-- TODO:
-- Racial overhaul
-- Ranged fallback
-- 2h weapon check
-- runeforge enchant check
-- Remove new talent comments for TWW
-- Convert rest of zerk PVP logic (other things thatn kick/cc)


if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 251 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle        = Action.GetToggle
local BossMods         = Action.BossMods
local Unit             = Action.Unit

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

    -- Death Knight General
    AbominationLimb = { ID = 383269, MAKULU_INFO = { damageType = "magic" } },
    AntiMagicShell = { ID = 48707 },
    AntiMagicShellSW = { ID = 410358 },
    AntiMagicZone = { ID = 51052 },
    BlindingSleet = { ID = 207167 },
    ChainsofIce = { ID = 45524 },
    DarkCommand = { ID = 56222 },
    DeathandDecay = { ID = 43265 },
    DeathCoil = { ID = 47541 },
    DeathGrip = { ID = 49576, MAKULU_INFO = { damageType = "magic" } },
    DeathStrike = { ID = 49998, MAKULU_INFO = { damageType = "physical" } },
    DeathsAdvance = { ID = 48265 },
    IceboundFortitude = { ID = 48792 },
    Lichborne = { ID = 49039 },
    MindFreeze = { ID = 47528, MAKULU_INFO = { damageType = "magic" } },
    PathofFrost = { ID = 3714 },
    RaiseAlly = { ID = 61999 },
    RaiseDead = { ID = 46585 },
    DeathCoilPlayer	= { Type = "Spell", ID = 47541, Hidden = true, Texture = 98008 },
    SoulReaper = { ID = 343294, MAKULU_INFO = { damageType = "magic" } },

    -- Frost  Oblit
    EmpowerRuneWeapon = { ID = 47568 },
    FrostStrike = { ID = 49143, MAKULU_INFO = { damageType = "magic" } },
    FrostwyrmsFury = { ID = 279302, MAKULU_INFO = { damageType = "magic" } },
    HowlingBlast = { ID = 49184, MAKULU_INFO = { damageType = "magic" } },
    Obliterate = { ID = 49020, MAKULU_INFO = { damageType = "physical" } },
    PillarofFrost = { ID = 51271 },
    RemorselessWinter = { ID = 196770, Texture = 136917, MAKULU_INFO = { damageType = "magic" } },
    GlacialAdvance = { ID = 194913, MAKULU_INFO = { damageType = "magic" } },
    HornofWinter = { ID = 57330 },
    ChillStreak = { ID = 305392, MAKULU_INFO = { damageType = "magic" } },
    ReapersMark = { ID = 439843, MAKULU_INFO = { damageType = "magic" } },
    BreathofSindragosa = { ID = 1249658, MAKULU_INFO = { damageType = "magic" } },
    Frostscythe = { ID = 207230, MAKULU_INFO = { damageType = "magic" } },

    Frostbane = { ID = 455993, MAKULU_INFO = { damageType = "magic" } },
    -- Talents
    CleavingStrikes = { ID = 316916 },
    ShatteringBlade = { ID = 207057, Hidden = true },
    GatheringStorm = { ID = 194912, Hidden = true },
    BitingCold = { ID = 377056, Hidden = true },
    ArcticAssault = { ID = 456230, Hidden = true },
    FrigidExecutioner = { ID = 377073, Hidden = true },
    RageOfTheFrozenChampion = { ID = 377076, Hidden = true },
    Icebreaker = { ID = 392950, Hidden = true },
    Avalanche = { ID = 207142, Hidden = true },
    UnleashedFrenzy = { ID = 376905, Hidden = true },
    SmotheringOffense = { ID = 435005, Hidden = true },
    DarkTalons = { ID = 435006, Hidden = true },
    Obliteration = { ID = 281238, Hidden = true },
    ShatteredFrost = { ID = 455993, Hidden = true },
    ColdHeart = { ID = 281208, Hidden = true },
    IcyTalons = { ID = 194878, Hidden = true },
    UnyieldingWill = { ID = 457574, Hidden = true },
    EnduringStrength = { ID = 377190, Hidden = true },
    TheLongWinter = { ID = 456240, Hidden = true },
    WitherAway = { ID = 441894, Hidden = true },
    FrozenDominion = { ID = 377226, Hidden = true },


    -- Borrowed/Other/Talents/Depreciated (CARRY OVER FROM UNHOLY - CLEANUP NEEDED)
    DeathCoilPet = { ID = 213690, Texture = 132179 },
    Defile = { ID = 152280 },
    SacrificialPact = { ID = 327574 },
    ControlUndead = { ID = 111673 },
    Asphyxiate = { ID = 108194, MAKULU_INFO = { damageType = "physical" } },
    DeathPact = { ID = 48743 },
    WraithWalk = { ID = 212552 },
    ClawingShadows = { ID = 207311 },
    ScourgeStrike = { ID = 55090 },
    Outbreak = { ID = 77575 },
    DarkTransformation = { ID = 63560 },
    Epidemic = { ID = 207317 },
    Apocalypse = { ID = 275699 },
    VileContagion = { ID = 390279 },
    RaiseAbomination = { ID = 288853 },
    ArmyoftheDead = { ID = 42650 },
    SummonGargoyle = { ID = 49206 },
    UnholyAssault = { ID = 207289 },
    Leap = { ID = 47482 },
    Gnaw = { ID = 47481 },
    Huddle = { ID = 47484 },
    Reanimation = { ID = 210128 },
    Strangulate = { ID = 47476, MAKULU_INFO = { damageType = "magic" } },
    DarkSimulacrum = { ID = 77606 },
    UnholyEndurance = { ID = 389682, Hidden = true },
    ImprovedDeathCoil = { ID = 377580, Hidden = true },
    CoilofDevastation = { ID = 390270, Hidden = true },
    Festermight = { ID = 377590, Hidden = true },
    BurstingSores = { ID = 207264, Hidden = true },
    InfectedClaws = { ID = 207272, Hidden = true },
    ArmyoftheDamned = { ID = 276837, Hidden = true },
    RottenTouch = { ID = 390275, Hidden = true },
    SuddenDoom = { ID = 49530, Hidden = true },
    CommanderoftheDead = { ID = 390259, Hidden = true },
    Plaguebringer = { ID = 390175, Hidden = true },
    UnholyBlight = { ID = 115989, Hidden = true },
    Superstrain = { ID = 390283, Hidden = true },
    EbonFever = { ID = 207269, Hidden = true },
    UnholyGround = { ID = 374265, Hidden = true },
    MagusoftheDead = { ID = 390196, Hidden = true },
    Morbidity = { ID = 377592, Hidden = true },
    DeathandDecayBuff = { ID = 188290, Hidden = true },
    FrostFever = { ID = 55095, Hidden = true },
    BloodPlague = { ID = 55078, Hidden = true },
    UnholyStrength = { ID = 53365, Hidden = true },
    FesteringWound = { ID = 194310, Hidden = true },
    RottenTouchDebuff = { ID = 390276, Hidden = true },
    SuddenDoomBuff = { ID = 81340, Hidden = true },
    CommanderoftheDeadBuff = { ID = 390260, Hidden = true },
    PlaguebringerBuff = { ID = 390178, Hidden = true },
    VirulentPlague = { ID = 191587, Hidden = true },
    DeathRot = { ID = 377540, Hidden = true },

    -- Hero Stuff
    RidersChampion = { ID = 444005, Hidden = true },
    ApocalypseNow = { ID = 444040, Hidden = true },
    AFeastofSouls = { ID = 444072, Hidden = true },
    ReaperofSouls = { ID = 440002, Hidden = true },



    -- Potions and Utility
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

    -- Auras
    ArenaPreparation = { ID = 32727, Hidden = true },

    -- Zerker (Queues for Scuzz)
    AsphyxiateFocus = { Type = "Spell", ID = 108194, Hidden = true, Texture = 260364 },
	DeathGripFocus = { Type = "Spell", ID = 49576, Hidden = true, Texture = 255654 },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DEATHKNIGHT_FROST] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
local mouseover
local pet = ConstUnit.pet
local arena1 = ConstUnit.arena1
local arena2 = ConstUnit.arena2
local arena3 = ConstUnit.arena3
local party1 = ConstUnit.party1
local party2 = ConstUnit.party2

local gameState = {
    pooling = false,
    partyDanger = false,
    aliveEnemies = 0,
    healerAlive = false,
    rwBuffs = false,
    twoHandCheck = false,
    staticObliterateBuffs = false,
    breathRPCost = 0,
    staticRimeBuffs = false,
    breathRPThreshhold = 60,
    erwBreathRPTrigger = 70,
    erwBreathRuneTrigger = 3,
    oblitRunePooling = 4,
    breathRimeRPThreshhold = 60,
    stDnd = 1,
    playerRunes = 0,
    activeEnemies = 0,
    stPlanning = false,
    addsRemain = false,
    sendingCDs = false,
    useBreath = false,
    rimeBuffs = false,
    RPBuffs = false,
    cooldownCheck = false,
    trueBreathCooldown = 0,
    oblitPoolingTime = 0,
    breathPoolingTime = 0,
    poolingRunes = false,
    poolingRP = false,
    gaPriority = false,
    breathDying = false,
    fightRemains = 0,
    breathCooldown = 0,
    fwfBuffs = false,

}

local buffs = {
    empowerRuneWeapon = 47568,
    rime = 59052,
    pillarOfFrost = 51271,
    remorselesswinter = 196770,
    icyTalons = 194879,
    killingMachine = 51124,
    deathAndDecay = 188290,
    unleashedFrenzy = 376907,
    lichborne = 49039,
    antiMagicZone = 145629,
    antiMagicShell = 410358,
    darkSuccor = 178819,
    wraithWalk = 212552,
    deathsAdvance = 48265,
    pathOfFrost = 3714,
    mograineMight = 444047,
    exterminate = 441378,
    painfulDeath = 443564,
    aFeastOfSouls = 444072,
    breathOfSindragosa = 1249658,
    unholyStrength = 53365,
    bonegrinder = 377098,
    trollbaineIcyFury = 444097,
    frostbane = 455993,
    coldHeart = 281209,
    reaperOfSouls = 440002,
    gatheringStorm = 211805,

}

local debuffs = {
    frostFever = 55095,
    razorice = 51714,
    reapersMarkDebuff = 434765,
}

local talents = {
    cleavingstrikes = 316916,


}

local interrupts = {
    { spell = MindFreeze, isCC = false },
    { spell = Strangulate, isCC = false },
    { spell = DeathGrip, isCC = false },
    { spell = Asphyxiate, isCC = true },
    { spell = BlindingSleet, isCC = true, aoe = true },



}

local function num(val)
    if val then return 1 else return 0 end
end

Player:AddTier("Tier31", { 207261, 207262, 207263, 207264, 207266 })

local function AutoAntiMagicZonePvp()
    local checkDmgBuffsfromEnemy = {
        51271,   -- Pillar of Frost
        207289,  -- Unholy Assault
        323639,  -- The Hunt
        194223,  -- Celestial Alignment
        375087,  -- Dragonrage
        190319,  -- Combustion
        12472,   -- Icy Veins
        365350,  -- Arcane Surge
        31884,   -- Avenging Wrath
        2825,    -- Bloodlust
        114051,  -- Ascendance
        205180,  -- Summon Darkglare
        265187,  -- Summon Demonic Tyrant
		258925,  -- Fel Barrage
		357210,	 -- Deep Breath
    }

    for _, buffID in ipairs(checkDmgBuffsfromEnemy) do
        if target:HasBuff(buffID) then
            if imtarget() then
                if A.AntiMagicZone:IsReadyByPassCastGCD() then
                    return true
				end

                if A.AntiMagicShell:IsReadyByPassCastGCD() and A.AntiMagicZone:GetCooldown() > 5 and Unit(player):HealthPercent() <= 50 then
                    return true
                end
            end
            break
        end
    end

    return false
end

local runeMax = 6 -- The maximum number of runes

local function runeTimeTo(x)
    -- Validate input
    if not x or x <= 0 or x > runeMax then
        return 0
    end

    -- Get the current time
    local currentTime = GetTime()
    if not currentTime then
        return 0
    end

    -- Store the cooldown remaining for each rune
    local runeCooldowns = {}

    -- Fill the runeCooldowns table with the cooldown remaining for each rune
    for i = 1, runeMax do
        local start, duration, runeReady = GetRuneCooldown(i)
        if runeReady then
            runeCooldowns[i] = 0 -- Rune is ready
        elseif start and duration then
            runeCooldowns[i] = (start + duration) - currentTime -- Time remaining until the rune is ready
        else
            runeCooldowns[i] = 0 -- Default to 0 if we can't get rune info
        end
    end

    -- Sort the cooldowns in ascending order
    table.sort(runeCooldowns)

    -- Sum the cooldowns of the first `x` runes
    local timeRequired = 0
    for i = 1, x do
        if runeCooldowns[i] then
            timeRequired = math.max(timeRequired, runeCooldowns[i])
        end
    end

    return timeRequired or 0
end

local function shouldBurst()
    if A.BurstIsON("target") then
        --if A.Zone ~= "arena" then
        --    local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --    for enemy in pairs(activeEnemies) do
        --        if ActionUnit(enemy):Health() > (A.FrostStrike:GetSpellDescription()[1] * 20) or target.isDummy or target.isBoss or target:IsPlayer() then
        --            return true
        --        end
        --    end
        --else
            return true
        --end
    end
    --return false
end

local cacheContext     = MakuluFramework.Cache

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 10 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end
        end

        return total
    end)
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

local function partyDanger()
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

local function updateGameState()
    -- Safety check for player object
    if not player or not player.exists then
        return
    end
-- Makulu Frost DK helper utilities for hero/talent-driven logic
local function isDeathbringer()
    return A.ReaperofSouls and A.ReaperofSouls:IsTalentLearned()
end
local function isRider()
    return A.RidersChampion and A.RidersChampion:IsTalentLearned()
end
local function kmStacks()
    return player:HasBuffCount(buffs.killingMachine) or 0
end
local function has2KM()
    return kmStacks() >= 2
end
local function bgStacks()
    return player:HasBuffCount(buffs.bonegrinder) or 0
end
local function hasTBIF()
    return player:Buff(buffs.trollbaineIcyFury)
end
local function erwCharges()
    if A.EmpowerRuneWeapon and A.EmpowerRuneWeapon.Fraction then
        return A.EmpowerRuneWeapon:Fraction() or 0
    end
    return 0
end
local function canCastERW()
    return A.EmpowerRuneWeapon and A.EmpowerRuneWeapon:GetCooldown() == 0
end

