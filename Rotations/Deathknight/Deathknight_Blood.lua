if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 250 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local TableToLocal     = MakuluFramework.tableToLocal
local ConstSpells      = MakuluFramework.constantSpells
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local ConstCell        = cacheContext:getConstCacheCell()
local TrinketOverride  = MakuluFramework.TrinketOverride
local ConstUnit        = MakuluFramework.ConstUnits
local MakLists         = MakuluFramework.lists
local Aware            = MakuluFramework.Aware
local CommandRegister  = MakuluFramework.Commands.register

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

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

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    ArenaPreparation = { ID = 32727, Hidden = true },

    AbominationLimb = { ID = 383269  },
    AntiMagicShell = { ID = 48707 },
    AntiMagicZone = { ID = 51052 },
    Asphyxiate = { ID = 221562 },
    BlindingSleet = { ID = 207167 },
    ChainsofIce = { ID = 45524 },
    DarkCommand = { ID = 56222 },
    DeathandDecay = { ID = 43265, Macro = "/cast [@player]spell:thisID" },
    DeathCoil = { ID = 47541 },
    DeathGrip = { ID = 49576 },
    DeathStrike = { ID = 49998 },
    DeathsAdvance = { ID = 48265 },
    IceboundFortitude = { ID = 48792 },
    Lichborne = { ID = 49039 },
    MindFreeze = { ID = 47528 },
    PathofFrost = { ID = 3714 },
    RaiseAlly = { ID = 61999 },
    RaiseDead = { ID = 46585 },


    BloodBoil = { ID = 50842 },
    DancingRuneWeapon = { ID = 49028 },
    DeathsCaress = { ID = 195292 },
    DeathPact = { ID = 48743 },
    HeartStrike = { ID = 206930 },
    Marrowrend = { ID = 195182 },
    Tombstone = { ID = 219809 },
    VampiricBlood = { ID = 55233 },

    Consumption = { ID = 274156 },
    Blooddrinker = { ID = 206931 },
    ReapersMark = { ID = 439843 },
    UnholyGround = { ID = 374265 },
    SanguineGround = { ID = 391458 },
    SacrificialPact = { ID = 327574 },
    BloodTap = { ID = 221699 },
    TighteningGrasp = { ID = 206970 },
    ShatteringBone = { ID = 377640 },
    InsatiableBlade = { ID = 377637 },
    GorefiendsGrasp = { ID = 108199 },
    EmpowerRuneWeapon = { ID = 47568 },
    SoulReaper = { ID = 343294 },
    Bonestorm = { ID = 194844 },
    MarkofBlood = { ID = 206940 },
    VampiricStrike = { ID = 433895 },
    RuneTap = { ID = 194679 },

    Carnage = { ID = 458752, Hidden = true },
    Coagulopathy = { ID = 391477, Hidden = true },
    VampiricStrikeTalent = { ID = 433901, Hidden = true },
    RelishInBlood = { ID = 317610, Hidden = true },
    RunicAttenuation = { ID = 207104, Hidden = true },
    Heartbreaker = { ID = 221536, Hidden = true },
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DEATHKNIGHT_BLOOD] = A

TableToLocal(M, getfenv(1))
Aware:enable()

local player = ConstUnit.player
local target = ConstUnit.target
local mouseover = ConstUnit.mouseover

local gs = {}

local buffs = {
    bone_shield = 195181,
    blood_shield = 77535,
    bonestorm = 194844,
    crimson_scourge = 81141,
    dancing_rune_weapon = 81256,
    ossuary = 219788,
    unholy_strength = 53365,
    front_shield = 207203,
    vampiric_embrace = 55233,
    Lichborne = 49039,
    icebound_fortitude = 48792,
    deaths_advance = 48265,
    anti_magic_shell = 48707,
    anti_magic_zone = 145629,
    tombstone = 219809,
    icy_talons = 194879,
    path_of_frost = 3714,
    death_and_decay = 188290,
    exterminate = 441416,
    abomination_limb = 383269,
    lichborne = 49039,
    coagulating_blood = 463730,
    vampiric_aura = 434105,
    vampiric_blood = 55233,
    sign_of_the_destroyer = 335150,
    coagulopathy = 391481,
    infliction_of_sorrow = 460049,
    essence_of_the_blood_queen = 433925,
    consumption = 274156,
    luck_of_the_draw = 1215993, -- needs checking
}

local debuffs = {
    blood_plague = 55078,
    death_grip = 51399,
    chains_of_ice = 45524,
    ashen_decay = 425719,
    mark_of_blood = 206940,
    soul_reaper = 353294,
    incite_terror = 458478,
}

local phys_def_buffs = {
    lichborne = 49039,
    icebound_fortitude = 48792,
    vampiric_blood = 55233,
}

local magic_def_buffs = {
    anti_magic_shell = 48707,
    anti_magic_zone = 145629,
    lichborne = 49039,
    icebound_fortitude = 48792,
}

