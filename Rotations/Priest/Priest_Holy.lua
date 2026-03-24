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
    --FlashHeal         = { ID = 2061, offGcd = true, ignoreCasting = true      },
    --Heal              = { ID = 2060, offGcd = true, ignoreCasting = true      },
    AngelicFeather      = { ID = 121536, Macro = "/cast [@player]spell:thisID"    },
    DesperatePrayer     = { ID = 19236     },
    DispelMagic         = { ID = 528, MAKULU_INFO = { damageType = "magic" }        },
    DivineStar          = { ID = 110744    },
    DominateMind        = { ID = 205364    },
    Fade                = { ID = 586       },
    FlashHeal           = { ID = 2061, Macro = "/cast [@target,help][@focus,help]spell:thisID"     },
    Halo                = { ID = 120517    },
    Heal                = { ID = 2060, Macro = "/cast [@target,help][@focus,help]spell:thisID"      },
    HolyNova            = { ID = 132157    },
    LeapofFaith         = { ID = 73325     },
    Levitate            = { ID = 1706      },
    MassDispel          = { ID = 32375     },
    MindBlast           = { ID = 8092, MAKULU_INFO = { damageType = "magic" }   },
    MindControl         = { ID = 605       },
    MindSoothe          = { ID = 453       },
    MindVision          = { ID = 2096      },
    Mindgames           = { ID = 375901    },
    PowerInfusion       = { ID = 10060     },
    PowerInfusionP      = { ID = 10060, Texture = 316262, Hidden = true, MAKULU_INFO = { ignoreCasting = true }     },
    PowerWordFortitude  = { ID = 21562, Macro = "/cast [@player]spell:thisID"     },
    PowerWordLife       = { ID = 373481, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordLifeToo    = { ID = 440678, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordShield     = { ID = 17, Macro = "/cast [@target,help][@focus,help]spell:thisID"        },
    PrayerOfMending     = { ID = 33076, Macro = "/cast [@target,help][@focus,help]spell:thisID"     },
    PrayerOfMendingBuff = { ID = 41635, Hidden = true		},
    PsychicScream       = { ID = 8122      },
    Renew               = { ID = 139, Macro = "/cast [@target,help][@focus,help]spell:thisID"       },
    Resurrection        = { ID = 2006, Macro = "/cast [@target,help][@focus,help]spell:thisID"      },
    ShackleUndead       = { ID = 9484      },
    ShadowWordDeath     = { ID = 32379     },
    ShadowWordPain      = { ID = 589       },
    Shadowfiend         = { ID = 34433	 },
    Smite               = { ID = 585, MAKULU_INFO = { damageType = "magic" }       },
    VampiricEmbrace     = { ID = 15286     },
    VoidShift           = { ID = 108968, MAKULU_INFO = { ignoreCasting = true } },
    VoidTendrils        = { ID = 108920    },

    -- Holy Specific
    Apotheosis        = { ID = 200183    },
    DivineHymn        = { ID = 64843     },
    DivineWord        = { ID = 372760	 },
    EmpyrealBlaze     = { ID = 372616    },
    EmpyrealBlazeBuff = { ID = 372617, Hidden = true	},
    GreaterHeal       = { ID = 289666,   },
    GuardianSpirit    = { ID = 47788, MAKULU_INFO = { offGcd = true, ignoreCasting = true }, Macro = "/cast [@target,help][@focus,help]spell:thisID" },
    HolyFire          = { ID = 14914, MAKULU_INFO = { damageType = "magic" }     },
    HolyWordChastise  = { ID = 88625     },
    HolyWordSalvation = { ID = 265202    },
    HolyWordSanctify  = { ID = 34861, Macro = "/cast [@player]spell:thisID"     },
    HolyWordSerenity  = { ID = 2050, Macro = "/cast [@target,help][@focus,help]spell:thisID"      },
    LightweaverBuff   = { ID = 390993, Hidden = true    },
    LightweaverTalent = { ID = 390992, Hidden = true    },
    Lightwell         = { ID = 372835    },
    MassResurrection  = { ID = 212036    },
    PrayerCircle      = { ID = 321377	},
    PrayerofHealing   = { ID = 596, Macro = "/cast [@target,help][@focus,help]spell:thisID"       },

    Purify            = { ID = 527, Macro = "/cast [@target,help][@focus,help]spell:thisID"       },
    SurgeofLight      = { ID = 109186	},
    SurgeofLightBuff  = { ID = 114255	},
    SymbolofHope      = { ID = 64901     },

    -- Hero Talents
    MiraculousRecovery                    = { ID = 440674, Hidden = true  },
    PowerSurge                            = { ID = 453109, Hidden = true  },
    WasteNoTime                           = { ID = 440681, Hidden = true  },

    -- PvP Talents
    CircleofHealing       = { ID = 204883, Macro = "/cast [@target,help][@focus,help]spell:thisID"    },
    DivineAscension       = { ID = 328530    },
    DivineImage           = { ID = 405963, Hidden = true 	},
    Epiphany              = { ID = 414553 	},
    GreaterFade           = { ID = 213602    },
    HolyWard              = { ID = 213610    },
    HolyWordConcentration = { ID = 289657    },
    PhaseShift            = { ID = 408557 	},
    RayofHope             = { ID = 197268    },
    ResonantWords         = { ID = 372313, Hidden = true 	},
    SpiritofRedemption    = { ID = 27827, Hidden = true 	},
    SpiritoftheRedeemer   = { ID = 215769    },
    Thoughtsteal          = { ID = 316262    },

	--Improved Dispel
	ImprovedDispelTalent                  = { ID = 390632, Hidden = true  },

    PremonitionBundle                     = { ID = 428924 },
    TranslucentImage   		  	          = { ID = 373446, Hidden = true 	},
    EternalSanctity   		  	          = { ID = 1215245, Hidden = true 	},
    EmpoweredRenew   		  	          = { ID = 391339, Hidden = true 	},

    --Infa adds for Arena
    PremonitionofInsightArena = { ID = 428933, FixedTexture = 5927640, Hidde = true, MAKULU_INFO = { ignoreCasting = true } }, 
    PremonitionofPietyArena = { ID = 428930, FixedTexture = 5927640, Hidde = true, MAKULU_INFO = { ignoreCasting = true } },
    PremonitionofSolaceArena = { ID = 428934, FixedTexture = 5927640, Hidde = true, MAKULU_INFO = { ignoreCasting = true }  },
    PremonitionofClairvoyanceArena = { ID = 440725, FixedTexture = 5927640, Hidde = true, MAKULU_INFO = { ignoreCasting = true }  },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_PRIEST_HOLY] = A
TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "FlashHeal", "Heal", "GreaterHeal", "Smite", "MindBlast", "HolyFire",
        "PrayerofHealing", "DivineHymn", "MassDispel", "Mindgames"
    }

    for _, spellName in ipairs(castTimeSpellNames) do
        local spell = M[spellName]
        if spell then
            rawset(spell, "ignoreMoving", castWhileMoving)
        end
    end
