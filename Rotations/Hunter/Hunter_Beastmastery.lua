-- Added a check if Rdruids have tree buff to not sting into it

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 253 then return end

local name, realm = UnitName("player")
if name == "Weÿ" or name == "Wéy" then
  print("Makulu error: 0x28. Please report in discord")
end

local FrameworkStart   = MakuluFramwork.start
local FrameworkEnd     = MakuluFramwork.endFunc
local RegisterIcon     = MakuluFramwork.registerIcon

local MakUnit          = MakuluFramwork.Unit
local MakSpell         = MakuluFramwork.Spell
local TableToLocal     = MakuluFramwork.tableToLocal
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local TrinketReady     = MakuluFramework.IsTrinketReady
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local ActionPet = LibStub("PetLibrary")
local MultiUnits       = Action.MultiUnits
local MakLists         = MakuluFramework.lists

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

    ArcaneShot = { ID = 185358, MAKULU_INFO = { damageType = "magic" } },
    WingClip = { ID = 195645, MAKULU_INFO = { damageType = "physical" } },
    ConcussiveShot = { ID = 5116, MAKULU_INFO = { damageType = "physical" } },
    Disengage = { ID = 781 },
    AspectOfTheCheetah = { ID = 186257, MAKULU_INFO = { damageType = "physical" } },
    CallPet1 = { ID = 883, Type = "SpellSingleColor", Color = "RED" },
    CallPet2 = { ID = 83242, Type = "SpellSingleColor", Color = "YELLOW" },
    CallPet3 = { ID = 83243, Type = "SpellSingleColor", Color = "BLUE" },
    DismissPet = { ID = 2641, Type = "SpellSingleColor", Color = "LIGHT BLUE" },
    MendPet = { ID = 136 },
    RevivePet = { ID = 982, Texture = 136 },
    CommandPet = { ID = 272651 },
    PrimalRage = { Type = "SpellSingleColor", ID = 272678, Color = "PINK" },
    FortitudeOfTheBear = { Type = "SpellSingleColor", ID = 272679, Color = "PINK" },
    MastersCall = { Type = "SpellSingleColor", ID = 272682, Color = "PINK" },
    MastersCallPet = { ID = 272682, Texture = 291944},
    FeignDeath = { ID = 5384 },
    HuntersMark = { ID = 257284 },
    AspectOfTheTurtle = { ID = 186265 },
    Exhilaration = { ID = 109304 },
    KillShot = { ID = 53351, MAKULU_INFO = { damageType = "physical" } },
    CounterShot = { ID = 147362, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true } },
    TarTrap = { ID = 187698 },
    Misdirection = { ID = 34477 },
    SurvivalOfTheFittest = { ID = 264735 },
    TranquilizingShot = { ID = 19801 },
    ScareBeast = { ID = 1513 },
    Intimidation = { ID = 19577, MAKULU_INFO = { damageType = "physical" } },
    HighExplosiveTrap = { ID = 236776, MAKULU_INFO = { damageType = "magic" } },
    ImplosiveTrap = { ID = 462031, FixedTexture = 135826, MAKULU_INFO = { damageType = "magic" } },
    ScatterShot = { ID = 213691, MAKULU_INFO = { damageType = "physical" } },
    BindingShot = { ID = 109248, MAKULU_INFO = { damageType = "magic" } },
    Camouflage = { ID = 199483 },
    SteelTrap = { ID = 162488, MAKULU_INFO = { damageType = "physical" } },
    DeathChakram = { ID = 375891, MAKULU_INFO = { damageType = "physical" } },
    ExplosiveShot = { ID = 212431, MAKULU_INFO = { damageType = "magic" } },
    BlackArrow = { ID = 466930, MAKULU_INFO = { damageType = "magic" } },
    RoarOfSacrifice = { ID = 53480 },
    BurstingShot = { ID = 186387, MAKULU_INFO = { damageType = "physical" } },
    FreezingTrap = { ID = 187650, MAKULU_INFO = { damageType = "magic" } },
    Flare = { ID = 1543 },

    KillCommand = { ID = 34026, MAKULU_INFO = { damageType = "physical" } },
    CobraShot = { ID = 193455, MAKULU_INFO = { damageType = "physical" } },
    BarbedShot = { ID = 217200, MAKULU_INFO = { damageType = "physical" } },
    MultiShot = { ID = 2643, MAKULU_INFO = { damageType = "physical" } },
    DireBeast = { ID = 120679, MAKULU_INFO = { damageType = "physical" } },
    Barrage = { ID = 120360, MAKULU_INFO = { damageType = "physical" } },
    BestialWrath = { ID = 19574 },
    CallOfTheWild = { ID = 359844, },
    Bloodshed = { ID = 321530, MAKULU_INFO = { damageType = "physical" } },

    ChimaeralSting = { ID = 356719, MAKULU_INFO = { damageType = "magic" } },
    DireBeastBasilisk = { ID = 205691, MAKULU_INFO = { damageType = "physical" } },
    DireBeastHawk = { ID = 208652, MAKULU_INFO = { damageType = "physical" } },
    WildKingdom = { ID = 356707, MAKULU_INFO = { damageType = "physical" } },

    BeastCleave = { ID = 115939, Hidden = true },
    BloodyFrenzy = { ID = 407412, Hidden = true },
    VenomsBite = { ID = 459565, Hidden = true },
    WildCall = { ID = 185789, Hidden = true },
    Savagery = { ID = 424557, Hidden = true },
    AlphaPredator = { ID = 269737, Hidden = true },
    HuntmastersCall = { ID = 459730, Hidden = true },
    KillerCobra = { ID = 199532, Hidden = true },
    ScentOfBlood = { ID = 193532, Hidden = true },
    GhillieSuit = { ID = 459466, Hidden = true },
    KillCleave = { ID = 378207, Hidden = true },
    CullTheHerd = { ID = 445717, Hidden = true },
    ViciousHunt = { ID = 445404, Hidden = true },
    BleakPowder = { ID = 467911, Hidden = true },
    ShadowHounds = { ID = 430707, Hidden = true },
    FuriousAssault = { ID = 445699, Hidden = true },
    BarbedScales = { ID = 469880, Hidden = true },
    DireCleave = { ID = 1217524, Hidden = true },
    ThunderingHooves = { ID = 459693, Hidden = true },
    EmergencySalve = { ID = 459517, Hidden = true },

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

