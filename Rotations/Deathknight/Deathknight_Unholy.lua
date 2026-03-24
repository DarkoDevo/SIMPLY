--AMS healer no range or delay
if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

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
local ACTION_CONST_DEATHKNIGHT_UNHOLY   = Action.Const.DEATHKNIGHT_UNHOLY
local ActiveUnitPlates        			= MultiUnits:GetActiveUnitPlates()
local Pet                               = LibStub("PetLibrary")
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop

Action[ACTION_CONST_DEATHKNIGHT_UNHOLY] = {
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
    --Mythic Plus
    Quake                                 = Create({ Type = "Spell", ID = 240447  	}),
    Burst                                 = Create({ Type = "Spell", ID = 240443	}),
    GrievousWound                         = Create({ Type = "Spell", ID = 240559	}),
    Necrotic                              = Create({ Type = "Spell", ID = 209858	}),
    --AntiFakeStuff
	AntiFakeKick                         = Create({ Type = "SpellSingleColor", ID = 47528,  Hidden = true,		Color = "GREEN"			, Desc = "[2] AntiFakeKick",     QueueForbidden = true	}),
	AntiFakeCC						     = Create({ Type = "SpellSingleColor", ID = 207167, Hidden = true,		Color = "BLUE"			, Desc = "[1] AntiFakeCC",       QueueForbidden = true	}), --Blinding Sleet
	AntiFakeCC1						     = Create({ Type = "SpellSingleColor", ID = 221562, Hidden = true,		Color = "LIGHT BLUE"	, Desc = "[1] AntiFakeCC1",      QueueForbidden = true	}), --Asphyxiate 
	AntiFakeCC2						     = Create({ Type = "SpellSingleColor", ID = 49576,  Hidden = true,		Color = "YELLOW"		, Desc = "[1] AntiFakeCC2",      QueueForbidden = true	}), --Death Grip
	AntiFakeCC3						     = Create({ Type = "SpellSingleColor", ID = 47476,  Hidden = true,		Color = "WHITE"			, Desc = "[1] AntiFakeCC3",      QueueForbidden = true	}), --Strangulate 
	AntiFakeCC4						     = Create({ Type = "SpellSingleColor", ID = 91809,  Hidden = true,		Color = "RED"			, Desc = "[1] AntiFakeCC4",      QueueForbidden = true	}), --Leap 
	AntiFakeCC5						     = Create({ Type = "SpellSingleColor", ID = 91800,  Hidden = true,		Color = "PINK"			, Desc = "[1] AntiFakeCC5",      QueueForbidden = true	}), --Gnaw 
    
    -- Abilities
    DeathAndDecay                         = Create({ Type = "Spell", ID = 43265 }),
    -- DeathCoil                             = Create({ Type = "Spell", ID = 47541 }),
	DeathCoil							  = Create({ Type = "Spell", ID = 47541, Macro = "/cast Death Coil" }),
    -- Talents
    AbominationLimb                       = Create({ Type = "Spell", ID = 383269 }),
    Asphyxiate                            = Create({ Type = "Spell", ID = 221562 }),
    ChainsofIce                           = Create({ Type = "Spell", ID = 45524 }),
    CleavingStrikes                       = Create({ Type = "Spell", ID = 316916 }),
    DeathStrike                           = Create({ Type = "Spell", ID = 49998 }),
    EmpowerRuneWeapon                     = Create({ Type = "Spell", ID = 47568 }),
    IcyTalons                             = Create({ Type = "Spell", ID = 194878 }),
    RaiseDead                             = Create({ Type = "Spell", ID = 46584 }),
    RunicAttenuation                      = Create({ Type = "Spell", ID = 207104 }),
    SacrificialPact                       = Create({ Type = "Spell", ID = 327574 }),
    SoulReaper                            = Create({ Type = "Spell", ID = 343294 }),
    UnholyGround                          = Create({ Type = "Spell", ID = 374265 }),
    -- Buffs
    AbominationLimbBuff                   = Create({ Type = "Spell", ID = 383269, Hidden = true }),
    DeathAndDecayBuff                     = Create({ Type = "Spell", ID = 188290 }),
    DeathsDueBuff                         = Create({ Type = "Spell", ID = 324165 }),
    EmpowerRuneWeaponBuff                 = Create({ Type = "Spell", ID = 47568, Hidden = true }),
    IcyTalonsBuff                         = Create({ Type = "Spell", ID = 194879 }),
    UnholyStrengthBuff                    = Create({ Type = "Spell", ID = 53365 }),
    -- Debuffs
    BloodPlagueDebuff                     = Create({ Type = "Spell", ID = 55078 }),
    FrostFeverDebuff                      = Create({ Type = "Spell", ID = 55095 }),
    VirulentPlagueDebuff                  = Create({ Type = "Spell", ID = 191587 }),
    -- Interrupts
    MindFreeze                            = Create({ Type = "Spell", ID = 47528 }),
    -- Custom
    Pool                                  = Create({ Type = "Spell", ID = 999910 }),
    -- Abilities
    -- Talents
    Apocalypse                            = Create({ Type = "Spell", ID = 275699 }),
    ArmyoftheDamned                       = Create({ Type = "Spell", ID = 276837 }),
    ArmyoftheDead                         = Create({ Type = "Spell", ID = 42650 }),
    BurstingSores                         = Create({ Type = "Spell", ID = 207264 }),
    ClawingShadows                        = Create({ Type = "Spell", ID = 207311, Texture = 61016 }),
    CoilofDevastation                     = Create({ Type = "Spell", ID = 390270 }),
    CommanderoftheDead                    = Create({ Type = "Spell", ID = 390259 }),
    DarkTransformation                    = Create({ Type = "Spell", ID = 63560 }),
    Defile                                = Create({ Type = "Spell", ID = 152280 }),
    DefileDebuff                          = Create({ Type = "Spell", ID = 218100, Hidden = true }),
    Epidemic                              = Create({ Type = "Spell", ID = 207317 }),
    EternalAgony                          = Create({ Type = "Spell", ID = 390268 }),
    FesteringStrike                       = Create({ Type = "Spell", ID = 85948 }),
    Festermight                           = Create({ Type = "Spell", ID = 377590 }),
	FesteringScythe					      = Create({ Type = "Spell", ID = 455397 }),
    GhoulishFrenzy                        = Create({ Type = "Spell", ID = 377587 }),
    ImprovedDeathCoil                     = Create({ Type = "Spell", ID = 377580 }),
    InfectedClaws                         = Create({ Type = "Spell", ID = 207272 }),
    Morbidity                             = Create({ Type = "Spell", ID = 377592 }),
    Outbreak                              = Create({ Type = "Spell", ID = 77575 }),
    Pestilence                            = Create({ Type = "Spell", ID = 277234 }),
    Plaguebringer                         = Create({ Type = "Spell", ID = 390175 }),
    RottenTouch                           = Create({ Type = "Spell", ID = 390275 }),
    ScourgeStrike                         = Create({ Type = "Spell", ID = 55090, Texture = 61016  }),
    SummonGargoyle                        = Create({ Type = "Spell", ID = 49206 }),
    Superstrain                           = Create({ Type = "Spell", ID = 390283 }),
    UnholyAssault                         = Create({ Type = "Spell", ID = 207289 }),
    UnholyBlight                          = Create({ Type = "Spell", ID = 460448 }),
    UnholyCommand                         = Create({ Type = "Spell", ID = 316941 }),
    UnholyPact                            = Create({ Type = "Spell", ID = 319230 }),
    VileContagion                         = Create({ Type = "Spell", ID = 390279 }),
	UnyieldingWill						  = Create({ Type = "Spell", ID = 457574 }),
    -- Buffs
    FestermightBuff                       = Create({ Type = "Spell", ID = 377591 }),
    PlaguebringerBuff                     = Create({ Type = "Spell", ID = 390178 }),
    RunicCorruptionBuff                   = Create({ Type = "Spell", ID = 51460 }),
    SuddenDoomBuff                        = Create({ Type = "Spell", ID = 81340 }),
    UnholyAssaultBuff                     = Create({ Type = "Spell", ID = 207289, Hidden = true }),
    -- Debuffs
    FesteringWoundDebuff                  = Create({ Type = "Spell", ID = 194310 }),
    UnholyBlightDebuff                    = Create({ Type = "Spell", ID = 115994 }),
	PetChainsDebuff					      = Create({ Type = "Spell", ID = 444826 }),
    
    --Manually Added
	DeathPact						  	  = Create({ Type = "Spell", ID = 48743	 }),
	IceboundFortitude					  = Create({ Type = "Spell", ID = 48792	 }),
	AntiMagicShell						  = Create({ Type = "Spell", ID = 48707, Texture = 24261, }),
	AntiMagicShellSW					  = Create({ Type = "Spell", ID = 410358, Texture = 24261, }),
	DarkSuccor							  = Create({ Type = "Spell", ID = 178819 }),
	DeathGrip						  	  = Create({ Type = "Spell", ID = 49576  }),
	AntiMagicZone						  = Create({ Type = "Spell", ID = 51052  }),
	DeathsAdvance						  = Create({ Type = "Spell", ID = 48265  }),
	WraithWalk						  	  = Create({ Type = "Spell", ID = 212552  }),
	Lichborne						  	  = Create({ Type = "Spell", ID = 49039	 }),
	DeathCoilPlayer						  = Create({ Type = "Spell", ID = 47541, Hidden = true, Texture = 98008 }),
	BlindingSleet						  = Create({ Type = "Spell", ID = 207167 }),
	RaiseAlly						  	  = Create({ Type = "Spell", ID = 61999 }),
	DeathCharge						  	  = Create({ Type = "Spell", ID = 444347, FixedTexture = 237561, }),
	DeathChargeTalent				  	  = Create({ Type = "Spell", ID = 444010, FixedTexture = 237561, }),
    
    --Pvp Talents
	DarkSimulacrum					  	  = Create({ Type = "Spell", ID = 77606  }),
	Reanimation					  	      = Create({ Type = "Spell", ID = 210128 }),
	RaiseAbomination					  = Create({ Type = "Spell", ID = 455395 }),
	Strangulate						  	  = Create({ Type = "Spell", ID = 47476	 }),
	Doomburst						      = Create({ Type = "Spell", ID = 356512 }),
	GroundingTotem						  = Create({ Type = "Spell", ID = 8178, Hidden = true }),
	EyeBeam						  		  = Create({ Type = "Spell", ID = 198013, Hidden = true }),
	AbyssalStare						  = Create({ Type = "Spell", ID = 452497, Hidden = true }),
	CelestialConduit					  = Create({ Type = "Spell", ID = 443028, Hidden = true }),
	CelestialConduit2					  = Create({ Type = "Spell", ID = 443038, Hidden = true }),
	SpellWarden						  	  = Create({ Type = "Spell", ID = 410320, Hidden = true }), 
    
	Garrote						  		  = Create({ Type = "Spell", ID = 703, Hidden = true }),
	CheapShot						  	  = Create({ Type = "Spell", ID = 1833, Hidden = true }),
    
    --Pet
	Gnaw						  	  	  = Create({ Type = "Spell", ID = 47481	 }),
	Leap						  	  	  = Create({ Type = "Spell", ID = 47482	 }),
    
	AsphyxiateFocus						  = Create({ Type = "Spell", ID = 221562, Hidden = true, Texture = 260364 }),
	DeathGripFocus						  = Create({ Type = "Spell", ID = 49576, Hidden = true, Texture = 255654 }),
	StrangulateFocus					  = Create({ Type = "Spell", ID = 255654, Hidden = true, Texture = 287712 }),
    
	PvpTrinket1 		  				  = Create({ Type = "Trinket", ID = 216369}),
	PvpTrinket2 		  				  = Create({ Type = "Trinket", ID = 216282}),
    
	FistofFury1						  	  = Create({ Type = "Spell", ID = 113656, Hidden = true }),
	FistofFury2						  	  = Create({ Type = "Spell", ID = 117418, Hidden = true }),
	WailingArrow						  = Create({ Type = "Spell", ID = 392060, Hidden = true }),
    
	BloodforgeArmor						  = Create({ Type = "Spell", ID = 410305, Hidden = true }),
    
} --if NoGlobalsAvialable() or NoInterfaceAvialable() then return true end

