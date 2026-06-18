#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path
import shutil


def main() -> int:
    parser = argparse.ArgumentParser(description='Restore the before-snapshots for a given pulse ID.')
    parser.add_argument('pulse_id')
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[2]
    manifest_path = root / 'PulseSystem/pulse_history' / args.pulse_id / 'manifest.json'
    if not manifest_path.exists():
        raise SystemExit(f'Could not find manifest for pulse {args.pulse_id}')

    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    before_dir = root / 'PulseSystem/pulse_history' / args.pulse_id / 'before'
    restored = []
    for rel_str in manifest['files_touched']:
        rel = Path(rel_str)
        src = before_dir / rel
        dst = root / rel
        if src.exists():
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)
            restored.append(rel_str)

    print(json.dumps({'pulse_id': args.pulse_id, 'restored_files': restored}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
