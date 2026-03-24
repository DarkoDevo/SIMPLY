--[[
Restoration Shaman Rotation Updates:
- Ancestral Swiftness: Now used on cooldown (unless holding for ramp)
- Unleash Life: Used on cooldown (2 UL for every 1 AS)
- Riptide: Aggressive spreading during AS windows and for Whispering Waves
- Whispering Waves: Chain Heal lower priority, Healing Wave cleaves on Riptide targets
- Ramp Mode: Manual/Auto ramp functionality with Cloudburst Totem integration
- AS Consumption: Smart targeting (Healing Surge for ST, Chain Heal for 2+ targets)
- Healing Rain: Very low priority in Whispering Waves builds
]]

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 264 then return end

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
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local HealingEngine    = Action.HealingEngine

local CONST                               = Action.Const
local ACTION_CONST_STOPCAST               = CONST.STOPCAST

local BossMods         = Action.BossMods

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
    Regeneratin = { ID = 291944, Macro = "/cast [@player]Earth Shield" },
    BagOfTricks = { ID = 312411 },
    HyperOrganicLightOriginator = { ID = 312924 },
    
    -- Manual Ramp Trigger (using a dummy spell ID for UI purposes)
    RampTrigger = { ID = 999999, Texture = 443454, Hidden = false, Macro = "/run print('Ramp Started!')" },
    
    AstralRecall = { ID = 556 },
    AstralShift = { ID = 108271 },
    Bloodlust = { ID = 2825, MAKULU_INFO = { damageType = "magic" } },
    ChainLightning = { ID = 188443, MAKULU_INFO = { damageType = "magic" } },
    EarthbindTotem = { ID = 2484, MAKULU_INFO = { damageType = "magic" } },
    FarSight = { ID = 6196 },
    FlameShock = { ID = 470411, MAKULU_INFO = { damageType = "magic" } },
    FlametongueWeapon = { ID = 318038 },
    GhostWolf = { ID = 2645 },
    HealingSurge = { ID = 8004, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    LightningBolt = { ID = 188196, Texture = 29166, MAKULU_INFO = { damageType = "magic" } },
    LightningShield = { ID = 192106 },
    Skyfury = { ID = 462854 },
    WaterWalking = { ID = 546 },
    ChainHeal = { ID = 1064, FixedTexture = 133663, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    LavaBurst = { ID = 51505, MAKULU_INFO = { damageType = "magic" } },
    EarthShield = { ID = 974, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    EarthShieldP = { ID = 974, Texture = 291944, Hidden = false, Macro = "/cast [@player]Earth Shield" }, --Regenratin
    TidalWavesBuff = { ID = 53390, Hidden = true },
    WindShear = { ID = 57994, MAKULU_INFO = { damageType = "magic" } },
    FrostShock = { ID = 196840, MAKULU_INFO = { damageType = "magic" } },
    CapacitorTotem = { ID = 192058, MAKULU_INFO = { damageType = "magic" } },
    GustOfWind = { ID = 192063 },
    HealingStreamTotem = { ID = 5394 },
    EarthGrabTotem = { ID = 51485, MAKULU_INFO = { damageType = "magic" } },
    Purge = { ID = 370, MAKULU_INFO = { damageType = "magic" } },
    GreaterPurge = { ID = 378773, MAKULU_INFO = { damageType = "magic" } },
    EarthElemental = { ID = 198103 },
    CleanseSpirit = { ID = 51886 },
    TremorTotem = { ID = 8143 },
    Hex = { ID = 51514, MAKULU_INFO = { damageType = "magic" } },
    WindRushTotem = { ID = 192077, MAKULU_INFO = { damageType = "magic" } },
    SpiritwalkersGrace = { ID = 79206 },
    AncestralGuidance = { ID = 108281 },
    Thunderstorm = { ID = 51490, MAKULU_INFO = { damageType = "magic" } },
    LightningLasso = { ID = 305483, MAKULU_INFO = { damageType = "magic" } },
    TotemicProjection = { ID = 108287 },
    PoisonCleansingTotem = { ID = 383013 },
    TotemicRecall = { ID = 108285 },
    StoneBulwarkTotem = { ID = 108270, MAKULU_INFO = { damageType = "magic" } },
    
    AncestralVision = { ID = 212048 },
    WaterShield = { ID = 52127 },
    EarthlivingWeapon = { ID = 382021 },
    Riptide = { ID = 61295, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    HealingRain = { ID = 73920, Texture = 383222, MAKULU_INFO = { heal = true }, Macro = "/cast [@cursor] Healing Rain\n/cast [@cursor] Surging Totem\n/cast Downpour" },
    HealingWave = { ID = 77472, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    SpiritLinkTotem = { ID = 98008, MAKULU_INFO = { heal = true } },
    HealingTideTotem = { ID = 108280, MAKULU_INFO = { heal = true } },
    CloudburstTotem = { ID = 157153, MAKULU_INFO = { heal = true } },
    RecallCloudburstTotem = { ID = 201764, Texture = 223493, Macro = "/cast Recall Cloudburst Totem", MAKULU_INFO = { heal = true } },
    EarthenWallTotem = { ID = 198838, MAKULU_INFO = { heal = true } },
    AncestralProtectionTotem = { ID = 207399 },
    Ascendance = { ID = 114052, MAKULU_INFO = { heal = true } },
    UnleashLife = { ID = 73685, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    PrimordialWave = { ID = 428332, FixedTexture = 3578231, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Downpour = { ID = 462603, Texture = 383222, MAKULU_INFO = { heal = true } },
    PurifySpirit = { ID = 77130, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    ManaTideTotem = { ID = 16191 },
    Wellspring = { ID = 197995, MAKULU_INFO = { heal = true } },
    
    CounterstrikeTotem = { ID = 204331 },
    UnleashShield = { ID = 356736, MAKULU_INFO = { damageType = "magic" } },
    GroundingTotem = { ID = 204336 },
    StaticFieldTotem = { ID = 355580, MAKULU_INFO = { damageType = "magic" } },
    Burrow = { ID = 409293 },
    
    ElementalOrbit = { ID = 383010, Hidden = true },
    AcidRain = { ID = 378443, Hidden = true },
    ImprovedPurifySpirit = { ID = 383016, Hidden = true },
    TherazanesResilience = { ID = 1217622, Hidden = true },
    
    SurgingTotem = { ID = 444995, Texture = 383222, MAKULU_INFO = { damageType = "magic" } },
    TidecallersGuard = { ID = 457481, FixedTexture = 133667, Macro = "/cast spell:thisID" },
    
    NaturesSwiftness = { ID = 378081, Texture = 382550 },
    AncestralSwiftness = { ID = 443454, Texture = 382550 },
    
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
    
    ArenaPreparation = { ID = 32727, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_SHAMAN_RESTORATION] = A

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

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    below95 = 0,
    below90 = 0,
    below85 = 0,
    below80 = 0,
    below75 = 0,
    below70 = 0,
    partySize = 0,
    cloudburstHealing = 0,
    healingModifier = 0,
    rampActive = false,
    rampStartTime = 0,
    isWhisperingWaves = false,
}

local buffs = {
    arenaPreparation = 32727,
    waterShield = 52127,
    earthShieldOrbit = 383648,
    earthShield = 974,
    skyfury = 462854,
    ascendance = 114052,
    cloudburstTotem = 157504,
    spiritwalkersGrace = 79206,
    spatialParadox = 406732,
    primordialWave = 375986,
    healingRain = 73920,
    healingRainTotem = 456366,
    unleashLife = 73685,
    highTide = 288675,
    lavaSurge = 77762,
    naturesswiftness = 378081,
    ancestralswiftness = 443454,
    tidalWaves = 53390,
    downpour = 462488,
    riptide = 61295,
    whisperingWaves = 1217598,
}

local debuffs = {
    flameShock = 188389,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)
        if A.Zone == "arena" or thisUnit.realHP < 35 then return end
        
        local unitID = thisUnit.Unit
        
        -- Check if 'HE' should not be used based on certain conditions
        if thisUnit.Enabled then
            local unit = Action.Unit(unitID)
            
            -- Condition: Player is mounted
            local isPlayerMounted = Player:IsMounted()
            
            -- Condition: Unit is out of range (> 40 yards)
            local isUnitOutOfRange = unit:GetRange() > 40
            
            -- Buff IDs for Spirit of Redemption and Spirit of Redeemer
            local spiritOfRedemptionBuffID = 27827  -- Spirit of Redemption
            local spiritOfRedeemerBuffID = 215769   -- Spirit of Redeemer
            
            -- Condition: Unit has Spirit of Redemption or Spirit of Redeemer buff
            local unitHasSpiritBuff = unit:IsBuffUp(spiritOfRedemptionBuffID) or unit:IsBuffUp(spiritOfRedeemerBuffID)
            
            -- If any condition is true, disable 'thisUnit'
            if isPlayerMounted or unitHasSpiritBuff then --
                thisUnit.Enabled = false
            end
        end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function num(val)
    if val then return 1 else return 0 end
end

Player:AddTier("Tier31", { 217236, 217237, 217238, 217239, 217240, })

local interrupts = {
    { spell = WindShear },
    { spell = Thunderstorm, isCC = true, aoe = true, distance = 2 }
}

local function shouldBurst()
    if A.BurstIsON("target") then
        --if A.Zone ~= "arena" then
        --    local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --    for enemy in pairs(activeEnemies) do
        --        if ActionUnit(enemy):Health() > (LavaBurst:ToolTip()[1] * 20) or target.isDummy then
        --            return true
        --        end
        --    end
        --else
        return true
    end
    --end
    return false
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
-- Simple local throttle to avoid re-casting every frame/GCD
local _es_last = 0
local function ES_Throttled(window)
    window = window or 1.2         -- seconds
    return (GetTime() - _es_last) < window
end
local function ES_Stamp() _es_last = GetTime() end


local function InCombat()
    local p = ConstUnit and ConstUnit.player
    if p and p.InCombat and p:InCombat() ~= nil then
        return p:InCombat()
    end
    if MakuluFramework and MakuluFramework.Combat and MakuluFramework.Combat.IsInCombat then
        return MakuluFramework.Combat:IsInCombat()
    end
    return false
end 

local function activeEnemies()
    return math.max(enemiesInMelee(), 1) --MultiUnits:GetActiveEnemies(40)
end

local function activeEnemiesInRange()
    return MultiUnits:GetActiveEnemies(40) or 0
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

local function isTotemActive(spell)
    for i = 1, MAX_TOTEMS do
        local _, name, startTime = GetTotemInfo(i)
        if startTime > 0 and name == spell.wowName then
            return true
        end
    end
    return false
end

local function shouldRecall()
    local recall = A.GetToggle(2, "recallSelect")
    -- recallSelect[1] = Tremor Totem
    -- recallSelect[2] = Capacitor Totem
    -- recallSelect[3] = Stone Bulwark Totem
    -- recallSelect[4] = Static Field Totem
    -- recallSelect[5] = Grounding Totem
    if TremorTotem.cd > 30000 and recall[1] then
        return true
    end
    if CapacitorTotem.cd > 30000 and recall[2] then
        return true
    end
    --if StoneBulwarkTotem.cd > 30000 and recall[3] then
    --    return true
    --end
    if StaticFieldTotem.cd > 30000 and recall[4] then
        return true
    end
    if GroundingTotem.cd > 30000 and recall[5] then
        return true
    end
    if EarthenWallTotem.cd > 45000 and recall[6] then
        return true
    end
    
    if IsPlayerSpell(A.WindRushTotem.ID) and WindRushTotem:Cooldown() > 15000 and recall[7] then
        return true
    end
    
    if IsPlayerSpell(A.PoisonCleansingTotem.ID) and PoisonCleansingTotem:Cooldown() > 15000 and recall[8] then
        return true
    end
    
    if IsPlayerSpell(A.HealingStreamTotem.ID) and HealingStreamTotem:Cooldown() > 15000 and recall[9] then
        return true
    end
    
    
    
    return false
end

local function shouldAoEHealing()
    if gameState.partySize <= 5 then
        if gameState.below95 >= 5 or gameState.below90 >= 4 or gameState.below85 >= 3 then
            return true
        end
    elseif gameState.partySize > 5 then
        if gameState.below85 >= 6 or gameState.below80 >= 5 then
            return true
        end
    end
    return false
end

local function shouldHealingCooldown()
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if player:Buff(buffs.ascendance) then return false end
    if isTotemActive(SpiritLinkTotem) then return false end
    if isTotemActive(HealingTideTotem) then return false end
    
    if gameState.partySize <= 5 then
        if gameState.below80 >= 5 or gameState.below75 >= 4 or gameState.below70 >= 3 then
            return true
        end
    elseif gameState.partySize > 5 then
        if gameState.below80 >= 7 or gameState.below75 >= 6 or gameState.below70 >= 5 then
            return true
        end
    end
    
    return false
end

local function startRamp()
    gameState.rampActive = true
    gameState.rampStartTime = GetTime()
end

local function isInRamp()
    if not gameState.rampActive then return false end
    local rampDuration = GetTime() - gameState.rampStartTime
    if rampDuration > 12 then -- 12 second ramp window
        gameState.rampActive = false
        return false
    end
    return true
end

local function shouldUseRamp()
    local rampMode = A.GetToggle(2, "rampMode")
    return rampMode
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
local updateDelay = 0.5
local function updateGameState()
    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gameState.imCastingRemaining = currentCastRemains
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime
    end
    
    gameState.T31has2P = Player:HasTier("Tier31", 2)
    gameState.T31has4P = Player:HasTier("Tier31", 4)
    
    gameState.below95 = MakMulti.party:Count(function(unit) return unit.ehp < 95 end)
    gameState.below90 = MakMulti.party:Count(function(unit) return unit.ehp < 90 end)
    gameState.below85 = MakMulti.party:Count(function(unit) return unit.ehp < 85 end)
    gameState.below80 = MakMulti.party:Count(function(unit) return unit.ehp < 80 end)
    gameState.below75 = MakMulti.party:Count(function(unit) return unit.ehp < 75 end)
    gameState.below70 = MakMulti.party:Count(function(unit) return unit.ehp < 70 end)
    gameState.partySize = MakMulti.party:Size()
    
    if player:Buff(buffs.cloudburstTotem) then
        gameState.cloudburstHealing = player:HasBuffPoints(buffs.cloudburstTotem)[1]
    else
        gameState.cloudburstHealing = 0
    end
    
    gameState.healingModifier = 1
    
    -- Check if Whispering Waves talent is active
    gameState.isWhisperingWaves = player:TalentKnown(1217598)
    
end

local function CanUseRiptide()
    -- In raids, always allow Riptide usage (bypass tidalwave gating)
    if gameState.partySize > 5 then
        return true
    end
    
    -- If "tidalwave" toggle is off, Riptide can always be used
    if not A.GetToggle(2, "tidalwave") then
        return true
    end
    
    if A.Riptide:GetSpellChargesFrac() >= 2.5 then
        return true
    end
    
    local hasTidalWaves = ActionUnit("player"):IsBuffStacks(A.TidalWavesBuff.ID) >= 2
    
    -- If "tidalwave" is on and player has Tidal Waves
    if hasTidalWaves then
        if isStaying then
            return false  -- Don't use Riptide when staying
        elseif isMoving then
            return true   -- Use Riptide when moving
        end
    end
    
    -- In all other cases, Riptide can be used
    return true
end

local function getBelowHP(percent)
    if target.isDummy and target.isFriendly and target.ehp < percent then
        return 100
    else
        return MakMulti.party:Count(function(unit)
                return HealingSurge:InRange(unit) and unit.ehp < percent and unit.hp > 0
        end)
    end
end

WindShear:Callback("every", function(spell, enemy)
        if player:Buff(buffs.grounding) then return end
        if not enemy.exists then return end
        if enemy:BuffFrom(MakLists.KickImmune) then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 420) then return end
        
        return spell:Cast(enemy)
end)

TotemicRecall:Callback(function(spell)
        if not shouldRecall() then return end
        
        return spell:Cast(player)
end)

Skyfury:Callback(function(spell)
        if player.inCombat then return end
        
        local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(Skyfury.wowName) and HealingSurge:InRange(unit) and not unit.isPet and unit.hp > 0 end)
        local outOfRange = MakMulti.party:Any(function(unit) return not HealingSurge:InRange(unit) end)
        
        if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only
        
        if not missingBuff then return end
        
        return Debounce("skyfury", 1000, 2500, spell, player)
end)

AstralShift:Callback(function(spell)
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[1] then return end
        
        if player.hp > A.GetToggle(2, "astralShiftHP") then return end
        if not player.inCombat then return end
        
        return spell:Cast(player)
end)

StoneBulwarkTotem:Callback(function(spell)
        if not A.StoneBulwarkTotem:IsTalentLearned() then return end
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[2] then return end
        
        if not player.inCombat then return end
        
        if shouldDefensive() or player.hp < A.GetToggle(2, "stoneBulwarkTotemHP") then
            return spell:Cast(player)
        end
end)

AncestralGuidance:Callback(function(spell)
        if not player:TalentKnown(AncestralGuidance.id) then return end
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[3] then return end
        
        if not player.inCombat then return end
        
        
        
        if shouldDefensive() or player.ehp < A.GetToggle(2, "ancestralGuidanceHP") then
            return spell:Cast(player)
        end
end)

EarthElemental:Callback(function(spell)
        if not A.EarthElemental:IsTalentLearned() then return end
        
        local defensiveSelect = A.GetToggle(2, "defensiveSelect")
        if not defensiveSelect[4] then return end
        
        if not player.inCombat then return end
        
        if shouldDefensive() or player.hp < A.GetToggle(2, "earthElementalHP") then
            return spell:Cast(player)
        end
end)

EarthlivingWeapon:Callback(function(spell)
        local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()
        local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
        if currentCombatTime > 0 then return end
        if not hasMainHandEnchant or mainHandExpiration <= (1800000 * num(not player.inCombat)) then
            return spell:Cast(player)
        end
end)

TidecallersGuard:Callback(function(spell)
        local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()
        
        if not hasOffHandEnchant or offHandExpiration <= (1800000 * num(not player.inCombat)) then
            return spell:Cast(player)
        end
end)

WaterShield:Callback(function(spell)
        if player.inCombat and getBelowHP(80) > 0 then return end
        if player:Buff(buffs.waterShield) then return end
        
        return spell:Cast(player)
end)

EarthShieldP:Callback("self", function(spell)
        if player.inCombat and getBelowHP(50) > 0 then return end
        if not player:TalentKnown(ElementalOrbit.id) then return end
        if not player:TalentKnown(TherazanesResilience.id) then
            if player:HasBuffCount(buffs.earthShieldOrbit) > A.GetToggle(2, "earthShieldStacks") then return end
        else
            if player:Buff(buffs.earthShieldOrbit) then return end
        end
        
        return spell:Cast(player)
end)

EarthShield:Callback("other", function(spell, unit)
        if Action.Zone == "arena" then return end
        if player.inCombat and getBelowHP(50) > 0 then return end
        if unit.isMe then return end
        if not player:TalentKnown(TherazanesResilience.id) then
            if MakMulti.party:Any(function(unit)
                    return unit:HasBuffCount(buffs.earthShield, true) > A.GetToggle(2, "earthShieldStacks")
            end) then
                return
            end
        else
            if MakMulti.party:Any(function(unit)
                    return unit.isTank and unit:Buff(buffs.earthShield, true)
            end) then
                return
            end
        end
        
        if Action.Zone == "arena" and unit:HasBuffCount(buffs.earthShield, true) < A.GetToggle(2, "earthShieldStacks") and unit:HasBuffCount(buffs.earthShieldOrbit, true) < A.GetToggle(2, "earthShieldStacks") then
            return spell:Cast(unit)
        end
        
        if tank:IsUnit(unit) and tank:HasBuffCount(buffs.earthShield) <= A.GetToggle(2, "earthShieldStacks") then
            return spell:Cast(unit)
        end
        
        --[[
    if tank.exists then
        if tank:IsUnit(unit) and tank:HasBuffCount(buffs.earthShield) <= A.GetToggle(2, "earthShieldStacks") then
            return spell:Cast(unit)
        end
    else
        if unit.hp < 95 and unit:HasBuffCount(buffs.earthShield) <= A.GetToggle(2, "earthShieldStacks") and not unit:Buff(buffs.earthShieldOrbit) then
            return spell:Cast(unit)
        end
    end
    ]]
end)

EarthShield:Callback("Tank", function(spell)
        if not spell:ReadyToUse() then return end

        -- Actively search for tank without Earth Shield
        local tank = MakMulti.party:Find(function(u)
                if not u.exists or u:IsDeadOrGhost() then return end
                if u:IsMe() then return end
                if not u:IsTank() then return end
                if u:Buff(974) then return end -- already has Earth Shield
                if not spell:InRange(u) then return end
                return true
        end)

        if not tank then return end

        HealingEngine.SetTarget(tank:CallerId(), 1)
        return spell:Cast(tank)
end)

-- Earth Shield on self: only care if ES (383648) exists at all
EarthShieldP:Callback("self2", function(spell)
        if not spell:ReadyToUse() then return end
        -- optional: don't do self-maintenance during emergencies
        if player.inCombat and HealingEngine.GetBelowHealthPercentUnits(50) > 0 then return end
        
        if player:Buff(383648) then return end  -- ES already on self
        return spell:Cast(player)
end)

-- helper: treat DPS as "not tank and not healer"
local function IsDPS(u)
    -- Prefer explicit helpers if they exist
    if u.IsTank and u:IsTank() then return false end
    if u.IsHealer and u:IsHealer() then return false end
    
    -- Fallback to role string if your wrapper exposes it
    if u.Role and (u:Role() == "TANK" or u:Role() == "HEALER") then
        return false
    end
    
    -- If nothing says tank/healer, assume DPS
    return true
end

EarthShield:Callback("other2", function(spell)
        if not spell:ReadyToUse() then return end
        -- Only cast in arena
        if Action.Zone ~= "arena" then return end
        -- Stop entirely if any tank exists
        local tankExists = MakMulti.party:Any(function(u)
                return u.exists and not u:IsDeadOrGhost() and u:IsTank()
        end)
        if tankExists then return end
        -- First non-tank under 70% without ES (no role/Role/IsDPS touches)
        local target = MakMulti.party:Find(function(u)
                if not u.exists or u:IsDeadOrGhost() then return end
                if u:IsMe() or not u:IsFriendly() or not spell:InRange(u) then return end
                if u:IsTank() then return end
                -- OPTIONAL: only if your wrapper truly has this method
                -- if u.IsHealer and u:IsHealer() then return end
                if u:Buff(974) then return end
                if u:Health() > 70 then return end
                return true
        end)
        if not target then return end

        HealingEngine.SetTarget(target:CallerId(), 1)
        return spell:Cast(target)
end)


BloodFury:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end
        
        if not A.GetToggle(1, "Racial") then return end
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

Berserking:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end
        
        if not A.GetToggle(1, "Racial") then return end
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

Fireblood:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end
        
        if not A.GetToggle(1, "Racial") then return end
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

AncestralCall:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end
        
        if not A.GetToggle(1, "Racial") then return end
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

RampTrigger:Callback(function(spell)
        local rampMode = A.GetToggle(2, "rampMode")
        if not rampMode then return end
        
        startRamp()
        return spell:Cast(player)
end)

BagOfTricks:Callback(function(spell)
        if not A.GetToggle(1, "Racial") then return end
        
        return spell:Cast(target)
end)

Purge:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end
        
        if not target:HasBuffFromFor(MakLists.pvePurge, 500) then return end
        
        return spell:Cast(target)
end)

AncestralVision:Callback(function(spell)
        if MakMulti.party:Any(function(unit)
                return unit.dead and HealingSurge:InRange(unit)
        end) then
            return spell:Cast(player)
        end
end)

CloudburstTotem:Callback("ramp", function(spell)
        if not IsPlayerSpell(CloudburstTotem.id) then return end
        if not player.inCombat then return end
        if not shouldUseRamp() then return end
        if isTotemActive(CloudburstTotem) then return end
        
        -- Drop CBT before ramp to soak UL/AS casts
        return spell:Cast(player)
end)

CloudburstTotem:Callback(function(spell)
        if not IsPlayerSpell(CloudburstTotem.id) then return end
        if not player.inCombat then return end
        local sumPartyHPDeficit = MakMulti.party:Sum(function(unit) return unit.maxHealth - unit.healthActual end)
        
        -- Don't overlap charges - check if totem is already active
        if isTotemActive(CloudburstTotem) then return end
        
        -- Don't use if we just recalled one recently (prevent immediate re-drop)
        if RecallCloudburstTotem:Used() < 2000 then return end
        
        -- Don't use if ramp mode is active (let ramp callback handle it)
        local rampMode = A.GetToggle(2, "rampMode")
        if rampMode then return end
        
        if sumPartyHPDeficit > 2000000 or shouldDefensive() then
            return spell:Cast(player)
        end
end)

RecallCloudburstTotem:Callback(function(spell)
        if not IsPlayerSpell(CloudburstTotem.id) then return end
        if not isTotemActive(CloudburstTotem) then return end
        
        local sumPartyHPDeficit = MakMulti.party:Sum(function(unit) return unit.maxHealth - unit.healthActual end)
        
        -- Recall when healing stored is valuable and team needs healing
        if sumPartyHPDeficit > gameState.cloudburstHealing and gameState.cloudburstHealing > 6000000 then
            return spell:Cast(player)
        end
        
        -- Auto-pop out of combat if enabled
        if not player.inCombat and A.GetToggle(2, "autoPopCB") then
            return spell:Cast(player)
        end
        
        -- Emergency recall if someone is very low and we have good healing stored
        local criticallyLow = getBelowHP(40)
        if criticallyLow >= 1 and gameState.cloudburstHealing > 4000000 then
            return spell:Cast(player)
        end
end)









SpiritLinkTotem:Callback(function(spell)
        if not shouldHealingCooldown() then return end
        
        
        
        local awareAlert = A.GetToggle(2, "makAware")
        if awareAlert[1] then
            Aware:displayMessage("Spirit Link Totem!", "Green", 1)
        end
        
        return spell:Cast(player)
end)

HealingTideTotem:Callback(function(spell)
        if not shouldHealingCooldown() then return end
        
        
        
        return spell:Cast(player)
end)

Ascendance:Callback(function(spell)
        if not shouldHealingCooldown() then return end
        
        
        
        return spell:Cast(player)
end)

PurifySpirit:Callback("pve", function(spell, friendly) -- Moving this to party binds temporarily until we can get healing engine sorted
        local shouldDispel = A.ImprovedPurifySpirit:IsTalentLearned() and friendly.cursed or friendly.magicked
        
        if not shouldDispel then return end
        return Debounce("cleanse", 1000, 2500, spell, friendly)
end)

PurifySpirit:Callback(function(spell, unit)
        if unit.hp < 35 then return end
        if Action.Zone == "arena" then return end
        local magicked = MakMulti.party:Find(function(unit) return unit.magicked and PurifySpirit:InRange(unit) end)
        local cursed = MakMulti.party:Find(function(unit) return unit.cursed and PurifySpirit:InRange(unit) end)
        
        if magicked then
            HealingEngine.SetTarget(magicked:CallerId(), 1)
            return Debounce("cleanse", 1000, 2500, spell, unit)
        end
        
        if cursed and player:TalentKnown(ImprovedPurifySpirit.id) then
            HealingEngine.SetTarget(cursed:CallerId(), 1)
            return Debounce("cleanse", 1000, 2500, spell, unit)
        end
end)

PoisonCleansingTotem:Callback(function(spell)
        local shouldDispel = MakMulti.party:Find(function(unit) return unit.poisoned end)
        
        if not shouldDispel then return end
        
        return Debounce("pct", 1000, 2500, spell, player)
end)

AncestralSwiftness:Callback(function(spell, unit)
        if getBelowHP(75) < 1 then return end
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        
        -- Use on cooldown
        return spell:Cast(player)
end)

NaturesSwiftness:Callback(function(spell, unit)
        if getBelowHP(75) < 1 then return end
        if player:TalentKnown(AncestralSwiftness.id) then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        
        if unit.ehp > 45 then return end
        
        return spell:Cast(player)
end)

AncestralSwiftness:Callback('InPVP', function(spell, unit)
        if getBelowHP(50) < 1 then return end
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        if not player:Buff(buffs.unleashLife) then return end
        
        return spell:Cast(player)
end)
AncestralSwiftness:Callback("ohshit", function(spell, unit)
        if getBelowHP(30) < 1 then return end
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        
        return spell:Cast(player)
end)
AncestralSwiftness:Callback("ohshitparty", function(spell, unit)
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end

        -- Only use when 3 or more members are at 90% HP or lower
        if getBelowHP(90) < 3 then return end

        return spell:Cast(player)
end)
NaturesSwiftness:Callback('InPVP', function(spell, unit)
        if getBelowHP(50) < 1 then return end
        if player:TalentKnown(AncestralSwiftness.id) then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        if not player:Buff(buffs.unleashLife) then return end
        
        return spell:Cast(player)
end)

HealingSurge:Callback("swift", function(spell, unit)
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        
        -- Consume AS on Healing Surge for single target healing
        local injuredCount = MakMulti.party:Count(function(u) return u.ehp < 90 end)
        if injuredCount >= 2 then return end -- Use Chain Heal for 2+ targets
        
        if not AutoHeal(unit:CallerId(), A.HealingSurge) then return end
        
        return spell:Cast(unit)
end)

HealingWave:Callback("swift", function(spell, unit)
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        
        if not AutoHeal(unit:CallerId(), A.HealingWave) then return end
        
        -- In raids, only use Healing Wave on targets with Riptide
        if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end
        
        return spell:Cast(unit)
end)

-- PvP: Healing Wave with AS/NS buff - No AutoHeal check for emergency healing
HealingWave:Callback("pvpSwift", function(spell, unit)
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        if not spell:ReadyToUse() then return end
        if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
        
        -- In raids, only use Healing Wave on targets with Riptide
        if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end
        
        return spell:Cast(unit)
end)

ChainHeal:Callback("swift", function(spell, unit)
        -- During Ancestral Swiftness, use Chain Heal if at least 3 people are below 80% HP
        if not player:Buff(buffs.ancestralswiftness) then return end
        if not spell:ReadyToUse() then return end

        -- Count party members below 80% HP
        local countBelow85 = MakMulti.party:Count(function(u)
            return u.exists
            and not u:IsDeadOrGhost()
            and u.hp < 85
        end) or 0

        if countBelow85 < 3 then return end

        return spell:Cast(unit)
end)

Riptide:Callback("swift", function(spell, unit)
        -- During Ancestral/Nature's Swiftness, always force an instant Riptide to consume the buff
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        return spell:Cast(unit)
end)


HealingSurge:Callback("tidal", function(spell, unit)
        
        if not MovementCheck then return end
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        if not player:Buff(buffs.tidalWaves) then return end
        if unit.ehp > 45 then return end
        if not AutoHeal(unit:CallerId(), A.HealingSurge) then return end
        
        return spell:Cast(unit)
end)

HealingWave:Callback("tidal", function(spell, unit)
        if not MovementCheck then return end
        if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
        if not player:Buff(buffs.tidalWaves) then return end
        if unit.ehp > 45 then return end
        if not AutoHeal(unit:CallerId(), A.HealingWave) then return end
        
        -- In raids, only use Healing Wave on targets with Riptide
        if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end
        
        return spell:Cast(unit)
end)

EarthenWallTotem:Callback(function(spell, unit)
        if isMoving then return end
        
        local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
        if currentCombatTime < 3000 then return end
        if isTotemActive(EarthenWallTotem) then return end
        if unit.ehp > 95 then return end
        
        local awareAlert = A.GetToggle(2, "makAware")
        if awareAlert[1] then
            Aware:displayMessage("Earthen Wall Totem!", "Red", 1)
        end
        
        return spell:Cast(player)
end)

HealingStreamTotem:Callback(function(spell, unit)
        if isMoving then return end
        if IsPlayerSpell(CloudburstTotem.id) then return end
        if isTotemActive(HealingStreamTotem) then return end
        
        if not AutoHeal(unit:CallerId(), A.HealingStreamTotem) then return end
        
        return spell:Cast(player)
end)

HealingStreamTotem:Callback('5man', function(spell) 
        
        -- Don't use Healing Stream Totem if Cloudburst Totem talent is chosen
        
        if IsPlayerSpell(157153) then return end
        if not spell:ReadyToUse() then return end
        
        local player = ConstUnit.player
        local party  = MakuluFramework.MultiUnits.party
        local size   = party:Size() or 1
        local inCombat = player:InCombat()
        
        -- Track charges if the API supports it
        local charges, maxCharges = spell:Charges()
        if not charges then charges = 0 end
        if not maxCharges then maxCharges = 2 end
        
        -- Group averages (percent health)
        local avgHP = party:Average(function(u)
                if u:Exists() and not u:IsDeadOrGhost() then
                    return u:Health()
                end
                return 100
        end) or 100
        
        local below80 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 80
        end) or 0
        
        local below60 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 60
        end) or 0
        
        local below40 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 40
        end) or 0
        
        -- Damage input tracker (optional)
        local dmgTracker = MakuluFramework.DamageTracker
        local recentIn   = dmgTracker and (dmgTracker:GetRecentDamageTaken(3) or 0) or 0
        
        ---------------------------------------------------------------------
        -- PRIORITY RULES
        ---------------------------------------------------------------------
        
        -- Emergency use: big dip or incoming damage spike
        if below40 >= 1 or (below60 >= 2) or recentIn > 0 then
            return spell:Cast(player)
        end
        
        -- Maintain uptime: never sit on 2 charges
        if inCombat and charges == maxCharges then
            return spell:Cast(player)
        end
        
        -- Rolling heal upkeep: mild raid pressure (avgHP < 85)
        if inCombat and avgHP <= 85 and charges >= 1 then
            return spell:Cast(player)
        end
        
        -- Solo safety net: use if we’re taking damage
        if size == 1 and inCombat and player:Health() < 90 and recentIn > 0 then
            return spell:Cast(player)
        end
end)

ManaTideTotem:Callback(function(spell)
        if isMoving then return end
        local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
        if currentCombatTime < 3000 then return end
        if player.manaPct >= 80 then return end
        
        return spell:Cast(player)
end)

HealingWave:Callback("pWave", function(spell, unit)
        if not MovementCheck then return end
        if not player:Buff(buffs.primordialWave) then return end
        
        if not AutoHeal(unit:CallerId(), A.HealingWave) then return end
        
        -- In raids, only use Healing Wave on targets with Riptide
        if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end
        
        local hurtWithRiptide = MakMulti.party:Count(function(unit) return unit.ehp < 90 and unit:Buff(buffs.riptide, true) end)
        if hurtWithRiptide >= 2 or player:BuffRemains(buffs.primordialWave) < HealingWave:CastTime() * 2 then
            return spell:Cast(unit)
        end
end)

Downpour:Callback(function(spell)
        if not player:Buff(buffs.downpour) then return end
        
        if shouldAoEHealing() or player:BuffRemains(buffs.downpour) < A.GetGCD() * 1500 then
            return spell:Cast(player)
        end
end)

Wellspring:Callback(function(spell)
        if not MovementCheck then return end
        if not shouldAoEHealing() then return end
        
        return spell:Cast(player)
end)

HealingRain:Callback(function(spell)
        if not MovementCheck then return end
        
        if Action.Zone == "arena" then return end
        
        if C_ClassTalents.GetActiveHeroTalentSpec() == 54 then return end
        if not player.inCombat then return end
        
        local healingRainMode = A.GetToggle(2, "healingRainMode")
        
        -- Very low priority in Whispering Waves builds - only when nothing else to do
        if gameState.isWhisperingWaves then
            if healingRainMode ~= "Always" then return end
            -- Only use if group is stationary and nothing higher-value is available
            if not shouldAoEHealing() then return end
        end
        
        if shouldAoEHealing() and healingRainMode == "Auto" or healingRainMode == "Always" then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[1] then
                Aware:displayMessage("Healing Rain!", "Blue", 1)
            end
            return spell:Cast(player)
        end
end)

SurgingTotem:Callback(function(spell)
        if C_ClassTalents.GetActiveHeroTalentSpec() ~= 54 then return end
        if not player.inCombat then return end
        
        local healingRainMode = A.GetToggle(2, "healingRainMode")
        
        if shouldAoEHealing() and healingRainMode == "Auto" or healingRainMode == "Always" then
            local awareAlert = A.GetToggle(2, "makAware")
            if awareAlert[1] then
                Aware:displayMessage("Surging Totem!", "Blue", 1)
            end
            return spell:Cast(player)
        end
end)

PrimordialWave:Callback(function(spell, unit)
        if not CanUseRiptide() then return end
        local riptideHP = A.GetToggle(2, "riptideHP")
        if not AutoHealOrSlider(unit:CallerId(), A.PrimordialWave, riptideHP) then return end
        
        return spell:Cast(unit)
end)

-- PvP: Primordial Wave - More aggressive, use on CD when someone needs healing
PrimordialWave:Callback("pvp", function(spell, unit)
        if not CanUseRiptide() then return end
        if not spell:ReadyToUse() then return end
        if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
        
        -- Cast on anyone <95% HP (this is a cooldown, use it aggressively)
        local hp = unit:Health()
        if hp >= 95 then return end
        
        return spell:Cast(unit)
end)

Riptide:Callback("spread", function(spell, unit)
        -- Aggressive Riptide spreading for Whispering Waves or during AS windows
        if not CanUseRiptide() then return end
        
        local shouldSpread = false
        
        -- Always spread in raids to keep Riptide coverage high
        if gameState.partySize > 5 then
            shouldSpread = true
        end
        
        -- Always spread for Whispering Waves builds
        if gameState.isWhisperingWaves then
            shouldSpread = true
        end
        
        -- Aggressive seeding during AS + 4pc window
        if player:Buff(buffs.ancestralswiftness) and gameState.T31has4P then
            shouldSpread = true
        end
        
        if not shouldSpread then return end
        
        -- Prioritize injured players without Riptide
        if not unit:Buff(buffs.riptide, true) and unit.ehp < 95 then
            return spell:Cast(unit)
        end
        
        -- Only refresh Riptide if it's about to expire (< 6 seconds) and during AS window
        if player:Buff(buffs.ancestralswiftness) and unit:Buff(buffs.riptide, true) and unit:BuffRemains(buffs.riptide, true) < 6000 and unit.ehp < 95 then
            return spell:Cast(unit)
        end
end)

Riptide:Callback(function(spell, unit)
        if not CanUseRiptide() then return end
        
        -- Don't cast Riptide if target already has it with > 6 seconds remaining
        if unit:Buff(buffs.riptide, true) and unit:BuffRemains(buffs.riptide, true) > 6000 then return end
        
        local riptideHP = A.GetToggle(2, "riptideHP")
        if not AutoHealOrSlider(unit:CallerId(), A.Riptide, riptideHP) then return end
        
        return spell:Cast(unit)
end)

-- PvP: Riptide - More aggressive, cast on anyone <97% HP without Riptide
Riptide:Callback("pvp", function(spell, unit)
        if not CanUseRiptide() then return end
        if not spell:ReadyToUse() then return end
        if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
        
        -- Don't cast Riptide if target already has it with > 6 seconds remaining
        if unit:Buff(buffs.riptide, true) and unit:BuffRemains(buffs.riptide, true) > 6000 then return end
        
        -- Cast on anyone <97% HP (aggressive HoT spreading)
        local hp = unit:Health()
        if hp >= 97 then return end
        
        return spell:Cast(unit)
end)

UnleashLife:Callback(function(spell, unit)
        if not spell:ReadyToUse() then return end
        if not unit or not unit:Exists() or unit:IsDeadOrGhost() then return end
        
        if unit:Health() < 98 then        
            return spell:Cast(unit)
        end
end)

UnleashLife:Callback("ramp", function(spell, unit)
        -- Use UL on cooldown for ramp sequences
        if not player.inCombat then return end
        if not shouldUseRamp() then return end
        
        return spell:Cast(unit)
end)

UnleashLife:Callback("all", function(spell, unit)
        -- Use UL on cooldown outside of ramp mode
        local rampMode = A.GetToggle(2, "rampMode")
        if rampMode then return end -- Let ramp callback handle it
        
        local unleashLifeHP = A.GetToggle(2, "unleashLifeHP")
        if not AutoHealOrSlider(unit:CallerId(), A.UnleashLife, unleashLifeHP) then return end
        
        return spell:Cast(unit)
end)

UnleashLife:Callback("ch", function(spell, unit)
        -- Chain heal specific UL usage
        return spell:Cast(unit)
end)

ChainHeal:Callback("ww", function(spell, unit)
        -- Whispering Waves: Chain Heal has lower priority, use outside AS windows
        if not gameState.isWhisperingWaves then return end
        if not MovementCheck then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Don't use during AS windows
        
        -- Never use Chain Heal in arena (too slow, use single target heals instead)
        if Action.Zone == "arena" then return end
        
        -- Do not use Chain Heal in raids (use Healing Wave on Riptide targets instead)
        if gameState.partySize > 5 then return end
        
        local numberHurt = MakMulti.party:Count(function(unit) return (unit.ehp < A.GetToggle(2, "chainHealHP") and A.GetToggle(2, "chainHealHP") < 100) or (unit.maxHealth - unit.healthActual > ChainHeal:ToolTip()[1] * gameState.healingModifier and A.GetToggle(2, "chainHealHP") >= 100) end)
        
        if numberHurt < 3 then return end
        
        local chainHealHP = A.GetToggle(2, "chainHealHP")
        local chainHealMode = A.GetToggle(2, "chainHealMode")
        
        if chainHealMode == "Auto" then
            if not player:Buff(buffs.unleashLife) then
                UnleashLife("ch", unit)
            end
            if not player:Buff(buffs.unleashLife) and not player:Buff(buffs.highTide) then return end
        end
        
        if chainHealMode ~= "Off" then
            if unit.ehp > chainHealHP and chainHealHP < 100 then return end
            
            if chainHealHP >= 100 then
                if unit.maxHealth - unit.healthActual > spell:ToolTip()[1] * gameState.healingModifier then
                    return spell:Cast(unit)
                end
            else
                if unit.ehp < chainHealHP then
                    return spell:Cast(unit)
                end
            end
        end
end)

ChainHeal:Callback(function(spell, unit)
        if not MovementCheck then return end
        
        -- Never use Chain Heal in arena (too slow, use single target heals instead)
        if Action.Zone == "arena" then return end
        
        -- Do not use Chain Heal in raids (use Healing Wave on Riptide targets instead)
        if gameState.partySize > 5 then return end
        
        -- Skip if Whispering Waves is talented (use "ww" callback instead)
        if gameState.isWhisperingWaves then return end
        
        local numberHurt = MakMulti.party:Count(function(unit) return (unit.ehp < A.GetToggle(2, "chainHealHP") and A.GetToggle(2, "chainHealHP") < 100) or (unit.maxHealth - unit.healthActual > ChainHeal:ToolTip()[1] * gameState.healingModifier and A.GetToggle(2, "chainHealHP") >= 100) end)
        
        if numberHurt < 3 then return end
        
        local chainHealHP = A.GetToggle(2, "chainHealHP")
        local chainHealMode = A.GetToggle(2, "chainHealMode")
        
        if chainHealMode == "Auto" then
            if not player:Buff(buffs.unleashLife) then
                UnleashLife("ch", unit)
            end
            if not player:Buff(buffs.unleashLife) and not player:Buff(buffs.highTide) then return end
        end
        
        if chainHealMode ~= "Off" then
            if unit.ehp > chainHealHP and chainHealHP < 100 then return end
            
            if chainHealHP >= 100 then
                if unit.maxHealth - unit.healthActual > spell:ToolTip()[1] * gameState.healingModifier then
                    return spell:Cast(unit)
                end
            else
                if unit.ehp < chainHealHP then
                    return spell:Cast(unit)
                end
            end
        end
end)

HealingSurge:Callback(function(spell, unit)
        if not MovementCheck then return end
        
        local healingSurgeHP = A.GetToggle(2, "healingSurgeHP")
        if not AutoHealOrSlider(unit:CallerId(), A.HealingSurge, healingSurgeHP) then return end
        
        return spell:Cast(unit)
end)

-- PvP: Healing Surge for urgent healing (≤85% HP) - Emergency fallback when can't generate Tidal Waves
HealingSurge:Callback("pvp", function(spell, unit)
        if not MovementCheck then return end
        if not spell:ReadyToUse() then return end
        
        -- Only cast if we have 0 Tidal Waves AND 0 Riptide charges (emergency fallback)
        local hasTidalWaves = player:Buff(buffs.tidalWaves, true)
        local riptideCharges = Riptide:Charges() or 0
        if hasTidalWaves or riptideCharges > 0 then return end
        
        -- Actively search for lowest HP urgent target (≤85%)
        local urgentTarget = MakMulti.party:Lowest(
            function(u) return u.hp end,
            function(u)
                return u.exists
                and not u:IsDeadOrGhost()
                and spell:InRange(u)
                and u.hp <= 85  -- Urgent healing threshold
            end
        )
        
        if urgentTarget then
            HealingEngine.SetTarget(urgentTarget:CallerId(), 1)
            return spell:Cast(urgentTarget)
        end
end)

HealingWave:Callback("ww", function(spell, unit)
        -- In raids, use HW to cleave on Riptide targets (regardless of WW talent)
        if not gameState.isWhisperingWaves and gameState.partySize <= 5 then return end
        if not MovementCheck then return end
        
        local healingWaveHP = A.GetToggle(2, "healingWaveHP")
        if not AutoHealOrSlider(unit:CallerId(), A.HealingWave, healingWaveHP) then return end
        
        -- Prioritize targets with Riptide
        if unit:Buff(buffs.riptide, true) then
            return spell:Cast(unit)
        end
        
        -- Count injured players with Riptide for cleave value
        local riptideTargets = MakMulti.party:Count(function(u) return u:Buff(buffs.riptide, true) and u.ehp < 95 end)
        if riptideTargets == 0 then
            -- In raids, skip HW if no Riptide targets are available
            if gameState.partySize > 5 then return end
            -- In dungeons, allow fallback to any valid target
            return spell:Cast(unit)
        end
end)

HealingWave:Callback(function(spell, unit)
        if not MovementCheck then return end
        
        -- Skip if Whispering Waves is talented (use "ww" callback instead)
        if gameState.isWhisperingWaves then return end
        
        local healingWaveHP = A.GetToggle(2, "healingWaveHP")
        if not AutoHealOrSlider(unit:CallerId(), A.HealingWave, healingWaveHP) then return end
        
        -- In raids, only use Healing Wave on targets with Riptide
        if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end
        
        return spell:Cast(unit)
end)

-- PvP: Healing Wave for topping off (86-99% HP) - Emergency fallback when can't generate Tidal Waves
HealingWave:Callback("pvp", function(spell, unit)
        if not MovementCheck then return end
        if not spell:ReadyToUse() then return end
        
        -- Only cast if we have 0 Tidal Waves AND 0 Riptide charges (emergency fallback)
        local hasTidalWaves = player:Buff(buffs.tidalWaves, true)
        local riptideCharges = Riptide:Charges() or 0
        if hasTidalWaves or riptideCharges > 0 then return end
        
        -- Actively search for topping off targets (86-99% HP)
        local topOffTarget = MakMulti.party:Lowest(
            function(u) return u.hp end,
            function(u)
                local validTarget = u.exists
                and not u:IsDeadOrGhost()
                and spell:InRange(u)
                and u.hp >= 86  -- Above urgent threshold
                and u.hp < 100  -- Below full
                
                -- In raids, only use Healing Wave on targets with Riptide
                if gameState.partySize > 5 then
                    return validTarget and u:Buff(buffs.riptide, true)
                end
                
                return validTarget
            end
        )
        
        if topOffTarget then
            HealingEngine.SetTarget(topOffTarget:CallerId(), 1)
            return spell:Cast(topOffTarget)
        end
end)

-- PvP: Whispering Waves cleave version - Actively search for Riptide targets
HealingWave:Callback("wwPvp", function(spell, unit)
        -- In raids, use HW to cleave on Riptide targets (regardless of WW talent)
        if not gameState.isWhisperingWaves and gameState.partySize <= 5 then return end
        if not MovementCheck then return end
        if not spell:ReadyToUse() then return end
        
        -- Require Tidal Waves buff for faster cast time
        if not player:Buff(buffs.tidalWaves, true) then return end
        
        -- Actively search for lowest HP target with Riptide buff
        local riptideTarget = MakMulti.party:Lowest(
            function(u) return u.hp end,
            function(u)
                return u.exists
                and not u:IsDeadOrGhost()
                and spell:InRange(u)
                and u.hp < 95  -- Needs healing
                and u:Buff(buffs.riptide, true)  -- Has Riptide for cleave
            end
        )
        
        if riptideTarget then
            HealingEngine.SetTarget(riptideTarget:CallerId(), 1)
            return spell:Cast(riptideTarget)
        end
        
        -- In dungeons, allow fallback to any valid target if no Riptide targets
        if gameState.partySize <= 5 then
            local anyTarget = MakMulti.party:Lowest(
                function(u) return u.hp end,
                function(u)
                    return u.exists
                    and not u:IsDeadOrGhost()
                    and spell:InRange(u)
                    and u.hp < 95
                end
            )
            
            if anyTarget then
                HealingEngine.SetTarget(anyTarget:CallerId(), 1)
                return spell:Cast(anyTarget)
            end
        end
end)

SpiritwalkersGrace:Callback(function(spell, unit)
        if player:BuffFrom(MakLists.ignoreMoving) then return end
        if not player.combat then return end
        
        if unit.ehp > 70 then return end -- need a better way to handle this
        
        return spell:Cast(player)
end)

EarthElemental:Callback(function(spell)
        if player:BuffFrom(MakLists.ignoreMoving) then return end
        if not player.combat then return end
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

HealingRain:Callback("acid", function(spell)
        if not MovementCheck then return end
        if C_ClassTalents.GetActiveHeroTalentSpec() == 54 then return end
        if not A.GetToggle(2, "acidRain") then return end
        if not A.AcidRain:IsTalentLearned() then return end
        
        return spell:Cast(player)
end)

SurgingTotem:Callback("acid", function(spell)
        if C_ClassTalents.GetActiveHeroTalentSpec() ~= 54 then return end
        if not A.GetToggle(2, "acidRain") then return end
        if not A.AcidRain:IsTalentLearned() then return end
        
        return spell:Cast(player)
end)

FlameShock:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if activeEnemiesInRange() < 1 then return end
        if target:DebuffRemains(debuffs.flameShock, true) > 2500 then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

LavaBurst:Callback("surge", function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if activeEnemiesInRange() < 1 then return end
        if not player:Buff(buffs.lavaSurge) then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

LavaBurst:Callback("swift", function(spell)
        -- During Ancestral/Nature's Swiftness, force Lava Burst to consume or act immediately
        if not (player:Buff(buffs.ancestralswiftness) or player:Buff(buffs.naturesswiftness)) then return end
        if not target.exists then return end
        if not spell:InRange(target) then return end
        return spell:Cast(target)
end)


ChainLightning:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if not MovementCheck then return end
        if activeEnemiesInRange() < 2 then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

LavaBurst:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if activeEnemiesInRange() < 1 then return end
        if not MovementCheck then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

LightningBolt:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if activeEnemiesInRange() < 1 then return end
        if not MovementCheck then return end
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

FrostShock:Callback(function(spell)
        -- Don't DPS if anyone needs healing
        local manaTreshold = A.GetToggle(2, "ManaTresholdDpsSlider")
        if player.manaPct <= manaTreshold then return end
        if getBelowHP(85) > 0 then return end

        if activeEnemiesInRange() ~= 1 then return end -- Only cast if exactly 1 enemy
        if player:Buff(buffs.ancestralswiftness) then return end -- Save AS for healing

        return spell:Cast(target)
end)

local function DamageRotation()
    -- HP and mana checks are now in individual DPS callbacks
    -- This prevents the rotation from pausing when someone drops below 85% HP mid-cast
    Purge()
    BloodFury()
    Berserking()
    Fireblood()
    AncestralCall()
    HealingRain("acid")
    SurgingTotem("acid")
    ChainLightning()
    FlameShock()
    LavaBurst("surge")
    LavaBurst()
    LightningBolt()
    FrostShock()
end

GroundingTotem:Callback("arena", function(spell)
        if target.exists and target.canAttack and target.hp < 20 then return end
        if WindShear:Used() < 1000 then return end
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

local function stopCast()
    local currentCast, _, castRemains, _ = myCast()
    if currentCast then
        local stopCastPercent = A.GetToggle(2, "stopCastPercent")
        local unitsBelow = getBelowHP(stopCastPercent)
        
        -- Stop casting damage spells if healing is urgently needed
        if unitsBelow >= 1 then
            if currentCast == LightningBolt.id or currentCast == LavaBurst.id or currentCast == ChainLightning.id or currentCast == Hex.id then
                return true
            end
        end
        
        -- Do not cancel healing casts mid-cast to avoid start/stop loops (Chain Heal / Healing Wave)
        -- If we want emergency pivots later, gate them on an actual instant available (e.g., AS/NS)
        -- For now: only cancel damage spells above; never cancel healing casts here.
    end
    return false
end

-- Healing Tide Totem – works in PvE, PvP, and SOLO
HealingTideTotem:Callback("5man", function(spell)
        
        if not InCombat() then return end
        if not spell:ReadyToUse() then return end   -- Makulu spell method
        local player  = ConstUnit.player            -- constant unit
        local party   = MakuluFramework.MultiUnits.party
        local size    = party:Size() or 1           -- group size (1 when solo)
        
        -- Group health stats (nil-safe; Health() returns %)
        local avgHP = party:Average(function(u)
                if u:Exists() and not u:IsDeadOrGhost() then
                    return u:Health()
                end
                return 100
        end) or 100
        
        local below70 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 70
        end) or 0
        
        local below50 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 50
        end) or 0
        
        local below35 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 35
        end) or 0
        
        -- ---- SOLO logic (size == 1) ----
        if size <= 3 then
            local php = player:Health()
            -- Optional: look at recent damage to avoid wasting HTT when topped
            local dmgTracker = MakuluFramework.DamageTracker
            local recentIn   = dmgTracker and (dmgTracker:GetRecentDamageTaken(3) or 0) or 0  -- last 3s
            
            -- Solo emergency or sustained pressure
            if php <= 45 or (php <= 65 and recentIn > 0) then
                return spell:Cast(player)
            end
            return
        end
        
        -- ---- GROUP/RAID logic (size >= 2) ----
        local isRaid = size > 5
        local trig70 = isRaid and 8 or 3
        local trig50 = isRaid and 4 or 2
        
        -- 1) Critical emergency
        if below50 >= trig50 or avgHP <= 55 or below35 >= 1 then
            return spell:Cast(player)
        end
        
        -- 2) Sustained heavy damage
        if below70 >= trig70 and avgHP <= 75 then
            return spell:Cast(player)
        end
        
        -- 3) Last-resort if many dipping (looser gate)
        if below70 >= (isRaid and 12 or 4) then
            return spell:Cast(player)
        end
