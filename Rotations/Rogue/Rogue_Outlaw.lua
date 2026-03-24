if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 260 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID = {
    WillToSurvive = { ID = 59752 },
    Stoneform = { ID = 20594 },
    Shadowmeld = { ID = 58984 },
    EscapeArtist = { ID = 20589 },
    GiftOfTheNaaru = { ID = 59544 },
    Darkflight = { ID = 68992 },
    BloodFury = { ID = 33697 },
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
    
    Ambush = { ID = 8676, MAKULU_INFO = { damageType = "physical" } },
    CheapShot = { ID = 1833, MAKULU_INFO = { damageType = "physical", cc = true } },
    CrimsonVial = { ID = 185311 },
    CripplingPoison = { ID = 3408 },
    Distract = { ID = 1725 },
    Feint = { ID = 1966 },
    InstantPoison = { ID = 315584 },
    Kick = { ID = 1766, MAKULU_INFO = { damageType = "physical" } },
    KidneyShot = { ID = 408, MAKULU_INFO = { damageType = "physical", cc = true } },
    CancelBladeFlurry = { ID = 1804, FixedTexture = 133663, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Sap = { ID = 6770, MAKULU_INFO = { damageType = "physical" } },
    ShroudOfConcealment = { ID = 114018},
    SinisterStrike = { ID = 193315, MAKULU_INFO = { damageType = "physical" } },
    SliceAndDice = { ID = 315496 },
    Sprint = { ID = 2983 },
    Stealth = { ID = 1784 },
    Vanish = { ID = 1856 },
    Blind = { ID = 2094, MAKULU_INFO = { damageType = "physical", cc = true } },
    CloakOfShadows = { ID = 31224 },
    Evasion = { ID = 5277 },
    Gouge = { ID = 1776 },
    TricksOfTheTrade = { ID = 57934 },
    AtrophicPoison = { ID = 381637 },
    NumbingPoison = { ID = 5761 },
    EchoingReprimand = { ID = 470669 },
    ThistleTea = { ID = 381623 },
    ColdBlood = { ID = 382245, MAKULU_INFO = { damageType = "physical" } },
    WoundPoison = { ID = 8679 },
    
    BetweenTheEyes = { ID = 315341, MAKULU_INFO = { damageType = "physical" } },
    BladeFlurry = { ID = 13877, MAKULU_INFO = { damageType = "physical" } },
    Dispatch = { ID = 2098, FixedTexture = 236286, MAKULU_INFO = { damageType = "physical" } },
    GrapplingHook = { ID =  195457 },
    PistolShot = { ID = 185763, MAKULU_INFO = { damageType = "physical" } },
    RollTheBones = { ID = 315508 },
    AdrenalineRush = { ID = 13750, MAKULU_INFO = { damageType = "physical" } },
    BladeRush = { ID = 271877, MAKULU_INFO = { damageType = "physical" } },
    GhostlyStrike = { ID = 196937, MAKULU_INFO = { damageType = "physical" } },
    KeepItRolling = { ID = 381989 },
    KillingSpree = { ID = 51690, MAKULU_INFO = { damageType = "physical" } },
    
    
    DeathFromAbove = { ID = 269513, MAKULU_INFO = { damageType = "physical" } },
    Dismantle = { ID = 207777, MAKULU_INFO = { damageType = "physical" } },
    SmokeBomb = { ID = 212182 },
    
    -- Trickster Hero Talents
    CoupDeGrace = { ID = 441423, MAKULU_INFO = { damageType = "physical" } },
    UnseenBlade = { ID = 441146, Hidden = true },
    FlawlessForm = { ID = 441326, Hidden = true },
    DisorientiatingStrikes = { ID = 441274, Hidden = true },
    
    LoadedDice = { ID = 256170, Hidden = true },
    HiddenOpportunity = { ID = 383281, Hidden = true },
    ImprovedAmbush = { ID = 381620, Hidden = true },
    FantheHammer = { ID = 381846, Hidden = true },
    Audacity = { ID = 381845, Hidden = true },
    QuickDraw = { ID = 196938, Hidden = true },
    Ruthlessness = { ID = 14161, Hidden = true },
    Crackshot = { ID = 423703, Hidden = true },
    ImprovedAdrenalineRush = { ID = 395422, Hidden = true },
    DeftManeuvers = { ID = 381878, Hidden = true },
    ImprovedBetweenTheEyes = { ID = 235484, Hidden = true },
    GreenskinsWickers = { ID = 386823, Hidden = true },
    UnderhandedUpperHand = { ID = 424044, Hidden = true },
    Subterfuge = { ID = 108208, Hidden = true },
    FatefulEnding = { ID = 454428, Hidden = true },
    TakeEmBySurprise = { ID = 382742, Hidden = true },
    
    ElementalPotion1 = { Type = "Potion", ID = 191387, Texture = 176108, Hidden = true },
    ElementalPotion2 = { Type = "Potion", ID = 191388, Texture = 176108, Hidden = true },
    ElementalPotion3 = { Type = "Potion", ID = 191389, Texture = 176108, Hidden = true },
    ElementalUltimate1 = { Type = "Potion", ID = 191381, Texture = 176108, Hidden = true },
    ElementalUltimate2 = { Type = "Potion", ID = 191382, Texture = 176108, Hidden = true },
    ElementalUltimate3 = { Type = "Potion", ID = 191383, Texture = 176108, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
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

Action[ACTION_CONST_ROGUE_OUTLAW] = A

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

local gs = {}

local buffs = {
    arenaPreparation = 32727,
    stealth = 115191,
    vanish = 11327,
    subterfuge = 115192,
    powerInfusion = 10060,
    instantPoison = 315584,
    woundPoison = 8679,
    cripplingPoison = 3408,
    numbingPoison = 5761,
    atrophicPoison = 381637,
    takeYourCut = 198368,
    acrobaticStrikes = 455144,
    fateBoundCoinHeads = 452923,
    fateBoundCoinTails = 452917,
    etherealRampage = 458826,
    alacrity = 193538,
    -- Trickster Hero Talent Buffs
    escalatingBlade = 441786,
    flawlessForm = 441326,
    fazed = 441224, -- This is actually a debuff but tracked here for consistency
    loadedDice = 256171,
    opportunity = 195627,
    enduringBrawler = 354847,
    takeEmBySurprise = 385907,
    audacity = 386270,
    thistleTea = 381623,
    greenskinsWickers = 394131,
    betweenTheEyes = 315341,
    adrenalineRush = 13750,
    luckyCoin = 454428, -- CHECK THIS
    feint = 1966,
    --RTB ONES
    broadside = 193356,
    burriedTreasure = 199600,
    grandMelee = 193358,
    ruthlessPrecision = 193357,
    skullAndCrossbones = 199603,
    trueBearing = 193359,
    sliceAndDice = 315496
    --
}

local debuffs = {
    exhaustion = 57723,
    -- Trickster Hero Talent Debuffs
    fazed = 441224,
}

local interrupts = {
    { spell = Kick },
    --{ spell = CheapShot, isCC = true },
}

local function shouldBurst()
    if Action.BurstIsON("target") then
        return true
    end
    return false
end

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            
            for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
                local enemy = MakUnit:new(enemyGUID) 
                if enemy.distance <= 7 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                    total = total + 1
                end 
            end  
            
            return total 
    end)
end

local function activeEnemies()
    return math.max(enemiesInMelee(), 1)
end

local function AutoTarget()
    if not player.inCombat then return false end
    
    if A.Zone == "pvp" or A.Zone == "arena" then return false end
    
    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end
    
    if not A.GetToggle(2, "autoTarget") then return false end
    
    if SinisterStrike:InRange(target) and target.exists then return false end
    
    if gs.ssEnemies > 0 then
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

local function updateGameState()
    gs = {
        TWW1has2P = player:Has2Set(),
        TWW1has4P = player:Has4Set(),
        ssEnemies = activeEnemies(),
        stealthed = player:Buff(buffs.stealth) or player:Buff(buffs.vanish),
        stealthedAll = player:Buff(buffs.stealth) or player:Buff(buffs.vanish) or player:Buff(buffs.subterfuge),
        melded = player:Buff(buffs.shadowmeld),
        
        -- Trickster Hero Talent Variables
        trickster = player:TalentKnown(UnseenBlade.id),
        fatebound = player:TalentKnown(FatefulEnding.id),
        escalatingBladeStacks = player:HasBuffCount(buffs.escalatingBlade),
        flawlessForm = player:Buff(buffs.flawlessForm),
        fazedDebuff = target:Debuff(debuffs.fazed),
        coupDeGraceReady = CoupDeGrace.cd <= 0 and player:TalentKnown(CoupDeGrace.id),
    }
    
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### FUNCTIONS AND VARIABLES #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

local arenaKicks = MakLists.arenaKicks

local kickPercent = 32
local meldDuration = 0.9
local shortHalfSecond = 620
local channelKickTime = 400
local quickKick = 15

local function generateNewRandomKicks()
    kickPercent = math.random(40, 90)
    meldDuration = math.random(600, 1200) / 1000
    shortHalfSecond = math.random(400, 600) / 1000
    channelKickTime = math.random(300, 800)
    quickKick = math.random(10, 20)
    
    return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()



local function getBelowHP(percent)
    return MakMulti.party:Count(function(unit)
            return unit.hp < percent and unit.hp > 0
    end)
end

local function shouldFinish()
    --"Use finishers if at -1 from max combo points, or -2 in Stealth with Crackshot. With the hero trees, Hidden Opportunity builds also finish at -2 if Audacity or Opportunity is active" );
    
    if player.cpDeficit <= 1 then
        return true
    end
    
    if player.cpDeficit == 2 and player:Buff(buffs.stealth) and player:TalentKnown(Crackshot.id) then
        return true
    end
    
    if IsPlayerSpell(HiddenOpportunity.id) then
        if player.cpDeficit == 2 and (player:Buff(buffs.audacity) or player:Buff(buffs.opportunity)) then
            return true
        end
    end
    
    return false
end

local function rtbCount()
    local hasBroadside = player:Buff(buffs.broadside)
    local hasBurriedTreasure = player:Buff(buffs.burriedTreasure)
    local hasGrandMelee = player:Buff(buffs.grandMelee)
    local hasRuthlessPrecision = player:Buff(buffs.ruthlessPrecision)
    local hasSkullAndCrossbones = player:Buff(buffs.skullAndCrossbones)
    local hasTrueBearing = player:Buff(buffs.trueBearing)
    
    local rtbBuffs = 0
    if hasBroadside then rtbBuffs = rtbBuffs + 1 end
    if hasBurriedTreasure then rtbBuffs = rtbBuffs + 1 end
    if hasGrandMelee then rtbBuffs = rtbBuffs + 1 end
    if hasRuthlessPrecision then rtbBuffs = rtbBuffs + 1 end
    if hasSkullAndCrossbones then rtbBuffs = rtbBuffs + 1 end
    if hasTrueBearing then rtbBuffs = rtbBuffs + 1 end
    
    return rtbBuffs
end

local function shouldReRoll()
    local hasBroadside = player:Buff(buffs.broadside)
    local hasBurriedTreasure = player:Buff(buffs.burriedTreasure)
    local hasGrandMelee = player:Buff(buffs.grandMelee)
    local hasRuthlessPrecision = player:Buff(buffs.ruthlessPrecision)
    local hasSkullAndCrossbones = player:Buff(buffs.skullAndCrossbones)
    local hasTrueBearing = player:Buff(buffs.trueBearing)
    
    local rtbBuffs = rtbCount()
    
    --"Variables that define the reroll rules for Roll the Bones Default rule: reroll if the only buff that will be rolled away is Buried Treasure, or Grand Melee in single target without upcoming adds" );
    if (hasBurriedTreasure or hasGrandMelee) and not hasBroadside and not hasRuthlessPrecision and not hasTrueBearing and activeEnemies() < 2 then
        return true
    end
    
    --"If Loaded Dice is talented, then keep any 1 buff from Roll the Bones but roll it into 2 buffs when Loaded Dice is active. Also reroll 2 buffs with loaded dice up if broadside, ruthless precision and true bearing are all missing and loaded dice is up" );
    if player:TalentKnown(LoadedDice.id) then
        if rtbBuffs == 1 and player:Buff(buffs.loadedDice) then
            return true
        end
        if rtbBuffs == 2 and player:Buff(buffs.loadedDice) and not hasBroadside and not hasRuthlessPrecision and not hasTrueBearing then
            return true
        end
    end
    
    local rtbArena = A.GetToggle(2, "forceRTB")
    if Action.Zone == "arena" and rtbArena then
        return true
    end
