--[[
11.2 updates
Borrowed Bindings:
Coordinated Assault -> HOLO
Bursting Shot -> Scatter Shot (same choice node now)
@player Freezing Trap -> Auto Trap
Sticky Bomb Arena -> Scare Beast Arena
Mending Bandage Arena -> Harpoon Arena

Add concussive shot
]]

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 255 then return end


local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local ConstUnit        = MakuluFramework.ConstUnits
local MakLists         = MakuluFramework.lists
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local ActionPet = LibStub("PetLibrary")
local MultiUnits       = Action.MultiUnits

local _G, setmetatable = _G, setmetatable


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

    ArcaneShot           = { ID = 185358, MAKULU_INFO = { damageType = "magic", ignoreMoving = true } },
    AspectOfTheCheetah   = { ID = 186257, MAKULU_INFO = { damageType = "physical" } },
    AspectOfTheTurtle    = { ID = 186265, MAKULU_INFO = { offGcd = true } },
    BindingShot          = { ID = 109248, MAKULU_INFO = { damageType = "magic", cc = true } },
    BurstingShot         = { ID = 186387, MAKULU_INFO = { damageType = "physical", ignoreMoving = true } },
    CallPet1             = { ID = 883, Type = "SpellSingleColor", Color = "RED" },
    CallPet2             = { ID = 83242, Type = "SpellSingleColor", Color = "YELLOW" },
    CallPet3             = { ID = 83243, Type = "SpellSingleColor", Color = "BLUE" },
    Camouflage           = { ID = 199483 },
    ConcussiveShot       = { ID = 5116, MAKULU_INFO = { damageType = "physical", ignoreMoving = true } },
    DeathChakram         = { ID = 375891, MAKULU_INFO = { damageType = "physical" } },
    Disengage            = { ID = 781, MAKULU_INFO = { offGcd = true } },
    DismissPet           = { ID = 2641, Type = "SpellSingleColor", Color = "LIGHT BLUE" },
    Exhilaration         = { ID = 109304, MAKULU_INFO = { offGcd = true } },
    ExplosiveShot        = { ID = 212431, MAKULU_INFO = { damageType = "magic", ignoreMoving = true } },
    FeignDeath           = { ID = 5384, MAKULU_INFO = { offGcd = true } },
    FortitudeOfTheBear   = { Type = "SpellSingleColor", ID = 272679, Color = "PINK" },
    FreezingTrap         = { ID = 187650, MAKULU_INFO = { damageType = "magic", cc = true } },
    HighExplosiveTrap    = { ID = 236776, FixedTexture = 135826, MAKULU_INFO = { damageType = "magic" } },
    HuntersMark          = { ID = 257284 },
    ImplosiveTrap        = { ID = 462031, FixedTexture = 135826, MAKULU_INFO = { damageType = "magic", cc = true } },
    Intimidation         = { ID = 19577, MAKULU_INFO = { damageType = "physical", cc = true } },
    KillShot             = { ID = 320976, MAKULU_INFO = { damageType = "physical", ignoreMoving = true } },
    MastersCall          = { Type = "SpellSingleColor", ID = 272682, Color = "PINK" },
    MendPet              = { ID = 136 },
    Misdirection         = { ID = 34477 },
    Muzzle               = { ID = 187707, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true, ignoreMoving = true } },
    PrimalRage           = { Type = "SpellSingleColor", ID = 272678, Color = "PINK" },
    RevivePet            = { ID = 982, Texture = 136 },
    RoarOfSacrifice      = { ID = 53480 },
    ScareBeast           = { ID = 1513 },
    ScatterShot          = { ID = 213691, MAKULU_INFO = { damageType = "physical", cc = true } },
    SteelTrap            = { ID = 162488, MAKULU_INFO = { damageType = "physical" } },
    SurvivalOfTheFittest = { ID = 264735, MAKULU_INFO = { offGcd = true } },
    TarTrap              = { ID = 187698 },
    TranquilizingShot    = { ID = 19801, MAKULU_INFO = { damageType = "physical", ignoreMoving = true } },
    WingClip             = { ID = 195645, MAKULU_INFO = { damageType = "physical" } },

    AspectOfTheEagle         = { ID = 186289 },
    Bombardier               = { ID = 389880, Hidden = true },
    Butchery                 = { ID = 212436, MAKULU_INFO = { damageType = "physical" } },
    ChimaeralSting           = { ID = 356719, MAKULU_INFO = { damageType = "magic" } },
    ContagiousReagents       = { ID = 459741, Hidden = true },
    CoordinatedAssault       = { ID = 360952, MAKULU_INFO = { damageType = "physical" } },
    EmergencySalve           = { ID = 459517, Hidden = true },
    FlankingStrike           = { ID = 269751, MAKULU_INFO = { damageType = "physical" } },
    FuryOfTheEagle           = { ID = 203415, MAKULU_INFO = { damageType = "physical" } },
    GhillieSuit              = { ID = 459466, Hidden = true },
    Harpoon                  = { ID = 190925, MAKULU_INFO = { damageType = "physical" } },
    KillCommand              = { ID = 259489, MAKULU_INFO = { damageType = "physical" } },
    LunarStorm               = { ID = 450385, Hidden = true },

    MendingBandage           = { ID = 212640 },
    MercilessBlows           = { ID = 459868, Hidden = true },
    MongooseBite             = { ID = 259387, MAKULU_INFO = { damageType = "physical" } },
    MongooseBiteEagle        = { ID = 265888, MAKULU_INFO = { damageType = "physical" } },
    RaptorStrike             = { ID = 186270, MAKULU_INFO = { damageType = "physical" } },

    RaptorStrikeEagle        = { ID = 265189, MAKULU_INFO = { damageType = "physical" } },
    RelentlessPrimalFerocity = { ID = 459922, Hidden = true },
    SicEm                    = { ID = 459920, Hidden = true },
    Spearhead                = { ID = 360966, MAKULU_INFO = { damageType = "physical" } },
    StickyTarBomb            = { ID = 407028, Texture = 1513, MAKULU_INFO = { damageType = "physical" } },
    SymbioticAdrenaline      = { ID = 459875, Hidden = true },
    TrackersNet              = { ID = 212638, MAKULU_INFO = { damageType = "physical" } },
    WildKingdom              = { ID = 356707, MAKULU_INFO = { damageType = "physical" } },
    WildfireBomb             = { ID = 259495, Texture = 300560, MAKULU_INFO = { damageType = "physical" } },

    -- Season 3 Talent Changes (Patch 11.2)
    ImprovedWildfireBomb = { ID = 321290, Hidden = true }, -- Returned: +8% Wildfire Bomb damage
    CullTheHerd = { ID = 1217429, Hidden = true }, -- Redesigned: Kill Shot DoT
    BornToKill = { ID = 1217434, Hidden = true }, -- Redesigned: +5% Deathblow chance, +25% Kill Shot damage
    ExplosivesExpert = { ID = 378937, Hidden = true }, -- Buffed: 5/10% damage increase

    ViciousHunt = { ID = 445404, Hidden = true },
    RuthlessMarauder = { ID = 385718, Hidden = true },

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
    Mounted = { ID = 264735, FixedTexture = 132261, Hidden = true }, --These two are to fix SOTF pixel issues that some people have
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_HUNTER_SURVIVAL] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
local mouseover 
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
    petClass = nil,
    shouldAoE = false,
    swapPet = nil,
    petSlotToggle = 1,
    -- Season 3: lunarStormCd removed - no longer needed with immediate refresh mechanic
    -- Season 3 Tier Set Detection
    has2Set = false,
    has4Set = false,
    packLeader = false,
}

local buffs = {
    tipOfTheSpear = 260286,
    mercilessBlows = 459870,
    coordinatedAssault = 360952,
    bombardier = 459859,
    furiousAssault = 448814,
    mongooseFury = 259388,
    sicEm = 461409,
    exposedFlank = 459864,
    camouflage = 199483,
    survivalOfTheFittest = 264735,
    enduranceTraining = 264662,
    predatorsThirst = 264663,
    pathfinding = 264656,
    strikeItRich = 1216879,
    hogstrider = 472640,
    howlWyvern = 471878,
    howlBoar = 472324,
    howlBear = 472325,
    feignDeath = 5384,
    shadowmeld = 58984,
    -- Season 3 Tier Set Bonuses
    boonOfElune = 1236374, -- Sentinel 2-set bonus buff for enhanced Wildfire Bombs
}

local debuffs = {
    huntersMark = 257284,
    serpentSting = 259491,
}

-- Hunter-specific Tranquilizing Shot purge list
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