Action[ACTION_CONST_HUNTER_BEASTMASTERY] = A

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
    burstCount = 0,
    openerStarted = false,
    openerDone = false,
}

local buffs = {
    callOfTheWild = 359844,
    bestialWrath = 19574,
    frenzy = 272790,
    beastCleave = 118455,
    huntersPrey = 378215,
    enduranceTraining = 264662,
    predatorsThirst = 264663,
    pathfinding = 264656,
    survivalOfTheFittest = 264735,
    camouflage = 199483,
    aspectOfTheTurtle = 186265,
    howlWyvern = 471878,
    howlBoar = 472324,
    howlBear = 472325,
    hogstrider = 472640,
    huntmastersCall = 459731,
    witheringFire = 466991,
    feignDeath = 5384,
    shadowmeld = 58984,
    twwS3_2pc = 1236372,
    twwS3_4pc = 1236373,
    leadFromTheFront = 472743,
    howlOfThePackLeader = 471876,
}

local debuffs = {
    serpentSting = 271788,
    huntersMark = 257284,
    barbedShot = 217200,
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

local function num(val)
    if val then return 1 else return 0 end
end

local interrupts = {
    { spell = CounterShot },
    --{ spell = ScatterShot, isCC = true },
    { spell = Intimidation, isCC = true },
    --{ spell = BurstingShot, isCC = true, distance = 2, aoe = true },
}

local function shouldBurst()
    if A.BurstIsON("target") then
        --if A.Zone ~= "arena" then
        --    local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --    for enemy in pairs(activeEnemies) do
        --        if ActionUnit(enemy):Health() > (A.KillCommand:GetSpellDescription()[1] * 15) or target.isDummy then
        --            return true
        --        end
        --    end
        --else
            return true
        --end
    end
    return false
end

local function enemyBurstCount()
    local burstCount = 0

    if arena1.exists and arena1.cds then burstCount = burstCount + 1 end
    if arena2.exists and arena2.cds then burstCount = burstCount + 1 end
    if arena3.exists and arena3.cds then burstCount = burstCount + 1 end

    return burstCount
end

----------------------------------------------------- PETABILITY ENEMY COUNT TESTING -----------------------------------------------------

local function GetEnemiesInRangeOfPetAttack()
    local petAttackSpellIDs = {16827, 17253, 49966}  -- Claw, Bite, Smack
    local enemyCount = 0

    for i = 1, 40 do
        local unitID = "nameplate" .. i
        if UnitExists(unitID) and UnitCanAttack("player", unitID) then
            for _, spellID in ipairs(petAttackSpellIDs) do
                if C_Spell.IsSpellInRange(spellID, unitID) == true then
                    enemyCount = enemyCount + 1
                    break
                end
            end
        end
    end

    return enemyCount
end

-- Updated activeEnemies function
local function activeEnemies()
    -- Use the custom function or default to MultiUnits:GetActiveEnemies()
    return math.max(GetEnemiesInRangeOfPetAttack(), MultiUnits:GetActiveEnemies(), 1)
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

    return incomingDamage and not defensiveActive()
end

local function trinketOnCd(slot)
    local start, duration, enabled = GetInventoryItemCooldown("player", slot)

    if start == 0 then
        return false
    end

    if duration > 0 then
        return true
    end
end

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if BarbedShot:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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
            if BarbedShot:InRange(enemy) and orb then
                return true
            end
        end

        return false
    end)
end

local function autoTarget()
    if not player.inCombat then return false end
    if A.IsInPvP then return false end

    if gameState.orbsActive then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if gameState.barbedShotRefreshable then return false end

    if A.GetToggle(2, "autoDOT") then
        if BarbedShot.frac >= 1 and gameState.barbedShotCount < gameState.activeEnemies then
            return true
        end
    end
end

