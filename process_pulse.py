#!/usr/bin/env python3
from __future__ import annotations
import argparse
import datetime as dt
import difflib
import json
import os
from pathlib import Path
import shutil
import sys
import zipfile


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def utc_stamp() -> str:
    return dt.datetime.now(dt.timezone.utc).strftime('%Y%m%dT%H%M%SZ')


def read_text(path: Path) -> str:
    return path.read_text(encoding='utf-8')


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding='utf-8')


def ensure_relative(path_str: str) -> Path:
    p = Path(path_str)
    if p.is_absolute():
        raise ValueError(f'Pulse file paths must be repo-relative, got absolute path: {path_str}')
    return p


def apply_replace_between_markers(original: str, start_marker: str, end_marker: str, content: str) -> str:
    start_token = f'-- {start_marker}'
    end_token = f'-- {end_marker}'
    start = original.find(start_token)
    end = original.find(end_token)
    if start == -1 or end == -1 or end < start:
        raise ValueError(f'Could not find valid marker pair: {start_marker} / {end_marker}')
    start_line_end = original.find('\n', start)
    if start_line_end == -1:
        raise ValueError(f'Start marker line is malformed for {start_marker}')
    replacement = content.rstrip() + '\n' if content.strip() else ''
    return original[: start_line_end + 1] + replacement + original[end:]



def apply_replace_text(original: str, find_text: str, replace_text: str, count: int | None = 1) -> str:
    occurrences = original.count(find_text)
    if occurrences == 0:
        raise ValueError('Exact replace_text needle was not found')
    if count is None:
        return original.replace(find_text, replace_text)
    return original.replace(find_text, replace_text, count)



def apply_operation(root: Path, op: dict) -> tuple[str, Path]:
    op_type = op['type']
    rel_path = ensure_relative(op['file'])
    abs_path = root / rel_path

    if op_type == 'write_file':
        content = op['content']
        write_text(abs_path, content)
        return op_type, abs_path

    original = read_text(abs_path)
    updated = original

    if op_type == 'replace_between_markers':
        updated = apply_replace_between_markers(
            original,
            op['start_marker'],
            op['end_marker'],
            op.get('content', ''),
        )
    elif op_type == 'replace_text':
        updated = apply_replace_text(
            original,
            op['find_text'],
            op['replace_text'],
            op.get('count', 1),
        )
    else:
        raise ValueError(f'Unsupported operation type: {op_type}')

    if updated != original:
        write_text(abs_path, updated)
    return op_type, abs_path



def zip_backup(root: Path, files: list[Path], out_zip: Path) -> None:
    out_zip.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out_zip, 'w', compression=zipfile.ZIP_DEFLATED) as zf:
        for rel in files:
            abs_path = root / rel
            if abs_path.exists():
                zf.write(abs_path, arcname=str(rel))



def normalized_pulse(raw: dict, default_id: str) -> dict:
    pulse_id = raw.get('pulse_id') or default_id
    operations = raw.get('operations', [])
    if not operations:
        raise ValueError('Pulse has no operations')
    return {
        'pulse_id': pulse_id,
        'summary': raw.get('summary', ''),
        'spec': raw.get('spec', ''),
        'operations': operations,
    }