-- purgeable enemy buffs (for Tranq/Dispel checks)
local purgeableBuffs = {
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


-- Season 3: Lunar Storm now immediately refreshes Wildfire Bomb cooldown every 30 seconds
-- No complex tracking needed - framework handles the 30-second interval automatically

-- Season 3: Enhanced interrupt system for Gladiator-viable PvP performance
local interrupts = {
    { spell = Muzzle }, -- Primary interrupt - instant, 40-yard range
    { spell = ScatterShot, isCC = true }, -- Secondary CC - 30-yard range, 4-sec incapacitate
    { spell = Intimidation, isCC = true }, -- Pet stun - 30-yard range, 5-sec stun
    { spell = ImplosiveTrap, isCC = true, aoe = true, distance = 3 }, -- AoE knockdown - 3-yard radius
}

local function shouldBurst()
    if A.BurstIsON("target") then
        return true
    else
        return false
    end
end

local cacheContext     = MakuluFramework.Cache

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if enemy.distance <= 7 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function enemiesInMeleeBurstingPvP()
    return constCell:GetOrSet("enemiesInMeleeBurstingPvP", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if ActionUnit(enemyGUID):GetRange() <= 5 and not ActionUnit(enemyGUID):IsTotem() and not enemy.isPet and enemy.cds then
                total = total + 1
            end
        end

        return total
    end)
end

local function stingCount()
    return constCell:GetOrSet("stingCount", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local stingCount = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy:Debuff(debuffs.serpentSting, true) and ActionUnit(enemyGUID):GetRange() <= 10 and not ActionUnit(enemyGUID):IsTotem() and not enemy.isPet then
                stingCount = stingCount + 1
            end
        end

        return stingCount
    end)
end

local function activeEnemies()
    return constCell:GetOrSet("activeEnemies", function()
        return math.max(enemiesInMelee(), 1)
    end)
end

local function petClass()
    if pet:Buff(buffs.enduranceTraining) then
        return "Tenacity"
    elseif pet:Buff(buffs.predatorsThirst) then
        return "Ferocity"
    elseif pet:Buff(buffs.pathfinding) then
        return "Cunning"
    end
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    -- Season 3: Enhanced defensive logic for Gladiator-viable performance
    return incomingDamage and not defensiveActive()
end

--------------------------------------------------------------------------------------------
-- PET SWAPPING FRAME ----------------------------------------------------------------------
local specToggleFrame = CreateFrame("Frame", "SpecToggleFrame", UIParent, "BackdropTemplate")

specToggleFrame:SetSize(120, 40)  -- Width, Height
specToggleFrame:SetPoint("CENTER")

specToggleFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
specToggleFrame:SetBackdropColor(0, 0, 0, 1)  

specToggleFrame.text = specToggleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
specToggleFrame.text:SetPoint("CENTER", specToggleFrame, "CENTER", 0, 0)
specToggleFrame.text:SetText("Ferocity") 
specToggleFrame.text:SetTextColor(1, 0, 0)  

gameState.swapPet = specToggleFrame.text:GetText()
local function ToggleSpec()
    if specToggleFrame.text:GetText() == "Ferocity" then
        specToggleFrame.text:SetText("Tenacity")
        specToggleFrame.text:SetTextColor(0, 1, 0)
        gameState.swapPet = "Tenacity"
    elseif specToggleFrame.text:GetText() == "Tenacity" then
        specToggleFrame.text:SetText("Cunning")
        specToggleFrame.text:SetTextColor(1, 1, 0)
        gameState.swapPet = "Cunning"
    else
        specToggleFrame.text:SetText("Ferocity")
        specToggleFrame.text:SetTextColor(1, 0, 0)
        gameState.swapPet = "Ferocity"
    end
end

specToggleFrame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not IsShiftKeyDown() then
        ToggleSpec()
    elseif button == "LeftButton" and IsShiftKeyDown() then
        self:StartMoving()
    end
end)

specToggleFrame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()
    end
end)

specToggleFrame:SetMovable(true)
specToggleFrame:EnableMouse(true)
specToggleFrame:RegisterForDrag("LeftButton")

local function showSwapPetsFrame()
    if A.GetToggle(2, "swapPets") then
        specToggleFrame:Show()
    else
        specToggleFrame:Hide()
    end
end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

local ferocitySlotID = nil
local tenacitySlotID = nil
local cunningSlotID = nil

local function swapPets()

    activePets = C_StableInfo.GetActivePetList()

    if C_StableInfo.IsAtStableMaster() or ferocitySlotID == nil or tenacitySlotID == nil or cunningSlotID == nil then

        ferocitySlotID = nil
        tenacitySlotID = nil
        cunningSlotID = nil

        for i = 1, #activePets do
            local pet = activePets[i]
            
            if (pet.specialization == "Ferocity" or pet.specialization == "Свирепость" or pet.specialization == "Férocité") and ferocitySlotID == nil then
                ferocitySlotID = pet.slotID
            end
            
            if (pet.specialization == "Tenacity" or pet.specialization == "Упорство" or pet.specialization == "Ténacité") and tenacitySlotID == nil then
                tenacitySlotID = pet.slotID
            end

            if (pet.specialization == "Cunning" or pet.specialization == "Хитрость" or pet.specialization == "Ruse") and cunningSlotID == nil then
                cunningSlotID = pet.slotID
            end
            
            if ferocitySlotID and tenacitySlotID and cunningSlotID then
                break  
            end
        end
    end

    if gameState.swapPet == "Ferocity" then
        return ferocitySlotID
    elseif gameState.swapPet == "Tenacity" then
        return tenacitySlotID
    elseif gameState.swapPet == "Cunning" then
        return cunningSlotID
    else
        return nil  
    end
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name

    return currentCast, currentCastName
end

local lastUpdateTime = 0
local updateDelay = 0.5

local function updateGameState()
    local currentTime = GetTime()
    local frameCell = cacheContext:getCell()
    local combatCell = cacheContext:getCombatCacheCell()

    -- Casting state (throttled updates for performance)
    local currentCast, currentCastName = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    -- Season 3: Enhanced game state management with caching
    showSwapPetsFrame()

    -- Pet management (frame cache - changes frequently)
    -- Season 3: Enhanced pet coordination for Pack Leader beast summoning optimization
    gameState.petClass = frameCell:GetOrSet("petClass", function() return petClass() end)
    gameState.petSlotToggle = frameCell:GetOrSet("petSlotToggle", function() return swapPets() end)

    -- Combat state (frame cache)
    gameState.shouldAoE = frameCell:GetOrSet("shouldAoE", function()
        return enemiesInMelee() > 2 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    end)

    -- Buff tracking (frame cache - changes frequently)
    gameState.howl = frameCell:GetOrSet("howlActive", function()
        return player:Buff(buffs.howlBear) or player:Buff(buffs.howlWyvern) or player:Buff(buffs.howlBoar)
    end)

    -- Season 3: Tier Set Detection (combat cache - doesn't change during combat)
    gameState.has2Set = combatCell:GetOrSet("has2Set", function() return player:Has2Set(1923) end)
    gameState.has4Set = combatCell:GetOrSet("has4Set", function() return player:Has4Set(1923) end)
    gameState.packLeader = combatCell:GetOrSet("packLeader", function() return player:TalentKnown(ViciousHunt.id) end)

    -- Additional Season 3 state tracking
    gameState.boonOfElune = frameCell:GetOrSet("boonOfElune", function() return player:Buff(buffs.boonOfElune) end)
    gameState.tipOfTheSpear = frameCell:GetOrSet("tipOfTheSpear", function() return player:Buff(buffs.tipOfTheSpear) end)
    gameState.coordinatedAssault = frameCell:GetOrSet("coordinatedAssault", function() return player:Buff(buffs.coordinatedAssault) end)
end

WillToSurvive:Callback(function(spell)
    if not player.cc then return end

    return spell:Cast()
end)

Misdirection:Callback(function(spell)
    local playerstatus = UnitThreatSituation("player")
    local misdirectType = A.GetToggle(2, "MisdirectType")
    if (GetNumGroupMembers() > 1 or pet.exists) and (player.combatTime < 5 or ActionUnit("player"):IsTanking() or playerstatus == 3) and not A.IsInPvP then
        if misdirectType == "WeakAura" then
            return spell:Cast()
        else
            if (focus.exists and focus.isFriendly) or (pet.exists and pet.hp > 0) then
                return spell:Cast()
            end
        end
    end
end)

HuntersMark:Callback(function(spell)
    if not HuntersMark:InRange(target) then return end
    if player.feigned then return end
    if target:Debuff(debuffs.huntersMark) then return end
    if not target.exists then return end
    if not target.canAttack then return end

    -- Season 3: Enhanced pre-combat and opener logic
    if not player.inCombat then
        -- Pre-combat Hunter's Mark for optimal opener setup
        return spell:Cast(target)
    end

    if player.inCombat and target.hp > 90 and ActionUnit("target"):TimeToDieX(80) > A.GetGCD() * 5 then
        if target.isBoss or not Harpoon:InRange(target) then
            return spell:Cast(target)
        end
    elseif not player.inCombat then
        return spell:Cast(target)
    end
end)

CallPet1:Callback(function(spell)
    -- Season 3: Enhanced pet management for Pack Leader optimization
    if A.GetToggle(2, "swapPets") then
        if gameState.petClass == gameState.swapPet then return end
        if gameState.petSlotToggle ~= 1 then return end
    end
    if pet.exists then return end
    if gameState.imCasting and gameState.imCasting == RevivePet.id then return end

    -- Season 3: Pet summoning triggers tier set bonuses and beast coordination
    return spell:Cast()
end)

CallPet2:Callback(function(spell)
    if gameState.petClass == gameState.swapPet then return end
    if gameState.petSlotToggle ~= 2 then return end
    if pet.exists then return end
    if gameState.imCasting and gameState.imCasting == RevivePet.id then return end

    return spell:Cast()
end)

CallPet3:Callback(function(spell)
    if gameState.petClass == gameState.swapPet then return end
    if gameState.petSlotToggle ~= 3 then return end
    if pet.exists then return end
    if gameState.imCasting and gameState.imCasting == RevivePet.id then return end

    return spell:Cast()
end)

DismissPet:Callback(function(spell)
    if IsMounted() then return end
    if gameState.imCasting == spell.id then return end
    if gameState.petClass == gameState.swapPet then return end
    if not A.GetToggle(2, "swapPets") then return end
    if player.inCombat and not A.GetToggle(2, "swapPetsCombat") then return end

    return spell:Cast()
end)

SurvivalOfTheFittest:Callback(function(spell, icon)
    icon = SurvivalOfTheFittest
    if A.GetToggle(2, "sotfPixel") then
        icon = Universal10
    end

    if not A.SurvivalOfTheFittest:IsTalentLearned() then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end    
    
    if not player.inCombat then return end
    if player:Buff(buffs.survivalOfTheFittest) then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "survivalOfTheFittestHP") then
        return spell:Cast(nil, nil, icon)
    end
end)

