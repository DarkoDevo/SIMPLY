--Test

if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 63 then return end

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
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

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

    -- Spellfire Spheres Hero Talent (Sunfury)
    AlexstraszasFury         = { ID = 235870, Hidden = true },
    AlgariManaPotion         = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },
    AlterTime                = { ID = 342245, Macro = "/cast Alter Time" },
    AlterTimeBack            = { ID = 342247, FixedTexture = 133663, Macro = "/cast Alter Time" }, -- Universal2
    AlterTimeCancel          = { ID = 342247, Hidden = true, FixedTexture = 133667, Macro = "/cancelaura Alter Time" }, -- Universal1
    ArcaneExplosion          = { ID = 1449, MAKULU_INFO = { damageType = "magic" } },
    ArcaneIntellect          = { ID = 1459 },
    ArenaPreparation         = { ID = 32727, Hidden = true },
    BlastWave                = { ID = 157981, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    BlazingBarrier           = { ID = 235313 },
    Blink                    = { ID = 1953 },
    CallOfTheSunKing         = { ID = 343222, Hidden = true },
    Combustion               = { ID = 190319, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true } },
    ConeOfCold               = { ID = 120, MAKULU_INFO = { damageType = "magic" } },
    Counterspell             = { ID = 2139, MAKULU_INFO = { damageType = "magic" } },
    Displacement             = { ID = 389713 },
    DownInFlames             = { ID = 450746, Hidden = true },
    DragonsBreath            = { ID = 31661, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    FeelTheBurn              = { ID = 383391, Hidden = true },
    FireBlast                = { ID = 108853, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true }, Macro = "/castsequence reset=0.5 Fire Blast, Languages" },
    Fireball                 = { ID = 133, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    Firestarter              = { ID = 205026, Hidden = true },
    FlameAccelerant          = { ID = 453282, Hidden = true },
    FlamePatch               = { ID = 205037, Hidden = true },
    Flamestrike              = { ID = 2120, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true  }, Macro = "/cast [@cursor]this:spellID" },
    FrontlinePotion          = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    FrostNova                = { ID = 122, MAKULU_INFO = { damageType = "magic" } },
    Frostbolt                = { ID = 116, Texture = 388882, MAKULU_INFO = { damageType = "magic" } },
    FrostfireBolt            = { ID = 431044, Texture = 157642, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    GloriousIncandescence    = { ID = 451073, Hidden = true },
    GravityLapse             = { ID = 449700, FixedTexture = 134153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    GravityLapseTalent       = { ID = 458513, Hidden = true },

    GreaterInvisibility      = { ID = 110959, MAKULU_INFO = { ignoreCasting = true } },
    GreaterPyroblast         = { ID = 203286 },
    Healthstone              = { Type = "Item", ID = 5512, Hidden = true },
    HyperWrist               = { ID = 1449, Type = "Item", FixedTexture = 133658, Hidden = true, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true, offGcd = true }, Macro = "/use item:168989" }, -- Universal3
    Hyperthermia             = { ID = 383860, Hidden = true },
    IceBlock                 = { ID = 45438 },
    IceCold                  = { ID = 414658 },

    IceColdTalent            = { ID = 414659, Hidden = true },

    IceFloes                 = { ID = 108839, MAKULU_INFO = { offGcd = true, ignoreCasting = true } },
    IceNova                  = { ID = 157997, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    IceWall                  = { ID = 352278 },
    ImprovedScorch           = { ID = 383604, Hidden = true },

    Invisibility             = { ID = 66, MAKULU_INFO = { ignoreCasting = true } },
    IsothermicCore           = { ID = 431095, Hidden = true },
    Kindling                 = { ID = 155148, Hidden = true },
    MarkOfTheFireLord        = { ID = 450325, Hidden = true },
    MassBarrier              = { ID = 414660 },
    MassInvisibility         = { ID = 414664 },
    MassPolymorph            = { ID = 383121 },
    Meteor                   = { ID = 153561, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  }, Macro = "/cast [@cursor]this:spellID" },
    MirrorImage              = { ID = 55342 },
    PhoenixFlames            = { ID = 257541, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PhoenixReborn            = { ID = 453123, Hidden = true },
    Polymorph                = { ID = 118, MAKULU_INFO = { damageType = "magic" } },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    Pyroblast                = { ID = 11366, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true  } },
    Quickflame               = { ID = 450807, Hidden = true },
    RemoveCurse              = { ID = 475 },

    RingOfFire               = { ID = 353082 },
    RingOfFrost              = { ID = 113724, MAKULU_INFO = { damageType = "magic" } },
    Scorch                   = { ID = 2948, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true  } },

    ShiftingPower            = { ID = 382440, FixedTexture = 3636841, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true } },
    Slow                     = { ID = 31589 },
    SlowFall                 = { ID = 130 },
    SpellfireSphere          = { ID = 449400, Hidden = true },

    SpellfireSpheres         = { ID = 448601, Hidden = true },
    Spellsteal               = { ID = 30449 },
    SpontaneousCombustion    = { ID = 451875, Hidden = true },
    SunKingsBlessing         = { ID = 383886, Hidden = true },
    Supernova                = { ID = 157980, FixedTexture = 134153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true  } },
    SynapseEnhancer          = { ID = 1449, Type = "Item", FixedTexture = 133653, Hidden = true, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true, offGcd = true }, Macro = "/use item:168973" }, -- Universal4
    TemperedPotion1          = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2          = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3          = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },

    TimeWarp                 = { ID = 80353 },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_MAGE_FIRE] = A

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
    heatingUp = false,
    hotStreak = false,
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    imCastingLength = nil,
    cursorCheck = false,
    timeToCombustion = 0,
    firestarterCombustion = -1,
    hotStreakFlamestrike = 0,
    hardCastFlamestrike = 0,
    combustionFlamestrike = 0,
    skbFlamestrike = 0,
    arcaneExplosion = 0,
    arcaneExplosionMana = 40,
    combustionShiftingPower = 0,
    combustionCastRemains = 200,
    overpoolFireBlasts = 0,
    skbDuration = 6000,
    combustionOnUse = false,
    onUseCutoff = 0,
    hasBlessing = false,
    hasCombustion = false,
    combustionReadyTime = 0,
    combustionPrecastTime = 0,
    castingPyroblast = false,
    castingFlamestrike = false,
    improvedScorch = false,
    shiftingPowerBeforeCombustion = false,
    fireBlastPooling = false,
    phoenixPooling = false,
    pfInFlight = false,
}

local buffs = {
    heatingUp = 48107,
    hotStreak = 48108,
    sunKingsBlessing = 383882,
    furyOfTheSunKing = 383883,
    hyperthermia = 383874,
    flameAccelerant = 453283,
    feelTheBurn = 383395,
    masterShepherd = 410248,
    alterTime = 342246,
    mirrorImage = 55342,
    heatShimmer = 458964,
    combustion = 190319,
    frostfireEmpowerment = 431177,
    excessFrost = 438611,
    calefaction = 408673,
    flamesFury = 409964,
    iceFloes = 108839,
    -- Spellfire Spheres (Sunfury Hero Talent)
    spellfireSphere = 449400,
    gloriousIncandescence = 451073,
}

local debuffs = {
    ignite = 12654,
    improvedScorch = 383608,
    dragonsBreath = 31661,
    polymorph = 118,
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
        if GravityLapse.cd < 1000 then
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

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength

    return currentCast, currentCastName, remains, length
end

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 8 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end
        end

        return total
    end)
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
                if Pyroblast:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function InMelee(unitID)
    return CheckInteractDistance(unitID, 3)
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15 or player:Buff(buffs.mirrorImage) or player:Buff(buffs.alterTime)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

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

local function isSpellInFlight(spell, speed)
    local casting = gameState.imCasting and gameState.imCasting == spell.id
    local travelTime = (target.distance / speed) * 1000

    if casting then
        return true
    end

    if spell.used > 10000 or spell.used < 0 then
        return false
    end

    if spell.used < travelTime then
        return true
    end

    return false
end

