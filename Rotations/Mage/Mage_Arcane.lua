if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 62 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local cacheContext     = MakuluFramework.Cache
local Debounce         = MakuluFramework.debounceSpell
local ConstUnit        = MakuluFramework.ConstUnits

local Aware            = MakuluFramework.MakuluAware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

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

    AlterTime           = { ID = 342245, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast !Alter Time" },
    ArcaneBarrage       = { ID = 44425, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneBlast         = { ID = 30451, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneExplosion     = { ID = 1449, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneIntellect     = { ID = 1459, MAKULU_INFO = { ignoreCasting = true } },
    ArcaneMissiles      = { ID = 5143, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneOrb           = { ID = 153626, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneSurge         = { ID = 365350, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true } },
    BlastWave           = { ID = 157981, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Blink               = { ID = 1953, MAKULU_INFO = { ignoreCasting = true } },
    ConeOfCold          = { ID = 120, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Counterspell        = { ID = 2139, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Displacement        = { ID = 389713, MAKULU_INFO = { ignoreCasting = true } },
    DragonsBreath       = { ID = 31661, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Evocation           = { ID = 12051, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true } },
    FireBlast           = { ID = 108853, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FrostNova           = { ID = 122, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Frostbolt           = { ID = 116, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    GravityLapse        = { ID = 449700, FixedTexture = 134153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    GreaterInvisibility = { ID = 110959, MAKULU_INFO = { ignoreCasting = true } },
    IceBlock            = { ID = 45438, Texture = 43543, MAKULU_INFO = { ignoreCasting = true } },
    IceCold             = { ID = 414658, Texture = 43543, MAKULU_INFO = { ignoreCasting = true } },
    IceFloes            = { ID = 108839, MAKULU_INFO = { ignoreCasting = true }, Macro = "/castsequence reset=1 Ice Floes, Languages" },
    IceNova             = { ID = 157997, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Invisibility        = { ID = 66, MAKULU_INFO = { ignoreCasting = true } },
    MassBarrier         = { ID = 414660, MAKULU_INFO = { ignoreCasting = true } },
    MassInvisibility    = { ID = 414664, MAKULU_INFO = { ignoreCasting = true } },
    MassPolymorph       = { ID = 383121, MAKULU_INFO = { ignoreCasting = true } },
    MirrorImage         = { ID = 55342, MAKULU_INFO = { ignoreCasting = true } },
    Polymorph           = { ID = 118, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PresenceOfMind      = { ID = 205025, ignoreCasting = true },
    PrismaticBarrier    = { ID = 235450, MAKULU_INFO = { ignoreCasting = true } },
    RemoveCurse         = { ID = 475, MAKULU_INFO = { ignoreCasting = true } },

    RingOfFrost         = { ID = 113724, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShiftingPower       = { ID = 382440, FixedTexture = 3636841, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true } },
    Slow                = { ID = 31589, MAKULU_INFO = { ignoreCasting = true } },
    SlowFall            = { ID = 130, MAKULU_INFO = { ignoreCasting = true } },
    Spellsteal          = { ID = 30449, MAKULU_INFO = { ignoreCasting = true } },
    Supernova           = { ID = 157980, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    TimeWarp            = { ID = 80353, MAKULU_INFO = { ignoreCasting = true } },
    TouchOfTheMagi      = { ID = 321507, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true } },

    Arcanosphere   = { ID = 353128, MAKULU_INFO = { ignoreCasting = true } },
    IceWall        = { ID = 352278, MAKULU_INFO = { ignoreCasting = true } },
    Kleptomania    = { ID = 198100, MAKULU_INFO = { ignoreCasting = true } },
    RingOfFire     = { ID = 353082, MAKULU_INFO = { ignoreCasting = true } },
    TemporalShield = { ID = 198111, MAKULU_INFO = { ignoreCasting = true } },

    ArcaneBombardment   = { ID = 384581, Hidden = true },
    ArcaneHarmony       = { ID = 384452, Hidden = true },
    ArcaneTempo         = { ID = 383980, Hidden = true },
    ArcingCleave        = { ID = 231564, Hidden = true },
    Enlightened         = { ID = 321387, Hidden = true },
    GravityLapseTalent  = { ID = 458513, Hidden = true },
    HighVoltage         = { ID = 461248, Hidden = true },
    IceColdTalent       = { ID = 414659, Hidden = true },
    Impetus             = { ID = 383676, Hidden = true },
    MagisSpark          = { ID = 454016, Hidden = true },
    OrbBarrage          = { ID = 384858, Hidden = true },
    Reverberate         = { ID = 281482, Hidden = true },
    ShiftingShards      = { ID = 444675, Hidden = true },
    Slipstream          = { ID = 236457, Hidden = true },
    SplinteringSorcery  = { ID = 443739, Hidden = true },
    UnerringProficiency = { ID = 444974, Hidden = true },

    AlterTimeBack   = { ID = 342247, FixedTexture = 133663, Hidden = false, Macro = "/cast Alter Time" }, -- Universal2
    AlterTimeCancel = { ID = 342247, Hidden = false, FixedTexture = 133667, Macro = "/cancelaura Alter Time" }, -- Universal1
    CancelPoM       = { ID = 116, Hidden = false, FixedTexture = 133658, MAKULU_INFO = { offGcd = true }, Macro = "/cancelaura Presence of Mind" }, -- Universal3
    NetherFlux      = { ID = 461264, FixedTexture = 133653, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true }, Macro = "/cast Nether Flux" }, -- Universal4 /cast Nether Flux

    SpellfireSpheres = { ID = 448601, Hidden = true },

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

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_MAGE_ARCANE] = A

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


local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    prevGCD = nil,
    arcaneCharges = 0,
    npStacks = 0,
    aoeCount = 2,
    opener = false,
    inCombat = false,
    shouldAoE = false,
    activeEnemies = 1,
    generatingSphere = 0,
    gloriousIncandescence = false,
    aethervision = 0,
    aetherAttunement = false,
    arcaneSurge = false,
}

-- Optional set bonus flags (Season 2/3 4pc). You can enable via toggles if detection fails.
local hasSetS2_4pc = false
local hasSetS3_4pc = false


-- Compatibility alias for TellMeWhen snippets that expect 'gs' variable
local gs = gameState

local buffs = {
    arcaneFamiliar = 210126,
    clearcasting = 263725,
    siphonStorm = 384267,
    netherPrecision = 383783,
    intuition = 1223797,
    arcaneSurge = 365362,
    arcaneTempo = 383997,
    presenceOfMind = 205025,
    iceFloes = 108839,
    aetherAttunement = 453601,
    aetherAttunementCount = 458388,
    mirrorImage = 55342,
    unerringProficiency = 444981,
    arcaneHarmony = 384455,
    arcaneSoul = 451038,
    -- Class set 11.2 (The War Within S3) 4pc auras
    spellslinger11_2_4pc = 1235964,
    sunfury11_2_4pc = 1235965,
    burdenOfPower = 451049,
    gloriousIncandescence = 451073,
    generatingSphere = 449400,
    aethervision = 467634,
    leydrinker = 453758,
    incantersFlow = 116267,
}

local debuffs = {
    touchOfTheMagi = 210824,
    dragonsBreath = 31661,
    magisSpark = 453912,
    polymorph = 118,
    netherFlux = 1233452,
    coneOfCold = 212792,
    frostNova = 122,
}

local function num(val)
    if val then return 1 else return 0 end
end

--[[Player:AddTier("Tier31", { 207281, 207279, 207284, 207280, 207282, })
local T31has2P = Player:HasTier("Tier31", 2)
local T31has4P = Player:HasTier("Tier31", 4)]]

local interrupts = {
    { spell = Counterspell }
}

local function updateInterrupts()
    if player:TalentKnown(Supernova.id) then
        if player:TalentKnown(GravityLapseTalent.id) then
            interrupts = {
                { spell = Counterspell },
                { spell = GravityLapse, isCC = true }
            }
        else
            interrupts = {
                { spell = Counterspell },
                { spell = Supernova, isCC = true }
            }
        end
    end

    if player:TalentKnown(DragonsBreath.id) then
        interrupts = {
            { spell = Counterspell },
            { spell = DragonsBreath, isCC = true, distance = 8 }
        }
    end
end

local function shouldBurst()
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
end

local constCell        = cacheContext:getConstCacheCell()

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if Frostbolt:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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


local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 4 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end
        end

        return total
    end)
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15 or player:Buff(buffs.mirrorImage) or player:Buff(buffs.alterTime)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    if player.channeling then return false end
    -- Do not auto-defensive during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge then return false end
    if target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true) then return false end

    return incomingDamage and not defensiveActive()
end

local function missingBuff(spellID)
    if ActionUnit("player"):HasBuffs(spellID) == 0 then
        return true
    end

    for i = 1, 4 do
        local unitID = "party" .. i
        if UnitExists(unitID) and ActionUnit(unitID):HasBuffs(spellID) == 0 and A.SlowFall:IsSpellInRange(unitID) then
            return true
        end
    end
    return false
end

local function arcaneBarrageInFlight()
    local targetRange = ActionUnit("target"):GetRange()
    local projectileSpeed = 20
    local timeSinceLastCast = A.ArcaneBarrage:GetSpellTimeSinceLastCast()

    local travelTime = targetRange / projectileSpeed
    local timeRemaining = travelTime - timeSinceLastCast

    if timeRemaining > 0 then
        return true, timeRemaining * 1000
    else
        return false, 0
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

local function InMelee(unitID)
    return CheckInteractDistance(unitID, 3)
end

local lastUpdateTime = 0
local updateDelay = 0.1
local function updateGameState()
    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gameState.imCastingRemaining = currentCastRemains
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime
    end

    local castingArcaneBlast = gameState.imCasting and gameState.imCasting == ArcaneBlast.id

    updateInterrupts()

    gameState.arcaneCharges = math.min(4, Player:ArcaneCharges() + num(castingArcaneBlast))
    gameState.npStacks = math.max(player:HasBuffCount(buffs.netherPrecision) - (1 * num(castingArcaneBlast)), 0)

    if not gameState.inCombat and player.inCombat then
        gameState.inCombat = true
    elseif gameState.inCombat and not player.inCombat then
        gameState.inCombat = false
    end

    if not gameState.opener and not gameState.inCombat and TouchOfTheMagi:Cooldown() < 300 then
        gameState.opener = true
    elseif gameState.opener and target:Debuff(debuffs.touchOfTheMagi, true) then
        gameState.opener = false
    end

    if not player:TalentKnown(ArcingCleave.id) then
        gameState.aoeCount = 9
    end

    gameState.activeEnemies = activeEnemies()

    gameState.shouldAoE = activeEnemies() >= (gameState.aoeCount + player:TalentKnownInt(Impetus.id)) and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    gameState.dontInterrupt = gameState.imCasting and (gameState.imCasting == Evocation.id or gameState.imCasting == ShiftingPower.id)

    gameState.generatingSphere = player:HasBuffCount(buffs.generatingSphere) + num(castingArcaneBlast)

    gameState.burdenOfPower = (player:Buff(buffs.burdenOfPower) and not castingArcaneBlast) or gameState.generatingSphere == 6

    gameState.gloriousIncandescence = player:Buff(buffs.gloriousIncandescence) or player:Buff(buffs.burdenOfPower) and castingArcaneBlast

    -- Auto-detect simple set bonuses by known buff IDs if available; fallback to user toggles
    hasSetS2_4pc = player:Buff(buffs.spellslinger11_2_4pc) or hasSetS2_4pc or A.GetToggle(2, "arcaneSetS2_4pc")
    hasSetS3_4pc = player:Buff(buffs.sunfury11_2_4pc) or hasSetS3_4pc or A.GetToggle(2, "arcaneSetS3_4pc")


    gameState.aethervision = player:HasBuffCount(buffs.aethervision) + num(castingArcaneBlast and player:Buff(buffs.netherPrecision))

    gameState.arcaneSurge = gameState.imCasting and gameState.imCasting == ArcaneSurge.id or player:Buff(buffs.arcaneSurge)

    local channeling = player.channelInfo
    local usingMissiles = player.channeling and channeling.spellId == ArcaneMissiles.id
    gameState.aetherAttunement = player:Buff(buffs.aetherAttunement) and not usingMissiles or not player:Buff(buffs.aetherAttunement) and not player:Buff(buffs.aetherAttunementCount) and usingMissiles
end

--[[actions=counterspell

actions+=/variable,name=opener,op=set,if=debuff.touch_of_the_magi.up&variable.opener,value=0
actions+=/call_action_list,name=cd_opener
actions+=/call_action_list,name=rotation_aoe,if=active_enemies>=variable.aoe_target_count
actions+=/call_action_list,name=rotation_ss_hv,if=talent.splintering_sorcery&talent.high_voltage
actions+=/call_action_list,name=rotation_default
]]


ArcaneIntellect:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(ArcaneIntellect.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 end)

    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then
        return Debounce("ai", 1000, 2500, spell, player)
    end
end)

IceBlock:Callback(function(spell)
    if player:TalentKnown(IceColdTalent.id) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end

    if player.hp > A.GetToggle(2, "iceBlockHP") then return end
    if not player.inCombat then return end
    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    return spell:Cast()
end)

IceCold:Callback(function(spell)
    if not player:TalentKnown(IceColdTalent.id) then return end

    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end

    if not player.inCombat then return end
    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "iceBlockHP") then
        return spell:Cast()
    end
end)

MassBarrier:Callback(function(spell)
    if A.IsInPvP then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end
    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "massBarrierHP") then
        return spell:Cast()
    end
end)

MirrorImage:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end

    if not player.inCombat then return end
    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    if not shouldDefensive() then return end

    return spell:Cast()
end)

Invisibility:Callback("feign", function(spell)
    if player:TalentKnown(GreaterInvisibility.id) then return end

    if MakMulti.party:Size() < 2 then return end

    if A.GetToggle(2, "feignMechs") then
        if makFeign() then
            return spell:Cast()
        end
    end
end)

GreaterInvisibility:Callback("feign", function(spell)
    if not player:TalentKnown(GreaterInvisibility.id) then return end

    if MakMulti.party:Size() < 2 then return end

    if A.GetToggle(2, "feignMechs") then
        if makFeign() then
            return spell:Cast()
        end
    end
end)

GreaterInvisibility:Callback(function(spell)
    if not player:TalentKnown(GreaterInvisibility.id) then return end

    if MakMulti.party:Size() < 2 then return end

    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[4] then return end

    if not player.inCombat then return end
    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "greaterInvisibilityHP") then
        return spell:Cast()
    end
end)

PrismaticBarrier:Callback(function(spell)
    if A.IsInPvP then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[5] then return end

    if UnitGetTotalAbsorbs("player") > 0 then return end

    if not player.inCombat then
        return spell:Cast()
    end

    -- Avoid using defensives during Arcane Surge or Touch of the Magi windows
    if gameState.arcaneSurge or (target and debuffs and debuffs.touchOfTheMagi and target:Debuff(debuffs.touchOfTheMagi, true)) then return end

    if shouldDefensive() or player.hp <= A.GetToggle(2, "prismaticBarrierHP") then
        return spell:Cast()
    end
end)

-- Trinkets/potions handled inline where needed per SimC guidance


LightsJudgment:Callback(function(spell)
    if gameState.arcaneSurge then return end
    if target:Debuff(debuffs.touchOfTheMagi, true) then return end
    if activeEnemies() < gameState.aoeCount then return end

    return spell:Cast(target)
end)

Berserking:Callback(function(spell)
    if gameState.arcaneSurge or gameState.imCasting and gameState.imCasting == ArcaneSurge.id then
        return spell:Cast()
    end
end)

BloodFury:Callback(function(spell)
    if gameState.arcaneSurge or gameState.imCasting and gameState.imCasting == ArcaneSurge.id then
        return spell:Cast()
    end
end)

Fireblood:Callback(function(spell)
    if gameState.arcaneSurge or gameState.imCasting and gameState.imCasting == ArcaneSurge.id then
        return spell:Cast()
    end
end)

AncestralCall:Callback(function(spell)
    if gameState.arcaneSurge or gameState.imCasting and gameState.imCasting == ArcaneSurge.id then
        return spell:Cast()
    end
end)

local function racials()
    LightsJudgment()
    Berserking()
    BloodFury()
    Fireblood()
    AncestralCall()
end

MirrorImage:Callback("pre", function(spell)
    if player.inCombat and not shouldDefensive() then return end
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 6 then return end
    if MakMulti.party:Size() <= 5 then return end

    return spell:Cast()
end)

Evocation:Callback("pre", function(spell)
    -- Gate pre-pull Evocation behind the Burst toggle and only out of combat
    if not A.BurstIsON("target") then return end
    if player.inCombat then return end

    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 6 then return end

    if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

ArcaneBlast:Callback("pre", function(spell)
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > ArcaneBlast:CastTime() * 1000 then return end
    if player.moving and not player:Buff(buffs.presenceOfMind) and not player:Buff(buffs.iceFloes) then return end
    if player:TalentKnown(Evocation.id) then return end

    return spell:Cast()
end)


TouchOfTheMagi:Callback("cd-opener", function(spell)
 
    if player:TalentKnown(NetherFlux.id) then return end
    
    if (gameState.imCasting and gameState.imCasting == ArcaneSurge.id or Player:PrevGCD(1, A.ArcaneSurge)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return spell:Cast(target)
    end

    if ArcaneSurge.cd > 30000 and gameState.arcaneCharges < 4 and not Player:PrevGCD(1, A.ArcaneBarrage) then
        return spell:Cast(target)
    end

    if not Player:PrevGCD(1, A.ArcaneBarrage) then return end

    local _, abTTH = arcaneBarrageInFlight()
    if abTTH > 500 and MakGcd() > 500 then return end
    if not gameState.arcaneSurge and ArcaneSurge.cd < 30000 then return end

    return spell:Cast(target)
end)

ArcaneBlast:Callback("cd-opener", function(spell)
    if not player:Buff(buffs.presenceOfMind) then return end

    return spell:Cast(target)
end)

ArcaneOrb:Callback("cd-opener", function(spell)
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 1 then return end

    if not player:TalentKnown(HighVoltage.id) then return end
    if spell.frac > 1 and spell.used > 0 and spell.used < 10000 then return end
    if not gameState.opener then return end

    return spell:Cast()
end)

Evocation:Callback("cd-opener", function(spell)
    -- Gate Evocation usage behind Burst toggle
    if not A.BurstIsON("target") then return end

    if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end
    -- SimC: evocation,if=cooldown.arcane_surge.remains<(gcd.max*3)&cooldown.touch_of_the_magi.remains<(gcd.max*5)
    if ArcaneSurge.cd > (A.GetGCD() * 3000) then return end
    if TouchOfTheMagi.cd >= (A.GetGCD() * 5000) then return end

    return spell:Cast()
end)

ArcaneBarrage:Callback("cd-opener", function(spell)
    -- SimC: Barrage before Evocation if Arcane Tempo would fall during the Evocation setup
    -- arcane_barrage,if=buff.arcane_tempo.up&cooldown.evocation.ready&buff.arcane_tempo.remains<gcd.max*5
    if not player:Buff(buffs.arcaneTempo) then return end
    if Evocation:Cooldown() > 0 then return end -- treat as not ready unless CD is 0
    if player:BuffRemains(buffs.arcaneTempo) < (A.GetGCD() * 5000) then
        return spell:Cast(target)
    end
end)
ArcaneMissiles:Callback("cd-opener", function(spell)
    -- SimC-guided: force Missiles immediately after Evocation/Surge opener sequence
    -- Also avoid clipping if Aether Attunement is up (reacting)
    if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end

    local justEvocated = Player:PrevGCD(1, A.Evocation) or Evocation.used < 2500
    local justSurged = Player:PrevGCD(1, A.ArcaneSurge)
    if (not (justEvocated or justSurged or gameState.opener)) then return end
    -- After Evocation specifically, allow Missiles regardless of NP stacks
    if (not justEvocated) and gameState.npStacks > 0 then return end
    if player:Buff(buffs.aetherAttunement) and gameState.shouldAoE then return end

    -- Keep a tiny line_cd to avoid double-queueing in the same instant, but don't block after Evo
    if (not justEvocated) and spell.used > 0 and spell.used < 1000 then return end

    return spell:Cast(target)
end)

ArcaneMissiles:Callback("post-evo", function(spell)
    -- Immediately cast Missiles after Evocation, even while moving
    if player.channeling then return end

    local justEvocated = Player:PrevGCD(1, A.Evocation) or Evocation.used < 3000
    if justEvocated then
        return spell:Cast(target)
    end
end)

ArcaneSurge:Callback("cd-opener", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if TouchOfTheMagi.cd > ArcaneSurge:CastTime() + (A.GetGCD() * 1000 * num(gameState.arcaneCharges == 4)) then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[1] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes.cd < 300 then
            return IceFloes:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

local function cdOpener()
    TouchOfTheMagi("cd-opener")
    ArcaneBlast("cd-opener")
    ArcaneOrb("cd-opener")
    ArcaneBarrage("cd-opener")
    Evocation("cd-opener")
    ArcaneMissiles("cd-opener")
    ArcaneSurge("cd-opener")
    -- Ensure Magi is applied immediately after Surge when appropriate
    TouchOfTheMagi("cd-opener")
end


-- Alternate opener for Sunfury + S3 4pc soul_cd scenario per SimC
ArcaneSurge:Callback("cd-opener-soul", function(spell)
    -- arcane_surge,if=(cooldown.touch_of_the_magi.remains<15)
    if TouchOfTheMagi.cd < 15000 then
        -- Handle Ice Floes for movement like in the standard opener
        local floes = A.GetToggle(2, "floesSelect")
        if player:TalentKnown(IceFloes.id) then
            if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
                return IceFloes:Cast()
            end
        end
        if player.moving and not player:Buff(buffs.iceFloes) then return end
        return spell:Cast(target)
    end
end)

Evocation:Callback("cd-opener-soul", function(spell)
    -- evocation,if=buff.arcane_surge.up&(buff.arcane_surge.remains<=8.5|((buff.glorious_incandescence.up|buff.intuition.react)&buff.arcane_surge.remains<=10))
    if not gameState.arcaneSurge then return end
    local surgeRem = player:BuffRemains(buffs.arcaneSurge)
    if surgeRem <= 8500 or ((player:Buff(buffs.gloriousIncandescence) or player:Buff(buffs.intuition)) and surgeRem <= 10000) then
        if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end
        return spell:Cast()
    end
end)

TouchOfTheMagi:Callback("cd-opener-soul", function(spell)

    if player:TalentKnown(NetherFlux.id) then return end

    -- touch_of_the_magi,if=(buff.arcane_surge.remains<=2.5&prev_gcd.1.arcane_barrage)|(cooldown.evocation.remains>40&cooldown.evocation.remains<60&prev_gcd.1.arcane_barrage)
    local surgeRem = player:BuffRemains(buffs.arcaneSurge)
    if (surgeRem > 0 and surgeRem <= 2500 and Player:PrevGCD(1, A.ArcaneBarrage)) or (Evocation.cd > 40000 and Evocation.cd < 60000 and Player:PrevGCD(1, A.ArcaneBarrage)) then
        return spell:Cast(target)
    end
end)

local function cdOpenerSoul()
    ArcaneSurge("cd-opener-soul")
    Evocation("cd-opener-soul")
    -- Ensure we immediately follow Evocation with Missiles, even while moving
    ArcaneMissiles("post-evo")
    TouchOfTheMagi("cd-opener-soul")
end

ShiftingPower:Callback("ss-st", function(spell)
    -- Allow Shifting Power outside of burst toggles per SimC

    if Player:PrevGCD(1, A.ArcaneBarrage) and player:TalentKnown(ShiftingShards.id) and (gameState.arcaneSurge or target:Debuff(debuffs.touchOfTheMagi, true) or Evocation:Cooldown() < 20000) then
        local floes = A.GetToggle(2, "floesSelect")
        if floes[2] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes.cd < 300 then
            return IceFloes:Cast()
        end
        if not player.moving or player:Buff(buffs.iceFloes) then
            return spell:Cast()
        end
    end

    if gameState.arcaneSurge then return end
    if player:Buff(buffs.siphonStorm) then return end
    if target:Debuff(debuffs.touchOfTheMagi, true) then return end
    if Evocation.cd <= 15000 then return end
    if TouchOfTheMagi.cd <= 10000 then return end



    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[2] and Action.GetToggle(2, "makAwareToggle") then
        if shouldBurst() then
            if (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) then
                if ShiftingPower:Cooldown() < 500 then
                    Aware:displayMessage("Shifting Power Soon! Stand Still", "Blue", 1)
                end
            end
        end
    end

    local floes = A.GetToggle(2, "floesSelect")
    if floes[2] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes:Cooldown() < 300 then
        return IceFloes:Cast()
    end

    return spell:Cast()
end)

PresenceOfMind:Callback("ss-st", function(spell)
    if target:DebuffRemains(debuffs.touchOfTheMagi, true) > A.GetGCD() * 1000 then return end
    if gameState.npStacks == 0 then return end
    if gameState.activeEnemies >= gameState.aoeCount then return end
    if player:TalentKnown(UnerringProficiency.id) then return end

    return spell:Cast()
end)

Supernova:Callback("ss-st", function(spell)
    if target:DebuffRemains(debuffs.touchOfTheMagi, true) > A.GetGCD() * 1000 then return end
    if player:HasBuffCount(buffs.unerringProficiency) ~= 30 then return end

    return spell:Cast(target)
end)

ArcaneBarrage:Callback("ss-st", function(spell)
    -- Prevent Barrage right after Surge until Touch of the Magi is out
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    -- High Voltage clearcasting loop preference: Barrage before Missiles while attuned
    if player:TalentKnown(HighVoltage.id) and player:Buff(buffs.clearcasting) and gameState.aetherAttunement and gameState.arcaneCharges > 1 then
        return spell:Cast(target)
    end

    -- Barrage into Touch if Touch is ready/soon and Surge is 30-75s away (per SimC)
    do
        local abInFlight, abTTH = arcaneBarrageInFlight()
        local travelMs = (abInFlight and abTTH) or 0
        local touchSoon = TouchOfTheMagi.cd == 0 or TouchOfTheMagi.cd < math.max(travelMs + 50, A.GetGCD() * 1000)
        if touchSoon and ArcaneSurge.cd > 30000 and ArcaneSurge.cd < 75000 then
            return spell:Cast(target)
        end
    end

    -- Pre-Touch pooling and funnel
    if TouchOfTheMagi.cd < 300 and shouldBurst() then
        return spell:Cast(target)
    end

    -- Tempo about to fall
    if player:TalentKnown(ArcaneTempo.id) and player:BuffRemains(buffs.arcaneTempo) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end

    -- Mana emergency ST if Orb about to be available
    if player.manaPct < 10 and not gameState.arcaneSurge and ArcaneOrb:Cooldown() < (A.GetGCD() * 1000) then
        return spell:Cast(target)
    end

    -- Aimed spenders based on Aethervision/Intuition and NP
    if (gameState.aethervision >= 2 or player:Buff(buffs.intuition)) and (gameState.npStacks >= 1 or (target.hp < 35 and player:TalentKnown(ArcaneBombardment.id) and not player:Buff(buffs.clearcasting)) or (player.manaPct < 70 and player:TalentKnown(Enlightened.id) and not player:Buff(buffs.clearcasting) and not gameState.arcaneSurge)) then
        return spell:Cast(target)
    end
    -- Season 3: anticipate Intuition with Harmony stacks at 4 charges
    if hasSetS3_4pc and gameState.arcaneCharges == 4 and player:HasBuffCount(buffs.arcaneHarmony) >= 20 then
        return spell:Cast(target)
    end

    -- Orb Barrage synergy
    if ArcaneOrb.frac >= 1 and gameState.arcaneCharges >= 4 and not player:Buff(buffs.clearcasting) and gameState.npStacks == 0 and player:TalentKnown(OrbBarrage.id) then
        return spell:Cast(target)
    end
end)

ArcaneMissiles:Callback("ss-st", function(spell)
    if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end

    -- SimC: HV refill: missiles if HV and ((cc>1) or (cc and aether_attunement)) and charges < 3
    if player:TalentKnown(HighVoltage.id) then
        local ccStacks = player:HasBuffCount(buffs.clearcasting)
        if (ccStacks > 1 or (ccStacks > 0 and player:Buff(buffs.aetherAttunement))) and gameState.arcaneCharges < 3 then
            return spell:Cast(target)
        end
    end
    -- Spark/Leydrinker activation in ST as well
    if player:Debuff(debuffs.magisSpark) or player:Buff(buffs.leydrinker) then
        if gameState.imCasting and gameState.imCasting ~= spell.id or not gameState.imCasting then
            return spell:Cast(target)
        end
    end

    -- Season 2: spend AA before Touch to avoid munching when S2 4pc is enabled
    if hasSetS2_4pc and player:Buff(buffs.clearcasting) and player:Buff(buffs.aetherAttunement) and TouchOfTheMagi.cd < A.GetGCD()*3000 then
        return spell:Cast(target)
    end


    -- SimC: use CC to maintain NP or avoid capping CC at 3
    if (player:Buff(buffs.clearcasting) and gameState.npStacks == 0) or player:HasBuffCount(buffs.clearcasting) == 3 then
        return spell:Cast(target)
    end
end)

ArcaneExplosion:Callback("ss-st", function(spell)
    -- SimC: In ST, you can use Arcane Explosion for your first 1-2 charges when you have no Clearcasting
    if gameState.activeEnemies == 1 and gameState.arcaneCharges < 2 and player:HasBuffCount(buffs.clearcasting) == 0 then
        return spell:Cast()
    end
end)

ArcaneOrb:Callback("ss-st", function(spell)
    -- SimC: Orb if you need charges or pre-TOtM/Surge usage in ST
    if spell.frac > 1 and spell.used > 0 and spell.used < 2000 then return end

    -- Primary: if you need charges
    if gameState.arcaneCharges < 4 then
        return spell:Cast()
    end

    -- Secondary: ST pre-Touch/Surge or about to overcap charges
    if gameState.activeEnemies == 1 and (TouchOfTheMagi.cd < 6000 or gameState.arcaneSurge or spell.frac > 1.5) then
        return spell:Cast()
    end
end)

ArcaneBlast:Callback("ss-st", function(spell)
    if player.mana - (spell:Cost() * num(gameState.imCasting and gameState.imCasting == spell.id)) < spell:Cost() then return end

    -- Spark/Leydrinker activation for ST
    if player:Debuff(debuffs.magisSpark) or player:Buff(buffs.leydrinker) then
        if gameState.imCasting and gameState.imCasting ~= spell.id or not gameState.imCasting then
            return spell:Cast(target)
        end
    end

    return spell:Cast(target)
end)

ArcaneBarrage:Callback("ss-st2", function(spell)
    -- Prevent Barrage right after Surge until Touch of the Magi is out
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    return spell:Cast(target)
end)

local function ssSt()
    ShiftingPower("ss-st")
    PresenceOfMind("ss-st")
    Supernova("ss-st")
    ArcaneBarrage("ss-st")
    ArcaneMissiles("ss-st")
    ArcaneExplosion("ss-st")
    ArcaneOrb("ss-st")
    ArcaneBlast("ss-st")
    ArcaneBarrage("ss-st2")
end

Supernova:Callback("ss-aoe", function(spell)
    if player:HasBuffCount(buffs.unerringProficiency) ~= 30 then return end

    return spell:Cast(target)
end)

ShiftingPower:Callback("ss-aoe", function(spell)
    -- Allow Shifting Power outside of burst toggles per SimC

    if Player:PrevGCD(1, A.ArcaneBarrage) and player:TalentKnown(ShiftingShards.id) and (gameState.arcaneSurge or target:Debuff(debuffs.touchOfTheMagi, true) or Evocation:Cooldown() < 20000) then
        local floes = A.GetToggle(2, "floesSelect")
        if floes[2] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes.cd < 300 then
            return IceFloes:Cast()
        end
        if not player.moving or player:Buff(buffs.iceFloes) then
            return spell:Cast()
        end
    end

    if gameState.arcaneSurge then return end
    if player:Buff(buffs.siphonStorm) then return end
    if target:Debuff(debuffs.touchOfTheMagi, true) then return end
    if Evocation.cd <= 15000 then return end
    if TouchOfTheMagi.cd <= 10000 then return end

    if target.ttd < 10000 then return end

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[2] and Action.GetToggle(2, "makAwareToggle") then
        if shouldBurst() then
            if (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) then
                if ShiftingPower:Cooldown() < 500 then
                    Aware:displayMessage("Shifting Power Soon! Stand Still", "Blue", 1)
                end
            end
        end
    end

    local floes = A.GetToggle(2, "floesSelect")
    if floes[2] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes:Cooldown() < 300 then
        return IceFloes:Cast()
    end

    return spell:Cast()
end)

ArcaneOrb:Callback("ss-aoe", function(spell)
    if gameState.arcaneCharges >= 3 then return end
    if spell.frac > 1 and spell.used > 0 and spell.used < 2000 then return end

    return spell:Cast()
end)

ArcaneBlast:Callback("ss-aoe", function(spell)
    if player:Debuff(debuffs.magisSpark) or player:Buff(buffs.leydrinker) then
        if gameState.imCasting and gameState.imCasting ~= spell.id or not gameState.imCasting then
            return spell:Cast(target)
        end
    end
end)

ArcaneBarrage:Callback("ss-aoe", function(spell)
    -- Prevent Barrage right after Surge until Touch of the Magi is out
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    if not gameState.aetherAttunement then return end
    if not player:TalentKnown(HighVoltage.id) then return end
    if not player:Buff(buffs.clearcasting) then return end
    if gameState.arcaneCharges <= 1 then return end

    return spell:Cast(target)
end)

ArcaneMissiles:Callback("ss-aoe", function(spell)
    if player.moving and not player:TalentKnown(Slipstream.id) and not player:Buff(buffs.iceFloes) then return end
    if not player:Buff(buffs.clearcasting) then return end

    if player:TalentKnown(HighVoltage.id) and gameState.arcaneCharges < 4 or gameState.npStacks == 0 then
        return spell:Cast(target)
    end
end)

PresenceOfMind:Callback("ss-aoe", function(spell)
    if gameState.arcaneCharges == 3 or gameState.arcaneCharges == 2 then
        return spell:Cast()
    end
end)

ArcaneBarrage:Callback("ss-aoe2", function(spell)
    -- Prevent Barrage right after Surge until Touch of the Magi is out
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    if gameState.arcaneCharges < 4 then return end

    return spell:Cast(target)
end)

ArcaneExplosion:Callback("ss-aoe", function(spell)
    if enemiesInMelee() < gameState.aoeCount then return end

    if player:TalentKnown(Reverberate.id) or gameState.arcaneCharges < 1 then
        return spell:Cast()
    end
end)

ArcaneBlast:Callback("ss-aoe2", function(spell)

    return spell:Cast(target)
end)

ArcaneBarrage:Callback("ss-aoe3", function(spell)
    -- Prevent Barrage right after Surge until Touch of the Magi is out
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    return spell:Cast(target)
end)

local function ssAoE()
    Supernova("ss-aoe")
    ShiftingPower("ss-aoe")
    ArcaneOrb("ss-aoe")
    ArcaneBlast("ss-aoe")
    ArcaneBarrage("ss-aoe")
    ArcaneMissiles("ss-aoe")
    PresenceOfMind("ss-aoe")
    ArcaneBarrage("ss-aoe2")
    ArcaneExplosion("ss-aoe")
    ArcaneBlast("ss-aoe2")
    ArcaneBarrage("ss-aoe3")
end

ShiftingPower:Callback("sunfury", function(spell)
    if gameState.arcaneSurge then return end
    if player:Buff(buffs.siphonStorm) then return end
    if target:Debuff(debuffs.touchOfTheMagi, true) then return end
    if Evocation.cd < 15000 then return end
    if TouchOfTheMagi.cd < 10000 then return end
    if player:Buff(buffs.arcaneSoul) then return end


    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[2] and Action.GetToggle(2, "makAwareToggle") then
        if shouldBurst() then
            if (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) then
                if ShiftingPower:Cooldown() < 500 then
                    Aware:displayMessage("Shifting Power Soon! Stand Still", "Blue", 1)
                end
            end
        end
    end

    local floes = A.GetToggle(2, "floesSelect")
    if floes[2] and not player:Buff(buffs.iceFloes) and player:TalentKnown(IceFloes.id) and IceFloes.cd < 300 then
        return IceFloes:Cast()
    end

    return spell:Cast()
end)

PresenceOfMind:Callback("sunfury", function(spell)
    if target:DebuffRemains(debuffs.touchOfTheMagi, true) > A.GetGCD() * 1000 then return end
    if gameState.npStacks == 0 then return end
    if gameState.activeEnemies >= 4 then return end

    return spell:Cast()
end)

ArcaneBarrage:Callback("sunfury", function(spell)
    -- Arcane Soul window: Barrage while Nether Precision >= 1; otherwise allow Missiles to handle NP == 0
    if player:Buff(buffs.arcaneSoul) then
        if gameState.npStacks >= 1 then
            return spell:Cast(target)
        else
            return
        end
    end

    if gameState.arcaneCharges == 4 and not gameState.burdenOfPower and gameState.npStacks > 0 and gameState.activeEnemies > 2 and ((player:TalentKnown(ArcaneBombardment.id) and target.hp < 35) or gameState.activeEnemies > 4) and player:TalentKnown(ArcingCleave.id) and ((player:TalentKnown(HighVoltage.id) and player:Buff(buffs.clearcasting)) or ArcaneOrb.frac >= 0.9) then
        return spell:Cast(target)
    end

    if gameState.aetherAttunement and player:TalentKnown(HighVoltage.id) and player:Buff(buffs.clearcasting) and gameState.arcaneCharges > 1 and gameState.activeEnemies > 2 and (target.hp < 35 or not player:TalentKnown(ArcaneBombardment.id) or gameState.activeEnemies > 4) then
        return spell:Cast(target)
    end

    if gameState.activeEnemies > 2 and (gameState.aethervision >= 2 or gameState.gloriousIncandescence or player:Buff(buffs.intuition)) and (gameState.npStacks >= 1 or (target.hp < 35 and player:TalentKnown(ArcaneBombardment.id) and not player:Buff(buffs.clearcasting))) then
        return spell:Cast(target)
    end
end)

ArcaneOrb:Callback("sunfury", function(spell)
    if gameState.arcaneCharges >= 2 then return end
    if player:Buff(buffs.arcaneSoul) then return end
    if spell.frac > 1 and spell.used > 0 and spell.used < 2000 then return end
    if gameState.imCasting and gameState.imCasting == ArcaneSurge.id then return end

    if not player:TalentKnown(HighVoltage.id) or not player:Buff(buffs.clearcasting) then
        return spell:Cast()
    end
end)

ArcaneMissiles:Callback("sunfury", function(spell)
    if gameState.npStacks > 0 then return end
    if not player:Buff(buffs.clearcasting) then return end
    if not player:Buff(buffs.arcaneSoul) then return end
    if player:HasBuffCount(buffs.clearcasting) < 3 then return end

    if player:BuffRemains(buffs.arcaneSoul) > A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

ArcaneBarrage:Callback("sunfury2", function(spell)
    -- Arcane Soul window: Barrage while Nether Precision >= 1; otherwise allow Missiles (NP == 0)
    if player:Buff(buffs.arcaneSoul) then
        if gameState.npStacks >= 1 then
            return spell:Cast(target)
        else
            return
        end
    end

    if (player:Buff(buffs.intuition) or gameState.aethervision >= 2 or gameState.gloriousIncandescence) and (((target.hp < 35 and player:TalentKnown(ArcaneBombardment.id)) or (player.manaPct < 70 and player:TalentKnown(Enlightened.id) and not gameState.arcaneSurge and gameState.activeEnemies < 3)) or gameState.gloriousIncandescence) and (gameState.npStacks > 0 or not player:Buff(buffs.clearcasting)) and (TouchOfTheMagi.cd > 6000 or not shouldBurst()) then
        return spell:Cast(target)
    end

    if gameState.arcaneCharges >= 4 and TouchOfTheMagi.cd < 300 and shouldBurst() then
        return spell:Cast(target)
    end
end)

ArcaneMissiles:Callback("sunfury2", function(spell)
    if not player:Buff(buffs.clearcasting) then return end

    if gameState.npStacks == 0 then
        return spell:Cast(target)
    end

    if player:HasBuffCount(buffs.clearcasting) == 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(HighVoltage.id) and gameState.arcaneCharges < 3 then
        return spell:Cast(target)
    end
end)

PresenceOfMind:Callback("sunfury2", function(spell)
    if gameState.activeEnemies < 3 then return end

    if gameState.arcaneCharges == 3 or gameState.arcaneCharges == 2 then
        return spell:Cast()
    end
end)

ArcaneExplosion:Callback("sunfury", function(spell)
    if enemiesInMelee() < 4 then return end

    if player:TalentKnown(Reverberate.id) or gameState.arcaneCharges < 1 then
        return spell:Cast()
    end
end)

ArcaneBlast:Callback("sunfury", function(spell)
    if player.mana - (spell:Cost() * num(gameState.imCasting and gameState.imCasting == ArcaneBlast.id)) < spell:Cost() then return end

    return spell:Cast(target)
end)

ArcaneBarrage:Callback("sunfury3", function(spell)

    return spell:Cast(target)
end)

local function sunfury()
    ShiftingPower("sunfury")
    PresenceOfMind("sunfury")
    ArcaneBarrage("sunfury")
    ArcaneOrb("sunfury")
    ArcaneMissiles("sunfury")
    ArcaneBarrage("sunfury2")
    ArcaneMissiles("sunfury2")
    PresenceOfMind("sunfury2")
    ArcaneExplosion("sunfury")
    ArcaneBlast("sunfury")
    ArcaneBarrage("sunfury3")
end

ArcaneBarrage:Callback("end", function(spell)
    if ActionUnit("target"):TimeToDie() >= 2 then return end
    if not player.inCombat then return end

    return spell:Cast(target)
end)

ArcaneBarrage:Callback("filler", function(spell)
    if not player.inCombat then return end

    -- Do not Barrage between Surge and ToTM application
    if (Player:PrevGCD(1, A.ArcaneSurge) or (gameState.imCasting and gameState.imCasting == ArcaneSurge.id)) and not target:Debuff(debuffs.touchOfTheMagi, true) then
        return
    end

    -- Prefer Barrage during HV clearcasting attunement loop
    if player:TalentKnown(HighVoltage.id) and player:Buff(buffs.clearcasting) and gameState.aetherAttunement and gameState.arcaneCharges > 1 then
        return spell:Cast(target)
    end

    return spell:Cast(target)
end)

--------------------------------------------------------------------------------------------------------------
-----Dungeon Utility------------------------------------------------------------------------------------------

local dungSpellsteal = {
    [324776] = true, -- Bramblethorn Coat
    [326046] = true, -- Stimulate Resistance
    [431493] = true, -- Darkblade
    [450756] = true, -- Abyssal Howl
    [335141] = true, -- Dark Shroud
    [335142] = true, -- Dark Shroud
    [256957] = true, -- Watertight Shell
    [275826] = true, -- Bolstering Shout
}

local greaterInvis = { -- debuff on player
    [433731] = true, -- Burrow Charge
    [322486] = true, -- Overgrowth
    [322939] = true, -- Harvest Essence
    [451395] = true, -- Corrupt
    [431333] = true, -- Tormenting Beam
    [431365] = true, -- Tormenting Ray
    [338606] = true, -- Morbid Fixation
    [343556] = true, -- Morbid Fixation
    [320596] = true, -- Heaving Retch
    [321894] = true, -- Dark Exile
    [454437] = true, -- Azerite Charge
    [454439] = true, -- Azerite Charge
    [463182] = true, -- Fiery Ricochet
}

local function enemyNeedsSpellsteal(buffList)
    local cacheKey = "enemiesNeedsSpellsteal"

    return constCell:GetOrSet(cacheKey, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if Frostbolt:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if buffList and enemy:BuffFrom(buffList) then
                        return true
                    end
                end
            end
        end

        return false
    end)
end

local function autoTarget()
    if not player.inCombat then return false end
    if A.Zone == "pvp" or A.Zone == "arena" then return false end

    if A.GetToggle(2, "lockTotM") then
        if target:Debuff(debuffs.touchOfTheMagi, true) then return false end
        if enemiesInRange(debuffs.touchOfTheMagi, 1000) >= 1 and not target:Debuff(debuffs.touchOfTheMagi, true) then
            return true
        end
    end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if enemyNeedsSpellsteal(dungSpellsteal) and not target:BuffFrom(dungSpellsteal) then
        return true
    end

    if Frostbolt:InRange(target) and target.exists then return false end

    if enemiesInRange() > 0 then
        return true
    end
end

Spellsteal:Callback("util", function(spell)
    if target:HasBuffFromFor(dungSpellsteal, 1000) then
        return spell:Cast(target)
    end
end)

GreaterInvisibility:Callback("util", function(spell)
    if player:HasDeBuffFromFor(greaterInvis, 600) then
        return spell:Cast()
    end
end)

--[[ Maybe let's not do this just yet. Might need to end up accounting for Poly Variants. It's only one mob, people can mouseover macro themselves for now if they really want to do it.
local dungPolymorph = { -- npcId
    [165251] = true, -- Illusionary Vulpin
},

local function shouldPolymorph(unit)
    local guid = UnitGUID(unit)
    if guid then
        local unit_type = strsplit("-", guid)
        if unit_type == "Creature" or unit_type == "Vehicle" then
            local _, _, _, _, _, npc_id = strsplit("-", guid)
            npc_id = tonumber(npc_id)
            return dungPolymorph[npc_id] or false
        end
    end
    return false
end

Polymorph:Callback("util", function(spell)
    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if target:Debuff(debuffs.polymorph) then return end

    if shouldPolymorph(target:CallerId()) then
        return spell:Cast(target)
    end
end)
]]

MirrorImage:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end

    if player.hp <= A.GetToggle(2, "MirrorImageHP") then
        return spell:Cast()
    end
end)

NetherFlux:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if not player:Buff(buffs.intuition) then return end

    return spell:Cast(target)
end)

PrismaticBarrier:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if player.hp <= A.GetToggle(2, "prismaticBarrierHP") then
        return spell:Cast()
    end
end)

MassBarrier:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if player.hp < A.GetToggle(2, "massBarrierHP") then
        return spell:Cast()
    end
end)

-- Melee CC: Frost Nova
FrostNova:Callback(function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if not target.exists then return end
    if not InMelee(target.id) then return end
    if target:Debuff(debuffs.dragonsBreath) then return end
    if target:Debuff(debuffs.coneOfCold) then return end
    if target:Debuff(debuffs.frostNova) then return end

    return spell:Cast()
end)

-- Melee CC: Cone of Cold
ConeOfCold:Callback(function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if not target.exists then return end
    if not InMelee(target.id) then return end
    if target:Debuff(debuffs.dragonsBreath) then return end
    if target:Debuff(debuffs.coneOfCold) then return end
    if target:Debuff(debuffs.frostNova) then return end

    return spell:Cast()
end)

-- Melee CC: Dragon's Breath
DragonsBreath:Callback(function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end
    if not target.exists then return end
    if not InMelee(target.id) then return end
    if target:Debuff(debuffs.coneOfCold) then return end
    if target:Debuff(debuffs.frostNova) then return end

    return spell:Cast()
end)

-- Alter Time: Use proactively at high health to save your state
AlterTime:Callback(function(spell)
    if not A.IsInPvP then return end
    if not A.GetToggle(2, "alterTimeEnabled") then return end
    if not spell:IsKnown() then return end
    if not player.inCombat then return end
    if player:Buff(buffs.alterTime) then return end

    -- Only use if we're at high health to save a good state
    local alterTimeHP = A.GetToggle(2, "alterTimeHP")
    if player.hp < alterTimeHP then
        return spell:Cast()
    end
end)

-- Alter Time Back: Use when low health to restore to saved state
AlterTimeBack:Callback(function(spell)
    if not A.IsInPvP then return end
    if not A.GetToggle(2, "alterTimeEnabled") then return end
    if not player.inCombat then return end
    if not player:Buff(buffs.alterTime) then return end

    -- Only use if we've dropped to low health
    local alterTimeBackHP = A.GetToggle(2, "alterTimeBackHP")
    if player.hp < alterTimeBackHP then
        return spell:Cast()
    end
end)

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end

	FrameworkStart(icon)
    updateGameState()

    if A.GetToggle(2, "makDebug") then
        local _, abTTH = arcaneBarrageInFlight()
        MakPrint(1, "AB Travel ms: ", math.floor(abTTH))
        MakPrint(2, "Current Mana Percent: ", player.manaPct)
        MakPrint(3, "Arcane Blast Mana Cost: ", ArcaneBlast:Cost())
        MakPrint(4, "Cast Name: ", gameState.imCastingName)
        MakPrint(5, "Sunfury: ", player:TalentKnown(SpellfireSpheres.id))
        MakPrint(6, "Should use opener: ", gameState.opener)
        MakPrint(7, "Should AoE: ", gameState.shouldAoE)
        MakPrint(8, "Active Enemies: ", activeEnemies())
        MakPrint(9, "Incanter's Flow: ", player:HasBuffCount(buffs.incantersFlow))
        MakPrint(10, "Aether Attunement ", gameState.aetherAttunement)
        MakPrint(11, "Aethervision: ", gameState.aethervision)
        MakPrint(12, "Generating Sphere: ", gameState.generatingSphere)
    end

    --[[actions.cd_opener+=/arcane_missiles,if=variable.opener,interrupt_if=!gcd.remains,interrupt_immediate=1,interrupt_global=1,line_cd=10
    actions.rotation_aoe+=/arcane_missiles,if=buff.clearcasting.react&((variable.alt_rotation&buff.arcane_charge.stack<buff.arcane_charge.max_stack)|buff.aether_attunement.up|talent.arcane_harmony)&((variable.alt_rotation&buff.arcane_charge.stack<buff.arcane_charge.max_stack)|!buff.nether_precision.up),interrupt_if=!gcd.remains,interrupt_immediate=1,interrupt_global=1,chain=1
    actions.rotation_default=arcane_missiles,if=buff.clearcasting.react&(buff.nether_precision.down|(buff.clearcasting.stack=3&!talent.splintering_sorcery)|(variable.alt_rotation&buff.nether_precision.stack=1&buff.arcane_charge.stack<4)),interrupt_if=!gcd.remains&(!variable.alt_rotation|buff.arcane_charge.stack=buff.arcane_charge.max_stack),interrupt_immediate=1,interrupt_global=1,chain=1]]

    local awareAlert = A.GetToggle(2, "makAware")
    if awareAlert[1] and Action.GetToggle(2, "makAwareToggle") then
        if player:Buff(buffs.iceFloes) then
            Aware:displayMessage("Ice Floes Up!", "Green", 1)
        end
    end

    if awareAlert[3] and Action.GetToggle(2, "makAwareToggle") then
        if shouldBurst() then
            if player.inCombat and target.canAttack and ArcaneSurge:Cooldown() < 1500 and (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) then
                Aware:displayMessage("Arcane Surge Soon! Stand Still", "Purple", 1)
            end
        end
    end

    local channeling = player.channelInfo
    if player.channeling and channeling.spellId == ArcaneMissiles.id then
        -- Allow clipping in ST; only avoid clipping in AoE during Aether Attunement
        if player:Buff(buffs.aetherAttunement) and gameState.shouldAoE then return end
    end
    -- Do not interrupt a Shifting Power channel with any other action
    if player.channeling and player.channelInfo and player.channelInfo.spellId == ShiftingPower.id then
        return FrameworkEnd()
    end

    Invisibility("feign")
    GreaterInvisibility("feign")
    if makFeign() and player.feigned then return end

    if not gameState.dontInterrupt then
        makInterrupt(interrupts)
    end

    ArcaneIntellect()
    IceBlock()
    MassBarrier()
    IceCold()
    MirrorImage()
    MirrorImage("pvp")
    PrismaticBarrier()
    GreaterInvisibility() -- moved to bottom to allow usage for other specific dungeon mechanics.

    NetherFlux("pvp")
    PrismaticBarrier("pvp")
    MassBarrier("pvp")

    -- Melee CC
    FrostNova()
    ConeOfCold()
    DragonsBreath()
    

    if player:HasBuffCount(buffs.presenceOfMind) == 1 and Player:PrevGCD(1, A.ArcaneBlast) then
        return A.CancelPoM:Show(icon)
    end
    -- Ensure Missiles fire immediately after Evocation, even if Barrage isn't in range
    if target.exists and target.canAttack then
        ArcaneMissiles("post-evo")
    end

    if target.exists and target.canAttack and ArcaneBarrage:InRange(target) and not gameState.dontInterrupt then
        ArcaneBarrage("end")
        MirrorImage("pre")
        Evocation("pre")
        Spellsteal("util")
        -- Immediately follow Evocation with Missiles to avoid delay
        ArcaneMissiles("post-evo")

        GreaterInvisibility("util")

        if shouldBurst() then
            if A.GetToggle(1, "Racial") then
                racials()
            end
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = gameState.arcaneSurge and target:Debuff(debuffs.touchOfTheMagi)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if ArcaneSurge.used < 5000 or (Evocation.used < 5000 and gameState.imCasting ~= Evocation.id) then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
            do
                local soulToggle = A.GetToggle(2, "arcaneSoulCdOpener")
                local useSoul = soulToggle and hasSetS3_4pc and player:TalentKnown(SpellfireSpheres.id) and not player:TalentKnown(MagisSpark.id) and gameState.activeEnemies >= 3
                if player:TalentKnown(SpellfireSpheres.id) and useSoul then
                    cdOpenerSoul()
                else
                    cdOpener()
                end
            end
        end

        if player:TalentKnown(SpellfireSpheres.id) then
            sunfury()
        else
            if gameState.shouldAoE then
                ssAoE()
            else
                ssSt()
            end
        end

        ArcaneBarrage("filler")
    end

	return FrameworkEnd()
end

local pvpSpellsteal = {
    [1022] = true,    -- blessingOfProtection
    [342246] = true,  -- alterTime
    [378464] = true,  -- nullifyingShroud
}

RemoveCurse:Callback("pve", function(spell, friendly)
    local iNeedCleanse = player.cursed
    local shouldDispel = friendly.cursed

    --Hopefully this makes it self prio
    if iNeedCleanse then
        if not friendly.isMe then return end
    end

    if shouldDispel then
        return Debounce("cleanse", 1000, 2500, spell, friendly)
    end
end)

Spellsteal:Callback("arena", function(spell, enemy)
    if not enemy:HasBuffFromFor(pvpSpellsteal, 500) then return end

    return Debounce("spellsteal", 1000, 2500, spell, enemy)
end)

Counterspell:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

local function polymorphDuration()
    local isPolyd = MakMulti.arena:Lowest(function(unit) return unit:DebuffRemains(debuffs.polymorph, true) end)

    if isPolyd then
        return isPolyd:DebuffRemains(debuffs.polymorph, true)
    else
        return 0
    end
end

local polyImmune = {
    642, -- divineShield
    45438,  -- iceBlock
    19263, -- deterrence
    31224,  -- cloakOfShadows
    23545, -- prismatic
    33891, -- Incarn Tree
    117679, -- Incarn Two
    5487, -- Bear Form
    783, -- Travel Form
    768, -- Cat Form
    186265, -- Turtle
}

Polymorph:Callback("arena", function(spell, enemy)
    local ccRemains = 0
    if enemy.cc then
        ccRemains = enemy:CCRemains()
    end

    if player.hp < 30 then return end

    if gameState.imCasting and gameState.imCasting == spell.id then return end
    if enemy:IsTarget() then return end
    if enemy:BuffFrom(polyImmune) then return end
    if polymorphDuration() > Polymorph:CastTime() then return end
    if ccRemains > Polymorph:CastTime() + MakGcd() then return end
    if enemy.incapacitateDr < 0.5 then return end

    if enemy.isHealer and target.hp <= 70 then
        if Action.GetToggle(2, "makAwareToggle") then
            Aware:displayMessage("Polymorph Healer", "Green", 1)
        end
        return spell:Cast(enemy)
    end

    if enemy:Debuff(debuffs.dragonsBreath) and enemy.hp > 70 then
        if Action.GetToggle(2, "makAwareToggle") then
            Aware:displayMessage("Polymorph Dragon's Breath", "Purple", 1)
        end
        return spell:Cast(enemy)
    end

    local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party2.hp > 0 and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        if Action.GetToggle(2, "makAwareToggle") then
            Aware:displayMessage("Polymorph To Peel", "Red", 1)
        end
        return spell:Cast(enemy)
    end

    if enemy.cds and enemy.hp > 40 then
        if Action.GetToggle(2, "makAwareToggle") then
            Aware:displayMessage("Polymorph On Enemy CDs", "Red", 1)
        end
        return spell:Cast(enemy)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    Spellsteal("arena", enemy)
    Counterspell("arena", enemy)
    Polymorph("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end

    RemoveCurse("pve", friendly)
end

A[6] = function(icon)
	RegisterIcon(icon)
    if autoTarget() then return TabTarget() end
    if targetForInterrupt(interrupts) and (not A.GetToggle(2, "lockTotM") or not target:Debuff(debuffs.touchOfTheMagi, true)) then return TabTarget() end
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
