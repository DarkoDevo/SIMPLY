if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 252 then return end

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
local constCell        = cacheContext:getConstCacheCell()

local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local LoC = Action.LossOfControl

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { offGcd = true }  },
    Stoneform = { ID = 20594, MAKULU_INFO = { offGcd = true }  },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { offGcd = true }  },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { offGcd = true }  },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { offGcd = true }  },
    Darkflight = { ID = 68992, MAKULU_INFO = { offGcd = true }  },
    BloodFury = { ID = 20572, MAKULU_INFO = { offGcd = true }  },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { offGcd = true }  },
    WarStomp = { ID = 20549, MAKULU_INFO = { offGcd = true }  },
    Berserking = { ID = 26297, MAKULU_INFO = { offGcd = true }  },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { offGcd = true }  },
    RocketJump = { ID = 69070, MAKULU_INFO = { offGcd = true }  },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { offGcd = true }  },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { offGcd = true }  },
    SpatialRift = { ID = 256948, MAKULU_INFO = { offGcd = true }  },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { offGcd = true }  },
    Fireblood = { ID = 265221, MAKULU_INFO = { offGcd = true }  },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { offGcd = true }  },
    BullRush = { ID = 255654, MAKULU_INFO = { offGcd = true }  },
    AncestralCall = { ID = 274738, MAKULU_INFO = { offGcd = true }  },
    Haymaker = { ID = 287712, MAKULU_INFO = { offGcd = true }  },
    Regeneratin = { ID = 291944, MAKULU_INFO = { offGcd = true }  },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { offGcd = true }  }, 
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { offGcd = true }  }, 

    DeathCoil = { ID = 47541, MAKULU_INFO = { damageType = "magic" } },  
    DeathCoilPlayer = { ID = 98008, Texture = 237586 }, 
    DeathCoilPet = { ID = 213690, Texture = 132179 },    
    FesteringStrike = { ID = 85948, MAKULU_INFO = { damageType = "physical" } },
    Defile = { ID = 152280, MAKULU_INFO = { damageType = "magic" } },
    DeathandDecay = { ID = 43265, MAKULU_INFO = { damageType = "magic" } },
    DeathGrip = { ID = 49576, MAKULU_INFO = { damageType = "magic" } },
    Lichborne = { ID = 49039 },
    DeathsAdvance = { ID = 48265 },
    DarkCommand = { ID = 56222 },
    RaiseAlly = { ID = 61999 },
    PathofFrost = { ID = 3714 },
    ChainsofIce = { ID = 45524, MAKULU_INFO = { damageType = "magic" } },
    DeathStrike = { ID = 49998, MAKULU_INFO = { damageType = "physical" } },
    RaiseDead = { ID = 46584 },
    MindFreeze = { ID = 47528, MAKULU_INFO = { damageType = "magic" } },
    AntiMagicShell = { ID = 48707 },
    BlindingSleet = { ID = 207167, MAKULU_INFO = { damageType = "magic" } },
    SacrificialPact = { ID = 327574 },
    ControlUndead = { ID = 111673 },
    IceboundFortitude = { ID = 48792 },
    AntiMagicZone = { ID = 51052 },
    Asphyxiate = { ID = 108194, MAKULU_INFO = { damageType = "magic" } },
    DeathPact = { ID = 48743 },
    WraithWalk = { ID = 212552 },
    EmpowerRuneWeapon = { ID = 47568 },
    AbominationLimb = { ID = 383269, MAKULU_INFO = { damageType = "magic" } },
    
    SoulReaper = { ID = 343294, MAKULU_INFO = { damageType = "magic" } },
    ClawingShadows = { ID = 207311, MAKULU_INFO = { damageType = "magic", ignoreResource = true } },
    ScourgeStrike = { ID = 55090, MAKULU_INFO = { damageType = "magic", ignoreResource = true } },
    Outbreak = { ID = 77575, MAKULU_INFO = { damageType = "magic" } },
    DarkTransformation = { ID = 63560, MAKULU_INFO = { damageType = "magic" } }, 
    Epidemic = { ID = 207317, MAKULU_INFO = { damageType = "magic" } },
    Apocalypse = { ID = 275699, MAKULU_INFO = { damageType = "magic" } },
    VileContagion = { ID = 390279, MAKULU_INFO = { damageType = "magic" } },
    RaiseAbomination = { ID = 455395, MAKULU_INFO = { damageType = "magic" } },
    ArmyoftheDead = { ID = 42650, MAKULU_INFO = { damageType = "magic" } },
    SummonGargoyle = { ID = 49206, MAKULU_INFO = { damageType = "magic" } },
    SummonGargoylePet = { ID = 212551, MAKULU_INFO = { damageType = "magic" } },
    SummonSkeletalArcher = { ID = 49207, MAKULU_INFO = { damageType = "magic" } },
    UnholyAssault = { ID = 207289, MAKULU_INFO = { damageType = "magic" } },
    Leap = { ID = 47482, MAKULU_INFO = { damageType = "physical" } },
    Gnaw = { ID = 47481, MAKULU_INFO = { damageType = "physical" } },
    Huddle = { ID = 47484 },
    DeathCharge = { ID = 444347 },

    Reanimation = { ID = 210128 },
    Strangulate = { ID = 47476 },
    DarkSimulacrum = { ID = 77606 },

    VampiricStrike = { ID = 433895, MAKULU_INFO = { damageType = "magic", ignoreResource = true } },

    UnholyEndurance = { ID = 389682, Hidden = true },
    ImprovedDeathCoil = { ID = 377580, Hidden = true },
    CoilofDevastation = { ID = 390270, Hidden = true },
    Festermight = { ID = 377590, Hidden = true },
    BurstingSores = { ID = 207264, Hidden = true },
    InfectedClaws = { ID = 207272, Hidden = true },
    ArmyoftheDamned = { ID = 276837, Hidden = true },
    RottenTouch = { ID = 390275, Hidden = true }, 
    SuddenDoom = { ID = 49530, Hidden = true },
    CommanderoftheDead = { ID = 390259, Hidden = true }, 
    Plaguebringer = { ID = 390175, Hidden = true }, 
    Superstrain = { ID = 390283, Hidden = true },
    EbonFever = { ID = 207269, Hidden = true },
    UnholyGround = { ID = 374265, Hidden = true },
    MagusoftheDead = { ID = 390196, Hidden = true },
    Morbidity = { ID = 377592, Hidden = true },
    HarbingerofDoom = { ID = 276023, Hidden = true },
    GiftoftheSanlayn = { ID = 434152, Hidden = true },
    UnholyBlight = { ID = 460448, Hidden = true },
    DoomedBidding = { ID = 455386, Hidden = true },
    MenacingMagus = { ID = 455135, Hidden = true },
    FrenziedBloodthirst = { ID = 434075, Hidden = true },
    HungeringThirst = { ID = 444037, Hidden = true },
    VampiricStrikeTalent = { ID = 433901, Hidden = true },
    DeathChargeTalent = { ID = 444010, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    DeathandDecayCursor = { ID = 43265, FixedTexture = 133667,  Macro = "/cast [@cursor] spell:thisID" }, -- Universal1
    AsphyxiateFocus = { ID = 221562, FixedTexture = 133663,  Macro = "/cast [@focus] spell:thisID" }, -- Universal2
    DeathGripFocus = { ID = 49576, FixedTexture = 133658,  Macro = "/cast [@focus] spell:thisID" }, -- Universal3
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DEATHKNIGHT_UNHOLY] = A

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

local gs = {}

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    suddenDoom = 81340,
    essenceOfTheBloodQueen = 433925,
    unholyAssault = 207289,
    deathAndDecay = 188290,
    unholyStrength = 53365,
    festermight = 377591,
    giftOfTheSanlayn = 434153,
    darkTransformation = 63560,
    commanderOfTheDead = 390260,
    inflictionOfSorrow = 460049,
    festeringScythe = 458123,
    aFeastOfSouls = 440861,
    runicCorruption = 51460,
    deathsAdvance = 48265,
    deathCharge = 444347,
    lichborne = 49039,
}

local debuffs = {
    festeringWound = 194310,
    virulentPlague = 191587,
    rottenTouch = 390276,
    frostFever = 55095,
    bloodPlague = 55078,
    chainsOfIceTrollbane = 444826,
    deathRot = 377540,
}

local interrupts = {
    {spell = MindFreeze},
    {spell = Asphyxiate, isCC = true},
    {spell = BlindingSleet, isCC = true, aoe = true, distance = 3},
}

local function num(val)
    if val then return 1 else return 0 end
end

local function enemiesInRange(debuff, dur, spell)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange_" .. tostring(spell)
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        local spell = spell or DeathStrike
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if spell:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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
    return enemiesInRange(nil, nil, MindFreeze)
end

local function lowestWound()
    local cacheKey = "lowestWound"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local lowestDuration = math.huge
        local lowestEnemy = nil

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if DeathStrike:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                local duration = enemy:DebuffRemains(debuffs.festeringWound, true)
                if duration and duration > 0 then
                    if duration < lowestDuration then
                        lowestDuration = duration
                        lowestEnemy = enemy
                    end
                end
            end
        end
        
        return lowestEnemy
    end)
end

local function shouldDefensive()
    local defensiveActive = player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15

    return makShouldDefensive() < 2000 and not defensiveActive
end

local function orbsActive()
    local cacheKey = "orbsActive"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            local enemyCast = enemy.castInfo
            local orb = enemyCast and enemyCast.spellId == 461904
            if DeathGrip:InRange(enemy) and orb then
                return true
            end
        end
        
        return false
    end)
end

local function fightRemains()
    local cacheKey = "fightRemains"
    
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