--------------------------------------------------------------------------------------------
-- PET SWAPPING FRAME ----------------------------------------------------------------------
if 1==2 then
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
            local point, relativeTo, relativePoint, x, y = self:GetPoint()
            self.savedPoint = {point, relativeTo, relativePoint, x, y}
            MakuluFramework.SavePersistentValue("BM_PET_FRAME", self.savedPoint, false)
        end
    end)

    specToggleFrame:SetMovable(true)
    specToggleFrame:EnableMouse(true)
    specToggleFrame:RegisterForDrag("LeftButton")
    specToggleFrame.savedPoint = MakuluFramework.TryGetPersistValue("BM_PET_FRAME", false)
    if specToggleFrame.savedPoint then
        specToggleFrame:ClearAllPoints()
        specToggleFrame:SetPoint(unpack(specToggleFrame.savedPoint))
    end

    local function showSwapPetsFrame()
        if A.GetToggle(2, "swapPets") then
            if not specToggleFrame:IsShown() then
                specToggleFrame:Show()
                if specToggleFrame.savedPoint then
                    specToggleFrame:ClearAllPoints()
                    specToggleFrame:SetPoint(unpack(specToggleFrame.savedPoint))
                end
            end
        else
            specToggleFrame:Hide()
        end
    end
end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

local ferocitySlotID = nil
local tenacitySlotID = nil
local cunningSlotID = nil

local function swapPets()

    local activePets = C_StableInfo.GetActivePetList()

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
    local currentCast, currentCastName = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    --showSwapPetsFrame()
    gameState.petClass = petClass()
    gameState.petSlotToggle = swapPets()
    gameState.shouldAoE = (activeEnemies() > 2 or (activeEnemies() > 1 and A.BeastCleave:IsTalentLearned())) and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gameState.orbsActive = orbsActive()
    gameState.activeEnemies = activeEnemies()

    gameState.barbedShotRefreshable = target:DebuffPandemic(debuffs.barbedShot)
    gameState.barbedShotCount = enemiesInRange(debuffs.barbedShot, 1000)

    gameState.howl = player:Buff(buffs.howlBear) or player:Buff(buffs.howlWyvern) or player:Buff(buffs.howlBoar)

    -- Track Howl of the Pack Leader last applied time to approximate its 30s cycle
    if player:Buff(buffs.howlOfThePackLeader) then
        local sinceApplied = player:HasBuffFor(buffs.howlOfThePackLeader)
        if sinceApplied and sinceApplied > 0 then
            local nowMS = time() * 1000
            gameState.howlLastApplied = nowMS - sinceApplied
        end
    -- Reset opener flags when out of combat; mark start when entering combat
    if not player.inCombat then
        gameState.openerStarted = false
        gameState.openerDone = false
    elseif player.inCombat and not gameState.openerStarted then
        gameState.openerStarted = true
    end

    end
    gameState.howlCycleMS = 30000
end

-- Bestial Wrath usage: cast when Howl of the Pack Leader has less than 16s remaining (supports 4pc/double Stampede)
local function shouldCastBestialWrathNow()
    -- If no 4pc, always OK
    local has4pc = player:Buff(buffs.twwS3_4pc) or player:Has4Set()
    if not has4pc then return true end

    -- Require a known Howl cycle anchor; if unknown, don't block usage
    if not gameState.howlLastApplied then return true end

    local nowMS = time() * 1000
    local cycle = gameState.howlCycleMS or 30000
    local since = nowMS - gameState.howlLastApplied
    local howlRemains = cycle - (since % cycle)

    return howlRemains < 16000
end


Misdirection:Callback(function(spell)
    local playerstatus = UnitThreatSituation("player")
    local misdirectType = A.GetToggle(2, "MisdirectType")
    if misdirectType == "Off" then return end
    if (player.combatTime < 5 or ActionUnit("player"):IsTanking() or playerstatus == 3) and not A.IsInPvP then
        if misdirectType == "WeakAura" then
            return spell:Cast()
        else
            if (focus.exists and focus.isFriendly) or (pet.exists and pet.hp > 0) then
                return spell:Cast()
            end
        end
    end
end)

MastersCallPet:Callback(function(spell)
    local aware = A.GetToggle(2, "makArenaAware")
    if target.totalImmune or target.physImmune then return end
    if MastersCallPet:Cooldown() > 300 then return end
    if pet:HasDeBuffFromFor(MakLists.zerkRoot, 300) then
        --if aware then Aware:displayMessage("Master's Call on player for Pet root break.", "Blue", 1) end
        return spell:Cast()
    end
end)

HuntersMark:Callback(function(spell)
    if not HuntersMark:InRange(target) then return end
    if player.feigned then return end
    if target:Debuff(debuffs.huntersMark) then return end
    if not target.exists then return end
    if not target.canAttack then return end

    if player.inCombat and target.hp > 90 and ActionUnit("target"):TimeToDieX(80) > A.GetGCD() * 5 then
        if target.isBoss or not BarbedShot:InRange(target) then
            return spell:Cast(target)
        end
    elseif not player.inCombat then
        return spell:Cast(target)
    end
end)

CallPet1:Callback(function(spell)
    if A.GetToggle(2, "swapPets") then
        if gameState.petClass == gameState.swapPet then return end
        if gameState.petSlotToggle ~= 1 then return end
    end
    if pet.exists then return end
    if gameState.imCasting and gameState.imCasting == RevivePet.id then return end

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

    if player:Buff(buffs.aspectOfTheTurtle) then return end

    if player.hp > A.GetToggle(2, "aspectOfTheTurtleHP") then return end

    return spell:Cast()
end)

