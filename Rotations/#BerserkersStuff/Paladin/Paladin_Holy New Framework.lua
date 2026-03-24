if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 65 then return end

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
	AntiFakeKick                            = { Type = "SpellSingleColor", ID = 96231,  Hidden = true,		Color = "GREEN"	    , Desc = "[2] AntiFakeKick",    QueueForbidden = true	},
	AntiFakeCC					            = { Type = "SpellSingleColor", ID = 853,  	Hidden = true,		Color = "YELLOW"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	},
    -- Holy
	CrusaderStrike                        	= { ID = 35395 		},
	ShieldoftheRighteous                  	= { ID = 53600		},
	FlashofLight                          	= { ID = 19750		},
	HammerofJustice                       	= { ID = 853      	},
    Consecration                          	= { ID = 26573     	},
	ConsecrationDebuff                    	= { ID = 204242    	},
	WordofGlory                           	= { ID = 85673, Texture = 291944 }, --Regeneratin
	HandofReckoning                       	= { ID = 62124    	},
	SenseUndead                       	  	= { ID = 5502    	},
	Redemption                            	= { ID = 7328      	},
	Intercession                          	= { ID = 391054    	},
	LayOnHands                            	= { ID = 633		},
	BlessingofFreedom                     	= { ID = 1044      	},
	HammerofWrath                         	= { ID = 24275    	},
    CrusaderAura                          	= { ID = 32223     	},
    DevotionAura                    	  	= { ID = 465       	},
    ConcentrationAura                     	= { ID = 317920    	},
    RetributionAura                       	= { ID = 183435    	},
	DivineSteed                           	= { ID = 190784   	},
	AvengingWrath                    	  	= { ID = 31884  	},
	Rebuke                    	  		  	= { ID = 96231 		},
    TurnEvil                              	= { ID = 10326   	},
    Forbearance                           	= { ID = 25771    	},
    BlessingofProtection                  	= { ID = 1022      	},
    BlessingofSacrifice                   	= { ID = 6940      	},
	HolyAvenger                           	= { ID = 105809    	},
	Seraphim                              	= { ID = 152262    	},
	DivinePurpose                     	  	= { ID = 223819		},
	DivineShield                          	= { ID = 642       	},
    Repentance					          	= { ID = 20066     	},
	Denounce							  	= { ID = 2812		},
	BlindingLight						  	= { ID = 115750    	},
	AuraMastery                           	= { ID = 31821    	},
	AvengingCrusader                      	= { ID = 216331    	},
	BarrierofFaith                        	= { ID = 148039    	},
	BeaconofFaith                         	= { ID = 156910    	},
	BeaconofVirtue                        	= { ID = 200025    	},
	BestowFaith                           	= { ID = 223306		},
	BlessingofSpring                      	= { ID = 388013, Texture = 20549 }, --Warstomp
	BlessingofSummer                      	= { ID = 388007, Texture = 20549 }, --Warstomp
	BlessingofAutumn                     	= { ID = 388010, Texture = 20549 }, --Warstomp
	BlessingofWinter                      	= { ID = 388011, Texture = 20549 }, --Warstomp
	DivineToll                            	= { ID = 375576 	},
	HolyPrism                             	= { ID = 114165		},
	Judgment                              	= { ID = 275773   	},
	LightsHammer                          	= { ID = 114158    	},
	RuleofLaw                             	= { ID = 214202    	},
	TyrDeliverance                        	= { ID = 200652    	},
	Cleanse                               	= { ID = 4987     	},
	HolyShock                             	= { ID = 20473		},
    EternalFlame                            = { ID = 156322, Texture = 291944 }, --WOG
	HolyShockDMG                          	= { ID = 20473, Texture = 10326, Hidden = true}, --Turn Evil
	HolyLight                             	= { ID = 82326, Texture = 59542},
	BeaconofLight                         	= { ID = 53563    	},
	InfusionofLight                   	  	= { ID = 54149		}, 
	DivineProtection                      	= { ID = 498      	},
	LightofMartyr                         	= { ID = 183998		},
	LightofDawn                           	= { ID = 85222		},
	Absolution                            	= { ID = 212056   	},
	MaraadBuff 							  	= { ID = 388019 	},
	EmpyreanLegacy 						  	= { ID = 387178 	},
	HandofDivinity 						  	= { ID = 414273 	},
	TyrDeliveranceBuff                    	= { ID = 200654, Hidden = true    	},
	AurasoftheResolute                    	= { ID = 385633, Hidden = true    	},
	AurasofSwiftVengeance                 	= { ID = 385639, Hidden = true    	},
	ShiningRighteousness                  	= { ID = 414445, Hidden = true    	},
	ImprovedDispelTalent                  	= { ID = 393024, Hidden = true  	},
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

