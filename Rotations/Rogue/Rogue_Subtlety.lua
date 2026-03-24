--[[
Sub Rogue Comprehensive APL Implementation
Updated to match the complete SimulationCraft APL for optimal PvE rotation

APL Structure (Comprehensive):
- cds: Cold Blood, Symbols of Death, Shadow Blades, Thistle Tea, Flagellation
- race: Blood Fury, Berserking, Fireblood, Ancestral Call with racial_sync variable
- stealth_cds: Shadow Dance, Vanish, Shadowmeld with proper conditions
- finish: Secret Technique, Rupture (3 variants), Coup de Grace, Black Powder, Eviscerate
- build: Backstab/Gloomblade, Shadowstrike, Shuriken Tornado/Storm, Goremaws Bite
- fill: Racial abilities for energy management

Key Variables (Comprehensive):
- variable.stealth: buff.shadow_dance.up|buff.stealth.up|buff.vanish.up
- variable.targets: spell_targets.shuriken_storm
- variable.skip_rupture: buff.shadow_dance.up|buff.darkest_night.up|variable.targets>=8&!talent.replicating_shadows&talent.unseen_blade
- variable.maintenance: (dot.rupture.ticking|variable.skip_rupture)&(buff.slice_and_dice.up|variable.targets<=2)
- variable.secret: buff.shadow_dance.up|(cooldown.flagellation.remains<40&cooldown.flagellation.remains>20&talent.death_perception)
- variable.racial_sync: (buff.shadow_blades.up&buff.shadow_dance.up)|!talent.shadow_blades&buff.symbols_of_death.up|fight_remains<20
- variable.shd_cp: combo_points<=1|buff.darkest_night.up&combo_points>=7|effective_combo_points>=6&talent.unseen_blade

Finish Conditions:
- !buff.darkest_night.up&effective_combo_points>=6|buff.darkest_night.up&combo_points==cp_max_spend

Spell IDs:
- Coup de Grace: 441423
- Death Perception: 382513
- Lingering Darkness: 382524
]]

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 261 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local IsInPvp          = MakuluFramework.InPvpInstance 
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local _G, setmetatable = _G, setmetatable

local isInArena = false

local ActionID       = {
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

    AirborneIrritant       = { ID = 200733, Hidden = true },
    AtrophicPoison         = { ID = 381637 },
    Backstab               = { ID = 53, MAKULU_INFO = { damageType = "physical" } },
    BlackPowder            = { ID = 319175, MAKULU_INFO = { damageType = "physical" } },
    Blind                  = { ID = 2094, MAKULU_INFO = { damageType = "physical", cc = true } },
    CheapShot              = { ID = 1833, MAKULU_INFO = { damageType = "physical", cc = true } },
    CloakOfShadows         = { ID = 31224 },
    ColdBlood              = { ID = 382245, MAKULU_INFO = { offGcd = true } },
    CoupDeGrace            = { ID = 441423, MAKULU_INFO = { damageType = "physical" } },
    CrimsonVial            = { ID = 185311 },
    CripplingPoison        = { ID = 3408 },
    DanseMacabre           = { ID = 382528, Hidden = true },
    DeathFromAbove         = { ID = 269513, MAKULU_INFO = { damageType = "physical" } },
    DeathPerception        = { ID = 382513, Hidden = true },
    DeathstalkersMark      = { ID = 457052, Hidden = true },
    DeeperStratagem        = { ID = 193531, Hidden = true },
    Dismantle              = { ID = 207777, MAKULU_INFO = { damageType = "physical" } },
    Distract               = { ID = 1725 },
    EchoingReprimand       = { ID = 385616, FixedTexture = 3565450, MAKULU_INFO = { damageType = "physical" } },
    Elusiveness            = { ID = 79008, Hidden = true },
    Evasion                = { ID = 5277 },
    Eviscerate             = { ID = 196819, FixedTexture = 132292, MAKULU_INFO = { damageType = "physical" } },
    Feint                  = { ID = 1966 },
    Flagellation           = { ID = 384631, FixedTexture = 3565724, MAKULU_INFO = { damageType = "physical" } },
    FollowTheBlood         = { ID = 457068, Hidden = true },
    Gloomblade             = { ID = 200758, MAKULU_INFO = { damageType = "physical" } },
    GoremawsBite           = { ID = 426591, MAKULU_INFO = { damageType = "physical" } },
    Gouge                  = { ID = 1776, MAKULU_INFO = { damageType = "physical", cc = true } },
    ImprovedBackstab       = { ID = 319949, Hidden = true },
    ImprovedShadowDance    = { ID = 393972, Hidden = true },

    Inevitability          = { ID = 382512, Hidden = true },
    InstantPoison          = { ID = 315584 },
    InvigoratingShadowdust = { ID = 382523, Hidden = true },
    Kick                   = { ID = 1766, MAKULU_INFO = { damageType = "physical" } },
    KidneyShot             = { ID = 408, MAKULU_INFO = { damageType = "physical", cc = true } },
    LingeringDarkness      = { ID = 382524, Hidden = true },
    LingeringShadow        = { ID = 382524, Hidden = true },
    NumbingPoison          = { ID = 5761 },
    PickLock               = { ID = 1804 },
    PickPocket             = { ID = 921 },
    PoisedShadows          = { ID = 457533, Hidden = true },
    Premeditation          = { ID = 343160, Hidden = true },
    ReplicatingShadows     = { ID = 382506, Hidden = true },
    Reverberation          = { ID = 394332, Hidden = true },
    Rupture                = { ID = 1943, MAKULU_INFO = { damageType = "physical" } },
    Sap                    = { ID = 6770, MAKULU_INFO = { damageType = "physical", cc = true } },

    SecretStratagem        = { ID = 394320, Hidden = true },
    SecretTechnique        = { ID = 280719, MAKULU_INFO = { damageType = "physical" } },
    Sepsis                 = { ID = 385408, MAKULU_INFO = { damageType = "physical" } },
    ShadowBlades           = { ID = 121471, MAKULU_INFO = { damageType = "physical" } },

    ShadowDance            = { ID = 185313, MAKULU_INFO = { damageType = "physical" } },
    Shadowcraft            = { ID = 426594, Hidden = true },
    Shadowstep             = { ID = 36554 },
    Shadowstrike           = { ID = 185438, MAKULU_INFO = { damageType = "physical" } },
    ShadowyDuel            = { ID = 207736, MAKULU_INFO = { damageType = "physical" } },
    Shiv                   = { ID = 5938, MAKULU_INFO = { damageType = "physical" } },
    ShroudOfConcealment    = { ID = 114018 },
    ShurikenStorm          = { ID = 197835, MAKULU_INFO = { damageType = "physical" } },
    ShurikenTornado        = { ID = 277925, MAKULU_INFO = { damageType = "physical" } },
    ShurikenToss           = { ID = 114014, MAKULU_INFO = { damageType = "physical" } },
    SliceAndDice           = { ID = 315496 },
    SmokeBomb              = { ID = 359053, MAKULU_INFO = { damageType = "physical" } },
    Sprint                 = { ID = 2983 },
    Stealth                = { ID = 1784 },
    Subterfuge             = { ID = 108208, Hidden = true },
    SymbolsOfDeath         = { ID = 212283, MAKULU_INFO = { damageType = "physical" } },
    TheFirstDance          = { ID = 382505, Hidden = true },
    TheRotten              = { ID = 382015, Hidden = true },
    ThistleTea             = { ID = 381623 },
    TricksOfTheTrade       = { ID = 57934 },
    UnseenBlade            = { ID = 441146, Hidden = true },
    Vanish                 = { ID = 1856 },
    Vigor                  = { ID = 14983, Hidden = true },
    WoundPoison            = { ID = 8679 },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    ElementalPotion1 = { Type = "Potion", ID = 191387, Texture = 176108, Hidden = true },
    ElementalPotion2 = { Type = "Potion", ID = 191388, Texture = 176108, Hidden = true },
    ElementalPotion3 = { Type = "Potion", ID = 191389, Texture = 176108, Hidden = true },
    ElementalUltimate1 = { Type = "Potion", ID = 191381, Texture = 176108, Hidden = true },
    ElementalUltimate2 = { Type = "Potion", ID = 191382, Texture = 176108, Hidden = true },
    ElementalUltimate3 = { Type = "Potion", ID = 191383, Texture = 176108, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    PoolResource = { Type = "Spell", ID = 9999000010 },
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_ROGUE_SUBTLETY] = A

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
    imCasting = nil,
    shouldAoE = false,
    TWW1has2P = false,
    TWW1has4P = false,
    activeEnemies = 1,
    backstabEnemies = 0,
    inRaid = MakMulti.party:Size() > 5,
    rupturesBeforeFlag = false,
    ruptureCount = 0,
    maxSpend = 5,
    effectiveCp = 0,
    secretCondition = false,
    skipRupture = false,
    -- APL Variables
    shdCp = false,
    maintenance = false,
    secret = false,
    priorityRotation = false,
    targets = 1,
    stealth = false,
    fwTargets = 1,
}

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    instantPoison = 315584,
    woundPoison = 8679,
    cripplingPoison = 3408,
    numbingPoison = 5761,
    atrophicPoison = 381637,
    tricksOfTheTrade = 57934,
    sliceAndDice = 315496,
    symbolsOfDeath = 212283,
    theRotten = 394203,
    shadowDance = 185422,
    shadowBlades = 121471,
    flagellation = 384631,
    flagellationPersist = 394758,
    subterfuge = 115192,
    thistleTea = 381623,
    premeditation = 343173,
    darkestNight = 457280,
    echoingReprimand5 = 354838,
    echoingReprimand4 = 323560,
    echoingReprimand3 = 323559,
    shurikenTornado = 277925,
    lingeringShadow = 385960,
    danseMacabre = 393969,
    escalatingBlade = 441786,
    finalityRupture = 385951,
    flawlessForm = 441326,
    perforatedVeins = 394254,
    clearTheWitnesses = 457178,
    coldBlood = 382245,
    lingeringDarkness = 385960,
    flagellationBuff = 384631,
    poisedShadows = 457533,
    silentStorm = 385727,
    tww3Trickster4pc = 457533, -- Need to verify this ID
    vanish = 11327,
}

