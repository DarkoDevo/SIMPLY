if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 577 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local Debounce         = MakuluFramework.debounceSpell
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID       = {
    WillToSurvive = { ID = 59752 },
    Stoneform = { ID = 20594 },
    Shadowmeld = { ID = 58984 },
    EscapeArtist = { ID = 20589 },
    GiftOfTheNaaru = { ID = 59544 },
    Darkflight = { ID = 68992 },
    BloodFury = { ID = 20572 },
    WillOfTheForsaken = { ID = 7744 },
    WarStomp = { ID = 20549 },
    Berserking = { ID = 26297 },
    ArcaneTorrent = { ID = 50613 },
    RocketJump = { ID = 69070 },
    RocketBarrage = { ID = 69041 },
    QuakingPalm = { ID = 107079 },
    SpatialRift = { ID = 256948 },
    LightsJudgment = { ID = 255647 },
    Fireblood = { ID = 265221 },
    ArcanePulse = { ID = 260364 },
    BullRush = { ID = 255654 },
    AncestralCall = { ID = 274738 },
    Haymaker = { ID = 287712 },
    Regeneratin = { ID = 291944 },
    BagOfTricks = { ID = 312411 }, 
    HyperOrganicLightOriginator = { ID = 312924 }, 

    ChaosNova = { ID = 179057, MAKULU_INFO = { damageType = "magic" } },
    ConsumeMagic = { ID = 278326, MAKULU_INFO = { damageType = "magic" } },
    Darkness = { ID = 196718 },
    Disrupt = { ID = 183752, MAKULU_INFO = { damageType = "physical" } },
    Felblade = { ID = 232893, MAKULU_INFO = { damageType = "magic" } },
    ImmolationAura = { ID = 258920, Texture = 320331, MAKULU_INFO = { damageType = "magic" } },
    Imprison = { ID = 217832, MAKULU_INFO = { damageType = "magic" } },
    ImprisonDetainment = { ID = 221527, Hidden = true, MAKULU_INFO = { damageType = "magic" } },
    Metamorphosis = { ID = 191427, MAKULU_INFO = { damageType = "magic" } },
    SigilOfMisery = { ID = 207684, MAKULU_INFO = { damageType = "magic" } },
    TheHunt = { ID = 370965, FixedTexture = 3636838, MAKULU_INFO = { damageType = "magic" } },
    ThrowGlaive = { ID = 185123, Texture = 356510, MAKULU_INFO = { damageType = "magic" } },
    Torment = { ID = 185245, MAKULU_INFO = { damageType = "magic" } },
    VengefulRetreat = { ID = 198793, MAKULU_INFO = { damageType = "physical", offGcd = true } },
    SigilOfSpite = { ID = 390163, FixedTexture = 3565443, MAKULU_INFO = { damageType = "magic" } },

    BladeDance = { ID = 188499, Texture = 243188, MAKULU_INFO = { damageType = "magic" } },
    DeathSweep = { ID = 210152, Texture = 243188, MAKULU_INFO = { damageType = "magic" } },
    DemonsBite = { ID = 162243, MAKULU_INFO = { damageType = "magic" } },
    Blur = { ID = 198589 },
    ChaosStrike = { ID = 162794, Texture = 278736, MAKULU_INFO = { damageType = "magic" } },
    Annihilation = { ID = 201427, Texture = 278736, MAKULU_INFO = { damageType = "magic" } },
    EssenceBreak = { ID = 258860, MAKULU_INFO = { damageType = "magic" } },
    EyeBeam = { ID = 198013, Texture = 343311, MAKULU_INFO = { damageType = "magic" } },
    FelEruption = { ID = 211881, MAKULU_INFO = { damageType = "magic" } },
    FelRush = { ID = 195072, MAKULU_INFO = { damageType = "magic" } },
    Netherwalk = { ID = 196555, MAKULU_INFO = { damageType = "magic" } },
    SigilOfFlame = { ID = 204596, Texture = 432816, MAKULU_INFO = { damageType = "magic" } },
    SigilOfDoom = { ID = 452490, Texture = 432816, MAKULU_INFO = { damageType = "magic" } },
    GlaiveTempest = { ID = 342817, MAKULU_INFO = { damageType = "magic" } },
    FelBarrage = { ID = 258925, MAKULU_INFO = { damageType = "magic" } },
    ReaversGlaive = { ID = 442294, Texture = 356510, MAKULU_INFO = { damageType = "magic" } },

    ReverseMagic = { ID = 205604, MAKULU_INFO = { damageType = "magic" } },
    RainFromAbove = { ID = 206803, MAKULU_INFO = { damageType = "magic" } },

    Initiative = { ID = 388108, Hidden = true },
    Demonic = { ID = 213410, Hidden = true },
    ChaoticTransformation = { ID = 388112, Hidden = true },
    Momentum = { ID = 206476, Hidden = true },
    Inertia = { ID = 427640, Hidden = true },
    Ragefire = { ID = 388107, Hidden = true },
    ShatteredDestiny = { ID = 388116, Hidden = true },
    Soulscar = { ID = 388106, Hidden = true },
    DemonBlades = { ID = 203555, Hidden = true },
    UnhinderedAssault = { ID = 444931, Hidden = true },
    Detainment = { ID = 205596, Hidden = true },
    Demonsurge = { ID = 452402, Hidden = true },
    ArtOfTheGlaive = { ID = 442290, Hidden = true },
    FuriousThrows = { ID = 393029, Hidden = true },
    AFireInside = { ID = 427775, Hidden = true },
    CycleOfHatred = { ID = 258887, Hidden = true },
    RestlessHunter = { ID = 390142, Hidden = true },
    QuickenedSigils = { ID = 209281, Hidden = true },
    StudentOfSuffering = { ID = 452412, Hidden = true },

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

    AntiFakeKick = { Type = "SpellSingleColor", ID = 183752, Color = "GREEN", Desc = "AntiFake Disrupt (focus)" },	
	AntiFakeImprison = { Type = "SpellSingleColor", ID = 217832, Color = "RED", Desc = "AntiFake Imprison (focus)" },					
	AntiFakeFelEruption = { Type = "SpellSingleColor", ID = 211881, Color = "WHITE", Desc = "AntiFake Fel Eruption (focus)" },	

    ArenaPreparation = { ID = 32727, Hidden = true }, 

    FelEruptionFocus = { Type = "Spell", ID = 211881, Desc = "Focus", Texture = 58984, MAKULU_INFO = { damageType = "magic" } }, -- Shadowmeld
	ImprisonFocus = { Type = "Spell", ID = 221527, Desc = "Focus", Texture = 28730, MAKULU_INFO = { damageType = "magic" } }, -- Arcane Torrent
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

Action[ACTION_CONST_DEMONHUNTER_HAVOC] = A

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

local gameState = {
    felBarrage = false,
    essenceBreak = false,
    generatorUp = false,
    furyGen = 0,
    gcdDrain = 0,
    shouldFelblade = false,
    shouldRetreat = false,
    lowHpNova = false,
    partyDanger = false,
    aliveEnemies = 0,
    healerAlive = false,
    rgDs = 0,
    rgInc = false,
}

local buffs = {
    metamorphosis = 162264,
    felBarrage = 258925,
    immolationAura = 258920,
    immolationAuraTwo = 427912,
    tacticalRetreat = 389890,
    innerDemon = 390145,
    unboundChaos = 347462,
    momentum = 208628,
    inertia = 427641,
    arenaPreparation = 32727,
    glaiveFlurry = 442435,
    rendingStrike = 442442,
    thrillOfTheFight = 442695,
    thrillOfTheFightDmg = 442688,
    initiative = 391215,
    studentOfSuffering = 453239,
}

local debuffs = {
    essenceBreak = 320338,
    exhaustion = 57723,
    reaversMark = 442624,
}   

local function num(val)
    if val then return 1 else return 0 end
end

Player:AddTier("Tier31", { 207261, 207262, 207263, 207264, 207266 })

local interrupts = {
    { spell = Disrupt },
    { spell = ChaosNova, isCC = true, aoe = true, distance = 4 },
    { spell = Imprison, isCC = true }
}

local function shouldBurst()
    if A.BurstIsON("target") then
        if A.Zone ~= "arena" then
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemy in pairs(activeEnemies) do
                if ActionUnit(enemy):Health() > (A.ChaosStrike:GetSpellDescription()[1] * 20) or target.isDummy or target.isBoss then
                    return true
                end
            end
        else
            return true
        end
    end
    return false
end

local cacheContext     = MakuluFramework.Cache

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if enemy.distance <= 8 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function enemiesInChaosStrike()
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local total = 0

	for enemy in pairs(activeEnemies) do 
		if A.ChaosStrike:IsSpellInRange(enemy) and not ActionUnit(enemy):IsTotem() and not ActionUnit(enemy):IsPet() then 
			total = total + 1
		end 
		
		if count and total >= count then 
			break 
		end 
	end  
	
	return total 
end

local function essenceBreakUp()
    local activeEnemies = MultiUnits:GetActiveUnitPlates()

    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if enemy:Debuff(debuffs.essenceBreak, true) then 
            return true
        end 
    end  
    
    return false
end

local function activeEnemies()
    return enemiesInMelee()
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

function lowHpNova()
    local arenaUnits = {arena1, arena2, arena3}

    for _, unit in ipairs(arenaUnits) do
        if unit.exists and unit.hp < 40 and ChaosStrike:InRange(unit) and not unit.cc and unit.stunDr > 0.5 then
            return true
        end
    end

    return false
end

function partyDanger()
    local partyUnits = {party1, party2, player}

    for _, unit in ipairs(partyUnits) do
        if unit.exists and unit.hp > 0 and unit.hp < 50 and not unit:BuffFrom(MakLists.Defensive) then
            return true
        end
    end

    return false
end

local function enemiesAlive()
    local aliveEnemies = 0
    local healerAlive = false

    local arenaUnits = {arena1, arena2, arena3}

    for _, unit in ipairs(arenaUnits) do
        if unit.exists and unit.hp > 0 then
            aliveEnemies = aliveEnemies + 1
            if unit.isHealer then
                healerAlive = true
            end
        end
    end

    return aliveEnemies, healerAlive
end

local function rgDs()
    local count = 0

    if IsPlayerSpell(Demonsurge.id) then
        local dsSpells = {ChaosStrike.id, BladeDance.id, SigilOfFlame.id, EyeBeam.id, ImmolationAura.id}
        for _, spell in ipairs(dsSpells) do
            if IsSpellOverlayed(spell) then
                count = count + 1
            end
        end
    elseif IsPlayerSpell(ArtOfTheGlaive.id) then
        local buffs = {buffs.glaiveFlurry, buffs.rendingStrike}
        for _, buff in ipairs(buffs) do
            if player:Buff(buff) then
                count = count + 1
            end
        end
    end

    return count
end


local function updateGameState()
    gameState.T31has2P = Player:HasTier("Tier31", 2)
    gameState.T31has4P = Player:HasTier("Tier31", 4)

    gameState.felBarrage = A.FelBarrage:IsTalentLearned() and (FelBarrage.cd < A.GetGCD() * 7000 and (activeEnemies() >= 3 or player:Buff(buffs.metamorphosis)) or player:Buff(buffs.felBarrage))
    
    gameState.essenceBreak = essenceBreakUp() or EssenceBreak.cd > 36000

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    local felRetreat = A.GetToggle(2, "felRetreat") and Felblade.cd < 300 or not A.GetToggle(2, "felRetreat") or IsPlayerSpell(UnhinderedAssault.id)
    gameState.shouldRetreat = felRetreat

    local felbladeMelee = A.GetToggle(2, "felbladeMelee") and ChaosStrike:InRange(target) or not A.GetToggle(2, "felbladeMelee")
    gameState.shouldFelblade = felbladeMelee and (A.GetToggle(2, "felRetreat") and (VengefulRetreat.cd > 6000 and VengefulRetreat.used > 400 or IsPlayerSpell(UnhinderedAssault.id)) or not A.GetToggle(2, "felRetreat")) or VengefulRetreat.used > 400 and VengefulRetreat.used < 700

    gameState.lowHpNova = lowHpNova()
    gameState.partyDanger = partyDanger()
    gameState.aliveEnemies, gameState.healerAlive = enemiesAlive()

    gameState.rgDs = rgDs()
    gameState.rgInc = not player:Buff(buffs.rendingStrike) and player:Buff(buffs.glaiveFlurry) and BladeDance.cd < 300 and MakGcd() == 0 or gameState.rgInc and Player:PrevGCD(1, A.DeathSweep)
end

Blur:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end 
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp < A.GetToggle(2, "blurHP") then 
        return spell:Cast(player)
    end
end)

