-- APL UPDATE 090625 - Optimized for TWW Season 3 (Patch 11.2) 446035

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 71 then return end

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
local ConstSpells      = MakuluFramework.constantSpells
local PVE              = MakuluFramework.PVE
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local MultiUnits       = Action.MultiUnits
local GetToggle           = Action.GetToggle
local Unit             = Action.Unit
local Debounce         = MakuluFramework.debounceSpell
local Trinket          = MakuluFramework.Trinket

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
    
    AngerManagement       = { ID = 152278 },
    AntiFakeCC            = { Type = "SpellSingleColor", ID = 107570,      Hidden = true,        Color = "YELLOW"    , Desc = "[1] AntiFakeCC",      QueueForbidden = true    },
    AntiFakeKick          = { Type = "SpellSingleColor", ID = 6552,  Hidden = true,        Color = "GREEN"        , Desc = "[2] AntiFakeKick",    QueueForbidden = true    },
    Avatar                = { ID = 107574 },
    BattleShout           = { ID = 6673 },
    BattleStance          = { ID = 386164 },
    Battlelord            = { ID = 386630, Hidden = true },
    BerserkerRage         = { ID = 18499, MAKULU_INFO = { offGcd = true } },
    BerserkerRageToo      = { ID = 384100 },
    BitterImmunity        = { ID = 383762 },
    Bladestorm            = { ID = 227847, Texture = 273409, MAKULU_INFO = { damageType = "physical" } },
    Bladestormtoo         = { ID = 446035, Texture = 273409, MAKULU_INFO = { damageType = "physical" } },
    Bloodletting          = { ID = 383154, Hidden = true },
    ChallengingShout      = { ID = 1161 },
    ChampionsSpear        = { ID = 376079, FixedTexture = 3565453 },
    Charge                = { ID = 100, },
    
    Cleave                = { ID = 845, MAKULU_INFO = { damageType = "physical" } },
    CollateralDamage      = { ID = 334779 },
    
    ColossusSmash         = { ID = 167105, MAKULU_INFO = { damageType = "physical" } },
    DefensiveStance       = { ID = 386208 },
    Demolish              = { ID = 436358, MAKULU_INFO = { damageType = "physical" } },
    DemoralizingShout     = { ID = 1160 },
    DiebytheSword         = { ID = 118038 },
    Disarm                = { ID = 236077, MAKULU_INFO = { damageType = "physical" } },
    DoubleTime            = { ID = 103827 },
    Dreadnaught           = { ID = 262150, MAKULU_INFO = { damageType = "physical" } },
    Execute               = { ID = 5308, MAKULU_INFO = { damageType = "physical" } },
    ExecuteToo            = { ID = 281000, MAKULU_INFO = { damageType = "physical" } },
    ExecuteTooo           = { ID = 163201, MAKULU_INFO = { damageType = "physical" } },
    ExecutionersPrecision = { ID = 386634 },
    FervorofBattle        = { ID = 202316 },
    FierceFollowthrough   = { ID = 444773, Hidden = true },
    Hamstring             = { ID = 1715, MAKULU_INFO = { damageType = "physical" } },
    HeroicLeap            = { ID = 6544 },
    HeroicThrow           = { ID = 57755, MAKULU_INFO = { damageType = "physical" } },
    IgnorePain            = { ID = 190456 },
    ImpendingVictory      = { ID = 202168 },
    ImprovedHeroicThrow   = { ID = 386034, MAKULU_INFO = { damageType = "physical" } },
    ImprovedWhirlwind     = { ID = 12950 },
    Intervene             = { ID = 3411 },
    IntimidatingShout     = { ID = 5246, Texture = 355, MAKULU_INFO = { damageType = "physical" } },
    IntimidatingShoutPvE  = { ID = 5246, Hidden = true, MAKULU_INFO = { damageType = "physical" } },
    Juggernaut            = { ID = 383292, Hidden = true },
    LastStand             = { ID = 12975 },
    Massacre              = { ID = 281001 },
    MercilessBonegrinder  = { ID = 383317, MAKULU_INFO = { damageType = "physical" } },
    MortalStrike          = { ID = 12294, MAKULU_INFO = { damageType = "physical" } },
    Opportunist           = { ID = 444774, Hidden = true },
    Overpower             = { ID = 7384, MAKULU_INFO = { damageType = "physical" } },
    Pummel                = { ID = 6552, MAKULU_INFO = { damageType = "physical" } },
    RallyingCry           = { ID = 97462 },
    Ravager               = { ID = 228920, Texture = 273409, MAKULU_INFO = { damageType = "physical" } },
    Rend                  = { ID = 772, MAKULU_INFO = { damageType = "physical" } },
    SecondWind            = { ID = 29838 },
    SharpenBlade          = { ID = 198817, MAKULU_INFO = { damageType = "physical" } },
    SharpenedBlades       = { ID = 383341, MAKULU_INFO = { damageType = "physical" } },
    ShatteringThrow       = { ID = 64382, MAKULU_INFO = { damageType = "physical" } },
    Shockwave             = { ID = 46968, MAKULU_INFO = { damageType = "physical" } },
    Skullsplitter         = { ID = 260643, MAKULU_INFO = { damageType = "physical" } },
    Slam                  = { ID = 1464, MAKULU_INFO = { damageType = "physical" } },
    SlayersDominance      = { ID = 444767, Hidden = true },
    SpellReflection       = { Type = "Spell", ID = 23920, MAKULU_INFO = { offGcd = true } },
    StormBolt             = { ID = 107570 },
    StrengthofArms        = { ID = 400803, Hidden = true },
    SuddenDeath           = { ID = 29725, MAKULU_INFO = { damageType = "physical" } },
    SuddenDeathBuff       = { ID = 52437 },
    SweepingStrikes       = { ID = 260708, MAKULU_INFO = { damageType = "physical" } },
    ThunderClap           = { ID = 6343, MAKULU_INFO = { damageType = "physical" } },
    ThunderousRoar        = { ID = 384318, MAKULU_INFO = { damageType = "physical" } },
    Unhinged              = { ID = 386628, MAKULU_INFO = { damageType = "physical" } },
    VictoryRush           = { ID = 34428, MAKULU_INFO = { damageType = "physical" } },
    Warbreaker            = { ID = 262161, MAKULU_INFO = { damageType = "physical" } },
    Whirlwind             = { ID = 1680, MAKULU_INFO = { damageType = "physical" } },
    
    -- Missing spells from original APL
    WreckingThrow = { ID = 384110, MAKULU_INFO = { damageType = "physical" } },
    
    -- Power Infusion external buff
    PowerInfusion = { ID = 10060, Hidden = true },
    
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

Action[ACTION_CONST_WARRIOR_ARMS] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local function num(val)
    if val then return 1 else return 0 end
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

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    minTalentedCdRemains = nil,
    cursorCheck = false,
    shouldAoE = false,
    should2T = false,
    executePhase = false,
    stPlanning = false,
    addsRemain = false,
}

local buffs = {
    avatar = 107574,
    battleShout = 6673,
    defensiveStance = 386208,
    battleStance = 386164,
    collateralDamage = 334783,
    mercilessBonegrinder = 383316,
    sweepingStrikes = 260708,
    suddenDeath = 52437,
    opportunist = 456120,
    juggernaut = 383290,
    recklessness = 1719,
    ravager = 228920,
    colossalMight = 440989,
    martialProwess = 316440,
    criticalConclusion = 1239144,
}

local debuffs = {
    championsMight = 376080,
    gushingWound = 385042,
    colossusSmash = 208086,
    executionersPrecision = 386633,
    strikeVulnerabilities = 394173,
    rend = 388539,
    markedForExecution = 445584,
    deepWound = 262115,
    lethalBlows = 455485,
    mortalWounds = 115804,
}


--Player:AddTier("Tier31", { 217236, 217237, 217238, 217239, 217240, })
--local T31has2P = Player:HasTier("Tier31", 2)
--local T31has4P = Player:HasTier("Tier31", 4)

local cacheContext     = MakuluFramework.Cache

