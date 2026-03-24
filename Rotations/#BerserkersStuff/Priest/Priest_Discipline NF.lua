if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 256 then return end

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

local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit       	   = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local UnitIsUnit	   = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable
local GetSpellTexture  = _G.TMW.GetSpellTexture

local ActionID = {
    WillToSurvive 				            = { ID = 59752 	},
    Stoneform 					            = { ID = 20594 	},
    Shadowmeld 					            = { ID = 58984 	},
    EscapeArtist 				            = { ID = 20589 	},
    GiftOfTheNaaru  			            = { ID = 59544 	},
    Darkflight 					            = { ID = 68992 	},
    BloodFury 					            = { ID = 20572 	},
    WillOfTheForsaken 			            = { ID = 7744 	},
    WarStomp 					            = { ID = 20549 	},
    Berserking 					            = { ID = 26297 	},
    ArcaneTorrent 				            = { ID = 50613 	},
    RocketJump 					            = { ID = 69070 	},
    RocketBarrage				            = { ID = 69041	},
    QuakingPalm 				            = { ID = 107079 },
    SpatialRift 				            = { ID = 256948 },
    LightsJudgment 				            = { ID = 255647 },
    Fireblood 					            = { ID = 265221 },
    ArcanePulse 				            = { ID = 260364 },
    BullRush 					            = { ID = 255654 },
    AncestralCall 				            = { ID = 274738 },
    Haymaker 					            = { ID = 287712 },
    Regeneratin 				            = { ID = 291944 },
    BagOfTricks 				            = { ID = 312411 },
    HyperOrganicLightOriginator             = { ID = 312924 },
	TargetEnemy 				            = { ID = 44603  },
	StopCast 					            = { ID = 61721  },
	PoolResource 				            = { ID = 209274 },
	FocusParty1 				            = { ID = 134314 },
	FocusParty2 				            = { ID = 134316 },
	FocusParty3 				            = { ID = 134318 },
	FocusParty4 				            = { ID = 134320 },
	FocusPlayer 				            = { ID = 134310 },
	AntiFakeKick                            = { Type = "SpellSingleColor", ID = 88625,  Hidden = true,		Color = "RED"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC					            = { Type = "SpellSingleColor", ID = 88625,  	Hidden = true,  Color = "RED"	    , Desc = "[1] AntiFakeCC",      QueueForbidden = true	},

    --Priest General
	DesperatePrayer                       = { ID = 19236     },
	Fade                                  = { ID = 586       },
	FlashHeal                             = { ID = 2061 		},
	MindBlast                             = { ID = 8092      },
	PowerWordFortitude                    = { ID = 21562     },
	PowerWordShield                       = { ID = 17,       },
	PsychicScream                         = { ID = 8122      },
	Resurrection                          = { ID = 2006      },
	ShadowWordPain                        = { ID = 589       },
	Smite                                 = { ID = 585, Texture = 385728       },
	Levitate                              = { ID = 1706      },
	MindVision                            = { ID = 2096      },
	MindSoothe                            = { ID = 453       },
	Renew                                 = { ID = 139 		},
	DispelMagic                           = { ID = 528       },
	Shadowfiend                           = { ID = 34433, Texture = 434722		},
	PrayerOfMending                       = { ID = 33076 	},
	PrayerOfMendingBuff                   = { ID = 41635		},
	ShadowWordDeath                       = { ID = 32379     },
	HolyNova                              = { ID = 132157    },
	AngelicFeather                        = { ID = 121536    },
	LeapofFaith                           = { ID = 73325     },
	ShackleUndead                         = { ID = 9484      },
	DominateMind                          = { ID = 205364    },
	MindControl                           = { ID = 605       },
	VoidTendrils                          = { ID = 108920    },
	MassDispel                            = { ID = 32375     },
	PowerInfusion                         = { ID = 10060     },
	VampiricEmbrace                       = { ID = 15286     },
	DivineStar                            = { ID = 110744,   },
	DivineStarShadow                      = { ID = 122121,   },
	Halo                                  = { ID = 120517,   },
	Mindgames                             = { ID = 375901,   },
	VoidShift                             = { ID = 108968,   },
	PowerWordLife                         = { ID = 373481	},
	FaeGuardians                    	  = { ID = 327694    },
	DirectMask                    	  	  = { ID = 356532    },

	--Discipline Specific
	Evangelism							  = { ID = 246287 	},
	LightsWrath							  = { ID = 373178	},
	Mindbender							  = { ID = 123040, Texture = 434722	},
	PowerWordSolace						  = { ID = 129250 	},
	PurgetheWicked						  = { ID = 204197 	},
	Purify								  = { ID = 527 		},
	Penance								  = { ID = 47540 	},
	PenanceDMG 							  = { ID = 47540, Texture = 23018, Hidden = true  },
	PowerWordRadiance					  = { ID = 194509 	},
	MassResurrection					  = { ID = 212036 	},
	PainSuppression						  = { ID = 33206     },
	Rapture								  = { ID = 47536 	},
	PowerWordBarrier					  = { ID = 62618 	},
	SurgeofLightBuff                      = { ID = 114255	},
	TEHoly								  = { ID = 390706    },
	TEShadow							  = { ID = 390707    },
	TwilightEquilibrium					  = { ID = 390705    }, 
	DarkReprimant					  	  = { ID = 400169, Texture = 47540   },

	--OLD STUFF
	MindSear							  = { ID = 48045 										},
	ShadowMend							  = { ID = 186263 										},
	Atonement							  = { ID = 194384, Hidden = true 							},
	MasteryGrace						  = { ID = 271534, Hidden = true 						},
	PoweroftheDarkSide					  = { ID = 198068, Hidden = true 						},
	PoweroftheDarkSide4T				  = { ID = 198069, Hidden = true 						},
	Castigation							  = { ID = 193134, Hidden = true 						},
	TwistofFate							  = { ID = 265259, Hidden = true							},
	BodyandSoul							  = { ID = 64129, Hidden = true 							},
	Masochism							  = { ID = 193063, Hidden = true 						},
	ShieldDiscipline					  = { ID = 197045, Hidden = true 						},
	PsychicVoice						  = { ID = 196704, Hidden = true 						},
	DominantMind						  = { ID = 205367, Hidden = true 						},
	ShiningForce						  = { ID = 204263 										},
	SinsoftheMany						  = { ID = 280391, Hidden = true 						},
	Contrition							  = { ID = 197419, Hidden = true 						},
	Lenience							  = { ID = 238063, Hidden = true 						},
	SpiritShell							  = { ID = 109964										},
	Purification						  = { ID = 196162, Hidden = true 						},
	PurifiedResolve						  = { ID = 196439, Hidden = true 						},
	Trinity								  = { ID = 214205, Hidden = true 						},
	StrengthofSoul						  = { ID = 197535, Hidden = true 						},
	UltimatePenitence					  = { ID = 421453, Texture = 68992 },
	DomeofLight							  = { ID = 197590, Hidden = true 						},
	Archangel							  = { ID = 197862 										},
	DarkArchangel						  = { ID = 197871 										},
	Thoughtsteal						  = { ID = 316262 										},
	SearingLight						  = { ID = 215768, Hidden = true 						},
	InnerLight						      = { ID = 355897										},
	InnerShadow						      = { ID = 355898										},
	PentinentBuff						  = { ID = 336011										},
	WeakenedSoul						  = { ID = 6788, Hidden = true 							},
	TrainOfThought						  = { ID = 390693, Hidden = true 						},
	Rhapsody						  	  = { ID = 390622, Hidden = true 						},
	InescapableTorment					  = { ID = 373427, Hidden = true 						},
	BenevolentFaerie                      = { ID = 327710	},
	PhaseShift					  	      = { ID = 408557 	},
	LuminousBarrier					  	  = { ID = 271466, Texture = 62618 	},
	Schism					  			  = { ID = 424509, Hidden = true 						},
	Voidwraith					  	      = { ID = 451235, Texture = 434722 	},
	Voidblast					  	      = { ID = 450215, Texture = 385728 	},

	--Improved Dispel
	ImprovedDispelTalent                  = { ID = 390632, Hidden = true  },

    PremonitionBundle                    = { ID = 428924, Texture = 291944, Hidden = true }, --Regneratin
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function createAction(attributes)
    return Action.Create({
        Type = attributes.Type or "Spell",
        ID = attributes.ID,
        Texture = attributes.Texture,
        MAKULU_INFO = attributes.MAKULU_INFO,
        Hidden = attributes.Hidden,
    })
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local A = {}
for name, attributes in pairs(ActionID) do
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

Action[ACTION_CONST_PRIEST_DISCIPLINE] = A
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

local function handleInterrupts(enemiesList)
    local _, _, _, lagWorld = GetNetStats()
    local interruptSpells = {
        {spell = A.HolyWordChastise, minPercent = 50, isCC = true},
    }

    if A.Zone == "arena" or A.Zone == "pvp" then return end

    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        for _, spellInfo in ipairs(interruptSpells) do
            local shouldInterrupt = enemy:PvEInterrupt(spellInfo.spell, spellInfo.minPercent, spellInfo.minEndTime, spellInfo.isCC, spellInfo.aoe)
            if shouldInterrupt == "Switch" and not spellInfo.aoe then
                Aware:displayMessage("Switching to " .. enemy.name .. " to interrupt", "White", 2.5)
                return "Switch"
            elseif shouldInterrupt == true then
                Aware:displayMessage("Interrupting " .. enemy.name, "White", 2.5)
                return spellInfo.spell
            end
        end
    end

    return nil
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)
    if A.Zone == "arena" or thisUnit.realHP < 35 then return end

    local unitID = thisUnit.Unit
    local Role = thisUnit.Role

    if not A.Purify:IsReadyByPassCastGCD(unitID) or Unit(unitID):IsDebuffUp(AvoidDispelTable) then return end

    local shouldDispel = thisUnit.useDispel and not QueueOrder.useDispel[Role] and
        (AuraIsValid(unitID, "UseDispel", "Magic") or Unit(unitID):IsDebuffUp(MagicDispelTable))

    if A.ImprovedDispelTalent:IsTalentLearned() then
        shouldDispel = shouldDispel or
            AuraIsValid(unitID, "UseDispel", "Disease") or Unit(unitID):IsDebuffUp(DiseaseDispelTable)
    end

    if not shouldDispel then return end

    QueueOrder.useDispel[Role] = true

    local offset, hpReduction
    if thisUnit.isSelf then
        offset, hpReduction = db.OffsetSelfDispel, 80
    elseif Role == "HEALER" then
        offset, hpReduction = db.OffsetHealersDispel, 70
    elseif Role == "TANK" then
        offset, hpReduction = db.OffsetTanksDispel, 50
    else
        offset, hpReduction = db.OffsetDamagersDispel, 60
    end

    thisUnit:SetupOffsets(offset, thisUnit.realHP - hpReduction)
end)

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