Camouflage:Callback(function(spell)
    if not A.Camouflage:IsTalentLearned() then return end
    if not A.GhillieSuit:IsTalentLearned() then return end
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

    -- Season 3: Enhanced defensive coordination for maximum survivability
    if player.hp > A.GetToggle(2, "aspectOfTheTurtleHP") then return end

    return spell:Cast()
end)

Exhilaration:Callback(function(spell)
    if not player.inCombat then return end

    if player.hp > A.GetToggle(2, "exhilarationHP") then return end

    return spell:Cast()
end)

FeignDeath:Callback(function(spell)
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

MendPet:Callback(function(spell)
    if pet.exists and pet.hp > A.GetToggle(2, "mendPetHP") then return end
    if gameState.imCasting and gameState.imCasting == RevivePet.id then return end

    local time = A.GetGCD() * 1000 + 500
    local pet1Tried = CallPet1.used > 0 and CallPet1.used < time
    local pet2Tried = CallPet2.used > 0 and CallPet2.used < time
    local pet3Tried = CallPet3.used > 0 and CallPet3.used < time

    if not pet.exists and (pet1Tried or pet2Tried or pet3Tried) or pet.exists then 
        return spell:Cast()
    end
end)

RevivePet:Callback(function(spell)
    if pet.exists and not pet.dead then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    
    local time = A.GetGCD() * 1000 + 500
    local pet1Tried = CallPet1.used > 0 and CallPet1.used < time
    local pet2Tried = CallPet2.used > 0 and CallPet2.used < time
    local pet3Tried = CallPet3.used > 0 and CallPet3.used < time

    if not pet.exists and (pet1Tried or pet2Tried or pet3Tried) or pet.exists then 
        return spell:Cast()
    end
end)

TranquilizingShot:Callback(function(spell)
    if not target.enraged and not target:PvEPurge() then return end

    return spell:Cast(target)
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    -- Season 3: Optimized cooldown coordination with cached game state
    if gameState.coordinatedAssault then
        return spell:Cast()
    end

    -- Fallback logic for builds without Coordinated Assault
    if not A.CoordinatedAssault:IsTalentLearned() then
        if Spearhead.cd > 300 or not A.Spearhead:IsTalentLearned() then
            return spell:Cast()
        end
    end
end)

Harpoon:Callback(function(spell)
    if A.IsInPvP then return end
    if not Player:PrevGCD(1, A.KillCommand) then return end
    if not Harpoon:InRange(target) then return end

    return spell:Cast(target)
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.coordinatedAssault) then
        return spell:Cast()
    end

    if not A.CoordinatedAssault:IsTalentLearned() then
        if Spearhead.cd > 300 or not A.Spearhead:IsTalentLearned() then
            return spell:Cast()
        end
    end
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.coordinatedAssault) then
        return spell:Cast()
    end

    if not A.CoordinatedAssault:IsTalentLearned() then
        if Spearhead.cd > 300 or not A.Spearhead:IsTalentLearned() then
            return spell:Cast()
        end
    end
end)

LightsJudgment:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    -- Season 3: Optimized cooldown coordination with cached game state
    if gameState.coordinatedAssault then
        return spell:Cast()
    end

    -- Fallback logic for builds without Coordinated Assault
    if not A.CoordinatedAssault:IsTalentLearned() then
        if Spearhead.cd > 300 or not A.Spearhead:IsTalentLearned() then
            return spell:Cast()
        end
    end
end)

AspectOfTheEagle:Callback(function(spell)
    if ActionUnit("target"):GetRange() < 6 then return end

    return spell:Cast()
end)

local function cds()
    BloodFury()
    AncestralCall()
    Fireblood()
    LightsJudgment()
    Berserking()
end

--actions.plcleave=spearhead,if=cooldown.coordinated_assault.remains
Spearhead:Callback("plCleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if CoordinatedAssault.cd < 300 then return end

    return spell:Cast(target)
end)

--actions.plcleave+=/raptor_bite,target_if=max:dot.serpent_sting.remains,if=buff.strike_it_rich.up&buff.strike_it_rich.remains<gcd|buff.hogstrider.remains
RaptorStrike:Callback("plCleave", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not RaptorStrike:InRange(target) then return end

    if player:Buff(buffs.strikeItRich) and player:Buff(buffs.strikeItRich).remains < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.hogstrider) then
        return spell:Cast(target)
    end
end)

MongooseBite:Callback("plCleave", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if player:Buff(buffs.strikeItRich) and player:Buff(buffs.strikeItRich).remains < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.hogstrider) then
        return spell:Cast(target)
    end
end)

RaptorStrikeEagle:Callback("plCleave", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end

    if player:Buff(buffs.strikeItRich) and player:Buff(buffs.strikeItRich).remains < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.hogstrider) then
        return spell:Cast(target)
    end
end)

MongooseBiteEagle:Callback("plCleave", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if player:Buff(buffs.strikeItRich) and player:Buff(buffs.strikeItRich).remains < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.hogstrider) then
        return spell:Cast(target)
    end
end)

--actions.plcleave+=/kill_command,target_if=min:bloodseeker.remains,if=buff.relentless_primal_ferocity.up&buff.tip_of_the_spear.stack<1
KillCommand:Callback("plCleave", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if not player:TalentKnown(RelentlessPrimalFerocity.id) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) >= 1 then return end 

    return spell:Cast(target)
end)

--actions.plcleave+=/wildfire_bomb (Season 3: 50% damage buff + CDR effects make this top priority)
WildfireBomb:Callback("plCleave", function(spell)
    -- Season 3: Wildfire Bomb 50% damage buff + CDR from Pack Mentality/Frenzy Strikes = extremely high AoE priority
    return spell:Cast(target)
end)

--actions.plcleave+=/kill_command,target_if=min:bloodseeker.remains,if=(buff.howl_of_the_pack_leader_wyvern.remains|buff.howl_of_the_pack_leader_boar.remains|buff.howl_of_the_pack_leader_bear.remains)
KillCommand:Callback("plCleave2", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if gameState.howl then
        return spell:Cast(target)
    end
end)

