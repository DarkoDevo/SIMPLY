#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]
GUIDANCE_PATH = ROOT / 'PulseSystem/generated/api_guidance_index.json'
WAIVERS_PATH = ROOT / 'PulseSystem/config/api_usage_waivers.json'
DEFAULT_GLOBS = ['Rotations/**/*.lua', 'MakuluFramework/**/*.lua']


def load_guidance(scope: str) -> list[dict]:
    if not GUIDANCE_PATH.exists():
        raise SystemExit('Compile guidance first: python PulseSystem/scripts/compile_api_guidance.py')
    data = json.loads(GUIDANCE_PATH.read_text(encoding='utf-8'))
    records = data.get('records', [])
    if scope:
        records = [r for r in records if scope.lower() in str(r.get('scope', '')).lower()]
    return records


def load_waivers() -> dict[str, Any]:
    if not WAIVERS_PATH.exists():
        return {'exact_lines': [], 'path_contains': []}
    return json.loads(WAIVERS_PATH.read_text(encoding='utf-8'))


def iter_files() -> list[Path]:
    files: list[Path] = []
    for pattern in DEFAULT_GLOBS:
        files.extend(ROOT.glob(pattern))
    return sorted(set(p for p in files if p.is_file()))


def compile_pattern(term: str) -> re.Pattern[str]:
    return re.compile(rf'(?<![A-Za-z0-9_]){re.escape(term)}(?![A-Za-z0-9_])')


def classify_line(line: str, term: str, rel_path: str) -> tuple[str, str]:
    stripped = line.strip()
    if not stripped:
        return 'ignored_blank', 'blank line'
    if stripped.startswith('--'):
        return 'ignored_comment', 'comment-only line'
    alias_pattern = re.compile(rf'^local\s+{re.escape(term)}\s*=\s*{re.escape(term)}\s*$')
    if alias_pattern.match(stripped):
        return 'alias_declaration', 'legacy alias declaration only'
    if 'PulseSystem/adopted_helpers/' in rel_path or 'PulseSystem/generated/helpers/' in rel_path or rel_path.endswith('Deathknight_PulseApi.lua'):
        if re.search(rf'\b{re.escape(term)}\s*\(', stripped):
            return 'reviewed_helper_call', 'reviewed helper lane retains the fallback call intentionally'
        if re.search(rf'\b{re.escape(term)}\b', stripped):
            return 'reviewed_helper_reference', 'reviewed helper lane references the avoided API as a guarded fallback'
    if re.search(rf'\b{re.escape(term)}\s*\(', stripped):
        return 'direct_call', 'direct API invocation'
    if re.search(rf'\b{re.escape(term)}\b', stripped):
        return 'symbol_reference', 'symbol reference without direct call'
    return 'ignored_non_exact', 'not an exact symbol match'


def is_waived(rel_path: str, line_no: int, term: str, waivers: dict[str, Any]) -> str | None:
    for entry in waivers.get('exact_lines', []):
        if entry.get('file') == rel_path and int(entry.get('line', -1)) == line_no and entry.get('term') == term:
            return entry.get('reason', 'exact line waiver')
    for entry in waivers.get('path_contains', []):
        if entry.get('term') == term and entry.get('substring') and entry['substring'] in rel_path:
            return entry.get('reason', 'path waiver')
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description='Scan repo files for APIs marked as avoid/preferred by the pulse library.')
    parser.add_argument('--scope', default='deathknight_unholy', help='Optional scope filter')
    args = parser.parse_args()

    records = load_guidance(args.scope)
    waivers = load_waivers()
    avoid_terms: list[tuple[str, str, str]] = []
    preferred_terms = set()
    for rec in records:
        for term in rec.get('avoid_apis', []):
            avoid_terms.append((term, rec['record_id'], rec['title']))
        for term in rec.get('preferred_apis', []):
            preferred_terms.add(term)

    findings = []
    suppressed = []
    ignored = []
    for path in iter_files():
        rel_path = str(path.relative_to(ROOT))
        lines = path.read_text(encoding='utf-8', errors='ignore').splitlines()
        for term, record_id, title in avoid_terms:
            pattern = compile_pattern(term)
            for line_no, line in enumerate(lines, 1):
                if not pattern.search(line):
                    continue
                classification, why = classify_line(line, term, rel_path)
                waiver_reason = is_waived(rel_path, line_no, term, waivers)
                item = {
                    'file': rel_path,
                    'line': line_no,
                    'term': term,
                    'record_id': record_id,
                    'title': title,
                    'classification': classification,
                    'line_text': line.strip(),
                    'why': why,
                }
                if waiver_reason:
                    item['waiver_reason'] = waiver_reason
                    suppressed.append(item)
                elif classification.startswith('ignored_'):
                    ignored.append(item)
                else:
                    if classification in ('reviewed_helper_call', 'reviewed_helper_reference', 'alias_declaration'):
                        item['severity'] = 'low'
                        suppressed.append(item)
                    else:
                        item['severity'] = 'high' if classification == 'direct_call' else 'medium'
                        findings.append(item)

    report = {
        'scope': args.scope,
        'records_considered': len(records),
        'preferred_apis_seen_in_guidance': sorted(preferred_terms),
        'avoid_api_findings': findings,
        'suppressed_findings': suppressed,
        'ignored_matches': ignored,
    }
    out = ROOT / 'PulseSystem/generated/api_usage_lint_report.json'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({
        'findings': len(findings),
        'suppressed': len(suppressed),
        'ignored': len(ignored),
        'report': str(out.relative_to(ROOT)),
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
