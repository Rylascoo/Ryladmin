"""Single-file deterministic candidate writer, not a sandbox for arbitrary code.

Only a trusted coordinator may supply observations/grants. No CLI exposes these
functions to model workers. Live integration is disabled in entry.py. Exclusive
ownership is cooperative here; OS isolation is a separate, unearned admission.
"""
from contextlib import contextmanager
import json
import os
from pathlib import Path
import tempfile
from policy import admit, digest, require, safe_path, writable


@contextmanager
def writer_lease(state_root, worktree, owner):
    """State root is coordinator-owned, outside every candidate writable surface."""
    state_root = Path(state_root).resolve(strict=True)
    worktree = Path(worktree).resolve(strict=True)
    require(not state_root.is_relative_to(worktree), 'candidate owns lease state')
    lock = state_root / (digest(os.path.normcase(str(worktree)).encode()) + '.lock')
    # Never break a lock based on time or process-name guesses.
    with lock.open('x', encoding='utf-8') as stream:
        stream.write(json.dumps({'owner': owner, 'worktree': str(worktree)}))
        stream.flush()
        os.fsync(stream.fileno())
    try:
        yield
    finally:
        lock.unlink()


def write_one(task, grant, observe, quota_decision, state_root, relative, before_sha256, content):
    require(type(content) is bytes and len(content) <= 1024 * 1024, 'bounded bytes required')
    with writer_lease(state_root, task['worktree'], task['owner']):
        admit(task, grant, observe(), quota_decision)
        require(relative in task['write_paths'], 'path outside task')
        writable(relative)
        target = safe_path(task['worktree'], relative)
        require(target.parent.is_dir(), 'parent must already exist')
        old = digest(target.read_bytes()) if target.exists() else None
        require(old == before_sha256, 'changed input file')
        fd, pending = tempfile.mkstemp(prefix='.foundation-', dir=target.parent)
        try:
            with os.fdopen(fd, 'wb') as stream:
                stream.write(content)
                stream.flush()
                os.fsync(stream.fileno())
            # Re-read authority and paths immediately before the atomic single-file step.
            admit(task, grant, observe(), quota_decision)
            require(safe_path(task['worktree'], relative) == target, 'path changed')
            require((digest(target.read_bytes()) if target.exists() else None) == old, 'input raced')
            os.replace(pending, target)
        finally:
            if os.path.exists(pending):
                os.unlink(pending)
    return {'path': relative, 'sha256': digest(content), 'bytes': len(content)}