--#####################################################################################################################################################################################

local A 									= setmetatable(Action[ACTION_CONST_DEATHKNIGHT_UNHOLY], { __index = Action })

local mouseover	 							= "mouseover"
local focus		 							= "focus"
local target	 							= "target"
local player	 							= "player"
local pet	 								= "pet"

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
	movingTime  					= Player:IsMovingTime()
	stayingTime						= Player:IsStayingTime()
	PlayerHealth					= Unit(player):HealthPercent()
	IsInMeleeRange     				= Unit(target):GetRange() < 5 --A.FesteringStrike:IsSpellInRange("target")
    
	pvp_Toggle 						= GetToggle(2, "Checkbox4") and (A.Zone == "arena" or A.Zone == "pvp")
end

--#####################################################################################################################################################################################

local function tempSpellCooldown(spellID)
    local cooldownInfo = C_Spell.GetSpellCooldown(spellID)
    if cooldownInfo and cooldownInfo.isEnabled then
        local start = cooldownInfo.startTime
        local duration = cooldownInfo.duration
        local modRate = cooldownInfo.modRate or 1
        
        if duration > 0 then
            local remaining = (start + duration - GetTime()) / modRate
            return remaining
        else
            return 0 -- No cooldown
        end
    end
    return nil -- Spell is not usable or invalid spell ID
end


-- Yanked stuff from zerker globals
local function NeedStopCast()
    if GetToggle(1, "StopCast") and Unit("player"):IsCastingRemains() > 0 then
        
        local playerHasQuakingDebuff = Unit("player"):HasDeBuffs(240447)
        local targetCastingGrimrail = Unit("target"):IsCastingRemains(161087)
        if playerHasQuakingDebuff > 0 and playerHasQuakingDebuff < 0.5 then
            return true
        elseif targetCastingGrimrail > 0 and targetCastingGrimrail < 0.5 then
            return true
        end
    end
    
    return false
end

local function CanSlow()
    if Unit("target"):IsPlayer() and Unit("target"):GetMaxSpeed() >= 100 and Unit("target"):IsDebuffDown("Slowed") then
        for buffID in pairs(SlowImmuneBuffs) do
            if Unit("target"):IsBuffUp(buffID) then
                return false
            end
        end
        return true
    end
    return false
end

