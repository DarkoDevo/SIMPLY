#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def main() -> int:
    profile = json.loads((ROOT / 'AutoBundle/Profiles/DeathKnight.json').read_text(encoding='utf-8'))
    runtime = {
        'profile': profile.get('name', 'unknown'),
        'files': profile.get('files', []),
        'shared_modules': [],
        'ui_toggles_detected': [],
    }

    shared_path = ROOT / 'Rotations/Deathknight/Deathknight_PulseApi.lua'
    if shared_path.exists():
        runtime['shared_modules'].append({
            'name': 'Deathknight_PulseApi',
            'path': 'Rotations/Deathknight/Deathknight_PulseApi.lua',
        })

    ui_text = (ROOT / 'Rotations/Deathknight/#Deathknight_Interface.lua').read_text(encoding='utf-8')
    for db in ['HoldMajorBurstIntoWalls', 'HoldMajorBurstEnemyHP', 'PulseExplainBurstHolds', 'PulseBurstHoldMessageThrottle', 'PulseShowKillWindowSoon', 'PulseKillWindowSoonEnemyHP', 'PulseKillWindowSoonMessageThrottle']:
        if db in ui_text:
            runtime['ui_toggles_detected'].append(db)

    out = ROOT / 'PulseSystem/generated/pulse_runtime_registry.json'
    out.write_text(json.dumps(runtime, indent=2), encoding='utf-8')
    print(json.dumps(runtime, indent=2))
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
