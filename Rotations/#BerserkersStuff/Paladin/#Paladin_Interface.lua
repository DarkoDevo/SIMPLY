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
local TR                                             = Action.TasteRotation
local select, setmetatable                           = select, setmetatable
local GetSpellInfo_original                          = _G.GetSpellInfo
local function GetSpellInfo(...) return GetSpellInfo_original(...) or "" end
if NoGlobalsAvialable() then return true end
A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    [2] = {
        [ACTION_CONST_PALADIN_HOLY] = {
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
                    DB = "HolyShockSlider",
                    DBV = 90,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Shock (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Holy Shock"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WOGSlider",
                    DBV = 85,
                    ONOFF = true,
                    L = {
                        ANY = "Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "InfusionSlider",
                    DBV = 80,
                    ONOFF = true,
                    L = {
                        ANY = "Infusion of Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Infusion of Light"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HolyLightSlider",
                    DBV = -1,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to hard cast Holy Light"
                    },
                    M = {},
                },                
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashofLightSlider",
                    DBV = - 1,
                    ONOFF = true,
                    L = {
                        ANY = "Flash of Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to hard cast Flash of Light"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
			{
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "AutoInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Switch Targets Interrupt",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets to interrupt.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "HolyShockOffensive",
                    DBV = false,
                    L = {
                        enUS = "HS offensive",
                    },
                    TT = {
                        enUS = "If enabled, we will use Holy Shock offensive - /cast Holy Shock and bind it to turn Evil",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        enUS = "BoF @Player",
                    },
                    TT = {
                        enUS = "If enbaled, we will use Beacon of Faith on us - useful in Dungeons",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        enUS = "Consume Infusion asap",
                    },
                    TT = {
                        enUS = "If enabled, we will consume Infusion of Light Buff as soon as possible",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "Dropdown2",
                    DBV = "Off",
                    L = {
                        ANY = "Light of Dawn Mode",
                    },
                    TT = {
                        enUS = "Description:\nAuto = will use it in AoE Scenarios \nAlways = Will use it always when its ready"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Flash of Light", value = "FlashofLight" },
                        { text = "Holy Light", value = "HolyLight" },
                    },
                    DB = "Dropdown5",
                    DBV = "FlashofLight",
                    L = {
                        ANY = "Infusion of Light",
                    },
                    TT = {
                        enUS = ""
                    },
                    M = {},
                },
            },
            { { E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Divine Protection (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Protection"
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
                        ANY = "Divine Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Shield"
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
                    DB = "EmergencyHealSlider",
                    DBV = - 1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Emergency (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Spells from Dropdown above"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "OOCHeal",
                    DBV = true,
                    L = { 
                        enUS = "OOC Healing",
                    },
                    TT = {
                        enUS = "If enbaled we will use out of combat healing logic beside of sliders",
                    },
                    M = {},
                },
            },
        },
		
--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################
		
        [ACTION_CONST_PALADIN_PROTECTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WoGFreePlayer",
                    DBV = 90,
                    ONLYOFF = true,
                    L = {
                        ANY = "Free Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 45,
                    ONLYOFF = true,
                    L = {
                        ANY = "Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Word of Glory"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ardent Defender (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ardent Defendern"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Guardians of Ancient Kings (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Guardians of Ancient Kings"
                    },
                    M = {},
                },
            },
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Divine Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection5",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Lay on Hands (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lay on Hands"
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
                    DB = "Checkbox3",
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
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Group Healing ] ===", },},},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "FreeWoGTeamDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Free WoG Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Free Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "WoGTeamDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Regular WoG Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FreeWoGTeam",
                    DBV = 85,
                    ONLYOFF = true,
                    L = {
                        ANY = "Free Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Free Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WoGTeam",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Regular Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoSTeamDropdown",
                    DBV = "Healer",
                    L = {
                        ANY = "Blessing of Sacrifice Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoPTeamDropdown",
                    DBV = "Healer",
                    L = {
                        ANY = "Blessing of Protection Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Protection"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoSTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Sacrifice (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoPTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Protection (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Protection"
                    },
                    M = {},
                },
            },
        },
		
--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################
		
        [ACTION_CONST_PALADIN_RETRIBUTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 45,
                    ONLYOFF = true,
                    L = {
                        ANY = "Word of Glory Player (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Word of Glory"
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
                        ANY = "Shield of Vengeance (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Shield of Vengeance | Divine Protection"
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
                        ANY = "Divine Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Shield"
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
                        ANY = "Lay on Hands (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lay on Hands"
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
                    DBV = true,
                    L = {
                        enUS = "Force HoW",
                    },
                    TT = {
                        enUS = "If enabled, we will force Hammer of Wrath",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = true,
                    L = {
                        enUS = "Wake of Ashes",
                    },
                    TT = {
                        enUS = "If enabled, we will use Wake of Ashes with additional Time to Die checks and only in AoE or in Boss Fight",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = {
                        enUS = "Templar Strike",
                    },
                    TT = {
                        enUS = "enable it, when you choosed Templar Strike Talent",
                    }, 
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Group Healing ] ===", },},},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Tank",   value = "Tank" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "WoGTeamDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Regular WoG Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WoGTeam",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Regular Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Tank",   value = "Tank" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoSTeamDropdown",
                    DBV = "Tank",
                    L = {
                        ANY = "Blessing of Sacrifice Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Tank",   value = "Tank" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoPTeamDropdown",
                    DBV = "Healer",
                    L = {
                        ANY = "Blessing of Protection Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Protection"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoSTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Sacrifice (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoPTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Protection (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Protection"
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
