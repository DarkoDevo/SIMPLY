if not MakuluValidCheck() then return true end
if not (Makulu_magic_number == 2347956243324) then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 259 then return end

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
local IsInPvp          = MakuluFramework.InPvpInstance
local ConstCell        = cacheContext:getConstCacheCell()

local Action           = _G.Action
local ActionUnit       = Action.Unit
local ActionPlayer     = Action.Player
local MultiUnits       = Action.MultiUnits
local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable

local isInArena = false 

local buffs = {
    arena_preparation = 32727,
    power_infusion = 10060,
    
    stealth = 1784,
    stealthed_improved_garrote = 392403,
    stealthed_improved_garrote_too = 392401,
    master_assassin = 256735,
    kingsbane = 385627,
    shiv = 319504,
    envenom = 32645,
    rupture = 1943,
    scent_of_blood = 394080,
    indiscriminate_carnage = 385754,
    slice_and_dice = 315496,
    edge_case = 453457,
    darkest_night = 457058,
    clear_the_witnesses = 457053,
    blindside = 328085,
    thistle_tea = 381623,
    fatebound_lucky_coin = 461818,
    fatebound_coin_tails = 452917,
    fatebound_coin_heads = 452923,
    vanish = 11327,
    momentum_of_despair = 457067,
    cold_blood = 456330,
    cold_blood_2 = 382245,
    cloak_of_shadows = 31224,

    wounded_poison = 8679,
    deadly_poison = 2823,
    atrophic_poison = 381637,
    crippling_poison = 3408,
    amplifying_poison = 381664,
    instant_poison = 315584,
    subterfuge = 115192,

    
    -- Season 3 Tier Set Buffs
    tier_2p_deathstalker = 1236400, -- Shiv increases Deathstalker effects by 50%
    tier_4p_deathstalker = 1236401, -- Shiv +2s duration, consumes Deathstalker's Mark
    tier_2p_fatebound = 1236402, -- Kingsbane +10% damage, +4s duration
    tier_4p_fatebound = 1236403, -- Lucky coin reduces cooldowns
}

local debuffs = {
    exhaustion = 57723,

    deathstalkers_mark = 457126,
    crimson_tempest = 121411,
    deathmark = 360194,
    rupture = 1943,
    garrote = 703,
    garrote_silence = 1330,
    caustic_spatter = 421976,
    kingsbane = 385627,
    sap = 6770,
    kidney_shot = 408,
    cheap_shot = 1833,
    shiv = 319504
}