local function guaranteedCrit()
    local firestarterActive = player:TalentKnown(Firestarter.id) and target.exists and target.canAttack and target.hp > 90

    if firestarterActive or player:BuffRemains(buffs.combustion) > MakGcd() or gameState.imCasting and gameState.imCasting == Pyroblast.id and gameState.hasBlessing then
        if gameState.imCasting and (gameState.imCasting == Scorch.spellId or gameState.imCasting == Fireball.spellId or gameState.imCasting == FrostfireBolt.spellId or (gameState.castingPyroblast and (player.combatTime < 2 or gameState.hasBlessing))) then
            return true
        end

        --[[local fireballInFlight = A.Fireball:GetSpellTimeSinceLastCast() > 0 and A.Fireball:GetSpellTimeSinceLastCast() < A.GetGCD() / 1.5
        local frostfireBoltInFlight = A.FrostfireBolt:GetSpellTimeSinceLastCast() > 0 and A.FrostfireBolt:GetSpellTimeSinceLastCast() < A.GetGCD() / 1.5
        local pyroblastInFlight = A.Pyroblast:GetSpellTimeSinceLastCast() > 0 and A.Pyroblast:GetSpellTimeSinceLastCast() < A.GetGCD() / 1.5
        local phoenixFlamesInFlight = A.PhoenixFlames:GetSpellTimeSinceLastCast() > 0 and A.PhoenixFlames:GetSpellTimeSinceLastCast() < A.GetGCD() / 1.5]]

        local fireballInFlight = A.Fireball:IsSpellInFlight() and not player:TalentKnown(FrostfireBolt.id)
        local frostfireBoltInFlight = gameState.frostfireInFlight
        local pyroblastInFlight = A.Pyroblast:IsSpellInFlight() -- Action tracks it better.

        if fireballInFlight or frostfireBoltInFlight or pyroblastInFlight or gameState.pfInFlight then
            return true
        end

    end

    if player:TalentKnown(CallOfTheSunKing.id) and gameState.pfInFlight then
        return true
    end

    if gameState.imCasting then
        if gameState.imCasting == Scorch.id and target.exists and target.canAttack and target.hp < 30 then
            return true
        end
    end

    if shouldBurst() and Combustion.cd < 500 and gameState.imCasting and (gameState.imCasting == Scorch.id or gameState.imCasting == Fireball.id or gameState.imCasting == FrostfireBolt.id) then
        return true
    end

    return false
end

local function guaranteedHeatingUp()
    return not player:Buff(buffs.heatingUp) and not player:Buff(buffs.hotStreak) and guaranteedCrit()
end

local function guaranteedHotStreak()
    return player:Buff(buffs.heatingUp) and guaranteedCrit()
end

----------------------------------

--delay vars
local lastUpdateTime = 0
local updateDelay = 0.4
local function updateGameState()
    --Hot Streak
    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gameState.heatingUp = (player:Buff(buffs.heatingUp) or guaranteedHeatingUp()) and not guaranteedHotStreak()
    gameState.hotStreak = player:Buff(buffs.hotStreak) or guaranteedHotStreak()
    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime
        gameState.pfInFlight = isSpellInFlight(PhoenixFlames, 40)
        gameState.frostfireInFlight = isSpellInFlight(FrostfireBolt, 40)
    end

    updateInterrupts()

    gameState.imCastingRemaining = currentCastRemains
    gameState.imCastingLength = currentCastLength
    gameState.castingPyroblast = gameState.imCasting and gameState.imCasting == Pyroblast.id
    gameState.castingFlamestrike = gameState.imCasting and gameState.imCasting == Flamestrike.id

    local cursorCondition = (Pyroblast:InRange(mouseover) or SlowFall:InRange(mouseover)) and (mouseover.canAttack or mouseover:IsMelee() or mouseover:IsPet())
    gameState.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gameState.improvedScorch = target.exists and target.canAttack and target.hp <= 30 and A.ImprovedScorch:IsTalentLearned() and target:HasDeBuffCount(debuffs.improvedScorch) < 1 + num(gameState.imCasting and gameState.imCasting == Scorch.id)

    if shouldBurst() then
        gameState.combustionReadyTime = Combustion:Cooldown() * (A.Kindling:IsTalentLearned() and 0.4 or 1)
        if A.FrostfireBolt:IsTalentLearned() then
            -- Frostfire Bolt hero talent path
            gameState.combustionPrecastTime = FrostfireBolt:CastTime() * num((activeEnemies() < gameState.ffCombustionFlamestrike)) + Flamestrike:CastTime() * num((activeEnemies() >= gameState.ffCombustionFlamestrike)) - gameState.combustionCastRemains
        elseif A.SpellfireSpheres:IsTalentLearned() then
            -- Spellfire Spheres hero talent path
            local improvedScorchActive = gameState.improvedScorch
            local scorchCastTime = Scorch:CastTime()
            local fireballCastTime = Fireball:CastTime()
            local hotStreakReact = player:Buff(buffs.hotStreak)

            if (scorchCastTime < A.GetGCD() * 1000 and hotStreakReact) or not A.Scorch:IsTalentLearned() then
                gameState.combustionPrecastTime = fireballCastTime
            else
                gameState.combustionPrecastTime = scorchCastTime
            end
            gameState.combustionPrecastTime = gameState.combustionPrecastTime - gameState.combustionCastRemains
        else
            -- Default path
            gameState.combustionPrecastTime = Fireball:CastTime() * num((activeEnemies() < gameState.sfCombustionFlamestrike)) + Flamestrike:CastTime() * num((activeEnemies() >= gameState.sfCombustionFlamestrike)) - gameState.combustionCastRemains
        end

        gameState.timeToCombustion = gameState.combustionReadyTime

        if A.Firestarter:IsTalentLearned() and not gameState.firestarterCombustion then
            gameState.timeToCombustion = 999
        end

        if A.SunKingsBlessing:IsTalentLearned() and A.Firestarter:IsTalentLearned() and target.exists and target.canAttack and target.hp > 90 and not player:Buff(buffs.furyOfTheSunKing) then
            gameState.timeToCombustion = (10 - player:HasBuffCount(buffs.sunKingsBlessing)) * (3000 * A.GetGCD())
        end

        if player:Buff(buffs.combustion) then
            gameState.timeToCombustion = 999
        end

        if gameState.combustionReadyTime + Combustion:Cooldown() * (1-(0.4+0.2*num(A.Firestarter:IsTalentLearned())) * num(A.Kindling:IsTalentLearned())) <= gameState.timeToCombustion then
            gameState.timeToCombustion = gameState.combustionReadyTime
        end

    else gameState.timeToCombustion = 999
    end

    gameState.firestarterCombustion = num(A.SunKingsBlessing:IsTalentLearned())

    gameState.hotStreakFlamestrike = (4 * num(A.Quickflame:IsTalentLearned() or A.FlamePatch:IsTalentLearned())) + (999 * num((not A.FlamePatch:IsTalentLearned() and not A.Quickflame:IsTalentLearned())))

    gameState.hardCastFlamestrike = 999

    -- Frostfire Bolt hero talent variables
    gameState.ffCombustionFlamestrike = 100
    gameState.ffFillerFlamestrike = 100

    -- Spellfire Spheres hero talent variables
    gameState.sfCombustionFlamestrike = 100 - (50 * num(A.MarkOfTheFireLord:IsTalentLearned())) - (44 * num(A.Quickflame:IsTalentLearned()))
    gameState.sfFillerFlamestrike = 100 - (50 * num(A.MarkOfTheFireLord:IsTalentLearned())) - (42 * num(A.Quickflame:IsTalentLearned()))

    -- Legacy variable for backward compatibility
    gameState.combustionFlamestrike = A.FrostfireBolt:IsTalentLearned() and gameState.ffCombustionFlamestrike or gameState.sfCombustionFlamestrike

    gameState.skbFlamestrike = (3 * num((A.FlamePatch:IsTalentLearned() or A.Quickflame:IsTalentLearned()))) + (999 * num((not A.FlamePatch:IsTalentLearned() and not A.Quickflame:IsTalentLearned())))

    gameState.arcaneExplosion = 999

    gameState.combustionShiftingPower = 999

    -- Pooling time for Fire Blast management (15 GCDs as per SimC)
    gameState.poolingTime = 15 * A.GetGCD() * 1000

    gameState.hasBlessing = player:BuffRemains(buffs.furyOfTheSunKing, true) > Pyroblast:CastTime()

    gameState.hasCombustion = player:Buff(buffs.combustion) or (gameState.hasBlessing and (gameState.castingPyroblast or gameState.castingFlamestrike))

    gameState.shiftingPowerBeforeCombustion = gameState.timeToCombustion > ShiftingPower:Cooldown()

    local fireBlastCooldown = FireBlast:Cooldown() > 300 and FireBlast:Cooldown() or 1
    local spellChargesFullRechargeTime = FireBlast:TimeToFullCharges() > 0 and FireBlast:TimeToFullCharges() or 1

    local combustionBuffRemains = player:BuffRemains(buffs.combustion) > 0 and player:BuffRemains(buffs.combustion) or 1

    gameState.fireBlastPooling = not gameState.hasCombustion and
        FireBlast.frac +
        (gameState.timeToCombustion + 12 * num(gameState.shiftingPowerBeforeCombustion)) % fireBlastCooldown - 1000 <
        (spellChargesFullRechargeTime) +
        gameState.overpoolFireBlasts % fireBlastCooldown -
        (combustionBuffRemains % fireBlastCooldown) % 1

    gameState.phoenixPooling = not A.SunKingsBlessing:IsTalentLearned() and (gameState.timeToCombustion + player:BuffRemains(buffs.combustion) - 5000 < PhoenixFlames:TimeToFullCharges() + PhoenixFlames.cd - 12 * num(gameState.shiftingPowerBeforeCombustion)) and not A.AlexstraszasFury:IsTalentLearned()

    gameState.wrists = C_Item.IsEquippedItem(168989)
    local _, wristCooldown = GetItemCooldown(168989)
    gameState.wristNotReady = wristCooldown > 0

    gameState.synapse = C_Item.IsEquippedItem(168973)
    local _, synapseCooldown = GetItemCooldown(168973)
    gameState.synapseNotReady = synapseCooldown > 0
end

