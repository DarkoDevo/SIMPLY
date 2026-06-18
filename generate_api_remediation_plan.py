#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
LINT_PATH = ROOT / 'PulseSystem/generated/api_usage_lint_report.json'
GUIDANCE_PATH = ROOT / 'PulseSystem/generated/api_guidance_index.json'
OUT_JSON = ROOT / 'PulseSystem/generated/api_remediation_plan.json'
OUT_MD = ROOT / 'PulseSystem/generated/api_remediation_plan.md'
DRAFT_ROOT = ROOT / 'PulseSystem/drafts'


def load_json(path: Path) -> Any:
    if not path.exists():
        raise SystemExit(f'Missing required file: {path}. Run the prerequisite generators first.')
    return json.loads(path.read_text(encoding='utf-8'))


def build_guidance_map(records: list[dict]) -> dict[str, dict]:
    return {r['record_id']: r for r in records}


def recommendation_for(finding: dict, guidance: dict) -> tuple[str, str]:
    preferred = guidance.get('preferred_apis') or []
    fallback = guidance.get('fallback_chain') or []
    cls = finding.get('classification')
    if cls == 'direct_call':
        return (
            'replace_call',
            f"Replace direct `{finding['term']}` usage with a helper or wrapper that prefers {', '.join(preferred) or 'approved framework helpers'} and follows fallback chain: {' -> '.join(fallback) or 'none provided'}."
        )
    if cls == 'alias_declaration':
        return (
            'monitor_only',
            'Alias-only declaration. Keep under waiver unless later direct calls appear; remove dead aliases during framework cleanup when safe.'
        )
    if cls == 'symbol_reference':
        return (
            'monitor_only',
            f"Symbol reference only. Monitor unless it turns into a direct call. Prefer {', '.join(preferred) or 'an approved helper'} when refactoring nearby code."
        )
    return ('manual_review', 'Review this occurrence manually.')


def emit_draft(remediation_items: list[dict]) -> list[str]:
    DRAFT_ROOT.mkdir(parents=True, exist_ok=True)
    created: list[str] = []
    for idx, item in enumerate(remediation_items, 1):
        if item['action'] == 'monitor_only':
            continue
        pulse_id = f"draft_api_remediation_{idx:03d}_{item['term'].lower()}_{item['file'].replace('/', '_').replace('.lua', '')}"
        draft = {
            'pulse_id': pulse_id,
            'draft_status': 'requires_editing',
            'spec': item.get('scope', 'general'),
            'summary': f"API remediation for {item['term']} in {item['file']} line {item['line']}",
            'promoted_from_lint': item,
            'operations': [
                {
                    'type': 'manual_patch_review',
                    'file': item['file'],
                    'line': item['line'],
                    'term': item['term'],
                    'recommended_action': item['action'],
                    'note': item['recommendation'],
                }
            ],
        }
        out = DRAFT_ROOT / f'{pulse_id}.json'
        out.write_text(json.dumps(draft, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
        created.append(str(out.relative_to(ROOT)))
    return created


def main() -> int:
    parser = argparse.ArgumentParser(description='Turn API lint results into a remediation plan and optional draft pulses.')
    parser.add_argument('--emit-drafts', action='store_true', help='Emit remediation draft pulses for actionable findings')
    args = parser.parse_args()

    lint = load_json(LINT_PATH)
    guidance_index = load_json(GUIDANCE_PATH)
    guidance_map = build_guidance_map(guidance_index.get('records', []))

    remediation_items = []
    for finding in lint.get('avoid_api_findings', []):
        guidance = guidance_map.get(finding['record_id'], {})
        action, recommendation = recommendation_for(finding, guidance)
        remediation_items.append({
            **finding,
            'scope': lint.get('scope', 'general'),
            'preferred_apis': guidance.get('preferred_apis', []),
            'fallback_chain': guidance.get('fallback_chain', []),
            'action': action,
            'recommendation': recommendation,
        })

    drafts = emit_draft(remediation_items) if args.emit_drafts else []

    payload = {
        'scope': lint.get('scope', 'general'),
        'actionable_findings': [x for x in remediation_items if x['action'] != 'monitor_only'],
        'monitor_only_findings': [x for x in remediation_items if x['action'] == 'monitor_only'],
        'drafts_created': drafts,
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

    lines = ['# API Remediation Plan', '', f"Scope: `{payload['scope']}`", '']
    if payload['actionable_findings']:
        lines += ['## Actionable findings', '']
        for item in payload['actionable_findings']:
            lines += [
                f"### {item['term']} in {item['file']}:{item['line']}",
                '',
                f"- classification: `{item['classification']}`",
                f"- action: `{item['action']}`",
                f"- line: `{item['line_text']}`",
                f"- preferred_apis: {', '.join(f'`{x}`' for x in item['preferred_apis']) or 'none listed'}",
                f"- fallback_chain: {' -> '.join(f'`{x}`' for x in item['fallback_chain']) or 'none listed'}",
                '',
                item['recommendation'],
                ''
            ]
    if payload['monitor_only_findings']:
        lines += ['## Monitor-only findings', '']
        for item in payload['monitor_only_findings']:
            lines.append(f"- `{item['term']}` in `{item['file']}:{item['line']}`: {item['recommendation']}")
        lines.append('')
    if drafts:
        lines += ['## Drafts created', ''] + [f'- `{d}`' for d in drafts] + ['']
    OUT_MD.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
    print(json.dumps({
        'actionable': len(payload['actionable_findings']),
        'monitor_only': len(payload['monitor_only_findings']),
        'drafts_created': len(drafts),
        'json': str(OUT_JSON.relative_to(ROOT)),
        'markdown': str(OUT_MD.relative_to(ROOT)),
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