end

local function lowestRtb()
    --We want to return the remaining duration of the lowest remaining rtb active buff on player
    local hasBroadside = player:Buff(buffs.broadside)
    local hasBurriedTreasure = player:Buff(buffs.burriedTreasure)
    local hasGrandMelee = player:Buff(buffs.grandMelee)
    local hasRuthlessPrecision = player:Buff(buffs.ruthlessPrecision)
    local hasSkullAndCrossbones = player:Buff(buffs.skullAndCrossbones)
    local hasTrueBearing = player:Buff(buffs.trueBearing)
    
    local broadSideRemains = player:BuffRemains(buffs.broadside)
    local burriedTreasureRemains = player:BuffRemains(buffs.burriedTreasure)
    local grandMeleeRemains = player:BuffRemains(buffs.grandMelee)
    local ruthlessPrecisionRemains = player:BuffRemains(buffs.ruthlessPrecision)
    local skullAndCrossbonesRemains = player:BuffRemains(buffs.skullAndCrossbones)
    local trueBearingRemains = player:BuffRemains(buffs.trueBearing)
    
    --Calculate lowest remaining buff
    local lowestBuff = 99999
    if hasBroadside and broadSideRemains < lowestBuff then
        lowestBuff = broadSideRemains
    end
    if hasBurriedTreasure and burriedTreasureRemains < lowestBuff then
        lowestBuff = burriedTreasureRemains
    end
    if hasGrandMelee and grandMeleeRemains < lowestBuff then
        lowestBuff = grandMeleeRemains
    end
    if hasRuthlessPrecision and ruthlessPrecisionRemains < lowestBuff then
        lowestBuff = ruthlessPrecisionRemains
    end
    if hasSkullAndCrossbones and skullAndCrossbonesRemains < lowestBuff then
        lowestBuff = skullAndCrossbonesRemains
    end
    if hasTrueBearing and trueBearingRemains < lowestBuff then
        lowestBuff = trueBearingRemains
    end
    
    return lowestBuff
