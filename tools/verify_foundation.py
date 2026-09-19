"""Offline repository integrity/configuration gate, Python 3.12+ standard library."""
import ast
import hashlib
import json
from pathlib import Path
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'runtime/foundation'))
from policy import contract, load_json, require


def verify_manifest(root, manifest, actual, *, lf_only=False):
    require(set(actual) == set(manifest), 'manifest file set mismatch')
    for relative, expected in manifest.items():
        content = (root / relative).read_bytes()
        require(not lf_only or b'\r' not in content, 'candidate text must use canonical LF: ' + relative)
        require(hashlib.sha256(content).hexdigest().lower() == expected['sha256'].lower(), 'hash drift: ' + relative)
        require(len(content) == expected['bytes'], 'length drift: ' + relative)


def candidate_paths(root):
    files = [*root.glob('runtime/foundation/**/*.py'), *root.glob('runtime/foundation/schemas/*.json'),
             root/'runtime/foundation/capabilities.json', *root.glob('tests/*.py'),
             root/'tools/verify_foundation.py', root/'.github/workflows/foundation.yml']
    return sorted(p.relative_to(root).as_posix() for p in files)


def verify(root=ROOT):
    current = root / 'runtime/current'
    manifest = load_json(root / 'runtime/CURRENT_SOURCE_MANIFEST.json')
    actual = [p.relative_to(current).as_posix() for p in current.rglob('*') if p.is_file()]
    verify_manifest(current, manifest['files'], actual)
    foundation = load_json(root / 'runtime/foundation/source-manifest.json')
    verify_manifest(root, foundation['files'], candidate_paths(root), lf_only=True)
    forbidden = {'auth.json','sessions','scratch','browser','plugins','.sandbox','.sandbox-secrets','installation_id'}
    for surface in (current, root/'runtime/foundation'):
        for path in surface.rglob('*'):
            require(path.name.lower() not in forbidden and '.sqlite' not in path.name.lower(), 'private-state path')
            require(not path.is_symlink(), 'source symlink')
    for path in current.rglob('*.toml'):
        with path.open('rb') as stream: tomllib.load(stream)
    for path in [*root.glob('runtime/foundation/**/*.py'),*root.glob('tests/*.py'),root/'tools/verify_foundation.py']:
        ast.parse(path.read_text(encoding='utf-8'),filename=str(path))
    capabilities = load_json(root / 'runtime/foundation/capabilities.json')
    contract('capabilities', capabilities)
    require(not any(c['status']=='ADMITTED' for c in capabilities['capabilities']), 'candidate self-admission')
    require(len({c['name'] for c in capabilities['capabilities']})==len(capabilities['capabilities']), 'duplicate capability')
    print(json.dumps({'source_integrity':'PASS','toml_parse':'PASS','python_parse':'PASS',
                      'private_state_exclusion':'PASS','live_dispatch':False},sort_keys=True))


if __name__ == '__main__': verify()