local pveSpellReflect = {
    -- SEASON 1 TWW
    -- Raid
    436996, -- Princess
    436787, -- Princess
    437839, -- Princess
    438200, -- Court
    441772, -- Court
    439865, -- Queen
    451600, -- Queen
    -- Dungeon
    432031, -- Ara-Kara - Ki'katal
    436322, -- Ara-Kara
    434786, -- Ara-Kara
    436322, -- Ara-Kara
    -- City
    434722, 440468, 439646, 446718, 439341,
    -- Dawn
    428086, 451117,
    -- Grim
    449444, 447966, 450102, 450087,
    -- NW
    320170, 322493, 320788,
    -- Mist
    323057,
    --Vault
    428161,
    
    --SEASON 2 TWW
    --Liberation of Undermine
    1219386, -- Scrap Rockets
    460847, -- Electric Blast
    --Cinderbrew
    436640, -- Burning Ricochet
    437733, -- Boiling Flames
    --Darkflame
    443694, -- Crude Weapons
    422700, -- Extinguishing Gust
    421638, -- Wicklighter Barrage
    469620, -- Creeping Shadow
    428563, -- Flame Bolt
    423479, -- Wicklighter Bolt
    --Mechagon Workshop
    294860, -- Blossom Blast
    291878, -- Pulse Blast
    294195, -- Arcing Zap
    293827, -- Giga-Wallop
    1215415, -- Sticky Sludge
    -- Motherlode
    260323, -- Alpha Cannon
    263628, -- Charged Shield
    280604, -- Iced Spritzer
    262270, -- Caustic Compound
    1215934, -- Rock Lance
    268846, -- Echo Blade
    -- Operation Floodgate
    473126, -- Mudslide
    469811, -- Backwash
    465871, -- Blood Blast
    465666, -- Sparkslam
    1214468, -- Trickshot
    474388, -- Flamethrower
    465595, -- Lightning Bolt
    462776, -- Surveying Beam
    -- Priory pf the Sacred Flame
    424420, -- Cinderblast
    424421, -- Fireball
    423015, -- Castigator's Shield
    423536, -- Holy Smite
    427357, -- Holy Smite
    427469, -- Fireball
    427900, -- Molten Pool
    427951, -- Seal of Flame
    -- Theater of pain
    1217138, -- Necrotic Bolt
    1216475, -- Necrotic Bolt
    319669, -- Spectral Reach
    1222949, -- Well of Darkness
    323608, -- Dark Devastation
    324589, -- Death Bolt
    341969, -- Withering Discharge
    330697, -- Decaying Strike
    330784, -- Necrotic Bolt
    333299, -- Curse of Desolation
    330875, -- Spirit Frost
    330810, -- Bind Soul
    -- The Rookery
    430805, -- Arcing Void
    430186, -- Seeping Corruption
    430238, -- Void Bolt
    430109, -- Lightning Bolt
    467907, -- Festering Void
    
    --SEASON 3 TWW
    -- Manaforge Omega Raid
    -- TODO: Add Manaforge Omega spell IDs for spell reflect when available
    
    -- Eco-Dome Al'dani
    -- TODO: Add Eco-Dome Al'dani spell IDs for spell reflect when available
    
    -- Halls of Atonement (Returning)
    -- TODO: Add Halls of Atonement spell IDs for spell reflect when available
    
    -- Tazavesh: Streets of Wonder (Returning)
    -- TODO: Add Tazavesh Streets of Wonder spell IDs for spell reflect when available
    
    -- Tazavesh: So'leah's Gambit (Returning)
    -- TODO: Add Tazavesh So'leah's Gambit spell IDs for spell reflect when available
}

local berserkerRageBreaks = {
    -- Fears
    [5782] = true,    -- Fear (Warlock)
    [118699] = true,  -- Fear Horrify (Warlock)
    [130616] = true,  -- Fear variant (Warlock)
    [5484] = true,    -- Howl of Terror (Warlock)
    [8122] = true,    -- Psychic Scream (Priest)
    [64044] = true,   -- Psychic Horror (Priest)
    [5246] = true,    -- Intimidating Shout (Warrior)
    [316593] = true,  -- Intimidating Shout variant (Warrior)
    [316595] = true,  -- Intimidating Shout variant (Warrior)
    [207684] = true,  -- Sigil of Misery (Demon Hunter)
    [360806] = true,  -- Sleep Walk (Evoker)

    -- Incapacitates
    [99] = true,      -- Incapacitating Roar (Druid)
    [3355] = true,    -- Freezing Trap (Hunter)
    [203337] = true,  -- Freezing Trap variant (Hunter)
    [19386] = true,   -- Wyvern Sting (Hunter)
    [217832] = true,  -- Imprison (Demon Hunter)
    [20066] = true,   -- Repentance (Paladin)
    [115078] = true,  -- Paralysis (Monk)
    [107079] = true,  -- Quaking Palm (Pandaren)
    [2637] = true,    -- Hibernate (Druid)
    [9484] = true,    -- Shackle Undead (Priest)
    [6358] = true,    -- Seduction (Warlock Succubus)
    [261589] = true,  -- Seduction Grimoire (Warlock)
}

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            
            for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
                local enemy = MakUnit:new(enemyGUID) 
                if Slam:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                    total = total + 1
                end 
            end  
            
            return total
    end)
end

local function activeEnemies()
    return enemiesInMelee()
end


-- -- Variables system (equivalent to original APL variables action list)
local function updateVariables()
    local activeEnemyCount = activeEnemies()
    
    -- st_planning: active_enemies=1&(raid_event.adds.in>15|!raid_event.adds.exists)
    gameState.stPlanning = activeEnemyCount == 1
    
    -- adds_remain: active_enemies>=2&(!raid_event.adds.exists|raid_event.adds.exists&raid_event.adds.remains>5)
    gameState.addsRemain = activeEnemyCount >= 2
    
    -- execute_phase: (talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
    gameState.executePhase = target.hp <= 20 or (target.hp <= 35 and A.Massacre:IsTalentLearned())
end

local interrupts = {
    { spell = Pummel },
    { spell = StormBolt, isCC = true },
    { spell = Shockwave, isCC = true, aoe = true, distance = 5 },
    { spell = IntimidatingShoutPvE, isCC = true, aoe = true, distance = 2 }
}

local function shouldBurst()
    if A.BurstIsON("target") then
        --if A.Zone ~= "arena" then
        --    local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --    for enemy in pairs(activeEnemies) do
        --        if ActionUnit(enemy):Health() > (A.Slam:GetSpellDescription()[1] * 10) or target.isDummy or target.isBoss then
        --            return true
        --        end
        --    end
        --else
        return true
    end
    --end
    --return false
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

local function wantSpellReflect()
    return constCell:GetOrSet("wantSpellReflect", function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for unitToCheck in pairs(activeEnemies) do
                local munit = MakUnit:new(unitToCheck)
                if munit and munit.exists and munit:IsCasting() then
                    local currentCast = munit:CastInfo()
                    if currentCast and currentCast.spellId and currentCast.percent > 10 and currentCast.percent < 100 and tContains(pveSpellReflect, currentCast.spellId) then
                        Aware:displayMessage("Need Spell Reflect", "Green", 1)
                        return true
                    end
                end
            end
            return false
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
                if HeroicThrow:InRange(enemy) and orb then
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
    
    if Slam:InRange(target) and target.exists then return false end
    
    if gameState.activeEnemies > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local function updateGameState()
    gameState.shouldAoE = activeEnemies() >= 3 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gameState.should2T = activeEnemies() >= 2 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gameState.activeEnemies = activeEnemies()
    gameState.orbsActive = orbsActive()
    
    -- Update variables system (equivalent to original APL variables action list)
    updateVariables()
    
end

--###########################################################################################################################################################################################
--                                                                CALLBACKS
--###########################################################################################################################################################################################

--################################################################ STANCES ##################################################################################################################
BattleStance:Callback(function(spell)
        if GetToggle(2, "StanceMode") == "1" then
            if player.hp > 50 and not player:Buff(buffs.battleStance) then
                return spell:Cast(player)
            end
        end
        
        if GetToggle(2, "StanceMode") == "2" and not player:Buff(buffs.battleStance) then
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

local function stances()
    BattleStance()
    DefensiveStance()
end

--############################################################# BASE STUFF #################################################################################################################

DiebytheSword:Callback(function(spell)
        if not player.inCombat then return end
        if player.hp > GetToggle(2, "DiebytheSwordSlider") then return end
        
        return spell:Cast(player)
end)


local arenaPrepStartTime = 0
BattleShout:Callback(function(spell)
    if player.inCombat then return end
    if player:Buff(buffs.battleShout) then return end

    -- Track when Arena Preparation buff is gained
    local hasArenaPrep = player:Buff(32727)
    if hasArenaPrep then
        if arenaPrepStartTime == 0 then
            arenaPrepStartTime = GetTime()
        end
        -- Wait 5 seconds after gaining Arena Preparation
        if (GetTime() - arenaPrepStartTime) < 5 then return end
    else
        arenaPrepStartTime = 0
    end

    return spell:Cast(player)
end)

Charge:Callback(function(spell)
        if player.inCombat then return end
        if Action.Zone == "arena" then return end
        if Unit("target"):GetRange() < 8 then return end
        if Unit("target"):GetRange() > 25 then return end
        
        return spell:Cast(target)
end)

VictoryRush:Callback("heal", function(spell)
        if IsPlayerSpell(A.ImpendingVictory.ID) then return end
        if player.hp > GetToggle(2, "VictoryRushSlider") then return end
        
        return spell:Cast(target)
end)

IgnorePain:Callback(function(spell)
        if not player.inCombat then return end
        if player.hp > GetToggle(2, "IgnorePainSlider") then return end
        
        return spell:Cast(player)
end)

ImpendingVictory:Callback("heal", function(spell)
        if not player.inCombat then return end
        if not IsPlayerSpell(A.ImpendingVictory.ID) then return end
        if player.hp > GetToggle(2, "VictoryRushSlider") then return end
        
        return spell:Cast(target)
end)

BitterImmunity:Callback("heal", function(spell)
        if not player.inCombat then return end
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
        
        return Debounce("berRage", 300, 2000, spell)
end)

SpellReflection:Callback(function(spell)
        if wantSpellReflect() then
            return spell:Cast()
        end
end)

SpellReflection:Callback("pvp-arena", function(spell)
        if Action.Zone ~= "arena" then return end
        if (arena1.exists and arena1:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena1.distance > 5 or Pummel:Cooldown() > 1000)) or (arena2.exists and arena2:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena2.distance > 5 or Pummel:Cooldown() > 1000)) or (arena3.exists and arena3:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena1.distance > 5 or Pummel:Cooldown() > 1000)) then
            return spell:Cast() -- No target required for Spell Reflection
        end
end)