end



local function ambushCondition()
    --default_->add_action( "variable,name=ambush_condition,value=(talent.hidden_opportunity|combo_points.deficit>=2+talent.improved_ambush+buff.broadside.up)&energy>=50" );
    if player:TalentKnown(HiddenOpportunity.id) or (player.cpDeficit >= 2 and player:TalentKnown(ImprovedAmbush.id) and player:Buff(buffs.broadside) and player.energy >= 50) then
        return true
    end
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### M+ DEFENSIVES #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

Feint:Callback(function(spell)
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[3] then return end
        
        if not player.inCombat then return end
        if player:Buff(buffs.feint) then return end
        
        if shouldDefensive() then
            return spell:Cast(player)
        end
        
        if player.hp < A.GetToggle(2, "feintHP") and not defensiveActive() then
            return spell:Cast()
        end
end)

Evasion:Callback(function(spell)
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[1] then return end
        
        if not player.inCombat then return end
        
        local playerstatus = UnitThreatSituation(player:CallerId())
        
        if playerstatus == 3 and not player:Buff(buffs.tricksOfTheTrade) then
            return spell:Cast(player)
        end
        
        if player.hp < A.GetToggle(2, "evasionHP") and not defensiveActive() then
            return spell:Cast()
        end
end)

CloakOfShadows:Callback(function(spell)
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[2] then return end
        
        if not player.inCombat then return end
        
        if shouldDefensive() then
            return spell:Cast(player)
        end
        
        if player.hp < A.GetToggle(2, "cloakHP") and not defensiveActive() then
            return spell:Cast()
        end
end)

CrimsonVial:Callback(function(spell)
        if player.hp < A.GetToggle(2, "crimsonVialHP") then
            return spell:Cast()
        end
end)

local function mPlusDefensives()
    if Action.Zone == "arena" then return end
    Feint()
    Evasion()
    CloakOfShadows()
    CrimsonVial()
end



-------------------------------------------------------------------------------------------------------------------------------
--- APL UPDATED 03/27/25
-------------------------------------------------------------------------------------------------------------------------------

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### RANDO #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

Stealth:Callback("rando", function(spell)
        if not player:Buff(buffs.stealth) then
            return spell:Cast()
        end
end)

--default_->add_action( "arcane_torrent,if=energy.base_deficit>=15+energy.regen" );
ArcaneTorrent:Callback("rando", function(spell)
        if player.energyDeficit >= 15 + GetPowerRegen() then
            return spell:Cast(target)
        end
end)

--default_->add_action( "arcane_pulse" );
ArcanePulse:Callback("rando", function(spell)
        return spell:Cast(target)
end)

--default_->add_action( "lights_judgment" );
LightsJudgment:Callback("rando", function(spell)
        return spell:Cast(target)
end)

--default_->add_action( "bag_of_tricks" );
BagOfTricks:Callback("rando", function(spell)
        return spell:Cast()
end)

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### ARENA PREP #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

BladeFlurry:Callback("arena_prep", function(spell)
        if Action.Zone == "arena" and enemyHealer.exists and enemyHealer.distance > 10 then return end
        if not player:Buff(buffs.bladeFlurry) then
            return spell:Cast()
        end
end)

Stealth:Callback("arena_prep", function(spell)
        if not player:Buff(buffs.stealth) then
            return spell:Cast()
        end
end)

AdrenalineRush:Callback("arena_prep", function(spell)
        if player:Buff(buffs.stealth) and not player:Buff(buffs.adrenalineRush) then
            return spell:Cast()
        end
end)

SliceAndDice:Callback("arena_prep", function(spell)
        if player:Buff(buffs.stealth) and not player:Buff(buffs.sliceAndDice) then
            return spell:Cast()
        end
end)

RollTheBones:Callback("arena_prep", function(spell)
        if player:Buff(buffs.stealth) then
            return spell:Cast()
        end
end)

local function arena_prep()
    if player:Buff(buffs.arenaPreparation) then return end
    if player.inCombat then return end
    if getBelowHP(100) > 0 then return end
    BladeFlurry("arena_prep")
    Stealth("arena_prep")
    AdrenalineRush("arena_prep")
    SliceAndDice("arena_prep")
    RollTheBones("arena_prep")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### HIGH PRIO #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

SmokeBomb:Callback("high_prio", function(spell)
        if Action.Zone ~= "arena" then return end
        if not target.exists then return end
        if not target:IsUnit(enemyHealer) and enemyHealer.distance <= 10 then return end
        if target.distance > 8 then return end
        if target.hp > 0 and target.hp < 30 and target.ccRemains > 1000 then
            return spell:Cast()
        end
        
        if target.hp > 0 and target.hp < 50 and target.ccRemains > 1500 then
            return spell:Cast()
        end
        
        if not target:IsUnit(enemyHealer) and target.hp > 0 and target.hp < 70 and target.ccRemains > 1500 and enemyHealer.ccRemains > 1500 then
            return spell:Cast()
        end
        
        if not target:IsUnit(enemyHealer) and target.hp > 0 and target.hp < 80 and target.ccRemains > 2000 and enemyHealer.ccRemains > 2000 then
            return spell:Cast()
        end
end)

-- Make Smarter
Evasion:Callback("high_prio", function(spell)
        if player.physImmune then return end
        if player.totalImmune then return end
        local evasionHP = A.GetToggle(2, "evasionHP")
        if player.hp < evasionHP then
            return spell:Cast()
        end
end)

-- Make Smarter
CloakOfShadows:Callback("high_prio", function(spell)
        if player.magicImmune then return end
        if player.totalImmune then return end
        local cloakHP = A.GetToggle(2, "cloakHP")
        if player.hp < cloakHP then
            return spell:Cast()
        end
end)

Feint:Callback("high_prio", function(spell)
        local feintHP = A.GetToggle(2, "feintHP")
        if player:Buff(buffs.feint) then return end
        if player.hp < feintHP then
            return spell:Cast(player)
        end
end)