local debuffs = {
    exhaustion = 57723,
    rupture = 1943,
    deathstalkersMark = 457129,
    fazed = 441224,
    findWeakness = 316220,
}

local interrupts = {
    { spell = Kick },
    { spell = CheapShot, isCC = true, condition = function() return player.stealthed or player:Buff(buffs.shadowDance) end },
    { spell = KidneyShot, isCC = true },
    { spell = Blind, isCC = true, aoe = true, distance = 3, condition = function() return player:TalentKnown(AirborneIrritant.id) end },
    { spell = Gouge, isCC = true }
}

Player:AddTier("TWW1", { 212041, 212039, 212038, 212037, 212036 })

local function num(val)
    if val then return 1 else return 0 end
end

local function shouldBurst()
    if Action.BurstIsON("target") then
        --[[if A.Zone ~= "arena" and A.Zone ~= "pvp" then
            if target.isDummy or gs.inRaid then
                return true
            end
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if enemy.ttd >= A.GetToggle(2, "burstSens") * 1000 then
                    return true
                end
            end
        else
            return true
        end]]
        return true
    end
    return false
end

local constCell = cacheContext:getConstCacheCell()

local function enemiesInMelee(spellId)
    local cacheKey = spellId and ("enemiesInRangeWithDebuff_" .. spellId) or "enemiesInMelee"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 5 and not enemy:IsTotem() and not enemy.isPet then
                if spellId and enemy:DebuffRemains(spellId, true) > 6000 and Rupture:InRange(enemy) then
                    count = count + 1
                elseif not spellId then
                    count = count + 1
                end
            end
        end
        
        return count
    end)
end

local function activeEnemies()
    return math.max(enemiesInMelee(), 1)
end

local function enemiesInBackstab()
    return constCell:GetOrSet("enemiesInBackstab", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do 
            local enemy = MakUnit:new(enemyGUID) 
            if Backstab:InRange(enemy) and not enemy.isPet then 
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function nearbyTotem()
    return constCell:GetOrSet("nearbyTotem", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()

        for enemyGUID in pairs(activeEnemies) do 
            local enemy = MakUnit:new(enemyGUID) 
            if Backstab:InRange(enemy) and enemy:IsTotem() then 
                return true
            end 
        end  
        
        return false
    end)
end

local function autoTarget()
    if not player.inCombat then return false end

    if A.Zone == "pvp" or A.Zone == "arena" then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if A.GetToggle(2, "autoRupture") and gs.ruptureCount < gs.backstabEnemies and target:DebuffRemains(debuffs.rupture, true) > 6000 and not gs.skipRupture then
        return true
    end

    if not A.GetToggle(2, "autoTarget") then return false end

    --[[if nearbyTotem() and not target:IsTotem() then
        return true
    end]]

    if Backstab:InRange(target) and target.exists then return false end

    if gs.backstabEnemies > 0 then
        return true
    end
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

local function IsDisarmed(unitID)
    return unitID:Buff(236077)
end

local function ShouldWeDisarm(unitID)
    if unitID.isHealer then return false end
    if unitID.isFriendly then return false end
    if not unitID.isMelee then return false end
    if not unitID.cds or unitID.hp < player.hp + 10 then return false end
    if IsDisarmed(unitID) then return false end

    if unitID.cds or (healer.exists and healer.cc) then
        return true
    end
    return false
end

local function effectiveCP()
    local cp = player.cp
    local effectiveCp = cp

    if player:Buff(buffs["echoingReprimand" .. cp]) then
        effectiveCp = 5 + player:TalentKnownInt(DeeperStratagem.id) + player:TalentKnownInt(SecretStratagem.id)
    end

    if player:Buff(buffs.shadowDance) then
        if cp >= 5 then
            effectiveCp = 5 + player:TalentKnownInt(DeeperStratagem.id) + player:TalentKnownInt(SecretStratagem.id)
        end
    else
        if cp >= 6 then
            effectiveCp = 6 + player:TalentKnownInt(DeeperStratagem.id) + player:TalentKnownInt(SecretStratagem.id)
        end
    end

    return effectiveCp
end

local function usedForDanse(spell)
    if not player:Buff(buffs.shadowDance) then return false end

    if spell.used < ShadowDance.used then
        return true
    end

    return false
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId

    return currentCast
end

local lastUpdateTime = 0
local updateDelay = 0.8
local function updateGameState()
    local currentTime = GetTime()
    local currentCast = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    gs.TWW1has2P = Player:HasTier("TWW1", 2)
    gs.TWW1has4P = Player:HasTier("TWW1", 4)

    gs.shouldAoE = activeEnemies() >= 3 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gs.activeEnemies = activeEnemies()

    gs.backstabEnemies = enemiesInBackstab()

    gs.ruptureCount = enemiesInMelee(debuffs.rupture)

    gs.maxSpend = 5 + player:TalentKnownInt(DeeperStratagem.id) + player:TalentKnownInt(SecretStratagem.id)
    gs.effectiveCp = effectiveCP()

    -- SimC APL Variables (matching TWW3 profile exactly)
    -- variable,name=stealth,value=buff.shadow_dance.up|buff.stealth.up|buff.vanish.up
    gs.stealth = player:Buff(buffs.shadowDance) or player.stealthed or player:Buff(buffs.vanish)

    -- variable,name=targets,value=spell_targets.shuriken_storm
    gs.targets = gs.activeEnemies

    -- variable,name=skip_rupture,value=buff.shadow_dance.up|buff.darkest_night.up|variable.targets>=4&(!talent.replicating_shadows&talent.unseen_blade|raid_event.adds.up)
    gs.skipRupture = player:Buff(buffs.shadowDance) or player:Buff(buffs.darkestNight) or (gs.targets >= 4 and (not player:TalentKnown(ReplicatingShadows.id) and player:TalentKnown(UnseenBlade.id)))

    -- variable,name=maintenance,value=(dot.rupture.ticking|variable.skip_rupture)&(buff.slice_and_dice.up|variable.targets<=2)
    gs.maintenance = (target:DebuffRemains(debuffs.rupture, true) > 0 or gs.skipRupture) and (player:Buff(buffs.sliceAndDice) or gs.targets <= 2)

    -- variable,name=secret,value=buff.shadow_dance.up&!buff.darkest_night.up|(cooldown.flagellation.remains<60&cooldown.flagellation.remains>30&talent.death_perception&talent.unseen_blade)
    gs.secret = (player:Buff(buffs.shadowDance) and not player:Buff(buffs.darkestNight)) or (Flagellation.cd < 60000 and Flagellation.cd > 30000 and player:TalentKnown(DeathPerception.id) and player:TalentKnown(UnseenBlade.id))

    -- variable,name=racial_sync,value=(buff.shadow_blades.up&buff.shadow_dance.up)|!talent.shadow_blades&buff.symbols_of_death.up|fight_remains<20
    gs.racialSync = (player:Buff(buffs.shadowBlades) and player:Buff(buffs.shadowDance)) or (not player:TalentKnown(ShadowBlades.id) and player:Buff(buffs.symbolsOfDeath)) or (target.ttd < 20000 and target.ttd > 0)

    -- variable,name=shd_cp,value=combo_points<=1|buff.darkest_night.up&combo_points>=7|effective_combo_points>=6&talent.unseen_blade
    gs.shdCp = player.cp <= 1 or (player:Buff(buffs.darkestNight) and player.cp >= 7) or (gs.effectiveCp >= 6 and player:TalentKnown(UnseenBlade.id))

    gs.priorityRotation = A.GetToggle(2, "priority") or false
    gs.fwTargets = gs.activeEnemies
end

CloakOfShadows:Callback("arena", function(spell)
    if player.stealthed or not isInArena then return end

    if target.magicCds and (ActionUnit("player"):TimeToDieMagicX(25) >= 2 or player.hp < 40) then
        return spell:Cast(player)
    end
end)

InstantPoison:Callback(function(spell)
    if player.inCombat then return end
    if gs.imCasting then
        if gs.imCasting == spell.id or gs.imCasting == WoundPoison.id then return end
    end
    if player:BuffRemains(buffs.instantPoison) >= 60000 then return end
    if player:BuffRemains(buffs.woundPoison) >= 60000 then return end

    return spell:Cast(player)
end)

WoundPoison:Callback(function(spell)
    if player.inCombat then return end
    if gs.imCasting then
        if gs.imCasting == spell.id or gs.imCasting == InstantPoison.id then return end
    end
    if player:BuffRemains(buffs.instantPoison) >= 600000 then return end
    if player:BuffRemains(buffs.woundPoison) >= 600000 then return end

    return spell:Cast(player)
end)

NumbingPoison:Callback(function(spell)
    if player.inCombat then return end
    if gs.imCasting then
        if gs.imCasting == spell.id or gs.imCasting == CripplingPoison.id or gs.imCasting == AtrophicPoison.id then return end
    end
    if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end

    return spell:Cast(player)
end)

AtrophicPoison:Callback(function(spell)
    if player.inCombat then return end
    if gs.imCasting then
        if gs.imCasting == spell.id or gs.imCasting == CripplingPoison.id or gs.imCasting == NumbingPoison.id then return end
    end
    if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end

    return spell:Cast(player)
end)

CripplingPoison:Callback(function(spell)
    if player.inCombat then return end
    if gs.imCasting then
        if gs.imCasting == spell.id or gs.imCasting == NumbingPoison.id or gs.imCasting == AtrophicPoison.id then return end
    end
    if player:BuffRemains(buffs.cripplingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.numbingPoison) >= 600000 then return end
    if player:BuffRemains(buffs.atrophicPoison) >= 600000 then return end

    return spell:Cast(player)
end)

local function poisons()
    InstantPoison()
    WoundPoison()
    NumbingPoison()
    AtrophicPoison()
    CripplingPoison()
end

TricksOfTheTrade:Callback(function(spell)
    local playerstatus = UnitThreatSituation(player:CallerId())

    if (player.combatTime < 5 or ActionUnit("player"):IsTanking() or playerstatus == 3) and not A.IsInPvP then
        return spell:Cast(player)
    end
end)

Feint:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end
    
    if not player.inCombat then return end

    if shouldDefensive then
        return spell:Cast(player)
    end

    if player.hp < A.GetToggle(2, "feintHP") and not defensiveActive() then
        return spell:Cast(player)
    end
end)

