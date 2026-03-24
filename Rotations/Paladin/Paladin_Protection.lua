if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 66 then return end

local FrameworkStart   = MakuluFramwork.start
local FrameworkEnd     = MakuluFramwork.endFunc
local RegisterIcon     = MakuluFramwork.registerIcon

local MakUnit          = MakuluFramwork.Unit
local MakEnemies       = MakuluFramwork.Enemies
local MakSpell         = MakuluFramwork.Spell
local MakMulti         = MakuluFramwork.MultiUnits
local MakParty         = MakuluFramwork.Party
local TableToLocal     = MakuluFramwork.tableToLocal
local MakGcd           = MakuluFramwork.gcd
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit       	   = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local LoC              = Action.LossOfControl
local UnitIsUnit	   = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable
local GetSpellTexture  = _G.TMW.GetSpellTexture

local ActionID = {
	--Racials
	WillToSurvive                = { ID = 59752 },
	Stoneform                    = { ID = 20594 },
	Shadowmeld                   = { ID = 58984 },
	EscapeArtist                 = { ID = 20589 },
	GiftOfTheNaaru               = { ID = 59544 },
	Darkflight                   = { ID = 68992 },
	BloodFury                    = { ID = 20572 },
	WillOfTheForsaken            = { ID = 7744  },
	WarStomp                     = { ID = 20549 },
	Berserking                   = { ID = 26297 },
	ArcaneTorrent                = { ID = 50613 },
	RocketJump                   = { ID = 69070 },
	RocketBarrage                = { ID = 69041 },
	QuakingPalm                  = { ID = 107079},
	SpatialRift                  = { ID = 256948},
	LightsJudgment               = { ID = 255647},
	Fireblood                    = { ID = 265221},
	ArcanePulse                  = { ID = 260364},
	BullRush                     = { ID = 255654},
	AncestralCall                = { ID = 274738},
	Haymaker                     = { ID = 287712},
	Regeneratin                  = { ID = 291944},
	BagOfTricks                  = { ID = 312411},
	HyperOrganicLightOriginator  = { ID = 312924},
	TargetEnemy                  = { ID = 44603 },
	StopCast                     = { ID = 61721 },
	PoolResource                 = { ID = 209274},
	FocusParty1                  = { ID = 134314},
	FocusParty2                  = { ID = 134316},
	FocusParty3                  = { ID = 134318},
	FocusParty4                  = { ID = 134320},
	FocusPlayer                  = { ID = 134310},
	AntiFakeKick                 = { Type = "SpellSingleColor", ID = 96231,  Hidden = true,		Color = "GREEN"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC					 = { Type = "SpellSingleColor", ID = 853,  	Hidden = true,		Color = "YELLOW"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	},
	--BaselineProtectionPaladinAbilities
	Consecration                 = { ID = 26573 },
	ConsecrationDebuff			 = { ID = 204242 },
	CrusaderStrike               = { ID = 35395 },
	DivineShield                 = { ID = 642   },
	DivineProtection             = { ID = 403876},
	FlashofLight                 = { ID = 19750 },
	HammerofJustice              = { ID = 853   },
	HandofReckoning              = { ID = 62124 },
	Judgment                     = { ID = 20271 },
	SenseUndead                  = { ID = 5502  },
	ShieldoftheRighteous         = { ID = 53600 },
	WordofGlory                  = { ID = 85673 },
	Redemption                   = { ID = 7328  },
	Intercession                 = { ID = 391054},
	DevotionAura                 = { ID = 465   },
	--BaselineProtectionPaladinPassives
	MasteryDivineBulwark         = { ID = 76671 },
	AegisofLight                 = { ID = 353367},
	Riposte                      = { ID = 161800},
	Forbearance                  = { ID = 25771 },
	--ProtectionPaladinClassTreeAbilities
	LayonHands                   = { ID = 633   },
	LayonHandsPassive             = { ID = 633, Desc = "passive" },
	LayonHandsPassiveToo          = { ID = 471195, Desc = "passive" },
	BlessingofFreedom            = { ID = 1044  },
	HammerofWrath                = { ID = 24275 },
	CleanseToxins                = { ID = 213644},
	AurasoftheResolute           = { ID = 385633},
	CrusaderAura                 = { ID = 32223 },
	TurnEvil                     = { ID = 10326 },
	DivineSteed                  = { ID = 190784},
	Rebuke                       = { ID = 96231 },
	AvengingWrath                = { ID = 384376},
	BlessingofSacrifice         =  { ID = 6940, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
	BlessingofProtection         = { ID = 1022, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
	BlessingofSanctuary          = { ID = 210256 },
	BlessingofFreedom            = { ID = 1044  },
	DivineToll                   = { ID = 375576},
	--ProtectionPaladinClassTreePassives
	Obduracy                     = { ID = 385427},
	FistofJustice                = { ID = 234299},
	GreaterJudgment              = { ID = 231663},
	Cavalier                     = { ID = 230332},
	SeasonedWarhorse             = { ID = 376996},
	HolyAegis                    = { ID = 385515},
	Justification                = { ID = 377043},
	Punishment                   = { ID = 403530},
	GoldenPath                   = { ID = 377128},
	SanctifiedPlates             = { ID = 402964},
	UnboundFreedom               = { ID = 305394},
	LightforgedBlessing          = { ID = 403479},
	SealofMercy                  = { ID = 384897},
	Afterimage                   = { ID = 385414},
	SacrificeoftheJust           = { ID = 384820},
	Recompense                   = { ID = 384914},
	UnbreakableSpirit            = { ID = 114154},
	ImprovedBlessingofProtection = { ID = 384909},
	CrusadersReprieve            = { ID = 403042},
	StrengthofConviction         = { ID = 379008},
	JudgmentofLight              = { ID = 183778},
	SealofMight                  = { ID = 385450},
	DivinePurpose                = { ID = 408459},
	SealofAlacrity               = { ID = 385425},
	Incandescence                = { ID = 385464},
	TouchofLight                 = { ID = 385349},
	FaithsArmor                  = { ID = 406101},
	OfDuskandDawn                = { ID = 409441},
	SealoftheCrusader            = { ID = 385728},
	SealofOrder                  = { ID = 385129},
	FadingLight                  = { ID = 109075},
	DivineResonance              = { ID = 355098},
	QuickenedInvocations         = { ID = 379391},
	ZealotsParagon               = { ID = 391142},
	--ProtectionPaladinSpecTreeAbilities
	AvengersShield               = { ID = 31935 },
	HammeroftheRighteous         = { ID = 53595 },
	BlessedHammer                = { ID = 204019},
	ArdentDefender               = { ID = 31850 },
	BlessingofSpellwarding       = { ID = 204018},
	BastionofLight               = { ID = 378974},
	GuardianofAncientKings       = { ID = 86659 },
	GuardianoftheForgottenQueen  = { ID = 228049},  -- PvP talent replacement for Guardian of Ancient Kings
	EyeofTyr                     = { ID = 387174},
	MomentofGlory                = { ID = 327193},
	--ProtectionPaladinSpecTreePassives
	HolyShield                   = { ID = 152261},
	Redoubt                      = { ID = 280373},
	InnerLight                   = { ID = 386568},
	GrandCrusader                = { ID = 85043 },
	ShiningLight                 = { ID = 321136},
	ImprovedHolyShield           = { ID = 393030},
	Sanctuary                    = { ID = 379021},
	InspiringVanguard            = { ID = 393022},
	BarricadeofFaith             = { ID = 385726},
	ConsecrationinFlame          = { ID = 379022},
	ConsecratedGround            = { ID = 204054},
	TirionsDevotion              = { ID = 392928},
	BulwarkofOrder               = { ID = 209389},
	ImprovedArdentDefender       = { ID = 393114},
	LightoftheTitans             = { ID = 378405},
	StrengthinAdversity          = { ID = 393071},
	CrusadersResolve             = { ID = 380188},
	TyrsEnforcer                 = { ID = 378285},
	RelentlessInquisitor         = { ID = 383388},
	AvengingWrathMight           = { ID = 384442},
	Sentinel                     = { ID = 385438},
	SealofClarity                = { ID = 384815},
	FaithintheLight              = { ID = 379043},
	SealofReprisal               = { ID = 377053},
	HandoftheProtector           = { ID = 315924},
	CrusadersJudgment            = { ID = 204023},
	FocusedEnmity                = { ID = 378845},
	SoaringShield                = { ID = 378457},
	GiftoftheGoldenValkyr        = { ID = 378279},
	UthersCounsel                = { ID = 378425},
	SanctifiedWrath              = { ID = 53376 },
	FerrenMarcussFervor          = { ID = 378762},
	ResoluteDefender             = { ID = 385422},
	BulwarkofRighteousFury       = { ID = 386653},
	InmostLight                  = { ID = 405757},
	FinalStand                   = { ID = 204077},
	RighteousProtector           = { ID = 204074},
	--TemplarTalents
	HammerofLight                = { ID = 427453},
	LightsGuidance               = { ID = 427445},
	ZealousVindication           = { ID = 431463},
	ForWhomtheBellTolls          = { ID = 432929},
	ShaketheHeavens              = { ID = 431533},
	WrathfulDescent              = { ID = 431551},
	SacrosanctCrusade            = { ID = 431730},
	HigherCalling                = { ID = 431687},
	BondsofFellowship            = { ID = 432992},
	UnrelentingCharger           = { ID = 432990},
	EndlessWrath                 = { ID = 432615},
	Sanctification               = { ID = 382430},
	Hammerfall                   = { ID = 432463},
	UndisputedRuling             = { ID = 432626},
	LightsDeliverance            = { ID = 425518},
	--LightsmithTalents
	HolyBulwark                  = { ID = 432459},
	SacredWeapon                 = { ID = 432472},
	RiteofSanctification         = { ID = 433568},
	RiteofAdjuration             = { ID = 433583},
	Solidarity                   = { ID = 432802},
	DivineGuidance               = { ID = 433106},
	BlessedAssurance             = { ID = 433015},
	LayingDownArms               = { ID = 432866},
	DivineInspiration            = { ID = 432964},
	Forewarning                  = { ID = 432804},
	FearNoEvil                   = { ID = 432834},
	Excoriation                  = { ID = 433896},
	SharedResolve                = { ID = 432821},
	Valiance                     = { ID = 432919},
	HammerandAnvil               = { ID = 433718},
	BlessingoftheForge           = { ID = 433011},
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function createAction(attributes)
    return Action.Create({
        Type = attributes.Type or "Spell",
        ID = attributes.ID,
        Texture = attributes.Texture,
        FixedTexture = attributes.FixedTexture,
        Color = attributes.Color,
        Desc = attributes.Desc,
        MAKULU_INFO = attributes.MAKULU_INFO,
        Hidden = attributes.Hidden,
        QueueForbidden = attributes.QueueForbidden,
    })
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local A = {}
for name, attributes in pairs(ActionID) do
    A[name] = createAction(attributes)
end
for name, attributes in pairs(ConstSpells) do
    A[name] = createAction(attributes)
end
A = setmetatable(A, { __index = Action })

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local buildMakuluFrameworkSpells = function()
	local result = {}
	for k, v in pairs(A) do
		result[k] = MakSpell:new(v.ID, v.MAKULU_INFO, v)
	end
	return result
end
local M = buildMakuluFrameworkSpells()

Action[ACTION_CONST_PALADIN_PROTECTION] = A
TableToLocal(M, getfenv(1))

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local player        = ConstUnit.player
local target        = ConstUnit.target
local focus         = ConstUnit.focus
local mouseover     = ConstUnit.mouseover
local arena1        = ConstUnit.arena1
local arena2        = ConstUnit.arena2
local arena3        = ConstUnit.arena3
local party1        = ConstUnit.party1
local party2        = ConstUnit.party2
local party3        = ConstUnit.party3
local party4        = ConstUnit.party4
local tank          = ConstUnit.tank
local healer        = ConstUnit.healer
local enemyHealer   = ConstUnit.enemyHealer

local unit

Aware:enable()

local buffs = {
	blessingofDuskBuff          = 385126,
	consecrationBuff            = 188370,
	divinePurposeBuff           = 223819,
	shieldoftheRighteousBuff    = 132403,
	avengingWrathBuff           = 31884,
	holyAvengerBuff             = 105809,
	seraphimBuff                = 152262,
	bulwarkofRighteousFuryBuff  = 386652,
	sanctificationBuff          = 424616,
	sanctificationEmpowerBuff   = 424622,
	shiningLightFreeBuff        = 327510,
	ardentDefenderBuff          = 31850,
	bastionofLightBuff          = 378974,
	guardianofAncientKingsBuff  = 86659,
	momentofGloryBuff           = 327193,
	sentinelBuff                = 389539,
	crusaderAura                = 32223 ,
	devotionAura                = 465,
	holyBulwarkBuff             = 432496,
	sacredWeaponBuff            = 432502,
}

local debuffs = {

}

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = nil,
    imCastingLength = nil,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local interrupts = {
    { spell = Rebuke },
    { spell = HammerofJustice, isCC = true },
	{ spell = BlindingLight, isCC = true, aoe = true, distance = 3 },
	{ spell = AvengersShield,},
	{ spell = DivineToll, isCC = true, aoe = true, distance = 3 }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    player = MakUnit:new("player")
    return player:HasBuff(buffs.barkskin, true) or player:HasBuff(buffs.ironbark, true)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive() 
end

--######################################################################################################################################################################################################

local function getCurrentCastInfo()
    local castingInfo = player.castOrChannelInfo

    if not castingInfo then
        return nil, nil, nil, nil
    end

    return castingInfo.spellId, castingInfo.name, castingInfo.remaining, castingInfo.castLength
end

local lastUpdateTime = 0
local updateDelay = 0.5

-- Funktion zur Aktualisierung des Spielzustands
local function updateGameState()
    local currentTime = GetTime()

    local currentCast, currentCastName, currentCastRemains, currentCastLength = getCurrentCastInfo()
    gameState.imCastingRemaining = currentCastRemains

    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime 
    end
end

--######################################################################################################################################################################################################

local function PlayerHealthIsSafe()
    return player:HasBuff(A.DivineShield.ID) or player:Health() >= 65 or player:Health() >= 45 and player:HasBuff({A.ArdentDefender.ID, A.GuardianofAncientKings.ID})
end

local function CanJudgment()
    return (not target:HasDeBuff(A.Judgment.ID, true) or A.Judgment:GetSpellCharges() >= 2 or A.Judgment:GetSpellChargesFullRechargeTime() <= A.GetCurrentGCD() + 0.25)
end

local function Movementcheck()
    return not GetToggle(2, "Checkbox2") or GetToggle(2, "Checkbox2") and isStaying
end

--######################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Intercession
Intercession:Callback('Utilities', function(spell)
    if not A.MouseHasFrame() then return end
    if not mouseover:IsPlayer() then return end
    if not Unit("mouseover"):IsDead() then return end
    
    return spell:Cast(mouseover)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CrusaderAura
CrusaderAura:Callback('PreCombat', function(spell)
    if A.Zone == "arena" then return end
    if not Player:IsMounted() then return end
    if not AurasofSwiftVengeance:IsKnown() then return end
    if player:HasBuff(A.CrusaderAura.ID) then return end

    return spell:Cast(player)
end)

-- DevotionAura
DevotionAura:Callback('PreCombat', function(spell)
    if A.Zone == "arena" then return end
    if Player:IsMounted() then return end
    if player:HasBuff(A.DevotionAura.ID) then return end

    return spell:Cast(player)
end)

-- RiteofSanctification
RiteofSanctification:Callback('PreCombat', function(spell)
    if not RiteofSanctification:IsKnown() then return end  -- Only cast if Rite of Sanctification talent is selected
    local hasMainHandEnchant, mainHandExpiration, _, _, _, _, _, _ = GetWeaponEnchantInfo()

    if not hasMainHandEnchant or mainHandExpiration <= (1800000 * num(not player.inCombat)) then
        return spell:Cast(player)
    end
end)

-- RiteofAdjuration
RiteofAdjuration:Callback('PreCombat', function(spell)
    if not RiteofAdjuration:IsKnown() then return end  -- Only cast if Rite of Adjuration talent is selected
    local hasMainHandEnchant, mainHandExpiration, _, _, _, _, _, _ = GetWeaponEnchantInfo()

    if not hasMainHandEnchant or mainHandExpiration <= (1800000 * num(not player.inCombat)) then
        return spell:Cast(player)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- LayonHands
LayonHands:Callback('Defensive', function(spell)
    if not player.inCombat then return end

    local protectionThreshold = GetToggle(2, "SelfProtection5")
    if player:HasDeBuff(A.Forbearance.ID) or playerHealth > protectionThreshold then return end

    spell:Cast(player)
end)

-- DivineShield - Emergency defensive cooldown
-- Provides complete immunity to damage for 8 seconds
DivineShield:Callback('Defensive', function(spell)
    -- Check if we have Forbearance (cooldown from other Paladin abilities)
    if player:HasDeBuff(A.Forbearance.ID) then return end

    -- Don't cast if Guardian of Ancient Kings is already active
    if player:HasBuff(A.GuardianofAncientKings.ID) then return end

    -- Use HP threshold from settings (default 40%)
    local protectionThreshold = GetToggle(2, "SelfProtection4") or 40
    if playerHealth > protectionThreshold then return end

    Aware:displayMessage("Divine Shield - Emergency Defense", "Red", 1)
    return spell:Cast(player)
end)

-- AvengingWrath Cooldowns
AvengingWrath:Callback('Defensive', function(spell, need_defensive)
    if not player.inCombat then return end

    local defensiveOptions = A.GetToggle(2, "defensiveSelect") or {}
    if not need_defensive or not defensiveOptions[3] then return end

    spell:Cast(player)
end)

-- Sentinel Cooldowns
Sentinel:Callback('Defensive', function(spell, need_defensive)
    if not Sentinel:IsKnown() then return end  -- Only cast if Sentinel talent is selected
    if not player.inCombat then return end

    local defensiveOptions = A.GetToggle(2, "defensiveSelect") or {}
    if not need_defensive or not defensiveOptions[3] then return end

    spell:Cast(player)
end)

-- GuardianofAncientKings
GuardianofAncientKings:Callback('Defensive', function(spell, need_defensive)
    if not player.inCombat then return end
    if player:HasBuff(A.GuardianofAncientKings.ID) or player:HasBuff(A.GuardianoftheForgottenQueen.ID) then return end

    local defensiveOptions = A.GetToggle(2, "defensiveSelect") or {}
    local protectionThreshold = GetToggle(2, "SelfProtection3") or 50

    if need_defensive and defensiveOptions[2] then
        Aware:displayMessage("Guardian of Ancient Kings - Emergency Defense", "Red", 1)
        return spell:Cast(player)
    end

    if playerHealth <= protectionThreshold then
        Aware:displayMessage("Guardian of Ancient Kings - HP Threshold", "Orange", 1)
        return spell:Cast(player)
    end
end)

-- GuardianoftheForgottenQueen - PvP talent replacement for Guardian of Ancient Kings
-- Provides complete immunity to all damage for 10 seconds (PvP only)
GuardianoftheForgottenQueen:Callback('Defensive', function(spell, need_defensive)
    if not player.inCombat then return end

    local defensiveOptions = A.GetToggle(2, "defensiveSelect") or {}
    local protectionThreshold = GetToggle(2, "SelfProtection3") or 50

    if need_defensive and defensiveOptions[2] then
        Aware:displayMessage("Guardian of the Forgotten Queen - Emergency Defense", "Red", 1)
        return spell:Cast(player)
    end

    if playerHealth <= protectionThreshold then
        Aware:displayMessage("Guardian of the Forgotten Queen - HP Threshold", "Orange", 1)
        return spell:Cast(player)
    end
end)

-- ArdentDefender
ArdentDefender:Callback('Defensive', function(spell, need_defensive)
    if not player.inCombat then return end

    local defensiveOptions = A.GetToggle(2, "defensiveSelect") or {}
    local protectionThreshold = GetToggle(2, "SelfProtection2") or 40

    if need_defensive and defensiveOptions[1] then
        return spell:Cast(player)
    end

    if playerHealth <= protectionThreshold then
        return spell:Cast(player)
    end
end)

-- WordofGlory Defensive - Self-healing when health drops
-- Priority: Only cast when Shining Light is active (Divine Purpose proc)
-- Threshold: 40-50% health (meta recommendation)
WordofGlory:Callback('Defensive', function(spell)
    -- Check if we have Holy Power available (requires 3+ for Word of Glory)
    local holyPower = player.holyPower or 0
    if holyPower < 3 then return end

    -- Check if Shining Light (Divine Purpose) is active - prioritize free casts
    local hasShiningLight = player:HasBuff(A.ShiningLight.ID)
    if not hasShiningLight then return end

    -- Check health threshold (40-50% is meta recommendation)
    local protectionThreshold = GetToggle(2, "SelfProtection1") or 40
    if playerHealth > protectionThreshold then return end

    -- Don't cast if it would drop Shield of the Righteous uptime
    -- Shield of the Righteous provides critical active mitigation
    local sotRRemains = player:BuffRemains(A.ShieldoftheRighteous.ID)
    if sotRRemains <= 0 then return end  -- Only cast if Shield of the Righteous is active

    Aware:displayMessage("Word of Glory - Defensive Healing", "Green", 1)
    spell:Cast(player)
end)

-- WordofGlory Freecast - Use free Word of Glory casts from Divine Purpose/Shining Light
-- These are free casts that don't consume Holy Power, so use them liberally
WordofGlory:Callback('Freecast', function(spell)
    -- Check if we have Shining Light (Divine Purpose) buff active
    -- Shining Light ID: 327510 (Divine Purpose proc)
    local hasShiningLight = Unit("player"):HasBuffs(327510, _, true) > 0 or player:HasBuff(buffs.divinePurposeBuff)
    if not hasShiningLight then return end

    -- Use free casts when below threshold (default 50% - meta recommendation)
    local freecastThreshold = GetToggle(2, "WoGFreePlayer") or 50
    if playerHealth > freecastThreshold then return end

    Aware:displayMessage("Word of Glory - Freecast Healing", "Cyan", 1)
    spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### COOLDOWNS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AvengingWrath Cooldowns
AvengingWrath:Callback('Cooldowns', function(spell)
    if not CDsON() or not inMeleeRange then return end
    spell:Cast(player)
end)

-- Sentinel Cooldowns
Sentinel:Callback('Cooldowns', function(spell)
    if not Sentinel:IsKnown() then return end  -- Only cast if Sentinel talent is selected
    if not CDsON() or not inMeleeRange then return end
    spell:Cast(player)
end)

-- MomentofGlory Cooldowns - Sync with Avenging Wrath for maximum uptime
MomentofGlory:Callback('Cooldowns', function(spell)
    if not MomentofGlory:IsKnown() then return end  -- Only cast if Moment of Glory talent is selected
    if not CDsON() then return end
    -- Only cast if Avenging Wrath is not active or will expire soon
    -- This allows for overlap and better cooldown management
    if player:BuffRemains(A.AvengingWrathBuff.ID) > 5 then return end

    spell:Cast(player)
end)

-- DivineToll Cooldowns - Cast on cooldown when enemies are in range
DivineToll:Callback('Cooldowns', function(spell)
    if not CDsON() then return end
    if not inMeleeRange then return end
    -- Check if we have enemies in range (at least 1 enemy)
    if MultiUnits:GetByRange(40) < 1 then return end

    spell:Cast(target)
end)

-- BastionofLight Cooldowns
BastionofLight:Callback('Cooldowns', function(spell)
    if not BastionofLight:IsKnown() then return end  -- Only cast if Bastion of Light talent is selected
    if not CDsON() then return end
    if not (player:HasBuff(A.AvengingWrathBuff.ID) or AvengingWrath:Cooldown() <= 30) then return end

    spell:Cast(player)
end)

-- Eye of Tyr Cooldowns (Templar Hero Tree)
-- Enables Hammer of Light for 12 seconds after cast
EyeofTyr:Callback('Cooldowns', function(spell)
    if not EyeofTyr:IsKnown() then return end  -- Only cast if Eye of Tyr talent is selected
    if not inMeleeRange then return end

    spell:Cast(player)
end)

-- Hammer of Light Finisher (Templar Hero Tree)
-- Must be cast within 12 seconds of Eye of Tyr or when Hammer of Light Ready buff is active
-- Only usable when Hammer of Light Ready buff is active
HammerofLight:Callback('finishers', function(spell)
    if not HammerofLight:IsKnown() then return end  -- Only cast if Hammer of Light talent is selected
    if not inMeleeRange then return end

    -- Check if Hammer of Light Ready buff is active (enables the spell)
    if not player:HasBuff(A.HammerofLight.ID) then return end

    Aware:displayMessage("Hammer of Light - Templar Finisher", "Yellow", 1)
    return spell:Cast(target)
end)

-- Sacred Weapon Cooldowns (Lightsmith Hero Tree)
-- Maintains buff with pandemic rules - don't refresh inside Avenging Wrath unless buff <= 6s remaining
-- NOTE: Removed CDsON() check - this is a maintenance ability, not a cooldown
SacredWeapon:Callback('Cooldowns', function(spell)
    if not A.SacredWeapon:IsTalentLearned() then return end  -- Only cast if Sacred Weapon talent is selected
    if not inMeleeRange then return end
    if player:HasBuff(buffs.holyBulwarkBuff) then return end

    -- Check if buff is active
    local buffRemains = player:BuffRemains(A.SacredWeapon.ID)

    -- If buff is not active, cast it
    if buffRemains <= 0 then
        Aware:displayMessage("Sacred Weapon - Lightsmith Buff", "Cyan", 1)
        return spell:Cast(player)
    end

    -- If Avenging Wrath is active, only refresh if buff is about to expire (pandemic rule)
    if player:HasBuff(A.AvengingWrathBuff.ID) then
        if buffRemains <= 6 then
            Aware:displayMessage("Sacred Weapon - Pandemic Refresh", "Blue", 1)
            return spell:Cast(player)
        end
        return  -- Don't cast during Avenging Wrath unless pandemic
    end

    -- Outside Avenging Wrath, maintain buff with pandemic (refresh when <= 5s remaining)
    if buffRemains <= 5 then
        Aware:displayMessage("Sacred Weapon - Maintain Buff", "Green", 1)
        return spell:Cast(player)
    end
end)

-- Holy Bulwark Cooldowns (Lightsmith Hero Tree)
-- Cast when you have charges of Holy Armaments (charge-based ability with 2 charges)
-- NOTE: Removed CDsON() check - this is a maintenance ability, not a cooldown
HolyBulwark:Callback('Cooldowns', function(spell)
    if not A.HolyBulwark:IsTalentLearned() then return end  -- Only cast if Holy Bulwark talent is selected
    if player:HasBuff(buffs.sacredWeaponBuff) then return end
    if not inMeleeRange then
        Aware:displayMessage("Holy Bulwark - Not in melee range", "Gray", 1)
        return
    end

    -- Check Holy Armaments charges directly (charge-based ability, not buff stacks)
    -- Holy Armaments has 2 charges with 60s cooldown each (reduced by Forewarning talent)
    local holyArmamentsCharges = A.HolyBulwark:GetSpellCharges() or 0

    Aware:displayMessage("Holy Bulwark - Charges: " .. holyArmamentsCharges, "Yellow", 1)

    if holyArmamentsCharges >= 1 then
        Aware:displayMessage("Holy Bulwark - Casting with " .. holyArmamentsCharges .. " charges", "Orange", 1)
        return spell:Cast(player)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Consecration PreCombat
-- Set up ground effect before combat starts
Consecration:Callback('PreCombat', function(spell)
	if player.inCombat then return end
    if not inMeleeRange or not Movementcheck() then return end

    -- Check if Consecration ground effect is already active on target
    -- ConsecrationDebuff ID (204242) is the ground effect debuff on enemies
    local hasConsecrationDebuff = target:HasDeBuff(A.ConsecrationDebuff.ID, true)

    -- If ground effect is already active, don't recast
    if hasConsecrationDebuff then
        Aware:displayMessage("Consecration - Already Active (PreCombat)", "Gray", 1)
        return
    end

    Aware:displayMessage("Consecration - Setting Up Ground Effect (PreCombat)", "Cyan", 1)
    return spell:Cast(player)
end)

-- AvengersShield PreCombat
AvengersShield:Callback('PreCombat', function(spell)
	if player.inCombat then return end

    spell:Cast(target)
end)

-- Judgment PreCombat
Judgment:Callback('PreCombat', function(spell)
	if player.inCombat then return end
    if not CanJudgment() then return end

    spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ACTIVE MITIGATION & THREAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Shield of the Righteous - Core active mitigation and threat generation
-- Cast on cooldown when Holy Power is available (3-5 charges)
ShieldoftheRighteous:Callback('active_mitigation', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check if we have Holy Power available (minimum 3 charges)
    local holyPower = player.holyPower or 0
    if holyPower < 3 then return end

    -- Check if Divine Purpose proc is active (free cast)
    if not player:HasBuff(A.DivinePurpose.ID) and holyPower < 3 then return end

    Aware:displayMessage("Shield of the Righteous - Active Mitigation", "Blue", 1)
    return spell:Cast(target)
end)

-- Consecration - AoE threat and damage (maintain uptime)
-- Tracks ground effect duration on target and refreshes with pandemic logic
Consecration:Callback('aoe_threat', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check if Consecration ground effect is active on target and has time remaining
    -- ConsecrationDebuff ID (204242) is the ground effect debuff on enemies
    local consecrationRemains = target:DebuffRemains(A.ConsecrationDebuff.ID)

    -- Refresh if ground effect is not active or about to expire (< 3 seconds remaining)
    -- Pandemic refresh: only recast when <= 3 seconds to preserve GCDs
    if consecrationRemains <= 3 then
        Aware:displayMessage("Consecration - Ground Effect Remaining: " .. consecrationRemains .. "s", "Yellow", 1)
        Aware:displayMessage("Consecration - Refreshing AoE Threat", "Green", 1)
        return spell:Cast(player)
    end
end)

-- Judgment - Holy Power generator and threat builder
Judgment:Callback('generators', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Cast on cooldown for Holy Power generation and threat
    Aware:displayMessage("Judgment - Generator", "Cyan", 1)
    return spell:Cast(target)
end)

-- Avenger's Shield - Ranged threat and Grand Crusader proc handler
AvengersShield:Callback('threat', function(spell)
    if not target.exists or not target.canAttack then return end

    -- Priority 1: Cast immediately if Grand Crusader proc is active
    if player:HasBuff(A.GrandCrusader.ID) then
        Aware:displayMessage("Avenger's Shield - Grand Crusader Proc", "Red", 1)
        return spell:Cast(target)
    end
        Aware:displayMessage("Avenger's Shield - Threat", "Orange", 1)
        return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### GENERATOR/UTILITY CALLBACKS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hammer of Wrath - Holy Power generator on cooldown
HammerofWrath:Callback('generators', function(spell)
    if not HammerofWrath:IsKnown() then return end  -- Only cast if Hammer of Wrath talent is selected
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Cast on cooldown for Holy Power generation
    Aware:displayMessage("Hammer of Wrath - Generator", "Yellow", 1)
    return spell:Cast(target)
end)

-- Blessed Hammer - Holy Power generator (Protection spec ability)
BlessedHammer:Callback('generators', function(spell)
    if not BlessedHammer:IsKnown() then return end  -- Only cast if Blessed Hammer talent is selected
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Cast on cooldown for Holy Power generation
    Aware:displayMessage("Blessed Hammer - Generator", "Cyan", 1)
    return spell:Cast(target)
end)

-- Hand of Reckoning - Taunt for tank swaps and threat management
HandofReckoning:Callback('taunt', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Use for tank swaps or when threat is needed
    Aware:displayMessage("Hand of Reckoning - Taunt", "Orange", 1)
    return spell:Cast(target)
end)

-- Cleanse Toxins - Party poison/disease removal
CleanseToxins:Callback('arena_party', function(spell, friendly)
    if friendly:IsMe() then return end
    if friendly.distance > 40 then return end
    if friendly.hp <= 0 then return end

    -- Check if friendly has poison or disease debuffs
    local hasPoisonOrDisease = friendly:HasDeBuffFromFor(MakLists.poison, 100) or
                               friendly:HasDeBuffFromFor(MakLists.disease, 100)

    if not hasPoisonOrDisease then return end

    Aware:displayMessage("Cleanse Toxins - Party", "Green", 1)
    return spell:Cast(friendly)
end)

-- Blessing of Spellwarding - Magic damage protection for party members
BlessingofSpellwarding:Callback('arena_party', function(spell, friendly)
    if friendly:IsMe() then return end
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end  -- Don't cast on other Paladins

    -- Use HP threshold from settings
    local spellwardThreshold = A.GetToggle(2, "SpellwardHPParty") or 50
    if friendly.hp > spellwardThreshold then return end

    Aware:displayMessage("Blessing of Spellwarding - Party", "Purple", 1)
    return spell:Cast(friendly)
end)

-- Lay on Hands - Party healing (in addition to self-healing)
LayonHandsPassive:Callback('arena_party', function(spell, friendly)
    if friendly:IsMe() then return end
    if friendly.hp <= 0 then return end
    if friendly:IsTotalImmune() then return end

    -- Use HP threshold from settings
    local lohThreshold = A.GetToggle(2, "LayonHandsHPParty") or 30
    if friendly.hp > lohThreshold then return end

    -- Priority: Healers > Casters > Other teammates
    if friendly.isHealer or friendly.isCaster then
        Aware:displayMessage("Lay on Hands - Party Healing", "Green", 1)
        return spell:Cast(friendly)
    end

    -- Only cast on other teammates if they're very low
    if friendly.hp < 20 then
        Aware:displayMessage("Lay on Hands - Emergency Healing", "Red", 1)
        return spell:Cast(friendly)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### HIGH PRIORITY PvE ABILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Crusader Strike - Single-target Holy Power generator
CrusaderStrike:Callback('single_target_generator', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check enemy count - only use for 1-2 enemies
    local enemyCount = MultiUnits:GetByRange(8)
    if enemyCount > 2 then return end  -- Use Hammer of the Righteous for AoE instead

    -- Cast on cooldown for Holy Power generation
    Aware:displayMessage("Crusader Strike - Single Target", "Cyan", 1)
    return spell:Cast(target)
end)

-- Hammer of the Righteous - AoE Holy Power generator (3+ enemies)
HammeroftheRighteous:Callback('aoe_generator', function(spell)
    if not HammeroftheRighteous:IsKnown() then return end  -- Only cast if Hammer of the Righteous talent is selected
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check enemy count - only use for 3+ enemies
    local enemyCount = MultiUnits:GetByRange(8)
    if enemyCount < 3 then return end  -- Use Crusader Strike for single target

    -- Cast on cooldown for AoE Holy Power generation
    Aware:displayMessage("Hammer of the Righteous - AoE Generator", "Yellow", 1)
    return spell:Cast(target)
end)

-- Word of Glory - Combat Holy Power Spender
-- Use Holy Power for healing when Shield of the Righteous is not needed
-- Priority: Shield of the Righteous > Word of Glory for Holy Power allocation
WordofGlory:Callback('combat_spender', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check if we have Holy Power available (requires 3+ for Word of Glory)
    local holyPower = player.holyPower or 0
    if holyPower < 3 then return end

    -- CRITICAL: Check if Shining Light is active - prioritize free casts
    -- If Shining Light is active, this is a free cast and should be used
    local hasShiningLight = player:HasBuff(A.ShiningLight.ID)

    -- Check health threshold (40-50% is meta recommendation, not 60%)
    local wogThreshold = A.GetToggle(2, "WogHP") or 50

    -- If Shining Light is active, use it regardless of health (damage gain for Templar)
    if hasShiningLight then
        if player.hp <= 100 then  -- Use free cast if not at full health
            Aware:displayMessage("Word of Glory - Shining Light Proc", "Yellow", 1)
            return spell:Cast(player)
        end
    end

    -- Without Shining Light, only use if below threshold
    if player.hp > wogThreshold then return end

    -- Don't cast if it would drop Shield of the Righteous uptime
    local sotRRemains = player:BuffRemains(A.ShieldoftheRighteous.ID)
    if sotRRemains <= 0 then return end  -- Only cast if Shield of the Righteous is active

    -- Cast for self-healing during combat
    Aware:displayMessage("Word of Glory - Combat Healing", "Green", 1)
    return spell:Cast(player)
end)

-- Divine Protection - Magic damage reduction cooldown
DivineProtection:Callback('magic_defense', function(spell)
    if not inMeleeRange then return end
    if not target.exists or not target.canAttack then return end

    -- Check if we already have Divine Shield active
    if player:HasBuff(A.DivineShield.ID) then return end

    -- Check if we have Forbearance (cooldown from other Paladin abilities)
    if player:HasDeBuff(A.Forbearance.ID) then return end

    -- Cast when taking magic damage or HP is low
    local magicDefenseThreshold = A.GetToggle(2, "SelfProtection1") or 50
    if player.hp > magicDefenseThreshold then return end

    Aware:displayMessage("Divine Protection - Magic Defense", "Purple", 1)
    return spell:Cast(player)
end)

--################################################################################################################################################################################################################

local function Untilities()
	Intercession('Utilities')
end

local function PreCombat()
	CrusaderAura('PreCombat')
	DevotionAura('PreCombat')
	RiteofSanctification('PreCombat')
	RiteofAdjuration('PreCombat')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SelfDefensive()
	needDefensive = shouldDefensive()
	LayonHands('Defensive')
	DivineShield('Defensive')
	AvengingWrath('Defensive', needDefensive)
	Sentinel('Defensive', needDefensive)
	GuardianofAncientKings('Defensive', needDefensive)
	GuardianoftheForgottenQueen('Defensive', needDefensive)  -- PvP talent replacement
	ArdentDefender('Defensive', needDefensive)
	WordofGlory('Defensive')
	WordofGlory('Freecast')

	-- Utility abilities
	HandofReckoning('taunt')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
	-- CRITICAL PRIORITY: Active Mitigation & Threat
	ShieldoftheRighteous('active_mitigation')
	Consecration('aoe_threat')
	Judgment('generators')
	AvengersShield('threat')

	-- COOLDOWNS
	AvengingWrath('Cooldowns')
	Sentinel('Cooldowns')
	MomentofGlory('Cooldowns')
	DivineToll('Cooldowns')
	BastionofLight('Cooldowns')
	DivineProtection('magic_defense')

	-- Templar Hero Tree Cooldowns
	-- Use IsTalentLearned() instead of IsPlayerSpell() for accurate hero tree detection
		EyeofTyr('Cooldowns')

	-- Lightsmith Hero Tree Cooldowns
	-- Use IsTalentLearned() instead of IsPlayerSpell() for accurate hero tree detection
		SacredWeapon('Cooldowns')
		HolyBulwark('Cooldowns')

	-- HIGH PRIORITY: Holy Power Generators (Single Target vs AoE)
	CrusaderStrike('single_target_generator')
	HammeroftheRighteous('aoe_generator')
	HammerofWrath('generators')
	BlessedHammer('generators')

	-- MEDIUM PRIORITY: Holy Power Spenders
	WordofGlory('combat_spender')

	-- Finishers (Templar only)
		HammerofLight('finishers')
end

--################################################################################################################################################################################################################

A[1] = function(icon)
    --AntiFakeCC - Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
	if A.AntiFakeCC:GetCooldown() == 0 then return A.AntiFakeCC:Show(icon) end
end

A[2] = function(icon)
	local castLeft, _, _, _, notKickAble = Unit("target"):IsCastingRemains()
	if castLeft == 0 then return end

    --AntiFakeKick --Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
    if A.AntiFakeKick:GetCooldown() == 0 and not notKickAble then return A.AntiFakeKick:Show(icon) end
end

--################################################################################################################################################################################################################

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()
    SetUpHealers()

	local CantCast = CantCast()
	if CantCast then return end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= player.combatTime
	playerHealth	= player.hp
	inMeleeRange	= target:Distance() <= 5

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    makInterrupt(interrupts)

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--Utilities
    Untilities()

     --PreCombat/Defensives
    if not player.inCombat then
        PreCombat()
    else
        SelfDefensive()
    end

    --Damage Rotation PVE
    if target.exists and target.canAttack then
        DamageRotationPve()
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY UTILITY CALLBACKS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Blessing of Sanctuary - Proactive CC protection for party members
-- IMPROVED: Reduced delay from 500ms to 100ms for faster reaction to stuns
-- This ensures the buff is applied DURING the stun, not after it expires
BlessingofSanctuary:Callback("arena_party", function(spell, friendly)
    if friendly:IsMe() then return end

    -- PRIORITY 1: Healers (highest priority for CC protection)
    if friendly.isHealer then
        -- Reduced from 500ms to 100ms to catch stuns immediately
        if friendly:HasDeBuffFromFor(MakLists.sanc, 100) then
            Aware:displayMessage("Blessing of Sanctuary - Healer CC", "Yellow", 1)
            return spell:Cast(friendly)
        end
    end

    -- PRIORITY 2: Casters/Ranged DPS (second priority - vulnerable to CC)
    if friendly.isCaster then
        if friendly:HasDeBuffFromFor(MakLists.sanc, 100) then
            Aware:displayMessage("Blessing of Sanctuary - Caster CC", "Cyan", 1)
            return spell:Cast(friendly)
        end
    end

    -- PRIORITY 3: Other teammates (lower priority)
    -- Only cast if they have a stun that's been active for at least 100ms
    if friendly:HasDeBuffFromFor(MakLists.sanc, 100) then
        Aware:displayMessage("Blessing of Sanctuary - Teammate CC", "Orange", 1)
        return spell:Cast(friendly)
    end
end)

-- Blessing of Protection - Arena party protection against physical damage
-- Protects low-health party members from physical damage and harmful effects
BlessingofProtection:Callback("arena_party", function(spell, friendly)
    if friendly:IsMe() then return end

    -- Don't cast if friendly has Forbearance (cooldown from other Paladin abilities)
    if friendly:HasDeBuff(A.Forbearance.ID) then return end

    -- Don't cast if friendly is immune
    if friendly:IsTotalImmune() then return end

    -- Don't cast on other Paladins (they have their own immunities)
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end

    -- Use HP threshold from settings (default 40%)
    local bopThreshold = A.GetToggle(2, "BopHPParty") or 40
    if friendly.hp > bopThreshold then return end

    Aware:displayMessage("Blessing of Protection - Party", "Green", 1)
    return spell:Cast(friendly)
end)

-- Blessing of Freedom - Automatic root/beam removal for party members
-- Priority: Healers > Casters/Ranged DPS > Other teammates (melee/tanks)
-- Detects root and beam effects using MakLists.freedom and friendly.rooted
BlessingofFreedom:Callback("arena_party", function(spell, friendly)
    -- Don't cast on self (separate logic can handle self-freedom if needed)
    if friendly:IsMe() then return end

    -- Don't waste Freedom if we're about to kill target
    if target.exists and target.hp < 10 then return end

    -- Check if friendly is in range
    if friendly.distance > 40 then return end

    -- Don't cast on dead or immune targets
    if friendly.hp <= 0 then return end
    if friendly:IsTotalImmune() then return end

    -- Check if friendly is affected by root or beam effects
    -- Using both friendly.rooted property and MakLists.freedom for comprehensive detection
    local hasRootDebuff = friendly.rooted or friendly:HasDeBuffFromFor(MakLists.freedom, 500)

    if not hasRootDebuff then return end

    -- PRIORITY 1: Healers (highest priority)
    -- Cast Freedom on healers immediately when they are rooted/beamed (500ms minimum)
    if friendly.isHealer then
        Aware:displayMessage("Freedom - Healer Rooted", "Green", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY 2: Casters/Ranged DPS (second priority)
    -- Casters are more vulnerable to roots/beams than melee since they rely on positioning and casting
    -- Cast Freedom on casters with same urgency as healers (500ms minimum)
    if friendly.isCaster then
        Aware:displayMessage("Freedom - Caster Rooted", "Cyan", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY 3: Other teammates - melee/tanks (third priority)
    -- Only cast if the debuff has been active for at least 700ms to avoid wasting on instant dispels
    -- and if the friendly is in danger (hp < 70) or if we have Unbound Freedom talent
    if friendly:HasDeBuffFromFor(MakLists.freedom, 700) then
        -- Cast on low HP teammates
        if friendly.hp < 70 then
            Aware:displayMessage("Freedom - Teammate Low HP", "Yellow", 1)
            return spell:Cast(friendly)
        end

        -- Cast on any teammate if we have Unbound Freedom talent (multiple charges)
        if IsPlayerSpell(A.UnboundFreedom.ID) then
            Aware:displayMessage("Freedom - Teammate Rooted", "Blue", 1)
            return spell:Cast(friendly)
        end
    end
end)

-- Word of Glory - Party Healing (Arena Party Callback)
-- Use extra Shining Light procs on party members to maximize benefits
-- Priority: Injured players > Healers > Tanks
WordofGlory:Callback("arena_party", function(spell, friendly)
    if friendly:IsMe() then return end
    if friendly.hp <= 0 then return end
    if friendly.distance > 40 then return end

    -- Check if we have Shining Light (Divine Purpose) buff active
    -- Only use party healing when we have free procs available
    local hasShiningLight = player:HasBuff(A.ShiningLight.ID)
    if not hasShiningLight then return end

    -- Use HP threshold from settings (default 50%)
    local partyWogThreshold = A.GetToggle(2, "PartyWoGHP") or 50
    if friendly.hp > partyWogThreshold then return end

    -- PRIORITY 1: Injured players (below 50% health)
    if friendly.hp < 50 then
        Aware:displayMessage("Word of Glory - Party Healing", "Yellow", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY 2: Healers (second priority)
    if friendly.isHealer then
        Aware:displayMessage("Word of Glory - Healer Healing", "Cyan", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY 3: Tanks (third priority)
    if friendly.isTank then
        Aware:displayMessage("Word of Glory - Tank Healing", "Green", 1)
        return spell:Cast(friendly)
    end

    -- PRIORITY 4: Other teammates
    Aware:displayMessage("Word of Glory - Party Healing", "Blue", 1)
    return spell:Cast(friendly)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
	if not enemy.exists then return end
	if enemy.hp <= 0 then return end
	if not inMeleeRange then return end

	-- Interrupt logic for arena
	-- Rebuke - Off-GCD interrupt
	if enemy:IsCasting() then
		if Rebuke:IsReady() then
			Aware:displayMessage("Rebuke - Interrupt", "Red", 1)
			return Rebuke:Cast(enemy)
		end
	end

	-- Hammer of Justice - Stun/CC on cooldown
	if HammerofJustice:IsReady() then
		if not enemy:HasDeBuff(A.Forbearance.ID) then
			Aware:displayMessage("Hammer of Justice - CC", "Yellow", 1)
			return HammerofJustice:Cast(enemy)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    if not friendly.exists then return end

    -- Party utility callbacks
    local partySize = GetNumGroupMembers()
    if partySize > 5 then return end
    if friendly.hp <= 0 then return end
    if friendly:IsDeadOrGhost() then return end

    -- Call party utility callbacks
    BlessingofSanctuary("arena_party", friendly)
    BlessingofProtection("arena_party", friendly)
    BlessingofFreedom("arena_party", friendly)
end

--################################################################################################################################################################################################################

A[6] = function(icon)
	RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end

    partyRotation(party1)
	enemyRotation(arena1)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[7] = function(icon)
	RegisterIcon(icon)
    partyRotation(party2)
	enemyRotation(arena2)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	RegisterIcon(icon)
    partyRotation(party3)
	enemyRotation(arena3)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[9] = function(icon)
	RegisterIcon(icon)
	partyRotation(party4)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[10] = function(icon)
	RegisterIcon(icon)
	partyRotation(player)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################
-- NOTES
--################################################################################################################################################################################################################
-- [1] is AntiFake CC rotation (limited, usually is single color like 0x00FF00 which is green)
-- [2] is AntiFake Kick rotation (racial, primary specialization interrupt spell)
-- [3] is Rotation (old launcher called it Single, supports all actions)
-- [4] is Secondary (old launcher called it AoE) rotation (supports all actions)
-- [5] is Trinket rotation (racial, specialization's spells which can remove CC)
-- [6] is Passive rotation (limited actions, usually @raid1, @party1, @arena1 and additional binds - for more info look notes in the launcher)
-- [7] is Passive rotation (limited actions, usually @raid2, @party2, @arena2)
-- [8] is Passive rotation (limited actions, usually @raid3, @party3, @arena3)
--Passive rotation doesn't require START button use like it does [1] -> [5] rotations
