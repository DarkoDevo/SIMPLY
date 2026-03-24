if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 102 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Debounce         = MakuluFramework.debounceSpell
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware
local FakeCasting      = MakuluFramework.FakeCasting
local NeedRaidBuff     = MakuluFramework.NeedRaidBuff

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local LoC = Action.LossOfControl

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID       = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    WarStomp = { ID = 20549, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Fireblood = { ID = 265221, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    BullRush = { ID = 255654, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    AncestralCall = { ID = 274738, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Haymaker = { ID = 287712, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Regeneratin = { ID = 291944, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },

    Mangle = { ID = 33917, MAKULU_INFO = { ignoreCasting = true } },
    Shred = { ID = 5221, MAKULU_INFO = { ignoreCasting = true } },
    Wrath = { ID = 190984, MAKULU_INFO = { ignoreCasting = true } },
    Moonfire = { ID = 8921, MAKULU_INFO = { ignoreCasting = true }},
    Regrowth = { ID = 8936, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    EntanglingRoots = { ID = 339, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm][]spell:thisID" },
    CatForm = { ID = 768, MAKULU_INFO = { ignoreCasting = true } },
    BearForm = { ID = 5487, MAKULU_INFO = { ignoreCasting = true } },
    TravelForm = { ID = 783, MAKULU_INFO = { ignoreCasting = true } },
    MoonkinForm = { ID = 24858, MAKULU_INFO = { ignoreCasting = true } },
    Dash = { ID = 1850, MAKULU_INFO = { ignoreCasting = true } },
    Ironfur = { ID = 192081, MAKULU_INFO = { ignoreCasting = true } },
    FerociousBite = { ID = 22568, MAKULU_INFO = { ignoreCasting = true } },
    MarkOfTheWild = { ID = 1126, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,exists][@focus,exists][@player][]spell:thisID" },
    Growl = { ID = 6795, MAKULU_INFO = { ignoreCasting = true } },
    Barkskin = { ID = 22812, MAKULU_INFO = { ignoreCasting = true } },
    Prowl = { ID = 5215, MAKULU_INFO = { ignoreCasting = true } },
    Rebirth = { ID = 20484, MAKULU_INFO = { ignoreCasting = true, heal = true }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Revive = { ID = 50769, MAKULU_INFO = { ignoreCasting = true, heal = true }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Rake = { ID = 1822, MAKULU_INFO = { ignoreCasting = true } },
    FrenziedRegeneration = { ID = 22842, MAKULU_INFO = { ignoreCasting = true } },
    Starfire = { ID = 194153, MAKULU_INFO = { ignoreCasting = true } },
    Rejuvenation = { ID = 774, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help][@player][]spell:thisID" },
    Thrash = { ID = 106832, MAKULU_INFO = { ignoreCasting = true } },
    Swiftmend = { ID = 18562, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help][@player][]spell:thisID" },
    Starsurge = { ID = 78674, MAKULU_INFO = { ignoreCasting = true, ignoreResource = true } },
    Rip = { ID = 1079, MAKULU_INFO = { ignoreCasting = true } },
    Swipe = { ID = 213764, MAKULU_INFO = { ignoreCasting = true } },
    RemoveCorruption = { ID = 2782, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,exists][@focus,exists][]spell:thisID" },
    Maim = { ID = 22570, MAKULU_INFO = { ignoreCasting = true } },
    Hibernate = { ID = 2637, MAKULU_INFO = { ignoreCasting = true } },
    SkullBash = { ID = 106839, MAKULU_INFO = { ignoreCasting = true } },
    SolarBeam = { ID = 78675, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,exists][@focus,exists][]spell:thisID" },
    WildCharge = { ID = 102401, MAKULU_INFO = { ignoreCasting = true } },
    Cyclone = { ID = 33786, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Soothe = { ID = 2908, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Sunfire = { ID = 93402, MAKULU_INFO = { ignoreCasting = true } },
    Typhoon = { ID = 132469, MAKULU_INFO = { ignoreCasting = true } },
    StampedingRoar = { ID = 106898, MAKULU_INFO = { ignoreCasting = true } },
    WildGrowth = { ID = 48438, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help][@player][]spell:thisID" },
    IncapacitatingRoar = { ID = 99, MAKULU_INFO = { ignoreCasting = true } },
    MightyBash = { ID = 5211, MAKULU_INFO = { ignoreCasting = true } },
    MassEntanglement = { ID = 102359, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    UrsolsVortex = { ID = 102793, MAKULU_INFO = { ignoreCasting = true } },
    Renewal = { ID = 108238, MAKULU_INFO = { ignoreCasting = true } },
    Innervate = { ID = 29166, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@mouseover,help][@focus,help][]spell:thisID" },
    HeartOfTheWild = { ID = 319454, MAKULU_INFO = { ignoreCasting = true } },
    NaturesVigil = { ID = 124974, MAKULU_INFO = { ignoreCasting = true } },

    Starfall = { ID = 191034, MAKULU_INFO = { ignoreCasting = true, ignoreResource = true } },
    StellarFlare = { ID = 202347, MAKULU_INFO = { ignoreCasting = true } },
    ForceOfNature = { ID = 205636, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@player]spell:thisID" },
    CelestialAlignment = { ID = 194223, MAKULU_INFO = { ignoreCasting = true } },
    CelestialAlignmentToo = { ID = 383410, Hidden = true },
    AstralCommunion = { ID = 400636, MAKULU_INFO = { ignoreCasting = true } },
    WildMushroom = { ID = 88747, MAKULU_INFO = { ignoreCasting = true } },
    ConvokeTheSpirits = { ID = 391528, FixedTexture = 3636839, MAKULU_INFO = { ignoreCasting = true } },
    FuryOfElune = { ID = 202770, MAKULU_INFO = { ignoreCasting = true } },
    NewMoon = { ID = 274281, MAKULU_INFO = { ignoreCasting = true } },
    HalfMoon = { ID = 274282, Texture = 202767, MAKULU_INFO = { ignoreCasting = true } },
    FullMoon = { ID = 274283, Texture = 202767, MAKULU_INFO = { ignoreCasting = true } },
    WarriorOfElune = { ID = 202425, MAKULU_INFO = { ignoreCasting = true } },
    IncarnationChosenOfElune = { ID = 102560, MAKULU_INFO = { ignoreCasting = true } },

    FaerieSwarm = { ID = 209749 },
    Thorns = { ID = 305497 },

    AetherialKindling = { ID = 327541, Hidden = true },
    Starweaver = { ID = 393940, Hidden = true },
    NaturesBalance = { ID = 202430, Hidden = true },
    OrbitBreaker = { ID = 383197, Hidden = true },
    UmbralIntensity = { ID = 383197, Hidden = true },
    AstralSmolder = { ID = 383197, Hidden = true },
    OrbitalStrike = { ID = 361237, Hidden = true },
    Starlord = { ID = 202345, Hidden = true },
    ElunesGuidance = { ID = 393991, Hidden = true },
    TreantsOfTheMoon = { ID = 428544, Hidden = true },
    LunarCalling = { ID = 429523, Hidden = true },
    DreamSurge = { ID = 433831, Hidden = true },
    WhirlingStars = { ID = 468743, Hidden = true },
    ControlOfTheDream = { ID = 434249, Hidden = true },
    WildSurges = { ID = 406890, Hidden = true },
    MoonGuardian = { ID = 429520, Hidden = true },
    SoulOfTheForest = { ID = 114107, Hidden = true },
    WaningTwilight = { ID = 393956, Hidden = true },
    FluidForm = { ID = 449193, Hidden = true },
    LycarasMeditation = { ID = 474728, Hidden = true },
    Lunation = { ID = 429539, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = false },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = false },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = false },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    SynapseEnhancer = { ID = 8936, Type = "Item", FixedTexture = 133667, Hidden = true, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true, offGcd = true } }, -- Universal1
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DRUID_BALANCE] = A

TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "Wrath", "Starfire", "Starsurge", "Starfall", "FullMoon", "HalfMoon", "NewMoon",
        "StellarFlare", "Sunfire", "Moonfire", "Regrowth", "EntanglingRoots",
        "Rebirth", "Revive", "Cyclone", "Hibernate", "WildGrowth",
        "FuryOfElune", "AstralCommunion"
    }

    for _, spellName in ipairs(castTimeSpellNames) do
        local spell = M[spellName]
        if spell then
            -- Use rawset to directly set the ignoreMoving property on the spell object
            rawset(spell, "ignoreMoving", castWhileMoving)
        end
    end
end

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

local gs = {
    imCasting = nil,
    shouldAoE = false,
    moonfireRefreshable = false,
    sunfireRefreshable = false,
    moonfireRefreshableAoE = false,
    sunfireRefreshableAoE = false,
    activeEnemies = 1,
    activeElites = 0,
    fightRemains = 999,
    astralPower = 0,
    moonfireCount = 0,
    sunfireCount = 0,
    effectiveMoonfireCount = 0,
    effectiveSunfireCount = 0,
    enteringEclipse = false,
    eclipse = false,
    eclipseRemains = 0,
    enterLunar = false,
    boatStacks = 0,
    TWW1has2P = false,
    TWW1has4P = false,
    inRaid = MakMulti.party:Size() > 5,
    wraithCount = 0,
    starfireCount = 0,
    cdCon1 = false,
    cdCon2 = false,
    cdCondition = false,
}

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    harmonyOfTheGrove = 428735,
    lunarEclipse = 48518,
    solarEclipse = 48517,
    boatArcane = 394050,
    boatNature = 394049,
    celestialAlignment = 194223,
    incarnation = 102560,
    moonkinForm = 24858,
    bearForm = 5487,
    travelForm = 783,
    starweaversWarp = 393942,
    starweaversWeft = 393944,
    touchTheCosmos = 394414,
    dreamstate = 450346,
    umbralEmbrace = 424248,
    starlord = 279709,
    frenziedRegeneration = 22842,
}

local debuffs = {
    exhaustion = 57723,
    moonfire = 164812,
    sunfire = 164815,
    stellarFlare = 202347,
    massEntanglement = 102359,
    cyclone = 33786,
    waningTwilight = 393956,
    fungalGrowth = 81281,
}

local interrupts = {
    { spell = SolarBeam },
    { spell = IncapacitatingRoar, isCC = true, aoe = true, distance = 3 },
}

FakeCasting.enable()

FakeCasting.blacklist({
    [190984] = true, --Wrath
  })

Player:AddTier("TWW1", { 212059, 212057, 212056, 212055, 212054 })

local function num(val)
    if val then return 1 else return 0 end
end

local function shouldBurst()
    if A.BurstIsON("target") then
        if A.Zone ~= "arena" then
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if enemy.ttd >= A.GetToggle(2, "burstSens") * 1000 then
                    return true
                end
            end
            if target.isDummy then return true end
        else
            return true
        end
    end
    return false
end

local constCell        = cacheContext:getConstCacheCell()

function notElite(unit)
    local cacheKey = "notElite" .. tostring(unit)

    return constCell:GetOrSet(cacheKey, function()
        local class = UnitClassification(unit:CallerId())
        local poopClass = { "rare", "normal", "trivial", "minus" }

        for _, v in ipairs(poopClass) do
            if class == v then
                return true
            end
        end

        return false
    end)
end

local function enemiesWithDots(debuff, dur)
    local cacheKey = debuff and ("enemiesWithDots" .. tostring(debuff))

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)

            if Moonfire:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if debuff and enemy:DebuffRemains(debuff, true) > dur and (enemy.ttd > dur or enemy.isDummy) then
                        count = count + 1
                    end
                end
            end
        end

        return count
    end)
end

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)

            if Moonfire:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function enemiesTTD(dur)
    local cacheKey = "enemiesTTD"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)

            if Moonfire:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if enemy.ttd > dur or enemy.isDummy then
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

local function autoTarget()
    if A.Zone == "arena" then return false end
    if not player.inCombat then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if gs.moonfireRefreshableAoE then
        return false
    end

    if A.GetToggle(2, "autoDOT") and gs.multidotMoonfireCount < math.min(gs.enemiesTTD, A.GetToggle(2, "maxMoonfire")) then
        return true
    end

    if gs.sunfireRefreshableAoE then
        return false
    end

    if A.GetToggle(2, "autoDOT") and gs.multidotSunfireCount < math.min(gs.enemiesTTD, A.GetToggle(2, "maxSunfire")) then
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

local function futureAstralPower()
    local astralPower = player.lunarPower
    local casting = gs.imCasting

    local astralPowerGains = {
        [Wrath.id] = 6,
        [Starfire.id] = 8,
        [StellarFlare.id] = 12,
        [NewMoon.id] = 10,
        [HalfMoon.id] = 20,
        [FullMoon.id] = 40
    }

    if player:TalentKnown(WildSurges.id) then
        astralPowerGains[Wrath.id] = astralPowerGains[Wrath.id] + 2
        astralPowerGains[Starfire.id] = astralPowerGains[Starfire.id] + 2
    end

    if player:TalentKnown(MoonGuardian.id) then
        astralPowerGains[Starfire.id] = astralPowerGains[Starfire.id] + 2
    end

    if gs.TWW1has4P and gs.eclipse then
        astralPowerGains[Wrath.id] = astralPowerGains[Wrath.id] + 2
        astralPowerGains[Starfire.id] = astralPowerGains[Starfire.id] + 5
    end

    if player:TalentKnown(SoulOfTheForest.id) then
        if gs.hasSolar then
            astralPowerGains[Wrath.id] = astralPowerGains[Wrath.id] * 1.6
        end
        if gs.hasLunar then
            astralPowerGains[Starfire.id] = astralPowerGains[Starfire.id] * 1.4 -- 40% middle ground between 1-3 targets, hard to predict if we're going to hit all active enemies with Starfire
        end
    end

    if casting then
        return astralPower + (astralPowerGains[casting] or 0)
    else
        return astralPower
    end
end

local function fightRemains()
    local cacheKey = "areaTTD"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local highest = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.isDummy then
                highest = 99999
            else
                if enemy.ttd > 0 and enemy.ttd > highest then
                    highest = enemy.ttd
                end
            end
        end

        return highest
    end)