local function GetCastPercentage(unitID)
    local name, _, _, startTime, endTime, _, _, notInterrupt = UnitCastingInfo(unitID)
    if not name then
        name, _, _, startTime, endTime, _, notInterrupt = UnitChannelInfo(unitID)
    end
    if name then
        local currentTime = GetTime() * 1000
        local elapsedTime = currentTime - startTime
        local totalDuration = endTime - startTime
        return (elapsedTime / totalDuration) * 100, notInterrupt
    else
        return 0, notInterrupt
    end
end

--Function to check if the unit is attackable with physical damage
local function CanAttackTargetPhysical(unitID)
    return Unit(unitID):IsBuffDown(Full_Immune_Buffs) and Unit(unitID):IsDebuffDown(Full_Immune_DeBuffs) and Unit(unitID):IsBuffDown(Phys_Immune_Buffs)
end

--########################################################################################################################################################################################################################################################################################################################################################################

--Function to check if the unit is attackable magical damage
local function CanAttackTargetMagical(unitID)
    return Unit(unitID):IsBuffDown(Full_Immune_Buffs) and Unit(unitID):IsDebuffDown(Full_Immune_DeBuffs) and Unit(unitID):IsBuffDown(Magic_Immune_Buffs)
end

--Specified Kick function depending on damage type (Physical)
local function CanKickArenaPhysical(unitID)
    local raceCar = GetToggle(2, "RaceCar")
    local percentRc = 35
    if raceCar then percentRc = 28 end
    local percent, notInterrupt = GetCastPercentage(unitID)
    return A.InterruptIsValid(unitID, "BerserkerPvpInterrupts", true, true) and not notInterrupt and CanAttackTargetPhysical(unitID) and Unit(unitID):IsBuffDown(Kick_Immune_Buffs) and ((percent > percentRc) or (UnitChannelInfo(unitID) and percent > 15))
end

--Specified Kick function depending on damage type (Magical)
local function CanKickArenaMagical(unitID)
    local raceCar = GetToggle(2, "RaceCar")
    local percentRc = 35
    if raceCar then percentRc = 28 end
    local percent, notInterrupt = GetCastPercentage(unitID)
    return A.InterruptIsValid(unitID, "BerserkerPvpInterrupts", true, true) and not notInterrupt and CanAttackTargetMagical(unitID) and Unit(unitID):IsBuffDown(Kick_Immune_Buffs) and ((percent > percentRc) or (UnitChannelInfo(unitID) and percent > 15))
end

local function CCHealerInArenaDps(unitID, threshold, ccDur, ccType, castOnlyOnHealer, castOnTarget)
    local healthThresholdMet = (Unit("arena1"):IsExists() and Unit("arena1"):HealthPercent() <= threshold) or (Unit("arena2"):IsExists() and Unit("arena2"):HealthPercent() <= threshold) or (Unit("arena3"):IsExists() and Unit("arena3"):HealthPercent() <= threshold)
    local isInCC = Unit(unitID):InCC() <= ccDur
    local drThresholdMet = Unit(unitID):GetDR(ccType) >= 50
    local isHealer = Unit(unitID):IsHealer()
    local isTarget = UnitIsUnit(unitID, "target")
    local noOtherCC = Unit(unitID):HasDeBuffs(Active_CC_Debuffs) < 1 and Unit(unitID):IsBuffDown(CC_Immune_Buffs)
    
    if noOtherCC and (healthThresholdMet and isInCC and drThresholdMet) then
        if (castOnlyOnHealer and isHealer) or (not castOnlyOnHealer and (isHealer or not isHealer)) then
            if (castOnTarget and (isTarget or not isTarget)) or (not castOnTarget and not isTarget) then
                return true
            end
        end
    end
    
    return false
end

--#####################################################################################################################################################################################

local function GnawAsStun(unitID)
    local castingSpells = {
        A.EyeBeam.ID,
        A.AbyssalStare.ID,
        A.CelestialConduit.ID,
        A.CelestialConduit2.ID,
        A.WailingArrow.ID
    }
    
    local unit = Unit(unitID)
    
    for _, spellID in ipairs(castingSpells) do
        if unit:IsCastingRemains(spellID) > 0 then
            return true
        end
    end
    
    if unit:HealthPercent() <= 25 then
        return true
    end
    
    return false
end

--#####################################################################################################################################################################################

local useKick, useCC, useRacial, notInterruptable, castRemainsTime

local function Interrupts(unitID)
    if A.Zone == "arena" then return false end
    
    if A.InstanceInfo.KeyStone > 1 then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "BerserkerS3Interrupts", true, true)
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "BerserkerPvpInterrupts", true, true)
    end
    
    if castRemainsTime == 0 then return false end
    
    if useKick and not notInterruptable and Unit(unitID):IsBuffDown(Kick_Immune_Buffs) then
        
        if A.MindFreeze:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and A.MindFreeze:AbsentImun(unitID, Temp.TotalAndMagKick, true) then return A.MindFreeze end
        
        if A.Leap:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(pet):IsBuffUp(A.DarkTransformation.ID) and Unit(pet):IsDebuffDown(Root_Debuff) and A.Leap:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then return A.Leap end
    end
    
    if useCC and Unit(unitID):IsBuffDown(CC_Immune_Buffs) then
        
        if A.Asphyxiate:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):GetDR("stun") >= 50 then return A.Asphyxiate end
        
        if A.Strangulate:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):GetDR("silence") >= 50 and Unit(unitID):IsBuffDown(378444) then return A.Strangulate end
        
        --if A.Gnaw:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):GetDR("stun") >= 50 and Unit(pet):IsBuffUp(A.DarkTransformation.ID) then return A.Gnaw end
    end
end

--#####################################################################################################################################################################################

local function UseItems()
    if Unit("player"):CombatTime() == 0 then return false end
    
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
    
    if (A.Zone == "arena" or A.Zone == "pvp") then return false end
    
    --Trinket1
    if A.Trinket1:IsReadyByPassCastGCD() and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] then return A.Trinket1 end
    
    --Trinket2
    if A.Trinket2:IsReadyByPassCastGCD() and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] then return A.Trinket2 end
end

--#####################################################################################################################################################################################

local function AutoAntiMagicZonePvp()
    local checkDmgBuffsfromEnemy = {
        51271,   -- Pillar of Frost
        207289,  -- Unholy Assault
        323639,  -- The Hunt
        194223,  -- Celestial Alignment
        375087,  -- Dragonrage
        190319,  -- Combustion
        12472,   -- Icy Veins
        365350,  -- Arcane Surge
        31884,   -- Avenging Wrath
        2825,    -- Bloodlust
        --114051,  -- Ascendance (currently procing on mage ascendance)
        205180,  -- Summon Darkglare
        265187,  -- Summon Demonic Tyrant
        258925,  -- Fel Barrage
		357210,	 -- Deep Breath
        102560,  -- Boomie Incarn
        162264,  -- Metamorphosis
        191427,  -- Metamorphosis
        360952,  -- Coordinated Assault
    }
    
    for _, buffID in ipairs(checkDmgBuffsfromEnemy) do
        if Unit(target):IsBuffUp(buffID, true) and Unit(target):GetRange() <= 5 and not Unit(target):IsHealer() then
            if imtarget() then
                if A.AntiMagicZone:IsReadyByPassCastGCD() then
                    return true
                end
                
                if A.AntiMagicShell:IsReadyByPassCastGCD() and A.AntiMagicZone:GetCooldown() > 5 and Unit(player):HealthPercent() <= 90 then
                    return true
                end
            end
            break
        end
    end
    
    return false
end

