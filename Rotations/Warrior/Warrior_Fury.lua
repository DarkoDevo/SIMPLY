-- NEW
if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 72 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon
local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local Aware            = MakuluFramework.Aware
local Debounce         = MakuluFramework.debounceSpell
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache

local _G, setmetatable = _G, setmetatable

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle        = Action.GetToggle
local Unit             = Action.Unit

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
local enemyHealer = ConstUnit.enemyHealer

local ActionID       = {
    
    -- Racials
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
    
    -- Random
    DelayIcon    = { ID = 20579 },
    PoolResource = { ID = 209274 },
    StopCast     = { ID = 61721 },
    TargetEnemy  = { ID = 44603 },
    
    AntiFakeCC   = { Type = "SpellSingleColor", ID = 107570,      Hidden = true,        Color = "YELLOW"    , Desc = "[1] AntiFakeCC",      QueueForbidden = true    },
    AntiFakeKick = { Type = "SpellSingleColor", ID = 6552,  Hidden = true,        Color = "GREEN"        , Desc = "[2] AntiFakeKick",    QueueForbidden = true    },
    
    
    -- Abilities
    BattleShout     = { ID = 6673 },
    Charge          = { ID = 100 },
    DefensiveStance = { ID = 386208 },
    HeroicThrow     = { ID = 57755, MAKULU_INFO = { damageType = "physical" } },
    Pummel          = { ID = 6552, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true }  },
    Slam            = { ID = 1464, MAKULU_INFO = { damageType = "physical" } },
    VictoryRush     = { ID = 34428, MAKULU_INFO = { damageType = "physical" } },

    -- Talents
    Avatar            = { ID = 107574 },
    BerserkerRage     = { ID = 18499 },
    BerserkerStance   = { ID = 386196 },
    BerserkersTorment = { ID = 390123, Hidden = true },
    BloodandThunder   = { ID = 384277, Hidden = true },
    ChampionsSpear    = { ID = 376079, FixedTexture = 3565453, MAKULU_INFO = { damageType = "physical" }, Macro = "/cast [@player]spell:thisID" },
    CrushingForce     = { ID = 382764, Hidden = true },
    DoubleTime        = { ID = 103827, Hidden = true },
    FrothingBerserker = { ID = 215571, Hidden = true },
    HeroicLeap        = { ID = 6544 },
    ImmovableObject   = { ID = 394307, Hidden = true },
    ImpendingVictory  = { ID = 202168, MAKULU_INFO = { damageType = "physical" } },
    IntimidatingShout = { ID = 5246, Texture = 355, MAKULU_INFO = { damageType = "physical" } },
    OverwhelmingRage  = { ID = 382767, Hidden = true },
    RallyingCry       = { ID = 97462 },
    RumblingEarth     = { ID = 275339, Hidden = true },
    Shockwave         = { ID = 46968, MAKULU_INFO = { damageType = "physical" } },
    SonicBoom         = { ID = 390725, Hidden = true },
    SpellReflection   = { ID = 23920 },
    StormBolt         = { ID = 107570, MAKULU_INFO = { damageType = "physical" } },
    ThunderClap       = { ID = 6343, Texture = 272824, MAKULU_INFO = { damageType = "physical" } },
    ThunderousRoar    = { ID = 384318, MAKULU_INFO = { damageType = "physical" } },
    TitanicThrow      = { ID = 384090, MAKULU_INFO = { damageType = "physical" } },
    WreckingThrow     = { ID = 384110, MAKULU_INFO = { damageType = "physical" } },
    
    -- Pool
    Pool = { ID = 999910 },
    
    -- Abilities
    Bloodbath    = { ID = 335096, MAKULU_INFO = { damageType = "physical" } },
    CrushingBlow = { ID = 335097, MAKULU_INFO = { damageType = "physical" } },
    Execute      = { ID = 5308, MAKULU_INFO = { damageType = "physical" } },
    ExecuteToo   = { ID = 280735, MAKULU_INFO = { damageType = "physical" } },
    Whirlwind    = { ID = 190411, MAKULU_INFO = { damageType = "physical" } },
    
    
    -- Other Talents
    AngerManagement   = { ID = 152278, Hidden = true },
    Annihilator       = { ID = 383916, Hidden = true },
    AshenJuggernaut   = { ID = 392536, Hidden = true },
    Bladestorm        = { ID = 446035, Texture = 228920, MAKULU_INFO = { damageType = "physical" } },
    BladestormThane   = { ID = 227847, Texture = 228920, MAKULU_INFO = { damageType = "physical" } },
    Bloodthirst       = { ID = 23881, MAKULU_INFO = { damageType = "physical" } },
    ColdSteelHotBlood = { ID = 383959, Hidden = true },
    DancingBlades     = { ID = 391683, Hidden = true },
    Frenzy            = { ID = 335077, Hidden = true },
    ImprovedExecute   = { ID = 316402, Hidden = true },
    ImprovedWhirlwind = { ID = 12950, Hidden = true },
    Massacre          = { ID = 206315, Hidden = true },
    MeatCleaver       = { ID = 280392, Hidden = true },
    OdynsFury         = { ID = 385059, MAKULU_INFO = { damageType = "physical" } },
    Onslaught         = { ID = 315720, MAKULU_INFO = { damageType = "physical" } },
    RagingBlow        = { ID = 85288, MAKULU_INFO = { damageType = "physical" } },
    Rampage           = { ID = 184367, MAKULU_INFO = { damageType = "physical" } },
    Ravager           = { ID = 228920, MAKULU_INFO = { damageType = "physical" }, Macro = "/cast [@player]spell:thisID" },
    RecklessAbandon   = { ID = 396749, Hidden = true },
    Recklessness      = { ID = 1719 },
    StormofSwords     = { ID = 388903, Hidden = true },
    SuddenDeath       = { ID = 280721, Hidden = true },
    Tenderize         = { ID = 388933, Hidden = true },
    TitanicRage       = { ID = 394329, Hidden = true },
    TitansTorment     = { ID = 390135, Hidden = true },
    ViciousContempt   = { ID = 383885, Hidden = true },
    WrathandFury      = { ID = 392936, Hidden = true },
    
    -- Other Things (sort these into correct slots later)
    BitterImmunity      = { ID = 383762 },
    Bloodborne          = { ID = 385703, Hidden = true },
    ChampionsMight      = { ID = 386284, Hidden = true },
    Disarm              = { ID = 236077, MAKULU_INFO = { damageType = "physical" } },
    EnragedRegeneration = { ID = 184364 },
    Hamstring           = { ID = 1715, MAKULU_INFO = { damageType = "physical" } },
    IgnorePain          = { ID = 190456 },
    Intervene           = { ID = 3411 },
    PiercingHowl        = { ID = 12323, MAKULU_INFO = { damageType = "physical" } },
    ShatteringThrow     = { ID = 64382, MAKULU_INFO = { damageType = "physical" } },
    SlaughteringStrikes = { ID = 388004, Hidden = true },
    Taunt               = { ID = 355 },
    Unhinged            = { ID = 386628, Hidden = true },
    Uproar              = { ID = 391572, Hidden = true },
    
    -- Hero Talents
    LightningStrikes = { ID = 434969, Hidden = true },
    SlayersDominance = { ID = 444767, Hidden = true },
    ThunderBlast     = { ID = 435222, Texture = 272824, MAKULU_INFO = { damageType = "magic" } },
    
    -- Season 3 Tier Set Mechanics
    IonizingStrikes = { ID = 435222, Hidden = true }, -- Mountain Thane 2pc proc (VERIFIED CORRECT)
    Overwhelmed     = { ID = 445584, Hidden = true }, -- Debuff that stacks on targets (VERIFIED CORRECT)
    ReapTheStorm    = { ID = 446918, Hidden = true }, -- Slayer 4pc proc ability (FIXED - was conflicting with LightningStrikes)
    SevereThunder   = { ID = 435223, Hidden = true }, -- Mountain Thane 4pc enhanced Thunder Blast (VERIFIED CORRECT)
    SlayersStrike   = { ID = 446919, Hidden = true }, -- Slayer 2pc proc ability (FIXED - was conflicting with SlayersDominance)
    
    -- Season 3 Tier Set Bonuses (Updated with correct Season 3 IDs)
    -- These IDs are based on Season 3 tier set detection patterns
    MountainThaneTier2pc = { ID = 446922, Hidden = true }, -- Mountain Thane 2pc: Thunder Blast Ionizing Strikes proc
    MountainThaneTier4pc = { ID = 446923, Hidden = true }, -- Mountain Thane 4pc: Enhanced Ionizing Strikes + Thunder Blast charge
    SlayerTier2pc        = { ID = 446920, Hidden = true }, -- Slayer 2pc: Execute damage +10%, Sudden Death Execute proc
    SlayerTier4pc        = { ID = 446921, Hidden = true }, -- Slayer 4pc: Raging Blow damage +10%, Reap the Storm proc
    
    -- Lotions and Potions
    AlgariManaPotion         = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
    FrontlinePotion          = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    Healthstone              = { Type = "Item", ID = 5512, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    TemperedPotion1          = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2          = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3          = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    
    -- Arena Preparation (you cheeky bastard - you never work)
    ArenaPreparation = { ID = 32727, Hidden = true },
    
    -- PVP Talents
    DeathWish = { ID = 199261 },
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })
Action[ACTION_CONST_WARRIOR_FURY] = A
TableToLocal(M, getfenv(1))
Aware:enable()