end)

-- Ascendance – universal callback (solo/party/raid, PvE/PvP)
-- Uses only Makulu APIs (no WoW globals / no external helpers)

Ascendance:Callback("5man", function(spell)
        -- Must be usable
        if not InCombat() then return end
        if not spell:ReadyToUse() then return end
        
        local player = ConstUnit.player
        local party  = MakuluFramework.MultiUnits.party
        local size   = party:Size() or 1
        local isRaid = size > 5
        
        -- Group health stats (nil-safe). Health() returns %.
        local avgHP = party:Average(function(u)
                if u:Exists() and not u:IsDeadOrGhost() then
                    return u:Health()
                end
                return 100
        end) or 100
        
        local below85 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 85
        end) or 0
        
        local below70 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 70
        end) or 0
        
        local below50 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 50
        end) or 0
        
        local below35 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 35
        end) or 0
        
        ----------------------------------------------------------------
        -- SOLO logic (size == 1): use as a personal life-saver or
        -- when under pressure so you can pump self-heals harder.
        ----------------------------------------------------------------
        if size <= 3 then
            local php = player:Health()
            local dmgTracker = MakuluFramework.DamageTracker
            local recentIn   = dmgTracker and (dmgTracker:GetRecentDamageTaken(3) or 0) or 0
            
            if php <= 45 or (php <= 65 and recentIn > 0) then
                return spell:Cast(player)
            end
            return
        end
        
        ----------------------------------------------------------------
        -- GROUP / RAID logic
        -- Ascendance is a major throughput CD (18s) + instant burst,
        -- so require heavier conditions than HTT.
        ----------------------------------------------------------------
        local trig85 = isRaid and 12 or 4   -- many hurt (pre-wipe stabilization)
        local trig70 = isRaid and 8  or 3   -- sustained heavy damage
        local trig50 = isRaid and 4  or 2   -- multiple critical
        
        -- 1) PANIC / WIPE-SAVE:
        --    several under 50% OR anyone under 35% OR avgHP very low.
        if below50 >= trig50 or below35 >= 1 or avgHP <= 55 then
            return spell:Cast(player)
        end
        
        -- 2) SUSTAINED HEAVY RAID DAMAGE:
        --    many under 70% plus low-ish average.
        if below70 >= trig70 and avgHP <= 75 then
            return spell:Cast(player)
        end
        
        -- 3) BROAD, MODERATE DAMAGE (ramp stabilizer):
        --    lots below 85% and average health slipping.
        if below85 >= trig85 and avgHP <= 82 then
            return spell:Cast(player)
        end