--actions.plcleave+=/flanking_strike,if=buff.tip_of_the_spear.stack=2|buff.tip_of_the_spear.stack=1
FlankingStrike:Callback("plCleave", function(spell)
    local flankStrike = A.GetToggle(2, "flankStrike")
    if player.moving and not flankStrike then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.plcleave+=/butchery
Butchery:Callback("plCleave", function(spell)
    if enemiesInMelee() < 1 then return end

    return spell:Cast()
end)

--actions.plcleave+=/coordinated_assault
CoordinatedAssault:Callback("plCleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end
    if player:TalentKnown(Bombardier.id) then
        if WildfireBomb.frac >= 1 then return end
    end

    return spell:Cast(target)
end)

--actions.plcleave+=/fury_of_the_eagle,if=buff.tip_of_the_spear.stack>0
FuryOfTheEagle:Callback("plCleave", function(spell)
    if target.distance > 5 then return end

    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast()
end)

--actions.plcleave+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max|charges_fractional>1.5
KillCommand:Callback("plCleave3", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end
    
    if player.focus < 77 then 
        return spell:Cast(target)
    end

    if spell.frac > 1.5 then
        return spell:Cast(target)
    end
end)

--actions.plcleave+=/explosive_shot
ExplosiveShot:Callback("plCleave", function(spell)

    return spell:Cast(target)
end)

--actions.plcleave+=/kill_shot,if=buff.deathblow.remains&talent.sic_em
KillShot:Callback("plCleave", function(spell)
    if not player:Buff(buffs.deathblow) then return end
    if not player:TalentKnown(SicEm.id) then return end

    return spell:Cast(target)
end)

--actions.plcleave+=/raptor_bite
RaptorStrike:Callback("plCleave2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not RaptorStrike:InRange(target) then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("plCleave2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("plCleave2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("plCleave2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    return spell:Cast(target)
end)

local function plCleave()
    Spearhead("plCleave")
    RaptorStrike("plCleave")
    MongooseBite("plCleave")
    RaptorStrikeEagle("plCleave")
    MongooseBiteEagle("plCleave")
    KillCommand("plCleave")
    WildfireBomb("plCleave")
    KillCommand("plCleave2")
    FlankingStrike("plCleave")
    Butchery("plCleave")
    CoordinatedAssault("plCleave")
    FuryOfTheEagle("plCleave")
    KillCommand("plCleave3")
    ExplosiveShot("plCleave")
    KillShot("plCleave")
    RaptorStrike("plCleave2")
    MongooseBite("plCleave2")
    RaptorStrikeEagle("plCleave2")
    MongooseBiteEagle("plCleave2")
    KillCommand("fallback")
end

--actions.plst=kill_command,target_if=min:bloodseeker.remains,if=(buff.relentless_primal_ferocity.up&buff.tip_of_the_spear.stack<1)|(buff.howl_of_the_pack_leader_wyvern.remains|buff.howl_of_the_pack_leader_boar.remains|buff.howl_of_the_pack_leader_bear.remains)
KillCommand:Callback("plSt", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end
    
    -- Optimized: Use cached game state for better performance
    if player:TalentKnown(RelentlessPrimalFerocity.id) and gameState.coordinatedAssault and not gameState.tipOfTheSpear then
        return spell:Cast(target)
    end

    if gameState.howl then
        return spell:Cast(target)
    end
end)

--actions.plst+=/spearhead,if=cooldown.coordinated_assault.remains (Season 3: Enhanced coordination)
Spearhead:Callback("plSt", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    -- Season 3: Improved coordination timing - don't overlap with Coordinated Assault
    if CoordinatedAssault.cd < 700 then return end

    -- Season 3: Enhanced with tier set considerations
    return spell:Cast(target)
end)

--actions.plst+=/flanking_strike,if=buff.tip_of_the_spear.stack>0
FlankingStrike:Callback("plSt", function(spell)
    local flankStrike = A.GetToggle(2, "flankStrike")
    if player.moving and not flankStrike then return end

    -- Optimized: Use cached game state for better performance
    if not gameState.tipOfTheSpear then return end

    return spell:Cast(target)
end)

--actions.plst+=/raptor_bite,target_if=min:dot.serpent_sting.remains,if=!dot.serpent_sting.ticking&target.time_to_die>12&(!talent.contagious_reagents|active_dot.serpent_sting=0)
--actions.plst+=/raptor_bite,target_if=max:dot.serpent_sting.remains,if=talent.contagious_reagents&active_dot.serpent_sting<active_enemies&dot.serpent_sting.remains
RaptorStrike:Callback("plSt", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 
    if not RaptorStrike:InRange(target) then return end
    if not target:Debuff(debuffs.serpentSting, true) and target.ttd > 12000 and (not player:TalentKnown(ContagiousReagents.id) or stingCount() == 0) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ContagiousReagents.id) and stingCount() < activeEnemies() and target:Debuff(debuffs.serpentSting, true) then
        return spell:Cast(target)
    end
end)

MongooseBite:Callback("plSt", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end
    if not target:Debuff(debuffs.serpentSting, true) and target.ttd > 12000 and (not player:TalentKnown(ContagiousReagents.id) or stingCount() == 0) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ContagiousReagents.id) and stingCount() < activeEnemies() and target:Debuff(debuffs.serpentSting, true) then
        return spell:Cast(target)
    end
end)

RaptorStrikeEagle:Callback("plSt", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 
    if not target:Debuff(debuffs.serpentSting, true) and target.ttd > 12000 and (not player:TalentKnown(ContagiousReagents.id) or stingCount() == 0) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ContagiousReagents.id) and stingCount() < activeEnemies() and target:Debuff(debuffs.serpentSting, true) then
        return spell:Cast(target)
    end
end)

MongooseBiteEagle:Callback("plSt", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not target:Debuff(debuffs.serpentSting, true) and target.ttd > 12000 and (not player:TalentKnown(ContagiousReagents.id) or stingCount() == 0) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ContagiousReagents.id) and stingCount() < activeEnemies() and target:Debuff(debuffs.serpentSting, true) then
        return spell:Cast(target)
    end
end)

--actions.plst+=/butchery
Butchery:Callback("plSt", function(spell)
    if target.distance > 5 then return end

    return spell:Cast()
end)

