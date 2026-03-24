-- added Healing Engine funtion  
if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 70 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakEnemies       = MakuluFramework.Enemies
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local MakParty         = MakuluFramework.Party
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Debounce         = MakuluFramework.debounceSpell
local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit             = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle        = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local LoC              = Action.LossOfControl
local UnitIsUnit       = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable
local GetSpellTexture  = _G.TMW.GetSpellTexture

local Trinket          = MakuluFramework.Trinket
local FakeCasting      = MakuluFramework.FakeCasting

local ActionID       = {
	-- Racials
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

	-- Baseline
    Consecration         = { ID = 26573, MAKULU_INFO = { damageType = "magic" } },
    CrusaderStrike       = { ID = 35395, FixedTexture = 135891, MAKULU_INFO = { damageType = "physical" } },
    DevotionAura         = { ID = 465},
    DivineProtection     = { ID = 403876, MAKULU_INFO = { offGcd = true } },
    DivineShield         = { ID = 642 },
    DivineSteed          = { ID = 190784, MAKULU_INFO = { offGcd = true } },
    FlashofLight         = { ID = 19750, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    FlashofLightParty    = { ID = 19750, Desc = "party", Texture = 10326, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    HammerofJustice      = { ID = 853, MAKULU_INFO = { damageType = "magic" } },
    HandofReckoning      = { ID = 62124, MAKULU_INFO = { offGcd = true } },
    Intercession         = { ID = 391054, Texture = 7328 },
    Judgement            = { ID = 20271,MAKULU_INFO = { damageType = "magic" } },
    Redemption           = { ID = 7328 },
    ShieldoftheRighteous = { ID = 53600, MAKULU_INFO = { offGcd = true } },
    TemplarsVerdict      = { ID = 85256, MAKULU_INFO = { damageType = "magic" } },
    WordofGlory          = { ID = 85673, Texture = 167136, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },

	--Paladin Tree
    AvengingWrath        = { ID = 31884, MAKULU_INFO = { offGcd = true } },
    BlessingofFreedom    = { ID = 1044 },
    BlessingofProtection = { ID = 1022, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    BlessingofSacrifice  = { ID = 6940, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    BlindingLight        = { ID = 115750, MAKULU_INFO = { damageType = "magic" } },
    CleanseToxins        = { ID = 213644, FixedTexture = 133667 },
    DivineToll           = { ID = 375576, FixedTexture = 3565448 },
    HammerofWrath        = { ID = 24275 },
    LayonHands           = { ID = 633, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    LayonHandsPassive    = { ID = 633, Desc = "passive", Texture = 139, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    LayonHandsPassiveToo = { ID = 471195, Desc = "passive", Texture = 139, MAKULU_INFO = { offGcd = true }, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    Rebuke               = { ID = 96231, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true } },
    Repentance           = { ID = 20066, MAKULU_INFO = { damageType = "magic" } },
    TurnEvil             = { ID = 10326 },

	--Retribution Tree
    BladeofJustice     = { ID = 184575, MAKULU_INFO = { damageType = "magic" } },
    BlessedChampion    = { ID = 403010, Hidden = true },
    BoundlessJudgment  = { ID = 405278, Hidden = true },
    ConsecratedBlade   = { ID = 404834, Hidden = true },
    Crusade            = { ID = 231895 },
    CrusadingStrikes   = { ID = 404542, Hidden = true },
    DivineArbiter      = { ID = 404306, Hidden = true },
    DivineHammer       = { ID = 198034, MAKULU_INFO = { damageType = "magic" } },
    DivineStorm        = { ID = 53385, MAKULU_INFO = { damageType = "magic" } },
    EmpyreanLegacy     = { ID = 387170, Hidden = true },
    ExecutionSentence  = { ID = 343527, MAKULU_INFO = { damageType = "magic" } },
    FinalReckoning     = { ID = 343721, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast Single-Button Assistant" },
    FinalVerdict       = { ID = 383328, MAKULU_INFO = { damageType = "magic" } },
    HolyBlade          = { ID = 383342, Hidden = true },
    JusticarsVengeance = { ID = 215661, MAKULU_INFO = { damageType = "magic" } },
    ShieldofVengeance  = { ID = 184662 },
    TemplarSlash       = { ID = 406647, FixedTexture = 135891, MAKULU_INFO = { damageType = "magic" } },
    TemplarStrike      = { ID = 407480, FixedTexture = 135891, MAKULU_INFO = { damageType = "magic" } },
    VanguardsMomentum  = { ID = 383314, Hidden = true },
    WakeofAshes        = { ID = 255937, Texture = 403695, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast Wake of Ashes\n/cast Hammer of Light" },

	--Buff Trackers
    
    DivineResonance   = { ID = 384027, Hidden = true },
    EmpyreanPowerBuff = { ID = 326733, Hidden = true },
    EmpyreanWardBuff  = { ID = 387792, Hidden = true },
    Expurgation       = { ID = 383344, Hidden = true },
    Forbearance       = { ID = 25771, Hidden = true },
    JudgmentDebuff    = { ID = 197277, Hidden = true },

    --Talents
    BladeofVengeance         = { ID = 403826, Hidden = true },
    DivineAuxiliary          = { ID = 406158, Hidden = true },
    EmpyrealWard             = { ID = 387791, Hidden = true },
    ExecutionersWill         = { ID = 406940, Hidden = true },
    HolyFlames               = { ID = 406545, Hidden = true },
    LightsCelerity           = { ID = 403698, Hidden = true },
    LightsRevocation         = { ID = 146956, Hidden = true },
    RadiantGlory             = { ID = 458359, Hidden = true },
    TempestoftheLightBringer = { ID = 383396, Hidden = true },
    TemplarStrikeStuff       = { ID = 406646, Hidden = true },
    UnboundFreedom           = { ID = 305394, Hidden = true },
    VengefulWrath            = { ID = 406835, Hidden = true },

    --Hero Stuff
    EternalFlame         = { ID = 156322, Texture = 167136, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
    HammerofLight        = {  ID = 427453, Texture = 403695, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast Wake of Ashes\n/cast Hammer of Light" },
    LightsGuidance       = { ID = 427445, Hidden = true },
    RiteofAdjuration     = { ID = 433583, Macro = "/cast spell:thisID\n/cast 16" },
    RiteofSanctification = { ID = 433568, Macro = "/cast spell:thisID\n/cast 16" },

    --PVP
	BlessingofSanctuary = { ID = 210256, Texture = 20066 },
    BlessingofSpellwarding = { ID = 204018, Texture = 62124 },
    SearingGlare = { ID = 410126, MAKULU_INFO = { damageType = "magic" } },

    --Other Pixels for Off Use
	SenseUndead = { ID = 5502 },
	FyralaththeDreamrender = { ID = 206448 },

    --Items
    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },


    ArenaPreparation = { ID = 32727, Hidden = true }, 
}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })
Action[ACTION_CONST_PALADIN_RETRIBUTION] = A
TableToLocal(M, getfenv(1))
Aware:enable()

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
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
local tank = ConstUnit.tank
local mouseover = ConstUnit.mouseover

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = 0,
    minTalentedCdRemains = nil,
    cursorCheck = false,
    shouldAoE = false,
    activeEnemies = 0,
    dsCastable = false,
}

local buffs = {
    avengingWrath = 31884,
    crusade = 231895,
    empyreanPower = 326733,
    empyreanLegacy = 387178,
    divineArbiter = 406975,
    divineHammer = 198034, --INFA - CHECK THIS
    divineResonance = 384029,
    blessingofAnshee = 445206,


}

local debuffs = {
    executionSentence = 343527,
}

local function num(val)
    if val then return 1 else return 0 end
end


local interrupts = {
    {spell = Rebuke },
    {spell = HammerofJustice, isCC = true, aoe = false},
    {spell = BlindingLight, isCC = true, aoe = true, distance = 2},
}

local function shouldBurst()
    --target = MakUnit:new("target")
	
    if not target.bigButtons then return false end
    if A.BurstIsON("target") then
        --if A.Zone ~= "arena" then
        --    local activeEnemies = MultiUnits:GetActiveUnitPlates()
        --    for enemy in pairs(activeEnemies) do
        --        if ActionUnit(enemy):Health() > (A.Judgement:GetSpellDescription()[1] * 10 ) or target.isDummy then
        --            return true
        --        end
        --    end
        --else
        return true
    end
end
    --return false
--end

local cacheContext     = MakuluFramework.Cache

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if enemy.distance <= 7 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function enemiesInRebuke()
    return constCell:GetOrSet("enemiesInRebuke", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID) 
            if Rebuke:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end 
        end  
        
        return total 
    end)
end

local function autoTarget()
    if A.Zone == "arena" then return false end
    if not player.inCombat then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if Rebuke:InRange(target) and target.exists then return false end

    if enemiesInRebuke() > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end

local function arenaHealthCheck(threshhold)
    --Return if any of the 3 arena units are below the threshhold
    if arena1.exists and party1.hp < threshhold then return true end
    if arena2.exists and party2.hp < threshhold then return true end
    if arena3.exists and party3.hp < threshhold then return true end
    return false
end

local function activeEnemies()
    return math.max(enemiesInMelee(), 1)
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    player = MakUnit:new("player")
    return player:BuffFrom(MakLists.Defensive) 
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive() 
end

local lastUpdateTime = 0
local updateDelay = 0.5
local combatTime = 0
local inMelee = false
local holyPower	= 0
local function updateGameState()


    local currentTime = GetTime()
    combatTime = player.combatTime
    inMelee = target:Distance() <= 3
    holyPower	= player.holyPower
    local enemies = activeEnemies()
    gameState.activeEnemies = enemies
    gameState.shouldAoE = (enemies >= 2) and A.GetToggle(2, "AoE") and A.Zone ~= "arena"

    --finishers->add_action( "variable,name=ds_castable,value=(spell_targets.divine_storm>=2|buff.empyrean_power.up|!talent.final_verdict&talent.tempest_of_the_lightbringer)&!buff.empyrean_legacy.up&!(buff.divine_arbiter.up&buff.divine_arbiter.stack>24)" );
    gameState.dsCastable = ((gameState.shouldAoE) or player:Buff(buffs.empyreanPower) or (not IsPlayerSpell(A.FinalVerdict.ID) and IsPlayerSpell(A.TempestoftheLightBringer.ID))) and not player:Buff(buffs.empyreanLegacy) and not (player:Buff(buffs.divineArbiter) and player:HasBuffCount(buffs.divineArbiter) > 24)

end


--############################################################################ GENERAL ###################################################################################--

Intercession:Callback("general", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if mouseover.isPet then return end
    if not mouseover.dead then return end
    if not spell:InRange(mouseover) then return end

    return spell:Cast()
end)

Redemption:Callback("general", function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if not spell:InRange(mouseover) then return end

    return spell:Cast()
end)

FlashofLight:Callback("general", function(spell)
    if player.hp > A.GetToggle(2, "FlashLightHP") then return end
    if player.inCombat and not IsPlayerSpell(A.LightsCelerity.ID) then return end
    if player.hp > 30 and target.hp < 20 then return end
    return spell:Cast(player)
end)

FlashofLight:Callback("generalOOC", function(spell)
    if player.hp >= 80 then return end
    if player.inCombat then return end
    return spell:Cast(player)
end)

DivineProtection:Callback("general", function(spell)
    if player.hp > 60 then return end
    if player.hp > 40 and target.hp < 20 then return end
    return spell:Cast(player)
end)

ShieldofVengeance:Callback("general", function(spell)
    if player.hp > 70 then return end
    if not player.inCombat then return end
    return spell:Cast(player)
end)

WordofGlory:Callback("general", function(spell)
    if player.hp > A.GetToggle(2, "WogHP") then return end
    if not player.inCombat then return end
    if player.hp > 40 and target.hp < 20 then return end
    return spell:Cast(player)
end)

EternalFlame:Callback("general", function(spell)
    if player.hp > A.GetToggle(2, "EFHP") then return end
    if not player.inCombat then return end
    if player.hp > 40 and target.hp < 20 then return end
    return spell:Cast(player)
end)

-- Lay on Hands - Self healing for player
-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
-- FIX: Check cooldown status of ALL Lay on Hands spell IDs before suggesting
LayonHands:Callback("general", function(spell)
    if not player.inCombat then return false end
    if player:HasDeBuff(A.Forbearance.ID) then return false end
    if player.totalImmune then return false end
    if player.hp > A.GetToggle(2, "LohHP") then return false end

    -- Check if ANY Lay on Hands spell ID is on cooldown
    -- Only suggest if NONE of the spell IDs are on cooldown
    if LayonHands:Cooldown() > 0 or LayonHandsPassiveToo:Cooldown() > 0 then return false end

    Aware:displayMessage("Lay on Hands - Self Heal", "Green", 1)
    local casted = spell:Cast(player)
    if casted then
        return true
    end
    return false
end)

-- Divine Shield - Emergency immunity for player
-- IMPROVED: Better priority logic and emergency override for critical situations
DivineShield:Callback("general", function(spell)
    -- EMERGENCY OVERRIDE: Cast immediately if HP is critically low (< 18%)
    -- This bypasses Lay on Hands priority to ensure survival
    if player.hp < 18 and not player:HasDeBuff(A.Forbearance.ID) and not player.totalImmune then
        if not (IsPlayerSpell(A.LightsRevocation.ID) == false and player:HasDeBuff(A.Forbearance.ID)) then
            Aware:displayMessage("Divine Shield - EMERGENCY!", "Red", 1)
            return spell:Cast(player)
        end
    end

    -- Don't cast immediately after Lay on Hands (wait 1 second to avoid waste)
    if LayonHands.used > 0 and LayonHands.used < 1000 then return end
    if LayonHandsPassiveToo.used > 0 and LayonHandsPassiveToo.used < 1000 then return end

    -- IMPROVED: Reduced LoH priority window from 2000ms to 1000ms
    -- This allows Divine Shield to be used more quickly when LoH is available
    if IsPlayerSpell(A.LightsRevocation.ID) and LayonHands:Cooldown() < 1000 and LayonHandsPassiveToo:Cooldown() < 1000 then return end

    -- Safety checks - don't waste Divine Shield
    if player:HasDeBuff(A.Forbearance.ID) and not IsPlayerSpell(A.LightsRevocation.ID) then return end
    if not player.inCombat then return end
    if player.totalImmune then return end

    -- Normal HP threshold check (default 40% from UI toggle)
    if player.hp > A.GetToggle(2, "DivineShieldHP") then return end

    Aware:displayMessage("Divine Shield - Defensive Is Up!", "Gold", 1)
    return spell:Cast(player)
end)

-- Blessing of Protection - General callback for player self-cast only
-- Only casts when both Lay on Hands and Divine Shield are on cooldown
BlessingofProtection:Callback("general", function(spell)
    if not player.inCombat then return end

    -- Only cast when Lay on Hands is on cooldown
    if LayonHands:Cooldown() < 1000 and LayonHandsPassiveToo:Cooldown() < 1000 then return end

    -- Only cast when Divine Shield is on cooldown
    if DivineShield:Cooldown() < 1000 then return end

    -- Don't cast if player has Forbearance
    if player:HasDeBuff(A.Forbearance.ID) then return end

    -- Check HP threshold
    if player.health > A.GetToggle(2, "BopHP") then return end

    return spell:Cast(player)
end)

DevotionAura:Callback("general", function(spell)
    if player:HasBuff(A.DevotionAura.ID) then return end
    return spell:Cast(player)
end)

local function general()
    DivineShield("general")
    BlessingofProtection("general")
    ShieldofVengeance("general")
    DivineProtection("general")
    FlashofLight("general")
    WordofGlory("general")
    Redemption("general")
    DevotionAura("general")
    FlashofLight("generalOOC")
end



--### APL: 3/1/25

--############################################################################ COOLDOWNS #############################################################################--
--cooldowns->add_action( "lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up" );
LightsJudgment:Callback("cooldowns", function(spell)
    if shouldBurst() and gameState.activeEnemies >= 2 then return spell:Cast(target) end
end)

--cooldowns->add_action( "fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10|debuff.execution_sentence.up" );
Fireblood:Callback("cooldowns", function(spell)
    if shouldBurst() and (player:Buff(buffs.avengingWrath) or (player:Buff(buffs.crusade) and player:HasBuffCount(buffs.crusade) == 10) or target:HasDeBuff(debuffs.executionSentence)) then return spell:Cast(player) end
end)

--  cooldowns->add_action( "shield_of_vengeance,if=fight_remains>15&(!talent.execution_sentence|!debuff.execution_sentence.up)&!buff.divine_hammer.up" );
--todo - question on this
ShieldofVengeance:Callback("cooldowns", function(spell)
    if combatTime < 1 then return end
    if player.hp > 70 then return end
    if shouldBurst() and (not A.ExecutionSentence:IsTalentLearned() or not target:HasDeBuff(debuffs.executionSentence)) and not player:HasBuff(buffs.divineHammer) then return spell:Cast(player) end
end)

--cooldowns->add_action( "execution_sentence,if=(!buff.crusade.up&cooldown.crusade.remains>15|buff.crusade.stack=10|cooldown.avenging_wrath.remains<0.75|cooldown.avenging_wrath.remains>15|talent.radiant_glory)
--&(holy_power>=4&time<5|holy_power>=3&time>5|holy_power>=2&(talent.divine_auxiliary|talent.radiant_glory))&(!talent.divine_hammer|cooldown.divine_hammer.remains)&(target.time_to_die>8&!talent.executioners_will|target.time_to_die>12)
--&cooldown.wake_of_ashes.remains<gcd" );
ExecutionSentence:Callback("cooldowns", function(spell)
    if shouldBurst() and 
    (not player:Buff(buffs.crusade) and (Crusade:Cooldown() > 15000 or player:HasBuffCount(buffs.crusade) == 10) or AvengingWrath:Cooldown() < 750 or AvengingWrath:Cooldown() > 15000 or A.RadiantGlory:IsTalentLearned()) and 
    ((holyPower >= 4 and combatTime < 5) or (holyPower >= 3 and combatTime > 5) or (holyPower >= 2 and (A.DivineAuxiliary:IsTalentLearned() or A.RadiantGlory:IsTalentLearned()) and (not A.DivineHammer.IsTalentLearned() or DivineHammer:Cooldown() > 500) and
    WakeofAshes:Cooldown() <= MakGcd())) then 
        return spell:Cast(target) 
    end
end)

--cooldowns->add_action( "avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&time>5|holy_power>=2&talent.divine_auxiliary&(cooldown.execution_sentence.remains=0|cooldown.final_reckoning.remains=0))&(!raid_event.adds.up|target.time_to_die>10)" );
AvengingWrath:Callback("cooldowns", function(spell)
    if A.RadiantGlory:IsTalentLearned() then return end
    if not IsPlayerSpell(A.AvengingWrath.ID) then return end
    if not inMelee then return end
    if shouldBurst() and (holyPower >= 4 or (holyPower >= 3 and MakGcd() > 5) or (holyPower >= 2 and A.DivineAuxiliary:IsTalentLearned() and (ExecutionSentence:Cooldown() == 0 or FinalReckoning:Cooldown() == 0))) then return spell:Cast(player) end
end)

--cooldowns->add_action( "crusade,if=holy_power>=5&time<5|holy_power>=3&time>5" );
Crusade:Callback("cooldowns", function(spell)
    if A.RadiantGlory:IsTalentLearned() then return end
    if not IsPlayerSpell(A.Crusade.ID) then return end
    if not inMelee then return end
    if shouldBurst() and ((holyPower >= 5 and combatTime < 5) or (holyPower >= 3 and combatTime > 5)) then return spell:Cast(player) end
end)

--cooldowns->add_action( "final_reckoning,if=(holy_power>=4&time<8|holy_power>=3&time>=8|holy_power>=2&(talent.divine_auxiliary|talent.radiant_glory))&(cooldown.avenging_wrath.remains>10|cooldown.crusade.remains&(!buff.crusade.up|buff.crusade.stack>=10)|talent.radiant_glory&(buff.avenging_wrath.up|talent.crusade&cooldown.wake_of_ashes.remains<gcd))&(!raid_event.adds.exists|raid_event.adds.up|raid_event.adds.in>40)" );
FinalReckoning:Callback("cooldowns", function(spell)
    if not target.bigButtons then return end
    -- taking this out for now to try and use the singlebuttonassist to cast at target in range
    -- if not inMelee then return end
    if shouldBurst() and ((holyPower >= 4 and combatTime < 8) or (holyPower >= 3 and combatTime >= 8) or (holyPower >= 2 and (A.DivineAuxiliary:IsTalentLearned() or A.RadiantGlory:IsTalentLearned())) and (AvengingWrath:Cooldown() > 10 or (Crusade:Cooldown() > 0 and (not player:Buff(buffs.crusade) or player:HasBuffCount(buffs.crusade) >= 10)) or (A.RadiantGlory:IsTalentLearned() and (player:Buff(buffs.avengingWrath) or (A.Crusade:IsTalentLearned() and WakeofAshes:Cooldown() < MakGcd()))))) then return spell:Cast() end
end)

local function cooldowns()
    LightsJudgment("cooldowns")
    Fireblood("cooldowns")
    ShieldofVengeance("cooldowns")
    ExecutionSentence("cooldowns")
    AvengingWrath("cooldowns")
    Crusade("cooldowns")
    FinalReckoning("cooldowns")
end

--############################################################################ FINISHERS #############################################################################--

--finishers->add_action( "hammer_of_light" );
HammerofLight:Callback("finishers", function(spell)
    return spell:Cast(target)
end)

--finishers->add_action( "divine_hammer,if=holy_power=5" );
DivineHammer:Callback("finishers", function(spell)
    if not inMelee then return end
    if shouldBurst() then return spell:Cast(target) end
end)

--finishers->add_action( "divine_storm,if=variable.ds_castable&!buff.hammer_of_light_ready.up(cooldown.divine_hammer.remains|!talent.divine_hammer)&(!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10|talent.radiant_glory)" );
DivineStorm:Callback("finishers", function(spell)
    if Action.Zone ~= "arena" and gameState.dsCastable and not IsSpellOverlayed(A.HammerofLight.ID) and (not A.Crusade:IsTalentLearned() or Crusade:Cooldown() > MakGcd() * 3 or (player:Buff(buffs.crusade) and player:HasBuffCount(buffs.crusade) < 10) or A.RadiantGlory:IsTalentLearned()) then return spell:Cast(target) end
end)

--finishers->add_action( "divine_storm,if=variable.ds_castable&!buff.hammer_of_light_ready.up&(!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10|talent.radiant_glory)" );
DivineStorm:Callback("finishers", function(spell)
    if Action.Zone ~= "arena" and gameState.dsCastable and not IsSpellOverlayed(A.HammerofLight.ID) and (not A.Crusade:IsTalentLearned() or Crusade:Cooldown() > MakGcd() * 3 or (player:Buff(buffs.crusade) and player:HasBuffCount(buffs.crusade) < 10) or A.RadiantGlory:IsTalentLearned()) then return spell:Cast(target) end
end)

--finishers->add_action( "justicars_vengeance,if=(!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10|talent.radiant_glory)&!buff.hammer_of_light_ready.up&(cooldown.divine_hammer.remains|!talent.divine_hammer)" );
JusticarsVengeance:Callback("finishers", function(spell)
    if A.FinalVerdict:IsTalentLearned() then return end
    if (not A.Crusade:IsTalentLearned() or Crusade:Cooldown() > MakGcd() * 3 or (player:Buff(buffs.crusade) and player:HasBuffCount(buffs.crusade) < 10) or A.RadiantGlory:IsTalentLearned()) and not IsSpellOverlayed(A.HammerofLight.ID) then return spell:Cast(target) end
end)

--finishers->add_action( "templars_verdict,if=(!talent.crusade|cooldown.crusade.remains>gcd*3|buff.crusade.up&buff.crusade.stack<10|talent.radiant_glory)&!buff.hammer_of_light_ready.up&(cooldown.divine_hammer.remains|!talent.divine_hammer)" );
FinalVerdict:Callback("finishers", function(spell)
    if A.JusticarsVengeance:IsTalentLearned() then return end
    if (not A.Crusade:IsTalentLearned() or Crusade:Cooldown() > MakGcd() * 3 or (player:Buff(buffs.crusade) and player:HasBuffCount(buffs.crusade) < 10) or A.RadiantGlory:IsTalentLearned()) and not IsSpellOverlayed(A.HammerofLight.ID) then return spell:Cast(target) end
end)

local function finishers()
    HammerofLight("finishers")
    DivineHammer("finishers")
    DivineStorm("finishers")
    JusticarsVengeance("finishers")
    FinalVerdict("finishers")
end

--############################################################################ GENERATORS ###########################################################################--

--generators->add_action( "call_action_list,name=finishers,if=(holy_power=5|holy_power=4&buff.divine_resonance.up|buff.all_in.up)&cooldown.wake_of_ashes.remains" );

--generators->add_action( "templar_slash,if=buff.templar_strikes.remains<gcd*2" );
--Not sure how to get templar strike buff its weird
--TemplarSlash:Callback("generators", function(spell)
--    if not inMelee then return end
--    if IsSpellOverlayed(A.TemplarSlash.ID) and player:BuffRemains(buffs.templarstrikes) < (MakGcd() * 2) then return spell:Cast(target) end
--end)

--generators->add_action( "templar_slash,if=buff.templar_strikes.remains<gcd*2" );
TemplarSlash:Callback("generators", function(spell)
    if not inMelee then return end
    if A.CrusadingStrikes:IsTalentLearned() then return end
    if IsSpellOverlayed(A.TemplarSlash.ID) then return spell:Cast(target) end
end)

-- generators->add_action( "blade_of_justice,if=!dot.expurgation.ticking&talent.holy_flames" );
BladeofJustice:Callback("generators", function(spell)
    if not inMelee then return end
    if not target:HasDeBuff(A.Expurgation.ID) and IsPlayerSpell(A.HolyFlames.ID) then return spell:Cast(target) end
end)

--generators->add_action( "wake_of_ashes,if=(!talent.lights_guidance|holy_power>=2&talent.lights_guidance)&(cooldown.avenging_wrath.remains>6|cooldown.crusade.remains>6|talent.radiant_glory)&
--(!talent.execution_sentence|cooldown.execution_sentence.remains>4|target.time_to_die<8)&(!raid_event.adds.exists|raid_event.adds.in>10|raid_event.adds.up)" );
WakeofAshes:Callback("generators", function(spell)
    if not target.bigButtons then return end
    if not inMelee then return end
    if shouldBurst() and (not A.LightsGuidance:IsTalentLearned() or (holyPower >= 2 and A.LightsGuidance:IsTalentLearned())) and 
    (AvengingWrath:Cooldown() > 6000 or Crusade:Cooldown() > 6000 or A.RadiantGlory:IsTalentLearned()) and (not A.ExecutionSentence:IsTalentLearned() or ExecutionSentence:Cooldown() > 4000) then return spell:Cast() end
end)

--generators->add_action( "divine_toll,if=holy_power<=2&(!raid_event.adds.exists|raid_event.adds.in>10|raid_event.adds.up)&(cooldown.avenging_wrath.remains>15|cooldown.crusade.remains>15|talent.radiant_glory|fight_remains<8)" );
DivineToll:Callback("generators", function(spell)
    local dtRange = A.GetToggle(2, "divineTollRange")
    if not shouldBurst() then return end
    if target.distance > dtRange then return end
    if holyPower <= 2 and (AvengingWrath:Cooldown() > 15000 or Crusade:Cooldown() > 15000 or A.RadiantGlory:IsTalentLearned()) then return spell:Cast(target) end
end)

--finishers

--generators->add_action( "templar_slash,if=buff.templar_strikes.remains<gcd&spell_targets.divine_storm>=2" );
TemplarSlash:Callback("generators2", function(spell)
    if not inMelee then return end
    if A.CrusadingStrikes:IsTalentLearned() then return end
    if gameState.shouldAoE and IsSpellOverlayed(A.TemplarSlash.ID) then return spell:Cast(target) end
end)

--generators->add_action( "blade_of_justice,if=(holy_power<=3|!talent.holy_blade)&(spell_targets.divine_storm>=2&talent.blade_of_vengeance)" );
BladeofJustice:Callback("generators", function(spell)
    if (holyPower <= 3 or not A.HolyBlade:IsTalentLearned()) and gameState.shouldAoE and A.BladeofVengeance:IsTalentLearned() then return spell:Cast(target) end
end)

--generators->add_action( "hammer_of_wrath,if=(spell_targets.divine_storm<2|!talent.blessed_champion)&(holy_power<=3|target.health.pct>20|!talent.vanguards_momentum)&(buff.blessing_of_anshe.up)" );
HammerofWrath:Callback("generators", function(spell)
    if (gameState.activeEnemies < 2 or not A.BlessedChampion:IsTalentLearned()) and (holyPower <= 3 or target.hp > 20 or not A.VanguardsMomentum:IsTalentLearned()) and player:HasBuff(buffs.blessingofAnshee) then return spell:Cast(target) end
end)

--generators->add_action( "templar_strike" );
TemplarStrike:Callback("generators", function(spell)
    if not inMelee then return end
    if A.CrusadingStrikes:IsTalentLearned() then return end
    return spell:Cast(target)
end)

--generators->add_action( "judgment" );
Judgement:Callback("generators", function(spell)
    return spell:Cast(target)
end)

--generators->add_action( "blade_of_justice" );
BladeofJustice:Callback("generators", function(spell)
    return spell:Cast(target)
end)

--generators->add_action( "hammer_of_wrath,if=(spell_targets.divine_storm<2|!talent.blessed_champion)" );
HammerofWrath:Callback("generators2", function(spell)
    if (gameState.activeEnemies < 2 or not A.BlessedChampion:IsTalentLearned()) then return spell:Cast(target) end
end)

--generators->add_action( "templar_slash" );
TemplarSlash:Callback("generators3", function(spell)
    if not inMelee then return end
    if A.CrusadingStrikes:IsTalentLearned() then return end
    return spell:Cast(target)
end)

--generators->add_action( "crusader_strike" );
CrusaderStrike:Callback("generators", function(spell)
    if not inMelee then return end
    if A.CrusadingStrikes:IsTalentLearned() then return end
    if A.TemplarStrikeStuff:IsTalentLearned() then return end
    return spell:Cast(target)
end)

--generators->add_action( "hammer_of_wrath" );
HammerofWrath:Callback("generators3", function(spell)
    return spell:Cast(target)
end)

--generators->add_action( "arcane_torrent" );
ArcaneTorrent:Callback("generators", function(spell)
    if not inMelee then return end
    return spell:Cast(player)
end)

local function generators()
    --generators->add_action( "call_action_list,name=finishers,if=(holy_power=5|holy_power=4&buff.divine_resonance.up|buff.all_in.up)&cooldown.wake_of_ashes.remains" );
    if (holyPower == 5 or (holyPower == 4 and player:Buff(buffs.divineResonance))) and WakeofAshes:Cooldown() > 500 then finishers() end
    TemplarSlash("generators")
    WakeofAshes("generators")
    DivineToll("generators")
    if combatTime > 2 then finishers() end
    TemplarSlash("generators2")
    BladeofJustice("generators")
    HammerofWrath("generators")
    TemplarStrike("generators")
    Judgement("generators")
    BladeofJustice("generators")
    HammerofWrath("generators2")
    TemplarSlash("generators3")
    if target.hp <= 20 or player:Buff(buffs.avengingWrath) or player:Buff(buffs.crusade) or player:Buff(buffs.empyreanPower) then finishers() end
    CrusaderStrike("generators")
    finishers()
    HammerofWrath("generators3")
    ArcaneTorrent("generators")
end

--############################################################################ PVP STUFF ##############################################################################--

--Rebuke:Callback("pvp", function(spell)
--    if not inMelee then return end
--    if not enemy.pvpKick then return end
--    return spell:Cast(target)
--end)

--############################################################################ PARTY HEALING CALLBACKS ##############################################################################--

local function isValidHealTarget(unit)
    return unit and unit.exists and not unit:IsDeadOrGhost()
end

-- Eternal Flame - Party healing
EternalFlame:Callback("party", function(spell, unit)
    if not isValidHealTarget(unit) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local efThreshold = A.GetToggle(2, "EFHPParty") or 30
    if efThreshold == 0 then return end
    if unit.hp > efThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Lay on Hands - Party emergency healing (without Empyreal Ward)
LayonHands:Callback("party", function(spell, unit)
    if not player.inCombat then return end
    if not isValidHealTarget(unit) then return end
    if A.EmpyrealWard:IsTalentLearned() then return end
    if unit:HasDeBuff(A.Forbearance.ID) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local lohThreshold = A.GetToggle(2, "LohHPParty") or 30
    if lohThreshold == 0 then return end
    if unit.hp > lohThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Lay on Hands Ward - Party emergency healing (with Empyreal Ward talent)
LayonHandsPassiveToo:Callback("party", function(spell, unit)
    if not player.inCombat then return end
    if not isValidHealTarget(unit) then return end
    if not A.EmpyrealWard:IsTalentLearned() then return end
    if unit:HasDeBuff(A.Forbearance.ID) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local lohThreshold = A.GetToggle(2, "LohHPParty") or 30
    if lohThreshold == 0 then return end
    if unit.hp > lohThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Blessing of Protection - Party emergency physical immunity
BlessingofProtection:Callback("party", function(spell, unit)
    if not player.inCombat then return end
    if not isValidHealTarget(unit) then return end
    if unit:HasDeBuff(A.Forbearance.ID) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    -- Don't BOP tanks
    if unit:IsUnit(tank) then return end
    local role = UnitGroupRolesAssigned(unit:CallerId())
    if role == "TANK" then return end
    if unit:IsTank() then return end

    local bopThreshold = A.GetToggle(2, "BopHPParty") or 30
    if bopThreshold == 0 then return end
    if unit.hp > bopThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Word of Glory - Party healing
WordofGlory:Callback("party", function(spell, unit)
    if not isValidHealTarget(unit) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local wogThreshold = A.GetToggle(2, "WogHPParty") or 30
    if wogThreshold == 0 then return end
    if unit.hp > wogThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Flash of Light - Party healing (requires Light's Celerity talent)
FlashofLight:Callback("party", function(spell, unit)
    if not isValidHealTarget(unit) then return end
    if not A.LightsCelerity:IsTalentLearned() then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local flashThreshold = A.GetToggle(2, "FlashLightHPParty") or 50
    if flashThreshold == 0 then return end
    if unit.hp > flashThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

-- Blessing of Sacrifice - Party damage reduction (not on focus)
BlessingofSacrifice:Callback("party", function(spell, unit)
    if not player.inCombat then return end
    if unit:IsMe() then return end
    if player.hp < 70 then return end
    if not isValidHealTarget(unit) then return end
    if spell:Cooldown() > 0 then return end
    if not spell:InRange(unit) then return end

    local sacThreshold = A.GetToggle(2, "SacHP") or 60
    if sacThreshold == 0 then return end
    if unit.hp > sacThreshold then return end

    HealingEngine.SetTarget(unit:CallerId(), 1)
    return spell:Cast(unit)
end)

FlashofLight:Callback("tank", function(spell)
    if not tank or not tank.exists then return end

    HealingEngine.SetTarget(tank:CallerId(), 1)
    return spell:Cast(tank)
end)

--############################################################################ HEALING ROTATION ##############################################################################--

local function HealingRotation()
    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end

    -- Emergency heals
    LayonHands("party", unit)
    LayonHandsPassiveToo("party", unit)
    BlessingofProtection("party", unit)

    -- Regular heals
    WordofGlory("party", unit)
    EternalFlame("party", unit)
    FlashofLight("party", unit)

    -- Utility
    BlessingofSacrifice("party", unit)
end

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    if Action.Zone ~= "arena" then
        makInterrupt(interrupts)
    end

    if player.inCombat then
        Intercession("general")
    end

    -- IMPROVED: All defensive abilities moved outside target validation block
    -- This allows defensive usage during kiting/retreat without requiring a valid target
    -- Critical for survival when running away or out of range
    LayonHands("general")
    DivineShield("general")
    BlessingofProtection("general")
    ShieldofVengeance("general")
    DivineProtection("general")
    FlashofLight("general")
    WordofGlory("general")
    Redemption("general")
    DevotionAura("general")
    FlashofLight("generalOOC")

    -- Party healing rotation (target/focus friendly healing)
    HealingRotation()


    if target.exists and target.hp > 0 and target.canAttack and Judgement:InRange(target) and not player:Debuff(410201) then

        if shouldBurst() then
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end

            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.FleetingR1, A.FleetingR2, A.FleetingR3, A.TemperedR1, A.TemperedR2, A.TemperedR3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.avengingWrath) or player:Buff(buffs.crusade) or target:Debuff(debuffs.executionSentence, true)
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
        end
        cooldowns()
        generators()
    end

	return FrameworkEnd()
end

--##########################################################################ARENA STUFF#####################################################################################################

-------------------------------------------------------------------------## ARENA ENEMY ##--------------------------------------------------------------------------------------------------
-- Hoj healer if he is not in cc and has more than 50% dr
HammerofJustice:Callback("arena_healer", function(spell, enemy)
    if enemy.ccImmune then return end
    if not spell:InRange(enemy) then return end
    if not enemy:IsUnit(enemyHealer) then return end
    if enemy:Debuff(203337) then return end
    if enemy.stunDr < 0.5 then return end
    if enemy:IsTarget() then return end
    if enemy:CCRemains() > 1500 then return end
    if player:Debuff(410201) then return end
    Aware:displayMessage("HOJ - Enemy Healer", "Blue", 1)
    return spell:Cast(enemy)
end)

-- Hoj kill target if the enemy team's healer is cced for more than 2 seconds and the kill target is not in cc and has more than 50% dr and is lower than 50% hp
HammerofJustice:Callback("arena_kill", function(spell, enemy)
    if enemy.ccImmune then return end
    if not spell:InRange(enemy) then return end
    if not enemy:IsTarget() then return end
    if enemy:Debuff(203337) then return end
    --if enemy.stunDr < 0.5 then return end
    if enemy:IsUnit(enemyHealer) then return end
    if enemyHealer:CCRemains() < 2000 then return end
    --if not enemyHealer:HasDebuffFromFor(MakLists.CC, 500) then return end
    --if enemy.hp > 50 then return end
    if player:Debuff(410201) then return end

    if enemy.stunDr == 1 then
        Aware:displayMessage("HOJ - KT - Enemy Healer CCed", "Red", 1)
        return spell:Cast(enemy)
    end

    if enemy.stunDr < 0.5 and enemy.hp < 50 then
        Aware:displayMessage("HOJ - KT - Enemy Healer CCed", "Red", 1)
        return spell:Cast(enemy)
    end
end)

-- PVP Kick with Rebuke
Rebuke:Callback("arena", function(spell, enemy)
    if enemy:IsKickImmune() then return end
    if not spell:InRange(enemy) then return end
    if enemy.distance > 10 then return end
    if player:Debuff(410201) then return end
    if not enemy:CastingFromFor(MakLists.arenaKicks, 620) then return end
    return spell:Cast(enemy)
end)

-------------------------------------------------------------------------## M+ PARTY ##-----------------------------------------------------------------------------------------------------

CleanseToxins:Callback("mplus", function(spell, friendly) 
    local iNeedCleanse = player.diseased or player.poisoned
    local shouldDispel = friendly.diseased or friendly.poisoned

    --Hopefully this makes it self prio
    if iNeedCleanse then
        if not friendly.isMe then return end
    end

    if shouldDispel then
        return Debounce("cleanse", 1000, 2500, spell, friendly)
    end
end)


-------------------------------------------------------------------------## ARENA PARTY ##--------------------------------------------------------------------------------------------------


-- BOP party if they are lower than slider values and not total immune and friendly is not a paladin
-- Excludes tanks from being valid BOP targets using multiple checks for reliability
BlessingofProtection:Callback("arena_party", function(spell, friendly)
    local hasPhys = MakMulti.arena:Any(function(enemy) return not enemy.isHealer and not enemy.isCaster end)
    if Action.Zone ~= "arena" then return end
    if not hasPhys then return end

    -- Exclude tanks from being valid BOP targets (triple-check for maximum reliability)
    -- Check 1: Compare against designated tank unit
    if friendly:IsUnit(tank) then return end
    -- Check 2: Check assigned role (works in instanced content)
    local role = UnitGroupRolesAssigned(friendly:CallerId())
    if role == "TANK" then return end
    -- Check 3: Check if unit is tank spec (works in all content)
    if friendly:IsTank() then return end

    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return end
    if friendly.hp > A.GetToggle(2, "BopHPParty") then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    if ((arena1.exists and not arena1:IsMelee()) and (arena2.exists and not arena2:IsMelee()) and (arena3.exists and not arena3:IsMelee())) then return end
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end
    --Aware:displayMessage("Blessing of Protection on Party", "White", 1)
    return spell:Cast(friendly)
end)

BlessingofProtection:Callback("dungeon_party", function(spell, friendly)
    if Action.Zone == "arena" then return end

    -- Exclude tanks from being valid BOP targets (triple-check for maximum reliability)
    -- Check 1: Compare against designated tank unit
    if friendly:IsUnit(tank) then return end
    -- Check 2: Check assigned role (works in instanced content)
    local role = UnitGroupRolesAssigned(friendly:CallerId())
    if role == "TANK" then return end
    -- Check 3: Check if unit is tank spec (works in all content)
    if friendly:IsTank() then return end

    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return end
    if friendly.hp > A.GetToggle(2, "BopHPParty") then return end
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end
    --Aware:displayMessage("Blessing of Protection on Party", "White", 1)
    return spell:Cast(friendly)
end)

-- Blessing of Spellwarding - Arena only, protects against magic damage
-- IMPROVED: More proactive casting with relaxed conditions
-- Now includes healer casters and uses higher HP threshold (45%) for better protection
BlessingofSpellwarding:Callback("arena_party", function(spell, friendly)
    -- Check if any enemy caster exists in arena (including healers)
    -- CHANGED: Previously only checked non-healer casters, now includes ALL casters for better coverage
    local hasMagicDamage = MakMulti.arena:Any(function(enemy) return enemy.isCaster end)
    if not hasMagicDamage then return end

    -- Don't cast on self if Divine Shield is available soon (prefer bubble)
    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return end

    -- IMPROVED: Use 45% HP threshold for more proactive usage (was 30% via BopHPParty)
    -- This allows earlier protection before teammate takes critical damage
    if friendly.hp > 45 then return end

    -- Don't waste if about to kill target and friendly is relatively safe
    if friendly.hp > 40 and target.hp < 20 then return end

    -- Safety checks - don't cast if already protected or can't benefit
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end

    -- Don't cast on other Paladins (they have their own immunities)
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end

    Aware:displayMessage("Spellwarding - Protection Against Magic Damage", "Purple", 1)
    return spell:Cast(friendly)
end)

-- LOH party if they are lower than slider values and not total immune and friendly is not a paladin
-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
-- FIX: Check cooldown status of ALL Lay on Hands spell IDs before suggesting
LayonHandsPassive:Callback("arena_party", function(spell, friendly)
    if IsPlayerSpell(EmpyreanWard.id) then return false end
    if friendly.totalImmune then return false end
    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return false end
    if friendly.hp > A.GetToggle(2, "LohHPParty") then return false end
    -- Only skip if target is NOT the friendly we're trying to heal (allow healing teammates even if enemy is low)
    if friendly.hp > 40 and target.hp < 20 and A.Zone == "arena" and not friendly:IsUnit(target) then return false end
    if friendly:HasDeBuff(A.Forbearance.ID) then return false end
    if friendly:IsTotalImmune() then return false end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return false end

    -- Check if ANY Lay on Hands spell ID is on cooldown
    -- Only suggest if NONE of the spell IDs are on cooldown
    if LayonHands:Cooldown() > 0 or LayonHandsPassiveToo:Cooldown() > 0 then return false end

    -- PRIORITY FIX: Don't cast on player if a teammate is lower HP and needs healing
    if friendly:IsMe() then
        local lohThreshold = A.GetToggle(2, "LohHPParty")
        -- Check all party members to see if any are lower HP than player and below threshold
        for _, teammate in ipairs({party1, party2, party3, party4}) do
            if teammate.exists and teammate.hp > 0 and teammate.hp < player.hp and teammate.hp < lohThreshold then
                -- A teammate is lower HP than us and needs healing, skip casting on player
                return false
            end
        end
    end

    --Aware:displayMessage("Lay on Hands on Party", "White", 1)
    local casted = spell:Cast(friendly)
    if casted then
        return true
    end
    return false
end)

-- LOH party if they are lower than slider values and not total immune and friendly is not a paladin
-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
-- FIX: Check cooldown status of ALL Lay on Hands spell IDs before suggesting
LayonHandsPassiveToo:Callback("arena_party", function(spell, friendly)
    if not IsPlayerSpell(EmpyreanWard.id) then return false end
    if friendly.totalImmune then return false end
    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return false end
    if friendly.hp > A.GetToggle(2, "LohHPParty") then return false end
    -- Only skip if target is NOT the friendly we're trying to heal (allow healing teammates even if enemy is low)
    if friendly.hp > 40 and target.hp < 20 and A.Zone == "arena" and not friendly:IsUnit(target) then return false end
    if friendly:HasDeBuff(A.Forbearance.ID) then return false end
    if friendly:IsTotalImmune() then return false end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return false end

    -- Check if ANY Lay on Hands spell ID is on cooldown
    -- Only suggest if NONE of the spell IDs are on cooldown
    if LayonHands:Cooldown() > 0 or LayonHandsPassiveToo:Cooldown() > 0 then return false end

    -- PRIORITY FIX: Don't cast on player if a teammate is lower HP and needs healing
    if friendly:IsMe() then
        local lohThreshold = A.GetToggle(2, "LohHPParty")
        -- Check all party members to see if any are lower HP than player and below threshold
        for _, teammate in ipairs({party1, party2, party3, party4}) do
            if teammate.exists and teammate.hp > 0 and teammate.hp < player.hp and teammate.hp < lohThreshold then
                -- A teammate is lower HP than us and needs healing, skip casting on player
                return false
            end
        end
    end

    --Aware:displayMessage("Lay on Hands on Party", "White", 1)
    local casted = spell:Cast(friendly)
    if casted then
        return true
    end
    return false
end)

-- Blessing of Sacrifice party if they are lower than slider values
BlessingofSacrifice:Callback("arena_party", function(spell, friendly)
    if A.IsInPvP or not A.GetToggle(2, "sacTankOnly") then
        if friendly:IsMe() then return end
        if friendly.hp > 40 and target.hp < 20 then return end
        if player.hp < 40 then return end
        if friendly:IsTotalImmune() then return end

        if friendly.hp < A.GetToggle(2, "SacHP") then
            return spell:Cast(friendly)
        end

        if friendly.hp < 60 and friendly.hp < player.hp then
            return spell:Cast(friendly)
        end
    else
        if A.GetToggle(2, "sacTankOnly") then
            --if not friendly:IsUnit(tank) then return end
            local role = UnitGroupRolesAssigned(friendly:CallerId())
            if role ~= "TANK" then return end
            if player.hp < 40 then return end

            local tankBusterIn = MakuluFramework.DBM_TankBusterIn()
            if tankBusterIn < 1500 then
                --Aware:displayMessage("Blessing of Sacrifice on Tank Buster", "White", 1)
                return spell:Cast(friendly)
            end
        end
    end
end)

-- FOL party if they are lower than slider values and we have lights celerity talent
FlashofLightParty:Callback("arena_party", function(spell, friendly)
    if friendly.hp > A.GetToggle(2, "FlashLightHPParty") then return end
    if not A.LightsCelerity:IsTalentLearned() then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    if friendly:IsTotalImmune() and not healer.cc then return end
    --Aware:displayMessage("Flash of Light on Party", "White", 1)
    return spell:Cast(friendly)
end)

-- Word of Glory party if they are lower than slider values
WordofGlory:Callback("arena_party", function(spell, friendly)
    if friendly.hp > A.GetToggle(2, "WogHPParty") then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    --maybe add healer.cc check later
    --Aware:displayMessage("Word of Glory on Party", "White", 1)
    return spell:Cast(friendly)
end)

-- Word of Glory party if they are lower than slider values
EternalFlame:Callback("arena_party", function(spell, friendly)
    if friendly.hp > A.GetToggle(2, "EFHPParty") then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    --maybe add healer.cc check later
    --Aware:displayMessage("Eternal Flame on Party", "White", 1)
    return spell:Cast(friendly)
end)

-- Blessing of Sanctuary - Proactive CC protection for party members
-- IMPROVED: Configurable priority system for PvP usage
-- Reduced delay from 500ms to 100ms for faster reaction to stuns
-- This ensures the buff is applied DURING the stun, not after it expires
BlessingofSanctuary:Callback("arena_party", function(spell, friendly)
    if friendly:IsMe() then return false end

    -- Only use in PvP (arena/battlegrounds)
    if Action.Zone ~= "arena" and not A.IsInPvP then return false end

    -- Check if Blessing of Sanctuary is enabled
    if not A.GetToggle(2, "BlessingofSanctuaryEnabled") then return false end

    -- Get priority mode from settings
    local priorityMode = A.GetToggle(2, "BlessingofSanctuaryPriority") or "SmartPriority"

    -- Check if friendly has a CC debuff that Sanctuary can help with
    if not friendly:HasDeBuffFromFor(MakLists.sanc, 100) then return false end

    -- PRIORITY MODE: Healers Only
    if priorityMode == "HealersOnly" then
        if friendly.isHealer then
            Aware:displayMessage("Blessing of Sanctuary - Healer CC", "Yellow", 1)
            return spell:Cast(friendly)
        end
        return false
    end

    -- PRIORITY MODE: Smart Priority (Healers > Casters > Others)
    if priorityMode == "SmartPriority" then
        -- PRIORITY 1: Healers (highest priority for CC protection)
        if friendly.isHealer then
            Aware:displayMessage("Blessing of Sanctuary - Healer CC", "Yellow", 1)
            return spell:Cast(friendly)
        end

        -- PRIORITY 2: Casters/Ranged DPS (second priority - vulnerable to CC)
        if friendly.isCaster then
            Aware:displayMessage("Blessing of Sanctuary - Caster CC", "Cyan", 1)
            return spell:Cast(friendly)
        end

        -- PRIORITY 3: Other teammates (lower priority)
        Aware:displayMessage("Blessing of Sanctuary - Teammate CC", "Orange", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY MODE: Use When Available (no restrictions)
    if priorityMode == "UseWhenAvailable" then
        if friendly.isHealer then
            Aware:displayMessage("Blessing of Sanctuary - Healer CC", "Yellow", 1)
        elseif friendly.isCaster then
            Aware:displayMessage("Blessing of Sanctuary - Caster CC", "Cyan", 1)
        else
            Aware:displayMessage("Blessing of Sanctuary - Teammate CC", "Orange", 1)
        end
        return spell:Cast(friendly)
    end

    return false
end)

-- Blessing of Freedom - Self-cast for player when rooted/slowed
-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
BlessingofFreedom:Callback("self", function(spell)
    -- Only use in combat
    if not player.inCombat then return false end

    -- Don't use if already immune or have Freedom active
    if player:IsTotalImmune() then return false end
    if player:Buff(A.BlessingofFreedom.ID) then return false end

    -- Check if player is affected by root or movement-impairing effects
    -- Using both player.rooted property and MakLists.freedom for comprehensive detection
    local hasRootDebuff = player.rooted or player:HasDeBuffFromFor(MakLists.freedom, 500)

    if not hasRootDebuff then return false end

    -- Use Freedom on self when rooted/slowed (500ms minimum to avoid wasting on instant dispels)
    Aware:displayMessage("Freedom - Self Root", "Purple", 1)
    local casted = spell:Cast(player)
    if casted then return true end
    return false
end)

-- Blessing of Freedom - Automatic for rooted/slowed teammates (Arena/BG)
-- Priority: Healers > Casters/Ranged DPS > Other teammates (melee/tanks)
-- Detects root and beam effects using MakLists.freedom and friendly.rooted
-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
BlessingofFreedom:Callback("arena_party", function(spell, friendly)
    -- Don't cast on self (separate self-cast callback handles that)
    if friendly:IsMe() then return false end

    -- Don't waste Freedom if we're about to kill target
    if target.exists and target.hp < 10 then return false end

    -- Check if friendly is in range (40 yards for Blessing of Freedom)
    if friendly.distance > 40 then return false end

    -- Don't cast on dead or immune targets
    if friendly.hp <= 0 then return false end
    if friendly:IsTotalImmune() then return false end

    -- Check if friendly is affected by root or beam effects
    -- Using both friendly.rooted property and MakLists.freedom for comprehensive detection
    local hasRootDebuff = friendly.rooted or friendly:HasDeBuffFromFor(MakLists.freedom, 500)

    if not hasRootDebuff then return false end

    -- PRIORITY 1: Healers (highest priority)
    -- Cast Freedom on healers immediately when they are rooted/beamed (500ms minimum)
    if friendly.isHealer then
        Aware:displayMessage("Freedom - Healer Rooted", "Green", 1)
        local casted = spell:Cast(friendly)
        if casted then return true end
        return false
    end

    -- PRIORITY 2: Casters/Ranged DPS (second priority)
    -- Casters are more vulnerable to roots/beams than melee since they rely on positioning and casting
    -- Cast Freedom on casters with same urgency as healers (500ms minimum)
    if friendly.isCaster then
        Aware:displayMessage("Freedom - Caster Rooted", "Cyan", 1)
        local casted = spell:Cast(friendly)
        if casted then return true end
        return false
    end

    -- PRIORITY 3: Other teammates - melee/tanks (third priority)
    -- Only cast if the debuff has been active for at least 700ms to avoid wasting on instant dispels
    -- and if the friendly is in danger (hp < 70) or if we have Unbound Freedom talent
    if friendly:HasDeBuffFromFor(MakLists.freedom, 700) then
        -- Cast on low HP teammates
        if friendly.hp < 70 then
            Aware:displayMessage("Freedom - Teammate Low HP", "Yellow", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end

        -- Cast on any teammate if we have Unbound Freedom talent (multiple charges)
        if IsPlayerSpell(A.UnboundFreedom.ID) then
            Aware:displayMessage("Freedom - Teammate Rooted", "Blue", 1)
            local casted = spell:Cast(friendly)
            if casted then return true end
            return false
        end
    end

    -- Special case: Suleyman's Clap mechanic (specific PvE encounter)
    local suleymanClap = target.exists and UnitPower("target") >= 90 and target.npcId == 212826
    if suleymanClap and friendly:ClassID() ~= 2 then -- Don't cast on other Paladins
        Aware:displayMessage("Freedom - Suleyman Clap", "Orange", 1)
        local casted = spell:Cast(friendly)
        if casted then return true end
        return false
    end

    return false
end)

-- FIX: Added explicit return false to prevent icon from sticking when spell is on cooldown
SearingGlare:Callback("arena", function(spell, enemy)
    -- Only use in PvP (arena/battlegrounds)
    if Action.Zone ~= "arena" and not A.IsInPvP then return false end

    -- Check if Searing Glare is enabled
    if not A.GetToggle(2, "SearingGlareEnabled") then return false end

    -- Don't use if we're already affected by Searing Glare debuff (can't cast while blinded)
    if player:Debuff(410201) then return false end

    -- Basic target validation
    if not enemy.exists then return false end
    if enemy.hp <= 0 then return false end
    if enemy.distance > 25 then return false end
    if enemy:IsTotalImmune() then return false end

    -- Don't use if target has CC immunity
    if enemy:BuffFrom(MakLists.CCImmune) then return false end

    -- Get usage mode from settings
    local usageMode = A.GetToggle(2, "SearingGlarePriority") or "Smart"

    -- Check if we're in burst window (for Burst mode)
    local inBurstWindow = player:Buff(buffs.avengingWrath) or player:Buff(buffs.crusade)

    -- Check if we or teammates are low HP (for Defensive mode)
    local lowHpThreshold = 40
    local teamLowHp = player.hp < lowHpThreshold or
                      (party1.exists and party1.hp < lowHpThreshold) or
                      (party2.exists and party2.hp < lowHpThreshold)

    -- Check if enemy is casting an important spell
    local castInfo = enemy.castOrChannelInfo
    local enemyCasting = castInfo and castInfo.remaining and castInfo.remaining > 500

    -- USAGE MODE: Smart (Healers/Casters Priority)
    if usageMode == "Smart" then
        -- PRIORITY 1: Enemy healer casting important heal
        if enemy.isHealer and enemyCasting then
            Aware:displayMessage("Searing Glare - Healer Cast", "Yellow", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        -- PRIORITY 2: Enemy caster during burst window or casting important spell
        if enemy.isCaster then
            if inBurstWindow or enemyCasting then
                Aware:displayMessage("Searing Glare - Caster Burst", "Cyan", 1)
                local casted = spell:Cast(enemy)
                if casted then return true end
                return false
            end
        end

        -- PRIORITY 3: Defensive usage when team is low HP
        if teamLowHp and (enemy.isHealer or enemy.isCaster) then
            Aware:displayMessage("Searing Glare - Defensive", "Orange", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        return false
    end

    -- USAGE MODE: Interrupt Only (During Enemy Casts)
    if usageMode == "Interrupt" then
        if not enemyCasting then return false end

        -- Prioritize healers and casters
        if enemy.isHealer then
            Aware:displayMessage("Searing Glare - Interrupt Healer", "Yellow", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        if enemy.isCaster then
            Aware:displayMessage("Searing Glare - Interrupt Caster", "Cyan", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        return false
    end

    -- USAGE MODE: Burst Windows (During Offensive CDs)
    if usageMode == "Burst" then
        if not inBurstWindow then return false end

        -- Use on healers and casters during burst
        if enemy.isHealer then
            Aware:displayMessage("Searing Glare - Burst Healer", "Yellow", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        if enemy.isCaster then
            Aware:displayMessage("Searing Glare - Burst Caster", "Cyan", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        -- Use on any enemy during burst if they're the kill target
        if enemy.hp < 40 then
            Aware:displayMessage("Searing Glare - Burst Execute", "Red", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        return false
    end

    -- USAGE MODE: Defensive (When Low HP)
    if usageMode == "Defensive" then
        if not teamLowHp then return false end

        -- Prioritize stopping enemy damage dealers when team is low
        if enemy.isHealer or enemy.isCaster or enemyCasting then
            Aware:displayMessage("Searing Glare - Defensive Save", "Orange", 1)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end

        return false
    end

    return false
end)

--[[ 
-- ============================================================================
-- Repentance - Smart PvP CC (30-second incapacitate, breaks on damage)
-- ============================================================================
-- Offensive Usage:
--   - CC enemy healer during burst windows (Avenging Wrath/Crusade)
--   - Prevents healing while you kill their DPS
--   - Best used when healer is NOT already CC'd (don't overlap)
--
-- Defensive Usage:
--   - CC enemy DPS attacking low HP teammates
--   - Peel for healer or squishy DPS under pressure
--   - Emergency CC to stop enemy burst on low HP target
--
-- Priority Targeting:
--   1. Enemy healer during your burst (offensive)
--   2. Enemy DPS attacking low HP teammate (defensive)
--   3. Healers > Casters > Melee (general priority)
--
-- Key Considerations:
--   - Don't use if target is already CC'd (waste)
--   - Check diminishing returns (stunDr property)
--   - Arena only (not useful in battlegrounds due to damage breaking)
-- ============================================================================
]]
Repentance:Callback("arena_offensive", function(spell, enemy)
    -- Check if Repentance automation is enabled
    if not A.GetToggle(2, "RepentanceEnabled") then return false end

    -- Get usage mode configuration
    local usageMode = A.GetToggle(2, "RepentanceUsageMode") or "Smart"

    -- Skip if mode is Manual or Defensive Only
    if usageMode == "Manual" or usageMode == "Defensive" then return false end

    -- Only use in arena (breaks on damage, not useful in BGs)
    if Action.Zone ~= "arena" and not A.IsInPvP then return false end

    -- Basic validation
    if not enemy.exists then return false end
    if enemy.hp <= 0 then return false end
    if enemy.distance > 30 then return false end

    -- Don't use on immune targets
    if enemy:IsTotalImmune() then return false end
    if enemy:BuffFrom(MakLists.CCImmune) then return false end

    -- Don't use if enemy is already CC'd (waste of CC)
    if enemy.ccImmune then return false end
    -- if enemy.incapacitated then return false end

    -- Check diminishing returns (don't use if DR is too low)
    if enemy.incapacitateDr < 0.25 then return false end

    -- OFFENSIVE USAGE: CC enemy healer during burst windows
    -- Only use when we have offensive cooldowns active
    local inBurstWindow = player:Buff(buffs.avengingWrath) or player:Buff(buffs.crusade)

    if not inBurstWindow then return false end

    -- Priority 1: Enemy healer (highest priority during burst)
    if enemy.isHealer then
        Aware:displayMessage("Repentance - Healer CC (Burst)", "Gold", 1.5)
        local casted = spell:Cast(enemy)
        if casted then return true end
        return false
    end

    -- Priority 2: Enemy casters (secondary priority during burst)
    if enemy.isCaster then
        Aware:displayMessage("Repentance - Caster CC (Burst)", "Orange", 1.5)
        local casted = spell:Cast(enemy)
        if casted then return true end
        return false
    end

    return false
end)

Repentance:Callback("arena_defensive", function(spell, enemy)
    -- Check if Repentance automation is enabled
    if not A.GetToggle(2, "RepentanceEnabled") then return false end

    -- Get usage mode configuration
    local usageMode = A.GetToggle(2, "RepentanceUsageMode") or "Smart"

    -- Skip if mode is Manual or Offensive Only
    if usageMode == "Manual" or usageMode == "Offensive" then return false end

    -- Only use in arena
    if Action.Zone ~= "arena" and not A.IsInPvP then return false end

    -- Basic validation
    if not enemy.exists then return false end
    if enemy.hp <= 0 then return false end
    if enemy.distance > 30 then return false end

    -- Don't use on immune targets
    if enemy:IsTotalImmune() then return false end
    if enemy:BuffFrom(MakLists.CCImmune) then return false end

    -- Don't use if enemy is already CC'd
    if enemy.ccImmune then return false end
    -- if enemy.incapacitated then return false end

    -- Check diminishing returns
    if enemy.incapacitateDr < 0.25 then return false end

    -- DEFENSIVE USAGE: CC enemies attacking low HP teammates
    local defensiveHpThreshold = A.GetToggle(2, "RepentanceDefensiveHP") or 30

    -- Check if player is low HP and being attacked by this enemy
    if player.hp < defensiveHpThreshold and enemy.target == player then
        Aware:displayMessage("Repentance - Defensive Peel (Self)", "Red", 1.5)
        local casted = spell:Cast(enemy)
        if casted then return true end
        return false
    end

    -- Check if party members are low HP and being attacked by this enemy
    if party1.exists and party1.hp < defensiveHpThreshold and party1.hp > 0 then
        if enemy.target == party1 then
            local targetName = party1.name or "Party1"
            Aware:displayMessage("Repentance - Defensive Peel (" .. targetName .. ")", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
    end

    if party2.exists and party2.hp < defensiveHpThreshold and party2.hp > 0 then
        if enemy.target == party2 then
            local targetName = party2.name or "Party2"
            Aware:displayMessage("Repentance - Defensive Peel (" .. targetName .. ")", "Red", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
    end

    -- Priority defensive peel for healer (even if not super low HP)
    if party1.exists and party1.isHealer and party1.hp < (defensiveHpThreshold + 15) and party1.hp > 0 then
        if enemy.target == party1 then
            Aware:displayMessage("Repentance - Healer Peel", "Purple", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
    end

    if party2.exists and party2.isHealer and party2.hp < (defensiveHpThreshold + 15) and party2.hp > 0 then
        if enemy.target == party2 then
            Aware:displayMessage("Repentance - Healer Peel", "Purple", 1.5)
            local casted = spell:Cast(enemy)
            if casted then return true end
            return false
        end
    end

    return false
end)


local enemyRotation = function(enemy)
    if player:Debuff(410201) then return end
    if Action.Zone ~= "arena" then return end
	if not enemy.exists then return end
    if enemy.hp <= 0 then return end

    -- CC abilities (priority order: hard CC > soft CC > interrupts)
    Repentance("arena_offensive", enemy)  -- Offensive: CC healer during burst
    Repentance("arena_defensive", enemy)  -- Defensive: Peel for low HP teammates
    SearingGlare("arena", enemy)          -- Blind enemies (4 sec miss)
    HammerofJustice("arena_healer", enemy) -- Stun healer
    HammerofJustice("arena_kill", enemy)   -- Stun kill target
    Rebuke("arena", enemy)                 -- Interrupt

end

local partyRotation = function(friendly)
    local partySize = GetNumGroupMembers()
    if partySize > 5 then return end
    if not friendly.exists then return end
    if friendly.hp <= 0 then return end
    if friendly:IsDeadOrGhost() then return end

    -- Self-cast abilities (only when friendly is player)
    if friendly:IsMe() then
        BlessingofFreedom("self")
    end

    -- Party abilities
    BlessingofSanctuary("arena_party", friendly)
    --LayonHandsPassive("arena_party", friendly)
    --LayonHandsPassiveToo("arena_party", friendly)
    CleanseToxins("mplus", friendly)
    --BlessingofProtection("arena_party", friendly)
    --BlessingofProtection("dungeon_party", friendly)
    BlessingofSpellwarding("arena_party", friendly)
    --BlessingofSacrifice("arena_party", friendly)
    --FlashofLightParty("arena_party", friendly)
    --WordofGlory("arena_party", friendly)
    --EternalFlame("arena_party", friendly)
    BlessingofFreedom("arena_party", friendly)

end

A[6] = function(icon)
	RegisterIcon(icon)
    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    partyRotation(party1)
	enemyRotation(arena1)

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
