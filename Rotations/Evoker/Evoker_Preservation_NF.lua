if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 1468 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local Debounce         = MakuluFramework.debounceSpell
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local HealingEngine    = Action.HealingEngine

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable

local LivingFlameCastType = 0
local sleepWalkTarget = nil

local ActionID       = {
    TailSwipe = { ID = 368970, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true  } },
    WingBuffet = { ID = 357214, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true  } },

    AzureStrike = { ID = 362969, MAKULU_INFO = { damageType = "magic" } },
    BlessingOfTheBronze = { ID = 364342 },
    CauterizingFlame = { ID = 374251 },
    DeepBreath = { ID = 357210, MAKULU_INFO = { damageType = "magic" } },
    Disintegrate = { ID = 356995, MAKULU_INFO = { damageType = "magic" } },
    EmeraldBlossom = { ID = 355913 },
    Naturalize = { ID = 360823 },
    FireBreath = { ID = 357208, MAKULU_INFO = { damageType = "magic" } },
    FireBreathToo = { ID = 382266, MAKULU_INFO = { damageType = "magic" }, },
    FuryOfTheAspects = { ID = 390386 },
    Hover = { ID = 358267 },
    Landslide = { ID = 358385, MAKULU_INFO = { damageType = "magic" } },
    LivingFlame = { ID = 361469, Texture = 375554 },
    LivingFlameDmg = { ID = 361469, Texture = 375554, Color = "BLUE", MAKULU_INFO = { damageType = "magic" }, },
    ObsidianScales = { ID = 363916 },
    Quell = { ID = 351338, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true } },
    RenewingBlaze = { ID = 374348 },
    Return = { ID = 361227 },
    TimeSpiral = { ID = 374968 },
    SpatialParadox = { ID = 406732 },
    TipTheScales = { ID = 370553 },
    VerdantEmbrace = { ID = 360995 },
    SleepWalk = { ID = 360806, MAKULU_INFO = { damageType = "magic" }, },
    Unravel = { ID = 368432, MAKULU_INFO = { damageType = "magic" } },
    OppressingRoar = { ID = 372048, MAKULU_INFO = { damageType = "magic" } },
    Rescue = { ID = 370665 },
    SourceOfMagic = { ID = 369459, MAKULU_INFO = { damageType = "magic" } },
    Zephyr = { ID = 374227 },

    Echo = { ID = 364343 },
    DreamBreath = { ID = 382614 },
    DreamBreathToo = { ID = 355936 },
    Reversion = { ID = 366155 },
    Rewind = { ID = 363534 },
    Spiritbloom = { ID = 382731 },
    SpiritbloomToo = { ID = 367226 },
    TimeDilation = { ID = 357170 },
    EmeraldCommunion = { ID = 370960 },
    TemporalAnomaly = { ID = 373861 },
    DreamFlight = { ID = 359816 },
    Stasis = { ID = 370537 },
    StasisRelease = { ID = 370564 },

    Engulf = { ID = 443328, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    DreamProjection = { ID = 377509 },
    ChronoLoop = { ID = 383005 },
    TimeStop = { ID = 378441 },
    SwoopUp = { ID = 370388 },
    NullifyingShroud = { ID = 378464 },

    LifeGiversFlame = { ID = 371426, Hidden = true },
    CallOfYsera = { ID = 373834, Hidden = true },
    FontOfMagic = { ID = 375783, Hidden = true },
    Lifespark = { ID = 443177, Hidden = true },
    ResonatingSphere = { ID = 376236, Hidden = true },
    EnergyLoop = { ID = 372233, Hidden = true },
    FieldOfDreams = { ID = 370062, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    ElementalPotion1 = { Type = "Potion", ID = 191387, Texture = 176108, Hidden = true },
    ElementalPotion2 = { Type = "Potion", ID = 191388, Texture = 176108, Hidden = true },
    ElementalPotion3 = { Type = "Potion", ID = 191389, Texture = 176108, Hidden = true },
    ElementalUltimate1 = { Type = "Potion", ID = 191381, Texture = 176108, Hidden = true },
    ElementalUltimate2 = { Type = "Potion", ID = 191382, Texture = 176108, Hidden = true },
    ElementalUltimate3 = { Type = "Potion", ID = 191383, Texture = 176108, Hidden = true },
    TemperedPotion = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
}

local function createAction(attributes)
    return Action.Create({
        Type = attributes.Type or "Spell",
        ID = attributes.ID,
        Texture = attributes.Texture,
        FixedTexture = attributes.FixedTexture,
        Color = attributes.Color,
        Desc = attributes.Desc,
        MAKULU_INFO = attributes.MAKULU_INFO,
        Hidden = attributes.Hidden,
        QueueForbidden = attributes.QueueForbidden,
    })
end

local A = {}
for name, attributes in pairs(ActionID) do
    A[name] = createAction(attributes)
end
for name, attributes in pairs(ConstSpells) do
    A[name] = createAction(attributes)
end
A = setmetatable(A, { __index = Action })

local buildMakuluFrameworkSpells = function()
	local result = {}
	for k, v in pairs(A) do
		result[k] = MakSpell:new(v.ID, v.MAKULU_INFO, v)
	end
	return result
end
local M = buildMakuluFrameworkSpells()

Action[ACTION_CONST_EVOKER_PRESERVATION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
local tank = ConstUnit.tank
local enemyHealer = ConstUnit.enemyHealer

local gs = {
    imCasting = nil,
    castingEmpower = false,
    shouldAoE = false,
    cursorCheck = false,
    TWW1has2P = false,
    TWW1has4P = false,
    inRaid = MakMulti.party:Size() > 5,
    activeEnemies = 1,
    echoCount = 0,
    averageHp = 100,
    holdForStasis = false,
}

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    spiritOfRedemption = 215982,
    spiritOfTheRedeemer = 215769,
    hover = 358267,
    echo = 364343,
    leapingFlames = 370901,
    lifespark = 443176,
    reversion = 366155,
    callOfYsera = 373835,
    stasisCharging = 370537,
    stasisReady = 370562,
    dreamBreath = 355941,
    rewind = 363534,
    temporalCompression = 362877,
    essenceBurst = 369299,
    nullifyingShroud = 378464,
}

local debuffs = {

}

local rooted = {
    [339] = true, -- entangling roots
    [122] = true, -- frost nova
    [102359] = true, -- mass entanglement
    [51485] = true, -- earthgrab totem
    [162488] = true, -- steel trap
    [212638] = true, -- tracker's net
    [64695] = true, -- earthgrab totem
    [358385] = true, -- Landslide
    [114404] = true, -- void tendrils
    [433662] = true, -- Grasping Blood
    [432031] = true, -- Grasping Blood 2
    [434083] = true, -- Ambush
    [431494] = true, -- Black Edge
    [324859] = true, -- Bramblethorn Entanglement
    [328664] = true, -- Chilled
    [464876] = true, -- Concussive Smash
    [450095] = true, -- Curse of Entropy
    [326092] = true, -- Debilitating Poison
    [431309] = true, -- Ensnaring Shadows
    [448215] = true, -- Expel Webs
    [320788] = true, -- Frozen Binds
    [433785] = true, -- Grasping Slash
    [425974] = true, -- Ground Pound
    [440238] = true, -- Ice Sickles
    [451871] = true, -- Mass Tremor
    [428161] = true, -- Molten Metal
    [322486] = true, -- Overgrowth
    [443430] = true, -- Silk Binding
    [434722] = true, -- Subjugate
    [340300] = true, -- Tongue Lashing
    [456773] = true, -- Twilight Wind
    [446718] = true, -- Umbral Weave
    [439324] = true, -- Umbral Weave
    [443427] = true, -- Web Bolt
}

local CauterizingFlameDispelTable = {
    [115767] = true, -- Deep Wounds
    [262115] = true, -- Deep Wounds 2
    [772] = true, -- Rend
    [703] = true, -- Garrote
    [1943] = true, -- Rupture
    [16511] = true, -- Hemorrhage
    [1079] = true, -- Rip
    [1822] = true, -- Rake
    [360194] = true, -- Deathmark (Appears twice in your list, included once here)
    [217200] = true, -- Barbed Shot
    [253384] = true, -- Slaughter
    [372860] = true, -- Searing Wounds
    [209858] = true, -- Necrotic Wound
    [324149] = true, -- Flayed Shot
    [325037] = true, -- Death Chakram
    [385060] = true, -- Odyn's Fury
    [384318] = true, -- Thunderous Roar
    [274837] = true, -- Feral Frenzy
    [18223] = true, -- Curse of Exhaustion
    [702] = true, -- Curse of Weakness
    [980] = true, -- Agony
    [199890] = true, -- Curse of Tongues
    [335467] = true, -- Devouring Plague
    [191587] = true, -- Virulent Plague
}

local interrupts = {
    { spell = Quell },
    { spell = TailSwipe, isCC = true, aoe = true, distance = 2 }
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(callbackEvent, thisUnit, db, QueueOrder)
	local unitID  = thisUnit.Unit
    local unit = MakUnit:new(unitID)

	--Spirit of Redemption / Spirit of the Redeemer
    if unit:Buff(buffs.spiritOfRedemption) or unit:Buff(buffs.spiritOfTheRedeemer) then
	    thisUnit.Enabled = false
	else 
        thisUnit.Enabled = true
	end

    if unit:Buff(buffs.echo) then
        thisUnit.realHP = unit.hp + 20
    else
        thisUnit.realHP = unit.hp
    end
end)


Player:AddTier("TWW1", { 212032, 212030, 212029, 212028, 212027 })

local function activeEnemies()
    return math.max(MultiUnits:GetActiveEnemies(), 1)
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

function holdForStasis()
    if not player:TalentKnown(Stasis.id) then return false end
    if Stasis.cd > 5000 then return false end

    local taCd = TemporalAnomaly.cd
    local dbCd = DreamBreath.cd
    local dbtCd = DreamBreathToo.cd
    local sbCd = Spiritbloom.cd
    local sbtCd = SpiritbloomToo.cd

    local earliestCd = math.min(taCd, dbCd, dbtCd, sbCd, sbtCd)
    
    local cooldowns = {
        taCd <= earliestCd + 5000,
        (dbCd <= earliestCd + 5000 and dbtCd <= earliestCd + 5000),
        (sbCd <= earliestCd + 5000 and sbtCd <= earliestCd + 5000),
    }

    for _, cooldown in ipairs(cooldowns) do
        if not cooldown then
            return false
        end
    end

    return true
end

function holdForStasis()
    if not player:TalentKnown(Stasis.id) then return false end
    if Stasis.cd > 5000 then return false end

    local taCd = TemporalAnomaly.cd
    local dbCd = DreamBreath.cd
    local dbtCd = DreamBreathToo.cd
    local sbCd = Spiritbloom.cd
    local sbtCd = SpiritbloomToo.cd

    local earliestCd = math.min(taCd, dbCd, dbtCd, sbCd, sbtCd)
    
    local cooldowns = {
        taCd <= earliestCd + 5000,
        (dbCd <= earliestCd + 5000 and dbtCd <= earliestCd + 5000),
        (sbCd <= earliestCd + 5000 and sbtCd <= earliestCd + 5000),
    }

    for _, cooldown in ipairs(cooldowns) do
        if not cooldown then
            return false
        end
    end

    return true
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local percent = casting and casting.percent
    local empStages = casting and casting.empowerStages

    return currentCast, percent, empStages
end

local function EmpowerStage()
    local _, percent = myCast()
    local duration = GetUnitEmpowerStageDuration(player:CallerId(), 1)
    local currentStage = 0

    if duration == 0 then return end

    local stages = {40, 70, 100}
    if player:TalentKnown(FontOfMagic.id) then
        stages = {30, 60, 80, 100}
    end

    if percent then
        if percent >= stages[1] and percent < stages[2] then
            currentStage = 1
        elseif percent >= stages[2] and percent < stages[3] then
            currentStage = 2
        elseif player:TalentKnown(FontOfMagic.id) and percent >= stages[3] and percent < stages[4] then
            currentStage = 3
        end
    else
        if duration > 0 then
            currentStage = 3 + player:TalentKnownInt(FontOfMagic.id)
        end
    end

    return currentStage
end

local function getBelowHP(percent)
    if target.isDummy and target.isFriendly and target.ehp < percent then
        return 100
    else
        return MakMulti.party:Count(function(unit)
            return LivingFlame:InRange(unit) and unit.ehp < percent and unit.hp > 0
        end)
    end
end

local lastUpdateTime = 0
local updateDelay = 0.8
local function updateGameState()
    local currentTime = GetTime()
    local currentCast = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    local empowers = {
        Spiritbloom = {id = Spiritbloom.id, idToo = SpiritbloomToo.id},
        FireBreath = {id = FireBreath.id, idToo = FireBreathToo.id},
        DreamBreath = {id = DreamBreath.id, idToo = DreamBreathToo.id}
    }

    gs.castingEmpower = currentCast and (
        currentCast == empowers.Spiritbloom.id or
        currentCast == empowers.Spiritbloom.idToo or
        currentCast == empowers.FireBreath.id or
        currentCast == empowers.FireBreath.idToo or
        currentCast == empowers.DreamBreath.id or
        currentCast == empowers.DreamBreath.idToo
    )

    gs.TWW1has2P = Player:HasTier("TWW1", 2)
    gs.TWW1has4P = Player:HasTier("TWW1", 4)

    gs.activeEnemies = activeEnemies()

    gs.shouldAoE = gs.activeEnemies >= 3 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gs.echoCount = MakMulti.party:Count(function(unit) return unit:Buff(buffs.echo, true) end)

    gs.holdForStasis = holdForStasis()

    gs.holdForStasis = holdForStasis()

    if target.isDummy then 
        gs.averageHp = target.ehp
    else
        gs.averageHp = MakMulti.party:Average(function(unit)
            if unit.hp > 0 and LivingFlame:InRange(unit) then
                return unit.ehp
            end
        end)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Base Stuff
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BlessingOfTheBronze:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(BlessingOfTheBronze.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 end)
    
    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then 
        return Debounce("botb", 1000, 2500, spell, player)
    end
end)

