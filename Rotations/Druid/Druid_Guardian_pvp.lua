if not Makulu_magic_number == 2347956243324 then
	return true
end

if GetSpecializationInfo(GetSpecialization()) ~= 104 then
	return
end

local FrameworkStart = MakuluFramework.start
local FrameworkEnd = MakuluFramework.endFunc
local RegisterIcon = MakuluFramework.registerIcon

local MakUnit = MakuluFramework.Unit
local TableToLocal = MakuluFramework.tableToLocal
local MakGcd = MakuluFramework.gcd
local Debounce = MakuluFramework.debounceSpell
local ConstUnit = MakuluFramework.ConstUnits
local cacheContext = MakuluFramework.Cache

local Aware = MakuluFramework.Aware

local Action = _G.Action
local ActionUnit = Action.Unit
local Player = Action.Player
local MultiUnits = Action.MultiUnits
local AuraIsValid = Action.AuraIsValid

local MakuluFunctions = MakuluFramework.OLD
local EnemiesInSpellRange = MakuluFunctions.EnemiesInSpellRange

local BossMods = Action.BossMods

local _G, setmetatable = _G, setmetatable

local ActionID = {
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
	EntanglingRoots = { ID = 339 },
	FerociousBite = { ID = 22568 },
	FrenziedRegeneration = { ID = 22842 },
	Growl = { ID = 6795 },
	HeartoftheWild = { ID = 319454 },
	IncapacitatingRoar = { ID = 99 },
	Ironfur = { ID = 192081 },
	Mangle = { ID = 33917 },
	Moonfire = { ID = 8921 },
	Prowl = { ID = 5215 },
	Rebirth = { ID = 20484 },
	Regrowth = { ID = 8936 },
	Rejuvenation = { ID = 774 },
	RemoveCorruption = { ID = 2782 },
	Renewal = { ID = 108238 },
	Revive = { ID = 50769 },
	Shred = { ID = 5221 },
	SkullBash = { ID = 106839 },
	Soothe = { ID = 2908 },
	StampedingRoar = { ID = 106898 },
	Swipe = { ID = 213764 },
	Thrash = { ID = 77758 },
	TravelForm = { ID = 783 },
	Typhoon = { ID = 132469 },
	UrsolsVortex = { ID = 102793 },
	WildCharge = { ID = 102401 },
	Wrath = { ID = 5176 },
	Hibernate = { ID = 2637 },
	MarkoftheWild = { ID = 1126 },

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
	if val then
		return 1
	else
		return 0
	end
end

HeartoftheWild:Callback(function(spell)
	if not MakuluFramework.burstMode then
		return
	end

	if not player:Buff(buffs.form_cat) or ConvoketheSpirits.cd > 1000 then
		return
	end

	return spell:Cast()
end)

Rake:Callback("feline", function(spell)
	if player:HasBuffCount(buffs.feline_potential_counter) < 6 then
		return
	end

	if ConvoketheSpirits.cd < 10000 or Mangle.cd > 2000 then
		return
	end

	return spell:Cast(target)
end)

Rake:Callback(function(spell)
	return spell:Cast(target)
end)

FerociousBite:Callback(function(spell)
	if not player:Buff(buffs.form_cat) then
		return
	end

	if player.cp < 4 or target.stun then
		return
	end

	return spell:Cast(target)
end)

Rip:Callback(function(spell)
	if not player:Buff(buffs.form_cat) then
		return
	end

	if player.cp < 4 then
		return
	end

	return spell:Cast(target)
end)

Rip:Callback("feline", function(spell)
	if not player:Buff(buffs.feline_potential) then
		return
	end

	if not player:Buff(buffs.form_cat) then
		return
	end

	return spell:Cast()
end)

CatForm:Callback(function(spell)
	if player:Buff(buffs.form_cat) then
		return
	end

	if Rake() then
		return
	end

	return spell:Cast(player)
end)

ConvoketheSpirits:Callback("burst", function(spell)
	if not MakuluFramework.burstMode then
		return
	end

	if not player:Buff(buffs.form_cat) then
		return CatForm()
	end

	return spell:Cast()
end)

RageoftheSleeper:Callback(function(spell)
	-- Recently bursted
	if ConvoketheSpirits.cd < 40000 then
		return
	end

	if target.distance > 10 then
		return
	end

	return spell:Cast(player)
end)

Moonfire:Callback("proc", function(spell)
	if not player:Buff(buffs.galactic_guardian) then
		return
	end

	return spell:Cast(target)
end)

Mangle:Callback(function(spell)
	return spell:Cast(target)
end)

Mangle:Callback("mangle_capped", function(spell)
	if not player:Buff(buffs.feline_potential_counter) then
		return spell:Cast(target)
	end

	if
		player:BuffRemains(buffs.feline_potential_counter) < 2000
		or player:HasBuffCount(buffs.feline_potential_counter) < 6
	then
		return spell:Cast(target)
	end
end)

Mangle:Callback("proc", function(spell)
	if not player:Buff(buffs.gore) then
		return
	end

	return spell:Cast(target)
end)

Thrash:Callback("dot", function(spell)
	if target.distance > 8 then
		return
	end

	return spell:Cast(target)
end)

Maul:Callback("spammer", function(spell)
	return spell:Cast(target)
end)

A[3] = function(icon)
	FrameworkStart(icon)
	if not target.exists then
		return
	end

	HeartoftheWild()
	Rake("feline")
	Rip("feline")
	FerociousBite()
	Rip()

	ConvoketheSpirits("burst")

	if not player:Buff(buffs.form_bear) then
		Mangle()

		return FrameworkEnd()
	end

	RageoftheSleeper()
	Mangle("mangle_capped")
	Maul("spammer")
	Mangle("proc")
	Moonfire("proc")
	Thrash("dot")
	Mangle()
	return FrameworkEnd()
end

local enemyRotation = function(enemy)
	if not enemy.exists then
		return
	end
end

local partyRotation = function(friendly)
	if not friendly.exists then
		return
	end
end

A[6] = function(icon)
	FrameworkStart(icon)
	return FrameworkEnd()
end

A[7] = function(icon)
	FrameworkStart(icon)
	return FrameworkEnd()
end

A[8] = function(icon)
	FrameworkStart(icon)
	return FrameworkEnd()
end

A[9] = function(icon)
	FrameworkStart(icon)

	return FrameworkEnd()
end

A[10] = function(icon)
	FrameworkStart(icon)

	return FrameworkEnd()
end
