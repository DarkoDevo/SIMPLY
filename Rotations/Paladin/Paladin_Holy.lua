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
local ConstSpells      = MakuluFramework.constantSpells
local Debounce         = MakuluFramework.debounceSpell
local cacheContext     = MakuluFramework.Cache
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Unit       	   = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits
local GetToggle		   = Action.GetToggle
local AuraIsValid      = Action.AuraIsValid
local LoC              = Action.LossOfControl
local UnitIsUnit	   = _G.UnitIsUnit
local HealingEngine    = Action.HealingEngine
local getmembersAll    = HealingEngine.GetMembersAll()
local _G, setmetatable = _G, setmetatable
local GetSpellTexture  = _G.TMW.GetSpellTexture

local FakeCasting                     = MakuluFramework.FakeCasting

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
	--CrusaderStrike                        	= { ID = 35395 		},
	ShieldoftheRighteous                  	= { ID = 53600		},
	FlashofLight                          	= { ID = 19750		},
	HammerofJustice                       	= { ID = 853      	},
    Consecration                          	= { ID = 26573     	},
	ConsecrationDebuff                    	= { ID = 204242    	},
	WordofGlory                           	= { ID = 85673,     Texture = 280098 }, --WOG Icon
    EternalFlame                            = { ID = 156322,    Texture = 280098 }, --WOG Icon
	HandofReckoning                       	= { ID = 62124    	},
	SenseUndead                       	  	= { ID = 5502    	},
	Redemption                            	= { ID = 7328      	},
	Intercession                          	= { ID = 391054    	},
	LayOnHands                            	= { ID = 633		},
    LayOnHandsTalent                        = { ID = 471195		},
    EmpyrealWard                            = { ID = 387791		},
	BlessingofFreedom                     	= { ID = 1044      	},
	HammerofWrath                         	= { ID = 24275    	},
    CrusaderAura                          	= { ID = 32223     	},
    DevotionAura                    	  	= { ID = 465       	},
    ConcentrationAura                     	= { ID = 317920    	},
    RetributionAura                       	= { ID = 183435    	},
	DivineSteed                           	= { ID = 190784   	},
	AvengingWrath                    	  	= { ID = 31884  	},
	--Rebuke                    	  		  	= { ID = 96231, MAKULU_INFO = { damageType = "physical", ignoreCasting = true, offGcd = true } },
    TurnEvil                              	= { ID = 10326   	},
    Forbearance                           	= { ID = 25771    	},
    BlessingofProtection                  	= { ID = 1022, Macro = "/cast [@target,help][@focus,help][@player]spell:thisID" },
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
	--BlessingofSpring                      	= { ID = 388013, Texture = 214202, Macro = "/cast [@player] Blessing of Spring" }, --Rule of Law Icon
	--BlessingofSummer                      	= { ID = 388007, Texture = 448227, Macro = "/cast [@focus, help] Blessing of Summer" }, --BlessingofSummer Icon
	--BlessingofAutumn                     	= { ID = 388010, Texture = 448227, Macro = "/cast [@focus, help] Blessing of Autumn" }, --BlessingofSummer Icon
	--BlessingofWinter                      	= { ID = 388011, Texture = 214202, Macro = "/cast [@player] Blessing of Summer" }, --Rule of Law Icon
	DivineToll                            	= { ID = 375576, FixedTexture = 3565448 	},

	HolyPrism                             	= { ID = 114165		},
	Judgment                              	= { ID = 275773   	},
	LightsHammer                          	= { ID = 114158    	},
	RuleofLaw                             	= { ID = 214202    	},
	TyrDeliverance                        	= { ID = 200652    	},
	Cleanse                               	= { ID = 4987     	},
	HolyShock                             	= { ID = 20473		},
	HolyShockDMG                          	= { ID = 20473, Desc = "Holy Shock DMG", Texture = 93402, Macro = "/cast Holy Shock" },
	HolyLight                             	= { ID = 82326 }, --Gift of Naaru Icon
	BeaconofLight                         	= { ID = 53563    	},
	InfusionofLight                   	  	= { ID = 54149		},
	DivineProtection                      	= { ID = 498      	},
	LightofMartyr                         	= { ID = 183998		},
	LightofDawn                           	= { ID = 85222		},
	Absolution                            	= { ID = 212056   	},
	MaraadBuff 							  	= { ID = 388019 	},
	EmpyreanLegacy 						  	= { ID = 1241358 	},
	HandofDivinity 						  	= { ID = 414273 	},
	TyrDeliveranceBuff                    	= { ID = 200654, Hidden = true    	},
	AurasoftheResolute                    	= { ID = 385633, Hidden = true    	},
	AurasofSwiftVengeance                 	= { ID = 385639, Hidden = true    	},
	ShiningRighteousness                  	= { ID = 414445, Hidden = true    	},
    CrusdersMight                  	        = { ID = 196926, Hidden = true  	},
	ImprovedDispelTalent                  	= { ID = 393024, Hidden = true  	},
    SearingGlare                          	= { ID = 410126,   	                },

    SiphoningPhylacteryShard                = { ID = 178783, Hidden = true 	    },
    SiphoningPhylacteryShardBuff            = { ID = 345549, Hidden = true  	},
    HolyBulwark                          	= { ID = 432459,   	                },
    SacredWeapon                          	= { ID = 432472,   	                },
    RiteofSanctification                    = { ID = 433568,   	                },
    RiteofAdjuration                        = { ID = 433583,   	                },
    RisingSunlight                          = { ID = 414204, Hidden = true  	},
    LightsRevocation                        = { ID = 146956, Hidden = true  	},
    BlessingofSpellwarding                  = { ID = 204018, Texture = 62124 },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function createAction(attributes)
    return Action.Create({
        Type = attributes.Type or "Spell",
        ID = attributes.ID,
        Texture = attributes.Texture,
        FixedTexture = attributes.FixedTexture,
        Color = attributes.Color,
        Desc = attributes.Desc,
        MAKULU_INFO = attributes.MAKULU_INFO,
        Hidden = attributes.Hidden,
        QueueForbidden = attributes.QueueForbidden,
    })
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local A = {}
for name, attributes in pairs(ActionID) do
    A[name] = createAction(attributes)
end
for name, attributes in pairs(ConstSpells) do
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
    beaconofvirtue = 200025,
    divinefavor = 210294,
    dawnlight = 431522,
    dawnlighthot = 431381,
    divinepupose = 223819,
    riteofsanctification = 433550,
    riteofadjuration = 433584,
    holybulwark = 432496,
    sacredweapon = 432502,
    avengingcrusdar = 216331,
    risingsunlight = 414204,
    awakeningstacks = 414196,
    awakeningbuff = 414193,
    blessingOfanshee = 445204,
    consecrationBuff = 188370,
    momentofcompassion = 387786,
    oathblock = 1240000,
    empyreanlega = 1241358,


}

local debuffs = {
	forbearance = 25771,
	consecration = 204242,
	oathbound = 1239997,

}

local gameState = {
    imCasting = nil,
    imCastingName = nil,
    imCastingRemaining = nil,
    imCastingLength = nil,
    lastConsecrationDrop = 0,
}

-- Helper function to parse time strings like "30", "1:30", "2:15" into seconds
local function parseTimeToSeconds(timeStr)
    if not timeStr or type(timeStr) ~= "string" then return nil end

    -- Remove any trailing 's' and trim whitespace
    timeStr = string.gsub(timeStr, "s$", "")
    timeStr = string.gsub(timeStr, "^%s*(.-)%s*$", "%1")

    -- Check if it contains a colon (minutes:seconds format)
    if string.find(timeStr, ":") then
        local minutes, seconds = string.match(timeStr, "^(%d+):(%d+)$")
        if minutes and seconds then
            return tonumber(minutes) * 60 + tonumber(seconds)
        end
    else
        -- Just seconds
        local seconds = tonumber(timeStr)
        if seconds then
            return seconds
        end
    end

    return nil
end






local interrupts = {
    { spell = Rebuke },
    { spell = HammerofJustice, isCC = true },
    { spell = BlindingLight, isCC = true, aoe = true, distance = 5 }
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or player:Buff(buffs.divineshield)
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

local constCell = cacheContext:getConstCacheCell()
local function enemiesInMelee()
    return constCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if CrusaderStrike:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                total = total + 1
            end
        end

        return total
    end)
end

local function autoTarget()
    if A.Zone == "arena" then return false end
    if not player.inCombat then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if CrusaderStrike:InRange(target) and target.exists then return false end

    if gameState.enemiesInMelee > 0 and A.GetToggle(2, "oorTarget") then
        return true
    end