end

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
    prayerOfMending = 41635,
    renew = 139,
}

local debuffs = {

}

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

local function num(value)
    return value and 1 or 0
end

local function enemyBurstCount()
    local burstCount = 0

    if arena1.exists and arena1.cds then burstCount = burstCount + 1 end
    if arena2.exists and arena2.cds then burstCount = burstCount + 1 end
    if arena3.exists and arena3.cds then burstCount = burstCount + 1 end

    return burstCount
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

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)

    local unitID = thisUnit.Unit
    local Role = thisUnit.Role

    if Action.Zone == "arena" then
        local unitA = MakUnit:new(unitID)

        --Spirit of Redemption / Spirit of the Redeemer
        if unitA:Buff(buffs.spiritOfRedemption) or unitA:Buff(buffs.spiritOfTheRedeemer) then
            thisUnit.Enabled = false
        else 
            thisUnit.Enabled = true
        end
    end

    if Action.Zone == "arena" or thisUnit.realHP < 35 then return end

    -- Check if 'HE' should not be used based on certain conditions
    if thisUnit.Enabled then 
        local unit = Unit(unitID)
        
        -- Condition: Player is mounted
        local isPlayerMounted = Player:IsMounted()
        
        -- Condition: Unit is out of range (> 40 yards)
        local isUnitOutOfRange = unit:GetRange() > 40
        
        -- Buff IDs for Spirit of Redemption and Spirit of Redeemer
        local spiritOfRedemptionBuffID = 27827  -- Spirit of Redemption
        local spiritOfRedeemerBuffID = 215769   -- Spirit of Redeemer
        
        -- Condition: Unit has Spirit of Redemption or Spirit of Redeemer buff
        local unitHasSpiritBuff = unit:IsBuffUp(spiritOfRedemptionBuffID) or unit:IsBuffUp(spiritOfRedeemerBuffID)
        
        -- If any condition is true, disable 'thisUnit'
        if isPlayerMounted or unitHasSpiritBuff then --
            thisUnit.Enabled = false
        end
    end

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

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

--################################################################################################################################################################################################################

local function CanPowerInfusion()
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return false end

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

local function holdGCDforSWDP()
    if Action.Zone ~= "arena" then return false end
    if ShadowWordDeath:Cooldown() > 1000 then return false end
    if getBelowHP(30) > 0 then return false end
    if arena1.exists and arena1:CastingFromFor(MakLists.swdList, 1) and not arena1:CastingFromFor(MakLists.swdList, 420) then return true end
    if arena2.exists and arena2:CastingFromFor(MakLists.swdList, 1) and not arena2:CastingFromFor(MakLists.swdList, 420) then return true end
    if arena3.exists and arena3:CastingFromFor(MakLists.swdList, 1) and not arena3:CastingFromFor(MakLists.swdList, 420) then return true end
    return false
end

