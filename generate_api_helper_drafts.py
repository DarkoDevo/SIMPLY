#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path
from textwrap import dedent

ROOT = Path(__file__).resolve().parents[2]
LIBRARY_ROOT = ROOT / 'PulseSystem/library/api_changes'
HELPER_DIR = ROOT / 'PulseSystem/generated/helpers'
OUT_JSON = ROOT / 'PulseSystem/generated/api_helper_drafts.json'
OUT_MD = ROOT / 'PulseSystem/generated/api_helper_drafts.md'


def safe_name(value: str) -> str:
    return ''.join(ch if ch.isalnum() else '_' for ch in value).strip('_').lower()


def infer_helper_family(record: dict) -> str:
    title = str(record.get('title', '')).lower()
    tags = ' '.join(record.get('tags', []))
    blob = f"{title} {tags} {record.get('details', '')}".lower()
    if 'cooldown' in blob:
        return 'cooldown'
    if 'aura' in blob or 'buff' in blob or 'debuff' in blob:
        return 'aura'
    return 'generic'


def lua_header(record: dict) -> str:
    return dedent(
        f'''
        -- Auto-generated helper draft from pulse library
        -- record_id: {record.get("record_id")}
        -- title: {record.get("title")}
        -- scope: {record.get("scope")}
        -- summary: {record.get("summary")}
        -- NOTE: this file is a draft helper lane and is not wired into the live rotation automatically.
        '''
    ).strip() + '\n\n'


def render_cooldown_helper(record: dict) -> str:
    guidance = record.get('api_guidance') or {}
    preferred = guidance.get('preferred_apis', [])
    avoid = guidance.get('avoid_apis', [])
    fallback = guidance.get('fallback_chain', [])
    preferred_comment = ', '.join(preferred) if preferred else 'none specified'
    avoid_comment = ', '.join(avoid) if avoid else 'none specified'
    fallback_comment = ' -> '.join(fallback) if fallback else 'none specified'
    return lua_header(record) + dedent(
        f'''
        -- Preferred APIs: {preferred_comment}
        -- Avoid APIs: {avoid_comment}
        -- Fallback chain: {fallback_comment}

        local PulseAPI = PulseAPI or {{}}

        function PulseAPI.GetCooldownSafe(spell, cacheKey, state)
            if not spell then
                return nil, 'missing_spell'
            end

            -- Lane 1: framework helper wrappers should go here first.
            if type(A) == 'table' and type(A.GetSpellCooldown) == 'function' then
                local ok, value = pcall(A.GetSpellCooldown, spell)
                if ok and value ~= nil then
                    return value, 'A.GetSpellCooldown'
                end
            end

            -- Lane 2: project-specific safe toggles or wrappers.
            if type(Action) == 'table' and type(Action.GetToggle) == 'function' and cacheKey then
                local ok, value = pcall(Action.GetToggle, 1, cacheKey)
                if ok and value ~= nil then
                    return value, 'Action.GetToggle'
                end
            end

            -- Lane 3: cached state if the safe helpers drift or disappear.
            if type(state) == 'table' and cacheKey and state[cacheKey] ~= nil then
                return state[cacheKey], 'cached_last_known_cooldown'
            end

            -- Lane 4: broad-safe prediction fallback for degraded environments.
            return nil, 'broad_safe_prediction'
        end
        '''
    ).lstrip()