Evasion:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    
    if not player.inCombat then return end

    local playerstatus = UnitThreatSituation(player:CallerId())

    if playerstatus == 3 and not player:Buff(buffs.tricksOfTheTrade) then
        return spell:Cast(player)
    end

    if player.hp < A.GetToggle(2, "evasionHP") and not defensiveActive() then
        return spell:Cast(player)
    end
end)

CloakOfShadows:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end

    if shouldDefensive() then
        return spell:Cast(player)
    end

    if player.hp < A.GetToggle(2, "cloakHP") and not defensiveActive() then
        return spell:Cast(player)
    end
end)

CrimsonVial:Callback(function(spell)
    if player.hp < A.GetToggle(2, "crimsonVialHP") then
        return spell:Cast(player)
    end
end)

Shiv:Callback(function(spell)
    if not target:BuffFrom(MakLists.pveEnrage) then return end

    return spell:Cast(target)
end)

Stealth:Callback(function(spell)
    if player.inCombat then return end
    if player.mounted then return end
    if player.stealthed then return end
    
    return spell:Cast(player)
end)

ColdBlood:Callback("cds", function(spell)
    -- cold_blood,if=cooldown.secret_technique.up&buff.shadow_dance.up&combo_points>=6&variable.secret&(buff.flagellation_persist.up|buff.flagellation_buff.remains<=3)
    if not player.inCombat then return end
    if SecretTechnique.cd > 0 then return end
    if not player:Buff(buffs.shadowDance) then return end
    if player.cp < 6 then return end
    if not gs.secret then return end
    if not (player:Buff(buffs.flagellationPersist) or player:BuffRemains(buffs.flagellationBuff) <= 3000) then return end

    return spell:Cast(player)
end)

SymbolsOfDeath:Callback("cds", function(spell)
    -- symbols_of_death,if=(buff.symbols_of_death.remains<=3.5&variable.maintenance&(variable.targets>1|raid_event.adds.up|!buff.flagellation_buff.up|dot.rupture.remains>=30)&(!talent.flagellation|cooldown.flagellation.remains>=30-15*!talent.death_perception&cooldown.secret_technique.remains<8|!talent.death_perception)|fight_remains<=15)
    if not player.inCombat then return end

    -- Don't cast if buff is already up (prevents wasting charges)
    if player:BuffRemains(buffs.symbolsOfDeath) > 3500 then return end

    local symbolsRemains = player:BuffRemains(buffs.symbolsOfDeath) <= 3500
    local maintenanceCondition = gs.maintenance
    local targetsOrFlagCondition = gs.targets > 1 or not player:Buff(buffs.flagellationBuff) or target:DebuffRemains(debuffs.rupture, true) >= 30000
    local flagellationCondition = not player:TalentKnown(Flagellation.id) or (Flagellation.cd >= (30000 - (15000 * (player:TalentKnown(DeathPerception.id) and 0 or 1))) and SecretTechnique.cd < 8000) or not player:TalentKnown(DeathPerception.id)
    local fightRemainsCondition = target.ttd <= 15000 and target.ttd > 0

    if (symbolsRemains and maintenanceCondition and targetsOrFlagCondition and flagellationCondition) or fightRemainsCondition then
        return spell:Cast(player)
    end
end)

ShadowBlades:Callback("cds", function(spell)
    -- shadow_blades,if=variable.maintenance&variable.shd_cp&buff.shadow_dance.up&!buff.premeditation.up
    if not player.inCombat then return end
    if not gs.maintenance then return end
    if not gs.shdCp then return end
    if not player:Buff(buffs.shadowDance) then return end
    if player:Buff(buffs.premeditation) then return end

    return spell:Cast(player)
end)

ThistleTea:Callback("cds", function(spell)
    -- thistle_tea,if=buff.shadow_dance.remains>4&!buff.thistle_tea.up
    if not player.inCombat then return end
    if player:BuffRemains(buffs.shadowDance) <= 4000 then return end
    if player:Buff(buffs.thistleTea) then return end

    return spell:Cast(player)
end)

Flagellation:Callback("cds", function(spell)
    -- flagellation,if=combo_points>=5&cooldown.shadow_blades.remains<=3|fight_remains<=25
    if not player.inCombat then return end
    if player.cp < 5 then return end

    local shadowBladesCondition = ShadowBlades.cd <= 3000
    local fightRemainsCondition = target.ttd <= 25000 and target.ttd > 0

    if shadowBladesCondition or fightRemainsCondition then
        return spell:Cast(target)
    end
end)

EchoingReprimand:Callback("cds", function(spell)
    if not player:Buff(buffs.sliceAndDice) then return end
    if player.cpDeficit < 3 then return end

    if not player:TalentKnown(TheRotten.id) or not player:TalentKnown(Reverberation.id) or player:Buff(buffs.shadowDance) then
        return spell:Cast(target)
    end
end)

