if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 66 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware
local RegisterEvent    = MakuluFramework.Events.register
local Debounce         = MakuluFramework.debounceSpell
local ConstCell        = cacheContext:getConstCacheCell()
local CommandRegister  = MakuluFramework.Commands.register
local UnRegisterEvent  = MakuluFramework.Events.unregister
local MakGcd           = MakuluFramework.gcd
local frame            = CreateFrame("Frame")

local _G, setmetatable = _G, setmetatable
local Action           = _G.Action
local MultiUnits       = Action.MultiUnits
local Player           = Action.Player
local BossMods         = Action.BossMods

local ActionID = {
    -- Racials
    WillToSurvive = { ID = 59752, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Stoneform = { ID = 20594, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Shadowmeld = { ID = 58984, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    EscapeArtist = { ID = 20589, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    GiftOfTheNaaru = { ID = 59544, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Darkflight = { ID = 68992, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    BloodFury = { ID = 20572, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    WillOfTheForsaken = { ID = 7744, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    WarStomp = { ID = 20549, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Berserking = { ID = 26297, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    ArcaneTorrent = { ID = 50613, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    RocketJump = { ID = 69070, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    RocketBarrage = { ID = 69041, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    QuakingPalm = { ID = 107079, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    SpatialRift = { ID = 256948, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    LightsJudgment = { ID = 255647, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Fireblood = { ID = 265221, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    ArcanePulse = { ID = 260364, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    BullRush = { ID = 255654, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    AncestralCall = { ID = 274738, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Haymaker = { ID = 287712, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    Regeneratin = { ID = 291944, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    BagOfTricks = { ID = 312411, Type = "Spell", MAKULU_INFO = { offGcd = true } }, 
    HyperOrganicLightOriginator = { ID = 312924, Type = "Spell", MAKULU_INFO = { offGcd = true } },

    -- Off GCD
    ArdentDefender              = { ID = 31850, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    AvengersShield              = { ID = 31935, Type = "Spell" },
    AvengingWrath               = { ID = 31884, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    BastionofLight              = { ID = 378974, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    BlessedAssurance            = { ID = 433015, Type = "Spell" },
    BlessedHammer               = { ID = 204019, Type = "Spell" },
    BlessingofFreedom           = { ID = 1044, Type = "Spell", Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    BlessingofProtection        = { ID = 1022, Type = "Spell", Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    BlessingofSacrifice         = { ID = 6940, Type = "Spell", MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    BlessingofSanctuary         = { ID = 210191, Type = "Spell" },
    BlessingofSpellwarding      = { ID = 204018, Type = "Spell" },
    BlindingLight               = { ID = 115750, Type = "Spell" },

    BulwarkofRighteousFury      = { ID = 386653, Type = "Spell" },
    CleanseToxins               = { ID = 213644, Type = "Spell" },
    ConcentrationAura           = { ID = 317920, Type = "Spell" },
    Consecration                = { ID = 26573, Type = "Spell" },
    CrusaderAura                = { ID = 32223, Type = "Spell" },
    CrusaderStrike              = { ID = 35395, Type = "Spell" },
    DevotionAura                = { ID = 465, Type = "Spell" },

    DivineProtection            = { ID = 403876, Type = "Spell" },
    DivineShield                = { ID = 642, Type = "Spell" },
    DivineSteed                 = { ID = 190784, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    DivineToll                  = { ID = 375576, Type = "Spell" },
    EyeofTyr                    = { ID = 387174, Type = "Spell", Macro = "/cast Eye of Tyr\n/cast Hammer of Light" },
    FlashofLight                = { ID = 19750, Type = "Spell", Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },

    GuardianOfTheForgottenQueen = { ID = 228049, Type = "Spell" },
    GuardianofAncientKings      = { ID = 86659, Type = "Spell" },
    HammerandAnvil              = { ID = 433718, Type = "Spell", Hidden = true },
    Hammerfall                  = { ID = 432463, Type = "Spell" },
    HammerofJustice             = { ID = 853, Type = "Spell" },
    HammerofLight               = { ID = 427453, Type = "Spell", Macro = "/cast Eye of Tyr\n/cast Hammer of Light" },
    HammerofWrath               = { ID = 24275, Type = "Spell" },
    HammeroftheRighteous        = { ID = 53595, Type = "Spell" },
    HandofReckoning             = { ID = 62124, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    HolyArmaments               = { ID = 432459, Type = "Spell", Hidden = true },
    HolyBulwark                 = { ID = 432459, Type = "Spell" },
    InmostLight                 = { ID = 405757, Type = "Spell" },
    Intercession                = { ID = 391054, Type = "Spell" },
    Judgment                    = { ID = 275779, Type = "Spell" },
    LayonHands                  = { ID = 633, Type = "Spell", MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    LayonHandsPassive           = { ID = 633, Type = "Spell", Desc = "passive", Texture = 139, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    LayonHandsPassiveToo        = { ID = 471195, Type = "Spell", Desc = "passive", Texture = 139, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    LightsDeliverance           = { ID = 425518, Type = "Spell" },
    LightsGuidance              = { ID = 427445, Type = "Spell" },
    MomentofGlory               = { ID = 327193, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    OfDuskandDawn               = { ID = 409441, Type = "Spell", Hidden = true },
    Rebuke                      = { ID = 96231, Type = "Spell" },
    Redemption                  = { ID = 7328, Type = "Spell" },
    Redoubt                     = { ID = 280373, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    RefiningFire                = { ID = 469883, Type = "Spell", Hidden = true },
    Repentance                  = { ID = 20066, Type = "Spell" },
    RighteousProtector          = { ID = 204074, Type = "Spell" },
    RiteofAdjuration            = { ID = 433583, Type = "Spell", Macro = "/cast [@player]spell:thisID\n/cast 16" },
    RiteofSanctification        = { ID = 433568, Type = "Spell", Macro = "/cast [@player]spell:thisID\n/cast 16" },
    SacredWeapon                = { ID = 432472, Type = "Spell" },
    SanctifiedWrath             = { ID = 53376, Type = "Spell", Hidden = true },
    SearingGlare                = { ID = 410126, Type = "Spell" },
    SenseUndead                 = { ID = 5502, Type = "Spell" },
    ShaketheHeavens             = { ID = 431533, Type = "Spell", Hidden = true },
    ShieldofVirtue              = { ID = 215652, Type = "Spell" },
    ShieldofVengeance           = { ID = 184662, Type = "Spell" },
    ShieldoftheRighteous        = { ID = 53600, Type = "Spell", MAKULU_INFO = { offGcd = true } },
    UnboundFreedom              = { ID = 393097, Type = "Spell" },
    WordofGlory                 = { ID = 85673, Type = "Spell" },
    
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_PALADIN_PROTECTION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local HPG_Abilities = {
    [275779] = true,  -- Judgment
    [204019] = true,  -- Blessed Hammer
    [31935]  = true,  -- Avenger's Shield
    [24275]  = true,  -- Hammer of Wrath
    [53595]  = true,  -- Hammer of the Righteous
}

local hpg_counter = 0
local dawn_stacks = 0

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
local mouseover = ConstUnit.mouseover
local pet = ConstUnit.pet
local arena1 = ConstUnit.arena1
local arena2 = ConstUnit.arena2
local arena3 = ConstUnit.arena3
local party1 = ConstUnit.party1
local party2 = ConstUnit.party2
local party3 = ConstUnit.party3
local party4 = ConstUnit.party4
local healer = ConstUnit.healer
local enemyHealer = ConstUnit.enemyHealer

local gameState = {}

local buffs = {
    arena_preparation = 32727,
    power_infusion = 10060,
    
    avenging_wrath = 31884,
    sentinel = 389539,
    hammer_of_light_free = 427441,
    shake_the_heavens = 431536,
    sacred_weapon = 432502,
    shining_light = 327510,
    bulwark_of_righteous_fury = 386652,
    consecration = 188370,
    
    shield_of_the_righteous = 32403,
    holy_bulwark = 432607,
    ardent_defender = 31850,
    blessing_of_freedom = 1044,
    blessing_of_protection = 1022,
    blessing_of_sanctuary = 210191,
    blessing_of_spellwarding = 204018,
    divine_protection = 403876,
    divine_shield = 640,
    divine_steed = 190784,
    guardian_of_ancient_kings = 86659,
    shield_of_vengeance = 184662,
    
    crusader_aura = 32223,
    devotion_aura = 465,
    concentration_aura = 371920,
    
    blessed_assurance = 433019,
    divine_guidance = 460822,
    blessing_of_dawn = 385127,
    hammer_of_light = 427453,
    
    shining_light_free = 327510,
    sotr = 53600,
    
    bastion_of_light = 378974,
    hammer_of_light_ready = 427453,
    luck_of_the_draw = 1215993, -- Based on Death Knight reference
    masterwork = 1238903, -- Season 3 set bonus buff - needs verification
    lights_deliverance = 433674,
}

local debuffs = {
    exhaustion = 57723,
    forbearance = 25771,
    judgmentDebuff = 197277,
}

local interrupts = {
    { spell = Rebuke },
    { spell = HammerofJustice, isCC = true },
    { spell = BlindingLight, isCC = true, aoe = true, distance = 3 },
}

local function num(val)
    if val then return 1 else return 0 end
end

local function shouldBurst()
    return makBurst()
end

local function party_support()
  local party = MakuluFramework.MultiUnits.party
  party:Each(function(u)
    WordofGlory("partyrotfree", u)
    WordofGlory("partyrot",     u)
    BlessingofProtection("partyrot", u)
    CleanseToxins("partyrot",      u)
  end)
end
-- call party_support() where you currently call WordofGlory("partyrotfree")




WordofGlory:Callback("partyrotfree_auto", function(spell)
  local wogpfhp = A.GetToggle(2, "PartyWoGHPFree")
  if wogpfhp == 0 or not spell:ReadyToUse() then return end

  local u = MakuluFramework.MultiUnits.party:Find(function(m)
    if not m.exists or m:IsDeadOrGhost() then return end
    if m.isMe or (spell:HasRange() and not spell:InRange(m)) then return end
    if m.Los and not m:Los() then return end
    return player:Buff(buffs.shining_light_free) and m.hp < wogpfhp
  end)

  if not u then return end
  return spell:Cast(u)
end)

WordofGlory:Callback("partyrot_auto", function(spell)
    if not spell:ReadyToUse() then return end

    local wogphp = A.GetToggle(2, "PartyWoGHP")
    if wogphp == 0 then return end

    local player = ConstUnit.player
    -- (optional) skip here so the _free_ callback can take precedence
    -- if player:Buff(buffs.shining_light_free) then return end

    local u = MakuluFramework.MultiUnits.party:Find(function(m)
        if not m.exists or m:IsDeadOrGhost() or m.isMe then return end
        if spell:HasRange() and not spell:InRange(m) then return end
        if m.Los and not m:Los() then return end
        return m.hp < wogphp
    end)

    if not u then return end
    return spell:Cast(u)
end)


-- Holy Power Priority System
-- Checks if we should preserve holy power for higher-priority abilities
local function shouldPreserveHolyPower()
    -- Check if Eye of Tyr is available or coming off cooldown soon (< 3 seconds)
    -- Only check if player has Eye of Tyr talent
    -- Eye of Tyr grants 3 holy power when cast (with LightsDeliverance talent)
    if IsPlayerSpell(EyeofTyr.id) and EyeofTyr:Cooldown() < 3000 then
        return true
    end
    
    -- Check if Hammer of Light is ready (buff active or overlay present)
    -- Hammer of Light can be cast immediately after Eye of Tyr
    if player:Buff(buffs.hammer_of_light_ready) or C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then
        return true
    end
    
    -- Check Lights Deliverance stack count
    -- At 55+ stacks, we're close to the 60-stack proc threshold
    -- Preserve holy power to avoid wasting the free Hammer of Light cast
    local lightsDeliveranceStacks = player:HasBuffCount(buffs.lights_deliverance)
    if lightsDeliveranceStacks >= 55 then
        return true
    end
    
    return false
end

local function EnemiesInSpellRange(makulu_spell)
    return ConstCell:GetOrSet("enemiesIn" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                    if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                        total = total + 1
                    end
                end
            end
            return total
    end)
end

local function TotemsInSpellRange(makulu_spell)
    return ConstCell:GetOrSet("totemsIn" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and enemy.inCombat and enemy:IsTotem() and not enemy.isFriendly then
                    return true
                end
            end 
            return false
    end)
end

local function AutoTarget()
    if not A.IsInPvP then return false end
    if not player.inCombat then return false end
    
    if A.GetToggle(2, "autotarget") then
        for _, spellInfo in ipairs(interrupts) do
            if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
                return false
            end
        end
    end
    
    if A.GetToggle(2, "autotarget") and TotemsInSpellRange(Rebuke) and not target:IsTotem() then
        return true
    end
    
    if A.GetToggle(2, "autotaunt") and gameState.ShouldTaunt == "Switch" then
        return true
    end
    
    if Rebuke:InRange(target) and target.exists then return false end
    
    if A.GetToggle(2, "targetmelee") and EnemiesInSpellRange(Rebuke) > 0 then
        return true
    end
end

local function OnSpellCastSuccess()
    local _, eventType, _, sourceGUID, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
    if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
        if HPG_Abilities[spellID] then
            hpg_counter = hpg_counter + 1
            
            -- Check if we gained a Blessing of Dawn stack
            if hpg_counter >= 3 then
                hpg_counter = hpg_counter - 3
                dawn_stacks = math.min(dawn_stacks + 1, 2)  -- Max 2 stacks
            end
        end
    end
end

RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", OnSpellCastSuccess)

local function calculate_hpg_to_2dawn()
    local hpgs_needed_for_next_stack = 3 - hpg_counter
    local hpg_to_2dawn = (2 - dawn_stacks) * 3 - hpg_counter
    -- hpg_to_2dawn ranges from -2 to 6
    return hpg_to_2dawn
end

local function updateGameState()
    gameState = {
        TWW1has2P = player:Has2Set(),
        TWW1has4P = player:Has4Set(),
        ShouldTaunt = MakuluFramework.TauntStatus(HandofReckoning),
        tank_buster_in = MakuluFramework.DBM_TankBusterIn() or 1000000,
    }
    
    if not A.GetToggle(2, "usedbm") then
        gameState.tank_buster_in = 1000000
    end
    
    gameState.judgmentHP = 1 + num(player:TalentKnown(SanctifiedWrath.id) and (player:Buff(buffs.avenging_wrath) or player:Buff(buffs.sentinel))) + (2 * num(player:Buff(buffs.bastion_of_light)))
end

--actions.cooldowns=lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up
LightsJudgment:Callback("cooldown", function(spell)
        if not A.GetToggle(1, "Racial") then return end
        
        if EnemiesInSpellRange(Rebuke) >= 2 then
            return spell:Cast(target)
        end
end)

-- actions.cooldowns+=/avenging_wrath
AvengingWrath:Callback("cooldown", function(spell)
        if shouldBurst() and Rebuke:InRange(target) then
            return spell:Cast()
        end
end)

-- actions.cooldowns+=/potion,if=buff.avenging_wrath.up
-- Note: Potion usage handled by framework

-- actions.cooldowns+=/moment_of_glory,if=(buff.avenging_wrath.remains<15|(time>10))
MomentofGlory:Callback("cooldown", function(spell)
        if not target:MeleeRange() then return end
        if player:BuffRemains(buffs.avenging_wrath) < 15000 or player.combatTime > 10000 then
            return spell:Cast()
        end
end)

-- actions.cooldowns+=/invoke_external_buff,name=power_infusion,if=buff.avenging_wrath.up
-- Note: External buffs handled by framework

-- actions.cooldowns+=/divine_toll,if=spell_targets.shield_of_the_righteous>=3
DivineToll:Callback("cooldown", function(spell)
        if not shouldBurst() then return end
        if AvengingWrath:Cooldown() > 15000 then
            return spell:Cast(target)
        end
end)

-- actions.cooldowns+=/bastion_of_light,if=buff.avenging_wrath.up|cooldown.avenging_wrath.remains<=30
BastionofLight:Callback("cooldown", function(spell)
        if player:Buff(buffs.avenging_wrath) or AvengingWrath:Cooldown() <= 30000 then
            return spell:Cast()
        end
end)

-- actions.cooldowns+=/fireblood,if=buff.avenging_wrath.remains>8
Fireblood:Callback("cooldown", function(spell)
        if not A.GetToggle(1, "Racial") then return end
        if A.GetToggle(2, "firebloodDef") then return end
        if player:BuffRemains(buffs.avenging_wrath) > 8000 then
            return spell:Cast()
        end
end)

-- ============================================================================
-- SACRED WEAPON - Offensive Holy Armament
-- ============================================================================
-- Sacred Weapon increases damage output and scales from player stats
-- Use during burst windows or on DPS to increase group damage
SacredWeapon:Callback("cooldown", function(spell)
        if not A.GetToggle(2, "SacredWeaponEnabled") then return end
        if not IsPlayerSpell(SacredWeapon.id) then return end
        -- if player:Buff(buffs.holy_bulwark) then return end
        -- if player:Buff(buffs.sacred_weapon) then return end
        
        return spell:Cast()
end)


-- actions+=/call_action_list,name=cooldowns
local function cooldown_rot()
    LightsJudgment("cooldown")
    AvengingWrath("cooldown")
    -- Potion handled by framework
    MomentofGlory("cooldown")
    DivineToll("cooldown")
    BastionofLight("cooldown")
    -- Power Infusion handled by framework
    Fireblood("cooldown")
    SacredWeapon("cooldown")  -- Offensive Holy Armament
end

local function IsUsingDefensive()
    if player:Buff(buffs.ardent_defender) or player:Buff(buffs.guardian_of_ancient_kings) or player:Buff(buffs.divine_shield) or player:Buff(buffs.blessing_of_protection) then
        return true
    end
    return false
end

--Bleed
Fireblood:Callback("bleed", function(spell)
        if player.bleeding then
            return spell:Cast()
        end
end)

-- actions.defensives=ardent_defender
ArdentDefender:Callback("defensive", function(spell)
        if not IsUsingDefensive() and target.ttd > 5000 then
            if player.hp < A.GetToggle(2, "ArdentDefenderHP") or gameState.tank_buster_in < 1500 then
                return spell:Cast()
            end
        end
end)

GuardianofAncientKings:Callback("defensive", function(spell)
        if A.IsInPvP then return end
        if not IsUsingDefensive() and target.ttd > 5000 then
            if player.hp < A.GetToggle(2, "GuardianHP") or gameState.tank_buster_in < 1500 then
                return spell:Cast()
            end
        end
end)

DivineShield:Callback("defensive", function(spell)
        if not IsUsingDefensive() and target.ttd > 5000 then
            if player.hp < A.GetToggle(2, "DivineShieldHP") or gameState.tank_buster_in < 1500 then
                return spell:Cast()
            end
        end
end)

BlessingofProtection:Callback("defensive", function(spell)
        if player.hp < 15 and target.ttd > 5000 and not IsUsingDefensive() then
            return spell:Cast()
        end
end)

WordofGlory:Callback("defensive", function(spell)
        if player:Buff(buffs.shining_light_free) and player.hp < A.GetToggle(2, "WoGHPFree") then
            return spell:Cast()
        end
        
        if player.hp < A.GetToggle(2, "WoGHP") and not player:Buff(buffs.shining_light_free) then
            return spell:Cast()
        end
end)

-- ============================================================================
-- HOLY BULWARK - Defensive Holy Armament
-- ============================================================================
-- Holy Bulwark provides a shield based on target's health
-- Use when player or allies are taking damage
HolyBulwark:Callback("defensives", function(spell)
        if not A.GetToggle(2, "HolyBulwarkEnabled") then return end
        if not IsPlayerSpell(HolyBulwark.id) then return end
        -- if player:Buff(buffs.holy_bulwark) then return end
        -- if player:Buff(buffs.sacred_weapon) then return end
        
        -- -- Use on self when low HP
        -- if player.hp < 50 then
        --     return spell:Cast(player)
        -- end
        
        return spell:Cast()
end)

-- actions+=/call_action_list,name=defensives
local function defensives_rot()
	WordofGlory("partyrotfree_auto")
    WordofGlory("partyrot_auto")
    BlessingofSacrifice("party70_auto")
    WordofGlory("defensive")
    ArdentDefender("defensive")
    GuardianofAncientKings("defensive")
    DivineShield("defensive")
    BlessingofProtection("defensive")
    HolyBulwark("defensives")  -- Defensive Holy Armament
end

--actions.standard=judgment,target_if=min:debuff.judgment.remains,if=charges>=2|full_recharge_time<=gcd.max
Judgment:Callback("standard", function(spell)
        if spell.frac >= 2 or spell:TimeToFullCharges() <= A.GetGCD() * 1000 then
            return spell:Cast(target)
        end
end)

-- 427441

--actions.standard+=/hammer_of_light,if=(buff.blessing_of_dawn.up|fight_remains<2)&(debuff.judgment.up|buff.hammer_of_light_ready.remains<2|buff.hammer_of_light_ready.stack>1|buff.hammer_of_light_free.up|(cooldown.eye_of_tyr.remains<3))
HammerofLight:Callback("standard", function(spell)
        if not HammerofLight:InRange(target) then return end
        if (player:Buff(buffs.blessing_of_dawn) or target.ttd < 2000) and (target:Debuff(275779) or player:BuffRemains(buffs.hammer_of_light_ready) < 2000 or player:HasBuffCount(buffs.hammer_of_light_ready) > 1 or player:Buff(buffs.hammer_of_light_free) or EyeofTyr:Cooldown() < 3000) then
            return spell:Cast()
        end
end)

--actions.standard+=/eye_of_tyr,if=(hpg_to_2dawn=5|!talent.of_dusk_and_dawn.enabled)&talent.lights_guidance.enabled
--actions.standard+=/eye_of_tyr,if=(hpg_to_2dawn=1|buff.blessing_of_dawn.stack>0)&talent.lights_guidance.enabled
EyeofTyr:Callback("standard", function(spell)
        if not shouldBurst() then return false end
        if not Rebuke:InRange(target) then return false end
        
        return spell:Cast()
end)


--actions.standard+=/shield_of_the_righteous,if=!buff.hammer_of_light_ready.up&(buff.luck_of_the_draw.up&((holy_power+judgment_holy_power>=5)|(!talent.righteous_protector.enabled|cooldown.righteous_protector_icd.remains=0)))
ShieldoftheRighteous:Callback("standard", function(spell)
        if player:Buff(buffs.hammer_of_light_ready) or C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return false end
                
        if player.holyPower + gameState.judgmentHP >= 5 then
            return spell:Cast()
        end
        
        return false
end)

--actions.standard+=/shield_of_the_righteous,if=set_bonus.thewarwithin_season_2_4pc&!buff.hammer_of_light_ready.up&((holy_power+judgment_holy_power>5)|(holy_power+judgment_holy_power>=5&cooldown.righteous_protector_icd.remains=0))
ShieldoftheRighteous:Callback("standard2", function(spell)
        if not player:Has4Set() then return false end
        if player:Buff(buffs.hammer_of_light_ready) or C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return false end
        
        -- Preserve holy power for Eye of Tyr + Hammer of Light combo or Lights Deliverance proc
        if shouldPreserveHolyPower() then return false end
        
        if (player.holyPower + gameState.judgmentHP > 5) or (player.holyPower + gameState.judgmentHP >= 5 and spell.used > 1000) then
            return spell:Cast()
        end
        
        return false
end)

--actions.standard+=/shield_of_the_righteous,if=!set_bonus.thewarwithin_season_2_4pc&(!talent.righteous_protector.enabled|cooldown.righteous_protector_icd.remains=0)&!buff.hammer_of_light_ready.up
ShieldoftheRighteous:Callback("standard3", function(spell)
        if player:Has4Set() then return false end
        if player:Buff(buffs.hammer_of_light_ready) or C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return false end
        
        -- Preserve holy power for Eye of Tyr + Hammer of Light combo or Lights Deliverance proc
        if shouldPreserveHolyPower() then return false end
        
        if not player:TalentKnown(RighteousProtector.id) or spell.used > 1000 then
            return spell:Cast()
        end
        
        return false
end)

--actions.standard+=/shield_of_the_righteous,if=holy_power=5&(!buff.blessing_of_dawn.up|!talent.lights_guidance.enabled)
ShieldoftheRighteous:Callback("standard4", function(spell)
        if player:Buff(buffs.hammer_of_light_ready) or C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return false end
        
        -- Preserve holy power for Eye of Tyr + Hammer of Light combo or Lights Deliverance proc
        if shouldPreserveHolyPower() then return false end
        
        if player.holyPower == 5 and (not player:Buff(buffs.blessing_of_dawn) or not player:TalentKnown(LightsGuidance.id)) then
            return spell:Cast()
        end
        
        return false
end)

--actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=spell_targets.shield_of_the_righteous>3&buff.bulwark_of_righteous_fury.stack>=3&holy_power<3
Judgment:Callback("standard2", function(spell)
        if EnemiesInSpellRange(Rebuke) > 3 and player:HasBuffCount(buffs.bulwark_of_righteous_fury) >= 3 and player.holyPower < 3 then
            return spell:Cast(target)
        end
end)

--actions.standard+=/holy_armaments,if=next_armament=holy_bulwark&set_bonus.thewarwithin_season_3_4pc
HolyArmaments:Callback("standard", function(spell)
        if not player:Has4Set() then return end -- Assuming season 3 4pc
        local bulwarkReady = C_Spell.GetSpellTexture(432459) == 5927636
        if bulwarkReady then
            return spell:Cast()
        end
end)

--actions.standard+=/blessed_hammer,if=set_bonus.thewarwithin_season_3_4pc&talent.hammer_and_anvil.enabled
BlessedHammer:Callback("standard", function(spell)
        if not player:Has4Set() then return end -- Assuming season 3 4pc
        if player:TalentKnown(HammerandAnvil.id) then
            return spell:Cast()
        end
end)

--actions.standard+=/avengers_shield,if=!buff.bulwark_of_righteous_fury.up&talent.bulwark_of_righteous_fury.enabled&spell_targets.shield_of_the_righteous>=3
AvengersShield:Callback("standard", function(spell)
        if target.ttd < 10000 then return end
        
        if not player:Buff(buffs.bulwark_of_righteous_fury) and player:TalentKnown(BulwarkofRighteousFury.id) and EnemiesInSpellRange(Rebuke) >= 3 then
            return spell:Cast(target)
        end
end)

--actions.standard+=/hammer_of_the_righteous,if=buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<3&!buff.avenging_wrath.up
HammeroftheRighteous:Callback("standard", function(spell)
        if not IsPlayerSpell(HammeroftheRighteous.id) then return false end
        if not Rebuke:InRange(target) then return false end
        if player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 3 and not player:Buff(buffs.avenging_wrath) then
            return spell:Cast(target)
        end
        return false
end)

--actions.standard+=/blessed_hammer,if=buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<3
BlessedHammer:Callback("standard2", function(spell)
        if player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 3 then
            return spell:Cast()
        end
end)

--actions.standard+=/crusader_strike,if=buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<2&!buff.avenging_wrath.up
CrusaderStrike:Callback("standard", function(spell)
        if not Rebuke:InRange(target) then return end
        if player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 2 and not player:Buff(buffs.avenging_wrath) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=charges>=2|full_recharge_time<=gcd.max -- This is literally already called first priority.

--actions.standard+=/consecration,if=buff.divine_guidance.stack=5
Consecration:Callback("standard", function(spell)
        if not player:Buff(buffs.consecration) and player:HasBuffCount(buffs.divine_guidance) == 5 and player.stayTime > 0.5 and Rebuke:InRange(target) and spell.used > 2000 then
            return spell:Cast()
        end
end)

--actions.standard+=/holy_armaments,if=next_armament=sacred_weapon&((!buff.sacred_weapon.up|(buff.sacred_weapon.remains<6&!buff.avenging_wrath.up&cooldown.avenging_wrath.remains<=30))&(!set_bonus.thewarwithin_season_3_4pc|buff.masterwork.stack=5))
HolyArmaments:Callback("standard2", function(spell)
        local weaponReady = C_Spell.GetSpellTexture(432459) == 5927637
        if not weaponReady then return end
        
        local sacredWeaponCondition = not player:Buff(buffs.sacred_weapon) or (player:BuffRemains(buffs.sacred_weapon) < 6000 and not player:Buff(buffs.avenging_wrath) and AvengingWrath:Cooldown() <= 30000)
        local setCondition = not player:Has4Set() or player:HasBuffCount(buffs.masterwork) == 5
        
        if sacredWeaponCondition and setCondition then
            return spell:Cast()
        end
        return false
end)



--actions.standard+=/hammer_of_wrath
HammerofWrath:Callback("standard", function(spell)
        -- Hammer of Wrath is usable when:
        -- 1. Target is below 20% HP (execute range), OR
        -- 2. Avenging Wrath is active (grants execute range)
        if not Rebuke:InRange(target) then return false end

        local targetBelowExecute = target.hp <= 20 or target.isDummy
        local avengingWrathActive = player:Buff(buffs.avenging_wrath)

        if targetBelowExecute or avengingWrathActive then
            return spell:Cast(target)
        end

        return false
end)


-- actions.standard+=/crusader_strike,if=buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<2&!buff.avenging_wrath.up
CrusaderStrike:Callback("standard2", function(spell)
        if player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(ShieldoftheRighteous) < 2 and not player:Buff(buffs.avenging_wrath) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/divine_toll,if=(!raid_event.adds.exists|raid_event.adds.in>10)
DivineToll:Callback("standard", function(spell)
        -- Only cast Divine Toll in standard rotation if not in burst window
        -- (burst window is handled by cooldown callback)
        if shouldBurst() then return false end
        if not Rebuke:InRange(target) then return false end
        
        return spell:Cast()
end)

--actions.standard+=/avengers_shield,if=talent.refining_fire.enabled
AvengersShield:Callback("standard2", function(spell)
        if target.ttd < 10000 then return end
        
        if player:TalentKnown(RefiningFire.id) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/judgment,target_if=min:debuff.judgment.remains,if=(buff.avenging_wrath.up&talent.hammer_and_anvil.enabled)
Judgment:Callback("standard3", function(spell)
        if player:Buff(buffs.avenging_wrath) and player:TalentKnown(HammerandAnvil.id) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/holy_armaments,if=next_armament=holy_bulwark&charges=2
HolyArmaments:Callback("standard3", function(spell)
        local bulwarkReady = C_Spell.GetSpellTexture(432459) == 5927636
        if not bulwarkReady then return end
        
        if spell.frac >= 2 then
            return spell:Cast()
        end
end)

--actions.standard+=/judgment,target_if=min:debuff.judgment.remains
Judgment:Callback("standard4", function(spell)
        
        return spell:Cast(target)
end)

--actions.standard+=/avengers_shield,if=!buff.shake_the_heavens.up&talent.shake_the_heavens.enabled
AvengersShield:Callback("standard3", function(spell)
        if target.ttd < 10000 then return end
        
        if not player:Buff(buffs.shake_the_heavens) and player:TalentKnown(ShaketheHeavens.id) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/hammer_of_the_righteous,if=(buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<3)|buff.shake_the_heavens.up
HammeroftheRighteous:Callback("standard2", function(spell)
        if not IsPlayerSpell(HammeroftheRighteous.id) then return false end
        if not Rebuke:InRange(target) then return false end
        if (player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 3) or player:Buff(buffs.shake_the_heavens) then
            return spell:Cast(target)
        end
        return false
end)

--actions.standard+=/blessed_hammer,if=(buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<3)|buff.shake_the_heavens.up
BlessedHammer:Callback("standard3", function(spell)
        if (player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 3) or player:Buff(buffs.shake_the_heavens) then
            return spell:Cast()
        end
end)

--actions.standard+=/crusader_strike,if=(buff.blessed_assurance.up&spell_targets.shield_of_the_righteous<2)|buff.shake_the_heavens.up
CrusaderStrike:Callback("standard3", function(spell)
        if not Rebuke:InRange(target) then return end
        if (player:Buff(buffs.blessed_assurance) and EnemiesInSpellRange(Rebuke) < 2) or player:Buff(buffs.shake_the_heavens) then
            return spell:Cast(target)
        end
end)

--actions.standard+=/avengers_shield,if=!talent.lights_guidance.enabled
AvengersShield:Callback("standard4", function(spell)
        if not player:TalentKnown(LightsGuidance.id) then
            return spell:Cast(target)
        end
end)

-- Drop Consecration every 11 seconds, or immediately if you step out of it
Consecration:Callback("standard2", function(spell)
        if not player.inCombat then return end
        if Consecration.used >= 11000 or (not player:Buff(buffs.consecration) and Consecration.used > 800) then
            return spell:Cast()
        end
end)

--actions.standard+=/eye_of_tyr,if=(talent.inmost_light.enabled&raid_event.adds.in>=45|spell_targets.shield_of_the_righteous>=3)&!talent.lights_deliverance.enabled
EyeofTyr:Callback("standard2", function(spell)
        if not shouldBurst() then return end
        
        if C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return end
        
        if (player:TalentKnown(InmostLight.id) or EnemiesInSpellRange(Rebuke) >= 3) and not player:TalentKnown(LightsDeliverance.id) then
            return spell:Cast()
        end
end)

--actions.standard+=/holy_armaments,if=next_armament=holy_bulwark
HolyArmaments:Callback("standard4", function(spell)
        local bulwarkReady = C_Spell.GetSpellTexture(432459) == 5927636
        if bulwarkReady then
            return spell:Cast()
        end
end)

--actions.standard+=/blessed_hammer
BlessedHammer:Callback("standard4", function(spell)
        return spell:Cast()
end)

--actions.standard+=/hammer_of_the_righteous
HammeroftheRighteous:Callback("standard3", function(spell)
        if not IsPlayerSpell(HammeroftheRighteous.id) then return false end
        if not Rebuke:InRange(target) then return false end
        return spell:Cast(target)
end)

--actions.standard+=/crusader_strike
CrusaderStrike:Callback("standard4", function(spell)
        if not Rebuke:InRange(target) then return end
        return spell:Cast(target)
end)

--actions.standard+=/word_of_glory,if=buff.shining_light_free.up&(talent.blessed_assurance.enabled|(talent.lights_guidance.enabled&cooldown.hammerfall_icd.remains=0))
WordofGlory:Callback("standard", function(spell)
        if player:Buff(buffs.shining_light_free) and (player:TalentKnown(BlessedAssurance.id) or (player:TalentKnown(LightsGuidance.id) and ShieldoftheRighteous.used > 1000)) then
            return spell:Cast()
        end
end)

--actions.standard+=/avengers_shield
AvengersShield:Callback("standard5", function(spell)
        if target.ttd < 10000 then return end
        
        return spell:Cast(target)
end)

--actions.standard+=/eye_of_tyr,if=!talent.lights_deliverance.enabled
EyeofTyr:Callback("standard3", function(spell)
        if not shouldBurst() then return end
        
        if C_SpellActivationOverlay.IsSpellOverlayed(HammerofLight.id) then return end
        if not Rebuke:InRange(target) then return end
        
        if not player:TalentKnown(LightsDeliverance.id) then
            return spell:Cast()
        end
end)

--actions.standard+=/word_of_glory,if=buff.shining_light_free.up
WordofGlory:Callback("standard2", function(spell)
        if player:Buff(buffs.shining_light_free) then
            return spell:Cast()
        end
end)

-- actions.standard+=/arcane_torrent,if=holy_power<5
ArcaneTorrent:Callback("standard", function(spell)
        if not A.GetToggle(1, "Racial") then return end
        if player.holyPower < 5 then
            return spell:Cast()
        end
end)

AvengersShield:Callback("oncd", function(spell)
        if A.GetToggle(2, "asonCD") then
            return spell:Cast(target)
        end
end)

EyeofTyr:Callback("templar", function(spell)
        if not spell:InRange(target) then return false end
        
        return spell:Cast()
end)

HammerofLight:Callback("templar", function(spell)
        
        return spell:Cast(target)
end)

ShieldofVirtue:Callback("pvp", function(spell)
    if A.IsInPvP then
        return spell:Cast(target)
    end    
end)

MomentofGlory:Callback("pvp", function(spell)
    if A.IsInPvP and player:Buff(buffs.avenging_wrath) then
        return spell:Cast()
    end
end)

-- actions+=/call_action_list,name=standard
local function standard_rot()
    -- APL Order
    MomentofGlory("pvp")
    ShieldofVirtue("pvp")
	HammerofLight("templar")
    ShieldofVirtue("pvp")
    AvengersShield("oncd") -- Keep the on-CD option for UI toggle
    Judgment("standard")
    Consecration("standard2")
    EyeofTyr("standard")
    ShieldoftheRighteous("standard")
    Judgment("standard2")
    ShieldoftheRighteous("standard2")
    HolyArmaments("standard")
    ShieldoftheRighteous("standard3")
    BlessedHammer("standard")
    ShieldoftheRighteous("standard4")
    AvengersShield("standard")
    HammeroftheRighteous("standard")
    BlessedHammer("standard2")
    HammerofWrath("standard")
    CrusaderStrike("standard")
    Consecration("standard")
    CrusaderStrike("standard2")
    HolyArmaments("standard2")
    DivineToll("standard")
    Judgment("standard3")
    HolyArmaments("standard3")
    Judgment("standard4")
    HammeroftheRighteous("standard2")
    BlessedHammer("standard3")
    CrusaderStrike("standard3")
    AvengersShield("standard4")
    EyeofTyr("standard2")
    HolyArmaments("standard4")
    BlessedHammer("standard4")
    HammeroftheRighteous("standard3")
    CrusaderStrike("standard4")
    WordofGlory("standard")
    EyeofTyr("standard3")
    WordofGlory("standard2")
    EyeofTyr("templar")  -- Fallback for LightsDeliverance talent
    ArcaneTorrent("standard")
    AvengersShield("standard5")
    
end

Intercession:Callback(function(spell)
        if not A.GetToggle(2, "mouseoverRes") then return end
        if not player.combat then return end
        if not mouseover.exists then return end
        if not mouseover.isFriendly then return end
        if not mouseover.dead then return end
        if not spell:InRange(mouseover) then return end
        
        return spell:Cast()
end)

Redemption:Callback(function(spell)
        if not A.GetToggle(2, "mouseoverRes") then return end
        if player.combat then return end
        if not mouseover.exists then return end
        if not mouseover.isFriendly then return end
        if not mouseover.dead then return end
        if not spell:InRange(mouseover) then return end
        
        return spell:Cast()
end)

HandofReckoning:Callback(function(spell)
        local noAggro = UnitThreatSituation("player", target:CallerId())
        if noAggro == 0 or noAggro == 2 then
            return spell:Cast(target)
        end
end)

CleanseToxins:Callback("self", function(spell)
        if player:Poisoned() or player:Diseased() then
            return spell:Cast()
        end
end)

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()
    
    makInterrupt(interrupts)
    HammerofLight("templar")
    
    Intercession()
    Redemption()
    
    if player.inCombat and MakuluFramework.TankDefensive() then
        if Trinket(13, "Defensive") then
            Trinket1()
        end
        if Trinket(14, "Defensive") then
            Trinket2()
        end
    end
    
    --Calling this in A[3] will cause hangs when Blizzard UI breaks item cooldowns. 
    --[[if player.inCombat and player.hp < 50 then
        if MakuluFramework.CanUseHealthStone() then
            HealthStone()
        end

        if MakuluFramework.CanUseHealthPotion() then
            HealthPotion()
        end
    end]]
    
    --[[
    -- ============================================================================
-- AURA MANAGEMENT SYSTEM
-- ============================================================================
-- Smart aura switching based on combat state and situational needs
-- Priorities: Devotion (combat) > Concentration (interrupt protection) > Crusader (movement)

-- Devotion Aura - Default aura for damage reduction in combat
-- DevotionAura:Callback("aura_management", function(spell)
--     if not A.GetToggle(2, "AuraManagementEnabled") then return false end
--     if player:Buff(buffs.devotion_aura) then return false end
--     if player:Buff(buffs.concentration_aura) then return false end
--     if player:Buff(buffs.crusader_aura) then return false end
--     if player.mounted then return false end

--     -- Use Devotion Aura in combat or when in PvP
--     if player.inCombat or A.IsInPvP then
--         return spell:Cast(player)
--     end

--     return false
-- end)

-- Concentration Aura - Use when being interrupted or need interrupt protection
-- ConcentrationAura:Callback("aura_management", function(spell)
--     if not A.GetToggle(2, "AuraManagementEnabled") then return false end
--     if not A.GetToggle(2, "ConcentrationAuraEnabled") then return false end
--     if player:Buff(buffs.concentration_aura) then return false end
--     if player.mounted then return false end

--     -- Use Concentration Aura in PvP to prevent interrupts
--     if Action.Zone == "arena" or A.IsInPvP then
--         if player.inCombat then
--             return spell:Cast(player)
--         end
--     end

--     return false
-- end)

-- -- Crusader Aura - Use out of combat for movement speed
-- CrusaderAura:Callback("aura_management", function(spell)
--     if not A.GetToggle(2, "AuraManagementEnabled") then return false end
--     if not A.GetToggle(2, "CrusaderAuraEnabled") then return false end
--     if player:Buff(buffs.crusader_aura) then return false end
--     if player.mounted then return false end
--     if player.inCombat then return false end

--     -- Use Crusader Aura out of combat for movement speed
--     if player.moving then
--         return spell:Cast(player)
--     end

--     return false
-- end)
]]
    
    LayonHands:Callback("partyrot", function(spell, friendly)
            if friendly.isMe then return end
            if friendly:Debuff(debuffs.forbearance) then return end
            
            local lohphp = A.GetToggle(2, "PartyLoHHP")
            if lohphp == 0 then return end
            if friendly.hp < lohphp then
                if A.GetToggle(2, "lohDebounce") then
                    return Debounce("lohusage", 1000, 2500, spell, friendly)
                else
                    return spell:Cast(friendly)
                end
            end
    end)
    
    LayonHandsPassiveToo:Callback("passive", function(spell, friendly)
            if friendly.isMe then return end
            if friendly:Debuff(debuffs.forbearance) then return end
            
            local lohphp = A.GetToggle(2, "PartyLoHHP")
            if lohphp == 0 then return end
            if friendly.hp < lohphp then
                if A.GetToggle(2, "lohDebounce") then
                    return Debounce("lohusage", 1000, 2500, spell, friendly)
                else
                    return spell:Cast(friendly)
                end
            end
    end)
    
    -- Lay on Hands - Self-cast emergency healing
    LayonHands:Callback("pvp_self", function(spell)
            if Action.Zone ~= "arena" and not A.IsInPvP then return false end
            if not player.inCombat then return false end
            if player:HasDeBuff(debuffs.forbearance) then return false end
            if player:IsTotalImmune() then return false end
            if player.hp > 15 then return false end
            
            Aware:displayMessage("Lay on Hands - Emergency Heal!", "Gold", 1.5)
            local casted = spell:Cast(player)
            if casted then return true end
            return false
    end)
    
    DevotionAura:Callback("aura_management", function(spell)
            if player:HasBuff(A.DevotionAura.ID) then return end
            return spell:Cast(player)
    end)
    
    -- Aura management (out of combat and in combat)
    DevotionAura("aura_management")
    -- ConcentrationAura("aura_management")
    -- CrusaderAura("aura_management")
    
    -- Rite abilities (out of combat weapon enchants)
    RiteofSanctification("rite_management")
    RiteofAdjuration("rite_management")
    
    if player.inCombat then -- Def
        Fireblood("bleed")
        CleanseToxins("self")
        
        -- PvP defensive abilities (arena-specific)
        if Action.Zone == "arena" or A.IsInPvP then
            DivineProtection("pvp_defensive")      -- Damage reduction
            ShieldofVengeance("pvp_defensive")     -- Absorb shield
            BlessingofFreedom("pvp_self")          -- Remove roots/slows
            LayonHands("pvp_self")                 -- Emergency heal
            BlessingofProtection("pvp_self")       -- Physical immunity
            DivineShield("pvp_emergency")          -- Emergency immunity
            DivineSteed("pvp_mobility")            -- Kiting/mobility
        end
        
        defensives_rot()
    end
    
    if target.exists and target.canAttack then
        HandofReckoning()
        if shouldBurst() then
            cooldown_rot()
        end
        standard_rot()
    end
    
    return FrameworkEnd()
end

BlessingofProtection:Callback("partyrot", function(spell, friendly)
    if friendly.isMe then return end
    if friendly:Debuff(debuffs.forbearance) then return end

    -- LoH ready? then don't use BoP
    if (LayonHands and LayonHands.ReadyToUse and LayonHands:ReadyToUse())
       or (LayonHandsPassiveToo and LayonHandsPassiveToo.ReadyToUse and LayonHandsPassiveToo:ReadyToUse()) then
        return
    end

    local bopphp = A.GetToggle(2, "PartyBoPHP")
    if bopphp == 0 then return end
    if friendly.hp < bopphp then
        return spell:Cast(friendly)
    end
end)

-- Blessing of Protection - Self-cast physical immunity
BlessingofProtection:Callback("pvp_self", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        if player:HasDeBuff(debuffs.forbearance) then return false end
        if player:IsTotalImmune() then return false end
        if DivineShield:Cooldown() < 2000 then return false end
        if player.hp > A.GetToggle(2, "BoPHPSelf") then return false end
        
        Aware:displayMessage("Blessing of Protection - Physical Immunity", "Yellow", 1)
        local casted = spell:Cast(player)
        if casted then return true end
        return false
end)


WordofGlory:Callback("partyrotfree", function(spell, friendly)
        if friendly.isMe then return end
        local wogpfhp = A.GetToggle(2, "PartyWoGHPFree")
        if wogpfhp == 0 then return end
        if player:Buff(buffs.shining_light_free) and friendly.hp < wogpfhp then
            return spell:Cast(friendly)
        end
end)

WordofGlory:Callback("partyrot", function(spell, friendly)
        if friendly.isMe then return end
        local wogphp = A.GetToggle(2, "PartyWoGHP")
        if wogphp == 0 then return end
        if friendly.hp < wogphp then
            return spell:Cast(friendly)
        end
end)

CleanseToxins:Callback("partyrot", function(spell, friendly)
        if friendly.isMe then return end
        if friendly:Poisoned() or friendly:Diseased() then
            return spell:Cast(friendly)
        end
end)

-- Blessing of Sacrifice – cast on the first ally at or below 70% HP
BlessingofSacrifice:Callback("party70_auto", function(spell)
    if not spell:ReadyToUse() then return end

    local party = MakuluFramework.MultiUnits.party
    local u = party:Find(function(m)
        if not m.exists or m:IsDeadOrGhost() then return end
        if m.isMe or not m:IsFriendly() then return end
        if spell:HasRange() and not spell:InRange(m) then return end
        if m.Los and not m:Los() then return end
        if m:Buff(6940) then return end          -- already has BoSac (spellID 6940)
        return m.hp <= 70
    end)
    if not u then return end
    return spell:Cast(u)
end)

-- ============================================================================
-- PvP-SPECIFIC CALLBACKS FOR PROTECTION PALADIN
-- ============================================================================
-- These callbacks implement smart PvP logic for arena and battleground combat
-- Focus: Defensive cooldowns, CC, utility, and party support

-- Divine Protection - Damage reduction cooldown (1 min CD)
DivineProtection:Callback("pvp_defensive", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        if player.hp > 60 then return false end
        if player.hp > 40 and target.hp < 20 then return false end
        
        Aware:displayMessage("Divine Protection - DR Active", "Cyan", 1)
        return spell:Cast(player)
end)

-- Shield of Vengeance - Proactive absorb shield (2 min CD)
ShieldofVengeance:Callback("pvp_defensive", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        if player.hp > 70 then return false end
        
        Aware:displayMessage("Shield of Vengeance - Absorb Active", "Orange", 1)
        return spell:Cast(player)
end)

-- Blessing of Freedom - Self-cast for player when rooted/slowed
BlessingofFreedom:Callback("pvp_self", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        if player:IsTotalImmune() then return false end
        if player:Buff(buffs.blessing_of_freedom) then return false end
        
        local hasRootDebuff = player.rooted or player:HasDeBuffFromFor(MakLists.freedom, 500)
        if not hasRootDebuff then return false end
        
        Aware:displayMessage("Freedom - Self Root", "Purple", 1)
        local casted = spell:Cast(player)
        if casted then return true end
        return false
end)

-- Blessing of Freedom - Party version for rooted/slowed teammates
BlessingofFreedom:Callback("pvp_party", function(spell, friendly)
        if friendly:IsMe() then return false end
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if friendly.distance > 40 then return false end
        if friendly.hp <= 0 then return false end
        if friendly:IsTotalImmune() then return false end
        
        local hasRootDebuff = friendly.rooted or friendly:HasDeBuffFromFor(MakLists.freedom, 500)
        if not hasRootDebuff then return false end
        
        -- PRIORITY 1: Healers
        if friendly.isHealer then
            Aware:displayMessage("Freedom - Healer Rooted", "Green", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        -- PRIORITY 2: Casters
        if friendly.isCaster then
            Aware:displayMessage("Freedom - Caster Rooted", "Cyan", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        -- PRIORITY 3: Others (if low HP or Unbound Freedom available)
        if friendly.hp < 70 or IsPlayerSpell(A.UnboundFreedom.ID) then
            Aware:displayMessage("Freedom - Teammate Rooted", "Blue", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        return false
end)

-- Blessing of Sanctuary - Party CC immunity (PvP talent)
BlessingofSanctuary:Callback("pvp_party", function(spell, friendly)
        if friendly:IsMe() then return false end
        if not A.GetToggle(2, "BlessingofSanctuaryEnabled") then return false end
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if friendly.distance > 40 then return false end
        if friendly.hp <= 0 then return false end
        if friendly:IsTotalImmune() then return false end
        if friendly:Buff(buffs.blessing_of_sanctuary) then return false end
        
        local usageMode = A.GetToggle(2, "BlessingofSanctuaryPriority") or "SmartPriority"
        
        -- PRIORITY 1: Healers (always protect healer)
        if friendly.isHealer then
            Aware:displayMessage("Sanctuary - Healer CC Immunity", "Green", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        -- PRIORITY 2: Casters (if Smart Priority mode)
        if usageMode ~= "HealersOnly" and friendly.isCaster then
            Aware:displayMessage("Sanctuary - Caster CC Immunity", "Cyan", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        -- PRIORITY 3: Others (if Use When Available mode)
        if usageMode == "UseWhenAvailable" then
            Aware:displayMessage("Sanctuary - CC Immunity", "Blue", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
        
        return false
end)

-- Blessing of Spellwarding - Party magic immunity (PvP talent)
BlessingofSpellwarding:Callback("pvp_party", function(spell, friendly)
        if friendly:IsMe() then return false end
        if not A.GetToggle(2, "BlessingofSpellwardingEnabled") then return false end
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if friendly.distance > 40 then return false end
        if friendly.hp <= 0 then return false end
        if friendly:IsTotalImmune() then return false end
        if friendly:Buff(buffs.blessing_of_spellwarding) then return false end
        
        -- Check if enemies are magic-heavy (casters/healers)
        local hasMagicDamage = false
        if arena1.exists and (arena1.isCaster or arena1.isHealer) then hasMagicDamage = true end
        if arena2.exists and (arena2.isCaster or arena2.isHealer) then hasMagicDamage = true end
        if arena3.exists and (arena3.isCaster or arena3.isHealer) then hasMagicDamage = true end
        
        if not hasMagicDamage then return false end
        if friendly.hp > 45 then return false end
        
        Aware:displayMessage("Spellwarding - Magic Immunity", "Purple", 1)
        local casted = spell:Cast(friendly)
        if casted then return true end
        return false
end)

-- Divine Steed - Mobility for kiting/gap closing
DivineSteed:Callback("pvp_mobility", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        if not A.GetToggle(2, "DivineSteedEnabled") then return false end
        
        -- Use when being trained by melee
        local meleeOnMe = false
        if arena1.exists and arena1:IsMelee() and arena1.distance < 10 and arena1.target == player then meleeOnMe = true end
        if arena2.exists and arena2:IsMelee() and arena2.distance < 10 and arena2.target == player then meleeOnMe = true end
        if arena3.exists and arena3:IsMelee() and arena3.distance < 10 and arena3.target == player then meleeOnMe = true end
        
        if meleeOnMe and player.hp < 60 then
            Aware:displayMessage("Divine Steed - Kiting!", "Cyan", 1)
            return spell:Cast(player)
        end
        
        return false
end)

-- Divine Shield - Smart PvP emergency immunity
DivineShield:Callback("pvp_emergency", function(spell)
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not player.inCombat then return false end
        
        -- EMERGENCY OVERRIDE: Cast immediately if HP is critically low (<18%)
        if player.hp < 18 and not player:HasDeBuff(debuffs.forbearance) and not player:IsTotalImmune() then
            Aware:displayMessage("Divine Shield - Emergency!", "Red", 1.5)
            return spell:Cast(player)
        end
        
        -- Don't cast immediately after Lay on Hands (wait 1 second to avoid waste)
        if LayonHands.used > 0 and LayonHands.used < 1000 then return false end
        if LayonHandsPassiveToo.used > 0 and LayonHandsPassiveToo.used < 1000 then return end
        
        -- Safety checks
        if player:HasDeBuff(debuffs.forbearance) then return false end
        if player:IsTotalImmune() then return false end
        
        -- Normal HP threshold check
        if player.hp > A.GetToggle(2, "DivineShieldHPPvP") then return false end
        
        Aware:displayMessage("Divine Shield - Defensive!", "Gold", 1)
        return spell:Cast(player)
end)

-- Hammer of Justice - Offensive CC (CC healer during burst)
HammerofJustice:Callback("pvp_offensive", function(spell, enemy)
        if not A.GetToggle(2, "HammerofJusticeEnabled") then return false end
        local usageMode = A.GetToggle(2, "HammerofJusticeMode") or "Smart"
        if usageMode == "Manual" or usageMode == "Defensive" then return false end
        
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not enemy.exists or enemy.hp <= 0 or enemy.distance > 10 then return false end
        if enemy:IsTotalImmune() or enemy:BuffFrom(MakLists.CCImmune) then return false end
        if enemy.ccImmune or enemy.stunDr and enemy.stunDr < 0.25 then return false end
        
        -- Only use during burst windows
        local inBurstWindow = player:Buff(buffs.avenging_wrath)
        if not inBurstWindow then return false end
        
        -- Priority 1: Enemy healer
        if enemy.isHealer then
            Aware:displayMessage("HoJ - Healer CC (Burst)", "Gold", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        -- Priority 2: Enemy casters
        if enemy.isCaster then
            Aware:displayMessage("HoJ - Caster CC (Burst)", "Orange", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        return false
end)

-- Hammer of Justice - Defensive CC (Peel for low HP teammates)
HammerofJustice:Callback("pvp_defensive", function(spell, enemy)
        if not A.GetToggle(2, "HammerofJusticeEnabled") then return false end
        local usageMode = A.GetToggle(2, "HammerofJusticeMode") or "Smart"
        if usageMode == "Manual" or usageMode == "Offensive" then return false end
        
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not enemy.exists or enemy.hp <= 0 or enemy.distance > 10 then return false end
        if enemy:IsTotalImmune() or enemy:BuffFrom(MakLists.CCImmune) then return false end
        if enemy.ccImmune or enemy.stunDr and enemy.stunDr < 0.25 then return false end
        
        local defensiveHpThreshold = A.GetToggle(2, "HammerofJusticeDefensiveHP") or 30
        
        -- Check if player is low HP and being attacked
        if player.hp < defensiveHpThreshold and enemy.target == player then
            Aware:displayMessage("HoJ - Defensive Peel (Self)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        -- Check if party members are low HP and being attacked
        if party1.exists and party1.hp < defensiveHpThreshold and party1.hp > 0 and enemy.target == party1 then
            Aware:displayMessage("HoJ - Defensive Peel (Party)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        if party2.exists and party2.hp < defensiveHpThreshold and party2.hp > 0 and enemy.target == party2 then
            Aware:displayMessage("HoJ - Defensive Peel (Party)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        -- Priority peel for healer
        if party1.exists and party1.isHealer and party1.hp < (defensiveHpThreshold + 15) and party1.hp > 0 and enemy.target == party1 then
            Aware:displayMessage("HoJ - Healer Peel", "Purple", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        if party2.exists and party2.isHealer and party2.hp < (defensiveHpThreshold + 15) and party2.hp > 0 and enemy.target == party2 then
            Aware:displayMessage("HoJ - Healer Peel", "Purple", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        return false
end)

-- Blinding Light - Offensive CC (Blind enemies during burst)
BlindingLight:Callback("pvp_offensive", function(spell, enemy)
        if not A.GetToggle(2, "BlindingLightEnabled") then return false end
        local usageMode = A.GetToggle(2, "BlindingLightMode") or "Smart"
        if usageMode == "Manual" or usageMode == "Defensive" then return false end
        
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not enemy.exists or enemy.hp <= 0 or enemy.distance > 25 then return false end
        if enemy:IsTotalImmune() or enemy:BuffFrom(MakLists.CCImmune) then return false end
        if enemy.ccImmune then return false end
        
        -- Only use during burst windows
        local inBurstWindow = player:Buff(buffs.avenging_wrath)
        if not inBurstWindow then return false end
        
        -- Priority 1: Enemy healer
        if enemy.isHealer then
            Aware:displayMessage("Blinding Light - Healer (Burst)", "Gold", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        -- Priority 2: Enemy casters
        if enemy.isCaster then
            Aware:displayMessage("Blinding Light - Caster (Burst)", "Orange", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        return false
end)

-- Blinding Light - Defensive CC (Disrupt enemy casts)
BlindingLight:Callback("pvp_defensive", function(spell, enemy)
        if not A.GetToggle(2, "BlindingLightEnabled") then return false end
        local usageMode = A.GetToggle(2, "BlindingLightMode") or "Smart"
        if usageMode == "Manual" or usageMode == "Offensive" then return false end
        
        if Action.Zone ~= "arena" and not A.IsInPvP then return false end
        if not enemy.exists or enemy.hp <= 0 or enemy.distance > 25 then return false end
        if enemy:IsTotalImmune() or enemy:BuffFrom(MakLists.CCImmune) then return false end
        if enemy.ccImmune then return false end
        
        local defensiveHpThreshold = A.GetToggle(2, "BlindingLightDefensiveHP") or 40
        
        -- Check if player is low HP and being attacked
        if player.hp < defensiveHpThreshold and enemy.target == player then
            Aware:displayMessage("Blinding Light - Defensive (Self)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        -- Check if party members are low HP and being attacked
        if party1.exists and party1.hp < defensiveHpThreshold and party1.hp > 0 and enemy.target == party1 then
            Aware:displayMessage("Blinding Light - Defensive (Party)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        if party2.exists and party2.hp < defensiveHpThreshold and party2.hp > 0 and enemy.target == party2 then
            Aware:displayMessage("Blinding Light - Defensive (Party)", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
        
        return false
end)

GuardianOfTheForgottenQueen:Callback(function(spell)
    if not spell:ReadyToUse() then return end
    local party = MakuluFramework.MultiUnits.party
    local u = party:Find(function(m)
        if not m.exists or m:IsDeadOrGhost() or not m:IsFriendly() then return end
        if spell:HasRange() and not spell:InRange(m) then return end
        if m.Los and not m:Los() then return end
        if (m.IsTotalImmune and m:IsTotalImmune()) or (m.IsMagicImmune and m:IsMagicImmune()) then return end
        return m:Health() <= 25
    end)
    if not u then return end
    return spell:Cast(u)
end)


-- ============================================================================
-- RITE ABILITIES MANAGEMENT
-- ============================================================================
-- Weapon enchants that provide stat buffs and armor increases
-- Rite of Sanctification: +5% armor, +2% primary stat (Strength for Prot)
-- Rite of Adjuration: +5% armor, +2% stamina

-- Rite of Sanctification - Weapon enchant for armor and strength
RiteofSanctification:Callback("rite_management", function(spell)
        if not A.GetToggle(2, "RiteManagementEnabled") then return false end
        if not A.GetToggle(2, "RiteofSanctificationEnabled") then return false end
        if player.mounted then return false end
        if player.inCombat then return false end
        
        -- Prevent rapid recasting - wait at least 500ms between casts
        if spell:Used() > 0 and spell:Used() < 500 then return false end
        
        -- Check weapon enchant status
        local hasMainHandEnchant, mainHandExpiration = GetWeaponEnchantInfo()
        
        -- Reapply if enchant is missing or expiring soon (within 30 minutes)
        if not hasMainHandEnchant or mainHandExpiration <= 1800000 then
            Aware:displayMessage("Rite of Sanctification - Applying", "Blue", 1)
            return spell:Cast(player)
        end
        
        return false
end)

-- Rite of Adjuration - Weapon enchant for armor and stamina
RiteofAdjuration:Callback("rite_management", function(spell)
        if not A.GetToggle(2, "RiteManagementEnabled") then return false end
        if not A.GetToggle(2, "RiteofAdjurationEnabled") then return false end
        if player.mounted then return false end
        if player.inCombat then return false end
        
        -- Prevent rapid recasting - wait at least 500ms between casts
        if spell:Used() > 0 and spell:Used() < 500 then return false end
        
        -- Check weapon enchant status
        local hasMainHandEnchant, mainHandExpiration = GetWeaponEnchantInfo()
        
        -- Reapply if enchant is missing or expiring soon (within 30 minutes)
        if not hasMainHandEnchant or mainHandExpiration <= 1800000 then
            Aware:displayMessage("Rite of Adjuration - Applying", "Blue", 1)
            return spell:Cast(player)
        end
        
        return false
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if Action.Zone ~= "arena" then return end
    
    -- PvP CC and interrupt abilities (priority order: hard CC > soft CC > interrupts)
    HammerofJustice("pvp_offensive", enemy)  -- Offensive: CC healer during burst
    HammerofJustice("pvp_defensive", enemy)  -- Defensive: Peel for low HP teammates
    BlindingLight("pvp_offensive", enemy)    -- Offensive: Blind during burst
    BlindingLight("pvp_defensive", enemy)    -- Defensive: Disrupt casts
                     -- Interrupt
    
end


local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end
    
    -- PvP party support (arena-specific)
    if Action.Zone == "arena" or A.IsInPvP then
        BlessingofFreedom("pvp_party", friendly)      -- Remove roots/slows
        BlessingofSanctuary("pvp_party", friendly)    -- CC immunity
        BlessingofSpellwarding("pvp_party", friendly) -- Magic immunity
    end
    
    -- Standard party support (PvE and PvP)
    GuardianOfTheForgottenQueen()
    LayonHands("partyrot", friendly)
    LayonHandsPassiveToo("passive", friendly)
    BlessingofProtection("partyrot", friendly)
    WordofGlory("partyrotfree", friendly)
    WordofGlory("partyrot", friendly)
    CleanseToxins("partyrot", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    if targetForInterrupt(interrupts) then
        return TabTarget()
    end
    if AutoTarget() then
        return TabTarget()
    end
    enemyRotation(arena1)
    partyRotation(party1)
    
    return FrameworkEnd()
end

A[7] = function(icon)
    RegisterIcon(icon)
    enemyRotation(arena2)
    partyRotation(party2)
    
    return FrameworkEnd()
end

A[8] = function(icon)
    RegisterIcon(icon)
    enemyRotation(arena3)
    partyRotation(party3)
    
    return FrameworkEnd()
end

A[9] = function(icon)
    RegisterIcon(icon)
    partyRotation(party4)
    
    return FrameworkEnd()
end

A[10] = function(icon)
    RegisterIcon(icon)
    partyRotation(player)
    
    return FrameworkEnd()
end
