#!/usr/bin/env python3
from __future__ import annotations
import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
INBOX = ROOT / 'PulseSystem/pulse_inbox'
PROCESSED = set()


def main() -> int:
    INBOX.mkdir(parents=True, exist_ok=True)
    print(f'Watching {INBOX}')
    while True:
        for pulse_file in sorted(INBOX.glob('*.json')):
            if pulse_file in PROCESSED:
                continue
            subprocess.run(['python', str(ROOT / 'PulseSystem/scripts/process_pulse.py'), str(pulse_file)], check=False)
            PROCESSED.add(pulse_file)
        time.sleep(2)


if __name__ == '__main__':
    raise SystemExit(main())
