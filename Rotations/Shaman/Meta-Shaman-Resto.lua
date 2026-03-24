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
local DebounceFunc     = MakuluFramework.debounce
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware
local as               = MakuluFramework.ArenaState
local cacheContext     = MakuluFramework.Cache
local Events           = MakuluFramework.Events
local DRList           = LibStub("DRList-1.0")

-- Helper function to get DR for a cast/channel spell
local function CastDr(castInfo, unit)
    if not castInfo or not castInfo.spellId then return 1 end
    local category = DRList:GetCategoryBySpellID(castInfo.spellId)
    if not category then return 1 end
    local categoryName = DRList:GetCategoryLocalization(category)
    if not categoryName then return 1 end
    return MakuluFramework.DR.Get(categoryName, rawget(unit, "guid")) or 1
end

-- Helper function for raw DR check
local function CastDrRaw(spellId, unit)
    if not spellId then return 1 end
    local category = DRList:GetCategoryBySpellID(spellId)
    if not category then return 1 end
    local categoryName = DRList:GetCategoryLocalization(category)
    if not categoryName then return 1 end
    return MakuluFramework.DR.Get(categoryName, rawget(unit, "guid")) or 1
end

-- Helper function to count dispellable buffs on a unit
local function BuffDispelCount(unit)
    local count = 0
    local buffs = unit:GetBuffs()
    if not buffs then return 0 end

    for _, buff in pairs(buffs) do
        if buff.dispelName == "Magic" then
            count = count + 1
        end
    end

    return count
end

local constCell        = cacheContext:getConstCacheCell()

local Action           = _G.Action
local Unit       	   = Action.Unit
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local UnitIsUnit	   = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable
local GetSpellTexture  = _G.TMW.GetSpellTexture

local CONST                               = Action.Const
local ACTION_CONST_STOPCAST               = CONST.STOPCAST

local BossMods         = Action.BossMods