-- Centralized ERW decision to match requested priority list
local function shouldPressERW()
    local rp = player.runicPower or 0
    local rune = player.rune or 0
    local rime = player:Buff(buffs.rime)
    local km = player:HasBuffCount(buffs.killingMachine) or 0
    local charges = erwCharges()
    local bosKnown = A.BreathofSindragosa:IsTalentLearned()
    local bosUp = player:Buff(buffs.breathOfSindragosa)
    local bosCD = bosKnown and (A.BreathofSindragosa:GetCooldown() or 999999) or 999999
    local pillarKnown = A.PillarofFrost:IsTalentLearned()
    local pillarUp = player:Buff(buffs.pillarOfFrost)
    local pillarCD = pillarKnown and (A.PillarofFrost:GetCooldown() or 999999) or 999999
    local fbKnown = IsPlayerSpell(A.Frostbane.ID)
    local fbProc = player:Buff(buffs.frostbane)

    -- Hold rules for upcoming windows
    if not bosUp and bosCD < 30000 and charges < 2 then return false end
    if not pillarUp and pillarCD < 7000 then return false end

    -- Starvation: no abilities available, 0-1 KM -> cast
    if rune < 1 and rp < 25 and not rime and km <= 1 then return true end
    -- If 2KM and starved -> do NOT cast; wait to consume
    if rune < 1 and rp < 25 and km >= 2 then return false end

    -- BoS upkeep safeguards
    if bosUp and (rp < 40 or (rp < gameState.erwBreathRPTrigger and rune < gameState.erwBreathRuneTrigger)) then
        return true
    end

    -- Last GCD in Pillar window
    if pillarUp and player:BuffRemains(buffs.pillarOfFrost) < Action.GetGCD() * 1.1 then
        if km == 0 then return true end -- free OB/FSC and fish for 2nd stack
        if km == 1 then return true end -- free consume
        -- If last press was ERW, we would prefer to not press again; we can't reliably detect last press, so skip extra logic here
    end

    -- Specific low-RP flows (rp < 40 approximately)
    if rp < 40 then
        if rime and km == 0 then
            -- No rp, Rime, 0KM -> cast after Rime if still no KM; approximate: allow here
            return true
        end
        if rime and km == 1 then
            -- No rp, Rime, 1KM -> consume Rime first; allow ERW afterwards
            return true
        end
        if not rime and km == 1 then
            -- No rp, no Rime, 1KM -> consume KM first then ERW; we don't force ERW yet
            return false
        end
        if rime and km >= 2 then
            -- No rp, Rime, 2KM -> don't cast; consume 2KM asap
            return false
        end
    end

    -- 40+ RP general cases
    if rp >= 40 then
        if km == 0 and not rime then
            -- Chance the Rime proc first
            return false
        end
        if km == 1 and not rime then
            -- Chance Rime or consume KM first
            return false
        end
        if rime and km <= 1 then
            -- Rime then FS then ERW -> allow press after using GCDs; approximate: allow here
            return true
        end
        if km >= 2 and not rime then
            -- Consume 2KM asap; don't ERW now
            return false
        end
    end

    -- Frostbane-specific rules
    if fbKnown then
        if rp >= 40 then
            if rime and km == 0 then return false end -- Rime then FB
            if rime and km == 1 then return false end -- Rime -> FB -> KM
            if not rime and km == 0 then return false end -- FB -> (maybe Rime) -> ERW if needed (don’t auto ERW yet)
            if not rime and km == 1 then return true end -- FB into ERW for 2x consume if no proc
        else -- rp low
            if fbProc and rime and km == 0 then return true end -- Rime then ERW for RP
            if fbProc and rime and km == 1 then return true end -- Rime -> ERW -> FB -> 2KM
            if fbProc and rime and km == 2 then return false end -- Consume 2KM asap
            if fbProc and not rime and km == 1 then return true end -- ERW for 2x consume
            if fbProc and km >= 2 then return true end -- Consume 2KM into ERW afterwards (approx: allow)
        end
    end

    -- Default: don't press
    return false
end



-- Prefer OB (ST) or FSC (cleave/AoE) for consuming KM
local function kmConsumePrefer(tag)
    if kmStacks() == 0 and not (isRider() and hasTBIF()) then return end
    local preferFSC = false
    if IsPlayerSpell(A.Frostscythe.ID) then
        if activeEnemies() >= (gameState.frostscythePrio or 3) then
            preferFSC = true
        elseif A.GetToggle(2, "AoE") and activeEnemies() >= 2 then
            preferFSC = true
        end
    end
    -- ALWAYS prefer Frostscythe in AoE, even during Obliteration
    if preferFSC and A.Frostscythe and A.Frostscythe.Cast then
        return A.Frostscythe:Cast(target)
    end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 and A.Frostscythe and A.Frostscythe.Cast then
        return A.Frostscythe:Cast(target)
    end
    if A.Obliterate and A.Obliterate.Cast then
        return A.Obliterate:Cast(target)
    end
end

-- Simple KM fishing: try Rime > FS > HoW to jiggle procs
local function fishKM()
    if player:Buff(buffs.rime) and A.HowlingBlast and A.HowlingBlast.Cast then return A.HowlingBlast:Cast(target) end
    if player.runicPower and player.runicPower >= 35 and A.FrostStrike and A.FrostStrike.Cast then return A.FrostStrike:Cast(target) end
    if player.rune and player.rune < 2 and A.HornofWinter and A.HornofWinter.Cast then return A.HornofWinter:Cast(player) end
end

-- Breath macro: Breath -> Trinkets -> Pillar -> Racials -> Reaper's Mark
local function breathMacro()
    if not shouldBurst() then return end
    if not player:Buff(buffs.breathOfSindragosa) then BreathofSindragosa("cooldowns") end
    -- Use trinkets before Pillar of Frost for proper timing
    if Trinket then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
    PillarofFrost("cooldowns_early")
    racials()
    ReapersMark("cooldowns")
end

--================== Deathbringer: Breath Opener & Priority ==================
local function dbBreathOpener()
    if not shouldBurst() then return end
    -- ERW -> KM consume -> Breath macro -> ERW/KM sequencing
    if canCastERW() and shouldPressERW() then A.EmpowerRuneWeapon:Cast(player) end
    kmConsumePrefer("db_open_km")
    breathMacro()
    -- Build to 2 KM using ERW if needed
    if kmStacks() < 2 and canCastERW() and shouldPressERW() then A.EmpowerRuneWeapon:Cast(player) end
    kmConsumePrefer("db_open_km2")
    if canCastERW() and shouldPressERW() then A.EmpowerRuneWeapon:Cast(player) end
    kmConsumePrefer("db_open_km3")
end

local function dbBreathPriority()
    -- 2KM
    if has2KM() then if kmConsumePrefer("db_breath_2km") then return true end end
    -- ERW: 2 charges with 1KM and RP<60
    if canCastERW() and shouldPressERW() then
        if A.EmpowerRuneWeapon:Cast(player) then return true end
    end
    -- 1KM with Exterminate during CDs
    if kmStacks() >= 1 and player:Buff(buffs.exterminate) and gameState.sendingCDs then
        if kmConsumePrefer("db_breath_km_exterm") then return true end
    end
    -- 1KM at BG=4 if won’t misalign (approx: just check >=4)
    if kmStacks() >= 1 and bgStacks() >= 4 then
        if kmConsumePrefer("db_breath_km_bg4") then return true end
    end
    -- 1KM
    if kmStacks() >= 1 then if kmConsumePrefer("db_breath_km") then return true end end
    -- Rime
    if player:Buff(buffs.rime) then if A.HowlingBlast:Cast(target) then return true end end
    -- Frost Strike
    if A.FrostStrike:Cast(target) then return true end
    -- ERW fallback
    if canCastERW() and shouldPressERW() then if A.EmpowerRuneWeapon:Cast(player) then return true end end
    -- Safety fallback: do not cast OB/FSC without KM in DB
    return false
end

--================== Frostbane (Shattered Frost) ST & AoE ==================
local function frostbaneSTOpener()
    if not shouldBurst() then return end
    -- Use trinkets before Pillar of Frost for proper timing
    if Trinket then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
    PillarofFrost("cooldowns_early")
    ReapersMark("cooldowns")
    racials()
    if canCastERW() and shouldPressERW() then A.EmpowerRuneWeapon:Cast(player) end
    kmConsumePrefer("fb_open_km")
    if kmStacks() < 2 and canCastERW() then A.EmpowerRuneWeapon:Cast(player) end
    if kmStacks() >= 1 then kmConsumePrefer("fb_open_km2") end
end

local function frostbaneST()
    -- 2KM
    if has2KM() and kmConsumePrefer("fb_st_2km") then return true end
    -- ERW 2 charges with 1KM and RP<60
    if canCastERW() and shouldPressERW() then
        if A.EmpowerRuneWeapon:Cast(player) then return true end
    end
    -- 1KM with Exterminate
    if kmStacks()>=1 and player:Buff(buffs.exterminate) then if kmConsumePrefer("fb_st_km_exterm") then return true end end
    -- 1KM at BG=4
    if kmStacks()>=1 and bgStacks()>=4 then if kmConsumePrefer("fb_st_km_bg4") then return true end end
    -- 1KM
    if kmStacks()>=1 then if kmConsumePrefer("fb_st_km") then return true end end
    -- Rime
    if player:Buff(buffs.rime) then if A.HowlingBlast:Cast(target) then return true end end
    -- 5 Razorice Frost Strike if SB build
    if A.ShatteringBlade:IsTalentLearned() and target:HasDeBuffCount(debuffs.razorice) == 5 then if A.FrostStrike:Cast(target) then return true end end
    -- Frostbane/Frost Strike
    if IsPlayerSpell(A.Frostbane.ID) then if A.Frostbane:Cast(target) then return true end else if A.FrostStrike:Cast(target) then return true end end
    -- ERW
    if canCastERW() and shouldPressERW() then if A.EmpowerRuneWeapon:Cast(player) then return true end end
    -- Oblit (KM-only rule handled above)
    return false
end

local function frostbaneAOE()
    -- 1KM at BG=4 first (if won’t misalign – approximated)
    if kmStacks()>=1 and bgStacks()>=4 then if kmConsumePrefer("fb_aoe_km_bg4") then return true end end
    -- Rime
    if player:Buff(buffs.rime) then if A.HowlingBlast:Cast(target) then return true end end
    -- Frostbane
    if IsPlayerSpell(A.Frostbane.ID) then if A.Frostbane:Cast(target) then return true end end
    -- 2KM
    if has2KM() then if kmConsumePrefer("fb_aoe_2km") then return true end end
    -- ERW 2 charges with 1KM and RP<60
    if canCastERW() and shouldPressERW() then
        if A.EmpowerRuneWeapon:Cast(player) then return true end
    end
    -- 1KM with Exterminate
    if kmStacks()>=1 and player:Buff(buffs.exterminate) then if kmConsumePrefer("fb_aoe_km_exterm") then return true end end
    -- 1KM
    if kmStacks()>=1 then if kmConsumePrefer("fb_aoe_km") then return true end end
    -- ERW 1 charge
    if canCastERW() and shouldPressERW() then if A.EmpowerRuneWeapon:Cast(player) then return true end end
    -- Glacial Advance
    if A.GlacialAdvance:Cast(target) then return true end
    -- Oblit/FSC thresholds
    if (player:Buff(buffs.remorselesswinter) and activeEnemies() >= 2) or activeEnemies() >= 3 then
        if A.Frostscythe:Cast(target) then return true end
    end
    return false
end

--================== Rider: Breath Opener & Priority ==================
local function riderBreathOpener()
    if not shouldBurst() then return end
    if canCastERW() and shouldPressERW() then A.EmpowerRuneWeapon:Cast(player) end
    if (player.runicPower or 0) < 60 then kmConsumePrefer("rider_open_km_lowrp") end
    FrostwyrmsFury("cooldowns")
    breathMacro()
end

local function riderBreath()
    -- 2KM
    if has2KM() and kmConsumePrefer("rider_breath_2km") then return true end
    -- ERW 2 charges with 1KM and RP<60
    if canCastERW() and shouldPressERW() then
        if A.EmpowerRuneWeapon:Cast(player) then return true end
    end
    -- 1KM with TBIF
    if kmStacks()>=1 and hasTBIF() then if kmConsumePrefer("rider_breath_km_tbif") then return true end end
    -- 1KM at BG=4
    if kmStacks()>=1 and bgStacks()>=4 then if kmConsumePrefer("rider_breath_km_bg4") then return true end end
    -- 1KM
    if kmStacks()>=1 then if kmConsumePrefer("rider_breath_km") then return true end end
    -- Rime
    if player:Buff(buffs.rime) then if A.HowlingBlast:Cast(target) then return true end end
    -- Frost Strike
    if A.FrostStrike:Cast(target) then return true end
    -- ERW
    if canCastERW() and shouldPressERW() then if A.EmpowerRuneWeapon:Cast(player) then return true end end
    -- Natty OB/FSC only with TBIF allowance
    if hasTBIF() then
        if activeEnemies() >= (gameState.frostscythePrio or 3) and A.Frostscythe and A.Frostscythe.Cast and A.Frostscythe:Cast(target) then return true end
        -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
        if not (IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2) and A.Obliterate and A.Obliterate.Cast and A.Obliterate:Cast(target) then return true end
    end
    return false
