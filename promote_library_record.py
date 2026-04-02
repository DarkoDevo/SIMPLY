#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
LIBRARY_ROOT = ROOT / 'PulseSystem/library'
DRAFT_ROOT = ROOT / 'PulseSystem/drafts'
INBOX_ROOT = ROOT / 'PulseSystem/pulse_inbox'


def load_record(record_id: str) -> tuple[dict[str, Any], Path]:
    for path in LIBRARY_ROOT.rglob('*.json'):
        if 'indexes' in path.parts:
            continue
        try:
            data = json.loads(path.read_text(encoding='utf-8'))
        except Exception:
            continue
        if isinstance(data, dict) and data.get('record_id') == record_id:
            return data, path
    raise SystemExit(f'Library record not found: {record_id}')


def infer_scope(record: dict[str, Any]) -> str:
    scope = str(record.get('scope') or 'general').lower()
    if 'deathknight_unholy' in scope or 'unholy' in scope:
        return 'deathknight_unholy'
    return scope or 'general'


def infer_operation_stubs(record: dict[str, Any]) -> list[dict[str, Any]]:
    target_hint = str(record.get('target_hint') or '').lower()
    actionability = str(record.get('actionability') or '')
    title = str(record.get('title') or '').lower()
    stubs: list[dict[str, Any]] = []

    if 'api_change' == str(record.get('kind') or ''):
        guidance = record.get('api_guidance') or {}
        preferred = guidance.get('preferred_apis') or []
        avoid = guidance.get('avoid_apis') or []
        fallback = guidance.get('fallback_chain') or []
        stubs.append({
            'type': 'write_file',
            'file': f"PulseSystem/drafts/generated_api_guidance__{record['record_id']}.json",
            'content': json.dumps({
                'record_id': record['record_id'],
                'scope': infer_scope(record),
                'preferred_apis': preferred,
                'avoid_apis': avoid,
                'fallback_chain': fallback,
                'notes': record.get('details', ''),
            }, indent=2) + '\n',
            'note': 'Use this generated guidance draft as the source for helper or lint updates.',
        })
        stubs.append({
            'type': 'write_file',
            'file': f"PulseSystem/drafts/generated_api_helper__{record['record_id']}.lua",
            'content': '-- TODO: convert this promoted API record into a reviewed helper wrapper before wiring it into the live rotation.\n',
            'note': 'This draft should become a helper wrapper lane that follows the preferred APIs and fallback chain.',
        })
        stubs.append({
            'type': 'replace_between_markers',
            'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
            'start_marker': 'PULSE_API_START: ACTION_CONST_DEATHKNIGHT_UNHOLY',
            'end_marker': 'PULSE_API_END: ACTION_CONST_DEATHKNIGHT_UNHOLY',
            'content': '-- TODO: implement or update API fallback helpers for this promoted record\n',
            'note': 'Prefer helper wrappers and ordered fallback chains rather than raw API reads in rotation code.',
        })

    if 'dk_unholy_ui' in target_hint or actionability == 'ui_visible':
        stubs.append({
            'type': 'replace_between_markers',
            'file': 'Rotations/Deathknight/#Deathknight_Interface.lua',
            'start_marker': 'PULSE_UI_START: ACTION_CONST_DEATHKNIGHT_UNHOLY',
            'end_marker': 'PULSE_UI_END: ACTION_CONST_DEATHKNIGHT_UNHOLY',
            'content': '-- TODO: add pulse-managed UI controls for this promoted record\n',
            'note': 'Merge these controls into the current pulse-managed UI block instead of replacing it blindly.',
        })

    if 'dk_unholy_rotation' in target_hint or 'rotation' in target_hint or 'awareness' in title or 'kill_window' in str(record.get('tags', [])):
        stubs.append({
            'type': 'replace_between_markers',
            'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
            'start_marker': 'PULSE_RULES_START: ACTION_CONST_DEATHKNIGHT_UNHOLY_HELPERS',
            'end_marker': 'PULSE_RULES_END: ACTION_CONST_DEATHKNIGHT_UNHOLY_HELPERS',
            'content': '-- TODO: add or extend helper functions for this promoted record\n',
            'note': 'Usually this record wants helper functions, runtime state, or message helpers.',
        })
        stubs.append({
            'type': 'replace_between_markers',
            'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
            'start_marker': 'PULSE_HOLDS_START: ACTION_CONST_DEATHKNIGHT_UNHOLY_COOLDOWNS',
            'end_marker': 'PULSE_HOLDS_END: ACTION_CONST_DEATHKNIGHT_UNHOLY_COOLDOWNS',
            'content': '-- TODO: wire the promoted helper into the cooldown lane\n',
            'note': 'Use this when the record affects burst-hold, send-now, or awareness timing.',
        })

    if not stubs:
        stubs.append({
            'type': 'write_file',
            'file': 'PulseSystem/pending/manual_review.txt',
            'content': 'TODO: manually implement promoted record after reviewing target files.\n',
            'note': 'Fallback stub when no better target hint exists.',
        })

    return stubs


def build_draft(record: dict[str, Any], library_path: Path) -> dict[str, Any]:
    summary = record.get('recommended_pulse') or record.get('summary') or record.get('title') or record['record_id']
    return {
        'pulse_id': f"draft_{record['record_id']}",
        'draft_status': 'requires_editing',
        'spec': infer_scope(record),
        'summary': summary,
        'promoted_from': {
            'record_id': record['record_id'],
            'library_path': str(library_path.relative_to(ROOT)),
            'title': record.get('title', ''),
            'kind': record.get('kind', ''),
            'scope': record.get('scope', ''),
            'actionability': record.get('actionability', ''),
        },
        'implementation_notes': [
            record.get('summary', ''),
            record.get('details', ''),
            f"Target hint: {record.get('target_hint', '')}".strip(),
        ],
        'operations': infer_operation_stubs(record),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description='Promote a library record into a draft pulse.')
    parser.add_argument('record_id', help='Library record_id to promote')
    parser.add_argument('--destination', choices=['drafts', 'inbox'], default='drafts')
    parser.add_argument('--force', action='store_true', help='Overwrite an existing draft if present')
    args = parser.parse_args()

    record, library_path = load_record(args.record_id)
    draft = build_draft(record, library_path)
    out_root = DRAFT_ROOT if args.destination == 'drafts' else INBOX_ROOT
    out_root.mkdir(parents=True, exist_ok=True)
    out_path = out_root / f"{draft['pulse_id']}.json"

    if out_path.exists() and not args.force:
        raise SystemExit(f'Draft already exists: {out_path}. Re-run with --force to overwrite.')

    out_path.write_text(json.dumps(draft, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({
        'record_id': record['record_id'],
        'draft_pulse_id': draft['pulse_id'],
        'destination': str(out_path.relative_to(ROOT)),
        'status': draft['draft_status'],
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