-- Make Smarter
CrimsonVial:Callback("high_prio", function(spell)
        local vialHP = A.GetToggle(2, "crimsonVialHP")
        if player.hp < vialHP then
            return spell:Cast()
        end
end)

local function high_prio()
    Evasion("high_prio")
    CloakOfShadows("high_prio")
    CrimsonVial("high_prio")
    Feint("high_prio")
    SmokeBomb("high_prio")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### STEALTH CDS #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

--stealth_cds->add_action( "vanish,if=talent.underhanded_upper_hand&talent.subterfuge&talent.crackshot&buff.adrenaline_rush.up&variable.finish_condition&(!cooldown.between_the_eyes.ready&buff.ruthless_precision.up|buff.adrenaline_rush.remains<3|buff.supercharge_1.up|buff.supercharge_2.up|cooldown.vanish.full_recharge_time<15|fight_remains<8)", "Stealth Cooldowns Builds with Underhanded Upper Hand and Subterfuge must use Vanish while Adrenaline Rush is active and either BTE on CD with RP up, adrenaline rush about to expire, supercharger buff up, vanish capped on charges or about to cap or fight about to end" );
Vanish:Callback("stealth_cds", function(spell)
        if player:TalentKnown(UnderhandedUpperHand.id) and player:TalentKnown(Subterfuge.id) and player:TalentKnown(Crackshot.id) and player:Buff(buffs.adrenalineRush) and shouldFinish() and (BetweenTheEyes:Cooldown() > 1000 and player:Buff(buffs.ruthlessPrecision) or player:BuffRemains(buffs.adrenalineRush) < 3000 or player:Buff(buffs.supercharge1) or player:Buff(buffs.supercharge2) or Vanish:Cooldown() < 1500) then
            return spell:Cast()
        end
end)

--stealth_cds->add_action( "vanish,if=talent.underhanded_upper_hand&talent.subterfuge&!talent.crackshot&buff.adrenaline_rush.up&(variable.ambush_condition|!talent.hidden_opportunity)&(!cooldown.between_the_eyes.ready&buff.ruthless_precision.up|buff.ruthless_precision.down|buff.adrenaline_rush.remains<3)", "Builds with Underhanded Upper Hand and Subterfuge but without crackshot use vanish only with Adrenaline Rush active" );
Vanish:Callback("stealth_cds2", function(spell)
        if player:TalentKnown(UnderhandedUpperHand.id) and player:TalentKnown(Subterfuge.id) and not player:TalentKnown(Crackshot.id) and player:Buff(buffs.adrenalineRush) and (ambushCondition() or not IsPlayerSpell(HiddenOpportunity.id)) and (BetweenTheEyes:Cooldown() > 1000 and (player:Buff(buffs.ruthlessPrecision) or not player:Buff(buffs.ruthlessPrecision) or player:BuffRemains(buffs.adrenalineRush) < 3000)) then
            return spell:Cast()
        end
end)

--stealth_cds->add_action( "vanish,if=!talent.underhanded_upper_hand&talent.crackshot&variable.finish_condition", "Builds without Underhanded Upper Hand but with Crackshot must still use Vanish into Between the Eyes on cooldown" );
Vanish:Callback("stealth_cds3", function(spell)
        if not player:TalentKnown(UnderhandedUpperHand.id) and player:TalentKnown(Crackshot.id) and shouldFinish() then
            return spell:Cast()
        end
end)

--stealth_cds->add_action( "vanish,if=!talent.underhanded_upper_hand&!talent.crackshot&talent.hidden_opportunity&!buff.audacity.up&buff.opportunity.stack<buff.opportunity.max_stack&variable.ambush_condition", "Builds without Underhanded Upper Hand and Crackshot but still Hidden Opportunity use Vanish into Ambush when Audacity is not active and under max Opportunity stacks" );
Vanish:Callback("stealth_cds4", function(spell)
        if not player:TalentKnown(UnderhandedUpperHand.id) and not player:TalentKnown(Crackshot.id) and player:TalentKnown(HiddenOpportunity.id) and not player:Buff(buffs.audacity) and player:HasBuffCount(buffs.opportunity) < 6 and ambushCondition() then
            return spell:Cast()
        end
end)

--stealth_cds->add_action( "vanish,if=!talent.underhanded_upper_hand&!talent.crackshot&!talent.hidden_opportunity&talent.fateful_ending&(!buff.fatebound_lucky_coin.up&(buff.fatebound_coin_tails.stack>=5|buff.fatebound_coin_heads.stack>=5)|buff.fatebound_lucky_coin.up&!cooldown.between_the_eyes.ready)", "Builds without Underhanded Upper Hand, Crackshot, and Hidden Opportunity but with Fatebound use Vanish at five stacks of either Fatebound coin in order to proc the Lucky Coin if it's not already active, and otherwise continue to Vanish into a Dispatch to proc Double Jeopardy on a biased coin" );
Vanish:Callback("stealth_cds5", function(spell)
        if not player:TalentKnown(UnderhandedUpperHand.id) and not player:TalentKnown(Crackshot.id) and not player:TalentKnown(HiddenOpportunity.id) and player:TalentKnown(FatefulEnding.id) and (not player:Buff(buffs.luckyCoin) and (player:HasBuffCount(buffs.fateboundCoinTails) >= 5 or player:HasBuffCount(buffs.fateboundCoinHeads) >= 5) or player:Buff(buffs.luckyCoin) and BetweenTheEyes:Cooldown() > 1000) then
            return spell:Cast()
        end
end)


--stealth_cds->add_action( "vanish,if=!talent.underhanded_upper_hand&!talent.crackshot&!talent.hidden_opportunity&!talent.fateful_ending&talent.take_em_by_surprise&!buff.take_em_by_surprise.up", "Builds with none of the above can use Vanish to maintain Take 'em By Surprise" );
Vanish:Callback("stealth_cds6", function(spell)
        if not player:TalentKnown(UnderhandedUpperHand.id) and not player:TalentKnown(Crackshot.id) and not player:TalentKnown(HiddenOpportunity.id) and not player:TalentKnown(FatefulEnding.id) and player:TalentKnown(TakeEmBySurprise.id) and not player:Buff(buffs.takeEmBySurprise) then
            return spell:Cast()
        end
end)


--stealth_cds->add_action( "shadowmeld,if=variable.finish_condition&!cooldown.vanish.ready" );]]
Shadowmeld:Callback("stealth_cds", function(spell)
        
        if shouldFinish() and Vanish:Cooldown() > 1000 and player.stayTime > .3 then
            return spell:Cast()
        end
end)

local function stealth_cds()
    Vanish("stealth_cds")
    Vanish("stealth_cds2")
    Vanish("stealth_cds3")
    Vanish("stealth_cds4")
    Vanish("stealth_cds5")
    Vanish("stealth_cds6")
    Shadowmeld("stealth_cds")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### BUILD #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

