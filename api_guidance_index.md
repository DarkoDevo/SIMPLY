# API Guidance Index

## Prefer safe cooldown detection fallbacks

- record_id: `legacy_legacy_api_and_suggestions_001_prefer_safe_cooldown_detection_fallbacks`
- scope: `deathknight_unholy`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- avoid_apis: `GetSpellCooldown`, `C_Spell.GetSpellCooldown`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

When cooldown APIs differ or protected reads become unreliable, use a ranked fallback chain and preserve addon behavior.

Build cooldown helpers so they try safe framework wrappers first, then known-safe native APIs, and avoid paths known to return protected or secret values. Log or surface when falling back so future API drift is easier to spot.

## Avoid raw aura reads that drift into protected territory

- record_id: `legacy_legacy_api_and_suggestions_005_avoid_raw_aura_reads_that_drift_into_protected_t`
- scope: `deathknight_unholy`
- preferred_apis: `A_Unit(unitID):HasBuffs`, `A_Unit(unitID):HasDeBuffs`, `GetByRange`
- avoid_apis: `UnitAura`, `AuraUtil.FindAuraByName`
- fallback_chain: `A_Unit(unitID):HasBuffs` -> `cached_arena_state` -> `broad_safe_prediction`

Prefer framework aura wrappers and cached state over direct aura scans when reliability changes between patches.

Use Makulu or Action-safe wrappers first, then cached arena state, and avoid building new logic on raw aura calls that have shown drift or secret/protected behavior.
