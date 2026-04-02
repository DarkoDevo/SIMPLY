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
ROTATION_FILE = ROOT / 'Rotations/Deathknight/Deathknight_Unholy.lua'


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


def existing_api_lane() -> str:
    content = ROTATION_FILE.read_text(encoding='utf-8')
    start = '-- PULSE_API_START: ACTION_CONST_DEATHKNIGHT_UNHOLY\n'
    end = '-- PULSE_API_END: ACTION_CONST_DEATHKNIGHT_UNHOLY'
    return content.split(start, 1)[1].split(end, 1)[0].strip()


def build_live_aura_lane(record: dict) -> str:
    guidance = record.get('api_guidance') or {}
    preferred = ', '.join(guidance.get('preferred_apis', [])) or 'none specified'
    avoid = ', '.join(guidance.get('avoid_apis', [])) or 'none specified'
    fallback = ' -> '.join(guidance.get('fallback_chain', [])) or 'none specified'
    return dedent(f'''
    -- Reviewed pulse helper adopted from: {record.get('record_id')}
    -- Preferred APIs: {preferred}
    -- Avoid APIs: {avoid}
    -- Fallback chain: {fallback}
    local pulseAuraState = pulseAuraState or {{}}

    local function PulseAPIUnitHasBuffSafe(unitID, buffKey, cacheKey, onlyOurs)
        if not unitID or not buffKey then
            return false, 'missing_unit_or_buff'
        end

        local unitObj = Unit(unitID)
        local stateKey = cacheKey or tostring(buffKey)
        pulseAuraState[unitID] = pulseAuraState[unitID] or {{}}

        if unitObj and unitObj.IsExists and unitObj:IsExists() then
            local isActive = false
            if type(buffKey) == 'table' then
                if type(unitObj.BuffFrom) == 'function' then
                    isActive = unitObj:BuffFrom(buffKey, onlyOurs) ~= nil
                elseif type(unitObj.IsBuffUp) == 'function' then
                    isActive = unitObj:IsBuffUp(buffKey, onlyOurs)
                end
            else
                if type(unitObj.HasBuff) == 'function' then
                    isActive = unitObj:HasBuff(buffKey, onlyOurs)
                elseif type(unitObj.IsBuffUp) == 'function' then
                    isActive = unitObj:IsBuffUp(buffKey, onlyOurs)
                end
            end

            if isActive then
                pulseAuraState[unitID][stateKey] = {{ active = true, seen_at = GetTime() }}
                return true, 'framework_unit_wrapper'
            end
        end

        local cached = pulseAuraState[unitID][stateKey]
        if cached and cached.active and (GetTime() - (cached.seen_at or 0)) <= 1.5 then
            return true, 'cached_arena_state'
        end

        return false, 'broad_safe_prediction'
    end
    ''').strip()


def build_adoption_pulse(record: dict, helper_rel: str, helper_content: str) -> dict:
    old1 = '''return Unit(unitID):IsBuffUp(Full_Immune_Buffs)
        or Unit(unitID):IsBuffUp(Phys_Immune_Buffs)
        or Unit(unitID):IsBuffUp(Magic_Immune_Buffs)
        or Unit(unitID):IsBuffUp(AMS_Bufftable)'''
    new1 = '''return select(1, PulseAPIUnitHasBuffSafe(unitID, Full_Immune_Buffs, "full_immune_buffs"))
        or select(1, PulseAPIUnitHasBuffSafe(unitID, Phys_Immune_Buffs, "phys_immune_buffs"))
        or select(1, PulseAPIUnitHasBuffSafe(unitID, Magic_Immune_Buffs, "magic_immune_buffs"))
        or select(1, PulseAPIUnitHasBuffSafe(unitID, AMS_Bufftable, "anti_magic_shell_buffs"))'''
    old2 = '''    if Unit(unitID):IsBuffUp(Full_Immune_Buffs) then
        return "enemy immunity is active"
    end

    if Unit(unitID):IsBuffUp(AMS_Bufftable) then
        return "anti-magic protection is active"
    end

    if Unit(unitID):IsBuffUp(Phys_Immune_Buffs) or Unit(unitID):IsBuffUp(Magic_Immune_Buffs) then
        return "enemy defensive wall is active"
    end'''
    new2 = '''    if select(1, PulseAPIUnitHasBuffSafe(unitID, Full_Immune_Buffs, "full_immune_buffs")) then
        return "enemy immunity is active"
    end

    if select(1, PulseAPIUnitHasBuffSafe(unitID, AMS_Bufftable, "anti_magic_shell_buffs")) then
        return "anti-magic protection is active"
    end

    if select(1, PulseAPIUnitHasBuffSafe(unitID, Phys_Immune_Buffs, "phys_immune_buffs"))
        or select(1, PulseAPIUnitHasBuffSafe(unitID, Magic_Immune_Buffs, "magic_immune_buffs")) then
        return "enemy defensive wall is active"
    end'''
    combined_lane = build_live_aura_lane(record) + '\n\n' + existing_api_lane()
    return {
        'pulse_id': f"007_adopt_{record['record_id']}",
        'summary': f"Adopt reviewed aura helper lane for {record.get('title', record['record_id'])}.",
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
                'content': combined_lane,
            },
            {
                'type': 'replace_text',
                'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
                'find_text': old1,
                'replace_text': new1,
            },
            {
                'type': 'replace_text',
                'file': 'Rotations/Deathknight/Deathknight_Unholy.lua',
                'find_text': old2,
                'replace_text': new2,
            },
        ],
        'promoted_from': {
            'record_id': record['record_id'],
            'generated_helper': helper_rel,
            'adoption_mode': 'reviewed_aura_helper_lane',
        }
    }


def main() -> int:
    parser = argparse.ArgumentParser(description='Promote a generated aura helper draft into a reviewed adoption pulse.')
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