local enemyBuffs = {
    107574, -- Avatar
    207289, -- Unholy Assault
    51271,  -- Pillar of Frost
    106951, -- Berserk
    162264, -- Metamorphosis
    191427, -- Metamorphosis
    1719,   -- Recklessness
    13750,  -- Adrenaline Rush
    19574,  -- Bestial Wrath
    137639, -- Storm E W
    375087, -- Dragon Rage
    288613, -- Trueshot
    360952, -- Coordinated Assault
	359844,	-- Call of the Wild
	31884,	-- Avenging Wrath
    185313, -- Shadow Dance
    114051, -- Ascendance
    102560, -- Boomie Incarn
    190319, -- Combustion
	12472,	-- Icy Veins
    102543, -- Feral Incarn
}

local function iceboundFortitudePvP()
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end
    for _, buffID in ipairs(enemyBuffs) do
        if Unit("target"):IsBuffUp(buffID, true) and locData and (locData.locType == "STUN" or locData.locType == "STUN_MECHANIC") and locData.timeRemaining > 2 and UnitIsUnit("player", "targettarget") then
            return true
        end
    end
end

local function lichbornePvP()
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end
    
    if locData.locType ~= "FEAR" and locData.locType ~= "FEAR_MECHANIC" and locData.locType ~= "DISORIENT" and locData.locType ~= "SLEEP" then return false end
    
    if locData.timeRemaining < 2 then return false end
    
    if Unit(player):IsBuffUp(8143, true) then return false end -- Tremor Totem
    
    ----if not UnitIsUnit("player", "targettarget") then return false end
    
    return true
end

local function imSilenced()
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end
    
    if locData.locType ~= "SILENCE" and locData.locType ~= "SILENCE_MECHANIC" then return false end
    
    return true
end

local function deathsChargePvP()
    if not IsPlayerSpell(A.DeathChargeTalent.ID) then return false end
    
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end
    
    if locData.locType ~= "ROOT" then return false end
    if locData.timeRemaining <= 0.5 then return false end
    if Unit(player):IsBuffUp(A.DeathCharge.ID) then return false end
    
    return true
end

local function wraithwalkPvP()
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    if not locData then return false end
    
    if locData.locType ~= "ROOT" then return false end
    if locData.timeRemaining <= 1 then return false end
    
    return true
end

--[[
local function scaryBuff()
    local enemyBuffs = {
        107574, -- Avatar
        207289, -- Unholy Assault
        51271,  -- Pillar of Frost
        106951, -- Berserk
        162264, -- Metamorphosis
        1719,   -- Recklessness
        13750,  -- Adrenaline Rush
        19574,  -- Bestial Wrath
        137639, -- Storm E W
        375087, -- Dragon Rage
        121471, -- Shadow Blade
        288613, -- Trueshot
        360952, -- Coordinated Assault
    }

    for _, buffID in ipairs(enemyBuffs) do
        if Unit("target"):IsBuffUp(buffID, true) then
            return true
        end
    end
end

local function bigBoyPrints()
    local locData = C_LossOfControl.GetActiveLossOfControlData(1)
    local locType = "None"
    local locRemaining = 0
    if locData then locType = locData.locType end
    if locData then locRemaining = locData.timeRemaining end

    MakPrint(1, "LoC Type: ", locType)
    MakPrint(2, "LoC Duration: ", locRemaining)
    MakPrint(3, "Scary Buff: ", scaryBuff())
    MakPrint(4, "Should Use IF: ", iceboundFortitudePvP())
    MakPrint(5, "Death Charge Learned: ", IsPlayerSpell(A.DeathChargeTalent.ID))
    MakPrint(6, "Death's Advance ready: ", A.DeathsAdvance:IsReadyByPassCastGCD())
    MakPrint(7, "Should Use Death Charge: ", deathsChargePvP())
end]]

--#####################################################################################################################################################################################

local function CanUseRunicPowerAoe()
    if Player:Rune() >= 6 or (GetToggle(2, "Checkbox4") and Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)) then return false end
    
    return A.SummonGargoyle:GetSpellTimeSinceLastCast() < 25 or Player:RunicPowerDeficit() < 35 or Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)
end

--#####################################################################################################################################################################################

local function CanUseRunicPowerST()
    if Player:Rune() >= 6 or (GetToggle(2, "Checkbox4") and Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)) then return false end
    
    return A.SummonGargoyle:GetSpellTimeSinceLastCast() < 25 or Player:RunicPowerDeficit() < 35 or Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)
end

--#####################################################################################################################################################################################

local function CanUseRunicPowerCap()
    if Player:Rune() >= 6 or (GetToggle(2, "Checkbox4") and Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)) then return false end
    
    return Player:RunicPowerDeficit() < 15 or Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)
end

--#####################################################################################################################################################################################

local function CanUseDoomburst()
    if not A.Doomburst:IsTalentLearned() then return true end
    
    if GetToggle(2, "Checkbox4") then
        if A.Apocalypse:GetCooldown() < A.GetCurrentGCD() * 2 and Unit("target"):IsDebuffStacks(A.FesteringWoundDebuff.ID) >= 4 then
            return false
        end
        
        if Unit("target"):IsDebuffStacks(A.FesteringWoundDebuff.ID, true) >= 2 or Player:Rune() < 2 then
            return true
        end
    else
        return true
    end
    
    return false
end

--#####################################################################################################################################################################################

local function CanPrepareArenaBurst()
    if not GetToggle(2, "Checkbox4") or not CDsON() then return false end
    
    return A.Apocalypse:GetCooldown() <= A.GetCurrentGCD() * 2 and Unit("target"):IsDebuffStacks(A.FesteringWoundDebuff.ID, true) < 4 and not A.UnholyAssault:IsReadyByPassCastGCD() --and A.DarkTransformation:GetCooldown() < 2
end

--#####################################################################################################################################################################################

local function CanUseDeathStrike()
    return Unit("target"):IsCastingRemains(A.FistofFury1.ID) == 0 and Unit("target"):IsCastingRemains(A.FistofFury2.ID) == 0
end

--################################################################################################################################################################################################################

A[1] = function(icon)
    if A.AntiFakeCC1:GetCooldown() == 0 then return A.AntiFakeCC1:Show(icon) end
end