local function num(val)
    if val then return 1 else return 0 end
end

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    minTalentedCdRemains = nil,
    cursorCheck = false,
    shouldAoE = false,
    
    -- Season 3 Tier Set State
    slayerTier2pc = false,
    slayerTier4pc = false,
    mountainThaneTier2pc = false,
    mountainThaneTier4pc = false,
    overwhelmedStacks = 0,
    severeThunderActive = false,
    ionizingStrikesReady = false,
    isSlayer = false,
    isMountainThane = false,
}

local buffs = {
    avatar = 107574,
    battleShout = 6673,
    warMachine = 262232,
    ashenJuggernaut = 392537,
    bloodcraze = 393951,
    dancingBlades = 391688,
    enrage = 184362,
    frenzy = 335082,
    furiousBloodthirst = 423211,
    meatCleaver = 85739,
    mercilessAssault = 409983,
    recklessness = 1719,
    suddenDeath = 280776,
    hurricane = 390581,
    gushingWound = 385042,
    championsMight = 386286,
    berserkerStance = 386196,
    defensiveStance = 386208,
    enragedRegeneration = 184364,
    brutalFinish = 446918,
    ravager = 228920,
    burstofPower = 437121, 
    
    -- Season 3 Tier Set Buffs
    severeThunder = 435223, -- Mountain Thane 4pc enhanced Thunder Blast
    slaughteringStrikes = 388004, -- Missing from original
    opportunist = 456120, -- Missing from original
    imminentDemise = 445584, -- Missing from original
    bloodbathDot = 385042, -- Missing from original
    bladestorm = 446035, -- Bladestorm buff (updated ID)
}

local debuffs = {
    championsMight = 376080,
    gushingWound = 385042,
    odynsFury = 385060,
    markedForExecution = 445584,
    
    -- Season 3 Tier Set Debuffs
    overwhelmed = 429765, -- Key Season 3 debuff for tier set procs (Slayer 4pc)
    bloodbathDot = 385042, -- Bloodbath DoT effect
}

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            
            -- if activeEnemies and type(activeEnemies) == "table" then
            for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
                local enemy = MakUnit:new(enemyGUID)
                if Slam:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                    total = total + 1
                    -- end
                end
            end
            
            return total
    end)
end

local function activeEnemies()
    return enemiesInMelee()
end

local interrupts = {
    {spell = Pummel },
    {spell = StormBolt, isCC = true},
    {spell = Shockwave, isCC = true, aoe = true, distance = 5},
}

local function shouldBurst()
    if A.BurstIsON("player") then
        --if A.Zone ~= "arena" then
        --local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --for enemy in pairs(activeEnemies) do
        --    if ActionUnit(enemy):Health() > (A.Slam:GetSpellDescription()[1] * 15) then
        --        return true
        --    end
        --end
        --else
        --    return true
        --end
        return true
    end
    return false
end

local function makTrinket(icon)
    if not shouldBurst() then return end
    if not pet.exists then return end
    --[[local gladiatorTrinkets = {
        208307, -- Verdant Combatant's Medallion
        209764, -- Verdant Aspirant's Medallion 
        209346, -- Verdant Gladiator's Medallion
        211606, -- Draconic Combatant's Medallion
        216369, -- Draconic Aspirant's Medallion
        216282, -- Draconic Gladiator's Medallion
    }
    
    for _, trinket in pairs(gladiatorTrinkets) do
        if IsEquippedItem(trinket) then
            return false
        end
    end]]
    
    if A.Trinket1:ReadyToUse("target") then
        return A.Trinket1:Show(icon)
    end
    
    if A.Trinket2:ReadyToUse("target") then
        return A.Trinket2:Show(icon)
    end
    
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    player = MakUnit:new("player")
    for defensive, _ in pairs(MakLists.Defensive) do
        if player:Buff(defensive) then
            return true
        end
    end
    return UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()
    
    return incomingDamage and not defensiveActive()
end

local function debuffCount(spellId)
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local debuffCount = 0
    
    -- if activeEnemies and type(activeEnemies) == "table" then
    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if enemy:Debuff(spellId, true) then
            debuffCount = debuffCount + 1
            -- end
        end
    end
    
    return debuffCount
end

local function missingBuff(spellID)
    if ActionUnit("player"):HasBuffs(spellID) == 0 then
        return true
    end
    
    for i = 1, 4 do
        local unitID = "party" .. i
        if UnitExists(unitID) and ActionUnit(unitID):HasBuffs(spellID) == 0 and A.BattleShout:IsSpellInRange(unitID) then
            return true
        end
    end
    return false
end

local function battleShoutCount() 
    local partyUnits = {party1, party2, party3, party4, player}
    local total = 0
    for _, unit in ipairs(partyUnits) do
        if unit:Buff(buffs.battleShout, true) then
            total = total + 1
        end
    end 
    
    return total
end

local function bloodthirstCrit()
    
    local critChance = GetCritChance()
    
    if player:HasBuff(buffs.recklessness) then
        critChance = critChance + 20
    end
    
    if player:HasBuff(buffs.mercilessAssault) then
        critChance = critChance + player:HasBuffCount(buffs.mercilessAssault) * 12
    end
    
    if player:HasBuff(buffs.bloodcraze) then
        critChance = critChance + player:HasBuffCount(buffs.bloodcraze) * 15
    end
    
    return critChance
end