end


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
    -- Fehlerbehandlung hinzufügen
    if not gameState then
        gameState = {} -- Stelle sicher dass gameState initialisiert ist
        return
    end

    local currentTime = GetTime()
    local currentCast, currentCastName, currentCastRemains, currentCastLength = getCurrentCastInfo()

    -- Überprüfe auf nil bevor dem Zugriff
    if currentCastRemains then
        gameState.imCastingRemaining = currentCastRemains
    end

    if (currentTime - lastUpdateTime) > updateDelay then
        gameState.imCasting = currentCast
        gameState.imCastingName = currentCastName
        lastUpdateTime = currentTime
    end

    gameState.enemiesInMelee = enemiesInMelee()

    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    gameState.dungeon = instanceType == "party"
    gameState.raid = instanceType == "raid"


end



--######################################################################################################################################################################################################

local function CantCreateHolyPower()
    return player.holyPower and player.holyPower == 5
end

local function enemyBurstCount()
    local burstCount = 0

    if arena1.exists and arena1.cds then burstCount = burstCount + 1 end
    if arena2.exists and arena2.cds then burstCount = burstCount + 1 end
    if arena3.exists and arena3.cds then burstCount = burstCount + 1 end

    return burstCount
end



FakeCasting.enable()

FakeCasting.blacklist({
  [20066] = true, -- Repentance
  [421453] = true, --Ultimate Penitience
})

local function getBelowHP(percent)
    return MakMulti.party:Count(function(unit)
        return FlashofLight:InRange(unit) and unit.ehp < percent
    end)
end

local function seasonReady()
    local iconID = C_Spell.GetSpellTexture(388007)

    local seasons = {
        [3636845] = "Summer",
        [3636843] = "Autumn",
        [3636846] = "Winter",
        [3636844] = "Spring"
    }

    return seasons[iconID]
end

local function TeamIsSafe(threshhold)
    return A.HealingEngine.GetBelowHealthPercentUnits(threshhold, nil) == 0
end

-- Check for JudgmentHeal conditions
local function judgmentHandler1()
    return not GetToggle(2, "JudgmentHeal") or (GetToggle(2, "JudgmentHeal") and ((player:Buff(buffs.avengingcrusader) and CanUseHealingCooldowns()) or (not player:Buff(buffs.avengingcrusader)) or (not A.AvengingCrusader:IsTalentLearned())))
end

-- Check Judgment allowance based on Awakening and optional 15-stack gating
local function judgmentHandler2()
    -- If the "StopJudgment15" toggle is enabled, only allow Judgment at exactly 15 Awakening stacks
    if GetToggle(2, "StopJudgment15") then
        return player:HasBuffCount(buffs.awakeningstacks) == 15
    end

    -- In dungeons (5 players or less), allow Judgment freely
    if GetNumGroupMembers() <= 5 then
        return true
    end

    -- In larger groups (raids), only allow Judgment when we have the Awakening buff 414193
    return player:Buff(buffs.awakeningbuff)
end

-- Main judgment handler that combines all conditions
local function judgmentHandler()
    if CantCreateHolyPower() then
        return false
    end

    if judgmentHandler1() and judgmentHandler2() then
        return true
    end

    return false
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive()
end

local function shouldPoolHP()
    local incomingDamage = hasIncomingDamage()
    if incomingDamage then return true end
    return false
end

--######################################################################################################################################################################################################

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### UTILITIES ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Intercession
Intercession:Callback('Utilities', function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if not player.combat then return end
    if not mouseover.exists then return end
    if not mouseover.isFriendly then return end
    if not mouseover.dead then return end
    if not spell:InRange(mouseover) then return end

    return spell:Cast()
end)

Absolution:Callback('Utilities', function(spell)
    if not A.GetToggle(2, "mouseoverRes") then return end
    if player.combat then return end

    local deadFriend  = MakMulti.party:Find(function(unit) return unit.exists and HolyLight:InRange(unit) and unit.dead end)

    if not deadFriend then return end

    return spell:Cast()
end)

--RiteofSanctification
RiteofSanctification:Callback('Utilities', function(spell)
    if not player:TalentKnown(RiteofSanctification.id) then return end
    local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()
    if player and player.CombatTime and player:CombatTime() > 0 then return end
    if not hasMainHandEnchant or mainHandExpiration <= (6000 * num(not player.inCombat)) then
        return spell:Cast()
    end
end)

