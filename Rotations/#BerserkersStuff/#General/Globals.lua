local _G, select, setmetatable                           = _G, select, setmetatable
local TMW                                                = _G.TMW
local A                                                  = _G.Action
local Player                                             = A.Player
local Unit                                               = A.Unit
local GetToggle                                          = A.GetToggle
local GameLocale                                         = A.FormatGameLocale(_G.GetLocale())
local StdUi                                              = A.StdUi
local Factory                                            = StdUi.Factory
local math_random                                        = math.random
local ActiveUnitPlates                                   = A.MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit, UnitIsPlayer                = _G.IsIndoors, _G.UnitIsUnit, _G.UnitIsPlayer

local CONST                                              = A.Const
local ACTION_CONST_DRUID_RESTORATION                     = CONST.DRUID_RESTORATION
local ACTION_CONST_EVOKER_PRESERVATION                   = CONST.EVOKER_PRESERVATION
local ACTION_CONST_MONK_MISTWEAVER                       = CONST.MONK_MISTWEAVER
local ACTION_CONST_PALADIN_HOLY     	                 = CONST.PALADIN_HOLY
local ACTION_CONST_PRIEST_DISCIPLINE                     = CONST.PRIEST_DISCIPLINE
local ACTION_CONST_PRIEST_HOLY     		                 = CONST.PRIEST_HOLY
local ACTION_CONST_SHAMAN_RESTORATION                    = CONST.SHAMAN_RESTORATION
local ACTION_CONST_PRIEST_SHADOW  		                 = CONST.PRIEST_SAHDOW

--################################################################################################################################################################################################################

local isKeyCheckDone = true

--################################################################################################################################################################################################################

------------------------------------
--- Notification if profil is missing Globals
------------------------------------
StaticPopupDialogs["ACTION_BERSERKER_OUTDATED_VERSION"] = {
    text = "Error Detected! Missing essential global variables! Reinstall the profile immediately to ensure proper functionality!",
    button1 = "Close",
    OnAccept = function()
        StaticPopup_Hide ("ACTION_BERSERKER_OUTDATED_VERSION")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 2,
}

--Added this function inside of every snippet to avoid deleting the globals with the Auth Key system
function NoGlobalsAvialable()
    return true
end

StaticPopupDialogs["ACTION_BERSERKER_OUTDATED_INTERFACE"] = {
    text = "Error Detected! Missing essential Interface variables! Reinstall the profile immediately to ensure proper functionality!",
    button1 = "Close",
    OnAccept = function()
        StaticPopup_Hide ("ACTION_BERSERKER_OUTDATED_INTERFACE")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 2,
}

--################################################################################################################################################################################################################

-- Num/Bool helper functions
function num(val)
    if val then return 1 else return 0 end
end

function bool(val)
    return val ~= 0
end

--################################################################################################################################################################################################################

