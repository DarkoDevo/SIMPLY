---Test
if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 254 then return end

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
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local TrinketAnalyzer  = MakuluFramework.TrinketAnalyzer

local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware

local constCell        = cacheContext:getConstCacheCell()

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local ActionPet        = LibStub("PetLibrary")
local MultiUnits       = Action.MultiUnits

local GetSpellTexture  = C_Spell.GetSpellTexture
local _G, setmetatable = _G, setmetatable


local ActionID = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { ignoreCasting = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { ignoreCasting = true } },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { ignoreCasting = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { ignoreCasting = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { ignoreCasting = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { ignoreCasting = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { ignoreCasting = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { ignoreCasting = true } },
    WarStomp = { ID = 20549, MAKULU_INFO = { ignoreCasting = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { ignoreCasting = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { ignoreCasting = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { ignoreCasting = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { ignoreCasting = true } },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { ignoreCasting = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { ignoreCasting = true } },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { ignoreCasting = true } },
    Fireblood = { ID = 265221, MAKULU_INFO = { ignoreCasting = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { ignoreCasting = true } },
    BullRush = { ID = 255654, MAKULU_INFO = { ignoreCasting = true } },
    AncestralCall = { ID = 274738, MAKULU_INFO = { ignoreCasting = true } },
    Haymaker = { ID = 287712, MAKULU_INFO = { ignoreCasting = true } },
    Regeneratin = { ID = 291944, MAKULU_INFO = { ignoreCasting = true } },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { ignoreCasting = true } },
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { ignoreCasting = true } },

    SteadyShot = { ID = 56641, MAKULU_INFO = { damageType = "physical", ignoreMoving = true, ignoreCasting = true } },
    ArcaneShot = { ID = 185358, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ChimaeraShot = { ID = 342049, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    WingClip = { ID = 195645, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    ConcussiveShot = { ID = 5116, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    Disengage = { ID = 781 },
    AspectOfTheCheetah = { ID = 186257, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    CallPet = { ID = 883, Texture = 227334 },
    MendPet = { ID = 136 },
    PrimalRage = { Type = "SpellSingleColor", ID = 272678, Color = "PINK" },
    MastersCall = { Type = "SpellSingleColor", ID = 272682, Color = "PINK" },
    FeignDeath = { ID = 5384, MAKULU_INFO = { ignoreCasting = true } },
    HuntersMark = { ID = 257284, MAKULU_INFO = { ignoreCasting = true } },
    AspectOfTheTurtle = { ID = 186265, MAKULU_INFO = { ignoreCasting = true } },
    Exhilaration = { ID = 109304, MAKULU_INFO = { ignoreCasting = true } },
    KillShot = { ID = 53351, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    CounterShot = { ID = 147362, MAKULU_INFO = { damageType = "physical", offGcd = true, ignoreCasting = true } },
    TarTrap = { ID = 187698, MAKULU_INFO = { ignoreCasting = true } },
    Misdirection = { ID = 34477, MAKULU_INFO = { ignoreCasting = true } },
    SurvivalOfTheFittest = { ID = 264735, MAKULU_INFO = { ignoreCasting = true } },
    TranquilizingShot = { ID = 19801, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    ScareBeast = { ID = 1513, MAKULU_INFO = { ignoreCasting = true } },
    Intimidation = { ID = 474421, FixedTexture = 132111, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    HighExplosiveTrap = { ID = 236776, FixedTexture = 135826, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ImplosiveTrap = { ID = 462031, FixedTexture = 135826, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ScatterShot = { ID = 213691, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    BindingShot = { ID = 109248, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Camouflage = { ID = 199483, MAKULU_INFO = { ignoreCasting = true } },
    ExplosiveShot = { ID = 212431, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Barrage = { ID = 120360, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    AimedShot = { ID = 19434, Texture = 191043, MAKULU_INFO = { damageType = "physical", ignoreMoving = true, ignoreCasting = true, ignoreResource = true } },
    RapidFire = { ID = 257044, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, ignoreMoving = true } },
    BurstingShot = { ID = 186387, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    Volley = { ID = 260243, MAKULU_INFO = { damageType = "physical", ignoreCasting = true }, Macro = "/cast Single-Button Assistant" },
    Trueshot = { ID = 288613, MAKULU_INFO = { ignoreCasting = true } },
    RoarOfSacrifice = { ID = 53480, MAKULU_INFO = { ignoreCasting = true } },
    WailingArrow = { ID = 392060, Texture = 191043, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MultiShot = { ID = 257620, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    FreezingTrap = { ID = 187650, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    ChimaeralSting = { ID = 356719, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SniperShot = { ID = 203155, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },
    WildKingdom = { ID = 356707, MAKULU_INFO = { damageType = "physical", ignoreCasting = true } },

    LoneWolf = { ID = 155228, Hidden = true },
    SteadyFocus = { ID = 193533, Hidden = true },
    SurgingShots = { ID = 391559, Hidden = true },
    GhillieSuit = { ID = 459466, Hidden = true },
    RapidFireBarrage = { ID = 459800, Hidden = true },
    TrickShots = { ID = 257621, Hidden = true },
    SymphonicArsenal = { ID = 450383, Hidden = true },
    SmallGameHunter = { ID = 459802, Hidden = true },
    PrecisionDetonation = { ID = 471369, Hidden = true },
    Headshot = { ID = 471363, Hidden = true },
    DoubleTap = { ID = 473370, Hidden = true },
    Bulletstorm = { ID = 389019, Hidden = true },
    AspectOfTheFox = { ID = 1219162, Hidden = true },
    AspectOfTheHydra = { ID = 470945, Hidden = true },
    WindrunnerQuiver = { ID = 473523, Hidden = true },
    EmergencySalve = { ID = 459517, Hidden = true },

    BlackArrow = { ID = 430703, MAKULU_INFO = { damageType = "magic" } },
    BlackArrow2 = { ID = 466930, MAKULU_INFO = { damageType = "magic" } },

    LunarStorm = { ID = 450385, Hidden = true },
    NoScope = { ID = 473385, Hidden = true },
    BlackArrowTalent = { ID = 466932, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    ArenaPreparation = { ID = 32727, Hidden = true },

    Universal10 = { ID = 264735, FixedTexture = 133632, Hidden = true }, --These two are to fix SOTF pixel issues that some people have
    Mounted = { ID = 264735, FixedTexture = 132261, Hidden = true },     --These two are to fix SOTF pixel issues that some people have
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

Action[ACTION_CONST_HUNTER_MARKSMANSHIP] = A

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
    imCasting = nil,
    cursorCheck = false,
    preciseShots = false,
    lunarStormCd = 0,
}

local buffs = {
    steadyFocus = 193534,
    trueshot = 288613,
    trickShots = 257622,
    razorFragments = 388998,
    preciseShots = 260242,
    bulletstorm = 389020,
    survivalOfTheFittest = 264735,
    enduranceTraining = 264662,
    predatorsThirst = 264663,
    pathfinding = 264656,
    doubleTap = 260402,
    witherFire = 466991,
    movingTarget = 474293,
    lockAndLoad = 194594,
    aspectOfTheCheetahOne = 186257,
    aspectOfTheCheetahTwo = 186258,
    camouflage = 199483,
    feignDeath = 5384,
    shadowmeld = 58984,
}

local debuffs = {
    serpentSting = 271788,
    huntersMark = 257284,
    spottersMark = 466872,
    lunarStormCd = 451803,
    concussiveShot = 5116,
}

local tranqPurgeableBuffs = {
  1044,  -- Blessing of Freedom
  1022,  -- Blessing of Protection
  6940,  -- Blessing of Sacrifice
  10060, -- Power Infusion
  47788, -- Guardian Spirit
  974,   -- Earth Shield
  79206, -- Spiritwalker's Grace
  192106,-- Lightning Shield
  29166, -- Innervate
  33763, -- Lifebloom
  8936,  -- Regrowth
  774,   -- Rejuvenation
  48438, -- Wild Growth
  11426, -- Ice Barrier
  235313,-- Blazing Barrier
  358267,-- Hover
  366155,-- Reversion
  364343,-- Echo
  124682,-- Enveloping Mist
  119611,-- Renewing Mist
  184362,-- Enrage
}


local function num(val)
    if val then return 1 else return 0 end
end

local interrupts = {
    { spell = CounterShot },
    { spell = ScatterShot,  isCC = true },
    { spell = Intimidation, isCC = true },
    --{ spell = BurstingShot, isCC = true, aoe = true, distance = 3 },
}

local multiShotLastCast = 0
local waitingForHit = false
local multiShotLastHit = 0

local function on_unit_spellcast_success(event, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool =
        CombatLogGetCurrentEventInfo()
    if sourceGUID ~= player.guid then return end

    if subevent == "SPELL_CAST_SUCCESS" then
        if spellID ~= MultiShot.id then return end

        multiShotLastCast = GetTime()
        multiShotLastHit = 0
        waitingForHit = true
        return
    end

    if subevent == "SPELL_DAMAGE" or subevent == "SPELL_MISSED" or subevent == "SPELL_ABSORBED" then
        if spellID ~= MultiShot.id then return end
        waitingForHit = false
        multiShotLastHit = multiShotLastHit + 1
    end
end
MakuluFramework.Events.register("COMBAT_LOG_EVENT_UNFILTERED", on_unit_spellcast_success)

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if SteadyShot:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if debuff and enemy:DebuffRemains(debuff, true) > dur then
                        count = count + 1
                    elseif not debuff then
                        count = count + 1
                    end
                end
            end
        end

        return count
    end)
end

local function activeEnemies()
    return math.max(enemiesInRange(), 1)
end

local cacheContext = MakuluFramework.Cache

local constCell    = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do                                    -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 8 and not enemy:IsTotem() and not enemy.isPet then -- I haven't tested the new totem yet
                total = total + 1
            end
        end

        return total
    end)
end

local function enemiesInMeleeBurstingPvP()
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local total = 0

    if A.Zone ~= "Arena" and A.Zone ~= "pvp" then return end

    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if ActionUnit(enemyGUID):GetRange() <= 5 and not ActionUnit(enemyGUID):IsTotem() and not enemy.isPet and enemy.cds then
            total = total + 1
        end
    end

    return total
end

local function enemyBurstCount()
    local burstCount = 0

    if arena1.exists and arena1.cds then burstCount = burstCount + 1 end
    if arena2.exists and arena2.cds then burstCount = burstCount + 1 end
    if arena3.exists and arena3.cds then burstCount = burstCount + 1 end

    return burstCount
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive()
end

local startTime = nil
local countdownDuration = 15000

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name

    return currentCast, currentCastName
end

-- Utility: approximate projectile in-flight check (ms window based on travel time)
local function isSpellInFlight(spell, speed)
    local casting = gameState.imCasting and gameState.imCasting == spell.id
    local travelTime = (target.distance / (speed or 45)) * 1000

    if casting then
        return true
    end

    if spell.used > 10000 or spell.used < 0 then
        return false
    end

    return spell.used < travelTime
end


--delay vars
local lastUpdateTime = 0
local updateDelay = 0.5

-- We clear 1/8 of the Rapid Fire cooldown when we use Trueshot per second
local trueShotRapidFireReduction = (1 / 8) / 1000

local function getOffensiveSlotCd(id)
    if TrinketAnalyzer:IsActionBlocked(id) then return nil end

    local isOnUse, isOffensive = TrinketAnalyzer:AnalyzeTrinketBySlot(id)
    if not isOnUse or not isOffensive then
        return false
    end

    return TrinketAnalyzer:GetCooldown(id)
end

local function holdCdsForTrinket()
    local maxWaitCd = 0
    for id = 13, 14 do
        maxWaitCd = math.max(maxWaitCd, getOffensiveSlotCd(id) or 0)
    end

    return maxWaitCd > 0 and maxWaitCd < 10000
end

local function calculateRapidFireCd()
    if not player:Buff(buffs.trueshot) then
        return 20000
    end

    local trueshotDuration = player:BuffRemains(buffs.trueshot, true)
    if trueshotDuration >= 8000 then
        return 8000
    end

    if trueshotDuration >= 8000 then
        return 8000
    end

    return (20000 * (1 - (trueshotDuration * trueShotRapidFireReduction))) + trueshotDuration
end

local function shouldBurst()
    if not A.IsInPvP and holdCdsForTrinket() then
        local awareAlert = A.GetToggle(2, "makAware")
        if awareAlert[2] then
            Aware:displayMessage("Holding Cds for Trinket", "Hunter", 1, GetSpellTexture(Trueshot.id))
        end

        return false
    end

    return A.BurstIsON("target")
end

local function updateGameState()
    local currentTime = GetTime()
    local currentCast, currentCastName = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    local cursorCondition = (KillShot:InRange(mouseover) or Misdirection:InRange(mouseover)) and
    (mouseover.canAttack or mouseover:IsMelee() or mouseover:IsPet())
    gameState.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gameState.activeEnemies = activeEnemies()

    gameState.preciseShots = (gameState.imCasting and gameState.imCasting == AimedShot.id) or
    player:Buff(buffs.preciseShots)


    -- UpdateLunarStormCd(deltaTime)

    gameState.lunarStormCd = player:DebuffRemains(debuffs.lunarStormCd, true)
    -- Treat Trick Shots as 3+ targets to avoid 2-target Multi-Shot/Steady Shot loops
    gameState.shouldAoE = gameState.activeEnemies >= 3 and player:TalentKnown(TrickShots.id) and A.Zone ~= "arena"
    --[[if gameState.shouldAoE then
        local lastMultiShot = GetTime() - multiShotLastCast
        if multiShotLastHit < 3 and not waitingForHit and lastMultiShot < 15 then
            Aware:displayMessage("Multishot didnt hit enough targets, disabling AoE", "Hunter", 1, GetSpellTexture(TrickShots.id))
            gameState.shouldAoE = false
        end
    end]]

    gameState.hasCheetah = player:Buff(buffs.aspectOfTheCheetahOne) or player:Buff(buffs.aspectOfTheCheetahTwo)

    gameState.castingSteady = gameState.imCasting and gameState.imCasting == SteadyShot.id
    gameState.aimedShotReady = player.focus + (num(gameState.castingSteady) * 20) > AimedShot:Cost()
    gameState.rapidFireCdExpected = calculateRapidFireCd()
end

local function steadyShotCount()
    local steadyShotCount = 0
    if player:TalentKnown(SteadyFocus.id) then
        if player:Buff(buffs.steadyFocus) then
            steadyShotCount = 0
        elseif gameState.imCasting == SteadyShot.id then
            steadyShotCount = steadyShotCount + 1
        end
    end
    return steadyShotCount == 1
end

Misdirection:Callback(function(spell)
    local playerstatus = UnitThreatSituation("player")
    if GetNumGroupMembers() > 1 and (player.combatTime < 5 or ActionUnit("player"):IsTanking() or playerstatus == 3) and not A.IsInPvP then
        if focus.exists and focus.isFriendly and focus.isTank then
            return spell:Cast()
        end
    end
end)

HuntersMark:Callback(function(spell)
    if not HuntersMark:InRange(target) then return end
    if player.feigned then return end
    if target:Debuff(debuffs.huntersMark) then return end
    if not target.exists then return end
    if not target.canAttack then return end

    if player.inCombat and target.hp > 90 and ActionUnit("target"):TimeToDieX(80) > A.GetGCD() * 5 then
        if target.isBoss or not SteadyShot:InRange(target) then
            return spell:Cast(target)
        end
    elseif not player.inCombat then
        return spell:Cast(target)
    end
end)

SurvivalOfTheFittest:Callback(function(spell, icon)
    icon = SurvivalOfTheFittest
    if A.GetToggle(2, "sotfPixel") then
        icon = Universal10
    end

    if not player:TalentKnown(SurvivalOfTheFittest.id) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end

    if not player.inCombat then return end
    if player:Buff(buffs.survivalOfTheFittest) then return end

    -- Check if player is being focused by enemy with burst CDs up
    local isFocusedWithBurst = ActionUnit("player"):IsFocused(nil, true)

    if isFocusedWithBurst or player.hp < A.GetToggle(2, "survivalOfTheFittestHP") then
        return spell:Cast(nil, nil, icon)
    end
end)

Camouflage:Callback(function(spell)
    if not player:TalentKnown(Camouflage.id) then return end
    if not player:TalentKnown(GhillieSuit.id) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "camouflageHP") then
        return spell:Cast()
    end
end)

AspectOfTheTurtle:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end

    if not player.inCombat then return end

    if player.hp > A.GetToggle(2, "aspectOfTheTurtleHP") then return end

    return spell:Cast()
end)

Exhilaration:Callback(function(spell)
    if not player.inCombat then return end

    if player.hp > A.GetToggle(2, "exhilarationHP") then return end

    return spell:Cast()
end)

FeignDeath:Callback(function(spell)
    -- Emergency low HP check (works in all content)
    local feignDeathHP = A.GetToggle(2, "feignDeathHP")
    if feignDeathHP and feignDeathHP > 0 and player.hp <= feignDeathHP then
        return spell:Cast()
    end

    if A.IsInPvP then return end

    if A.GetToggle(2, "selfCleanse") then
        if player:TalentKnown(EmergencySalve.id) then
            if player.diseased or player.poisoned then
                return spell:Cast()
            end
        end
    end

    if A.GetToggle(2, "feignMechs") then
        if makFeign() then
            return spell:Cast()
        end
    end
end)

AimedShot:Callback("pre", function(spell)
    if A.IsInPvP then return end
    if not gameState.aimedShotReady then return end

    local canMove = player:Buff(buffs.lockAndLoad) or (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
    if player.moving and not canMove then return end
    if player.inCombat then return end
    if gameState.imCasting then return end
    if activeEnemies() >= (3 - player:TalentKnownInt(Volley.id)) and gameState.shouldAoE then return end

    return spell:Cast()
end)

SteadyShot:Callback("pre", function(spell)
    if A.IsInPvP then return end

    if gameState.imCasting then return end
    if player.inCombat then return end
    -- Pre-SteadyShot only if fewer than 3 targets (Trick Shots needs 3+)
    if activeEnemies() >= 3 and not A.Volley:IsTalentLearned() then return end

    return spell:Cast()
end)

Volley:Callback("pre-pvp", function(spell)
    if not A.IsInPvP then return end -- PvP opener apparently
    if not gameState.cursorCheck then return end

    if gameState.imCasting then return end
    if player.inCombat then return end

    return spell:Cast()
end)

RapidFire:Callback("pre-pvp", function(spell)
    if not A.IsInPvP then return end -- PvP opener apparently

    if gameState.imCasting then return end

    if player.combatTime > 4000 then return end

    return spell:Cast(target)
end)

Berserking:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if not player:Buff(buffs.trueshot) then return end

    return spell:Cast()
end)

BloodFury:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if A.Trueshot:IsTalentLearned() and (not player:Buff(buffs.trueshot) or Trueshot:Cooldown() < 30000) then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if A.Trueshot:IsTalentLearned() and (not player:Buff(buffs.trueshot) or Trueshot:Cooldown() < 30000) then return end

    return spell:Cast()
end)

Fireblood:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if A.Trueshot:IsTalentLearned() and (not player:Buff(buffs.trueshot) or Trueshot:Cooldown() < 30000) then return end

    return spell:Cast()
end)

LightsJudgment:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.trueshot) then return end

    return spell:Cast()
end)

local function cds()
    Berserking()
    BloodFury()
    AncestralCall()
    Fireblood()
    LightsJudgment()
end

--########################## SINGLE TARGET #############################################17

-- actions.st=volley,if=!talent.double_tap&(talent.aspect_of_the_hydra|active_enemies=1|buff.precise_shots.down&(cooldown.rapid_fire.remains+action.rapid_fire.execute_time<6|!talent.bulletstorm))&(!raid_event.adds.exists|raid_event.adds.in>cooldown|active_enemies>1)
-- DR-specific helpers and callbacks aligned to SimC APL
SteadyShot:Callback("dr_buffer", function(spell)
    -- Queue a Steady Shot after Aimed Shot in DR to buffer Deathblow reaction if Black Arrow isn't about to be used
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if player:Buff(buffs.trueshot) then return end
    if Trueshot:Cooldown() <= 0 then return end
    if not isSpellInFlight(AimedShot) then return end
    -- Do not buffer Steady Shot if Rapid Fire is available or we just used Steady Shot
    if RapidFire:Cooldown() == 0 then return end
    if Player:PrevGCD(1, A.SteadyShot) then return end
    local baReady = ((BlackArrow:Cooldown() or 999999) < 500) or ((BlackArrow2:Cooldown() or 999999) < 500)
    if baReady then return end
    return spell:Cast(target)
end)

Trueshot:Callback("st_dr", function(spell)
    -- DR: avoid Trueshot if Black Arrow is ready; if Bulletstorm is talented, prefer when it's up
    if not shouldBurst() then return end
    if player:TalentKnown(DoubleTap.id) and player:Buff(buffs.doubleTap) then return end
    if player:TalentKnown(Bulletstorm.id) and not player:Buff(buffs.bulletstorm) then return end
    local baReady = ((BlackArrow:Cooldown() or 999999) < 500) or ((BlackArrow2:Cooldown() or 999999) < 500)
    if baReady then return end
    return spell:Cast()
end)

BlackArrow:Callback("st_dr", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if player:TalentKnown(Headshot.id) then
        if not gameState.preciseShots then return end
        -- Spend Precise Shots with BA when Spotter's is down or Moving Target is down
        if (not target:Debuff(debuffs.spottersMark, true)) or (not player:Buff(buffs.movingTarget)) then
            return spell:Cast(target)
        else
            return
        end
    else
        return spell:Cast(target)
    end
end)

BlackArrow2:Callback("st_dr", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if player:TalentKnown(Headshot.id) then
        if not gameState.preciseShots then return end
        if (not target:Debuff(debuffs.spottersMark, true)) or (not player:Buff(buffs.movingTarget)) then
            return spell:Cast(target)
        else
            return
        end
    else
        return spell:Cast(target)
    end
end)

AimedShot:Callback("st_dr", function(spell)
    if not gameState.aimedShotReady then return end
    local baReady = ((BlackArrow:Cooldown() or 999999) < 500) or ((BlackArrow2:Cooldown() or 999999) < 500)
    if ((player:Buff(buffs.trueshot) or baReady) and not gameState.preciseShots) or (player:Buff(buffs.lockAndLoad) and player:Buff(buffs.movingTarget)) then
        local canMove = player:Buff(buffs.lockAndLoad) or (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
        if not canMove and player.moving then return end
        return spell:Cast(target)
    end
end)

RapidFire:Callback("st_dr", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    local baReady = ((BlackArrow:Cooldown() or 999999) < 500) or ((BlackArrow2:Cooldown() or 999999) < 500)
    if baReady then return end
    return spell:Cast(target)
end)

BlackArrow:Callback("ts_prio", function(spell)
    -- Ensure Black Arrow proc/spend is not skipped during Trueshot
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if not player:Buff(buffs.trueshot) then return end
    return spell:Cast(target)
end)

BlackArrow2:Callback("ts_prio", function(spell)
    -- Ensure Black Arrow proc/spend is not skipped during Trueshot (2nd variant)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if not player:Buff(buffs.trueshot) then return end
    return spell:Cast(target)
end)


Volley:Callback("st", function(spell)
    if player:Buff(buffs.doubleTap) then return end

    return spell:Cast()
end)

-- actions.st+=/rapid_fire,if=hero_tree.sentinel&buff.lunar_storm_cooldown.down|!talent.aspect_of_the_hydra&talent.bulletstorm&active_enemies>1&buff.trick_shots.up&(buff.precise_shots.down|!talent.no_scope)
RapidFire:Callback("st", function(spell)
    -- Prioritize Rapid Fire to trigger Lunar Storm
    if player:TalentKnown(LunarStorm.id) and gameState.lunarStormCd <= 0 then
        return spell:Cast(target)
    end

    -- Stack extra Bulletstorm when Volley Trick Shots is up without Aspect of the Hydra
    if not player:TalentKnown(AspectOfTheHydra.id) and
       player:TalentKnown(Bulletstorm.id) and
       gameState.activeEnemies > 1 and
       player:Buff(buffs.trickShots) and
       (not gameState.preciseShots or not player:TalentKnown(NoScope.id)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/trueshot,if=variable.trueshot_ready
Trueshot:Callback("st", function(spell)
    if not shouldBurst() then return end
    if player:TalentKnown(DoubleTap.id) and player:Buff(buffs.doubleTap) then return end

    return spell:Cast()
end)

-- actions.st+=/explosive_shot,if=talent.precision_detonation&action.aimed_shot.in_flight&buff.trueshot.down
ExplosiveShot:Callback("st", function(spell)
    -- DR and Sentinel openers prioritize Explosive Shot before Trueshot under specific conditions
    local charges = AimedShot.frac or 0
    if player:TalentKnown(PrecisionDetonation.id) and not player:Buff(buffs.lockAndLoad) and charges <= 1.1 and not player:Buff(buffs.trueshot) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/aimed_shot,if=talent.precision_detonation&set_bonus.thewarwithin_season_2_4pc&(buff.precise_shots.down|debuff.spotters_mark.up&buff.moving_target.up)&buff.lock_and_load.up
AimedShot:Callback("st", function(spell)
    if not gameState.aimedShotReady then return end

    if not player:TalentKnown(PrecisionDetonation.id) then return end
    if not player:Has4Set() then return end
    if not player:Buff(buffs.lockAndLoad) then return end

    if not gameState.preciseShots or target:Debuff(debuffs.spottersMark, true) and player:Buff(buffs.movingTarget) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/volley,if=talent.double_tap&buff.double_tap.down
Volley:Callback("st2", function(spell)
    if not gameState.cursorCheck then return end

    if not player:TalentKnown(DoubleTap.id) then return end
    if player:Buff(buffs.doubleTap) then return end

    return spell:Cast()
end)

-- actions.st+=/kill_shot,target_if=min:dot.black_arrow_dot.ticking|max_prio_damage,if=talent.black_arrow&(talent.headshot&buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)|!talent.headshot&buff.razor_fragments.up)
KillShot:Callback("st", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end

    -- Black Arrow becomes the primary Precise Shot spenders for Headshot builds
    if player:TalentKnown(Headshot.id) and gameState.preciseShots and
       (not target:Debuff(debuffs.spottersMark, true) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end

    if not player:TalentKnown(Headshot.id) and player:Buff(buffs.razorFragments) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/kill_shot,target_if=max:debuff.spotters_mark.down|action.aimed_shot.in_flight_to_target|max_prio_damage,if=!talent.black_arrow&(talent.headshot&buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)|!talent.headshot&buff.razor_fragments.up)
KillShot:Callback("st2", function(spell)
    if player:TalentKnown(BlackArrowTalent.id) then return end

    -- Kill Shot becomes the primary Precise Shot spenders for Headshot builds without Black Arrow
    if player:TalentKnown(Headshot.id) and gameState.preciseShots and
       (not target:Debuff(debuffs.spottersMark, true) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end

    if not player:TalentKnown(Headshot.id) and player:Buff(buffs.razorFragments) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/multishot,target_if=max:debuff.spotters_mark.down|action.aimed_shot.in_flight_to_target|max_prio_damage,if=buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)&active_enemies>1&!talent.aspect_of_the_hydra&(talent.symphonic_arsenal|talent.small_game_hunter)
MultiShot:Callback("st", function(spell)
    -- Do not use Multi-Shot on 2 targets; Trick Shots requires 3+ and we don't want to loop
    local ae = gameState.activeEnemies or activeEnemies()
    if ae < 3 then return end
    if player:TalentKnown(AspectOfTheHydra.id) then return end
    if not gameState.preciseShots then return end

    if (player:TalentKnown(SymphonicArsenal.id) or player:TalentKnown(SmallGameHunter.id)) and target.exists and target.canAttack and ((not target:Debuff(debuffs.spottersMark, true)) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/arcane_shot,target_if=max:debuff.spotters_mark.down|action.aimed_shot.in_flight_to_target|max_prio_damage,if=buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)
ArcaneShot:Callback("st", function(spell)
    if not gameState.preciseShots then return end

    if not target:Debuff(debuffs.spottersMark) or not player:Buff(buffs.movingTarget) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/aimed_shot,target_if=max:debuff.spotters_mark.up,if=(buff.precise_shots.down|debuff.spotters_mark.up&buff.moving_target.up)&full_recharge_time<action.rapid_fire.execute_time+cast_time&(!talent.bulletstorm|buff.bulletstorm.up)&talent.windrunner_quiver
AimedShot:Callback("st2", function(spell)
    if not gameState.aimedShotReady then return end

    if not gameState.preciseShots or (target:Debuff(debuffs.spottersMark, true) and player:Buff(buffs.movingTarget)) and spell:TimeToFullCharges() < 1500 + spell:CastTime() and player:Buff(buffs.bulletstorm) and player:TalentKnown(WindrunnerQuiver.id) then
        local canMove = player:Buff(buffs.lockAndLoad) or
        (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
        if not canMove then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[2] and player.focus > AimedShot:Cost() then
                Aware:displayMessage("Trying to Aimed Shot!", "Hunter", 1, GetSpellTexture(spell.id))
            end

            if not player.moving then
                return spell:Cast(target)
            end
        else
            return spell:Cast(target)
        end
    end
end)

-- actions.st+=/rapid_fire,if=(!hero_tree.sentinel|buff.lunar_storm_cooldown.remains>cooldown%3)&(!talent.bulletstorm|buff.bulletstorm.stack<=10|talent.aspect_of_the_hydra&active_enemies>1)
RapidFire:Callback("st2", function(spell)
    if not player:TalentKnown(Bulletstorm.id) or player:HasBuffCount(buffs.bulletstorm) <= 10 or player:TalentKnown(AspectOfTheHydra.id) and gameState.activeEnemies > 1 then
        if player:TalentKnown(LunarStorm.id) then
            if gameState.lunarStormCd > 0 then
                if gameState.lunarStormCd > (gameState.rapidFireCdExpected / 3) then
                    return spell:Cast(target)
                end
            end
        end

        if not player:TalentKnown(LunarStorm.id) then
            return spell:Cast(target)
        end
    end
end)

-- actions.st+=/aimed_shot,target_if=max:debuff.spotters_mark.up|max_prio_damage,if=buff.precise_shots.down|debuff.spotters_mark.up&buff.moving_target.up
AimedShot:Callback("st3", function(spell)
    if not gameState.aimedShotReady then return end

    if not gameState.preciseShots or (target:Debuff(debuffs.spottersMark, true) and player:Buff(buffs.movingTarget)) then
        local canMove = player:Buff(buffs.lockAndLoad) or
        (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
        if not canMove then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[2] and player.focus > AimedShot:Cost() then
                Aware:displayMessage("Trying to Aimed Shot!", "Hunter", 1, GetSpellTexture(spell.id))
            end

            if not player.moving then
                return spell:Cast(target)
            end
        else
            return spell:Cast(target)
        end
    end
end)

-- actions.st+=/explosive_shot,if=talent.precision_detonation|buff.trueshot.down
ExplosiveShot:Callback("st2", function(spell)
    if player:TalentKnown(PrecisionDetonation.id) or not player:Buff(buffs.trueshot) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/black_arrow,if=!talent.headshot
BlackArrow:Callback("st2", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if player:TalentKnown(Headshot.id) then return end

    return spell:Cast(target)
end)

BlackArrow2:Callback("st2", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end
    if player:TalentKnown(Headshot.id) then return end

    return spell:Cast(target)
end)

-- actions.st+=/kill_shot,if=!talent.headshot
KillShot:Callback("st3", function(spell)
    if player:TalentKnown(Headshot.id) then return end

    return spell:Cast(target)
end)

-- actions.st+=/steady_shot
SteadyShot:Callback("st", function(spell)
    -- Avoid Steady Shot if Rapid Fire is available or during Trueshot; prevent chaining
    if RapidFire:Cooldown() == 0 then return end
    if player:Buff(buffs.trueshot) then return end
    if Player:PrevGCD(1, A.SteadyShot) and RapidFire:Cooldown() == 0 then return end
    return spell:Cast(target)
end)

ExplosiveShot:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not target:Debuff(debuffs.huntersMark) then return end

    return spell:Cast(target)
end)

KillShot:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not KillShot:InRange(target) then return end
    if target.hp > 15 then return end

    return spell:Cast(target)
end)

-- Updated to match APL priority order for DR and Sentinel (raid_event.adds logic omitted)
local function st()
    KillShot("pvp") 
    ExplosiveShot("pvp")            -- Blow Shit UP!!!
    ExplosiveShot("st")             -- DR/Sent: ES early with PD/shrapnel rules
    Volley("st")                    -- volley,if=buff.double_tap.down
    SteadyShot("dr_buffer")         -- DR: buffer Deathblow after Aimed Shot
    Trueshot("st_dr")               -- DR: trueshot if !black_arrow.ready and bulletstorm gating
    Trueshot("st")                  -- Sentinel/general: trueshot ready
    BlackArrow("ts_prio")           -- PRIORITY: spend Black Arrow during Trueshot
    BlackArrow2("ts_prio")          -- PRIORITY: spend Black Arrow during Trueshot (variant)
    RapidFire("st")                 -- Sentinel: lunar storm trigger or bulletstorm stacking
    KillShot("st")                  -- DR/Sent: KS headshot/razor spending
    BlackArrow("st_dr")             -- DR: BA usage (incl. headshot precise shots condition)
    BlackArrow2("st_dr")            -- DR: BA usage (incl. headshot precise shots condition)
    AimedShot("st_dr")              -- DR: (trueshot|ba.ready)&!precise | LnL&moving_target
    ArcaneShot("st")                -- precise shots spend when appropriate
    Volley("st2")                   -- volley,if=talent.double_tap&buff.double_tap.down
    KillShot("st2")                 -- non-BA variant
    MultiShot("st")                 -- multishot precise shots spenders for some builds
    AimedShot("st2")                -- near-capping charges with Windrunner
    RapidFire("st_dr")              -- DR: if black arrow not ready
    RapidFire("st2")                -- general usage
    AimedShot("st3")                -- general Aimed Shot
    ExplosiveShot("st2")            -- fallback ES
    KillShot("st3")                 -- KS if !headshot
    SteadyShot("st")                -- filler
end

-- actions.trickshots=volley,if=!talent.double_tap
Volley:Callback("aoe", function(spell)
    if not gameState.cursorCheck then return end
    if player:TalentKnown(DoubleTap.id) then return end

    return spell:Cast()
end)

-- actions.trickshots+=/trueshot,if=variable.trueshot_ready
Trueshot:Callback("aoe", function(spell)
    if not shouldBurst() then return end

    return spell:Cast()
end)

-- actions.trickshots+=/multishot,target_if=max:debuff.spotters_mark.down|action.aimed_shot.in_flight_to_target,if=buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)|buff.trick_shots.down
MultiShot:Callback("aoe", function(spell)
    -- If Trick Shots is already up (e.g., from Black Arrow on 3+), do not cast Multi-Shot right after
    if player:Buff(buffs.trickShots) then return end

    -- Spend Precise Shots cleave when appropriate, but not if Trick Shots is already up
    if target.exists and target.canAttack and gameState.preciseShots and ((not target:Debuff(debuffs.spottersMark, true)) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end

    -- Only press Multi-Shot to apply Trick Shots if we can actually gain it (requires 3+ targets)
    -- Also, if Black Arrow is talented and ready, let it grant Trick Shots on 3+ targets instead of Multi-Shot
    local ae = gameState.activeEnemies or activeEnemies()
    if not player:Buff(buffs.trickShots) then
        if ae >= 3 then
            if player:TalentKnown(BlackArrowTalent.id) then
                local baCd1 = BlackArrow:Cooldown() or 999999
                local baCd2 = BlackArrow2:Cooldown() or 999999
                if baCd1 == 0 or baCd2 == 0 then
                    return
                end
            end
            if target.exists and target.canAttack then
                return spell:Cast(target)
            end
        end
        return
    end
end)

MultiShot:Callback("aoe_dump", function(spell)
    -- Fallback only when 3+ targets are present; avoid spamming on 2 targets where Trick Shots cannot be gained
    if player:Buff(buffs.trickShots) then return end
    local ae = gameState.activeEnemies or activeEnemies()
    if ae >= 3 and target.exists and target.canAttack then
        return spell:Cast(target)
    end
end)

-- actions.trickshots+=/volley,if=talent.double_tap&buff.double_tap.down
Volley:Callback("aoe2", function(spell)
    if not gameState.cursorCheck then return end
    if not player:TalentKnown(DoubleTap.id) then return end
    if player:Buff(buffs.doubleTap) then return end

    return spell:Cast()
end)

-- actions.trickshots+=/black_arrow,if=talent.black_arrow&(!talent.headshot|buff.precise_shots.up&(debuff.spotters_mark.down|buff.moving_target.down)|buff.trick_shots.down)
BlackArrow:Callback("aoe", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end

    if not player:TalentKnown(Headshot.id) then
        return spell:Cast()
    end

    if gameState.preciseShots and (not target:Debuff(debuffs.spottersMark, true) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end

    if not player:Buff(buffs.trickShots) then
        return spell:Cast(target)
    end
end)

BlackArrow2:Callback("aoe", function(spell)
    if not player:TalentKnown(BlackArrowTalent.id) then return end

    if not player:TalentKnown(Headshot.id) then
        return spell:Cast()
    end

    if gameState.preciseShots and (not target:Debuff(debuffs.spottersMark, true) or not player:Buff(buffs.movingTarget)) then
        return spell:Cast(target)
    end

    if not player:Buff(buffs.trickShots) then
        return spell:Cast(target)
    end
end)

-- actions.trickshots+=/aimed_shot,if=(buff.precise_shots.down|debuff.spotters_mark.up&buff.moving_target.up)&buff.trick_shots.up&buff.bulletstorm.up&full_recharge_time<gcd
AimedShot:Callback("aoe", function(spell)
    if not gameState.aimedShotReady then return end

    if not player:Buff(buffs.bulletstorm) then return end
    if spell:TimeToFullCharges() > A.GetGCD() * 1000 then return end

    if not gameState.preciseShots or (target:Debuff(debuffs.spottersMark, true) and player:Buff(buffs.movingTarget)) then
        local canMove = player:Buff(buffs.lockAndLoad) or
        (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
        if not canMove then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[2] and player.focus > AimedShot:Cost() then
                Aware:displayMessage("Trying to Aimed Shot!", "Hunter", 1, GetSpellTexture(spell.id))
            end

            if not player.moving then
                return spell:Cast(target)
            end
        else
            return spell:Cast(target)
        end
    end
end)

-- actions.trickshots+=/rapid_fire,if=buff.trick_shots.remains>execute_time&(!hero_tree.sentinel|buff.lunar_storm_cooldown.remains>cooldown%3|buff.lunar_storm_ready.up)
RapidFire:Callback("aoe", function(spell)
    if player:BuffRemains(buffs.trickShots) < 1.5 then return end

    if player:TalentKnown(LunarStorm.id) then
        if gameState.lunarStormCd <= 0 then
            return spell:Cast(target)
        elseif gameState.lunarStormCd < 500 then
            Aware:displayMessage("Holding GCD for lunar storm!", "Hunter", 1, GetSpellTexture(spell.id))
            MakuluFramework.spellState.gcdHold = true
            return
        elseif gameState.lunarStormCd < 1000 then
            Aware:displayMessage("Holding Casts for lunar storm!", "Hunter", 1, GetSpellTexture(spell.id))
            MakuluFramework.spellState.castingLockdown = true
            return
        else
            if gameState.lunarStormCd > (gameState.rapidFireCdExpected / 3) then
                return spell:Cast(target)
            end
        end
    else
        return spell:Cast()
    end
end)

-- actions.trickshots+=/explosive_shot,if=talent.precision_detonation&action.aimed_shot.in_flight&buff.trueshot.down
ExplosiveShot:Callback("aoe", function(spell)
    -- DR: ES early during Trick Shots when PD and Trueshot down; prefer LnL down to avoid conflict
    if player:TalentKnown(PrecisionDetonation.id) and not player:Buff(buffs.trueshot) and not player:Buff(buffs.lockAndLoad) then
        return spell:Cast(target)
    end
end)

-- actions.trickshots+=/aimed_shot,if=(buff.precise_shots.down|debuff.spotters_mark.up&buff.moving_target.up)&buff.trick_shots.up
AimedShot:Callback("aoe2", function(spell)
    if not gameState.aimedShotReady then return end

    if player:BuffRemains(buffs.trickShots) < AimedShot:CastTime() + MakGcd() then return end

    if not gameState.preciseShots or (target:Debuff(debuffs.spottersMark, true) and player:Buff(buffs.movingTarget)) then
        local canMove = player:Buff(buffs.lockAndLoad) or
        (player:TalentKnown(AspectOfTheFox.id) and gameState.hasCheetah)
        if not canMove then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[2] and player.focus > AimedShot:Cost() then
                Aware:displayMessage("Trying to Aimed Shot!", "Hunter", 1, GetSpellTexture(spell.id))
            end

            if not player.moving then
                return spell:Cast(target)
            end
        else
            return spell:Cast(target)
        end
    end
end)

-- actions.trickshots+=/explosive_shot
ExplosiveShot:Callback("aoe2", function(spell)
    return spell:Cast(target)
end)

-- actions.trickshots+=/kill_shot
KillShot:Callback("aoe", function(spell)
    return spell:Cast(target)
end)

-- actions.trickshots+=/steady_shot,if=focus+cast_regen<focus.max
SteadyShot:Callback("aoe", function(spell)
    -- Only cast if we won't cap focus after the cast; avoid when RF ready or during Trueshot; avoid chaining
    if player.focus + 20 >= player.focusMax then return end
    if RapidFire:Cooldown() == 0 then return end
    if player:Buff(buffs.trueshot) then return end
    if Player:PrevGCD(1, A.SteadyShot) and RapidFire:Cooldown() == 0 then return end
    return spell:Cast(target)
end)

-- Updated to match APL trickshots priority order (raid_event.adds logic omitted)
local function trickshots()
    KillShot("pvp")
    ExplosiveShot("pvp")            -- Blow Shit UP!!!
    ExplosiveShot("aoe")            -- explosive_shot first when Aimed Shot in flight and Trueshot down
    Volley("aoe")                   -- volley,if=!talent.double_tap
    RapidFire("aoe")                -- rapid_fire with sentinel/lunar storm logic inside
    BlackArrow("aoe")               -- black_arrow conditions per APL
    BlackArrow2("aoe")              -- black_arrow,if=talent.black_arrow
    MultiShot("aoe")                -- multishot, spend Precise Shots or apply Trick Shots
    Trueshot("aoe")                 -- trueshot,if=variable.trueshot_ready&buff.double_tap.down
    Volley("aoe2")                  -- volley,if=talent.double_tap&buff.double_tap.down
    AimedShot("aoe")                -- aimed_shot with bulletstorm & recharge logic
    ExplosiveShot("aoe2")           -- explosive_shot (fallback)
    AimedShot("aoe2")               -- aimed_shot,if=...&buff.trick_shots.up
    SteadyShot("aoe")               -- steady_shot,if=focus+cast_regen<focus.max
    MultiShot("aoe_dump")           -- multishot (fallback)
end

local function totemStomp()
    ArcaneShot("st")
    SteadyShot("st")
end

TarTrap:Callback("pvp", function(spell)
    if enemiesInMelee() < 1 then return end

    return spell:Cast()
end)

BurstingShot:Callback("pvp", function(spell)
    if not A.BurstingShot:IsTalentLearned() then return end
    if enemiesInMelee() < 1 then return end
    if Player:PrevGCD(1, A.TarTrap) then return end

    return spell:Cast()
end)

HighExplosiveTrap:Callback("pvp", function(spell)
    if player:TalentKnown(ImplosiveTrap.id) then return end
    if enemiesInMeleeBurstingPvP() == 0 then return end

    return spell:Cast()
end)

BindingShot:Callback("pvp", function(spell)
    if not A.BindingShot:IsTalentLearned() then return end
    if enemiesInMeleeBurstingPvP() == 0 then return end
    if Player:PrevGCD(1, A.HighExplosiveTrap) then return end

    return spell:Cast()
end)

ConcussiveShot:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not target.exists then return end
    if target:DebuffFrom(MakLists.Slowed) then return end
    if target:BuffFrom(MakLists.SlowImmune) then return end

    return spell:Cast(target)
end)

ConcussiveShot:Callback("pvp-focus", function(spell)
    if not A.IsInPvP then return end
    if not focus.exists then return end
    if focus:DebuffFrom(MakLists.Slowed) then return end
    if focus:BuffFrom(MakLists.SlowImmune) then return end

    return spell:Cast(focus)
end)

SniperShot:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not A.SniperShot:IsTalentLearned() then return end

    if target.hp <= 85 then return end

    return spell:Cast(target)
end)

ConcussiveShot:Callback("close", function(spell, enemy)
    local u = enemy or target or ConstUnit.target
    if not A.IsInPvP then return end
    if not spell:ReadyToUse() then return end
    if not u or not u:Exists() or u:IsDeadOrGhost() or not u:CanAttack() then return end
    if u.Los and not u:Los() then return end
    -- “close” check (<= 20y)
    if u.Distance and u:Distance() > 20 then return end
    -- skip if target is immune to slows (method may not exist on all builds)
    if u.IsSlowImmune and u:IsSlowImmune() then return end
    -- skip if our slow is already on them
    if u:DebuffRemains(debuffs.concussiveShot, true) > 0 then return end
    -- optional: also confirm spell thinks we're in range
    if spell:HasRange() and not spell:InRange(u) then return end

    return spell:Cast(u)
end)

TranquilizingShot:Callback("pvp", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    if not target:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(target)
end)

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Current Cast: ", gameState.imCasting)
        MakPrint(2, "Active Enemies: ", activeEnemies())
        MakPrint(3, "Should Rapid Fire: ", gameState.lunarStormCd > (gameState.rapidFireCdExpected / 3))
        MakPrint(4, "Rapid Fire CD: ", gameState.rapidFireCdExpected)
        MakPrint(5, "Aimed Shot Recharge Time: ", AimedShot:TimeToFullCharges())
        MakPrint(6, "Lunar Storm CD: ", gameState.lunarStormCd)
        MakPrint(7, "Trinket cd : ", getOffensiveSlotCd(13))
        MakPrint(8, "Rapid Fire last attempt: ", RapidFire.lastAttempt)
        MakPrint(9, "Wailing Arrow Usable: ", IsSpellOverlayed(WailingArrow.id))
        MakPrint(10, "Aimed Shot Cost: ", AimedShot:Cost())
        MakPrint(11, "Exhaustion Remains: ", player:SatedRemains())
        MakPrint(12, "Lunar Storm: ", player:TalentKnown(LunarStorm.id))
    end

    if A.GetToggle(2, "sotfPixel") and player:IsMounted() then
        return A.Mounted:Show(icon)
    end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then
        if player:TalentKnown(Misdirection.id) and not A.IsInPvP then
            local tankExists = MakMulti.party:Find(function(friendly) return friendly.isTank end)
            if not focus.exists and GetNumGroupMembers() > 1 and tankExists then
                Aware:displayMessage("Set Focus for Misdirect!", "Red", 1)
            end
        end
    end

	if Action.Zone == "arena" then
        if enemyHealer.exists and enemyHealer.distance < 40 and enemyHealer:CCRemains() > 2000 and enemyHealer.incapacitateDr >= .5 and FreezingTrap:Cooldown() < 1500 then
            local aware = A.GetToggle(2, "makArenaAware")
            if aware then Aware:displayMessage("You should try to TRAP now.", "Blue", 1) end
        end
    end

    if player.channeling then return FrameworkEnd() end

    FeignDeath()
    if makFeign() and player.feigned then return FrameworkEnd() end

    makInterrupt(interrupts)

    TranquilizingShot("pvp")
    Exhilaration()
    AspectOfTheTurtle()
    SurvivalOfTheFittest(icon)
    Camouflage()
    HuntersMark()
    ConcussiveShot("close")

    if A.Zone == "arena" or A.Zone == "pvp" then
        --TarTrap("pvp")
        --BurstingShot("pvp")
        --HighExplosiveTrap("pvp")
        --ConcussiveShot("pvp")
        --BindingShot("pvp")
    end

    if target.exists and target.canAttack and KillShot:InRange(target) and (gameState.imCastingRemaining and gameState.imCastingRemaining < 700 or not gameState.imCastingRemaining) then
        if ActionUnit("target"):IsTotem() then
            totemStomp()
        end

        Misdirection()
        SniperShot("pvp")
        AimedShot("pre")
        SteadyShot("pre")
        Volley("pre-pvp")
        ExplosiveShot("pvp")
        RapidFire("pre-pvp")

        if shouldBurst() then
            cds()
            if player:Buff(buffs.trueshot) then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end

            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1,
                A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2,
                A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = Trueshot.cd < 750 or player:Buff(buffs.trueshot)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        if gameState.shouldAoE then
            KillShot("pvp")
            trickshots()
        else
            KillShot("pvp")
            st()
        end
    end

    return FrameworkEnd()
end

local HIGH_PRIO_PURGE = {
  1044,  -- Blessing of Freedom
  1022,  -- Blessing of Protection
  6940,  -- Blessing of Sacrifice
  10060, -- Power Infusion
  47788, -- Guardian Spirit
  974,   -- Earth Shield
  79206, -- Spiritwalker's Grace
  192106,-- Lightning Shield
  29166, -- Innervate
  33763, -- Lifebloom
  8936,  -- Regrowth
  774,   -- Rejuvenation
  48438, -- Wild Growth
  11426, -- Ice Barrier
  235313,-- Blazing Barrier
  358267,-- Hover
  366155,-- Reversion
  364343,-- Echo
  124682,-- Enveloping Mist
  119611,-- Renewing Mist
  184362,-- Enrage
}

local LOW_HEALTH_PURGE = {
  1044,  -- Blessing of Freedom
  1022,  -- Blessing of Protection
  6940,  -- Blessing of Sacrifice
  10060, -- Power Infusion
  47788, -- Guardian Spirit
  974,   -- Earth Shield
  79206, -- Spiritwalker's Grace
  192106,-- Lightning Shield
  29166, -- Innervate
  33763, -- Lifebloom
  8936,  -- Regrowth
  774,   -- Rejuvenation
  48438, -- Wild Growth
  11426, -- Ice Barrier
  235313,-- Blazing Barrier
  358267,-- Hover
  366155,-- Reversion
  364343,-- Echo
  124682,-- Enveloping Mist
  119611,-- Renewing Mist
  184362,-- Enrage
}

local buffDetectedTime = nil
local delayPassedSS = false
local SS_DELAY_DURATION = 1.5

local function shouldPurgePvP(enemy)
    for _, buff in ipairs(HIGH_PRIO_PURGE) do
        if enemy:Buff(buff) then
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

CounterShot:Callback("arena", function(spell, enemy)
    if enemy:IsKickImmune() then return end
    if not A.CounterShot:IsTalentLearned() then return end
    if target.hp < 20 then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end

    return spell:Cast(enemy)
end)

TranquilizingShot:Callback("arena", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    --if target.hp < 40 then return end
    if not enemy:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(enemy)
end)

Intimidation:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if enemy:IsCCImmune() then return end
    local aware = A.GetToggle(2, "makArenaAware")
    if not enemy:IsPlayer() then return end
    if enemy.distance > 30 then return end
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if ccRemains > 0 then return end

    if enemy:IsTarget() and enemyHealer.ccRemains > 2000 and target.stunDr == 1 and target.hp <= 35 then

        return spell:Cast(enemy)
    end

    if enemy:IsTarget() then return end
    if enemy.stunDr < 0.25 then return end

    if enemy:IsHealer() and enemy.stunDr >= .25 and target.hp <= 35 and target.hp > 10 then

        return spell:Cast(enemy)
    end

    if enemy:IsHealer() and enemy.stunDr == 1 and target.hp <= 90 and target.hp > 10 and FreezingTrap:Cooldown() < 500 then

        return spell:Cast(enemy)
    end

    if enemy:IsHealer() and enemy.stunDr >= .5 and target.hp <= 50 and target.hp > 10 and FreezingTrap:Cooldown() < 500  then

        return spell:Cast(enemy)
    end
end)

ScatterShot:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if enemy:IsCCImmune() then return end
    local aware = A.GetToggle(2, "makArenaAware")
    if enemy.distance > 30 then return end
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if ccRemains > 0 then return end

    -- NEVER use on main target - this is for peeling off DPS targets
    if enemy:IsTarget() then return end
    if enemy.incapacitateDr < 0.25 then return end

    -- Priority 1: Peel DPS when they pop cooldowns (cds = true means offensive cooldowns are active)
    if not enemy:IsHealer() and enemy.cds and enemy.incapacitateDr >= 0.5 then
        return spell:Cast(enemy)
    end

    -- Priority 2: Peel DPS when your healer is under CC
    if not enemy:IsHealer() and enemy.incapacitateDr >= 0.5 then
        if (party1.exists and party1.cc) or (party2.exists and party2.cc) then
            return spell:Cast(enemy)
        end
    end

    -- Priority 3: Peel healer when target is low HP
    if enemy:IsHealer() and target.hp <= 25 then

        return spell:Cast(enemy)
    end

    if enemy:IsHealer() and target.hp <= 40 and enemy.incapacitateDr >= .5 then

        return spell:Cast(enemy)
    end

    -- Priority 4: Peel DPS when your party member is low HP
    if not enemy:IsHealer() and enemy.incapacitateDr == 1 and (party1.exists and party1.hp > 0 and party1.hp < 40) then

        return spell:Cast(enemy)
    end

    if not enemy:IsHealer() and enemy.incapacitateDr == 1 and (party2.exists and party2.hp > 0 and party2.hp < 40) then

        return spell:Cast(enemy)
    end

    if not enemy:IsHealer() and enemy.incapacitateDr == 1 and (player.hp > 0 and player.hp < 40) and AspectOfTheTurtle:Cooldown() > 2000 then

        return spell:Cast(enemy)
    end
end)

ChimaeralSting:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if not enemy:IsUnit(enemyHealer) then return end
    if enemy.totalImmune then return end
    if enemy.cc then return end
    if target.hp < 30 then return end

    return spell:Cast(enemy)
end)

RoarOfSacrifice:Callback("arena", function(spell, friendly)
    if not A.RoarOfSacrifice:IsTalentLearned() then return end
    if friendly.totalImmune then return end
    if friendly.hp < 70 and enemyBurstCount() >= 1 then
        return spell:Cast(friendly)
    end

    if friendly.hp < 40 then
        return spell:Cast(friendly)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    if player:Buff(buffs.camouflage) then return end
    if player:Debuff(410201) then return end
    
    Intimidation("arena", enemy)
    CounterShot("arena", enemy)
    ScatterShot("arena", enemy)
    TranquilizingShot("arena", enemy)
    ChimaeralSting("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    RoarOfSacrifice("arena", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end

    local casting = player.castInfo
    local shouldStopSteady = A.GetToggle(2, "stopSteady") and player.combat and player.casting and
    casting.spellId == SteadyShot.id and casting.percent < 80 and AimedShot.frac > 1 and
    (player.focus > AimedShot:Cost() or player:Buff(buffs.lockAndLoad))

    if shouldStopSteady and (not player.moving or player:Buff(buffs.lockAndLoad)) then
        return A:Show(icon, ACTION_CONST_STOPCAST)
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
