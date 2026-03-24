-- For Later (Check if spec in group)
-- MultiUnits.party:Any(function(unit) return unit.spec == assaSpecId)


if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 257 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local Debounce         = MakuluFramework.debounceSpell
local DebounceFunc     = MakuluFramework.debounce
local Aware            = MakuluFramework.Aware
local as               = MakuluFramework.ArenaState
local cacheContext     = MakuluFramework.Cache
local Events           = MakuluFramework.Events
local DRList           = LibStub("DRList-1.0")

-- Helper function to get DR for a cast/channel spell
local function CastDr(castInfo, unit)
    if not castInfo or not castInfo.spellId then return 1 end
    local category = DRList:GetCategoryBySpellID(castInfo.spellId)
    if not category then return 1 end
    local categoryName = DRList:GetCategoryLocalization(category)
    if not categoryName then return 1 end
    return MakuluFramework.DR.Get(categoryName, rawget(unit, "guid")) or 1
end

-- Helper function for raw DR check (used in line 360)
local function CastDrRaw(spellId, unit)
    if not spellId then return 1 end
    local category = DRList:GetCategoryBySpellID(spellId)
    if not category then return 1 end
    local categoryName = DRList:GetCategoryLocalization(category)
    if not categoryName then return 1 end
    return MakuluFramework.DR.Get(categoryName, rawget(unit, "guid")) or 1
end

-- Helper function to count dispellable buffs on a unit
local function BuffDispelCount(unit)
    local count = 0
    local buffs = unit:GetBuffs()
    if not buffs then return 0 end

    for _, buff in pairs(buffs) do
        if buff.dispelName == "Magic" then
            count = count + 1
        end
    end

    return count
end


local constCell        = cacheContext:getConstCacheCell()

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
local MakLists         = MakuluFramework.lists

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
	DesperatePrayer                       = { ID = 19236, MAKULU_INFO = { heal = true, targeted = false }      },
	Fade                                  = { ID = 586, MAKULU_INFO = { targeted = false, ignoreCasting = true, offGcd = true, stopCasting = true }       },
	FlashHeal                             = { ID = 2061, MAKULU_INFO = { heal = true }      },
    Heal                                  = { ID = 2060, MAKULU_INFO = { heal = true }       },
	--FlashHeal                             = { ID = 2061, offGcd = true, ignoreCasting = true      },
    --Heal                                  = { ID = 2060, offGcd = true, ignoreCasting = true      },
	MindBlast                             = { ID = 8092, MAKULU_INFO = { damageType = "magic" }   },
	PowerWordFortitude                    = { ID = 21562, MAKULU_INFO = { heal = true }      },
	PowerWordShield                       = { ID = 17, MAKULU_INFO = { heal = true }         },
	PsychicScream                         = { ID = 8122, MAKULU_INFO = { cc = true }       },
	Resurrection                          = { ID = 2006, MAKULU_INFO = { heal = true }      },
	ShadowWordPain                        = { ID = 589, MAKULU_INFO = { damageType = "magic" }       },
	Smite                                 = { ID = 585, MAKULU_INFO = { damageType = "magic" }       },
	Levitate                              = { ID = 1706, MAKULU_INFO = { heal = true }      },
	MindVision                            = { ID = 2096      },
	MindSoothe                            = { ID = 453       },
	Renew                                 = { ID = 139, MAKULU_INFO = { heal = true }        },
	DispelMagic                           = { ID = 528, MAKULU_INFO = { damageType = "magic" }        },
	Shadowfiend                           = { ID = 34433, MAKULU_INFO = { targeted = false }	 },
	PrayerOfMending                       = { ID = 33076, MAKULU_INFO = { heal = true }     },
	PrayerOfMendingBuff                   = { ID = 41635, Hidden = true		},
	ShadowWordDeath                       = { ID = 32379, MAKULU_INFO = { damageType = "magic", ignoreCasting = true, offGcd = true }     },
	HolyNova                              = { ID = 132157    },
	AngelicFeather                        = { ID = 121536, MAKULU_INFO = { heal = true, mo = true }    },
	LeapofFaith                           = { ID = 73325     },
	ShackleUndead                         = { ID = 9484      },
	DominateMind                          = { ID = 205364    },
	MindControl                           = { ID = 605       },
	VoidTendrils                          = { ID = 108920, MAKULU_INFO = { targeted = false }    },
	MassDispel                            = { ID = 32375     },
	PowerInfusion                         = { ID = 10060, MAKULU_INFO = { heal = true }     },
	VampiricEmbrace                       = { ID = 15286     },
	DivineStar                            = { ID = 110744    },
	Halo                                  = { ID = 120517    },
	Mindgames                             = { ID = 375901    },
    VoidShift                             = { ID = 108968, MAKULU_INFO = { ignoreCasting = true, heal = true, offGcd = true } },
	PowerWordLife                         = { ID = 373481, MAKULU_INFO = { heal = true }	 },
    PowerWordLifeToo                      = { ID = 440678, MAKULU_INFO = { heal = true, ignoreResource = true, ignoreCasting = true  }	 },

    -- Holy Specific
	Apotheosis                            = { ID = 200183, MAKULU_INFO = { offGcd = true, targeted = false, heal = true }    },
	DivineWord                            = { ID = 372760	 },
	EmpyrealBlaze                         = { ID = 372616    },
	EmpyrealBlazeBuff                     = { ID = 372617, Hidden = true	},
	Lightwell                             = { ID = 372835    },
	Purify                                = { ID = 527, MAKULU_INFO = { heal = true }       },
	HolyWordSerenity                      = { ID = 2050, MAKULU_INFO = { heal = true }      },
	HolyFire                              = { ID = 14914, MAKULU_INFO = { damageType = "magic" }     },
	HolyWordChastise                      = { ID = 88625, MAKULU_INFO = { damageType = "magic", cc = true }     },
	HolyWordSalvation                     = { ID = 265202, MAKULU_INFO = { heal = true }    },
	GuardianSpirit                        = { ID = 47788, MAKULU_INFO = { offGcd = true, ignoreCasting = true, heal = true } },
	PrayerofHealing                       = { ID = 596, MAKULU_INFO = { heal = true }        },
	MassResurrection                      = { ID = 212036, MAKULU_INFO = { targeted = false }    },
	HolyWordSanctify                      = { ID = 34861, MAKULU_INFO = { heal = true, mo = true }      },
	-- HolyWordSanctifyMO                    = { ID = 34861, Texture = 1706, Hidden = false,  MAKULU_INFO = { heal = true, mo = true }    },
    DivineHymn                            = { ID = 64843, MAKULU_INFO = { targeted = false }     },
	SymbolofHope                          = { ID = 64901, MAKULU_INFO = { targeted = false }     },
	LightweaverTalent                     = { ID = 390992, Hidden = true    },
    LightweaverBuff                       = { ID = 390993, Hidden = true    },

    GreaterHeal                           = { ID = 289666, MAKULU_INFO = { heal = true }    },
    SurgeofLight                          = { ID = 109186	},
    SurgeofLightBuff                      = { ID = 114255	},
    PrayerCircle                          = { ID = 321377	},

    -- Hero
    MiraculousRecovery                    = { ID = 440674, Hidden = true  },

    -- PvP Talents
    HolyWard                              = { ID = 213610, MAKULU_INFO = { targeted = false, stopCasting = true, offGcd = true }    },
    HolyWordConcentration                 = { ID = 289657    },
    SpiritoftheRedeemer                   = { ID = 215769, { targeted = false }, Macro = "/cast Spirit of Redemption(PvP Talent)"    },
    RayofHope                             = { ID = 197268, MAKULU_INFO = { heal = true }    },
    GreaterFade                           = { ID = 213602    },
    CircleofHealing                       = { ID = 204883    },
    Thoughtsteal                          = { ID = 316262    },
    DivineAscension                       = { ID = 328530    },
	DivineImage                           = { ID = 405963, Hidden = true 	},
	SpiritofRedemption                    = { ID = 27827, Hidden = true 	},
	ResonantWords					  	  = { ID = 372313, Hidden = true 	},
	PhaseShift					  	      = { ID = 408557 	},
	Epiphany					  	      = { ID = 414553 	},

	--Improved Dispel
	ImprovedDispelTalent                  = { ID = 390632, Hidden = true  },

    PremonitionBundle                     = { ID = 428924, FixedTexture = 5927640, Hidden = false, Macro = "/cast Premonition", MAKULU_INFO = { targeted = false, offGcd = true } },
    TranslucentImage   		  	          = { ID = 373446, Hidden = true 	},
    EternalSanctity   		  	          = { ID = 1215245, Hidden = true 	},
    EmpoweredRenew   		  	          = { ID = 391339, Hidden = true 	},

    --Infa adds for Arena
    PremonitionofInsightArena = { ID = 428933, Hidden = false, Macro = "/cast Premonition", MAKULU_INFO = { targeted = false, offGcd = true } }, 
    PremonitionofPietyArena = { ID = 428930, Hidden = false, Macro = "/cast Premonition", MAKULU_INFO = { targeted = false, offGcd = true } },
    PremonitionofSolaceArena = { ID = 428934, Hidden = false, Macro = "/cast Premonition", MAKULU_INFO = { targeted = false, offGcd = true }  },
    PremonitionofClairvoyanceArena = { ID = 440725, Hidden = false, Macro = "/cast Premonition", MAKULU_INFO = { targeted = false, offGcd = true }  },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CreateAction = _G.CreateAction  -- Get the global CreateAction function

local A = {}
for name, attributes in pairs(ActionID) do
    A[name] = CreateAction(attributes)
end
for name, attributes in pairs(ConstSpells) do
    A[name] = CreateAction(attributes)
end
A = setmetatable(A, { __index = Action })

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local buildMakuluFrameworkSpells = function()
	local result = {}
    local keys = {}
    for k, v in pairs(A) do
        keys[k] = v
    end

	for k, v in pairs(keys) do
		result[k] = MakSpell:new(v.ID, v.MAKULU_INFO, v, {A = A, K = k})
	end
	return result
end
local M = buildMakuluFrameworkSpells()

Action[ACTION_CONST_PRIEST_HOLY] = A
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
    empyrealblaze = 372617,
    feather = 121557,
    apotheosis = 200183,
    insurance = 1215349,
    answeredPrayers = 394289,
    spiritOfRedemption = 215982,
    spiritOfTheRedeemer = 215769,
    fromDarkness = 390617,
    prayerOfMending = 41635,
    renew = 139,
    resonating = 372313,
    surgeOfLight = 114255,
    guardian = 47788,
    rayofHopeHigh = 232707,
    rayofHopelow = 232708,

    premInsight = 428933,
    premPiety = 428930,
    premSolace = 428934,

    solaceBuff = 443526,
    wasteNoTime = 440683
}

local kickPercent = 32
local meldDuration = 0.9
local fastReact = 400 / 1000
local shortHalfSecond = 620
local channelKickTime = 400
local swdOffset = 600
local quickKick = 15
local cdDelay = 100
local prepDelay = 1000

local function generateNewRandomKicks()
    kickPercent = math.random(40, 90)
    meldDuration = math.random(600, 1200) / 1000
    fastReact = math.random(250, 350) / 1000
    shortHalfSecond = math.random(400, 800)
    swdOffset = math.random(450, 700)
    channelKickTime = math.random(300, 800)
    quickKick = math.random(10, 20)
    cdDelay = math.random(600, 2500)
    prepDelay = math.random(500, 1500)

    return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()

local isStaying
local stayingTime
local movingTime
local isMoving
local combatTime
local playerHealth
local inMeleeRange

local debuffs = {

}