local function runesReady()
    local currentTime = GetTime()
    local count = 0

    for runeSlot = 1, 6 do
        local startTime, duration, isRuneReady = GetRuneCooldown(runeSlot)
        
        if isRuneReady then
            count = count + 1
        else
            local timeUntilReady = (startTime + duration) - currentTime
            if timeUntilReady <= 0.4 then
                count = count + 1
            end
        end
    end

    return count
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

    if DeathStrike:InRange(target) and target.exists then return false end

    if gs.dsInRange > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local function updategs()
    gs.activeEnemies = activeEnemies()
    gs.orbsActive = orbsActive()
    gs.fightRemains = fightRemains()
    gs.shouldAoE = A.GetToggle(2, "AoE") and not A.IsInPvP
    gs.dsInRange = enemiesInRange()

    gs.woundCount = enemiesInRange(debuffs.festeringWound, 1000)
    gs.vpCount = enemiesInRange(debuffs.virulentPlague, 1000)
    gs.woundRefreshable = target:DebuffPandemic(debuffs.festeringWound) and DeathStrike:InRange(target)
    gs.virulentPlagueRefreshable = target:DebuffPandemic(debuffs.virulentPlague) and DeathStrike:InRange(target)
    gs.frostFeverRefreshable = target:DebuffPandemic(debuffs.frostFever) and DeathStrike:InRange(target)
    gs.bloodPlagueRefreshable = target:DebuffPandemic(debuffs.bloodPlague) and DeathStrike:InRange(target)

    gs.lowestWound = lowestWound()

    gs.runes = runesReady()

    gs.gargoyleActive = SummonGargoyle.used < 25000
    gs.abomActive = RaiseAbomination.used < 30000
    gs.armyActive = ArmyoftheDead.used < 30000
    gs.apocActive = Apocalypse.used < 20000

    gs.gargoyleRemains = math.max(25000 - SummonGargoyle.used, 0)
    gs.abomRemains = math.max(30000 - RaiseAbomination.used, 0)
    gs.armyRemains = math.max(30000 - ArmyoftheDead.used, 0)
    gs.apocRemains = math.max(20000 - Apocalypse.used, 0)

    gs.sanlayn = player:TalentKnown(VampiricStrikeTalent.id)
    gs.vampiricStrike = IsSpellOverlayed(VampiricStrike.id)

    gs.dndCd = player:TalentKnown(Defile.id) and Defile.cd or DeathandDecay.cd
    gs.dndUsed = player:TalentKnown(Defile.id) and Defile.used or DeathandDecay.used
    gs.dndTicking = player:Buff(buffs.deathAndDecay) and gs.dndUsed < 10000

    -- actions.variables=variable,name=st_planning,op=setif,value=1,value_else=0,condition=active_enemies=1&(!raid_event.adds.exists|!raid_event.adds.in|raid_event.adds.in>15|raid_event.pull.has_boss&raid_event.adds.in>15)
    gs.stPlanning = gs.activeEnemies <= 1 and incAddsIn() > 15000

    -- actions.variables+=/variable,name=adds_remain,op=setif,value=1,value_else=0,condition=active_enemies>=2&(!raid_event.adds.exists&fight_remains>6|raid_event.adds.exists&raid_event.adds.remains>6)
    gs.addsRemain = gs.activeEnemies >= 2

    -- actions.variables+=/variable,name=apoc_timing,op=setif,value=3,value_else=0,condition=cooldown.apocalypse.remains<5&debuff.festering_wound.stack<1&cooldown.unholy_assault.remains>5
    gs.apocTiming = num(Apocalypse.cd < 5000 and not target:Debuff(debuffs.festeringWound, true) and UnholyAssault.cd > 5000) * 3000

    -- actions.variables+=/variable,name=pop_wounds,op=setif,value=1,value_else=0,condition=(cooldown.apocalypse.remains>variable.apoc_timing|!talent.apocalypse)&(debuff.festering_wound.stack>=1&cooldown.unholy_assault.remains<20&talent.unholy_assault&variable.st_planning|debuff.rotten_touch.up&debuff.festering_wound.stack>=1|debuff.festering_wound.stack>=4-pet.abomination.active)|fight_remains<5&debuff.festering_wound.stack>=1
    gs.popWounds = (Apocalypse.cd > gs.apocTiming or not player:TalentKnown(Apocalypse.id)) and (target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 and UnholyAssault.cd < 20000 and player:TalentKnown(UnholyAssault.id) and gs.stPlanning or target:Debuff(debuffs.rottenTouch, true) and target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 or target:HasDeBuffCount(debuffs.festeringWound, true) >= 4 - num(gs.abomActive)) or gs.fightRemains < 5000 and target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 or not makBurst()

    -- actions.variables+=/variable,name=pooling_runic_power,op=setif,value=1,value_else=0,condition=talent.vile_contagion&cooldown.vile_contagion.remains<5&runic_power<30
    gs.poolingRunicPower = player:TalentKnown(VileContagion.id) and VileContagion.cd < 5000 and player.runicPower < 30

    -- actions.variables+=/variable,name=spend_rp,op=setif,value=1,value_else=0,condition=(!talent.rotten_touch|talent.rotten_touch&!debuff.rotten_touch.up|runic_power.deficit<20)&((talent.improved_death_coil&(active_enemies=2|talent.coil_of_devastation)|rune<3|pet.gargoyle.active|buff.sudden_doom.react|!variable.pop_wounds&debuff.festering_wound.stack>=4))
    gs.spendRp = (not player:TalentKnown(RottenTouch.id) or player:TalentKnown(RottenTouch.id) and not target:Debuff(debuffs.rottenTouch, true) or player.runicPowerDeficit < 20) and ((player:TalentKnown(ImprovedDeathCoil.id) and (gs.activeEnemies == 2 or player:TalentKnown(CoilofDevastation.id)) or gs.runes < 3 or gs.gargoyleActive or player:Buff(buffs.suddenDoom) or not gs.popWounds and target:HasDeBuffCount(debuffs.festeringWound, true) >= 4))

    -- actions.variables+=/variable,name=san_coil_mult,op=setif,value=2,value_else=1,condition=buff.essence_of_the_blood_queen.stack>=4
    gs.sanCoilMult = player:HasBuffCount(buffs.essenceOfTheBloodQueen) >= 4 and 2 or 1

    -- actions.variables+=/variable,name=epidemic_targets,value=3+talent.improved_death_coil+(talent.frenzied_bloodthirst*variable.san_coil_mult)+(talent.hungering_thirst&talent.harbinger_of_doom&buff.sudden_doom.up)
    gs.epidemicTargets = 3 + player:TalentKnownInt(ImprovedDeathCoil.id) + (player:TalentKnownInt(FrenziedBloodthirst.id) * gs.sanCoilMult) + num(player:TalentKnown(HungeringThirst.id) and player:TalentKnownInt(HarbingerofDoom.id) and player:Buff(buffs.suddenDoom))
end

--------------------------------------
---Defensives-------------------------
--------------------------------------

AntiMagicShell:Callback(function(spell)
    if shouldDefensive() then 
        return spell:Cast()
    end
end)

IceboundFortitude:Callback(function(spell)
    if shouldDefensive() then 
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "ibfHP") then
        return spell:Cast()
    end
end)

Lichborne:Callback(function(spell)
    if shouldDefensive() then 
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "lichborneHP") then
        return spell:Cast()
    end
end)

DeathCoilPlayer:Callback("heal", function(spell)
    if not A.GetToggle(2, "deathCoilSelf") then return end
    if not player:Buff(buffs.lichborne) then return end

    if player.ehp < A.GetToggle(2, "deathCoilHealHP") then
        return spell:Cast()
    end
end)

local function defensives()
    DeathCoilPlayer("heal")
    AntiMagicShell()
    IceboundFortitude()
    Lichborne()
end

--------------------------------------
---Util-------------------------------
--------------------------------------
RaiseDead:Callback(function(spell)
    if IsMounted() then return end
    if pet.exists and pet.hp > 0 then return end

    return spell:Cast()
end)

RaiseAlly:Callback(function(spell)
    if A.IsInPvP then return end

    if not A.GetToggle(2, "mouseoverRes") then return end
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if mouseover.isPet then return end

    return spell:Cast()
end)

DeathsAdvance:Callback(function(spell)
    if player:TalentKnown(DeathChargeTalent.id) then return end
	local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end

	if locData.locType ~= "ROOT" then return false end
	if locData.timeRemaining <= 1 then return false end

    if player:Buff(buffs.deathsAdvance) or player:Buff(buffs.deathCharge) then return end

    return spell:Cast()
end)

DeathCharge:Callback(function(spell)
    if not player:TalentKnown(DeathChargeTalent.id) then return end
	local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end

	if locData.locType ~= "ROOT" then return false end
	if locData.timeRemaining <= 1 then return false end

    if player:Buff(buffs.deathsAdvance) or player:Buff(buffs.deathCharge) then return end

    return spell:Cast()
end)

local function util()
    RaiseDead()
    RaiseAlly()
    DeathsAdvance()
    DeathCharge()
end

-----------------------------------------
---Racials-------------------------------
-----------------------------------------

-- actions.racials=arcane_torrent,if=runic_power<20&rune<2
ArcaneTorrent:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not DeathStrike:InRange(target) then return end
    if player.runicPower > 20 then return end
    if gs.runes > 1 then return end

    return spell:Cast()
end)

-- actions.racials+=/blood_fury,if=(buff.blood_fury.duration+3>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60)&(pet.army_ghoul.active&pet.army_ghoul.remains<=buff.blood_fury.duration+3|pet.apoc_ghoul.active&pet.apoc_ghoul.remains<=buff.blood_fury.duration+3|active_enemies>=2&death_and_decay.ticking)|fight_remains<=buff.blood_fury.duration+3
BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not DeathStrike:InRange(target) then return end

    if 18000 >= gs.gargoyleRemains and gs.gargoyleActive then
        return spell:Cast()
    end

    if (not player:TalentKnown(SummonGargoyle.id) or SummonGargoyle.cd > 60000) and (gs.armyActive and gs.armyRemains <= 18000 or gs.apocActive and gs.apocRemains <= 18000 or gs.activeEnemies >= 2 and gs.dndTicking) or gs.fightRemains <= 18000 then
        return spell:Cast()
    end