local function orbsActive()
    local cacheKey = "orbsActive"
    
    return constCell:GetOrSet(cacheKey, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            
            -- if activeEnemies and type(activeEnemies) == "table" then
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                local enemyCast = enemy.castInfo
                local orb = enemyCast and enemyCast.spellId == 461904
                if HeroicThrow:InRange(enemy) and orb then
                    return true
                    -- end
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
    
    if Slam:InRange(target) and target.exists then return false end
    
    if gameState.activeEnemies > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local lastUpdateTime = 0
local updateDelay = 0.1
local function updateGameState()
    local currentTime = GetTime()
    
    -- Performance optimization: Only update expensive calculations when needed
    if currentTime - lastUpdateTime < updateDelay then
        return
    end
    lastUpdateTime = currentTime
    
    -- Core combat state (updated every frame for responsiveness)
    gameState.shouldAoE = activeEnemies() >= 2 and Action.GetToggle(2, "AoE") and Action.Zone ~= "arena"
    gameState.orbsActive = orbsActive()
    gameState.activeEnemies = activeEnemies()
    
    -- Season 3 Tier Set Detection (cached for performance)
    local constCell = cacheContext:getConstCacheCell()
    gameState.slayerTier2pc = constCell:GetOrSet("slayerTier2pc", function() return IsPlayerSpell(A.SlayerTier2pc.ID) end)
    gameState.slayerTier4pc = constCell:GetOrSet("slayerTier4pc", function() return IsPlayerSpell(A.SlayerTier4pc.ID) end)
    gameState.mountainThaneTier2pc = constCell:GetOrSet("mountainThaneTier2pc", function() return IsPlayerSpell(A.MountainThaneTier2pc.ID) end)
    gameState.mountainThaneTier4pc = constCell:GetOrSet("mountainThaneTier4pc", function() return IsPlayerSpell(A.MountainThaneTier4pc.ID) end)
    
    -- Hero Talent Detection (cached for performance)
    gameState.isSlayer = constCell:GetOrSet("isSlayer", function() return IsPlayerSpell(A.SlayersDominance.ID) end)
    gameState.isMountainThane = constCell:GetOrSet("isMountainThane", function() return IsPlayerSpell(A.LightningStrikes.ID) end)
    
    -- Season 3 Mechanics State (updated every frame for accuracy)
    gameState.overwhelmedStacks = target:HasDeBuffCount(debuffs.overwhelmed) or 0
    gameState.severeThunderActive = player:HasBuff(buffs.severeThunder)
    gameState.ionizingStrikesReady = constCell:GetOrSet("ionizingStrikesReady", function() return IsPlayerSpell(A.IonizingStrikes.ID) end)
    
    -- Additional Season 3 optimizations
    gameState.enrageActive = player:HasBuff(buffs.enrage)
    gameState.recklessnessActive = player:HasBuff(buffs.recklessness)
    gameState.avatarActive = player:HasBuff(buffs.avatar)
    
    -- Season 3 Tier Set Validation (for debugging)
    -- These values should be true when Season 3 tier sets are equipped
    if gameState.slayerTier2pc or gameState.slayerTier4pc or gameState.mountainThaneTier2pc or gameState.mountainThaneTier4pc then
        -- Tier set bonuses detected - Season 3 optimizations active
        gameState.season3TierActive = true
    else
        gameState.season3TierActive = false
    end
    
    -- SimC APL Variables (matching official APL logic)
    gameState.st_planning = gameState.activeEnemies == 1 -- Single target planning
    gameState.adds_remain = gameState.activeEnemies >= 2 -- Adds remain active
    gameState.execute_phase = (IsPlayerSpell(A.Massacre.ID) and target.hp < 35) or target.hp < 20 -- Execute phase detection
    
end

--###########################################################################################################################################################################################
--                                                                CALLBACKS
--###########################################################################################################################################################################################

--################################################################ STANCES ##################################################################################################################
BerserkerStance:Callback(function(spell)
        if GetToggle(2, "StanceMode") == "1" then
            if player.hp > 50 and not player:Buff(buffs.berserkerStance) then
                return spell:Cast(player)
            end
        end
        
        if GetToggle(2, "StanceMode") == "2" and not player:Buff(buffs.berserkerStance) then
            return spell:Cast(player)
        end
end)

DefensiveStance:Callback(function(spell)
        if GetToggle(2, "StanceMode") == "1" then
            if player.hp <= 50 and not player:Buff(buffs.defensiveStance) then
                return spell:Cast(player)
            end
        end
        
        if GetToggle(2, "StanceMode") == "3" and not player:Buff(buffs.defensiveStance) then
            return spell:Cast(player)
        end
end)

--###############################################################################  RACIALS  ###########################################################################################

ArcaneTorrent:Callback(function(spell)
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

LightsJudgment:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

BagOfTricks:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

Berserking:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

BloodFury:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)    
end)

Fireblood:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

