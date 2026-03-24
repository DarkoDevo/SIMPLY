--[[
Fixed Shadowfiend, Mindbender, & Voidwraith
]]

if not MakuluValidCheck() then return true end
if Makulu_magic_number ~= 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 258 then return end

local FrameworkStart   = MakuluFramwork.start
local FrameworkEnd     = MakuluFramwork.endFunc
local RegisterIcon     = MakuluFramwork.registerIcon

local MakUnit          = MakuluFramwork.Unit
local MakSpell         = MakuluFramwork.Spell
local MakMulti         = MakuluFramwork.MultiUnits
local TableToLocal     = MakuluFramwork.tableToLocal
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local Debounce         = MakuluFramework.debounceSpell
local MakLists         = MakuluFramework.lists
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local MultiUnits       = Action.MultiUnits

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

    
    Smite = { ID = 585, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShadowWordPain = { ID = 589, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindBlast = { ID = 8092, FixedTexture = 136224, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FlashHeal = { ID = 2061, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    PowerWordShield = { ID = 17, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordFortitude = { ID = 21562, MAKULU_INFO = { ignoreCasting = true } },
    PsychicScream = { ID = 8122, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DesperatePrayer = { ID = 19236, MAKULU_INFO = { ignoreCasting = true } },
    Fade = { ID = 586, MAKULU_INFO = { ignoreCasting = true }, Macro = "/stopcasting\n/cast spell:thisID" },
    Resurrection = { ID = 2006, MAKULU_INFO = { ignoreCasting = true } },
    Levitate = { ID = 1706, MAKULU_INFO = { ignoreCasting = true } },
    MindSoothe = { ID = 453, MAKULU_INFO = { ignoreCasting = true } },
    Renew = { ID = 139, MAKULU_INFO = { ignoreCasting = true } },
    PurifyDisease = { ID = 213634, MAKULU_INFO = { ignoreCasting = true } },
    DispelMagic = { ID = 528, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Mindbender = { ID = 200174, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowfiend = { ID = 34433, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PrayerofMending = { ID = 33076, MAKULU_INFO = { ignoreCasting = true } },
    ShadowWordDeath = { ID = 32379, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    HolyNova = { ID = 132157, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    AngelicFeather = { ID = 121536, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@player]spell:thisID" },
    LeapofFaith = { ID = 73325, MAKULU_INFO = { ignoreCasting = true } },
    ShackleUndead = { ID = 9484, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    VoidTendrils = { ID = 108920, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindControl = { ID = 605, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DominateMind = { ID = 205364, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MassDispel = { ID = 32375, MAKULU_INFO = { ignoreCasting = true } },
    PowerInfusion = { ID = 10060, MAKULU_INFO = { ignoreCasting = true } },
    VampiricEmbrace = { ID = 15286, MAKULU_INFO = { ignoreCasting = true } },
    DivineStar = { ID = 122121, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Halo = { ID = 120644, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Mindgames = { ID = 375901, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PowerWordLife = { ID = 373481, MAKULU_INFO = { ignoreCasting = true } },
    VoidShift = { ID = 108968, MAKULU_INFO = { ignoreCasting = true } },
    
    DevouringPlague = { ID = 335467, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    Dispersion = { ID = 47585, MAKULU_INFO = { ignoreCasting = true } },
    Silence = { ID = 15487, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, offGcd = true } },
    PsychicHorror = { ID = 64044, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindSpike = { ID = 73510, Texture = 101056, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindSpikeInsanity = { ID = 407466, Texture = 101056, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DarkAscension = { ID = 391109, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    VoidEruption = { ID = 228260, Texture = 391109, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    VoidBolt = { ID = 205448, Texture = 391109, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },   
    ShadowCrash = { ID = 205385, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast [@cursor]spell:thisID" },
    ShadowCrashOther = { ID = 457042, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast [@cursor]spell:thisID" },
    VoidTorrent = { ID = 263165, Texture = 318276, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowform = { ID = 232698, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    VampiricTouch = { ID = 34914, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindFlay = { ID = 15407, Texture = 101056, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindFlayInsanity = { ID = 391403, Texture = 101056, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    Psyfiend = { ID = 211522, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Thoughtsteal = { ID = 316262, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    VoidBlast					  	      = { ID = 450405, Hidden = true	},
	Voidwraith					  	      = { ID = 451235, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast Voidwraith" },
    VoidVolley                            = { ID = 1242173, Texture = 318276, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    WhisperingShadows = { ID = 406777, Hidden = true },
    DistortedReality = { ID = 409044, Hidden = true },
    InescapableTorment = { ID = 373427, Hidden = true },
    IdolOfYoggsaron = { ID = 373273, Hidden = true },
    InsidiousIre = { ID = 373212, Hidden = true },
    IdolOfCthun = { ID = 377349, Hidden = true },
    PsychicLink = { ID = 199484, Hidden = true },
    TranslucentImage = { ID = 373446, Hidden = true },
    MindsEye = { ID = 407470, Hidden = true },
    ProtectiveLight = { ID = 193063, Hidden = true },
    TwinsOfTheSunPriestess = { ID = 373466, Hidden = true },
    Phantasm = { ID = 108942, Hidden = true },
    Voidform = { ID = 194249, Hidden = true },
    PowerSurge = { ID = 453109, Hidden = true },
    MindMelt = { ID = 391090, Hidden = true },
    DevourMatter = { ID = 451840, Hidden = true },
    VoidEmpowerment = { ID = 450138, Hidden = true },
    MindDevourer = { ID = 373202, Hidden = true },
    DepthOfShadows = { ID = 451308, Hidden = true },
    EntropicRift = { ID = 447444, Hidden = true },
    EmpoweredSurges = { ID = 453799, Hidden = true },
    VoidwraithTalent = { ID = 451234, Hidden = true },
    DarkEnergy = { ID = 451018, Hidden = true },
    Catharsis = { ID = 391297, Hidden = true },
    PerfectedForm = { ID = 453917, Hidden = true },
    DescendingDarkness = { ID = 451313, Hidden = true },
    Deathspeaker = { ID = 392507, Hidden = true },
    Rhapsody = { ID = 390622, Hidden = true },
    TwistOfFate = { ID = 390972, Hidden = true },

    -- Season 3 Set Bonuses and Hero Trees
    TWW3Archon4pcHelper = { ID = 1236399, Hidden = true }, -- Placeholder for set bonus tracking
    Ascension = { ID = 328530, Hidden = true }, -- Ascension buff
    TWW3Voidweaver4pcHelper = { ID = 1236397, Hidden = true }, -- Placeholder for Voidweaver set bonus

    -- Voidweaver Hero Tree Talents
    Voidheart = { ID = 449887, Hidden = true },
    CollectiveConsciousness = { ID = 447444, Hidden = true },
    NoEscape = { ID = 451204, Hidden = true },
    InnerQuiet = { ID = 448278, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    -- Season 3 Trinkets
    HyperthreadWristwraps = { Type = "Item", ID = 219334, Hidden = true },
    AberrantSpellforge = { Type = "Item", ID = 212451, Hidden = true },
    NeuralSynapseEnhancer = { Type = "Item", ID = 219312, Hidden = true },
    FlarendosPilotLight = { Type = "Item", ID = 219308, Hidden = true },
    GeargrinderSpareKeys = { Type = "Item", ID = 219300, Hidden = true },
    SpymastersWeb = { Type = "Item", ID = 220202, Hidden = true },
    PrizedGladiatorsBadgeOfFerocity = { Type = "Item", ID = 225897, Hidden = true },
    AstralGladiatorsBadgeOfFerocity = { Type = "Item", ID = 225896, Hidden = true },
    PerfidiousProjector = { Type = "Item", ID = 219317, Hidden = true },
    IngeniousManaBattery = { Type = "Item", ID = 219312, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_PRIEST_SHADOW] = A

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

local gs = {
    shouldAoE = false,
    maxVTs = 12,
    isVTPossible = false,
    holdingCrash = false,
    poolForCDs = false,
    dotsUp = false,
    manualVT = false,
    manualVTsApplied = false,
    petActive = false,
    petTime = 0,
    vtDelay = false,
    initialTargetGUID = nil,
    drForcePrio = true,
    meForcePrio = true,
    poolingMindblast = false,
    activeEnemies = 1,
    activeEnemiesTTD = 1,
    scInFlight = false,
    cursorCheck = false,
    vtRefreshable = false,
    fiendCd = 0,
    trinket1Buffs = false,
    trinket2Buffs = false,
    setBonusTWW3_4pc = false,
    isArchon = false,
    isVoidweaver = false,
}

local buffs = {
    arenaPreparation = 32727,
    shadowform = 232698,
    voidform = 194249,
    mindDevourer = 373204,
    deathspeaker = 392511,
    mindFlayInsanity = 391401,
    mindSpikeInsanity = 407468,
    powerInfusion = 10060,
    darkAscension = 391109,
    unfurlingDarkness = 341282,
    deathsTorment = 423726,
    shadowyInsight = 375981,
    entanglingAffix = 408556,
    fade = 583,
    protectiveLight = 193065,
    voidheart = 449887,
    catharsis = 391314,
    angelicFeather = 121557,
    mindMelt = 391090,
    entropicRift = 447444,
    powerSurge = 453109,
    voidVolley = 357442,
    twistOfFate = 390972,
    rhapsody = 390622,
    tww3Archon4pcHelper = 999999,
    ascension = 999998,
    bloodlust = 2825,
}

local debuffs = {
    exhaustion = 57723,
    vampiricTouch = 34914,
    devouringPlague = 335467,
}

local function num(val)
    if val then return 1 else return 0 end
end

local interrupts = {
    { spell = Silence },
    { spell = PsychicHorror, isCC = true, condition = function() return player:TalentKnown(PsychicHorror.id) end },
    { spell = PsychicScream, isCC = true, aoe = true, distance = 3 },
}

local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur, ttd)
    local cacheKey
    if debuff then
        cacheKey = "enemiesInRangeWithDebuff_" .. tostring(debuff)
    elseif ttd and ttd > 0 and (not debuff) and (dur == 0 or not dur) then
        cacheKey = "enemiesInRange_TTD_" .. tostring(ttd)
    else
        cacheKey = "enemiesInRange"
    end

    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        local ttd = ttd or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if ShadowWordPain:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if debuff and enemy:DebuffRemains(debuff, true) > dur and enemy.ttd > ttd then
                        count = count + 1
                    elseif not debuff and enemy.ttd > ttd then
                        count = count + 1
                    end
                end
            end
        end
        
        return count
    end)
end

local function activeEnemies()
    return math.max(MultiUnits:GetActiveEnemies(), 1)
end

local function shouldBurst()
    if A.BurstIsON("player") then
        if gs.burstTTD >= 1 or A.Zone == "pvp" or A.Zone == "arena" or target.isDummy then
            return true
        end
    end
    return false
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

local function isSpellInFlight(spell, speed)
    local casting = gs.imCasting and gs.imCasting == spell.id
    local travelTime = (target.distance / speed) * 1000
    
    if casting then
        return true
    end

    if spell.used > 10000 or spell.used < 0 then
        return false
    end

    if spell.used < travelTime or spell.used < 2000 then
        return true
    end

    return false
end

local function predInsanity()
    local insanChanges = {
        [MindBlast.id] = 6,
        [VampiricTouch.id] = 4,
        [DarkAscension.id] = 30,
    }
    
    local casting = player:CastOrChanelInfo()
    local spellId = casting and casting.spellId
    local currentInsanity = player.insanity
    
    return math.min(currentInsanity + (insanChanges[spellId] or 0), player.insanityMax)
end

local function delayVT()
    player = MakUnit:new("player")
    local imCasting = player.castInfo

    if imCasting and imCasting.spellId == VampiricTouch.spellId then 

        if not gs.initialTargetGUID then
            gs.initialTargetGUID = target.guid
        end

        if target.guid ~= gs.initialTargetGUID then
            gs.vtDelay = false
        else
            gs.vtDelay = true
        end
    else
        gs.vtDelay = false
        gs.initialTargetGUID = nil
    end
end

local function isPetActive()
    for i = 1, 4 do
        local _, name, startTime, duration = GetTotemInfo(i)
        if name == Voidwraith.wowName or name == Shadowfiend.wowName or name == Mindbender.wowName then
            local remainingTime = (startTime + duration) - GetTime()
            if remainingTime > 0 then
                return remainingTime
            end
        end
    end
    return 0
end


local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength
    
    return currentCast, currentCastName, remains, length
end

local function autoTarget()
    if not player.inCombat then return false end
    if A.Zone == "pvp" or A.Zone == "arena" then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if gs.scInFlight then
        return false
    end

    if A.GetToggle(2, "autoDOT") and gs.vtCount < gs.maxVTs and (not gs.vtRefreshable or gs.vtDelay) then
        return true
    end

    if ShadowWordPain:InRange(target) and target.exists then return false end

    if enemiesInRange() > 0 then
        return true
    end
end

local lastUpdateTime = 0
local updateDelay = 0.8

local function updateGameState()
    local currentTime = GetTime()
    local currentCast, _, remains = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        lastUpdateTime = currentTime
    end
    gs.castRemains = remains

    delayVT()

    gs.insanity = predInsanity()
    gs.insanityDeficit = player.insanityMax - gs.insanity
    gs.activeEnemies = activeEnemies()
    gs.activeEnemiesTTD = enemiesInRange(nil, nil, 18000)
    gs.burstTTD = enemiesInRange(nil, nil, A.GetToggle(2, "burstSens") * 1000)
    gs.vtCount = enemiesInRange(debuffs.vampiricTouch, 5000)
    gs.plagueCount = enemiesInRange(debuffs.devouringPlague, 5000)
    gs.scInFlight = isSpellInFlight(ShadowCrash, 10) or isSpellInFlight(ShadowCrashOther, 10)
    gs.petTime = isPetActive()
    gs.petActive = gs.petTime > 0
    gs.fiendCd = Shadowfiend.cd
    if player:TalentKnown(VoidwraithTalent.id) then
        gs.fiendCd = Voidwraith.cd
    elseif player:TalentKnown(Mindbender.id) then
        gs.fiendCd = Mindbender.cd
    end
    gs.shouldAoE = gs.activeEnemies > 2 and A.GetToggle(2, "AoE") and Action.Zone ~= "arena"

    local cursorCondition = (ShadowWordPain:InRange(mouseover) or FlashHeal:InRange(mouseover)) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gs.poolForCDs = (VoidEruption.cd <= Action.GetGCD() * 3000 and player:TalentKnown(VoidEruption.id) or DarkAscension.cd < 500 and player:TalentKnown(DarkAscension.id)) or player:TalentKnown(VoidTorrent.id) and player:TalentKnown(PsychicLink.id) and VoidTorrent.cd <= 4000 and gs.activeEnemies > 1 and not player:Buff(buffs.voidform)

    -- Season 3 APL variables
    gs.maxVTs = math.min(12, math.max(gs.activeEnemies, 1))
    if gs.activeEnemies > 12 then
        gs.maxVTs = 12
    end

    gs.isVTPossible = enemiesInRange(debuffs.vampiricTouch, 5000, 18000) >= 1

    -- Updated dots_up logic for Season 3
    gs.dotsUp = (enemiesInRange(debuffs.vampiricTouch, 5000) + (8 * num(gs.scInFlight and player:TalentKnown(WhisperingShadows.id)))) >= gs.maxVTs or not gs.isVTPossible
    if gs.activeEnemies < 3 then
        gs.dotsUp = gs.vtCount == gs.activeEnemies or gs.scInFlight and player:TalentKnown(WhisperingShadows.id)
    end

    -- Updated holding_crash logic for Season 3 - More aggressive for AoE
    gs.holdingCrash = false
    -- Only hold crash if we're expecting adds soon and not in active AoE
    if gs.activeEnemies <= 2 and ShadowCrash.cd < 10000 then
        gs.holdingCrash = true
    end

    -- Manual VTs applied logic
    gs.manualVTsApplied = (gs.vtCount + (8 * num(not gs.holdingCrash))) >= gs.maxVTs or not gs.isVTPossible

    gs.poolingMindblast = player:TalentKnown(VoidBlast.id) and math.max(VoidTorrent.cd, num(gs.holdingCrash)) <= A.GetGCD() * 1000 * (2 + num(player:TalentKnown(MindMelt.id)) * 2)

    gs.vtRefreshable = target:DebuffRemains(debuffs.vampiricTouch, true) < 5000 and not gs.vtDelay and not gs.scInFlight and (target.ttd > A.GetToggle(2, "vtRefresh") * 1000 or target.isDummy)

    -- Hero Tree Detection
    gs.isArchon = player:TalentKnown(PerfectedForm.id) or player:TalentKnown(PowerSurge.id) or player:TalentKnown(EmpoweredSurges.id)
    gs.isVoidweaver = player:TalentKnown(Voidheart.id) or player:TalentKnown(CollectiveConsciousness.id) or player:TalentKnown(NoEscape.id) or player:TalentKnown(InnerQuiet.id)

    -- Trinket buff tracking
    gs.trinket1Buffs = false -- TODO: Implement trinket detection
    gs.trinket2Buffs = false -- TODO: Implement trinket detection

    -- Set bonus tracking
    gs.setBonusTWW3_4pc = false -- TODO: Implement set bonus detection

    gs.inRaid = MakMulti.party:Size() > 5
end

PowerWordFortitude:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(PowerWordFortitude.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 end)
    
    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then 
        return Debounce("pwf", 1000, 2500, spell, player)
    end
end)

Fade:Callback(function(spell)
    if not player:TalentKnown(TranslucentImage.id) then return end
    if A.Zone == "arena" or A.Zone == "pvp" then return end

    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if player:TalentKnown(TranslucentImage.id) and shouldDefensive() and defensiveSelect[1] then 
        return spell:Cast()
    end
        
    if MakMulti.party:Size() >= 2 and UnitThreatSituation(player:CallerId()) == 3 then
        return spell:Cast()
    end
end)

DesperatePrayer:Callback(function(spell)
    if player.hp > A.GetToggle(2, "DesperatePrayerHP") then return end
    
    return spell:Cast()
end)

Dispersion:Callback(function(spell)
    if player.hp > A.GetToggle(2, "dispersionHP") then return end
    
    return spell:Cast()
end)

VampiricEmbrace:Callback(function(spell)
    if not shouldBurst() then return end -- easiest way to check if enemies are going to live long enough to be worth
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if player.hp < 50 or (shouldDefensive() and defensiveSelect[2]) then 
        return spell:Cast()
    end
end)

FlashHeal:Callback("pve", function(spell)
    if not A.ProtectiveLight:IsTalentLearned() then return end
    if not shouldDefensive() then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end
    if player:Buff(buffs.fade) and A.TranslucentImage:IsTalentLearned() then return end
    if player:Buff(buffs.voidform) or player:Buff(buffs.darkAscension) then return end
    if player:Buff(buffs.protectiveLight) then return end

    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast()
end)

FlashHeal:Callback("target", function(spell)
    if not target.exists then return end
    if not target.isFriendly then return end
    if target.hp > 95 then return end

    return spell:Cast(target)
end)

PowerWordShield:Callback("pve", function(spell)
    if player:Buff(spell.id) then return end

    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if player.hp < A.GetToggle(2, "PWSHP") or (shouldDefensive() and defensiveSelect[4]) or (not player.inCombat and A.GetToggle(2, "oocPWS")) then 
        return spell:Cast()
    end
end)

DispelMagic:Callback("pve", function(spell)
    if not target:BuffFrom(MakLists.pvePurge) then return end

    return spell:Cast(target)
end)

Shadowform:Callback(function(spell)
    if player:Buff(buffs.shadowform) then return end
    if player:Buff(buffs.voidform) then return end

    return spell:Cast()
end)

ArcaneTorrent:Callback("pre", function(spell)
    if not Action.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

Halo:Callback("pre", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if activeEnemies() <= 4 then
        return spell:Cast()
    end
end)

ShadowCrash:Callback("pre", function(spell)
    if not gs.cursorCheck then return end
    if activeEnemies() > 1 then
        return spell:Cast()
    end
end)

ShadowCrashOther:Callback("pre", function(spell)
    if activeEnemies() > 1 then
        return spell:Cast()
    end
end)

VampiricTouch:Callback("pre", function(spell)
    if not gs.vtRefreshable then return end

    return spell:Cast(target)
end)

local function precombat()
    ArcaneTorrent("pre")
    Halo("pre")
    ShadowCrash("pre")
    ShadowCrashOther("pre")
    VampiricTouch("pre")
end

-- Season 3: Updated AoE logic - Shadow Crash priority for AoE
ShadowCrash:Callback("aoe", function(spell)
    if not gs.cursorCheck then return end
    if gs.holdingCrash then return end
    if gs.scInFlight then return end

    -- High priority for AoE: Use Shadow Crash to apply VTs efficiently
    if gs.activeEnemies > 2 then
        return spell:Cast()
    end

    if gs.vtRefreshable or target:DebuffRemains(debuffs.vampiricTouch, true) <= target.ttd and not player:Buff(buffs.voidform) then
        return spell:Cast()
    end
end)

ShadowCrashOther:Callback("aoe", function(spell)
    if gs.holdingCrash then return end
    if gs.scInFlight then return end

    -- High priority for AoE: Use Shadow Crash to apply VTs efficiently
    if gs.activeEnemies > 2 then
        return spell:Cast()
    end

    if gs.vtRefreshable or target:DebuffRemains(debuffs.vampiricTouch, true) <= target.ttd and not player:Buff(buffs.voidform) then
        return spell:Cast()
    end
end)

VampiricTouch:Callback("aoe", function(spell)
    if not gs.vtRefreshable then return end
    if target.ttd < 18000 then return end
    if not (target:Debuff(debuffs.vampiricTouch, true) or not gs.dotsUp) then return end
    if player:Buff(buffs.entropicRift) then return end

    if gs.maxVTs > 0 and not gs.manualVTsApplied and not gs.scInFlight then
        return spell:Cast(target)
    end
end)

local function aoe()
    -- Season 3: AoE variables are handled in updateGameState()
    -- Shadow Crash first for efficient VT application
    ShadowCrash("aoe")
    ShadowCrashOther("aoe")
    VampiricTouch("aoe")
end

Fireblood:Callback(function(spell)
    if not shouldBurst() then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

Berserking:Callback(function(spell)
    if not shouldBurst() then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

BloodFury:Callback(function(spell)
    if not shouldBurst() then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not shouldBurst() then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

PowerInfusion:Callback(function(spell)
    if not shouldBurst() then return end
    if player:Buff(buffs.powerInfusion) then return end

    -- Season 3: Updated Power Infusion logic
    if (player:Buff(buffs.voidform) or player:Buff(buffs.darkAscension) and (player.combatTime <= 80000 or player.combatTime >= 140000)) and (not player:Buff(buffs.powerInfusion) or gs.setBonusTWW3_4pc and player:BuffRemains(buffs.powerInfusion) <= 15000) then
        return spell:Cast()
    end
end)

--actions.cds+=/halo,if=talent.power_surge&(pet.fiend.active&cooldown.fiend.remains>=4&talent.mindbender|!talent.mindbender&!cooldown.fiend.up|active_enemies>2&!talent.inescapable_torment|!talent.dark_ascension)&(cooldown.mind_blast.charges=0|!cooldown.void_torrent.up|!talent.void_eruption|cooldown.void_eruption.remains>=gcd.max*4|buff.mind_devourer.up&talent.mind_devourer)
Halo:Callback(function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:TalentKnown(PowerSurge.id) and (gs.petActive and gs.fiendCd >= 4000 and player:TalentKnown(Mindbender.id) or not player:TalentKnown(Mindbender.id) and gs.fiendCd > 500 or gs.activeEnemies > 2 and not player:TalentKnown(InescapableTorment.id) or not player:TalentKnown(DarkAscension.id)) and (MindBlast.frac < 1 or VoidTorrent.cd > 500 or not player:TalentKnown(VoidEruption.id) or VoidEruption.cd >= A.GetGCD() * 4000 or player:Buff(buffs.mindDevourer) and player:TalentKnown(MindDevourer.id)) then
        return spell:Cast()
    end
end)

--actions.cds+=/void_eruption,if=(pet.fiend.active&cooldown.fiend.remains>=4|!talent.mindbender&!cooldown.fiend.up|active_enemies>2&!talent.inescapable_torment)&(cooldown.mind_blast.charges=0|time>15|buff.mind_devourer.up&talent.mind_devourer|buff.power_surge.up)
VoidEruption:Callback(function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end
    if gs.fiendCd < 500 then return end

    if (gs.petActive and gs.fiendCd >= 4000 or not player:TalentKnown(Mindbender.id) or gs.activeEnemies > 2 and not player:TalentKnown(InescapableTorment.id)) and (MindBlast.frac < 1 or player.combatTime > 15000 or player:Buff(buffs.mindDevourer) and player:TalentKnown(MindDevourer.id) or player:Buff(buffs.powerSurge)) then
        return spell:Cast()
    end
end)

--actions.cds+=/dark_ascension,if=(pet.fiend.active&cooldown.fiend.remains>=4|!talent.mindbender&!cooldown.fiend.up|active_enemies>2&!talent.inescapable_torment)&(active_dot.devouring_plague>=1|insanity>=(20-(5*talent.minds_eye)+(5*talent.distorted_reality)-(pet.fiend.active*2)))
DarkAscension:Callback(function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if (gs.petActive and gs.fiendCd >= 4000 or not player:TalentKnown(Mindbender.id) or gs.activeEnemies > 2 and not player:TalentKnown(InescapableTorment.id)) and (gs.plagueCount >= 1 or gs.insanity >= (20 - (5 * num(player:TalentKnown(MindsEye.id))) + (5 * num(player:TalentKnown(DistortedReality.id))) - (num(gs.petActive) * 2))) then
        return spell:Cast()
    end
end)

-- Season 3: Trinket usage callbacks
HyperthreadWristwraps:Callback(function(spell)
    if not player:TalentKnown(VoidBlast.id) then return end
    -- TODO: Implement hyperthread_wristwraps.void_blast.count>=2 logic
    if MindBlast.cd > 500 then
        return spell:Cast()
    end

    if not player:TalentKnown(VoidBlast.id) then
        -- TODO: Implement hyperthread_wristwraps.void_bolt.count>=1 and void_torrent.count>=1 logic
        return spell:Cast()
    end
end)

AberrantSpellforge:Callback(function(spell)
    if A.GetGCD() > 0 then return end
    -- TODO: Implement buff.aberrant_spellforge.stack<=4 logic
    return spell:Cast()
end)

NeuralSynapseEnhancer:Callback(function(spell)
    if not (player:Buff(buffs.powerSurge) or player:Buff(buffs.entropicRift) or gs.trinket1Buffs or gs.trinket2Buffs) then return end
    if not (player:Buff(buffs.voidform) or VoidEruption.cd >= 40000 or player:Buff(buffs.darkAscension)) then return end

    return spell:Cast()
end)

local function cds()
    Fireblood()
    Berserking()
    BloodFury()
    AncestralCall()
    PowerInfusion()
    Halo()
    VoidEruption()
    DarkAscension()

    -- Season 3: Trinket usage
    HyperthreadWristwraps()
    AberrantSpellforge()
    NeuralSynapseEnhancer()

    if player:Buff(buffs.powerInfusion) or player:Buff(buffs.darkAscension) then
        if Trinket(1, "Damage") then Trinket1() end
        if Trinket(2, "Damage") then Trinket2() end
    end
end

MindSpike:Callback("empfiller", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:TalentKnown(spell.id) then return end

    if not player:Buff(buffs.mindSpikeInsanity) then return end
    if target:DebuffRemains(debuffs.devouringPlague, true) < spell:CastTime() then return end

    return spell:Cast(target)
end)

MindFlay:Callback("empfiller", function(spell)
    if player.moving then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.mindFlayInsanity) then return end
    if not target:Debuff(debuffs.devouringPlague, true) then return end

    return spell:Cast(target)
end)

local function empFiller()
    MindSpike("empfiller")
    MindFlay("empfiller")
end

VampiricTouch:Callback("filler", function(spell)
    if not player:Buff(buffs.unfurlingDarkness) then return end
    if gs.vtDelay == 1 then return end

    return spell:Cast(target)
end)


ShadowWordDeath:Callback("filler", function(spell)
    if target.hp < 20 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.deathspeaker) and target:Debuff(debuffs.devouringPlague, true) then
        return spell:Cast(target)
    end

    if player:TalentKnown(InescapableTorment.id) and gs.petActive then
        return spell:Cast(target)
    end
end)

DevouringPlague:Callback("filler", function(spell)
    if spell:Cost() > gs.insanity then return end

    if player:Buff(buffs.voidform) then 
        return spell:Cast(target)
    end

    if DarkAscension.cd < 500 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.mindDevourer) then
        return spell:Cast(target)
    end
end)

Halo:Callback("filler", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.activeEnemies <= 1 then return end

    return spell:Cast()
end)

MindSpike:Callback("filler", function(spell)
    if not player:TalentKnown(spell.id) then return end

    return spell:Cast(target)
end)

MindFlay:Callback("filler", function(spell)
    if player.moving then return end
    if gs.imCasting and gs.imCasting == spell.id and gs.castRemains and gs.castRemains > 1000 then return end

    return spell:Cast(target)
end)

DivineStar:Callback("filler", function(spell)

    return spell:Cast()
end)

ShadowCrash:Callback("filler", function(spell)
    if gs.cursorCheck then return end
    if not gs.vtRefreshable then return end

    return spell:Cast()
end)

ShadowCrashOther:Callback("filler", function(spell)
    if not gs.vtRefreshable then return end

    return spell:Cast()
end)

ShadowWordDeath:Callback("filler2", function(spell)

    return spell:Cast(target)
end)

ShadowWordPain:Callback("filler", function(spell)
    
    return spell:Cast(target)
end)

local function filler()
    VampiricTouch("filler")
    empFiller()
    ShadowWordDeath("filler")
    DevouringPlague("filler")
    Halo("filler")
    MindSpike("filler")
    if gs.imCasting and gs.imCasting == MindFlay.id and gs.castRemains and gs.castRemains > 1000 then return end
    MindFlay("filler")
    DivineStar("filler")
    ShadowCrash("filler")
    ShadowWordDeath("filler2")
    
end

--actions.main+=/vampiric_touch,target_if=min:remains,if=buff.unfurling_darkness.up&talent.unfurling_darkness&talent.mind_melt&talent.void_blast&buff.mind_melt.stack<2&cooldown.mindbender.up&cooldown.dark_ascension.up&time<=4
VampiricTouch:Callback("main1", function(spell)
    if not gs.vtRefreshable then return end
    if target.ttd < 12000 then return end

    if player:Buff(buffs.unfurlingDarkness) and player:TalentKnown(MindMelt.id) and player:TalentKnown(VoidBlast.id) and player:HasBuffCount(buffs.mindMelt) < 2 and gs.fiendCd < 700 and DarkAscension.cd < 700 and player.combatTime <= 4 then
        return spell:Cast(target)
    end
end)

-- Season 3: Updated Mindbender/Shadowfiend logic
Mindbender:Callback("main", function(spell, enemy)
    local player = ConstUnit.player
    if not spell:ReadyToUse() then return end
    if not player:TalentKnown(Mindbender.id) then return end      -- require Mindbender talent
    if player:TalentKnown(VoidwraithTalent.id) then return end    -- block if Voidwraith talented

    local u = enemy or target or ConstUnit.target
    if not u or not u:Exists() or u:IsDeadOrGhost() or not u:CanAttack() then return end
    if (spell:HasRange() and not spell:InRange(u)) or (u.Los and not u:Los()) then return end

    return spell:Cast(u)
end)

Shadowfiend:Callback("main", function(spell, enemy)
    local player = ConstUnit.player
    if not spell:ReadyToUse() then return end
    if player:TalentKnown(Mindbender.id) then return end         -- block if Mindbender talented
    if player:TalentKnown(VoidwraithTalent.id) then return end   -- block if Voidwraith talented

    local u = enemy or target or ConstUnit.target
    if not u or not u:Exists() or u:IsDeadOrGhost() or not u:CanAttack() then return end
    if (spell:HasRange() and not spell:InRange(u)) or (u.Los and not u:Los()) then return end

    return spell:Cast(u)  -- if Shadowfiend is untargeted in your API, use: return spell:Cast()
end)

-- Voidwraith: use if (PI ready OR we already have PI), NOT talented into Mindbender,
-- and we've been in combat > 5s.
Voidwraith:Callback("main", function(spell, enemy)
    local player = ConstUnit.player
    local u = enemy or target or ConstUnit.target

    -- spell ready / talent gate / time-in-combat
    if not spell:ReadyToUse() then return end
    if player:TalentKnown(Mindbender.id) then return end
    if player.combatTime <= 5 then return end

    -- Power Infusion condition (ready OR already on us)
    local piOk = PowerInfusion:ReadyToUse() or player:HasBuff(buffs.powerInfusion, true)
    if not piOk then return end

    -- basic target sanity (if Voidwraith is targeted; if it's untargeted, just do: return spell:Cast())
    if not u or not u:Exists() or u:IsDeadOrGhost() or not u:CanAttack() then return end
    if (spell:HasRange() and not spell:InRange(u)) or (u.Los and not u:Los()) then return end

    return spell:Cast(u)   -- if Voidwraith is untargeted in your API, use: return spell:Cast()
end)


ShadowWordDeath:Callback("main", function(spell)
    if not player:TalentKnown(DevourMatter.id) then return end

    if (target.hp <= 20 or target:Debuff(debuffs.devouringPlague, true)) and target.shield > 0 then
        return spell:Cast(target)
    end
end)

-- Season 3: Updated Mind Blast for Void Blast talent
MindBlast:Callback("mainVoid", function(spell)
    if not player:TalentKnown(VoidBlast.id) then return end

    if (target:DebuffRemains(debuffs.devouringPlague, true) >= spell:CastTime() or player:BuffRemains(buffs.voidheart) <= A.GetGCD() * 1000 or gs.imCasting and gs.imCasting == VoidTorrent.id and player:TalentKnown(VoidEmpowerment.id)) and (gs.insanityDeficit >= 16 or MindBlast:TimeToFullCharges() <= A.GetGCD() * 1000) and (not player:TalentKnown(MindDevourer.id) or not player:Buff(buffs.mindDevourer) or player:BuffRemains(buffs.voidheart) <= A.GetGCD() * 1000) then
        return spell:Cast(target)
    end
end)

DevouringPlague:Callback("main", function(spell)
    if not player:Buff(buffs.voidform) then return end
    if not player:TalentKnown(PerfectedForm.id) then return end
    if not player:TalentKnown(VoidEruption.id) then return end

    if player:BuffRemains(buffs.voidform) <= A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

MindBlast:Callback("main", function(spell)
    local gcdMax = A.GetGCD() * 1000
    local vbCd = VoidBolt.cd

    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.voidform) then return end
    if spell:TimeToFullCharges() > gcdMax then return end

    if player:TalentKnown(InsidiousIre.id) then
        if target:DebuffRemains(debuffs.devouringPlague, true) < spell:CastTime() then return end
    end

    local intMod = vbCd % gcdMax
    local floatMod = vbCd - math.floor(vbCd / gcdMax) * gcdMax

    if player:Buff(buffs.voidform) then
        if (intMod - floatMod) * gcdMax <= 0.25 and (intMod - floatMod) >= 0.01 then
            return spell:Cast(target)
        end
    else
        return spell:Cast(target)
    end
end)

VoidBolt:Callback("main", function(spell)
    if gs.insanityDeficit <= 16 then return end
    if VoidBolt.cd % A.GetGCD() * 1000 > 0.1 then return end

    return spell:Cast(target)
end)

-- Season 3: Void Volley usage
VoidVolley:Callback("main", function(spell)
    

    return spell:Cast(target)
end)

VoidVolley:Callback("main2", function(spell)
    if not player:TalentKnown(spell.id) then return end

    return spell:Cast(target)
end)

-- Season 3: Mind Flay Insanity priority
MindFlayInsanity:Callback("main", function(spell)
    if not player:TalentKnown(spell.id) then return end
    if player.moving then return end

    return spell:Cast(target)
end)

DevouringPlague:Callback("main2", function(spell)
    if spell:Cost() > gs.insanity then return end

    -- Voidweaver: Enhanced conditions from TWW3_Priest_Shadow.simc
    if gs.isVoidweaver then
        if enemiesInRange(debuffs.devouringPlague) <= 1 and target:DebuffRemains(debuffs.devouringPlague, true) <= A.GetGCD() * 1000 and (not player:TalentKnown(VoidEruption.id) or VoidEruption.cd >= A.GetGCD() * 3000) then
            return spell:Cast(target)
        end

        if gs.insanityDeficit <= 35 then
            return spell:Cast(target)
        end

        if player:Buff(buffs.mindDevourer) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.entropicRift) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.powerSurge) and player:HasBuffCount(buffs.tww3Archon4pcHelper) < 4 and player:Buff(buffs.ascension) then
            return spell:Cast(target)
        end
    else
        -- Archon logic
        if gs.insanityDeficit <= 6 then
            return spell:Cast(target)
        end

        if enemiesInRange(debuffs.devouringPlague) <= 1 and target:DebuffRemains(debuffs.devouringPlague, true) < A.GetGCD() * 1000 and (not player:TalentKnown(VoidEruption.id) or VoidEruption.cd >= A.GetGCD() * 3000) then
            return spell:Cast(target)
        end
    end
end)

-- Season 3: Updated Void Torrent logic
VoidTorrent:Callback("main", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end
    if player.moving and not player:TalentKnown(DarkEnergy.id) then return end
    if gs.holdingCrash then return end

    if not player:TalentKnown(EntropicRift.id) then return end
    if target:DebuffRemains(debuffs.devouringPlague, true) >= 2500 and (DarkAscension.cd >= 12000 or not player:TalentKnown(DarkAscension.id) or not player:TalentKnown(VoidBlast.id)) or VoidEruption.cd <= 3000 and player:TalentKnown(VoidEruption.id) then
        local awareAlert = A.GetToggle(2, "makAware")
        if awareAlert[3] and not player:TalentKnown(DarkEnergy.id) then
            Aware:displayMessage("VOID TORRENT! STAND STILL", "WHITE", 1)
        end
        if A.Zone == "pvp" or A.Zone == "arena" then
            if player:AttackersV69() >= 1 then
                return Fade:Cast()
            end
        end
        return spell:Cast(target)
    end
end)

VoidTorrent:Callback("main2", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end
    if player.moving and not player:TalentKnown(DarkEnergy.id) then return end
    if gs.holdingCrash then return end
    if player:TalentKnown(EntropicRift.id) then return end
    if target:DebuffRemains(debuffs.devouringPlague, true) < 2500 then return end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[3] and not player:TalentKnown(DarkEnergy.id) then
        Aware:displayMessage("VOID TORRENT! STAND STILL", "WHITE", 1)
    end

    if A.Zone == "pvp" or A.Zone == "arena" then
        if player:AttackersV69() >= 1 then
            return Fade:Cast()
        end
    end
    return spell:Cast(target)
end)

-- Season 3: Updated Shadow Word: Death logic
ShadowWordDeath:Callback("main2", function(spell)
    if target.hp <= (20 + 15 * num(player:TalentKnown(Deathspeaker.id))) then
        return spell:Cast(target)
    end
end)

ShadowWordDeath:Callback("main3", function(spell)
    if not player:TalentKnown(InescapableTorment.id) then return end
    if not gs.petActive then return end

    return spell:Cast(target)
end)

MindBlast:Callback("main2", function(spell)
    local gcdMax = A.GetGCD() * 1000
    if gs.imCasting and gs.imCasting == spell.id then return end

    if not gs.petActive then return end
    if not player:TalentKnown(InescapableTorment.id) then return end
    if gs.petTime < spell:CastTime() then return end
    if gs.activeEnemies > 7 then return end
    if player:Buff(buffs.mindDevourer) then return end
    if target:DebuffRemains(debuffs.devouringPlague, true) < spell:CastTime() then return end
    if gs.poolingMindblast then return end
    if not gs.dotsUp then return end

    if MindBlast:TimeToFullCharges() <= gcdMax + spell:CastTime() or gs.petTime <= gcdMax + spell:CastTime() then
        return spell:Cast(target)
    end
end)

ShadowWordDeath:Callback("main3", function(spell)
    if not gs.petActive then return end
    if gs.petTime > (A.GetGCD() * 1000) + 1000 then return end
    if not player:TalentKnown(InescapableTorment.id) then return end
    if gs.activeEnemies > 7 then return end

    return spell:Cast(target)
end)

VoidBolt:Callback("main2", function(spell)

    return spell:Cast(target)
end)

DevouringPlague:Callback("main3", function(spell)
    if spell:Cost() > gs.insanity then return end

    if not target.isBoss then return end
    if target.ttd > target:DebuffRemains(debuffs.devouringPlague, true) + 4000 then return end

    return spell:Cast(target)
end)

DevouringPlague:Callback("main4", function(spell)
    if spell:Cost() > gs.insanity then return end

    -- Voidweaver specific logic
    if gs.isVoidweaver then
        if player:Buff(buffs.voidform) and player:TalentKnown(VoidEruption.id) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.powerSurge) then
            return spell:Cast(target)
        end

        if player:TalentKnown(DistortedReality.id) then
            return spell:Cast(target)
        end
    end

    -- Archon specific logic
    if gs.isArchon then
        if gs.insanityDeficit <= 35 and player:TalentKnown(DistortedReality.id) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.darkAscension) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.mindDevourer) and MindBlast.cd < 500 and (VoidEruption.cd >= 3000 * A.GetGCD() or not player:TalentKnown(VoidEruption.id)) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.voidheart) then
            return spell:Cast(target)
        end

        if player:Buff(buffs.voidform) and player:TalentKnown(PerfectedForm.id) and player:TalentKnown(VoidEruption.id) then
            return spell:Cast(target)
        end
    end

    -- Generic logic for both trees
    if player:Buff(buffs.darkAscension) or player:Buff(buffs.voidform) then
        return spell:Cast(target)
    end
end)

VoidTorrent:Callback("main2", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end
    if player.moving and not player:TalentKnown(DarkEnergy.id) then return end
    if gs.holdingCrash then return end
    if player:TalentKnown(EntropicRift.id) then return end
    if target:DebuffRemains(debuffs.devouringPlague, true) < 2500 then return end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[3] and not player:TalentKnown(DarkEnergy.id) then -- Void Torrent soon
        Aware:displayMessage("VOID TORRENT! STAND STILL", "WHITE", 1)
    end

    if A.Zone == "pvp" or A.Zone == "arena" then
        if player:AttackersV69() >= 1 then
            return Fade:Cast()
        end
    end
    return spell:Cast(target)
end)

-- High priority Shadow Crash for AoE scenarios
ShadowCrash:Callback("aoe_priority", function(spell)
    if not gs.cursorCheck then return end
    if gs.scInFlight then return end
    if gs.activeEnemies <= 2 then return end
    -- Don't hold crash in active AoE scenarios
    if gs.holdingCrash and gs.activeEnemies <= 3 then return end

    -- Use Shadow Crash aggressively in AoE to apply VTs
    return spell:Cast()
end)

ShadowCrashOther:Callback("aoe_priority", function(spell)
    if gs.scInFlight then return end
    if gs.activeEnemies <= 2 then return end
    -- Don't hold crash in active AoE scenarios
    if gs.holdingCrash and gs.activeEnemies <= 3 then return end

    -- Use Shadow Crash aggressively in AoE to apply VTs
    return spell:Cast()
end)

ShadowCrash:Callback("main", function(spell)
    if not gs.cursorCheck then return end
    if gs.holdingCrash then return end
    if gs.scInFlight then return end

    -- Priority for VT refresh in single target
    if gs.vtRefreshable then
        return spell:Cast()
    end
end)

ShadowCrashOther:Callback("main", function(spell)
    if gs.holdingCrash then return end
    if gs.scInFlight then return end

    -- Priority for VT refresh in single target
    if gs.vtRefreshable then
        return spell:Cast()
    end
end)

VampiricTouch:Callback("main", function(spell)
    if not gs.vtRefreshable then return end

    if (target:Debuff(debuffs.vampiricTouch, true) or not gs.dotsUp) and (gs.maxVTs > 0 or gs.activeEnemies <= 1) and (ShadowCrash.cd >= target:DebuffRemains(debuffs.vampiricTouch, true) or gs.holdingCrash or not player:TalentKnown(WhisperingShadows.id)) and (not gs.scInFlight or not player:TalentKnown(WhisperingShadows.id)) then
        return spell:Cast(target)
    end
end)

ShadowWordDeath:Callback("main4", function(spell)
    if not gs.dotsUp then return end
    if not player:Buff(buffs.deathspeaker) then return end

    return spell:Cast(target)
end)

MindBlast:Callback("main3", function(spell)
    if gs.poolingMindblast then return end
    if gs.imCasting and gs.imCasting == spell.id and spell.frac < 1.9 then return end

    -- Voidweaver: Enhanced Mind Blast logic
    if gs.isVoidweaver then
        if not player:Buff(buffs.mindDevourer) or not player:TalentKnown(MindDevourer.id) or VoidEruption.cd < 500 and player:TalentKnown(VoidEruption.id) then
            return spell:Cast(target)
        end
    else
        -- Archon logic
        if not player:Buff(buffs.mindDevourer) then
            return spell:Cast(target)
        end

        if VoidEruption.cd < 500 and player:TalentKnown(VoidEruption.id) then
            return spell:Cast(target)
        end
    end
end)

local function mainVoidweaver()
    -- Voidweaver-specific rotation based on TWW3_Priest_Shadow.simc
    Shadowfiend("main")
    Voidwraith("main")
    Mindbender("main")

    -- High priority Shadow Crash for AoE scenarios
    ShadowCrash("aoe_priority")
    ShadowCrashOther("aoe_priority")

    ShadowWordDeath("main")
    MindBlast("mainVoid")
    DevouringPlague("main")
    MindBlast("main")
    VoidBolt("main")
    DevouringPlague("main2")
    VoidTorrent("pvp")
    VoidVolley("main")
    MindFlayInsanity("main")
    ShadowCrash("main")
    ShadowCrashOther("main")
    VampiricTouch("main")
    MindBlast("main3")
    VoidVolley("main2")
    DevouringPlague("main4")
    Halo("filler")
    -- Voidweaver: Additional Shadow Crash usage for movement
    ShadowCrash("filler")
    ShadowWordDeath("main2")
    ShadowWordDeath("main3")
    MindFlay("filler")
    DivineStar("filler")
    ShadowWordDeath("filler2")
    
end

local function main()
    -- Season 3 APL: Potion usage
    if shouldBurst() then
        local damagePotion = Action.GetToggle(2, "damagePotion")
        local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
        local potionExhausted = Action.GetToggle(2, "potionExhausted")
        local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
        local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

        if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
            local shouldPot = (player:Buff(buffs.voidform) and player:Buff(buffs.powerInfusion) or player:Buff(buffs.darkAscension)) and (player.combatTime >= 320000 or player:SatedRemains() >= 320000 or player:Buff(buffs.bloodlust)) or player.combatTime <= 30000
            if shouldPot then
                return Potion()
            end
        end

        cds()
    end

    -- Hero Tree Detection and Rotation Selection
    if gs.isVoidweaver then
        mainVoidweaver()
    else
        -- Season 3 APL Main Priority (Archon)
        Shadowfiend("main")
        Voidwraith("main")
        Mindbender("main")

        -- High priority Shadow Crash for AoE scenarios
        ShadowCrash("aoe_priority")
        ShadowCrashOther("aoe_priority")

        ShadowWordDeath("main")
        MindBlast("mainVoid")
        DevouringPlague("main")
        MindBlast("main")
        VoidBolt("main")
        DevouringPlague("main2")
        VoidTorrent("pvp")
        VoidVolley("main")
        MindFlayInsanity("main")
        ShadowCrash("main")
        ShadowCrashOther("main")
        VampiricTouch("main")
        MindBlast("main3")
        VoidVolley("main2")
        DevouringPlague("main4")
        Halo("filler")
        ShadowCrash("filler")
        ShadowWordDeath("main2")
        ShadowWordDeath("main3")
        DivineStar("filler")
        ShadowWordDeath("filler2")
        
        filler()
    end
end

------------------------------------------------------------
---------------------------ARENA----------------------------
------------------------------------------------------------

local function shouldFadePvP()
    if player:TalentKnown(DarkEnergy.id) then
        if VoidTorrent.cd < 18000 and VoidTorrent.cd > 500 then return false end
    end

    local arenaEnemies = {arena1, arena2, arena3}
    for _, enemy in pairs(arenaEnemies) do
        local castInfo = enemy.castOrChannelInfo
        if enemy.exists and castInfo and castInfo.remaining <= 1000 then
            if MakLists.arenaFadeList[castInfo.spellId] or (MakLists.swdList[castInfo.spellId] and ShadowWordDeath.used > 1000) then
                return true
            end
        end
    end
    return false
end

Fade:Callback("avoid_damage", function(spell)
    if shouldFadePvP() then
        return Debounce("fade_damage", 300, 600, spell, player)
    end
end)

local function shouldSwdPvp()
    local arenaEnemies = {arena1, arena2, arena3}
    for _, enemy in pairs(arenaEnemies) do
        local castInfo = enemy.castOrChannelInfo
        if enemy.exists and castInfo and castInfo.remaining <= 1000 and Fade.used > 1000 then
            if MakLists.swdList[castInfo.spellId] then
                return true
            end
        end
    end
    return false
end

ShadowWordDeath:Callback("avoid_cc", function(spell)
    if shouldSwdPvp() then
        return Debounce("death_damage", 300, 600, spell, target)
    end
end)

PsychicScream:Callback("pvp", function(spell)
    local arenaEnemies = {arena1, arena2, arena3}
    for _, enemy in pairs(arenaEnemies) do
        if enemy.exists and enemy.distance <= 3 and enemy.cds and enemy.disorientDr >= 0.5 and not enemy:IsUnit(enemyHealer) then
            return Debounce("self_peel", 300, 600, spell, player)
        end
    end

    if enemyHealer.exists and enemyHealer.hp > 0 then
        if enemyHealer.disorientDr < 0.5 then return end
        if enemyHealer.distance > 3 then return end
    
        if enemyHealer.magicImmune then return end
        if enemyHealer.ccImmune then return end
        if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

        return Debounce("scream", 300, 600, spell, player)
    end
end)

ShadowWordPain:Callback("catharsis", function(spell)
    if not player:TalentKnown(Catharsis.id) then return end
    
    local tenPercentHealth = player.maxHealth * 0.10
    local shouldCatharsis = player:Buff(buffs.catharsis) and player:HasBuffPoints(buffs.catharsis)[1] >= tenPercentHealth

    if not shouldCatharsis then return end

    return spell:Cast(target)
end)

Psyfiend:Callback(function(spell)
    if VoidTorrent.used < 0 then return end
    if VoidTorrent.used > 5000 then return end

    return spell:Cast()
end)

VoidEruption:Callback("pvp", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end
    if VoidTorrent.cd > spell:CastTime() then return end
    if not gs.petActive and gs.fiendCd < 10000 then return end

    return spell:Cast(target)
end)

DarkAscension:Callback("pvp", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[1] then return end
    if VoidTorrent.cd > spell:CastTime() then return end
    if not gs.petActive and player:TalentKnown(Mindbender.id) then return end

    return spell:Cast(target)
end)

VampiricTouch:Callback("pvp_targ", function(spell)
    if target:DebuffRemains(debuffs.vampiricTouch, true) > 4000 then return end
    if gs.vtDelay then return end

    return spell:Cast(target)
end)

ShadowCrashOther:Callback("pvp_targ", function(spell)
    if target:DebuffRemains(debuffs.vampiricTouch, true) > 4000 then return end
    if gs.vtDelay then return end

    return spell:Cast(target)
end)

Mindbender:Callback("pvp", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[2] then return end
    if gs.fiendCd > 300 then return end
    if VoidTorrent.cd > 4000 then return end
    if not spell:ReadyToUse() then return end
    if not player:TalentKnown(Mindbender.id) then return end      -- require Mindbender talent
    if player:TalentKnown(VoidwraithTalent.id) then return end    -- block if Voidwraith talented

    return spell:Cast(target)
end)

VampiricTouch:Callback("unfurl", function(spell)
    if not player:Buff(buffs.unfurlingDarkness) then return end
    if player:TalentKnown(VoidEruption.id) then
        if player:BuffRemains(buffs.unfurlingDarkness) > VoidEruption:CastTime() + VoidEruption.cd then return end
    else
        if player:BuffRemains(buffs.unfurlingDarkness) > DarkAscension:CastTime() + DarkAscension.cd then return end
    end

    return spell:Cast(target)
end)

VoidTorrent:Callback("pvp", function(spell)
    local cooldowns = A.GetToggle(2, "cooldownSelect")
    if not shouldBurst() and cooldowns[3] then return end
    if player.moving and not player:TalentKnown(DarkEnergy.id) then return end

    if player:TalentKnown(VoidEruption.id) and VoidEruption.cd < 20000 then return end
    if player:TalentKnown(DarkAscension.id) and DarkAscension.cd < 20000 then return end

    if Fade.cd < 500 then --player:AttackersV69() >= 1
        if AngelicFeather.frac >= 1 and not player:Buff(buffs.angelicFeather) then
            return AngelicFeather:Cast()
        end
        return Fade:Cast()
    end

    return spell:Cast(target)
end)

DevouringPlague:Callback("go", function(spell)
    if gs.insanity < spell:Cost() then return end
    if VoidEruption.cd < 10000 then
        if gs.insanityDeficit < 16 then return end
    end

    return spell:Cast(target)
end)

DevouringPlague:Callback("slow", function(spell)
    if gs.insanity < spell:Cost() then return end
    if gs.insanityDeficit < 16 then return end

    return spell:Cast(target)
end)

MindBlast:Callback("pvp", function(spell)
    if gs.imCasting and gs.imCasting == spell.id and spell.frac < 1.9 then return end

    return spell:Cast(target)
end)

local function go()
    VoidBolt("main2")
    Mindbender("pvp")
    Voidwraith("main")
    PowerInfusion()
    VoidEruption("pvp")
    DarkAscension("pvp")
    VampiricTouch("unfurl")
    VoidTorrent("pvp")
    Psyfiend()
    DevouringPlague("go")
end

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Shadow Crash In Flight: ", gs.scInFlight)
        MakPrint(2, "Holding Shadow Crash: ", gs.holdingCrash)
        MakPrint(3, "Should AoE: ", gs.shouldAoE)
        MakPrint(4, "VT Refreshable: ", gs.vtRefreshable)
        MakPrint(5, "VT Count: ", gs.vtCount)
        MakPrint(6, "enemies TTD > 18: ", gs.activeEnemiesTTD)
        MakPrint(7, "Should Burst: ", gs.burstTTD)
        MakPrint(8, "Mind Blast charges: ", MindBlast.frac)
        MakPrint(9, "Voidwraith Known: ", player:TalentKnown(VoidwraithTalent.id))
        MakPrint(10, "Vampiric Touch Last Used: ", VampiricTouch.used)
        MakPrint(11, "Vampiric Touch Last Attempted: ", VampiricTouch.lastAttempt)
        MakPrint(12, "Hero Tree - Archon: ", gs.isArchon)
        MakPrint(13, "Hero Tree - Voidweaver: ", gs.isVoidweaver)
    end


    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then -- Set focus reminder
        if ActionUnit("player"):InParty() and not focus.exists and A.TwinsOfTheSunPriestess:IsTalentLearned() then
            Aware:displayMessage("SET FOCUS TARGET FOR POWER INFUSION", "Red", 1)
        end
    end

    if awareAlert[2] then -- Shadow Crash ready
        if ((player:TalentKnown(ShadowCrash.id) and ShadowCrash.cd < 700) or (player:TalentKnown(ShadowCrashOther.id) and ShadowCrashOther.cd < 700 and A.ShadowCrashOther:IsBlocked())) and player.inCombat then
            Aware:displayMessage("SHADOW CRASH READY", "Purple", 1)
        end
    end

    local channeling = player.channelInfo

    if awareAlert[3] then -- Void Torrent soon
        if player.channeling and channeling.name == VoidTorrent.wowName and not player:TalentKnown(DarkEnergy.id) then
            Aware:displayMessage("VOID TORRENT! STAND STILL", "WHITE", 1)
        end
    end

    if player.channeling and (channeling.name == VoidTorrent.wowName or channeling.name == MindFlayInsanity.wowName) then return end

    PowerWordFortitude()
    Shadowform()
    Fade()
    DesperatePrayer()
    Dispersion()
    VampiricEmbrace()
    FlashHeal("pve")
    FlashHeal("target")
    PowerWordShield("pve")

    makInterrupt(interrupts)

	if target.exists and target.canAttack and ShadowWordPain:InRange(target) then
        if A.Zone == "arena" or A.Zone == "pvp" or A.IsInPvP then
            Fade("avoid_damage")
            ShadowWordDeath("avoid_cc")
            PsychicScream("pvp")
            ShadowWordPain("catharsis")
            VampiricTouch("pvp_targ")
            ShadowCrashOther("pvp_targ")
            if shouldBurst() then
                go()
            end
            empFiller()
            DevouringPlague("slow")
            MindBlast("pvp")
            MindSpike("filler")
            MindFlay("filler")
        else
            DispelMagic("pve")

            if not player.inCombat then
                precombat()
            end

            if gs.shouldAoE then
                aoe()
            end
            main()
        end
    end

	return FrameworkEnd()
end

PurifyDisease:Callback("pve", function(spell, friendly) 
    local shouldDispel = friendly.diseased

    if not shouldDispel then return end

    return Debounce("cleanse", 350, 1500, spell, friendly)
end)

VoidShift:Callback("save_self", function(spell, friendly)
    if friendly:IsUnit(player) then return end
    
    if player.hp > 25 then return end

    if not spell:InRange(friendly) then return end
    if friendly.hp < 50 then return end

    return Debounce("shift_self", 300, 1000, spell, friendly)
end)

VoidShift:Callback("save_others", function(spell, friendly)
    if friendly:IsUnit(player) then return end

    if player.hp < 50 then return end

    if not spell:InRange(friendly) then return end
    if friendly.hp > 25 then return end

    return Debounce("shift_other", 300, 1000, spell, friendly)
end)

local friendlyRotation = function(friendly)
	if not friendly.exists then return end
    VoidShift("save_self", friendly)
    VoidShift("save_others", friendly)
    PurifyDisease("pve", friendly)
end


Silence:Callback("pvp", function(spell, enemy)
    if target.hp > 40 then
        if player:TalentKnown(VoidEruption.id) and VoidEruption.cd < 30000 or DarkAscension.cd < 30000 then return end
    end

    if enemyHealer.exists and enemyHealer.hp > 0 then
        if enemyHealer.silenceDr < 1 then return end
        if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

        if enemy:IsUnit(enemyHealer) then
            return spell:Cast(enemy)
        end
    end

    if not enemyHealer.exists or enemyHealer.dead then
        if enemy.silenceDr < 1 then return end
        if enemy.cc and enemy:CCRemains() > 400 then return end

        if enemy.pvpKick then
            return spell:Cast(enemy)
        end
    end
end)

PsychicHorror:Callback("pvp", function(spell, enemy)
    if target.hp > 40 then
        if player:TalentKnown(VoidEruption.id) and VoidEruption.cd < 30000 or DarkAscension.cd < 30000 then return end
    end

    if enemyHealer.exists and enemyHealer.hp > 0 then
        if enemyHealer.stunDr < 0.5 then return end
        if enemyHealer.ccImmune then return end
        if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

        if enemy:IsUnit(enemyHealer) then
            return spell:Cast(enemy)
        end
    end

    if not enemyHealer.exists or enemyHealer.dead then
        if enemy.stunDr < 0.5 then return end
        if enemy.cc and enemy:CCRemains() > 400 then return end
        if enemy.ccImmune then return end

        if enemy.pvpKick or enemy.cds and not enemy:IsUnit(target) then
            return spell:Cast(enemy)
        end
    end
end)

ShadowCrashOther:Callback("pvp", function(spell, enemy, icon)
    local icon = icon or Levitate
    if not enemy.exists then return end
    if not spell:InRange(enemy) then return end

    if enemy:IsUnit(target) then return end

    if not target:Debuff(debuffs.vampiricTouch, true) then
        if gs.imCasting and gs.imCasting ~= VampiricTouch.id or not gs.imCasting then return end
    end

    if enemy:DebuffRemains(debuffs.vampiricTouch, true) > 4000 then return end

    local delay = math.random(100, 300)
    local reset = math.random(400, 600)

    return Debounce("sc_pvp", delay, reset, spell, enemy, icon)
end)

VampiricTouch:Callback("pvp", function(spell, enemy, icon)
    local icon = icon or ShadowWordPain
    if not enemy.exists then return end
    if not spell:InRange(enemy) then return end

    if player:BuffRemains(buffs.unfurlingDarkness) > 2000 and player:TalentKnown(VoidEruption.id) and VoidEruption.cd < 3000 then return end

    if target.exists then -- let's try letting A[3] handle target, applying on target at top prio
        if enemy:IsUnit(target) then return end
        if not target:Debuff(debuffs.vampiricTouch, true) then
            if gs.imCasting and gs.imCasting ~= VampiricTouch.id or not gs.imCasting or not gs.scInFlight then return end
        end
    end

    if enemy:DebuffRemains(debuffs.vampiricTouch, true) > 4000 then return end
    if gs.scInFlight then return end

    --my attempt at staggering each VT, I think this should work independently for each enemy unit
    local delay = math.random(100, 300)
    local reset = math.random(400, 600)

    return Debounce("vt_pvp", delay, reset, spell, enemy, icon)
end)

ShadowWordDeath:Callback("pvp", function(spell, enemy)
    if not enemy.exists then return end
    if not spell:InRange(enemy) then return end

    if enemy.hp > 20 then return end

    return Debounce("swd_pvp", 600, 1100, spell, enemy)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    Silence("pvp", enemy)
    PsychicHorror("pvp", enemy)
    ShadowWordDeath("pvp", enemy)
    ShadowCrashOther("pvp", enemy)
    VampiricTouch("pvp", enemy)
end

A[6] = function(icon)
	RegisterIcon(icon)
	enemyRotation(arena1)
    friendlyRotation(party1)
    if autoTarget() then return TabTarget() end
    if targetForInterrupt(interrupts) then return TabTarget() end
	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)
	enemyRotation(arena2)
    friendlyRotation(party2)

	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)
	enemyRotation(arena3)
    friendlyRotation(party3)

	return FrameworkEnd()
end

A[9] = function(icon)
	RegisterIcon(icon)
    friendlyRotation(party4)

	return FrameworkEnd()
end

A[10] = function(icon)
	RegisterIcon(icon)
    friendlyRotation(player)

	return FrameworkEnd()
end