Exhilaration:Callback(function(spell)
    if not player.inCombat then return end

    if player.hp > A.GetToggle(2, "exhilarationHP") then return end

    return spell:Cast()
end)

FortitudeOfTheBear:Callback(function(spell)
    if not player.inCombat then return end
    if gameState.petClass ~= "Tenacity" then return end

    if player.hp > A.GetToggle(2, "fortHP") then return end

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

TranquilizingShot:Callback("pve", function(spell, enemy)
    if not enemy then return end
    if enemy:HasBuffFromFor(MakLists.pveEnrage, 500) then
        return spell:Cast(enemy)
    end
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not player:Buff(buffs.callOfTheWild) and A.CallOfTheWild:IsTalentLearned() then return end
    if not A.CallOfTheWild:IsTalentLearned() and not player:Buff(buffs.bestialWrath) then return end

    return spell:Cast()
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not player:Buff(buffs.callOfTheWild) and A.CallOfTheWild:IsTalentLearned() then return end
    if not A.CallOfTheWild:IsTalentLearned() and not player:Buff(buffs.bestialWrath) then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not player:Buff(buffs.callOfTheWild) and A.CallOfTheWild:IsTalentLearned() then return end
    if not A.CallOfTheWild:IsTalentLearned() and not player:Buff(buffs.bestialWrath) then return end

    return spell:Cast()
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not player:Buff(buffs.callOfTheWild) and A.CallOfTheWild:IsTalentLearned() then return end
    if not A.CallOfTheWild:IsTalentLearned() and not player:Buff(buffs.bestialWrath) then return end

    return spell:Cast()
end)

local function cds()
    Berserking()
    BloodFury()
    AncestralCall()
    Fireblood()
end

-----------------------------------CLEAVE-----------------------------------
--actions.cleave=bestial_wrath
BestialWrath:Callback("cleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if A.CallOfTheWild:IsTalentLearned() and CallOfTheWild.cd <= 30000 then return end
    if target.distance > 40 then return end
    if not shouldCastBestialWrathNow() then return end

    return spell:Cast()
end)

--actions.cleave+=/dire_beast,if=talent.huntmasters_call&buff.huntmasters_call.stack=2
DireBeast:Callback("cleave", function(spell)
    if not player:TalentKnown(HuntmastersCall.id) then return end
    if player:HasBuffCount(buffs.huntmastersCall) < 2 then return end

    return spell:Cast(target)
end)

--actions.cleave+=/black_arrow,if=buff.beast_cleave.remains&buff.withering_fire.up
BlackArrow:Callback("cleave", function(spell)
    if not pet:Buff(buffs.beastCleave) then return end
    if not player:Buff(buffs.witheringFire) then return end

    return spell:Cast(target)
end)

--actions.cleave+=/barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<=gcd+0.25|pet.main.buff.frenzy.stack<3|talent.call_of_the_wild&cooldown.call_of_the_wild.ready|cooldown.barbed_shot.charges_fractional>1.4&howl_summon_ready|full_recharge_time<gcd+0.25
BarbedShot:Callback("cleave", function(spell)
    if pet:Buff(buffs.frenzy) and pet:BuffRemains(buffs.frenzy) <= Action.GetGCD() * 2000 then -- turning this up a bit to see if maybe it's a GCD issue for stacks falling off.
        return spell:Cast(target)
    end

    if pet:HasBuffCount(buffs.frenzy) < 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(CallOfTheWild.id) and CallOfTheWild.cd < 700 then
        return spell:Cast(target)
    end

    if spell.frac > 1.4 and gameState.howl then
        return spell:Cast(target)
    end

    if spell:TimeToFullCharges() < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

--actions.cleave+=/multishot,if=pet.main.buff.beast_cleave.remains<0.25+gcd&(!talent.bloody_frenzy|cooldown.call_of_the_wild.remains)
MultiShot:Callback("cleave", function(spell)
    if pet:BuffRemains(buffs.beastCleave) >= ((A.GetGCD() * 1000) + 250) then return end -- Let's keep this as a realistic delay for uptime rather than SimC check

    if not player:TalentKnown(BloodyFrenzy.id) or CallOfTheWild.cd > 700 or not shouldBurst() then
        return spell:Cast(target)
    end
end)

--actions.cleave+=/black_arrow,if=buff.beast_cleave.remains
BlackArrow:Callback("cleave2", function(spell)
    if not pet:Buff(buffs.beastCleave) then return end

    return spell:Cast(target)
end)

--actions.cleave+=/call_of_the_wild
CallOfTheWild:Callback("cleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    return spell:Cast(target)
end)

--actions.cleave+=/bloodshed
Bloodshed:Callback("cleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    return spell:Cast(target)
end)

--actions.cleave+=/dire_beast,if=talent.shadow_hounds|talent.dire_cleave
DireBeast:Callback("cleave2", function(spell)
    if player:TalentKnown(ShadowHounds.id) then
        return spell:Cast(target)
    end

    if player:TalentKnown(DireCleave.id) then
        return spell:Cast(target)
    end
end)

--actions.cleave+=/kill_command,target_if=max:(target.health.pct<35|!talent.killer_instinct)*2+dot.a_murder_of_crows.refreshable
KillCommand:Callback("cleave", function(spell)
    if pet:DebuffFrom(MakLists.zerkRoot) then return end
    if pet:InCC() then return end

    return spell:Cast(target)
end)

--actions.cleave+=/barbed_shot,target_if=min:dot.barbed_shot.remains,if=set_bonus.thewarwithin_season_2_2pc|charges_fractional>1.4|buff.call_of_the_wild.up|talent.scent_of_blood&(cooldown.bestial_wrath.remains<12+gcd)|fight_remains<9
BarbedShot:Callback("cleave2", function(spell)
    if player:Has2Set() then
        return spell:Cast(target)
    end

    if spell.frac > 1.4 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.callOfTheWild) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ScentOfBlood.id) and BestialWrath.cd < 12000 + (A.GetGCD() * 1000) then
        return spell:Cast(target)
    end
end)