Darkness:Callback(function(spell)
    if not player.inCombat then return end
    
    if player.hp > A.GetToggle(2, "darknessHP") then return end

    return spell:Cast(player)
end)

Netherwalk:Callback(function(spell)
    if not player.inCombat then return end
    
    if player.hp > A.GetToggle(2, "netherwalkHP") then return end

    return spell:Cast(player)
end)

ImmolationAura:Callback("pre", function(spell)
    if player.inCombat then return end

    return spell:Cast(player)
end)

ChaosNova:Callback("arena", function(spell)
    if enemiesInMelee() >= 2 then
        if arena1.Cds or arena2.Cds or arena3.Cds then
            return spell:Cast(player)
        end
    end

    if gameState.lowHpNova then
        return spell:Cast(player)
    end
end)

ReverseMagic:Callback("arena", function(spell)
    if not player:DebuffFrom(MakLists.arenaDispelDebuffs) then return end

    return Debounce("RM", 1000, 2500, spell, player)
end)

Felblade:Callback("felRetreat", function(spell)
    if not gameState.shouldFelblade then return end
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if VengefulRetreat.used > 300 and VengefulRetreat.used < 700 then
        return spell:Cast(target)
    end
end)

Felblade:Callback("gapClose", function(spell)
    if not gameState.shouldFelblade then return end
    if ChaosStrike:InRange(target) then return end
    
    return spell:Cast(target)
end)

