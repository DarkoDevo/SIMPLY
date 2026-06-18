#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LIBRARY_ROOT = ROOT / 'PulseSystem/library'


def load_records() -> list[dict]:
    records = []
    for path in sorted(LIBRARY_ROOT.rglob('*.json')):
        if 'indexes' in path.parts:
            continue
        try:
            data = json.loads(path.read_text(encoding='utf-8'))
        except Exception:
            continue
        if isinstance(data, dict) and data.get('record_id'):
            data['_path'] = str(path.relative_to(ROOT))
            records.append(data)
    return records


def main() -> int:
    parser = argparse.ArgumentParser(description='List pulse library records.')
    parser.add_argument('--kind', help='Optional kind filter')
    parser.add_argument('--scope', help='Optional scope filter')
    args = parser.parse_args()

    records = load_records()
    if args.kind:
        records = [r for r in records if r.get('kind') == args.kind]
    if args.scope:
        records = [r for r in records if args.scope.lower() in str(r.get('scope', '')).lower()]

    lines = []
    for record in records:
        lines.append(f"- {record['record_id']} | {record.get('kind','')} | {record.get('scope','')} | {record.get('title','')} | {record['_path']}")
    print('\n'.join(lines) if lines else 'No matching library records found.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