--actions.cleave+=/lights_judgment,if=buff.bestial_wrath.down|target.time_to_die<5
LightsJudgment:Callback("cleave", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.bestialWrath) then return end

    return spell:Cast(target)
end)

--actions.cleave+=/cobra_shot,if=focus.time_to_max<gcd*2|buff.hogstrider.stack>3
CobraShot:Callback("cleave", function(spell)
    local focusRegen = GetPowerRegen()
    local timeToMax = (player.focusDeficit / focusRegen) * 1000

    if timeToMax < A.GetGCD() * 2000 then
        return spell:Cast(target)
    end

    if player:HasBuffCount(buffs.hogstrider) > 3 then
        return spell:Cast(target)
    end
end)

--actions.cleave+=/dire_beast
DireBeast:Callback("cleave3", function()
    -- Not in SimC cleave list unless Shadow Hounds or Dire Cleave; handled elsewhere
end)

--actions.cleave+=/explosive_shot,if=talent.thundering_hooves
ExplosiveShot:Callback("cleave", function(spell)
    if not player:TalentKnown(A.ThunderingHooves.id) then return end
    return spell:Cast(target)
end)

--actions.cleave+=/bag_of_tricks,if=buff.bestial_wrath.down|target.time_to_die<5
BagOfTricks:Callback("cleave", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.bestialWrath) then return end

    return spell:Cast(target)
end)

--actions.cleave+=/arcane_torrent,if=(focus+focus.regen+30)<focus.max
ArcaneTorrent:Callback("cleave", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if enemiesInMelee() < 1 then return end
    if player.focus + Player:FocusRegen() + 30 > player.focusMax then return end

    return spell:Cast()
end)

local function cleave()
    BestialWrath("cleave")
    DireBeast("cleave")
    BlackArrow("cleave")
    BarbedShot("cleave")
    MultiShot("cleave")
    BlackArrow("cleave2")
    CallOfTheWild("cleave")
    Bloodshed("cleave")
    DireBeast("cleave2")
    KillCommand("cleave")
    BarbedShot("cleave2")
    LightsJudgment("cleave")
    CobraShot("cleave")
    DireBeast("cleave3")
    ExplosiveShot("cleave")
    BagOfTricks("cleave")
    ArcaneTorrent("cleave")
end
-----------------------------------SINGLE TARGET-----------------------------------


BestialWrath:Callback("arenapre", function(spell)
    if Action.Zone ~= "arena" then return end
    if not IsPlayerSpell(ViciousHunt.id) then return end
    if player.combatTime > 0 then return end
    if not target.exists then return end
    if not target.canAttack then return end
    if not shouldBurst() then return end

    return spell:Cast()
end)

--actions.st+=/dire_beast,if=talent.huntmasters_call
DireBeast:Callback("st", function(spell)
    if not player:TalentKnown(HuntmastersCall.id) then return end

    return spell:Cast(target)
end)

--actions.st=bestial_wrath
BestialWrath:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if A.CallOfTheWild:IsTalentLearned() and CallOfTheWild.cd <= 30000 then return end
    if target.distance > 40 then return end
    if not shouldCastBestialWrathNow() then return end

    return spell:Cast()
end)

BlackArrow:Callback("st", function(spell)
    if A.GetToggle(2, "forceBlackArrow") or player:Buff(buffs.witheringFire) then
        return spell:Cast(target)
    end
end)

--actions.st+=/barbed_shot,target_if=min:dot.barbed_shot.remains,if=pet.main.buff.frenzy.up&pet.main.buff.frenzy.remains<=gcd+0.25|pet.main.buff.frenzy.stack<3|talent.call_of_the_wild&cooldown.call_of_the_wild.ready|cooldown.barbed_shot.charges_fractional>1.4&howl_summon_ready|full_recharge_time<gcd+0.25
BarbedShot:Callback("st", function(spell)
    if pet:Buff(buffs.frenzy) and pet:BuffRemains(buffs.frenzy) <= Action.GetGCD() * 2000 then -- turning this up a bit to see if maybe it's a GCD issue for stacks falling off.
        return spell:Cast(target)
    end

    if pet:HasBuffCount(buffs.frenzy) < 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(CallOfTheWild.id) and CallOfTheWild.cd < 700 then
        return spell:Cast(target)
    end

    if spell.frac > 1.4 and gameState.howl then
        return spell:Cast(target)
    end

    if spell:TimeToFullCharges() < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

--actions.st+=/call_of_the_wild
CallOfTheWild:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    return spell:Cast(target)
end)