ObsidianScales:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    
    if not player.inCombat then return end

    if shouldDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "obsidianScalesHP") and not defensiveActive() then
        return spell:Cast()
    end
end)

Zephyr:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end

    if shouldDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "zephyrHP") and not defensiveActive() then
        return spell:Cast()
    end
end)

RenewingBlaze:Callback(function(spell)
    if not player.inCombat then return end

    if player.hp < A.GetToggle(2, "renewingBlazeHP") then
        return spell:Cast()
    end
end)

NullifyingShroud:Callback(function(spell)
    if Action.Zone ~= "arena" then return end
    if player.combatTime == 0 then return end
    if getBelowHP(70) >= 1 then return end
    if player:Buff(buffs.arenaPreparation) then return end
    if player:Buff(buffs.nullifyingShroud) then return end
    if target.hp < 50 and target.canAttack then return end
    if player.mounted then return end

    return spell:Cast()
end)

Naturalize:Callback(function(spell, unit)
    if unit.hp < 35 then return end
    if player:Buff(buffs.stasisCharging) then return end

    local magicked = MakMulti.party:Find(function(unit) return unit.magicked and Naturalize:InRange(unit) end)
    local poisoned = MakMulti.party:Find(function(unit) return unit.poisoned and Naturalize:InRange(unit) end)

    if magicked then
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        return Debounce("naturalize", 1000, 2500, spell, unit)
    end

    if poisoned then
        HealingEngine.SetTarget(poisoned:CallerId(), 1)
        return Debounce("naturalize", 1000, 2500, spell, unit)
    end
end)