end)

AncestralSwiftness:Callback("ohshit", function(spell, unit)
        if getBelowHP(25) < 1 then return end
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end

        return spell:Cast(player)
end)

-- Ancestral Swiftness for mana saving - Use on CD when below 50% mana
AncestralSwiftness:Callback("manaSave", function(spell, unit)
        if not player:TalentKnown(AncestralSwiftness.id) then return end
        if not player.inCombat then return end
        if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
        if player:Buff(buffs.spiritwalkersGrace) then return end
        if player:Buff(buffs.spatialParadox) then return end
        if player.mana > 50 then return end  -- Only use when below 50% mana
        if unit.hp >= 98 then return end  -- Only use if someone needs healing

        return spell:Cast(player)
end)

-- Healing Surge when target ≤90% AND YOU have Tidal Waves (buff on player)
HealingSurge:Callback("tidalWaves", function(spell, unit)
        if not isStaying then return end
        if not spell:ReadyToUse() then return end
        if unit.hp > 90 then return end
        if not player:Buff(buffs.tidalWaves, true) then return end

        return spell:Cast(unit)
end)

-- Healing Wave for mid-range healing (80-94% HP) with Tidal Waves
HealingWave:Callback("mid", function(spell, unit)
        if not MovementCheck then return end
        if not spell:ReadyToUse() then return end
        
        -- Require Tidal Waves buff
        if not player:Buff(buffs.tidalWaves, true) then return end
        
        -- Actively search for mid-range healing targets (80-94% HP)
        local midRangeTarget = MakMulti.party:Lowest(
            function(u) return u.hp end,
            function(u)
                return u.exists
                and not u:IsDeadOrGhost()
                and spell:InRange(u)
                and u.hp > 80   -- Above urgent threshold
                and u.hp < 95   -- Below full
            end
        )
        
        if midRangeTarget then
            HealingEngine.SetTarget(midRangeTarget:CallerId(), 1)
            return spell:Cast(midRangeTarget)
        end
end)

