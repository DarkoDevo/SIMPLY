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
        [ACTION_CONST_HUNTER_BEASTMASTERY] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MendPet",
                    DBV = 80,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mend Pet (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mend Pet"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 80,
                    ONLYOFF = true,
                    L = {
                        ANY = "Feign Death (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Feign Death"
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
                        ANY = "Exhilaration (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Exhilaration"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Survival of the Fittest (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Survival of the Fittest"
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
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Aspect of the Turtle (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Aspect of the Turtle"
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
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Barbed Shot Dot",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = true,
                    L = { 
                        enUS = "Disable Burst",
                    },
                    TT = {
                        enUS = "If enabled, we will automatically disable Burst as soon Bestial Wrath is used",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        enUS = "Force Kill Shot",
                    },
                    TT = {
                        enUS = "If enabled, we will force Kill Shot as soon its ready",
                    },
                    M = {},
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_HUNTER_MARKSMANSHIP] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MendPet",
                    DBV = 80,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mend Pet (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mend Pet"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 80,
                    ONLYOFF = true,
                    L = {
                        ANY = "Feign Death (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Feign Death"
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
                        ANY = "Exhilaration (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Exhilaration"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Survival of the Fittest (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Survival of the Fittest"
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
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Aspect of the Turtle (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Aspect of the Turtle"
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
        },
		
--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################
		
        [ACTION_CONST_HUNTER_SURVIVAL] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MendPet",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mend Pet (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mend Pet"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Feign Death (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Feign Death"
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
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Exhilaration (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Exhilaration"
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
                        ANY = "Survival of the Fittest (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Survival of the Fittest"
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
                        ANY = "Aspect of the Turtle (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Aspect of the Turtle"
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