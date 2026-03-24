--[[ 
Chain Lightning: /cast Chain Lightning; Lava Beam
Stoneskin Totem: /cast Stone Bulwark Totem
Gift of the Naaru: /cast Skyfury
Darkflight: /cast Thunderstrike Ward
Nature's Swiftness: /cast Nature's Swiftness; Ancestral Swiftness

TODO:
PVP:
- Fix Grounding
- Fix Kick
- Fix Purge
- Fix Tremor
- Optimize Flameshock + Prim Wave leveraging min:flame_shock.remains and A123
- Optimize Ascendance

PVE:
- build min:flame_shock.remains + tab targeting for primwave/flameshock

]]


if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 262 then return end

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
local Trinket          = MakuluFramework.Trinket
local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit       	   = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local ConstSpells      = MakuluFramework.constantSpells

local FakeCasting                     = MakuluFramework.FakeCasting

local _G, setmetatable = _G, setmetatable

local ActionID       = {
    AncestralCall  = { ID = 274738, MAKULU_INFO = { ignoreCasting = true } },
    BagOfTricks    = { ID = 312411, MAKULU_INFO = { ignoreCasting = true } },
    Berserking     = { ID = 26297, MAKULU_INFO = { ignoreCasting = true } },
    BloodFury      = { ID = 20572, MAKULU_INFO = { ignoreCasting = true } },
    BullRush       = { ID = 255654, MAKULU_INFO = { ignoreCasting = true } },
    Darkflight     = { ID = 68992, MAKULU_INFO = { ignoreCasting = true } },
    Fireblood      = { ID = 265221, MAKULU_INFO = { ignoreCasting = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { ignoreCasting = true } },
    Haymaker       = { ID = 287712, MAKULU_INFO = { ignoreCasting = true } },
    QuakingPalm    = { ID = 107079, MAKULU_INFO = { ignoreCasting = true } },
    Regeneratin    = { ID = 291944, MAKULU_INFO = { ignoreCasting = true } },
    RocketBarrage  = { ID = 69041, MAKULU_INFO = { ignoreCasting = true } },
    RocketJump     = { ID = 69070, MAKULU_INFO = { ignoreCasting = true } },
    Stoneform      = { ID = 20594, MAKULU_INFO = { ignoreCasting = true }  },
    WarStomp       = { ID = 20549, MAKULU_INFO = { ignoreCasting = true } },

    AncestralGuidance    = { ID = 108281, MAKULU_INFO = { ignoreCasting = true } },
    AncestralSpirit      = { ID = 2008, MAKULU_INFO = { ignoreCasting = true } },
    AstralShift          = { ID = 108271, MAKULU_INFO = { ignoreCasting = true } },
    Bloodlust            = { ID = 2825, MAKULU_INFO = { ignoreCasting = true } },
    BloodlustShamanism   = { ID = 204361, FixedTexture = 133667, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    CapacitorTotem       = { ID = 192058, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ChainHeal            = { ID = 1064, MAKULU_INFO = { ignoreCasting = true } },
    ChainLightning       = { ID = 188443, Texture = 369675, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast Chain Lightning\n/cast Lava Beam" },
    CleanseSpirit        = { ID = 51886, MAKULU_INFO = { ignoreCasting = true } },
    EarthElemental       = { ID = 198103, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EarthShield          = { ID = 974, MAKULU_INFO = { ignoreCasting = true } },
    EarthShieldParty     = { ID = 974, Texture = 356736, Hidden = true, MAKULU_INFO = { ignoreCasting = true } },
    EarthbindTotem       = { ID = 2484, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EarthgrabTotem       = { ID = 51485, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FlameShock           = { ID = 470411, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FlametongueWeapon    = { ID = 318038, MAKULU_INFO = { ignoreCasting = true } },
    FrostShock           = { ID = 196840, Texture = 12982, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    GhostWolf            = { ID = 2645, MAKULU_INFO = { ignoreCasting = true } },
    GreaterPurge         = { ID = 378773, MAKULU_INFO = { ignoreCasting = true } },
    GustofWind           = { ID = 192063, MAKULU_INFO = { ignoreCasting = true } },
    HealingStreamTotem   = { ID = 5394, MAKULU_INFO = { ignoreCasting = true } },
    HealingSurge         = { ID = 8004, MAKULU_INFO = { ignoreCasting = true } },
    Heroism              = { ID = 32182, MAKULU_INFO = { ignoreCasting = true } },
    HeroismShamanism     = { ID = 204362, FixedTexture = 133667, MAKULU_INFO = { ignoreCasting = true, offGcd = true } },
    Hex                  = { ID = 51514 , MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LavaBurst            = { ID = 51505, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LightningBolt        = { ID = 188196, Texture = 29166, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast Lightning Bolt\n/cast Tempest" },
    LightningLasso       = { ID = 305483, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LightningShield      = { ID = 192106, MAKULU_INFO = { ignoreCasting = true } },
    NaturesSwiftness     = { ID = 378081, Texture = 132158, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast Nature's Swiftness\n/cast Ancestral Swiftness" },
    PoisonCleansingTotem = { ID = 383013, MAKULU_INFO = { ignoreCasting = true } },
    PrimalStrike         = { ID = 73899, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Purge                = { ID = 370, MAKULU_INFO = { ignoreCasting = true } },
    Skyfury              = { ID = 462854, MAKULU_INFO = { ignoreCasting = true } }, -- Gift of the Naaru
    SpiritWalk           = { ID = 58875, MAKULU_INFO = { ignoreCasting = true } },
    SpiritwalkersGrace   = { ID = 79206, MAKULU_INFO = { ignoreCasting = true } },
    StoneBulwarkTotem    = { ID = 108270, MAKULU_INFO = { ignoreCasting = true } },
    Thunderstorm         = { ID = 51490, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ThunderstrikeWard    = { ID = 462757, MAKULU_INFO = { ignoreCasting = true } }, -- Darkflight
    TotemicProjection    = { ID = 108287, MAKULU_INFO = { ignoreCasting = true } },
    TotemicRecall        = { ID = 108285, MAKULU_INFO = { ignoreCasting = true } },
    TranquilAirTotem     = { ID = 383019, MAKULU_INFO = { ignoreCasting = true } },
    TremorTotem          = { ID = 8143, MAKULU_INFO = { ignoreCasting = true } },
    WaterWalking         = { ID = 546, MAKULU_INFO = { ignoreCasting = true } },
    WindRushTotem        = { ID = 192077, MAKULU_INFO = { ignoreCasting = true } },
    WindShear            = { ID = 57994, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, offGcd = true } },

    Ascendance       = { ID = 114050, MAKULU_INFO = { ignoreCasting = true } },
    EarthShock       = { ID = 8042, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    Earthquake       = { ID = 61882, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true }, Macro = "/cast Single-Button Assistant" },
    EarthquakeT      = { ID = 462620, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true }, Macro = "/cast Single-Button Assistant" },
    ElementalBlast   = { ID = 117014, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, ignoreResource = true } },
    FireElemental    = { ID = 198067, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Icefury          = { ID = 210714, Texture = 12982, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LavaBeam         = { ID = 114074, Texture = 369675, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LiquidMagmaTotem = { ID = 192222, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast Single-Button Assistant" },
    PrimordialWave   = { ID = 375982, FixedTexture = 3578231, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    StormElemental   = { ID = 192249, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Stormkeeper      = { ID = 191634, MAKULU_INFO = { ignoreCasting = true } },

    CounterstrikeTotem = { ID = 204331, MAKULU_INFO = { ignoreCasting = true } },
    GroundingTotem     = { ID = 204336, MAKULU_INFO = { ignoreCasting = true } },
    SkyfuryTotem       = { ID = 204330, MAKULU_INFO = { ignoreCasting = true } },
    StaticFieldTotem   = { ID = 355580, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    UnleashShield      = { ID = 356736, MAKULU_INFO = { ignoreCasting = true } },

    AncestralSwiftness = { ID = 443454, Texture = 132158, MAKULU_INFO = { ignoreCasting = true } },
    Tempest = { ID = 454009, Texture = 29166, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    TempestToo = { ID = 452201, Texture = 29166, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    DeeplyRootedElements       = { ID = 378270, Hidden = true },
    EchoChamber                = { ID = 382032, Hidden = true },
    EchoOfTheElements          = { ID = 333919, Hidden = true },
    EchoesOfGreatSundering     = { ID = 384087, Hidden = true },
    ElectrifiedShocks          = { ID = 381726, Hidden = true },
    ElementalOrbit             = { ID = 383010, Hidden = true },
    ElementalReverb            = { ID = 443418, Hidden = true },
    EyeOfTheStorm              = { ID = 381708, Hidden = true },
    FlowOfPower                = { ID = 385923, Hidden = true },
    FluxMelting                = { ID = 381776, Hidden = true },
    FurtherBeyond              = { ID = 381787, Hidden = true },
    FuryoftheStorms            = { ID = 191717, Hidden = true },
    FusionOfElements           = { ID = 462840, Hidden = true },
    LavaSurge                  = { ID = 77756, Hidden = true },
    LightningRod               = { ID = 210689, Hidden = true },
    MagmaChamber               = { ID = 381932, Hidden = true },
    MasterOfTheElements        = { ID = 16166, Hidden = true },
    MountainsWillFall          = { ID = 381726, Hidden = true },
    PrimordialCapacity         = { ID = 443448, Hidden = true },
    PrimordialSurge            = { ID = 386474, Hidden = true },
    SearingFlames              = { ID = 381782, Hidden = true },
    SkybreakersFieryDemise     = { ID = 378310, Hidden = true },
    SplinteredElements         = { ID = 382042, Hidden = true },
    SurgeOfPower               = { ID = 356736, Hidden = true },
    SwellingMaelstrom          = { ID = 381707, Hidden = true },
    UnrelentingCalamity        = { ID = 382685, Hidden = true },
    WindspeakersLavaResurgence = { ID = 378268, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    Burrow           = { ID = 409293, },
    ArenaPreparation = { ID = 32727, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_SHAMAN_ELEMENTAL] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local function num(val)
    if val then return 1 else return 0 end
end

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
    cursorCheck            = false,
    echoesOfGreatSundering = false,
    enemyPWaveReady        = false,
    flameShockTotal        = 0,
    flameShockUp           = false,
    imCasting              = nil,
    imCastingName          = nil,
    imCastingRemaining     = 0,
    lowestFlameShock       = 0,
    lowestFlameShockUnit   = nil,
    maelCap                = 100,
    maelstrom              = 0,
    minTalentedCdRemains   = nil,
    orbsActive             = false,
    rodCount               = 0,
    shouldAoE              = false,
    shouldAoESpenders      = false,
}

local buffs = {
    ancestralGuidance          = 108281,
    arcDischarge               = 455097,
    ascendance                 = 114050,
    earthShield                = 974,
    earthShieldOrbit           = 383648,
    echoesOfGreatSundering     = 384088,
    elementalEquilibrium       = 378275,
    fluxMelting                = 381777,
    fusionOfElementsFire       = 462840,
    fusionOfElementsNature     = 462840,
    grounding                  = 8178,
    icefury                    = 462818,
    icefuryDmg                 = 210714,
    lavaSurge                  = 77762,
    lightningShield            = 192106,
    magmaChamber               = 381933,
    masterOfTheElements        = 260734,
    naturesSwiftness           = 378081,
    powerOfTheMaelstrom        = 191877,
    primordialWave             = 375986,
    spiritwalkersGrace         = 79260,
    splinteredElements         = 382043,
    stormFrenzy                = 462725,
    stormkeeper                = 191634,
    surgeOfPower               = 285514,
    tempest                    = 454015,
    windspeakersLavaResurgence = 378269,
}

local debuffs = {
    electrifiedShocks = 382089,
    exhaustion        = 57723,
    flameShock        = 188389,
    intimidation      = 24394,
    lightningRod      = 197209,
    scatterShot       = 213691,
}


Player:AddTier("Tier31", { 217236, 217237, 217238, 217239, 217240, })
local T31has2P = Player:HasTier("Tier31", 2)
local T31has4P = Player:HasTier("Tier31", 4)

local interrupts = {
    {spell = WindShear },
    --{spell = LightningLasso, isCC = true},
    {spell = Thunderstorm, isCC = true, aoe = true, distance = 5},
}


local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if LightningBolt:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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
    -- More robust enemy counting: combine nameplate scan with framework fallbacks
    local count1 = enemiesInRange() or 0
    local count2 = (MultiUnits and MultiUnits.GetActiveEnemies and MultiUnits:GetActiveEnemies()) or 0
    local count3 = (MakMulti and MakMulti.GetActiveEnemies and MakMulti:GetActiveEnemies(40)) or 0
    return math.max(count1, count2, count3, 1)
end


-- Estimate average pack time-to-die across active enemies
local function packTTD()
    local active = MultiUnits:GetActiveUnitPlates()
    local total, n = 0, 0
    for guid in pairs(active) do
        local e = MakUnit:new(guid)
        if LightningBolt:InRange(e) and ((player.inCombat and e.inCombat) or e.isDummy) and not e:IsTotem() and not e.isPet then
            total = total + (e.ttd or 0)
            n = n + 1
        end
    end
    return (n > 0 and (total / n) or target.ttd or 0)
end

-- Avoid dumping Awakening/Tempest stacks into dying packs
local function suppressAwakeningDump()
    return player:HasBuffCount(buffs.tempest) >= 8 and packTTD() < 8000
end

local function shouldBurst()
    local burstStyle = A.GetToggle(2, "burstStyle")
    if burstStyle == "1" then
        if A.BurstIsON("target") then
            if A.Zone ~= "arena" then
                local activeEnemies = MultiUnits:GetActiveUnitPlates()
                for enemyGUID in pairs(activeEnemies) do
                    local enemy = MakUnit:new(enemyGUID)
                    if enemy.ttd >= A.GetToggle(2, "burstSens") * 1000 then
                        return true
                    end
                end
                if target.isDummy then return true end
            else
                return true
            end
        end
        return false
    else
        return makBurst()
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

    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        if enemy:Debuff(spellId, true) then
            debuffCount = debuffCount + 1
        end
    end

    return debuffCount
end

local function lowestFlameShockUnit()
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local lowestDuration = nil
    local lowestFlameShock = nil

    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        local debuffDuration = enemy:DebuffRemains(debuffs.flameShock, true)

        if not enemy:Debuff(debuffs.flameShock, true) then
            debuffDuration = 0
        end

        if lowestDuration == nil or debuffDuration < lowestDuration then
            lowestDuration = debuffDuration
            lowestFlameShock = enemy
        end
    end

    return lowestFlameShock, lowestDuration
end

local function registerCooldowns()

    return A.UnitCooldown:Register("arena", PrimordialWave.id, 30, false, true, nil, true)
end

local function shouldRecall()
    local recall = A.GetToggle(2, "recallSelect")

    -- recallSelect[1] = Tremor Totem
    -- recallSelect[2] = Capacitor Totem
    -- recallSelect[3] = Stone Bulwark Totem
    -- recallSelect[4] = Static Field Totem
    -- recallSelect[5] = Grounding Totem
    -- recallSelect[6] = Liquid Magma Totem

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

    if LiquidMagmaTotem.cd > 15000 and IsPlayerSpell(FireElemental.id) and recall[6] then
        return true
    end

    if WindRushTotem.cd > 15000 and recall[7] then
        return true
    end

    if PoisonCleansingTotem.cd > 15000 and recall[8] then
        return true
    end

    if HealingStreamTotem.cd > 15000 and recall[9] then
        return true
    end

    return false
end

local function orbsActive()
    local cacheKey = "orbsActive"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            local enemyCast = enemy.castInfo
            local orb = enemyCast and enemyCast.spellId == 461904
            if LightningBolt:InRange(enemy) and orb then
                return true
            end
        end

        return false
    end)
end

local function autoTarget()
    if not player.inCombat then return false end

    if gameState.orbsActive then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if A.GetToggle(2, "autoRod") and player:TalentKnown(LightningRod.id) and gameState.rodCount < math.min(gameState.activeEnemies, 5) and target:DebuffRemains(debuffs.lightningRod, true) > 1000 then
        return true
    end
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength

    return currentCast, currentCastName, remains, length
end

local function maelstrom()
    local maelstrom = player.maelstrom
    local changes = 0

    local maelstromChanges = {
        [LightningBolt.id] = 6 + (2 * num(A.FlowOfPower:IsTalentLearned())),
        [ChainLightning.id] = 2 * (math.min(activeEnemies(), 5)),
        [LavaBurst.id] = 8 + (2 * num(A.FlowOfPower:IsTalentLearned())),
        [ElementalBlast.id] = -90 + (10 * num(A.EyeOfTheStorm:IsTalentLearned())),
    }

    if gameState.imCasting then
        changes = maelstromChanges[gameState.imCasting] or 0
    end

    return maelstrom + changes
end

local function earthShieldCount()
    local partyUnits = {party1, party2, party3, party4, player}
    local total = 0
    for _, unit in ipairs(partyUnits) do
        if unit:Buff(buffs.earthShield, true) or unit:Buff(buffs.earthShieldOrbit, true) then
            total = total + 1
        end
    end

    return total
end

local function tempDeBuffFor(unitToken, debuffSpellId)
    local currentTime = GetTime()  -- Localize GetTime() for performance
    for index = 1, 500 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unitToken.CallerId(), index, "HARMFUL")
        if not aura then
            -- No more debuffs on the target
            break
        end

        if aura.spellId == debuffSpellId then
            if aura.expirationTime and aura.duration then
                local timeApplied = currentTime - (aura.expirationTime - aura.duration)
                return timeApplied
            else
                -- Could log or handle the case of missing expirationTime/duration
                return nil -- No expirationTime or duration data available
            end
        end
    end

    -- Debuff with specified spellId was not found
    return nil
end

local function tempGroundingCheck(unitToken, debuffSpellIds, threshold)
    for _, debuffSpellId in ipairs(MakLists.arenaGrounding) do
        local timeApplied = tempDeBuffFor(unitToken, debuffSpellId)
        if timeApplied and timeApplied > threshold then
            return true
        end
    end

    -- If no debuff in the list exceeds the threshold, return false
    return false
end


local function tempBuffFor(unitToken, buffSpellId)
    local currentTime = GetTime()  -- Localize GetTime() for performance
    for index = 1, 500 do
        local aura = C_UnitAuras.GetAuraDataByIndex(unitToken.CallerId(), index, "HELPFUL")
        if not aura then
            -- No more buffs on the target
            break
        end

        if aura.spellId == buffSpellId then
            if aura.expirationTime and aura.duration then
                local timeApplied = currentTime - (aura.expirationTime - aura.duration)
                return timeApplied
            else
                -- Could log or handle the case of missing expirationTime/duration
                return nil -- No expirationTime or duration data available
            end
        end
    end

    -- Buff with specified spellId was not found
    return nil
end

local function tempPurgeCheck(unitToken, buffSpellIds, threshold)
    for _, buffSpellId in ipairs(buffSpellIds) do
        local timeApplied = tempBuffFor(unitToken, buffSpellId)
        if timeApplied and timeApplied >= threshold then
            return true
        end
    end

    return false
end

FakeCasting.enable()

FakeCasting.blacklist({
  ["Lightning Bolt"] = true,
  ["Lava Burst"] = true,
  ["Dark Reprimand"] = true,
  ["Healing Surge"] = true,
  ["Stormkeeper"] = true,

})

local lastUpdateTime = 0
local updateDelay = 0.5
local function updateGameState()
    mouseover = MakUnit:new("mouseover")

    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gameState.imCastingRemaining = currentCastRemains
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime
    end

    registerCooldowns()

    gameState.maelstrom = maelstrom()
    gameState.maelCap = player.maelstromMax

    gameState.activeEnemies = activeEnemies()

    gameState.flameShockUp = target:DebuffRemains(debuffs.flameShock, true) > 3000 or FlameShock.cd > 2000 and (PrimordialWave.cd > 2000 or not A.PrimordialWave:IsTalentLearned())
    gameState.flameShockTotal = debuffCount(debuffs.flameShock)

    local cursorCondition = (FlameShock:InRange(mouseover) or HealingSurge:InRange(mouseover)) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gameState.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gameState.shouldAoE = gameState.activeEnemies >= 2 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    -- ST Spenders with AoE Builders toggle: allows Chain Lightning for AoE building while using ST spender logic
    local stSpendersToggle = A.GetToggle(2, "stSpendersAoeBuilders")
    gameState.shouldAoESpenders = gameState.shouldAoE and not stSpendersToggle

    gameState.lowestFlameShockUnit, gameState.lowestFlameShock = lowestFlameShockUnit()

    gameState.stormkeeper = player:Buff(buffs.stormkeeper) or (gameState.imCasting and gameState.imCasting == Stormkeeper.id)
    gameState.consumingSOP = gameState.imCasting and (gameState.imCasting == LightningBolt.id or gameState.imCasting == ChainLightning.id or gameState.imCasting == Tempest.id or gameState.imCasting == LavaBurst.id)
    gameState.surgeOfPower = (player:Buff(buffs.surgeOfPower) and not gameState.consumingSOP) or (gameState.imCasting and gameState.imCasting == ElementalBlast.id)
    gameState.masterOfTheElements = player:Buff(buffs.masterOfTheElements) or (gameState.imCasting and gameState.imCasting == LavaBurst.id)
    gameState.echoesOfGreatSundering = player:Buff(buffs.echoesOfGreatSundering) or (gameState.imCasting and gameState.imCasting == ElementalBlast.id)

    gameState.rodCount = enemiesInRange(debuffs.lightningRod, 1000)

    gameState.pwaveInFlight = A.UnitCooldown:IsSpellInFly("enemy", PrimordialWave.id)
    --gameState.enemyPWaveReady = A.UnitCooldown:GetCooldown("enemy", PrimordialWave.id) == 0 won't be able to use this until we have spec checks at arena start

    gameState.healerTrappedSoon = healer:Debuff(debuffs.scatterShot) or healer:Debuff(debuffs.intimidation)

    gameState.orbsActive = orbsActive()
end

--#############################################################################GLOBAL##########################################################################################################

WindShear:Callback("every", function(spell, enemy)
    if player:Buff(buffs.grounding) then return end
    if not enemy.exists then return end
    if enemy:BuffFrom(MakLists.KickImmune) then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 420) then return end

    return spell:Cast(enemy)
end)

TotemicRecall:Callback(function(spell)
    if not shouldRecall() then return end

    return spell:Cast()
end)

Skyfury:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit)
        if HealingSurge:InRange(unit) and not unit.isPet and unit.hp > 0 then
            if not unit:Buff(Skyfury.wowName) then
                return true
            end
        end
        return false
    end)

    local outOfRange = MakMulti.party:Any(function(unit) return not HealingSurge:InRange(unit) or unit.distance <= 0 end)

    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if not missingBuff then return end

    return Debounce("skyfury", 1000, 2500, spell, player)
end)

Skyfury:Callback('pvp', function(spell)
    -- Check if player already has Skyfury buff
    if player:Buff(Skyfury.wowName) then return end

    -- Only use out of combat
    if player.inCombat then return end

    return spell:Cast(player)
end)

AstralShift:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "astralShiftHP") then
        return spell:Cast()
    end
end)

StoneBulwarkTotem:Callback(function(spell)
    if not A.StoneBulwarkTotem:IsTalentLearned() then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end
    if shouldDefensive() or player.hp < A.GetToggle(2, "stoneBulwarkTotemHP") then
        return spell:Cast()
    end
end)

AncestralGuidance:Callback(function(spell)
    if not A.AncestralGuidance:IsTalentLearned() then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "ancestralGuidanceHP") then
        return spell:Cast()
    end
end)

EarthElemental:Callback(function(spell)
    if not A.EarthElemental:IsTalentLearned() then return end

    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[4] then return end

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "earthElementalHP") then
        return spell:Cast()
    end
end)

FlametongueWeapon:Callback(function(spell)
    local hasMainHandEnchant, mainHandExpiration = GetWeaponEnchantInfo()
    if not hasMainHandEnchant or not player.inCombat and mainHandExpiration <= 1800000 then
        return spell:Cast()
    end
end)

ThunderstrikeWard:Callback(function(spell)
    local _, _, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()
    if not hasOffHandEnchant or not player.inCombat and offHandExpiration <= 1800000 then
        return spell:Cast()
    end
end)

LightningShield:Callback(function(spell)
    if player:Buff(buffs.lightningShield) then return end

    return spell:Cast()
end)

EarthShield:Callback(function(spell)
    if player:Buff(buffs.earthShield, true) then return end
    if player:Buff(buffs.earthShieldOrbit, true) then return end
    if not A.ElementalOrbit:IsTalentLearned() then return end
    if player.combatTime > 0 and player.hp > 60 then return end

    return spell:Cast()
end)

SpiritwalkersGrace:Callback(function(spell)
    if player:BuffFrom(MakLists.ignoreMoving) then return end
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then
        if Stormkeeper.cd > 500 then return end
        if Ascendance.cd < 500 then return end
        if player:Buff(buffs.ascendance) then return end
    end

    return spell:Cast()
end)

Stormkeeper:Callback(function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if gameState.stormkeeper then return end
    if player:Buff(buffs.ascendance) then return end
    --if player.moving and not player:Buff(buffs.spiritwalkersGrace) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    return spell:Cast()
end)

Stormkeeper:Callback("nonLightning", function(spell)
    if gameState.maelstrom >= EarthShock:Cost() then return end

    if gameState.stormkeeper then return end
    if player:Buff(buffs.ascendance) then return end
    --if player.moving and not player:Buff(buffs.spiritwalkersGrace) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    return spell:Cast()
end)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not A.Ascendance:IsTalentLearned() or player:Buff(buffs.ascendance) or Ascendance:Cooldown() > 50000 then
        return spell:Cast()
    end
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not A.Ascendance:IsTalentLearned() or player:Buff(buffs.ascendance) then
        return spell:Cast()
    end
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not A.Ascendance:IsTalentLearned() or player:Buff(buffs.ascendance) or Ascendance:Cooldown() > 50000 then
        return spell:Cast()
    end
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not A.Ascendance:IsTalentLearned() or player:Buff(buffs.ascendance) or Ascendance:Cooldown() > 50000 then
        return spell:Cast()
    end
end)

BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    if not A.Ascendance:IsTalentLearned() or player:Buff(buffs.ascendance) then
        return spell:Cast()
    end
end)

NaturesSwiftness:Callback(function(spell)
    if IsPlayerSpell(A.AncestralSwiftness.ID) then return end

    return spell:Cast()
end)

AncestralSwiftness:Callback(function(spell)
    if not IsPlayerSpell(A.AncestralSwiftness.ID) then return end

    return spell:Cast()
end)

FireElemental:Callback(function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    return spell:Cast()
end)

StormElemental:Callback(function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    return spell:Cast()
end)

local function shouldGrounding()
    if not A.GroundingTotem:IsTalentLearned() then return end

    local arenaUnits = {arena1, arena2, arena3}
    for _, unit in ipairs(arenaUnits) do
        if unit:PvpGround(MakLists.arenaGrounding) then
            print("PvpGround detected for unit:", unit)
            return true
        end
    end

    return false
end

GroundingTotem:Callback("arena", function(spell)
    if target.exists and target.canAttack and target.hp < 20 then return end
    if WindShear:Cooldown() == 0 then return end
    --TEST
    --if target.exists and target:PvpKick(Maklists.arenaGrounding) then
    --    return spell:Cast(player)
    --end
    if healer:HasDeBuffFromFor(MakLists.arenaHealerGround, 300) then
        return spell:Cast()
    end

    if arena1.exists and arena1:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast()
    end

    if arena2.exists and arena2:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast()
    end

    if arena3.exists and arena3:CastingFromFor(MakLists.arenaGrounding, 450) then
        return spell:Cast()
    end

    if gameState.pwaveInFlight then
        return spell:Cast()
    end

    if gameState.healerTrappedSoon then
        return spell:Cast()
    end
end)

--TripQ -- We need to make sure the fear has been on target for at least 0.5 seconds before we tremor it and that the remaining duration on fear is at least x second.
TremorTotem:Callback("arena", function(spell)
    local onlyHeals = A.GetToggle(2, "OnlyTremorHealer")
    if target.exists and target.hp < 20 then return end

    if (party1.isHealer or not onlyHeals) and party1:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        print("Tremor on party1")
        return spell:Cast()
    end

    if (party2.isHealer or not onlyHeals) and party2:HasDeBuffFromFor(MakLists.arenaTremor, 500) then
        print("Tremor on party2")
        return spell:Cast()
    end
end)

--############################################################################# AOE ##########################################################################################################


LiquidMagmaTotem:Callback("aoe", function(spell)
    if not gameState.cursorCheck then return end

    -- SimC AoE: LMT to spread FS when PWave soon or untalented, and FS count needs it
    local enemies = gameState.activeEnemies or activeEnemies()
    local fs_ok = (gameState.flameShockTotal <= (enemies - 3)) or (gameState.flameShockTotal < math.min(enemies, 3))
    if (PrimordialWave.cd < A.GetGCD() * 1000 * 5 or not player:TalentKnown(PrimordialWave.id)) and fs_ok then
        return spell:Cast()
    end
end)

LiquidMagmaTotem:Callback("V2", function(spell)
    if not gameState.cursorCheck then return end

    -- SimC AoE: LMT to spread FS when PWave soon or untalented, and FS count needs it
    local enemies = gameState.activeEnemies or activeEnemies()
    local fs_ok = (gameState.flameShockTotal <= (enemies - 3)) or (gameState.flameShockTotal < math.min(enemies, 3))
    if fs_ok then
        return spell:Cast()
    end
end)

--actions.aoe+=/primordial_wave,target_if=min:dot.flame_shock.remains,if=buff.surge_of_power.up|!talent.surge_of_power.enabled|maelstrom<60-5*talent.eye_of_the_storm.enabled
--add min:dot
PrimordialWave:Callback("aoe", function(spell)
    local enemies = gameState.activeEnemies or activeEnemies()
    local fs_cap = math.min(enemies, 6)

    -- SimC AoE: cast if FS on all targets up to 6, or if LMT is far/untalented AND Ascendance is far
    if gameState.flameShockTotal >= fs_cap then
        return spell:Cast(target)
    end
    if ((LiquidMagmaTotem.cd > 15000) or not player:TalentKnown(LiquidMagmaTotem.id)) and (Ascendance.cd > 15000) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "flame_shock,target_if=refreshable,if=buff.surge_of_power.up&talent.lightning_rod.enabled&dot.flame_shock.remains<target.time_to_die-16&active_dot.flame_shock<(spell_targets.chain_lightning>?6)&!talent.liquid_magma_totem.enabled", "{Lightning} Spread Flame Shock using Surge of Power if LMT is not picked." );
FlameShock:Callback("aoe", function(spell)
    if (gameState.activeEnemies or activeEnemies()) > 3 then return end
    -- After Icefury, refresh FS to proc Fusion Elemental Blast
    if Player:PrevGCD(1, A.Icefury) and A.FusionOfElements:IsTalentLearned() and target:DebuffRemains(debuffs.flameShock, true) < 8000 then
        return spell:Cast(target)
    end

    local enemies = gameState.activeEnemies or activeEnemies()
    local ttk = packTTD()
    local fsCap = (ttk < 15000) and 3 or 6
    if gameState.flameShockTotal >= math.min(enemies, fsCap) then return end

    if gameState.surgeOfPower and IsPlayerSpell(A.LightningRod.ID) and target:DebuffRemains(debuffs.flameShock, true) < 2000 and not IsPlayerSpell(A.LiquidMagmaTotem.ID) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=buff.primordial_wave.up&buff.stormkeeper.up&maelstrom<60-5*talent.eye_of_the_storm.enabled-(8+2*talent.flow_of_power.enabled)*active_dot.flame_shock&spell_targets.chain_lightning>=6&active_dot.flame_shock<6", "{Lightning} Cast extra Flame Shock to help getting to next spender for SK+SoP on 6+ targets. Mostly opener." );
FlameShock:Callback("aoe2", function(spell)
    if (gameState.activeEnemies or activeEnemies()) > 3 then return end
    if not player:Buff(buffs.primordialWave) then return end
    if not gameState.stormkeeper then return end
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if gameState.maelstrom < 60 - (5 * num(A.EyeOfTheStorm:IsTalentLearned())) - (8 + (2 * num(A.FlowOfPower:IsTalentLearned()))) * gameState.flameShockTotal and activeEnemies() >= 6 and gameState.flameShockTotal < 6 then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "flame_shock,target_if=refreshable,if=talent.fire_elemental.enabled&(buff.surge_of_power.up|!talent.surge_of_power.enabled)&dot.flame_shock.remains<target.time_to_die-5&(active_dot.flame_shock<6|dot.flame_shock.remains>0)", "{Fire} Spread and refresh Flame Shock using Surge of Power (if talented) up to 6." );
FlameShock:Callback("aoe3", function(spell)
    if (gameState.activeEnemies or activeEnemies()) > 3 then return end

    if not A.FireElemental:IsTalentLearned() then return end

    local enemies = gameState.activeEnemies or activeEnemies()
    local ttk = packTTD()
    local fsCap = (ttk < 15000) and 3 or 6
    if gameState.flameShockTotal >= math.min(enemies, fsCap) then return end

    if gameState.surgeOfPower or not A.SurgeOfPower:IsTalentLearned() then
        if target:DebuffRemains(debuffs.flameShock, true) < 2000 then
            return spell:Cast(target)
        end
    end
end)


--[[FlameShock:Callback("aoe", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 3500 then return end

     if gameState.surgeOfPower then
        if A.LightningRod:IsTalentLearned() and target:DebuffRemains(debuffs.flameShock, true) < ActionUnit("target"):TimeToDie() * 1000 - 16000 and activeEnemies() < 5 then
            return spell:Cast(target)
        end

        if (not A.LightningRod:IsTalentLearned() or A.SkybreakersFieryDemise:IsTalentLearned()) and target:DebuffRemains(debuffs.flameShock, true) < ActionUnit("target"):TimeToDie() * 1000 - 5000 then
            if gameState.flameShockTotal < 6 or target:Debuff(debuffs.flameShock, true) then
                return spell:Cast(target)
            end
        end
    end

    if target:DebuffRemains(debuffs.flameShock, true) < ActionUnit("target"):TimeToDie() * 1000 - 5000 then
        if gameState.flameShockTotal < 6 or target:Debuff(debuffs.flameShock, true) then
            if A.MasterOfTheElements:IsTalentLearned() and not A.LightningRod:IsTalentLearned() and not A.SurgeOfPower:IsTalentLearned() then
                return spell:Cast(target)
            end
            if A.DeeplyRootedElements:IsTalentLearned() and not A.SurgeOfPower:IsTalentLearned() then
                return spell:Cast(target)
            end
        end
    end
end)]]

--actions.aoe+=/tempest,target_if=min:debuff.lightning_rod.remains,if=!buff.arc_discharge.up
Tempest:Callback("aoe", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if Player:PrevGCD(1, A.Tempest) then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end
    if player:Buff(buffs.arcDischarge) then return end

    return spell:Cast(target)
end)
TempestToo:Callback("aoe", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if Player:PrevGCD(1, A.Tempest) then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end
    if player:Buff(buffs.arcDischarge) then return end

    return spell:Cast(target)
end)

Ascendance:Callback("aoe", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    return spell:Cast()
end)

-- aoe->add_action( "lava_beam,if=active_enemies>=6&buff.surge_of_power.up&buff.ascendance.remains>cast_time", "Against 6 targets or more Surge of Power should be used with Lava Beam rather than Lava Burst." );
LavaBeam:Callback("aoe", function(spell)
    if player:BuffRemains(buffs.ascendance) > spell:CastTime()and gameState.surgeOfPower and activeEnemies() >= 6 or gameState.masterOfTheElements and (activeEnemies() >= 6 or not A.SurgeOfPower:IsTalentLearned()) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "chain_lightning,if=active_enemies>=6&buff.surge_of_power.up", "Against 6 targets or more Surge of Power should be used with Chain Lightning rather than Lava Burst." );
ChainLightning:Callback("aoe", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if gameState.surgeOfPower and activeEnemies() >= 6 then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.primordial_wave.up&buff.stormkeeper.up&maelstrom<60-5*talent.eye_of_the_storm.enabled&spell_targets.chain_lightning>=6&talent.surge_of_power.enabled", "Consume Primordial Wave buff immediately if you have Stormkeeper buff, fighting 6+ enemies and need maelstrom to spend." );
LavaBurst:Callback("aoe", function(spell)
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.primordialWave) then return end
    if not gameState.stormkeeper then return end
    if LavaBurst:Used() < 750 then return end
    if gameState.maelstrom < 60 - 5 * num(A.EyeOfTheStorm:IsTalentLearned()) then return end
    if not gameState.surgeOfPower then return end
    if activeEnemies() < 6 then return end

    return spell:Cast(target)
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.primordial_wave.up&(buff.primordial_wave.remains<4|buff.lava_surge.up)", "Cast Lava burst to consume Primordial Wave proc. Wait for Lava Surge proc if possible." );
LavaBurst:Callback("aoe2", function(spell)
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.primordialWave) then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end
    if LavaBurst:Used() < 750 then return end
    if player:BuffRemains(buffs.primordialWave) < 4 or player:Buff(buffs.lavaSurge) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains,if=cooldown_react&buff.lava_surge.up&!buff.master_of_the_elements.up&talent.master_of_the_elements.enabled&talent.fire_elemental.enabled", "{Fire} Use Lava Surge proc to buff <anything> with Master of the Elements." );
LavaBurst:Callback("aoe3", function(spell)
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.lavaSurge) then return end
    if gameState.masterOfTheElements then return end
    if LavaBurst:Used() < 750 then return end
    if not A.MasterOfTheElements:IsTalentLearned() then return end
    if not A.FireElemental:IsTalentLearned() then return end

    return spell:Cast(target)
end)

--aoe->add_action( "earthquake,if=cooldown.primordial_wave.remains<gcd&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)", "Activate Surge of Power if next global is Primordial wave. Respect Echoes of Great Sundering." );
Earthquake:Callback("aoe", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if PrimordialWave:Cooldown() < A.GetGCD() and A.SurgeOfPower:IsTalentLearned() and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("aoe", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if PrimordialWave:Cooldown() < A.GetGCD() and A.SurgeOfPower:IsTalentLearned() and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast()
    end
end)

--aoe->add_action( "earthquake,if=(lightning_rod=0&talent.lightning_rod.enabled|maelstrom>variable.mael_cap-30)&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)", "Spend if all Lightning Rods ran out or you are close to overcaping. Respect Echoes of Great Sundering." );
Earthquake:Callback("aoe2", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (not target:Debuff(debuffs.lightningRod) and A.LightningRod:IsTalentLearned()) or (gameState.maelstrom > (gameState.maelCap - 30) and ((gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)))) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("aoe2", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (not target:Debuff(debuffs.lightningRod) and A.LightningRod:IsTalentLearned()) or (gameState.maelstrom > (gameState.maelCap - 30) and ((gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)))) then
        return spell:Cast()
    end
end)

--aoe->add_action( "earthquake,if=buff.stormkeeper.up&spell_targets.chain_lightning>=6&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)", "Spend to buff your follow-up Stormkeeper with Surge of Power on 6+ targets. Respect Echoes of Great Sundering." );
Earthquake:Callback("aoe3", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if gameState.stormkeeper and activeEnemies() >= 6 and A.SurgeOfPower:IsTalentLearned() and (gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)) then
        return spell:Cast()
    end
end)

--aoe->add_action( "earthquake,if=buff.stormkeeper.up&spell_targets.chain_lightning>=6&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)", "Spend to buff your follow-up Stormkeeper with Surge of Power on 6+ targets. Respect Echoes of Great Sundering." );
EarthquakeT:Callback("aoe3", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if gameState.stormkeeper and activeEnemies() >= 6 and A.SurgeOfPower:IsTalentLearned() and (gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)) then
        return spell:Cast()
    end
end)

--aoe->add_action( "earthquake,if=(buff.master_of_the_elements.up|spell_targets.chain_lightning>=5)&(buff.fusion_of_elements_nature.up|buff.ascendance.remains>9|!buff.ascendance.up)&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)&talent.fire_elemental.enabled", "{Fire} Spend if you have Master of the elements buff or fighting 5+ enemies. Bank maelstrom during the end of Ascendance. Respect Echoes of Great Sundering." );
Earthquake:Callback("aoe4", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.masterOfTheElements or activeEnemies() >= 5) and (player:Buff(buffs.fusionOfElementsNature) or player:BuffRemains(buffs.ascendance) > 9000 or not player:Buff(buffs.ascendance)) and (gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast()
    end
end)

--aoe->add_action( "earthquake,if=(buff.master_of_the_elements.up|spell_targets.chain_lightning>=5)&(buff.fusion_of_elements_nature.up|buff.ascendance.remains>9|!buff.ascendance.up)&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)&talent.fire_elemental.enabled", "{Fire} Spend if you have Master of the elements buff or fighting 5+ enemies. Bank maelstrom during the end of Ascendance. Respect Echoes of Great Sundering." );
EarthquakeT:Callback("aoe4", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.masterOfTheElements or activeEnemies() >= 5) and (player:Buff(buffs.fusionOfElementsNature) or player:BuffRemains(buffs.ascendance) > 9000 or not player:Buff(buffs.ascendance)) and (gameState.echoesOfGreatSundering or not IsPlayerSpell(A.EchoesOfGreatSundering.ID)) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast()
    end
end)

-- aoe->add_action( "elemental_blast,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled&!buff.echoes_of_great_sundering_eb.up&(lightning_rod=0|maelstrom>variable.mael_cap-30)", "Use the talents you selected. Spread Lightning Rod to as many targets as possible." );
ElementalBlast:Callback("aoe", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not gameState.echoesOfGreatSundering and (not target:Debuff(debuffs.lightningRod) or gameState.maelstrom > (gameState.maelCap - 30)) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "earth_shock,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled&!buff.echoes_of_great_sundering_es.up&(lightning_rod=0|maelstrom>variable.mael_cap-30)", "Use the talents you selected. Spread Lightning Rod to as many targets as possible." );
EarthShock:Callback("aoe", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not gameState.echoesOfGreatSundering and (not target:Debuff(debuffs.lightningRod) or gameState.maelstrom > (gameState.maelCap - 30)) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "icefury,if=talent.fusion_of_elements.enabled&!(buff.fusion_of_elements_nature.up|buff.fusion_of_elements_fire.up)", "Use Icefury for Fusion of Elements proc." );
Icefury:Callback("aoe", function(spell)
    if (gameState.activeEnemies or activeEnemies()) > 3 then return end

    if IsPlayerSpell(A.FusionOfElements.ID) and (not player:Buff(buffs.fusionOfElementsNature) or not player:Buff(buffs.fusionOfElementsFire)) then
        return spell:Cast()
    end
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&!buff.ascendance.up&talent.fire_elemental.enabled", "{Fire} Proc Master of the Elements outside Ascendance." );
LavaBurst:Callback("aoe4", function(spell)
    if not gameState.flameShockUp then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end
    if LavaBurst:Used() < 750 then return end
    if IsPlayerSpell(A.MasterOfTheElements.ID) and not gameState.masterOfTheElements and not player:Buff(buffs.ascendance) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_beam,if=buff.stormkeeper.up&(buff.surge_of_power.up|spell_targets.lava_beam<6)", "Stormkeeper is strong and should be used." );
LavaBeam:Callback("aoe2", function(spell)
    if gameState.stormkeeper and (gameState.surgeOfPower or activeEnemies() < 6) then
        return spell:Cast(target)
    end
end)

-- aoe->add_action( "chain_lightning,if=buff.stormkeeper.up&(buff.surge_of_power.up|spell_targets.chain_lightning<6)", "Stormkeeper is strong and should be used." );
ChainLightning:Callback("aoe2", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if gameState.stormkeeper and (gameState.surgeOfPower or activeEnemies() < 6) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_beam,if=buff.power_of_the_maelstrom.up&buff.ascendance.remains>cast_time&!buff.stormkeeper.up", "Power of the Maelstrom is strong and should be used." );
LavaBeam:Callback("aoe3", function(spell)
    if player:Buff(buffs.powerOfTheMaelstrom) and player:BuffRemains(buffs.ascendance) > spell:CastTime() and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

-- aoe->add_action( "chain_lightning,if=buff.power_of_the_maelstrom.up&!buff.stormkeeper.up", "Power of the Maelstrom is strong and should be used." );
ChainLightning:Callback("aoe3", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if player:Buff(buffs.powerOfTheMaelstrom) and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_beam,if=(buff.master_of_the_elements.up&spell_targets.lava_beam>=4|spell_targets.lava_beam>=5)&buff.ascendance.remains>cast_time&!buff.stormkeeper.up", "Consume Master of the Elements with Lava Beam on 4+ targets. Just spam it over hardcasted Lava Burst on 5+ targets." );
LavaBeam:Callback("aoe4", function(spell)
    if gameState.masterOfTheElements and activeEnemies() >= 4 and player:BuffRemains(buffs.ascendance) > spell:CastTime() and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=talent.deeply_rooted_elements.enabled", "Gamble away for Deeply Rooted Elements procs." );
LavaBurst:Callback("aoe5", function(spell)
    if not gameState.flameShockUp then return end
    if IsPlayerSpell(A.DeeplyRootedElements.ID) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_beam,if=buff.ascendance.remains>cast_time" );
LavaBeam:Callback("aoe5", function(spell)
    if player:BuffRemains(buffs.ascendance) > spell:CastTime() then
        return spell:Cast(target)
    end
end)

-- aoe->add_action( "chain_lightning" );
ChainLightning:Callback("aoe4", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    return spell:Cast(target)
end)

--  aoe->add_action( "flame_shock,moving=1,target_if=refreshable" );
FlameShock:Callback("moving", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if player.moving then
        return spell:Cast(target)
    end
end)

--  aoe->add_action( "frost_shock,moving=1" );
FrostShock:Callback("moving", function(spell)
    if player.moving then
        return spell:Cast(target)
    end
end)

--############################################################################# SINGLE TARGET ##########################################################################################################

--Zayose Stormkeeper
Stormkeeper:Callback("fots", function(spell)
    if Action.Zone ~= "arena" then return end
    if not IsPlayerSpell(FuryoftheStorms.id) then return end

    return spell:Cast()
end)

-- single_target->add_action( "liquid_magma_totem,if=!buff.ascendance.up&(talent.fire_elemental.enabled|spell_targets.chain_lightning>1)", "Use LMT outside Ascendance in fire builds and on 2 targets for lightning." );
LiquidMagmaTotem:Callback("st", function(spell)
    if not gameState.cursorCheck then return end
    if not player:Buff(buffs.ascendance) and (IsPlayerSpell(A.FireElemental.ID) or activeEnemies() > 1) then
        return spell:Cast()
    end

end)

--aoe->add_action( "primordial_wave,target_if=min:dot.flame_shock.remains,if=buff.surge_of_power.up|!talent.surge_of_power.enabled|maelstrom<60-5*talent.eye_of_the_storm.enabled", "Spread Flame Shock via Primordial Wave using Surge of Power if possible." );
PrimordialWave:Callback("st", function(spell)
    if (target:DebuffRemains(debuffs.flameShock, true) < 2000 or gameState.flameShockTotal >= 2) and (gameState.surgeOfPower or not A.SurgeOfPower:IsTalentLearned() or gameState.maelstrom < 60 - (5 * num(A.EyeOfTheStorm:IsTalentLearned()))) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "primordial_wave,target_if=min:dot.flame_shock.remains,if=spell_targets.chain_lightning=1|buff.surge_of_power.up|!talent.surge_of_power.enabled|maelstrom<60-5*talent.eye_of_the_storm.enabled|talent.liquid_magma_totem.enabled", "Use Primordial Wave as much as possible. Buff with Surge of power on 2 targets if not playing LMT." );
--PrimordialWave:Callback("st", function(spell)
--    if activeEnemies() == 1 or gameState.surgeOfPower or not A.SurgeOfPower:IsTalentLearned() or gameState.maelstrom < 60 - (5 * num(A.EyeOfTheStorm:IsTalentLearned())) or A.LiquidMagmaTotem:IsTalentLearned() then
--        return spell:Cast(target)
--    end
--end)

-- single_target->add_action( "ancestral_swiftness,if=!buff.primordial_wave.up|!buff.stormkeeper.up|!talent.elemental_blast.enabled", "Use Ancestral Swiftness as much as possible. Use on EB instead of LvB where possible." );
AncestralSwiftness:Callback("st", function(spell)
    if not player:Buff(buffs.primordialWave) or not gameState.stormkeeper or not A.ElementalBlast:IsTalentLearned() then
        return spell:Cast()
    end
end)

--single_target->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=active_enemies=1&(dot.flame_shock.remains<2|active_dot.flame_shock=0)&(dot.flame_shock.remains<cooldown.primordial_wave.remains|!talent.primordial_wave.enabled)&(dot.flame_shock.remains<cooldown.liquid_magma_totem.remains|!talent.liquid_magma_totem.enabled)&!buff.surge_of_power.up&talent.fire_elemental.enabled", "{Fire} Manually refresh Flame shock if better options are not available." );

--single_target->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=active_enemies=1&(dot.flame_shock.remains<2|active_dot.flame_shock=0)&(dot.flame_shock.remains<cooldown.primordial_wave.remains|!talent.primordial_wave.enabled)&(dot.flame_shock.remains<cooldown.liquid_magma_totem.remains|!talent.liquid_magma_totem.enabled)&!buff.surge_of_power.up&talent.fire_elemental.enabled", "{Fire} Manually refresh Flame shock if better options are not available." );
FlameShock:Callback("st", function(spell)
    --if activeEnemies() == 1 then
        if target:DebuffRemains(debuffs.flameShock, true) < 2000 and
           (target:DebuffRemains(debuffs.flameShock, true) < PrimordialWave.cd or not A.PrimordialWave:IsTalentLearned()) and
           (target:DebuffRemains(debuffs.flameShock, true) < LiquidMagmaTotem.cd or not A.LiquidMagmaTotem:IsTalentLearned()) and
           not gameState.surgeOfPower and
           IsPlayerSpell(FireElemental.id) then
            return spell:Cast(target)
        end
    --end
end)

--single_target->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=active_dot.flame_shock<active_enemies&spell_targets.chain_lightning>1&(talent.deeply_rooted_elements.enabled|talent.ascendance.enabled|talent.primordial_wave.enabled|talent.searing_flames.enabled|talent.magma_chamber.enabled)&(!buff.surge_of_power.up&buff.stormkeeper.up|!talent.surge_of_power.enabled|cooldown.ascendance.remains=0&talent.ascendance.enabled)&!talent.liquid_magma_totem.enabled", "Use Flame shock without Surge of Power if you can't spread it with SoP because it is going to be used on Stormkeeper or Surge of Power is not talented." );
FlameShock:Callback("st2", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if gameState.flameShockTotal < activeEnemies() and activeEnemies() > 1 and
       (A.DeeplyRootedElements:IsTalentLearned() or
        A.Ascendance:IsTalentLearned() or
        A.PrimordialWave:IsTalentLearned() or
        A.SearingFlames:IsTalentLearned() or
        A.MagmaChamber:IsTalentLearned()) and
       (not gameState.surgeOfPower and gameState.stormkeeper or not A.SurgeOfPower:IsTalentLearned() or Ascendance:Cooldown() == 0 and A.Ascendance:IsTalentLearned()) and
       not A.LiquidMagmaTotem:IsTalentLearned() then
        return spell:Cast(target)
    end
end)
--single_target->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=spell_targets.chain_lightning>1&(talent.deeply_rooted_elements.enabled|talent.ascendance.enabled|talent.primordial_wave.enabled|talent.searing_flames.enabled|talent.magma_chamber.enabled)&(buff.surge_of_power.up&!buff.stormkeeper.up|!talent.surge_of_power.enabled)&dot.flame_shock.remains<6&talent.fire_elemental.enabled,cycle_targets=1", "{Fire} Spread Flame Shock to multiple targets only if talents were selected that benefit from it." );
FlameShock:Callback("st3", function(spell)
    local enemies = activeEnemies()
    if enemies <= 1 then return end

    -- TTK-aware FS cap: trash packs (<15s) cap at 3, otherwise aim for 6 total FS
    local ttk = packTTD()
    local fsCap = (ttk < 15000) and 3 or 6

    local shouldSpread = (gameState.flameShockTotal < math.min(enemies, fsCap))
    if not shouldSpread then return end

    if target:DebuffRemains(debuffs.flameShock, true) < 6000 then
        local lowestFSUnit = gameState.lowestFlameShockUnit
        if lowestFSUnit then
            return spell:Cast(lowestFSUnit)
        else
            return spell:Cast(target)
        end
    end
end)


-- single_target->add_action( "flame_shock,target_if=min:dot.flame_shock.remains,if=active_enemies=1&(dot.flame_shock.remains<2|active_dot.flame_shock=0)&(dot.flame_shock.remains<cooldown.primordial_wave.remains|!talent.primordial_wave.enabled)&(dot.flame_shock.remains<cooldown.liquid_magma_totem.remains|!talent.liquid_magma_totem.enabled)&!buff.surge_of_power.up&talent.fire_elemental.enabled", "{Fire} Manually refresh Flame shock if better options are not available." );
--[[FlameShock:Callback("st", function(spell)
    if activeEnemies() == 1 then
        if (target:DebuffRemains(debuffs.flameShock, true) < 2000 or gameState.flameShockTotal == 0) and
           (target:DebuffRemains(debuffs.flameShock, true) < PrimordialWave.cd or not A.PrimordialWave:IsTalentLearned()) and
           (target:DebuffRemains(debuffs.flameShock, true) < LiquidMagmaTotem.cd or not A.LiquidMagmaTotem:IsTalentLearned()) and
           not gameState.surgeOfPower and
           IsPlayerSpell(FireElemental.id) then
            return spell:Cast(target)
        end
    end

    if (gameState.flameShockTotal == 0 or target:DebuffRemains(debuffs.flameShock, true) < 3500) and activeEnemies() > 1 then
        if (A.DeeplyRootedElements:IsTalentLearned() or
            A.Ascendance:IsTalentLearned() or
            A.PrimordialWave:IsTalentLearned() or
            A.SearingFlames:IsTalentLearned() or
            A.MagmaChamber:IsTalentLearned()) and
           (not gameState.masterOfTheElements and
            (gameState.stormkeeper or Stormkeeper.cd < 300) or
            not A.SurgeOfPower:IsTalentLearned()) then
            return spell:Cast(target)
        end
    end
end)]]

--  single_target->add_action( "tempest,target_if=min:debuff.lightning_rod.remains,if=!buff.arc_discharge.up" );
Tempest:Callback("st", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if not player:Buff(buffs.arcDischarge) then
        return spell:Cast(target)
    end
end)

TempestToo:Callback("st", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if not player:Buff(buffs.arcDischarge) then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "lightning_bolt,if=buff.stormkeeper.up&buff.surge_of_power.up", "Stormkeeper is strong and should be used." );
LightningBolt:Callback("st", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    -- Enforce MoTE before dumping Stormkeeper charges
    if gameState.stormkeeper and A.MasterOfTheElements:IsTalentLearned() and not gameState.masterOfTheElements then return end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    if gameState.stormkeeper and gameState.surgeOfPower then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.stormkeeper.up&!buff.master_of_the_elements.up&!talent.surge_of_power.enabled&talent.master_of_the_elements.enabled", "Buff stormkeeper with MotE when not using Surge of Power." );
LavaBurst:Callback("st", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) < 2000 then return end
    if LavaBurst:Used() < 750 then return end
    -- Ensure MotE before dumping Stormkeeper charges (even with Surge of Power builds)
    if gameState.stormkeeper and A.MasterOfTheElements:IsTalentLearned() and not gameState.masterOfTheElements then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "lightning_bolt,if=buff.stormkeeper.up&!talent.surge_of_power.enabled&(buff.master_of_the_elements.up|!talent.master_of_the_elements.enabled)", "Buff Stormkeeper with at least something if you can." );
LightningBolt:Callback("st2", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    if gameState.stormkeeper and not A.SurgeOfPower:IsTalentLearned() and (gameState.masterOfTheElements or not A.MasterOfTheElements:IsTalentLearned()) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "lightning_bolt,if=buff.surge_of_power.up&!buff.ascendance.up&talent.echo_chamber.enabled", "Surge of Power is strong and should be used." );
LightningBolt:Callback("st3", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    if gameState.surgeOfPower and not player:Buff(buffs.ascendance) and A.EchoChamber:IsTalentLearned() then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "ascendance,if=cooldown.lava_burst.charges_fractional<1.0" );
Ascendance:Callback("st", function(spell)
    if LavaBurst.frac < 1 then
        return spell:Cast()
    end
end) -- unchanged, placeholder

-- single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains,if=cooldown_react&buff.lava_surge.up&talent.fire_elemental.enabled", "{Fire} Lava Surge is neat. Utilize it." );
LavaBurst:Callback("st2", function(spell)
    if not target:Debuff(debuffs.flameShock) then return end
    if LavaBurst:Used() < 750 then return end
    if player:Buff(buffs.lavaSurge) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.primordial_wave.up", "Consume Primordial wave buff." );
LavaBurst:Callback("st3", function(spell)
    if target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    if LavaBurst:Used() < 750 then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end
    if player:Buff(buffs.primordialWave) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "earthquake,if=buff.master_of_the_elements.up&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|spell_targets.chain_lightning>1&!talent.echoes_of_great_sundering.enabled&!talent.elemental_blast.enabled)&(buff.fusion_of_elements_nature.up|maelstrom>variable.mael_cap-15|buff.ascendance.remains>9|!buff.ascendance.up)&talent.fire_elemental.enabled", "{Fire} Spend if you have MotE buff and: not in Ascendance OR Ascendance gona last so long you will need to spend anyway OR nature fusion buff up OR close to maelstrom cap. Respect Echoes of Great Sundering." );
Earthquake:Callback("st", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end
    if gameState.masterOfTheElements and (gameState.echoesOfGreatSundering or (activeEnemies() > 1 and not IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not IsPlayerSpell(A.ElementalBlast.ID)) and (player:Buff(buffs.fusionOfElementsNature) or gameState.maelstrom > (gameState.maelCap - 15) or player:BuffRemains(buffs.ascendance) > 9000 or not player:Buff(buffs.ascendance)))  then
        return spell:Cast()
    end
end)

-- single_target->add_action( "elemental_blast,if=buff.master_of_the_elements.up&(buff.fusion_of_elements_nature.up|buff.fusion_of_elements_fire.up|maelstrom>variable.mael_cap-15|buff.ascendance.remains>6|!buff.ascendance.up)&talent.fire_elemental.enabled", "{Fire} Spend if you have MotE buff and: not in Ascendance OR Ascendance gona last so long you will need to spend anyway OR any fusion buff up OR close to maelstrom cap." );
ElementalBlast:Callback("st", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if gameState.masterOfTheElements and (player:Buff(buffs.fusionOfElementsNature) or player:Buff(buffs.fusionOfElementsFire) or gameState.maelstrom > (gameState.maelCap - 15) or player:BuffRemains(buffs.ascendance) > 6000 or not player:Buff(buffs.ascendance)) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "earth_shock,if=buff.master_of_the_elements.up&(buff.fusion_of_elements_nature.up|maelstrom>variable.mael_cap-15|buff.ascendance.remains>9|!buff.ascendance.up)&talent.fire_elemental.enabled", "{Fire} Spend if you have MotE buff and: not in Ascendance OR Ascendance gona last so long you will need to spend anyway OR nature fusion buff up OR close to maelstrom cap." );
EarthShock:Callback("st", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    if gameState.masterOfTheElements and (player:Buff(buffs.fusionOfElementsNature) or gameState.maelstrom > (gameState.maelCap - 15) or player:BuffRemains(buffs.ascendance) > 9000 or not player:Buff(buffs.ascendance)) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "earthquake,if=(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|spell_targets.chain_lightning>1&!talent.echoes_of_great_sundering.enabled&!talent.elemental_blast.enabled)&(buff.stormkeeper.up|cooldown.primordial_wave.remains<gcd&talent.surge_of_power.enabled&!talent.liquid_magma_totem.enabled)&talent.storm_elemental.enabled", "{Lightning} Spend if Stormkeeper is active OR Pwave is coming next gcd and you arent specced into LMT. Respect Echoes of Great Sundering." );
Earthquake:Callback("st2", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end
    if (gameState.echoesOfGreatSundering or (activeEnemies() > 1 and not IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not IsPlayerSpell(A.ElementalBlast.ID))) and (gameState.stormkeeper or (PrimordialWave:Cooldown() < MakGcd() and A.SurgeOfPower:IsTalentLearned() and not A.LiquidMagmaTotem:IsTalentLearned())) and IsPlayerSpell(A.StormElemental.ID) then
        return spell:Cast()
    end
end)

--single_target->add_action( "elemental_blast,target_if=min:debuff.lightning_rod.remains,if=buff.stormkeeper.up&talent.storm_elemental.enabled", "{Lightning} Spend if Stormkeeper is active. Spread Lightning Rod to as many targets as possible." );
ElementalBlast:Callback("st2", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if gameState.stormkeeper and IsPlayerSpell(A.StormElemental.ID) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "earth_shock,if=((buff.master_of_the_elements.up|lightning_rod=0)&cooldown.stormkeeper.remains>10&(rolling_thunder.next_tick>5|!talent.rolling_thunder.enabled)|buff.stormkeeper.up)&talent.storm_elemental.enabled&spell_targets.chain_lightning=1", "{Lightning}[1t] Spend if you have Master of the Elements buff and Stormkeeper is not coming up soon OR Stormkeeper is active OR Lightning Rod ran out." );
EarthShock:Callback("st2", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    if ((gameState.masterOfTheElements or not target:Debuff(debuffs.lightningRod)) and Stormkeeper.cd > 10000 or gameState.stormkeeper) and IsPlayerSpell(A.StormElemental.ID) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "earth_shock,target_if=min:debuff.lightning_rod.remains,if=(cooldown.primordial_wave.remains<gcd&talent.surge_of_power.enabled&!talent.liquid_magma_totem.enabled|buff.stormkeeper.up)&talent.storm_elemental.enabled&spell_targets.chain_lightning>1&talent.echoes_of_great_sundering.enabled&!buff.echoes_of_great_sundering_es.up", "{Lightning}[2t] Spend if Stormkeeper is active OR Pwave is coming next gcd and you arent specced into LMT. Spread Lightning Rod to as many targets as possible. Use Echoes of Great Sundering." );
EarthShock:Callback("st3", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    if (PrimordialWave:Cooldown() < MakGcd() and A.SurgeOfPower:IsTalentLearned() and (not A.LiquidMagmaTotem:IsTalentLearned() or gameState.stormkeeper)) and IsPlayerSpell(A.StormElemental.ID) and activeEnemies() > 1 and IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not gameState.echoesOfGreatSundering then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "icefury,if=!(buff.fusion_of_elements_nature.up|buff.fusion_of_elements_fire.up)&buff.icefury.stack=2&(talent.fusion_of_elements.enabled|!buff.ascendance.up)", "Don't waste Icefury stacks even during Ascendance." );
Icefury:Callback("st", function(spell)
    if not player:Buff(buffs.fusionOfElementsNature) and not player:Buff(buffs.fusionOfElementsFire) and player:HasBuffCount(buffs.icefuryDmg) >= 2 and (A.FusionOfElements:IsTalentLearned() or not player:Buff(buffs.ascendance)) then
        return spell:Cast()
    end
end)

-- single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.ascendance.up", "Spam Lava burst in Ascendance." );
LavaBurst:Callback("st4", function(spell)
    if target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    if player:Buff(buffs.ascendance) then
        return spell:Cast(target)
    end
end)

-- single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&talent.fire_elemental.enabled", "{Fire} Buff your next <anything> with MotE." );
LavaBurst:Callback("st5", function(spell)
    if target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end
    if LavaBurst:Used() < 750 then return end
    if A.MasterOfTheElements:IsTalentLearned() and not gameState.masterOfTheElements and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.stormkeeper.up&talent.elemental_reverb.enabled&talent.earth_shock.enabled&time<10", "{Farseer/ES} Spend all Lava Burst charges in opener to get one Stormkeeper buffed with Surge of Power." );
LavaBurst:Callback("st6", function(spell)
    if target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    if gameState.stormkeeper and A.ElementalReverb:IsTalentLearned() and A.EarthShock:IsTalentLearned() and player.combatTime < 10 then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "earthquake,if=(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|spell_targets.chain_lightning>1&!talent.echoes_of_great_sundering.enabled&!talent.elemental_blast.enabled)&(maelstrom>variable.mael_cap-35|fight_remains<5)", "Spend if close to overcaping. Respect Echoes of Great Sundering." );
Earthquake:Callback("st3", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end
    if (gameState.echoesOfGreatSundering or (activeEnemies() > 1 and not IsPlayerSpell(A.EchoesOfGreatSundering.ID) and not IsPlayerSpell(A.ElementalBlast.ID)) and gameState.maelstrom > (gameState.maelCap - 35)) then
        return spell:Cast()
    end
end)

--  single_target->add_action( "elemental_blast,target_if=min:debuff.lightning_rod.remains,if=maelstrom>variable.mael_cap-15|fight_remains<5", "Spend if close to overcaping." );
ElementalBlast:Callback("st3", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if gameState.maelstrom > (gameState.maelCap - 15) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "earth_shock,target_if=min:debuff.lightning_rod.remains,if=maelstrom>variable.mael_cap-15|fight_remains<5", "Spend if close to overcaping." );
EarthShock:Callback("st4", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    if gameState.maelstrom > (gameState.maelCap - 15) then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "lightning_bolt,if=buff.surge_of_power.up" );
LightningBolt:Callback("st4", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    if gameState.surgeOfPower then
        return spell:Cast(target)
    end
end)

--single_target->add_action( "icefury,if=!(buff.fusion_of_elements_nature.up|buff.fusion_of_elements_fire.up)", "Use Icefury if you won't overwrite Fusion of Elements buffs." );
Icefury:Callback("st2", function(spell)
    if not player:Buff(buffs.fusionOfElementsNature) and not player:Buff(buffs.fusionOfElementsFire) then
        return spell:Cast()
    end
end)

--single_target->add_action( "frost_shock,if=buff.icefury_dmg.up&(spell_targets.chain_lightning=1|buff.stormkeeper.up&talent.surge_of_power.enabled)", "Use Icefury-buffed Frost Shock against 1 target or if you need to generate for SoP buff on Stormkeeper." );
FrostShock:Callback("st", function(spell)
    if player:Buff(buffs.icefuryDmg) and (activeEnemies() == 1 or A.Zone == "arena" or (gameState.stormkeeper and A.SurgeOfPower:IsTalentLearned())) then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "chain_lightning,if=buff.power_of_the_maelstrom.up&spell_targets.chain_lightning>1&!buff.stormkeeper.up", "Utilize the Power of the Maelstrom buff." );
ChainLightning:Callback("st", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if not gameState.shouldAoE then return end
    if player:Buff(buffs.powerOfTheMaelstrom) and activeEnemies() > 1 and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "lightning_bolt,if=buff.power_of_the_maelstrom.up&!buff.stormkeeper.up", "Utilize the Power of the Maelstrom buff." );
LightningBolt:Callback("st5", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    if player:Buff(buffs.powerOfTheMaelstrom) and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=talent.deeply_rooted_elements.enabled", "Fish for DRE procs." );
LavaBurst:Callback("st7", function(spell)
    if target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    if A.DeeplyRootedElements:IsTalentLearned() then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "chain_lightning,if=spell_targets.chain_lightning>1&!buff.stormkeeper.up", "Casting Chain Lightning at two targets is more efficient than Lightning Bolt." );
ChainLightning:Callback("st2", function(spell)
    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and A.IsInPvP then return end
    if not gameState.shouldAoE then return end
    if activeEnemies() > 1 and not gameState.stormkeeper then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "lightning_bolt", "Filler spell. Always available. Always the bottom line." );
LightningBolt:Callback("st6", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if UnitLevel(player:CallerId()) >= 70 and not player:TalentKnown(ThunderstrikeWard.id) and not gameState.stormkeeper and A.IsInPvP then return end
    return spell:Cast(target)
end)

--  single_target->add_action( "flame_shock,moving=1,target_if=refreshable" );
FlameShock:Callback("st2", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if player.moving then
        return spell:Cast(target)
    end
end)

--  single_target->add_action( "flame_shock,moving=1,if=movement.distance>6" );
-- HRM I DONT GET THIS ONE SKIPPING IT FOR NOW

--  single_target->add_action( "frost_shock,moving=1", "Frost Shock is our movement filler." );
FrostShock:Callback("st2", function(spell)
    if player.moving then
        return spell:Cast(target)
    end
end)

--#################################### OTHERS ######################################################
Icefury:Callback("moving", function(spell)
    --if not A.FrostShock:IsTalentLearned() then return end

    return spell:Cast(target)
end)

LavaBurst:Callback("moving", function(spell)

    return spell:Cast(target)
end)

Earthquake:Callback("moving", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if activeEnemies() == 1 then return end
    if not gameState.shouldAoESpenders then return end
    if not gameState.cursorCheck and IsPlayerSpell(A.Earthquake.ID) then return end

    return spell:Cast(target)
end)

EarthquakeT:Callback("moving", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if activeEnemies() == 1 then return end
    if not gameState.shouldAoESpenders then return end

    return spell:Cast(target)
end)

EarthShock:Callback("moving", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    return spell:Cast(target)
end)

PoisonCleansingTotem:Callback(function(spell)
    local shouldDispel = MakMulti.party:Find(function(unit) return unit.poisoned end)

    if not shouldDispel then return end

    return spell:Cast()
end)

HealingStreamTotem:Callback("normal", function(spell)
    if not IsPlayerSpell(A.HealingStreamTotem.ID) then return end
    if player.hp > 0 and player.hp < 80 then
        return spell:Cast()
    end
end)

--#################################### ARENA SPECIFIC ###############################################

Ascendance:Callback("arena", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not Action.Zone == "arena" then return end
    if not shouldBurst() and not cooldownUsage[2] then return end
    if LavaBurst.frac < 1 then return end
    if not (gameState.flameShockTotal >= 2) then return end
    return spell:Cast()
end)

PrimordialWave:Callback("arena", function(spell)
    if not Action.Zone == "arena" then return end
    if target:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    return spell:Cast(target)
end)

LavaBurst:Callback("arena", function(spell)
    if not Action.Zone == "arena" then return end
    return spell:Cast(target)
end)

HealingStreamTotem:Callback("arena", function(spell)
    if not IsPlayerSpell(A.HealingStreamTotem.ID) then return end
    if party1.exists and party1.hp > 0 and party1.hp < 80 then
        return spell:Cast()
    end

    if party2.exists and party2.hp > 0 and party2.hp < 80 then
        return spell:Cast()
    end

    if player.hp > 0 and player.hp < 80 then
        return spell:Cast()
    end
end)

local testEarthshield = {
    [315315] = true,
    [134134] = true,
    [315314] = true,
    [383648] = true,
    [974] = true,
}

local debuffTest = {
    [153] = true,
    [735134] = true,
    [188389] = true,
    [124025] = true,
}
-----------------------------------------------------------------------------------------------------
------11.0.5 PvE Attempt to not interfere with PvPers------------------------------------------------
Tempest:Callback("fullSend", function(spell)
    if not A.GetToggle(2, "fullSendTempest") then return end
    if not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

TempestToo:Callback("fullSend", function(spell)
    if not A.GetToggle(2, "fullSendTempest") then return end
    if not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

LightningBolt:Callback("fullSend", function(spell)
    if not A.GetToggle(2, "fullSendTempest") then return end
    if not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

Stormkeeper:Callback("aoe-new", function(spell)
    if gameState.stormkeeper then return end
    if player:Buff(buffs.ascendance) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    -- SimC AOE: stormkeeper,if=talent.herald_of_the_storms|cooldown.primordial_wave.remains<gcd|!talent.primordial_wave
    -- Note: herald_of_the_storms not available in this framework; use PWave gating
    if PrimordialWave.cd < A.GetGCD() * 1000 or not player:TalentKnown(PrimordialWave.id) then
        return spell:Cast()
    end
end)

Ascendance:Callback("aoe-new", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    return spell:Cast()
end)

Tempest:Callback("aoe-new", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if suppressAwakeningDump() then return end

    if Player:PrevGCD(1, A.Tempest) then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end

    if player:Buff(buffs.arcDischarge) then return end

    if gameState.surgeOfPower or not player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)
TempestToo:Callback("aoe-new", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end
    if Player:PrevGCD(1, A.Tempest) then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end
    if player:Buff(buffs.arcDischarge) then return end

    if gameState.surgeOfPower or not player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)

ChainLightning:Callback("aoe-new", function(spell)
    -- SimC: Storm Frenzy handling (independent of MotE gating)
    local n = gameState.activeEnemies or activeEnemies()
    if player:HasBuffCount(buffs.stormFrenzy) >= 2 and not player:TalentKnown(SurgeOfPower.id) then
        local sk_factor = (gameState.stormkeeper and 1 or 0) * n * n
        if gameState.maelstrom < (gameState.maelCap - (15 + sk_factor)) then
            return spell:Cast(target)
        end
    end

    -- For SK+SoP dumping, ensure MotE before spending charges
    if gameState.stormkeeper and A.MasterOfTheElements:IsTalentLearned() and not gameState.masterOfTheElements then return end

    if gameState.surgeOfPower and n >= 6 then
        return spell:Cast(target)
    end
end)

LightningBolt:Callback("aoe-new", function(spell)
    -- Use LB with SK+SoP specifically on 2 targets per SimC
    if gameState.stormkeeper and gameState.surgeOfPower and (gameState.activeEnemies == 2) then
        return spell:Cast(target)
    end

    -- SimC: Storm Frenzy 2 targets when not SoP talent and maelstrom below threshold
    local n = gameState.activeEnemies or activeEnemies()
    if player:HasBuffCount(buffs.stormFrenzy) >= 2 and not player:TalentKnown(SurgeOfPower.id) and gameState.stormkeeper and n == 2 then
        local sk_factor = (gameState.stormkeeper and 1 or 0) * n * n
        if gameState.maelstrom < (gameState.maelCap - (15 + sk_factor)) then
            return spell:Cast(target)
        end
    end
end)


--actions.aoe+=/lava_burst,target_if=dot.flame_shock.remains>2,if=buff.primordial_wave.up&(buff.stormkeeper.up&spell_targets.chain_lightning>=6|buff.tempest.up)&maelstrom<60-5*talent.eye_of_the_storm.enabled&talent.surge_of_power.enabled
LavaBurst:Callback("aoe-new", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.primordialWave) then return end
    if not gameState.stormkeeper then return end
    if gameState.maelstrom < 60 - 5 * num(A.EyeOfTheStorm:IsTalentLearned()) then return end
    if not gameState.surgeOfPower then return end
    if gameState.activeEnemies < 6 and not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains>2,if=buff.primordial_wave.up&(buff.primordial_wave.remains<4|buff.lava_surge.up)", "Cast Lava burst to consume Primordial Wave proc. Wait for Lava Surge proc if possible." );
LavaBurst:Callback("aoe2-new", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.primordialWave) then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end

    if player:BuffRemains(buffs.primordialWave) < 4 or player:Buff(buffs.lavaSurge) then
        return spell:Cast(target)
    end
end)

--aoe->add_action( "lava_burst,target_if=dot.flame_shock.remains,if=cooldown_react&buff.lava_surge.up&!buff.master_of_the_elements.up&talent.master_of_the_elements.enabled&talent.fire_elemental.enabled", "{Fire} Use Lava Surge proc to buff <anything> with Master of the Elements." );
LavaBurst:Callback("aoe3-new", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not gameState.flameShockUp then return end
    if not player:Buff(buffs.lavaSurge) then return end
    if gameState.masterOfTheElements then return end
    if not A.MasterOfTheElements:IsTalentLearned() then return end
    if not A.FireElemental:IsTalentLearned() then return end

    return spell:Cast(target)
end)

--actions.aoe+=/elemental_blast,target_if=min:debuff.lightning_rod.remains,if=spell_targets.chain_lightning=2&(maelstrom>variable.mael_cap-30|cooldown.primordial_wave.remains<gcd&talent.surge_of_power.enabled|buff.tempest.up&talent.surge_of_power.enabled)
ElementalBlast:Callback("aoe-new", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if gameState.activeEnemies ~= 2 then return end

    if gameState.maelstrom > gameState.maelCap - 30 or PrimordialWave.cd < A.GetGCD() * 1000 and player:TalentKnown(SurgeOfPower.id) or player:Buff(buffs.tempest) and player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)

--actions.aoe+=/earthquake,if=cooldown.primordial_wave.remains<gcd&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)
Earthquake:Callback("aoe-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if PrimordialWave.cd < A.GetGCD() * 1000 and player:TalentKnown(SurgeOfPower.id) and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("aoe-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if PrimordialWave.cd < A.GetGCD() * 1000 and player:TalentKnown(SurgeOfPower.id) and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast(target)
    end
end)

--actions.aoe+=/earthquake,if=(lightning_rod=0&talent.lightning_rod.enabled|maelstrom>variable.mael_cap-30)&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)
Earthquake:Callback("aoe2-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.rodCount == 0 and player:TalentKnown(LightningRod.id)) or (gameState.maelstrom > (gameState.maelCap - 30) and ((gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)))) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("aoe2-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.rodCount == 0 and player:TalentKnown(LightningRod.id)) or (gameState.maelstrom > (gameState.maelCap - 30) and ((gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)))) then
        return spell:Cast(target)
    end
end)

--actions.aoe+=/earthquake,if=(buff.stormkeeper.up&spell_targets.chain_lightning>=6|buff.tempest.up)&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)
Earthquake:Callback("aoe3-new", function(spell)
    if not player:TalentKnown(SurgeOfPower.id) then return end

    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.stormkeeper and gameState.activeEnemies >= 6 or player:Buff(buffs.tempest)) and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast()
    end
end)

----actions.aoe+=/earthquake,if=(buff.stormkeeper.up&spell_targets.chain_lightning>=6|buff.tempest.up)&talent.surge_of_power.enabled&(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up|!talent.echoes_of_great_sundering.enabled)
EarthquakeT:Callback("aoe3-new", function(spell)
    if not player:TalentKnown(SurgeOfPower.id) then return end

    if gameState.maelstrom < spell:Cost() then return end

    if (gameState.stormkeeper and gameState.activeEnemies >= 6 or player:Buff(buffs.tempest)) and (gameState.echoesOfGreatSundering or not player:TalentKnown(EchoesOfGreatSundering.id)) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/elemental_blast,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled&!buff.echoes_of_great_sundering_eb.up&(lightning_rod=0|maelstrom>variable.mael_cap-30|(buff.stormkeeper.up&spell_targets.chain_lightning>=6|buff.tempest.up)&talent.surge_of_power.enabled)
ElementalBlast:Callback("aoe2-new", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if player:TalentKnown(EchoesOfGreatSundering.id) and not gameState.echoesOfGreatSundering and (gameState.rodCount == 0 or gameState.maelstrom > (gameState.maelCap - 30) or (gameState.stormkeeper and gameState.activeEnemies >= 6 or player:Buff(buffs.tempest)) and player:TalentKnown(SurgeOfPower.id)) then
        return spell:Cast(target)
    end
end)

--actions.aoe+=/earth_shock,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled&!buff.echoes_of_great_sundering_es.up&(lightning_rod=0|maelstrom>variable.mael_cap-30|(buff.stormkeeper.up&spell_targets.chain_lightning>=6|buff.tempest.up)&talent.surge_of_power.enabled)
EarthShock:Callback("aoe-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if player:TalentKnown(EchoesOfGreatSundering.id) and not gameState.echoesOfGreatSundering and (gameState.rodCount == 0 or gameState.maelstrom > (gameState.maelCap - 30) or (gameState.stormkeeper and gameState.activeEnemies >= 6 or player:Buff(buffs.tempest)) and player:TalentKnown(SurgeOfPower.id)) then
        return spell:Cast(target)
    end
end)

LavaBurst:Callback("aoe4-new", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not gameState.flameShockUp then return end
    if gameState.imCasting and gameState.imCasting == LavaBurst.id then return end
    if IsPlayerSpell(A.MasterOfTheElements.ID) and not gameState.masterOfTheElements and not player:Buff(buffs.ascendance) and IsPlayerSpell(A.FireElemental.ID) then
        return spell:Cast(target)
    end
end)

-- aoe->add_action( "chain_lightning" );
ChainLightning:Callback("aoe4-new", function(spell)
    return spell:Cast(target)
end)

--actions.single_target+=/stormkeeper,if=!talent.ascendance.enabled|cooldown.ascendance.remains<gcd|cooldown.ascendance.remains>10
Stormkeeper:Callback("st-new", function(spell)
    if gameState.stormkeeper then return end
    if player.moving and not player:Buff(buffs.spiritwalkersGrace) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    -- SimC: stormkeeper,if=talent.herald_of_the_storms|cooldown.primordial_wave.remains<gcd|!talent.primordial_wave
    -- Note: herald_of_the_storms not available in this framework; use PWave gating
    if PrimordialWave.cd < A.GetGCD() * 1000 or not player:TalentKnown(PrimordialWave.id) then
        return spell:Cast()
    end
end)

--actions.single_target+=/primordial_wave,if=!buff.surge_of_power.up
PrimordialWave:Callback("st-new", function(spell)
    -- Prefer to cast PWave after reaching 1+ FS, but don't delay in ST if long
    if gameState.flameShockTotal == 0 and target:DebuffRemains(debuffs.flameShock) < 2000 then return end
    return spell:Cast(target)
end)


-- single_target->add_action( "ancestral_swiftness,if=!buff.primordial_wave.up|!buff.stormkeeper.up|!talent.elemental_blast.enabled", "Use Ancestral Swiftness as much as possible. Use on EB instead of LvB where possible." );
AncestralSwiftness:Callback("st-new", function(spell)
    -- SimC: Use Ancestral Swiftness as much as possible in ST
    return spell:Cast()
end)

--actions.single_target+=/ascendance, ST gating based on SimC (approximation without special trinket checks)
Ascendance:Callback("st-new", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    -- SimC: prefer aligning away from immediate Primordial Wave; gate if PWave soon
    if player:TalentKnown(PrimordialWave.id) and PrimordialWave.cd <= 25000 then return end

    return spell:Cast()
end)


--actions.single_target+=/tempest,if=buff.surge_of_power.up
Tempest:Callback("st-new", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if suppressAwakeningDump() then return end

    if not gameState.surgeOfPower then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if gameState.imCasting and gameState.imCasting == TempestToo.id then return end
    if gameState.imCasting and gameState.imCasting == LightningBolt.id then return end
    if Player:PrevGCD(1, A.Tempest) then return end

    return spell:Cast(target)
end)

--actions.single_target+=/tempest,if=buff.surge_of_power.up
TempestToo:Callback("st-new", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if suppressAwakeningDump() then return end

    if not gameState.surgeOfPower then return end
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if gameState.imCasting and gameState.imCasting == Tempest.id then return end
    if gameState.imCasting and gameState.imCasting == LightningBolt.id then return end
    if Player:PrevGCD(1, A.Tempest) then return end

    return spell:Cast(target)
end)

--actions.single_target+=/lightning_bolt,if=buff.surge_of_power.up
LightningBolt:Callback("st-new", function(spell)
    if not shouldBurst() then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if suppressAwakeningDump() then return end

    if not gameState.surgeOfPower then return end
    -- If Stormkeeper is up and MoTE is talented, ensure MoTE before spending charges
    if gameState.stormkeeper and A.MasterOfTheElements:IsTalentLearned() and not gameState.masterOfTheElements then return end

    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if gameState.imCasting and gameState.imCasting == Tempest.id then return end
    if gameState.imCasting and gameState.imCasting == TempestToo.id then return end
    if Player:PrevGCD(1, A.Tempest) then return end

    return spell:Cast(target)
end)

--actions.single_target+=/liquid_magma_totem,if=active_dot.flame_shock=0
LiquidMagmaTotem:Callback("st-new", function(spell)
    if not gameState.cursorCheck then return end
    -- SimC ST: Apply/refresh Flame Shock via LMT with specific Farseer gates
    -- 1) No Flame Shock up: cast if no SoP/MotE and not (T31 2pc + Ancestral Swiftness talent)
    if not target:Debuff(debuffs.flameShock, true) and not gameState.surgeOfPower and not gameState.masterOfTheElements and not (T31has2P and A.AncestralSwiftness:IsTalentLearned()) then
        return spell:Cast()
    end
    -- 2) Refreshable FS: cast if not MotE (Call of the Ancestors check unavailable here)
    if target:DebuffRemains(debuffs.flameShock, true) < 6000 and not gameState.masterOfTheElements then
        return spell:Cast()
    end
    -- 3) Use when PWave is far, low maelstrom, no Ascendance or AS up, and no MotE
    if (not player:TalentKnown(PrimordialWave.id) or PrimordialWave.cd > 24000) and not player:Buff(buffs.ascendance) and gameState.maelstrom < (gameState.maelCap - 10) and not player:Buff(buffs.naturesSwiftness) and not gameState.masterOfTheElements then
        return spell:Cast()
    end
end)

--actions.single_target+=/flame_shock,if=(active_dot.flame_shock=0|dot.flame_shock.remains<6)&!buff.surge_of_power.up&!buff.master_of_the_elements.up&!talent.primordial_wave.enabled&!talent.liquid_magma_totem.enabled
FlameShock:Callback("st-new", function(spell)
    -- After Icefury, refresh FS to proc Fusion EB
    if Player:PrevGCD(1, A.Icefury) and A.FusionOfElements:IsTalentLearned() and target:DebuffRemains(debuffs.flameShock, true) < 8000 then
        return spell:Cast(target)
    end

    -- SimC ST: Maintain/apply FS when not up or refreshable, avoiding SoP/MotE windows
    if target:DebuffRemains(debuffs.flameShock, true) < 6000 and not gameState.surgeOfPower and not gameState.masterOfTheElements then
        return spell:Cast(target)
    end
end)

--actions.single_target+=/earthquake,if=(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up)&(maelstrom>variable.mael_cap-15|fight_remains<5)
Earthquake:Callback("st-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end
    -- Strict: never EQ on 1 target
    if activeEnemies() == 1 then return end
    if gameState.echoesOfGreatSundering and gameState.maelstrom > (gameState.maelCap - 15) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("st-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end
    -- Strict: never EQ on 1 target
    if activeEnemies() == 1 then return end

    if gameState.echoesOfGreatSundering and gameState.maelstrom > (gameState.maelCap - 15) then
        return spell:Cast(target)
    end
end)

--actions.single_target+=/elemental_blast,if=maelstrom>variable.mael_cap-15|fight_remains<5
ElementalBlast:Callback("st-new", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    -- SimC ST: Spend near cap or when Master of the Elements is up
    if gameState.maelstrom > (gameState.maelCap - 15) or gameState.masterOfTheElements or target.ttd < 5000 then
        return spell:Cast(target)
    end
end)

--actions.single_target+=/earth_shock,if=maelstrom>variable.mael_cap-15|fight_remains<5
EarthShock:Callback("st-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    -- SimC ST: Spend near cap or when Master of the Elements is up
    if gameState.maelstrom > (gameState.maelCap - 15) or gameState.masterOfTheElements or target.ttd < 5000 then
        return spell:Cast(target)
    end
end)

--actions.single_target+=/icefury,if=!(buff.fusion_of_elements_nature.up|buff.fusion_of_elements_fire.up)
Icefury:Callback("st-new", function(spell)
    if not player:Buff(buffs.fusionOfElementsNature) and not player:Buff(buffs.fusionOfElementsFire) then
        return spell:Cast(target)
    end
end)

-- actions.single_target+=/lava_burst,target_if=dot.flame_shock.remains>2,if=!buff.master_of_the_elements.up
LavaBurst:Callback("st-new", function(spell)
    if target:DebuffRemains(debuffs.flameShock, true) < 2000 then return end
    if gameState.masterOfTheElements then return end

    -- SimC ST: Use LvB to proc MotE under various triggers
    local want = player:Buff(buffs.lavaSurge) or player:Buff(buffs.tempest) or gameState.stormkeeper or (LavaBurst.frac and LavaBurst.frac > 1.8) or (gameState.maelstrom > (gameState.maelCap - 30))
    if want then
        if PrimordialWave.cd > 8000 or not (T31has4P and A.AncestralSwiftness:IsTalentLearned()) then
            return spell:Cast(target)
        end
    end
end)

-- actions.single_target+=/earthquake,if=(buff.echoes_of_great_sundering_es.up|buff.echoes_of_great_sundering_eb.up)&(buff.tempest.up|buff.stormkeeper.up)&talent.surge_of_power.enabled
Earthquake:Callback("st2-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end

    if activeEnemies() == 1 then return end

    if gameState.echoesOfGreatSundering and (player:Buff(buffs.tempest) or gameState.stormkeeper) and player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast()
    end
end)

EarthquakeT:Callback("st2-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end

    if Action.Zone == "arena" then return end
    if not gameState.shouldAoESpenders then return end

    if gameState.echoesOfGreatSundering and (player:Buff(buffs.tempest) or gameState.stormkeeper) and player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)

-- actions.single_target+=/elemental_blast,if=(buff.tempest.up|buff.stormkeeper.up)&talent.surge_of_power.enabled
ElementalBlast:Callback("st2-new", function(spell)
    local ebCost = C_Spell.GetSpellPowerCost(spell.id)[2]
    if gameState.maelstrom < ebCost.cost then return end

    if (player:Buff(buffs.tempest) or gameState.stormkeeper) and player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)
-- actions.single_target+=/earth_shock,if=(buff.tempest.up|buff.stormkeeper.up)&talent.surge_of_power.enabled
EarthShock:Callback("st2-new", function(spell)
    if gameState.maelstrom < spell:Cost() then return end
    if gameState.shouldAoESpenders then return end

    if (player:Buff(buffs.tempest) or gameState.stormkeeper) and player:TalentKnown(SurgeOfPower.id) then
        return spell:Cast(target)
    end
end)
-- actions.single_target+=/tempest
Tempest:Callback("st2-new", function(spell)
    if not shouldBurst() and not A.GetToggle(2, "tempestNothingLeft") then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

TempestToo:Callback("st2-new", function(spell)
    if not shouldBurst() and not A.GetToggle(2, "tempestNothingLeft") then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if not player:Buff(buffs.tempest) then return end

    return spell:Cast(target)
end)

LightningBolt:Callback("st2-new", function(spell)
    if not shouldBurst() and not A.GetToggle(2, "tempestNothingLeft") then
        if player:BuffRemains(buffs.tempest) >= 5000 and player:HasBuffCount(buffs.tempest) <= 1 then return end
    end

    if gameState.imCasting and gameState.imCasting == Tempest.id then return end

    return spell:Cast(target)
end)

FrostShock:Callback("st-new", function(spell)
    if not A.GetToggle(2, "tempestNothingLeft") then
        return spell:Cast(target)
    end
end)

---------

Burrow:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if player.hp > A.GetToggle(2, "burrowHP") then return end

    return spell:Cast()
end)

--###################################################################################################

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    mouseover = MakUnit:new("mouseover")

    local awareAlert = A.GetToggle(2, "makAware")

    if awareAlert[1] and player.inCombat and A.LiquidMagmaTotem:IsTalentLearned() and LiquidMagmaTotem.cd < 2500 then
        if (not player:Buff(buffs.ascendance) and IsPlayerSpell(FireElemental.id)) or gameState.shouldAoE then
            Aware:displayMessage("LIQUID MAGMA TOTEM SOON", "Red", 1)
        end
    end

    local burstStyle = A.GetToggle(2, "burstStyle")
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Last Lava Burst Used: ", LavaBurst:Used())
        MakPrint(2, "Enemy Has Flame Shock For: ", target:HasDeBuffFor(debuffs.flameShock, true))
        MakPrint(3, "Player Has Testing Debuff For: ", player:HasDeBuffFor(194310))
        MakPrint(4, "Player Has Buff From For Test: ", player:HasBuffFromFor(testEarthshield, 1500))
        MakPrint(5, "Enemy Has DeBuff From For Test: ", target:HasDeBuffFromFor(debuffTest, 1500))
        MakPrint(6, "Action Icefury Usable: ", A.Icefury:IsReady("target", nil, nil, nil, true))
        MakPrint(7, "PWave In Flight: ", gameState.pwaveInFlight)
        MakPrint(8, "Maelstrom: ", gameState.maelstrom)
        MakPrint(9, "Maelstrom Cap: ", gameState.maelCap)
        MakPrint(10, "Target TTD: ", target.ttd)
        MakPrint(11, "Should Burst: ", shouldBurst())
        MakPrint(12, "Burst Style TTD: ", burstStyle == "1")
    end

    if A.GetToggle(2, "pauseWhenWolf") and player:Buff(GhostWolf.wowName) then return end
    if Action.Zone ~= "arena" then
        makInterrupt(interrupts)
    end

    if player.channeling then return end

    if Action.Zone == "arena" and A.GetToggle(2, "fakeCasting") then
        -- Don't fake cast when Spiritwalker's Grace is active (can cast while moving)
        if not player:Buff(buffs.spiritwalkersGrace) then
            FakeCasting.gglFakeCast(icon)
        end
    end

    Skyfury()
    Skyfury('pvp')
    FlametongueWeapon()
    ThunderstrikeWard()
    AstralShift()
    HealingStreamTotem("normal")
    LightningShield()
    EarthShield()
    StoneBulwarkTotem()
    EarthElemental()
    PoisonCleansingTotem()
    AncestralGuidance()
    Burrow("pvp")

    if Action.Zone == "arena" then
        GroundingTotem("arena")
        TremorTotem("arena")
        HealingStreamTotem("arena")
    end

	if target.exists and target.canAttack and FlameShock:InRange(target) then
        NaturesSwiftness()
        if shouldBurst() then
            BloodFury()
            Berserking()
            Fireblood()
            AncestralCall()
            BagOfTricks()
        end
        if shouldBurst() then
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
        end
        if not player.inCombat then
            Stormkeeper()
        end
        FireElemental()
        StormElemental()
        Stormkeeper()
        TotemicRecall()
        WindShear("every", target)

        if shouldBurst() then
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = FireElemental.used < 10 or StormElemental.used < 10
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end

        if A.IsInPvP then
            if gameState.shouldAoE and Action.Zone ~= "arena" then
                LiquidMagmaTotem("aoe")
                PrimordialWave("aoe")
                AncestralSwiftness()
                FlameShock("st")
                FlameShock("aoe")
                FlameShock("aoe2")
                FlameShock("aoe3")
                Tempest("aoe")
                TempestToo("aoe")
                Ascendance("aoe")
                LavaBeam("aoe")
                LavaBurst("aoe")
                LavaBurst("aoe2")
                LavaBurst("aoe3")
                Earthquake("aoe")
                EarthquakeT("aoe")
                Earthquake("aoe2")
                EarthquakeT("aoe2")
                Earthquake("aoe3")
                EarthquakeT("aoe3")
                Earthquake("aoe4")
                EarthquakeT("aoe4")
                ElementalBlast("aoe")
                EarthShock("aoe")
                Icefury("aoe")
                LavaBurst("aoe4")
                LavaBeam("aoe2")
                ChainLightning("aoe2")
                LavaBeam("aoe3")
                ChainLightning("aoe3")
                LavaBeam("aoe4")
                LavaBurst("aoe5")
                LavaBeam("aoe5")
                ChainLightning("aoe4")
                LightningBolt("st")
                --FlameShock("aoe2")
                --FrostShock("aoe")
            elseif not player:Debuff(410201) then
                Ascendance("arena")
                Stormkeeper("fots")
                LiquidMagmaTotem("st")
                PrimordialWave("st")
                AncestralSwiftness()
                FlameShock("st")
                FlameShock("st2")
                FlameShock("st3")
                Tempest("st")
                TempestToo("st")
                LightningBolt("st")
                LavaBurst("st")
                LightningBolt("st2")
                LightningBolt("st3")
                Ascendance("st")
                LavaBurst("st2")
                LavaBurst("st3")
                Earthquake("st")
                ElementalBlast("st")
                EarthShock("st")
                Earthquake("st2")
                ElementalBlast("st2")
                EarthShock("st2")
                EarthShock("st3")
                Icefury("st")
                LavaBurst("st4")
                LavaBurst("st5")
                LavaBurst("st6")
                Earthquake("st3")
                ElementalBlast("st3")
                EarthShock("st4")
                LightningBolt("st4")
                Icefury("st2")
                FrostShock("st")
                ChainLightning("st")
                LightningBolt("st5")
                Stormkeeper("nonLightning")
                LavaBurst("st7")
                ChainLightning("st2")
                LightningBolt("st6")
                --FrostShock("st2")
            end
        elseif not A.IsInPvP then
            if gameState.shouldAoE and Action.Zone ~= "arena" then
                LiquidMagmaTotem("V2")
                Tempest("fullSend")
                TempestToo("fullSend")
                LightningBolt("fullSend")
                Stormkeeper("aoe-new")
                PrimordialWave("aoe")
                AncestralSwiftness()
                FlameShock("aoe")
                FlameShock("aoe3")
                Ascendance("aoe-new")
                Tempest("aoe-new")
                TempestToo("aoe-new")
                Earthquake("aoe-new")
                EarthquakeT("aoe-new")
                ChainLightning("aoe-new")
                LavaBurst("aoe-new")
                LavaBurst("aoe2-new")
                LavaBurst("aoe3-new")
                ElementalBlast("aoe-new")
                Earthquake("aoe-new")
                EarthquakeT("aoe-new")
                Earthquake("aoe2-new")
                EarthquakeT("aoe2-new")
                Earthquake("aoe3-new")
                EarthquakeT("aoe3-new")
                ElementalBlast("aoe2-new")
                EarthShock("aoe-new")
                -- ST Spenders with AoE Builders: Use ST spenders when toggle is enabled
                if not gameState.shouldAoESpenders then
                    EarthShock("st-new")
                    EarthShock("st2-new")
                end
                Icefury("aoe")
                LavaBurst("aoe4-new")
                ChainLightning("aoe4-new")
            elseif not player:Debuff(410201) then
                LiquidMagmaTotem("V2")
                Tempest("fullSend")
                TempestToo("fullSend")
                LightningBolt("fullSend")
                Stormkeeper("st-new")
                PrimordialWave("st-new")
                AncestralSwiftness("st-new")
                Ascendance("st-new")
                Tempest("st-new")
                TempestToo("st-new")
                LightningBolt("st-new")
                LiquidMagmaTotem("st-new")
                FlameShock("st-new")
                Earthquake("st-new")
                EarthquakeT("st-new")
                ElementalBlast("st-new")
                EarthShock("st-new")
                Icefury("st-new")
                LavaBurst("st-new")
                Earthquake("st2-new")
                EarthquakeT("st2-new")
                ElementalBlast("st2-new")
                EarthShock("st2-new")
                Tempest("st2-new")
                TempestToo("st2-new")
                LightningBolt("st2-new")
                FrostShock("st-new")
            end
        end

        if not player:Debuff(410201) then
            Icefury("moving")
            LavaBurst("moving")
            Earthquake("moving")
            EarthquakeT("moving")
            EarthShock("moving")
            SpiritwalkersGrace()
            FlameShock("moving") -- identical
            FrostShock("moving") -- identical
        end
    end


	return FrameworkEnd()
end


local HIGH_PRIO_PURGE = {
    [1022] = true,    -- blessingOfProtection
    [342246] = true,  -- alterTime
    [378464] = true,  -- nullifyingShroud
}

local LOW_HEALTH_PURGE = {
    -- (TODO) Purges to be used only on low health targets such as lifebloom, renew, etc.

}

local curseDetectedTime = nil
local delayPassedRC = false
local RC_DELAY_DURATION = 1.5



local function shouldPurgePvP(enemy)
    if Action.Zone ~= "arena" then return false end
    if tempPurgeCheck(enemy, HIGH_PRIO_PURGE, .35) then
        print("High Prio Purge Detected On:", enemy.CallerId())
        return true end

    return false
end

EarthShieldParty:Callback("party", function(spell, friendly)
    if friendly:Buff(buffs.earthShield) then return end
    if friendly:Buff(buffs.earthShieldOrbit) then return end
    if not A.ElementalOrbit:IsTalentLearned() then return end

    if earthShieldCount() > 1 then return end
    if player.combatTime > 0 and friendly.hp > 40 then return end
    if Action.Zone == "arena" then
        if party2.exists then
            if not friendly.isHealer then
                return Debounce("ES", 1500, 5000, spell, friendly)
            end
        else
            return Debounce("ES2", 1500, 5000, spell, friendly)
        end
    else
        if friendly.hp > 0 then
            if friendly.isTank then
                return spell:Cast(friendly)
            end
        end
    end
end)

--[[EarthShield:Callback("party", function(spell, icon, friendly)
    icon = icon or UnleashShield

    -- Debug: Checking if Earth Shield is already on the friendly target
    if friendly:Buff(buffs.earthShield) then
        print("Earth Shield already present on target.")
        return
    end

    if friendly:Buff(buffs.earthShieldOrbit) then
        print("Earth Shield Orbit already present on target.")
        return
    end

    -- Debug: Check if the talent Elemental Orbit is learned
    if not A.ElementalOrbit:IsTalentLearned() then
        print("Elemental Orbit talent not learned.")
        return
    end

    -- Debug: Check if Earth Shield count is greater than 1
    if earthShieldCount() > 1 then
        print("More than 1 Earth Shield active, exiting.")
        return
    end

    -- Debug: Check if player is in combat and if the friendly target's HP is above 40%
    if player.combatTime > 0 and friendly.hp > 40 then
        print("In combat and friendly HP > 40%, exiting.")
        return
    end

    -- Debug: Check if in an arena zone
    if Action.Zone == "arena" then
        print("In arena.")

        -- Debug: Check if party2 exists
        if party2.exists then
            print("Party 2 exists.")

            -- Debug: Check if the friendly target is not a healer
            if not friendly.isHealer then
                print("Friendly target is not a healer, casting Earth Shield.")
                return Debounce("ES", 1500, 5000, spell, friendly)
            end
        else
            print("Party 2 does not exist, casting Earth Shield.")
            return Debounce("ES2", 1500, 5000, spell, friendly)
        end
    else
        -- Debug: Outside of arena, check if the friendly target's HP is greater than 0
        if friendly.hp > 0 then
            print("Friendly HP > 0, checking if they are a tank.")

            -- Debug: Check if the friendly target is a tank
            if friendly.isTank then
                print("Friendly target is a tank, casting Earth Shield.")
                return spell:Cast(friendly, false, icon)
            end
        end
    end

    -- Debug: If the function reaches here, no action was taken
    print("No valid condition met for casting Earth Shield.")
end)]]

CleanseSpirit:Callback("pve", function(spell, friendly)
    local shouldDispel = friendly.cursed

    if not shouldDispel then return end

    return Debounce("cleanse", 350, 1500, spell, player)
end)

Purge:Callback("arena", function(spell, enemy)
    if player:Debuff(410201) then return end
    if not A.Purge:IsTalentLearned() then return end
    if not enemy.exists then return end
    if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end

    return spell:Cast(enemy)
end)

GreaterPurge:Callback("arena", function(spell, enemy)
    if player:Debuff(410201) then return end
    if not A.GreaterPurge:IsTalentLearned() then return end
    if not enemy.exists then return end
    if not enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then return end

    return spell:Cast(enemy)
end)

WindShear:Callback("arena", function(spell, enemy)
    if player:Debuff(410201) then return end
    if enemy:IsKickImmune() then return end
    if player:Buff(buffs.grounding) then return end
    if not enemy.exists then return end
    if enemy:BuffFrom(MakLists.KickImmune) then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 630) then return end

    return spell:Cast(enemy)
end)

FlameShock:Callback("arena", function (spell, enemy)
    if player:Debuff(410201) then return end
    if not enemy.exists then return end
    if enemy:DebuffRemains(debuffs.flameShock, true) > 2000 then return end
    if enemy.ccRemains > 0 then return end

    return spell:Cast(enemy)
end)

Hex:Callback("arena", function(spell, enemy)
    if player:Debuff(410201) then return end
    if enemy:IsCCImmune() then return end
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
    if enemy.incapacitateDr < 0.25 then return end

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

-- Bloodlust when we have ascendance up on party1 or party2 if they are a dps or if no friendly healer exists on either one of them
BloodlustShamanism:Callback("party", function(spell, friendly)
    if not friendly.exists then return end
    if friendly.distance >= 35 then return end
    if not player:Buff(buffs.ascendance) and not player:Buff(buffs.primordialWave) then return end
    if healer.exists and friendly:IsUnit(healer) then return end

    return spell:Cast(friendly)
end)

HeroismShamanism:Callback("party", function(spell, friendly)
    if not friendly.exists then return end
    if friendly.distance >= 35 then return end
    if not player:Buff(buffs.ascendance) and not player:Buff(buffs.primordialWave) then return end
    if healer.exists and friendly:IsUnit(healer) then return end

    return spell:Cast(friendly)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    if Unit(enemy:CallerId()):InLOS() then return end

    Purge("arena", enemy)
    GreaterPurge("arena", enemy)
    WindShear("arena", enemy)
    Hex("arena", enemy)
    FlameShock("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end
    BloodlustShamanism("party", friendly)
    HeroismShamanism("party", friendly)
    EarthShieldParty("party", friendly)
end

local partyRotationPvE = function(friendly)
    if not friendly.exists then return end

    CleanseSpirit("pve", friendly)
end

local function arenaCastingDanger()
    local arenaEnemies = {arena1, arena2, arena3}
    for _, enemy in pairs(arenaEnemies) do
        local castInfo = enemy.castOrChannelInfo
        if enemy.exists and enemy:CastingFromFor(MakLists.arenaGrounding, 420) then
            return true
        end
    end
    return false
end

local stopCastingList = {
    [51514] = true, -- Hex
}

A[6] = function(icon)
	RegisterIcon(icon)

    --Zayose stop casting suggestions
    if player.casting then
        -- Stop casting if grounding totem is active, but allow Stormkeeper to cast through it
        local currentCastInfo = player.castOrChannelInfo
        local currentCastId = currentCastInfo and currentCastInfo.spellId
        if target:HasBuff(8178) and currentCastId ~= 191634 then StopCasting() end

        if arenaCastingDanger() and GroundingTotem:Cooldown() < 500 then StopCasting() end
        if player:CastingFromFor(stopCastingList, 420) and enemyHealer.exists and (enemyHealer:IsCCImmune() or enemyHealer:IsTotalImmune() or enemyHealer:IsMagicImmune()) then StopCasting() end
        if player:CastingFromFor(stopCastingList, 420) and enemyHealer.exists and enemyHealer.incapacitateDr == 0.25 and target.exists and target.hp > 50 then StopCasting() end
        if healer.exists and healer:HasDeBuffFromFor(MakLists.feared, 420) and TremorTotem:IsTalentLearned() and TremorTotem:Cooldown() < 500 then StopCasting() end
    end


    partyRotationPvE(party1)

    if Action.Zone == "arena" then
        partyRotation(party1)
        enemyRotation(arena1)
    else
        if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
        if autoTarget() then return TabTarget() end
    end
	return FrameworkEnd()
end

A[7] = function(icon)
	RegisterIcon(icon)

    partyRotationPvE(party2)

    if Action.Zone == "arena" then
        partyRotation(party2)
        enemyRotation(arena2)
    end
	return FrameworkEnd()
end

A[8] = function(icon)
	RegisterIcon(icon)

    partyRotationPvE(party3)

    if Action.Zone == "arena" then
        partyRotation(party3)
        enemyRotation(arena3)
    end
	return FrameworkEnd()
end

A[9] = function(icon)
	RegisterIcon(icon)

    partyRotationPvE(party4)

    if Action.Zone == "arena" then
        partyRotation(MakUnit:new("party4"))
        enemyRotation(MakUnit:new("arena4"))
    end
	return FrameworkEnd()
end

A[10] = function(icon)
	RegisterIcon(icon)

    partyRotationPvE(player)

    if Action.Zone == "arena" then
        partyRotation(player)
        enemyRotation(MakUnit:new("arena5"))
    end
	return FrameworkEnd()
end