local ActionID       = {
    AncestralCall               = { ID = 274738 },
    ArcanePulse                 = { ID = 260364 },
    ArcaneTorrent               = { ID = 50613 },
    BagOfTricks                 = { ID = 312411 },
    Berserking                  = { ID = 26297 },
    BloodFury                   = { ID = 20572 },
    BullRush                    = { ID = 255654 },
    Darkflight                  = { ID = 68992 },
    EscapeArtist                = { ID = 20589 },
    Fireblood                   = { ID = 265221 },
    GiftOfTheNaaru              = { ID = 59544 },
    Haymaker                    = { ID = 287712 },
    HyperOrganicLightOriginator = { ID = 312924 },
    LightsJudgment              = { ID = 255647 },
    QuakingPalm                 = { ID = 107079 },
    Regeneratin                 = { ID = 291944 },
    RocketBarrage               = { ID = 69041 },
    RocketJump                  = { ID = 69070 },
    Shadowmeld                  = { ID = 58984 },
    SpatialRift                 = { ID = 256948 },
    Stoneform                   = { ID = 20594 },
    WarStomp                    = { ID = 20549 },
    WillOfTheForsaken           = { ID = 7744 },
    WillToSurvive               = { ID = 59752 },

    AcidRain                 = { ID = 378443, Hidden = true },
    AlgariManaPotion         = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
    AncestralGuidance        = { ID = 108281 },
    AncestralProtectionTotem = { ID = 207399 },
    AncestralSwiftness       = { ID = 443454, Texture = 382550, offgcd = true },
    AncestralVision          = { ID = 212048 },
    ArenaPreparation         = { ID = 32727, Hidden = true },
    Ascendance               = { ID = 114052, offgcd = true, MAKULU_INFO = { heal = true } },
    AstralRecall             = { ID = 556 },
    AstralShift              = { ID = 108271, offgcd = true, },
    Bloodlust                = { ID = 2825, offgcd = true, MAKULU_INFO = { damageType = "magic" } },
    Burrow                   = { ID = 409293 },
    CapacitorTotem           = { ID = 192058, MAKULU_INFO = { damageType = "magic" } },
    ChainHeal                = { ID = 1064, FixedTexture = 136042 },
    ChainLightning           = { ID = 188443, MAKULU_INFO = { damageType = "magic" } },
    CleanseSpirit            = { ID = 51886 },
    CloudburstTotem          = { ID = 157153, MAKULU_INFO = { heal = true } },
    CounterstrikeTotem       = { ID = 204331 },
    Downpour                 = { ID = 462603, Texture = 383222, MAKULU_INFO = { heal = true } },
    EarthElemental           = { ID = 198103 },
    EarthGrabTotem           = { ID = 51485, MAKULU_INFO = { damageType = "magic" } },
    EarthShield              = { ID = 974 },
    --EarthShieldP             = { ID = 974, Texture = 291944, Hidden = false, Macro = "/cast [@player]Earth Shield" }, --Regenratin
    EarthbindTotem           = { ID = 2484, MAKULU_INFO = { damageType = "magic" } },
    EarthenWallTotem         = { ID = 198838, MAKULU_INFO = { heal = true } },
    EarthlivingWeapon        = { ID = 382021 },
    ElementalOrbit           = { ID = 383010, Hidden = true },
    ElementalPotion1         = { Type = "Potion", ID = 191387, Texture = 176108, Hidden = true },
    ElementalPotion2         = { Type = "Potion", ID = 191388, Texture = 176108, Hidden = true },
    ElementalPotion3         = { Type = "Potion", ID = 191389, Texture = 176108, Hidden = true },
    ElementalUltimate1       = { Type = "Potion", ID = 191381, Texture = 176108, Hidden = true },
    ElementalUltimate2       = { Type = "Potion", ID = 191382, Texture = 176108, Hidden = true },
    ElementalUltimate3       = { Type = "Potion", ID = 191383, Texture = 176108, Hidden = true },
    FarSight                 = { ID = 6196 },
    FlameShock               = { ID = 470411, MAKULU_INFO = { damageType = "magic" } },
    FlametongueWeapon        = { ID = 318038 },
    FrontlinePotion          = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    FrostShock               = { ID = 196840, MAKULU_INFO = { damageType = "magic" } },
    GhostWolf                = { ID = 2645 },
    GreaterPurge             = { ID = 378773, MAKULU_INFO = { damageType = "magic" } },

    GroundingTotem           = { ID = 204336 },
    GustOfWind               = { ID = 192063 },
    HealingRain              = { ID = 73920, Texture = 383222, MAKULU_INFO = { heal = true } },
    HealingStreamTotem       = { ID = 5394 },
    HealingSurge             = { ID = 8004 },
    HealingTideTotem         = { ID = 108280, MAKULU_INFO = { heal = true } },
    HealingWave              = { ID = 77472, MAKULU_INFO = { heal = true } },
    Healthstone              = { Type = "Item", ID = 5512, Hidden = true },
    Hex                      = { ID = 51514, MAKULU_INFO = { damageType = "magic" } },
    ImprovedPurifySpirit     = { ID = 383016, Hidden = true },
    LavaBurst                = { ID = 51505, MAKULU_INFO = { damageType = "magic" } },
    LightningBolt            = { ID = 188196, Texture = 29166, MAKULU_INFO = { damageType = "magic" } },
    LightningLasso           = { ID = 305483, MAKULU_INFO = { damageType = "magic" } },
    LightningShield          = { ID = 192106 },
    ManaTideTotem            = { ID = 16191 },
    NaturesSwiftness         = { ID = 378081, Texture = 382550 },
    PoisonCleansingTotem     = { ID = 383013 },
    PotionofUnwaveringFocus  = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    PrimordialWave           = { ID = 428332, FixedTexture = 3578231, MAKULU_INFO = { heal = true } },

    Purge                    = { ID = 370, MAKULU_INFO = { damageType = "magic" } },
    PurifySpirit             = { ID = 77130 },
    RecallCloudburstTotem    = { ID = 201764, Texture = 223493, Hidden = true, MAKULU_INFO = { heal = true } },
    Riptide                  = { ID = 61295, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    Skyfury                  = { ID = 462854 },

    SpiritLinkTotem          = { ID = 98008, MAKULU_INFO = { heal = true } },
    SpiritwalkersGrace       = { ID = 79206 },
    StaticFieldTotem         = { ID = 355580, MAKULU_INFO = { damageType = "magic" } },
    StoneBulwarkTotem        = { ID = 108270, MAKULU_INFO = { damageType = "magic" } },

    SurgingTotem             = { ID = 444995, Texture = 383222, MAKULU_INFO = { damageType = "magic" } },
    TemperedPotion           = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },

    TherazanesResilience     = { ID = 1217622, Hidden = true },
    Thunderstorm             = { ID = 51490, MAKULU_INFO = { damageType = "magic" } },

    TidalWavesBuff           = { ID = 53390, Hidden = true },
    TidecallersGuard         = { ID = 457481, FixedTexture = 133667, },
    TotemicProjection        = { ID = 108287 },
    TotemicRecall            = { ID = 108285 },
    TremorTotem              = { ID = 8143 },
    UnleashLife              = { ID = 73685, MAKULU_INFO = { heal = true } },
    UnleashShield            = { ID = 356736, MAKULU_INFO = { damageType = "magic" } },
    WaterShield              = { ID = 52127 },
    WaterWalking             = { ID = 546 },
    Wellspring               = { ID = 197995, MAKULU_INFO = { heal = true } },
    WindRushTotem            = { ID = 192077, MAKULU_INFO = { damageType = "magic" } },

    WindShear                = { ID = 57994, MAKULU_INFO = { damageType = "magic" } },
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
for name, attributes in pairs(ConstSpells) do -- add this for loop
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
}

local buffs = {
    arenaPreparation = 32727,
    battlegroundPreparation = 44521,
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
    spiritOfRedemption = 215982,
    spiritOfTheRedeemer = 215769,
    riptide = 61295,
}