ShurikenTornado:Callback("cds", function(spell)
    if not player:Buff(buffs.sliceAndDice) then return end

    if player:Buff(buffs.symbolsOfDeath) and player.cp <= 2 and not player:Buff(buffs.premeditation) and (not player:TalentKnown(Flagellation.id) or Flagellation.cd > 20000) and gs.activeEnemies >= 3 then
        return spell:Cast(player)
    end

    if not player:Buff(buffs.shadowDance) and not player:Buff(buffs.flagellation) and not player:Buff(buffs.flagellationPersist) and not player:Buff(buffs.shadowBlades) and gs.activeEnemies <= 2 then
        return spell:Cast(player)
    end
end)

Vanish:Callback("cds", function(spell)
    if not player.inCombat then return end
    if MakMulti.party:Size() < 2 and not target.isDummy then return end

    if player.stealthed then return end
    if not player:Buff(buffs.shadowDance) then return end
    if not player:TalentKnown(InvigoratingShadowdust.id) then return end
    if not player:TalentKnown(UnseenBlade.id) then return end
    if SecretTechnique.cd < 10000 then return end
    if player.cpDeficit <= 1 then return end

    if Flagellation.cd >= 60000 or not player:TalentKnown(Flagellation.id) then
        return spell:Cast(player)
    end

    if gs.inRaid and target.ttd <= 30000 * math.floor(spell.frac) and target.isBoss then
        return spell:Cast(player)
    end
end)

ShadowDance:Callback("cds", function(spell)
    if not player.inCombat then return end
    if gs.inRaid and target.ttd <= 8000 and target.isBoss then
        return spell:Cast(player)
    end

    if player:Buff(buffs.shadowDance) then return end
    if not player:TalentKnown(InvigoratingShadowdust.id) then return end
    if not player:Buff(buffs.shadowBlades) then return end

    if player:TalentKnown(DeathstalkersMark.id) and player:Buff(buffs.subterfuge) then
        return spell:Cast(player)
    end

    if gs.ruptureCount >= 1 and player:Buff(buffs.sliceAndDice) and player:TalentKnown(UnseenBlade.id) then
        return spell:Cast(player)
    end
end)



BloodFury:Callback("cds", function(spell)
    -- blood_fury,if=variable.racial_sync
    if not A.GetToggle(1, "Racial") then return end
    if not gs.racialSync then return end

    return spell:Cast(player)
end)

Berserking:Callback("cds", function(spell)
    -- berserking,if=variable.racial_sync
    if not A.GetToggle(1, "Racial") then return end
    if not gs.racialSync then return end

    return spell:Cast(player)
end)

Fireblood:Callback("cds", function(spell)
    -- fireblood,if=variable.racial_sync&buff.shadow_dance.up
    if not A.GetToggle(1, "Racial") then return end
    if not gs.racialSync then return end
    if not player:Buff(buffs.shadowDance) then return end

    return spell:Cast(player)
end)

AncestralCall:Callback("cds", function(spell)
    -- ancestral_call,if=variable.racial_sync
    if not A.GetToggle(1, "Racial") then return end
    if not gs.racialSync then return end

    return spell:Cast(player)
end)

local function cds()
    ColdBlood("cds")
    Sepsis("cds")
    Flagellation("cds")
    SymbolsOfDeath("cds")
    ShadowBlades("cds")
    EchoingReprimand("cds")
    ShurikenTornado("cds")
    Vanish("cds")
    ShadowDance("cds")
    GoremawsBite("cds")
    ThistleTea("cds")
    BloodFury("cds")
    Berserking("cds")
    Fireblood("cds")
    AncestralCall("cds")
end

SecretTechnique:Callback("finish", function(spell)
    -- secret_technique,if=variable.secret
    if player.cp < 5 then return end
    if not gs.secret then return end

    return spell:Cast(target)
end)

Rupture:Callback("finish", function(spell)
    -- rupture,if=!variable.skip_rupture&(!dot.rupture.ticking|refreshable|buff.flagellation_buff.up&!buff.symbols_of_death.up&variable.targets<=2)&target.time_to_die-remains>6&cooldown.flagellation.remains>=10
    if player.cp < 4 then return end
    if gs.skipRupture then return end

    local ruptureRemains = target:DebuffRemains(debuffs.rupture, true)
    local notTicking = ruptureRemains <= 0
    local refreshable = ruptureRemains <= 5400 -- 30% pandemic threshold
    local flagellationCondition = player:Buff(buffs.flagellationBuff) and not player:Buff(buffs.symbolsOfDeath) and gs.targets <= 2
    local ttdCondition = target.ttd == 0 or (target.ttd - ruptureRemains) > 6000
    local flagCdCondition = not player:TalentKnown(Flagellation.id) or Flagellation.cd >= 10000

    if (notTicking or refreshable or flagellationCondition) and ttdCondition and flagCdCondition then
        return spell:Cast(target)
    end
end)

Rupture:Callback("finish2", function(spell)
    -- rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.priority_rotation&target.time_to_die>=(2*combo_points)&refreshable&variable.targets>=2
    if gs.skipRupture then return end
    if gs.priorityRotation then return end
    if target.ttd < (2 * player.cp * 1000) and target.ttd > 0 then return end
    if target:DebuffRemains(debuffs.rupture, true) > 5400 then return end -- Not refreshable
    if gs.targets < 2 then return end

    return spell:Cast(target)
end)

CoupDeGrace:Callback("finish", function(spell)
    -- coup_de_grace,if=debuff.fazed.up&cooldown.flagellation.remains>=20|fight_remains<=10
    if not target:Debuff(debuffs.fazed) then return end

    local flagellationCondition = Flagellation.cd >= 20000
    local fightRemainsCondition = target.ttd <= 10000 and target.ttd > 0

    if flagellationCondition or fightRemainsCondition then
        return spell:Cast(target)
    end
end)

BlackPowder:Callback("finish", function(spell)
    -- black_powder,if=!variable.priority_rotation&variable.maintenance&(((variable.targets>=2&talent.deathstalkers_mark&(!buff.darkest_night.up|buff.shadow_dance.up&variable.targets>=5))|talent.unseen_blade&variable.targets>=4)|action.coup_de_grace.ready&variable.targets>=3)
    if gs.priorityRotation then return end
    if not gs.maintenance then return end

    local deathstalkersCondition = gs.targets >= 2 and player:TalentKnown(DeathstalkersMark.id) and (not player:Buff(buffs.darkestNight) or (player:Buff(buffs.shadowDance) and gs.targets >= 5))
    local unseenBladeCondition = player:TalentKnown(UnseenBlade.id) and gs.targets >= 4
    local coupDeGraceCondition = CoupDeGrace.cd <= 0 and gs.targets >= 3

    if deathstalkersCondition or unseenBladeCondition or coupDeGraceCondition then
        return spell:Cast(player)
    end
end)

Eviscerate:Callback("finish", function(spell)
    -- eviscerate,if=cooldown.flagellation.remains>=10|variable.targets>=3
    if player.cp < 5 then return end

    local flagellationCondition = Flagellation.cd >= 10000
    local targetsCondition = gs.targets >= 3

    if flagellationCondition or targetsCondition then
        return spell:Cast(target)
    end
end)

Eviscerate:Callback("finish2", function(spell)
    -- eviscerate (fallback - always spend at max CP)
    if player.cp < gs.maxSpend then return end

    return spell:Cast(target)
end)

local function finish()
    -- SimC APL finish priority order
    SecretTechnique("finish")            -- secret_technique,if=variable.secret
    Rupture("finish")                    -- rupture,if=!variable.skip_rupture&(!dot.rupture.ticking|refreshable|buff.flagellation_buff.up&!buff.symbols_of_death.up&variable.targets<=2)&target.time_to_die-remains>6&cooldown.flagellation.remains>=10
    Rupture("finish2")                   -- rupture,cycle_targets=1,if=!variable.skip_rupture&!variable.priority_rotation&target.time_to_die>=(2*combo_points)&refreshable&variable.targets>=2
    CoupDeGrace("finish")                -- coup_de_grace,if=debuff.fazed.up&cooldown.flagellation.remains>=20|fight_remains<=10
    BlackPowder("finish")                -- black_powder,if=!variable.priority_rotation&variable.maintenance&(((variable.targets>=2&talent.deathstalkers_mark&(!buff.darkest_night.up|buff.shadow_dance.up&variable.targets>=5))|talent.unseen_blade&variable.targets>=4)|action.coup_de_grace.ready&variable.targets>=3)
    Eviscerate("finish")                 -- eviscerate,if=cooldown.flagellation.remains>=10|variable.targets>=3
    Eviscerate("finish2")                -- eviscerate (fallback - always spend at max CP)
