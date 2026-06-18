#!/usr/bin/env python3
from __future__ import annotations
import argparse
import datetime as dt
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
LIBRARY_ROOT = ROOT / 'PulseSystem/library'

CATEGORY_DIRS = {
    'api_change': 'api_changes',
    'rotation_suggestion': 'rotation_suggestions',
    'framework_note': 'framework_notes',
    'observation': 'observations',
    'legacy_import': 'imported_legacy',
}


def slugify(value: str) -> str:
    value = value.strip().lower()
    value = re.sub(r'[^a-z0-9]+', '_', value)
    return value.strip('_') or 'item'


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')


def ensure_category(kind: str) -> str:
    return CATEGORY_DIRS.get(kind, 'imported_legacy')


def classify_kind(raw_kind: str | None, text: str) -> str:
    if raw_kind:
        raw_kind = raw_kind.strip().lower()
        mapping = {
            'api': 'api_change',
            'api_change': 'api_change',
            'suggestion': 'rotation_suggestion',
            'rotation_suggestion': 'rotation_suggestion',
            'framework': 'framework_note',
            'framework_note': 'framework_note',
            'observation': 'observation',
            'legacy': 'legacy_import',
            'legacy_import': 'legacy_import',
        }
        if raw_kind in mapping:
            return mapping[raw_kind]
    lowered = text.lower()
    if 'api' in lowered or 'protected' in lowered or 'secret value' in lowered:
        return 'api_change'
    if 'makulu' in lowered or 'tmw' in lowered or 'framework' in lowered:
        return 'framework_note'
    if 'bug' in lowered or 'error' in lowered or 'unreliable' in lowered or 'taint' in lowered:
        return 'observation'
    return 'rotation_suggestion'


def infer_actionability(entry: dict[str, Any]) -> str:
    explicit = entry.get('actionability')
    if explicit:
        return explicit
    lowered = json.dumps(entry, ensure_ascii=False).lower()
    if 'deprecated' in lowered:
        return 'deprecated'
    if 'warning' in lowered or 'unsafe' in lowered or 'avoid' in lowered:
        return 'warning'
    if 'ui' in lowered or 'message' in lowered or 'hint' in lowered:
        return 'ui_visible'
    if 'apply' in lowered or 'replace' in lowered or 'hold' in lowered or 'logic' in lowered:
        return 'code_applicable'
    return 'informational'


def normalize_entry(entry: dict[str, Any], source_name: str, ordinal: int) -> dict[str, Any]:
    title = entry.get('title') or entry.get('name') or f'Imported note {ordinal}'
    body_text = entry.get('details') or entry.get('body') or entry.get('summary') or entry.get('text') or ''
    kind = classify_kind(entry.get('kind'), f'{title}\n{body_text}')
    record_id = entry.get('record_id') or f"legacy_{slugify(source_name)}_{ordinal:03d}_{slugify(title)[:48]}"
    scope = entry.get('scope') or entry.get('spec') or entry.get('target') or 'general'
    tags = entry.get('tags') or []
    if isinstance(tags, str):
        tags = [t.strip() for t in tags.split(',') if t.strip()]
    links = entry.get('links') or []
    if isinstance(links, str):
        links = [links]
    preferred_apis = entry.get('preferred_apis') or entry.get('preferred_api') or []
    if isinstance(preferred_apis, str):
        preferred_apis = [v.strip() for v in preferred_apis.split(',') if v.strip()]
    avoid_apis = entry.get('avoid_apis') or entry.get('avoid_api') or []
    if isinstance(avoid_apis, str):
        avoid_apis = [v.strip() for v in avoid_apis.split(',') if v.strip()]
    fallback_chain = entry.get('fallback_chain') or []
    if isinstance(fallback_chain, str):
        fallback_chain = [v.strip() for v in re.split(r'\s*(?:>|,|;)\s*', fallback_chain) if v.strip()]
    return {
        'record_id': record_id,
        'title': title,
        'kind': kind,
        'scope': scope,
        'summary': entry.get('summary') or body_text or title,
        'details': body_text,
        'source': {
            'type': entry.get('source_type') or 'legacy_import',
            'name': source_name,
            'imported_at_utc': utc_now(),
        },
        'actionability': infer_actionability(entry),
        'tags': tags,
        'links': links,
        'target_hint': entry.get('target_hint') or entry.get('target') or '',
        'recommended_pulse': entry.get('recommended_pulse') or '',
        'status': entry.get('status') or 'active',
        'api_guidance': {
            'preferred_apis': preferred_apis,
            'avoid_apis': avoid_apis,
            'fallback_chain': fallback_chain,
        } if kind == 'api_change' else {},
    }