--build->add_action( "ambush,if=talent.hidden_opportunity&buff.audacity.up", "Builders  High priority Ambush for Hidden Opportunity builds" );
Ambush:Callback("build", function(spell)
        if IsPlayerSpell(HiddenOpportunity.id) and player:Buff(buffs.audacity) then
            return spell:Cast(target)
        end
end)

--build->add_action( "pistol_shot,if=talent.fan_the_hammer&talent.audacity&talent.hidden_opportunity&buff.opportunity.up&!buff.audacity.up", "With Audacity + Hidden Opportunity + Fan the Hammer, consume Opportunity to proc Audacity any time Ambush is not available" );
PistolShot:Callback("build", function(spell)
        if IsPlayerSpell(FantheHammer.id) and IsPlayerSpell(Audacity.id) and IsPlayerSpell(HiddenOpportunity.id) and player:Buff(buffs.opportunity) and not player:Buff(buffs.audacity) then
            return spell:Cast(target)
        end
end)

--build->add_action( "pistol_shot,if=talent.fan_the_hammer&buff.opportunity.up&(buff.opportunity.stack>=buff.opportunity.max_stack|buff.opportunity.remains<2)", "With Fan the Hammer, consume Opportunity as a higher priority if at max stacks or if it will expire" );
PistolShot:Callback("build2", function(spell)
        if IsPlayerSpell(FantheHammer.id) and player:Buff(buffs.opportunity) and (player:HasBuffCount(buffs.opportunity) >= 6 or player:BuffRemains(buffs.opportunity) < 2000) then
            return spell:Cast(target)
        end
end)

--build->add_action( "pistol_shot,if=talent.fan_the_hammer&buff.opportunity.up&(combo_points.deficit>=(1+(talent.quick_draw+buff.broadside.up)*(talent.fan_the_hammer.rank+1))|combo_points<=talent.ruthlessness)", "With Fan the Hammer, consume Opportunity if it will not overcap CPs, or with 1 CP at minimum" );
PistolShot:Callback("build3", function(spell)
        if IsPlayerSpell(FantheHammer.id) and player:Buff(buffs.opportunity) and (player.cpDeficit >= (1 + (num(IsPlayerSpell(QuickDraw.id)) + num(player:Buff(buffs.broadside))) * 3) or player.cp <= num(IsPlayerSpell(Ruthlessness.id))) then
            return spell:Cast(target)
        end
end)

--build->add_action( "pistol_shot,if=!talent.fan_the_hammer&buff.opportunity.up&(energy.base_deficit>energy.regen*1.5|combo_points.deficit<=1+buff.broadside.up|talent.quick_draw.enabled|talent.audacity.enabled&!buff.audacity.up)", "If not using Fan the Hammer, then consume Opportunity based on energy, when it will exactly cap CPs, or when using Quick Draw" );
PistolShot:Callback("build4", function(spell)
        local energyRegen = GetPowerRegen()
        if not IsPlayerSpell(FantheHammer.id) and player:Buff(buffs.opportunity) and (player.energyDeficit > energyRegen * 1.5 or player.cpDeficit <= 1 + num(player:Buff(buffs.broadside)) or IsPlayerSpell(QuickDraw.id) or (IsPlayerSpell(Audacity.id) and not player:Buff(buffs.audacity))) then
            return spell:Cast(target)
        end
end)

--build->add_action( "pool_resource,for_next=1", "Fallback pooling just so Sinister Strike is never casted if Ambush is available for Hidden Opportunity builds" );

--build->add_action( "ambush,if=talent.hidden_opportunity" );
Ambush:Callback("build2", function(spell)
        if IsPlayerSpell(HiddenOpportunity.id) then
            return spell:Cast(target)
        end
end)

-- Trickster Hero Talent: Enhanced Sinister Strike for Unseen Blade stacks
-- sinister_strike,if=talent.unseen_blade&buff.escalating_blade.stack<4&!buff.flawless_form.up
SinisterStrike:Callback("trickster", function(spell)
        if not player:TalentKnown(UnseenBlade.id) then return end
        if player:HasBuffCount(buffs.escalatingBlade) >= 4 then return end
        if player:Buff(buffs.flawlessForm) then return end
        
        return spell:Cast(target)
end)

--build->add_action( "sinister_strike" );
SinisterStrike:Callback("build", function(spell)
        return spell:Cast(target)
end)

local function build()
    Ambush("build")
    PistolShot("build")
    PistolShot("build2")
    PistolShot("build3")
    PistolShot("build4")
    Ambush("build2")
    SinisterStrike("trickster")  -- Trickster priority
    SinisterStrike("build")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### CDS #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

--cds->add_action( "adrenaline_rush,if=!buff.adrenaline_rush.up&(!variable.finish_condition|!talent.improved_adrenaline_rush)|talent.improved_adrenaline_rush&combo_points<=2", "Cooldowns Use Adrenaline Rush if it is not active and the finisher condition is not met, with Improved Adrenaline Rush you can also refresh it with 2cp or less if Loaded Dice is not already up  Adrenaline rush if buff is missing unless you can finish or with 2 or less cp if loaded dice is missing" );
AdrenalineRush:Callback("cds", function(spell)
        if not shouldBurst() then return end
        if AdrenalineRush:Cooldown() > 1000 then return end
        if (not player:Buff(buffs.adrenalineRush) and (not shouldFinish() or not player:TalentKnown(ImprovedAdrenalineRush.id)) or (player:TalentKnown(ImprovedAdrenalineRush.id) and player.cp <= 2)) then
            return spell:Cast(player)
        end
end)

--cds->add_action( "blade_flurry,if=spell_targets>=2&buff.blade_flurry.remains<gcd", "Maintain Blade Flurry on 2+ targets" );
BladeFlurry:Callback("cds", function(spell)
        if activeEnemies() >= 2 and player:BuffRemains(buffs.bladeFlurry) < 700 then
            return spell:Cast()
        end
end)

--cds->add_action( "blade_flurry,if=talent.deft_maneuvers&!variable.finish_condition&(spell_targets>=3&combo_points.deficit=spell_targets+buff.broadside.up|spell_targets>=5)", "With Deft Maneuvers, use Blade Flurry on cooldown at 5+ targets, or at 3-4 targets if missing combo points equal to the amount given" );
BladeFlurry:Callback("cds2", function(spell)
        if player:TalentKnown(DeftManeuvers.id) and not shouldFinish() and (activeEnemies() >= 3 and (player.cpDeficit == activeEnemies() + num(player:Buff(buffs.broadside)) or activeEnemies() >= 5)) then
            return spell:Cast()
        end
end)
--cds->add_action( "keep_it_rolling,if=rtb_buffs>=4&(rtb_buffs.min_remains<1|(buff.broadside.up+buff.ruthless_precision.up+buff.true_bearing.up>=2))", "Use Keep it Rolling with any 4 buffs, unless you only have one of Broadside, Ruthless Precision and True Bearing, then wait until just before the lowest duration buff expires in an attempt to obtain another good buff from Count the Odds." );
KeepItRolling:Callback("cds", function(spell)
        if rtbCount() >= 4 and (lowestRtb() < 1000 or (num(player:Buff(buffs.broadside)) + num(player:Buff(buffs.ruthlessPrecision)) + num(player:Buff(buffs.trueBearing)) >= 2)) then
            return spell:Cast()
        end
end)