ShatteringThrow:Callback(function(spell)
        if target:HasBuffFromFor(MakLists.shatteringBuffs, 500) then 
            return spell:Cast(target)
        end
end)

SharpenBlade:Callback(function(spell)
        if not IsPlayerSpell(A.SharpenBlade.ID) then return end
        if Action.Zone ~= "arena" and Action.Zone ~= "pvp" then return end
        if target.hp > 70 then return end
        
        return spell:Cast(target)
end)

local function baseStuff()
    DiebytheSword()
    BattleShout()
    Charge()
    VictoryRush("heal")
    IgnorePain()
    ImpendingVictory("heal")
    BitterImmunity("heal")
    RallyingCry()
    RallyingCry("party")
    BerserkerRage()
    SpellReflection()
    ShatteringThrow()
    SharpenBlade()
end

--###############################################################################  RACIALS        ###########################################################################################
--default_->add_action( "arcane_torrent,if=cooldown.mortal_strike.remains>1.5&rage<50" );
ArcaneTorrent:Callback(function(spell)
        if shouldBurst() and MortalStrike:Cooldown() > 1500 and player.rage < 50 then
            return spell:Cast(player)
        end
end)

--default_->add_action( "lights_judgment,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains" );
LightsJudgment:Callback(function(spell)
        if shouldBurst() and not target:HasDeBuff(debuffs.colossusSmash) and MortalStrike:Cooldown() > 0 then
            
            return spell:Cast(target)
        end
end)

--default_->add_action( "bag_of_tricks,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains" );
BagOfTricks:Callback(function(spell)
        if shouldBurst() and not target:HasDeBuff(debuffs.colossusSmash) and MortalStrike:Cooldown() > 0 then
            return spell:Cast(target)
        end
end)

--default_->add_action( "berserking,if=target.time_to_die>180&buff.avatar.up|target.time_to_die<180&variable.execute_phase&buff.avatar.up|target.time_to_die<20" );
Berserking:Callback(function(spell)
        if not shouldBurst() then return end
        if player:HasBuff(buffs.avatar) then
            return spell:Cast(player)
        end
        
        if gameState.executePhase or player:HasBuff(buffs.avatar) then
            return spell:Cast(player)
        end
end)

--default_->add_action( "blood_fury,if=debuff.colossus_smash.up" );
BloodFury:Callback(function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if not target:HasDeBuff(debuffs.colossusSmash) then return end
        
        return spell:Cast(player)    
end)

--default_->add_action( "fireblood,if=debuff.colossus_smash.up" );
Fireblood:Callback(function(spell)
        if target.totalImmune or target.physImmune then return end
        if not shouldBurst() then return end
        if not target:HasDeBuff(debuffs.colossusSmash) then return end
        
        return spell:Cast(player)
end)

--default_->add_action( "ancestral_call,if=debuff.colossus_smash.up" );
AncestralCall:Callback(function(spell)
        if not shouldBurst() then return end
        if not target:HasDeBuff(debuffs.colossusSmash) then return end
        
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

--###############################################################################  MISSING SPELLS FROM ORIGINAL APL  #########################################################################


-- Wrecking Throw callbacks for all rotations where it appears in original APL
WreckingThrow:Callback("colossus_st", function(spell)
        return spell:Cast(target)
end)

WreckingThrow:Callback("colossus_execute", function(spell)
        return spell:Cast(target)
end)

WreckingThrow:Callback("colossus_sweep", function(spell)
        if not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

WreckingThrow:Callback("slayer_st", function(spell)
        return spell:Cast(target)
end)

WreckingThrow:Callback("slayer_execute", function(spell)
        return spell:Cast(target)
end)

WreckingThrow:Callback("slayer_sweep", function(spell)
        if not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

WreckingThrow:Callback("slayer_aoe", function(spell)
        return spell:Cast(target)
end)

-- Power Infusion callback (external buff coordination)
PowerInfusion:Callback(function(spell)
        if not shouldBurst() then return end
        if target:HasDeBuff(debuffs.colossusSmash) then
            return spell:Cast(player)
        end
        if gameState.executePhase and player:HasBuff(buffs.avatar) then
            return spell:Cast(player)
        end
end)


-- Potion usage (equivalent to original APL potion logic)
-- local function potionUsage()
--     if not shouldBurst() then return end

--     -- potion,if=gcd.remains=0&debuff.colossus_smash.remains>8|target.time_to_die<25
--     if target:DebuffRemains(debuffs.colossusSmash) > 8000 then
--         -- Use appropriate potion based on spec/situation
--         if A.TemperedPotion3:IsReady() then
--             return A.TemperedPotion3:Cast(player)
--         elseif A.TemperedPotion2:IsReady() then
--             return A.TemperedPotion2:Cast(player)
--         elseif A.TemperedPotion1:IsReady() then
--             return A.TemperedPotion1:Cast(player)
--         end
--     end
-- end

--###############################################################################  COLOSSUS ST       ##################################################################################

--colossus_st->add_action( "rend,if=dot.rend.remains<=gcd" );
Rend:Callback("colossus_st", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() then
            return spell:Cast(target)
        end
end)

--colossus_st->add_action( "thunderous_roar" );
ThunderousRoar:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        
        return spell:Cast(player)
end)

--colossus_st->add_action( "ravager,if=cooldown.colossus_smash.remains<=gcd&(cooldown.avatar.remains>14|cooldown.avatar.remains<2)" );
Ravager:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        local avatarCd = Avatar:Cooldown()
        if (ColossusSmash:Cooldown() <= MakGcd() or Warbreaker:Cooldown() <= MakGcd()) and (avatarCd > 14000 or avatarCd < 2000) then
            return spell:Cast(player)
        end
end)

--colossus_st->add_action( "avatar,if=raid_event.adds.in>15" );
Avatar:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        -- Simplified raid_event logic - use in single target scenarios
        if gameState.stPlanning then
            return spell:Cast(player)
        end
end)

--colossus_st->add_action( "colossus_smash,if=cooldown.avatar.remains>14" );
ColossusSmash:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        if Avatar:Cooldown() > 14000 then
            return spell:Cast(target)
        end