def main() -> int:
    parser = argparse.ArgumentParser(description='Apply one SIMPLY pulse file safely.')
    parser.add_argument('pulse_file', help='Path to pulse JSON file')
    parser.add_argument('--dry-run', action='store_true', help='Validate and preview pulse without writing files')
    parser.add_argument('--allow-reapply', action='store_true', help='Allow re-applying a pulse_id that already has history')
    args = parser.parse_args()

    root = repo_root()
    pulse_path = Path(args.pulse_file).resolve()
    if not pulse_path.exists():
        raise SystemExit(f'Pulse file not found: {pulse_path}')

    raw = json.loads(pulse_path.read_text(encoding='utf-8'))
    stamp = utc_stamp()
    pulse = normalized_pulse(raw, default_id=stamp)
    pulse_id = pulse['pulse_id']

    existing_history = root / 'PulseSystem/pulse_history' / pulse_id
    if existing_history.exists() and not args.allow_reapply:
        raise SystemExit(f'Pulse {pulse_id} already exists in history. Use --allow-reapply to override this guard.')

    pulse_archive_raw = root / 'PulseSystem/pulse_archive/raw' / f'{pulse_id}.json'
    pulse_archive_normalized = root / 'PulseSystem/pulse_archive/normalized' / f'{pulse_id}.json'
    pulse_history = root / 'PulseSystem/pulse_history' / pulse_id
    before_dir = pulse_history / 'before'
    after_dir = pulse_history / 'after'
    diff_dir = pulse_history / 'diffs'
    backup_zip = root / 'PulseSystem/backups' / f'{pulse_id}_before.zip'

    if args.dry_run:
        preview = {'pulse_id': pulse_id, 'summary': pulse.get('summary', ''), 'files_touched': [str(p) for p in files_touched], 'operation_count': len(pulse['operations'])}
        print(json.dumps(preview, indent=2))
        return 0

    pulse_archive_raw.parent.mkdir(parents=True, exist_ok=True)
    pulse_archive_normalized.parent.mkdir(parents=True, exist_ok=True)
    before_dir.mkdir(parents=True, exist_ok=True)
    after_dir.mkdir(parents=True, exist_ok=True)
    diff_dir.mkdir(parents=True, exist_ok=True)

    files_touched = []
    seen = set()
    for op in pulse['operations']:
        rel = ensure_relative(op['file'])
        if rel not in seen:
            files_touched.append(rel)
            seen.add(rel)

    zip_backup(root, files_touched, backup_zip)
    pulse_archive_raw.write_text(json.dumps(raw, indent=2), encoding='utf-8')
    pulse_archive_normalized.write_text(json.dumps(pulse, indent=2), encoding='utf-8')

    for rel in files_touched:
        src = root / rel
        if src.exists():
            dst = before_dir / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)

    applied = []
    for op in pulse['operations']:
        op_type, abs_path = apply_operation(root, op)
        applied.append({'type': op_type, 'file': str(abs_path.relative_to(root))})

    combined_diff_parts = []
    for rel in files_touched:
        before = before_dir / rel
        after = root / rel
        if after.exists():
            dst = after_dir / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(after, dst)
        before_text = read_text(before) if before.exists() else ''
        after_text = read_text(after) if after.exists() else ''
        diff_text = ''.join(
            difflib.unified_diff(
                before_text.splitlines(keepends=True),
                after_text.splitlines(keepends=True),
                fromfile=f'a/{rel}',
                tofile=f'b/{rel}',
            )
        )
        (diff_dir / f"{str(rel).replace('/', '__')}.diff").write_text(diff_text, encoding='utf-8')
        combined_diff_parts.append(diff_text)

    (pulse_history / 'combined.diff').write_text('\n'.join(combined_diff_parts), encoding='utf-8')
    manifest = {
        'pulse_id': pulse_id,
        'summary': pulse.get('summary', ''),
        'spec': pulse.get('spec', ''),
        'backup_zip': str(backup_zip.relative_to(root)),
        'files_touched': [str(p) for p in files_touched],
        'operations_applied': applied,
    }
    (pulse_history / 'manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')

    summary_lines = [
        f'# Pulse {pulse_id}',
        '',
        f"Summary: {pulse.get('summary', '').strip() or 'No summary provided.'}",
        '',
        'Files touched:',
    ]
    for rel in files_touched:
        summary_lines.append(f'- {rel}')
    summary_lines += ['', 'Operations applied:']
    for item in applied:
        summary_lines.append(f"- {item['type']}: {item['file']}")
    (pulse_history / 'summary.md').write_text('\n'.join(summary_lines) + '\n', encoding='utf-8')

    print(json.dumps({'pulse_id': pulse_id, 'files_touched': manifest['files_touched']}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