--actions.st+=/bloodshed
Bloodshed:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    return spell:Cast(target)
end)

--actions.st+=/kill_command
KillCommand:Callback("st", function(spell)
    if pet:DebuffFrom(MakLists.zerkRoot) then return end
    if pet:InCC() then return end

    return spell:Cast(target)
end)

--actions.st+=/black_arrow
BlackArrow:Callback("st2", function(spell)

    return spell:Cast(target)
end)

--actions.st+=/barbed_shot,target_if=min:dot.barbed_shot.remains,if=set_bonus.thewarwithin_season_2_2pc|charges_fractional>1.4|buff.call_of_the_wild.up|talent.scent_of_blood&(cooldown.bestial_wrath.remains<12+gcd)|fight_remains<9
BarbedShot:Callback("st2", function(spell)
    if player:Has2Set() then
        return spell:Cast(target)
    end

    if spell.frac > 1.4 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.callOfTheWild) then
        return spell:Cast(target)
    end

    if player:TalentKnown(ScentOfBlood.id) and BestialWrath.cd < 12000 + (A.GetGCD() * 1000) then
        return spell:Cast(target)
    end
end)

--actions.st+=/explosive_shot,if=talent.thundering_hooves
-- Explosive Shot is not used on ST per SimC; removed

--actions.st+=/lights_judgment,if=buff.bestial_wrath.down|target.time_to_die<5
LightsJudgment:Callback("st", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.bestialWrath) then return end

    return spell:Cast(target)
end)

-- actions.st+=/cobra_shot
CobraShot:Callback("st", function(spell)

    return spell:Cast(target)
end)

-- actions.st+=/dire_beast
DireBeast:Callback("st2", function()
    -- Not in SimC ST list; Dire Beast usage handled by specific talent conditions
end)

--actions.st+=/bag_of_tricks,if=buff.bestial_wrath.down|target.time_to_die<5
BagOfTricks:Callback("st", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.bestialWrath) then return end

    return spell:Cast(target)
end)

--actions.st+=/arcane_pulse,if=buff.bestial_wrath.down|target.time_to_die<5
ArcanePulse:Callback("st", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if player:Buff(buffs.bestialWrath) then return end

    return spell:Cast(target)
end)

--actions.st+=/arcane_torrent,if=(focus+focus.regen+30)<focus.max
ArcaneTorrent:Callback("st", function(spell)
    if not shouldBurst() then return end
    if not A.GetToggle(1, "Racial") then return end
    if enemiesInMelee() < 1 then return end
    if player.focus + Player:FocusRegen() + 15 > player.focusMax then return end

    return spell:Cast()
end)

-- Automated opener to remove need for manual opener sequence
-- Sequence: Hunter's Mark -> Black Arrow -> Barbed Shot -> Barbed Shot -> Bloodshed -> Call of the Wild
BlackArrow:Callback("opener", function(spell)
    if Action.Zone == "arena" then return end
    if not A.BlackArrow:IsTalentLearned() then return end
    if not target.exists or not target.canAttack then return end
    if target.distance > 40 then return end
    if player.combatTime > 7000 then return end
    return spell:Cast(target)
end)

BarbedShot:Callback("opener1", function(spell)
    if Action.Zone == "arena" then return end
    if not target.exists or not target.canAttack then return end
    if player.combatTime > 7000 then return end
    if spell.frac >= 1.5 then
        return spell:Cast(target)
    end
end)

BarbedShot:Callback("opener2", function(spell)
    if Action.Zone == "arena" then return end
    if not target.exists or not target.canAttack then return end
    if player.combatTime > 7000 then return end
    if Player:PrevGCD(1, A.BarbedShot) and spell.frac >= 1 then
        return spell:Cast(target)
    end
end)

local function opener()
    if gameState.openerDone then return end
    if Action.Zone == "arena" then return end
    if not target.exists or not target.canAttack then return end

    -- Timebox the opener so it doesn't linger
    if player.combatTime > 7000 then
        gameState.openerDone = true
        return
    end

    -- 1) Hunter's Mark
    HuntersMark()
    -- 2) Black Arrow (if talented)
    BlackArrow("opener")
    -- 3) Barbed Shot twice
    BarbedShot("opener1")
    BarbedShot("opener2")
    -- 4) Bloodshed (respects cooldown toggles)
    Bloodshed("st")
    -- 5) Call of the Wild (respects cooldown toggles)
    CallOfTheWild("st")

    -- Consider opener done after Call of the Wild fired or after the timebox
    if Player:PrevGCD(1, A.CallOfTheWild) or Player:PrevGCD(2, A.CallOfTheWild) then
        gameState.openerDone = true
    elseif player.combatTime > 6000 then
        gameState.openerDone = true
    end
end

local function st()
    BestialWrath("arenapre")
    DireBeast("st")
    BestialWrath("st")
    BlackArrow("st")
    BarbedShot("st")
    MastersCallPet()
    CallOfTheWild("st")
    Bloodshed("st")
    KillCommand("st")
    BlackArrow("st2")
    BarbedShot("st2")
    LightsJudgment("st")
    CobraShot("st")
    DireBeast("st2")
    BagOfTricks("st")
    ArcanePulse("st")
    ArcaneTorrent("st")