local function hasPhysDefBuff()
    return ConstCell:GetOrSet("hasPhysDefBuff", function()
        for _, buff in pairs(phys_def_buffs) do
            if player:Buff(buff) then
                return true
            end
        end
        return false
    end)
end

local function hasMagicDefBuff()
    return ConstCell:GetOrSet("hasMagicDefBuff", function()
        for _, buff in pairs(magic_def_buffs) do
            if player:Buff(buff) then
                return true
            end
        end
        return false
    end)
end

local function hasDefBuff()
    return hasPhysDefBuff() or hasMagicDefBuff()
end

local function num(val)
    if val then return 1 else return 0 end
end

-- Helper function to ensure we only check player's own Dancing Rune Weapon buff
local function playerHasDancingRuneWeapon()
    return ConstCell:GetOrSet("playerDRW", function()
        -- Force check only player's own buffs by using onlyOurs = true
        return player:Buff(buffs.dancing_rune_weapon, true) ~= nil
    end)
end

local interrupts = {
    {spell = MindFreeze},
    {spell = Asphyxiate, isCC = true},
    {spell = BlindingSleet, isCC = true, aoe = true, distance = 3},
}

local function shouldBurst()
    return makBurst()
end

local constCell = cacheContext:getConstCacheCell()

local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if HeartStrike:InRange(enemy) and not enemy.isPet then
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
            if HeartStrike:InRange(enemy) and enemy:IsTotem() then
                return true
            end
        end

        return false
    end)
end

local function TauntCountSpell(makulu_spell)
    return ConstCell:GetOrSet("tauntCount" .. makulu_spell.id, function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local needTaunt = 0
        for unitToCheck in pairs(activeEnemies) do
            local munit = MakUnit:new(unitToCheck)
            if munit and munit.exists and munit.inCombat and makulu_spell:InRange(munit) and not A.IsInPvP and not munit:IsTotem() and not munit.isDummy then
                local threatStatusE = UnitThreatSituation("player", unitToCheck)
                if threatStatusE == 0 or threatStatusE == 2 then
                    needTaunt = needTaunt + 1
                end
            end
        end
        return needTaunt
    end)
end

local function enemiesInRange(dur)
    local cacheKey = dur and "enemiesInRange_" .. tostring(dur) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        
            if MindFreeze:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if dur > 0 and enemy.ttd > dur then
                        count = count + 1
                    elseif dur <= 0 then
                        count = count + 1
                    end
                end
            end
        end
        
        return count
    end)
end

local function abomLimbInRange()
    local cacheKey = "abomLimbInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        
            if player.inCombat and enemy.inCombat and enemy.distance <= 20 and enemy.distance >= 8 and not enemy:IsTotem() and not enemy.isPet and enemy.ttd > 10000 then
                if (GetUnitSpeed(enemy:CallerId()) == 0 or enemy.casting) then
                    count = count + 1
                end
            end
        end
        
        return count
    end)
end

local function dontAbom()
    local npcs = {
        226398, -- Big Momma
        

    }

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

    if UnitThreatSituation("player", "target") == 0 or UnitThreatSituation("player", "target") == 2 then
        return false
    end

    if A.GetToggle(2, "autotaunt") and gs.nearbyWithoutAggro > 1 then
        return true
    end

    if nearbyTotem() and not target:IsTotem() then
        return true
    end

    if HeartStrike:InRange(target) and target.exists then return false end

    if A.GetToggle(2, "targetmelee") and gs.rangeMelee > 0 then
        return true
    end
end

