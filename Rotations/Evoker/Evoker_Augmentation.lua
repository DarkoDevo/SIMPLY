if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 1473 then return end

--[[
tryign to cast source of magic on ppl out of range
]]--


local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local cacheContext     = MakuluFramework.Cache
local ConstUnit        = MakuluFramework.ConstUnits
local MakGcd           = MakuluFramework.gcd

local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local HealingEngine    = Action.HealingEngine

local MakuluFunctions     = MakuluFramework.OLD
local EnemiesInSpellRange = MakuluFunctions.EnemiesInSpellRange

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable

local ActionID       = {
    Landslide = { ID = 358385 },
    ObsidianScales = { ID = 363916 },
    Expunge = { ID = 365585, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    VerdantEmbrace = { ID = 360995, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Quell = { ID = 351338 },
    CauterizingFlame = { ID = 374251, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    TiptheScales = { ID = 370553 },
    SleepWalk = { ID = 360806 },
    RenewingBlaze = { ID = 374348 },
    Unravel = { ID = 368432 },
    OppressingRoar = { ID = 372048 },
    Rescue = { ID = 370665 },
    SourceofMagic = { ID = 369459, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    SpatialParadox = { ID = 406732 },
    TimeSpiral = { ID = 374968 },
    Zephyr = { ID = 374227 },

    EbonMight = { ID = 395152 },
    Eruption = { ID = 395160 },
    BreathofEons = { ID = 403631 },
    ScaleBreathofEons = { ID = 442204 },
    Timelessness = { ID = 412710 },
    BestowWeyrnstone = { ID = 408233 },
    BlisteringScales = { ID = 360827, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Prescience = { ID = 409311, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    TimeSkip = { ID = 404977 },

    NullifyingShroud = { ID = 378464 },
    DreamProjection = { ID = 377509 },
    SwoopUp = { ID = 370388 },
    ChronoLoop = { ID = 383005 },
    TimeStop = { ID = 378441 },

    AzureStrike = { ID = 362969 },
    FuryoftheAspects = { ID = 390386 },
    Return = { ID = 361227 },
    BlessingoftheBronze = { ID = 364342 },
    Hover = { ID = 358267 },
    ChronoFlames = { ID = 431443, FixedTexture = 4622464 },
    EmeraldBlossom = { ID = 355913, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    FireBreath = { ID = 357208 },
    LivingFlame = { ID = 361469, FixedTexture = 4622464 },

    BlackAttunement = { ID = 403264 },
    SensePower = { ID = 361021 },
    Upheavel = { ID = 396286 },
    BronzeAttunement = { ID = 403265 },
    InterwovenThreads = { ID = 412713 },

    WingBuffet = { ID = 357214 },
    TailSwipe = { ID = 368970 },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    ArenaPreparation = { ID = 32727, Hidden = true },

}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_EVOKER_AUGMENTATION] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local lastCastTime = GetTime() * 1000

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
local mouseover = ConstUnit.mouseover
local pet

local party = MakMulti.party
local enemies = MakMulti.enemies
local activeEnemies = MakMulti.activeEnemies

local gameState = {}

local buffs = {
    blistering_scales = 360827,
    source_of_magic = 369459,
    prescience = 410089,
    ebon_might = 395296,
    tip_the_scales = 370553,
    hover = 358267,
    zephyr = 374227,
    obsidian_scales = 363916,
    black_attunement = 403264,
    bronze_attunement = 403265,
    nourishing_sands = 406043,
    blessing_of_the_bronze = 381748,

    essence_burst = 392268, -- equpotion free
    trembling_earth = 424368, -- eruption triggers smaller equptions

    spatial_paradox = 406732,
}

local debuffs = {
    sleep_walk = 360806,
}

local function num(val)
    if val then return 1 else return 0 end
end

local function GetTimeSinceLastCast()
    if lastCastTime == 0 then
        return 99999999
    end

    local currentTime = GetTime() * 1000
    local timeSinceCast = currentTime - lastCastTime
    return timeSinceCast
end

--[[Player:AddTier("Tier31", { 207281, 207279, 207284, 207280, 207282, })
local T31has2P = Player:HasTier("Tier31", 2)
local T31has4P = Player:HasTier("Tier31", 4)]]

local interrupts = {
    {spell = Quell, minPercent = 50, isCC = false },
    {spell = WingBuffet, minPercent = 50, isCC = false, aoe = true},
    {spell = TailSwipe, minPercent = 50, isCC = true, aoe = true},
    {spell = SleepWalk, minPercent = 50, isCC = true },
}

local function shouldBurst()
    if A.BurstIsON("target") then
        if A.Zone ~= "arena" or A.Zone ~= "pvp" then
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if enemy.ttd >= 20000 then
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

local empowered_start = 0
local empowered_spell_id = 0

local function GetEmpoweredStage()
    if empowered_start == 0 or empowered_spell_id == 0 then
        return 0
    end

    local currentTime = GetTime()
    local elapsedTime = currentTime - empowered_start

    for i = 1, 4 do
        local stageDuration = GetUnitEmpowerStageDuration("player", i - 1) / 1000
        if elapsedTime <= stageDuration then
            return i
        end
        elapsedTime = elapsedTime - stageDuration
    end

    return 4
end

local healer_extend_spells = {
    [740] = true, -- Tranq (RD)
    [115310] = true, -- Revival (MW)
    [388615] = true, -- Restoral (MW)
}
local isCastingHealerExtend = false

local function OnUnitSpellcast(self, event, unitTarget, castGUID, spellID)
    if UnitIsFriend("player", unitTarget) then
        if event == "UNIT_SPELLCAST_START" then
            if healer_extend_spells[spellID] then
                isCastingHealerExtend = true
            end
        elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
            if healer_extend_spells[spellID] then
                isCastingHealerExtend = false
            end
        end
    end
end

local function OnEmpoweredSpell(...)
    local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

    if sourceGUID ~= UnitGUID("player") then return end

    if spellID == 357208 or spellID == 396286 then
        if eventType == "SPELL_EMPOWER_START" then
            empowered_spell_id = spellID
            empowered_start = GetTime()
        elseif eventType == "SPELL_EMPOWER_END" or eventType == "SPELL_CAST_FAILED" or eventType == "SPELL_EMPOWER_INTERRUPT" then
            empowered_start = 0
            empowered_spell_id = 0
        end
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        OnEmpoweredSpell(CombatLogGetCurrentEventInfo())
    elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
        OnUnitSpellcast(self, event, ...)
    end
end)

eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")


local function updateGameState()
    player = MakUnit:new("player")
    --target = MakUnit:new("target")
    --focus = MakUnit:new("focus")
    --mouseover = MakUnit:new("mouseover")

    local inInstance, instanceType = IsInInstance()

    gameState = {
        isMoving = player.moving,
        inCombat = player.inCombat,
        stayTime = player.stayTime,
        inInstance = inInstance,
        inDungeon = inInstance and (instanceType == "party" or instanceType == "scenario"),
        inRaid = inInstance and instanceType == "raid",
        isPvP = A.Zone ~= "arena" or A.Zone ~= "pvp",
        wantedTarget = nil,
        wantedSlot = nil,
        wantBlessingOfBronze = false,
        can_cast_move = player:Buff(buffs.hover) or player:Buff(buffs.spatial_paradox),
        can_cast_move_emp = player:Buff(buffs.tip_the_scales),
    }
    --Tank
    if ConstUnit.tank and ConstUnit.tank.exists and not ConstUnit.tank:Buff(buffs.blistering_scales) and BlisteringScales:ReadyToUse() and BlisteringScales:InRange(ConstUnit.tank) then
        HealingEngine.SetTarget(ConstUnit.tank:CallerId(), 2)
        return
    end

    -- Healer
    if ConstUnit.healer and ConstUnit.healer.exists and not ConstUnit.healer:Buff(buffs.source_of_magic) and SourceofMagic:ReadyToUse() and Prescience:InRange(ConstUnit.healer) then
        HealingEngine.SetTarget(ConstUnit.healer:CallerId(), 2)
        return
    end

    -- DPS
    if Prescience:ReadyToUse() then
        local slots = {"party1", "party2", "party3", "party4", "player" }
        if gameState.inRaid then
            slots = {"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10", "raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20", "raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30", "raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"}
        end
        local top_dps = -1
        local top_dps_unit = nil
        for _, slot in ipairs(slots) do
            local unit = MakUnit:new(slot)
            if unit.exists and not unit.dead and not unit:Buff(buffs.prescience) and focus:BuffRemains(buffs.prescience) == 0 and Prescience:InRange(unit) and unit:PvEGroupRole() == "DAMAGER" then
                local dps_total = A.CombatTracker:GetRealTimeDPS(unit:CallerId())
                if dps_total > top_dps then
                    top_dps = dps_total
                    top_dps_unit = unit
                end
            end
        end

        if top_dps_unit then
            HealingEngine.SetTarget(top_dps_unit:CallerId(), 2)
        end
        
    end
end

BlisteringScales:Callback("pve-dung-focus-tank", function(spell)
    if not gameState.inDungeon and not gameState.inRaid then return end
    if not focus.exists then return end
    if not focus.isTank and UnitGroupRolesAssigned(focus:CallerId()) ~= "TANK" then return end
    if focus:Buff(buffs.blistering_scales, true) then return end

    return spell:Cast(focus)
end)

BlisteringScales:Callback("pve-solo", function(spell)
    if gameState.inDungeon or gameState.inRaid then return end
    if not focus.exists then return end
    if player:Buff(buffs.blistering_scales) then return end

    return spell:Cast(player)
end)

BlisteringScales:Callback("pve-raid", function(spell)
    if not gameState.inRaid then return end
    if focus and focus.exists and focus.isTank and not focus:Buff(buffs.blistering_scales) then
        return spell:Cast(focus)
    end
end)

SourceofMagic:Callback("pve-raid", function(spell)
    if not Prescience:InRange(focus) then return end
    if not gameState.inRaid then return end
    if not focus.exists then return end
    if not focus.isHealer and UnitGroupRolesAssigned(focus:CallerId()) ~= "HEALER" then return end
    if focus:Buff(buffs.source_of_magic, true) then return end

    return spell:Cast(focus)
end)

SourceofMagic:Callback("pve-dung-focus-healer", function(spell)
    if not Prescience:InRange(focus) then return end
    if not gameState.inDungeon and not gameState.inRaid then return end
    if not focus.exists then return end
    if not focus.isHealer and UnitGroupRolesAssigned(focus:CallerId()) ~= "HEALER" then return end
    if focus:Buff(buffs.source_of_magic, true) then return end

    return spell:Cast(focus)
end)

Prescience:Callback("pve-dung-focus-dps", function(spell)
    if not gameState.inDungeon and not gameState.inRaid then return end
    if not focus.exists then return end
    local role = UnitGroupRolesAssigned(focus:CallerId())
    if role == "TANK" or role == "HEALER" then return end
    if focus:Buff(buffs.prescience) ~= nil then return end
    if focus:BuffRemains(buffs.prescience) > 0 then return end

    return spell:Cast(focus)
end)

Prescience:Callback("pve", function(spell)
    local curTarget = focus
    if target.exists and target.isFriendly then
        curTarget = target
    end

    if curTarget.exists and not curTarget:Buff(buffs.prescience) and focus:BuffRemains(buffs.prescience) == 0 and curTarget.isFriendly and not curTarget.dead then
        return spell:Cast(curTarget)
    end
end)

Prescience:Callback("pve-raid", function(spell)
    if not gameState.inRaid or focus.exists then return end
    if not focus.exists then return end
    if focus.isHealer or focus.isTank or focus.isMe then return end
    if focus:Buff(buffs.prescience) ~= nil then return end
    if focus:BuffRemains(buffs.prescience) > 0 then return end

    return spell:Cast(focus)
end)

EbonMight:Callback("pve-dung", function(spell)
    if not gameState.inDungeon and not gameState.inRaid then return end
    if gameState.stayTime < 1 and not gameState.can_cast_move then return end
    if not gameState.inCombat then return end
    if not Eruption:InRange(target) then return end

    if shouldBurst() then
        return spell:Cast()
    end
end)

EbonMight:Callback("pve-solo", function(spell)
    if gameState.stayTime < 1 and not gameState.can_cast_move then return end
    if not Eruption:InRange(target) then return end

    if shouldBurst() then
        return spell:Cast()
    end
end)

BreathofEons:Callback("pve-dung", function(spell)
    --if not gameState.inDungeon and not gameState.inRaid then return end
    if gameState.stayTime < 1 then return end
    if not gameState.inCombat then return end
    if not player:Buff(buffs.ebon_might) then return end
    if not Eruption:InRange(target) then return end
    if BreathofEons.cd > 0 or GetTimeSinceLastCast() < 2500 then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

ScaleBreathofEons:Callback("pve-dung", function(spell)
    --if not gameState.inDungeon and not gameState.inRaid then return end
    if gameState.stayTime < 1 then return end
    if not gameState.inCombat then return end
    if not player:Buff(buffs.ebon_might) then return end
    if not Eruption:InRange(target) then return end
    if ScaleBreathofEons.cd > 0 or GetTimeSinceLastCast() < 2500 then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

TiptheScales:Callback("pve", function(spell)
    if not Eruption:InRange(target) then return end
    if not shouldBurst() then return end
    if not FireBreath:ReadyToUse() then return end
    if player:BuffRemains(buffs.ebon_might, true) < 1 then return end

    return spell:Cast(player)
end)

FireBreath:Callback("pve-tts", function(spell)
    if not Eruption:InRange(target) or spell.cd > 0 then return end
    if not player:Buff(buffs.tip_the_scales) then return end
    if player:BuffRemains(buffs.ebon_might, true) < 1 then return end

    if EbonMight:ReadyToUse() and shouldBurst() then
        return spell:Cast()
    elseif not EbonMight:ReadyToUse() and EbonMight.cd >= 5500 then
        return spell:Cast()
    end
end)

FireBreath:Callback("pve", function(spell)
    if gameState.stayTime < 1 or spell.cd > 0 or gameState.can_cast_move_emp then return end
    if not Eruption:InRange(target) then return end
    if player:BuffRemains(buffs.ebon_might, true) < 1 then return end
    if player:Buff(buffs.tip_the_scales) then return end

    return spell:Cast()
end)

Upheavel:Callback("pve", function(spell)
    if gameState.stayTime < 1 then return end
    if not Upheavel:InRange(target) then return end
    if player:Buff(buffs.tip_the_scales) then return end
    if player:BuffRemains(buffs.ebon_might, true) < 1 then return end

    return spell:Cast(target)
end)

Eruption:Callback("pve-ebon", function(spell)
    if gameState.stayTime < 0.5 and not gameState.can_cast_move then return end
    if not Eruption:InRange(target) then return end
    if not player:Buff(buffs.ebon_might) then return end

    return spell:Cast(target)
end)

Eruption:Callback("pve", function(spell)
    if gameState.stayTime < 0.5 and not gameState.can_cast_move then return end
    if not Eruption:InRange(target) then return end

    return spell:Cast(target)
end)

LivingFlame:Callback("pve", function(spell)
    if gameState.stayTime < 0.5 and not gameState.can_cast_move then return end
    if not LivingFlame:InRange(target) then return end

    return spell:Cast(target)
end)

AzureStrike:Callback("pve", function(spell)
    if not AzureStrike:InRange(target) then return end

    return spell:Cast(target)
end)

ObsidianScales:Callback("pve", function(spell)
    if player:Buff(buffs.obsidian_scales) or player:Buff(buffs.renewing_blaze) then return end

    if shouldDefensive() or player.hp < 60 then
        return spell:Cast()
    end
end)

RenewingBlaze:Callback("pve", function(spell)
    if player.hp >= 50 then return end
    if player:Buff(buffs.obsidian_scales) or player:Buff(buffs.renewing_blaze) then return end

    if shouldDefensive() or player.hp < 60 then
        return spell:Cast()
    end
end)

EmeraldBlossom:Callback("pve", function(spell)
    if not focus.exists then return end
    if player.combatTime < 1 then return end

    if focus.hp <= 80 and player:Buff(buffs.nourishing_sands) then
        return spell:Cast(focus)
    end

    if player:BuffRemains(buffs.nourishing_sands) < 2 and focus.hp < 100 then
        return spell:Cast(focus)
    end

    if not player:Buff(buffs.nourishing_sands) and focus.hp < 70 then
        return spell:Cast(focus)
    end
end)

BlessingoftheBronze:Callback("pve", function(spell)
    if not gameState.wantBlessingOfBronze then return end

    return spell:Cast(focus)
end)

SpatialParadox:Callback("pve", function(spell)
    if not isCastingHealerExtend then return end

    Aware:displayMessage("Extending Healer CD Range", "Evoker", 3, "ability_evoker_stretchtime")
    return spell:Cast()
end)

Zephyr:Callback("pve", function(spell)
    if not gameState.inCombat then return end
    if player:Buff(buffs.zephyr) then return end
    if not shouldDefensive() then return end

    return spell:Cast()
end)

Unravel:Callback("pve", function(spell)
    if target.shield == 0 then return end

    return spell:Cast(target)
end)

VerdantEmbrace:Callback("pve", function(spell)
    if not focus.exists then return end
    if not focus:IsMe() then return end
    if focus.hp >= 50 then return end

    return spell:Cast(player)
end)

TimeSkip:Callback("pve", function(spell)
    if gameState.stayTime < 1 then return end
    if player:TalentKnown(412713) then return end -- Interwoven Threads
    if EbonMight.cd < 4000 then return end
    if Upheavel.cd < 4000 then return end
    if FireBreath.cd < 4000 then return end
    if BreathofEons.cd < 4000 then return end

    return spell:Cast(player)
end)

Hover:Callback("pve", function(spell)
    if not gameState.inCombat then return end
    if player:Buff(buffs.hover) or player:Buff(buffs.spatial_paradox) then return end
    if player.moveTime < 1500 then return end

    return spell:Cast(player)
end)

BlisteringScales:Callback("pvp", function(spell)
    if not gameState.inPvP then return end
    if focus and focus.exists and not focus:Buff(buffs.blistering_scales) then
        return spell:Cast(focus)
    end
end)

MakuluFramework.firstLoop = true
A[3] = function(icon)
    local empStage = GetEmpoweredStage()
    if empStage == 3 and empowered_spell_id == 357208 then
        return A.FireBreath:Show(icon)
    elseif empStage == 1 and empowered_spell_id == 357208 and player:TalentKnown(459725) then -- Molten Embers
        return A.FireBreath:Show(icon)
    elseif empowered_spell_id == 396286 then
        local isr = EnemiesInSpellRange(A.Eruption)
        if empStage >= isr or empStage > 3 then
            return A.Upheavel:Show(icon)
        end
    end

    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end

	FrameworkStart(icon)
    updateGameState()

    focus = MakUnit:new("focus")

    MakPrint(1, "Focus Pre: ", focus:BuffRemains(buffs.prescience))

    makInterrupt(interrupts)

    Zephyr("pve")

    if focus and focus.exists then
        BlisteringScales("pve-dung-focus-tank")
        if SourceofMagic.isKnown and SourceofMagic.cooldown == 0 and not focus:Buff(buffs.source_of_magic) and UnitGroupRolesAssigned(focus:CallerId()) == "HEALER" and BlisteringScales:InRange(focus) then
            return A.SourceofMagic:Show(icon)
        end

        --Prescience("pve-dung-focus-dps")
        --BlisteringScales("pve-raid")
    end

    BlessingoftheBronze("pve")
    BlisteringScales("pve-solo")
    BlisteringScales("pvp")

    
    --Prescience("pve-raid")
    Prescience("pve")

    if target.exists and target.canAttack then
        -- Defensive
        ObsidianScales("pve")
        RenewingBlaze("pve")
        EmeraldBlossom("pve")
        VerdantEmbrace("pve")
        -- Oppressing Roar - increase all CC infront of you

        -- Burst
        TimeSkip("pve")
        EbonMight("pve-dung")
        EbonMight("pve-solo")
        TiptheScales("pve")
        FireBreath("pve-tts")
        Hover("pve")

        -- DPS
        Unravel("pve")
        FireBreath("pve")
        BreathofEons("pve-dung")
        ScaleBreathofEons("pve-dung")
        Upheavel("pve")
        Eruption("pve-ebon")
        Eruption("pve")
        LivingFlame("pve")
        AzureStrike("pve")
    end

	return FrameworkEnd()
end

Quell:Callback("arean-rot", function(spell, who)
    if not gameState.inPvP then return end
    if not who.pvpKick then return end

    Aware:displayMessage("Quell " .. who.name, "Evoker", 1, "abilityP_evoker_stretchtime")
    return spell:Cast(who)
end)

SleepWalk:Callback("arean-rot", function(spell, who)
    --if gs.imCasting and gs.imCasting == spell.id then return end
    if not gameState.inPvP then return end
    local sleepWalkExists = MakMulti.arena:Any(function(unit) return unit:DebuffRemains(debuffs.sleep_walk, true) > SleepWalk:CastTime() + MakGcd() end)
    if sleepWalkExists then return end
    if who:IsCCImmune() then return end
    if target.hp < 30 then return end
    if who.isTarget then return end
    if who.hp < 50 then return end
    if who:CCRemains() > spell:CastTime() + MakGcd() then return end
    if who.disorientDr < 0.5 then return end

    if who.isHealer then
        Aware:displayMessage("Sleep Walk " .. who.name .. " [Healer]", "Red", 1)
        return spell:Cast(who)
    end

    local partyDanger = MakMulti.party:Any(function(unit) return unit.hp > 0 and unit.hp < 50 end)
    if partyDanger and not who.isHealer and who.cds then
        Aware:displayMessage("Sleep Walk " .. who.name .. " [Peel]", "Red", 1)
        return spell:Cast(who)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if not enemy.player then return end
    if player.mounted then return end
    if player.stealthed then return end

    Quell("arean-rot", enemy)
    SleepWalk("arean-rot", enemy)
end

Expunge:Callback("partyrot", function(spell, who)
    if not who:HasDeBuffFromFor(MakLists.pvePoison, 250) then return end
    Aware:displayMessage("Expunge Remove DeBuff", "Evoker", 3, "ability_evoker_stretchtime")
    return spell:Cast(who)
end)

CauterizingFlame:Callback("partyrot", function(spell, who)
    if not who:HasDeBuffFromFor(MakLists.pvePoison, 250) and not who:HasDeBuffFromFor(MakLists.pveDisease, 250) and not who:HasDeBuffFromFor(MakLists.pveCurse, 250) and not who:HasDeBuffFromFor(MakLists.pveBleed, 250) then return end
    Aware:displayMessage("Cauterizing Flame Remove DeBuff", "Evoker", 3, "ability_evoker_stretchtime")
    return spell:Cast(who)
end)

local partyRotation = function(friendly)
    if not friendly.exists then return end
    Expunge("partyrot", friendly)
    CauterizingFlame("partyrot", friendly)
end

A[6] = function(icon)
	FrameworkStart(icon)
    --updateGameState()

    if GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end

	enemyRotation(MakUnit:new("arena1"))
	partyRotation(MakUnit:new("party1"))

	return FrameworkEnd()
end

A[7] = function(icon)
	FrameworkStart(icon)

	enemyRotation(MakUnit:new("arena2"))
	partyRotation(MakUnit:new("party2"))

	return FrameworkEnd()
end

A[8] = function(icon)
	FrameworkStart(icon)

	enemyRotation(MakUnit:new("arena3"))
	partyRotation(MakUnit:new("party3"))

	return FrameworkEnd()
end

A[9] = function(icon)
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena4"))
	partyRotation(MakUnit:new("party4"))

	return FrameworkEnd()
end

A[10] = function(icon)
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena5"))
	partyRotation(MakUnit:new("player"))

	return FrameworkEnd()
end