------------------------------------
--- IsBuffUp simc reference
------------------------------------
function Unit:IsBuffUp(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasBuffs(spell, byID) > 0
end

------------------------------------
--- IsBuffDown simc reference
------------------------------------
function Unit:IsBuffDown(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasBuffs(spell, byID) <= 0
end

------------------------------------
--- IsBuffRefreshable simc reference
------------------------------------
function Unit:IsBuffRefreshable(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasBuffs(spell, byID) <= 3
end

------------------------------------
--- IsBuffStacks simc reference
------------------------------------
function Unit:IsBuffStacks(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasBuffsStacks(spell, byID)
end

------------------------------------
--- IsDebuffUp simc reference
------------------------------------
function Unit:IsDebuffUp(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasDeBuffs(spell, byID) > 0
end

------------------------------------
--- IsDebuffDown simc reference
------------------------------------
function Unit:IsDebuffDown(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasDeBuffs(spell, byID) <= 0
end

------------------------------------
--- IsDebuffRefreshable simc reference
------------------------------------
function Unit:IsDebuffRefreshable(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasDeBuffs(spell, byID) <= 3
end

------------------------------------
--- IsDebuffStacks simc reference
------------------------------------
function Unit:IsDebuffStacks(spell, byID)
    local unitID = self.UnitID
    return self(unitID):HasDeBuffsStacks(spell, byID)
end

--################################################################################################################################################################################################################

------------------------------------
--- Cooldown toggle from Hero to Action
------------------------------------
function CDsON()
    return A.BurstIsON("player")
end


--################################################################################################################################################################################################################

--Function to check if we are in healer spec for the Healer Setup
function IsHealerSpec()
    return Unit("player"):HasSpec(ACTION_CONST_DRUID_RESTORATION) or Unit("player"):HasSpec(ACTION_CONST_EVOKER_PRESERVATION) or Unit("player"):HasSpec(ACTION_CONST_MONK_MISTWEAVER) or Unit("player"):HasSpec(ACTION_CONST_PALADIN_HOLY) or Unit("player"):HasSpec(ACTION_CONST_PRIEST_DISCIPLINE) or Unit("player"):HasSpec(ACTION_CONST_PRIEST_HOLY) or Unit("player"):HasSpec(ACTION_CONST_SHAMAN_RESTORATION)
end

--################################################################################################################################################################################################################

--#####################################################################################################################################################################################

------------------------------------
--- Function to check if we can Soothe
------------------------------------
function canSoothe()
    return A.Zone ~= "arena" and (A.AuraIsValid("target", "UseExpelEnrage", "Enrage") or Unit("target"):IsBuffUp(EnrageDispelTable))
end


--#####################################################################################################################################################################################

------------------------------------
--- Function that checks if im the target
-- used for UHDK if a harmful spell is casted and has us as target
------------------------------------
function imtarget()
    local unit = "target"
    if UnitExists(unit) and UnitExists(unit .. "target") and UnitIsUnit(unit .. "target", "player") then
        return true
    else
        return false
    end
end

--################################################################################################################################################################################################################

--################################################################################################################################################################################################################

------------------------------------
--- Function to check if we can damage
-- dont show any damage icon when one of the conditions below is met
-- mainly checks for immunity
------------------------------------
--#####################################################################################################################################################################################

--#####################################################################################################################################################################################
------------------------------------
--- Function to check stuff to avoid casting spells
-- Global Function for all A3 actions
------------------------------------
function CantCast()
    local player = Unit("player")
    local gcdTrershold = 0.25
    local isCasting = player:IsCastingRemains() > gcdTrershold
    local isChanneling = Player:IsChanneling()
    local isMistweaver = player:HasSpec(ACTION_CONST_MONK_MISTWEAVER)
    local isShadowPriest = player:HasSpec(ACTION_CONST_PRIEST_SHADOW)
    
    local channelCheck = isChanneling and not (isMistweaver or isShadowPriest)
    local castingCheck = isCasting and not (isMistweaver or isShadowPriest)

    local isGhostWolfOrTravelFormAndMoving = (player:IsBuffUp(2645) or player:IsBuffUp(783)) and Player:IsMoving()
    
    return castingCheck or
           channelCheck or
           A.GetCurrentGCD() > gcdTrershold or
           A.LossOfControl:Get("STUN") ~= 0 or 
           Player:IsMounted() or 
           player:IsDebuffUp(240447) or  --Quaking
           isGhostWolfOrTravelFormAndMoving
end


-- Constants
local CRITICAL_DEBUFFS = {225484, 428542, 421326, 415624, 196376}

-- Get the appropriate unit ID
local function GetUnitID()
    if A.IsUnitFriendly("target") then
        return "target"
    elseif A.IsUnitFriendly("focus") then
        return "focus"
    else
        return nil
    end
end

-- Get valid unit object
local function GetValidUnit(unitID)
    -- Try to get a valid unit ID; if none, use the provided unitID
    unitID = GetUnitID() or unitID
    -- Return the unit object if unitID is valid, else nil
    return unitID and Unit(unitID) or nil
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AutoHeal function
function AutoHeal(unitID, spell)
    local unit = GetValidUnit(unitID)
    if not unit or not spell then
        return false
    end

    -- Get the base healing value from the spell
    local healingDescription = spell:GetSpellDescription()
    local healingValue = healingDescription and healingDescription[1] or 0

    -- Get the sensitivity multiplier from settings
    local sensitivityMultiplier = GetToggle(2, "AutoHealSensitivitySlider") or 1

    -- Calculate the unit's health deficit
    local healthDeficit = unit:HealthDeficit()

    -- Calculation of healing values and damages
    local ongoingHealing = unit:GetHEAL()                 -- Ongoing heals
    local incomingHealing = unit:GetIncomingHeals()       -- Incoming heals
    local absorption = unit:GetAbsorb()                   -- Absorption from shields
    local healingAbsorb = unit:GetTotalHealAbsorbs()      -- Healing absorption debuffs
    local incomingDamage = unit:GetDMG()                  -- Incoming damage

    -- Calculation of the total effective healing value
    local calculatedValue = (healingValue * sensitivityMultiplier) + ongoingHealing + incomingHealing + absorption - incomingDamage - healingAbsorb

    -- Check if healing is needed
    return healthDeficit > calculatedValue
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AutoHealOrSlider function
function AutoHealOrSlider(unitID, spellObject, sliderValue)
    local unit = GetValidUnit(unitID)
    if not unit then
        return false
    end

    -- If slider value is 100 or more, use AutoHeal logic
    if sliderValue >= 100 then
        return AutoHeal(unitID, spellObject)
    end

    -- Heal if unit's health percent is less than or equal to sliderValue
    if unit:HealthPercent() <= sliderValue then
        return true
    end

    -- Heal if unit has any critical debuff
    for _, debuffID in ipairs(CRITICAL_DEBUFFS) do
        if unit:IsDebuffUp(debuffID) then
            return true
        end
    end

    return false
end

--################################################################################################################################################################################################################

-- Global Function for Single Target/Tank Cooldowns
function CanStCooldown(unitID)
    if not IsHealerSpec() or Unit("player"):CombatTime() == 0 then return false end

    local unit = Unit(unitID)
    local healthPercent = unit:HealthPercent()
    local isTakingDamage = unit:GetRealTimeDMG() > 0
    
    if not isTakingDamage then return false end

    local isTank = unit:Role("TANK")
    local isFocused = unit:IsFocused()
    
    return (isFocused and healthPercent <= 65) or
           (isTank and healthPercent <= 45) or
           (not (isTank or isFocused) and healthPercent <= 25 and unit:TimeToDie() < 4)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Global Function for AoE Spells
function CanUseAoeHealing()
    if not IsHealerSpec() or not GetToggle(2, "AoE") then return false end

    local friendlySize = A.TeamCache.Friendly.Size
    local below95, below90, below85 = A.HealingEngine.GetBelowHealthPercentUnits(95, nil),
                                      A.HealingEngine.GetBelowHealthPercentUnits(90, nil),
                                      A.HealingEngine.GetBelowHealthPercentUnits(85, nil)

    if friendlySize == 0 then return false end

    return (friendlySize <= 5 and (below95 >= 5 or below90 >= 4 or below85 >= math.min(3, friendlySize))) or
           (friendlySize > 5 and (below95 >= 7 or below90 >= 6 or below85 >= 5))
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Global Function for Healing Cooldowns
function CanUseHealingCooldowns()
    if not IsHealerSpec() or not A.BurstIsON("player") or Unit("player"):CombatTime() == 0 then return false end

    local friendlySize = A.TeamCache.Friendly.Size
    local below80, below75, below70 = A.HealingEngine.GetBelowHealthPercentUnits(80, nil),
                                      A.HealingEngine.GetBelowHealthPercentUnits(75, nil),
                                      A.HealingEngine.GetBelowHealthPercentUnits(70, nil)

    local isArena = A.Zone == "arena"
    local arenaCondition = isArena and (A.HealingEngine.GetBelowHealthPercentUnits(40, nil) >= 1 or
                                        A.HealingEngine.GetBelowHealthPercentUnits(50, nil) >= 2 or
                                        A.HealingEngine.GetBelowHealthPercentUnits(60, nil) >= 3)

    return (friendlySize <= 5 and (below80 >= 5 or below75 >= 4 or below70 >= 3 or arenaCondition)) or
           (friendlySize > 5 and (below80 >= 7 or below75 >= 6 or below70 >= 5))
end

--################################################################################################################################################################################################################

local isHealerSetupComplete = false

local function SetToggleToValue(category, toggleName, displayName, targetValue)
    if GetToggle(category, toggleName) ~= targetValue then
        A.SetToggle({category, toggleName, displayName}, targetValue)
    end
end

local function ApplyToggleOptions(options)
    for _, option in ipairs(options) do
        local category, toggleName, targetState = unpack(option)
        local currentOptions = GetToggle(category, toggleName)
        
        -- Überprüfen, ob wir die "PredictOptions" anpassen und Option 5 immer deaktivieren
        if toggleName == "PredictOptions" then
            for i = 1, #currentOptions do
                if i == 1 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = true })
                elseif i == 2 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = true })
                elseif i == 3 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = false })
                elseif i == 4 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = true })
                elseif i == 5 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = false })
                elseif i == 6 then
                    A.SetToggle({category, toggleName, nil, true}, { [i] = true })
                else
                    A.SetToggle({category, toggleName, nil, true}, { [i] = targetState })
                end
            end
        else
            -- Normale Behandlung für alle anderen Optionen
            for i = 1, #currentOptions do
                A.SetToggle({category, toggleName, nil, true}, { [i] = targetState })
            end
        end
    end
