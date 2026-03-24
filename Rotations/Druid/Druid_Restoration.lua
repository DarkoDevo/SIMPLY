if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 105 then return end

local IS_DEV_DEBUGGING = false
local function MakDebugPrint(...)
    if IS_DEV_DEBUGGING then
        print(...)
    end
end

local function str(message)
    return tostring(message)
end

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
local Debounce         = MakuluFramework.debounceSpell
local ConstSpells      = MakuluFramework.constantSpells
local Aware            = MakuluFramework.Aware
local NeedRaidBuff     = MakuluFramework.NeedRaidBuff
local TrinketOverride  = MakuluFramework.TrinketOverride

local Action           = _G.Action
local Unit       	   = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local UnitIsUnit	   = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local GetSpellTexture = C_Spell.GetSpellTexture
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable

local ActionID = {
    WillToSurvive 				            = { ID = 59752 	},
    Stoneform 					            = { ID = 20594 	},
    Shadowmeld 					            = { ID = 58984 	},
    EscapeArtist 				            = { ID = 20589 	},
    GiftOfTheNaaru  			            = { ID = 59544 	},
    Darkflight 					            = { ID = 68992, Macro = "/cast [@player]Life Bloom" 	},
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
	AntiFakeKick                            = { Type = "SpellSingleColor", ID = 106839,  Hidden = true,		Color = "GREEN"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC					            = { Type = "SpellSingleColor", ID = 5211,  	Hidden = true,		Color = "YELLOW"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	},
    -- Restoration
    --Rake2                   = { ID = 1822,    Hidden = true, Texture = 291944, MAKULU_INFO = { damageType = "physical" 	   }}, -- Regenratin Icon for Fluid Form
    Abundance                 = { ID = 207383,    isTalent = true, Hidden = true                                              },
    AdaptiveSwarm             = { ID = 391888,  FixedTexture = 3578197, MAKULU_INFO = { damageType = "magical" 	                                   }},
    AquaticForm               = { ID = 276012                                                                                 },
    AncientofLore             = { ID = 473909                                                                                 },
    BalanceAffinity           = { ID = 197632,    isTalent = true, Hidden = true                                              },
    Barkskin                  = { ID = 22812                                                                                  },
    BearForm                  = { ID = 5487                                                                                   },
    BloomingInfusionDps       = { ID = 429474, Hidden = true                                                                  },
    BloomingInfusionHps       = { ID = 429438, Hidden = true                                                                  },
    CatForm                   = { ID = 768                                                                                    },
    CenarionWard              = { ID = 102351, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    CenarionWardHealing       = { ID = 102352                                                                                 },
    ClearCasting              = { ID = 16870                                                                                  },
    ConvoketheSpirits         = { ID = 391528,  FixedTexture = 3636839, MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@target,help][@focus,help][@target,harm]spell:thisID"},
    Cultivation               = { ID = 200390,    isTalent = true, Hidden = true                                              },
    Cyclone                   = { ID = 33786, MAKULU_INFO = { damageType = "magical" } },
    Dash                      = { ID = 1850                                                                                   },
    DazedDebuff               = { ID = 50259,   Hidden = true                                                                 },
    DeepRoots                 = { ID = 233755, isTalent = true, Hidden = true                                                 },
    Disentanglement           = { ID = 233673, isTalent = true, Hidden = true                                                 },
    EarlySpring               = { ID = 203624, isTalent = true, Hidden = true                                                 },
    Efflorescence             = { ID = 145205, Macro = "/cast [@cursor]spell:thisID" },
    EntanglingBark            = { ID = 247543, isTalent = true, Hidden = true                                                 },
    EntanglingRoots           = { ID = 339, MAKULU_INFO = { damageType = "magical" } },
    FeralAffinity             = { ID = 197490,    isTalent = true, Hidden = true                                              },
    FerociousBite             = { ID = 22568,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    Flourish                  = { ID = 197721,    isTalent = true                                                             },
    Fluidform                 = { ID = 449193,  Hidden = true                                                                 },
    FocusedGrowth             = { ID = 203553, isTalent = true, Hidden = true                                                 },
    FrenziedRegeneration      = { ID = 22842                                                                                  },
    FullBloomLifebloom        = { ID = 290754, Hidden = true                                                                  },
    Germination               = { ID = 155675,    isTalent = true, Hidden = true                                              },
    GroveGuardians            = { ID = 102693                                                                                 },
    GuardianAffinity          = { ID = 197491,    isTalent = true, Hidden = true                                              },
    HeartoftheWild            = { ID = 319454,    isTalent = true                                                             },
    Hibernate                 = { ID = 2637,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    ImprovedDispelTalent      = { ID = 392378, Hidden = true                                                                  },
    IncapacitatingRoar        = { ID = 99                                                                                     },
    IncarnationTreeofLife     = { ID = 33891,     isTalent = true                                                             },
    IncarnationTreeofLifeBuff = { ID = 117679,    Hidden   = true                                                             },
    InnerPeace                = { ID = 197073,    isTalent = true, Hidden = true                                              },
    Innervate                 = { ID = 29166, Macro = "/cast [@player]spell:thisID" },
    Invigorate                = { ID = 392160                                                                                 },
    Ironbark                  = { ID = 102342, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Ironfur                   = { ID = 192081                                                                                 },
    Lifebloom                 = { ID = 33763 },
    LifebloomP                = { ID = 188550, Texture = 68992, Macro = "/cast [@player][]Lifebloom" },
    Maim                      = { ID = 22570,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    Mangle                    = { ID = 33917,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    MarkoftheWild             = { ID = 1126 , Macro = "/cast [@player]spell:thisID" },
    MassEntanglement          = { ID = 102359,    isTalent = true,  MAKULU_INFO = { damageType = "magical" } },
    MasterShapeshifter        = { ID = 289237, isTalent = true                                                                },
    MightyBash                = { ID = 5211,      isTalent = true,  MAKULU_INFO = { damageType = "physical" 	               }},
    Moonfire                  = { ID = 8921,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    MoonfireDebuff            = { ID = 164812,  Hidden = true 	                                                            },
    MoonkinForm               = { ID = 24858                                                                                  },
    NaturesCure               = { ID = 88423, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    NaturesSwiftness          = { ID = 132158                                                                                 },
    NaturesVigil              = { ID = 124974                                                                                 },
    Nourish                   = { ID = 50464                                                                                  },
    Overgrowth                = { ID = 203651                                                                                 },
    Photosynthesis            = { ID = 274902,    isTalent = true, Hidden = true                                              },
    Prowl                     = { ID = 5215                                                                                   },
    Rake                      = { ID = 1822,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    RakeDebuff                = { ID = 155722,  Hidden = true                                                                 },
    RakeStun                  = { ID = 163505,  Hidden = true                                                                 },
    Rebirth                   = { ID = 20484, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Regrowth                  = { ID = 8936, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Rejuvenation              = { ID = 774, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    RejuvenationGermimation   = { ID = 155777                                                                                 },
    Renewal                   = { ID = 108238,    isTalent = true                                                             },
    RenewingBloom             = { ID = 364365                                                                                 },
    Revitalize                = { ID = 212040                                                                                 },
    Revive                    = { ID = 50769, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Rip                       = { ID = 1079,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    Shred                     = { ID = 5221,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    SkullBash                 = { ID = 106839,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    Soothe                    = { ID = 2908, MAKULU_INFO = { damageType = "magical"                                            }},
    SouloftheForest           = { ID = 158478,    isTalent = true, Hidden = true                                              },
    SpringBlossoms            = { ID = 207385,    isTalent = true, Hidden = true                                              },
    StampedingRoar            = { ID = 106898                                                                                 },
    Starfire                  = { ID = 197628,  MAKULU_INFO = { damageType = "magical" 	                                   }},
    Starsurge                 = { ID = 197626,  MAKULU_INFO = { damageType = "magical" 	                                   }},
    Sunfire                   = { ID = 93402,   MAKULU_INFO = { damageType = "magical" 	                                   }},
    SunfireDebuff             = { ID = 164815,  Hidden = true	                                                                },
    Swiftmend                 = { ID = 18562, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    SwipeBear                 = { ID = 213771,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    SwipeCat                  = { ID = 106785,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    Thorns                    = { ID = 305497, isTalent = true                                                                },
    ThrashBear                = { ID = 77758,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    ThrashCat                 = { ID = 106830,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    Tranquility               = { ID = 740                                                                                    },
    TravelForm                = { ID = 783                                                                                    },
    Typhoon                   = { ID = 132469,    isTalent = true                                                             },
    Undergrowth               = { ID = 392301                                                                                 },
    UndergrowthLifebloom      = { ID = 188550, Hidden = true                                                                  },
    UrsolVortex               = { ID = 102793                                                                                 },
    VerdantInfusion           = { ID = 338829                                                                                 },
    WildCharge                = { ID = 102401,    Texture = 58984                                                             },
    WildGrowth                = { ID = 48438, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    WildSynthesis             = { ID = 400534,    isTalent = true, Hidden = true                                              },
    Wrath                     = { ID = 5176,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    
    --11.1
    SymbioticRelationship                   = { ID = 474750, FixedTexture = 133667, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    BlossomBurst                            = { ID = 473919, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    MassBlooming                            = { ID = 474149, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })


Action[ACTION_CONST_DRUID_RESTORATION] = A
TableToLocal(M, getfenv(1))

MakuluFramework.rampModeTimer = 10

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
local enemies       = MakMulti.enemies

local unit

local PlayerHaveBloomingInfusion
local PlayerHaveNaturesSwiftness
local PlayerHaveInnervate
local IncarnationTreeofLifeBuff
local PlayerHaveClearcast
local PlayerHaveSouloftheForest

Aware:enable()

local buffs = {
	barkskin            = 22812,
	ironbark            = 102342,
    natureswiftness     = 132158,
    incarnation         = 117679,
    innervate           = 29166,
    clearcast           = 16870,
    soulforest          = 114108,
    rejuvenation        = 774,
    germination         = 155777,
    lifebloom           = 33763,
    lifebloomUndergrowth = 188550,
    fullbloom           = 290754,
    wildgrowth          = 48438,
    regrowth            = 8936,
    cenarionward        = 102352,
    infusionheal        = 429438,
    infusiondmg         = 429474,
    harmonyofgrove      = 428737,
    tranquility         = 157982,
    stampedingroar      = 77764,
    tigerdash           = 252216,
    dash                = 1850,
    ancientoflore       = 473909,
    bearform            = 5487,
    catform             = 768,
    frenziedregeneration = 22842,
    dreamsurge          = 433831,
}

local debuffs = {
    sunfire    = 164815,
    moonfire   = 164812,
    rake       = 155722,
    rip        = 1079,
    thrashcat  = 405233,
    thrashbear = 192090,
}

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = nil,
    imCastingLength = nil,

    abundanceStacks = 0
}

local ConsumableHoTs = {
    [A.Rejuvenation.ID] = true,
    [A.RejuvenationGermimation.ID] = true,
    [A.WildGrowth.ID] = true,
    [A.Regrowth.ID] = true,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local interrupts = {
    { spell = SkullBash },
    { spell = MightyBash, isCC = true },
    { spell = IncapacitatingRoar, isCC = true, aoe = true, distance = 3 },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local wantRootStop = {
    -- Liberation of Undermine
    [231788] = true,
    [235187] = true,
}

local function wantToStopUnit()
    if not MassEntanglement:ReadyToUse() and not EntanglingRoots:ReadyToUse() then return false end

    local inRangeMass = enemies:Count(function(unit)
        return unit.exists and not unit.isFriendly and not unit.rooted and unit:IsMoving()
    end)

    if A.GetToggle(2, "MouseOverRootRaid") and mouseover.exists and not mouseover.isFriendly then
        if wantRootStop[mouseover.id] and not mouseover.rooted then
            if inRangeMass > 1 and MassEntanglement:ReadyToUse() then
                return "MassMouse"
            elseif EntanglingRoots:ReadyToUse() then
                return "SingleMouse"
            end
        end
    elseif (not mouseover.exists or A.GetToggle(2, "MouseOverRootRaid")) and target.exists and not target.isFriendly then
        if wantRootStop[target.id] and not target.rooted then
            if inRangeMass > 1 and MassEntanglement:ReadyToUse() then
                return "MassTarget"
            elseif EntanglingRoots:ReadyToUse() then
                return "SingleTarget"
            end
        end
    end
    return "None"
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function hasIncomingDamage()
    return incBigDmgIn() <= 2000 or incModDmgIn() <= 2000
end

local function defensiveActive()
    player = MakUnit:new("player")
    return player:Buff(buffs.barkskin) or player:Buff(buffs.ironbark)
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive()
end

local function shouldPrepareTeam()
    if not GetToggle(2, "PrepareTeamBox") then return end
    local incomingDamage = hasIncomingDamage()

    return incomingDamage
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)
    local unitID = thisUnit.Unit

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
    
    if IsInRaid() and MakUnit:new("boss1").exists then
        local BossTargets = {}
        for i = 1, 5 do
            local tmpboss = MakUnit:new("boss"..i)
            if tmpboss.exists and tmpboss.target and tmpboss.target.exists then
                BossTargets[tmpboss.target.guid] = true
            end
        end
        tank = MakMulti.party:Find(function(party)
            return party.exists and party.isTank and not party.dead and BossTargets[party.guid]
        end)
    else
        tank = ConstUnit.tank
    end
end

--######################################################################################################################################################################################################

local function getFriendlyUnitID()
    if target.isFriendly then return target end
    if focus.isFriendly then return focus end
    return nil
end

local function canUseSwiftmendCombo()
    if not GetToggle(2, "Checkbox3") or not A.VerdantInfusion:IsTalentLearned() then return false end
    
    local unitID = getFriendlyUnitID()
    if not unitID or unitID:HasBuffs(A.CenarionWardHealing.ID, true) == 0 then return false end
    
    return AutoHealOrSlider(unitID:CallerId(), A.Swiftmend, GetToggle(2, "Swiftmend"))
end

local function canUseSwiftmendAggressive()
    if GetToggle(2, "Checkbox3") or GetToggle(2, "SwiftmendDropdown") ~= "2" then return false end
    
    local unitID = getFriendlyUnitID()
    if not unitID then return false end
    
    return AutoHealOrSlider(unitID:CallerId(), A.Swiftmend, GetToggle(2, "Swiftmend"))
end

local function canUseSwiftmendExpiring()
    if GetToggle(2, "Checkbox3") or GetToggle(2, "SwiftmendDropdown") ~= "1" then return false end
    
    local unitID = getFriendlyUnitID()
    if not unitID then return false end
    
    local hasValidBuff =
        unitID:Buff(A.Regrowth.ID, true) or
        (unitID:BuffRemains(A.WildGrowth.ID, true) > 0 and unitID:BuffRemains(A.WildGrowth.ID, true) <= 3000) or
        (unitID:BuffRemains(A.Rejuvenation.ID, true) > 0 and unitID:BuffRemains(A.Rejuvenation.ID, true) <= 3000) or
        (unitID:BuffRemains(A.RejuvenationGermimation.ID, true) > 0 and unitID:BuffRemains(A.RejuvenationGermimation.ID, true) <= 3000)
    
    if not hasValidBuff then return false end
    
    return AutoHealOrSlider(unitID:CallerId(), A.Swiftmend, GetToggle(2, "Swiftmend"))
end

local function canUseSwiftmend()
    local unitID = getFriendlyUnitID()
    if not unitID or not unitID:BuffFrom(ConsumableHoTs, true) then return false end
    
    if A.Swiftmend:GetCooldown() ~= 0 or not A.Swiftmend:IsSpellInRange(unitID:CallerId()) then return false end
    
    if Unit("player"):IsCastingRemains() > 0.25 or Player:IsChanneling() or A.GetCurrentGCD() > 0.25 then return false end
    
    return canUseSwiftmendAggressive() or canUseSwiftmendExpiring() or canUseSwiftmendCombo()
end

--######################################################################################################################################################################################################

-- Function to check if target is Boss
local function CanUseBossAbility()
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime <= 0 then return end
    if not Unit("target"):IsBoss() then return end
    return true
end

-------------------------------------------------------------
-------- Dot Functions

-- Function to check if a DoT refresh is allowed
local function CanRefreshDot(dotType)
    local manaThreshold = GetToggle(2, "ManaTresholdDpsSlider")
    if player.manaPct <= manaThreshold then
        return false
    end

    local option = GetToggle(2, "DotRefreshDropdown")

    -- Handle option "7": Do not refresh DoTs if the player is in stance 2
    if option == "7" then
        -- If the player is in stance 2, return false; otherwise, allow DoT refresh
        return not Player:IsStance(1) and not Player:IsStance(2) and not Player:IsStance(3)
    end

    -- Define allowed options without range checks
    local allowedOptions = {}
    if dotType == "Sunfire" then
        allowedOptions = { "1", "2", "8" }
    elseif dotType == "Moonfire" then
        allowedOptions = { "1", "3", "8" }
    end

    -- Check if the current option is in the allowed options list
    for _, opt in ipairs(allowedOptions) do
        if option == opt then
            return true
        end
    end

    -- For options that require no enemies within 10 yards
    if (option == "4" 
        or (dotType == "Sunfire" and option == "5") 
        or (dotType == "Moonfire" and option == "6")) 
        and not Enemies10y then
        return true
    end

    return false
end

-------------------------------------------------------------

-- Function to check if there are valid targets
local function HasValidTargets()
    return MultiUnits:GetBySpell(A.Shred) >= 1
end

-- Function to check if AoE abilities can be used
local function CanUseAoEAbility()
    return MultiUnits:GetByRange(8) >= 2
end

-- Function to check Catweaving conditions
local function ShouldCatweave()
    -- If the player is in a form (stances 1 to 3), do not jump inot Cat Form
    local stance = Player:GetStance()
    if stance >= 1 and stance <= 3 then
        return false
    end

    local catweavingOption = GetToggle(2, "DotRefreshDropdown")
    
    -- Early exit if Catweaving is disabled
    if catweavingOption == "8" then
        return false
    end

    -- For options 4, 5, 6, 7 check for melee range
    if catweavingOption == "1" or catweavingOption == "4" or catweavingOption == "5" or catweavingOption == "6" or catweavingOption == "7" then
        if Enemies10y then
            return true
        else
            return false
        end
    end

    -- For other options, allow Catweaving
    return true
end

-- Common function for checking debuff remains
local function ShouldApplyDebuff(debuff, threshold)
    return target:DebuffRemains(debuff, true) <= threshold
end

-------------------------------------------------------------

-- Function to check if the target can be attacked
-- Need it because i call instant casts in healing rota
local function CanAttackTarget()
    return target.exists and not target.isFriendly and target.canAttack
end

-- Function to check if Balance abilities can be used
local function CanUseBalanceAbility()
    -- If we cannot attack the target, return false
    if not CanAttackTarget() then return false end

    -- If "DotRefreshDropdown" toggle is not "8" and we are in melee range, do not use Balance abilities
    local dotRefreshOption = GetToggle(2, "DotRefreshDropdown")
    if dotRefreshOption ~= "8" and player:TalentKnown(Rake.id) and inMeleeRange then
        return false
    end

    -- If player's mana percentage is below or equal to the threshold, do not use Balance abilities
    local manaThreshold = GetToggle(2, "ManaTresholdDpsSlider")
    if player.manaPct <= manaThreshold then
        return false
    end

    -- If the player is in a form (stances 1 to 3), do not use Balance abilities
    local stance = Player:GetStance()
    if stance >= 1 and stance <= 3 then
        return false
    end

    -- All conditions met, can use Balance abilities
    return true
end
--------------------------------
local function autoTarget()
    if not player.inCombat then return false end
    if A.IsInPvP then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if GetToggle(2, "MultiDot") and not Unit("target"):IsBoss() and Unit("target"):HasDeBuffs(A.MoonfireDebuff.ID, true) > 0 and (Player:GetDeBuffsUnitCount(A.MoonfireDebuff.ID, true) < MultiUnits:GetActiveEnemies()) then
        return true
    end
end
--------------------------------
--######################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rebirth
Rebirth:Callback('Utilities1', function(spell)
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if not mouseover.player then return end
    
    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Barkskin
Barkskin:Callback('Defensive1', function(spell)
    -- Prefer predictive defensive usage; fall back to HP threshold
    if shouldDefensive() then
        return spell:Cast()
    end

    local threshold = GetToggle(2, "SelfProtection1")
    if threshold ~= nil and playerHealth <= threshold then
        return spell:Cast()
    end
end)

-- Renewal
Renewal:Callback('Defensive2', function(spell)
    if playerHealth > GetToggle(2, "SelfProtection2") then return end
    return spell:Cast()
end)

-- BearForm
BearForm:Callback('Defensive3', function(spell)
    if Player:IsStance(1) then return end
    if playerHealth > GetToggle(2, "SelfProtection3") then return end
    return spell:Cast()
end)

-- Leave BearForm
BearForm:Callback('LeaveForm', function(spell)
    if not GetToggle(2, "LeaveCatBearForm") then return end
    if not Player:IsStance(1) then return end
    if Unit("target"):GetRange() < 10 then return end
    if player:Buff(buffs.stampedingroar) then return end
    if player:Buff(buffs.tigerdash) then return end
    if player:Buff(buffs.dash) then return end

    return spell:Cast()
end)

-- Leave CatForm
CatForm:Callback('LeaveForm', function(spell)
    if not GetToggle(2, "LeaveCatBearForm") then return end
    if not Player:IsStance(2) then return end
    if Unit("target"):GetRange() < 10 then return end
    if player:Buff(buffs.stampedingroar) then return end
    if player:Buff(buffs.tigerdash) then return end
    if player:Buff(buffs.dash) then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- MarkoftheWild
MarkoftheWild:Callback('PreCombat1', function(spell)
    if not NeedRaidBuff(MarkoftheWild) then return end
    return Debounce("raidbuff", 1000, 2500, spell, player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--NaturesCure
NaturesCure:Callback("Dispel", function(spell)
    if A.Zone == "arena" then return end
    if unit.ehp < 35 then return end
    if unit:DebuffFrom(AvoidDispelTable) then return end

    local magicked  = MakMulti.party:Find(function(unit) return (unit.magicked or AuraIsValid(unit:CallerId(), "UseDispel", "Magic")) and NaturesCure:InRange(unit) end)
    local cursed    = MakMulti.party:Find(function(unit) return (unit.cursed or AuraIsValid(unit:CallerId(), "UseDispel", "Curse")) and NaturesCure:InRange(unit) end)
    local poisoned  = MakMulti.party:Find(function(unit) return (unit.poisoned or AuraIsValid(unit:CallerId(), "UseDispel", "Poison")) and NaturesCure:InRange(unit) end)

    if magicked then
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if cursed and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(cursed:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if poisoned and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(poisoned:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
end)

Soothe:Callback("Dispel", function(spell)
    if A.Zone == "arena" then return end
    if canSoothe() then
        return spell:Cast(unit)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### EMERGENCY SINGLE TARGET COOLDOWN ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ironbark
Ironbark:Callback('Emergency', function(spell)
    if not A.Ironbark:IsTalentLearned() then return end
    if not unit:IsPlayer() then return end

    local tankBuster = MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0
    if tankBuster then
        if tank.exists and tank.ehp > 0 then


            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(unit)
        end
    end

    if unit.ehp > 45 then return end



    return spell:Cast(unit)
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
    return spell:Cast()
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
    return player:HasBuffCount(buffs.tranquility, true) ~= 0 or player:Buff(buffs.incarnation)
end

-- Tranquility
Tranquility:Callback('Cooldowns', function(spell)
    if not A.Tranquility:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if MajorCooldownIsActive() then return end



    return spell:Cast()
end)

-- Incarnation Tree of Life
IncarnationTreeofLife:Callback('Cooldowns', function(spell)
    if not A.IncarnationTreeofLife:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if MajorCooldownIsActive() then return end



    return spell:Cast()
end)

NaturesSwiftness:Callback('CooldownConvoke', function(spell)
    if not player.inCombat then return end
    if not NaturesSwiftness:ReadyToUse() then return end
    return spell:Cast(player)
end)

--ConvoketheSpirits
ConvoketheSpirits:Callback('Cooldowns', function(spell)
    if not A.ConvoketheSpirits:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if GetToggle(2, "Checkbox4") and unit.ehp > 35 then return end
    if MajorCooldownIsActive() then return end



    if NaturesSwiftness:ReadyToUse() and not player:Buff(buffs.natureswiftness) then
        return NaturesSwiftness('CooldownConvoke')
    end

    return spell:Cast(unit)
end)

--Flourish
Flourish:Callback('Cooldowns', function(spell)
    if not A.Flourish:IsTalentLearned() then return end
    local currentActiveRejuvenations = HealingEngine.GetBuffsCount(A.Rejuvenation.ID, 0, true)
    local currentActiveGerminations = HealingEngine.GetBuffsCount(A.RejuvenationGermimation.ID, 0, true)
    local currentActivewildgrowths = HealingEngine.GetBuffsCount(A.WildGrowth.ID, 0, true)
    local seccondCondition = currentActivewildgrowths >= 3 and (currentActiveRejuvenations >= 3 or currentActiveGerminations >= 3)

    if player:HasBuffCount(buffs.tranquility, true) >= 4 or CanUseAoeHealing() and seccondCondition then
        return spell:Cast()
    end
end)

--Innervate
Innervate:Callback('Cooldowns', function(spell)
    if not A.Innervate:IsTalentLearned() then return end
    if PlayerHaveInnervate then return end
    if player.manaPct > 75 then return end

    if not (CanUseAoeHealing() or CanUseHealingCooldowns()) then return end

    return spell:Cast()
end)

Innervate:Callback('FriendlyHealer', function(spell)
    if not GetToggle(2, "InnervateFriend") then return end
    if not A.Innervate:IsTalentLearned() then return end
    local lowest_mana = MakMulti.party:Lowest(function(unit)
        if unit.dead or not unit.isHealer or not Innervate:InRange(unit) then
            return 9999999999
        end
        return unit.manaPct 
    end)

    if lowest_mana and lowest_mana.manaPct < 50 and lowest_mana.manaPct < player.manaPct and (CanUseAoeHealing() or CanUseHealingCooldowns()) then
        HealingEngine.SetTarget(lowest_mana:CallerId(), 1)
        return spell:Cast(lowest_mana)
    end
end)

-- Helper function to check if party needs Ancient of Lore healing (more aggressive thresholds)
local function partyNeedsAncientHealing()
    -- More aggressive thresholds than CanUseHealingCooldowns()
    -- Arena: 1 person below 60%, OR 2 people below 70%, OR any person below 50%
    local below70 = HealingEngine.GetBelowHealthPercentUnits(70, nil) or 0
    local below60 = HealingEngine.GetBelowHealthPercentUnits(60, nil) or 0
    local below50 = HealingEngine.GetBelowHealthPercentUnits(45, nil) or 0

    -- Any party member below 50% is critical
    if below50 >= 1 then return true end

    -- 1 person below 60% needs attention
    if below60 >= 1 then return true end

    -- 2+ people below 70% means group is in trouble
    if below70 >= 2 then return true end

    -- Also check lowest party member HP directly
    local lowestHP = MakMulti.party:Lowest(function(unit)
        if not unit.exists or unit.dead then return 999 end
        return unit.hp
    end)
    if lowestHP and lowestHP.hp < 65 then return true end

    return false
end

-- NaturesSwiftness AncientPrep Callback
-- Casts Nature's Swiftness to enable instant Ancient of Lore when emergency conditions are met
NaturesSwiftness:Callback('AncientPrep', function(spell)
    if not player.inCombat then return end
    if not A.IsInPvP then return end
    if player:Buff(buffs.natureswiftness) then return end
    if not NaturesSwiftness:ReadyToUse() then return end
    if AncientofLore:Cooldown() > 0 then return end

    -- Check if about to be CC'ed (enemy casting CC on player)
    local aboutToBeCC = false
    if Action.Zone == "arena" then
        if arena1.exists and arena1:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena1.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
        if arena2.exists and arena2:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena2.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
        if arena3.exists and arena3:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena3.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
    end

    -- Check if group needs healing (more aggressive than CanUseHealingCooldowns)
    local groupNeedsHealing = partyNeedsAncientHealing()

    -- Cast if about to be CC'ed OR group needs healing
    if aboutToBeCC or groupNeedsHealing then
        return spell:Cast(player)
    end
end)

-- AncientofLore PvP Callback
-- Casts Ancient of Lore when player has Nature's Swiftness and is in PvP
-- Triggers when about to be CC'ed or group is taking significant damage
AncientofLore:Callback('pvp', function(spell)
    if not player.inCombat then return end
    if not A.IsInPvP then return end
    if not player:Buff(buffs.natureswiftness) then return end
    if not AncientofLore:ReadyToUse() then return end

    -- Check if about to be CC'ed (enemy casting CC on player)
    local aboutToBeCC = false
    if Action.Zone == "arena" then
        if arena1.exists and arena1:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena1.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
        if arena2.exists and arena2:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena2.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
        if arena3.exists and arena3:CastingFromFor(MakLists.arenaFadeList, 420) then
            local castInfo = arena3.castOrChannelInfo
            if castInfo and castInfo.percent >= 60 then
                aboutToBeCC = true
            end
        end
    end

    -- Check if group needs healing (more aggressive than CanUseHealingCooldowns)
    local groupNeedsHealing = partyNeedsAncientHealing()

    -- Cast if about to be CC'ed OR group needs healing
    if aboutToBeCC or groupNeedsHealing then
        return spell:Cast()
    end
end)

MassBlooming:Callback('AncientWindow', function(spell)  
    if not player:Buff(buffs.ancientoflore) then return end
    if not MassBlooming:ReadyToUse() then return end

    return spell:Cast()
end)

BlossomBurst:Callback('AncientWindow', function(spell)  
    if not player:Buff(buffs.ancientoflore) then return end
    if MassBlooming:ReadyToUse() then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### SOUL OF THE FOREST + NATURES SWIFTNESS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--WildGrowth Soul of the Forest
WildGrowth:Callback('SotF', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end

    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:Buff(buffs.soulforest) then return end
    if unit:BuffRemains(buffs.wildgrowth, true) > 3000 then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "WildGrowth" then return end

    if not AutoHeal(unit, A.WildGrowth) then return end

    return spell:Cast()
end)

--WildGrowth Soul of the Forest (Infa force test)
WildGrowth:Callback('Force', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end

    local toggleOption = A.GetToggle(2, "testWG")
    if not toggleOption then return end

    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:Buff(buffs.soulforest) then return end
    --if not IsInRaid() then return end

    return spell:Cast()
end)

--Rejuvenation Soul of the Forest
Rejuvenation:Callback('SotF', function(spell)
    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:Buff(buffs.soulforest) then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "Rejuvenation" then return end

    if unit:BuffRemains(buffs.rejuvenation, true) > 3000 then return end
    if not AutoHeal(unit:CallerId(), A.Rejuvenation) then return end

    return spell:Cast(unit)
end)

--Germination Soul of the Forest
Rejuvenation:Callback('SotFGermination', function(spell)
    if not A.Germination:IsTalentLearned() then return end
    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:Buff(buffs.soulforest) then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "Rejuvenation" then return end

    if unit:BuffRemains(buffs.germination, true) > 3000 then return end
    if not AutoHeal(unit:CallerId(), A.Rejuvenation) then return end

    return spell:Cast(unit)
end)

--Regrowth Soul of the Forest
Regrowth:Callback('SotF', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end

    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:Buff(buffs.soulforest, true) then return end

    local canCast = isStaying or PlayerHaveNaturesSwiftness or IncarnationTreeofLifeBuff or PlayerHaveBloomingInfusion
    if not canCast then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "Regrowth" then return end

    if unit.ehp > 35 then return end

    return spell:Cast(unit)
end)

--NaturesSwiftness
NaturesSwiftness:Callback('HealingPve', function(spell)
    if not player.inCombat then return end
    if unit.ehp > 45 then return end

    return spell:Cast()
end)

--Own function to decide whetever we want to use Wild Growth first when multiple units are injured
local function SotFHandler()
    if CanUseAoeHealing() then
        WildGrowth('Force')
        WildGrowth('SotF')
        Rejuvenation('SotF')
        Rejuvenation('SotFGermination')
        Regrowth('SotF')
    else
        WildGrowth('Force')
        Rejuvenation('SotF')
        Rejuvenation('SotFGermination')
        WildGrowth('SotF')
        Regrowth('SotF')
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD HEALING PVE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SymbioticRelationship:Callback('HealingPve', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then
        return
    end
    
    local option = A.GetToggle(2, "symbioticRelationship")
    if option == "3" then return end

    local buffActive = MakMulti.party:Any(function(friendly) return friendly:Buff(A.SymbioticRelationship.ID) end)
    if buffActive then return end

    if option == "1" then
        local oor = MakMulti.party:Any(function(friendly) return not Regrowth:InRange(friendly) end)
        if oor then return end

        local lowestHP = MakMulti.party:Lowest(
            function(friendly) return friendly.maxHealth end,
            function(friendly) return not friendly.isMe end
        )

        if lowestHP then
            HealingEngine.SetTarget(lowestHP:CallerId(), 1)
            return spell:Cast(lowestHP)
        end
    end

    if option == "2" then
        local foundTank = MakMulti.party:Find(function(friendly) return friendly.isTank end)
        if foundTank then
            HealingEngine.SetTarget(foundTank:CallerId(), 1)
            return spell:Cast(foundTank)
        end
    end
end)

GroveGuardians:Callback('HealingPve', function(spell)
    -- Early exits für allgemeine Bedingungen
    if gameState.imCasting and gameState.imCasting == spell.spellId then
        return
    end
    
    if A.GroveGuardians:GetSpellTimeSinceLastCast() < 12 then
        return
    end
    
    if player:BuffRemains(buffs.harmonyofgrove) > 6000 then
        return
    end
    
    -- KeepGrove Toggle-Überprüfung
    if GetToggle(2, "KeepGrove") then
        return spell:Cast(unit)
    end
    
    -- Health und Charges Überprüfungen
    local charges = A.GroveGuardians:GetSpellCharges()
    if charges == 0 then
        return
    end
    
    if charges == 3 and unit.ehp > 85 then
        return
    end
    
    if charges == 2 and unit.ehp > 65 then
        return
    end
    
    if charges == 1 and unit.ehp > 45 then
        return
    end
    
    -- Wenn alle Bedingungen erfüllt sind, den Zauber wirken
    return spell:Cast(unit)
end)

--Efflorescence
Efflorescence:Callback('HealingPve', function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end
    if isMoving then return end
    if A.Efflorescence:GetSpellTimeSinceLastCast() < 30 then return end

    return spell:Cast()
end)

-- Wild Growth Callback
WildGrowth:Callback('HealingPve', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end

    if IsInRaid() and A.GetToggle(2, "testWG") and Swiftmend:Cooldown() > 0 and Swiftmend:Cooldown() <= 10000 then return end

    if unit:BuffRemains(buffs.wildgrowth, true) > 3000 then return end

    local canCastWildGrowth = CanUseAoeHealing() or CanUseHealingCooldowns() or PlayerHaveInnervate or IncarnationTreeofLifeBuff or shouldPrepareTeam()
    if not canCastWildGrowth then return end

    if not AutoHeal(unit, A.WildGrowth) then return end

    return spell:Cast()
end)

-- Regrowth Callback
Regrowth:Callback('Freecast', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end

    local isFreecasting = PlayerHaveClearcast or PlayerHaveBloomingInfusion or PlayerHaveNaturesSwiftness
    if not isFreecasting then return end

    local hasBlockingBuff = PlayerHaveSouloftheForest or PlayerHaveInnervate --or IncarnationTreeofLifeBuff
    if hasBlockingBuff then return end

    local freecastThreshold = GetToggle(2, "FreecastSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Regrowth, freecastThreshold) then return end

    return spell:Cast(unit)
end)

-- Overgrowth
Overgrowth:Callback('HealingPve', function(spell)
    if not A.Overgrowth:IsTalentLearned() then return end
    
    local overgrowthHealthThreshold = 65
    if unit.ehp > overgrowthHealthThreshold then return end

    local hasLongDurationBuff = unit:BuffRemains(buffs.lifebloom, true) > 3000 or unit:BuffRemains(buffs.lifebloomUndergrowth, true) > 3000 or unit:BuffRemains(buffs.rejuvenation, true) > 3000
    if hasLongDurationBuff then return end

    return spell:Cast(unit)
end)

-- Lifebloom PvE (Tank only - uses focus target)
Lifebloom:Callback('HealingPve', function(spell)
    if A.IsInPvP then return end
    if not focus.isTank then return end

    -- Determine which buff ID to check based on Undergrowth talent
    local lifebloomBuffId = A.Undergrowth:IsTalentLearned() and buffs.lifebloomUndergrowth or buffs.lifebloom

    local hasLifebloomBuff = focus:Buff(lifebloomBuffId, true)
    -- If no buff at all, cast
    if not hasLifebloomBuff then
        return spell:Cast(focus)
    end
    -- Check remaining time - refresh if less than 4 seconds
    local lifebloomRemains = focus:BuffRemains(lifebloomBuffId) or 0
    if lifebloomRemains >= 4000 then return end
    return spell:Cast(focus)
end)

-- Lifebloom PvE (Player - Photosynthesis + Undergrowth)
-- Only use when both talents are learned - Undergrowth gives 2 Lifeblooms so we can put one on player
LifebloomP:Callback('Player', function(spell)
    if A.IsInPvP then return end

    -- Only cast on player if BOTH Photosynthesis AND Undergrowth are talented
    if A.Photosynthesis:IsTalentLearned() and A.Undergrowth:IsTalentLearned() then
        local hasLifebloomBuff = player:Buff(buffs.lifebloomUndergrowth, true)
        -- If no buff at all, cast
        if not hasLifebloomBuff then
            HealingEngine.SetTarget("player")
            return spell:Cast(player)
        end
        -- Check remaining time - refresh if less than 4 seconds
        local lifebloomRemains = player:BuffRemains(buffs.lifebloomUndergrowth) or 0
        if lifebloomRemains >= 4000 then return end
        HealingEngine.SetTarget("player")
        return spell:Cast(player)
    end
end)

-- CenarionWard
CenarionWard:Callback('HealingPve', function(spell)
    local isUnderDamage = Unit("focus"):GetRealTimeDMG() > 0 or unit:IsDummy()
    if not isUnderDamage then return end

    local isTank = Unit("focus"):Role("TANK")
    local applyToEveryone = GetToggle(2, "Checkbox5")
    if not (isTank or applyToEveryone) then return end

    local cenarionwardSlider = GetToggle(2, "CenarionWardSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.CenarionWard, cenarionwardSlider) then return end

    return spell:Cast(unit)
end)

--Rejuvenation/Germination Helper
local function shouldCastRejuvenation(unit, spell, buffType)
    if unit:BuffRemains(buffType) > 3000 then return end
    
    local isTank = GetToggle(2, "Checkbox1") and Unit("focus"):Role("TANK")
    if isTank or PlayerHaveInnervate then return true end
    
    local rejuvenationSlider = GetToggle(2, "RejuvenationSlider")
    if not AutoHealOrSlider(unit:CallerId(), spell, rejuvenationSlider) then return end
    
    return true
end

-- Rejuvenation
Rejuvenation:Callback('HealingPve', function(spell)
    if not shouldCastRejuvenation(unit, A.Rejuvenation, buffs.rejuvenation) then return end
    
    return spell:Cast(unit)
end)

-- Germination
Rejuvenation:Callback('Germination', function(spell)
    if not A.Germination:IsTalentLearned() then return end
    if not shouldCastRejuvenation(unit, A.Rejuvenation, buffs.germination) then return end
    
    return spell:Cast(unit)
end)

--Invigorate
Invigorate:Callback('HealingPve', function(spell)
    if not A.Invigorate:IsTalentLearned() then return end
    
    local healthThreshold = 75
    if unit.ehp > healthThreshold then return end

    return spell:Cast(unit)
end)

--Nourish
Nourish:Callback('HealingPve', function(spell)
    if not A.Nourish:IsTalentLearned() then return end

    local nourishSlider = GetToggle(2, "NourishSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Nourish, nourishSlider) then return end

    return spell:Cast(unit)
end)

--Regrowth
Regrowth:Callback('HealingPve', function(spell)
    if not (isStaying or PlayerHaveNaturesSwiftness or IncarnationTreeofLifeBuff or PlayerHaveBloomingInfusion) then return end

    local regrowthSlider = GetToggle(2, "RegrowthSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Regrowth, regrowthSlider) then return end

    return spell:Cast(unit)
end)

--Regrowth
Regrowth:Callback('Tree', function(spell)
    if not IncarnationTreeofLifeBuff then return end
    if not AutoHeal(unit:CallerId(), A.Regrowth) then return end

    return spell:Cast(unit)
end)

-- Rejuvenation Spread
Rejuvenation:Callback('Spread', function(spell)
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if ((GetToggle(2, "AutoSpread") and currentCombatTime > 0 and player.manaPct > GetToggle(2, "AutoSpreadSlider")) or (GetToggle(2, "SpreadHot")) or (GetToggle(2, "ForceSpread"))) then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.Rejuvenation:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.Rejuvenation.ID, true) then
                HealingEngine.SetTarget(unitID)
                spell:Cast(unit)
            end
        end
    end
end)

-- Germination
Rejuvenation:Callback('SpreadGermination', function(spell)
    if not A.Germination:IsTalentLearned() then return end
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if ((GetToggle(2, "AutoSpread") and currentCombatTime > 0 and player.manaPct > GetToggle(2, "AutoSpreadSlider")) or (GetToggle(2, "SpreadHot")) or (GetToggle(2, "ForceSpread"))) then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.Rejuvenation:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.RejuvenationGermimation.ID, true) then
                HealingEngine.SetTarget(unitID)
                spell:Cast(unit)
            end
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BOSS ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- HeartoftheWild
HeartoftheWild:Callback('DamageBossPve', function(spell)
    if not CanUseBossAbility() then return end

    return spell:Cast()
end)

-- NaturesVigil
NaturesVigil:Callback('DamageBossPve', function(spell)
    if not CanUseBossAbility() then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEBUFF ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Sunfire
Sunfire:Callback('DamagePve', function(spell)
    if not CanRefreshDot("Sunfire") then
        return
    end

    local sunfireRemains = target:DebuffRemains(debuffs.sunfire, true)
    if sunfireRemains > 3000 then
        return
    end

    return spell:Cast(target)
end)

-- Moonfire
Moonfire:Callback('DamagePve', function(spell)
    if not CanRefreshDot("Moonfire") then
        return
    end

    local moonfireRemains = target:DebuffRemains(debuffs.moonfire, true)
    if moonfireRemains > 3000 then
        return
    end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### CAT ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FluidForm
Rake:Callback('FluidForm', function(spell)
    if not A.Fluidform:IsTalentLearned() then return end
    if not HasValidTargets() then return end
    if not ShouldCatweave() then return end

    return spell:Cast(target)
end)

-- CatForm
CatForm:Callback('DamagePve', function(spell)
    if A.Fluidform:IsTalentLearned() then return end
    if not HasValidTargets() then return end
    if not ShouldCatweave() then return end

    return spell:Cast()
end)

-- Ferocious Bite
FerociousBite:Callback('DamagePve', function(spell)
    if not Player:IsStance(2) then return end
    if not target:HasDeBuff(debuffs.rip, true) then return end
    
    if player.comboPoints >= 5 then
        MakDebugPrint("Ferocious Bite: " .. player.comboPoints)
        return spell:Cast(target)
    elseif player.comboPoints >= 4 and target.ttd < 10000 then
        MakDebugPrint("Ferocious Bite: " .. player.comboPoints)
        return spell:Cast(target)
    end
end)

-- Thrash Cat AOE
ThrashCat:Callback('AoeDebuff', function(spell)
    if not Player:IsStance(2) then return end
    if not CanUseAoEAbility() then return end
    if not ShouldApplyDebuff(debuffs.thrashcat, 3000) then return end

    return spell:Cast()
end)

-- Rake
Rake:Callback('DamagePve', function(spell)
    if not Player:IsStance(2)then return end
    if not ShouldApplyDebuff(debuffs.rake, 3000) then return end

    return spell:Cast(target)
end)

-- Rip
Rip:Callback('DamagePve', function(spell)
    if not Player:IsStance(2) then return end
    if not ShouldApplyDebuff(debuffs.rip, 3000) then return end
    
    if player.comboPoints >= 5 then
        MakDebugPrint("Rip: " .. player.comboPoints)
        return spell:Cast(target)
    elseif player.comboPoints == 4 and target.ttd < 16000 and target.ttd > 10000 then
        MakDebugPrint("Rip: " .. player.comboPoints)
        return spell:Cast(target)
    elseif player.comboPoints == 3 and target.ttd < 12000 and target.ttd > 8000 then
        MakDebugPrint("Rip: " .. player.comboPoints)
        return spell:Cast(target)
    end
end)

-- Thrash Cat (Single target)
ThrashCat:Callback('DamagePve', function(spell)
    if not Player:IsStance(2) then return end
    if not inMeleeRange then return end
    if not ShouldApplyDebuff(debuffs.thrashcat, 3000) then return end

    return spell:Cast()
end)

-- Swipe Cat
SwipeCat:Callback('DamagePve', function(spell)
    if not Player:IsStance(2) then return end
    if not CanUseAoEAbility() then return end

    return spell:Cast()
end)

-- Shred
Shred:Callback('DamagePve', function(spell)
    if not Player:IsStance(2) then return end

    return spell:Cast(target)
end)

-- Rake
Rake:Callback('Stealth', function(spell)
    if not Player:IsStance(2) then return end
    
    local rakeDebuffRemains = target:DebuffRemains(debuffs.rake, true)
    if rakeDebuffRemains > 3000 then return end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BEAR ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FrenziedRegeneration
FrenziedRegeneration:Callback('Defensive4', function(spell)
    if not Player:IsStance(1) then return end
    if playerHealth > 70 then return end

    return spell:Cast()
end)

-- Ironfur
Ironfur:Callback('Defensive5', function(spell)
    if not Player:IsStance(1) then return end
    if player:Buff(A.Ironfur.ID) then return end

    return spell:Cast()
end)

-- Thrash Bear
ThrashBear:Callback('DamagePve', function(spell)
    if not Player:IsStance(1) then return end
    if not inMeleeRange then return end

    return spell:Cast()
end)

-- Mangle
Mangle:Callback('DamagePve', function(spell)
    if not Player:IsStance(1) then return end

    return spell:Cast(target)
end)

-- Swipe Bear
SwipeBear:Callback('DamagePve', function(spell)
    if not Player:IsStance(1) then return end
    if not inMeleeRange then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Starsurge
Starsurge:Callback('DamagePve', function(spell)
    if not CanUseBalanceAbility() then return end

    return spell:Cast(target)
end)

-- Starfire (Instant Cast - Checkbox)
Starfire:Callback('Instant', function(spell)
    if A.IsInPvP then return end
    if not CanUseBalanceAbility() then return end
    if not player:Buff(buffs.infusiondmg) then return end
    if MultiUnits:GetBySpell(A.Starfire) <= 1 then return end
    if unit.ehp < 50 then return end

    return spell:Cast(target)
end)

-- Wrath (Instant Cast)
Wrath:Callback('Instant', function(spell)
    if not CanUseBalanceAbility() then return end
    if not player:Buff(buffs.infusiondmg) then return end
    if unit.ehp < 50 then return end

    return spell:Cast(target)
end)

-- Starfire (Normal Cast)
Starfire:Callback('DamagePve', function(spell)
    if A.IsInPvP then return end
    if GetToggle(2, "StarfireInstantBox") then return end
    if not CanUseBalanceAbility() then return end
    if MultiUnits:GetBySpell(A.Starfire) <= 1 then return end

    return spell:Cast(target)
end)

-- Wrath (Normal Cast)
Wrath:Callback('DamagePve', function(spell)
    if not CanUseBalanceAbility() then return end

    return spell:Cast(target)
end)

--################################################################################################################################################################################################################

MassEntanglement:Callback('ForceRootRaid', function(spell, unit)
    return spell:Cast(unit)
end)

EntanglingRoots:Callback('Utilities2', function(spell, unit)
    return spell:Cast(unit)
end)

local function Untilities()
    Rebirth('Utilities1')
    local needUnitStop = wantToStopUnit()
    if needUnitStop ~= "None" then
        if needUnitStop == "MassMouse" then
            MassEntanglement('ForceRootRaid', mouseover)
        elseif needUnitStop == "MassTarget" then
            MassEntanglement('ForceRootRaid', target)
        elseif needUnitStop == "SingleMouse" then
            EntanglingRoots('ForceRootRaid', mouseover)
        elseif needUnitStop == "SingleTarget" then
            EntanglingRoots('ForceRootRaid', target)
        end
    end
end

NaturesSwiftness:Callback('PreCombatCast', function(spell)
    if not player.inCombat then return end
    if not IsInRaid() then return end
    if not player:Buff(buffs.natureswiftness) and not player.inCombat then
        return spell:Cast(player)
    end
end)

local function PreCombat()
    MarkoftheWild('PreCombat1')
    NaturesSwiftness('PreCombatCast')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SelfDefensive()
    Barkskin('Defensive1')
    Renewal('Defensive2')
    BearForm('Defensive3')
    FrenziedRegeneration('Defensive4')
    Ironfur('Defensive5')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rejuvenation Spread Macro
Rejuvenation:Callback('RampMacro', function(spell)
    if gameState.abundanceStacks >= 10 then return end
    if not A.Rejuvenation:IsReadyByPassCastGCD(unitID) then return end
    if not A.GetToggle(2, "rampRejuv") then return end

    local next_unit = MakMulti.party:Lowest(function(unit)
        if unit.dead then
            return 9999999999
        end
        return unit:Buff(A.Rejuvenation.ID, true) and 105 or unit:Health() 
    end)
    if next_unit and not next_unit:Buff(A.Rejuvenation.ID, true) then
        HealingEngine.SetTarget(next_unit:CallerId(), 1)
        return spell:Cast(next_unit)
    end
end)

-- Germination
Rejuvenation:Callback('RampMacroGermination', function(spell)
    if gameState.abundanceStacks >= 10 then return end
    if not A.Germination:IsTalentLearned() then return end
    if not A.Rejuvenation:IsReadyByPassCastGCD(unitID) then return end
    if not A.GetToggle(2, "rampRejuv") then return end

    local next_unit = MakMulti.party:Lowest(function(unit)
        if unit.dead then
            return 9999999999
        end
        return unit:Buff(A.RejuvenationGermimation.ID, true) and 105 or unit:Health() 
    end)
    if next_unit and not next_unit:Buff(A.Rejuvenation.ID, true) then
        HealingEngine.SetTarget(next_unit:CallerId(), 1)
        return spell:Cast(next_unit)
    end
end)

-- Wild Growth
WildGrowth:Callback('RampMacro', function(spell)
    if player.stayTime < 1 then return end
    if not A.GetToggle(2, "rampWildGrowth") then return end

    local next_unit = MakMulti.party:Lowest(function(unit)
        if unit.dead then
            return 9999999999
        end
        return unit:Health()
    end)
    if next_unit and not next_unit:Buff(A.WildGrowth.ID, true) then
        HealingEngine.SetTarget(next_unit:CallerId(), 1)
        return spell:Cast(next_unit)
    end
end)

-- Grove Guardian
GroveGuardians:Callback('RampMacro', function(spell)
    if not A.GetToggle(2, "rampGuardians") then return end
    spell:Cast(focus)
end)

--Natures Swiftness
NaturesSwiftness:Callback('RampMacro', function(spell)
    if not player.inCombat then return end
    if not A.GetToggle(2, "rampConvoke") then return end
    if ConvoketheSpirits:ReadyToUse() then
        spell:Cast(player)
    end
end)

-- Convoke
ConvoketheSpirits:Callback('RampMacro', function(spell)
    if not A.GetToggle(2, "rampConvoke") then return end
    if player:HasBuff(buffs.natureswiftness) then
        local next_unit = MakMulti.party:Lowest(function(unit)
            if unit.dead then
                return 9999999999
            end
            return unit:Health()
        end)
        if next_unit then
            HealingEngine.SetTarget(next_unit:CallerId(), 1)
            return spell:Cast(next_unit)
        end
    end
end)

local function rdruid_ramp_mode()
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 and MakuluFramework.rampMode then
        if player:TalentKnown(392302) then
            WildGrowth('RampMacro')
        end
        Rejuvenation('RampMacro')
        Rejuvenation('RampMacroGermination')
        if not player:TalentKnown(392302) then
            WildGrowth('RampMacro')
        end
        GroveGuardians('RampMacro')

        if gameState.abundanceStacks >= 10 then
            NaturesSwiftness('RampMacro')
            ConvoketheSpirits('RampMacro')
        end
    end
end

-------------------------------------------------------------------

CatForm:Callback('LowManaConvoke', function(spell)
    return spell:Cast(player)
end)

NaturesSwiftness:Callback('LowManaConvoke', function(spell)
    if not player.inCombat then return end
    return spell:Cast(player)
end)

ConvoketheSpirits:Callback('LowMana', function(spell)
    if not A.GetToggle(2, "ConvokeLowMana") then return end
    if not player:TalentKnown(289237) then return end
    if player.mana > 30 then return end
    if target.isFriendly then return end
    if target.distance >= 10 then return end
    if not HasValidTargets() then return end
    if not ShouldCatweave() then return end

    if not Player:IsStance(2) then
        return CatForm('LowManaConvoke')
    end

    if NaturesSwiftness:ReadyToUse() and not player:Buff(buffs.natureswiftness) then
        NaturesSwiftness('LowManaConvoke')
    end

    return spell:Cast(target)
end)

TrinketOverride(219313, function()
    if not target.exists or not target.isFriendly then return false end
    if not player.inCombat then return false end

    local lowestHealthAlly = party:Lowest(function(unit)
        if unit.dead then
            return 9999999999
        end
        return unit.ehp
    end)
    if lowestHealthAlly and lowestHealthAlly.ehp < 70 then
        return true
    end
    return false
end)

--###############################################################################
-- PVP Healing Callbacks
--###############################################################################

-- Nature's Swiftness with Soul of the Forest (2 charges)
NaturesSwiftness:Callback('pvp_sotf_2charge', function(spell, friendly)
    if not player.inCombat then return end
    if not friendly.exists then return end
    if not NaturesSwiftness:ReadyToUse() then return end
    local charges = NaturesSwiftness:Charges()
    if charges ~= 2 then return end
    if friendly.hp > 50 then return end
    if not player:Buff(buffs.soulforest) then return end
    return spell:Cast(player)
end)

-- Nature's Swiftness with Soul of the Forest (1 charge)
NaturesSwiftness:Callback('pvp_sotf_1charge', function(spell, friendly)
    if not player.inCombat then return end
    if not friendly.exists then return end
    if not NaturesSwiftness:ReadyToUse() then return end
    local charges = NaturesSwiftness:Charges()
    if charges ~= 1 then return end
    if friendly.hp > 38 then return end
    if player:Buff(buffs.natureswiftness) then return end
    if not player:Buff(buffs.soulforest) then return end
    return spell:Cast(player)
end)

-- Grove Guardians for Dream Surge Proc with Nature's Swiftness + Soul of the Forest
GroveGuardians:Callback('pvp_dreamsurge', function(spell, friendly)
    if not friendly.exists then return end
    if not GroveGuardians:ReadyToUse() then return end
    if player:Buff(buffs.dreamsurge) then return end
    if not player:Buff(buffs.natureswiftness) then return end
    if not player:Buff(buffs.soulforest) then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Regrowth with Nature's Swiftness + Soul of the Forest
Regrowth:Callback('pvp_ns_sotf', function(spell, friendly)
    if not friendly.exists then return end
    if not Regrowth:ReadyToUse() then return end
    if friendly.hp > 50 then return end
    if not player:Buff(buffs.natureswiftness) then return end
    if not player:Buff(buffs.soulforest) then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Regrowth with Soul of the Forest (standing still)
Regrowth:Callback('pvp_sotf', function(spell, friendly)
    if not friendly.exists then return end
    if not Regrowth:ReadyToUse() then return end
    if player.moving then return end
    if friendly.hp > 65 then return end
    if not player:Buff(buffs.soulforest) then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Rejuvenation with Soul of the Forest
Rejuvenation:Callback('pvp_sotf', function(spell, friendly)
    if not friendly.exists then return end
    if not Rejuvenation:ReadyToUse() then return end
    if friendly.hp > 80 then return end
    if not player:Buff(buffs.soulforest) then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Swiftmend
Swiftmend:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Swiftmend:ReadyToUse() then return end
    if friendly.hp >= 85 then return end
    local hasRegrowth = friendly:Buff(buffs.regrowth)
    local hasRejuv = friendly:Buff(buffs.rejuvenation)
    if not hasRegrowth and not hasRejuv then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Frenzied Regeneration
FrenziedRegeneration:Callback('pvp', function(spell)
    if not FrenziedRegeneration:ReadyToUse() then return end
    if player.hp >= 35 then return end
    return spell:Cast(player)
end)

-- Bear Form for Frenzied Regeneration
BearForm:Callback('pvp', function(spell)
    if not BearForm:ReadyToUse() then return end
    if player.hp > 21 then return end
    if player:Buff(buffs.bearform) then return end
    if not FrenziedRegeneration:ReadyToUse() then return end
    if player:Buff(buffs.frenziedregeneration) then return end
    return spell:Cast(player)
end)

-- Cat Form to break roots (shifting to Cat Form breaks root effects)
CatForm:Callback('pvp_entangle', function(spell)
    if not CatForm:ReadyToUse() then return end
    if player:Buff(buffs.catform) then return end
    if not player:IsRooted() then return end
    return spell:Cast(player)
end)

-- Ironbark
Ironbark:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Ironbark:ReadyToUse() then return end
    if friendly.hp >= 50 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Cenarion Ward
CenarionWard:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not CenarionWard:ReadyToUse() then return end
    if friendly.hp > 58 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Overgrowth (OH SHIT)
-- Only cast if target has 2 or fewer HoTs to avoid overwriting existing HoT coverage
Overgrowth:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Overgrowth:ReadyToUse() then return end
    if friendly.hp > 55 then return end

    -- Count active HoTs on target
    local hotCount = 0

    -- Check Rejuvenation
    if friendly:Buff(buffs.rejuvenation, true) then hotCount = hotCount + 1 end

    -- Check Germination
    if friendly:Buff(buffs.germination, true) then hotCount = hotCount + 1 end

    -- Check Lifebloom (use correct buff based on Undergrowth talent)
    local lifebloomBuffId = A.Undergrowth:IsTalentLearned() and buffs.lifebloomUndergrowth or buffs.lifebloom
    if friendly:Buff(lifebloomBuffId, true) then hotCount = hotCount + 1 end

    -- Check Regrowth HoT
    if friendly:Buff(buffs.regrowth, true) then hotCount = hotCount + 1 end

    -- Check Adaptive Swarm (spell ID 391888 is also the buff)
    if friendly:Buff(A.AdaptiveSwarm.ID, true) then hotCount = hotCount + 1 end

    -- Only cast if 2 or fewer HoTs are present
    if hotCount > 2 then return end

    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Incarnation Tree of Life (PvP)
IncarnationTreeofLife:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not IncarnationTreeofLife:ReadyToUse() then return end
    if A.AncientofLore:IsTalentLearned() then return end
    if player:Buff(buffs.incarnation) then return end
    local emergencyHeal = friendly.hp <= 55 or HealingEngine.GetBelowHealthPercentUnits(70) >= 3 or HealingEngine.GetBelowHealthPercentUnits(60) >= 2
    if not emergencyHeal then return end
    return spell:Cast(player)
end)

-- Adaptive Swarm
AdaptiveSwarm:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not AdaptiveSwarm:ReadyToUse() then return end
    if friendly.hp > 80 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Grove Guardians (3 charges)
GroveGuardians:Callback('pvp_3charge', function(spell, friendly)
    if not friendly.exists then return end
    if not GroveGuardians:ReadyToUse() then return end
    if not player.inCombat then return end
    local charges = GroveGuardians:Charges()
    if charges ~= 3 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Grove Guardians (2 charges)
GroveGuardians:Callback('pvp_2charge', function(spell, friendly)
    if not friendly.exists then return end
    if not GroveGuardians:ReadyToUse() then return end
    local charges = GroveGuardians:Charges()
    if charges ~= 2 then return end
    if friendly.hp > 75 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Grove Guardians (1 charge)
GroveGuardians:Callback('pvp_1charge', function(spell, friendly)
    if not friendly.exists then return end
    if not GroveGuardians:ReadyToUse() then return end
    local charges = GroveGuardians:Charges()
    if charges ~= 1 then return end
    if friendly.hp > 58 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Rejuvenation
Rejuvenation:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Rejuvenation:ReadyToUse() then return end
    if friendly.hp > 98 then return end
    if friendly:Buff(buffs.rejuvenation, true) and friendly:BuffRemains(buffs.rejuvenation) > 3000 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Germination
RejuvenationGermimation:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not RejuvenationGermimation:ReadyToUse() then return end
    if friendly.hp > 90 then return end
    if friendly:Buff(buffs.germination, true) and friendly:BuffRemains(buffs.germination) > 3000 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Lifebloom PvP (handles both Undergrowth and Photosynthesis)
-- Helper function to check if target needs Lifebloom (checks correct buff based on talent)
local function needsLifebloom(unit)
    if not unit.exists or unit.dead then return false end
    -- Check correct buff ID based on Undergrowth talent
    local lifebloomBuffId = A.Undergrowth:IsTalentLearned() and buffs.lifebloomUndergrowth or buffs.lifebloom
    local hasLifebloomBuff = unit:Buff(lifebloomBuffId, true)
    if not hasLifebloomBuff then return true end
    local lifebloomRemains = unit:BuffRemains(lifebloomBuffId) or 0
    if lifebloomRemains >= 4000 then return false end
    return true
end

-- Helper function to check if player is being targeted by arena enemies
local function isPlayerBeingTargeted()
    local arenaUnits = {arena1, arena2, arena3}
    for _, arenaUnit in ipairs(arenaUnits) do
        if arenaUnit.exists and not arenaUnit.dead then
            local enemyTarget = arenaUnit.target
            if enemyTarget and enemyTarget.exists and enemyTarget.isMe then
                return true
            end
        end
    end
    return false
end

-- LifebloomP: Cast on player (self) only
LifebloomP:Callback('PlayerPVP', function(spell)
    if not A.IsInPvP then return end
    if not LifebloomP:ReadyToUse() then return end
    if not player.inCombat then return end
    if not A.Undergrowth:IsTalentLearned() then return end
    if not needsLifebloom(player) then return end

    -- Get party size (excluding player)
    local partySize = 0
    MakMulti.party:ForEach(function(friendly)
        if friendly.exists and not friendly.dead and not friendly.isMe then
            partySize = partySize + 1
        end
    end)

    -- Solo or 1 party member: always cast on self
    if partySize <= 1 then
        return spell:Cast(player)
    end

    -- Party size 2+: only cast on self if being targeted AND health < 85%
    if isPlayerBeingTargeted() and player.hp < 85 then
        return spell:Cast(player)
    end
end)

-- Lifebloom: Cast on party members (or self if no Undergrowth)
Lifebloom:Callback('pvp', function(spell)
    if not Lifebloom:ReadyToUse() then return end
    if not player.inCombat then return end

    local hasUndergrowth = A.Undergrowth:IsTalentLearned()
    local hasPhotosynthesis = A.Photosynthesis:IsTalentLearned()

    -- With Undergrowth: LifebloomP handles player, this handles party members
    if hasUndergrowth then
        local partyMembers = {}
        MakMulti.party:ForEach(function(friendly)
            if friendly.exists and not friendly.dead and not friendly.isMe then
                table.insert(partyMembers, friendly)
            end
        end)

        table.sort(partyMembers, function(a, b) return a.hp < b.hp end)

        -- With Undergrowth we can have 2 Lifeblooms - one on player (via LifebloomP), one on party
        for i = 1, math.min(1, #partyMembers) do
            local friendly = partyMembers[i]
            if friendly and needsLifebloom(friendly) then
                HealingEngine.SetTarget(friendly:CallerId(), 1)
                return spell:Cast(friendly)
            end
        end
        return
    end

    -- Without Undergrowth: single Lifebloom goes on lowest HP (can include self with Photosynthesis)
    if hasPhotosynthesis then
        -- With Photosynthesis but no Undergrowth: prefer self for the healing boost
        if needsLifebloom(player) then
            HealingEngine.SetTarget(player:CallerId(), 1)
            return spell:Cast(player)
        end
    else
        -- No talents: Lifebloom on lowest HP party member
        local lowestHP = MakMulti.party:Lowest(function(friendly)
            if friendly.isMe then return 999 end -- Exclude self
            return friendly.hp
        end)
        if lowestHP and not lowestHP.isMe and needsLifebloom(lowestHP) then
            HealingEngine.SetTarget(lowestHP:CallerId(), 1)
            return spell:Cast(lowestHP)
        end
    end
end)

-- Convoke the Spirits
ConvoketheSpirits:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not ConvoketheSpirits:ReadyToUse() then return end
    if HealingEngine.GetBelowHealthPercentUnits(80) < 3 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Wild Growth
WildGrowth:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not WildGrowth:ReadyToUse() then return end
    if player.moving then return end
    if HealingEngine.GetBelowHealthPercentUnits(90) < 3 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Tranquility
Tranquility:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Tranquility:ReadyToUse() then return end
    if player.moving then return end
    if HealingEngine.GetBelowHealthPercentUnits(60) < 3 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Flourish
Flourish:Callback('pvp', function(spell)
    if not Flourish:ReadyToUse() then return end
    if HealingEngine.GetBelowHealthPercentUnits(85) < 3 then return end
    return spell:Cast(player)
end)

-- Regrowth (Clear Casting)
Regrowth:Callback('pvp_cc', function(spell, friendly)
    if not friendly.exists then return end
    if not Regrowth:ReadyToUse() then return end
    if player.moving then return end
    if not player:Buff(buffs.clearcast) then return end
    if friendly.hp > 90 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Regrowth (Incarnation Tree of Life)
Regrowth:Callback('pvp_incarn', function(spell, friendly)
    if not friendly.exists then return end
    if not Regrowth:ReadyToUse() then return end
    if not player:Buff(buffs.incarnation) then return end
    if friendly.hp > 85 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)

-- Regrowth (basic)
Regrowth:Callback('pvp', function(spell, friendly)
    if not friendly.exists then return end
    if not Regrowth:ReadyToUse() then return end
    if player.moving then return end
    if friendly.hp > 85 then return end
    HealingEngine.SetTarget(friendly:CallerId(), 1)
    return spell:Cast(friendly)
end)


local function HealerRotationPvP()
    local friendly
    if target.exists and target.isFriendly then
        friendly = target
    elseif focus.exists and focus.isFriendly then
        friendly = focus
    else
        return
    end

    MassBlooming('AncientWindow')  
    BlossomBurst('AncientWindow')  
    AncientofLore('pvp')
    NaturesSwiftness('AncientPrep')

    -- Nature's Swiftness with Soul of the Forest
    NaturesSwiftness('pvp_sotf_2charge', friendly)
    NaturesSwiftness('pvp_sotf_1charge', friendly)

    -- Grove Guardians for Dream Surge proc
    GroveGuardians('pvp_dreamsurge', friendly)

    -- Nature's Swiftness + Soul of the Forest Regrowth
    Regrowth('pvp_ns_sotf', friendly)

    -- Soul of the Forest consumers
    Regrowth('pvp_sotf', friendly)
    Rejuvenation('pvp_sotf', friendly)

    -- Swiftmend
    Swiftmend('pvp', friendly)

    -- Defensive abilities
    FrenziedRegeneration('pvp')
    BearForm('pvp')
    CatForm('pvp_entangle')

    -- Ironbark
    Ironbark('pvp', friendly)

    -- Cenarion Ward
    CenarionWard('pvp', friendly)

    -- Overgrowth (emergency)
    Overgrowth('pvp', friendly)

    -- Incarnation Tree of Life
    IncarnationTreeofLife('pvp', friendly)

    -- Adaptive Swarm
    AdaptiveSwarm('pvp', friendly)

    -- Grove Guardians by charges
    GroveGuardians('pvp_3charge', friendly)
    GroveGuardians('pvp_2charge', friendly)
    GroveGuardians('pvp_1charge', friendly)

    -- Rejuvenation / Germination
    Rejuvenation('pvp', friendly)
    RejuvenationGermimation('pvp', friendly)

    -- Lifebloom
    LifebloomP('PlayerPVP')
    Lifebloom('pvp', friendly)

    -- Convoke
    ConvoketheSpirits('pvp', friendly)

    -- Wild Growth
    WildGrowth('pvp', friendly)

    -- Tranquility
    Tranquility('pvp', friendly)

    -- Flourish
    Flourish('pvp')

    -- Regrowth variants
    Regrowth('pvp_cc', friendly)
    Regrowth('pvp_incarn', friendly)
    Regrowth('pvp', friendly)

    SymbioticRelationship('HealingPve')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Skip Action when all Members are above the EmergencySlider health threshold
local function ShouldSkipHealing()
    local emergencyThreshold = GetToggle(2, "EmergencySlider")
    local stance = Player:GetStance()
    return stance >= 1 and stance <= 3 and unit.ehp > emergencyThreshold
end

local function HealerRotationPve()
    if MakuluFramework.rampMode then
        
    end

    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end
    
    MassBlooming('AncientWindow')  
    BlossomBurst('AncientWindow')  
    AncientofLore('pvp')
    NaturesSwiftness('AncientPrep')

    NaturesCure('Dispel')
    Ironbark('Emergency')

    rdruid_ramp_mode()

    --Skip Action when all Members are above 65% Health
    if ShouldSkipHealing() then
        return
    end

    Starfire('Instant')
    Wrath('Instant')

    if GetToggle(2, "ForceSpread") then
        Rejuvenation('Spread')
        Rejuvenation('SpreadGermination')
    end

    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')

    Tranquility('Cooldowns')
    IncarnationTreeofLife('Cooldowns')
    ConvoketheSpirits('Cooldowns')
    Flourish('Cooldowns')
    Innervate('Cooldowns')
    Innervate('FriendlyHealer')

    SymbioticRelationship('HealingPve')

    SotFHandler()
    NaturesSwiftness('HealingPve')
    GroveGuardians('HealingPve')
    --Efflorescence('HealingPve')
    WildGrowth('HealingPve')
    LifebloomP('Player')
    Regrowth('Freecast')
    Overgrowth('HealingPve')
    Lifebloom('HealingPve')
    CenarionWard('HealingPve')
    Rejuvenation('HealingPve')
    Rejuvenation('Germination')
    Rejuvenation('Spread')
    Rejuvenation('SpreadGermination')
    Invigorate('HealingPve')
    Nourish('HealingPve')
    Regrowth('HealingPve')
    --Regrowth('Tree')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
    if Player:IsStealthed() then
        Rake('Stealth')
    else
        Starsurge('DamagePve')    

        Sunfire('DamagePve')
        Moonfire('DamagePve')

        HeartoftheWild('DamageBossPve')
        NaturesVigil('DamageBossPve')

        Rake('FluidForm')
        CatForm('DamagePve')
        ThrashCat('AoeDebuff')
        FerociousBite('DamagePve')
        Rake('DamagePve')
        Rip('DamagePve')
        ThrashCat('DamagePve')
        SwipeCat('DamagePve')
        Shred('DamagePve')

        ThrashBear('DamagePve')
        Mangle('DamagePve')
        SwipeBear('DamagePve')

        Starsurge('DamagePve')
        Starfire('DamagePve')
        Wrath('DamagePve')
    end
end

--################################################################################################################################################################################################################
--[[
Lifebloom:Callback('BurstMode', function(spell)
    local bloomCount = HealingEngine.GetBuffsCount({A.Lifebloom.ID, A.UndergrowthLifebloom.ID, A.FullBloomLifebloom.ID}, 0, true)

    if bloomCount >= 2 then return end
    if bloomCount == 1 and not player:TalentKnown(A.Undergrowth.ID) then return end

    if tank and tank.exists and tank.hp > 0 and not tank:HasBuff(buffs.lifebloom) then
        HealingEngine.SetTarget(tank:CallerId(), 1)
        print("Lifebloom on tank")
        return spell:Cast(tank)
    end

    if player:TalentKnown(A.Photosynthesis.ID) and not player:HasBuff(buffs.lifebloom) then
        HealingEngine.SetTarget(player:CallerId(), 1)
        print("Lifebloom on player")
        return spell:Cast(player)
    else
        local lowestHealthAlly = party:Lowest(function(unit)
            return unit:Health() and unit ~= tank and not unit:HasBuff(buffs.lifebloom)
        end)

        if lowestHealthAlly and lowestHealthAlly.exists then
            HealingEngine.SetTarget(lowestHealthAlly:CallerId(), 1)
            print("Lifebloom on lowest health ally")
            return spell:Cast(lowestHealthAlly)
        end
    end
end)

Rejuvenation:Callback('BurstMode', function(spell)
    local hotTarget = party:Find(function(unit)
        return unit.exists and 
               not unit.dead and
               not unit:HasBuff(buffs.rejuvenation) and
               not unit:HasBuff(buffs.germination)
    end)

    if hotTarget then
        HealingEngine.SetTarget(hotTarget:CallerId(), 1)
        print("Rejuvenation on " .. hotTarget.name)
        return spell:Cast(hotTarget)
    end
end)

Regrowth:Callback('BurstMode', function(spell)
    local regrowthTarget = party:Find(function(unit)
        return unit.exists and 
               not unit.dead and
               not unit:HasBuff(Regrowth)
    end)
    
    if regrowthTarget then
        HealingEngine.SetTarget(regrowthTarget:CallerId(), 1)
        print("Regrowth on " .. regrowthTarget.name)
        return spell:Cast(regrowthTarget)
    end
end)

local function HealerBurstMode()
    if MakuluFramework.burstMode then
        Lifebloom('BurstMode')
        Rejuvination('BurstMode')
        Regrowth('BurstMode')
        local effloCounter = party:Count(function(unit)
            return unit:Buff(buffs.efflorescence, true)
        end)
        if effloCounter <= 1 then
            Aware:displayMessage("Need Efflorescence", "Blue", 1.4, GetSpellTexture(A.Efflorescence.ID))
        end


    end
end
]]--
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

MakuluFramework.firstLoop = true
A[3] = function(icon)
	FrameworkStart(icon)

    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    updateGameState()
    SetUpHealers()

    gameState.abundanceStacks = player:HasBuffCount(207640)
    
    if IS_DEV_DEBUGGING then
        MakPrint(1, "Abundance Stacks: ", gameState.abundanceStacks)
        MakPrint(2, "Ramp Mode: ", MakuluFramework.rampMode)
    end

	local CantCast = CantCast()
	if CantCast then return end

    -- In stealth: only allow Rake, skip the rest of the rotation
    if Player:IsStealthed() then
        if target.exists and target.canAttack then
            Rake('Stealth')
        end
        return FrameworkEnd()
    end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= (player and player.CombatTime and player:CombatTime()) or 0
	playerHealth	= player.ehp
	inMeleeRange	= target:Distance() <= 5
	Enemies10y	    = Unit("target"):GetRange() < 10

    -- Buffs
    PlayerHaveNaturesSwiftness  = player:Buff(buffs.natureswiftness, true)
    PlayerHaveBloomingInfusion  = player:Buff(buffs.infusionheal, true)
    PlayerHaveInnervate         = player:Buff(buffs.innervate, true)
    IncarnationTreeofLifeBuff   = player:Buff(buffs.incarnation, true)
    PlayerHaveClearcast         = player:Buff(buffs.clearcast, true)
    PlayerHaveSouloftheForest   = player:Buff(buffs.soulforest, true)

    local CanSwiftmend = canUseSwiftmend()
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local channel = player.channelInfo
    if not player.channeling then
        makInterrupt(interrupts)
    end

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--Utilities
    Untilities()

     --PreCombat/Defensives
    PreCombat()
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 0 then
        SelfDefensive()
    end

    BearForm('LeaveForm')
    CatForm('LeaveForm')

    ConvoketheSpirits('LowMana')

    --Soothe Rotation PVE
    if target.exists and target.canAttack then
        Soothe('Dispel')
    end

    --Healing Rotation PVP
    if A.IsInPvP and (target.exists or focus.exists) and not Player:IsStealthed() then
        
        if CanSwiftmend then
            return A.Swiftmend:Show(icon)
        end

        HealerRotationPvP()
    end

    --Healing Rotation PVE
    if not A.IsInPvP and (target.exists or focus.exists) and not Player:IsStealthed() then
        
        if CanSwiftmend then
            return A.Swiftmend:Show(icon)
        end

        --HealerBurstMode()

        HealerRotationPve()
    end

    --Damage Rotation PVE
    if target.exists and target.canAttack and not Player:IsStealthed() then
        DamageRotationPve()
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### ARENA ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Kill Target Detection - Prevents accidentally CCing the unit our team is trying to kill
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local BLESSING_OF_PROTECTION = 1022
local DIVINE_SHIELD = 642
local ICE_BLOCK = 45438
local BLESSING_OF_SPELLWARDING = 204018

-- List of defensive immunity buffs that make CC the only viable option
local defensiveImmunityBuffs = {
    BLESSING_OF_PROTECTION,
    DIVINE_SHIELD,
    ICE_BLOCK,
    BLESSING_OF_SPELLWARDING,
}

-- Helper function to check if unit has a defensive immunity that blocks damage
local function hasDefensiveImmunity(unit)
    if not unit or not unit.exists then return false end
    for _, buffId in ipairs(defensiveImmunityBuffs) do
        if unit:Buff(buffId) then return true end
    end
    return false
end

-- Helper function to check if a unit is being focused by our team (player or party members)
local function isBeingFocused(unit)
    if not unit or not unit.exists then return false end
    if not unit.guid then return false end

    -- Check if player is targeting this unit
    if unit.isTarget then return true end

    -- Check if any party member (other than player) is targeting this unit
    local isFocused = MakMulti.party:Any(function(friendly)
        if not friendly.exists then return false end
        if friendly.dead then return false end
        if friendly.isMe then return false end

        local friendlyTarget = friendly.target
        if not friendlyTarget then return false end
        if not friendlyTarget.exists then return false end
        if not friendlyTarget.guid then return false end

        return friendlyTarget.guid == unit.guid
    end)

    return isFocused
end

-- Helper function to determine if a unit is the kill target based on incoming damage
-- Returns true if the unit is taking significantly more damage than other enemies
local function isKillTarget(unit)
    if not unit or not unit.exists then return false end

    -- First check: is the unit being focused by our team?
    if not isBeingFocused(unit) then return false end

    -- Second check: is the unit taking significant damage? (DPS check via framework)
    local unitDPS = 0
    if MakuluFramework.GetDmgPerSec then
        unitDPS = MakuluFramework.GetDmgPerSec(unit) or 0
    end

    -- If unit is focused and taking any meaningful damage, consider it the kill target
    -- Threshold: more than 5000 DPS incoming means they're being actively attacked
    if unitDPS > 5000 then return true end

    -- Also consider it kill target if they're focused and below 70% HP (actively being damaged)
    if unit.hp < 70 then return true end

    return false
end

-- Main helper function to check if we should avoid CCing this unit
-- Returns true if we should NOT CC this unit (it's the kill target without immunity)
local function shouldAvoidCC(unit)
    if not unit or not unit.exists then return false end

    -- If unit has defensive immunity, we SHOULD CC them (Cyclone goes through BoP, etc.)
    if hasDefensiveImmunity(unit) then return false end

    -- If unit is the kill target, avoid CCing
    if isKillTarget(unit) then return true end

    return false
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Healer spec IDs for reliable detection (used by Cyclone and CC combo)
local HEALER_SPECS = {
    [105] = true,   -- Restoration Druid
    [1468] = true,  -- Preservation Evoker
    [270] = true,   -- Mistweaver Monk
    [65] = true,    -- Holy Paladin
    [256] = true,   -- Discipline Priest
    [257] = true,   -- Holy Priest
    [264] = true,   -- Restoration Shaman
}

-- Helper function to check if unit is confirmed healer by spec ID
local function isConfirmedHealer(unit)
    if not unit or not unit.exists or unit.dead then return false end
    local specId = unit.specId or 0
    return specId > 0 and HEALER_SPECS[specId]
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cyclone:Callback("pvp", function(spell, enemy)
    -- Must have a valid enemy passed from enemyRotation
    if not enemy or not enemy.exists then return end

    -- Don't use Cyclone during Ancient of Lore - preserve healing window
    if player:Buff(buffs.ancientoflore) then return end

    local EMERALD_COMMUNION = 370960
    local RAKE_STUN = 163505  -- Rake stun debuff ID

    -- Basic Cyclone cast requirements
    local function canCyclone()
        if not spell:InRange(enemy) then return false end
        if enemy.ccImmune then return false end
        if enemy.totalImmune then return false end
        if enemy.magicImmune then return false end
        if enemy:CCRemains() > spell:CastTime() then return false end
        return true
    end

    -- Full validation including kill target protection
    local function isValidCycloneTarget()
        if not canCyclone() then return false end
        if enemy.hp < 50 then return false end
        -- Don't cyclone kill target unless they have defensive immunity
        if shouldAvoidCC(enemy) then return false end
        return true
    end

    -- Don't Cyclone if any party member is below 85% HP
    local partyNeedsHealing = MakMulti.party:Any(function(friendly)
        return friendly.exists and not friendly.dead and friendly.hp < 85
    end)
    if partyNeedsHealing then return end

    -- Only Cyclone confirmed healer specs (use spec ID to avoid false positives like Shadow Priest)
    local enemySpecId = enemy.specId or 0
    if enemySpecId == 0 or not HEALER_SPECS[enemySpecId] then return end

    -- Never Cyclone the kill target
    if shouldAvoidCC(enemy) then return end

    -- Priority 1: Evoker channeling Emerald Communion
    if enemy:IsChanneling(EMERALD_COMMUNION) then
        if canCyclone() then
            Aware:displayMessage("Cyclone - Emergency Stop!", "Red", 1.5)
            return spell:Cast(enemy)
        end
    end

    -- Priority 2: Healer stunned by Rake - chain into Cyclone immediately!
    if enemy:Debuff(RAKE_STUN, true) then
        local rakeRemains = enemy:DebuffRemains(RAKE_STUN, true)
        -- Cast Cyclone if Rake stun will expire during or just after cast
        if rakeRemains > 0 and rakeRemains <= spell:CastTime() + 500 then
            if canCyclone() then
                Aware:displayMessage("Cyclone - Rake Chain!", "Orange", 1.5)
                return spell:Cast(enemy)
            end
        end
    end

    -- Priority 3: Healer with defensive immunity (Cyclone goes through BoP, Divine Shield, etc.)
    if hasDefensiveImmunity(enemy) then
        if canCyclone() then
            Aware:displayMessage("Cyclone - Immunity Target!", "Yellow", 1.5)
            return spell:Cast(enemy)
        end
    end

    -- Priority 4: Healer with NO DR (full duration) - respects kill target protection
    if isValidCycloneTarget() then
        local healerDR = enemy.disorientDr or 1
        if healerDR >= 1.0 then
            Aware:displayMessage("Cyclone - Healer CC!", "Blue", 1.5)
            return spell:Cast(enemy)
        end
    end

    -- Priority 5: Healer with some DR (at least 50% duration) - respects kill target protection
    if isValidCycloneTarget() then
        local healerDR = enemy.disorientDr or 1
        if healerDR >= 0.5 then
            Aware:displayMessage("Cyclone - Healer CC!", "Blue", 1.5)
            return spell:Cast(enemy)
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Bear Form callback to break incoming Polymorph/Hex
BearForm:Callback('BreakCC', function(spell, enemy)
    if not A.IsInPvP then return end
    if not enemy.exists then return end

    -- Only shift if we're in human/caster form (stance 0)
    local stance = Player:GetStance()
    if stance ~= 0 then return end

    -- Check if this enemy is casting Polymorph/Hex on us
    if enemy:CastingFromFor(MakLists.arenaFadeList, 500) then
        local castInfo = enemy.castOrChannelInfo
        -- Only react when cast is >= 80% to avoid fake casts
        if castInfo and castInfo.percent >= 80 then
            -- Verify they're targeting us
            local enemyTarget = enemy.target
            if enemyTarget and enemyTarget.exists and enemyTarget.isMe then
                return spell:Cast(player)
            end
        end
    end
end)

-- Forward declaration for executeHealerCCCombo (defined below)
local executeHealerCCCombo

-- Enemy rotation (called per arena unit from A[6], A[7], A[8])
local enemyRotation = function(enemy)
    if not enemy or not enemy.exists then return end
    if Player:IsStealthed() then return end

    -- Execute healer CC combo FIRST (highest priority offensive play)
    -- This is called once per frame due to internal throttling
    executeHealerCCCombo()

    -- Other enemy abilities
    BearForm('BreakCC', enemy)
    Cyclone("pvp", enemy)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Healer CC Combo: Cat Form -> Wild Charge -> Incapacitating Roar -> Cyclone
-- Used to lock down enemy healers in arena
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Track combo state
local healerCCComboState = {
    active = false,
    targetGuid = nil,
    step = 0,
    lastStepTime = 0,
    lastExecuteTime = 0, -- Prevent running multiple times per frame
}

-- Helper function to check if party is safe enough for offensive play
local function partyIsSafeForCC()
    local anyBelowThreshold = MakMulti.party:Any(function(friendly)
        if not friendly.exists or friendly.dead then return false end
        return friendly.hp < 50
    end)
    return not anyBelowThreshold
end

-- Helper function to find enemy healer (uses isConfirmedHealer defined above)
local function findEnemyHealer()
    if isConfirmedHealer(arena1) then return arena1 end
    if isConfirmedHealer(arena2) then return arena2 end
    if isConfirmedHealer(arena3) then return arena3 end
    return nil
end

-- Helper function to check if target is valid for CC combo
local function isValidCCComboTarget(enemy)
    if not enemy or not enemy.exists then return false end
    if enemy.dead then return false end
    if enemy.ccImmune then return false end
    if enemy.totalImmune then return false end
    if enemy:CCRemains() > 2000 then return false end -- Already CC'd
    -- Don't CC kill target unless they have defensive immunity
    if shouldAvoidCC(enemy) then return false end
    return true
end

-- Main CC Combo function (assigned to forward-declared local)
executeHealerCCCombo = function()
    -- Only in arena
    if Action.Zone ~= "arena" then return end
    if not A.IsInPvP then return end
    if not player.inCombat then return end

    local currentTime = GetTime() * 1000

    -- Prevent running multiple times per frame (called from multiple arena icons)
    if currentTime - healerCCComboState.lastExecuteTime < 50 then return end
    healerCCComboState.lastExecuteTime = currentTime

    -- Don't shift forms during Ancient of Lore - preserve healing window
    if player:Buff(buffs.ancientoflore) then return end

    -- Don't execute while stealthed
    if Player:IsStealthed() then return end

    -- Safety check - don't do offensive plays if party needs healing
    if not partyIsSafeForCC() then
        if healerCCComboState.active then
            healerCCComboState.active = false
            healerCCComboState.step = 0
        end
        return
    end

    -- Find enemy healer
    local enemyHealer = findEnemyHealer()
    if not enemyHealer then return end

    -- Reset combo if target changed or timeout (10 seconds - increased for travel time)
    if healerCCComboState.targetGuid ~= enemyHealer.guid or
       (healerCCComboState.lastStepTime > 0 and currentTime - healerCCComboState.lastStepTime > 10000) then
        healerCCComboState.active = false
        healerCCComboState.step = 0
        healerCCComboState.targetGuid = enemyHealer.guid
    end

    -- Check if we're mid-combo (step > 0) - if so, continue even if target is briefly invalid
    local isMidCombo = healerCCComboState.step > 0

    -- For starting a new combo, require full validation
    if not isMidCombo then
        if not isValidCCComboTarget(enemyHealer) then return end
        -- Only start the combo if Incapacitating Roar is available
        if not IncapacitatingRoar:ReadyToUse() then return end
    end

    -- Step 0 -> 1: Cat Form (if not already in cat form)
    if healerCCComboState.step == 0 then
        if not player:Buff(buffs.catform) then
            if CatForm:ReadyToUse() then
                healerCCComboState.active = true
                healerCCComboState.step = 1
                healerCCComboState.lastStepTime = currentTime
                Aware:displayMessage("Cat Form - Starting CC Combo!", "Green", 1.5)
                return CatForm:Cast(player)
            end
            return -- Wait for Cat Form to be ready
        else
            -- Already in cat form, advance to step 1
            healerCCComboState.active = true
            healerCCComboState.step = 1
            healerCCComboState.lastStepTime = currentTime
            -- Fall through to step 1 logic immediately
        end
    end

    -- Step 1 -> 2: Wild Charge (leap) to enemy healer
    if healerCCComboState.step == 1 then
        -- Already in range for roar, advance to step 2
        if enemyHealer.distance <= 10 then
            healerCCComboState.step = 2
            healerCCComboState.lastStepTime = currentTime
            -- Fall through to step 2 logic immediately
        -- Need to leap to get in range
        elseif WildCharge:ReadyToUse() and enemyHealer.canAttack and enemyHealer.distance <= 25 then
            -- Set step to 2 AFTER cast succeeds (on next frame)
            Aware:displayMessage("Wild Charge - Gap Closer!", "Cyan", 1.5)
            healerCCComboState.lastStepTime = currentTime
            local result = WildCharge:Cast(enemyHealer)
            if result then
                healerCCComboState.step = 2
            end
            return result
        else
            -- Can't leap yet (out of range or on cooldown), wait
            return
        end
    end

    -- Step 2 -> 3: Incapacitating Roar (10 yard range AoE incapacitate)
    if healerCCComboState.step == 2 then
        -- Wait until we're in range (may still be traveling from Wild Charge)
        if enemyHealer.distance > 10 then
            -- Check if we've been waiting too long (3 seconds should be enough for leap travel)
            if currentTime - healerCCComboState.lastStepTime > 3000 then
                -- Reset combo, leap failed
                healerCCComboState.active = false
                healerCCComboState.step = 0
                Aware:displayMessage("CC Combo Failed - Out of Range", "Red", 1.5)
            end
            return
        end

        -- In range, cast Incapacitating Roar
        if IncapacitatingRoar:ReadyToUse() and not enemyHealer.ccImmune and enemyHealer:CCRemains() < 500 then
            Aware:displayMessage("Incapacitating Roar - Stunning!", "Orange", 1.5)
            healerCCComboState.lastStepTime = currentTime
            local result = IncapacitatingRoar:Cast()
            if result then
                healerCCComboState.step = 3
            end
            return result
        end
        return -- Wait for roar to be ready
    end

    -- Step 3 -> Complete: Cyclone to extend CC
    if healerCCComboState.step == 3 then
        -- Need to shift out of bear form to cast Cyclone
        if player:Buff(buffs.bearform) then
            -- Cancel bear form by shifting to caster
            if CatForm:ReadyToUse() then
                -- Shift to caster form (or just let it naturally drop)
                -- Actually, just wait - the rotation should handle form shifting
            end
            return -- Wait for form shift
        end

        -- Check if Cyclone conditions are met
        if Cyclone:ReadyToUse() and Cyclone:InRange(enemyHealer) then
            if not enemyHealer.ccImmune and not enemyHealer.magicImmune then
                local ccRemains = enemyHealer:CCRemains() or 0
                local cycloneCastTime = Cyclone:CastTime() or 1500
                -- Cast Cyclone if CC will expire during or shortly after cast
                if ccRemains < cycloneCastTime + 1000 then
                    Aware:displayMessage("Cyclone - Combo Finish!", "Purple", 1.5)
                    -- Reset combo state
                    healerCCComboState.active = false
                    healerCCComboState.step = 0
                    healerCCComboState.lastStepTime = 0
                    return Cyclone:Cast(enemyHealer)
                end
            end
        end

        -- If CC has expired and we haven't cycloned, reset
        local ccRemains = enemyHealer:CCRemains() or 0
        if ccRemains <= 0 and currentTime - healerCCComboState.lastStepTime > 2000 then
            healerCCComboState.active = false
            healerCCComboState.step = 0
            Aware:displayMessage("CC Combo Expired", "Red", 1.5)
            return
        end

        -- Still waiting for Cyclone opportunity
        return
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    if not friendly.exists then return end
    if Player:IsStealthed() then return end

    -- Party healing logic goes here
end

--################################################################################################################################################################################################################

A[6] = function(icon)
    -- Skip rotation while stealthed (except Rake which is handled in A[3])
    if Player:IsStealthed() then return end

    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end

	RegisterIcon(icon)
    partyRotation(party1)
	enemyRotation(arena1)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[7] = function(icon)
    -- Skip rotation while stealthed
    if Player:IsStealthed() then return end

	RegisterIcon(icon)
    partyRotation(party2)
	enemyRotation(arena2)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[8] = function(icon)
    -- Skip rotation while stealthed
    if Player:IsStealthed() then return end

	RegisterIcon(icon)
    partyRotation(party3)
	enemyRotation(arena3)

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[9] = function(icon)
    -- Skip rotation while stealthed
    if Player:IsStealthed() then return end

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
