#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
LINT = ROOT / 'PulseSystem/generated/api_remediation_plan.json'


def main() -> int:
    data = json.loads(LINT.read_text(encoding='utf-8'))
    actionable = data.get('actionable_findings', [])
    framework_items = [item for item in actionable if item['file'].startswith('MakuluFramework/')]
    out_json = ROOT / 'PulseSystem/generated/framework_followup_backlog.json'
    out_md = ROOT / 'PulseSystem/generated/framework_followup_backlog.md'
    payload = {
        'count': len(framework_items),
        'items': framework_items,
        'summary': 'Framework-level follow-up items that should be migrated carefully instead of patched impulsively inside live combat code.',
    }
    out_json.write_text(json.dumps(payload, indent=2), encoding='utf-8')
    lines = [
        '# Framework Follow-up Backlog',
        '',
        payload['summary'],
        '',
        f"- Count: {payload['count']}",
        '',
    ]
    for item in framework_items:
        lines += [
            f"## {item['term']} in {item['file']}:{item['line']}",
            '',
            f"- classification: `{item['classification']}`",
            f"- line: `{item['line_text']}`",
            f"- recommendation: {item['recommendation']}",
            '',
        ]
    out_md.write_text('\n'.join(lines), encoding='utf-8')
    print(json.dumps({'count': len(framework_items), 'json': str(out_json.relative_to(ROOT)), 'markdown': str(out_md.relative_to(ROOT))}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
