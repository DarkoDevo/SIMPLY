if not MakuluValidCheck() then return true end
if Makulu_magic_number ~= 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 263 then return end

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
local Trinket          = MakuluFramework.Trinket
local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware


local Action           = _G.Action
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()

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

    AlphaWolf             = { ID = 198434, Hidden = true },
    AncestralGuidance     = { ID = 108281 },
    AncestralSpirit       = { ID = 2008 },
    Ascendance            = { ID = 114051, MAKULU_INFO = { damageType = "magic" } },
    AshenCatalyst         = { ID = 390370, Hidden = true },
    AstralRecall          = { ID = 556 },
    AstralShift           = { ID = 108271 },
    AwakeningStorms       = { ID = 455129, Hidden = true },
    Bloodlust             = { ID = 2825, MAKULU_INFO = { damageType = "magic" } },
    BloodlustShamanism    = { ID = 204361, FixedTexture = 133667, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Burrow                = { ID = 409293 },
    CapacitorTotem        = { ID = 192058, MAKULU_INFO = { damageType = "magic" } },
    ChainHeal             = { ID = 1064 },
    ChainLightning        = { ID = 188443, MAKULU_INFO = { damageType = "magic" } },
    CleanseSpirit         = { ID = 51886 },
    ConductiveEnergy      = { ID = 455123, Hidden = true },
    ConvergingStorms      = { ID = 384363, Hidden = true },
    CounterstrikeTotem    = { ID = 204331 },
    CrashLightning        = { ID = 187874, MAKULU_INFO = { damageType = "magic" } },
    CrashingStorms        = { ID = 334308, Hidden = true },
    DeeplyRootedElements  = { ID = 378270, Hidden = true },
    DoomWinds             = { ID = 384352, MAKULU_INFO = { damageType = "physical" } },
    EarthElemental        = { ID = 198103 },
    EarthGrabTotem        = { ID = 51485, MAKULU_INFO = { damageType = "magic" } },
    EarthShield           = { ID = 974 },
    EarthShieldParty      = { ID = 974, Hidden = true, Texture = 154925 },
    EarthbindTotem        = { ID = 2484, MAKULU_INFO = { damageType = "magic" } },
    Earthsurge            = { ID = 455590, Hidden = true },
    ElementalAssault      = { ID = 210853, Hidden = true },
    ElementalBlast        = { ID = 117014, MAKULU_INFO = { damageType = "magic" } },
    ElementalOrbit        = { ID = 383010, Hidden = true },
    ElementalSpirits      = { ID = 262624, Hidden = true },
    FarSight              = { ID = 6196 },
    FeralLunge            = { ID = 196884, },
    FeralSpirit           = { ID = 51533 },
    FireNova              = { ID = 333974, MAKULU_INFO = { damageType = "magic" } },
    FlameShock            = { ID = 470411, Texture = 454735, MAKULU_INFO = { damageType = "magic" } },
    FlametongueWeapon     = { ID = 318038 },
    FlowingSpirits        = { ID = 469314, Hidden = true },
    FlowingSpirits        = { ID = 469314, Hidden = true },
    FrostShock            = { ID = 196840, MAKULU_INFO = { damageType = "magic" } },

    GhostWolf             = { ID = 2645 },
    ThunderousPaws        = { ID = 378075, Hidden = true },
    GreaterPurge          = { ID = 378773, MAKULU_INFO = { damageType = "magic" } },
    GroundingTotem        = { ID = 204336 },
    GustOfWind            = { ID = 192063 },
    Hailstorm             = { ID = 334195, Hidden = true },
    HealingStreamTotem    = { ID = 5394 },
    HealingSurge          = { ID = 8004 },
    Heroism               = { ID = 32182, MAKULU_INFO = { ignoreCasting = true } },
    HeroismShamanism      = { ID = 204362, FixedTexture = 133667, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Hex                   = { ID = 51514, MAKULU_INFO = { damageType = "magic" } },
    IceStrike             = { ID = 470194, MAKULU_INFO = { damageType = "magic" } },
    LashingFlames         = { ID = 334046, Hidden = true },
    LavaBurst             = { ID = 51505, MAKULU_INFO = { damageType = "magic" } },
    LavaLash              = { ID = 60103, MAKULU_INFO = { damageType = "magic" } },
    LegacyOfTheFrostWitch = { ID = 384450, Hidden = true },
    LightningBolt         = { ID = 188196, Texture = 29166, MAKULU_INFO = { damageType = "magic" } },

    LightningLasso        = { ID = 305483, MAKULU_INFO = { damageType = "magic" } },
    LightningShield       = { ID = 192106 },
    LivelyTotems          = { ID = 445034, Hidden = true },
    MoltenAssault         = { ID = 334033, Hidden = true },
    NaturesSwiftness      = { ID = 378081 },
    OverflowingMaelstrom  = { ID = 384149, Hidden = true},
    PoisonCleansingTotem  = { ID = 383013 },

    PrimordialWave        = { ID = 375982, FixedTexture = 3578231, MAKULU_INFO = { damageType = "magic" } },
    PrimordialStorm       = { ID = 1218090, FixedTexture = 3578231, MAKULU_INFO = { damageType = "magic" } },
    Purge                 = { ID = 370, MAKULU_INFO = { damageType = "magic" } },
    RagingMaelstrom       = { ID = 384143, Hidden = true },

    SearingTotem          = { ID = 3599, Hidden = true },

    Shamanism             = { ID = 193876, Hidden = true },
    Skyfury               = { ID = 462854 },
    SpiritwalkersGrace    = { ID = 79206 },
    StaticAccumulation    = { ID = 384411, Hidden = true },
    StaticFieldTotem      = { ID = 355580, MAKULU_INFO = { damageType = "magic" } },
    StoneBulwarkTotem     = { ID = 108270, MAKULU_INFO = { damageType = "magic" } },
    Stormblast            = { ID = 319930, Hidden = true },
    Stormflurry           = { ID = 344357, Hidden = true },
    Stormstrike           = { ID = 17364, Texture = 198367, MAKULU_INFO = { damageType = "physical" } },
    Stormweaver           = { ID = 410673, Hidden = true },
    Sundering             = { ID = 197214, MAKULU_INFO = { damageType = "magic" } },
    Supercharge           = { ID = 455110, Hidden = true },
    SurgingTotem          = { ID = 444995, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast Single-Button Assistant" },
    SwirlingMaelstrom     = { ID = 384359, Hidden = true },
    Tempest               = { ID = 452201, Texture = 29166, MAKULU_INFO = { damageType = "magic" } },
    TempestTalent         = { ID = 454009, Hidden = true },
    ThorimsInvocation     = { ID = 384444, Hidden = true },
    Thunderstorm          = { ID = 51490, MAKULU_INFO = { damageType = "magic" } },
    TotemicProjection     = { ID = 108287 },
    TotemicRebound        = { ID = 445025, Hidden = true },
    TotemicRecall         = { ID = 108285 },
    TremorTotem           = { ID = 8143 },
    UnleashShield         = { ID = 356736, MAKULU_INFO = { damageType = "magic" } },
    UnrelentingStorms     = { ID = 470490, Hidden = true },
    UnrulyWinds           = { ID = 390288, Hidden = true },
    WaterWalking          = { ID = 546 },
    WindRushTotem         = { ID = 192077, MAKULU_INFO = { damageType = "magic" } },
    WindShear             = { ID = 57994, MAKULU_INFO = { damageType = "magic" } },
    WindfuryWeapon        = { ID = 33757 },
    Windstrike            = { ID = 115356, Texture = 198367, MAKULU_INFO = { damageType = "physical" } },
    WitchDoctorsAncestry  = { ID = 384447, Hidden = true },

    HealingSurgeParty = { ID = 8004, Texture = 356736, Desc = "Party" }, -- Unleash Shield 

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
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_SHAMAN_ENHANCEMENT] = A

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
local tank = ConstUnit.tank
local healer = ConstUnit.healer
local enemyHealer = ConstUnit.enemyHealer

local gs = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    cdUp = false,
    tiSpell = false,
    enemies = 0,
    T31has2P = false,
    T31has4P = false,
    activeFS = 0,
    fightRemains = 0,
    maelSpent = 0,
    activeWolves = 0,
    shouldAoE = false,
    targetNatureMod = 1,
    expectedLbFunnel = 1,
    orbsActive = false,
    rodCount = 0,
}

local buffs = {
    tempest = 454015,
    lightningShield = 192106,
    earthShield = 974,
    earthShieldOrbit = 383648,
    ascendance = 114051,
    feralSpirit = 333957,
    doomWinds = 384352,
    maelstromWeapon = 344179,
    primordialWave = 375986,
    crashLightning = 187878,
    ashenCatalyst = 390371,
    iceStrike = 384357,
    hailstorm = 334196,
    convergingStorms = 198300,
    clCrashLightning = 333964,
    cracklingThunder = 409834,
    cracklingSurge = 224127,
    icyEdge = 224126,
    moltenWeapon = 224125,
    volcanicStrength = 409833,
    awakeningStorms = 462131,
    stormbringer = 201846,
    hotHand = 215785,
    arenaPreparation = 32727,
    stormweaver = 410681,
    arcDischarge = 455097,
    voltiacBlaze = 470058,
    legacyOfTheFrostWitch = 384451,
    stormsurge = 201846,
    totemicRebound = 458269,
    earthenWeapon = 392375,
    whirlingEarth = 453406,
    whirlingAir = 453409,
    whirlingFire = 453405,
}

local debuffs = {
    flameShock = 188389,
    chaosBrand = 1490,
    huntersMark = 257284,
    lightningRod = 197209, -- needs checking
    lashingFlames = 334168,
}

local function num(val)
    if val then return 1 else return 0 end
end

Player:AddTier("Tier31", { 217236, 217237, 217238, 217239, 217240, })

local interrupts = {
    { spell = WindShear },
    { spell = Thunderstorm, isCC = true, aoe = true, distance = 2 }
}

local function shouldBurst()
    -- Always burst on training dummies
    if target.isDummy then return true end

    if A.GetToggle(2, "burstStyle") == "1" then
        if A.BurstIsON("target") then
            if A.Zone ~= "arena" then
                local activeEnemies = MultiUnits:GetActiveUnitPlates()
                for enemyGUID in pairs(activeEnemies) do
                    local enemy = MakUnit:new(enemyGUID)
                    if enemy.ttd >= A.GetToggle(2, "burstSens") * 1000 then
                        return true
                    end
                end
            else
                return true
            end
        end
        return false
    else
        return makBurst()
    end
end

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if enemy.distance <= 5 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function lavaLashInRange()
    return constCell:GetOrSet("lavaLashInRange", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if LavaLash:InRange(enemy) and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function activeEnemies()
    return math.max(enemiesInMelee(), 1)
end

local function tiSpell()
    local lightningBoltTime = LightningBolt.used
    local chainLightningTime = ChainLightning.used
    local tempestTime = Tempest.used

    if lightningBoltTime < 0 and chainLightningTime < 0 and tempestTime < 0 then
        return LightningBolt.id
    end

    local hardReset = A.GetToggle(2, "resetTi") and not player.inCombat

    if lightningBoltTime < 0 or hardReset then
        lightningBoltTime = 999999
    end

    if chainLightningTime < 0 or hardReset then
        chainLightningTime = 999999
    end

    if tempestTime < 0 or hardReset then
        tempestTime = 999999
    end

    if tempestTime < chainLightningTime and tempestTime < lightningBoltTime then
        if gs.activeEnemies >= 2 then -- If Tempest hits two enemies, CL is primed. Very hard to check.
            return ChainLightning.id
        else
            return LightningBolt.id
        end
    end

    if lightningBoltTime <= chainLightningTime then
        return LightningBolt.id
    else
        return ChainLightning.id
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

local function isValidTarget(unit)
    return unit:Exists() and
           not unit:IsDeadOrGhost() and
           unit:CanAttack() and
           unit:Los()
end

-------------------Tempest Tracker---------------
local tempestProgress = 0

local spellsThatConsume = {
    [LightningBolt.id] = true,
    [ChainLightning.id] = true,
    [Tempest.id] = true,
    [ElementalBlast.id] = true,
    [LavaBurst.id] = true,
}

local function OnSpellCastEvent(unit, _, spellID)
    if unit ~= "player" then return end

    if spellsThatConsume[spellID] then
        local currentStacks = player:HasBuffCount(buffs.maelstromWeapon) or 0
        local spent

        if spellID == LightningBolt.id and player:Buff(buffs.ascendance) then
            spent = math.min(currentStacks, 5) 
        else
            spent = currentStacks
        end

        tempestProgress = tempestProgress + spent

        if tempestProgress >= 40 then
            tempestProgress = tempestProgress - 40
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_AURA")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        OnSpellCastEvent(...)
    end
end)

-------------------

local function shouldRecall()
    local recall = A.GetToggle(2, "recallSelect")

    -- recallSelect[1] = Tremor Totem
    -- recallSelect[2] = Capacitor Totem
    -- recallSelect[3] = Stone Bulwark Totem
    -- recallSelect[4] = Static Field Totem
    -- recallSelect[5] = Grounding Totem

    if IsPlayerSpell(A.TremorTotem.ID) and TremorTotem:Cooldown() > 30000 and recall[1] then
        return true
    end

    if IsPlayerSpell(A.CapacitorTotem.ID) and  CapacitorTotem:Cooldown() > 30000 and recall[2] then
        return true
    end

    --if IsPlayerSpell(A.StoneBulwarkTotem.ID) and  StoneBulwarkTotem:Cooldown() > 30000 and recall[3] then
    --    return true
    --end

    if IsPlayerSpell(A.StaticFieldTotem.ID) and StaticFieldTotem:Cooldown() > 30000 and recall[4] then
        return true
    end

    if IsPlayerSpell(A.GroundingTotem.ID) and GroundingTotem:Cooldown() > 30000 and recall[5] then
        return true
    end

    if IsPlayerSpell(A.WindRushTotem.ID) and WindRushTotem:Cooldown() > 15000 and recall[6] then
        return true
    end

    if IsPlayerSpell(A.PoisonCleansingTotem.ID) and PoisonCleansingTotem:Cooldown() > 15000 and recall[7] then
        return true
    end

    if IsPlayerSpell(A.HealingStreamTotem.ID) and HealingStreamTotem:Cooldown() > 15000 and recall[8] then
        return true
    end

    return false
end

local function isTotemActive(spell)
    for i = 1, MAX_TOTEMS do
        local _, name, startTime = GetTotemInfo(i)
        if startTime > 0 and name == spell.wowName then
            return true
        end
    end
    return false
end

local function isAnyTotemActive()
    for i = 1, MAX_TOTEMS do
        local _, _, startTime = GetTotemInfo(i)
        if startTime > 0 then
            return true
        end
    end
    return false
end

local wolves = {
    [buffs.cracklingSurge] = 0,
    [buffs.icyEdge] = 0,
    [buffs.moltenWeapon] = 0
}
local function countWolves()
    for spellID in pairs(wolves) do
        wolves[spellID] = 0
    end

    AuraUtil.ForEachAura("player", "HELPFUL", nil, function(name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll, timeMod, ...)
        if wolves[spellID] ~= nil then
            wolves[spellID] = wolves[spellID] + 1
        end
    end)

    return wolves
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength

    return currentCast, currentCastName, remains, length
end

local function earthShieldCount() 
    local partyUnits = {party1, party2, party3, party4, player}
    local total = 0
    for _, unit in ipairs(partyUnits) do
        if unit:Buff(buffs.earthShield, true) then
            total = total + 1
        end
    end 

    return total
end

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 5 and not enemy:IsTotem() and not enemy.isPet then
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

local function orbsActive()
    local cacheKey = "orbsActive"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            local enemyCast = enemy.castInfo
            local orb = enemyCast and enemyCast.spellId == 461904
            if LightningBolt:InRange(enemy) and orb then
                return true
            end
        end
        
        return false
    end)