AncestralCall:Callback(function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

local function racials()
    ArcaneTorrent()
    LightsJudgment()
    BagOfTricks()
    Berserking()
    BloodFury()
    Fireblood()
    AncestralCall()
end

--############################################################# BASE STUFF #################################################################################################################

Pummel:Callback("base", function(spell)
        if not target.pvpKick then return end
        
        return spell:Cast(target)
end)

BattleShout:Callback(function(spell)
        if player.inCombat then return end
        if player:HasBuff(buffs.battleShout) then return end
        
        return spell:Cast(player)
end)

BattleShout:Callback("party", function(spell)
        if not party1.exists or party1:Buff(buffs.battleShout) then return end
        if not party2.exists or party2:Buff(buffs.battleShout) then return end
        if not party3.exists or party3:Buff(buffs.battleShout) then return end
        if not party4.exists or party4:Buff(buffs.battleShout) then return end
        
        return spell:Cast(player)
end)

Charge:Callback(function(spell)
        if Action.Zone == "arena" then return end
        if player.inCombat then return end
        if Unit("target"):GetRange() < 8 then return end
        if Unit("target"):GetRange() > 25 then return end
        
        return spell:Cast(target)
end)

Bloodthirst:Callback("heal", function(spell)
        
        if not player:HasBuff(buffs.enragedRegeneration) then return end
        
        return spell:Cast(target)
end)

VictoryRush:Callback("heal", function(spell)
        if not player.inCombat then return end
        if IsPlayerSpell(A.ImpendingVictory.ID) then return end
        if player.hp > GetToggle(2, "VictoryRushSlider") then return end
        if not player:HasBuff(buffs.victorious) then return end -- Requires Victorious buff
        
        return spell:Cast(target)
end)

ImpendingVictory:Callback("heal", function(spell)
        if not player.inCombat then return end
        if not IsPlayerSpell(A.ImpendingVictory.ID) then return end
        if player.hp > GetToggle(2, "VictoryRushSlider") then return end
        if player.rage < 10 then return end -- Requires 10 rage
        
        return spell:Cast(target)
end)

EnragedRegeneration:Callback("heal", function(spell)
        if not player.inCombat then return end
        if player.hp > GetToggle(2, "EnragedRegenerationSlider") then return end
        
        return spell:Cast(player)
end)

BitterImmunity:Callback("heal", function(spell)
        if not player.inCombat then return end
        if player:HasBuff(buffs.enragedRegeneration) then return end
        if player.hp > GetToggle(2, "BitterImmunitySlider") then return end
        
        return spell:Cast(player)
end)

RallyingCry:Callback(function(spell)
        if not player.inCombat then return end
        if player.hp > GetToggle(2, "RallyingCrySlider") then return end
        
        return spell:Cast(player)
end)

RallyingCry:Callback("party", function(spell)
        if not player.inCombat then return end
        if not party1.exists or party1.hp > GetToggle(2, "RallyingCrySlider") then return end
        if not party2.exists or party2.hp > GetToggle(2, "RallyingCrySlider") then return end
        if not party3.exists or party3.hp > GetToggle(2, "RallyingCrySlider") then return end
        if not party4.exists or party4.hp > GetToggle(2, "RallyingCrySlider") then return end
        
        return spell:Cast(player)
end)

BerserkerRage:Callback(function(spell)
        if not player:HasDeBuff(MakLists.feared) then return end
        
        return Debounce("berRage", 350, 2500, spell)
end)

SpellReflection:Callback(function(spell)
    -- Check if current target is casting a reflectable spell (works in all content)
    if target.exists and target:CastingFromFor(MakLists.arenaSpellReflect, 500) then
        local castInfo = target.castOrChannelInfo
        -- Only reflect if cast is far enough along (60%+) to avoid wasting cooldown
        if castInfo and castInfo.percent >= 60 then
            return spell:Cast(player)
        end
    end

    -- Arena-specific: check arena enemies casting at us
    if Action.Zone == "arena" then
        local shouldReflect = false

        if arena1.exists and arena1:CastingFromFor(MakLists.arenaSpellReflect, 500) then
            local castInfo = arena1.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 and (arena1.distance > 5 or Pummel.cooldown > 1000) then
                shouldReflect = true
            end
        end

        if arena2.exists and arena2:CastingFromFor(MakLists.arenaSpellReflect, 500) then
            local castInfo = arena2.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 and (arena2.distance > 5 or Pummel.cooldown > 1000) then
                shouldReflect = true
            end
        end

        if arena3.exists and arena3:CastingFromFor(MakLists.arenaSpellReflect, 500) then
            local castInfo = arena3.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 and (arena3.distance > 5 or Pummel.cooldown > 1000) then
                shouldReflect = true
            end
        end

        if shouldReflect then
            return spell:Cast(player)
        end
    end
end)

ShatteringThrow:Callback(function(spell)
        if target:HasBuffFromFor(MakLists.shatteringBuffs, 500) then 
            return spell:Cast(target)
        end
end)

local function baseStuff()
    BerserkerStance()
    DefensiveStance()
    BattleShout()
    BattleShout("party")
    EnragedRegeneration("heal")
    BitterImmunity("heal")
    RallyingCry()
    RallyingCry("party")
    BerserkerRage()
    SpellReflection()
end

local function baseStuffCombat()
    Pummel("base")
    Charge()
    Bloodthirst("heal")
    VictoryRush("heal")
    ImpendingVictory("heal")
    ShatteringThrow()
end

--###############################################################################  SLAYER  #########################################################################################
-- APL 10-19-2025
--################################################################################################################################################################################################################

Recklessness:Callback("slayer_simc", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Avatar:Callback("slayer_simc", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Rampage:Callback("slayer_season3_enrage_priority", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_season3_unified_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        local markedStacks = target:HasDeBuffCount(debuffs.markedForExecution) or 0
        local suddenDeathStacks = player:HasBuffCount(buffs.suddenDeath) or 0
        
        if markedStacks >= 2 or suddenDeathStacks >= 2 then
            return spell:Cast(target)
        end
end)

RagingBlow:Callback("slayer_season3_overwhelmed", function(spell)
        if target.totalImmune or target.physImmune then return end
        local overwhelmedStacks = target:HasDeBuffCount(debuffs.overwhelmed) or 0
        
        if overwhelmedStacks > 0 and gameState.slayerTier4pc then
            return spell:Cast(target)
        end
end)

RagingBlow:Callback("slayer_season3_reap_storm", function(spell)
        if target.totalImmune or target.physImmune then return end
        -- Season 3: Raging Blow triggers Reap the Storm based on number of Overwhelmed stacks
        -- High priority in AoE when Season 3 tier set is active
        if gameState.activeEnemies >= 2 and gameState.slayerTier4pc then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_simc_ashen", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.ashenJuggernaut) and player:BuffRemains(buffs.ashenJuggernaut) <= A.GetGCD() * 1000 then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_simc_sudden", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.suddenDeath) and player:BuffRemains(buffs.suddenDeath) < 2000 and not gameState.execute_phase then
            return spell:Cast(target)
        end
end)

ThunderousRoar:Callback("slayer_simc_aoe", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if gameState.activeEnemies > 1 and player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

ChampionsSpear:Callback("slayer_simc_complex", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if Bladestorm:ReadyToUse() and (Avatar:ReadyToUse() or Recklessness:ReadyToUse() or player:HasBuff(buffs.avatar) or player:HasBuff(buffs.recklessness)) and player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

OdynsFury:Callback("slayer_simc_titanic", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if gameState.activeEnemies > 1 and IsPlayerSpell(A.TitanicRage.ID) and player:HasBuffCount(buffs.meatCleaver) == 0 then
            return spell:Cast(player)
        end
end)

Bladestorm:Callback("slayer_simc_complex", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        
        if player:HasBuff(buffs.enrage) and (IsPlayerSpell(A.RecklessAbandon.ID) and Avatar.cooldown >= 24000 or IsPlayerSpell(A.AngerManagement.ID) and Recklessness.cooldown >= 15000 and (player:HasBuff(buffs.avatar) or Avatar.cooldown >= 8000)) then
            return spell:Cast(player)
        end
end)

Bladestorm:Callback("slayer_simc_aoe_practical", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        
        -- Major cooldown coordination logic - only cast during optimal burst windows
        local hasRecklessness = player:HasBuff(buffs.recklessness)
        local hasAvatar = player:HasBuff(buffs.avatar)
        local recklessnessCooldown = A.Recklessness:GetCooldown() or 999999
        local avatarCooldown = A.Avatar:GetCooldown() or 999999
        local cooldownsAvailable = (recklessnessCooldown <= 10000) and (avatarCooldown <= 10000)
        
        -- Only cast if major cooldowns are active OR both are available/nearly available
        if not (hasRecklessness or hasAvatar or cooldownsAvailable) then return end
        
        -- High priority in AoE situations where Bladestorm excels
        if gameState.activeEnemies >= 3 and player:HasBuff(buffs.enrage) and (target.ttd > 8000 or target.isDummy) then
            return spell:Cast(player)
        end
        -- Use in 2+ enemy situations when other conditions are met
        if gameState.activeEnemies >= 2 and player:HasBuff(buffs.enrage) and player.rage >= 80 and (target.ttd > 10000 or target.isDummy) then
            return spell:Cast(player)
        end
end)

-- REMOVED: slayer_practical_execute_phase - Redundant with slayer_simc_execute (too broad, blocks other abilities)
-- REMOVED: slayer_practical_sudden_death - Redundant with slayer_simc_sudden/sudden2/sudden_filler
-- REMOVED: slayer_practical_ashen - Redundant with slayer_simc_ashen (higher priority, more specific)

Whirlwind:Callback("slayer_simc_cleaver", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.activeEnemies >= 2 and IsPlayerSpell(A.MeatCleaver.ID) and player:HasBuffCount(buffs.meatCleaver) == 0 then
            return spell:Cast(player)
        end
end)

Onslaught:Callback("slayer_simc_tenderize", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and player:TalentKnown(388933) and player:HasBuff(buffs.brutalFinish) then
            return spell:Cast(target)
        end
end)

Onslaught:Callback("slayer_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and player.rage <= 100 then
            return spell:Cast(target)
        end
end)

Rampage:Callback("slayer_simc_enrage", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:BuffRemains(buffs.enrage) < A.GetGCD() * 1000 then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_simc_sudden2", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuffCount(buffs.suddenDeath) == 2 and player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_simc_marked", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuffCount(debuffs.markedForExecution) > 1 and player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

OdynsFury:Callback("slayer_simc_aoe", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if gameState.activeEnemies > 1 and not IsPlayerSpell(A.TitanicRage.ID) then
            return spell:Cast(player)
        end
end)

RagingBlow:Callback("slayer_simc_aoe_priority", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.activeEnemies >= 2 and gameState.slayerTier4pc then
            return spell:Cast(target)
        end
        if gameState.activeEnemies >= 2 and gameState.overwhelmedStacks > 0 then
            return spell:Cast(target)
        end
        if gameState.activeEnemies >= 3 and player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

CrushingBlow:Callback("slayer_simc_complex", function(spell)
        if target.totalImmune or target.physImmune then return end
        if RagingBlow:Charges() == 2 or
        (player:HasBuff(buffs.brutalFinish) and
            (not target:HasDeBuff(debuffs.championsMight) or
                (target:HasDeBuff(debuffs.championsMight) and target:DebuffRemains(debuffs.championsMight) > A.GetGCD() * 1000))) then
            return spell:Cast(player)
        end
end)

Bloodbath:Callback("slayer_simc_complex", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and (player:HasBuffCount(buffs.bloodcraze) >= 1 or
            (IsPlayerSpell(A.Uproar.ID) and target:DebuffRemains(debuffs.bloodbathDot) < 40000 and IsPlayerSpell(A.Bloodborne.ID)) or
            (player:HasBuff(buffs.enrage) and player:BuffRemains(buffs.enrage) < A.GetGCD() * 1000)) then
            return spell:Cast(player)
        end
end)

RagingBlow:Callback("slayer_simc_brutal", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.brutalFinish) and player:HasBuffCount(buffs.slaughteringStrikes) < 5 and
        (not target:HasDeBuff(debuffs.championsMight) or
            (target:HasDeBuff(debuffs.championsMight) and target:DebuffRemains(debuffs.championsMight) > A.GetGCD() * 1000)) then
            return spell:Cast(target)
        end
end)

Rampage:Callback("slayer_simc_rage", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player.rage > 115 then
            return spell:Cast(target)
        end
end)

Execute:Callback("slayer_simc_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.execute_phase and target:HasDeBuff(debuffs.markedForExecution) and player:HasBuff(buffs.enrage) and gameState.activeEnemies == 1 then
            return spell:Cast(target)
        end
end)

Bloodthirst:Callback("slayer_simc_vicious", function(spell)
        if target.totalImmune or target.physImmune then return end
        local critPct = GetCritChance() -- Approximation for crit_pct_current
        if (target.hp < 35 and IsPlayerSpell(A.ViciousContempt.ID) and player:HasBuff(buffs.brutalFinish) and
            player:HasBuff(buffs.enrage) and critPct >= 85 and gameState.activeEnemies == 1) or
        (not gameState.slayerTier4pc and gameState.activeEnemies > 4) then
            return spell:Cast(target)
        end
end)

CrushingBlow:Callback("slayer_simc_rage", function(spell)
        if target.totalImmune or target.physImmune then return end
        
        local ragingBlowCharges = 0
        if RagingBlow and type(RagingBlow.Charges) == "function" then
            ragingBlowCharges = RagingBlow:Charges()
        elseif A.RagingBlow and type(A.RagingBlow.Charges) == "function" then
            ragingBlowCharges = A.RagingBlow:Charges()
        end
        
        if ragingBlowCharges <= 1 and player.rage >= 100 and
        IsPlayerSpell(A.AngerManagement.ID) and not player:HasBuff(buffs.recklessness) then
            return spell:Cast(player)
        end
end)

Bloodbath:Callback("slayer_simc_crit", function(spell)
        if target.totalImmune or target.physImmune then return end
        local critPct = GetCritChance()
        if player:HasBuffCount(buffs.bloodcraze) >= 4 or critPct >= 85 then
            return spell:Cast(player)
        end
end)

RagingBlow:Callback("slayer_simc_opportunist", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.opportunist) then
            return spell:Cast(target)
        end
end)

Rampage:Callback("slayer_simc_abandon", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player.rage >= 120 or
        (IsPlayerSpell(A.RecklessAbandon.ID) and player:HasBuff(buffs.recklessness) and
            player:HasBuffCount(buffs.slaughteringStrikes) >= 3) then
            return spell:Cast(player)
        end
end)

Bloodthirst:Callback("slayer_simc_crit", function(spell)
        if target.totalImmune or target.physImmune then return end
        local critPct = GetCritChance()
        if player:HasBuffCount(buffs.bloodcraze) >= 4 or critPct >= 85 then
            return spell:Cast(target)
        end
end)

RagingBlow:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

Rampage:Callback("slayer_simc_anger", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player.rage >= 100 and IsPlayerSpell(A.AngerManagement.ID) and player:HasBuff(buffs.recklessness) then
            return spell:Cast(player)
        end
end)

Bloodthirst:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

Rampage:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Execute:Callback("slayer_simc_sudden_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.suddenDeath) then
            return spell:Cast(target)
        end
end)

ThunderousRoar:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if player:HasBuff(buffs.enrage) and not player:HasBuff(buffs.brutalFinish) then
            return spell:Cast(player)
        end
end)

Bladestorm:Callback("slayer_simc_practical", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        
        local recklessnessCooldown = 0
        local avatarCooldown = 0
        
        if A.Recklessness and type(A.Recklessness.GetCooldown) == "function" then
            recklessnessCooldown = A.Recklessness:GetCooldown()
        elseif A.Recklessness and A.Recklessness.ID then
            local start, duration = GetSpellCooldown(A.Recklessness.ID)
            recklessnessCooldown = (start > 0 and duration > 0) and ((start + duration - GetTime()) * 1000) or 0
        end
        
        if A.Avatar and type(A.Avatar.GetCooldown) == "function" then
            avatarCooldown = A.Avatar:GetCooldown()
        elseif A.Avatar and A.Avatar.ID then
            local start, duration = GetSpellCooldown(A.Avatar.ID)
            avatarCooldown = (start > 0 and duration > 0) and ((start + duration - GetTime()) * 1000) or 0
        end
        
        local hasRecklessness = player:HasBuff(buffs.recklessness)
        local hasAvatar = player:HasBuff(buffs.avatar)
        local cooldownsAvailable = (recklessnessCooldown <= 5000) and (avatarCooldown <= 5000)
        
        if not (hasRecklessness or hasAvatar or cooldownsAvailable) then return end
        
        if player:HasBuff(buffs.enrage) and (target.ttd > 8000 or target.isDummy) then
            return spell:Cast(player)
        end
end)

WreckingThrow:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 30 then return end
        if not player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

Whirlwind:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if IsPlayerSpell(A.ImprovedWhirlwind.ID) and not player:HasBuff(buffs.meatCleaver) then
            return spell:Cast(player)
        end
end)

Slam:Callback("slayer_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not IsPlayerSpell(A.ImprovedWhirlwind.ID) then
            return spell:Cast(target)
        end
end)

StormBolt:Callback("slayer_simc_bladestorm", function(spell)
        if Action.Zone == "arena" then return end -- PvP consideration
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.bladestorm) then
            return spell:Cast(target)
        end
end)

Rampage:Callback("slayer_bladepage", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:BuffRemains(buffs.brutalFinish) < A.GetGCD() * 1000 and player:HasBuffCount(buffs.slaughteringStrikes) >= 3 then
            return spell:Cast(target)
        end
end)

Rampage:Callback("slayer_simc_ssStacks", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuffCount(buffs.slaughteringStrikes) >= 3 then
            return spell:Cast(player)
        end
end)

local function slayer()
    Recklessness("slayer_simc")
    Avatar("slayer_simc")
    Rampage("slayer_bladepage")
    Rampage("slayer_season3_enrage_priority")
    Onslaught("slayer_simc_tenderize")
    Execute("slayer_season3_unified_execute")
    RagingBlow("slayer_season3_overwhelmed")
    RagingBlow("slayer_season3_reap_storm")
    Execute("slayer_simc_ashen")
    Execute("slayer_simc_sudden")
    ThunderousRoar("slayer_simc_aoe")
    Onslaught("slayer_filler")
    ChampionsSpear("slayer_simc_complex")
    OdynsFury("slayer_simc_titanic")
    Bladestorm("slayer_simc_complex")
    Bladestorm("slayer_simc_aoe_practical")
    Rampage("slayer_simc_ssStacks")
    Whirlwind("slayer_simc_cleaver")
    Rampage("slayer_simc_enrage")
    Execute("slayer_simc_sudden2")
    Execute("slayer_simc_marked")
    OdynsFury("slayer_simc_aoe")
    RagingBlow("slayer_simc_aoe_priority")
    CrushingBlow("slayer_simc_complex")
    Bloodbath("slayer_simc_complex")
    RagingBlow("slayer_simc_brutal")
    Rampage("slayer_simc_rage")
    Execute("slayer_simc_execute")
    Bloodthirst("slayer_simc_vicious")
    CrushingBlow("slayer_simc_rage")
    Bloodbath("slayer_simc_crit")
    RagingBlow("slayer_simc_opportunist")
    Rampage("slayer_simc_abandon")
    Bloodthirst("slayer_simc_crit")
    RagingBlow("slayer_simc_filler")
    Rampage("slayer_simc_anger")
    Bloodthirst("slayer_simc_filler")
    Rampage("slayer_simc_filler")
    Execute("slayer_simc_sudden_filler")
    ThunderousRoar("slayer_simc_filler")
    Bladestorm("slayer_simc_practical")
    WreckingThrow("slayer_simc_filler")
    Whirlwind("slayer_simc_filler")
    Slam("slayer_simc_filler")
    StormBolt("slayer_simc_bladestorm")
end

--###############################################################################  MOUNTAIN THANE  #########################################################################################
-- APL 10-19-25
--################################################################################################################################################################################################################

Recklessness:Callback("thane_simc", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Avatar:Callback("thane_simc", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Ravager:Callback("thane_simc", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if (target.ttd > 8000 or target.isDummy) then
            return spell:Cast(player)
        end
end)

ThunderousRoar:Callback("thane_simc_aoe", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if (target.ttd > 8000 or target.isDummy) and gameState.activeEnemies > 1 and player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

ChampionsSpear:Callback("thane_simc_might", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if player:HasBuff(buffs.enrage) and IsPlayerSpell(A.ChampionsMight.ID) then
            return spell:Cast(player)
        end
end)

ThunderClap:Callback("thane_simc_cleaver", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuffCount(buffs.meatCleaver) == 0 and IsPlayerSpell(A.MeatCleaver.ID) and gameState.activeEnemies >= 2 then
            return spell:Cast(player)
        end
end)

ThunderBlast:Callback("thane_simc_enrage", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.enrage) and IsPlayerSpell(A.MeatCleaver.ID) then
            return spell:Cast(target)
        end
end)

Execute:Callback("thane_simc_ashen", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.ashenJuggernaut) and player:BuffRemains(buffs.ashenJuggernaut) <= A.GetGCD() * 1000 then
            return spell:Cast(target)
        end
end)

Rampage:Callback("thane_simc_enrage_low", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:BuffRemains(buffs.enrage) < A.GetGCD() * 1000 then
            return spell:Cast(player)
        end
end)

ThunderBlast:Callback("thane_simc_enrage_any", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

Execute:Callback("thane_simc_sudden2", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuffCount(buffs.suddenDeath) == 2 and player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

Execute:Callback("thane_simc_marked", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuffCount(debuffs.markedForExecution) > 1 and player:HasBuff(buffs.enrage) then
            return spell:Cast(target)
        end
end)

ThunderClap:Callback("thane_simc_cleaver2", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.activeEnemies >= 2 and IsPlayerSpell(A.MeatCleaver.ID) and player:HasBuffCount(buffs.meatCleaver) < 2 then
            return spell:Cast(player)
        end
end)

Onslaught:Callback("thane_simc_tenderize", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and IsPlayerSpell(A.Tenderize.ID) and player:HasBuff(buffs.brutalFinish) then
            return spell:Cast(target)
        end
end)

Rampage:Callback("thane_simc_slaughter", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not player:HasBuff(buffs.enrage) or player:HasBuffCount(buffs.slaughteringStrikes) >= 4 then
            return spell:Cast(player)
        end
end)

CrushingBlow:Callback("thane_simc_charges", function(spell)
        if target.totalImmune or target.physImmune then return end
        
        -- Safe charge check with nil protection
        local ragingBlowCharges = 0
        if RagingBlow and type(RagingBlow.Charges) == "function" then
            ragingBlowCharges = RagingBlow:Charges()
        elseif A.RagingBlow and type(A.RagingBlow.Charges) == "function" then
            ragingBlowCharges = A.RagingBlow:Charges()
        end
        
        if ragingBlowCharges == 2 or player:HasBuff(buffs.brutalFinish) then
            return spell:Cast(player)
        end
end)

Bloodthirst:Callback("thane_simc_vicious", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.hp < 35 and IsPlayerSpell(A.ViciousContempt.ID) and player:HasBuffCount(buffs.bloodcraze) >= 2 then
            return spell:Cast(target)
        end
end)

Execute:Callback("thane_simc_marked3", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
            return spell:Cast(target)
        end
end)

Bloodbath:Callback("thane_simc_bloodcraze", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and player:HasBuffCount(buffs.bloodcraze) >= 1 and player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

RagingBlow:Callback("thane_simc_brutal", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.brutalFinish) and player:HasBuffCount(buffs.slaughteringStrikes) < 5 then
            return spell:Cast(target)
        end
end)

Rampage:Callback("thane_simc_rage", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player.rage >= 120 then
            return spell:Cast(player)
        end
end)

Bloodbath:Callback("thane_simc_bloodcraze4", function(spell)
        if target.totalImmune or target.physImmune then return end
        if (target.ttd > 4000 or target.isDummy) and player:HasBuffCount(buffs.bloodcraze) >= 4 then
            return spell:Cast(player)
        end
end)

CrushingBlow:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Bloodbath:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

RagingBlow:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

Bloodthirst:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

Rampage:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Execute:Callback("thane_simc_sudden_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player:HasBuff(buffs.suddenDeath) then
            return spell:Cast(target)
        end
end)

Onslaught:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

ThunderousRoar:Callback("thane_simc_enrage_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if player:HasBuff(buffs.enrage) then
            return spell:Cast(player)
        end
end)

WreckingThrow:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 30 then return end
        return spell:Cast(target)
end)

ThunderClap:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

Whirlwind:Callback("thane_simc_improved", function(spell)
        if target.totalImmune or target.physImmune then return end
        if IsPlayerSpell(A.ImprovedWhirlwind.ID) then
            return spell:Cast(player)
        end
end)

Slam:Callback("thane_simc_filler", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not IsPlayerSpell(A.ImprovedWhirlwind.ID) then
            return spell:Cast(target)
        end
end)
-----------------------------------------------------------------------
-- PVP Callbacks ------------------------------------------------------
-----------------------------------------------------------------------
--#####################################################################
--#####################################################################

Charge:Callback("pvp", function(spell)
    if not Charge:InRange(target) then return end

    return spell:Cast(target)
end)

Onslaught:Callback("pvp1", function(spell)
    if not Onslaught:InRange(target) then return end
    if player.rage > 70 then return end

    return spell:Cast(target)
end)

ThunderBlast:Callback("pvp", function(spell)
    if not Slam:InRange(target) then return end
    if player:HasBuffCount(435222) < 2 then return end

    return spell:Cast(player)
end)

ThunderBlast:Callback("pvp1", function(spell)
    if not Slam:InRange(target) then return end

    return spell:Cast(player)
end)

ChampionsSpear:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end

    if player:TalentKnown(TitansTorment.id) then
        if Avatar.cd >= A.GetGCD() * 1000 then return end
    end

    return spell:Cast(player)
end)

ChampionsSpear:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end

    if not player:TalentKnown(TitansTorment.id) then
        return spell:Cast(player)
    end
end)

Rampage:Callback("pvp", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:HasBuff(buffs.meatCleaver) then return end

    if player:Buff(buffs.recklessness) then
        return spell:Cast(target)
    end

    if player:BuffRemains(buffs.enrage) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player.rage > 110 and player:TalentKnown(OverwhelmingRage.id) then
        return spell:Cast(target)
    end

    if player.rage > 80 and not player:TalentKnown(OverwhelmingRage.id) then
        return spell:Cast(target)
    end
end)

Rampage:Callback("pvp1", function(spell)
    if not Rampage:InRange(target) then return end

    if player:Buff(buffs.recklessness) then
        return spell:Cast(target)
    end

    if player:BuffRemains(buffs.enrage) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player.rage > 110 and player:TalentKnown(OverwhelmingRage.id) then
        return spell:Cast(target)
    end

    if player.rage > 80 and not player:TalentKnown(OverwhelmingRage.id) then
        return spell:Cast(target)
    end
end)

ThunderousRoar:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.avatar) then return end

    return spell:Cast(player)