end

function SetUpHealers()
    if not GetToggle(2, "SetupHealingTab") or isHealerSetupComplete or not IsHealerSpec() then
        return false
    end

    -- Apply toggle options
    local toggleOptions = {
        {8, "SelectStopOptions", false},  -- Always disable
        {8, "PredictOptions", false}       -- Always enable
    }
    ApplyToggleOptions(toggleOptions)

    -- Set specific toggles
    local specificToggles = {
        {8, "MultiplierIncomingDamageLimit", "Incoming Damage Limit: ", 1},
        {8, "MultiplierThreat", "Threat: ", 1},
        {8, "MultiplierPetsInCombat", "Pets In Combat: ", 1},
        {8, "MultiplierPetsOutCombat", "Pets Out Combat: ", 1}
    }
    for _, toggle in ipairs(specificToggles) do
        SetToggleToValue(unpack(toggle))
    end

    -- Disable specific UI settings
    local uiSettingsToDisable = {
        {8, "SelectPets", "Enable Pets: "},
        {8, "SelectResurrects", "Enable Resurrects: "},
        {1, "ReTarget", "ReTarget: "},
        {1, "ReFocus", "ReFocus: "}
    }
    for _, setting in ipairs(uiSettingsToDisable) do
        if GetToggle(setting[1], setting[2]) then
            A.SetToggle(setting, nil)
        end
    end

    if A.GetToggle({8, "PredictOptions", "Predict Options: 5"}, true) then
        A.SetToggle({8, "PredictOptions", "Predict Options: 5"}, false)
    end


    -- Set sort method to HP if it's AHP
    if GetToggle(8, "SelectSortMethod") == "AHP" then 
        A.SetToggle({8, "SelectSortMethod", "Target Sort Method:"}, "HP")
    end

    -- Enable stop damage on breakable
    if not GetToggle(1, "StopAtBreakAble") then 
        A.SetToggle({1, "StopAtBreakAble", "Stop Damage On BreakAble: "})
    end

    -- Disable large number breakdown
    C_CVar.SetCVar("breakUpLargeNumbers", 0)

    isHealerSetupComplete = true
    return true
end

--########################################################################################################################################################################################################################################################################################################################################################################

------------------------------------
--- Interrupt List in Action to make it visible for Users which spells are inside of the passiv Interrupt function and to use it for BGs and Epic BGs
------------------------------------
local L = setmetatable(
    {enUS = {InterruptName = "[Berserker]Pvp Interrupts",},}, 
    { __index = function(t) return t.enUS end })

TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
    local CL = A.GetCL()
    Category.options[#Category.options + 1] = { text = L[GameLocale].InterruptName, value = "BerserkerPvpInterrupts" }
    Category:SetOptions(Category.options)
end)

Factory[4].BerserkerPvpInterrupts = StdUi:tGenerateMinMax({
    [GameLocale] = {
        ISINTERRUPT = true,
        [5143]      = { useKick = true, useCC = false, useRacial = false  },      -- Arcane Missles
        [365350]    = { useKick = true, useCC = false, useRacial = false  },      -- Arcane Surge
        [1064]      = { useKick = true, useCC = false, useRacial = false  },      -- Chain Heal
        [116858]    = { useKick = true, useCC = false, useRacial = false  },      -- Chaos Bolt
        [323764]    = { useKick = true, useCC = false, useRacial = false  },      -- Convoke the Spirits
        [33786]     = { useKick = true, useCC = false, useRacial = false  },      -- Cyclone
        [356995]    = { useKick = true, useCC = false, useRacial = false  },      -- Disintegrate
        [64843]     = { useKick = true, useCC = false, useRacial = false  },      -- Divine Hymn
        [234153]    = { useKick = true, useCC = false, useRacial = false  },      -- Drain Life
        [376788]    = { useKick = true, useCC = false, useRacial = false  },      -- Dream Breath
        [377509]    = { useKick = true, useCC = false, useRacial = false  },      -- Dream Projection
        [395152]    = { useKick = true, useCC = false, useRacial = false  },      -- Ebon Might
        [339]       = { useKick = true, useCC = false, useRacial = false  },      -- Entangling Roots
        [124682]    = { useKick = true, useCC = false, useRacial = false  },      -- Enveloping Mist
        [395160]    = { useKick = true, useCC = false, useRacial = false  },      -- Eruption
        --[191837]    = { useKick = true, useCC = false, useRacial = false  },      -- Essence Font
        [359073]    = { useKick = true, useCC = false, useRacial = false  },      -- Eternity Surge
        [12051]     = { useKick = true, useCC = false, useRacial = false  },      -- Evocation
        [5782]      = { useKick = true, useCC = false, useRacial = false  },      -- Fear
        [2061]      = { useKick = true, useCC = false, useRacial = false  },      -- Flash Heal
        [19750]     = { useKick = true, useCC = false, useRacial = false  },      -- Flash of Light
        [202771]    = { useKick = true, useCC = false, useRacial = false  },      -- Full Moon
        [199786]    = { useKick = true, useCC = false, useRacial = false  },      -- Glacial Spike
        [289666]    = { useKick = true, useCC = false, useRacial = false  },      -- Greater Heal
        [120517]    = { useKick = true, useCC = false, useRacial = false  },      -- Halo
        [105174]    = { useKick = true, useCC = false, useRacial = false  },      -- Hand of Gul'dan
        [2060]      = { useKick = true, useCC = false, useRacial = false  },      -- Heal
        [8004]      = { useKick = true, useCC = false, useRacial = false  },      -- Healing Surge
        [77472]     = { useKick = true, useCC = false, useRacial = false  },      -- Healing Wave
        [51514]     = { useKick = true, useCC = false, useRacial = false  },      -- Hex
        [82326]     = { useKick = true, useCC = false, useRacial = false  },      -- Holy Light
        [265202]    = { useKick = true, useCC = false, useRacial = false  },      -- Holy Word: Salvation
        [305483]    = { useKick = true, useCC = false, useRacial = false  },      -- Lightning Lasso
        [305484]    = { useKick = true, useCC = false, useRacial = false  },      -- Lightning Lasso 2
        [305485]    = { useKick = true, useCC = false, useRacial = false  },      -- Lightning Lasso 2
        [204437]    = { useKick = true, useCC = false, useRacial = false  },      -- Lightning Lasso 2
        [32375]     = { useKick = true, useCC = false, useRacial = false  },      -- Mass Dispel
        [323701]    = { useKick = true, useCC = false, useRacial = false  },      -- Mindgames
        [289022]    = { useKick = true, useCC = false, useRacial = false  },      -- Nourish
        [378464]    = { useKick = true, useCC = false, useRacial = false  },      -- Nullifying Shroud
        [47540]     = { useKick = true, useCC = false, useRacial = false  },      -- Penance
        [186723]    = { useKick = true, useCC = false, useRacial = false  },      -- Penance
        [118]       = { useKick = true, useCC = false, useRacial = false  },      -- Polymorph
        [194509]    = { useKick = true, useCC = false, useRacial = false  },      -- Power Word: Radiance
        [596]       = { useKick = true, useCC = false, useRacial = false  },      -- Prayer of Healing
        [33076]     = { useKick = true, useCC = false, useRacial = false  },      -- Prayer of Mending
        [205021]    = { useKick = true, useCC = false, useRacial = false  },      -- Ray of Frost
        [20484]     = { useKick = true, useCC = false, useRacial = false  },      -- Rebirth
        [8936]      = { useKick = true, useCC = false, useRacial = false  },      -- Regrowth
        [20066]     = { useKick = true, useCC = false, useRacial = false  },      -- Repentance
        [113724]    = { useKick = true, useCC = false, useRacial = false  },      -- Ring of Frost
        [410126]    = { useKick = true, useCC = false, useRacial = false  },      -- Searing Glare
        [30283]     = { useKick = true, useCC = false, useRacial = false  },      -- Shadowfury
        [360806]    = { useKick = true, useCC = false, useRacial = false  },      -- Sleep Walk
        [198898]    = { useKick = true, useCC = false, useRacial = false  },      -- Song of Chi-ji
        [115175]    = { useKick = true, useCC = false, useRacial = false  },      -- Soothing Mist
        [386997]    = { useKick = true, useCC = false, useRacial = false  },      -- Soul Rot
        [367226]    = { useKick = true, useCC = false, useRacial = false  },      -- Spiritbloom
        [265187]    = { useKick = true, useCC = false, useRacial = false  },      -- Summon Demonic Tyrant
        [227344]    = { useKick = true, useCC = false, useRacial = false  },      -- Surging Mist
        [404977]    = { useKick = true, useCC = false, useRacial = false  },      -- Time Skip
        [200652]    = { useKick = true, useCC = false, useRacial = false  },      -- Tyr's Deliverance
        [421453]    = { useKick = true, useCC = false, useRacial = false  },      -- Ultimate Penitence
        [30108]     = { useKick = true, useCC = false, useRacial = false  },      -- Unstable Affliction
        [396286]    = { useKick = true, useCC = false, useRacial = false  },      -- Upheaval
        [34914]     = { useKick = true, useCC = false, useRacial = false  },      -- Vampiric Touch
        [116670]    = { useKick = true, useCC = false, useRacial = false  },      -- Vivify
        [263165]    = { useKick = true, useCC = false, useRacial = false  },      -- Void Torrent
        [48438]     = { useKick = true, useCC = false, useRacial = false  },      -- Wild Growth
        [417537]    = { useKick = true, useCC = false, useRacial = false  },      -- Oblivion
        [390612]    = { useKick = true, useCC = false, useRacial = false  },      -- Frost Bomb
   },
}, 43, 70, math_random(87, 95), true)