end
--===============================================================================

    local function twoHandCheck()
        -- Get the item link for the main hand slot
        local itemLink = GetInventoryItemLink("player", INVSLOT_MAINHAND)

        -- Check if there's an item in the main hand slot
        if itemLink then
            -- Get item info using the item link
            local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                  itemEquipLoc, itemTexture, sellPrice, classID, subclassID = GetItemInfo(itemLink)

            if classID and subclassID then
                -- List of 2H weapon subclass IDs (as of current WoW version)
                local twoHandedWeapons = {
                    [1] = true,  -- Two-Handed Axes
                    [5] = true,  -- Two-Handed Maces
                    [8] = true,  -- Two-Handed Swords
                    [10] = true, -- Polearms
                    [6] = true,  -- Staves
                }

                -- Check if the item is a weapon and is one of the 2H weapon subclass IDs
                if classID == LE_ITEM_CLASS_WEAPON and twoHandedWeapons[subclassID] then
                    return true
                end
            end
        end
        return false
    end

    --# Variables (Fixed) - Updated to match new APL
    -- variable,name=rw_buffs,value=talent.gathering_storm|talent.biting_cold
    gameState.rwBuffs = A.GatheringStorm:IsTalentLearned() or A.BitingCold:IsTalentLearned()
    gameState.twoHandCheck = twoHandCheck()
    gameState.staticObliterateBuffs = A.ArcticAssault:IsTalentLearned() or A.FrigidExecutioner:IsTalentLearned() or gameState.twoHandCheck
    -- variable,name=breath_rp_cost,value=dbc.power.9067.cost_per_tick%10
    gameState.breathRPCost = 17
    -- variable,name=static_rime_buffs,value=talent.rage_of_the_frozen_champion|talent.icebreaker|talent.bind_in_darkness
    gameState.staticRimeBuffs = A.RageOfTheFrozenChampion:IsTalentLearned() or A.Icebreaker:IsTalentLearned()
    -- APL Variable Options (these would normally be configurable)
    gameState.breathRPThreshhold = 60
    gameState.erwBreathRPTrigger = 70
    gameState.erwBreathRuneTrigger = 3
    gameState.oblitRunePooling = 4
    gameState.breathRimeRPThreshhold = 60
    gameState.stDnd = 1
    gameState.playerRunes = player.rune

    --# Variables (Live) - Updated to match new APL logic
    -- Compute area TTD (max enemy TTD) for fight remaining decisions
    local highestTTD = 0
    do
        local plates = MultiUnits:GetActiveUnitPlates()
        for enemyGUID in pairs(plates) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.isDummy then
                highestTTD = 99999
            elseif enemy.ttd and enemy.ttd > 0 and enemy.ttd > highestTTD then
                highestTTD = enemy.ttd
            end
        end
    end
    gameState.fightRemains = highestTTD

    gameState.activeEnemies = activeEnemies()
    -- Unified "send CDs" rules
    gameState.stPlanning = gameState.activeEnemies == 1
    gameState.addsRemain = gameState.activeEnemies >= 2
    local inRaid = IsInRaid and IsInRaid() or false
    gameState.sendingCDs = shouldBurst() and (gameState.stPlanning or gameState.addsRemain or (inRaid and gameState.fightRemains < 20000) or (not inRaid and gameState.fightRemains > 10000))
    -- BoS gating: allow either ST planning or any AoE
    gameState.useBreath = gameState.stPlanning or gameState.activeEnemies >= 2
    -- variable,name=rime_buffs,value=buff.rime.react&(variable.static_rime_buffs|talent.avalanche&!talent.arctic_assault&debuff.razorice.stack<5)
    local targetRazoriceStacks = (target and target.exists) and target:HasDeBuffCount(debuffs.razorice) or 0
    gameState.rimeBuffs = player:HasBuff(buffs.rime) and (gameState.staticRimeBuffs or (A.Avalanche:IsTalentLearned() and not A.ArcticAssault:IsTalentLearned() and targetRazoriceStacks < 5))
    -- variable,name=rp_buffs,value=talent.unleashed_frenzy&(buff.unleashed_frenzy.remains<gcd.max*3|buff.unleashed_frenzy.stack<3)|talent.icy_talons&(buff.icy_talons.remains<gcd.max*3|buff.icy_talons.stack<(3+(2*talent.smothering_offense)))
    gameState.RPBuffs = (A.UnleashedFrenzy:IsTalentLearned() and (player:BuffRemains(buffs.unleashedFrenzy) < Action.GetGCD() * 3 or player:HasBuffCount(buffs.unleashedFrenzy) < 3)) or (A.IcyTalons:IsTalentLearned() and (player:BuffRemains(buffs.icyTalons) < Action.GetGCD() * 3 or player:HasBuffCount(buffs.icyTalons) < (3 + (2 * num(A.SmotheringOffense:IsTalentLearned())))))
    -- cooldown_check per SimC: (talent.pillar_of_frost & buff.pillar_of_frost.up) | !talent.pillar_of_frost | fight_remains < 20s
    gameState.cooldownCheck = ((A.PillarofFrost:IsTalentLearned() and player:Buff(buffs.pillarOfFrost)) or not A.PillarofFrost:IsTalentLearned() or gameState.fightRemains < 20000)

    -- variable,name=true_breath_cooldown,op=setif,value=cooldown.breath_of_sindragosa.remains,value_else=cooldown.pillar_of_frost.remains,condition=cooldown.breath_of_sindragosa.remains>cooldown.pillar_of_frost.remains
    local breathCD = A.BreathofSindragosa:GetCooldown() or 0
    local pillarCD = A.PillarofFrost:GetCooldown() or 0
    if breathCD > pillarCD then
        gameState.trueBreathCooldown = breathCD
    else
        gameState.trueBreathCooldown = pillarCD
    end

    -- variable,name=oblit_pooling_time (keep our approximation used for oblit pooling prep)
    if player and player.rune and player.rune < gameState.oblitRunePooling and A.PillarofFrost:GetCooldown() < 10000 then
        local gcd = Action.GetGCD()
        if gcd and gcd > 0 and (player.rune + 1) > 0 then
            gameState.oblitPoolingTime = ((A.PillarofFrost:GetCooldown() + 1000) / gcd) / (player.rune + 1) * 6000
        else
            gameState.oblitPoolingTime = 5000
        end
    else
        gameState.oblitPoolingTime = 5000
    end

    -- variable,name=breath_pooling_time (retain approximation)
    if player and player.runicPowerDeficit and player.runicPowerDeficit > 10 and gameState.trueBreathCooldown < 10000 then
        local gcd = Action.GetGCD()
        local denominator = (player.rune + 1) * (player.runicPower + 20)
        if gcd and gcd > 0 and denominator > 0 then
            gameState.breathPoolingTime = ((gameState.trueBreathCooldown + 1000) / gcd) / denominator * 100
        else
            gameState.breathPoolingTime = 0
        end
    else
        gameState.breathPoolingTime = 0
    end

    -- variable,name=rune_pooling,value=hero_tree.deathbringer&cooldown.reapers_mark.remains<6&rune<3&variable.sending_cds
    local hasDeathbringer = A.ReaperofSouls and A.ReaperofSouls:IsTalentLearned()
    gameState.poolingRunes = hasDeathbringer and (A.ReapersMark:GetCooldown() < 6000) and (player.rune < 3) and gameState.sendingCDs

    -- variable,name=rp_pooling,value=talent.breath_of_sindragosa&cooldown.breath_of_sindragosa.remains<4*gcd.max&runic_power<60+(35+5*buff.icy_onslaught.up)-(10*rune)&variable.sending_cds
    -- We don't track icy_onslaught in this framework, so treat its stack contribution as 0
    -- Made less aggressive to reduce downtime
    if A.BreathofSindragosa:IsTalentLearned() then
        local bosCD = A.BreathofSindragosa:GetCooldown()
        local rpThreshold = 85 - (10 * (player.rune or 0)) -- Reduced from 95 to 85
        -- Only pool when very close to BoS (2 GCDs instead of 4)
        gameState.poolingRP = (bosCD < 2 * Action.GetGCD()) and (player.runicPower < rpThreshold) and gameState.sendingCDs
    else
        gameState.poolingRP = false
    end

    -- variable,name=ga_priority,value=(!talent.shattered_frost&talent.shattering_blade&active_enemies>=4)|(!talent.shattered_frost&!talent.shattering_blade&active_enemies>=2)
    gameState.gaPriority = (not A.ShatteredFrost:IsTalentLearned() and A.ShatteringBlade:IsTalentLearned() and activeEnemies() >= 4) or (not A.ShatteredFrost:IsTalentLearned() and not A.ShatteringBlade:IsTalentLearned() and activeEnemies() >= 2)

    -- variable,name=breath_dying,value=runic_power<variable.breath_rp_cost*2*gcd.max&rune.time_to_2>runic_power%variable.breath_rp_cost
    if player and player.runicPower and gameState.breathRPCost and gameState.breathRPCost > 0 then
        local runeTime = runeTimeTo(2)
        local rpRatio = player.runicPower / gameState.breathRPCost
        gameState.breathDying = player.runicPower < gameState.breathRPCost * 2 * Action.GetGCD() and runeTime > rpRatio
    else
        gameState.breathDying = false
    end

    -- variable,name=frostscythe_prio,value=dynamic based on cleave
    -- Prefer 2+ targets with Cleaving Strikes + RW; otherwise 3; Rider can raise to 4
    do
        local rider = A.RidersChampion:IsTalentLearned()
        local cleaveRW = A.CleavingStrikes:IsTalentLearned() and player:Buff(buffs.remorselesswinter)
        local aoeCleave2 = A.GetToggle(2, "AoE") and activeEnemies() >= 2 and IsPlayerSpell(A.Frostscythe.ID)
        if aoeCleave2 and cleaveRW and not (A.Obliteration:IsTalentLearned() and player:Buff(buffs.pillarOfFrost)) then
            gameState.frostscythePrio = 2
        elseif rider and not cleaveRW then
            gameState.frostscythePrio = 4
        else
            gameState.frostscythePrio = 3
        end
    end

    -- variable,name=breath_of_sindragosa_check,value=talent.breath_of_sindragosa&(cooldown.breath_of_sindragosa.remains>20|(cooldown.breath_of_sindragosa.up&runic_power>=(60-20*hero_tree.deathbringer)))
    do
        local deathbringerMod = (A.ReaperofSouls and A.ReaperofSouls:IsTalentLearned()) and 20 or 0
        local bosCD = A.BreathofSindragosa:GetCooldown() or 0
        gameState.breathCheck = A.BreathofSindragosa:IsTalentLearned() and (bosCD > 20000 or (bosCD == 0 and (player.runicPower or 0) >= (60 - deathbringerMod))) or false
    end
    -- gameState.fightRemains computed above
    -- variable,name=fwf_buffs,value=(buff.pillar_of_frost.remains<gcd.max|(buff.unholy_strength.up&buff.unholy_strength.remains<gcd.max)|(talent.bonegrinder.rank=2&buff.bonegrinder_frost.up&buff.bonegrinder_frost.remains<gcd.max))&(active_enemies>1|debuff.razorice.stack=5|!death_knight.runeforge.razorice&(!talent.glacial_advance|!talent.avalanche|!talent.arctic_assault)|talent.shattering_blade)
    local targetRazoriceStacks2 = (target and target.exists) and target:HasDeBuffCount(debuffs.razorice) or 0
    gameState.fwfBuffs = (player:BuffRemains(buffs.pillarOfFrost) < Action.GetGCD() or (player:Buff(buffs.unholyStrength) and player:BuffRemains(buffs.unholyStrength) < Action.GetGCD())) and (activeEnemies() > 1 or targetRazoriceStacks2 == 5 or (not A.GlacialAdvance:IsTalentLearned() or not A.Avalanche:IsTalentLearned() or not A.ArcticAssault:IsTalentLearned()) or A.ShatteringBlade:IsTalentLearned())

end

WraithWalk:Callback(function(spell)
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return end
    if locData.locType ~= "ROOT" then return end

    return spell:Cast(player)
end)

local deathsAdvanceList = {
    204666, -- Shattered Earth (Oakheart)
    199345, -- Down Draft (Dresaron)
}

DeathsAdvance:Callback(function(spell)
    if MultiUnits:GetByRangeCasting(nil, 1, nil, deathsAdvanceList) == 0 then return end

    return spell:Cast(player)
end)

Lichborne:Callback(function(spell)
    if not A.UnholyEndurance:IsTalentLearned() then return end
    if not shouldDefensive() then return end

    return spell:Cast(player)
end)

IceboundFortitude:Callback(function(spell)
    if not shouldDefensive() then return end

    return spell:Cast(player)
end)

AntiMagicShell:Callback(function(spell)
    if not shouldDefensive() then return end

    return spell:Cast(player)
end)

DeathPact:Callback(function(spell)
    if player.hp > A.GetToggle(2, "DeathPactSlider") then return end
    if not player.inCombat then return end

    return spell:Cast(player)
end)

DeathStrike:Callback(function(spell)
    if player.hp > A.GetToggle(2, "DeathStrikeSlider") then return end

    return spell:Cast(target)
end)

RaiseDead:Callback(function(spell)
    if player.combatTime <= 0 then return end
    if pet.exists and pet.hp > 0 then return end

    return spell:Cast(player)
end)