A[2] = function(icon)
    local castLeft, _, _, _, notKickAble = Unit(target):IsCastingRemains()
    if castLeft > 0 then
        --AntiFakeKick
        if A.AntiFakeKick:IsReadyByPassCastGCD(target) and not notKickAble then return A.AntiFakeKick:Show(icon) end
        
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
    --Cancel WraithWalk
    if Unit(player):IsBuffUp(A.WraithWalk.ID) and LoC:Get("ROOT") == 0 and Unit(player):IsDebuffDown(Root_Debuff) then return A.WraithWalk:Show(icon) end
    
    --bigBoyPrints()
    
    if imSilenced() then
        if (A.FesteringStrike:IsReadyByPassCastGCD(unitID) or A.FesteringScythe:IsReadyByPassCastGCD(unitID)) and Player:Rune() >= 2 and CanAttackTargetPhysical(unitID) then return A.FesteringStrike:Show(icon) end
        if A.DeathStrike:IsReadyByPassCastGCD(target) and CanAttackTargetPhysical(unitID) then return A.DeathStrike:Show(icon) end
    end
    
    --From Scuzz, added by Trip 22 December 2024
    if A.IceboundFortitude:IsReadyByPassCastGCD() and iceboundFortitudePvP() then return A.IceboundFortitude:Show(icon) end 
    
    --From Scuzz, added by Trip 13 January 2025
    if A.Lichborne:IsReadyByPassCastGCD() and lichbornePvP() then return A.Lichborne:Show(icon) end    
    
    local CantCast = CantCast()
    if CantCast then return false end
    
    --From Scuzz, added by Trip 15 January 2025
    if A.DeathsAdvance:IsReadyByPassCastGCD() and deathsChargePvP() then return A.DeathCharge:Show(icon) end
    
    --WraithWalk
    if A.WraithWalk:IsReadyByPassCastGCD() and wraithwalkPvP() then return A.WraithWalk:Show(icon) end
    
    local CanPrepareArenaBurst = CanPrepareArenaBurst()
    
    -- Mouseover Raise Ally
    if A.RaiseAlly:IsReadyByPassCastGCD(mouseover) and A.MouseHasFrame() and Unit(mouseover):IsDead() and Unit(mouseover):IsPlayer() then return A.RaiseAlly:Show(icon) end
    
    if combatTime == 0 then
        
    else
        local avoid_Overlap = Unit(player):IsBuffDown(A.Lichborne.ID) and Unit(player):IsBuffDown(A.DeathPact.ID)
        
        --DeathStrike >650k last 4 secs
        if A.DeathStrike:IsReadyByPassCastGCD(target) and Unit(player):HasBuffs(A.BloodforgeArmor.ID) < 0.3 and Unit(target):IsBuffDown(Full_Immune_Buffs) and Unit(target):IsBuffDown(Phys_Immune_Buffs) and Unit(player):GetLastTimeDMGX(4) > GetToggle(2, "DeathStrikeSliderSpecial") and CanUseDeathStrike() then return A.DeathStrike:Show(icon) end
        
        --SacrificialPact
        if A.SacrificialPact:IsReadyByPassCastGCD() and UnitExists("pet") and Unit("pet"):HealthPercent() > 0 and avoid_Overlap and PlayerHealth <= GetToggle(2, "SacrificialPactSlider") then return A.SacrificialPact:Show(icon) end
        
        --DeathPact
        if A.DeathPact:IsReadyByPassCastGCD() and avoid_Overlap and PlayerHealth <= GetToggle(2, "DeathPactSlider") then return A.DeathPact:Show(icon) end
        
        --IceboundFortitude
        if A.IceboundFortitude:IsReadyByPassCastGCD() and PlayerHealth <= GetToggle(2, "IceboundFortitudeSlider") then return A.IceboundFortitude:Show(icon) end
        
        --AntiMagicShell Debuff Remove
        if ((not A.SpellWarden:IsTalentLearned() and A.AntiMagicShell:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShell.ID) < .3) or (A.SpellWarden:IsTalentLearned() and A.AntiMagicShellSW:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShellSW.ID) < .3)) and A.UnyieldingWill:IsTalentLearned() and Unit(player):IsBuffDown(A.AntiMagicZone.ID) and Unit(player):IsDebuffUp(AMS_Dispell) then return A.AntiMagicShell:Show(icon) end
        
        --AntiMagicShell Debuff Absorb
        if ((not A.SpellWarden:IsTalentLearned() and A.AntiMagicShell:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShell.ID) < .3) or (A.SpellWarden:IsTalentLearned() and A.AntiMagicShellSW:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShellSW.ID) < .3)) and Unit(player):IsBuffDown(A.AntiMagicZone.ID) and (AutoAntiMagicZonePvp() or Unit(player):IsDebuffUp(AMS_Debufftable) or PlayerHealth <= GetToggle(2, "AntiMagicShellSlider")) then return A.AntiMagicShell:Show(icon) end
        
        --AntiMagicShell Buff Counter
        if ((not A.SpellWarden:IsTalentLearned() and A.AntiMagicShell:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShell.ID) < .3) or (A.SpellWarden:IsTalentLearned() and A.AntiMagicShellSW:IsReadyByPassCastGCD() and tempSpellCooldown(A.AntiMagicShellSW.ID) < .3)) and Unit(player):IsBuffDown(A.AntiMagicZone.ID) and Unit(target):IsBuffUp(AMS_Bufftable) and Unit(target):GetRange() <= 5 then return A.AntiMagicShell:Show(icon) end
        
        --AntiMagicZone
        if A.AntiMagicZone:IsReadyByPassCastGCD() and Unit(player):IsBuffDown(A.AntiMagicShell.ID) and (AutoAntiMagicZonePvp() or PlayerHealth <= GetToggle(2, "AntiMagicZoneSlider")) then return A.AntiMagicZone:Show(icon) end
        
        --Lichborne
        if A.Lichborne:IsReadyByPassCastGCD() and avoid_Overlap and PlayerHealth <= GetToggle(2, "LichborneSlider") then return A.Lichborne:Show(icon) end
        
        --Deathcoil Player
        if GetToggle(2, "lichborneHealing") and A.DeathCoilPlayer:IsReadyByPassCastGCD(player) and Unit(player):IsBuffDown(A.DeathPact.ID) and Unit(player):IsBuffUp(A.Lichborne.ID) and PlayerHealth <= 90 then return A.DeathCoilPlayer:Show(icon) end
        
        --DarkSuccor
        if A.DeathStrike:IsReadyByPassCastGCD(target) and Unit(player):HasBuffs(A.BloodforgeArmor.ID) < 0.3 and Unit(target):IsBuffDown(Full_Immune_Buffs) and Unit(target):IsBuffDown(Phys_Immune_Buffs) and avoid_Overlap and Unit(player):IsBuffUp(A.DarkSuccor.ID) and PlayerHealth <= 85 and CanUseDeathStrike() then return A.DeathStrike:Show(icon) end
        
        --DeathStrike
        if A.DeathStrike:IsReadyByPassCastGCD(target) and Unit(player):HasBuffs(A.BloodforgeArmor.ID) < 0.3 and Unit(target):IsBuffDown(Full_Immune_Buffs) and Unit(target):IsBuffDown(Phys_Immune_Buffs) and avoid_Overlap and PlayerHealth <= GetToggle(2, "DeathStrikeSlider") and CanUseDeathStrike() then return A.DeathStrike:Show(icon) end
        
        --[[DeathsAdvance
        if A.DeathsAdvance:IsReadyByPassCastGCD() and Unit(player):IsBuffDown(A.DeathsAdvance.ID) and Unit(player):IsBuffDown(A.WraithWalk.ID) and IsUnitEnemy(target) and not A.MindFreeze:IsSpellInRange("target") and movingTime >= 3 then return A.DeathsAdvance:Show(icon) end]] --Asked to remove and replace with Death Charge
        
        --Trinket Stuff for Scuzz
        if A.PvpTrinket1:GetCooldown() == 0 and Unit(player):IsDebuffUp(A.Garrote.ID) and Unit(player):IsDebuffUp(A.CheapShot.ID) then return A.Trinket2:Show(icon) end
        if A.PvpTrinket2:GetCooldown() == 0 and Unit(player):IsDebuffUp(A.Garrote.ID) and Unit(player):IsDebuffUp(A.CheapShot.ID) then return A.Trinket2:Show(icon) end
    end
    
    --RaiseDead
    if A.RaiseDead:IsReadyByPassCastGCD() and (not UnitExists("pet") or Unit("pet"):HealthPercent() <= 0) then return A.RaiseDead:Show(icon) end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function Cooldowns()
        
        local activeDarkTransformation = (A.DarkTransformation:GetSpellTimeSinceLastCast() < 15)
        local readyDarkTransformation = (A.DarkTransformation:GetCooldown() == 0 or not A.DarkTransformation:IsTalentLearned())
        local readyApocalypse = (A.Apocalypse:GetCooldown() == 0 or not A.Apocalypse:IsTalentLearned())
        
        if GetToggle(2, "Checkbox4") then
            --ArmyoftheDead
            if A.ArmyoftheDead:IsReadyByPassCastGCD() and not A.RaiseAbomination:IsTalentLearned() and readyApocalypse then return A.ArmyoftheDead:Show(icon) end
            
            --EmpowerRuneWeapon
            if A.EmpowerRuneWeapon:IsReadyByPassCastGCD() and readyApocalypse then return A.EmpowerRuneWeapon:Show(icon) end
            
            --AbominationLimb
            if A.AbominationLimb:IsReadyByPassCastGCD() and A.AbominationLimb:IsTalentLearned() and CanAttackTargetMagical(unitID) and Unit(unitID):GetRange() <= 5 and readyApocalypse then return A.AbominationLimb:Show(icon) end
            
            --SummonGargoyle
            if A.SummonGargoyle:IsReadyByPassCastGCD() and readyApocalypse then return A.SummonGargoyle:Show(icon) end
            
            --RaiseAbomination
            if A.RaiseAbomination:IsReadyByPassCastGCD() and A.RaiseAbomination:IsTalentLearned() and tempSpellCooldown(A.RaiseAbomination.ID) < .3 and Unit(unitID):GetRange() <= 5 and readyApocalypse then return A.RaiseAbomination:Show(icon) end
            
            --DarkTransformation
            if A.DarkTransformation:IsReadyByPassCastGCD() and not A.Apocalypse:IsTalentLearned() and UnitExists("pet") and Unit("pet"):HealthPercent() > 0 then return A.DarkTransformation:Show(icon) end
            
            --UnholyAssault
            if A.UnholyAssault:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and readyApocalypse and FesterStacks <= 3 then return A.UnholyAssault:Show(icon) end
            
            --Apocalypse
            if A.Apocalypse:IsReadyByPassCastGCD() and A.Apocalypse:IsTalentLearned() and CanAttackTargetMagical(unitID) and FesterStacks >= 1 then return A.Apocalypse:Show(icon) end
        else
            --ArmyoftheDead
            if A.ArmyoftheDead:IsReadyByPassCastGCD() and not A.RaiseAbomination:IsTalentLearned() and readyApocalypse then return A.ArmyoftheDead:Show(icon) end
            
            --EmpowerRuneWeapon
            if A.EmpowerRuneWeapon:IsReadyByPassCastGCD() and readyApocalypse then return A.EmpowerRuneWeapon:Show(icon) end
            
            --AbominationLimb
            if A.AbominationLimb:IsReadyByPassCastGCD() and A.AbominationLimb:IsTalentLearned() and CanAttackTargetMagical(unitID) and Unit(unitID):GetRange() <= 5 and readyApocalypse then return A.AbominationLimb:Show(icon) end
            
            --SummonGargoyle
            if A.SummonGargoyle:IsReadyByPassCastGCD() and readyApocalypse then return A.SummonGargoyle:Show(icon) end
            
            --DarkTransformation | UnholyBlight
            if A.DarkTransformation:IsReadyByPassCastGCD() and not A.Apocalypse:IsTalentLearned() and UnitExists("pet") and Unit("pet"):HealthPercent() > 0 then return A.DarkTransformation:Show(icon) end
            
            --UnholyBlight
            --if A.UnholyBlight:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and Unit(unitID):IsBuffDown(Magic_Immune_UnholyBlight) and IsInMeleeRange then return A.UnholyBlight:Show(icon) end (depreciated)
            
            --UnholyAssault
            if A.UnholyAssault:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and readyApocalypse and FesterStacks <= 3 then return A.UnholyAssault:Show(icon) end
            
            --Apocalypse
            if A.Apocalypse:IsReadyByPassCastGCD() and A.Apocalypse:IsTalentLearned() and CanAttackTargetMagical(unitID) and FesterStacks >= GetToggle(2, "FesterStacksSlider") then return A.Apocalypse:Show(icon) end
        end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function AoE()
        --PVE Epidemic | DeathCoil
        --A.Epidemic:IsTalentLearned()
        if 1 == 1 then
            if A.Epidemic:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and Unit(unitID):IsDebuffUp(A.VirulentPlagueDebuff.ID) and (CanUseRunicPowerAoe() or Unit(player):IsBuffUp(A.SuddenDoomBuff.ID)) then return A.Epidemic:Show(icon) end
        else
            if A.DeathCoil:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and CanUseRunicPowerAoe() then return A.DeathCoil:Show(icon) end
        end
        
        if FesterStacks < GetToggle(2, "FesterStacksSlider") or CanPrepareArenaBurst then
            --FesteringStrike
            if (A.FesteringStrike:IsReadyByPassCastGCD(unitID) or A.FesteringScythe:IsReadyByPassCastGCD(unitID)) and CanAttackTargetPhysical(unitID) then return A.FesteringStrike:Show(icon) end
        else
            if Unit(player):IsBuffDown(A.SuddenDoomBuff.ID) then
                --DeathAndDecay | VileContagion
                if A.DeathAndDecay:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and isStaying and (Unit(player):IsBuffDown({A.DeathAndDecayBuff.ID, A.DefileDebuff.ID}) and (Unit(unitID):IsDebuffUp(A.FesteringWoundDebuff.ID, true)) or GetToggle(2, "FesterStacksSlider") < 1) then
                    if CDsON() and A.VileContagion:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) then return A.VileContagion:Show(icon) end 
                    return A.DeathAndDecay:Show(icon)
                end
                
                --Wound Spender
                if WoundSpender:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) then return WoundSpender:Show(icon) end
            end
        end
        
        --Filler
        if 1 == 1 then
            if A.Epidemic:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and Unit(unitID):IsDebuffUp(A.VirulentPlagueDebuff.ID) and CanUseDoomburst() then return A.Epidemic:Show(icon) end
        else
            if A.DeathCoil:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and CanUseDoomburst() then return A.DeathCoil:Show(icon) end
        end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function Generic()
        
        --DeathCoil
        if A.DeathCoil:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and CanUseRunicPowerCap() then return A.DeathCoil:Show(icon) end
        
        if FesterStacks < GetToggle(2, "FesterStacksSlider") or CanPrepareArenaBurst then
            --FesteringStrike
            if (A.FesteringStrike:IsReadyByPassCastGCD(unitID) or A.FesteringScythe:IsReadyByPassCastGCD(unitID)) and CanAttackTargetPhysical(unitID) then return A.FesteringStrike:Show(icon) end
        else
            if Unit(player):IsBuffDown(A.SuddenDoomBuff.ID) then
                --Wound Spender
                if WoundSpender:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) then return WoundSpender:Show(icon) end
            end
        end
        
        --DeathCoil
        if A.DeathCoil:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and CanUseRunicPowerST() then return A.DeathCoil:Show(icon) end
        
        --DeathCoil Filler
        if A.DeathCoil:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) --[[and CanUseDoomburst()]] then return A.DeathCoil:Show(icon) end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function APL()
        --AOE Check
        if GetToggle(2, "AoE") then AoEUnits = MultiUnits:GetBySpell(A.MindFreeze) else AoEUnits = 1 end
        
        -- Set WoundSpender and AnyDnD
        WoundSpender = (A.ClawingShadows:IsTalentLearned() and A.ClawingShadows or A.ScourgeStrike)
        
        AnyDnD = A.DeathAndDecay
        if A.Defile:IsTalentLearned() then
            AnyDnD = A.Defile
        end
        
        -- Check our stacks of Festering Wounds
        FesterStacks = Unit(unitID):IsDebuffStacks(A.FesteringWoundDebuff.ID, true)
        FesterRefreshable = Unit(unitID):IsDebuffDown(A.FesteringWoundDebuff.ID, true)
        
        -- call_action_list,name=cooldowns
        if CDsON() and IsInMeleeRange and CanAttackTargetMagical(unitID) then
            local ShouldReturn = Cooldowns(); if ShouldReturn then return ShouldReturn; end
        end
        
        -- Pvp
        if GetToggle(2, "Checkbox4") then
            local ShouldReturn = Generic(); if ShouldReturn then return ShouldReturn; end
        end
        
        -- run_action_list,name=aoe,if=active_enemies>=4
        if AoEUnits >= 3 then
            local ShouldReturn = AoE(); if ShouldReturn then return ShouldReturn; end
        else
            local ShouldReturn = Generic(); if ShouldReturn then return ShouldReturn; end
        end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function DamageRotation(unitID)
        local CantDamage = Unit("target"):IsDead() or Unit("target"):IsBuffUp("TotalImun") or Unit("target"):InLOS() or Unit("target"):IsBuffUp(Full_Immune_Buffs) or Unit("player"):IsDebuffUp(410126)
        if CantDamage then return false end
        
        --Special Targets
        if (A.Zone == "arena" or A.Zone == "pvp") and not Unit(unitID):IsPlayer() then
            local ShouldReturn = Generic(); if ShouldReturn then return ShouldReturn; end
        end
        
        if (A.Zone == "arena" or A.Zone == "pvp") and not Unit(unitID):IsPlayer() then
            return false
        end
        
        --Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then return Interrupt:Show(icon) end
        
        --Use Items & Racials
        local UseItems = UseItems()
        if UseItems and CDsON() and Unit(player):IsBuffUp(A.DarkTransformation.ID) then return UseItems:Show(icon) end
        
        --Grip Target 
        if A.DeathGrip:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and pvp_Toggle and (GetToggle(2, "DeathGripDropdown") == "1" or GetToggle(2, "DeathGripDropdown") == "3") 
        and Unit(unitID):IsBuffDown(CC_Immune_Buffs)
        and Unit(unitID):IsPlayer() 
        and Unit(unitID):IsBuffDown(DontGripMe) 
        and Unit(unitID):IsDebuffDown(Root_Debuff) 
        and Unit(unitID):IsBuffDown(A.DeathsAdvance.ID) 
        and Unit(unitID):HealthPercent() < GetToggle(2, "TargetHealthSlider") 
        and Unit(unitID):GetRange() >= 10
        and not A.MindFreeze:IsSpellInRange(unitID) 
        then 
            return A.DeathGrip:Show(icon) 
        end
        
        --Gnaw Stun Target Health < 25% - Eye Beam - Abyssal Stare - Celestial Conduit
        if A.Gnaw:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):GetDR("stun") >= 50 and Unit(pet):IsBuffUp(A.DarkTransformation.ID) and GnawAsStun(unitID) and Unit(unitID):InCC() == 0 then return A.Gnaw:Show(icon) end
        
        --DarkTransformation for Scuzz
        if A.DarkTransformation:IsReadyByPassCastGCD() and CDsON() and UnitExists("pet") and Unit("pet"):HealthPercent() > 0 and GetToggle(2, "Checkbox4") and not A.Apocalypse:IsTalentLearned() and A.MindFreeze:IsSpellInRange(unitID) then return A.DarkTransformation:Show(icon) end
        
        --UnholyBlight
        --if A.UnholyBlight:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and Unit(unitID):IsBuffDown(Magic_Immune_UnholyBlight) and GetToggle(2, "Checkbox4") and IsInMeleeRange then return A.UnholyBlight:Show(icon) end
        
        --Outbreak
        if A.Outbreak:IsReadyByPassCastGCD(unitID) and not (A.UnholyBlight:IsTalentLearned() and A.DarkTransformation:IsReadyByPassCastGCD()) and not (A.Apocalypse:IsTalentLearned() and A.Apocalypse:IsReadyByPassCastGCD()) and CanAttackTargetMagical(unitID) and Unit(unitID):IsDebuffDown(A.VirulentPlagueDebuff.ID, true) and ((not GetToggle(2, "Checkbox4")) or (GetToggle(2, "Checkbox4") and (Unit(unitID):HealthPercent() > 10 and not (Unit(unitID):IsBuffUp(DOT_Immune_Table)) or not A.MindFreeze:IsSpellInRange(unitID)))) then return A.Outbreak:Show(icon) end
        
        --Outbreak
        if A.Outbreak:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):IsDebuffDown(A.VirulentPlagueDebuff.ID, true) and ((not GetToggle(2, "Checkbox4")) or (GetToggle(2, "Checkbox4") and (Unit(unitID):HealthPercent() > 10 and Unit(unitID):GetRange() >= 1 and not (Unit(unitID):IsBuffUp(DOT_Immune_Table)) or not A.MindFreeze:IsSpellInRange(unitID)))) then return A.Outbreak:Show(icon) end
        
        --Plaguebringer
        if A.ScourgeStrike:IsReadyByPassCastGCD(unitID) and A.ScourgeStrike:IsSpellInRange(unitID) and CanAttackTargetPhysical(unitID) --[[and Unit(target):IsDebuffUp(A.FesteringWoundDebuff.ID, true)]] and GetToggle(2, "Checkbox1") and A.Plaguebringer:IsTalentLearned() and Unit(player):HasBuffs(A.Plaguebringer.ID) < A.GetGCD() then return A.ScourgeStrike:Show(icon) end
        
        --SoulReaper
        if A.SoulReaper:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):HealthPercent() <= GetToggle(2, "soulReaperHP") and Unit(unitID):HealthPercent() > 15 then return A.SoulReaper:Show(icon) end
        
        --Blinding Sleet
        if A.BlindingSleet:IsReadyByPassCastGCD() and CanAttackTargetMagical(unitID) and pvp_Toggle and MultiUnits:GetBySpell(A.FesteringStrike) >= 2 and Unit(unitID):HealthPercent() <= 40 then return A.BlindingSleet:Show(icon) end
        
        -- ChainsofIce
        if A.ChainsofIce:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and CanSlow() and Unit(unitID):GetRange() >= 3 and Unit(unitID):HealthPercent() >= 20 then return A.ChainsofIce:Show(icon) end
        
        if APL() then
            return true
        end
        
        --Wound Spender out of range
        if WoundSpender:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and FesterStacks >= GetToggle(2, "FesterStacksSlider") then return WoundSpender:Show(icon) end
        
        --Wound Spender out of range
        if WoundSpender:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):GetRange() >= 6 then return WoundSpender:Show(icon) end
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    --Damage Rotation
    if A.IsUnitEnemy(target) then unitID = target if DamageRotation(unitID) then return true end end