--########################################################################################################################################################################################################################################################################################################################################################################

------------------------------------
--- Interrupt List for Season 3 PVE
------------------------------------
local L = setmetatable(
    {
        ruRU = {InterruptName         = "[Berserker]Season 3 Interrupts",},
        enUS = {InterruptName         = "[Berserker]Season 3 Interrupts",},
    }, 
    { __index = function(t) return t.enUS end })

TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
        local CL = A.GetCL()
        Category.options[#Category.options + 1] = { text = L[GameLocale].InterruptName, value = "BerserkerS3Interrupts" }
        Category:SetOptions(Category.options)
end)

Factory[4].BerserkerS3Interrupts = StdUi:tGenerateMinMax({
    [GameLocale] = {
        ISINTERRUPT = true,
        --DAWN OF THE INFINITE (BOTH SECTIONS)
        [411994] = { useKick = true, useCC = false, useRacial = false       }, -- Chronomelt
        [412012] = { useKick = false, useCC = true, useRacial = true        }, -- Temposlice
        [415770] = { useKick = true, useCC = false, useRacial = false       }, -- Infinite Bolt Volley
        [415435] = { useKick = true, useCC = true, useRacial = true         }, -- Infinite Bolt
        [415437] = { useKick = true, useCC = true, useRacial = true         }, --  Enervate
        [416256] = { useKick = true, useCC = true, useRacial = true         }, -- Stonebolt
        [400165] = { useKick = true, useCC = false, useRacial = false       }, -- Epoch Bolt
        [413607] = { useKick = false, useCC = true, useRacial = true        }, -- Corroding Volley
        --[412924] = { useKick = true, useCC = false, useRacial = false     }, -- Binding Grasp (need to be in shrouding sandstorm (412212))
        [417481] = { useKick = true, useCC = false, useRacial = false       }, -- Displace Chronosequence
        [419327] = { useKick = false, useCC = true, useRacial = true        }, -- Infinite Schism
        [412378] = { useKick = true, useCC = false, useRacial = false       }, -- Dizzying Sands
        [412233] = { useKick = true, useCC = true, useRacial = true         }, -- Rocket Bolt Volley
        [413427] = { useKick = true, useCC = false, useRacial = false       }, -- Time Beam
        [407535] = { useKick = false, useCC = true, useRacial = true        }, -- Deploy Goblin Sappers

        --WAYCREST MANOR
        [267824] = { useKick = true, useCC = true, useRacial = true         }, -- Scar Soul
        [265368] = { useKick = true, useCC = true, useRacial = true         }, -- Spirited Defense
        [426541] = { useKick = true, useCC = true, useRacial = true         }, -- Runic Bolt
        [264390] = { useKick = true, useCC = true, useRacial = true         }, -- Spellbind
        [263959] = { useKick = true, useCC = true, useRacial = true         }, -- Soul Volley
        [314992] = { useKick = true, useCC = true, useRacial = true         }, -- Drain Essence
        [264050] = { useKick = true, useCC = true, useRacial = true         }, -- Infected Thorn
        [260700] = { useKick = true, useCC = false, useRacial = false       }, -- Ruinous Bolt
        [260701] = { useKick = true, useCC = false, useRacial = false       }, -- Bramble Bolt
        [265346] = { useKick = true, useCC = true, useRacial = true         }, -- Pallid Glare
        [264520] = { useKick = true, useCC = true, useRacial = true         }, -- Severing Serpent
        [324589] = { useKick = true, useCC = true, useRacial = true         }, -- Soul Bolt
        [265876] = { useKick = true, useCC = true, useRacial = true         }, -- Ruinous Volley
        [268202] = { useKick = true, useCC = true, useRacial = true         }, -- Death Lens

        --ATAL'DAZAR
        [253517] = { useKick = true, useCC = true, useRacial = true         }, -- Mending Word
        [383489] = { useKick = true, useCC = true, useRacial = true         }, -- Wildfire
        [253583] = { useKick = true, useCC = true, useRacial = true         }, -- Fiery Enchant
        [255041] = { useKick = true, useCC = true, useRacial = true         }, -- Terrifying Screech
        [256849] = { useKick = true, useCC = false, useRacial = false       }, -- Dino Might
        [252923] = { useKick = true, useCC = true, useRacial = true         }, -- Venom Blast
        [252781] = { useKick = true, useCC = true, useRacial = true         }, -- Unstable Hex
        [253721] = { useKick = false, useCC = true, useRacial = true        }, -- Bulwark of Juju
        [259572] = { useKick = true, useCC = false, useRacial = false       }, -- Noxious Stench
        [250096] = { useKick = true, useCC = false, useRacial = false       }, -- Wracking Pain

        --DARKHEART THICKET
        [200630] = { useKick = true, useCC = true, useRacial = true         }, -- Unnerving Screech
        [357144] = { useKick = true, useCC = true, useRacial = true         }, -- Despair
        [204243] = { useKick = true, useCC = true, useRacial = true         }, -- Tormenting Eye
        [201298] = { useKick = true, useCC = true, useRacial = true         }, -- Bloodbolt
        [225562] = { useKick = false, useCC = true, useRacial = true        }, -- Blood Metamorphosis
        [201399] = { useKick = true, useCC = true, useRacial = true         }, -- Dread Inferno
        [201837] = { useKick = true, useCC = true, useRacial = true         }, -- Shadow Bolt
        [225568] = { useKick = true, useCC = true, useRacial = true         }, -- Curse of Isolation

        --BLACK ROOK HOLD
        [199663] = { useKick = true, useCC = true, useRacial = true         }, -- Soul Blast
        [196883] = { useKick = true, useCC = true, useRacial = true         }, -- Spirit Blast
        [200248] = { useKick = true, useCC = true, useRacial = true         }, -- Arcane Blitz
        [200291] = { useKick = false, useCC = true, useRacial = true        }, -- Knife Dance
        [201139] = { useKick = false, useCC = true, useRacial = true        }, -- Brutal Assault
        [227913] = { useKick = true, useCC = true, useRacial = true         }, -- Felfrenzy

        --THRONE OF THE TIDES
        [76813] = { useKick = true, useCC = true, useRacial = true          }, -- Healing Wave
        [76820] = { useKick = true, useCC = true, useRacial = true          }, -- Hex
        [426768] = { useKick = true, useCC = true, useRacial = true         }, -- Lightning Bolt
        [117163] = { useKick = true, useCC = true, useRacial = true         }, -- Water Bolt
        [426905] = { useKick = false, useCC = true, useRacial = true        }, -- Psionic Pulse
        [429176] = { useKick = true, useCC = true, useRacial = true         }, -- Aquablast
        [428526] = { useKick = true, useCC = false, useRacial = false       }, -- Ink Blast

        --THE EVERBLOOM
        [164973] = { useKick = true, useCC = true, useRacial = true         }, -- Dancing Thorns
        [164965] = { useKick = true, useCC = true, useRacial = true         }, -- Choking Vines
        [165213] = { useKick = true, useCC = true, useRacial = true         }, -- Enraged Growth
        [164887] = { useKick = true, useCC = true, useRacial = true         }, -- Healing Waters
        [427459] = { useKick = true, useCC = false, useRacial = false       }, -- Toxic Bloom
        [212040] = { useKick = true, useCC = false, useRacial = false       }, -- Revitalize
        [420334] = { useKick = true, useCC = false, useRacial = false       }, -- Nature's Wrath
        [169825] = { useKick = true, useCC = true, useRacial = true         }, -- Arcane Blast
        [169841] = { useKick = true, useCC = true, useRacial = true         }, -- Arcane Blast (not sure which of the two IDs to use)
        [169839] = { useKick = true, useCC = true, useRacial = true         }, -- Pyroblast
        [169840] = { useKick = true, useCC = true, useRacial = true         }, -- Frostbolt
        [176000] = { useKick = true, useCC = true, useRacial = true         }, -- Lasher Venom

        --ALGETH'AR ACADEMY
        [396812] = { useKick = true, useCC = true, useRacial = true,        }, --Mystic Blast
        [388392] = { useKick = true, useCC = true, useRacial = true,        }, --Monotonous Lecture
        [388863] = { useKick = true, useCC = true, useRacial = true,        }, --Mana Void
        [377389] = { useKick = true, useCC = true, useRacial = true,        }, --Call of the Flock
        [396640] = { useKick = true, useCC = true, useRacial = true,        }, --Healing Touch
        [387843] = { useKick = true, useCC = true, useRacial = true,        }, --Astral Bomb
        
        --COURT OF STARS
        [209413] = { useKick = true, useCC = true, useRacial = true,        }, --Suppress
        [207980] = { useKick = true, useCC = true, useRacial = true,        }, --Disintegration Beam
        [208165] = { useKick = true, useCC = true, useRacial = true,        }, --Withering Soul   
        [214692] = { useKick = true, useCC = false, useRacial = false,      }, --Shadow Bolt Volley
        [210261] = { useKick = false, useCC = true, useRacial = true,       }, --Sound Alarm
        [211401] = { useKick = true, useCC = true, useRacial = false,       }, --Drifting Embers
        
        --HALLS OF VALOR
        [198595] = { useKick = true, useCC = true, useRacial = true,        }, --Thunderous Bolt
        [215433] = { useKick = true, useCC = true, useRacial = true,        }, --Holy Radiance
        [192288] = { useKick = true, useCC = true, useRacial = true,        }, --Searing Light
        [199726] = { useKick = true, useCC = false, useRacial = false,      }, --Unruly Yell  
        [198750] = { useKick = true, useCC = false, useRacial = false,      }, --Surge 
        
        --RUBY LIFE POOLS 
        [372749] = { useKick = true, useCC = true, useRacial = true,        }, --Ice Shield 
        [372735] = { useKick = false, useCC = true, useRacial = true,       }, --Tectonic Slam 
        [373803] = { useKick = true, useCC = true, useRacial = true,        }, --Cold Claws 
        [373017] = { useKick = true, useCC = false, useRacial = false,      }, --Roaring Blaze
        [392451] = { useKick = true, useCC = true, useRacial = true,        }, --Flashfire
        [385310] = { useKick = true, useCC = true, useRacial = true,        }, --Lightning Bolt
        
        --SHADOWMOON BURIAL GROUNDS
        [152818] = { useKick = true, useCC = true, useRacial = true,        }, --Shadow Mend
        [152814] = { useKick = true, useCC = true, useRacial = true,        }, --Shadow Bolt
        [156776] = { useKick = true, useCC = true, useRacial = true,        }, --Rending Voidlash
        [156722] = { useKick = true, useCC = true, useRacial = true,        }, --Void Bolt
        [156718] = { useKick = true, useCC = true, useRacial = true,        }, --Necrotic Burst
        [153524] = { useKick = true, useCC = true, useRacial = true,        }, --Plague Spit
        
        --TEMPLE OF THE JADE SERPENT
        [397888] = { useKick = true, useCC = true, useRacial = true,        }, --Hydrolance
        [397889] = { useKick = true, useCC = true, useRacial = true,        }, --Tidal Burst
        [395859] = { useKick = true, useCC = true, useRacial = true,        }, --Haunting Scream
        [396073] = { useKick = true, useCC = true, useRacial = true,        }, --Cat Nap    
        [397914] = { useKick = true, useCC = true, useRacial = true,        }, --Defiling Mist  
        
        --AZURE VAULT
        [375602] = { useKick = true, useCC = true, useRacial = true,        }, --Erratic Growth 
        [387564] = { useKick = true, useCC = true, useRacial = true,        }, --Mystic Vapors
        [370225] = { useKick = true, useCC = true, useRacial = true,        }, --Shriek
        [386546] = { useKick = true, useCC = true, useRacial = true,        }, --Waking Bane
        [389804] = { useKick = true, useCC = true, useRacial = true,        }, --Heavy Tome
        [377488] = { useKick = true, useCC = true, useRacial = true,        }, --Icy Bindings
        [373932] = { useKick = true, useCC = true, useRacial = true,        }, --Illusionary Bolts
        
        --THE NOKHUD OFFENSIVE
        [383823] = { useKick = true, useCC = true, useRacial = true,        }, --Rally the Clan
        [384365] = { useKick = true, useCC = true, useRacial = true,        }, --Disruptive Shout
        [386024] = { useKick = true, useCC = true, useRacial = true,        }, --Tempest
        [387411] = { useKick = true, useCC = true, useRacial = true,        }, --Death Bolt Volley     
        [387440] = { useKick = false, useCC = true, useRacial = true,       }, --Desecrating Roar
        [387606] = { useKick = true, useCC = true, useRacial = true,        }, --Dominate
        [382077] = { useKick = false, useCC = true, useRacial = true,       }, --Command: Seek
        [373395] = { useKick = true, useCC = true, useRacial = true,        }, --Bloodcurdling Shout
        [376725] = { useKick = true, useCC = true, useRacial = true,        }, --Storm Bolt
        
        --BRACKENHIDE HOLLOW
        [367503] = { useKick = true, useCC = true, useRacial = true,        }, --Withering Burst
        [367500] = { useKick = true, useCC = true, useRacial = true,        }, --Hideous Cackle
        [377950] = { useKick = true, useCC = false, useRacial = false,      }, --Greater Healing Rapids
        [385029] = { useKick = true, useCC = false, useRacial = false,      }, --Screech
        [373804] = { useKick = true, useCC = false, useRacial = false,      }, --Touch of Decay
        [381770] = { useKick = true, useCC = true, useRacial = true,        }, --Gushing Ooze
        [382474] = { useKick = true, useCC = true, useRacial = true,        }, --Decay Surge
        [374544] = { useKick = true, useCC = true, useRacial = true,        }, --Burst of Decay
        
        --FREEHOLD
        [257397] = { useKick = true, useCC = true, useRacial = true,        }, --Healing Balm
        [256060] = { useKick = true, useCC = false, useRacial = false,      }, --Revitalizing Brew
        [258777] = { useKick = true, useCC = true, useRacial = true,        }, --Sea Spout
        [257732] = { useKick = true, useCC = true, useRacial = true,        }, --Shattering Bellow
        [257784] = { useKick = true, useCC = true, useRacial = true,        }, --Frost Blast
        [281420] = { useKick = true, useCC = true, useRacial = true,        }, --Water Bolt
        [259092] = { useKick = true, useCC = true, useRacial = true,        }, --Lightning Bolt
        [257736] = { useKick = true, useCC = true, useRacial = true,        }, --Thundering Squall
       
        --HALLS OF INFUSION
        [374066] = { useKick = true, useCC = true, useRacial = true,        }, --Earth Shield
        [374339] = { useKick = true, useCC = true, useRacial = true,        }, --Demoralizing Shout
        [374045] = { useKick = true, useCC = true, useRacial = true,        }, --Expulse
        [374080] = { useKick = true, useCC = true, useRacial = true,        }, --Blasting Gust
        [389443] = { useKick = true, useCC = true, useRacial = true,        }, --Purifying Blast
        [395694] = { useKick = true, useCC = true, useRacial = true,        }, --Elemental Focus
        [374563] = { useKick = true, useCC = true, useRacial = true,        }, --Dazzle
        [374706] = { useKick = true, useCC = false, useRacial = false,      }, --Pyretic Burst
        [374699] = { useKick = true, useCC = false, useRacial = false,      }, --Cauterize
        [375384] = { useKick = true, useCC = true, useRacial = true,        }, --Rumbling Earth
        [385141] = { useKick = true, useCC = true, useRacial = true,        }, --Thunderstorm
        [375950] = { useKick = true, useCC = true, useRacial = true,        }, --Ice Shard
        [377348] = { useKick = true, useCC = true, useRacial = true,        }, --Tidal Divergence
        [377402] = { useKick = true, useCC = true, useRacial = true,        }, --Aqueous Barrier
        [387618] = { useKick = true, useCC = true, useRacial = true,        }, --Infuse
       
        --NELTHARION'S LAIR
        [183465] = { useKick = false, useCC = true, useRacial = true,       }, --Viscid Bile
        
        --NELTHARUS
        [378282] = { useKick = true, useCC = true, useRacial = true,        }, --Molten Core    
        [378818] = { useKick = false, useCC = true, useRacial = true,       }, --Magma Conflagration    
        [372615] = { useKick = true, useCC = true, useRacial = true,        }, --Ember Reach 
        [395427] = { useKick = true, useCC = true, useRacial = true,        }, --Burning Roar  
        [372538] = { useKick = true, useCC = true, useRacial = true,        }, --Melt
        [384161] = { useKick = true, useCC = true, useRacial = true,        }, --Mote of Combustion 
        [396925] = { useKick = true, useCC = true, useRacial = true,        }, --Lava Bolt        
       
        --ULDAMAN
        [369675] = { useKick = true, useCC = true, useRacial = true,        }, --Chain Lightning
        [369674] = { useKick = true, useCC = true, useRacial = true,        }, --Stone Spike
        [369603] = { useKick = true, useCC = false, useRacial = false,      }, --Defensive Bulwark
        [369399] = { useKick = true, useCC = true, useRacial = true,        }, --Stone Bolt
        [369465] = { useKick = false, useCC = true, useRacial = true,       }, --Hail of Stone
        [369400] = { useKick = true, useCC = true, useRacial = true,        }, --Earthen Ward
        [369365] = { useKick = true, useCC = true, useRacial = true,        }, --Curse of Stone
        [369411] = { useKick = true, useCC = true, useRacial = true,        }, --Sonic Burst
        
        --UNDERROT
        [265081] = { useKick = true, useCC = true, useRacial = true,        }, --Warcry
        [265376] = { useKick = false, useCC = true, useRacial = true,       }, --Barbed Spear
        [265089] = { useKick = true, useCC = true, useRacial = true,        }, --Dark Reconstitution
        [278755] = { useKick = true, useCC = true, useRacial = true,        }, --Harrowing Despair
        [260879] = { useKick = true, useCC = true, useRacial = true,        }, --Blood Bolt
        [265540] = { useKick = false, useCC = true, useRacial = true,       }, --Rotten Bile
        [266106] = { useKick = true, useCC = true, useRacial = true,        }, --Sonic Screech
        [278961] = { useKick = true, useCC = true, useRacial = true,        }, --Decaying Mind
        [272180] = { useKick = true, useCC = true, useRacial = true,        }, --Void Spit
        [265487] = { useKick = true, useCC = true, useRacial = true,        }, --Shadow Bolt Volley
        [265433] = { useKick = true, useCC = true, useRacial = true,        }, --Withering Curse
        
        --VORTEX PINNACLE
        [410760] = { useKick = true, useCC = true, useRacial = true,        }, --Wind Bolt
        [410870] = { useKick = true, useCC = true, useRacial = true,        }, --Cyclone
        [86331] = { useKick = true, useCC = false, useRacial = false,       }, --Lightning Bolt
        [88170] = { useKick = true, useCC = true, useRacial = true,         }, --Cloudburst
        [88959] = { useKick = true, useCC = true, useRacial = true,         }, --Holy Smite
        [87779] = { useKick = true, useCC = true, useRacial = true,         }, --Greater Heal
   },
}, 43, 70, math_random(87, 95), true)