ArcaneIntellect:Callback(function(spell)
    if player:Buff(buffs.combustion) then return end
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
    if player:Buff(buffs.alterTime) then return end

    return spell:Cast()
end)

IceCold:Callback(function(spell)
    if not player:TalentKnown(IceColdTalent.id) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "iceBlockHP") then
        return spell:Cast()
    end
end)

MassBarrier:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "massBarrierHP") then
        return spell:Cast()
    end
end)

MirrorImage:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end

    if not player.inCombat then return end

    -- In arena or blitz, use when taking damage at 80% HP
    if A.Zone == "arena" or A.Zone == "pvp" then
        if player.hp <= 80 then
            return spell:Cast(player)
        end
        return
    end

    -- In other content, use normal defensive logic
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

    if shouldDefensive() or player.hp < A.GetToggle(2, "greaterInvisibilityHP") then
        return spell:Cast()
    end
end)

BlazingBarrier:Callback(function(spell)
    if A.IsInPvP then return end
    if player:Buff(buffs.combustion) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[5] then return end

    if UnitGetTotalAbsorbs("player") > 0 then return end

    -- In other content, allow out of combat pre-buffing and use normal defensive logic
    if not player.inCombat then
        return spell:Cast()
    end

    if shouldDefensive() or player.hp <= A.GetToggle(2, "blazingBarrierHP") then
        return spell:Cast()
    end
end)

MirrorImage:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end

    if player.hp <= A.GetToggle(2, "MirrorImageHP") then
        return spell:Cast()
    end
end)

BlazingBarrier:Callback("pvp", function(spell)
    if not A.IsInPvP then return end
    if not player.inCombat then return end

    if player.hp <= A.GetToggle(2, "blazingBarrierHP") then
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

MirrorImage:Callback("pre", function(spell)
    if player.inCombat and not shouldDefensive() then return end
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 6 then return end
    if MakMulti.party:Size() <= 5 then return end

    return spell:Cast()
end)

Flamestrike:Callback("pre", function(spell)
    if not A.GetToggle(2, "AoE") then return end
    if not gameState.cursorCheck then return end

    local threshold
    if A.FrostfireBolt:IsTalentLearned() then
        threshold = gameState.ffFillerFlamestrike
    elseif A.SpellfireSpheres:IsTalentLearned() then
        threshold = gameState.sfFillerFlamestrike
    else
        threshold = gameState.hotStreakFlamestrike
    end

    if activeEnemies() < threshold then return end

    if player.inCombat or gameState.imCasting then return end
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > (Pyroblast:CastTime() / 1000) then return end

    return spell:Cast()
end)

-- Opener Step 1: Pre-cast Pyroblast before pull
Pyroblast:Callback("pre", function(spell)
    if not player or not gameState then return end
    if player.inCombat or gameState.imCasting then return end
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if BossMods and BossMods:HasAnyAddon() and BossMods:GetPullTimer() and Pyroblast and Pyroblast.CastTime and BossMods:GetPullTimer() > (Pyroblast:CastTime() / 1000) then return end

    return spell:Cast()
end)

-- Opener Step 2: Queue Phoenix Flames as Pyroblast is ending
PhoenixFlames:Callback("pre", function(spell)
    if not player or not gameState or not target then return end
    if gameState.hotStreak then return end
    if not gameState.castingPyroblast and not Player:PrevGCD(1, A.Pyroblast) and not gameState.castingFlamestrike and not Player:PrevGCD(1, A.Flamestrike) and not player.moving then return end
    if not player.combatTime then return end
    if player.combatTime > 5 then return end
    if spell.used and spell.used > 0 and spell.used < 5000 then return end

    if FireBlast and FireBlast.lastAttempt and FireBlast.lastAttempt > 200 and FireBlast.lastAttempt < 700 then return end

    if A.GetToggle(2, "scorchOnly") and target.hp and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    return spell:Cast(target)
end)

-- Opener Step 3: Use Tempered Potion (handled in main rotation during opener)
-- Opener Step 4: Cast Scorch (handled in "openerScorch" callback below)
-- Opener Step 5: Cast Combustion while casting Scorch (handled in Combustion callback)
-- Opener Step 6-9: Queue instant Pyroblast, Fire Blast, etc. (handled in main rotation)

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast()
end)

Berserking:Callback(function(spell)
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

LightsJudgment:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if gameState.hasCombustion then return end

    return spell:Cast()
end)

BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if gameState.hasCombustion then return end

    return spell:Cast()
end)

local function cooldowns()
    -- Use racials early in Combustion per SimC (buff.combustion.remains > 6)
    if player:BuffRemains(buffs.combustion) <= 6000 then return end
    BloodFury()
    Berserking()
    Fireblood()
    AncestralCall()
end

HyperWrist:Callback(function(spell)
    if not gameState.wrists then return end
    if gameState.wristNotReady then return end
    if player:BuffDuration(buffs.combustion) < 10000 then return end -- This is specifically to check that we've hard used combustion and not gotten a proc.
    if player:BuffRemains(buffs.combustion) < 6000 then return end

    if FireBlast.frac < 1 then
        return spell:Cast()
    end
end)

SynapseEnhancer:Callback(function(spell)
    if not gameState.synapse then return end
    if gameState.synapseNotReady then return end

    if Combustion.cd < 500 or player:BuffRemains(buffs.combustion) > 10000 then
        return spell:Cast()
    end
end)

PhoenixFlames:Callback("justInCase", function(spell)
    if FireBlast.lastAttempt > 0 and FireBlast.lastAttempt < 500 then return end

    if A.GetToggle(2, "scorchOnly") and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    if player:Buff(buffs.hyperthermia) and player:BuffRemains(buffs.feelTheBurn) < 2000 and FireBlast.frac < 1 then
        return spell:Cast()
    end
end)

Meteor:Callback("noCombust", function(spell)
    if not gameState.cursorCheck then return end
    if player:Buff(buffs.combustion) then return end
    if not shouldBurst() then return end -- combust prep only

    if gameState.imCastingRemaining and gameState.imCastingRemaining > 800 then return end

    if Combustion.cd < 300 then
        return spell:Cast()
    end

    if gameState.hasBlessing and gameState.imCasting and gameState.imCasting == Pyroblast.id then
        return spell:Cast()
    end
end)

Meteor:Callback("combust", function(spell)
    if not gameState.cursorCheck then return end
    if not player:Buff(buffs.combustion) then return end
    if player:BuffRemains(buffs.combustion) <= 2000 then return end
    if gameState.imCastingRemaining and gameState.imCastingRemaining > 800 then return end

    return spell:Cast()
end)

Meteor:Callback("ffFiller", function(spell)
    if player:Buff(buffs.combustion) then return end
    if not gameState.cursorCheck then return end
    if not (Combustion:Cooldown() > gameState.poolingTime or A.SunKingsBlessing:IsTalentLearned()) then return end

    return spell:Cast()
end)

Meteor:Callback("sfFiller", function(spell)
    if player:Buff(buffs.combustion) then return end
    if not gameState.cursorCheck then return end
    if activeEnemies() < 2 then return end

    return spell:Cast()
end)

-- Opener Step 4: Cast Scorch after Phoenix Flames and Potion
Scorch:Callback("opener", function(spell)
    if not shouldBurst() then return end
    if not player then return end
    if not player.inCombat then return end
    if not player.combatTime then return end
    if player.combatTime > 4000 then return end -- Only during opener (first 4 seconds)
    if player:Buff(buffs.combustion) then return end
    if not target or not target.exists then return end

    -- Cast Scorch after Phoenix Flames has been used (and potion if enabled)
    -- The potion check is implicit - if potion is used, it will be used before this
    if PhoenixFlames and PhoenixFlames.used and PhoenixFlames.used > 0 and PhoenixFlames.used < 3000 and Combustion and Combustion.cd and Combustion.cd < 500 then
        return spell:Cast(target)
    end
end)

FireBlast:Callback("enterCombustion", function(spell)
    if not player:Buff(buffs.heatingUp) then return end
    if C_Spell.IsCurrentSpell(spell.id) then return end

    return spell:Cast(target)
end)

-- Opener Step 5: Cast Combustion while casting Scorch
Combustion:Callback(function(spell)
    if not shouldBurst() then return end
    if not player then return end
    if player:Buff(buffs.combustion) then return end
    if not player.inCombat then return end

    if A.GetToggle(2, "holdCombustIB") and FireBlast and FireBlast.frac and PhoenixFlames and PhoenixFlames.frac and (FireBlast.frac < 2 and PhoenixFlames.frac < 1) then return end

    -- During opener: cast Combustion while casting Scorch (no Fire Blast needed, Scorch will crit)
    if player.combatTime and player.combatTime < 4000 and gameState.imCasting and Scorch and Scorch.id and gameState.imCasting == Scorch.id then
        if gameState.imCastingRemaining and gameState.imCastingRemaining < 1000 then
            return spell:Cast()
        end
    end

    -- Normal Combustion usage (non-opener) - use Fire Blast to generate Heating Up first
    if gameState.imCasting and Scorch and Scorch.id and Fireball and Fireball.id and FrostfireBolt and FrostfireBolt.id and (gameState.imCasting == Scorch.id or gameState.imCasting == Fireball.id or gameState.imCasting == FrostfireBolt.id) then
        FireBlast("enterCombustion")

        if gameState.imCastingRemaining and gameState.imCastingRemaining < 1000 then
            return spell:Cast()
        end
    end
end)

