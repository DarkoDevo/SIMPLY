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
        [ACTION_CONST_EVOKER_DEVASTATION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ObsidianScalesSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Obsidian Scales (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Obsidian Scales"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RenewingBlazeSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewing Blaze (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewing Blaze"
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
                        enUS = "Placeholder",
                    },
                    TT = {
                        enUS = "Placeholder",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Placeholder",
                    },
                    TT = {
                        enUS = "Placeholder",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        enUS = "Placeholder",
                    },
                    TT = {
                        enUS = "Placeholder",
                    },
                    M = {},
                },
            },
        },

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        [ACTION_CONST_EVOKER_PRESERVATION] = {
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
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EchoSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Echo (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Echo"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ReversionSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Reversion (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Reversion"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "CauterizingFlameSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Cauterizing Flame (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Cauterizing Flame"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VerdantEmbraceSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Verdant Embrace (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Verdant Embrace"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LivingFlameSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Living Flame (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Living Flame"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SpiritBloomSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Spirit Bloom (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Spirit Bloom"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "ForceFB",
                    DBV = true,
                    L = {
                        enUS = "Force Fire Breath",
                    },
                    TT = {
                        enUS = "If enabled, we will force Fire Breath when our team is safe",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SpreadHot",
                    DBV = false,
                    L = {
                        enUS = "Spread Echo",
                    },
                    TT = {
                        enUS = "If enabled, we will spread echo to teammates without it, when we have the essence and noone needs urgent healing.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "YseraConsuming",
                    DBV = false,
                    L = {
                        enUS = "Call of Ysera",
                    },
                    TT = {
                        enUS = "If enabled, we will force to consume Call of Ysera Buff with Dream Breath",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "4 (Only works if you have font of magic talented)",      value = "4" },
                        { text = "3",      value = "3" },
                        { text = "2",      value = "2" },
                        { text = "1",      value = "1" },
                    },
                    DB = "Dropdown1",
                    DBV = "1",
                    L = {
                        ANY = "Spirit Bloom",
                    },
                    TT = {
                        enUS = "Choose, how much you want to empower the cast"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "4 (Only works if you have font of magic talented)",      value = "4" },
                        { text = "3",      value = "3" },
                        { text = "2",      value = "2" },
                        { text = "1",      value = "1" },
                    },
                    DB = "Dropdown2",
                    DBV = "1",
                    L = {
                        ANY = "Dream Breath",
                    },
                    TT = {
                        enUS = "Choose, how much you want to empower the cast"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "4 (Only works if you have font of magic talented)",      value = "4" },
                        { text = "3",      value = "3" },
                        { text = "2",      value = "2" },
                        { text = "1",      value = "1" },
                    },
                    DB = "Dropdown3",
                    DBV = "1",
                    L = {
                        ANY = "Fire Breath",
                    },
                    TT = {
                        enUS = "Choose, how much you want to empower the cast"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto",      value = "3" },
                        { text = "Spirit Bloom",      value = "2" },
                        { text = "Dream Breath",      value = "1" },
                    },
                    DB = "TipDropdown",
                    DBV = "3",
                    L = {
                        ANY = "Tip the Scales",
                    },
                    TT = {
                        enUS = "Choose, if you want to force a specific spell"
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
                    DB = "ObsidianScalesSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Obsidian Scales (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Obsidian Scales"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RenewingBlazeSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewing Blaze (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewing Blaze"
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