end

local function debuffCount(spellId)
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local debuffCount = 0

    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if enemy:Debuff(spellId, true) then 
            debuffCount = debuffCount + 1
        end 
    end  
    
    return debuffCount
end

local function autoTarget()
    if not player.inCombat then return false end
    if InPvP() then return false end

    if gs.orbsActive then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if A.GetToggle(2, "autoRod") and player:TalentKnown(ConductiveEnergy.id) and gs.rodCount < math.min(gs.activeEnemies, 5) and target:DebuffRemains(debuffs.lightningRod, true) > 1000 then
        return true
    end

    if LavaLash:InRange(target) and target.exists then return false end

    if gs.lavaLashInRange > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local lastUpdateTime = 0
local updateDelay = 0.5
local function updategs()
    local currentTime = GetTime() 
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gs.imCastingRemaining = currentCastRemains
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.imCastingName = currentCastName
        lastUpdateTime = currentTime 
    end

    gs.ascendance = player:BuffRemains(buffs.ascendance) > MakGcd()

    gs.cdUp = gs.ascendance or player:Buff(buffs.feralSpirit) or player:Buff(buffs.doomWinds) or (not player:TalentKnown(Ascendance.id) and not player:TalentKnown(FeralSpirit.id) and not player:TalentKnown(DoomWinds.id))

    gs.activeEnemies = activeEnemies()
    gs.lavaLashInRange = lavaLashInRange()

    gs.maelstrom = player:HasBuffCount(buffs.maelstromWeapon)

    gs.tiSpell = tiSpell()

    gs.activeFS = debuffCount(debuffs.flameShock)

    --gs.maelSpent = trackMaelstromSpent()

    local wolfCount = countWolves()
    gs.activeWolves = wolfCount[buffs.cracklingSurge] + wolfCount[buffs.icyEdge] + wolfCount[buffs.moltenWeapon]

    gs.shouldAoE = A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gs.targetNatureMod = 1 + (num(target:Debuff(debuffs.chaosBrand)) * 0.03) * (1 + num(target:Debuff(debuffs.huntersMark) and target.hp >= 80) * 0.05)

    gs.expectedLbFunnel = A.LightningBolt:GetSpellDescription()[1] * (1 + num(target:Debuff(debuffs.lightningRod)) * gs.targetNatureMod * (1 + num(player:Buff(buffs.primordialWave)) * gs.activeFS * 1.75) * 0.10)

    gs.expectedClFunnel = A.ChainLightning:GetSpellDescription()[1] * (1 + num(target:Debuff(debuffs.lightningRod)) * gs.targetNatureMod * (math.min(gs.enemies, 3 + 2 * num(player:TalentKnown(CrashingStorms.id)))) * 0.10)
    gs.orbsActive = orbsActive()
    gs.rodCount = enemiesInRange(debuffs.lightningRod, 1000)

    gs.remainingForTempest = 40 - tempestProgress
    gs.tempestSoon = A.GetToggle(2, "estTempest") and player:TalentKnown(TempestTalent.id) and (player:HasBuffCount(buffs.awakeningStorms) == 2 or gs.remainingForTempest <= 10)
end

Bloodlust:Callback("arena", function(spell)
    local isArena, isRegistered = IsActiveBattlefieldArena()

    if not player:TalentKnown(Shamanism.id) then return end
    if not isArena then return end
    if player:Buff(buffs.arenaPreparation) then return end
    if not gs.cdUp then return end
    if target.distance > 10 then return end

    return spell:Cast(player)
end)

TotemicRecall:Callback(function(spell)
    if not shouldRecall() then return end
    if InPvP() then return end

    return spell:Cast(player)
end)

Skyfury:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(Skyfury.wowName) and HealingSurge:InRange(unit) and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return not HealingSurge:InRange(unit) or unit.distance <= 0 end)

    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if not missingBuff then return end

    return Debounce("skyfury", 1000, 2500, spell, player)
end)

Skyfury:Callback("buff", function(spell)
    if player:Buff(Skyfury.id) then return end
    if player.inCombat then return end

    return spell:Cast(player)
end)

AstralShift:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end 
    
    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "astralShiftHP") then 
        return spell:Cast()
    end
end)

StoneBulwarkTotem:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end    
    
    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "stoneBulwarkTotemHP") then 
        return spell:Cast()
    end
end)

AncestralGuidance:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end   

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "ancestralGuidanceHP") then 
        return spell:Cast()
    end
end)

EarthElemental:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[4] then return end   

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "earthElementalHP") then 
        return spell:Cast()
    end
end)

WindfuryWeapon:Callback(function(spell)
    local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()

    if not hasMainHandEnchant or mainHandExpiration <= (1800000 * num(not player.inCombat)) then
        return spell:Cast()
    end
end)

FlametongueWeapon:Callback(function(spell)
    local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()

    if not hasOffHandEnchant or offHandExpiration <= (1800000 * num(not player.inCombat)) then
        return spell:Cast()
    end
end)

LightningShield:Callback(function(spell)
    if player.inCombat then return end
    if player:Buff(buffs.lightningShield) then return end

    return spell:Cast()
end)

EarthShield:Callback(function(spell)
    if not player:TalentKnown(ElementalOrbit.id) then return end

    if player.inCombat and A.GetToggle(2, "esInCombat") then
        if not player:Buff(EarthShield.wowName) then
            return spell:Cast()
        end
    end

    if not player.inCombat and player:HasBuffCount(EarthShield.wowName) < 9 then
        return spell:Cast()
    end
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not gs.cdUp then return end

    return spell:Cast()
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not gs.cdUp then return end

    return spell:Cast()
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if A.IsInPvP then return end
    if not gs.cdUp then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not gs.cdUp then return end

    return spell:Cast()
end)

BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

HealingSurge:Callback("self", function(spell)
    if player.hp > A.GetToggle(2, "healingSurgeHP") then return end
    if player:Buff(buffs.ancestralGuidance) then return end

    if A.Stormweaver:IsTalentLearned() then
        if player:HasBuffCount(buffs.stormweaver) >= 5 then 
            return spell:Cast(friendly)
        end
    else
        if player:HasBuffCount(buffs.maelstromWeapon) >= 5 then
            return spell:Cast(player)
        end
    end
end)

PoisonCleansingTotem:Callback(function(spell)
    local shouldDispel = MakMulti.party:Find(function(unit) return unit.poisoned end)
    
    if not shouldDispel then return end

    return Debounce("pct", 1000, 2500, spell, player)
end)

------------------------------------------------------
---AOE (19 December 2024)-----------------------------

-- actions.aoe=feral_spirit,if=talent.elemental_spirits.enabled|talent.alpha_wolf.enabled
FeralSpirit:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end

    if player:TalentKnown(ElementalSpirits.id) or player:TalentKnown(AlphaWolf.id) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/ascendance,if=dot.flame_shock.ticking&ti_chain_lightning
Ascendance:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if target.distance > 5 then return end

    if not target:Debuff(debuffs.flameShock, true) then return end

    if gs.activeFS < math.min(gs.activeEnemies, 6) then return end -- attempt to hard force spread Flame Shock (tiSpell is causing issues when not adding this)

    if gs.tiSpell ~= ChainLightning.id then return end
    
    return spell:Cast()
end)