end)

Avatar:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if target.distance > 10 then return end
    if not player:Buff(buffs.recklessness) then return end

    if player:TalentKnown(TitansTorment.id) and player:Buff(buffs.enrage) then
        return spell:Cast(player)
    end

    if not player:TalentKnown(TitansTorment.id) then
        if player:Buff(buffs.recklessness) then
            return spell:Cast(player)
        end
        if target.isBoss and target.timeToDie < 20 then
            return spell:Cast(player)
        end
    end
end)

Bladestorm:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if player:HasBuffCount(buffs.imminentDemise) < 2 then return end

    return spell:Cast(player)
end)
BladestormThane:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if player:HasBuffCount(buffs.imminentDemise) < 2 then return end

    return spell:Cast(player)
end)

Bladestorm:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end

    return spell:Cast(player)
end)
BladestormThane:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end

    return spell:Cast(player)
end)

Execute:Callback("pvp1", function(spell)
    if A.Massacre:IsTalentLearned() then return end 
    if not IsPlayerSpell(Execute.id) then return end
    if not Execute:InRange(target) then return end

    return spell:Cast(target)
end)
ExecuteToo:Callback("pvp1", function(spell)
    if not A.Massacre:IsTalentLearned() then return end 
    if not IsPlayerSpell(Execute.id) then return end
    if not Execute:InRange(target) then return end

    return spell:Cast(target)
end)