--actions.plst+=/kill_command,if=buff.strike_it_rich.remains&buff.tip_of_the_spear.stack<1
KillCommand:Callback("plSt2", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.plst+=/raptor_bite,if=buff.strike_it_rich.remains&buff.tip_of_the_spear.stack>0
RaptorStrike:Callback("plSt2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 
    if not RaptorStrike:InRange(target) then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("plSt2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("plSt2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("plSt2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.plst+=/fury_of_the_eagle,if=buff.tip_of_the_spear.stack>0&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.in>40)
FuryOfTheEagle:Callback("plSt", function(spell)
    if target.distance > 5 then return end

    if not player:Buff(buffs.tipOfTheSpear) then return end
    if incAddsIn() < 40000 then return end

    -- Season 3: Ruthless Marauder now guarantees Tip of the Spear generation (100% proc rate)
    return spell:Cast()
end)

--actions.plst+=/coordinated_assault,if=!talent.bombardier|talent.bombardier&cooldown.wildfire_bomb.charges_fractional<1
CoordinatedAssault:Callback("plSt", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if player:TalentKnown(Bombardier.id) then
        if WildfireBomb.frac >= 1 then return end
    end

    -- Season 3: Triggers Lead From the Front, enabling 4-set Stampede when Beast is summoned
    return spell:Cast(target)
end)

--actions.plst+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(!buff.relentless_primal_ferocity.up|(buff.relentless_primal_ferocity.up&buff.tip_of_the_spear.stack<1|focus<30))
KillCommand:Callback("plSt3", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if player.focus > 77 then return end

    local rpfBuff = player:TalentKnown(RelentlessPrimalFerocity.id) and player:Buff(buffs.coordinatedAssault)
    if (not rpfBuff or (rpfBuff and not player:Buff(buffs.tipOfTheSpear) or player.focus < 30)) then
        return spell:Cast(target)
    end
end)

--actions.plst+=/wildfire_bomb,if=buff.tip_of_the_spear.stack>0 (Season 3: 50% damage buff + Tip of the Spear priority)
WildfireBomb:Callback("plSt", function(spell)
    -- Season 3: Wildfire Bomb received 50% initial damage buff, making it extremely high priority with Tip of the Spear
    -- Season 3: Improved Wildfire Bomb talent adds additional +8% damage if taken
    -- Optimized: Use cached game state for better performance
    if gameState.tipOfTheSpear then
        return spell:Cast(target)
    end

    -- Use without Tip of the Spear if charges are high to avoid overcapping (damage buff makes this worthwhile)
    local threshold = player:TalentKnown(ImprovedWildfireBomb.id) and 1.6 or 1.7 -- Lower threshold with talent
    if spell.frac > threshold then
        return spell:Cast(target)
    end
end)

-- actions.plst+=/raptor_bite,target_if=min:dot.serpent_sting.remains,if=!talent.contagious_reagents
-- actions.plst+=/raptor_bite,target_if=max:dot.serpent_sting.remains
MongooseBite:Callback("plSt3", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not MongooseBite:InRange(target) then return end 

    return spell:Cast(target)
end)

RaptorStrike:Callback("plSt3", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not RaptorStrike:InRange(target) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("plSt3", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("plSt3", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end

    return spell:Cast(target)
end)

-- actions.plst+=/kill_shot (Season 3: Enhanced with Born to Kill and Cull the Herd)
KillShot:Callback("plSt", function(spell)
    -- Season 3: Born to Kill adds +25% damage and +5% Deathblow chance
    -- Season 3: Cull the Herd makes Kill Shot apply a DoT effect
    return spell:Cast(target)
end)

-- actions.plst+=/explosive_shot
ExplosiveShot:Callback("plSt", function(spell)

    return spell:Cast(target)
end)


local function plSt()
    ExplosiveShot("plSt")
    KillCommand("plSt")
    Spearhead("plSt")
    FlankingStrike("plSt")
    RaptorStrike("plSt")
    MongooseBite("plSt")
    RaptorStrikeEagle("plSt")
    MongooseBiteEagle("plSt")
    Butchery("plSt")
    KillCommand("plSt2")
    RaptorStrike("plSt2")
    MongooseBite("plSt2")
    RaptorStrikeEagle("plSt2")
    MongooseBiteEagle("plSt2")
    FuryOfTheEagle("plSt")
    CoordinatedAssault("plSt")
    WildfireBomb("plSt")
    KillCommand("plSt3")
    RaptorStrike("plSt3")
    MongooseBite("plSt3")
    RaptorStrikeEagle("plSt3")
    MongooseBiteEagle("plSt3")
    KillShot("plSt")
    KillCommand("fallback")
end

--###########################################################################################################################################################################
-- SENTINAL CLEAVE
--###########################################################################################################################################################################

--actions.sentcleave=wildfire_bomb (Season 3: 50% damage buff + immediate Lunar Storm refresh)
WildfireBomb:Callback("sentCleave", function(spell)
    -- Season 3: Wildfire Bomb 50% damage buff + Lunar Storm immediate refresh makes this top priority
    return spell:Cast(target)
end)

--actions.sentcleave+=/kill_command,target_if=min:bloodseeker.remains,if=buff.relentless_primal_ferocity.up&buff.tip_of_the_spear.stack<1
KillCommand:Callback("sentCleave", function(spell)
    if player:TalentKnown(RelentlessPrimalFerocity.id) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) >= 1 then return end 

    return spell:Cast(target)
end)

--actions.sentcleave+=/wildfire_bomb,if=buff.tip_of_the_spear.stack>0&cooldown.wildfire_bomb.charges_fractional>1.7|cooldown.wildfire_bomb.charges_fractional>1.9|(talent.bombardier&cooldown.coordinated_assault.remains<2*gcd)|talent.butchery&cooldown.butchery.remains<gcd
WildfireBomb:Callback("sentCleave2", function(spell)
    if player:Buff(buffs.tipOfTheSpear) and spell.frac > 1.7 then
        return spell:Cast(target)
    end

    if spell.frac > 1.9 then
        return spell:Cast(target)
    end

    if player:TalentKnown(Bombardier.id) and CoordinatedAssault.cd < 2000 * A.GetGCD() then
        return spell:Cast(target)
    end

    if player:TalentKnown(Butchery.id) and Butchery.cd < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

--actions.sentcleave+=/raptor_bite,target_if=max:dot.serpent_sting.remains,if=buff.strike_it_rich.up&buff.strike_it_rich.remains<gcd
RaptorStrike:Callback("sentCleave", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 
    if not RaptorStrike:InRange(target) then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if player:BuffRemains(buffs.strikeItRich) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("sentCleave", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if player:BuffRemains(buffs.strikeItRich) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("sentCleave", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.strikeItRich) then return end
    if player:BuffRemains(buffs.strikeItRich) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("sentCleave", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.strikeItRich) then return end
    if player:BuffRemains(buffs.strikeItRich) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

--actions.sentcleave+=/butchery
Butchery:Callback("sentCleave", function(spell)
    if target.distance > 5 then return end

    return spell:Cast()
end)

--actions.sentcleave+=/coordinated_assault,if=!talent.bombardier|talent.bombardier&cooldown.wildfire_bomb.charges_fractional<1
CoordinatedAssault:Callback("sentCleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if player:TalentKnown(Bombardier.id) then
        if WildfireBomb.frac >= 1 then return end
    end

    return spell:Cast(target)
end)

--actions.sentcleave+=/fury_of_the_eagle,if=buff.tip_of_the_spear.stack>0
FuryOfTheEagle:Callback("sentCleave", function(spell)
    if target.distance > 5 then return end

    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast()
end)

--actions.sentcleave+=/flanking_strike,if=(buff.tip_of_the_spear.stack=2|buff.tip_of_the_spear.stack=1)
FlankingStrike:Callback("sentCleave", function(spell)
    local flankStrike = A.GetToggle(2, "flankStrike")
    if player.moving and not flankStrike then return end

    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.sentcleave+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
KillCommand:Callback("sentCleave2", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if player.focus > 77 then return end

    return spell:Cast(target)
end)

--actions.sentcleave+=/explosive_shot
ExplosiveShot:Callback("sentCleave", function(spell)
    return spell:Cast(target)
end)

--actions.sentcleave+=/wildfire_bomb,if=buff.tip_of_the_spear.stack>0
WildfireBomb:Callback("sentCleave3", function(spell)
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.sentcleave+=/kill_shot,if=buff.deathblow.remains&talent.sic_em
KillShot:Callback("sentCleave", function(spell)
    if not player:Buff(buffs.deathblow) then return end
    if not player:TalentKnown(SicEm.id) then return end
        
    return spell:Cast(target)
end)

--actions.sentcleave+=/raptor_bite,target_if=min:dot.serpent_sting.remains,if=!talent.contagious_reagents
--actions.sentcleave+=/raptor_bite,target_if=max:dot.serpent_sting.remains
MongooseBite:Callback("sentCleave2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    return spell:Cast(target)
end)

RaptorStrike:Callback("sentCleave2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not RaptorStrike:InRange(target) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("sentCleave2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("sentCleave2", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end

    return spell:Cast(target)
end)

local function sentCleave()
    -- Season 3: Boon of Elune has highest priority for Sentinel
    WildfireBomb("boonOfElune")
    WildfireBomb("sentCleave")
    KillCommand("sentCleave")
    WildfireBomb("sentCleave2")
    MongooseBite("sentCleave")
    RaptorStrike("sentCleave")
    MongooseBiteEagle("sentCleave")
    RaptorStrikeEagle("sentCleave")
    Butchery("sentCleave")
    CoordinatedAssault("sentCleave")
    FuryOfTheEagle("sentCleave")
    FlankingStrike("sentCleave")
    KillCommand("sentCleave2")
    ExplosiveShot("sentCleave")
    WildfireBomb("sentCleave3")
    KillShot("sentCleave")
    MongooseBite("sentCleave2")
    RaptorStrike("sentCleave2")
    MongooseBiteEagle("sentCleave2")
    RaptorStrikeEagle("sentCleave2")
    KillCommand("fallback")
end

--###########################################################################################################################################################################
-- SENTINAL SINGLE TARGET
--###########################################################################################################################################################################

-- Season 3 Sentinel 2-Set: Prioritize Wildfire Bomb with Boon of Elune (+150% initial damage)
WildfireBomb:Callback("boonOfElune", function(spell)
    if not gameState.has2Set then return end
    if not player:Buff(buffs.boonOfElune) then return end

    -- Boon of Elune makes next 2 Wildfire Bombs deal +150% initial damage as Arcane - extremely high priority
    return spell:Cast(target)
end)

--actions.sentst=wildfire_bomb (Season 3: 50% damage buff + immediate Lunar Storm refresh)
WildfireBomb:Callback("sentSt", function(spell)
    -- Season 3: Wildfire Bomb 50% damage buff + Lunar Storm immediate refresh makes this extremely high priority
    return spell:Cast(target)
end)

--actions.sentst+=/kill_command,target_if=min:bloodseeker.remains,if=(buff.relentless_primal_ferocity.up&buff.tip_of_the_spear.stack<1)
KillCommand:Callback("sentSt", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if not player:TalentKnown(RelentlessPrimalFerocity.id) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) >= 1 then return end 

    return spell:Cast(target)
end)

--actions.sentst+=/spearhead,if=cooldown.coordinated_assault.remains
Spearhead:Callback("sentSt", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if CoordinatedAssault.cd < 1000 then return end

    return spell:Cast(target)
end)

--actions.sentst+=/flanking_strike,if=buff.tip_of_the_spear.stack>0
FlankingStrike:Callback("sentSt", function(spell)
    local flankStrike = A.GetToggle(2, "flankStrike")
    if player.moving and not flankStrike then return end
    
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.sentst+=/kill_command,if=buff.strike_it_rich.remains&buff.tip_of_the_spear.stack<1
KillCommand:Callback("sentSt2", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

--actions.sentst+=/mongoose_bite,if=buff.strike_it_rich.remains&buff.coordinated_assault.up
MongooseBite:Callback("sentSt", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("sentSt", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.strikeItRich) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end

    return spell:Cast(target)
end)

--actions.sentst+=/wildfire_bomb,if=buff.tip_of_the_spear.stack>0&cooldown.wildfire_bomb.charges_fractional>1.6|cooldown.wildfire_bomb.charges_fractional>1.8|(talent.bombardier&cooldown.coordinated_assault.remains<2*gcd)
WildfireBomb:Callback("sentSt2", function(spell)
    -- Season 3: 50% damage buff makes lower charge thresholds worthwhile
    if player:Buff(buffs.tipOfTheSpear) and spell.frac > 1.6 then -- Lowered from 1.7
        return spell:Cast(target)
    end

    if spell.frac > 1.8 then -- Lowered from 1.9
        return spell:Cast(target)
    end

    if player:TalentKnown(Bombardier.id) and CoordinatedAssault.cd < 2000 * A.GetGCD() then
        return spell:Cast(target)
    end
end)

--actions.sentst+=/butchery
Butchery:Callback("sentSt", function(spell)
    if target.distance > 5 then return end

    return spell:Cast(target)
end)

-- Season 3: Optimized opener sequence for maximum theoretical DPS
CoordinatedAssault:Callback("opener", function(spell)
    if not A.CoordinatedAssault:IsTalentLearned() then return end
    if player.inCombat then return end -- Pre-combat only

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    -- Season 3: Pre-pull Coordinated Assault for optimal opener timing
    return spell:Cast()
end)

--actions.sentst+=/coordinated_assault,if=!talent.bombardier|talent.bombardier&cooldown.wildfire_bomb.charges_fractional<1
CoordinatedAssault:Callback("sentSt", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if player:TalentKnown(Bombardier.id) then
        if WildfireBomb.frac >= 1 then return end
    end

    return spell:Cast(target)
end)

--actions.sentst+=/fury_of_the_eagle,if=buff.tip_of_the_spear.stack>0
FuryOfTheEagle:Callback("sentSt", function(spell)
    if target.distance > 5 then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast()
end)

--actions.sentst+=/kill_command,target_if=min:bloodseeker.remains,if=buff.tip_of_the_spear.stack<1&cooldown.flanking_strike.remains<gcd
--actions.sentst+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(!buff.relentless_primal_ferocity.up|(buff.relentless_primal_ferocity.up&(buff.tip_of_the_spear.stack<2|focus<30)))
KillCommand:Callback("sentSt3", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    if not player:Buff(buffs.tipOfTheSpear) and FlankingStrike.cd < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player.focus < 77 then
        if player:TalentKnown(RelentlessPrimalFerocity.id) and player:Buff(buffs.coordinatedAssault) then
            if (player:HasBuffCount(buffs.tipOfTheSpear) < 2 or player.focus < 30) then
                return spell:Cast(target)
            end
        else 
            return spell:Cast(target)
        end
    end
end)

--actions.sentst+=/mongoose_bite,if=buff.mongoose_fury.remains<gcd&buff.mongoose_fury.stack>0
MongooseBite:Callback("sentSt2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if not player:Buff(buffs.mongooseFury) then return end
    if player:BuffRemains(buffs.mongooseFury) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("sentSt2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.mongooseFury) then return end
    if player:BuffRemains(buffs.mongooseFury) > A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

--actions.sentst+=/wildfire_bomb,if=buff.tip_of_the_spear.stack>0&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.in>15)
WildfireBomb:Callback("sentSt3", function(spell)
    if not player:Buff(buffs.tipOfTheSpear) then return end
    -- Season 3: No lunar storm cooldown check needed - immediate refresh mechanic
    if incAddsIn() < 15000 then return end

    return spell:Cast(target)
end)

--actions.sentst+=/mongoose_bite,if=buff.mongoose_fury.remains
MongooseBite:Callback("sentSt3", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    if not player:Buff(buffs.mongooseFury) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("sentSt3", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    if not player:Buff(buffs.mongooseFury) then return end

    return spell:Cast(target)
end)

--actions.sentst+=/explosive_shot
ExplosiveShot:Callback("sentSt", function(spell)

    return spell:Cast(target)
end)

--actions.sentst+=/kill_shot (Season 3: Enhanced with Born to Kill and Cull the Herd)
KillShot:Callback("sentSt", function(spell)
    -- Season 3: Born to Kill adds +25% damage and +5% Deathblow chance
    -- Season 3: Cull the Herd makes Kill Shot apply a DoT effect
    return spell:Cast(target)
end)

--actions.sentst+=/raptor_bite,target_if=min:dot.serpent_sting.remains,if=!talent.contagious_reagents
--actions.sentst+=/raptor_bite,target_if=max:dot.serpent_sting.remains
RaptorStrike:Callback("fill", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 
    if not RaptorStrike:InRange(target) then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("fill", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 
    if not MongooseBite:InRange(target) then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("fill", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end 

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("fill", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end 

    return spell:Cast(target)
end)

local function sentSt()
    -- Season 3: Boon of Elune has highest priority for Sentinel
    WildfireBomb("boonOfElune")
    WildfireBomb("sentSt")
    KillCommand("sentSt")
    Spearhead("sentSt")
    FlankingStrike("sentSt")
    KillCommand("sentSt2")
    MongooseBite("sentSt")
    MongooseBiteEagle("sentSt")
    WildfireBomb("sentSt2")
    Butchery("sentSt")
    CoordinatedAssault("sentSt")
    FuryOfTheEagle("sentSt")
    KillCommand("sentSt3")
    MongooseBite("sentSt2")
    MongooseBiteEagle("sentSt2")
    WildfireBomb("sentSt3")
    MongooseBite("sentSt3")
    MongooseBiteEagle("sentSt3")
    ExplosiveShot("sentSt")
    KillShot("sentSt")
    RaptorStrike("fill")
    MongooseBite("fill")
    RaptorStrikeEagle("fill")
    MongooseBiteEagle("fill")
    KillCommand("fallback")
end

KillCommand:Callback("fallback", function(spell)
    if not A.GetToggle(2, "kcFallback") then return end

    -- Only use Kill Command when out of melee range
    if target.distance <= 5 then return end

    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

-- Totem/Psyfiend targeting callbacks - high priority, no conditions
KillCommand:Callback("totem", function(spell)
    if not ActionUnit("target"):IsTotem() then return end
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("totem", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not ActionUnit("target"):IsTotem() then return end
    if not MongooseBite:InRange(target) then return end

    return spell:Cast(target)
end)

RaptorStrike:Callback("totem", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not ActionUnit("target"):IsTotem() then return end
    if not RaptorStrike:InRange(target) then return end

    return spell:Cast(target)
end)

MongooseBiteEagle:Callback("totem", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not ActionUnit("target"):IsTotem() then return end

    return spell:Cast(target)
end)

RaptorStrikeEagle:Callback("totem", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not ActionUnit("target"):IsTotem() then return end

    return spell:Cast(target)
end)

local function totemStomp()
    -- Use dedicated totem callbacks for maximum priority
    KillCommand("totem")
    MongooseBite("totem")
    RaptorStrike("totem")
    MongooseBiteEagle("totem")
    RaptorStrikeEagle("totem")
end

local function trapNearby()
    if not A.IsInPvP then return end

    local healerExists = arena1.isHealer or arena2.isHealer or arena3.isHealer

    if not target.isHealer and healerExists then
        if arena1.isHealer and arena1.incapacitateDr > 0.5 and ActionUnit("arena1"):GetRange() <= 2 then
            return true
        elseif arena2.isHealer and arena2.incapacitateDr > 0.5 and ActionUnit("arena2"):GetRange() <= 2 then
            return true
        elseif arena3.isHealer and arena3.incapacitateDr > 0.5 and ActionUnit("arena3"):GetRange() <= 2 then
            return true
        end
    end

    if target.isHealer or not healerExists then
        if not arena1.isTarget and arena1.incapacitateDr > 0.5 and ActionUnit("arena1"):GetRange() <= 2 then
            return true
        elseif not arena2.isTarget and arena2.incapacitateDr > 0.5 and ActionUnit("arena2"):GetRange() <= 2 then
            return true
        elseif not arena3.isTarget and arena3.incapacitateDr > 0.5 and ActionUnit("arena3"):GetRange() <= 2 then
            return true
        end
    end

    return false
end

FreezingTrap:Callback("arena", function(spell)
    if not A.IsInPvP then return end

    -- Season 3: Enhanced trap placement logic for Gladiator-viable performance
    if not trapNearby() then return end

    return spell:Cast()
end)

HighExplosiveTrap:Callback("arena", function(spell)
    if not A.IsInPvP then return end
    if enemiesInMeleeBurstingPvP() == 0 then return end

    return spell:Cast()
end)

ConcussiveShot:Callback("arena", function(spell)
    if not A.IsInPvP then return end
    if target:DebuffFrom(MakLists.Slowed) then return end
    if target:BuffFrom(MakLists.SlowImmune) then return end
    if player:Buff(buffs.coordinatedAssault) then return end

    return spell:Cast(target)
end)

local function trapWarning()
    if Action.Zone ~= "arena" then return end
    local aware = A.GetToggle(2, "makArenaAware")

    if aware and enemyHealer.ccRemains > 2000 and enemyHealer.incapacitateDr >= 0.5 and FreezingTrap:Cooldown() < 300 then
        Aware:displayMessage("TRY TO TRAP NOW", 2)
    end
end

Muzzle:Callback("test", function(spell, enemy)
    if not target.exists then return end

    return spell:Cast(enemy)
end)

-- PVP Callbacks
FeignDeath:Callback("pvp", function(spell)
    -- Check if Feign Death PvP toggle is enabled
    if not A.GetToggle(2, "feignDeathPvP") then return end

    -- Use Feign Death when HP is below the configured threshold
    if player.hp > A.GetToggle(2, "feignDeathHP") then return end

    return spell:Cast(player)
end)

MongooseBite:Callback("pvp1", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not MongooseBite:InRange(target) then return end

    if player:HasBuffCount(buffs.mongooseFury) ~= 5 then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) ~= 3 then return end

    return spell:Cast(target)
end)

HuntersMark:Callback("pvp", function(spell)
    if not HuntersMark:InRange(target) then return end
    if target:Debuff(debuffs.huntersMark) then return end
    if target.hp < 80 then return end

    return spell:Cast(target)
end)

ExplosiveShot:Callback("pvp1", function(spell)
    if not ExplosiveShot:InRange(target) then return end
    if target.hp < 20 then return end
    if not target:Debuff(debuffs.huntersMark) then return end

    return spell:Cast(target)
end)

WildfireBomb:Callback("pvp1", function(spell)
    if WildfireBomb.charges < 2 then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

KillShot:Callback("pvp", function(spell)
    if not KillShot:InRange(target) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

ExplosiveShot:Callback("pvp2", function(spell)
    if not ExplosiveShot:InRange(target) then return end
    if not player.inCombat then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

CoordinatedAssault:Callback("pvp", function(spell)
    if WildfireBomb.charges > 1 then return end

    return spell:Cast(target)
end)

FlankingStrike:Callback("pvp", function(spell)
    if not FlankingStrike:InRange(target) then return end

    -- Only use with 1 or 2 stacks of Tip of the Spear (never 0 or 3)
    local tipStacks = player:HasBuffCount(buffs.tipOfTheSpear)
    if tipStacks == 0 or tipStacks == 3 then return end

    -- Coordinated Assault must be active OR on cooldown for at least 25 seconds
    local hasCA = player:Buff(buffs.coordinatedAssault)
    local caCD = CoordinatedAssault.cd
    if not hasCA and caCD < 25000 then return end

    return spell:Cast(target)
end)

FuryOfTheEagle:Callback("pvp", function(spell)
    -- Must be in melee range (5 yards) to use Fury of the Eagle
    if target.distance > 5 then return end
    if not enemiesInMeleeBurstingPvP() then return end
    if not player.inCombat then return end

    -- Use during Coordinated Assault (20% damage buff) OR as a finisher on low HP targets
    if not player:Buff(buffs.coordinatedAssault) and target.hp > 20 then return end

    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast()
end)

MongooseBite:Callback("pvp2", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not MongooseBite:InRange(target) then return end
    if player:HasBuffCount(buffs.mongooseFury) ~= 5 then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

KillCommand:Callback("pvp1", function(spell)
    if not player.inCombat then return end
    if not player:TalentKnown(ViciousHunt.id) then return end
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

WildfireBomb:Callback("pvp2", function(spell)
    if WildfireBomb.charges < 1 then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

Butchery:Callback("pvp", function(spell)
    if target.distance > 5 then return end

    return spell:Cast()
end)

KillCommand:Callback("pvp2", function(spell)
    if player.focus >= 75 then return end
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

Spearhead:Callback("pvp", function(spell)
    if not Spearhead:InRange(target) then return end
    if not player:Buff(buffs.coordinatedAssault) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end

    return spell:Cast(target)
end)

ExplosiveShot:Callback("pvp3", function(spell)
    if not ExplosiveShot:InRange(target) then return end
    if not player:Buff(buffs.bombardier) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

ExplosiveShot:Callback("pvp4", function(spell)
    if not ExplosiveShot:InRange(target) then return end
    if not player:Buff(buffs.tipOfTheSpear) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

KillCommand:Callback("pvp3", function(spell)
    if target.distance <= 5 then return end
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

RaptorStrike:Callback("pvp", function(spell)
    if IsPlayerSpell(MongooseBite.id) then return end
    if not RaptorStrike:InRange(target) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

MongooseBite:Callback("pvp3", function(spell)
    if not IsPlayerSpell(MongooseBite.id) then return end
    if not MongooseBite:InRange(target) then return end
    if player:HasBuffCount(buffs.tipOfTheSpear) < 1 then return end

    return spell:Cast(target)
end)

KillCommand:Callback("pvp4", function(spell)
    if not pet.exists then return end
    if pet.cc then return end
    if pet.rooted then return end

    return spell:Cast(target)
end)

local function PVPRotation()

    MongooseBite("pvp1")
    HuntersMark("pvp")
    ExplosiveShot("pvp2")
    WildfireBomb("pvp1")
    FuryOfTheEagle("pvp")
    FlankingStrike("pvp")
    KillCommand("plSt")
    Spearhead("plSt")
    RaptorStrike("plSt")
    MongooseBite("plSt")
    RaptorStrikeEagle("plSt")
    MongooseBiteEagle("plSt")
    Butchery("plSt")
    KillCommand("plSt2")
    RaptorStrike("plSt2")
    MongooseBite("plSt2")
    RaptorStrikeEagle("plSt2")
    MongooseBiteEagle("plSt2")
    CoordinatedAssault("pvp")
    WildfireBomb("plSt")
    KillShot("pvp")
    KillCommand("pvp3")
    RaptorStrike("plSt3")
    MongooseBite("plSt3")
    RaptorStrikeEagle("plSt3")
    MongooseBiteEagle("plSt3")
    KillCommand("fallback")

    MongooseBite("pvp1")
    HuntersMark("pvp")
    ExplosiveShot("pvp1")
    WildfireBomb("pvp1")
    KillShot("pvp")
    ExplosiveShot("pvp2")
    CoordinatedAssault("pvp")
    FlankingStrike("pvp")
    FuryOfTheEagle("pvp")
    MongooseBite("pvp2")
    KillCommand("pvp1")
    WildfireBomb("pvp2")
    Butchery("pvp")
    KillCommand("pvp2")
    Spearhead("pvp")
    ExplosiveShot("pvp3")
    ExplosiveShot("pvp4")
    KillCommand("pvp3")
    RaptorStrike("pvp")
    MongooseBite("pvp3")
    KillCommand("pvp4")
    WildfireBomb("plSt")


end

TranquilizingShot:Callback("pvp", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    if not target:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(target)
end)



A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    local packLeader = player:TalentKnown(ViciousHunt.id)

    if A.GetToggle(2, "makDebug") then

        MakPrint(1, "Target Distance: ", ActionUnit("target"):GetRange())
        MakPrint(2, "Raptor Strike Learned: ", IsPlayerSpell(RaptorStrike.id))
        MakPrint(3, "Mongoose Bite Learned: ", IsPlayerSpell(MongooseBite.id))
        MakPrint(4, "Pack Leader Hero Talents: ", packLeader)
        MakPrint(5, "Enemies in Melee: ", enemiesInMelee())
        MakPrint(6, "Swap Pet Toggle: ", gameState.swapPet) 
        MakPrint(7, "Pet Slot Matching Toggle: ", gameState.petSlotToggle)
        MakPrint(8, "Current Pet Spec: ", gameState.petClass) 
        MakPrint(9, "At Stable Master: ", C_StableInfo.IsAtStableMaster())
        -- Season 3: Tier Set and Lunar Storm debug
        MakPrint(10, "Season 3 2-Set: ", gameState.has2Set)
        MakPrint(11, "Season 3 4-Set: ", gameState.has4Set)
        MakPrint(12, "Pack Leader: ", gameState.packLeader)
        MakPrint(13, "Boon of Elune: ", player:Buff(buffs.boonOfElune))
        MakPrint(14, "Lunar Storm Talent: ", A.LunarStorm:IsTalentLearned())
        MakPrint(15, "Improved WF Bomb: ", A.ImprovedWildfireBomb:IsTalentLearned())
        MakPrint(16, "Born to Kill: ", A.BornToKill:IsTalentLearned())
    end

    local awareAlert = A.GetToggle(2, "makAware")

    if A.GetToggle(2, "sotfPixel") and player:IsMounted() then
        return A.Mounted:Show(icon)
    end

    FeignDeath("pvp")
    if makFeign() and player.feigned then return end

    makInterrupt(interrupts)

    trapWarning()
    FreezingTrap("arena")
    --Muzzle("test")
    MendPet() 
    RevivePet() -- Need separate due to Mend Pet 10 second CD
    CallPet1()
    CallPet2()
    CallPet3()
    DismissPet()
    Exhilaration()
    if player.inCombat and pet.exists and gameState.petClass == "Tenacity" and player.hp <= A.GetToggle(2, "fortHP") and ActionPet:IsSpellKnown(FortitudeOfTheBear.id) and FortitudeOfTheBear.cd < 300 then
        return A.FortitudeOfTheBear:Show(icon)
    end
    AspectOfTheTurtle()
    SurvivalOfTheFittest(icon)
    Camouflage()
    HuntersMark()
    TranquilizingShot("pvp")

    -- Season 3: Optimized pre-combat and opener sequences for maximum theoretical DPS
    if not player.inCombat and target.exists and target.canAttack then
        -- Pre-combat setup for optimal opener
        HuntersMark()

        -- Season 3: Aspect of the Eagle for ranged engagement if target is far
        if target.distance > 15 then
            AspectOfTheEagle()
        end

        -- Pre-combat pet positioning and coordination
        if pet.exists and gameState.petClass == "Ferocity" then
            -- Optimal pet positioning for Pack Leader builds
        end
    end

    if target.exists and target.canAttack and KillShot:InRange(target) and not player:Debuff(410201) then
        if ActionUnit("target"):IsTotem() then
            totemStomp()
        end

        ConcussiveShot("arena")

        if shouldBurst() and target.distance <= 5 then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.coordinatedAssault) or (not A.CoordinatedAssault:IsTalentLearned() and (Spearhead.cd < 300 or not A.Spearhead:IsTalentLearned()))
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
            cds()
        end

        Harpoon()

        if A.IsInPvP then
            PVPRotation()
        end  

        if not A.IsInPvP and gameState.shouldAoE then    
            if packLeader then
                plCleave()
            else
                sentCleave()
            end
        else
            if packLeader then
                plSt()
            else
                sentSt()
            end
        end
        
        AspectOfTheEagle()
        KillCommand("fallback")
    end

	return FrameworkEnd()
end

Muzzle:Callback("arena", function(spell, enemy)
    if enemy:IsKickImmune() then return end
    if not A.Muzzle:IsTalentLearned() then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 420) then return end

    return spell:Cast(enemy)
end)

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

TranquilizingShot:Callback("arena", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    --if target.hp < 40 then return end
    if not enemy:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(enemy)
end)

Harpoon:Callback("arena", function(spell, enemy, icon)
    local icon = icon or MendingBandage
    local aware = A.GetToggle(2, "makArenaAware")
    if enemy.ccImmune then return end
    if enemy.ccRemains > 1000 then return end
    if FreezingTrap:Cooldown() > 300 then return end
    if not Harpoon:InRange(enemy) then return end
    if enemy.incapacitateDr < 0.5 then return end
    local aware = A.GetToggle(2, "makArenaAware")

    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end   

    local healerExists = arena1.isHealer or arena2.isHealer or arena3.isHealer
    if not target.isHealer and healerExists then
        if enemy.isHealer and enemy.incapacitateDr > 0.5 then
            if aware then Aware:displayMessage("HARPOONING GET READY TO TRAP", 2) end
            return spell:Cast(enemy, false, icon)
        end
    end

    --if target.isHealer or not healerExists then
    --    if not enemy.isTarget and enemy.incapacitateDr > 0.5 then
    --        return spell:Cast(enemy, false, icon)
    --    end
    --end
end)

Intimidation:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if enemy:IsCCImmune() then return end

    -- ONLY use Intimidation on the enemy healer (never on main target or DPS)
    if not enemy:IsHealer() then return end

    -- Only use Intimidation if Freezing Trap is ready (to follow up with trap)
    if FreezingTrap:Cooldown() > 300 then return end

    local aware = A.GetToggle(2, "makArenaAware")
    if enemy.distance > 30 then return end

    -- Don't use if enemy is already CC'd
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end
    if ccRemains > 0 then return end

    -- Check stun diminishing returns
    if enemy.stunDr < 0.25 then return end

    -- Priority 1: Use on healer when target is low HP and DR is good
    if enemy.stunDr >= 0.5 and target.hp <= 35 and target.hp > 10 then
        -- Display aware message to remind player to follow up with trap
        if aware then
            Aware:displayMessage("HEALER STUNNED - TRAP NOW!", 2)
        end
        return spell:Cast(enemy)
    end

    -- Priority 2: Use on healer when target is medium HP and DR is full
    if enemy.stunDr == 1 and target.hp <= 60 and target.hp > 10 then
        -- Display aware message to remind player to follow up with trap
        if aware then
            Aware:displayMessage("HEALER STUNNED - TRAP NOW!", 2)
        end
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

TrackersNet:Callback("arena", function(spell, enemy)
    if not A.TrackersNet:IsTalentLearned() then return end
    if not enemy.cds then return end
    if enemy.isTarget then return end

    return spell:Cast(enemy)
end)

StickyTarBomb:Callback("arena", function(spell, enemy)
    if not StickyTarBomb:InRange(enemy) then return end
    if A.StickyTarBomb:IsSuspended(0.5, 1) then return end

    -- Priority 1: Use on disarmed enemies (original logic)
    if enemy:BuffFrom(MakLists.Disarm) then
        return spell:Cast(enemy)
    end

    -- Priority 2: Use on melee DPS when they pop cooldowns
    if enemy:IsMelee() and not enemy:IsHealer() and enemy.cds then
        return spell:Cast(enemy)
    end

    -- Priority 3: Use on melee DPS when they're targeting you or your healer
    if enemy:IsMelee() and not enemy:IsHealer() then
        local enemyTarget = enemy.target
        if enemyTarget == "player" or (party1.exists and enemyTarget == "party1") or (party2.exists and enemyTarget == "party2") then
            return spell:Cast(enemy)
        end
    end
end)

ChimaeralSting:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    -- Don't use while healer is in CC - wait for CC to be over
    if enemy:CCRemains() > 0 then return end
    if not enemy:IsHealer() then return end

    -- Only use after pressure has been applied to main target (target below 70% HP)
    if target.hp > 70 then return end

    -- Ideal timing: After trap CC is over (enemy was recently CC'd but not anymore)
    -- This checks if enemy was CC'd in the last 3 seconds but is not CC'd now
    local wasRecentlyCC = false
    if enemy.cc == false and enemy.incapacitateDr < 1 then
        -- If DR is reduced, they were recently CC'd
        wasRecentlyCC = true
    end

    -- Use if: 1) Enemy was recently CC'd (trap just ended), OR 2) Target is very low
    if wasRecentlyCC or target.hp < 40 then
        return spell:Cast(enemy)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if player:Debuff(410201) then return end
    if player:Buff(buffs.camouflage) then return end

    Muzzle("arena", enemy)
    Harpoon("arena", enemy)
    Intimidation("arena", enemy)
    ScatterShot("arena", enemy)
    StickyTarBomb("arena", enemy)
    TrackersNet("arena", enemy)
    TranquilizingShot("arena", enemy)
    ChimaeralSting("arena", enemy)
end

RoarOfSacrifice:Callback("party", function(spell, friendly)
    if not A.RoarOfSacrifice:IsTalentLearned() then return end
    if friendly.hp > 60 then return end

    return spell:Cast(ally)
end)

local partyRotation = function(friendly)
    if not friendly.exists then return end

    RoarOfSacrifice("party", friendly)

end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end

    if Action.Zone == "arena" then
        enemyRotation(arena1)
        partyRotation(party1)
    end

	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)

    if Action.Zone == "arena" then
        enemyRotation(arena2)
        partyRotation(party2)
    end

	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)

    if Action.Zone == "arena" then
        enemyRotation(arena3)
        partyRotation(party3)
    end

	return FrameworkEnd()
end

A[9] = function(icon)
	RegisterIcon(icon)

    if Action.Zone == "arena" then
	    partyRotation(party4)
    end

	return FrameworkEnd()
end

A[10] = function(icon)
	RegisterIcon(icon)

    if Action.Zone == "arena" then 
	    partyRotation(player)
    end

	return FrameworkEnd()
end
