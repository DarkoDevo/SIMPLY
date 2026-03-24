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
        [ACTION_CONST_MAGE_ARCANE] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ShieldSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Arcane Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Frost Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceblockSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ice Block (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ice Block"
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

        [ACTION_CONST_MAGE_FIRE] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ShieldSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Fire Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Frost Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceblockSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ice Block (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ice Block"
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

        [ACTION_CONST_MAGE_FROST] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ShieldSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Frost Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Frost Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceblockSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ice Block (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ice Block"
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