end


local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId

    return currentCast
end

local lastUpdateTime = 0
local updateDelay = 0.25
local function updateGameState()
    local currentTime = GetTime()
    local currentCast = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.wrathCount = Wrath.count
        gs.starfireCount = Starfire.count
        lastUpdateTime = currentTime
    end

    gs.activeEnemies = activeEnemies()

    gs.shouldAoE = gs.activeEnemies > 1 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gs.fightRemains = fightRemains()

    gs.astralPower = futureAstralPower()
    gs.astralPowerDeficit = player.lunarPowerMax - gs.astralPower

    gs.pool = A.GetToggle(2, "poolAsp") and gs.astralPowerDeficit > 20
    local consumingDreamstate = player:Buff(buffs.dreamstate) and gs.imCasting and (gs.imCasting == Wrath.id or gs.imCasting == Starfire.id)
    local dreamstateStacks = player:HasBuffCount(buffs.dreamstate) - num(consumingDreamstate)
    gs.dreamstate = not player.combat or dreamstateStacks >= 1 or gs.eclipse and gs.eclipseRemains < 8000

    gs.TWW1has2P = Player:HasTier("TWW1", 2)
    gs.TWW1has4P = Player:HasTier("TWW1", 4)

    gs.moonfireRefreshable = target:DebuffRemains(debuffs.moonfire, true) < 3000 and (target.ttd > 3000 or target.isDummy) and (not player:TalentKnown(TreantsOfTheMoon.id) or ForceOfNature.cd > 3000 and not player:Buff(buffs.harmonyOfTheGrove))
    gs.moonfireRefreshableAoE = target:DebuffRemains(debuffs.moonfire, true) < 5000 and (target.ttd > 5000 or target.isDummy)

    gs.sunfireRefreshable = target:DebuffRemains(debuffs.sunfire, true) < 3000 and (target.ttd > 3000 or target.isDummy)
    gs.sunfireRefreshableAoE = target:DebuffRemains(debuffs.sunfire, true) < 5000 and (target.ttd > 5000 or target.isDummy)

    gs.stellarFlareRefreshable = target:DebuffRemains(debuffs.stellarFlare, true) < 3000 and (target.ttd > 7000 or target.isDummy)

    gs.moonfireCount = enemiesInRange(debuffs.moonfire, 5000)
    gs.sunfireCount = enemiesInRange(debuffs.sunfire, 5000)

    gs.multidotMoonfireCount = enemiesWithDots(debuffs.moonfire, 5000)
    gs.multidotSunfireCount = (not player:TalentKnown(Sunfire.id) and 0) or enemiesWithDots(debuffs.sunfire, 5000)

    gs.enemiesTTD = enemiesTTD(5000)

    gs.enteringEclipse = gs.imCasting and (gs.imCasting == Wrath.id and gs.wrathCount == 1 or gs.imCasting == Starfire.id and gs.starfireCount == 1) or gs.cdCondition
    gs.eclipse = player:BuffRemains(buffs.lunarEclipse) > Wrath:CastTime() or player:BuffRemains(buffs.solarEclipse) > Starfire:CastTime() or gs.enteringEclipse
    gs.eclipseRemains = math.max(player:BuffRemains(buffs.lunarEclipse), player:BuffRemains(buffs.solarEclipse), num(gs.enteringEclipse) * 99999)
    gs.enterLunar = (player:TalentKnown(LunarCalling.id) or gs.activeEnemies > 3 - num(player:TalentKnown(UmbralIntensity.id) or player:TalentKnown(SoulOfTheForest.id)) and gs.shouldAoE)
    gs.hasSolar = (gs.imCasting and gs.imCasting == Starfire.id and gs.starfireCount == 1) or player:Buff(buffs.solarEclipse)
    gs.hasLunar = (gs.imCasting and gs.imCasting == Wrath.id and gs.wrathCount == 1) or player:Buff(buffs.lunarEclipse)

    gs.boatStacks = player:HasBuffCount(buffs.boatArcane) + player:HasBuffCount(buffs.boatNature)

    -- Approximate SimC variable.passive_asp = 6%spell_haste + talent.natures_balance (+ bounteous bloom/orbit breaker ignored)
    local maxGcdMS = MakuluFramework.maxGcd and MakuluFramework.maxGcd() or 1500
    local currGcdMS = MakuluFramework.gcd and MakuluFramework.gcd() or maxGcdMS
    local hasteMult = 1
    if maxGcdMS > 0 and currGcdMS > 0 then
        hasteMult = math.max(0.75, maxGcdMS / currGcdMS) -- clamp to reasonable floor
    end
    local passiveAsp = 6 * hasteMult
    if player:TalentKnown(NaturesBalance.id) then passiveAsp = passiveAsp + 1 end
    gs.passiveAsp = passiveAsp

    gs.noCdTalent = not player:TalentKnown(CelestialAlignment.id) and not player:TalentKnown(IncarnationChosenOfElune.id) or not shouldBurst()

    gs.caIncCD = CelestialAlignment.cd
    if player:TalentKnown(IncarnationChosenOfElune.id) then
        gs.caIncCD = IncarnationChosenOfElune.cd
    end

    gs.caIncFullRecharge = CelestialAlignment:TimeToFullCharges()
    if player:TalentKnown(IncarnationChosenOfElune.id) then
        gs.caIncFullRecharge = IncarnationChosenOfElune:TimeToFullCharges()
    end

    gs.caIncUp = player:Buff(buffs.celestialAlignment) or player:Buff(buffs.incarnation)

    gs.caEffectiveCd = math.min(gs.caIncCD, ForceOfNature.cd)

    gs.cdCon1 = (gs.inRaid and gs.fightRemains < (15 + (5 * player:TalentKnownInt(IncarnationChosenOfElune.id))) * (1 - player:TalentKnownInt(WhirlingStars.id) * 0.02) * 1000) or A.GetToggle(2, "bypassBurstRaid")
    gs.cdCon2 = gs.fightRemains > 10000 and (not player:TalentKnown(DreamSurge.id) or player:Buff(buffs.harmonyOfTheGrove)) and (not player:TalentKnown(WhirlingStars.id) or not player:TalentKnown(ConvokeTheSpirits.id) or ConvokeTheSpirits.cd < A.GetGCD() * 2000 or (gs.inRaid and gs.fightRemains < ConvokeTheSpirits.cd + 3000 or ConvokeTheSpirits.cd > gs.caIncFullRecharge))

    gs.cdCondition = shouldBurst() and gs.caIncCD < 700 and not gs.caIncUp and (gs.cdCon1 or gs.cdCon2)

    gs.convokeCondition = gs.inRaid and gs.fightRemains < 5000 or (gs.caIncUp or gs.caIncCD > 40000) and (not player:TalentKnown(DreamSurge.id) or player:Buff(buffs.harmonyOfTheGrove) or ForceOfNature.cd > 15000)
    -- KotG 11.2 detection and CA condition (approximate)
    gs.kotgActive = player:TalentKnown(DreamSurge.id)
    -- Prefer CA/Inc when usual cdCondition is met and Treants can align or Harmony is up
    local treantsSoon = ForceOfNature.cd < A.GetGCD() * 4000
    gs.kotgCaCondition = gs.kotgActive and shouldBurst() and not gs.caIncUp and (gs.cdCon1 or gs.cdCon2) and (treantsSoon or player:Buff(buffs.harmonyOfTheGrove) or gs.fightRemains < 15000)


    gs.wrathEnergize = 6 + (2 * player:TalentKnownInt(WildSurges.id)) + (2 * num(gs.TWW1has4P and gs.eclipse)) * (1.6 * num(gs.hasSolar))
    gs.starfireEnergize = 8 + ((2 * player:TalentKnownInt(WildSurges.id)) + (5 * num(gs.TWW1has4P and gs.eclipse)) + (2 * player:TalentKnownInt(MoonGuardian.id))) * (1.4 * num(gs.hasLunar))

    gs.synapse = C_Item.IsEquippedItem(168973)
    local _, synapseCooldown = GetItemCooldown(168973)
    gs.synapseNotReady = synapseCooldown > 0

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

