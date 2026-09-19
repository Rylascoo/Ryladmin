import copy
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'runtime/foundation'))
from policy import (Rejected, admit, contract, digest, load_json, quota, normalize_usage,
                    account_usage, safe_path, save_checkpoint, restore_checkpoint, validate_result)
from writer import write_one, writer_lease


def observation(remaining=50, second=None):
    windows = [{'id': 'codex:primary', 'duration_minutes': 10080, 'remaining': remaining, 'reset_at': 2000}]
    if second is not None:
        windows.append({'id': 'codex:secondary', 'duration_minutes': 300, 'remaining': second, 'reset_at': 1100})
    return {'schema': 'ryladmin.usage.v1', 'observed_at': 1000, 'source': 'fixture-supported-interface/v1', 'windows': windows}


def select(remaining=50, previous='NORMAL', second=None, **kwargs):
    obs = observation(remaining, second)
    defaults = dict(now=1001, required_windows=[w['id'] for w in obs['windows']],
                    reservations={w['id']: 0 for w in obs['windows']}, task_cost=1, resume_checks=True)
    defaults.update(kwargs)
    return quota(obs, previous, **defaults)


def packet(root):
    task = dict(schema='ryladmin.task.v1', job_id='fixture-01', repository='Rylascoo/Ryladmin', head='a'*40,
                authority_ref='b'*40, authority_sha256='c'*64, input_sha256='d'*64, tool_sha256='e'*64,
                worktree=str(root), owner='coordinator', lease='Q-ADMIN-04/fixture', expires_at=2000,
                capability='ryladmin-repository-writer', role='repository-writer', objective='bounded fixture edit',
                required_tests=['fixture'], return_target='coordinator', validation_claim='DETERMINISTIC_ONLY',
                depth=0, deadline_seconds=60, token_budget=1000, cancellation_owner='coordinator',
                tools=['bounded-write'], write_paths=['tests/output.txt'], args=[], network=False, mcp=[], plugins=[])
    grant = {k: task[k] for k in ('repository','head','authority_ref','authority_sha256','input_sha256','tool_sha256','worktree','owner','lease','expires_at','capability','tools','write_paths')}
    grant.update(schema='ryladmin.grant.v1', status='ADMITTED', acceptance_ref='f'*40,
                 max_depth=1, max_jobs=1, max_seconds=60, max_tokens=1000)
    observed = {k: task[k] for k in ('head','authority_ref','authority_sha256','input_sha256','tool_sha256','worktree','owner','lease')}
    observed.update(now=1001, active_jobs=0, exclusive_writer=True, paused=False,
                    grant_sha256=digest(json.dumps(grant, sort_keys=True, separators=(',', ':')).encode()))
    return task, grant, observed