Scorch:Callback("movement", function(spell)
    -- Movement filler - cast Scorch when moving and unable to cast other spells
    if not player.moving then return end
    if player:Buff(buffs.iceFloes) then return end -- Ice Floes allows casting while moving
    if not player.inCombat then return end
    if not target.exists or not target.canAttack then return end
    if not Pyroblast:InRange(target) then return end

    -- Don't override instant cast spells during movement
    if gameState.hotStreak then return end -- Hot Streak Pyroblast/Flamestrike takes priority
    if player:Buff(buffs.hyperthermia) and (FireBlast.frac >= 1 or PhoenixFlames.frac >= 1) then return end -- Let instant casts happen first

    -- Cast Scorch as movement filler
    return spell:Cast(target)
end)

-- Enter Combustion with Scorch (or Fireball if above 104% haste)
Scorch:Callback("enterCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if not shouldBurst() then return end -- combust prep only
    if target.hp and target.hp < 30 and not target.isDummy then return end

    -- If above 104% haste, use Fireball instead of Scorch
    local hastePercent = player.haste or 0
    if hastePercent > 104 then return end

    if Combustion and Combustion.cd and Combustion.cd < 500 then
        return spell:Cast(target)
    end

    if Player:PrevGCD(1, A.Meteor) then
        return spell:Cast(target)
    end
end)

-- Enter Combustion with Fireball if above 104% haste (or if already casting Fireball when Combustion becomes ready)
Fireball:Callback("enterCombust", function(spell)
    if not player or not target or not target.exists then return end
    if FrostfireBolt and FrostfireBolt.id and player:TalentKnown(FrostfireBolt.id) then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end
    if not shouldBurst() then return end -- combust prep only
    if target.hp and target.hp < 30 then return end

    -- Use Fireball if above 104% haste
    local hastePercent = player.haste or 0
    local useFireball = hastePercent > 104

    if Combustion and Combustion.cd and Combustion.cd < 300 and useFireball then
        return spell:Cast(target)
    end

    if Player:PrevGCD(1, A.Meteor) and useFireball then
        return spell:Cast(target)
    end
end)

FrostfireBolt:Callback("enterCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end
    if not shouldBurst() then return end -- combust prep only
    if target.hp and target.hp < 30 then return end

    if player:Buff(buffs.frostfireEmpowerment) then return end

    if Combustion and Combustion.cd and Combustion.cd < 300 then
        return spell:Cast(target)
    end

    if Player:PrevGCD(1, A.Meteor) then
        return spell:Cast(target)
    end
end)

Scorch:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end
    if not shouldBurst() then return end -- combust prep only

    if player:Buff(buffs.frostfireEmpowerment) then
        if Combustion and Combustion.cd and Combustion.cd < 300 then
            return spell:Cast(target)
        end

        if Player:PrevGCD(1, A.Meteor) then
            return spell:Cast(target)
        end
    end
end)

-- Outside Combustion Priority 4: Cast Shifting Power outside of cooldowns to get cooldown reduction on Combustion, Fire Blast, and Phoenix Flames
ShiftingPower:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hyperthermia) then return end
    if player:Buff(buffs.hotStreak) then return end

    if FireBlast and FireBlast.frac and FireBlast.frac > 2.5 then return end
    if PhoenixFlames and PhoenixFlames.frac and PhoenixFlames.frac > 2 then return end
    -- Shifting Power if Combustion is more than 8 seconds away
    local combustCd = nil
    if Combustion then
        if Combustion.cd then
            combustCd = Combustion.cd
        elseif Combustion.Cooldown then
            combustCd = Combustion:Cooldown()
        end
    end
    if combustCd and combustCd <= 8000 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if A.IceFloes:IsTalentLearned() and IceFloes and IceFloes.Cooldown and IceFloes:Cooldown() < 300 and ShiftingPower and ShiftingPower.Cooldown and ShiftingPower:Cooldown() < 300 then
        if floes and floes[2] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end
    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

Flamestrike:Callback(function(spell)
    if not A.GetToggle(2, "AoE") then return end
    if not gameState.cursorCheck then return end

    local threshold
    if A.FrostfireBolt:IsTalentLearned() then
        threshold = player:Buff(buffs.combustion) and gameState.ffCombustionFlamestrike or gameState.ffFillerFlamestrike
    elseif A.SpellfireSpheres:IsTalentLearned() then
        threshold = player:Buff(buffs.combustion) and gameState.sfCombustionFlamestrike or gameState.sfFillerFlamestrike
    else
        threshold = gameState.hotStreakFlamestrike
    end

    if activeEnemies() < threshold then return end

    if spell:CastTime() == 0 or gameState.hotStreak then
        return spell:Cast()
    end

    local blessingOnBurst = A.GetToggle(2, "blessingOnBurst")
    local consumeBlessing = player:BuffRemains(buffs.furyOfTheSunKing, true) < Pyroblast:CastTime() + 4000 or blessingOnBurst and shouldBurst() or not blessingOnBurst

    if gameState.hasBlessing and consumeBlessing then
        local floes = A.GetToggle(2, "floesSelect")
        if A.IceFloes:IsTalentLearned() and IceFloes:Cooldown() < 300 then
            if floes[1] and not player:Buff(buffs.iceFloes) then
                IceFloes:Cast()
                return spell:Cast()
            end
        end
    end
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if gameState.hasBlessing and consumeBlessing then
        return spell:Cast()
    end
end)

-- AoE Combustion Priority 1: Cast Flamestrike with Hyperthermia (Double Flamestrike technique)
Flamestrike:Callback("doubleFlamestrike", function(spell)
    if not player or not target or not target.exists then return end
    if not A.GetToggle(2, "AoE") then return end
    if not gameState.cursorCheck then return end
    if not player:Buff(buffs.combustion) then return end

    local threshold
    if A.FrostfireBolt and A.FrostfireBolt.IsTalentLearned and A.FrostfireBolt:IsTalentLearned() then
        threshold = gameState.ffCombustionFlamestrike
    elseif A.SpellfireSpheres and A.SpellfireSpheres.IsTalentLearned and A.SpellfireSpheres:IsTalentLearned() then
        threshold = gameState.sfCombustionFlamestrike
    else
        threshold = gameState.hotStreakFlamestrike
    end

    if activeEnemies() < threshold then return end

    -- Double Flamestrike: Queue Flamestrike with Hot Streak as a cast ends
    if gameState.imCasting and gameState.imCastingRemaining and gameState.imCastingRemaining < 400 and player:Buff(buffs.hotStreak) then
        return spell:Cast()
    end
end)

-- AoE Combustion Priority 2: Cast Flamestrike with Hyperthermia
Flamestrike:Callback("hyperthermia", function(spell)
    if not player or not target or not target.exists then return end
    if not A.GetToggle(2, "AoE") then return end
    if not gameState.cursorCheck then return end
    if not player:Buff(buffs.combustion) then return end
    if not player:Buff(buffs.hyperthermia) then return end

    local threshold
    if A.FrostfireBolt and A.FrostfireBolt.IsTalentLearned and A.FrostfireBolt:IsTalentLearned() then
        threshold = gameState.ffCombustionFlamestrike
    elseif A.SpellfireSpheres and A.SpellfireSpheres.IsTalentLearned and A.SpellfireSpheres:IsTalentLearned() then
        threshold = gameState.sfCombustionFlamestrike
    else
        threshold = gameState.hotStreakFlamestrike
    end

    if activeEnemies() < threshold then return end

    return spell:Cast()
end)

-- AoE Outside Combustion Priority 2: Cast Flamestrike with Hyperthermia
Flamestrike:Callback("hyperNoCombust", function(spell)
    if not player or not target or not target.exists then return end
    if not A.GetToggle(2, "AoE") then return end
    if not gameState.cursorCheck then return end
    if player:Buff(buffs.combustion) then return end
    if not player:Buff(buffs.hyperthermia) then return end

    local threshold
    if A.FrostfireBolt and A.FrostfireBolt.IsTalentLearned and A.FrostfireBolt:IsTalentLearned() then
        threshold = gameState.ffFillerFlamestrike
    elseif A.SpellfireSpheres and A.SpellfireSpheres.IsTalentLearned and A.SpellfireSpheres:IsTalentLearned() then
        threshold = gameState.sfFillerFlamestrike
    else
        threshold = gameState.hotStreakFlamestrike
    end

    if activeEnemies() < threshold then return end

    return spell:Cast()
end)