SynapseEnhancer:Callback(function(spell)
    if not gs.synapse then return end
    if gs.synapseNotReady then return end

    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if A.GetToggle(2, "syncFoECA") and player:TalentKnown(FuryOfElune.id) then
        if FuryOfElune.used > 8000 then return end
    end

    if not gs.cdCondition then return end

    return spell:Cast()
end)

MarkOfTheWild:Callback('PreCombat1', function(spell)
    if not NeedRaidBuff(MarkOfTheWild) then return end
    return Debounce("raidbuff", 1000, 2500, spell, player)
end)

Soothe:Callback(function(spell)
    if A.Zone == "arena" then return end

    if A.AuraIsValid("target", "UseExpelEnrage", "Enrage") or target.enraged then
        return spell:Cast()
    end
end)

Renewal:Callback(function(spell)
    if not player.combat then return end

    if player.hp < A.GetToggle(2, "RenewalHP") then
        return spell:Cast()
    end
end)

BearForm:Callback(function(spell)
    if not A.GetToggle(2, "autoShift") then return end
    local autoForm = A.GetToggle(2, "autoForms")
    if not autoForm[2] then return end
    if player:Buff(buffs.bearForm) then return end
    if gs.caIncUp then return end

    if LoC:Get("ROOT") > 0 then
        return spell:Cast()
    end

    if A.GetToggle(2, "lycarasMeditation") then
        if not player.combat and player:TalentKnown(FluidForm.id) and player:TalentKnown(LycarasMeditation.id) then
            return spell:Cast()
        end
    end

    if player.ehp < A.GetToggle(2, "frenziedRegenHP") and FrenziedRegeneration.cd < 500 and (Renewal.cd > 500 or not player:TalentKnown(Renewal.id)) then
        return spell:Cast()
    end
end)

