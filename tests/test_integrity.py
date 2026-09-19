import copy
import hashlib
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from verify_foundation import verify_manifest
from policy import Rejected


class IntegrityTests(unittest.TestCase):
    def test_matching_working_copy_hash_cannot_hide_crlf_drift(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            content=b'candidate\r\n'
            (root/'a').write_bytes(content)
            manifest={'a':{'sha256':hashlib.sha256(content).hexdigest(),'bytes':len(content)}}
            with self.assertRaises(Rejected): verify_manifest(root,manifest,['a'],lf_only=True)

    def test_missing_extra_or_changed_source_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            (root/'a').write_bytes(b'known')
            manifest={'a':{'sha256':hashlib.sha256(b'known').hexdigest(),'bytes':5}}
            verify_manifest(root,manifest,['a'])
            for actual in ([],['a','extra']):
                with self.assertRaises(Rejected): verify_manifest(root,manifest,actual)
            (root/'a').write_bytes(b'drift')
            with self.assertRaises(Rejected): verify_manifest(root,manifest,['a'])


if __name__=='__main__': unittest.main()