VengefulRetreat:Callback("override", function(spell)
    if MakGcd() >= 300 then return end
    if MakGcd() <= 100 then return end
    if not gameState.shouldRetreat then return end
    if not ChaosStrike:InRange(target) then return end

    return spell:Cast(player)
end)

RainFromAbove:Callback("arena", function(spell, enemy)
    if not A.RainFromAbove:IsTalentLearned() then return end

    if player.hp < 50 and not player:BuffFrom(MakLists.Defensive) then
        if RainFromAbove.cd < 300 then
            Aware:displayMessage("IN DANGER! ESCAPING TO THE SKIES! SPAM YOUR 1 KEY!", "Red", 1)
            return spell:Cast(enemy)
        end
    end
end)

-----------------------------------------------------------------
---BASIC---------------------------------------------------------
-----------------------------------------------------------------

ImmolationAura:Callback("basic", function(spell)
    if EyeBeam.cd > 2000 then return end

    return spell:Cast()
end)

SigilOfFlame:Callback("basic", function(spell)
    if not ChaosStrike:InRange(target) then return end
    if EyeBeam.cd > 2000 then return end

    return spell:Cast()
end)

EyeBeam:Callback("basic", function(spell)
    if not ChaosStrike:InRange(target) then return end

    return spell:Cast()
end)