local function holdGCDforSWD()
    if Action.Zone ~= "arena" then return false end
    if ShadowWordDeath.cd > 1000 then return false end
    if getBelowHP(30) > 0 then return false end
    if arena1.exists and arena1:CastingFromFor(MakLists.swdList, 1) --[[and not arena1:CastingFromFor(MakLists.swdList, 420)]] then return true end
    if arena2.exists and arena2:CastingFromFor(MakLists.swdList, 1) --[[and not arena2:CastingFromFor(MakLists.swdList, 420)]] then return true end
    if arena3.exists and arena3:CastingFromFor(MakLists.swdList, 1) --[[and not arena3:CastingFromFor(MakLists.swdList, 420)]] then return true end
    return false
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

    -- Use proactively as a defensive if Translucent Image is talented and big damage is incoming
    if player:TalentKnown(TranslucentImage.id) and shouldDefensive() then
        return spell:Cast(player)
    end

    -- Drop threat instantly if we grab aggro in PvE
    if player.inCombat then
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy and enemy.exists and enemy.inCombat and enemy.canAttack then
                local threat = UnitThreatSituation("player", enemy:CallerId())
                if threat and threat >= 2 then
                    return spell:Cast(player)
                end
                local dest = enemy.target
                if dest and dest.guid == player.guid then
                    return spell:Cast(player)
                end
            end
        end
    end
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

    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if Action.Zone == "arena" and currentCombatTime > 0 then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(PowerWordFortitude.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 or C_Map.GetBestMapForUnit(player:CallerId()) ~= C_Map.GetBestMapForUnit(unit:CallerId()) end)
    
    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then 
        return Debounce("pwf", 1000, 2500, spell, player)
    end
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
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if diseased and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(diseased:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### EMERGENCY SINGLE TARGET COOLDOWN ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VoidShift
VoidShift:Callback('Emergency', function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if not unit:IsPlayer() then return end

    -- M+ optimized: More aggressive, prioritize tank
    -- Tank: 30% HP, Others: 25% HP
    local threshold = unit.isTank and 30 or 25
    if unit.hp > threshold then return end

    -- Only use if we have enough HP to give (at least 50%)
    if player.hp < 50 then return end

    return spell:Cast(unit)
end)

-- GuardianSpirit
GuardianSpirit:Callback('Emergency', function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if not unit:IsPlayer() then return end

    -- M+ optimized: More aggressive threshold
    -- Tank: 40% HP, DPS/Healer: 30% HP
    local threshold = unit.isTank and 40 or 30
    if unit.hp > threshold then return end

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
    -- Emergency use: 0 charges of Serenity and someone below 50% HP
    if HolyWordSerenity:Charges() == 0 then
        local someoneBelow50 = MakMulti.party:Any(function(u)
            return u.exists and not u:IsDeadOrGhost() and u.hp < 50
        end)

        if someoneBelow50 then
            return spell:Cast(player)
        end
    end

    -- Normal cooldown usage
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

-- Power Word: Life - Bare bones TFO logic
PowerWordLife:Callback('HealingPve', function(spell, unit)
    if not (A.PowerSurge:IsTalentLearned() or A.WasteNoTime:IsTalentLearned()) then return end
    if unit.hp <= 0 then return end
    if unit.hp < 35 then
        return spell:Cast(unit)
    end
end)

PowerWordLifeToo:Callback('HealingPve', function(spell, unit)
    if not A.MiraculousRecovery:IsTalentLearned() then return end
    if unit.hp <= 0 then return end
    if unit.hp < 50 then
        return spell:Cast(unit)
    end
end)

-- FlashHeal (Free Cast - Surge of Light buff)
FlashHeal:Callback('Freecast', function(spell)
    if not player:Buff(114255) then return end
    -- High priority free cast - use on anyone below 92% HP
    if unit.hp >= 92 then return end

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
    -- Check if buff conditions and AoE healing are valid
    if not AreBuffsValid() or not CanUseAoeHealing() then return end

    if player:TalentKnown(321377) and player:Buff(321377) then return end

    -- Check if healing target is within 13 yards (Sanctify range)
    -- Since we have @player macro, we cast at player location, so check if unit is within 13 yards of player
    if unit.exists and not unit:IsDeadOrGhost() then
        if unit.distance and unit.distance > 13 then return end
    end

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
    local baseSlider = GetToggle(2, "HolyWordSerenitySlider")
    local serenityThreshold = baseSlider + (num(unit:Buff(buffs.insurance, true)) * 25)

    -- Emergency: Always cast if target is critically low (no holding)
    local emergencyThreshold = math.max(55, baseSlider - 10)
    if unit.ehp <= emergencyThreshold then
        return spell:Cast(unit)
    end

    -- M+ Mode: More aggressive, less holding
    -- Only hold for buffs if target is above 70% HP (safe to wait)
    if unit.hp > 70 then
        -- Check buff gating only when safe
        if not AreBuffsValid() then return end

        -- Charge/Apotheosis sync: only hold if very safe
        if player:TalentKnown(EternalSanctity.id) then
            if Apotheosis.cd < spell:TimeToFullCharges() and not player:Buff(buffs.apotheosis) then
                if spell.charges < spell.maxCharges and unit.hp > 70 then return end
            end
        end

        -- Answered Prayers: only hold if very safe
        if player:HasBuffCount(buffs.answeredPrayers) >= 40 and not player:Buff(buffs.apotheosis) then
            if spell.charges < spell.maxCharges and unit.hp > 70 then return end
        end
    end

    if A.PremonitionBundle:IsReadyByPassCastGCD() and getBelowHP(90) >= 1 then
        return PremonitionBundle('HealingPve')
    end

    local insuranceUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return HolyWordSerenity:InRange(friendly) and friendly.hp > 0 and friendly.ehp < baseSlider + (num(friendly:Buff(buffs.insurance, true)) * 25) end
    )

    if insuranceUnit then
        if unit:BuffRemains(buffs.insurance, true) > 1000 and unit.ehp > serenityThreshold then
            HealingEngine.SetTarget(insuranceUnit:CallerId(), 1)
        end
    end

    -- Cast if target is below threshold (simple HP check, no AutoHeal)
    if unit.ehp <= serenityThreshold then
        return spell:Cast(unit)
    end
end)

-- PrayerOfMending
-- DISABLED: Using "14stack" callback instead for on-CD tank priority logic
--[[
PrayerOfMending:Callback('HighPrio', function(spell)
    if GetToggle(2, "PrayerofMendingMenu") ~= "1" then return end
    if unit:Buff(A.PrayerOfMendingBuff.ID) then return end
    -- Cast on anyone below 95% HP - NO WAITING
    if unit.hp >= 95 then return end

    return spell:Cast(unit)
end)
--]]

-- PrayerOfHealing
PrayerofHealing:Callback('HealingPve', function(spell)
    if not isStaying then return end

    -- M+ optimized: 3 people below 85% HP (more aggressive than raid)
    if getBelowHP(85) < 3 then return end

    return spell:Cast(player)
end)

PrayerofHealing:Callback('HealingPveBuffd', function(spell)
    if isStaying then return end

    if not player:TalentKnown(321377) then return end
    if not player:Buff(321377) then return end

    -- With buff, can use on 2 people below 80%
    if getBelowHP(80) < 2 then return end

    return spell:Cast(player)
end)

-- Halo
Halo:Callback('HealingPve', function(spell)
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

-- CircleofHealing
CircleofHealing:Callback('HealingPve', function(spell)
    -- M+ optimized: More aggressive than CanUseAoeHealing for instant cast
    -- Use if 3+ people below 80% OR use normal AoE logic
    local below80 = getBelowHP(80)
    if below80 >= 3 then
        return spell:Cast(unit)
    end

    -- Fall back to normal AoE healing logic
    if not CanUseAoeHealing() then return end

    return spell:Cast(unit)
end)

-- FlashHeal + Lightweaver - Build stacks more often to maintain Lightweaver procs
FlashHeal:Callback('Lightweaver', function(spell)
    if not A.LightweaverTalent:IsTalentLearned() then return end

    -- If we have Lightweaver buff, skip Flash Heal (use Heal instead)
    if player:Buff(A.LightweaverBuff.ID) then return end

    -- Use Lightweaver slider for threshold
    local lightweaverSlider = GetToggle(2, "LightweaverSlider")
    if unit.hp > lightweaverSlider then return end

    return spell:Cast(unit)
end)

-- Heal + Lightweaver - ONLY cast when you have buff and target below Lightweaver slider (cheap, fast, big heal)
Heal:Callback('Lightweaver', function(spell)
    if not A.LightweaverTalent:IsTalentLearned() then return end
    if not player:Buff(A.LightweaverBuff.ID) then return end

    local lightweaverSlider = GetToggle(2, "LightweaverSlider")
    if unit.hp >= lightweaverSlider then return end

    return spell:Cast(unit)
end)

-- FlashHeal (Panic Mode - always fires below 60% HP)
FlashHeal:Callback('Panic', function(spell)
    -- Emergency Flash Heal - ignores sliders, always fires below 60% HP
    if unit.hp >= 60 then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('HealingPve', function(spell)
    -- Use Flash Heal slider for threshold
    local flashHealSlider = GetToggle(2, "FlashHealSlider")
    if unit.hp > flashHealSlider then return end

    -- If Lightweaver is talented and you have the proc, don't override it on targets >60% HP
    if A.LightweaverTalent:IsTalentLearned() then
        if player:Buff(A.LightweaverBuff.ID) and unit.hp > 60 then return end
    end

    return spell:Cast(unit)
end)

-- Heal + Waste No Time - Cast when you have the buff (instant, 15% less mana)
Heal:Callback('WasteNoTime', function(spell)
    if not A.WasteNoTime:IsTalentLearned() then return end

    -- Only cast if we have Waste No Time buff (makes Heal instant)
    if not player:Buff(440683) then return end

    -- Use on anyone below 80% HP
    if unit.hp >= 80 then return end

    return spell:Cast(unit)
end)


-- Heal (Fallback/Filler) - Basic topping off when not moving
Heal:Callback('HealingPve', function(spell)
    if player.moving then return end

    -- Use Heal slider for threshold
    local healSlider = GetToggle(2, "HealSlider")
    if unit.hp > healSlider then return end
    -- Don't use Heal on critically low targets, use Flash Heal instead
    if unit.hp < 60 then return end

    return spell:Cast(unit)
end)

PrayerOfMending:Callback("14stack", function(spell, unit)
    if not spell:ReadyToUse() then return end
    -- Cast on CD regardless of combat status

    -- Check if tank exists and is in range
    if tank.exists and not tank:IsDeadOrGhost() and spell:InRange(tank) then
        local tankStacks = tank:HasBuffCount(buffs.prayerOfMending, true) or 0

        -- If tank doesn't have 14 stacks, cast on tank
        if tankStacks < 14 then
            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(tank)
        end
    end

    -- Tank has 14 stacks or doesn't exist, find best alternative target
    -- First priority: lowest HP person who needs healing
    local lowestHpTarget = MakMulti.party:Lowest(
        function(u) return u.hp end,
        function(u) return u.exists and not u:IsDeadOrGhost() and spell:InRange(u) and u.hp < 100 end
    )

    if lowestHpTarget then
        HealingEngine.SetTarget(lowestHpTarget:CallerId(), 1)
        return spell:Cast(lowestHpTarget)
    end

    -- Everyone is full HP, find person with lowest PoM stacks
    local lowestStacksTarget = MakMulti.party:Lowest(
        function(u) return u:HasBuffCount(buffs.prayerOfMending, true) or 0 end,
        function(u) return u.exists and not u:IsDeadOrGhost() and spell:InRange(u) end
    )

    if lowestStacksTarget then
        HealingEngine.SetTarget(lowestStacksTarget:CallerId(), 1)
        return spell:Cast(lowestStacksTarget)
    end
end)

local RENEW_ID = buffs and buffs.renew or 139

Renew:Callback("OnCD", function(spell, unit)
    if not spell:ReadyToUse() then return end

    -- Use Renew slider for HP threshold
    local renewSlider = GetToggle(2, "RenewSlider")

    -- Priority 1: Tank without Renew or about to expire (< 4 seconds) and below slider threshold
    if tank.exists and not tank:IsDeadOrGhost() and spell:InRange(tank) then
        local tankRenewRemains = tank:BuffRemains(buffs.renew) or 0
        if tankRenewRemains < 4000 and tank.hp <= renewSlider then
            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(tank)
        end
    end

    -- Priority 2: Lowest HP person without Renew or about to expire (must be below slider threshold)
    local lowestHpNeedsRenew = MakMulti.party:Lowest(
        function(u) return u.hp end,
        function(u)
            local renewRemains = u:BuffRemains(buffs.renew) or 0
            return u.exists and not u:IsDeadOrGhost() and spell:InRange(u) and renewRemains < 4000 and u.hp <= renewSlider
        end
    )

    if lowestHpNeedsRenew then
        HealingEngine.SetTarget(lowestHpNeedsRenew:CallerId(), 1)
        return spell:Cast(lowestHpNeedsRenew)
    end

    -- Priority 3: Anyone without Renew or about to expire (must be below slider threshold)
    local anyoneNeedsRenew = MakMulti.party:Find(
        function(u)
            local renewRemains = u:BuffRemains(buffs.renew) or 0
            return u.exists and not u:IsDeadOrGhost() and spell:InRange(u) and renewRemains < 4000 and u.hp <= renewSlider
        end
    )

    if anyoneNeedsRenew then
        HealingEngine.SetTarget(anyoneNeedsRenew:CallerId(), 1)
        return spell:Cast(anyoneNeedsRenew)
    end
end)

-- PowerWordShield (Proactive Tank Shielding)
PowerWordShield:Callback('TankShield', function(spell)
    -- Proactively shield tank if they don't have shield
    if not tank.exists or tank:IsDeadOrGhost() then return end
    if not spell:InRange(tank) then return end
    if tank:Buff(A.PowerWordShield.ID) then return end

    -- Use Power Word Shield slider for threshold
    local pwsSlider = GetToggle(2, "PowerWordShieldSlider")

    -- Shield tank if they're in combat and below slider threshold
    if player.inCombat and tank.hp < pwsSlider then
        HealingEngine.SetTarget(tank:CallerId(), 1)
        return spell:Cast(tank)
    end
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

    -- Use Power Word Shield slider for threshold
    local pwsSlider = GetToggle(2, "PowerWordShieldSlider")
    if unit.hp >= pwsSlider then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL DAMAGE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ShadowWordDeath
ShadowWordDeath:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    if target.hp > 35 then return end

    return spell:Cast(target)
end)

-- Shadowfiend
Shadowfiend:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if player.manaPct >= 80 then return end

    return spell:Cast(target)
end)

-- HolyWordChastise
HolyWordChastise:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    return spell:Cast(target)
end)

-- HolyFire
HolyFire:Callback('Buffed', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    if not player:Buff(buffs.empyrealblaze) then return end

    return spell:Cast(target)
end)

-- Holy Nova
HolyNova:Callback('DamagePve', function(spell)
    if player:HasBuffCount(390636) < 20 then return end
    if MultiUnits:GetByRange(8) < GetToggle(2, "HolyNovaSlider") then return end
    if getBelowHP(96) > 0 then return end

    return spell:Cast(player)
end)

-- DivineStar
DivineStar:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if Unit("target"):GetRange() > 30 then return end

    return spell:Cast(target)
end)

