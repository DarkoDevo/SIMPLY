local TMW                                             = TMW 
local CNDT                                            = TMW.CNDT
local Env                                             = CNDT.Env
local A                                               = Action
local GetToggle                                       = A.GetToggle
local InterruptIsValid                                = A.InterruptIsValid
local UnitCooldown                                    = A.UnitCooldown
local Unit                                            = A.Unit 
local Player                                          = A.Player 
local Pet                                             = A.Pet
local LoC                                             = A.LossOfControl
local MultiUnits                                      = A.MultiUnits
local EnemyTeam                                       = A.EnemyTeam
local FriendlyTeam                                    = A.FriendlyTeam
local TeamCache                                       = A.TeamCache
local InstanceInfo                                    = A.InstanceInfo
local TR                                              = Action.TasteRotation
local select, setmetatable                            = select, setmetatable
local GetSpellInfo_original                           = _G.GetSpellInfo
local function GetSpellInfo(...) return GetSpellInfo_original(...) or "" end
if NoGlobalsAvialable() then return true end
A.Data.ProfileEnabled[A.CurrentProfile]             = true
A.Data.ProfileUI                                     = {    
    [2] = {        
        [ACTION_CONST_MONK_MISTWEAVER] = { 
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
                    DB = "RMSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Renewing Mist (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Renewing Mist"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Slider1",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Soothing Mist (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Soothing Mist"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Slider2",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Vivify (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Vivify"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Slider3",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Enveloping Mist (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Enveloping Mist"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SGSlider",
                    DBV = 65,
                    ONOFF = true,
                    L = {
                        ANY = "Sheiluns Gift (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Sheiluns Gift"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 10,
                    DB = "SGSlider2",
                    DBV = 3,
                    ONLYOFF = true,
                    L = {
                        ANY = "Sheiluns Gift Stacks (%)"
                    },
                    TT = {
                        ANY = "Choose a specific amount for the Sheiluns Gift. Otherwise we will use it whenever its ready and the health conditions are met"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Slider4",
                    DBV = 65,
                    ONOFF = true,
                    L = {
                        ANY = "Soothing Mist Emergency (%)"
                    },
                    TT = {
                        ANY = "Normally we dont start a new SM cast when we channel already. With this slider we would interrupt the current channel for an emergency heal"
                    },
                    M = {},
                }, 
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Both",      value = "4" },
                        { text = "Essence Font",      value = "3" },
                        { text = "Soothing Mist",      value = "2" },
                        { text = "Off",      value = "1" },
                    },
                    DB = "Dropdown2",
                    DBV = "1",
                    L = {
                        ANY = "Interrupt Casts",
                    },
                    TT = {
                        enUS = "Interrupt Essence Font casts to only buff up with Ancient Teachings. Interrupt Soothing Mist casts if the unit is full health"
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
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Diffuse Magic (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Diffuse Magic"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dampen Harm (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dampen Harm"
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
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Fortifying Brew (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Fortifying Brew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Healing Elixir (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Healing Elixir"
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
                    E = "Checkbox",
                    DB = "LazyMode",
                    DBV = false,
                    L = { 
                        enUS = "SM Filler",
                    },
                    TT = {
                        enUS = "If enabled, we will heal with Soothing Mist as filler as soon someone is below 100% health or keep it up on tanks and not using dps spells",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "VivifyMode",
                    DBV = false,
                    L = { 
                        enUS = "Vivify",
                    },
                    TT = {
                        enUS = "If enabled, we will give Vivify more priority when multiple units are injured",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "RenewingMistMode",
                    DBV = false,
                    L = { 
                        enUS = "Renewing Mist",
                    },
                    TT = {
                        enUS = "If enabled, we will always use Renewing Mist on ourself when we have 2 stacks to always keep the spell it rolling.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ChiHarmonyMode",
                    DBV = false,
                    L = { 
                        enUS = "Chi Harmony",
                    },
                    TT = {
                        enUS = "If enabled, we will force the Unit with the Chi Harmony Buff (BETA)",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "SGMode",
                    DBV = false,
                    L = { 
                        enUS = "Sheiluns Gift",
                    },
                    TT = {
                        enUS = "If enabled, we will not use Sheiluns Gift when someone is low health",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ManaTeaSlider",
                    DBV = 35,
                    ONOFF = true,
                    L = {
                        ANY = "Mana Tea (%)"
                    },
                    TT = {
                        ANY = "The minimum health that a group member can have in order for Mana Tea to be used"
                    },
                    M = {},
                },
            },
        },

--################################################################################################################################################################################################################
--
--################################################################################################################################################################################################################

        [ACTION_CONST_MONK_BREWMASTER] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Diffuse Magic (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Diffuse Magic"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dampen Harm (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dampen Harm"
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
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Fortifying Brew (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Fortifying Brew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Healing Elixir (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Healing Elixir"
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

        [ACTION_CONST_MONK_WINDWALKER] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Diffuse Magic (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Diffuse Magic"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Dampen Harm (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Dampen Harm"
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
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Fortifying Brew (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Fortifying Brew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Touch of Karma (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Touch of Karma"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection5",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Transcendence: Transfer (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Transcendence: Transfer"
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
                        enUS = "If enbaled, we will spread Marc of the Crane Dot",
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

function CanSlowRangeClass(unitID)
    if Action.Unit("target"):IsPlayer() and not Action.Unit("target"):IsMelee() and Action.Unit("target"):GetRange() <= 5 and Action.Unit("target"):GetMaxSpeed() >= 100 and Action.Unit("target"):IsDebuffDown("Slowed") and Action.Unit("target"):IsBuffDown({
        642, -- Divine Shield
        45438, -- Ice Block
        186265, -- Aspect of Turtle     
        215769, -- Spirit of Redemption
        33786,  --Cyclone
        227847, -- Bladestorm  
        768, -- Cat Form
        5487, -- Bear Form
        783, -- Travel Form
        31224, -- Cloak of Shadows
        204018, -- Blessing of Spellwarding    
        48707, -- Anti Magic Shell
        23920, -- Spell Reflection
        213915, -- Mass reflect
        212295, -- Nether Ward (Warlock)
        1022, -- Blessing of Protection
        188499, -- Blade Dance 
        1044, -- Blessing of Freedom
        48265, -- Death's Advance
        287081, -- Lichborne
        212552, -- Wraith Walk
        53271, -- Master's Call    
        116841, -- Tiger's Lust
        216113, -- Way of the Crane (Monk TT PvP)
    })
    then
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