--RiteofAdjuration
RiteofAdjuration:Callback('Utilities', function(spell)
    if not player:TalentKnown(RiteofAdjuration.id) then return end
    local hasMainHandEnchant, mainHandExpiration, _, _, hasOffHandEnchant, offHandExpiration, _, _ = GetWeaponEnchantInfo()
    if player and player.CombatTime and player:CombatTime() > 0 then return end
    if not hasMainHandEnchant or mainHandExpiration <= (6000 * num(not player.inCombat)) then
        return spell:Cast()
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DEFENSIVE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DivineShield
DivineShield:Callback('Defensive1', function(spell)
	if player:HasDeBuff(debuffs.forbearance) then return end
    if player.hp > GetToggle(2, "SelfProtection2") then return end



    return spell:Cast()
end)

-- DivineProtection
DivineProtection:Callback('Defensive1', function(spell)
    -- Don't use if already immune
    if player:Buff(buffs.divineshield) then return end
    local hpThreshold = GetToggle(2, "SelfProtection1")
    if Action.Zone == "arena" then
        -- In PvP, trigger purely on HP threshold for reliability
        if player.hp > hpThreshold then return end
    else
        -- In PvE, keep predictive damage + effective HP gating
        if not shouldDefensive() or player.ehp > hpThreshold then return end
    end

    return spell:Cast()
end)

-- BlessingofFreedom
BlessingofFreedom:Callback('Defensive1', function(spell)
    if not GetToggle(2, "BoFPlayer") then return end
    if ((LoC:Get("ROOT") > 0) or (LoC:Get("SLOW") > 0) or (LoC:Get("FREEZE") > 0) or (player:HasDeBuffFromFor(MakLists.freedom, 500))) then
        return spell:Cast()
    end

    local suleymanClap = UnitPower("target") >= 90 and target.npcId == 212826
    if suleymanClap then -- Don't cast on other Paladins
        return spell:Cast()
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PRE COMBAT ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CrusaderAura
CrusaderAura:Callback('PreCombat', function(spell)
    if A.Zone == "arena" then return end
    if not Player:IsMounted() then return end
    if not A.AurasofSwiftVengeance:IsTalentLearned() then return end
    if player:Buff(A.CrusaderAura.ID) then return end

    return spell:Cast()
end)

-- DevotionAura
DevotionAura:Callback('PreCombat', function(spell)
    if A.Zone == "arena" then return end
    if Player:IsMounted() then return end
    if player:Buff(A.DevotionAura.ID) then return end

    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DISPEL ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Cleanse
Cleanse:Callback("Dispel", function(spell)
    if A.Zone == "arena" then return end
    if unit.ehp < 35 then return end
    if unit:DebuffFrom(AvoidDispelTable) then return end

    local magicked  = MakMulti.party:Find(function(unit) return (unit.magicked or AuraIsValid(unit:CallerId(), "UseDispel", "Magic")) and Cleanse:InRange(unit) end)
    local diseased = MakMulti.party:Find(function(unit) return (unit.diseased or AuraIsValid(unit:CallerId(), "UseDispel", "Disease")) and Cleanse:InRange(unit) end)
    local poisoned  = MakMulti.party:Find(function(unit) return (unit.poisoned or AuraIsValid(unit:CallerId(), "UseDispel", "Poison")) and Cleanse:InRange(unit) end)

    if magicked then
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if diseased and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(diseased:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if poisoned and player:TalentKnown(ImprovedDispelTalent.id) then
        HealingEngine.SetTarget(poisoned:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### EMERGENCY SINGLE TARGET COOLDOWN ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CantUseLoHBoP()
    return unit:HasDeBuff(debuffs.forbearance) or combatTime == 0
end

-- LayOnHands
LayOnHands:Callback('Emergency', function(spell)
    if player:TalentKnown(EmpyrealWard.id) then return end
    if CantUseLoHBoP() then return end
    if unit.hp > 25 then return end
    if not unit:IsPlayer() and unit.npcId ~= 210759 then return end -- Brann
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime > 25 and gameState.raid then return end



    -- PvP focus support: if focus is a friendly in danger, cast on focus even if targeting an enemy
    if Action.Zone == "arena" and focus.exists and focus.isFriendly and focus.hp <= 25 and not focus:HasDeBuff(debuffs.forbearance) then
        return spell:Cast(focus)
    end

    return spell:Cast(unit)
end)

-- LayOnHandsTalent
LayOnHandsTalent:Callback('Emergency', function(spell)
    if not player:TalentKnown(EmpyrealWard.id) then return end
    if CantUseLoHBoP() then return end
    if unit.hp > 25 then return end
    if not unit:IsPlayer() and unit.npcId ~= 210759 then return end -- Brann

    -- PvP focus support: if focus is a friendly in danger, cast on focus even if targeting an enemy
    if Action.Zone == "arena" and focus.exists and focus.isFriendly and focus.hp <= 25 and not focus:HasDeBuff(debuffs.forbearance) then
        return spell:Cast(focus)
    end

    return spell:Cast(unit)
end)

-- BlessingofProtection
BlessingofProtection:Callback('Emergency', function(spell)
    if Action.Zone == "arena" then return end
    if CantUseLoHBoP() then return end
    if unit.hp > 45 then return end
    --if Unit("focus"):ThreatSituation() < 1 then return end
    if Unit("focus"):Role("TANK") then return end
    if unit:Buff(A.BlessingofSacrifice.ID) then return end
    if Unit("focus"):Class() == "PALADIN" then return end
    if not unit:IsPlayer() then return end

    return spell:Cast(unit)
end)

-- BlessingofSacrifice
BlessingofSacrifice:Callback('Emergency', function(spell)
    if player.hp < 45 then return end

    local tankBuster = MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0
    if tankBuster then
        if tank.exists and tank.ehp > 0 then
            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(unit)
        end
    end

    if combatTime == 0 then return end
    if UnitIsUnit("focus", "player") then return end
    if unit:Buff(A.BlessingofProtection.ID) then return end
    if unit.hp > 65 then return end
    if not unit:IsPlayer() then return end

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
    if not A.GetToggle(1, "Racial") then return end

    if player.bleeding then
        return spell:Cast()
    end

    local magicked  = MakMulti.party:Find(function(friendly) return (friendly.magicked or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Magic")) and Cleanse:InRange(friendly) and not friendly.isMe end)
    local diseased = MakMulti.party:Find(function(friendly) return (friendly.diseased or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Disease")) and Cleanse:InRange(friendly) and not friendly.isMe end)
    local poisoned  = MakMulti.party:Find(function(friendly) return (friendly.poisoned or Action.AuraIsValid(friendly:CallerId(), "UseDispel", "Poison")) and Cleanse:InRange(friendly) and not friendly.isMe end)

    if ((diseased or poisoned) and player:TalentKnown(ImprovedDispelTalent.id)) or magicked then
        if ((player.diseased or player.poisoned) and player:TalentKnown(ImprovedDispelTalent.id)) or player.magicked then
            return spell:Cast()
        end
    end
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
    return player:Buff(buffs.avengingwrath) or player:Buff(buffs.avengingcrusader) or player:Buff(buffs.auramastery) or player:Buff(buffs.awakeningbuff)
end

-- AvengingWrath
AvengingWrath:Callback('Cooldowns', function(spell)
    if A.AvengingCrusader:IsTalentLearned() then return end
    if MajorCooldownIsActive() then return end

    -- Require combat before using Wings
    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if currentCombatTime == 0 then return end

    -- PvE: Use Wings based on DBM/BigWigs timers or CanUseHealingCooldowns
    if Action and Action.Zone and Action.Zone ~= "arena" then
        if not CanUseHealingCooldowns() then return end
        return spell:Cast()
    end

    -- PvP handling
    local shouldUseWings = false
    if enemyBurstCount and type(enemyBurstCount) == "function" then
        local burstCount = enemyBurstCount()
        if burstCount and type(burstCount) == "number" and burstCount >= 1 then
            local lowHealthCondition = false
            if (party1 and party1.exists and party1.hp and type(party1.hp) == "number" and party1.hp < 50) or
               (party2 and party2.exists and party2.hp and type(party2.hp) == "number" and party2.hp < 50) or
               (player and player.hp and type(player.hp) == "number" and player.hp < 50) then
                lowHealthCondition = true
            end
            shouldUseWings = lowHealthCondition
        end
    end

    if shouldUseWings and spell and type(spell.Cast) == "function" then
        return spell:Cast()
    end
end)

-- AuraMastery
AuraMastery:Callback('Cooldowns', function(spell)



    if MajorCooldownIsActive() then return end

    if Action.Zone == "arena" and getBelowHP(30) == 0 then
        if enemyBurstCount() >= 1 and ((party1.exists and party1.hp < 84) or (party2.exists and party2.hp < 84) or (player.hp < 84)) then
            return spell:Cast()
        end
    end

    if not CanUseHealingCooldowns() then return end
    return spell:Cast()
end)

-- TyrDeliverance
TyrDeliverance:Callback('Cooldowns', function(spell)




    local currentCombatTime = (player and player.CombatTime and player:CombatTime()) or 0
    if Action.Zone == "arena" and currentCombatTime > 0 and getBelowHP(75) <= 1 then
        return spell:Cast()
    end

    if gameState.dungeon then return end

    if not CanUseAoeHealing() then return end
    return spell:Cast()
end)

-- DivineToll
DivineToll:Callback('Cooldowns', function(spell)



    if Action.Zone == "arena" and unit.ehp < 60 then
        return spell:Cast(unit)
    end

    if GetToggle(2, "DtMenu") == "3" then return end
    -- Only use Divine Toll with 2 or fewer Holy Power
    if player.holyPower > 2 then return end

    local virtueSync = GetToggle(2, "VirtueSynch")

    if CanUseAoeHealing() then
        if virtueSync and player:TalentKnown(BeaconofVirtue.id) then
            if (unit:Buff(buffs.beaconofvirtue) or player:Buff(buffs.beaconofvirtue)) then
                return spell:Cast(unit)
            end
        else
            return spell:Cast(unit)
        end
    end
 end)

-- HandofDivinity
HandofDivinity:Callback('Cooldowns', function(spell)
    if Action.Zone == "arena" and unit.ehp < 60 then return end
    if not CanUseAoeHealing() then return end
    return spell:Cast()
end)

-- HolyBulwark
HolyBulwark:Callback('HealingPve', function(spell)
    local bulwarkReady = C_Spell.GetSpellTexture(432459) == 5927636
    if not bulwarkReady then return end

    if unit:Buff(buffs.holybulwark) then return end

    local tankBuster = MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0
    if tankBuster then
        if tank.exists and tank.ehp > 0 then
            HealingEngine.SetTarget(tank:CallerId(), 1)
            return spell:Cast(unit)
        end
    end

    if Action.Zone == "arena" then
        if unit.ehp < 80 then
            return spell:Cast(unit)
        end
    end

    if unit.ehp > 75 then return end

    return spell:Cast(unit)
end)

-- SacredWeapon
SacredWeapon:Callback('HealingPve', function(spell)
    local weaponReady = C_Spell.GetSpellTexture(432459) == 5927637
    if not weaponReady then return end

    for i = 1, #getmembersAll do
        local unitID = getmembersAll[i].Unit
        if Unit(unitID):IsBuffUp(PiTable) and Unit(unitID):Role("DAMAGER") then
            HealingEngine.SetTarget(unitID)
            if unit:BuffRemains(buffs.sacredweapon) > 3000 then return end
            return spell:Cast(unit)
        end
    end

    if unit:BuffRemains(buffs.sacredweapon) > 3000 then return end
    if CanUseAoeHealing() then
        return spell:Cast(unit)
    end

    if Action.Zone == "arena" then
        if unit:BuffRemains(buffs.sacredweapon) > 3000 then return end
        if unit.ehp < 70 then
            return spell:Cast(unit)
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### STANDARD HEALING PVE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- HolyShock 2 Charges
HolyShock:Callback('2Charges', function(spell)
    if CantCreateHolyPower() then return end

    if Action.Zone == "arena" then
        if unit.hp < 90 then
            return spell:Cast(unit)
        end
    end

    if player:Buff(buffs.risingsunlight) and player.holyPower > 2 then return end

    if A.HolyShock:GetSpellCharges() < 2 then return end
    local hsMenu = GetToggle(2, "HSMenu")
    if hsMenu == "3" then return  end

    local holyshockSlider = GetToggle(2, "HolyShockSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.HolyShock, holyshockSlider) then return end

    return spell:Cast(unit)
end)

-- BarrierofFaith
BarrierofFaith:Callback('HealingPve', function(spell)
    if player:HasBuffCount(buffs.awakeningstacks) >= 12 and not player:Buff(buffs.awakeningbuff) then return end
    if not AutoHeal(unit:CallerId(), A.BarrierofFaith) then return end

    return spell:Cast(unit)
end)

-- HolyPrism
HolyPrism:Callback('HealingPve', function(spell)
    local virtueSync = GetToggle(2, "VirtueSynch")



    if player:HasBuffCount(buffs.awakeningstacks) < 12 or player:Buff(buffs.awakeningbuff) then
        if virtueSync and player:TalentKnown(BeaconofVirtue.id) and CanUseAoeHealing() then
            -- Virtue Synch
            if (unit:Buff(buffs.beaconofvirtue) or player:Buff(buffs.beaconofvirtue)) then
                return spell:Cast(unit)
            end
        else
            if (CanUseAoeHealing() or CanUseHealingCooldowns() or player:BuffRemains(buffs.awakeningbuff) < 4000) then
                -- Standard
                --Fallback to avoid triggering SotR because of Auto Heal Calculations
                if unit.ehp < 80 then
                    return spell:Cast(unit)
                end

                local wordofglorySlider = GetToggle(2, "WOGSlider")
                if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end
                return spell:Cast(unit)
            end
        end
    end
 end)

-- WordofGlory Divine Purpose: Always consume Divine Purpose procs first
WordofGlory:Callback('DivinePurpose', function(spell)
    if not player:Buff(buffs.divinepupose) then return end

    local wogTarget = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return WordofGlory:InRange(friendly) and friendly.hp > 0 and friendly.ehp < 90 end
    )

    if wogTarget then
        HealingEngine.SetTarget(wogTarget:CallerId(), 1)
        return spell:Cast(wogTarget)
    end
end)

-- WordofGlory + Dawnlight or Virtue Buff
WordofGlory:Callback('Buffed', function(spell)
    if player:Buff(buffs.dawnlight) or unit:Buff(buffs.beaconofvirtue) or player:Buff(buffs.beaconofvirtue) then
        --Fallback to avoid triggering SotR because of Auto Heal Calculations

        local dawnlightUnit = MakMulti.party:Lowest(
            function(friendly) return friendly.ehp end,
            function(friendly) return WordofGlory:InRange(friendly) and friendly.hp > 0 and friendly.ehp < GetToggle(2, "WOGSlider") + (num(friendly:Buff(buffs.dawnlighthot, true)) * 25) end
        )

        local wordofglorySlider = GetToggle(2, "WOGSlider")

        if dawnlightUnit then -- spread Dawnlight HoT
            if unit:BuffRemains(buffs.dawnlighthot, true) > 1000 and unit.ehp > wordofglorySlider then
                HealingEngine.SetTarget(dawnlightUnit:CallerId(), 1)
            end
        end

        if unit.ehp < 80 then
            return spell:Cast(unit)
        end

        if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end

        spell:Cast(unit)
    end
end)

-- LightofDawn 5HP
LightofDawn:Callback('5HP', function(spell)
    if player.holyPower ~= 5 or not player:Buff(buffs.divinepupose) then return end

    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Off" then return end

    if lightofdawnmenu == "Auto" then
        if gameState.raid and unit.ehp > GetToggle(2, "AvoidLoDSlider") and CanUseAoeHealing() then
            return spell:Cast()
        end
    end

    if lightofdawnmenu == "Always" then
        if player.holyPower >= 5 and CanUseAoeHealing() then
            return spell:Cast()
        end
    end

    if lightofdawnmenu == "UL" then
        if player.holyPower >= 5 and CanUseAoeHealing() and player:HasBuffCount(buffs.unendingLight) >= 9 then
            return spell:Cast()
        end
    end
end)

-- WordofGlory 5HP
WordofGlory:Callback('5HP', function(spell)
    if HolyPower ~= 5 or not player:Buff(buffs.divinepupose) then return end

    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Always" then return end

    local dawnlightUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return WordofGlory:InRange(friendly) and friendly.hp > 0 and friendly.ehp < GetToggle(2, "WOGSlider") + (num(friendly:Buff(buffs.dawnlighthot, true)) * 25) end
    )

    local wordofglorySlider = GetToggle(2, "WOGSlider")

    if dawnlightUnit then -- spread Dawnlight HoT
        if unit:BuffRemains(buffs.dawnlighthot, true) > 1000 and unit.ehp > wordofglorySlider then
            HealingEngine.SetTarget(dawnlightUnit:CallerId(), 1)
        end
    end

    --Fallback to avoid triggering SotR because of Auto Heal Calculations
    if unit.ehp < 80 then
        return spell:Cast(unit)
    end

    if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end

    return spell:Cast(unit)
end)

-- HolyLight + Hand of Divinity Buff
HolyLight:Callback('Divinity', function(spell)
    if CantCreateHolyPower() then return end
    if not player:Buff(buffs.divinity) then return end
    if not AutoHeal(unit:CallerId(), A.HolyLight) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- LightofDawn default
LightofDawn:Callback('Default', function(spell)
    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Off" then return end

    if lightofdawnmenu == "Auto" then
        if gameState.raid and unit.ehp > GetToggle(2, "AvoidLoDSlider") and CanUseAoeHealing() then
            return spell:Cast()
        end
    end

    if lightofdawnmenu == "Always" then
        if CanUseAoeHealing() then
            return spell:Cast()
        end
    end

    if lightofdawnmenu == "UL" then
        if CanUseAoeHealing() and player:HasBuffCount(buffs.unendingLight) >= 9 then
            return spell:Cast()
        end
    end
end)

-- WordofGlory default
WordofGlory:Callback('Default', function(spell)
    local lightofdawnmenu = GetToggle(2, "Dropdown2")
    if lightofdawnmenu == "Always" then return end

    local dawnlightUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly) return WordofGlory:InRange(friendly) and friendly.hp > 0 and friendly.ehp < GetToggle(2, "WOGSlider") + (num(friendly:Buff(buffs.dawnlighthot, true)) * 25) end
    )

    local wordofglorySlider = GetToggle(2, "WOGSlider")

    if dawnlightUnit then -- spread Dawnlight HoT
        if unit:BuffRemains(buffs.dawnlighthot, true) > 1000 and unit.ehp > wordofglorySlider then
            HealingEngine.SetTarget(dawnlightUnit:CallerId(), 1)
        end
    end

    --Fallback to avoid triggering SotR because of Auto Heal Calculations
    if unit.ehp < 80 then
        return spell:Cast(unit)
    end

    if not AutoHealOrSlider(unit:CallerId(), A.WordofGlory, wordofglorySlider) then return end

    return spell:Cast(unit)
end)

-- HolyShock default
HolyShock:Callback('Default', function(spell)
    if CantCreateHolyPower() then return end
    if player:Buff(buffs.risingsunlight) and player.holyPower > 2 then return end

    local hsMenu = GetToggle(2, "HSMenu")
    if hsMenu == "3" then return  end

    local holyshockSlider = GetToggle(2, "HolyShockSlider")
    if not AutoHealOrSlider(unit:CallerId(), A.HolyShock, holyshockSlider) then return end

    return spell:Cast(unit)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FlashofLight Divine Favor
FlashofLight:Callback('DivineFavor', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if CantCreateHolyPower() then return end
    if not player:Buff(buffs.divinefavor) then return end
    if GetToggle(2, "DivineFavorMenu") ~= "1" then return end
    if not AutoHeal(unit:CallerId(), A.FlashofLight) then return end

    return spell:Cast(unit)
end)

FlashofLight:Callback('arena', function(spell)
    if Action.Zone ~= "arena" then return end
    if unit.hp > 50 then return end

    return spell:Cast(unit)
end)

-- HolyLight Divine Favor
HolyLight:Callback('DivineFavor', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if CantCreateHolyPower() then return end
    if not player:Buff(buffs.divinefavor) then return end
    if GetToggle(2, "DivineFavorMenu") ~= "2" then return end
    if not AutoHeal(unit, A.HolyLight) then return end

    return spell:Cast(unit)
end)

-- HolyLight Divine Favor + Infusion
HolyLight:Callback('DivineFavor', function(spell)
    if gameState.imCasting and gameState.imCasting == spell.spellId then return end
    if CantCreateHolyPower() then return end
    if not player:Buff(buffs.divinefavor) then return end
    if not player:Buff(buffs.infusionoflight) then return end
    if GetToggle(2, "DivineFavorMenu") ~= "4" then return end
    if not AutoHeal(unit, A.HolyLight) then return end

    return spell:Cast(unit)
end)

-- Central helper function to handle Infusion of Light and regular healing
local function HandleInfusionOfLightOrHealing(spell, spellName, unit, isForce, isInfusion, isOutOfCombat)
    if CantCreateHolyPower() then return end

    -- Logic for Out of Combat Healing
    if isOutOfCombat then
        if not GetToggle(2, "OOCHeal") then return end
        if combatTime > 0 then return end
        if not AutoHeal(unit:CallerId(), A.HolyLight) then return end

        return spell:Cast(unit)
    end

    -- Logic for Infusion of Light
    if isInfusion then
        if gameState.imCasting and gameState.imCasting == spell.spellId then return end

        -- Check if the selected spell matches the Infusion of Light setting
        local infusionoflightmenu = GetToggle(2, "Dropdown5")
        if infusionoflightmenu ~= spellName then return end

        -- Check if the Infusion of Light buff lasts long enough to finish casting the spell
        local buffRemains = player:BuffRemains(buffs.infusionoflight)
        local castTime = spell:CastTime()
        if buffRemains < castTime then return end

        -- In Force mode, only proceed if the early consumption option is enabled
        if isForce then
            local forceearlyconsume = GetToggle(2, "Checkbox3")
            if not forceearlyconsume then return end
        end

        -- Check if the spell can be cast according to the Infusion slider
        local infusionSlider = GetToggle(2, "InfusionSlider")
        if spellName == "FlashofLight" and not AutoHealOrSlider(unit:CallerId(), A.FlashofLight, infusionSlider) then return end
        if spellName == "HolyLight" and not AutoHealOrSlider(unit:CallerId(), A.HolyLight, infusionSlider) then return end
    else
        -- Logic for regular healing
        if spellName == "FlashofLight" then
            local flashoflightSlider = GetToggle(2, "FlashofLightSlider")
            if not AutoHealOrSlider(unit:CallerId(), A.FlashofLight, flashoflightSlider) then return end
        elseif spellName == "HolyLight" then
            local holylightSlider = GetToggle(2, "HolyLightSlider")
            if not AutoHealOrSlider(unit:CallerId(), A.HolyLight, holylightSlider) then return end
        end
    end

    return spell:Cast(unit)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function ManageBeaconsArena()
    if Action.Zone == "arena" and player:Buff(32727) then

        -- Apply Beacon of Light to party1, if eligible
        if party1.exists and not party1:Buff(buffs.beaconoflight) and BeaconofLight:Cooldown() == 0 then
            HealingEngine.SetTarget(party1:CallerId(), 1)
            if not target:IsUnit(party1) and not focus:IsUnit(party1) then
                --TargetUnit(party1:CallerId()) -- Optional: Force target if necessary
            end
            BeaconofLight:Cast(party1)
            return -- Ensure only one action per call
        end

        -- Apply Beacon of Faith to party2, if eligible
        if party2.exists and not party2:Buff(buffs.beaconoffaith) and BeaconofFaith:Cooldown() == 0 then
            HealingEngine.SetTarget(party2:CallerId(), 1)
            if not target:IsUnit(party2) and not focus:IsUnit(party2) then
                --TargetUnit(party2:CallerId()) -- Optional: Force target if necessary
            end
            BeaconofFaith:Cast(party2)
            return -- Exit to prevent unnecessary target swaps
        end

        -- Apply Beacon of Faith to player only if party2 doesn't exist
        if not party2.exists and not player:Buff(buffs.beaconoffaith) and BeaconofFaith:Cooldown() == 0 then
            HealingEngine.SetTarget(player:CallerId(), 1)
            if not target:IsUnit(player) and not focus:IsUnit(player) then
                --TargetUnit(player:CallerId()) -- Optional: Force target if necessary
            end
            BeaconofFaith:Cast(player)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Flash of Light Callbacks
FlashofLight:Callback('ForceInfusionofLight', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "FlashofLight", unit, true, true, false)
end)

FlashofLight:Callback('InfusionofLight', function(spell)


    return HandleInfusionOfLightOrHealing(spell, "FlashofLight", unit, false, true, false)
end)

FlashofLight:Callback('HealingPve', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "FlashofLight", unit, false, false, false)
end)

-- Empyrean Legacy: Consume Empyrean Legacy procs with Eternal Flame before spending another Judgment
EternalFlame:Callback('EmpyreanLegacy', function(spell)
    if not player:Buff(buffs.empyreanlega) then return end
    if player.holyPower < 3 then return end

    -- Find a suitable target for Eternal Flame
    local efTarget = MakMulti.party:Find(function(f)
        return f.hp > 0 and f.hp < 95 and EternalFlame:InRange(f)
    end)

    if efTarget then
        HealingEngine.SetTarget(efTarget:CallerId(), 1)
        return spell:Cast(efTarget)
    end
end)

-- Oath-Bound handling: ONLY use Eternal Flame when not under blocking buff 1240000
EternalFlame:Callback('OathBound', function(spell)
    if player:Buff(buffs.oathblock) then return end
    local oathUnit = MakMulti.party:Find(function(f)
        return f:HasDeBuff(debuffs.oathbound, true) and f.hp > 0 and EternalFlame:InRange(f)
    end)
    if not oathUnit then return end
    HealingEngine.SetTarget(oathUnit:CallerId(), 1)
    return spell:Cast(oathUnit)
end)


-- Beacon of Virtue: Spam Flash of Light on beacon targets only while Moment of Compassion is active
FlashofLight:Callback('VirtueCompassion', function(spell)
    if not player:Buff(buffs.beaconofvirtue) then return end
    if not player:Buff(buffs.momentofcompassion) then return end

    local virtueUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.ehp end,
        function(friendly)
            return FlashofLight:InRange(friendly) and friendly.hp > 0 and friendly:Buff(buffs.beaconofvirtue, true)
        end
    )

    if not virtueUnit then return end
    return spell:Cast(virtueUnit)
end)

-- Fallback Oath-Bound handling: use Word of Glory when EF is not usable
WordofGlory:Callback('OathBound', function(spell)
    if player:Buff(buffs.oathblock) then return end
    local oathUnit = MakMulti.party:Find(function(f)
        return f:HasDeBuff(debuffs.oathbound, true) and f.hp > 0 and WordofGlory:InRange(f)
    end)
    if not oathUnit then return end
    HealingEngine.SetTarget(oathUnit:CallerId(), 1)
    return spell:Cast(oathUnit)
end)


-- Holy Light Callbacks
HolyLight:Callback('ForceInfusionofLight', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "HolyLight", unit, true, true, false)
end)

HolyLight:Callback('InfusionofLight', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "HolyLight", unit, false, true, false)
end)

HolyLight:Callback('HealingPve', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "HolyLight", unit, false, false, false)
end)

HolyLight:Callback('OutofCombat', function(spell)
    return HandleInfusionOfLightOrHealing(spell, "HolyLight", unit, false, false, true)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### DUMP ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function castSpellIfConditionsMet(spell, consumerType, unit, healthCheckForLoD, canSOTR)
    local holyPowerConsumer = GetToggle(2, "HolyPowerConsumer")

    if GetToggle(2, "DontConsumeHP") and shouldPrepareTeam() then
        return false
    end

    if holyPowerConsumer ~= consumerType or player.holyPower < 5 then
        return
    end

    if healthCheckForLoD then
        local minHealth = GetToggle(2, "AvoidLoDSlider")
        if unit.ehp < minHealth then
            return
        end
    end

    if canSOTR then
        if unit.ehp < 70 then
            return
        end

        if not TeamIsSafe(70) then
            return
        end
    end

    return spell:Cast(unit)
end

-- Light of Dawn Dump
LightofDawn:Callback('Dump', function(spell)
    return castSpellIfConditionsMet(spell, "1", player, true, false)
end)

-- Shield of the Righteous Dump
ShieldoftheRighteous:Callback('Dump', function(spell)
    if shouldPoolHP() then return end
    if Action.Zone == "arena" then return end
    if not inMeleeRange then return end
    return castSpellIfConditionsMet(spell, "2", player, false, true)
end)

-- Word of Glory Dump
WordofGlory:Callback('Dump', function(spell)
    return castSpellIfConditionsMet(spell, "3", unit, false, false)
end)

-----------------------------------------------------------------------

-- Light of Dawn Dump + Mana check
LightofDawn:Callback('DumpMana', function(spell)
    return castSpellIfConditionsMet(spell, "4", player, true, false)
end)

-- Shield of the Righteous Dump
ShieldoftheRighteous:Callback('DumpMana', function(spell)
    if shouldPoolHP() then return end
    if Action.Zone == "arena" then return end
    if not inMeleeRange then return end
    return castSpellIfConditionsMet(spell, "5", player, false, true)
end)

-- Word of Glory Dump
WordofGlory:Callback('DumpMana', function(spell)
    return castSpellIfConditionsMet(spell, "6", unit, false, false)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### BLESSINGS & BEACONS ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function lightBeacon()
    local classPriority = {
        8,  -- Mage
        5,  -- Priest
        3,  -- Hunter
        7,  -- Shaman
        11, -- Druid
        9,  -- Warlock
        13, -- Evoker
        10, -- Monk
        4,  -- Rogue
        2,  -- Paladin
        6,  -- Death Knight
        12, -- Demon Hunter
        1,  -- Warrior
    }

    local beaconUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.maxHealth end,
        function(friendly) return friendly.hp > 0 and not friendly.isTank and not friendly.isHealer and classPriority[friendly:ClassID()] end
    )

    return beaconUnit
end

local function faithBeacon()
    local classPriority = {
        8,  -- Mage
        5,  -- Priest
        3,  -- Hunter
        7,  -- Shaman
        11, -- Druid
        9,  -- Warlock
        13, -- Evoker
        10, -- Monk
        4,  -- Rogue
        2,  -- Paladin
        6,  -- Death Knight
        12, -- Demon Hunter
        1,  -- Warrior
    }

    local beaconUnit = MakMulti.party:Lowest(
        function(friendly) return friendly.maxHealth end,
        function(friendly) return not friendly:Buff(buffs.beaconoflight) and friendly.hp > 0 and not friendly.isTank and not friendly.isHealer and classPriority[friendly:ClassID()] end
    )

    return beaconUnit
end

-- BeaconofVirtue
BeaconofVirtue:Callback('Beacon', function(spell)
    if not player:TalentKnown(BeaconofVirtue.id) then return end
    if not (CanUseHealingCooldowns() or CanUseAoeHealing() or shouldPrepareTeam()) then return end
    if player:BuffRemains(buffs.avengingcrusader) > 3000 then return end



    return spell:Cast()
end)

-- BeaconofLight
BeaconofLight:Callback('Beacon', function(spell)
    if Action.Zone == "arena" then return end
    if player:TalentKnown(BeaconofVirtue.id) then return end

    local beaconExists = MakMulti.party:Any(function(friendly) return friendly:Buff(buffs.beaconoflight, true) end)
    if beaconExists then return end

    local beaconUnit = lightBeacon()
    if not beaconUnit then return end

    if beaconUnit:Buff(buffs.beaconoflight) then return end
    if beaconUnit:Buff(buffs.beaconoffaith) then return end

    if spell:InRange(beaconUnit) then
        if not UnitIsUnit(unit:CallerId(), beaconUnit:CallerId()) then
            HealingEngine.SetTarget(beaconUnit:CallerId(), 1)
        else
            return spell:Cast(unit)
        end
    end
end)

-- BeaconofFaith
BeaconofFaith:Callback('Beacon', function(spell)
    if Action.Zone == "arena" then return end
    if player:TalentKnown(BeaconofVirtue.id) then return end

    local beaconExists = MakMulti.party:Any(function(friendly) return not friendly.dead and friendly:Buff(buffs.beaconoffaith, true) end)
    if beaconExists then return end

    local beaconUnit = faithBeacon()
    if not beaconUnit then return end

    if beaconUnit:Buff(buffs.beaconoflight) then return end
    if beaconUnit:Buff(buffs.beaconoffaith) then return end

    if spell:InRange(beaconUnit) then
        if not UnitIsUnit(unit:CallerId(), beaconUnit:CallerId()) then
            HealingEngine.SetTarget(beaconUnit:CallerId(), 1)
        else
            return spell:Cast(unit)
        end
    end
end)

-- BeaconofFaith (Player)
BeaconofFaith:Callback('Player', function(spell)
    if A.BeaconofVirtue:IsTalentLearned() then return end
    if not A.BeaconofFaith:IsTalentLearned() then return end
    if not GetToggle(2, "Checkbox1") then return end
    if HealingEngine.GetBuffsCount(A.BeaconofFaith.ID) ~= 0 then return end
    if player:Buff(buffs.beaconoflight) or player:Buff(buffs.beaconoffaith) then return end

    HealingEngine.SetTarget("player")
    return spell:Cast()
end)

local function shouldHoldForSoonWingsOrDT(windowMs)
    local w = windowMs or 8000
    if player:Buff(buffs.avengingwrath) then return false end
    local awCd = AvengingWrath:Cooldown()
    local dtCd = DivineToll:Cooldown()
    local awSoon = awCd > 0 and awCd <= w
    local dtSoon = dtCd > 0 and dtCd <= w
    return awSoon or dtSoon
end

-- BlessingofSpring (WIU: use on self on cooldown; light sync with Wings/DT)
BlessingofSpring:Callback('Blessing', function(spell)
    if seasonReady() ~= "Spring" then return end
    if combatTime == 0 then return end



    if shouldHoldForSoonWingsOrDT(8000) then return end
    HealingEngine.SetTarget("player")
    return spell:Cast()
end)

-- BlessingofSummer (WIU: cast on self for damage conversion; use on cooldown; light sync with Wings/DT)
BlessingofSummer:Callback('Blessing', function(spell)
    if seasonReady() ~= "Summer" then return end
    if combatTime == 0 then return end



    if shouldHoldForSoonWingsOrDT(8000) then return end
    HealingEngine.SetTarget("player")
    return spell:Cast()
end)

-- BlessingofAutumn (WIU: generally use on self; CDR is minor; light sync with Wings/DT)
BlessingofAutumn:Callback('Blessing', function(spell)
    if seasonReady() ~= "Autumn" then return end
    if combatTime == 0 then return end



    if shouldHoldForSoonWingsOrDT(8000) then return end
    HealingEngine.SetTarget("player")
    return spell:Cast()
end)

-- BlessingofWinter (WIU: always on self for mana; light sync with Wings/DT)
BlessingofWinter:Callback('Blessing', function(spell)
    if seasonReady() ~= "Winter" then return end
    if combatTime == 0 then return end



    if shouldHoldForSoonWingsOrDT(8000) then return end
    HealingEngine.SetTarget("player")
    return spell:Cast()
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### AVENGING CRUSDER ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function CanAttackTarget()
    return target.exists and not target.isFriendly and target.canAttack
end

-- AvengingCrusader
AvengingCrusader:Callback('AC', function(spell)
    if A.AvengingWrath:IsTalentLearned() then return end
    if not CanAttackTarget() then return end
    if not inMeleeRange and not Action.Zone == "arena" then return end

    if player:BuffRemains(buffs.beaconofvirtue) > 3000 then return end



    local acHealth = GetToggle(2, "AvengingCrusaderSlider")
    if getBelowHP(acHealth) ~= 0 or unit.ehp <= acHealth or shouldPrepareTeam() or CanUseHealingCooldowns() then
        return spell:Cast()
    end

    if Action.Zone == "arena" then
        if getBelowHP(80) ~= 0 or unit.ehp <= acHealth then
            return spell:Cast()
        end
    end
end)

-- Judgment Force with AvengingCrusader
Judgment:Callback('AC', function(spell)
    if not judgmentHandler() then return end
    if A.AvengingWrath:IsTalentLearned() then return end
    if not player:Buff(buffs.avengingcrusdar) then return end
    if not CanAttackTarget() then return end

    return spell:Cast(target)
end)

-- CrusaderStrike force with AvengingCrusader
CrusaderStrike:Callback('AC', function(spell)
    if A.AvengingWrath:IsTalentLearned() then return end
    if not player:Buff(buffs.avengingcrusdar) then return end
    if not CanAttackTarget() then return end
    if CantCreateHolyPower() then return end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### FORCE DAMAGE ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Judgment Force with Infusion
Judgment:Callback('ForceInfusionofLight', function(spell)
    if not judgmentHandler() then return end
    if not CanAttackTarget() then return end
    if not GetToggle(2, "Checkbox3") then return end
    if GetToggle(2, "Dropdown5") ~= "Judgment" then return end
    if not player:Buff(buffs.infusionoflight) then return end

    return spell:Cast(target)
end)

-- Consecration Force
Consecration:Callback('ForceDps', function(spell)
    if Action.Zone == "arena" then return end
    if not CanAttackTarget() then return end
    if unit.ehp < 50 then return end
    if not GetToggle(2, "ForceDps") then return end
    if not inMeleeRange then return end
    if isMoving then return end

    -- Drop Consecration every 12 seconds
    if gameState.lastConsecrationDrop and (GetTime() - gameState.lastConsecrationDrop) < 12 then return end
    gameState.lastConsecrationDrop = GetTime()
    return spell:Cast()
end)

-- HammerofWrath Force
HammerofWrath:Callback('ForceDps', function(spell)
    if CantCreateHolyPower() then return end
    if not CanAttackTarget() then return end
    if not A.HammerofWrath:IsTalentLearned() then return end
    if unit.ehp < 50 then return end
    if not GetToggle(2, "ForceDps") then return end
    if player.holyPower == 5 then return end

    return spell:Cast(target)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### NORMAL DAMAGE ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Force Awakening Wings
Judgment:Callback('awakening', function(spell)
    if not target.exists then return end
    if target.isFriendly then return end

    -- In dungeons (5 players or less), allow Judgment freely
    -- In larger groups (raids), only use Judgment when we have the Awakening buff 414193
    if GetNumGroupMembers() > 5 and not player:Buff(buffs.awakeningbuff) then return end

    -- This callback is specifically for awakening, so we need both awakening buff and dawnlight
    if not player:Buff(buffs.awakeningbuff) then return end
    if not player:Buff(buffs.dawnlight) then return end

    return spell:Cast(target)
end)

-- Searing Glare
SearingGlare:Callback('DamagePvp', function(spell)
    if Action.Zone ~= "arena" then return end
    if not CanAttackTarget() then return end
    if (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50) or (player.hp < 50) then return end
    if target.distance > 20 then return end
    if isMoving then return end

    return spell:Cast()
end)

-- Consecration
Consecration:Callback('DamagePve', function(spell)
    if Action.Zone == "arena" then return end
    if not inMeleeRange then return end
    if isMoving then return end

    -- Drop Consecration every 12 seconds
    if gameState.lastConsecrationDrop and (GetTime() - gameState.lastConsecrationDrop) < 12 then return end
    gameState.lastConsecrationDrop = GetTime()
    return spell:Cast()
end)

-- Judgment
Judgment:Callback('DamagePve', function(spell)
    if Action.Zone == "arena" then return end
    if not CanAttackTarget() then return end
    if CantCreateHolyPower() then return end
    -- Prevent wasting Holy Power: if at 4 HP with Infusion of Light, spend HP first
    if player.holyPower >= 4 and player:Buff(buffs.infusionoflight) then return end
    -- In dungeons (5 players or less), allow Judgment freely
    -- In larger groups (raids), only use Judgment when we have the Awakening buff 414193
    if GetNumGroupMembers() > 5 and not player:Buff(buffs.awakeningbuff) then return end
    return spell:Cast(target)
end)

-- Judgment with Infusion
Judgment:Callback('InfusionofLight', function(spell)
    if not judgmentHandler() then return end
    if not CanAttackTarget() then return end
    if GetToggle(2, "Dropdown5") ~= "Judgment" then return end
    if not player:Buff(buffs.infusionoflight) then return end
    -- Prevent wasting Holy Power: if at 4 HP with Infusion of Light, spend HP first
    if player.holyPower >= 4 then return end

    return spell:Cast(target)
end)

-- HammerofWrath with Avenging Wrath: Prioritize during Wings
HammerofWrath:Callback('AvengingWrath', function(spell)
    if not player:Buff(buffs.avengingwrath) then return end
    if not A.HammerofWrath:IsTalentLearned() then return end
    if CantCreateHolyPower() then return end
    if not CanAttackTarget() then return end
    -- Prevent wasting Holy Power: if at 4 HP with Infusion of Light, spend HP first
    if player.holyPower >= 4 and player:Buff(buffs.infusionoflight) then return end

    return spell:Cast(target)
end)

-- HammerofWrath
HammerofWrath:Callback('DamagePve', function(spell)
    if not A.HammerofWrath:IsTalentLearned() then return end
    if CantCreateHolyPower() then return end

    return spell:Cast(target)
end)

-- DivineToll Damage
DivineToll:Callback('DamagePve', function(spell)
    if Action.Zone == "arena" then return end
    if GetToggle(2, "DtMenu") == "2" then return end -- Off for damage
    if player.holyPower >= 2 then return end

    -- If big healing soon, healing callback will handle; otherwise use for damage
    if MajorCooldownIsActive() then return end
    if AvengingWrath:Cooldown() < 8000 and not player:Buff(buffs.avengingwrath) then return end -- minor sync with Wings

    local needAdds = GetToggle(2, "DivineTollSlider")
    local enoughEnemies = enemiesInMelee() >= needAdds
    local singleTargetOK = Unit("target"):IsBoss() or target.isDummy or (needAdds <= 1)

    if not (enoughEnemies or singleTargetOK) then return end

    return spell:Cast(target)
end)

--Holy Shock DMG
HolyShockDMG:Callback('DamagePve', function(spell)
    if CantCreateHolyPower() then return end
    if player:Buff(buffs.risingsunlight) and player.holyPower > 2 then return end

    local hsMenu = GetToggle(2, "HSMenu")

    if hsMenu ~= "1" and hsMenu ~= "3" and (hsMenu ~= "4" or A.HolyShock:GetSpellCharges() < 2) then
        return
    end

    return spell:Cast(target)
end)

-- CrusaderStrike + CrusdersMight
CrusaderStrike:Callback('CrusdersMight', function(spell)
    if not CanAttackTarget() then return end
    if not GetToggle(2, "CrusdersMightBox") and A.CrusdersMight:IsTalentLearned() then return end
    if A.HolyShock:GetCooldown() < 2 then return end
    if CantCreateHolyPower() then return end

    return spell:Cast(target)
end)

-- CrusaderStrike
CrusaderStrike:Callback('DamagePve', function(spell)
    if not CanAttackTarget() then return end
    if GetToggle(2, "CrusdersMightBox") and A.CrusdersMight:IsTalentLearned() then return end
    if CantCreateHolyPower() then return end

    return spell:Cast(target)
end)

-- Aggressive dump
ShieldoftheRighteous:Callback('aggroDps', function(spell)
    if not CrusaderStrike:InRange(target) then return end

    if A.GetToggle(2, "aggroDps") then
        if player.holyPower >= 3 then
            return spell:Cast()
        end
    end
end)

--################################################################################################################################################################################################################

local function Untilities()
	Intercession('Utilities')
    Absolution('Utilities')
    RiteofSanctification('Utilities')
    RiteofAdjuration('Utilities')
end

local function PreCombat()
	CrusaderAura('PreCombat')
	DevotionAura('PreCombat')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function SelfDefensive()
	DivineShield('Defensive1')
	DivineProtection('Defensive1')
    BlessingofFreedom('Defensive1')
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

    LayOnHands('Emergency')
		EternalFlame('OathBound')
		WordofGlory('OathBound')


    LayOnHandsTalent('Emergency')
    BlessingofProtection('Emergency')
    BlessingofSacrifice('Emergency')

    BloodFury('Racials')
    Berserking('Racials')
    Fireblood('Racials')
    AncestralCall('Racials')
    BagOfTricks('Racials')

    BlessingofSpring('Blessing')
    BlessingofWinter('Blessing')

    Judgment('awakening')
    Judgment('AC')
    CrusaderStrike('AC')

    AvengingCrusader('AC')
	AvengingWrath('Cooldowns')
	AuraMastery('Cooldowns')
	TyrDeliverance('Cooldowns')
    BeaconofVirtue('Beacon')
	DivineToll('Cooldowns')
	HandofDivinity('Cooldowns')

    BlessingofSummer('Blessing')
    BlessingofAutumn('Blessing')

	HolyBulwark('HealingPve')
	SacredWeapon('HealingPve')

    HolyShock('2Charges')
    BarrierofFaith('HealingPve')
    HolyPrism('HealingPve')

    WordofGlory('Buffed')

    LightofDawn('5HP')
    WordofGlory('5HP')
    HolyLight('Divinity')



    Judgment('ForceInfusionofLight')
	FlashofLight('InfusionofLight')
	HolyLight('ForceInfusionofLight')
		FlashofLight('VirtueCompassion')


    Consecration('ForceDps')
    HammerofWrath('ForceDps')

	FlashofLight('DivineFavor')
	HolyLight('DivineFavor')

    LightofDawn('Default')
    WordofGlory('Default')

    CrusaderStrike('CrusdersMight')
    HolyShock('Default')

    Judgment('InfusionofLight')
	FlashofLight('InfusionofLight')
	HolyLight('InfusionofLight')

	FlashofLight('HealingPve')
	HolyLight('HealingPve')

	BeaconofLight('Beacon')
    BeaconofFaith('Player')
	BeaconofFaith('Beacon')

    HolyLight('OutofCombat')
    LightofDawn('Dump')
    WordofGlory('Dump')
    LightofDawn('DumpMana')
    WordofGlory('DumpMana')
    FlashofLight('arena')
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function DamageRotationPve()
    --if player.manaPct <= GetToggle(2, "ManaTresholdDpsSlider") then return end

    ShieldoftheRighteous('Dump')
    ShieldoftheRighteous('DumpMana')
	Consecration('DamagePve')
	Judgment('DamagePve')
	HammerofWrath('DamagePve')
    DivineToll('DamagePve')
    SearingGlare('DamagePvp')
	HolyShockDMG('DamagePve')
    CrusaderStrike('CrusdersMight')
	CrusaderStrike('DamagePve')
    ShieldoftheRighteous('aggroDps')
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

    --if Action.Zone == "arena" then
    --    FakeCasting.gglFakeCast(icon)
    --end

	local CantCast = CantCast()
	if CantCast then return FrameworkEnd() end

	isStaying   	= not player.moving
    stayingTime		= Player.stayTime
	movingTime  	= Player.moveTime
	isMoving 		= player.moving
	combatTime  	= (player and player.CombatTime and player:CombatTime()) or 0
	inMeleeRange	= CrusaderStrike:InRange(target)

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    makInterrupt(interrupts)
    ManageBeaconsArena()

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

-- Hoj healer if he is not in cc and has more than 50% dr
HammerofJustice:Callback("arena_healer", function(spell, enemy)
    if enemy.ccImmune then return end
    if not spell:InRange(enemy) then return end
    if not enemy:IsUnit(enemyHealer) then return end
    if enemy:Debuff(203337) then return end
    if enemy.stunDr < 0.5 then return end
    if enemy:IsTarget() then return end
    if enemy:CCRemains() > 1500 then return end
    if player:Debuff(410201) then return end
    Aware:displayMessage("HOJ - Enemy Healer", "Blue", 1)
    return spell:Cast(enemy)
end)

-- Hoj kill target if the enemy team's healer is cced for more than 2 seconds and the kill target is not in cc and has more than 50% dr and is lower than 50% hp
HammerofJustice:Callback("arena_kill", function(spell, enemy)
    if enemy.ccImmune then return end
    if not spell:InRange(enemy) then return end
    if not enemy:IsTarget() then return end
    if enemy:Debuff(203337) then return end
    --if enemy.stunDr < 0.5 then return end
    if enemy:IsUnit(enemyHealer) then return end
    if enemyHealer:CCRemains() < 2000 then return end
    --if not enemyHealer:HasDebuffFromFor(MakLists.CC, 500) then return end
    --if enemy.hp > 50 then return end
    if player:Debuff(410201) then return end

    if enemy.stunDr == 1 then
        Aware:displayMessage("HOJ - KT - Enemy Healer CCed", "Red", 1)
        return spell:Cast(enemy)
    end

    if enemy.stunDr < 0.5 and enemy.hp < 50 then
        Aware:displayMessage("HOJ - KT - Enemy Healer CCed", "Red", 1)
        return spell:Cast(enemy)
    end
end)

-- PVP Kick with Rebuke
Rebuke:Callback("arena", function(spell, enemy)
    if getBelowHP(50) >= 1 then return end
    if enemy:IsKickImmune() then return end
    if not spell:InRange(enemy) then return end
    if enemy.totalImmune then return end
    if enemy.physicalImmune then return end
    if enemy:CastingFromFor(MakLists.arenaKicks, 500) then
        Aware:displayMessage("Rebuke - Enemy Casting", "Red", 1)
        return spell:Cast(enemy)
    end
end)

--Repentance Enemy Healer if arena1, arena2, or arena3 is injured and not the healer
Repentance:Callback("arena", function(spell, enemy)
    if getBelowHP(50) >= 1 then return end
    if not enemy:IsUnit(enemyHealer) then return end
    if enemy:IsTarget() then return end
    if enemy.hp < 20 then return end
    if enemy.ccImmune then return end
    if enemy.totalImmune then return end
    if enemy.magicImmune then return end
    if enemy.incapacitateDr < 0.5 then return end
    if enemy.ccRemains > 1000 then return end
    if (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50) or (player.hp < 50) then return end
    if (arena1.exists and arena1.hp < 70) or (arena2.exists and arena2.hp < 70) or (arena3.exists and arena3.hp < 70) then
        Aware:displayMessage("Repentance - Enemy Healer", "Blue", 1)
        return spell:Cast(enemy)
    end
end)


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    HammerofJustice("arena_healer", enemy)
    HammerofJustice("arena_kill", enemy)
    Rebuke("arena", enemy)
    Repentance("arena", enemy)
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Cleanse:Callback("arenap", function(spell, friendly)
    if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
    if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
        return spell:Cast(friendly)
    end
end)

--Freedom friendly if they have a debuff from our freedom table for more than 500 ms
BlessingofFreedom:Callback("party", function(spell, friendly)
    if friendly:HasDeBuffFromFor(MakLists.freedom, 500) then
        return spell:Cast(friendly)
    end

    local suleymanClap = UnitPower("target") >= 90 and target.npcId == 212826
    if suleymanClap and friendly:ClassID() ~= 2 then -- Don't cast on other Paladins
        return spell:Cast(friendly)
    end
end)

-- BOP partry if they are lower than slider values and not total immune and friendly is not a paladin
BlessingofProtection:Callback("arena_party", function(spell, friendly)
    local hasPhys = MakMulti.arena:Any(function(enemy) return not enemy.isHealer and not enemy.isCaster end)
    if Action.Zone ~= "arena" then return end
    if not hasPhys then return end
    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return end
    if friendly.hp > 60 then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    if ((arena1.exists and not arena1:IsMelee()) and (arena2.exists and not arena2:IsMelee()) and (arena3.exists and not arena3:IsMelee())) then return end
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end
    if friendly:ClassID() == 2 and not friendly:IsMe() then return end
    --Aware:displayMessage("Blessing of Protection on Party", "White", 1)
    return spell:Cast(friendly)
end)

BlessingofSpellwarding:Callback("arena_party", function(spell, friendly)
    local hasMagicDamage = MakMulti.arena:Any(function(enemy) return not enemy.isHealer and enemy.isCaster end)
    if not hasMagicDamage then return end
    if friendly:IsMe() and DivineShield:Cooldown() < 2000 and not IsPlayerSpell(A.LightsRevocation.ID) then return end
    if friendly.hp > 60 then return end
    if friendly.hp > 40 and target.hp < 20 then return end
    --if ((arena1.exists and not arena1:IsMelee()) and (arena2.exists and not arena2:IsMelee()) and (arena3.exists and not arena3:IsMelee())) then return end
    if friendly:HasDeBuff(A.Forbearance.ID) then return end
    if friendly:IsTotalImmune() then return end
    if friendly:ClassID() == 2 and not friendly:IsMe()  then return end
    --Aware:displayMessage("Blessing of Spellwarding on Party", "White", 1)
    return spell:Cast(friendly)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    if not friendly.exists then return end

    BlessingofProtection("arena_party", friendly)
    BlessingofSpellwarding("arena_party", friendly)
    Cleanse("arenap", friendly)
    BlessingofFreedom("party", friendly)
end

--################################################################################################################################################################################################################

local stopCastingList = {
    [20066] = true, -- Repentance
    [414273] = true, -- Divinity
    [200652] = true, -- tyrs deliverance
}

A[6] = function(icon)
	RegisterIcon(icon)
    --if player is casting tyrsDeliverance or divinefavor and anyone in our party is below 50% then stop casting
    if player:CastingFromFor(stopCastingList, 420) and getBelowHP(40) >= 1 then
        StopCasting()
    end

    if targetForInterrupt(interrupts) then return TabTarget() end
    if autoTarget() then return TabTarget() end
    if Action.Zone == "arena" then
        partyRotation(party1)
        enemyRotation(arena1)
    end
	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[7] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(party2)
        enemyRotation(arena2)
    end
	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
        partyRotation(party3)
        enemyRotation(arena3)
    end
	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[9] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
	    partyRotation(party4)
    end
	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[10] = function(icon)
	RegisterIcon(icon)
    if Action.Zone == "arena" then
	    partyRotation(player)
    end
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