end

-- Build callbacks based on SimC APL priority
Backstab:Callback("build", function(spell)
    -- backstab,if=(talent.unseen_blade|variable.targets<=2)&(buff.shadow_dance.up&(buff.premeditation.up|buff.shadow_blades.up)&!used_for_danse|!variable.stealth&buff.shadow_blades.up)
    if not (player:TalentKnown(UnseenBlade.id) or gs.targets <= 2) then return end

    local shadowDanceCondition = player:Buff(buffs.shadowDance) and (player:Buff(buffs.premeditation) or player:Buff(buffs.shadowBlades)) and not usedForDanse(spell)
    local shadowBladesCondition = not gs.stealth and player:Buff(buffs.shadowBlades)

    if shadowDanceCondition or shadowBladesCondition then
        return spell:Cast(target)
    end
end)

Gloomblade:Callback("build", function(spell)
    -- gloomblade,if=buff.shadow_dance.up&!used_for_danse|!variable.stealth&buff.shadow_blades.up
    local shadowDanceCondition = player:Buff(buffs.shadowDance) and not usedForDanse(spell)
    local shadowBladesCondition = not gs.stealth and player:Buff(buffs.shadowBlades)

    if shadowDanceCondition or shadowBladesCondition then
        return spell:Cast(target)
    end
end)

Shadowstrike:Callback("build", function(spell)
    -- shadowstrike,cycle_targets=1,if=debuff.find_weakness.remains<=2&variable.targets=2&talent.unseen_blade|!used_for_danse&!talent.premeditation
    local findWeaknessCondition = target:DebuffRemains(debuffs.findWeakness) <= 2000 and gs.targets == 2 and player:TalentKnown(UnseenBlade.id)
    local dansePremediationCondition = not usedForDanse(spell) and not player:TalentKnown(Premeditation.id)

    if findWeaknessCondition or dansePremediationCondition then
        return spell:Cast(target)
    end
end)

ShurikenTornado:Callback("build", function(spell)
    -- shuriken_tornado,if=buff.lingering_darkness.up|talent.deathstalkers_mark&cooldown.shadow_blades.remains>=32&variable.targets>=3
    if not player:TalentKnown(spell.id) then return end

    local lingeringDarknessCondition = player:Buff(buffs.lingeringDarkness)
    local deathstalkersCondition = player:TalentKnown(DeathstalkersMark.id) and ShadowBlades.cd >= 32000 and gs.targets >= 3

    if lingeringDarknessCondition or deathstalkersCondition then
        return spell:Cast(player)
    end
end)

ShurikenTornado:Callback("build2", function(spell)
    -- shuriken_tornado,if=talent.unseen_blade&!buff.stealth.up&((buff.shadow_dance.up&!talent.shadowcraft&variable.targets>=3)|(talent.shadowcraft&variable.targets>=3)|!variable.stealth&variable.targets<=2)&(buff.symbols_of_death.up|!raid_event.adds.up)
    if not player:TalentKnown(UnseenBlade.id) then return end
    if player.stealthed then return end

    local shadowDanceCondition = player:Buff(buffs.shadowDance) and not player:TalentKnown(Shadowcraft.id) and gs.targets >= 3
    local shadowcraftCondition = player:TalentKnown(Shadowcraft.id) and gs.targets >= 3
    local lowTargetsCondition = not gs.stealth and gs.targets <= 2
    local symbolsCondition = player:Buff(buffs.symbolsOfDeath)

    if (shadowDanceCondition or shadowcraftCondition or lowTargetsCondition) and symbolsCondition then
        return spell:Cast(player)
    end
end)

ShurikenStorm:Callback("build", function(spell)
    -- shuriken_storm,if=buff.clear_the_witnesses.up&(variable.targets>=2|!buff.symbols_of_death.up)
    if not player:Buff(buffs.clearTheWitnesses) then return end

    local targetsCondition = gs.targets >= 2 or not player:Buff(buffs.symbolsOfDeath)

    if targetsCondition then
        return spell:Cast(player)
    end
end)

Shadowstrike:Callback("build2", function(spell)
    -- shadowstrike,cycle_targets=1,if=talent.deathstalkers_mark&!debuff.deathstalkers_mark.up&variable.targets>=3&(buff.shadow_blades.up|buff.premeditation.up|talent.the_rotten)
    if not player:TalentKnown(DeathstalkersMark.id) then return end
    if target:Debuff(debuffs.deathstalkersMark) then return end
    if gs.targets < 3 then return end

    local buffCondition = player:Buff(buffs.shadowBlades) or player:Buff(buffs.premeditation) or player:TalentKnown(TheRotten.id)

    if buffCondition then
        return spell:Cast(target)
    end
end)

ShurikenStorm:Callback("build2", function(spell)
    -- shuriken_storm,if=talent.deathstalkers_mark&variable.targets>=(2+3*buff.shadow_dance.up)
    if not player:TalentKnown(DeathstalkersMark.id) then return end

    local requiredTargets = 2 + (player:Buff(buffs.shadowDance) and 3 or 0)

    if gs.targets >= requiredTargets then
        return spell:Cast(player)
    end
end)

ShurikenStorm:Callback("build3", function(spell)
    -- shuriken_storm,if=talent.unseen_blade&(buff.flawless_form.up&variable.targets>=3&!variable.stealth|buff.silent_storm.up&variable.targets>=5&buff.shadow_dance.up)
    if not player:TalentKnown(UnseenBlade.id) then return end

    local flawlessCondition = player:Buff(buffs.flawlessForm) and gs.targets >= 3 and not gs.stealth
    local silentStormCondition = player:Buff(buffs.silentStorm) and gs.targets >= 5 and player:Buff(buffs.shadowDance)

    if flawlessCondition or silentStormCondition then
        return spell:Cast(player)
    end
end)

ShurikenStorm:Callback("build4", function(spell)
    -- shuriken_storm,if=(buff.tww3_trickster_4pc.up|buff.escalating_blade.stack=4)&!used_for_danse&(buff.shadow_blades.up|variable.targets>=4)
    local trickster4pcCondition = player:Buff(buffs.tww3Trickster4pc) or player:HasBuffCount(buffs.escalatingBlade) == 4
    local notDanseCondition = not usedForDanse(spell)
    local shadowBladesOrTargetsCondition = player:Buff(buffs.shadowBlades) or gs.targets >= 4

    if trickster4pcCondition and notDanseCondition and shadowBladesOrTargetsCondition then
        return spell:Cast(player)
    end
end)

Shadowstrike:Callback("build3", function(spell)
    -- shadowstrike (fallback)
    return spell:Cast(target)
end)

GoremawsBite:Callback("build", function(spell)
    -- goremaws_bite,if=combo_points.deficit>=3
    if player.cpDeficit < 3 then return end

    return spell:Cast(target)
end)

Gloomblade:Callback("build2", function(spell)
    -- gloomblade (fallback)
    return spell:Cast(target)
end)

Backstab:Callback("build2", function(spell)
    -- backstab (fallback)
    return spell:Cast(target)
end)