local function updateGameState()
    local inInstance, instanceType = IsInInstance()

    gs = {
        isMoving = player.moving,
        inCombat = player.inCombat,
        stayTime = player.stayTime,
        inInstance = inInstance,
        inDungeon = inInstance and instanceType == "party",
        inRaid = inInstance and instanceType == "raid",
        wantedTarget = nil,
        wantedSlot = nil,
        range30 = EnemiesInSpellRange(A.DeathGrip),
        rangeMelee = enemiesInMelee(),
        activeCount = enemiesInRange(),
        aoeAbomCount = enemiesInRange(10000),
        active8ttd = enemiesInRange(8000),
        abomLimbInRange = abomLimbInRange(),
        sanlayn = player:TalentKnown(VampiricStrikeTalent.id),

        tankBusterIn = MakuluFramework.DBM_TankBusterIn() or 1000000,
        burst = shouldBurst(),
        ShouldTaunt = MakuluFramework.TauntStatus(DarkCommand),
        
    }

    gs.nearbyWithoutAggro = TauntCountSpell(DarkCommand)

    if gs.ShouldTaunt == "None" then
        gs.ShouldTaunt = MakuluFramework.TauntStatus(DeathGrip)
    end

    -- actions.sanlayn=variable,name=death_strike_dump_drw_amount,value=80
    gs.death_strike_dump_drw_amount = 80
    -- actions.sanlayn+=/variable,name=death_strike_dump_amount,value=35
    gs.death_strike_dump_amount = 35
    -- actions.sanlayn+=/variable,name=death_strike_pre_essence_dump_amount,value=20
    gs.death_strike_pre_essence_dump_amount = 20
    -- actions.sanlayn+=/variable,name=death_strike_sang_low_hp,value=40
    gs.death_strike_sang_low_hp = 40
    -- actions.sanlayn+=/variable,name=death_strike_pre_essence_dump_amount_low_hp,value=70
    gs.death_strike_pre_essence_dump_amount_low_hp = 70
    -- actions.sanlayn+=/variable,name=bone_shield_refresh_value,value=7
    gs.bone_shield_refresh_value = 7
    -- actions.sanlayn+=/variable,name=heart_strike_rp_drw,value=(21+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
    gs.heart_strike_rp_drw = 21 + (gs.activeCount * player:TalentKnownInt(Heartbreaker.id) * 2)

    local numReady = 0
    for runeSlot=1,6 do
        local start, duration, runeReady = GetRuneCooldown(runeSlot)
        if runeReady then
            numReady = numReady + 1
        end
    end
    gs.runes = numReady

end

---------- MACRO STUFF -----------

MakuluFramework.pauseMode = false
local function PauseModeHandler()
	if MakuluFramework.pauseMode then
		MakuluFramework.pauseMode = false
    else
    	MakuluFramework.pauseMode = true
    end
end
CommandRegister("pause", PauseModeHandler, "Pause Makulu Rotation", {})

---------- END MACRO STUFF -----------

local function tankDefensive()
    if not player.combat then return false end

    if player:BuffFrom(MakLists.Defensive) then return false end
    if player:Buff(buffs.anti_magic_shell) then return false end
    if player:Buff(buffs.anti_magic_zone) then return false end

    if gs.active8ttd >= 5 and player.combatTime < 5 then
        return true
    end

    if makIncBuster() < 1500 then
        return true
    end
    
    return false
end

BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end
    if not playerHasDancingRuneWeapon() then return end

    return spell:Cast()
end)

Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end
    if not playerHasDancingRuneWeapon() then return end

    return spell:Cast()
end)

AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end
    if not playerHasDancingRuneWeapon() then return end

    return spell:Cast()
end)

Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end
    if not playerHasDancingRuneWeapon() then return end

    return spell:Cast()
end)

local function racials()
    BloodFury()
    Berserking()
    AncestralCall()
    Fireblood()
end

AbominationLimb:Callback("aoe-ranged", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    local abomMode = A.GetToggle(2, "abomMode")
    local abomCount = A.GetToggle(2, "abomCount")
    if abomMode == "Ranged" then
        if gs.abomLimbInRange >= 3 and gs.aoeAbomCount >= abomCount then
            return spell:Cast()
        end
    end

    if abomMode == "AoERanged" then
        if gs.abomLimbInRange >= 3 or gs.aoeAbomCount >= abomCount then
            return spell:Cast()
        end
    end
end)

--actions+=/blood_tap,if=(rune<=2&rune.time_to_3>gcd&charges_fractional>=1.8)
--actions+=/blood_tap,if=(rune<=1&rune.time_to_3>gcd)
BloodTap:Callback("prio", function(spell)
    if gs.runes <= (1 + num(spell.frac >= 1.8)) and Player:RuneTimeToX(3) > A.GetGCD() * 1000 then
        return spell:Cast()
    end
end)

-- actions.high_prio_actions+=/raise_dead,use_off_gcd=1
RaiseDead:Callback("prio", function(spell)
  
    return spell:Cast()
end)

-- actions.high_prio_actions+=/deaths_caress,if=buff.bone_shield.remains<gcd.max*2
DeathsCaress:Callback("prio", function(spell)
    if player:BuffRemains(buffs.bone_shield) >= A.GetGCD() * 2000 then return end

    return spell:Cast(target)
end)

-- actions.high_prio_actions+=/death_strike,if=buff.coagulopathy.up&buff.coagulopathy.remains<=gcd.max*2
DeathStrike:Callback("prio", function(spell)
    if player:Buff(buffs.coagulopathy) and player:BuffRemains(buffs.coagulopathy) <= A.GetGCD() * 2000 then
        return spell:Cast(target)
    end
end)

-- actions.high_prio_actions+=/death_and_decay,if=!buff.death_and_decay.up
DeathandDecay:Callback("prio", function(spell)
    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end
    if player:Buff(buffs.death_and_decay) then return end
        
    return spell:Cast()
end)

-- actions.high_prio_actions+=/blood_boil,if=dot.blood_plague.remains<gcd.max*2
BloodBoil:Callback("prio", function(spell)
    if not DeathStrike:InRange(target) then return end
    if target:DebuffRemains(debuffs.blood_plague, true) >= A.GetGCD() * 2000 then return end
        
    return spell:Cast()
end)