Action[ACTION_CONST_PALADIN_HOLY] = A
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
	divineshield = 642,
	infusionoflight = 54149,
	divinity = 414273,
	auramastery = 31821,
	avengingwrath = 31884,
	avengingcrusader = 216331,
    beaconoflight = 53563,
    beaconoffaith = 156910,
}

local debuffs = {
	forbearance = 25771,
	consecration = 204242,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function handleInterrupts(enemiesList)
    local _, _, _, lagWorld = GetNetStats()
    local interruptSpells = {
        {spell = A.Rebuke, minPercent = 50, isCC = false},
        --{spell = A.HammerofJustice, minPercent = 50, isCC = true},
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

    if not A.Cleanse:IsReadyByPassCastGCD(unitID) or Unit(unitID):IsDebuffUp(AvoidDispelTable) then return end

    local shouldDispel = thisUnit.useDispel and not QueueOrder.useDispel[Role] and
        (AuraIsValid(unitID, "UseDispel", "Magic") or Unit(unitID):IsDebuffUp(MagicDispelTable))

    if A.ImprovedDispelTalent:IsTalentLearned() then
        shouldDispel = shouldDispel or
            AuraIsValid(unitID, "UseDispel", "Disease") or Unit(unitID):IsDebuffUp(DiseaseDispelTable) or
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

--######################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Intercession
Intercession:Callback('Utilities1', function(spell)
    if not isStaying then return end
    if not A.MouseHasFrame() then return end
    if not mouseover:IsPlayer() then return end
    if not Unit("mouseover"):IsDead() then return end
    
    return spell:Cast(mouseover)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DivineShield
DivineShield:Callback('Defensive1', function(spell)
	if player:HasDeBuff(debuffs.forbearance) then return end
    if playerHealth > GetToggle(2, "SelfProtection2") then return end
    return spell:Cast(player)
end)

-- DivineProtection
DivineProtection:Callback('Defensive1', function(spell)
	if player:HasDeBuff(buffs.divineshield) then return end
    if playerHealth > GetToggle(2, "SelfProtection1") then return end
    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CrusaderAura
CrusaderAura:Callback('PreCombat', function(spell)
    if A.Zone == "arena" then return end
    if not Player:IsMounted() then return end
    if not A.AurasofSwiftVengeance:IsTalentLearned() then return end
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

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--NaturesCure
Cleanse:Callback('Dispel', function(spell)
    if A.Zone == "arena" then return end
    if unit:Health() < 35 then return end
    if unit:HasDeBuff(AvoidDispelTable) then return end

    local hasImprovedDispel = A.ImprovedDispelTalent:IsTalentLearned()
    local shouldDispel = AuraIsValid("focus", "UseDispel", "Magic") or unit:HasDeBuff(MagicDispelTable)

    if hasImprovedDispel then
        shouldDispel = shouldDispel or AuraIsValid("focus", "UseDispel", "Disease") or unit:HasDeBuff(DiseaseDispelTable) or AuraIsValid("focus", "UseDispel", "Poison") or unit:HasDeBuff(PoisonDispelTable)
    end

    if not shouldDispel then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### COOLDOWNS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CantUseLoHBoP()
    return unit:HasDeBuff(debuffs.forbearance) or combatTime == 0
end

-- LayOnHands
LayOnHands:Callback('Cooldowns', function(spell)
    if CantUseLoHBoP() then return end
    if unit:Health() > 25 then return end

    return spell:Cast(unit)
end)

-- BlessingofProtection
BlessingofProtection:Callback('Cooldowns', function(spell)
    if CantUseLoHBoP() then return end
    if unit:Health() > 45 then return end
    --if Unit("focus"):ThreatSituation() < 2 then return end
    if Unit("focus"):Role("TANK") then return end

    return spell:Cast(unit)
end)

-- BlessingofSacrifice
BlessingofSacrifice:Callback('Cooldowns', function(spell)
    if combatTime == 0 then return end
    if UnitIsUnit("focus", "player") then return end
    if unit:Health() > 65 then return end
    if player:Health() < 45 then return end

    return spell:Cast(unit)
end)

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

local function MajorCooldownIsActive()
    return player:HasBuff(buffs.avengingwrath) or player:HasBuff(buffs.avengingcrusader) or player:HasBuff(buffs.auramastery)
end

-- AvengingWrath
AvengingWrath:Callback('Cooldowns', function(spell)
    if MajorCooldownIsActive() then return end
    if not CanUseHealingCooldowns() then return end

    return spell:Cast(player)
end)

-- AuraMastery
AuraMastery:Callback('Cooldowns', function(spell)
    if MajorCooldownIsActive() then return end
    if not CanUseHealingCooldowns() then return end

    return spell:Cast(player)
end)

-- TyrDeliverance
TyrDeliverance:Callback('Cooldowns', function(spell)
    if isMoving then return end
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

-- DivineToll
DivineToll:Callback('Cooldowns', function(spell)
    if HolyPower >= 2 then return end
    if not (CanUseHealingCooldowns() or CanUseAoeHealing()) then return end

    return spell:Cast(unit)
end)

-- HandofDivinity
HandofDivinity:Callback('Cooldowns', function(spell)
    if isMoving then return end
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BLESSINGS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BlessingofSpring
BlessingofSpring:Callback('Blessing', function(spell)
    if combatTime == 0 then return end

    for i = 1, #getmembersAll do
        local unitID = getmembersAll[i].Unit
        if Unit(unitID):HealthPercent() <= 65 then
            HealingEngine.SetTarget(unitID)
            return spell:Cast(unit)
        end
    end

    return spell:Cast(unit)
end)

-- BlessingofSummer
BlessingofSummer:Callback('Blessing', function(spell)
    if combatTime == 0 then return end

    for i = 1, #getmembersAll do
        local unitID = getmembersAll[i].Unit
        if Unit(unitID):IsBuffUp(PiTable) and Unit(unitID):Role("DAMAGER") then
            HealingEngine.SetTarget(unitID)
            return spell:Cast(unit)
        end
    end
end)

-- BlessingofAutumn
BlessingofAutumn:Callback('Blessing', function(spell)
    if combatTime == 0 then return end

    for i = 1, #getmembersAll do
        local unitID = getmembersAll[i].Unit
        if Unit(unitID):IsBuffUp(PiTable) and Unit(unitID):Role("DAMAGER") then
            HealingEngine.SetTarget(unitID)
            return spell:Cast(unit)
        end
    end
end)

-- BlessingofWinter
BlessingofWinter:Callback('Blessing', function(spell)
    if combatTime == 0 then return end
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD HEALING PVE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BeaconofVirtue
BeaconofVirtue:Callback('Beacon', function(spell)
    if not A.BeaconofVirtue:IsTalentLearned() then return end
    if not CanUseAoeHealing() then return end

    return spell:Cast(player)
end)

-- BeaconofLight
BeaconofLight:Callback('Beacon', function(spell)
    if A.BeaconofVirtue:IsTalentLearned() then return end
    if HealingEngine.GetBuffsCount(A.BeaconofLight.ID) ~= 0 then return end
    if unit:HasBuff(buffs.beaconoflight) or unit:HasBuff(buffs.beaconoffaith) then return end
    if not Unit("focus"):Role("TANK") then return end

    return spell:Cast(unit)
end)

-- BeaconofFaith (Focus Target)
BeaconofFaith:Callback('Beacon', function(spell)
    if A.BeaconofVirtue:IsTalentLearned() then return end
    if not A.BeaconofFaith:IsTalentLearned() then return end
    if HealingEngine.GetBuffsCount(A.BeaconofFaith.ID) ~= 0 then return end
    if unit:HasBuff(buffs.beaconoflight) or unit:HasBuff(buffs.beaconoffaith) then return end
    if not Unit("focus"):Role("TANK") then return end

    return spell:Cast(unit)
end)

-- BeaconofFaith (Player)
BeaconofFaith:Callback('Player', function(spell)
    if A.BeaconofVirtue:IsTalentLearned() then return end
    if not A.BeaconofFaith:IsTalentLearned() then return end
    if not GetToggle(2, "Checkbox1") then return end
    if HealingEngine.GetBuffsCount(A.BeaconofFaith.ID) ~= 0 then return end
    if player:HasBuff(buffs.beaconoflight) or player:HasBuff(buffs.beaconoffaith) then return end

    HealingEngine.SetTarget("player")
    return spell:Cast(player)
end)

-- LightofDawn
LightofDawn:Callback('HealingPve', function(spell)
    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Off" then return end

    if lightofdawnmenu == "Auto" then
        if not (CanUseAoeHealing() or CanUseHealingCooldowns()) then return end
    elseif lightofdawnmenu == "Always" then
        if HolyPower < 5 and not (CanUseAoeHealing() or CanUseHealingCooldowns()) then return end
    end
    
    return spell:Cast(player)
end)

-- EternalFlame
EternalFlame:Callback('HealingPve', function(spell)
    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Always" then return end

    local wordofglorySlider = GetToggle(2, "WOGSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end

    return spell:Cast(unit)
end)

-- WordofGlory
WordofGlory:Callback('HealingPve', function(spell)
    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Always" then return end

    local wordofglorySlider = GetToggle(2, "WOGSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end

    return spell:Cast(unit)
end)

-- HolyLight + Hand of Divinity Buff
HolyLight:Callback('Divinity', function(spell)
    if not player:HasBuff(buffs.divinity) then return end
    if not AutoHeal(unit:CallerId(), A.HolyLight) then return end

    return spell:Cast(unit)
end)

-- BarrierofFaith
BarrierofFaith:Callback('HealingPve', function(spell)
    if not AutoHeal(unit:CallerId(), A.BarrierofFaith) then return end

    return spell:Cast(unit)
end)

-- HolyShock
HolyShock:Callback('HealingPve', function(spell)
    local holyshockSlider = GetToggle(2, "HolyShockSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.HolyShock, holyshockSlider) then return end

    return spell:Cast(unit)
end)

-- HolyPrism
HolyPrism:Callback('HealingPve', function(spell)
    if not AutoHeal(unit:CallerId(), A.HolyPrism) then return end

    return spell:Cast(unit)
end)

-- Hilfsfunktion für Infusion of Light Logik
local function HandleInfusionOfLight(spell, spellName, isForced)
    local infusionoflightmenu = GetToggle(2, "Dropdown5")
    if infusionoflightmenu ~= spellName then return end
    if isMoving then return end

    local castRemainsFlashofLight = Unit("player"):IsCastingRemains(A.FlashofLight.ID)
    local castRemainsHolyLight = Unit("player"):IsCastingRemains(A.HolyLight.ID)
    local lastCastwasFlashofLight = A.FlashofLight:GetSpellTimeSinceLastCast() < 1
    local lastCastwasHolyLight = A.HolyLight:GetSpellTimeSinceLastCast() < 1

    if spellName == "FlashofLight" then
        if castRemainsFlashofLight > 0 or lastCastwasFlashofLight then return end
    elseif spellName == "HolyLight" then
        if castRemainsHolyLight > 0 or lastCastwasHolyLight then return end
    end

    local buffRemains = player:BuffRemains(buffs.infusionoflight)
    local castTime = spell:CastTime()
    if buffRemains < castTime then return end

    local infusionSlider = GetToggle(2, "InfusionSlider")
    if not infusionSlider then return end
    if not AutoHealOrSlider(unit:CallerId(), spell, infusionSlider) then return end

    return spell:Cast(unit)
end

-- Force FlashofLight + InfusionofLight
FlashofLight:Callback('ForceInfusionofLight', function(spell)
    local forceearlyconsume = GetToggle(2, "Checkbox3")
    if not forceearlyconsume then return end
    return HandleInfusionOfLight(spell, "FlashofLight", true)
end)

-- Force HolyLight + InfusionofLight
HolyLight:Callback('ForceInfusionofLight', function(spell)
    local forceearlyconsume = GetToggle(2, "Checkbox3")
    if not forceearlyconsume then return end
    return HandleInfusionOfLight(spell, "HolyLight", true)
end)

-- FlashofLight + InfusionofLight
FlashofLight:Callback('InfusionofLight', function(spell)
    return HandleInfusionOfLight(spell, "FlashofLight", false)
end)

-- HolyLight + InfusionofLight
HolyLight:Callback('InfusionofLight', function(spell)
    return HandleInfusionOfLight(spell, "HolyLight", false)
end)

-- FlashofLight Normal
FlashofLight:Callback('HealingPve', function(spell)
    if isMoving then return end

    local flashoflightSlider = GetToggle(2, "FlashofLightSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.FlashofLight, flashoflightSlider) then return end

    return spell:Cast(unit)
end)

-- HolyLight Normal
HolyLight:Callback('HealingPve', function(spell)
    if isMoving then return end

    local holylightSlider = GetToggle(2, "HolyLightSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.HolyLight, holylightSlider) then return end

    return spell:Cast(unit)
end)

-- Out of combat Healing
HolyLight:Callback('OutofCombat', function(spell)
    if not GetToggle(2, "OOCHeal") then return end
    if combatTime > 0 then return end
    if isMoving then return end

    if not AutoHeal(unit:CallerId(), A.HolyLight) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL DAMAGE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Consecration
Consecration:Callback('DamagePve', function(spell)
    if not inMeleeRange then return end
    if isMoving then return end

    local consecrationRemains = target:DebuffRemains(debuffs.consecration)
    if consecrationRemains > 3000 then return end

    return spell:Cast(player)
end)

-- Judgment
Judgment:Callback('DamagePve', function(spell)
    if HolyPower == 5 then return end

    return spell:Cast(target)
end)

-- HammerofWrath
HammerofWrath:Callback('DamagePve', function(spell)
    if not A.HammerofWrath:IsTalentLearned() then return end
    if HolyPower == 5 then return end

    return spell:Cast(target)
end)

-- HolyShockDMG
HolyShockDMG:Callback('DamagePve', function(spell)
    if not GetToggle(2, "HolyShockOffensive") then return end
    if HolyPower == 5 then return end

    return spell:Cast(target)
end)

-- CrusaderStrike
CrusaderStrike:Callback('DamagePve', function(spell)
    if not inMeleeRange then return end -- something weird is going on it tries to use it in out of range
    if HolyPower == 5 then return end

    return spell:Cast(target)
end)

-- ShieldoftheRighteous
ShieldoftheRighteous:Callback('DamagePve', function(spell)
    if not inMeleeRange then return end
    if HolyPower ~= 5 then return end

    return spell:Cast(player)
end)

--################################################################################################################################################################################################################

local function Untilities()
	Intercession('Utilities1')
end

local function PreCombat()
	CrusaderAura('PreCombat')
	DevotionAura('PreCombat')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SelfDefensive()
	DivineShield('Defensive1')
	DivineProtection('Defensive1')
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

	Cleanse('Dispel')
    LayOnHands('Cooldowns')
    BlessingofProtection('Cooldowns')
    BlessingofSacrifice('Cooldowns')
    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')
	AvengingWrath('Cooldowns')
	AuraMastery('Cooldowns')
	TyrDeliverance('Cooldowns')
    BeaconofVirtue('Beacon')
	DivineToll('Cooldowns')
	HandofDivinity('Cooldowns')
    BlessingofSpring('Blessing')
    BlessingofSummer('Blessing')
    BlessingofAutumn('Blessing')
    BlessingofWinter('Blessing')
	LightofDawn('HealingPve')
	WordofGlory('HealingPve')
	FlashofLight('ForceInfusionofLight')
	HolyLight('ForceInfusionofLight')
	BarrierofFaith('HealingPve')
	HolyShock('HealingPve')
	HolyPrism('HealingPve')
	FlashofLight('InfusionofLight')
	HolyLight('InfusionofLight')
	FlashofLight('HealingPve')
	HolyLight('HealingPve')
	BeaconofLight('Beacon')
    BeaconofFaith('Player')
	BeaconofFaith('Beacon')
    HolyLight('OutofCombat')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
	Consecration('DamagePve')
	Judgment('DamagePve')
	HammerofWrath('DamagePve')
	HolyShockDMG('DamagePve')
	CrusaderStrike('DamagePve')
	ShieldoftheRighteous('DamagePve')
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
    SetUpHealers()

	isStaying   	= Player:IsStaying()
	movingTime  	= Player:IsMovingTime()
	stayingTime		= Player:IsStayingTime()
	isMoving 		= player:IsMoving()
	combatTime  	= player:CombatTime()
	playerHealth	= player:Health()
	inMeleeRange	= Unit("target"):GetRange() <= 5
	HolyPower		= Player:HolyPower()

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local enemiesList = MakEnemies.get()
    local shouldInterrupt = handleInterrupts(enemiesList)
    if shouldInterrupt then
        if shouldInterrupt == "Switch" then
            return A.TargetEnemy:Show(icon)
        else
            return shouldInterrupt:Show(icon)
        end
    end

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

Rebuke:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
	if not enemy.exists then return end
	Rebuke("arena", enemy)
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