class QuotaTests(unittest.TestCase):
    def test_thresholds(self):
        for remaining, state in [(0,'WAITING_FOR_RESET'), (4.9,'CHECKPOINT_ONLY'), (5,'CHECKPOINT_ONLY'),
                                 (5.1,'LIGHT'), (9.9,'LIGHT'), (10,'LIGHT'), (10.1,'NORMAL')]:
            with self.subTest(remaining=remaining):
                result = select(remaining)
                self.assertEqual(state, result['state'])
                if remaining <= 10:
                    self.assertFalse(result['dispatch'])

    def test_light_one_small_task_only(self):
        self.assertTrue(select(9, small=True)['dispatch'])
        self.assertFalse(select(9, small=True, active_jobs=1)['dispatch'])
        self.assertFalse(select(9, small=False)['dispatch'])

    def test_hysteresis_all_windows(self):
        for remaining in (10.1, 15):
            self.assertEqual('LIGHT', select(remaining, 'LIGHT')['state'])
        self.assertEqual('NORMAL', select(15.1, 'LIGHT')['state'])
        self.assertEqual('LIGHT', select(90, 'LIGHT', second=10)['state'])
        self.assertEqual('LIGHT', select(90, 'LIGHT', resume_checks=False)['state'])

    def test_elapsed_reset_is_not_replenishment(self):
        obs = observation(0)
        obs['windows'][0]['reset_at'] = 900
        decision = quota(obs, 'WAITING_FOR_RESET', now=1001, required_windows=['codex:primary'],
                         reservations={'codex:primary': 0}, task_cost=1, resume_checks=True)
        self.assertEqual('WAITING_FOR_RESET', decision['state'])
        self.assertFalse(decision['dispatch'])

    def test_reservations_and_uncertainty(self):
        self.assertEqual('CHECKPOINT_ONLY', select(50, reservations={'codex:primary': 45})['state'])
        self.assertEqual('WAITING_FOR_RESET', select(50, reservations={'codex:primary': 50})['state'])
        self.assertFalse(select(50, task_cost=None)['dispatch'])
        self.assertEqual('LIGHT', select(50, task_cost=45)['state'])
        self.assertEqual('CHECKPOINT_ONLY', select(50, closeout_cost=50)['state'])

    def test_unknown_inputs(self):
        for overrides in ({'now':1301}, {'now':999}, {'required_windows':['missing']},
                          {'reservations':{}}, {'task_cost':float('nan')}, {'closeout_cost':-1},
                          {'active_jobs':True}):
            with self.subTest(overrides=overrides):
                self.assertEqual('USAGE_UNKNOWN', select(**overrides)['state'])
        self.assertEqual('USAGE_UNKNOWN', select(-1)['state'])
        self.assertEqual('USAGE_UNKNOWN', select(101)['state'])
        self.assertEqual('USAGE_UNKNOWN', select(previous='invented')['state'])

    def test_pause_overrides_replenishment(self):
        result = select(100, 'WAITING_FOR_RESET', paused=True)
        self.assertFalse(result['dispatch'])
        self.assertEqual('CHECKPOINT_ONLY', result['state'])

    def test_supported_normalization_deduplicates_legacy(self):
        bucket = {'limitId':'codex', 'primary':{'usedPercent':90,'windowDurationMins':10080,'resetsAt':2000}, 'secondary':None}
        raw = {'rateLimits':bucket, 'rateLimitsByLimitId':{'codex':bucket}, 'accountId':'private-fixture'}
        normalized = normalize_usage(raw, observed_at=1000, source='fixture', required_buckets=['codex'])
        self.assertEqual(1, len(normalized['windows']))
        self.assertEqual(10, normalized['windows'][0]['remaining'])
        self.assertNotIn('private', json.dumps(normalized))
        for change in ({'rateLimitsByLimitId':{}}, {'rateLimitsByLimitId':{'other':bucket}}):
            with self.assertRaises(Rejected):
                normalize_usage({**raw, **change}, observed_at=1000, source='fixture', required_buckets=['codex'])

    def test_disappearing_window(self):
        result = quota(observation(), 'NORMAL', now=1001, required_windows=['codex:primary','codex:secondary'],
                       reservations={'codex:primary':0,'codex:secondary':0}, task_cost=1)
        self.assertEqual('USAGE_UNKNOWN', result['state'])

    def test_usage_event_dedup(self):
        event = dict(schema='ryladmin.usage-event.v1', job_id='a', event_id='1', sequence=1, scope='job', tokens=10)
        newer = {**event, 'event_id':'2', 'sequence':2, 'tokens':20}
        self.assertEqual(20, account_usage([newer, event, newer]))
        self.assertEqual(30, account_usage([event, newer, {**event,'job_id':'b'}]))
        for bad in ({**event,'tokens':11}, {**newer,'scope':'aggregate'}, {**newer,'tokens':1}):
            with self.assertRaises(Rejected):
                account_usage([event,bad])


class WriterTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        base = Path(self.temp.name)
        self.root = base / 'worktree'
        (self.root / 'tests').mkdir(parents=True)
        self.state = base / 'control'
        self.state.mkdir()
        self.task, self.grant, self.observed = packet(self.root)
        self.target = self.root / 'tests/output.txt'

    def write(self, observe=None, relative='tests/output.txt', before=None):
        return write_one(self.task,self.grant,observe or (lambda:self.observed),select(),self.state,
                         relative,before,b'approved\n')

    def test_allowed_isolated_atomic_write(self):
        result = self.write()
        self.assertEqual(b'approved\n',self.target.read_bytes())
        self.assertEqual(digest(b'approved\n'),result['sha256'])
        self.assertEqual([],list(self.state.iterdir()))

    def test_negative_packets_do_not_reach_replace(self):
        changes = [('head','f'*40),('authority_ref','f'*40),('authority_sha256','f'*64),
                   ('input_sha256','f'*64),('tool_sha256','f'*64),('worktree',str(self.state)),
                   ('owner','foreign'),('lease','foreign'),('expires_at',900),('capability','unknown'),
                   ('depth',2),('deadline_seconds',61),('token_budget',1001),('network',True),
                   ('mcp',['unexpected']),('plugins',['unexpected']),('args',['--yolo']),
                   ('args',['--config','agents.enabled=true']),('tools',['shell']),
                   ('write_paths',['CURRENT_STATE.md']),('role','scout'),('role','reviewer'),
                   ('cancellation_owner','other')]
        original = copy.deepcopy(self.task)
        for field, value in changes:
            with self.subTest(field=field,value=value), patch('writer.os.replace') as dispatch:
                self.task = {**original,field:value}
                with self.assertRaises(Rejected): self.write()
                dispatch.assert_not_called()
                self.assertFalse(self.target.exists())
        self.task = original

    def test_observed_rejections_no_dispatch(self):
        for changes in ({'active_jobs':1},{'exclusive_writer':False},{'paused':True},
                        {'head':'f'*40},{'grant_sha256':'0'*64},{'now':2000}):
            with self.subTest(changes=changes), patch('writer.os.replace') as dispatch:
                with self.assertRaises(Rejected): self.write(lambda:{**self.observed,**changes})
                dispatch.assert_not_called()

    def test_unavailable_capabilities(self):
        for status in ('SUSPENDED','EXPERIMENTAL','NOT_ADMITTED'):
            self.grant['status'] = status
            with patch('writer.os.replace') as dispatch:
                with self.assertRaises(Rejected): self.write()
                dispatch.assert_not_called()

    def test_protected_paths_even_if_grant_requests_them(self):
        for path in ('runtime/current/config.toml','runtime/foundation/capabilities.json',
                     'runtime/foundation/state/grant.json','.git/config','../foreign.txt',
                     'tests/../../foreign.txt','tests/x:stream','tests/CON.txt',
                     'tests/alias.','tests//output.txt','C:/active-installation/config.toml'):
            with self.subTest(path=path), patch('writer.os.replace') as dispatch:
                task, grant, obs = packet(self.root)
                task['write_paths'] = grant['write_paths'] = [path]
                obs['grant_sha256'] = digest(json.dumps(grant,sort_keys=True,separators=(',',':')).encode())
                with self.assertRaises(Rejected):
                    write_one(task,grant,lambda:obs,select(),self.state,path,None,b'forbidden')
                dispatch.assert_not_called()

    def test_one_writer_per_worktree(self):
        with writer_lease(self.state,self.root,'first'):
            with self.assertRaises(FileExistsError): self.write()
        self.assertFalse(self.target.exists())

    def test_control_state_not_candidate_owned(self):
        with self.assertRaises(Rejected):
            with writer_lease(self.root,self.root,'first'): pass

    def test_authority_changed_before_atomic_step(self):
        with patch('writer.os.replace') as dispatch:
            observations = iter([self.observed,{**self.observed,'head':'f'*40}])
            with self.assertRaises(Rejected): self.write(lambda:next(observations))
            dispatch.assert_not_called()
        self.assertFalse(self.target.exists())
        self.assertEqual([],list((self.root/'tests').iterdir()))

    def test_changed_file_and_interrupted_write(self):
        self.target.write_bytes(b'old')
        with self.assertRaises(Rejected): self.write()
        with patch('writer.os.replace',side_effect=OSError('fixture interruption')):
            with self.assertRaises(OSError): self.write(before=digest(b'old'))
        self.assertEqual(b'old',self.target.read_bytes())
        self.assertEqual([self.target],list(self.target.parent.iterdir()))

    def test_hardlink_rejected(self):
        foreign = self.state/'foreign'
        foreign.write_bytes(b'preserve')
        os.link(foreign,self.target)
        with self.assertRaises(Rejected): self.write(before=digest(b'preserve'))
        self.assertEqual(b'preserve',foreign.read_bytes())

    def test_quota_rejection_no_write(self):
        for decision in (select(0),select(5),select(50,task_cost=None),select(paused=True)):
            with patch('writer.os.replace') as dispatch:
                with self.assertRaises(Rejected):
                    write_one(self.task,self.grant,lambda:self.observed,decision,self.state,'tests/output.txt',None,b'x')
                dispatch.assert_not_called()