end


-- Dark Ranger variants (Black Arrow talented) per SimC APL
KillShot:Callback("drcleave", function(spell)
    if not KillShot:InRange(target) then return end
    if target.hp > 20 and not player:Buff(buffs.huntersPrey) then return end
    return spell:Cast(target)
end)

KillShot:Callback("drst", function(spell)
    if not KillShot:InRange(target) then return end
    if target.hp > 20 and not player:Buff(buffs.huntersPrey) then return end
    return spell:Cast(target)
end)

BestialWrath:Callback("drcleave", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if A.CallOfTheWild:IsTalentLearned() and CallOfTheWild.cd <= 30000 then return end
    if target.distance > 40 then return end
    return spell:Cast()
end)

BestialWrath:Callback("drst", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    if A.CallOfTheWild:IsTalentLearned() and CallOfTheWild.cd <= 30000 then return end
    if target.distance > 40 then return end
    return spell:Cast()
end)

BarbedShot:Callback("drcleave", function(spell)
    if spell:TimeToFullCharges() < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

BarbedShot:Callback("drst", function(spell)
    if spell:TimeToFullCharges() < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

BarbedShot:Callback("drcleave2", function(spell)
    if KillCommand.frac and spell.frac >= KillCommand.frac then
        return spell:Cast(target)
    end
end)

BarbedShot:Callback("drst2", function(spell)
    return spell:Cast(target)
end)

CobraShot:Callback("drcleave", function(spell)
    local focusRegen = GetPowerRegen()
    local timeToMax = (player.focusDeficit / focusRegen) * 1000
    if timeToMax < A.GetGCD() * 2000 then
        return spell:Cast(target)
    end
end)

-- Unconditional Explosive Shot fallback for Dark Ranger cleave (per SimC drcleave)
ExplosiveShot:Callback("drcleave2", function(spell)
    return spell:Cast(target)
end)

TranquilizingShot:Callback("pvp", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    if not target:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(target)
end)


local function drcleave()
    KillShot("drcleave")
    BestialWrath("drcleave")
    BlackArrow("cleave")

    BarbedShot("drcleave")
    Bloodshed("cleave")
    MultiShot("cleave")
    BlackArrow("cleave2")

    CallOfTheWild("cleave")
    ExplosiveShot("cleave") -- conditional (talent.thundering_hooves)
    BarbedShot("drcleave2")
    KillCommand("cleave")
    CobraShot("drcleave")
    ExplosiveShot("drcleave2") -- unconditional fallback per SimC
end

local function drst()
    KillShot("drst")
    BestialWrath("drst")
    BlackArrow("st")

    BarbedShot("drst")
    Bloodshed("st")
    CallOfTheWild("st")
    KillCommand("st")
    BlackArrow("st2")

    BarbedShot("drst2")
    CobraShot("st")
end

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Pet Class: ", gameState.petClass)
        MakPrint(2, "Barbed Shot charges: ", BarbedShot.frac)
        MakPrint(3, "Frenzy Stacks ", pet:HasBuffCount(buffs.frenzy))
        MakPrint(4, "Active Enemies: ", activeEnemies())
        MakPrint(5, "Target Exists: ", target.exists)
        MakPrint(6, "Can Attack Target: ", target.canAttack)
        MakPrint(7, "Cleave: ", gameState.shouldAoE)
        MakPrint(8, "AOE Targets: ", activeEnemies())
        MakPrint(9, "Kill Shot in range: ", KillShot:InRange(target))
        MakPrint(10, "Bestial Wrath: ", player:Buff(buffs.bestialWrath))
        MakPrint(11, "Trinket1 Ready: ", TrinketReady(13))
    end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then
        local misdirectType = A.GetToggle(2, "MisdirectType")
        if A.Misdirection:IsTalentLearned() and misdirectType == "Focus" then
            if not focus.exists then
                Aware:displayMessage("Set Focus for Misdirect!", "Red", 1)
            end
        end
    end

    if Action.Zone == "arena" then
        if enemyHealer.exists and enemyHealer.distance < 40 and enemyHealer:CCRemains() > 2000 and enemyHealer.incapacitateDr >= .5 and FreezingTrap:Cooldown() < 1500 then
            local aware = A.GetToggle(2, "makArenaAware")
            if aware then Aware:displayMessage("You should try to TRAP now.", "Blue", 1) end
        end
    end

    --print(activeEnemies())

    if A.GetToggle(2, "sotfPixel") and player:IsMounted() then
        return A.Mounted:Show(icon)
    end

    FeignDeath()
    if makFeign() and player.feigned then return end

    makInterrupt(interrupts)
    TranquilizingShot("pvp")
    MendPet()
    RevivePet()
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

    if target.exists and target.canAttack and KillShot:InRange(target) and not player:Debuff(410201) then
        Misdirection()

        --BestialWrath("pack")
        TranquilizingShot("pve", target)

        -- Automated opener (no manual steps needed)
        opener()

        if shouldBurst() and not player:Debuff(410201) then
            cds()
            local trinketCd = not TrinketReady(13) and TrinketReady(14) or trinketOnCd(13)
            if player:Buff(buffs.callOfTheWild) or player:Buff(buffs.bestialWrath) or trinketCd then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.callOfTheWild) or (player:TalentKnown(Bloodshed.id) and Player:PrevGCD(1, A.Bloodshed)) or (not player:TalentKnown(CallOfTheWild.id) and not player:TalentKnown(Bloodshed.id) and player:Buff(buffs.bestialWrath))
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        if not player:Debuff(410201) then
            if A.BlackArrow:IsTalentLearned() then
                if gameState.shouldAoE then
                    drcleave()
                else
                    drst()
                end
            else
                if gameState.shouldAoE then
                    cleave()
                else
                    st()
                end
            end
        end
    end

	return FrameworkEnd()
end

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

CounterShot:Callback("arena", function(spell, enemy)
    if enemy:IsKickImmune() then return end
    if not A.CounterShot:IsTalentLearned() then return end
    if target.hp < 20 then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end

    return spell:Cast(enemy)
end)

TranquilizingShot:Callback("arena", function(spell, enemy)
    if not A.TranquilizingShot:IsTalentLearned() then return end
    --if target.hp < 40 then return end
    if not enemy:HasBuffFromFor(tranqPurgeableBuffs, 550) then return end

    return spell:Cast(enemy)
end)

Intimidation:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if enemy:IsCCImmune() then return end
    local aware = A.GetToggle(2, "makArenaAware")
    if not enemy:IsPlayer() then return end
    if enemy.distance > 30 then return end
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if ccRemains > 0 then return end

    -- Only use Intimidation if 0 DR (full duration) unless kill target is below 25% HP
    local isExecutePhase = target.hp <= 25
    if enemy.stunDr ~= 1 and not isExecutePhase then return end

    -- Check if we have a rogue in party for healer stun setup
    local hasRogueInParty = (party1.exists and party1:ClassID() == 4) or
                            (party2.exists and party2:ClassID() == 4) or
                            player:ClassID() == 4

    -- If rogue in party: only stun healer (reserve Intimidation for trap setup)
    -- If no rogue in party: can stun kill target
    if hasRogueInParty then
        -- Healer stun conditions (rogue in party for trap setup)
        if enemy:IsHealer() and target.hp > 10 then
            if aware then
                Aware:displayMessage("HEALER STUNNED - USE FREEZING TRAP!", "Red", 2)
            end
            return spell:Cast(enemy)
        end
    else
        -- No rogue in party: stun kill target when healer is CC'd
        if enemy:IsTarget() and enemyHealer.ccRemains > 2000 and target.hp <= 35 then
            return spell:Cast(enemy)
        end
    end
end)