FelRush:Callback("basic", function(spell)
    if target.distance > 5 then return end
    if not player:Buff(buffs.unboundChaos) then return end

    return spell:Cast()
end)

VengefulRetreat:Callback("basic", function(spell)
    if not ChaosStrike:InRange(target) then return end

    return spell:Cast()
end)

EssenceBreak:Callback("basic", function(spell)
    if not ChaosStrike:InRange(target) then return end

    return spell:Cast()
end)

TheHunt:Callback("basic", function(spell)
    if not player.combat then return end

    return spell:Cast(target)
end)

BladeDance:Callback("basic", function(spell)
    if not ChaosStrike:InRange(target) then return end

    return spell:Cast()
end)

ChaosStrike:Callback("basic", function(spell)

    return spell:Cast()
end)

Felblade:Callback("basic", function(spell)

    return spell:Cast()
end)

ThrowGlaive:Callback("basic", function(spell)
    if not player.inCombat then return end

    return spell:Cast()
end)

FelRush:Callback("basic2", function(spell)
    if player.fury >= 30 then return end

    return spell:Cast()
end)

local function basic()
    ImmolationAura("basic")
    SigilOfFlame("basic")
    EyeBeam("basic")
    FelRush("basic")
    VengefulRetreat("basic")
    EssenceBreak("basic")
    TheHunt("basic")
    BladeDance("basic")
    ChaosStrike("basic")
    Felblade("basic")
    ThrowGlaive("basic")
    FelRush("basic2")
