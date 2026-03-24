local TMW                                            = TMW
local CNDT                                           = TMW.CNDT
local Env                                            = CNDT.Env
local A                                              = Action
local GetToggle                                      = A.GetToggle
local InterruptIsValid                               = A.InterruptIsValid
local UnitCooldown                                   = A.UnitCooldown
local Unit                                           = A.Unit
local Player                                         = A.Player
local Pet                                            = A.Pet
local LoC                                            = A.LossOfControl
local MultiUnits                                     = A.MultiUnits
local EnemyTeam                                      = A.EnemyTeam
local FriendlyTeam                                   = A.FriendlyTeam
local TeamCache                                      = A.TeamCache
local InstanceInfo                                   = A.InstanceInfo
local select, setmetatable                           = select, setmetatable
local GetSpellInfo_original                          = _G.GetSpellInfo
local function GetSpellInfo(...) return GetSpellInfo_original(...) or "" end
if NoGlobalsAvialable() then return true end
A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    [2] = {
        [ACTION_CONST_SHAMAN_RESTORATION] = {
            {
                {
                    E = "Checkbox", 
                    DB = "Iconbar1",
                    DBV = false,
                    L = { 
                        enUS = "Qeuebar", 
                    }, 
                    TT = { 
                        enUS = "Choose whether you want to display an bar to queue and block cooldowns", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Iconbar2",
                    DBV = false,
                    L = {
                        enUS = "Presettings",
                    },
                    TT = {
                        enUS = "Choose whether you want to display an bar with presettings for M+ | Raids | Pvp - It's editable!",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SetupHealingTab",
                    DBV = true,
                    L = {
                        enUS = "Auto Setup",
                    },
                    TT = {
                        enUS = "If enabled, we will Auto setup the 'Healing System' Tab in action to our prefered values",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        enUS = "Use AoE",
                    },
                    TT = {
                        enUS = "As healer, we use it to toggle our Aoe Healing Spells like 'Wild Growth' - 'Essence Font' - 'Prayer of Healing' etc ",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 5,
                    DB = "AutoHealSensitivitySlider",
                    DBV = 2,
                    ONOFF = false,
                    L = {
                        ANY = "Auto Heal Sensitivity"
                    },
                    TT = {
                        ANY = "Auto Heal assesses the health deficit and factors in the potency of the heal, including incoming healing, damage taken, and active HoTs.\nThe slider adjusts the healing value: a lower slider setting results in more aggressive healing, consuming more mana, whereas a higher setting leads to less aggressive healing, aiding in better mana management."
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Healing Settings ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RiptideSlider",
                    DBV = -1,
                    ONOFF = true,
                    L = {
                        ANY = "Riptide (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Riptide"
                    },
                    M = {},
                }, 
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealingWaveSlider",
                    DBV = -1,
                    ONOFF = true,
                    L = {
                        ANY = "Healing Wave (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Healing Wave"
                    },
                    M = {},
                },                
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealingSurgeSlider",
                    DBV = 80,
                    ONOFF = true,
                    L = {
                        ANY = "Healing Surge (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Healing Surge"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "SnipeLavaBurst",
                    DBV = true,
                    L = {
                        enUS = "Snipe",
                    },
                    TT = {
                        enUS = "If enabled, we will use try to snipe our target if he is low health and we have Lava Surge Buff (mainly for PVP)",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AcidRain",
                    DBV = false,
                    L = {
                        enUS = "Acid Rain",
                    },
                    TT = {
                        enUS = "If enabled, we will use Healing Rain offensive with Acid Rain Talent",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "FreeBox",
                    DBV = false,
                    L = {
                        enUS = "",
                    },
                    TT = {
                        enUS = "",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "FreeBox",
                    DBV = false,
                    L = {
                        enUS = "",
                    },
                    TT = {
                        enUS = "",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "HealingRainMode",
                    DBV = "Off",
                    L = {
                        ANY = "Healing Rain",
                    },
                    TT = {
                        enUS = "Auto = will use it when Aoe Slider condition is true\nAlways = will use it always and keep it on cooldown"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "ChainHealMode",
                    DBV = "Auto",
                    L = {
                        ANY = "Chain Heal",
                    },
                    TT = {
                        enUS = "Auto = will use it only with Unleash Life or High Tide Buff\nAlways = will use it always when Aoe Slider condition is true"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AstralShiftSlider",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Astral Shift (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Astral Shift"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ManaTresholdDpsSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mana Treshold (%)"
                    },
                    TT = {
                        ANY = "Player Mana % to use Dps Spells"
                    },
                    M = {},
                },
            },
        },
        --#####################################################################################################################################################################################
        
        [ACTION_CONST_SHAMAN_ENCHANCEMENT] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealingTotemSlider",
                    DBV = 75,
                    ONLYOFF = true,
                    L = {
                        ANY = "Healing Totem (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Healing Totem"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealingSurgeSelfHealSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Healing Surge (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Healing Surge"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AstralShiftSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Astral Shift (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Astral Shift"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AncestralGuidanceSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ancestral Guidance (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ancestral Guidance"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        enUS = "Use AoE",
                    },
                    TT = {
                        enUS = "Enable multiunits actions",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        enUS = "Feral Spirit on CD",
                    },
                    TT = {
                        enUS = "If enabled, we will use Feral Spirits on cooldown without Cooldown toggle",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Shamanism on Focus",
                    },
                    TT = {
                        enUS = "If enbaled, we will check our Frienldy Focus for Damage Buffs and support him with Bloodlust - Need @focus macro",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox4",
                    DBV = false,
                    L = { 
                        enUS = "Checkbox3",
                    },
                    TT = {
                        enUS = "Currently without function",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealingSurgeFocusHealSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Focus Healing"
                    },
                    TT = {
                        ANY = "Focus HP % to use Healing Surge"
                    },
                    M = {},
                },
            },
        },

        --#####################################################################################################################################################################################

        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
           {{ E = "LayoutSpace", },},
           {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
           {
            {
                E = "Slider",
                MIN = -1,
                MAX = 100,
                DB = "HealingTotemSlider",
                DBV = 75,
                ONLYOFF = true,
                L = {
                    ANY = "Healing Totem (%)"
                },
                TT = {
                    ANY = "Player HP % to use Healing Totem"
                },
                M = {},
            },
            {
                E = "Slider",
                MIN = -1,
                MAX = 100,
                DB = "HealingSurgeSelfHealSlider",
                DBV = 50,
                ONLYOFF = true,
                L = {
                    ANY = "Healing Surge (%)"
                },
                TT = {
                    ANY = "Player HP % to use Healing Surge"
                },
                M = {},
            },
        },
        {
            {
                E = "Slider",
                MIN = -1,
                MAX = 100,
                DB = "AstralShiftSlider",
                DBV = 50,
                ONLYOFF = true,
                L = {
                    ANY = "Astral Shift (%)"
                },
                TT = {
                    ANY = "Player HP % to use Astral Shift"
                },
                M = {},
            },
            {
                E = "Slider",
                MIN = -1,
                MAX = 100,
                DB = "AncestralGuidanceSlider",
                DBV = 50,
                ONLYOFF = true,
                L = {
                    ANY = "Ancestral Guidance (%)"
                },
                TT = {
                    ANY = "Player HP % to use Ancestral Guidance"
                },
                M = {},
            },
        },
           {{ E = "LayoutSpace", },},
           {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
           {
               {
                   E = "Checkbox",
                   DB = "AoE",
                   DBV = true,
                   L = {
                       enUS = "Use AoE",
                   },
                   TT = {
                       enUS = "Enable multiunits actions",
                   }, 
                   M = {},
               },
               {
                   E = "Checkbox",
                   DB = "Checkbox1",
                   DBV = false,
                   L = { 
                       enUS = "Checkbox1",
                   },
                   TT = {
                       enUS = "Currently without function",
                   },
                   M = {},
               },
               {
                   E = "Checkbox",
                   DB = "Checkbox2",
                   DBV = false,
                   L = { 
                       enUS = "Checkbox2",
                   },
                   TT = {
                       enUS = "Currently without function",
                   },
                   M = {},
               },
               {
                   E = "Checkbox",
                   DB = "Checkbox4",
                   DBV = false,
                   L = { 
                       enUS = "Checkbox3",
                   },
                   TT = {
                       enUS = "Currently without function",
                   },
                   M = {},
               },
           },
        },
    },
}

--#####################################################################################################################################################################################

------------------------------------
--- Function to check if we can use Anti Fear Totem
------------------------------------
local ActiveUnitPlates = Action.MultiUnits:GetActiveUnitPlates()
function canTremor()
    local fearCheck = 0

    for unitID in pairs(ActiveUnitPlates) do
        if UnitCastingInfo(unitID) == "Fear" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Terror" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Psychic Scream" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Repulsive Visage" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Howl of Terror" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Intimidating Shout" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Sleep Walk" then
            fearCheck = 1
        elseif UnitCastingInfo(unitID) == "Fearsome Howl" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Fear" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Terror" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Psychic Scream" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Howl of Terror" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Intimidating Shout" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Sleep Walk" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Fearsome Howl" then
            fearCheck = 1
        elseif UnitCastingInfo("target") == "Repulsive Visage" then
            fearCheck = 1
        elseif Action.FriendlyTeam():GetDeBuffs("Fear", 30) > 0 then
            fearCheck = 1
        elseif Action.FriendlyTeam():GetDeBuffs("Charm", 30) > 0 then
            fearCheck = 1
        elseif Action.FriendlyTeam():GetDeBuffs("Sleep", 30) > 0 then
            fearCheck = 1
        end
    end

	if fearCheck == 1 then 
        return true 
    else 
        return false 
    end
end	

--################################################################################################################################################################################################################

local stringformat  = string.format
function NoInterfaceAvialable()
    local date = C_DateAndTime.GetCurrentCalendarTime()
    local today = tonumber(string.format("%04d%02d%02d",date.year,date.month,date.monthDay))
    
    if (today > tonumber("20250101")) then --format: YYYYMMDD
       StaticPopup_Show ("ACTION_BERSERKER_OUTDATED_INTERFACE")
       return true
    else
       return false
    end
end