CauterizingFlame:Callback(function(spell, unit)
    if unit.hp < 35 then return end
    if player:Buff(buffs.stasisCharging) then return end

    local bleeding = MakMulti.party:Find(function(unit) return unit.bleeding and CauterizingFlame:InRange(unit) end)
    local poisoned = MakMulti.party:Find(function(unit) return unit.poisoned and CauterizingFlame:InRange(unit) end)
    local cursed = MakMulti.party:Find(function(unit) return unit.cursed and CauterizingFlame:InRange(unit) end)
    local diseased = MakMulti.party:Find(function(unit) return unit.diseased and CauterizingFlame:InRange(unit) end)


    if bleeding then
        HealingEngine.SetTarget(bleeding:CallerId(), 1)
        return Debounce("cauterize", 1000, 2500, spell, unit)
    end

    if poisoned then
        HealingEngine.SetTarget(poisoned:CallerId(), 1)
        return Debounce("cauterize", 1000, 2500, spell, unit)
    end

    if cursed then
        HealingEngine.SetTarget(cursed:CallerId(), 1)
        return Debounce("cauterize", 1000, 2500, spell, unit)
    end

    if diseased then
        HealingEngine.SetTarget(diseased:CallerId(), 1)
        return Debounce("cauterize", 1000, 2500, spell, unit)
    end
end)

TipTheScales:Callback(function(spell)

    return spell:Cast()
end)

VerdantEmbrace:Callback("self", function(spell)

    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast()
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Big Green
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TemporalAnomaly:Callback("bigGreen", function(spell)
    if player:HasBuffCount(buffs.stasisCharging) ~= 3 then return end

    return spell:Cast()
end)

DreamBreath:Callback("bigGreen", function(spell)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 2 then return end

    return spell:Cast()
end)

DreamBreathToo:Callback("bigGreen", function(spell)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 2 then return end

    return spell:Cast()
end)

Spiritbloom:Callback("bigGreen", function(spell, unit)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 1 then return end

    TipTheScales()
    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast(unit)
end)

SpiritbloomToo:Callback("bigGreen", function(spell, unit)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end

    if player:HasBuffCount(buffs.stasisCharging) ~= 1 then return end

    TipTheScales()
    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast(unit)
end)

Stasis:Callback(function(spell)
    if player:Buff(buffs.stasisCharging) then return end
    if player:Buff(buffs.stasisReady) then return end
    if not gs.holdForStasis then return end
    if not gs.holdForStasis then return end

    if not player.inCombat then return end
    if player.moving then return end

    local below90 = getBelowHP(90)
    local below65 = getBelowHP(65)

    if below90 >= 2 or below65 >= 1 then
        if not player:TalentKnown(FieldOfDreams.id) then
            VerdantEmbrace("self")
            return spell:Cast()
        else
            return spell:Cast()
        end
    end
end)

StasisRelease:Callback("bigGreen", function(spell)
    if not player:Buff(buffs.stasisReady) then return end
    
    local below70 = getBelowHP(70)
    local below60 = getBelowHP(60)
    local below50 = getBelowHP(50)
    if below70 >= 3 or below60 >= 2 or below50 >= 1 then
        return spell:Cast()
    end
end)

local function bigGreen(unit)
    Stasis()
    Stasis()
    StasisRelease("bigGreen")
    TemporalAnomaly("bigGreen")
    DreamBreath("bigGreen")
    DreamBreathToo("bigGreen")
    Spiritbloom("bigGreen", unit)
    SpiritbloomToo("bigGreen", unit)
end

VerdantEmbrace:Callback("bigBloom", function(spell, unit)
    if player:HasBuffCount(buffs.stasisCharging) ~= 3 then return end

    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast(unit)
end)

Spiritbloom:Callback("bigBloom", function(spell, unit)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 2 then return end

    TipTheScales()
    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast(unit)
end)

SpiritbloomToo:Callback("bigBloom", function(spell, unit)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end

    if player:HasBuffCount(buffs.stasisCharging) ~= 2 then return end

    TipTheScales()
    HealingEngine.SetTarget(player:CallerId(), 1)
    return spell:Cast(unit)
end)

DreamBreath:Callback("bigBloom", function(spell)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 1 then return end

    return spell:Cast()
end)

DreamBreathToo:Callback("bigBloom", function(spell)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.stasisCharging) ~= 1 then return end

    return spell:Cast()
end)

StasisRelease:Callback("bigBloom", function(spell)
    if not player:Buff(buffs.stasisReady) then return end
    
    local below60 = getBelowHP(60)
    local below40 = getBelowHP(40)
    if below60 >= 3 or below40 >= 2 then
        return spell:Cast()
    end
end)

local function bigBloom(unit)
    Stasis()
    StasisRelease("bigBloom")
    VerdantEmbrace("bigBloom", unit)
    Spiritbloom("bigBloom", unit)
    SpiritbloomToo("bigBloom", unit)
    DreamBreath("bigBloom", unit)
    DreamBreathToo("bigBloom", unit)
end

Rewind:Callback("dung", function(spell)
    if not player.inCombat then return end
    local below40 = getBelowHP(40)
    local below50 = getBelowHP(50)
    if below40 >= 2 or below50 >= 3 then
        return spell:Cast()
    end
end)

EmeraldCommunion:Callback("dung", function(spell, unit)
    if not player.inCombat then return end
    if unit.ehp < 40 then
        VerdantEmbrace("dung", unit)
        VerdantEmbrace("self") -- just in case can't do unit
        spell:Cast()
    end
end)

TemporalAnomaly:Callback("dung", function(spell)
    local below90 = getBelowHP(90)
    if below90 < 2 then return end
    if gs.holdForStasis then return end

    if below90 >= 2 or incBigDmgIn() < 3000 then
        return spell:Cast()
    end
end)

Echo:Callback("dung", function(spell, unit)
    
    local needsEcho = MakMulti.party:Find(function(unit) return unit.distance <= 30 and not unit:Buff(buffs.echo, true) and unit.hp > 0 end)
    
    if incBigDmgIn() < 3000 and (TemporalAnomaly.cd > 1500 or player.moving and not player:Buff(buffs.hover)) then
        if needsEcho then
            if not UnitIsUnit(needsEcho:CallerId(), unit:CallerId()) then
                HealingEngine.SetTarget(needsEcho:CallerId(), 1)
            end
            return spell:Cast(unit)
        end
    end

    if unit.ehp < A.GetToggle(2, "echoHP") and not unit:Buff(buffs.echo, true) then
        return spell:Cast(unit)
    end
end)

Reversion:Callback("dung", function(spell, unit)
    if gs.echoCount < 2 and unit.ehp < 40 then return end
    if unit.ehp > A.GetToggle(2, "reversionHP") then return end
    if unit:Buff(buffs.reversion, true) then return end

    return spell:Cast(unit)
end)

FireBreath:Callback("dung", function(spell)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end
    if not player:TalentKnown(LifeGiversFlame.id) then return end

    if target.canAttack and target.hp > 0 and LivingFlame:InRange(target) then
        return spell:Cast()
    end
end)