local debuffs = {
    flameShock = 188389,
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

local function activeEnemies()
    return math.max(enemiesInMelee(), 1) --MultiUnits:GetActiveEnemies(40) 
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
    if combatTime == 0 then return end
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

local function shouldUseRamp()
    -- Ramp healing is proactive healing before incoming damage
    -- For now, always allow ramp abilities in combat
    -- This can be expanded with boss-specific logic or toggle settings
    if not player.inCombat then return false end
    return true
end

local function getPartyList()
    return constCell:GetOrSet("partyList", function()
        -- Build list manually using Action's Unit() to get ALL raid members
        local members = {}

        if IsInRaid() then
            -- In raid/battleground - check all 40 raid slots
            for i = 1, 40 do
                local unit = MakUnit:new("raid" .. i)
                if unit.exists and not unit.dead and unit.distance < 50 and not unit.healImmune then
                    table.insert(members, unit)
                end
            end
        else
            -- In party/arena - check player + 4 party members
            local playerUnit = MakUnit:new("player")
            if playerUnit.exists and not playerUnit.dead and not playerUnit.healImmune then
                table.insert(members, playerUnit)
            end

            for i = 1, 4 do
                local unit = MakUnit:new("party" .. i)
                if unit.exists and not unit.dead and unit.distance < 50 and not unit.healImmune then
                    table.insert(members, unit)
                end
            end
        end

        -- Sort by HP (with offset for player)
        local myOffset = 0
        if player.ehp > 30 then
            local total, _, _, _, cds = player:AttackersV69()
            if total < 2 and cds < 1 then
                myOffset = 40
            end
        end

        table.sort(members, function(a, b)
            return ((a.isMe and a.ehp + myOffset) or a.ehp) < ((b.isMe and b.ehp + myOffset) or b.ehp)
        end)

        -- Convert to Group object so it has :ForEach(), :Filter(), etc.
        return MakMulti.group:FromMultiUnits(members)
    end)
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

    -- Count party members within totem range (46 yards) for totem-based healing decisions
    gameState.below95 = MakMulti.party:Count(function(unit) return unit.ehp < 95 and unit.distance <= 46 end)
    gameState.below90 = MakMulti.party:Count(function(unit) return unit.ehp < 90 and unit.distance <= 46 end)
    gameState.below85 = MakMulti.party:Count(function(unit) return unit.ehp < 85 and unit.distance <= 46 end)
    gameState.below80 = MakMulti.party:Count(function(unit) return unit.ehp < 80 and unit.distance <= 46 end)
    gameState.below75 = MakMulti.party:Count(function(unit) return unit.ehp < 75 and unit.distance <= 46 end)
    gameState.below70 = MakMulti.party:Count(function(unit) return unit.ehp < 70 and unit.distance <= 46 end)
    gameState.partySize = MakMulti.party:Size()

    if player:Buff(buffs.cloudburstTotem) then
        gameState.cloudburstHealing = player:HasBuffPoints(buffs.cloudburstTotem)[1]
    else
        gameState.cloudburstHealing = 0
    end

    gameState.healingModifier = 1

end

local function CanUseRiptide()
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
    if player.combatTime > 0 then return end
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

--[[
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

EarthShieldP:Callback("self2", function(spell)
    if not spell:ReadyToUse() then return end
    -- optional: don't do self-maintenance during emergencies
    if player.inCombat and getBelowHP(50) > 0 then return end

    if player:Buff(383648) then return end  -- ES already on self
    return spell:Cast(player)
end)
]]

EarthShield:Callback("other", function(spell, unit)
    if player.inCombat and getBelowHP(50) > 0 then return end

    -- Don't cast on player at all (this callback is for "other" units only)
    if unit.isMe then return end

    -- Check the correct buff ID based on target
    local buffId = unit.isMe and buffs.earthShieldOrbit or buffs.earthShield

    -- Don't cast if target already has Earth Shield
    if unit:Buff(buffId, true) then
        return
    end

    -- PvP/Arena/Battleground specific logic
    if Action.Zone == "arena" or Action.Zone == "pvp" then
        -- Arena prep: put on party1
        if player:Buff(buffs.arenaPreparation) then
            if party1.exists and not party1:Buff(buffs.earthShield, true) then
                HealingEngine.SetTarget(party1:CallerId(), 1)
                return spell:Cast(party1)
            end
            return
        end

        -- Battleground prep: put on other healer
        if player:Buff(buffs.battlegroundPreparation) then
            local otherHealer = MakMulti.party:Find(function(u)
                if not u.exists or u:IsDeadOrGhost() then return end
                if u.isMe then return end
                if not u.isHealer then return end
                if not spell:InRange(u) then return end
                local healerBuffId = u.isMe and buffs.earthShieldOrbit or buffs.earthShield
                if u:Buff(healerBuffId, true) then return end
                return true
            end)
            if otherHealer then
                HealingEngine.SetTarget(otherHealer:CallerId(), 1)
                return spell:Cast(otherHealer)
            end
            return
        end

        -- In combat PvP: cast on person under 55% HP
        if player.inCombat then
            local lowTarget = MakMulti.party:Find(function(u)
                if not u.exists or u:IsDeadOrGhost() then return end
                if u.isMe then return end
                if u.hp >= 55 then return end
                if not spell:InRange(u) then return end
                local targetBuffId = u.isMe and buffs.earthShieldOrbit or buffs.earthShield
                if u:Buff(targetBuffId, true) then return end
                return true
            end)
            if lowTarget then
                HealingEngine.SetTarget(lowTarget:CallerId(), 2)
                return spell:Cast(lowTarget)
            end
        end
        return
    end

    -- PvE logic below
    if not player:TalentKnown(TherazanesResilience.id) then
        if MakMulti.party:Any(function(u)
            local checkBuffId = u.isMe and buffs.earthShieldOrbit or buffs.earthShield
            return u:HasBuffCount(checkBuffId, true) > A.GetToggle(2, "earthShieldStacks")
        end) then
            return
        end
    else
        if MakMulti.party:Any(function(u)
            local checkBuffId = u.isMe and buffs.earthShieldOrbit or buffs.earthShield
            return u.isTank and u:Buff(checkBuffId, true)
        end) then
            return
        end
    end

    if tank:IsUnit(unit) then
        local tankBuffId = tank.isMe and buffs.earthShieldOrbit or buffs.earthShield
        if tank:HasBuffCount(tankBuffId) <= A.GetToggle(2, "earthShieldStacks") then
            return spell:Cast(unit)
        end
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

EarthShield:Callback("other2", function(spell)
    if not spell:ReadyToUse() then return end
    -- Only cast in arena
    if Action.Zone ~= "arena" then return end
    -- Stop entirely if any tank exists
    local tankExists = MakMulti.party:Any(function(u)
        return u.exists and not u:IsDeadOrGhost() and u:IsTank()
    end)
    if tankExists then return end
    -- First non-tank under 70% without ES
    local target = MakMulti.party:Find(function(u)
        if not u.exists or u:IsDeadOrGhost() then return end
        if u:IsMe() or not u:IsFriendly() or not spell:InRange(u) then return end
        if u:IsTank() then return end
        if u.hp >= 70 then return end
        -- Check the correct buff ID based on target
        local buffId = u.isMe and buffs.earthShieldOrbit or buffs.earthShield
        if u:Buff(buffId, true) then return end
        return true
    end)
    if target then
        return spell:Cast(target)
    end
end)

EarthShield:Callback("self", function(spell)
    -- Don't cast if player already has Earth Shield Orbit buff
    if player:Buff(buffs.earthShieldOrbit, true) then return end

    -- Don't cast if someone else already has Earth Shield (unless in PvP)
    if Action.Zone ~= "arena" and Action.Zone ~= "pvp" then
        if MakMulti.party:Any(function(u)
            if u.isMe then return false end
            return u:Buff(buffs.earthShield, true)
        end) then
            return
        end
    end

    return spell:Cast(player)
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(player)
end)

BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

Purge:Callback(function(spell)
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

    if isTotemActive(CloudburstTotem) then return end

    if sumPartyHPDeficit > 2000000 or shouldDefensive() then
        return spell:Cast(player)
    end
end)

RecallCloudburstTotem:Callback(function(spell)
    if not IsPlayerSpell(CloudburstTotem.id) then return end

    local sumPartyHPDeficit = MakMulti.party:Sum(function(unit) return unit.maxHealth - unit.healthActual end)
    if not isTotemActive(CloudburstTotem) then return end

    if sumPartyHPDeficit > gameState.cloudburstHealing and gameState.cloudburstHealing > 6000000 then
        return spell:Cast(player)
    end
    if not player.inCombat and A.GetToggle(2, "autoPopCB") then
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
        -- HealingEngine.SetTarget(magicked:CallerId(), 1)
        return Debounce("cleanse", 1000, 2500, spell, unit)
    end

    if cursed and player:TalentKnown(ImprovedPurifySpirit.id) then
        -- HealingEngine.SetTarget(cursed:CallerId(), 1)
        return Debounce("cleanse", 1000, 2500, spell, unit)
    end
end)

PoisonCleansingTotem:Callback(function(spell)
    local shouldDispel = MakMulti.party:Find(function(unit) return unit.poisoned end)
    
    if not shouldDispel then return end

    return Debounce("pct", 1000, 2500, spell, player)
end)

AncestralSwiftness:Callback(function(spell, unit)
    if not player:TalentKnown(AncestralSwiftness.id) then return end
    if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
    if player:Buff(buffs.spiritwalkersGrace) then return end
    if player:Buff(buffs.spatialParadox) then return end

    if unit.ehp > 45 then return end

    return spell:Cast(player)
end)

NaturesSwiftness:Callback(function(spell, unit)
    if player:TalentKnown(AncestralSwiftness.id) then return end
    if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
    if player:Buff(buffs.spiritwalkersGrace) then return end
    if player:Buff(buffs.spatialParadox) then return end

    if unit.ehp > 45 then return end

    return spell:Cast(player)
end)

HealingSurge:Callback("swift", function(spell, unit)
    if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end

    if not AutoHeal(unit:CallerId(), A.HealingSurge) then return end

    return spell:Cast(unit)
end)

HealingWave:Callback("swift", function(spell, unit)
    if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end

    if not AutoHeal(unit:CallerId(), A.HealingWave) then return end

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

    return spell:Cast(unit)
end)

EarthenWallTotem:Callback(function(spell, unit)
    if isMoving then return end

    if player.combatTime < 3 then return end
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

ManaTideTotem:Callback(function(spell)
	if isMoving then return end
    if player.combatTime < 3 then return end
    if player.manaPct >= 80 then return end

    return spell:Cast(player)
end)

HealingWave:Callback("pWave", function(spell, unit)
	if not MovementCheck then return end
    if not player:Buff(buffs.primordialWave) then return end

    if not AutoHeal(unit:CallerId(), A.HealingWave) then return end

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

    -- Spread during Ancestral Swiftness windows for instant Riptides
    if player:Buff(buffs.ancestralswiftness) then
        shouldSpread = true
    end

    if not shouldSpread then return end

    -- Actively search for targets without Riptide
    local needsRiptide = MakMulti.party:Lowest(
        function(u) return u.hp end,
        function(u)
            return u.exists
            and not u:IsDeadOrGhost()
            and not u:Buff(buffs.riptide, true)
            and u.hp < 98
        end
    )

    if needsRiptide then
        return spell:Cast(needsRiptide)
    end
end)

Riptide:Callback(function(spell, unit)
    if not CanUseRiptide() then return end

    local riptideHP = A.GetToggle(2, "riptideHP")
    if not AutoHealOrSlider(unit:CallerId(), A.Riptide, riptideHP) then return end

    return spell:Cast(unit)
end)

UnleashLife:Callback(function(spell, unit)
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    if unit.hp < 98 then
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
    local chainHealMode = A.GetToggle(2, "chainHealMode")
    if chainHealMode == "Auto" then return end

    local unleashLifeHP = A.GetToggle(2, "unleashLifeHP")
    if not AutoHealOrSlider(unit:CallerId(), A.UnleashLife, unleashLifeHP) then return end

    return spell:Cast(unit)
end)

UnleashLife:Callback("ch", function(spell, unit)

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

HealingWave:Callback(function(spell, unit)
    if not MovementCheck then return end

    local healingWaveHP = A.GetToggle(2, "healingWaveHP")
    if not AutoHealOrSlider(unit:CallerId(), A.HealingWave, healingWaveHP) then return end

    return spell:Cast(unit)
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
    if target:DebuffRemains(debuffs.flameShock, true) > 2500 then return end

    return spell:Cast(target)
end)

LavaBurst:Callback("surge", function(spell)
    if not player:Buff(buffs.lavaSurge) then return end

    return spell:Cast(target)
end)

ChainLightning:Callback(function(spell)
    if not MovementCheck then return end
    if activeEnemies() < 2 then return end

    return spell:Cast(target)
end)

LavaBurst:Callback(function(spell)
    if not MovementCheck then return end

    return spell:Cast(target)
end)

LightningBolt:Callback(function(spell)
    if not MovementCheck then return end

    return spell:Cast(target)
end)

FrostShock:Callback(function(spell)
    return spell:Cast(target)
end)

local function DamageRotation()
    if player.manaPct > A.GetToggle(2, "ManaTresholdDpsSlider") then 
        Purge()
        BloodFury()
        Berserking()
        Fireblood()
        AncestralCall()
        HealingRain("acid")
        SurgingTotem("acid")
        FlameShock()
        LavaBurst("surge")
        ChainLightning()
        LavaBurst()
        LightningBolt()
        FrostShock()
    end
end

GroundingTotem:Callback("arena", function(spell)
    if target.exists and target.canAttack and target.hp < 20 then return end
    if WindShear:Used() < 1000 then return end
    --TEST
    --if target.exists and target:PvpKick(Maklists.arenaGrounding) then
    --    return spell:Cast(player)
    --end
    if arena1.exists and arena1:CastingFromFor(MakLists.arenaGrounding, 450) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        return spell:Cast(player)
    end

    if arena2.exists and arena2:CastingFromFor(MakLists.arenaGrounding, 450) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        return spell:Cast(player)
    end

    if arena3.exists and arena3:CastingFromFor(MakLists.arenaGrounding, 450) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        return spell:Cast(player)
    end
end)

TremorTotem:Callback("arena", function(spell)
    if not spell:ReadyToUse() then return end
    local onlyHeals = A.GetToggle(2, "OnlyTremorHealer")
    if target.exists and target.hp < 20 then return end

    -- Get nearby enemies once for both checks
    local nearbyEnemies = MultiUnits:GetActiveUnitPlates()

    -- PROACTIVE: Priest within 8 yards (anticipate Psychic Scream)
    for _, unitID in pairs(nearbyEnemies) do
        local unit = ActionUnit(unitID)
        if unit:IsExists() and not unit:IsDeadOrGhost() and unit:IsEnemy() then
            if unit:Class() == "PRIEST" and unit:GetRange() <= 8 then
                -- Stop casting and drop Tremor preemptively
                if Player:IsCasting() or Player:IsChanneling() then
                    SpellStopCasting()
                end
                print("Tremor - Priest nearby!")
                return spell:Cast(player)
            end
        end
    end

    -- REACTIVE: Warlock casting Fear on player (50%+ duration or no DR)
    for _, unitID in pairs(nearbyEnemies) do
        local unit = ActionUnit(unitID)
        if unit:IsExists() and not unit:IsDeadOrGhost() and unit:IsEnemy() then
            if unit:Class() == "WARLOCK" and unit:IsCasting() then
                local spellID = select(9, UnitCastingInfo(unitID)) or select(9, UnitChannelInfo(unitID))
                -- Fear spell IDs: 5782 (Fear), 118699 (Fear - with glyph), 5484 (Howl of Terror)
                if spellID == 5782 or spellID == 118699 or spellID == 5484 then
                    local castTarget = unit:GetUnitTarget()
                    if castTarget and UnitIsUnit(castTarget, "player") then
                        -- Check DR on fear (0 DR = full duration, use Tremor)
                        -- For now, always Tremor warlock fear on player
                        if Player:IsCasting() or Player:IsChanneling() then
                            SpellStopCasting()
                        end
                        print("Tremor - Warlock casting Fear on you!")
                        return spell:Cast(player)
                    end
                end
            end
        end
    end

    -- REACTIVE: Party members already feared (500ms+ duration)
    if (party1.isHealer or not onlyHeals) and party1:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        print("Tremor on party1")
        return spell:Cast(player)
    end

    if (party2.isHealer or not onlyHeals) and party2:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        print("Tremor on party2")
        return spell:Cast(player)
    end

    -- REACTIVE: Raid members already feared (500ms+ duration)
    if IsInRaid() then
        for i = 1, 40 do
            local unitID = "raid" .. i
            if UnitExists(unitID) and not UnitIsDeadOrGhost(unitID) then
                local raidMember = MakUnit:new(unitID)
                if raidMember and raidMember.exists then
                    if (raidMember.isHealer or not onlyHeals) and raidMember:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
                        if Player:IsCasting() or Player:IsChanneling() then
                            SpellStopCasting()
                        end
                        print("Tremor on " .. unitID)
                        return spell:Cast(player)
                    end
                end
            end
        end
    end

    -- REACTIVE: Player feared
    if player:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        if Player:IsCasting() or Player:IsChanneling() then
            SpellStopCasting()
        end
        print("Tremor - You are feared!")
        return spell:Cast(player)
    end
end)

local function stopCast()
    local currentCast, _, castRemains,_ = myCast()
    if currentCast then
        local unitsBelow50 = getBelowHP(A.GetToggle(2, "stopCastPercent"))
        -- Stop casting if powerful healing is urgently needed,
        if unitsBelow50 >= 1 then
            if currentCast == LightningBolt.id or currentCast == LavaBurst.id or currentCast == ChainLightning.id or currentCast == Hex.id then
                return true
            end
        end
    end
end

--################################################################################################################################################################################################################

local function HealerRotationPve()
    --Healing Rotation PVE
    if unit then
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
            ChainHeal("ww", unit)
            ChainHeal(unit)
            HealingSurge(unit)
            HealingWave("ww", unit)
            HealingWave(unit)
            SpiritwalkersGrace(unit)
        end
    end

    --EarthShieldP("self") --not as high prio as self healing but not want to force it out of combat
    WaterShield() --not as high prio as self healing but not want to force it out of combat
end

local function HealerRotationPvp()
    --Healing Rotation PVP
    if unit then
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
            Riptide("arena", unit)

            -- Priority 2: Tidal Waves Generators (Generate buff BEFORE consuming it)
            ChainHeal("ww", unit) -- Generate Tidal Waves + AoE healing
            ChainHeal(unit) -- Generate Tidal Waves + AoE healing

            -- Priority 3: Tidal Waves Consumers (Fast heals with Tidal Waves buff)
            HealingWave("mid", unit) -- Mid-range healing 80-94% HP with Tidal Waves
            HealingSurge("tidalWaves", unit) -- Urgent healing ≤85% HP with Tidal Waves

            -- Priority 4: Cooldowns/Totems
            Downpour()
            Wellspring()
            SurgingTotem()
            EarthShield("other", unit)
            PrimordialWave("pvp", unit)
            PoisonCleansingTotem()
            --EarthShield("other2", unit)

            -- Priority 5: Filler Heals (with Tidal Waves requirement)
            HealingSurge("pvp", unit) -- Urgent healing ≤85% HP
            HealingWave("wwPvp", unit) -- Whispering Waves cleave
            HealingWave("pvp", unit) -- Topping off 86-99% HP

            -- Priority 6: Movement/Fallback
            SpiritwalkersGrace(unit)
            HealingRain()
            Riptide("moving", unit)

        end
        EarthShield("self")
    end

    WaterShield() --not as high prio as self healing but not want to force it out of combat
end

--################################################################################################################################################################################################################

local lastExecTime = 0

local function mainLoop(icon)
	FrameworkStart(icon)
    updateGameState()
    SetUpHealers()

    local healable = getPartyList()

    unit = healable:Lowest(function(friendly)
        return (friendly.isMe and friendly.ehp + 10) or friendly.ehp
    end) or player

    if target.exists and target.isFriendly then
        if target.ehp < unit.ehp then
            unit = target
        end
    end

    local alpha = 0
    if focus.exists then

        local plates = MakuluFramework.Plates.load()
        local found = plates[rawget(focus, "guid")]

        if found then
            alpha = focus:Los()
        end
    end

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
        MakPrint(12, "Focus Alpha: ", alpha)
        MakPrint(13, "Unit name: ", unit.name)
        MakPrint(14, "Last Exec time: ", lastExecTime)
        MakPrint(15, "Healable Count: ", healable:Size())
        MakPrint(16, "In Raid: ", IsInRaid())
        MakPrint(17, "Group Members: ", GetNumGroupMembers())
    end

	local CantCast = CantCast()
	if CantCast then return end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= player.combatTime
	playerHealth	= player.hp
	inMeleeRange	= target:Distance() <= 5

	--Buffs
	MovementCheck = (isStaying or player:Buff(buffs.spiritwalkersGrace) or player:Buff(buffs.naturesswiftness))
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
    RecallCloudburstTotem()
    AncestralVision()
    CloudburstTotem()
    Ascendance()
    HealingTideTotem()
    SpiritLinkTotem()
    ManaTideTotem()

    if Action.Zone == "arena" then
        WindShear("every", target)
        GroundingTotem("arena")
        TremorTotem("arena")
        --HealingStreamTotem("arena")
    end

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if A.IsInPvP then
        HealingTideTotem("5man")
        Ascendance("5man")
        WindShear("every", target)
        GroundingTotem("arena")
        TremorTotem("arena")
        HealingStreamTotem('5man', unit)
    end
    
    --Healing Rotation
    if A.IsInPvP then
        HealerRotationPvp()
    else
        HealerRotationPve()
    end

    --Damage Rotation
    if target.exists and target.canAttack and ChainLightning:InRange(target) then
        DamageRotation() -- Moved it in a new function because the mana slider was stopping everything instead of damage only =)
    end

	return FrameworkEnd()
end

local function profile(icon)
    local start = debugprofilestop()
    local res = mainLoop(icon)
    lastExecTime = debugprofilestop() - start
    return res
end

A[3] = profile

--################################################################################################################################################################################################################

-- PVP Callbacks
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

AncestralSwiftness:Callback("manaSave", function(spell, unit)
    if not player:TalentKnown(AncestralSwiftness.id) then return end
    if not player.inCombat then return end
    if (player:Buff(buffs.naturesswiftness) or player:Buff(buffs.ancestralswiftness)) then return end
    if player:Buff(buffs.spiritwalkersGrace) then return end
    if player:Buff(buffs.spatialParadox) then return end
    if player.mana > 50 then return end  -- Only use when below 50% mana
    if unit and unit.hp >= 98 then return end  -- Only use if someone needs healing

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

-- PvP: Healing Wave with AS/NS buff - No AutoHeal check for emergency healing
HealingWave:Callback("pvpSwift", function(spell, unit)
    if not player:Buff(buffs.ancestralswiftness) and not player:Buff(buffs.naturesswiftness) then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    -- In raids, only use Healing Wave on targets with Riptide
    if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end

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

-- Riptide - Cast on targets <98% HP without Riptide buff OR when player needs Tidal Waves
Riptide:Callback("tidalGen", function(spell, unit)
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
    if unit.hp >= 99 then return end

    -- Only purpose: Generate Tidal Waves buff
    -- Cast Riptide if we don't have Tidal Waves buff
    if not player:Buff(buffs.tidalWaves, true) then
        return spell:Cast(unit)
    end
end)

-- Riptide - If moving and health below %
Riptide:Callback("moving", function(spell, unit)
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
    if unit.hp >= 90 then return end

    return spell:Cast(unit)
end)

-- PvP: Riptide - More aggressive, cast on both dps without Riptide
Riptide:Callback("arena", function(spell)
    -- Don't cast in starting room (arena preparation buff)
    if player:Buff(32727) then return end -- Arena Preparation buff ID

    if not CanUseRiptide() then return end
    if not spell:ReadyToUse() then return end

    -- Iterate through ALL party/raid members
    local healable = getPartyList()
    return healable:ForEach(function(unit)
        -- Heal anyone below 98% without Riptide buff
        if unit.hp < 98 and not unit:Buff(buffs.riptide, true) then
            return spell:Cast(unit)
        end
    end)
end)

-- Healing Surge when target ≤90% AND YOU have Tidal Waves (buff on player)
HealingSurge:Callback("tidalWaves", function(spell, unit)
    if not MovementCheck then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end
    if unit.hp > 90 then return end
    if not player:Buff(buffs.tidalWaves, true) then return end

    return spell:Cast(unit)
end)

-- PvP: Healing Surge for urgent healing (≤85% HP) - Emergency fallback when can't generate Tidal Waves
HealingSurge:Callback("pvp", function(spell, unit)
    if not MovementCheck then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    -- Only cast if we have 0 Tidal Waves AND 0 Riptide charges (emergency fallback)
    local hasTidalWaves = player:Buff(buffs.tidalWaves, true)
    local riptideCharges = Riptide:Charges() or 0
    if hasTidalWaves or riptideCharges > 0 then return end

    -- Only cast on urgent targets (≤85% HP)
    if unit.hp > 85 then return end

    return spell:Cast(unit)
end)

-- Healing Wave for mid-range healing (80-94% HP) with Tidal Waves
HealingWave:Callback("mid", function(spell, unit)
    if not MovementCheck then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    -- Require Tidal Waves buff
    if not player:Buff(buffs.tidalWaves, true) then return end

    -- Only cast on mid-range targets (80-94% HP)
    if unit.hp < 80 or unit.hp >= 94 then return end

    return spell:Cast(unit)
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
        return
    end

    -- Cast on any injured target if there are Riptide targets to cleave
    if unit.ehp < 95 then
        return spell:Cast(unit)
    end
end)

-- PvP: Healing Wave for topping off (86-99% HP) - Emergency fallback when can't generate Tidal Waves
HealingWave:Callback("pvp", function(spell, unit)
    if not MovementCheck then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    -- Only cast if we have 0 Tidal Waves AND 0 Riptide charges (emergency fallback)
    local hasTidalWaves = player:Buff(buffs.tidalWaves, true)
    local riptideCharges = Riptide:Charges() or 0
    if hasTidalWaves or riptideCharges > 0 then return end

    -- Only cast on topping off targets (86-99% HP)
    if unit.hp < 86 or unit.hp >= 95 then return end

    -- In raids, only use Healing Wave on targets with Riptide
    if gameState.partySize > 5 and not unit:Buff(buffs.riptide, true) then return end

    return spell:Cast(unit)
end)

-- PvP: Whispering Waves cleave version - Actively search for Riptide targets
HealingWave:Callback("wwPvp", function(spell, unit)
    -- In raids, use HW to cleave on Riptide targets (regardless of WW talent)
    if not gameState.isWhisperingWaves and gameState.partySize <= 5 then return end
    if not MovementCheck then return end
    if not spell:ReadyToUse() then return end
    if not unit or not unit.exists or unit:IsDeadOrGhost() then return end

    -- Require Tidal Waves buff for faster cast time
    if not player:Buff(buffs.tidalWaves, true) then return end

    -- Only cast on targets with Riptide buff that need healing
    if unit.hp >= 95 then return end
    if not unit:Buff(buffs.riptide, true) then return end

    return spell:Cast(unit)
end)

-- Healing Tide Totem – works in PvE, PvP, and SOLO
HealingTideTotem:Callback("5man", function(spell)
    if not player.inCombat then return end
    if not spell:ReadyToUse() then return end

    local party = MakMulti.party

    -- Count injured party members at different thresholds (within totem range: 46 yards)
    local below70 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 70 and u.distance <= 46
    end) or 0

    local below60 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 60 and u.distance <= 46
    end) or 0

    local below45 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 45 and u.distance <= 46
    end) or 0

    -- Don't overlap with Ascendance unless 2+ people are critically low (below 45%)
    if Ascendance:ReadyToUse() and below45 < 2 then
        return
    end

    -- Universal logic: 1 person below 45% OR 2 people below 60% OR 3 people below 70%
    if below45 >= 1 or below60 >= 2 or below70 >= 3 then
        return spell:Cast(player)
    end
end)

-- Ascendance – universal callback (solo/party/raid, PvE/PvP)
Ascendance:Callback("5man", function(spell)
    if not player.inCombat then return end
    if not spell:ReadyToUse() then return end

    local party = MakMulti.party

    -- Count injured party members at different thresholds (within 40 yards for Ascendance healing)
    local below70 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 70 and u.distance <= 40
    end) or 0

    local below60 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 60 and u.distance <= 40
    end) or 0

    local below45 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 45 and u.distance <= 40
    end) or 0

    -- Don't overlap with Healing Tide Totem unless 2+ people are critically low (below 45%)
    if HealingTideTotem:ReadyToUse() and below45 < 2 then
        return
    end

    -- Universal logic: 1 person below 45% OR 2 people below 60% OR 3 people below 70%
    if below45 >= 1 or below60 >= 2 or below70 >= 3 then
        return spell:Cast(player)
    end