end

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    local makAlert = A.GetToggle(2, "makAware")

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Immolation Single Recharge: ", ImmolationAura.cd)
        MakPrint(2, "Focus Exists: ", focus.exists)
        MakPrint(3, "GCD remains: ", MakGcd())
        MakPrint(4, "Combat Time: ", player.combatTime)
        MakPrint(5, "Chaos Strike In Range: ", ChaosStrike:InRange(target))
        MakPrint(6, "Vengeful Retreat last used: ", VengefulRetreat.used)
        MakPrint(7, "Should Felblade: ", gameState.shouldFelblade)
        MakPrint(8, "Should opener: ", (EyeBeam.cd < 300 or Metamorphosis.cd < 300) and player.combatTime < 15)
        MakPrint(9, "Enemies Alive: ", gameState.aliveEnemies)
        MakPrint(10, "Enemy Healer Alive: ", gameState.healerAlive)
        MakPrint(11, "Reaver's Glaive last used: ", ReaversGlaive.used)     
        MakPrint(12, "rgDs Count: ", gameState.rgDs)              
    end

    makInterrupt(interrupts)

    if A.IsInPvP then
        ChaosNova("arena")
        RainFromAbove("arena")
        ReverseMagic("arena")
    end

    Blur()
    Darkness()
    Netherwalk()

    if target.exists and target.canAttack and ThrowGlaive:InRange(target) then
        ImmolationAura("pre")
        
        if shouldBurst() and ChaosStrike:InRange(target) then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.ElementalPotion1, A.ElementalPotion2, A.ElementalPotion3, A.ElementalUltimate1, A.ElementalUltimate2, A.ElementalUltimate3, A.TemperedPotion, A.PotionofUnwaveringFocus)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.metamorphosis)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if player:Buff(buffs.metamorphosis) then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
        end
        
        basic()

    end

	return FrameworkEnd()
end


local buffDetectedTime = nil
local delayPassedSS = false
local SS_DELAY_DURATION = 1.5

local function shouldPurgePvP(enemy)
    if enemy.exists then
        if enemy:BuffFrom(MakLists.purgeableBuffs) then
            if not buffDetectedTime then
                buffDetectedTime = TMW.time 
            end
            
            if (TMW.time - buffDetectedTime) >= SS_DELAY_DURATION then
                delayPassedSS = true
            end
            
            return delayPassedSS
        end
    end
    
    buffDetectedTime = nil
    delayPassedSS = false
    return false
end

ConsumeMagic:Callback("arena", function(spell, enemy)
    if not enemy:BuffFrom(MakLists.purgeableBuffs) then return end

    return Debounce("CM", 1000, 2500, spell, enemy)
end)