--cds->add_action( "keep_it_rolling,if=rtb_buffs>=3&(buff.broadside.up+buff.ruthless_precision.up+buff.true_bearing.up>=2)&(rtb_buffs.min_remains<1|(buff.broadside.up+buff.ruthless_precision.up+buff.true_bearing.up=3))", "Use Keep it Rolling with 3 buffs, if they contain at least 2 of Broadside, Ruthless Precision and True Bearing. If one of the 3 is missing, then wait until just before the lowest buff expires in an attempt to obtain it from Count the Odds." );
KeepItRolling:Callback("cds2", function(spell)
        if rtbCount() >= 3 and (num(player:Buff(buffs.broadside)) + num(player:Buff(buffs.ruthlessPrecision)) + num(player:Buff(buffs.trueBearing)) >= 2) and (lowestRtb() < 1000 or (num(player:Buff(buffs.broadside)) + num(player:Buff(buffs.ruthlessPrecision)) + num(player:Buff(buffs.trueBearing)) == 3)) then
            return spell:Cast()
        end
end)

--cds->add_action( "roll_the_bones,if=rtb_buffs.will_lose<=buff.loaded_dice.up", "Roll the bones if you have no buffs, or will lose no buffs by rolling. With Loaded Dice up, roll if you have 1 buff or will lose at most 1 buff." );
RollTheBones:Callback("cds", function(spell)
        if rtbCount() == 0 or (rtbCount() <= 1 and player:Buff(buffs.loadedDice)) then
            return spell:Cast()
        end
end)

--cds->add_action( "roll_the_bones,if=talent.keep_it_rolling&buff.loaded_dice.up&rtb_buffs<=2", "KIR builds can also roll with Loaded Dice up and at most 2 buffs in total" );
RollTheBones:Callback("cds2", function(spell)
        if player:TalentKnown(KeepItRolling.id) and player:Buff(buffs.loadedDice) and rtbCount() <= 2 then
            return spell:Cast()
        end
end)

--cds->add_action( "roll_the_bones,if=talent.hidden_opportunity&buff.loaded_dice.up&rtb_buffs<=2&!buff.broadside.up&!buff.ruthless_precision.up&!buff.true_bearing.up", "HO builds can fish for good buffs by rerolling with 2 buffs and Loaded Dice up if those 2 buffs do not contain either Broadside, Ruthless Precision or True Bearing" );
RollTheBones:Callback("cds3", function(spell)
        if player:TalentKnown(HiddenOpportunity.id) and player:Buff(buffs.loadedDice) and rtbCount() <= 2 and not player:Buff(buffs.broadside) and not player:Buff(buffs.ruthlessPrecision) and not player:Buff(buffs.trueBearing) then
            return spell:Cast()
        end
end)

--cds->add_action( "ghostly_strike,if=combo_points<cp_max_spend" );
GhostlyStrike:Callback("cds", function(spell)
        if player.cp < 7 then
            return spell:Cast(target)
        end
end)

-- Trickster Hero Talent: Enhanced Killing Spree usage
-- killing_spree,if=talent.unseen_blade&buff.escalating_blade.stack>=3&variable.finish_condition
KillingSpree:Callback("trickster", function(spell)
        if not player:TalentKnown(UnseenBlade.id) then return end
        if not shouldBurst() then return end
        if player:HasBuffCount(buffs.escalatingBlade) < 3 then return end
        if not shouldFinish() then return end
        
        return spell:Cast(target)
end)

--cds->add_action( "killing_spree,if=variable.finish_condition&!stealthed.all", "Killing Spree has higher priority than stealth cooldowns" );
KillingSpree:Callback("cds", function(spell)
        if not shouldBurst() then return end
        if shouldFinish() and not gs.stealthedAll then
            return spell:Cast(target)
        end
end)

--cds->add_action( "call_action_list,name=stealth_cds,if=!stealthed.all", "Crackshot builds use stealth cooldowns if not already in stealth" );
--in function



--cds->add_action( "blade_rush,if=energy.base_time_to_max>4&!stealthed.all", "Use Blade Rush at minimal energy outside of stealth" );
BladeRush:Callback("cds", function(spell)
        if player.energy <= 50 and not gs.stealthedAll then
            return spell:Cast(target)
        end
end)


--cds->add_action( "blood_fury" );
BloodFury:Callback("cds", function(spell)
        return spell:Cast()
end)

--cds->add_action( "berserking" );
Berserking:Callback("cds", function(spell)
        return spell:Cast()
end)

--cds->add_action( "fireblood" );
Fireblood:Callback("cds", function(spell)
        return spell:Cast()
end)

--cds->add_action( "ancestral_call" );
AncestralCall:Callback("cds", function(spell)
        return spell:Cast()
end)

--cds->add_action( "use_items,slots=trinket1,if=buff.between_the_eyes.up|trinket.1.has_stat.any_dps|fight_remains<=20", "Default conditions for usable items." );

--cds->add_action( "use_items,slots=trinket2,if=buff.between_the_eyes.up|trinket.2.has_stat.any_dps|fight_remains<=20" );

local function cds()
    AdrenalineRush("cds")
    BladeFlurry("cds")
    BladeFlurry("cds2")
    KeepItRolling("cds")
    KeepItRolling("cds2")
    RollTheBones("cds")
    RollTheBones("cds2")
    RollTheBones("cds3")
    GhostlyStrike("cds")
    KillingSpree("trickster")  -- Trickster priority
    KillingSpree("cds")
    if not gs.stealthedAll then
        stealth_cds()
    end
    BladeRush("cds")
    if player:Buff(buffs.betweenTheEyes) then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### FINISH #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

--finish->add_action( "between_the_eyes,if=!talent.crackshot&(buff.between_the_eyes.remains<4|talent.improved_between_the_eyes|talent.greenskins_wickers)&!buff.greenskins_wickers.up", "Finishers Use Between the Eyes to keep the crit buff up, but on cooldown if Improved/Greenskins, and avoid overriding Greenskins" );
BetweenTheEyes:Callback("finish", function(spell)
        if not player:TalentKnown(Crackshot.id) and (player:BuffRemains(buffs.betweenTheEyes) < 4000 or player:TalentKnown(ImprovedBetweenTheEyes.id) or player:TalentKnown(GreenskinsWickers.id)) and not player:Buff(buffs.greenskinsWickers) then
            return spell:Cast(target)
        end
end)