end)

--colossus_st->add_action( "warbreaker,if=cooldown.avatar.remains>14" );
Warbreaker:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        if Avatar:Cooldown() > 14000 then
            return spell:Cast(player)
        end
end)

--colossus_st->add_action( "champions_spear" );
ChampionsSpear:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_st->add_action( "mortal_strike" );
MortalStrike:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)

--colossus_st->add_action( "demolish,if=debuff.colossus_smash.up&buff.colossal_might.up" );
Demolish:Callback("colossus_st", function(spell)
        if not shouldBurst() then return end
        if not target:HasDeBuff(debuffs.colossusSmash) then return end
        if not player:HasBuff(buffs.colossalMight) then return end
        
        return spell:Cast(target)
end)

--colossus_st->add_action( "skullsplitter" );
Skullsplitter:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)

--colossus_st->add_action( "execute" );
Execute:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)
ExecuteToo:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)
ExecuteTooo:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)

--colossus_st->add_action( "overpower" );
Overpower:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)

--colossus_st->add_action( "rend,if=dot.rend.remains<=gcd*5" );
Rend:Callback("colossus_st2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() * 5 then
            return spell:Cast(target)
        end
end)

--colossus_st->add_action( "slam" );
Slam:Callback("colossus_st", function(spell)
        
        return spell:Cast(target)
end)


local function colossus_st()
    Rend("colossus_st")
    ThunderousRoar("colossus_st")
    Ravager("colossus_st")
    Avatar("colossus_st")
    ColossusSmash("colossus_st")
    Warbreaker("colossus_st")
    ChampionsSpear("colossus_st")
    Demolish("colossus_st")
    MortalStrike("colossus_st")
    Skullsplitter("colossus_st")
    Overpower("colossus_st")
    Execute("colossus_st")
    ExecuteToo("colossus_st")
    ExecuteTooo("colossus_st")
    WreckingThrow("colossus_st")
    Rend("colossus_st2")
    Slam("colossus_st")
end

--###############################################################################  COLOSSUS EXECUTE       #############################################################################

--colossus_execute->add_action( "sweeping_strikes,if=active_enemies=2" );
SweepingStrikes:Callback("colossus_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.activeEnemies == 2 then
            return spell:Cast(player)
        end
end)

--colossus_execute->add_action( "rend,if=dot.rend.remains<=gcd&!talent.bloodletting" );
Rend:Callback("colossus_execute", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() and not A.Bloodletting:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_execute->add_action( "thunderous_roar" );
ThunderousRoar:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_execute->add_action( "champions_spear" );
ChampionsSpear:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_execute->add_action( "ravager,if=cooldown.colossus_smash.remains<=gcd" );
Ravager:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() <= MakGcd() or Warbreaker:Cooldown() <= MakGcd() then
            return spell:Cast(player)
        end
end)

--colossus_execute->add_action( "avatar" );
Avatar:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_execute->add_action( "colossus_smash" );
ColossusSmash:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--colossus_execute->add_action( "warbreaker" );
Warbreaker:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_execute->add_action( "execute,if=buff.juggernaut.remains<=gcd&talent.juggernaut" );
Execute:Callback("colossus_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("colossus_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("colossus_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_execute->add_action( "skullsplitter" );
Skullsplitter:Callback("colossus_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_execute->add_action( "demolish,if=debuff.colossus_smash.up&buff.colossal_might.stack=10" );
Demolish:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        if not target:HasDeBuff(debuffs.colossusSmash) then return end
        if player:HasBuffCount(buffs.colossalMight) ~= 10 then return end
        
        return spell:Cast(target)
end)

--colossus_execute->add_action( "mortal_strike,if=debuff.executioners_precision.stack=2|!talent.executioners_precision|talent.battlelord" );
MortalStrike:Callback("colossus_execute", function(spell)
        if target:HasDeBuffCount(debuffs.executionersPrecision) == 2 or not A.ExecutionersPrecision:IsTalentLearned() or A.Battlelord:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_execute->add_action( "overpower,if=rage<90" );
Overpower:Callback("colossus_execute", function(spell)
        if player.rage < 90 then
            return spell:Cast(target)
        end
end)

--colossus_execute->add_action( "execute,if=rage>=40&talent.executioners_precision" );
Execute:Callback("colossus_execute2", function(spell)
        if player.rage >= 40 and A.ExecutionersPrecision:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("colossus_execute2", function(spell)
        if player.rage >= 40 and A.ExecutionersPrecision:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("colossus_execute2", function(spell)
        if player.rage >= 40 and A.ExecutionersPrecision:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_execute->add_action( "overpower" );
Overpower:Callback("colossus_execute2", function(spell)
        return spell:Cast(target)
end)

--colossus_execute->add_action( "bladestorm" );
Bladestorm:Callback("colossus_execute", function(spell)
        if not shouldBurst() then return end
        
        return spell:Cast(player)
end)

--colossus_execute->add_action( "execute" );
Execute:Callback("colossus_execute3", function(spell)
        return spell:Cast(target)
end)
ExecuteToo:Callback("colossus_execute3", function(spell)
        return spell:Cast(target)
end)
ExecuteTooo:Callback("colossus_execute3", function(spell)
        return spell:Cast(target)
end)

--colossus_execute->add_action( "mortal_strike" );
MortalStrike:Callback("colossus_execute2", function(spell)
        return spell:Cast(target)
end)


local function colossus_execute()
    SweepingStrikes("colossus_execute")
    Rend("colossus_execute")
    ThunderousRoar("colossus_execute")
    ChampionsSpear("colossus_execute")
    Ravager("colossus_execute")
    Avatar("colossus_execute")
    ColossusSmash("colossus_execute")
    Warbreaker("colossus_execute")
    Execute("colossus_execute")
    ExecuteToo("colossus_execute")
    ExecuteTooo("colossus_execute")
    Skullsplitter("colossus_execute")
    Demolish("colossus_execute")
    MortalStrike("colossus_execute")
    Overpower("colossus_execute")
    Execute("colossus_execute2")
    ExecuteToo("colossus_execute2")
    ExecuteTooo("colossus_execute2")
    Overpower("colossus_execute2")
    Bladestorm("colossus_execute")
    WreckingThrow("colossus_execute")
    Execute("colossus_execute3")
    ExecuteToo("colossus_execute3")
    ExecuteTooo("colossus_execute3")
end

--###############################################################################  COLOSSUS_SWEEP   ###################################################################################

--colossus_sweep->add_action( "thunder_clap,if=!dot.rend.remains&!buff.sweeping_strikes.up" );
ThunderClap:Callback("colossus_sweep", function(spell)
        if target.totalImmune or target.physImmune then return end
        if not target:HasDeBuff(debuffs.rend) and not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "rend,if=dot.rend.remains<=gcd&buff.sweeping_strikes.up" );
Rend:Callback("colossus_sweep", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() and player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "thunderous_roar" );
ThunderousRoar:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_sweep->add_action( "sweeping_strikes" );
SweepingStrikes:Callback("colossus_sweep", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_sweep->add_action( "champions_spear" );
ChampionsSpear:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_sweep->add_action( "ravager,if=cooldown.colossus_smash.ready" );
Ravager:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() <= MakGcd() or Warbreaker:Cooldown() <= MakGcd() then
            return spell:Cast(player)
        end
end)

--colossus_sweep->add_action( "avatar" );
Avatar:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_sweep->add_action( "colossus_smash" );
ColossusSmash:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--colossus_sweep->add_action( "warbreaker" );
Warbreaker:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_sweep->add_action( "mortal_strike" );
MortalStrike:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)

--colossus_sweep->add_action( "demolish,if=debuff.colossus_smash.up" );
Demolish:Callback("colossus_sweep", function(spell)
        if not shouldBurst() then return end
        if target:HasDeBuff(debuffs.colossusSmash) then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "overpower" );
Overpower:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)

--colossus_sweep->add_action( "execute" );
Execute:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)
ExecuteToo:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)
ExecuteTooo:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)

--colossus_sweep->add_action( "whirlwind,if=talent.fervor_of_battle" );
Whirlwind:Callback("colossus_sweep", function(spell)
        if A.FervorofBattle:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "cleave,if=talent.fervor_of_battle" );
Cleave:Callback("colossus_sweep", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        if A.FervorofBattle:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "thunder_clap,if=dot.rend.remains<=8&buff.sweeping_strikes.down" );
ThunderClap:Callback("colossus_sweep2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 8000 and not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "rend,if=dot.rend.remains<=5" );
Rend:Callback("colossus_sweep2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 5000 then
            return spell:Cast(target)
        end
end)

--colossus_sweep->add_action( "slam" );
Slam:Callback("colossus_sweep", function(spell)
        
        return spell:Cast(target)
end)

local function colossus_sweep()
    ThunderClap("colossus_sweep")
    Rend("colossus_sweep")
    ThunderousRoar("colossus_sweep")
    SweepingStrikes("colossus_sweep")
    ChampionsSpear("colossus_sweep")
    Ravager("colossus_sweep")
    Avatar("colossus_sweep")
    ColossusSmash("colossus_sweep")
    Warbreaker("colossus_sweep")
    MortalStrike("colossus_sweep")
    Demolish("colossus_sweep")
    Overpower("colossus_sweep")
    Execute("colossus_sweep")
    ExecuteToo("colossus_sweep")
    ExecuteTooo("colossus_sweep")
    Whirlwind("colossus_sweep")
    Cleave("colossus_sweep")
    ThunderClap("colossus_sweep2")
    Rend("colossus_sweep2")
    Slam("colossus_sweep")
end


--###############################################################################  COLOSSUS AOE       #################################################################################

--colossus_aoe->add_action( "cleave,if=!dot.deep_wounds.remains" );
Cleave:Callback("colossus_aoe", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        if not target:HasDeBuff(debuffs.deepWounds) then
            return spell:Cast(target)
        end
end)

--colossus_aoe->add_action( "thunder_clap,if=!dot.rend.remains" );
ThunderClap:Callback("colossus_aoe", function(spell)
        if not target:HasDeBuff(debuffs.rend) then
            return spell:Cast(target)
        end
end)

--colossus_aoe->add_action( "thunderous_roar" );
ThunderousRoar:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "avatar" );
Avatar:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "sweeping_strikes" );
SweepingStrikes:Callback("colossus_aoe", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "warbreaker" );
Warbreaker:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "ravager" );
Ravager:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "champions_spear" );
ChampionsSpear:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "colossus_smash" );
ColossusSmash:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "cleave" );
Cleave:Callback("colossus_aoe2", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "bladestorm,if=talent.unhinged|talent.merciless_bonegrinder" );
Bladestorm:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if A.Unhinged:IsTalentLearned() or A.MercilessBonegrinder:IsTalentLearned() then
            return spell:Cast(player)
        end
