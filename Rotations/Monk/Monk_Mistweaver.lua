if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 270 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local AtoL             = MakuluFramework.AtoL
local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Debounce         = MakuluFramework.debounceSpell
local DebounceFunc     = MakuluFramework.debounce
local ConstSpells      = MakuluFramework.constantSpells
local boss             = MakuluFramework.Boss
local inc              = MakuluFramework.incSpell
local as               = MakuluFramework.ArenaState

local constCell        = cacheContext:getConstCacheCell()
local frameCell        = cacheContext:getCell()
local combatCell       = cacheContext:getCombatCacheCell()
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit             = Action.Unit
local MultiUnits       = Action.MultiUnits

local HealingEngine    = Action.HealingEngine
local BossMods         = Action.BossMods

local GetSpellTexture = C_Spell.GetSpellTexture

local _G, setmetatable             = _G, setmetatable

C_Timer.After(8, function()
    print(" " .. MakuluFramework.Chat.SpecDraw(270, 20) .. MakuluFramework.Chat.colour.class.monk .. " - Makulu MW loaded")
    print(" " .. MakuluFramework.Chat.SpellDraw(115151, 20) .. MakuluFramework.Chat.colour.class.monk .. " - We mist you")
end)

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
    AntiFakeKick           = { Type = "SpellSingleColor", ID = 116705, Hidden = true, Color = "RED", Desc = "[2] AntiFakeKick", QueueForbidden = true },
    AntiFakeCC             = { Type = "SpellSingleColor", ID = 115078, Hidden = true, Color = "RED", Desc = "[1] AntiFakeCC", QueueForbidden = true },
    
    JadefireStomp            = { Type = "Spell", ID = 388193, MAKULU_INFO = { damageType = "magic", targeted = false }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm]spell:thisID" },

    AlphaTiger              = { Type = "Spell", ID = 287503, Hidden = true },
    RecentlyChallenged      = { Type = "Spell", ID = 290512, Hidden = true },
    AncientTeachings        = { Type = "Spell", ID = 388026, Hidden = true },
    TeachingsOfTheMonastery = { Type = "Spell", ID = 202090, Hidden = true },
    VaviciousVificationBuff = { Type = "Spell", ID = 392883, Hidden = true },
    VaviciousVification     = { Type = "Spell", ID = 388812, Hidden = true },
    MistsOfLife             = { Type = "Spell", ID = 388548, Hidden = true },
    ChiHarmony              = { Type = "Spell", ID = 448392, Hidden = true },

    ZenSpheresTalent        = { Type = "Spell", ID = 410777, Hidden = true },
    SphereHelp              = { Type = "Spell", ID = 410777, Desc = "Zen Spheres (Help)", MAKULU_INFO = { heal = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    SphereHarm              = { Type = "Spell", ID = 410777, Desc = "Zen Spheres (Harm)", Texture = 274738, Hidden = true, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm]spell:thisID" },
    ZenSpheres              = { Type = "Spell", ID = 410777, Desc = "Zen Spheres (Hybrid)", MAKULU_INFO = { heal = true, damageType = "magic" }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    ZenSpheresPvP           = { Type = "Spell", ID = 410777, Desc = "Zen Spheres (PvP Harm)", MAKULU_INFO = { heal = true, damageType = "magic" }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm]spell:thisID" },

    RisingSunKick           = { Type = "Spell", ID = 107428, FixedTexture = 642415, MAKULU_INFO = { damageType = "physical" } },
    RushingWindKick         = { Type = "Spell", ID = 467307, FixedTexture = 642415, MAKULU_INFO = { targeted = false } },
    BlackoutKick            = { Type = "Spell", ID = 100784, MAKULU_INFO = { damageType = "physical" } },
    TigerPalm               = { Type = "Spell", ID = 100780, MAKULU_INFO = { damageType = "physical" } },
    SpinningCraneKick       = { Type = "Spell", ID = 101546, MAKULU_INFO = { damageType = "physical", targeted = false } },
    TouchOfDeath            = { Type = "Spell", ID = 322109, MAKULU_INFO = { damageType = "physical", ignoreResource = true, offGcd = true, ignoreCasting = true } },
    Disable                 = { Type = "Spell", ID = 116095, MAKULU_INFO = { damageType = "physical" } },
    GrappleWeapon           = { Type = "Spell", ID = 233759, MAKULU_INFO = { damageType = "physical" } },
    SpearHandStrike         = { Type = "Spell", ID = 116705, MAKULU_INFO = { damageType = "physical", offGcd = true } },

    Prevoke                 = { Type = "Spell", ID = 115546 },
    Detox                   = { Type = "Spell", ID = 115450, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:115450" },
    LifeCocoon             = { Type = "Spell", ID = 116849, MAKULU_INFO = { heal = true, offGcd = true, ignoreCasting = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    Vivify                  = { Type = "Spell", ID = 116670, MAKULU_INFO = { heal = true, ignoreCasting = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    SoothingMist            = { Type = "Spell", ID = 115175, MAKULU_INFO = { heal = true, ignoreCasting = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    RenewingMist            = { Type = "Spell", ID = 115151, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:115151" },
    --RenewingMistP            = { Type = "Spell", ID = 115151, FixedTexture = 133667, MAKULU_INFO = { heal = true } },
    EnvelopingMist          = { Type = "Spell", ID = 124682, MAKULU_INFO = { heal = true, ignoreCasting = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    ExpelHarm               = { Type = "Spell", ID = 322101, MAKULU_INFO = { heal = true, targeted = false }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    HealingElixir           = { Type = "Spell", ID = 122281, MAKULU_INFO = { heal = true, offGcd = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    ThunderFocusTea         = { Type = "Spell", ID = 116680, MAKULU_INFO = { heal = true, offGcd = true, targeted = false }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    SheilunsGift            = { Type = "Spell", ID = 399491, MAKULU_INFO = { heal = true, ignoreCasting = true }, Macro = "/cast [@mouseover,help][@target,help][@focus,help]spell:thisID" },
    ZenPulse                = { Type = "Spell", ID = 446326, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    EssenceFont             = { Type = "Spell", ID = 191837, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    ManaTea                 = { Type = "Spell", ID = 115294,  MAKULU_INFO = { heal = true, targeted = false, dumbCast = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    CracklingJadeLightning  = { Type = "Spell", ID = 117952, MAKULU_INFO = { damageType = "magic" } },

    ChiWave                 = { Type = "Spell", ID = 115098, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    ChiBurst                = { Type = "Spell", ID = 123986, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    InvokeChiJi             = { Type = "Spell", ID = 325197, MAKULU_INFO = { heal = true, offGcd = true, targeted = false }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    InvokeChiJiBuff         = { Type = "Spell", ID = 343820 },
    InvokeYulon             = { Type = "Spell", ID = 322118, MAKULU_INFO = { heal = true, offGcd = true, targeted = false }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    CelestialConduit        = { Type = "Spell", ID = 443028, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    DiffuseMagic            = { Type = "Spell", ID = 122783 },

    FortifyingBrew          = { Type = "Spell", ID = 115203 },
    DampenHarm              = { Type = "Spell", ID = 122278 },
    Restoral                = { Type = "Spell", ID = 388615, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Revival                 = { Type = "Spell", ID = 115310, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Paralysis               = { Type = "Spell", ID = 115078 },

    TigersLust              = { Type = "Spell", ID = 116841 },
    LegSweep                = { Type = "Spell", ID = 119381 },
    SongofChiJi             = { Type = "Spell", ID = 198898 },
    RingOfPeace             = { Type = "Spell", ID = 116844 },
    ImprovedDispelTalent    = { Type = "Spell", ID = 388874, Hidden = true },
    JadeEmpowerment         = { Type = "Spell", ID = 467316, Hidden = true },
    RapidDiffusion          = { Type = "Spell", ID = 388847, Hidden = true },
    JadeSanctuary           = { Type = "Spell", ID = 443059, Hidden = true },
    AugustDynasty           = { Type = "Spell", ID = 442818, Hidden = true },
    SecretInfusion          = { Type = "Spell", ID = 388491, Hidden = true },
    AspectOfHarmony         = { Type = "Spell", ID = 450508, Hidden = true },
    JadefireTeachings       = { Type = "Spell", ID = 467293, Hidden = true },
    AwakenedJadefire        = { Type = "Spell", ID = 388779, Hidden = true },
    ShaohaosLessons         = { Type = "Spell", ID = 400089, Hidden = true },
    PeerIntoPeace           = { Type = "Spell", ID = 440008, Hidden = true },
    GiftOfTheCelestials     = { Type = "Spell", ID = 388212, Hidden = true },
    EmperorsFavor           = { Type = "Spell", ID = 471761, Hidden = true },
    LegacyOfWisdom          = { Type = "Spell", ID = 404408, Hidden = true },

    -- Season 3 Tier Set: Crash of Fallen Storms
    HeartOfJadeSerpent      = { Type = "Spell", ID = 443294, Hidden = true },
    PotentialEnergy         = { Type = "Spell", ID = 1239483, Hidden = true },
    HarmonicSurge           = { Type = "Spell", ID = 1239443, Hidden = true },
    JadeSerpentBlessing     = { Type = "Spell", ID = 1236382, Hidden = true }, -- 4-set haste buff
    CrashOfFallenStorms2Set = { Type = "Spell", ID = 1236381, Hidden = true }, -- Conduit 2-set
    CrashOfFallenStorms4Set = { Type = "Spell", ID = 1236382, Hidden = true }, -- Conduit 4-set
    HarmonyPotentialEnergy  = { Type = "Spell", ID = 1236377, Hidden = true }, -- Harmony 2-set
    HarmonyHarmonicSurge    = { Type = "Spell", ID = 1236378, Hidden = true }, -- Harmony 4-set

    ManaTeaBuff             = { Type = "Spell", ID = 115867, Hidden = true },
    Transcendence           = { Type = "Spell", ID = 101643 },
    TranscendenceTransfer   = { Type = "Spell", ID = 119996 },
    SummonWhiteTigerStatue  = { Type = "Spell", ID = 388686, Macro = "/cast [@player]spell:thisID" },
    SummonJadeSerpentStatue = { Type = "Spell", ID = 115313, Macro = "/cast [@player]spell:thisID" },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
-- Tell LSP that M contains Spell objects
---@cast M table<string, Spell>
-- Now use M.SpellName instead of just SpellName
-- The LSP will show documentation when you hover over M.Frostbolt:Cast()
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_MONK_MISTWEAVER] = A
TableToLocal(M, getfenv(1))
Aware:enable()
local presetValues = {
    mistweave = {
        fistweaving = false,
        pureFist = false,
        fistweaveStopHPpve = 80,
        fistweaveStopCdsHPpve = 90,
        fistweaveStopHPpvp = 70,
        fistweaveStopCdsHPpvp = 85,
    },
    fistweave = {
        fistweaving = true,
        pureFist = true,
        fistweaveStopHPpve = 55,
        fistweaveStopCdsHPpve = 70,
        fistweaveStopHPpvp = 60,
        fistweaveStopCdsHPpvp = 75,
    },
}

local presetFrame
local presetFrameVisible = nil

local function presetLabel(presetKey)
    if presetKey == "mistweave" then
        return "Mistweave"
    end
    return "Fistweave"
end

local function updatePresetFrameStatus()
    if not presetFrame or not presetFrame.status then return end
    local isFist = A.GetToggle(2, "fistweaving")
    local isPure = A.GetToggle(2, "pureFist")
    if isFist then
        presetFrame.status:SetText(isPure and "Fistweave: Pure" or "Fistweave: Hybrid")
    else
        presetFrame.status:SetText("Mistweave")
    end
end

local function applyPreset(presetKey)
    local preset = presetValues[presetKey]
    if not preset then return end

    local changed = false
    for key, value in pairs(preset) do
        if A.GetToggle(2, key) ~= value then
            A.SetToggle({ 2, key, nil, true }, value)
            changed = true
        end
    end

    if changed then
        A.Print(presetLabel(presetKey) .. " preset applied. Reopen /action to refresh values.")
    end

    updatePresetFrameStatus()
end

local function savePresetFramePosition(frame)
    if not MakuluFramework or not MakuluFramework.SavePersistentValue then return end
    local point, _, relativePoint, x, y = frame:GetPoint()
    MakuluFramework.SavePersistentValue("MWPresetFramePos", {
        point = point,
        relativePoint = relativePoint,
        x = x,
        y = y,
    })
end

local function restorePresetFramePosition(frame)
    if not MakuluFramework or not MakuluFramework.TryGetPersistValue then return end
    local saved = MakuluFramework.TryGetPersistValue("MWPresetFramePos")
    if not saved or not saved.point or not saved.x or not saved.y then return end

    frame:ClearAllPoints()
    frame:SetPoint(saved.point, UIParent, saved.relativePoint or saved.point, saved.x, saved.y)
end

local function createPresetFrame()
    if presetFrame then return end

    presetFrame = CreateFrame("Frame", "MakuluMWPresetFrame", UIParent, "BackdropTemplate")
    presetFrame:SetSize(210, 84)
    presetFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    presetFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    presetFrame:SetBackdropColor(0, 0, 0, 0.9)
    presetFrame:SetMovable(true)
    presetFrame:EnableMouse(true)
    presetFrame:SetClampedToScreen(true)

    presetFrame.title = presetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    presetFrame.title:SetPoint("TOP", presetFrame, "TOP", 0, -6)
    presetFrame.title:SetText("MW Presets")

    presetFrame.status = presetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    presetFrame.status:SetPoint("TOP", presetFrame.title, "BOTTOM", 0, -2)
    presetFrame.status:SetText("Mistweave")

    local mistButton = CreateFrame("Button", nil, presetFrame, "UIPanelButtonTemplate")
    mistButton:SetSize(90, 22)
    mistButton:SetPoint("BOTTOMLEFT", presetFrame, "BOTTOMLEFT", 12, 10)
    mistButton:SetText("Mistweave")
    mistButton:SetScript("OnClick", function()
        applyPreset("mistweave")
    end)

    local fistButton = CreateFrame("Button", nil, presetFrame, "UIPanelButtonTemplate")
    fistButton:SetSize(90, 22)
    fistButton:SetPoint("BOTTOMRIGHT", presetFrame, "BOTTOMRIGHT", -12, 10)
    fistButton:SetText("Fistweave")
    fistButton:SetScript("OnClick", function()
        applyPreset("fistweave")
    end)

    presetFrame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and IsShiftKeyDown() then
            self:StartMoving()
        end
    end)
    presetFrame:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        savePresetFramePosition(self)
    end)

    restorePresetFramePosition(presetFrame)
    presetFrame:Hide()
end

local function refreshPresetFrameVisibility()
    if not presetFrame then return end
    local shouldShow = A.GetToggle(2, "mwPresetFrame") and true or false

    if shouldShow then
        presetFrameVisible = true
        presetFrame:Show()
        updatePresetFrameStatus()
    else
        presetFrameVisible = false
        presetFrame:Hide()
    end
end

createPresetFrame()
if C_Timer and C_Timer.NewTicker then
    C_Timer.NewTicker(1, refreshPresetFrameVisibility)
    refreshPresetFrameVisibility()
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

local healTarget = nil

-- Development debug flag for testing Zen Spheres without PvP/combat restrictions
-- Set to true to allow casting on player at full health and on any valid target
-- Set to false for normal operation with all restrictions
local devDebug = false
-- Helper function to safely access unit properties
local function safeUnitAccess(unit, property, defaultValue)
    if not unit then return defaultValue end
    local success, result = pcall(function() return unit[property] end)
    return success and result or defaultValue
end

-- Helper function to ensure healTarget is never nil
local function ensureHealTarget()
    if not healTarget then
        calculateHealTarget()
    end
    if not healTarget then
        healTarget = ConstUnit.player
    end
    return healTarget
end

local gs = {}

local buffs = {
    harmonyActive = 450711,
    renewingMist = 119611,
    soothingTotem = 198533,
    soothingMist = 115175,
    envelopingMist = 124682,
    chiJiEnvelop = 343820,
    thunderFocusTea = 116680,
    vificiation = 392883,
    topEnvelop = 393988,
    sphereOfHope = 411036,
    sphereOfDispear = 411038,
    rushingWinds = 467431,
    manaTea = 115867,
    topRSK = 388525,
    topExpel = 388524,
    vivaciousVivication = 392883,
    craneBuff = 343820,
    teachingsOfTheMonastery = 202090,
    jadeEmpowerment = 467317,
    chiHarmony = 423439,
    augustDynasty = 442850,
    jadefireStomp = 388193,
    jadefireTeachings = 388026,
    awakenedJadefire = 389387,
    invokeYulon = 389422,
    aspectOfHarmony = 450531,
    statueSooM = 198533,
    drainingVitality = 450711,
    strengthOfTheBlackOx = 443112,
    zenPulse = 446334,
    secretInfusionHaste = 388497,
    secretInfusionVers = 388500,
    
    -- Season 3 Tier Set Buffs
    heartOfJadeSerpent = 443294,
    potentialEnergy = 1239483,
    harmonicSurge = 1239443,
    jadeSerpentBlessing = 1236382, -- 4-set haste buff  
}

local debuffs = {
    mysticTouch = 8647,
}

local interrupts = {
    { spell = SpearHandStrike },
    { spell = LegSweep, isCC = true, aoe = true, distance = 3 },
    { spell = Paralysis, isCC = true },
}

local counterMagicDispelList = AtoL({
    "Flame Shock",
    "Moonfire",
    "Sunfire",
    "Vampiric Touch",
    "Agony",
    "Corruption",
})

local ccDispelList = AtoL({
    "Sleep Walk",
    390612, --frost bomb
    "Frost Bomb",
    "Fear",
    "Psychic Horror",
    "Psychic Scream",
    "Freezing Trap",
    "Hammer of Justice",
    "Repentance",
    "Polymorph",
    "Chaos Nova",
    "Frost Nove",
    "Havoc",
    "Soul Rot",
    "Landslide",
    "Entangling Roots",
    "Frost Nova",
    "Absolute Zero",
    "Dread of Winter",
    "Silence",
    "Entangling Roots",
    "Sphere of Despair",
    "Earthgrab",
    "Landslide",
    "Dragon's Breath",
    "Absoulute Zero",
    "Dead of Winter",
    "Strangulate",
    "Searing Glare",
})

local function calculateHealTarget()
    -- Safely determine heal target with comprehensive nil checks
    if target and target.exists and target.isFriendly then
        healTarget = target
    elseif focus and focus.exists and focus.isFriendly then
        healTarget = focus
    elseif player then
        healTarget = player
    else
        -- Fallback to ensure healTarget is never nil
        healTarget = ConstUnit.player
    end

    -- Additional safety check
    if not healTarget then
        healTarget = ConstUnit.player
    end
end

local function instaCastStuff()
    local castInfo = player.castOrChannelInfo
    if castInfo then
        return castInfo.spellId == SoothingMist.id
    end

    return player:Buff(buffs.thunderFocusTea)
end

local function rwkTFT()
    return player:Buff(buffs.thunderFocusTea) or player:Buff(buffs.topRSK)
end

local aspectOfHarmonyBuffs = {
    [450521] = true,
    [450526] = true,
    [450531] = true
}

local function aspectOfHarmonyPercent()
    return constCell:GetOrSet("aspectHarmonyPercent", function()
        local foundAspect = player:BuffFrom(aspectOfHarmonyBuffs, true)
        if not foundAspect or not foundAspect.idx then return 0 end

        -- Safely get tooltip information with comprehensive nil checks
        local success, res = pcall(C_TooltipInfo.GetUnitAura, player.id, foundAspect.idx, foundAspect.filter)
        if not success or not res then return 0 end

        -- Check if tooltip structure exists
        if not res.lines or not res.lines[2] or not res.lines[2].leftText then
            return 0
        end

        local harmonyAmount = res.lines[2].leftText
        if not harmonyAmount or harmonyAmount == "" then return 0 end

        local attempt = select(2, strsplit(" ", harmonyAmount))
        if not attempt then return 0 end

        local actualNumber = tonumber(attempt)
        if not actualNumber then
            -- Removed debug print to prevent chat spam
            return 0
        end

        -- Ensure player.maxHealth exists and is not zero
        if not player.maxHealth or player.maxHealth == 0 then return 0 end

        return (actualNumber / player.maxHealth) * 100
    end)
end

local function cdsLessThan(lessThan)
    if as.enemyCdRemains <= 0 then return false end

    return as.enemyCdRemains <= lessThan
end

local arenaKicks = MakLists.arenaKicks

local kickPercent = 32
local meldDuration = 0.9
local shortHalfSecond = 620
local channelKickTime = 400
local quickKick = 15
local cdDelay = 100
local prepDelay = 1000

local function generateNewRandomKicks()
    kickPercent = math.random(40, 90)
    meldDuration = math.random(600, 1200) / 1000
    shortHalfSecond = math.random(400, 800)
    channelKickTime = math.random(300, 800)
    quickKick = math.random(10, 20)
    cdDelay = math.random(600,2500)
    prepDelay = math.random(500, 1500)

    return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if CracklingJadeLightning:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function enemiesInMelee()
    local cacheKey = "enemiesInMelee"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if TigerPalm:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    count = count + 1
                end
            end
        end
        
        return count
    end)
end

local function useDefensive()
    return incBigDmgIn() <= 2000 or incModDmgIn() <= 2000
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength

    return currentCast, currentCastName, remains, length
end

local function dmgSoon()
    return constCell:GetOrSet("dmg_soon", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            local casting = enemy.castOrChannelInfo
            if casting and casting.spellId then
                local spellId = casting.spellId
                if MakLists.incomingAoE[spellId] then
                    if casting.channel then
                        return 99999
                    else
                        return casting.remaining
                    end
                end
            end
        end
        return 99999
    end)
end

local playerSpellTargets = {}

local function chiHarmonyRemains(unit)
    local found = unit:HasBuffFor(buffs.renewingMist, true)
    if found == 0 then return 0 end
    if found > 8000 then return 0 end

    local remains = unit:BuffRemains(buffs.renewingMist, true)
    if remains < 8000 then return remains end

    return 8000 - found
end

local function hasChiHarmony(unit)
  return chiHarmonyRemains(unit) > 0
end

local function on_unit_spellcast_sent(event, unit, targetUnit, castGUID, spellID)
    if unit == "player" then
        playerSpellTargets[spellID] = targetUnit
    end
end
MakuluFramework.Events.register("UNIT_SPELLCAST_SENT", on_unit_spellcast_sent)

local cocoonUsageInfo = {
    lastUsed = 0,
    target = nil,
}

local function cocoonInFlight(target)
    if not A.LifeCocoon:IsSpellInFlight() then return false end
    if cocoonUsageInfo.target ~= target.guid then return false end
    
    return (GetTime() * 1000) - cocoonUsageInfo.lastUsed < 1000
end

local function on_unit_spellcast_success(event, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool =
        CombatLogGetCurrentEventInfo()

    if subevent ~= "SPELL_CAST_SUCCESS" then return end
    if sourceGUID ~= player.guid then return end
    if spellID ~= LifeCocoon.id then return end

    cocoonUsageInfo.lastUsed = GetTime() * 1000
    cocoonUsageInfo.target = destGUID
end
MakuluFramework.Events.register("COMBAT_LOG_EVENT_UNFILTERED", on_unit_spellcast_success)

local function spellTarget(spellId)
    return playerSpellTargets[spellId]
end

local function cjlHealAmount()
    local thresholds = {
        [5] = {0, 65},
        [4] = {20, 70},
        [3] = {50, 75},
        [2] = {70, 90},
        [1] = {70, 90},
        [0] = {70, 90}
    }

    local result = thresholds[math.min(gs.activeEnemies, 5)] or {85, 90}
    return result[1], result[2]
end

local function chiHarmonyRamp()
    return incBigDmgIn() <= 4000
end

local function cdUsed()
    local spells = {
        InvokeChiJi,
        InvokeYulon,
        CelestialConduit,
        Revival,
        Restoral
    }

    local lastUsed = 99999

    if gs.imCasting and (gs.imCasting == SheilunsGift.id or gs.imCasting == CelestialConduit.id) and not gs.raid then
        return 0
    end

    for _, spell in ipairs(spells) do
        if player:TalentKnown(spell.id) and spell.used and spell.used >= 0 then
            lastUsed = math.min(lastUsed, spell.used)
        end
    end

    if not gs.raid and SheilunsGift.used < lastUsed then
        lastUsed = SheilunsGift.used
    end

    return lastUsed
end

local function useSheilun(unit)
    if not unit then return end
    if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then return end

    if SheilunsGift.count < 8 then return end

    if player:TalentKnown(EmperorsFavor.id) then
        if unit.ehp < 50 then
            return true
        end
    end

    local below80 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 80 end)
    
    if not gs.raid then
        if below80 >= 3 and not player:TalentKnown(EmperorsFavor.id) then
            return true
        end
    else
        if below80 >= 3 + (2 * player:TalentKnownInt(LegacyOfWisdom.id)) then
            return true
        end
    end

    return false
end

                                                                                                                                                                                                                local statueNames = statueNames or {
                                                                                                                                                                                                                    ["Jade Serpent Statue"] = true,
                                                                                                                                                                                                                    ["Statue der Jadeschlange"] = true,
                                                                                                                                                                                                                    ["Estatua del Dragón de Jade"] = true,
                                                                                                                                                                                                                    ["Statue du Serpent de jade"] = true,
                                                                                                                                                                                                                    ["Statua della Serpe di Giada"] = true,
                                                                                                                                                                                                                    ["Estátua de Serpente de Jade"] = true,
                                                                                                                                                                                                                    ["Статуя Нефритовой Змеи"] = true,
                                                                                                                                                                                                                    ["옥룡 조각상"] = true,
                                                                                                                                                                                                                    ["青龙雕像"] = true
                                                                                                                                                                                                                }

local function statueActive()
    for i = 1, MAX_TOTEMS do
        local _, name, startTime = GetTotemInfo(i)
        if startTime > 0 and statueNames[name] then
            return true
        end
    end
    return false
end

local function stickSooM(unit)
    local currentSooM  = MakMulti.party:Find(function(friendly) return friendly:Buff(buffs.soothingMist, true) end)

    if currentSooM then
        if not UnitIsUnit(unit:CallerId(), currentSooM:CallerId()) then
            HealingEngine.SetTarget(currentSooM:CallerId(), 1)
        end
    end
end

local function useSooM(unit)
    if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then return false end

    if unit.ehp < A.GetToggle(2, "soomHP") then
        return true
    end
end

local function cancelSooM()
    if player:TalentKnown(PeerIntoPeace.id) then return false end
    
    local channel = player.channelInfo
    if not channel then return false end
    if channel and channel.spellId ~= SoothingMist.id then return false end
    if target.isFriendly then return false end -- allow manual override with hard target

    local lowestUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and friendly.hp > 0 end
    )

    local soomUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and friendly:Buff(buffs.soothingMist, true) end
    )

    return soomUnit and ((soomUnit.ehp >= lowestUnit.ehp + 40) or (soomUnit.ehp >= 80 and gs.enemiesInMelee >= 1) or soomUnit.ehp >= 100) or false
end

                                                                                                                                                                                                                    local function shouldYulon()
                                                                                                                                                                                                                        if not gs.raid then return false end
                                                                                                                                                                                                                        if not boss then return false end
                                                                                                                                                                                                                        if not player.combat then return false end

                                                                                                                                                                                                                        if boss.vexie() then
                                                                                                                                                                                                                            if makRamp({465865}) < 2000 then -- Exhaust Fumes (tracker is for Tank Buster but happens at same time every time)
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                            if inc.mechanicalBreakdown or makRamp({460116}) < 2000 then -- Tune-Up
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.cauldron() then
                                                                                                                                                                                                                            local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
                                                                                                                                                                                                                            if currentCombatTime > 20000 and makRamp({473650}) < 6000 then -- Scrapbomb (from second phase onward)
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                            if inc.colossalClash < 60000 then
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.rik() then
                                                                                                                                                                                                                            local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
                                                                                                                                                                                                                            if currentCombatTime > 60000 and makRamp({466866}) < 3000 then -- Echoing Chant
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.stix() then
                                                                                                                                                                                                                            if makRamp({464399}) < 1000 then -- Electromagnetic Sorting
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.lockenstock() then
                                                                                                                                                                                                                            if makRamp({465232}) < 2000 then -- Sonic Ba-Boom (AKA Activate Inventions)
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                            if inc.betaLaunch or inc.bleedingEdge then
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.bandit() then
                                                                                                                                                                                                                            local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
                                                                                                                                                                                                                            if currentCombatTime > 30000 and makRamp({469993}) < 5000 then -- Foul Exhaust
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.mugzee() then
                                                                                                                                                                                                                            if player.combat then
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        if boss.gallywix() then
                                                                                                                                                                                                                            if makRamp({466340}) < 3000 then -- Scatterblast Canisters
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                            if makRamp({469286}) < 3000 then -- Giga Coils
                                                                                                                                                                                                                                return true
                                                                                                                                                                                                                            end
                                                                                                                                                                                                                        end

                                                                                                                                                                                                                        return false
                                                                                                                                                                                                                    end


local function useChiji()
    if gs.cdUsed < 4000 then return end

    if SheilunsGift.count >= 8 and not player.moving then return false end

    local below80 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 80 end)
    local below60 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 60 end)
    local below50 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 50 and not friendly:Buff(buffs.lifeCocoon) end)

    if not gs.raid then
        if below80 >= 3 or below60 >= 2 or (below50 >= 1 and LifeCocoon.cd > 400) or dmgSoon() < 1500 then
            return true
        end
    end

    if gs.raid then
        if dmgSoon() < 1500 + (player:TalentKnownInt(ShaohaosLessons.id) * SheilunsGift:CastTime()) + (A.GetGCD() * 2000) then
            return true
        end

        if shouldYulon() then
            return true
        end
    end
end

local function useCelestialConduit()
    local groupSize = MakMulti.party:Size()
    if groupSize > 5 and boss then return false end
    if gs.cdUsed < 4000 then return end

    if gs.summonActive then return false end

    local boss1 = MakUnit:new("boss1")
    if boss then
        if boss.izo() then
            local cast = boss1.castOrChannelInfo
            local splice = 439341
            if cast and cast.spellId == splice and cast.elapsed > 500 then
                return true
            end
        end
    end

    local below70 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 70 end)
    local below60 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 60 end)
    local below40 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 40 and not friendly:Buff(buffs.lifeCocoon) end)

    if below70 >= 3 or below60 >= 2 or (below40 >= 1 and LifeCocoon.cd > 400) then
        return true
    end
end

local function useRevival()
    local groupSize = MakMulti.party:Size()
    if groupSize > 5 and boss then return false end

    if gs.cdUsed < 4000 then return end

    local below50 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 50 end)
    local below40 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 40 end)

    if not gs.summonActive then
        if below50 >= 3 or below40 >= 2 then
            return true
        end
    end
end

local function useAugustCombo()
    --[[local below60 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 60 end)

    if below60 >= 3 then
        return true
    end]]

    if A.GetToggle(2, "augustCombo") and JadefireStomp.used > 8500 then return true end
end

local function useCocoon(unit)
    local cocoonMode = A.GetToggle(2, "cocoonMode")

    if unit.totalImmune then return false end

    if cocoonMode == 1 then -- HP
        if unit.isTank then
            if unit.hp > 0 and unit.hp < A.GetToggle(2, "lifeCocoonHPtank") then
                return true
            end
        else
            if unit.hp > 0 and unit.hp < A.GetToggle(2, "lifeCocoonHPother") then
                return true
            end
        end
    elseif cocoonMode == 2 then --TTD
        if unit.isTank then
            if unit.ttd > 0 and unit.ttd < A.GetToggle(2, "lifeCocoonTTDtank") * 1000 then
                return true
            end
        else
            if unit.ttd > 0 and unit.ttd < A.GetToggle(2, "lifeCocoonTTDall") * 1000 then
                return true
            end
        end
    end
end

local function autoTarget()
    if not player.inCombat then return false end
    if A.IsInPvP then return false end

    if gs.orbsActive then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if TigerPalm:InRange(target) and target.exists then return false end

    if gs.enemiesInMelee > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

                                                                                                                                 

-- Season 3: Cached tier set and healing calculations with error handling
-- local function getTierSetStatus()
--     return combatCell:GetOrSet("tierSetStatus", function()
--         local has2Set, has4Set = false, false

--         -- Safely check for tier set bonuses
--         local success, result = pcall(function()
--             -- Season 3 "Crash of Fallen Storms" tier set item IDs
--             local tierSetItems = {
--                 237673, -- Half-Mask of Fallen Storms (Head)
--                 237671, -- Glyphs of Fallen Storms (Shoulder)
--                 237676, -- Gi of Fallen Storms (Chest)
--                 237674, -- Grasp of Fallen Storms (Hands)
--                 237672  -- Legwraps of Fallen Storms (Legs)
--             }

--             local equippedCount = 0
--             for _, itemId in ipairs(tierSetItems) do
--                 if GetItemCount and GetItemCount(itemId, false, true) > 0 then
--                     equippedCount = equippedCount + 1
--                 end
--             end

--             return {
--                 has2Set = equippedCount >= 2,
--                 has4Set = equippedCount >= 4
--             }
--         end)

--         if success and result then
--             has2Set = result.has2Set
--             has4Set = result.has4Set
--         end

--         -- Safely get buff information with error handling
--         local heartOfJadeActive, heartOfJadeRemains, potentialEnergyStacks, jadeSerpentBlessingActive = false, 0, 0, false

--         pcall(function()
--             heartOfJadeActive = player:Buff(buffs.heartOfJadeSerpent) or false
--             heartOfJadeRemains = player:BuffRemains(buffs.heartOfJadeSerpent) or 0
--             potentialEnergyStacks = player:HasBuffCount(buffs.potentialEnergy) or 0
--             jadeSerpentBlessingActive = player:Buff(buffs.jadeSerpentBlessing) or false
--         end)

--         return {
--             has2Set = has2Set,
--             has4Set = has4Set,
--             heartOfJadeActive = heartOfJadeActive,
--             heartOfJadeRemains = heartOfJadeRemains,
--             potentialEnergyStacks = potentialEnergyStacks,
--             jadeSerpentBlessingActive = jadeSerpentBlessingActive
--         }
--     end)
-- end

-- MakMulti.party:Lowest(function(unit) return unit.ehp end, function(unit) return unit.hp > 0 and not unit.dead and Vivify:InRange(unit) end)
local function getOptimalHealingTarget()
    return frameCell:GetOrSet("optimalHealingTarget", function()
        local lowestUnit = MakMulti.party:Lowest(
            function(unit) return unit.ehp end,
            function(unit) return unit.hp > 0 and not unit.dead and Vivify:InRange(unit) end
        )
        return lowestUnit or healTarget or player
    end)
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

    gs.activeEnemies = enemiesInRange()
    gs.enemiesInMelee = enemiesInMelee()
    gs.cdUsed = cdUsed()

    -- unit:SetPieces() - Get number of equipped tier set items
    gs.has2SetBonus = player:Has2Set() -- Check if unit has 2-piece tier set bonus
    gs.has4SetBonus = player:Has4Set() -- Check if unit has 4-piece tier set bonus
    
    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    gs.dungeon = instanceType == "party"
    gs.raid = instanceType == "raid"

    gs.masterOfHarmony = player:TalentKnown(AspectOfHarmony.id) -- Check if unit has Aspect of Harmony talent
    gs.conduitOfCelestials = not gs.masterOfHarmony -- Opposite hero talent tree

    -- Playstyle Detection and Toggle
    gs.fistweaving = A.GetToggle(2, "fistweaving") or false
    gs.shouldFistweave = gs.fistweaving and (gs.masterOfHarmony or player:TalentKnown(AncientTeachings.id))

    local summonDuration = 25000 - (13000 * player:TalentKnownInt(GiftOfTheCelestials.id))
    gs.summonActive = InvokeYulon.used < summonDuration or InvokeChiJi.used < summonDuration
    
    gs.teamCds = A.IsInPvP and MakMulti.party:Any(function(party)
        return not party.isHealer and not party.cc and party.cds and not party:DamageLocked()
    end)

    gs.actualLowest = (A.IsInPvP and MakMulti.party:Lowest(function(party)
        return (party.dead and 100) or party.ehp
    end)) or healTarget

    gs.hurtWithReM = MakMulti.party:Count(function(friendly) return friendly:Buff(buffs.renewingMist, true) and friendly.ehp < A.GetToggle(2, "vivifyHP") end)
end

local function shouldFistweaveHybrid()
    if not gs.shouldFistweave then return false end
    if not target.exists or not target.canAttack then return false end
    if target.totalImmune or target.magicImmune then return false end
    if not TigerPalm:InRange(target) then return false end

    local lowest = gs.actualLowest or healTarget
    if not lowest then return false end

    local stopHpKey = A.IsInPvP and "fistweaveStopHPpvp" or "fistweaveStopHPpve"
    local stopCdsHpKey = A.IsInPvP and "fistweaveStopCdsHPpvp" or "fistweaveStopCdsHPpve"
    local stopHp = A.GetToggle(2, stopHpKey)
    local stopCdsHp = A.GetToggle(2, stopCdsHpKey)
    if stopHp == nil then
        stopHp = A.GetToggle(2, "fistweaveStopHP")
    end
    if stopCdsHp == nil then
        stopCdsHp = A.GetToggle(2, "fistweaveStopCdsHP")
    end
    stopHp = stopHp or 0
    stopCdsHp = stopCdsHp or stopHp

    if lowest.ehp <= stopHp then return false end
    if as.enemyCds and lowest.ehp <= stopCdsHp then return false end

    return true
end

-------------------------------------------------------------------
---Defensives------------------------------------------------------
-------------------------------------------------------------------

ExpelHarm:Callback("def", function(spell)
    if not player.inCombat then return end
    if player:BuffFrom(MakLists.Defensive) then return end
    if UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.3 then return end

    if useDefensive() and player:Buff(buffs.thunderFocusTea) then
        return spell:Cast() -- M.ExpelHarm:Cast() is also valid
    end
end)

FortifyingBrew:Callback(function(spell)
    if not player.inCombat then return end
    if player:BuffFrom(MakLists.Defensive) then return end
    if UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.3 then return end
    
    if useDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "fortifyingBrewHP") then
        return spell:Cast()
    end
end)

DiffuseMagic:Callback(function(spell)
    if not player.inCombat then return end
    if player:BuffFrom(MakLists.Defensive) then return end
    if UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.3 then return end

    local reflectDebuff = {
        469799, -- Overcharge
        1214523, -- Feasting Void
        428019, -- Flashpoint
        426295, -- Flaming Tether
        437956, -- Erupting Inferno
    }

    if player:DebuffFrom(reflectDebuff) then
        return spell:Cast()
    end

    if useDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "diffuseMagicHP") then
        return spell:Cast()
    end
end)

CelestialConduit:Callback("def", function(spell)
    if not player.inCombat then return end
    if not player:TalentKnown(JadeSanctuary.id) then return end
    if player:BuffFrom(MakLists.Defensive) then return end
    if UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.3 then return end

    if useDefensive() then
        return spell:Cast()
    end
end)

local function defensives()
    ExpelHarm("def")
    FortifyingBrew()
    DiffuseMagic()
    CelestialConduit("def")
end

-------------------------------------------------------------------
---Utility---------------------------------------------------------
-------------------------------------------------------------------

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    
    if player.bleeding then
        return spell:Cast()
    end

    local magicked  = MakMulti.party:Find(function(friendly) return (friendly.magicked or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Magic")) and Detox:InRange(friendly) and not friendly.isMe end)
    local diseased = MakMulti.party:Find(function(friendly) return (friendly.diseased or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Disease")) and Detox:InRange(friendly) and not friendly.isMe end)
    local poisoned  = MakMulti.party:Find(function(friendly) return (friendly.poisoned or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Poison")) and Detox:InRange(friendly) and not friendly.isMe end)

    if ((diseased or poisoned) and player:TalentKnown(ImprovedDispelTalent.id)) or magicked then
        if ((player.diseased or player.poisoned) and player:TalentKnown(ImprovedDispelTalent.id)) or player.magicked then
            return spell:Cast()
        end
    end
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    
    if not makBurst() then return end
    if not gs.summonActive then return end
    return spell:Cast()
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    
    if not makBurst() then return end
    if not gs.summonActive then return end
    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    
    if not makBurst() then return end
    if not gs.summonActive then return end
    return spell:Cast()
end)

TigersLust:Callback(function(spell, unit)
    if unit.hp < 40 then return end

    local imRooted = player.rooted
    local elseRooted  = MakMulti.party:Find(function(friendly) return TigersLust:InRange(friendly) and friendly:ClassID() ~= 2 and friendly:DebuffFrom(MakLists.pveFreedom) end) -- Exclude Paladin

    if imRooted then
        HealingEngine.SetTarget(player:CallerId(), 1)
        Debounce("tl", 1000, 2500, spell, unit)
    elseif elseRooted then
        HealingEngine.SetTarget(elseRooted:CallerId(), 1)
        Debounce("tl", 1000, 2500, spell, unit)
    end
end)

ManaTea:Callback(function(spell, unit)
    local pctRecovered = player:HasBuffCount(buffs.manaTea) * 2.5
    
    if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then return end

    if gs.raid then
        if player:Buff(buffs.invokeYulon) then return end
    end
    
    if unit.hp > 80 then
        if player.manaPct < 80 and pctRecovered > 10 then
            return spell:Cast()
        end
    end

    if player.manaPct < 10 and pctRecovered > 5 then
        return spell:Cast()
    end
end)

local function cancelManaTea()
    local channel = player.channelInfo
    if not channel then return false end
    if channel and channel.spellId ~= ManaTea.id then return false end

    if player.manaPct < 10 then return false end

    if player.manaPct >= 90 then
        return true
    end

    local lowestUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and friendly.hp > 0 end
    )
    if not gs.raid then
        if lowestUnit.ehp < 75 then
            return true
        end
    else
        if lowestUnit.ehp < 45 then
            return true
        end
    end
    return false
end

local function utility(unit)
    Fireblood()
    BloodFury()
    Berserking()
    AncestralCall()
    ManaTea(unit)
    TigersLust(unit)
end

-------------------------------------------------------------------



SheilunsGift:Callback("yulon", function(spell)
    if SheilunsGift.count < 1 then return end
    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId == spell.id then
        return
    end

    return spell:Cast()
end)

ThunderFocusTea:Callback("yulon_combo", function(spell)
    if not player.combat then return end
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    return spell:Cast()
end)

RenewingMist:Callback("yulon_combo", function(spell, unit)
    if player:Buff(buffs.secretInfusionHaste) then return end
    
    local needsMist = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.renewingMist, true) end
    )

    if needsMist and unit:Buff(buffs.renewingMist, true) then
        HealingEngine.SetTarget(needsMist:CallerId(), 1)
    end
    ThunderFocusTea("yulon_combo")
    return spell:Cast(unit)
end)

RenewingMist:Callback("chiji_combo", function(spell, unit)
    if not gs.summonActive then return end
    if not player:TalentKnown(InvokeChiJi.id) then return end

    if player:Buff(buffs.secretInfusionHaste) then return end
    
    local needsMist = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.renewingMist, true) end
    )

    if needsMist and unit:Buff(buffs.renewingMist, true) then
        HealingEngine.SetTarget(needsMist:CallerId(), 1)
    end
    ThunderFocusTea("yulon_combo")
    return spell:Cast(unit)
end)

InvokeYulon:Callback("boss", function(spell, unit)
    if not shouldYulon() then return end

    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end



    RenewingMist("yulon_combo", unit)

    if player:TalentKnown(ShaohaosLessons.id) then
        SheilunsGift("yulon") -- Always Sheilun before Yulon for Shaohao buff
    end
    return spell:Cast()
end)

CelestialConduit:Callback("boss", function(spell)
    if incBigDmgIn() > 500 then return end

    if gs.cdUsed < 5000 then return end

    return spell:Cast()
end)

local function shouldRevival()
    if not gs.raid then return false end
    if not boss then return false end
    if not player.combat then return false end

    local averageHp = MakMulti.party:Average(function(friendly) return friendly.ehp end)

    if boss.vexie() then
        if InvokeYulon.used > 40000 and InvokeYulon.cd > 10000 then
            if averageHp < 80 and makRamp({468149}) > 20000 then -- Exhaust Fumes (really janky to try get it to be used after third set)
                return true
            end
        end
    end

    if boss.cauldron() then
        if inc.colossalClash < 60000 and averageHp < 70 then
            return true
        end
    end

    if boss.rik() then
        if averageHp < 80 and InvokeYulon.used > 40000 and InvokeYulon.cd > 10000 then
            return true
        end
    end

    if boss.stix() then
        if averageHp < 80 and InvokeYulon.used > 40000 and InvokeYulon.cd > 10000 then
            return true
        end
    end

    if boss.lockenstock() then
        if averageHp < 80 and InvokeYulon.used > 40000 and InvokeYulon.cd > 10000 then
            return true
        end
    end

    if boss.bandit() then
        if averageHp < 80 and not gs.summonActive then
            return true
        end
    end

    if boss.mugzee() then
        if averageHp < 80 and makRamp({469491}) < 5000 then -- Double Whammy Shot
            return true
        end
    end

    if boss.gallywix() then
        if averageHp < 80 and InvokeYulon.used > 40000 and InvokeYulon.cd > 10000 then -- Double Whammy Shot
            return true
        end
    end

    return false
end

Revival:Callback("boss", function(spell)
    if gs.cdUsed < 5000 then return end
    if player:TalentKnown(Restoral.id) then return end



    if not boss then
        local averageHp  = MakMulti.party:Average(function(friendly) return friendly.ehp end)
        if averageHp < 70 then
            return spell:Cast()
        end
    end

    if boss then
        if shouldRevival() then
            return spell:Cast()
        end
    end
end)

Restoral:Callback("boss", function(spell)
    if gs.cdUsed < 5000 then return end
    if not player:TalentKnown(Restoral.id) then return end

    if not boss then
        local averageHp  = MakMulti.party:Average(function(friendly) return friendly.ehp end)
        if averageHp < 70 then 
            return spell:Cast()
        end
    end

    if boss then
        if shouldRevival() then
            return spell:Cast()
        end
    end
end)

Vivify:Callback("save", function(spell, unit)
    if unit.ehp > 20 then return end

    return spell:Cast(unit)
end)

RenewingMist:Callback("raid_capped", function(spell, unit)
    local needsMist = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.renewingMist, true) end
    )

    if gs.raid then
        if target and target.exists and not target.isFriendly then
            if A.GetToggle(2, "pureFist") and TigerPalm:InRange(target) then return end
        end
    end
    
    if spell.charges == spell.maxCharges then
        if unit:Buff(buffs.renewingMist, true) then
            HealingEngine.SetTarget(needsMist:CallerId(), 1)
        end
        return spell:Cast(unit)
    end
end)

RisingSunKick:Callback("raid", function(spell)
    if player:TalentKnown(RushingWindKick.id) then return end
    if not target.exists then return end
    if target.exists and target.isFriendly then return end

    if ThunderFocusTea.frac > 1.9 or (player:TalentKnown(InvokeYulon.id) and InvokeYulon.cd > ThunderFocusTea:TimeToFullCharges()) then
        if player:TalentKnown(InvokeChiJi.id) and not gs.summonActive or not player:TalentKnown(InvokeChiJi.id) then 
            ThunderFocusTea("core")
        end
    end
    return spell:Cast(target)
end)

RushingWindKick:Callback("raid", function(spell)
    if not player:TalentKnown(RushingWindKick.id) then return end
    if not target.exists then return end
    if target.exists and target.isFriendly then return end

    if ThunderFocusTea.frac > 1.9 or (player:TalentKnown(InvokeYulon.id) and InvokeYulon.cd > ThunderFocusTea:TimeToFullCharges()) then
        if player:TalentKnown(InvokeChiJi.id) and not gs.summonActive or not player:TalentKnown(InvokeChiJi.id) then 
            ThunderFocusTea("core")
        end
    end
    return spell:Cast(target)
end)

ThunderFocusTea:Callback("cap", function(spell)
    if not player.combat then return end
    if spell.frac < 1.9 then return end
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    return spell:Cast()
end)

EnvelopingMist:Callback("ox", function(spell, unit)
    if not player:Buff(buffs.strengthOfTheBlackOx) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    local needsMist = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return EnvelopingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.envelopingMist, true) end
    )

    if unit:Buff(buffs.renewingMist, true) then
        HealingEngine.SetTarget(needsMist:CallerId(), 1)
    end
    return spell:Cast(unit)
end)

RenewingMist:Callback("raid", function(spell, unit)
    local needsMist = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.renewingMist, true) and not hasChiHarmony(friendly) end
    )

    if gs.raid then
        if target and target.exists and not target.isFriendly then
            if A.GetToggle(2, "pureFist") and TigerPalm:InRange(target) then return end
        end
    end

    if needsMist and unit:Buff(buffs.renewingMist, true) then
        HealingEngine.SetTarget(needsMist:CallerId(), 1)
    end
    return spell:Cast(unit)
end)

Vivify:Callback("triage", function(spell, unit)
    if unit.ehp > 40 then return end
    if player:TalentKnown(InvokeChiJi.id) then return end


    return spell:Cast(unit)
end)

local function raid(unit)
    InvokeYulon("boss", unit)
    CelestialConduit("boss")
    Revival("boss")
    Restoral("boss")
    SoothingMist("core", unit)
    Vivify("save", unit)
    RenewingMist("chiji_combo", unit)
    RenewingMist("raid_capped", unit)
    RisingSunKick("raid")
    RushingWindKick("raid")
    ThunderFocusTea("cap")
    EnvelopingMist("ox", unit)
    SheilunsGift("core", unit)
    RenewingMist("raid", unit)
    Vivify("triage", unit)
end

-------------------------------------------------------------------
---Damage----------------------------------------------------------
-------------------------------------------------------------------

TouchOfDeath:Callback(function(spell)
    if not target.bigButtons then return end
    if player:Debuff("Searing Glare") then return end

    if target:Buff("Guardian Spirit") then return end

    if not IsSpellOverlayed(spell.id) and (not player:TalentKnown(322113) or target.hp > 15) then return end

    local _, instanceType = GetInstanceInfo()
    if instanceType ~= "party" and instanceType ~= "raid" then
        return spell:Cast(target)
    end

    local classification = UnitClassification(target:CallerId())
    if classification == "rareelite" or classification == "elite" or target.player then
        return spell:Cast(target)
    end
end)

-- Season 3: Highest priority Thunder Focus Tea for tier set synergy
ThunderFocusTea:Callback("season3-priority", function(spell)
    if not player.combat then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not gs.has2SetBonus then return end

    -- NEW: Check if tier set optimization is enabled
    if not A.GetToggle(2, "tierSetPriority") then return end

    -- Conduit of Celestials: Maintain Heart of Jade Serpent uptime
    if gs.conduitOfCelestials then
        if A.GetToggle(2, "maintainJadeSerpentBuff") then
            if not gs.heartOfJadeActive or player:BuffRemains(buffs.heartOfJadeSerpent) < 4000 then
                return spell:Cast()
            end
        end
    end

    -- Master of Harmony: Trigger guaranteed Harmonic Surge procs
    if gs.masterOfHarmony and gs.has4SetBonus then
        if A.GetToggle(2, "harmonicSurge") then -- NEW: Check if Harmonic Surge is enabled in interface
            if gs.potentialEnergyStacks >= 3 or (healTarget and healTarget.ehp < 70) then
                return spell:Cast()
            end
        end
    end

end)

ThunderFocusTea:Callback("core", function(spell)
    if not player.combat then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if gs.masterOfHarmony then
        if spell:TimeToFullCharges() < 1000 or player:Buff(buffs.aspectOfHarmony) then
            return spell:Cast()
        end
    else
        return spell:Cast()
    end
end)

RisingSunKick:Callback("secret_infusion", function(spell)
    if player:TalentKnown(RushingWindKick.id) then return end
    if not spell:InRange(target) then return end --Need this check for TFT below.
    if not player:TalentKnown(SecretInfusion.id) then return end
    if not player:Buff(buffs.thunderFocusTea) then return end

    return spell:Cast(target)
end)

RushingWindKick:Callback("secret_infusion", function(spell)
    if not player:TalentKnown(RushingWindKick.id) then return end
    if not spell:InRange(target) then return end --Need this check for TFT below.
    if not player:TalentKnown(SecretInfusion.id) then return end
    if not player:Buff(buffs.thunderFocusTea) then return end

    return spell:Cast(target)
end)

ChiBurst:Callback("core", function(spell)
    if not RisingSunKick:InRange(target) then return end

    return spell:Cast()
end)

CracklingJadeLightning:Callback("dmg", function(spell) 
    if not target.exists then return end
    if target.isFriendly then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:TalentKnown(JadeEmpowerment.id) then return end
    if not player:Buff(buffs.jadeEmpowerment) then return end

    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    local dmgSoon = incBigDmgIn() > 0 and incBigDmgIn() < 6000 or makShouldDefensive() < 6000
    if dmgSoon then return end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then
        Aware:displayMessage("CRACKLING JADE LIGHTNING SOON!", "Monk", 1, GetSpellTexture(spell.id))
    end

    if player.stayTime > 0.3 then
        return spell:Cast(target)
    end
end)

JadefireStomp:Callback("core", function(spell)

    if not player:Buff(buffs.jadefireStomp) then
        return spell:Cast()
    end
    
    if player:TalentKnown(AwakenedJadefire.id) and not player:Buff(buffs.awakenedJadefire) then
        return spell:Cast()
    end

    if player:TalentKnown(JadefireTeachings.id) and not player:Buff(buffs.jadefireTeachings) then
        return spell:Cast()
    end

end)

SpinningCraneKick:Callback("core", function(spell)
    if not RisingSunKick:InRange(target) then return end
    if gs.enemiesInMelee < 5 + (3 * num(gs.masterOfHarmony)) then return end
    if player:Buff(buffs.drainingVitality) then return end

    return spell:Cast()
end)

RisingSunKick:Callback("core", function(spell)
    if player:TalentKnown(RushingWindKick.id) then return end
    if not spell:InRange(target) then return end --Need this check for TFT below.

    return spell:Cast(target)
end)

RushingWindKick:Callback("core", function(spell)
    if not player:TalentKnown(RushingWindKick.id) then return end
    if not spell:InRange(target) then return end --Need this check for TFT below.

    return spell:Cast(target)
end)

BlackoutKick:Callback("core", function(spell)
    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 1 + (2 * num(gs.dungeon)) then return end

    return spell:Cast(target)
end)

-- Season 3: High priority Tiger Palm for Harmonic Surge procs
TigerPalm:Callback("season3-harmonic", function(spell)
    if not gs.masterOfHarmony then return end
    if not target.exists or target.isFriendly then return end

    -- Prioritize when we have Potential Energy buff (guaranteed Harmonic Surge)
    if player:Buff(buffs.potentialEnergy) then
        return spell:Cast(target)
    end

    -- Use when we have 4-set bonus and Thunder Focus Tea guarantees procs
    if gs.has4SetBonus and player:Buff(buffs.thunderFocusTea) then
        return spell:Cast(target)
    end
end)

TigerPalm:Callback("core", function(spell)

    return spell:Cast(target)
end)

local function damage()
    TouchOfDeath()
    JadefireStomp("core")
    RisingSunKick("secret_infusion")
    RushingWindKick("secret_infusion")
    ChiBurst("core")
    CracklingJadeLightning("dmg")
    JadefireStomp("core")
    SpinningCraneKick("core")
    RisingSunKick("core")
    RushingWindKick("core")
    BlackoutKick("core")
    TigerPalm("core")
end

RisingSunKick:Callback("core-raid", function(spell)
    if player:TalentKnown(RushingWindKick.id) then return end
    if not spell:InRange(target) then return end --Need this check for TFT below.
    if not gs.raid then return end

    return spell:Cast(target)
end)

local function chijiRotation()
    RisingSunKick("core-raid")
    BlackoutKick("core")
    TigerPalm("core")
end

-------------------------------------------------------------------
---Healing General-------------------------------------------------
-------------------------------------------------------------------

LifeCocoon:Callback("core", function(spell, unit)
    if not player.inCombat then return end
    if not useCocoon(unit) then return end



    if A.GetToggle(2, "randomiseCocoon") then
        return Debounce(unit.name .. "LowCoccoon", cdDelay, 5000, spell, unit)
    else
        return spell:Cast(unit)
    end
end)

Detox:Callback("core", function(spell, unit)
    if A.Zone == "arena" then return end
    if unit.hp < 35 then return end

    local magicked  = MakMulti.party:Find(function(friendly) return (friendly.magicked or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Magic")) and Detox:InRange(friendly) end)
    local diseased = MakMulti.party:Find(function(friendly) return (friendly.diseased or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Disease")) and Detox:InRange(friendly) end)
    local poisoned  = MakMulti.party:Find(function(friendly) return (friendly.poisoned or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Poison")) and Detox:InRange(friendly) end)

    if magicked then
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if diseased and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(diseased:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if poisoned and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(poisoned:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
end)

ThunderFocusTea:Callback("harmony", function(spell, unit)
    if player:Buff(buffs.thunderFocusTea) then return end
    if not gs.masterOfHarmony then return end
    if not player.combat then return end
    if not Paralysis:InRange(target) then return end
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if unit.ehp < 65 or incBigDmgIn() < 1000 or incModDmgIn() < 1000 then
        return spell:Cast()
    end
end)

-- Season 3: High priority Sheilun's Gift for Heart of the Jade Serpent maintenance
SheilunsGift:Callback("season3-priority", function(spell, unit)
    if not gs.has2SetBonus then return end
    if not gs.conduitOfCelestials then return end
    if not A.GetToggle(2, "tierSetPriority") then return end
    if not unit then unit = healTarget end
    if not unit then return end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId == spell.id then return end

    -- NEW: Use interface control for minimum stacks
    local minStacks = A.GetToggle(2, "sheilunGiftMinStacks")

    -- High priority when Heart of Jade Serpent buff is down or expiring soon
    if A.GetToggle(2, "maintainJadeSerpentBuff") then
        if not gs.heartOfJadeActive or player:BuffRemains(buffs.heartOfJadeSerpent) < 3000 then
            if spell.count >= minStacks then
                return spell:Cast(unit)
            end
        end
    end
end)

SheilunsGift:Callback("core", function(spell, unit)
    if not useSheilun(unit) then return end
    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId == spell.id then
        return
    end

    return Debounce("Sheiluns" .. unit.name, 300, 2500, spell, unit)
end)

InvokeChiJi:Callback("core", function(spell)
    if not player.inCombat then return end
    if not RisingSunKick:InRange(target) then return end
    
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if gs.raid and spell.cd < 2000 and dmgSoon() < 2500 then
        RenewingMist("yulon_combo")
    end

    if not useChiji() then return end

    return spell:Cast()
end)

CelestialConduit:Callback("core", function(spell)
    if not player.inCombat then return end
    if not useCelestialConduit() then return end

    return spell:Cast()
end)

Revival:Callback("core", function(spell)
    if not player.inCombat then return end
    if not player:TalentKnown(Revival.id) then return end
    if not useRevival() then return end

    return spell:Cast()
end)

Restoral:Callback("core", function(spell)
    if not player.inCombat then return end
    if not player:TalentKnown(Restoral.id) then return end
    if not useRevival() then return end

    return spell:Cast()
end)

ThunderFocusTea:Callback("cjl", function(spell)
    if not player.combat then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    return spell:Cast()
end)

CracklingJadeLightning:Callback("core", function(spell, unit) -- Has to go into healing section due to emergency healing
    if player.moving then return end
    if not target.exists then return end
    if target.isFriendly then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:TalentKnown(JadeEmpowerment.id) then return end
    if not player:Buff(buffs.jadeEmpowerment) and ThunderFocusTea.cd > 600 then return end

    if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then return end

    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    local ehpMin, ehpMax = cjlHealAmount()

    if unit.ehp > ehpMin and unit.ehp < ehpMax then
        local awareAlert = A.GetToggle(2, "makAware")
        if awareAlert[1] then
            Aware:displayMessage("CRACKLING JADE LIGHTNING SOON!", "Green", 1, GetSpellTexture(spell.id))
        end
        if not player:Buff(buffs.jadeEmpowerment) then
            ThunderFocusTea("cjl")
        end

        if player.stayTime > 0.3 then
            return spell:Cast(target)
        end
    end
end)

RenewingMist:Callback("chi_harmony", function(spell, unit)
    if hasChiHarmony(unit) then return end

    return spell:Cast(unit)
end)

EnvelopingMist:Callback("soom", function(spell, unit)
    local envMTarget = spellTarget(EnvelopingMist.id)
    local hasEnvM = (envMTarget and unit.name == envMTarget) or unit:Buff(buffs.envelopingMist, true)
    
    if hasEnvM then return end
    if not unit:Buff(buffs.soothingMist, true) then return end

    return spell:Cast(unit)
end)

EnvelopingMist:Callback("core", function(spell, unit)
    if spell:CastTime() > 0 then return end
    if unit.ehp < A.GetToggle(2, "envelopingMistHP") then 
        return spell:Cast(unit)
    end

    if gs.raid then
        local missedRamp = MakMulti.party:Lowest(
            function(friendly)
                return friendly.ehp
            end,
            function(friendly)
                local spellTargetUnit = spellTarget(EnvelopingMist.id)
                return EnvelopingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.envelopingMist, true) and (not spellTargetUnit or friendly.name ~= spellTargetUnit)
            end
        )
        if missedRamp then
            if not UnitIsUnit(missedRamp:CallerId(), unit:CallerId()) then
                HealingEngine.SetTarget(unit:CallerId(), 1)
            end
        end
        return spell:Cast(unit)
    end
end)

ExpelHarm:Callback("core", function(spell)
    if player.ehp > A.GetToggle(2, "expelHarmHP") then return end

    return spell:Cast()
end)

Vivify:Callback("core", function(spell, unit)
    local channel = player.channelInfo
    if not channel then

        if unit.ehp > A.GetToggle(2, "vivifyHP") then return end
        if gs.hurtWithReM >= 5 and player:Buff(buffs.vivaciousVivication) then
            return spell:Cast(unit)
        end

        if gs.raid then
            if target and target.exists and not target.isFriendly then
                if A.GetToggle(2, "pureFist") and TigerPalm:InRange(target) then return end
            end
        end

        local directHeal = math.abs(unit.ehp - HealingEngine.GetHealthAVG()) >= 10

        if unit.ehp < 60 and player:Buff(buffs.augustDynasty) and player:Buff(buffs.vivaciousVivication) then
            return spell:Cast(unit)
        end

        if player:Buff(buffs.vivaciousVivication) then
            if directHeal and unit.hp > 50 then
                RenewingMist("chi_harmony", unit)
            end
            return spell:Cast(unit)
        end
    end

    if not player:TalentKnown(SoothingMist.id) then
        if target and target.exists and not target.isFriendly then
            if A.GetToggle(2, "pureFist") and TigerPalm:InRange(target) then return end
        end

        if unit.ehp < A.GetToggle(2, "vivifyHardHP") then 
            return spell:Cast(unit)
        end
    end

    if channel then
        if channel.spellId == SoothingMist.id and unit:HasBuff(buffs.soothingMist, true) and unit:HasBuff(buffs.envelopingMist, true) and unit.ehp <= 90 then
            return spell:Cast(unit)
        end
    end
end)

SoothingMist:Callback("core", function(spell, unit)
    if player.moving then return end
    if not useSooM(unit) then return end
    if player.channeling then return end

    return spell:Cast(unit)
end)

--[[SoothingMist:Callback("statue_tank", function(spell, unit)
    if not A.GetToggle(2, "statueTank") then return end
    if player.moving then return end
    if not player:TalentKnown(SummonJadeSerpentStatue.id) then return end

    local missingStatueSooM = MakMulti.party:Find(function(friendly) return SoothingMist:InRange(friendly) and friendly.isTank and not friendly:Buff(buffs.statueSooM) end)
    
    if statueActive() then
        if missingStatueSooM then
            HealingEngine.SetTarget(missingStatueSooM:CallerId(), 1)
            return spell:Cast(unit)
        end
    end
end)]]

RenewingMist:Callback("core", function(spell, unit)
    local missingReM  = MakMulti.party:Find(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.renewingMist, true) end)

    if gs.raid then
        if target and target.exists and not target.isFriendly then
            local remExists = MakMulti.party:Find(function(friendly) return friendly:Buff(buffs.renewingMist, true) end)
            if A.GetToggle(2, "pureFist") and TigerPalm:InRange(target) and remExists then return end
        end
    end    

    if spell.charges == spell.maxCharges or (incBigDmgIn() > 8000 and incModDmgIn() > 8000) then
        if missingReM then
            if unit:BuffRemains(buffs.renewingMist, true) > 1000 and not UnitIsUnit(unit:CallerId(), missingReM:CallerId()) then
                HealingEngine.SetTarget(missingReM:CallerId(), 1)
                return spell:Cast(unit)
            end
        end
        return spell:Cast(unit)
    end

    if chiHarmonyRamp() and unit.hp > 90 then
        if hasChiHarmony(unit) then
            local missingChiHarmony = MakMulti.party:Find(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly:BuffRemains(buffs.renewingMist, true) < 4000 end)
            if missingChiHarmony then
                if not UnitIsUnit(unit:CallerId(), missingChiHarmony:CallerId()) then
                    HealingEngine.SetTarget(missingChiHarmony:CallerId(), 1)
                    return spell:Cast(unit)
                end
            end
        end
        return spell:Cast(unit)
    end
end)

Vivify:Callback("ramp", function(spell, unit)
    if player:TalentKnown(InvokeChiJi.id) then return end
    if not unit:Buff(buffs.envelopingMist) then return end
    if unit.ehp > 70 then return end
    if not player:Buff(buffs.zenPulse) then return end

    local emCount = MakMulti.party:Count(function(friendly) return friendly:Buff(buffs.envelopingMist, true) end)
    if emCount < 5 then return end

    return spell:Cast(unit)
end)

EnvelopingMist:Callback("ramp", function(spell, unit)
    local rskCD = player:TalentKnown(RushingWindKick.id) and RushingWindKick.cd or RisingSunKick.cd 

    local shouldRamp = dmgSoon() <= 4000 and dmgSoon() > spell:CastTime() and unit.ehp > 95 and (InvokeYulon.cd > 600 or not player:TalentKnown(InvokeYulon.id))

    if shouldRamp or (player:Buff(buffs.invokeYulon) and rskCD > 500) then
        local envMTarget = spellTarget(EnvelopingMist.id)
        if hasChiHarmony(unit) or unit.name == envMTarget then
            local missedRamp = MakMulti.party:Lowest(
                function(friendly)
                    return friendly.ehp
                end,
                function(friendly)
                    local spellTargetUnit = spellTarget(EnvelopingMist.id)
                    return EnvelopingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and not friendly:Buff(buffs.envelopingMist, true) and not hasChiHarmony(friendly) and (not spellTargetUnit or friendly.name ~= spellTargetUnit)
                end
            )
            if missedRamp then
                if not UnitIsUnit(unit:CallerId(), missedRamp:CallerId()) then
                    HealingEngine.SetTarget(missedRamp:CallerId(), 1)
                end
            end
        end
        return spell:Cast(unit)
    end
end)

RisingSunKick:Callback("ramp", function(spell)
    if player:TalentKnown(RushingWindKick.id) then return end
    if target.isFriendly then return end
    
    local count = MakMulti.party:Count(function(friendly) return friendly:Buff(buffs.envelopingMist, true) end)
    if count + num(gs.imCasting and gs.imCasting == EnvelopingMist.id) >= 5 then
        return spell:Cast(target)
    end
end)

RushingWindKick:Callback("ramp", function(spell)
    if not player:TalentKnown(RushingWindKick.id) then return end
    if target.isFriendly then return end
    
    local count = MakMulti.party:Count(function(friendly) return friendly:Buff(buffs.envelopingMist, true) end)
    if count + num(gs.imCasting and gs.imCasting == EnvelopingMist.id) >= 5 then
        return spell:Cast(target)
    end
end)

Vivify:Callback("ramp2", function(spell, unit)
    if player:TalentKnown(InvokeChiJi.id) then return end
    if unit.ehp > 90 then return end

    return spell:Cast(unit)
end)

local function yulonRamp(unit)
    Vivify("ramp", unit)
    EnvelopingMist("ramp", unit)
    RisingSunKick("ramp")
    RushingWindKick("ramp")
    Vivify("ramp2", unit)
end

SoothingMist:Callback("oor", function(spell, unit)
    if player.moving then return end
    if RisingSunKick:InRange(target) then return end
    if unit.ehp > A.GetToggle(2, "soomOORHP") then return end

    return spell:Cast(unit)
end)

Vivify:Callback("ooc", function(spell, unit)
    if player.combat then return end
    if unit.ehp > 95 then return end

    if player:Buff(buffs.vivaciousVivication) or unit:Buff(buffs.soothingMist, true) then
        return spell:Cast(unit)
    end
end)

RenewingMist:Callback("ooc", function(spell, unit)
    if player.combat then return end
    if unit.ehp > 95 then return end

    return spell:Cast(unit)
end)

SummonJadeSerpentStatue:Callback(function(spell)
    if not player.combat and target.exists and not target.isFriendly and Paralysis:InRange(target) and SummonJadeSerpentStatue.used < 4000 then
        return spell:Cast()
    end

    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if player.combat and (spell.used > currentCombatTime or spell.used < 0) then
        return spell:Cast()
    end
end)

-- Season 3: Fistweaving rotation prioritizing damage abilities with healing conversion
local function fistweavingRotation(unit)
    -- Emergency healing first
    LifeCocoon("core", unit)
    Detox("core", unit)

    -- Season 3 tier set priorities
    ThunderFocusTea("season3-priority")
    if gs.conduitOfCelestials then
        SheilunsGift("season3-priority", unit)
    end

    -- Damage abilities for healing through Ancient Teachings/Jadefire Teachings
    if target.exists and not target.isFriendly then
                -- NEW: Mystic Touch application for enhanced fistweaving
        TigerPalm("mystic-touch")

        -- Season 3 priority abilities
        JadefireStomp("core")
        TigerPalm("season3-harmonic") -- Harmonic Surge priority
        RisingSunKick("secret_infusion")
        RushingWindKick("secret_infusion")
        JadefireStomp("core")
        CracklingJadeLightning("core", unit)
        SpinningCraneKick("core")
        RisingSunKick("core")
        RushingWindKick("core")
        BlackoutKick("core")
        TigerPalm("core")
    end

    -- Major cooldowns
    InvokeChiJi("core", unit)
    CelestialConduit("core", unit)

    -- Direct healing only when necessary
    if unit and unit.ehp < 60 then
        Revival("core", unit)
        Restoral("core", unit)
        EnvelopingMist("soom", unit)
        Vivify("core", unit)
    end

    -- Maintenance healing
    RenewingMist("core", unit)
    ExpelHarm("core", unit)
    ManaTea(unit)
end

-- Season 3: Traditional Mistweaving rotation prioritizing direct healing
local function traditionalMistweavingRotation(unit)
    -- Core healing priorities
    LifeCocoon("core", unit)
    Detox("core", unit)
    ThunderFocusTea("harmony", unit)
    ThunderFocusTea("core")

    if gs.raid then
        if player:Buff(buffs.invokeYulon) then
            yulonRamp(unit)
        end
        raid(unit)
    end

    -- Season 3 tier set priorities
    if gs.conduitOfCelestials then
        SheilunsGift("season3-priority", unit)
    end
    SheilunsGift("core", unit)

    -- Major healing cooldowns
    InvokeChiJi("core", unit)
    CelestialConduit("core", unit)
    Revival("core", unit)
    Restoral("core", unit)

    -- Direct healing spells
    EnvelopingMist("soom", unit)
    EnvelopingMist("core", unit)
    Vivify("core", unit)
    RenewingMist("core", unit)
    ExpelHarm("core", unit)

    -- Damage abilities for pressure (lower priority)
    if target.exists and not target.isFriendly then
        CracklingJadeLightning("core", unit)
        RisingSunKick("core")
        RushingWindKick("core")
    end

    ManaTea(unit)
    ZenSpheres("core", unit)
end

-- Season 3: Dual rotation system dispatcher
local function dualRotationHealing(unit)
    if shouldFistweaveHybrid() then
        fistweavingRotation(unit)
    else
        traditionalMistweavingRotation(unit)
    end
end

local function healing(unit)
    if shouldFistweaveHybrid() then
        return fistweavingRotation(unit)
    end

    LifeCocoon("core", unit)
    Detox("core", unit)
    ThunderFocusTea("harmony", unit)
    ThunderFocusTea("core")

    if gs.raid then
        if player:Buff(buffs.invokeYulon) then
            yulonRamp(unit)
        end
        raid(unit)
    end

    SheilunsGift("core", unit)
    CracklingJadeLightning("core", unit)
    InvokeChiJi("core", unit)
    CelestialConduit("core", unit)
    Revival("core", unit)
    Restoral("core", unit)
    JadefireStomp("core")
    EnvelopingMist("soom", unit)
    EnvelopingMist("core", unit)
    ExpelHarm("core")

    if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then
        if target.exists and not target.isFriendly and TigerPalm:InRange(target) then
            return chijiRotation()
        end
    end

    Vivify("core", unit)
    SoothingMist("pvp")
    SoothingMist("core", unit)
    --SoothingMist("statue_tank", unit)
    RenewingMist("core", unit)
    EnvelopingMist("ramp", unit)
    SoothingMist("oor", unit)
    Vivify("ooc", unit)
    RenewingMist("ooc", unit)
    SummonJadeSerpentStatue()
end

-------------------------------------------------------------------
---PVP-------------------------------------------------------------
-------------------------------------------------------------------

local function useSheilunPvp(unit)
    -- if player:TalentKnown(InvokeChiJi.id) and gs.summonActive then return end

    if player:TalentKnown(EmperorsFavor.id) then
        if SheilunsGift.count >= 8 and unit.ehp < 50 and as.enemyCds then
            return true
        end

        if SheilunsGift.count >= 4 and unit.ehp < 30 then
            return true
        end
    end

    if SheilunsGift.count < 5 then return end
    local below80 = MakMulti.party:Count(function(friendly) return RenewingMist:InRange(friendly) and not friendly.isPet and friendly.hp > 0 and friendly.ehp < 80 end)
    
    if not gs.raid then
        if below80 >= 3 and not player:TalentKnown(EmperorsFavor.id) then
            return true
        end
    else
        if below80 >= 3 + (2 * player:TalentKnownInt(LegacyOfWisdom.id)) then
            return true
        end
    end

    return false
end

SheilunsGift:Callback("pvp", function(spell, unit)
    if not unit then return end
    if cocoonInFlight(unit) then return end
    
    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId == SoothingMist.id then return end
    if unit.totalImmune then return end

    if not useSheilunPvp(unit) then return end

    if unit.ehp < 10 then
        return spell:Cast(unit)
    end


    DebounceFunc("Sheiluns" .. unit.name, 300, 2500, function ()
        -- Prevent overlap by forcing
        LifeCocoon("pvp", true)
        spell:Cast(unit)
        return false
    end)
end)

local dontRWKList = AtoL({
    "Darkness",
    "Dispersion",
    "Rain from Above"
})

local defensiveWeDontHit = AtoL({
    "Diffuse Magic",
    "Dampen Harm",
    "Fortifying Brew",
    "Barkskin",
    "Ironbark",
    "Icebound Fortitude",
    "Astral Shift",
    "Survival of the Fittest",
    "Obsidian Scales",
    "Pain Suppression",
    "Unending Resolve",
    "Divine Protection"
})

CracklingJadeLightning:Callback("pvp", function(spell)
    if not target.exists then return end
    if target.isFriendly then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not healTarget then return end
    if healTarget.hp < 30 or (as.enemyCds and healTarget.hp < 40) then return end
    -- if gs.imCasting then return end
    if not player:TalentKnown(JadeEmpowerment.id) then return end
    --if TigerPalm:InRange(target) then return end
    if player.stayTime < 0.2 or player.speed > 0 then return end
    if not player:Buff(buffs.jadeEmpowerment) then
        -- ThunderFocusTea("pvp")
        return
    end

    if player:Buff(buffs.harmonyActive) then
        Aware:displayMessage("Big Crackle Damage", "Monk", 1, GetSpellTexture(buffs.harmonyActive))
        return spell:Cast(target)
    end

    if target.ehp > 90 and target:BuffFrom(defensiveWeDontHit) then
        Aware:displayMessage("Not casted due to a defensive", "Monk", 1, GetSpellTexture(spell.id))
        return
    end


    return spell:Cast(target)
end)

SphereHarm:Callback("pvp", function(spell, unit)
    if not target.bigButtons then return end
    if not target.exists then return end
    if not target.canAttack then return end
    if target.totalImmune then return end
    if target.magicImmune then return end
    if target:Debuff(buffs.sphereOfDispear) then return end

    local total, _, _, _, cds = unit:AttackersV69()
    if total == 0 then return end

    if cds >= 1 then
        Debounce("SphereHarm" .. unit.name, 1000, 10500, spell, unit)
    end
    if target.hp > 50 and player.manaPct < 50 then return end
    if healTarget and healTarget.hp < 60 then return end

    local found = MakMulti.arena:Find(function (party)
        return party:Buff(buffs.sphereOfDispear)
    end)

    if found and not found.dead and not found.totalImmune then
        if found.hp < target.hp then return end

        if found.hp - target.hp < 20 then return end
    end

    Debounce("SphereHarm" .. unit.name, 1000, 10500, spell, unit)
end)

SphereHarm:Callback("prio", function(spell, unit)
    if not target.bigButtons then return end
    if not target.exists then return end
    if not target.canAttack then return end
    if target.totalImmune then return end
    if target.magicImmune then return end
    if target:Debuff(buffs.sphereOfDispear) then return end

    local total, _, _, _, cds = unit:AttackersV69()
    if total == 0 then return end
    if cds >= 1 then
        Debounce("SphereHarm" .. unit.name, 1000, 10500, spell, unit)
    end
end)

Vivify:Callback("bigvv-dropping-soon", function(spell)
    if not healTarget then return end
    if healTarget.hp > 70 then return end
    -- if chiHarmonyRemains(healTarget) < 1000 then return end
    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId ~= SoothingMist.id then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    
    if not player:Buff(buffs.vivaciousVivication) then return end
    if player:BuffRemains(buffs.vivaciousVivication) > 2500 then
        return
    end

    Aware:displayMessage("Spending free vivify as dropping soon", 'Monk', 1.5, GetSpellTexture(spell.id))
    return spell:Cast(healTarget)
end)

Vivify:Callback("soothingCast", function(spell)
    if not healTarget then return end
    if healTarget.hp > 90 then return end

    local castInfo = player.castOrChannelInfo
    if not castInfo or castInfo.spellId ~= SoothingMist.id then return end

    return spell:Cast(healTarget)
end)

Vivify:Callback("prep-room", function(spell)
    if not healTarget then return end

    local castInfo = player.castOrChannelInfo
    if not castInfo or castInfo.spellId ~= SoothingMist.id then return end

    return spell:Cast(healTarget)
end)

Vivify:Callback("bigvv-pvp", function(spell)
    if not healTarget then return end
    if healTarget.ehp > 65 then return end    
    if not player:Buff(buffs.vivaciousVivication) then return end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId ~= SoothingMist.id then return end
    if player:Buff(buffs.thunderFocusTea) and (healTarget.totalImmune or healTarget.ehp > 25) then
        return
    end

    if player:Buff(buffs.thunderFocusTea) or healTarget.ehp > 30 then
        EnvelopingMist("instant-pvp")
        RisingSunKick("pvp", target)
    end
    -- if chiHarmonyRemains(healTarget) < 1000 then return end
    --if player:Buff(buffs.thunderFocusTea) then return end

    return spell:Cast(healTarget)
end)

Vivify:Callback("vv-pvp", function(spell)
    if not healTarget then return end
    if healTarget.hp > 50 then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not player:Buff(buffs.vivaciousVivication) then return end

    return spell:Cast(healTarget)
end)

local prepTimer = 0
local function enablePrepRoom()
    prepTimer = GetTime()
end

MakuluFramework.Commands.register("prep", enablePrepRoom, "Enable Prep Room", {})

ThunderFocusTea:Callback("prep-room", function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then return end
    if GetTime() - prepTimer > 10 then return end
    if not player:Buff(32727) then return end
    if not player:TalentKnown(JadeEmpowerment.id) then return end
    if player:HasBuffCount(buffs.jadeEmpowerment) == 1 then return end

    return Debounce("tftPrep", prepDelay, 5000, spell, player)
end)

ThunderFocusTea:Callback("pvp", function(spell)
    if not healTarget then return end
    if spell.used < 1000 and spell.used > 0 then return end

    if player:Buff(buffs.harmonyActive) then return end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId == SoothingMist.id then
        return
    end
    
    --if RushingWindKick.cd > 1000 then return end
    -- if not as.enemyCds and spell.frac < 1.5 and healTarget.ehp > 60 then return end
    --if healTarget.hp < 30 then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    -- if player:Buff(buffs.topRSK) then return end
    
    -- if player:Buff(buffs.topRSK) and RisingSunKick.cd < 2000 and target.canAttack and target.distance <= 15 then return end
    -- if player:Buff(buffs.topEnvelop) and EnvelopingMist.cd < 2000 then return end

    if aspectOfHarmonyPercent() < 38  then return end
    
    return spell:Cast()
end)

Vivify:Callback("pvp", function(spell)
    if not healTarget then return end
    if player:Buff(buffs.thunderFocusTea) then return end

    local castInfo = player.castOrChannelInfo
    if castInfo then
        if castInfo.spellId ~= SoothingMist.id then return end
    else
        if not player:Buff(buffs.vivaciousVivication) then return end
    end

    if healTarget.hp > 20 then return end

    return spell:Cast(healTarget)
end)

local healPrio = {
    party1, party2
}

RenewingMist:Callback("arenaGates", function(spell, unit)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if player:Buff(32727) then return end
    if healTarget and healTarget.hp < 100 then return end
    if not healTarget then return end

    for _, party in ipairs(healPrio) do
        if party.exists and not party:Buff(buffs.renewingMist) then
            if healTarget.guid == party.guid then
                return spell:Cast(healTarget)
            end

            HealingEngine.SetTarget(party:CallerId(), 1)
            return
        end
    end
end)

RenewingMist:Callback("chi-pvp", function(spell)
    if not healTarget then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not IsPlayerSpell(ChiHarmony.id) then return end
    if not as.enemyCds and healTarget.hp > 95 then return end
    -- if healTarget:IsUnit(player) then return end
    if as.enemyCds and as.enemyCdRemains > 5000 and healTarget.ehp > 70 and chiHarmonyRemains(healTarget) < 4000 then
        return spell:Cast(healTarget)
    end
    if player.combat and (not as.enemyCds or as.enemyCdRemains > 2000 or chiHarmonyRemains(healTarget) > 1000) then return end
    
    Aware:displayMessage("Renewing Mist for Chi Harmony uptime", 'Monk', 1.5, GetSpellTexture(spell.id))

    return spell:Cast(healTarget)
end)

RenewingMist:Callback("force", function(spell)
    if not healTarget then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if not IsPlayerSpell(ChiHarmony.id) then return end
    
    Aware:displayMessage("Renewing Mist for Chi Harmony uptime", 'Monk', 1.5, GetSpellTexture(spell.id))

    return spell:Cast(healTarget)
end)

SoothingMist:Callback("prep-room", function(spell)
    if not healTarget then return end
    if player.stayTime < 0.5 or player.speed > 0 then return end

    local castInfo = player.castOrChannelInfo
    if castInfo then
        if castInfo.spellId ~= spell.id then return end
        if castInfo.remaining > 1000 then return end
    end

    return spell:Cast(healTarget)
end)

SoothingMist:Callback("pvp", function(spell)
    if not healTarget then return end
    if player.stayTime < 0.2 or player.speed > 0 then return end

    -- if player.stayTime < 0.5 and healTarget.hp > 90 and (healTarget:Buff(buffs.soothingTotem) or not statueActive()) then return end

    local castInfo = player.castOrChannelInfo
    if castInfo then
        if castInfo.spellId ~= spell.id then return end
        if castInfo.remaining > 1000 then return end
    end

    if player:Buff(buffs.thunderFocusTea) then 
        if healTarget.ehp > 40 and RushingWindKick.cd < 2000 then
            return
        end
    end

    if as.enemyCdsAny and not healTarget:Buff(buffs.envelopingMist) and (not healTarget.totalImmune or healTarget.ehp < 80) then
        return spell:Cast(healTarget)
    end

    if not healTarget:Buff(buffs.envelopingMist) and healTarget.ehp < 60 then
        return spell:Cast(healTarget)
    end

    if healTarget.ehp < 40 then
        return spell:Cast(healTarget)
    end

    if target.isFriendly then
        return spell:Cast(healTarget)
    end

    if player:Buff(buffs.jadeEmpowerment) and healTarget.ehp > 50 then
        -- ThunderFocusTea("pvp")
        return
    end

    if TigerPalm:InRange(target) then
        return
    end
    
    return spell:Cast(healTarget)
end)

LifeCocoon:Callback("pvp", function(spell, force)
    if not healTarget then return end

    if healTarget.totalImmune then return end

    -- if healTarget.ehp < 40 and not healTarget.hasDefensive then
    --     Debounce("LowCoccoon" .. healTarget.name, 500, 4500, spell)
    -- end

    local total, _, _, _, cds = healTarget:AttackersV69()
    if as.enemyCds and as.enemyCdRemains < 5000 then
        cds = cds - 1
    end

    local wouldCast = false

    if total > 0 and healTarget.ehp < 80 and not healTarget.hasDefensive and cds > 1 and not cdsLessThan(5000) then
        Debounce("LowCoccoonCdsLower" .. healTarget.name, 500, 4500, spell, healTarget)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 1. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end

    if total > 0 and healTarget.ehp < 50 and (not healTarget:Buff(buffs.envelopingMist) or not healTarget.hasDefensive) and cds > 0 and not cdsLessThan(5000) then
        Debounce("LowCoccoonCds" .. healTarget.name, 500, 4500, spell, healTarget)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 2. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end

    if healTarget.ehp < 40 and cds > 0 then
        Debounce("LowCoccoonCdsTwo" .. healTarget.name, 500, 4500, spell, healTarget)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 3. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end

    if healTarget.ehp < 20 then
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 4. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
        return spell:Cast(healTarget)
    end

    if force and wouldCast then
        return spell:Cast(healTarget)
    end
end)

EnvelopingMist:Callback("instant-pvp", function(spell)
    if not healTarget then return end
    if cocoonInFlight(healTarget) then return end

    local hasTopEnvelop = player:HasBuffFor(buffs.topEnvelop) > 100
    if not hasTopEnvelop and player:Buff(buffs.topEnvelop) then return end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellId ~= SoothingMist.id then return end

    if hasTopEnvelop and player:BuffRemains(buffs.topEnvelop) < 2000 and healTarget:BuffRemains(buffs.envelopingMist) < 4000 then
        return spell:Cast(healTarget)
    end

    if player:HasBuffCount(buffs.craneBuff) >= 3 and player:BuffRemains(buffs.craneBuff) < 2000 and not player:Buff(buffs.thunderFocusTea) then
        return spell:Cast(healTarget)
    end

    if healTarget:BuffRemains(buffs.envelopingMist) > 1000 then return end
    -- Here we are giving up a TFT charge lets make sure we really want to do this
    if player:Buff(buffs.thunderFocusTea) and not hasTopEnvelop then
        if not healTarget:Buff(buffs.envelopingMist) and (healTarget.ehp < 40 or (healTarget.ehp < 60 and as.enemyCds and as.enemyCdRemains > 4000)) then
            -- Check if a cocoon is coming soon
            LifeCocoon("pvp", true)
            return spell:Cast(healTarget)
        end
        return
    end
    
    --if healTarget:Buff(buffs.envelopingMist) then return end
    if healTarget.hp > 90 then return end
    if healTarget.ehp > 60 and (not as.enemyCds or cdsLessThan(2000)) then return end
    --if healTarget.hp < 30 then return end
    if healTarget:BuffRemains(buffs.envelopingMist) > 1000 then return end

    local total = healTarget:AttackersV69()
    if total == 0 and healTarget.ehp > 30 then return end

    if player:Buff(buffs.topEnvelop) then
        return spell:Cast(healTarget)
    end 
    
    if player:HasBuffCount(buffs.craneBuff) >= 3 and not player:Buff(buffs.thunderFocusTea) then
        return spell:Cast(healTarget)
    end

    if player:HasBuffCount(buffs.craneBuff) >= 3 and player:Buff(buffs.thunderFocusTea) and healTarget.ehp < 40 then
        return spell:Cast(healTarget)
    end

    --if healTarget.hp > 90 then
    --    local total, _, _, _, cds = healTarget:AttackersV69()
    --
    --    if cds == 0 and total < 2 then return end
    --end

end)

EnvelopingMist:Callback("soothing", function(spell)
    if not healTarget then return end
    
    local castInfo = player.castOrChannelInfo
    if not castInfo or castInfo.spellId ~= SoothingMist.id then
        return
    end

    if healTarget:BuffRemains(buffs.envelopingMist) > 3000 then return end

    if healTarget:Buff(buffs.envelopingMist) and player.manaPct < 90 and (healTarget.hp > 70 and not as.enemyCds) then return end
    
    --if healTarget.hp > 80 then
    --    local total, _, _, _, cds = healTarget:AttackersV69()

    --    if cds == 0 and total < 2 then return end
    --end
    return spell:Cast(healTarget)
end)

EnvelopingMist:Callback("prep-room", function(spell)
    if not healTarget then return end
    
    local castInfo = player.castOrChannelInfo
    if not castInfo or castInfo.spellId ~= SoothingMist.id then
        return
    end

    if healTarget:BuffRemains(buffs.envelopingMist) > 1000 then return end
    return spell:Cast(healTarget)
end)

EnvelopingMist:Callback("pvp", function(spell)
    if not healTarget then return end
    if not instaCastStuff() then return end
    if healTarget:Buff(buffs.envelopingMist) then return end
    if healTarget.hp > 60 then return end


    --if healTarget.hp > 80 then
    --    local total, _, _, _, cds = healTarget:AttackersV69()

    --    if cds == 0 and total < 2 then return end
    --end
    return spell:Cast(healTarget)
end)

EnvelopingMist:Callback("noTFT-pvp", function(spell)
    if not healTarget then return end
    if RushingWindKick:Cooldown() < 1000 then return end
    if healTarget.hp < 85 then return end

    return spell()
end)

RenewingMist:Callback("pvp", function(spell)
    if not healTarget then return end
    if player:Buff(buffs.thunderFocusTea) then return end
    if healTarget.ehp < 80 then return end
    if healTarget:BuffRemains(buffs.renewingMist) > 1000 then return end

    return spell:Cast(healTarget)
end)

Restoral:Callback("pvp", function(spell)
    if not healTarget then return end
    if healTarget.ehp > 20 then return end
    if healTarget.totalImmune then return end
    if healTarget.healImmune then return end
    if cocoonInFlight(healTarget) then return end

    return spell:Cast(healTarget)
end)

InvokeChiJi:Callback("pvp", function(spell)
    if not healTarget then return end
    if not target.exists or not target.canAttack then return end
    if target.distance > 20 then return end
    if healTarget.ehp > 90 then return end
    if healTarget.ehp > 40 and (not as.enemyCds or cdsLessThan(2000)) then return end

    -- if healTarget.hp > 40 then
    --    local total, _, _, _, cds = healTarget:AttackersV69()
    
    --    if cds == 0 and total < 2 then return end
    -- end

    return spell:Cast()
end)

TigerPalm:Callback("pvp", function(spell, unit)
    if player:Debuff("Searing Glare") then return end
    return spell:Cast(unit)
end)

BlackoutKick:Callback("pvp", function(spell, unit)
    if player:Debuff("Searing Glare") then return end

    if not player:Buff(buffs.teachingsOfTheMonastery) and TigerPalm("pvp", unit) then
        Aware:displayMessage("Tiger Palm for Monastery", "Monk", 1, GetSpellTexture(TigerPalm.id))
    end

    if RushingWindKick.cd < 2000 and player:HasBuffCount(buffs.teachingsOfTheMonastery) < 4 then
        TigerPalm("pvp", unit)
    end

    if RushingWindKick.cd < 1000 then
        return
    end

    return spell:Cast(unit)
end)

RisingSunKick:Callback("pvp", function(spell, unit)
    if player:TalentKnown(RushingWindKick.id) then return end
    
    if not target.exists then return end
    if not target.canAttack then return end
    if not healTarget then return end
    --if healTarget.hp > 90 and unit.hp > 30 then return end
    if unit.distance > 15 then return end
    local rwkcd = spell:Cooldown()

    if healTarget.hp < 70 then
        return spell:Cast(unit)
    end

    if healTarget.hp < 90 and rwkTFT() then
        return spell:Cast(unit)
    end
end)

local RWKImmune = AtoL({
    31224,  -- Cloak of Shadows
    204018, -- Blessing of Spellwarding
    212295, --Nether Ward
    115310, --Revival
    69901,  --Spell Reflect
    23920,  --Spell Reflection
    388615, -- Restoral
    353313, --Peaveweaver 1
    353319, --Peaveweaver 2
    408558, -- Phase Shift
})

RushingWindKick:Callback("pvp", function(spell, unit)
    if not player:TalentKnown(RushingWindKick.id) then return end
    
    if not target.exists then return end
    if not target.bigButtons then return end
    if not target.canAttack or target.dead then return end
    if not healTarget then return end
    if target.bcc then return end
    if target.totalImmune or target:BuffFrom(RWKImmune) then return end
    --if healTarget.hp > 90 and unit.hp > 30 then return end
    if unit.distance > 15 then return end

    if player:Debuff("Searing Glare") then return end

    if target:BuffFrom(dontRWKList) then
        Aware:displayMessage("Not casted due to big defensive", "Monk", 1, GetSpellTexture(spell.id))
        return
    end

    -- if not rwkTFT() and healTarget.hp > 40 and ThunderFocusTea.frac < 1 then
    --     if player:Buff(buffs.rushingWinds) then
    --         return
    --     end
    -- end

    if player:Buff(buffs.harmonyActive) then
        Aware:displayMessage("RWK on harmony", "Monk", 1, GetSpellTexture(buffs.harmonyActive))
        return spell:Cast(unit)
    end

    if unit.hp < 20 then
        Aware:displayMessage("RWK Execute", "Monk", 1, GetSpellTexture(spell.id))
        ThunderFocusTea("pvp")
        return spell:Cast(unit)
    end

    if aspectOfHarmonyPercent() > 40 and ThunderFocusTea.cd > 0 and ThunderFocusTea.cd < 3000 then
        if not player:Buff(buffs.teachingsOfTheMonastery) or ThunderFocusTea.cd < 1500 then
            return
        end
    end

    -- if not gs.teamCds and target.ehp > 80 and target:BuffFrom(defensiveWeDontHit) then
    --     Aware:displayMessage("Not casted due to a defensive", "Monk", 1, GetSpellTexture(spell.id))
    --     return
    -- end

    ThunderFocusTea("pvp")
    return spell:Cast(unit)
end)

ManaTea:Callback("pvp", function(spell)
    if not healTarget then return end
    if gs.actualLowest.hp < 80 then return end
    if player:HasBuffCount(buffs.manaTea) < 3 then return end
    if player:Buff(buffs.harmonyActive) then return end

    if player.manaPct > 90 and player:HasBuffCount(buffs.manaTea) < 8 then return end

    if player.manaPct > 60 and player:HasBuffCount(buffs.manaTea) < 8 and healTarget.hp < 90 then return end

    if player.manaPct > 30 and target.bigButtons and target.exists and target.canAttack and target.hp < 40 then return end

    if not gs.actualLowest.totalImmune then
        if as.enemyCds and as.enemyCdRemains > 1000 then return end
    end

    return spell:Cast(player)
end)

SphereHelp:Callback("pvp", function(spell)
    if not healTarget then return end
    if healTarget.isMe then return end
    if healTarget:BuffRemains(buffs.sphereOfHope) > 1000 then 
        if healTarget:BuffRemains(buffs.sphereOfHope) > 10000 then return end

        if not as.enemyCds or cdsLessThan(5000) then return end

        Aware:displayMessage("Refreshing Sphere early in enemy CDS", "Monk", 1, GetSpellTexture(spell.id))
    end

    local found = MakMulti.party:Find(function (party)
        if party:IsUnit(healTarget) then return end
        return party:Buff(buffs.sphereOfHope)
    end)

    if found and not found.dead then
        if found.hp < healTarget.hp then return end

        if found.hp - healTarget.hp < 20 then return end
    end

    return spell:Cast(healTarget)
end)

-- Unified Zen Spheres callback - handles both healing and damage spheres
ZenSpheres:Callback("core", function(spell, unit)
    -- Check if Zen Spheres talent is selected
    if not player:TalentKnown(ZenSpheresTalent.id) then return end

                                                                                                -- DevDebug mode: Allow testing without normal restrictions
                                                                                                if devDebug then
                                                                                                    -- Healing sphere on player (even at full health)
                                                                                                    if player.exists and not player:Buff(buffs.sphereOfHope) then
                                                                                                        if spell:InRange(player) then
                                                                                                            return Debounce("ZenSpheresDebugHeal_player", 1000, 10500, spell, player)
                                                                                                        end
                                                                                                    end

                                                                                                    -- Damage sphere on any valid enemy target
                                                                                                    if target.exists and target.canAttack then
                                                                                                        if not target.totalImmune and not target.magicImmune then
                                                                                                            if not target:Debuff(buffs.sphereOfDispear) and spell:InRange(target) then
                                                                                                                return Debounce("ZenSpheresDebugDamage_" .. target.name, 1000, 10500, spell, target)
                                                                                                            end
                                                                                                        end
                                                                                                    end

                                                                                                    return
                                                                                                end

    -- Normal operation mode below
    -- Determine if we should prioritize healing or damage
    local shouldHeal = false
    local shouldDamage = false

    -- Check if healing is needed
    if unit and unit.hp > 0 then
        -- Prioritize healing if unit is below 80% health
        if unit.ehp < 80 then
            shouldHeal = true
        end
    end

    -- Check for low health allies that need healing spheres
    local lowestAlly = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly)
            return RenewingMist:InRange(friendly)
                and friendly.hp > 0
                and not friendly.dead
                and not friendly:Buff(buffs.sphereOfHope)
                and friendly.ehp < 75
        end
    )

    -- Check for valid damage target
    local validDamageTarget = target.exists
        and target.canAttack
        and not target.totalImmune
        and not target.magicImmune
        and not target:Debuff(buffs.sphereOfDispear)
        and spell:InRange(target)

    -- Decision logic: Healing takes priority over damage
    if lowestAlly and lowestAlly.ehp < 70 then
        -- Place healing sphere on lowest ally
        HealingEngine.SetTarget(lowestAlly:CallerId(), 1)
        return Debounce("ZenSpheresHeal_" .. lowestAlly.name, 1000, 10500, spell, lowestAlly)
    elseif shouldHeal and unit and unit.ehp < 75 and not unit:Buff(buffs.sphereOfHope) then
        -- Place healing sphere on current unit
        return Debounce("ZenSpheresHeal_" .. unit.name, 1000, 10500, spell, unit)
    elseif validDamageTarget and player.inCombat then
        -- Only use damage spheres if no urgent healing is needed
        local urgentHealing = MakMulti.party:Any(function(friendly)
            return RenewingMist:InRange(friendly) and friendly.hp > 0 and friendly.ehp < 60
        end)

        if not urgentHealing then
            -- Check mana efficiency for damage spheres
            if player.manaPct > 40 or target.hp < 50 then
                return Debounce("ZenSpheresDamage_" .. target.name, 1000, 10500, spell, target)
            end
        end
    end
end)

-- Unified Zen Spheres callback for PvP scenarios
ZenSpheres:Callback("pvp", function(spell)
    -- Check if Zen Spheres talent is selected
    if not player:TalentKnown(ZenSpheresTalent.id) then return end

    -- DevDebug mode: Allow testing without normal restrictions
    if devDebug then
        -- Healing sphere on player (even at full health)
        if player.exists and not player:Buff(buffs.sphereOfHope) then
            if spell:InRange(player) then
                return spell:Cast(player)
            end
        end

        -- Damage sphere on any valid enemy target
        if target.exists and target.canAttack and not target.isFriendly then
            if not target.totalImmune and not target.magicImmune then
                if not target:Debuff(buffs.sphereOfDispear) and spell:InRange(target) then
                    return Debounce("ZenSpheresDebugPvP_" .. target.name, 1000, 10500, spell, target)
                end
            end
        end

        return
    end

    -- Normal PvP operation mode below
    -- Healing sphere logic for PvP
    if healTarget and not healTarget.isMe then
        -- Check if healTarget already has sphere and it's not expiring soon
        if healTarget:BuffRemains(buffs.sphereOfHope) > 1000 then
            if healTarget:BuffRemains(buffs.sphereOfHope) > 10000 then return end

            -- Refresh early during enemy cooldowns
            if not as.enemyCds or cdsLessThan(5000) then return end

            Aware:displayMessage("Refreshing Sphere early in enemy CDS", "Monk", 1, GetSpellTexture(spell.id))
        end

        -- Check if another party member already has sphere
        local found = MakMulti.party:Find(function (party)
            if party:IsUnit(healTarget) then return end
            return party:Buff(buffs.sphereOfHope)
        end)

        if found and not found.dead then
            if found.hp < healTarget.hp then return end
            if found.hp - healTarget.hp < 20 then return end
        end

        -- Place healing sphere on healTarget
        if healTarget.ehp < 85 then
            return spell:Cast(healTarget)
        end
    end

    -- Damage sphere logic for PvP
    if target.exists and target.canAttack and not target.isFriendly then
        if not target.totalImmune and not target.magicImmune then
            if not target:Debuff(buffs.sphereOfDispear) then
                -- Check if target is under pressure
                local total, _, _, _, cds = target:AttackersV69()
                if total > 0 and cds >= 1 then
                    -- Ensure healing isn't urgent
                    if not healTarget or healTarget.hp >= 60 then
                        if player.manaPct > 50 or target.hp < 50 then
                            return Debounce("ZenSpheresPvP_" .. target.name, 1000, 10500, spell, target)
                        end
                    end
                end
            end
        end
    end
end)

ExpelHarm:Callback("melow-pvp", function(spell)
    if not healTarget then return end
    if not healTarget.isMe then return end
    if player:Buff(buffs.thunderFocusTea) then return end

    if healTarget.hp > 80 then return end

    Debounce("EXPELMELOW", 500, 4500, spell)
end)

ExpelHarm:Callback("top-pvp", function(spell)
    if not healTarget then return end
    if not healTarget.isMe or healTarget.hp > 80 then return end
    if healTarget.hp > 90 then return end
    if not player:Buff(buffs.topExpel) then return end
    if player:Buff(buffs.thunderFocusTea) then return end

    return spell:Cast()
end)

ExpelHarm:Callback("pvp", function(spell)
    if not healTarget then return end
    if not healTarget.isMe or healTarget.hp > 80 then return end
    if player.hp > 80 then return end
    if player:Buff(buffs.thunderFocusTea) then return end

    Debounce("PLAYERLOW", 500, 4500, spell)
end)

A[1] = function(icon)
    if A.AntiFakeCC:GetCooldown() == 0 then
        return A.AntiFakeCC:Show(icon)
    end
end

A[2] = function(icon)
    local castLeft, _, _, _, notKickAble = Unit("target"):IsCastingRemains()
    if castLeft == 0 then return end

    if A.AntiFakeKick:GetCooldown() == 0 and not notKickAble then
        return A.AntiFakeKick:Show(icon)
    end
end

A[3] = function(icon)
    FrameworkStart(icon)

    SetUpHealers()
    updategs()
    calculateHealTarget()

    -- Ensure healTarget is never nil to prevent nil access errors
    ensureHealTarget()

    defensives()

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[2] then
        if gs.summonActive then
            if player:TalentKnown(InvokeChiJi.id) then
                Aware:displayMessage("ChiJi Active!", "Monk", 1, GetSpellTexture(InvokeChiJi.id))
            else
                Aware:displayMessage("Yulon Active!", "Monk", 1, GetSpellTexture(InvokeYulon.id))
            end
        end
    end

    
    if A.GetToggle(2, "makDebug") and healTarget then
        MakPrint(1, "Disarm DR: ", player.disarmDr)
        MakPrint(2, "Boss: ", boss)
        MakPrint(3, "Combat: ", player.combat)
        local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
        MakPrint(4, "Combat Time: ", currentCombatTime)
        MakPrint(5, "Should Yulon: ", shouldYulon())
        MakPrint(6, "Cauldron:", boss and boss.cauldron())
        MakPrint(7, "BG start timer: ", GetBattlefieldInstanceRunTime())
        MakPrint(8, "Prep room timer: ", player:HasBuffFor(32727))
        MakPrint(9, "Harmony percent: ", aspectOfHarmonyPercent())
        MakPrint(10, "Cd Remains: ", as.enemyCdRemains)
        MakPrint(11, "CC remains : ", player.ccRemains)
        --MakPrint(12, "EvnM Cast Time: ", EnvelopingMist:CastTime())
        -- MakPrint(12, "Chi time: ", chiHarmonyRemains(healTarget))
        MakPrint(12, "Locked: ", player:HealLockedRemains())
    end

    if not A.IsInPvP then
        local channel = player.channelInfo
        if not player.channeling then
            makInterrupt(interrupts)
        end

        if channel then
            if channel.spellId ~= SoothingMist.id then return end
        end

        local healUnit = target.isFriendly and target or focus.isFriendly and focus or player

        stickSooM(healUnit)
        utility(healUnit)
        if gs.summonActive and makBurst() then
            if Action.Trinket1:IsReady() then return A.Trinket1:Show(icon) end
            if Action.Trinket2:IsReady() then return A.Trinket2:Show(icon) end
        end

        -- Season 3 Dual Rotation System
        if gs.has2SetBonus then
            -- Use optimized dual rotation system
            dualRotationHealing(healUnit)
        else
            -- Fallback to traditional rotation
            healing(healUnit)
        end
        if target.exists and not target.isFriendly then
            damage()
        end
    else
        local _ = player.stayTime
        if player:Buff(32727) then
            ThunderFocusTea("prep-room")
            if aspectOfHarmonyPercent() < 49 and player:HasBuffCount(buffs.jadeEmpowerment) >= 1 then
                SoothingMist("prep-room")
                EnvelopingMist("prep-room")
                Vivify("prep-room")
            end

            return FrameworkEnd()
        end

        if not target.exists then
            if not healTarget then return FrameworkEnd() end
            if healTarget.hp > 95 then 
                RenewingMist("arenaGates")
                return FrameworkEnd() 
            end
        end
    
        if target.exists and target.canAttack then
            -- We always wanna insta KILL BECAUSE WE MAD BOIS
            TouchOfDeath(target)
        end

        -- Season 3 PvP Priority System
        if gs.has2SetBonus then
            ThunderFocusTea("season3-priority")
            if gs.conduitOfCelestials then
                SheilunsGift("season3-priority", healTarget)
            end
        end

        -- Dual Rotation System for PvP
        if shouldFistweaveHybrid() then
            -- Fistweaving Priority: Damage abilities with healing conversion
            LifeCocoon("pvp")
            InvokeChiJi("pvp")
            ZenSpheres("pvp")
            RushingWindKick("pvp", target)
            CracklingJadeLightning("pvp")
            RisingSunKick("pvp", target)
            if target.exists and target.canAttack then
                TigerPalm("season3-harmonic") -- Season 3 Harmonic Surge priority
                BlackoutKick("pvp", target)
                TigerPalm("pvp", target)
            end
            -- Emergency healing only
            Restoral("pvp")
            EnvelopingMist("instant-pvp")
            Vivify("bigvv-pvp")
        else
            -- Traditional Mistweaving Priority: Direct healing focus
            LifeCocoon("pvp")
            SheilunsGift("pvp", healTarget)
            Restoral("pvp")
            EnvelopingMist("soothing")
            Vivify("soothingCast")
            InvokeChiJi("pvp")
            Vivify("bigvv-pvp")
            EnvelopingMist("instant-pvp")
            SoothingMist("pvp")
            ExpelHarm("top-pvp")
            Vivify("bigvv-dropping-soon")
            -- Damage abilities for pressure
            if target.exists and target.canAttack then
                ZenSpheres("pvp")
                RushingWindKick("pvp", target)
                CracklingJadeLightning("pvp")
                BlackoutKick("pvp", target)
                TigerPalm("pvp", target)
            end
        end
        -- RenewingMist("chi-pvp")
        ManaTea("pvp")
        ZenSpheres("pvp")
        ExpelHarm("melow-pvp")
    
        --RenewingMist("pvp")
        --EnvelopingMist("noTFT")
        Vivify("pvp")

        --EnvelopingMist("pvp")
        ExpelHarm("pvp")
        RenewingMist("arenaGates")
    end

    return FrameworkEnd()
end

TouchOfDeath:Callback("arena", function(spell, enemy)
    if not enemy.exists then return end
    if enemy.dead then return end
    if not TouchOfDeath:InRange(enemy) then return end
    
    if player:Debuff(SearingGlare) then return end

    if enemy:Buff("Guardian Spirit") then return end
    if enemy.hp > 15 then return end

    return spell:Cast(enemy)
end)

Detox:Callback("arena", function (spell, unit)
    if not healTarget then return end
    if player.cc then return end

    if gs.actualLowest.hp < 40 then return end
    
    if gs.actualLowest.hp < 70 and as.enemyCds then return end

    if unit:Debuff("Unstable Affliction") and (gs.actualLowest.hp < 80 or as.enemyCds) then return end
    if unit:Debuff("Vampiric Touch") and (gs.actualLowest.hp < 70 or as.enemyCds) then return end
    if unit:Debuff(203337) then return end

    if unit:HasDeBuffFromFor(ccDispelList, shortHalfSecond, true) then
        if spell:Cast(unit) then 
            Aware:displayMessage("Detox on " .. unit.name, 'Monk', 1.5, GetSpellTexture(spell.id))
            return true
        end
    end

    if unit:Debuff("Unstable Affliction") then return end
    if unit:Debuff("Vampiric Touch") then return end

    if player:Buff(buffs.harmonyActive) then return end
    if aspectOfHarmonyPercent() > 40 and RushingWindKick.cd < 1000 
        and ThunderFocusTea.cd < 1000 then 
            if target.canAttack and target.distance < 20 and not target.magicImmune then return end
            return 
    end

    if target.exists and target.canAttack and target.hp < 40 then return end

    if not unit:IsUnit(gs.actualLowest) and (gs.actualLowest.hp < 60 or player.manaPct < 40) then return end
    -- (388874) = Improved Detox
    if player:TalentKnown(388874) and unit:HasDeBuffFor("Devouring Plague") > shortHalfSecond then
        if spell:Cast(unit) then 
            Aware:displayMessage("Detox on " .. unit.name, 'Monk', 1.5, GetSpellTexture(spell.id))
            return true
        end
    end

    -- (353502) = Counteract Magic
    local isCounterMagic = IsPlayerSpell(353502)
    if isCounterMagic and unit:IsUnit(healTarget) and unit:HasDeBuffFromFor(counterMagicDispelList, shortHalfSecond, true) then
        if spell:Cast(unit) then
            Aware:displayMessage("Detox for counter magic on " .. unit.name, 'Monk', 1.5, GetSpellTexture(spell.id))
            return true
         end
    end

    if healTarget.hp > 80 and unit:HasDeBuffFromFor(counterMagicDispelList, shortHalfSecond, true) then
        if spell:Cast(unit) then 
            Aware:displayMessage("Detox on " .. unit.name, 'Monk', 1.5, GetSpellTexture(spell.id))
            return true
         end
    end
end)

local isDisarmed = AtoL({
    236077, -- Disarmed
    207777, -- Dismantle
    233759, -- Grapple Weapon
    209749, -- Faerie Swarm
    236077, -- Disarm
})

GrappleWeapon:Callback("arena", function(spell, enemy)
    if not enemy.exists then return end
    if enemy.isHealer or enemy.isCaster then return end
    
    if player:Debuff("Searing Glare") then return end
    if enemy:Buff(446035) then return end

    local classId = enemy:ClassID()
    if classId == 11 or classId == 10 or classId == 2 then return end

    local specId = enemy.specId
    if specId == 253 then return end

    if enemy.cc then return end
    if not enemy.cds then return end
    if enemy:CdsRemain() < 3000 then return end
    if enemy:Buff("Bladestorm") then return end
    if enemy:DebuffFrom(isDisarmed) then return end
    if enemy.disarmDr ~= 1 then return end

    if healTarget and (healTarget:Buff(buffs.lifeCocoon) or cocoonInFlight(healTarget))  then return end

    if Debounce("GRAPPLECDS" .. enemy.name, 500, 4500, spell, enemy) then
        Aware:displayMessage("Grapple weapon on  " .. enemy.name, 'DeathKnight', 1.5, GetSpellTexture(spell.id))
    end
end)

                                                                                                                                                                                                    local damKickList = AtoL({
                                                                                                                                                                                                        "Chaos Bolt",
                                                                                                                                                                                                        "Lava Burst",
                                                                                                                                                                                                        "Haunt",
                                                                                                                                                                                                        "Mind Flay: Insanity",
                                                                                                                                                                                                        "Unstable Affliction",
                                                                                                                                                                                                        "Crackling Jade Lightning",
                                                                                                                                                                                                        "Soul Rot",
                                                                                                                                                                                                        "Stormkeeper",
                                                                                                                                                                                                        "Lightning Lasso",
                                                                                                                                                                                                        "Full Moon",
                                                                                                                                                                                                        "Ray of Frost",
                                                                                                                                                                                                        "Frostfire Bolt",
                                                                                                                                                                                                        "Vampiric Touch",
                                                                                                                                                                                                        "Hand of Gul'dan",
                                                                                                                                                                                                        "Disintegrate",
                                                                                                                                                                                                        "Void Torrent",
                                                                                                                                                                                                    })

SpearHandStrike:Callback("arena", function(spell, enemy)
    if not enemy.exists then return end
    if not enemy.player then return end
    if not enemy:IsSafeToKick() then return end

    local castOrChannel = enemy.castOrChannelInfo
    if not castOrChannel then return end -- Ensure castOrChannelInfo exists

    if not arenaKicks[castOrChannel.spellId] and castOrChannel.name ~= "Crackling Jade Lightning" then 
        if enemy.isHealer then return end
        if not damKickList[castOrChannel.name] then return end
     end

    if not castOrChannel.channel and castOrChannel.percent < kickPercent then return end
    if castOrChannel.channel and castOrChannel.elapsed < channelKickTime then return end

    return spell:Cast(enemy)
end)

Paralysis:Callback("arena", function(spell, enemy)
    if player:Debuff("Searing Glare") then return end
    if healTarget and healTarget.ehp < 20 then return end
    if not enemy.exists or not target then return end
    if enemy:IsUnit(target) then return end
    if not enemy.isHealer then return end
    -- If we have a hunter don't incap
    --if MakMulti.party:Any(function(friendly) 
    --    local classId = friendly:ClassID()
    --    return classId == 3 or classId == 8
    --end) then return end
		
    if enemy.ccImmune then return end
    if enemy.totalImmune then return end
    if enemy.magicImmune then return end
    if enemy.cc and enemy:CCRemains() > 1500 then return end
    --local total, _, _, _, cds = enemy:AttackersV69()
    --if total > 0 then return end

    if enemy:Debuff("Feral Frenzy") then return end

    if target.hp < 80 and enemy.incapacitateDr == 1 then
        Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
        return spell:Cast(enemy)
    end

    if target.hp < 40 and enemy.incapacitateDr >= .5 and enemy.incapacitateDrRemains > 6000 then
        Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
        return spell:Cast(enemy)
    end

    if (target.hp < 20 and enemy.castOrChannelInfo) and enemy.incapacitateDr >= .25 and enemy.incapacitateDrRemains > 13000 then
        Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
        return spell:Cast(enemy)
    end
end)

                                                                                                                                                                                                    Paralysis:Callback("withHunt", function(spell, enemy)
                                                                                                                                                                                                        if player:Debuff("Searing Glare") then return end
                                                                                                                                                                                                        if healTarget and healTarget.ehp < 20 then return end
                                                                                                                                                                                                        if not enemy.exists then return end
                                                                                                                                                                                                        if enemy:IsUnit(target) then return end
                                                                                                                                                                                                        if enemy.isHealer then return end
                                                                                                                                                                                                        if not target then return end
                                                                                                                                                                                                        -- If we have a hunter don't incap
                                                                                                                                                                                                        if not MakMulti.party:Any(function(friendly)
                                                                                                                                                                                                            return friendly:ClassID() == 3
                                                                                                                                                                                                        end) then return end
                                                                                                                                                                                                            
                                                                                                                                                                                                        if enemy.ccImmune then return end
                                                                                                                                                                                                        if enemy.totalImmune then return end
                                                                                                                                                                                                        if enemy.magicImmune then return end
                                                                                                                                                                                                        if enemy.cc and enemy:CCRemains() > 1500 then return end
                                                                                                                                                                                                        local total, _, _, _, cds = enemy:AttackersV69()
                                                                                                                                                                                                        if total > 0 then return end

                                                                                                                                                                                                        if enemy:Debuff("Feral Frenzy") then return end
                                                                                                                                                                                                        if enemy.incapacitateDr < 0.5 then return end

                                                                                                                                                                                                        if target.hp < 80 and enemy.incapacitateDr == 1 then
                                                                                                                                                                                                            Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
                                                                                                                                                                                                            return spell:Cast(enemy)
                                                                                                                                                                                                        end

                                                                                                                                                                                                        if target.hp < 40 and enemy.incapacitateDr >= .5 and enemy.incapacitateDrRemains > 6000 then
                                                                                                                                                                                                            Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
                                                                                                                                                                                                            return spell:Cast(enemy)
                                                                                                                                                                                                        end

                                                                                                                                                                                                        if (target.hp < 20 and enemy.castOrChannelInfo) and enemy.incapacitateDr >= .25 and enemy.incapacitateDrRemains > 13000 then
                                                                                                                                                                                                            Aware:displayMessage("Incap on  " .. enemy.name, 'Monk', 1.5, GetSpellTexture(spell.id))
                                                                                                                                                                                                            return spell:Cast(enemy)
                                                                                                                                                                                                        end
                                                                                                                                                                                                    end)

local function enemyRotation(enemy)
    if not enemy.exists then return end

    TouchOfDeath("arena", enemy)  -- ✅
    SpearHandStrike("arena", enemy) -- ✅
    Paralysis("arena", enemy)  -- ✅
    GrappleWeapon("arena", enemy) -- ✅
end

local function partyRotation(team)
    if not team.exists then return end

    Detox("arena", team) -- ✅
end

A[6] = function(icon)
    RegisterIcon(icon)
    if A.IsInPvP then
        enemyRotation(arena1)
    end

    if cancelSooM() then StopCasting() end
    if cancelManaTea() then StopCasting() end
    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    partyRotation(party1)

    return FrameworkEnd()
end

-- [7] is Passive rotation (limited actions, usually @raid2, @party2, @arena2)
A[7] = function(icon)
	RegisterIcon(icon)
    if A.IsInPvP then
        enemyRotation(arena2)
    end

    partyRotation(party2)

	return FrameworkEnd()
end

-- [8] is Passive rotation (limited actions, usually @raid3, @party3, @arena3)
A[8] = function(icon)
	RegisterIcon(icon)
    
    if A.IsInPvP then
        enemyRotation(arena3)
    end
    partyRotation(party3)

	return FrameworkEnd()
end

-- [9] is Passive rotation (limited actions, usually @raid4, @party4)
A[9] = function(icon)
	RegisterIcon(icon)
    partyRotation(party4)
    
	return FrameworkEnd()
end

-- [10] is Passive rotation (limited actions, usually @raid5, @player)
A[10] = function(icon)
	RegisterIcon(icon)
    partyRotation(player)

	return FrameworkEnd()
end
