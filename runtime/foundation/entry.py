"""Read-only Ryladmin candidate entry. Deliberately has no live launch operation."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
from policy import Rejected, contract, digest, load_json, require


def git(root, *args):
    return subprocess.run(['git', '-c', 'safe.directory=' + str(root), '-C', str(root), *args],
                          check=True, capture_output=True, text=True, timeout=10).stdout.strip()


def check(root, expected_head, expected_tool_hash, tool):
    root = Path(root).resolve(strict=True)
    require(Path(git(root, 'rev-parse', '--show-toplevel')).resolve() == root, 'wrong root')
    require(git(root, 'remote', 'get-url', 'origin').removesuffix('.git').rstrip('/') ==
            'https://github.com/Rylascoo/Ryladmin', 'wrong origin')
    require(git(root, 'rev-parse', 'HEAD') == expected_head, 'stale HEAD')
    require(git(root, 'branch', '--show-current') not in ('', 'main'), 'isolated branch required')
    require(not git(root, 'status', '--porcelain=v1', '--untracked-files=all'), 'dirty candidate')
    require(not (root / '.codex').exists(), 'unadmitted local config')
    require(tool.is_file() and digest(tool.read_bytes()) == expected_tool_hash, 'tool missing/hash drift')
    capabilities = load_json(Path(__file__).with_name('capabilities.json'))
    contract('capabilities', capabilities)
    require(capabilities['live_dispatch'] is False, 'candidate cannot self-admit')
    return {'status': 'SOURCE_PREFLIGHT_ONLY', 'head': expected_head,
            'live_dispatch': False, 'reason': 'containment, metering and independent admission pending'}


def main():
    parser = argparse.ArgumentParser(allow_abbrev=False)
    parser.add_argument('--check', action='store_true', required=True)
    parser.add_argument('--worktree', required=True)
    parser.add_argument('--expected-head', required=True)
    parser.add_argument('--tool', type=Path, required=True)
    parser.add_argument('--tool-sha256', required=True)
    flags = [arg.split('=', 1)[0] for arg in sys.argv[1:] if arg.startswith('--')]
    if len(flags) != len(set(flags)):
        parser.error('duplicate/conflicting options')
    args = parser.parse_args()
    try:
        print(json.dumps(check(args.worktree, args.expected_head, args.tool_sha256, args.tool), sort_keys=True))
    except (Rejected, OSError, subprocess.SubprocessError) as error:
        print(json.dumps({'status': 'REJECTED', 'reason': str(error), 'live_dispatch': False}))
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main())
