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
        [ACTION_CONST_WARRIOR_ARMS] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VictoryRushSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Victory Rush (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Victory Rush"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IgnorePainSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ignore Pain (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ignore Pain - we use Regeneratin Icon"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DiebytheSwordSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Die by the Sword (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Die by the Sword"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCrySlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Rallying Cry (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Rallying Cry"
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

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_WARRIOR_FURY] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VictoryRushSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Victory Rush (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Victory Rush"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EnragedRegenerationSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Enraged Regeneration (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Enraged Regeneration"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCrySlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Rallying Cry (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Rallying Cry"
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
		
--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################
		
        [ACTION_CONST_WARRIOR_PROTECTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VictoryRushSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Victory Rush (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Victory Rush"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Last Stand (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Last Stand"
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
                        ANY = "Shield Wall (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Shield Wall"
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
                        ANY = "Bitter Immunity (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Bitter Immunity"
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
                        enUS = "Shockwave",
                    },
                    TT = {
                        enUS = "If enabled, we will use Shockwave when there are >= 3 Enemies",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Use Stance",
                    },
                    TT = {
                        enUS = "'If enabled, we will automatically use Stances'",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        enUS = "Charge",
                    },
                    TT = {
                        enUS = "If enabled, we will use Charge always - otherwise only out of combat",
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