--[[

simc commit: TWW3 / thewarwithin / 08 August 2025

Updated APL based on latest warlock_affliction.simc from SimulationCraft
- Updated single target rotation priority based on latest APL
- Updated AoE rotation priority with new conditions
- Updated cleave rotation with improved logic
- Improved Malefic Rapture usage conditions
- Updated cooldown synchronization logic
- Added new variable tracking for better optimization

]]


if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 265 then return end

local FrameworkStart   = MakuluFramwork.start
local FrameworkEnd     = MakuluFramwork.endFunc
local RegisterIcon     = MakuluFramwork.registerIcon

local MakUnit          = MakuluFramwork.Unit
local MakSpell         = MakuluFramwork.Spell
local TableToLocal     = MakuluFramwork.tableToLocal
local MakGcd           = MakuluFramwork.gcd
local MakLists         = MakuluFramework.lists
local Debounce         = MakuluFramework.debounceSpell
local ConstUnit        = MakuluFramework.ConstUnits
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local _G, setmetatable = _G, setmetatable
local UnitIsUnit       = _G.UnitIsUnit

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
    
    --Baseline
    CommandDemon = { ID = 119898, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Corruption = { ID = 172, Texture = 81836, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CreateHealthstone = { ID = 6201, MAKULU_INFO = { ignoreCasting = true } },
    CreateSoulwell = { ID = 29893, MAKULU_INFO = { ignoreCasting = true } },
    CurseOfExhaustion = { ID = 334275, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CurseOfTongues = { ID = 1714, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CurseOfWeakness = { ID = 702, Texture = 236572, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DrainLife = { ID = 234153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EyeOfKilrogg = { ID = 126, MAKULU_INFO = { ignoreCasting = true } },
    Fear = { ID = 5782, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    HealthFunnel = { ID = 755, MAKULU_INFO = { ignoreCasting = true } },
    RitualOfDoom = { ID = 342601, MAKULU_INFO = { ignoreCasting = true } },
    RitualOfSummoning = { ID = 698, MAKULU_INFO = { ignoreCasting = true } },
    ShadowBolt = { ID = 686, Texture = 453080, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Soulstone = { ID = 20707, MAKULU_INFO = { ignoreCasting = true } },
    SubjugateDemon = { ID = 1098, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SummonImp = { ID = 688, MAKULU_INFO = { ignoreCasting = true } },
    SummonVoidwalker = { ID = 697, MAKULU_INFO = { ignoreCasting = true } },
    SummonFelhunter = { ID = 691, MAKULU_INFO = { ignoreCasting = true } },
    SummonSayaad = { ID = 366222, MAKULU_INFO = { ignoreCasting = true } },
    UnendingBreath = { ID = 5697, MAKULU_INFO = { ignoreCasting = true } },
    UnendingResolve = { ID = 104773, MAKULU_INFO = { ignoreCasting = true } },
    
    --Pets
    SingeMagic = { ID = 119905, MAKULU_INFO = { ignoreCasting = true, pet = true } }, 
    ShadowBulwark = { ID = 119907, MAKULU_INFO = { ignoreCasting = true, pet = true } },
    SpellLock = { ID = 19647, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, pet = true } },
    Seduction = { ID = 119909, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, pet = true } },
    
    SingeMagicSac = { ID = 132411, MAKULU_INFO = { ignoreCasting = true, pet = true } }, 
    ShadowBulwarkSac = { ID = 132413, MAKULU_INFO = { ignoreCasting = true, pet = true } },
    SpellLockSac = { ID = 132409, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, pet = true } },
    SeductionSac = { ID = 261589, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, pet = true } },
    
    --Class
    FelDomination = { ID = 333889, MAKULU_INFO = { ignoreCasting = true } },
    BurningRush = { ID = 111400, MAKULU_INFO = { ignoreCasting = true } },
    DemonicCircle = { ID = 48018, MAKULU_INFO = { ignoreCasting = true } },
    DemonicCircleTeleport = { ID = 48020, MAKULU_INFO = { ignoreCasting = true } },
    HowlOfTerror = { ID = 5484, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MortalCoil = { ID = 6789, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    AmplifyCurse = { ID = 328774, MAKULU_INFO = { ignoreCasting = true } },
    Banish = { ID = 710, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DemonicGateway = { ID = 111771, MAKULU_INFO = { ignoreCasting = true } },
    DarkPact = { ID = 108416, MAKULU_INFO = { ignoreCasting = true } },
    Shadowfury = { ID = 30283, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowflame = { ID = 384069, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Soulburn = { ID = 385899, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    
    --Spec
    Agony = { ID = 980, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MaleficRapture = { ID = 324536, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    UnstableAffliction = { ID = 316099, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SeedOfCorruption = { ID = 27243, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DrainSoul = { ID = 388667, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    GrimoireOfSacrifice = { ID = 108503, MAKULU_INFO = { ignoreCasting = true } },
    VileTaint = { ID = 278350, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PhantomSingularity = { ID = 205179, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Haunt = { ID = 48181, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SummonDarkglare = { ID = 205180, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SoulRot = { ID = 386997, FixedTexture = 3636850, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Oblivion = { ID = 417537, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    
    --Hero
    Wither = { ID = 445468, Texture = 81836, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CurseOfTheSatyr = { ID = 440057, Texture = 236572, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Malevolence = { ID = 442726, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    
    --PvP
    NetherWard = { ID = 212295, MAKULU_INFO = { ignoreCasting = true } },
    ShadowRift = { ID = 353294, MAKULU_INFO = { ignoreCasting = true } },
    CallObserver = { ID = 201996, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    BondsOfFel = { ID = 353753, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SoulRip = { ID = 410598, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    
    --Passives
    SoulSwap = { ID = 386951, Hidden = true },
    ShadowEmbrace = { ID = 32388, Hidden = true }, 
    AbsoluteCorruption = { ID = 196103, Hidden = true }, 
    RampartAfflictions = { ID = 335052, Hidden = true }, 
    DarkVirtuosity = { ID = 405327, Hidden = true }, 
    WitheringBolt = { ID = 386976, Hidden = true }, 
    DemonicSoul = { ID = 449614, Hidden = true },
    TormentedCrescendo = { ID = 387075, Hidden = true },
    
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

Action[ACTION_CONST_WARLOCK_AFFLICTION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "ShadowBolt", "Agony", "Corruption", "UnstableAffliction",
        "SeedOfCorruption", "DrainSoul", "VileTaint", "PhantomSingularity",
        "Haunt", "SummonDarkglare", "SoulRot", "Oblivion",
        "Wither", "CurseOfTheSatyr", "Malevolence", "MaleficRapture",
        "DrainLife"
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
    soulShards = 0,
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = nil,
    imCastingLength = nil,
    cursorCheck = false,
    psUp = false,
    vtUp = false,
    vtPsUp = false,
    srUp = false,
    cdDotsUp = false,
    hasCds = false,
    cdsActive = false,
    minVt = 10,
    minPs = 16,
    uaCount = 0,
    minAgony = 0,
    minAgonyTarget = nil,
    agonyCount = 0,
    canSeed = false,
    shadowEmbraceDebuff = 0,
    shadowEmbraceUp = false,
    darkglareActive = false,
    activeEnemies = 1,
    shouldCleave = false,
    shouldAoE = false,
    uaRemains = 0,
}

local buffs = {
    grimoireOfSacrifice = 196099,
    arenaPreparation = 32727,
    powerInfusion = 10060,
    tormentedCrescendo = 387079,
    umbrafireKindling = 423765,
    nightfall = 264571,
}

local debuffs = {
    exhaustion = 57723,
    curseOfExhaustion = 334275,
    curseOfTongues = 1714,
    curseOfWeakness = 702,
    curseOfTheSatyr = 442804,
    agony = 980,
    seedOfCorruption = 27243,
    corruption = 146739,
    wither = 445474,
    haunt = 48181,
    shadowEmbrace = 453206,
    shadowEmbraceDS = 32390,   
    soulRot = 386997,
    mortalCoil = 6789,
    unstableAffliction = 316099, 
    usntableAfflictionRA = 342938,
    phantomSingularity = 205179,
    vileTaint = 386931,
}

local interrupts = {
    { spell = SpellLock },
    { spell = SpellLockSac },
    { spell = MortalCoil, isCC = true },
    { spell = HowlOfTerror, isCC = true, aoe = true, distance = 3 },
}

local function num(val)
    if val then return 1 else return 0 end
end

local function predSoulShards()
    local shardChanges = {
        [SeedOfCorruption.id] = -1,
        [VileTaint.id] = -1,
        [MaleficRapture.id] = -1,
    }
    
    local casting = player:CastOrChanelInfo()
    local spellId = casting and casting.spellId
    local currentShards = player.soulShards
    
    return math.min(currentShards + (shardChanges[spellId] or 0), 5)
end

local function shouldBurst()
    return makBurst()
end

local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local count = 0
            local dur = dur or 0
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Agony:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function uaRemains()
    local cacheKey = "uaRemains"
    
    return constCell:GetOrSet(cacheKey, function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Agony:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                    if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                        local duration = enemy:DebuffRemains(UnstableAffliction.wowName, true)
                        if duration > 0 then
                            return duration
                        end
                    end
                end
            end
            
            return 0
    end)
end



local function fightRemains()
    local cacheKey = "areaTTD"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local highest = 0 
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.ttd > 0 and enemy.ttd > highest then
                highest = enemy.ttd
            end
        end
        
        return highest
    end)
end


local function activeEnemies()
    return math.max(enemiesInRange(), 1)
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

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength
    
    return currentCast, currentCastName, remains, length
end

local function minDOT(debuff)
    local cacheKey = ("minDOT_" .. debuff)
    
    return constCell:GetOrSet(cacheKey, function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local lowestDuration = math.huge
            local enemyWithLowestDuration = nil
            local debuffFound = false
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if enemy.inCombat and enemy.ttd > 5000 or enemy.isDummy then
                    local duration = enemy:DebuffRemains(debuff, true)
                    
                    if duration > 0 then
                        debuffFound = true 
                        if duration < lowestDuration then
                            lowestDuration = duration
                            enemyWithLowestDuration = enemy
                        end
                    end
                end
            end
            
            if not debuffFound then
                return 99999, nil 
            else
                return lowestDuration, enemyWithLowestDuration 
            end
    end)
end


local function darkglareActive()
    local spellWords = {}
    for word in SummonDarkglare.wowName:gmatch("%S+") do
        spellWords[word] = true
    end
    
    for i = 1, 4 do
        local _, totemName = GetTotemInfo(i)
        if totemName then
            for word in totemName:gmatch("%S+") do
                if spellWords[word] then
                    return true
                end
            end
        end
    end
    return false
end

local function isSpellInFlight(spell, speed)
    local casting = gs.imCasting and gs.imCasting == spell.id
    local travelTime = (target.distance / speed) * 1000
    
    if casting then
        return true
    end

    if spell.used > 10000 or spell.used < 0 then
        return false
    end
    
    if spell.used < travelTime then
        return true
    end

    return false
end

local function autoTarget()
    if not player.inCombat then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    -- Movement check is now handled by the framework via ignoreMoving flag
    if A.GetToggle(2, "autoDOT") and gs.agonyCount < math.min(gs.activeEnemies, 8) and target:DebuffRemains(debuffs.agony, true) > 5000 and (VileTaint.cd > 5000 or not player:TalentKnown(VileTaint.id) or player.combatTime < 3) then
        return true
    end

    if A.GetToggle(2, "priorityTarget") and gs.uaCount >= 1 then
        if target:DebuffRemains(debuffs.agony, true) > 5000 and not target:Debuff(UnstableAffliction.wowName, true) then
            return true
        end
    end
end

--delay vars
local lastUpdateTime = 0
local updateDelay = 0.6

local function updategs()
    --Soul Shards
    local currentTime = GetTime() 
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.soulShards = predSoulShards()
        gs.imCasting = currentCast
        gs.imCastingName = currentCastName
        lastUpdateTime = currentTime 
    end
    gs.imCastingRemaining = currentCastRemains
    gs.imCastingLength = currentCastLength
    
    gs.seedInFlight = isSpellInFlight(SeedOfCorruption, 20)
    
    gs.activeEnemies = activeEnemies()
    
    gs.shouldCleave = gs.activeEnemies > 1 and gs.activeEnemies < 3 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    
    gs.shouldAoE = gs.activeEnemies > 2 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    
    gs.fightRemains = fightRemains()
    
    local cursorCondition = (Agony:InRange(mouseover) or UnendingBreath:InRange(mouseover)) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")
    
    if not player:TalentKnown(DrainSoul.id) then 
        gs.shadowEmbraceDebuff = target:HasDeBuffCount(debuffs.shadowEmbrace, true) + num(gs.imCasting and gs.imCasting == ShadowBolt.id or isSpellInFlight(ShadowBolt, 20))
    else
        gs.shadowEmbraceDebuff = target:HasDeBuffCount(debuffs.shadowEmbraceDS, true)
    end
    gs.shadowEmbraceUp = not player:TalentKnown(ShadowEmbrace.id) or gs.shadowEmbraceDebuff >= (2 + (2 * num(A.DrainSoul:IsTalentLearned()))) and (target:DebuffRemains(debuffs.shadowEmbrace, true) > 3 or target:DebuffRemains(debuffs.shadowEmbraceDS, true) > 3)
    
    gs.psUp = enemiesInRange(debuffs.phantomSingularity) >= 1 or not player:TalentKnown(PhantomSingularity.id)
    gs.vtUp = enemiesInRange(debuffs.vileTaint) >= 1 or (gs.imCasting and gs.imCasting == VileTaint.id) or not player:TalentKnown(VileTaint.id)
    gs.vtPsUp = (not player:TalentKnown(VileTaint.id) and not player:TalentKnown(PhantomSingularity.id)) or
                 (player:TalentKnown(VileTaint.id) and gs.vtUp) or
                 (player:TalentKnown(PhantomSingularity.id) and gs.psUp)
    
    gs.srUp = enemiesInRange(debuffs.soulRot) >= 1 or (gs.imCasting and gs.imCasting == SoulRot.id) or not player:TalentKnown(SoulRot.id)
    gs.cdDotsUp = gs.vtPsUp and gs.srUp and gs.shadowEmbraceUp
    
    gs.hasCds = player:TalentKnown(PhantomSingularity.id) or player:TalentKnown(VileTaint.id) or player:TalentKnown(SoulRot.id) or player:TalentKnown(SummonDarkglare.id)
    
    gs.cdsActive = not gs.hasCds or (gs.cdDotsUp and (SummonDarkglare.cd > 20000 or not player:TalentKnown(SummonDarkglare.id)))
    
    gs.uaCount = enemiesInRange(UnstableAffliction.wowName, 5000)
    if gs.imCasting and gs.imCastingName == UnstableAffliction.wowName then
        gs.uaCount = gs.uaCount + 1
    end
    
    gs.uaRemains = uaRemains()
    
    gs.minVt = minDOT(debuffs.vileTaint)
    gs.minPs = minDOT(debuffs.phantomSingularity)
    gs.minVtPs = math.min(gs.minVt, gs.minPs)
    
    gs.minAgony, gs.minAgonyTarget = minDOT(debuffs.agony)
    gs.agonyCount = enemiesInRange(debuffs.agony, 5000)
    
    local heroSpecID = C_ClassTalents.GetActiveHeroTalentSpec()
    gs.witherKnown = heroSpecID == 58
    
    gs.corruptionPandemic = not gs.witherKnown and (target:DebuffRemains(debuffs.corruption, true) < 4000 and not player:TalentKnown(AbsoluteCorruption.id) or not target:Debuff(debuffs.corruption, true))
    gs.witherPandemic = gs.witherKnown and (target:DebuffRemains(debuffs.wither, true) < 4000 and not player:TalentKnown(AbsoluteCorruption.id) or not target:Debuff(debuffs.wither, true))
    
    local seedExists = enemiesInRange(debuffs.seedOfCorruption) >= 1
    gs.refreshCorruption = (gs.corruptionPandemic or gs.witherPandemic) and not seedExists
    gs.canSeed = not target:Debuff(debuffs.seedOfCorruption) and not gs.seedInFlight and gs.refreshCorruption 
    
    gs.darkglareActive = darkglareActive()
    
    gs.pool = shouldBurst() and player:TalentKnown(SoulRot.id) and SoulRot.cd < 12000
    
    gs.poolForOblivion = shouldBurst() and player:TalentKnown(Oblivion.id) and Oblivion.cd < 8000 and gs.soulShards < 3 and not gs.vtPsUp and not player:Buff(buffs.tormentedCrescendo)

    gs.holdingTaint = A.VileTaint:IsBlocked() and VileTaint.cd < 1000

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

UnendingResolve:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp <  A.GetToggle(2, "UnendingResolveHP") then
        return spell:Cast()
    end
end)

DarkPact:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end
    if not player.inCombat then return end 
    
    
    if shouldDefensive() or player.hp <  A.GetToggle(2, "DarkPactHP") then
        return spell:Cast()
    end
end)

MortalCoil:Callback(function(spell)
    if player.hp > A.GetToggle(2, "MortalCoilHP") then return end
    
    return spell:Cast()
end)

DrainLife:Callback(function(spell)
    if player.hp > A.GetToggle(2, "DrainLifeHP") then return end
    
    if A.Soulburn:IsTalentLearned() and gs.soulShards >= 1 and Soulburn.cd < 300 then
        return Soulburn:Cast()
    end
    
    return spell:Cast()
end)

FelDomination:Callback(function(spell)
    if pet.exists and pet.hp > 0 then return end
    if not player.inCombat then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    
    return spell:Cast()
end)

SummonImp:Callback(function(spell)
    if pet.exists and pet.hp > 0 then return end
    if A.GetToggle(2, "PetChoice") ~= "IMP" then return end
    if gs.imCasting and gs.imCasting == SummonImp.spellId then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    
    return spell:Cast()
end)

SummonVoidwalker:Callback(function(spell)
    if pet.exists and pet.hp > 0 then return end
    if A.GetToggle(2, "PetChoice") ~= "VOIDWALKER" then return end
    if gs.imCasting and gs.imCasting and gs.imCasting == SummonVoidwalker.spellId then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    
    return spell:Cast()
end)

SummonFelhunter:Callback(function(spell)
    if pet.exists and pet.hp > 0 then return end
    if A.GetToggle(2, "PetChoice") ~= "FELHUNTER" then return end
    if gs.imCasting and gs.imCasting == SummonFelhunter.spellId then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    
    return spell:Cast()
end)

SummonSayaad:Callback(function(spell)
    if pet.exists and pet.hp > 0 then return end
    if A.GetToggle(2, "PetChoice") ~= "SAYAAD" then return end
    if gs.imCasting and gs.imCasting == SummonSayaad.spellId then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    
    return spell:Cast()
end)

HealthFunnel:Callback(function(spell)
    if not pet.exists then return end
    if player:Buff(buffs.grimoireOfSacrifice) then return end
    if pet.hp > A.GetToggle(2, "HealthFunnelHP") then return end
    
    return spell:Cast()
end)

GrimoireOfSacrifice:Callback(function(spell)
    if gs.imCasting and gs.imCasting == SummonImp.id then
        return spell:Cast()
    end
    
    if gs.imCasting and gs.imCasting == SummonVoidwalker.id then
        return spell:Cast()
    end
    
    if gs.imCasting and gs.imCasting == SummonFelhunter.id then
        return spell:Cast()
    end
    
    if gs.imCasting and gs.imCasting == SummonSayaad.id then
        return spell:Cast()
    end
    
    if not pet.exists then return end
    
    return spell:Cast()
end)

CreateSoulwell:Callback(function(spell)
    if not player:Buff(buffs.arenaPreparation) then return end
    if gs.imCasting and gs.imCasting == CreateSoulwell.spellId then return end
    
    return spell:Cast()
end)

SeedOfCorruption:Callback("pre", function(spell)
    if gs.imCasting then return end

    if player.inCombat then return end
    if not gs.canSeed then return end
    if gs.soulShards < 1 then return end
    
    if gs.activeEnemies > 2 - player:TalentKnownInt(DemonicSoul.id) then
        return spell:Cast(target)
    end
end)

Haunt:Callback("pre", function(spell)
    if player.inCombat then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    
    return spell:Cast(target)
end)

Berserking:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if gs.cdsActive or (SoulRot.used > 0 and SoulRot.used < 2000 and player.combatTime < 20) then
        return spell:Cast(target)
    end
end)

BloodFury:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if gs.cdsActive or (SoulRot.used > 0 and SoulRot.used < 2000 and player.combatTime < 20) then
        return spell:Cast(target)
    end
end)

Fireblood:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if gs.cdsActive or (SoulRot.used > 0 and SoulRot.used < 2000 and player.combatTime < 20) then
        return spell:Cast(target)
    end
end)

AncestralCall:Callback(function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if gs.cdsActive or (SoulRot.used > 0 and SoulRot.used < 2000 and player.combatTime < 20) then
        return spell:Cast(target)
    end
end)

local function ogcd()
    if gs.cdsActive then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
    Berserking()
    BloodFury()
    Fireblood()
    AncestralCall()
end

DrainSoul:Callback("eof", function(spell)
    if not player:TalentKnown(DemonicSoul.id) then return end

    if gs.activeEnemies < 4 and ((gs.fightRemains < 5000 and player:Buff(buffs.nightfall)) or (Player:PrevGCD(1, A.Haunt) and player:HasBuffCount(buffs.nightfall) >= 2 and not player:Buff(buffs.tormentedCrescendo))) then
        return spell:Cast(target)
    end
end)



Oblivion:Callback("eof", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[4] then return end
    if not target.isBoss then return end
    if gs.soulShards <= 1 then return end
    if gs.fightRemains >= (gs.soulShards + num(player:Buff(buffs.tormentedCrescendo)) * A.GetGCD()) * 1000 + 3000 then return end
    
    return spell:Cast(target)
end)

MaleficRapture:Callback("eof", function(spell)
    if gs.soulShards < 1 then return end
    if gs.fightRemains >= 4000 then return end
    if player:TalentKnown(DemonicSoul.id) then
        if player:Buff(buffs.nightfall) then return end
    end
    
    return spell:Cast(target)
end)

local function eof()
    DrainSoul("eof")
    Oblivion("eof")
    MaleficRapture("eof")
end

Haunt:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target:DebuffRemains(debuffs.haunt, true) >= 3000 then return end
    if target.ttd < 8000 and not target.isDummy then return end

    return spell:Cast(target)
end)

VileTaint:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.cursorCheck then return end
    if gs.soulShards < 1 then return end

    -- Updated condition based on new APL: (cooldown.soul_rot.remains<=execute_time|cooldown.soul_rot.remains>=25)&dot.agony.remains
    if player:TalentKnown(SoulRot.id) then
        if (SoulRot.cd <= spell:CastTime() or SoulRot.cd >= 25000) and target:Debuff(debuffs.agony, true) then
            return spell:Cast()
        end
    else
        if target:Debuff(debuffs.agony, true) then
            return spell:Cast()
        end
    end
end)

PhantomSingularity:Callback("aoe", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end

    -- Updated condition based on new APL: (cooldown.soul_rot.remains<=execute_time|cooldown.soul_rot.remains>=25)&dot.agony.remains
    if player:TalentKnown(SoulRot.id) then
        if (SoulRot.cd <= spell:CastTime() or SoulRot.cd >= 25000) and target:Debuff(debuffs.agony, true) then
            return spell:Cast()
        end
    else
        if target:Debuff(debuffs.agony, true) then
            return spell:Cast()
        end
    end
end)

UnstableAffliction:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCastingName == spell.wowName then return end

    -- APL: remains<3 | (talent.demonic_soul & remains<cooldown.soul_rot.remains+execute_time & cooldown.soul_rot.remains<5) & fight_remains>remains+5
    local remain_ok = gs.uaRemains < 3000 or (
        player:TalentKnown(DemonicSoul.id) and gs.uaRemains < (SoulRot.cd + spell:CastTime()) and SoulRot.cd < 5000
    )
    if remain_ok and gs.fightRemains > gs.uaRemains + 5000 then
        return spell:Cast(target)
    end
end)

Agony:Callback("aoe", function(spell)
    if gs.agonyCount >= 8 then return end
    if target:DebuffRemains(debuffs.agony, true) >= 10000 then return end
    -- Movement check is now handled by the framework via ignoreMoving flag
    if target.ttd < 8000 and not target.isDummy then return end

    -- Updated condition based on new APL: active_dot.agony<8&(remains<5|cooldown.vile_taint.remains>10|!talent.vile_taint)&target.time_to_die>10
    local refreshCondition = target:DebuffRemains(debuffs.agony, true) < 5000 or
                            VileTaint.cd > 10000 or
                            not player:TalentKnown(VileTaint.id)

    if refreshCondition then
        return spell:Cast(target)
    end
end)

SoulRot:Callback("aoe", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[2] then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    -- APL: variable.vt_up&(variable.ps_up|variable.vt_up)&dot.agony.remains
    if gs.vtUp and target:Debuff(debuffs.agony, true) then
        return spell:Cast(target)
    end
end)

Malevolence:Callback("aoe", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[5] then return end  

    if gs.vtPsUp and gs.srUp then
        return spell:Cast()
    end
    
    if player:Buff(buffs.powerInfusion) and not player:TalentKnown(SoulRot.id) then 
        return spell:Cast()
    end
end)

SeedOfCorruption:Callback("aoe", function(spell)
    if gs.soulShards < 1 then return end
    if gs.seedInFlight then return end
    if target:Debuff(debuffs.seedOfCorruption, true) then return end -- Don't cast if seed already on target

    -- Check if we need to refresh corruption/wither and seed is the best way to do it
    local needsCorruption = (not gs.witherKnown and target:DebuffRemains(debuffs.corruption, true) < 5000) or
                           (gs.witherKnown and target:DebuffRemains(debuffs.wither, true) < 5000)

    -- Only cast seed if we need corruption refresh AND we're in AoE (3+ enemies or 2+ with Demonic Soul)
    if needsCorruption and gs.activeEnemies >= (3 - player:TalentKnownInt(DemonicSoul.id)) then
        return spell:Cast(target)
    end
end)

Corruption:Callback("aoe", function(spell)
    if gs.witherKnown then return end
    if gs.seedInFlight then return end
    if target:Debuff(debuffs.seedOfCorruption, true) then return end -- Don't cast if seed is on target

    -- Only cast corruption directly if we're not in seed range (less than 3 enemies, or 2 without Demonic Soul)
    if target:DebuffRemains(debuffs.corruption, true) < 5000 and gs.activeEnemies < (3 - player:TalentKnownInt(DemonicSoul.id)) then
        return spell:Cast(target)
    end
end)

Wither:Callback("aoe", function(spell)
    if not gs.witherKnown then return end
    if gs.seedInFlight then return end
    if target:Debuff(debuffs.seedOfCorruption, true) then return end -- Don't cast if seed is on target

    -- Only cast wither directly if we're not in seed range (less than 3 enemies, or 2 without Demonic Soul)
    if target:DebuffRemains(debuffs.wither, true) < 5000 and gs.activeEnemies < (3 - player:TalentKnownInt(DemonicSoul.id)) then
        return spell:Cast(target)
    end
end)

SummonDarkglare:Callback("aoe", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end

    if gs.vtPsUp and gs.srUp then
        return spell:Cast()
    end
    
    if player:Buff(buffs.powerInfusion) and not player:TalentKnown(SoulRot.id) then 
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe", function(spell)
    -- Updated condition based on new APL: (cooldown.summon_darkglare.remains>15|soul_shard>3|(talent.demonic_soul&soul_shard>2))&buff.tormented_crescendo.up
    if (SummonDarkglare.cd > 15000 or gs.soulShards > 3 or (player:TalentKnown(DemonicSoul.id) and gs.soulShards > 2)) and player:Buff(buffs.tormentedCrescendo) then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe2", function(spell)
    -- Updated condition based on new APL: soul_shard>4|(talent.tormented_crescendo&buff.tormented_crescendo.react=1&soul_shard>3)
    if gs.soulShards > 4 or (player:TalentKnown(TormentedCrescendo.id) and player:HasBuffCount(buffs.tormentedCrescendo) == 1 and gs.soulShards > 3) then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe3", function(spell)
    -- Updated condition based on new APL: talent.demonic_soul&(soul_shard>2|(talent.tormented_crescendo&buff.tormented_crescendo.react=1&soul_shard))
    if player:TalentKnown(DemonicSoul.id) and (gs.soulShards > 2 or (player:TalentKnown(TormentedCrescendo.id) and player:HasBuffCount(buffs.tormentedCrescendo) == 1 and gs.soulShards >= 1)) then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe4", function(spell)
    -- Updated condition based on new APL: talent.tormented_crescendo&buff.tormented_crescendo.react
    if player:TalentKnown(TormentedCrescendo.id) and player:Buff(buffs.tormentedCrescendo) then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe5", function(spell)
    -- Updated condition based on new APL: talent.tormented_crescendo&buff.tormented_crescendo.react=2
    if player:TalentKnown(TormentedCrescendo.id) and player:HasBuffCount(buffs.tormentedCrescendo) >= 2 then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("aoe6", function(spell)
    -- Updated condition based on new APL: (variable.cd_dots_up|variable.vt_ps_up)&(soul_shard>2|cooldown.oblivion.remains>10|!talent.oblivion)
    if (gs.cdDotsUp or gs.vtPsUp) and (gs.soulShards > 2 or Oblivion.cd > 10000 or not player:TalentKnown(Oblivion.id)) then
        return spell:Cast()
    end
end)

DrainSoul:Callback("aoe", function(spell)
    if gs.shadowEmbraceUp then return end
    
    return spell:Cast(target)
end)

ShadowBolt:Callback("aoe", function(spell)
    if not player:Buff(buffs.nightfall) then return end
    if gs.shadowEmbraceUp then return end
    
    return spell:Cast(target)
end)

local function aoe()
    -- Updated AoE rotation based on new APL priority
    Haunt("aoe")
    VileTaint("aoe")
    PhantomSingularity("aoe")
    UnstableAffliction("aoe")
    Agony("aoe")
    SoulRot("aoe")
    Malevolence("aoe")
    SeedOfCorruption("aoe")
    Corruption("aoe")
    Wither("aoe")
    SummonDarkglare("aoe")
    MaleficRapture("aoe")
    MaleficRapture("aoe2")
    MaleficRapture("aoe3")
    MaleficRapture("aoe4")
    MaleficRapture("aoe5")
    MaleficRapture("aoe6")
    DrainSoul("aoe")
    ShadowBolt("aoe")
end

DrainSoul:Callback("cleaveSE", function(spell)
    if not player:TalentKnown(ShadowEmbrace.id) then return end
    if gs.shadowEmbraceUp then return end
    if target.ttd < 15000 then return end
    
    if gs.witherKnown then
        return spell:Cast(target)
    end
    
    if player:TalentKnown(DemonicSoul.id) then
        if player:Buff(buffs.nightfall) or player.combatTime < 20000 then
            return spell:Cast(target)
        end
    end
end)

ShadowBolt:Callback("cleaveSE", function(spell)
    if not player:TalentKnown(ShadowEmbrace.id) then return end
    if gs.shadowEmbraceUp then return end
    if target.ttd < 15000 then return end
    
    return spell:Cast(target)
end)

local function cleaveSE()
    DrainSoul("cleaveSE")
    ShadowBolt("cleaveSE")
end

Agony:Callback("cleave", function(spell)
    if target.ttd <= target:DebuffRemains(debuffs.agony, true) + 5000 then return end
    
    if player:TalentKnown(VileTaint.id) then
        if target:DebuffRemains(debuffs.agony, true) >= VileTaint.cd + VileTaint:CastTime() and not gs.holdingTaint then return end
        if gs.imCasting and gs.imCasting == VileTaint.id then return end
    end
    
    if target:DebuffRemains(debuffs.agony, true) < A.GetGCD() * 2000 or player:TalentKnown(DemonicSoul.id) and target:DebuffRemains(debuffs.agony, true) < SoulRot.cd + 8000 and SoulRot.cd < 5000 then
        return spell:Cast(target)
    end
end)

Wither:Callback("cleave", function(spell)
    if not gs.witherKnown then return end
    if target.ttd <= target:DebuffRemains(debuffs.wither, true) + 5000 then return end
    if gs.seedInFlight then return end
    if not gs.refreshCorruption then return end
    
    return spell:Cast(target)
end)

Haunt:Callback("cleave", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target:DebuffRemains(debuffs.haunt, true) < 3000 then
        return spell:Cast(target)
    end
    
    if player:TalentKnown(DemonicSoul.id) and player:Buff(buffs.nightfall) and (not player:TalentKnown(VileTaint.id) or VileTaint.cd > 500) then
        return spell:Cast(target)
    end
end)

UnstableAffliction:Callback("cleave", function(spell)
    if gs.imCasting and gs.imCastingName == spell.wowName then return end
    if target.ttd < gs.uaRemains + 5000 then return end
    if gs.uaCount >= 1 then return end
    
    if gs.uaCount < 1 or player:TalentKnown(DemonicSoul.id) and gs.uaRemains < SoulRot.cd + 8000 and SoulRot.cd < 5000 then
        return spell:Cast(target)
    end
end)

Corruption:Callback("cleave", function(spell)
    if gs.witherKnown then return end
    if target.ttd <= target:DebuffRemains(debuffs.corruption, true) + 5000 then return end
    if gs.seedInFlight then return end
    if not gs.refreshCorruption then return end
    
    return spell:Cast(target)
end)

VileTaint:Callback("cleave", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.cursorCheck then return end
    if gs.soulShards < 1 then return end   
    
    if not player:TalentKnown(SoulRot.id) then
        return spell:Cast()
    end
    
    if gs.minAgony < 1500 or SoulRot.cd <= spell:CastTime() + A.GetGCD() then
        return spell:Cast()
    end
    
    if SoulRot.cd >= 20000 or gs.imCasting and gs.imCasting == SoulRot.id then
        return spell:Cast()
    end
end)

PhantomSingularity:Callback("cleave", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end
    if gs.agonyCount < 2 then return end
    
    if not player:TalentKnown(SoulRot.id) then
        return spell:Cast(target)
    end
    
    if SoulRot.cd < 4000 then
        return spell:Cast(target)
    end
    
    if gs.fightRemains < SoulRot.cd then
        return spell:Cast(target)
    end
end)

Malevolence:Callback("cleave", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[5] then return end  

    if gs.vtPsUp then
        return spell:Cast()
    end
end)

SoulRot:Callback("cleave", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[2] then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.vtPsUp then return end
    if gs.agonyCount < 2 then return end
    
    return spell:Cast(target)
end)

SummonDarkglare:Callback("cleave", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end
    if not gs.cdDotsUp then return end
    
    return spell:Cast()
end)

MaleficRapture:Callback("cleave", function(spell)
    if player:Buff(buffs.tormentedCrescendo) then
        return spell:Cast()
    end
    
    if gs.soulShards <= 4 then return end
    
    if player:TalentKnown(DemonicSoul.id) and player:Buff(buffs.nightfall) or not player:TalentKnown(DemonicSoul.id) then
        return spell:Cast()
    end
end)

DrainSoul:Callback("cleave", function(spell)
    if not player:TalentKnown(DemonicSoul.id) then return end
    if not player:Buff(buffs.nightfall) then return end
    if player:HasBuffCount(buffs.tormentedCrescendo) >= 2 then return end
    if target.hp >= 20 then return end
    
    return spell:Cast(target)
end)

MaleficRapture:Callback("cleave2", function(spell)
    if player:TalentKnown(DemonicSoul.id) and (gs.soulShards > 1 or player:Buff(buffs.tormentedCrescendo) and SoulRot.cd > player:BuffRemains(buffs.tormentedCrescendo) * A.GetGCD() or gs.imCasting and gs.imCasting == SoulRot.id) and (not player:TalentKnown(VileTaint.id) or gs.soulShards > 1 and (VileTaint.cd > 10000 or gs.imCasting and gs.imCasting == VileTaint.id)) and (not player:TalentKnown(Oblivion.id) or Oblivion.cd > 10000 or gs.soulShards > 2 and Oblivion.cd < 10000) then
        return spell:Cast()
    end
    
    if player:TalentKnown(TormentedCrescendo.id) and player:Buff(buffs.tormentedCrescendo) and (player:BuffRemains(buffs.tormentedCrescendo) < A.GetGCD() * 2000 or player:HasBuffCount(buffs.tormentedCrescendo) >= 2) then
        return spell:Cast()
    end
    
    if (gs.cdDotsUp or (player:TalentKnown(DemonicSoul.id) or player:TalentKnown(PhantomSingularity.id)) and gs.vtPsUp or gs.witherKnown and gs.vtPsUp and not target:Debuff(debuffs.soulRot, true) and gs.soulShards > 1) and (not player:TalentKnown(Oblivion.id) or Oblivion.cd > 10000 or gs.soulShards > 2 and Oblivion.cd < 10000) then
        return spell:Cast()
    end
    
    if not player:TalentKnown(DemonicSoul.id) and player:Buff(buffs.tormentedCrescendo) then
        return spell:Cast()
    end
end)

Agony:Callback("cleave2", function(spell)
    if target:DebuffRemains(debuffs.agony, true) > 8000 then return end
    -- Movement check is now handled by the framework via ignoreMoving flag
    if target.ttd < 8000 and not target.isDummy then return end

    if target:DebuffRemains(debuffs.agony, true) < 5000 or SoulRot.cd < 8000 then
        return spell:Cast(target)
    end
end)

UnstableAffliction:Callback("cleave2", function(spell)
    if gs.imCasting and gs.imCastingName == spell.wowName then return end
    if gs.uaRemains > 8000 then return end
    
    if gs.uaRemains < 5000 or SoulRot.cd < 8000 then
        return spell:Cast(target)
    end
end)

DrainSoul:Callback("cleave2", function(spell)
    if not player:Buff(buffs.nightfall) then return end
    
    return spell:Cast(target)
end)

ShadowBolt:Callback("cleave", function(spell)
    if not player:Buff(buffs.nightfall) then return end
    
    return spell:Cast(target)
end)

Wither:Callback("cleave2", function(spell)
    if not gs.witherKnown then return end
    if not gs.refreshCorruption then return end
    
    return spell:Cast(target)
end)

Corruption:Callback("cleave2", function(spell)
    if gs.witherKnown then return end
    if not gs.refreshCorruption then return end
    
    return spell:Cast(target)
end)

DrainSoul:Callback("cleave3", function(spell)
    
    return spell:Cast(target)
end)

ShadowBolt:Callback("cleave2", function(spell)

    return spell:Cast(target)
end)

local function cleave()
    Agony("cleave")
    Wither("cleave")
    Haunt("cleave")
    UnstableAffliction("cleave")
    Corruption("cleave")
    if gs.witherKnown then
        cleaveSE()
    end
    VileTaint("cleave")
    PhantomSingularity("cleave")
    Malevolence("cleave")
    SoulRot("cleave")
    SummonDarkglare("cleave")
    if player:TalentKnown(DemonicSoul.id) then
        cleaveSE()
    end
    MaleficRapture("cleave")
    DrainSoul("cleave")
    MaleficRapture("cleave2")
    Agony("cleave2")
    UnstableAffliction("cleave2")
    DrainSoul("cleave2")
    ShadowBolt("cleave")
    Wither("cleave2")
    Corruption("cleave2")
    DrainSoul("cleave3")
    ShadowBolt("cleave2")
end

DrainSoul:Callback("seMaintenance", function(spell)
    if not player:TalentKnown(ShadowEmbrace.id) then return end
    if gs.shadowEmbraceUp then return end
    if target.ttd < 15000 then return end
    
    return spell:Cast(target)
end)

ShadowBolt:Callback("seMaintenance", function(spell)
    if not player:TalentKnown(ShadowEmbrace.id) then return end
    if gs.shadowEmbraceUp then return end
    if target.ttd < 15000 then return end
    
    return spell:Cast(target)
end)

local function seMaintenance()
    DrainSoul("seMaintenance")
    ShadowBolt("seMaintenance")
end


Agony:Callback("st", function(spell)
    local remains = target:DebuffRemains(debuffs.agony, true)

    if target.ttd < remains + 5000 then return end

    -- Updated condition based on new APL: (!talent.vile_taint|cooldown.vile_taint.remains&remains<cooldown.vile_taint.remains+action.vile_taint.cast_time)
    if player:TalentKnown(VileTaint.id) then
        if not (VileTaint.cd > 0 and remains < VileTaint.cd + VileTaint:CastTime()) then return end
        if gs.imCasting and gs.imCasting == VileTaint.id then return end
    end

    -- Updated condition: (talent.absolute_corruption&remains<3|!talent.absolute_corruption&remains<5|cooldown.soul_rot.remains<5&remains<8)
    if (player:TalentKnown(AbsoluteCorruption.id) and remains < 3000) or
       (not player:TalentKnown(AbsoluteCorruption.id) and remains < 5000) or
       (SoulRot.cd < 5000 and remains < 8000) then
        return spell:Cast(target)
    end
end)

Haunt:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    -- Updated condition based on new APL: talent.demonic_soul&buff.nightfall.react<2-prev_gcd.1.drain_soul&(!talent.vile_taint|cooldown.vile_taint.remains)
    if player:TalentKnown(DemonicSoul.id) and player:HasBuffCount(buffs.nightfall) < 2 and (not player:TalentKnown(VileTaint.id) or VileTaint.cd > 500) then
        return spell:Cast(target)
    end
end)

UnstableAffliction:Callback("st", function(spell)
    if gs.imCasting and gs.imCastingName == spell.wowName then return end
    local remains = gs.uaRemains
    if target.ttd < remains + 5000 then return end

    -- Updated condition based on new APL: (talent.absolute_corruption&remains<3|!talent.absolute_corruption&remains<5|cooldown.soul_rot.remains<5&remains<8)&(!talent.demonic_soul|buff.nightfall.react<2|prev_gcd.1.haunt&buff.nightfall.stack<2)
    local refreshCondition = (player:TalentKnown(AbsoluteCorruption.id) and remains < 3000) or
                            (not player:TalentKnown(AbsoluteCorruption.id) and remains < 5000) or
                            (SoulRot.cd < 5000 and remains < 8000)

    local nightfallCondition = not player:TalentKnown(DemonicSoul.id) or
                              player:HasBuffCount(buffs.nightfall) < 2 or
                              (Player:PrevGCD(1, A.Haunt) and player:HasBuffCount(buffs.nightfall) < 2)

    if refreshCondition and nightfallCondition then
        return spell:Cast(target)
    end
end)

Haunt:Callback("st2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    local remains = target:DebuffRemains(debuffs.haunt, true)
    if target.ttd < remains + 5000 then return end

    -- Updated condition based on new APL: (talent.absolute_corruption&debuff.haunt.remains<3|!talent.absolute_corruption&debuff.haunt.remains<5|cooldown.soul_rot.remains<5&debuff.haunt.remains<8)&(!talent.vile_taint|cooldown.vile_taint.remains)
    local refreshCondition = (player:TalentKnown(AbsoluteCorruption.id) and remains < 3000) or
                            (not player:TalentKnown(AbsoluteCorruption.id) and remains < 5000) or
                            (SoulRot.cd < 5000 and remains < 8000)

    local vileTaintCondition = not player:TalentKnown(VileTaint.id) or VileTaint.cd > 500

    if refreshCondition and vileTaintCondition then
        return spell:Cast(target)
    end
end)

Wither:Callback("st", function(spell)
    if not gs.witherKnown then return end

    local remains = target:DebuffRemains(debuffs.wither, true)
    if target.ttd < remains + 5000 then return end

    -- Updated condition based on new APL: (talent.wither&!talent.absolute_corruption&remains<5|cooldown.soul_rot.remains<5&remains<8)
    if (not player:TalentKnown(AbsoluteCorruption.id) and remains < 5000) or (SoulRot.cd < 5000 and remains < 8000) then
        return spell:Cast(target)
    end
end)

Corruption:Callback("st", function(spell)
    if gs.witherKnown then return end

    local remains = target:DebuffRemains(debuffs.corruption, true)
    if target.ttd < remains + 5000 then return end

    -- Updated condition based on new APL: refreshable
    if remains < 5000 then
        return spell:Cast(target)
    end
end)

DrainSoul:Callback("st", function(spell)
    if not player:Buff(buffs.nightfall) then return end

    -- Updated condition based on new APL: buff.nightfall.react&(buff.nightfall.react=buff.nightfall.max_stack|buff.nightfall.remains<execute_time*buff.nightfall.max_stack)&(talent.wither&!buff.tormented_crescendo.react|talent.demonic_soul&buff.tormented_crescendo.react<1)&cooldown.soul_rot.remains&soul_shard<5&(!talent.vile_taint|cooldown.vile_taint.remains)
    local nightfallCondition = player:HasBuffCount(buffs.nightfall) == 2 or
                               player:BuffRemains(buffs.nightfall) < spell:CastTime() * 2

    local crescendoCondition = (gs.witherKnown and not player:Buff(buffs.tormentedCrescendo)) or
                              (player:TalentKnown(DemonicSoul.id) and player:HasBuffCount(buffs.tormentedCrescendo) < 1)

    local otherConditions = SoulRot.cd > 0 and gs.soulShards < 5 and
                           (not player:TalentKnown(VileTaint.id) or VileTaint.cd > 500)

    if nightfallCondition and crescendoCondition and otherConditions then
        return spell:Cast(target)
    end
end)

ShadowBolt:Callback("st", function(spell)
    if not player:Buff(buffs.nightfall) then return end

    -- Updated condition based on new APL: buff.nightfall.react&(buff.nightfall.react=buff.nightfall.max_stack|buff.nightfall.remains<execute_time*buff.nightfall.max_stack)&buff.tormented_crescendo.react<buff.tormented_crescendo.max_stack&cooldown.soul_rot.remains>5&(!talent.vile_taint|cooldown.vile_taint.remains)
    local nightfallCondition = player:HasBuffCount(buffs.nightfall) == 2 or
                               player:BuffRemains(buffs.nightfall) < spell:CastTime() * 2

    local crescendoCondition = player:HasBuffCount(buffs.tormentedCrescendo) < 2

    local otherConditions = SoulRot.cd > 5000 and (not player:TalentKnown(VileTaint.id) or VileTaint.cd > 500)

    if nightfallCondition and crescendoCondition and otherConditions then
        return spell:Cast(target)
    end
end)

VileTaint:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.cursorCheck then return end
    if gs.soulShards < 1 then return end

    -- Updated condition based on new APL: (!talent.soul_rot|cooldown.soul_rot.remains>20|cooldown.soul_rot.remains<=execute_time+gcd.max|fight_remains<cooldown.soul_rot.remains)&dot.agony.remains&(dot.corruption.remains|dot.wither.remains)&dot.unstable_affliction.remains
    local soulRotCondition = not player:TalentKnown(SoulRot.id) or
                            SoulRot.cd > 20000 or
                            SoulRot.cd <= spell:CastTime() + A.GetGCD() or
                            gs.fightRemains < SoulRot.cd

    local dotsCondition = target:Debuff(debuffs.agony, true) and
                         (target:Debuff(debuffs.corruption, true) or target:Debuff(debuffs.wither, true)) and
                         target:Debuff(debuffs.unstableAffliction, true)

    if soulRotCondition and dotsCondition then
        return spell:Cast()
    end
end)

PhantomSingularity:Callback("st", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end

    -- Updated condition based on new APL: (!talent.soul_rot|cooldown.soul_rot.remains<=execute_time+gcd.max|fight_remains<cooldown.soul_rot.remains+8)&dot.agony.remains&(dot.corruption.remains|dot.wither.remains)&dot.unstable_affliction.remains
    local soulRotCondition = not player:TalentKnown(SoulRot.id) or
                            SoulRot.cd <= spell:CastTime() + A.GetGCD() or
                            gs.fightRemains < SoulRot.cd + 8000

    local dotsCondition = target:Debuff(debuffs.agony, true) and
                         (target:Debuff(debuffs.corruption, true) or target:Debuff(debuffs.wither, true)) and
                         target:Debuff(debuffs.unstableAffliction, true)

    if soulRotCondition and dotsCondition then
        return spell:Cast(target)
    end
end)

Malevolence:Callback("st", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[5] then return end  

    if gs.vtPsUp then
        return spell:Cast()
    end
end)

SoulRot:Callback("st", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[2] then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    -- Updated condition based on new APL: variable.vt_ps_up
    if gs.vtPsUp then
        return spell:Cast(target)
    end
end)

SummonDarkglare:Callback("st", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end

    -- Updated condition based on new APL: variable.cd_dots_up&(!talent.shadow_embrace|debuff.shadow_embrace.stack=debuff.shadow_embrace.max_stack)
    if gs.cdDotsUp and (not player:TalentKnown(ShadowEmbrace.id) or gs.shadowEmbraceUp) then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("st", function(spell)
    -- Updated condition based on new APL: (soul_shard>4|buff.tormented_crescendo.react=buff.tormented_crescendo.max_stack)&cooldown.soul_rot.remains>5
    if (gs.soulShards > 4 or player:HasBuffCount(buffs.tormentedCrescendo) == 2) and
       SoulRot.cd > 5000 then
        return spell:Cast()
    end
end)

DrainSoul:Callback("st2", function(spell)
    -- Updated condition based on new APL: talent.demonic_soul&buff.nightfall.react&buff.tormented_crescendo.react<buff.tormented_crescendo.max_stack&target.health.pct<20
    if player:TalentKnown(DemonicSoul.id) and player:Buff(buffs.nightfall) and
       player:HasBuffCount(buffs.tormentedCrescendo) < 2 and
       target.hp < 20 then
        return spell:Cast(target)
    end
end)

MaleficRapture:Callback("st2", function(spell)
    -- Updated condition based on new APL: talent.demonic_soul&(soul_shard>1|buff.tormented_crescendo.react&cooldown.soul_rot.remains>buff.tormented_crescendo.remains*gcd.max)&(!talent.vile_taint|soul_shard>1&cooldown.vile_taint.remains>10)&(!talent.oblivion|cooldown.oblivion.remains>10|soul_shard>2&cooldown.oblivion.remains<10)
    if player:TalentKnown(DemonicSoul.id) then
        local soulShardCondition = gs.soulShards > 1 or (player:Buff(buffs.tormentedCrescendo) and SoulRot.cd > player:BuffRemains(buffs.tormentedCrescendo) * A.GetGCD())
        local vileTaintCondition = not player:TalentKnown(VileTaint.id) or (gs.soulShards > 1 and VileTaint.cd > 10000)
        local oblivionCondition = not player:TalentKnown(Oblivion.id) or Oblivion.cd > 10000 or (gs.soulShards > 2 and Oblivion.cd < 10000)

        if soulShardCondition and vileTaintCondition and oblivionCondition then
            return spell:Cast()
        end
    end
end)

Oblivion:Callback("st", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[4] then return end

    -- Updated condition based on new APL: dot.agony.remains&(dot.corruption.remains|dot.wither.remains)&dot.unstable_affliction.remains&debuff.haunt.remains>5
    local dotsCondition = target:Debuff(debuffs.agony, true) and
                         (target:Debuff(debuffs.corruption, true) or target:Debuff(debuffs.wither, true)) and
                         target:Debuff(debuffs.unstableAffliction, true) and
                         target:DebuffRemains(debuffs.haunt, true) > 5000

    if dotsCondition then
        return spell:Cast(target)
    end
end)

MaleficRapture:Callback("st3", function(spell)
    -- Updated condition based on new APL: (variable.cd_dots_up|(talent.demonic_soul|talent.phantom_singularity)&variable.vt_ps_up|talent.wither&variable.vt_ps_up&!dot.soul_rot.remains&soul_shard>3)&(!talent.oblivion|cooldown.oblivion.remains>10|soul_shard>2&cooldown.oblivion.remains<10)
    local dotsCondition = gs.cdDotsUp or
                         ((player:TalentKnown(DemonicSoul.id) or player:TalentKnown(PhantomSingularity.id)) and gs.vtPsUp) or
                         (gs.witherKnown and gs.vtPsUp and not target:Debuff(debuffs.soulRot, true) and gs.soulShards > 3)

    local oblivionCondition = not player:TalentKnown(Oblivion.id) or
                             Oblivion.cd > 10000 or
                             (gs.soulShards > 2 and Oblivion.cd < 10000)

    if dotsCondition and oblivionCondition then
        return spell:Cast()
    end
end)

MaleficRapture:Callback("st4", function(spell)
    -- Updated condition based on new APL: talent.demonic_soul&!buff.nightfall.react&(!talent.vile_taint|cooldown.vile_taint.remains>10|soul_shard>1&cooldown.vile_taint.remains<10)
    if player:TalentKnown(DemonicSoul.id) and not player:Buff(buffs.nightfall) then
        local vileTaintCondition = not player:TalentKnown(VileTaint.id) or
                                  VileTaint.cd > 10000 or
                                  (gs.soulShards > 1 and VileTaint.cd < 10000)

        if vileTaintCondition then
            return spell:Cast()
        end
    end
end)

MaleficRapture:Callback("st5", function(spell)
    -- Updated condition based on new APL: !talent.demonic_soul&(buff.tormented_crescendo.react&buff.tormented_crescendo.remains<=cooldown.soul_rot.remains+10+execute_time)
    if not player:TalentKnown(DemonicSoul.id) and player:Buff(buffs.tormentedCrescendo) then
        if player:BuffRemains(buffs.tormentedCrescendo) <= SoulRot.cd + 10000 + spell:CastTime() then
            return spell:Cast()
        end
    end
end)

DrainSoul:Callback("st3", function(spell)
    if not player:Buff(buffs.nightfall) then return end

    return spell:Cast(target)
end)

ShadowBolt:Callback("st2", function(spell)
    if not player:Buff(buffs.nightfall) then return end

    return spell:Cast(target)
end)

Agony:Callback("st2", function(spell)
    if target:DebuffRemains(debuffs.agony, true) > 5000 then return end
    
    return spell:Cast(target)
end)

UnstableAffliction:Callback("st2", function(spell)
    if gs.imCasting and gs.imCastingName == spell.wowName then return end
    if gs.uaRemains > 5000 then return end
    
    return spell:Cast(target)
end)

DrainSoul:Callback("st4", function(spell)
        
    return spell:Cast(target)
end)

ShadowBolt:Callback("st3", function(spell)
        
    return spell:Cast(target)
end)

local function st()
    -- Updated single target rotation based on new APL priority
    Agony("st")
    Haunt("st")
    UnstableAffliction("st")
    Haunt("st2")
    Wither("st")
    Corruption("st")
    DrainSoul("st")
    ShadowBolt("st")
    seMaintenance()
    VileTaint("st")
    PhantomSingularity("st")
    SoulRot("st")
    SummonDarkglare("st")
    Malevolence("st")
    MaleficRapture("st")
    DrainSoul("st2")
    MaleficRapture("st2")
    Oblivion("st")
    MaleficRapture("st3")
    MaleficRapture("st4")
    MaleficRapture("st5")
    DrainSoul("st3")
    ShadowBolt("st2")
    Agony("st2")
    UnstableAffliction("st2")
    DrainSoul("st4")
    ShadowBolt("st3")
end

local function shouldReflect()
    local arenas = { arena1, arena2, arena3 }
    
    for _, arena in ipairs(arenas) do
        local casting = arena.castOrChannelInfo
        local currentCast = casting and casting.spellId
        
        if currentCast and MakLists.Reflect[currentCast] then
            return true
        end
    end
    
    return false
end

NetherWard:Callback("pvp", function(spell)
        if not A.NetherWard:IsTalentLearned() then return end
        if not shouldReflect() then return end    
        
        return spell:Cast()
end)

local function inTwenty()
    local arenas = { arena1, arena2, arena3 }
    local totalInRange = 0
    
    for _, arena in ipairs(arenas) do
        local inRange = MortalCoil:InRange(arena)
        
        if inRange then 
            totalInRange = totalInRange + 1
        end
    end
    return totalInRange
end

CallObserver:Callback("pvp", function(spell)
        if not A.CallObserver:IsTalentLearned() then return end    
        
        if inTwenty() < 2 then return end
        
        return spell:Cast()
end)

SoulRip:Callback("pvp", function(spell)
        if not A.SoulRip:IsTalentLearned() then return end    
        
        if inTwenty() < 2 then return end
        
        return spell:Cast()
end)

BondsOfFel:Callback("pvp", function(spell)
        if not A.BondsOfFel:IsTalentLearned() then return end    
        
        if inTwenty() < 2 then return end
        
        return spell:Cast()
end)

SpellLock:Callback("bg", function(spell)
        if not IsInRaid() then return end
        if not target.pvpKick then return end
        
        return spell:Cast(enemy)
end)

SpellLockSac:Callback("bg", function(spell)
        if not IsInRaid() then return end
        if not target.pvpKick then return end
        
        return spell:Cast(enemy)
end)

local function shouldExhaustion(enemy)
    -- Enemy is ranged and not slowed by ally
    if enemy:HasDeBuff(debuffs.curseOfExhaustion) then return end
    if enemy:HasDeBuff(debuffs.curseOfTheSatyr, true) then return end
    
    return not enemy.isMelee and not enemy.slowed
end

local function shouldTongues(enemy)
    -- Enemy slowed already WITHOUT Exhaustion
    -- Enemy is caster
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfTheSatyr) then return end
    if enemy:HasDeBuff(debuffs.curseOfTongues) then return end
    
    return not enemy.isMelee 
end

local function shouldWeakness(enemy)
    -- Enemy is melee and not healer
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfWeakness) or enemy:HasDeBuff(debuffs.curseOfTheSatyr) then return end
    
    return enemy.isMelee and not enemy.isHealer
end

CurseOfExhaustion:Callback("bg", function(spell)
        if not shouldExhaustion(target) then return end
        
        return spell:Cast(target)
end)

CurseOfTongues:Callback("bg", function(spell)
        if not shouldTongues(target) then return end
        
        return spell:Cast(target)
end)

CurseOfWeakness:Callback("bg", function(spell)
        if IsPlayerSpell(CurseOfTheSatyr.id) then return end
        if not shouldWeakness(target) then return end
        
        return spell:Cast(target)
end)

CurseOfTheSatyr:Callback("bg", function(spell)
        if shouldWeakness(target) or shouldTongues(target) then    
            return spell:Cast(target)
        end
end)

local function pvpenis()
    NetherWard("pvp")
    CallObserver("pvp")
    SoulRip("pvp")
end

A[3] = function(icon)
    FrameworkStart(icon)
    updategs()
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Soul Shards: ", gs.soulShards)
        MakPrint(2, "Unstable Affliction Count: ", gs.uaCount)
        MakPrint(3, "Unstable Affliction Remains: ", gs.uaRemains)
        MakPrint(4, "Seed in flight: ", isSpellInFlight(SeedOfCorruption, 20))
        MakPrint(5, "Darkglare Active: ", gs.darkglareActive)
        MakPrint(6, "Fight Remains: ", gs.fightRemains) 
        MakPrint(7, "Min Agony: ", gs.minAgony) 
        MakPrint(8, "Min Agony Target: ", gs.minAgonyTarget)
        MakPrint(9, "Should AoE: ", gs.shouldAoE)
        MakPrint(10, "Should Cleave: ", gs.shouldCleave) 
        MakPrint(11, "Can Seed: ", gs.canSeed)
        MakPrint(12, "Spell Lock Learned: ", SpellLock:IsKnown())     
    end
    
    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then -- Vile Taint ready
        if player:TalentKnown(VileTaint.id) and VileTaint.cd < 700 and player.inCombat then
            Aware:displayMessage("VILE TAINT READY", "Purple", 1)
        end
    end

    makInterrupt(interrupts)
    
    FelDomination()
    GrimoireOfSacrifice()
    SummonImp()
    SummonVoidwalker()
    SummonFelhunter()
    SummonSayaad()
    CreateSoulwell()
    UnendingResolve()
    DarkPact()
    HealthFunnel()
    
    if target.exists and target.canAttack and (ShadowBolt:InRange(target) or DrainSoul:InRange(target)) then
        MortalCoil()
        DrainLife()
        
        if A.IsInPvP then
            SpellLock("bg")
            SpellLockSac("bg")
            CurseOfExhaustion("bg")
            CurseOfTheSatyr("bg")
            CurseOfTongues("bg")
            CurseOfWeakness("bg")
            pvpenis()
        end
        
        SeedOfCorruption("pre")
        Haunt("pre")
        
        if player.channeling and gs.imCasting and gs.imCasting == Oblivion.id then return end
        if player.channeling and VileTaint.cd > 300 and not player:Buff(buffs.nightfall) then return end
        
        local damagePotion = Action.GetToggle(2, "damagePotion")
        local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
        local potionExhausted = Action.GetToggle(2, "potionExhausted")
        local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
        local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

        if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
            local shouldPot = gs.cdDotsUp
            if shouldPot then
                return damagePotionObject:Show(icon)
            end
        end

        if gs.shouldAoE then
            aoe()
        end
        
        ogcd()
        eof()
        
        if gs.shouldCleave then
            cleave()
        end
        
        st()
        
    end
    
    return FrameworkEnd()
end

CurseOfExhaustion:Callback("arena", function(spell, enemy)
        if not shouldExhaustion(enemy) then return end
        
        return spell:Cast(enemy)
end)

CurseOfTongues:Callback("arena", function(spell, enemy)
        if not shouldTongues(enemy) then return end
        
        return spell:Cast(enemy)
end)

CurseOfWeakness:Callback("arena", function(spell, enemy)
        if IsPlayerSpell(CurseOfTheSatyr.id) then return end
        if not shouldWeakness(enemy) then return end
        
        return spell:Cast(enemy)
end)

CurseOfTheSatyr:Callback("arena", function(spell, enemy)
        if shouldWeakness(enemy) or shouldTongues(enemy) then    
            return spell:Cast(enemy)
        end
end)

SingeMagic:Callback("party", function(spell, friendly)
    if not friendly.magicked then return end
    return spell:Cast(friendly)
end)

local function fearDuration()
    for i = 1, 3 do
        local enemy = "arena" .. i
        if ActionUnit(enemy):IsExists() and ActionUnit(enemy):HasDeBuffs(A.Fear.ID, true) > 0 then
            return ActionUnit(enemy):HasDeBuffs(A.Fear.ID) * 1000
        end
    end
    return 0
end

Fear:Callback("arena", function(spell, enemy)
        
        local ccRemains = 0
        if enemy.cc then
            ccRemains = enemy:CCRemains()
        end
        
        if gs.imCasting and gs.imCasting == spell.id then return end    
        if enemy:IsTarget() then return end
        if enemy.disorientDr <= 0.25 then return end
        if ccRemains > Fear:CastTime() + MakGcd() then return end
        if fearDuration() > Fear:CastTime() then return end
        
        local fearCastTime = spell:CastTime()
        if arena1:HasDeBuffRemain(spell.Id, fearCastTime) then return end
        if arena2:HasDeBuffRemain(spell.Id, fearCastTime) then return end
        if arena3:HasDeBuffRemain(spell.Id, fearCastTime) then return end
        
        if enemy.cc then return end
        
        if gs.uaCount < 1 + (num(A.RampartAfflictions:IsTalentLearned())) then return end
        
        if enemy:Debuff(debuffs.fear) then
            Aware:displayMessage("Chain Fearing", "Purple", 1)
            return spell:Cast(enemy)
        end
        
        if enemy.isHealer then 
            Aware:displayMessage("Fearing Healer", "Green", 1)
            return spell:Cast(enemy)
        end
        
        local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party1.hp > 0 and party2.hp < 50)
        if peelParty and not enemy.isHealer and enemy.hp > 40 then
            Aware:displayMessage("Fearing To Peel", "Red", 1)
            return spell:Cast(enemy)
        end
        
        if enemy:Debuff(debuffs.mortalCoil) then
            return spell:Cast(enemy)
        end
end)

SpellLock:Callback("arena", function(spell, enemy)
        if not enemy.pvpKick then return end
        
        return spell:Cast(enemy)
end)

SpellLockSac:Callback("arena", function(spell, enemy)
        if not enemy.pvpKick then return end
        
        return spell:Cast(enemy)
end)


MortalCoil:Callback("arena", function(spell, enemy)
        if enemy.pvpKick or (enemy:Debuff(debuffs.fear) and enemy:DebuffRemains(debuffs.fear) < 1000) then
            return spell:Cast(enemy)
        end
end)

UnstableAffliction:Callback("arena", function(spell, enemy)
        if gs.uaCount >= 1 + (2 * num(A.RampartAfflictions:IsTalentLearned())) then return end
        if enemy:DebuffRemains(debuffs.unstableAffliction) > 5000 then return end
        if enemy:DebuffRemains(debuffs.unstableAfflictionRA) > 5000 then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        
        return spell:Cast(enemy)
end)

Agony:Callback("arena", function(spell, enemy)
        if enemy:DebuffRemains(debuffs.agony) > 4000 then return end
        
        return spell:Cast(enemy)
end)

Corruption:Callback("arena", function(spell, enemy)
        if enemy:DebuffRemains(debuffs.corruption, true) > 4000 then return end
        if enemy:DebuffRemains(debuffs.wither, true) > 4000 then return end
        
        return spell:Cast(enemy)
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    if A.Zone ~= "arena" then return end
    SpellLock("arena", enemy)
    SpellLockSac("arena", enemy)
    MortalCoil("arena", enemy)
    CurseOfExhaustion("arena", enemy)
    CurseOfTheSatyr("arena", enemy)
    CurseOfTongues("arena", enemy)
    CurseOfWeakness("arena", enemy)
    Fear("arena", enemy)
    UnstableAffliction("arena", enemy)
    Agony("arena", enemy)
    Corruption("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    SingeMagic("party", friendly)
    
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