-- Riptide - Cast on targets <98% HP without Riptide buff OR when player needs Tidal Waves
Riptide:Callback("tidalGen", function(spell, unit)
        if not spell:ReadyToUse() then return end
        if unit.hp >= 98 then return end

        -- Cast if target doesn't have Riptide buff OR player doesn't have Tidal Waves
        local hasRiptideBuff = unit:Buff(buffs.riptide, true)
        local hasTidalWaves = player:Buff(buffs.tidalWaves, true)

        if not hasRiptideBuff or not hasTidalWaves then
            return spell:Cast(unit)
        end
end)

-- Riptide: Priority 2 - Generate Tidal Waves, actively search for targets without Riptide
Riptide:Callback("basic", function(spell, unit)
        if not spell:ReadyToUse() then return end
        
        -- Actively search for lowest HP target without Riptide buff
        local needsRiptide = MakMulti.party:Lowest(
            function(u) return u.hp end,
            function(u)
                return u.exists
                and not u:IsDeadOrGhost()
                and spell:InRange(u)
                and u.hp < 97  -- Needs healing
                and not u:Buff(buffs.riptide)  -- No Riptide buff (any caster)
            end
        )
        
        if needsRiptide then
            HealingEngine.SetTarget(needsRiptide:CallerId(), 1)
            return spell:Cast(needsRiptide)
        end
end)
-- Riptide: emergencies ignore buff, normal <96% & ≤6s, plus filler / anti-cap
Riptide:Callback(function(spell, unit)
        if not spell:ReadyToUse() then return end
        
        local player   = ConstUnit.player
        local party    = MakuluFramework.MultiUnits.party
        local inCombat = player:InCombat()
        
        -- Target state
        local hp   = unit:Health()
        local has  = unit:Buff(buffs.riptide, true)
        local rem  = (has and unit:BuffRemains(buffs.riptide, true)) or 0  -- ms
        
        -- Group snapshot
        local anyBelow60 = party:Count(function(u)
                return u:Exists() and not u:IsDeadOrGhost() and u:Health() < 60
        end) or 0
        
        -- Charges (if available in your build; safe if not)
        local charges, maxCharges = spell.Charges and spell:Charges() or nil, nil
        if type(charges) == "number" then
            maxCharges = select(2, spell:Charges())
        end
        
        
        -- EMERGENCY: never let someone die if a cast is available
        -- Ignore Riptide-overwrite rules here
        
        if hp <= 60 then
            return spell:Cast(unit)
        end
        
        -- NORMAL: <96% HP AND (no RT or ≤6s left)
        if hp < 96 and (not has or rem <= 6000) then
            return spell:Cast(unit)
        end
        
        -- FILLER / ANTI-CAP:
        -- - if we’re in combat and sitting capped on charges, dump one
        -- - or, if this unit is dipping and their RT is about to fall (<3s)
        if inCombat then
            if charges and maxCharges and charges == maxCharges then
                return spell:Cast(unit)
            end
            if (not has or rem <= 3000) and hp < 98 then
                return spell:Cast(unit)
            end
        end
end)