FireBreathToo:Callback("dung", function(spell)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    if not player:TalentKnown(LifeGiversFlame.id) then return end

    if target.canAttack and target.hp > 0 and LivingFlame:InRange(target) then
        return spell:Cast()
    end
end)

LivingFlame:Callback("dung", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if not player:Buff(buffs.leapingFlames) then return end
    if player:TalentKnown(Lifespark.id) and not player:Buff(buffs.lifespark) then return end
    if unit.ehp > A.GetToggle(2, "livingFlameHP") then return end
    LivingFlameCastType = 1
    return spell:Cast(unit)
end)

DreamBreath:Callback("dung", function(spell, unit)
    if player.moving then return end
    if gs.holdForStasis then return end
    if gs.holdForStasis then return end

    if not player:TalentKnown(FontOfMagic.id) then return end

    local healCount = getBelowHP(85)
    if healCount < 2 and unit.ehp > 75 then return end

    VerdantEmbrace("self")


    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
    end

    return spell:Cast()
end)

DreamBreathToo:Callback("dung", function(spell, unit)
    if player.moving then return end
    if gs.holdForStasis then return end
    if gs.holdForStasis then return end

    if player:TalentKnown(FontOfMagic.id) then return end
    
    local healCount = getBelowHP(85)
    if healCount < 2 and unit.ehp > 75 then return end

    VerdantEmbrace("self")
 
 
    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
    end

    return spell:Cast()
end)

Spiritbloom:Callback("dung", function(spell, unit)
    if player.moving then return end
    if gs.holdForStasis then return end
    if gs.holdForStasis then return end

    if not player:TalentKnown(FontOfMagic.id) then return end

    local below50 = getBelowHP(50)
    local below65 = getBelowHP(65)
    local below80 = getBelowHP(80)
    if below50 > 2 then
        TipTheScales()
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(unit)
    end

    if below65 > 2 then
        if gs.echoCount > 2 then
            HealingEngine.SetTarget(player:CallerId(), 1)
            return spell:Cast(unit)
        end
    end

    if below80 > 2 then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(unit)
    end

    if unit.ehp < 60 then
        return spell:Cast(unit)
    end
end)

SpiritbloomToo:Callback("dung", function(spell, unit)
    if player.moving then return end
    if gs.holdForStasis then return end
    if gs.holdForStasis then return end

    if player:TalentKnown(Stasis.id) then
        if Stasis.cd < 4000 then return end
    end

    if player:TalentKnown(FontOfMagic.id) then return end

    local below50 = getBelowHP(50)
    local below80 = getBelowHP(80)
    if below50 > 2 then
        TipTheScales()
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(unit)
    end

    if below80 > 2 then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(unit)
    end

    if unit.ehp < 60 then
        return spell:Cast(unit)
    end
end)

VerdantEmbrace:Callback("dung", function(spell, unit)
    local veSelect = A.GetToggle(2, "veSelect")

    local veSelf = MakMulti.party:Find(function(unit) return unit.hp > 0 and unit.ehp < A.GetToggle(2, "verdantEmbraceHP") and unit:Buff(buffs.echo, true) end)

    if veSelf then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(unit)
    end

    if not veSelect[1] and unit.isTank then return end
    if not veSelect[2] and unit.isHealer and not unit.isMe then return end
    if not veSelect[3] and not unit.isTank and not unit.isHealer then return end
    if not veSelect[4] and unit.isMe then return end
    if (player.rooted or player:BuffFrom(rooted)) and not unit.isMe then return end

    if unit.ehp > A.GetToggle(2, "verdantEmbraceHP") then return end

    return spell:Cast(unit)
end)

EmeraldBlossom:Callback("dung", function(spell, unit)
    if unit.ehp > A.GetToggle(2, "emeraldBlossomHP") then return end
    if spell.used < 2000 then return end

    return spell:Cast(unit)
end)

TimeDilation:Callback("dung", function(spell, unit)
    local tankBuster = MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0

    if tankBuster then
        if tank.exists and tank.ehp > 0 then
            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(unit)
        end
    end

    if UnitIsUnit(unit:CallerId(), "boss1target") then
        return spell:Cast(unit)
    end
end)

LivingFlame:Callback("dung2", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if unit.ehp > 90 then return end
    LivingFlameCastType = 1
    return spell:Cast(unit)
end)

local function dungeon(unit)
    if not player:TalentKnown(TemporalAnomaly.id) then
        bigBloom(unit)
    else
        bigGreen(unit)
    end
    EmeraldCommunion("dung", unit)
    Rewind("dung")
    Reversion("dung", unit)
    FireBreath("dung")
    FireBreathToo("dung")
    LivingFlame("dung", unit)
    VerdantEmbrace("dung", unit)
    DreamBreath("dung", unit)
    DreamBreathToo("dung", unit)
    Spiritbloom("dung", unit)
    SpiritbloomToo("dung", unit)
    TimeDilation("dung", unit)
    TemporalAnomaly("dung")
    Echo("dung", unit)
    EmeraldBlossom("dung", unit)
    LivingFlame("dung2", unit)
end

Stasis:Callback("blossom", function(spell)
    if player:Buff(buffs.stasisCharging) then return end
    if player:Buff(buffs.stasisReady) then return end

    local ebCost = C_Spell.GetSpellPowerCost(EmeraldBlossom.id)[2].cost
    if player.mana < ebCost * 3 then return end
    if not player:Buff(buffs.essenceBurst) then return end
    if player.essence < 3 then return end

    return spell:Cast()
end)

StasisRelease:Callback("blossom", function(spell)
    if not player:Buff(buffs.stasisReady) then return end
    
    local below70 = getBelowHP(70)
    local below50 = getBelowHP(50)
    if below70 >= 3 or below50 >= 2 then
        return spell:Cast()
    end
end)

DreamBreath:Callback("blossom", function(spell)
    if player.moving then return end
    if player:Buff(buffs.stasisCharging) then return end

    if not player:TalentKnown(FontOfMagic.id) then return end
    
    local below85 = getBelowHP(85)
    if below85 < 4 then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end

    VerdantEmbrace("self")
    return spell:Cast()
end)

DreamBreathToo:Callback("blossom", function(spell)
    if player.moving then return end
    if player:Buff(buffs.stasisCharging) then return end

    if player:TalentKnown(FontOfMagic.id) then return end
    
    local below85 = getBelowHP(85)
    if below85 < 4 then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end

    VerdantEmbrace("self")
    return spell:Cast()
end)

Spiritbloom:Callback("blossom", function(spell, unit)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:Buff(buffs.stasisCharging) then return end

    if unit.ehp > 60 then return end

    TipTheScales()
    return spell:Cast(unit)
end)

SpiritbloomToo:Callback("blossom", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player:Buff(buffs.stasisCharging) then return end

    if unit.ehp > 60 then return end

    TipTheScales()
    return spell:Cast(unit)
end)

EmeraldBlossom:Callback("blossom", function(spell, unit)
    Stasis("blossom")

    if player:Buff(buffs.stasisCharging) then
        if unit.ehp <= 90 then
            return spell:Cast(unit)
        end
    end

    if player:HasBuffCount(buffs.essenceBurst) >= 2 and Stasis.cd > 300 then
        if unit.ehp <= 90 then
            return spell:Cast(unit)
        end
    elseif player:HasBuffCount(buffs.essenceBurst) == 1 then
        if unit.ehp <= 85 then
            return spell:Cast(unit)
        end
    elseif not player:Buff(buffs.essenceBurst) then
        if unit.ehp <= 70 then
            return spell:Cast(unit)
        end
    end
end)

TemporalAnomaly:Callback("blossom", function(spell)
    if player:Buff(buffs.stasisCharging) then return end

    local below65 = getBelowHP(65)
    if below65 < 4 then return end

    return spell:Cast()
end)