-- HolyFire
HolyFire:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    --if target:DebuffRemains(14914) >= 3000 then return end

    return spell:Cast(target)
end)

-- ShadowWordPain
ShadowWordPain:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
    if target:DebuffRemains(589) >= 3000 then return end

    return spell:Cast(target)
end)

-- Smite
Smite:Callback('DamagePve', function(spell)
    -- Never DPS if anyone needs healing
    if getBelowHP(90) > 0 then return end
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

    -- Emergency Defensives
    VoidShift('Emergency')
    GuardianSpirit('Emergency')

    -- Emergency Power Word: Life (< 35-50% HP)
    PowerWordLife('HealingPve', unit)
    PowerWordLifeToo('HealingPve', unit)

    -- Racials
    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')

    -- Major Cooldowns (AoE healing)
    HolyWordSalvation('Cooldowns')
    DivineHymn('Cooldowns')
    Apotheosis('Cooldowns')
    PowerInfusion('Cooldowns')

    -- Emergency Low HP Healing
    HolyWordSerenity('HealingPve')
    -- Waste No Time Proc Healing (instant Heal)
    Heal('WasteNoTime')

    -- Free Flash Heal (Surge of Light proc, < 92% HP)
    FlashHeal('Freecast')

    -- Lightweaver Proc Healing
    Heal('Lightweaver')

    -- Dispels
    Purify('Dispel')

    -- Maintain HoTs/Buffs (keep on CD with tank priority)
    PrayerOfMending("14stack", unit)
    Renew("OnCD", unit)
    PowerWordShield('TankShield')

    -- Holy Words (main healing tools)
    DivineWord('HealingPve')
    HolyWordSanctify('HealingPve')

    -- Lightweaver Proc Healing (Flash Heal builds stacks, Heal consumes proc)
    FlashHeal('Lightweaver')

    -- Single Target Filler Healing 
    FlashHeal('HealingPve')

    -- AoE Healing (only if multiple people need healing)
    CircleofHealing('HealingPve')
    Halo('HealingPve')
    Lightwell("auto")

    -- Prayer of Healing (lower priority in M+, requires 3+ people)
    PrayerofHealing('HealingPveBuffd')
    PrayerofHealing('HealingPve')

    -- Movement/Low Priority
    PowerWordShield('HealingAndMoving')
    
    -- Single Target Filler Healing 
    Heal('HealingPve')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
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
-- Fade
Fade:Callback("arena", function(spell)
    local castOrChannelAone = arena1.castOrChannelInfo
    local castOrChannelAtwo = arena2.castOrChannelInfo
    local castOrChannelAthree = arena3.castOrChannelInfo
    if Action.Zone ~= "arena" then return end
    if not IsPlayerSpell(PhaseShift.id) then return end
    if arena1.exists and arena1:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAone.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena1", "White", 1) end
            return spell:Cast(player)
        end
    end

    if arena2.exists and arena2:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAtwo.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena2", "White", 1) end
            return spell:Cast(player)
        end
    end

    if arena3.exists and arena3:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAthree.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena3", "White", 1) end
            return spell:Cast(player)
        end
    end
end)

PsychicScream:Callback("arena", function(spell)
    if getBelowHP(40) > 0 then return end
    if player:Debuff(410201) then return end -- searing glare
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if not enemyHealer.exists then return end
    if enemyHealer.distance <= 3 and not enemyHealer.totalImmune and not enemyHealer.magicImmune and not enemyHealer.ccImmune and enemyHealer.ccRemains < 1000 and enemyHealer.disorientDr >= .5 and not enemyHealer:Debuff(203337) then
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
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then return end
    if player:Buff(32727) then return end
    if party1.exists and party1:Buff(buffs.prayerOfMending) or party2.exists and party2:Buff(buffs.prayerOfMending) then return end

    return spell:Cast(player)
end)

PrayerOfMending:Callback("arenaGates", function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then return end
    if player:Buff(32727) then return end

    if party1.exists and party1:HasBuffCount(buffs.prayerOfMending) <= 8 then
        HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    end

    if party2.exists and party2:HasBuffCount(buffs.prayerOfMending) <= 8 then
        HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    elseif not player:Buff(buffs.prayerOfMending) then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

Renew:Callback("arenaGates", function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then return end
    if player:Buff(32727) then return end
    if Renew:Cooldown() > 0 then return end

    if party1.exists and not party1:Buff(buffs.renew) then
        HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    end

    if party2.exists and not party2:Buff(buffs.renew) then
        HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    elseif not player:Buff(buffs.renew) then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

-- Premonitions
PremonitionofInsightArena:Callback("arena", function(spell)
    if unit.hp > 95 then return end
    --if player.combatTime == 0 then return end

    return spell:Cast(player)
end)

PremonitionofPietyArena:Callback("arena", function(spell)
    if unit.hp > 70 then return end

    return spell:Cast(player)
end)

PremonitionofSolaceArena:Callback("arena", function(spell)
    if unit.hp > 70 then return end

    return spell:Cast(player)
end)

PremonitionofClairvoyanceArena:Callback("arena", function(spell)
    if unit.hp > 70 then return end

    return spell:Cast(player)
end)

-- GuardianSpirit
GuardianSpirit:Callback('arena', function(spell)
    if VoidShift:Used() > 0 and VoidShift:Used() < 3000 then return end
    if unit.hp > 30 then return end
    if unit:Buff(232707) then return end

    return spell:Cast(unit)
end)

-- RayofHope
RayofHope:Callback('arena', function(spell)
    if VoidShift:Used() > 0 and VoidShift:Used() < 3000 then return end
    if unit.hp > 40 then return end
    if unit:Buff(47788) then return end

    return spell:Cast(unit)
end)

-- PowerWordLife
PowerWordLife:Callback('arena', function(spell)
    if player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp > 35 then return end

    return spell:Cast(unit)
end)

PowerWordLifeToo:Callback('arena', function(spell)
    if not player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp > 50 then return end

    return spell:Cast(unit)
end)

-- Apotheosis
Apotheosis:Callback('arena', function(spell)
    if unit.hp > 70 then return end
    if unit:Buff(47788) then return end
    if unit.hp < 50 and HolyWordSerenity:Charges() == 0 and HolyWordSanctify:Charges() == 0 then
        return spell:Cast(player)
    end

    if unit.hp < 40 and HolyWordSerenity:Charges() == 0 then
        return spell:Cast(player)
    end

    if HolyWordSerenity:Charges() <= 1 and HolyWordSanctify:Charges() <= 1 and HolyWordChastise:Cooldown() > 1000 then
        return spell:Cast(player)
    end
end)

-- HolyWordSerenity
HolyWordSerenity:Callback('arena', function(spell)
    if unit.hp > 55 then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('arena', function(spell)
    if not player:Buff(114255) then return end
    if unit.hp > 75 then return end

    return spell:Cast(unit)
end)

-- PrayerOfMending
PrayerOfMending:Callback('arena', function(spell)
    if unit.hp > 95 then return end
    if unit:Buff(41635) and unit:BuffRemains(41635) > 2000 then return end

    return spell:Cast(unit)
end)

-- Renew
Renew:Callback('arena', function(spell)
    if unit.hp > 95 then return end
    if unit:Buff(139) and unit:BuffRemains(139) > 2000 then return end

    return spell:Cast(unit)
end)

-- HolyWordSanctify
HolyWordSanctify:Callback('arena', function(spell)
    if unit.hp > 70 then return end

    return spell:Cast(player)
end)

-- FlashHeal
FlashHeal:Callback('arena2', function(spell)
    --if not player:Buff(372313) then return end
    if unit.hp >= 75 then return end

    return spell:Cast(unit)
end)

-- FlashHeal
FlashHeal:Callback('arena3', function(spell)
    if not player:Buff(215769) then return end
    if unit.hp > 99 then return end

    return spell:Cast(unit)
end)


-- PowerWordShield
PowerWordShield:Callback('arena', function(spell)
    if unit.hp > 40 then return end

    return spell:Cast(unit)
end)

-- Shadowfiend
Shadowfiend:Callback('arena', function(spell)
    if player.manaPct >= 80 then return end
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end

    return spell:Cast(target)
end)

-- Holy Fire
HolyFire:Callback('arena', function(spell)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if getBelowHP(75) > 0 then return end

    return spell:Cast(target)
end)

-- Smite
Smite:Callback('arena', function(spell)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if getBelowHP(75) > 0 then return end

    return spell:Cast(target)
end)

Lightwell:Callback("auto", function(spell)
    if not spell:ReadyToUse() then return end

    -- cast if anyone in party is under 90% HP
    local someoneHurt = MakuluFramework.MultiUnits.party:Any(function(u)
        return u.exists and not u:IsDeadOrGhost() and u.hp < 98
    end)
    if not someoneHurt then return end

    return spell:Cast(player)
end)


local function HealerRotationPvp()
    local holdGCDforSWDE = holdGCDforSWD()
    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end
    Fade("arena")
    if holdGCDforSWDE then return end
    PremonitionofInsightArena('arenaGates')
    PrayerOfMending('arenaGates')
    Lightwell("auto")
    Renew('arenaGates')
    PsychicScream("arena")
    PremonitionofInsightArena('arena')
    PremonitionofPietyArena('arena')
    PremonitionofSolaceArena('arena')
    PremonitionofClairvoyanceArena('arena')
    PowerWordLife('arena', unit)
    PowerWordLifeToo('arena', unit)
    RayofHope('arena')
    GuardianSpirit('arena')
    Apotheosis('arena')
    HolyWordSerenity('arena')
    FlashHeal('arena')
    PrayerOfMending("14stack", unit)
    PrayerOfMending('arena')
    Renew("OnCD", unit)
    Renew('arena')
    HolyWordSanctify('arena')
    FlashHeal('arena2')
    PowerWordShield('arena')
    Shadowfiend('arena')
    HolyFire('arena')
    Smite('arena')
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

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Holy Word: Serenity CD ", HolyWordSerenity:TimeToFullCharges())

    end


	local CantCast = CantCast()
	if CantCast then return end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= (player and player.CombatTime and player:CombatTime()) or 0
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
        if Action.Zone ~= "arena" then
            HealerRotationPve()
        else
            HealerRotationPvp()
        end
    end

    AngelicFeather('Movement')

    --Damage Rotation PVE
    if target.exists and target.canAttack and Action.Zone ~= "arena" then
        DamageRotationPve()
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
ShadowWordDeath:Callback("arenap", function(spell, enemy)
    local castOrChannel = enemy.castOrChannelInfo
    if (IsPlayerSpell(PhaseShift.id) and Fade:Cooldown() == 0) then return end
    if player:Buff(408558) then return end
    if enemy.exists and enemy:CastingFromFor(MakLists.swdList, 420) then
        if castOrChannel.percent >= 50 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting SW:D to counter incoming CC", "Blue", 1) end
            return spell:Cast(player)
        end
    end
end)

ShadowWordDeath:Callback("arena2", function(spell, enemy)
    if not CanAttackTarget() then return end
    if enemy.hp > 20 then return end

    return spell:Cast(enemy)
end)

DispelMagic:Callback("arenap", function(spell, enemy)
    if getBelowHP(70) > 0 then return end
    --if enemy.hp > 50 then return end
    --if PowerWordShield:Cooldown() < 2000 then return end
    if enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then
        return spell:Cast(enemy)
    end
end)

HolyWordChastise:Callback("arenap", function(spell, enemy)
    if enemy.totalImmune then return end
    if enemy.magicImmune then return end
    if arena1.hp > 70 and arena2.hp > 70 and arena3.hp > 70 then return end
    if player:Buff(408558) then return end
    if player:Buff(410201) then return end
    if enemy.stunDr < 1 then return end

    if enemy:IsUnit(enemyHealer) and enemy.distance <= 25 then
        return spell:Cast(enemy)
    end

    if enemy:HasBuffFromFor(MakLists.DPSCooldownList, 500) then
        return spell:Cast(enemy)
    end

    return spell:Cast(enemy)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
    local holdGCDforSWDPE = holdGCDforSWDP()
    if player:Debuff(410201) then return end
    if player.channeling then return end
	if not enemy.exists then return end
    ShadowWordDeath("arenap", enemy)
    ShadowWordDeath("arena2", enemy)
    HolyWordChastise("arenap", enemy)
    if not holdGCDforSWDPE then
        DispelMagic("arenap", enemy)
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

VoidShift:Callback("arenap", function(spell, friendly)
    if friendly.isMe then return end
    if friendly:Buff(47788) then return end
    if friendly:Buff(232707) then return end
    if friendly.hp < 35 and player.hp > 60 and not friendly.totalImmune then
        return spell:Cast(friendly)
    end

    if player.hp < 35 and friendly.hp > 60 then
        return spell:Cast(friendly)
    end

end)

Purify:Callback("arenap", function(spell, friendly)
    if getBelowHP(50) > 0 then return end
    if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
    if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
        return spell:Cast(friendly)
    end
end)

PowerInfusionP:Callback("arenap", function(spell, friendly)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if not target.canAttack then return end
    if target.distance > 40 then return end
    if friendly:HasBuffFromFor(MakLists.DPSCooldownList, 777) then
        return spell:Cast(friendly)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    local holdGCDforSWDP = holdGCDforSWD()
    if player.channeling then return end
    if not friendly.exists then return end
    if holdGCDforSWDP then return end
    PowerInfusionP("arenap", friendly)
    VoidShift("arenap", friendly)
    Purify("arenap", friendly)
end

--################################################################################################################################################################################################################

A[6] = function(icon)
    -- All Lightweaver StopCast logic removed

    if Action.Zone == "arena" then
        if Unit("player"):IsCastingRemains(A.Smite.ID) > 0 or Unit("player"):IsCastingRemains(A.HolyFire.ID) > 0 and getBelowHP(75) > 0 then
            return A.StopCast:Show(icon)
        end
    end

    --Multi Dot
    if GetToggle(2, "SpreadDot") and not Unit("target"):IsBoss() and Unit("target"):HasDeBuffs(A.ShadowWordPain.ID, true) > 0 and (Player:GetDeBuffsUnitCount(A.ShadowWordPain.ID, true) < MultiUnits:GetActiveEnemies()) then
        return A.TargetEnemy:Show(icon)
    end

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
