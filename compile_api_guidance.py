#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LIBRARY_ROOT = ROOT / 'PulseSystem/library/api_changes'
OUT_JSON = ROOT / 'PulseSystem/generated/api_guidance_index.json'
OUT_MD = ROOT / 'PulseSystem/generated/api_guidance_index.md'


def main() -> int:
    parser = argparse.ArgumentParser(description='Compile API guidance records into one searchable guidance index.')
    parser.add_argument('--scope', default='', help='Optional scope filter, e.g. deathknight_unholy')
    args = parser.parse_args()

    records = []
    for path in sorted(LIBRARY_ROOT.glob('*.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        if args.scope and args.scope.lower() not in str(data.get('scope', '')).lower():
            continue
        guidance = data.get('api_guidance') or {}
        records.append({
            'record_id': data.get('record_id'),
            'title': data.get('title'),
            'scope': data.get('scope'),
            'summary': data.get('summary'),
            'details': data.get('details'),
            'preferred_apis': guidance.get('preferred_apis', []),
            'avoid_apis': guidance.get('avoid_apis', []),
            'fallback_chain': guidance.get('fallback_chain', []),
            'tags': data.get('tags', []),
            'source_path': str(path.relative_to(ROOT)),
        })

    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps({'records': records}, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

    lines = ['# API Guidance Index', '']
    if args.scope:
        lines += [f'Scope filter: `{args.scope}`', '']
    for rec in records:
        lines += [f"## {rec['title']}", '', f"- record_id: `{rec['record_id']}`", f"- scope: `{rec['scope']}`"]
        if rec['preferred_apis']:
            lines.append(f"- preferred_apis: {', '.join(f'`{x}`' for x in rec['preferred_apis'])}")
        if rec['avoid_apis']:
            lines.append(f"- avoid_apis: {', '.join(f'`{x}`' for x in rec['avoid_apis'])}")
        if rec['fallback_chain']:
            lines.append(f"- fallback_chain: {' -> '.join(f'`{x}`' for x in rec['fallback_chain'])}")
        lines += ['', rec.get('summary', ''), '', rec.get('details', ''), '']
    OUT_MD.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
    print(json.dumps({'compiled_records': len(records), 'json': str(OUT_JSON.relative_to(ROOT)), 'markdown': str(OUT_MD.relative_to(ROOT))}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