LivingFlame:Callback("blossom", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if unit.ehp > A.GetToggle(2, "livingFlameHP") then return end

    return spell:Cast(unit)
end)

local function chronoblossoms(unit)
    StasisRelease("blossom")
    EmeraldCommunion("dung", unit)
    Rewind("dung")
    Reversion("dung", unit)
    DreamBreath("blossom")
    DreamBreathToo("blossom")
    Spiritbloom("blossom", unit)
    SpiritbloomToo("blossom", unit)
    EmeraldBlossom("blossom", unit)
    TemporalAnomaly("blossom")
    LivingFlame("blossom", unit)
end

TemporalAnomaly:Callback("echo", function(spell)
    if not player:TalentKnown(ResonatingSphere.id) then return end

    return spell:Cast()
end)

Echo:Callback("echo", function(spell, unit)
    local needsEcho = MakMulti.party:Find(function(unit) return unit.distance <= 30 and not unit:Buff(buffs.echo, true) and unit.ehp > 0 end)
    if not needsEcho and not target.isDummy then return end
    if not player.inCombat and not target.isDummy then return end

    if unit:Buff(buffs.echo, true) and not target.isDummy then
        HealingEngine.SetTarget(needsEcho:CallerId(), 1)
    end

    if not unit:Buff(buffs.echo, true) then
        return spell:Cast(unit)
    end
end)

local function echoWarden(unit)
    TemporalAnomaly("echo")
    Echo("echo", unit)
end

Stasis:Callback("flameshaper", function(spell)
    if player.moving then return end
    if player:Buff(buffs.stasisCharging) then return end
    if player:Buff(buffs.stasisReady) then return end

    return spell:Cast()
end)

StasisRelease:Callback("flameshaper", function(spell)
    if not player:Buff(buffs.stasisReady) then return end
    if gs.averageHp > 75 then return end

    return spell:Cast()
end)

Engulf:Callback("flameshaper", function(spell, unit)
    local below90 = getBelowHP(90)
    local hasDb = MakMulti.party:Find(function(unit) return Engulf:InRange(unit) and unit:Buff(DreamBreath.wowName, true) end)
    local charges = math.floor(Engulf.frac)

    if hasDb and (below90 >= 2 or hasDb:BuffRemains(DreamBreath.wowName, true) < (2000 * charges)) then
        HealingEngine.SetTarget(hasDb:CallerId(), 1)
        return spell:Cast(unit)
    end
end)

DreamBreath:Callback("flameshaperStasis", function(spell, unit)
    if player.moving then return end
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end
    if Engulf.frac < 1.9 and gs.averageHp > 65 and Stasis.cd < 1000 and not player:Buff(buffs.stasisCharging) then return end
    if gs.averageHp > 70 + (math.floor(Engulf.frac) * 20) then return end

    if Stasis.cd < 300 then
        VerdantEmbrace("dung", unit)
        VerdantEmbrace("self") -- Extra just in case current focus unit is disabled for VE
        Stasis("flameshaper")
        return spell:Cast()
    end
end)

DreamBreathToo:Callback("flameshaperStasis", function(spell, unit)
    if player.moving then return end
    if player:TalentKnown(FontOfMagic.id) then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end
    if Engulf.frac < 1.9 and gs.averageHp > 65 and Stasis.cd < 1000 and not player:Buff(buffs.stasisCharging) then return end
    if gs.averageHp > 70 + (math.floor(Engulf.frac) * 20) then return end

    if Stasis.cd < 300 then
        VerdantEmbrace("dung", unit)
        VerdantEmbrace("self") -- Extra just in case current focus unit is disabled for VE
        Stasis("flameshaper")
        return spell:Cast()
    end
end)

DreamBreath:Callback("flameshaper", function(spell, unit)
    if player.moving then return end
    if not player:TalentKnown(FontOfMagic.id) then return end
    if Stasis.cd < 4000 then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end

    if Engulf.frac > 0.9 and not player:Buff(buffs.stasisCharging) and gs.averageHp <= 85 then
        VerdantEmbrace("dung", unit)
        VerdantEmbrace("self") -- Extra just in case current focus unit is disabled for VE
        return spell:Cast()
    end
end)

DreamBreathToo:Callback("flameshaper", function(spell, unit)
    if player.moving then return end
    if player:TalentKnown(FontOfMagic.id) then return end
    if Stasis.cd < 4000 then return end
    if player:HasBuffCount(buffs.temporalCompression) < 4 then return end

    if player:HasBuffCount(buffs.stasisCharging) == 3 or Engulf.frac > 0.9 and not player:Buff(buffs.stasisCharging) and gs.averageHp <= 85 then
        VerdantEmbrace("dung", unit)
        VerdantEmbrace("self") -- Extra just in case current focus unit is disabled for VE
        return spell:Cast()
    end
end)

Spiritbloom:Callback("flameshaper", function(spell, unit)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if DreamBreath.cd < 1000 and DreamBreathToo.cd < 1000 and Engulf.frac >= 1.9 then return end

    local below70 = getBelowHP(70)
    if below70 >= 4 or unit.ehp < 50 then
        TipTheScales()
        return spell:Cast(unit)
    end
end)

SpiritbloomToo:Callback("flameshaper", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    if DreamBreath.cd < 1000 and DreamBreathToo.cd < 1000 and Engulf.frac >= 1.9 then return end

    local below70 = getBelowHP(70)
    if below70 >= 4 or unit.ehp < 50 then
        TipTheScales()
        return spell:Cast(unit)
    end
end)

TemporalAnomaly:Callback("flameshaper", function(spell, unit)
    if not player:TalentKnown(ResonatingSphere.id) then return end
    if not player.inCombat and not target.isDummy then return end
    if unit.ehp > 95 then return end

    return spell:Cast()
end)

Reversion:Callback("flameshaper", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    if unit.isTank then return end
    
    if unit.ehp >= 95 then return end

    spell:Cast(unit)
end)

local function flameshaper(unit)
    StasisRelease("flameshaper")
    Rewind("dung")
    EmeraldCommunion("dung", unit)
    TimeDilation("dung", unit)
    Engulf("flameshaper", unit)
    DreamBreath("flameshaperStasis", unit)
    DreamBreathToo("flameshaperStasis", unit)
    if player:Buff(buffs.stasisCharging) and Engulf.frac >= 1 then return end
    DreamBreath("flameshaper", unit)
    DreamBreathToo("flameshaper", unit)
    Spiritbloom("flameshaper", unit)
    SpiritbloomToo("flameshaper", unit)
    TemporalAnomaly("flameshaper", unit)
    Echo("echo", unit)
    Reversion("flameshaper", unit)
    EmeraldBlossom("dung", unit) -- I don't think this will ever call so need to figure out when it's worth even using
    LivingFlame("dung2", unit)
end


LivingFlameDmg:Callback("execute", function(spell)
    if not player:Buff(buffs.lifespark) then return end
    if player.moving and not player:Buff(buffs.hover) then return end
    local below50 = getBelowHP(50)
    if below50 >= 1 then return end
    if target.hp > 45 then return end
    LivingFlameCastType = 2

    return spell:Cast(target)
end)

Disintegrate:Callback("execute", function(spell)
    local below50 = getBelowHP(50)
    if below50 >= 1 then return end
    if player.moving and not player:Buff(buffs.hover) then return end
    if target.hp > 35 then return end

    return spell:Cast(target)
end)

local function execute()
    LivingFlameDmg("execute")
    Disintegrate("execute")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ARENA STUFFS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

StasisRelease:Callback("arena", function(spell, unit)
    if not player:Buff(buffs.stasisReady) then return end
    if unit.hp > 60 then return end
    if unit:BuffRemains(buffs.dreamBreath) > 2000 then return end

    return spell:Cast()
end)

