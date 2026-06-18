#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path
from textwrap import dedent

ROOT = Path(__file__).resolve().parents[2]
LIB_ROOT = ROOT / 'PulseSystem/library/api_changes'
GEN_HELPER_ROOT = ROOT / 'PulseSystem/generated/helpers'
DRAFT_ROOT = ROOT / 'PulseSystem/drafts'
INBOX_ROOT = ROOT / 'PulseSystem/pulse_inbox'


def load_record(record_id: str) -> tuple[dict, Path]:
    for path in LIB_ROOT.glob('*.json'):
        data = json.loads(path.read_text(encoding='utf-8'))
        if data.get('record_id') == record_id:
            return data, path
    raise SystemExit(f'Could not find API library record: {record_id}')


def helper_path_for(record_id: str) -> Path:
    helper_path = GEN_HELPER_ROOT / f'{record_id}.lua'
    if not helper_path.exists():
        raise SystemExit(f'Generated helper draft not found: {helper_path}')
    return helper_path


def build_live_cooldown_lane(record: dict) -> str:
    guidance = record.get('api_guidance') or {}
    preferred = ', '.join(guidance.get('preferred_apis', [])) or 'none specified'
    avoid = ', '.join(guidance.get('avoid_apis', [])) or 'none specified'
    fallback = ' -> '.join(guidance.get('fallback_chain', [])) or 'none specified'
    return dedent(f'''
    -- Reviewed pulse helper adopted from: {record.get('record_id')}
    -- Preferred APIs: {preferred}
    -- Avoid APIs: {avoid}
    -- Fallback chain: {fallback}
    local pulseApiState = pulseApiState or {{}}

    local function PulseAPIGetCooldownSafe(spell, cacheKey)
        if not spell then
            return nil, 'missing_spell'
        end

        local spellKey = cacheKey or tostring(spell.ID or spell)

        if type(spell.GetCooldown) == 'function' then
            local ok, value = pcall(spell.GetCooldown, spell)
            if ok and type(value) == 'number' then
                pulseApiState[spellKey] = value
                return value, 'spell:GetCooldown()'
            end
        end

        if type(A) == 'table' and type(A.GetSpellCooldown) == 'function' and spell.ID then
            local ok, value = pcall(A.GetSpellCooldown, spell.ID)
            if ok and type(value) == 'number' then
                pulseApiState[spellKey] = value
                return value, 'A.GetSpellCooldown'
            end
        end

        if pulseApiState[spellKey] ~= nil then
            return pulseApiState[spellKey], 'cached_last_known_cooldown'
        end

        return nil, 'broad_safe_prediction'
    end
    ''').strip() + '\n'


def build_adoption_pulse(record: dict, helper_rel: str, helper_content: str) -> dict:
    content = build_live_cooldown_lane(record)
    old = '''local apocalypseSoon = (not A.Apocalypse:IsTalentLearned()) or (A.Apocalypse:GetCooldown() <= readySoonWindow)
    local gargoyleSoon = (not A.SummonGargoyle:IsTalentLearned()) or (A.SummonGargoyle:GetCooldown() <= readySoonWindow)
    local assaultSoon = (not A.UnholyAssault:IsTalentLearned()) or (A.UnholyAssault:GetCooldown() <= readySoonWindow)
    return apocalypseSoon and gargoyleSoon and assaultSoon'''
    new = '''local apocalypseCD = select(1, PulseAPIGetCooldownSafe(A.Apocalypse, "Apocalypse"))
    local gargoyleCD = select(1, PulseAPIGetCooldownSafe(A.SummonGargoyle, "SummonGargoyle"))
    local assaultCD = select(1, PulseAPIGetCooldownSafe(A.UnholyAssault, "UnholyAssault"))
    local apocalypseSoon = (not A.Apocalypse:IsTalentLearned()) or ((apocalypseCD or 999) <= readySoonWindow)
    local gargoyleSoon = (not A.SummonGargoyle:IsTalentLearned()) or ((gargoyleCD or 999) <= readySoonWindow)
    local assaultSoon = (not A.UnholyAssault:IsTalentLearned()) or ((assaultCD or 999) <= readySoonWindow)
    return apocalypseSoon and gargoyleSoon and assaultSoon'''
    return {
        'pulse_id': f"006_adopt_{record['record_id']}",
        'summary': f"Adopt reviewed API helper lane for {record.get('title', record['record_id'])}.",
        'spec': record.get('scope', 'deathknight_unholy'),
        'operations': [
            {
                'type': 'write_file',
                'file': f'PulseSystem/adopted_helpers/{record["record_id"]}.lua',
                'content': helper_content,
            },
            {
                'type': 'replace_between_markers',
                'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
                'start_marker': 'PULSE_API_START: ACTION_CONST_DEATHKNIGHT_UNHOLY',
                'end_marker': 'PULSE_API_END: ACTION_CONST_DEATHKNIGHT_UNHOLY',
                'content': content,
            },
            {
                'type': 'replace_text',
                'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
                'find_text': old,
                'replace_text': new,
            },
        ],
        'promoted_from': {
            'record_id': record['record_id'],
            'generated_helper': helper_rel,
            'adoption_mode': 'reviewed_helper_lane',
        }
    }


def main() -> int:
    parser = argparse.ArgumentParser(description='Promote a generated API helper draft into a reviewed adoption pulse.')
    parser.add_argument('record_id')
    parser.add_argument('--destination', choices=['drafts', 'inbox'], default='drafts')
    parser.add_argument('--force', action='store_true')
    args = parser.parse_args()

    record, _ = load_record(args.record_id)
    helper_path = helper_path_for(args.record_id)
    helper_content = helper_path.read_text(encoding='utf-8')
    pulse = build_adoption_pulse(record, str(helper_path.relative_to(ROOT)), helper_content)
    out_root = DRAFT_ROOT if args.destination == 'drafts' else INBOX_ROOT
    out_root.mkdir(parents=True, exist_ok=True)
    out_path = out_root / f"{pulse['pulse_id']}.json"
    if out_path.exists() and not args.force:
        raise SystemExit(f'Draft already exists: {out_path}. Re-run with --force to overwrite.')
    out_path.write_text(json.dumps(pulse, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({
        'record_id': args.record_id,
        'draft_pulse_id': pulse['pulse_id'],
        'destination': str(out_path.relative_to(ROOT)),
        'generated_helper': str(helper_path.relative_to(ROOT)),
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
