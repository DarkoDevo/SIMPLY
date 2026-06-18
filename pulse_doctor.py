#!/usr/bin/env python3
from __future__ import annotations
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = ROOT / 'PulseSystem/scripts'


def run(script: str, *args: str) -> dict:
    cmd = [sys.executable, str(SCRIPTS / script), *args]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    return {
        'script': script,
        'returncode': proc.returncode,
        'stdout': proc.stdout.strip(),
        'stderr': proc.stderr.strip(),
    }


def main() -> int:
    results = [
        run('validate_pulse_runtime.py'),
        run('compile_api_guidance.py'),
        run('lint_api_usage.py'),
        run('generate_api_remediation_plan.py'),
        run('generate_api_helper_drafts.py'),
        run('build_pulse_dashboard.py'),
        run('build_runtime_registry.py'),
        run('build_framework_followup_backlog.py'),
    ]
    status = 'ok' if all(item['returncode'] == 0 for item in results) else 'needs_attention'
    report = {
        'status': status,
        'steps': results,
    }
    out_json = ROOT / 'PulseSystem/generated/pulse_doctor_report.json'
    out_md = ROOT / 'PulseSystem/generated/pulse_doctor_report.md'
    out_json.write_text(json.dumps(report, indent=2), encoding='utf-8')
    lines = ['# Pulse Doctor Report', '', f'- Overall status: {status}', '', '## Steps']
    for item in results:
        lines.append(f"- {item['script']}: returncode={item['returncode']}")
    out_md.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))
    return 0 if status == 'ok' else 1


if __name__ == '__main__':
    raise SystemExit(main())