Spiritbloom:Callback("arena", function(spell, unit)
    if not player:TalentKnown(FontOfMagic.id) then return end
    
    if unit:Buff(buffs.rewind) then return end
    if unit:BuffFrom(MakLists.TotalImmune) then return end
    if unit.hp > 40 then return end

    TipTheScales()
    if player:Buff(buffs.tipTheScales) then
        return spell:Cast()
    end
end)

SpiritbloomToo:Callback("arena", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    
    if unit:Buff(buffs.rewind) then return end
    if unit:BuffFrom(MakLists.TotalImmune) then return end
    if unit.hp > 40 then return end

    TipTheScales()
    if player:Buff(buffs.tipTheScales) then
        return spell:Cast()
    end
end)

Rewind:Callback("arena", function(spell, unit)
    if unit.hp > 45 then return end
    if unit:BuffFrom(MakLists.TotalImmune) then return end

    return spell:Cast(unit)
end)

EmeraldCommunion:Callback("arena", function(spell, unit)
    if unit.hp > 35 then return end
    if unit:BuffFrom(MakLists.TotalImmune) then return end

    return spell:Cast()
end)

LivingFlame:Callback("arena", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if unit.hp > 30 then return end
    if not player:Buff(buffs.lifespark) then return end

    LivingFlameCastType = 1
    return spell:Cast(unit)
end)

TimeDilation:Callback("arena", function(spell, unit)
    if not player.inCombat then return end
    if unit.hp < 80 and ((arena1.exists and arena1.cds) or (arena2.exists and arena2.cds) or (arena3.exists and arena3.cds)) then
        return spell:Cast(unit)
    end
    
    if unit.hp < 50 then
        return spell:Cast(unit)
    end
end)

Stasis:Callback("arena", function(spell, unit)
    if player:Buff(buffs.stasisCharging) then return end
    if player:Buff(buffs.stasisReady) then return end
    if VerdantEmbrace.cd > 1000 then return end
    if DreamBreath.cd > 2000 then return end
    if unit.hp > 95 then return end
    if not LivingFlame:ReadyToUse() then return end

    return spell:Cast()
end)

VerdantEmbrace:Callback("arena", function(spell, unit)
    if not player:Buff(buffs.stasisCharging) then return end

    local veSelect = A.GetToggle(2, "veSelect")
    if not veSelect[1] and unit.isTank then return end
    if not veSelect[2] and unit.isHealer and not unit.isMe then return end
    if not veSelect[3] and not unit.isTank and not unit.isHealer then return end
    if not veSelect[4] and unit.isMe then return end
    if (player.rooted or player:BuffFrom(rooted)) and not unit.isMe then return end

    if unit.hp > 95 then return end

    return spell:Cast(unit)
end)

Echo:Callback("arena", function(spell, unit)
    if not player:Buff(buffs.stasisCharging) then return end
    if player:Buff(buffs.echo, true) then return end

    return spell:Cast(unit)
end)

DreamBreath:Callback("arena", function(spell, unit)
    if player.moving then return end
    if not player:TalentKnown(FontOfMagic.id) then return end
    if not player:Buff(buffs.callOfYsera) then return end
    if not player:Buff(buffs.stasisCharging) then return end
    if not unit:Buff(buffs.echo, true) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
    end

    return spell:Cast(unit)
end)

DreamBreathToo:Callback("arena", function(spell, unit)
    if player.moving then return end
    if player:TalentKnown(FontOfMagic.id) then return end
    if not player:Buff(buffs.callOfYsera) then return end
    if not player:Buff(buffs.stasisCharging) then return end
    if not unit:Buff(buffs.echo, true) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
    end

    return spell:Cast(unit)
end)

VerdantEmbrace:Callback("arena2", function(spell, unit)
    local veSelect = A.GetToggle(2, "veSelect")
    if not veSelect[1] and unit.isTank then return end
    if not veSelect[2] and unit.isHealer and not unit.isMe then return end
    if not veSelect[3] and not unit.isTank and not unit.isHealer then return end
    if not veSelect[4] and unit.isMe then return end
    if (player.rooted or player:BuffFrom(rooted)) and not unit.isMe then return end

    if unit.hp > 95 then return end

    return spell:Cast(unit)
end)

DreamBreath:Callback("arena2", function(spell, unit)
    if player.moving then return end
    if not player:TalentKnown(FontOfMagic.id) then return end
    if not player:Buff(buffs.callOfYsera) then return end

    if unit:Buff(buffs.echo, true) or player.essence < 2 then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[2] then
            Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
        end
        return spell:Cast(unit)
    end
end)

DreamBreathToo:Callback("arena2", function(spell, unit)
    if player.moving then return end
    if player:TalentKnown(FontOfMagic.id) then return end
    if not player:Buff(buffs.callOfYsera) then return end

    if unit:Buff(buffs.echo, true) or player.essence < 2 then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[2] then
            Aware:displayMessage("Dream Breath! Aim at Party", "Green", 1)
        end
        return spell:Cast(unit)
    end
end)

LivingFlame:Callback("arena2", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if not player:Buff(buffs.lifespark) then return end
    if unit.hp > 55 then return end

    if player:Buff(buffs.echo, true) or player.essence < 2 then
        LivingFlameCastType = 1
        return spell:Cast(unit)
    end
end)

Spiritbloom:Callback("arena2", function(spell, unit)
    if not player:TalentKnown(FontOfMagic.id) then return end
    
    local below50 = getBelowHP(50)
    if below50 < 3 then return end

    TipTheScales()
    if player:Buff(buffs.tipTheScales) then
        return spell:Cast()
    end
end)

SpiritbloomToo:Callback("arena2", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    
    local below50 = getBelowHP(50)
    if below50 < 3 then return end

    TipTheScales()
    if player:Buff(buffs.tipTheScales) then
        return spell:Cast()
    end
end)

FireBreath:Callback("arena", function(spell)
    if player.moving then return end

    if player:TalentKnown(FontOfMagic.id) then return end

    local below70 = getBelowHP(70)
    if below70 >= 1 then return end
    if player:Buff(buffs.tipTheScales) then return end

    if target.canAttack and target.hp > 0 and LivingFlame:InRange(target) then
        return spell:Cast()
    end
end)

FireBreathToo:Callback("arena", function(spell)
    if player.moving then return end

    if not player:TalentKnown(FontOfMagic.id) then return end

    local below70 = getBelowHP(70)
    if below70 >= 1 then return end
    if player:Buff(buffs.tipTheScales) then return end

    if target.canAttack and target.hp > 0 and LivingFlame:InRange(target) then
        return spell:Cast()
    end
end)

Reversion:Callback("arena", function(spell, unit)
    if unit.hp <= 40 then
        return spell:Cast(unit)
    end

    if unit:BuffRemains(buffs.reversion, true) < 2000 and unit.hp <= 95 and unit:Buff(buffs.echo, true) then
        return spell:Cast(unit)
    end
end)

Echo:Callback("arena2", function(spell, unit)
    if player:Buff(buffs.echo, true) then return end
    if unit.hp > 95 then return end
    
    return spell:Cast(unit)
end)

Spiritbloom:Callback("arena3", function(spell, unit)
    if not player:TalentKnown(FontOfMagic.id) then return end
    
    if not unit:Buff(buffs.echo, true) then return end
    if unit.hp > 75 then return end 

    return spell:Cast(unit)
end)

SpiritbloomToo:Callback("arena3", function(spell, unit)
    if player:TalentKnown(FontOfMagic.id) then return end
    
    if not unit:Buff(buffs.echo, true) then return end
    if unit.hp > 75 then return end 

    return spell:Cast(unit)
end)