Ravager:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.avatar) then return end

    return spell:Cast(player)
end)

OdynsFury:Callback("pvp1", function(spell)
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.avatar) then return end

    return spell:Cast(player)
end)

ThunderBlast:Callback("pvp2", function(spell)
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.severeThunder) then return end

    return spell:Cast(player)
end)

Recklessness:Callback("pvp1", function(spell)
    if not shouldBurst() then return end
    if target.distance > 10 then return end

    if not player:TalentKnown(AngerManagement.id) then
        if Avatar.cd < 1000 and player:TalentKnown(TitansTorment.id) then
            return spell:Cast(player)
        end
    end

    if player:TalentKnown(AngerManagement.id) then
        return spell:Cast(player)
    end

    if not player:TalentKnown(TitansTorment.id) then
        return spell:Cast(player)
    end
end)

Onslaught:Callback("pvp2", function(spell)
    if not Onslaught:InRange(target) then return end
    if player:Buff(buffs.enrage) then return end

    return spell:Cast(target)
end)

RagingBlow:Callback("pvp1", function(spell)
    if not RagingBlow:InRange(target) then return end
    if RagingBlow.charges < 2 then return end
    if player:Buff(buffs.enrage) then return end

    return spell:Cast(target)
end)

Rampage:Callback("pvp2", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:Buff(buffs.recklessness) then return end
    if not player:Buff(buffs.enrage) then return end
    if player:Buff(buffs.slaughteringStrikes) then return end

    return spell:Cast(target)
end)

ThunderousRoar:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end

    return spell:Cast(player)
end)

Avatar:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if target.distance > 10 then return end

    if player:TalentKnown(TitansTorment.id) then
        if not player:Buff(buffs.enrage) and not player:TalentKnown(TitanicRage.id) then return end
        if target:Debuff(debuffs.championsMight) or not player:TalentKnown(ChampionsMight.id) then
            return spell:Cast(player)
        end
    end

    if not player:TalentKnown(TitansTorment.id) then
        return spell:Cast(player)
    end
