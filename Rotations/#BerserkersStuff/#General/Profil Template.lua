local TMW 					  			= _G.TMW
local Action 			      			= _G.Action
local GetSpellTexture 		  			= _G.TMW.GetSpellTexture

local Unit                              = Action.Unit
local Create                            = Action.Create
local Player                      		= Action.Player
local BurstIsON                         = Action.BurstIsON
local GetToggle				  			= Action.GetToggle
local MultiUnits                        = Action.MultiUnits
local AuraIsValid                       = Action.AuraIsValid
local IsUnitEnemy                       = Action.IsUnitEnemy
local LoC                               = Action.LossOfControl
local GetCurrentGCD                     = Action.GetCurrentGCD
local IsUnitFriendly                    = Action.IsUnitFriendly
local InterruptIsValid                  = Action.InterruptIsValid
local ACTION_CONST_STOPCAST   			= Action.Const.STOPCAST
local ACTION_CONST_AUTOTARGET 			= Action.Const.AUTOTARGET
local ACTION_CONST_SHAMAN_ELEMENTAL     = Action.Const.SHAMAN_ELEMENTAL
local Utils								= Action.Utils
local ActiveUnitPlates        			= MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop =
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop

-- Ensure debugprofilestop exists on Classic/MoP
if type(debugprofilestop) ~= "function" then
    local gtp = _G.GetTimePreciseSec
    if type(gtp) == "function" then
        debugprofilestop = function() return gtp() * 1000 end
    else
        debugprofilestop = function() return _G.GetTime() * 1000 end
    end
end


Action[ACTION_CONST_SHAMAN_ELEMENTAL] = {
    --Alliance Racials
	EveryManforHimself                    = Create({ Type = "Spell", ID = 59752     }),
	Stoneform                             = Create({ Type = "Spell", ID = 20594    	}),
	Shadowmeld                            = Create({ Type = "Spell", ID = 58984     }),
	EscapeArtist                          = Create({ Type = "Spell", ID = 20589     }),
	GiftofNaaru                           = Create({ Type = "Spell", ID = 59542     }),
	Darkflight                            = Create({ Type = "Spell", ID = 68992		}),
	QuakingPalm                           = Create({ Type = "Spell", ID = 107079    }),
	SpatialRift                           = Create({ Type = "Spell", ID = 256948    }),
	LightsJudgment                        = Create({ Type = "Spell", ID = 255647	}),
	Fireblood                             = Create({ Type = "Spell", ID = 265221	}),
	Haymaker                              = Create({ Type = "Spell", ID = 287712    }),
	HyperOrganicLightOriginator           = Create({ Type = "Spell", ID = 312924    }),
	--Horde Racials
	BloodFury                             = Create({ Type = "Spell", ID = 33697		}),
	WilloftheForsaken                     = Create({ Type = "Spell", ID = 7744      }),
	Canibalize                     		  = Create({ Type = "Spell", ID = 20577     }),
	WarStomp                              = Create({ Type = "Spell", ID = 20549     }),
	Berserking                            = Create({ Type = "Spell", ID = 26297		}),
	ArcaneTorrent                         = Create({ Type = "Spell", ID = 28730		}),
	PackHobGoblin                         = Create({ Type = "Spell", ID = 69046		}),
	RocketBarrage                         = Create({ Type = "Spell", ID = 69041		}),
	RocketJump                         	  = Create({ Type = "Spell", ID = 69070		}),
	ArcanePulse                           = Create({ Type = "Spell", ID = 260364	}),
	Cantrips                         	  = Create({ Type = "Spell", ID = 255661	}),
	BullRush                              = Create({ Type = "Spell", ID = 255654    }),
	AncestralCall                         = Create({ Type = "Spell", ID = 274738	}),
	EmbraceoftheLoa                       = Create({ Type = "Spell", ID = 292752	}),
	PterrordaxSwoop                       = Create({ Type = "Spell", ID = 281954	}),
	Regeneratin                           = Create({ Type = "Spell", ID = 291944	}),
    BagofTricks                           = Create({ Type = "Spell", ID = 312411    }),
    MakeCamp                              = Create({ Type = "Spell", ID = 312370    }),
	ReturntoCamp                          = Create({ Type = "Spell", ID = 312372    }),
	RummageyourBag                        = Create({ Type = "Spell", ID = 312425    }),
    --Misc
    TargetEnemy                           = Create({ Type = "Spell", ID = 44603		}),
    StopCast                              = Create({ Type = "Spell", ID = 61721		}),
    PoolResource                          = Create({ Type = "Spell", ID = 209274	}),
	DelayIcon                    		  = Create({ Type = "Spell", ID = 20579     }),
	FocusParty1                    		  = Create({ Type = "Spell", ID = 134314, 	Hidden = true 	}),
	FocusParty2                    		  = Create({ Type = "Spell", ID = 134316, 	Hidden = true   }),
	FocusParty3                    		  = Create({ Type = "Spell", ID = 134318, 	Hidden = true   }),
	FocusParty4                    		  = Create({ Type = "Spell", ID = 134320, 	Hidden = true   }),
	FocusPlayer                    		  = Create({ Type = "Spell", ID = 134310, 	Hidden = true   }),
    --Mythic Plus
    Quake                                 = Create({ Type = "Spell", ID = 240447  	}),
    Burst                                 = Create({ Type = "Spell", ID = 240443	}),
    GrievousWound                         = Create({ Type = "Spell", ID = 240559	}),
    Necrotic                              = Create({ Type = "Spell", ID = 209858	}),
	--AntiFakeStuff
	--AntiFakeKick                        = Create({ Type = "SpellSingleColor", ID = 96231,  Hidden = true,		Color = "GREEN"	, Desc = "[2] AntiFakeKick",    QueueForbidden = true	}),
	--AntiFakeCC						  = Create({ Type = "SpellSingleColor", ID = 853,  	 Hidden = true,		Color = "GREEN"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	}),


} if NoInterfaceAvialable() or NoGlobalsAvialable() then return true end