Engulf:Callback("arena", function(spell, unit)
    if unit.hp > 80 then return end
    if not unit:Buff(buffs.echo, true) then return end
    if not unit:Buff(buffs.dreamBreath, true) then return end

    return spell:Cast(unit)
end)

Engulf:Callback("arena", function(spell, unit)
    if unit.hp > 80 then return end
    if not unit:Buff(buffs.echo, true) then return end
    if not unit:Buff(buffs.dreamBreath, true) then return end

    return spell:Cast(unit)
end)

CauterizingFlame:Callback("arena", function(spell, unit)
    if not unit:DebuffFrom(CauterizingFlameDispelTable) then return end

    return Debounce("cauterize", 1000, 2500, spell, unit)
end)

Rescue:Callback("arena", function(spell, unit)
    if unit.hp > 50 then return end
    if unit.isMe then return end
    if (player.rooted or player:BuffFrom(rooted)) then return end

    return spell:Cast(unit)
end)

LivingFlame:Callback("arena3", function(spell, unit)
    if player.moving and not player:Buff(buffs.hover) then return end
    if unit.hp > 70 then return end
    LivingFlameCastType = 1
    return spell:Cast(unit)
end)

TailSwipe:Callback("arena", function(spell)
    if Action.Zone ~= "arena" then return end
    local below40 = getBelowHP(40)
    if below40 >= 1 then return end
    if arena1.exists and arena1.distance <= 3 and arena1:CastingFromFor(MakLists.arenaKicks, 350) then
        return spell:Cast()
    end

    if arena2.exists and arena2.distance <= 3 and arena2:CastingFromFor(MakLists.arenaKicks, 350) then
        return spell:Cast()
    end

    if arena3.exists and arena3.distance <= 3 and arena3:CastingFromFor(MakLists.arenaKicks, 350) then
        return spell:Cast()
    end

end)

local function arena(unit)
    StasisRelease("arena", unit)
    Spiritbloom("arena", unit)
    SpiritbloomToo("arena", unit)
    Rewind("arena", unit)
    EmeraldCommunion("arena", unit)
    LivingFlame("arena", unit)
    TimeDilation("arena", unit)
    Stasis("arena", unit)
    VerdantEmbrace("arena", unit)
    Echo("arena", unit)
    DreamBreath("arena", unit)
    DreamBreathToo("arena", unit)
    VerdantEmbrace("arena2", unit)
    DreamBreath("arena2", unit)
    DreamBreathToo("arena2", unit)
    LivingFlame("arena2", unit)
    Spiritbloom("arena2", unit)
    SpiritbloomToo("arena2", unit)
    FireBreath("arena")
    FireBreathToo("arena")
    Reversion("arena", unit)
    Echo("arena2", unit)
    Spiritbloom("arena3", unit)
    SpiritbloomToo("arena3", unit)
    Engulf("arena", unit)
    CauterizingFlame("arena", unit)
    Rescue("arena", unit)
    LivingFlame("arena3", unit)
end

FireBreath:Callback("damage", function(spell)
    if player.moving then return end
    
    if player:Buff(buffs.tipTheScales) then return end
    if player:TalentKnown(FontOfMagic.id) then return end
    if not LivingFlame:InRange(target) then return end

    if gs.inRaid and player:HasBuffCount(buffs.temporalCompression) < 4 then return end

    return spell:Cast()
end)

FireBreathToo:Callback("damage", function(spell)
    if player.moving then return end

    if player:Buff(buffs.tipTheScales) then return end
    if not player:TalentKnown(FontOfMagic.id) then return end
    if not LivingFlame:InRange(target) then return end
    
    return spell:Cast()
end)

Disintegrate:Callback("normal", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if gs.inRaid then return end
    if A.Zone == "arena" then return end
    if player.essenceDeficit > 1 then return end
    if player.manaPct < A.GetToggle(2, "dpsMana") then return end

    return spell:Cast(target)
end)

Disintegrate:Callback("energyLoop", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if not player:TalentKnown(EnergyLoop.id) then return end
    if player.manaPct > 80 then return end
    if player.essence <= 3 then return end
    
    return spell:Cast(target)
end)

LivingFlameDmg:Callback(function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if player.manaPct < A.GetToggle(2, "dpsMana") and not player:TalentKnown(FieldOfDreams.id) then return end

    LivingFlameCastType = 2
    return spell:Cast(target)
end)

AzureStrike:Callback(function(spell)
    if Action.Zone == "arena" then return end
    if player.manaPct < A.GetToggle(2, "dpsMana") then return end

    return spell:Cast(target)
end)

local function recastSb()
    if gs.imCasting and gs.imCasting ~= Spiritbloom.id and gs.imCasting ~= SpiritbloomToo.id then return false end

    local hasFontOfMagic = player:TalentKnown(FontOfMagic.id)
    local below80 = getBelowHP(80)

    local empStage = EmpowerStage()

    if empStage == 1 then
        if below80 <= 1 and not player:Buff(buffs.stasisCharging) then
            return true
        end
    end

    if empStage == 2 then
        if below80 <= 2 and not player:Buff(buffs.stasisCharging) or player:Buff(buffs.stasisCharging) then
            return true
        end
    end

    if empStage == 3 then
        return true -- try fix confusion with FB sometimes. Thanks Blizzard.
        --[[if not hasFontOfMagic or below80 <= 3 or player:Buff(buffs.stasisCharging) then
            return true
        end]]
    end

    if empStage == 4 then
        return true
    end

    return false

end

local function recastDb()
    if gs.imCasting and gs.imCasting ~= DreamBreath.id and gs.imCasting ~= DreamBreathToo.id then return false end

    local below90 = getBelowHP(90)
    local below80 = getBelowHP(80)

    local empStage = EmpowerStage()

    if empStage == 1 then
        if below90 >= 1 and below80 < 1 or player:Buff(buffs.stasisCharging) then
            return true
        end
    end

    if empStage == 2 or empStage == 3 or empStage == 4 then
        return true
    end

    return false
end

local function recastFb()
    if gs.imCasting and gs.imCasting ~= FireBreath.id and gs.imCasting ~= FireBreathToo.id then return false end

    local hasFontOfMagic = player:TalentKnown(FontOfMagic.id)

    local empStage = EmpowerStage()

    if not gs.inRaid then
        if empStage == 1 then
            if gs.activeEnemies <= 1 then
                return true
            end
        end

        if empStage == 2 then
            if gs.activeEnemies <= 2 then
                return true
            end
        end

        if empStage == 3 then
            if not hasFontOfMagic or gs.activeEnemies <= 3 then
                return true
            end
        end
    end

    if empStage == 4 then
        return true
    end

    return false
end

local isHealerSetupDone = false