--################################################################################################################################################################################################################

local function CanPowerInfusion()
    if combatTime == 0 then return false end

    local pitarget = GetToggle(2, "PowerInfusionDropdown")
    local partyUnits = { "party1", "party2", "party3", "party4" }

    for i = 1, #getmembersAll do
        local unitID = getmembersAll[i].Unit
        local isReady = A.PowerInfusion:IsReadyByPassCastGCD(unitID)
        local hasDamageBuff = Unit(unitID):IsBuffUp(PiTable)
        local hasNoPiDebuff = Unit(unitID):IsBuffDown(A.PowerInfusion.ID, true)
        local isNotTank = not Unit(unitID):Role("TANK")
        local canPI = isReady and hasNoPiDebuff and hasDamageBuff and isNotTank

        if pitarget == "All" or pitarget == unitID then
            for _, partyUnit in ipairs(partyUnits) do
                if UnitIsUnit(unitID, partyUnit) and canPI then
                    HealingEngine.SetTarget(unitID)
                    return true
                end
            end
        end
    end

    return false
end

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PowerWordFortitude
PowerWordFortitude:Callback('PreCombat', function(spell)
    if player:HasBuff(A.PowerWordFortitude.ID) then return end

    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Purify
Purify:Callback('Dispel', function(spell)
    if A.Zone == "arena" then return end
    if unit:Health() < 35 then return end
    if unit:HasDeBuff(AvoidDispelTable) then return end

    local hasImprovedDispel = A.ImprovedDispelTalent:IsTalentLearned()
    local shouldDispel = AuraIsValid("focus", "UseDispel", "Magic") or unit:HasDeBuff(MagicDispelTable)

    if hasImprovedDispel then
        shouldDispel = shouldDispel or AuraIsValid("focus", "UseDispel", "Disease") or unit:HasDeBuff(DiseaseDispelTable)
    end

    if not shouldDispel then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### EMERGENCY SINGLE TARGET COOLDOWN ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VoidShift
VoidShift:Callback('Emergency', function(spell)
    if combatTime == 0 then return end
    if unit.hp > 35 then return end
    if player.hp < 60 then return end
    if not unit:IsPlayer() then return end

    return spell:Cast(unit)
end)

-- PainSuppression
PainSuppression:Callback('Emergency', function(spell)
    if combatTime == 0 then return end
	if unit.hp > 35 then return end
	if Unit("focus"):IsBuffUp(A.PainSuppression.ID) or Unit("player"):IsBuffUp(A.Rapture.ID) then return end
    if not unit:IsPlayer() then return end

    return spell:Cast(unit)
end)

-- Rapture
Rapture:Callback('Emergency', function(spell)
    if combatTime == 0 then return end
	if unit.hp > 55 then return end
	if Unit("focus"):IsBuffUp(A.PainSuppression.ID) or Unit("player"):IsBuffUp(A.Rapture.ID) then return end
    if not unit:IsPlayer() then return end

    return spell:Cast(unit)
end)

-- PowerWordShield + Rapture
PowerWordShield:Callback('Rapture', function(spell)
	if unit:Buff(A.PowerWordShield.ID) then return end
	if not player:Buff(A.Rapture.ID) then return end

    if GetToggle(2, "SpreadRapture") then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.PowerWordShield:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.PowerWordShield.ID, true) then
                HealingEngine.SetTarget(unitID)
				return spell:Cast(unit)
            end
        end
    end

    return spell:Cast(unit)
end)

-- PremonitionBundle
PremonitionBundle:Callback('HealingPve', function(spell)
    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### RACIALS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanUseRacialAbility()
    return A.GetToggle(1, "Racial") and CanUseHealingCooldowns()
end

local function UseRacialAbility(spell)
    if not CanUseRacialAbility() then
        return false
    end
    return spell:Cast(player)
end

-- BloodFury
BloodFury:Callback('Racials', function(spell)
    return UseRacialAbility(spell)
end)

-- Berserking
Berserking:Callback('Racials', function(spell)
    return UseRacialAbility(spell)
end)

-- Fireblood
Fireblood:Callback('Racials', function(spell)
    return UseRacialAbility(spell)
end)

-- AncestralCall
AncestralCall:Callback('Racials', function(spell)
    return UseRacialAbility(spell)
end)

-- BagOfTricks
BagOfTricks:Callback('Racials', function(spell)
    return UseRacialAbility(spell)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### COOLDOWNS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function MajorCooldownIsActive()
    return not player:Buff(A.UltimatePenitence.ID, true) and not player:Buff(A.LuminousBarrier.ID, true) and not player:Buff(A.PowerWordBarrier.ID, true)
end

local function HandleHealingCooldowns(spell)
    if MajorCooldownIsActive() then return end
    if not CanUseHealingCooldowns() then return end

    return spell:Cast(player)
end

-- UltimatePenitence
UltimatePenitence:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell)
end)

-- LuminousBarrier
LuminousBarrier:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell)
end)