-- actions.high_prio_actions+=/soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)&(!hero_tree.sanlayn|pet.dancing_rune_weapon.remains<5)
SoulReaper:Callback("prio", function(spell)
    if gs.activeCount > 1 then return end
    if ActionUnit("target"):TimeToDieX(35) < 5 then return end
    if target.ttd < (player:BuffRemains(debuffs.soul_reaper) + 5000) then return end
    
    if not gs.sanlayn or player:BuffRemains(buffs.dancing_rune_weapon, true) < 5000 then
        return spell:Cast(target)
    end
end)

local function highPrio()
    AbominationLimb("aoe-ranged")
    BloodTap("prio")
    RaiseDead("prio")
    DeathsCaress("prio")
    DeathStrike("prio")
    DeathandDecay("prio")
    BloodBoil("prio")
    SoulReaper("prio")
end

-- actions.deathbringer=rune_tap,if=rune>2
RuneTap:Callback("deathbringer", function(spell)
    if gs.runes > 2 then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/dancing_rune_weapon
DancingRuneWeapon:Callback("deathbringer", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.deathbringer+=/death_strike,if=buff.coagulopathy.remains<=gcd
DeathStrike:Callback("deathbringer", function(spell)
    if not player:TalentKnown(Coagulopathy.id) then return end

    if player:BuffRemains(buffs.coagulopathy) <= A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/marrowrend,if=!buff.bone_shield.up|buff.bone_shield.remains<1.5|buff.bone_shield.stack<=1
-- actions.deathbringer+=/marrowrend,if=(buff.exterminate.up)&(cooldown.reapers_mark.up|cooldown.reapers_mark.remains<3)
Marrowrend:Callback("deathbringer", function(spell)
    if not player:Buff(buffs.bone_shield) or player:BuffRemains(buffs.bone_shield) < 1500 or player:HasBuffCount(buffs.bone_shield) <= 1 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.exterminate) and ReapersMark.cd < 3000 then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/deaths_caress,if=!buff.bone_shield.up|buff.bone_shield.remains<1.5|buff.bone_shield.stack<=1
DeathsCaress:Callback("deathbringer", function(spell)
    if not player:Buff(buffs.bone_shield) or player:BuffRemains(buffs.bone_shield) < 1500 or player:HasBuffCount(buffs.bone_shield) <= 1 then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/blood_boil,if=dot.blood_plague.remains<3
BloodBoil:Callback("deathbringer", function(spell)
    if not DeathStrike:InRange(target) then return end

    if target:DebuffRemains(debuffs.blood_plague, true) < 3000 then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/bonestorm,if=buff.bone_shield.stack>=5&(!talent.shattering_bone.enabled|death_and_decay.ticking)&!buff.dancing_rune_weapon.remains
Bonestorm:Callback("deathbringer", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not DeathStrike:InRange(target) then return end
    
    if player:HasBuffCount(buffs.bone_shield) >= 5 and (not player:TalentKnown(ShatteringBone.id) or not player:Buff(buffs.death_and_decay)) and not playerHasDancingRuneWeapon() then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/soul_reaper,if=active_enemies<=2&buff.reaper_of_souls.up&target.time_to_die>(dot.soul_reaper.remains+5)
-- actions.deathbringer+=/soul_reaper,if=active_enemies<=2&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
SoulReaper:Callback("deathbringer", function(spell)
    if gs.activeCount > 2 then return end
    if target.ttd > target:DebuffRemains(debuffs.soul_reaper, true) + 5000 then return end

    if player:Buff(buffs.reaper_of_souls) then
        return spell:Cast(target)
    end

    if ActionUnit:TimeToDieX(35) < 5 then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/death_and_decay,if=((dot.reapers_mark.ticking)&!death_and_decay.ticking)|!buff.death_and_decay.up
DeathandDecay:Callback("deathbringer", function(spell)
    if not DeathStrike:InRange(target) then return end
    if player.stayTime < A.GetToggle(2, "DNDTimer") then return end
    if player:Buff(buffs.death_and_decay) then return end
        
    return spell:Cast()
end)

-- actions.deathbringer+=/marrowrend,if=buff.exterminate.up
Marrowrend:Callback("deathbringer2", function(spell)
    if not player:Buff(buffs.exterminate) then return end
        
    return spell:Cast(target)
end)

-- actions.deathbringer+=/bonestorm,if=buff.bone_shield.stack>=5&(!talent.shattering_bone.enabled|death_and_decay.ticking)&buff.dancing_rune_weapon.remains
Bonestorm:Callback("deathbringer2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not DeathStrike:InRange(target) then return end
    if player:HasBuffCount(buffs.bone_shield) < 5 then return end
    if not playerHasDancingRuneWeapon() then return end

    if not player:TalentKnown(ShatteringBone.id) or player:Buff(buffs.death_and_decay) then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/death_strike,if=(runic_power.deficit<35|(runic_power.deficit<41&buff.dancing_rune_weapon.up))
DeathStrike:Callback("deathbringer2", function(spell)
    if player.runicPowerDeficit < 35 + (num(playerHasDancingRuneWeapon()) * 6) then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/reapers_mark
ReapersMark:Callback("deathbringer", function(spell)
    return spell:Cast(target)
end)

-- actions.deathbringer+=/marrowrend,if=buff.bone_shield.stack<6&!dot.bonestorm.ticking
Marrowrend:Callback("deathbringer3", function(spell)
    if player:HasBuffCount(buffs.bone_shield) >= 6 then return end
    if player:Buff(buffs.bonestorm) then return end

    return spell:Cast(target)
end)

-- actions.deathbringer+=/tombstone,if=buff.bone_shield.stack>=8&(!talent.shattering_bone.enabled|death_and_decay.ticking)&cooldown.dancing_rune_weapon.remains>=25
Tombstone:Callback("deathbringer", function(spell)
    if player:HasBuffCount(buffs.bone_shield) < 8 then return end
    if DancingRuneWeapon.cd < 25000 then return end

    if not player:TalentKnown(ShatteringBone.id) or player:Buff(buffs.death_and_decay) then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/abomination_limb,if=!buff.dancing_rune_weapon.up
AbominationLimb:Callback("deathbringer", function(spell)
    if not DeathStrike:InRange(target) then return end
    
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if playerHasDancingRuneWeapon() then return end

    local abomMode = A.GetToggle(2, "abomMode")
    local abomCount = A.GetToggle(2, "abomCount")
    if abomMode == "APL" or abomMode == "AoE" and gs.aoeAbomCount >= abomCount then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/blood_boil,if=pet.dancing_rune_weapon.active&!drw.bp_ticking
BloodBoil:Callback("deathbringer2", function(spell)
    if not playerHasDancingRuneWeapon() then return end

    if target:DebuffRemains(debuffs.blood_plague, true) < player:BuffRemains(buffs.dancing_rune_weapon, true) and spell.used > 2000 then
        return spell:Cast()
    end
end)

-- actions.deathbringer+=/any_dnd,if=!buff.death_and_decay.remains -- this is already covered above.

-- actions.deathbringer+=/blooddrinker,if=!buff.dancing_rune_weapon.up&active_enemies<=2&buff.coagulopathy.remains>3
Blooddrinker:Callback("deathbringer", function(spell)
    if target.ttd < 6000 then return end

    if playerHasDancingRuneWeapon() then return end
    if gs.activeCount > 2 then return end
    if player:BuffRemains(buffs.coagulopathy) < 3000 then return end

    return spell:Cast(target)
end)

-- actions.deathbringer+=/death_strike
DeathStrike:Callback("deathbringer3", function(spell)

    return spell:Cast(target)
end)

-- actions.deathbringer+=/consumption
Consumption:Callback("deathbringer", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.deathbringer+=/blood_boil,if=charges_fractional>=1.5
BloodBoil:Callback("deathbringer3", function(spell)
    if not DeathStrike:InRange(target) then return end

    if spell.frac < 1.5 then return end

    return spell:Cast()
end)

-- actions.deathbringer+=/heart_strike,if=rune>=1|rune.time_to_2<gcd
HeartStrike:Callback("deathbringer", function(spell)
    if gs.runes >= 1 then
        return spell:Cast(target)
    end

    if Player:RuneTimeToX(2) < A.GetGCD() * 1000 then
        return spell:Cast(target)
    end
end)

-- actions.deathbringer+=/blood_boil
BloodBoil:Callback("deathbringer4", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.deathbringer+=/heart_strike
HeartStrike:Callback("deathbringer2", function(spell)
    return spell:Cast(target)
end)

-- actions.deathbringer+=/soul_reaper,if=buff.reaper_of_souls.up
SoulReaper:Callback("deathbringer2", function(spell)
    if not player:Buff(buffs.reaper_of_souls) then return end

    return spell:Cast(target)
end)

-- actions.deathbringer+=/arcane_torrent,if=runic_power.deficit>20
ArcaneTorrent:Callback("deathbringer", function(spell)
    if not DeathStrike:InRange(target) then return end
    if player.runicPowerDeficit < 20 then return end

    return spell:Cast()
end)

-- actions.deathbringer+=/deaths_caress,if=buff.bone_shield.stack<11
DeathsCaress:Callback("deathbringer2", function(spell)
    if player:HasBuffCount(buffs.bone_shield) >= 11 then return end

    return spell:Cast(target)
end)

local function deathbringer()
    RuneTap("deathbringer")
    DancingRuneWeapon("deathbringer")
    DeathStrike("deathbringer")
    Marrowrend("deathbringer")
    DeathsCaress("deathbringer")
    BloodBoil("deathbringer")
    Bonestorm("deathbringer")
    SoulReaper("deathbringer")
    DeathandDecay("deathbringer")
    Marrowrend("deathbringer2")
    Bonestorm("deathbringer2")
    DeathStrike("deathbringer2")
    ReapersMark("deathbringer")
    Marrowrend("deathbringer3")
    Tombstone("deathbringer")
    AbominationLimb("deathbringer")
    BloodBoil("deathbringer2")
    Blooddrinker("deathbringer")
    DeathStrike("deathbringer3")
    Consumption("deathbringer")
    BloodBoil("deathbringer3")
    HeartStrike("deathbringer")
    BloodBoil("deathbringer4")
    HeartStrike("deathbringer2")
    SoulReaper("deathbringer2")
    ArcaneTorrent("deathbringer")
    DeathsCaress("deathbringer2")
end

-- actions.san_cds=abomination_limb,if=!buff.dancing_rune_weapon.up
AbominationLimb:Callback("sanlayn-cds", function(spell)
    if not DeathStrike:InRange(target) then return end
    
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    local abomMode = A.GetToggle(2, "abomMode")
    local abomCount = A.GetToggle(2, "abomCount")
    if abomMode == "APL" or abomMode == "AoE" and gs.aoeAbomCount >= abomCount then
        if not playerHasDancingRuneWeapon() then
            return spell:Cast()
        end
    end
end)

-- actions.san_cds+=/dancing_rune_weapon
DancingRuneWeapon:Callback("sanlayn-cds", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.san_cds+=/bonestorm,if=buff.death_and_decay.up&buff.bone_shield.stack>5&cooldown.dancing_rune_weapon.remains>15
Bonestorm:Callback("sanlayn-cds", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not DeathStrike:InRange(target) then return end
    if not player:Buff(buffs.death_and_decay) then return end
    if player:HasBuffCount(buffs.bone_shield) < 5 then return end
    if DancingRuneWeapon.cd < 15000 then return end

    return spell:Cast()
end)

-- actions.san_cds+=/tombstone,if=(!buff.dancing_rune_weapon.up&buff.death_and_decay.up)&buff.bone_shield.stack>5&runic_power.deficit>=30&cooldown.dancing_rune_weapon.remains>25
Tombstone:Callback("sanlayn-cds", function(spell)
    if playerHasDancingRuneWeapon() then return end
    if not player:Buff(buffs.death_and_decay) then return end
    if player:HasBuffCount(buffs.bone_shield) < 5 then return end
    if player.runicPowerDeficit < 30 then return end
    if DancingRuneWeapon.cd < 25000 then return end

    return spell:Cast()
end)

local function sanCds()
    AbominationLimb("sanlayn-cds")
    DancingRuneWeapon("sanlayn-cds")
    Bonestorm("sanlayn-cds")
    Tombstone("sanlayn-cds")
end

-- actions.san_drw=bonestorm,if=buff.death_and_decay.up&buff.bone_shield.stack>5
Bonestorm:Callback("san-drw", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if not DeathStrike:InRange(target) then return end
    if not player:Buff(buffs.death_and_decay) then return end
    if player:HasBuffCount(buffs.bone_shield) < 5 then return end

    return spell:Cast()
end)

-- actions.san_drw+=/death_strike,if=(active_enemies=1|buff.luck_of_the_draw.up)&runic_power.deficit<15+(10*talent.relish_in_blood.enabled)+(3*talent.runic_attenuation.enabled)+(spell_targets.heart_strike*talent.heartbreaker.enabled*2)
DeathStrike:Callback("san-drw", function(spell)
    if player.runicPowerDeficit < (15 + (10 * player:TalentKnownInt(RelishInBlood.id)) + (3 * player:TalentKnownInt(RunicAttenuation.id)) + (gs.activeCount * player:TalentKnownInt(Heartbreaker.id) * 2)) then
        if gs.activeCount <= 1 or player:Buff(buffs.luck_of_the_draw) then
            return spell:Cast(target)
        end
    end
end)

-- actions.san_drw+=/blood_boil,if=!drw.bp_ticking
BloodBoil:Callback("san-drw", function(spell)
    if not DeathStrike:InRange(target) then return end

    if spell.used < DancingRuneWeapon.used then return end

    return spell:Cast()
end)

-- actions.san_drw+=/heart_strike
HeartStrike:Callback("san-drw", function(spell)

    return spell:Cast(target)
end)

-- actions.san_drw+=/death_strike
DeathStrike:Callback("san-drw2", function(spell)

    return spell:Cast(target)
end)

-- actions.san_drw+=/consumption
Consumption:Callback("san-drw", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.san_drw+=/blood_boil
BloodBoil:Callback("san-drw2", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

local function sanDrw()
    Bonestorm("san-drw")
    DeathStrike("san-drw")
    BloodBoil("san-drw")
    HeartStrike("san-drw")
    DeathStrike("san-drw2")
    Consumption("san-drw")
    BloodBoil("san-drw2")
end

-- actions.sanlayn=heart_strike,if=buff.infliction_of_sorrow.up
-- actions.sanlayn+=/heart_strike,if=buff.vampiric_strike.up
HeartStrike:Callback("sanlayn", function(spell)
    if player:Buff(buffs.infliction_of_sorrow) or IsSpellOverlayed(VampiricStrike.id) then
        return spell:Cast(target)
    end
end)

-- actions.sanlayn+=/blooddrinker,if=!buff.dancing_rune_weapon.up&active_enemies<=2&buff.coagulopathy.remains>3
Blooddrinker:Callback("sanlayn", function(spell)
    if playerHasDancingRuneWeapon() then return end
    if gs.activeCount > 2 then return end
    if player:BuffRemains(buffs.coagulopathy) < 3000 then return end

    return spell:Cast(target)
end)

-- actions.sanlayn+=/death_strike,if=runic_power.deficit<15+(10*talent.relish_in_blood.enabled)+(3*talent.runic_attenuation.enabled)+(spell_targets.heart_strike*talent.heartbreaker.enabled*2)
DeathStrike:Callback("sanlayn", function(spell)
    if player.runicPowerDeficit < (15 + (10 * player:TalentKnownInt(RelishInBlood.id)) + (3 * player:TalentKnownInt(RunicAttenuation.id)) + (gs.activeCount * player:TalentKnownInt(Heartbreaker.id) * 2)) then
        return spell:Cast(target)
    end
end)

-- actions.sanlayn+=/marrowrend,if=!dot.bonestorm.ticking&buff.bone_shield.stack<variable.bone_shield_refresh_value&runic_power.deficit>20
Marrowrend:Callback("sanlayn", function(spell)
    if player:Buff(buffs.bonestorm) then return end
    if player:HasBuffCount(buffs.bone_shield) >= gs.bone_shield_refresh_value then return end
    if player.runicPowerDeficit < 20 then return end

    return spell:Cast(target)
end)

-- actions.sanlayn+=/death_strike
DeathStrike:Callback("sanlayn2", function(spell)

    return spell:Cast(target)
end)

-- actions.sanlayn+=/heart_strike,if=rune>1
HeartStrike:Callback("sanlayn2", function(spell)
    if gs.runes <= 1 then return end

    return spell:Cast(target)
end)

-- actions.sanlayn+=/consumption
Consumption:Callback("sanlayn2", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.sanlayn+=/blood_boil
BloodBoil:Callback("sanlayn2", function(spell)
    if not DeathStrike:InRange(target) then return end

    return spell:Cast()
end)

-- actions.sanlayn+=/heart_strike
HeartStrike:Callback("sanlayn3", function(spell)

    return spell:Cast(target)
end)

local function sanlayn()
    HeartStrike("sanlayn")
    Blooddrinker("sanlayn")
    DeathStrike("sanlayn")
    Marrowrend("sanlayn")
    DeathStrike("sanlayn2")
    HeartStrike("sanlayn2")
    Consumption("sanlayn2")
    BloodBoil("sanlayn2")
    HeartStrike("sanlayn3")
end

local function defLastTB()

end

VampiricBlood:Callback("defensive", function(spell)
    if not player.combat then return end
    if player.ehp > 95 then return end
    if player:BuffFrom(MakLists.Defensive) then return end

    return spell:Cast()
end)

local function shouldAMS()
    local amsList = {
        439365, -- Spouting Stout
        440134, -- Honey Marinade
        435789, -- Cindering Wounds
        435622, -- Let it Hail
        463218, -- Volatile Keg
        443487, -- Final Sting
        441397, -- Bee Venom
        448515, -- Divine Judgment
        424420, -- Cinderblast
        427469, -- Fireball
        424421, -- Fireball
        444743, -- Fireball Volley
        446368, -- Sacrificial Pyre
        428169, -- Blinding Light
        448791, -- Sacred Toll
        427897, -- Heat Wave
        448492, -- Thunderclap
        435148, -- Blazing Strike
        444123, -- Lightning Torrent
        1214324, -- Crashing Thunder
        445457, -- Oblivion Wave
        427404, -- Localized Storm
        430805, -- Arcing Void
        430812, -- Attracting Shadows
        1214523, -- Feasting Void
        472549, -- Volatile Void
        1214628, -- Unleash Darkness
        425394, -- Dousing Breath
        428266, -- Eternal Darkness
        430171, -- Quenching Blast
        426677, -- Candleflame Bolt
        1218117, -- Massive Stomp
        469620, -- Creeping Shadow
        262347, -- Static Pulse
        258622, -- Resonant Quake
        259474, -- Searing Reagent
        260318, -- Alpha Cannon
        263628, -- Charged Shield
        262794, -- Mind Lash
        1215916, -- Mind Lash
        268846, -- Echo Blade
        262270,  -- Caustic Compound
        269099, -- Charged Shot
        269100, -- Charged Shot
        269429, -- Charged Shot
        473351, -- Electrocrush
        469478, -- Sludge Claws
        466188, -- Thunder Punch
        466189, -- Thunder Punch
        466190, -- Thunder Punch
        466197, -- Thunder Punch
        462737, -- Black Blood Wound
        465827,  -- Warp Blood
        465666, -- Sparkslam
        1216443, -- Electrical Storm
        294929,  -- Blazing Chomp
        291878, -- Pulse Blast
        1215412, -- Corrosive Gunk
        473436,  -- High Explosive Rockets
        1215741, -- Mighty Smash
        333292,  -- Searing Death
        474087, -- Necrotic Eruption
        324079, -- Reaping Scythe
        324449,  -- Manifest Death  
        330716,  -- Soulstorm
        330875, -- Spirit Frost
        330700, -- Decaying Blight
        345245,  -- Disease Cloud
    }

    local amsDebuff = {
        291928, -- Mega-Zap
    }

    
end

AntiMagicShell:Callback("defensive", function(spell)
    if not tankDefensive() then return end

    return spell:Cast()
end)

IceboundFortitude:Callback("defensive", function(spell)
    if not tankDefensive() then return end

    return spell:Cast()
end)

Lichborne:Callback("defensive", function(spell)
    if not tankDefensive() then return end

    return spell:Cast()
end)

DeathStrike:Callback("defensive", function(spell)
    if player.ehp > 70 then return end

    return spell:Cast(target)
end)

local function defensives()
    VampiricBlood("defensive")
    AntiMagicShell("defensive")
    IceboundFortitude("defensive")
    Lichborne("defensive")
    DeathStrike("defensive")
end

--[[DeathandDecay:Callback("agro", function(spell)
    if player.stayTime > 0 and not player:Buff(buffs.death_and_decay) and gs.rangeMelee > 0 and TauntCountSpell(MindFreeze) > 1 then
        spell:Cast()
    end
end)]]

local usedDC = false
DarkCommand:Callback("agro", function(spell)
    if player:Buff(buffs.abomination_limb) then return end

    usedDC = false
    if gs.ShouldTaunt == "Taunt" then
        usedDC = true
        spell:Cast(target)
    end
end)

DeathGrip:Callback("agro", function(spell)
    if player:Buff(buffs.abomination_limb) then return end

    if DarkCommand.cd < 8000 then
        usedDC = false
    end
    if gs.ShouldTaunt == "Taunt" and not usedDC then
        spell:Cast(target)
    end
end)

MarkofBlood:Callback("dr", function(spell)
    if player.inCombat and (target:DebuffRemains(debuffs.mark_of_blood, true) < 1500 or not target:Debuff(debuffs.mark_of_blood, true)) then
        spell:Cast(target)
    end
end)

GorefiendsGrasp:Callback("agro", function(spell)
    if player:Buff(buffs.abomination_limb) then return end

    if TauntCountSpell(DarkCommand) > 3 and DarkCommand.cd > 1000 and DeathGrip.cd > 1000 and not usedDC then
        spell:Cast()
    end

    if player:TalentKnown(206970) and TauntCountSpell(DarkCommand) > 2 and DarkCommand.cd > 1000 and DeathGrip.cd > 1000 and not usedDC then
        spell:Cast()
    end

    if TauntCountSpell(DarkCommand) > 4 and not usedDC then
        spell:Cast()
    end
end)

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    
    if MakuluFramework.pauseMode then return end

	FrameworkStart(icon)
    updateGameState()

    makInterrupt(interrupts)

    if player.inCombat and tankDefensive() then
        if Trinket(13, "Defensive") then
            Trinket1()
        end
        if Trinket(14, "Defensive") then
            Trinket2()
        end
    end

    if target.exists and target.canAttack then
        defensives()

        DarkCommand("agro")
        DeathGrip("agro")
        --DeathandDecay("agro")
        GorefiendsGrasp("agro")

        racials()
        highPrio()

        if gs.sanlayn then
            if playerHasDancingRuneWeapon() then
                sanDrw()
            end
            sanCds()
            sanlayn()
        else
            deathbringer()
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
    if MakuluFramework.pauseMode then return end
	FrameworkStart(icon)
    if A.GetToggle(2, "autotarget") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end

	enemyRotation(MakUnit:new("arena1"))
	partyRotation(MakUnit:new("party1"))

	return FrameworkEnd()
end

A[7] = function(icon)
    if MakuluFramework.pauseMode then return end
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena2"))
	partyRotation(MakUnit:new("party2"))

	return FrameworkEnd()
end

A[8] = function(icon)
    if MakuluFramework.pauseMode then return end
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena3"))
	partyRotation(MakUnit:new("party3"))

	return FrameworkEnd()
end

A[9] = function(icon)
    if MakuluFramework.pauseMode then return end
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena4"))
	partyRotation(MakUnit:new("party4"))

	return FrameworkEnd()
end

A[10] = function(icon)
    if MakuluFramework.pauseMode then return end
	FrameworkStart(icon)
	enemyRotation(MakUnit:new("arena5"))
	partyRotation(MakUnit:new("player"))

	return FrameworkEnd()
end
