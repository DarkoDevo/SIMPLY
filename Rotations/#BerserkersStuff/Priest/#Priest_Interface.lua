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
        [ACTION_CONST_PRIEST_HOLY] = {
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
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RenewSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Renew (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Renew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordShieldSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Power Word Shield (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Shield"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LightweaverSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Lightweaver (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal and Heal alternate"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Heal"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashHealSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Flash Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HolyWordSerenitySlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Word Serenity (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Holy Word Serenety"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "GSTank",
                    DBV = false,
                    L = {
                        enUS = "GS Tanks",
                    },
                    TT = {
                        enUS = "If enabled, we will use Guardian Spirit on Tanks only",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "DivineImageBox",
                    DBV = false,
                    L = {
                        enUS = "Divine Image",
                    },
                    TT = {
                        enUS = "If enabled, we wont cast any new Holy Word until Divine Image Buff is gone",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ResonantWordsBox",
                    DBV = true,
                    L = {
                        enUS = "Resonant Words",
                    },
                    TT = {
                        enUS = "If enabled, we wont cast any new Holy Word until Resonant Words Buff is gone",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "HWS",
                    DBV = false,
                    L = {
                        enUS = "HWS Range Check",
                    },
                    TT = {
                        enUS = "If enabled, we will use Holy Word Sanctify with range check for @player macros",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "SpreadDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Shadow Word: Pain",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All",         value = "All" },
                        { text = "Party1",      value = "Party1" },
                        { text = "Party2",      value = "Party2" },
                        { text = "Party3",      value = "Party3" },
                        { text = "Party4",      value = "Party4" },
                        { text = "Mouseover",   value = "Mouseover" },
                    },
                    DB = "PowerInfusionDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Power Infusion Mode",
                    },
                    TT = {
                        enUS = "Choose, a specific class you want to support with Power Infusion - or use ALL"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Desperate Prayer (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Desperate Prayer"
                    },
                    M = {},
                },
            },
            {
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
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LeapofFaithSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Leap of Faith (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Leap of Faith"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 10,
                    DB = "HolyNovaSlider",
                    DBV = 5,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Holy Nova"
                    },
                    TT = {
                        ANY = "Amount of targets to use Holy Nova"
                    },
                    M = {},
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_PRIEST_DISCIPLINE] = {
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
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RenewSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Renew (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Renew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordShieldSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Power Word Shield (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Shield"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PenanceHealSlider",
                    DBV = 55,
                    ONOFF = true,
                    L = { 
                        ANY = "Penance (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Penance"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashHealSlider",
                    DBV = 35,
                    ONOFF = true,
                    L = { 
                        ANY = "Flash Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordRadiance1Charge",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Radiance 1 Charges (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Radiance with 1 charge"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordRadiance2Charge",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Radiance 2 Charges (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Radiance witrh 2 charges"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MindbenderSlider",
                    DBV = 75,
                    ONOFF = true,
                    L = { 
                        ANY = "Mindbender (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Mindbender"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AtonementCheck",
                    DBV = false,
                    L = { 
                        enUS = "Check Atonements",
                    },
                    TT = {
                        enUS = "If enbaled, we will check active Atonement Buffs on the unit before we use an applier",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SpreadPWS",
                    DBV = false,
                    L = { 
                        enUS = "Spread Atonement",
                    },
                    TT = {
                        enUS = "If enbaled, we will spread PWS + Renew",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SpreadRapture",
                    DBV = false,
                    L = { 
                        enUS = "Spread Rapture",
                    },
                    TT = {
                        enUS = "If enaqbled, we will spread out PWS with Rapture",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "PwsTank",
                    DBV = false,
                    L = { 
                        enUS = "PWS @Tank",
                    },
                    TT = {
                        enUS = "If enbaled, we will keep PWS active on Tanks",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "OOCHeal",
                    DBV = false,
                    L = { 
                        enUS = "Out of Combat Heal",
                    },
                    TT = {
                        enUS = "If enabled, we will Out of Combat Heal",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SpreadDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Shadow Word: Pain",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All",         value = "All" },
                        { text = "Party1",      value = "Party1" },
                        { text = "Party2",      value = "Party2" },
                        { text = "Party3",      value = "Party3" },
                        { text = "Party4",      value = "Party4" },
                        { text = "Mouseover",   value = "Mouseover" },
                    },
                    DB = "PowerInfusionDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Power Infusion",
                    },
                    TT = {
                        enUS = "Choose, a specific class you want to support with Power Infusion - or use ALL"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Always",                  value = "1" },
                        { text = "Group Damage",            value = "2" },
                        { text = "Single Unit Damage",      value = "3" },
                        { text = "Group + Single Damage",   value = "4" },
                        { text = "Off",                     value = "5" },
                    },
                    DB = "MindbenderMenu",
                    DBV = "1",
                    L = {
                        ANY = "Mindbender Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the spell"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "High Priority",   value = "1" },
                        { text = "Low Priority",    value = "2" },
                        { text = "While Moving",    value = "3" },
                        { text = "Off",             value = "4" },
                    },
                    DB = "PrayerofMendingMenu",
                    DBV = "3",
                    L = {
                        ANY = "Prayer of Mending Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the priority"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Always",          value = "1" },
                        { text = "Moving",          value = "2" },
                        { text = "Apply Atonement", value = "3" },
                        { text = "Off",             value = "4" },
                    },
                    DB = "RenewMenu",
                    DBV = "3",
                    L = {
                        ANY = "Renew Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the priority"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Desperate Prayer (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Desperate Prayer"
                    },
                    M = {},
                },
            },
            {
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
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 10,
                    DB = "HolyNovaSlider",
                    DBV = 5,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Holy Nova"
                    },
                    TT = {
                        ANY = "Amount of targets to use Holy Nova"
                    },
                    M = {},
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_PRIEST_SHADOW] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordShieldSlider",
                    DBV = 85,
                    ONLYOFF = true,
                    L = {
                        ANY = "Power Word: Shield Player (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Power Word: Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashHealSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Flash Heal Player(%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DesperatePrayerSlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Desperate Prayer (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Desperate Prayer"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VampiricEmbraceSlider",
                    DBV = 45,
                    ONLYOFF = true,
                    L = {
                        ANY = "Vampiric Embrace (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Vampiric Embrace"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DispersionSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dispersion (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dispersion"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MindgamesSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mindgames (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Mindgames"
                    },
                    M = {},
                },
            },
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
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will use Vampiric Touch on all Enemies",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Mouseover Feature",
                    },
                    TT = {
                        enUS = "If enabled, we will use Shadow Crash only if our target and mouseover target are the same, which makes the usage of @cursor macros much better",
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
                    DB = "PowerWordShieldSlider2",
                    DBV = 85,
                    ONLYOFF = true,
                    L = {
                        ANY = "Power Word: Shield Target (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Power Word: Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashHealSlider2",
                    DBV = 35,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Flash Heal Target(%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VoidShiftUnit",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Void Shift Unit (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Void Shift"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VoidShiftPlayer",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Void Shift Player (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Void Shift"
                    },
                    M = {},
                },
            },
        },

    },
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function CanCastShadowWordDeath(unitID)
    --if Action.Zone == "arena" then return false end
    local HexCast = Action.Unit(unitID):IsCastingRemains(20066) > 0 and Action.Unit(unitID):IsCastingRemains(20066) < 1
    local PolyCast = Action.Unit(unitID):IsCastingRemains(118) > 0 and Action.Unit(unitID):IsCastingRemains(118) < 1
    local SleepCast = Action.Unit(unitID):IsCastingRemains(360806) > 0 and Action.Unit(unitID):IsCastingRemains(360806) < 1
    local LowHealth = Action.Unit(unitID):HealthPercent() < 20
  
    return (LowHealth or HexCast or PolyCast or SleepCast)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function CanMassDispel()
    local MDbuffIDs = { 642, 45438 } --Divne Shield, Iceblock
    if ((Action.Unit("target"):IsBuffUp(MDbuffIDs) and Action.Unit("target"):GetRange() < 40) or (Action.Unit("arena1"):IsBuffUp(MDbuffIDs) and Action.Unit("arena1"):GetRange() < 40) or (Action.Unit("arena2"):IsBuffUp(MDbuffIDs) and Action.Unit("arena2"):GetRange() < 40) or (Action.Unit("arena3"):IsBuffUp(MDbuffIDs) and Action.Unit("arena3"):GetRange() < 40)) then
        return true
    end

    return false
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

--################################################################################################################################################################################################################