end)

-- actions.racials+=/berserking,if=(buff.berserking.duration+3>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60)&(pet.army_ghoul.active&pet.army_ghoul.remains<=buff.berserking.duration+3|pet.apoc_ghoul.active&pet.apoc_ghoul.remains<=buff.berserking.duration+3|active_enemies>=2&death_and_decay.ticking)|fight_remains<=buff.berserking.duration+3
Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not DeathStrike:InRange(target) then return end

    if 15000 >= gs.gargoyleRemains and gs.gargoyleActive then
        return spell:Cast()
    end

    if (not player:TalentKnown(SummonGargoyle.id) or SummonGargoyle.cd > 60000) and (gs.armyActive and gs.armyRemains <= 15000 or gs.apocActive and gs.apocRemains <= 15000 or gs.activeEnemies >= 2 and gs.dndTicking) or gs.fightRemains <= 15000 then
        return spell:Cast()
    end
end)

-- actions.racials+=/lights_judgment,if=buff.unholy_strength.up&(!talent.festermight|buff.festermight.remains<target.time_to_die|buff.unholy_strength.remains<target.time_to_die)
LightsJudgment:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not player:Buff(buffs.unholyStrength) then return end
    if not player:TalentKnown(Festermight.id) or player:BuffRemains(buffs.festermight) < target.ttd or player:BuffRemains(buffs.unholyStrength) < target.ttd then
        return spell:Cast(target)
    end
end)

-- actions.racials+=/ancestral_call,if=(18>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60)&(pet.army_ghoul.active&pet.army_ghoul.remains<=18|pet.apoc_ghoul.active&pet.apoc_ghoul.remains<=18|active_enemies>=2&death_and_decay.ticking)|fight_remains<=18
AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not DeathStrike:InRange(target) then return end

    if 18000 >= gs.gargoyleRemains and gs.gargoyleActive then
        return spell:Cast()
    end

    if (not player:TalentKnown(SummonGargoyle.id) or SummonGargoyle.cd > 60000) and (gs.armyActive and gs.armyRemains <= 18000 or gs.apocActive and gs.apocRemains <= 18000 or gs.activeEnemies >= 2 and gs.dndTicking) or gs.fightRemains <= 18000 then
        return spell:Cast()
    end
end)

-- actions.racials+=/arcane_pulse,if=active_enemies>=2|(rune.deficit>=5&runic_power.deficit>=60)
ArcanePulse:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if gs.activeEnemies >= 2 or (gs.runes <= 1 and player.runicPowerDeficit >= 60) then
        return spell:Cast(target)
    end
end)

-- actions.racials+=/fireblood,if=(buff.fireblood.duration+3>=pet.gargoyle.remains&pet.gargoyle.active)|(!talent.summon_gargoyle|cooldown.summon_gargoyle.remains>60)&(pet.army_ghoul.active&pet.army_ghoul.remains<=buff.fireblood.duration+3|pet.apoc_ghoul.active&pet.apoc_ghoul.remains<=buff.fireblood.duration+3|active_enemies>=2&death_and_decay.ticking)|fight_remains<=buff.fireblood.duration+3
Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not DeathStrike:InRange(target) then return end

    if 8000 >= gs.gargoyleRemains and gs.gargoyleActive then
        return spell:Cast()
    end

    if (not player:TalentKnown(SummonGargoyle.id) or SummonGargoyle.cd > 60000) and (gs.armyActive and gs.armyRemains <= 8000 or gs.apocActive and gs.apocRemains <= 8000 or gs.activeEnemies >= 2 and gs.dndTicking) or gs.fightRemains <= 8000 then
        return spell:Cast()
    end
end)

-- actions.racials+=/bag_of_tricks,if=active_enemies=1&(buff.unholy_strength.up|fight_remains<5)
BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if gs.activeEnemies == 1 and (player:Buff(buffs.unholyStrength) or gs.fightRemains < 5000) then
        return spell:Cast(target)
    end
end)

local function racials()
    ArcaneTorrent()
    BloodFury()
    Berserking()
    LightsJudgment()
    AncestralCall()
    ArcanePulse()
    Fireblood()
    BagOfTricks()
end

-----------------------------------------
---Shared CDs----------------------------
-----------------------------------------

-- actions.cds_shared+=/army_of_the_dead,if=(variable.st_planning|variable.adds_remain)&(talent.commander_of_the_dead&cooldown.dark_transformation.remains<5|!talent.commander_of_the_dead&active_enemies>=1)|fight_remains<35
ArmyoftheDead:Callback("sharedCd", function(spell)
    if player:TalentKnown(RaiseAbomination.id) then return end

    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if gs.stPlanning or gs.addsRemain then
        if player:TalentKnown(CommanderoftheDead.id) and DarkTransformation.cd < 5000 or not player:TalentKnown(CommanderoftheDead.id) and gs.activeEnemies >= 1 then
            return spell:Cast()
        end
    end

    if gs.fightRemains < 35000 then
        return spell:Cast()
    end
end)

-- actions.cds_shared+=/raise_abomination,if=(variable.st_planning|variable.adds_remain)&(!talent.vampiric_strike|(pet.apoc_ghoul.active|!talent.apocalypse))|fight_remains<30
RaiseAbomination:Callback("sharedCd", function(spell)
    if not player:TalentKnown(RaiseAbomination.id) then return end
    if not DeathStrike:InRange(target) then return end

    if not makBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if (gs.stPlanning or gs.addsRemain) and (not gs.sanlayn or (gs.apocActive or not player:TalentKnown(Apocalypse.id))) then
        return spell:Cast()
    end

    if gs.fightRemains < 30000 then
        return spell:Cast()
    end
end)

-- actions.cds_shared+=/summon_gargoyle,use_off_gcd=1,if=(variable.st_planning|variable.adds_remain)&(buff.commander_of_the_dead.up|!talent.commander_of_the_dead&active_enemies>=1)|fight_remains<25
SummonGargoyle:Callback("sharedCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if gs.stPlanning or gs.addsRemain then
        if player:Buff(buffs.commanderOfTheDead) or not player:TalentKnown(CommanderoftheDead.id) and gs.activeEnemies >= 1 then
            return spell:Cast()
        end
    end

    if gs.fightRemains < 25000 then
        return spell:Cast()
    end
end)


local function cdsShared()
    ArmyoftheDead("sharedCd")
    RaiseAbomination("sharedCd")
    SummonGargoyle("sharedCd")
end

-----------------------------------------
---CDs AOE Sanlayn-----------------------
-----------------------------------------

-- actions.cds_aoe_san=dark_transformation,if=variable.adds_remain&(buff.death_and_decay.up|active_enemies<=3)
DarkTransformation:Callback("aoeSanlynCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not pet.exists or pet.hp <= 0 then return end
    if not DeathStrike:InRange(target) then return end

    if gs.addsRemain then
        if player:Buff(buffs.deathAndDecay) or gs.activeEnemies <= 3 then
            return spell:Cast()
        end
    end
end)

-- actions.cds_aoe_san+=/vile_contagion,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=4&(raid_event.adds.remains>4|!raid_event.adds.exists&fight_remains>4)&(raid_event.adds.exists&raid_event.adds.remains<=11|cooldown.any_dnd.remains<3|buff.death_and_decay.up&debuff.festering_wound.stack>=4)|variable.adds_remain&debuff.festering_wound.stack=6
VileContagion:Callback("aoeSanlynCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 4 then
        if gs.addsRemain and (gs.dndCd < 3000 or player:Buff(buffs.deathAndDecay)) then
            return spell:Cast(target)
        end
    end
end)

-- actions.cds_aoe_san+=/unholy_assault,target_if=max:debuff.festering_wound.stack,if=variable.adds_remain&(debuff.festering_wound.stack>=2&cooldown.vile_contagion.remains<6|!talent.vile_contagion)
UnholyAssault:Callback("aoeSanlynCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if gs.addsRemain then
        if target:HasDeBuffCount(debuffs.festeringWound) >= 2 and VileContagion.cd < 6000 or not player:TalentKnown(VileContagion.id) then
            return spell:Cast(target)
        end
    end
end)

-- actions.cds_aoe_san+=/outbreak,if=dot.virulent_plague.ticks_remain<5&(dot.virulent_plague.refreshable|talent.morbidity&!buff.gift_of_the_sanlayn.up&talent.superstrain&dot.frost_fever.refreshable&dot.blood_plague.refreshable)&(!dot.virulent_plague.ticking&variable.epidemic_targets<active_enemies|(!talent.unholy_blight|talent.unholy_blight&cooldown.dark_transformation.remains>5)&(!talent.raise_abomination|talent.raise_abomination&cooldown.raise_abomination.remains>5))
Outbreak:Callback("aoeSanlynCd", function(spell)
    if target:DebuffRemains(debuffs.virulentPlague, true) >= 15000 then return end
    if pet:Buff(buffs.darkTransformation) then return end

    if (gs.virulentPlagueRefreshable or player:TalentKnown(Morbidity.id) and not player:Buff(buffs.giftOfTheSanlayn) and player:TalentKnown(Superstrain.id) and gs.frostFeverRefreshable and gs.bloodPlagueRefreshable) and (not target:Debuff(debuffs.virulentPlague, true) and gs.epidemicTargets < gs.activeEnemies or (not player:TalentKnown(UnholyBlight.id) or player:TalentKnown(UnholyBlight.id) and DarkTransformation.cd > 5000) and (not player:TalentKnown(RaiseAbomination.id) or player:TalentKnown(RaiseAbomination.id) and RaiseAbomination.cd > 5000)) then
        return spell:Cast(target)
    end
end)

-- actions.cds_aoe_san+=/apocalypse,target_if=max:debuff.festering_wound.stack,if=variable.adds_remain&rune<=3
Apocalypse:Callback("aoeSanlynCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[6] then return end
    end

    if gs.addsRemain and gs.runes <= 3 then
        return spell:Cast(target)
    end
end)

