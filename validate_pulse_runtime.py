#!/usr/bin/env python3
from __future__ import annotations
import json
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
REQUIRED_FILES = ['PulseSystem/README.md','PulseSystem/config/pulse_targets.json','Rotations/Deathknight/#Deathknight_Interface.lua','Rotations/Deathknight/Deathknight_Unholy.lua','Rotations/Deathknight/Deathknight_PulseApi.lua']
REQUIRED_MARKERS = {
 'Rotations/Deathknight/#Deathknight_Interface.lua': ['-- PULSE_UI_START: ACTION_CONST_DEATHKNIGHT_UNHOLY','-- PULSE_UI_END: ACTION_CONST_DEATHKNIGHT_UNHOLY'],
 'Rotations/Deathknight/Deathknight_Unholy.lua': ['-- PULSE_RULES_START: ACTION_CONST_DEATHKNIGHT_UNHOLY_HELPERS','-- PULSE_RULES_END: ACTION_CONST_DEATHKNIGHT_UNHOLY_HELPERS','-- PULSE_HOLDS_START: ACTION_CONST_DEATHKNIGHT_UNHOLY_COOLDOWNS','-- PULSE_HOLDS_END: ACTION_CONST_DEATHKNIGHT_UNHOLY_COOLDOWNS','-- PULSE_API_START: ACTION_CONST_DEATHKNIGHT_UNHOLY','-- PULSE_API_END: ACTION_CONST_DEATHKNIGHT_UNHOLY']}
def main() -> int:
 results={'missing_files':[],'missing_markers':[],'profile_checks':{},'status':'ok'}
 for rel in REQUIRED_FILES:
  if not (ROOT/rel).exists(): results['missing_files'].append(rel)
 for rel, markers in REQUIRED_MARKERS.items():
  path=ROOT/rel
  if not path.exists(): continue
  text=path.read_text(encoding='utf-8')
  for marker in markers:
   if marker not in text: results['missing_markers'].append({'file':rel,'marker':marker})
 profile_path=ROOT/'AutoBundle/Profiles/DeathKnight.json'
 if profile_path.exists():
  profile=json.loads(profile_path.read_text(encoding='utf-8'))
  paths=[item.get('path') for item in profile.get('files',[])]
  results['profile_checks']={'includes_shared_helper_file':'./Deathknight/Deathknight_PulseApi.lua' in paths,'shared_helper_precedes_unholy': paths.index('./Deathknight/Deathknight_PulseApi.lua') < paths.index('./Deathknight/Deathknight_Unholy.lua') if './Deathknight/Deathknight_PulseApi.lua' in paths and './Deathknight/Deathknight_Unholy.lua' in paths else False}
 if results['missing_files'] or results['missing_markers'] or not all(results['profile_checks'].values()): results['status']='needs_attention'
 out=ROOT/'PulseSystem/generated/pulse_runtime_validation.json'; out.parent.mkdir(parents=True, exist_ok=True); out.write_text(json.dumps(results, indent=2), encoding='utf-8'); print(json.dumps(results, indent=2)); return 0 if results['status']=='ok' else 1
if __name__=='__main__': raise SystemExit(main())