--###################################### AOE ######################################

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react=2|(buff.killing_machine.react&rune>=3)
-- Modified: NEVER cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
Obliterate:Callback("aoe", function(spell)
    local kmStacks = player:HasBuffCount(buffs.killingMachine) or 0
    local fscKnown = IsPlayerSpell(A.Frostscythe.ID)
    -- If Frostscythe is known and we're in AoE (2+ enemies), never cast Obliterate
    if fscKnown and activeEnemies() >= 2 then return end
    if not (kmStacks >= 2 or (kmStacks >= 1 and player.rune >= 3)) then return end
    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!variable.pooling_runic_power&debuff.razorice.stack=5&talent.shattering_blade&(talent.shattered_frost|active_enemies<4)
FrostStrike:Callback("aoe", function(spell)
    if gameState.poolingRP then return end
    if target:HasDeBuffCount(debuffs.razorice) ~= 5 then return end
    if not A.ShatteringBlade:IsTalentLearned() then return end
    if not (A.ShatteredFrost:IsTalentLearned() or activeEnemies() < 4) then return end

    return spell:Cast(target)
end)

-- howling_blast,if=buff.rime.react
HowlingBlast:Callback("aoe", function(spell)
    -- SimC: howling_blast,if=buff.rime.react|!dot.frost_fever.ticking
    if not player:HasBuff(buffs.rime) and target:HasDeBuff(debuffs.frostFever) then return end
    return spell:Cast(target)
end)

-- glacial_advance,target_if=max:(debuff.razorice.stack),if=!variable.pooling_runic_power&(variable.ga_priority|debuff.razorice.stack<5)
GlacialAdvance:Callback("aoe", function(spell)
    if gameState.poolingRP then return end
    if not (gameState.gaPriority or target:HasDeBuffCount(debuffs.razorice) < 5) then return end

    return spell:Cast(target)
end)

-- Use Exterminate charges with Frostscythe in AoE (highest priority) - costs only 1 rune and summons scythes
Frostscythe:Callback("aoe_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    if not IsPlayerSpell(A.Frostscythe.ID) then return end
    if activeEnemies() < 2 then return end

    return spell:Cast(target)
end)

-- Use Exterminate charges with Obliterate in AoE (highest priority) - costs only 1 rune and summons scythes
Obliterate:Callback("aoe_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    -- Only use if Frostscythe is not available
    if IsPlayerSpell(A.Frostscythe.ID) then return end

    return spell:Cast(target)
end)

-- frostscythe,if=(buff.killing_machine.react=2|(buff.killing_machine.react&rune>=3))&active_enemies>=variable.frostscythe_prio
Frostscythe:Callback("aoe", function(spell)
    local kmStacks = player:HasBuffCount(buffs.killingMachine) or 0
    if not ((kmStacks >= 2 or (kmStacks >= 1 and player.rune >= 3)) and activeEnemies() >= (gameState.frostscythePrio or 3)) then return end
    return spell:Cast(target)
end)

-- frostscythe,if=buff.killing_machine.react&!variable.rune_pooling&active_enemies>=variable.frostscythe_prio
Frostscythe:Callback("aoe2", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    if gameState.poolingRunes then return end
    if activeEnemies() < (gameState.frostscythePrio or 3) then return end
    return spell:Cast(target)
end)

-- obliterate
-- Modified: NEVER cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
Obliterate:Callback("aoe2", function(spell)
    local fscKnown = IsPlayerSpell(A.Frostscythe.ID)
    -- If Frostscythe is known and we're in AoE (2+ enemies), never cast Obliterate
    if fscKnown and activeEnemies() >= 2 then return end
    local kmStacks = player:HasBuffCount(buffs.killingMachine) or 0
    if kmStacks < 1 then return end
    if gameState.poolingRunes then return end
    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!variable.pooling_runic_power
FrostStrike:Callback("aoe2", function(spell)
    if gameState.poolingRP then return end

    return spell:Cast(target)
end)

-- horn_of_winter,if=rune<2&runic_power.deficit>25&(!talent.breath_of_sindragosa|variable.true_breath_cooldown>cooldown.horn_of_winter.duration-15)
HornofWinter:Callback("aoe", function(spell)
    if player.rune >= 2 then return end
    if player.runicPowerDeficit <= 25 then return end
    if not (not A.BreathofSindragosa:IsTalentLearned() or gameState.trueBreathCooldown > (A.HornofWinter:GetCooldown() - 15000)) then return end

    return spell:Cast(player)
end)

-- arcane_torrent,if=runic_power.deficit>25
ArcaneTorrent:Callback("aoe", function(spell)
    if player.runicPowerDeficit <= 25 then return end

    return spell:Cast(player)
end)

-- abomination_limb,if=variable.sending_cds
AbominationLimb:Callback("aoe", function(spell)
    if not gameState.sendingCDs then return end
    return spell:Cast(player)
end)

local function aoe()
    -- Use Exterminate charges first (highest priority) - costs only 1 rune and summons scythes
    Frostscythe("aoe_exterminate")
    Obliterate("aoe_exterminate")

    -- SimC AoE: prefer Frostscythe at N targets, then KM Obliterate, Rime HB, spenders, fillers
    Frostscythe("aoe")
    Obliterate("aoe")
    HowlingBlast("aoe")
    FrostStrike("aoe")
    GlacialAdvance("aoe")
    Frostscythe("aoe2")
    Obliterate("aoe2")
    HowlingBlast("aoe")
    FrostStrike("aoe2")
    HornofWinter("aoe")
    ArcaneTorrent("aoe")

    -- Emergency fallback abilities to prevent downtime in AoE
    if player.rune >= 1 and not gameState.poolingRunes then
        -- Always prefer Frostscythe over Obliterate in AoE
        if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 and A.Frostscythe and A.Frostscythe.Cast then
            A.Frostscythe:Cast(target)
        elseif A.Obliterate and A.Obliterate.Cast then
            A.Obliterate:Cast(target)
        end
    end

    if player.runicPower >= 25 and not gameState.poolingRP and A.FrostStrike and A.FrostStrike.Cast then
        A.FrostStrike:Cast(target)
    end

    -- Last resort: resource generation
    if player.rune < 2 and player.runicPowerDeficit > 20 and A.HornofWinter and A.HornofWinter.Cast then
        A.HornofWinter:Cast(player)
    end
end

--##################################### BREATH ACTIVE ######################################

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice+((hero_tree.deathbringer&debuff.reapers_mark_debuff.up)*5),if=buff.killing_machine.react&buff.pillar_of_frost.up
Obliterate:Callback("breath", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    if not player:Buff(buffs.pillarOfFrost) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- howling_blast,if=(variable.rime_buffs|!buff.killing_machine.react&buff.pillar_of_frost.up&talent.obliteration)&runic_power>(variable.breath_rime_rp_threshold-(talent.rage_of_the_frozen_champion*(dbc.effect.842306.base_value%10)))|!dot.frost_fever.ticking
HowlingBlast:Callback("breath", function(spell)
    if (gameState.rimeBuffs or (not player:Buff(buffs.killingMachine) and player:Buff(buffs.pillarOfFrost) and A.Obliteration:IsTalentLearned())) and player.runicPower > (gameState.breathRimeRPThreshhold - (num(A.RageOfTheFrozenChampion:IsTalentLearned()) * 10)) then
        return spell:Cast(target)
    end
    if not target:HasDeBuff(debuffs.frostFever) then
        return spell:Cast(target)
    end
end)

-- horn_of_winter,if=rune<2&runic_power.deficit>30&(!buff.empower_rune_weapon.up|runic_power<variable.breath_rp_cost*2*gcd.max)
HornofWinter:Callback("breath", function(spell)
    if player.rune >= 2 then return end
    if player.runicPowerDeficit <= 30 then return end
    if not (not player:Buff(buffs.empowerRuneWeapon) or player.runicPower < gameState.breathRPCost * 2 * Action.GetGCD()) then return end

    return spell:Cast(player)
end)

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice+((hero_tree.deathbringer&debuff.reapers_mark_debuff.up)*5),if=buff.killing_machine.react|runic_power.deficit>20
Obliterate:Callback("breath2", function(spell)
    if not (player:Buff(buffs.killingMachine) or player.runicPowerDeficit > 20) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&target.time_to_pct_0>5&active_enemies<=1&rune>2
SoulReaper:Callback("breath", function(spell)
    if gameState.fightRemains <= 5000 then return end
    if target.hp > 35 then return end
    if target.hp <= 0 then return end
    if activeEnemies() > 1 then return end
    if player.rune <= 2 then return end

    return spell:Cast(target)
end)

-- howling_blast,if=variable.breath_dying
HowlingBlast:Callback("breath2", function(spell)
    if not gameState.breathDying then return end

    return spell:Cast(target)
end)

-- arcane_torrent,if=runic_power<60
ArcaneTorrent:Callback("breath", function(spell)
    if player.runicPower >= 60 then return end

    return spell:Cast(player)
end)

-- howling_blast,if=buff.rime.react
HowlingBlast:Callback("breath3", function(spell)
    if not player:Buff(buffs.rime) then return end

    return spell:Cast(target)
end)

--actions.breath+=/arcane_torrent,if=runic_power<60
ArcaneTorrent:Callback("breath", function(spell)
    if player.runicPower >= 60 then return end

    return spell:Cast(player)
end)


--actions.breath+=/howling_blast,if=buff.rime.react
HowlingBlast:Callback("breath2", function(spell)
    if not player:HasBuff(buffs.rime) then return end

    return spell:Cast(target)
end)

local function breath()
    Obliterate("breath")
    HowlingBlast("breath")
    HornofWinter("breath")
    Obliterate("breath2")
    SoulReaper("breath")
    HowlingBlast("breath2")
    ArcaneTorrent("breath")
    HowlingBlast("breath3")
end

--######################################## COLDHEART #######################################

--actions.cold_heart=chains_of_ice,if=fight_remains<gcd&(rune<2|!buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>=4|variable.2h_check&buff.cold_heart.stack>8)|buff.killing_machine.up&(!variable.2h_check&buff.cold_heart.stack>8|variable.2h_check&buff.cold_heart.stack>10))
ChainsofIce:Callback("coldHeart", function(spell)
    if gameState.fightRemains < MakGcd() and (player.rune < 2 or not player:buff(buffs.killingMachine and (not gameState.twoHandCheck and player:HasBuffCount(buffs.coldHeart) >= 4 or gameState.twoHandCheck and player:HasBuffCount(buffs.coldHeart) > 8))) or (player:buff(buffs.killingMachine) and (not gameState.twoHandCheck and player:HasBuffCount(buffs.coldHeart) > 8 or gameState.twoHandCheck and player:HasBuffCount(buffs.coldHeart) > 10)) then
        return spell:Cast(target)
    end

end)

--actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&buff.pillar_of_frost.up&buff.cold_heart.stack>=10&(buff.pillar_of_frost.remains<gcd*(1+(talent.frostwyrms_fury&cooldown.frostwyrms_fury.ready))|buff.unholy_strength.up&buff.unholy_strength.remains<gcd)
ChainsofIce:Callback("coldHeart2", function(spell)
    if A.Obliteration:IsTalentLearned() then return end
    if not player:Buff(buffs.pillarOfFrost) then return end
    if player:HasBuffCount(buffs.coldHeart) < 10 then return end
    if player:BuffRemains(buffs.pillarOfFrost) < MakGcd() * (1 + num(A.FrostwyrmsFury:IsTalentLearned() and A.FrostwyrmsFury:GetCooldown() == 0)) or player:BuffRemains(buffs.unholyStrength) < MakGcd() or (player:Buff(buffs.unholyStrength and player:BuffRemains(buffs.unholyStrength < MakGcd()))) then return end

    return spell:Cast(target)
end)

--actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&death_knight.runeforge.fallen_crusader&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains_expected>15&(buff.cold_heart.stack>=10&buff.unholy_strength.up|buff.cold_heart.stack>=13)
--enchant check add
ChainsofIce:Callback("coldHeart3", function(spell)
    if not IsPlayerSpell(A.Obliteration.ID) and not player:Buff(buffs.pillarOfFrost) and A.PillarofFrost:Cooldown() > 15000 and (player:HasBuffCount(buffs.coldHeart) >= 10 and (player:Buff(buffs.unholyStrength) or player:HasBuffCount(buffs.coldHeart) >= 13)) then
        return spell:Cast(target)
    end
end)

--actions.cold_heart+=/chains_of_ice,if=!talent.obliteration&!death_knight.runeforge.fallen_crusader&buff.cold_heart.stack>=10&!buff.pillar_of_frost.up&cooldown.pillar_of_frost.remains_expected>20
ChainsofIce:Callback("coldHeart4", function(spell)
    if not IsPlayerSpell(A.Obliteration.ID) and player:HasBuffCount(buffs.coldHeart) >= 10 and not player:Buff(buffs.pillarOfFrost) and A.PillarofFrost:Cooldown() > 20000 then
        return spell:Cast(target)
    end
end)

--actions.cold_heart+=/chains_of_ice,if=talent.obliteration&!buff.pillar_of_frost.up&(buff.cold_heart.stack>=14&buff.unholy_strength.up|buff.cold_heart.stack>=19|cooldown.pillar_of_frost.remains_expected<3&buff.cold_heart.stack>=14)
ChainsofIce:Callback("coldHeart5", function(spell)
    if IsPlayerSpell(A.Obliteration.ID) and not player:Buff(buffs.pillarOfFrost) and (player:HasBuffCount(buffs.coldHeart) >= 14 and (player:Buff(buffs.unholyStrength) or player:HasBuffCount(buffs.coldHeart) >= 19 or A.PillarofFrost:Cooldown() < 3000) and player:HasBuffCount(buffs.coldHeart) >= 14) then
        return spell:Cast(target)
    end
end)

local function coldHeart()
    ChainsofIce("coldHeart")
    ChainsofIce("coldHeart2")
    ChainsofIce("coldHeart3")
    ChainsofIce("coldHeart4")
    ChainsofIce("coldHeart5")
end

--##################################### OBLITERATION ######################################

-- Use Exterminate charges with Frostscythe in AoE (high priority) - costs only 1 rune and summons scythes
Frostscythe:Callback("obliteration_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    if not IsPlayerSpell(A.Frostscythe.ID) then return end
    if activeEnemies() < 2 then return end

    return spell:Cast(target)
end)

-- Use Exterminate charges with Obliterate in ST (high priority) - costs only 1 rune and summons scythes
Obliterate:Callback("obliteration_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice+((hero_tree.deathbringer&debuff.reapers_mark_debuff.up)*5),if=buff.killing_machine.react&(buff.exterminate.up|fight_remains<gcd*2)
Obliterate:Callback("obliteration", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    if not (player:Buff(buffs.exterminate) or gameState.fightRemains < Action.GetGCD() * 2) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=debuff.razorice.stack=5&talent.shattering_blade&talent.a_feast_of_souls&buff.a_feast_of_souls.up
FrostStrike:Callback("obliteration", function(spell)
    if target:HasDeBuffCount(debuffs.razorice) ~= 5 then return end
    if not A.ShatteringBlade:IsTalentLearned() then return end
    if not A.AFeastofSouls:IsTalentLearned() then return end
    if not player:Buff(buffs.aFeastOfSouls) then return end

    return spell:Cast(target)
end)

-- soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&target.time_to_pct_0>5&active_enemies<=1&rune>2&!buff.killing_machine.react
SoulReaper:Callback("obliteration", function(spell)
    if gameState.fightRemains <= 5000 then return end
    if target.hp > 35 then return end
    if target.hp <= 0 then return end
    if gameState.activeEnemies > 1 then return end
    if player.rune <= 2 then return end
    if player:Buff(buffs.killingMachine) then return end

    return spell:Cast(target)
end)

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react
Obliterate:Callback("obliteration2", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- glacial_advance,target_if=max:(debuff.razorice.stack),if=(variable.ga_priority|debuff.razorice.stack<5)&(!death_knight.runeforge.razorice&(debuff.razorice.stack<5|debuff.razorice.remains<gcd*3)|((variable.rp_buffs|rune<2)&active_enemies>1))
GlacialAdvance:Callback("obliteration", function(spell)
    if not (gameState.gaPriority or target:HasDeBuffCount(debuffs.razorice) < 5) then return end
    if not (target:HasDeBuffCount(debuffs.razorice) < 5 or target:DebuffRemains(debuffs.razorice) < Action.GetGCD() * 3 or ((gameState.RPBuffs or player.rune < 2) and gameState.activeEnemies > 1)) then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=(rune<2|variable.rp_buffs|debuff.razorice.stack=5&talent.shattering_blade)&(!talent.glacial_advance|active_enemies=1|talent.shattered_frost)
FrostStrike:Callback("obliteration2", function(spell)
    if not (player.rune < 2 or gameState.RPBuffs or (target:HasDeBuffCount(debuffs.razorice) == 5 and A.ShatteringBlade:IsTalentLearned())) then return end
    if not (not A.GlacialAdvance:IsTalentLearned() or gameState.activeEnemies == 1 or A.ShatteredFrost:IsTalentLearned()) then return end

    return spell:Cast(target)
end)

-- howling_blast,if=buff.rime.react
HowlingBlast:Callback("obliteration", function(spell)
    if not player:Buff(buffs.rime) then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!talent.glacial_advance|active_enemies=1|talent.shattered_frost
FrostStrike:Callback("obliteration3", function(spell)
    if not (not A.GlacialAdvance:IsTalentLearned() or gameState.activeEnemies == 1 or A.ShatteredFrost:IsTalentLearned()) then return end

    return spell:Cast(target)
end)

-- glacial_advance,target_if=max:(debuff.razorice.stack),if=variable.ga_priority
GlacialAdvance:Callback("obliteration2", function(spell)
    if not gameState.gaPriority then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
FrostStrike:Callback("obliteration4", function(spell)
    return spell:Cast(target)
end)

-- horn_of_winter,if=rune<3
HornofWinter:Callback("obliteration", function(spell)
    if player.rune >= 3 then return end

    return spell:Cast(player)
end)

-- arcane_torrent,if=rune<1&runic_power<30
ArcaneTorrent:Callback("obliteration", function(spell)
    if player.rune >= 1 then return end
    if player.runicPower >= 30 then return end

    return spell:Cast(player)
end)

-- howling_blast,if=!buff.killing_machine.react
HowlingBlast:Callback("obliteration2", function(spell)
    if player:Buff(buffs.killingMachine) then return end

    return spell:Cast(target)
end)

local function obliteration()
    -- Use Exterminate charges first (highest priority)
    Frostscythe("obliteration_exterminate")
    Obliterate("obliteration_exterminate")

    Obliterate("obliteration")
    FrostStrike("obliteration")
    SoulReaper("obliteration")
    Obliterate("obliteration2")
    GlacialAdvance("obliteration")
    FrostStrike("obliteration2")
    HowlingBlast("obliteration")
    FrostStrike("obliteration3")
    GlacialAdvance("obliteration2")
    FrostStrike("obliteration4")
    HornofWinter("obliteration")
    ArcaneTorrent("obliteration")
    HowlingBlast("obliteration2")
end

--##################################### RACIALS ######################################

-- blood_fury,use_off_gcd=1,if=variable.cooldown_check
BloodFury:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(player)
end)

-- berserking,use_off_gcd=1,if=variable.cooldown_check
Berserking:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(player)
end)

-- arcane_pulse,if=variable.cooldown_check
ArcanePulse:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(player)
end)

-- lights_judgment,if=variable.cooldown_check
LightsJudgment:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(target)
end)

-- ancestral_call,use_off_gcd=1,if=variable.cooldown_check
AncestralCall:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(player)
end)

-- fireblood,use_off_gcd=1,if=variable.cooldown_check
Fireblood:Callback("racials", function(spell)
    if not gameState.cooldownCheck then return end

    return spell:Cast(player)
end)

-- bag_of_tricks,if=talent.obliteration&!buff.pillar_of_frost.up&buff.unholy_strength.up
BagOfTricks:Callback("racials", function(spell)
    if not A.Obliteration:IsTalentLearned() then return end
    if player:Buff(buffs.pillarOfFrost) then return end
    if not player:Buff(buffs.unholyStrength) then return end

    return spell:Cast(target)
end)

-- bag_of_tricks,if=!talent.obliteration&buff.pillar_of_frost.up&(buff.unholy_strength.up&buff.unholy_strength.remains<gcd*3|buff.pillar_of_frost.remains<gcd*3)
BagOfTricks:Callback("racials2", function(spell)
    if A.Obliteration:IsTalentLearned() then return end
    if not player:Buff(buffs.pillarOfFrost) then return end
    if not ((player:Buff(buffs.unholyStrength) and player:BuffRemains(buffs.unholyStrength) < Action.GetGCD() * 3) or player:BuffRemains(buffs.pillarOfFrost) < Action.GetGCD() * 3) then return end

    return spell:Cast(target)
end)

local function racials()
    BloodFury("racials")
    Berserking("racials")
    ArcanePulse("racials")
    LightsJudgment("racials")
    AncestralCall("racials")
    Fireblood("racials")
    BagOfTricks("racials")
    BagOfTricks("racials2")
end

--##################################### COOLDOWNS ######################################

-- remorseless_winter,if=variable.rw_buffs&(cooldown.pillar_of_frost.remains>8|cooldown.pillar_of_frost.remains<2|buff.pillar_of_frost.up|!talent.pillar_of_frost|(buff.gathering_storm.stack=10&buff.remorseless_winter.remains<gcd.max))&fight_remains>10
-- Updated to use on CD but hold if Pillar of Frost is about to come off CD (within 8 seconds but more than 2 seconds)
-- REMOVED Arctic Assault restriction when Pillar of Frost is up to allow usage during burst
RemorselessWinter:Callback("cooldowns", function(spell)
    -- Do not manually cast RW if Frozen Dominion is learned (Pillar spawns it automatically)
    if A.FrozenDominion:IsTalentLearned() then return end
    -- SimC: remorseless_winter,if=variable.sending_cds&(active_enemies>1|talent.gathering_storm)|(buff.gathering_storm.stack=10&buff.remorseless_winter.remains<gcd.max)&fight_remains>10
    local gcd = Action.GetGCD()
    local cond_a = gameState.sendingCDs and (activeEnemies() > 1 or A.GatheringStorm:IsTalentLearned())
    local cond_b = A.GatheringStorm:IsTalentLearned() and player:HasBuffCount(buffs.gatheringStorm) == 10 and player:BuffRemains(buffs.remorselesswinter) < gcd
    if not ((cond_a or cond_b) and gameState.fightRemains > 10000) then return end
    return spell:Cast(player)
end)

-- chill_streak,if=variable.sending_cds&(!talent.arctic_assault|!buff.pillar_of_frost.up)
ChillStreak:Callback("cooldowns", function(spell)
    if not gameState.sendingCDs then return end
    if A.ArcticAssault:IsTalentLearned() and player:Buff(buffs.pillarOfFrost) then return end

    return spell:Cast(target)
end)

-- Empower Rune Weapon: use on cooldown (always)
EmpowerRuneWeapon:Callback("cooldowns_always", function(spell)
    if A.EmpowerRuneWeapon:GetCooldown() > 0 then return end
    return spell:Cast(player)
end)



-- empower_rune_weapon,if=talent.obliteration&!talent.breath_of_sindragosa&buff.pillar_of_frost.up|fight_remains<20
EmpowerRuneWeapon:Callback("cooldowns", function(spell)
    if A.EmpowerRuneWeapon:GetCooldown() > 0 then return end
    if not shouldPressERW() then return end
    return spell:Cast(player)
end)

-- empower_rune_weapon (pre-Pillar for BoS prep)
EmpowerRuneWeapon:Callback("cooldowns_pre", function(spell)
    if A.EmpowerRuneWeapon:GetCooldown() > 0 then return end
    if not shouldPressERW() then return end
    return spell:Cast(player)
end)

-- empower_rune_weapon,if=buff.breath_of_sindragosa.up&(runic_power<40|runic_power<variable.erw_breath_rp_trigger&rune<variable.erw_breath_rune_trigger)
EmpowerRuneWeapon:Callback("cooldowns2", function(spell)
    if A.EmpowerRuneWeapon:GetCooldown() > 0 then return end
    if not shouldPressERW() then return end

    return spell:Cast(player)
end)

-- empower_rune_weapon,if=!talent.breath_of_sindragosa&!talent.obliteration&!buff.empower_rune_weapon.up&rune<5&(cooldown.pillar_of_frost.remains_expected<7|buff.pillar_of_frost.up|!talent.pillar_of_frost)
EmpowerRuneWeapon:Callback("cooldowns3", function(spell)
    if A.EmpowerRuneWeapon:GetCooldown() > 0 then return end
    if not shouldPressERW() then return end

    return spell:Cast(player)
end)

-- Use Pillar of Frost as soon as it's ready, unless Breath of Sindragosa is about to come off cooldown
PillarofFrost:Callback("cooldowns_early", function(spell)
    -- Use Pillar on cooldown; only hold if BoS is about to come off cooldown
    if A.BreathofSindragosa and A.BreathofSindragosa:IsTalentLearned() then
        local bosCD = A.BreathofSindragosa:GetCooldown() or 0
        local holdWindow = (Action.GetGCD() or 1000) * 2
        if bosCD > 0 and bosCD <= holdWindow then return end
    end
    if A.PillarofFrost:GetCooldown() > 0 then return end
    return spell:Cast(player)
end)


-- pillar_of_frost,if=talent.obliteration&!talent.breath_of_sindragosa&(!hero_tree.deathbringer|(rune>=2|(rune>=1&cooldown.empower_rune_weapon.ready)))&variable.sending_cds|fight_remains<20
PillarofFrost:Callback("cooldowns", function(spell)
    if A.Obliteration:IsTalentLearned() and not A.BreathofSindragosa:IsTalentLearned() then
        -- Check deathbringer hero tree conditions (simplified for PvE)
        if not (player.rune >= 2 or (player.rune >= 1 and A.EmpowerRuneWeapon:GetCooldown() == 0)) then return end
        if not gameState.sendingCDs then return end
    elseif gameState.fightRemains >= 20000 then
        return
    end

    return spell:Cast(player)
end)

-- pillar_of_frost,if=talent.breath_of_sindragosa&variable.sending_cds&(cooldown.breath_of_sindragosa.remains>10|!variable.use_breath)&buff.unleashed_frenzy.up&(!hero_tree.deathbringer|rune>1)
PillarofFrost:Callback("cooldowns2", function(spell)
    if not A.BreathofSindragosa:IsTalentLearned() then return end
    if not gameState.sendingCDs then return end
    if not gameState.breathCheck then return end
    if (player.rune or 0) < 2 then return end
    return spell:Cast(player)
end)

-- pillar_of_frost,if=!talent.obliteration&!talent.breath_of_sindragosa&variable.sending_cds
PillarofFrost:Callback("cooldowns3", function(spell)
    if A.Obliteration:IsTalentLearned() then return end
    if A.BreathofSindragosa:IsTalentLearned() then return end
    if not gameState.sendingCDs then return end

    return spell:Cast(player)
end)

-- reapers_mark,target_if=first:debuff.reapers_mark_debuff.down,if=buff.pillar_of_frost.up|cooldown.pillar_of_frost.remains>5|fight_remains<20
ReapersMark:Callback("cooldowns", function(spell)
    if target:HasDeBuff(debuffs.reapersMarkDebuff) then return end
    if not (player:Buff(buffs.pillarOfFrost) or A.PillarofFrost:GetCooldown() > 5000 or gameState.fightRemains < 20000) then return end

    return spell:Cast(target)
end)

-- Make BoS start reliably in both ST and AoE when talented
BreathofSindragosa:Callback("cooldowns", function(spell)
    if player:Buff(buffs.breathOfSindragosa) then return end
    if not A.BreathofSindragosa:IsTalentLearned() then return end
    -- Start during Pillar window or near end of fight per APL
    if not (player:Buff(buffs.pillarOfFrost) or gameState.fightRemains < 20000) then return end
    -- Avoid immediate starve: require RP threshold (60 baseline, 40 with Deathbringer)
    local threshold = (A.ReaperofSouls and A.ReaperofSouls:IsTalentLearned()) and 40 or 60
    if (player.runicPower or 0) < threshold then return end
    return spell:Cast(player)
end)

-- frostwyrms_fury,if=hero_tree.rider_of_the_apocalypse&talent.apocalypse_now&(!talent.breath_of_sindragosa&buff.pillar_of_frost.up|buff.breath_of_sindragosa.up)|fight_remains<20
-- Removed variable.sending_cds requirement for Apocalypse Now builds
FrostwyrmsFury:Callback("cooldowns", function(spell)
    if A.RidersChampion:IsTalentLearned() and A.ApocalypseNow:IsTalentLearned() then
        if not gameState.sendingCDs then return end
        -- User preference: only use Frostwyrm's Fury during Pillar of Frost window
        if player:Buff(buffs.pillarOfFrost) then
            -- If BoS is talented, ensure we have enough RP (>=60) when sending FWF with Rider+Apocalypse Now
            if A.BreathofSindragosa:IsTalentLearned() and (player.runicPower or 0) < 60 then return end
            return spell:Cast(target)
        end
    end
    if gameState.fightRemains < 20000 then
        return spell:Cast(target)
    end
end)

-- frostwyrms_fury,if=!talent.apocalypse_now&active_enemies=1&buff.pillar_of_frost.up&(!talent.obliteration|!talent.pillar_of_frost)
-- Simplified conditions to ensure FWF is used during Pillar of Frost window
FrostwyrmsFury:Callback("cooldowns2", function(spell)
    if A.ApocalypseNow:IsTalentLearned() then return end
    if activeEnemies() ~= 1 then return end
    -- Ensure Pillar of Frost is active for FWF usage
    if not player:Buff(buffs.pillarOfFrost) then return end
    -- Simplified Obliteration check
    if A.Obliteration:IsTalentLearned() and A.PillarofFrost:IsTalentLearned() then return end

    return spell:Cast(target)
end)

-- frostwyrms_fury,if=!talent.apocalypse_now&active_enemies>=2&buff.pillar_of_frost.up
-- Simplified to ensure FWF is used during Pillar of Frost window for AoE
FrostwyrmsFury:Callback("cooldowns3", function(spell)
    if A.ApocalypseNow:IsTalentLearned() then return end
    if activeEnemies() < 2 then return end
    -- Require Pillar of Frost to be active for AoE FWF usage
    if not player:Buff(buffs.pillarOfFrost) then return end

    return spell:Cast(target)
end)

-- frostwyrms_fury,if=!talent.apocalypse_now&talent.obliteration&buff.pillar_of_frost.up
-- Simplified to ensure FWF is used during Pillar of Frost window for Obliteration
FrostwyrmsFury:Callback("cooldowns4", function(spell)
    if A.ApocalypseNow:IsTalentLearned() then return end
    if not A.Obliteration:IsTalentLearned() then return end
    -- Require Pillar of Frost to be active for Obliteration FWF usage
    if not player:Buff(buffs.pillarOfFrost) then return end

    return spell:Cast(target)
end)

--actions.cooldowns+=/raise_dead
RaiseDead:Callback("cooldowns", function(spell)
    if pet.exists and pet.hp > 0 then return end
    if player.combatTime <= 0 then return end

    return spell:Cast(player)
end)

--cooldowns->add_action( "soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&target.time_to_pct_0>5&active_enemies<=1&(talent.obliteration&(buff.pillar_of_frost.up&!buff.killing_machine.react&rune>2|!buff.pillar_of_frost.up|buff.killing_machine.react<2&!buff.exterminate.up&!buff.exterminate_painful_death.up&buff.pillar_of_frost.remains<gcd)|talent.breath_of_sindragosa&(buff.breath_of_sindragosa.up&runic_power>50|!buff.breath_of_sindragosa.up)|!talent.breath_of_sindragosa&!talent.obliteration)" );
SoulReaper:Callback("cooldowns", function(spell)
    if gameState.activeEnemies <= 1 and target.hp <= 45 and (IsPlayerSpell(A.Obliteration.ID) or (player:Buff(buffs.pillarOfFrost and not player:Buff(buffs.killingMachine) and (player.rune > 2 or not player:Buff(buffs.pillarOfFrost) or player:HasBuffCount(buffs.killingMachine) < 2) and not player:Buff(buffs.exterminate) and not player:Buff(buffs.painfulDeath) and player:BuffRemains(buffs.pillarOfFrost) < MakGcd()) or IsPlayerSpell(A.BreathofSindragosa.ID) and (player:Buff(buffs.breathOfSindragosa) and player.runicPower > 50 or not player:Buff(buffs.breathOfSindragosa)) or not IsPlayerSpell(A.BreathofSindragosa.ID) and not IsPlayerSpell(A.Obliteration.ID))) then
        return spell:Cast(target)
    end
end)

--cooldowns->add_action( "frostscythe,if=!buff.killing_machine.react&!buff.pillar_of_frost.up" );
Frostscythe:Callback("cooldowns", function(spell)
    if player:Buff(buffs.killingMachine) then return end
    if player:Buff(buffs.pillarOfFrost) then return end

    return spell:Cast(target)
end)

--cooldowns->add_action( "any_dnd,if=!buff.death_and_decay.up&variable.adds_remain&(buff.pillar_of_frost.up&buff.killing_machine.react&(talent.enduring_strength|buff.pillar_of_frost.remains>5)|!buff.pillar_of_frost.up&(cooldown.death_and_decay.charges=2|cooldown.pillar_of_frost.remains>cooldown.death_and_decay.duration|!talent.the_long_winter&cooldown.pillar_of_frost.remains<gcd.max*2)|fight_remains<15)&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)" );
DeathandDecay:Callback("cooldowns", function(spell)
    if DeathandDecay:Used() > 0 and DeathandDecay:Used() < 3000 then return end
    if gameState.activeEnemies == 0 then return end
    if player:Buff(buffs.deathAndDecay) then return end
    if not player:Buff(buffs.deathAndDecay)
    and (gameState.activeEnemies > 1 and A.DeathandDecay:Fraction() == 2)
    or (player:Buff(buffs.pillarOfFrost)
        and player:Buff(buffs.killingMachine)
        and ((IsPlayerSpell(A.EnduringStrength.ID)
        or player:BuffRemains(buffs.pillarOfFrost) > 5000)
        or (not player:Buff(buffs.pillarOfFrost)
            and (A.DeathandDecay:Fraction() == 2
            or A.PillarofFrost:Cooldown() > A.DeathandDecay:Cooldown()
            or (not IsPlayerSpell(A.TheLongWinter.ID)
                and A.PillarofFrost:Cooldown() < MakGcd() * 2)
                and ((gameState.activeEnemies > 5
                or (IsPlayerSpell(A.CleavingStrikes.ID) and gameState.activeEnemies >= 2)))))))
    and gameState.activeEnemies ~= 1 then
         return spell:Cast(player)
 end
end)

-- soul_reaper,if=talent.reaper_of_souls&buff.reaper_of_souls.up&buff.killing_machine.react<2
SoulReaper:Callback("cooldowns", function(spell)
    if not A.ReaperofSouls:IsTalentLearned() then return end
    if not player:Buff(buffs.reaperOfSouls) then return end
    if player:HasBuffCount(buffs.killingMachine) >= 2 then return end

    return spell:Cast(target)
end)

-- frostscythe,if=!buff.killing_machine.react&!buff.pillar_of_frost.up
Frostscythe:Callback("cooldowns", function(spell)
    if player:Buff(buffs.killingMachine) then return end
    if player:Buff(buffs.pillarOfFrost) then return end

    return spell:Cast(target)
end)

-- any_dnd,if=hero_tree.deathbringer&!buff.death_and_decay.up&variable.st_planning&cooldown.reapers_mark.remains<gcd.max*2&talent.unholy_ground&variable.st_dnd
DeathandDecay:Callback("cooldowns_st_deathbringer", function(spell)
    if not A.RidersChampion:IsTalentLearned() then return end -- Using RidersChampion as proxy for deathbringer hero tree
    if player:Buff(buffs.deathAndDecay) then return end
    if not gameState.stPlanning then return end
    if A.ReapersMark:GetCooldown() >= (Action.GetGCD() * 2) then return end
    if not A.UnholyGround:IsTalentLearned() then return end
    if gameState.stDnd ~= 1 then return end

    return spell:Cast(player)
end)

-- any_dnd,if=!buff.death_and_decay.up&(raid_event.adds.remains>5|!raid_event.adds.exists&active_enemies>1)&(buff.pillar_of_frost.up&buff.killing_machine.react&(talent.enduring_strength|buff.pillar_of_frost.remains>5))&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)
DeathandDecay:Callback("cooldowns_aoe1", function(spell)
    if player:Buff(buffs.deathAndDecay) then return end
    if not (activeEnemies() > 1) then return end
    if not (player:Buff(buffs.pillarOfFrost) and player:Buff(buffs.killingMachine) and (A.EnduringStrength:IsTalentLearned() or player:BuffRemains(buffs.pillarOfFrost) > 5000)) then return end
    if not (activeEnemies() > 5 or (A.CleavingStrikes:IsTalentLearned() and activeEnemies() >= 2)) then return end

    return spell:Cast(player)
end)

-- any_dnd,if=!buff.death_and_decay.up&(raid_event.adds.remains>5|!raid_event.adds.exists&active_enemies>1)&(!buff.pillar_of_frost.up&(cooldown.death_and_decay.charges=2&cooldown.pillar_of_frost.remains))&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)
DeathandDecay:Callback("cooldowns_aoe2", function(spell)
    if player:Buff(buffs.deathAndDecay) then return end
    if not (activeEnemies() > 1) then return end
    if player:Buff(buffs.pillarOfFrost) then return end
    if A.PillarofFrost:GetCooldown() == 0 then return end
    if not (activeEnemies() > 5 or (A.CleavingStrikes:IsTalentLearned() and activeEnemies() >= 2)) then return end

    return spell:Cast(player)
end)

-- any_dnd,if=!buff.death_and_decay.up&(raid_event.adds.remains>5|!raid_event.adds.exists&active_enemies>1)&(!buff.pillar_of_frost.up&(cooldown.death_and_decay.charges=1&cooldown.pillar_of_frost.remains>(cooldown.death_and_decay.duration-(cooldown.death_and_decay.duration*(cooldown.death_and_decay.charges_fractional%%1)))))&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)
DeathandDecay:Callback("cooldowns_aoe3", function(spell)
    if player:Buff(buffs.deathAndDecay) then return end
    if not (activeEnemies() > 1) then return end
    if player:Buff(buffs.pillarOfFrost) then return end
    if A.PillarofFrost:GetCooldown() < 10000 then return end -- Simplified condition
    if not (activeEnemies() > 5 or (A.CleavingStrikes:IsTalentLearned() and activeEnemies() >= 2)) then return end

    return spell:Cast(player)
end)

-- any_dnd,if=!buff.death_and_decay.up&(raid_event.adds.remains>5|!raid_event.adds.exists&active_enemies>1)&(!buff.pillar_of_frost.up&(!talent.the_long_winter&cooldown.pillar_of_frost.remains<gcd.max*2)|fight_remains<15)&(active_enemies>5|talent.cleaving_strikes&active_enemies>=2)
DeathandDecay:Callback("cooldowns_aoe4", function(spell)
    if player:Buff(buffs.deathAndDecay) then return end
    if not (activeEnemies() > 1) then return end
    if player:Buff(buffs.pillarOfFrost) then return end

    local condition1 = not A.TheLongWinter:IsTalentLearned() and A.PillarofFrost:GetCooldown() < (Action.GetGCD() * 2)
    local condition2 = gameState.fightRemains < 15000
    if not (condition1 or condition2) then return end

    if not (activeEnemies() > 5 or (A.CleavingStrikes:IsTalentLearned() and activeEnemies() >= 2)) then return end


    return spell:Cast(player)
end)

-- abomination_limb,if=variable.sending_cds
AbominationLimb:Callback("cooldowns", function(spell)
    if not gameState.sendingCDs then return end
    return spell:Cast(player)
end)

local function cooldowns()
    -- Major cooldowns first (highest priority)
    EmpowerRuneWeapon("cooldowns_always")
    PillarofFrost("cooldowns_early")

    BreathofSindragosa("cooldowns")
    EmpowerRuneWeapon("cooldowns")
    EmpowerRuneWeapon("cooldowns2")
    EmpowerRuneWeapon("cooldowns3")

    -- Damage cooldowns (including Abomination Limb)
    AbominationLimb("cooldowns")
    FrostwyrmsFury("cooldowns")
    FrostwyrmsFury("cooldowns2")
    FrostwyrmsFury("cooldowns3")
    FrostwyrmsFury("cooldowns4")
    RemorselessWinter("cooldowns")
    ChillStreak("cooldowns")
    ReapersMark("cooldowns")

    -- Utility and setup abilities
    RaiseDead("cooldowns")

    -- Lower priority abilities
    SoulReaper("cooldowns")
    Frostscythe("cooldowns")
end

--####################################### HIGH PRIORITY ACTIONS ######################################





-- antimagic_shell,if=runic_power.deficit>40&death_knight.first_ams_cast<time&(!talent.breath_of_sindragosa|talent.breath_of_sindragosa&variable.true_breath_cooldown>cooldown.antimagic_shell.duration)
AntiMagicShell:Callback("highPrioActions", function(spell)
    if player.runicPowerDeficit <= 40 then return end
    if not (not A.BreathofSindragosa:IsTalentLearned() or (A.BreathofSindragosa:IsTalentLearned() and gameState.trueBreathCooldown > A.AntiMagicShell:GetCooldown())) then return end
    -- Do not use AMS during burst windows (Pillar or active Breath)
    if player:Buff(buffs.pillarOfFrost) or player:Buff(buffs.breathOfSindragosa) then return end

    return spell:Cast(player)
end)

-- howling_blast,if=!dot.frost_fever.ticking&active_enemies>=2&(!talent.breath_of_sindragosa|!buff.breath_of_sindragosa.up)&(!talent.obliteration|talent.wither_away|talent.obliteration&(!cooldown.pillar_of_frost.ready|buff.pillar_of_frost.up&!buff.killing_machine.react))
HowlingBlast:Callback("highPrioActions", function(spell)
    if target:HasDeBuff(debuffs.frostFever) then return end
    if activeEnemies() < 2 then return end
    if A.BreathofSindragosa:IsTalentLearned() and player:Buff(buffs.breathOfSindragosa) then return end

    if A.Obliteration:IsTalentLearned() and not A.WitherAway:IsTalentLearned() then
        if A.PillarofFrost:GetCooldown() == 0 then return end
        if not (player:Buff(buffs.pillarOfFrost) and not player:Buff(buffs.killingMachine)) then return end
    end

    return spell:Cast(target)
end)

local function highPrioActions()
    AntiMagicShell("highPrioActions")
    HowlingBlast("maintain_ff")
    HowlingBlast("highPrioActions")
end

-- Maintain Frost Fever on current target at all times (single target upkeep)
HowlingBlast:Callback("maintain_ff", function(spell)
    if target:HasDeBuff(debuffs.frostFever) then return end
    return spell:Cast(target)
end)

--####################################### OBLITERATION ACTIVE ROTATION #######################################

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice+((hero_tree.deathbringer&debuff.reapers_mark_debuff.up)*5),if=buff.killing_machine.react&(buff.exterminate.up|fight_remains<gcd*2)
Obliterate:Callback("obliteration", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    if not (player:Buff(buffs.exterminate) or gameState.fightRemains < (Action.GetGCD() * 2)) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=debuff.razorice.stack=5&talent.shattering_blade&talent.a_feast_of_souls&buff.a_feast_of_souls.up
FrostStrike:Callback("obliteration", function(spell)
    if target:HasDeBuffCount(debuffs.razorice) ~= 5 then return end
    if not A.ShatteringBlade:IsTalentLearned() then return end
    if not A.AFeastofSouls:IsTalentLearned() then return end
    if not player:Buff(buffs.aFeastOfSouls) then return end

    return spell:Cast(target)
end)

-- soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&target.time_to_pct_0>5&active_enemies<=1&rune>2&!buff.killing_machine.react
SoulReaper:Callback("obliteration", function(spell)
    if gameState.fightRemains <= 5000 then return end
    if target.hp > 35 then return end
    if target.hp <= 0 then return end
    if activeEnemies() > 1 then return end
    if player.rune <= 2 then return end
    if player:Buff(buffs.killingMachine) then return end

    return spell:Cast(target)
end)

-- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react
Obliterate:Callback("obliteration2", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- glacial_advance,target_if=max:(debuff.razorice.stack),if=(variable.ga_priority|debuff.razorice.stack<5)&(!death_knight.runeforge.razorice&(debuff.razorice.stack<5|debuff.razorice.remains<gcd*3)|((variable.rp_buffs|rune<2)&active_enemies>1))
GlacialAdvance:Callback("obliteration", function(spell)
    if not (gameState.gaPriority or target:HasDeBuffCount(debuffs.razorice) < 5) then return end
    local condition1 = target:HasDeBuffCount(debuffs.razorice) < 5 or target:DebuffRemains(debuffs.razorice) < (Action.GetGCD() * 3)
    local condition2 = (gameState.RPBuffs or player.rune < 2) and activeEnemies() > 1
    if not (condition1 or condition2) then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=(rune<2|variable.rp_buffs|debuff.razorice.stack=5&talent.shattering_blade)&(!talent.glacial_advance|active_enemies=1|talent.shattered_frost)
FrostStrike:Callback("obliteration2", function(spell)
    if not (player.rune < 2 or gameState.RPBuffs or (target:HasDeBuffCount(debuffs.razorice) == 5 and A.ShatteringBlade:IsTalentLearned())) then return end
    if not (not A.GlacialAdvance:IsTalentLearned() or activeEnemies() == 1 or A.ShatteredFrost:IsTalentLearned()) then return end

    return spell:Cast(target)
end)

-- howling_blast,if=buff.rime.react
HowlingBlast:Callback("obliteration", function(spell)
    if not player:Buff(buffs.rime) then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!talent.glacial_advance|active_enemies=1|talent.shattered_frost
FrostStrike:Callback("obliteration3", function(spell)
    if not (not A.GlacialAdvance:IsTalentLearned() or activeEnemies() == 1 or A.ShatteredFrost:IsTalentLearned()) then return end

    return spell:Cast(target)
end)

-- glacial_advance,target_if=max:(debuff.razorice.stack),if=variable.ga_priority
GlacialAdvance:Callback("obliteration2", function(spell)
    if not gameState.gaPriority then return end

    return spell:Cast(target)
end)

-- frost_strike,target_if=max:((talent.shattering_blade&debuff.razorice.stack=5)*5)+(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
FrostStrike:Callback("obliteration4", function(spell)
    return spell:Cast(target)
end)

-- horn_of_winter,if=rune<3
HornofWinter:Callback("obliteration", function(spell)
    if player.rune >= 3 then return end

    return spell:Cast(player)
end)

-- arcane_torrent,if=rune<1&runic_power<30
ArcaneTorrent:Callback("obliteration", function(spell)
    if player.rune >= 1 then return end
    if player.runicPower >= 30 then return end

    return spell:Cast(player)
end)

-- howling_blast,if=!buff.killing_machine.react
HowlingBlast:Callback("obliteration2", function(spell)
    if player:Buff(buffs.killingMachine) then return end

    return spell:Cast(target)
end)

local function obliteration()
    Obliterate("obliteration")
    FrostStrike("obliteration")
    SoulReaper("obliteration")
    Obliterate("obliteration2")
    GlacialAdvance("obliteration")
    FrostStrike("obliteration2")
    HowlingBlast("obliteration")
    FrostStrike("obliteration3")
    GlacialAdvance("obliteration2")
    FrostStrike("obliteration4")
    HornofWinter("obliteration")
    ArcaneTorrent("obliteration")
    HowlingBlast("obliteration2")
end
-- Use Exterminate charges with Frostscythe in cleave (highest priority) - costs only 1 rune and summons scythes
Frostscythe:Callback("singleTarget_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    if not IsPlayerSpell(A.Frostscythe.ID) then return end
    if activeEnemies() < 2 then return end

    return spell:Cast(target)
end)

-- Use Exterminate charges with Obliterate in ST (highest priority) - costs only 1 rune and summons scythes
Obliterate:Callback("singleTarget_exterminate", function(spell)
    if not player:Buff(buffs.exterminate) then return end
    if player.rune < 1 then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available - always prefer Frostscythe
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- frostscythe as KM consumer on 2-target cleave when AoE toggle is on (avoid OB), except during Obliteration window
Frostscythe:Callback("singleTarget", function(spell)
    if not IsPlayerSpell(A.Frostscythe.ID) then return end
    if not A.GetToggle(2, "AoE") then return end
    if activeEnemies() < 2 then return end
    if A.Obliteration:IsTalentLearned() and player:Buff(buffs.pillarOfFrost) then return end
    if not player:Buff(buffs.killingMachine) then return end
    if gameState.poolingRunes then return end
    return spell:Cast(target)
end)


--####################################### SINGLE TARGET #########################################

-- frost_strike,if=talent.a_feast_of_souls&debuff.razorice.stack=5&talent.shattering_blade&buff.a_feast_of_souls.up
FrostStrike:Callback("singleTarget", function(spell)
    if not A.AFeastofSouls:IsTalentLearned() then return end
    if target:HasDeBuffCount(debuffs.razorice) ~= 5 then return end
    if not A.ShatteringBlade:IsTalentLearned() then return end
    if not player:Buff(buffs.aFeastOfSouls) then return end

    return spell:Cast(target)
end)

-- obliterate,if=buff.killing_machine.react=2|(buff.killing_machine.react&rune>=3)
Obliterate:Callback("singleTarget", function(spell)
    local kmStacks = player:HasBuffCount(buffs.killingMachine) or 0
    -- Never cast Obliterate in AoE situations when Frostscythe is available
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end
    if not (kmStacks >= 2 or (kmStacks >= 1 and player.rune >= 3)) then return end
    return spell:Cast(target)
end)

-- horn_of_winter,if=(!talent.breath_of_sindragosa|variable.true_breath_cooldown>cooldown.horn_of_winter.duration-15)&cooldown.pillar_of_frost.remains<variable.oblit_pooling_time
HornofWinter:Callback("singleTarget", function(spell)
    if not (not A.BreathofSindragosa:IsTalentLearned() or gameState.trueBreathCooldown > (A.HornofWinter:GetCooldown() - 15000)) then return end
    if A.PillarofFrost:GetCooldown() >= gameState.oblitPoolingTime then return end

    return spell:Cast(player)
end)

-- frost_strike,if=debuff.razorice.stack=5&talent.shattering_blade
FrostStrike:Callback("singleTarget2", function(spell)
    if target:HasDeBuffCount(debuffs.razorice) ~= 5 then return end
    if not A.ShatteringBlade:IsTalentLearned() then return end

    return spell:Cast(target)
end)

-- soul_reaper,if=fight_remains>5&target.time_to_pct_35<5&target.time_to_pct_0>5&!buff.killing_machine.react
SoulReaper:Callback("singleTarget", function(spell)
    if gameState.fightRemains <= 5000 then return end
    if target.hp > 35 then return end
    if target.hp <= 0 then return end
    if player:Buff(buffs.killingMachine) then return end

    return spell:Cast(target)
end)

-- obliterate,if=buff.killing_machine.react&rune>3
Obliterate:Callback("singleTarget2", function(spell)
    if not player:Buff(buffs.killingMachine) then return end
    if player.rune <= 3 then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- obliterate,if=variable.pooling_runic_power&runic_power.deficit>=20
Obliterate:Callback("singleTarget3", function(spell)
    if not gameState.poolingRP then return end
    if player.runicPowerDeficit < 20 then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- howling_blast,if=buff.rime.react
HowlingBlast:Callback("singleTarget", function(spell)
    if not player:Buff(buffs.rime) then return end

    return spell:Cast(target)
end)

-- frost_strike,if=!variable.pooling_runic_power&runic_power.deficit<=30
FrostStrike:Callback("singleTarget3", function(spell)
    if gameState.poolingRP then return end
    if A.ShatteringBlade:IsTalentLearned() then return end
    if player.runicPowerDeficit > 30 then return end

    return spell:Cast(target)
end)

-- obliterate,if=!variable.pooling_runes
Obliterate:Callback("singleTarget4", function(spell)
    if gameState.poolingRunes then return end
    if A.Obliteration:IsTalentLearned() and player:Buff(buffs.pillarOfFrost) then return end
    -- Never cast Obliterate in AoE situations when Frostscythe is available
    if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 then return end

    return spell:Cast(target)
end)

-- horn_of_winter,if=rune<2&runic_power.deficit>25&(!talent.breath_of_sindragosa|variable.true_breath_cooldown>cooldown.horn_of_winter.duration-15)
HornofWinter:Callback("singleTarget2", function(spell)
    if player.rune >= 2 then return end
    if player.runicPowerDeficit <= 25 then return end
    if not (not A.BreathofSindragosa:IsTalentLearned() or gameState.trueBreathCooldown > (A.HornofWinter:GetCooldown() - 15000)) then return end

    return spell:Cast(player)
end)

-- arcane_torrent,if=!talent.breath_of_sindragosa&runic_power.deficit>20
ArcaneTorrent:Callback("singleTarget", function(spell)
    if A.BreathofSindragosa:IsTalentLearned() then return end
    if player.runicPowerDeficit <= 20 then return end

    return spell:Cast(player)
end)

-- frost_strike,if=!variable.pooling_runic_power
FrostStrike:Callback("singleTarget4", function(spell)
    if gameState.poolingRP then return end

    return spell:Cast(target)
end)

-- abomination_limb,if=variable.sending_cds
AbominationLimb:Callback("singleTarget", function(spell)
    if not gameState.sendingCDs then return end
    return spell:Cast(player)
end)

local function singleTarget()
    -- Use Exterminate charges first (highest priority) - costs only 1 rune and summons scythes
    Frostscythe("singleTarget_exterminate")
    Obliterate("singleTarget_exterminate")

    -- Abomination Limb first for burst damage
    AbominationLimb("singleTarget")

    -- High priority abilities with buffs/procs
    FrostStrike("singleTarget")
    Frostscythe("singleTarget")
    Obliterate("singleTarget")
    FrostStrike("singleTarget2")
    SoulReaper("singleTarget")
    Obliterate("singleTarget2")

    -- Resource pooling and management
    Obliterate("singleTarget3")
    HowlingBlast("singleTarget")
    FrostStrike("singleTarget3")
    Obliterate("singleTarget4")

    -- Resource generation and filler
    HornofWinter("singleTarget")
    HornofWinter("singleTarget2")
    ArcaneTorrent("singleTarget")
    FrostStrike("singleTarget4")

    -- Emergency fallback abilities to prevent downtime
    if player.rune >= 1 and not gameState.poolingRunes then
        -- Never cast Obliterate in AoE situations when Frostscythe is available
        if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 and A.Frostscythe and A.Frostscythe.Cast then
            A.Frostscythe:Cast(target)
        elseif A.Obliterate and A.Obliterate.Cast then
            A.Obliterate:Cast(target)
        end
    end

    if player.runicPower >= 25 and not gameState.poolingRP and A.FrostStrike and A.FrostStrike.Cast then
        A.FrostStrike:Cast(target)
    end

    -- Last resort: resource generation
    if player.rune < 2 and player.runicPowerDeficit > 20 and A.HornofWinter and A.HornofWinter.Cast then
        A.HornofWinter:Cast(player)
    end
end


--##################################### ARENA FALLBACK #####################################


ChainsofIce:Callback("arenaFallback", function(spell)
    if not A.ChainsofIce:IsTalentLearned() then return end
    if Unit("target"):GetRange() < 10 then return end
    --if not target:IsPlayer() then return end
    if target:HasDeBuff(debuffs.chainsOfIce, true) then return end

    return spell:Cast(target)
end)

HowlingBlast:Callback("arenaFallback", function(spell)
    if not player:Buff(buffs.rime) or target:HasDeBuff(debuffs.frostFever, true) then return end
    if Unit("target"):GetRange() < 10 then return end

    return spell:Cast(target)
end)

DeathGrip:Callback("arenaFallback", function(spell)
    if target:HasDeBuff(MakLists.dontGrip) then return end
    if target:HasDeBuff(MakLists.zerkRoot) then return end
    if target.hp > GetToggle(2, "TargetHealthSlider") then return end
    if Unit("target"):GetRange() < 15 then return end
    return spell:Cast(target)
end)

RemorselessWinter:Callback("arenaFallback", function(spell)
    if A.FrozenDominion:IsTalentLearned() then return end
    if Unit("target"):GetRange() < 5 then return end
    if Unit("target"):GetRange() > 9 then return end
    --if not target:IsPlayer() then return end

    return spell:Cast(target)
end)

local function arenaFallback()
    DeathGrip("arenaFallback")
    HowlingBlast("arenaFallback")
    ChainsofIce("arenaFallback")
    RemorselessWinter("arenaFallback")
end

--##################################### ARENA DEFENSIVES #####################################

DeathStrike:Callback("arenaDefensive", function(spell)
    if Unit(player):GetLastTimeDMGX(4) <= GetToggle(2, "DeathStrikeSliderSpecial") then return end

    return spell:Cast(target)
end)

SacrificialPact:Callback("arenaDefensive", function(spell)
    if not pet.exists then return end
    if player.HasBuff(buffs.lichborne) then return end
    if player.hp > GetToggle(2, "SacrificialPactSlider") then return end

    return spell:Cast(player)
end)

DeathPact:Callback("arenaDefensive", function(spell)
    if player.hp > GetToggle(2, "DeathPactSlider") then return end

    return spell:Cast(player)
end)

IceboundFortitude:Callback("arenaDefensive", function(spell)
    if player.hp > GetToggle(2, "IceboundFortitudeSlider") then return end

    return spell:Cast(player)
end)


AntiMagicShell:Callback("arenaDefensiveDebuff", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not A.UnyieldingWill:IsTalentLearned() then return end
    if not player:HasDeBuff(MakLists.AMSDispell) then return end

    return spell:Cast(player)
end)

AntiMagicShellSW:Callback("arenaDefensiveDebuff", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not A.UnyieldingWill:IsTalentLearned() then return end
    if not player:HasDeBuff(MakLists.AMSDispell) then return end

    return spell:Cast(player)
end)

AntiMagicShell:Callback("arenaDefensiveOther", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not AutoAntiMagicZonePvp() or not player:HasDeBuff({122470, 6789, 389794, 385627, 196770}) or player.hp > GetToggle(2, "AntiMagicShellSlider") then return end
    if not player:HasDeBuff(MakLists.AMSDispell) then return end

    return spell:Cast(player)
end)

AntiMagicShellSW:Callback("arenaDefensiveOther", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not AutoAntiMagicZonePvp() or not player:HasDeBuff({122470, 6789, 389794, 385627, 196770}) or player.hp > GetToggle(2, "AntiMagicShellSlider") then return end
    if not player:HasDeBuff(MakLists.AMSDispell) then return end

    return spell:Cast(player)
end)

AntiMagicShell:Callback("arenaDefensiveLitFuse", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not target:HasBuff(450716) then return end

    return spell:Cast(player)
end)

AntiMagicShellSW:Callback("arenaDefensiveLitFuse", function(spell)
    if player:HasBuff(buffs.antiMagicZone) then return end
    if not target:HasBuff(450716) then return end

    return spell:Cast(player)
end)

AntiMagicZone:Callback("arenaDefensive", function(spell)
    if player:HasBuff(buffs.antiMagicShell) then return end
    if not AutoAntiMagicZonePvp() or player.hp > GetToggle(2, "AntiMagicZoneSlider") then return end

    return spell:Cast(player)
end)

Lichborne:Callback("arenaDefensive", function(spell)
    if player.hp > GetToggle(2, "LichborneSlider") then return end

    return spell:Cast(player)
end)

DeathCoilPlayer:Callback("arenaDefensive", function(spell)
    --if player:HasBuff(buffs.deathPact) then return end
    if not player:HasBuff(buffs.lichborne) then return end
    if player.hp > 90 then return end

    return spell:Cast(player)
end)


DeathStrike:Callback("arenaDefensive", function(spell)
    if player:HasBuff(buffs.lichborne) then return end
    if not player:HasBuff(buffs.darkSuccor) then return end
    if player.hp > 85 then return end

    return spell:Cast(target)
end)

DeathStrike:Callback("arenaDefensive2", function(spell)
    if player:HasBuff(buffs.lichborne) then return end
    if player.hp > GetToggle(2, "DeathStrikeSlider") then return end
    if player.hp > 85 then return end

    return spell:Cast(target)
end)

DeathsAdvance:Callback("arenaDefensive", function(spell)
    if player:HasBuff(buffs.wraithWalk) then return end
    if player:HasBuff(buffs.deathsAdvance) then return end
    if not target.canAttack then return end
    if MindFreeze:InRange(target) then return end

    return spell:Cast(player)
end)

local function arenaDefensives()
    DeathStrike("arenaDefensive")
    SacrificialPact("arenaDefensive")
    DeathPact("arenaDefensive")
    IceboundFortitude("arenaDefensive")
    AntiMagicShell("arenaDefensiveDebuff")
    AntiMagicShellSW("arenaDefensiveDebuff")
    AntiMagicShell("arenaDefensiveOther")
    AntiMagicShellSW("arenaDefensiveOther")
    AntiMagicShell("arenaDefensiveLitFuse")
    AntiMagicShellSW("arenaDefensiveLitFuse")
    AntiMagicZone("arenaDefensive")
    Lichborne("arenaDefensive")
    DeathCoilPlayer("arenaDefensive")
    DeathStrike("arenaDefensive")
    DeathStrike("arenaDefensive2")
    DeathsAdvance("arenaDefensive")
end

--[[ Need to redo racials
ArcaneTorrent:Callback(function(spell)
    _, _, raceId = UnitRace("player")
    if raceId ~= 10 then return end

    if enemiesInMelee() < 1 then return end
    if player.runicPower >= 20 then return end
    if player.rune >= 2 then return end

    return spell:Cast(player)
end)

BloodFury:Callback(function(spell)
    if not FesteringStrike:InRange(target) then return end
    if gameState.gargTime > 0 and gameState.gargTime <= 18 then
        return spell:Cast(player)
    end

    if gameState.fightRemains < 18 and target:IsBoss() and IsInRaid() then
        return spell:Cast(player)
    end

    local burstCheck = gameState.armyGhoulTime > 0 and gameState.armyGhoulTime <= 18 or gameState.apocGhoulTime > 0 and gameState.apocGhoulTime <= 18 or activeEnemies() >= 2 and player:Buff(buffs.deathAndDecay)

    if not burstCheck then return end
    if A.SummonGargoyle:IsTalentLearned() and A.SummonGargoyle:Cooldown() <= 60 then return end

    return spell:Cast(player)
end)

Berserking:Callback(function(spell)
    if not FesteringStrike:InRange(target) then return end
    if gameState.gargTime > 0 and gameState.gargTime <= 15 then
        return spell:Cast(player)
    end

    if gameState.fightRemains < 15 and target:IsBoss() and IsInRaid() then
        return spell:Cast(player)
    end

    local burstCheck = gameState.armyGhoulTime > 0 and gameState.armyGhoulTime <= 15 or gameState.apocGhoulTime > 0 and gameState.apocGhoulTime <= 15 or activeEnemies() >= 2 and player:Buff(buffs.deathAndDecay)

    if not burstCheck then return end
    if A.SummonGargoyle:IsTalentLearned() and A.SummonGargoyle:Cooldown() <= 60 then return end

    return spell:Cast(player)
end)

LightsJudgment:Callback(function(spell)
    if not player:Buff(buffs.unholyStrength) then return end
    if A.Festermight:IsTalentLearned() and not player:Buff(buffs.festermight) then return end

    return spell:Cast(player)
end)

AncestralCall:Callback(function(spell)
    if not FesteringStrike:InRange(target) then return end
    if gameState.gargTime > 0 and gameState.gargTime <= 18 then
        return spell:Cast(player)
    end

    if gameState.fightRemains < 18 and target:IsBoss() and IsInRaid() then
        return spell:Cast(player)
    end

    local burstCheck = gameState.armyGhoulTime > 0 and gameState.armyGhoulTime <= 18 or gameState.apocGhoulTime > 0 and gameState.apocGhoulTime <= 18 or activeEnemies() >= 2 and player:Buff(buffs.deathAndDecay)

    if not burstCheck then return end
    if A.SummonGargoyle:IsTalentLearned() and A.SummonGargoyle:Cooldown() <= 60 then return end

    return spell:Cast(player)
end)

ArcanePulse:Callback(function(spell)
    if activeEnemies() >= 2 or (player.rune <= 1 and player.runicPowerDeficit >= 60) then
        return spell:Cast(player)
    end
end)

Fireblood:Callback(function(spell)
    if not FesteringStrike:InRange(target) then return end
    if gameState.gargTime > 0 and gameState.gargTime <= 11 then
        return spell:Cast(player)
    end

    if gameState.fightRemains < 11 and target:IsBoss() and IsInRaid() then
        return spell:Cast(player)
    end

    local burstCheck = gameState.armyGhoulTime > 0 and gameState.armyGhoulTime <= 11 or gameState.apocGhoulTime > 0 and gameState.apocGhoulTime <= 11 or activeEnemies() >= 2 and player:Buff(buffs.deathAndDecay)

    if not burstCheck then return end
    if A.SummonGargoyle:IsTalentLearned() and A.SummonGargoyle:Cooldown() <= 60 then return end

    return spell:Cast(player)
end)

BagOfTricks:Callback(function(spell)
    if activeEnemies() > 1 then return end
    if not player:Buff(buffs.unholyStrength) then return end

    return spell:Cast(player)
end)

local function racials()
    ArcaneTorrent()
    BloodFury()
    Berserking()
    LightsJudgment()
    AncestralCall()
    ArcanePulse()
    Fireblood()
    BagOfTricks()
end]]

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    -- Quick combat res on focus or mouseover if available
    if RaiseAlly and RaiseAlly:InRange(player) then
        if focus and focus.exists and not focus.canAttack and focus.hp == 0 then
            if A.RaiseAlly:Cast(focus) then return FrameworkEnd() end
        end
        if mouseover and mouseover.exists and not mouseover.canAttack and mouseover.hp == 0 then
            if A.RaiseAlly:Cast(mouseover) then return FrameworkEnd() end
        end
    end

    end

	FrameworkStart(icon)

    -- Safety check for player object
    -- Water Walking: cast Path of Frost out of combat while swimming
    if player.combatTime <= 0 and _G.IsSwimming and IsSwimming() and not player:Buff(buffs.pathOfFrost) then
        if A.PathofFrost:Cast(player) then return FrameworkEnd() end
    end

    if not player or not player.exists then
        return FrameworkEnd()
    end

    updateGameState()

    Lichborne()
    WraithWalk()
    DeathsAdvance()
    IceboundFortitude()
    AntiMagicShell()
    DeathPact()

    makInterrupt(interrupts)

    if Action.Zone == "arena" then
        arenaDefensives()
    end

    if target and target.exists and target.canAttack and FrostStrike:InRange(target) then
        DeathStrike()

        -- Use trinkets before cooldowns (including Pillar of Frost) when Burst toggle is ON
        if shouldBurst() then
            -- Use trinkets before Pillar of Frost for proper timing
            if Trinket then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
            cooldowns()
            racials()
        end
        highPrioActions()

            --[[ NEED TO UPDATE POTION LOGIC
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion, A.PotionofUnwaveringFocus)



            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local summonGargoyle = not A.SummonGargoyle:IsTalentLearned() or A.SummonGargoyle:Cooldown() > 60000
                local shouldPot = pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < 30 or gameState.armyGhoulTime > 0 and gameState.armyGhoulTime <= 30 or gameState.apocGhoulTime > 0 and gameState.apocGhoulTime <= 30
                if summonGargoyle and shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end]]

        --actions+=/call_action_list,name=cold_heart,if=talent.cold_heart&(!buff.killing_machine.up|talent.breath_of_sindragosa)&((debuff.razorice.stack=5|!death_knight.runeforge.razorice&!talent.glacial_advance&!talent.avalanche&!talent.arctic_assault)|fight_remains<=gcd)
        if A.ColdHeart:IsTalentLearned() and (not player:Buff(buffs.killingMachine) or A.BreathofSindragosa:IsTalentLearned()) and ((target:HasDeBuffCount(debuffs.razorice, true) == 5 or not A.GlacialAdvance:IsTalentLearned() and not A.Avalanche:IsTalentLearned() and not A.ArcticAssault:IsTalentLearned()) or gameState.fightRemains <= Action.GetGCD()) then
            coldHeart()
        end

        -- actions+=/run_action_list,name=breath,if=buff.breath_of_sindragosa.up
        if player:Buff(buffs.breathOfSindragosa) then
            if A.RidersChampion:IsTalentLearned() then
                riderBreath()
            elseif A.ReaperofSouls:IsTalentLearned() then
                dbBreathPriority()
            else
                breath()
            end
        end

        --actions+=/run_action_list,name=obliteration,if=talent.obliteration&buff.pillar_of_frost.up&!buff.breath_of_sindragosa.up
        if A.Obliteration:IsTalentLearned() and player:Buff(buffs.pillarOfFrost) and not player:Buff(buffs.breathOfSindragosa) then
            obliteration()
        end

        -- Enhanced filler logic to prevent downtime

        -- Always try to fill downtime, not just near CD windows
        local needsFiller = true

        -- Check if we have immediate abilities available
        local hasKM = player:Buff(buffs.killingMachine)
        local hasRime = player:Buff(buffs.rime)
        local canSpendRP = player.runicPower >= 25 and not gameState.poolingRP
        local canSpendRunes = player.rune >= 1 and not gameState.poolingRunes

        -- If we have immediate high-priority abilities, don't use fillers
        if hasKM and canSpendRunes then needsFiller = false end
        if hasRime then needsFiller = false end
        if canSpendRP and player.runicPowerDeficit <= 30 then needsFiller = false end

        if needsFiller then
            -- Priority filler abilities to prevent downtime
            if IsPlayerSpell(A.Frostscythe.ID) and activeEnemies() >= 2 and canSpendRunes and A.Frostscythe and A.Frostscythe.Cast then
                if A.Frostscythe:Cast(target) then return FrameworkEnd() end
            elseif A.GlacialAdvance and A.GlacialAdvance.IsReady and A.GlacialAdvance:IsReady() and player.runicPower >= 30 and not gameState.poolingRP and A.GlacialAdvance.Cast then
                if A.GlacialAdvance:Cast(target) then return FrameworkEnd() end
            elseif A.HowlingBlast and A.HowlingBlast.IsReady and A.HowlingBlast:IsReady() and (hasRime or not target:HasDeBuff(debuffs.frostFever)) and A.HowlingBlast.Cast then
                if A.HowlingBlast:Cast(target) then return FrameworkEnd() end
            elseif A.HornofWinter and A.HornofWinter.IsReady and A.HornofWinter:IsReady() and player.rune < 3 and player.runicPowerDeficit > 20 and A.HornofWinter.Cast then
                if A.HornofWinter:Cast(player) then return FrameworkEnd() end
            elseif A.FrostStrike and A.FrostStrike.IsReady and A.FrostStrike:IsReady() and player.runicPower >= 25 and not gameState.poolingRP and A.FrostStrike.Cast then
                if A.FrostStrike:Cast(target) then return FrameworkEnd() end
            end
        end

        local useAoE = activeEnemies() >= 3 and A.GetToggle(2, "AoE") and not A.IsInPvP
        if IsPlayerSpell(A.Frostbane.ID) then
            if useAoE then
                frostbaneAOE()
            else
                frostbaneST()
            end
        else
            if useAoE then
                aoe()
            else
                singleTarget()
            end
        end
    end

    if target.exists and target.canAttack and DeathGrip:InRange(target) then
        arenaFallback()
    end

    if A.GetToggle(2, "makDebug") then

        --Let's print our new set of gamestates
        MakPrint(1, "ST Planning", gameState.stPlanning)
        MakPrint(2, "RP Deficit", player.runicPowerDeficit)
        MakPrint(3, "Spend CDs", gameState.sendingCDs)
        MakPrint(4, "Rime Buffs", gameState.rimeBuffs)
        MakPrint(5, "RP Buffs", gameState.RPBuffs)
        MakPrint(6, "Cooldown Check", gameState.cooldownCheck)
        MakPrint(7, "True Breath Cooldown", gameState.trueBreathCooldown)
        MakPrint(8, "Oblit Pooling Time", gameState.oblitPoolingTime)
        MakPrint(9, "Breath Pooling Time", gameState.breathPoolingTime)
        MakPrint(10, "Pooling Runes", gameState.poolingRunes)
        MakPrint(11, "Pooling RP", gameState.poolingRP)
        MakPrint(12, "GA Priority", gameState.gaPriority)
        MakPrint(13, "Breath Dying", gameState.breathDying)
        MakPrint(14, "True Breath Cooldown", gameState.trueBreathCooldown)

    end

	return FrameworkEnd()
end

Asphyxiate:Callback("arena45", function(spell, enemy)
    if not GetToggle(2, "AsphyxiateDropdown") == "4" then return end
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end
    if ccRemains > 1500 then return end
    if not enemy:IsTarget() then return end
    if enemy.hp >= 45 then return end
    if enemy.stunDR < 0.5 then return end
    return spell:Cast(enemy)
end)

Strangulate:Callback("arenastun", function(spell, enemy)
    if not GetToggle(2, "StrangulateDropdown") == "4" then return end
    if not enemy:IsTarget() then return end
    if enemy.hp >= 35 then return end
    if enemy.silenceDr < 0.5 then return end
    return spell:Cast(enemy)
end)

Asphyxiate:Callback("arenacc", function(spell, enemy)
    if not GetToggle(2, "AsphyxiateDropdown") == "1" or GetToggle(2, "AsphyxiateDropdown") == "3" then return end
    if not arena1.hp <= 45 or arena2.hp <= 45 or arena3.hp <= 45 then return end
    if not enemy.isHealer then return end
    if enemy.stunDr < 0.50 then return end
    return spell:Cast(enemy)
end)

Strangulate:Callback("arenacc", function(spell, enemy)
    if not GetToggle(2, "StrangulateDropdown") == "1" or GetToggle(2, "StrangulateDropdown") == "3" then return end
    if not arena1.hp <= 35 or arena2.hp <= 35 or arena3.hp <= 35 then return end
    if not enemy.isHealer then return end
    if enemy.silenceDr < 0.50 then return end
    return spell:Cast(enemy)
end)

MindFreeze:Callback("arenakick", function(spell, enemy)
    if not enemy.pvpKick then return end
    return spell:Cast(enemy)
end)

Strangulate:Callback("arenakick", function(spell, enemy)
    if not GetToggle(2, "AsphyxiateDropdown") == "1" or GetToggle(2, "AsphyxiateDropdown") == "2" then return end
    if not enemy.pvpKick then return end
    if enemy.silenceDr < 0.50 then return end

    return spell:Cast(enemy)
end)

DeathGrip:Callback("arenakick", function(spell, enemy)
    if not GetToggle(2, "DeathGripDropdown") == "1" or GetToggle(2, "DeathGripDropdown") == "2" then return end
    if enemy:HasDeBuff(MakLists.dontGrip) then return end
    if enemy:HasDeBuff(MakLists.zerkRoot) then return end
    if not enemy.pvpKick then return end
    return spell:Cast(enemy)
end)

local function enemyRotation(enemy)
    if Action.Zone ~= "arena" then return end
	if Player:IsMounted() or Player:IsStealthed() then return false end

    -- Target Stuns
    Asphyxiate("arenastun", enemy)
    Strangulate("arenastun", enemy)

    -- CC
    Asphyxiate("arenacc", enemy)
    Strangulate("arenacc", enemy)

    -- Kicks
    MindFreeze("arenakick", enemy)
    Strangulate("arenakick", enemy)
end

local partyRotation = function(friendly)
    if Action.Zone ~= "arena" then return end
    if not friendly.exists then return end

end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
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
	partyRotation(player)

	return FrameworkEnd()
end