Barkskin:Callback(function(spell)
    if not player.combat then return end

    if shouldDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "BarkskinHP") then
        return spell:Cast()
    end
end)

NaturesVigil:Callback(function(spell)
    if shouldDefensive() then
        return spell:Cast()
    end
end)

Berserking:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if not gs.cdCondition then return end

    return spell:Cast(target)
end)

MoonkinForm:Callback(function(spell)
    if not A.GetToggle(2, "autoShift") then return end
    local autoForm = A.GetToggle(2, "autoForms")
    if not autoForm[1] then return end

    if player:Buff(buffs.moonkinForm) then return end
    if A.Zone == "arena" and player:Buff(buffs.bearForm) then return end
    if player:Buff(buffs.travelForm) then return end

    if A.GetToggle(2, "lycarasMeditation") then
        if not player.combat and player:TalentKnown(FluidForm.id) and player:TalentKnown(LycarasMeditation.id) then
            return
        end
    end

    return spell:Cast()
end)

Wrath:Callback("pre", function(spell)
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 2 then return end

    if gs.eclipse and player.inCombat then return end
    if player.inCombat and player.combatTime > 2 then return end
    if gs.imCasting and gs.imCasting == Starfire.id then return end

    return spell:Cast(target)
end)

StellarFlare:Callback("pre", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if player.inCombat and player.combatTime > 2 then return end
    if gs.imCasting and gs.imCasting == Wrath.id or Player:PrevGCD(1, A.Wrath) then
        return spell:Cast(target)
    end
end)

Starfire:Callback("pre", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if player.inCombat and player.combatTime > 2 then return end
    if gs.imCasting and gs.imCasting == Wrath.id or Player:PrevGCD(1, A.Wrath) then
        return spell:Cast(target)
    end
end)

local function preCd()
    SynapseEnhancer()
    Berserking()
    -- Use trinkets whenever burst is toggled on
    if shouldBurst() then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
end

--Moving

Moonfire:Callback("moving", function(spell)
    if not A.GetToggle(2, "dotsMoving") then return end

    if player:TalentKnown(Lunation.id) then
        return spell:Cast(target)
    else
        if spell.used > Sunfire.used then
            return spell:Cast(target)
        end
    end
end)

Sunfire:Callback("moving", function(spell)
    if not A.GetToggle(2, "dotsMoving") then return end
    if spell.used < Moonfire.used then return end

    return spell:Cast(target)
end)

local function moving()
    Moonfire("moving")
    Sunfire("moving")
end