-- Outside Combustion Priority 2: Cast Pyroblast with Hyperthermia
Pyroblast:Callback("hyperNoCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if not player:Buff(buffs.hyperthermia) then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 3: Cast Pyroblast with Hot Streak
Pyroblast:Callback(function(spell)
    if not target or not target.exists then return end
    if spell:CastTime() == 0 or gameState.hotStreak then
        return spell:Cast(target)
    end

    local blessingOnBurst = A.GetToggle(2, "blessingOnBurst")
    local consumeBlessing = player:BuffRemains(buffs.furyOfTheSunKing, true) < Pyroblast:CastTime() + 4000 or blessingOnBurst and shouldBurst() or not blessingOnBurst

    if gameState.hasBlessing and consumeBlessing then
        local floes = A.GetToggle(2, "floesSelect")
        if A.IceFloes:IsTalentLearned() and IceFloes:Cooldown() < 300 then
            if floes[1] and not player:Buff(buffs.iceFloes) then
                IceFloes:Cast()
                return spell:Cast(target)
            end
        end
    end
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if gameState.hasBlessing and consumeBlessing then
        return spell:Cast(target)
    end
end)

-- Outside Combustion Priority 5: Cast Scorch if target is below 30% health and Improved Scorch is about to fall
Scorch:Callback("noCombust2", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if not A.ImprovedScorch:IsTalentLearned() then return end
    if gameState.hotStreak then return end
    if not target.hp or target.hp > 30 then return end
    if target:DebuffRemains(debuffs.improvedScorch, true) > 2000 then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 6: Cast Scorch with Heat Shimmer if Improved Scorch is about to fall
Scorch:Callback("noCombustHeatShimmer", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if not A.ImprovedScorch:IsTalentLearned() then return end
    if gameState.hotStreak then return end
    if not player:Buff(buffs.heatShimmer) then return end
    if target:DebuffRemains(debuffs.improvedScorch, true) > 2000 then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 1: Cast Fire Blast with Heating Up while casting a spell
-- Or during Hyperthermia following Combustion-style rules
-- Or during Shifting Power to avoid capping Fire Blast charges
-- Major Improvement: Pooling - avoid using Fire Blast when Combustion is soon unless about to cap
FireBlast:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if not player.inCombat then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end

    if spell.used and spell.used > 0 and spell.used < 400 then return end
    if PhoenixFlames and PhoenixFlames.used and PhoenixFlames.used > 0 and PhoenixFlames.used < 400 then return end
    if gameState.pfInFlight then return end

    if C_Spell and C_Spell.IsCurrentSpell and C_Spell.IsCurrentSpell(spell.id) then return end

    local critInFlight = A.Fireball and A.Fireball.IsSpellInFlight and A.Fireball:IsSpellInFlight() and not player:TalentKnown(FrostfireBolt.id) or A.Pyroblast and A.Pyroblast.IsSpellInFlight and A.Pyroblast:IsSpellInFlight() or gameState.frostfireInFlight
    if player:Buff(buffs.heatingUp) and (critInFlight or Pyroblast and Pyroblast.used and Pyroblast.used < 300 or Flamestrike and Flamestrike.used and Flamestrike.used < 300 or C_Spell and C_Spell.IsCurrentSpell and Pyroblast and Pyroblast.id and C_Spell.IsCurrentSpell(Pyroblast.id)) then return end

    if A.GetToggle(2, "scorchOnly") and target.hp and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    if Player:PrevGCD(1, A.PhoenixFlames) and player:Buff(buffs.heatingUp) and not gameState.imCasting then return end

    if PhoenixFlames and PhoenixFlames.lastAttempt and PhoenixFlames.lastAttempt > 0 and PhoenixFlames.lastAttempt < 500 then return end

    -- Determine Combustion remaining cooldown in ms (prefer .cd, fall back to :Cooldown())
    local combustCd = nil
    if Combustion then
        if Combustion.cd then
            combustCd = Combustion.cd
        elseif Combustion.Cooldown then
            combustCd = Combustion:Cooldown()
        end
    end

    -- Major Improvement: Pooling
    -- If Combustion will be ready within 10 seconds, pool Fire Blast unless we would cap on charges
    if combustCd and combustCd <= 10000 then
        if not (spell.frac and spell.frac > 2.8 and gameState.heatingUp and gameState.imCasting and gameState.imCastingRemaining and gameState.imCastingRemaining < 700) then
            return
        end
    end

    -- Priority 1a: Cast Fire Blast with Heating Up while casting a spell and about to overcap
    if gameState.heatingUp and spell.frac and spell.frac > 2.8 then
        if gameState.imCasting and gameState.imCastingRemaining and gameState.imCastingRemaining < 700 then
            return Debounce("fb", 100, 300, spell, target)
        end
    end

    -- Priority 1b: During Hyperthermia if above 1.5 charges or Glorious Incandescence is active
    if player:Buff(buffs.hyperthermia) then
        local hasGI = player:Buff(buffs.gloriousIncandescence)
        if (spell.frac and spell.frac > 1.5) or hasGI then
            if MakGcd() > 200 and not player.casting then
                return Debounce("fb", 100, 300, spell, target)
            end
        end
    end

    -- Priority 1c: During Shifting Power to avoid capping Fire Blast charges
    if gameState.imCasting and ShiftingPower and ShiftingPower.id and gameState.imCasting == ShiftingPower.id and spell.frac and spell.frac > 2.5 then
        return Debounce("fb", 100, 300, spell, target)
    end

    -- Fallback: if Fire Blast is about to cap and Heating Up is up, allow usage
    if MakGcd() > 200 and gameState.heatingUp and not player.casting and spell.frac and spell.frac > 2.8 then
        return Debounce("fb", 100, 300, spell, target)
    end
end)

-- Outside Combustion Priority 7: Cast Phoenix Flames
PhoenixFlames:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if player:Buff(buffs.frostfireEmpowerment) and not player:Buff(buffs.excessFrost) then return end

    if FireBlast and FireBlast.lastAttempt and FireBlast.lastAttempt > 0 and FireBlast.lastAttempt < 500 then return end

    if A.GetToggle(2, "scorchOnly") and target.hp and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    -- Filler rules from spec:
    -- 1) Cast after Hyperthermia if Heating Up is active
    if player:Buff(buffs.hyperthermia) and player:Buff(buffs.heatingUp) then
        return spell:Cast(target)
    end

    -- 2) Cast after a Fireball cast without Heating Up
    if Player and Player.PrevGCD and Player:PrevGCD(1, A.Fireball) and not player:Buff(buffs.heatingUp) then
        return spell:Cast(target)
    end

    return spell:Cast(target)
end)

FrostfireBolt:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end

    if FireBlast and FireBlast.lastAttempt and FireBlast.lastAttempt > 0 and FireBlast.lastAttempt < 500 then return end
    if not player:Buff(buffs.frostfireEmpowerment) then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 8: If target is below 30% health cast Scorch