end)

--colossus_aoe->add_action( "thunder_clap,if=dot.rend.remains<5" );
ThunderClap:Callback("colossus_aoe2", function(spell)
        if target:DebuffRemains(debuffs.rend) < 5000 then
            return spell:Cast(target)
        end
end)

--colossus_aoe->add_action( "demolish,if=buff.colossal_might.stack=10&(debuff.colossus_smash.remains>=2|cooldown.colossus_smash.remains>=10|cooldown.warbreaker.remains>=10)" );
Demolish:Callback("colossus_aoe", function(spell)
        if not shouldBurst() then return end
        if player:HasBuffCount(buffs.colossalMight) ~= 10 then return end
        if not (target:DebuffRemains(debuffs.colossusSmash) >= 2000 or A.ColossusSmash:GetCooldown() >= 10000 or A.Warbreaker:GetCooldown() >= 10000) then return end
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "mortal_strike" );
MortalStrike:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "overpower" );
Overpower:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "thunder_clap" );
ThunderClap:Callback("colossus_aoe3", function(spell)
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "skullsplitter,if=buff.sweeping_strikes.up" );
Skullsplitter:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)

--colossus_aoe->add_action( "execute" );
Execute:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)
ExecuteToo:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)
ExecuteTooo:Callback("colossus_aoe", function(spell)
        
        return spell:Cast(target)
end)


--colossus_aoe->add_action( "bladestorm" );
Bladestorm:Callback("colossus_aoe2", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--colossus_aoe->add_action( "whirlwind" );
Whirlwind:Callback("colossus_aoe", function(spell)
        return spell:Cast(target)
end)

local function colossus_aoe()
    Cleave("colossus_aoe")
    ThunderClap("colossus_aoe")
    ThunderousRoar("colossus_aoe")
    Avatar("colossus_aoe")
    SweepingStrikes("colossus_aoe")
    Warbreaker("colossus_aoe")
    Ravager("colossus_aoe")
    ChampionsSpear("colossus_aoe")
    ColossusSmash("colossus_aoe")
    Cleave("colossus_aoe2")
    Bladestorm("colossus_aoe")
    ThunderClap("colossus_aoe2")
    Demolish("colossus_aoe")
    MortalStrike("colossus_aoe")
    Overpower("colossus_aoe")
    ThunderClap("colossus_aoe3")
    Skullsplitter("colossus_aoe")
    Execute("colossus_aoe")
    ExecuteToo("colossus_aoe")
    ExecuteTooo("colossus_aoe")
    Bladestorm("colossus_aoe2")
    Whirlwind("colossus_aoe")
end

--###############################################################################  SLAYER ST       ####################################################################################

--slayer_st->add_action( "rend,if=dot.rend.remains<=gcd" );
Rend:Callback("slayer_st", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() then
            return spell:Cast(target)
        end
end)

--slayer_st->add_action( "thunderous_roar" );
ThunderousRoar:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_st->add_action( "avatar,if=cooldown.colossus_smash.remains<=5|debuff.colossus_smash.up" );
Avatar:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        -- Use Avatar shortly before or with Colossus Smash for optimal alignment
        if (ColossusSmash:Cooldown() <= 5000 or Warbreaker:Cooldown() <= 5000) or target:HasDeBuff(debuffs.colossusSmash) then
            return spell:Cast(player)
        end
end)

--slayer_st->add_action( "champions_spear,if=debuff.colossus_smash.up|buff.avatar.up" );
ChampionsSpear:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuff(debuffs.colossusSmash) or player:HasBuff(buffs.avatar) then
            return spell:Cast(player)
        end
end)

--slayer_st->add_action( "ravager,if=cooldown.colossus_smash.remains<=gcd" );
Ravager:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() <= MakGcd() or Warbreaker:Cooldown() <= MakGcd() then
            return spell:Cast(player)
        end
end)

--slayer_st->add_action( "colossus_smash" );
ColossusSmash:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--slayer_st->add_action( "warbreaker" );
Warbreaker:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_st->add_action( "execute,if=buff.juggernaut.remains<=gcd*2&talent.juggernaut|buff.sudden_death.stack=2|buff.sudden_death.remains<=gcd*3|debuff.marked_for_execution.stack=3" );
Execute:Callback("slayer_st", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
        if player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_st", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
        if player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_st", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
        if player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 then
            return spell:Cast(target)
        end
end)

--slayer_st->add_action( "overpower,if=buff.opportunist.up" );
--AddTier Stuff Later
Overpower:Callback("slayer_st", function(spell)
        if player:HasBuff(buffs.opportunist) then
            return spell:Cast(target)
        end
end)

--slayer_st->add_action( "mortal_strike" );
MortalStrike:Callback("slayer_st", function(spell)
        
        return spell:Cast(target)
end)

--slayer_st->add_action( "bladestorm,if=(cooldown.colossus_smash.remains>=gcd*4|cooldown.warbreaker.remains>=gcd*4)|debuff.colossus_smash.remains>=gcd*4" );
Bladestorm:Callback("slayer_st", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() >= MakGcd() * 4 or Warbreaker:Cooldown() >= MakGcd() * 4 or target:DebuffRemains(debuffs.colossusSmash) >= MakGcd() * 4 then
            return spell:Cast(player)
        end
end)

--slayer_st->add_action( "skullsplitter" );
Skullsplitter:Callback("slayer_st", function(spell)
        
        return spell:Cast(target)
end)




--slayer_st->add_action( "overpower" );
Overpower:Callback("slayer_st2", function(spell)
        
        return spell:Cast(target)
end)

--slayer_st->add_action( "rend,if=dot.rend.remains<=8" );
Rend:Callback("slayer_st2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 8000 then
            return spell:Cast(target)
        end
end)