end)

HealingStreamTotem:Callback('5man', function(spell)
    -- Don't use Healing Stream Totem if Cloudburst Totem talent is chosen
    if IsPlayerSpell(157153) then return end
    if not spell:ReadyToUse() then return end

    local party = MakMulti.party

    -- Track charges
    local charges, maxCharges = spell:Charges()
    if not charges then charges = 0 end
    if not maxCharges then maxCharges = 2 end

    -- Count injured party members at different thresholds (within totem range: 46 yards)
    local below70 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 70 and u.distance <= 46
    end) or 0

    local below60 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 60 and u.distance <= 46
    end) or 0

    local below45 = party:Count(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 45 and u.distance <= 46
    end) or 0

    -- Emergency logic (use second charge): 1 below 45% OR 2 below 60% OR 3 below 70%
    if below45 >= 1 or below60 >= 2 or below70 >= 3 then
        if charges > 0 then
            return spell:Cast(player)
        end
    end

    -- In combat: keep at least 1 charge on cooldown (use first charge liberally)
    if player.inCombat and charges >= 2 then
        return spell:Cast(player)
    end
end)

PurifySpirit:Callback("arena", function(spell, friendly)
    if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
    if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
        return spell:Cast(friendly)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

-- Priority Totem Killer (Grounding Totem, Tremor Totem)
FlameShock:Callback('totem', function(spell)
    -- Don't waste GCD on totems if anyone in party is below 65% HP
    local partyNeedsHealing = MakMulti.party:Any(function(friendly)
        return friendly.exists and friendly.hp < 65
    end)
    if partyNeedsHealing then return end

    -- Find priority totems (low HP totems that need instant removal)
    local priorityTotem = MakMulti.enemies:Find(function(enemy)
        if not enemy:IsTotem() then return false end
        if not spell:InRange(enemy) then return false end
        if enemy.dead then return false end

        -- Priority totems: Grounding Totem, Tremor Totem (both have 50 HP)
        local totemName = enemy.name
        if totemName == "Grounding Totem" or totemName == "Tremor Totem" then
            return true
        end

        return false
    end)

    if priorityTotem then
        if A.GetToggle(2, "makAware") and A.GetToggle(2, "makAware")[1] then
            Aware:displayMessage("Killing " .. priorityTotem.name, "Shaman", 1, GetSpellTexture(spell.id))
        end
        return spell:Cast(priorityTotem)
    end
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

    -- don't overlap with existing CC
    if ccRemains > spell:CastTime() + MakGcd() then return end

    -- DR check (optional)
    if enemy.stunDr < 0.5 then return end

    -- Healer priority when target is low
    if enemy.isHealer and target.hp <= 60 then
        if aware[1] then
            Aware:displayMessage("Lassoing Healer", "Yellow", 1)
        end
        return spell:Cast(enemy)
    end
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
    FlameShock("totem") -- Kill priority totems (Grounding, Tremor)
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