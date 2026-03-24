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
--if NoGlobalsAvialable() then return true end
A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    [2] = {
        [ACTION_CONST_DEATHKNIGHT_BLOOD] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathStrikeSlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Strike"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicShellSlider",
                    DBV = 55,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Shell (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Shell"
                    },
                    M = {},
                },
            },
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathPactSlider",
                    DBV = 45,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Pact"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceboundFortitudeSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Icebound Fortitude (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Icebound Fortitude"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VampiricBloodSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Vampiric Blood (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Vampiric Blood"
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

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_DEATHKNIGHT_FROST] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathStrikeSlider",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Strike"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathPactSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Pact"
                    },
                    M = {},
                },
            },
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LichborneSlider",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Lichborne (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lichborne"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceboundFortitudeSlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Icebound Fortitude (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Icebound Fortitude"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicShellSlider",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Shell (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Shell"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicZoneSlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Zone (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Zone"
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
                        enUS = "Mini Burst",
                    },
                    TT = {
                        enUS = "If enbaled, we will use Mini Burst: Pillar of Frost",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Auto disable",
                    },
                    TT = {
                        enUS = "If enabled, we will automatically disable burst after Pillar of Frost - only works when Mini Burst is enabled - not when Big Burst is enabled",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox4",
                    DBV = false,
                    L = { 
                        enUS = "Checkbox4",
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
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Stun Healer",   value = "3" },
                    },
                    DB = "AsphyxiateDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Asphyxiate",
                    },
                    TT = {
                        enUS = "Choose, how the rotation should handle Asphyxiate. Auto means we use it for Pvp Kicks and Healer Stuns"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Stun Healer",   value = "3" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "StrangulateDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Strangulate",
                    },
                    TT = {
                        enUS = "Choose, how the rotation should handle Strangulate. Auto means we use it for Pvp Kicks and Healer Stuns"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "DeathGripDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Death Grip",
                    },
                    TT = {
                        enUS = "Choose, how the rotation should handle Death Grip."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 40,
                    DB = "TargetRangeSlider",
                    DBV = 10,
                    ONLYOFF = true,
                    L = {
                        ANY = "Target Range"
                    },
                    TT = {
                        ANY = "Target range to use Death Grip when the Dropdown is set to Target"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TargetHealthSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Grip Health (%)"
                    },
                    TT = {
                        ANY = "Target HP % to Death Grip when the Target is not in Range"
                    },
                    M = {},
                },
            },
        },
		
--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################
		
        [ACTION_CONST_DEATHKNIGHT_UNHOLY] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = 1000000,
                    MAX = 16000000,
                    DB = "DeathStrikeSliderSpecial",
                    DBV = 2000000,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike Special"
                    },
                    TT = {
                        ANY = "Player lost more than X health last 4 secconds"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathStrikeSlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Strike"
                    },
                    M = {},
                },
            },
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LichborneSlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Lichborne (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lichborne"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceboundFortitudeSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Icebound Fortitude (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Icebound Fortitude"
                    },
                    M = {},
                },
			},
            {   {
                    E = "Checkbox",
                    DB = "lichborneHealing",
                    DBV = false,
                    L = { 
                        enUS = "Use Death Coil on player during lichborne for healing",
                    },
                    TT = {
                        enUS = "If enabled, we will use death coil on player during lichborne for healing",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "RaceCar",
                    DBV = true,
                    L = {
                        enUS = "Use Fast Kicks in Arena",
                    },
                    TT = {
                        enUS = "If enabled this will kick faster than our normal kicks (Race Car Mode)",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicShellSlider",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Shell (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Shell"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicZoneSlider",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Zone (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Zone"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SacrificialPactSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Sacrificial Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Sacrificial Pact"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathPactSlider",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Pact"
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
                        enUS = "Plaguebringer",
                    },
                    TT = {
                        enUS = "If enabled, we will keep Plaguebringer active",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Spread Festering Wounds",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Festering Wounds to multiple enemies around us",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox4",
                    DBV = false,
                    L = { 
                        enUS = "Arena Rotation",
                    },
                    TT = {
                        enUS = "If enbaled, we will use a more specific Arena Rotation",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 5,
                    DB = "FesterStacksSlider",
                    DBV = 3,
                    ONLYOFF = true,
                    L = {
                        ANY = "Festering Wound Stacks (%)"
                    },
                    TT = {
                        ANY = "Choose, how many stacks you want to keep active"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Healer",   value = "3" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "AsphyxiateDropdown",
                    DBV = "3",
                    L = {
                        ANY = "Asphyxiate",
                    },
                    TT = {
                        enUS = "Auto = We will use Asphyxiate to interrupt any arena unit or to stun the enemy healer in arena. Interrupt = We will use Asphyxiate only to interrupt any arena unit. Healer = We will use Asphyxiate only to stun the enemy healer. Target = We will use Asphyxiate only to interrupt our current target."
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Healer",   value = "3" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "StrangulateDropdown",
                    DBV = "3",
                    L = {
                        ANY = "Strangulate",
                    },
                    TT = {
                        enUS = "Auto = We will use Strangulate to interrupt any arena unit or to stun the enemy Healer in arena. Interrupt = We will use Strangulate only to interrupt any arena unit. Healer = We will use Strangulate only to stun the enemy healer. Target = We will use Strangulate only to interrupt our current target."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Target",   value = "3" },
                    },
                    DB = "DeathGripDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Death Grip",
                    },
                    TT = {
                        enUS = "Auto = We will use Death Grip to interrupt in Arena (lowest priority) or to grab our Target when the conditions below are met. Interrupt = We will use Death Grip only to interrupt. Target = We will use Death Grip only to grab our Target when the conditions below are met."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TargetHealthSlider",
                    DBV = 75,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Grip Target Health (%)"
                    },
                    TT = {
                        ANY = "Target HP % to Death Grip when the Target is not in Range"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "soulReaperHP",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Soul Reaper Target Health (%)"
                    },
                    TT = {
                        ANY = "Target HP % to Soul Reaper"
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