local function build()
    -- SimC APL build priority order
    Backstab("build")                    -- backstab,if=(talent.unseen_blade|variable.targets<=2)&(buff.shadow_dance.up&(buff.premeditation.up|buff.shadow_blades.up)&!used_for_danse|!variable.stealth&buff.shadow_blades.up)
    Gloomblade("build")                  -- gloomblade,if=buff.shadow_dance.up&!used_for_danse|!variable.stealth&buff.shadow_blades.up
    Shadowstrike("build")                -- shadowstrike,cycle_targets=1,if=debuff.find_weakness.remains<=2&variable.targets=2&talent.unseen_blade|!used_for_danse&!talent.premeditation
    ShurikenTornado("build")             -- shuriken_tornado,if=buff.lingering_darkness.up|talent.deathstalkers_mark&cooldown.shadow_blades.remains>=32&variable.targets>=3
    ShurikenTornado("build2")            -- shuriken_tornado,if=talent.unseen_blade&!buff.stealth.up&((buff.shadow_dance.up&!talent.shadowcraft&variable.targets>=3)|(talent.shadowcraft&variable.targets>=3)|!variable.stealth&variable.targets<=2)&(buff.symbols_of_death.up|!raid_event.adds.up)
    ShurikenStorm("build")               -- shuriken_storm,if=buff.clear_the_witnesses.up&(variable.targets>=2|!buff.symbols_of_death.up)
    Shadowstrike("build2")               -- shadowstrike,cycle_targets=1,if=talent.deathstalkers_mark&!debuff.deathstalkers_mark.up&variable.targets>=3&(buff.shadow_blades.up|buff.premeditation.up|talent.the_rotten)
    ShurikenStorm("build2")              -- shuriken_storm,if=talent.deathstalkers_mark&variable.targets>=(2+3*buff.shadow_dance.up)
    ShurikenStorm("build3")              -- shuriken_storm,if=talent.unseen_blade&(buff.flawless_form.up&variable.targets>=3&!variable.stealth|buff.silent_storm.up&variable.targets>=5&buff.shadow_dance.up)
    ShurikenStorm("build4")              -- shuriken_storm,if=(buff.tww3_trickster_4pc.up|buff.escalating_blade.stack=4)&!used_for_danse&(buff.shadow_blades.up|variable.targets>=4)
    Shadowstrike("build3")               -- shadowstrike (fallback)
    GoremawsBite("build")                -- goremaws_bite,if=combo_points.deficit>=3
    Gloomblade("build2")                 -- gloomblade (fallback)
    Backstab("build2")                   -- backstab (fallback)
end

Shadowstrike:Callback("stealthed", function(spell)
    if not Backstab:InRange(target) then return end

    if not player:TalentKnown(DeathstalkersMark.id) then return end
    if target:Debuff(debuffs.deathstalkersMark) then return end
    if player:Buff(buffs.darkestNight) then return end

    return spell:Cast(target)
end)

Shadowstrike:Callback("stealthed2", function(spell)
    if not Backstab:InRange(target) then return end

    if not usedForDanse(spell) and player:Buff(buffs.shadowBlades) then
        return spell:Cast(target)
    end

    if player:TalentKnown(UnseenBlade.id) and gs.activeEnemies >= 2 then
        return spell:Cast(target)
    end
end)

ShurikenStorm:Callback("stealthed", function(spell)
    if player:Buff(buffs.premeditation) then return end
    if gs.activeEnemies < 4 then return end

    return spell:Cast(player)
end)

Gloomblade:Callback("stealthed", function(spell)
    if player:BuffRemains(buffs.lingeringShadow) < 10 then return end
    if not player:Buff(buffs.shadowBlades) then return end
    if gs.activeEnemies > 1 then return end

    return spell:Cast(target)
end)

Shadowstrike:Callback("stealthed3", function(spell)
    if not Backstab:InRange(target) then return end

    return spell:Cast(target)
end)

local function stealthed()
    Shadowstrike("stealthed")
    if  (player:Buff(buffs.darkestNight) and player.cp == gs.maxSpend) or
        (gs.effectiveCp >= gs.maxSpend and not player:Buff(buffs.darkestNight)) or
        (player:Buff(buffs.shurikenTornado) and player.cpDeficit <= 2 and not player:Buff(buffs.darkestNight)) or
        (player.cpDeficit <= (1 + player:TalentKnownInt(DeathstalkersMark.id)) and not player:Buff(buffs.darkestNight))
        then
        finish()
    end
    Shadowstrike("stealthed2")
    ShurikenStorm("stealthed")
    Gloomblade("stealthed")
    Shadowstrike("stealthed3")
end

Vanish:Callback("stealthCds", function(spell)
    -- vanish,if=energy>=40&!buff.subterfuge.up&effective_combo_points<=3
    if not player.inCombat then return end
    if player.stealthed then return end
    if player.energy < 40 then return end
    if player:Buff(buffs.subterfuge) then return end
    if gs.effectiveCp > 3 then return end

    return spell:Cast(player)
end)

ShadowDance:Callback("stealthCds", function(spell)
    -- shadow_dance,if=(variable.shd_cp|!talent.premeditation)&variable.maintenance&(cooldown.secret_technique.remains<=24|talent.the_first_dance&buff.shadow_blades.up)&(buff.symbols_of_death.remains>=6|buff.shadow_blades.remains>=6)|fight_remains<=10
    if not player.inCombat then return end
    local shdCpCondition = gs.shdCp or not player:TalentKnown(Premeditation.id)
    if not shdCpCondition then return end
    if not gs.maintenance then return end

    local secretTechniqueCondition = SecretTechnique.cd <= 24000 or (player:TalentKnown(TheFirstDance.id) and player:Buff(buffs.shadowBlades))
    local buffCondition = player:BuffRemains(buffs.symbolsOfDeath) >= 6000 or player:BuffRemains(buffs.shadowBlades) >= 6000
    local fightRemainsCondition = target.ttd <= 10000 and target.ttd > 0

    if (secretTechniqueCondition and buffCondition) or fightRemainsCondition then
        return spell:Cast(player)
    end
end)



Shadowmeld:Callback("stealthCds", function(spell)
    -- shadowmeld,if=energy>=40&combo_points.deficit>=3
    if player.stealthed then return end
    if player.energy < 40 then return end
    if player.cpDeficit < 3 then return end

    return spell:Cast(player)
end)

local function stealthCds()
    -- SimC APL stealth_cds priority order
    ShadowDance("stealthCds")            -- shadow_dance,if=(variable.shd_cp|!talent.premeditation)&variable.maintenance&(cooldown.secret_technique.remains<=24|talent.the_first_dance&buff.shadow_blades.up)&(buff.symbols_of_death.remains>=6|buff.shadow_blades.remains>=6)|fight_remains<=10
    Vanish("stealthCds")                 -- vanish,if=energy>=40&!buff.subterfuge.up&effective_combo_points<=3
    Shadowmeld("stealthCds")             -- shadowmeld,if=energy>=40&combo_points.deficit>=3
end

-- Fill callbacks based on APL
ArcaneTorrent:Callback("fill", function(spell)
    -- arcane_torrent,if=energy.deficit>=15+energy.regen
    if not A.GetToggle(1, "Racial") then return end
    if not Backstab:InRange(target) then return end

    local energyRegen = GetPowerRegen()

    if player.energyDeficit >= 15 + energyRegen then
        return spell:Cast(player)
    end
end)

ArcanePulse:Callback("fill", function(spell)
    -- arcane_pulse
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

LightsJudgment:Callback("fill", function(spell)
    -- lights_judgment
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

BagOfTricks:Callback("fill", function(spell)
    -- bag_of_tricks
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(target)
end)

local function fill()
    -- APL fill priority order
    ArcaneTorrent("fill")                -- arcane_torrent,if=energy.deficit>=15+energy.regen
    ArcanePulse("fill")                  -- arcane_pulse
    LightsJudgment("fill")               -- lights_judgment
    BagOfTricks("fill")                  -- bag_of_tricks
end

SliceAndDice:Callback(function(spell)
    if player:Buff(buffs.sliceAndDice) then return end
    if player.cp < 1 then return end

    return spell:Cast(player)
end)

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

-- PVP Rotation Callbacks
Eviscerate:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player:Buff(buffs.darkestNight) == 0 then return end
    if player.cp ~= 7 then return end

    return spell:Cast(target)
end)

SecretTechnique:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player.cp < 5 then return end
    if player:Buff(buffs.shadowDance) == 0 then return end

    return spell:Cast(target)
end)

SecretTechnique:Callback("PVP1_2", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player.cp < 5 then return end
    if ShadowBlades.cd <= 28000 then return end
    if player:Buff(buffs.shadowDance) == 0 then return end
    if player:Buff(buffs.symbolsOfDeath) == 0 then return end
    if player:HasBuffCount(buffs.danseMacabre) == 0 then return end

    return spell:Cast(target)
end)

Rupture:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player.cp < 5 then return end
    if target:DebuffRemains(debuffs.rupture, true) > 1000 then return end

    return spell:Cast(target)
end)

KidneyShot:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player.cp < 5 then return end
    if not player.inCombat then return end
    if target:Debuff(spell.id) then return end
    if target.stunDr ~= 1 then return end

    return spell:Cast(target)
end)

SliceAndDice:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player.cp < 5 then return end
    if player:BuffRemains(buffs.sliceAndDice) >= 1000 then return end
    if player.combatTime <= 10000 then return end

    return spell:Cast(player)
end)

Eviscerate:Callback("PVP1_2", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if player.cp < 5 then return end
    if player:Buff(buffs.darkestNight) then return end

    return spell:Cast(target)
end)