-- PowerWordBarrier
PowerWordBarrier:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell)
end)

-- PowerInfusion
PowerInfusion:Callback('Cooldowns', function(spell)
    if not CanPowerInfusion() then return end
    if unit.hp < 45 then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD HEALING PVE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PowerWordLife
PowerWordLife:Callback('HealingPve', function(spell)
    if unit.hp > 35 then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('Freecast', function(spell)
    if not player:Buff(114255) then return end
    if not AutoHeal(unit, A.FlashHeal) then return end

    return spell:Cast(unit)
end)

-- PrayerOfMending
PrayerOfMending:Callback('HighPrio', function(spell)
    if GetToggle(2, "PrayerofMendingMenu") ~= "1" then return end
    if unit:Buff(A.PrayerOfMendingBuff.ID) then return end
    if not AutoHeal(unit, A.PrayerOfMending) then return end

    return spell:Cast(unit)
end)

-- PowerWordRadiance 1 Charge
PowerWordRadiance:Callback('Charges1', function(spell)
	if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if A.PowerWordRadiance:GetSpellTimeSinceLastCast() < 8 then return end

    local charges = A.PowerWordRadiance:GetSpellCharges()
    if charges == 0 or charges == 2 then return end

	local _1ChargeSlider = GetToggle(2, "PowerWordRadiance1Charge")
    if not AutoHealOrSlider(unit, A.PowerWordRadiance, _1ChargeSlider) then return end

    return spell:Cast(unit)
end)

-- PowerWordRadiance 2 Charge
PowerWordRadiance:Callback('Charges2', function(spell)
	if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if A.PowerWordRadiance:GetSpellTimeSinceLastCast() < 8 then return end

    local charges = A.PowerWordRadiance:GetSpellCharges()
    if charges == 0 or charges == 1 then return end

	local _1ChargeSlider = GetToggle(2, "PowerWordRadiance2Charge")
    if not AutoHealOrSlider(unit, A.PowerWordRadiance, _1ChargeSlider) then return end

    return spell:Cast(unit)
end)

-- Halo
Halo:Callback('HealingPve', function(spell)
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

-- Penance
Penance:Callback('HealingPve', function(spell)
    local Penanceslider = GetToggle(2, "PenanceHealSlider")
    if not AutoHealOrSlider(unit, A.Penance, Penanceslider) then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('HealingPve', function(spell)
    local FlashHealslider = GetToggle(2, "FlashHealSlider")
    if not AutoHealOrSlider(unit, A.FlashHeal, FlashHealslider) then
        return
    end

    return spell:Cast(unit)
end)

local function SpreadPowerWordShield()
    if GetToggle(2, "SpreadPWS") then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.PowerWordShield:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.PowerWordShield.ID, true) and Unit(unitID):IsBuffDown(A.Atonement.ID, true) then
                HealingEngine.SetTarget(unitID)
                return true
            end
        end
    end
end

-- PowerWordShield
PowerWordShield:Callback('HealingPve', function(spell)
	if SpreadPowerWordShield() then return spell:Cast(unit) end

	if GetToggle(2, "AtonementCheck") and unit:Buff(A.Atonement.ID) then return end
	if unit:Buff(A.PowerWordShield.ID) then return end
	if GetToggle(2, "PwsTank") and Unit("focus"):Role("TANK") then return spell:Cast(unit) end

    local PowerWordShieldslider = GetToggle(2, "PowerWordShieldSlider")
    if not AutoHealOrSlider(unit, A.PowerWordShield, PowerWordShieldslider) then return end

    return spell:Cast(unit)
end)

-- PrayerOfMending
PrayerOfMending:Callback('LowPrioAndMoving', function(spell)
    local menuOption = GetToggle(2, "PrayerofMendingMenu")

    if menuOption == "2" then
        if unit:Buff(A.PrayerOfMendingBuff.ID) then return end
    elseif menuOption == "3" then
        if isStaying or unit:Buff(A.PrayerOfMendingBuff.ID) then return end
    else
        return
    end

    if not AutoHeal(unit, A.PrayerOfMending) then return end

    return spell:Cast(unit)
end)

local function SpreadRenew()
    if GetToggle(2, "SpreadPWS") then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.Renew:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.Renew.ID, true) and Unit(unitID):IsBuffDown(A.Atonement.ID, true) then
                HealingEngine.SetTarget(unitID)
                return true
            end
        end
    end
end

-- Renew
Renew:Callback('AlwaysAndMoving', function(spell)
	if SpreadRenew() then return spell:Cast(unit) end
	if GetToggle(2, "AtonementCheck") and unit:Buff(A.Atonement.ID) then return end
	
    local menuOption = GetToggle(2, "RenewMenu")

    if menuOption == "1" then
        if unit:Buff(A.Renew.ID) then return end
    elseif menuOption == "2" then
        if isStaying or unit:Buff(A.Renew.ID) then return end
    elseif menuOption == "3" then
        if unit:Buff(A.Atonement.ID) then return end
    else
        return
    end

    local Renewslider = GetToggle(2, "RenewSlider")
    if not AutoHealOrSlider(unit, A.Renew, Renewslider) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL DAMAGE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanAttackTarget()
    return target.exists and not target.isFriendly and target.canAttack
end

local function CheckTimetoDie()
	return Unit("target"):TimeToDie() < 5
end

local function HandleMindbenderLogic(spell)
	if not CanAttackTarget() then return end
    if combatTime == 0 then return end

    local mindbenderMenuOption = GetToggle(2, "MindbenderMenu")

    if mindbenderMenuOption == "1" then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "2" and CanUseHealingCooldowns() then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "3" and unit.hp <= GetToggle(2, "MindbenderSlider") then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "4" and (CanUseAoeHealing() or unit.hp <= GetToggle(2, "MindbenderSlider")) then
        return spell:Cast(target)
    end
end

-- Shadowfiend
Shadowfiend:Callback('DamagePve', function(spell)
    return HandleMindbenderLogic(spell)
end)

-- Mindbender
Mindbender:Callback('DamagePve', function(spell)
    return HandleMindbenderLogic(spell)
end)

-- Voidwraith
Voidwraith:Callback('DamagePve', function(spell)
    return HandleMindbenderLogic(spell)
end)

-- ShadowWordDeath
ShadowWordDeath:Callback('MindbenderPrio', function(spell)
	if not CanAttackTarget() then return end
    if A.Shadowfiend:GetSpellTimeSinceLastCast() < 12 or A.Mindbender:GetSpellTimeSinceLastCast() < 12 or A.Voidwraith:GetSpellTimeSinceLastCast() < 12 then 
		return spell:Cast(target) 
	end
end)

-- ShadowWordDeath
ShadowWordDeath:Callback('DamagePve', function(spell)
    if target.hp > 35 then return end

    return spell:Cast(target)
end)

-- Voidblast
Voidblast:Callback('DamagePve', function(spell)
    return spell:Cast(target)
end)

-- HolyNova
HolyNova:Callback('DamagePve', function(spell)
    if player:HasBuffCount(390636) < 15 then return end
    if MultiUnits:GetByRange(8) < GetToggle(2, "HolyNovaSlider") then return end

    return spell:Cast(target)
end)

-- ShadowWordPain
ShadowWordPain:Callback('DamagePve', function(spell)
    if target:DebuffRemains(589) >= 3000 or target:DebuffRemains(204213) >= 3000 then return end
	--if CheckTimetoDie() then return end

    return spell:Cast(target)
end)

-- MindBlast
MindBlast:Callback('DamagePve', function(spell)
	if gameState.imCasting and gameState.imCasting == spell.spellId then return end
	if not CanAttackTarget() then return end
	if target:DebuffRemains(204213) < 3000 or combatTime == 0 then return end
	--if CheckTimetoDie() then return end

    return spell:Cast(target)
end)

-- PenanceDMG
PenanceDMG:Callback('DamagePve', function(spell)
	if not CanAttackTarget() then return end
	if target:DebuffRemains(204213) < 3000 or combatTime == 0 then return end
	--if A.Voidblast:IsReady() then return end
	--if CheckTimetoDie() then return end
 
    return spell:Cast(target)
end)

-- DivineStar
DivineStar:Callback('DamagePve', function(spell)
    if combatTime == 0 then return end
    if Unit("target"):GetRange() > 30 then return end

    return spell:Cast(target)
end)

-- Smite
Smite:Callback('DamagePve', function(spell)
    return spell:Cast(target)
end)

--################################################################################################################################################################################################################

local function Untilities()

end

local function PreCombat()
	PowerWordFortitude('PreCombat')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SelfDefensive()

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function HealerRotationPve()
    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end

    Purify('Dispel')

    VoidShift('Emergency')
	PainSuppression('Emergency')
	Rapture('Emergency')
	PowerWordShield('Rapture')

    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')

	UltimatePenitence('Cooldowns')
	LuminousBarrier('Cooldowns')
	PowerWordBarrier('Cooldowns')
	PowerInfusion('Cooldowns')
	PremonitionBundle('HealingPve') 

	ShadowWordDeath('MindbenderPrio')
	Shadowfiend('DamagePve')
	Mindbender('DamagePve')
	Voidwraith('DamagePve')

	PowerWordLife('HealingPve')
	FlashHeal('Freecast')

	PowerWordRadiance('Charges2')
    PrayerOfMending('HighPrio')
    Halo('HealingPve')
	PowerWordRadiance('Charges1')
	
	PowerWordShield('HealingPve')
	Penance('HealingPve')

	MindBlast('DamagePve')
	PenanceDMG('DamagePve')

	FlashHeal('HealingPve')
    PrayerOfMending('LowPrioAndMoving')
    Renew('AlwaysAndMoving')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
    if Player:ManaPercentage() <= GetToggle(2, "ManaTresholdDpsSlider") then return end

    ShadowWordDeath('DamagePve')
	Voidblast('DamagePve')
	HolyNova('DamagePve')
    ShadowWordPain('DamagePve')
	MindBlast('DamagePve')
	PenanceDMG('DamagePve')
	DivineStar('DamagePve')
    Smite('DamagePve')
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

    --[[
    local enemiesList = MakEnemies.get()
    local shouldInterrupt = handleInterrupts(enemiesList)
    if shouldInterrupt then
        if shouldInterrupt == "Switch" then
            return A.TargetEnemy:Show(icon)
        else
            return shouldInterrupt:Show(icon)
        end
    end
    ]]

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--Utilities
    Untilities()

     --PreCombat/Defensives
    if combatTime == 0 then
        PreCombat()
    else
        SelfDefensive()
    end

    --Healing Rotation PVE
    if (target.exists or focus.exists) then
        HealerRotationPve()
    end

    --Damage Rotation PVE
    if target.exists and target.canAttack then
        DamageRotationPve()
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
	if not enemy.exists then return end

end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    if not friendly.exists then return end

end

--################################################################################################################################################################################################################

A[6] = function(icon)
    --Multi Dot
    --if GetToggle(2, "SpreadDot") and not Unit("target"):IsBoss() and Unit("target"):HasDeBuffs(A.ShadowWordPain.ID, true) > 0 and (Player:GetDeBuffsUnitCount(A.ShadowWordPain.ID, true) < MultiUnits:GetActiveEnemies()) then
       -- return A.TargetEnemy:Show(icon)
    --end

	RegisterIcon(icon)
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