ScatterShot:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if enemy:IsCCImmune() then return end
    if enemy.distance > 30 then return end
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if ccRemains > 0 then return end

    if enemy:IsUnit(target) then return end
    if enemy.incapacitateDr < 0.25 then return end

    if enemy:IsUnit(enemyHealer) and target.hp <= 25 then
        return spell:Cast(enemy)
    end

    if enemy:IsUnit(enemyHealer) and target.hp <= 40 and enemy.incapacitateDr >= .5 then
        return spell:Cast(enemy)
    end

    if not enemy:IsUnit(enemyHealer) and enemy.incapacitateDr == 1 and (party1.exists and party1.hp > 0 and party1.hp < 40) then
        return spell:Cast(enemy)
    end

    if not enemy:IsUnit(enemyHealer) and enemy.incapacitateDr == 1 and (party2.exists and party2.hp > 0 and party2.hp < 40) then
        return spell:Cast(enemy)
    end

    if not enemy:IsUnit(enemyHealer) and enemy.incapacitateDr == 1 and (player.hp > 0 and player.hp < 40) and AspectOfTheTurtle:Cooldown() > 2000 then
        return spell:Cast(enemy)
    end
end)

ChimaeralSting:Callback("arena", function(spell, enemy)
    if not target.exists then return end
    if not enemy:IsUnit(enemyHealer) then return end
    if enemy.totalImmune then return end
    -- if enemy has the buff from Ancient of Lore, don't cast
    if enemy:Buff(117679) then return end
    if enemy.cc then return end
    if target.hp < 30 then return end
    -- Only cast if silence will have full 4-second duration (no DR)
    if enemy.silenceDr ~= 1 then return end

    return spell:Cast(enemy)
end)

RoarOfSacrifice:Callback("arena", function(spell, friendly)
    if not A.RoarOfSacrifice:IsTalentLearned() then return end
    if friendly.totalImmune then return end
    if friendly.hp < 70 and enemyBurstCount() >= 1 then
        return spell:Cast(friendly)
    end

    if friendly.hp < 40 then
        return spell:Cast(friendly)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    if player:Buff(buffs.camouflage) then return end
    if player:Debuff(410201) then return end

    Intimidation("arena", enemy)
    CounterShot("arena", enemy)
    ScatterShot("arena", enemy)
    TranquilizingShot("arena", enemy)
    ChimaeralSting("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    RoarOfSacrifice("arena", friendly)
end

A[6] = function(icon)
	RegisterIcon(icon)

    if targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end

    if Action.Zone == "arena" then
        partyRotation(party1)
        enemyRotation(arena1)
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