Disrupt:Callback("arena", function(spell, enemy)
    if not A.Disrupt:IsTalentLearned() then return end
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

Imprison:Callback("arena", function(spell, enemy)
    if enemy.incapacitateDr < 0.5 then return end
    if enemy.isTarget then return end
    if enemy.cc then return end
    if not target.exists then return end

    if gameState.healerAlive and enemy.isHealer and target.hp <= 60 then
        if spell.cd < 300 then
            Aware:displayMessage("ON THE OFFENSIVE! IMPRISONING HEALER!", "Blue", 1)
            return spell:Cast(enemy)
        end
    elseif gameState.aliveEnemies <= 2 and enemy.hp > 70 and target.hp <= 60 then
        if spell.cd < 300 then
            Aware:displayMessage("ON THE OFFENSIVE! IMPRISONING OTHER ENEMY!", "Blue", 1)
            return spell:Cast(enemy)
        end
    end

    if gameState.partyDanger then
        if enemy.cds and enemy.hp > 60 then
            if spell.cd < 300 then
                Aware:displayMessage("ENEMY BURSTING AND WE'RE IN TROUBLE! USING IMPRISON ON DPS!", "Red", 1)
                return spell:Cast(enemy)
            end
        end
    end
end)

ImprisonDetainment:Callback("arena", function(spell, enemy)
    if enemy.incapacitateDr < 0.5 then return end
    if enemy.isTarget then return end
    if enemy.cc then return end
    if not target.exists then return end

    if gameState.healerAlive and enemy.isHealer and target.hp <= 60 then
        if spell.cd < 300 then
            Aware:displayMessage("ON THE OFFENSIVE! IMPRISONING HEALER!", "Blue", 1)
            return spell:Cast(enemy)
        end
    elseif gameState.aliveEnemies <= 2 and enemy.hp > 70 and target.hp <= 60 then
        if spell.cd < 300 then
            Aware:displayMessage("ON THE OFFENSIVE! IMPRISONING OTHER ENEMY!", "Blue", 1)
            return spell:Cast(enemy)
        end
    end

    if gameState.partyDanger then
        if enemy.cds and enemy.hp > 60 then
            if spell.cd < 300 then
                Aware:displayMessage("ENEMY BURSTING AND WE'RE IN TROUBLE! USING IMPRISON ON DPS!", "Red", 1)
                return spell:Cast(enemy)
            end
        end
    end
end)

FelEruption:Callback("arena", function(spell, enemy)
    if enemy.stunDr < 0.5 then return end
    if enemy.cc then return end
    if not target.exists then return end

    if enemy.isHealer and target.hp <= 40 then
        if spell.cd < 300 then
            Aware:displayMessage("ON THE OFFENSIVE! USING FEL ERUPTION ON HEALER!", "Green", 1)
            return spell:Cast(enemy)
        end
    end

    if gameState.partyDanger then
        if enemy.cds then
            if spell.cd < 300 then
                Aware:displayMessage("ENEMY BURSTING AND WE'RE IN TROUBLE! USING FEL ERUPTION ON DPS!", "Red", 1)
                return spell:Cast(enemy)
            end
        end
    end
end)


AntiFakeImprison:Callback("antifake", function(spell)
    if not focus.exists then return end
    if not focus.canAttack then return end
    if focus.incapacitateDr < 0.5 then return end
    if focus.cc then return end

    return spell:Cast(focus)
end)

AntiFakeFelEruption:Callback("antifake", function(spell)
    if not focus.canAttack then return end
    if not focus.exists then return end
    if focus.stunDr < 0.5 then return end
    if focus.cc then return end

    return spell:Cast(focus)
end)


local function antiFakeRotation()
    if not A.GetToggle(2, "antiFakeRotation") then return end

    AntiFakeFelEruption("antifake")
    AntiFakeImprison("antifake")
end

local function notHealer(unit)
    return not focus:IsUnit(unit) and not target:IsUnit(unit) and unit.exists and unit.hp > 0 and not enemyHealer:IsUnit(unit)
end

local function autoFocus(icon)
    local shouldFocus = A.GetToggle(2, "autoFocus")
    if shouldFocus == "Manual" then return end
    if player:Buff(buffs.arenaPreparation) then return end

    if target.exists then 
        if shouldFocus == "Healer" and enemyHealer.exists and enemyHealer.hp > 0 then
            if enemyHealer:IsUnit(focus) then
                if enemyHealer:IsUnit(arena1) then
                    return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA1) 
                elseif enemyHealer:IsUnit(arena2) then
                    return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA2) 
                elseif enemyHealer:IsUnit(arena3) then
                    return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA3) 
                end
            end
        end
        if shouldFocus == "OffDPS" then
            if notHealer(arena1) then
                return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA1) 
            elseif notHealer(arena2) then
                return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA2) 
            elseif notHealer(arena3) then
                return A:Show(icon, ACTION_CONST_PVP_FOCUS_ARENA3) 
            end
        end
    end
end


local enemyRotation = function(enemy)
	if not enemy.exists then return end

    ConsumeMagic("arena", enemy)
    Disrupt("arena", enemy)
    Imprison("arena", enemy)
    ImprisonDetainment("arena", enemy)
    FelEruption("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end

end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
	enemyRotation(arena1)
	partyRotation(party1)

    local af = autoFocus(icon)
    if af then return af end
	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)
	enemyRotation(arena2)
	partyRotation(party2)

    antiFakeRotation()
	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)
	enemyRotation(arena3)
	partyRotation(MakUnit:new("party3"))

	return FrameworkEnd()
end

A[9] = function(icon)
	RegisterIcon(icon)
	partyRotation(MakUnit:new("party4"))

	return FrameworkEnd()
end

A[10] = function(icon)
	RegisterIcon(icon)
	partyRotation(player)

	return FrameworkEnd()
end