-- actions.aoe+=/tempest,target_if=min:debuff.lightning_rod.remains,if=!buff.arc_discharge.up&((buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&!talent.raging_maelstrom.enabled)|(buff.maelstrom_weapon.stack>=8))|(buff.maelstrom_weapon.stack>=5&(tempest_mael_count>30|buff.awakening_storms.stack=2))
LightningBolt:Callback("aoe-t", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then
            if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
        end
    end
    if not player:Buff(buffs.tempest) then return end
    if player:Buff(buffs.arcDischarge) then return end

    if gs.maelstrom >= 8 - (3 * num(gs.tempestSoon)) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/windstrike,target_if=min:debuff.lightning_rod.remains,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>0&ti_chain_lightning
Stormstrike:Callback("aoe-w", function(spell)
    if not gs.ascendance then return end
    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges == 0 then return end

    if not player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom <= 0 then return end
    if gs.tiSpell ~= ChainLightning.id then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/crash_lightning,if=talent.crashing_storms.enabled&((talent.unruly_winds.enabled&active_enemies>=10)|active_enemies>=15)
CrashLightning:Callback("aoe", function(spell)
    if not LavaLash:InRange(target) then return end
    if not player:TalentKnown(CrashingStorms.id) then return end

    if gs.activeEnemies >= 15 - (5 * num(player:TalentKnown(UnrulyWinds.id))) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/lightning_bolt,target_if=min:debuff.lightning_rod.remains,if=(!talent.tempest.enabled|(tempest_mael_count<=10&buff.awakening_storms.stack<=1))&((active_dot.flame_shock=active_enemies|active_dot.flame_shock=6)&buff.primordial_wave.up&buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&(!buff.splintered_elements.up|fight_remains<=12|raid_event.adds.remains<=gcd))
LightningBolt:Callback("aoe", function(spell) 
    if player:Buff(buffs.tempest) then return end
    if player:HasBuffCount(buffs.awakeningStorms) >= 2 then return end
    if gs.activeFS < math.min(gs.activeEnemies, 6) then return end
    if not player:Buff(buffs.primordialWave) then return end
    if gs.maelstrom < 10 then return end
    if player:Buff(buffs.splinteredElements) then return end

    if not A.GetToggle(2, "savePwave") and player:Buff(buffs.primordialWave) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/voltaic_blaze,if=buff.maelstrom_weapon.stack<=8
FlameShock:Callback("aoe-v", function(spell)
    if not player:Buff(buffs.voltiacBlaze) then return end
    if gs.maelstrom > 8 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/lava_lash,if=talent.molten_assault.enabled&(talent.primordial_wave.enabled|talent.fire_nova.enabled)&dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
LavaLash:Callback("aoe", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if not target:Debuff(debuffs.flameShock, true) then return end
    if gs.activeFS >= 6 then return end
    if gs.activeFS >= gs.activeEnemies then return end

    if player:TalentKnown(PrimordialWave.id) or player:TalentKnown(FireNova.id) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up
PrimordialWave:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if player:Buff(buffs.ascendance) then return end
    if player:Buff(buffs.primordialWave) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/chain_lightning,target_if=min:debuff.lightning_rod.remains,if=buff.arc_discharge.up&buff.maelstrom_weapon.stack>=5
ChainLightning:Callback("aoe", function(spell)
    if not player:Buff(buffs.arcDischarge) then return end
    if gs.maelstrom < 5 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/elemental_blast,target_if=min:debuff.lightning_rod.remains,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|feral_spirit.active>=2)))&buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&(!talent.crashing_storms.enabled|active_enemies<=3)
ElementalBlast:Callback("aoe", function(spell)
    if player:TalentKnown(ElementalSpirits.id) then
        local charges = C_Spell.GetSpellCharges(spell.id)

        if charges.currentCharges ~= charges.maxCharges and gs.activeWolves < 2 then return end
    end

    if gs.maelstrom < 10 then return end
    
    if not player:TalentKnown(CrashingStorms.id) or gs.activeEnemies <= 3 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/chain_lightning,target_if=min:debuff.lightning_rod.remains,if=(buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&!talent.raging_maelstrom.enabled)|(buff.maelstrom_weapon.stack>=7)
ChainLightning:Callback("aoe2", function(spell)
    if gs.maelstrom < 7 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/feral_spirit
FeralSpirit:Callback("aoe2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.aoe+=/doom_winds,if=ti_chain_lightning&(buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled)
DoomWinds:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if gs.tiSpell ~= ChainLightning.id then return end

    if player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/crash_lightning,if=(buff.doom_winds.up&active_enemies>=4)|!buff.crash_lightning.up|(talent.alpha_wolf.enabled&feral_spirit.active&alpha_wolf_min_remains=0)
CrashLightning:Callback("aoe2", function(spell)
    if not Stormstrike:InRange(target) then return end

    if player:Buff(buffs.doomWinds) and gs.activeEnemies >= 4 then
        return spell:Cast(target)
    end

    if not player:Buff(buffs.crashLightning) then
        return spell:Cast(target)
    end

    if player:TalentKnown(AlphaWolf.id) and gs.activeWolves >= 1 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/sundering,if=buff.doom_winds.up|talent.earthsurge.enabled
Sundering:Callback("aoe", function(spell)
    if target.distance > 5 then return end

    if player:Buff(buffs.doomWinds) or player:TalentKnown(Earthsurge.id) then
        return spell:Cast()
    end
end)

-- actions.aoe+=/fire_nova,if=active_dot.flame_shock=6|(active_dot.flame_shock>=4&active_dot.flame_shock=active_enemies)
FireNova:Callback("aoe", function(spell)
    if gs.activeFS < 4 then return end
    if gs.activeFS < math.min(gs.activeEnemies, 6) then return end

    return spell:Cast()
end)

-- actions.aoe+=/stormstrike,if=talent.stormblast.enabled&talent.stormflurry.enabled
Stormstrike:Callback("aoe", function(spell)
    if not player:TalentKnown(Stormblast.id) then return end
    if not player:TalentKnown(Stormflurry.id) then return end

    return spell:Cast(target)
end)

--actions.aoe+=/voltaic_blaze
FlameShock:Callback("aoe-v2", function(spell)
    if not player:Buff(buffs.voltiacBlaze) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/lava_lash,target_if=min:debuff.lashing_flames.remains,if=talent.lashing_flames.enabled
LavaLash:Callback("aoe2", function(spell)
    if not player:TalentKnown(LashingFlames.id) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/lava_lash,if=talent.molten_assault.enabled&dot.flame_shock.ticking
LavaLash:Callback("aoe3", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if not target:Debuff(debuffs.flameShock, true) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/ice_strike,if=talent.hailstorm.enabled&!buff.ice_strike.up
IceStrike:Callback("aoe", function(spell)
    if not player:TalentKnown(Hailstorm.id) then return end
    if player:Buff(buffs.iceStrike) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/frost_shock,if=talent.hailstorm.enabled&buff.hailstorm.up
FrostShock:Callback("aoe", function(spell)
    if not player:TalentKnown(Hailstorm.id) then return end
    if not player:Buff(buffs.hailstorm) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/sundering
Sundering:Callback("aoe2", function(spell)
    if target.distance > 5 then return end

    return spell:Cast()
end)

-- actions.aoe+=/flame_shock,if=talent.molten_assault.enabled&!ticking
FlameShock:Callback("aoe", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/flame_shock,target_if=min:dot.flame_shock.remains,if=(talent.fire_nova.enabled|talent.primordial_wave.enabled)&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
FlameShock:Callback("aoe", function(spell)
    if gs.activeFS >= gs.activeEnemies then return end
    if gs.activeFS >= 6 then return end

    if player:TalentKnown(FireNova.id) or player:TalentKnown(PrimordialWave.id) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=3
FireNova:Callback("aoe2", function(spell)
    if gs.activeFS < 3 then return end

    return spell:Cast()
end)

-- actions.aoe+=/stormstrike,if=buff.crash_lightning.up&(talent.deeply_rooted_elements.enabled|buff.converging_storms.stack=buff.converging_storms.max_stack)
Stormstrike:Callback("aoe2", function(spell)
    if not player:Buff(buffs.crashLightning) then return end

    if player:TalentKnown(DeeplyRootedElements.id) or player:HasBuffCount(buffs.convergingStorms) >= 6 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/crash_lightning,if=talent.crashing_storms.enabled&buff.cl_crash_lightning.up&active_enemies>=4
CrashLightning:Callback("aoe3", function(spell)
    if not Stormstrike:InRange(target) then return end
    if not player:TalentKnown(CrashingStorms.id) then return end
    if not player:Buff(buffs.clCrashLightning) then return end
    if gs.activeEnemies < 4 then return end

    return spell:Cast()
end)

-- actions.aoe+=/windstrike
-- actions.aoe+=/stormstrike
Stormstrike:Callback("aoe3", function(spell)
    
    return spell:Cast(target)
end)

-- actions.aoe+=/ice_strike
IceStrike:Callback("aoe2", function(spell)

    return spell:Cast(target)
end)

-- actions.aoe+=/lava_lash
LavaLash:Callback("aoe4", function(spell)

    return spell:Cast(target)
end)

-- actions.aoe+=/crash_lightning
CrashLightning:Callback("aoe4", function(spell)
    if not Stormstrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.aoe+=/fire_nova,if=active_dot.flame_shock>=2
FireNova:Callback("aoe3", function(spell)
    if gs.activeFS < 2 then return end

    return spell:Cast()
end)

-- actions.aoe+=/elemental_blast,target_if=min:debuff.lightning_rod.remains,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|feral_spirit.active>=2)))&buff.maelstrom_weapon.stack>=5&(!talent.crashing_storms.enabled|active_enemies<=3)
ElementalBlast:Callback("aoe2", function(spell)
    if player:TalentKnown(ElementalSpirits.id) then
        local charges = C_Spell.GetSpellCharges(spell.id)

        if charges.currentCharges ~= charges.maxCharges and gs.activeWolves < 2 then return end
    end

    if gs.maelstrom < 5 then return end
    
    if not player:TalentKnown(CrashingStorms.id) or gs.activeEnemies <= 3 then
        return spell:Cast(target)
    end

    return spell:Cast(target)
end)

-- actions.aoe+=/chain_lightning,target_if=min:debuff.lightning_rod.remains,if=buff.maelstrom_weapon.stack>=5
ChainLightning:Callback("aoe3", function(spell)
    if gs.maelstrom < 5 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/flame_shock,if=!ticking
FlameShock:Callback("aoe2", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 1500 then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/frost_shock,if=!talent.hailstorm.enabled
FrostShock:Callback("aoe2", function(spell)
    if player:TalentKnown(Hailstorm.id) then return end

    return spell:Cast(target)
end)

local function aoe()
    FeralSpirit("aoe")
    Ascendance("aoe")
    LightningBolt("aoe-t")
    Stormstrike("aoe-w")
    CrashLightning("aoe")
    LightningBolt("aoe")
    FlameShock("aoe-v")
    LavaLash("aoe")
    PrimordialWave("aoe")
    ChainLightning("aoe")
    ElementalBlast("aoe")
    ChainLightning("aoe2")
    FeralSpirit("aoe2")
    DoomWinds("aoe")
    CrashLightning("aoe2")
    Sundering("aoe")
    FireNova("aoe")
    Stormstrike("aoe")
    FlameShock("aoe-v2")
    LavaLash("aoe2")
    LavaLash("aoe3")
    IceStrike("aoe")
    FrostShock("aoe")
    Sundering("aoe2")
    FlameShock("aoe")
    FireNova("aoe2")
    Stormstrike("aoe2")
    CrashLightning("aoe3")
    Stormstrike("aoe3")
    IceStrike("aoe2")
    LavaLash("aoe4")
    CrashLightning("aoe4")
    FireNova("aoe3")
    ElementalBlast("aoe2")
    ChainLightning("aoe3")
    FlameShock("aoe2")
    FrostShock("aoe2")
end

--actions.aoe_totemic=surging_totem
SurgingTotem:Callback("aoe_totemic", function(spell)
    if not LavaLash:InRange(target) then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/ascendance,if=ti_chain_lightning
Ascendance:Callback("aoe_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if target.distance > 5 then return end

    if gs.tiSpell ~= ChainLightning.id then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/sundering,if=buff.ascendance.up&pet.surging_totem.active&talent.earthsurge.enabled&(buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled)
Sundering:Callback("aoe_totemic", function(spell)
    if target.distance > 5 then return end

    if not gs.ascendance then return end
    if not isTotemActive(SurgingTotem) then return end
    if not player:TalentKnown(Earthsurge.id) then return end
    
    if player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/crash_lightning,if=talent.crashing_storms.enabled&(active_enemies>=15-5*talent.unruly_winds.enabled)
CrashLightning:Callback("aoe_totemic", function(spell)
    if not player:TalentKnown(CrashingStorms.id) then return end
    if gs.activeEnemies < 15 - 5 * player:TalentKnownInt(UnrulyWinds.id) then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/lightning_bolt,if=((active_dot.flame_shock=active_enemies|active_dot.flame_shock=6)&buff.primordial_wave.up&buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&(!buff.splintered_elements.up|fight_remains<=12|raid_event.adds.remains<=gcd))
LightningBolt:Callback("aoe_totemic", function(spell)
    if gs.activeFS < math.min(gs.activeEnemies, 6) then return end
    if not player:Buff(buffs.primordialWave) then return end
    if gs.maelstrom < 10 then return end
    if player:Buff(buffs.splinteredElements) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/doom_winds,if=!talent.elemental_spirits.enabled&(buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled)
DoomWinds:Callback("aoe_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if player:TalentKnown(ElementalSpirits.id) then return end

    if player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/lava_lash,if=talent.molten_assault.enabled&(talent.primordial_wave.enabled|talent.fire_nova.enabled)&dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
LavaLash:Callback("aoe_totemic", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if not target:Debuff(debuffs.flameShock, true) then return end
    if gs.activeFS >= gs.activeEnemies then return end
    if gs.activeFS >= 6 then return end

    if player:TalentKnown(PrimordialWave.id) or player:TalentKnown(FireNova.id) then
        return spell:Cast(target)
    end
end)

--actions.aoe_totemic+=/primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up
PrimordialWave:Callback("aoe_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if player:Buff(buffs.ascendance) then return end
    if player:Buff(buffs.primordialWave) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/elemental_blast,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|feral_spirit.active>=2)))&buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&(!talent.crashing_storms.enabled|active_enemies<=3)
ElementalBlast:Callback("aoe_totemic", function(spell)
    if player:TalentKnown(ElementalSpirits.id) then
        local charges = C_Spell.GetSpellCharges(spell.id)
        if charges.currentCharges ~= charges.maxCharges and gs.activeWolves < 2 then return end
    end
    if gs.maelstrom < 10 then return end
    if player:TalentKnown(CrashingStorms.id) and gs.activeEnemies > 3 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/chain_lightning,if=buff.maelstrom_weapon.stack>=10
ChainLightning:Callback("aoe_totemic", function(spell)
    if gs.maelstrom < 10 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/feral_spirit
FeralSpirit:Callback("aoe_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/doom_winds,if=buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled
DoomWinds:Callback("aoe_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/crash_lightning,if=buff.doom_winds.up|!buff.crash_lightning.up|(talent.alpha_wolf.enabled&feral_spirit.active&alpha_wolf_min_remains=0)
CrashLightning:Callback("aoe_totemic2", function(spell)

    if player:Buff(buffs.doomWinds) then
        return spell:Cast()
    end

    if not player:Buff(buffs.crashLightning) then
        return spell:Cast()
    end

    if player:TalentKnown(AlphaWolf.id) and gs.activeWolves >= 1 then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/sundering,if=buff.doom_winds.up|talent.earthsurge.enabled&(buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled)&pet.surging_totem.active
Sundering:Callback("aoe_totemic2", function(spell)
    if target.distance > 5 then return end

    if player:Buff(buffs.doomWinds) then
        return spell:Cast()
    end

    if player:TalentKnown(Earthsurge.id) and (player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id)) and isTotemActive(SurgingTotem) then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/fire_nova,if=active_dot.flame_shock=6|(active_dot.flame_shock>=4&active_dot.flame_shock=active_enemies)
FireNova:Callback("aoe_totemic", function(spell)
    if gs.activeFS < 4 then return end
    if gs.activeFS < math.min(gs.activeEnemies, 6) then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/voltaic_blaze
FlameShock:Callback("aoe_totemic", function(spell)
    if not player:Buff(buffs.voltiacBlaze) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/lava_lash,target_if=min:debuff.lashing_flames.remains,if=talent.lashing_flames.enabled
LavaLash:Callback("aoe_totemic2", function(spell)
    if not player:TalentKnown(LashingFlames.id) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/lava_lash,if=talent.molten_assault.enabled&dot.flame_shock.ticking
LavaLash:Callback("aoe_totemic3", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if not target:Debuff(debuffs.flameShock, true) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/ice_strike,if=talent.hailstorm.enabled&!buff.ice_strike.up
IceStrike:Callback("aoe_totemic", function(spell)
    if not player:TalentKnown(Hailstorm.id) then return end
    if player:Buff(buffs.iceStrike) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/frost_shock,if=talent.hailstorm.enabled&buff.hailstorm.up
FrostShock:Callback("aoe_totemic", function(spell)
    if not player:TalentKnown(Hailstorm.id) then return end
    if not player:Buff(buffs.hailstorm) then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/sundering,if=(buff.legacy_of_the_frost_witch.up|!talent.legacy_of_the_frost_witch.enabled)&pet.surging_totem.active
Sundering:Callback("aoe_totemic3", function(spell)
    if target.distance > 5 then return end

    if not isTotemActive(SurgingTotem) then return end

    if player:Buff(buffs.legacyOfTheFrostWitch) or not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast()
    end
end)

--actions.aoe_totemic+=/flame_shock,if=talent.molten_assault.enabled&!ticking
FlameShock:Callback("aoe_totemic2", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/flame_shock,target_if=min:dot.flame_shock.remains,if=(talent.fire_nova.enabled|talent.primordial_wave.enabled)&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
FlameShock:Callback("aoe_totemic3", function(spell)
    if gs.activeFS >= gs.activeEnemies then return end
    if gs.activeFS >= 6 then return end

    if player:TalentKnown(FireNova.id) or player:TalentKnown(PrimordialWave.id) then
        return spell:Cast(target)
    end
end)

--actions.aoe_totemic+=/fire_nova,if=active_dot.flame_shock>=3
FireNova:Callback("aoe_totemic2", function(spell)
    if gs.activeFS < 3 then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/stormstrike,if=buff.crash_lightning.up&(talent.deeply_rooted_elements.enabled|buff.converging_storms.stack=buff.converging_storms.max_stack)
Stormstrike:Callback("aoe_totemic", function(spell)
    if not player:Buff(buffs.crashLightning) then return end
    if not player:TalentKnown(DeeplyRootedElements.id) and player:HasBuffCount(buffs.convergingStorms) < 6 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/crash_lightning,if=talent.crashing_storms.enabled&buff.cl_crash_lightning.up&active_enemies>=4
CrashLightning:Callback("aoe_totemic3", function(spell)
    if not player:TalentKnown(CrashingStorms.id) then return end
    if not player:Buff(buffs.clCrashLightning) then return end
    if gs.activeEnemies < 4 then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/windstrike
--actions.aoe_totemic+=/stormstrike
Stormstrike:Callback("aoe_totemic4", function(spell)
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/ice_strike
IceStrike:Callback("aoe_totemic2", function(spell)
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/lava_lash
LavaLash:Callback("aoe_totemic4", function(spell)
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/crash_lightning
CrashLightning:Callback("aoe_totemic4", function(spell)
    return spell:Cast()
end)

--actions.aoe_totemic+=/fire_nova,if=active_dot.flame_shock>=2
FireNova:Callback("aoe_totemic3", function(spell)
    if gs.activeFS < 2 then return end
    return spell:Cast()
end)

--actions.aoe_totemic+=/elemental_blast,target_if=min:debuff.lightning_rod.remains,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|feral_spirit.active>=2)))&buff.maelstrom_weapon.stack>=5&(!talent.crashing_storms.enabled|active_enemies<=3)
ElementalBlast:Callback("aoe_totemic3", function(spell)
    if player:TalentKnown(ElementalSpirits.id) then
        local charges = C_Spell.GetSpellCharges(spell.id)
        if charges.currentCharges ~= charges.maxCharges and gs.activeWolves < 2 then return end
    end
    if gs.maelstrom < 5 then return end
    if player:TalentKnown(CrashingStorms.id) and gs.activeEnemies > 3 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/chain_lightning,target_if=min:debuff.lightning_rod.remains,if=buff.maelstrom_weapon.stack>=5
ChainLightning:Callback("aoe_totemic4", function(spell)
    if gs.maelstrom < 5 then return end
    return spell:Cast(target)
end)

--actions.aoe_totemic+=/flame_shock,if=!ticking
FlameShock:Callback("aoe_totemic4", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 1500 then return end
    return spell:Cast(target)
end)

local function aoeTotemic()
    SurgingTotem("aoe_totemic")
    Ascendance("aoe_totemic")
    Sundering("aoe_totemic")
    CrashLightning("aoe_totemic")
    LightningBolt("aoe_totemic")
    DoomWinds("aoe_totemic")
    LavaLash("aoe_totemic")
    PrimordialWave("aoe_totemic")
    ElementalBlast("aoe_totemic")
    ChainLightning("aoe_totemic")
    FeralSpirit("aoe_totemic")
    DoomWinds("aoe_totemic")
    CrashLightning("aoe_totemic2")
    Sundering("aoe_totemic2")
    FireNova("aoe_totemic")
    FlameShock("aoe_totemic")
    LavaLash("aoe_totemic2")
    LavaLash("aoe_totemic3")
    IceStrike("aoe_totemic")
    FrostShock("aoe_totemic")
    Sundering("aoe_totemic3")
    FlameShock("aoe_totemic2")
    FlameShock("aoe_totemic3")
    FireNova("aoe_totemic2")
    Stormstrike("aoe_totemic")
    CrashLightning("aoe_totemic3")
    Stormstrike("aoe_totemic4")
    IceStrike("aoe_totemic2")
    LavaLash("aoe_totemic4")
    CrashLightning("aoe_totemic4")
    FireNova("aoe_totemic3")
    ElementalBlast("aoe_totemic3")
    ChainLightning("aoe_totemic4")
    FlameShock("aoe_totemic4")
end

-- actions.single=feral_spirit,if=talent.elemental_spirits.enabled
FeralSpirit:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end
    if not player:TalentKnown(ElementalSpirits.id) then return end
    return spell:Cast()
end)
-- actions.single+=/windstrike,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>0&ti_lightning_bolt&!talent.elemental_spirits.enabled
Stormstrike:Callback("st", function(spell)
    if not gs.ascendance then return end
    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges == 0 then return end

    if not player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom <= 0 then return end
    if gs.tiSpell ~= LightningBolt.id then return end
    if player:TalentKnown(ElementalSpirits.id) then return end
    return spell:Cast(target)
end)
-- actions.single+=/primordial_wave,if=!dot.flame_shock.ticking&talent.molten_assault.enabled&(raid_event.adds.in>action.primordial_wave.cooldown|raid_event.adds.in<6)
PrimordialWave:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if player:Buff(buffs.ascendance) then return end
    if target:Debuff(debuffs.flameShock, true) then return end
    if not player:TalentKnown(MoltenAssault.id) then return end
    return spell:Cast(target)
end)
-- actions.single+=/lava_lash,if=talent.lashing_flames.enabled&debuff.lashing_flames.down
LavaLash:Callback("st", function(spell)
    if not player:TalentKnown(LashingFlames.id) then return end
    if target:Debuff(debuffs.lashingFlames, true) then return end
    return spell:Cast(target)
end)
-- actions.single+=/stormstrike,if=buff.maelstrom_weapon.stack<2&cooldown.ascendance.remains=0
Stormstrike:Callback("st2", function(spell)
    if gs.maelstrom >= 2 then return end
    if Ascendance:Cooldown() > 0 then return end
    return spell:Cast(target)
end)
-- actions.single+=/feral_spirit
FeralSpirit:Callback("st2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end
    return spell:Cast()
end)
-- actions.single+=/ascendance,if=dot.flame_shock.ticking&(ti_lightning_bolt&active_enemies=1&raid_event.adds.in>=action.ascendance.cooldown%2)&buff.maelstrom_weapon.stack>=2
Ascendance:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if target.distance > 5 then return end

    if not target:Debuff(debuffs.flameShock, true) then return end
    if gs.tiSpell ~= LightningBolt.id then return end
    if gs.activeEnemies > 1 then return end
    if gs.maelstrom < 2 then return end
    return spell:Cast()
end)
-- actions.single+=/tempest,if=buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack|(buff.tempest.stack=buff.tempest.max_stack&(tempest_mael_count>30|buff.awakening_storms.stack=2)&buff.maelstrom_weapon.stack>=5)
LightningBolt:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then
            if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
        end
    end

    if not player:Buff(buffs.tempest) then return end

    if gs.maelstrom >= 10 then
        return spell:Cast(target)
    end
    if player:HasBuffCount(buffs.tempest) >= 2 and gs.tempestSoon and gs.maelstrom >= 5 then
        return spell:Cast(target)
    end
end)
-- actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&talent.elemental_spirits.enabled&feral_spirit.active>=6&(charges_fractional>=1.8|buff.ascendance.up)
ElementalBlast:Callback("st", function(spell)
    if gs.maelstrom < 10 then return end
    if not player:TalentKnown(ElementalSpirits.id) then return end
    if gs.activeWolves < 6 then return end
    
    if spell.frac >= 1.8 or gs.ascendance then
        return spell:Cast(target)
    end
end)
-- actions.single+=/windstrike,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>0&ti_lightning_bolt&charges=max_charges
Stormstrike:Callback("st3", function(spell)
    if not gs.ascendance then return end
    if not player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom <= 0 then return end
    if gs.tiSpell ~= LightningBolt.id then return end
    
    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges ~= charges.maxCharges then return end

    return spell:Cast(target)
end)
-- actions.single+=/doom_winds,if=raid_event.adds.in>=action.doom_winds.cooldown&talent.elemental_spirits.enabled&talent.ascendance.enabled&buff.maelstrom_weapon.stack>=2
DoomWinds:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if not player:TalentKnown(ElementalSpirits.id) then return end
    if not player:TalentKnown(Ascendance.id) then return end
    if gs.maelstrom < 2 then return end
    return spell:Cast()
end)
-- actions.single+=/windstrike,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>0&ti_lightning_bolt
Stormstrike:Callback("st4", function(spell)
    if not gs.ascendance then return end
    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges == 0 then return end

    if not player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom <= 0 then return end
    if gs.tiSpell ~= LightningBolt.id then return end
    return spell:Cast(target)
end)
-- actions.single+=/flame_shock,if=!ticking&talent.ashen_catalyst.enabled
FlameShock:Callback("st", function(spell)
    if target:Debuff(debuffs.flameShock, true) then return end
    if not player:TalentKnown(AshenCatalyst.id) then return end
    return spell:Cast(target)
end)
-- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&buff.primordial_wave.up
LightningBolt:Callback("st2", function(spell)
    if player:Buff(buffs.tempest) then return end

    if gs.maelstrom < 10 then return end
    if not player:Buff(buffs.primordialWave) then return end
    return spell:Cast(target)
end)
-- actions.single+=/tempest,if=(!talent.overflowing_maelstrom.enabled&buff.maelstrom_weapon.stack>=5)|(buff.maelstrom_weapon.stack>=10-2*talent.elemental_spirits.enabled)
LightningBolt:Callback("st3", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then
            if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
        end
    end

    if not player:Buff(buffs.tempest) then return end

    if not player:TalentKnown(OverflowingMaelstrom.id) and gs.maelstrom >= 5 then
        return spell:Cast(target)
    end

    if gs.maelstrom >= 10 - 2 * player:TalentKnownInt(ElementalSpirits.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/primordial_wave,if=(raid_event.adds.in>action.primordial_wave.cooldown|raid_event.adds.in<6)&!talent.deeply_rooted_elements.enabled
PrimordialWave:Callback("st2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if not player:TalentKnown(DeeplyRootedElements.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=8&feral_spirit.active>=4&(!buff.ascendance.up|charges_fractional>=1.8)
ElementalBlast:Callback("st2", function(spell)
    if gs.maelstrom >= 8 and gs.activeWolves >= 4 and (not gs.ascendance or spell.frac >= 1.8) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=8+2*talent.legacy_of_the_frost_witch.enabled
LightningBolt:Callback("st4", function(spell)
    if player:Buff(buffs.tempest) then return end

    if gs.maelstrom >= 8 + 2 * player:TalentKnownInt(LegacyOfTheFrostWitch.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5&!talent.legacy_of_the_frost_witch.enabled&(talent.deeply_rooted_elements.enabled|!talent.overflowing_maelstrom.enabled|!talent.witch_doctors_ancestry.enabled)
LightningBolt:Callback("st5", function(spell)
    if player:Buff(buffs.tempest) then return end

    if gs.maelstrom >= 5 and not player:TalentKnown(LegacyOfTheFrostWitch.id) and (player:TalentKnown(DeeplyRootedElements.id) or not player:TalentKnown(OverflowingMaelstrom.id) or not player:TalentKnown(WitchDoctorsAncestry.id)) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/voltaic_blaze,if=talent.elemental_spirits.enabled&!talent.witch_doctors_ancestry.enabled
FlameShock:Callback("st2", function(spell)
    if player:Buff(buffs.voltiacBlaze) and player:TalentKnown(ElementalSpirits.id) and not player:TalentKnown(WitchDoctorsAncestry.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lightning_bolt,if=buff.arc_discharge.up&talent.deeply_rooted_elements.enabled
LightningBolt:Callback("st6", function(spell)
    if player:Buff(buffs.arcDischarge) and player:TalentKnown(DeeplyRootedElements.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lava_lash,if=buff.hot_hand.up|(buff.ashen_catalyst.stack=buff.ashen_catalyst.max_stack)
LavaLash:Callback("st2", function(spell)
    if player:Buff(buffs.hotHand) or player:HasBuffCount(buffs.ashenCatalyst) >= 3 then
        return spell:Cast(target)
    end
end)
-- actions.single+=/stormstrike,if=buff.doom_winds.up|(talent.stormblast.enabled&buff.stormsurge.up&charges=max_charges)
Stormstrike:Callback("st5", function(spell)
    if player:Buff(buffs.doomWinds) then
        return spell:Cast(target)
    end 
    
    local charges = C_Spell.GetSpellCharges(spell.id)
    if player:TalentKnown(Stormblast.id) and player:Buff(buffs.stormsurge) and charges.currentCharges == charges.maxCharges then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lava_lash,if=talent.lashing_flames.enabled&!buff.doom_winds.up
LavaLash:Callback("st3", function(spell)
    if player:TalentKnown(LashingFlames.id) and not player:Buff(buffs.doomWinds) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/voltaic_blaze,if=talent.elemental_spirits.enabled&!buff.doom_winds.up
FlameShock:Callback("st3", function(spell)
    if player:Buff(buffs.voltiacBlaze) and player:TalentKnown(ElementalSpirits.id) and not player:Buff(buffs.doomWinds) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/crash_lightning,if=talent.unrelenting_storms.enabled&talent.elemental_spirits.enabled&!talent.deeply_rooted_elements.enabled
CrashLightning:Callback("st", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(UnrelentingStorms.id) and player:TalentKnown(ElementalSpirits.id) and not player:TalentKnown(DeeplyRootedElements.id) then
        return spell:Cast()
    end
end)
-- actions.single+=/ice_strike,if=talent.elemental_assault.enabled&talent.swirling_maelstrom.enabled&talent.witch_doctors_ancestry.enabled
IceStrike:Callback("st", function(spell)
    if player:TalentKnown(ElementalAssault.id) and player:TalentKnown(SwirlingMaelstrom.id) and player:TalentKnown(WitchDoctorsAncestry.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/stormstrike
Stormstrike:Callback("st6", function(spell)
    return spell:Cast(target)
end)
-- actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5&talent.ascendance.enabled&!talent.legacy_of_the_frost_witch.enabled
LightningBolt:Callback("st7", function(spell)
    if gs.maelstrom >= 5 and player:TalentKnown(Ascendance.id) and not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/crash_lightning,if=talent.unrelenting_storms.enabled
CrashLightning:Callback("st2", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(UnrelentingStorms.id) then
        return spell:Cast()
    end
end)
-- actions.single+=/voltaic_blaze
FlameShock:Callback("st4", function(spell)
    if player:Buff(buffs.voltiacBlaze) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/sundering,if=!talent.elemental_spirits.enabled&raid_event.adds.in>=action.sundering.cooldown
Sundering:Callback("st", function(spell)
    if target.distance > 5 then return end

    if not player:TalentKnown(ElementalSpirits.id) then
        return spell:Cast()
    end
end)
-- actions.single+=/frost_shock,if=buff.hailstorm.up&buff.ice_strike.up&talent.swirling_maelstrom.enabled&talent.ascendance.enabled
FrostShock:Callback("st", function(spell)
    if player:Buff(buffs.hailstorm) and player:Buff(buffs.iceStrike) and player:TalentKnown(SwirlingMaelstrom.id) and player:TalentKnown(Ascendance.id) then
        return spell:Cast(target)
    end
end)
--actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5&feral_spirit.active>=4&talent.deeply_rooted_elements.enabled&(charges_fractional>=1.8|(buff.molten_weapon.stack+buff.icy_edge.stack>=4))&!talent.flowing_spirits.enabled
ElementalBlast:Callback("st3", function(spell)
    if gs.maelstrom >= 5 and gs.activeWolves >= 4 and player:TalentKnown(DeeplyRootedElements.id) and (spell.frac >= 1.8 or (player:HasBuffCount(buffs.moltenWeapon) + player:HasBuffCount(buffs.icyEdge) >= 4)) and not player:TalentKnown(FlowingSpirits.id) then
        return spell:Cast(target)
    end
end)
--actions.single+=/crash_lightning,if=talent.alpha_wolf.enabled&feral_spirit.active&alpha_wolf_min_remains=0
CrashLightning:Callback("st3", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(AlphaWolf.id) and gs.activeWolves >= 1 then
        return spell:Cast()
    end
end)
--actions.single+=/flame_shock,if=!ticking&!talent.tempest.enabled
FlameShock:Callback("st5", function(spell)
    if not target:Debuff(debuffs.flameShock, true) and not player:TalentKnown(TempestTalent.id) then
        return spell:Cast(target)
    end
end)
--actions.single+=/doom_winds,if=raid_event.adds.in>=action.doom_winds.cooldown&talent.elemental_spirits.enabled
DoomWinds:Callback("st2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if player:TalentKnown(ElementalSpirits.id) then
        return spell:Cast()
    end
end)
--actions.single+=/lava_lash,if=talent.elemental_assault.enabled&talent.tempest.enabled&talent.molten_assault.enabled&talent.deeply_rooted_elements.enabled&dot.flame_shock.ticking
LavaLash:Callback("st4", function(spell)
    if player:TalentKnown(ElementalAssault.id) and player:TalentKnown(TempestTalent.id) and player:TalentKnown(MoltenAssault.id) and player:TalentKnown(DeeplyRootedElements.id) and target:Debuff(debuffs.flameShock, true) then
        return spell:Cast(target)
    end
end)
--actions.single+=/ice_strike,if=talent.elemental_assault.enabled&talent.swirling_maelstrom.enabled
IceStrike:Callback("st2", function(spell)
    if player:TalentKnown(ElementalAssault.id) and player:TalentKnown(SwirlingMaelstrom.id) then
        return spell:Cast(target)
    end
end)
--actions.single+=/lightning_bolt,if=buff.arc_discharge.up
LightningBolt:Callback("st8", function(spell)
    if player:Buff(buffs.arcDischarge) then
        return spell:Cast(target)
    end
end)
--actions.single+=/crash_lightning,if=talent.unrelenting_storms.enabled
CrashLightning:Callback("st4", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(UnrelentingStorms.id) then
        return spell:Cast()
    end
end)
--actions.single+=/lava_lash,if=talent.elemental_assault.enabled&talent.tempest.enabled&talent.molten_assault.enabled&dot.flame_shock.ticking
LavaLash:Callback("st5", function(spell)
    if player:TalentKnown(ElementalAssault.id) and player:TalentKnown(TempestTalent.id) and player:TalentKnown(MoltenAssault.id) and target:Debuff(debuffs.flameShock, true) then
        return spell:Cast(target)
    end
end)
--actions.single+=/frost_shock,if=buff.hailstorm.up&buff.ice_strike.up&talent.swirling_maelstrom.enabled&talent.tempest.enabled
FrostShock:Callback("st2", function(spell)
    if player:Buff(buffs.hailstorm) and player:Buff(buffs.iceStrike) and player:TalentKnown(SwirlingMaelstrom.id) and player:TalentKnown(TempestTalent.id) then
        return spell:Cast(target)
    end
end)

-- actions.single+=/flame_shock,if=!ticking
FlameShock:Callback("st6", function(spell)
    if not target:Debuff(debuffs.flameShock, true) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/lava_lash,if=talent.lashing_flames.enabled
LavaLash:Callback("st6", function(spell)
    if player:TalentKnown(LashingFlames.id) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/ice_strike,if=!buff.ice_strike.up
IceStrike:Callback("st3", function(spell)
    if not player:Buff(buffs.iceStrike) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/frost_shock,if=buff.hailstorm.up
FrostShock:Callback("st3", function(spell)
    if player:Buff(buffs.hailstorm) then
        return spell:Cast(target)
    end
end)
-- actions.single+=/crash_lightning,if=talent.converging_storms.enabled
CrashLightning:Callback("st5", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(ConvergingStorms.id) then
        return spell:Cast()
    end
end)
-- actions.single+=/lava_lash
LavaLash:Callback("st7", function(spell)
    return spell:Cast(target)
end)
-- actions.single+=/ice_strike
IceStrike:Callback("st4", function(spell)
    return spell:Cast(target)
end)
-- actions.single+=/stormstrike
Stormstrike:Callback("st7", function(spell)
    return spell:Cast(target)
end)
-- actions.single+=/sundering,if=raid_event.adds.in>=action.sundering.cooldown
Sundering:Callback("st2", function(spell)
    if target.distance > 5 then return end

    return spell:Cast()
end)
-- actions.single+=/frost_shock
FrostShock:Callback("st4", function(spell)
    return spell:Cast(target)
end)
-- actions.single+=/crash_lightning
CrashLightning:Callback("st6", function(spell)
    if not LavaLash:InRange(target) then return end
    return spell:Cast()
end)
-- actions.single+=/fire_nova,if=active_dot.flame_shock
FireNova:Callback("st", function(spell)
    if target:Debuff(debuffs.flameShock, true) then
        return spell:Cast()
    end
end)
-- actions.single+=/earth_elemental
EarthElemental:Callback("st", function(spell)
    return spell:Cast()
end)
-- actions.single+=/flame_shock
FlameShock:Callback("st7", function(spell)
    return spell:Cast(target)
end)

local function st()
    FeralSpirit("st")
    Stormstrike("st")
    PrimordialWave("st")
    LavaLash("st")
    Stormstrike("st2")
    FeralSpirit("st2")
    Ascendance("st")
    LightningBolt("st")
    ElementalBlast("st")
    Stormstrike("st3")
    DoomWinds("st")
    Stormstrike("st4")
    FlameShock("st")
    LightningBolt("st2")
    LightningBolt("st3")
    PrimordialWave("st2")
    ElementalBlast("st2")
    LightningBolt("st4")
    LightningBolt("st5")
    FlameShock("st2")
    LightningBolt("st6")
    LavaLash("st2")
    Stormstrike("st5")
    LavaLash("st3")
    FlameShock("st3")
    CrashLightning("st")
    IceStrike("st")
    Stormstrike("st6")
    LightningBolt("st7")
    CrashLightning("st2")
    FlameShock("st4")
    Sundering("st")
    FrostShock("st")
    ElementalBlast("st3")
    CrashLightning("st3")
    FlameShock("st5")
    DoomWinds("st2")
    LavaLash("st4")
    IceStrike("st2")
    LightningBolt("st8")
    CrashLightning("st4")
    LavaLash("st5")
    FrostShock("st2")
    FlameShock("st6")
    LavaLash("st6")
    IceStrike("st3")
    FrostShock("st3")
    CrashLightning("st5")
    LavaLash("st7")
    IceStrike("st4")
    Stormstrike("st7")
    Sundering("st2")
    FrostShock("st4")
    CrashLightning("st6")
    FireNova("st")
    EarthElemental("st")
    FlameShock("st7")
end

-- actions.single_totemic=surging_totem
SurgingTotem:Callback("st_totemic", function(spell)
    if not player.inCombat then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/ascendance,if=ti_lightning_bolt&pet.surging_totem.remains>4&(buff.totemic_rebound.stack>=3|buff.maelstrom_weapon.stack>0)
Ascendance:Callback("st_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if target.distance > 5 then return end

    if gs.tiSpell ~= LightningBolt.id then return end
    if not isTotemActive(SurgingTotem) then return end
    if SurgingTotem.used > 20000 then return end
    if player:HasBuffCount(buffs.totemicRebound) < 3 and gs.maelstrom <= 0 then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/doom_winds,if=raid_event.adds.in>=action.doom_winds.cooldown&!talent.elemental_spirits.enabled&buff.legacy_of_the_frost_witch.up
DoomWinds:Callback("st_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if player:TalentKnown(ElementalSpirits.id) then return end
    if not player:Buff(buffs.legacyOfTheFrostWitch) then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/sundering,if=buff.ascendance.up&pet.surging_totem.active&talent.earthsurge.enabled&buff.legacy_of_the_frost_witch.up&buff.totemic_rebound.stack>=5&buff.earthen_weapon.stack>=2
Sundering:Callback("st_totemic", function(spell)
    if target.distance > 5 then return end

    if not gs.ascendance then return end
    if not isTotemActive(SurgingTotem) then return end
    if not player:TalentKnown(Earthsurge.id) then return end
    if not player:Buff(buffs.legacyOfTheFrostWitch) then return end
    if player:HasBuffCount(buffs.totemicRebound) < 5 then return end
    if player:HasBuffCount(buffs.earthenWeapon) < 2 then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/crash_lightning,if=talent.unrelenting_storms.enabled&talent.alpha_wolf.enabled&alpha_wolf_min_remains=0&buff.earthen_weapon.stack>=8
CrashLightning:Callback("st_totemic", function(spell)
    if not LavaLash:InRange(target) then return end
    if not player:TalentKnown(UnrelentingStorms.id) then return end
    if not player:TalentKnown(AlphaWolf.id) then return end
    if gs.activeWolves > 0 then return end
    if player:HasBuffCount(buffs.earthenWeapon) < 8 then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/windstrike,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>0&ti_lightning_bolt&!talent.elemental_spirits.enabled
Stormstrike:Callback("st_totemic", function(spell)
    if not gs.ascendance then return end

    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges == 0 then return end

    if not player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom <= 0 then return end
    if gs.tiSpell ~= LightningBolt.id then return end
    if player:TalentKnown(ElementalSpirits.id) then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/sundering,if=buff.legacy_of_the_frost_witch.up&cooldown.ascendance.remains>=10&pet.surging_totem.active&buff.totemic_rebound.stack>=3&!buff.ascendance.up
Sundering:Callback("st_totemic2", function(spell)
    if target.distance > 5 then return end

    if not player:Buff(buffs.legacyOfTheFrostWitch) then return end
    if Ascendance.cd < 10000 then return end
    if not isTotemActive(SurgingTotem) then return end
    if player:HasBuffCount(buffs.totemicRebound) < 3 then return end
    if gs.ascendance then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/primordial_wave,if=!dot.flame_shock.ticking&talent.molten_assault.enabled&(raid_event.adds.in>action.primordial_wave.cooldown|raid_event.adds.in<6)
PrimordialWave:Callback("st_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target:Debuff(debuffs.flameShock, true) then return end
    if not player:TalentKnown(MoltenAssault.id) then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/feral_spirit
FeralSpirit:Callback("st_totemic", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if player:TalentKnown(FlowingSpirits.id) then return end
    if target.distance > 15 and not Stormstrike:InRange(target) then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/elemental_blast,if=buff.maelstrom_weapon.stack=buff.maelstrom_weapon.max_stack&talent.elemental_spirits.enabled&feral_spirit.active>=6&(charges_fractional>=1.8|buff.ascendance.up)
ElementalBlast:Callback("st_totemic", function(spell)
    if gs.maelstrom < 10 then return end
    if not player:TalentKnown(ElementalSpirits.id) then return end
    if gs.activeWolves < 6 then return end

    if spell.frac >= 1.8 or gs.ascendance then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/voltaic_blaze,if=buff.whirling_earth.up
FlameShock:Callback("st_totemic", function(spell)
    if player:Buff(buffs.voltiacBlaze) and player:Buff(buffs.whirlingEarth) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/crash_lightning,if=talent.unrelenting_storms.enabled&talent.alpha_wolf.enabled&alpha_wolf_min_remains=0
CrashLightning:Callback("st_totemic", function(spell)
    if not LavaLash:InRange(target) then return end
    if not player:TalentKnown(UnrelentingStorms.id) then return end
    if not player:TalentKnown(AlphaWolf.id) then return end
    if gs.activeWolves > 0 then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/flame_shock,if=!ticking&talent.lashing_flames.enabled
FlameShock:Callback("st_totemic", function(spell)
    if target:Debuff(debuffs.flameShock, true) then return end
    if not player:TalentKnown(LashingFlames.id) then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/lava_lash,if=buff.hot_hand.up&!talent.legacy_of_the_frost_witch.enabled
LavaLash:Callback("st_totemic", function(spell)
    if player:Buff(buffs.hotHand) and not player:TalentKnown(LegacyOfTheFrostWitch.id) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5&charges=max_charges
ElementalBlast:Callback("st_totemic2", function(spell)
    if gs.maelstrom < 5 then return end

    local charges = C_Spell.GetSpellCharges(spell.id)
    if charges.currentCharges == charges.maxCharges then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=8&buff.primordial_wave.up&raid_event.adds.in>buff.primordial_wave.remains&(!buff.splintered_elements.up|fight_remains<=12)
LightningBolt:Callback("st_totemic3", function(spell)
    if gs.maelstrom < 8 then return end
    if not player:Buff(buffs.primordialWave) then return end
    if player:Buff(buffs.splinteredElements) then return end
    
    return spell:Cast(target)
end)
-- actions.single_totemic+=/elemental_blast,if=buff.maelstrom_weapon.stack>=8&(feral_spirit.active>=2|!talent.elemental_spirits.enabled)
ElementalBlast:Callback("st_totemic3", function(spell)
    if gs.maelstrom < 8 then return end
    if gs.activeWolves >= 2 or not player:TalentKnown(ElementalSpirits.id) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/lava_burst,if=!talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>=5
LavaBurst:Callback("st_totemic", function(spell)
    if player:TalentKnown(ElementalBlast.id) then return end
    if player:TalentKnown(ThorimsInvocation.id) then return end
    if gs.maelstrom < 5 then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/primordial_wave,if=(raid_event.adds.in>action.primordial_wave.cooldown)|raid_event.adds.in<6
PrimordialWave:Callback("st_totemic2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    return spell:Cast(target)
end)
-- actions.single_totemic+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5&(charges_fractional>=1.8|(buff.molten_weapon.stack+buff.icy_edge.stack>=4))&talent.ascendance.enabled&(feral_spirit.active>=4|!talent.elemental_spirits.enabled)
ElementalBlast:Callback("st_totemic4", function(spell)
    if gs.maelstrom < 5 then return end
    if (spell.frac >= 1.8 or (player:HasBuffCount(buffs.moltenWeapon) + player:HasBuffCount(buffs.icyEdge) >= 4)) and player:TalentKnown(Ascendance.id) and (gs.activeWolves >= 4 or not player:TalentKnown(ElementalSpirits.id)) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/elemental_blast,if=talent.ascendance.enabled&(buff.maelstrom_weapon.stack>=10|(buff.maelstrom_weapon.stack>=5&buff.whirling_air.up&!buff.legacy_of_the_frost_witch.up))
ElementalBlast:Callback("st_totemic5", function(spell)
    if not player:TalentKnown(Ascendance.id) then return end
    if gs.maelstrom >= 10 or (gs.maelstrom >= 5 and player:Buff(buffs.whirlingAir) and not player:Buff(buffs.legacyOfTheFrostWitch)) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/lightning_bolt,if=talent.ascendance.enabled&(buff.maelstrom_weapon.stack>=10|(buff.maelstrom_weapon.stack>=5&buff.whirling_air.up&!buff.legacy_of_the_frost_witch.up))
LightningBolt:Callback("st_totemic4", function(spell)
    if not player:TalentKnown(Ascendance.id) then return end
    if gs.maelstrom >= 10 or (gs.maelstrom >= 5 and player:Buff(buffs.whirlingAir) and not player:Buff(buffs.legacyOfTheFrostWitch)) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/lava_lash,if=buff.hot_hand.up&talent.molten_assault.enabled&pet.searing_totem.active
LavaLash:Callback("st_totemic5", function(spell)
    if player:Buff(buffs.hotHand) and player:TalentKnown(MoltenAssault.id) and isTotemActive(SearingTotem) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/windstrike
Stormstrike:Callback("st_totemic5", function(spell)
    if not gs.ascendance then return end

    local charges = C_Spell.GetSpellCharges(Windstrike.id)
    if charges.currentCharges == 0 then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/stormstrike
Stormstrike:Callback("st_totemic6", function(spell)
    return spell:Cast(target)
end)
-- actions.single_totemic+=/lava_lash,if=talent.molten_assault.enabled
LavaLash:Callback("st_totemic6", function(spell)
    if not player:TalentKnown(MoltenAssault.id) then return end
    return spell:Cast(target)
end)
-- actions.single_totemic+=/crash_lightning,if=talent.unrelenting_storms.enabled
CrashLightning:Callback("st_totemic5", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(UnrelentingStorms.id) then
        return spell:Cast()
    end
end)
-- actions.single_totemic+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5&talent.ascendance.enabled
LightningBolt:Callback("st_totemic5", function(spell)
    if gs.maelstrom >= 5 and player:TalentKnown(Ascendance.id) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/ice_strike,if=!buff.ice_strike.up
IceStrike:Callback("st_totemic3", function(spell)
    if not player:Buff(buffs.iceStrike) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/frost_shock,if=buff.hailstorm.up&pet.searing_totem.active
FrostShock:Callback("st_totemic4", function(spell)
    if player:Buff(buffs.hailstorm) and isTotemActive(SearingTotem) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/lava_lash
LavaLash:Callback("st_totemic7", function(spell)
    return spell:Cast(target)
end)
-- actions.single_totemic+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5&feral_spirit.active>=4&talent.deeply_rooted_elements.enabled&(charges_fractional>=1.8|(buff.icy_edge.stack+buff.molten_weapon.stack>=4))
ElementalBlast:Callback("st_totemic6", function(spell)
    if gs.maelstrom >= 5 and gs.activeWolves >= 4 and player:TalentKnown(DeeplyRootedElements.id) and (spell.frac >= 1.8 or (player:HasBuffCount(buffs.icyEdge) + player:HasBuffCount(buffs.moltenWeapon) >= 4)) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/doom_winds,if=raid_event.adds.in>=action.doom_winds.cooldown&talent.elemental_spirits.enabled
DoomWinds:Callback("st_totemic2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not Stormstrike:InRange(target) then return end

    if player:TalentKnown(ElementalSpirits.id) then
        return spell:Cast()
    end
end)
-- actions.single_totemic+=/flame_shock,if=!ticking&!talent.voltaic_blaze.enabled
FlameShock:Callback("st_totemic6", function(spell)
    if not target:Debuff(debuffs.flameShock, true) and not player:TalentKnown(buffs.voltiacBlaze) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/frost_shock,if=buff.hailstorm.up
FrostShock:Callback("st_totemic5", function(spell)
    if player:Buff(buffs.hailstorm) then
        return spell:Cast(target)
    end
end)
-- actions.single_totemic+=/crash_lightning,if=talent.converging_storms.enabled
CrashLightning:Callback("st_totemic6", function(spell)
    if not LavaLash:InRange(target) then return end
    if player:TalentKnown(ConvergingStorms.id) then
        return spell:Cast()
    end
end)
-- actions.single_totemic+=/frost_shock
FrostShock:Callback("st_totemic6", function(spell)
    return spell:Cast(target)
end)
-- actions.single_totemic+=/crash_lightning
CrashLightning:Callback("st_totemic7", function(spell)
    if not LavaLash:InRange(target) then return end
    return spell:Cast()
end)
-- actions.single_totemic+=/fire_nova,if=active_dot.flame_shock
FireNova:Callback("st_totemic", function(spell)
    if target:Debuff(debuffs.flameShock, true) then
        return spell:Cast()
    end
end)
-- actions.single_totemic+=/earth_elemental
EarthElemental:Callback("st_totemic", function(spell)
    return spell:Cast()
end)
-- actions.single_totemic+=/flame_shock,if=!talent.voltaic_blaze.enabled
FlameShock:Callback("st_totemic7", function(spell)
    if not player:TalentKnown(buffs.voltiacBlaze) then
        return spell:Cast(target)
    end
end)

local function stTotemic()
    SurgingTotem("st_totemic")
    Ascendance("st_totemic")
    DoomWinds("st_totemic")
    Sundering("st_totemic")
    CrashLightning("st_totemic")
    Stormstrike("st_totemic")
    Sundering("st_totemic2")
    PrimordialWave("st_totemic")
    FeralSpirit("st_totemic")
    ElementalBlast("st_totemic")
    FlameShock("st_totemic")
    CrashLightning("st_totemic")
    FlameShock("st_totemic")
    LavaLash("st_totemic")
    ElementalBlast("st_totemic2")
    LightningBolt("st_totemic3")
    ElementalBlast("st_totemic3")
    LavaBurst("st_totemic")
    PrimordialWave("st_totemic2")
    ElementalBlast("st_totemic4")
    ElementalBlast("st_totemic5")
    LightningBolt("st_totemic4")
    LavaLash("st_totemic5")
    Stormstrike("st_totemic5")
    Stormstrike("st_totemic6")
    LavaLash("st_totemic6")
    CrashLightning("st_totemic5")
    LightningBolt("st_totemic5")
    IceStrike("st_totemic3")
    FrostShock("st_totemic4")
    LavaLash("st_totemic7")
    ElementalBlast("st_totemic6")
    DoomWinds("st_totemic2")
    FlameShock("st_totemic6")
    FrostShock("st_totemic5")
    CrashLightning("st_totemic6")
    FrostShock("st_totemic6")
    CrashLightning("st_totemic7")
    FireNova("st_totemic")
    EarthElemental("st_totemic")
    FlameShock("st_totemic7")
end

GroundingTotem:Callback("arena", function(spell)
    if target.exists and target.canAttack and target.hp < 20 then return end
    if WindShear:Cooldown() == 0 then return end
    --TEST
    --if target.exists and target:PvpKick(Maklists.arenaGrounding) then
    --    return spell:Cast(player)
    --end
    if arena1.exists and arena1:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast(player)
    end

    if arena2.exists and arena2:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast(player)
    end

    if arena3.exists and arena3:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast(player)
    end
end)

--TripQ -- We need to make sure the fear has been on target for at least 0.5 seconds before we tremor it and that the remaining duration on fear is at least x second.
TremorTotem:Callback("arena", function(spell)
    local onlyHeals = A.GetToggle(2, "OnlyTremorHealer")
    if target.exists and target.hp < 20 then return end

    if (party1.isHealer or not onlyHeals) and party1:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        print("Tremor on party1")
        return spell:Cast(player)
    end
 
    if (party2.isHealer or not onlyHeals) and party2:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        print("Tremor on party2")
        return spell:Cast(player)
    end
end)

--##############################
--###### PVP ###################
--##############################

--PVP CALLBACKS 

Ascendance:Callback("pvp", function(spell)
    
    if target.distance > 5 then return end
    if not target:Debuff(debuffs.flameShock, true) then return end
    -- Only use when DoomWinds is ready
    if DoomWinds:Cooldown() ~= 0 then return end

    return spell:Cast()
end)

DoomWinds:Callback("pvp", function(spell)
    
    if target.distance > 5 then return end
    -- Only use if Ascendance is up or has 50+ secs left on CD
    local ascendanceUp = player:Buff(Ascendance.id)
    local ascendanceCD = Ascendance:Cooldown()
    if not ascendanceUp and ascendanceCD > 0 and ascendanceCD < 50000 then return end

    return spell:Cast()
end)

Tempest:Callback("pvp", function(spell)
    local maelstromThreshold = target.hp > 50 and 8 or 5
    if gs.maelstrom < maelstromThreshold then return end

    return spell:Cast()
end)

LightningBolt:Callback("pvp", function(spell)
    local maelstromThreshold = target.hp > 50 and 8 or 5
    if gs.maelstrom < maelstromThreshold then return end

    return spell:Cast()
end)

FlameShock:Callback("pvp", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 3000 then return end

    return spell:Cast()
end)

PrimordialWave:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if gs.maelstrom >= 5 then return end
    if not target:Debuff(debuffs.flameShock, true) then return end

    return spell:Cast(target)
end)

Windstrike:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if target.distance > 5 then return end

    return spell:Cast(target)
end)

FrostShock:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if player:HasBuffCount(buffs.hailstorm) < 10 then return end
    if not player:Buff(buffs.iceStrike) then return end

    return spell:Cast(target)
end)

IceStrike:Callback("pvp", function(spell)
    if gs.maelstrom >= 5 then return end
    if player:TalentKnown(ElementalAssault.id) and player:TalentKnown(SwirlingMaelstrom.id) then
        return spell:Cast(target)
    end
end)

FeralLunge:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if target.distance < 15 or target.distance > 25 then return end
    return spell:Cast(target)
end)

TotemicRecall:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if not isAnyTotemActive() then return end

    local tremorCD = TremorTotem:Cooldown()
    local groundingCD = GroundingTotem:Cooldown()

    -- Check if Tremor Totem is on cooldown between 5-10 seconds
    local tremorRecallable = tremorCD > 5000 and tremorCD < 10000

    -- Check if there's an enemy with Fear/Charm/Sleep (Warlock 9, Priest 5, Warrior 1) for Tremor
    local hasFearClass = (arena1.exists and (arena1:ClassID() == 9 or arena1:ClassID() == 5 or arena1:ClassID() == 1))
                      or (arena2.exists and (arena2:ClassID() == 9 or arena2:ClassID() == 5 or arena2:ClassID() == 1))
                      or (arena3.exists and (arena3:ClassID() == 9 or arena3:ClassID() == 5 or arena3:ClassID() == 1))

    -- Check if there's an enemy Mage (8) or Druid (11) for Grounding
    local hasEnemyCaster = (arena1.exists and (arena1:ClassID() == 8 or arena1:ClassID() == 11))
                        or (arena2.exists and (arena2:ClassID() == 8 or arena2:ClassID() == 11))
                        or (arena3.exists and (arena3:ClassID() == 8 or arena3:ClassID() == 11))

    -- Use if Tremor is recallable with fear class OR (Grounding is on cooldown AND enemy has Mage/Druid)
    if (tremorRecallable and hasFearClass) or (groundingCD > 0 and hasEnemyCaster) then
        return spell:Cast()
    end
end)

GhostWolf:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if not player:TalentKnown(ThunderousPaws.id) then return end
    if not player:IsRooted() then return end

    return spell:Cast()
end)

SurgingTotem:Callback("pvp", function(spell)
    if not player.inCombat then return end


    return spell:Cast()
end)

PrimordialStorm:Callback("pvp", function(spell)
    if not player.inCombat then return end
    if target.distance > 5 then return end

    return spell:Cast()
end)

Stormstrike:Callback("pvp", function(spell)
    if not player.inCombat then return end
    

    return spell:Cast()
end)

local function PVPRotation()

    --Always First 
    Ascendance("pvp")
    DoomWinds("pvp")
    Windstrike("pvp")

    --Keep this Up 
    FlameShock("pvp")
    PrimordialWave("pvp")

    if A.SurgingTotem:IsTalentLearned() then
        PrimordialStorm("pvp")
        stTotemic()
    end

    -- BURST 
    Tempest("pvp")
    LightningBolt("pvp")

    --Movement
    GhostWolf("pvp")
    FeralLunge("pvp")

    PrimordialWave("st")
    FeralSpirit("st")
    Stormstrike("pvp")
    LavaLash("st")
    IceStrike("pvp")
    FrostShock("pvp")
    Stormstrike("st2")
    FeralSpirit("st2")
    LightningBolt("st")
    ElementalBlast("st")
    Stormstrike("st3")
    Stormstrike("st4")
    LightningBolt("st2")
    LightningBolt("st3")
    PrimordialWave("st2")
    ElementalBlast("st2")
    LightningBolt("st4")
    LightningBolt("st5")
    LightningBolt("st6")
    LavaLash("st2")
    Stormstrike("st5")
    LavaLash("st3")
    CrashLightning("st")
    Stormstrike("st6")
    LightningBolt("st7")
    CrashLightning("st2")
    Sundering("st")
    FrostShock("st")
    ElementalBlast("st3")
    CrashLightning("st3")
    LavaLash("st4")
    LightningBolt("st8")
    CrashLightning("st4")
    LavaLash("st5")
    FrostShock("st2")
    LavaLash("st6")
    FrostShock("st3")
    CrashLightning("st5")
    LavaLash("st7")
    Stormstrike("st7")
    Sundering("st2")
    FrostShock("st4")
    CrashLightning("st6")
    FireNova("st")
    EarthElemental("st")
    FrostShock("pvp")
    -- Gap Closer 
    FeralLunge("pvp")



end 

--########################################
--######### Healing ######################
--########################################

-- Healing Callbacks

StoneBulwarkTotem:Callback("party", function(spell, friendly)
    if not player.inCombat then return end
    if spell:Cooldown() > 0 then return end

    local bulwarkHP = A.GetToggle(2, "stoneBulwarkTotemHP") or 50
    if friendly.hp > bulwarkHP then return end

    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast()
end)

HealingStreamTotem:Callback("party", function(spell, friendly)
    if not player.inCombat then return end
    if spell:Cooldown() > 0 then return end
    if isTotemActive(HealingStreamTotem) then return end

    local streamHP = A.GetToggle(2, "healingStreamTotemHP") or 80
    if friendly.hp > streamHP then return end

    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast()
end)

HealingSurge:Callback("party", function(spell, friendly)
    if friendly.hp > A.GetToggle(2, "healingSurgeHP") then return end
    if player:Buff(buffs.ancestralGuidance) then return end
    if not spell:InRange(friendly) then return end

    if player:TalentKnown(Stormweaver.id) then
        if player:HasBuffCount(buffs.stormweaver) >= 5 then
            HealingEngine.SetTarget(friendly:CallerId(), 1)
            return spell:Cast(friendly)
        end
    else
        if player:HasBuffCount(buffs.maelstromWeapon) >= 5 then
            HealingEngine.SetTarget(friendly:CallerId(), 1)
            return spell:Cast(friendly)
        end
    end
end)

local function HealingRotation()
    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end

    StoneBulwarkTotem("party", unit)
    HealingStreamTotem("party", unit)
    HealingSurge("party", unit)
end

A[3] = function(icon)
	FrameworkStart(icon)
    updategs()
    

    local wolfCount = countWolves()
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Remaining for Tempest: ", gs.remainingForTempest)
        MakPrint(2, "Target Distance: ", target.distance)
        MakPrint(3, "Surging Totem Active: ", isTotemActive(SurgingTotem))
        MakPrint(4, "Searing Totem Active: ", isTotemActive(SearingTotem))
        MakPrint(5, "Wolves active: ", gs.activeWolves)
        MakPrint(6, "Rod Count: ", gs.rodCount)
        MakPrint(7, "Lightning Bolt Used: ", LightningBolt.used)
        MakPrint(8, "Chain Lightning Used: ", ChainLightning.used)
        MakPrint(9, "Tempest Used: ", Tempest.used)
        MakPrint(10, "TI Spell: ", gs.tiSpell)
        MakPrint(11, "Unit Classification: ", UnitClassification(target:CallerId()))
        MakPrint(12, "Should Burst: ", shouldBurst())
    end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then

    end

    if A.GetToggle(2, "pauseWhenWolf") and player:Buff(GhostWolf.wowName) then return end

    makInterrupt(interrupts)

    AstralShift()
    TotemicRecall()
    TotemicRecall("pvp")
    --StoneBulwarkTotem()
    AncestralGuidance()
    EarthElemental()

    if Action.Zone == "arena" then
        GroundingTotem("arena")
        TremorTotem("arena")
    end
    
    EarthShield()
    Skyfury()
    Skyfury("buff")
    WindfuryWeapon()
    FlametongueWeapon()
    LightningShield()
    HealingSurge("self")
    PoisonCleansingTotem()


    if target.exists and target.canAttack and ChainLightning:InRange(target) then
    
        if shouldBurst() and LavaLash:InRange(target) then
            Bloodlust("arena")
            BloodFury()
            Berserking()
            Fireblood()
            AncestralCall()

            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
            
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = gs.cdUp
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        if InPvP() then   

            HealingRotation()  
            PVPRotation()

        end 


        if NotInPvP() and player:TalentKnown(SurgingTotem.id) then
            if gs.activeEnemies > 1 then
                aoeTotemic()
            else
                stTotemic()
            end
        else
            if gs.activeEnemies > 1 then
                aoe()
            else
                st()
            end
        end

    end

	return FrameworkEnd()
end

CleanseSpirit:Callback("pve", function(spell, friendly) 
    local imCursed = player.cursed
    local shouldDispel = friendly.cursed

    --Hopefully this makes it self prio
    if imCursed then
        if not friendly.isMe then return end
    end

    if not shouldDispel then return end

    return Debounce("cleanse", 1000, 2500, spell, friendly)
end)

Purge:Callback("arena", function(spell, enemy)
    if not isValidTarget(enemy) then return end
    if not A.Purge:IsTalentLearned() then return end
    if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end

    return spell:Cast(enemy)
end)

GreaterPurge:Callback("arena", function(spell, enemy)
    if not isValidTarget(enemy) then return end
    if not A.GreaterPurge:IsTalentLearned() then return end
    if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end

    return spell:Cast(enemy)
end)

WindShear:Callback("arena", function(spell, enemy)
    if not isValidTarget(enemy) then return end
    if enemy:IsKickImmune() then return end
    if player:Buff(buffs.grounding) then return end
    if enemy:BuffFrom(MakLists.KickImmune) then return end
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

Hex:Callback("arena", function(spell, enemy)
    if not isValidTarget(enemy) then return end

    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if enemy:IsCCImmune() then return end

    if player.hp < 30 then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if enemy:IsTarget() then return end
    if target.hp < 20 then return end
    if enemy:BuffFrom(MakLists.hexImmune) then return end

    if ccRemains > Hex:CastTime() + MakGcd() then return end
    if enemy.incapacitateDr < 0.5 then return end

    local aware = A.GetToggle(2, "makAware")

    if enemy.isHealer and target.hp <= 70 then
        if aware[1] then
            Aware:displayMessage("Hexing Healer", "Green", 1)
        end
        return spell:Cast(enemy)
    end

    local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party2.hp > 0 and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        if aware[1] then
            Aware:displayMessage("Hexing To Peel", "Red", 1)
        end
        return spell:Cast(enemy)
    end

    if enemy.cds and enemy.hp > 40 then
        if aware[1] then
            Aware:displayMessage("Hexing On Enemy CDs", "Red", 1)
        end
        return spell:Cast(enemy)
    end
end)

HealingSurgeParty:Callback("party", function(spell, friendly)
    if friendly.hp > A.GetToggle(2, "healingSurgeHP") then return end
    if player:Buff(buffs.ancestralGuidance) then return end

    if player:TalentKnown(Stormweaver.id) then
        if player:HasBuffCount(buffs.stormweaver) >= 5 then
            HealingEngine.SetTarget(friendly:CallerId(), 1)
            return spell:Cast(friendly, nil, icon)
        end
    else
        if player:HasBuffCount(buffs.maelstromWeapon) >= 5 then
            HealingEngine.SetTarget(friendly:CallerId(), 1)
            return spell:Cast(friendly, nil, icon)
        end
    end
end)

EarthShieldParty:Callback("party", function(spell, friendly)
    if friendly:Buff(buffs.earthShield) then return end
    if friendly:Buff(buffs.earthShieldOrbit) then return end
    if not A.ElementalOrbit:IsTalentLearned() then return end
    if target.hp < 50 then return end

    if earthShieldCount() > 1 then return end
    if player.combatTime > 0 and friendly.hp > 40 then return end
    if Action.Zone == "arena" then
        if party2.exists then
            if not friendly.isHealer then
                HealingEngine.SetTarget(friendly:CallerId(), 1)
                return Debounce("ES", 1500, 5000, spell, friendly)
            end
        else
            HealingEngine.SetTarget(friendly:CallerId(), 1)
            return Debounce("ES2", 1500, 5000, spell, friendly)
        end
    else
        if friendly.hp > 0 then
            if friendly.isTank then
                HealingEngine.SetTarget(friendly:CallerId(), 1)
                return spell:Cast(friendly)
            end
        end
    end
end)

-- Bloodlust when we have ascendance up on party1 or party2 if they are a dps or if no friendly healer exists on either one of them
BloodlustShamanism:Callback("party", function(spell, friendly)
    if not friendly.exists then return end
    if friendly.distance >= 35 then return end
    if not player:Buff(buffs.ascendance) and not player:Buff(buffs.doomWinds) then return end
    if healer.exists and friendly:IsUnit(healer) then return end

    return spell:Cast(friendly)
end)

HeroismShamanism:Callback("party", function(spell, friendly)
    if not friendly.exists then return end
    if friendly.distance >= 35 then return end
    if not player:Buff(buffs.ascendance) and not player:Buff(buffs.doomWinds) then return end
    if healer.exists and friendly:IsUnit(healer) then return end

    return spell:Cast(friendly)
end)

local flameShockFailedAttempts = {}

FlameShock:Callback("arena", function (spell, enemy)
    local enemyID = enemy.id

    -- Check if we recently failed to cast on this enemy (5 second delay)
    local failedTime = flameShockFailedAttempts[enemyID]
    if failedTime and (GetTime() - failedTime) < 5 then
        return
    end

    -- If not in LoS, mark as failed and wait 5 seconds
    if not enemy:Los() then
        flameShockFailedAttempts[enemyID] = GetTime()
        return
    end

    if enemy.distance > 25 then return end
    if not isValidTarget(enemy) then return end
    if player:Debuff(410201) then return end
    if enemy:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if enemy.ccRemains > 0 then return end

    return spell:Cast(enemy)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    Purge("arena", enemy)
    GreaterPurge("arena", enemy)
    WindShear("arena", enemy)
    Hex("arena", enemy)
    FlameShock("arena", enemy)

end

local partyRotation = function(friendly)
    if not friendly.exists then return end

    BloodlustShamanism("party", friendly)
    HeroismShamanism("party", friendly)
    HealingSurgeParty("party", friendly)
    CleanseSpirit("pve", friendly)
    EarthShieldParty("party", friendly)

end

A[6] = function(icon)
	RegisterIcon(icon)
    partyRotation(party1)
    enemyRotation(arena1)

    if NotInPvP() and A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if NotInPvP() and autoTarget() then return TabTarget() end

	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)
    partyRotation(party2)
    enemyRotation(arena2)

	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)
    partyRotation(party3)
    enemyRotation(arena3)

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