Scorch:Callback("noCombust3", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if not target.hp or target.hp > 30 then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 9: Cast Fireball as filler
Fireball:Callback("noCombust", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if FrostfireBolt and FrostfireBolt.id and player:TalentKnown(FrostfireBolt.id) then return end
    if gameState.hotStreak then return end

    return spell:Cast(target)
end)

-- Outside Combustion Priority 9: Cast Frostfire Bolt as filler
FrostfireBolt:Callback("noCombust2", function(spell)
    if not player or not target or not target.exists then return end
    if player:Buff(buffs.combustion) then return end
    if not player:TalentKnown(FrostfireBolt.id) then return end
    if gameState.hotStreak then return end

    return spell:Cast(target)
end)

Scorch:Callback("noCombust4", function(spell)

    return spell:Cast(target)
end)

-- ST Combustion Priority 1: Cast Pyroblast with Hot Streak (Double Pyroblast technique)
Pyroblast:Callback("doublePyro", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if not A.Pyroblast or not A.Pyroblast.IsSpellInFlight or not A.Pyroblast:IsSpellInFlight() then return end
    if not player:Buff(buffs.heatingUp) then return end

    return spell:Cast(target)
end)

-- Combustion Priority 1: Cast Pyroblast with Hyperthermia
Pyroblast:Callback("hyperthermia", function(spell)
    if not player then return end
    if not player:Buff(buffs.hyperthermia) then return end
    if not player:Buff(buffs.combustion) then return end
    if not target or not target.exists then return end

    return spell:Cast(target)
end)

-- Combustion Priority 4: Cast Scorch with Heat Shimmer
Scorch:Callback("combust", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if not player:Buff(buffs.heatShimmer) then return end
    if not A.ImprovedScorch or not A.ImprovedScorch.IsTalentLearned or not A.ImprovedScorch:IsTalentLearned() then return end
    if not target.hp or target.hp > 30 then return end
    -- Only refresh Improved Scorch when the debuff is close to expiring (below 4 GCDs)
    if target:DebuffRemains(debuffs.improvedScorch, true) > 4 * A.GetGCD() * 1000 then return end

    return spell:Cast(target)
end)

-- Combustion Priority 5: Cast Phoenix Flames to generate Hot Streak
PhoenixFlames:Callback("combust", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if Player:PrevGCD(1, A.PhoenixFlames) then return end

    if player:Buff(buffs.frostfireEmpowerment) and not player:Buff(buffs.excessFrost) then return end

    if FireBlast and FireBlast.lastAttempt and FireBlast.lastAttempt > 0 and FireBlast.lastAttempt < 500 then return end

    if A.GetToggle(2, "scorchOnly") and target.hp and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    if player:Buff(buffs.flamesFury) or FireBlast and FireBlast.frac and FireBlast.frac < 1 then
        return spell:Cast(target)
    end
end)

FrostfireBolt:Callback("combust", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if Player:PrevGCD(1, A.PhoenixFlames) then return end

    if FireBlast and FireBlast.lastAttempt and FireBlast.lastAttempt > 0 and FireBlast.lastAttempt < 500 then return end
    if not player:Buff(buffs.frostfireEmpowerment) then return end

    return spell:Cast(target)
end)

-- Combustion Priority 3: Cast Fire Blast to generate Hot Streak
FireBlast:Callback("combust", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end

    if C_Spell and C_Spell.IsCurrentSpell and C_Spell.IsCurrentSpell(spell.id) then return end

    -- Only spend Fire Blast in Combustion when above 1.5 charges,
    -- or when Glorious Incandescence buff is active (to guarantee it is consumed in the window)
    local charges = spell.frac
    if charges and charges <= 1.5 and not player:Buff(buffs.gloriousIncandescence) then
        return
    end

    local critInFlight = A.Fireball and A.Fireball.IsSpellInFlight and A.Fireball:IsSpellInFlight() and not player:TalentKnown(FrostfireBolt.id) or A.Pyroblast and A.Pyroblast.IsSpellInFlight and A.Pyroblast:IsSpellInFlight() or gameState.frostfireInFlight
    if player:Buff(buffs.heatingUp) and (critInFlight or Pyroblast and Pyroblast.used and Pyroblast.used < 300 or Flamestrike and Flamestrike.used and Flamestrike.used < 300 or C_Spell and C_Spell.IsCurrentSpell and Pyroblast and Pyroblast.id and C_Spell.IsCurrentSpell(Pyroblast.id)) then return end

    if charges and charges < 1 then return end

    if spell.used and spell.used > 0 and spell.used < 400 then return end
    if PhoenixFlames and PhoenixFlames.used and PhoenixFlames.used > 0 and PhoenixFlames.used < 400 then return end
    if gameState.pfInFlight then return end

    if PhoenixFlames and PhoenixFlames.lastAttemptTime and PhoenixFlames.lastAttemptTime > 0 and PhoenixFlames.lastAttemptTime < 500 then return end

    if A.GetToggle(2, "scorchOnly") and target.hp and target.hp < 30 and not target.isBoss and not target.isDummy then return end

    return Debounce("fb", 100, 300, spell, target)
end)

Fireball:Callback("combust", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if FrostfireBolt and FrostfireBolt.id and player:TalentKnown(FrostfireBolt.id) then return end
    if gameState.hotStreak then return end
    if not player:Buff(buffs.flameAccelerant) then return end

    return spell:Cast(target)
end)

-- Spellfire Spheres specific Fire Blast callback for combustion
FireBlast:Callback("sfCombust", function(spell)
    if not player or not target or not target.exists then return end
    if not A.SpellfireSpheres or not A.SpellfireSpheres.IsTalentLearned or not A.SpellfireSpheres:IsTalentLearned() then return end
    if not player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end

    if C_Spell and C_Spell.IsCurrentSpell and spell.id and C_Spell.IsCurrentSpell(spell.id) then return end

    local charges = spell.frac

    -- Glorious Incandescence handling
    if A.GloriousIncandescence and A.GloriousIncandescence.IsTalentLearned and A.GloriousIncandescence:IsTalentLearned() then
        if not player:Buff(buffs.gloriousIncandescence) and charges and charges <= 1.5 then return end
        if player:BuffRemains(buffs.combustion) < (A.GetGCD() * 1000 * (charges or 0)) then return end
    else
        -- Without GI, still follow the "above 1.5 charges" rule during Combustion
        if charges and charges <= 1.5 then return end
    end

    local critInFlight = A.Fireball and A.Fireball.IsSpellInFlight and A.Fireball:IsSpellInFlight() or A.Pyroblast and A.Pyroblast.IsSpellInFlight and A.Pyroblast:IsSpellInFlight()
    if player:Buff(buffs.heatingUp) and (critInFlight or Pyroblast and Pyroblast.used and Pyroblast.used < 300 or Flamestrike and Flamestrike.used and Flamestrike.used < 300) then return end

    if charges and charges < 1 then return end
    if spell.used and spell.used > 0 and spell.used < 400 then return end
    if PhoenixFlames and PhoenixFlames.used and PhoenixFlames.used > 0 and PhoenixFlames.used < 400 then return end

    return Debounce("sfFb", 100, 300, spell, target)
end)

-- Spellfire Spheres specific Fire Blast callback for filler
FireBlast:Callback("sfFiller", function(spell)
    if not player or not target or not target.exists then return end
    if not A.SpellfireSpheres or not A.SpellfireSpheres.IsTalentLearned or not A.SpellfireSpheres:IsTalentLearned() then return end
    if player:Buff(buffs.combustion) then return end
    if player:Buff(buffs.hotStreak) then return end

    if C_Spell and C_Spell.IsCurrentSpell and spell.id and C_Spell.IsCurrentSpell(spell.id) then return end

    -- Determine Combustion remaining cooldown in ms (prefer .cd, fall back to :Cooldown())
    local combustCd = nil
    if Combustion then
        if Combustion.cd then
            combustCd = Combustion.cd
        elseif Combustion.Cooldown then
            combustCd = Combustion:Cooldown()
        end
    end

    -- Major Improvement: Pooling (Spellfire path)
    -- If Combustion will be ready within 10 seconds, pool Fire Blast unless we would cap on charges
    if combustCd and combustCd <= 10000 then
        if not (spell.frac and spell.frac > 2.8 and gameState.heatingUp and gameState.imCasting and gameState.imCastingRemaining and gameState.imCastingRemaining < 700) then
            return
        end
    end

    -- Glorious Incandescence handling for AoE
    if A.GloriousIncandescence and A.GloriousIncandescence.IsTalentLearned and A.GloriousIncandescence:IsTalentLearned() and activeEnemies() >= 2 then
        if not player:Buff(buffs.gloriousIncandescence) then return end
        if Combustion and Combustion.Cooldown and Combustion:Cooldown() <= 10000 then return end
    end

    -- Hyperthermia handling (follow Combustion-style rule: >1.5 charges or GI buff)
    if player:Buff(buffs.hyperthermia) then
        local charges = spell.frac
        if A.GloriousIncandescence and A.GloriousIncandescence.IsTalentLearned and A.GloriousIncandescence:IsTalentLearned() then
            if not player:Buff(buffs.gloriousIncandescence) and charges and charges <= 1.5 then return end
            if player:BuffRemains(buffs.hyperthermia) < (A.GetGCD() * 1000 * (charges or 0)) then return end
        else
            if charges and charges <= 1.5 then return end
        end
        if Combustion and Combustion.Cooldown and Combustion:Cooldown() <= 10000 then return end
    end

    local critInFlight = A.Fireball and A.Fireball.IsSpellInFlight and A.Fireball:IsSpellInFlight() or A.Pyroblast and A.Pyroblast.IsSpellInFlight and A.Pyroblast:IsSpellInFlight()
    if player:Buff(buffs.heatingUp) and critInFlight then return end

    if spell.frac and spell.frac < 1 then return end
    if spell.used and spell.used > 0 and spell.used < 400 then return end

    return Debounce("sfFillerFb", 100, 300, spell, target)
end)

FrostfireBolt:Callback("combust2", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if not player:TalentKnown(FrostfireBolt.id) then return end
    if gameState.hotStreak then return end
    if not player:Buff(buffs.flameAccelerant) then return end

    return spell:Cast(target)
end)

-- Combustion Priority 6: Cast Scorch to generate Hot Streak
Scorch:Callback("combust2", function(spell)
    if not player or not target or not target.exists then return end
    if not player:Buff(buffs.combustion) then return end
    if gameState.hotStreak then return end
    if PhoenixFlames and PhoenixFlames.frac and PhoenixFlames.frac >= 1 and not A.GetToggle(2, "scorchOnly") then return end

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

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    --[[if enemyNeedsSpellsteal(dungSpellsteal) and not target:BuffFrom(dungSpellsteal) then
        return true
    end

    if Frostbolt:InRange(target) and target.exists then return false end

    if enemiesInRange() > 0 then
        return true
    end]]
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

-- Frostfire Bolt Hero Talent Combustion Rotation (ff_combustion)
-- ST Priority: Pyroblast (Hyperthermia) > Pyroblast (Hot Streak) > Fire Blast > Scorch (Heat Shimmer) > Phoenix Flames > Scorch
-- AoE Priority: Flamestrike (Hyperthermia) > Flamestrike (Hot Streak) > Fire Blast > Phoenix Flames > Scorch
local function ffCombustion()
    Scorch("movement") -- Movement filler - works even during Combustion

    -- AoE Combustion
    Flamestrike("doubleFlamestrike") -- AoE: Double Flamestrike technique
    Flamestrike("hyperthermia") -- AoE: Cast Flamestrike with Hyperthermia

    -- ST Combustion
    Pyroblast("doublePyro") -- ST: Double Pyroblast technique
    Pyroblast("hyperthermia") -- ST: Cast Pyroblast with Hyperthermia

    -- Hot Streak spenders (AoE or ST)
    Flamestrike() -- AoE Hot Streak
    Pyroblast() -- ST Hot Streak

    Meteor("combust")
    FireBlast("combust") -- Cast Fire Blast to generate Hot Streak
    Scorch("combust") -- Cast Scorch with Heat Shimmer (removed from AoE priority)
    PhoenixFlames("combust") -- Cast Phoenix Flames to generate Hot Streak
    FrostfireBolt("combust")
    Fireball("combust")
    FrostfireBolt("combust2")
    Scorch("combust2") -- Cast Scorch to generate Hot Streak
end

-- Spellfire Spheres Hero Talent Combustion Rotation (sf_combustion)
-- ST Priority: Pyroblast (Hyperthermia) > Pyroblast (Hot Streak) > Fire Blast > Scorch (Heat Shimmer) > Phoenix Flames > Scorch
-- AoE Priority: Flamestrike (Hyperthermia) > Flamestrike (Hot Streak) > Fire Blast > Phoenix Flames > Scorch
local function sfCombustion()
    Scorch("movement") -- Movement filler - works even during Combustion

    -- AoE Combustion
    Flamestrike("doubleFlamestrike") -- AoE: Double Flamestrike technique
    Flamestrike("hyperthermia") -- AoE: Cast Flamestrike with Hyperthermia

    -- ST Combustion
    Pyroblast("doublePyro") -- ST: Double Pyroblast technique
    Pyroblast("hyperthermia") -- ST: Cast Pyroblast with Hyperthermia

    -- Hot Streak spenders (AoE or ST)
    Flamestrike() -- AoE Hot Streak
    Pyroblast() -- ST Hot Streak

    -- Improved Scorch maintenance during combustion
    if gameState.improvedScorch and target and target.exists and target:DebuffRemains(debuffs.improvedScorch, true) < 4 * A.GetGCD() * 1000 then
        Scorch("combust")
    end

    Meteor("combust")
    FireBlast("sfCombust") -- Spellfire Spheres specific Fire Blast during combustion
    PhoenixFlames("combust") -- Cast Phoenix Flames to generate Hot Streak
    Scorch("combust2") -- Cast Scorch to generate Hot Streak
    Fireball("combust")
end

-- Default Combustion Rotation (legacy)
-- ST Priority: Pyroblast (Hyperthermia) > Pyroblast (Hot Streak) > Fire Blast > Scorch (Heat Shimmer) > Phoenix Flames > Scorch
-- AoE Priority: Flamestrike (Hyperthermia) > Flamestrike (Hot Streak) > Fire Blast > Phoenix Flames > Scorch
local function defaultCombustion()
    Scorch("movement") -- Movement filler - works even during Combustion

    -- AoE Combustion
    Flamestrike("doubleFlamestrike") -- AoE: Double Flamestrike technique
    Flamestrike("hyperthermia") -- AoE: Cast Flamestrike with Hyperthermia

    -- ST Combustion
    Pyroblast("doublePyro") -- ST: Double Pyroblast technique
    Pyroblast("hyperthermia") -- ST: Cast Pyroblast with Hyperthermia

    -- Hot Streak spenders (AoE or ST)
    Flamestrike() -- AoE Hot Streak
    Pyroblast() -- ST Hot Streak

    Meteor("combust")
    FireBlast("combust") -- Cast Fire Blast to generate Hot Streak
    PhoenixFlames("combust") -- Cast Phoenix Flames to generate Hot Streak
    Fireball("combust")
    Scorch("combust2") -- Cast Scorch to generate Hot Streak
end

-- Frostfire Bolt Hero Talent Filler Rotation (ff_filler)
-- Priority: Fire Blast (Heating Up) > Flamestrike/Pyroblast (Hyperthermia) > Flamestrike/Pyroblast (Hot Streak) > Shifting Power > Scorch (Execute + Improved) > Scorch (Heat Shimmer) > Phoenix Flames > Scorch (Execute) > Fireball
local function ffFiller()
    Scorch("movement") -- Movement filler - high priority
    Scorch("enterCombust") -- Combustion prep
    FrostfireBolt("enterCombust") -- Combustion prep
    Scorch("noCombust") -- Combustion prep
    FireBlast("noCombust") -- Priority 1: Fire Blast with Heating Up
    Flamestrike("hyperNoCombust") -- Priority 2: Flamestrike with Hyperthermia (AoE)
    Pyroblast("hyperNoCombust") -- Priority 2: Pyroblast with Hyperthermia (ST)
    Flamestrike() -- Priority 3: Flamestrike with Hot Streak (AoE)
    Pyroblast() -- Priority 3: Pyroblast with Hot Streak (ST)
    ShiftingPower("noCombust") -- Priority 4: Shifting Power
    Scorch("noCombust2") -- Priority 5: Scorch if target below 30% and Improved Scorch about to fall
    Scorch("noCombustHeatShimmer") -- Priority 6: Scorch with Heat Shimmer if Improved Scorch about to fall
    Meteor("ffFiller")
    if (player:Buff(buffs.excessFrost) or A.SunKingsBlessing:IsTalentLearned()) and not (FrostfireBolt.used > 0 and FrostfireBolt.used < 500) then
        PhoenixFlames("noCombust") -- Priority 7: Phoenix Flames
    end
    FrostfireBolt("noCombust")
    Scorch("noCombust3") -- Priority 8: Scorch if target below 30%
    Fireball("noCombust") -- Priority 9: Fireball as filler
    FrostfireBolt("noCombust2") -- Priority 9: Frostfire Bolt as filler
    Scorch("noCombust4")
end

-- Spellfire Spheres Hero Talent Filler Rotation (sf_filler)
-- Priority: Fire Blast (Heating Up) > Flamestrike/Pyroblast (Hyperthermia) > Flamestrike/Pyroblast (Hot Streak) > Shifting Power > Scorch (Execute + Improved) > Scorch (Heat Shimmer) > Phoenix Flames > Scorch (Execute) > Fireball
local function sfFiller()
    Scorch("movement") -- Movement filler - high priority

    -- Spellfire Spheres specific Fire Blast for filler (Priority 1)
    FireBlast("sfFiller")

    -- Hyperthermia Flamestrike (AoE)
    if player:Buff(buffs.hyperthermia) and activeEnemies() >= gameState.sfFillerFlamestrike then
        Flamestrike()
    end

    -- Hot Streak Flamestrike (AoE)
    if player:Buff(buffs.hotStreak) and activeEnemies() >= gameState.sfFillerFlamestrike then
        Flamestrike()
    end

    -- Scorch -> Heating Up Flamestrike (AoE)
    if Player:PrevGCD(1, A.Scorch) and player:Buff(buffs.heatingUp) and activeEnemies() >= gameState.sfFillerFlamestrike then
        Flamestrike()
    end

    -- Priority 2: Flamestrike with Hyperthermia (AoE) / Pyroblast with Hyperthermia (ST)
    Flamestrike("hyperNoCombust")
    if player:Buff(buffs.hyperthermia) then
        Pyroblast()
    end

    -- Priority 3: Flamestrike with Hot Streak (AoE) / Pyroblast with Hot Streak (ST)
    if player:Buff(buffs.hotStreak) then
        Pyroblast()
    end

    -- Scorch -> Heating Up Pyroblast
    if Player:PrevGCD(1, A.Scorch) and player:Buff(buffs.heatingUp) then
        Pyroblast()
    end

    ShiftingPower("noCombust") -- Priority 4: Shifting Power

    -- Priority 5: Scorch if target below 30% and Improved Scorch about to fall
    Scorch("noCombust2")

    -- Priority 6: Scorch with Heat Shimmer if Improved Scorch about to fall
    Scorch("noCombustHeatShimmer")

    Meteor("sfFiller")

    -- Priority 7: Phoenix Flames
    if player:Buff(buffs.heatingUp) or FireBlast:Cooldown() <= 0 or PhoenixFlames and PhoenixFlames.frac and PhoenixFlames.frac > 1.5 then
        PhoenixFlames("noCombust")
    end

    -- Priority 8: Scorch if target below 30%
    if target and target.exists and target.canAttack and target.hp and target.hp <= 30 then
        Scorch("noCombust3")
    end

    Fireball("noCombust") -- Priority 9: Fireball as filler
end

-- Default Filler Rotation (legacy)
-- Priority: Fire Blast (Heating Up) > Flamestrike/Pyroblast (Hyperthermia) > Flamestrike/Pyroblast (Hot Streak) > Shifting Power > Scorch (Execute + Improved) > Scorch (Heat Shimmer) > Phoenix Flames > Scorch (Execute) > Fireball
local function defaultFiller()
    Scorch("movement") -- Movement filler - high priority
    Scorch("enterCombust") -- Combustion prep
    Scorch("noCombust") -- Combustion prep
    FireBlast("noCombust") -- Priority 1: Fire Blast with Heating Up
    Flamestrike("hyperNoCombust") -- Priority 2: Flamestrike with Hyperthermia (AoE)
    Pyroblast("hyperNoCombust") -- Priority 2: Pyroblast with Hyperthermia (ST)
    Flamestrike() -- Priority 3: Flamestrike with Hot Streak (AoE)
    Pyroblast() -- Priority 3: Pyroblast with Hot Streak (ST)
    ShiftingPower("noCombust") -- Priority 4: Shifting Power
    Scorch("noCombust2") -- Priority 5: Scorch if target below 30% and Improved Scorch about to fall
    Scorch("noCombustHeatShimmer") -- Priority 6: Scorch with Heat Shimmer if Improved Scorch about to fall
    PhoenixFlames("noCombust") -- Priority 7: Phoenix Flames
    Scorch("noCombust3") -- Priority 8: Scorch if target below 30%
    Fireball("noCombust") -- Priority 9: Fireball as filler
    Scorch("noCombust4")
end

A[3] = function(icon)
    FrameworkStart(icon)
    updateGameState()

    local critInFlight = A.Fireball:IsSpellInFlight() and not player:TalentKnown(FrostfireBolt.id) or A.Pyroblast:IsSpellInFlight() or gameState.frostfireInFlight

    if A.GetToggle(2, "makDebug") then

        MakPrint(1, "I got wrists: ", gameState.wrists)
        MakPrint(2, "Wrists Not Ready: ", gameState.wristNotReady)
        MakPrint(3, "Max Combustion Duration: ", player:BuffDuration(buffs.combustion))
        MakPrint(4, "Crit In Flight: ", critInFlight)
        MakPrint(5, "My cast remaining: ", gameState.imCastingRemaining)
        MakPrint(6, "Guaranteed Crit: ", guaranteedCrit())
        MakPrint(7, "Should Flamestrike Targets: ", gameState.hotStreakFlamestrike)
        MakPrint(8, "Phoenix Flames last attempt: ", PhoenixFlames.lastAttemptTime)
        MakPrint(9, "Fireball In Flight: ", A.Fireball:IsSpellInFlight() and not player:TalentKnown(FrostfireBolt.id))
        MakPrint(10, "Frostfire Bolt In Flight: ", gameState.frostfireInFlight)
        MakPrint(11, "Phoenix Flames In Flight: ", gameState.pfInFlight)
        MakPrint(12, "Pyroblast In Flight: ", A.Pyroblast:IsSpellInFlight())
    end

    local awareAlert = A.GetToggle(2, "makAware")

    if awareAlert[1] then
        if player:Buff(buffs.iceFloes) then
            Aware:displayMessage("Ice Floes Up!", "Green", 1)
        end
    end

    if awareAlert[2] then
        if shouldBurst() then
            if (not A.IceFloes:IsTalentLearned() or IceFloes.frac < 1) and not player:Buff(buffs.combustion) and FireBlast.frac < 1 then
                if ShiftingPower:Cooldown() < 500 then
                    Aware:displayMessage("Shifting Power Soon! Stand Still", "Blue", 1)
                end
            end
        end
    end

    if not player.channeling then
        Invisibility("feign")
        GreaterInvisibility("feign")
        if makFeign() and player.feigned then return end
        makInterrupt(interrupts)
    end

    if player:Buff(buffs.combustion) and player:Buff(buffs.heatingUp) and critInFlight then
        return FrameworkEnd()
    end

    local casting = player.castInfo
    local shouldStopFlamestrike = player.casting and casting.spellId == Flamestrike.id and not gameState.hasBlessing and player.combatTime * 1000 > Flamestrike.used and Flamestrike.used > 0
    local shouldStopPyroblast = player.casting and casting.spellId == Pyroblast.id and not gameState.hasBlessing and player.combatTime * 1000 > Pyroblast.used and Pyroblast.used > 0

    if shouldStopFlamestrike or shouldStopPyroblast then
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end

    if target.exists and target.canAttack and Pyroblast:InRange(target) then -- need outside castingRemaining
        Meteor("noCombust")
        Combustion()
        HyperWrist()
    end

    if gameState.imCastingRemaining and gameState.imCastingRemaining < 800 or not gameState.imCastingRemaining then

        ArcaneIntellect()
        AlterTime()
        AlterTimeBack()
        IceBlock()
        MassBarrier()
        IceCold()
        MirrorImage()
        MirrorImage("pvp")
        BlazingBarrier()
        BlazingBarrier("pvp")
        GreaterInvisibility()

        -- Melee CC
        FrostNova()
        ConeOfCold()
        DragonsBreath()

        if target.exists and target.canAttack and Pyroblast:InRange(target) then
            MirrorImage("pre")
            Flamestrike("pre")
            Pyroblast("pre")
            PhoenixFlames("pre")

            -- Opener Step 3: Use Tempered Potion after Phoenix Flames
            if player and player.inCombat and player.combatTime and player.combatTime < 3000 and PhoenixFlames and PhoenixFlames.used and PhoenixFlames.used > 0 and PhoenixFlames.used < 2000 then
                local damagePotion = Action.GetToggle(2, "damagePotion")
                local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
                local potionExhausted = Action.GetToggle(2, "potionExhausted")
                local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
                local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

                if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and potionExhaustedSlider and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                    return damagePotionObject:Show(icon)
                end
            end

            -- Opener Step 4: Cast Scorch
            Scorch("opener")

            -- Opener Step 5: Cast Combustion (handled in Combustion callback)
            Combustion()

            Spellsteal("util")
            GreaterInvisibility("util")

            if gameState.hasCombustion then
                FireBlast("combust")
            else
                FireBlast("noCombust")
            end

            if not player.channeling then
                if player:BuffRemains(buffs.combustion) > 10 then
                    cooldowns()
                end

                if gameState.hasCombustion then
                    -- CDs inside Combustion per SimC (potion and trinkets when buff.remains > 6s)
                    if player:BuffRemains(buffs.combustion) > 6000 then
                        local damagePotion = Action.GetToggle(2, "damagePotion")
                        local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
                        local potionExhausted = Action.GetToggle(2, "potionExhausted")
                        local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
                        local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

                        if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                            return damagePotionObject:Show(icon)
                        end

                        if Trinket(1, "Damage") then Trinket1() end
                        if Trinket(2, "Damage") then Trinket2() end
                        SynapseEnhancer()
                    end

                    -- Hero talent path separation for combustion
                    if A.FrostfireBolt:IsTalentLearned() then
                        ffCombustion()
                    elseif A.SpellfireSpheres:IsTalentLearned() then
                        sfCombustion()
                    else
                        defaultCombustion()
                    end
                else
                    if Combustion.cd < 500 and shouldBurst() and player.inCombat then
                        if A.GetToggle(2, "holdCombustIB") and FireBlast.frac >= 2 and PhoenixFlames.frac >= 1 or not A.GetToggle(2, "holdCombustIB") then

                            local damagePotion = Action.GetToggle(2, "damagePotion")
                            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
                            local potionExhausted = Action.GetToggle(2, "potionExhausted")
                            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
                            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

                            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                                return damagePotionObject:Show(icon)
                            end

                            if Trinket(1, "Damage") then Trinket1() end
                            if Trinket(2, "Damage") then Trinket2() end
                            SynapseEnhancer()
                        end
                    end
                    -- Hero talent path separation for filler
                    if A.FrostfireBolt:IsTalentLearned() then
                        -- Frostfire Bolt (ff_filler) path
                        ffFiller()
                    elseif A.SpellfireSpheres:IsTalentLearned() then
                        -- Spellfire Spheres (sf_filler) path
                        sfFiller()
                    else
                        -- Default filler path
                        defaultFiller()
                    end
                end
            end

        end
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
    -- Don't poly during Combustion unless kill target is below 30%
    if player:Buff(buffs.combustion) and target.hp > 30 then return end

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

    -- Priority 1: ALWAYS poly healer if healer is NOT my target (no HP checks)
    if enemy.isHealer and not target.isHealer then
        Aware:displayMessage("Polymorph Healer", "Green", 1)
        return spell:Cast(enemy)
    end

    -- Priority 2: If target IS healer, poly a DPS instead
    if target.isHealer and not enemy.isHealer then
        -- Find the best DPS to poly: either bursting (has CDs) or highest HP
        local shouldPoly = false
        local reason = ""

        -- Poly DPS that is bursting (has offensive CDs active)
        if enemy.cds and enemy.hp > 40 then
            shouldPoly = true
            reason = "Polymorph DPS Bursting"
        -- Poly highest HP DPS (above 70% HP is considered high)
        elseif enemy.hp > 70 then
            shouldPoly = true
            reason = "Polymorph High HP DPS"
        end

        if shouldPoly then
            Aware:displayMessage(reason, "Purple", 1)
            return spell:Cast(enemy)
        end
    end

    -- Priority 3: Dragon's Breath follow-up
    if enemy:Debuff(debuffs.dragonsBreath) and enemy.hp > 70 then
        Aware:displayMessage("Polymorph Dragon's Breath", "Purple", 1)
        return spell:Cast(enemy)
    end

    -- Priority 4: Peel for low HP party members
    local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party2.hp > 0 and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        Aware:displayMessage("Polymorph To Peel", "Red", 1)
        return spell:Cast(enemy)
    end
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    Polymorph("arena", enemy)
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
    if targetForInterrupt(interrupts) then return TabTarget() end
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