-- actions.cds_aoe_san+=/abomination_limb,if=variable.adds_remain
AbominationLimb:Callback("aoeSanlynCd", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[7] then return end
    end

    if gs.addsRemain then
        return spell:Cast()
    end
end)

local function cdsAoESan()
    DarkTransformation("aoeSanlynCd")
    VileContagion("aoeSanlynCd")
    UnholyAssault("aoeSanlynCd")
    Outbreak("aoeSanlynCd")
    Apocalypse("aoeSanlynCd")
    AbominationLimb("aoeSanlynCd")
end

-----------------------------------------
---CDs AOE-------------------------------
-----------------------------------------

-- actions.cds_aoe=vile_contagion,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=4&(raid_event.adds.remains>4|!raid_event.adds.exists&fight_remains>4)&(raid_event.adds.exists&raid_event.adds.remains<=11|cooldown.any_dnd.remains<3|buff.death_and_decay.up&debuff.festering_wound.stack>=4)|variable.adds_remain&debuff.festering_wound.stack=6
VileContagion:Callback("aoeCds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 4 then
        if gs.addsRemain and (gs.dndCd < 3000 or player:Buff(buffs.deathAndDecay)) then
            return spell:Cast(target)
        end
    end
end)

-- actions.cds_aoe+=/unholy_assault,target_if=max:debuff.festering_wound.stack,if=variable.adds_remain&(debuff.festering_wound.stack>=2&cooldown.vile_contagion.remains<3|!talent.vile_contagion)
UnholyAssault:Callback("aoeCds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if gs.addsRemain then
        if target:HasDeBuffCount(debuffs.festeringWound) >= 2 and VileContagion.cd < 3000 or not player:TalentKnown(VileContagion.id) then
            return spell:Cast(target)
        end
    end
end)

-- actions.cds_aoe+=/dark_transformation,if=variable.adds_remain&(cooldown.vile_contagion.remains>5|!talent.vile_contagion|death_and_decay.ticking|cooldown.death_and_decay.remains<3)
DarkTransformation:Callback("aoeCds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not pet.exists or pet.hp <= 0 then return end
    if not DeathStrike:InRange(target) then return end

    if gs.addsRemain then
        if VileContagion.cd > 5000 or not player:TalentKnown(VileContagion.id) or gs.dndTicking or gs.dndCd < 3000 then
            return spell:Cast()
        end
    end
end)

-- actions.cds_aoe+=/outbreak,if=dot.virulent_plague.ticks_remain<5&dot.virulent_plague.refreshable&(!talent.unholy_blight|talent.unholy_blight&cooldown.dark_transformation.remains)&(!talent.raise_abomination|talent.raise_abomination&cooldown.raise_abomination.remains)
Outbreak:Callback("aoeCds", function(spell)
    if target:DebuffRemains(debuffs.virulentPlague) >= 15000 then return end

    if gs.virulentPlagueRefreshable and (not player:TalentKnown(UnholyBlight.id) or player:TalentKnown(UnholyBlight.id) and DarkTransformation.cd > 500) and (not player:TalentKnown(RaiseAbomination.id) or player:TalentKnown(RaiseAbomination.id) and RaiseAbomination.cd > 500) then
        return spell:Cast(target)
    end
end)

-- actions.cds_aoe+=/apocalypse,target_if=max:debuff.festering_wound.stack,if=variable.adds_remain&rune<=3
Apocalypse:Callback("aoeCds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[6] then return end
    end

    if gs.addsRemain and gs.runes <= 3 then
        return spell:Cast(target)
    end
end)

-- actions.cds_aoe+=/abomination_limb,if=variable.adds_remain
AbominationLimb:Callback("aoeCds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[7] then return end
    end

    if gs.addsRemain then
        return spell:Cast()
    end
end)

local function cdsAoE()
    VileContagion("aoeCds")
    UnholyAssault("aoeCds")
    DarkTransformation("aoeCds")
    Outbreak("aoeCds")
    Apocalypse("aoeCds")
    AbominationLimb("aoeCds")
end

-----------------------------------------
---CDs Cleave Sanlayn--------------------
-----------------------------------------

