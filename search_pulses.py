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
    parser = argparse.ArgumentParser(description='Search pulse library records by free text.')
    parser.add_argument('query')
    args = parser.parse_args()
    query = args.query.lower()

    matches = []
    for record in load_records():
        haystack = json.dumps(record, ensure_ascii=False).lower()
        if query in haystack:
            matches.append(record)

    if not matches:
        print('No matching library records found.')
        return 0

    for record in matches:
        print(f"=== {record['record_id']} ===")
        print(f"Title: {record.get('title','')}")
        print(f"Kind: {record.get('kind','')}")
        print(f"Scope: {record.get('scope','')}")
        print(f"Actionability: {record.get('actionability','')}")
        print(f"Summary: {record.get('summary','')}")
        if record.get('details'):
            print(f"Details: {record['details']}")
        print(f"Path: {record['_path']}")
        print()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