def render_aura_helper(record: dict) -> str:
    guidance = record.get('api_guidance') or {}
    preferred = guidance.get('preferred_apis', [])
    avoid = guidance.get('avoid_apis', [])
    fallback = guidance.get('fallback_chain', [])
    preferred_comment = ', '.join(preferred) if preferred else 'none specified'
    avoid_comment = ', '.join(avoid) if avoid else 'none specified'
    fallback_comment = ' -> '.join(fallback) if fallback else 'none specified'
    return lua_header(record) + dedent(
        f'''
        -- Preferred APIs: {preferred_comment}
        -- Avoid APIs: {avoid_comment}
        -- Fallback chain: {fallback_comment}

        local PulseAPI = PulseAPI or {{}}

        function PulseAPI.UnitHasBuffSafe(unitID, auraName, cacheState)
            if not unitID or not auraName then
                return false, 'missing_unit_or_aura'
            end

            -- Lane 1: framework wrappers first.
            if type(A_Unit) == 'function' then
                local ok, unitObj = pcall(A_Unit, unitID)
                if ok and unitObj and type(unitObj.HasBuffs) == 'function' then
                    local hit = unitObj:HasBuffs(auraName, true)
                    if hit and hit > 0 then
                        return true, 'A_Unit(unitID):HasBuffs'
                    end
                end
            end

            -- Lane 2: cached state maintained elsewhere by safe scans.
            if type(cacheState) == 'table' and type(cacheState[unitID]) == 'table' and cacheState[unitID][auraName] then
                return true, 'cached_arena_state'
            end

            -- Lane 3: broad-safe prediction fallback.
            return false, 'broad_safe_prediction'
        end
        '''
    ).lstrip()


def render_generic_helper(record: dict) -> str:
    guidance = record.get('api_guidance') or {}
    preferred = guidance.get('preferred_apis', [])
    avoid = guidance.get('avoid_apis', [])
    fallback = guidance.get('fallback_chain', [])
    return lua_header(record) + dedent(
        f'''
        local PulseAPI = PulseAPI or {{}}

        PulseAPI.Guidance = PulseAPI.Guidance or {{}}
        PulseAPI.Guidance["{record.get('record_id')}"] = {{
            preferred_apis = {json.dumps(preferred)},
            avoid_apis = {json.dumps(avoid)},
            fallback_chain = {json.dumps(fallback)},
        }}
        '''
    ).lstrip()


def main() -> int:
    parser = argparse.ArgumentParser(description='Generate helper-wrapper drafts from API guidance records.')
    parser.add_argument('--scope', default='', help='Optional scope filter, e.g. deathknight_unholy')
    args = parser.parse_args()

    HELPER_DIR.mkdir(parents=True, exist_ok=True)
    records = []
    for path in sorted(LIBRARY_ROOT.glob('*.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        if args.scope and args.scope.lower() not in str(data.get('scope', '')).lower():
            continue
        family = infer_helper_family(data)
        if family == 'cooldown':
            content = render_cooldown_helper(data)
        elif family == 'aura':
            content = render_aura_helper(data)
        else:
            content = render_generic_helper(data)
        out_name = f"{safe_name(data.get('record_id', 'record'))}.lua"
        out_path = HELPER_DIR / out_name
        out_path.write_text(content, encoding='utf-8')
        records.append({
            'record_id': data.get('record_id'),
            'title': data.get('title'),
            'scope': data.get('scope'),
            'helper_family': family,
            'generated_lua': str(out_path.relative_to(ROOT)),
            'preferred_apis': (data.get('api_guidance') or {}).get('preferred_apis', []),
            'avoid_apis': (data.get('api_guidance') or {}).get('avoid_apis', []),
            'fallback_chain': (data.get('api_guidance') or {}).get('fallback_chain', []),
        })

    OUT_JSON.write_text(json.dumps({'records': records}, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    lines = ['# API Helper Drafts', '']
    for rec in records:
        lines.extend([
            f"## {rec['title']}",
            '',
            f"- record_id: `{rec['record_id']}`",
            f"- scope: `{rec['scope']}`",
            f"- helper_family: `{rec['helper_family']}`",
            f"- generated_lua: `{rec['generated_lua']}`",
        ])
        if rec['preferred_apis']:
            lines.append(f"- preferred_apis: {', '.join(f'`{x}`' for x in rec['preferred_apis'])}")
        if rec['avoid_apis']:
            lines.append(f"- avoid_apis: {', '.join(f'`{x}`' for x in rec['avoid_apis'])}")
        if rec['fallback_chain']:
            lines.append(f"- fallback_chain: {' -> '.join(f'`{x}`' for x in rec['fallback_chain'])}")
        lines.append('')
    OUT_MD.write_text('\n'.join(lines).rstrip() + '\n', encoding='utf-8')
    print(json.dumps({'generated_helpers': len(records), 'json': str(OUT_JSON.relative_to(ROOT)), 'markdown': str(OUT_MD.relative_to(ROOT))}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