local ActionID = {
    Ambush                = { ID = 8676, MAKULU_INFO = { damageType = "physical" } },
    AmplifyingPoision     = { ID = 381664 },
    ArterialPrecision     = { ID = 400783 },
    AtrophicPoison        = { ID = 381637 },
    Blind                 = { ID = 2094, MAKULU_INFO = { cc = true } },
    Blindside             = { ID = 328085 },
    BloodFury             = { ID = 20572 },
    BloodyMess            = { ID = 381626 },
    CausticSpatter        = { ID = 421975, Hidden = true },
    CausticSplatter       = { ID = 421975 },
    CheapShot             = { ID = 1833, MAKULU_INFO = { damageType = "physical", cc = true } },
    CleartheWitnesses     = { ID = 457053, Hidden = true },
    CloakofShadows        = { ID = 31224 },
    ColdBlood             = { ID = 382245, MAKULU_INFO = { offGcd = true } },
    CrimsonTempest        = { ID = 121411, MAKULU_INFO = { damageType = "physical" } },
    CrimsonVial           = { ID = 185311, MAKULU_INFO = { heal = true } },
    CripplingPoison       = { ID = 3408 },
    CuttotheChase         = { ID = 51664 },
    DarkestNight          = { ID = 457058, Hidden = true },
    DashingScoundrel      = { ID = 381797 },
    DeadlyPoison          = { ID = 2823 },
    DeathfromAbove        = { ID = 269513, MAKULU_INFO = { damageType = "physical" } },
    Deathmark             = { ID = 360194, MAKULU_INFO = { damageType = "magic" } },
    DeathstalkersMark     = { ID = 457052, Hidden = true },
    DeeperStratagem       = { ID = 193531, Hidden = true },
    Dismantle             = { ID = 207777 },
    Distract              = { ID = 1725 },
    Doomblade             = { ID = 381673 },
    DragonTemperedBlades  = { ID = 381801 },
    EchoingReprimand      = { ID = 385616, MAKULU_INFO = { damageType = "physical" } },
    EdgeCase              = { ID = 453457, Hidden = true },
    Envenom               = { ID = 32645, MAKULU_INFO = { damageType = "magic" } },
    Evasion               = { ID = 5277 },
    FanofKnives           = { ID = 51723, MAKULU_INFO = { damageType = "physical" } },
    FatalConcoction       = { ID = 334701 },
    FateboundLuckyCoin    = { ID = 452923, Hidden = true },
    Feint                 = { ID = 1966 },
    FlyingDaggers         = { ID = 381631 },
    Garrote               = { ID = 703, MAKULU_INFO = { damageType = "physical" } },
    Gouge                 = { ID = 1776, MAKULU_INFO = { damageType = "physical", cc = true } },
    HandofFate            = { ID = 452536, Hidden = true },
    ImprovedGarrote       = { ID = 381632 },
    ImprovedPoisons       = { ID = 381624 },
    ImprovedShiv          = { ID = 319032 },
    IndiscriminateCarnage = { ID = 381802 },
    InstantPoision        = { ID = 315584 },
    IntenttoKill          = { ID = 381630 },
    InternalBleeding      = { ID = 381627 },
    IronWire              = { ID = 196861 },
    Kick                  = { ID = 1766, MAKULU_INFO = { damageType = "physical" } },
    KidneyShot            = { ID = 408, MAKULU_INFO = { damageType = "physical", cc = true } },
    Kingsbane             = { ID = 385627, MAKULU_INFO = { damageType = "magic" } },
    LethalDose            = { ID = 381640 },
    LightweightShiv       = { ID = 394983 },
    MasterAssassin        = { ID = 255989 },
    MomentumofDespair     = { ID = 457067, Hidden = true },
    Mutilate              = { ID = 1329, MAKULU_INFO = { damageType = "physical" } },
    NumbingPoison         = { ID = 5761 },
    PathofBlood           = { ID = 423054 },
    PickLock              = { ID = 1804 },
    PickPocket            = { ID = 921 },
    PoisonBomb            = { ID = 255544, MAKULU_INFO = { damageType = "magic" } },
    PoisonedKnife         = { ID = 185565, MAKULU_INFO = { damageType = "physical" } },
    Rupture               = { ID = 1943, MAKULU_INFO = { damageType = "physical" } },
    SanguineBlades        = { ID = 200806 },
    Sap                   = { ID = 6770, MAKULU_INFO = { cc = true } },
    ScentofBlood          = { ID = 381799 },
    SealFate              = { ID = 14190 },
    SecretStratagem       = { ID = 394320, Hidden = true },
    Sepsis                = { ID = 385408, MAKULU_INFO = { damageType = "magic" } },
    SerratedBoneSpike     = { ID = 385424, MAKULU_INFO = { damageType = "physical" } },
    ShadowStep            = { ID = 36554, MAKULU_INFO = { ignoreMoving = true } },
    Shiv                  = { ID = 5938 },
    ShroudedSuffocation   = { ID = 385478 },
    ShroundofConcealment  = { ID = 114018 },
    SinisterStrike        = { ID = 1752, MAKULU_INFO = { damageType = "physical" } },
    SliceandDice          = { ID = 315496 },
    SmokeBomb             = { ID = 212182 },
    Sprint                = { ID = 2983, MAKULU_INFO = { ignoreMoving = true } },
    Stealth               = { ID = 1784 },
    Subterfuge            = { ID = 115192 },
    SuddenDemise          = { ID = 423136 },
    SystemicFailure       = { ID = 381652 },
    ThistleTea            = { ID = 381623 },
    ThrownPrecision       = { ID = 381629 },
    TinyToxicBlade        = { ID = 381800 },
    TricksoftheTrade      = { ID = 57934 },
    TwisttheKnife         = { ID = 381669 },
    Vanish                = { ID = 1856 },
    VeilofMidnight        = { ID = 198952 },
    VenomRush             = { ID = 152152 },
    VenomousWounds        = { ID = 79134 },
    ViciousVenoms         = { ID = 381634 },
    WoundPoison           = { ID = 8679 },
    ZoldyckRecipe         = { ID = 381798 },
    
    Universal1Unit1 = { ID = 703, FixedTexture = 133667, Hidden = false, Macro = "/cast [@arena1] Garrote" },
    Universal1Unit2 = { ID = 703, FixedTexture = 133667, Hidden = false, Macro = "/cast [@arena2] Garrote" },
    Universal1Unit3 = { ID = 703, FixedTexture = 133667, Hidden = false, Macro = "/cast [@arena3] Garrote" },

    Universal2Unit1 = { ID = 1943, FixedTexture = 133663, Hidden = false, Macro = "/cast [@arena1] Rupture" },
    Universal2Unit2 = { ID = 1943, FixedTexture = 133663, Hidden = false, Macro = "/cast [@arena2] Rupture" },
    Universal2Unit3 = { ID = 1943, FixedTexture = 133663, Hidden = false, Macro = "/cast [@arena3] Rupture" },
    -- Season 3 "Shroud of the Sudden Eclipse" Tier Set Bonuses
    TierSet2PieceDeathstalker = { ID = 1236400, Hidden = true }, -- Shiv increases Deathstalker effects by 50%
    TierSet4PieceDeathstalker = { ID = 1236401, Hidden = true }, -- Shiv +2s duration, consumes Deathstalker's Mark
    TierSet2PieceFatebound = { ID = 1236402, Hidden = true }, -- Kingsbane +10% damage, +4s duration, Edge Case triggers
    TierSet4PieceFatebound = { ID = 1236403, Hidden = true }, -- Lucky coin reduces Deathmark CD by 30s, Kingsbane by 15s
    
    -- Tier Set Buff Tracking
    DeathstalkerTierBuff = { ID = 1236400, Hidden = true }, -- 2-piece buff tracking
    FateboundTierBuff = { ID = 1236402, Hidden = true }, -- 2-piece buff tracking
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_ROGUE_ASSASSINATION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

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

local interrupts = {
    { spell = Kick },
    { spell = CheapShot, isCC = true },
    { spell = Gouge, isCC = true },
    { spell = KidneyShot, isCC = true }
}

local function EnemiesInSpellRange(makulu_spell)
    return ConstCell:GetOrSet("enemiesIn" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and not enemy.isPet and not enemy.isFriendly and (enemy.inCombat or enemy.isDummy) then
                    total = total + 1
                end
            end
            return total
    end)
end

local function EnemiesInSpellRangeWithoutDebuff(makulu_spell, debuff_id)
    return ConstCell:GetOrSet("enemiesInDebuff" .. makulu_spell.id .. debuff_id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and (enemy.inCombat or enemy.isDummy) and not enemy.isPet and not enemy.isFriendly and not enemy:Debuff(debuff_id) then
                    total = total + 1
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
                if makulu_spell:InRange(enemy) and enemy:IsTotem() and not enemy.isFriendly then
                    return true
                end
            end 
            return false
    end)
end

local function LongestTTDRange(makulu_spell)
    return ConstCell:GetOrSet("longestTTDRange" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local biggest_ttd = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and (enemy.inCombat or enemy.isDummy) and not enemy:IsTotem() and not enemy.isFriendly then
                    if enemy.ttd > biggest_ttd then
                        biggest_ttd = enemy.ttd
                    end
                end
            end
            return biggest_ttd
    end)
end

local function AutoTarget()
    if not player.inCombat then return false end
    
    if A.IsInPvP then return false end
    
    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end
    
    if TotemsInSpellRange(Ambush) and not target:IsTotem() then
        return true
    end
    
    if Ambush:InRange(target) and target.exists and (target.hp < 20 or target:Debuff(debuffs.deathmark, true) or target:Debuff(debuffs.kingsbane, true)) then 
        return false
    end
    
    if not target:Debuff(debuffs.garrote, true) or not target:Debuff(debuffs.rupture, true) then
        return false
    end
    
    if EnemiesInSpellRangeWithoutDebuff(Ambush, debuffs.garrote) < EnemiesInSpellRange(Ambush) then
        return true
    end
    
    if Ambush:InRange(target) and target.exists then return false end
    
    if EnemiesInSpellRange(Ambush) > 0 then
        return true
    end
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()
    return incomingDamage and not defensiveActive()
end

local function IsDisarmed(unitID)
    return unitID:Buff(236077)
end

local function ShouldWeDisarm(unitID)
    if unitID.isHealer then return false end
    if unitID.isFriendly then return false end
    if not unitID.isMelee then return false end
    if not unitID.cds or unitID.hp < player.hp + 10 then return false end
    if IsDisarmed(unitID) then return false end
    
    if unitID.cds or (healer.exists and healer.cc) then
        return true
    end
    return false
end

local function updateGameState()
    gameState = {
        TWW1has2P = player:Has2Set(),
        TWW1has4P = player:Has4Set(),
        power_regen = GetPowerRegen(),
        regen_saturated = GetPowerRegen() > 30 and 1 or 0,
        in_ten_range = EnemiesInSpellRange(Garrote),
        single_target = EnemiesInSpellRange(Garrote) < 2,
        effective_spend_cp = math.min(player.comboPointsMax - 1, 5 * player:TalentKnownInt(HandofFate.id)),
        -- Season 3 Optimized Energy Management: Simplified pooling logic
        not_pooling = (target:Debuff(debuffs.deathmark, true) or target:Debuff(debuffs.kingsbane, true) or player:Debuff(debuffs.shiv))
        or (player:Buff(buffs.envenom) and player:BuffRemains(buffs.envenom) <= 1500) -- Extended window
        or player.energy >= (35 + 25 * player:TalentKnownInt(HandofFate.id) - 10 * player:TalentKnownInt(ViciousVenoms.id)) -- Reduced thresholds
        or LongestTTDRange(PoisonedKnife) <= 20000
        or (player:Has4Set() and player:Buff(buffs.fatebound_lucky_coin)), -- Tier set consideration
        
        -- Season 3 Tier Set Integration
        tier_2p_active = player:Has2Set(),
        tier_4p_active = player:Has4Set(),
        is_deathstalker = player:TalentKnown(DeathstalkersMark.id),
        is_fatebound = player:TalentKnown(FateboundLuckyCoin.id),
        
        -- Tier Set Enhanced Abilities
        shiv_enhanced = player:Has2Set() and player:TalentKnown(DeathstalkersMark.id),
        kingsbane_enhanced = player:Has2Set() and player:TalentKnown(FateboundLuckyCoin.id),
        cooldown_reduction_active = player:Has4Set() and player:Buff(buffs.fatebound_lucky_coin)
    }
    
    arena1 = MakUnit:new("arena1")
    arena2 = MakUnit:new("arena2")
    arena3 = MakUnit:new("arena3")
    target = MakUnit:new("target")
    
    if isInArena then
        if arena1.exists and not arena1.isFriendly and arena1.isHealer then
            enemyHealer = arena1
        elseif arena2.exists and not arena2.isFriendly and arena2.isHealer then
            enemyHealer = arena2
        elseif arena3.exists and not arena3.isFriendly and arena3.isHealer then
            enemyHealer = arena3
        end
        
        if (arena1.exists and arena1.bcc and Garrote:InRange(arena1))
        or (arena2.exists and arena2.bcc and Garrote:InRange(arena2))
        or (arena3.exists and arena3.bcc and Garrote:InRange(arena3)) then
            gameState.arena_breakable = true
        end
    end
end

local function checkIfAntiCCConds(unit)
    if unit.CastInfo and unit:CastInfo().percent > 25 then return true end
    return false
end

local function ShouldWeBurst()
    return ConstCell:GetOrSet("shouldWeBurst", function()
            if isInArena then
                if (Deathmark:Usable(target) or target:Debuff(debuffs.deathmark, true)) and not target.totalImmune and not target.physImmune 
                and (not target.bcc or target.hp < 30) and (not target.hasDefensive or target.hp < 25) then
                    if target.hp < 55 and (not enemyHealer or not enemyHealer.exists or enemyHealer.cc) then
                        return true
                    elseif target.hp < 45 then
                        return true
                    end
                end
            else
                if Action.BurstIsON("target") then
                    return true
                end
            end
            return false
    end)
end

-- Callbacks remain the same logic, each condition combined into one if statement if possible

CloakofShadows:Callback(function(spell)
        if player.stealthed then return end
        
        if target.magicCds and (ActionUnit("player"):TimeToDieMagicX(25) >= 2 or player.hp < 40) then
            return spell:Cast(player)
        end
end)

DeathfromAbove:Callback("gapcloser", function(spell, who)
        if isInArena
        and spell:InRange(who)
        and player.comboPoints >= 3
        and not player:Buff(buffs.sprint) then
            return spell:Cast(who)
        end
end)

Stealth:Callback("ooc", function(spell)
        if not player:IsStealthed() then
            return spell:Cast(player)
        end
end)

-- Stealthed conditions remain as before (single checks)
Ambush:Callback("stealthed", function(spell)
        if not target:Debuff(debuffs.deathstalkers_mark) and player:TalentKnown(DeathstalkersMark.id) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("stealthed", function(spell)
        if player:TalentKnown(Kingsbane.id)
        and (target:Debuff(debuffs.kingsbane, true) or Kingsbane.cd == 0)
        and not player:Debuff(debuffs.shiv)
        and player:Buff(buffs.envenom) then
            return spell:Cast(target)
        end
end)

Envenom:Callback("stealthed", function(spell)
        if player.comboPoints >= gameState.effective_spend_cp
        and target:Debuff(debuffs.kingsbane, true)
        and player:BuffRemains(buffs.envenom) <= 3000
        and (target:Debuff(debuffs.deathstalkers_mark, true) or player:Buff(buffs.edge_case) or player:Buff(buffs.cold_blood)) then
            return spell:Cast(target)
        end
end)

Envenom:Callback("stealthed2", function(spell)
        if player.comboPoints >= gameState.effective_spend_cp
        and player:Buff(buffs.master_assassin)
        and gameState.single_target
        and (target:Debuff(debuffs.deathstalkers_mark, true) or player:Buff(buffs.edge_case) or player:Buff(buffs.cold_blood)) then
            return spell:Cast(target)
        end
end)

Rupture:Callback("stealthed", function(spell)
        if player.comboPoints >= gameState.effective_spend_cp
        and player:Buff(buffs.indiscriminate_carnage)
        and target:DebuffRemains(debuffs.rupture, true) < 3500
        and (not gameState.regen_saturated or not player:Buff(buffs.scent_of_blood) or not target:Debuff(debuffs.rupture, true))
        and target.ttd > 1500 then
            return spell:Cast(target)
        end
end)

Garrote:Callback("stealthed", function(spell)
        if player:Buff(buffs.stealthed_improved_garrote)
        and (target:DebuffRemains(debuffs.garrote, true) < 12000 or target:HasDeBuffCount(debuffs.garrote, true) <= 1
            or (player:Buff(buffs.indiscriminate_carnage) and gameState.in_ten_range > 1))
        and not gameState.single_target
        and target.ttd - target:DebuffRemains(debuffs.garrote, true) > 200 then
            return spell:Cast(target)
        end
end)

Garrote:Callback("stealthed2", function(spell)
        if player:Buff(buffs.stealthed_improved_garrote)
        and (target:HasDeBuffCount(debuffs.garrote, true) <= 1
            or target:DebuffRemains(debuffs.garrote, true) < 12000
            or (not gameState.single_target and player:BuffRemains(buffs.master_assassin) < 3000))
        and player.comboPoints <= 1 + 2 * player:TalentKnownInt(ShroudedSuffocation.id) then
            return spell:Cast(target)
        end
end)

local function stealthed_list()
    if player:Buff(buffs.stealth) or player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.master_assassin) then
        Ambush("stealthed")
        Shiv("stealthed")
        Envenom("stealthed")
        Envenom("stealthed2")
        Rupture("stealthed")
        Garrote("stealthed")
        Garrote("stealthed2")
    end
end

SliceandDice:Callback("regular", function(spell)
        if not player:Buff(buffs.slice_and_dice)
        and target:Debuff(debuffs.rupture, true)
        and player.comboPoints >= 1
        and (not player:Buff(buffs.indiscriminate_carnage) or gameState.single_target) then
            return spell:Cast(player)
        end
end)

Envenom:Callback("regular", function(spell)
        if player:Buff(buffs.slice_and_dice)
        and player:BuffRemains(buffs.slice_and_dice) < 5000
        and player.comboPoints >= 5 then
            return spell:Cast(target)
        end
end)

-- Shiv conditions remain single if checks
Shiv:Callback("shiv", function(spell)
        if player:TalentKnown(ArterialPrecision.id)
        and gameState.shiv_condition
        and gameState.in_ten_range >= 4
        and target:Debuff(debuffs.crimson_tempest, true) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("shiv2", function(spell)
        if not player:TalentKnown(LightweightShiv.id)
        and gameState.shiv_kingsbane_condition
        and ((target:Debuff(debuffs.kingsbane, true) and target:DebuffRemains(debuffs.kingsbane, true) < 8000)
            or (not target:Debuff(debuffs.kingsbane, true) and Kingsbane.cd >= 24000))
        and (not player:TalentKnown(CrimsonTempest.id) or gameState.single_target or target:Debuff(debuffs.crimson_tempest, true)) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("shiv3", function(spell)
        if player:TalentKnown(LightweightShiv.id)
        and gameState.shiv_kingsbane_condition
        and (target:Debuff(debuffs.kingsbane, true) or Kingsbane.cd <= 1000) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("shiv4", function(spell)
        if player:TalentKnown(ArterialPrecision.id)
        and gameState.shiv_condition
        and target:Debuff(debuffs.deathmark, true) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("shiv5", function(spell)
        if not player:TalentKnown(Kingsbane.id)
        and not player:TalentKnown(ArterialPrecision.id)
        and gameState.shiv_condition
        and (not player:TalentKnown(CrimsonTempest.id) or gameState.single_target or target:Debuff(debuffs.crimson_tempest, true)) then
            return spell:Cast(target)
        end
end)

Shiv:Callback("shiv6", function(spell)
        if LongestTTDRange(PoisonedKnife) <= Shiv.frac * 8000 then
            return spell:Cast(target)
        end
end)

-- Season 3 Tier Set Enhanced Shiv Logic
Shiv:Callback("tier_enhanced", function(spell)
        -- Deathstalker 2-piece: Shiv increases Deathstalker effects by 50%
        if gameState.shiv_enhanced
        and gameState.shiv_condition
        and target:Debuff(debuffs.deathstalkers_mark, true)
        and (target:Debuff(debuffs.deathmark, true) or player:Buff(buffs.darkest_night)) then
            return spell:Cast(target)
        end
end)

-- Season 3 Tier Set 4-piece: Enhanced Shiv duration and Deathstalker's Mark consumption
Shiv:Callback("tier_4p_enhanced", function(spell)
        if gameState.tier_4p_active
        and gameState.is_deathstalker
        and gameState.shiv_condition
        and target:Debuff(debuffs.deathstalkers_mark, true)
        and target:DebuffCount(debuffs.deathstalkers_mark, true) >= 2 then
            return spell:Cast(target)
        end
end)

local function shiv_list()
    gameState.shiv_condition = not target:Debuff(debuffs.shiv, true)
    and target:Debuff(debuffs.garrote, true)
    and target:Debuff(debuffs.rupture, true)
    gameState.shiv_kingsbane_condition = player:TalentKnown(Kingsbane.id)
    and player:Buff(buffs.envenom)
    and gameState.shiv_condition
    
    -- Season 3 Tier Set Enhanced Shiv Priority
    Shiv("tier_4p_enhanced")
    Shiv("tier_enhanced")
    
    -- Standard Shiv Priority
    Shiv("shiv")
    Shiv("shiv2")
    Shiv("shiv3")
    Shiv("shiv4")
    Shiv("shiv5")
    Shiv("shiv6")
end

PoolResources:Callback("vanish", function(spell)
        if player.energy < 45 then
            return
        end
end)

local last_vanish = time()

Vanish:Callback(function(spell)
        if player:Buff(buffs.stealth) then return end
        if not isInArena then return end
end)

Vanish:Callback("vanish", function(spell)
        if not player:Buff(buffs.fatebound_lucky_coin)
        and (player:HasBuffCount(buffs.fatebound_coin_tails) >= 5 or player:HasBuffCount(buffs.fatebound_coin_heads) >= 5) then
            last_vanish = time()
            return spell:Cast(player)
        end
end)

Vanish:Callback("vanish2", function(spell)
        if not player:TalentKnown(MasterAssassin.id)
        and not player:TalentKnown(IndiscriminateCarnage.id)
        and player:TalentKnown(ImprovedGarrote.id)
        and Garrote.cd == 0
        and (not target:Debuff(debuffs.garrote, true) or target:DebuffRemains(debuffs.garrote, true) < 12000)
        and (target:Debuff(debuffs.deathmark, true) or Deathmark.cd < 5000)
        and player.comboPoints >= 3 then
            last_vanish = time()
            return spell:Cast(player)
        end
end)

Vanish:Callback("vanish3", function(spell)
        if not player:TalentKnown(MasterAssassin.id)
        and player:TalentKnown(IndiscriminateCarnage.id)
        and player:TalentKnown(ImprovedGarrote.id)
        and Garrote.cd == 0
        and (target:HasDeBuffCount(debuffs.garrote, true) <= 1 or target:DebuffRemains(debuffs.garrote, true) < 12000)
        and gameState.in_ten_range > 2
        and (target.ttd - target:DebuffRemains(debuffs.garrote, true) > 1500 or player.combatTime > 2000) then
            last_vanish = time()
            return spell:Cast(player)
        end
end)

Vanish:Callback("vanish4", function(spell)
        if not player:TalentKnown(ImprovedGarrote.id)
        and player:TalentKnown(MasterAssassin.id)
        and target:DebuffRemains(debuffs.rupture, true) > 3000
        and target:DebuffRemains(debuffs.garrote, true) > 3000
        and target:Debuff(debuffs.deathmark, true)
        and (target:Debuff(debuffs.shiv) or target:DebuffRemains(debuffs.deathmark) < 4000) then
            last_vanish = time()
            return spell:Cast(player)
        end
end)

Vanish:Callback("vanish5", function(spell)
        if player:TalentKnown(ImprovedGarrote.id)
        and Garrote.cd == 0
        and (target:HasDeBuffCount(debuffs.garrote, true) <= 1 or target:DebuffRemains(debuffs.garrote, true) < 12000)
        and (target:Debuff(debuffs.deathmark, true) or Deathmark.cd < 4000)
        and player.combatTime > 3000 then
            last_vanish = time()
            return spell:Cast(player)
        end
end)

local function vanish_list()
    if player.stealthed then return end
    if time() - last_vanish < 30 then return end
    
    PoolResources("vanish")
    Vanish("vanish")
    Vanish("vanish2")
    PoolResources("vanish")
    Vanish("vanish3")
    Vanish("vanish4")
    Vanish("vanish5")
end

Deathmark:Callback("cds", function(spell)
        if (gameState.deathmark_condition and target.ttd >= 10000) or LongestTTDRange(PoisonedKnife) <= 20000 then
            return spell:Cast(target)
        end
end)

Kingsbane:Callback("cds", function(spell)
        if ((player:Debuff(debuffs.shiv) or Shiv.cd < 6000)
            and player:Buff(buffs.envenom)
            and (Deathmark.cd >= 5000 or target:Debuff(debuffs.deathmark, true)))
        or LongestTTDRange(PoisonedKnife) <= 15000 then
            return spell:Cast(target)
        end
end)

-- Season 3 Tier Set Enhanced Kingsbane for Fatebound
Kingsbane:Callback("tier_enhanced", function(spell)
        -- Fatebound 2-piece: Kingsbane +10% damage, +4s duration, Edge Case triggers
        if gameState.kingsbane_enhanced
        and gameState.is_fatebound
        and ((player:Debuff(debuffs.shiv) or Shiv.cd < 6000)
            and player:Buff(buffs.envenom)
            and (Deathmark.cd >= 5000 or target:Debuff(debuffs.deathmark, true)))
        and (not gameState.cooldown_reduction_active or Kingsbane.cd <= 1000) then
            return spell:Cast(target)
        end
end)

ThistleTea:Callback("cds", function(spell)
        if ThistleTea.frac < 1 or player.energy >= 200 then return end
        
        if not player:Buff(buffs.thistle_tea)
        and (((player.energyDeficit >= 100 + gameState.power_regen or ThistleTea.frac >= 3)
                and player:DebuffRemains(debuffs.shiv) >= 4000)
            or (gameState.in_ten_range >= 4 and player:DebuffRemains(debuffs.shiv) >= 6000))
        or LongestTTDRange(PoisonedKnife) < ThistleTea.frac * 6000 then
            return spell:Cast(player)
        end
end)

BloodFury:Callback("misc_cds", function(spell)
        if target:Debuff(debuffs.deathmark, true) then
            return spell:Cast(player)
        end
end)

Berserking:Callback("misc_cds", function(spell)
        if target:Debuff(debuffs.deathmark, true) then
            return spell:Cast(player)
        end
end)

Fireblood:Callback("misc_cds", function(spell)
        if target:Debuff(debuffs.deathmark, true) then
            return spell:Casts(player)
        end
end)

AncestralCall:Callback("misc_cds", function(spell)
        if ((not player:TalentKnown(Kingsbane.id) and target:Debuff(debuffs.deathmark, true) and player:Debuff(debuffs.shiv))
            or (player:TalentKnown(Kingsbane.id)
                and target:Debuff(debuffs.deathmark, true)
                and target:Debuff(debuffs.kingsbane, true)
                and target:DebuffRemains(debuffs.kingsbane, true) < 8000)) then
            return spell:Cast(player)
        end
end)

-- actions.cds+=/cold_blood,use_off_gcd=1,if=(buff.fatebound_coin_tails.stack>0&buff.fatebound_coin_heads.stack>0)|debuff.shiv.up&(cooldown.deathmark.remains>50&(!set_bonus.tww3_fatebound_4pc)|dot.kingsbane.ticking&(set_bonus.tww3_fatebound_4pc)|!talent.inevitabile_end&effective_combo_points>=variable.effective_spend_cp)
ColdBlood:Callback("cds", function(spell)
        if (player:HasBuffCount(buffs.fatebound_coin_tails) > 0 and player:HasBuffCount(buffs.fatebound_coin_heads) > 0)
        or (player:Debuff(debuffs.shiv, true)
            and (Deathmark.cd > 5000 and not gameState.TWW1has4P
                or target:Debuff(debuffs.kingsbane, true) and gameState.TWW1has4P
                or not player:TalentKnown(InevitableEnd.id) and player.comboPoints >= gameState.effective_spend_cp)) then
            return spell:Cast(player)
        end
end)

local function cooldowns_list()
    gameState.deathmark_ma_condition = not player:TalentKnown(MasterAssassin.id) or target:Debuff(debuffs.garrote, true)
    gameState.deathmark_kingsbane_condition = not player:TalentKnown(Kingsbane.id) or Kingsbane.cd <= 2000
    gameState.deathmark_condition = not player:Buff(buffs.stealth)
    and player:BuffRemains(buffs.slice_and_dice) > 5000
    and target:Debuff(debuffs.rupture, true)
    and player:Buff(buffs.envenom)
    and not target:Debuff(debuffs.deathmark, true)
    and gameState.deathmark_ma_condition
    and gameState.deathmark_kingsbane_condition
    
    if Trinket(1, "Damage") then Trinket1() end
    if Trinket(2, "Damage") then Trinket2() end
    
    Deathmark("cds")
    shiv_list()
    
    -- Season 3 Tier Set Enhanced Kingsbane Priority
    Kingsbane("tier_enhanced")
    Kingsbane("cds")
    
    ThistleTea("cds")
    vanish_list()
    
    BloodFury("misc_cds")
    Berserking("misc_cds")
    Fireblood("misc_cds")
    AncestralCall("misc_cds")
    
    -- ColdBlood("cds")
end

Garrote:Callback("core_dot", function(spell)
        if player.comboPoints >= 1
        and target:HasDeBuffCount(debuffs.garrote, true) <= 1
        and target:DebuffRemains(debuffs.garrote, true) < 12000
        and target.ttd - target:DebuffRemains(debuffs.garrote, true) > 1200 then
            return spell:Cast(target)
        end
end)

Rupture:Callback("core_dot", function(spell)
        if player.comboPoints >= gameState.effective_spend_cp
        and target:HasDeBuffCount(debuffs.rupture, true) <= 1
        and target:DebuffRemains(debuffs.rupture, true) < 4000
        and target.ttd - target:DebuffRemains(debuffs.rupture, true) > (4000 + (player:TalentKnownInt(DashingScoundrel.id)*5000) + (gameState.regen_saturated*6000))
        and not player:Buff(buffs.darkest_night) then
            return spell:Cast(target)
        end
end)

CrimsonTempest:Callback("core_dot", function(spell)
        if player.comboPoints >= gameState.effective_spend_cp
        and target:HasDeBuffCount(debuffs.crimson_tempest, true) <= 1
        and target:DebuffRemains(debuffs.crimson_tempest, true) < 4000
        and player:BuffRemains(buffs.momentum_of_despair) > 6000
        and gameState.single_target then
            return spell:Cast(target)
        end
end)

local function core_dot_list()
    Garrote("core_dot")
    Rupture("core_dot")
    CrimsonTempest("core_dot")
end

CrimsonTempest:Callback("aoe_dot", function(spell)
        if gameState.in_ten_range >= 2
        and gameState.dot_finisher_condition
        and target:HasDeBuffCount(debuffs.crimson_tempest, true) <= 1
        and target:DebuffRemains(debuffs.crimson_tempest, true) < 6000
        and target.ttd - target:DebuffRemains(debuffs.crimson_tempest, true) > 6000 then
            return spell:Cast(target)
        end
end)

Garrote:Callback("aoe_dot", function(spell)
        if player.comboPoints >= 1
        and target:HasDeBuffCount(debuffs.garrote, true) <= 1
        and target:DebuffRemains(debuffs.garrote, true) < 12000
        and not gameState.regen_saturated
        and target.ttd - target:DebuffRemains(debuffs.garrote, true) > 1200 then
            return spell:Cast(target)
        end
end)

Rupture:Callback("aoe_dot", function(spell)
        if gameState.dot_finisher_condition
        and target:HasDeBuffCount(debuffs.rupture, true) <= 1
        and target:DebuffRemains(debuffs.rupture, true) < 7000
        and (not target:Debuff(debuffs.kingsbane, true) or player:Buff(buffs.cold_blood))
        and (not gameState.regen_saturated and (player:TalentRank(ScentofBlood.id) == 2
                or (player:TalentRank(ScentofBlood.id) <= 1 and (player:Buff(buffs.indiscriminate_carnage) or target.ttd - target:DebuffRemains(debuffs.rupture, true) > 1500))))
        and target.ttd - target:DebuffRemains(debuffs.rupture, true) > (7000 + (player:TalentKnownInt(DashingScoundrel.id)*5000) + (gameState.regen_saturated*6000))
        and not player:Buff(buffs.darkest_night) then
            return spell:Cast(target)
        end
end)

Rupture:Callback("aoe_dot2", function(spell)
        if gameState.dot_finisher_condition
        and target:HasDeBuffCount(debuffs.rupture, true) <= 1
        and target:DebuffRemains(debuffs.rupture, true) < 19000
        and (not target:Debuff(debuffs.kingsbane, true) or player:Buff(buffs.cold_blood))
        and gameState.regen_saturated
        and not player:Buff(buffs.scent_of_blood)
        and target.ttd - target:DebuffRemains(debuffs.rupture, true) > 19000
        and not player:Buff(buffs.darkest_night) then
            return spell:Cast(target)
        end
end)

Garrote:Callback("aoe_dot2", function(spell)
        if player.comboPoints >= 1
        and target:DebuffRemains(debuffs.garrote, true) < 12000
        and (target:HasDeBuffCount(debuffs.garrote, true) <= 1 or (target:DebuffRemains(debuffs.garrote, true) <= 1500 and gameState.in_ten_range >= 3))
        and (target:DebuffRemains(debuffs.garrote, true) <= 3000 and gameState.in_ten_range >= 3)
        and target.ttd - target:DebuffRemains(debuffs.garrote, true) > 4000
        and not player:Buff(buffs.master_assassin) then
            return spell:Cast(target)
        end
end)

local function aoe_dot_list()
    if gameState.single_target then return end
    
    gameState.scent_effective_max_stacks = math.max(gameState.in_ten_range * player:TalentRank(ScentofBlood.id)*2, 20)
    gameState.scent_saturation = player:HasBuffCount(buffs.scent_of_blood) >= gameState.scent_effective_max_stacks
    gameState.dot_finisher_condition = player.comboPoints >= gameState.effective_spend_cp and target:HasDeBuffCount(debuffs.rupture, true) <= 1
    
    CrimsonTempest("aoe_dot")
    Garrote("aoe_dot")
    Rupture("aoe_dot")
    Rupture("aoe_dot2")
    Garrote("aoe_dot2")
end

Envenom:Callback("direct", function(spell)
        if not player:Buff(buffs.darkest_night)
        and player.comboPoints >= gameState.effective_spend_cp
        and (gameState.not_pooling or player:HasBuffCount(buffs.amplifying_poison) >= 20 or player.comboPoints > player.comboPointsMax or not gameState.single_target)
        and not player:Buff(buffs.vanish) then
            return spell:Cast(target)
        end
end)

Envenom:Callback("direct2", function(spell)
        if player:Buff(buffs.darkest_night)
        and player.comboPoints >= player.comboPointsMax then
            return spell:Cast(target)
        end
end)

Mutilate:Callback("direct", function(spell)
        if gameState.use_caustic_filler then
            return spell:Cast(target)
        end
end)

Ambush:Callback("direct", function(spell)
        if gameState.use_caustic_filler then
            return spell:Cast(target)
        end
end)

EchoingReprimand:Callback("direct", function(spell)
        if gameState.use_filler or LongestTTDRange(PoisonedKnife) < 20000 then
            return spell:Cast(target)
        end
end)

FanofKnives:Callback("direct", function(spell)
        if CheapShot:InRange(target)
        and gameState.use_filler
        and not gameState.priority_rotation
        and (gameState.in_ten_range >= 3 - ((player:TalentKnown(MomentumofDespair.id) and 1 or 0)*(player:TalentKnown(ThrownPrecision.id) and 1 or 0))
            or (player:Buff(buffs.clear_the_witnesses) and not player:TalentKnown(ViciousVenoms.id))) then
            return spell:Cast(player)
        end
end)

FanofKnives:Callback("direct2", function(spell)
        if CheapShot:InRange(target)
        and not target:Debuff(debuffs.deadly_poison, true)
        and (not gameState.priority_rotation or target:Debuff(debuffs.garrote, true) or target:Debuff(debuffs.rupture, true))
        and gameState.use_filler
        and gameState.in_ten_range >= 3 - ((player:TalentKnown(MomentumofDespair.id) and 1 or 0)*(player:TalentKnown(ThrownPrecision.id) and 1 or 0)) then
            return spell:Cast(player)
        end
end)

Ambush:Callback("direct2", function(spell)
        if gameState.use_filler
        and (player:Buff(buffs.blindside) or player:Buff(buffs.stealth))
        and (not target:Debuff(debuffs.kingsbane, true) or not target:Debuff(debuffs.deathmark, true) or player:Buff(buffs.blindside)) then
            return spell:Cast(target)
        end
end)

Mutilate:Callback("direct2", function(spell)
        if gameState.use_filler
        and not target:Debuff(debuffs.deadly_poison, true)
        and not target:Debuff(debuffs.amplifying_poison, true)
        and gameState.in_ten_range == 2 then
            return spell:Cast(target)
        end
end)

Mutilate:Callback("direct3", function(spell)
        if gameState.use_filler then
            return spell:Cast(target)
        end
end)

local function direct_list()
    Envenom("direct")
    Envenom("direct2")
    
    gameState.use_filler = player.comboPoints > 1 or gameState.not_pooling or not gameState.single_target
    
    gameState.use_caustic_filler = player:TalentKnown(CausticSpatter.id)
        and target:Debuff(debuffs.rupture, true)
        and (not target:Debuff(debuffs.caustic_spatter, true) or target:DebuffRemains(debuffs.caustic_spatter, true) <= 2000)
        and player.comboPoints > 1
        and not gameState.single_target
    
    Mutilate("direct")
    Ambush("direct")
    EchoingReprimand("direct")
    if not isInArena or (isInArena and gameState.arena_breakable) then
        FanofKnives("direct")
        FanofKnives("direct2")
    end
    Ambush("direct2")
    Mutilate("direct2")
    Mutilate("direct3")
end

ArcaneTorrent:Callback("regular", function(spell)
        if player.energyDeficit >= 15 + gameState.power_regen then
            return spell:Cast(player)
        end
end)

CrimsonVial:Callback("regular", function(spell)
        if player.hp < 75 then
            return spell:Cast(player)
        end
end)

Evasion:Callback("regular", function(spell)
        if player.hp < 50 then
            return spell:Cast(player)
        end
end)

Feint:Callback("regular", function(spell)
        if player.hp < 50 and not player:Buff(buffs.evasion) then
            return spell:Cast(player)
        end
end)

local function defensive_list()
    CrimsonVial("regular")
    if not player.inCombat then return end
    Evasion("regular")
    Feint("regular")
end

WoundPoison:Callback("regular", function(spell)
        if not player:Buff(buffs.wounded_poison) then
            return spell:Cast(target)
        end
end)

CripplingPoison:Callback("regular", function(spell)
        if not player:Buff(buffs.crippling_poison) then
            return spell:Cast(target)
        end
end)

DeadlyPoison:Callback("regular", function(spell)
        if not player:Buff(buffs.deadly_poison) then
            return spell:Cast(target)
        end
end)

AmplifyingPoision:Callback("regular", function(spell)
        if not player:Buff(buffs.amplifying_poison) then
            return spell:Cast(target)
        end
end)

AtrophicPoison:Callback("regular", function(spell)
        if not player:Buff(buffs.atrophic_poison) then
            return spell:Cast(target)
        end
end)

NumbingPoison:Callback("regular", function(spell)
        if not player:Buff(buffs.numbing_poison) then
            return spell:Cast(target)
        end
end)

local function poision_list()
    local lethal_used = 0
    local nonlethal_used = 0
    if isInArena then
        if enemyHealer.exists then
            lethal_used = lethal_used + 1
            WoundPoison("regular")
        else
            lethal_used = lethal_used + 1
            DeadlyPoison("regular")
        end
    else
        lethal_used = lethal_used + 1
        DeadlyPoison("regular")
    end
    
    if player:TalentKnown(DragonTemperedBlades.id) then
        if player:TalentKnown(AmplifyingPoision.id) then
            lethal_used = lethal_used + 1
            AmplifyingPoision("regular")
        end
        if lethal_used < 2 then
            lethal_used = lethal_used + 1
            WoundPoison("regular")
        end
        if player:TalentKnown(AtrophicPoison.id) then
            nonlethal_used = nonlethal_used + 1
            AtrophicPoison("regular")
        end
        if nonlethal_used < 2 and player:TalentKnown(NumbingPoison.id) then
            nonlethal_used = nonlethal_used + 1
            NumbingPoison("regular")
        end
        if nonlethal_used < 2 and player:TalentKnown(CripplingPoison.id) then
            nonlethal_used = nonlethal_used + 1
            CripplingPoison("regular")
        end
    else
        if player:TalentKnown(AtrophicPoison.id) then
            AtrophicPoison("regular")
        elseif player:TalentKnown(NumbingPoison.id) then
            NumbingPoison("regular")
        else
            CripplingPoison("regular")
        end
    end
end

PoisonedKnife:Callback("pvp-slow", function(spell)
        if sInArena
        and not player.stealthed
        and target.speed > player.speed
        and not target.rooted
        and not target.slowImmune
        and not Ambush:InRange(target)
        and Blind:InRange(target)
        and not target:Debuff(debuffs.crippling_poison, true)
        and player:Buff(buffs.crippling_poison) then
            return spell:Cast(target)
        end
end)

Vanish:Callback("defensive", function(spell)
        if isInArena
        and not player.stealthed
        and player.inCombat then
            
            local arenaHPAvg = 0
            local arenaCount = 0
            if arena1.exists then
                arenaHPAvg = arenaHPAvg + arena1.hp
                arenaCount = arenaCount + 1
            end
            if arena2.exists then
                arenaHPAvg = arenaHPAvg + arena2.hp
                arenaCount = arenaCount + 1
            end
            if arena3.exists then
                arenaHPAvg = arenaHPAvg + arena3.hp
                arenaCount = arenaCount + 1
            end
            
            if arenaCount > 0 then
                local avgHP = arenaHPAvg / arenaCount
                if player.hp < 50 and (player.hp < avgHP) then
                    return spell:Cast(player)
                end
            end
        end
end)


-- PvP Callbacks
Stealth:Callback("pvp1", function(spell)
    if not player:IsStealthed() and not player.inCombat then
        return spell:Cast(player)
    end
end)

WoundPoison:Callback("pvp1", function(spell)
    if A.IsInPvP and not player:Buff(buffs.wounded_poison) then
        return spell:Cast(player)
    end
end)

DeadlyPoison:Callback("pvp1", function(spell)
    if not A.IsInPvP and not player:Buff(buffs.deadly_poison) then
        return spell:Cast(player)
    end
end)

CripplingPoison:Callback("pvp1", function(spell)
    if not player:Buff(buffs.crippling_poison) then
        return spell:Cast(player)
    end
end)

CrimsonVial:Callback("pvp1", function(spell)
    if player.hp <= 85 then
        return spell:Cast(player)
    end
end)

Evasion:Callback("pvp1", function(spell)
    if player.hp <= 33 then
        return spell:Cast(player)
    end
end)

Vanish:Callback("pvp1", function(spell)
    if Vanish.frac == 2 and player.hp <= 18 then
        return spell:Cast(player)
    end
end)

Vanish:Callback("pvp2", function(spell)
    if Vanish.frac == 1 and player.hp <= 8 then
        return spell:Cast(player)
    end
end)

-- Opener
Garrote:Callback("pvp1", function(spell)
    if (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too))
    and not target:Debuff(debuffs.garrote_silence, true)
    and target.silenceDr > 0 then
        return spell:Cast(target)
    end
end)

Ambush:Callback("pvp1", function(spell)
    if (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too))
    and player.comboPoints < 5
    and target:DebuffRemains(debuffs.rupture, true) <= 3000 then
        return spell:Cast(target)
    end
end)

Rupture:Callback("pvp1", function(spell)
    if (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too))
    and target:DebuffRemains(debuffs.rupture, true) <= 3000 then
        return spell:Cast(target)
    end
end)

Shiv:Callback("pvp1", function(spell)
    if Shiv.frac == 2 and player.inCombat
    and not target:Debuff(debuffs.shiv, true)
    and Deathmark:Usable(player) then
        return spell:Cast(target)
    end
end)

KidneyShot:Callback("pvp1", function(spell)
    if A.IsInPvP
    and not target:Debuff(debuffs.kidney_shot, true)
    and target:Debuff(debuffs.shiv, true) then
        return spell:Cast(target)
    end
end)

ThistleTea:Callback("pvp1", function(spell)
    if ThistleTea.frac == 3
    and Ambush:InRange(target) and player.inCombat
    and (not player:Buff(buffs.thistle_tea)
    and target:Debuff(debuffs.deathmark, true)
    or player.energy < 60) then
        return spell:Cast(player)
    end
end)

Deathmark:Callback("pvp1", function(spell)
    if player.inCombat
    and target:Debuff(debuffs.shiv, true)
    and player:Buff(buffs.envenom) then
        return spell:Cast(target)
    end
end)

Garrote:Callback("pvp2", function(spell)
    if target:DebuffRemains(debuffs.garrote, true) <= 3000 then
        return spell:Cast(target)
    end
end)

Envenom:Callback("pvp1", function(spell)
    if player.comboPoints == 6 and player:TalentKnown(DeeperStratagem.id)
    and not target:Debuff(debuffs.deathstalkers_mark, true)
    and player:Buff(buffs.darkest_night) then
        return spell:Cast(target)
    end
end)

-- Combo Point Spenders
CrimsonTempest:Callback("pvp1", function(spell)
    if player.comboPoints >= gameState.effective_spend_cp
    and Ambush:InRange(target) and player.inCombat
    and target:DebuffRemains(debuffs.crimson_tempest, true) <= 3000
    and gameState.in_ten_range >= 5 then
        return spell:Cast(player)
    end
end)

KidneyShot:Callback("pvp2", function(spell)
    if A.IsInPvP
    and player.comboPoints >= gameState.effective_spend_cp
    and not target:Debuff(debuffs.kidney_shot, true)
    and target.stunDr == 1
    and not target:Debuff(debuffs.garrote_silence, true) then
        return spell:Cast(target)
    end
end)

Rupture:Callback("pvp2", function(spell)
    if player.comboPoints >= gameState.effective_spend_cp
    and target:DebuffRemains(debuffs.rupture, true) <= 3000 then
        return spell:Cast(target)
    end
end)

CrimsonTempest:Callback("pvp2", function(spell)
    if player.comboPoints >= gameState.effective_spend_cp
    and Ambush:InRange(target) and player.inCombat
    and target:DebuffRemains(debuffs.crimson_tempest, true) <= 3000
    and gameState.in_ten_range >= 2 then
        return spell:Cast(player)
    end
end)

Envenom:Callback("pvp2", function(spell)
    if player.comboPoints >= gameState.effective_spend_cp
    and not player:Buff(buffs.darkest_night) then
        return spell:Cast(target)
    end
end)

Envenom:Callback("pvp3", function(spell)
    if player.comboPoints >= 4 then
        return spell:Cast(target)
    end
end)

-- Rotation
Garrote:Callback("pvp3", function(spell)
    if (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too))
    and target:DebuffRemains(debuffs.garrote, true) <= 3000 then
        return spell:Cast(target)
    end
end)

Shiv:Callback("pvp2", function(spell)
    if Kingsbane:Usable(target) and player.inCombat
    and not target:Debuff(debuffs.shiv, true) then
        return spell:Cast(target)
    end
end)

Shiv:Callback("pvp3", function(spell)
    if Shiv.frac == 2 and player.inCombat
    and not target:Debuff(debuffs.shiv, true)
    and target:Debuff(debuffs.kidney_shot, true) then
        return spell:Cast(target)
    end
end)

ThistleTea:Callback("pvp2", function(spell)
    if Ambush:InRange(target) and player.inCombat
    and not player:Buff(buffs.thistle_tea)
    and player.energy < 60 then
        return spell:Cast(player)
    end
end)

EchoingReprimand:Callback("pvp1", function(spell)
    if player.inCombat then
        return spell:Cast(target)
    end
end)

FanofKnives:Callback("pvp1", function(spell)
    if player.inCombat and Ambush:InRange(target) and gameState.in_ten_range >= 5 then
        return spell:Cast(player)
    end
end)

ColdBlood:Callback("pvp1", function(spell)
    if player:TalentKnown(ColdBlood.id) and player.inCombat
    and Kingsbane:Usable(target)
    and not player:Buff(buffs.cold_blood)
    and not player:Buff(buffs.cold_blood_2) then
        return spell:Cast(player)
    end
end)

Kingsbane:Callback("pvp1", function(spell)
    if not A.ColdBlood:IsTalentLearned() and player.inCombat then
        return spell:Cast(target)
    end
end)

Kingsbane:Callback("pvp2", function(spell)
    if A.ColdBlood:IsTalentLearned() and player.inCombat
    and (player:Buff(buffs.cold_blood) or player:Buff(buffs.cold_blood_2)) then
        return spell:Cast(target)
    end
end)

Deathmark:Callback("pvp2", function(spell)
    if player.inCombat
    and target:Debuff(debuffs.kingsbane, true)
    and player:Buff(buffs.envenom) then
        return spell:Cast(target)
    end
end)

Ambush:Callback("pvp2", function(spell)
    if player.inCombat
    and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then
        return spell:Cast(target)
    end
end)

CheapShot:Callback("pvp1", function(spell)
    if A.IsInPvP
    and not target:Debuff(debuffs.kidney_shot, true)
    and not target:Debuff(debuffs.cheap_shot, true)
    and target.stunDr > 0.25 then
        return spell:Cast(target)
    end
end)

SerratedBoneSpike:Callback("pvp1", function(spell)
    if player.inCombat then
        return spell:Cast(target)
    end
end)

FanofKnives:Callback("pvp2", function(spell)
    if player.inCombat and Ambush:InRange(target) and gameState.in_ten_range >= 2 then
        return spell:Cast(player)
    end
end)

SmokeBomb:Callback("pvp1", function(spell)
    if A.IsInPvP and Ambush:InRange(target) and player.inCombat and target.hp <= 35 then
        return spell:Cast(player)
    end
end)

FanofKnives:Callback("pvp3", function(spell)
    if player.inCombat and Ambush:InRange(target) and player:Buff(buffs.clear_the_witnesses) then
        return spell:Cast(player)
    end
end)

FanofKnives:Callback("pvp_subterfuge", function(spell)
    if player:Buff(buffs.subterfuge)
    and Ambush:InRange(target) then
        return spell:Cast(player)
    end
end)

Envenom:Callback("pvp_subterfuge", function(spell)
    if player:Buff(buffs.subterfuge)
    and player:Buff(buffs.envenom) 
    and Ambush:InRange(target) then
        return spell:Cast(player)
    end
end)

Rupture:Callback("pvp_subterfuge", function(spell)
    if player:Buff(buffs.subterfuge)
    and target:DebuffRemains(debuffs.rupture, true) <= 3000 
    and Ambush:InRange(target) then
        return spell:Cast(player)
    end
end)

CrimsonTempest:Callback("pvp_subterfuge", function(spell)
    if player:Buff(buffs.subterfuge)
    and target:DebuffRemains(debuffs.crimson_tempest, true) <= 3000
    and Ambush:InRange(target) then
        return spell:Cast(player)
    end
end)

Mutilate:Callback("pvp1", function(spell)
    if player.inCombat then
        return spell:Cast(target)
    end
end)

local function NotInPvP()
    return not A.IsInPvP
end

local function InRaid()
    return IsInRaid()
end

local function InParty()
    return IsInGroup() and not IsInRaid()
end

local function InPvP()
    return A.IsInPvP or UnitInBattleground("player")
end

local function PVPRotation()
    if InPvP() then
        -- Defensives
        CrimsonVial("pvp1")
        Evasion("pvp1")
        Vanish("pvp1")
        Vanish("pvp2")

        -- Opener
        Garrote("pvp1")
        Rupture("pvp_subterfuge")
        CrimsonTempest("pvp_subterfuge")
        Envenom("pvp_subterfuge")
        Ambush("pvp1")
        Rupture("pvp1")
        Shiv("pvp1")
        KidneyShot("pvp1")
        ThistleTea("pvp1")
        Deathmark("pvp1")
 
        -- Rotation
        Garrote("pvp3")
        Envenom("pvp1")

        -- Combo Point Spenders
        CrimsonTempest("pvp1")
        KidneyShot("pvp2")
        Rupture("pvp2")
        CrimsonTempest("pvp2")
        Envenom("pvp2")
        Envenom("pvp3")

        -- Main Rotation
        Garrote("pvp2")
        Shiv("pvp2")
        Shiv("pvp3")
        ThistleTea("pvp2")
        EchoingReprimand("pvp1")
        FanofKnives("pvp1")
        ColdBlood("pvp1")
        Kingsbane("pvp1")
        Kingsbane("pvp2")
        Deathmark("pvp2")
        Ambush("pvp2")
        CheapShot("pvp1")
        SerratedBoneSpike("pvp1")
        FanofKnives("pvp2")
        SmokeBomb("pvp1")
        FanofKnives("pvp3")
        FanofKnives("pvp_subterfuge")
        Mutilate("pvp1")


    end
end



A[3] = function(icon)
    FrameworkStart(icon)
    _, isInArena = IsInPvp()
    updateGameState()
    
    if target and target.exists and isInArena then
        if target.bcc then
            Aware:displayMessage("Target in Breakable CC", "Red", 1.25)
        end
        
        if target.totalImmune or target.physImmune then
            Aware:displayMessage("Target is Physical Immune", "Red", 1.25)
        end
    end
    
    if isInArena and player.stealthed and player.hp < target.hp and player.hp < 80 then
        return FrameworkEnd()
    end
    
    makInterrupt(interrupts)
    
    if player.inCombat and shouldDefensive() then
        if Trinket(13, "Defensive") then
            Trinket1()
        end
        if Trinket(14, "Defensive") then
            Trinket2()
        end
    end
    
    if player.inCombat and player.hp < 50 then
        if MakuluFramework.CanUseHealthStone() then
            HealthStone()
        end
        
        if MakuluFramework.CanUseHealthPotion() then
            HealthPotion()
        end
    end
    
    defensive_list()
    Vanish("defensive")

    if InPvP() then 

        -- Poisons
        Stealth("pvp1")
        WoundPoison("pvp1")
        CripplingPoison("pvp1")

        if target.exists and target.canAttack then
            PVPRotation()
        end

    end
    
    if NotInPvP() and target.exists and target.canAttack then
            CloakofShadows()
            DeathfromAbove("gapcloser")
            PoisonedKnife("pvp-slow")
            
            stealthed_list()
            
            -- Season 3 Optimized Priority: DOTs and burst windows first
            if ShouldWeBurst() and Garrote:InRange(target) then
                cooldowns_list()
                vanish_list()
            end
            core_dot_list()
            aoe_dot_list()
            
            -- Resource spending and finishers
            Envenom("regular")
            direct_list()
            
            -- Slice and Dice maintenance (lower priority - auto-maintained via Cut to the Chase)
            SliceandDice("regular")
            ArcaneTorrent("regular")  

            Stealth("ooc")
            poision_list()

    end
    
    
    return FrameworkEnd()
end

-- Now unify pvp-related callbacks into single if statements

CheapShot:Callback("pvp-non-target-full", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.75
        and (who.cds or who.magicCds) then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-non-target-full", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.75
        and (who.cds or who.magicCds)
        and player.comboPoints >= 4 then
            return spell:Cast(who)
        end
end)

Kick:Callback("pvp-kick-healer", function(spell, who)
        if who.exists and who.canAttack
        and who.isHealer
        and who.pvpKick and who.safeToKick
        and not who.totalImmune then
            
            if Kick:InRange(who) then
                return spell:Cast(who)
            elseif ShadowStep:Usable(who) and not Blind:InRange(who) and ((arena1.exists and arena1.hp < 30) or (arena2.exists and arena2.hp < 30) or (arena3.exists and arena3.hp < 30)) then
                return ShadowStep:Cast(who)
            end
        end
end)

Blind:Callback("pvp-kick-healer-full", function(spell, who)
        if who.exists and who.canAttack
        and who.isHealer
        and who.pvpKick and who.safeToKick
        and not who.totalImmune
        and who.disorientDr >= 0.75
        and Blind:InRange(who) then
            return spell:Cast(who)
        end
end)

Kick:Callback("pvp-kick-dps", function(spell, who)
        if who.exists and who.canAttack
        and who.pvpKick and who.safeToKick
        and not who.totalImmune
        and Kick:InRange(who) then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-kick", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.pvpKick and who.safeToKick
        and who.stunDr >= 0.5 then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-kick", function(spell, who)
        if who.exists and who.canAttack
        and KidneyShot:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.pvpKick and who.safeToKick
        and who.stunDr >= 0.5
        and player.comboPoints >= 4 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-half-dr", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.5
        and (who.cds or who.magicCds) then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-half-dr", function(spell, who)
        if who.exists and who.canAttack
        and KidneyShot:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.5
        and (who.cds or who.magicCds)
        and player.comboPoints >= 4 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-opener", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.75
        and player.hp <= who.hp then
            return spell:Cast(who)
        end
end)

ShadowStep:Callback("to-kill", function(spell, who)
        if who.exists and who.canAttack
        and ShadowStep:InRange(who)
        and not Blind:InRange(who)
        and not who.totalImmune
        and who.hp <= 30 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-to-kill", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.3
        and who.hp <= 30 then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-to-kill", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.3
        and who.hp <= 30
        and player.comboPoints >= 3 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-dying", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.3
        and player.hp <= 40 then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-dying", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.3
        and player.comboPoints >= 2
        and player.hp <= 40 then
            return spell:Cast(who)
        end
end)

Blind:Callback("pvp-kill", function(spell, who)
        if who.exists and who.canAttack
        and Blind:InRange(who)
        and not who.isTarget
        and not who.totalImmune
        and not who.ccImmune
        and who.disorientDr >= 0.5
        and who.pvpKick and who.safeToKick
        and target.hp <= 40 then
            return spell:Cast(who)
        end
end)

Sap:Callback("pvp-open", function(spell, who)
        if not player.inCombat
        and not who.inCombat
        and player.stealthed
        and Sap:Usable(who)
        and who:Distance() <= 10
        and not (arena1:Debuff(debuffs.sap) or arena2:Debuff(debuffs.sap) or arena3:Debuff(debuffs.sap)) then
            return spell:Cast(who)
        end
end)

Dismantle:Callback("pvp-disarm", function(spell, who)
        if who.exists
        and who.canAttack
        and Dismantle:InRange(who)
        and not who.totalImmune
        and ShouldWeDisarm(who)
        and not who:Buff(446035)
        and who:HasBuffFromFor(MakLists.Disarm, 500) then
            Aware:displayMessage("Disarming!", "Green", 2.5)
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("pvp-low-hp", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and player.hp <= 60
        and player.comboPoints >= 3
        and who.stunDr >= 0.3 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("pvp-low-hp", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.5
        and player.hp <= 60 then
            return spell:Cast(who)
        end
end)

Gouge:Callback("pvp-kick-healer", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.incapacitateDr >= 0.5
        and ActionPlayer:IsBehind(.3)
        and who.isHealer
        and who.pvpKick and who.safeToKick then
            return spell:Cast(who)
        end
end)

Gouge:Callback("pvp-kick-dps", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.incapacitateDr >= 0.5
        and ActionPlayer:IsBehind(.3)
        and not who.isHealer
        and who.pvpKick and who.safeToKick then
            return spell:Cast(who)
        end
end)

Gouge:Callback("pvp-low-hp", function(spell, who)
        if who.exists and who.canAttack
        and Ambush:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.incapacitateDr >= 0.5
        and ActionPlayer:IsBehind(.3)
        and not who.isHealer
        and player.hp <= 50 then
            return spell:Cast(who)
        end
end)

Blind:Callback("pvp-cc-heal-burst", function(spell, who)
        if who.exists and who.canAttack
        and Blind:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.disorientDr >= 0.5
        and who.pvpKick and who.safeToKick
        and not who.isHealer then
            return spell:Cast(who)
        end
end)

Gouge:Callback("full-dr-healer", function(spell, who)
        if who.exists and who.canAttack
        and Gouge:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.incapacitateDr >= 0.9
        and who.isHealer
        and (not who.cc or who.ccRemains <= 500) then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("full-dr-healer", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.9
        and who.isHealer then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("full-dr-healer", function(spell, who)
        if who.exists and who.canAttack
        and KidneyShot:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.9
        and who.isHealer
        and player.comboPoints >= 5 then
            return spell:Cast(who)
        end
end)

Gouge:Callback("full-dr-dps", function(spell, who)
        if who.exists and who.canAttack
        and Gouge:InRange(who)
        and not who.totalImmune
        and not who.ccImmune
        and who.incapacitateDr >= 0.9
        and not who.isHealer
        and (not who.cc or who.ccRemains <= 500)
        and who.hp >= player.hp + 5 then
            return spell:Cast(who)
        end
end)

CheapShot:Callback("full-dr-dps", function(spell, who)
        if who.exists and who.canAttack
        and CheapShot:InRange(who)
        and (player:Buff(buffs.stealth) or player:Buff(buffs.vanish))
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.9
        and not who.isHealer
        and who.hp >= player.hp + 5 then
            return spell:Cast(who)
        end
end)

KidneyShot:Callback("full-dr-dps", function(spell, who)
        if who.exists and who.canAttack
        and KidneyShot:InRange(who)
        and (not who.cc or who.ccRemains <= 500)
        and not who.totalImmune
        and not who.ccImmune
        and who.stunDr >= 0.9
        and not who.isHealer
        and player.comboPoints >= 5
        and who.hp >= player.hp + 5 then
            return spell:Cast(who)
        end
end)

local enemyRotation = function(enemy)
    if not enemy.exists or not enemy.canAttack then return end
    
    CheapShot("pvp-non-target-full", enemy)
    if not player.stealthed then
        Kick("pvp-kick-healer", enemy)
        KidneyShot("pvp-non-target-full", enemy)
        Gouge("pvp-kick-healer", enemy)
        Blind("pvp-kick-healer-full", enemy)
    end
    
    CheapShot("pvp-half-dr", enemy)
    if not player.stealthed then
        Kick("pvp-kick-dps", enemy)
        KidneyShot("pvp-half-dr", enemy)
        Gouge("pvp-kick-dps", enemy)
    end
    
    CheapShot("pvp-opener", enemy)
    CheapShot("pvp-to-kill", enemy)
    CheapShot("pvp-dying", enemy)
    if not player.stealthed then
        Gouge("pvp-low-hp", enemy)
        ShadowStep("to-kill", enemy)
        KidneyShot("pvp-to-kill", enemy)
        KidneyShot("pvp-dying", enemy)
        KidneyShot("pvp-kick", enemy)
        Blind("pvp-kill", enemy)
    end
    
    CheapShot("pvp-kick", enemy)
    Sap("pvp-open", enemy)
    Dismantle("pvp-disarm", enemy)
    
    CheapShot("pvp-low-hp", enemy)
    
    if not player.stealthed then
        KidneyShot("pvp-low-hp", enemy)
        Blind("pvp-cc-heal-burst", enemy)
        Gouge("full-dr-healer", enemy)
        KidneyShot("full-dr-healer", enemy)
        Gouge("full-dr-dps", enemy)
        KidneyShot("full-dr-dps", enemy)
    end
    CheapShot("full-dr-healer", enemy)
    CheapShot("full-dr-dps", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end
end

Universal1Unit1:Callback("garrote-arena-1", function(spell)
        if arena1 and arena1.exists
        and arena1.canAttack
        and Garrote:InRange(arena1)
        and not arena1.isTarget
        and target:Debuff(debuffs.garrote, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena1:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Garrote [Arena1]", "Green", 2.5)
            return spell:Cast(arena1)
        end
end)

Universal1Unit1:Callback("garrote-arena-1-buffd", function(spell)
        if arena1 and arena1.exists
        and arena1.canAttack
        and Garrote:InRange(arena1)
        and not arena1:Debuff(debuffs.garrote, true)
        and (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too)) then
            Aware:displayMessage("Garrote [Arena1]", "Green", 2.5)
            return spell:Cast(arena1)
        end
end)

Universal1Unit2:Callback("garrote-arena-2-buffd", function(spell)
        if arena2 and arena2.exists
        and arena2.canAttack
        and Garrote:InRange(arena2)
        and not arena2:Debuff(debuffs.garrote, true)
        and (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too)) then
            Aware:displayMessage("Garrote [Arena2]", "Green", 2.5)
            return spell:Cast(arena2)
        end
end)

Universal1Unit3:Callback("garrote-arena-3-buffd", function(spell)
        if arena3 and arena3.exists
        and arena3.canAttack
        and Garrote:InRange(arena3)
        and not arena3:Debuff(debuffs.garrote, true)
        and (player:Buff(buffs.stealthed_improved_garrote) or player:Buff(buffs.stealthed_improved_garrote_too)) then
            Aware:displayMessage("Garrote [Arena3]", "Green", 2.5)
            return spell:Cast(arena3)
        end
end)

Universal1Unit2:Callback("garrote-arena-2", function(spell)
        if arena2 and arena2.exists
        and arena2.canAttack
        and Garrote:InRange(arena2)
        and not arena2.isTarget
        and target:Debuff(debuffs.garrote, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena2:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Garrote [Arena2]", "Green", 2.5)
            return spell:Cast(arena2)
        end
end)

Universal1Unit3:Callback("garrote-arena-3", function(spell)
        if arena3 and arena3.exists
        and arena3.canAttack
        and Garrote:InRange(arena3)
        and not arena3.isTarget
        and target:Debuff(debuffs.garrote, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena3:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Garrote [Arena3]", "Green", 2.5)
            return spell:Cast(arena3)
        end
end)

Universal2Unit1:Callback("rupture-arena-1", function(spell)
        if arena1 and arena1.exists
        and arena1.canAttack
        and Garrote:InRange(arena1)
        and not arena1.isTarget
        and target:Debuff(debuffs.rupture, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena1:Debuff(debuffs.rupture, true)
        and arena1:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Rupture [Arena1]", "Green", 2.5)
            return spell:Cast(arena1)
        end
end)

Universal2Unit2:Callback("rupture-arena-2", function(spell)
        if arena2 and arena2.exists
        and arena2.canAttack
        and Garrote:InRange(arena2)
        and not arena2.isTarget
        and target:Debuff(debuffs.rupture, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena2:Debuff(debuffs.rupture, true)
        and arena2:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Rupture [Arena2]", "Green", 2.5)
            return spell:Cast(arena2)
        end
end)

Universal2Unit3:Callback("rupture-arena-3", function(spell)
        if arena3 and arena3.exists
        and arena3.canAttack
        and Garrote:InRange(arena3)
        and not arena3.isTarget
        and target:Debuff(debuffs.rupture, true)
        and not target:Debuff(debuffs.deathmark, true)
        and not arena3:Debuff(debuffs.rupture, true)
        and arena3:Debuff(debuffs.garrote, true) then
            Aware:displayMessage("Rupture [Arena3]", "Green", 2.5)
            return spell:Cast(arena3)
        end
end)

A[6] = function(icon)
    RegisterIcon(icon)
    
    Universal1Unit1("garrote-arena-1-buffd")
    Universal1Unit1("garrote-arena-1")
    Universal2Unit1("rupture-arena-1")
    
    if not isInArena then
        if targetForInterrupt(interrupts) then return TabTarget() end
        if AutoTarget() then return TabTarget() end
    end
    enemyRotation(arena1)
    partyRotation(party1)
    
    return FrameworkEnd()
end

A[7] = function(icon)
    RegisterIcon(icon)
    
    Universal1Unit2("garrote-arena-2-buffd")
    Universal1Unit2("garrote-arena-2")
    Universal2Unit2("rupture-arena-2")
    
    enemyRotation(arena2)
    partyRotation(party2)
    
    return FrameworkEnd()
end

A[8] = function(icon)
    RegisterIcon(icon)
    
    Universal1Unit3("garrote-arena-3-buffd")
    Universal1Unit3("garrote-arena-3")
    Universal2Unit3("rupture-arena-3")
    
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
