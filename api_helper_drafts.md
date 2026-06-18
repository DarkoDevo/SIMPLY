# API Helper Drafts

## Prefer safe cooldown detection fallbacks

- record_id: `legacy_legacy_api_and_suggestions_001_prefer_safe_cooldown_detection_fallbacks`
- scope: `deathknight_unholy`
- helper_family: `cooldown`
- generated_lua: `PulseSystem/generated/helpers/legacy_legacy_api_and_suggestions_001_prefer_safe_cooldown_detection_fallbacks.lua`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- avoid_apis: `GetSpellCooldown`, `C_Spell.GetSpellCooldown`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

## Avoid raw aura reads that drift into protected territory

- record_id: `legacy_legacy_api_and_suggestions_005_avoid_raw_aura_reads_that_drift_into_protected_t`
- scope: `deathknight_unholy`
- helper_family: `aura`
- generated_lua: `PulseSystem/generated/helpers/legacy_legacy_api_and_suggestions_005_avoid_raw_aura_reads_that_drift_into_protected_t.lua`
- preferred_apis: `A_Unit(unitID):HasBuffs`, `A_Unit(unitID):HasDeBuffs`, `GetByRange`
- avoid_apis: `UnitAura`, `AuraUtil.FindAuraByName`
- fallback_chain: `A_Unit(unitID):HasBuffs` -> `cached_arena_state` -> `broad_safe_prediction`
