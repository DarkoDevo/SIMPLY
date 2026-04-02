# API Remediation Plan

Scope: `deathknight_unholy`

## Actionable findings

### GetSpellCooldown in MakuluFramework/Spell.lua:53

- classification: `direct_call`
- action: `replace_call`
- line: `local info = GetSpellCooldown(gcdSpell)`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

Replace direct `GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.

### GetSpellCooldown in MakuluFramework/Spell.lua:74

- classification: `direct_call`
- action: `replace_call`
- line: `local cooldownInfo = GetSpellCooldown(spellId)`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

Replace direct `GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.

### GetSpellCooldown in Rotations/Deathknight/Deathknight_Unholy.lua:266

- classification: `direct_call`
- action: `replace_call`
- line: `local cooldownInfo = C_Spell.GetSpellCooldown(spellID)`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

Replace direct `GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.

### C_Spell.GetSpellCooldown in Rotations/Deathknight/Deathknight_Unholy.lua:266

- classification: `direct_call`
- action: `replace_call`
- line: `local cooldownInfo = C_Spell.GetSpellCooldown(spellID)`
- preferred_apis: `A.GetSpellCooldown`, `Action.GetToggle`, `A_IsReady`
- fallback_chain: `A.GetSpellCooldown` -> `Action.GetToggle` -> `cached_last_known_cooldown` -> `broad_safe_prediction`

Replace direct `C_Spell.GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.

## Monitor-only findings

- `GetSpellCooldown` in `MakuluFramework/Spell.lua:18`: Symbol reference only. Monitor unless it turns into a direct call. Prefer A.GetSpellCooldown, Action.GetToggle, A_IsReady when refactoring nearby code.
- `C_Spell.GetSpellCooldown` in `MakuluFramework/Spell.lua:18`: Symbol reference only. Monitor unless it turns into a direct call. Prefer A.GetSpellCooldown, Action.GetToggle, A_IsReady when refactoring nearby code.
- `GetSpellCooldown` in `Rotations/Deathknight/Deathknight_Unholy.lua:534`: Symbol reference only. Monitor unless it turns into a direct call. Prefer A.GetSpellCooldown, Action.GetToggle, A_IsReady when refactoring nearby code.
- `GetSpellCooldown` in `Rotations/Deathknight/Deathknight_Unholy.lua:535`: Symbol reference only. Monitor unless it turns into a direct call. Prefer A.GetSpellCooldown, Action.GetToggle, A_IsReady when refactoring nearby code.
- `GetSpellCooldown` in `Rotations/Deathknight/Deathknight_Unholy.lua:537`: Symbol reference only. Monitor unless it turns into a direct call. Prefer A.GetSpellCooldown, Action.GetToggle, A_IsReady when refactoring nearby code.
