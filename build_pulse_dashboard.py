#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def count_json_files(path: Path) -> int:
    return len(list(path.rglob('*.json'))) if path.exists() else 0


def main() -> int:
    pulse_history = ROOT / 'PulseSystem/pulse_history'
    library = ROOT / 'PulseSystem/library'
    drafts = ROOT / 'PulseSystem/drafts'
    backups = ROOT / 'PulseSystem/backups'
    adopted = ROOT / 'PulseSystem/adopted_helpers'
    generated = ROOT / 'PulseSystem/generated'

    dashboard = {
        'history_count': len([p for p in pulse_history.iterdir() if p.is_dir()]) if pulse_history.exists() else 0,
        'library_record_count': count_json_files(library) - count_json_files(library / 'indexes'),
        'draft_count': count_json_files(drafts),
        'backup_count': len(list(backups.glob('*.zip'))) if backups.exists() else 0,
        'adopted_helper_count': len([p for p in adopted.glob('*.lua')]) if adopted.exists() else 0,
        'generated_helper_count': len([p for p in (generated / 'helpers').glob('*.lua')]) if (generated / 'helpers').exists() else 0,
        'latest_pulses': sorted([p.name for p in pulse_history.iterdir() if p.is_dir()], reverse=True)[:10] if pulse_history.exists() else [],
        'library_breakdown': {},
    }

    if library.exists():
        for child in sorted(library.iterdir()):
            if child.is_dir() and child.name != 'indexes':
                dashboard['library_breakdown'][child.name] = count_json_files(child)

    out_json = generated / 'pulse_dashboard.json'
    out_md = generated / 'pulse_dashboard.md'
    out_json.write_text(json.dumps(dashboard, indent=2), encoding='utf-8')

    lines = [
        '# Pulse Dashboard',
        '',
        f"- Pulse history entries: {dashboard['history_count']}",
        f"- Library records: {dashboard['library_record_count']}",
        f"- Drafts: {dashboard['draft_count']}",
        f"- Backups: {dashboard['backup_count']}",
        f"- Adopted helpers: {dashboard['adopted_helper_count']}",
        f"- Generated helpers: {dashboard['generated_helper_count']}",
        '',
        '## Library breakdown',
    ]
    for key, value in dashboard['library_breakdown'].items():
        lines.append(f'- {key}: {value}')
    lines += ['', '## Latest pulses']
    for pulse_id in dashboard['latest_pulses']:
        lines.append(f'- {pulse_id}')
    out_md.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(json.dumps(dashboard, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