A[3] = function(icon)
    -- if not isHealerSetupDone then
    --     _G.MakuluCore.Functions.SetUpHealers()
    --     isHealerSetupDone = true
    -- end
	FrameworkStart(icon)
    updateGameState()


    local makAlert = A.GetToggle(2, "makAware")

    if makAlert[1] then
        if player:Buff(buffs.hover) then
            Aware:displayMessage("Hover Active!", "Green", 1)
        end
    end

    if makAlert[3] then
        if player:Buff(buffs.stasisCharging) and Action.Zone ~= "arena" then
            Aware:displayMessage("Charging Stasis! Stand still!", "White", 1)
        end
    end

    if makAlert[4] then
        if player.inCombat and target.exists and target.canAttack and not LivingFlame:InRange(target) then
            Aware:displayMessage("Out of Range!", "Red", 1)
        end
    end

    if makAlert[5] then
        if A.GetToggle(2, "spreadEcho") then
            Aware:displayMessage("Spreading Echo!", "Purple", 1)
        end
    end

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Living Flame Cast Type ", LivingFlameCastType)
        MakPrint(2, "Hold for Stasis ", holdForStasis())
        MakPrint(1, "Living Flame Cast Type: ", LivingFlameCastType)
        MakPrint(2, "Hold for Stasis: ", holdForStasis())
        MakPrint(3, "Stasis CD: ", Stasis.cd)
        MakPrint(4, "Sleep Walk CD: ", SleepWalk.cd)
        MakPrint(5, "Average HP: ", gs.averageHp)
    end

    if not gs.castingEmpower then
        makInterrupt(interrupts)
        ObsidianScales()
        Zephyr()
        RenewingBlaze()
        BlessingOfTheBronze()
        NullifyingShroud()
        TailSwipe("arena")
    end

    if recastFb() then
        return A.FireBreath:Show(icon)
    end
    if recastSb() then
        return A.Spiritbloom:Show(icon)
    end
    if recastDb() then
        return A.DreamBreath:Show(icon)
    end

    if target.exists and target.canAttack and LivingFlame:InRange(target) and not player.channeling then
        if A.Zone == "arena" then
            execute()
        end
    end

    local unit
    local healUnits = {target, focus}
    for _, healUnit in ipairs(healUnits) do
        if healUnit.exists and healUnit.isFriendly and LivingFlame:InRange(healUnit) then
            unit = healUnit
            break
        end
    end

    if unit then
        if unit.isFriendly and LivingFlame:InRange(unit) then
            Naturalize(unit)
            CauterizingFlame(unit)
            if A.GetToggle(2, "spreadEcho") then
                echoWarden(unit)
            end
            if A.Zone == "arena" then
                arena(unit)
            else
                if player:TalentKnown(FieldOfDreams.id) then
                    chronoblossoms(unit)
                elseif player:TalentKnown(Engulf.id) then
                    flameshaper(unit)
                else
                    dungeon(unit)
                end
            end
        end
    end

    if target.exists and target.canAttack and LivingFlame:InRange(target) and not player.channeling then
        FireBreath("damage")
        FireBreathToo("damage")
        Disintegrate("energyLoop")
        --Disintegrate("normal")
        LivingFlameDmg()
        AzureStrike()
    end

	return FrameworkEnd()
end

Quell:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

local sleepwalkStopBuffs = {
    [204336] = true, -- Grounding Totem Effect
    [642] = true,    -- Divine Shield
    [740] = true,    -- Tranquility
    [378464] = true, -- Nullifying Shroud
    [6940] = true,   -- Blessing of Sacrifice
    [421453] = true, -- Ultimate Penitence
    [408557] = true, -- Phase Shift
    [377360] = true  -- Precognition
}



SleepWalk:Callback("arena", function(spell, enemy)
    -- Don't proceed if the enemy is the current target
    if enemy.isTarget then return end
    if enemy.distance > 30 then return end

    -- Check if the enemy is already crowd-controlled beyond our cast time
    if enemy:CCRemains() > SleepWalk:CastTime() + MakGcd() then return end

    -- Check diminishing returns on disorient effects
    if enemy.disorientDr < 0.5 then return end
    if enemy.disorientDr < 100 and target.hp > 60 and target.canAttack then return end

    -- Check if any party member is below 35% HP; if so, we shouldn't cast SleepWalk
    local below35 = getBelowHP(35)
    if below35 >= 1 then return end

    -- Check if the enemy has any buffs that would prevent SleepWalk
    if enemy:BuffFrom(sleepwalkStopBuffs) then return end

    -- Ensure the player is not moving
    if player.moving and not player:Buff(buffs.hover) then return end

    -- Main logic for casting SleepWalk
    if enemy.isHealer then
        Aware:displayMessage("Sleep Walk Healer", "Green", 1)
        sleepWalkTarget = enemy
        return spell:Cast(enemy)
    end

    if target.isHealer and target.hp < 50 then
        Aware:displayMessage("Healer is low HP - Sleep Walk " .. enemy.name .. " for off-target peels", "Green", 1)
        sleepWalkTarget = enemy
        return spell:Cast(enemy)
    end

    -- Optional: Peel off DPS when party members are in danger
    --local partyDanger = MakMulti.party:Any(function(unit) return unit.hp > 0 and unit.hp < 50 end)
    --if partyDanger and not enemy.isHealer and enemy.cds then
    --    Aware:displayMessage("Sleep Walk " .. enemy.name .. " to peel", "Red", 1)
    --   sleepWalkTarget = enemy
    --    return spell:Cast(enemy)
    --end
end)

Unravel:Callback("arena", function(spell, enemy)
    if UnitGetTotalAbsorbs(enemy:CallerId()) < 50000 then return end

    return spell:Cast(enemy)
end)

ChronoLoop:Callback("arena", function(spell, enemy)
    if enemy.hp > 40 then return end
    local below40 = getBelowHP(40)
    if below40 > 1 then return end

    return spell:Cast(enemy)
end)

Naturalize:Callback("arena", function(spell, friendly)
    if getBelowHP(40) >= 1 then return end
    if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
    if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
        return spell:Cast(friendly)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    Quell("arena", enemy)
    SleepWalk("arena", enemy)
    Unravel("arena", enemy)
    ChronoLoop("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end

end

local sleepwalkStopBuffs = {
    [204336] = true, -- Grounding Totem Effect
    [642] = true,    -- Divine Shield
    [740] = true,    -- Tranquility
    [421453] = true, -- Ultimate Penitence
    [6940] = true,   -- Blessing of Sacrifice
    [408557] = true, -- Phase Shift
    [377360] = true  -- Precog
}

local function shouldStopSleep(unit)
    
    if unit:CCRemains() > 1500 then
        return true
    end

    if unit:HasBuffFromFor(sleepwalkStopBuffs, 500) then
        return true
    end

    if player:HasDeBuffFor(32379) > 300 then --swd
        return true
    end

    return false
end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end

    --Stopcast Pvp
    if gs.imCasting == SleepWalk.id then
        if shouldStopSleep(sleepWalkTarget) then
            StopCasting()
        end
    end

    if Action.Zone == "arena" or Action.Zone == "pvp" then
        local currentCast = gs.imCasting
        local castingInfo = player:CastOrChanelInfo()
        if not castingInfo then return end
        local castRemains = castingInfo.remains

        if currentCast and castingInfo then
            local unitsBelow40 = getBelowHP(40)
            local unitsBelow65 = getBelowHP(65)
    
            -- Stop casting if powerful healing is urgently needed,
            if unitsBelow40 >= 1 then
                if currentCast == LivingFlame.id and LivingFlameCastType == 1 then
                    if castRemains > 500 then
                        if (TipTheScales:ReadyToUse() and Spiritbloom:ReadyToUse()) or Rewind:ReadyToUse() then
                            StopCasting()
                            return
                        end
                    end
                end
            end
    
            -- Stop casting damage spells if healing is needed
            if unitsBelow65 >= 1 then
                if (currentCast == LivingFlame.id and LivingFlameCastType == 2) or currentCast == FireBreath.id or currentCast == Disintegrate.id then
                    StopCasting()
                    return
                end
            end
        end
    end

    if Action.Zone == "arena" then
	    enemyRotation(arena1)
	    partyRotation(party1)
    end

	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
        enemyRotation(arena2)
        partyRotation(party2)
    end

	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
        enemyRotation(arena3)
        partyRotation(party3)
    end

	return FrameworkEnd()
end

A[9] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(party4)
    end

	return FrameworkEnd()
end

A[10] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
	    partyRotation(player)
    end

	return FrameworkEnd()
end