-- actions.cds_cleave_san=dark_transformation,if=buff.death_and_decay.up&(talent.apocalypse&pet.apoc_ghoul.active|!talent.apocalypse)|fight_remains<20|raid_event.adds.exists&raid_event.adds.remains<20
DarkTransformation:Callback("cdsCleaveSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not pet.exists or pet.hp <= 0 then return end
    if not DeathStrike:InRange(target) then return end

    if player:Buff(buffs.deathAndDecay) and player:TalentKnown(Apocalypse.id) and gs.apocActive or not player:TalentKnown(Apocalypse.id) then
        return spell:Cast()
    end

    if gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- actions.cds_cleave_san+=/unholy_assault,if=buff.dark_transformation.up&buff.dark_transformation.remains<12|fight_remains<20|raid_event.adds.exists&raid_event.adds.remains<20
UnholyAssault:Callback("cdsCleaveSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < 12000 then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20000 then
        return spell:Cast(target)
    end
end)

-- actions.cds_cleave_san+=/apocalypse,target_if=max:debuff.festering_wound.stack
Apocalypse:Callback("cdsCleaveSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[6] then return end
    end
end)

-- actions.cds_cleave_san+=/outbreak,target_if=target.time_to_die>dot.virulent_plague.remains&dot.virulent_plague.ticks_remain<5,if=(dot.virulent_plague.refreshable|talent.morbidity&buff.infliction_of_sorrow.up&talent.superstrain&dot.frost_fever.refreshable&dot.blood_plague.refreshable)&(!talent.unholy_blight|talent.unholy_blight&cooldown.dark_transformation.remains>6)&(!talent.raise_abomination|talent.raise_abomination&cooldown.raise_abomination.remains>6)
Outbreak:Callback("cdsCleaveSan", function(spell)
    if target:DebuffRemains(debuffs.virulentPlague) >= 15000 then return end
    if pet:Buff(buffs.darkTransformation) then return end

    if (gs.virulentPlagueRefreshable or player:TalentKnown(Morbidity.id) and player:Buff(buffs.inflictionOfSorrow) and player:TalentKnown(Superstrain.id) and gs.frostFeverRefreshable and gs.bloodPlagueRefreshable) and (not player:TalentKnown(UnholyBlight.id) or player:TalentKnown(UnholyBlight.id) and DarkTransformation.cd > 6000) and (not player:TalentKnown(RaiseAbomination.id) or player:TalentKnown(RaiseAbomination.id) and RaiseAbomination.cd > 6000) then
        return spell:Cast(target)
    end
end)

-- actions.cds_cleave_san+=/abomination_limb,if=!buff.gift_of_the_sanlayn.up&!buff.sudden_doom.react&buff.festermight.up&debuff.festering_wound.stack<=2|!buff.gift_of_the_sanlayn.up&fight_remains<12
AbominationLimb:Callback("cdsCleaveSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[7] then return end
    end

    if not player:Buff(buffs.giftOfTheSanlayn) and not player:Buff(buffs.suddenDoom) and player:Buff(buffs.festermight) and target:HasDeBuffCount(debuffs.festeringWound) <= 2 or not player:Buff(buffs.giftOfTheSanlayn) and gs.fightRemains < 12000 then
        return spell:Cast()
    end
end)

local function cdsCleaveSan()
    DarkTransformation("cdsCleaveSan")
    UnholyAssault("cdsCleaveSan")
    Apocalypse("cdsCleaveSan")
    Outbreak("cdsCleaveSan")
    AbominationLimb("cdsCleaveSan")
end

----------------------------------
---CDs Sanlayn--------------------
----------------------------------

-- actions.cds_san=dark_transformation,if=active_enemies>=1&variable.st_planning&(talent.apocalypse&pet.apoc_ghoul.active|!talent.apocalypse)|fight_remains<20
DarkTransformation:Callback("cdsSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not pet.exists or pet.hp <= 0 then return end
    if not DeathStrike:InRange(target) then return end

    if gs.activeEnemies >= 1 and gs.stPlanning and (player:TalentKnown(Apocalypse.id) and gs.apocActive or not player:TalentKnown(Apocalypse.id)) or gs.fightRemains < 20 then
        return spell:Cast()
    end
end)

-- actions.cds_san+=/unholy_assault,if=variable.st_planning&(buff.dark_transformation.up&buff.dark_transformation.remains<12)|fight_remains<20
UnholyAssault:Callback("cdsSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if gs.stPlanning and pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < 12000 then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20000 then
        return spell:Cast(target)
    end
end)

-- actions.cds_san+=/apocalypse,if=variable.st_planning|fight_remains<20
Apocalypse:Callback("cdsSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[6] then return end
    end

    if gs.stPlanning or gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- actions.cds_san+=/outbreak,target_if=target.time_to_die>dot.virulent_plague.remains&dot.virulent_plague.ticks_remain<5,if=(dot.virulent_plague.refreshable|talent.morbidity&buff.infliction_of_sorrow.up&talent.superstrain&dot.frost_fever.refreshable&dot.blood_plague.refreshable)&(!talent.unholy_blight|talent.unholy_blight&cooldown.dark_transformation.remains>6)&(!talent.raise_abomination|talent.raise_abomination&cooldown.raise_abomination.remains>6)
Outbreak:Callback("cdsSan", function(spell)
    if target:DebuffRemains(debuffs.virulentPlague) >= 15000 then return end
    if pet:Buff(buffs.darkTransformation) then return end

    if (gs.virulentPlagueRefreshable or player:TalentKnown(Morbidity.id) and player:Buff(buffs.inflictionOfSorrow) and player:TalentKnown(Superstrain.id) and gs.frostFeverRefreshable and gs.bloodPlagueRefreshable) and (not player:TalentKnown(UnholyBlight.id) or player:TalentKnown(UnholyBlight.id) and DarkTransformation.cd > 6000) and (not player:TalentKnown(RaiseAbomination.id) or player:TalentKnown(RaiseAbomination.id) and RaiseAbomination.cd > 6000) then
        return spell:Cast(target)
    end
end)

-- actions.cds_san+=/abomination_limb,if=active_enemies>=1&variable.st_planning&!buff.gift_of_the_sanlayn.up&!buff.sudden_doom.react&buff.festermight.up&debuff.festering_wound.stack<=2|!buff.gift_of_the_sanlayn.up&fight_remains<12
AbominationLimb:Callback("cdsSan", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[7] then return end
    end

    if gs.activeEnemies >= 1 and gs.stPlanning and not player:Buff(buffs.giftOfTheSanlayn) and not player:Buff(buffs.suddenDoom) and player:Buff(buffs.festermight) and target:HasDeBuffCount(debuffs.festeringWound) <= 2 or not player:Buff(buffs.giftOfTheSanlayn) and gs.fightRemains < 12000 then
        return spell:Cast()
    end
end)

local function cdsSan()
    DarkTransformation("cdsSan")
    UnholyAssault("cdsSan")
    Apocalypse("cdsSan")
    Outbreak("cdsSan")
    AbominationLimb("cdsSan")
end

--------------------------
---CDs--------------------
--------------------------

-- actions.cds=dark_transformation,if=variable.st_planning&(cooldown.apocalypse.remains<8|!talent.apocalypse|active_enemies>=1)|fight_remains<20
DarkTransformation:Callback("cds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not pet.exists or pet.hp <= 0 then return end
    if not DeathStrike:InRange(target) then return end

    if gs.stPlanning and (Apocalypse.cd < 8000 or not player:TalentKnown(Apocalypse.id) or gs.activeEnemies >= 1) or gs.fightRemains < 20 then
        return spell:Cast()
    end
end)

-- actions.cds+=/unholy_assault,if=variable.st_planning&(cooldown.apocalypse.remains<gcd*2|!talent.apocalypse|active_enemies>=2&buff.dark_transformation.up)|fight_remains<20
UnholyAssault:Callback("cds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[5] then return end
    end

    if gs.stPlanning and (Apocalypse.cd < A.GetGCD() * 2000 or not player:TalentKnown(Apocalypse.id) or gs.activeEnemies >= 2 and pet:Buff(buffs.darkTransformation)) then
        return spell:Cast(target)
    end

    if gs.fightRemains < 20000 then
        return spell:Cast(target)
    end
end)

-- actions.cds+=/apocalypse,if=variable.st_planning|fight_remains<20
Apocalypse:Callback("cds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[6] then return end
    end

    if gs.stPlanning or gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- actions.cds+=/outbreak,target_if=target.time_to_die>dot.virulent_plague.remains&dot.virulent_plague.ticks_remain<5,if=(dot.virulent_plague.refreshable|talent.superstrain&(dot.frost_fever.refreshable|dot.blood_plague.refreshable))&(!talent.unholy_blight|talent.plaguebringer)&(!talent.raise_abomination|talent.raise_abomination&cooldown.raise_abomination.remains>dot.virulent_plague.ticks_remain*3)
Outbreak:Callback("cds", function(spell)
    if pet:Buff(buffs.darkTransformation) then return end

    if (gs.virulentPlagueRefreshable or player:TalentKnown(Superstrain.id) and (gs.frostFeverRefreshable or gs.bloodPlagueRefreshable)) and (not player:TalentKnown(UnholyBlight.id) or player:TalentKnown(Plaguebringer.id)) and (not player:TalentKnown(RaiseAbomination.id) or player:TalentKnown(RaiseAbomination.id) and RaiseAbomination.cd > 9000) then
        return spell:Cast(target)
    end
end)

-- actions.cds+=/abomination_limb,if=variable.st_planning&!buff.sudden_doom.react&(buff.festermight.up&buff.festermight.stack>8|!talent.festermight)&(pet.apoc_ghoul.remains<5|!talent.apocalypse)&debuff.festering_wound.stack<=2|fight_remains<12
AbominationLimb:Callback("cds", function(spell)
    if not makBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[7] then return end
    end

    if gs.stPlanning and not player:Buff(buffs.suddenDoom) and (player:Buff(buffs.festermight) and player:HasBuffCount(buffs.festermight) > 8 or not player:TalentKnown(Festermight.id)) and (gs.apocRemains < 5000 or not player:TalentKnown(Apocalypse.id)) and target:HasDeBuffCount(debuffs.festeringWound, true) <= 2 or gs.fightRemains < 12000 then
        return spell:Cast()
    end
end)

local function cds()
    DarkTransformation("cds")
    UnholyAssault("cds")
    Apocalypse("cds")
    Outbreak("cds")
    AbominationLimb("cds")
end

-----------------------------
---Cleave--------------------
-----------------------------

-- actions.cleave=any_dnd,if=!death_and_decay.ticking&variable.adds_remain&(cooldown.apocalypse.remains|!talent.apocalypse)
DeathandDecay:Callback("cleave", function(spell)
    if player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end
    if not gs.addsRemain then return end
    if player:TalentKnown(Apocalypse.id) then
        if Apocalypse.cd < 500 then return end
    end

    return spell:Cast()
end)

Defile:Callback("cleave", function(spell)
    if not player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end
    if not gs.addsRemain then return end
    if player:TalentKnown(Apocalypse.id) then
        if Apocalypse.cd < 500 then return end
    end

    return spell:Cast()
end)

-- actions.cleave+=/death_coil,if=!variable.pooling_runic_power&talent.improved_death_coil
DeathCoil:Callback("cleave", function(spell)
    if gs.poolingRunicPower then return end
    if not player:TalentKnown(ImprovedDeathCoil.id) then return end

    return spell:Cast(target)
end)

-- actions.cleave+=/wound_spender,if=buff.vampiric_strike.react
ScourgeStrike:Callback("cleave", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.vampiricStrike then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("cleave", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.vampiricStrike then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

-- actions.cleave+=/death_coil,if=!variable.pooling_runic_power&!talent.improved_death_coil
DeathCoil:Callback("cleave2", function(spell)
    if gs.poolingRunicPower then return end
    if player:TalentKnown(ImprovedDeathCoil.id) then return end

    return spell:Cast(target)
end)

-- actions.cleave+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=!buff.vampiric_strike.react&!variable.pop_wounds&debuff.festering_wound.stack<2|buff.festering_scythe.react
-- actions.cleave+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=!buff.vampiric_strike.react&cooldown.apocalypse.remains<variable.apoc_timing&debuff.festering_wound.stack<1
FesteringStrike:Callback("cleave", function(spell)
    if not gs.popWounds and target:HasDeBuffCount(debuffs.festeringWound, true) < 2 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.festeringScythe) then
        return spell:Cast(target)
    end

    if Apocalypse.cd < gs.apocTiming and target:HasDeBuffCount(debuffs.festeringWound, true) < 1 then
        return spell:Cast(target)
    end
end)

-- actions.cleave+=/wound_spender,if=variable.pop_wounds
ScourgeStrike:Callback("cleave2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.popWounds then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("cleave2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.popWounds then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

local function cleave()
    DeathandDecay("cleave")
    Defile("cleave")
    DeathCoil("cleave") 
    ScourgeStrike("cleave")
    ClawingShadows("cleave")
    DeathCoil("cleave2")
    FesteringStrike("cleave")
    ScourgeStrike("cleave2")
    ClawingShadows("cleave2")
end

--------------------------------
---AoE Setup--------------------
--------------------------------

-- actions.aoe_setup=festering_strike,if=buff.festering_scythe.react
-- actions.aoe_setup+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=talent.vile_contagion&cooldown.vile_contagion.remains<5&!debuff.festering_wound.stack=6
-- actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=death_knight.fwounded_targets=0&cooldown.apocalypse.remains<gcd

FesteringStrike:Callback("aoeSetup", function(spell)
    if player:Buff(buffs.festeringScythe) then 
        return spell:Cast(target)
    end

    if player:TalentKnown(VileContagion.id) and VileContagion.cd < 5000 and target:HasDeBuffCount(debuffs.festeringWound, true) < 6 then
        return spell:Cast(target)
    end

    if gs.woundCount == 0 and Apocalypse.cd < A.GetGCD() * 1000 and player:TalentKnown(Apocalypse.id) then
        return spell:Cast(target)
    end
end)

-- actions.aoe_setup+=/wound_spender,target_if=debuff.chains_of_ice_trollbane_slow.up
ScourgeStrike:Callback("aoeSetup", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not target:Debuff(debuffs.chainsOfIceTrollbane, true) then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("aoeSetup", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not target:Debuff(debuffs.chainsOfIceTrollbane, true) then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

-- actions.aoe_setup+=/death_coil,if=!variable.pooling_runic_power&active_enemies<variable.epidemic_targets&rune<4
DeathCoil:Callback("aoeSetup", function(spell)
    if gs.poolingRunicPower then return end
    if gs.runes >= 4 then return end

    if gs.activeEnemies < gs.epidemicTargets then
        return spell:Cast(target)
    end
end)

-- actions.aoe_setup+=/epidemic,if=!variable.pooling_runic_power&variable.epidemic_targets<=active_enemies&rune<4
Epidemic:Callback("aoeSetup", function(spell)
    if gs.vpCount <= 0 then return end

    if gs.poolingRunicPower then return end
    if gs.runes >= 4 then return end

    if gs.epidemicTargets <= gs.activeEnemies then
        return spell:Cast()
    end
end)

-- actions.aoe_setup+=/any_dnd,if=!death_and_decay.ticking&(!talent.bursting_sores&!talent.vile_contagion|death_knight.fwounded_targets=active_enemies|death_knight.fwounded_targets>=8|raid_event.adds.exists&raid_event.adds.remains<=11&raid_event.adds.remains>5|!buff.death_and_decay.up&talent.defile&rune>3)
DeathandDecay:Callback("aoeSetup", function(spell)
    if player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end

    if not player:TalentKnown(BurstingSores.id) and not player:TalentKnown(VileContagion.id) then
        return spell:Cast()
    end

    if gs.woundCount >= math.min(8, gs.activeEnemies) then
        return spell:Cast()
    end 
    
    if gs.addsRemain then
        return spell:Cast()
    end
        
    if not player:Buff(buffs.deathAndDecay) and player:TalentKnown(Defile.id) and gs.runes > 3 then
        return spell:Cast()
    end
end)

Defile:Callback("aoeSetup", function(spell)
    if not player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end

    if not player:TalentKnown(BurstingSores.id) and not player:TalentKnown(VileContagion.id) then
        return spell:Cast()
    end

    if gs.woundCount >= math.min(8, gs.activeEnemies) then
        return spell:Cast()
    end 
    
    if gs.addsRemain then
        return spell:Cast()
    end
        
    if not player:Buff(buffs.deathAndDecay) and player:TalentKnown(Defile.id) and gs.runes > 3 then
        return spell:Cast()
    end
end)

--actions.aoe_setup+=/death_coil,if=!variable.pooling_runic_power&active_enemies<variable.epidemic_targets&(buff.sudden_doom.react|death_knight.fwounded_targets=active_enemies|death_knight.fwounded_targets>=8)
DeathCoil:Callback("aoeSetup2", function(spell)
    if gs.poolingRunicPower then return end

    if gs.activeEnemies < gs.epidemicTargets and (player:Buff(buffs.suddenDoom) or gs.woundCount >= math.min(gs.activeEnemies, 8)) then
        return spell:Cast(target)
    end
end)

--actions.aoe_setup+=/epidemic,if=!variable.pooling_runic_power&variable.epidemic_targets<=active_enemies&(buff.sudden_doom.react|death_knight.fwounded_targets=active_enemies|death_knight.fwounded_targets>=8)
Epidemic:Callback("aoeSetup2", function(spell)
    if gs.vpCount <= 0 then return end

    if gs.poolingRunicPower then return end

    if gs.activeEnemies < gs.epidemicTargets and (player:Buff(buffs.suddenDoom) or gs.woundCount >= math.min(gs.activeEnemies, 8)) then
        return spell:Cast()
    end
end)


-- actions.aoe_setup+=/death_coil,if=!variable.pooling_runic_power&active_enemies<variable.epidemic_targets
DeathCoil:Callback("aoeSetup3", function(spell)
    if gs.poolingRunicPower then return end

    if gs.activeEnemies < gs.epidemicTargets then
        return spell:Cast(target)
    end
end)

-- actions.aoe_setup+=/epidemic,if=!variable.pooling_runic_power
Epidemic:Callback("aoeSetup3", function(spell)
    if gs.vpCount <= 0 then return end

    if gs.poolingRunicPower then return end
    
    return spell:Cast()
end)

-- actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=death_knight.fwounded_targets<8&!death_knight.fwounded_targets=active_enemies
FesteringStrike:Callback("aoeSetup2", function(spell)
    if gs.woundCount < math.min(gs.activeEnemies, 8) then
        return spell:Cast(target)
    end
end)

-- actions.aoe_setup+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=buff.vampiric_strike.react
ScourgeStrike:Callback("aoeSetup2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.vampiricStrike then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("aoeSetup2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if not gs.vampiricStrike then return end
    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

local function aoeSetup()
    FesteringStrike("aoeSetup")
    ScourgeStrike("aoeSetup")
    ClawingShadows("aoeSetup")
    DeathCoil("aoeSetup")
    Epidemic("aoeSetup")
    DeathandDecay("aoeSetup")
    Defile("aoeSetup")
    DeathCoil("aoeSetup2")
    Epidemic("aoeSetup2")
    DeathCoil("aoeSetup3")
    Epidemic("aoeSetup3")
    FesteringStrike("aoeSetup2")
    ScourgeStrike("aoeSetup2")
    ClawingShadows("aoeSetup2")
end

--------------------------------
---AoE Burst--------------------
--------------------------------

-- actions.aoe_burst=festering_strike,if=buff.festering_scythe.react
FesteringStrike:Callback("aoeBurst", function(spell)
    if not player:Buff(buffs.festeringScythe) then return end

    return spell:Cast(target)
end)

-- actions.aoe_burst+=/death_coil,if=!buff.vampiric_strike.react&active_enemies<variable.epidemic_targets&(!talent.bursting_sores|talent.bursting_sores&death_knight.fwounded_targets<active_enemies&death_knight.fwounded_targets<active_enemies*0.4&buff.sudden_doom.react|buff.sudden_doom.react&(talent.doomed_bidding&talent.menacing_magus|talent.rotten_touch|debuff.death_rot.remains<gcd)|rune<2)
DeathCoil:Callback("aoeBurst", function(spell)
    if gs.vampiricStrike then return end
    if gs.activeEnemies >= gs.epidemicTargets then return end

    if not player:TalentKnown(BurstingSores.id) or player:TalentKnown(BurstingSores.id) and gs.woundCount < gs.activeEnemies * 0.4 and player:Buff(buffs.suddenDoom) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.suddenDoom) and (player:TalentKnown(DoomedBidding.id) and player:TalentKnown(MenacingMagus.id) or player:TalentKnown(RottenTouch.id) or target:DebuffRemains(debuffs.rottenTouch, true) < A.GetGCD() * 1000) or gs.runes < 2 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_burst+=/epidemic,if=!buff.vampiric_strike.react&(!talent.bursting_sores|talent.bursting_sores&death_knight.fwounded_targets<active_enemies&death_knight.fwounded_targets<active_enemies*0.4&buff.sudden_doom.react|buff.sudden_doom.react&(buff.a_feast_of_souls.up|debuff.death_rot.remains<gcd|debuff.death_rot.stack<10)|rune<2)
Epidemic:Callback("aoeBurst", function(spell)
    if gs.vpCount <= 0 then return end

    if gs.vampiricStrike then return end

    if not player:TalentKnown(BurstingSores.id) or player:TalentKnown(BurstingSores.id) and gs.woundCount < gs.activeEnemies * 0.4 and player:Buff(buffs.suddenDoom) then
        return spell:Cast()
    end

    if player:Buff(buffs.suddenDoom) and (player:Buff(buffs.aFeastOfSouls) or target:DebuffRemains(debuffs.rottenTouch, true) < A.GetGCD() * 1000 or target:HasDeBuffCount(debuffs.deathRot, true) < 10) or gs.runes < 2 then
        return spell:Cast()
    end
end)

-- actions.aoe_burst+=/wound_spender,target_if=debuff.chains_of_ice_trollbane_slow.up
-- actions.aoe_burst+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=1|buff.vampiric_strike.react
ScourgeStrike:Callback("aoeBurst", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    if target:Debuff(debuffs.chainsOfIceTrollbane, true) then
        return spell:Cast(target)
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 then
        return spell:Cast(target)
    end

    if gs.vampiricStrike then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("aoeBurst", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:Debuff(debuffs.chainsOfIceTrollbane, true) then
        return spell:Cast(target)
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 then
        return spell:Cast(target)
    end

    if gs.vampiricStrike then
        return spell:Cast(target)
    end
end)

-- actions.aoe_burst+=/death_coil,if=active_enemies<variable.epidemic_targets
DeathCoil:Callback("aoeBurst2", function(spell)
    if gs.activeEnemies >= gs.epidemicTargets then return end

    return spell:Cast(target)
end)

-- actions.aoe_burst+=/epidemic
Epidemic:Callback("aoeBurst2", function(spell)
    if gs.vpCount <= 0 then return end

    return spell:Cast()
end)

-- actions.aoe_burst+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=debuff.festering_wound.stack<=2
FesteringStrike:Callback("aoeBurst2", function(spell)
    if target:HasDeBuffCount(debuffs.festeringWound, true) <= 2 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_burst+=/wound_spender,target_if=max:debuff.festering_wound.stack
ScourgeStrike:Callback("aoeBurst2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("aoeBurst2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    return spell:Cast(target)
end)

local function aoeBurst()
    FesteringStrike("aoeBurst")
    DeathCoil("aoeBurst")
    Epidemic("aoeBurst")
    ScourgeStrike("aoeBurst")
    ClawingShadows("aoeBurst")
    DeathCoil("aoeBurst2")
    Epidemic("aoeBurst2")
    FesteringStrike("aoeBurst2")
    ScourgeStrike("aoeBurst2")
    ClawingShadows("aoeBurst2")
end

--------------------------
---AoE--------------------
--------------------------

-- actions.aoe=festering_strike,if=buff.festering_scythe.react
FesteringStrike:Callback("aoe", function(spell)
    if not player:Buff(buffs.festeringScythe) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=1&buff.death_and_decay.up&talent.bursting_sores&cooldown.apocalypse.remains>variable.apoc_timing
ScourgeStrike:Callback("aoe", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 and player:Buff(buffs.deathAndDecay) and player:TalentKnown(BurstingSores.id) and Apocalypse.cd > gs.apocTiming then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("aoe", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 and player:Buff(buffs.deathAndDecay) and player:TalentKnown(BurstingSores.id) and Apocalypse.cd > gs.apocTiming then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/death_coil,if=!variable.pooling_runic_power&active_enemies<variable.epidemic_targets
DeathCoil:Callback("aoe", function(spell)
    if gs.poolingRunicPower then return end

    if gs.activeEnemies < gs.epidemicTargets then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/epidemic,if=!variable.pooling_runic_power
Epidemic:Callback("aoe", function(spell)
    if gs.vpCount <= 0 then return end

    if gs.poolingRunicPower then return end

    return spell:Cast()
end)

-- actions.aoe+=/wound_spender,target_if=debuff.chains_of_ice_trollbane_slow.up
ScourgeStrike:Callback("aoe2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not target:Debuff(debuffs.chainsOfIceTrollbane, true) then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("aoe2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not target:Debuff(debuffs.chainsOfIceTrollbane, true) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=cooldown.apocalypse.remains<variable.apoc_timing|buff.festering_scythe.react
-- actions.aoe+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=debuff.festering_wound.stack<2
FesteringStrike:Callback("aoe2", function(spell)
    if Apocalypse.cd < gs.apocTiming then
        return spell:Cast(target)
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) < 2 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack>=1&cooldown.apocalypse.remains>gcd|buff.vampiric_strike.react&dot.virulent_plague.ticking
ScourgeStrike:Callback("aoe3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 and Apocalypse.cd > A.GetGCD() * 1000 or gs.vampiricStrike and target:Debuff(debuffs.virulentPlague, true) then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("aoe3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 and Apocalypse.cd > A.GetGCD() * 1000 or gs.vampiricStrike and target:Debuff(debuffs.virulentPlague, true) then
        return spell:Cast(target)
    end
end)

local function aoe()
    FesteringStrike("aoe")
    ScourgeStrike("aoe")
    ClawingShadows("aoe")
    DeathCoil("aoe")
    Epidemic("aoe")
    ScourgeStrike("aoe2")
    ClawingShadows("aoe2")
    FesteringStrike("aoe2")
    ScourgeStrike("aoe3")
    ClawingShadows("aoe3")
end

--------------------------
---Sanlayn Fishing--------
--------------------------

-- actions.san_fishing+=/wound_spender,if=buff.infliction_of_sorrow.up
ScourgeStrike:Callback("sanFishing", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not player:Buff(buffs.inflictionOfSorrow) then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("sanFishing", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not player:Buff(buffs.inflictionOfSorrow) then return end

    return spell:Cast(target)
end)

-- actions.san_fishing+=/any_dnd,if=!buff.death_and_decay.up&!buff.vampiric_strike.react
DeathandDecay:Callback("sanFishing", function(spell)
    if player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if player:Buff(buffs.deathAndDecay) then return end
    if gs.vampiricStrike then return end

    return spell:Cast()
end)

Defile:Callback("sanFishing", function(spell)
    if not player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if player:Buff(buffs.deathAndDecay) then return end
    if gs.vampiricStrike then return end

    return spell:Cast()
end)

-- actions.san_fishing+=/death_coil,if=buff.sudden_doom.react&talent.doomed_bidding|set_bonus.tww2_4pc&buff.essence_of_the_blood_queen.at_max_stacks&talent.frenzied_bloodthirst&!buff.vampiric_strike.react
DeathCoil:Callback("sanFishing", function(spell)
    if player:Buff(buffs.suddenDoom) and player:TalentKnown(DoomedBidding.id) or player:Has4Set() and player:HasBuffCount(buffs.essenceOfTheBloodQueen) >= 7 and player:TalentKnown(FrenziedBloodthirst.id) and not gs.vampiricStrike then
        return spell:Cast(target)
    end
end)

-- actions.san_fishing+=/soul_reaper,if=target.health.pct<=35&fight_remains>5
SoulReaper:Callback("sanFishing", function(spell)
    if A.IsInPvP then
        if target.hp <= A.GetToggle(2, "soulReaperHP") then
            return spell:Cast(target)
        end
    end

    if target.hp <= 35 and gs.fightRemains > 5000 then
        return spell:Cast(target)
    end
end)

-- actions.san_fishing+=/death_coil,if=!buff.vampiric_strike.react
DeathCoil:Callback("sanFishing2", function(spell)
    if gs.vampiricStrike then return end

    return spell:Cast(target)
end)

-- actions.san_fishing+=/wound_spender,if=(debuff.festering_wound.stack>=3-pet.abomination.active&cooldown.apocalypse.remains>variable.apoc_timing)|buff.vampiric_strike.react
ScourgeStrike:Callback("sanFishing2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if gs.vampiricStrike then 
        return spell:Cast(target)
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 3 - num(gs.abomActive) and Apocalypse.cd > gs.apocTiming then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("sanFishing2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if gs.vampiricStrike then 
        return spell:Cast(target)
    end

    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 3 - num(gs.abomActive) and Apocalypse.cd > gs.apocTiming then
        return spell:Cast(target)
    end
end)

-- actions.san_fishing+=/festering_strike,if=debuff.festering_wound.stack<3-pet.abomination.active
FesteringStrike:Callback("sanFishing", function(spell)
    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 3 - num(gs.abomActive) then
        return spell:Cast(target)
    end
end)

local function sanFishing()
    ScourgeStrike("sanFishing")
    ClawingShadows("sanFishing")
    DeathandDecay("sanFishing")
    Defile("sanFishing")
    DeathCoil("sanFishing")
    SoulReaper("sanFishing")
    DeathCoil("sanFishing2")
    ScourgeStrike("sanFishing2")
    ClawingShadows("sanFishing2")
    FesteringStrike("sanFishing")
end

---------------------
---Sanlayn ST--------
---------------------
-- actions.san_st=any_dnd,if=!death_and_decay.ticking&talent.unholy_ground&cooldown.dark_transformation.remains<5
DeathandDecay:Callback("sanSt", function(spell)
    if player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end
    if not player:TalentKnown(UnholyGround.id) then return end
    if DarkTransformation.cd >= 5000 and makBurst() then return end

    return spell:Cast()
end)

Defile:Callback("sanSt", function(spell)
    if not player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if gs.dndTicking then return end
    if not player:TalentKnown(UnholyGround.id) then return end
    if DarkTransformation.cd >= 5000 and makBurst() then return end

    return spell:Cast()
end)

-- actions.san_st+=/wound_spender,if=buff.infliction_of_sorrow.up
ScourgeStrike:Callback("sanSt", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    if not player:Buff(buffs.inflictionOfSorrow) then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("sanSt", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not player:Buff(buffs.inflictionOfSorrow) then return end

    return spell:Cast(target)
end)

-- actions.san_st+=/death_coil,if=buff.sudden_doom.react&buff.gift_of_the_sanlayn.remains&(talent.doomed_bidding|talent.rotten_touch)|rune<3&!buff.runic_corruption.up|set_bonus.tww2_4pc&runic_power>80|buff.gift_of_the_sanlayn.up&buff.essence_of_the_blood_queen.at_max_stacks&talent.frenzied_bloodthirst&set_bonus.tww2_4pc&buff.winning_streak.at_max_stacks&rune<=3&buff.essence_of_the_blood_queen.remains>3
DeathCoil:Callback("sanSt", function(spell)
    if player:Buff(buffs.suddenDoom) and player:Buff(buffs.giftOfTheSanlayn) and (player:TalentKnown(DoomedBidding.id) or player:TalentKnown(RottenTouch.id)) then
        return spell:Cast(target)
    end

    if gs.runes < 3 and not player:Buff(buffs.runicCorruption) then
        return spell:Cast(target)
    end

    if player:Has4Set() and player.runicPower > 80 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.giftOfTheSanlayn) and player:HasBuffCount(buffs.essenceOfTheBloodQueen) >= 7 and player:TalentKnown(FrenziedBloodthirst.id) and player:Has4Set() and player:HasBuffCount(buffs.winningStreak) >= 10 and gs.runes <= 3 and player:BuffRemains(buffs.essenceOfTheBloodQueen) > 3000 then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/wound_spender,if=buff.vampiric_strike.react&debuff.festering_wound.stack>=1|buff.gift_of_the_sanlayn.up|talent.gift_of_the_sanlayn&buff.dark_transformation.up&buff.dark_transformation.remains<gcd
ScourgeStrike:Callback("sanSt2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if gs.vampiricStrike and target:Debuff(debuffs.festeringWound, true) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.giftOfTheSanlayn) then
        return spell:Cast(target)
    end

    if player:TalentKnown(GiftoftheSanlayn.id) and pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("sanSt2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if gs.vampiricStrike and target:Debuff(debuffs.festeringWound, true) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.giftOfTheSanlayn) then
        return spell:Cast(target)
    end

    if player:TalentKnown(GiftoftheSanlayn.id) and pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/soul_reaper,if=target.health.pct<=35&!buff.gift_of_the_sanlayn.up&fight_remains>5
SoulReaper:Callback("sanSt", function(spell)
    if A.IsInPvP then
        if target.hp <= A.GetToggle(2, "soulReaperHP") then
            return spell:Cast(target)
        end
    end

    if target.hp <= 35 and not player:Buff(buffs.giftOfTheSanlayn) and gs.fightRemains > 5000 then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/festering_strike,if=(debuff.festering_wound.stack=0&cooldown.apocalypse.remains<variable.apoc_timing)|(talent.gift_of_the_sanlayn&!buff.gift_of_the_sanlayn.up|!talent.gift_of_the_sanlayn)&(buff.festering_scythe.react|debuff.festering_wound.stack<=1)
FesteringStrike:Callback("sanSt", function(spell)
    if (not target:Debuff(debuffs.festeringWound, true) and Apocalypse.cd < gs.apocTiming) or (player:TalentKnown(GiftoftheSanlayn.id) and not player:Buff(buffs.giftOfTheSanlayn) or not player:TalentKnown(GiftoftheSanlayn.id)) and (not player:Buff(buffs.festeringScythe) or target:HasDeBuffCount(debuffs.festeringWound, true) <= 1) then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/wound_spender,if=(!talent.apocalypse|cooldown.apocalypse.remains>variable.apoc_timing)&(debuff.festering_wound.stack>=3-pet.abomination.active|buff.vampiric_strike.react)
ScourgeStrike:Callback("sanSt3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if (not player:TalentKnown(Apocalypse.id) or Apocalypse.cd > gs.apocTiming) and (target:HasDeBuffCount(debuffs.festeringWound, true) >= 3 - num(gs.abomActive) or gs.vampiricStrike) then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("sanSt3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if (not player:TalentKnown(Apocalypse.id) or Apocalypse.cd > gs.apocTiming) and (target:HasDeBuffCount(debuffs.festeringWound, true) >= 3 - num(gs.abomActive) or gs.vampiricStrike) then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/death_coil,if=!variable.pooling_runic_power&debuff.death_rot.remains<gcd|(buff.sudden_doom.react&debuff.festering_wound.stack>=1|rune<2)
DeathCoil:Callback("sanSt2", function(spell)
    if not gs.poolingRunicPower and target:DebuffRemains(debuffs.deathRot, true) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.suddenDoom) and target:HasDeBuffCount(debuffs.festeringWound, true) >= 1 then
        return spell:Cast(target)
    end

    if gs.runes < 2 then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/wound_spender,if=debuff.festering_wound.stack>4
ScourgeStrike:Callback("sanSt4", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) > 4 then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("sanSt4", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) > 4 then
        return spell:Cast(target)
    end
end)

-- actions.san_st+=/death_coil,if=!variable.pooling_runic_power
DeathCoil:Callback("sanSt3", function(spell)
    if gs.poolingRunicPower then return end

    return spell:Cast(target)
end)

local function sanSt()
    DeathandDecay("sanSt")
    Defile("sanSt")
    ScourgeStrike("sanSt")
    ClawingShadows("sanSt")
    DeathCoil("sanSt")
    ScourgeStrike("sanSt2")
    ClawingShadows("sanSt2")
    SoulReaper("sanSt")
    FesteringStrike("sanSt")
    ScourgeStrike("sanSt3")
    ClawingShadows("sanSt3")
    DeathCoil("sanSt2")
    ScourgeStrike("sanSt4")
    ClawingShadows("sanSt4")
    DeathCoil("sanSt3")
end

--------------------------
---ST---------------------
--------------------------

-- actions.st=soul_reaper,if=target.health.pct<=35&fight_remains>5
SoulReaper:Callback("st", function(spell)
    if A.IsInPvP then
        if target.hp <= A.GetToggle(2, "soulReaperHP") then
            return spell:Cast(target)
        end
    end

    if target.hp <= 35 and gs.fightRemains > 5000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/wound_spender,if=debuff.chains_of_ice_trollbane_slow.up
ScourgeStrike:Callback("st", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:Debuff(debuffs.chainsOfIceTrollbane, true) then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("st", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if target:Debuff(debuffs.chainsOfIceTrollbane, true) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/any_dnd,if=talent.unholy_ground&!buff.death_and_decay.up&(pet.apoc_ghoul.active|pet.abomination.active|pet.gargoyle.active)
DeathandDecay:Callback("st", function(spell)
    if player:TalentKnown(Defile.id) then return end

    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if not player:TalentKnown(UnholyGround.id) then return end
    if player:Buff(buffs.deathAndDecay) then return end

    if gs.apocActive or gs.abomActive or gs.gargActive or not makBurst() then
        return spell:Cast()
    end
end)

Defile:Callback("st", function(spell)
    if not player:TalentKnown(Defile.id) then return end
    
    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end

    if not player:TalentKnown(UnholyGround.id) then return end
    if player:Buff(buffs.deathAndDecay) then return end

    if gs.apocActive or gs.abomActive or gs.gargActive or not makBurst() then
        return spell:Cast()
    end
end)

-- actions.st+=/death_coil,if=!variable.pooling_runic_power&variable.spend_rp|fight_remains<10
DeathCoil:Callback("st", function(spell)
    if not gs.poolingRunicPower and gs.spendRp then
        return spell:Cast(target)
    end

    if gs.fightRemains < 10000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/festering_strike,if=debuff.festering_wound.stack<4&(!variable.pop_wounds|buff.festering_scythe.react)
FesteringStrike:Callback("st", function(spell)
    if target:HasDeBuffCount(debuffs.festeringWound, true) < 4 and (not gs.popWounds or player:Buff(buffs.festeringScythe)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/wound_spender,if=variable.pop_wounds
ScourgeStrike:Callback("st2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not gs.popWounds then return end

    return spell:Cast(target)
end)

ClawingShadows:Callback("st2", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if not gs.popWounds then return end

    return spell:Cast(target)
end)

-- actions.st+=/death_coil,if=!variable.pooling_runic_power
DeathCoil:Callback("st2", function(spell)
    if gs.poolingRunicPower then return end

    return spell:Cast(target)
end)

-- actions.st+=/wound_spender,if=!variable.pop_wounds&debuff.festering_wound.stack>=4
ScourgeStrike:Callback("st3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end
    
    if gs.popWounds then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 4 then
        return spell:Cast(target)
    end
end)

ClawingShadows:Callback("st3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if gs.runes < 1 then return end

    if gs.popWounds then return end
    
    if target:HasDeBuffCount(debuffs.festeringWound, true) >= 4 then
        return spell:Cast(target)
    end
end)

local function st()
    SoulReaper("st")
    ScourgeStrike("st")
    ClawingShadows("st")
    DeathandDecay("st")
    Defile("st")
    DeathCoil("st")
    FesteringStrike("st")
    ScourgeStrike("st2")
    ClawingShadows("st2")
    DeathCoil("st2")
    ScourgeStrike("st3")
    ClawingShadows("st3")
end

--------------------------
---PvP--------------------
--------------------------

local function stunWithGnaw()
    local gnawStun = {
        [198013] = true, -- Eye Beam
        [452497] = true, -- Abyssal Stare
        [443028] = true, -- Celestial Conduit
        [443038] = true, -- Celestial Conduit
    }

    if not target or not target.castOrChannelInfo then
        return false
    end

    local casting = target.castOrChannelInfo
    return gnawStun[casting.spellId] or false
end

DeathGrip:Callback("pvp", function(spell)
    if not target.player then return end
    if target.hp > A.GetToggle(2, "pvpDeathGripHP") then return end
    if target.distance < A.GetToggle(2, "pvpDeathGripDist") then return end
    if target.ccImmune then return end
    if target:BuffFrom(MakLists.dontGrip) then return end
    if target:DebuffFrom(MakLists.zerkRoot) then return end
    if target:Buff(buffs.deathsAdvance) then return end

    return spell:Cast(target)
end)

ChainsofIce:Callback("pvp", function(spell)
    if not target.player then return end
    if target.hp < 15 then return end
    if target.hp > A.GetToggle(2, "pvpCOIHP") then return end
    if target.distance < A.GetToggle(2, "pvpCOIDist") then return end
    if target.ccImmune then return end

    local _, runSpeed = GetUnitSpeed(target:CallerId())
    if runSpeed < 100 then return end
    if target:DebuffFrom(MakLists.slowed) then return end

    return spell:Cast(target)
end)

local function pvpenis()
    DeathGrip("pvp")
    ChainsofIce("pvp")
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

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Active Enemies: ", gs.activeEnemies)
        MakPrint(2, "Epidemic Targets: ", gs.epidemicTargets)
        MakPrint(3, "Pooling Runic Power: ", gs.poolingRunicPower)
        MakPrint(4, "Spend Runic Power: ", gs.spendRp)
        MakPrint(5, "DnD Ticking: ", gs.dndTicking)
        MakPrint(6, "aoeBurst: ", gs.dndTicking or player:Buff(buffs.deathAndDecay) and gs.woundCount >= (gs.activeEnemies / 2))
        MakPrint(7, "aoeSetup: ", not gs.dndTicking and gs.dndCd < 10000)
        MakPrint(8, "Runes: ", gs.runes)
        MakPrint(9, "Active Abomination: ", gs.abomActive)
        MakPrint(10, "DnD cooldown: ", gs.dndCd)
        MakPrint(11, "Sanlayn: ", gs.sanlayn)
        MakPrint(12, "Wound Count: ", gs.woundCount)
    end

    if player.channeling then return end
	
    makInterrupt(interrupts)
    util()

    if player.combat then
        defensives()
    end

    if target.exists and target.canAttack and DeathCoil:InRange(target) then

        if A.IsInPvP then
            pvpenis()

            if A.Gnaw:IsReadyByPassCastGCD("target") then
                if not target.physImmune and target.stunDr > 0.5 and pet:Buff(buffs.darkTransformation) then
                    if target.hp < 25 or stunWithGnaw() then
                        return A.Gnaw:Show(icon)
                    end
                end
            end
        end

        if makBurst() then
            racials()

            if pet:Buff(buffs.darkTransformation) then
                --[[if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end]]
                if A.Trinket1:IsReady() then return A.Trinket1:Show(icon) end
                if A.Trinket2:IsReady() then return A.Trinket2:Show(icon) end
            end
            
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = gs.activeEnemies >= 1 and (not player:TalentKnown(SummonGargoyle.id) or SummonGargoyle.cd > 60000) and (pet:Buff(buffs.darkTransformation) and pet:BuffRemains(buffs.darkTransformation) < 30000 or gs.armyActive and gs.armyRemains <= 30000 or gs.apocActive and gs.apocRemains <= 30000 or gs.abomActive and gs.abomRemains <= 30000 or gs.fightRemains <= 30000) or gs.fightRemains <= 30000
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        cdsShared()

        if gs.shouldAoE then
            if gs.sanlayn then
                if gs.activeEnemies >= 3 then
                    cdsAoESan()
                end
                if gs.activeEnemies == 2 then
                    cdsCleaveSan()
                end
                if gs.activeEnemies <= 1 then
                    cdsSan()
                end
            else
                if gs.activeEnemies >= 2 then
                    cdsAoE()
                else
                    cds()
                end
            end

            if gs.activeEnemies >= 3 then
                if gs.dndTicking or player:Buff(buffs.deathAndDecay) and gs.woundCount >= (gs.activeEnemies / 2) then
                    aoeBurst()
                else
                    if not gs.dndTicking and gs.dndCd < 10000 then
                        aoeSetup()
                    else
                        aoe()
                    end
                end
            end

            if gs.activeEnemies == 2 then
                cleave()
            end
        end

        if gs.activeEnemies <= 1 or not gs.shouldAoE then
            if gs.sanlayn then
                if player:TalentKnown(GiftoftheSanlayn.id) and DarkTransformation.cd > 500 and not player:Buff(buffs.giftOfTheSanlayn) and player:BuffRemains(buffs.essenceOfTheBloodQueen) < DarkTransformation.cd + 3000 then
                    sanFishing()
                end
                sanSt()
            else
                st()
            end
        end

    end

    return FrameworkEnd()
end

local enemyRotation = function(enemy)
	if not enemy.exists then return end

end

local partyRotation = function(friendly)
    if not friendly.exists then return end

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
