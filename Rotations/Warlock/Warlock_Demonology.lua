if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 266 then return end

local FrameworkStart   = MakuluFramwork.start
local FrameworkEnd     = MakuluFramwork.endFunc
local RegisterIcon     = MakuluFramwork.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local MakGCD           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local Trinket          = MakuluFramework.Trinket
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache
local constCell        = cacheContext:getConstCacheCell()
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local Pet              = LibStub("PetLibrary")

local _G, setmetatable = _G, setmetatable

local ActionID       = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { ignoreCasting = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { ignoreCasting = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { ignoreCasting = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { ignoreCasting = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { ignoreCasting = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { ignoreCasting = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { ignoreCasting = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { ignoreCasting = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { ignoreCasting = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { ignoreCasting = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { ignoreCasting = true } },
    Fireblood = { ID = 26522, MAKULU_INFO = { ignoreCasting = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { ignoreCasting = true } },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { ignoreCasting = true } },
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { ignoreCasting = true } },
    AncestralCall = { ID = 274738, Texture = 59752, MAKULU_INFO = { ignoreCasting = true } },

    AmplifyCurse          = { ID = 328774, MAKULU_INFO = { ignoreCasting = true } },
    AxeToss               = { ID = 119898, MAKULU_INFO = { damageType = "physical", offGcd = true, ignoreCasting = true } },
    Banish                = { ID = 710, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    BilescourgeBombers    = { ID = 267211, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    BurningRush           = { ID = 111400, MAKULU_INFO = { ignoreCasting = true } },
    CallDreadstalkers     = { ID = 104316, FixedTexture = 1378282, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    Corruption            = { ID = 172, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CreateHealthstone     = { ID = 6201, MAKULU_INFO = { ignoreCasting = true } },
    CreateSoulwell        = { ID = 29893, MAKULU_INFO = { ignoreCasting = true } },
    CurseOfExhaustion     = { ID = 334275, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CurseOfTongues        = { ID = 1714, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CurseOfWeakness       = { ID = 702, Texture = 68992, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DarkPact              = { ID = 108416, MAKULU_INFO = { ignoreCasting = true } },
    Demonbolt             = { ID = 264178, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DemonicCircle         = { ID = 48018, MAKULU_INFO = { ignoreCasting = true } },
    DemonicCircleTeleport = { ID = 48020, MAKULU_INFO = { ignoreCasting = true } },
    DemonicStrength       = { ID = 267171, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Doom                  = { ID = 460551, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DrainLife             = { ID = 234153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Fear                  = { ID = 5782, MAKULU_INFO = { ignoreCasting = true } },
    FelDomination         = { ID = 333889, MAKULU_INFO = { ignoreCasting = true } },
    GrimoireFelguard      = { ID = 111898, Texture = 108503, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    Guillotine            = { ID = 386833, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    HandOfGuldan          = { ID = 105174, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    HealthFunnel          = { ID = 755, MAKULU_INFO = { ignoreCasting = true } },
    HowlOfTerror          = { ID = 5484, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Implosion             = { ID = 196277, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    InfernalBolt          = { ID = 434506, FixedTexture = 136197, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MortalCoil            = { ID = 6789, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PowerSiphon           = { ID = 264130, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShadowBolt            = { ID = 686, FixedTexture = 136197, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowflame           = { ID = 384069, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowfury            = { ID = 30283, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    SoulStrike            = { ID = 264057, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Soulburn              = { ID = 385899, MAKULU_INFO = { ignoreCasting = true } },
    Soulstone             = { ID = 20707, MAKULU_INFO = { ignoreCasting = true } },
    SubjugateDemon        = { ID = 1098, MAKULU_INFO = { ignoreCasting = true } },
    SummonCharhound       = { ID = 455476, FixedTexture = 1616211, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    SummonDemonicTyrant   = { ID = 265187, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SummonFelguard        = { ID = 30146, MAKULU_INFO = { ignoreCasting = true } },
    SummonFelhunter       = { ID = 691, MAKULU_INFO = { ignoreCasting = true } },
    SummonGloomhound      = { ID = 455465, FixedTexture = 1616211, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    SummonImp             = { ID = 688, MAKULU_INFO = { ignoreCasting = true } },
    SummonSayaad          = { ID = 366222, MAKULU_INFO = { ignoreCasting = true } },
    SummonSoulkeeper      = { ID = 386256, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SummonVilefiend       = { ID = 264119, FixedTexture = 1616211, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    SummonVoidwalker      = { ID = 697, MAKULU_INFO = { ignoreCasting = true } },
    UnendingBreath        = { ID = 5697, MAKULU_INFO = { ignoreCasting = true } },
    UnendingResolve       = { ID = 104773, MAKULU_INFO = { ignoreCasting = true } },

    CallFelLord = { ID = 212459, MAKULU_INFO = { ignoreCasting = true } },
    CallObserver = { ID = 201996, MAKULU_INFO = { ignoreCasting = true } },

    SacrificedSouls = { ID = 267214, Hidden = true },
    ReignofTyranny = { ID = 427684, Hidden = true },
    GrandWarlocksDesign = { ID = 387084, Hidden = true },
    SoulboundTyrant = { ID = 334585, Hidden = true },
    FelInvocation = { ID = 428351, Hidden = true },
    MarkOfFharg = { ID = 455450, Hidden = true },
    MarkOfShatug = { ID = 455449, Hidden = true },

    Ruination = { ID = 434635, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    
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

Action[ACTION_CONST_WARLOCK_DEMONOLOGY] = A

TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "ShadowBolt", "Demonbolt", "CallDreadstalkers", "HandOfGuldan",
        "SummonVilefiend", "SummonCharhound", "SummonGloomhound",
        "GrimoireFelguard", "SummonDemonicTyrant", "InfernalBolt",
        "BilescourgeBombers", "Implosion", "Doom", "Ruination"
    }

    for _, spellName in ipairs(castTimeSpellNames) do
        local spell = M[spellName]
        if spell then
            -- Use rawset to directly set the ignoreMoving property on the spell object
            rawset(spell, "ignoreMoving", castWhileMoving)
        end
    end
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

local gs = {
    petExpire = 0,
    pets = {
        [55659] = { active = false, remains = 0 },    -- Wild Imps
        [98035] = { active = false, remains = 0 },   -- Dreadstalkers
        [17252] = { active = false, remains = 0 },   -- Felguard
        [135816] = { active = false, remains = 0 },  -- Vilefiend
        [226268] = { active = false, remains = 0 },  -- Gloomhound
        [226269] = { active = false, remains = 0 },  -- Charhound
    },
    impl = false,
    spreadDemonbolt = false,
    soulShards = 0,
    imCasting = nil,
    dreadstalkersActive = false,
    vilefiendActive = false,
    activeEnemies = 1,
}

local buffs = {
    arenaPreparation = 32727,
    netherPortal = 267218,
    demonicPower = 265273,
    demonicCore = 264173,
    demonicCalling = 205146,
    pitLord = 432795,
    motherOfChaos = 432794,
    overlord = 428524,
    ritualPitLord = 432816,
    ritualMother = 432815,
    ritualOverlord = 431944,
    ruination = 433885,
    infernalBolt = 433891,
}

local debuffs = {
    exhaustion = 57723,
    doomBrand = 423583,
    curseOfExhaustion = 334275,
    curseOfTongues = 1714,
    curseOfWeakness = 702,
    doom = 460553,
}

local interrupts = {
    { spell = AxeToss, isCC = true },
    { spell = MortalCoil, isCC = true },
    { spell = HowlOfTerror, isCC = true, aoe = true, distance = 3 },
}

local function num(val)
    if val then return 1 else return 0 end
end

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if ShadowBolt:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

Pet:AddActionsSpells(266, {
    30213, -- Legion Strike
}, true)

local function activeEnemies()

    local aoeDetection = A.GetToggle(2, "aoeDetection")

    if Pet:IsSpellKnown(30213) and aoeDetection == "Pet" then -- Legion Strike
        return math.max(Pet:GetInRange(30213), Player:GetDeBuffsUnitCount(270569)) -- Houndmaster's Strategem
        else return math.max(enemiesInRange(), 1)
    end

end

local function predSoulShards()
    local shardChanges = {
        [CallDreadstalkers.id] = -2,
        [HandOfGuldan.id] = -3,
        [SummonVilefiend.id] = -1,
        [SummonCharhound.id] = -1,
        [SummonGloomhound.id] = -1,
        [GrimoireFelguard.id] = -1,
        [Demonbolt.id] = 2,
        [ShadowBolt.id] = 1,
        [InfernalBolt.id] = 3,
    }
    
    local casting = player:CastOrChanelInfo()
    local spellId = casting and casting.spellId
    local currentShards = player.soulShards
    
    if casting and casting == SummonDemonicTyrant.id and player:TalentKnown(SoulboundTyrant.id) then 
        return currentShards + 3 
    else
        return math.min(currentShards + (shardChanges[spellId] or 0), 5)
    end
end

local function shouldBurst()
    return makBurst()
end

-- Tracker for Pets
Pet:AddTrackers(266, Pet.Data.TrackersConfigPetID[266])
local demonologyPetTracker = Pet.Data.Trackers[266]

-- Block errors
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED", function()
    Action.TimerSet("DISABLE_PET_ERRORS", 99999, function() Pet:DisableErrors(true) end)
end)

-- Callback for when a pet is added
TMW:RegisterCallback("TMW_ACTION_PET_LIBRARY_ADDED", function(_, PetID, PetGUID, PetData)
    local currentTime = GetTime()
    local permanentFelguard = UnitGUID("pet")
    if PetID == 55659 or PetID == 143622 then -- Wild Imps
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.impcasts = 6
        petGUIDs.petenergy = 100
        petGUIDs.addedTime = currentTime
    elseif PetID == 98035 then  -- Dreadstalkers
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.duration = 12250
        petGUIDs.addedTime = currentTime
    elseif PetID == 17252 and PetGUID ~= permanentFelguard then  -- Felguard
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.duration = 17000
        petGUIDs.addedTime = currentTime
    elseif PetID == 135816 then  -- Vilefiend
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.duration = 15000
        petGUIDs.addedTime = currentTime
    elseif PetID == 226269 then  -- Charhound
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.duration = 15000
        petGUIDs.addedTime = currentTime
    elseif PetID == 226268 then  -- Gloomhound
        local petGUIDs = PetData.GUIDs[PetGUID]
        petGUIDs.duration = 15000
        petGUIDs.addedTime = currentTime
    end
end)

local function OnCombatLogEvent(...)
    local _, Event, _, SourceGUID, _, _, _, _, _, _, _, SpellID = CombatLogGetCurrentEventInfo()
    local currentTime = GetTime()
    local tyrantCasted = false

    for PetID, PetData in pairs(demonologyPetTracker.PetIDs) do
        for GUID, petGUIDData in pairs(PetData.GUIDs) do
            if petGUIDData.addedTime then
                local petLifetime = currentTime - petGUIDData.addedTime
                local maxDuration = petGUIDData.duration or 20000

                if Event == "SPELL_CAST_SUCCESS" and SpellID == SummonDemonicTyrant.id and not tyrantCasted then
                    for pID, pData in pairs(demonologyPetTracker.PetIDs) do
                        for gGUID, gData in pairs(pData.GUIDs) do
                            if gData.duration then 
                                gData.duration = gData.duration + 15000
                            end
                        end
                    end
                    if gs.pets[17252].remains > 0 then
                        gs.pets[17252].remains = gs.pets[17252].remains + 15000
                    end
                    tyrantCasted = true
                elseif Event == "SPELL_CAST_SUCCESS" and SpellID == Implosion.id and (PetID == 55659 or PetID == 143622) then
                    PetData.GUIDs[GUID] = nil
                elseif petLifetime > maxDuration then
                    PetData.GUIDs[GUID] = nil
                elseif PetID == 55659 or PetID == 143622 then  -- Wild Imp specific handling
                    if Event == "SPELL_CAST_SUCCESS" and SpellID == 104318 and GUID == SourceGUID then
                        petGUIDData.impcasts = petGUIDData.impcasts - 1
                        petGUIDData.petenergy = petGUIDData.petenergy / 6
                    end
                end
            end
        end
    end
end
Listener:Add("DEMONOLOGY_IMP_TRACKER", "COMBAT_LOG_EVENT_UNFILTERED", OnCombatLogEvent)

local function impsExpiringSoon()
    local impCount = 0
    for PetID, PetData in pairs(demonologyPetTracker.PetIDs) do
        if PetID == 55659 or PetID == 143622 then
            for _, Data in pairs(PetData.GUIDs) do
                if Data.impcasts <= 2 then
                    impCount = impCount + 1
                end
            end
        end
    end
    return impCount
end

local function impDespawn()
    if pet:Buff(buffs.demonicPower) then return 0 end


    -- actions.variables+=/variable,name=imp_despawn,op=set,value=2*spell_haste*6+0.58+time,if=prev_gcd.1.hand_of_guldan&buff.dreadstalkers.up&cooldown.summon_demonic_tyrant.remains<13&variable.imp_despawn=0
    -- # Checks the Wild Imps in a Tyrant Setup alongside Dreadstalkers for the sake of casting Tyrant before Expiration Dreadstalkers or Imps
    -- actions.variables+=/variable,name=imp_despawn,op=set,value=(variable.imp_despawn>?buff.dreadstalkers.remains+time),if=variable.imp_despawn
    -- # Checks The Wild Imps in a Tyrant Setup alongside Grimoire Felguard for the sake of casting Tyrant before Expiration of Grimoire Felguard or Imps
    -- actions.variables+=/variable,name=imp_despawn,op=set,value=variable.imp_despawn>?buff.grimoire_felguard.remains+time,if=variable.imp_despawn&buff.grimoire_felguard.up

    local val = 0

    local spellHastePercentage = GetCombatRatingBonus(20)
    local spellHasteMultiplier = 1 / (1 + spellHastePercentage / 100)
    local spellHaste = math.floor(spellHasteMultiplier * 100) / 100

    if gs.prevHandOfGuldan and gs.dreadstalkersActive and SummonDemonicTyrant.cd < 13000 then
        val = 2 * spellHaste * 6 + 0.58 * 1000 + GetTime()
    end

    if val > 0 then
        val = math.max(val, gs.dreadstalkersRemains + GetTime())
    end

    if val > 0 and gs.felguardActive then
        val = math.max(val, gs.felguardRemains + GetTime())
    end

    return val
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

local function firstTyrantTime()
    -- actions.precombat+=/variable,name=first_tyrant_time,op=set,value=15
    -- actions.precombat+=/variable,name=first_tyrant_time,op=add,value=action.grimoire_felguard.execute_time,if=talent.grimoire_felguard.enabled
    -- actions.precombat+=/variable,name=first_tyrant_time,op=add,value=action.summon_vilefiend.execute_time,if=talent.summon_vilefiend.enabled
    -- actions.precombat+=/variable,name=first_tyrant_time,op=add,value=gcd.max,if=talent.grimoire_felguard.enabled|talent.summon_vilefiend.enabled
    -- actions.precombat+=/variable,name=first_tyrant_time,op=sub,value=action.summon_demonic_tyrant.execute_time+action.shadow_bolt.execute_time
    -- actions.precombat+=/variable,name=first_tyrant_time,op=min,value=10

    local addFelguard = player:TalentKnown(GrimoireFelguard.id) and GrimoireFelguard:CastTime() + MakGCD() or 0
    local houndLearned = player:TalentKnown(MarkOfShatug.id) or player:TalentKnown(MarkOfFharg.id)
    local addVilefiend = player:TalentKnown(SummonVilefiend.id) and not houndLearned and SummonVilefiend:CastTime() + MakGCD() or 0
    local addGloomhound = player:TalentKnown(MarkOfShatug.id) and SummonGloomhound:CastTime() + MakGCD() or 0
    local addCharhound = player:TalentKnown(MarkOfFharg.id) and SummonCharhound:CastTime() + MakGCD() or 0
    local subTyrant = SummonDemonicTyrant:CastTime() + ShadowBolt:CastTime()

    local firstTyrantTime = 15000 + addFelguard + addVilefiend + addGloomhound + addCharhound - subTyrant

    return math.max(firstTyrantTime, 10000)
end

local function fightRemains()
    local cacheKey = "areaTTD"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local highest = 0 
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.isDummy then 
                highest = 99999
            else
                if enemy.ttd > 0 and enemy.ttd > highest then
                    highest = enemy.ttd
                end
            end
        end
        
        return highest
    end)
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId

    return currentCast
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

    if target:DebuffRemains(debuffs.doom, true) < 1000 then return false end

    if A.GetToggle(2, "autoDOT") then
        if player:TalentKnown(Doom.id) then
            if player:Buff(buffs.demonicCore) then
                if gs.activeEnemies > math.min(gs.doomCount, 4) then
                    return true
                end
            end
        end
    end
end

local lastUpdateTime = 0
local updateDelay = 0.4
local function updategs()
    -- Reset pet states
    for k, v in pairs(gs.pets) do
        v.active = false
        v.remains = 0
    end

    --Remaining duration for pets
    local currentTime = GetTime()
    for PetID, PetData in pairs(demonologyPetTracker.PetIDs) do
        for GUID, petGUIDData in pairs(PetData.GUIDs) do
            if petGUIDData.addedTime and petGUIDData.duration then
                local timeElapsed = currentTime - petGUIDData.addedTime 
                petGUIDData.remains = petGUIDData.duration - timeElapsed 
                if petGUIDData.remains < 0 then
                    petGUIDData.remains = 0 
                end
            end
        end
    end

    -- Update gs
    for PetID, PetData in pairs(demonologyPetTracker.PetIDs) do
        for GUID, petGUIDData in pairs(PetData.GUIDs) do
            if gs.pets[PetID] then
                gs.pets[PetID].active = true
                gs.pets[PetID].remains = petGUIDData.remains 
            end
        end
    end

    --Unfortunately I have to do this stupid janky override for Felguard timer for now.
    local timeSinceLastGrimoireFelguard = GrimoireFelguard.used
    local felguardMaxDuration = 17000
    
    if timeSinceLastGrimoireFelguard < felguardMaxDuration then
        gs.pets[17252].active = true
        gs.pets[17252].remains = (felguardMaxDuration - timeSinceLastGrimoireFelguard)
        if Player:PrevGCD(1, A.SummonDemonicTyrant) and gs.pets[17252].active then
            gs.pets[17252].remains = gs.pets[17252].remains + 15000
        end
    end

    -- petExpire var
    local vilefiendUp = gs.pets[135816]
    local gloomhoundUp = gs.pets[226268]
    local charhoundUp = gs.pets[226269]
    local petVilefiendRemains = math.max(vilefiendUp.remains, gloomhoundUp.remains, charhoundUp.remains)
    local petVilefiendActive = petVilefiendRemains > 0
    local petDreadstalkers = gs.pets[98035]
    local petFelguard = gs.pets[17252]
    if petVilefiendActive and petDreadstalkers.active then 
        gs.petExpire = math.min(petVilefiendRemains, petDreadstalkers.remains) - Action.GetGCD() * 0.5
    elseif not player:TalentKnown(SummonVilefiend.id) and player:TalentKnown(GrimoireFelguard.id) and petDreadstalkers.active then
        gs.petExpire = math.min(petDreadstalkers.remains, petFelguard.remains) - Action.GetGCD() * 0.5
    elseif not player:TalentKnown(SummonVilefiend.id) and (not player:TalentKnown(GrimoireFelguard.id) or not T30has2P) and petDreadstalkers.active then
        gs.petExpire = petDreadstalkers.remains - Action.GetGCD() * 0.5
    else
        gs.petExpire = 0
    end

    --Soul Shards
    local currentCast = myCast()
    local currentTime = GetTime() 
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.soulShards = predSoulShards()
        lastUpdateTime = currentTime
    end

    gs.activeEnemies = activeEnemies()
    gs.fightRemains = fightRemains()
    gs.doomCount = enemiesInRange(debuffs.doom, 1000)

    local cursorCondition = (ShadowBolt:InRange(mouseover) or Soulstone:InRange(mouseover)) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    --[[gs.dreadstalkersRemains = gs.pets[98035].remains
    gs.felguardRemains = gs.pets[17252].remains

    gs.dreadstalkersActive = gs.pets[98035].active or (gs.imCasting and gs.imCasting == CallDreadstalkers.id)
    gs.vilefiendActive = gs.pets[135816].active or gs.pets[226268].active or gs.pets[226269].active or (gs.imCasting and (gs.imCasting == SummonVilefiend.id or gs.imCasting == SummonCharhound.id or gs.imCasting == SummonGloomhound.id))
    gs.felguardActive = gs.pets[17252].active or (gs.imCasting and gs.imCasting == GrimoireFelguard.id)]]

    -- Dreadstalkers
    gs.dreadstalkersRemains = math.max(12000 - CallDreadstalkers.used, 0)
    gs.dreadstalkersActive = gs.dreadstalkersRemains > 0

    -- Felguard (Grimoire)
    gs.felguardRemains = math.max(17000 - GrimoireFelguard.used, 0)
    gs.felguardActive = gs.felguardRemains > 0

    -- Vilefiend / Gloomhound / Charhound
    gs.vilefiendUsed = player:TalentKnown(MarkOfShatug.id) and SummonGloomhound.used or player:TalentKnown(MarkOfFharg.id) and SummonCharhound.used or SummonVilefiend.used
    gs.vilefiendRemains = math.max(15000 - gs.vilefiendUsed, 0)
    gs.vilefiendActive = gs.vilefiendRemains > 0

    gs.prevDreadstalkers = not gs.imCasting and Player:PrevGCD(1, A.CallDreadstalkers) or gs.imCasting and gs.imCasting == CallDreadstalkers.id
    gs.prevDreadstalkers2 = not gs.imCasting and Player:PrevGCD(2, A.CallDreadstalkers) or Player:PrevGCD(1, A.CallDreadstalkers) and gs.imCasting and gs.imCasting == CallDreadstalkers.id
    gs.prevShadowBolt = not gs.imCasting and Player:PrevGCD(1, A.ShadowBolt) or gs.imCasting and gs.imCasting == ShadowBolt.id
    gs.prevCharhound = not gs.imCasting and Player:PrevGCD(1, A.SummonCharhound) or gs.imCasting and gs.imCasting == SummonCharhound.id
    gs.prevGloomhound = not gs.imCasting and Player:PrevGCD(1, A.SummonGloomhound) or gs.imCasting and gs.imCasting == SummonGloomhound.id
    gs.prevVilefiend = not gs.imCasting and Player:PrevGCD(1, A.SummonVilefiend) or gs.imCasting and gs.imCasting == SummonVilefiend.id or gs.prevCharhound or gs.prevGloomhound
    gs.prevGrimoireFelguard = not gs.imCasting and Player:PrevGCD(1, A.GrimoireFelguard) or gs.imCasting and gs.imCasting == GrimoireFelguard.id
    gs.prevGrimoireFelguard2 = not gs.imCasting and Player:PrevGCD(2, A.GrimoireFelguard) or Player:PrevGCD(1, A.GrimoireFelguard) and gs.imCasting and gs.imCasting == GrimoireFelguard.id
    gs.prevGrimoireFelguard3 = not gs.imCasting and Player:PrevGCD(3, A.GrimoireFelguard) or Player:PrevGCD(2, A.GrimoireFelguard) and gs.imCasting and gs.imCasting == GrimoireFelguard.id
    gs.prevDemonbolt = not gs.imCasting and Player:PrevGCD(1, A.Demonbolt) or gs.imCasting and gs.imCasting == Demonbolt.id
    gs.prevHandOfGuldan = not gs.imCasting and Player:PrevGCD(1, A.HandOfGuldan) or gs.imCasting and gs.imCasting == HandOfGuldan.id

    gs.vilefiendCd = player:TalentKnown(MarkOfShatug.id) and SummonGloomhound.cd or player:TalentKnown(MarkOfFharg.id) and SummonCharhound.cd or player:TalentKnown(SummonVilefiend.id) and SummonVilefiend.cd or 0

    local spendingShards = gs.imCasting and (gs.imCasting == CallDreadstalkers.id or gs.imCasting == HandOfGuldan.id)
    gs.ruination = player:Buff(buffs.pitLord) and player:BuffRemains(buffs.pitLord) - (num(spendingShards) * gs.soulShards * 1000) <= 0 or player:Buff(buffs.ruination)
    gs.infernalBolt = player:Buff(buffs.motherOfChaos) and player:BuffRemains(buffs.motherOfChaos) - (num(spendingShards) * gs.soulShards * 1000) <= 0 or player:Buff(buffs.infernalBolt)

    gs.impDespawn = impDespawn()
    gs.impsExpiringSoon = impsExpiringSoon()

    gs.firstTyrantTime = firstTyrantTime()

    -- actions.precombat+=/variable,name=in_opener,op=set,value=1
    -- actions.variables+=/variable,name=in_opener,op=set,value=0,if=pet.demonic_tyrant.active
    gs.inOpener = not pet:Buff(buffs.demonicPower)

    -- actions.variables=variable,name=next_tyrant_cd,op=set,value=cooldown.summon_demonic_tyrant.remains_expected
    gs.nextTyrantCd = SummonDemonicTyrant.cd

    -- actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.down,if=active_enemies>1+(talent.sacrificed_souls.enabled)
    -- actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.remains<6,if=active_enemies>2+(talent.sacrificed_souls.enabled)&active_enemies<5+(talent.sacrificed_souls.enabled)
    -- actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.remains<8,if=active_enemies>4+(talent.sacrificed_souls.enabled)
    gs.impl = false
    if pet:Buff(buffs.demonicPower) then
        if pet:BuffRemains(buffs.demonicPower) < 8000 and gs.activeEnemies > 4 + player:TalentKnownInt(SacrificedSouls.id) then
            gs.impl = true
        elseif pet:BuffRemains(buffs.demonicPower) < 6000 and gs.activeEnemies > 2 + player:TalentKnownInt(SacrificedSouls.id) and gs.activeEnemies < 5 + player:TalentKnownInt(SacrificedSouls.id) then
            gs.impl = true
        end
    else
        if gs.activeEnemies > 1 + player:TalentKnownInt(SacrificedSouls.id) then
            gs.impl = true
        end
    end

    -- actions.variables+=/variable,name=pool_cores_for_tyrant,op=set,value=cooldown.summon_demonic_tyrant.remains<20&variable.next_tyrant_cd<20&(buff.demonic_core.stack<=2|!buff.demonic_core.up)&cooldown.summon_vilefiend.remains<gcd.max*8&cooldown.call_dreadstalkers.remains<gcd.max*8
    gs.poolCoresForTyrant = shouldBurst() and SummonDemonicTyrant.cd < 20000 and gs.nextTyrantCd < 20000 and (player:HasBuffCount(buffs.demonicCore) <= 2 or not player:HasBuff(buffs.demonicCore)) and gs.vilefiendCd < A.GetGCD() * 8000 and CallDreadstalkers.cd < A.GetGCD() * 8000

    -- actions.variables+=/variable,name=diabolic_ritual_remains,value=buff.diabolic_ritual_mother_of_chaos.remains,if=buff.diabolic_ritual_mother_of_chaos.up
    -- actions.variables+=/variable,name=diabolic_ritual_remains,value=buff.diabolic_ritual_overlord.remains,if=buff.diabolic_ritual_overlord.up
    -- actions.variables+=/variable,name=diabolic_ritual_remains,value=buff.diabolic_ritual_pit_lord.remains,if=buff.diabolic_ritual_pit_lord.up
    gs.diabolicRitualRemains = player:Buff(buffs.ritualMother) and player:BuffRemains(buffs.ritualMother) or player:Buff(buffs.ritualOverlord) and player:BuffRemains(buffs.ritualOverlord) or player:Buff(buffs.ritualPitLord) and player:BuffRemains(buffs.ritualPitLord) or 0

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

UnendingResolve:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp <  A.GetToggle(2, "UnendingResolveHP") then
        return spell:Cast()
    end
end)

DarkPact:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end
    if not player.inCombat then return end 
    
    
    if shouldDefensive() or player.hp <  A.GetToggle(2, "DarkPactHP") then
        return spell:Cast()
    end
end)

MortalCoil:Callback(function(spell)
    if player.hp > A.GetToggle(2, "MortalCoilHP") then return end
    
    return spell:Cast()
end)

DrainLife:Callback(function(spell)
    if player.hp > A.GetToggle(2, "DrainLifeHP") then return end
    
    if A.Soulburn:IsTalentLearned() and gs.soulShards >= 1 and Soulburn.cd < 300 then
        return Soulburn:Cast(player)
    end
    
    return spell:Cast()
end)

FelDomination:Callback(function(spell)
    local noPet = not pet.exists or pet.hp == 0

    if not noPet then return end
    if not player.inCombat then return end

    return spell:Cast()
end)

SummonFelguard:Callback(function(spell)
    local noPet = not pet.exists or pet.hp == 0
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not noPet then return end
    
    return spell:Cast()
end)

HealthFunnel:Callback(function(spell)
    local healthFunnelHP = Action.GetToggle(2, "HealthFunnelHP")
    local noPet = pet.exists or pet.hp == 0

    if noPet then return end
    if pet.hp > healthFunnelHP then return end

    return spell:Cast()
end)

CreateSoulwell:Callback(function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.arenaPreparation) then return end

    return spell:Cast()
end)

PowerSiphon:Callback("pre", function(spell)
    local impsActive = A.Implosion:GetCount()
    if player:Buff(buffs.arenaPreparation) then return end
    if impsActive < 2 then return end
    if player:Buff(buffs.demonicCore) then return end

    return spell:Cast()
end)

Demonbolt:Callback("pre", function(spell)
    if gs.imCasting then return end
    if player:Buff(buffs.demonicCore) then return end

    return spell:Cast(target)
end)

ShadowBolt:Callback("pre", function(spell)
    if gs.imCasting then return end
    -- Movement check is now handled by the framework via ignoreMoving flag

    return spell:Cast(target)
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

local function racials()
    Berserking()
    BloodFury()
    Fireblood()
    AncestralCall()
end

-- actions.fight_end=grimoire_felguard,if=fight_remains<20
GrimoireFelguard:Callback("end", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if gs.fightRemains > 20000 then return end

    return spell:Cast(target)
end)

-- actions.fight_end+=/Ruination
HandOfGuldan:Callback("end", function(spell)
    if spell.cost > gs.soulShards then return end

    if not gs.ruination then return end

    return spell:Cast(target)
end)

-- actions.fight_end+=/implosion,if=fight_remains<2*gcd.max&!prev_gcd.1.implosion
Implosion:Callback("end", function(spell)
    if gs.fightRemains > 2000 * A.GetGCD() then return end
    if Player:PrevGCD(1, A.Implosion) then return end

    return spell:Cast(target)
end)

-- actions.fight_end+=/demonbolt,if=fight_remains<gcd.max*2*buff.demonic_core.stack+9&buff.demonic_core.react&(soul_shard<4|fight_remains<buff.demonic_core.stack*gcd.max)
Demonbolt:Callback("end", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.fightRemains > 2000 * A.GetGCD() * player:HasBuffCount(buffs.demonicCore) + 9000 then return end

    if gs.soulShards < 4 or gs.fightRemains < player:HasBuffCount(buffs.demonicCore) * A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.fight_end+=/call_dreadstalkers,if=fight_remains<20
CallDreadstalkers:Callback("end", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end

    if gs.fightRemains > 20000 then return end
    return spell:Cast(target)
end)

-- actions.fight_end+=/summon_vilefiend,if=fight_remains<20
SummonVilefiend:Callback("end", function(spell)
    if gs.prevVilefiend then return end
    if spell.cost > gs.soulShards then return end
    if gs.vilefiendCd > 500 then return end

    if gs.fightRemains > 20000 then return end
    return spell:Cast()
end)

-- actions.fight_end+=/summon_demonic_tyrant,if=fight_remains<20
SummonDemonicTyrant:Callback("end", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if gs.fightRemains > 20000 then return end
    return spell:Cast(target)
end)

-- actions.fight_end+=/demonic_strength,if=fight_remains<10
DemonicStrength:Callback("end", function(spell)
    if gs.fightRemains > 10000 then return end
    return spell:Cast(target)
end)

-- actions.fight_end+=/power_siphon,if=buff.demonic_core.stack<3&fight_remains<20
PowerSiphon:Callback("end", function(spell)
    if player:Buff(buffs.arenaPreparation) then return end
    if player:HasBuffCount(buffs.demonicCore) >= 3 then return end
    if gs.fightRemains > 20000 then return end
    return spell:Cast()
end)

-- actions.fight_end+=/hand_of_guldan,if=soul_shard>2&fight_remains<gcd.max*2*buff.demonic_core.stack+9
HandOfGuldan:Callback("end", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.soulShards <= 2 then return end
    if gs.fightRemains > 1000 * A.GetGCD() * player:HasBuffCount(buffs.demonicCore) + 9000 then return end

    return spell:Cast(target)
end)

-- actions.fight_end+=/infernal_bolt
ShadowBolt:Callback("end", function(spell)
    if not gs.infernalBolt then return end
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

    return spell:Cast(target)
end)

local function endOfFight()
    GrimoireFelguard("end")
    HandOfGuldan("end")
    Implosion("end")
    Demonbolt("end")
    CallDreadstalkers("end")
    SummonVilefiend("end")
    SummonDemonicTyrant("end")
    DemonicStrength("end")
    PowerSiphon("end")
    HandOfGuldan("end")
    ShadowBolt("end")
end

-- actions.opener=summon_demonic_tyrant,if=buff.wild_imps.stack>=9&buff.dreadstalkers.remains&(buff.vilefiend.up|!talent.summon_vilefiend)&(buff.grimoire_felguard.up|cooldown.grimoire_felguard.remains>30|!talent.grimoire_felguard)
SummonDemonicTyrant:Callback("opener", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if A.Implosion:GetCount() >= 9 and gs.dreadstalkersActive and (gs.vilefiendActive or not player:TalentKnown(SummonVilefiend.id)) and (gs.felguardActive or GrimoireFelguard.cd > 30000 or not player:TalentKnown(GrimoireFelguard.id)) then
        return spell:Cast()
    end
end)

-- actions.opener+=/grimoire_felguard,if=soul_shard>=5-talent.fel_invocation
GrimoireFelguard:Callback("opener", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if gs.soulShards >= 5 - player:TalentKnownInt(FelInvocation.id) then
        return spell:Cast(target)
    end
end)

-- actions.opener+=/summon_vilefiend,if=soul_shard=5
SummonVilefiend:Callback("opener", function(spell)
    if gs.prevVilefiend then return end
    if spell.cost > gs.soulShards then return end
    if gs.vilefiendCd > 500 then return end

    if gs.soulShards >= 5 then
        return spell:Cast()
    end
end)

-- actions.opener+=/shadow_bolt,if=soul_shard<5&cooldown.call_dreadstalkers.up
ShadowBolt:Callback("opener", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.soulShards >= 5 then return end
    if CallDreadstalkers.cd > 500 then return end

    return spell:Cast(target)
end)

-- actions.opener+=/call_dreadstalkers,if=soul_shard=5
CallDreadstalkers:Callback("opener", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end

    if gs.soulShards >= 5 then
        return spell:Cast(target)
    end
end)

-- actions.opener+=/Ruination
HandOfGuldan:Callback("opener", function(spell)
    if spell.cost > gs.soulShards then return end

    if not gs.ruination then return end

    return spell:Cast(target)
end)

-- actions.opener+=/hand_of_guldan,if=soul_shard>=3&buff.infernal_bolt.up
HandOfGuldan:Callback("opener2", function(spell)
    if spell.cost > gs.soulShards then return end
    if gs.soulShards < 3 then return end

    if player:Buff(buffs.infernalBolt) then
        return spell:Cast(target)
    end
end)

-- actions.opener+=/infernal_bolt
ShadowBolt:Callback("opener2", function(spell)
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

    if not gs.infernalBolt then return end

    return spell:Cast(target)
end)

-- actions.opener+=/shadow_bolt,if=soul_shard<5&buff.dreadstalkers.remains&pet.wild_imp.active<3
ShadowBolt:Callback("opener3", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.soulShards >= 5 then return end
    if not gs.dreadstalkersActive then return end
    if A.Implosion:GetCount() >= 3 then return end

    return spell:Cast(target)
end)

-- actions.opener+=/hand_of_guldan,if=soul_shard>=3&pet.wild_imp.active<10
HandOfGuldan:Callback("opener3", function(spell)
    if spell.cost > gs.soulShards then return end
    if gs.soulShards < 3 then return end

    if A.Implosion:GetCount() < 10 then
        return spell:Cast(target)
    end
end)

-- actions.opener+=/demonbolt,if=buff.demonic_core.react&buff.dreadstalkers.remains&soul_shard<4
Demonbolt:Callback("opener", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if not gs.dreadstalkersActive then return end
    if gs.soulShards >= 4 then return end

    return spell:Cast(target)
end)

-- actions.opener+=/hand_of_guldan,if=variable.first_tyrant_time?buff.dreadstalkers.remains+time
HandOfGuldan:Callback("opener4", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.firstTyrantTime > gs.dreadstalkersRemains + (player.combatTime * 1000) then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/power_siphon,if=cooldown.summon_demonic_tyrant.remains<15
PowerSiphon:Callback("tyrant", function(spell)
    if SummonDemonicTyrant.cd > 15000 then return end
    if player:Buff(buffs.arenaPreparation) then return end

    return spell:Cast()
end)

-- actions.tyrant+=/ruination,if=buff.dreadstalkers.remains>gcd.max+action.summon_demonic_tyrant.cast_time&(soul_shard=5|variable.imp_despawn)
HandOfGuldan:Callback("tyrant", function(spell)
    if spell.cost > gs.soulShards then return end

    if not gs.ruination then return end
    if gs.dreadstalkersRemains < A.GetGCD() * 1000 + SummonDemonicTyrant:CastTime() then return end

    if gs.soulShards == 5 or gs.impDespawn > 0 then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/infernal_bolt,if=!buff.demonic_core.react&variable.imp_despawn>time+gcd.max*2+action.summon_demonic_tyrant.cast_time&soul_shard<3
-- actions.tyrant+=/shadow_bolt,if=prev_gcd.1.call_dreadstalkers&soul_shard<4&buff.demonic_core.react<4
-- actions.tyrant+=/shadow_bolt,if=prev_gcd.2.call_dreadstalkers&prev_gcd.1.shadow_bolt&buff.bloodlust.up&soul_shard<5
-- actions.tyrant+=/shadow_bolt,if=prev_gcd.1.summon_vilefiend&(buff.demonic_calling.down|prev_gcd.2.grimoire_felguard)
-- actions.tyrant+=/shadow_bolt,if=prev_gcd.1.grimoire_felguard&buff.demonic_core.react<3&buff.demonic_calling.remains>gcd.max*3
ShadowBolt:Callback("tyrant", function(spell)

    if gs.infernalBolt then 
        if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

        if player:Buff(buffs.demonicCore) then return end
        if gs.impDespawn < A.GetGCD() * 2000 + SummonDemonicTyrant:CastTime() then return end
        if gs.soulShards >= 3 then return end

        return spell:Cast(target)
    else
        if gs.imCasting and gs.imCasting == spell.id then return end

        if gs.prevDreadstalkers and gs.soulShards < 4 and player:HasBuffCount(buffs.demonicCore) < 4 then
            return spell:Cast(target)
        end

        if gs.prevDreadstalkers2 and gs.prevShadowBolt and player.bloodlust and gs.soulShards < 5 then
            return spell:Cast(target)
        end

        if gs.prevVilefiend and (not player:Buff(buffs.demonicCalling) or gs.prevGrimoireFelguard2) then
            return spell:Cast(target)
        end

        if gs.prevGrimoireFelguard and player:HasBuffCount(buffs.demonicCore) < 3 and player:BuffRemains(buffs.demonicCalling) > A.GetGCD() * 3000 then
            return spell:Cast(target)
        end
    end
end)

-- actions.tyrant+=/hand_of_guldan,if=variable.imp_despawn>time+gcd.max*2+action.summon_demonic_tyrant.cast_time&!buff.demonic_core.react&buff.demonic_art_pit_lord.up&variable.imp_despawn<time+gcd.max*5+action.summon_demonic_tyrant.cast_time
HandOfGuldan:Callback("tyrant2", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.impDespawn < A.GetGCD() * 2000 + SummonDemonicTyrant:CastTime() then return end
    if player:Buff(buffs.demonicCore) then return end
    if not player:Buff(buffs.pitLord) then return end
    if gs.impDespawn > A.GetGCD() * 5000 + SummonDemonicTyrant:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.tyrant+=/hand_of_guldan,if=variable.imp_despawn>time+gcd.max+action.summon_demonic_tyrant.cast_time&variable.imp_despawn<time+gcd.max*2+action.summon_demonic_tyrant.cast_time&buff.dreadstalkers.remains>gcd.max+action.summon_demonic_tyrant.cast_time&soul_shard>1
HandOfGuldan:Callback("tyrant3", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.impDespawn < A.GetGCD() * 1000 + SummonDemonicTyrant:CastTime() then return end
    if gs.impDespawn > A.GetGCD() * 2000 + SummonDemonicTyrant:CastTime() then return end
    if gs.dreadstalkersRemains < A.GetGCD() * 1000 + SummonDemonicTyrant:CastTime() then return end
    if gs.soulShards <= 1 then return end

    return spell:Cast(target)
end)

-- actions.tyrant+=/shadow_bolt,if=!buff.demonic_core.react&variable.imp_despawn>time+gcd.max*2+action.summon_demonic_tyrant.cast_time&variable.imp_despawn<time+gcd.max*4+action.summon_demonic_tyrant.cast_time&soul_shard<3&buff.dreadstalkers.remains>gcd.max*2+action.summon_demonic_tyrant.cast_time
ShadowBolt:Callback("tyrant2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:Buff(buffs.demonicCore) then return end
    if gs.impDespawn < A.GetGCD() * 2000 + SummonDemonicTyrant:CastTime() then return end
    if gs.impDespawn > A.GetGCD() * 4000 + SummonDemonicTyrant:CastTime() then return end
    if gs.soulShards >= 3 then return end
    if gs.dreadstalkersRemains < A.GetGCD() * 2000 + SummonDemonicTyrant:CastTime() then return end

    return spell:Cast(target)
end)

-- actions.tyrant+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13+gcd.max&cooldown.summon_vilefiend.remains<gcd.max&cooldown.call_dreadstalkers.remains<gcd.max*3.33&(soul_shard=5-(pet.felguard.cooldown.soul_strike.remains<gcd.max)&talent.fel_invocation|soul_shard=5)
GrimoireFelguard:Callback("tyrant", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if SummonDemonicTyrant.cd > 13000 + (A.GetGCD() * 1000) then return end
    if gs.vilefiendCd > A.GetGCD() * 1000 then return end
    if CallDreadstalkers.cd > A.GetGCD() * 3330 then return end

    if gs.soulShards == 5 - num(SoulStrike.cd < A.GetGCD() * 1000 and player:TalentKnown(FelInvocation.id)) then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/summon_vilefiend,if=(buff.grimoire_felguard.up|cooldown.grimoire_felguard.remains>10|!talent.grimoire_felguard)&cooldown.summon_demonic_tyrant.remains<13&cooldown.call_dreadstalkers.remains<gcd.max*2.33&(soul_shard=5|soul_shard=4&(buff.demonic_core.react=4)|buff.grimoire_felguard.up)
SummonVilefiend:Callback("tyrant", function(spell)
    if gs.prevVilefiend then return end
    if spell.cost > gs.soulShards then return end
    if gs.vilefiendCd > 500 then return end

    if (gs.felguardActive or GrimoireFelguard.cd > 10000 or not player:TalentKnown(GrimoireFelguard.id)) and SummonDemonicTyrant.cd < 13000 and CallDreadstalkers.cd < A.GetGCD() * 2330 and (gs.soulShards == 5 or gs.soulShards == 4 and player:HasBuffCount(buffs.demonicCore) >= 4 or gs.felguardActive) then
        return spell:Cast()
    end
end)

-- actions.tyrant+=/call_dreadstalkers,if=(!talent.summon_vilefiend|buff.vilefiend.up)&cooldown.summon_demonic_tyrant.remains<10&soul_shard>=(5-(buff.demonic_core.react>=3))|prev_gcd.3.grimoire_felguard
CallDreadstalkers:Callback("tyrant", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end

    if gs.prevGrimoireFelguard3 then
        return spell:Cast(target)
    end
    
    if player:TalentKnown(SummonVilefiend.id) and not gs.vilefiendActive then return end
    if SummonDemonicTyrant.cd > 10000 then return end

    if gs.soulShards >= 5 - num(player:HasBuffCount(buffs.demonicCore) >= 3) then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/summon_demonic_tyrant,if=variable.imp_despawn&variable.imp_despawn<time+gcd.max*2+cast_time|buff.dreadstalkers.up&buff.dreadstalkers.remains<gcd.max*2+cast_time
SummonDemonicTyrant:Callback("tyrant", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if gs.impDespawn > 0 and gs.impDespawn < A.GetGCD() * 2000 + spell:CastTime() then 
        return spell:Cast()
    end

    if gs.dreadstalkersActive and gs.dreadstalkersRemains < A.GetGCD() * 2000 + spell:CastTime() then
        return spell:Cast()
    end
end)

-- actions.tyrant+=/hand_of_guldan,if=(variable.imp_despawn|buff.dreadstalkers.remains)&soul_shard>=3|soul_shard=5
HandOfGuldan:Callback("tyrant4", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.soulShards >= 5 - (2 * num(gs.impDespawn > 0 or gs.dreadstalkersActive)) then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/infernal_bolt,if=variable.imp_despawn&soul_shard<3
ShadowBolt:Callback("tyrant3", function(spell)
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

    if not gs.infernalBolt then return end
    if gs.soulShards >= 3 then return end

    return spell:Cast(target)
end)

-- actions.tyrant+=/demonbolt,target_if=min:debuff.doom.remains,if=variable.imp_despawn&buff.demonic_core.react&soul_shard<4|prev_gcd.1.call_dreadstalkers&soul_shard<4&buff.demonic_core.react=4|buff.demonic_core.react=4&soul_shard<4|buff.demonic_core.react>=2&cooldown.power_siphon.remains<5
Demonbolt:Callback("tyrant", function(spell)
    if not player:Buff(buffs.demonicCore) then return end

    if gs.impDespawn > 0 and player:Buff(buffs.demonicCore) and gs.soulShards < 4 then
        return spell:Cast(target)
    end

    if gs.prevDreadstalkers and gs.soulShards < 4 and player:HasBuffCount(buffs.demonicCore) >= 4 then
        return spell:Cast(target)
    end

    if player:HasBuffCount(buffs.demonicCore) >= 2 and PowerSiphon.cd < 5000 then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/ruination,if=variable.imp_despawn|soul_shard=5&cooldown.summon_vilefiend.remains>gcd.max*3
HandOfGuldan:Callback("tyrant5", function(spell)
    if spell.cost > gs.soulShards then return end

    if gs.impDespawn > 0 then
        return spell:Cast(target)
    end

    if gs.soulShards >= 5 and gs.vilefiendCd > A.GetGCD() * 3000 then
        return spell:Cast(target)
    end
end)

-- actions.tyrant+=/shadow_bolt
-- actions.tyrant+=/infernal_bolt
ShadowBolt:Callback("tyrant4", function(spell)
    
    return spell:Cast(target)
end)

local function tyrant()
    PowerSiphon("tyrant")
    HandOfGuldan("tyrant")
    ShadowBolt("tyrant")
    HandOfGuldan("tyrant2")
    HandOfGuldan("tyrant3")
    ShadowBolt("tyrant2")
    GrimoireFelguard("tyrant")
    SummonVilefiend("tyrant")
    CallDreadstalkers("tyrant")
    SummonDemonicTyrant("tyrant")
    HandOfGuldan("tyrant4")
    ShadowBolt("tyrant3")
    Demonbolt("tyrant")
    HandOfGuldan("tyrant5")
    ShadowBolt("tyrant4")
end

local function opener()
    SummonDemonicTyrant("opener")
    GrimoireFelguard("opener")
    SummonVilefiend("opener")
    ShadowBolt("opener")
    CallDreadstalkers("opener")
    HandOfGuldan("opener")
    HandOfGuldan("opener2")
    ShadowBolt("opener2")
    ShadowBolt("opener3")
    HandOfGuldan("opener3")
    Demonbolt("opener")
    HandOfGuldan("opener4")
end

-- actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<=15&cooldown.call_dreadstalkers.remains<10
GrimoireFelguard:Callback("rotation", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if SummonDemonicTyrant.cd <= 15000 and CallDreadstalkers.cd < 10000 then
        return spell:Cast(target)
    end
end)

-- actions+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>=25+cast_time|cooldown.summon_demonic_tyrant.remains<=13&cooldown.call_dreadstalkers.remains<10
SummonVilefiend:Callback("rotation", function(spell)
    if gs.prevVilefiend then return end
    if spell.cost > gs.soulShards then return end
    if gs.vilefiendCd > 500 then return end

    if SummonDemonicTyrant.cd >= 25000 + spell:CastTime() or (SummonDemonicTyrant.cd <= 13000 and CallDreadstalkers.cd < 10000) then
        return spell:Cast()
    end
end)

-- actions+=/call_dreadstalkers,if=cooldown.summon_demonic_tyrant.remains>=10|cooldown.summon_demonic_tyrant.remains<=10
CallDreadstalkers:Callback("rotation", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end

    if SummonDemonicTyrant.cd >= 10000 or SummonDemonicTyrant.cd <= 10000 then
        return spell:Cast(target)
    end
end)

-- actions+=/demonbolt,target_if=min:debuff.doom.remains,if=buff.demonic_core.stack>=3-(talent.doom&debuff.doom.down)*2&soul_shard<=3&talent.doom
Demonbolt:Callback("rotation", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.soulShards > 3 then return end
    if not player:TalentKnown(Doom.id) then return end

    if player:HasBuffCount(buffs.demonicCore) >= 3 - (num(player:TalentKnown(Doom.id) and not target:Debuff(debuffs.doom, true)) * 2) then
        return spell:Cast(target)
    end
end)

-- actions+=/demonic_strength,if=pet.demonic_tyrant.active
DemonicStrength:Callback("rotation", function(spell)
    if not pet:Buff(buffs.demonicPower) then return end

    return spell:Cast()
end)

-- actions+=/bilescourge_bombers,if=active_enemies>1
BilescourgeBombers:Callback("rotation", function(spell)
    if not gs.cursorCheck then return end
    if gs.activeEnemies <= 1 then return end

    return spell:Cast()
end)

-- actions+=/hand_of_guldan,if=demonic_art&soul_shard>=3
HandOfGuldan:Callback("rotation", function(spell)
    if spell.cost > gs.soulShards then return end
    if gs.soulShards < 3 then return end

    if player:Buff(buffs.pitLord) or player:Buff(buffs.motherOfChaos) or player:Buff(buffs.overlord) then
        return spell:Cast(target)
    end
end)

-- actions+=/implosion,if=active_enemies>3&set_bonus.tww2_4pc&buff.wild_imps.stack>7&!buff.demonic_core.react&!prev_gcd.1.implosion|!set_bonus.tww2_4pc&active_enemies>2&two_cast_imps>2&!prev_gcd.1.implosion&variable.impl
Implosion:Callback("rotation", function(spell)
    if Player:PrevGCD(1, A.Implosion) then return end

    -- TWW2 4pc logic
    if gs.activeEnemies > 3 and A.Implosion:GetCount() > 7 and not player:Buff(buffs.demonicCore) then
        return spell:Cast(target)
    end

    -- Non-set bonus logic
    if gs.activeEnemies > 2 and gs.impsExpiringSoon > 2 and gs.impl then
        return spell:Cast(target)
    end
end)

-- actions+=/ruination
HandOfGuldan:Callback("rotation2", function(spell)
    if spell.cost > gs.soulShards then return end

    if not gs.ruination then return end

    return spell:Cast(target)
end)

-- actions+=/demonbolt,target_if=(!debuff.doom.up),if=soul_shard<4&buff.demonic_core.stack>=3&talent.doom
Demonbolt:Callback("rotation2", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.soulShards >= 4 then return end
    if player:HasBuffCount(buffs.demonicCore) < 3 then return end
    if not player:TalentKnown(Doom.id) then return end

    if not target:Debuff(debuffs.doom, true) then
        return spell:Cast(target)
    end
end)

-- actions+=/demonbolt,if=soul_shard<4&buff.demonic_core.stack>=3&!talent.doom
Demonbolt:Callback("rotation3", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.soulShards >= 4 then return end
    if player:HasBuffCount(buffs.demonicCore) < 3 then return end
    if player:TalentKnown(Doom.id) then return end

    return spell:Cast(target)
end)

-- actions+=/power_siphon,if=!buff.demonic_core.up
PowerSiphon:Callback("rotation", function(spell)
    if player:Buff(buffs.demonicCore) then return end

    return spell:Cast()
end)

-- actions+=/infernal_bolt,if=soul_shard<3
ShadowBolt:Callback("rotation", function(spell)
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

    if not gs.infernalBolt then return end
    if gs.soulShards >= 3 then return end

    return spell:Cast(target)
end)

-- actions+=/hand_of_guldan,if=soul_shard>=3
HandOfGuldan:Callback("rotation3", function(spell)
    if spell.cost > gs.soulShards then return end
    if gs.soulShards < 3 then return end

    return spell:Cast(target)
end)

-- actions+=/demonbolt,if=soul_shard<4&buff.demonic_core.react
Demonbolt:Callback("rotation4", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.soulShards >= 4 then return end

    return spell:Cast(target)
end)

-- actions+=/shadow_bolt
ShadowBolt:Callback("rotation2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast(target)
end)

-- actions+=/infernal_bolt
ShadowBolt:Callback("rotation3", function(spell)
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end

    if not gs.infernalBolt then return end

    return spell:Cast(target)
end)

local function rotation()
    if not A.IsInPvP then
        GrimoireFelguard("rotation")
        SummonVilefiend("rotation")
        CallDreadstalkers("rotation")
        Demonbolt("rotation")
        DemonicStrength("rotation")
        BilescourgeBombers("rotation")
        HandOfGuldan("rotation")
        Implosion("rotation")
        HandOfGuldan("rotation2")
        Demonbolt("rotation2")
        Demonbolt("rotation3")
        PowerSiphon("rotation")
        ShadowBolt("rotation")
        HandOfGuldan("rotation3")
        Demonbolt("rotation4")
        ShadowBolt("rotation2")
        ShadowBolt("rotation3")
    end
end

SummonCharhound:Callback("pvp", function(spell)
    if not spell:ReadyToUse() then return end
    if gs.vilefiendCd > 500 then return end
    if player:Buff(buffs.arenaPreparation) then return end 

    return spell:Cast()
end)

HandOfGuldan:Callback("pvp", function(spell)
    if not spell:ReadyToUse() then return end
    if gs.soulShards < 3 then return end

    return spell:Cast(target)    
end)

CallDreadstalkers:Callback("pvp", function(spell)
    if not spell:ReadyToUse() then return end

    return spell:Cast(target)
end)

CallDreadstalkers:Callback(function(spell)

    return spell:Cast(target)
end)

GrimoireFelguard:Callback("pvp", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if spell.cost > gs.soulShards then return end

    return spell:Cast(target)
end)

PowerSiphon:Callback("pvp", function(spell)
    local impsActive = A.Implosion:GetCount()
    if player:Buff(buffs.arenaPreparation) then return end
    if impsActive < 2 then return end
    if player:Buff(buffs.demonicCore) then return end

    return spell:Cast()
end)

Demonbolt:Callback("pvp", function(spell)
    if not player:Buff(buffs.demonicCore) then return end
    if gs.soulShards > 3 then return end
    if not player:TalentKnown(Doom.id) then return end

    return spell:Cast(target)
    
end)

ShadowBolt:Callback("pvp", function(spell)
    if gs.imCasting and gs.imCasting == InfernalBolt.id then return end
    if not gs.infernalBolt then return end

    return spell:Cast(target)
end)

ShadowBolt:Callback(function(spell)

    return spell:Cast(target)
end)

local function pvprotation()
    if A.IsInPvP then

        GrimoireFelguard("rotation")
        SummonVilefiend("rotation")
        CallDreadstalkers("rotation")
        Demonbolt("rotation")
        DemonicStrength("rotation")
        BilescourgeBombers("rotation")
        HandOfGuldan("rotation")
        Implosion("rotation")
        HandOfGuldan("rotation2")
        Demonbolt("rotation2")
        Demonbolt("rotation3")
        PowerSiphon("rotation")
        ShadowBolt("rotation")
        HandOfGuldan("rotation3")
        Demonbolt("rotation4")
        ShadowBolt("rotation2")
        ShadowBolt("rotation3")
    end
end

A[3] = function(icon)
	FrameworkStart(icon)
    updategs()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Grimoire: Felguard: ", gs.felguardRemains)
        MakPrint(2, "Vilefiend: ", gs.vilefiendRemains)
        MakPrint(3, "Dreadstalkers: ", gs.dreadstalkersRemains)
        MakPrint(4, "Pool Cores: ", gs.poolCoresForTyrant)
        MakPrint(5, "Ritual Remains: ", gs.diabolicRitualRemains)
        MakPrint(6, "Cursor Check: ", gs.cursorCheck)
        MakPrint(7, "Active Enemies: ", gs.activeEnemies)
        MakPrint(8, "Soul Shards: ", gs.soulShards)
        MakPrint(9, "Ruination: ", gs.ruination)
        MakPrint(10, "Imp Despawn: ", gs.impDespawn)
        MakPrint(11, "First Tyrant Time: ", gs.firstTyrantTime)
        MakPrint(12, "Enemy energy: ", UnitPower("target"))
    end

    FelDomination()
    SummonFelguard()
    HealthFunnel()
    CreateSoulwell()
    PowerSiphon("pre")
    UnendingResolve()
    DarkPact()

    makInterrupt(interrupts)

    local imCasting = player.castInfo
    if imCasting and imCasting.remaining > 500 then return end
    if player.channeling then return end

	if target.exists and target.canAttack and ShadowBolt:InRange(target) then
        MortalCoil()
        DrainLife()

        if player.combatTime == 0 then
            -- Movement check is now handled by the framework via ignoreMoving flag
            Demonbolt("pre")
            ShadowBolt("pre")
        end

        if shouldBurst() then
            -- Use racials during Tyrant or at end of fight (<22s), per APL
            if pet:Buff(buffs.demonicPower) or gs.fightRemains < 22000 then
                racials()
            end
            -- Use on-use trinkets during Tyrant window
            if pet:Buff(buffs.demonicPower) then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end

            -- Potion during Tyrant window (APL: potion,if=pet.demonic_tyrant.active)
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                if pet:Buff(buffs.demonicPower) then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        if A.GetToggle(2, "endOfFight") and gs.fightRemains < 30000 then
            endOfFight()
        end

        if shouldBurst() then
            if player.combatTime * 1000 < gs.firstTyrantTime and SummonDemonicTyrant.cd < gs.firstTyrantTime then
                opener()
            end

            local castingTyrant = gs.imCasting and gs.imCasting == SummonDemonicTyrant.id
            if SummonDemonicTyrant.cd < A.GetGCD() * 14000 and not castingTyrant then
                tyrant()
            end
        end

        pvprotation()
        rotation()

	end

    if A.IsInPvP then 

        pvprotation()

    end    

	return FrameworkEnd()
end

local function shouldExhaustion(enemy)
    -- Enemy is ranged and not slowed by ally
    if enemy:HasDeBuff(debuffs.curseOfExhaustion) then return end
    
    return not enemy.isMelee and not enemy.slowed
end

local function shouldTongues(enemy)
    -- Enemy slowed already WITHOUT Exhaustion
    -- Enemy is caster
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfTongues) then return end
    
    return not enemy.isMelee 
end

local function shouldWeakness(enemy)
    -- Enemy is melee and not healer
    if enemy:HasDeBuff(debuffs.curseOfExhaustion, true) then return end
    if enemy:HasDeBuff(debuffs.curseOfWeakness) then return end
    
    return enemy.isMelee and not enemy.isHealer
end

CurseOfExhaustion:Callback("arena", function(spell, enemy)
    if not shouldExhaustion(enemy) then return end
    
    return spell:Cast(enemy)
end)

CurseOfTongues:Callback("arena", function(spell, enemy)
    if not shouldTongues(enemy) then return end
    
    return spell:Cast(enemy)
end)

CurseOfWeakness:Callback("arena", function(spell, enemy)
    if not shouldWeakness(enemy) then return end
    
    return spell:Cast(enemy)
end)

local function fearDuration()
    for i = 1, 3 do
        local enemy = "arena" .. i
        if ActionUnit(enemy):IsExists() and ActionUnit(enemy):HasDeBuffs(A.Fear.ID, true) > 0 then
            return ActionUnit(enemy):HasDeBuffs(A.Fear.ID) * 1000
        end
    end
    return 0
end

Fear:Callback("arena", function(spell, enemy)
    
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end
    
    if not enemy:Los() then return end
    if spell:IsImmune(enemy) or enemy:IsTotalImmune() or enemy:IsMagicImmune() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end    
    if enemy:IsTarget() then return end
    if enemy.disorientDr <= 0.25 then return end
    if ccRemains > Fear:CastTime() + MakGCD() then return end
    if fearDuration() > Fear:CastTime() then return end
    
    local fearCastTime = spell:CastTime()
    if arena1:HasDeBuffRemain(spell.Id, fearCastTime) then return end
    if arena2:HasDeBuffRemain(spell.Id, fearCastTime) then return end
    if arena3:HasDeBuffRemain(spell.Id, fearCastTime) then return end
    
    if enemy.cc then return end
    
    if enemy:Debuff(debuffs.fear) then
        Aware:displayMessage("Chain Fearing", "Purple", 1)
        return spell:Cast(enemy)
    end
    
    if enemy.isHealer then 
        Aware:displayMessage("Fearing Healer", "Green", 1)
        return spell:Cast(enemy)
    end
    
    local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party1.hp > 0 and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        Aware:displayMessage("Fearing To Peel", "Red", 1)
        return spell:Cast(enemy)
    end
    
    if enemy:Debuff(debuffs.mortalCoil) then
        return spell:Cast(enemy)
    end
end)

AxeToss:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end
    
    return spell:Cast(enemy)
end)

MortalCoil:Callback("arena", function(spell, enemy)
    if enemy.incapacitateDr <= 0.5 then return end

    if enemy.pvpKick or (enemy:Debuff(debuffs.fear) and enemy:DebuffRemains(debuffs.fear) < 1000) then
        return spell:Cast(enemy)
    end

    if target.hp < 50 and enemy.isHealer then
        return spell:Cast(enemy)
    end
end)

Demonbolt:Callback("arena", function(spell, enemy)
    if not spell:ReadyToUse() then return end
    if not enemy or not enemy.exists or enemy:IsDeadOrGhost() or not enemy:CanAttack() then return end
    if not enemy:Los() or (spell:HasRange() and not spell:InRange(enemy)) then return end

    if player:HasBuffCount(buffs.demonicCore, true) < 1 then return end
    if enemy:DebuffRemains(debuffs.doom, true) > 0 then return end

    return spell:Cast(enemy)
end)



local enemyRotation = function(enemy)
    if not enemy.exists then return end
    AxeToss("arena", enemy)
    MortalCoil("arena", enemy)
    Demonbolt("arena", enemy)
    CurseOfExhaustion("arena", enemy)
    CurseOfTongues("arena", enemy)
    CurseOfWeakness("arena", enemy)
    Fear("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end

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