--################################################################################################################################################################################################################

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()
    SetUpHealers()
    
    local CantCast = CantCast()
    if CantCast then return end
    
    isStaying       = not player.moving
    stayingTime        = Player.stayTime
    movingTime      = Player.moveTime
    isMoving         = player.moving
    combatTime      = (player and player.CombatTime and player:CombatTime()) or 0
    playerHealth    = player.hp
    inMeleeRange    = target:Distance() <= 5
    
    --Buffs
    MovementCheck = (isStaying or player:Buff(buffs.spiritwalkersGrace) or player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness))
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Sum HP Deficit: ", MakMulti.party:Sum(function(unit) return unit.maxHealth - unit.healthActual end))
        local _, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
        MakPrint(2, "Dungeon ID: ", instanceID)
        MakPrint(3, "Healing Rain: ", C_ClassTalents.GetActiveHeroTalentSpec() ~= 54)
        MakPrint(4, "Surging Totem: ", C_ClassTalents.GetActiveHeroTalentSpec() == 54)
        local shouldDispel = MakMulti.party:Find(function(unit) return unit.poisoned end)
        MakPrint(5, "Poisoned: ", shouldDispel)
        MakPrint(6, "Party Count Below 95% HP: ", gameState.below95)
        MakPrint(7, "Party Size: ", gameState.partySize)
        MakPrint(8, "Should AoE Heal: ", shouldAoEHealing())
        MakPrint(9, "Spirit Link Totem Active: ", isTotemActive(SpiritLinkTotem))
        MakPrint(10, "Unleash Life HP %: ", A.GetToggle(2, "unleashLifeHP"))
        MakPrint(11, "Cloudburst Totem Healing: ", gameState.cloudburstHealing)
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[2] then
        if C_ClassTalents.GetActiveHeroTalentSpec() == 54 then
            if SurgingTotem.cd < 1000 and (A.SurgingTotem:IsBlocked() or A.GetToggle(2, "healingRainMode") == "Off") then
                Aware:displayMessage("Surge Totem Ready!", "Blue", 1)
            end
        else
            if HealingRain.cd < 1000 and A.HealingRain:IsTalentLearned() and (A.HealingRain:IsBlocked() or A.GetToggle(2, "healingRainMode") == "Off") then
                Aware:displayMessage("Healing Rain Ready!", "Blue", 1)
            end
        end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    if A.GetToggle(2, "pauseWhenWolf") and player:Buff(GhostWolf.wowName) then return end
    
    makInterrupt(interrupts)
    
    TotemicRecall()
    Skyfury()
    AstralShift()
    StoneBulwarkTotem()
    AncestralGuidance()
    EarthElemental()
    EarthlivingWeapon()
    TidecallersGuard()
    
    --Healing, no target needed
    if NotInPvP() then RampTrigger() end -- Manual ramp trigger button
    if NotInPvP() then RecallCloudburstTotem() end
    if NotInPvP() then AncestralVision() end
    CloudburstTotem()
    if NotInPvP() then Ascendance() end
    if NotInPvP() then HealingTideTotem() end
    if NotInPvP() then SpiritLinkTotem() end
    ManaTideTotem()
    
    if Action.Zone == "arena" then
        WindShear("every", target)
        GroundingTotem("arena")
        TremorTotem("arena")
        --HealingStreamTotem("arena")
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    --Set Unit
    local unit
    local healUnits = {target, focus}
    for _, healUnit in ipairs(healUnits) do
        if healUnit.exists and healUnit.isFriendly and HealingSurge:InRange(healUnit) then
            unit = healUnit
            break
        end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    --Healing Rotation
    if unit and NotInPvP() then
        if unit.isFriendly and HealingSurge:InRange(unit) then
            PurifySpirit(unit)
            
            -- Ramp sequence
            CloudburstTotem("ramp")
            UnleashLife("ramp", unit)
            AncestralSwiftness(unit)
            NaturesSwiftness(unit)
            
            -- Swiftness consumption: force an instant Chain Heal after Ancestral Swiftness
            ChainHeal("swift", unit)
            
            HealingSurge("swift", unit)
            HealingWave("swift", unit)
            HealingSurge("tidal", unit)
            HealingWave("tidal", unit)
            
            -- Riptide spreading (high priority for WW builds and AS windows)
            Riptide("spread", unit)
            
            -- Whispering Waves cleaving
            HealingWave("ww", unit)
            
            -- Regular abilities
            UnleashLife("all", unit)
            EarthenWallTotem(unit)
            HealingStreamTotem(unit)
            HealingWave("pWave", unit)
            Downpour()
            Wellspring()
            HealingRain()
            SurgingTotem()
            EarthShield("other", unit)
            PrimordialWave(unit)
            Riptide(unit)
            PoisonCleansingTotem()
            
            -- Chain Heal (lower priority for WW builds)
            ChainHeal("ww", unit)
            ChainHeal(unit)
            
            HealingSurge(unit)
            HealingWave(unit)
            SpiritwalkersGrace(unit)
        end
        EarthShieldP("self")
    end
    
    
    if unit and InPvP() then
        if unit.isFriendly and HealingSurge:InRange(unit) then
            
            -- Priority 1: Emergency/Instant Casts
            AncestralSwiftness("ohshit", unit)
            AncestralSwiftness("ohshitparty", unit)
            AncestralSwiftness('InPVP', unit)
            AncestralSwiftness("manaSave", unit)
            NaturesSwiftness('InPVP', unit)
            UnleashLife(unit)
            HealingWave("pvpSwift", unit) -- Instant with AS/NS
            PurifySpirit(unit)
            HealingTideTotem("5man")
            Ascendance("5man")

            -- Consume Ancestral Swiftness with Chain Heal if 3+ people below 80% party
            ChainHeal("swift", unit)

            CloudburstTotem("ramp")
            HealingStreamTotem('5man', unit)

            Riptide("tidalGen", unit) -- Primary heal - Use charges to maintain Tidal Waves and heal
            
            -- Priority 2: Tidal Waves Generators (Generate buff BEFORE consuming it)
            ChainHeal("ww", unit) -- Generate Tidal Waves + AoE healing
            ChainHeal(unit) -- Generate Tidal Waves + AoE healing
            
            -- Priority 3: Tidal Waves Consumers (Fast heals with Tidal Waves buff)
            HealingWave("mid", unit) -- Mid-range healing 80-94% HP with Tidal Waves
            HealingSurge("tidalWaves", unit) -- Urgent healing ≤85% HP with Tidal Waves
            
            -- Priority 4: Primary Heals & Cooldowns
            EarthenWallTotem(unit)
            Downpour()
            Wellspring()
            SurgingTotem()
            EarthShield("other", unit)
            PrimordialWave("pvp", unit)
            PoisonCleansingTotem()
            EarthShield("other2", unit)
            -- Priority 5: Filler Heals (with Tidal Waves requirement)
            HealingSurge("pvp", unit) -- Urgent healing ≤85% HP
            HealingWave("pvp", unit) -- Topping off 86-99% HP
            
            -- Priority 6: Movement/Fallback
            SpiritwalkersGrace(unit)
            HealingRain()
            
        end
        EarthShieldP("self2")
    end
    
    WaterShield() --not as high prio as self healing but not want to force it out of combat
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    --Damage Rotation
    if target.exists and target.canAttack and ChainLightning:InRange(target) then
        DamageRotation() -- Moved it in a new function because the mana slider was stopping everything instead of damage only =)
    end
    
    return FrameworkEnd()