class StateResultTests(unittest.TestCase):
    def test_result_validation_no_self_promotion(self):
        task, _, _ = packet(Path(tempfile.gettempdir())/'fixture')
        result = {k:task[k] for k in ('job_id','repository','head','authority_ref','input_sha256','owner')}
        result.update(schema='ryladmin.result.v1',status='RETURNED',summary='fixture',root_exit_code=0,
                      owned_survivors=0,changed_paths=['tests/output.txt'],tests=['fixture PASS'],
                      evidence=[{'path':'result.log','sha256':digest(b'log')}],token_usage=0,token_enforcement='UNAVAILABLE')
        self.assertEqual('VALIDATED_RETURN_NOT_ADMISSION',validate_result(result,task,{'result.log':b'log'}))
        for changes in ({'summary':''},{'summary':'   '},{'root_exit_code':None},{'owned_survivors':1},
                        {'job_id':'wrong'},{'evidence':[]},{'status':'ADMITTED'}, {'tests':[]},
                        {'changed_paths':['CURRENT_STATE.md']},{'token_usage':True}):
            with self.subTest(changes=changes), self.assertRaises(Rejected):
                validate_result({**result,**changes},task,{'result.log':b'log'})
        with self.assertRaises(Rejected): validate_result(result,task,{'result.log':b'changed'})

    def test_checkpoint_restart_and_interruption(self):
        value = dict(schema='ryladmin.checkpoint.v1',job_id='fixture',head='a'*40,owner='coordinator',
                     lease='Q-ADMIN-04',state='LIGHT',reason='reserve',next_operation='reconcile live authority',
                     paused=True,required_windows=['codex:primary'],reservations=[],partial_artifacts=[],
                     completed_tests=['fixture'],automatic_resume=False)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'checkpoint.json'
            save_checkpoint(path,value)
            self.assertEqual(value,restore_checkpoint(path))
            with patch('policy.os.replace',side_effect=OSError('interrupt')):
                with self.assertRaises(OSError): save_checkpoint(path,{**value,'state':'NORMAL'})
            self.assertEqual(value,restore_checkpoint(path))
            self.assertEqual([path],list(Path(directory).iterdir()))
            path.write_text('{"schema":"a","schema":"b"}',encoding='utf-8')
            with self.assertRaises(Rejected): load_json(path)

    def test_schema_rejects_unknown_fields(self):
        task,_,_ = packet(Path(tempfile.gettempdir())/'fixture')
        for value in ({**task,'permission_override':True}, {k:v for k,v in task.items() if k!='head'}):
            with self.assertRaises(Rejected): contract('task',value)

    def test_entry_rejects_unrestricted_arguments_without_launch(self):
        entry = Path(__file__).resolve().parents[1]/'runtime/foundation/entry.py'
        result = subprocess.run([sys.executable,str(entry),'--yolo'],capture_output=True,timeout=10)
        self.assertEqual(2,result.returncode)

    def test_entry_duplicate_options_rejected(self):
        entry = Path(__file__).resolve().parents[1]/'runtime/foundation/entry.py'
        result = subprocess.run([sys.executable,str(entry),'--check','--expected-head','a'*40,
                                 '--expected-head','b'*40],capture_output=True,timeout=10)
        self.assertEqual(2,result.returncode)
        self.assertIn(b'duplicate/conflicting',result.stderr)


if __name__ == '__main__': unittest.main()