ThistleTea:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.thistleTea) then return end
    if player:Buff(buffs.shadowDance) == 0 then return end

    return spell:Cast(player)
end)

SymbolsOfDeath:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.shadowDance) == 0 then return end
    if player:Buff(buffs.symbolsOfDeath) then return end
    -- Only use if we have 2 charges OR Shadow Dance is about to end (save 1 charge)
    if spell.charges < 2 and player:BuffRemains(buffs.shadowDance) > 3000 then return end

    return spell:Cast(player)
end)

ShadowBlades:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.shadowDance) == 0 then return end

    return spell:Cast(player)
end)

SmokeBomb:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not player.inCombat then return end
    if not Backstab:InRange(target) then return end
    if target.hp > 17 then return end

    return spell:Cast(player)
end)

Shadowstrike:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not Backstab:InRange(target) then return end
    if player.inCombat then return end
    if not player.stealthed then return end

    return spell:Cast(target)
end)

Flagellation:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player.combatTime <= 5000 then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.stealth) == 0 and player:Buff(buffs.shadowDance) == 0 then return end

    return spell:Cast(target)
end)

CheapShot:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not spell:InRange(target) then return end
    if target:Debuff(KidneyShot.id) then return end
    if target:Debuff(spell.id) then return end
    if target.stunDr < 0.25 then return end

    return spell:Cast(target)
end)

ShadowDance:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.shadowDance) then return end
    if target:Debuff(CheapShot.id) == 0 and target:Debuff(KidneyShot.id) == 0 then return end

    return spell:Cast(player)
end)

Shadowstrike:Callback("PVP1_2", function(spell)
    if not InPvP() then return end
    if not player.inCombat then return end
    if player:Buff(buffs.stealth) == 0 and player:Buff(Vanish.id) == 0 and player:Buff(buffs.shadowDance) == 0 then return end

    return spell:Cast(target)
end)

ShadowDance:Callback("PVP1_2", function(spell)
    if not InPvP() then return end
    if player.combatTime <= 5000 then return end
    if not Backstab:InRange(target) then return end
    if not player.inCombat then return end
    if player:Buff(buffs.shadowDance) then return end
    if not SymbolsOfDeath:Usable() then return end

    return spell:Cast(player)
end)

GoremawsBite:Callback("PVP1", function(spell)
    if not InPvP() then return end

    return spell:Cast(target)
end)

ShurikenStorm:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not player.inCombat then return end
    if not Backstab:InRange(target) then return end
    if player:Buff(buffs.clearTheWitnesses) == 0 and activeEnemies() < 2 then return end

    return spell:Cast(player)
end)

Gloomblade:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player:Buff(buffs.stealth) then return end

    return spell:Cast(target)
end)

Backstab:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if activeEnemies() ~= 1 then return end

    return spell:Cast(target)
end)

Stealth:Callback("PVP1", function(spell)
    if not InPvP() then return end

    return spell:Cast(player)
end)

WoundPoison:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player:Buff(buffs.woundPoison) then return end

    return spell:Cast(player)
end)

InstantPoison:Callback("PVP1", function(spell)
    if InPvP() then return end
    if player:Buff(buffs.instantPoison) then return end

    return spell:Cast(player)
end)

CripplingPoison:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player:Buff(buffs.cripplingPoison) then return end

    return spell:Cast(player)
end)

CrimsonVial:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player.hp > 85 then return end

    return spell:Cast(player)
end)

Evasion:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if player.hp > 33 then return end

    return spell:Cast(player)
end)

Vanish:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if math.floor(spell.frac) ~= 2 then return end
    if player.hp > 18 then return end

    return spell:Cast(player)
end)

Vanish:Callback("PVP1_2", function(spell)
    if not InPvP() then return end
    if math.floor(spell.frac) ~= 1 then return end
    if player.hp > 8 then return end

    return spell:Cast(player)
end)

Feint:Callback("PVP1", function(spell)
    if not InPvP() then return end
    if not player.inCombat then return end
    if not player:TalentKnown(Elusiveness.id) then return end
    if player:Buff(spell.id) then return end
    if player.hp > 45 then return end

    return spell:Cast(player)
end)

local function PVPRotation()
    if not InPvP() then return end

    -- Defensives
    CrimsonVial("PVP1")
    Evasion("PVP1")
    Vanish("PVP1")
    Vanish("PVP1_2")
    Feint("PVP1")

        -- Burst
    ThistleTea("PVP1")
    SymbolsOfDeath("PVP1")
    ShadowBlades("PVP1")
    SmokeBomb("PVP1")

    -- Cooldowns
    Flagellation("PVP1")
    ShadowDance("PVP1")
    ShadowDance("PVP1_2")

    -- Finishers (5+ combo points)
    KidneyShot("PVP1")
    SecretTechnique("PVP1")
    SecretTechnique("PVP1_2")
    Eviscerate("PVP1")
    Rupture("PVP1")
    SliceAndDice("PVP1")
    Eviscerate("PVP1_2")

    -- Stealth Opener
    CheapShot("PVP1")
    Shadowstrike("PVP1")
    Shadowstrike("PVP1_2")

    -- Builders
    GoremawsBite("PVP1")
    ShurikenStorm("PVP1")
    Gloomblade("PVP1")
    Backstab("PVP1")

   
end

A[3] = function(icon)
	FrameworkStart(icon)
    _, isInArena = IsInPvp()
    updateGameState()
    
    local makAlert = A.GetToggle(2, "makAware")

    if makAlert[1] then
        if not player.inCombat then
            if (player:BuffRemains(buffs.instantPoison) < 600000 and player:BuffRemains(buffs.woundPoison) < 600000) or (player:BuffRemains(buffs.cripplingPoison) < 600000 and player:BuffRemains(buffs.numbingPoison) < 600000 and player:BuffRemains(buffs.atrophicPoison) < 600000) then
                Aware:displayMessage("Applying Poisons!", "Green", 1)
            end
        end
    end

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Enemies in Melee (always min 1): ", gs.activeEnemies)
        MakPrint(2, "Melee with Rupture: ", gs.ruptureCount)
        MakPrint(3, "In Raid: ", gs.inRaid)
        MakPrint(4, "Vanish Charges: ", math.floor(Vanish.frac))
        MakPrint(5, "Effective CP: ", gs.effectiveCp)
        MakPrint(6, "Target TTD: ", target.ttd)
        MakPrint(7, "Should Burst: ", shouldBurst())
        MakPrint(8, "Stealthed: ", player.stealthed)
        MakPrint(9, "Secret Technique: ", gs.secretCondition)
        MakPrint(10, "APL Variables - ShdCp: ", gs.shdCp, " Maintenance: ", gs.maintenance, " Secret: ", gs.secret)
        MakPrint(11, "APL Variables - Targets: ", gs.targets, " Stealth: ", gs.stealth, " SkipRupture: ", gs.skipRupture)
    end

    makInterrupt(interrupts)

    
    TricksOfTheTrade()
    Evasion()
    CloakOfShadows()
    CloakOfShadows("arena")
    CrimsonVial()

    if InPvP() then 

        -- Poisons
        Stealth("PVP1")
        WoundPoison("PVP1")
        CripplingPoison("PVP1")


        if target.exists and target.canAttack then
            PVPRotation()
        end

    end

    if NotInPvP() and target.exists and target.canAttack and ShurikenToss:InRange(target) then
        Shiv()
        poisons()
        Stealth()

        -- SimC APL action list order
        -- Potion (if burst is on)
        if shouldBurst() then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player.bloodlust or target.ttd <= 30000 and target.ttd > 0 or player:Buff(buffs.flagellationBuff)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        -- call_action_list,name=cds
        cds()

        -- call_action_list,name=race (handled in cds function)

        -- call_action_list,name=item (trinkets)
        if shouldBurst() then
            local shouldTrinket = player:Buff(buffs.shadowBlades) or target.ttd <= 20000 and target.ttd > 0
            if shouldTrinket then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
        end

        -- call_action_list,name=stealth_cds,if=!variable.stealth
        if not gs.stealth then
            stealthCds()
        end

        -- Slice and Dice maintenance
        SliceAndDice()

        -- Stealthed rotation
        if player.stealthed or player:Buff(buffs.shadowDance) or player:Buff(buffs.subterfuge) then
            stealthed()
        end

        -- call_action_list,name=finish,if=!buff.darkest_night.up&effective_combo_points>=6|buff.darkest_night.up&combo_points==cp_max_spend|action.coup_de_grace.ready&cooldown.secret_technique.remains>0
        local finishCondition1 = not player:Buff(buffs.darkestNight) and player.cp >= 5
        local finishCondition2 = player:Buff(buffs.darkestNight) and player.cp == gs.maxSpend
        local finishCondition3 = CoupDeGrace.cd <= 0 and SecretTechnique.cd > 0

        if finishCondition1 or finishCondition2 or finishCondition3 then
            finish()
        end

        -- call_action_list,name=build
        if Backstab:InRange(target) then
            build()
        end

        -- call_action_list,name=fill,if=!variable.stealth
        if not gs.stealth then
            fill()
        end

        --local autoAttack = C_Spell.IsCurrentSpell(6603)
        --if not autoAttack and Backstab:InRange(target) then return A.Backstab:Show(icon) end

    end

	return FrameworkEnd()