end

--################################################################################################################################################################################################################

-- Hunter CC debuffs for SpellWarden healer protection
local HunterCCDebuffs = {
    213691, -- Scatter Shot
    24394,  -- Intimidation
    117526, -- Binding Shot
}


local function PartyRotation(icon, unitID)

	if A.SpellWarden:IsTalentLearned() and A.AntiMagicShellSW:IsReady(unitID) and Unit(unitID):IsHealer() and Unit(unitID):HasDeBuffs(HunterCCDebuffs) >= 1 then 
		return A.DarkSimulacrum:Show(icon)
	end

    end

--################################################################################################################################################################################################################

local function ArenaRotation(icon, unitID)
    if Player:IsMounted() or Player:IsStealthed() or not Unit(unitID):IsPlayer() or Unit(unitID):IsBuffUp(Full_Immune_Buffs) then return false end
    
    ------------------------------------
    --- STUNS TARGET
    ------------------------------------
    if UnitIsUnit(unitID, target) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) then
        --Asphyxiate Stun Target Health < 45%
        if GetToggle(2, "AsphyxiateDropdown") == "4" then
            if A.Asphyxiate:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):GetDR("stun") >= 50 and Unit(unitID):HealthPercent() <= 45 then return A.Asphyxiate:Show(icon) end
        end
        
        --Strangulate Stun Target Health < 35%
        if GetToggle(2, "StrangulateDropdown") == "4" then
            if A.Strangulate:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):GetDR("silence") >= 50 and Unit(unitID):IsBuffDown(378444) and Unit(unitID):HealthPercent() <= 35 then return A.Strangulate:Show(icon) end
        end
        
        --Gnaw Stun Target Health < 25%
        if A.Gnaw:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):GetDR("stun") >= 50 and Unit(pet):IsBuffUp(A.DarkTransformation.ID) and GnawAsStun(unitID) and Unit(unitID):InCC() == 0 then return A.Gnaw:Show(icon) end
    end
    
    ------------------------------------
    --- CC
    ------------------------------------
    --Asphyxiate Auto/HealerCC
    if ((GetToggle(2, "AsphyxiateDropdown") == "1") or (GetToggle(2, "AsphyxiateDropdown") == "3")) then
        if A.Asphyxiate:IsReadyByPassCastGCD(unitID) and CanAttackTargetPhysical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) and CCHealerInArenaDps(unitID, 45, 0, "stun", true, true) then return A.Asphyxiate:Show(icon) end
    end
    
    --Strangulate Auto/HealerCC
    if ((GetToggle(2, "StrangulateDropdown") == "1") or (GetToggle(2, "StrangulateDropdown") == "3")) then
        if A.Strangulate:IsReadyByPassCastGCD(unitID) and CanAttackTargetMagical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) and Unit(unitID):IsBuffDown(378444) and CCHealerInArenaDps(unitID, 35, 0, "silence", true, true) then return A.Strangulate:Show(icon) end
    end
    
    ------------------------------------
    --- KICKS
    ------------------------------------
    --MindFreeze
    if CanKickArenaMagical(unitID) then
        if A.MindFreeze:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.GroundingTotem.ID) then return A.MindFreeze:Show(icon) end
    end
    
    --Leap Kick
    if CanKickArenaPhysical(unitID) then
        if A.Leap:IsReadyByPassCastGCD(unitID) and Unit(pet):IsBuffUp(A.DarkTransformation.ID) and UnitIsUnit(unitID, target) and Unit(pet):IsDebuffDown(Root_Debuff) then return A.Leap:Show(icon) end
    end
    
    --Asphyxiate Kick
    if CanKickArenaPhysical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) and ((GetToggle(2, "AsphyxiateDropdown") == "1") or (GetToggle(2, "AsphyxiateDropdown") == "2")) then
        if A.Asphyxiate:IsReadyByPassCastGCD(unitID) and Unit(unitID):GetDR("stun") >= 50 then return A.Asphyxiate:Show(icon) end
    end
    
    --Strangulate Kick
    if CanKickArenaMagical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) and ((GetToggle(2, "StrangulateDropdown") == "1") or (GetToggle(2, "StrangulateDropdown") == "2")) then
        if A.Strangulate:IsReadyByPassCastGCD(unitID) and Unit(unitID):GetDR("silence") >= 50 and Unit(unitID):IsBuffDown(378444) then return A.Strangulate:Show(icon) end
    end
    
    --DeathGrip Kick
    if CanKickArenaPhysical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) then
        if (GetToggle(2, "DeathGripDropdown") == "1" or GetToggle(2, "DeathGripDropdown") == "2") then
            if A.DeathGrip:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(DontGripMe) and Unit(unitID):IsDebuffDown(Root_Debuff) then return A.DeathGrip:Show(icon) end
        end
    end
    
    --Gnaw Kick
    if CanKickArenaPhysical(unitID) and Unit(unitID):IsBuffDown(CC_Immune_Buffs) then
        if A.Gnaw:IsReadyByPassCastGCD(unitID) and Unit(unitID):GetDR("stun") >= 50 and Unit(pet):IsBuffUp(A.DarkTransformation.ID) and Unit(unitID):InCC() == 0 then return A.Gnaw:Show(icon) end
    end


