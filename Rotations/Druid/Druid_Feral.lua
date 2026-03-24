if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 103 then return end

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
local cacheContext     = MakuluFramework.Cache
local Debounce         = MakuluFramework.debounceSpell
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware
local NeedRaidBuff     = MakuluFramework.NeedRaidBuff

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local LoC = Action.LossOfControl

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable
local FakeCasting      = MakuluFramework.FakeCasting

local ActionID       = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { offGcd = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { offGcd = true } },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { offGcd = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { offGcd = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { offGcd = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { offGcd = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { offGcd = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { offGcd = true } },
    WarStomp = { ID = 20549, MAKULU_INFO = { offGcd = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { offGcd = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { offGcd = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { offGcd = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { offGcd = true } },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { offGcd = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { offGcd = true } },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { offGcd = true } },
    Fireblood = { ID = 265221, MAKULU_INFO = { offGcd = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { offGcd = true } },
    BullRush = { ID = 255654, MAKULU_INFO = { offGcd = true } },
    AncestralCall = { ID = 274738, MAKULU_INFO = { offGcd = true } },
    Haymaker = { ID = 287712, MAKULU_INFO = { offGcd = true } },
    Regeneratin = { ID = 291944, MAKULU_INFO = { offGcd = true } },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { offGcd = true } }, 
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { offGcd = true } },
    
    Mangle = { ID = 33917, MAKULU_INFO = { damageType = "physical" } },   
    Shred = { ID = 5221, MAKULU_INFO = { damageType = "physical" } },
    Wrath = { ID = 190984, MAKULU_INFO = { damageType = "magic" } },
    MoonfireCat = { ID = 155625, MAKULU_INFO = { damageType = "magic" } },   
    Regrowth = { ID = 8936, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },  
    EntanglingRoots = { ID = 339, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm][]spell:thisID" },  
    CatForm = { ID = 768 },  
    BearForm = { ID = 5487 },  
    TravelForm = { ID = 783 },  
    MoonkinForm = { ID = 24858 },  
    Dash = { ID = 1850 },  
    Ironfur = { ID = 192081 },  
    FerociousBite = { ID = 22568, FixedTexture = 132127, { damageType = "physical" } },  
    MarkoftheWild = { ID = 1126, Macro = "/cast [@target,exists][@focus,exists][@player][]spell:thisID" },  
    Growl = { ID = 6795 },  
    Barkskin = { ID = 22812 },  
    Prowl = { ID = 5215 },  
    Revive = { ID = 50769, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },  
    Rake = { ID = 1822, MAKULU_INFO = { damageType = "physical" } },  
    FrenziedRegeneration = { ID = 22842 },  
    Starfire = { ID = 194153, MAKULU_INFO = { damageType = "magic" } },  
    Rejuvenation = { ID = 774, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },  
    ThrashCat = { ID = 106830, MAKULU_INFO = { damageType = "physical" } },  
    Swiftmend = { ID = 18562, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },  
    Rip = { ID = 1079, MAKULU_INFO = { damageType = "physical" } },  
    SwipeCat = { ID = 213764, MAKULU_INFO = { damageType = "physical" } },  
    RemoveCorruption = { ID = 2782, Macro = "/cast [@target,exists][@focus,exists][]spell:thisID" },  
    Maim = { ID = 22570, MAKULU_INFO = { damageType = "physical" } },  
    MaimArena = { ID = 22570, Hidden = true, FixedTexture = 133663, MAKULU_INFO = { damageType = "physical" } },  
    Hibernate = { ID = 2637, MAKULU_INFO = { damageType = "magic" } },  
    SkullBash = { ID = 106839, MAKULU_INFO = { damageType = "physical" } },  
    WildCharge = { ID = 102401 },  
    Cyclone = { ID = 33786, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },  
    Soothe = { ID = 2908, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },  
    Sunfire = { ID = 93402, MAKULU_INFO = { damageType = "magic" } },  
    Typhoon = { ID = 132469, MAKULU_INFO = { damageType = "magic" } },  
    StampedingRoar = { ID = 106898 },  
    WildGrowth = { ID = 48438, Macro = "/cast [@target,help][@focus,help][@player][]spell:thisID" },  
    IncapacitatingRoar = { ID = 99 },  
    MightyBash = { ID = 5211, MAKULU_INFO = { damageType = "physical" } },  
    MassEntanglement = { ID = 102359, MAKULU_INFO = { damageType = "magic" } },  
    UrsolsVortex = { ID = 102793 },  
    Renewal = { ID = 108238 },  
    Innervate = { ID = 29166, Macro = "/cast [@mouseover,help][@focus,help][]spell:thisID" },  
    HeartOfTheWild = { ID = 319454 },  
    NaturesVigil = { ID = 124974 },
    Rebirth = { ID = 20484 },
    
    TigersFury = { ID = 5217 },
    PrimalWrath = { ID = 285381, MAKULU_INFO = { damageType = "physical" } },
    Berserk = { ID = 106951 },
    AdaptiveSwarm = { ID = 391888, MAKULU_INFO = { damageType = "magic" } },
    ConvokeTheSpirits = { ID = 391528, MAKULU_INFO = { damageType = "physical" } },
    Incarnation = { ID = 102543 },
    FeralFrenzy = { ID = 274837, MAKULU_INFO = { damageType = "physical" } },
    BrutalSlash = { ID = 202028, MAKULU_INFO = { damageType = "physical" } },
    
    FaerieSwarm = { ID = 209749 },     
    Thorns = { ID = 305497 },   
    
    ThrashingClaws = { ID = 405300, Hidden = true },
    LunarInspiration = { ID = 155580, Hidden = true },
    Bloodtalons = { ID = 319439, Hidden = true },
    MomentOfClarity = { ID = 236068, Hidden = true },
    RavageTalent = { ID = 441583, Hidden = true },
    ThrivingGrowth = { ID = 439528, Hidden = true },
    UnbridledSwarm = { ID = 391951, Hidden = true },
    RagingFury = { ID = 391078, Hidden = true },
    Veinripper = { ID = 391978, Hidden = true },
    DoubleClawedRake = { ID = 391700, Hidden = true },
    WildSlashes = { ID = 390864, Hidden = true },
    BerserkHeartOfTheLion = { ID = 391174, Hidden = true },
    RampartFerocity = { ID = 391709, Hidden = true },
    Ravage = { ID = 391709, Hidden = true },
    AshamanesGuidance = { ID = 391548, Hidden = true },
    RampantFerocity = { ID = 391709, Hidden = true },
    EmpoweredShapeshifting = { ID = 441689, Hidden = true },
    SavageFury = { ID = 449645, Hidden = true },
    FluidForm = { ID = 449193, Hidden = true },
    CoiledToSpring = { ID = 449537, Hidden = true },
    RipAndTear = { ID = 391347, Hidden = true },
    CircleOfLifeAndDeath = { ID = 391969, Hidden = true },
    
    PoolResource = { ID = 8936, Texture = 202021, MAKULU_INFO = { ignoreResource = true }, Hidden = true },
    
    RegrowthParty = { ID = 8936, Hidden = true, FixedTexture = 133667 }, -- Universal1
    
    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DRUID_FERAL] = A

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
}

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    suddenAmbush = 391974,
    clearcasting = 135700,
    incarnation = 102543,
    shadowmeld = 58984,
    prowl = 5215,
    catForm = 768,
    bearForm = 5487,
    travelForm = 783,
    tigersFury = 5217,
    bloodtalons = 145152,
    ravage = 441585,
    predatorySwiftness = 69369,
    berserk = 106951,
    apexPredatorsCraving = 391882,
    frenziedRegeneration = 22842,
    coiledToSpring = 449538,
}

local debuffs = {
    exhaustion = 57723,
    thrashCat = 405233,
    moonfireCat = 155625,
    rake = 155722,
    rip = 1079,
    adaptiveSwarm = 391889,
    bloodseekerVines = 439531,
}

local interrupts = {
    { spell = SkullBash },
    { spell = IncapacitatingRoar, isCC = true, aoe = true, distance = 3 },
}

Player:AddTier("TWW1", { 212059, 212057, 212056, 212055, 212054 })

local function num(val)
    if val then return 1 else return 0 end
end

-- A.RegisterPMultiplier(
--     Rake.id,     
--     debuffs.rake, 
--     {function ()
--             return player.stealthed and 1.6 or 1
--     end},
--     {145152, 1.2}, {52610, 1.15}, {5217, 1.15} -- BloodTalons, Savage Roar, Tiger's Fury
-- )

local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local count = 0
            local dur = dur or 0
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Shred:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function activeEnemies()
    return math.max(enemiesInRange(), 1)
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()
    
    if player.channeling then return false end
    return makShouldDefensive() < 2000 and not defensiveActive() 
end

local function getBelowHP(percent)
    return MakMulti.party:Count(function(unit)
            return Regrowth:InRange(unit) and unit.hp < percent and unit.hp > 0
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

local function orbsActive()
    local cacheKey = "orbsActive"
    
    return constCell:GetOrSet(cacheKey, function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                local enemyCast = enemy.castInfo
                local orb = enemyCast and enemyCast.spellId == 461904
                if MoonfireCat:InRange(enemy) and orb then
                    return true
                end
            end
            
            return false
    end)
end

local function rakeInRange()
    return constCell:GetOrSet("rakeInRange", function() 
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Rake:InRange(enemy) and not enemy.isPet then
                    total = total + 1
                end
            end
            
            return total
    end)
end

local function debuffCount(spellId)
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local debuffCount = 0
    
    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if enemy:Debuff(spellId, true) then 
            debuffCount = debuffCount + 1
        end 
    end  
    
    return debuffCount
end

local function shouldStayBear()
    --if Action.Zone ~= "arena" then return false end
    if player:Buff(buffs.frenziedRegeneration) then return true end
    if player.hp < 60 then return true end
    
    return false
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
    
    if gs.rakeRefreshable then return false end
    
    if A.GetToggle(2, "autoDOT") then
        local rakeSoon = gs.cp < 5 and (gs.rakeRefreshable or gs.lowestPMult < gs.currentPMultiplier)
        
        if not rakeSoon and gs.cp >= 4 and gs.wildstalker then
            if gs.bloodvinesCount > 0 and not target:Debuff(debuffs.bloodseekerVines, true) then
                return true
            end
        end
        
        if gs.cp < 5 and (not gs.btRakeUp or not player:TalentKnown(Bloodtalons.id)) then
            if gs.rakeCount < math.min(gs.activeEnemies, 5) then
                return true
            end
            
            if gs.targetPMultiplier > gs.lowestPMult then
                return true
            end
        end
    end
    
    if Rake:InRange(target) and target.exists then return false end
    
    if gs.rakeInRange > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local activeBTTriggers = 0  
local btAbilitiesStatus = {} 
local bloodtalonsAbilities = { Shred, Rake, BrutalSlash, FeralFrenzy, MoonfireCat, ThrashCat, SwipeCat }

local function canUseBt(ability)
    return btAbilitiesStatus[ability] == true
end

local function updateBloodTalons()
    activeBTTriggers = 0
    
    if player:Buff(buffs.bloodtalons) then
        for _, ability in ipairs(bloodtalonsAbilities) do
            btAbilitiesStatus[ability] = false
        end
    end
    
    if player:TalentKnown(Bloodtalons.id) then
        for _, ability in ipairs(bloodtalonsAbilities) do
            local timeSinceLastCast = ability.used
            
            if timeSinceLastCast > 4000 or timeSinceLastCast <= 0 then
                btAbilitiesStatus[ability] = true 
            else
                btAbilitiesStatus[ability] = false 
                activeBTTriggers = activeBTTriggers + 1
            end
        end
    end
end

local function fightRemains()
    local cacheKey = "areaTTD"
    
    return constCell:GetOrSet(cacheKey, function()
            local _, instanceType = GetInstanceInfo()
            if instanceType == "raid" then
                
                local activeEnemies = MultiUnits:GetActiveUnitPlates()
                local highest = 0 
                
                for enemyGUID in pairs(activeEnemies) do
                    local enemy = MakUnit:new(enemyGUID)
                    if enemy.ttd > 0 and enemy.ttd > highest then
                        highest = enemy.ttd
                    end
                end
                
                return highest
            else
                return 99999
            end
    end)
end

local function myPMult()
    local pmodifier = 1.0
    if IsStealthed() then
        pmodifier = pmodifier * 2
    end
    if player:Buff(buffs.tigersFury) then
        pmodifier = pmodifier * 1.15
    end
    if player:Buff(buffs.bloodtalons) then
        pmodifier = pmodifier * 1.2
    end
    return pmodifier
end
MakuluFramework.Pmul.register(debuffs.rake, myPMult)

local function lowestPMult()
    local cacheKey = "scanPMult"
    
    return constCell:GetOrSet(cacheKey, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            
            local lowestPMult = nil
            
            for enemyGUID, _ in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Rake:InRange(enemy) and (enemy.ttd > 8000 or enemy.isTarget or enemy.isDummy) then
                    local currentPMult = enemy:PMulState(debuffs.rake)
                    
                    if currentPMult and (not lowestPMult or currentPMult < lowestPMult) then
                        lowestPMult = currentPMult
                    end
                end
            end
            
            return lowestPMult or 0
    end)
end

local function bloodseekerVinesUnit()
    local cacheKey = "bloodseekerVinesUnit"
    
    return constCell:GetOrSet(cacheKey, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local highestStack = 0
            
            for enemyGUID, _ in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if Rake:InRange(enemy) then
                    local bloodseekerVinesStacks = enemy:DebuffRemains(debuffs.bloodseekerVines, true) > 1500 and enemy:HasDeBuffCount(debuffs.bloodseekerVines, true)
                    
                    if bloodseekerVinesStacks and bloodseekerVinesStacks > highestStack then
                        highestStack = bloodseekerVinesStacks
                    end
                end
            end
            
            return highestStack
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
    
    updateBloodTalons()
    
    gs.activeEnemies = activeEnemies()
    gs.orbsActive = orbsActive()
    gs.fightRemains = fightRemains()
    gs.rakeCount = enemiesInRange(debuffs.rake, 1000)
    gs.bloodvinesCount = enemiesInRange(debuffs.bloodseekerVines, 1000)
    gs.rakeInRange = rakeInRange()
    gs.shouldAoE = A.GetToggle(2, "AoE") and gs.activeEnemies >= 2 and not A.IsInPvP
    
    if Player:PrevGCD(1, A.FeralFrenzy) then
        gs.cp = 5
    else
        gs.cp = player.comboPoints
    end
    
    gs.wildstalker = player:TalentKnown(ThrivingGrowth.id)
    gs.druidOfTheClaw = player:TalentKnown(RavageTalent.id)
    
    gs.bsIncUp = player:Buff(buffs.berserk) or player:Buff(buffs.incarnation)
    
    if player:TalentKnown(Incarnation.id) then
        gs.bsIncCd = Incarnation.cd
    else
        gs.bsIncCd = Berserk.cd
    end
    
    gs.btSwipeUp = not canUseBt(SwipeCat)
    gs.btThrashUp = not canUseBt(ThrashCat)
    gs.btRakeUp = not canUseBt(Rake)
    gs.btShredUp = not canUseBt(Shred)
    gs.btFrenzyUp = not canUseBt(FeralFrenzy)
    gs.btMoonfireUp = not canUseBt(MoonfireCat)
    gs.btBrutalSlashUp = not canUseBt(BrutalSlash)
    
    gs.btCount = activeBTTriggers
    gs.needBt = player:TalentKnown(Bloodtalons.id) and player:HasBuffCount(buffs.bloodtalons) <= 1
    
    gs.currentPMultiplier = myPMult()
    gs.targetPMultiplier = target:PMulState(debuffs.rake)
    gs.lowestPMult = lowestPMult()
    
    gs.bloodseekerVinesUnit = bloodseekerVinesUnit()
    
    gs.easySwipe = A.GetToggle(2, "easySwipe")
    
    local energyRegen = GetPowerRegen()
    gs.effectiveEnergy = player.energy + (40 * player:HasBuffCount(buffs.clearcasting)) + (3 * energyRegen) + (50 * (num(TigersFury.cd < 3500)))
    
    local timeToPoolRaw = 115 - gs.effectiveEnergy - (23 * num(player:Buff(buffs.incarnation)))
    gs.timeToPool = timeToPoolRaw % energyRegen
    
    if timeToPoolRaw < 0 then
        gs.timeToPool = gs.timeToPool - energyRegen
    end
    
    gs.dotRefreshSoon = (not player:TalentKnown(ThrashingClaws.id) and (target:DebuffRemains(debuffs.thrashCat, true) - 12000 * 0.3 <= 2000)) or (player:TalentKnown(LunarInspiration.id) and (target:DebuffRemains(debuffs.moonfireCat, true) - 14000 * 0.3 <= 2000)) or ((gs.targetPMultiplier < 1.6 or player:Buff(buffs.suddenAmbush)) and (target:DebuffRemains(debuffs.rake, true) - 12000 * 0.3 <= 2000))
    
    gs.ccCapped = player:HasBuffCount(buffs.clearcasting) >= 1 + player:TalentKnownInt(MomentOfClarity.id)
    
    gs.lastConvoke = (ConvokeTheSpirits.cd + (120000 - (60000 * player:TalentKnownInt(AshamanesGuidance.id)))) > gs.fightRemains and ConvokeTheSpirits.cd < gs.fightRemains
    
    if player:TalentKnown(Incarnation.id) then
        gs.lastZerk = (Incarnation.cd + 25000) > gs.fightRemains and Incarnation.cd < gs.fightRemains
    else
        gs.lastZerk = (Berserk.cd + 25000) > gs.fightRemains and Berserk.cd < gs.fightRemains
    end
    
    gs.ripRefreshable = target:DebuffPandemic(debuffs.rip) and Rip:InRange(target)
    gs.rakeRefreshable = target:DebuffPandemic(debuffs.rake) and Rake:InRange(target)
    gs.thrashRefreshable = target:DebuffPandemic(debuffs.thrashCat) and Shred:InRange(target)
    gs.moonfireRefreshable = target:DebuffPandemic(debuffs.moonfireCat)
    gs.ripRemains = target:DebuffRemains(debuffs.rip, true)
    gs.rakeRemains = target:DebuffRemains(debuffs.rake, true)
    gs.adaptiveSwarmRemains = target:DebuffRemains(debuffs.adaptiveSwarm, true)
    gs.bloodseekerVinesTicking = target:Debuff(debuffs.bloodseekerVines, true)
end

FakeCasting.enable()

FakeCasting.blacklist({
        [370960] = true, -- em com
})

CatForm:Callback(function(spell)
        if not A.GetToggle(2, "autoShift") then return end
        local autoForm = A.GetToggle(2, "autoForms")
        if not autoForm[1] then return end
        
        if shouldStayBear() then return end
        if player:Buff(buffs.catForm) then return end
        --if A.Zone == "arena" and player:Buff(buffs.bearForm) then return end
        if player:Buff(buffs.travelForm) then return end
        
        return spell:Cast()
end)

MarkoftheWild:Callback('PreCombat1', function(spell)
        if not NeedRaidBuff(MarkoftheWild) then return end
        return Debounce("raidbuff", 1000, 2500, spell, player)
end)

Soothe:Callback(function(spell)
        if A.Zone == "arena" then return end
        if not target.exists then return end
        
        if A.AuraIsValid("target", "UseExpelEnrage", "Enrage") or target.enraged then
            return spell:Cast(target)
        end
end)

Renewal:Callback(function(spell)
        if player.hp < A.GetToggle(2, "RenewalHP") then
            return spell:Cast()
        end
end)

FrenziedRegeneration:Callback(function(spell)
        local canUse = player:Buff(buffs.bearForm) or ((player:Buff(buffs.catForm) and player:TalentKnown(EmpoweredShapeshifting.id)))
        
        if not canUse then return end
        if player:Buff(buffs.frenziedRegeneration) then return end
        if player.hp < A.GetToggle(2, "FrenziedRegenerationHP") then
            return spell:Cast()
        end
end)

BearForm:Callback("arena", function(spell)
        if not A.GetToggle(2, "autoShift") then return end
        local autoForm = A.GetToggle(2, "autoForms")
        if not autoForm[2] then return end
        
        if not A.IsInPvP then return end
        if player:Buff(buffs.bearForm) then return end
        if player.hp > 50 then return end
        --if player:AttackersV69() == 0 then return end
        
        return spell:Cast()
end)

BearForm:Callback("root", function(spell)
        if not A.GetToggle(2, "autoShift") then return end
        local autoForm = A.GetToggle(2, "autoForms")
        if not autoForm[2] then return end
        
        if player:Buff(buffs.bearForm) then return end
        if LoC:Get("ROOT") <= 0 then return end
        
        return Debounce("root", 500, 2500, spell)
end)

Barkskin:Callback(function(spell)
        if shouldDefensive() then
            return spell:Cast()
        end
        
        if player.hp < A.GetToggle(2, "BarkskinHP") then
            return spell:Cast()
        end
end)

NaturesVigil:Callback(function(spell)
        if shouldDefensive() then
            return spell:Cast()
        end
end)

Regrowth:Callback("selfheal", function(spell)
        if player.hp > A.GetToggle(2, "offHealingHP") then return end
        if not player:Buff(buffs.predatorySwiftness) then return end
        
        local partyMem = A.GetToggle(2, "healingUnits")
        if not partyMem[4] then return end  -- Check "Self" toggle
        
        return spell:Cast(player)
end)

Rebirth:Callback("pve", function(spell)
        if not A.GetToggle(2, "mouseoverRes") then return end
        if not player.combat then return end
        if not mouseover.exists then return end
        if not mouseover.isFriendly then return end
        if not mouseover.dead then return end
        if mouseover.isPet then return end
        
        return spell:Cast()
end)

Revive:Callback("pve", function(spell)
        if not A.GetToggle(2, "mouseoverRes") then return end
        if player.combat then return end
        if not mouseover.exists then return end
        if not mouseover.isFriendly then return end
        if not mouseover.dead then return end
        if mouseover.isPet then return end
        
        return spell:Cast()
end)

Prowl:Callback("ooc", function(spell)
        if player.inCombat then return end
        if player.stealthed then return end
        if player.mounted then return end
        if player:Buff(buffs.travelForm) then return end
        if not target.exists then return end
        if target.isFriendly then return end
        
        return spell:Cast()
end)

--------------------------------------------
---Main-------------------------------------
--------------------------------------------

-- actions+=/tigers_fury (use on cooldown)
TigersFury:Callback("main", function(spell)
        -- Use Tigers Fury on cooldown - no conditions, no holding
        return spell:Cast()
end)

-- Fallback Tigers Fury - use on cooldown
TigersFury:Callback("fallback", function(spell)
        -- Use Tigers Fury on cooldown - no conditions, no holding
        return spell:Cast()
end)

-- actions+=/rake,target_if=max:refreshable+(persistent_multiplier>dot.rake.pmultiplier),if=buff.shadowmeld.up|buff.prowl.up
Rake:Callback("main", function(spell)
        if not gs.rakeRefreshable then return end
        
        if player.stealthed then
            return spell:Cast(target)
        end
end)

-- actions+=/adaptive_swarm,target_if=dot.adaptive_swarm_damage.stack<3&(!dot.adaptive_swarm_damage.ticking|dot.adaptive_swarm_damage.remains<2),if=!action.adaptive_swarm_damage.in_flight&(spell_targets=1|!talent.unbridled_swarm)&(dot.rip.ticking|hero_tree.druid_of_the_claw)
AdaptiveSwarm:Callback("main", function(spell)
        if target:HasDeBuffCount(debuffs.adaptiveSwarm, true) < 3 and (not target:Debuff(debuffs.adaptiveSwarm, true) or target:DebuffRemains(debuffs.adaptiveSwarm, true) < 2000) and (gs.activeEnemies == 1 or not player:TalentKnown(UnbridledSwarm.id)) and (not gs.ripRefreshable or gs.druidOfTheClaw) then
            return spell:Cast(target)
        end
end)

-- actions+=/adaptive_swarm,target_if=max:(1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die,if=buff.cat_form.up&dot.adaptive_swarm_damage.stack<3&talent.unbridled_swarm.enabled&spell_targets.swipe_cat>1&dot.rip.ticking
AdaptiveSwarm:Callback("main2", function(spell)
        if (player:Buff(buffs.catForm) and target:HasDeBuffCount(debuffs.adaptiveSwarm, true) < 3 and player:TalentKnown(UnbridledSwarm.id) and gs.activeEnemies > 1 and not gs.ripRefreshable) then
            return spell:Cast(target)
        end
end)

-- actions+=/ferocious_bite,if=buff.apex_predators_craving.up&!(variable.need_bt&active_bt_triggers=2)&!buff.bs_inc.up
FerociousBite:Callback("main", function(spell)
        if player:Buff(buffs.apexPredatorsCraving) and not (gs.needBt and gs.btCount == 2) and not gs.bsIncUp then
            return spell:Cast(target)
        end
end)

-- actions+=/rip,if=talent.rip_and_tear&spell_targets=1&hero_tree.wildstalker&buff.tigers_fury.up&!buff.bs_inc.up&(buff.bloodtalons.up|!talent.bloodtalons)&(combo_points>=3&refreshable&cooldown.tigers_fury.remains>25|buff.tigers_fury.remains<5&variable.rip_duration>cooldown.tigers_fury.remains&cooldown.tigers_fury.remains>=dot.rip.remains)
Rip:Callback("main", function(spell)
        if player:TalentKnown(RipAndTear.id) and
        gs.activeEnemies == 1 and
        gs.wildstalker and
        player:Buff(buffs.tigersFury) and
        not gs.bsIncUp and
        (player:Buff(buffs.bloodtalons) or not player:TalentKnown(Bloodtalons.id)) then
            
            local ripDuration = ((4 + (4 * gs.cp)) * (1 - (0.2 * player:TalentKnownInt(CircleOfLifeAndDeath.id))) * (1 + (0.25 * player:TalentKnownInt(Veinripper.id))))
            
            if (gs.cp >= 3 and gs.ripRefreshable and TigersFury.cd > 25000) or
            (player:BuffRemains(buffs.tigersFury) < 5000 and
                ripDuration > TigersFury.cd and
            TigersFury.cd >= gs.ripRemains) then
                return spell:Cast(target)
            end
        end
end)

-------------------------------------------
---Cooldowns-------------------------------
-------------------------------------------

-- actions.cooldown+=/incarnation,if=target.time_to_die>17|target.time_to_die=fight_remains
-- actions.cooldown+=/berserk,if=buff.tigers_fury.up&(target.time_to_die>12|target.time_to_die=fight_remains)
Berserk:Callback("cooldown", function(spell)
        if gs.bsIncCd > 350 then return end
        
        
        if not makBurst() then 
            local cooldownUsage = A.GetToggle(2, "cooldownUsage")
            if cooldownUsage[2] then return end
        end
        
        if gs.ripRefreshable then return end
        
        if not player:TalentKnown(Incarnation.id) then
            if not player:Buff(buffs.tigersFury) then return end
        end
        
        return spell:Cast()
end)

-- actions.cooldown+=/berserking,if=buff.bs_inc.up
Berserking:Callback("cooldown", function(spell)
        if not A.GetToggle(1, "Racial") then return end
        if gs.ripRefreshable then return end
        
        if gs.bsIncUp then
            return spell:Cast()
        end
end)

-- actions.cooldown+=/feral_frenzy,if=combo_points<=1+buff.bs_inc.up
FeralFrenzy:Callback("cooldown", function(spell)
        if not makBurst() then
            local cooldownUsage = A.GetToggle(2, "cooldownUsage")
            if cooldownUsage[3] then return end
        end
        
        if gs.cp <= 1 + num(gs.bsIncUp) then
            return spell:Cast(target)
        end
end)

-- actions.cooldown+=/convoke_the_spirits,if=fight_remains<5|buff.bs_inc.up&buff.bs_inc.remains<5-talent.ashamanes_guidance|buff.tigers_fury.up&!variable.holdConvoke&(combo_points<=4|buff.bs_inc.up&combo_points<=3)
ConvokeTheSpirits:Callback("cooldown", function(spell)
        if not makBurst() then
            local cooldownUsage = A.GetToggle(2, "cooldownUsage")
            if cooldownUsage[4] then return end
        end
        
        if gs.fightRemains < 5000 or
        (gs.bsIncUp and player:BuffRemains(buffs.berserk) < (5000 - (1000 * player:TalentKnownInt(AshamanesGuidance.id)))) or
        (player:Buff(buffs.tigersFury) and
            (gs.cp <= 4 or (gs.bsIncUp and gs.cp <= 3))) then
            
            -- Ensure Berserk/Incarnation is up before Convoke during burst windows
            if not gs.bsIncUp then
                if player:TalentKnown(Incarnation.id) then
                    if Incarnation:ReadyToUse() then
                        return Incarnation:Cast()
                    end
                else
                    if Berserk:ReadyToUse() then
                        return Berserk:Cast()
                    end
                end
            end
            
            -- Ensure racials are fired before Convoke (never both; pick the one you actually have)
            if A.GetToggle(1, "Racial") then
                if BloodFury:IsKnown() and BloodFury:ReadyToUse() then
                    return BloodFury:Cast(player)
                end
                if Berserking:IsKnown() and Berserking:ReadyToUse() then
                    return Berserking:Cast(player)
                end
            end
            
            return spell:Cast()
        end
end)

local function cooldown()
    Berserk("cooldown")
    Berserking("cooldown")
    FeralFrenzy("cooldown")
    ConvokeTheSpirits("cooldown")
end

--------------------------------------------
---AoEBuilder-------------------------------
--------------------------------------------
-- actions.aoe_builder+=/thrash_cat,target_if=max:time_to_die,if=refreshable&!talent.thrashing_claws&!(variable.need_bt&buff.bt_thrash.up)&remains<time_to_die
ThrashCat:Callback("aoe_builder", function(spell)
        if (gs.thrashRefreshable and not player:TalentKnown(ThrashingClaws.id) and not (gs.needBt and gs.btThrashUp)) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/brutal_slash,target_if=min:time_to_die,if=(cooldown.brutal_slash.full_recharge_time<4|time_to_die<4|raid_event.adds.remains<4|(buff.bs_inc.up&spell_targets>=3-hero_tree.druid_of_the_claw))&!(variable.need_bt&buff.bt_swipe.up&(buff.bs_inc.down|spell_targets<3-hero_tree.druid_of_the_claw))
BrutalSlash:Callback("aoe_builder", function(spell)
        if not player:TalentKnown(BrutalSlash.id) then return end
        
        if ((BrutalSlash:TimeToFullCharges() < 4000 or gs.fightRemains < 4000 or (gs.bsIncUp and gs.activeEnemies >= 3 - num(gs.druidOfTheClaw))) and not (gs.needBt and gs.btBrutalSlashUp and (not gs.bsIncUp or gs.activeEnemies < 3 - num(gs.druidOfTheClaw)))) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/swipe_cat,target_if=min:time_to_die,if=talent.wild_slashes&(time_to_die<4|raid_event.adds.remains<4|buff.bs_inc.up&spell_targets>=3-hero_tree.druid_of_the_claw)&!(variable.need_bt&buff.bt_swipe.up&(buff.bs_inc.down|spell_targets<3-hero_tree.druid_of_the_claw))
SwipeCat:Callback("aoe_builder", function(spell)
        if player:TalentKnown(BrutalSlash.id) then return end
        
        if player:TalentKnown(WildSlashes.id) and
        (gs.fightRemains < 4000 or (gs.bsIncUp and gs.activeEnemies >= 3 - num(gs.druidOfTheClaw))) and
        not (gs.needBt and gs.btSwipeUp and (not gs.bsIncUp or gs.activeEnemies < 3 - num(gs.druidOfTheClaw))) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/swipe_cat,if=time_to_die<4|(talent.wild_slashes&spell_targets.swipe_cat>4&!(variable.need_bt&buff.bt_swipe.up))
SwipeCat:Callback("aoe_builder2", function(spell)
        if player:TalentKnown(BrutalSlash.id) then return end
        
        if gs.fightRemains < 4000 or
        (player:TalentKnown(WildSlashes.id) and gs.activeEnemies > 4 and not (gs.needBt and gs.btSwipeUp)) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/prowl,target_if=dot.rake.refreshable|dot.rake.pmultiplier<1.4,if=!(variable.need_bt&buff.bt_rake.up)&action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&!variable.cc_capped
Prowl:Callback("aoe_builder", function(spell)
        
        if player.stealthed then return end
        
        if (gs.rakeRefreshable or gs.targetPMultiplier < 1.4) and 
        not (gs.needBt and gs.btRakeUp) and 
        player.energy >= 35 and 
        MakGcd() == 0 and 
        not player:Buff(buffs.suddenAmbush) and 
        not gs.ccCapped then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/shadowmeld,target_if=dot.rake.refreshable|dot.rake.pmultiplier<1.4,if=!(variable.need_bt&buff.bt_rake.up)&action.rake.ready&!buff.sudden_ambush.up&!buff.prowl.up&!variable.cc_capped
Shadowmeld:Callback("aoe_builder", function(spell)
        if player.moving then return end
        if player.stealthed then return end
        
        if (gs.rakeRefreshable or gs.targetPMultiplier < 1.4) and 
        not (gs.needBt and gs.btRakeUp) and 
        player.energy >= 35 and 
        not player:Buff(buffs.suddenAmbush) and 
        not player:Buff(buffs.prowl) and 
        not gs.ccCapped then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/rake,target_if=refreshable,if=talent.doubleclawed_rake&!(variable.need_bt&buff.bt_rake.up)&!variable.cc_capped
Rake:Callback("aoe_builder", function(spell)
        if gs.rakeRefreshable and 
        player:TalentKnown(DoubleClawedRake.id) and 
        not (gs.needBt and gs.btRakeUp) and 
        not gs.ccCapped then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/swipe_cat,if=talent.wild_slashes&spell_targets.swipe_cat>2&!(variable.need_bt&buff.bt_swipe.up)
SwipeCat:Callback("aoe_builder3", function(spell)
        if player:TalentKnown(BrutalSlash.id) then return end
        
        if player:TalentKnown(WildSlashes.id) and 
        gs.activeEnemies > 2 and 
        not (gs.needBt and gs.btSwipeUp) then
            return spell:Cast()
        end
end)

--TRIP NOTE: Added 25/02/2025, final day of 11.1 PTR
-- actions.aoe_builder+=/rake,target_if=!dot.rake.ticking&hero_tree.wildstalker
Rake:Callback("aoe_builder2", function(spell)
        if not target:Debuff(debuffs.rake, true) and gs.wildstalker then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/moonfire_cat,target_if=refreshable,if=!(variable.need_bt&buff.bt_moonfire.up)&!variable.cc_capped
MoonfireCat:Callback("aoe_builder", function(spell)
        if gs.moonfireRefreshable and 
        not (gs.needBt and gs.btMoonfireUp) and 
        not gs.ccCapped then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/rake,target_if=refreshable,if=!(variable.need_bt&buff.bt_rake.up)&!variable.cc_capped
Rake:Callback("aoe_builder3", function(spell)
        if gs.rakeRefreshable and 
        not (gs.needBt and gs.btRakeUp) and 
        not gs.ccCapped then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/brutal_slash,if=!(variable.need_bt&buff.bt_swipe.up)
BrutalSlash:Callback("aoe_builder", function(spell)
        if not player:TalentKnown(BrutalSlash.id) then return end
        
        if not (gs.needBt and gs.btBrutalSlashUp) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/swipe_cat,if=!(variable.need_bt&buff.bt_swipe.up)
SwipeCat:Callback("aoe_builder4", function(spell)
        if player:TalentKnown(BrutalSlash.id) then return end
        
        if not (gs.needBt and gs.btSwipeUp) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/shred,if=!buff.sudden_ambush.up&!variable.easy_swipe&!(variable.need_bt&buff.bt_shred.up)
Shred:Callback("aoe_builder", function(spell)
        if not player:Buff(buffs.suddenAmbush) and 
        not gs.easySwipe and 
        not (gs.needBt and gs.btShredUp) then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/thrash_cat,if=!talent.thrashing_claws&!(variable.need_bt&buff.bt_thrash.up)
ThrashCat:Callback("aoe_builder2", function(spell)
        if not player:TalentKnown(ThrashingClaws.id) and 
        not (gs.needBt and gs.btThrashUp) then
            return spell:Cast()
        end
end)

-- actions.aoe_builder+=/rake,target_if=max:ticks_gained_on_refresh,if=talent.doubleclawed_rake&buff.sudden_ambush.up&variable.need_bt&buff.bt_rake.down
Rake:Callback("aoe_builder4", function(spell)
        if player:TalentKnown(DoubleClawedRake.id) and 
        player:Buff(buffs.suddenAmbush) and 
        gs.needBt and 
        not gs.btRakeUp then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/moonfire_cat,target_if=max:ticks_gained_on_refresh,if=variable.need_bt&buff.bt_moonfire.down
MoonfireCat:Callback("aoe_builder2", function(spell)
        if gs.needBt and 
        not gs.btMoonfireUp then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/rake,target_if=max:ticks_gained_on_refresh,if=buff.sudden_ambush.up&variable.need_bt&buff.bt_rake.down
Rake:Callback("aoe_builder5", function(spell)
        if player:Buff(buffs.suddenAmbush) and 
        gs.needBt and 
        not gs.btRakeUp then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/shred,if=variable.need_bt&buff.bt_shred.down&!variable.easy_swipe
Shred:Callback("aoe_builder2", function(spell)
        if gs.needBt and 
        not gs.btShredUp and 
        not gs.easySwipe then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/rake,target_if=dot.rake.pmultiplier<1.6,if=variable.need_bt&buff.bt_rake.down
Rake:Callback("aoe_builder6", function(spell)
        if gs.targetPMultiplier < 1.6 and 
        gs.needBt and 
        not gs.btRakeUp then
            return spell:Cast(target)
        end
end)

-- actions.aoe_builder+=/thrash_cat,if=variable.need_bt&buff.bt_shred.down
ThrashCat:Callback("aoe_builder3", function(spell)
        if gs.needBt and not gs.btThrashUp then
            return spell:Cast()
        end
end)

local function aoeBuilder()
    ThrashCat("aoe_builder")
    BrutalSlash("aoe_builder")
    SwipeCat("aoe_builder")
    SwipeCat("aoe_builder2")
    Prowl("aoe_builder")
    Shadowmeld("aoe_builder")
    Rake("aoe_builder")
    SwipeCat("aoe_builder3")
    Rake("aoe_builder2")
    MoonfireCat("aoe_builder")
    Rake("aoe_builder3")
    BrutalSlash("aoe_builder")
    SwipeCat("aoe_builder4")
    Shred("aoe_builder")
    ThrashCat("aoe_builder2")
    Rake("aoe_builder4")
    MoonfireCat("aoe_builder2")
    Rake("aoe_builder5")
    Shred("aoe_builder2")
    Rake("aoe_builder6")
    ThrashCat("aoe_builder3")
end

--------------------------------------------
---STBuilder-------------------------------
--------------------------------------------
-- actions.builder+=/prowl,if=gcd.remains=0&energy>=35&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)*!(variable.need_bt&buff.bt_rake.up)&buff.tigers_fury.up&!buff.shadowmeld.up
Prowl:Callback("builder", function(spell)
        if MakGcd() == 0 and 
        player.energy >= 35 and 
        not player:Buff(buffs.suddenAmbush) and 
        (gs.rakeRefreshable or gs.targetPMultiplier < 1.4) and 
        not (gs.needBt and gs.btRakeUp) and 
        player:Buff(buffs.tigersFury) and 
        not player.stealthed then
            return spell:Cast()
        end
end)

-- actions.builder+=/shadowmeld,if=gcd.remains=0&energy>=35&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)*!(variable.need_bt&buff.bt_rake.up)&buff.tigers_fury.up&!buff.prowl.up
Shadowmeld:Callback("builder", function(spell)
        if player.moving then return end
        if MakGcd() == 0 and 
        player.energy >= 35 and 
        not player:Buff(buffs.suddenAmbush) and 
        (gs.rakeRefreshable or gs.targetPMultiplier < 1.4) and 
        not (gs.needBt and gs.btRakeUp) and 
        player:Buff(buffs.tigersFury) and 
        not player.stealthed then
            return spell:Cast()
        end
end)

-- actions.builder+=/rake,if=((refreshable&persistent_multiplier>=dot.rake.pmultiplier|dot.rake.remains<3.5)|buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)&!(variable.need_bt&buff.bt_rake.up)&(hero_tree.wildstalker|!buff.bs_inc.up)
Rake:Callback("builder", function(spell)
        if ((gs.rakeRefreshable and gs.currentPMultiplier >= gs.targetPMultiplier) or
            gs.rakeRemains < 3500 or
            (player:Buff(buffs.suddenAmbush) and gs.currentPMultiplier > gs.targetPMultiplier)) and
        not (gs.needBt and gs.btRakeUp) and
        (gs.wildstalker or not gs.bsIncUp) then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/shred,if=buff.sudden_ambush.up&buff.bs_inc.up&!(variable.need_bt&buff.bt_shred.up&active_bt_triggers=2)
Shred:Callback("builder", function(spell)
        if not player:Buff(buffs.suddenAmbush) then return end
        if not gs.bsIncUp then return end
        
        if not (gs.needBt and gs.btShredUp and gs.btCount == 2) then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/brutal_slash,if=cooldown.brutal_slash.full_recharge_time<4&!(variable.need_bt&buff.bt_swipe.up)
BrutalSlash:Callback("builder", function(spell)
        if not player:TalentKnown(BrutalSlash.id) then return end
        
        if BrutalSlash:TimeToFullCharges() < 4000 and 
        not (gs.needBt and gs.btBrutalSlashUp) then
            return spell:Cast()
        end
end)

-- actions.builder+=/moonfire_cat,if=refreshable
MoonfireCat:Callback("builder", function(spell)
        if gs.moonfireRefreshable then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/thrash_cat,if=refreshable&!talent.thrashing_claws&!buff.bs_inc.up
ThrashCat:Callback("builder", function(spell)
        if gs.thrashRefreshable and
        not player:TalentKnown(ThrashingClaws.id) and
        not gs.bsIncUp then
            return spell:Cast()
        end
end)

-- actions.builder+=/shred,if=buff.clearcasting.react&!(variable.need_bt&buff.bt_shred.up)
Shred:Callback("builder2", function(spell)
        if player:Buff(buffs.clearcasting) and 
        not (gs.needBt and gs.btShredUp) then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/pool_resource,if=variable.dot_refresh_soon&energy.deficit>70&!variable.need_bt&!buff.bs_inc.up&cooldown.tigers_fury.remains>3
PoolResource:Callback("builder", function(spell)
        if gs.dotRefreshSoon and 
        player.energyDeficit > 70 and 
        not gs.needBt and 
        not gs.bsIncUp and 
        TigersFury.cd > 3000 then
            return spell:Cast()
        end
end)

-- actions.builder+=/brutal_slash,if=!(variable.need_bt&buff.bt_swipe.up)
BrutalSlash:Callback("builder2", function(spell)
        if not player:TalentKnown(BrutalSlash.id) then return end
        
        if not (gs.needBt and gs.btBrutalSlashUp) then
            return spell:Cast()
        end
end)

-- actions.builder+=/shred,if=!(variable.need_bt&buff.bt_shred.up)
Shred:Callback("builder3", function(spell)
        if not (gs.needBt and gs.btShredUp) then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/rake,if=refreshable
Rake:Callback("builder2", function(spell)
        if gs.rakeRefreshable then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/thrash_cat,if=refreshable&!talent.thrashing_claws
ThrashCat:Callback("builder2", function(spell)
        if not Shred:InRange(target) then return end
        
        if player:TalentKnown(ThrashingClaws.id) then return end
        
        if gs.thrashRefreshable then
            return spell:Cast()
        end
end)

-- actions.builder+=/swipe_cat,if=variable.need_bt&buff.bt_swipe.down
SwipeCat:Callback("builder", function(spell)
        if player:TalentKnown(BrutalSlash.id) then return end
        
        if gs.needBt and 
        not gs.btSwipeUp then
            return spell:Cast()
        end
end)

-- actions.builder+=/rake,if=variable.need_bt&buff.bt_rake.down&persistent_multiplier>=dot.rake.pmultiplier
Rake:Callback("builder3", function(spell)
        if gs.needBt and 
        not gs.btRakeUp and 
        gs.currentPMultiplier >= gs.targetPMultiplier then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/moonfire_cat,if=variable.need_bt&buff.bt_moonfire.down
MoonfireCat:Callback("builder2", function(spell)
        if gs.needBt and 
        not gs.btMoonfireUp then
            return spell:Cast(target)
        end
end)

-- actions.builder+=/thrash_cat,if=variable.need_bt&buff.bt_thrash.down
ThrashCat:Callback("builder3", function(spell)
        if gs.needBt and 
        not gs.btThrashUp then
            return spell:Cast()
        end
end)

local function builder()
    Prowl("builder")
    Shadowmeld("builder")
    Rake("builder")
    Shred("builder")
    BrutalSlash("builder")
    MoonfireCat("builder")
    ThrashCat("builder")
    Shred("builder2")
    PoolResource("builder")
    BrutalSlash("builder2")
    Shred("builder3")
    Rake("builder2")
    ThrashCat("builder2")
    SwipeCat("builder")
    Rake("builder3")
    MoonfireCat("builder2")
    ThrashCat("builder3")
end


------------------------------------------
---Finisher-------------------------------
------------------------------------------

-- actions.finisher=primal_wrath,target_if=max:dot.bloodseeker_vines.ticking,if=spell_targets.primal_wrath>1&((dot.primal_wrath.remains<6.5&!buff.bs_inc.up|dot.primal_wrath.refreshable)|(!talent.rampant_ferocity.enabled&(spell_targets.primal_wrath>1&!dot.bloodseeker_vines.ticking&!buff.ravage.up|spell_targets.primal_wrath>6+talent.ravage)))
PrimalWrath:Callback("finisher", function(spell)
        if gs.activeEnemies > 1 and 
        (((gs.ripRemains < 6500 and not gs.bsIncUp) or 
            gs.ripRefreshable) or 
            (not player:TalentKnown(RampantFerocity.id) and 
                (gs.activeEnemies > 1 and not gs.bloodseekerVinesTicking and not player:Buff(buffs.ravage)) or 
                gs.activeEnemies > 6 + num(gs.druidOfTheClaw))) then
            return spell:Cast(target)
        end
end)

-- actions.finisher+=/rip,target_if=refreshable,if=(!talent.primal_wrath|spell_targets=1)&(buff.bloodtalons.up|!talent.bloodtalons)&(buff.tigers_fury.up|dot.rip.remains<cooldown.tigers_fury.remains)&(remains<fight_remains|remains<4&buff.ravage.up)
Rip:Callback("finisher", function(spell)
        if (not player:TalentKnown(PrimalWrath.id) or gs.activeEnemies == 1) and
        (player:Buff(buffs.bloodtalons) or not player:TalentKnown(Bloodtalons.id)) and
        gs.ripRefreshable then
            return spell:Cast(target)
        end
end)

-- actions.finisher+=/call_action_list,name=aoe_builder,if=hero_tree.druid_of_the_claw&buff.bs_inc.up&!buff.ravage.up&spell_targets>=2

-- actions.finisher+=/ferocious_bite,max_energy=1,target_if=max:dot.bloodseeker_vines.ticking,if=!buff.bs_inc.up
FerociousBite:Callback("finisher", function(spell)
        -- Use max energy during non-Berserk
        if not gs.bsIncUp then
            if player.energy < 50 then return end -- Need at least 50 energy for max energy bite
            return spell:Cast(target)
        end
        
        -- Normal bite during Berserk
        if player.energy >= 25 then -- Minimum energy for bite
            return spell:Cast(target)
        end
end)

-- Fallback Ferocious Bite - always available as last resort
FerociousBite:Callback("fallback", function(spell)
        if player.energy >= 25 then -- Minimum energy for bite
            return spell:Cast(target)
        end
end)

-- actions.finisher+=/pool_resource,for_next=1
PoolResource:Callback("finisher", function(spell)
        return spell:Cast()
end)

local function finisher()
    -- Check for special AoE builder case first
    if gs.druidOfTheClaw and gs.bsIncUp and not player:Buff(buffs.ravage) and gs.activeEnemies >= 2 then
        aoeBuilder()
        return
    end
    
    -- Normal finisher priority
    PrimalWrath("finisher")
    Rip("finisher")
    FerociousBite("finisher")
    
    -- Fallback finisher - ensure we always have something to cast at 5 CP
    FerociousBite("fallback")
    
    PoolResource("finisher")
end

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    
    FrameworkStart(icon)
    updategs()
    
    if Action.Zone == "arena" then
        FakeCasting.gglFakeCast(icon)
    end
    
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "AttackersV69: ", player:AttackersV69())
        MakPrint(2, "Party1V69: ", party1:AttackersV69())
        MakPrint(3, "Party2V69: ", party2:AttackersV69())
        MakPrint(4, "Arena1V69: ", arena1:AttackersV69())
        MakPrint(5, "Arena2V69: ", arena2:AttackersV69())
        MakPrint(6, "Arena3V69: ", arena3:AttackersV69())
        MakPrint(7, "energy: ", player.energy)
        MakPrint(8, "btBrutalSlashUp: ", gs.btBrutalSlashUp)
        MakPrint(9, "BT Rake Up: ", gs.btRakeUp)
        MakPrint(10, "BT Count: ", gs.btCount)
        MakPrint(11, "Should Burst: ", makBurst())
    end
    
    --[[local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] then

    end]]
    
    if player.channeling then return end
    
    makInterrupt(interrupts)
    
    MarkoftheWild("PreCombat1")
    CatForm()
    BearForm("arena")
    BearForm("root")
    Renewal()
    FrenziedRegeneration()
    Barkskin()
    NaturesVigil()
    Regrowth("selfheal")
    Soothe()
    Rebirth("pve")
    Revive("pve")
    Prowl("ooc")
    
    if A.GetToggle(2, "stayInBear") and player:Buff(buffs.bearForm) then return end
    
    if target.exists and target.canAttack and Shred:InRange(target) then
        
        TigersFury("main")
        Rake("main")
        AdaptiveSwarm("main")
        AdaptiveSwarm("main2")
        FerociousBite("main")
        
        if makBurst() then
            if Berserk.cd < 1000 or player:Buff(buffs.berserk) then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
            
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = gs.bsIncUp
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end
        
        cooldown() -- contains customised makBurst stuff so calling OUTSIDE makBurst section
        
        Rip("main")
        
        -- actions+=/call_action_list,name=builder,if=(buff.bs_inc.up&!buff.ravage.up&!buff.coiled_to_spring.up&hero_tree.druid_of_the_claw&talent.coiled_to_spring&spell_targets<=2)|buff.bloodtalons.stack=0&active_bt_triggers=2
        if (gs.bsIncUp and not player:Buff(buffs.ravage) and not player:Buff(buffs.coiledToSpring) and gs.druidOfTheClaw and player:TalentKnown(CoiledToSpring.id) and gs.activeEnemies <= 2) or (player:HasBuffCount(buffs.bloodtalons) == 0 and gs.btCount == 2) then
            builder()
        end
        
        -- Removed wait condition - Tigers Fury is now used on cooldown without waiting
        
        if gs.cp == 5 then
            finisher()
        end
        
        if gs.cp < 5 then
            if gs.shouldAoE then
                aoeBuilder()
            else
                builder()
            end
        end
        
        -- actions+=/tigers_fury (fallback if we can't do anything else)
        TigersFury("fallback")
        
        PoolResources("finisher") --Might as well show pooling all the time in range so people don't freak out that it's doing nothing.
        
    end
    
    return FrameworkEnd()
end

local pvpCurse = {
    [334275] = true, -- Curse of Exhaustion
    [1714] = true, -- Curse of Tongues
    [702] = true, -- Curse of Weakness
    [442804] = true, -- Curse of the Satyr
    [254412] = true, -- Hex
    
}

RemoveCorruption:Callback("party", function(spell, friendly) 
        local iNeedCleanse = player.cursed or player.poisoned
        local shouldDispel = friendly.cursed or friendly.poisoned
        
        --Hopefully this makes it self prio
        if iNeedCleanse then
            if not friendly.isMe then return end
        end
        
        
        local delay = math.random(500, 1000)
        local arenaCursed = friendly:HasDeBuffFromFor(pvpCurse, delay)
        
        if shouldDispel or arenaCursed then
            return Debounce("cleanse", 500, 2500, spell, friendly)
        end
end)

SkullBash:Callback("arena", function(spell, enemy)
        if enemy:IsKickImmune() then return end
        if target.hp < 20 then return end
        if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end
        
        return spell:Cast(enemy)
end)

Cyclone:Callback("arena", function(spell, enemy)
        local awareArena = A.GetToggle(2, "makAwareArena")
        if not enemy:IsUnit(enemyHealer) then return end
        if enemy:IsTarget() then return end
        if enemy.hp < 20 then return end
        if enemy.ccImmune then return end
        if enemy.totalImmune then return end
        if enemy.magicImmune then return end
        if enemy.disorientDr < 0.5 then return end
        if enemy.ccRemains > 1000 then return end
        if target.hp > 70 then return end
        if player.hp > 60 then
            if awareArena then Aware:displayMessage("Cyclone - Enemy Healer", "Blue", 1) end
            return spell:Cast(enemy)
        end
end)

MightyBash:Callback("arena", function(spell, enemy)
        local awareArena = A.GetToggle(2, "makAwareArena")
        if enemy.ccImmune then return end
        if enemy.distance > 10 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.stunDr < 0.25 then return end
        if enemy.ccRemains > 0 then return end
        
        if enemy:IsUnit(enemyHealer) then
            if target.hp > 70 then return end
            if enemy.stunDr < 1 then return end
            if player.hp > 60 then
                if awareArena then Aware:displayMessage("Mighty Bash - Enemy Healer", "Blue", 1) end
                return spell:Cast(enemy)
            end
        end
        
        if not enemy:IsUnit(enemyHealer) then
            if getBelowHP(40) > 0 and enemy.stunDr < 0.5 then
                if awareArena then Aware:displayMessage("Mighty Bash - Enemy DPS - Team Low", "Red", 1) end
                return spell:Cast(enemy)
            end
        end
end)

MaimArena:Callback("arena", function(spell, enemy)
        if enemy.ccImmune then return end
        if enemy.distance > 10 then return end
        if enemy.totalImmune then return end
        if enemy.physicalImmune then return end
        if enemy.stunDr < 1 then return end
        if enemy.ccRemains > 0 then return end
        if not enemy:IsUnit(target) then return end
        if enemy.hp > 65 then return end
        
        return spell:Cast(enemy)
        
end)

RegrowthParty:Callback("party", function(spell, friendly)
        if friendly.hp > A.GetToggle(2, "offHealingHP") then return end
        if not player:Buff(buffs.predatorySwiftness) then return end
        
        local partyMem = A.GetToggle(2, "healingUnits")
        
        local isTank = friendly.isTank
        local isHealer = friendly.isHealer
        local isDPS = not isTank and not isHealer and not friendly.isMe
        
        if not partyMem[1] and isTank then return end
        if not partyMem[2] and isHealer then return end
        if not partyMem[3] and isDPS then return end
        if not partyMem[4] and friendly.isMe then return end
        
        return spell:Cast(friendly)
end)

local enemyRotation = function(enemy)
    if not enemy.exists then return end
    
    SkullBash("arena", enemy)
    MightyBash("arena", enemy)
    Cyclone("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    
    RegrowthParty("party", friendly)
    RemoveCorruption("party", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    partyRotation(party1)
    enemyRotation(arena1)
    
    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    
    return FrameworkEnd()
end

A[7] = function(icon)
    RegisterIcon(icon)
    partyRotation(party2)
    enemyRotation(arena2)
    
    return FrameworkEnd()
end

A[8] = function(icon)
    RegisterIcon(icon)
    partyRotation(party3)
    enemyRotation(arena3)
    
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