end)

Execute:Callback("pvp2", function(spell)
    if A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end
    if not player:Buff(buffs.suddenDeath) then return end

    return spell:Cast(target)
end)
ExecuteToo:Callback("pvp2", function(spell)
    if not A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end
    if not player:Buff(buffs.suddenDeath) then return end

    return spell:Cast(target)
end)

Rampage:Callback("pvp3", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:Buff(buffs.recklessness) then return end
    if not player:Buff(buffs.enrage) then return end
    if player.rage < 80 then return end

    return spell:Cast(target)
end)

Bladestorm:Callback("pvp3", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd <= 0 then return end

    return spell:Cast(player)
end)
BladestormThane:Callback("pvp3", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd <= 0 then return end

    return spell:Cast(player)
end)

Ravager:Callback("pvp2", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd <= 0 then return end

    return spell:Cast(player)
end)

Rampage:Callback("pvp4", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:Buff(buffs.recklessness) then return end
    if not player:Buff(buffs.enrage) then return end
    if player.rage < 80 then return end

    return spell:Cast(target)
end)

OdynsFury:Callback("pvp2", function(spell)
    if not Slam:InRange(target) then return end
    if target:DebuffRemains(debuffs.odynsFury) >= 1000 then return end
    if not player:Buff(buffs.enrage) and not player:TalentKnown(TitanicRage.id) then return end
    if Avatar.cd <= 0 then return end

    return spell:Cast(player)
end)

Execute:Callback("pvp3", function(spell)
    if A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end

    if target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(AshenJuggernaut.id) then
        if player:BuffRemains(buffs.ashenJuggernaut) <= A.GetGCD() * 1000 then
            if player:Buff(buffs.enrage) then
                return spell:Cast(target)
            end
        end
    end
end)
ExecuteToo:Callback("pvp3", function(spell)
    if not A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end

    if target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(AshenJuggernaut.id) then
        if player:BuffRemains(buffs.ashenJuggernaut) <= A.GetGCD() * 1000 then
            if player:Buff(buffs.enrage) then
                return spell:Cast(target)
            end
        end
    end
end)


Rampage:Callback("pvp5", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:TalentKnown(Bladestorm.id) then return end
    if target:Debuff(debuffs.championsMight) then return end

    return spell:Cast(target)
end)

Bladestorm:Callback("pvp4", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd < 9000 then return end

    return spell:Cast(player)
end)
BladestormThane:Callback("pvp4", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd < 9000 then return end

    return spell:Cast(player)
end)

Ravager:Callback("pvp3", function(spell)
    if not shouldBurst() then return end
    if not Slam:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if Avatar.cd < 9000 then return end

    return spell:Cast(player)
end)

Onslaught:Callback("pvp3", function(spell)
    if not Onslaught:InRange(target) then return end
    if not player:TalentKnown(Tenderize.id) then return end
    if not player:Buff(buffs.brutalFinish) then return end

    return spell:Cast(target)
end)

RagingBlow:Callback("pvp2", function(spell)
    if not RagingBlow:InRange(target) then return end
    if RagingBlow.charges < 2 then return end

    return spell:Cast(target)
end)

Rampage:Callback("pvp6", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:TalentKnown(AngerManagement.id) then return end

    return spell:Cast(target)
end)

CrushingBlow:Callback("pvp", function(spell)
    if not CrushingBlow:InRange(target) then return end

    return spell:Cast(target)
end)

Onslaught:Callback("pvp4", function(spell)
    if not Onslaught:InRange(target) then return end
    if not player:TalentKnown(Tenderize.id) then return end

    return spell:Cast(target)
end)

Bloodbath:Callback("pvp", function(spell)
    if player.rage >= 100 then return end

    if target.hp < 35 and player:TalentKnown(ViciousContempt.id) then
        return spell:Cast(player)
    end

    if player.rage < 100 then
        return spell:Cast(player)
    end
end)

RagingBlow:Callback("pvp3", function(spell)
    if not RagingBlow:InRange(target) then return end
    if player.rage >= 100 then return end
    if player:Buff(buffs.opportunist) then return end

    return spell:Cast(target)
end)

Rampage:Callback("pvp7", function(spell)
    if not Rampage:InRange(target) then return end
    if not player:TalentKnown(RecklessAbandon.id) then return end

    return spell:Cast(target)
end)

Execute:Callback("pvp4", function(spell)
    if A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if not target:Debuff(debuffs.markedForExecution) then return end

    return spell:Cast(target)
end)
ExecuteToo:Callback("pvp4", function(spell)
    if not A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end
    if not player:Buff(buffs.enrage) then return end
    if not target:Debuff(debuffs.markedForExecution) then return end

    return spell:Cast(target)
end)

Bloodthirst:Callback("pvp1", function(spell)
    
    return spell:Cast(player)
end)

RagingBlow:Callback("pvp4", function(spell)
    if not RagingBlow:InRange(target) then return end

    return spell:Cast(target)
end)

Onslaught:Callback("pvp5", function(spell)
    if not Onslaught:InRange(target) then return end

    return spell:Cast(target)
end)

Execute:Callback("pvp5", function(spell)
    if A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end

    return spell:Cast(target)
end)
ExecuteToo:Callback("pvp5", function(spell)
    if not A.Massacre:IsTalentLearned() then return end
    if not Execute:InRange(target) then return end

    return spell:Cast(target)
end)

Bloodthirst:Callback("pvp2", function(spell)
    return spell:Cast(player)
end)

Whirlwind:Callback("pvp", function(spell)
    if not player:TalentKnown(MeatCleaver.id) then return end

    return spell:Cast(player)
end)

Slam:Callback("pvp", function(spell)
    return spell:Cast(player)
end)

ThunderClap:Callback("pvp", function(spell)
    -- Only cast if we don't have Meat Cleaver buff
    if player:HasBuff(buffs.meatCleaver) then return end

    -- Only cast if 2+ enemies in melee range
    if enemiesInMelee() < 2 then return end

    return spell:Cast(player)
end)

Bloodthirst:Callback("pvp3", function(spell)
    -- Cast if we have Burst of Power buff OR if talented into Lightning Strikes
    if not player:Buff(buffs.burstofPower) and not IsPlayerSpell(A.LightningStrikes.ID) then return end

    return spell:Cast(player)
end)

local function thane()
    Recklessness("thane_simc")
    Avatar("thane_simc")
    Ravager("thane_simc")
    ThunderousRoar("thane_simc_aoe")
    ChampionsSpear("thane_simc_might")
    ThunderClap("thane_simc_cleaver")
    ThunderBlast("thane_simc_enrage")
    Execute("thane_simc_ashen")
    Rampage("thane_simc_enrage_low")
    ThunderBlast("thane_simc_enrage_any")
    Execute("thane_simc_sudden2")
    Execute("thane_simc_marked")
    ThunderClap("thane_simc_cleaver2")
    Onslaught("thane_simc_tenderize")
    Rampage("thane_simc_slaughter")
    CrushingBlow("thane_simc_charges")
    Bloodthirst("thane_simc_vicious")
    Execute("thane_simc_marked3")
    Bloodbath("thane_simc_bloodcraze")
    RagingBlow("thane_simc_brutal")
    Rampage("thane_simc_rage")
    Bloodbath("thane_simc_bloodcraze4")
    CrushingBlow("thane_simc_filler")
    Bloodbath("thane_simc_filler")
    RagingBlow("thane_simc_filler")
    Bloodthirst("thane_simc_filler")
    Rampage("thane_simc_filler")
    Execute("thane_simc_sudden_filler")
    Onslaught("thane_simc_filler")
    
    ThunderousRoar("thane_simc_enrage_filler")
    WreckingThrow("thane_simc_filler")
    ThunderClap("thane_simc_filler")
    Whirlwind("thane_simc_improved")
    Slam("thane_simc_filler")
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