end

--################################################################################################################################################################################################################

A[6] = function(icon)
    --Stopcast Function from Globals
    if NeedStopCast() then 
        return A.StopCast:Show(icon)
    end
    
    --Multi Dot
    if GetToggle(2, "Checkbox2") and MultiUnits:GetBySpell(A.FesteringStrike) > 1 and combatTime > 0 then
        if Unit(target):IsBoss() or MultiUnits:GetBySpell(A.FesteringStrike) == 1 or A.TargetEnemy:IsSuspended(0.5, 0.1) then 
            return false 
        end
        
        if ActiveUnitPlates and Unit(target):IsDebuffUp(A.FesteringWoundDebuff.ID, true) then
            for MultiDot_UnitID in pairs(ActiveUnitPlates) do
                if A.FesteringStrike:IsReadyByPassCastGCD(MultiDot_UnitID) and Unit(MultiDot_UnitID):IsDebuffRefreshable(A.FesteringWoundDebuff.ID, true) then 
                    return A.TargetEnemy:Show(icon)
                elseif not A.FesteringStrike:IsInRange(target) and MultiUnits:GetBySpell(A.FesteringStrike) > 1 then 
                    return A.TargetEnemy:Show(icon)
                end
            end
        end
        if MultiUnits:GetBySpell(A.FesteringStrike) > 1 and not A.FesteringStrike:IsInRange(target) then
            return A.TargetEnemy:Show(icon) 
        end
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
    
    --Stun 1
    if A.Asphyxiate:IsReadyByPassCastGCD(focus) and Unit(focus):IsBuffDown(CC_Immune_Buffs) and Unit(focus):IsBuffDown(Phys_Immune_Buffs) and Unit(focus):GetDR("stun") >= 50 and Unit(focus):HasDeBuffs(Active_CC_Debuffs) < 0.6 then return A.AntiFakeCC1:Show(icon) end
    
    --Stun 2
    if A.Strangulate:IsReadyByPassCastGCD(focus) and Unit(focus):IsBuffDown(CC_Immune_Buffs) and Unit(focus):IsBuffDown(378444) and Unit(focus):GetDR("silence") >= 50 and Unit(focus):HasDeBuffs(Active_CC_Debuffs) < 0.2 then return A.AntiFakeCC3:Show(icon) end
    
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	if PartyRotation(icon, "party3") or ArenaRotation(icon, "arena3") then
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