--#####################################################################################################################################################################################

local A 									= setmetatable(Action[ACTION_CONST_SHAMAN_ELEMENTAL], { __index = Action })

local mouseover	 							= "mouseover"
local focus		 							= "focus"
local target	 							= "target"
local player	 							= "player"

local Temp                                  = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
	TotalAndMagAndCCAndStun                 = {"TotalImun", "DamageMagicImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked                    = {},
	BerserkerRageLoC                        = {"FEAR", "INCAPACITATE"},
}

--################################################################################################################################################################################################################

local function RotationsVariables()
    --Default Variables
	isMoving 						= Player:IsMoving()
	isStaying   					= Player:IsStaying()
	combatTime  					= Unit(player):CombatTime()
	inCombat						= combatTime > 0
	noCombat						= combatTime == 0
	movingTime  					= Player:IsMovingTime()
	stayingTime						= Player:IsStayingTime()
	PlayerHealth					= Unit(player):HealthPercent()

	--IsInMeleeRange     			= Unit(target):GetRange() < 5 A.Stormstrike:IsSpellInRange("target")
	--IsInCasterRange     			= A.Stormstrike:IsSpellInRange("target")
end

--#####################################################################################################################################################################################

local function Interrupts(unitID)
	if A.Zone == "arena" then return false end

	if A.InstanceInfo.KeyStone > 1 then
		useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "BerserkerS3Interrupts", true, true)
	else
		useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "BerserkerPvpInterrupts", true, true)
	end

    if castRemainsTime == 0 then return false end

	--if useKick and not notInterruptable and A.MindFreeze:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(Kick_Immune_Buffs) and A.MindFreeze:AbsentImun(unitID, Temp.TotalAndMagKick, true) then return A.MindFreeze end

	if useRacial and A.QuakingPalm:AutoRacial(unitID) then return A.QuakingPalm end

	if useRacial and A.Haymaker:AutoRacial(unitID) then return A.Haymaker end

	if useRacial and A.WarStomp:AutoRacial(unitID) then return A.WarStomp end

	if useRacial and A.BullRush:AutoRacial(unitID) then return A.BullRush end

	--if useCC and A.Asphyxiate:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) and Unit(unitID):GetDR("stun") >= 50 and Unit(unitID):IsControlAble("stun") and Unit(unitID):IsBuffDown(Phys_Immune_Buffs) and A.Asphyxiate:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then return A.Asphyxiate end
end

--#####################################################################################################################################################################################

local function UseItems()
	if Unit(player):CombatTime() == 0 then return false end

	-- Blood Fury
	if A.BloodFury:IsReadyByPassCastGCD() then return A.BloodFury end

	-- Berserking
	if A.Berserking:IsReadyByPassCastGCD() then return A.Berserking end

	-- Fireblood
	if A.Fireblood:IsReadyByPassCastGCD() then return A.Fireblood end

	-- Ancestral Call
	if A.AncestralCall:IsReadyByPassCastGCD() then return A.AncestralCall end

	-- Bag of Tricks
	if A.BagofTricks:IsReadyByPassCastGCD() then return A.BagofTricks end

	-- LightsJudgment
	if A.LightsJudgment:IsReadyByPassCastGCD() then return A.LightsJudgment end

	if (Action.Zone == "arena" or Action.Zone == "pvp") then return false end

	--Trinket1
	if A.Trinket1:IsReadyByPassCastGCD() and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] then return A.Trinket1 end

	--Trinket2
	if A.Trinket2:IsReadyByPassCastGCD() and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] then return A.Trinket2 end
