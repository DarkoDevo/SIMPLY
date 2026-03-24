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
        [ACTION_CONST_WARLOCK_AFFLICTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MortalCoilSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mortal Coil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mortal Coil"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DrainLifeSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Drain Life (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Drain Life"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DarkPactSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dark Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dark Pact"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "UnendingResolveSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Unending Resolve (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Unending Resolve"
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
                        enUS = "Shadow Embrace",
                    },
                    TT = {
                        enUS = "If enabled, we will keep Shadow Embrace active",
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
                        enUS = "If enabled, we will spread Immolate Debuff",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "EasyDot",
                    DBV = false,
                    L = {
                        enUS = "Darkclare",
                    },
                    TT = {
                        enUS = "If enabled, we will use Summon Darkclare with Agone, Corruption and Unstable Affliction only - otherwise we will wait of Vile Taint, Phantom Singularity and Soul Rot as well",
                    }, 
                    M = {},
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_WARLOCK_DEMONOLOGY] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MortalCoilSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mortal Coil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mortal Coil"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DrainLifeSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Drain Life (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Drain Life"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DarkPactSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dark Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dark Pact"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "UnendingResolveSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Unending Resolve (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Unending Resolve"
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
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_WARLOCK_DESTRUCTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "MortalCoilSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mortal Coil (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Mortal Coil"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DrainLifeSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Drain Life (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Drain Life"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DarkPactSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dark Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dark Pact"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "UnendingResolveSlider",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Unending Resolve (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Unending Resolve"
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
                    DB = "MultiDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Immolate Debuff",
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