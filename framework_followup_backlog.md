# Framework Follow-up Backlog

Framework-level follow-up items that should be migrated carefully instead of patched impulsively inside live combat code.

- Count: 2

## GetSpellCooldown in MakuluFramework/Spell.lua:53

- classification: `direct_call`
- line: `local info = GetSpellCooldown(gcdSpell)`
- recommendation: Replace direct `GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.

## GetSpellCooldown in MakuluFramework/Spell.lua:74

- classification: `direct_call`
- line: `local cooldownInfo = GetSpellCooldown(spellId)`
- recommendation: Replace direct `GetSpellCooldown` usage with a helper or wrapper that prefers A.GetSpellCooldown, Action.GetToggle, A_IsReady and follows fallback chain: A.GetSpellCooldown -> Action.GetToggle -> cached_last_known_cooldown -> broad_safe_prediction.
