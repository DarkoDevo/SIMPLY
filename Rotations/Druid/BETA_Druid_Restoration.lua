if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

--[[
Patch Notes:
- Added checkbox for innervate friend
- Optamized check order of a few things (no logic changes just lighter checks first)
- Added precasting natures swiftness to normal cooldown convoke
]]--

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
    Lifebloom                               = { ID = 33763, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    LifebloomP                              = { ID = 33763, Texture = 68992, Hidden = true, Macro = "/cast [@player][]spell:thisID" },
    UndergrowthLifebloom                    = { ID = 188550, Hidden = true                                                                  },
    FullBloomLifebloom                      = { ID = 290754, Hidden = true                                                                  },
    Rejuvenation                            = { ID = 774, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    RejuvenationGermimation                 = { ID = 155777                                                                                 },
    WildGrowth                              = { ID = 48438, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Regrowth                                = { ID = 8936, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Swiftmend                               = { ID = 18562, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Efflorescence                           = { ID = 145205, Macro = "/cast [@cursor]spell:thisID" },
    Tranquility                             = { ID = 740                                                                                    },
    Nourish                                 = { ID = 50464                                                                                  },
    Overgrowth                              = { ID = 203651                                                                                 },
    CenarionWard                            = { ID = 102351, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    CenarionWardHealing                     = { ID = 102352                                                                                 },
    ClearCasting                            = { ID = 16870                                                                                  },
    RenewingBloom                           = { ID = 364365                                                                                 },
    Invigorate                              = { ID = 392160                                                                                 },
    Undergrowth                             = { ID = 392301                                                                                 },
    Innervate                               = { ID = 29166, Macro = "/cast [@player]spell:thisID" },
    NaturesSwiftness                        = { ID = 132158                                                                                 },
    Barkskin                                = { ID = 22812                                                                                  },
    Ironbark                                = { ID = 102342, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    EntanglingRoots                         = { ID = 339, MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@mouseover,harm][@target,harm][@focus,harm][]spell:thisID" },
    Cyclone                                 = { ID = 33786, MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    UrsolVortex                             = { ID = 102793                                                                                 },
    Dash                                    = { ID = 1850                                                                                   },
    Hibernate                               = { ID = 2637,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    NaturesCure                             = { ID = 88423, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    Soothe                                  = { ID = 2908, MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Rebirth                                 = { ID = 20484, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Revive                                  = { ID = 50769, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    Revitalize                              = { ID = 212040                                                                                 },
    Prowl                                   = { ID = 5215                                                                                   },
    HeartoftheWild                          = { ID = 319454,    isTalent = true                                                             },
    MightyBash                              = { ID = 5211,      isTalent = true,  MAKULU_INFO = { damageType = "physical" 	               }},
    Typhoon                                 = { ID = 132469,    isTalent = true                                                             },
    MassEntanglement                        = { ID = 102359,    isTalent = true,  MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@mouseover,exists][@target,exists][@focus,exists][]spell:thisID" },
    WildCharge                              = { ID = 102401,    Texture = 58984                                                             },
    Renewal                                 = { ID = 108238,    isTalent = true                                                             },
    Flourish                                = { ID = 197721,    isTalent = true                                                             },
    IncarnationTreeofLife                   = { ID = 33891,     isTalent = true                                                             },
    IncarnationTreeofLifeBuff               = { ID = 117679,    Hidden   = true                                                             },
    SouloftheForest                         = { ID = 158478,    isTalent = true, Hidden = true                                              },
    Photosynthesis                          = { ID = 274902,    isTalent = true, Hidden = true                                              },
    Germination                             = { ID = 155675,    isTalent = true, Hidden = true                                              },
    GuardianAffinity                        = { ID = 197491,    isTalent = true, Hidden = true                                              },
    FeralAffinity                           = { ID = 197490,    isTalent = true, Hidden = true                                              },
    BalanceAffinity                         = { ID = 197632,    isTalent = true, Hidden = true                                              },
    InnerPeace                              = { ID = 197073,    isTalent = true, Hidden = true                                              },
    Abundance                               = { ID = 207383,    isTalent = true, Hidden = true                                              },
    SpringBlossoms                          = { ID = 207385,    isTalent = true, Hidden = true                                              },
    Cultivation                             = { ID = 200390,    isTalent = true, Hidden = true                                              },
    WildSynthesis                           = { ID = 400534,    isTalent = true, Hidden = true                                              },
    TravelForm                              = { ID = 783                                                                                    },
    BearForm                                = { ID = 5487                                                                                   },
    CatForm                                 = { ID = 768                                                                                    },
    MoonkinForm                             = { ID = 24858                                                                                  },
    AquaticForm                             = { ID = 276012                                                                                 },
    Thorns                                  = { ID = 305497, isTalent = true                                                                },
    MarkoftheWild                           = { ID = 1126 , Macro = "/cast [@player]spell:thisID" },
    MasterShapeshifter                      = { ID = 289237, isTalent = true                                                                },
    Disentanglement                         = { ID = 233673, isTalent = true, Hidden = true                                                 },
    EntanglingBark                          = { ID = 247543, isTalent = true, Hidden = true                                                 },
    EarlySpring                             = { ID = 203624, isTalent = true, Hidden = true                                                 },
    FocusedGrowth                           = { ID = 203553, isTalent = true, Hidden = true                                                 },
    DeepRoots                               = { ID = 233755, isTalent = true, Hidden = true                                                 },
    Moonfire                                = { ID = 8921,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    MoonfireDebuff                          = { ID = 164812,  Hidden = true 	                                                            },
    Sunfire                                 = { ID = 93402,   MAKULU_INFO = { damageType = "magical" 	                                   }},
    SunfireDebuff                           = { ID = 164815,  Hidden = true	                                                                },
    Wrath                                   = { ID = 5176,    MAKULU_INFO = { damageType = "magical" 	                                   }},
    Starfire                                = { ID = 197628,  MAKULU_INFO = { damageType = "magical" 	                                   }},
    Starsurge                               = { ID = 197626,  MAKULU_INFO = { damageType = "magical" 	                                   }},
    FrenziedRegeneration                    = { ID = 22842                                                                                  },
    Ironfur                                 = { ID = 192081                                                                                 },
    ThrashCat                               = { ID = 106830,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    ThrashBear                              = { ID = 77758,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    Mangle                                  = { ID = 33917,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    IncapacitatingRoar                      = { ID = 99                                                                                     },
    Shred                                   = { ID = 5221,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    Rip                                     = { ID = 1079,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    FerociousBite                           = { ID = 22568,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    Rake                                    = { ID = 1822,    MAKULU_INFO = { damageType = "physical" 	                                   }},
    --Rake2                                   = { ID = 1822,    Hidden = true, Texture = 291944, MAKULU_INFO = { damageType = "physical" 	   }}, -- Regenratin Icon for Fluid Form
    SwipeCat                                = { ID = 106785,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    SwipeBear                               = { ID = 213771,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    Maim                                    = { ID = 22570,   MAKULU_INFO = { damageType = "physical" 	                                   }},
    RakeDebuff                              = { ID = 155722,  Hidden = true                                                                 },
    DazedDebuff                             = { ID = 50259,   Hidden = true                                                                 },
    RakeStun                                = { ID = 163505,  Hidden = true                                                                 },
    Fluidform                               = { ID = 449193,  Hidden = true                                                                 },
    ConvoketheSpirits                       = { ID = 391528,  FixedTexture = 3636839, MAKULU_INFO = { damageType = "magical" }, Macro = "/cast [@target,help][@focus,help][@target,harm]spell:thisID"},
    AdaptiveSwarm                           = { ID = 391888,  FixedTexture = 3578197, MAKULU_INFO = { damageType = "magical" 	                                   }},
    SkullBash                               = { ID = 106839,  MAKULU_INFO = { damageType = "physical" 	                                   }},
    NaturesVigil                            = { ID = 124974                                                                                 },
    GroveGuardians                          = { ID = 102693                                                                                 },
    VerdantInfusion                         = { ID = 338829                                                                                 },
    StampedingRoar                          = { ID = 106898                                                                                 },
    ImprovedDispelTalent                    = { ID = 392378, Hidden = true                                                                  },
    BloomingInfusionDps                     = { ID = 429474, Hidden = true                                                                  },
    BloomingInfusionHps                     = { ID = 429438, Hidden = true                                                                  },
    
    --11.1
    SymbioticRelationship                   = { ID = 474750, FixedTexture = 133667, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
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
	barkskin        = 22812,
	ironbark        = 102342,
    natureswiftness = 132158,
    incarnation     = 117679,
    innervate       = 29166,
    clearcast       = 16870,
    soulforest      = 114108,
    rejuvenation    = 774,
    germination     = 155777,
    lifebloom       = 33763,
    undergrowth     = 188550,
    fullbloom       = 290754,
    wildgrowth      = 48438,
    regrowth        = 8936,
    cenarionward    = 102352,
    infusionheal    = 429438,
    infusiondmg     = 429474,
    harmonyofgrove  = 428737,
    tranquility     = 157982,
    stampedingroar  = 77764,
    tigerdash       = 252216,
    dash            = 1850,
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
        (unit:BuffRemains(A.WildGrowth.ID, true) > 0 and unit:BuffRemains(A.WildGrowth.ID, true) <= 3000) or
        (unit:BuffRemains(A.Rejuvenation.ID, true) > 0 and unit:BuffRemains(A.Rejuvenation.ID, true) <= 3000) or
        (unit:BuffRemains(A.RejuvenationGermimation.ID, true) > 0 and unit:BuffRemains(A.RejuvenationGermimation.ID, true) <= 3000)
    
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
    if combatTime <= 0 then return end
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
    if not shouldDefensive() or playerHealth > GetToggle(2, "SelfProtection1") then return end
    return spell:Cast()
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
            if not UnitIsUnit(lowestHP:CallerId(), unit:CallerId()) then
                HealingEngine.SetTarget(lowestHP:CallerId(), 1)
            else
                spell:Cast(unit)
            end
        end
    end

    if option == "2" then
        local tank = MakMulti.party:Find(function(friendly) return friendly.isTank end)
        if tank then
            if not UnitIsUnit(tank:CallerId(), unit:CallerId()) then
                HealingEngine.SetTarget(tank:CallerId(), 1)
            else
                spell:Cast(unit)
            end
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
    if combatTime == 0 then return end
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

    local hasLongDurationBuff = unit:BuffRemains(buffs.lifebloom, true) > 3000 or unit:BuffRemains(buffs.undergrowth, true) > 3000 or unit:BuffRemains(buffs.rejuvenation, true) > 3000
    if hasLongDurationBuff then return end

    return spell:Cast(unit)
end)

-- Lifebloom
Lifebloom:Callback('HealingPve', function(spell)
    local maxLifebloomStacks = A.Undergrowth:IsTalentLearned() and 2 or 1
    local currentLifebloomStacks = HealingEngine.GetBuffsCount({A.Lifebloom.ID, A.UndergrowthLifebloom.ID, A.FullBloomLifebloom.ID}, 0, true)
    
    if currentLifebloomStacks >= maxLifebloomStacks then return end

    local hasLongDurationBuff = unit:BuffRemains(buffs.lifebloom, true) > 3000 or unit:BuffRemains(buffs.undergrowth, true) > 3000 or unit:BuffRemains(buffs.fullbloom, true) > 3000
    if hasLongDurationBuff then return end

    local lifeBloomCounts = MakMulti.party:Count(function(friendly) return friendly:BuffRemains(buffs.lifebloom) > 2000 or friendly:BuffRemains(buffs.undergrowth) > 2000 or friendly:BuffRemains(buffs.fullbloom) > 2000 end)
    if lifeBloomCounts >= maxLifebloomStacks then return end

    local isTank = GetToggle(2, "Checkbox1") and Unit("focus"):Role("TANK") or GetToggle(2, "LifrBloomAll")
    if isTank then return spell:Cast(unit) end

    local lifebloomSlider = GetToggle(2, "LifebloomSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.Lifebloom, lifebloomSlider) then return end
    
    return spell:Cast(unit)
end)

-- Lifebloom (Player only)
Lifebloom:Callback('Player', function(spell)
    -- Check if Photosynthesis talent is learned
    if not A.Photosynthesis:IsTalentLearned() then return end
    if target.exists and target.isFriendly then return end

    -- Determine maximum Lifebloom stacks based on Undergrowth talent
    local maxLifebloomStacks = A.Undergrowth:IsTalentLearned() and 2 or 1

    -- Count current Lifebloom buffs on player
    local currentLifebloomStacks = HealingEngine.GetBuffsCount({
        A.Lifebloom.ID, 
        A.UndergrowthLifebloom.ID, 
        A.FullBloomLifebloom.ID
    }, 0, true)
    
    -- Exit if max stacks are reached
    if currentLifebloomStacks >= maxLifebloomStacks then return end

    -- Check for existing Lifebloom buffs with more than 3 seconds remaining
    local hasLongLifebloomBuff = player:BuffRemains(buffs.lifebloom, true) > 3000 or player:BuffRemains(buffs.undergrowth, true) > 3000 or player:BuffRemains(buffs.fullbloom, true) > 3000
    if hasLongLifebloomBuff then return end

    -- Check if Lifebloom should be applied
    local forceLifebloomPlayer = GetToggle(2, "Checkbox2")
    local canUseLifebloom = forceLifebloomPlayer or CanUseAoeHealing() or CanUseHealingCooldowns()
    --if not canUseLifebloom then return end

    if forceLifebloomPlayer then
        HealingEngine.SetTarget("player", 1)
    end

    -- Cast Lifebloom on player
    return Lifebloom:Cast(focus)
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
    if ((GetToggle(2, "AutoSpread") and combatTime > 0 and player.manaPct > GetToggle(2, "AutoSpreadSlider")) or (GetToggle(2, "SpreadHot")) or (GetToggle(2, "ForceSpread"))) then
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
    if ((GetToggle(2, "AutoSpread") and combatTime > 0 and player.manaPct > GetToggle(2, "AutoSpreadSlider")) or (GetToggle(2, "SpreadHot")) or (GetToggle(2, "ForceSpread"))) then
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
    if combatTime > 0 and MakuluFramework.rampMode then
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
    Lifebloom('Player')
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

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= player.combatTime
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
    if combatTime > 0 then
        SelfDefensive()
    end

    BearForm('LeaveForm')
    CatForm('LeaveForm')

    ConvoketheSpirits('LowMana')

    --Soothe Rotation PVE
    if target.exists and target.canAttack then
        Soothe('Dispel')
    end

    --Healing Rotation PVE
    if (target.exists or focus.exists) then
        
        if CanSwiftmend then
            return A.Swiftmend:Show(icon)
        end

        --HealerBurstMode()

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
    if A.GetToggle(2, "AutoInterrupt") and targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end

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
