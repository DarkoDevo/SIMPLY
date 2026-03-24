local TMW                                   = TMW
local CNDT                                  = TMW.CNDT
local Env                                   = CNDT.Env
local A                                     = Action
local GetToggle                             = A.GetToggle
local InterruptIsValid                      = A.InterruptIsValid
local UnitCooldown                          = A.UnitCooldown
local Unit                                  = A.Unit
local Player                                = A.Player
local Pet                                   = A.Pet
local LoC                                   = A.LossOfControl
local MultiUnits                            = A.MultiUnits
local EnemyTeam                             = A.EnemyTeam
local FriendlyTeam                          = A.FriendlyTeam
local TeamCache                             = A.TeamCache
local InstanceInfo                          = A.InstanceInfo
local TR                                    = A.TasteRotation
local select, setmetatable                  = select, setmetatable
local GetSpellInfo_original                 = _G.GetSpellInfo 
local function GetSpellInfo(...) return GetSpellInfo_original(...) or "" end
if NoGlobalsAvialable() then return true end
A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    [2] = {
        [ACTION_CONST_DRUID_RESTORATION] = {
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
                    DB = "LifebloomSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Lifebloom (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Lifebloom for Non Tanks"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RejuvenationSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Rejuvenation (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Rejuvenation"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FreecastSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Clearcast (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regrowth"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "CenarionWardSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Cenarion Ward (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Cenarion Ward"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RegrowthSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Regrowth (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regrowth"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "NourishSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Nourish (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Nourish"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Swiftmend",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Swiftmend (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Swiftmend"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "SpreadHot",
                    DBV = false,
                    L = {
                        enUS = "Spread Rejuvenation",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Rejuvenation",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "MultiDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Moonfire Dot",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        enUS = "Pre Hot",
                    },
                    TT = {
                        enUS = "If enbaled, we will pre hot the tank with Lifebloom and Rejuvenation",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Photosynthesis",
                    },
                    TT = {
                        enUS = "If enbaled, we will swap Lifebloom to player (Darkflight Icon) with Photosynthesis Talent",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = true,
                    L = { 
                        enUS = "Force Swiftmend into CW",
                    },
                    TT = {
                        enUS = "If enbaled, we will force to extend the Cenarion Ward Buff",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox4",
                    DBV = true,
                    L = { 
                        enUS = "Convoke for low health",
                    },
                    TT = {
                        enUS = "If enbaled, we will use Convoke the Spirits to heal up a low health member",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox5",
                    DBV = true,
                    L = { 
                        enUS = "CW everyone",
                    },
                    TT = {
                        enUS = "When enabled, Cenarion Ward will be applied flexibly to any party or raid member. If not enabled, it will only be cast on tanks",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox6",
                    DBV = false,
                    L = { 
                        enUS = "Catweaving",
                    },
                    TT = {
                        enUS = "If enabled, we will automatically enter Cat Form when all Units are above Emergency Slider and we are in Melee Range",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EmergencySlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Emergency (%)"
                    },
                    TT = {
                        ANY = "Unit HP (%) to leave our Cat/Moonkin Form"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto",            value = "Auto" },
                        { text = "Rejuvenation",    value = "Rejuvenation" },
                        { text = "Regrowth",        value = "Regrowth" },
                        { text = "Wild Growth",     value = "WildGrowth" },
                    },
                    DB = "SoutFDropdown",
                    DBV = "Auto",
                    L = {
                        ANY = "Soul of the Forest Mode",
                    },
                    TT = {
                        enUS = "Choose how you want to handle Soul of the Forest Buff"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Expiring Hots",   value = "1" },
                        { text = "Agressiv",        value = "2" },
                    },
                    DB = "SwiftmendDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Swiftmend Mode",
                    },
                    TT = {
                        enUS = "Choose how you want to handle Swiftmend without Verdant Infusion Talent"
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
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Barkskin (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Barkskin"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewal (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewal"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Bear Form (%)"
                    },
                    TT = {
                        ANY = "Player HP % to switch in Bear Form"
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
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_DRUID_BALANCE] = { 
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Barkskin (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Barkskin"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewal (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Natures Vigil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Natures Vigil"
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

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_DRUID_FERAL] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Barkskin (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Barkskin"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewal (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Natures Vigil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Natures Vigil"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Survival Instincts (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Survival Instincts"
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

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_DRUID_GUARDIAN] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Barkskin (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Barkskin"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewal (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Natures Vigil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Natures Vigil"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Survival Instincts (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Survival Instincts"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Defensive Trinkets ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TrinketSlider1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Trinket 1 (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Trinket 1"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TrinketSlider2",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Trinket 2 (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Trinket 21"
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