--actions.aoe=wrath,if=variable.enter_lunar&variable.eclipse&variable.eclipse_remains<cast_time
Wrath:Callback("aoe", function(spell)
    if not gs.enterLunar then return end
    if not gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/starfire,if=!variable.enter_lunar&variable.eclipse&variable.eclipse_remains<cast_time
Starfire:Callback("aoe", function(spell)
    if gs.enterLunar then return end
    if not gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/starfall,if=astral_power.deficit<=variable.passive_asp+6
Starfall:Callback("aoe", function(spell)
    if gs.pool then return end

    if gs.astralPowerDeficit <= gs.passiveAsp + 6 then
        return spell:Cast()
    end
end)

-- actions.aoe+=/moonfire,target_if=refreshable&(target.time_to_die-remains)>6&(!talent.treants_of_the_moon|spell_targets-active_dot.moonfire_dmg>6|cooldown.force_of_nature.remains>3&!buff.harmony_of_the_grove.up)
Moonfire:Callback("aoe", function(spell)
    if not gs.moonfireRefreshableAoE then return end

    if not player:TalentKnown(TreantsOfTheMoon.id) then
        return spell:Cast(target)
    end

    if gs.activeEnemies - gs.moonfireCount > 6 then
        return spell:Cast(target)
    end

    if ForceOfNature.cd > 3000 and not player:Buff(buffs.harmonyOfTheGrove) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/sunfire,target_if=refreshable&(target.time_to_die-remains)>6-(spell_targets%2)
Sunfire:Callback("aoe", function(spell)
    if not gs.sunfireRefreshableAoE then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/wrath,if=variable.enter_lunar&(!variable.eclipse|variable.eclipse_remains<cast_time)
Wrath:Callback("aoe2", function(spell)
    if not gs.enterLunar then return end
    if gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)
-- actions.aoe+=/starfire,if=!variable.enter_lunar&(!variable.eclipse|variable.eclipse_remains<cast_time)
Starfire:Callback("aoe2", function(spell)
    if gs.enterLunar then return end
    if gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/stellar_flare,target_if=refreshable&(target.time_to_die-remains-target>7+spell_targets),if=spell_targets<(11-talent.umbral_intensity.rank-(2*talent.astral_smolder)-talent.lunar_calling)
StellarFlare:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.stellarFlareRefreshable then return end

    if gs.activeEnemies < (11 - player:TalentKnownInt(UmbralIntensity.id) - (2 * player:TalentKnownInt(AstralSmolder.id)) - player:TalentKnownInt(LunarCalling.id)) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/force_of_nature,if=cooldown.ca_inc.remains<gcd.max&(!variable.eclipse|variable.eclipse_remains>6)|variable.eclipse_remains>=3&cooldown.ca_inc.remains>10+15*talent.control_of_the_dream&(fight_remains>cooldown+5|cooldown.ca_inc.remains>fight_remains)
ForceOfNature:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if gs.caIncCD < A.GetGCD() * 1000 and (not gs.eclipse or gs.eclipseRemains > 6000) then
        return spell:Cast()
    end

    if gs.eclipseRemains >= 3000 and gs.caIncCD > 10000 + 15000 * player:TalentKnownInt(ControlOfTheDream.id) and (gs.fightRemains > 65000 or gs.caIncCD > gs.fightRemains) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/fury_of_elune,if=variable.eclipse
FuryOfElune:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if not gs.eclipse then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/celestial_alignment,if=variable.cd_condition
CelestialAlignment:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end
    -- If already have elune buff don't reuse
    if player:Buff(202425) then return end
    if player:Buff(102560) then return end

    if A.GetToggle(2, "syncFoECA") and player:TalentKnown(FuryOfElune.id) then
        if FuryOfElune.used > 8000 then return end
    end

    if not gs.cdCondition then return end

    return spell:Cast()
end)

-- actions.aoe+=/incarnation,if=variable.cd_condition
IncarnationChosenOfElune:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    -- If already have elune buff don't reuse
    if player:Buff(202425) then return end
    if player:Buff(102560) then return end

    if A.GetToggle(2, "syncFoECA") and player:TalentKnown(FuryOfElune.id) then
        if FuryOfElune.used > 8000 then return end
    end

    if not gs.cdCondition then return end


    return spell:Cast()
end)

-- actions.aoe+=/warrior_of_elune,if=!talent.lunar_calling&buff.eclipse_solar.remains<7|talent.lunar_calling
WarriorOfElune:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not player.inCombat then return end
    if gs.cdCondition then return end

    -- SimC AoE: !talent.lunar_calling & buff.eclipse_solar.remains<7 | talent.lunar_calling & !buff.dreamstate.up
    local shouldCast = false
    if not player:TalentKnown(LunarCalling.id) then
        shouldCast = player:BuffRemains(buffs.solarEclipse) < 7000
    else
        shouldCast = not player:Buff(buffs.dreamstate)
    end

    if not shouldCast then return end

    return spell:Cast()
end)

-- actions.aoe+=/starfall,if=buff.starweavers_warp.up|buff.touch_the_cosmos.up
Starfall:Callback("aoe2", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if player:Buff(buffs.starweaversWarp) then
        return spell:Cast(player)
    end

    if player:Buff(buffs.touchTheCosmos) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/starsurge,if=buff.starweavers_weft.up
Starsurge:Callback("aoe", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if not player:Buff(buffs.starweaversWeft) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/starfall
Starfall:Callback("aoe3", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    return spell:Cast()
end)

-- actions.aoe+=/convoke_the_spirits,if=(!buff.dreamstate.up&!buff.umbral_embrace.up&spell_targets.starfire<7|spell_targets.starfire=1)&(fight_remains<5|(buff.ca_inc.up|cooldown.ca_inc.remains>40)&(!hero_tree.keeper_of_the_grove|buff.harmony_of_the_grove.up|cooldown.force_of_nature.remains>15))
ConvokeTheSpirits:Callback("aoe", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if (not gs.dreamstate and not player:Buff(buffs.umbralEmbrace) and gs.activeEnemies < 7 or gs.activeEnemies == 1) and (gs.fightRemains < 5000 or (gs.caIncUp or gs.caIncCD > 40000) and (not player:TalentKnown(DreamSurge.id) or player:Buff(buffs.harmonyOfTheGrove) or ForceOfNature.cd > 15000)) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/new_moon
NewMoon:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    local newMoonReady = C_Spell.GetSpellTexture(274281) == 1392545
    if not newMoonReady then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/half_moon
HalfMoon:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    local halfMoonReady = C_Spell.GetSpellTexture(274281) == 1392543
    if not halfMoonReady then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/full_moon
FullMoon:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    local fullMoonReady = C_Spell.GetSpellTexture(274281) == 1392542
    if not fullMoonReady then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/wild_mushroom,if=!prev_gcd.1.wild_mushroom&!dot.fungal_growth.ticking
WildMushroom:Callback("aoe", function(spell)
    if Player:PrevGCD(1, A.WildMushroom) then return end
    if target:Debuff(debuffs.fungalGrowth, true) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/force_of_nature,if=!hero_tree.keeper_of_the_grove
ForceOfNature:Callback("aoe2", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if player:TalentKnown(DreamSurge.id) then return end

    return spell:Cast(player)
end)

-- actions.aoe+=/starfire,if=talent.lunar_calling|buff.eclipse_lunar.up&spell_targets.starfire>3-(talent.umbral_intensity|talent.soul_of_the_forest)
Starfire:Callback("aoe3", function(spell)
    if not player:TalentKnown(LunarCalling.id) then
        if not gs.hasLunar then return end
        if gs.activeEnemies <= 3 - num(player:TalentKnown(UmbralIntensity.id) or player:TalentKnown(SoulOfTheForest.id)) then return end
    end

    return spell:Cast(target)
end)

-- actions.aoe+=/wrath
Wrath:Callback("aoe3", function(spell)

    return spell:Cast(target)
end)

local function aoe()
    Wrath("aoe")
    Starfire("aoe")
    Starfall("aoe")
    Moonfire("aoe")
    Sunfire("aoe")
    Wrath("aoe2")
    Starfire("aoe2")
    StellarFlare("aoe")
    ForceOfNature("aoe")
    FuryOfElune("aoe")
    preCd()
    CelestialAlignment("aoe")
    IncarnationChosenOfElune("aoe")
    WarriorOfElune("aoe")
    Starfall("aoe2")
    Starsurge("aoe")
    Starfall("aoe3")
    ConvokeTheSpirits("aoe")
    NewMoon("aoe")
    HalfMoon("aoe")
    FullMoon("aoe")
    WildMushroom("aoe")
    ForceOfNature("aoe2")
    Starfire("aoe3")
    Wrath("aoe3")
end

--actions.st=warrior_of_elune,if=talent.lunar_calling|!talent.lunar_calling&variable.eclipse_remains<=7
WarriorOfElune:Callback(function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not player.inCombat then return end
    if gs.cdCondition then return end

    -- SimC ST: talent.lunar_calling | (!talent.lunar_calling & variable.eclipse_remains<=7)
    local shouldCast = false
    if player:TalentKnown(LunarCalling.id) then
        shouldCast = true
    else
        shouldCast = gs.eclipseRemains <= 7000
    end

    if not shouldCast then return end

    return spell:Cast()
end)

--actions.st=wrath,if=variable.enter_lunar&variable.eclipse&variable.eclipse_remains<cast_time&!variable.cd_condition
Wrath:Callback("st", function(spell)
    if not gs.enterLunar then return end
    if not gs.eclipse then return end
    if gs.eclipseRemains > spell:CastTime() then return end
    if gs.cdCondition then return end

    return spell:Cast(target)
end)

-- actions.st+=/starfire,if=!variable.enter_lunar&variable.eclipse&variable.eclipse_remains<cast_time&!variable.cd_condition
Starfire:Callback("st", function(spell)
    if gs.enterLunar then return end
    if not gs.eclipse then return end
    if gs.eclipseRemains > spell:CastTime() then return end
    if gs.cdCondition then return end

    return spell:Cast(target)
end)

-- actions.st+=/moonfire,target_if=remains<3&(!talent.treants_of_the_moon|cooldown.force_of_nature.remains>3&!buff.harmony_of_the_grove.up)
Moonfire:Callback("st", function(spell) -- Swap Moonfire and Sunfire priority to give tank chance to group
    if not gs.moonfireRefreshable then return end

    if not player:TalentKnown(TreantsOfTheMoon.id) then
        return spell:Cast(target)
    end

    if ForceOfNature.cd > 3000 and not player:Buff(buffs.harmonyOfTheGrove) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/sunfire,target_if=remains<3
Sunfire:Callback("st", function(spell)
    -- Always refresh at low remaining duration
    if gs.sunfireRefreshable then
        return spell:Cast(target)
    end

    -- Early refresh to align with upcoming CDs or Treants windows (approximate SimC refreshable logic)
    local earlyRefresh = false
    if gs.sunfireRefreshableAoE then
        -- Keeper of the Grove surrogate: DreamSurge talent indicates Keeper hero tree in this framework
        if player:TalentKnown(DreamSurge.id) and ForceOfNature.cd < A.GetGCD() * 1000 then
            earlyRefresh = true
        end
        -- Elune's Chosen surrogate: refresh before CDs
        if gs.cdCondition then
            earlyRefresh = true
        end
    end

    if not earlyRefresh then return end

    return spell:Cast(target)
end)

-- actions.st+=/celestial_alignment,if=variable.cd_condition
CelestialAlignment:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    -- If already have elune buff don't reuse
    if player:Buff(202425) then return end
    if player:Buff(102560) then return end

    if A.GetToggle(2, "syncFoECA") and player:TalentKnown(FuryOfElune.id) then
        if FuryOfElune.used > 8000 then return end
    end

    if not gs.cdCondition then return end

    return spell:Cast()
end)

-- actions.st+=/incarnation,if=variable.cd_condition
IncarnationChosenOfElune:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    -- If already have elune buff don't reuse
    if player:Buff(202425) then return end
    if player:Buff(102560) then return end

    if A.GetToggle(2, "syncFoECA") and player:TalentKnown(FuryOfElune.id) then
        if FuryOfElune.used > 8000 then return end
    end

    if not gs.cdCondition then return end

    return spell:Cast()
end)

-- actions.st+=/wrath,if=variable.enter_lunar&(!variable.eclipse|variable.eclipse_remains<cast_time)
Wrath:Callback("st2", function(spell)
    if not gs.enterLunar then return end
    if gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.st+=/starfire,if=!variable.enter_lunar&(!variable.eclipse|variable.eclipse_remains<cast_time)
Starfire:Callback("st2", function(spell)
    if gs.enterLunar then return end
    if gs.eclipse then return end
    if gs.eclipseRemains >= spell:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.st+=/starsurge,if=variable.cd_condition&astral_power.deficit>variable.passive_asp+action.force_of_nature.energize_amount
Starsurge:Callback("st", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if not gs.cdCondition then return end
    -- SimC: cast if astral_power.deficit > passive_asp + action.force_of_nature.energize_amount (20)
    if gs.astralPowerDeficit <= gs.passiveAsp + 20 then return end

    if gs.pool then return end

    return spell:Cast(target)
end)

-- actions.st+=/force_of_nature,if=cooldown.ca_inc.remains<gcd.max&(!talent.convoke_the_spirits|cooldown.convoke_the_spirits.remains<gcd.max*3|cooldown.convoke_the_spirits.remains>cooldown.ca_inc.full_recharge_time|fight_remains<cooldown.convoke_the_spirits.remains+3)|cooldown.ca_inc.full_recharge_time+5+15*talent.control_of_the_dream>cooldown&(!talent.convoke_the_spirits|cooldown.convoke_the_spirits.remains+10+15*talent.control_of_the_dream>cooldown|fight_remains<cooldown.convoke_the_spirits.remains+cooldown.convoke_the_spirits.duration+5)&(fight_remains>cooldown+5|fight_remains<cooldown.ca_inc.remains+7)|talent.whirling_stars&talent.convoke_the_spirits&cooldown.convoke_the_spirits.remains>cooldown.force_of_nature.duration-10&fight_remains>cooldown.convoke_the_spirits.remains+6
ForceOfNature:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if gs.caIncCD < A.GetGCD() * 1000 and (not player:TalentKnown(ConvokeTheSpirits.id) or ConvokeTheSpirits.cd < A.GetGCD() * 3000 or ConvokeTheSpirits.cd > gs.caIncFullRecharge or gs.fightRemains < ConvokeTheSpirits.cd + 3000) then
        return spell:Cast()
    end

    if gs.caIncFullRecharge + 5000 + 15000 * player:TalentKnownInt(ControlOfTheDream.id) > 60000 and (not player:TalentKnown(ConvokeTheSpirits.id) or ConvokeTheSpirits.cd + 10000 + 15000 * player:TalentKnownInt(ControlOfTheDream.id) > 60000 or gs.fightRemains < ConvokeTheSpirits.cd + 5000 + 60000 + (60000 * player:TalentKnownInt(ElunesGuidance.id))) and (gs.fightRemains > 65000 or gs.fightRemains < gs.caIncCD + 7000) then
        return spell:Cast()
    end

    if player:TalentKnown(WhirlingStars.id) and player:TalentKnown(ConvokeTheSpirits.id) and ConvokeTheSpirits.cd > 50 and gs.fightRemains > ConvokeTheSpirits.cd + 6000 then
        return spell:Cast()
    end
end)

-- actions.st+=/fury_of_elune,if=5+variable.passive_asp<astral_power.deficit
FuryOfElune:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if gs.passiveAsp + 5 > gs.astralPowerDeficit then return end

    return spell:Cast(target)
end)

-- actions.st+=/starfall,if=buff.starweavers_warp.up
Starfall:Callback("st", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if not player:Buff(buffs.starweaversWarp) then return end

    return spell:Cast()
end)

-- actions.st+=/starsurge,if=talent.starlord&buff.starlord.stack<3
Starsurge:Callback("st2", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if not player:TalentKnown(Starlord.id) then return end
    if player:HasBuffCount(buffs.starlord) >= 3 then return end

    return spell:Cast(target)
end)

-- actions.st+=/stellar_flare,target_if=refreshable&(target.time_to_die-remains-target>7+spell_targets)
StellarFlare:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.stellarFlareRefreshable then return end

    return spell:Cast(target)
end)

-- actions.st+=/starsurge,if=cooldown.convoke_the_spirits.remains<gcd.max*2&variable.convoke_condition
Starsurge:Callback("st3", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if ConvokeTheSpirits.cd >= A.GetGCD() * 2000 then return end
    if not gs.convokeCondition then return end

    return spell:Cast(target)
end)

-- actions.st+=/convoke_the_spirits,if=variable.convoke_condition
ConvokeTheSpirits:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if not gs.convokeCondition then return end

    return spell:Cast()
end)

-- actions.st+=/starsurge,if=buff.starlord.remains>4&variable.boat_stacks>=3|fight_remains<4
Starsurge:Callback("st4", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if gs.fightRemains < 4000 then
        return spell:Cast(target)
    end

    if player:BuffRemains(buffs.starlord) > 4000 and gs.boatStacks >= 3 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/new_moon,if=astral_power.deficit>variable.passive_asp+energize_amount|fight_remains<20|cooldown.ca_inc.remains>15
NewMoon:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    local newMoonReady = C_Spell.GetSpellTexture(274281) == 1392545
    if not newMoonReady then return end

    if gs.astralPowerDeficit > gs.passiveAsp + 10 then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20 then
        return spell:Cast(target)
    end

    if gs.caIncCD > 15000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/half_moon,if=astral_power.deficit>variable.passive_asp+energize_amount&(buff.eclipse_lunar.remains>execute_time|buff.eclipse_solar.remains>execute_time)|fight_remains<20|cooldown.ca_inc.remains>15
HalfMoon:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    local halfMoonReady = C_Spell.GetSpellTexture(274281) == 1392543
    if not halfMoonReady then return end

    if gs.astralPowerDeficit > gs.passiveAsp + 20 and (gs.eclipseRemains > spell:CastTime()) then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20 then
        return spell:Cast(target)
    end

    if gs.caIncCD > 15000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/full_moon,if=astral_power.deficit>variable.passive_asp+energize_amount&(buff.eclipse_lunar.remains>execute_time|buff.eclipse_solar.remains>execute_time)|fight_remains<20|cooldown.ca_inc.remains>15
FullMoon:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    local fullMoonReady = C_Spell.GetSpellTexture(274281) == 1392542
    if not fullMoonReady then return end

    if gs.astralPowerDeficit > gs.passiveAsp + 40 and (gs.eclipseRemains > spell:CastTime()) then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20 then
        return spell:Cast(target)
    end

    if gs.caIncCD > 15000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/starsurge,if=buff.starweavers_weft.up|buff.touch_the_cosmos.up
-- actions.st+=/starsurge,if=astral_power.deficit<variable.passive_asp+action.wrath.energize_amount+(action.starfire.energize_amount+variable.passive_asp)*(buff.eclipse_solar.remains<(gcd.max*3))
Starsurge:Callback("st5", function(spell)
    if gs.astralPower < spell:Cost() then return end

    if gs.pool then return end

    if player:Buff(buffs.starweaversWeft) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.touchTheCosmos) then
        return spell:Cast(target)
    end

    if gs.astralPowerDeficit < gs.passiveAsp + gs.wrathEnergize + (gs.starfireEnergize + gs.passiveAsp) * (num(player:BuffRemains(buffs.solarEclipse) < A.GetGCD() * 3000)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/force_of_nature,if=!hero_tree.keeper_of_the_grove
ForceOfNature:Callback("st2", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if player:TalentKnown(DreamSurge.id) then return end

    return spell:Cast()
end)

-- actions.st+=/wild_mushroom
WildMushroom:Callback("st", function(spell)

    return spell:Cast(target)
end)

-- actions.st+=/starfire,if=talent.lunar_calling
Starfire:Callback("st3", function(spell)
    if not player:TalentKnown(LunarCalling.id) then return end

    return spell:Cast(target)
end)

local function kotg_pre_cd()
    -- Lightweight: honor your existing preCd() for trinkets; just arm FoE if good
    if gs.kotgActive and gs.kotgCaCondition then
        FuryOfElune("st")
    end
end

local function kotg_st()
    -- WoE as opener when appropriate
    WarriorOfElune()

    -- Enter eclipse at tail-end
    Wrath("st")
    Starfire("st")

    -- Dots
    Sunfire("st")
    Moonfire("st")

    -- KotG pre-cd alignment then CDs
    kotg_pre_cd()
    if gs.kotgCaCondition then
        CelestialAlignment("st")
        IncarnationChosenOfElune("st")
    end

    -- Spend/build
    Wrath("st2")
    Starfire("st2")

    -- AP spenders and utility follow base priorities
    Starsurge("st")
    ForceOfNature("st")
    FuryOfElune("st")
    Starfall("st")
    Starsurge("st2")
    StellarFlare("st")
    Starsurge("st3")
    ConvokeTheSpirits("st")
    Starsurge("st4")
    NewMoon("st")
    HalfMoon("st")
    FullMoon("st")
    Starsurge("st5")
    ForceOfNature("st2")
    WildMushroom("st")
    Starfire("st3")
    Wrath("st3")
end

-- actions.st+=/wrath
Wrath:Callback("st3", function(spell)

    return spell:Cast(target)
end)

local function st()
    -- SimC ST begins with Warrior of Elune
    WarriorOfElune()

    Wrath("st")
    Starfire("st")
    -- SimC: Sunfire before Moonfire in ST
    Sunfire("st")
    Moonfire("st")
    preCd()
    CelestialAlignment("st")
    IncarnationChosenOfElune("st")
    Wrath("st2")
    Starfire("st2")
    Starsurge("st")
    ForceOfNature("st")
    FuryOfElune("st")
    Starfall("st")
    Starsurge("st2")
    StellarFlare("st")
    Starsurge("st3")
    ConvokeTheSpirits("st")
    Starsurge("st4")
    NewMoon("st")
    HalfMoon("st")
    FullMoon("st")
    Starsurge("st5")
    ForceOfNature("st2")
    WildMushroom("st")
    Starfire("st3")
    Wrath("st3")
end

FrenziedRegeneration:Callback("pvp", function(spell)
    if player:Buff(buffs.frenziedRegeneration) then return end
    if not player:Buff(buffs.bearForm) then return end
    if player.ehp > A.GetToggle(2, "frenziedRegenHP") then return end

    return spell:Cast()
end)

BearForm:Callback("pvp", function(spell)
    if not A.GetToggle(2, "autoShift") then return end
    local autoForm = A.GetToggle(2, "autoForms")
    if not autoForm[2] then return end

    if player:Buff(buffs.bearForm) then return end
    if player.hp > 40 and (gs.sunfireRefreshable or gs.moonfireRefreshable) then return end
    if gs.caIncCD < 500 then return end
    if gs.caIncUp then return end

    if ActionUnit(player:CallerId()):IsFocused("MELEE", true, true) and player.hp < 60 then
        return spell:Cast()
    end

    if player.hp < 50 and FrenziedRegeneration.cd < 500 then
        return spell:Cast()
    end

    if player.hp < 30 then
        return spell:Cast()
    end
end)

MoonkinForm:Callback("pvp", function(spell)
    if not A.GetToggle(2, "autoShift") then return end
    local autoForm = A.GetToggle(2, "autoForms")
    if not autoForm[1] then return end

    if player:Buff(buffs.moonkinForm) then return end
    if player:Buff(buffs.bearForm) then
        if player.hp < 30 then return end
        if ActionUnit(player:CallerId()):IsFocused("MELEE", true, true) and player.hp < 70 then return end
        if player.hp < 50 and FrenziedRegeneration.cd < 500 then return end
        if player:Buff(buffs.frenziedRegeneration) then return end

        if player.hp > 80 or (player.hp > 50 and FrenziedRegeneration.cd > 1000) then
            return spell:Cast()
        end
    end

    if not player:Buff(buffs.bearForm) and not player:Buff(buffs.travelForm) then
        return spell:Cast()
    end
end)

Moonfire:Callback("pvp", function(spell)
    if not target.exists then return end
    if not target.canAttack then return end
    if gs.caIncUp then return end
    if target:DebuffPandemic(debuffs.moonfire) or (target:DebuffRemains(debuffs.moonfire, true) < 10000 and gs.caIncCD < 1000) then
        return spell:Cast(target)
    end
end)

Sunfire:Callback("pvp", function(spell)
    if not target.exists then return end
    if not target.canAttack then return end
    if gs.caIncUp then return end

    if target:DebuffPandemic(debuffs.sunfire) or (target:DebuffRemains(debuffs.sunfire, true) < 10000 and gs.caIncCD < 1000) then
        return spell:Cast(target)
    end
end)

WildMushroom:Callback("pvp", function(spell)
    if not player:TalentKnown(WaningTwilight.id) then return end
    if gs.caIncUp then return end
    if Player:PrevGCD(1, A.WildMushroom) then return end
    if target:DebuffRemains(debuffs.waningTwilight, true) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

Starsurge:Callback("pvp", function(spell)
    if not target.exists then return end
    if not target.canAttack then return end
    if gs.astralPower < spell:Cost() then return end
    if target.hp < 40 then
        return spell:Cast(target)
    end
end)

Starfire:Callback("pvp", function(spell)
    if not target.exists then return end
    if not target.canAttack then return end
    if gs.caIncCD < 500 then return end
    if spell:CastTime() > Wrath:CastTime() then return end

    return spell:Cast(target)
end)

Wrath:Callback("pvp", function(spell)
    if not target.exists then return end
    if not target.canAttack then return end
    if gs.caIncCD < 500 then return end
    if gs.eclipse then return end

    return spell:Cast(target)
end)

local function pvpenis()
    BearForm("pvp")
    MoonkinForm("pvp")
    Moonfire("pvp")
    Sunfire("pvp")
    WildMushroom("pvp")
    Starsurge("pvp")
    Starfire("pvp")
    Wrath("pvp")
end

Rebirth:Callback("pve", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if mouseover.isPet then return end

    return spell:Cast()
end)

Revive:Callback("pve", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if mouseover.isPet then return end

    return spell:Cast()
end)

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    
	FrameworkStart(icon)
    updateGameState()

    local awareAlert = A.GetToggle(2, "makAware")

    if awareAlert[1] and player.inCombat and player:TalentKnown(ForceOfNature.id) and ForceOfNature.cd < 2500 then
        Aware:displayMessage("FORCE OF NATURE SOON!", "Green", 1)
    end

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Astral Power: ", gs.astralPower)
        MakPrint(2, "Should CDs: ", gs.cdCondition)
        MakPrint(3, "Should Convoke: ", gs.convokeCondition)
        MakPrint(4, "Entering Eclipse: ", gs.enteringEclipse)
        MakPrint(5, "Should Convoke: ", gs.convokeCondition)
        MakPrint(6, "No CD Talent: ", gs.noCdTalent)
        MakPrint(7, "Moonfire Count: ", gs.multidotMoonfireCount)
        MakPrint(8, "Sunfire Count: ", gs.multidotSunfireCount)
        MakPrint(9, "target ttd: ", target.ttd)
        MakPrint(10, "CA Inc Up: ", gs.caIncUp)
        MakPrint(11, "CA Inc CD: ", gs.caIncCD)
        MakPrint(12, "Dreamstate: ", gs.dreamstate)
    end

    if player.channeling then return end
    makInterrupt(interrupts)

    if Action.Zone == "arena" and A.GetToggle(2, "fakeCasting") then
        FakeCasting.gglFakeCast(icon)
    end

    FrenziedRegeneration("pvp") -- have this available to pve if wanted

    if player:Buff(buffs.bearForm) and player:Buff(buffs.frenziedRegeneration) and player.ehp < 85 then return FrameworkEnd() end
    if A.GetToggle(2, "stayInBear") and player:Buff(buffs.bearForm) then return FrameworkEnd() end

    MarkOfTheWild("PreCombat1")

    if A.GetToggle(2, "dontBreakStealth") and player.stealthed then return FrameworkEnd() end

    BearForm()
    MoonkinForm()
    Renewal()
    Barkskin()
    NaturesVigil()
    Rebirth("pve")
    Revive("pve")

    if A.Zone == "arena" then
        pvpenis()
    end

    if target.exists and target.canAttack and Moonfire:InRange(target) then
        Soothe()
        Wrath("pre")
        WarriorOfElune()
        StellarFlare("pre")
        Starfire("pre")

        local damagePotion = Action.GetToggle(2, "damagePotion")
        local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
        local potionExhausted = Action.GetToggle(2, "potionExhausted")
        local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
        local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

        if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() >= potionExhaustedSlider * 60000) or not potionLustOnly) then
            local shouldPot = gs.cdCondition
            if shouldPot then
                return damagePotionObject:Show(icon)
            end
        end

        if gs.activeEnemies > 1 and gs.shouldAoE then
            aoe()
        else
            if gs.kotgActive then
                kotg_st()
            else
                st()
            end
        end
        moving()
    end

	return FrameworkEnd()
end

RemoveCorruption:Callback("pve", function(spell, friendly)
    local imCursed = player.cursed
    local imPoisoned = player.poisoned
    local shouldDispel = friendly.cursed or friendly.poisoned

    if player:Buff(buffs.bearForm) then return end
    --Hopefully this makes it self prio
    if imCursed or imPoisoned then
        if not friendly.isMe then return end
    end

    if not shouldDispel then return end

    return Debounce("cleanse", 600, 1500, spell, friendly)
end)

SolarBeam:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if not unit:Debuff(debuffs.massEntanglement) then return end

    local healerAlive  = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy.isHealer and enemy.hp > 0 end)
    if healerAlive and unit.isHealer or not healerAlive then
        return spell:Cast(unit)
    end
end)

MassEntanglement:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if unit:CCRemains() > 500 then return end
    if SolarBeam.cd > 500 then return end
    if unit.ccImmune then return end
    if unit.totalImmune then return end
    if unit.magicImmune then return end
    if unit.rootDr < 0.5 then return end

    if gs.caIncCD < 500 or gs.caIncUp or FuryOfElune.used < 8000 then
        if target.hp > 0 and target.hp < 70 then
            local healerAlive = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy.isHealer and enemy.hp > 0 end)
            if healerAlive then
                if unit.isHealer and not unit.isTarget then
                    Aware:displayMessage("USING ROOT BEAM ON HEALER", "Green", 3)
                    return spell:Cast(unit)
                end
            else
                -- Classes: Paladin (2), Priest (5), Mage (8), Warlock (9), Evoker (13)
                local nonHealerClass = unit:ClassID() == 2 or unit:ClassID() == 5 or unit:ClassID() == 8 or unit:ClassID() == 9 or unit:ClassID() == 13
                if nonHealerClass and unit.casting then
                    Aware:displayMessage("USING ROOT BEAM ON DPS", "Green", 3)
                    return spell:Cast(unit)
                end
            end
        end
    end

    if target.hp > 0 and target.hp < 40 then
    local healerAlive = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy.isHealer and enemy.hp > 0 end)
        if healerAlive then
            if unit.isHealer and not unit.isTarget then
                Aware:displayMessage("USING ROOT BEAM ON HEALER", "Green", 3)
                return spell:Cast(unit)
            end
        else
            -- Classes: Paladin (2), Priest (5), Mage (8), Warlock (9), Evoker (13)
            local nonHealerClass = unit:ClassID() == 2 or unit:ClassID() == 5 or unit:ClassID() == 8 or unit:ClassID() == 9 or unit:ClassID() == 13
            if nonHealerClass and unit.casting then
                Aware:displayMessage("USING ROOT BEAM ON DPS", "Green", 3)
                return spell:Cast(unit)
            end
        end
    end