--slayer_st->add_action( "execute,if=!talent.juggernaut" );
Execute:Callback("slayer_st2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_st2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_st2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_st->add_action( "cleave" );
Cleave:Callback("slayer_st", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        return spell:Cast(target)
end)

--slayer_st->add_action( "slam" );
Slam:Callback("slayer_st", function(spell)
        
        return spell:Cast(target)
end)

--slayer_st->add_action( "storm_bolt,if=buff.bladestorm.up" );
StormBolt:Callback("slayer_st", function(spell)
        if Action.Zone == "arena" then return end
        if player:HasBuff(buffs.bladestorm) then
            return spell:Cast(target)
        end
end)

local function slayer_st()
    Rend("slayer_st")
    ThunderousRoar("slayer_st")
    Avatar("slayer_st")
    ChampionsSpear("slayer_st")
    Ravager("slayer_st")
    ColossusSmash("slayer_st")
    Warbreaker("slayer_st")
    Execute("slayer_st")
    ExecuteToo("slayer_st")
    ExecuteTooo("slayer_st")
    Overpower("slayer_st")
    MortalStrike("slayer_st")
    Bladestorm("slayer_st")
    Skullsplitter("slayer_st")
    Overpower("slayer_st2")
    Rend("slayer_st2")
    Execute("slayer_st2")
    ExecuteToo("slayer_st2")
    ExecuteTooo("slayer_st2")
    Cleave("slayer_st")
    Slam("slayer_st")
    StormBolt("slayer_st")
end

--###############################################################################  SLAYER EXECUTE    ##################################################################################

--slayer_execute->add_action( "sweeping_strikes,if=active_enemies=2" );
SweepingStrikes:Callback("slayer_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        if gameState.activeEnemies == 2 then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "rend,if=dot.rend.remains<=gcd&!talent.bloodletting" );
Rend:Callback("slayer_execute", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() and not IsPlayerSpell(A.Bloodletting.ID) then
            return spell:Cast(target)
        end
end)
--slayer_execute->add_action( "thunderous_roar" );
ThunderousRoar:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_execute->add_action( "avatar,if=cooldown.colossus_smash.remains<=5|debuff.colossus_smash.up" );
Avatar:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if (ColossusSmash:Cooldown() <= 5000 or Warbreaker:Cooldown() <= 5000) or target:HasDeBuff(debuffs.colossusSmash) then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "champions_spear,if=debuff.colossus_smash.up|buff.avatar.up" );
ChampionsSpear:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuff(debuffs.colossusSmash) or player:HasBuff(buffs.avatar) then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "ravager,if=cooldown.colossus_smash.remains<=gcd" );
Ravager:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() <= MakGcd() or Warbreaker:Cooldown() <= MakGcd() then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "warbreaker" );
Warbreaker:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_execute->add_action( "colossus_smash" );
ColossusSmash:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--slayer_execute->add_action( "execute,if=buff.juggernaut.remains<=gcd&talent.juggernaut" );
Execute:Callback("slayer_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_execute", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() and A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_execute->add_action( "bladestorm,if=(debuff.executioners_precision.stack=2&(debuff.colossus_smash.remains>4|cooldown.colossus_smash.remains>15))|!talent.executioners_precision" );
Bladestorm:Callback("slayer_execute", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target:HasDeBuffCount(debuffs.executionersPrecision) == 2 and (target:DebuffRemains(debuffs.colossusSmash) > 4000 or (target:HasDeBuffCount(debuffs.executionersPrecision) == 2 and ((ColossusSmash:Cooldown() > 15000 or Warbreaker:Cooldown() > 15000) or not IsPlayerSpell(A.ExecutionersPrecision.ID)))) then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "skullsplitter,if=rage<=40" );
Skullsplitter:Callback("slayer_execute", function(spell)
        if target.totalImmune or target.physImmune then return end
        if player.rage <= 40 then
            return spell:Cast(player)
        end
end)

--slayer_execute->add_action( "overpower,if=buff.martial_prowess.stack<2&buff.opportunist.up&talent.opportunist&(talent.bladestorm|talent.ravager&rage<85)" );
Overpower:Callback("slayer_execute", function(spell)
        if player:HasBuffCount(buffs.martialProwess) < 2 and player:HasBuff(buffs.opportunist) and A.Opportunist:IsTalentLearned() and (A.Bladestorm:IsTalentLearned() or (A.Ravager:IsTalentLearned() and player.rage < 85)) then
            return spell:Cast(target)
        end
end)

--slayer_execute->add_action( "mortal_strike,if=dot.rend.remains<2|debuff.executioners_precision.stack=2&!dot.ravager.remains" );
MortalStrike:Callback("slayer_execute", function(spell)
        if target:DebuffRemains(debuffs.rend) < 2000 or (target:HasDeBuffCount(debuffs.executionersPrecision) == 2 and not player:HasBuff(buffs.ravager)) then
            return spell:Cast(target)
        end
end)


--slayer_execute->add_action( "overpower,if=rage<=40&buff.martial_prowess.stack<2&talent.fierce_followthrough" );
Overpower:Callback("slayer_execute2", function(spell)
        if player.rage <= 40 and player:HasBuffCount(buffs.martialProwess) < 2 and A.FierceFollowthrough:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_execute->add_action( "execute,if=rage>20" );
Execute:Callback("slayer_execute2", function(spell)
        if player.rage > 20 then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_execute2", function(spell)
        if player.rage > 20 then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_execute2", function(spell)
        if player.rage > 20 then
            return spell:Cast(target)
        end
end)

--slayer_execute->add_action( "overpower" );
Overpower:Callback("slayer_execute3", function(spell)
        
        return spell:Cast(target)
end)

--slayer_execute->add_action( "storm_bolt,if=buff.bladestorm.up" );
StormBolt:Callback("slayer_execute", function(spell)
        if Action.Zone == "arena" then return end
        if player:HasBuff(buffs.bladestorm) then
            return spell:Cast(target)
        end
end)

local function slayer_execute()
    SweepingStrikes("slayer_execute")
    Rend("slayer_execute")
    ThunderousRoar("slayer_execute")
    Avatar("slayer_execute")
    ChampionsSpear("slayer_execute")
    Ravager("slayer_execute")
    Warbreaker("slayer_execute")
    ColossusSmash("slayer_execute")
    Execute("slayer_execute")
    ExecuteToo("slayer_execute")
    ExecuteTooo("slayer_execute")
    Bladestorm("slayer_execute")
    Skullsplitter("slayer_execute")
    Overpower("slayer_execute")
    MortalStrike("slayer_execute")
    Overpower("slayer_execute2")
    Execute("slayer_execute2")
    ExecuteToo("slayer_execute2")
    ExecuteTooo("slayer_execute2")
    Overpower("slayer_execute3")
    StormBolt("slayer_execute")
end

--###############################################################################  SLAYER SWEEP       ##################################################################################

--slayer_sweep->add_action( "thunder_clap,if=!dot.rend.remains&!buff.sweeping_strikes.up" );
ThunderClap:Callback("slayer_sweep", function(spell)
        if not target:HasDeBuff(debuffs.rend) and not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "thunderous_roar" );
ThunderousRoar:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_sweep->add_action( "sweeping_strikes" );
SweepingStrikes:Callback("slayer_sweep", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_sweep->add_action( "rend,if=dot.rend.remains<=gcd" );
Rend:Callback("slayer_sweep", function(spell)
        if target:DebuffRemains(debuffs.rend) <= MakGcd() then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "champions_spear" );
ChampionsSpear:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_sweep->add_action( "avatar" );
Avatar:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_sweep->add_action( "colossus_smash" );
ColossusSmash:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--slayer_sweep->add_action( "warbreaker" );
Warbreaker:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_sweep->add_action( "skullsplitter,if=buff.sweeping_strikes.up" );
Skullsplitter:Callback("slayer_sweep", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "execute,if=buff.juggernaut.remains<=gcd*2" );
Execute:Callback("slayer_sweep", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 or player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_sweep", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 or player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_sweep", function(spell)
        if player:BuffRemains(buffs.juggernaut) <= MakGcd() * 2 or target:HasDeBuffCount(debuffs.markedForExecution) == 3 or player:HasBuffCount(buffs.suddenDeath) == 2 or player:BuffRemains(buffs.suddenDeath) <= MakGcd() * 3 then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "bladestorm,if=(cooldown.colossus_smash.remains>=gcd*4|cooldown.warbreaker.remains>=gcd*4)|debuff.colossus_smash.remains>=gcd*4" );
Bladestorm:Callback("slayer_sweep", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() >= MakGcd() * 4 or Warbreaker:Cooldown() >= MakGcd() * 4 or target:HasDeBuff(debuffs.colossusSmash) >= MakGcd() * 4 then
            return spell:Cast(player)
        end
end)

--slayer_sweep->add_action( "overpower,if=buff.opportunist.up" );
Overpower:Callback("slayer_sweep", function(spell)
        if player:HasBuff(buffs.opportunist) then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "mortal_strike" );
MortalStrike:Callback("slayer_sweep", function(spell)
        
        return spell:Cast(target)
end)

--slayer_sweep->add_action( "overpower" );
Overpower:Callback("slayer_sweep2", function(spell)
        
        return spell:Cast(target)
end)

--slayer_sweep->add_action( "thunder_clap,if=dot.rend.remains<=8&buff.sweeping_strikes.down" )
ThunderClap:Callback("slayer_sweep2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 8000 and not player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "rend,if=dot.rend.remains<=5" );
Rend:Callback("slayer_sweep2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 5000 then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "cleave,if=talent.fervor_of_battle&!buff.martial_prowess.up" );
Cleave:Callback("slayer_sweep", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        if A.FervorofBattle:IsTalentLearned() and not player:HasBuff(buffs.martialProwess) then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "whirlwind,if=talent.fervor_of_battle" );
Whirlwind:Callback("slayer_sweep", function(spell)
        if A.FervorofBattle:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "execute,if=!talent.juggernaut" );
Execute:Callback("slayer_sweep2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_sweep2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_sweep2", function(spell)
        if not A.Juggernaut:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_sweep->add_action( "slam" );
Slam:Callback("slayer_sweep", function(spell)
        
        return spell:Cast(target)
end)

--slayer_sweep->add_action( "storm_bolt,if=buff.bladestorm.up" );
StormBolt:Callback("slayer_sweep", function(spell)
        if Action.Zone == "arena" then return end
        if player:HasBuff(buffs.bladestorm) then
            return spell:Cast(target)
        end
end)

local function slayer_sweep()
    ThunderClap("slayer_sweep")
    ThunderousRoar("slayer_sweep")
    SweepingStrikes("slayer_sweep")
    Rend("slayer_sweep")
    ChampionsSpear("slayer_sweep")
    Avatar("slayer_sweep")
    ColossusSmash("slayer_sweep")
    Warbreaker("slayer_sweep")
    Skullsplitter("slayer_sweep")
    Execute("slayer_sweep")
    ExecuteToo("slayer_sweep")
    ExecuteTooo("slayer_sweep")
    Bladestorm("slayer_sweep")
    Overpower("slayer_sweep")
    MortalStrike("slayer_sweep")
    Overpower("slayer_sweep2")
    ThunderClap("slayer_sweep2")
    Rend("slayer_sweep2")
    Cleave("slayer_sweep")
    Whirlwind("slayer_sweep")
    Execute("slayer_sweep2")
    ExecuteToo("slayer_sweep2")
    ExecuteTooo("slayer_sweep2")
    Slam("slayer_sweep")
    StormBolt("slayer_sweep")
end

--###############################################################################  SLAYER AOE       ####################################################################################

--slayer_aoe->add_action( "thunder_clap,if=!dot.rend.remains" );
ThunderClap:Callback("slayer_aoe", function(spell)
        if not target:HasDeBuff(debuffs.rend) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "sweeping_strikes" );
SweepingStrikes:Callback("slayer_aoe", function(spell)
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "thunderous_roar" );
ThunderousRoar:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "avatar" );
Avatar:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "champions_spear" );
ChampionsSpear:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "ravager,if=cooldown.colossus_smash.remains<=gcd" );
Ravager:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if ColossusSmash:Cooldown() <= MakGcd() then
            return spell:Cast(player)
        end
end)

--slayer_aoe->add_action( "warbreaker" );
Warbreaker:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "colossus_smash" );
ColossusSmash:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "cleave" );
Cleave:Callback("slayer_aoe", function(spell)
        if not IsPlayerSpell(A.Cleave.ID) then return end
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "execute,if=buff.sudden_death.up&buff.imminent_demise.stack<3|buff.juggernaut.remains<3&talent.juggernaut" );
Execute:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.suddenDeath) and (target:HasDeBuffCount(debuffs.markedForExecution) < 3 or (player:BuffRemains(buffs.juggernaut) < 3000 and A.Juggernaut:IsTalentLearned())) then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.suddenDeath) and (target:HasDeBuffCount(debuffs.markedForExecution) < 3 or (player:BuffRemains(buffs.juggernaut) < 3000 and A.Juggernaut:IsTalentLearned())) then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.suddenDeath) and (target:HasDeBuffCount(debuffs.markedForExecution) < 3 or (player:BuffRemains(buffs.juggernaut) < 3000 and A.Juggernaut:IsTalentLearned())) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "bladestorm" );
Bladestorm:Callback("slayer_aoe", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(player)
end)

