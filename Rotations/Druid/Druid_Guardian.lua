if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 104 then return end

--[[
to do:
party dispels
vortex > typhoon
]]--


local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local Debounce         = MakuluFramework.debounceSpell
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local NeedRaidBuff     = MakuluFramework.NeedRaidBuff

local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local AuraIsValid      = Action.AuraIsValid

local MakuluFunctions = MakuluFramework.OLD
local EnemiesInSpellRange = MakuluFunctions.EnemiesInSpellRange

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

    Barkskin = { ID = 22812 },
    BearForm = { ID = 5487 },
    CatForm = { ID = 768 },
    Dash = { ID = 1850 },
    Dreamwalk = { ID = 193753 },
    EntanglingRoots = { ID = 339, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm][]spell:thisID" },
    FerociousBite = { ID = 22568 },
    FrenziedRegeneration = { ID = 22842 },
    Growl = { ID = 6795 },
    HeartoftheWild = { ID = 319454 },
    IncapacitatingRoar = { ID = 99 },
    Ironfur = { ID = 192081 },
    Mangle = { ID = 33917 },
    Moonfire = { ID = 8921 },
    Prowl = { ID = 5215 },
    Rebirth = { ID = 461623, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Regrowth = { ID = 8936, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Rejuvenation = { ID = 774, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    RemoveCorruption = { ID = 2782, Macro = "/cast [@target,exists][@focus,exists][]spell:thisID" },
    Renewal = { ID = 108238 },
    Revive = { ID = 50769, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Shred = { ID = 5221 },
    SkullBash = { ID = 106839 },
    Soothe = { ID = 2908, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    StampedingRoar = { ID = 106898 },
    Swipe = { ID = 213764 },
    Thrash = { ID = 77758 },
    TravelForm = { ID = 783 },
    Typhoon = { ID = 132469 },
    UrsolsVortex = { ID = 102793 },
    WildCharge = { ID = 102401 },
    Wrath = { ID = 5176 },
    Hibernate = { ID = 2637 },
    MarkoftheWild = { ID = 1126, Macro = "/cast [@target,exists][@focus,exists][@player][]spell:thisID" },

    Rake = { ID = 1822 },
    IncarnationGuardianofUrsoc = { ID = 102558 },
    LunarBeam = { ID = 204066 },
    Maul = { ID = 6807, Texture = 68992 },
    RageoftheSleeper = { ID = 200851 },
    Raze = { ID = 400254 },
    SurvivalInstincts = { ID = 61336 },

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

    FocusParty1 = { ID = 134314, Hidden = true, FixedTexture = 134314, Type = "Spell" },
    FocusParty2 = { ID = 134316, Hidden = true, FixedTexture = 134316, Type = "Spell" },
    FocusParty3 = { ID = 134318, Hidden = true, FixedTexture = 134318, Type = "Spell" },
    FocusParty4 = { ID = 134320, Hidden = true, FixedTexture = 134320, Type = "Spell" },
    FocusParty5 = { ID = 134310, Hidden = true, FixedTexture = 134310, Type = "Spell" },

    FlashingClaws = { ID = 393427 },
    FuryofNature = { ID = 370695 },
    Rip = { ID = 1079 },
    WildpowerSurge = { ID = 441691 },
    LunarCalling = { ID = 529523 },
    Berserk = { ID = 50334 },
    ConvoketheSpirits = { ID = 391528, FixedTexture = 3636839 },
    FountofStrength = { ID = 441675 },
    FluidForm = { ID = 449193 },
    BoundlessMoonlight = { ID = 424058 },
    Pulverize = { ID = 80313 },
    Starsurge = { ID = 197626 },
    LunarInsight = { ID = 429530 },

    ThornsOfIron = { ID = 400222, Hidden = true },
    UrsocsEndurance = { ID = 393611, Hidden = true },
    Ravage = { ID = 441583, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DRUID_GUARDIAN] = A

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

local gameState = {}

local buffs = {
	form_bear = 5487,
	form_cat = 768,
	form_travel = 783,
	prowl = 5215,
	regrowth = 8936,
	barkskin = 22812,
	dash = 1850,
	stampeding_roar = 77764,
	mark_of_the_wild = 1126,
	survival_instincts = 61336,
	ravage = 441583,
	tooth_and_claw = 135286,
	rage_of_the_sleeper = 200851,
	berserk_bear = 50334,
	vicious_cycle_maul = 372015,
	gore = 93622,
	galactic_guardian = 213708,
	vicious_cycle = 372019,
	frenzied_regeneration = 22842,

	feline_potential_counter = 441701,
	feline_potential = 441702,
}

local debuffs = {
    moon_fire = 164812,
    thrash = 192090,
}

local function num(val)
    if val then return 1 else return 0 end
end

--[[Player:AddTier("Tier31", { 207281, 207279, 207284, 207280, 207282, })
local T31has2P = Player:HasTier("Tier31", 2)
local T31has4P = Player:HasTier("Tier31", 4)]]

local interrupts = {
    { spell = SkullBash },
    { spell = IncapacitatingRoar, isCC = true },
}

local function handleInterrupts(enemiesList)
    local _, _, _, lagWorld = GetNetStats()
    local interruptSpells = {
        {spell = A.SkullBash, minPercent = 50, isCC = false, aoe = false},
        {spell = A.Hibernate, minPercent = 50, isCC = true, aoe = false },
        {spell = A.IncapacitatingRoar, minPercent = 50, isCC = true, aoe = true },
        {spell = A.Typhoon, minPercent = 25, isCC = true, aoe = true },
    }

    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        for _, spellInfo in ipairs(interruptSpells) do
            local shouldInterrupt = enemy:PvEInterrupt(spellInfo.spell, spellInfo.minPercent, spellInfo.minEndTime, spellInfo.isCC, spellInfo.aoe)
            if shouldInterrupt == "Switch" and not spellInfo.aoe then
                return "Switch"
            elseif shouldInterrupt == true then
                return spellInfo.spell
            end
        end
    end

    return nil
end
local cacheContext     = MakuluFramework.Cache

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 10 and not enemy:IsTotem() and not enemy.isPet then
                total = total + 1
            end
        end
        
        return total
    end)
end

local function shouldBurst()
    if A.BurstIsON("target") then
        if A.Zone ~= "arena" then
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemy in pairs(activeEnemies) do
                if ActionUnit(enemy):Health() > (A.Maul:GetSpellDescription()[1] * 20) or target.isDummy then
                    return true
                end
            end
        else
            return true
        end
    end
    return false
end

local function amITankingBoss()
    if IsInRaid() then
        for i = 1, 5 do
            local unitID = "boss" .. i
            if UnitExists(unitID) and UnitIsUnit("player", unitID .. "target") then
                return true
            end
        end
    end
    return false
end

local function autoTarget()
    if not player.inCombat then return false end

    if A.GetToggle(2, "autotarget") then
        for _, spellInfo in ipairs(interrupts) do
            if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
                return false
            end
        end
    end

    if A.GetToggle(2, "autotaunt") and gameState.ShouldTaunt == "Switch" then
        return true
    end

    if Mangle:InRange(target) and target.exists then return false end

    if A.GetToggle(2, "targetmelee") and gameState.rangeMelee > 0 then
        return true
    end
end

local function updateGameState()

    local inInstance, instanceType = IsInInstance()

    gameState = {
        isMoving = player.moving,
        inCombat = player.inCombat,
        --stayTime = player.stayTime, weirdly broken
        inInstance = inInstance,
        inDungeon = inInstance and instanceType == "party",
        inRaid = inInstance and instanceType == "raid",
        wantedTarget = nil,
        wantedSlot = nil,
        range40 = EnemiesInSpellRange(A.Moonfire),
        range8 = EnemiesInSpellRange(A.Thrash),
        rangeMelee = EnemiesInSpellRange(A.Mangle),
        rage = player.rage,
        tankBusterIn = MakuluFramework.DBM_TankBusterIn() or 1000000,
        burst = shouldBurst(),
        shouldTaunt = MakuluFramework.TauntStatus(Growl),
        ifBuild = player:TalentKnown(ThornsOfIron.id) and player:TalentKnown(UrsocsEndurance.id)
    }
end

FrenziedRegeneration:Callback("pve", function(spell)
    if player.rage < 10 then return end
    if player:Buff(buffs.frenzied_regeneration) then return end
    if player.hp < A.GetToggle(2, "FRegenHP") and player:Buff(buffs.form_bear) then
        return spell:Cast()
    end
end)

Mangle:Callback("pve-highprio", function(spell)
    if not player:Buff(buffs.vicious_cycle) or player:HasBuffCount(buffs.vicious_cycle) < 3 then return false end

    return spell:Cast(target)
end)

-- actions.bear=maul,if=buff.ravage.up&active_enemies>1
Maul:Callback("pve", function(spell)
    if target:Debuff(debuffs.maul) then return false end

    return spell:Cast(target)
end)

-- actions.bear+=/heart_of_the_Wild,if=(talent.heart_of_the_wild.enabled&!talent.rip.enabled)|talent.heart_of_the_wild.enabled&buff.feline_potential_counter.stack=6&active_enemies<3
HeartoftheWild:Callback("pve", function(spell)
    if not gameState.burst then return false end

    if player:TalentKnown(HeartoftheWild.id) and not player:TalentKnown(Rip.id) and enemiesInMelee() > 0 then
        return spell:Cast(player)
    end

    if player:TalentKnown(HeartoftheWild.id) and player:Buff(buffs.feline_potential_counter) == 6 and enemiesInMelee() > 0 and enemiesInMelee() < 3 then
        return spell:Cast(player)
    end
end)

Thrash:Callback("pvenew", function(spell)
    if not Mangle:InRange(target) then return end
    if enemiesInMelee() < 1 then return end

    return spell:Cast(target)
end)

-- actions.bear+=/moonfire,cycle_targets=1,if=buff.bear_form.up&(((!ticking&target.time_to_die>12)|(refreshable&target.time_to_die>12))&active_enemies<7&talent.fury_of_nature.enabled)|(((!ticking&target.time_to_die>12)|(refreshable&target.time_to_die>12))&active_enemies<4&!talent.fury_of_nature.enabled)
Moonfire:Callback("pve", function(spell)
    if not player:Buff(buffs.form_bear) or target:Debuff(debuffs.moon_fire) then return false end

    if (not target:Debuff(debuffs.moon_fire) and target.action:TimeToDie() > 12 or target:Debuff(debuffs.moon_fire) and target.action:TimeToDie() > 12) and gameState.range40 < 7 and player:TalentKnown(FuryofNature.id) then
        return spell:Cast(target)
    end

    if (not target:Debuff(debuffs.moon_fire) and target.action:TimeToDie() > 12 or target:Debuff(debuffs.moon_fire) and target.action:TimeToDie() > 12) and gameState.range40 < 4 and not player:TalentKnown(FuryofNature.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/thrash_bear,target_if=refreshable|(dot.thrash_bear.stack<5&talent.flashing_claws.rank=2|dot.thrash_bear.stack<4&talent.flashing_claws.rank=1|dot.thrash_bear.stack<3&!talent.flashing_claws.enabled)
Thrash:Callback("pve", function(spell)
    if not Mangle:InRange(target) then return end
    if Thrash.cd > 0 then return false end

    if (target:HasDeBuffCount(debuffs.thrash) < 5 and player:TalentKnown(FlashingClaws.id)) or (target:HasDeBuffCount(debuffs.thrash) < 4 and player:TalentKnown(FlashingClaws.id) == 1) or (target:HasDeBuffCount(debuffs.thrash) < 3 and not player:TalentKnown(FlashingClaws.id)) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/lunar_beam
LunarBeam:Callback("pve", function(spell)
    if not gameState.burst then return false end
    if gameState.isMoving then return false end
    if enemiesInMelee() < 3 and (not target.isBoss and not target.isDummy) then return false end
    if enemiesInMelee() == 0 then return end

    return spell:Cast(target)
end)

-- actions.bear+=/convoke_the_spirits,if=(talent.wildpower_surge.enabled&buff.cat_form.up&buff.feline_potential.up)|!talent.wildpower_surge.enabled
ConvoketheSpirits:Callback("pve", function(spell)
    if not gameState.burst then return false end
    if enemiesInMelee()< 3 and (not target.isBoss and not target.isDummy) then return false end
    if player:TalentKnown(WildpowerSurge.id) and player:Buff(buffs.form_cat) and player:Buff(buffs.feline_potential) then
        return spell:Cast(target)
    end

    if not player:TalentKnown(WildpowerSurge.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/berserk_bear
Berserk:Callback("pve", function(spell)
    if enemiesInMelee() < 3 and (not target.isBoss and not target.isDummy) then return false end
    if A.BurstIsON("target") and enemiesInMelee() > 0 then
        return spell:Cast(player)
    end
end)

-- actions.bear+=/rage_of_the_sleeper,if=(((buff.incarnation_guardian_of_ursoc.down&cooldown.incarnation_guardian_of_ursoc.remains>60)|buff.berserk_bear.down)&rage>40&(!talent.convoke_the_spirits.enabled)|(buff.incarnation_guardian_of_ursoc.up|buff.berserk_bear.up)&rage>40&(!talent.convoke_the_spirits.enabled)|(talent.convoke_the_spirits.enabled)&rage>40)
RageoftheSleeper:Callback("pve", function(spell)
    if ((not player:Buff(buffs.incarnation_guardian_of_ursoc) and IncarnationGuardianofUrsoc.cd > 60000 or not player:Buff(buffs.berserk_bear)) and player.rage > 40000 and not player:TalentKnown(ConvoketheSpirits.id)) or (player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear) and player.rage > 40 and not player:TalentKnown(ConvoketheSpirits.id)) or player:TalentKnown(ConvoketheSpirits.id) and player.rage > 40 then
        return spell:Cast()
    end

    if A.BurstIsON("target") and enemiesInMelee() > 0 then
        return spell:Cast()
    end
end)

-- actions.bear+=/maul,if=buff.ravage.up&active_enemies<2
Maul:Callback("pve", function(spell)
    if not target:Buff(buffs.ravage) then return false end
    if enemiesInMelee() > 2 then return false end

    return spell:Cast(target)
end)

-- actions.bear+=/raze,if=(buff.tooth_and_claw.stack>1|buff.tooth_and_claw.up&buff.tooth_and_claw.remains<1+gcd)&variable.If_build=1
-- actions.bear+=/raze,if=variable.If_build=0&(buff.tooth_and_claw.stack>1|buff.tooth_and_claw.up&buff.tooth_and_claw.remains<1+gcd|buff.vicious_cycle_maul.stack=3)
Raze:Callback("pve", function(spell)
    if not Mangle:InRange(target) then return end

    if player:HasBuffCount(buffs.tooth_and_claw) > 1 or player:Buff(buffs.tooth_and_claw) and player:BuffRemains(buffs.tooth_and_claw) < 1000 + MakGcd() then
        if gameState.ifBuild or player:HasBuffCount(buffs.vicious_cycle_maul) == 3 then
            return spell:Cast(target)
        end
    end
end)

-- actions.bear+=/thrash_bear,if=active_enemies>=5&talent.lunar_calling.enabled
Thrash:Callback("pve2", function(spell)
    if Thrash.cd > 0 then return false end
    if not Mangle:InRange(target) then return end

    if enemiesInMelee() >= 5 and player:TalentKnown(LunarCalling.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/ironfur,target_if=!debuff.tooth_and_claw.up,if=!buff.ironfur.up&rage>50&!cooldown.pause_action.remains&variable.If_build=0&!buff.rage_of_the_sleeper.up|rage>90&variable.If_build=0|!debuff.tooth_and_claw.up&!buff.ironfur.up&rage>50&!cooldown.pause_action.remains&variable.If_build=0&!buff.rage_of_the_sleeper.up
Ironfur:Callback("pve", function(spell)
    if not target:Debuff(debuffs.tooth_and_claw) and not player:Buff(buffs.ironfur) and player.rage > 50 and ((not player:Buff(buffs.rage_of_the_sleeper) or player.rage > 90) or (not target:Debuff(debuffs.tooth_and_claw) and not player:Buff(buffs.ironfur) and player.rage > 50 and not player:Buff(buffs.rage_of_the_sleeper))) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/ironfur,if=!buff.ravage.up&((rage>40&variable.If_build=1&cooldown.rage_of_the_sleeper.remains>3&talent.rage_of_the_sleeper.enabled|(buff.incarnation.up|buff.berserk_bear.up)&rage>20&variable.If_build=1&cooldown.rage_of_the_sleeper.remains>3&talent.rage_of_the_sleeper.enabled|rage>90&variable.If_build=1&!talent.fount_of_strength.enabled|rage>110&variable.If_build=1&talent.fount_of_strength.enabled|(buff.incarnation.up|buff.berserk_bear.up)&rage>20&variable.If_build=1&buff.rage_of_the_sleeper.up&talent.rage_of_the_sleeper.enabled))
Ironfur:Callback("pve2", function(spell)
    if not target:Buff(buffs.ravage) and ((player.rage > 40 and player:HasBuffCount(buffs.rage_of_the_sleeper) > 3 and player:TalentKnown(RageoftheSleeper.id)) or ((player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and player.rage > 20 and player:Buff(buffs.rage_of_the_sleeper) > 3 and player:TalentKnown(RageoftheSleeper.id)) or (player.rage > 90 and not player:TalentKnown(FountofStrength.id)) or (player.rage > 110 and player:TalentKnown(FountofStrength.id)) or ((player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and player.rage > 20 and player:Buff(buffs.rage_of_the_sleeper) and player:TalentKnown(RageoftheSleeper.id))) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/ironfur,if=!buff.ravage.up&((rage>40&variable.If_build=1&!talent.rage_of_the_sleeper.enabled|(buff.incarnation.up|buff.berserk_bear.up)&rage>20&variable.If_build=1&!talent.rage_of_the_sleeper.enabled|(buff.incarnation.up|buff.berserk_bear.up)&rage>20&variable.If_build=1&!talent.rage_of_the_sleeper.enabled))
Ironfur:Callback("pve3", function(spell)
    if not target:Buff(buffs.ravage) and (player.rage > 40 and not player:TalentKnown(RageoftheSleeper.id) or (((player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and player.rage > 20 and not player:TalentKnown(RageoftheSleeper.id)) or ((player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and player.rage > 20 and not player:TalentKnown(RageoftheSleeper.id)))) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/ferocious_bite,if=(buff.cat_form.up&buff.feline_potential.up&active_enemies<3&(buff.incarnation.up|buff.berserk_bear.up)&!dot.rip.refreshable)
FerociousBite:Callback("pve", function(spell)
    if player:Buff(buffs.form_cat) and player:Buff(buffs.feline_potential) and enemiesInMelee() < 3 and (player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and not target:Debuff(debuffs.rip) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/rip,if=(buff.cat_form.up&buff.feline_potential.up&active_enemies<3&(!buff.incarnation.up|!buff.berserk_bear.up))|(buff.cat_form.up&buff.feline_potential.up&active_enemies<3&(buff.incarnation.up|buff.berserk_bear.up)&refreshable)
Rip:Callback("pve", function(spell)
    if player:Buff(buffs.form_cat) and player:Buff(buffs.feline_potential) and enemiesInMelee() < 3 and (not player:Buff(buffs.incarnation_guardian_of_ursoc) or not player:Buff(buffs.berserk_bear)) or player:Buff(buffs.form_cat) and player:Buff(buffs.feline_potential) and gameState.range40 < 3 and (player:Buff(buffs.incarnation_guardian_of_ursoc) or player:Buff(buffs.berserk_bear)) and target:Debuff(debuffs.rip) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/raze,if=variable.If_build=1&buff.vicious_cycle_maul.stack=3&!talent.ravage.enabled
Raze:Callback("pve2", function(spell)
    if not Mangle:InRange(target) then return end

    if player:HasBuffCount(buffs.vicious_cycle_maul) == 3 and not player:TalentKnown(Ravage.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/mangle,if=buff.gore.up&active_enemies<11|buff.incarnation_guardian_of_ursoc.up&buff.feline_potential_counter.stack<6&talent.wildpower_surge.enabled
Mangle:Callback("pve", function(spell)
    if player:Buff(buffs.gore) and enemiesInMelee() < 11 or player:Buff(buffs.incarnation_guardian_of_ursoc) and player:Buff(buffs.feline_potential_counter) < 6 and player:TalentKnown(WildpowerSurge.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/raze,if=variable.If_build=0
Raze:Callback("pve3", function(spell)
    if not Mangle:InRange(target) then return end
    if gameState.ifBuild then return end

    return spell:Cast(target)
end)

-- actions.bear+=/shred,if=cooldown.rage_of_the_sleeper.remains<=52&buff.feline_potential_counter.stack=6&!buff.cat_form.up&!dot.rake.refreshable&active_enemies<3&talent.fluid_form.enabled
Shred:Callback("pve", function(spell)
    if RageoftheSleeper.cd <= 52 and player:Buff(buffs.feline_potential_counter) == 6 and not player:Buff(buffs.form_cat) and not target:Debuff(debuffs.rake) and enemiesInMelee() < 3 and player:TalentKnown(FluidForm.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/rake,if=cooldown.rage_of_the_sleeper.remains<=52&buff.feline_potential_counter.stack=6&!buff.cat_form.up&active_enemies<3&talent.fluid_form.enabled
Rake:Callback("pve", function(spell)
    if not Mangle:InRange(target) then return end

    if RageoftheSleeper.cd <= 52 and player:Buff(buffs.feline_potential_counter) == 6 and not player:Buff(buffs.form_cat) and enemiesInMelee() < 3 and player:TalentKnown(FluidForm.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/mangle,if=buff.cat_form.up&talent.fluid_form.enabled
Mangle:Callback("pve2", function(spell)
    if player:Buff(buffs.form_cat) and player:TalentKnown(FluidForm.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/maul,if=variable.If_build=1&(((buff.tooth_and_claw.stack>1|buff.tooth_and_claw.up&buff.tooth_and_claw.remains<1+gcd)&active_enemies<=5&!talent.raze.enabled)|((buff.tooth_and_claw.stack>1|buff.tooth_and_claw.remains<1+gcd)&active_enemies=1&talent.raze.enabled)|((buff.tooth_and_claw.stack>1|buff.tooth_and_claw.up&buff.tooth_and_claw.remains<1+gcd)&active_enemies<=5&!talent.raze.enabled))
Maul:Callback("pve2", function(spell)
    if (((player:HasBuffCount(buffs.tooth_and_claw) > 1 or player:Buff(buffs.tooth_and_claw) and player:BuffRemains(buffs.tooth_and_claw) < 1000 + MakGcd()) and enemiesInMelee() <= 5 and not player:TalentKnown(Raze.id)) or ((player:HasBuffCount(buffs.tooth_and_claw) > 1 or player:Buff(buffs.tooth_and_claw) and player:BuffRemains(buffs.tooth_and_claw) < 1000 + MakGcd()) and enemiesInMelee() == 1 and player:TalentKnown(Raze.id)) or ((player:HasBuffCount(buffs.tooth_and_claw) > 1 or player:BuffRemains(buffs.tooth_and_claw) < 1000 + MakGcd() and enemiesInMelee() <= 5 and not player:TalentKnown(Raze.id)))) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/maul,if=variable.If_build=0&((buff.tooth_and_claw.up&active_enemies<=5&!talent.raze.enabled)|(buff.tooth_and_claw.up&active_enemies=1&talent.raze.enabled))
Maul:Callback("pve3", function(spell)
    if (player:Buff(buffs.tooth_and_claw) and enemiesInMelee() <= 5 and not player:TalentKnown(Raze.id)) or (player:Buff(buffs.tooth_and_claw) and enemiesInMelee() == 1 and player:TalentKnown(Raze.id)) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/maul,if=(active_enemies<=5&!talent.raze.enabled&variable.If_build=0)|(active_enemies=1&talent.raze.enabled&variable.If_build=0)|buff.vicious_cycle_maul.stack=3&active_enemies<=5&!talent.raze.enabled
Maul:Callback("pve4", function(spell)
    if (enemiesInMelee() <= 5 and not player:TalentKnown(Raze.id)) or (enemiesInMelee() == 1 and player:TalentKnown(Raze.id)) or (player:HasBuffCount(buffs.vicious_cycle_maul) == 3 and enemiesInMelee() <= 5 and not player:TalentKnown(Raze.id)) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/thrash_bear,if=active_enemies>=5
Thrash:Callback("pve3", function(spell)
    if Thrash.cd > 0 then return false end
    if not Mangle:InRange(target) then return end

    if enemiesInMelee() >= 5 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/mangle,if=(buff.incarnation.up&active_enemies<=4)|(buff.incarnation.up&talent.soul_of_the_forest.enabled&active_enemies<=5)|((rage<88)&active_enemies<11)|((rage<83)&active_enemies<11&talent.soul_of_the_forest.enabled)
Mangle:Callback("pve3", function(spell)
    if (player:Buff(buffs.incarnation_guardian_of_ursoc) and enemiesInMelee() <= 4) or (player:Buff(buffs.incarnation_guardian_of_ursoc) and player:TalentKnown(SouloftheForest.id) and enemiesInMelee() <= 5) or (player.rage < 88 and enemiesInMelee() < 11) or (player.rage < 83 and enemiesInMelee() < 11 and player:TalentKnown(SouloftheForest.id)) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/thrash_bear,if=active_enemies>1
Thrash:Callback("pve4", function(spell)
    if Thrash.cd > 0 then return false end
    if not Mangle:InRange(target) then return end

    if enemiesInMelee() > 1 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/pulverize,target_if=dot.thrash_bear.stack>2
Pulverize:Callback("pve", function(spell)
    if target:HasDeBuffCount(debuffs.thrash) > 2 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/thrash_bear
Thrash:Callback("pve5", function(spell)
    if Thrash.cd > 0 then return false end
    if not Mangle:InRange(target) then return end

    return spell:Cast(target)
end)

-- actions.bear+=/moonfire,if=buff.galactic_guardian.up&buff.bear_form.up&talent.boundless_moonlight.enabled
Moonfire:Callback("pve2", function(spell)
    if player:Buff(buffs.galactic_guardian) and player:Buff(buffs.form_bear) and player:TalentKnown(BoundlessMoonlight.id) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/rake,if=cooldown.rage_of_the_sleeper.remains<=52&rage<40&active_enemies<3&!talent.lunar_insight.enabled&talent.fluid_form.enabled&energy>70&refreshable
Rake:Callback("pve2", function(spell)
    if RageoftheSleeper.cd <= 52 and player.rage < 40 and enemiesInMelee() < 3 and not player:TalentKnown(LunarInsight.id) and player:TalentKnown(FluidForm.id) and player.energy > 70 and target:DebuffPandemic(debuffs.rake) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/shred,if=cooldown.rage_of_the_sleeper.remains<=52&rage<40&active_enemies<3&!talent.lunar_insight.enabled&talent.fluid_form.enabled&energy>70&!buff.rage_of_the_sleeper.up
Shred:Callback("pve2", function(spell)
    if RageoftheSleeper.cd <= 52 and player.rage < 40 and enemiesInMelee() < 3 and not player:TalentKnown(LunarInsight.id) and player:TalentKnown(FluidForm.id) and player.energy > 70 and not player:Buff(buffs.rage_of_the_sleeper) then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/rip,if=buff.cat_form.up&!dot.rip.ticking&active_enemies<3
Rip:Callback("pve2", function(spell)
    if player:Buff(buffs.form_cat) and not target:Debuff(debuffs.rip) and enemiesInMelee() < 3 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/ferocious_bite,if=dot.rip.ticking&combo_points>4&active_enemies<3
FerociousBite:Callback("pve2", function(spell)
    if target:Debuff(debuffs.rip) and player.comboPoints > 4 and enemiesInMelee() < 3 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/starsurge,if=talent.starsurge.enabled&rage<20
Starsurge:Callback("pve", function(spell)
    if player:TalentKnown(Starsurge.id) and player.rage < 20 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/swipe_bear,if=(talent.lunar_insight.enabled&active_enemies>4)|!talent.lunar_insight.enabled|talent.lunar_insight.enabled&active_enemies<2
Swipe:Callback("pve", function(spell)
    if not Mangle:InRange(target) then return end

    if (player:TalentKnown(LunarInsight.id) and enemiesInMelee() > 4) or not player:TalentKnown(LunarInsight.id) or player:TalentKnown(LunarInsight.id) and enemiesInMelee() < 2 then
        return spell:Cast(target)
    end
end)

-- actions.bear+=/moonfire,if=(talent.lunar_insight.enabled&active_enemies>1)&buff.bear_form.up
Moonfire:Callback("pve3", function(spell)
    if player:TalentKnown(LunarInsight.id) and enemiesInMelee() > 1 and player:Buff(buffs.form_bear) then
        return spell:Cast(target)
    end
end)

-- Moonfire Fallback Test
Moonfire:Callback("pve4", function(spell)
    if not player:Buff(buffs.form_bear) then return false end
    if target:Debuff(debuffs.moon_fire) then return false end

    return spell:Cast(target)
end)

Renewal:Callback("pve", function(spell)
    if player.hp < 50 then
        return spell:Cast()
    end

    if player.hp < 70 and MakuluFramework.TankDefensive() then
        return spell:Cast()
    end
end)

SurvivalInstincts:Callback("pve", function(spell)
    if player.hp < 40 then
        return spell:Cast()
    end

    if MakuluFramework.TankDefensive() and player.hp < 80 and (not player:Buff(buffs.barkskin) and not player:Buff(buffs.incarnation_guardian_of_ursoc)) and amITankingBoss() then
        return spell:Cast()
    end
end)

Barkskin:Callback("pve", function(spell)
    if player.hp < 60 then
        return spell:Cast()
    end

    if MakuluFramework.TankDefensive() and player.hp < 90 and (not player:Buff(buffs.survival_instincts) and not player:Buff(buffs.incarnation_guardian_of_ursoc)) and amITankingBoss() then
        return spell:Cast()
    end
end)

Ironfur:Callback("pve-def", function(spell)
    if player.rage < 30 then return end

    if player:HasBuffCount(buffs.ironfur) < 1 then
        return spell:Cast()
    end

    if player.hp < 70 and player:HasBuffCount(buffs.ironfur) < 2 then
        return spell:Cast()
    end

    if player.hp < 60 and player:HasBuffCount(buffs.ironfur) < 3 then
        return spell:Cast()
    end

    if MakuluFramework.TankDefensive() and player.hp < 90 and amITankingBoss() then
        return spell:Cast()
    end

    if player.rage >= 60 and player.hp < 100 then
        return spell:Cast()
    end
end)

IncarnationGuardianofUrsoc:Callback("pve", function(spell)
    if not IsPlayerSpell(IncarnationGuardianofUrsoc.id) then return end
    if gameState.range8 < 3 and (not target.isBoss and not target.isDummy) then return false end
    if player.hp < 70 and (player:HasBuffCount(buffs.ironfur) < 2 or gameState.range8 > 6 or (target.isBoss and amITankingBoss())) then
        return spell:Cast()
    end

    if MakuluFramework.TankDefensive() and player.hp < 90 and not player:Buff(buffs.survival_instincts) and not player:Buff(buffs.barkskin) and amITankingBoss() then
        return spell:Cast()
    end

    if A.BurstIsON("target") and enemiesInMelee() > 0 then
        return spell:Cast()
    end

    return false
end)

BearForm:Callback("pve", function(spell)
    if not player:Buff(buffs.form_bear) then
        return spell:Cast()
    end
end)

BearForm:Callback("pve-raid", function(spell)
    local agroStatus = UnitThreatSituation("player")

    if agroStatus and (agroStatus == 1 or agroStatus == 3) and not player:Buff(buffs.form_bear) then
        return spell:Cast()
    end
end)

CatForm:Callback("pve-raid", function(spell)
    local agroStatus = UnitThreatSituation("player")

    if not agroStatus and (agroStatus == 2 or agroStatus == 0) and not player:Buff(buffs.form_cat) then
        return spell:Cast()
    end
end)

Rebirth:Callback("pve", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if not mouseover.player then return end

    return spell:Cast(mouseover)
end)

Revive:Callback("pve", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if not mouseover.player then return end

    return spell:Cast(mouseover)
end)

MarkoftheWild:Callback('PreCombat1', function(spell)
    if not NeedRaidBuff(MarkoftheWild) then return end
    return Debounce("raidbuff", 1000, 2500, spell, player)
end)

Soothe:Callback(function(spell)
    if target.enraged then
        return spell:Cast(target)
    end
end)

updateGameState()

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    
	FrameworkStart(icon)
    updateGameState()

    makInterrupt(interrupts)

    if player.combat then
        if gameState.ShouldTaunt == "Taunt" then
            return A.Growl:Show(icon)
        end
    end

    local needRebirth = false

    if player.combat then
        if mouseover.exists and mouseover.isFriendly and mouseover.dead and mouseover.player then
            needRebirth = true
        end
        Rebirth("pve")
    else
        Revive("pve")
    end

    MarkoftheWild("PreCombat1")

    if target.exists and target.canAttack then
        Soothe()
        if gameState.inRaid then
            BearForm("pve-raid")
            CatForm("pve-raid")
        else
            BearForm("pve")
        end
        
        if player:Buff(buffs.form_cat) then
            
        elseif player:Buff(buffs.form_bear) then
            -- Defensive
            if not needRebirth then
                Ironfur("pve-def")
            end
            Renewal("pve")
            if not needRebirth then
                Barkskin("pve")
            end
            SurvivalInstincts("pve")
            IncarnationGuardianofUrsoc("pve")
            RageoftheSleeper("pve")
            FrenziedRegeneration("pve")

            -- DPS
            Thrash("pvenew")
            Mangle("pve-highprio")
            Maul("pve")
            HeartoftheWild("pve")
            Moonfire("pve")
            Thrash("pve")
            LunarBeam("pve")
            ConvoketheSpirits("pve")
            Maul("pve")
            Raze("pve")
            Thrash("pve2")
            Ironfur("pve")
            Ironfur("pve2")
            Ironfur("pve3")
            FerociousBite("pve")
            Rip("pve")
            Raze("pve2")
            Mangle("pve")
            Raze("pve3")
            Shred("pve")
            Rake("pve")
            Mangle("pve2")
            Maul("pve2")
            Maul("pve3")
            Maul("pve4")
            Thrash("pve3")
            Mangle("pve3")
            Thrash("pve4")
            Pulverize("pve")
            Thrash("pve5")
            Moonfire("pve2")
            Rake("pve2")
            Shred("pve2")
            Rip("pve2")
            FerociousBite("pve2")
            Starsurge("pve")
            Moonfire("pve3")
            Moonfire("pve4")
            Swipe("pve")
        end

    end

	return FrameworkEnd()
end

local enemyRotation = function(enemy)
	if not enemy.exists then return end
end

RemoveCorruption:Callback("pve", function(spell, friendly)
    if not RemoveCorruption:InRange(friendly) then return end
    
    if friendly.cursed or friendly.poisoned then
        return Debounce("nc", 1000, 2500, spell, friendly)
    end
end)

local partyRotation = function(friendly)
    if not friendly.exists then return end

    RemoveCorruption("pve", friendly)
end

A[6] = function(icon)
	FrameworkStart(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end

	enemyRotation(arena1)
	partyRotation(party1)

	return FrameworkEnd()
end

A[7] = function(icon)
	FrameworkStart(icon)
	enemyRotation(arena2)
	partyRotation(party2)

	return FrameworkEnd()
end

A[8] = function(icon)
	FrameworkStart(icon)
	enemyRotation(arena3)
	partyRotation(party3)

	return FrameworkEnd()
end

A[9] = function(icon)
	FrameworkStart(icon)

	partyRotation(party4)

	return FrameworkEnd()
end

A[10] = function(icon)
	FrameworkStart(icon)

	partyRotation(player)

	return FrameworkEnd()
end