end

CheapShot:Callback("pvp-non-target-full", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.75 then return end
    if not who.cds and not who.magicCds then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-non-target-full", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.75 then return end
    if not who.cds and not who.magicCds then return end
    if player.cp < 4 then return end

    return spell:Cast(who)
end)

Kick:Callback("pvp-kick-healer", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not who.isHealer then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.totalImmune then return end

    if Kick:InRange(who) then
        return spell:Cast(who)
    elseif Shadowstep:Usable(who) and not Blind:InRange(who) and ((arena1.exists and arena1.hp < 30) or (arena2.exists and arena2.hp < 30) or (arena3.exists and arena3.hp < 30)) then
        return Shadowstep:Cast(who)
    end
end)

Blind:Callback("pvp-kick-healer-full", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not who.isHealer then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.totalImmune then return end
    if who.disorientDr < 0.75 then return end

    if Blind:InRange(who) then
        return spell:Cast(who)
    end
end)

Kick:Callback("pvp-kick-dps", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.totalImmune then return end

    if Kick:InRange(who) then
        return spell:Cast(who)
    end
end)

CheapShot:Callback("pvp-kick", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.stunDr < 0.5 then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-kick", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not KidneyShot:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.stunDr < 0.5 then return end
    if player.cp < 4 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("pvp-half-dr", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.5 then return end
    if not who.cds and not who.magicCds then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-half-dr", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not KidneyShot:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.5 then return end
    if not who.cds or not who.magicCds then return end
    if player.cp < 4 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("pvp-opener", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.75 then return end
    if player.hp > who.hp then return end

    return spell:Cast(who)
end)

Shadowstep:Callback("to-kill", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Shadowstep:InRange(who) or Blind:InRange(who) then return end
    if who.totalImmune or who.hp > 30 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("pvp-to-kill", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.3 then return end
    if who.hp > 30 then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-to-kill", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.3 then return end
    if who.hp > 30 then return end
    if player.cp < 3 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("pvp-dying", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.3 then return end
    if player.hp > 40 then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-dying", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.3 then return end
    if player.cp < 2 then return end
    if player.hp > 40 then return end

    return spell:Cast(who)
end)

Blind:Callback("pvp-kill", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Blind:InRange(who) or who.isTarget then return end
    if who.totalImmune or who.ccImmune then return end
    if who.disorientDr < 0.5 then return end
    if not who.pvpKick or not who.safeToKick then return end
    if target.hp > 40 then return end

    return spell:Cast(who)
end)

Sap:Callback("pvp-open", function(spell, who)
    if player.inCombat or who.inCombat then return end
    if not player.stealthed then return end
    if not Sap:Usable(who) or who:Distance() > 10 then return end

    return spell:Cast(who)
end)

Dismantle:Callback("pvp-disarm", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Dismantle:InRange(who) then return end
    if who:Buff(446035) then return end
    if who.totalImmune then return end
    if not ShouldWeDisarm(who) then return end

    Aware:displayMessage("Diarming!", "Green", 2.5)

    return spell:Cast(who)
end)

KidneyShot:Callback("pvp-low-hp", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if player.hp > 60 then return end
    if player.cp < 3 then return end
    if who.stunDr < 0.3 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("pvp-low-hp", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.5 then return end
    if player.hp > 60 then return end

    return spell:Cast(who)
end)

Gouge:Callback("pvp-kick-healer", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.incapacitateDr < 0.5 then return end
    if not Player:IsBehind(.3) then return end
    if not who.isHealer then return end
    if not who.pvpKick or not who.safeToKick then return end

    return spell:Cast(who)
end)

Gouge:Callback("pvp-kick-dps", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.incapacitateDr < 0.5 then return end
    if not Player:IsBehind(.3) then return end
    if who.isHealer then return end
    if not who.pvpKick or not who.safeToKick then return end

    return spell:Cast(who)
end)

Gouge:Callback("pvp-low-hp", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Flagellation:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.incapacitateDr < 0.5 then return end
    if not Player:IsBehind(.3) then return end
    if who.isHealer then return end
    if player.hp > 50 then return end

    return spell:Cast(who)
end)

Blind:Callback("pvp-cc-heal-burst", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Blind:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.disorientDr < 0.5 then return end
    if not who.pvpKick or not who.safeToKick then return end
    if who.isHealer then return end

    return spell:Cast(who)
end)

Gouge:Callback("full-dr-healer", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Gouge:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.incapacitateDr < 0.9 then return end
    if not who.isHealer then return end
    if who.cc and who.ccRemains > 500 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("full-dr-healer", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.9 then return end
    if not who.isHealer then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("full-dr-healer", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not KidneyShot:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.9 then return end
    if not who.isHealer then return end
    if player.cp < 5 then return end

    return spell:Cast(who)
end)

Gouge:Callback("full-dr-dps", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not Gouge:InRange(who) then return end
    if who.totalImmune or who.ccImmune then return end
    if who.incapacitateDr < 0.9 then return end
    if who.isHealer then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.hp < player.hp + 5 then return end

    return spell:Cast(who)
end)

CheapShot:Callback("full-dr-dps", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not CheapShot:InRange(who) or not (player:Buff(buffs.stealth) or player:Buff(buffs.vanish)) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.9 then return end
    if who.isHealer then return end
    if who.hp < player.hp + 5 then return end

    return spell:Cast(who)
end)

KidneyShot:Callback("full-dr-dps", function(spell, who)
    if not who.exists or not who.canAttack then return end
    if not KidneyShot:InRange(who) then return end
    if who.cc and who.ccRemains > 500 then return end
    if who.totalImmune or who.ccImmune then return end
    if who.stunDr < 0.9 then return end
    if who.isHealer then return end
    if player.cp < 5 then return end
    if who.hp < player.hp + 5 then return end

    return spell:Cast(who)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end

    CheapShot("pvp-non-target-full", enemy)
    if not player.stealthed then
        Kick("pvp-kick-healer", enemy)
        KidneyShot("pvp-non-target-full", enemy)
        Gouge("pvp-kick-healer", enemy)
        Blind("pvp-kick-healer-full", enemy)
    end

    CheapShot("pvp-half-dr", enemy)
    if not player.stealthed then
        Kick("pvp-kick-dps", enemy)
        KidneyShot("pvp-half-dr", enemy)
        Gouge("pvp-kick-dps", enemy)
    end

    CheapShot("pvp-opener", enemy)
    CheapShot("pvp-to-kill", enemy)
    CheapShot("pvp-dying", enemy)
    if not player.stealthed then
        Gouge("pvp-low-hp", enemy)
        Shadowstep("to-kill", enemy)
        KidneyShot("pvp-to-kill", enemy)
        KidneyShot("pvp-dying", enemy)
        KidneyShot("pvp-kick", enemy)
        Blind("pvp-kill", enemy)
    end

    CheapShot("pvp-kick", enemy)
    Sap("pvp-open", enemy)
    Dismantle("pvp-disarm", enemy)

    CheapShot("pvp-low-hp", enemy)

    if not player.stealthed then
        KidneyShot("pvp-low-hp", enemy)
        Blind("pvp-cc-heal-burst", enemy)
        Gouge("full-dr-healer", enemy)
        KidneyShot("full-dr-healer", enemy)
        Gouge("full-dr-dps", enemy)
        KidneyShot("full-dr-dps", enemy)
    end
    CheapShot("full-dr-healer", enemy)
    CheapShot("full-dr-dps", enemy)
end


local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end

end

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
	enemyRotation(arena1)
	partyRotation(party1)

	return FrameworkEnd()
end

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
