if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 1467 then return end

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

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable


local ActionID       = {
    TailSwipe = { ID = 368970, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true  } },
    WingBuffet = { ID = 357214, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true  } },

    AzureStrike = { ID = 362969, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    BlessingOfTheBronze = { ID = 364342, MAKULU_INFO = {ignoreCasting = true } },
    CauterizingFlame = { ID = 374251, MAKULU_INFO = {ignoreCasting = true } },
    DeepBreath = { ID = 357210, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DeepBreathScale = { ID = 433874, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Disintegrate = { ID = 356995, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EmeraldBlossom = { ID = 355913, MAKULU_INFO = {ignoreCasting = true } },
    Expunge = { ID = 365585, MAKULU_INFO = {ignoreCasting = true } },
    FireBreath = { ID = 357208, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FireBreathToo = { ID = 382266, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    FuryOfTheAspects = { ID = 390386, MAKULU_INFO = {ignoreCasting = true } },
    Hover = { ID = 358267, MAKULU_INFO = {ignoreCasting = true } },
    Landslide = { ID = 358385, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    LivingFlame = { ID = 361469, MAKULU_INFO = {ignoreCasting = true } },
    LivingFlameDmg = { ID = 361469, Color = "BLUE", MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ObsidianScales = { ID = 363916, MAKULU_INFO = {ignoreCasting = true } },
    Quell = { ID = 351338, MAKULU_INFO = { damageType = "magic", offGcd = true, ignoreCasting = true } },
    RenewingBlaze = { ID = 374348, MAKULU_INFO = {ignoreCasting = true } },
    Return = { ID = 361227, MAKULU_INFO = {ignoreCasting = true } },
    TimeSpiral = { ID = 374968, MAKULU_INFO = {ignoreCasting = true } },
    SpatialParadox = { ID = 406732, MAKULU_INFO = {ignoreCasting = true } },
    TipTheScales = { ID = 370553, MAKULU_INFO = {ignoreCasting = true } },
    VerdantEmbrace = { ID = 360995, MAKULU_INFO = {ignoreCasting = true } },
    SleepWalk = { ID = 360806, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Unravel = { ID = 368432, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    OppressingRoar = { ID = 372048, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Rescue = { ID = 370665, MAKULU_INFO = {ignoreCasting = true } },
    SourceOfMagic = { ID = 369459, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Zephyr = { ID = 374227, MAKULU_INFO = {ignoreCasting = true } },

    Pyre = { ID = 357211, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EternitySurge = { ID = 359073, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    EternitySurgeToo = { ID = 382411, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Dragonrage = { ID = 375087, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Firestorm = { ID = 368847, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    ShatteringStar = { ID = 370452, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    ChronoLoop = { ID = 383005, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    TimeStop = { ID = 378441, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    SwoopUp = { ID = 370388, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    NullifyingShroud = { ID = 378464, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    Engulf = { ID = 443328, Color = "BLUE", MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    ScarletAdaptation = { ID = 372469, Hidden = true },
    RubyEmbers = { ID = 365937, Hidden = true },
    ImminentDestruction = { ID = 370781, Hidden = true },
    MeltArmor = { ID = 441176, Hidden = true },
    Maneuverability = { ID = 433871, Hidden = true },
    FontOfMagic = { ID = 411212, Hidden = true },
    EternitysSpan = { ID = 375757, Hidden = true },
    ScorchingEmbers = { ID = 370819, Hidden = true },
    ArcaneVigor = { ID = 386342, Hidden = true },
    FeedTheFlames = { ID = 369846, Hidden = true },
    Animosity = { ID = 375797, Hidden = true },
    EssenceAttunement = { ID = 375722, Hidden = true },
    Volatility = { ID = 369089, Hidden = true },
    Burnout = { ID = 375801, Hidden = true },
    Snapfire = { ID = 370783, Hidden = true },
    AncientFlame = { ID = 369990, Hidden = true },
    MassDisintegrate = { ID = 436335, Hidden = true },
    EventHorizon = { ID = 411164, Hidden = true },
    Enkindle = { ID = 444016, Hidden = true },
    FanTheFlames = { ID = 444318, Hidden = true },
    EngulfingBlaze = { ID = 370837, Hidden = true },
    Iridescence = { ID = 370867, Hidden = true },
    ChargedBlast = { ID = 370455, Hidden = true },
    ArcaneIntensity = { ID = 375618, Hidden = true },
    FlameSiphon = { ID = 444140, Hidden = true },
    PowerSwell = { ID = 370839, Hidden = true },
    BlastFurnace = { ID = 375510, Hidden = true },
    Slipstream = { ID = 441257, Hidden = true },
    AzureCelerity = { ID = 441183, Hidden = true },

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

Action[ACTION_CONST_EVOKER_DEVASTATION] = A

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

local gs = { }

local buffs = {
    arenaPreparation = 32727,
    powerInfusion = 10060,
    hover = 358267,
    dragonrage = 375087,
    snapfire = 370818,
    massDisintegrate = 436336,
    chargedBlast = 370454,
    leapingFlames = 370901,
    burnout = 375802,
    scarletAdaptation = 372470,
    ancientFlame = 375583,
    tipTheScales = 370553,
    essenceBurst = 359618,
    iridescenceRed = 386353,
    iridescenceBlue = 386399,
    deepBreath = 357210,
    deepBreathScale = 433874,
    sourceOfMagic = 369459,
    blessingOfTheBronze = 381748,
    nullifyingShroud = 378464,
    imminentDestruction = 411055,
    jackpot = 1217769, -- needs checking
    powerSwell = 376850,
    innerFlame = 444017,
}

local debuffs = {
    fireBreath = 357209,
    shatteringStar = 370452,
    enkindle = 444017,
    livingFlame = 361500,
    sleepWalk = 360806,
}

local interrupts = {
    { spell = Quell },
    { spell = TailSwipe, isCC = true, aoe = true, distance = 2 }
}

local function num(val)
    if val then return 1 else return 0 end
end

Player:AddTier("TWW1", { 212032, 212030, 212029, 212028, 212027 })

local function shouldBurst()
    if Action.BurstIsON("target") then
        if A.Zone ~= "arena" and A.Zone ~= "pvp" then
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
            if LivingFlame:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

    return incomingDamage and not defensiveActive() 
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    local percent = casting and casting.percent
    local empStages = casting and casting.empowerStages

    return currentCast, percent, empStages
end

local function EmpowerStage()
    local _, percent = myCast()
    local duration = GetUnitEmpowerStageDuration("player", 1)
    local currentStage = 0

    if duration == 0 then return end

    local stages = {40, 70, 100}
    if player:TalentKnown(FontOfMagic.id) then
        stages = {30, 60, 80, 100}
    end

    if percent then
        if percent >= stages[1] and percent < stages[2] then
            currentStage = 1
        elseif percent >= stages[2] and percent < stages[3] then
            currentStage = 2
        elseif player:TalentKnown(FontOfMagic.id) and percent >= stages[3] and percent < stages[4] then
            currentStage = 3
        end
    else
        if duration > 0 then
            currentStage = 3 + player:TalentKnownInt(FontOfMagic.id)
        end
    end

    return currentStage
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

    if A.GetToggle(2, "snipeEngulf") then
        if gs.breathDotCount > 0 and not target:Debuff(debuffs.fireBreath, true) and Engulf.cd < 500 then
            return true
        end
    end
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

    gs.has2Set = player:Has2Set()
    gs.has4Set = player:Has4Set()

    gs.shouldAoE = activeEnemies() >= 3 and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    local cursorCondition = LivingFlame:InRange(mouseover) and (mouseover.canAttack or mouseover.isMelee or mouseover.isPet)
    gs.cursorCheck = A.GetToggle(2, "cursorCheck") and cursorCondition or not A.GetToggle(2, "cursorCheck")

    gs.activeEnemies = activeEnemies()

    local spellHastePercentage = GetCombatRatingBonus(20)
    local spellHasteMultiplier = 1 / (1 + spellHastePercentage / 100)
    gs.spellHaste = math.floor(spellHasteMultiplier * 100) / 100

    gs.fbCD = player:TalentKnown(FontOfMagic.id) and FireBreathToo.cd or FireBreath.cd
    gs.esCD = player:TalentKnown(FontOfMagic.id) and EternitySurgeToo.cd or EternitySurge.cd

    -- actions+=/variable,name=next_dragonrage,value=cooldown.dragonrage.remains<?((cooldown.eternity_surge.remains-8)>?(cooldown.fire_breath.remains-8))
    gs.nextDragonrage = math.min(Dragonrage.cd, math.max(gs.esCD - 8000, gs.fbCD - 8000))

    -- actions+=/variable,name=pool_for_id,if=talent.imminent_destruction,default=0,op=set,value=cooldown.deep_breath.remains<7&essence.deficit>=1&!buff.essence_burst.up&(raid_event.adds.in>=action.deep_breath.cooldown*0.4|talent.melt_armor&talent.maneuverability|active_enemies>=3)
    local dbCD = player:TalentKnown(Maneuverability.id) and DeepBreathScale.cd or DeepBreath.cd
    gs.poolForId = player:TalentKnown(ImminentDestruction.id) and dbCD < 7000 and player.essenceDeficit >= 1 and not player:Buff(buffs.essenceBurst) and (incAddsIn() >= dbCD * 0.4 or player:TalentKnown(MeltArmor.id) and player:TalentKnown(Maneuverability.id) or gs.activeEnemies >= 3)

    -- actions+=/variable,name=can_extend_dr,if=talent.animosity,op=set,value=buff.dragonrage.up&(buff.dragonrage.duration+dbc.effect.1160688.base_value%1000-buff.dragonrage.elapsed-buff.dragonrage.remains)>0
    gs.canExtendDr = player:TalentKnown(Animosity.id) and player:Buff(buffs.dragonrage) and (30000 + 4000 - player:BuffDuration(buffs.dragonrage) - player:BuffRemains(buffs.dragonrage)) > 0

    -- actions+=/variable,name=can_use_empower,op=set,value=cooldown.dragonrage.remains>=gcd.max*variable.dr_prep_time,if=talent.animosity&talent.dragonrage
    gs.canUseEmpower = true
    if player:TalentKnown(Animosity.id) and player:TalentKnown(Dragonrage.id) then
        gs.canUseEmpower = Dragonrage.cd >= A.GetGCD() * 6000 -- dr_prep_time default 6
    end

    -- actions+=/variable,name=can_use_empower,value=1,default=1,if=!talent.animosity|!talent.dragonrage
    if not player:TalentKnown(Animosity.id) or not player:TalentKnown(Dragonrage.id) then
        gs.canUseEmpower = true
    end

    gs.breathDotCount = enemiesInRange(debuffs.fireBreath, 1000)
    gs.massDisintegrate = gs.imCasting == FireBreath.id or gs.imCasting == EternitySurge.id or player:Buff(buffs.massDisintegrate)
    gs.essenceBurstMax = 1 + player:TalentKnownInt(EssenceAttunement.id)

    gs.drPrepTimeAoE = 4000
    gs.drPrepTimeSt = 6000 -- Updated to match APL default

    if gs.shouldAoE then
        gs.useHeal = player:TalentKnown(AncientFlame.id) and not player:Buff(buffs.ancientFlame) and not player:Buff(buffs.dragonrage) and not player:Buff(buffs.burnout)
    else
        gs.useHeal = player:TalentKnown(AncientFlame.id) and not player:Buff(buffs.ancientFlame) and not player:Buff(buffs.dragonrage) and not player:Buff(buffs.burnout) and not target:Debuff(debuffs.shatteringStar) and player:TalentKnown(ScarletAdaptation.id)
    end
end

-- actions.precombat+=/verdant_embrace,if=talent.scarlet_adaptation
VerdantEmbrace:Callback("precombat", function(spell)
    if A.IsInPvP then return end
    if player.inCombat then return end
    if not player:TalentKnown(ScarletAdaptation.id) then return end

    return spell:Cast()
end)

-- actions.precombat+=/hover,if=talent.slipstream
Hover:Callback("precombat", function(spell)
    if A.IsInPvP then return end
    if player.inCombat then return end
    if not player:TalentKnown(Slipstream.id) then return end
    if player:Buff(buffs.hover) then return end

    return spell:Cast()
end)

BlessingOfTheBronze:Callback(function(spell)
    if player.inCombat then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(BlessingOfTheBronze.wowName) and unit.distance < 40 and not unit.isPet end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 end)

    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if not missingBuff then return end

    return spell:Cast()
end)

ObsidianScales:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
    
    if not player.inCombat then return end

    if shouldDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "obsidianScalesHP") and not defensiveActive() then
        return spell:Cast()
    end
end)

Zephyr:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end

    if not player.inCombat then return end

    if shouldDefensive() then
        return spell:Cast()
    end

    if player.hp < A.GetToggle(2, "zephyrHP") and not defensiveActive() then
        return spell:Cast()
    end
end)

RenewingBlaze:Callback(function(spell)
    if not player.inCombat then return end

    if player.hp < A.GetToggle(2, "renewingBlazeHP") then
        return spell:Cast()
    end
end)

Quell:Callback("target", function(spell)
    if not target.exists then return end
    if not target.pvpKick then return end

    return spell:Cast(target)
end)

TailSwipe:Callback("pvp", function(spell)
    local nearbyCasting = MakMulti.arena:Any(function(unit) return unit.exists and unit.canAttack and unit.pvpKick and unit.distance <= 5 end)

    if nearbyCasting then 
        return spell:Cast()
    end

    if target.exists and target.canAttack and target.pvpKick and target.distance <= 5 then
        return spell:Cast()
    end
end)

NullifyingShroud:Callback(function(spell)
    if Action.Zone ~= "arena" then return end
    if not player.inCombat then return end
    if player:Buff(buffs.arenaPreparation) then return end
    if player:Buff(buffs.nullifyingShroud) then return end
    if target.hp < 50 and target.canAttack then return end
    if player:Buff(buffs.dragonrage) then return end
    if player.mounted then return end

    return spell:Cast()
end)

LivingFlame:Callback("heal", function(spell)
    if not target.isFriendly then return end
    if target.hp <= 0 then return end
    if not A.GetToggle(2, "healTarget") then return end

    if target.hp <= 95 then
        return spell:Cast(target)
    end
end)

Firestorm:Callback("pre", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting then return end
    if player.inCombat then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if not player:TalentKnown(Engulf.id) or not player:TalentKnown(RubyEmbers.id) then 
        return spell:Cast()
    end
end)

LivingFlameDmg:Callback("pre", function(spell)
    if gs.imCasting then return end
    if player.inCombat then return end
    
    if not player:TalentKnown(Firestorm.id) or Firestorm.cd < 300 or player:TalentKnown(Engulf.id) and player:TalentKnown(RubyEmbers.id) then 
        return spell:Cast()
    end
end)

local function recastEs()
    if gs.imCasting and (gs.imCasting == EternitySurge.id or gs.imCasting == EternitySurgeToo.id) then
        local empStage = EmpowerStage()

        if empStage == 3 + player:TalentKnownInt(FontOfMagic.id) then
            return true
        end

        -- actions.es=eternity_surge,empower_to=1,target_if=max:target.health.pct,if=active_enemies<=1+talent.eternitys_span|(variable.can_extend_dr&talent.animosity|talent.mass_disintegrate)&active_enemies>(3+talent.font_of_magic+4*talent.eternitys_span)|buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste&talent.animosity&variable.can_extend_dr
        if empStage == 1 then
            if gs.activeEnemies <= 1 + player:TalentKnownInt(EternitysSpan.id) or (gs.canExtendDr and player:TalentKnown(Animosity.id) or player:Buff(buffs.massDisintegrate)) and gs.activeEnemies > (3 + player:TalentKnownInt(FontOfMagic.id) + 4 * player:TalentKnownInt(EternitysSpan.id)) or player:BuffRemains(buffs.dragonrage) < 1750 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 1000 * gs.spellHaste and player:TalentKnown(Animosity.id) and gs.canExtendDr then
                return true
            end
        end

        -- actions.es+=/eternity_surge,empower_to=2,target_if=max:target.health.pct,if=active_enemies<=2+2*talent.eternitys_span|buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste&talent.animosity&variable.can_extend_dr
        if empStage == 2 then
            if gs.activeEnemies <= 2 + 2 * player:TalentKnownInt(EternitysSpan.id) or player:BuffRemains(buffs.dragonrage) < 2500 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 1750 * gs.spellHaste and player:TalentKnown(Animosity.id) and gs.canExtendDr then
                return true
            end
        end

        -- actions.es+=/eternity_surge,empower_to=3,target_if=max:target.health.pct,if=active_enemies<=3+3*talent.eternitys_span|!talent.font_of_magic&talent.mass_disintegrate|buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste&talent.animosity&variable.can_extend_dr
        if empStage == 3 then
            if gs.activeEnemies <= 3 + 3 * player:TalentKnownInt(EternitysSpan.id) or not player:TalentKnown(FontOfMagic.id) and player:TalentKnown(MassDisintegrate.id) or player:BuffRemains(buffs.dragonrage) <= 3250 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 2500 * gs.spellHaste and player:TalentKnown(Animosity.id) and gs.canExtendDr then
                return true
            end
        end

        return false
    end
end

local function recastFb()

    if gs.imCasting and (gs.imCasting == FireBreath.id or gs.imCasting == FireBreathToo.id) then

        local empStage = EmpowerStage()

        --Let's just try some non-Sim stuff as I think Sim stuff is actually overly complicated and causing issues. 
        if empStage then
            if empStage == 3 + player:TalentKnownInt(FontOfMagic.id) then
                return true
            end

            if empStage >= gs.activeEnemies or empStage >= 1 and player:TalentKnown(ScorchingEmbers.id) then
                return true
            end
        end

        --[[if empStage == 3 and not player:TalentKnown(FontOfMagic.id) then
            return true
        end

        -- actions.fb=fire_breath,empower_to=2,target_if=max:target.health.pct,if=talent.scorching_embers&(cooldown.engulf.remains<=duration+0.5|cooldown.engulf.up)&talent.engulf&release.dot_duration<=target.time_to_die
        -- actions.fb+=/fire_breath,empower_to=3,target_if=max:target.health.pct,if=talent.scorching_embers&(cooldown.engulf.remains<=duration+0.5|cooldown.engulf.up)&talent.engulf&(release.dot_duration<=target.time_to_die|!talent.font_of_magic)
        if player:TalentKnown(ScorchingEmbers.id) then
            if (Engulf.cd <= target:DebuffDuration(debuffs.fireBreath, true) + 500 or Engulf.cd < 500) and player:TalentKnown(Engulf.id) then
                if (target.ttd <= 18000 or target.isDummy or not player:TalentKnown(FontOfMagic.id)) then
                    if empStage == 2 then
                        return true
                    end
                end
                if (target.ttd <= 12000 or target.isDummy or not player:TalentKnown(FontOfMagic.id)) then
                    if empStage == 3 then
                        return true
                    end
                end
            end
        end


        -- actions.fb+=/fire_breath,empower_to=1,target_if=max:target.health.pct,if=((buff.dragonrage.remains<1.75*spell_haste&buff.dragonrage.remains>=1*spell_haste)&talent.animosity&variable.can_extend_dr|active_enemies=1)&release.dot_duration<=target.time_to_die
        -- actions.fb+=/fire_breath,empower_to=2,target_if=max:target.health.pct,if=((buff.dragonrage.remains<2.5*spell_haste&buff.dragonrage.remains>=1.75*spell_haste)&talent.animosity&variable.can_extend_dr|talent.scorching_embers|active_enemies>=2)&release.dot_duration<=target.time_to_die
        -- actions.fb+=/fire_breath,empower_to=3,target_if=max:target.health.pct,if=!talent.font_of_magic|((buff.dragonrage.remains<=3.25*spell_haste&buff.dragonrage.remains>=2.5*spell_haste)&talent.animosity&variable.can_extend_dr|talent.scorching_embers)&release.dot_duration<=target.time_to_die
        if empStage == 1 then
            if ((player:BuffRemains(buffs.dragonrage) < 1750 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 1000 * gs.spellHaste) and player:TalentKnown(Animosity.id) and gs.canExtendDr or gs.activeEnemies == 1) and (target.ttd <= 24000 or target.isDummy) then
                return true
            end
        end

        if empStage == 2 then
            if ((player:BuffRemains(buffs.dragonrage) < 2500 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 1750 * gs.spellHaste) and player:TalentKnown(Animosity.id) and gs.canExtendDr or player:TalentKnown(ScorchingEmbers.id) or gs.activeEnemies >= 2) and (target.ttd <= 18000 or target.isDummy) then
                return true
            end
        end

        if empStage == 3 then
            if not player:TalentKnown(FontOfMagic.id) or ((player:BuffRemains(buffs.dragonrage) <= 3250 * gs.spellHaste and player:BuffRemains(buffs.dragonrage) >= 2500 * gs.spellHaste) and player:TalentKnown(Animosity.id) and gs.canExtendDr or player:TalentKnown(ScorchingEmbers.id)) and (target.ttd <= 12000 or target.isDummy) then
                return true
            end
        end

        if empStage == 4 then
            return true
        end]]

        return false
    end
end

-- actions.aoe=hover,use_off_gcd=1,if=raid_event.movement.in<6&!buff.hover.up&gcd.remains>=0.5&(buff.mass_disintegrate_stacks.up&talent.mass_disintegrate|active_enemies<=4)
Hover:Callback("aoe", function(spell)
    if player:Buff(buffs.hover) then return end
    if A.GetGCD() < 500 then return end
    if not (gs.massDisintegrate and player:TalentKnown(MassDisintegrate.id) or gs.activeEnemies <= 4) then return end

    return spell:Cast()
end)

-- actions.aoe+=/firestorm,if=buff.snapfire.up
Firestorm:Callback("aoe", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.snapfire) then return end

    return spell:Cast()
end)

-- actions.aoe+=/shattering_star,target_if=max:target.health.pct,if=(!buff.essence_burst.at_max_stacks&talent.arcane_vigor|talent.eternitys_span&active_enemies<=4)
ShatteringStar:Callback("aoe", function(spell)
    if not (player:HasBuffCount(buffs.essenceBurst) < gs.essenceBurstMax and player:TalentKnown(ArcaneVigor.id) or player:TalentKnown(EternitysSpan.id) and gs.activeEnemies <= 4) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/deep_breath,if=talent.maneuverability&talent.melt_armor&!cooldown.fire_breath.up&!cooldown.eternity_surge.up|talent.feed_the_flames&talent.engulf&talent.imminent_destruction
DeepBreath:Callback("aoe", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if player:TalentKnown(FeedTheFlames.id) and player:TalentKnown(Engulf.id) and player:TalentKnown(ImminentDestruction.id) then
        return spell:Cast()
    end

    if not player:TalentKnown(Maneuverability.id) then return end
    if not player:TalentKnown(MeltArmor.id) then return end

    if gs.fbCD < 700 then return end
    if gs.esCD < 700 then return end

    return spell:Cast()
end)

DeepBreathScale:Callback("aoe", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if player:TalentKnown(FeedTheFlames.id) and player:TalentKnown(Engulf.id) and player:TalentKnown(ImminentDestruction.id) then
        return spell:Cast()
    end

    if not player:TalentKnown(Maneuverability.id) then return end
    if not player:TalentKnown(MeltArmor.id) then return end

    if gs.fbCD < 700 then return end
    if gs.esCD < 700 then return end

    return spell:Cast()
end)

--actions.aoe+=/firestorm,if=talent.feed_the_flames&(!talent.engulf|cooldown.engulf.remains>4|cooldown.engulf.charges=0|(variable.next_dragonrage<=cooldown*1.2|!talent.dragonrage))
Firestorm:Callback("aoe2", function(spell)
    if not gs.cursorCheck then return end
    if not player:TalentKnown(FeedTheFlames.id) then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if (not player:TalentKnown(Engulf.id) or Engulf.cd > 4000 or Engulf.frac < 1 or (gs.nextDragonrage <= 24000 or not player:TalentKnown(Dragonrage.id))) then 
        return spell:Cast()
    end
end)

-- actions.aoe+=/fire_breath,target_if=max:target.health.pct,empower_to=4,if=talent.scorching_embers&variable.can_use_empower&target.time_to_die>=duration
FireBreath:Callback("aoe", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not player:TalentKnown(ScorchingEmbers.id) then return end
    if not gs.canUseEmpower then return end
    if target.ttd < 12000 and not target.isDummy then return end

    return spell:Cast()
end)

FireBreathToo:Callback("aoe", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not player:TalentKnown(ScorchingEmbers.id) then return end
    if not gs.canUseEmpower then return end
    if target.ttd < 12000 and not target.isDummy then return end

    return spell:Cast()
end)

-- actions.aoe+=/fire_breath,target_if=max:target.health.pct,empower_to=2,if=variable.can_use_empower&target.time_to_die>=duration
FireBreath:Callback("aoe2", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end
    if target.ttd < 18000 and not target.isDummy then return end

    return spell:Cast()
end)

FireBreathToo:Callback("aoe2", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end
    if target.ttd < 18000 and not target.isDummy then return end

    return spell:Cast()
end)

-- actions.aoe+=/tip_the_scales,use_off_gcd=1,if=(!talent.dragonrage|buff.dragonrage.up)&cooldown.fire_breath.remains<cooldown.eternity_surge.remains
TipTheScales:Callback("aoe", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    if player:TalentKnown(Dragonrage.id) and not player:Buff(buffs.dragonrage) then return end

    if gs.fbCD < gs.esCD then
        return spell:Cast()
    end
end)

--actions.aoe+=/shattering_star,target_if=max:target.health.pct,if=(cooldown.dragonrage.up&talent.arcane_vigor|talent.eternitys_span&active_enemies<=3)&talent.engulf
ShatteringStar:Callback("aoe2", function(spell)  
    if not player:TalentKnown(Engulf.id) then return end

    if Dragonrage.cd < 500 and player:TalentKnown(ArcaneVigor.id) then
        return spell:Cast(target)
    end

    if player:TalentKnown(EternitysSpan.id) and gs.activeEnemies <= 3 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/dragonrage,target_if=max:target.time_to_die,if=target.time_to_die>=15|!raid_event.adds.exists
Dragonrage:Callback("aoe", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if target.ttd >= 15000 or target.isDummy or incAddsIn() > 60000 then
        return spell:Cast()
    end
end)

-- actions.aoe+=/call_action_list,name=es,if=(!talent.dragonrage|buff.dragonrage.up|cooldown.dragonrage.remains>variable.dr_prep_time_aoe|!talent.animosity)&(!buff.jackpot.up|!set_bonus.tww2_4pc|talent.mass_disintegrate)
EternitySurge:Callback("aoe", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(Dragonrage.id) or player:Buff(buffs.dragonrage) or Dragonrage.cd > gs.drPrepTimeAoE or not player:TalentKnown(Animosity.id)) then return end
    if not (not player:Buff(buffs.jackpot) or not gs.has4Set or player:TalentKnown(MassDisintegrate.id)) then return end

    return spell:Cast(target)
end)

EternitySurgeToo:Callback("aoe", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(Dragonrage.id) or player:Buff(buffs.dragonrage) or Dragonrage.cd > gs.drPrepTimeAoE or not player:TalentKnown(Animosity.id)) then return end
    if not (not player:Buff(buffs.jackpot) or not gs.has4Set or player:TalentKnown(MassDisintegrate.id)) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/deep_breath,if=!buff.dragonrage.up&essence.deficit>3
DeepBreath:Callback("aoe2", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if player:Buff(buffs.dragonrage) then return end
    if player.essenceDeficit <= 3 then return end

    return spell:Cast()
end)

DeepBreathScale:Callback("aoe2", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if player:Buff(buffs.dragonrage) then return end
    if player.essenceDeficit <= 3 then return end

    return spell:Cast()
end)

-- actions.aoe+=/engulf,target_if=(dot.fire_breath_damage.remains>travel_time)&(dot.enkindle.remains>travel_time|!talent.enkindle)&(!talent.scorching_embers|dot.fire_breath_damage.duration<=6|fight_remains<=30)&(cooldown.dragonrage.remains>=cooldown.engulf.duration+full_recharge_time|!talent.dragonrage|buff.tip_the_scales.up&cooldown.fire_breath.up|buff.dragonrage.up|full_recharge_time<=cooldown.fire_breath.duration_expected)
Engulf:Callback("aoe", function(spell)
    if not target:Debuff(debuffs.fireBreath, true) then return end
    if player:TalentKnown(Enkindle.id) and not target:Debuff(debuffs.enkindle, true) then return end
    if player:TalentKnown(ScorchingEmbers.id) and target:HasDeBuffFor(debuffs.fireBreath, true) > 6000 and target.ttd > 30000 then return end

    local engulfDuration = 3000 -- Approximate duration
    local fullRechargeTime = spell:TimeToFullCharges()

    if not (Dragonrage.cd >= engulfDuration + fullRechargeTime or not player:TalentKnown(Dragonrage.id) or player:Buff(buffs.tipTheScales) and gs.fbCD < 500 or player:Buff(buffs.dragonrage) or fullRechargeTime <= gs.fbCD) then return end

    return spell:Cast(target)
end)

--actions.aoe+=/shattering_star,target_if=max:target.health.pct,if=(buff.essence_burst.stack<buff.essence_burst.max_stack&talent.arcane_vigor|talent.eternitys_span&active_enemies<=3|set_bonus.tww2_4pc&buff.jackpot.stack<2)&(!talent.engulf|cooldown.engulf.remains<4|cooldown.engulf.charges>0)
ShatteringStar:Callback("aoe3", function(spell) 
    if not player:TalentKnown(Engulf.id) or Engulf.cd < 4000 or Engulf.frac > 0 then
        if player:HasBuffCount(buffs.essenceBurst) < 1 + player:TalentKnownInt(EssenceAttunement.id) and player:TalentKnown(ArcaneVigor.id) then 
            return spell:Cast(target)
        end

        if player:TalentKnown(EternitysSpan.id) and gs.activeEnemies <= 3 then
            return spell:Cast(target)
        end

        if player:Has4Set() and player:HasBuffCount(buffs.jackpot) < 2 then
            return spell:Cast(target)
        end
    end
end)

--actions.aoe+=/engulf,target_if=max:(((dot.fire_breath_damage.remains-dbc.effect.1140380.base_value*action.engulf_damage.in_flight_to_target-action.engulf_damage.travel_time)>0)*3+dot.living_flame_damage.ticking+dot.enkindle.ticking),if=(dot.fire_breath_damage.remains>=action.engulf_damage.travel_time+dbc.effect.1140380.base_value*action.engulf_damage.in_flight_to_target)&(variable.next_dragonrage>=cooldown*1.2|!talent.dragonrage)
Engulf:Callback("aoe", function(spell)  
    if not target:Debuff(debuffs.fireBreath, true) then return end

    if gs.nextDragonrage >= 27600 or not player:TalentKnown(Dragonrage.id) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/pyre,target_if=max:target.health.pct,if=buff.charged_blast.stack>=12&(cooldown.dragonrage.remains>gcd.max*4|!talent.dragonrage)
Pyre:Callback("aoe", function(spell)
    if player:HasBuffCount(buffs.chargedBlast) < 12 then return end

    if Dragonrage.cd > A.GetGCD() * 4000 or not player:TalentKnown(Dragonrage.id) then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/disintegrate,target_if=min:debuff.bombardments.remains,if=buff.mass_disintegrate_stacks.up&talent.mass_disintegrate&(!variable.pool_for_id|buff.mass_disintegrate_stacks.remains<=buff.mass_disintegrate_stacks.stack*(duration+0.1))
Disintegrate:Callback("aoe", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if not gs.massDisintegrate then return end
    if not player:TalentKnown(MassDisintegrate.id) then return end

    if not gs.poolForId or player:BuffRemains(buffs.massDisintegrate) <= player:HasBuffCount(buffs.massDisintegrate) * 2600 then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/deep_breath,if=talent.imminent_destruction&!buff.essence_burst.up
DeepBreath:Callback("aoe3", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not player:TalentKnown(ImminentDestruction.id) then return end
    if player:Buff(buffs.essenceBurst) then return end

    return spell:Cast()
end)

DeepBreathScale:Callback("aoe3", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not player:TalentKnown(ImminentDestruction.id) then return end
    if player:Buff(buffs.essenceBurst) then return end

    return spell:Cast()
end)

-- actions.aoe+=/pyre,target_if=max:target.health.pct,if=(active_enemies>=4-(buff.imminent_destruction.up)|talent.snapfire|talent.volatility|talent.scorching_embers&active_dot.fire_breath_damage>=active_enemies*0.75)&(cooldown.dragonrage.remains>gcd.max*4|!talent.dragonrage|!talent.charged_blast)&!variable.pool_for_id&(!buff.mass_disintegrate_stacks.up|buff.essence_burst.stack=2|buff.essence_burst.stack=1&essence>=(3-buff.imminent_destruction.up)|essence>=(5-buff.imminent_destruction.up*2))
Pyre:Callback("aoe2", function(spell)
    if not (gs.activeEnemies >= 4 - num(player:Buff(buffs.imminentDestruction)) or player:TalentKnown(Snapfire.id) or player:TalentKnown(Volatility.id) or player:TalentKnown(ScorchingEmbers.id) and gs.breathDotCount >= gs.activeEnemies * 0.75) then return end
    if not (Dragonrage.cd > A.GetGCD() * 4000 or not player:TalentKnown(Dragonrage.id) or not player:TalentKnown(ChargedBlast.id)) then return end
    if gs.poolForId then return end
    if not (not gs.massDisintegrate or player:HasBuffCount(buffs.essenceBurst) == 2 or player:HasBuffCount(buffs.essenceBurst) == 1 and player.essence >= (3 - num(player:Buff(buffs.imminentDestruction))) or player.essence >= (5 - (num(player:Buff(buffs.imminentDestruction)) * 2))) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/living_flame,target_if=max:target.health.pct,if=(!talent.burnout|buff.burnout.up|cooldown.fire_breath.remains<=gcd.max*5|buff.inner_flame.up|buff.scarlet_adaptation.up|buff.ancient_flame.up)&buff.leaping_flames.up&(!buff.essence_burst.up&essence.deficit>1|cooldown.fire_breath.remains<=gcd.max*3&buff.essence_burst.stack<buff.essence_burst.max_stack)
LivingFlameDmg:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.leapingFlames) then return end

    if not (not player:TalentKnown(Burnout.id) or player:Buff(buffs.burnout) or gs.fbCD <= A.GetGCD() * 5000 or player:Buff(buffs.innerFlame) or player:Buff(buffs.scarletAdaptation) or player:Buff(buffs.ancientFlame)) then return end
    if not (not player:Buff(buffs.essenceBurst) and player.essenceDeficit > 1 or gs.fbCD <= A.GetGCD() * 3000 and player:HasBuffCount(buffs.essenceBurst) < gs.essenceBurstMax) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/disintegrate,target_if=max:target.health.pct,chain=1,early_chain_if=evoker.use_early_chaining&ticks>=2&(raid_event.movement.in>2|buff.hover.up),interrupt_if=evoker.use_clipping&buff.dragonrage.up&ticks>=2&(raid_event.movement.in>2|buff.hover.up),if=(raid_event.movement.in>2|buff.hover.up)&!variable.pool_for_id&(active_enemies<=4|buff.mass_disintegrate_stacks.up)
Disintegrate:Callback("aoe2", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if gs.poolForId then return end

    if gs.activeEnemies <= 4 or gs.massDisintegrate then
        return spell:Cast(target)
    end
end)

-- actions.aoe+=/living_flame,target_if=max:target.health.pct,if=talent.snapfire&buff.burnout.up
LivingFlameDmg:Callback("aoe2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:TalentKnown(Snapfire.id) then return end
    if not player:Buff(buffs.burnout) then return end

    return spell:Cast(target)
end)

-- actions.aoe+=/firestorm
Firestorm:Callback("aoe3", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast()
end)

-- actions.aoe+=/living_flame,if=talent.snapfire&!talent.engulfing_blaze
LivingFlameDmg:Callback("aoe3", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:TalentKnown(Snapfire.id) then return end
    if player:TalentKnown(EngulfingBlaze.id) then return end

    return spell:Cast(target)
end)

--actions.aoe+=/azure_strike,target_if=max:target.health.pct
AzureStrike:Callback(function(spell)

    return spell:Cast(target)
end)

local function aoe()
    Hover("aoe")
    Firestorm("aoe")
    ShatteringStar("aoe")
    DeepBreath("aoe")
    DeepBreathScale("aoe")
    TipTheScales("aoe")
    FireBreath("aoe")
    FireBreathToo("aoe")
    FireBreath("aoe2")
    FireBreathToo("aoe2")
    Dragonrage("aoe")
    EternitySurge("aoe")
    EternitySurgeToo("aoe")
    Engulf("aoe")
    Pyre("aoe")
    Disintegrate("aoe")
    DeepBreath("aoe3")
    DeepBreathScale("aoe3")
    Pyre("aoe2")
    LivingFlameDmg("aoe")
    Disintegrate("aoe2")
    LivingFlameDmg("aoe2")
    Firestorm("aoe3")
    LivingFlameDmg("aoe3")
    AzureStrike()
end

-- actions.st=deep_breath,if=talent.maneuverability&set_bonus.tww3_4pc,cancel_if=gcd.remains=0&ticks>=8&active_enemies=1
DeepBreath:Callback("st", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not player:TalentKnown(Maneuverability.id) then return end
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc

    return spell:Cast()
end)

DeepBreathScale:Callback("st", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not player:TalentKnown(Maneuverability.id) then return end
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc

    return spell:Cast()
end)

-- actions.st+=/dragonrage,if=target.time_to_die>=30&raid_event.adds.in>=60|!raid_event.adds.exists
Dragonrage:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if target.ttd >= 30000 or target.isDummy or incAddsIn() >= 60000 then
        return spell:Cast()
    end
end)

-- actions.st+=/eternity_surge,empower_to=1,if=set_bonus.tww3_4pc&buff.dragonrage.up&cooldown.engulf.full_recharge_time<gcd.max*3&cooldown.fire_breath.remains<gcd.max*3
EternitySurge:Callback("st", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc
    if not player:Buff(buffs.dragonrage) then return end
    if Engulf:TimeToFullCharges() >= A.GetGCD() * 3000 then return end
    if gs.fbCD >= A.GetGCD() * 3000 then return end

    return spell:Cast(target)
end)

EternitySurgeToo:Callback("st", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc
    if not player:Buff(buffs.dragonrage) then return end
    if Engulf:TimeToFullCharges() >= A.GetGCD() * 3000 then return end
    if gs.fbCD >= A.GetGCD() * 3000 then return end

    return spell:Cast(target)
end)

-- actions.st+=/living_flame,if=set_bonus.tww3_4pc&cooldown.engulf.remains<=execute_time*2&buff.essence_burst.stack<(2-talent.arcane_vigor.enabled)&buff.dragonrage.up&cooldown.fire_breath.remains<=execute_time*2
LivingFlameDmg:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    -- PRIORITY: if Burnout is active, cast Living Flame immediately
    if player:Buff(375802) then
        return spell:Cast(target)
    end

    -- Original logic
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc
    if Engulf.cd > spell:CastTime() * 2 then return end
    if player:HasBuffCount(buffs.essenceBurst) >= (2 - player:TalentKnownInt(ArcaneVigor.id)) then return end
    if not player:Buff(buffs.dragonrage) then return end
    if gs.fbCD > spell:CastTime() * 2 then return end

    return spell:Cast(target)
end)

-- actions.st+=/hover,use_off_gcd=1,if=raid_event.movement.in<6&!buff.hover.up&gcd.remains>=0.5|talent.slipstream&gcd.remains>=0.5
Hover:Callback("st", function(spell)
    if player:Buff(buffs.hover) then return end
    if A.GetGCD() < 500 then return end
    if not player:TalentKnown(Slipstream.id) and A.GetGCD() < 500 then return end

    return spell:Cast()
end)

-- actions.st+=/tip_the_scales,use_off_gcd=1,if=buff.dragonrage.up&cooldown.fire_breath.remains<cooldown.eternity_surge.remains
TipTheScales:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[3] then return end

    if not player:Buff(buffs.dragonrage) then return end
    if gs.fbCD >= gs.esCD then return end

    return spell:Cast()
end)

--actions.st+=/deep_breath,if=talent.maneuverability&talent.melt_armor
DeepBreath:Callback("st", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if not player:TalentKnown(Maneuverability.id) then return end
    if not player:TalentKnown(MeltArmor.id) then return end

    return spell:Cast()
end)

DeepBreathScale:Callback("st", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if not player:TalentKnown(Maneuverability.id) then return end
    if not player:TalentKnown(MeltArmor.id) then return end

    return spell:Cast()
end)

--actions.st+=/dragonrage,if=(cooldown.fire_breath.remains<4|cooldown.eternity_surge.remains<4&(!talent.mass_disintegrate|set_bonus.tww2_4pc))&((cooldown.fire_breath.remains<8|!talent.animosity)&(cooldown.eternity_surge.remains<8|talent.mass_disintegrate|!talent.animosity|set_bonus.tww2_4pc))&target.time_to_die>=32|fight_remains<32
Dragonrage:Callback("st", function(spell)
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[1] then return end

    if target.ttd < 32000 and gs.inRaid and target.isBoss then
        return spell:Cast()
    end

    if (gs.fbCD < 4000 or gs.esCD < 4000 and (not player:TalentKnown(MassDisintegrate.id) or player:Has4Set())) and ((gs.fbCD < 8000 or not player:TalentKnown(Animosity.id)) and (gs.esCD < 8000 or player:TalentKnown(MassDisintegrate.id) or not player:TalentKnown(Animosity.id) or player:Has4Set())) and (target.ttd >= 32000 or target.isDummy) then
        return spell:Cast()
    end
end)

--actions.st+=/call_action_list,name=es,if=buff.dragonrage.up&talent.animosity&talent.engulf&set_bonus.tww2_4pc&!buff.jackpot.up&variable.can_extend_dr&!cooldown.engulf.up
EternitySurge:Callback("st2", function(spell) 
    if player:TalentKnown(FontOfMagic.id) then return end
    if player:Buff(buffs.dragonrage) and player:TalentKnown(Animosity.id) and player:TalentKnown(Engulf.id) and player:Has4Set() and not player:Buff(buffs.jackpot) and gs.canExtendDr and Engulf.cd > 700 then
        return spell:Cast(target)
    end
end)

EternitySurgeToo:Callback("st2", function(spell) 
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player:Buff(buffs.dragonrage) and player:TalentKnown(Animosity.id) and player:TalentKnown(Engulf.id) and player:Has4Set() and not player:Buff(buffs.jackpot) and gs.canExtendDr and Engulf.cd > 700 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/shattering_star,if=(!buff.essence_burst.at_max_stacks|!talent.arcane_vigor|talent.engulf)&(set_bonus.tww2_2pc|!talent.scorching_embers|!talent.engulf|dot.fire_breath_damage.ticking&dot.fire_breath_damage.duration<=6|(action.engulf.usable_in<?cooldown.fire_breath.remains_expected+4)>=15)
ShatteringStar:Callback("st", function(spell)
    if not (player:HasBuffCount(buffs.essenceBurst) < gs.essenceBurstMax or not player:TalentKnown(ArcaneVigor.id) or player:TalentKnown(Engulf.id)) then return end

    local engulfUsableIn = Engulf.cd
    local fbRemainsExpected = gs.fbCD

    if not (gs.has2Set or not player:TalentKnown(ScorchingEmbers.id) or not player:TalentKnown(Engulf.id) or target:Debuff(debuffs.fireBreath, true) and target:HasDeBuffFor(debuffs.fireBreath, true) <= 6000 or math.min(engulfUsableIn, fbRemainsExpected + 4000) >= 15000) then return end

    return spell:Cast(target)
end)

-- actions.st+=/fire_breath,target_if=max:target.health.pct,empower_to=4,if=(talent.scorching_embers&talent.engulf&action.engulf.usable_in<=duration+0.5)&variable.can_use_empower&(cooldown.shattering_star.remains<=duration+0.5+6-gcd.max|!talent.shattering_star|cooldown.engulf.full_recharge_time<=cooldown.fire_breath.duration_expected+4)
FireBreath:Callback("st", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not (player:TalentKnown(ScorchingEmbers.id) and player:TalentKnown(Engulf.id) and Engulf.cd <= 12500) then return end
    if not gs.canUseEmpower then return end
    if not (ShatteringStar.cd <= 18500 - A.GetGCD() or not player:TalentKnown(ShatteringStar.id) or Engulf:TimeToFullCharges() <= gs.fbCD + 4000) then return end

    return spell:Cast()
end)

FireBreathToo:Callback("st", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not (player:TalentKnown(ScorchingEmbers.id) and player:TalentKnown(Engulf.id) and Engulf.cd <= 12500) then return end
    if not gs.canUseEmpower then return end
    if not (ShatteringStar.cd <= 18500 - A.GetGCD() or not player:TalentKnown(ShatteringStar.id) or Engulf:TimeToFullCharges() <= gs.fbCD + 4000) then return end

    return spell:Cast()
end)

-- actions.st+=/fire_breath,target_if=max:target.health.pct,empower_to=2,if=variable.can_use_empower&!buff.dragonrage.up&talent.mass_disintegrate
FireBreath:Callback("st2", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end
    if player:Buff(buffs.dragonrage) then return end
    if not player:TalentKnown(MassDisintegrate.id) then return end

    return spell:Cast()
end)

FireBreathToo:Callback("st2", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end
    if player:Buff(buffs.dragonrage) then return end
    if not player:TalentKnown(MassDisintegrate.id) then return end

    return spell:Cast()
end)

-- actions.st+=/fire_breath,target_if=max:target.health.pct,empower_to=1,if=variable.can_use_empower
FireBreath:Callback("st3", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end

    return spell:Cast()
end)

FireBreathToo:Callback("st3", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if target.distance > 25 then return end
    if not gs.canUseEmpower then return end

    return spell:Cast()
end)

-- actions.st+=/engulf,if=(dot.fire_breath_damage.remains>travel_time)&(dot.living_flame_damage.remains>travel_time|!talent.ruby_embers)&(dot.enkindle.remains>travel_time|!talent.enkindle)&(!talent.iridescence|buff.iridescence_red.up)&(!talent.scorching_embers|dot.fire_breath_damage.duration<=6|fight_remains<=30)&(debuff.shattering_star_debuff.remains>travel_time|full_recharge_time<action.shattering_star.usable_in|talent.scorching_embers)&(cooldown.dragonrage.remains>=cooldown.engulf.duration+full_recharge_time|raid_event.adds.in<=60&raid_event.adds.in>duration+full_recharge_time|!talent.dragonrage|buff.tip_the_scales.up&cooldown.fire_breath.up|buff.dragonrage.up|full_recharge_time<=cooldown.fire_breath.duration_expected)
Engulf:Callback("st", function(spell)
    if not target:Debuff(debuffs.fireBreath, true) then return end
    if player:TalentKnown(RubyEmbers.id) and not target:Debuff(debuffs.livingFlame, true) then return end
    if player:TalentKnown(Enkindle.id) and not target:Debuff(debuffs.enkindle, true) then return end
    if player:TalentKnown(Iridescence.id) and not player:Buff(buffs.iridescenceRed) then return end
    if player:TalentKnown(ScorchingEmbers.id) and target:HasDeBuffFor(debuffs.fireBreath, true) > 6000 and target.ttd > 30000 then return end

    local engulfDuration = 3000
    local fullRechargeTime = spell:TimeToFullCharges()
    local travelTime = 500 -- Approximate travel time

    if not (target:DebuffRemains(debuffs.shatteringStar, true) > travelTime or fullRechargeTime < ShatteringStar.cd or player:TalentKnown(ScorchingEmbers.id)) then return end

    local addsIn = incAddsIn()
    if not (Dragonrage.cd >= engulfDuration + fullRechargeTime or addsIn <= 60000 and addsIn > engulfDuration + fullRechargeTime or not player:TalentKnown(Dragonrage.id) or player:Buff(buffs.tipTheScales) and gs.fbCD < 500 or player:Buff(buffs.dragonrage) or fullRechargeTime <= gs.fbCD) then return end

    return spell:Cast(target)
end)

--actions.st+=/deep_breath,if=(talent.imminent_destruction&!debuff.shattering_star_debuff.up|talent.melt_armor&talent.maneuverability)&(talent.melt_armor&talent.maneuverability|!buff.dragonrage.up)
DeepBreath:Callback("st2", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if (player:TalentKnown(ImminentDestruction.id) and not target:Debuff(debuffs.shatteringStar, true) or player:TalentKnown(MeltArmor.id) and player:TalentKnown(Maneuverability.id)) and (player:TalentKnown(MeltArmor.id) and player:TalentKnown(Maneuverability.id) or not player:Buff(buffs.dragonrage)) then
        return spell:Cast()
    end
end)

DeepBreathScale:Callback("st2", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if (player:TalentKnown(ImminentDestruction.id) and not target:Debuff(debuffs.shatteringStar, true) or player:TalentKnown(MeltArmor.id) and player:TalentKnown(Maneuverability.id)) and (player:TalentKnown(MeltArmor.id) and player:TalentKnown(Maneuverability.id) or not player:Buff(buffs.dragonrage)) then
        return spell:Cast()
    end
end)

--actions.st+=/call_action_list,name=es,if=(!talent.dragonrage|variable.next_dragonrage>variable.dr_prep_time_st|!talent.animosity|talent.mass_disintegrate)&(!set_bonus.tww2_4pc|!buff.jackpot.up|variable.es_send_threshold<=cooldown.fire_breath.remains|talent.mass_disintegrate)&(!talent.power_swell|buff.power_swell.remains<=gcd.max)
EternitySurge:Callback("st2", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    
    if (not player:TalentKnown(Dragonrage.id) or gs.nextDragonrage > gs.drPrepTimeSt or not player:TalentKnown(Animosity.id) or player:TalentKnown(MassDisintegrate.id)) and (not player:Buff(buffs.jackpot) or 8000 <= gs.fbCD or player:TalentKnown(MassDisintegrate.id)) and (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= A.GetGCD() * 1000) then
        return spell:Cast(target)
    end
end)

EternitySurgeToo:Callback("st2", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    
    if (not player:TalentKnown(Dragonrage.id) or gs.nextDragonrage > gs.drPrepTimeSt or not player:TalentKnown(Animosity.id) or player:TalentKnown(MassDisintegrate.id)) and (not player:Buff(buffs.jackpot) or 8000 <= gs.fbCD or player:TalentKnown(MassDisintegrate.id)) and (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= A.GetGCD() * 1000) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/living_flame,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max&buff.burnout.up
LivingFlameDmg:Callback("st2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.dragonrage) then return end
    if not player:Buff(buffs.burnout) then return end

    if player:BuffRemains(buffs.dragonrage) < (gs.essenceBurstMax - player:HasBuffCount(buffs.essenceBurst)) * A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/azure_strike,if=buff.dragonrage.up&buff.dragonrage.remains<(buff.essence_burst.max_stack-buff.essence_burst.stack)*gcd.max
AzureStrike:Callback("st", function(spell)
    if not player:Buff(buffs.dragonrage) then return end

    if player:BuffRemains(buffs.dragonrage) < (gs.essenceBurstMax - player:HasBuffCount(buffs.essenceBurst)) * A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.st+=/firestorm,if=buff.snapfire.up|active_enemies>=2
Firestorm:Callback("st", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:Buff(buffs.snapfire) or gs.activeEnemies >= 2 then
        return spell:Cast()
    end
end)

-- actions.st+=/eternity_surge,target_if=max:target.health.pct,empower_to=2,if=(!talent.power_swell|buff.power_swell.remains<=duration|!talent.mass_disintegrate)&active_enemies=2&!talent.eternitys_span&variable.can_use_empower
EternitySurge:Callback("st2", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= 18000 or not player:TalentKnown(MassDisintegrate.id)) then return end
    if gs.activeEnemies ~= 2 then return end
    if player:TalentKnown(EternitysSpan.id) then return end
    if not gs.canUseEmpower then return end

    return spell:Cast(target)
end)

EternitySurgeToo:Callback("st2", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= 18000 or not player:TalentKnown(MassDisintegrate.id)) then return end
    if gs.activeEnemies ~= 2 then return end
    if player:TalentKnown(EternitysSpan.id) then return end
    if not gs.canUseEmpower then return end

    return spell:Cast(target)
end)

-- actions.st+=/eternity_surge,target_if=max:target.health.pct,empower_to=1,if=(!talent.power_swell|buff.power_swell.remains<=duration|!talent.mass_disintegrate)&variable.can_use_empower
EternitySurge:Callback("st3", function(spell)
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= 24000 or not player:TalentKnown(MassDisintegrate.id)) then return end
    if not gs.canUseEmpower then return end

    return spell:Cast(target)
end)

EternitySurgeToo:Callback("st3", function(spell)
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if not (not player:TalentKnown(PowerSwell.id) or player:BuffRemains(buffs.powerSwell) <= 24000 or not player:TalentKnown(MassDisintegrate.id)) then return end
    if not gs.canUseEmpower then return end

    return spell:Cast(target)
end)

-- actions.st+=/deep_breath,if=(talent.imminent_destruction|talent.melt_armor|talent.maneuverability)&!set_bonus.tww3_4pc,interrupt_immediate=1,interrupt_if=gcd.remains=0&ticks>=8,cancel_if=gcd.remains=0&ticks>=8
DeepBreath:Callback("st4", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not (player:TalentKnown(ImminentDestruction.id) or player:TalentKnown(MeltArmor.id) or player:TalentKnown(Maneuverability.id)) then return end
    if gs.has4Set then return end -- Disabled when Season 3 (TWW3) 4pc is equipped

    return spell:Cast()
end)

DeepBreathScale:Callback("st4", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end

    if not (player:TalentKnown(ImminentDestruction.id) or player:TalentKnown(MeltArmor.id) or player:TalentKnown(Maneuverability.id)) then return end
    if gs.has4Set then return end -- Disabled when Season 3 (TWW3) 4pc is equipped

    return spell:Cast()
end)

-- actions.st+=/living_flame,if=buff.leaping_flames.up&buff.essence_burst.stack=0&buff.inner_flame.up&(buff.inner_flame.remains>execute_time|!buff.dragonrage.up&buff.burnout.up)&set_bonus.tww3_4pc
LivingFlameDmg:Callback("st3", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not player:Buff(buffs.leapingFlames) then return end
    if player:HasBuffCount(buffs.essenceBurst) ~= 0 then return end
    if not player:Buff(buffs.innerFlame) then return end
    if not (player:BuffRemains(buffs.innerFlame) > spell:CastTime() or not player:Buff(buffs.dragonrage) and player:Buff(buffs.burnout)) then return end
    if not gs.has4Set then return end -- Requires Season 3 (TWW3) 4pc

    return spell:Cast(target)
end)

-- actions.st+=/disintegrate,target_if=min:debuff.bombardments.remains,early_chain_if=ticks_remain<=1&buff.mass_disintegrate_stacks.up,if=(raid_event.movement.in>2|buff.hover.up)&buff.mass_disintegrate_stacks.up&talent.mass_disintegrate&!variable.pool_for_id
Disintegrate:Callback("st", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if not gs.massDisintegrate then return end
    if not player:TalentKnown(MassDisintegrate.id) then return end
    if gs.poolForId then return end

    return spell:Cast(target)
end)

-- actions.st+=/pyre,if=talent.snapfire&active_enemies>=2&talent.volatility.rank>=2&(!talent.azure_celerity|talent.feed_the_flames)
Pyre:Callback("st", function(spell)
    if not player:TalentKnown(Snapfire.id) then return end
    if gs.activeEnemies < 2 then return end
    if player:TalentRank(Volatility.id) < 2 then return end
    if not (not player:TalentKnown(AzureCelerity.id) or player:TalentKnown(FeedTheFlames.id)) then return end

    return spell:Cast(target)
end)

--actions.st+=/call_action_list,name=es,if=(!talent.dragonrage|variable.next_dragonrage>variable.dr_prep_time_st|!talent.animosity|talent.mass_disintegrate)&(!set_bonus.tww2_4pc|!buff.jackpot.up|talent.mass_disintegrate)
EternitySurge:Callback("st3", function(spell) -- Also what in the fuck?
    if player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    
    if (not player:TalentKnown(Dragonrage.id) or gs.nextDragonrage > gs.drPrepTimeSt or not player:TalentKnown(Animosity.id) or player:TalentKnown(MassDisintegrate.id)) and (not player:Buff(buffs.jackpot) or player:TalentKnown(MassDisintegrate.id)) then
        return spell:Cast(target)
    end
end)

EternitySurgeToo:Callback("st3", function(spell) -- Also what in the fuck?
    if not player:TalentKnown(FontOfMagic.id) then return end
    if player.moving and not player:Buff(buffs.tipTheScales) then return end
    if (not player:TalentKnown(Dragonrage.id) or gs.nextDragonrage > gs.drPrepTimeSt or not player:TalentKnown(Animosity.id) or player:TalentKnown(MassDisintegrate.id)) and (not player:Buff(buffs.jackpot) or player:TalentKnown(MassDisintegrate.id)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/disintegrate,target_if=min:debuff.bombardments.remains,chain=1,interrupt_if=buff.inner_flame.up,if=(raid_event.movement.in>2|buff.hover.up)&!variable.pool_for_id
Disintegrate:Callback("st2", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end
    if gs.poolForId then return end

    return spell:Cast(target)
end)

-- actions.st+=/call_action_list,name=green,if=talent.ancient_flame&!buff.ancient_flame.up&!buff.shattering_star_debuff.up&talent.scarlet_adaptation&!buff.dragonrage.up&!buff.burnout.up&talent.engulfing_blaze
VerdantEmbrace:Callback("st", function(spell)
    if not player:TalentKnown(AncientFlame.id) then return end
    if player:Buff(buffs.ancientFlame) then return end
    if target:Debuff(debuffs.shatteringStar, true) then return end
    if not player:TalentKnown(ScarletAdaptation.id) then return end
    if player:Buff(buffs.dragonrage) then return end
    if player:Buff(buffs.burnout) then return end
    if not player:TalentKnown(EngulfingBlaze.id) then return end

    return spell:Cast()
end)

-- actions.st+=/deep_breath,if=!buff.dragonrage.up&active_enemies>=2&((raid_event.adds.in>=120&!talent.onyx_legacy)|(raid_event.adds.in>=60&talent.onyx_legacy))
-- actions.st+=/deep_breath,if=!buff.dragonrage.up&(talent.imminent_destruction&!debuff.shattering_star_debuff.up|talent.melt_armor|talent.maneuverability)
-- actions.st+=/deep_breath,if=talent.imminent_destruction&raid_event.adds.in>=cooldown*0.4&!buff.essence_burst.up
DeepBreath:Callback("st3", function(spell)
    if player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if player:TalentKnown(ImminentDestruction.id) and incAddsIn() >= GetSpellBaseCooldown(spell.id) * 0.4 and not player:Buff(buffs.essenceBurst) then
        return spell:Cast()
    end

    if player:Buff(buffs.dragonrage) then return end
    if gs.activeEnemies >= 2 then
        return spell:Cast()
    end

    if player:TalentKnown(ImminentDestruction.id) and not target:Debuff(debuffs.shatteringStar, true) or player:TalentKnown(MeltArmor.id) or player:TalentKnown(Maneuverability.id) then
        return spell:Cast()
    end
end)

DeepBreathScale:Callback("st3", function(spell)
    if not player:TalentKnown(Maneuverability.id) then return end -- Prevent non-Scalecommander cooldown bug
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if not shouldBurst() and not cooldownUsage[2] then return end
    
    if player:TalentKnown(ImminentDestruction.id) and incAddsIn() >= GetSpellBaseCooldown(spell.id) * 0.4 and not player:Buff(buffs.essenceBurst) then
        return spell:Cast()
    end

    if player:Buff(buffs.dragonrage) then return end
    if gs.activeEnemies >= 2 then
        return spell:Cast()
    end

    if player:TalentKnown(ImminentDestruction.id) and not target:Debuff(debuffs.shatteringStar, true) or player:TalentKnown(MeltArmor.id) or player:TalentKnown(Maneuverability.id) then
        return spell:Cast()
    end
end)

--actions.st+=/pyre,if=(variable.pyre_st|active_enemies>1&talent.snapfire)&!variable.pool_for_id
Pyre:Callback("st2", function(spell)
    if gs.activeEnemies > 1 and player:TalentKnown(Snapfire.id) and not gs.poolForId then
        return spell:Cast(target)
    end
end)

--actions.st+=/disintegrate,target_if=min:buff.bombardments.remains,chain=1,early_chain_if=evoker.use_early_chaining&ticks>=2&(raid_event.movement.in>2|buff.hover.up)&(buff.dragonrage.up|set_bonus.tww1_4pc),interrupt_if=evoker.use_clipping&ticks>=2&(raid_event.movement.in>2|buff.hover.up)&(buff.dragonrage.up|set_bonus.tww1_4pc),if=(raid_event.movement.in>2|buff.hover.up)&!variable.pool_for_id&!variable.pool_for_cb&!variable.pyre_st
Disintegrate:Callback("st2", function(spell)
    if player.moving and not player:Buff(buffs.hover) then return end

    if not gs.poolForId and not gs.poolForCb then
        return spell:Cast(target)
    end
end)

--actions.st+=/firestorm,if=active_enemies>1
Firestorm:Callback("st2", function(spell)
    if not gs.cursorCheck then return end
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.activeEnemies > 1 then
        return spell:Cast()
    end
end)

-- actions.st+=/living_flame,if=buff.burnout.up|(buff.leaping_flames.up|buff.ancient_flame.up)&raid_event.movement.in>execute_time
LivingFlameDmg:Callback("st4", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if player:Buff(buffs.burnout) or (player:Buff(buffs.leapingFlames) or player:Buff(buffs.ancientFlame)) then
        return spell:Cast(target)
    end
end)

-- actions.st+=/azure_strike,if=active_enemies>=2&!talent.snapfire
AzureStrike:Callback("st2", function(spell)
    if gs.activeEnemies < 2 then return end
    if player:TalentKnown(Snapfire.id) then return end

    return spell:Cast(target)
end)

-- actions.st+=/living_flame,if=raid_event.movement.in>execute_time
LivingFlameDmg:Callback("st5", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast(target)
end)

-- actions.st+=/azure_strike
AzureStrike:Callback("st3", function(spell)
    return spell:Cast(target)
end)

local function st()
    DeepBreath("st")
    DeepBreathScale("st")
    Dragonrage("st")
    EternitySurge("st")
    EternitySurgeToo("st")
    LivingFlameDmg("st")
    Hover("st")
    TipTheScales("st")
    ShatteringStar("st")
    FireBreath("st")
    FireBreathToo("st")
    FireBreath("st2")
    FireBreathToo("st2")
    FireBreath("st3")
    FireBreathToo("st3")
    Engulf("st")
    LivingFlameDmg("st2")
    AzureStrike("st")
    Firestorm("st")
    EternitySurge("st2")
    EternitySurgeToo("st2")
    EternitySurge("st3")
    EternitySurgeToo("st3")
    DeepBreath("st4")
    DeepBreathScale("st4")
    LivingFlameDmg("st3")
    Disintegrate("st")
    Pyre("st")
    Disintegrate("st2")
    VerdantEmbrace("st")
    LivingFlameDmg("st4")
    AzureStrike("st2")
    LivingFlameDmg("st5")
    AzureStrike("st3")
end

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()
    
    local makAlert = A.GetToggle(2, "makAware")

    if recastFb() then
        return A.FireBreath:Show(icon)
    end
    if recastEs() then
        return A.EternitySurge:Show(icon)
    end

    if makAlert[1] then
        if player:Buff(buffs.hover) then
            Aware:displayMessage("Hover Active!", "Green", 1)
        end
    end

    if makAlert[2] then
        if (player:Buff(buffs.deepBreath) or player:Buff(buffs.deepBreathScale)) and not A.DeepBreath:IsBlocked() and not A.DeepBreathScale:IsBlocked() then
            Aware:displayMessage("Deep Breath!", "Blue", 1)
        end
    end

    if makAlert[3] then
        if player.inCombat and target.exists and target.canAttack and not LivingFlame:InRange(target) then
            Aware:displayMessage("Out of Range!", "Red", 1)
        end
    end

    local casting = player.castOrChannelInfo
    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Haste Percent (sheet): ", GetCombatRatingBonus(20))
        MakPrint(2, "Spell Haste (calc): ", gs.spellHaste)
        MakPrint(3, "Casting Fire Breath: ", casting and (casting.spellId == FireBreath.id or casting.spellId == FireBreathToo.id))
        MakPrint(4, "Fire Breath Used: ", FireBreathToo.used)
        MakPrint(5, "Empower Stage: ", EmpowerStage())
        MakPrint(6, "Target Distance: ", target.distance)
        MakPrint(7, "In Raid: ", gs.inRaid)
        MakPrint(8, "Fire Breath Cooldown: ", gs.fbCD)
        MakPrint(9, "Eternity Surge Cooldown: ", gs.esCD)
        MakPrint(10, "Next Dragonrage: ", gs.nextDragonrage)
        MakPrint(11, "Can Extend DR: ", gs.canExtendDr)
        MakPrint(12, "Target TTD Makulu: ", target.ttd)
    end

    makInterrupt(interrupts)

    if not player.channeling then
        ObsidianScales()
        Zephyr()
        RenewingBlaze()
        BlessingOfTheBronze()
        TailSwipe("pvp")
        LivingFlame("heal")
        NullifyingShroud()
        VerdantEmbrace("precombat")
        Hover("precombat")
    end

    if target.exists and target.canAttack and LivingFlame:InRange(target) and not player.channeling then
        -- actions+=/quell,use_off_gcd=1,if=target.debuff.casting.react
        if target.pvpKick then
            Quell("target")
        end

        Firestorm("pre")
        LivingFlameDmg("pre")

        -- actions=potion,if=(!talent.dragonrage|buff.dragonrage.up)&(!cooldown.shattering_star.up|debuff.shattering_star_debuff.up|active_enemies>=2)|fight_remains<35
        local damagePotion = Action.GetToggle(2, "damagePotion")
        local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
        local potionExhausted = Action.GetToggle(2, "potionExhausted")
        local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
        local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

        if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
            local shouldPot = (not player:TalentKnown(Dragonrage.id) or player:Buff(buffs.dragonrage)) and (ShatteringStar.cd > 500 or target:Debuff(debuffs.shatteringStar, true) or gs.activeEnemies >= 2) or target.ttd < 35000
            if shouldPot then
                return damagePotionObject:Show(icon)
            end
        end

        if shouldBurst() then
            local shouldTrinket = player:Buff(buffs.dragonrage)
            if shouldTrinket then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
        end

        if gs.shouldAoE then
            aoe()
        else
            st()
        end
        AzureStrike()
    end

	return FrameworkEnd()
end

Quell:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

SleepWalk:Callback("arena", function(spell, enemy)
    if gs.imCasting and gs.imCasting == spell.id then return end

    local sleepWalkExists = MakMulti.arena:Any(function(unit) return unit:DebuffRemains(debuffs.sleepWalk, true) > SleepWalk:CastTime() + MakGcd() end)
    if sleepWalkExists then return end
    if enemy:IsCCImmune() then return end
    if target.hp < 30 then return end
    if enemy.isTarget then return end
    if enemy.hp < 50 then return end
    if enemy:CCRemains() > spell:CastTime() + MakGcd() then return end
    if enemy.disorientDr < 0.5 then return end

    if enemy.isHealer then
        if spell:Cast(enemy) then
            Aware:displayMessage("Sleep Walk Healer", "Green", 1)
	        return
	    end
    end

    local partyDanger = MakMulti.party:Any(function(unit) return unit.hp > 0 and unit.hp < 50 end)
    if partyDanger and not enemy.isHealer and enemy.cds then
	if spell:Cast(enemy) then	
            Aware:displayMessage("Sleep Walk " .. enemy.name .. " to peel", "Red", 1)
	        return
	    end
        return spell:Cast(enemy)
    end
end)

Unravel:Callback("arena", function(spell, enemy)
    if UnitGetTotalAbsorbs(enemy:CallerId()) < 50000 then return end

    return spell:Cast(enemy)
end)

ChronoLoop:Callback("arena", function(spell, enemy)
    if enemy.hp > 40 then return end

    return spell:Cast(enemy)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end
    if enemy.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    Quell("arena", enemy)
    SleepWalk("arena", enemy)
    Unravel("arena", enemy)
    ChronoLoop("arena", enemy)
end

VerdantEmbrace:Callback(function(spell, friendly)
    local veSelect = A.GetToggle(2, "veSelect")
    if player:Buff(buffs.arenaPreparation) then return end
    if not player.inCombat and target.canAttack and target.distance < 25 then return end

    if not spell:InRange(friendly) then return end

    if not veSelect[1] and friendly.isTank then return end
    if not veSelect[2] and friendly.isHealer then return end
    if not veSelect[3] and not friendly.isTank and not friendly.isHealer and not friendly.isMe then return end
    if not veSelect[4] and friendly.isMe then return end

    local lowestFriendly = MakMulti.party:Lowest(function(unit) return unit.hp end)
    if not friendly:IsUnit(lowestFriendly) then return end

    if player.inCombat and (not player.moving or player:Buff(buffs.tipTheScales)) and (gs.fbCD > 300 or gs.esCD > 300) then return end

    if friendly.hp > 0 then
        if friendly.hp <= A.GetToggle(2, "verdantEmbraceHP") or A.GetToggle(2, "healForDPS") and gs.useHeal then
            return spell:Cast(friendly)
        end
    end
end)

EmeraldBlossom:Callback(function(spell, icon, friendly)
    local icon = icon or SwoopUp
    if Action.Zone == "arena" then return end
    
    if player:Buff(buffs.arenaPreparation) then return end
    if not player.inCombat and target.canAttack and target.distance < 25 then return end

    if not spell:InRange(friendly) then return end

    local lowestFriendly = MakMulti.party:Lowest(function(unit) return unit.hp end)
    if not friendly:IsUnit(lowestFriendly) then return end

    if player.inCombat and (not player.moving or player:Buff(buffs.tipTheScales)) and (gs.fbCD > 300 or gs.esCD > 300) then return end

    if friendly.hp > 0 then
        if friendly.hp <= A.GetToggle(2, "emeraldBlossomHP") or A.GetToggle(2, "healForDPS") and gs.useHeal then
            return spell:Cast(friendly, nil, icon)
        end
    end
end)

Expunge:Callback(function(spell, friendly)
    if Action.Zone == "arena" then return end
    if not spell:InRange(friendly) then return end
    if not friendly.poisoned then return end

    return Debounce("dispel", 1000, 2500, spell, friendly)
end)

CauterizingFlame:Callback(function(spell, friendly)
    if not spell:InRange(friendly) then return end

    if friendly.bleeding or friendly.poisoned or friendly.cursed or friendly.diseased then
        return Debounce("cf", 1000, 2500, spell, friendly)
    end
end)

SourceOfMagic:Callback(function(spell, friendly)
    if not spell:InRange(friendly) then return end
    if friendly.distance > 25 then return end

    if not friendly.isHealer then return end
    if friendly:Buff(buffs.sourceOfMagic) then return end
    
    return Debounce("SoM", 1000, 2500, spell, friendly)
end)

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if player.mounted then return end
    if player.stealthed then return end
    if IsResting() then return end
    Expunge(friendly)
    CauterizingFlame(friendly)
    VerdantEmbrace(friendly)
    EmeraldBlossom(icon, friendly)
    SourceOfMagic(friendly)
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