end

--################################################################################################################################################################################################################

CleanseSpirit:Callback("pve", function(spell, friendly)
        local shouldDispel = friendly.cursed
        
        if not shouldDispel then return end
        
        return Debounce("cleanse", 350, 1500, spell, player)
end)

Purge:Callback("arena", function(spell, enemy)
        if not A.Purge:IsTalentLearned() then return end
        if not enemy.exists then return end
        if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end
        
        return spell:Cast(enemy)
end)

GreaterPurge:Callback("arena", function(spell, enemy)
        if not A.GreaterPurge:IsTalentLearned() then return end
        if not enemy.exists then return end
        if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end
        
        return spell:Cast(enemy)
end)

WindShear:Callback("arena", function(spell, enemy)
        if enemy:IsKickImmune() then return end
        if GroundingTotem:Used() < 1000 then return end
        if player:Buff(buffs.grounding) then return end
        if not enemy.exists then return end
        if enemy:BuffFrom(MakLists.KickImmune) then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 420) then return end
        
        return spell:Cast(enemy)
end)

FlameShock:Callback("arena", function (spell, enemy)
        if not enemy.exists then return end
        if enemy:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
        
        return spell:Cast(enemy)
end)

Hex:Callback("arena", function(spell, enemy)
        if enemy:IsCCImmune() then return end
        if getBelowHP(A.GetToggle(2, "stopCastPercent")) >= 1 then return end
        local aware = A.GetToggle(2, "makAware")
        if player.hp < 30 then return false end
        if target.hp < 20 then return false end
        if enemy:BuffFrom(MakLists.hexImmune) then return false end
        local ccRemains = 0
        if enemy.cc then
            ccRemains = enemy:CCRemains()
        end
        
        if gameState.imCasting and gameState.imCasting == spell.id then return end
        if enemy:IsTarget() then return end
        
        if ccRemains > Hex:CastTime() + MakGcd() then return end
        if enemy.incapacitateDr < 0.5 then return end
        
        if enemy.isHealer and target.hp <= 60 then
            if aware[1] then
                Aware:displayMessage("Hexing Healer", "Green", 1)
            end
            return spell:Cast(enemy)
        end
        
        --local peelParty = (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50)
        --if peelParty and not enemy.isHealer and enemy.hp > 40 then
        --    if aware[1] then
        --        Aware:displayMessage("Hexing To Peel", "Red", 1)
        --    end
        --    return spell:Cast(enemy)
        --end
end)