--slayer_aoe->add_action( "overpower,if=buff.sweeping_strikes.up&(buff.opportunist.up|talent.dreadnaught&!talent.juggernaut)" );
Overpower:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) and (player:HasBuff(buffs.opportunist) or (A.Dreadnaught:IsTalentLearned() and not A.Juggernaut:IsTalentLearned())) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "mortal_strike,if=buff.sweeping_strikes.up" );
MortalStrike:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "execute,if=buff.sweeping_strikes.up&debuff.executioners_precision.stack<2&talent.executioners_precision|debuff.marked_for_execution.up" );
Execute:Callback("slayer_aoe2", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) and ((target:HasDeBuffCount(debuffs.executionersPrecision) < 2 and A.ExecutionersPrecision:IsTalentLearned()) or target:HasDeBuff(debuffs.markedForExecution)) then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("slayer_aoe2", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) and ((target:HasDeBuffCount(debuffs.executionersPrecision) < 2 and A.ExecutionersPrecision:IsTalentLearned()) or target:HasDeBuff(debuffs.markedForExecution)) then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("slayer_aoe2", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) and ((target:HasDeBuffCount(debuffs.executionersPrecision) < 2 and A.ExecutionersPrecision:IsTalentLearned()) or target:HasDeBuff(debuffs.markedForExecution)) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "skullsplitter,if=buff.sweeping_strikes.up" );
Skullsplitter:Callback("slayer_aoe", function(spell)
        if player:HasBuff(buffs.sweepingStrikes) then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "overpower,if=buff.opportunist.up|talent.dreadnaught" );
Overpower:Callback("slayer_aoe2", function(spell)
        if player:HasBuff(buffs.opportunist) or A.Dreadnaught:IsTalentLearned() then
            return spell:Cast(target)
        end
end)

--slayer_aoe->add_action( "mortal_strike" );
MortalStrike:Callback("slayer_aoe2", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "overpower" );
Overpower:Callback("slayer_aoe3", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "thunder_clap" );
ThunderClap:Callback("slayer_aoe2", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "execute" );
Execute:Callback("slayer_aoe3", function(spell)
        
        return spell:Cast(target)
end)
ExecuteToo:Callback("slayer_aoe3", function(spell)
        
        return spell:Cast(target)
end)
ExecuteTooo:Callback("slayer_aoe3", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "whirlwind" );
Whirlwind:Callback("slayer_aoe", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "skullsplitter" );
Skullsplitter:Callback("slayer_aoe2", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "slam" );
Slam:Callback("slayer_aoe", function(spell)
        
        return spell:Cast(target)
end)

--slayer_aoe->add_action( "storm_bolt,if=buff.bladestorm.up" );
StormBolt:Callback("slayer_aoe", function(spell)
        if Action.Zone == "arena" then return end
        if player:HasBuff(buffs.bladestorm) then
            return spell:Cast(target)
        end
end)

