if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 581 then return end

--[[
Special Binds:

Immolation Aura:
/cast Immolation Aura
/cast Consuming Flame

Throw Glaive:
/cast Throw Glaive
/cast Reaver's Glaive

Sigil of Flame:
/cast [combat,@player][]Sigil of Flame
/cast [combat,@player][]Sigil of Doom

Universals

Universal 2:
/cast [@cursor]Sigil of Flame
/cast [@cursor]Sigil of Doom

Universal 3:
/cast [@cursor]Infernal Strike


]]--

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware
local ConstCell        = cacheContext:getConstCacheCell()

local Action           = _G.Action
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle

local BossMods         = Action.BossMods

local IS_META_ENGINE = Action.MetaEngine and Action.MetaEngine:IsHealthy()

local _G, setmetatable = _G, setmetatable

--[[

]]--
local ActionID = {

    AntiFakeKick = { Type = "SpellSingleColor", ID = 6552,  Hidden = true,		Color = "GREEN"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC	 = { Type = "SpellSingleColor", ID = 107570,  	Hidden = true,		Color = "YELLOW"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	},
    
    ChaosNova = { Type = "Spell", ID = 179057 },
    Darkness = { Type = "Spell", ID = 196718 },
    Disrupt = { Type = "Spell", ID = 183752 },
    Felblade = { Type = "Spell", ID = 232893 },
    Glide = { Type = "Spell", ID = 131347 },
    ImmolationAura = { Type = "Spell", ID = 258920, FixedTexture = 1344649, Macro = "/cast Immolation Aura\n/cast Consuming Flame" },
    Imprison = { Type = "Spell", ID = 217832 },
    Metamorphosis = { Type = "Spell", ID = 187827 },
    SigilofMisery = { Type = "Spell", ID = 207684 },
    SigilofSpite = { Type = "Spell", ID = 390163 },
    SpectralSight = { Type = "Spell", ID = 188501 },
    TheHunt = { Type = "Spell", ID = 370965 },
    ThrowGlaive = { Type = "Spell", ID = 204157, FixedTexture = 1305159, Macro = "/cast Throw Glaive\n/cast Reaver's Glaive" },
    Torment = { Type = "Spell", ID = 185245 },
    VengefulRetreat = { Type = "Spell", ID = 198793 },
    ReaversGlaive = { Type = "Spell", ID = 442294 },

    DemonSpikes = { Type = "Spell", ID = 203720 },
    FelDevastation = { Type = "Spell", ID = 212084, FixedTexture = 1450143 },
    FelDesolation = { Type = "Spell", ID = 452486, FixedTexture = 1450143 },
    FieryBrand = { Type = "Spell", ID = 204021 },
    Fracture = { Type = "Spell", ID = 263642 },
    InfernalStrike = { Type = "Spell", ID = 189110, Macro = "/cast [@cursor]Infernal Strike" },
    SigilofFlame = { Type = "Spell", ID = 204596, FixedTexture = 1344652, Macro = "/cast [combat,@player][]Sigil of Flame\n/cast [combat,@player][]Sigil of Doom" },
    SigilofSilence = { Type = "Spell", ID = 202137, Macro = "/cast [combat,@player][]Sigil of Silence" },
    SoulCarver = { Type = "Spell", ID = 207407 },
    SoulCleave = { Type = "Spell", ID = 228477, FixedTexture = 1344653 },
    SpiritBomb = { Type = "Spell", ID = 247454 },

    SigilofDoom = { Type = "Spell", ID = 452490, FixedTexture = 1344652, Macro = "/cast [combat,@player][]Sigil of Doom" },
    ConsumingFlame = {Type = "Spell", ID = 452487, FixedTexture = 1344649 },
    SigilofChains = { Type = "Spell", ID = 202138 },

    Universal1 = { Type = "Spell", ID = 133658, FixedTexture = 133658, Hidden = true },
    Universal2 = { Type = "Spell", ID = 133663, FixedTexture = 133663, Hidden = false, Macro = "/cast [@player]Sigil of Flame\n/cast [@player]Sigil of Doom" },
    Universal3 = { Type = "Spell", ID = 133658, FixedTexture = 133658, Hidden = false, Macro = "/cast [@cursor]Infernal Strike" },
    Universal4 = { Type = "Spell", ID = 133653, FixedTexture = 133653, Hidden = true },
    Universal5 = { Type = "Spell", ID = 133650, FixedTexture = 133650, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DEMONHUNTER_VENGEANCE] = A

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

local buffs = {
    arena_preparation = 32727,
    power_infusion = 10060,

    darkness = 209426,
    demon_spikes = 203819,
    demonsurge = 452416,
    enduring_torment = 453314,
    fel_flame_fortification = 393009,
    gladiators_insignia = 345230,
    immolation_aura = 258920,
    metamorphosis = 187827,
    scourgebound_vanquisher = 414334,
    sign_of_the_mists = 335151,
    soul_fragments = 203981,
    soul_furnace = 391166,
    spectral_sight = 188501,
    spriggan_vision = 427303,
    student_of_suffering = 453239,
}

local debuffs = {
    exhaustion = 57723,

    burning_blades = 453177,
    chaos_brand = 1490,
    fiery_brand = 207771,
    frailty = 247456,
    sigil_of_doom = 462030,
    sigil_of_flame = 204598,
    sigil_of_misery = 207685,
    sigil_of_silence = 204490,
    the_hunt = 370966,
    torment = 185245,
}

local interrupts = {
    {spell = Disrupt },
    {spell = ChaosNova, isCC = true, aoe = true},
    {spell = Imprison, isCC = true },
    --{spell = SigilofSilence, isCC = true, aoe = true, distance = 7},
    --{spell = SigilofMisery, isCC = true, aoe = true, distance = 7},
    --{spell = SigilofChains, isCC = true, aoe = true},
}

local function num(val)
    if val then return 1 else return 0 end
end

local function shouldBurst()
    if Action.BurstIsON("target") then
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
            if makulu_spell:InRange(enemy) and (enemy.inCombat or enemy.isDummy) and not enemy.isPet and not enemy.isFriendly then
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

local function EnemiesInSpellRangeWithDebuff(makulu_spell, debuff_id)
    return ConstCell:GetOrSet("enemiesInDebuff" .. makulu_spell.id .. debuff_id, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if makulu_spell:InRange(enemy) and (enemy.inCombat or enemy.isDummy) and not enemy.isPet and not enemy.isFriendly and enemy:Debuff(debuff_id) then
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
            if makulu_spell:InRange(enemy) and enemy.inCombat and enemy:IsTotem() and not enemy.isFriendly then
                return true
            end
        end 
        return false
    end)
end

local function enemiesInRange(dur)
    local cacheKey = dur and "enemiesInRange_" .. tostring(dur) or "enemiesInRange"
    
    return ConstCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        
            if Felblade:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if dur > 0 and enemy.ttd > dur then
                        count = count + 1
                    elseif dur <= 0 then
                        count = count + 1
                    end
                end
            end
        end
        
        return count
    end)
end

local function autoTarget()
    if not player.inCombat then return false end
    if player.speed >= 50 then return false end

    if A.GetToggle(2, "autotarget") then
        for _, spellInfo in ipairs(interrupts) do
            if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
                return false
            end
        end
    end

    if A.GetToggle(2, "autotaunt") and gameState.ShouldTaunt == "Switch" then
        return true
    end

    if Fracture:InRange(target) and target.exists and target:Debuff(debuffs.the_hunt) then return false end

    if not target:Debuff(debuffs.the_hunt) and EnemiesInSpellRangeWithDebuff(Fracture, debuffs.the_hunt) > 0 then
        return true
    end

    if Fracture:InRange(target) and target.exists then return false end

    if A.GetToggle(2, "targetmelee") and EnemiesInSpellRange(Fracture) > 0 then
        return true
    end
end

local function updateGameState()
    gameState = {
        TWW2has2P = player:Has2Set(),
        TWW2has4P = player:Has4Set(),
        ShouldTaunt = MakuluFramework.TauntStatus(Torment),
        tank_buster_in = MakuluFramework.DBM_TankBusterIn() or 1000000,
        soul_fragments = player:HasBuffCount(buffs.soul_fragments),
        inMelee = EnemiesInSpellRange(Fracture),
        maxFury = 100,
        active8ttd = enemiesInRange(8000)
    }

    if player:TalentKnown(320770) then
        gameState.maxFury = 120
    end
    if not A.GetToggle(2, "usedbm") then
        gameState.tank_buster_in = 1000000
    end
end

local function sigilTarget()
    local sigilUnitToCheck = target
    local sigilCastOn = player
    if A.GetToggle(2, "sigilMouseOver") then
        sigilUnitToCheck = mouseover
        sigilCastOn = mouseover
    end
    return {sigilUnitToCheck, sigilCastOn}
end

DemonSpikes:Callback("rotation", function(spell)
    if player:Buff(buffs.demon_spikes) then return false end
    if not player.inCombat then return false end
    if not Felblade:InRange(target) then return end

    if spell.frac <= 1.9 then
        if player.ehp > A.GetToggle(2, "demonSpikes1") then return false end
    else
        if player.ehp > A.GetToggle(2, "demonSpikes2") then return false end
    end

    return spell:Cast()
end)

SigilofFlame:Callback("rotation", function(spell)
    if EnemiesInSpellRangeWithoutDebuff(Felblade, debuffs.sigil_of_flame) < EnemiesInSpellRange(Felblade) then return false end
    if not Fracture:InRange(target) then return false end
    
    return spell:Cast()
end)

ImmolationAura:Callback("rotation", function(spell)
    if gameState.active8ttd < 1 then return false end

    if not player:Buff(buffs.immolation_aura) and player.moving and player.speed >= 50 then
        return spell:Cast() -- Cast while using The Hunt to gap close w/o immolation
    end

    if not player.inCombat then return false end

    if EnemiesInSpellRange(Disrupt) < 1 then return false end
    if player:Buff(buffs.immolation_aura) then return false end

    return spell:Cast()
end)

ConsumingFlame:Callback("rotation", function(spell)
    if not player:Buff(buffs.immolation_aura) and player.moving and player.speed >= 50 then
        return spell:Cast() -- Cast while using The Hunt to gap close w/o immolation
    end

    if EnemiesInSpellRange(Disrupt) < 1 then return false end

    return spell:Cast()
end)

SoulCleave:Callback("rotation", function(spell)
    if not Fracture:InRange(target) then return false end
    if gameState.soul_fragments < 1 then return false end
    if player.fury < 30 then return false end
    return spell:Cast()
end)

Fracture:Callback("rotation", function(spell)
    if player.fury >= 100 then return false end

    return spell:Cast(target)
end)

Felblade:Callback("rotation", function(spell)
    if player.fury >= 60 then return false end
    if A.GetToggle(2, "felbladeMelee") and not Fracture:InRange(target) then return false end
    if player.stayTime < A.GetToggle(2, "felbladeTimer") then return false end

    return spell:Cast(target)
end)

SpiritBomb:Callback("rotation", function(spell)
    if gameState.soul_fragments < 3 then return false end
    if EnemiesInSpellRangeWithoutDebuff(Felblade, debuffs.frailty) >= EnemiesInSpellRange(Felblade) then return false end

    return spell:Cast(target)
end)

ThrowGlaive:Callback("rotation", function(spell)
    if spell.frac <= A.GetToggle(2, "holdThrowGlaiveCharges") + 0.9  then return false end
    
    return spell:Cast(target)
end)

SigilofSpite:Callback("rotation", function(spell)
    if EnemiesInSpellRange(Disrupt) < 2 then return false end
    if player.stayTime < A.GetToggle(2, "sigilOfSpiteTimer") then return false end  

    return spell:Cast()
end)

TheHunt:Callback("gapcloser", function(spell)
    if not shouldBurst() then return false end
    if player:Buff(buffs.reavers_glaive) then return false end

    return spell:Cast(target)
end)

SigilofDoom:Callback("rotation", function(spell)
    if EnemiesInSpellRange(Disrupt) < 2 then return false end

    return spell:Cast()
end)

FelDevastation:Callback("rotation", function(spell)
    if player.hp > 95 and not target.isDummy then return false end
    if player.moving then return false end
    if player.stayTime < A.GetToggle(2, "felDevastationTimer") then return false end
    if not Fracture:InRange(target) then return end
    if player:Buff(buffs.metamorphosis) then return false end

    return spell:Cast(target)
end)

FelDesolation:Callback("rotation", function(spell)
    if player.hp > 95 and not target.isDummy then return false end
    if player.moving then return false end

    return spell:Cast(target)
end)

FieryBrand:Callback("rotation", function(spell)
    if not target:Debuff(debuffs.fiery_brand) then return false end
    if not player.inCombat then return false end
    if not shouldBurst() then return false end

    return spell:Cast(target)
end)

ReaversGlaive:Callback("rotation", function(spell)
    if not player.inCombat then return false end

    return ThrowGlaive:Cast(target)
end)

Fracture:Callback("warblade", function(spell)
    if not player:Buff(buffs.warblade) then return false end

    return spell:Cast(target)
end)

SoulCarver:Callback("rotation", function(spell)
    if not shouldBurst() then return false end
    return spell:Cast(target)
end)

Metamorphosis:Callback("rotation", function(spell)
    if not player.inCombat then return false end
    if gameState.inMelee == 0 then return false end

    if shouldBurst() and not A.GetToggle(2, "MetaDefensive") then
        return spell:Cast(target)
    end

    if MakuluFramework.DefensiveActive() and player.hp > 60 then return false end

    if gameState.tank_buster_in <= 4000 then
        return spell:Cast(target)
    end

    if player.hp <= A.GetToggle(2, "MetaHP") then
        return spell:Cast(target)
    end

    return false
end)

FelDevastation:Callback("defensive", function(spell)
    if MakuluFramework.DefensiveActive() and player.hp > 60 then return false end

    if player.stayTime < A.GetToggle(2, "felDevastationTimer") then return false end

    if not Fracture:InRange(target) then return false end
    if player:Buff(buffs.metamorphosis) then return false end

    if player:TalentKnown(213410) and gameState.tank_buster_in <= 2000 then --Wait to last moment if we have Demonic talent
        return spell:Cast()
    end
    if not player:TalentKnown(213410) and gameState.tank_buster_in <= 3000 then
        return spell:Cast()
    end
    if player.hp <= A.GetToggle(2, "FelDevastationHP") then
        return spell:Cast()
    end

    return false
end)

FelDesolation:Callback("defensive", function(spell)
    if MakuluFramework.DefensiveActive() and player.hp > 60 then return false end

    if player.stayTime < A.GetToggle(2, "felDevastationTimer") then return false end

    if not Fracture:InRange(target) then return false end

    if player:TalentKnown(213410) and gameState.tank_buster_in <= 2000 then --Wait to last moment if we have Demonic talent
        return spell:Cast()
    end
    if not player:TalentKnown(213410) and gameState.tank_buster_in <= 3000 then
        return spell:Cast()
    end
    if player.hp <= A.GetToggle(2, "FelDevastationHP") then
        return spell:Cast()
    end

    return false
end)

Darkness:Callback("defensive", function(spell)
    if MakuluFramework.DefensiveActive() and player.hp > 60 then return false end

    if player.stayTime < A.GetToggle(2, "darknessTimer") then return false end  

    if not Fracture:InRange(target) then return false end

    if player:TalentKnown(213410) and gameState.tank_buster_in <= 2000 then --Wait to last moment if we have Demonic talent
        return spell:Cast()
    end
    if not player:TalentKnown(213410) and gameState.tank_buster_in <= 3000 then
        return spell:Cast()
    end
    if player.hp <= A.GetToggle(2, "darknessHP") then
        return spell:Cast()
    end

    return false
end)

FieryBrand:Callback("defensiveaoe", function(spell)
    if not player.inCombat then return false end
    if not player:TalentKnown(207739) then return false end -- Burning Alive talent
    if EnemiesInSpellRangeWithoutDebuff(Felblade, debuffs.fiery_brand) < EnemiesInSpellRange(Felblade) then return false end

    return spell:Cast(target)
end)

FieryBrand:Callback("defensivest", function(spell)
    if not player.inCombat then return false end

    if MakuluFramework.TankDefensive() and shouldBurst() then
        return spell:Cast(target)
    end
end)

SoulCleave:Callback("dumprage", function(spell)
    if gameState.maxFury - player.fury > 30 then return false end

    return spell:Cast(target)
end)

InfernalStrike:Callback("rotation-self", function(spell)
    if not player.inCombat then return false end
    if gameState.inMelee < 3 then return false end
    if spell.used > 0 and spell.used < 500 then return false end
    if spell.frac <= A.GetToggle(2, "holdInfernalStrikeCharges") + 0.9 then return false end

    return spell:Cast()
end)

InfernalStrike:Callback("rotation-self2", function(spell)
    if not player.inCombat then return false end
    if gameState.inMelee < 4 then return false end
    if spell.used > 0 and spell.used < 500 then return false end

    if spell.frac <= A.GetToggle(2, "holdInfernalStrikeCharges") + 0.9 then return false end

    return spell:Cast()
end)

local function WantInfernalJump()
    if mouseover.exists and not mouseover.isFriendly and player.speed < 40 then
        if not SoulCarver:InRange(mouseover) and FieryBrand:InRange(mouseover) then
            return true
        end
    end
    return false
end

local function WantFireMouseOver()
    if mouseover.exists and not mouseover.isFriendly and player.speed < 40 and not player.inCombat  then
        if not SoulCarver:InRange(mouseover) and FieryBrand:InRange(mouseover) then
            return true
        end
    end
    return false
end

Torment:Callback("agro", function(spell)
    if gameState.ShouldTaunt == "Taunt" then
        spell:Cast(target)
    end
end)

A[1] = function(icon)

end

A[2] = function(icon)

end

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end

	FrameworkStart(icon)
    updateGameState()

    makInterrupt(interrupts)
    if 1 == 2 then
        MakPrint(1, "Fury: ", player.fury)
        MakPrint(2, "FelBlade Range (NS): ", EnemiesInSpellRangeWithoutDebuff(Felblade, debuffs.sigil_of_flame))
        MakPrint(3, "FelBlade Range: ", EnemiesInSpellRange(Felblade))
        MakPrint(4, "Disrupt Range: ", EnemiesInSpellRange(Disrupt))
        MakPrint(5, "Taunt Range: ", EnemiesInSpellRange(Torment))
        MakPrint(6, "Soul Fragments: ", gameState.soul_fragments)
        MakPrint(7, "Speed: ", player.speed)
        MakPrint(8, "Taunt: ", gameState.ShouldTaunt)
    end

    if player.inCombat and MakuluFramework.TankDefensive() then
        if Trinket(13, "Defensive") then
            Trinket1()
        end
        if Trinket(14, "Defensive") then
            Trinket2()
        end
    end

    --[[if player.inCombat and player.hp < 50 then
        if MakuluFramework.CanUseHealthStone() then
            HealthStone()
        end

        if MakuluFramework.CanUseHealthPotion() then
            HealthPotion()
        end
    end]]

    if player.inCombat then -- Defensive
        DemonSpikes("rotation")
        Metamorphosis("rotation")
        FieryBrand("defensiveaoe")
        FieryBrand("defensivest")
        FelDevastation("defensive")
        FelDesolation("defensive")
    end

    if WantFireMouseOver() then
        return A.Universal2:Show(icon)
    end

    if WantInfernalJump() then
        return A.Universal3:Show(icon)
    end

    if target.exists and target.canAttack then
        if shouldBurst() and target:Distance() < 4 then
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
        end

        Torment("agro")

        ReaversGlaive("rotation")
        SoulCleave("dumprage")

        SigilofSpite("rotation")
        TheHunt("gapcloser")
        SigilofDoom("rotation")
        ConsumingFlame("rotation")
        FelDevastation("rotation")
        FelDesolation("rotation")
        FieryBrand("rotation")
        SigilofFlame("rotation")
        ImmolationAura("rotation")
        InfernalStrike("rotation-self2")
        SoulCarver("rotation")
        SpiritBomb("rotation")
        Felblade("rotation")
        if player:TalentKnown(442290) then
            if gameState.inMelee == 1 then
                SoulCleave("rotation")
                Fracture("rotation")
            else
                Fracture("rotation")
                SoulCleave("rotation")
            end
        else
            SoulCleave("rotation")
            Fracture("rotation")
        end
        Fracture("warblade")
        ThrowGlaive("rotation")
        InfernalStrike("rotation-self")
    end

	return FrameworkEnd()
end

local enemyRotation = function(enemy)
	if not enemy.exists then return end

end


local partyRotation = function(friendly)
    if not friendly.exists then return end

end

A[6] = function(icon)
	RegisterIcon(icon)
    if A.GetToggle(2, "autotarget") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
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