LightningLasso:Callback("arena", function(spell, enemy)
        -- hard-stops / global checks
        if enemy:IsCCImmune() then return end
        if getBelowHP(A.GetToggle(2, "stopCastPercent")) >= 1 then return end
        
        local aware = A.GetToggle(2, "makAware")
        if player.hp < 30 then return false end
        if target.hp < 20 then return false end
        
        -- optional stun-immunity list if you have one
        local lassoImmune = MakLists and (MakLists.stunImmune or MakLists.lassoImmune)
        if lassoImmune and enemy:BuffFrom(lassoImmune) then return false end
        
        -- current CC remaining on the enemy
        local ccRemains = 0
        if enemy.cc then
            ccRemains = enemy:CCRemains()
        end
        
        -- don't re-fire while we're already channeling/casting it
        if gameState.imCasting and gameState.imCasting == spell.id then return end
        
        -- don't lasso the current kill target if that's your rule
        if enemy:IsTarget() then return end
        
        -- don't start if they already have enough CC remaining to overlap
        if ccRemains > LightningLasso:CastTime() + MakGcd() then return end
        
        -- avoid bad DR (stun DR)
        if enemy.stunDr and enemy.stunDr < 0.5 then return end
        
        -- primary condition: lasso the healer when your target is pressured
        if enemy.isHealer and target.hp <= 60 then
            if aware[1] then
                Aware:displayMessage("Lassoing Healer", "Orange", 1)
            end
            return spell:Cast(enemy)
        end
        
        --[[ Example peel logic if you want it later
    -- local peelParty = (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50)
    -- if peelParty and not enemy.isHealer and enemy.hp > 40 then
    --     if aware[1] then
    --         Aware:displayMessage("Lassoing to Peel", "Red", 1)
    --     end
    --     return spell:Cast(enemy)
    -- end
    --]]
end)