end

--################################################################################################################################################################################################################



--################################################################################################################################################################################################################

A[1] = function(icon)
	--if A.AntiFakeCC:GetCooldown() == 0 then return A.AntiFakeCC:Show(icon) end
end

A[2] = function(icon)
	local castLeft, _, _, _, notKickAble = Unit(target):IsCastingRemains()
	if castLeft > 0 then
		--AntiFakeKick
		--if A.AntiFakeKick:IsReadyByPassCastGCD(target) and not notKickAble then return A.AntiFakeKick:Show(icon) end

		--QuakingPalm
		if A.QuakingPalm:IsRacialReadyP(target, nil, nil, true) then return A.QuakingPalm:Show(icon) end

		--Haymaker
		if A.Haymaker:IsRacialReadyP(target, nil, nil, true) then return A.Haymaker:Show(icon) end

		--WarStomp
		if A.WarStomp:IsRacialReadyP(target, nil, nil, true) then return A.WarStomp:Show(icon) end

		--BullRush
		if A.BullRush:IsRacialReadyP(target, nil, nil, true) then return A.BullRush:Show(icon) end
	end
end

--#####################################################################################################################################################################################

A[3] = function(icon)
	RotationsVariables()

	local CantCast = CantCast()
	if CantCast then return false end

	if combatTime == 0 then

	else
		--WordofGlory
		--if A.WordofGlory:IsReadyByPassCastGCD() and PlayerHealth <= GetToggle(2, "SelfProtection1") then return A.WordofGlory:Show(icon) end

	end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local function APL()

		--AOE Check
		--if AoEON() then AoEUnits = MultiUnits:GetByRange(10) else AoEUnits = 1 end

	end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local function DamageRotation(unitID)
		local CantDamage = CantDamage()
		if CantDamage then return false end

		--Use Items & Racials and Unit(player):IsBuffUp(A.AvengingWrathBuff.ID)
		local UseItems = UseItems()
		if UseItems and CDsON() then return UseItems:Show(icon) end

		--Interrupts
		local Interrupt = Interrupts(unitID)
		if Interrupt then return Interrupt:Show(icon) end

		if APL() then
			return true
		end
	end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--Healing Rotation
	--if A.IsUnitFriendly(target) then unitID = target if HealingRotation(unitID) then return true end elseif A.IsUnitFriendly(focus) then unitID = focus if HealingRotation(unitID) then return true end end

	--Damage Rotation
	if A.IsUnitEnemy(target) then unitID = target if DamageRotation(unitID) then return true end end
end

--################################################################################################################################################################################################################

local function PartyRotation(icon, unitID)
	if CantUsePartyRotationPassiv(unitID) then return false end

	--WordofGlory
	--if A.WordofGlory:IsReadyByPassCastGCD(unitID) and Unit(unitID):HealthPercent() <= GetToggle(2, "WogArena") then return A.WordofGlory:Show(icon) end
end

--################################################################################################################################################################################################################

local function ArenaRotation(icon, unitID)
	if CantUseArenaRotationPassiv(unitID) then return false end

    --Stun 1
	--if A.Asphyxiate:IsReadyByPassCastGCD(unitID) and CCHealerInArenaDps(unitID, 45, 0.5, "stun", true, true) then return A.Asphyxiate:Show(icon) end

	--Interrupt Kick
	--if A.MindFreeze:IsReadyByPassCastGCD(unitID) and CanKickArenaPhysical(unitID) then return A.MindFreeze:Show(icon) end
end

--################################################################################################################################################################################################################

--################################################################################################################################################################################################################

A[6] = function(icon)
    --Stopcast Function from Globals
    if NeedStopCast() then
		return A.StopCast:Show(icon)
	end

	if PartyRotation(icon, "party1") or ArenaRotation(icon, "arena1") then
		return true
	end
end

--################################################################################################################################################################################################################

A[7] = function(icon)
	if PartyRotation(icon, "party2") or ArenaRotation(icon, "arena2") then
		return true
	end
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	if PartyRotation(icon, "party3") or ArenaRotation(icon, "arena3") then
		return true
	end
end

--################################################################################################################################################################################################################

A[9] = function(icon)
	if PartyRotation(icon, "party4") or ArenaRotation(icon, "arena4") then
		return true
	end
end

--################################################################################################################################################################################################################

A[10] = function(icon)
	if PartyRotation(icon, "player") or ArenaRotation(icon, "arena5") then
		return true
	end
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