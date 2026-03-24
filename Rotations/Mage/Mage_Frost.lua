if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 64 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local cacheContext     = MakuluFramework.Cache

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local Debounce         = MakuluFramework.debounceSpell
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID       = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { ignoreCasting = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { ignoreCasting = true } },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { ignoreCasting = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { ignoreCasting = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { ignoreCasting = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { ignoreCasting = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { ignoreCasting = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { ignoreCasting = true } },
    WarStomp = { ID = 20549, MAKULU_INFO = { ignoreCasting = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { ignoreCasting = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { ignoreCasting = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { ignoreCasting = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { ignoreCasting = true } },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { ignoreCasting = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { ignoreCasting = true } },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { ignoreCasting = true } },
    Fireblood = { ID = 265221, MAKULU_INFO = { ignoreCasting = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { ignoreCasting = true } },
    BullRush = { ID = 255654, MAKULU_INFO = { ignoreCasting = true } },
    AncestralCall = { ID = 274738, MAKULU_INFO = { ignoreCasting = true } },
    Haymaker = { ID = 287712, MAKULU_INFO = { ignoreCasting = true } },
    Regeneratin = { ID = 291944, MAKULU_INFO = { ignoreCasting = true } },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { ignoreCasting = true } }, 
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { ignoreCasting = true } }, 

    Frostbolt = { ID = 116, Texture = 388882, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast Frostbolt\n/cast Frostfire Bolt" },
    FireBlast = { ID = 108853, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FrostNova = { ID = 122, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Blink = { ID = 1953, MAKULU_INFO = { ignoreCasting = true } },
    ArcaneExplosion = { ID = 1449, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Counterspell = { ID = 2139, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ArcaneIntellect = { ID = 1459, MAKULU_INFO = { ignoreCasting = true } },
    SlowFall = { ID = 130, MAKULU_INFO = { ignoreCasting = true } },
    Polymorph = { ID = 118, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ConeOfCold = { ID = 120, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    TimeWarp = { ID = 80353, MAKULU_INFO = { ignoreCasting = true } },
    IceBarrier = { ID = 11426, MAKULU_INFO = { ignoreCasting = true } },
    IceBlock = { ID = 45438, Texture = 43543, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast !Ice Block\n/cast Ice Cold" },
    IceCold = { ID = 414658, Texture = 43543, MAKULU_INFO = { ignoreCasting = true } },
    Invisibility = { ID = 66, MAKULU_INFO = { ignoreCasting = true } },
    Spellsteal = { ID = 30449, MAKULU_INFO = { ignoreCasting = true } },
    RemoveCurse = { ID = 475, MAKULU_INFO = { ignoreCasting = true } },
    MirrorImage = { ID = 55342, MAKULU_INFO = { ignoreCasting = true } },
    AlterTime = { ID = 342245, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast !Alter Time" },
    MassPolymorph = { ID = 383121, MAKULU_INFO = { ignoreCasting = true } },
    Slow = { ID = 31589, MAKULU_INFO = { ignoreCasting = true } },
    RingOfFrost = { ID = 113724, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    IceNova = { ID = 157997, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    IceFloes = { ID = 108839, MAKULU_INFO = { ignoreCasting = true }, Macro = "/castsequence reset=1 Ice Floes, Languages" },
    BlastWave = { ID = 157981, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    GreaterInvisibility = { ID = 110959, MAKULU_INFO = { ignoreCasting = true } },
    DragonsBreath = { ID = 31661, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Supernova = { ID = 157980, FixedTexture = 134153, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShiftingPower = { ID = 382440, FixedTexture = 3636841, MAKULU_INFO = { ignoreMoving = true, ignoreCasting = true } },
    Displacement = { ID = 389713, MAKULU_INFO = { ignoreCasting = true } },
    MassBarrier = { ID = 414660, MAKULU_INFO = { ignoreCasting = true } },
    MassInvisibility = { ID = 414664, MAKULU_INFO = { ignoreCasting = true } },

    Blizzard = { ID = 190356, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }, Macro = "/cast [@cursor]spell:thisID" },
    ColdSnap = { ID = 235219, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    IceLance = { ID = 30455, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FrozenOrb = { ID = 84714, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Flurry = { ID = 44614, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CometStorm = { ID = 153595, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    IcyVeins = { ID = 12472, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    RayOfFrost = { ID = 205021, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true } },
    GlacialSpike = { ID = 199786, MAKULU_INFO = { damageType = "magic", ignoreMoving = true, ignoreCasting = true, ignoreResource = true } },
    Freeze = { ID = 33395, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    FrostfireBolt = { ID = 431044, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    IceForm = { ID = 198144, MAKULU_INFO = { ignoreCasting = true } },
    FrostBomb = { ID = 390612, MAKULU_INFO = { ignoreCasting = true } },
    Snowdrift = { ID = 387794, MAKULU_INFO = { ignoreCasting = true } },
    RingOfFire = { ID = 353082, MAKULU_INFO = { ignoreCasting = true } },
    IceWall = { ID = 352278, MAKULU_INFO = { ignoreCasting = true } },

    IceCaller = { ID = 236662, Hidden = true }, 
    FracturedFrost = { ID = 378448, Hidden = true },
    ColdestSnap = { ID = 417493, Hidden = true },
    DeathsChill = { ID = 450331, Hidden = true },
    FreezingRain = { ID = 270233, Hidden = true },
    SplinteringCold = { ID = 379049, Hidden = true },
    IceColdTalent = { ID = 414659, Hidden = true },
    Splinterstorm = { ID = 443742, Hidden = true },
    ColdFront = { ID = 382110, Hidden = true },
    SlickIce = { ID = 382144, Hidden = true },
    FrozenTouch = { ID = 205030, Hidden = true },
    DeepShatter = { ID = 378749, Hidden = true },
    ExcessFrost = { ID = 438600, Hidden = true },
    IsothermicCore = { ID = 431095, Hidden = true },
    SplinteringRay = { ID = 418733, Hidden = true },
    UnerringProficiency = { ID = 444974, Hidden = true },

    AlterTimeCancel = { ID = 342247, Hidden = false, FixedTexture = 133667, Macro = "/cancelaura Alter Time" }, -- Universal1
    AlterTimeBack = { ID = 342247, Hidden = false, FixedTexture = 133663, Macro = "/cast Alter Time" }, -- Universal2

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

Action[ACTION_CONST_MAGE_FROST] = A

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
    imCastingName = nil,
    imCastingRemaining = 0,
    prevGCD = nil,
    shouldAoE = false,
    activeEnemies = 0,
    enemiesInMelee = 0,
    fightRemains = 0,
    aoeCount = 7 - (3 * num(A.IceCaller:IsTalentLearned())),
    cursorCheck = false,
    freezable = false,
    deathsChillStack = 0,
    wintersChillStacks = 0,
    isFrozen = false,
    icicles = 0,
    excessFrost = 0,
    excessFire = 0,
    alterTimeActive = false,
    alterSnapshot = nil,
    bombFlurry = false,
    holdFlurry = false,
    holdRay = false,
    boltspam = false,
    stFF = false,
    prevGlacialSpike = false,
}

local buffs = {
    mirrorImage = 55342,
    iceFloes = 108839,
    icyVeins = 12472,
    deathsChill = 454371,
    freezingRain = 270232,
    fingersOfFrost = 44544,
    icicles = 205473,
    brainFreeze = 190446,
    excessFrost = 438611,
    excessFire = 438624,
    frostMastery = 431039,
    frostfireEmpowerment = 431177,
    alterTime = 342246,
    iceBlock = 45438,
}

local debuffs = {
    wintersChill = 228358,
    iceNova = 157997,
    frostNova = 122,
    freeze = 33395,
    glacialSpike = 228600,
    frostBomb = 390612,
    dragonsBreath = 31661,
    polymorph = 118,
}

local function num(val)
    if val then return 1 else return 0 end
end

local interrupts = {
    { spell = Counterspell },
    { spell = DragonsBreath, isCC = true, aoe = true, distance = 8 },
    { spell = Supernova, isCC = true },
}

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

        for enemyGUID in pairs(activeEnemies) do 
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance < 10 + (5 * num(A.GetToggle(2, "cocRange") == "15")) and not enemy:IsTotem() and not enemy.isPet then 
                total = total + 1
            end 
        end  
        
        return total 
    end)
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
            elseif enemy.ttd > 0 and enemy.ttd > highest then
                highest = enemy.ttd
            end
        end
        
        return highest
    end)
end

local function predIcicles() 
    local incIcicles = 0
    local currentIcicles = player:HasBuffCount(buffs.icicles)


    if gs.imCasting and (gs.imCasting == Frostbolt.id or gs.imCasting == FrostfireBolt.id) then
        incIcicles = 1
    end
        
    local predictedIcicles = currentIcicles + incIcicles

    if gs.imCasting and gs.imCasting == GlacialSpike.id then
        predictedIcicles = 0
    end

    return math.min(predictedIcicles, 5)
end

local function predExcessFrost()
   
    local frostSpells = {
        Frostbolt.id,
        FrostfireBolt.id,
        Blizzard.id,
        GlacialSpike.id,
    }

    local frostMasteryStacks = player:HasBuffCount(buffs.frostMastery)

    if gs.imCasting then
        for _, spell in pairs(frostSpells) do
            if frostMasteryStacks + num(gs.imCasting == spell) == 6 then
                return true
            end
        end
    end

    if player:Buff(buffs.excessFrost) then
        return true
    end
    return false
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

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local currentCastName = casting and casting.name
    local remains = casting and casting.remaining
    local length = casting and casting.castLength

    return currentCast, currentCastName, remains, length
end

local lastUpdateTime = 0
local updateDelay = 0.3
local function updategs()
    local currentTime = GetTime() 
    local currentCast, currentCastName, currentCastRemains, currentCastLength = myCast()
    gs.imCastingRemaining = currentCastRemains
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.imCastingName = currentCastName
        gs.icicles = predIcicles()
        lastUpdateTime = currentTime 
    end

    local cursorCondition = (IceLance:InRange(mouseover) or SlowFall:InRange(mouseover)) and (mouseover.canAttack or mouseover:IsMelee() or mouseover:IsPet())
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gs.shouldAoE = A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gs.activeEnemies = activeEnemies()
    gs.enemiesInMelee = enemiesInMelee()
    gs.fightRemains = fightRemains()
    gs.shouldOrb = gs.fightRemains >= (A.GetToggle(2, "orbTTD") * 1000)

    --[[gs.excessFrost = predExcessFrost()
    local generatingExcessFire = gs.imCasting and player:HasBuffCount(buffs.fireMastery) + num(gs.imCasting == FrostfireBolt.id) == 6
    gs.excessFire = player:Buff(buffs.excessFire) or generatingExcessFire
    gs.excessFireStacks = player:HasBuffCount(buffs.excessFire) + num(generatingExcessFire)]]

    gs.excessFrost = player:Buff(buffs.excessFrost)
    gs.excessFire = player:Buff(buffs.excessFire)
    gs.excessFireStacks = player:HasBuffCount(buffs.excessFire)

    local stackingDeathsChill = player:Buff(buffs.icyVeins) and player:TalentKnown(DeathsChill.id) and gs.imCasting and (gs.imCasting == Frostbolt.id or gs.imCasting == FrostfireBolt.id)
    gs.deathsChillStack = player:HasBuffCount(buffs.deathsChill, true) + num(stackingDeathsChill)
   
    gs.wintersChillStacks = math.max(0, target:HasDeBuffCount(debuffs.wintersChill, true) - num(gs.imCasting))
    gs.isFrozen = target:Debuff(debuffs.iceNova) or target:Debuff(debuffs.frostNova) or target:Debuff(debuffs.freeze) or target:Debuff(debuffs.glacialSpike) or gs.wintersChillStacks > 0
    gs.freezable = (target.player and not target.magicImmune) or (not target.player and not target.isBoss) and not gs.isFrozen

    if player:Buff(buffs.alterTime) then
        if not gs.alterTimeActive then
            gs.alterSnapshot = player.hp 
            gs.alterTimeActive = true
        end
    else
        gs.alterTimeActive = false
    end

    gs.bombFlurry = target.canAttack and gs.wintersChillStacks == 0 and target:DebuffRemains(debuffs.frostBomb, true) >= 2 and target:Debuff(debuffs.frostBomb, true) and target:DebuffRemains(debuffs.frostBomb, true) < 3.5
    gs.holdFlurry = Flurry.frac <= 1.9 and (FrostBomb:Cooldown() < 300 or FrostBomb:Cooldown() < 5000)
    gs.holdRay = target:Debuff(debuffs.frostBomb, true) and gs.wintersChillStacks == 0

    gs.boltspam = player:TalentKnown(Splinterstorm.id) and player:TalentKnown(ColdFront.id) and player:TalentKnown(SlickIce.id) and player:TalentKnown(DeathsChill.id) and player:TalentKnown(FrozenTouch.id) or player:TalentKnown(FrostfireBolt.id) and player:TalentKnown(DeepShatter.id) and player:TalentKnown(SlickIce.id) and player:TalentKnown(DeathsChill.id)

    gs.stFF = player:TalentKnown(FrostfireBolt.id)

    gs.frostboltInFlight = A.Frostbolt:IsSpellInFlight() or A.FrostfireBolt:IsSpellInFlight()
    gs.prevGlacialSpike = Player:PrevGCD(1, A.GlacialSpike) or gs.imCasting and gs.imCasting == GlacialSpike.id
    gs.prevFrostbolt = Player:PrevGCD(1, A.Frostbolt) or Player:PrevGCD(1, A.FrostfireBolt) or gs.imCasting and (gs.imCasting == Frostbolt.id or gs.imCasting == FrostfireBolt.id)
end

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
    if player:Buff(buffs.alterTime) then return end

    return spell:Cast(player)
end)

IceCold:Callback(function(spell)
    if not player:TalentKnown(IceColdTalent.id) then return end
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end    
    
    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "iceBlockHP") then 
        return spell:Cast(player)
    end
end)

MassBarrier:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end   

    if not player.inCombat then return end

    if shouldDefensive() or player.hp < A.GetToggle(2, "massBarrierHP") then 
        return spell:Cast(player)
    end
end)

MirrorImage:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end   

    if not player.inCombat then return end

    if not shouldDefensive() then return end

    return spell:Cast(player)
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

IceBarrier:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[5] then return end   

    if UnitGetTotalAbsorbs("player") > 0 then return end

    if not player.inCombat then 
        return spell:Cast(player)
    end

    if shouldDefensive() or player.hp <= A.GetToggle(2, "iceBarrierHP") then 
        return spell:Cast(player)
    end
end)


------------------------------
---Movement------------------

ConeOfCold:Callback("movement", function(spell)
    if player:TalentKnown(ColdestSnap.id) then return end
    if gs.enemiesInMelee < 2 then return end

    return spell:Cast()
end)

ArcaneExplosion:Callback("movement", function(spell)
    if gs.enemiesInMelee < 2 then return end

    return spell:Cast()
end)

FireBlast:Callback("movement", function(spell)

    return spell:Cast(target)
end)

IceLance:Callback("movement", function(spell)

    return spell:Cast(target)
end)

local function movement()
    ConeOfCold("movement")
    ArcaneExplosion("movement")
    FireBlast("movement")
    IceLance("movement")
end


------------------------------
---Cooldowns------------------

-- actions.cds+=/icy_veins,if=buff.icy_veins.remains<1.5&(talent.frostfire_bolt|active_enemies>=3)
IcyVeins:Callback("cds", function(spell)
    if player:TalentKnown(IceForm.id) and IceForm.cd > 300 then return end
    if player:BuffRemains(buffs.icyVeins) > A.GetGCD() * 1500 then return end

    if player:TalentKnown(FrostfireBolt.id) or gs.activeEnemies >= 3 then
        return spell:Cast()
    end
end)

-- actions.cds+=/frozen_orb,if=time=0&active_enemies>=3
FrozenOrb:Callback("cds", function(spell)
    if player.combatTime > 1 then return end
    if gs.activeEnemies < 3 then return end

    return spell:Cast()
end)

-- actions.cds+=/flurry,if=time=0&active_enemies<=2
Flurry:Callback("cds", function(spell)
    if player.combatTime > 2 then return end
    if gs.wintersChillStacks > 0 then return end
    if Player:PrevGCD(1, A.Flurry) then return end
    if gs.activeEnemies > 2 then return end

    return spell:Cast(target)
end)

-- actions.cds+=/icy_veins,if=buff.icy_veins.remains<1.5&talent.splinterstorm
IcyVeins:Callback("cds2", function(spell)
    if player:TalentKnown(IceForm.id) and IceForm.cd > 300 then return end
    if player:BuffRemains(buffs.icyVeins) > A.GetGCD() * 1500 then return end

    if player:TalentKnown(Splinterstorm.id) then
        return spell:Cast()
    end
end)

BloodFury:Callback("cds", function(spell)

    return spell:Cast()
end)

Berserking:Callback("cds", function(spell)
    if player:BuffRemains(buffs.icyVeins) > 10000 and player:BuffRemains(buffs.icyVeins) < 15000 then
        return spell:Cast()
    end
end)

LightsJudgment:Callback("cds", function(spell)

    return spell:Cast(target)
end)

Fireblood:Callback("cds", function(spell)

    return spell:Cast()
end)

AncestralCall:Callback("cds", function(spell)

    return spell:Cast()
end)

local function cds()
    IcyVeins("cds")
    FrozenOrb("cds")
    Flurry("cds")
    IcyVeins("cds2")
    BloodFury("cds")
    Berserking("cds")
    LightsJudgment("cds")
    Fireblood("cds")
    AncestralCall("cds")
end

------------------------------
---Pre-Combat-----------------

MirrorImage:Callback("pre", function(spell)
    if player.inCombat and not shouldDefensive() then return end
    if BossMods:HasAnyAddon() and BossMods:GetPullTimer() > 6 then return end
    if MakMulti.party:Size() <= 5 then return end

    return spell:Cast()
end)

GlacialSpike:Callback("pre", function(spell)
    if gs.icicles < 5 then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if player.inCombat then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

Blizzard:Callback("pre", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting then return end
    if player.inCombat then return end

    if gs.activeEnemies >= 4 then 
        return spell:Cast()
    end

    if gs.activeEnemies >= 2 and player:TalentKnown(IceCaller.id) and not player:TalentKnown(FracturedFrost.id) then
        return spell:Cast()
    end
end)

Frostbolt:Callback("pre", function(spell)
    if gs.imCasting then return end
    if player.inCombat then return end
    if gs.activeEnemies > 3 then return end

    return spell:Cast(target)
end)

------------------------------
---Frostfire------------------

-- actions.aoe_ff=frostfire_bolt,if=talent.deaths_chill&buff.icy_veins.remains>9&(buff.deaths_chill.stack<9|buff.deaths_chill.stack=9&!action.frostfire_bolt.in_flight)
Frostbolt:Callback("ff-aoe", function(spell)
    if not player:TalentKnown(DeathsChill.id) then return end
    if player:BuffRemains(buffs.icyVeins) < 9000 then return end
    if gs.deathsChillStack > 9 then return end

    return spell:Cast(target)
end)

-- actions.aoe_ff+=/cone_of_cold,if=talent.coldest_snap&prev_gcd.1.comet_storm
ConeOfCold:Callback("ff-aoe", function(spell)
    if not player:TalentKnown(ColdestSnap.id) then return end
    if gs.enemiesInMelee < 3 then return end
    if FrozenOrb.cd < 700 + (A.GetToggle(2, "orbCocCD") * 1000) then return end

    if Player:PrevGCD(1, A.CometStorm) or CometStorm.used < 2000 then
        return spell:Cast()
    end 
end)

-- actions.aoe_ff+=/freeze,if=freezable&(prev_gcd.1.glacial_spike|prev_gcd.1.comet_storm&time-action.cone_of_cold.last_used>8)
Freeze:Callback("ff-aoe", function(spell)
    if not gs.cursorCheck then return end
    if not gs.freezable then return end
    if gs.isFrozen then return end

    if gs.prevGlacialSpike or not player:TalentKnown(GlacialSpike.id) and ConeOfCold.used < 8000 then
        return spell:Cast()
    end
end)

-- actions.aoe_ff+=/ice_nova,if=freezable&!prev_off_gcd.freeze&(prev_gcd.1.glacial_spike&remaining_winters_chill=0&debuff.winters_chill.down|prev_gcd.1.comet_storm&time-action.cone_of_cold.last_used>8)
IceNova:Callback("ff-aoe", function(spell)
    if not gs.freezable then return end
    if Freeze.used < 1000 then return end

    if gs.prevGlacialSpike and gs.wintersChillStacks == 0 and not target:Debuff(debuffs.wintersChill) or Player:PrevGCD(1, A.CometStorm) and ConeOfCold.used > 8000 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ff+=/frozen_orb
FrozenOrb:Callback("ff-aoe", function(spell)
    if not gs.shouldOrb then return end
    
    return spell:Cast()
end)

-- actions.aoe_ff+=/ice_lance,if=buff.excess_fire.stack=2&action.comet_storm.cooldown_react
IceLance:Callback("ff-aoe", function(spell)
    if gs.excessFireStacks < 2 then return end

    if player:TalentKnown(CometStorm.id) and CometStorm.cd < 500 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ff+=/blizzard,if=talent.ice_caller|talent.freezing_rain
Blizzard:Callback("ff-aoe", function(spell)
    if player.moving and not player:Buff(buffs.freezingRain) and not player:Buff(buffs.iceFloes) then return end
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:TalentKnown(IceCaller.id) then
        return spell:Cast()
    end
    
    if player:TalentKnown(FreezingRain.id) then
        return spell:Cast()
    end
end)

-- actions.aoe_ff+=/comet_storm,if=cooldown.cone_of_cold.remains>10|cooldown.cone_of_cold.ready
CometStorm:Callback("ff-aoe", function(spell)
    if ConeOfCold.cd < 500 then
        return spell:Cast(target)
    end

    if ConeOfCold.cd > 10000 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ff+=/ray_of_frost,if=talent.splintering_ray&remaining_winters_chill
RayOfFrost:Callback("ff-aoe", function(spell)
    if not player:TalentKnown(SplinteringRay.id) then return end
    if gs.wintersChillStacks < 1 then return end
    
    return spell:Cast(target)
end)

-- actions.aoe_ff+=/glacial_spike,if=buff.icicles.react=5
GlacialSpike:Callback("ff-aoe", function(spell)
    if gs.icicles < 5 then return end
    
    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end
    
    return spell:Cast(target)
end)

-- actions.aoe_ff+=/flurry,if=cooldown_react&buff.excess_fire.up&buff.excess_frost.up
-- actions.aoe_ff+=/flurry,if=cooldown_react&remaining_winters_chill=0&debuff.winters_chill.down
Flurry:Callback("ff-aoe", function(spell)
    if gs.excessFrost and gs.excessFire then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks < 1 and not target:Debuff(debuffs.wintersChill) then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ff+=/frostfire_bolt,if=buff.frostfire_empowerment.react&!buff.excess_fire.up
Frostbolt:Callback("ff-aoe2", function(spell)
    if not player:Buff(buffs.frostfireEmpowerment) then return end
    if gs.excessFire then return end

    return spell:Cast(target)
end)

-- actions.aoe_ff+=/shifting_power,if=cooldown.icy_veins.remains>10&cooldown.frozen_orb.remains>10&(!talent.comet_storm|cooldown.comet_storm.remains>10)
ShiftingPower:Callback("ff-aoe", function(spell)
    if not shouldBurst() then return end
    if IcyVeins.cd < 10000 then return end
    if FrozenOrb.cd < 10000 then return end
    if player:TalentKnown(CometStorm.id) and CometStorm.cd < 10000 then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
        if floes[3] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

-- actions.aoe_ff+=/ice_lance,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ff-aoe2", function(spell)
    if player:Buff(buffs.fingersOfFrost) then 
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ff+=/frostfire_bolt
Frostbolt:Callback("ff-aoe3", function(spell)

    return spell:Cast(target)
end)

-- actions.aoe_ff+=/call_action_list,name=movement

local function ffaoe()
    Frostbolt("ff-aoe")
    ConeOfCold("ff-aoe")
    Freeze("ff-aoe")
    IceNova("ff-aoe")
    FrozenOrb("ff-aoe")
    IceLance("ff-aoe")
    Blizzard("ff-aoe")
    CometStorm("ff-aoe")
    RayOfFrost("ff-aoe")
    GlacialSpike("ff-aoe")
    Flurry("ff-aoe")
    Frostbolt("ff-aoe2")
    ShiftingPower("ff-aoe")
    IceLance("ff-aoe2")
    Frostbolt("ff-aoe3")
    movement()
end

-- actions.cleave_ff=frostfire_bolt,if=talent.deaths_chill&buff.icy_veins.remains>9&(buff.deaths_chill.stack<4|buff.deaths_chill.stack=4&!action.frostfire_bolt.in_flight)
Frostbolt:Callback("ff-cleave", function(spell)
    if player:BuffRemains(buffs.icyVeins) < 9000 then return end
    if not player:TalentKnown(DeathsChill.id) then return end
    if gs.deathsChillStack > 4 then return end

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/freeze,if=freezable&prev_gcd.1.glacial_spike
Freeze:Callback("ff-cleave", function(spell)
    if not gs.freezable then return end
    if not gs.prevGlacialSpike then return end

    return spell:Cast()
end)

-- actions.cleave_ff+=/ice_nova,if=freezable&prev_gcd.1.glacial_spike&remaining_winters_chill=0&debuff.winters_chill.down&!prev_off_gcd.freeze
IceNova:Callback("ff-cleave", function(spell)
    if not gs.freezable then return end
    if not gs.prevGlacialSpike then return end
    if gs.wintersChillStacks > 0 then return end
    if Freeze.used < 1000 then return end

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/flurry,target_if=min:debuff.winters_chill.stack,if=cooldown_react&prev_gcd.1.glacial_spike&!prev_off_gcd.freeze
-- actions.cleave_ff+=/flurry,if=cooldown_react&(buff.icicles.react<5|!talent.glacial_spike)&remaining_winters_chill=0&debuff.winters_chill.down&(prev_gcd.1.frostfire_bolt|prev_gcd.1.comet_storm)
-- actions.cleave_ff+=/flurry,if=cooldown_react&(buff.icicles.react<5|!talent.glacial_spike)&buff.excess_fire.up&buff.excess_frost.up
Flurry:Callback("ff-cleave", function(spell)
    if gs.prevGlacialSpike and Freeze.used > 1000 then
        return spell:Cast(target)
    end

    if (gs.icicles < 5 or not player:TalentKnown(GlacialSpike.id)) and gs.wintersChillStacks < 1 and (gs.prevFrostbolt or Player:PrevGCD(1, A.CometStorm)) then
        return spell:Cast(target)
    end

    if (gs.icicles < 5 or not player:TalentKnown(GlacialSpike.id)) and gs.excessFrost and gs.excessFire then
        return spell:Cast(target)
    end
end)

-- actions.cleave_ff+=/comet_storm
CometStorm:Callback("ff-cleave", function(spell)

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/frozen_orb
FrozenOrb:Callback("ff-cleave", function(spell)
    if not gs.shouldOrb then return end

    return spell:Cast()
end)

-- actions.cleave_ff+=/blizzard,if=buff.freezing_rain.up&talent.ice_caller
Blizzard:Callback("ff-cleave", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if not player:TalentKnown(IceCaller.id) then return end
    if not player:Buff(buffs.freezingRain) then return end

    return spell:Cast()
end)

-- actions.cleave_ff+=/glacial_spike,if=buff.icicles.react=5
GlacialSpike:Callback("ff-cleave", function(spell)
    if gs.icicles < 5 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/ray_of_frost,target_if=max:debuff.winters_chill.stack,if=remaining_winters_chill=1
RayOfFrost:Callback("ff-cleave", function(spell)
    if gs.wintersChillStacks ~= 1 then return end
    
    return spell:Cast(target)
end)

-- actions.cleave_ff+=/frostfire_bolt,if=buff.frostfire_empowerment.react&!buff.excess_fire.up
Frostbolt:Callback("ff-cleave2", function(spell)
    if not player:Buff(buffs.frostfireEmpowerment) then return end
    if gs.excessFire then return end

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/shifting_power,if=cooldown.icy_veins.remains>10&cooldown.frozen_orb.remains>10&(!talent.comet_storm|cooldown.comet_storm.remains>10)&(!talent.ray_of_frost|cooldown.ray_of_frost.remains>10)
ShiftingPower:Callback("ff-cleave", function(spell)
    if not shouldBurst() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if IcyVeins.cd < 10000 then return end
    if FrozenOrb.cd < 10000 then return end
    if player:TalentKnown(CometStorm.id) and CometStorm.cd < 10000 then return end
    if player:TalentKnown(RayOfFrost.id) and RayOfFrost.cd < 10000 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
        if floes[3] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

-- actions.cleave_ff+=/ice_lance,target_if=max:debuff.winters_chill.stack,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ff-cleave", function(spell)
    if player:Buff(buffs.fingersOfFrost) then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.cleave_ff+=/frostbolt
Frostbolt:Callback("ff-cleave3", function(spell)

    return spell:Cast(target)
end)

-- actions.cleave_ff+=/call_action_list,name=movement

local function ffcleave()
    Frostbolt("ff-cleave")
    Freeze("ff-cleave")
    IceNova("ff-cleave")
    Flurry("ff-cleave")
    CometStorm("ff-cleave")
    FrozenOrb("ff-cleave")
    Blizzard("ff-cleave")
    GlacialSpike("ff-cleave")
    RayOfFrost("ff-cleave")
    Frostbolt("ff-cleave2")
    ShiftingPower("ff-cleave")
    IceLance("ff-cleave")
    Frostbolt("ff-cleave3")
    movement()
end

-- actions.st_ff=flurry,if=cooldown_react&(buff.icicles.react<5|!talent.glacial_spike)&remaining_winters_chill=0&debuff.winters_chill.down&(prev_gcd.1.glacial_spike|prev_gcd.1.frostfire_bolt|prev_gcd.1.comet_storm)
-- actions.st_ff+=/flurry,if=cooldown_react&(buff.icicles.react<5|!talent.glacial_spike)&buff.excess_fire.up&buff.excess_frost.up
Flurry:Callback("ff-st", function(spell)
    if (gs.icicles < 5 or not player:TalentKnown(GlacialSpike.id)) and gs.wintersChillStacks < 1 and (gs.prevGlacialSpike or gs.prevFrostbolt or Player:PrevGCD(1, A.CometStorm)) then
        return spell:Cast(target)
    end

    if (gs.icicles < 5 or not player:TalentKnown(GlacialSpike.id)) and gs.excessFrost and gs.excessFire then
        return spell:Cast(target)
    end
end)

-- actions.st_ff+=/comet_storm
CometStorm:Callback("ff-st", function(spell)

    return spell:Cast(target)
end)

-- actions.st_ff+=/glacial_spike,if=buff.icicles.react=5
GlacialSpike:Callback("ff-st", function(spell)
    if gs.icicles < 5 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

-- actions.st_ff+=/ray_of_frost,if=remaining_winters_chill=1
RayOfFrost:Callback("ff-st", function(spell)
    if gs.wintersChillStacks ~= 1 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[2] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

-- actions.st_ff+=/frozen_orb
FrozenOrb:Callback("ff-st", function(spell)
    if not gs.shouldOrb then return end
    
    return spell:Cast()
end)

-- actions.st_ff+=/shifting_power,if=cooldown.icy_veins.remains>10&cooldown.frozen_orb.remains>10&(!talent.comet_storm|cooldown.comet_storm.remains>10)&(!talent.ray_of_frost|cooldown.ray_of_frost.remains>10)
ShiftingPower:Callback("ff-st", function(spell)
    if not shouldBurst() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if IcyVeins.cd < 10000 then return end
    if FrozenOrb.cd < 10000 then return end
    if player:TalentKnown(CometStorm.id) and CometStorm.cd < 10000 then return end
    if player:TalentKnown(RayOfFrost.id) and RayOfFrost.cd < 10000 then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
        if floes[3] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

-- actions.st_ff+=/ice_lance,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ff-st", function(spell)
    if player:Buff(buffs.fingersOfFrost) then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.st_ff+=/frostbolt
Frostbolt:Callback("ff-st", function(spell)

    return spell:Cast(target)
end)

-- actions.st_ff+=/call_action_list,name=movement

local function ffst()
    Flurry("ff-st")
    CometStorm("ff-st")
    GlacialSpike("ff-st")
    RayOfFrost("ff-st")
    FrozenOrb("ff-st")
    ShiftingPower("ff-st")
    IceLance("ff-st")
    Frostbolt("ff-st")
    movement()
end


------------------------------
---Spellslinger---------------

-- actions.aoe_ss=cone_of_cold,if=talent.coldest_snap&!action.frozen_orb.cooldown_react&(prev_gcd.1.comet_storm|prev_gcd.1.frozen_orb&cooldown.comet_storm.remains>5)&(!talent.deaths_chill|buff.icy_veins.remains<9|buff.deaths_chill.stack>=15)
ConeOfCold:Callback("ss-aoe", function(spell)
    if not player:TalentKnown(ColdestSnap.id) then return end
    if gs.enemiesInMelee < 3 then return end
    if FrozenOrb.cd < 700 + (A.GetToggle(2, "orbCocCD") * 1000) then return end
    
    if (Player:PrevGCD(1, A.CometStorm) or CometStorm.used < 2000 or (Player:PrevGCD(1, A.FrozenOrb) and (not player:TalentKnown(CometStorm.id) or CometStorm.cd > 5000))) and (not player:TalentKnown(DeathsChill.id) or player:BuffRemains(buffs.icyVeins) < 9000 or gs.deathsChillStack >= 15) then
        return spell:Cast()
    end
end)

-- actions.aoe_ss+=/freeze,if=freezable&(prev_gcd.1.glacial_spike|!talent.glacial_spike)
Freeze:Callback("ss-aoe", function(spell)
    if not gs.cursorCheck then return end
    if not gs.freezable then return end

    if gs.prevGlacialSpike or not player:TalentKnown(GlacialSpike.id) then
        return spell:Cast()
    end
end)

-- actions.aoe_ss+=/flurry,if=cooldown_react&remaining_winters_chill=0&debuff.winters_chill.down&prev_gcd.1.glacial_spike
Flurry:Callback("ss-aoe", function(spell)
    if gs.wintersChillStacks > 0 then return end

    if gs.prevGlacialSpike then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ss+=/ice_nova,if=freezable&!prev_off_gcd.freeze&prev_gcd.1.glacial_spike&remaining_winters_chill=0&debuff.winters_chill.down
-- actions.aoe_ss+=/ice_nova,if=talent.unerring_proficiency&time-action.cone_of_cold.last_used<10&time-action.cone_of_cold.last_used>7
IceNova:Callback("ss-aoe", function(spell)
    if gs.freezable and Freeze.used > 1000 and gs.prevGlacialSpike and gs.wintersChillStacks == 0 then
        return spell:Cast(target)
    end

    if player:TalentKnown(UnerringProficiency.id) and ConeOfCold.used < 10000 and ConeOfCold.used > 7000 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ss+=/frozen_orb,if=cooldown_react
FrozenOrb:Callback("ss-aoe", function(spell)
    if not gs.shouldOrb then return end

    return spell:Cast()
end)

-- actions.aoe_ss+=/blizzard,if=talent.ice_caller|talent.freezing_rain
Blizzard:Callback("ss-aoe", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:TalentKnown(IceCaller.id) or player:TalentKnown(FreezingRain.id) then
        return spell:Cast()
    end
end)

-- actions.aoe_ss+=/frostbolt,if=talent.deaths_chill&buff.icy_veins.remains>9&(buff.deaths_chill.stack<12|buff.deaths_chill.stack=12&!action.frostbolt.in_flight)
Frostbolt:Callback("ss-aoe", function(spell)
    if not player:TalentKnown(DeathsChill.id) then return end
    if player:BuffRemains(buffs.icyVeins) <= 9000 then return end
    if gs.deathsChillStack > 12 then return end

    return spell:Cast(target)
end)

-- actions.aoe_ss+=/comet_storm
CometStorm:Callback("ss-aoe", function(spell)

    return spell:Cast(target)
end)

-- actions.aoe_ss+=/ray_of_frost,if=talent.splintering_ray&remaining_winters_chill&buff.icy_veins.down
RayOfFrost:Callback("ss-aoe", function(spell)
    if not player:TalentKnown(SplinteringRay.id) then return end
    if gs.wintersChillStacks < 1 then return end
    if player:Buff(buffs.icyVeins) then return end

    return spell:Cast(target)
end)

-- actions.aoe_ss+=/glacial_spike,if=buff.icicles.react=5&(action.flurry.cooldown_react|remaining_winters_chill|freezable&cooldown.ice_nova.ready)
GlacialSpike:Callback("ss-aoe", function(spell)
    if gs.icicles < 5 then return end

    if Flurry.cd < 500 or gs.wintersChillStacks > 0 or gs.freezable and player:TalentKnown(IceNova.id) and IceNova.cd < 500 then

        local floes = A.GetToggle(2, "floesSelect")
        if player:TalentKnown(IceFloes.id) then
            if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
                IceFloes:Cast()
                return spell:Cast(target)
            end
        end
    
        if player.moving and not player:Buff(buffs.iceFloes) then return end
        
        return spell:Cast(target)
    end
end)

-- actions.aoe_ss+=/shifting_power,if=cooldown.icy_veins.remains>10&(fight_remains+15>cooldown.icy_veins.remains)
ShiftingPower:Callback("ss-aoe", function(spell)
    if not shouldBurst() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if IcyVeins.cd < 10000 then return end
    if gs.fightRemains + 10000 < IcyVeins.cd then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
        if floes[3] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

-- actions.aoe_ss+=/ice_lance,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ss-aoe", function(spell)
    if player:Buff(buffs.fingersOfFrost) then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.aoe_ss+=/flurry,if=cooldown_react&remaining_winters_chill=0&debuff.winters_chill.down
Flurry:Callback("ss-aoe2", function(spell)
    if gs.wintersChillStacks > 0 then return end

    return spell:Cast(target)
end)

-- actions.aoe_ss+=/frostbolt
Frostbolt:Callback("ss-aoe2", function(spell)

    return spell:Cast(target)
end)

-- actions.aoe_ss+=/call_action_list,name=movement


local function ssaoe()
    ConeOfCold("ss-aoe")
    Freeze("ss-aoe")
    Flurry("ss-aoe")
    IceNova("ss-aoe")
    FrozenOrb("ss-aoe")
    Blizzard("ss-aoe")
    Frostbolt("ss-aoe")
    CometStorm("ss-aoe")
    RayOfFrost("ss-aoe")
    GlacialSpike("ss-aoe")
    ShiftingPower("ss-aoe")
    IceLance("ss-aoe")
    Flurry("ss-aoe2")
    Frostbolt("ss-aoe2")
    movement()
end

-- actions.cleave_ss=flurry,target_if=min:debuff.winters_chill.stack,if=cooldown_react&prev_gcd.1.glacial_spike&!prev_off_gcd.freeze
Flurry:Callback("ss-cleave", function(spell)
    if not gs.prevGlacialSpike then return end
    if Freeze.used < 1000 then return end

    return spell:Cast(target)
end)

--actions.cleave_ss+=/freeze,if=freezable&prev_gcd.1.glacial_spike
Freeze:Callback("ss-cleave", function(spell)
    if not gs.freezable then return end
    if not gs.prevGlacialSpike then return end

    return spell:Cast()
end)

-- actions.cleave_ss+=/ice_nova,if=freezable&!prev_off_gcd.freeze&remaining_winters_chill=0&debuff.winters_chill.down&prev_gcd.1.glacial_spike
IceNova:Callback("ss-cleave", function(spell)
    if not gs.freezable then return end
    if Freeze.used < 1000 then return end
    if not gs.prevGlacialSpike then return end
    if gs.wintersChillStacks > 0 then return end

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/flurry,if=cooldown_react&debuff.winters_chill.down&remaining_winters_chill=0&prev_gcd.1.frostbolt
Flurry:Callback("ss-cleave2", function(spell)
    if gs.wintersChillStacks > 0 then return end
    if not gs.prevFrostbolt then return end
    
    return spell:Cast(target)
end)

-- actions.cleave_ss+=/ice_lance,if=buff.fingers_of_frost.react=2
IceLance:Callback("ss-cleave", function(spell)
    if player:HasBuffCount(buffs.fingersOfFrost) < 2 then return end

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/comet_storm,if=remaining_winters_chill&buff.icy_veins.down
CometStorm:Callback("ss-cleave", function(spell)
    if gs.wintersChillStacks < 1 then return end
    if player:Buff(buffs.icyVeins) then return end

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/frozen_orb,if=cooldown_react&(cooldown.icy_veins.remains>30|buff.icy_veins.react)
FrozenOrb:Callback("ss-cleave", function(spell)
    if not gs.shouldOrb then return end

    if A.GetToggle(2, "orbWithoutBurst") and not shouldBurst() then
        return spell:Cast()
    end

    if IcyVeins.cd > 30000 then
        return spell:Cast()
    end

    if player:Buff(buffs.icyVeins) then
        return spell:Cast()
    end
end)

-- actions.cleave_ss+=/ray_of_frost,target_if=max:debuff.winters_chill.stack,if=prev_gcd.1.flurry&buff.icy_veins.down
RayOfFrost:Callback("ss-cleave", function(spell)
    if not Player:PrevGCD(1, A.Flurry) then return end
    if player:Buff(buffs.icyVeins) then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[2] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/glacial_spike,if=buff.icicles.react=5&(action.flurry.cooldown_react|remaining_winters_chill|freezable&cooldown.ice_nova.ready)
GlacialSpike:Callback("ss-cleave", function(spell)
    if gs.icicles < 5 then return end

    if Flurry.cd < 700 or gs.wintersChillStacks > 0 or (gs.freezable and IceNova.cd < 700) then

        local floes = A.GetToggle(2, "floesSelect")
        if player:TalentKnown(IceFloes.id) then
            if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
                IceFloes:Cast()
                return spell:Cast(target)
            end
        end
    
        if player.moving and not player:Buff(buffs.iceFloes) then return end
        
        return spell:Cast(target)
    end
end)

-- actions.cleave_ss+=/shifting_power,if=cooldown.icy_veins.remains>10&!action.flurry.cooldown_react&(fight_remains+15>cooldown.icy_veins.remains)
ShiftingPower:Callback("ss-cleave", function(spell)
    if not shouldBurst() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if IcyVeins.cd < 10000 then return end
    if Flurry.cd < A.GetGCD() * 1000 then return end
    if gs.fightRemains + 15000 < IcyVeins.cd then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
        if floes[3] and not player:Buff(buffs.iceFloes) then
            IceFloes:Cast()
            return spell:Cast()
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast()
end)

-- actions.cleave_ss+=/frostbolt,if=talent.deaths_chill&buff.icy_veins.remains>9&(buff.deaths_chill.stack<6|buff.deaths_chill.stack=6&!action.frostbolt.in_flight)
Frostbolt:Callback("ss-cleave", function(spell)
    if not player:TalentKnown(DeathsChill.id) then return end
    if player:BuffRemains(buffs.icyVeins) <= 9000 then return end
    if gs.deathsChillStack > 6 then return end

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/blizzard,if=talent.freezing_rain&talent.ice_caller
Blizzard:Callback("ss-cleave", function(spell)
    if not player:TalentKnown(FreezingRain.id) then return end
    if not player:TalentKnown(IceCaller.id) then return end

    return spell:Cast()
end)

-- actions.cleave_ss+=/ice_lance,target_if=max:debuff.winters_chill.stack,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ss-cleave2", function(spell)
    if player:Buff(buffs.fingersOfFrost) then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.cleave_ss+=/frostbolt
Frostbolt:Callback("ss-cleave2", function(spell)

    return spell:Cast(target)
end)

-- actions.cleave_ss+=/call_action_list,name=movement

local function sscleave()
    Flurry("ss-cleave")
    Freeze("ss-cleave")
    IceNova("ss-cleave")
    Flurry("ss-cleave2")
    IceLance("ss-cleave")
    CometStorm("ss-cleave")
    FrozenOrb("ss-cleave")
    RayOfFrost("ss-cleave")
    GlacialSpike("ss-cleave")
    ShiftingPower("ss-cleave")
    Frostbolt("ss-cleave")
    Blizzard("ss-cleave")
    IceLance("ss-cleave2")
    Frostbolt("ss-cleave2")
    movement()
end

-- actions.st_ss=flurry,if=cooldown_react&debuff.winters_chill.down&remaining_winters_chill=0&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt)
Flurry:Callback("ss-st", function(spell)
    if gs.wintersChillStacks > 0 then return end

    if gs.prevFrostbolt or gs.prevGlacialSpike then
        return spell:Cast(target)
    end
end)

-- actions.st_ss+=/comet_storm,if=remaining_winters_chill&buff.icy_veins.down
CometStorm:Callback("ss-st", function(spell)
    if gs.wintersChillStacks == 0 then return end
    if player:Buff(buffs.icyVeins) then return end

    return spell:Cast(target)
end)

-- actions.st_ss+=/frozen_orb,if=cooldown_react&(cooldown.icy_veins.remains>30|buff.icy_veins.react)
FrozenOrb:Callback("ss-st", function(spell)
    if not gs.shouldOrb then return end

    if A.GetToggle(2, "orbWithoutBurst") and not shouldBurst() then
        return spell:Cast()
    end

    if IcyVeins.cd > 30000 or player:Buff(buffs.icyVeins) then
        return spell:Cast()
    end
end)

-- actions.st_ss+=/ray_of_frost,if=prev_gcd.1.flurry
RayOfFrost:Callback("ss-st", function(spell)
    if not Player:PrevGCD(1, A.Flurry) then return end

    local floes = A.GetToggle(2, "floesSelect")
    if player:TalentKnown(IceFloes.id) then
        if floes[2] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
            IceFloes:Cast()
            return spell:Cast(target)
        end
    end

    if player.moving and not player:Buff(buffs.iceFloes) then return end

    return spell:Cast(target)
end)

-- actions.st_ss+=/glacial_spike,if=buff.icicles.react=5&(action.flurry.cooldown_react|remaining_winters_chill)
GlacialSpike:Callback("ss-st", function(spell)
    if gs.icicles < 5 then return end

    if Flurry.cd < 700 or gs.wintersChillStacks > 0 or Flurry.cd < GlacialSpike:CastTime() + A.GetGCD() * 1000 and Flurry.cd > 700 then

        local floes = A.GetToggle(2, "floesSelect")
        if player:TalentKnown(IceFloes.id) then
            if floes[1] and not player:Buff(buffs.iceFloes) and IceFloes.cd < 300 then
                IceFloes:Cast()
                return spell:Cast(target)
            end
        end
    
        if player.moving and not player:Buff(buffs.iceFloes) then return end
        
        return spell:Cast(target)
    end
end)

-- actions.st_ss+=/shifting_power,if=cooldown.icy_veins.remains>10&!action.flurry.cooldown_react&(fight_remains+15>cooldown.icy_veins.remains)
ShiftingPower:Callback("ss-st", function(spell)
    if not shouldBurst() then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if IcyVeins.cd < 10000 then return end
    if Flurry.cd < A.GetGCD() * 1000 then return end
    if gs.fightRemains + 15000 < IcyVeins.cd then return end

    if gs.boltspam or not player:Buff(buffs.icyVeins) or player:BuffRemains(buffs.icyVeins) > 10000 then

        local floes = A.GetToggle(2, "floesSelect")
        if player:TalentKnown(IceFloes.id) and IceFloes.cd < 500 and ShiftingPower.cd < 500 then
            if floes[3] and not player:Buff(buffs.iceFloes) then
                IceFloes:Cast()
                return spell:Cast()
            end
        end

        if player.moving and not player:Buff(buffs.iceFloes) then return end

        return spell:Cast()
    end
end)

-- actions.st_ss+=/ice_lance,if=buff.fingers_of_frost.react|remaining_winters_chill
IceLance:Callback("ss-st", function(spell)
    if player:Buff(buffs.fingersOfFrost) then
        return spell:Cast(target)
    end

    if gs.wintersChillStacks > 0 then
        return spell:Cast(target)
    end
end)

-- actions.st_ss+=/frostbolt
Frostbolt:Callback("ss-st", function(spell)

    return spell:Cast(target)
end)

-- actions.st_ss+=/call_action_list,name=movement

local function ssst()
    Flurry("ss-st")
    CometStorm("ss-st")
    FrozenOrb("ss-st")
    RayOfFrost("ss-st")
    GlacialSpike("ss-st")
    ShiftingPower("ss-st")
    IceLance("ss-st")
    Frostbolt("ss-st")
    movement()
end

------------------------------
---PvP------------------------

ColdSnap:Callback("pvp", function(spell)
    if IceBlock.cd <= 10000 then return end

    return spell:Cast()
end)

AlterTime:Callback("pvp", function(spell)
    if player:Buff(buffs.alterTime) then return end
    if player.hp > 90 then return end
    if player.hp < 70 then return end

    return spell:Cast()
end)

AlterTimeCancel:Callback("pvp", function(spell)
    if not player:Buff(buffs.alterTime) then return end
    if not gs.alterTimeActive then return end
    
    if player.hp <= 50 then
        return spell:Cast()
    end

    if player:BuffRemains(buffs.alterTime) < 2000 and player.hp < gs.alterSnapshot then
        return spell:Cast()
    end
end)

AlterTimeBack:Callback("pvp", function(spell)
    if not player:Buff(buffs.alterTime) then return end
    if not gs.alterTimeActive then return end
    if player:BuffRemains(buffs.alterTime) >= 2000 then return end
    if player.hp < gs.alterSnapshot then return end

    return spell:Cast()
end)

MassBarrier:Callback("pvp", function(spell)
    local party1 = party1.exists and party1.hp <= 50
    local party2 = party2.exists and party2.hp <= 50
    
    if party1 or party2 or player.hp <= 50 then
        return spell:Cast()
    end
end)

RingOfFire:Callback("pvp", function(spell)
    if target.hp < 30 then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if Player:IsMounted() then return end

    return spell:Cast()
end)

Flurry:Callback("pvp", function(spell)
    if not gs.bombFlurry then return end
    if gs.wintersChillStacks > 0 then return end
    if Player:PrevGCD(1, A.Flurry) then return end

    return spell:Cast(target)
end)

IceNova:Callback("pvp", function(spell)
    if player:TalentKnown(RingOfFrost.id) then return end
    --if not gs.bombFlurry then return end
    --if gs.wintersChillStacks > 0 then return end
    --if Player:PrevGCD(1, A.Flurry) then return end

    if player:TalentKnown(CometStorm.id) and not Player:PrevGCD(1, A.CometStorm) then return end

    return spell:Cast()
end)

FrostBomb:Callback("pvp", function(spell)
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    local flurryNova = Flurry.frac >= 1 or Flurry:Cooldown() < 2000 or (IceNova:Cooldown() < 300 and player:TalentKnown(IceNova.id))
    if not flurryNova then return end
    if gs.icicles < 5 and player:TalentKnown(GlacialSpike.id) then return end

    return spell:Cast(target)
end)

GlacialSpike:Callback("pvp", function(spell)
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if not player:TalentKnown(FrostBomb.id) then return end
    if FrostBomb.cd < 300 then return end

    if gs.icicles < 5 then return end

    if gs.wintersChillStacks == 0 and not target:Debuff(debuffs.frostBomb) then
        IceNova:Cast(target)
    end

    return spell:Cast(target)
end)

RayOfFrost:Callback("pvp", function(spell)
    if not shouldBurst() then return end
    if player.moving and not player:Buff(buffs.iceFloes) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.holdRay then return end

    return spell:Cast(target)
end)

FrostNova:Callback("pvp", function(spell)
    if arena1.exists and arena1.distance <= 8 and arena1.ccRemains > 500 then return end
    if arena2.exists and arena2.distance <= 8 and arena2.ccRemains > 500 then return end
    if arena3.exists and arena3.distance <= 8 and arena3.ccRemains > 500 then return end
    if gs.enemiesInMelee < 1 then return end

    return spell:Cast()
end)

BlastWave:Callback("pvp", function(spell)
    if gs.enemiesInMelee < 1 then return end

    return spell:Cast()
end)

ConeOfCold:Callback("pvp", function(spell)
    if player:TalentKnown(ColdestSnap.id) then return end
    if target.distance > 10 then return end

    return spell:Cast()
end)

local function pvpenis()
    IceNova("pvp")
    ColdSnap("pvp")
    AlterTime("pvp")
    AlterTimeCancel("pvp")
    AlterTimeBack("pvp")
    MassBarrier("pvp")
    RingOfFire("pvp")
    Flurry("pvp")
    FrostBomb("pvp")
    GlacialSpike("pvp")
    RayOfFrost("pvp")
    FrostNova("pvp")
    BlastWave("pvp")
    ConeOfCold("pvp")
end

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
        return spell:Cast(player)
    end
end)

A[3] = function(icon)
	FrameworkStart(icon)
    updategs()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Combat Time: ", player.combatTime)
        MakPrint(2, "Frostfire Bolt Known: ", player:TalentKnown(FrostfireBolt.id))
        MakPrint(3, "Death's Chill Stacks: ", gs.deathsChillStack)
        MakPrint(4, "Cursor Check: ", gs.cursorCheck)
        MakPrint(5, "Trigger AoE at: ", gs.aoeCount)
        MakPrint(6, "Active Enemies: ", gs.activeEnemies)
        MakPrint(7, "Target Distance: ", target.distance)
        MakPrint(8, "Iciles: ", gs.icicles)
        MakPrint(9, "Freezable: ", gs.freezable)
        MakPrint(10, "Winters Chill Stacks: ", gs.wintersChillStacks)
        MakPrint(11, "Excess Fire: ", gs.excessFire)
        MakPrint(12, "Excess Frost: ", gs.excessFrost)
    end

    local casting = player.castInfo
    if player.channeling then return end
    if player.casting and casting.remaining > 600 then return end

    Invisibility("feign") 
    GreaterInvisibility("feign") 
    if makFeign() and player.feigned then return end

    makInterrupt(interrupts)

    ArcaneIntellect()
    IceBlock()
    MassBarrier()
    IceCold()
    MirrorImage()
    GreaterInvisibility()

    if target.exists and target.canAttack and IceLance:InRange(target) then
        local awareAlert = A.GetToggle(2, "makAware")

        if awareAlert[1] then
            if player:Buff(buffs.iceFloes) then
                Aware:displayMessage("Ice Floes Up!", "Green", 1)
            end
        end
    
        if awareAlert[2] then
            if shouldBurst() then
                if not player:TalentKnown(IceFloes.id) and ShiftingPower.cd < 500 then
                    if CometStorm.cd > 10000 and player:TalentKnown(CometStorm.id) then
                        if gs.activeEnemies >= gs.aoeCount then
                            Aware:displayMessage("Shifting Power Soon!", "White", 1)
                        else
                            local cleave = gs.activeEnemies >= 2 and gs.activeEnemies <= 3 and A.GetToggle(2, "AoE")
                            if (not player:Buff(buffs.icyVeins) or cleave) and FrozenOrb.cd > 10000 and (RayOfFrost.cd > 10000 or not player:TalentKnown(RayOfFrost.id)) or IcyVeins.cd < 23000 then
                                Aware:displayMessage("Shifting Power Soon!", "White", 1)
                            end
                        end
                    end
                end
            end
        end
    
        if awareAlert[3] then
            if gs.icicles >= 5 and player:TalentKnown(GlacialSpike.id) and (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) and (Flurry.cd < 600 or gs.wintersChillStacks > 0) then
                Aware:displayMessage("Glacial Spike!", "Blue", 1)
            end
        end
    
        if awareAlert[4] then
            if player:TalentKnown(RayOfFrost.id) and (not player:TalentKnown(IceFloes.id) or IceFloes.frac < 1) then
                if (A.IsInPvP and not gs.holdRay or not A.IsInPvP) and RayOfFrost.cd < 300 then
                    Aware:displayMessage("Ray of Frost!", "Purple", 1)
                end
            end
        end
        
        IceBarrier()

        if A.IsInPvP then
            pvpenis()
        end

        MirrorImage("pre")
        Blizzard("pre")
        GlacialSpike("pre")
        Frostbolt("pre")
        Spellsteal("util")
        GreaterInvisibility("util")

        if shouldBurst() then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            cds()

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:BuffRemains(buffs.icyVeins) > 15
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
        end

        if player:TalentKnown(FrostfireBolt.id) then
            if gs.shouldAoE then
                if gs.activeEnemies >= 3 then
                    ffaoe()
                elseif gs.activeEnemies == 2 then
                    ffcleave()
                end
            end
        else
            if gs.shouldAoE then
                if gs.activeEnemies >= 3 then
                    ssaoe()
                elseif gs.activeEnemies == 2 then
                    sscleave()
                end
            end
        end

        if player:TalentKnown(FrostfireBolt.id) then
            ffst()
        else
            ssst()
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

local pvpCurse = {
    [334275] = true, -- Curse of Exhaustion
    [1714] = true, -- Curse of Tongues
    [702] = true, -- Curse of Weakness
    [442804] = true, -- Curse of the Satyr
}

RemoveCurse:Callback("arena", function(spell, friendly)
    if not RemoveCurse:InRange(friendly) then return end
    
    local delay = math.random(500, 1000)

    if friendly:HasDeBuffFromFor(pvpCurse, delay) then
        return spell:Cast(friendly)
    end
end)

Spellsteal:Callback("arena", function(spell, enemy)
    if not enemy:HasBuffFromFor(pvpSpellsteal, 500) then return end

    return spell:Cast(enemy)
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

    if target:Debuff(debuffs.frostBomb) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end    
    if enemy:IsTarget() then return end
    if enemy:BuffFrom(polyImmune) then return end
    if polymorphDuration() > Polymorph:CastTime() then return end
    if ccRemains > Polymorph:CastTime() + MakGcd() then return end
    if enemy.incapacitateDr < 0 then return end

    if enemy.isHealer and target.hp <= 70 then 
        Aware:displayMessage("Polymorph Healer", "Green", 1)
        return spell:Cast(enemy)
    end

    if enemy:Debuff(debuffs.dragonsBreath) and enemy.hp > 70 then
        Aware:displayMessage("Polymorph Dragon's Breath", "Purple", 1)
        return spell:Cast(enemy)
    end

    local peelParty = (party1.exists and party1.hp > 0 and party1.hp < 50) or (party2.exists and party2.hp > 0 and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        Aware:displayMessage("Polymorph To Peel", "Red", 1)
        return spell:Cast(enemy)
    end

    if enemy.cds and enemy.hp > 40 then
        Aware:displayMessage("Polymorph On Enemy CDs", "Red", 1)
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
    RemoveCurse("arena", friendly)
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