local function PVPRotation()
    if InPvP() then 

        Charge("pvp")
        Onslaught("pvp1")
        ChampionsSpear("pvp1")
        ChampionsSpear("pvp2")
        ThunderousRoar("pvp1")
        Avatar("pvp1")
        Avatar("pvp2")
        Recklessness("pvp1")
        Rampage("pvp")
        Bladestorm("pvp1")
        BladestormThane("pvp1")
        Bladestorm("pvp2")
        BladestormThane("pvp2")
        ThunderClap("pvp")
        ThunderBlast("pvp")
        Rampage("pvp1")
        ThunderBlast("pvp1")
        Execute("pvp1")
        ExecuteToo("pvp1")
        Bloodthirst("pvp3")
        Ravager("pvp1")
        OdynsFury("pvp1")
        ThunderBlast("pvp2")
        Recklessness("pvp1")
        Onslaught("pvp2")
        RagingBlow("pvp1")
        Rampage("pvp2")
        ThunderousRoar("pvp2")
        Avatar("pvp2")
        Execute("pvp2")
        ExecuteToo("pvp2")
        Rampage("pvp3")
        Bladestorm("pvp3")
        BladestormThane("pvp3")
        Ravager("pvp2")
        Rampage("pvp4")
        OdynsFury("pvp2")
        Execute("pvp3")
        ExecuteToo("pvp3")
        Rampage("pvp5")
        Bladestorm("pvp4")
        BladestormThane("pvp4")
        Ravager("pvp3")
        Onslaught("pvp3")
        RagingBlow("pvp2")
        Rampage("pvp6")
        CrushingBlow("pvp")
        Onslaught("pvp4")
        Bloodbath("pvp")
        RagingBlow("pvp3")
        Rampage("pvp7")
        Execute("pvp4")
        ExecuteToo("pvp4")
        Bloodthirst("pvp1")
        RagingBlow("pvp4")
        Onslaught("pvp5")
        Execute("pvp5")
        ExecuteToo("pvp5")
        Bloodthirst("pvp2")
        Whirlwind("pvp")
        Slam("pvp")

    end
end

--################################################################################################################################################################################################################

A[1] = function(icon)
    --AntiFakeCC - Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
    if A.AntiFakeCC:GetCooldown() == 0 then return A.AntiFakeCC:Show(icon) end
end

A[2] = function(icon)
    local castLeft, _, _, _, notKickAble = Unit("target"):IsCastingRemains()
    if castLeft == 0 then return end
    
    --AntiFakeKick --Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
    if A.AntiFakeKick:GetCooldown() == 0 and not notKickAble then return A.AntiFakeKick:Show(icon) end
end

--################################################################################################################################################################################################################

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()
    mouseover = MakUnit:new("mouseover")
    local awareAlert = A.GetToggle(2, "makAware")
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Enemies in Range: ", activeEnemies())
        MakPrint(2, "Target Disorient DR: ", target.disorientDr)
        MakPrint(3, "Target Total Immune: ", target.totalImmune)
        MakPrint(4, "Target CC: ", target.cc)
        MakPrint(5, "Target CC Remains: ", target:CCRemains())
        MakPrint(6, "Enemy Healer Exists: ", enemyHealer.exists)
        MakPrint(7, "PVP Kick arena1 ", arena1.pvpKick)
        MakPrint(8, "PVP Kick arena2 ", arena2.pvpKick)
        MakPrint(9, "PVP Kick arena3 ", arena3.pvpKick)
    end
    if Action.Zone ~= "arena" then makInterrupt(interrupts) end
    baseStuff()
    if target.exists and target.hp > 0 and target.canAttack and Slam:InRange(target) and not player:Debuff(410201) then
        
        baseStuffCombat()
        
        if shouldBurst() then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)
            
            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.recklessness)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
            racials()
        end
        
        if InPvP() then 
            PVPRotation()
        end
        
        -- Season 3 Performance Optimization: Use cached hero talent detection
        if NotInPvP() and gameState.shouldAoE then
            if gameState.isSlayer then
                slayer()
            elseif gameState.isMountainThane then
                thane()
            else
                slayer() -- Default to Slayer if no hero talent detected
            end
        else
            if gameState.isSlayer then
                slayer()
            elseif gameState.isMountainThane then
                thane()
            else
                slayer() -- Default to Slayer if no hero talent detected
            end
        end
    end
    return FrameworkEnd()
end

--################################################################################################################################################################################################################
--## ARENA ENEMY STUFFS ##--
--################################################################################################################################################################################################################

Pummel:Callback("arena", function(spell, enemy)
        if enemy:IsKickImmune() then return end
        if target.hp < 20 then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end
        
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_healer", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.ccImmune then return end
        if enemy.distance > 20 then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if enemy:IsTarget() then return end
        if target.hp > 50 then return end
        if enemy.stunDr < 0.5 then return end
        if enemy:CCRemains() > 2000 then return end
        if aware then Aware:displayMessage("SB - Enemy Healer - KT Low", "Blue", 1) end
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_kill", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.ccImmune then return end
        if not enemy:IsTarget() then return end
        if enemy.distance > 20 then return end
        if enemy.stunDr < 0.5 then return end
        if enemyHealer.exists and enemy:IsUnit(enemyHealer) then return end
        if enemyHealer:CCRemains() < 2000 then return end
        if enemy.hp > 50 then return end
        if aware then Aware:displayMessage("SB - KT - Healer CCed", "Red", 1) end
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_nohealer_kill", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.ccImmune then return end
        if enemyHealer.exists then return end
        if enemy.distance > 20 then return end
        if not enemy:IsTarget() then return end
        if enemy.stunDr < 0.5 then return end
        if enemy.hp > 50 then return end
        if aware then Aware:displayMessage("SB - KT - No Enemy Healer Exists", "Red", 1) end
        return spell:Cast(enemy)
end)

Charge:Callback("charge_fear", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy:IsTarget() then return end
        if enemy.distance < 5 then return end
        if target.hp > 60 then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if IntimidatingShout:Cooldown() > 700 then return end
        if enemy.totalImmune then return end
        if enemy.ccImmune then return end
        if enemy.disorientDr < 0.5 then return end
        if enemyHealer:CCRemains() > 1500 then return end
        if aware then Aware:displayMessage("Charge - Enemy Healer - To Fear", "Blue", 1) end
        return spell:Cast(enemy)
end)

IntimidatingShout:Callback("arena", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.ccImmune then return end
        --if not spell:InRange(enemy) then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if enemy:IsTarget() then return end
        if target.hp > 60 then return end
        if target.totalImmune then return end
        if enemy.disorientDr < 0.5 then return end
        if enemyHealer:CCRemains() > 1500 then return end
        if aware then Aware:displayMessage("Fear - Enemy Healer - KT Low", "Blue", 1) end
        return spell:Cast(enemy)
end)

Disarm:Callback("arena", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.ccRemains > 700 then return end
        if enemy.distance > 10 then return end
        if enemy:Buff(446035) then return end
        if enemy:Buff(227847) then return end
        if not enemy:HasBuffFromFor(MakLists.Disarm, 500) then return end
        if aware then Aware:displayMessage("Disarm - Enemy - Bursting", "White", 1) end
        return spell:Cast(enemy)
end)

--################################################################################################################################################################################################################
--## ARENA PARTY STUFFS ##--
--################################################################################################################################################################################################################

Intervene:Callback("party", function(spell, friendly)
        if friendly:IsUnit(player) then return end
        if friendly.hp > 40 then return end
        if player.hp < 40 then return end
        if friendly.hp > target.hp then return end
        if target.hp < 30 then return end
        
        return spell:Cast(friendly)
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    if player:Debuff(410201) then return end
    
    Pummel("arena", enemy)
    StormBolt("arena_healer", enemy)
    StormBolt("arena_kill", enemy)
    StormBolt("arena_nohealer_kill", enemy)
    Charge("charge_fear", enemy)
    IntimidatingShout("arena", enemy)
    Disarm("arena", enemy)
end

local enemyRotationTest = function(enemy)
    if not enemy.exists then return end
    
    Pummel("test", enemy)   
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    
    Intervene("party", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    if Action.Zone == "arena" then
        enemyRotation(arena1)
        partyRotation(party1)
    end
    --enemyRotationTest(target)
    
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
        --print("were in a8 inside arena")
        enemyRotation(arena3)
        partyRotation(party3)
    end
    
    return FrameworkEnd()
end

A[9] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        enemyRotation(MakUnit:new("arena4"))
        partyRotation(MakUnit:new("party4"))
    end
    
    return FrameworkEnd()
end

A[10] = function(icon)
    RegisterIcon(icon)
    if Action.Zone == "arena" then
        enemyRotation(MakUnit:new("arena5"))
        partyRotation(player)
    end
    return FrameworkEnd()
end