PurifySpirit:Callback("arena", function(spell, friendly)
        if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
        if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
            return spell:Cast(friendly)
        end
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    
    Purge("arena", enemy)
    GreaterPurge("arena", enemy)
    WindShear("arena", enemy)
    Hex("arena", enemy)
    LightningLasso("arena", enemy)
    
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    PurifySpirit("arena", friendly)
    CleanseSpirit("pve", friendly)
    
    --EarthShieldParty("party", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    
    if stopCast() then
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end
    
    if Action.Zone == "arena" then
        partyRotation(party1)
        enemyRotation(arena1)
    else
        if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    end
    return FrameworkEnd()
end

A[7] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(party2)
        enemyRotation(arena2)
    end
    return FrameworkEnd()
end

A[8] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(party3)
        enemyRotation(arena3)
    end
    return FrameworkEnd()
end

A[9] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(MakUnit:new("party4"))
        enemyRotation(MakUnit:new("arena4"))
    end
    return FrameworkEnd()
end

A[10] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(player)
        enemyRotation(MakUnit:new("arena5"))
    end
    return FrameworkEnd()
end

--################################################################################################################################################################################################################
-- NOTES
--################################################################################################################################################################################################################
-- [1] is AntiFake CC rotation (limited, usually is single color like 0x00FF00 which is green)
-- [2] is AntiFake Kick rotation (racial, primary specialization interrupt spell)
-- [3] is Rotation (old launcher called it Single, supports all actions)
-- [4] is Secondary (old launcher called it AoE) rotation (supports all actions)
-- [5] is Trinket rotation (racial, specialization's spells which can remove CC)
-- [6] is Passive rotation (limited actions, usually @raid1, @party1, @arena1 and additional binds - for more info look notes in the launcher)
-- [7] is Passive rotation (limited actions, usually @raid2, @party2, @arena2)
-- [8] is Passive rotation (limited actions, usually @raid3, @party3, @arena3)
--Passive rotation doesn't require START button use like it does [1] -> [5] rotations