--finish->add_action( "between_the_eyes,if=talent.crackshot&(buff.ruthless_precision.up|buff.between_the_eyes.remains<4)", "Crackshot builds use Between the Eyes outside of Stealth to refresh the Between the Eyes crit buff or on cd with the Ruthless Precision buff" );
BetweenTheEyes:Callback("finish2", function(spell)
        if player:TalentKnown(Crackshot.id) and (player:Buff(buffs.ruthlessPrecision) or player:BuffRemains(buffs.betweenTheEyes) < 4000) then
            return spell:Cast(target)
        end
end)

--finish->add_action( "cold_blood" );
ColdBlood:Callback("finish", function(spell)
        return spell:Cast(target)
end)

-- Trickster Hero Talent: Coup de Grace
-- coup_de_grace,if=debuff.fazed.up&(cooldown.between_the_eyes.remains>45|!talent.crackshot)
CoupDeGrace:Callback("finish", function(spell)
        if not player:TalentKnown(spell.id) then return end
        if not target:Debuff(debuffs.fazed) then return end
        
        local betweenTheEyesCondition = BetweenTheEyes.cd > 45000 or not player:TalentKnown(Crackshot.id)
        
        if betweenTheEyesCondition then
            return spell:Cast(target)
        end
end)

-- Trickster Hero Talent: Enhanced Dispatch for Coup de Grace
-- dispatch,if=talent.unseen_blade&buff.escalating_blade.stack>=4&!debuff.fazed.up
Dispatch:Callback("trickster", function(spell)
        if not player:TalentKnown(UnseenBlade.id) then return end
        if player:HasBuffCount(buffs.escalatingBlade) < 4 then return end
        if target:Debuff(debuffs.fazed) then return end
        
        return spell:Cast(target)
end)

Dispatch:Callback("coup", function(spell)
        if not IsSpellOverlayed(spell.id) then return end
        
        return spell:Cast(target)
end)


--finish->add_action( "dispatch" );
Dispatch:Callback("finish", function(spell)
        if IsSpellOverlayed(spell.id) then return end
        return spell:Cast(target)
end)

local function finish()
    BetweenTheEyes("finish")
    BetweenTheEyes("finish2")
    ColdBlood("finish")
    CoupDeGrace("finish")  -- Trickster hero talent priority
    Dispatch("trickster")  -- Trickster enhanced Dispatch
    Dispatch("coup")
    Dispatch("finish")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### POISONS #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

InstantPoison:Callback(function(spell)
        if player.inCombat then return end
        if gs.imCasting then
            if gs.imCasting == spell.id or gs.imCasting == WoundPoison.id then return end
        end
        if player:BuffRemains(buffs.instantPoison) >= 60000 then return end
        if player:BuffRemains(buffs.woundPoison) >= 60000 then return end
        
        return spell:Cast()
end)

WoundPoison:Callback(function(spell)
        if player.inCombat then return end
        if gs.imCasting then
            if gs.imCasting == spell.id or gs.imCasting == InstantPoison.id then return end
        end
        if player:BuffRemains(buffs.instantPoison) >= 600000 and not Action.Zone == "arena" then return end
        if player:BuffRemains(buffs.woundPoison) >= 600000 then return end
        
        return spell:Cast()
end)

NumbingPoison:Callback(function(spell)
        if player.inCombat then return end
        if gs.imCasting then
            if gs.imCasting == spell.id or gs.imCasting == CripplingPoison.id or gs.imCasting == AtrophicPoison.id then return end
        end
        if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end
        
        return spell:Cast()
end)

AtrophicPoison:Callback(function(spell)
        if player.inCombat then return end
        if gs.imCasting then
            if gs.imCasting == spell.id or gs.imCasting == CripplingPoison.id or gs.imCasting == NumbingPoison.id then return end
        end
        if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end
        
        return spell:Cast()
end)

CripplingPoison:Callback(function(spell)
        if player.inCombat then return end
        if gs.imCasting then
            if gs.imCasting == spell.id or gs.imCasting == NumbingPoison.id or gs.imCasting == AtrophicPoison.id then return end
        end
        if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
        if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end
        
        return spell:Cast()
end)

local function poisons()
    CripplingPoison()
    if Action.Zone == "arena" then WoundPoison() else InstantPoison() end
    if Action.Zone == "arena" then arena_prep() end
end



--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### STEALTH #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

--stealth->add_action( "cold_blood,if=variable.finish_condition", "Stealth" );
ColdBlood:Callback("stealth", function(spell)
        if shouldFinish() then
            return spell:Cast(target)
        end
end)

--stealth->add_action( "pool_resource,for_next=1", "Ensure Crackshot BtE is not skipped because of low energy" );
-- IDK

--stealth->add_action( "between_the_eyes,if=variable.finish_condition&talent.crackshot&(!buff.shadowmeld.up|stealthed.rogue)", "High priority Between the Eyes for Crackshot, except not directly out of Shadowmeld" );
BetweenTheEyes:Callback("stealth", function(spell)
        if shouldFinish() and player:TalentKnown(Crackshot.id) and (not player:Buff(buffs.shadowmeld) or gs.stealthed) then
            return spell:Cast(target)
        end
end)

--stealth->add_action( "dispatch,if=variable.finish_condition" );
Dispatch:Callback("stealth", function(spell)
        if IsSpellOverlayed(spell.id) then return end
        if shouldFinish() then
            return spell:Cast(target)
        end
end)

--stealth->add_action( "pistol_shot,if=talent.crackshot&talent.fan_the_hammer.rank>=2&buff.opportunity.stack>=6&(buff.broadside.up&combo_points<=1|buff.greenskins_wickers.up)", "2 Fan the Hammer Crackshot builds can consume Opportunity in stealth with max stacks, Broadside, and low CPs, or with Greenskins active" );
PistolShot:Callback("stealth", function(spell)
        if player:TalentKnown(Crackshot.id) and player:HasBuffCount(buffs.opportunity) >= 6 and (player:Buff(buffs.broadside) and player.cp <= 1 or player:Buff(buffs.greenskinsWickers)) then
            return spell:Cast(target)
        end
end)

--stealth->add_action( "ambush,if=talent.hidden_opportunity" );
Ambush:Callback("stealth", function(spell)
        if IsPlayerSpell(HiddenOpportunity.id) then
            return spell:Cast(target)
        end
end)

local function stealth()
    ColdBlood("stealth")
    BetweenTheEyes("stealth")
    Dispatch("stealth")
    PistolShot("stealth")
    Ambush("stealth")
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()
    
    high_prio()
    poisons()
    mPlusDefensives()
    if Action.Zone ~= "arena" then makInterrupt(interrupts) end
    
    if target.exists and target.canAttack then
        if not player.inCombat then
            Stealth("rando")
        end
        
        if SinisterStrike:InRange(target) and not player:Debuff(410201) then
            
            cds()
            stealth()
            if shouldFinish() then finish() end
            build()
            ArcaneTorrent("rando")
            ArcanePulse("rando")
            LightsJudgment("rando")
            BagOfTricks("rando")
            
        end
        
    end
    
    return FrameworkEnd()