end)

FaerieSwarm:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if unit.totalImmune then return end
    if unit:Buff(446035) then return end
    if not unit:HasBuffFromFor(MakLists.Disarm, 500) then return end
    Aware:displayMessage("Faerie Swarm on Bursting", "White", 1)
    return spell:Cast(unit)
end)

MightyBash:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if unit:CCRemains() > 500 then return end
    if unit.ccImmune then return end
    if unit.totalImmune then return end
    if unit.physicalImmune then return end
    if unit.stunDr < 0.5 then return end

    local healerAlive = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy.isHealer and enemy.hp > 0 end)
    if healerAlive and unit.isHealer then
        if gs.caIncCD < 7000 or gs.caIncUp or FuryOfElune.used < 8000 then
            Aware:displayMessage("BASHING HEALER!", "WHITE", 1)
            spell:Cast(unit)
        end
    else
        if target.hp > 0 and target.hp < 55 then
            spell:Cast(unit)
        end
    end
end)

Cyclone:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if unit:CCRemains() > spell:CastTime() then return end
    if unit.ccImmune then return end
    if unit.totalImmune then return end
    if unit.magicImmune then return end
    if unit.isTarget then return end

    if gs.imCasting and gs.imCasting == spell.id then return end

    local cycloneActive = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy:DebuffRemains(debuffs.cyclone, true) > Cyclone:CastTime() end)
    if cycloneActive then return end

    if gs.caIncCD < 7000 or (gs.caIncUp and gs.astralPowerDeficit > 20) or FuryOfElune.used < 8000 then
        local healerAlive = MakMulti.arena:Any(function(enemy) return enemy.exists and enemy.isHealer and enemy.hp > 0 and enemy.disorientDr >= 0.5 end)
        if healerAlive then
            if unit.isHealer then
                Aware:displayMessage("CYCLONE HEALER!", "WHITE", 1)
                spell:Cast(unit)
            end
        else
            if unit.hp > 30 and unit.disorientDr >= 0.5 then
                Aware:displayMessage("CYCLONE OFF-DPS!", "WHITE", 1)
                spell:Cast(unit)
            end
        end
    end
