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
        [ACTION_CONST_DEMONHUNTER_HAVOC] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 75,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blur (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Blur"
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
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Netherwalk (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Netherwalk"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Darkness (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Darkness"
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
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Rain from Above (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Rain from Above"
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
                    DB = "FelBarrage",
                    DBV = false,
                    L = { 
                        enUS = "Prepare Fel Barrage",
                    },
                    TT = {
                        enUS = "If enabled, we will collect full Fury and use Fel Barrage - it will auto disable when its used",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 120,
                    DB = "FurySlider",
                    DBV = 100,
                    ONLYOFF = true,
                    L = {
                        ANY = "Fury for Fel Barrage (%)"
                    },
                    TT = {
                        ANY = "Player Fury % to use Fel Barrage"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 10,
                    DB = "StayingTimeSlider",
                    DBV = 0,
                    ONLYOFF = true,
                    L = {
                        ANY = "Staying Time (%)"
                    },
                    TT = {
                        ANY = "Time we have to stay to use Eye Beam, Essence Break, Glaive Tempest, Fel Barrage"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Eye Beam", value = 1 },
                        { text = "Essence Break", value = 2 },
                        { text = "Glaive Tempest", value = 3 },
                        { text = "Fel Barrage", value = 4 },
                        { text = "Sigil of Flame", value = 5 },
                        { text = "Blade Dance", value = 6 },
                        { text = "Elysian Decree", value = 7 },

                    },
                    MULT = true,
                    DB = "MovementSpells",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = false,
                        [7] = true,
                    }, 
                    SetPlaceholder = { 
                        enUS = "", 
                    }, 
                    L = { 
                        enUS = "Spells for Movement Checks",
                    }, 
                    TT = { 
                        enUS = "If you enbale one or more of these spells, we will only use it while we reached the Staying Time from the Slider above",
                    }, 
                    M = {},                                    
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_DEMONHUNTER_VENGEANCE] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Metamorphosis (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Metamorphosis"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Darkness (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Darkness"
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
                        enUS = "Infernal Strike to pull",
                    },
                    TT = {
                        enUS = "If enabled, we will use Infernal Strike as first spell when we are out of combat",
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