if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

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

local ActionID = {
	--Racials
    WillToSurvive 				= { ID = 59752 	},
    Stoneform 					= { ID = 20594 	},
    Shadowmeld 					= { ID = 58984 	},
    EscapeArtist 				= { ID = 20589 	},
    GiftOfTheNaaru  			= { ID = 59544 	},
    Darkflight 					= { ID = 68992 	},
    BloodFury 					= { ID = 20572 	},
    WillOfTheForsaken 			= { ID = 7744 	},
    WarStomp 					= { ID = 20549 	},
    Berserking 					= { ID = 26297 	},
    ArcaneTorrent 				= { ID = 50613 	},
    RocketJump 					= { ID = 69070 	},
    RocketBarrage				= { ID = 69041	},
    QuakingPalm 				= { ID = 107079 },
    SpatialRift 				= { ID = 256948 },
    LightsJudgment 				= { ID = 255647 },
    Fireblood 					= { ID = 265221 },
    ArcanePulse 				= { ID = 260364 },
    BullRush 					= { ID = 255654 },
    AncestralCall 				= { ID = 274738 },
    Haymaker 					= { ID = 287712 },
    Regeneratin 				= { ID = 291944 },
    BagofTricks 				= { ID = 312411 },
    HyperOrganicLightOriginator = { ID = 312924 },

    --Misc
	TargetEnemy 				= { ID = 44603  },
	StopCast 					= { ID = 61721  },
	PoolResource 				= { ID = 209274 },
	FocusParty1 				= { ID = 134314 },
	FocusParty2 				= { ID = 134316 },
	FocusParty3 				= { ID = 134318 },
	FocusParty4 				= { ID = 134320 },
	FocusPlayer 				= { ID = 134310 },

	--AntiFakeStuff
	AntiFakeKick                = { Type = "SpellSingleColor", ID = 106839,  Hidden = true,		Color = "GREEN"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC					= { Type = "SpellSingleColor", ID = 5211,  	Hidden = true,		Color = "YELLOW"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	},

    -- Restoration
    Lifebloom                             = { ID = 33763                                                                                  },
    LifebloomP                            = { ID = 33763, Texture = 68992, Hidden = true                                                  },
    UndergrowthLifebloom                  = { ID = 188550, Hidden = true                                                                  },
    FullBloomLifebloom                    = { ID = 290754, Hidden = true                                                                  },
    Rejuvenation                          = { ID = 774                                                                                    },
    RejuvenationGermimation               = { ID = 155777                                                                                 },
    WildGrowth                            = { ID = 48438                                                                                  },
    Regrowth                              = { ID = 8936                                                                                   },
    Swiftmend                             = { ID = 18562                                                                                  },
    Efflorescence                         = { ID = 145205                                                                                 },
    Tranquility                           = { ID = 740                                                                                    },
    Nourish                               = { ID = 50464                                                                                  },
    Overgrowth                            = { ID = 203651                                                                                 },
    CenarionWard                          = { ID = 102351                                                                                 },
    CenarionWardHealing                   = { ID = 102352                                                                                 },
    ClearCasting                          = { ID = 16870                                                                                  },
    RenewingBloom                         = { ID = 364365                                                                                 },
    Invigorate                            = { ID = 392160                                                                                 },
    Undergrowth                           = { ID = 392301                                                                                 },
    
    -- Cooldowns
    Innervate                             = { ID = 29166                                                                                  },
    NaturesSwiftness                      = { ID = 132158                                                                                 },
    Barkskin                              = { ID = 22812                                                                                  },
    Ironbark                              = { ID = 102342                                                                                 },

    -- Utilities
    EntanglingRoots                       = { ID = 339,     MAKULU_INFO = { damageType = "magical" 	                                     }},
    Cyclone                               = { ID = 33786,   MAKULU_INFO = { damageType = "magical" 	                                     }},
    UrsolVortex                           = { ID = 102793                                                                                 },
    Dash                                  = { ID = 1850                                                                                   },
    Hibernate                             = { ID = 2637,    MAKULU_INFO = { damageType = "magical" 	                                     }},
    NaturesCure                           = { ID = 88423                                                                                  },
    Soothe                                = { ID = 2908,    MAKULU_INFO = { damageType = "magical" 	                                     }},
    Rebirth                               = { ID = 20484                                                                                  },
    Revive                                = { ID = 50769                                                                                  },
    Revitalize                            = { ID = 212040                                                                                 },
    Prowl                                 = { ID = 5215                                                                                   },
    
    -- Talents
    HeartoftheWild                        = { ID = 319454,    isTalent = true                                                             },
    MightyBash                            = { ID = 5211,      isTalent = true,  MAKULU_INFO = { damageType = "physical" 	             }},
    Typhoon                               = { ID = 132469,    isTalent = true                                                             },
    MassEntanglement                      = { ID = 102359,    isTalent = true,  MAKULU_INFO = { damageType = "magical" 	                 }},
    WildCharge                            = { ID = 102401,    Texture = 58984                                                             },
    Renewal                               = { ID = 108238,    isTalent = true                                                             },
    Flourish                              = { ID = 197721,    isTalent = true                                                             },
    IncarnationTreeofLife                 = { ID = 33891,     isTalent = true                                                             },
    IncarnationTreeofLifeBuff             = { ID = 117679,    Hidden   = true                                                             },
    SouloftheForest                       = { ID = 158478,    isTalent = true, Hidden = true                                              },
    Photosynthesis                        = { ID = 274902,    isTalent = true, Hidden = true                                              },
    Germination                           = { ID = 155675,    isTalent = true, Hidden = true                                              },
    GuardianAffinity                      = { ID = 197491,    isTalent = true, Hidden = true                                              },
    FeralAffinity                         = { ID = 197490,    isTalent = true, Hidden = true                                              },
    BalanceAffinity                       = { ID = 197632,    isTalent = true, Hidden = true                                              },
    InnerPeace                            = { ID = 197073,    isTalent = true, Hidden = true                                              },
    Abundance                             = { ID = 207383,    isTalent = true, Hidden = true                                              },
    SpringBlossoms                        = { ID = 207385,    isTalent = true, Hidden = true                                              },
    Cultivation                           = { ID = 200390,    isTalent = true, Hidden = true                                              },
    WildSynthesis                         = { ID = 400534,    isTalent = true, Hidden = true                                              },
    
    -- Shapeshift
    TravelForm                            = { ID = 783                                                                                    },
    BearForm                              = { ID = 5487                                                                                   },
    CatForm                               = { ID = 768                                                                                    },
    MoonkinForm                           = { ID = 24858                                                                                  },
    AquaticForm                           = { ID = 276012                                                                                 },

    -- Pvp
    Thorns                                = { ID = 305497, isTalent = true                                                                },
    MarkoftheWild                         = { ID = 1126 },
    MasterShapeshifter                    = { ID = 289237, isTalent = true                                                                },
    Disentanglement                       = { ID = 233673, isTalent = true, Hidden = true                                                 },
    EntanglingBark                        = { ID = 247543, isTalent = true, Hidden = true                                                 },
    EarlySpring                           = { ID = 203624, isTalent = true, Hidden = true                                                 },
    FocusedGrowth                         = { ID = 203553, isTalent = true, Hidden = true                                                 },

    DeepRoots                             = { ID = 233755, isTalent = true, Hidden = true                                                 },
    -- Balance Affinity
    Moonfire                              = { ID = 8921,    MAKULU_INFO = { damageType = "magical" 	                                     }},
    MoonfireDebuff                        = { ID = 164812,  Hidden = true 	                                                              },
    Sunfire                               = { ID = 93402,   MAKULU_INFO = { damageType = "magical" 	                                     }},
    SunfireDebuff                         = { ID = 164815,  Hidden = true	                                                              },
    Wrath                                 = { ID = 5176,    MAKULU_INFO = { damageType = "magical" 	                                     }},
    Starfire                              = { ID = 197628,  MAKULU_INFO = { damageType = "magical" 	                                     }},
    Starsurge                             = { ID = 197626,  MAKULU_INFO = { damageType = "magical" 	                                     }},

    -- Guardian Affinity
    FrenziedRegeneration                  = { ID = 22842                                                                                  },
    Ironfur                               = { ID = 192081                                                                                 },
    ThrashCat                             = { ID = 106830,   MAKULU_INFO = { damageType = "physical" 	                                 }},
    ThrashBear                            = { ID = 77758,    MAKULU_INFO = { damageType = "physical" 	                                 }},
    Mangle                                = { ID = 33917,    MAKULU_INFO = { damageType = "physical" 	                                 }},
    IncapacitatingRoar                    = { ID = 99                                                                                     },

    -- Feral Affinity
    Shred                                 = { ID = 5221,    MAKULU_INFO = { damageType = "physical" 	                                 }},
    Rip                                   = { ID = 1079,    MAKULU_INFO = { damageType = "physical" 	                                 }},
    FerociousBite                         = { ID = 22568,   MAKULU_INFO = { damageType = "physical" 	                                 }},
    Rake                                  = { ID = 1822,    MAKULU_INFO = { damageType = "physical" 	                                 }},
    SwipeCat                              = { ID = 106785,  MAKULU_INFO = { damageType = "physical" 	                                 }},
    SwipeBear                             = { ID = 213771,  MAKULU_INFO = { damageType = "physical" 	                                 }},
    Maim                                  = { ID = 22570,   MAKULU_INFO = { damageType = "physical" 	                                 }},
    RakeDebuff                            = { ID = 155722,  Hidden = true                                                                 },
    DazedDebuff                           = { ID = 50259,   Hidden = true                                                                 },
    RakeStun                              = { ID = 163505,  Hidden = true                                                                 },
    Fluidform                             = { ID = 449193,  Hidden = true                                                                 },
    ConvoketheSpirits                     = { ID = 391528,  MAKULU_INFO = { damageType = "magical" 	                                     }},
    AdaptiveSwarm                         = { ID = 391888,  MAKULU_INFO = { damageType = "magical" 	                                     }},
    SkullBash                             = { ID = 106839,  MAKULU_INFO = { damageType = "physical" 	                                 }},
    NaturesVigil                          = { ID = 124974                                                                                 },
    GroveGuardians                        = { ID = 102693                                                                                 },
    VerdantInfusion                       = { ID = 338829                                                                                 },

    --Improved Dispel
    ImprovedDispelTalent                  = { ID = 392378, Hidden = true                                                                  },
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

Action[ACTION_CONST_DRUID_RESTORATION] = A
TableToLocal(M, getfenv(1))

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local player
local focus
local target
local mouseover
local needDefensive
local unit

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
    tranquility     = 740,
    regrowth        = 8936,
    cenarionward    = 102352,
}

local debuffs = {
    sunfire    = 164815,
    moonfire   = 164812,
    rake       = 155722,
    rip        = 1079,
    thrashcat  = 405233,
    thrashbear = 192090,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function handleInterrupts(enemiesList)
    local _, _, _, lagWorld = GetNetStats()
    local interruptSpells = {
        {spell = A.SkullBash, minPercent = 50, isCC = false},
        {spell = A.MightyBash, minPercent = 50, isCC = true},
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

    if not A.NaturesCure:IsReadyByPassCastGCD(unitID) or Unit(unitID):IsDebuffUp(AvoidDispelTable) then return end

    local shouldDispel = thisUnit.useDispel and not QueueOrder.useDispel[Role] and
        (AuraIsValid(unitID, "UseDispel", "Magic") or Unit(unitID):IsDebuffUp(MagicDispelTable))

    if A.ImprovedDispelTalent:IsTalentLearned() then
        shouldDispel = shouldDispel or
            AuraIsValid(unitID, "UseDispel", "Curse") or Unit(unitID):IsDebuffUp(CurseDispelTable) or
            AuraIsValid(unitID, "UseDispel", "Poison") or Unit(unitID):IsDebuffUp(PoisonDispelTable)
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function TrinketsnRacials()
    if combatTime == 0 then return end

	-- Blood Fury
	if A.BloodFury:IsReady() then return A.BloodFury end

	-- Berserking
	if A.Berserking:IsReady() then return A.Berserking end

	-- Fireblood
	if A.Fireblood:IsReady() then return A.Fireblood end

	-- Ancestral Call
	if A.AncestralCall:IsReady() then return A.AncestralCall end

	-- Bag of Tricks
	if A.BagofTricks:IsReady() then return A.BagofTricks end

	-- LightsJudgment
	if A.LightsJudgment:IsReady() then return A.LightsJudgment end

	if (A.Zone == "arena" or A.Zone == "pvp") then return end

	--Trinket1
	if A.Trinket1:IsReadyByPassCastGCD() then return A.Trinket1 end

	--Trinket2
	if A.Trinket2:IsReadyByPassCastGCD() then return A.Trinket2 end
end

--######################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Rebirth
Rebirth:Callback('Utilities1', function(spell)
    if not isStaying then return end
    if not A.MouseHasFrame() then return end
    if not mouseover:IsPlayer() then return end
    if not Unit("mouseover"):IsDead() then return end
    
    return spell:Cast(mouseover)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Barkskin
Barkskin:Callback('Defensive1', function(spell)
    if playerHealth > GetToggle(2, "SelfProtection1") then return end
    return spell:Cast(player)
end)

-- Renewal
Renewal:Callback('Defensive2', function(spell)
    if playerHealth > GetToggle(2, "SelfProtection2") then return end
    return spell:Cast(player)
end)

-- BearForm
BearForm:Callback('Defensive3', function(spell)
    if Player:IsStance(1) then return end
    if playerHealth > GetToggle(2, "SelfProtection3") then return end
    return spell:Cast(player)
end)

-- FrenziedRegeneration
FrenziedRegeneration:Callback('Defensive4', function(spell)
    if not Player:IsStance(1) then return end
    if playerHealth > 70 then return end
    return spell:Cast(player)
end)

-- Ironfur
Ironfur:Callback('Defensive5', function(spell)
    if not Player:IsStance(1) then return end
    if player:HasBuff(A.Ironfur.ID) then return end
    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- MarkoftheWild
MarkoftheWild:Callback('PreCombat1', function(spell)
    if player:HasBuff(A.MarkoftheWild.ID) then return end
    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--NaturesCure
NaturesCure:Callback('HealingPve', function(spell)
    if A.Zone == "arena" then return end
    if unit:Health() < 35 then return end
    if unit:HasDeBuff(AvoidDispelTable) then return end

    local hasImprovedDispel = A.ImprovedDispelTalent:IsTalentLearned()
    local shouldDispel = AuraIsValid("focus", "UseDispel", "Magic") or unit:HasDeBuff(MagicDispelTable)

    if hasImprovedDispel then
        shouldDispel = shouldDispel or AuraIsValid("focus", "UseDispel", "Curse") or unit:HasDeBuff(CurseDispelTable) or AuraIsValid("focus", "UseDispel", "Poison") or unit:HasDeBuff(PoisonDispelTable)
    end

    if not shouldDispel then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### COOLDOWNS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Ironbark
Ironbark:Callback('Cooldowns', function(spell)
    if not A.Ironbark:IsTalentLearned() then return end
    if unit:Health() > 45 then return end

    return spell:Cast(unit)
end)

local function CantUseCooldowns()
    return player:HasBuffCount(buffs.tranquility, true) ~= 0 or player:HasBuff(buffs.incarnation, true)
end

-- Tranquility
Tranquility:Callback('Cooldowns', function(spell)
    if not A.Tranquility:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if CantUseCooldowns() then return end

    return spell:Cast(player)
end)

-- Incarnation Tree of Life
IncarnationTreeofLife:Callback('Cooldowns', function(spell)
    if not A.IncarnationTreeofLife:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if CantUseCooldowns() then return end

    return spell:Cast(player)
end)

--ConvoketheSpirits
ConvoketheSpirits:Callback('Cooldowns', function(spell)
    if not A.ConvoketheSpirits:IsTalentLearned() then return end
    if not CanUseHealingCooldowns() then return end
    if GetToggle(2, "Checkbox4") and unit:Health() > 35 then return end
    if CantUseCooldowns() then return end

    return spell:Cast(unit)
end)

--Flourish
Flourish:Callback('Cooldowns', function(spell)
    if not A.Flourish:IsTalentLearned() then return end
    if not player:HasBuffCount(buffs.tranquility, true) >= 3 then return end

    return spell:Cast(player)
end)

--Innervate
Innervate:Callback('Cooldowns', function(spell)
    if not A.Innervate:IsTalentLearned() then return end
    if PlayerHaveInnervate then return end
    if Player:ManaPercentage() > 75 then return end
    if not (CanUseAoeHealing() or CanUseHealingCooldowns()) then return end

    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### SOUL OF THE FOREST + NATURES SWIFTNESS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--WildGrowth Soul of the Forest
WildGrowth:Callback('SotF', function(spell)
    local castRemains = Unit("player"):IsCastingRemains(A.WildGrowth.ID)
    if castRemains > 0 then return end
    if A.WildGrowth:GetSpellTimeSinceLastCast() < 1 then return end

    if isMoving then return end
    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:HasBuff(buffs.soulforest, true) then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "WildGrowth" then return end

    if unit:BuffRemains(buffs.wildgrowth, true) > 3000 then return end

    return spell:Cast(player)
end)

--Rejuvenation Soul of the Forest
Rejuvenation:Callback('SotF', function(spell)
    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:HasBuff(buffs.soulforest) then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "Rejuvenation" then return end

    if unit:BuffRemains(buffs.rejuvenation, true) > 3000 then return end

    return spell:Cast(unit)
end)

--Regrowth Soul of the Forest
Regrowth:Callback('SotF', function(spell)
    local castRemains = Unit("player"):IsCastingRemains(A.Regrowth.ID)
    if castRemains > 0 then return end
    if A.Regrowth:GetSpellTimeSinceLastCast() < 1 then return end

    if not A.SouloftheForest:IsTalentLearned() then return end
    if not player:HasBuff(buffs.soulforest, true) then return end

    local canCast = isStaying or PlayerHaveNaturesSwiftness or IncarnationTreeofLifeBuff
    if not canCast then return end

    local toggleOption = GetToggle(2, "SoutFDropdown")
    if toggleOption ~= "Auto" and toggleOption ~= "Regrowth" then return end

    if unit:Health() > 90 then return end

    return spell:Cast(unit)
end)

--NaturesSwiftness
NaturesSwiftness:Callback('HealingPve', function(spell)
    if unit:Health() > 45 then return end

    return spell:Cast(player)
end)

--Own function to decide whetever we want to use Wild Growth first when multiple units are injured
local function SotFHandler()
    if CanUseAoeHealing() then
        WildGrowth('SotF')
        Rejuvenation('SotF')
        Regrowth('SotF')
    else
        Rejuvenation('SotF')
        WildGrowth('SotF')
        Regrowth('SotF')
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD HEALING PVE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Swiftmend 0 with CenarionWard Combo
Swiftmend:Callback('Combo', function(spell)
    if not A.VerdantInfusion:IsTalentLearned() then return end
    if not GetToggle(2, "Checkbox3") then return end
    if not unit:HasBuff(buffs.cenarionward, true) then return end

    local consumableHoTs = {8936, 48438, 774, 155777}
    for _, hotID in ipairs(consumableHoTs) do
        if unit:HasBuff(hotID, true) then
            return spell:Cast(unit)
        end
    end
end)

--Efflorescence
Efflorescence:Callback('HealingPve', function(spell)
    if isMoving then return end
    if A.Efflorescence:GetSpellTimeSinceLastCast() < 30 then return end

    return spell:Cast(player)
end)

--WildGrowth
WildGrowth:Callback('HealingPve', function(spell)
    local castRemains = Unit("player"):IsCastingRemains(A.WildGrowth.ID)
    if castRemains > 0 then return end
    if A.WildGrowth:GetSpellTimeSinceLastCast() < 1 then return end

    if isMoving then return end
    
    if not (CanUseAoeHealing() or CanUseHealingCooldowns() or PlayerHaveInnervate) then return end

    return spell:Cast(player)
end)

--Lifebloom (Player only)
LifebloomP:Callback('Player', function(spell)
    if not A.Photosynthesis:IsTalentLearned() then return end

    local maxBuffCount = A.Undergrowth:IsTalentLearned() and 2 or 1
    local currentBuffCount = HealingEngine.GetBuffsCount({A.Lifebloom.ID, A.UndergrowthLifebloom.ID, A.FullBloomLifebloom.ID}, 0, true)
    
    if currentBuffCount >= maxBuffCount then return end

    if player:BuffRemains(buffs.lifebloom, true) > 3000 or player:BuffRemains(buffs.undergrowth, true) > 3000 or player:BuffRemains(buffs.fullbloom, true) > 3000 then return end

    local forceLifebloomPlayer = GetToggle(2, "Checkbox2")
    
    if not (forceLifebloomPlayer or CanUseAoeHealing() or CanUseHealingCooldowns()) then return end

    return spell:Cast(player)
end)

--Regrowth
Regrowth:Callback('Freecast', function(spell)
    local castRemains = Unit("player"):IsCastingRemains(A.Regrowth.ID)
    if castRemains > 0 then return end
    if A.Regrowth:GetSpellTimeSinceLastCast() < 1 then return end

    if not (isStaying or PlayerHaveNaturesSwiftness) then return end

    if PlayerHaveNaturesSwiftness then
        return spell:Cast(unit)
    end

    if not PlayerHaveClearcast then return end
    if PlayerHaveSouloftheForest then return end
    if IncarnationTreeofLifeBuff then return end
    if PlayerHaveInnervate then return end

    local regrowthSlider = GetToggle(2, "FreecastSlider")
    if not AutoHealOrSlider(unit, A.Regrowth, regrowthSlider) then return end

    return spell:Cast(unit)
end)

--Overgrowth
Overgrowth:Callback('HealingPve', function(spell)
    if not A.Overgrowth:IsTalentLearned() then return end
    
    local overgrowthHealth = 65
    if unit:Health() > overgrowthHealth then return end

    if unit:BuffRemains(buffs.lifebloom, true) > 3000 or unit:BuffRemains(buffs.undergrowth, true) > 3000 or unit:BuffRemains(buffs.rejuvenation, true) > 3000 then return end

    return spell:Cast(unit)
end)

--Lifebloom
Lifebloom:Callback('HealingPve', function(spell)
    local maxBuffCount = A.Undergrowth:IsTalentLearned() and 2 or 1
    local currentBuffCount = HealingEngine.GetBuffsCount({A.Lifebloom.ID, A.UndergrowthLifebloom.ID, A.FullBloomLifebloom.ID}, 0, true)
    
    if currentBuffCount >= maxBuffCount then return end

    if unit:BuffRemains(buffs.lifebloom, true) > 3000 or unit:BuffRemains(buffs.undergrowth, true) > 3000 or unit:BuffRemains(buffs.fullbloom, true) > 3000 then return end

    local isTank = GetToggle(2, "Checkbox1") and Unit("focus"):Role("TANK")
    if isTank then
        return spell:Cast(unit)
    end

    local lifebloomSlider = GetToggle(2, "LifebloomSlider")
    if not AutoHealOrSlider(unit, A.Lifebloom, lifebloomSlider) then return end
    
    return spell:Cast(unit)
end)

--CenarionWard
CenarionWard:Callback('HealingPve', function(spell)
    local cenarionwardSlider = GetToggle(2, "CenarionWardSlider")
    if not AutoHealOrSlider(unit, A.CenarionWard, cenarionwardSlider) then return end

    if not (Unit("focus"):GetRealTimeDMG() > 0 or unit:IsDummy()) then return end

    local isTank = Unit("focus"):Role("TANK")
    local applytoeveryone = GetToggle(2, "Checkbox5")

    if not (isTank or applytoeveryone) then return end

    return spell:Cast(unit)
end)

--Swiftmend 1 Agressive Hot Consuming
Swiftmend:Callback('Agressive', function(spell)
    if GetToggle(2, "SwiftmendDropdown") == "1" then return end
    local swiftmendSlider = GetToggle(2, "Swiftmend")
    if not AutoHealOrSlider(unit, A.Swiftmend, swiftmendSlider) then return end

    local consumableHoTs = {8936, 48438, 774, 155777}
    for _, hotID in ipairs(consumableHoTs) do
        if unit:HasBuff(hotID, true) then
            return spell:Cast(unit)
        end
    end
end)

local function CheckForExpiringHots(unit)
    local hotBuffs = {buffs.regrowth, buffs.wildgrowth, buffs.rejuvenation, buffs.germination}
    
    for _, buffID in ipairs(hotBuffs) do
        local duration = unit:BuffRemains(buffID, true)
        if duration > 0 then
            if buffID == buffs.regrowth then
                return true
            elseif duration < 4000 then
                return true
            end
        end
    end
    
    return false
end

--Swiftmend für auslaufende HoTs
Swiftmend:Callback('ExpiringHots', function(spell)
    if GetToggle(2, "SwiftmendDropdown") == "2" then return end
    
    local swiftmendSlider = GetToggle(2, "Swiftmend")
    if not AutoHealOrSlider(unit, A.Swiftmend, swiftmendSlider) then return end
    
    if not CheckForExpiringHots(unit) then return end
    
    return spell:Cast(unit)
end)

--GroveGuardians
GroveGuardians:Callback('HealingPve', function(spell)
    if not A.GroveGuardians:IsTalentLearned() then return end
    if A.GroveGuardians:GetSpellTimeSinceLastCast() < 15 then return end

    local charges = A.GroveGuardians:GetSpellCharges()
    if charges == 0 then return end

    local healthThreshold = charges == 3 and 85 or (charges == 2 and 65 or 45)
    if unit:Health() > healthThreshold then return end

    return spell:Cast(unit)
end)

local function shouldCastRejuvenation(unit, spell, buffType)
    if unit:BuffRemains(buffType) > 3000 then return end

    local isTank = GetToggle(2, "Checkbox1") and Unit("focus"):Role("TANK")
    if isTank or PlayerHaveInnervate then
        return true
    end

    local rejuvenationSlider = GetToggle(2, "RejuvenationSlider")
    if not AutoHealOrSlider(unit, spell, rejuvenationSlider) then return end

    return true
end

-- Germination
Rejuvenation:Callback('Germination', function(spell)
    if not A.Germination:IsTalentLearned() then return end

    if GetToggle(2, "SpreadHot") then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.Rejuvenation:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.RejuvenationGermimation.ID, true) then
                HealingEngine.SetTarget(unitID)
                spell:Cast(unit)
            end
        end
    end

    if not shouldCastRejuvenation(unit, A.Rejuvenation, buffs.germination) then return end

    spell:Cast(unit)
end)

-- Rejuvenation
Rejuvenation:Callback('HealingPve', function(spell)
    if GetToggle(2, "SpreadHot") then
        for i = 1, #getmembersAll do
            local unitID = getmembersAll[i].Unit

            if A.Rejuvenation:IsReadyByPassCastGCD(unitID) and Unit(unitID):IsBuffDown(A.Rejuvenation.ID, true) then
                HealingEngine.SetTarget(unitID)
                spell:Cast(unit)
            end
        end
    end

    if not shouldCastRejuvenation(unit, A.Rejuvenation, buffs.rejuvenation) then return end

    spell:Cast(unit)
end)

--Invigorate
Invigorate:Callback('HealingPve', function(spell)
    if not A.Invigorate:IsTalentLearned() then return end
    
    local healthThreshold = 75
    if unit:Health() > healthThreshold then return end

    return spell:Cast(unit)
end)

--Nourish
Nourish:Callback('HealingPve', function(spell)
    if not A.Nourish:IsTalentLearned() then return end
    if not isStaying then return end

    local nourishSlider = GetToggle(2, "NourishSlider")
    if not AutoHealOrSlider(unit, A.Nourish, nourishSlider) then return end

    return spell:Cast(unit)
end)

--Regrowth
Regrowth:Callback('HealingPve', function(spell)
    if not (isStaying or PlayerHaveNaturesSwiftness or IncarnationTreeofLifeBuff) then return end

    local regrowthSlider = GetToggle(2, "RegrowthSlider")
    if not AutoHealOrSlider(unit, A.Regrowth, regrowthSlider) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STEALTH ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Rake:Callback('Stealth', function(spell)
    if not Player:IsStance(2) then return end
    
    local rakeDebuffRemains = target:DebuffRemains(debuffs.rake, true)
    if rakeDebuffRemains > 3000 then return end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEBUFF ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Sunfire
Sunfire:Callback('DamagePve', function(spell)
    local manaThreshold = GetToggle(2, "ManaTresholdDpsSlider")
    if Player:ManaPercentage() <= manaThreshold then return end

    local sunfireRemains = target:DebuffRemains(debuffs.sunfire, true)
    if sunfireRemains > 3000 then return end

    return spell:Cast(target)
end)

-- Moonfire
Moonfire:Callback('DamagePve', function(spell)
    local manaThreshold = GetToggle(2, "ManaTresholdDpsSlider")
    if Player:ManaPercentage() <= manaThreshold then return end

    local moonfireRemains = target:DebuffRemains(debuffs.moonfire, true)
    if moonfireRemains > 3000 then return end

    return spell:Cast(target)
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BOSS ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanUseBossAbility()
    if combatTime <= 0 then return false end
    if not Unit("target"):IsBoss() then return false end
    return true
end

-- HeartoftheWild
HeartoftheWild:Callback('DamageBossPve', function(spell)
    if not CanUseBossAbility() then return end
    return spell:Cast(player)
end)

-- NaturesVigil
NaturesVigil:Callback('DamageBossPve', function(spell)
    if not CanUseBossAbility() then return end
    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### CAT ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanUseCatAbility()
    return Player:IsStance(2)
end

local function CanUseAoEAbility()
    return inMeleeRange and MultiUnits:GetBySpell(A.Shred) > 1
end

-- CatForm
CatForm:Callback('DamagePve', function(spell)
    if target:DebuffRemains(debuffs.sunfire, true) <= 4000 then return end
    if target:DebuffRemains(debuffs.moonfire, true) <= 4000 then return end
    if not GetToggle(2, "Checkbox6") then return end
    if MultiUnits:GetBySpell(A.Shred) < 1 then return end
    if not Player:IsStance(0) then return end

    return spell:Cast(player)
end)

-- Thrash Cat AOE
ThrashCat:Callback('AoeDebuff', function(spell)
    if not CanUseCatAbility() then return end
    if not CanUseAoEAbility() then return end
    if target:DebuffRemains(debuffs.thrashcat, true) > 3000 then return end

    return spell:Cast(player)
end)

-- FerociousBite
FerociousBite:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if Player:ComboPoints() ~= 5 then return end

    return spell:Cast(target)
end)

-- Rake
Rake:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if target:DebuffRemains(debuffs.rake, true) > 3000 then return end

    return spell:Cast(target)
end)

-- Rip
Rip:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if target:DebuffRemains(debuffs.rip, true) > 3000 then return end

    return spell:Cast(target)
end)

-- Thrash Cat
ThrashCat:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if not inMeleeRange then return end
    if target:DebuffRemains(debuffs.thrashcat, true) > 3000 then return end

    return spell:Cast(player)
end)

-- Swipe Cat
SwipeCat:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if Player:Energy() < 40 then return end
    if not CanUseAoEAbility() then return end

    return spell:Cast(player)
end)

-- Shred
Shred:Callback('DamagePve', function(spell)
    if not CanUseCatAbility() then return end
    if Player:Energy() < 40 then return end
    if MultiUnits:GetBySpell(A.Shred) ~= 1 then return end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BEAR ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanUseBearAbility()
    return Player:IsStance(1)
end

local function HasEnoughEnergy()
    return Player:Energy() >= 40
end

-- Thrash Bear
ThrashBear:Callback('DamagePve', function(spell)
    if not CanUseBearAbility() then return end
    if not inMeleeRange then return end
    return spell:Cast(player)
end)

-- Swipe Bear
SwipeBear:Callback('DamagePve', function(spell)
    if not HasEnoughEnergy() then return end
    if not CanUseBearAbility() then return end
    if not inMeleeRange then return end
    if MultiUnits:GetBySpell(A.Shred) <= 1 then return end
    return spell:Cast(player)
end)

-- Mangle
Mangle:Callback('DamagePve', function(spell)
    if not HasEnoughEnergy() then return end
    if not CanUseBearAbility() then return end
    if MultiUnits:GetBySpell(A.Shred) ~= 1 then return end
    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanUseBalanceAbility()
    if GetToggle(2, "Checkbox6") and MultiUnits:GetBySpell(A.Shred) >= 1 then return false end
    if Player:ManaPercentage() <= GetToggle(2, "ManaTresholdDpsSlider") then return false end
    if not Player:IsStance(0) then return false end
    return true
end

-- Starsurge
Starsurge:Callback('DamagePve', function(spell)
    if not CanUseBalanceAbility() then return end
    return spell:Cast(target)
end)

-- Starfire
Starfire:Callback('DamagePve', function(spell)
    if not CanUseBalanceAbility() then return end
    if not isStaying then return end
    if MultiUnits:GetBySpell(A.Starfire) <= 1 then return end
    return spell:Cast(target)
end)

-- Wrath
Wrath:Callback('DamagePve', function(spell)
    if not CanUseBalanceAbility() then return end
    if not isStaying then return end
    return spell:Cast(target)
end)

--################################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function Untilities()
    Rebirth('Utilities1')
end

local function PreCombat()
    MarkoftheWild('PreCombat1')
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

local function HealerRotationPve()
    if target.exists and target.isFriendly then
        unit = target
    elseif focus.exists and focus.isFriendly then
        unit = focus
    else
        return
    end

    --Skip Action when all Members are above 65% Health
    if not Player:IsStance(0) and unit:Health() > GetToggle(2, "EmergencySlider") then return end

    NaturesCure('HealingPve')
    Ironbark('Cooldowns')
    Tranquility('Cooldowns')
    IncarnationTreeofLife('Cooldowns')
    ConvoketheSpirits('Cooldowns')
    Flourish('Cooldowns')
    Innervate('Cooldowns')
    Swiftmend('Combo')
    Efflorescence('HealingPve')
    SotFHandler()
    NaturesSwiftness('HealingPve')
    WildGrowth('HealingPve')
    LifebloomP('Player')
    Regrowth('Freecast')
    Overgrowth('HealingPve')
    Lifebloom('HealingPve')
    CenarionWard('HealingPve')
    Swiftmend('Agressive')
    Swiftmend('ExpiringHots')
    GroveGuardians('HealingPve')
    Rejuvenation('Germination')
    Rejuvenation('HealingPve')
    Invigorate('HealingPve')
    Nourish('HealingPve')
    Regrowth('HealingPve')
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
        CatForm('DamagePve')
        ThrashCat('AoeDebuff')
        FerociousBite('DamagePve')
        Rake('DamagePve')
        Rip('DamagePve')
        ThrashCat('DamagePve')
        SwipeCat('DamagePve')
        Shred('DamagePve')
        ThrashBear('DamagePve')
        SwipeBear('DamagePve')
        Mangle('DamagePve')
        Starsurge('DamagePve')
        Starfire('DamagePve')
        Wrath('DamagePve')
    end
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

	player 		    = MakUnit:new("player")
    focus 		    = MakUnit:new("focus")
	target 		    = MakUnit:new("target")
	mouseover 	    = MakUnit:new("mouseover")

	isStaying   	= Player:IsStaying()
	movingTime  	= Player:IsMovingTime()
	stayingTime		= Player:IsStayingTime()
	isMoving 		= player:IsMoving()
	combatTime  	= player:CombatTime()
	playerHealth	= player:Health()
	inMeleeRange	= Unit("target"):GetRange() <= 5

    -- Buffs
    PlayerHaveNaturesSwiftness  = player:HasBuff(buffs.natureswiftness, true)
    PlayerHaveInnervate         = player:HasBuff(buffs.innervate, true)
    IncarnationTreeofLifeBuff   = player:HasBuff(buffs.incarnation, true)
    PlayerHaveClearcast         = player:HasBuff(buffs.clearcast, true)
    PlayerHaveSouloftheForest   = player:HasBuff(buffs.soulforest, true)

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
    if GetToggle(2, "MultiDot") and not Unit("target"):IsBoss() and Unit("target"):HasDeBuffs(A.MoonfireDebuff.ID, true) > 0 and (Player:GetDeBuffsUnitCount(A.MoonfireDebuff.ID, true) < MultiUnits:GetActiveEnemies()) then
        return A.TargetEnemy:Show(icon)
    end

	RegisterIcon(icon)
	partyRotation(MakUnit:new("party1"))
	enemyRotation(MakUnit:new("arena1"))
	
	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[7] = function(icon)
	RegisterIcon(icon)
	partyRotation(MakUnit:new("party2"))
	enemyRotation(MakUnit:new("arena2"))

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	RegisterIcon(icon)
	partyRotation(MakUnit:new("party3"))
	enemyRotation(MakUnit:new("arena3"))

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[9] = function(icon)
	RegisterIcon(icon)
	partyRotation(MakUnit:new("party4"))
	enemyRotation(MakUnit:new("arena4"))

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[10] = function(icon)
	RegisterIcon(icon)
	partyRotation(MakUnit:new("player"))
	enemyRotation(MakUnit:new("arena5"))

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