local function cdsLessThan(lessThan)
    if as.enemyCdRemains <= 0 then return false end

    return as.enemyCdRemains <= lessThan
end



local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = nil,
    imCastingLength = nil,
}

local function getBelowHP(percent)
    return MakMulti.party:Count(function(units)
        return FlashHeal:InRange(units) and units.hp < percent and units.hp > 0
    end)
end

local deathTried = 0

local castedRenewTrack = {}
local bigRenewTracker = {}
local playerDamageTaken = 0

local rayTarget = nil
local rayDelta = 0

local tryFadeTime = 0
local fadeUnit = nil
local tryDeathTime = 0

Events.registerReset(function()
    castedRenewTrack = {}
    bigRenewTracker = {}
    playerDamageTaken = 0

    rayTarget = nil
    rayDelta = 0
end)

local tryDodgeList = MakuluFramework.AtoL({
    "Mortal Coil",
    --"Storm Bolt",
    "Death Grip",
    "Wild Charge",
    "Shadowstep",
    "Charge"
})

local function combatLog(_, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool,
        casterGUID, casterName, casterFlags, casterRaidFlags, absorbSpellId, absorbSpellName, absorbSpellSchool, amount, critical = CombatLogGetCurrentEventInfo()

    if subevent == "SPELL_DAMAGE" and destGUID == player.guid then
        playerDamageTaken = GetTime()
        return
    end

    if subevent == "SPELL_CAST_SUCCESS" and sourceGUID and sourceName then
        local caster = MakUnit:newGUID(sourceGUID, sourceName)
        if not caster.isFriendly then
            if spellName == "Freezing Trap" and CastDrRaw(spellID, player) >= 0.5 then
                tryFadeTime = GetTime()
                fadeUnit = sourceGUID
                tryDeathTime = tryFadeTime
            end
            if spellName == "Harpoon" then
                tryFadeTime = GetTime() - 0.2
                tryDeathTime = tryFadeTime
            end

            if destGUID == player.guid and tryDodgeList[spellName] then
                tryFadeTime = GetTime() - 0.2
            end
        end
    end

    if spellID == 197268 and subevent == "SPELL_AURA_APPLIED" and sourceGUID == player.guid then
        rayTarget = destGUID
        print("Ray tracking started")
        rayDelta = 0
        return
    end
    
    if spellID == 197268 and subevent == "SPELL_AURA_REMOVED" then
        if rayTarget == destGUID then
            print("Ray tracking finished. Delta was: " .. rayDelta)
            rayDelta = 0
            rayTarget = nil
        end
        return
    end

    if (subevent == "SPELL_ABSORBED" or subevent == "SPELL_HEAL_ABSORBED") then
        if rayTarget and rayTarget ~= destGUID then return end

        local absorber = absorbSpellId
        local absorbAmount = amount
        if (subevent == "SPELL_HEAL_ABSORBED") then
            absorber = spellID
        elseif critical == nil then
            absorber = casterName
            absorbAmount = absorbSpellId -- If its a swing then lets account for it?
        end

        if absorber ~= 197268 then return end

        if subevent == "SPELL_ABSORBED" then
            rayDelta = rayDelta - absorbAmount
        else
            rayDelta = rayDelta + (absorbAmount * 1.5)
        end
        return
    end

    if sourceGUID ~= player.guid then return end
    if spellID ~= Renew.id then return end

    if subevent == "SPELL_CAST_SUCCESS" then
        castedRenewTrack[destGUID] = GetTime()
        bigRenewTracker[destGUID] = true
        return
    end

    if subevent == "SPELL_AURA_APPLIED" then
        local empowered = castedRenewTrack[destGUID]
        if empowered then
            if (GetTime() - empowered) < 0.5 then
                bigRenewTracker[destGUID] = true
            end
            castedRenewTrack[destGUID] = nil
        else
            bigRenewTracker[destGUID] = false
        end
        return
    end

    if subevent == "SPELL_AURA_REFRESH" then
        local empowered = castedRenewTrack[destGUID]
        if empowered then
            if (GetTime() - empowered) < 0.5 then
                bigRenewTracker[destGUID] = true
            end
            castedRenewTrack[destGUID] = nil
        end
        return 
    end
end

Events.register("COMBAT_LOG_EVENT_UNFILTERED", combatLog)

local function hasBigRenew(aUnit)
    if not aUnit or not aUnit:Buff(139) then return end

    return bigRenewTracker[aUnit.guid]
end

function MakUnit:HealthActual()
    return self.cache:GetOrSet("HealthActual", function()
        local delta = 0
        if rayTarget and rayTarget == rawget(self, "guid") then
            delta = rayDelta
        end

        return (UnitHealth(MakUnit.CallerId(self)) or 0) + delta
    end)
end

MakuluFramework.Unit.reindex()

local function holdCdOnRay(friend)
    local isRay = rayTarget and rayTarget == rawget(friend, "guid")
    if not isRay then return end
    return RayofHope.used > 4500 and RayofHope.used < 6500
end

local function getPartyList()
    return constCell:GetOrSet("partyList", function()
        local healable = MakMulti.party:Filter(function(friendly)
            return friendly.exists and not friendly.dead and friendly.distance < 50 and not friendly.healImmune
        end)

        local myOffset = 0
        if player.ehp > 30 then
            local total, _, _, _, cds = player:AttackersV69()
            if total < 2 and cds < 1 then
                myOffset = 40
            end
        end

        healable:Sort(function(a, b)
            return ((a.isMe and a.ehp + myOffset) or a.ehp) < ((b.isMe and b.ehp + myOffset) or b.ehp)
        end)

        return healable
    end)
end

local function getPartyCdList()
    return constCell:GetOrSet("partyList", function()
        local toHeal = getPartyList():Filter(function(friendly)
            return not friendly.isMe and friendly.cds
        end)

        toHeal:Sort(function(a, b)
            return a:CdsRemain() > b:CdsRemain()
        end)

        return toHeal
    end)
end

local function getArenaList()
    return constCell:GetOrSet("arenaList", function()
        local enemy = MakMulti.arena:Filter(function(arena)
            return arena.exists and not arena.dead and arena.distance < 50 and not arena.magicImmune
        end)

        enemy:Sort(function(a, b)
            return a.ehp < b.ehp
        end)

        return enemy
    end)
end


local function runForParty(spell, key)
    return getPartyList():ForEach(function (party)
        return spell(key, party)
    end)
end

local SpellInfo = C_Spell.GetSpellInfo

local spellInfoCache = {}

local function worthAvoiding(enemy, spell)
    local distance = enemy.distance

    -- We aint avoiding no mages loser. We gotta react here
    local specId = enemy.specId
    if specId == 62 or specId == 63 or specId == 64 then
        return true
    end

    if not enemy:Los() then return true end  -- If not in LoS, assume it's worth avoiding (they might be casting around corner)
    local maxRange = spellInfoCache[spell.spellId]
    if not maxRange then

        local info = SpellInfo(spell.spellId)
        if not info then
            print('Couldnt find info on spell: ' .. spell.spellId .. " returning we are in range")
            return true
        end

        maxRange = info.maxRange or info.minRange
        spellInfoCache[spell.spellId] = maxRange
    end

    if maxRange == 0 then
        print('Couldnt find range for spell: ' .. spell.spellId .. " returning we are in range")
        return true
    end

    local toAvoid = distance - 5 < maxRange
    if not toAvoid then
        print("Not worth avoiding distance is " .. distance .. " max range is " .. maxRange)
    end

    return toAvoid
end

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
    return incBigDmgIn() <= 2000 or incModDmgIn() <= 2000
end

local function defensiveActive()
    player = MakUnit:new("player")
    return player:HasBuff(buffs.barkskin, true) or player:HasBuff(buffs.ironbark, true)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive()
end

local function CanAttackTarget()
    return target.exists and not target.isFriendly and target.canAttack
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)

--     local unitID = thisUnit.Unit
--     local Role = thisUnit.Role

--     if Action.Zone == "arena" then
--         local unitA = MakUnit:new(unitID)

--         --Spirit of Redemption / Spirit of the Redeemer
--         if unitA:Buff(buffs.spiritOfRedemption) or unitA:Buff(buffs.spiritOfTheRedeemer) then
--             thisUnit.Enabled = false
--         else 
--             thisUnit.Enabled = true
--         end
--     end

--     if Action.Zone == "arena" or thisUnit.realHP < 35 then return end

--     -- Check if 'HE' should not be used based on certain conditions
--     if thisUnit.Enabled then 
--         local unit = Unit(unitID)
        
--         -- Condition: Player is mounted
--         local isPlayerMounted = Player:IsMounted()
        
--         -- Condition: Unit is out of range (> 40 yards)
--         local isUnitOutOfRange = unit:GetRange() > 40
        
--         -- Buff IDs for Spirit of Redemption and Spirit of Redeemer
--         local spiritOfRedemptionBuffID = 27827  -- Spirit of Redemption
--         local spiritOfRedeemerBuffID = 215769   -- Spirit of Redeemer
        
--         -- Condition: Unit has Spirit of Redemption or Spirit of Redeemer buff
--         local unitHasSpiritBuff = unit:IsBuffUp(spiritOfRedemptionBuffID) or unit:IsBuffUp(spiritOfRedeemerBuffID)
        
--         -- If any condition is true, disable 'thisUnit'
--         if isPlayerMounted or unitHasSpiritBuff then --
--             thisUnit.Enabled = false
--         end
--     end

--     local offset, hpReduction
--     if thisUnit.isSelf then
--         offset, hpReduction = db.OffsetSelfDispel, 80
--     elseif Role == "HEALER" then
--         offset, hpReduction = db.OffsetHealersDispel, 70
--     elseif Role == "TANK" then
--         offset, hpReduction = db.OffsetTanksDispel, 50
--     else
--         offset, hpReduction = db.OffsetDamagersDispel, 60
--     end

--     thisUnit:SetupOffsets(offset, thisUnit.realHP - hpReduction)
-- end)

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
                    -- -- HealingEngine.SetTarget(unitID)
                    return true
                end
            end
        end
    end

    return false
end

--################################################################################################################################################################################################################