end

--#######################################################################################################################################################################
--#######################################################################################################################################################################
--##### ARENA ENEMY ROTATION #####
--#######################################################################################################################################################################
--#######################################################################################################################################################################

Sap:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if player.inCombat then return end
        if not gs.stealthedAll then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if enemy.distance > 10 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.incapacitateDr < .5 then return end
        if enemy.ccRemains > 700 then return end
        
        if A.GetToggle(2, "makAware") then Aware:displayMessage("SAP - Enemy Healer", "Blue", 1) end
        return spell:Cast(enemy)
end)

Kick:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if not enemy.exists then return end
        if not enemy.player then return end
        if enemy.distance > 10 then return end
        if not enemy:IsSafeToKick() then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end
        
        return spell:Cast(enemy)
end)

Blind:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if not player.inCombat then return end
        if player:Buff(buffs.stealth) then return end
        if not enemy:IsPlayer() then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.disorientDr < .5 then return end
        if enemy.ccRemains > 700 then return end
        if enemy.distance < 10 then return end
        if enemy:Buff(6940) then return end
        if enemy:IsUnit(enemyHealer) and not enemy:IsUnit(target) then
            if target.hp <= 60 and enemy.disorientDr == 1 then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Blind - Enemy Healer", "Blue", 1) end
                return spell:Cast(enemy)
            end
            
            if target.hp <= 30  then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Blind - Enemy Healer - Low", "Blue", 1) end
                return spell:Cast(enemy)
            end
        end
end)

Gouge:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.incapacitateDr < .5 then return end
        if enemy.ccRemains > 700 then return end
        if enemy.distance > 10 then return end
        
        if enemy:IsUnit(enemyHealer) and not enemy:IsUnit(target) then
            if target.hp < 40 then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Gouge - Enemy Healer", "Blue", 1) end
                return spell:Cast(enemy)
            end
        end
        
        if enemy:IsUnit(enemyHealer) and not enemy:IsUnit(target) and enemy:CastingFromFor(MakLists.arenaKicks, 620) then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Gouge - Enemy Healer - Casting", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
        if not enemy:IsUnit(enemyHealer) and not enemy:IsUnit(target) and getBelowHP(40) > 0 and enemy:CastingFromFor(MakLists.arenaKicks, 620) then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Gouge - OT - Peel", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
        if getBelowHP(50) > 0 and enemy:CastingFromFor(MakLists.arenaKicks, 620) then
            return spell:Cast(enemy)
        end
end)

KidneyShot:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.stunDr < .5 then return end
        if enemy.distance > 10 then return end
        if enemy.ccRemains > 700 then return end
        if player.cp < 5 then return end
        
        if enemy:IsUnit(enemyHealer) and enemy.stunDr >= .5 then
            
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Kidney Shot - Healer - DR", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
        if not enemy:IsUnit(enemyHealer) and enemy:IsUnit(target) then
            if enemy.hp > 10 and enemy.hp < 40 then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Kidney Shot - KT - Low", "Blue", 1) end
                return spell:Cast(enemy)
            end
            
            if enemy.hp > 10 and enemy.hp < 70 and (enemyHealer.ccRemains > 2000 or not enemyHealer.exists) then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Kidney Shot - KT - Cross CC", "Blue", 1) end
                return spell:Cast(enemy)
            end
            
            if enemy.hp > 10 and enemy.hp < 90 and enemy.stunDr == 1 and (enemyHealer.ccRemains > 2000 or not enemyHealer.exists) then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Kidney Shot - KT - Cross CC DR", "Blue", 1) end
                return spell:Cast(enemy)
            end
        end
        
        if not enemy:IsUnit(enemyHealer) and enemy.stunDr == 1 then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Kidney Shot - DR Test", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
end)

CheapShot:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if not gs.stealthedAll then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.distance > 10 then return end
        if enemy.stunDr < .5 then return end
        if enemy.ccRemains > 700 then return end
        if player.cp < 5 then return end
        
        if enemy:IsUnit(enemyHealer) and enemy.stunDr >= .5 then
            
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Cheap Shot - Healer - DR", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
        if not enemy:IsUnit(enemyHealer) and enemy:IsUnit(target) then
            if enemy.hp > 10 and enemy.hp < 40 then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Cheap Shot - KT - Low", "Blue", 1) end
                return spell:Cast(enemy)
            end
            
            if enemy.hp > 10 and enemy.hp < 70 and (enemyHealer.ccRemains > 2000 or not enemyHealer.exists) then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Cheap Shot - KT - Cross CC", "Blue", 1) end
                return spell:Cast(enemy)
            end
            
            if enemy.hp > 10 and enemy.hp < 90 and enemy.stunDr == 1 and (enemyHealer.ccRemains > 2000 or not enemyHealer.exists) then
                if A.GetToggle(2, "makAware") then Aware:displayMessage("Cheap Shot - KT - Cross CC DR", "Blue", 1) end
                return spell:Cast(enemy)
            end
        end
        
        if not enemy:IsUnit(enemyHealer) and enemy.stunDr == 1 then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Cheap Shot - DR Test", "Blue", 1) end
            return spell:Cast(enemy)
        end
        
end)

Dismantle:Callback("enemy_rotation", function(spell, enemy)
        if GrapplingHook:Used() > 0 and GrapplingHook:Used() < 500 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.ccRemains > 700 then return end
        if enemy.distance > 10 then return end
        if enemy:Buff(446035) then return end
        if enemy:Buff(227847) then return end
        if enemy:HasBuffFromFor(MakLists.Disarm, 630) then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Disarm - Bursting", "Blue", 1) end
            return spell:Cast(enemy)
        end
end)

CancelBladeFlurry:Callback("enemy_rotation", function(spell)
        if target:IsUnit(enemyHealer) then return end
        if not player.inCombat then return end
        if not player:Buff(buffs.bladeFlurry) then return end
        if enemyHealer.exists and enemyHealer.distance > 10 then return end
        
        if enemyHealer:Debuff(MakLists.BreakableCC) then
            if A.GetToggle(2, "makAware") then Aware:displayMessage("Cancel Blade Flurry - Breakable CC on Healer", "Blue", 1) end
            return spell:Cast()
        end
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    Sap("enemy_rotation", enemy)
    Blind("enemy_rotation", enemy)
    CheapShot("enemy_rotation", enemy)
    KidneyShot("enemy_rotation", enemy)
    Kick("enemy_rotation", enemy)
    Dismantle("enemy_rotation", enemy)
    Gouge("enemy_rotation", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end
    
end

A[6] = function(icon)
    RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
    if AutoTarget() then return TabTarget() end
    CancelBladeFlurry("enemy_rotation")
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

