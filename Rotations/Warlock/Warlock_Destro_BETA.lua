if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 267 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
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
local Pet              = LibStub("PetLibrary")

local _G, setmetatable = _G, setmetatable

local ActionID       = {
    AncestralCall               = { ID = 274738, Texture = 59752, MAKULU_INFO = {ignoreCasting = true } },
    ArcanePulse                 = { ID = 260364, MAKULU_INFO = {ignoreCasting = true } },
    ArcaneTorrent               = { ID = 50613, MAKULU_INFO = {ignoreCasting = true } },
    BagOfTricks                 = { ID = 312411, MAKULU_INFO = {ignoreCasting = true } },
    Berserking                  = { ID = 26297, MAKULU_INFO = {ignoreCasting = true } },
    BloodFury                   = { ID = 20572, MAKULU_INFO = {ignoreCasting = true } },
    Darkflight                  = { ID = 68992, MAKULU_INFO = {ignoreCasting = true } },
    EscapeArtist                = { ID = 20589, MAKULU_INFO = {ignoreCasting = true } },
    Fireblood                   = { ID = 265221, MAKULU_INFO = {ignoreCasting = true } },
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = {ignoreCasting = true } },
    RocketBarrage               = { ID = 69041, MAKULU_INFO = {ignoreCasting = true } },
    RocketJump                  = { ID = 69070, MAKULU_INFO = {ignoreCasting = true } },
    SpatialRift                 = { ID = 256948, MAKULU_INFO = {ignoreCasting = true } },
    Stoneform                   = { ID = 20594, MAKULU_INFO = {ignoreCasting = true } },
    WarStomp                    = { ID = 20549, MAKULU_INFO = {ignoreCasting = true } },
    WillOfTheForsaken           = { ID = 7744, MAKULU_INFO = {ignoreCasting = true } },
    WillToSurvive               = { ID = 59752, MAKULU_INFO = {ignoreCasting = true } },

    AlgariManaPotion         = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
    AmplifyCurse             = { ID = 328774, MAKULU_INFO = {ignoreCasting = true } },
    ArenaPreparation         = { ID = 32727, Hidden = true },
    Backdraft                = { ID = 196406, Hidden = true },
    BaneOfFragility          = { ID = 199954, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Banish                   = { ID = 710, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    BlisteringAtrophy        = { ID = 456939, Hidden = true },
    BondsOfFel               = { ID = 353753, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    BurningRush              = { ID = 111400, MAKULU_INFO = {ignoreCasting = true } },
    CallObserver             = { ID = 201996, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    CastingCircle            = { ID = 221703, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Cataclysm                = { ID = 152108, FixedTexture = 409545, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  }, Macro = "/cast Single-Button Assistant" },
    ChannelDemonfire         = { ID = 196447, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    ChaosBolt                = { ID = 116858, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true  } },
    Conflagrate              = { ID = 17962, FixedTexture = 135807, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    ConflagrationOfChaos     = { ID = 387108, Hidden = true },
    Corruption               = { ID = 172, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CreateHealthstone        = { ID = 6201, MAKULU_INFO = {ignoreCasting = true } },
    CreateSoulwell           = { ID = 29893, MAKULU_INFO = {ignoreCasting = true } },
    CurseOfExhaustion        = { ID = 334275, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    CurseOfTheSatyr          = { ID = 440057, Texture = 236572, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    CurseOfTongues           = { ID = 1714, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    CurseOfWeakness          = { ID = 702, Texture = 68992, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    DarkPact                 = { ID = 108416, MAKULU_INFO = {ignoreCasting = true } },
    DemonicCircle            = { ID = 48018, MAKULU_INFO = {ignoreCasting = true } },
    DemonicCircleTeleport    = { ID = 48020, MAKULU_INFO = {ignoreCasting = true } },
    DiabolicRitual           = { ID = 428514, Hidden = true },
    DimensionalRift          = { ID = 387976, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    DrainLife                = { ID = 234153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Eradication              = { ID = 196412, Hidden = true },
    Fear                     = { ID = 5782, MAKULU_INFO = {ignoreCasting = true } },
    FelDomination            = { ID = 333889, MAKULU_INFO = {ignoreCasting = true } },
    FireAndBrimstone         = { ID = 196408, Hidden = true },

    FrontlinePotion          = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    GrimoireOfSacrifice      = { ID = 108503, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Havoc                    = { ID = 80240, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    HealthFunnel             = { ID = 755, MAKULU_INFO = {ignoreCasting = true } },
    Healthstone              = { Type = "Item", ID = 5512, Hidden = true },
    DemonicHealthstone       = { Type = "Item", ID = 224464, Hidden = true, Macro = "/cast Soulburn\n/use Demonic Healthstone" },   
    HowlOfTerror             = { ID = 5484, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Immolate                 = { ID = 348, FixedTexture = 135817, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    ImprovedChaosBolt        = { ID = 456951, Hidden = true },
    Incinerate               = { ID = 29722, FixedTexture = 135789, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    InfernalBolt             = { ID = 434506, FixedTexture = 135789, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Inferno                  = { ID = 270545, Hidden = true },
    InternalCombustion       = { ID = 266134, Hidden = true },
    Malevolence              = { ID = 442726, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    MasterRitualist          = { ID = 387165, Hidden = true },
    Mayhem                   = { ID = 387506, Hidden = true },
    MortalCoil               = { ID = 6789, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },

    NetherWard               = { ID = 212295, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },

    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    Pyrogenics               = { ID = 387095, Hidden = true },
    RagingDemonfire          = { ID = 387166, Hidden = true },
    RainOfChaos              = { ID = 266086, Hidden = true },
    RainOfFire               = { ID = 5740, FixedTexture = 136186, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true  } },
    RainOfFireT              = { ID = 1214467, FixedTexture = 136186, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true  } },
    RoaringBlaze             = { ID = 205184, Hidden = true },

    Ruination                = { ID = 434635, FixedTexture = 236291, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true  } },
    SecretsOfTheCoven        = { ID = 428518, Hidden = true },
    ShadowBite               = { ID = 54049, Hidden = true },

    ShadowBolt               = { ID = 686, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShadowRift               = { ID = 353294, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Shadowburn               = { ID = 17877, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true  } },
    Shadowflame              = { ID = 384069, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Shadowfury               = { ID = 30283, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    SingeMagic               = { ID = 119905, MAKULU_INFO = { ignoreCasting = true } },
    SoulFire                 = { ID = 6353, FixedTexture = 135809, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    SoulRip                  = { ID = 410598, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Soulburn                 = { ID = 385899, MAKULU_INFO = {ignoreCasting = true } },
    Soulstone                = { ID = 20707, MAKULU_INFO = {ignoreCasting = true } },
    SpellLock                = { ID = 19647, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true, pet = true  } },
    SpellLockSac             = { ID = 132409, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true, pet = true  } },
    SubjugateDemon           = { ID = 1098, MAKULU_INFO = {ignoreCasting = true } },
    SummonFelhunter          = { ID = 691, MAKULU_INFO = {ignoreCasting = true } },
    SummonImp                = { ID = 688, MAKULU_INFO = {ignoreCasting = true } },
    SummonInfernal           = { ID = 1122, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },

    SummonSayaad             = { ID = 366222, MAKULU_INFO = {ignoreCasting = true } },
    SummonSoulkeeper         = { ID = 386256, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },

    SummonVoidwalker         = { ID = 697, MAKULU_INFO = {ignoreCasting = true } },
    TemperedPotion1          = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2          = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3          = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    UnendingBreath           = { ID = 5697, MAKULU_INFO = {ignoreCasting = true } },
    UnendingResolve          = { ID = 104773, MAKULU_INFO = {ignoreCasting = true } },
    UniversalOne             = { ID = 80240, FixedTexture = 133667, Hidden = true },
    UniversalTwo             = { ID = 445468, FixedTexture = 133663, Hidden = true },
    Whiplash                 = { ID = 6360, Hidden = true },

    Wither                   = { ID = 445468, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
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

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_WARLOCK_DESTRUCTION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "Incinerate", "ChaosBolt", "RainOfFire", "RainOfFireT", "Immolate",
        "ChannelDemonfire", "SoulFire", "Shadowburn", "Conflagrate",
        "Cataclysm", "SummonInfernal", "DimensionalRift", "InfernalBolt",
        "Ruination", "ShadowBolt", "Havoc", "Wither", "Malevolence"
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
    shouldAoE = false,
    shouldCleave = false,
    havocImmoTime = 0,
    pooling = false,
    poolingCb = false,
    infernalActive = false,
    havocRemains = 0,
    havocUp = false,
        havocSwapDoneThisWindow = false,

    immoCount = 0,
    witherCount = 0,
    dotCount = 0,
    witherRemains = 0,
    immolateRemains = 0,
    demonicArt = false,
    diabolicRitualRemains = 0,
    ritualOfRuin = false,
    ruination = false,
    poolSoulShards = false,
    immoDelay = false,
    witherKnown = false,
    -- Advanced Variables System
    setBonusTww3_2pc = false,
    setBonusTww3_4pc = false,
    setBonusActive = false,
    resourceEfficiency = 0,
    havocTargetOptimal = nil,
    fightRemainsEnhanced = 0,
    cleaveThreshold = 2,
    aoeThreshold = 3,
    optimalShardThreshold = 3.5,
    shardGenerationRate = 0,
    -- Target_if tracking
    minImmolateTarget = nil,
    minImmolateRemains = 999999,
    bestHavocTarget = nil,
    havocTargetScore = 999999,
    -- Optimal spender tracking
    optimalSpender = "chaos_bolt",
}

local buffs = {
    powerInfusion = 10060,
    grimoireOfSacrifice = 196099,
    felDomination = 333889,
    infernalBolt = 433891,
    pitLord = 432795,
    motherOfChaos = 432794,
    overlord = 428524,
    decimation = 457555,
    ritualPitLord = 432816,
    ritualMother = 432815,
    ritualOverlord = 431944,
    impendingRuin = 387158,
    ritualOfRuin = 387157,
    ruination = 433885,
    backdraft = 117828,
    rainOfChaos = 266087,
    malevolence = 442726,
    amplifyCurse = 328774,
    burningRush = 111400,
    arenaPrep = 32727,
    blitzPrep = 44521,
    soulBurn = 387626,

}

local debuffs = {
    exhaustion = 57723,
    curseOfExhaustion = 334275,
    curseOfTongues = 1714,
    curseOfWeakness = 702,
    curseOfTheSatyr = 442804,
    wither = 445474,
    immolate = 157736,
    eradication = 196414,
    pyrogenics = 387096,
    conflagrate = 265931,
    havoc = 80240,
    fear = 5782,
    mortalCoil = 6789,
    polymorph = 118,
    freezingTrap = 3355,
    paralysis = 115078,
    repentance = 20066,
    hex = 51514,
    banish = 710,
    cyclone = 33786,
    entanglingRoots = 339,
    massEntanglement = 102359,
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

local function isValidTarget(unit)
    return unit:Exists() and 
           not unit:IsDeadOrGhost() and 
           unit:CanAttack() and 
           unit:Los()
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

Pet:AddActionsSpells(267, {
        A.Whiplash.ID,
        A.ShadowBite.ID,
}, true)

local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local count = 0
            local dur = dur or 0

            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Incinerate:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function delayImmo()
    local imCasting = player.castInfo

    if imCasting and imCasting.spellId == Immolate.spellId then

        if not gs.initialTargetGUID then
            gs.initialTargetGUID = target.guid
        end

        if target.guid ~= gs.initialTargetGUID then
            gs.immoDelay = false
        else
            gs.immoDelay = true
        end
    else
        gs.immoDelay = false
        gs.initialTargetGUID = nil
    end
end

-- Advanced Target_if Implementation Functions with Defensive Programming
local function findTargetWithMinImmolateRemains()
    local bestTarget = target
    local minRemains = target and target:DebuffRemains(debuffs.immolate, true) or 999999

    -- Scan all nearby enemies for minimum Immolate remains
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety check for spell range
            if Immolate and Immolate.InRange and Immolate:InRange(unit) then
                local immolateRemains = unit:DebuffRemains(debuffs.immolate, true)
                if immolateRemains and immolateRemains >= 0 and immolateRemains < minRemains then
                    minRemains = immolateRemains
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, minRemains
end

local function findTargetWithMinWitherRemains()
    local bestTarget = target
    local minRemains = target and target:DebuffRemains(debuffs.wither, true) or 999999

    -- Scan all nearby enemies for minimum Wither remains
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety check for spell range
            if Wither and Wither.InRange and Wither:InRange(unit) then
                local witherRemains = unit:DebuffRemains(debuffs.wither, true)
                if witherRemains and witherRemains >= 0 and witherRemains < minRemains then
                    minRemains = witherRemains
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, minRemains
end

local function findOptimalHavocTarget()
    local bestTarget = target
    local bestScore = 999999

    -- Calculate score for current target: ((-ttd)<?-15) + immolate_remains + 99*(is_current_target)
    if target and target.ttd then
        local currentScore = math.max(-target.ttd, -15000) +
        (target:DebuffRemains(debuffs.immolate, true) or 0) +
        (target:DebuffRemains(debuffs.wither, true) or 0) + 99000
        bestScore = currentScore
    end

    -- Scan all nearby enemies for optimal Havoc target
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety checks for spell range and guid comparison
            if Havoc and Havoc.InRange and Havoc:InRange(unit) and unit.guid and target and target.guid and unit.guid ~= target.guid then
                local unitTtd = unit.ttd or 999999
                local immolateRemains = unit:DebuffRemains(debuffs.immolate, true) or 0
                local witherRemains = unit:DebuffRemains(debuffs.wither, true) or 0
                local score = math.max(-unitTtd, -15000) + immolateRemains + witherRemains
                if score < bestScore then
                    bestScore = score
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, bestScore
end

local function findTargetWithMinDotRemains(debuffId)
    local bestTarget = target
    local minRemains = target and target:DebuffRemains(debuffId, true) or 999999

    -- Scan all nearby enemies for minimum debuff remains
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety checks for spell range based on debuff type
            local inRange = false
            if debuffId == debuffs.immolate and Immolate and Immolate.InRange then
                inRange = Immolate:InRange(unit)
            elseif debuffId == debuffs.wither and Wither and Wither.InRange then
                inRange = Wither:InRange(unit)
            end

            if inRange then
                local debuffRemains = unit:DebuffRemains(debuffId, true)
                if debuffRemains and debuffRemains >= 0 and debuffRemains < minRemains then
                    minRemains = debuffRemains
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, minRemains
end

local function findTargetWithMinTtd()
    local bestTarget = target
    local minTtd = target and target.ttd or 999999

    -- Scan all nearby enemies for minimum time to die
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety check for spell range
            if Shadowburn and Shadowburn.InRange and Shadowburn:InRange(unit) then
                local unitTtd = unit.ttd or 999999
                if unitTtd < minTtd then
                    minTtd = unitTtd
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, minTtd
end

local function findTargetForSoulFire()
    local bestTarget = target
    local minScore = 999999

    -- Calculate score: dot.wither.remains + dot.immolate.remains - 5*debuff.conflagrate.up + 100*debuff.havoc.remains
    if target then
        local witherRemains = target:DebuffRemains(debuffs.wither, true) or 0
        local immolateRemains = target:DebuffRemains(debuffs.immolate, true) or 0
        local conflagrateUp = target:Debuff(debuffs.conflagrate, true) and 1 or 0
        local havocUp = target:Debuff(debuffs.havoc, true) and 1 or 0
        local currentScore = witherRemains + immolateRemains - 5000 * conflagrateUp + 100000 * havocUp
        minScore = currentScore
    end

    -- Scan all nearby enemies for optimal Soul Fire target
    for i = 1, 40 do
        local unit = ActionUnit("nameplate" .. i)
        -- Defensive programming: check if unit exists and is valid before calling methods
        if unit and unit.IsExists and unit:IsExists() and unit.CanAttack and unit:CanAttack() then
            -- Additional safety check for spell range
            if SoulFire and SoulFire.InRange and SoulFire:InRange(unit) then
                local witherRemains = unit:DebuffRemains(debuffs.wither, true) or 0
                local immolateRemains = unit:DebuffRemains(debuffs.immolate, true) or 0
                local conflagrateUp = unit:Debuff(debuffs.conflagrate, true) and 1 or 0
                local havocUp = unit:Debuff(debuffs.havoc, true) and 1 or 0
                local score = witherRemains + immolateRemains - 5000 * conflagrateUp + 100000 * havocUp
                if score < minScore then
                    minScore = score
                    bestTarget = unit
                end
            end
        end
    end

    return bestTarget, minScore
end

local function predSoulShards()
    local shardChanges = {
        [Incinerate.id] = 0.2,
        [ChaosBolt.id] = gs.ritualOfRuin and 0 or -20,
        [SoulFire.id] = 10,
        [InfernalBolt.id] = 20,
    }

    local spellId = gs.imCasting
    local currentShards = UnitPower(player:CallerId(), 7, true) -- Destro uses frags rather than full shards

    return math.min(currentShards + (shardChanges[spellId] or 0), 50) / 10
end

local function infernalActive()
    local spellWords = {}
    for word in SummonInfernal.wowName:gmatch("%S+") do
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

local function shouldBurst()
    if A.BurstIsON("target") then
        return true
    end
    return false
end

-- Function to check if friendly players need dispel
local function needsDispel(unit)
    if not unit or not unit.exists or unit.hp <= 0 then return false end

    -- Check for common CC debuffs that Imp can dispel
    local dispellableDebuffs = {
        debuffs.polymorph,
        debuffs.freezingTrap,
        debuffs.paralysis,
        debuffs.repentance,
        debuffs.hex,
        debuffs.banish,
        debuffs.cyclone,
        debuffs.entanglingRoots,
        debuffs.massEntanglement,
    }

    for _, debuffId in ipairs(dispellableDebuffs) do
        if unit:Debuff(debuffId) then
            return true
        end
    end

    return false
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

-- Helper function to determine optimal spender based on target count and conditions
-- Based on general rule:
-- 1-2 targets - Chaos Bolt
-- 3-4 targets during Havoc - Chaos Bolt (Havoc makes Chaos Bolt cleave)
-- 3+ targets without Havoc - Rain of Fire (AoE territory)
-- During Malevolence: Keep pressing Shadowburn on up to 10 targets (Withers stack based on Soul Shard spending)
local function getOptimalSpender()
    -- During Malevolence, Shadowburn is king on up to 10 targets (for Wither stacking via Blackened Soul)
    -- Keep pressing Shadowburn as long as targets will live for the duration of Blackened Soul
    if player:Buff(buffs.malevolence) then
        if gs.activeEnemies <= 10 and player:TalentKnown(Shadowburn.id) and gs.soulShards >= 1 then
            -- Check if targets will live long enough for Blackened Soul duration (8 seconds)
            if target.ttd > 8000 or target.ttd == 0 then
                return "shadowburn"
            end
        end
    end

    -- 1-2 targets: Always Chaos Bolt
    if gs.activeEnemies <= 2 then
        return "chaos_bolt"
    end

    -- 3-4 targets WITH Havoc: Chaos Bolt (Havoc makes it cleave, so it's better)
    if gs.havocUp and gs.activeEnemies <= 4 then
        return "chaos_bolt"
    end

    -- 3+ targets WITHOUT Havoc: Rain of Fire (AoE rotation)
    if gs.activeEnemies >= 3 then
        return "rain_of_fire"
    end

    -- Default fallback
    return "chaos_bolt"
end

local function debuffRemains(spell)
    local cacheKey = spell and (tostring(spell) .. "Remains") or "debuffRemains"

    return constCell:GetOrSet(cacheKey, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()

            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Incinerate:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                    if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                        local duration = enemy:DebuffRemains(spell.wowName, true)
                        if duration > 0 then
                            return duration
                        end
                    end
                end
            end

            return 0
    end)
end

local function ritualOfRuin()
    if player:Buff(buffs.ritualOfRuin) then
        return true
    end

    local isCastingRainOfFire = gs.imCasting and gs.imCasting == RainOfFire.id
    local isCastingChaosBolt = gs.imCasting and gs.imCasting == ChaosBolt.id
    local impendingRuinCount = player:HasBuffCount(buffs.impendingRuin)
    local masterRitualist = 5 * player:TalentKnownInt(MasterRitualist.id)

    if isCastingRainOfFire and impendingRuinCount >= (20 - masterRitualist - RainOfFire.cost) then
        return true
    end

    if isCastingChaosBolt and impendingRuinCount >= (20 - masterRitualist - ChaosBolt.cost) then
        return true
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

    if MultiUnits:GetByRangeCasting(nil, 1, nil, 461904) >= 1 then -- Just disable auto target when affix orbs are out.
        return false
    end

    -- Simple Havoc swap: just tab off if current target has Havoc
    if A.GetToggle(2, "swapOffHavoc") and NotInPvP() and not player:TalentKnown(Mayhem.id) and target:Debuff(debuffs.havoc, true) and gs.activeEnemies >= 2 then
        return true  -- Tab off the Havoc target
    end

    if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < math.max(A.GetToggle(2, "cataTime") * 1000, 500) then
        return false
    end

    if A.GetToggle(2, "autoDOT") and gs.dotCount < math.min(gs.activeEnemies, 5) and (target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true) > 5000 or gs.immoDelay) then
        return true
    end
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


local lastUpdateTime = 0
local updateDelay = 0.6

local function updategs()
    --Soul Shards
    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.imCastingName = currentCastName
        lastUpdateTime = currentTime
    end

    delayImmo()

    gs.soulShards = predSoulShards()

    gs.imCastingRemaining = currentCastRemains
    gs.imCastingLength = currentCastLength

    gs.activeEnemies = activeEnemies()
    gs.fightRemains = fightRemains()
    gs.shouldAoE = A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gs.shouldCleave = gs.activeEnemies == 2 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gs.cleaveApl = A.GetToggle(2, "cleaveApl") or false

    local heroSpecID = C_ClassTalents.GetActiveHeroTalentSpec()
    gs.witherKnown = heroSpecID == 58

    gs.havocRemains = debuffRemains(Havoc)
    gs.havocUp = gs.havocRemains > 0

    gs.immolateRemains = debuffRemains(Immolate)
    gs.witherRemains = debuffRemains(Wither)
    gs.infernalBolt = player:Buff(buffs.infernalBolt) or gs.imCasting and gs.imCasting == ChaosBolt.id and player:Buff(buffs.motherOfChaos)

    gs.chaosBoltInFlight = isSpellInFlight(ChaosBolt, 20)
    gs.soulFireInFlight = isSpellInFlight(SoulFire, 20)

    local cursorCondition = (Incinerate:InRange(mouseover) or UnendingBreath:InRange(mouseover)) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    -- Variable system matching official APL
    gs.pooling = gs.soulShards >= 3 or (player:TalentKnown(SecretsOfTheCoven.id) and gs.infernalBolt or player:Buff(buffs.decimation)) and gs.soulShards >= 3

    gs.infernalActive = infernalActive()

    gs.poolingCb = gs.pooling or gs.infernalActive and gs.soulShards >= 3

    gs.havocImmoTime = num(gs.havocUp) * math.max(gs.immolateRemains, gs.witherRemains)

    gs.infernalActiveBurst = gs.infernalActive or SummonInfernal.cd > 20000

    gs.witherCount = enemiesInRange(debuffs.wither, 1000)
    gs.immoCount = enemiesInRange(debuffs.immolate, 1000)
    gs.dotCount = math.max(gs.witherCount, gs.immoCount)

    gs.demonicArt = player:Buff(buffs.motherOfChaos) or player:Buff(buffs.pitLord) or player:Buff(buffs.overlord)
    gs.diabolicRitual = player:Buff(buffs.ritualMother) or player:Buff(buffs.ritualOverlord) or player:Buff(buffs.ritualPitLord)
    gs.diabolicRitualRemains = player:BuffRemains(buffs.ritualMother) + player:BuffRemains(buffs.ritualOverlord) + player:BuffRemains(buffs.ritualPitLord)
    gs.ritualOfRuin = ritualOfRuin()

    gs.ruination = player:Buff(buffs.ruination) or gs.imCasting and gs.imCasting == ChaosBolt.id and player:Buff(buffs.pitLord)
    gs.eradication = target:Debuff(debuffs.eradication) or (player:TalentKnown(Eradication.id) and (gs.imCasting and gs.imCasting == ChaosBolt.id or gs.chaosBoltInFlight))

    gs.poolSoulShards = Havoc.cd <= 5000 or player:TalentKnown(Mayhem.id)

    gs.holdingCata = A.Cataclysm:IsBlocked() and Cataclysm.cd < 1000

    -- Advanced Set Bonus Logic - TWW Season 3
    local setBonus2pc = false
    local setBonus4pc = false

    -- Check for TWW Season 3 set bonuses (Tier 33)
    -- 2pc: Chaos Bolt and Rain of Fire damage increased by 20%
    -- 4pc: Soul Shard generation increased by 15%, Dimensional Rift cooldown reduced by 25%
    for slot = 1, 19 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            local itemID = GetItemInfoFromHyperlink(itemLink)
            -- TWW Season 3 Warlock set item IDs (example IDs - would need actual IDs)
            local twwSetItems = {
                [212072] = true, [212073] = true, [212074] = true, [212075] = true, [212076] = true -- Example set item IDs
            }
            if twwSetItems[itemID] then
                if not setBonus2pc then setBonus2pc = true end
                if setBonus2pc and not setBonus4pc then setBonus4pc = true end
            end
        end
    end

    gs.setBonusTww3_2pc = setBonus2pc
    gs.setBonusTww3_4pc = setBonus4pc
    gs.setBonusActive = gs.setBonusTww3_2pc or gs.setBonusTww3_4pc

    -- Enhanced Resource Management Variables
    gs.resourceEfficiency = gs.soulShards / 5.0 -- Efficiency ratio (0-1)
    gs.shardGenerationRate = 0.2 + (gs.setBonusTww3_4pc and 0.03 or 0) -- Base + set bonus
    gs.optimalShardThreshold = 3.5 - (gs.setBonusTww3_4pc and 0.5 or 0) -- Reduced threshold with 4pc

    -- Enhanced Fight Remains Calculations
    gs.fightRemainsEnhanced = gs.fightRemains
    if gs.fightRemains < 30000 then -- End of fight scenarios
        gs.optimalShardThreshold = gs.optimalShardThreshold * 0.7 -- Spend more aggressively
    end

    -- Multi-target Thresholds with Set Bonus Adjustments
    gs.cleaveThreshold = 2
    gs.aoeThreshold = 3 - (gs.setBonusTww3_2pc and 1 or 0) -- 2pc makes AoE more attractive

    -- Havoc Target Optimization with safety checks
    if target and target.exists then
        local havocTarget, havocScore = findOptimalHavocTarget()
        gs.havocTargetOptimal = havocTarget
        gs.havocTargetScore = havocScore

        -- Target_if tracking updates
        local immolateTarget, immolateRemains = findTargetWithMinImmolateRemains()
        gs.minImmolateTarget = immolateTarget
        gs.minImmolateRemains = immolateRemains
    else
        -- Fallback values when no target exists
        gs.havocTargetOptimal = nil
        gs.havocTargetScore = 999999
        gs.minImmolateTarget = nil
        gs.minImmolateRemains = 999999
    end

    -- Additional Advanced Variables for Complete APL Parity
    gs.burstWindowActive = gs.demonicArt or gs.diabolicRitual or gs.infernalActive
    gs.resourcePoolingPhase = gs.soulShards < gs.optimalShardThreshold and not gs.burstWindowActive
    gs.endOfFightPhase = gs.fightRemainsEnhanced < 30000

    -- Multi-target optimization variables
    gs.shouldPrioritizeAoE = gs.activeEnemies >= gs.aoeThreshold
    gs.shouldPrioritizeCleave = gs.activeEnemies == gs.cleaveThreshold

    -- Havoc optimization tracking with safety checks
    gs.havocWindowOptimal = gs.havocUp and gs.havocRemains > 5000
    gs.havocTargetAvailable = gs.havocTargetOptimal and gs.havocTargetOptimal.guid and target and target.guid and gs.havocTargetOptimal.guid ~= target.guid

    -- Resource efficiency tracking for end-of-fight scenarios
    if gs.endOfFightPhase then
        gs.shouldSpendAggressively = true
        gs.optimalShardThreshold = gs.optimalShardThreshold * 0.5
    else
        gs.shouldSpendAggressively = false
    end

    -- Update optimal spender based on target count and conditions
    gs.optimalSpender = getOptimalSpender()

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

BurningRush:Callback(function(spell)
        if not player:Buff(buffs.burningRush) then return end
        if not gs.imCasting then return end

        return spell:Cast()
end)

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
            return Soulburn:Cast(player)
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

-- Imp Dispel for friendly players in PvP
SingeMagic:Callback("pvp", function(spell)
        if not A.IsInPvP then return end
        if not pet.exists or pet.hp <= 0 then return end
        if player:Buff(buffs.grimoireOfSacrifice) then return end

        -- Check party members for dispellable debuffs
        local partyUnits = { party1, party2, party3, party4, player }

        for _, unit in ipairs(partyUnits) do
            if needsDispel(unit) and SingeMagic:InRange(unit) then
                return spell:Cast(unit)
            end
        end

        -- Check arena teammates if in arena
        if A.Zone == "arena" then
            local arenaTeammates = { party1, party2 }
            for _, unit in ipairs(arenaTeammates) do
                if needsDispel(unit) and SingeMagic:InRange(unit) then
                    return spell:Cast(unit)
                end
            end
        end
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

SoulFire:Callback("pre", function(spell)
        if gs.activeEnemies ~= 1 then return end
        if gs.imCasting then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

Cataclysm:Callback("pre", function(spell)
        
        if gs.imCasting then return end
        if gs.activeEnemies < 2 then return end
        if A.Zone == "arena" then return end

        return spell:Cast()
end)

Incinerate:Callback("pre", function(spell)
        if gs.imCasting then return end

        return spell:Cast(target)
end)

Berserking:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end

        return spell:Cast()
end)

BloodFury:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end

        return spell:Cast()
end)

Fireblood:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end

        return spell:Cast()
end)

AncestralCall:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end

        return spell:Cast()
end)

local function ogcd()
    -- Sync on-use trinkets and racials with Infernal windows by default
    local syncToInfernal = (gs.infernalActive) or (player:TalentKnown(SummonInfernal.id) and SummonInfernal.cd < A.GetGCD() * 1000) or (not player:TalentKnown(SummonInfernal.id))
    if not syncToInfernal then return end

    if Trinket(1, "Damage") then Trinket1() end
    if Trinket(2, "Damage") then Trinket2() end
    Berserking()
    BloodFury()
    Fireblood()
    AncestralCall()
end

-- Single Target Rotation Callbacks (based on APL default action list)

-- actions+=/malevolence,if=cooldown.summon_infernal.remains>=55
Malevolence:Callback("st", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if gs.shouldAoE then return end
        if not shouldBurst() and cooldowns[2] then return end
        if SummonInfernal.cd < 55000 then return end
        return spell:Cast(target)
end)

-- HIGH PRIORITY: Shadowburn during Malevolence (up to 10 targets for Wither stacking)
-- Since Withers stack based on how many times you spend Soul Shards, keep pressing Shadowburn
-- on up to 10 targets during Malevolence as long as they will live for the duration of Blackened Soul
Shadowburn:Callback("malevolence_priority", function(spell)
        if spell.cost > gs.soulShards then return end
        if not player:Buff(buffs.malevolence) then return end
        if gs.activeEnemies > 10 then return end

        -- Check if target will live for Blackened Soul duration (8 seconds)
        if target.ttd < 8000 and target.ttd > 0 then return end

        return spell:Cast(target)
end)

-- SPENDER PRIORITY SYSTEM based on target count:
-- 1-2 targets: Chaos Bolt
-- 3-4 targets during Havoc: Chaos Bolt (Havoc makes Chaos Bolt cleave)
-- 3+ targets without Havoc: Rain of Fire (AoE rotation)
-- During Malevolence (up to 10 targets): Shadowburn (handled above)

-- Rain of Fire priority when optimal spender says so (3+ targets without Havoc, or 5+ targets with Havoc)
RainOfFire:Callback("optimal_spender", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if gs.optimalSpender ~= "rain_of_fire" then return end
        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end
        if not gs.pooling then return end

        return spell:Cast()
end)

RainOfFireT:Callback("optimal_spender", function(spell)
        if not player:TalentKnown(RainOfFireT.id) then return end
        if gs.optimalSpender ~= "rain_of_fire" then return end
        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end
        if not gs.pooling then return end

        return spell:Cast()
end)

-- actions.default+=/summon_infernal,if=demonic_art
SummonInfernal:Callback("st_demonic_art", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if gs.shouldAoE then return end
        if not shouldBurst() and cooldowns[1] then return end
        if not gs.cursorCheck then return end
        if not gs.demonicArt then return end
        return spell:Cast()
end)

-- actions.default+=/chaos_bolt,if=demonic_art
ChaosBolt:Callback("st_demonic_art", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)

-- actions.default+=/chaos_bolt,if=talent.diabolic_ritual&(demonic_art|((buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<action.chaos_bolt.execute_time)))
ChaosBolt:Callback("st_diabolic_window", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not (gs.demonicArt or (gs.diabolicRitual and gs.diabolicRitualRemains < ChaosBolt:CastTime())) then return end
        return spell:Cast(target)
end)

-- actions.default+=/soul_fire,if=buff.decimation.react&(soul_shard<=4|buff.decimation.remains<=gcd.max*2)&debuff.conflagrate.remains>=execute_time
SoulFire:Callback("st_decimation", function(spell)
        if gs.shouldAoE then return end
        if not player:Buff(buffs.decimation) then return end
        if gs.soulShards > 4 and player:BuffRemains(buffs.decimation) > A.GetGCD() * 2000 then return end
        if target:DebuffRemains(debuffs.conflagrate, true) < spell:CastTime() then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.default+=/wither,if=talent.internal_combustion&(((dot.wither.remains-5*action.chaos_bolt.in_flight)<dot.wither.duration*0.4)|dot.wither.remains<3|(dot.wither.remains-action.chaos_bolt.execute_time)<5&action.chaos_bolt.usable)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains-5))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Wither:Callback("st_internal_combustion", function(spell)
        if not gs.witherKnown then return end
        if gs.shouldAoE then return end
        if not player:TalentKnown(InternalCombustion.id) then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end

        local witherRemains = target:DebuffRemains(debuffs.wither, true)
        local witherDuration = 18000 -- 18 seconds base duration
        local chaosBoltExecuteTime = ChaosBolt:CastTime()

        if ((witherRemains - 5000 * num(gs.chaosBoltInFlight)) < witherDuration * 0.4) or
        witherRemains < 3000 or
        (witherRemains - chaosBoltExecuteTime < 5000 and ChaosBolt:IsUsable()) then

            if not player:TalentKnown(SoulFire.id) or
            (SoulFire.cd + SoulFire:CastTime() > witherRemains - 5000) then
                return spell:Cast(target)
            end
        end
end)

-- Opener: Cast Conflagrate immediately after Summon Infernal
Conflagrate:Callback("opener", function(spell)
        if gs.shouldAoE then return end

        -- Check if Summon Infernal was just cast (within last 2 GCDs)
        local infernalLastUsed = SummonInfernal.lastUsed or 0
        local timeSinceInfernal = (GetTime() * 1000) - infernalLastUsed

        if timeSinceInfernal < (A.GetGCD() * 2000) and timeSinceInfernal > 0 then
            return spell:Cast(target)
        end
end)

-- actions.default+=/conflagrate,if=talent.roaring_blaze&debuff.conflagrate.remains<1.5|full_recharge_time<=gcd.max*2|recharge_time<=8&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<gcd.max)&soul_shard>=1.5
Conflagrate:Callback("st_priority", function(spell)
        if gs.shouldAoE then return end

        if player:TalentKnown(RoaringBlaze.id) and target:DebuffRemains(debuffs.conflagrate, true) < 1500 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= A.GetGCD() * 2000 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= 8000 and
        gs.diabolicRitual and
        gs.diabolicRitualRemains < A.GetGCD() * 1000 and
        gs.soulShards >= 1.5 then
            return spell:Cast(target)
        end
end)

-- actions+=/shadowburn,if=talent.wither&((cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)|fight_remains<=8)
Shadowburn:Callback("st_priority", function(spell)
        if spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end
        if not gs.witherKnown then return end

        if gs.fightRemains <= 8000 then
            return spell:Cast(target)
        end

        if (player:TalentKnown(ConflagrationOfChaos.id) or player:TalentKnown(BlisteringAtrophy.id)) then
            if spell:TimeToFullCharges() <= A.GetGCD() * 3000 then
                return spell:Cast(target)
            end

            if target:DebuffRemains(debuffs.eradication, true) <= A.GetGCD() * 1000 and
            player:TalentKnown(Eradication.id) and
            not gs.chaosBoltInFlight and
            not player:TalentKnown(DiabolicRitual.id) then
                return spell:Cast(target)
            end
        end
end)

-- actions.default+=/chaos_bolt,if=buff.ritual_of_ruin.up
ChaosBolt:Callback("st_ritual_of_ruin", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end
        if not gs.ritualOfRuin then return end

        return spell:Cast(target)
end)

-- actions.default+=/shadowburn,if=(cooldown.summon_infernal.remains>=90&talent.rain_of_chaos)|buff.malevolence.up
-- actions.default+=/chaos_bolt,if=(cooldown.summon_infernal.remains>=90&talent.rain_of_chaos)|buff.malevolence.up
Shadowburn:Callback("st_infernal_malevolence", function(spell)
        if spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end

        if (SummonInfernal.cd >= 90000 and player:TalentKnown(RainOfChaos.id)) or player:Buff(buffs.malevolence) then
            return spell:Cast(target)
        end
end)

ChaosBolt:Callback("st_infernal_malevolence", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if gs.shouldAoE then return end

        if (SummonInfernal.cd >= 90000 and player:TalentKnown(RainOfChaos.id)) or player:Buff(buffs.malevolence) then
            return spell:Cast(target)
        end
end)

-- actions+=/ruination
Ruination:Callback("st", function(spell)
        if gs.shouldAoE then return end
        if not gs.ruination then return end

        return spell:Cast(target)
end)

-- actions.default+=/cataclysm,if=raid_event.adds.in>15&(talent.wither&dot.wither.refreshable)
Cataclysm:Callback("st", function(spell)
        if not gs.cursorCheck then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if gs.shouldAoE then return end
        if A.Zone == "arena" then return end

        if gs.witherKnown and target:DebuffRemains(debuffs.wither, true) < 4000 then
            return spell:Cast()
        end
end)

-- actions.default+=/channel_demonfire,if=talent.raging_demonfire&(dot.immolate.remains+dot.wither.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))>cast_time
ChannelDemonfire:Callback("st_raging", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if gs.shouldAoE then return end
        if not player:TalentKnown(RagingDemonfire.id) then return end

        local dotRemains = target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true)
        local chaosBoltReduction = 5000 * num(gs.chaosBoltInFlight and player:TalentKnown(InternalCombustion.id))

        if (dotRemains - chaosBoltReduction) > spell:CastTime() then
            return spell:Cast()
        end
end)

-- actions.default+=/wither,if=!talent.internal_combustion&(((dot.wither.remains-5*(action.chaos_bolt.in_flight))<dot.wither.duration*0.3)|dot.wither.remains<3)&(!talent.cataclysm|cooldown.cataclysm.remains>dot.wither.remains)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Wither:Callback("st_normal", function(spell)
        if not gs.witherKnown then return end
        if gs.shouldAoE then return end
        if player:TalentKnown(InternalCombustion.id) then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end

        local witherRemains = target:DebuffRemains(debuffs.wither, true)
        local witherDuration = 18000 -- 18 seconds base duration

        if ((witherRemains - 5000 * num(gs.chaosBoltInFlight)) < witherDuration * 0.3) or witherRemains < 3000 then
            if not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > witherRemains then
                if not player:TalentKnown(SoulFire.id) or (SoulFire.cd + SoulFire:CastTime() > witherRemains) then
                    return spell:Cast(target)
                end
            end
        end
end)

-- actions.default+=/immolate,if=(((dot.immolate.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))<dot.immolate.duration*0.3)|dot.immolate.remains<3|(dot.immolate.remains-action.chaos_bolt.execute_time)<5&talent.internal_combustion&action.chaos_bolt.usable)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.immolate.remains-5*talent.internal_combustion))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Immolate:Callback("st", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if gs.shouldAoE then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end

        local immolateRemains = target:DebuffRemains(debuffs.immolate, true)
        local immolateReduction = 5000 * num(gs.chaosBoltInFlight and player:TalentKnown(InternalCombustion.id))
        local immolateThreshold = 18000 * 0.3 -- 30% of 18 second duration
        local chaosBoltExecuteTime = ChaosBolt:CastTime()

        if ((immolateRemains - immolateReduction) < immolateThreshold) or
        immolateRemains < 4000 or
        (immolateRemains - chaosBoltExecuteTime < 5000 and player:TalentKnown(InternalCombustion.id) and ChaosBolt:IsUsable()) then

            local soulFireCondition = not player:TalentKnown(SoulFire.id) or
            (SoulFire.cd + SoulFire:CastTime() > immolateRemains - 5000 * player:TalentKnownInt(InternalCombustion.id))

            if soulFireCondition then
                return spell:Cast(target)
            end
        end
end)

-- actions.default+=/incinerate,if=talent.diabolic_ritual&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains-2-!variable.disable_cb_2t*action.chaos_bolt.cast_time-variable.disable_cb_2t*gcd.max)<=0)
Incinerate:Callback("st_diabolic_ritual", function(spell)
        if gs.shouldAoE then return end
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not gs.diabolicRitual then return end

        local ritualRemains = gs.diabolicRitualRemains - 2000 - ChaosBolt:CastTime() - A.GetGCD() * 1000

        if ritualRemains <= 0 then
            return spell:Cast(target)
        end
end)

-- actions.default+=/chaos_bolt,if=(variable.pooling_condition_cb&(cooldown.summon_infernal.remains>=gcd.max*3|soul_shard>4))&(talent.wither|((buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)>(action.chaos_bolt.execute_time+2*gcd.max)))
ChaosBolt:Callback("st_pooling", function(spell)
        -- Enhanced Resource Management with Set Bonus Logic
        local adjustedCost = spell.cost
        if gs.setBonusTww3_4pc then
            adjustedCost = adjustedCost * 0.85 -- 4pc reduces effective cost by 15%
        end

        if adjustedCost and adjustedCost > gs.soulShards then return end
        if gs.shouldAoE then return end
        if not gs.poolingCb then return end

        -- Require Wither OR (for Diabolist) sufficient Diabolic Ritual remains
        -- If Diabolist remains are not detected (buffs missing), allow a safety spend at shard cap to avoid lockups
        local diabolicWindowOK = true
        if not gs.witherKnown then
            if player:TalentKnown(DiabolicRitual.id) then
                if gs.diabolicRitual then
                    diabolicWindowOK = gs.diabolicRitualRemains > (ChaosBolt:CastTime() + 2 * A.GetGCD() * 1000)
                else
                    -- Fallback: if shards are about to cap and we aren't reading the ritual buffs, allow CB to spend
                    diabolicWindowOK = gs.soulShards > 4.5
                end
            end
        end
        if not diabolicWindowOK then return end

        -- Enhanced resource thresholds with set bonus adjustments
        local shardThreshold = gs.optimalShardThreshold
        local infernalCondition = SummonInfernal.cd >= A.GetGCD() * 3000 or gs.soulShards > shardThreshold

        -- Set bonus enhanced burst window detection
        if gs.setBonusTww3_2pc and (gs.demonicArt or gs.diabolicRitual) then
            infernalCondition = infernalCondition or gs.soulShards > (shardThreshold - 1)
        end

        if infernalCondition then
            return spell:Cast(target)
        end
end)

-- actions.default+=/channel_demonfire
ChannelDemonfire:Callback("st", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if gs.shouldAoE then return end

        return spell:Cast()
end)

-- actions.default+=/dimensional_rift
DimensionalRift:Callback("st", function(spell)
        if gs.shouldAoE then return end

        return spell:Cast(target)
end)

-- actions+=/summon_infernal
SummonInfernal:Callback("st", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if gs.shouldAoE then return end
        if not shouldBurst() and cooldowns[1] then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

-- actions+=/infernal_bolt,if=soul_shard<=3
InfernalBolt:Callback("st", function(spell)
        if gs.imCasting and gs.imCasting == spell.id then return end
        if gs.shouldAoE then return end
        if not gs.infernalBolt then return end
        if gs.soulShards > 3 then return end

        return spell:Cast(target)
end)

-- actions.default+=/conflagrate,if=charges>(max_charges-1)|fight_remains<gcd.max*charges
Conflagrate:Callback("st_charges", function(spell)
        if gs.shouldAoE then return end

        if spell.frac > (spell.maxCharges - 1) or gs.fightRemains < A.GetGCD() * spell.frac * 1000 then
            return spell:Cast(target)
        end
end)

-- actions.default+=/soul_fire,if=buff.backdraft.up
SoulFire:Callback("st_backdraft", function(spell)
        if gs.shouldAoE then return end
        if not player:Buff(buffs.backdraft) then return end


        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.default+=/incinerate


Incinerate:Callback("st_filler", function(spell)
        if gs.shouldAoE then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)


-- Prefer Soul Fire during Roaring Blaze window as a filler over other generators (no Decimation)
SoulFire:Callback("st_rb", function(spell)
        if gs.activeEnemies > 2 then return end
        if not player:TalentKnown(RoaringBlaze.id) then return end
        if player:Buff(buffs.decimation) then return end
        if gs.soulShards >= 4.5 then return end
        if target:DebuffRemains(debuffs.conflagrate, true) <= spell:CastTime() then return end

        return spell:Cast(target)
end)

-- Cleave Rotation Callbacks (based on APL cleave action list)

-- actions.cleave+=/malevolence,if=(!cooldown.summon_infernal.up|!talent.summon_infernal)
Malevolence:Callback("cleave", function(spell)
        if not gs.shouldCleave and not gs.cleaveApl then return end
        if SummonInfernal.cd < 1000 and player:TalentKnown(SummonInfernal.id) then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/havoc,target_if=min:((-target.time_to_die)<?-15)+dot.immolate.remains+99*(self.target=target),if=(!cooldown.summon_infernal.up|!talent.summon_infernal)&target.time_to_die>8
Havoc:Callback("cleave", function(spell)
        if A.IsInPvP then return end 
        if not gs.shouldCleave and not gs.cleaveApl then return end
        if SummonInfernal.cd < 1000 and player:TalentKnown(SummonInfernal.id) then return end

        -- Use advanced target_if logic for optimal Havoc target selection with safety checks
        local optimalTarget = gs.havocTargetOptimal or target
        if not optimalTarget or not optimalTarget.ttd or optimalTarget.ttd < 8000 then return end

        return spell:Cast(optimalTarget)
end)

-- actions.cleave+=/chaos_bolt,if=demonic_art
ChaosBolt:Callback("cleave_demonic_art", function(spell)
        if not gs.shouldCleave and not gs.cleaveApl then return end
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)


-- actions.havoc=conflagrate,if=talent.backdraft&buff.backdraft.down&soul_shard>=1&soul_shard<=4
Conflagrate:Callback("havoc", function(spell)
        if not player:TalentKnown(Backdraft.id) then return end
        if player:Buff(buffs.backdraft) then return end
        if gs.soulShards < 1 then return end
        if gs.soulShards > 4 then return end

        return spell:Cast(target)
end)

-- actions.havoc+=/soul_fire,if=cast_time<havoc_remains&soul_shard<2.5
SoulFire:Callback("havoc", function(spell)
        if spell:CastTime() > gs.havocRemains then return end
        if gs.soulShards >= 2.5 then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.havoc+=/cataclysm,if=raid_event.adds.in>15|(talent.wither&dot.wither.remains<action.wither.duration*0.3)
Cataclysm:Callback("havoc", function(spell)
        if not gs.cursorCheck then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if A.Zone == "arena" then return end
        if not gs.witherKnown then return end
        local witherRem = target:DebuffRemains(debuffs.wither, true)
        local witherDur = 18000
        if witherRem >= witherDur * 0.3 then return end

        return spell:Cast()
end)

-- actions.havoc+=/immolate,target_if=min:dot.immolate.remains+100*debuff.havoc.remains,if=(((dot.immolate.refreshable&variable.havoc_immo_time<5.4)&target.time_to_die>5)|((dot.immolate.remains<2&dot.immolate.remains<havoc_remains)|!dot.immolate.ticking|variable.havoc_immo_time<2)&target.time_to_die>11)&soul_shard<4.5
Immolate:Callback("havoc", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if gs.soulShards >= 4.5 then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 500 and not gs.holdingCata then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        -- Use advanced target_if logic: min:dot.immolate.remains+100*debuff.havoc.remains
        local bestTarget = gs.minImmolateTarget or target
        if not bestTarget or not bestTarget.ttd or bestTarget.ttd < 11000 then return end

        local immolateRemains = bestTarget:DebuffRemains(debuffs.immolate, true) or 0
        local havocImmoTime = num(bestTarget:Debuff(debuffs.havoc, true)) * immolateRemains

        if (immolateRemains < 4000 and havocImmoTime < 5400 and bestTarget.ttd > 5000) or havocImmoTime < 2000 then
            return spell:Cast(bestTarget)
        end
end)

-- actions.havoc+=/wither,target_if=min:dot.wither.remains+100*debuff.havoc.remains,if=(((dot.wither.refreshable&variable.havoc_immo_time<5.4)&target.time_to_die>5)|((dot.wither.remains<2&dot.wither.remains<havoc_remains)|!dot.wither.ticking|variable.havoc_immo_time<2)&target.time_to_die>11)&soul_shard<4.5
Wither:Callback("havoc", function(spell)
        if not gs.witherKnown then return end
        if gs.soulShards >= 4.5 then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        -- Use advanced target_if logic: min:dot.wither.remains+100*debuff.havoc.remains
        local bestTarget, minRemains = findTargetWithMinWitherRemains()
        if not bestTarget or not bestTarget.ttd or bestTarget.ttd < 11000 then return end

        local witherRemains = bestTarget:DebuffRemains(debuffs.wither, true) or 0
        local havocImmoTime = num(bestTarget:Debuff(debuffs.havoc, true)) * witherRemains

        if (witherRemains < 4000 and havocImmoTime < 5400 and bestTarget.ttd > 5000) or havocImmoTime < 2000 then
            return spell:Cast(bestTarget)
        end
end)

-- actions.havoc+=/shadowburn,if=active_enemies<=4&(cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)
-- actions.havoc+=/shadowburn,if=active_enemies<=4&havoc_remains<=gcd.max*3
Shadowburn:Callback("havoc", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end
        --if A.IsInPvP then return end
        if gs.activeEnemies > 4 then return end

        if player:TalentKnown(ConflagrationOfChaos.id) or player:TalentKnown(BlisteringAtrophy.id) then
            if spell:TimeToFullCharges() <= A.GetGCD() * 3000 then
                return spell:Cast(target)
            end

            if target:DebuffRemains(debuffs.eradication, true) <= A.GetGCD() * 1000 and player:TalentKnown(Eradication.id) and not gs.chaosBoltInFlight and not player:TalentKnown(DiabolicRitual.id) then
                return spell:Cast(target)
            end
        end

        if gs.havocRemains <= A.GetGCD() * 3000 then
            return spell:Cast(target)
        end
end)

-- actions.havoc+=/chaos_bolt,if=cast_time<havoc_remains&((!talent.improved_chaos_bolt&active_enemies<=2)|(talent.improved_chaos_bolt&((talent.wither&talent.inferno&active_enemies<=2)|(((talent.wither&talent.cataclysm&active_enemies<=4)|(!talent.wither&talent.inferno))&active_enemies<=3)|(!talent.wither&talent.cataclysm&active_enemies<=5))))
ChaosBolt:Callback("havoc", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if spell:CastTime() > gs.havocRemains then return end

        if ((not player:TalentKnown(ImprovedChaosBolt.id) and gs.activeEnemies <= 2) or (player:TalentKnown(ImprovedChaosBolt.id) and ((gs.witherKnown and player:TalentKnown(Inferno.id) and gs.activeEnemies <= 2) or (((gs.witherKnown and player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 4) or (not gs.witherKnown and player:TalentKnown(Inferno.id))) and gs.activeEnemies <= 3) or (not gs.witherKnown and player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 5)))) then
            return spell:Cast(target)
        end
end)

-- actions.havoc+=/rain_of_fire,if=active_enemies>=3-talent.wither
RainOfFire:Callback("havoc", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

-- actions.havoc+=/rain_of_fire,if=active_enemies>=3-talent.wither
RainOfFireT:Callback("havoc", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end

        return spell:Cast(target)
end)

-- actions.havoc+=/channel_demonfire,if=soul_shard<4.5
ChannelDemonfire:Callback("havoc", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if gs.soulShards >= 4.5 then return end

        return spell:Cast()
end)

-- actions.havoc+=/conflagrate,if=!talent.backdraft
Conflagrate:Callback("havoc2", function(spell)
        if player:TalentKnown(Backdraft.id) then return end

        return spell:Cast(target)
end)

-- actions.havoc+=/dimensional_rift,if=soul_shard<4.7&(charges>2|fight_remains<cooldown.dimensional_rift.duration)
DimensionalRift:Callback("havoc", function(spell)
        -- Enhanced Resource Management with Set Bonus Logic
        local shardThreshold = 4.7
        if gs.setBonusTww3_4pc then
            shardThreshold = shardThreshold + 0.5 -- 4pc allows higher shard usage
        end

        if gs.soulShards >= shardThreshold then return end

        -- Set bonus reduces cooldown by 25%
        local adjustedCd = spell.cd
        if gs.setBonusTww3_4pc then
            adjustedCd = adjustedCd * 0.75
        end

        if spell.frac <= 2 and gs.fightRemainsEnhanced >= adjustedCd then return end

        return spell:Cast(target)
end)

-- actions.havoc+=/incinerate,if=cast_time<havoc_remains
Incinerate:Callback("havoc", function(spell)
        if spell:CastTime() >= gs.havocRemains then return end
        if gs.soulShards >= 4.5 then return end


        return spell:Cast(target)
end)

local function havocRot()
    Conflagrate("havoc")
    SoulFire("havoc")
    Cataclysm("havoc")
    Immolate("havoc")
    Wither("havoc")
    Shadowburn("havoc")
    ChaosBolt("havoc")
    RainOfFire("havoc")
    RainOfFireT("havoc")
    ChannelDemonfire("havoc")
    Conflagrate("havoc2")
    DimensionalRift("havoc")
    Incinerate("havoc")
end

local function cleaveRotation()
    -- Cleave rotation based on official SimC APL cleave action list
    -- Opener sequence: Conflagrate -> Malevolence for proper burst alignment
    Havoc("cleave")
    Conflagrate("opener")        -- Opener: Cast immediately after Summon Infernal (or at start of burst)
    Malevolence("cleave")        -- Opener: Cast after Conflagrate

    -- HIGH PRIORITY: Shadowburn during Malevolence for Wither stacking
    Shadowburn("malevolence_priority")

    Conflagrate("st_priority")   -- Priority: Use for Roaring Blaze maintenance and charge management
    ChaosBolt("cleave_demonic_art")
    SoulFire("st_decimation")
    Wither("st_internal_combustion")
    Wither("st_normal")
    Shadowburn("st_priority")
    Shadowburn("st_infernal_malevolence")
    SoulFire("st_rb")

    ChaosBolt("st_infernal_malevolence")
    Ruination("st")
    Cataclysm("st")
    SoulFire("st_backdraft")
    Immolate("st")
    SummonInfernal("st")
    ChannelDemonfire("st_raging")  -- Moved down: Channel Demonfire should not interrupt opener sequence
    Incinerate("st_diabolic_ritual")
    SoulFire("st_backdraft")

    -- Optimal spender priority (enforces target count rules)
    RainOfFire("optimal_spender")
    RainOfFireT("optimal_spender")

    ChaosBolt("st_pooling")
    ChannelDemonfire("st")
    DimensionalRift("st")
    InfernalBolt("st")
    Conflagrate("st_charges")
    Incinerate("st_filler")
end

-- ========================================
-- SINGLE-TARGET OPENER CALLBACKS
-- ========================================
-- Opener Step 2: Summon Infernal
SummonInfernal:Callback("st_opener", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 8000 then return end -- Only during opener (first 8 seconds)
    if spell.cd > 0 then return end

    -- Cast Infernal at start of combat (0-8 seconds)
    if player.combatTime >= 0 and player.combatTime <= 8000 then
        return spell:Cast()
    end
end)

-- Opener Step 3: Conflagrate (first cast)
Conflagrate:Callback("st_opener_first", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 10000 then return end -- Only during opener (first 10 seconds)
    if spell.cd > 0 then return end

    -- Cast immediately after Summon Infernal (within 2 GCDs)
    local infernalLastUsed = SummonInfernal.lastUsed or 0
    local timeSinceInfernal = (GetTime() * 1000) - infernalLastUsed

    if timeSinceInfernal < (A.GetGCD() * 2000) and timeSinceInfernal > 0 then
        return spell:Cast(target)
    end
end)

-- Opener Step 4: Malevolence
Malevolence:Callback("st_opener", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 12000 then return end -- Only during opener (first 12 seconds)
    if spell.cd > 0 then return end

    -- Cast after first Conflagrate (within 2 GCDs)
    local conflagLastUsed = Conflagrate.lastUsed or 0
    local timeSinceConflag = (GetTime() * 1000) - conflagLastUsed

    if timeSinceConflag < (A.GetGCD() * 2500) and timeSinceConflag > 0 then
        return spell:Cast(target)
    end
end)

-- Opener Step 5: Chaos Bolt (first cast)
ChaosBolt:Callback("st_opener_first", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 15000 then return end -- Only during opener (first 15 seconds)
    if spell.cost > gs.soulShards then return end

    -- Cast after Malevolence (within 2 GCDs)
    local malevolenceLastUsed = Malevolence.lastUsed or 0
    local timeSinceMalevolence = (GetTime() * 1000) - malevolenceLastUsed

    if timeSinceMalevolence < (A.GetGCD() * 2500) and timeSinceMalevolence > 0 then
        return spell:Cast(target)
    end
end)

-- Opener Step 6: Incinerate (filler)
Incinerate:Callback("st_opener", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 18000 then return end -- Only during opener (first 18 seconds)

    -- Cast after first Chaos Bolt (around 8-12 seconds)
    if player.combatTime >= 8000 and player.combatTime <= 18000 then
        -- Only cast if we're not about to cap on shards
        if gs.soulShards < 4.5 then
            return spell:Cast(target)
        end
    end
end)

-- Opener Step 7: Conflagrate (second cast)
Conflagrate:Callback("st_opener_second", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 20000 then return end -- Only during opener (first 20 seconds)
    if spell.cd > 0 then return end

    -- Cast second Conflagrate during opener (around 10-15 seconds)
    if player.combatTime >= 10000 and player.combatTime <= 20000 then
        -- Check if we've already cast Conflagrate at least once
        local conflagLastUsed = Conflagrate.lastUsed or 0
        local timeSinceConflag = (GetTime() * 1000) - conflagLastUsed

        -- Allow second cast if enough time has passed
        if timeSinceConflag > 5000 then
            return spell:Cast(target)
        end
    end
end)

-- Opener Step 8: Chaos Bolt (second cast)
ChaosBolt:Callback("st_opener_second", function(spell)
    if gs.shouldAoE then return end
    if player.combatTime > 22000 then return end -- Only during opener (first 22 seconds)
    if spell.cost > gs.soulShards then return end

    -- Cast second Chaos Bolt during opener (around 12-18 seconds)
    if player.combatTime >= 12000 and player.combatTime <= 22000 then
        -- Check if we've already cast Chaos Bolt at least once
        local cbLastUsed = ChaosBolt.lastUsed or 0
        local timeSinceCB = (GetTime() * 1000) - cbLastUsed

        -- Allow second cast if enough time has passed
        if timeSinceCB > 4000 then
            return spell:Cast(target)
        end
    end
end)

local function singleTargetRotation()
    -- Single target rotation based on official SimC APL priority
    -- Opener sequence:
    -- 1. Precast Soulfire 4 seconds before pull (handled in precombat)
    -- 2. Summon Infernal
    -- 3. Conflagrate
    -- 4. Malevolence + on-use trinket, racial, potion
    -- 5. Chaos Bolt
    -- 6. Incinerate
    -- 7. Conflagrate
    -- 8. Chaos Bolt

    -- Opener: Precast Soulfire (handled in precombat)
    -- Opener: Summon Infernal
    SummonInfernal("st_opener")

    -- Opener: Conflagrate (first cast)
    Conflagrate("st_opener_first")

    -- Opener: Malevolence
    Malevolence("st_opener")

    -- Opener: Chaos Bolt (first cast)
    ChaosBolt("st_opener_first")

    -- Opener: Incinerate (filler)
    Incinerate("st_opener")

    -- Opener: Conflagrate (second cast)
    Conflagrate("st_opener_second")

    -- Opener: Chaos Bolt (second cast)
    ChaosBolt("st_opener_second")

    -- Regular rotation starts here
    SummonInfernal("st_demonic_art")
    Conflagrate("opener")        -- Fallback: Cast immediately after Summon Infernal
    Malevolence("st")            -- Fallback: Cast after Conflagrate

    -- HIGH PRIORITY: Shadowburn during Malevolence for Wither stacking
    Shadowburn("malevolence_priority")

    Conflagrate("st_priority")   -- Priority: Use for Roaring Blaze maintenance and charge management
    ChaosBolt("st_diabolic_window")
    SoulFire("st_decimation")
    Wither("st_internal_combustion")
    Shadowburn("st_priority")
    Shadowburn("st_infernal_malevolence")
    SoulFire("st_rb")

    ChaosBolt("st_infernal_malevolence")
    Ruination("st")
    Cataclysm("st")
    Wither("st_normal")
    Immolate("st")
    SummonInfernal("st")
    ChannelDemonfire("st_raging")  -- Moved down: Channel Demonfire should not interrupt opener sequence

    -- Optimal spender priority (enforces target count rules)
    RainOfFire("optimal_spender")
    RainOfFireT("optimal_spender")

    ChaosBolt("st_pooling")
    ChaosBolt("st4")
    ChannelDemonfire("st")
    DimensionalRift("st")
    InfernalBolt("st")
    Conflagrate("st_charges")
    Incinerate("st_filler")
end

-- ========================================
-- AoE OPENER CALLBACKS (3+ targets)
-- ========================================
-- Opener Step 2: Apply Immolate to targets not hit by Cataclysm
Immolate:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if gs.witherKnown then return end -- Use Wither instead if talented
    if player.combatTime > 15000 then return end -- Only during opener (first 15 seconds)

    -- Apply to targets missing Immolate
    if target:DebuffRemains(debuffs.immolate, true) == 0 then
        return spell:Cast(target)
    end
end)

-- Opener Step 2: Apply Wither to targets not hit by Cataclysm
Wither:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if not gs.witherKnown then return end
    if player.combatTime > 15000 then return end -- Only during opener (first 15 seconds)

    -- Apply to targets missing Wither
    if target:DebuffRemains(debuffs.wither, true) == 0 then
        return spell:Cast(target)
    end
end)

-- Opener Step 3: Summon Infernal
SummonInfernal:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 10000 then return end -- Only during opener (first 10 seconds)
    if spell.cd > 0 then return end

    -- Cast Infernal early in AoE opener
    if player.combatTime >= 2000 and player.combatTime <= 10000 then
        return spell:Cast()
    end
end)

-- Opener Step 4: Channel Demonfire (if specced into it)
ChannelDemonfire:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if not player:TalentKnown(RagingDemonfire.id) then return end
    if player.combatTime > 12000 then return end -- Only during opener (first 12 seconds)

    -- Cast after Infernal (around 4-6 seconds into combat)
    if player.combatTime >= 4000 and player.combatTime <= 12000 then
        -- Check if we have DoTs up
        local dotDuration = target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true)
        if dotDuration > spell:CastTime() then
            return spell:Cast()
        end
    end
end)

-- Opener Step 5: Malevolence
Malevolence:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 15000 then return end -- Only during opener (first 15 seconds)
    if spell.cd > 0 then return end

    -- Cast after Channel Demonfire or Infernal (around 6-8 seconds)
    if player.combatTime >= 6000 and player.combatTime <= 15000 then
        return spell:Cast(target)
    end
end)

-- Opener Step 6: Rain of Fire (first cast)
RainOfFire:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if not gs.cursorCheck then return end
    if player.combatTime > 18000 then return end -- Only during opener (first 18 seconds)
    if spell.cost > gs.soulShards then return end

    -- Cast after Malevolence (around 8-12 seconds)
    if player.combatTime >= 8000 and player.combatTime <= 18000 then
        -- Check if we haven't cast RoF recently (allow 2 casts)
        local rofLastUsed = spell.lastUsed or 0
        local timeSinceRof = (GetTime() * 1000) - rofLastUsed
        if timeSinceRof > 3000 or timeSinceRof == (GetTime() * 1000) then
            return spell:Cast()
        end
    end
end)

RainOfFireT:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 18000 then return end -- Only during opener (first 18 seconds)
    if spell.cost > gs.soulShards then return end

    -- Cast after Malevolence (around 8-12 seconds)
    if player.combatTime >= 8000 and player.combatTime <= 18000 then
        -- Check if we haven't cast RoF recently (allow 2 casts)
        local rofLastUsed = spell.lastUsed or 0
        local timeSinceRof = (GetTime() * 1000) - rofLastUsed
        if timeSinceRof > 3000 or timeSinceRof == (GetTime() * 1000) then
            return spell:Cast()
        end
    end
end)

-- Opener Step 7: Havoc
-- Note: Havoc should be applied to any target that will live for its full duration
-- that is not your main target, just to increase Soul Shard generation from Incinerate and Conflagrate
Havoc:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 20000 then return end -- Only during opener (first 20 seconds)
    if spell.cd > 0 then return end

    -- Cast after first Rain of Fire casts (around 12-15 seconds)
    if player.combatTime >= 12000 and player.combatTime <= 20000 then
        -- Apply to a target that will live for full duration (not main target)
        if target.ttd > 12000 or target.ttd == 0 then
            return spell:Cast(target)
        end
    end
end)

-- Opener: Conflagrate for shard generation during opener
Conflagrate:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 25000 then return end -- Only during opener (first 25 seconds)
    if spell.cd > 0 then return end

    -- Use Conflagrate charges during opener for shard generation
    if player.combatTime >= 10000 and player.combatTime <= 25000 then
        return spell:Cast(target)
    end
end)

-- Opener: Incinerate for shard generation during opener
Incinerate:Callback("aoe_opener", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 25000 then return end -- Only during opener (first 25 seconds)

    -- Use Incinerate as filler during opener for shard generation
    -- Only if we're not about to cap on shards and not currently casting something more important
    if player.combatTime >= 10000 and player.combatTime <= 25000 then
        if gs.soulShards < 4.5 then
            return spell:Cast(target)
        end
    end
end)

-- Opener Step 8: Rain of Fire (if at 5 soul shards during opener)
-- "At any point during your AoE opener if you were to reach 5 Soul Shards you should cast a Rain of Fire"
RainOfFire:Callback("aoe_opener_5shards", function(spell)
    if not gs.shouldAoE then return end
    if not gs.cursorCheck then return end
    if player.combatTime > 25000 then return end -- Only during opener (first 25 seconds)
    if gs.soulShards < 5 then return end -- Only if at 5 shards

    -- Cast if we're at 5 shards during opener
    if player.combatTime >= 15000 and player.combatTime <= 25000 then
        return spell:Cast()
    end
end)

RainOfFireT:Callback("aoe_opener_5shards", function(spell)
    if not gs.shouldAoE then return end
    if player.combatTime > 25000 then return end -- Only during opener (first 25 seconds)
    if gs.soulShards < 5 then return end -- Only if at 5 shards

    -- Cast if we're at 5 shards during opener
    if player.combatTime >= 15000 and player.combatTime <= 25000 then
        return spell:Cast()
    end
end)

local function aoeRotation()
    -- AoE rotation based on SimulationCraft APL
    -- AoE Opener sequence (3+ targets):
    -- 1. Precast Cataclysm 1 second before pull
    -- 2. Apply Immolate/Wither to targets not hit by Cataclysm
    -- 3. Summon Infernal
    -- 4. Channel Demonfire (if specced)
    -- 5. Malevolence + on-use trinket, racial, potion
    -- 6. Rain of Fire x2
    -- 7. Havoc
    -- 8. Rain of Fire (if at 5 soul shards during opener)

    -- Opener: Precast Cataclysm (handled in precombat)
    -- Opener: Apply Immolate/Wither to targets not hit by Cataclysm
    Immolate("aoe_opener")
    Wither("aoe_opener")

    -- Opener: Summon Infernal
    SummonInfernal("aoe_opener")

    -- Opener: Channel Demonfire (if specced into it)
    ChannelDemonfire("aoe_opener")

    -- Opener: Malevolence (on-use trinket, racial, potion handled separately)
    Malevolence("aoe_opener")

    -- Opener: Rain of Fire x2
    RainOfFire("aoe_opener")
    RainOfFireT("aoe_opener")

    -- Opener: Havoc
    Havoc("aoe_opener")

    -- Opener: Conflagrate and Incinerate for shard generation
    Conflagrate("aoe_opener")
    Incinerate("aoe_opener")

    -- Opener: Rain of Fire (if at 5 soul shards during opener)
    RainOfFire("aoe_opener_5shards")
    RainOfFireT("aoe_opener_5shards")

    -- Regular rotation starts here
    SummonInfernal("aoe")
    Malevolence("default")

    -- HIGH PRIORITY: Shadowburn during Malevolence for Wither stacking (up to 10 targets)
    Shadowburn("malevolence_priority")

    RainOfFire("aoe_toggle")
    RainOfFireT("aoe_toggle")

    RainOfFire("aoe_demonic_art")
    RainOfFireT("aoe_demonic_art")
    ChaosBolt("aoe_diabolic")

    Incinerate("aoe_diabolic")
    -- Havoc rotation is called separately when conditions are met
    DimensionalRift("aoe")

    -- Optimal spender priority (enforces target count rules)
    RainOfFire("optimal_spender")
    RainOfFireT("optimal_spender")

    RainOfFire("aoe2")  -- Fixed: was "aoe_pooling", now maps to aoe2 (pooling conditions)
    RainOfFireT("aoe2") -- Fixed: was "aoe_pooling", now maps to aoe2 (pooling conditions)
    Wither("aoe")
    ChannelDemonfire("aoe_raging")
    Shadowburn("aoe")
    Ruination("aoe")
    RainOfFire("aoe3")  -- Fixed: was "aoe_infernal", now maps to aoe3 (infernal active conditions)
    RainOfFireT("aoe3") -- Fixed: was "aoe_infernal", now maps to aoe3 (infernal active conditions)
    SoulFire("aoe")     -- Fixed: was "aoe_decimation_havoc", now maps to aoe (decimation with havoc conditions)
    SoulFire("aoe2")    -- Fixed: was "aoe_decimation", now maps to aoe2 (basic decimation in AoE)
    InfernalBolt("aoe")
    ChaosBolt("aoe")
    Cataclysm("aoe")
    Havoc("aoe")
    Wither("aoe2")
    Immolate("aoe")
    SummonInfernal("aoe")  -- Use AoE-specific Infernal per engine APL (PI/long fight)
    RainOfFire("aoe4")
    RainOfFireT("aoe4")
    ChannelDemonfire("aoe")
    Immolate("aoe2")
    DimensionalRift("aoe2")
    SoulFire("aoe2")
    Incinerate("aoe2")
    Conflagrate("aoe")
    Incinerate("aoe_filler")
end

-- Additional AoE callbacks based on SimulationCraft APL

DemonicHealthstone:Callback('Stone', function(spell)

    if A.Soulburn:IsTalentLearned() and gs.soulShards >= 1 and Soulburn.cd < 300 then
        return Soulburn:Cast(player)
    end

end)

-- actions.aoe+=/channel_demonfire,if=dot.immolate.remains+dot.wither.remains>cast_time
ChannelDemonfire:Callback("aoe", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if not gs.shouldAoE then return end

        local dotRemains = target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true)
        if dotRemains > spell:CastTime() then
            return spell:Cast()
        end
end)

-- actions.aoe+=/immolate,target_if=min:dot.immolate.remains+99*debuff.havoc.remains,if=((dot.immolate.refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.immolate.remains))|active_enemies>active_dot.immolate)&target.time_to_die>10&!havoc_active
Immolate:Callback("aoe2", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if not gs.shouldAoE then return end
        if target.ttd < 10000 then return end
        if gs.havocUp and target:DebuffRemains(debuffs.immolate, true) > 4000 then return end

        local immolateRefreshable = target:DebuffRemains(debuffs.immolate, true) < 4000
        local cataCondition = not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > target:DebuffRemains(debuffs.immolate, true)

        if (immolateRefreshable and cataCondition) or gs.activeEnemies > gs.immoCount then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/soul_fire,target_if=min:(dot.wither.remains+dot.immolate.remains-5*debuff.conflagrate.up+100*debuff.havoc.remains),if=buff.decimation.up
SoulFire:Callback("aoe2", function(spell)
        if not gs.shouldAoE then return end
        if not player:Buff(buffs.decimation) then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)
        if gs.soulShards >= 4.5 then return end


-- actions.aoe+=/incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up
Incinerate:Callback("aoe2", function(spell)
        if not gs.shouldAoE then return end
        if not player:TalentKnown(FireAndBrimstone.id) then return end
        if not player:Buff(buffs.backdraft) then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

-- actions.aoe+=/conflagrate,if=buff.backdraft.stack<2|!talent.backdraft
Conflagrate:Callback("aoe", function(spell)
        if not gs.shouldAoE then return end

        if player:BuffCount(buffs.backdraft) < 2 or not player:TalentKnown(Backdraft.id) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/dimensional_rift
DimensionalRift:Callback("aoe2", function(spell)
        if not gs.shouldAoE then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/incinerate
Incinerate:Callback("aoe_filler", function(spell)
        if not gs.shouldAoE then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

RainOfFire:Callback("force", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end

        if player.combatTime > 2 then return end
        if not gs.cursorCheck then return end
        if spell.cost > gs.soulShards then return end

        if gs.imCasting and gs.imCastng == SoulFire.id then
            return spell:Cast()
        end
end)

RainOfFireT:Callback("force", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end

        if player.combatTime > 2 then return end
        if spell.cost > gs.soulShards then return end

        if gs.imCasting and gs.imCastng == SoulFire.id then
            return spell:Cast(target)
        end
end)

-- actions.default+=/malevolence,if=cooldown.summon_infernal.remains>=55
-- actions.aoe+=/malevolence,if=cooldown.summon_infernal.remains>=55&soul_shard<4.7&(active_enemies<=3+active_dot.wither|time>30)
Malevolence:Callback("default", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[2] then return end

        if SummonInfernal.cd < 55000 then return end

        -- Single target condition
        if not gs.shouldAoE then
            return spell:Cast()
        end

        -- AoE conditions
        if gs.soulShards >= 4.7 then return end
        if gs.activeEnemies <= 3 + gs.witherCount or player.combatTime > 30000 then
            return spell:Cast()
        end
end)

-- Force Rain of Fire usage when AoE toggle is ON (prefer spender over CB)
RainOfFire:Callback("aoe_toggle", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end
        return spell:Cast()
end)

RainOfFireT:Callback("aoe_toggle", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end
        if not target or not target.exists then return end
        return spell:Cast(target)
end)


-- actions.aoe+=/rain_of_fire,if=demonic_art
RainOfFire:Callback("aoe_demonic_art", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end

        -- Enhanced Resource Management with Set Bonus Logic
        local adjustedCost = spell.cost
        if gs.setBonusTww3_2pc then
            adjustedCost = adjustedCost * 0.9 -- 2pc reduces Rain of Fire cost by 10%
        end

        if adjustedCost > gs.soulShards then return end
        if not gs.demonicArt then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

RainOfFireT:Callback("aoe_demonic_art", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/rain_of_fire,if=demonic_art
RainOfFireT:Callback("aoe", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if not gs.shouldAoE then return end

        if spell.cost > gs.soulShards then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)

-- Wait condition from APL: wait,sec=((buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)),if=(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<gcd.max*0.25)&soul_shard>2
-- This is handled by the framework automatically

-- actions.aoe+=/incinerate,if=(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<=action.incinerate.cast_time&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)>gcd.max*0.25)
Incinerate:Callback("aoe_diabolic", function(spell)
        if not gs.shouldAoE then return end
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not gs.diabolicRitual then return end

        if gs.diabolicRitualRemains <= spell:CastTime() and gs.diabolicRitualRemains > A.GetGCD() * 250 then
            return spell:Cast(target)
        end
end)
-- actions.aoe+=/chaos_bolt,if=talent.diabolic_ritual&(((buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<(action.chaos_bolt.execute_time)&active_enemies<=9)|(demonic_art&active_enemies<=7))
ChaosBolt:Callback("aoe_diabolic", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.shouldAoE then return end
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not gs.havocUp and gs.soulShards < 3 then return end

        -- NEVER use Chaos Bolt with 4+ enemies - only Rain of Fire
        if gs.activeEnemies >= 4 then return end

        local ritualRemains = gs.diabolicRitualRemains
        if (gs.diabolicRitual and ritualRemains < ChaosBolt:CastTime() and gs.activeEnemies <= 9) or
        (gs.demonicArt and gs.activeEnemies <= 7) then
            return spell:Cast(target)
        end
end)


-- actions.aoe+=/call_action_list,name=havoc,if=havoc_active&havoc_remains>gcd.max&active_enemies<(5+!talent.wither)&(!cooldown.summon_infernal.up|!talent.summon_infernal)
-- This is handled by the existing havoc rotation function when conditions are met

-- actions.aoe+=/dimensional_rift,if=soul_shard<4.7&(charges>2|fight_remains<cooldown.dimensional_rift.duration)
DimensionalRift:Callback("aoe", function(spell)
        if not gs.shouldAoE then return end
        if gs.soulShards >= 4.7 then return end
        if spell.frac <= 2 and gs.fightRemains >= spell.cd then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/rain_of_fire,if=!talent.inferno&soul_shard>=(4.5-0.1*(active_dot.immolate+active_dot.wither))|soul_shard>=(3.5-0.1*(active_dot.immolate+active_dot.wither))|buff.ritual_of_ruin.up
RainOfFire:Callback("aoe2", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end
        if not gs.witherKnown and not (player:TalentKnown(DiabolicRitual.id) and gs.activeEnemies >= 8) then return end

        local dotReduction = 0.1 * (gs.immoCount + gs.witherCount)

        if gs.soulShards >= (4.5 - dotReduction) then
            return spell:Cast()
        end

        if gs.soulShards >= (3.5 - dotReduction) then
            return spell:Cast()
        end

        if gs.ritualOfRuin then
            return spell:Cast()
        end
end)

-- actions.aoe+=/rain_of_fire,if=!talent.inferno&soul_shard>=(4.5-0.1*(active_dot.immolate+active_dot.wither))|soul_shard>=(3.5-0.1*(active_dot.immolate+active_dot.wither))|buff.ritual_of_ruin.up
RainOfFireT:Callback("aoe2", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end
        if spell.cost > gs.soulShards then return end

        local dotReduction = 0.1 * (gs.immoCount + gs.witherCount)

        if not player:TalentKnown(Inferno.id) and gs.soulShards >= (4.5 - dotReduction) then
            return spell:Cast(target)
        end

        if gs.soulShards >= (3.5 - dotReduction) then
            return spell:Cast(target)
        end

        if gs.ritualOfRuin then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/wither,target_if=min:dot.wither.remains+99*debuff.havoc.remains+99*!dot.wither.ticking,if=dot.wither.refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.wither.remains)&(!talent.raging_demonfire|cooldown.channel_demonfire.remains>remains|time<5)&(active_dot.wither<=4|time>15)&target.time_to_die>18
Wither:Callback("aoe", function(spell)
        if not gs.witherKnown then return end
        if target:DebuffRemains(debuffs.wither, true) > 4000 then return end
        if target.ttd < 18000 then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < math.max(target:DebuffRemains(debuffs.wither, true), 500) and not gs.holdingCata then return end
        if player:TalentKnown(RagingDemonfire.id) and ChannelDemonfire.cd < target:DebuffRemains(debuffs.wither, true) then return end

        if gs.witherCount <= 4 or player.combatTime > 15 then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/channel_demonfire,if=dot.immolate.remains+dot.wither.remains>cast_time&talent.raging_demonfire
ChannelDemonfire:Callback("aoe_raging", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if not gs.shouldAoE then return end
        if not player:TalentKnown(RagingDemonfire.id) then return end

        local dotRemains = target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true)
        if dotRemains > spell:CastTime() then
            return spell:Cast()
        end
end)

--actions.aoe+=/shadowburn,if=((buff.malevolence.up&((talent.cataclysm&active_enemies<=10)|(talent.inferno&active_enemies<=6)))|(talent.wither&talent.cataclysm&active_enemies<=6)|(!talent.wither&talent.cataclysm&active_enemies<=4)|active_enemies<=3)&((cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)|fight_remains<=8)

--actions.aoe+=/shadowburn,target_if=min:time_to_die,if=((buff.malevolence.up&((talent.cataclysm&active_enemies<=10)|(talent.inferno&active_enemies<=6)))|(talent.wither&talent.cataclysm&active_enemies<=6)|(!talent.wither&talent.cataclysm&active_enemies<=4)|active_enemies<=3)&((cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)&time_to_die<5|fight_remains<=8)
Shadowburn:Callback("aoe", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end

        -- Use advanced target_if logic: min:time_to_die for optimal target selection with safety checks
        local bestTarget, minTtd = findTargetWithMinTtd()
        if not bestTarget then return end

        local malevolenceCondition = (player:Buff(buffs.malevolence) and ((player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 10) or (player:TalentKnown(Inferno.id) and gs.activeEnemies <= 6)))
        local talentCondition = (gs.witherKnown and player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 6) or (not gs.witherKnown and player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 4) or gs.activeEnemies <= 3
        local eradicationRemains = bestTarget:DebuffRemains(debuffs.eradication, true) or 0
        local cooldownCondition = (spell:TimeToFullCharges() <= A.GetGCD() * 3000 or eradicationRemains <= A.GetGCD() and player:TalentKnown(Eradication.id) and not gs.chaosBoltInFlight and not player:TalentKnown(DiabolicRitual.id))
        local finalCondition = (player:TalentKnown(ConflagrationOfChaos.id) or player:TalentKnown(BlisteringAtrophy.id))

        if (malevolenceCondition or talentCondition) and cooldownCondition and finalCondition then
            return spell:Cast(bestTarget)
        end
end)

-- actions.aoe+=/ruination
Ruination:Callback("aoe", function(spell)
        if not gs.ruination then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/rain_of_fire,if=pet.infernal.active&talent.rain_of_chaos
RainOfFire:Callback("aoe3", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end

        if not gs.infernalActive then return end
        if not player:TalentKnown(RainOfChaos.id) then return end

        return spell:Cast()
end)

-- actions.aoe+=/rain_of_fire,if=pet.infernal.active&talent.rain_of_chaos
RainOfFireT:Callback("aoe3", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if not gs.shouldAoE then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end

        if not gs.infernalActive then return end
        if not player:TalentKnown(RainOfChaos.id) then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/soul_fire,target_if=min:dot.wither.remains+dot.immolate.remains-5*debuff.conflagrate.up+100*debuff.havoc.remains,if=(buff.decimation.up)&!talent.raging_demonfire&havoc_active
-- actions.aoe+=/soul_fire,target_if=min:(dot.wither.remains+dot.immolate.remains-5*debuff.conflagrate.up+100*debuff.havoc.remains),if=buff.decimation.up&active_dot.immolate<=4
SoulFire:Callback("aoe", function(spell)
        if gs.activeEnemies >= 4 then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if not player:Buff(buffs.decimation) then return end

        -- Use advanced target_if logic for optimal Soul Fire target with safety checks
        local bestTarget, minScore = findTargetForSoulFire()
        if not bestTarget then return end

        if not player:TalentKnown(RagingDemonfire.id) and gs.havocUp then
            return spell:Cast(bestTarget)
        end

        if gs.immoCount <= 4 then
            return spell:Cast(bestTarget)
        end
end)

-- actions.aoe+=/infernal_bolt,if=soul_shard<2.5
InfernalBolt:Callback("aoe", function(spell)
        if gs.imCasting and gs.imCasting == spell.id then return end
        if not gs.infernalBolt then return end
        if gs.soulShards >= 2.5 then return end

        if gs.soulShards >= 2.5 then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/chaos_bolt,if=((soul_shard>3.5-(0.1*active_enemies))&!action.rain_of_fire.enabled)|(!talent.wither&talent.cataclysm&active_enemies<=3)
ChaosBolt:Callback("aoe", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.shouldAoE then return end
        if not gs.havocUp and gs.soulShards < 3 then return end

        -- NEVER use Chaos Bolt with 4+ enemies - only Rain of Fire
        if gs.activeEnemies >= 4 then return end

        if gs.soulShards > 3.0 - (0.1 * gs.activeEnemies) then
            return spell:Cast(target)
        end

        if not gs.witherKnown and player:TalentKnown(Cataclysm.id) and gs.activeEnemies <= 3 then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/cataclysm,if=raid_event.adds.in>15|talent.wither
Cataclysm:Callback("aoe", function(spell)
        if not gs.cursorCheck then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if A.Zone == "arena" then return end
        if not gs.witherKnown then return end

        return spell:Cast()
end)

-- actions.aoe+=/havoc,target_if=min:((-target.time_to_die)<?-15)+dot.immolate.remains+99*(self.target=target),if=(!cooldown.summon_infernal.up|!talent.summon_infernal|(talent.inferno&active_enemies>4))&target.time_to_die>8&(cooldown.malevolence.remains>15|!talent.malevolence)|time<5
Havoc:Callback("aoe", function(spell)
        if A.IsInPvP then return end
        if target.ttd < 8000 then return end

        if player.combatTime > 0 and player.combatTime < 5 then
            return spell:Cast(target)
        end

        if player:TalentKnown(Malevolence.id) and Malevolence.cd < 15000 then return end

        if SummonInfernal.cd > 500 or not player:TalentKnown(SummonInfernal.id) or (player:TalentKnown(Inferno.id) and gs.activeEnemies > 4) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/wither,target_if=min:dot.wither.remains+99*debuff.havoc.remains,if=dot.wither.refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.wither.remains)&(!talent.raging_demonfire|cooldown.channel_demonfire.remains>remains|time<5)&active_dot.wither<=active_enemies&target.time_to_die>18
Wither:Callback("aoe2", function(spell)
        if not gs.witherKnown then return end
        if target:DebuffRemains(debuffs.wither, true) > 4000 then return end
        if target.ttd < 18000 then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < math.max(target:DebuffRemains(debuffs.wither, true), 500) and not gs.holdingCata then return end
        if player:TalentKnown(RagingDemonfire.id) and ChannelDemonfire.cd < target:DebuffRemains(debuffs.wither, true) and player.combatTime > 5 then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/immolate,target_if=min:dot.immolate.remains+99*debuff.havoc.remains,if=dot.immolate.refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.immolate.remains)&(!talent.raging_demonfire|cooldown.channel_demonfire.remains>remains|time<5)&(active_dot.immolate<=6&!(talent.diabolic_ritual&talent.inferno)|active_dot.immolate<=4)&target.time_to_die>18
Immolate:Callback("aoe", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if target:DebuffRemains(debuffs.immolate, true) > 4000 then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < target:DebuffRemains(debuffs.immolate, true) and not gs.holdingCata then return end
        if player:TalentKnown(RagingDemonfire.id) and ChannelDemonfire.cd < target:DebuffRemains(debuffs.immolate, true) and player.combatTime > 5 then return end
        if target.ttd < 18000 then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 500 and not gs.holdingCata then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if gs.immoCount <= 6 - (num(player:TalentKnown(DiabolicRitual.id) and player:TalentKnown(Inferno.id)) * 2) then
            return spell:Cast(target)
        end
end)

-- actions.default+=/summon_infernal
-- actions.aoe+=/summon_infernal,if=cooldown.invoke_power_infusion_0.up|cooldown.invoke_power_infusion_0.duration=0|fight_remains>=120
SummonInfernal:Callback("default", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")



        if not shouldBurst() and cooldowns[1] then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

-- AoE-specific Summon Infernal: long-fight usage, no PI dependency
SummonInfernal:Callback("aoe", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[1] then return end
        if gs.fightRemains and gs.fightRemains < 120000 then return end
        return spell:Cast()
end)


-- actions.aoe+=/rain_of_fire,if=debuff.pyrogenics.down&active_enemies<=4&!talent.diabolic_ritual
RainOfFire:Callback("aoe4", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end


        if target:Debuff(debuffs.pyrogenics, true) then return end
        if player:TalentKnown(DiabolicRitual.id) then return end

        return spell:Cast()
end)

-- actions.aoe+=/rain_of_fire,if=debuff.pyrogenics.down&active_enemies<=4&!talent.diabolic_ritual
RainOfFireT:Callback("aoe4", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end

        if target:Debuff(debuffs.pyrogenics, true) then return end
        if player:TalentKnown(DiabolicRitual.id) then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/channel_demonfire,if=dot.immolate.remains+dot.wither.remains>cast_time
ChannelDemonfire:Callback("aoe2", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true) < 2500 then return end

        return spell:Cast()
end)

-- actions.aoe+=/immolate,target_if=min:dot.immolate.remains+99*debuff.havoc.remains,if=((dot.immolate.refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.immolate.remains))|active_enemies>active_dot.immolate)&target.time_to_die>10&!havoc_active&!(talent.diabolic_ritual&talent.inferno)
-- actions.aoe+=/immolate,target_if=min:dot.immolate.remains+99*debuff.havoc.remains,if=((dot.immolate.refreshable&variable.havoc_immo_time<5.4)|(dot.immolate.remains<2&dot.immolate.remains<havoc_remains)|!dot.immolate.ticking|(variable.havoc_immo_time<2)*havoc_active)&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>dot.immolate.remains)&target.time_to_die>11&!(talent.diabolic_ritual&talent.inferno)
Immolate:Callback("aoe2", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if target.ttd < 10000 then return end
        if player:TalentKnown(DiabolicRitual.id) and player:TalentKnown(Inferno.id) then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 500 and not gs.holdingCata then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if ((target:DebuffRemains(debuffs.immolate, true) < 4000 and (not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > math.max(target:DebuffRemains(debuffs.immolate, true), 500))) or gs.activeEnemies > gs.immoCount) and not gs.havocUp then
            return spell:Cast(target)
        end

        if ((target:DebuffRemains(debuffs.immolate, true) < 4000 and gs.havocImmoTime < 5400) or (target:DebuffRemains(debuffs.immolate, true) < 2000 and target:DebuffRemains(debuffs.immolate, true) < gs.havocRemains) or not target:Debuff(debuffs.immolate, true) or (gs.havocImmoTime < 2000 * num(gs.havocUp))) and (not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > math.max(target:DebuffRemains(debuffs.immolate, true), 500)) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/dimensional_rift
DimensionalRift:Callback("aoe2", function(spell)

        return spell:Cast()
end)

-- actions.aoe+=/soul_fire,target_if=min:(dot.wither.remains+dot.immolate.remains-5*debuff.conflagrate.up+100*debuff.havoc.remains),if=buff.decimation.up
SoulFire:Callback("aoe2", function(spell)
        if not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up
Incinerate:Callback("aoe2", function(spell)
        if not player:TalentKnown(FireAndBrimstone.id) then return end
        if not player:Buff(buffs.backdraft) then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

-- actions.aoe+=/conflagrate,if=buff.backdraft.stack<2|!talent.backdraft
Conflagrate:Callback("aoe", function(spell)
        if player:HasBuffCount(buffs.backdraft) >= 2 then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/incinerate
Incinerate:Callback("aoe3", function(spell)
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

-- Additional AoE callbacks based on APL

-- actions.aoe+=/soul_fire,target_if=min:(dot.wither.remains+dot.immolate.remains-5*debuff.conflagrate.up+100*debuff.havoc.remains),if=buff.decimation.up
SoulFire:Callback("aoe_final", function(spell)
        if not gs.shouldAoE then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.aoe+=/incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up
Incinerate:Callback("aoe_backdraft", function(spell)
        if not gs.shouldAoE then return end
        if not player:TalentKnown(FireAndBrimstone.id) then return end
        if not player:Buff(buffs.backdraft) then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

-- actions.aoe+=/conflagrate,if=buff.backdraft.stack<2|!talent.backdraft
Conflagrate:Callback("aoe_final", function(spell)
        if not gs.shouldAoE then return end

        if player:HasBuffCount(buffs.backdraft) < 2 or not player:TalentKnown(Backdraft.id) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/incinerate
Incinerate:Callback("aoe_filler", function(spell)
        if not gs.shouldAoE then return end
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

local function aoe()
    -- Call the new AoE rotation function
    aoeRotation()

    -- Havoc rotation when conditions are met
    if gs.havocUp and gs.havocRemains > A.GetGCD() * 1000 and gs.activeEnemies < (5 + num(not gs.witherKnown)) and (SummonInfernal.cd > 500 or not player:TalentKnown(SummonInfernal.id)) then
        havocRot()
    end
end

-- actions.cleave+=/malevolence,if=(!cooldown.summon_infernal.up|!talent.summon_infernal)
Malevolence:Callback("cleave", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[2] then return end

        if SummonInfernal.cd > 500 or not player:TalentKnown(SummonInfernal.id) then
            return spell:Cast()
        end
end)

-- actions.cleave+=/havoc,target_if=min:((-target.time_to_die)<?-15)+dot.immolate.remains+99*(self.target=target),if=(!cooldown.summon_infernal.up|!talent.summon_infernal)&target.time_to_die>8
Havoc:Callback("cleave", function(spell)
        if A.IsInPvP then return end
        if target.ttd < 8000 then return end

        if SummonInfernal.cd > 500 or not player:TalentKnown(SummonInfernal.id) then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/chaos_bolt,if=demonic_art
ChaosBolt:Callback("cleave", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/soul_fire,if=buff.decimation.react&(soul_shard<=4|buff.decimation.remains<=gcd.max*2)&debuff.conflagrate.remains>=execute_time&cooldown.havoc.remains
SoulFire:Callback("cleave", function(spell)
        if not player:Buff(buffs.decimation) then return end
        if target:DebuffRemains(debuffs.conflagrate, true) <= SoulFire:CastTime() then return end
        if Havoc.cd < 500 then return end

        if gs.soulShards <= 4 or player:BuffRemains(buffs.decimation) <= A.GetGCD() * 2000 then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/wither,target_if=min:dot.wither.remains+99*debuff.havoc.remains,if=talent.internal_combustion&(((dot.wither.remains-5*action.chaos_bolt.in_flight)<dot.wither.duration*0.4)|dot.wither.remains<3|(dot.wither.remains-action.chaos_bolt.execute_time)<5&action.chaos_bolt.usable)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains-5))&target.time_to_die>8&!action.soul_fire.in_flight_to_target

-- actions.cleave+=/wither,target_if=min:dot.wither.remains+99*debuff.havoc.remains,if=!talent.internal_combustion&(((dot.wither.remains-5*(action.chaos_bolt.in_flight))<dot.wither.duration*0.3)|dot.wither.remains<3)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Wither:Callback("cleave", function(spell)
        if not gs.witherKnown then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if player:TalentKnown(InternalCombustion.id) then
            if (((target:DebuffRemains(debuffs.wither, true) - 5000 * num(gs.chaosBoltInFlight)) < 7200) or target:DebuffRemains(debuffs.wither, true) < 3000 or (target:DebuffRemains(debuffs.wither, true) - ChaosBolt:CastTime()) < 5000 and gs.soulShards >= ChaosBolt.cost) and (not player:TalentKnown(SoulFire.id) or SoulFire.cd + SoulFire:CastTime() > (target:DebuffRemains(debuffs.wither, true) - 5000)) then
                return spell:Cast(target)
            end
        else
            if (((target:DebuffRemains(debuffs.wither, true) - 5000 * num(gs.chaosBoltInFlight)) < 5400) or target:DebuffRemains(debuffs.wither, true) < 3000) and (not player:TalentKnown(SoulFire.id) or SoulFire.cd + SoulFire:CastTime() > target:DebuffRemains(debuffs.wither, true)) then
                return spell:Cast(target)
            end
        end
end)

-- actions.cleave+=/conflagrate,if=(talent.roaring_blaze.enabled&full_recharge_time<=gcd.max*2)|recharge_time<=8&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<gcd.max)&!variable.pool_soul_shards
Conflagrate:Callback("cleave", function(spell)
        if player:TalentKnown(RoaringBlaze.id) and spell:TimeToFullCharges() <= A.GetGCD() * 2000 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= 8000 and gs.diabolicRitual and gs.diabolicRitualRemains < A.GetGCD() * 1000 and not gs.poolSoulShards then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/shadowburn,if=(cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)|fight_remains<=8
Shadowburn:Callback("cleave", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end
        --if A.IsInPvP then return end

        if target.ttd <= 8000 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= A.GetGCD() * 3000 then
            return spell:Cast(target)
        end

        if player:TalentKnown(ConflagrationOfChaos.id) or player:TalentKnown(BlisteringAtrophy.id) then
            if target:DebuffRemains(debuffs.eradication, true) <= A.GetGCD() * 1000 and player:TalentKnown(Eradication.id) and not gs.chaosBoltInFlight and not player:TalentKnown(DiabolicRitual.id) then
                return spell:Cast(target)
            end
        end
end)

-- actions.cleave+=/chaos_bolt,if=buff.ritual_of_ruin.up
ChaosBolt:Callback("cleave2", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.ritualOfRuin then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/rain_of_fire,if=cooldown.summon_infernal.remains>=90&talent.rain_of_chaos
RainOfFire:Callback("cleave", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end

        if not player:TalentKnown(RainOfChaos.id) then return end
        if SummonInfernal.cd < 90000 then return end

        return spell:Cast()
end)

-- actions.cleave+=/rain_of_fire,if=cooldown.summon_infernal.remains>=90&talent.rain_of_chaos
RainOfFireT:Callback("cleave", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end

        if not player:TalentKnown(RainOfChaos.id) then return end
        if SummonInfernal.cd < 90000 then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/shadowburn,if=cooldown.summon_infernal.remains>=90&talent.rain_of_chaos
Shadowburn:Callback("cleave2", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end
        --if A.IsInPvP then return end

        if not player:TalentKnown(RainOfChaos.id) then return end
        if SummonInfernal.cd < 90000 then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/chaos_bolt,if=cooldown.summon_infernal.remains>=90&talent.rain_of_chaos
ChaosBolt:Callback("cleave3", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not player:TalentKnown(RainOfChaos.id) then return end
        if SummonInfernal.cd < 90000 then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/ruination,if=(debuff.eradication.remains>=execute_time|!talent.eradication|!talent.shadowburn)
Ruination:Callback("cleave", function(spell)
        if not gs.ruination then return end

        if target:DebuffRemains(debuffs.eradication, true) >= spell:CastTime() then
            return spell:Cast(target)
        end

        if not player:TalentKnown(Eradication.id) then
            return spell:Cast(target)
        end

        if not player:TalentKnown(Shadowburn.id) then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/cataclysm,if=raid_event.adds.in>15
Cataclysm:Callback("cleave", function()
        -- Ignore raid adds timing: engine casts only with adds. We skip this in cleave.
end)

-- actions.cleave+=/channel_demonfire,if=talent.raging_demonfire&(dot.immolate.remains+dot.wither.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))>cast_time
ChannelDemonfire:Callback("cleave", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if not player:TalentKnown(RagingDemonfire.id) then return end

        if target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true) - 5000 * (num(gs.chaosBoltInFlight and player:TalentKnown(InternalCombustion.id))) > spell:CastTime() then
            return spell:Cast()
        end
end)

-- actions.cleave+=/soul_fire,if=soul_shard<=3.5&(debuff.conflagrate.remains>cast_time+travel_time|!talent.roaring_blaze&buff.backdraft.up)&!variable.pool_soul_shards
SoulFire:Callback("cleave2", function(spell)
        if gs.soulShards > 3.5 then return end
        if gs.poolSoulShards then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        if target:DebuffRemains(debuffs.conflagrate, true) > spell:CastTime() + (A.GetGCD() * 1000) then
            return spell:Cast(target)
        end

        if not player:TalentKnown(RoaringBlaze.id) and player:Buff(buffs.backdraft) then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/immolate,target_if=min:dot.immolate.remains+99*debuff.havoc.remains,if=(dot.immolate.refreshable&(dot.immolate.remains<cooldown.havoc.remains|!dot.immolate.ticking))&(!talent.cataclysm|cooldown.cataclysm.remains>remains)&(!talent.soul_fire|cooldown.soul_fire.remains+(!talent.mayhem*action.soul_fire.cast_time)>dot.immolate.remains)&target.time_to_die>15
Immolate:Callback("cleave", function(spell)
        if gs.immoDelay then return end
        local immoRemains = target:DebuffRemains(debuffs.immolate, true)
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 500 and not gs.holdingCata then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if gs.witherKnown then return end
        if immoRemains > 4000 then return end
        if target.ttd < 15000 then return end
        if immoRemains > Havoc.cd then return end
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < immoRemains and not gs.holdingCata then return end
        if player:TalentKnown(SoulFire.id) and SoulFire.cd + (num(not player:TalentKnown(Mayhem.id)) * SoulFire:CastTime()) < immoRemains then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/summon_infernal
SummonInfernal:Callback("cleave", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[1] then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

-- actions.cleave+=/incinerate,if=talent.diabolic_ritual&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains-2-!variable.disable_cb_2t*action.chaos_bolt.cast_time-variable.disable_cb_2t*gcd.max)<=0)
Incinerate:Callback("cleave", function(spell)
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not gs.diabolicRitual then return end

        if gs.diabolicRitualRemains - 2000 - num(not A.GetToggle(2, "disableCb2t")) * ChaosBolt:CastTime() - (num(A.GetToggle(2, "disableCb2t")) * A.GetGCD() * 1000) <= 0 then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/rain_of_fire,if=variable.pooling_condition&!talent.wither&buff.rain_of_chaos.up
-- actions.cleave+=/rain_of_fire,if=variable.allow_rof_2t_spender>=1&!talent.wither&talent.pyrogenics&debuff.pyrogenics.remains<=gcd.max&(!talent.rain_of_chaos|cooldown.summon_infernal.remains>=gcd.max*3)&variable.pooling_condition
-- actions.cleave+=/rain_of_fire,if=variable.do_rof_2t&variable.pooling_condition&(cooldown.summon_infernal.remains>=gcd.max*3|!talent.rain_of_chaos)
RainOfFire:Callback("cleave2", function(spell)
        if player:TalentKnown(RainOfFireT.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end
        if not gs.cursorCheck then return end
        if not gs.pooling then return end

        if not gs.witherKnown and player:Buff(buffs.rainOfChaos) then
            return spell:Cast()
        end

        if not A.GetToggle(2, "allowRoF2t") then return end

        if not player:TalentKnown(RainOfChaos.id) or SummonInfernal.cd >= A.GetGCD() * 3000 then
            return spell:Cast()
        end
end)

RainOfFireT:Callback("cleave2", function(spell)
        if player:TalentKnown(RainOfFire.id) then return end
        if gs.activeEnemies < 4 then return end

        if spell.cost > gs.soulShards then return end
        if not gs.pooling then return end

        if not gs.witherKnown and player:Buff(buffs.rainOfChaos) then
            return spell:Cast()
        end

        if not A.GetToggle(2, "allowRoF2t") then return end

        if not player:TalentKnown(RainOfChaos.id) or SummonInfernal.cd >= A.GetGCD() * 3000 then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/soul_fire,if=soul_shard<=4&talent.mayhem
SoulFire:Callback("cleave3", function(spell)
        if gs.soulShards > 4 then return end
        if not player:TalentKnown(Mayhem.id) then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/chaos_bolt,if=!variable.disable_cb_2t&variable.pooling_condition_cb&(cooldown.summon_infernal.remains>=gcd.max*3|soul_shard>4|!talent.rain_of_chaos)
ChaosBolt:Callback("cleave4", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if A.GetToggle(2, "disableCb2t") then return end
        if not gs.poolingCb then return end

        if SummonInfernal.cd >= A.GetGCD() * 3000 then
            return spell:Cast(target)
        end

        if gs.soulShards > 4 then
            return spell:Cast(target)
        end

        if not player:TalentKnown(RainOfChaos.id) then
            return spell:Cast(target)
        end
end)

-- actions.cleave+=/channel_demonfire
ChannelDemonfire:Callback("cleave2", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag

        return spell:Cast()
end)

-- actions.cleave+=/dimensional_rift
DimensionalRift:Callback("cleave", function(spell)

        return spell:Cast(target)
end)

-- actions.cleave+=/infernal_bolt
InfernalBolt:Callback("cleave", function(spell)
        if not gs.infernalBolt then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/conflagrate,if=charges>(max_charges-1)|fight_remains<gcd.max*charges
Conflagrate:Callback("cleave2", function(spell)
        if spell.frac < 1.9 then return end

        return spell:Cast(target)
end)

-- actions.cleave+=/incinerate
Incinerate:Callback("cleave2", function(spell)
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)


local function cleave()
    -- Call the new cleave rotation function
    cleaveRotation()

    -- Havoc rotation when conditions are met
    if gs.havocRemains > A.GetGCD() * 1000 then
        havocRot()
    end
end


-- actions+=/malevolence,if=cooldown.summon_infernal.remains>=55
Malevolence:Callback("st", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[2] then return end
        if SummonInfernal.cd < 55000 then return end

        return spell:Cast()
end)

-- actions+=/chaos_bolt,if=demonic_art
ChaosBolt:Callback("st", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.demonicArt then return end

        return spell:Cast(target)
end)

-- actions+=/soul_fire,if=buff.decimation.react&(soul_shard<=4|buff.decimation.remains<=gcd.max*2)&debuff.conflagrate.remains>=execute_time
SoulFire:Callback("st", function(spell)
        if not player:Buff(buffs.decimation) then return end
        if target:DebuffRemains(debuffs.conflagrate, true) < spell:CastTime() * A.GetGCD() then return end

        if gs.soulShards <= 4 or player:BuffRemains(buffs.decimation) <= A.GetGCD() * 2000 then
            return spell:Cast(target)
        end
end)

-- actions+=/wither,if=talent.internal_combustion&(((dot.wither.remains-5*action.chaos_bolt.in_flight)<dot.wither.duration*0.4)|dot.wither.remains<3|(dot.wither.remains-action.chaos_bolt.execute_time)<5&action.chaos_bolt.usable)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains-5))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Wither:Callback("st", function(spell)
        if not gs.witherKnown then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if not player:TalentKnown(InternalCombustion.id) then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end

        if (((target:DebuffRemains(debuffs.wither, true) - 5000 * num(gs.chaosBoltInFlight)) < 7200) or target:DebuffRemains(debuffs.wither, true) < 3000 or (target:DebuffRemains(debuffs.wither, true) - ChaosBolt:CastTime()) < 5000 and gs.soulShards >= ChaosBolt.cost) and (not player:TalentKnown(SoulFire.id) or SoulFire.cd + SoulFire:CastTime() > (target:DebuffRemains(debuffs.wither, true) - 5000)) then
            return spell:Cast(target)
        end
end)

-- actions+=/conflagrate,if=talent.roaring_blaze&debuff.conflagrate.remains<1.5|full_recharge_time<=gcd.max*2|recharge_time<=8&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains)<gcd.max)&soul_shard>=1.5
Conflagrate:Callback("st", function(spell)
        if player:TalentKnown(RoaringBlaze.id) and target:DebuffRemains(debuffs.conflagrate, true) < 1500 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= A.GetGCD() * 2000 then
            return spell:Cast(target)
        end

        if spell:TimeToFullCharges() <= 8000 and gs.diabolicRitual and gs.diabolicRitualRemains < A.GetGCD() * 1000 and gs.soulShards >= 1.5 then
            return spell:Cast(target)
        end
end)

-- actions+=/shadowburn,if=(cooldown.shadowburn.full_recharge_time<=gcd.max*3|debuff.eradication.remains<=gcd.max&talent.eradication&!action.chaos_bolt.in_flight&!talent.diabolic_ritual)&(talent.conflagration_of_chaos|talent.blistering_atrophy)&!demonic_art|fight_remains<=8
Shadowburn:Callback("st", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end
        --if A.IsInPvP then return end

        if target.ttd <= 8000 then
            return spell:Cast(target)
        end

        if (spell:TimeToFullCharges() <= A.GetGCD() * 3000 or target:DebuffRemains(debuffs.eradication, true) <= A.GetGCD() * 1000 and player:TalentKnown(Eradication.id) and not gs.chaosBoltInFlight and not player:TalentKnown(DiabolicRitual.id)) and (player:TalentKnown(ConflagrationOfChaos.id) or player:TalentKnown(BlisteringAtrophy.id)) and not gs.demonicArt then
            return spell:Cast(target)
        end
end)

-- actions+=/chaos_bolt,if=buff.ritual_of_ruin.up
ChaosBolt:Callback("st2", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.ritualOfRuin then return end

        return spell:Cast(target)
end)

-- actions+=/shadowburn,if=(cooldown.summon_infernal.remains>=90&talent.rain_of_chaos)|buff.malevolence.up
Shadowburn:Callback("st2", function(spell)
        if spell.cost > gs.soulShards then return end
        if A.IsInPvP then
            if player.moving then
                return spell:Cast(target)
            end
        end
        --if A.IsInPvP then return end

        if SummonInfernal.cd >= 90000 and player:TalentKnown(RainOfChaos.id) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.malevolence) then
            return spell:Cast(target)
        end
end)

-- actions+=/chaos_bolt,if=(cooldown.summon_infernal.remains>=90&talent.rain_of_chaos)|buff.malevolence.up
ChaosBolt:Callback("st3", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if SummonInfernal.cd >= 90000 and player:TalentKnown(RainOfChaos.id) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.malevolence) then
            return spell:Cast(target)
        end
end)

-- actions+=/ruination,if=(debuff.eradication.remains>=execute_time|!talent.eradication|!talent.shadowburn)
Ruination:Callback("st", function(spell)
        if not gs.ruination then return end

        if target:DebuffRemains(debuffs.eradication, true) >= spell:CastTime() + A.GetGCD() * 1000 then
            return spell:Cast(target)
        end

        if not player:TalentKnown(Eradication.id) then
            return spell:Cast(target)
        end

        if not player:TalentKnown(Shadowburn.id) then
            return spell:Cast(target)
        end
end)

-- actions+=/cataclysm,if=raid_event.adds.in>15&(dot.immolate.refreshable&!talent.wither|talent.wither&dot.wither.refreshable)
Cataclysm:Callback("st", function(spell)
        if not gs.cursorCheck then return end
        if gs.imCasting and gs.imCasting == spell.id then return end
        if A.Zone == "arena" then return end
        -- Do not use Cataclysm in pure single-target
        if gs.activeEnemies <= 1 then return end

        if target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true) < 4000 then
            return spell:Cast()
        end
end)

-- actions+=/channel_demonfire,if=talent.raging_demonfire&(dot.immolate.remains+dot.wither.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))>cast_time
ChannelDemonfire:Callback("st", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag
        if not player:TalentKnown(RagingDemonfire.id) then return end

        if target:DebuffRemains(debuffs.immolate, true) + target:DebuffRemains(debuffs.wither, true) - 5000 * (num(gs.chaosBoltInFlight and player:TalentKnown(InternalCombustion.id))) > 2500 then
            return spell:Cast()
        end
end)

-- actions+=/wither,if=!talent.internal_combustion&(((dot.wither.remains-5*(action.chaos_bolt.in_flight))<dot.wither.duration*0.3)|dot.wither.remains<3)&(!talent.cataclysm|cooldown.cataclysm.remains>dot.wither.remains)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.wither.remains))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Wither:Callback("st2", function(spell)
        if not gs.witherKnown then return end
        if player:TalentKnown(InternalCombustion.id) then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        if (((target:DebuffRemains(debuffs.wither, true) - 5000 * num(gs.chaosBoltInFlight)) < 5400) or target:DebuffRemains(debuffs.wither, true) < 3000) and (not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > math.max(target:DebuffRemains(debuffs.wither, true), 500) or gs.holdingCata) and (not player:TalentKnown(SoulFire.id) or SoulFire.cd + SoulFire:CastTime() > target:DebuffRemains(debuffs.wither, true)) then
            return spell:Cast(target)
        end
end)

-- actions+=/immolate,if=(((dot.immolate.remains-5*(action.chaos_bolt.in_flight&talent.internal_combustion))<dot.immolate.duration*0.3)|dot.immolate.remains<3|(dot.immolate.remains-action.chaos_bolt.execute_time)<5&talent.internal_combustion&action.chaos_bolt.usable)&(!talent.cataclysm|cooldown.cataclysm.remains>dot.immolate.remains)&(!talent.soul_fire|cooldown.soul_fire.remains+action.soul_fire.cast_time>(dot.immolate.remains-5*talent.internal_combustion))&target.time_to_die>8&!action.soul_fire.in_flight_to_target
Immolate:Callback("st", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if target.ttd < 8000 then return end
        if gs.soulFireInFlight then return end
        if gs.activeEnemies >= 2 and player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 500 and not gs.holdingCata then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end


        if (((target:DebuffRemains(debuffs.immolate, true) - 5000 * num(gs.chaosBoltInFlight and player:TalentKnown(InternalCombustion.id))) < 5400)
            or target:DebuffRemains(debuffs.immolate, true) < 4000
            or (target:DebuffRemains(debuffs.immolate, true) - ChaosBolt:CastTime() < 5000 and player:TalentKnown(InternalCombustion.id) and gs.soulShards >= ChaosBolt:Cost()))
            and (gs.activeEnemies <= 1 or not player:TalentKnown(Cataclysm.id) or Cataclysm.cd > math.max(target:DebuffRemains(debuffs.immolate, true), 500))
            and (not player:TalentKnown(SoulFire.id) or SoulFire.cd + SoulFire:CastTime() > target:DebuffRemains(debuffs.immolate, true) - 5000 * player:TalentKnownInt(InternalCombustion.id)) then
            return spell:Cast(target)
        end
end)

-- actions+=/summon_infernal
SummonInfernal:Callback("st", function(spell)
        local cooldowns = A.GetToggle(2, "cooldownSelect")
        if not shouldBurst() and cooldowns[1] then return end
        if not gs.cursorCheck then return end

        return spell:Cast()
end)

-- actions+=/incinerate,if=talent.diabolic_ritual&(diabolic_ritual&(buff.diabolic_ritual_mother_of_chaos.remains+buff.diabolic_ritual_overlord.remains+buff.diabolic_ritual_pit_lord.remains-2-!variable.disable_cb_2t*action.chaos_bolt.cast_time-variable.disable_cb_2t*gcd.max)<=0)
Incinerate:Callback("st", function(spell)
        if not player:TalentKnown(DiabolicRitual.id) then return end
        if not gs.diabolicRitual then return end

        if gs.diabolicRitualRemains <= ChaosBolt:CastTime() then
            return spell:Cast(target)
        end
end)

-- actions+=/chaos_bolt,if=variable.pooling_condition_cb&(cooldown.summon_infernal.remains>=gcd.max*3|soul_shard>4|!talent.rain_of_chaos)
ChaosBolt:Callback("st4", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if not gs.poolingCb then return end

        if SummonInfernal.cd >= A.GetGCD() * 3000 then
            return spell:Cast(target)
        end

        if gs.soulShards > 4 then
            return spell:Cast(target)
        end

        if not player:TalentKnown(RainOfChaos.id) then
            return spell:Cast(target)
        end

        if A.IsInPvP then
            if player:BuffRemains(buffs.backdraft) > spell:CastTime() then
                return spell:Cast(target)
            end
        end
end)

-- actions+=/channel_demonfire
ChannelDemonfire:Callback("st2", function(spell)
        -- Movement check is now handled by the framework via ignoreMoving flag

        return spell:Cast()
end)

-- actions+=/dimensional_rift
DimensionalRift:Callback("st", function(spell)

        return spell:Cast(target)
end)

-- actions+=/infernal_bolt
InfernalBolt:Callback("st", function(spell)
        if not gs.infernalBolt then return end

        return spell:Cast(target)
end)

-- actions+=/conflagrate,if=charges>(max_charges-1)|fight_remains<gcd.max*charges
Conflagrate:Callback("st2", function(spell)
        if spell:TimeToFullCharges() > A.GetGCD() * 1000 then return end

        return spell:Cast(target)
end)

-- actions+=/soul_fire,if=buff.backdraft.up
SoulFire:Callback("st2", function(spell)
        if not player:Buff(buffs.backdraft) then return end
        if A.IsInPvP and not player:Buff(buffs.decimation) then return end

        return spell:Cast(target)
end)

-- actions+=/incinerate
Incinerate:Callback("st2", function(spell)
        if gs.soulShards >= 4.5 then return end
        return spell:Cast(target)
end)

local function st()
    -- Call the new single target rotation function
    singleTargetRotation()
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

Immolate:Callback("pvp", function(spell)
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if target:DebuffRemains(debuffs.immolate, true) > 4000 then return end
        if target:DebuffRemains(debuffs.wither, true) > 4000 then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        return spell:Cast(target)
end)

Wither:Callback("pvp", function(spell)
    if not target or not target.exists or target:IsDeadOrGhost() then return end
    if target.totalImmune or target.magicImmune then return end
    if spell:HasRange() and not spell:InRange(target) then return end
    if target.Los and not target:Los() then return end
    if not gs.witherKnown then return end
    if not spell:ReadyToUse() then return end
    if target:DebuffRemains(debuffs.wither, true) > 4000 then return end

        return spell:Cast(target)
end)

NetherWard:Callback("pvp", function(spell)
        if not shouldReflect() then return end

        return spell:Cast()
end)

-- High priority Chaos Bolt for fast casts (proc priority)
ChaosBolt:Callback("pvp_priority", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end

        -- Force Chaos Bolt when we have fast cast procs
        if player:Buff(buffs.backdraft) and player:BuffRemains(buffs.backdraft) > spell:CastTime() then
            return spell:Cast(target)
        end

        -- Force Chaos Bolt when we have Ritual of Ruin (instant cast)
        if gs.ritualOfRuin then
            return spell:Cast(target)
        end

        -- Force Chaos Bolt during demonic art windows
        if gs.demonicArt then
            return spell:Cast(target)
        end
end)

ChaosBolt:Callback("pvp", function(spell)
        if spell.cost and spell.cost > gs.soulShards then return end
        if player:BuffRemains(buffs.backdraft) > spell:CastTime() then
            return spell:Cast(target)
        end
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
        if inTwenty() < 2 then return end

        return spell:Cast()
end)

-- Soul Rip should be used after Infernal and Malevolence for optimal burst
SoulRip:Callback("pvp", function(spell)
        if inTwenty() < 2 then return end

        -- Only use Soul Rip after we've used our major burst cooldowns
        -- This ensures we're blasting Chaos Bolts when Soul Rip debuff is active
        if gs.infernalActive or player:Buff(buffs.malevolence) then
            return spell:Cast(target)
        end

        -- Use Soul Rip if Infernal is on cooldown (already used) and we have good shard count
        if SummonInfernal.cd > 10000 and gs.soulShards >= 3 then
            return spell:Cast(target)
        end
end)

BondsOfFel:Callback("pvp", function(spell)
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
    if enemy:HasDeBuff(debuffs.curseOfTongues) then return end
    if enemy:HasDeBuff(debuffs.curseOfWeakness) then return end

    return player.moving and not enemy.isMelee and not enemy.slowed and not player:Buff(buffs.amplifyCurse)
end

local function shouldTongues(enemy)
    -- Enemy slowed already WITHOUT Exhaustion
    -- Enemy is caster
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfTheSatyr) then return end
    if enemy:HasDeBuff(debuffs.curseOfTongues) then return end

    return not player:Buff(buffs.amplifyCurse) and not enemy.isMelee and not enemy.isHealer and enemy.cds
end

local function shouldWeakness(enemy)
    -- Enemy is melee and not healer
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfWeakness) or enemy:HasDeBuff(debuffs.curseOfTheSatyr) then return end

    return player:Buff(buffs.amplifyCurse) and enemy.isMelee and not enemy.isHealer and enemy.cds
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

AmplifyCurse:Callback("pvp", function(spell)
        local enemyCd = MakMulti.arena:Any(function(unit) return not unit.isHealer and unit.cds end)

        if enemyCd then
            return spell:Cast()
        end
end)

CreateSoulwell:Callback("precombat", function(spell)
    if not spell:ReadyToUse() then return end
        -- Arena or Blitz prep only
    if not (player:Buff(buffs.arenaPrep) or player:Buff(buffs.blitzPrep)) then return end
    return spell:Cast()
end)

SummonInfernal:Callback("infernal_sequence", function(spell)
    if not spell:ReadyToUse() then return end
    if gs.soulShards < 4 then return end
    if not player:Buff(buffs.backdraft) then return end
    local rbRemain = target:DebuffRemains(debuffs.conflagrate, true) or 0   
    local bdRemain = player:BuffRemains(buffs.backdraft) or 0               
    if rbRemain <= 1200 or bdRemain <= 1200 then return end                 

    return spell:Cast()
end)

Malevolence:Callback("pvp", function(spell)
        if SummonInfernal.cd < 55000 then return end
        return spell:Cast(target)
end)

local function pvpenis()
    -- PvP Improvements:
    -- 1. Imp Dispel for friendly players (Freezing Trap, Polymorph, etc.)
    -- 2. Force Chaos Bolt priority when fast cast procs are available
    -- 3. Soul Rip used after Infernal/Malevolence for optimal burst timing
    -- 4. Fear logic improved with 3+ soul shard kill window setup
    SummonInfernal("infernal_sequence")
    Malevolence("pvp")

    -- High priority dispel for friendly players
    SingeMagic("pvp")
    Wither("pvp")
    -- High priority Chaos Bolt for fast casts/procs
    ChaosBolt("pvp_priority")

    Immolate("pvp")
    ChaosBolt("pvp")
    NetherWard("pvp")
    CallObserver("pvp")
    SoulRip("pvp")
    AmplifyCurse("pvp")
end
A[3] = function(icon)
    FrameworkStart(icon)
    updategs()

    -- Handle Havoc target swap - just tab off if current target has Havoc
    if autoTarget() then
        return TabTarget()
    end

    CreateSoulwell("precombat")

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Soul Shards: ", gs.soulShards)
        MakPrint(2, "Chaos Bolt In Flight: ", gs.chaosBoltInFlight)
        MakPrint(3, "Soul Fire In Flight: ", gs.soulFireInFlight)
        MakPrint(4, "Active Enemies: ", gs.activeEnemies)
        MakPrint(5, "Should AoE: ", gs.shouldAoE)
        MakPrint(6, "Wither Known: ", gs.witherKnown)
        MakPrint(7, "Set Bonus 2pc: ", gs.setBonusTww3_2pc)
        MakPrint(8, "Set Bonus 4pc: ", gs.setBonusTww3_4pc)
        MakPrint(9, "Optimal Shard Threshold: ", gs.optimalShardThreshold)
        MakPrint(10, "Resource Efficiency: ", gs.resourceEfficiency)
        MakPrint(11, "Havoc Target Optimal: ", gs.havocTargetOptimal and gs.havocTargetOptimal.name or "None")
        MakPrint(12, "Burst Window Active: ", gs.burstWindowActive)
    end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then -- Vile Taint ready
        if player:TalentKnown(Cataclysm.id) and Cataclysm.cd < 700 and player.inCombat then
            Aware:displayMessage("CATACLYSM READY", "Red", 1)
        end
    end

    BurningRush()

    if player.channeling then return end

    makInterrupt(interrupts)

    if player.casting and gs.imCastingRemaining > 500 then return end

    
    if player.inCombat and player.hp < 40 and A.DemonicHealthstone:IsReady(player) then

        if A.Soulburn:IsTalentLearned() and gs.soulShards > 0 then

            return Soulburn:Cast(player)
        end
        if not player:Buff(buffs.soulBurn) > 0 then return end
             
        HealthStone(player) 
    end


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

    if target.exists and target.canAttack and ChaosBolt:InRange(target) then

        MortalCoil()
        DrainLife()

        if A.IsInPvP then
            if A.Zone ~= "arena" then
                SpellLock("bg")
                SpellLockSac("bg")
                CurseOfExhaustion("bg")
                CurseOfTheSatyr("bg")
                CurseOfTongues("bg")
                CurseOfWeakness("bg")
            end
            pvpenis()
        end

        if not player.inCombat then
            SoulFire("pre")
            Cataclysm("pre")
            Incinerate("pre")
        end

        if shouldBurst() then

            ogcd()

            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = gs.infernalActiveBurst or not player:TalentKnown(SummonInfernal.id) or gs.fightRemains < SummonInfernal.cd and IsInRaid() and target.isBoss
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end

        end

        if gs.shouldAoE then
            aoe()
        end

        if gs.shouldCleave then
            cleave()
        end

        st()
    end


    return FrameworkEnd()
end

CurseOfExhaustion:Callback("arena", function(spell, enemy)
        if not isValidTarget(enemy) then return end
        if not shouldExhaustion(enemy) then return end

        return spell:Cast(enemy)
end)

CurseOfTongues:Callback("arena", function(spell, enemy)
        if not isValidTarget(enemy) then return end
        if not shouldTongues(enemy) then return end
        return spell:Cast(enemy)
end)

CurseOfWeakness:Callback("arena", function(spell, enemy)
        if IsPlayerSpell(CurseOfTheSatyr.id) then return end
        if not isValidTarget(enemy) then return end
        if not shouldWeakness(enemy) then return end

        return spell:Cast(enemy)
end)

CurseOfTheSatyr:Callback("arena", function(spell, enemy)
        if shouldWeakness(enemy) or shouldTongues(enemy) then
        if not isValidTarget(enemy) then return end
            return spell:Cast(enemy)
        end
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
        if not isValidTarget(enemy) then return end
        if spell:IsImmune(enemy) or enemy:IsTotalImmune() or enemy:IsMagicImmune() then return end
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

        -- Improved Fear logic: if we have 3+ soul shards, fear for kill window setup
        if gs.soulShards >= 3 and not enemy.isHealer then
            Aware:displayMessage("Fear -> Chaos Bolt Setup", "Yellow", 1)
            return spell:Cast(enemy)
        end

        if enemy:Debuff(debuffs.fear) then
            Aware:displayMessage("Chain Fearing", "Purple", 1)
            return spell:Cast(enemy)
        end

        if enemy.isHealer then
            Aware:displayMessage("Fearing Healer", "Green", 1)
            return spell:Cast(enemy)
        end

        local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party2.hp > 0 and party2.hp < 50)
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
        if not isValidTarget(enemy) then return end

        return spell:Cast(enemy)
end)

SpellLockSac:Callback("arena", function(spell, enemy)
        if not enemy.pvpKick then return end
        if not isValidTarget(enemy) then return end

        return spell:Cast(enemy)
end)

Havoc:Callback("arena", function(spell, enemy, icon)
        if not isValidTarget(enemy) then return end
        if enemy.isTarget then return end
        
        return spell:Cast(enemy)
        
end)

MortalCoil:Callback("arena", function(spell, enemy)
        if not isValidTarget(enemy) then return end
        if enemy.incapacitateDr <= 0.5 then return end
        if enemy:Debuff(debuffs.havoc, true) then return end

        local havocUp = MakMulti.arena:Any(function(unit) return unit:Debuff(debuffs.havoc, true) end)

        if enemy.pvpKick or (enemy:Debuff(debuffs.fear) and enemy:DebuffRemains(debuffs.fear) < 1000) then
            return spell:Cast(enemy)
        end

        if target.hp < 50 and enemy.isHealer then
            return spell:Cast(enemy)
        end

        if havocUp and not enemy:Debuff(debuffs.havoc, true) then
            return spell:Cast(enemy)
        end
end)

Immolate:Callback("arena", function(spell, enemy, icon)
        if not isValidTarget(enemy) then return end
        icon = icon or UniversalTwo
        if gs.immoDelay then return end
        if gs.witherKnown then return end
        if enemy:DebuffRemains(debuffs.immolate, true) > 4000 then return end
        if enemy:DebuffRemains(debuffs.wither, true) > 4000 then return end
        if gs.imCasting and gs.imCasting == Cataclysm.id then return end

        return spell:Cast(enemy, false, icon)
end)

Wither:Callback("arena", function(spell, enemy)
    if spell:IsImmune(enemy) or enemy:IsTotalImmune() or enemy:IsMagicImmune() then return end
    if not isValidTarget(enemy) then return end
    if not gs.witherKnown then return end
    if not spell:ReadyToUse() then return end
    if enemy:DebuffRemains(debuffs.wither, true) > 4000 then return end

    return spell:Cast(enemy)   -- Makulu cast signature
end)

local enemyRotation = function(enemy)
    Wither("arena", enemy)
    SpellLock("arena", enemy)
    SpellLockSac("arena", enemy)
    MortalCoil("arena", enemy)
    Havoc("arena", enemy)
    Immolate("arena", enemy)
    CurseOfExhaustion("arena", enemy)
    CurseOfTheSatyr("arena", enemy)
    --CurseOfTongues("arena", enemy)
    CurseOfWeakness("arena", enemy)
    Fear("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end

end

A[6] = function(icon)
    RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    enemyRotation(arena1)
    partyRotation(party1)

    return FrameworkEnd()
end

-- Main Rotation function for TellMeWhen compatibility
function Rotation(unit)
    -- Validate unit and combat state
    if not unit or not UnitExists(unit) then
        return nil
    end

    -- Update game state
    updategs()

    -- Handle off-GCD abilities
    ogcd()

    -- Handle cooldowns
    Malevolence("default")

    -- Force cast abilities at combat start
    RainOfFire("force")
    RainOfFireT("force")

    -- Main rotation logic based on official APL structure
    if gs.havocUp then
        havocRot()
    elseif gs.shouldAoE then
        aoeRotation()
    elseif gs.shouldCleave or gs.cleaveApl then
        cleaveRotation()
    else
        singleTargetRotation()
    end

    -- Return nil as the callback system handles spell execution
    return nil
end

-- Make sure the function is globally accessible
_G.Rotation = Rotation

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