end)

Moonfire:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if not player:Buff(buffs.moonkinForm) then return end
    if unit.bcc then return end
    if unit.magicImmune then return end
    if unit.totalImmune then return end
    if gs.caIncUp then return end
    if gs.caIncCD < 500 and shouldBurst() then return end
    if unit.hp < 30 then return end
    if not unit:DebuffPandemic(debuffs.moonfire) then return end
    return spell:Cast(unit)
end)

Sunfire:Callback("arena", function(spell, unit)
    if not unit.exists then return end
    if not spell:InRange(unit) then return end
    if not player:Buff(buffs.moonkinForm) then return end
    if unit.bcc then return end
    if unit.magicImmune then return end
    if unit.totalImmune then return end
    if gs.caIncUp then return end
    if gs.caIncCD < 500 and shouldBurst() then return end
    if unit.hp < 30 then return end
    if not unit:DebuffPandemic(debuffs.sunfire) then return end

    return spell:Cast(unit)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if enemy.isFriendly then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end

    FaerieSwarm("arena", enemy)
    SolarBeam("arena", enemy)
    MassEntanglement("arena", enemy)
    MightyBash("arena", enemy)
    Cyclone("arena", enemy)
    Moonfire("arena", enemy)
    Sunfire("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end

    RemoveCorruption("pve", friendly)

end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
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