local function slayer_aoe()
    ThunderClap("slayer_aoe")
    SweepingStrikes("slayer_aoe")
    ThunderousRoar("slayer_aoe")
    Avatar("slayer_aoe")
    ChampionsSpear("slayer_aoe")
    Ravager("slayer_aoe")
    Warbreaker("slayer_aoe")
    ColossusSmash("slayer_aoe")
    Cleave("slayer_aoe")
    Execute("slayer_aoe")
    ExecuteToo("slayer_aoe")
    ExecuteTooo("slayer_aoe")
    Bladestorm("slayer_aoe")
    Overpower("slayer_aoe")
    MortalStrike("slayer_aoe")
    Execute("slayer_aoe2")
    ExecuteToo("slayer_aoe2")
    ExecuteTooo("slayer_aoe2")
    Skullsplitter("slayer_aoe")
    Overpower("slayer_aoe2")
    MortalStrike("slayer_aoe2")
    Overpower("slayer_aoe3")
    ThunderClap("slayer_aoe2")
    Execute("slayer_aoe3")
    ExecuteToo("slayer_aoe3")
    ExecuteTooo("slayer_aoe3")
    Whirlwind("slayer_aoe")
    Skullsplitter("slayer_aoe2")
    Slam("slayer_aoe")
    StormBolt("slayer_aoe")
end

-- PVP Killer: Execute immediately if ready or have Sudden Death proc
Execute:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if player:HasBuff(buffs.suddenDeath) or gameState.executePhase then
            return spell:Cast(target)
        end
end)
ExecuteToo:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if player:HasBuff(buffs.suddenDeath) or gameState.executePhase then
            return spell:Cast(target)
        end
end)
ExecuteTooo:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if player:HasBuff(buffs.suddenDeath) or gameState.executePhase then
            return spell:Cast(target)
        end
end)
Bladestorm:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(player)
end)

Avatar:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        
        -- If Demolish is talented, only use Avatar at 10 stacks of Colossal Might
        if A.Demolish:IsTalentLearned() then
            if player:HasBuffCount(buffs.colossalMight) == 10 then
                return spell:Cast(player)
            end
        else
            -- No Demolish talent, use Avatar on cooldown
            return spell:Cast(player)
        end
end)

ThunderousRoar:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(player)
end)

ChampionsSpear:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(player)
end)

Ravager:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(player)
end)

ColossusSmash:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(target)
end)

Warbreaker:Callback("PVPKiller", function(spell)
        if not shouldBurst() then return end
        if not IsPlayerSpell(A.Warbreaker.ID) then return end
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(player)
end)

SweepingStrikes:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if gameState.activeEnemies >= 2 then
            return spell:Cast(player)
        end
end)

ThunderClap:Callback("PVPKiller", function(spell)
    if target.totalImmune or target.physImmune then return end

    -- Original logic: within 5 yards and missing rend
    if target.distance <= 5 and not target:HasDeBuff(debuffs.rend) then
        return spell:Cast(target)
    end

    -- Hunter logic: within 10 yards and missing Thunder Clap debuff
    local _, targetClass = UnitClass("target")
    if targetClass == "HUNTER" and target.distance <= 10 and not target:HasDeBuff(435203) then
        return spell:Cast(target)
    end
end)

Rend:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if gameState.activeEnemies == 1 and target:DebuffRemains(debuffs.rend) <= MakGcd() then
            return spell:Cast(target)
        end
end)

MortalStrike:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if target:DebuffRemains(debuffs.mortalWounds) <= 2000 or player:HasBuff(buffs.criticalConclusion) then
            return spell:Cast(target)
        end
end)
MortalStrike:Callback("PVPKiller2", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(target)
end)

Overpower:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        if Overpower.charges == 2 then
            return spell:Cast(target)
        end
end)
Overpower:Callback("PVPKiller2", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(target)
        
end)

Slam:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        return spell:Cast(target)
        
end)

Demolish:Callback("PVPKiller", function(spell)
        if target.totalImmune or target.physImmune then return end
        if target.distance > 5 then return end
        
        -- Only proceed if we have 10 stacks of Colossal Might
        if player:HasBuffCount(buffs.colossalMight) ~= 10 then return end
        
        local colossalMightRemains = player:BuffRemains(buffs.colossalMight)
        local avatarCd = Avatar:Cooldown()
        
        -- Only cast Demolish if Avatar's cooldown is longer than Colossal Might duration
        -- This means Avatar won't be available before Colossal Might expires
        if avatarCd > colossalMightRemains then
            return spell:Cast(target)
        end
end)

BerserkerRage:Callback("PVPKiller", function(spell)
    
    if player:DebuffFrom(MakLists.berserkerRageBreaks) then

        return spell:Cast()
    end

end)

Hamstring:Callback("PVPKiller", function(spell)
    if target.totalImmune or target.physImmune then return end
    if target.distance > 5 then return end
    local _, targetClass = UnitClass("target")
    if targetClass ~= "HUNTER" then return end
    local hasThunderClap = target:HasDeBuff(435203)
    local hasHamstring = target:HasDeBuff(debuffs.hamstring)
    if not hasThunderClap or not hasHamstring then
        return spell:Cast(target)
    end
end)

local function PVPKiller()
    -- Fear Break 
    BerserkerRage("PVPKiller") 
    -- Slow 
    ThunderClap("PVPKiller")
    -- Hamstring("PVPKiller")
    Avatar("PVPKiller")
    ThunderousRoar("PVPKiller")
    ChampionsSpear("PVPKiller")
    Ravager("PVPKiller")
    ColossusSmash("PVPKiller")
    Warbreaker("PVPKiller")
    Bladestorm("PVPKiller")
    SweepingStrikes("PVPKiller")
    MortalStrike("PVPKiller")
    Demolish("PVPKiller")
    Execute("PVPKiller")
    ExecuteToo("PVPKiller")
    ExecuteTooo("PVPKiller")
    Rend("PVPKiller")
    Overpower("PVPKiller")
    MortalStrike("PVPKiller2")
    Overpower("PVPKiller2")
    Slam("PVPKiller")
    
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
    
    local awareAlert = A.GetToggle(2, "makAware")
    
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Nothing to see here")
    end
    
    -- Original APL main actions equivalent
    -- charge,if=time<=0.5|movement.distance>5 (handled in baseStuff)
    PowerInfusion()
    
    -- pummel,if=target.debuff.casting.react (handled by PVE.interrupt)
    if Action.Zone ~= "arena" then PVE.interrupt(interrupts) end
    
    stances()
    baseStuff()
    
    if target.exists and target.canAttack and Slam:InRange(target) and not player:Debuff(410201) then
        
        if shouldBurst() then
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
            
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)
            
            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.recklessness) or target:HasDeBuff(debuffs.colossusSmash)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            racials()
            
        end
        
        if A.IsInPvP then
            PVPKiller()
        end
        
        if IsPlayerSpell(A.Demolish.ID) then
            if gameState.activeEnemies > 2 then
                colossus_aoe()
            elseif gameState.executePhase then
                colossus_execute()
            elseif gameState.activeEnemies == 2 and not gameState.executePhase then
                colossus_sweep()
            else
                colossus_st()
            end
        end
        
        if IsPlayerSpell(A.SlayersDominance.ID) then
            if gameState.activeEnemies > 2 then
                slayer_aoe()
            elseif gameState.executePhase then
                slayer_execute()
            elseif gameState.activeEnemies == 2 and not gameState.executePhase then
                slayer_sweep()
            else
                slayer_st()
            end
        end
        
        if not IsPlayerSpell(A.Demolish.ID) and not IsPlayerSpell(A.SlayersDominance.ID) then
            if gameState.activeEnemies > 2 then
                colossus_aoe()
            elseif gameState.executePhase then
                colossus_execute()
            elseif gameState.activeEnemies == 2 and not gameState.executePhase then
                colossus_sweep()
            else
                colossus_st()
            end
        end
        
        
    end
    
    
    return FrameworkEnd()
end

--## ARENA ENEMY STUFFS ##--

Pummel:Callback("arena", function(spell, enemy)
        if enemy:IsKickImmune() then return end
        if target.hp < 20 then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end
        
        return spell:Cast(enemy)
end)

Pummel:Callback("test", function(spell, enemy)
        if enemy.hp > 80 then return end
        
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
        if enemy.distance > 20 then return end
        if not enemy:IsTarget() then return end
        if enemy.stunDr < 0.5 then return end
        if enemyHealer.exists and enemy:IsUnit(enemyHealer) then return end
        if enemyHealer:CCRemains() < 2000 then return end
        --if enemy.hp > 50 then return end
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

--## ARENA PARTY STUFFS ##--
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
    SpellReflection("pvp-arena")
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