def parse_json_source(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text(encoding='utf-8'))
    if isinstance(data, dict):
        if isinstance(data.get('records'), list):
            return data['records']
        return [data]
    if isinstance(data, list):
        return data
    raise ValueError('JSON legacy source must be an object, a records object, or a list')


def parse_text_source(path: Path) -> list[dict[str, Any]]:
    text = path.read_text(encoding='utf-8')
    blocks = [b.strip() for b in re.split(r'\n\s*---+\s*\n', text) if b.strip()]
    records: list[dict[str, Any]] = []
    for block in blocks:
        lines = [line.rstrip() for line in block.splitlines() if line.strip()]
        record: dict[str, Any] = {}
        detail_lines: list[str] = []
        for line in lines:
            if ':' in line and re.match(r'^[A-Za-z_ ]{2,30}:', line):
                key, value = line.split(':', 1)
                key = key.strip().lower().replace(' ', '_')
                value = value.strip()
                if key in {'tags', 'links'}:
                    record[key] = [v.strip() for v in value.split(',') if v.strip()]
                else:
                    record[key] = value
            else:
                detail_lines.append(line)
        if detail_lines and 'details' not in record:
            record['details'] = '\n'.join(detail_lines)
        if not record.get('title'):
            first = lines[0] if lines else f'Imported note {len(records)+1}'
            record['title'] = first[:120]
        records.append(record)
    return records


def load_entries(path: Path) -> list[dict[str, Any]]:
    if path.suffix.lower() == '.json':
        return parse_json_source(path)
    return parse_text_source(path)


def main() -> int:
    parser = argparse.ArgumentParser(description='Import legacy API notes and suggestions into the pulse library.')
    parser.add_argument('source_file', help='Path to JSON or text source file')
    parser.add_argument('--also-copy-to-inbox', action='store_true', help='Also export normalized records to PulseSystem/pulse_inbox as library pulses')
    args = parser.parse_args()

    src = Path(args.source_file).resolve()
    if not src.exists():
        raise SystemExit(f'Source file not found: {src}')

    entries = load_entries(src)
    imported: list[dict[str, Any]] = []
    source_name = src.stem

    for i, entry in enumerate(entries, start=1):
        record = normalize_entry(entry, source_name=source_name, ordinal=i)
        category_dir = LIBRARY_ROOT / ensure_category(record['kind'])
        category_dir.mkdir(parents=True, exist_ok=True)
        out_path = category_dir / f"{record['record_id']}.json"
        out_path.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
        imported.append({'record_id': record['record_id'], 'kind': record['kind'], 'path': str(out_path.relative_to(ROOT))})

        if args.also_copy_to_inbox:
            inbox_payload = {
                'pulse_id': f"library_{record['record_id']}",
                'spec': record['scope'],
                'summary': f"Library record imported: {record['title']}",
                'operations': []
            }
            inbox_path = ROOT / 'PulseSystem/pulse_inbox' / f"library_{record['record_id']}.json"
            inbox_path.parent.mkdir(parents=True, exist_ok=True)
            inbox_path.write_text(json.dumps(inbox_payload, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

    index_path = LIBRARY_ROOT / 'indexes' / 'legacy_import_index.json'
    previous = []
    if index_path.exists():
        previous = json.loads(index_path.read_text(encoding='utf-8')).get('imports', [])
    index_path.write_text(json.dumps({'imports': previous + imported}, indent=2) + '\n', encoding='utf-8')

    print(json.dumps({'source': str(src), 'imported_count': len(imported), 'records': imported}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