local function holdGCDforSWDP()
    return constCell:GetOrSet("holdGcd", function()
        if Action.Zone ~= "arena" then return false end
        if ShadowWordDeath:Cooldown() > 1000 then return false end
        if IsPlayerSpell(PhaseShift.id) and Fade.used < 500 then return end
        if player:Buff(408558) then return end
        if player.magicImmune or player.ccImmune then return end

        if Fade.cd < 100 and unit.ehp < 30 and not unit.totalImmune then return end

        return MakMulti.arena:Any(function (enemy)
            if not enemy.exists then return end

            local castOrChannel = enemy.castOrChannelInfo
            if not castOrChannel then return end
            if not MakLists.swdList[castOrChannel.spellId] then return end
            if CastDr(castOrChannel, player) <= 0.25 then
                print("Not going to death this as DR is dead")
                return
            end

            if not worthAvoiding(enemy, castOrChannel) then return end
            if castOrChannel.remaining > MakuluFramework.maxGcd() + 200 then return end

            Aware:displayMessage("Holding GCD for SWD", "Priest", 1, GetSpellTexture(ShadowWordDeath.id))
            return true
        end)
    end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AngelicFeather
AngelicFeather:Callback('Movement', function(spell)
    if Action.Zone == "arena" then return end
    if player:HasBuff(buffs.feather) then return end
    if isStaying then return end

    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DesperatePrayer
DesperatePrayer:Callback('Defensive', function(spell)
    if playerHealth > GetToggle(2, "SelfProtection1") then return end

    return spell:Cast(player)
end)

-- Fade
Fade:Callback('Defensive', function(spell)
    if Action.Zone == "arena" then return end
    if not player:TalentKnown(TranslucentImage.id) then return end
    if not shouldDefensive() then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PowerWordFortitude
--PowerWordFortitude:Callback('PreCombat', function(spell)
--    if player:HasBuff(A.PowerWordFortitude.ID) then return end
--
--    return spell:Cast(player)
--end)

PowerWordFortitude:Callback('PreCombat', function(spell)
    if player.inCombat then return end

    if Action.Zone == "arena" and player.combatTime > 0 then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(PowerWordFortitude.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 or C_Map.GetBestMapForUnit(player:CallerId()) ~= C_Map.GetBestMapForUnit(unit:CallerId()) end)
    
    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then 
        return Debounce("pwf", 1000, 2500, spell, player)
    end
end)

PowerWordFortitude:Callback('combat', function(spell)
    if unit.hp < 85 then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(PowerWordFortitude.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    if not missingBuff then return end
    return Debounce("pwf", 200, 2500, spell, player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Purify
Purify:Callback('Dispel', function(spell)
    if A.Zone == "arena" then return end
    if unit.ehp < 35 then return end
    if unit:DebuffFrom(AvoidDispelTable) then return end

    local magicked  = MakMulti.party:Find(function(unit) return (unit.magicked or AuraIsValid(unit:CallerId(), "UseDispel", "Magic")) and Purify:InRange(unit) end)
    local diseased  = MakMulti.party:Find(function(unit) return (unit.cursed or AuraIsValid(unit:CallerId(), "UseDispel", "Disease")) and Purify:InRange(unit) end)

    if magicked then
        -- HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if diseased and player:TalentKnown(ImprovedDispelTalent.id) then
        -- HealingEngine.SetTarget(diseased:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
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

-- GuardianSpirit
GuardianSpirit:Callback('Emergency', function(spell)
    if combatTime == 0 or unit.hp > 35 then return end
    if not unit:IsPlayer() then return end

    if GetToggle(2, "GSTank") then
        if not unit.isTank then return end
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
    return not player:Buff(A.Apotheosis.ID, true) and not player:Buff(A.DivineHymn.ID, true) and not player:Buff(A.SpiritofRedemption.ID, true) and A.HolyWordSalvation:GetSpellTimeSinceLastCast() > 15
end

local function HandleHealingCooldowns(spell, allowMoving)
    if not allowMoving and isMoving then return end
    if MajorCooldownIsActive() then return end
    if not CanUseHealingCooldowns() then return end

    return spell:Cast(player)
end

-- HolyWordSalvation
HolyWordSalvation:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell, false)
end)

-- DivineHymn
DivineHymn:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell, false)
end)

-- Apotheosis
Apotheosis:Callback('Cooldowns', function(spell)
    return HandleHealingCooldowns(spell, true)
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
    if player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp > 35 then return end

    return spell:Cast(unit)
end)

PowerWordLifeToo:Callback('HealingPve', function(spell)
    if not as.enemyCds and unit.totalImmune and player:Buff(buffs.premInsight) then
        return
    end

    if not player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp > 50 then return end
    if player.mana < 70000 then return end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellID == DivineHymn.id then
        if unit.ehp > 20 then return end
    end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('Freecast', function(spell)
    if not player:Buff(114255) then return end
    if not AutoHeal(unit:CallerId(), A.FlashHeal) then return end

    return spell:Cast(unit)
end)

-- DivineWord
DivineWord:Callback('HealingPve', function(spell)
    local serenitySlider = GetToggle(2, "HolyWordSerenitySlider")
    if not AutoHealOrSlider(unit:CallerId(), A.HolyWordSerenity, serenitySlider) then return end

    return spell:Cast(player)
end)

local function AreBuffsValid()
    local isDivineImageEnabled = GetToggle(2, "DivineImageBox")
    local isResonantWordsEnabled = GetToggle(2, "ResonantWordsBox")
    
    -- Buffs sind gültig, wenn die Checkbox deaktiviert ist oder der Buff nicht aktiv ist
    local isDivineImageValid = not isDivineImageEnabled or not player:Buff(A.DivineImage.ID)
    local isResonantWordsValid = not isResonantWordsEnabled or not player:Buff(A.ResonantWords.ID)
    
    -- Beide Buff-Checks müssen erfüllt sein, damit der Zauber verwendet werden kann
    return isDivineImageValid and isResonantWordsValid
end

-- HolyWordSanctify
HolyWordSanctify:Callback('HealingPve', function(spell)
    -- Überprüfen, ob die Buff-Bedingungen und die AoE-Heilung gültig sind
    if not AreBuffsValid() or not CanUseAoeHealing() then return end
    
    if player:TalentKnown(EternalSanctity.id) then
        if Apotheosis.cd < spell:TimeToFullCharges() and not player:Buff(buffs.apotheosis) then
            if spell.charges < spell.maxCharges then return end
        end
    end

    if player:HasBuffCount(buffs.answeredPrayers) >= 40 and not player:Buff(buffs.apotheosis) then
        if spell.charges < spell.maxCharges then return end
    end

    return spell:Cast(unit)
end)

-- HolyWordSerenity
HolyWordSerenity:Callback('HealingPve', function(spell)
    -- Überprüfen, ob die Buff-Bedingungen gültig sind
    if not AreBuffsValid() then return end

    if player:TalentKnown(EternalSanctity.id) then
        if Apotheosis.cd < spell:TimeToFullCharges() and not player:Buff(buffs.apotheosis) then
            if spell.charges < spell.maxCharges and unit.hp > 30 then return end
        end
    end

    if player:HasBuffCount(buffs.answeredPrayers) >= 40 and not player:Buff(buffs.apotheosis) then
        if spell.charges < spell.maxCharges then return end
    end

    if A.PremonitionBundle:IsReadyByPassCastGCD() and getBelowHP(90) >= 1 then
        return PremonitionBundle('HealingPve') 
    end

    local serenityThreshold = GetToggle(2, "HolyWordSerenitySlider") + (num(unit:Buff(buffs.insurance, true)) * 25)
    
    local insuranceUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return HolyWordSerenity:InRange(friendly) and friendly.hp > 0 and friendly.ehp < GetToggle(2, "HolyWordSerenitySlider") + (num(friendly:Buff(buffs.insurance, true)) * 25) end
    )

    if insuranceUnit then
        if unit:BuffRemains(buffs.insurance, true) > 1000 and unit.ehp > serenityThreshold then
            -- HealingEngine.SetTarget(insuranceUnit:CallerId(), 1)
        end
    end

    if AutoHealOrSlider(unitID, A.HolyWordSerenity, serenityThreshold) then
        return spell:Cast(unit)
    end
end)

-- PrayerOfMending
PrayerOfMending:Callback('HighPrio', function(spell)
    if GetToggle(2, "PrayerofMendingMenu") ~= "1" then return end
    if unit:Buff(A.PrayerOfMendingBuff.ID) then return end
    if unit.hp > 99 then return end

    return spell:Cast(unit)
end)

-- PrayerOfHealing
PrayerofHealing:Callback('HealingPve', function(spell)
    if not isStaying then return end

    if getBelowHP(90) < 4 then return end

    return spell:Cast(player)
end)

-- Halo
Halo:Callback('HealingPve', function(spell)
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

-- CircleofHealing
CircleofHealing:Callback('HealingPve', function(spell)
    if not CanUseAoeHealing() then return end

    return spell:Cast(unit)
end)

-- FlashHeal + Lightweaver
FlashHeal:Callback('Lightweaver', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if not A.LightweaverTalent:IsTalentLearned() then return end

    if player:Buff(A.LightweaverBuff.ID) then return Heal('Lightweaver') end

    local sliderValue = GetToggle(2, "LightweaverSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.FlashHeal, sliderValue) then
        return
    end

    return spell:Cast(unit)
end)

-- Heal + Lightweaver
Heal:Callback('Lightweaver', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if not A.LightweaverTalent:IsTalentLearned() then return end

    if not player:Buff(A.LightweaverBuff.ID) then return FlashHeal('Lightweaver') end

    local sliderValue = GetToggle(2, "LightweaverSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Heal, sliderValue) then
        return
    end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('HealingPve', function(spell)
    if A.LightweaverTalent:IsTalentLearned() then return end

    local FlashHealslider = GetToggle(2, "FlashHealSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.FlashHeal, FlashHealslider) then
        return
    end

    return spell:Cast(unit)
end)

-- Heal
Heal:Callback('HealingPve', function(spell)
    if A.LightweaverTalent:IsTalentLearned() then return end

    local Healslider = GetToggle(2, "HealSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Heal, Healslider) then
        return
    end

    return spell:Cast(unit)
end)

Heal:Callback('WasteNoTime', function(spell)
    if not player:Buff(buffs.wasteNoTime) then return end
    if unit.hp >= 80 then return end

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

    if not AutoHeal(unit:CallerId(), A.PrayerOfMending) then return end

    return spell:Cast(unit)
end)

-- Renew
Renew:Callback('AlwaysAndMoving', function(spell)
    local menuOption = GetToggle(2, "RenewMenu")

    if player:TalentKnown(EmpoweredRenew.id) then
        if HolyWordSerenity:TimeToFullCharges() < 5000 then return end
    end

    if menuOption == "1" then
        if unit:Buff(A.Renew.ID) then return end
    elseif menuOption == "2" then
        if isStaying or unit:Buff(A.Renew.ID) then return end
    else
        return
    end

    if unit.hp < 90 then
        return spell:Cast(unit)
    end

    local Renewslider = GetToggle(2, "RenewSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Renew, Renewslider) then return end

    return spell:Cast(unit)

end)

-- PowerWordShield
PowerWordShield:Callback('HealingAndMoving', function(spell)
    local menuOption = GetToggle(2, "PowerWordShieldMenu")

    if menuOption == "1" then
        if unit:Buff(A.PowerWordShield.ID) then return end
    elseif menuOption == "2" then
        if isStaying or unit:Buff(A.PowerWordShield.ID) then return end
    else
        return
    end

    local PowerWordShieldslider = GetToggle(2, "PowerWordShieldSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.PowerWordShield, PowerWordShieldslider) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL DAMAGE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ShadowWordDeath
ShadowWordDeath:Callback('DamagePve', function(spell)
    if target.hp > 35 then return end

    return spell:Cast(target)
end)

-- Shadowfiend
Shadowfiend:Callback('DamagePve', function(spell)
    if combatTime == 0 then return end
    if player.manaPct >= 80 then return end

    return spell:Cast(target)
end)

-- HolyWordChastise
HolyWordChastise:Callback('DamagePve', function(spell)
    return spell:Cast(target)
end)

-- HolyFire
HolyFire:Callback('Buffed', function(spell)
    if not player:Buff(buffs.empyrealblaze) then return end

    return spell:Cast(target)
end)

-- HolyNova
HolyNova:Callback('DamagePve', function(spell)
    if player:HasBuffCount(390636) < 15 then return end
    if MultiUnits:GetByRange(8) < GetToggle(2, "HolyNovaSlider") then return end

    return spell:Cast(target)
end)

-- DivineStar
DivineStar:Callback('DamagePve', function(spell)
    if combatTime == 0 then return end
    if Unit("target"):GetRange() > 30 then return end

    return spell:Cast(target)
end)

-- HolyFire
HolyFire:Callback('DamagePve', function(spell)
    --if target:DebuffRemains(14914) >= 3000 then return end

    return spell:Cast(target)
end)

-- ShadowWordPain
ShadowWordPain:Callback('DamagePve', function(spell)
    if target:DebuffRemains(589) >= 3000 then return end

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
    DesperatePrayer('Defensive')
    Fade('Defensive')
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
    GuardianSpirit('Emergency')

    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')

    HolyWordSalvation('Cooldowns')
    DivineHymn('Cooldowns')
    Apotheosis('Cooldowns')
    PowerInfusion('Cooldowns')

    PowerWordLife('HealingPve')
    PowerWordLifeToo('HealingPve')

    DivineWord('HealingPve')
    HolyWordSanctify('HealingPve')
    HolyWordSerenity('HealingPve')

    FlashHeal('Freecast')

    PrayerOfMending('HighPrio')
    Halo('HealingPve')
    CircleofHealing('HealingPve')



    Heal('WasteNoTime')

    FlashHeal('Lightweaver')
    Heal('Lightweaver')

    PrayerofHealing('HealingPve')

    FlashHeal('HealingPve')
    Heal('HealingPve')

    PrayerOfMending('LowPrioAndMoving')
    Renew('AlwaysAndMoving')
    PowerWordShield('HealingAndMoving')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
    if Player:ManaPercentage() <= GetToggle(2, "ManaTresholdDpsSlider") then return end

    ShadowWordDeath('DamagePve')
	Shadowfiend('DamagePve')
    HolyWordChastise('DamagePve')
	HolyFire('Buffed')
	HolyNova('DamagePve')
    DivineStar('DamagePve')
    HolyFire('DamagePve')
    ShadowWordPain('DamagePve')
    Smite('DamagePve')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Holy Ward - Use before incoming CC (prevents full loss of control)
HolyWard:Callback("arena", function(spell)
    if Action.Zone ~= "arena" and Action.Zone ~= "pvp" then return end
    if not IsPlayerSpell(spell.id) then return end
    if not player.inCombat then return end

    return MakMulti.arena:ForEach(function(enemy)
        if not enemy.exists then return end
        local castOrChannel = enemy.castOrChannelInfo
        if not castOrChannel then return end

        -- Check if it's a CC spell we want to ward
        if not MakLists.arenaFadeList[castOrChannel.spellId] then return end
        if CastDr(castOrChannel, player) <= 0.25 then return end

        if not worthAvoiding(enemy, castOrChannel) then return end

        -- Use Holy Ward earlier than Fade (at 50% cast)
        if castOrChannel.percent and castOrChannel.percent < 50 then return end
        if castOrChannel.remaining and castOrChannel.remaining > swdOffset + 200 then return end

        if A.GetToggle(2, "makArenaAware") then
            Aware:displayMessage("Holy Ward vs " .. enemy.name, "Priest", 1.5, GetSpellTexture(spell.id))
        end
        return spell:Cast()
    end)
end)

-- Fade
Fade:Callback("arena", function(spell)
    if Action.Zone ~= "arena" then return end
    if not IsPlayerSpell(PhaseShift.id) then
        print("DEBUG: No Phase Shift talent")
        return
    end

    return MakMulti.arena:ForEach(function (enemy)
        if not enemy.exists then return end
        local castOrChannel = enemy.castOrChannelInfo
        if not castOrChannel then return end

        -- Debug: Print spell being cast
        if MakLists.arenaFadeList[castOrChannel.spellId] then
            print("DEBUG: Enemy casting fadeable spell: " .. castOrChannel.spellId .. " percent: " .. (castOrChannel.percent or "nil") .. " remaining: " .. (castOrChannel.remaining or "nil"))
        end

        if not MakLists.arenaFadeList[castOrChannel.spellId] then return end
        if CastDr(castOrChannel, player) <= 0.25 then
            print("Not going to fade this - DR too low")
            return
        end

        if not worthAvoiding(enemy, castOrChannel) then
            print("DEBUG: Not worth avoiding")
            return
        end

        if MakLists.swdList[castOrChannel.spellId]
            and (ShadowWordDeath.cd < 1000 or ShadowWordDeath.used < 1000 or (GetTime() - deathTried) < 0.3) then
            print("DEBUG: Preferring SWD over Fade")
            return
        end

        -- Check if cast is at least 60% complete (similar to other priest rotations)
        if castOrChannel.percent and castOrChannel.percent < 60 then
            print("DEBUG: Cast not 60% yet: " .. castOrChannel.percent)
            return
        end
        -- Fallback to remaining time check (fade when less than swdOffset remaining)
        if castOrChannel.remaining and castOrChannel.remaining > swdOffset then
            print("DEBUG: Too much time remaining: " .. castOrChannel.remaining .. " > " .. swdOffset)
            return
        end

        print("DEBUG: ATTEMPTING TO FADE!")
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from " .. enemy.name, "White", 1, GetSpellTexture(PhaseShift.id)) end
        return spell:Cast(player)
    end)
end)

Fade:Callback("dodge", function(spell, now)
    if Action.Zone ~= "arena" then return end
    if not IsPlayerSpell(PhaseShift.id) then return end
    if tryDeathTime == tryFadeTime then
        if ShadowWordDeath.used < 1000 or (GetTime() - deathTried) < 0.3 then return end
    end

    local fadeDelta = now - tryFadeTime
    if fadeDelta > 0.6 then return end
    if fadeDelta < fastReact then return end

    Aware:displayMessage("Fading Event", "Priest", 1, GetSpellTexture(Fade.id))
    if not spell:Cast(player) then return end
end)

local dontFear = MakuluFramework.AtoL({
    6940,       -- Blessing of Sacrifice
    378464,     -- Nullifying Shroud
    329543,     -- Divine Ascension
    215769,     -- Spirit of Redemption
    5246,       -- Intimidating Shout
    8143,       -- Tremor Totem (fear immunity)
    "Bladestorm",
    "Nullifying Shroud"
})

PsychicScream:Callback("arena", function(spell)
    -- if getBelowHP(40) > 0 then return end
    if player:Debuff(410201) then return end -- searing glare
    if player.combatTime == 0 then return end
    if not enemyHealer.exists then return end
    if enemyHealer.magicImmune then return end -- Includes Grounding Totem buff (8178)
    if enemyHealer.ccImmune then return end
    if enemyHealer.distance > 4 then return end
    if enemyHealer:BuffFrom(dontFear) or enemyHealer:DebuffFrom(dontFear) then return end -- Includes Tremor Totem (8143)
    if not enemyHealer:Los() then return end
    if enemyHealer:GetCD("Shadow Word: Death") < 1200 then return end
    if enemyHealer.ccRemains < 1000 and enemyHealer.disorientDr >= .5 and not enemyHealer:Debuff(203337) then
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting Psychic Scream on enemy healer", "White", 1) end
        return spell:Cast(player)
    end

    --[[if arena1.exists and arena1:IsHealer() and arena1.distance <= 5 and not arena1.totalImmune and not arena1.magicImmune and not arena1.ccImmune and arena1.ccRemains < 1 and arena1.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena2)", "White", 1)
        return spell:Cast(player)
    end

    if arena2.exists and arena2:IsHealer() and arena2.distance <= 5 and not arena2.totalImmune and not arena2.magicImmune and not arena2.ccImmune and arena2.ccRemains < 1 and arena2.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena2)", "White", 1)
        return spell:Cast(player)
    end

    if arena3.exists and arena3:IsHealer() and arena3.distance <= 5 and not arena3.totalImmune and not arena3.magicImmune and not arena3.ccImmune and arena3.ccRemains < 1 and arena3.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena3)", "White", 1)
        return spell:Cast(player)
    end]]
end)

-- Gate Open Pre Buffs
PremonitionofInsightArena:Callback("arenaGates", function(spell)
    if player.combatTime > 0 then return end
    if player:Buff(32727) then return end
    if player:Buff(buffs.premInsight) then return end
    if party1.exists and party1:Buff(buffs.prayerOfMending) or party2.exists and party2:Buff(buffs.prayerOfMending) then return end

    return PremonitionBundle:Cast(player)
end)

PrayerOfMending:Callback("arenaGates", function(spell)
    if player.combatTime > 0 then return end
    if player:Buff(32727) then return end
    if party1.exists and party1:HasBuffCount(buffs.prayerOfMending) <= 8 and party1:Los() then
        -- HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    elseif party2.exists and party2:HasBuffCount(buffs.prayerOfMending) <= 8 and party2:Los() then
        -- HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    elseif not player:Buff(buffs.prayerOfMending) then
        -- HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

Renew:Callback("arenaGates", function(spell)
    if player.combatTime > 0 then return end
    if player:Buff(32727) then return end

    if party1.exists and not hasBigRenew(party1) and party1:Los() then
        -- HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    elseif party2.exists and not hasBigRenew(party2) and party2:Los() then
        -- HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    elseif not hasBigRenew(player) then
        -- HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

-- Premonitions
PremonitionofInsightArena:Callback("arena", function(spell, force)
    -- Combat check
    if player.combatTime == 0 then return end

    if player:Buff(buffs.premInsight) then return end

    -- Health conditions: someone at 52% or 2 people at 65%
    local lowCount = getBelowHP(65)
    local veryLowCount = getBelowHP(52)

    if not force and veryLowCount == 0 and lowCount < 2 then return end

    if force or PremonitionBundle.frac == 2 then
        return PremonitionBundle:Cast(player)
    end
end)

PremonitionofPietyArena:Callback("arena", function(spell, go)
    -- Combat check
    if player.combatTime == 0 then return end

    if player:Buff(buffs.premPiety) then return end

    -- Health conditions: someone at 52% or 2 people at 65%
    local lowCount = getBelowHP(65)
    local veryLowCount = getBelowHP(52)

    if not go and veryLowCount == 0 and lowCount < 2 then return end

    if go then return PremonitionBundle:Cast(player) end
    if unit.hp > 80 and not as.enemyCds then return end

    if SpiritoftheRedeemer.cd < 2000 then return end

    if unit.hp > 50 and not as.enemyCds then return end

    return PremonitionBundle:Cast(player)
end)

PremonitionofSolaceArena:Callback("arena", function(spell)
    -- Combat check
    if player.combatTime == 0 then return end

    -- Health conditions: someone at 52% or 2 people at 65%
    local lowCount = getBelowHP(65)
    local veryLowCount = getBelowHP(52)

    if veryLowCount == 0 and lowCount < 2 then return end

    if PremonitionBundle.frac == 2 then
        return PremonitionBundle:Cast(player)
    end

    if unit:Buff(buffs.solaceBuff) and unit:BuffRemains(buffs.solaceBuff, true) > 2000 then
        return
    end

    if unit.hp > 60 and not as.enemyCds then return end

    return PremonitionBundle:Cast(player)
end)

PremonitionofClairvoyanceArena:Callback("arena", function(spell, force)
    -- Combat check
    if player.combatTime == 0 then return end

    -- Health conditions: someone at 52% or 2 people at 65%
    local lowCount = getBelowHP(65)
    local veryLowCount = getBelowHP(52)

    if not force and veryLowCount == 0 and lowCount < 2 then return end

    if force then
        return PremonitionBundle:Cast(player)
    end

    if unit.hp > 60 or unit.totalImmune then return end

    return PremonitionBundle:Cast(player)
end)

local holdFor =  MakuluFramework.AtoL({
    "Alter Time",
    31224,  -- Cloak of shadows
    5277,   --evasion
    45438, -- ice block
})

local autoTargetSmallShieldList =  MakuluFramework.AtoL({
    212800, -- blur
    61336, -- survival instincts
    122470, -- touch of karma
    642, --divine shield
    6940, --blessing of sacrifice
    184662, -- shield of vengeance,
    108271, --astral shift
    --108416, --dark pact
    118038, --die by the sword
    184364, -- enraged regeneration
    104773,--/unending-resolve--
    120954,--/fortifying-brew
    363916, --obsidian scales
    498, -- divine protection
    22812, -- barkskin
    122278, -- dampen harm
    48792, --icebound fortitude
    33206, --pain suppression
    498, --divine protection
    403876, -- divine protection
    102342, -- ironbark,
    6940, -- blessing of hand
    5277,   --evasion
})

-- GuardianSpirit
GuardianSpirit:Callback('arena', function(spell, force)
    if not unit then return end
    if unit.totalImmune then return end
    if holdCdOnRay(unit) then return end

    local total, _, _, _, cds = unit:AttackersV69()
    if as.enemyCds and as.enemyCdRemains < 5000 then
        cds = cds - 1
    end

    if total == 0 then return end

    if unit.isMe and unit.hp > 20 then return end
    
    if force then
        return spell:Cast(unit)
    end

    if unit:BuffFrom(holdFor) then return end
    if unit:BuffFrom(autoTargetSmallShieldList) and unit.ehp > 30 and cds < 2 then return end
    
    if unit.ehp > 30 and (player:Buff(buffs.spiritOfRedemption) or player:Buff(buffs.spiritOfTheRedeemer)) then return end

    local wouldCast = false

    if unit.ehp < 20 then
        return spell:Cast(unit)
    end

    if total > 0 and unit.ehp < 70 and cds > 1 then
        --Debounce("LowCoccoonCdsLower" .. unit.name, 500, 4500, spell, unit)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 1. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end

    if total > 0 and unit.ehp < 60 and cds > 0 then
        --Debounce("LowCoccoonCds" .. unit.name, 500, 4500, spell, unit)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 2. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end

    if unit.ehp < 40 and cds > 0 then
        --Debounce("LowCoccoonCdsTwo" .. unit.name, 500, 4500, spell, unit)
        wouldCast = true
        -- if A.GetToggle(2, "makDebug") then
        --     Aware:displayMessage("Coccoon 3. EHP: " .. healTarget.ehp, "Monk", 1, GetSpellTexture(spell.id))
        -- end
    end


end)

-- RayofHope
RayofHope:Callback('arena', function(spell, force)
    if unit:Buff(buffs.guardian) then return end
    if unit.ehp > 10 and GuardianSpirit.cd < 1000 then return end

    if unit.hp < 15 then return spell:Cast(unit) end

    if not force or unit.hp > 48 then return end

    if unit:BuffFrom(holdFor) then return end

    if unit.isMe and unit.hp > 20 then return end

    if PowerWordLife.cd > 3000 then return end
    if HolyWordSerenity.cd > 2000 then return end

    if PowerWordLife.cd > 2000 and HolyWordSerenity.frac < 1 then return end

    -- local _, _, _, _, cds = unit:AttackersV69()
    -- if cds < 1 then return end

    return spell:Cast(unit)
end)

-- PowerWordLife
PowerWordLife:Callback('arena', function(spell)
    if player:TalentKnown(MiraculousRecovery.id) then return end

    if rayTarget and rayTarget == unit.guid then
        local healthActual = UnitHealth(unit:CallerId()) or 0
        if ((healthActual / unit:HealthMax()) * 100) > 35 then return end
    elseif unit.hp > 35 then return end

    return spell:Cast(unit)
end)

PowerWordLifeToo:Callback('arena', function(spell)
    if not player:TalentKnown(MiraculousRecovery.id) then return end

    if rayTarget and rayTarget == unit.guid then
        local healthActual = UnitHealth(unit:CallerId()) or 0
        if ((healthActual / unit:HealthMax()) * 100) > 50 then return end
    elseif unit.hp > 50 then return end
    
    if player.mana < 70000 then return end
    GuardianSpirit("arena", true)
    RayofHope("arena", true)
    return spell:Cast(unit)
end)

-- Apotheosis
Apotheosis:Callback('arena', function(spell)
    if unit.hp > 70 then return end
    -- if unit:Buff(buffs.guardian) then return end
    if unit.hp < 30 and HolyWordSerenity.frac < 1 then
        return spell:Cast()
    end

    if unit.hp < 60 and HolyWordSerenity.frac < 1 then
        return spell:Cast()
    end

    -- if HolyWordSerenity.frac <= 1 and HolyWordSanctify.frac <= 1 and HolyWordChastise.cd > 1000 then
    --     return spell:Cast(player)
    -- end
end)

-- HolyWordSerenity
HolyWordSerenity:Callback('arena', function(spell)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end

    if unit.ehp > 30 and (player:Buff(buffs.spiritOfRedemption) or player:Buff(buffs.spiritOfTheRedeemer)) then return end

    if spell.frac < 1.9 and PowerWordLife.cd < 100 and unit.hp > 40 then return end
    -- if spell.frac < 1 and unit and unit.hp > 65 then return end

    if unit.ehp > 65 then return end

    if spell.frac < 1.8 then 
        GuardianSpirit('arena', true)
        RayofHope('arena', true)
    end
    return spell:Cast(unit)
end)

HolyWordSerenity:Callback('force', function(spell)
    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('arena', function(spell)
    if not player:Buff(buffs.surgeOfLight) then return end

    if player:HasBuffCount(buffs.surgeOfLight) > 1 then
        if unit.hp > 75 and unit:BuffRemains(buffs.surgeOfLight) > 2000 then return end

        if unit.hp > 95 then return end
        return spell:Cast(unit)
    end

    if unit.hp > 85 then return end
    if unit:BuffRemains(buffs.surgeOfLight) < 2000 then
        return spell:Cast(unit)
    end

    if HolyWordSerenity.frac > 1.9 then return end

    if not player:Buff(buffs.resonating) then
        HolyWordSanctify("arena_mo", true)
        HolyWordSanctify("arena", true)
    end

    return spell:Cast(unit)
end)

FlashHeal:Callback('chonker', function(spell)
    if not player:Buff(buffs.surgeOfLight) then return end
    if player:HasBuffCount(buffs.fromDarkness) < 18 then return end
    if unit.hp > 65 then return end
    return spell:Cast(unit) and Aware:displayMessage("Chonker free flash heal", 'Priest', 1.5, GetSpellTexture(spell.id))
end)

FlashHeal:Callback('spirit', function(spell)
    if not player:Buff(buffs.spiritOfRedemption) and not player:Buff(buffs.spiritOfTheRedeemer) then return end
    return spell:Cast(unit)
end)

-- PrayerOfMending
PrayerOfMending:Callback('arena', function(spell, strict)
    if strict and unit.ehp < 40 and not unit.totalImmune then return end
    local total, _, _, _, cds = unit:AttackersV69()

    local hasInsightBuff = player:Buff(buffs.premInsight)
    -- if unit.isMe then return end
    if unit:Buff(41635) and unit:BuffRemains(41635) > 2000
        and unit:HasBuffCount(41635) > 11 then

        MakMulti.party:Any(function(friendly)
            if friendly.isMe then return end
            if unit:Buff(41635) and unit:HasBuffCount(41635) > 7 then return end
            if not friendly:Los() then return end
            
            if not hasInsightBuff then
                PremonitionofInsightArena("arena", true)
                PremonitionofClairvoyanceArena("arena", true)
            end
            return spell:Cast(friendly)
        end)
    end
    if total == 0 and HolyWordSerenity.frac == 2 and unit.hp > 90 and not hasInsightBuff then return end

    if unit.isMe and total == 0 and not hasInsightBuff then
        return Debounce("PrayerSelf", 1200, 4500, spell, player)
    end

    if not hasInsightBuff then
        PremonitionofInsightArena("arena", true)
        PremonitionofClairvoyanceArena("arena", true)
    end
    return spell:Cast(unit)
end)

-- Renew
Renew:Callback('arena', function(spell, strict)
    if strict and unit.ehp < 40 and not unit.totalImmune then return end
    local total, _, _, _, cds = unit:AttackersV69()
    if total == 0 and unit.isMe then return end
    
    if hasBigRenew(unit) and unit:BuffRemains(139) > 2000 then
        if not strict and unit:BuffRemains(139) > 10000 then
            MakMulti.party:Any(function(friendly)
                if friendly.isMe then return end
                if hasBigRenew(friendly) and unit:BuffRemains(friendly) > 4000 then return end
                if not friendly:Los() then return end
                return spell:Cast(friendly)
            end)

            if total == 0 and player.hp > 80 then return end
            if hasBigRenew(player) and unit:BuffRemains(player) > 4000 then return end
            return spell:Cast(player)
        end
        return
    end

    return spell:Cast(unit)
end)

-- HolyWordSanctify
HolyWordSanctify:Callback('arena_nearby', function(spell)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end

    if player:Buff(buffs.premInsight) then return end

    local missing = 0

    getPartyList():ForEach(function(friendly)
        if friendly.distance > 13 then return end
        missing = missing + 100 - math.min(friendly.hp, 100)
    end)
    
    if missing < 30 then return end

    return spell:Cast(player)
end)

HolyWordSanctify:Callback('arena_sanctify', function(spell)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end

    if unit.hp > 70 then return end
    if unit.distance > 10 then return end
    if not unit.isMe and unit.distance == 0 then return end
    print('Casting sanctify as theyre close on ' .. unit.name .. ' distiance is  ' .. unit.distance)

    return spell:Cast(player)
end)

HolyWordSanctify:Callback('arena_sanctify_mo', function(spell)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end

    if unit.hp > 90 then return end
    if player:Buff(buffs.resonating) then return end

    Aware:displayMessage("Sanctify on mouseover ready", 'Priest', 1.5, GetSpellTexture(spell.id))
    if not mouseover.exists then return end
    if mouseover.guid ~= unit.guid then return end

    return spell:Cast(mouseover)
end)

-- HolyWordSanctify
HolyWordSanctify:Callback('arena', function(spell, force)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end

    if unit.hp > 80 then return end
    if unit.distance > 10 then return end
    if not unit.isMe and unit.distance == 0 then return end

    return spell:Cast(player)
end)

HolyWordSanctify:Callback('arena_mo', function(spell, force)
    if not as.enemyCds and unit.ehp > 60 and player:Buff(buffs.premInsight) then
        return
    end
    if unit.hp > 80 then return end

    Aware:displayMessage("Sanctify on mouseover ready", 'Priest', 1.5, GetSpellTexture(spell.id))
    if not mouseover.exists then return end
    if mouseover.guid ~= unit.guid then return end

    return spell:Cast(mouseover)
end)

-- FlashHeal
FlashHeal:Callback('arena2', function(spell)
    --if not player:Buff(372313) then return end
    if player:Buff(buffs.surgeOfLight) then return end
    if (HolyWordSerenity.frac > 1 or PowerWordLifeToo.cd < 500) and unit.hp > 50 then return end
    if unit.hp > 70 then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('arena3', function(spell)
    if player.stayTime < 0.5 then return end
    if HolyWordSerenity.frac > 0.9 and CanAttackTarget() and target.hp < unit.hp - 20 then return end
    if HolyWordSerenity.frac >= 2 then return end
    if unit.hp == 100 then return end

    return spell:Cast(unit)
end)


-- PowerWordShield
PowerWordShield:Callback('solace', function(spell)
    if not player:Buff(buffs.premSolace)  then return end

    if player:BuffRemains(buffs.premSolace) < 2000 then
        return spell:Cast(unit)
    end

    if unit:BuffRemains(buffs.solaceBuff) > 1000 then return end

    local total, _, _, _, cds = unit:AttackersV69()
    if total > 0 then
        return spell:Cast(unit)
    end
end)

PowerWordShield:Callback('arena', function(spell)
    if unit.hp > 40 then return end

    return spell:Cast(unit)
end)

ShadowWordPain:Callback('arena', function(spell)
    if not target.exists or not target.canAttack then return end
    if not unit or unit.hp < 50 then return end
    if target.bcc then return end

    if target:DebuffRemains(589) > 1500 then return end

    return spell:Cast(target)
end)

ShadowWordPain:Callback('stomp', function(spell)
    if target:DebuffRemains(589) > 1500 then return end

    return spell:Cast(target)
end)

ShadowWordPain:Callback('spread', function(spell)
    if not target.exists or not target.canAttack then return end
    return getArenaList():ForEach(function(arena)
        if not arena.exists or not arena.canAttack then return end
        if not arena:Los() then return end
        if arena.bcc then return end
        if arena:DebuffRemains(589) > 1500 then return end

        return spell:Cast(arena)
    end)
end)

-- Priority Totem Killer (Grounding Totem, Tremor Totem)
ShadowWordPain:Callback('totem', function(spell)
    -- Don't waste GCD on totems if anyone in party is below 65% HP
    local partyNeedsHealing = MakMulti.party:Any(function(friendly)
        return friendly.exists and friendly.hp < 65
    end)
    if partyNeedsHealing then return end

    -- Find priority totems (low HP totems that need instant removal)
    local priorityTotem = MakMulti.enemies:Find(function(enemy)
        if not enemy:IsTotem() then return false end
        if not spell:InRange(enemy) then return false end
        if enemy.dead then return false end

        -- Priority totems: Grounding Totem, Tremor Totem (both have 50 HP)
        local totemName = enemy.name
        if totemName == "Grounding Totem" or totemName == "Tremor Totem" then
            return true
        end

        return false
    end)

    if priorityTotem then
        if A.GetToggle(2, "makArenaAware") then
            Aware:displayMessage("Killing " .. priorityTotem.name, "Priest", 1, GetSpellTexture(spell.id))
        end
        return spell:Cast(priorityTotem)
    end
end)

-- Shadowfiend
Shadowfiend:Callback('arena', function(spell)
    if not target.exists or not target.canAttack then return end
    if target.distance > 30 then return end
    if player.manaPct >= 90 then return end
    if player:Debuff(410201) then return end
    if SpiritoftheRedeemer.cd < 15000 then return end

    return spell:Cast()
end)

local spiritMacro  = 0
local function spirit()
    print("Spirit queued")
    spiritMacro = GetTime()
end

local function queuedSpirit()
    if SpiritoftheRedeemer.cd > 1000 then return end
    local requestedTime = (GetTime() - spiritMacro) * 1000

    if SpiritoftheRedeemer.used < requestedTime or requestedTime > 1500 then return end
    return true
end

MakuluFramework.Commands.register("spirit", spirit, "Queue spirit", {})

SpiritoftheRedeemer:Callback("macro", function (spell)
    --if player:HasBuff(buffs.feather) then return end
    local requestedTime = (GetTime() - spiritMacro) * 1000

    if spell.used < requestedTime or requestedTime > 1500 then return end
    print("Spirit trying to cast now")
    
    PowerInfusion("force")
    PremonitionofPietyArena("arena", true)
    return spell:Cast()
end)

local rootMacro  = 0
local function root()
    rootMacro = GetTime()
end

MakuluFramework.Commands.register("root", root, "Queue roots", {})

VoidTendrils:Callback("macro", function (spell)
    --if player:HasBuff(buffs.feather) then return end
    local requestedTime = (GetTime() - rootMacro) * 1000

    if spell.used < requestedTime or requestedTime > 1500 then return end

    return spell:Cast()
end)

-- Auto Void Tendrils when kiting melee (Warriors, Rogues, DH, Hunters)
VoidTendrils:Callback("kite", function(spell)
    if not Player:IsMoving() then return end
    if not IsPlayerSpell(spell.id) then return end

    -- Priority melee classes: Warrior (1), Rogue (4), Hunter (3), Demon Hunter (12)
    local priorityMeleeClasses = {
        [1] = true,  -- Warrior
        [3] = true,  -- Hunter
        [4] = true,  -- Rogue
        [12] = true, -- Demon Hunter
    }

    -- Count priority melee enemies within 5 yards
    local meleeCount = MakMulti.enemies:Count(function(enemy)
        return enemy.exists
            and not enemy.dead
            and enemy.distance <= 5
            and priorityMeleeClasses[enemy:ClassID()]
            and not enemy.totalImmune
            and not enemy.ccImmune
    end)

    if meleeCount == 0 then return end

    if A.GetToggle(2, "makArenaAware") then
        Aware:displayMessage("Void Tendrils - Kiting " .. meleeCount .. " melee", "Priest", 1.5, GetSpellTexture(spell.id))
    end
    return spell:Cast()
end)

-- Holy Fire
HolyFire:Callback('pump', function(spell)
    if player:Debuff(410201) then return end
    
    if not player:Buff(372617) then return end

    if not CanAttackTarget() or not target.bigButtons then
        getArenaList():ForEach(function(arena)
            if not arena.exists or not arena.canAttack then return end
            if not arena:Los() then return end
            if arena.bcc then return end
            return spell:Cast(arena)
        end)
    end

    if target.bcc then return end
    return spell:Cast(target)
end)

HolyFire:Callback('arena', function(spell)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if target.bcc then return end
    if player:Buff(372617) then
        spell:Cast(target)
    end    
    
    if getBelowHP(60) > 0 or as.enemyCdsAny then return end

    return spell:Cast(target)
end)

HolyFire:Callback('stomp', function(spell)
    if player:Debuff(410201) then return end
    
    if not player:Buff(372617) then return end

    return spell:Cast(target)
end)

-- DivineHymn
DivineHymn:Callback('arena', function(spell)
   if not player:Buff(buffs.spiritOfRedemption) and not player:Buff(buffs.spiritOfTheRedeemer) then return end

    HolyWordSerenity('arena')
   return spell:Cast()
end)

local featherMacro = 0
local function feather()
    featherMacro = GetTime()
end

MakuluFramework.Commands.register("feather", feather, "Queue feather pvp", {})

AngelicFeather:Callback('arena', function(spell)
    if player:HasBuff(buffs.feather) then return end
    local requestedTime = (GetTime() - featherMacro) * 1000

    if spell.used < requestedTime or requestedTime > 1500 then return end

    return spell:Cast(player)
end)

-- Smite
Smite:Callback('arena', function(spell)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if getBelowHP(75) > 0 or as.enemyCdsAny then return end

    return spell:Cast(target)
end)


local function runForCds(spell, key)
    return getPartyCdList():ForEach(function (party)
        return spell(key, party)
    end)
end

local function runForArena(spell, key)
    return getArenaList():ForEach(function (party)
        return spell(key, party)
    end)
end

local stompList = MakuluFramework.AtoL({
    "Psyfiend",

    "Grounding Totem",
    "Counterstrike Totem",
    "Tremor Totem"
})

local function HealerRotationPvp()
    local now = GetTime()
    
    local _ = player.stayTime
    
    SpiritoftheRedeemer("macro")

    if holdGCDforSWDP() then
        MakuluFramework.spellState.gcdHold = true
    end

    -- local lowestUnit = MakMulti.party:Lowest(function(friendly)
    --     return (friendly.isMe and friendly.ehp + 30) or friendly.ehp
    -- end)

    -- if (player:Buff(buffs.spiritOfRedemption) or player:Buff(buffs.spiritOfTheRedeemer)) then
    --     if lowestUnit.guid ~= unit.guid then
    --         print('Cant heal me with redeemer swapping to lowest')
    --         ---- HealingEngine.SetTarget(lowestUnit:CallerId(), 1)
    --         -- return true
    --     end
    -- end

    -- if unit.isMe and player.hp > 40 and lowestUnit.guid ~= player.guid then
    --     local total, _, _, _, cds = unit:AttackersV69()
    --     if total < 2 and cds == 0 then
    --         print('We chilling dont target me...')
    --         -- -- HealingEngine.SetTarget(lowestUnit:CallerId(), 1)
    --     end
    -- end

    if player:Buff(32727) then
        PowerWordFortitude('PreCombat')
        -- if as._hasSpec(258) then
        --     if player:TalentKnown(390632) then return end

        --     Aware:displayMessage("Consider taking Improved purify vs spri", 'Priest', 1.5, GetSpellTexture(390632))
        -- end
        return
    end

    local castInfo = player.castOrChannelInfo
    if castInfo and castInfo.spellID == DivineHymn.id then
        if unit.ehp > 20 then return end
        -- if unit:Buff(buffs.guardian) then return end
        -- if holdCdOnRay(unit) then return end
    end

    if player:Buff(32727) then
        PowerWordFortitude('PreCombat')
        -- if as._hasSpec(258) then
        --     if player:TalentKnown(390632) then return end

        --     Aware:displayMessage("Consider taking Improved purify vs spri", 'Priest', 1.5, GetSpellTexture(390632))
        -- end
        return
    end
    
    ShadowWordDeath("dodge", now)
    Fade("dodge", now)

    runForArena(ShadowWordDeath, "arenap")
    HolyWard("arena")
    Fade("arena")
    PsychicScream("arena")
    VoidTendrils("kite")
    VoidTendrils("macro")
    Purify("freemeee", player)
    GuardianSpirit('arena')
    PremonitionofInsightArena('arena')
    PremonitionofPietyArena('arena')
    PremonitionofSolaceArena('arena')
    PremonitionofClairvoyanceArena('arena')
    runForArena(HolyWordChastise, "arenap")
    RayofHope('arena')
    PowerWordLife('arena')
    PowerWordLifeToo('arena')
    Heal('WasteNoTime')
    runForParty(VoidShift, "arenap")
    if CanAttackTarget() and stompList[target.name] then
        ShadowWordDeath("stomp")
        ShadowWordPain("stomp")
        HolyFire("stomp")
    end
    ShadowWordPain("totem") -- Kill priority totems (Grounding, Tremor)
    AngelicFeather('arena')
    Apotheosis('arena')
    DivineHymn("arena")
    PowerWordFortitude('combat')
    runForParty(Purify, "angel")
    HolyWordSanctify('arena_mo')
    FlashHeal('chonker')
    HolyWordSerenity('arena')
    PrayerOfMending('arena', true)
    Purify("arenap_prio", player)
    PrayerOfMending('arena')
    runForCds(Purify, "arenap_prio")
    HolyWordSanctify('arena')
    FlashHeal('arena3')
    FlashHeal('arena')
    FlashHeal('spirit')
    if player:Buff(buffs.premInsight) and player:BuffRemains(buffs.premInsight) > PrayerOfMending.cd then
        runForParty(Purify, "arenap_prio")
        if PrayerOfMending.cd < 2000 then
            FlashHeal('arena2')
            Smite('arena')
            ShadowWordPain("spread")
            return
        end

        FlashHeal('arena2')
        Renew('arena', true)
        runForArena(DispelMagic, "arenap_prio")
        ShadowWordPain("arena")
        Smite('arena')
        Renew('arena')
        runForArena(DispelMagic, "arenap_low")
        ShadowWordPain("spread")
        return
    end
    runForParty(Purify, "arenap_prio")
    PowerWordShield("solace")
    Renew('arena', true)
    HolyFire('pump')
    Renew('arena')
    runForArena(DispelMagic, "arenap_prio")
    -- HolyWordSanctify('arena_nearby')
    runForParty(Purify, "arenap_low")
    ShadowWordDeath("shiftPoM")
    FlashHeal('arena2')
    Shadowfiend('arena')
    HolyFire('arena')
    Smite('arena')
    ShadowWordPain("arena")
    runForArena(DispelMagic, "arenap_low")

    PremonitionofInsightArena('arenaGates')
    PrayerOfMending('arenaGates')
    Renew('arenaGates')
    ShadowWordPain("spread")
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

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
ShadowWordDeath:Callback("arenap", function(spell, enemy)
    if not enemy.exists then return end
    local castOrChannel = enemy.castOrChannelInfo
    if not castOrChannel then return end
    if IsPlayerSpell(PhaseShift.id) and Fade.used < 500 then return end
    if player:Buff(408558) then return end

    if player.magicImmune or player.ccImmune then return end

    if not MakLists.swdList[castOrChannel.spellId] then return end
    if CastDr(castOrChannel, player) <= 0.25 then return end

    if spell.cd > castOrChannel.remaining then return end

    if castOrChannel.remaining > swdOffset then return end
    if castOrChannel.elapsed < channelKickTime then return end
    if not worthAvoiding(enemy, castOrChannel) then return end

    if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting SW:D to counter incoming CC", "White", 1, GetSpellTexture(spell.id)) end
    if spell:Cast(enemy, {ignoreLos = true}) then
        deathTried = GetTime()
        return
    end

    return getArenaList():ForEach(function(arena)
        if not arena.exists or not arena.canAttack then return end
        if not arena:Los() then return end
        if not spell:Cast(arena) then return end
        deathTried = GetTime()
    end)
end)

ShadowWordDeath:Callback("stomp", function(spell)
    if target.name ~= "Psyfiend" then return end
    return spell:Cast(target)
end)

ShadowWordDeath:Callback("shiftPoM", function(spell)
    if not player:Buff(41635) then return end
    if player:HasBuffCount(41635) < 6 then return end
    if not player:HealLocked() and (player:BuffRemains(41635) < 4000 or (GetTime() - playerDamageTaken) < 2) then return end
    if player.hp < 20 then return end

    if Fade.cd > 1000 and not MakMulti.arena:Any(function(friendly)
        local classId = friendly:ClassID()
        return classId == 2 or classId == 8
    end) then return end

    if player:TotalAbsorbs() > 200000 then return end

    return getArenaList():ForEach(function(arena)
        if not arena.exists or not arena.canAttack then return end
        if not arena:Los() then return end
        if arena.bcc then return end
        Aware:displayMessage("Shifting PoM with SWD", "White", 1, GetSpellTexture(spell.id))
        return spell:Cast(arena)
    end)
end)

ShadowWordDeath:Callback("dodge", function(spell, now)
    if Action.Zone ~= "arena" then return end
    if tryDeathTime == tryFadeTime then
        if Fade.used < 1000 then return end
    end

    local deathDelta = now - tryDeathTime
    if deathDelta > 0.6 then return end
    if deathDelta < fastReact then return end

    if player:TotalAbsorbs() > 200000 then return end

    if MakuluFramework.gcd() > 50 then return end

    return getArenaList():ForEach(function(arena)
        if not arena.exists or not arena.canAttack then return end
        if not arena:Los() then return end

        Aware:displayMessage("Deathing Event", "Priest", 1, GetSpellTexture(ShadowWordDeath.id))
        if not spell:Cast(arena) then return end
        deathTried = GetTime()
    end)
end)

ShadowWordDeath:Callback("arena2", function(spell, enemy)
    if not CanAttackTarget() then return end
    if unit and unit.hp < 40 then return end
    if enemy.hp > 20 then return end

    return spell:Cast(enemy)
end)

local importantPurges = MakuluFramework.AtoL({
    -- Paladin
    "Avenging Wrath",
    "Hand of Protection",
    "Hand of Freedom",
    "Hand of Sacrifice",
    "Divine Favor",
    "Divine Plea",
    "Blessing of Freedom",
    "Blessing of Protection",

    -- Druid
    "Predator's Swiftness",
    "Innervate",

    -- Mage
    "Icy Veins",
    "Hot Streak",
    "Alter Time",
    "Sphere of Hope",

    -- Priest
    --"Fear Ward",

    -- Shaman

    -- Warlock
    --"Demon Soul",
    "Demon Soul: Imp",
    "Demon Soul: Voidwalker",
    "Demon Soul: Felhunter",
    "Demon Soul: Succubus",
    "Demon Soul: Felguard",

    "Nature's Swiftness",
    -- this is not exhaustive
})

DispelMagic:Callback("arenap_prio", function(spell, enemy)
    if not unit then return end
    if player.cc then return end
    -- if unit.hp < 60 or (as.enemyCds and unit.hp < 70) then return end
    if not enemy:Los() then return end

    local importantPurge = enemy:HasBuffFromFor(importantPurges, shortHalfSecond)
    if importantPurge and BuffDispelCount(enemy) < 3 then
        return spell:Cast(enemy) and Aware:displayMessage("Dispelling: " .. importantPurge.name, 'Priest', 1.5, GetSpellTexture(spell.id))
    end
end)

local lowPrioPurges = MakuluFramework.AtoL({
    "Lifebloom",
    "Renewing Mist",
    "Riptide",
    "Blessing of Freedom",
    "Reversion",
    -- this is not exhaustive
})

DispelMagic:Callback("arenap_low", function(spell, enemy)
    if not unit then return end
    if player.cc then return end

    if not enemy:Los() then return end
    if player.manaPct < 80 and enemy.hp > 50 then return end
    local importantPurge = enemy:HasBuffFromFor(lowPrioPurges, shortHalfSecond)
    if importantPurge and BuffDispelCount(enemy) < 3 then
        return spell:Cast(enemy) and Aware:displayMessage("Dispelling: " .. importantPurge.name, 'Priest', 1.5, GetSpellTexture(spell.id))
    end
end)


HolyWordChastise:Callback("rogue", function(spell, enemy, doHold)

    local rogue = MakMulti.party:Find(function(friendly)
        return friendly:ClassID() == 4
    end)

    if enemy.incapacitateDr < 0.5 then return end

    if rogue and not rogue.cds and as.lowestEhp > 40 then return end

    if enemy:IsUnit(enemyHealer) and as.lowestEhp < 40 and as.lowestUnit and as.lowestUnit.cc then
        -- Dont stun to save outselves from angry rogues
        DebounceFunc("StunChain" .. unit.name, 300, 4500, doHold)
    end

    if enemy.hp < 60 then
        -- Dont stun to save outselves from angry rogues
        return doHold()
    end
end)

HolyWordChastise:Callback("arenap", function(spell, enemy)
    if unit.hp < 40 then return end
    if enemy.totalImmune then return end
    if enemy.magicImmune then return end
    --if arena1.hp > 70 and arena2.hp > 70 and arena3.hp > 70 then return end
    if player:Buff(408558) then return end
    if player:Buff(410201) then return end
    -- if enemy.stunDr < 1 then return end
    
    if not enemy:Los() then return end
    if not spell:InRange(enemy) then return end

    local maxGcd = MakuluFramework.maxGcd() or 0
    local ccRemains = enemy.ccRemains or 0
    local needHold = enemy.cc and ccRemains > 350 and ccRemains < maxGcd + 200
    if needHold and unit.hp < 50 and (as.lowestEhp > 30 or unit.hp < as.lowestEhp) then
        return
    end

    local doHold = function()
        if needHold then
            MakuluFramework.spellState.gcdHold = true
            print('Holding for smooth cc chainssss')
            return
        end

        return spell:Cast(enemy)
    end

    if not player:TalentKnown(200199) then
        return HolyWordChastise("rogue", enemy, doHold)
    end

    local haveRogue = MakMulti.party:Any(function(friendly)
        return friendly:ClassID() == 4
    end)

    if not haveRogue and enemy.stunDr < 0.5 then return end
    if haveRogue and (enemy.stunDr ~= 0.25 or enemy.stunDrRemains < 8000) then return end

    if haveRogue then
        return doHold()
    end
    
    if enemy:IsUnit(enemyHealer) and enemy.distance <= 15 then
        -- Dont stun to save outselves from angry rogues
        return doHold()
    end
    
    if enemy:IsUnit(enemyHealer) and as.lowestEhp and as.lowestEhp < 40 then
        -- Dont stun to save outselves from angry rogues
        return doHold()
    end

    if enemy:IsUnit(enemyHealer) and as.lowestEhp and as.lowestEhp < 40 and as.lowestUnit and as.lowestUnit.cc then
        -- Dont stun to save outselves from angry rogues
        DebounceFunc("StunChain" .. unit.name, 300, 4500, doHold)
    end

    if enemy.isHealer then return end

    if enemy.ehp < 20 then
        return doHold()
    end

    if enemy:HasBuffFromFor(MakLists.DPSCooldownList, shortHalfSecond) and not enemy:DamageLocked() then
        return doHold()
    end

    if as.highBurstTeam then return end

    local anyMelee = MakMulti.arena:Any(function(arena)
        return enemy.isMelee
    end)

    if enemy.stunDr <= 1 then return end
    if (not anyMelee or (unit.isRanged and enemy.isMelee)) and not enemy:DamageLocked() then
        return doHold()
    end

    if unit.hp < 60 and not enemy:DamageLocked() then
        return doHold()
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

VoidShift:Callback("arenap", function(spell, friendly)
    if friendly.isMe then return end
    if friendly:Buff(buffs.guardian) then return end
    if holdCdOnRay(friendly) then return end

    -- if HolyWordSanctify.cd < 500 and not player:HealLocked() then return end
    if friendly.ehp < 25 and player.hp > 50 and not friendly.totalImmune then
        return spell:Cast(friendly)
    end
end)

VoidShift:Callback("saveSelf", function(spell)
    if player:Buff(buffs.guardian) then return end
    if holdCdOnRay(player) then return end

    -- if GuardianSpirit.cd < 1500 and not player:HealLocked() then return end
    -- if HolyWordSerenity.cd < 500 and not player:HealLocked() then return end
    -- if PowerWordLife.cd < 500 and not player:HealLocked() then return end
    if player.hp < 15 and friendly.hp > 60 then
        return spell:Cast(friendly)
    end
end)

local aggroDispel = MakuluFramework.AtoL({
    "Flame Shock",
    "Moonfire",
    "Sunfire",
    "Vampiric Touch",
    "Agony",
    "Corruption",
})

local angelDispel = MakuluFramework.AtoL({
    "Unstable Affliction",
    "Vampiric Touch",
})

local ccDispelList = MakuluFramework.AtoL({
    "Sleep Walk",
    390612, --frost bomb
    "Frost Bomb",
    "Fear",
    "Psychic Horror",
    "Psychic Scream",
    "Mind Control",
    "Holy Word: Chastise",
    "Freezing Trap",
    "Ring of Frost",
    "Hammer of Justice",
    "Repentance",
    "Polymorph",
    "Chaos Nova",
    "Havoc",
    "Soul Rot",
    "Dread of Winter",
    "Silence",
    "Sphere of Despair",
    "Dragon's Breath",
    "Absoulute Zero",
    "Dead of Winter",
    "Strangulate",
    "Searing Glare",
})

local meleePrioDispel = MakuluFramework.AtoL({
    "Frost Nove",
    "Ice Nove",
    "Entangling Roots",
    "Mass Entanglement",
    "Earthgrab",
    "Landslide",
    "Snowdrift",
    "Landslide",
})

local meleePrioDispelSlows = MakuluFramework.AtoL({
    "Freeze",
    "Cone of Cold",
    "Frost Shock",
})

local mePrioDispel = MakuluFramework.AtoL({
    "Oppressing Roar"
})

Purify:Callback("freemeee", function(spell, friendly)
    if not unit then return end
    if player.cc then return end
    if player:Buff(buffs.spiritOfRedemption) or player:Buff(buffs.spiritOfTheRedeemer) then return end

    -- if unit.hp < 40 then return end

    if friendly:Debuff("Unstable Affliction") and (unit.hp < 80 or as.enemyCdsAny or player.hp < 80) then return end
    if friendly:Debuff("Vampiric Touch") and (unit.hp < 60 or as.enemyCdsAny or player.hp < 40) then return end
    if friendly:Debuff(203337) then return end

    if not unit:Los() then return end

    local toDispel = friendly.isMe and friendly:HasDeBuffFromFor(meleePrioDispel, shortHalfSecond, true)
    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 500 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify me " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            if not friendly:Los() then return end
            return true
        end
    end
end)

Purify:Callback("arenap_prio", function(spell, friendly)
    if not unit then return end
    if player.cc then return end

    if friendly.isMe and (player:Buff(buffs.spiritOfRedemption) or player:Buff(buffs.spiritOfTheRedeemer)) then return end

    -- if unit.hp < 40 then return end

    if friendly:Debuff("Unstable Affliction") and (unit.hp < 80 or as.enemyCdsAny or player.hp < 80) then return end
    if friendly:Debuff("Vampiric Touch") and (unit.hp < 80 or as.enemyCdsAny or player.hp < 40) then return end
    if friendly:Debuff(203337) then return end
    if not friendly:Los() then return end

    local toDispel =  friendly.isMe and friendly:HasDeBuffFromFor(mePrioDispel, shortHalfSecond, true)
    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 500 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify me " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            if not friendly:Los() then return end
            return true
        end
    end 

    local doAggro = (player:TalentKnown(196439) and spell.frac > 1.5) or friendly.cds

    toDispel = doAggro and (friendly.isMelee or friendly.isMe) and friendly:HasDeBuffFromFor(meleePrioDispel, shortHalfSecond, true)

    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 500 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify root " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            
            return true
        end
    end

    -- toDispel = doAggro and friendly.isMelee and friendly:HasDeBuffFromFor(meleePrioDispelSlows, shortHalfSecond, true)

    -- if toDispel then
    --     local remains = toDispel.expiration - (GetTime() * 1000)
    --     if remains > 1500 and spell:Cast(friendly) then 
    --         Aware:displayMessage("Purify slow " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
    --         return true
    --     end
    -- end

    toDispel = friendly:HasDeBuffFromFor(ccDispelList, shortHalfSecond, true)
    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 500 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            if not friendly:Los() then return end
            return true
        end
    end
end)

Purify:Callback("angel", function(spell, friendly)
    if not player:Buff(buffs.spiritOfRedemption) and not player:Buff(buffs.spiritOfTheRedeemer) then return end
    if not unit then return end
    if player.cc then return end
    if friendly.isMe then return end
    if unit.ehp < 30 then return end

    if not friendly:Los() then return end
    local toDispel = friendly:HasDeBuffFromFor(angelDispel, shortHalfSecond, true)
    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 1000 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            return true
        end
    end
end)

Purify:Callback("arenap_low", function(spell, friendly)
    if not unit then return end
    if player.cc then return end

    -- Keep dots on us to keep PoM off us
    if friendly.isMe then return end

    if unit.hp < 70 then return end
    if not friendly:Los() then return end

    if friendly:Debuff("Unstable Affliction") then return end
    if friendly:Debuff("Vampiric Touch") then
        if unit.hp < 80 or as.enemyCdsAny or player.hp < 40 then return end
        if not player:TalentKnown(390632) then return end
        local vt = friendly:HasDeBuffFor("Vampiric Touch")
        if vt > shortHalfSecond then
            if spell:Cast(friendly) then
                Aware:displayMessage("Purify VT on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
                return true
            end
        end
        return
    end

    if (not player:TalentKnown(196439) or spell.frac < 1.5) and not MakMulti.arena:Any(function(arena)
        local classId = arena:ClassID()
        return classId == 9 or classId == 8
    end) then return end

    if not friendly:IsUnit(unit) and (unit.hp < 60 or player.manaPct < 40) then return end

    local toDispel = friendly:HasDeBuffFromFor(aggroDispel, shortHalfSecond, true)

    if toDispel then
        local remains = toDispel.expiration - (GetTime() * 1000)
        if remains > 1500 and spell:Cast(friendly) then 
            Aware:displayMessage("Purify " .. toDispel.name .. " on " .. friendly.name, 'Priest', 1.5, GetSpellTexture(spell.id))
            return true
        end
    end
end)

PowerInfusion:Callback("arenap", function(spell, friendly)
    if friendly.isMe then return end
    if player.combatTime == 0 then return end
    if not target.exists or not target.canAttack then return end
    if not friendly:Los() then return end
    if target.distance > 40 then return end
    if friendly.cc or friendly:DamageLocked() then return end
    if friendly.name == "Glimpsegoo" then return end
    if friendly.cds then
        return Debounce("pi" .. friendly.name, 500, 2500, spell, friendly)
    end
end)

PowerInfusion:Callback("force", function(spell)
   getPartyCdList():ForEach(function (friendly)
        if not friendly:Los() then return end
        if friendly.cc or friendly:DamageLocked() then return end
        if friendly.name == "Glimpsegoo" then return end
        return spell:Cast(friendly)
    end)

    getPartyList():ForEach(function (friendly)
        if friendly.isMe then return end
        if not friendly:Los() then return end
        if friendly.cc or friendly:DamageLocked() then return end
        if friendly.name == "Glimpsegoo" then return end
        return spell:Cast(friendly)
    end)

    getPartyList():ForEach(function (friendly)
        if friendly.isMe then return end
        if not friendly:Los() then return end
        return spell:Cast(friendly)
    end)

    return spell:Cast(player)
end)

local UnitHealth = UnitHealth

function MakUnit:HealthActual()
    return self.cache:GetOrSet("HealthActual", function()
        local delta = 0
        if rayTarget and rayTarget == rawget(self, "guid") then
            delta = rayDelta
        end

        return (UnitHealth(MakUnit.CallerId(self)) or 0) + delta
    end)
end

MakuluFramework.Unit.reindex()

local feezingTrapId = 187650
local diamondIce = 203340

local swdCastTIme = 0

local tryDodgeList = MakuluFramework.AtoL({
    --"Storm Bolt",
    "Death Grip",
    "Wild Charge",
    "Shadowstep",
    "Charge"
})

local function combatLog(_, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool,
        casterGUID, casterName, casterFlags, casterRaidFlags, absorbSpellId, absorbSpellName, absorbSpellSchool, amount, critical = CombatLogGetCurrentEventInfo()

    if subevent == "SPELL_DAMAGE" and destGUID == player.guid then
        playerDamageTaken = GetTime()
        return
    end

    if subevent == "SPELL_CAST_SUCCESS" and sourceGUID and sourceName then
        if sourceGUID == player.guid and destGUID then 
          if bigHealList[spellID] or bigHealList[spellName] then
            bigHealIncoming[destGUID] = GetTime() 
          end
        end

        local caster = MakUnit:newGUID(sourceGUID, sourceName)
        if not caster.isFriendly then
            if spellName == "Harpoon" then
                tryFadeTime = GetTime() - 0.2
                tryDeathTime = tryFadeTime
            end

            if destGUID == player.guid and tryDodgeList[spellName] then
                tryFadeTime = GetTime() - 0.2
            end
        end
    end

    if spellID == 197268 and subevent == "SPELL_AURA_APPLIED" and sourceGUID == player.guid then
        rayTarget = destGUID
        rayDelta = 0
        return
    end

    if spellID == 197268 and subevent == "SPELL_AURA_REMOVED" then
        if rayTarget == destGUID then
            print("Ray casting finished")
            C_Timer.After(0.1, function ()
              print("Ray timer done. Delta was " .. rayDelta)
              rayDelta = 0
              rayTarget = nil
            end)
        end
        return
    end

    if (subevent == "SPELL_ABSORBED" or subevent == "SPELL_HEAL_ABSORBED") then
        if rayTarget and rayTarget ~= destGUID then return end

        local absorber = absorbSpellId
        local absorbAmount = amount
        if (subevent == "SPELL_HEAL_ABSORBED") then
            absorber = spellID
        elseif critical == nil then
            absorber = casterName
            absorbAmount = absorbSpellId -- If its a swing then lets account for it?
        end

        if absorber ~= 197268 then return end

        if subevent == "SPELL_ABSORBED" then
            rayDelta = rayDelta - absorbAmount
        else
            rayDelta = rayDelta + (absorbAmount * 1.5)
        end
        return
    end

    if sourceGUID ~= player.guid then return end
    if spellID == ShadowWordDeath.id and subevent == "SPELL_CAST_SUCCESS" then
      swdCastTIme = GetTime()
    end

    if spellID ~= Renew.id then return end

    if subevent == "SPELL_CAST_SUCCESS" then
        castedRenewTrack[destGUID] = GetTime()
        bigRenewTracker[destGUID] = true
        return
    end

    if subevent == "SPELL_AURA_APPLIED" then
        local empowered = castedRenewTrack[destGUID]
        if empowered then
            if (GetTime() - empowered) < 0.5 then
                bigRenewTracker[destGUID] = true
            end
            castedRenewTrack[destGUID] = nil
        else
            bigRenewTracker[destGUID] = false
        end
        return
    end

    if subevent == "SPELL_AURA_REFRESH" then
        local empowered = castedRenewTrack[destGUID]
        if empowered then
            if (GetTime() - empowered) < 0.5 then
                bigRenewTracker[destGUID] = true
            end
            castedRenewTrack[destGUID] = nil
        end
        return
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local lastExecTime = 0



local function mainLoop(icon)
	FrameworkStart(icon)
    updateGameState()
    -- SetUpHealers()

    local healable = getPartyList()

    unit = healable:Lowest(function(friendly)
        return (friendly.isMe and friendly.ehp + 10) or friendly.ehp
    end) or player

    if target.exists and target.isFriendly then
        if target.ehp < unit.ehp then
            unit = target
        end
    end

    local alpha = 0
    if focus.exists then

        local plates = MakuluFramework.Plates.load()
        local found = plates[rawget(focus, "guid")]

        if found then
            alpha = focus:Los()
        end
    end

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Player HP ", player.hp)

        MakPrint(2, "AS cds ", as.enemyCds)
        MakPrint(3, "AS cds remains", as.enemyCdRemains)

        local total, _, _, _, cds = unit:AttackersV69()
        MakPrint(4, "Heal target cds", cds)
        MakPrint(5, "Heal target total", total)
        MakPrint(6, "Last Exec time", lastExecTime)
        MakPrint(7, "Focus Alpha", alpha)

        MakPrint(8, "Big renew", hasBigRenew(unit or player))
        MakPrint(9, "Ray Delta", rayDelta)
        MakPrint(10, "Unit name", unit.name)
        MakPrint(11, "Dispel Count", player:GetCD("Shadow Word: Death"))
    end

	-- local CantCast = CantCast()
	-- if CantCast then return end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= player.combatTime
	playerHealth	= player.hp

    -- a6()
    -- a7()
    -- a8()
    -- a9()
    -- a10()

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
        --PreCombat()
    else
        SelfDefensive()
    end

    --Healing Rotation PVE
    if (target.exists or focus.exists) then
        if false and Action.Zone ~= "arena" then
    --         HealerRotat
    -- PowerWordShield('arena')ionPve()
    --         AngelicFeather('Movement')
        else
           
        end
    end

   
    HealerRotationPvp()
    

    if not A.IsInPVP then   
        HealerRotationPve()
    end

    --Damage Rotation PVE
    if target.exists and target.canAttack and Action.Zone ~= "arena" then
        DamageRotationPve()
    end

	return FrameworkEnd()
end

local function profile(icon)
    local start = debugprofilestop()
    local res = mainLoop(icon)
    lastExecTime = debugprofilestop() - start
    return res
end

A[3] = profile
