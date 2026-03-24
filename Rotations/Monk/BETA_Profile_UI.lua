-- Forgot to add this when adding the BETA Monk
local TMW                                            = TMW 
local CNDT                                            = TMW.CNDT
local Env                                            = CNDT.Env

local A                                                = Action
local GetToggle                                        = A.GetToggle
local InterruptIsValid                                = A.InterruptIsValid

local UnitCooldown                                    = A.UnitCooldown
local Unit                                            = A.Unit 
local Player                                        = A.Player 
local Pet                                            = A.Pet
local LoC                                            = A.LossOfControl
local MultiUnits                                    = A.MultiUnits
local EnemyTeam                                        = A.EnemyTeam
local FriendlyTeam                                    = A.FriendlyTeam
local TeamCache                                        = A.TeamCache
local InstanceInfo                                    = A.InstanceInfo
local select, setmetatable                            = select, setmetatable

local GameLocale                                        = A.FormatGameLocale(_G.GetLocale())
local StdUi                                                = A.StdUi
local Factory                                            = StdUi.Factory
local math_random                                        = math.random

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "TWW S2 v1.1.0",
    -- Class settings
    [2] = {        
        [ACTION_CONST_MONK_BREWMASTER] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Brewmaster Monk ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = false,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                { -- AOE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {},
                },
            },
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
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- AUTO OPTIONS
                {
                    E = "Checkbox",
                    DB = "autotarget",
                    DBV = true,
                    L = {
                        enUS = "Auto Target",
                    },
                    TT = {
                        enUS = "Taunt, Multi-Dot, Interrupt, etc.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "autotaunt",
                    DBV = true,
                    L = {
                        enUS = "Auto Taunt (Non-Raid)",
                    },
                    TT = {
                        enUS = "Auto Taunt in non-raid environments",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "multidot",
                    DBV = true,
                    L = {
                        enUS = "Auto Target for Multi-Dot",
                    },
                    TT = {
                        enUS = "Auto swap targets for multi-dot.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "targetmelee",
                    DBV = true,
                    L = {
                        enUS = "Auto Target Melee",
                    },
                    TT = {
                        enUS = "Auto swap targets for malee targeting.",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Damage Potions",
                    },
                },
            },
            { -- Potions
                { -- useDamagePotion
                    E = "Checkbox", 
                    DB = "damagePotion",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion"
                    }, 
                    TT = { 
                        ANY = "Use Damage Potion", 
                    }, 
                    M = {},
                },
                { -- potionBossOnly
                    E = "Checkbox", 
                    DB = "potionLustOnly",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion Bloodlust/TimeWarp Only", 
                    }, 
                    TT = { 
                        ANY = "Only use Damage Potion when any kind of Bloodlust/Warp active."
                    }, 
                    M = {},
                },
            },
            {
                { -- potionExhausted
                    E = "Checkbox", 
                    DB = "potionExhausted",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion With Exhaustion", 
                    }, 
                    TT = { 
                        ANY = "Use Damage Potion while Exhausted (can't use Bloodlust)."
                    }, 
                    M = {},
                },
                { -- potionExhaustedSlider
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 5,   
                    Precision = 1,                         
                    DB = "potionExhaustedSlider",
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = "Exhaustion Time Remaining",
                    },
                    TT = { 
                        ANY = "Time in minutes left on the Exhaustion Debuff to consider using Damage Potion.", 
                    },                     
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Defensives",
                    },
                },
            },
            { -- General -- Header
                {
                    E = "Label",
                    L = {
                        ANY = "Defensives will attempted to be used before incoming damage.\nThe HP% values are intended for unexpected damage.",
                    },
                },
            }, 
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Celestial Brew", value = 1 }, 
                        { text = "Diffuse Magic", value = 2 },     
                        { text = "Fortifying Brew", value = 3 },
                        { text = "Celestial Infusion", value = 4 },
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        ANY = "Defensive Abilities", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want the rotation to use as defensives.", 
                    }, 
                    M = {},                                    
                },  
            },  
            { 
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "celestialBrewHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Celestial Brew",
                    },
                    TT = { 
                        ANY = "HP (%) to use Celestial Brew", 
                    },                     
                    M = {},
                },  
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "diffuseMagicHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Diffuse Magic",
                    },
                    TT = { 
                        ANY = "HP (%) to use Diffuse Magic", 
                    },                     
                    M = {},
                },  
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "fortifyingBrewHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Fortifying Brew",
                    },
                    TT = { 
                        ANY = "HP (%) to use Fortifying Brew", 
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "CelestialInfusionHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Celestial Infusion",
                    },
                    TT = { 
                        ANY = "HP (%) to use Celestial Infusion", 
                    },                     
                    M = {},
                }, 
            },
            {
                { -- Expel Harm
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "expelHarmHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Expel Harm HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Expel Harm. Used in conjunction with Expel Harm Orbs.", 
                    },                     
                    M = {},
                },  
                { -- Expel Harm
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 4,                            
                    DB = "expelHarmOrbs",
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Expel Harm Orbs",
                    },
                    TT = { 
                        ANY = "Number of Healing Spheres to use Expel Harm. Used in conjunction with Expel Harm HP.", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Vivify
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "vivifyHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Vivify with Vivacious Vivification",
                    },
                    TT = { 
                        ANY = "HP (%) to use Vivify with Vivacious Vivification (also on party members!)", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "makDebug",
                    DBV = false,
                    L = { 
                        ANY = "Enable debug options",
                    }, 
                    TT = { 
                        ANY = "Show a box with various debug data.\nIt takes a couple of seconds to get rid of the box when you disable this.",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Zen Meditation", value = 1 },      
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                    },  
                    L = { 
                        ANY = "Aware Text Alert Reminders", 
                    }, 
                    TT = { 
                        ANY = "Select what text alert reminders you would like.\nThese will appear in the center of your screen.", 
                    }, 
                    M = {},                                    
                },  
            },                          
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },                    
        },
        [ACTION_CONST_MONK_WINDWALKER] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Windwalker Monk ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = false,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                { -- AOE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {},
                },
            },
            {
                { -- oor
                    E = "Checkbox", 
                    DB = "autoTarget",
                    DBV = false,
                    L = { 
                        ANY = "Automatic Target When Out Of Range",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to the closest target if out of range.",
                    }, 
                    M = {},
                },
            },
            {
                { -- nonmoving stomp
                    E = "Checkbox", 
                    DB = "stompStaying",
                    DBV = false,
                    L = { 
                        ANY = "Jadefire Stomp While Not Moving",
                    }, 
                    TT = { 
                        ANY = "Enabling this will make the rotation only use Jadefire Stomp when standing still.",
                    }, 
                    M = {},
                },
                { -- nonmoving wdp
                    E = "Checkbox", 
                    DB = "wdpStaying",
                    DBV = false,
                    L = { 
                        ANY = "Whirling Dragon Punch While Not Moving",
                    }, 
                    TT = { 
                        ANY = "Enabling this will make the rotation only use Whirling Dragon Punch when standing still.",
                    }, 
                    M = {},
                },
            },
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
            },
            {
                { -- TODSensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 15,                            
                    DB = "TODSensitivity",
                    DBV = 10,
                    ONOFF = false,
                    L = { 
                        ANY = "Touch of Death Sensitivity",
                    },
                    TT = { 
                        ANY = "Making this lower will increase the likelihood that it will use TOD, but it may end up using it on enemies that are already about to die anyway.", 
                    },                     
                    M = {},
                },    
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },    
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Burst and Cooldowns",
                    },
                },
            },
            { 
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "holdSEF",
                    DBV = true,
                    L = { 
                        ANY = "Save one charge of SEF to be used with Xuen",
                    }, 
                    TT = { 
                        ANY = "Enabling this option will prevent SEF from being used if it won't be ready again by the time Xuen can be used.",
                    }, 
                    M = {},
                },    
            },
            { 
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 30,                            
                    DB = "burstSens",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = "Time To Die Burst Sensitivity",
                    },
                    TT = { 
                        ANY = "Estimated time left until enemy dies before turning off burst.\nFor example, setting this to 15 will mean that we will not use damage cooldowns if all enemies are expected to die in less than 15 seconds.", 
                    },                     
                    M = {},
                },
            }, 
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Storm, Earth, and Fire", value = 1 },
                        { text = "Invoke Xuen", value = 2 },
                        { text = "Celestial Conduit", value = 3 },
                        { text = "Fists of Fury", value = 4 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = false,
                    },  
                    L = { 
                        ANY = "Cooldowns to use with Burst Toggle", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want to obey the Burst Toggle.\nUnchecking an ability means it will be used even when Burst is off.", 
                    }, 
                    M = {},                                    
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },    
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Damage Potions",
                    },
                },
            },
            { -- Potions
                { -- useDamagePotion
                    E = "Checkbox", 
                    DB = "damagePotion",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion"
                    }, 
                    TT = { 
                        ANY = "Use Damage Potion", 
                    }, 
                    M = {},
                },
                { -- potionBossOnly
                    E = "Checkbox", 
                    DB = "potionLustOnly",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion Bloodlust/TimeWarp Only", 
                    }, 
                    TT = { 
                        ANY = "Only use Damage Potion when any kind of Bloodlust/Warp active."
                    }, 
                    M = {},
                },
            },
            {
                { -- potionExhausted
                    E = "Checkbox", 
                    DB = "potionExhausted",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion With Exhaustion", 
                    }, 
                    TT = { 
                        ANY = "Use Damage Potion while Exhausted (can't use Bloodlust)."
                    }, 
                    M = {},
                },
                { -- potionExhaustedSlider
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 5,   
                    Precision = 1,                         
                    DB = "potionExhaustedSlider",
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = "Exhaustion Time Remaining",
                    },
                    TT = { 
                        ANY = "Time in minutes left on the Exhaustion Debuff to consider using Damage Potion.", 
                    },                     
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Defensives",
                    },
                },
            },
            { -- General -- Header
                {
                    E = "Label",
                    L = {
                        ANY = "Defensives will attempted to be used before incoming damage.\nThe HP% values are intended for unexpected damage.",
                    },
                },
            }, 
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Touch of Karma", value = 1 }, 
                        { text = "Diffuse Magic", value = 2 },     
                        { text = "Fortifying Brew", value = 3 },    
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                    },  
                    L = { 
                        ANY = "Defensive Abilities", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want the rotation to use as defensives.", 
                    }, 
                    M = {},                                    
                },  
            },  
            { 
                { -- Astral Shift
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "touchOfKarmaHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Touch of Karma",
                    },
                    TT = { 
                        ANY = "HP (%) to use Touch of Karma", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "diffuseMagicHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Diffuse Magic",
                    },
                    TT = { 
                        ANY = "HP (%) to use Diffuse Magic", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "fortifyingBrewHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Fortifying Brew",
                    },
                    TT = { 
                        ANY = "HP (%) to use Fortifying Brew", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Vivify
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "vivifyHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Vivify with Vivacious Vivification",
                    },
                    TT = { 
                        ANY = "HP (%) to use Vivify with Vivacious Vivification (also on party members!)", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "makDebug",
                    DBV = false,
                    L = { 
                        ANY = "Enable debug options",
                    }, 
                    TT = { 
                        ANY = "Show a box with various debug data.\nIt takes a couple of seconds to get rid of the box when you disable this.",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Chi Burst", value = 1 },     
                        { text = "Crackling Jade Lightning", value = 2 },   
                        { text = "Whirling Dragon Punch", value = 3 },   
                        { text = "Slicing Winds", value = 4 },   
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        ANY = "Aware Text Alert Reminders", 
                    }, 
                    TT = { 
                        ANY = "Select what text alert reminders you would like.\nThese will appear in the center of your screen.", 
                    }, 
                    M = {},                                    
                },  
            },                          
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },                    
        },
        [ACTION_CONST_MONK_MISTWEAVER] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Mistweaver Monk ====== ",
                    },
                },
            },
            {    
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
            },
            {
                { -- AOE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        ANY = "Use AoE", 
                    }, 
                    TT = { 
                        ANY = "Enable AoE", 
                    }, 
                    M = {},
                },
                { -- mouseover
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = false,
                    L = { 
                        ANY = "Mouseover",
                    }, 
                    TT = { 
                        ANY = "This does nothing! It's just necessary to have the option in the profile to prevent it from defaulting to on.",
                    }, 
                    M = {},
                },
            },
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
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "oorTarget",
                    DBV = true,
                    L = { 
                        ANY = "Auto Target Out Of Range",
                    }, 
                    TT = { 
                        ANY = "Automatically swap to a target you can hit in melee if you step out of range of your current target.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "augustCombo",
                    DBV = true,
                    L = { 
                        ANY = "August Dynasty on cooldown",
                    }, 
                    TT = { 
                        ANY = "Use Jadefire Stomp every 8 seconds to proc August Dynasty buff.",
                    }, 
                    M = {},
                },
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "pureFist",
                    DBV = false,
                    L = { 
                        ANY = "Pure Fistweave (Raid)",
                    }, 
                    TT = { 
                        ANY = "Focus purely on Ancient Teachings in raid (unless out of range).\nWill still consume Zen Pulse on anyone below HP slider.",
                    }, 
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Defensives",
                    },
                },
            },
            { -- General -- Header
                {
                    E = "Label",
                    L = {
                        ANY = "Defensives will attempted to be used before incoming damage.\nThe HP% values are intended for unexpected damage.",
                    },
                },
            }, 
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "fortifyingBrewHP",
                    DBV = 45,
                    ONOFF = false,
                    L = {
                        ANY = "Fortifying Brew HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Fortifying Brew."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "diffuseMagicHP",
                    DBV = 35,
                    ONOFF = false,
                    L = {
                        ANY = "Diffuse Magic HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Diffuse Magic."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Burst and Cooldowns",
                    },
                },
            },
            { 
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 30,                            
                    DB = "burstSens",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = "Time To Die Sensitivity",
                    },
                    TT = { 
                        ANY = "Estimated time left until enemy dies before disabling certain spells.\nFor example, setting this to 15 will mean that we will not use those spells if all enemies are expected to die in less than 15 seconds.", 
                    },                     
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "ChiJi / Yulon", value = 1 },
                        { text = "Thunder Focus Tea", value = 2 },
                        { text = "Crackling Jade Lightning", value = 3 },
                        { text = "Jadefire Stomp", value = 4 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        ANY = "Cooldowns to use with Burst Toggle", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want to obey the Burst Toggle.\nUnchecking an ability means it will be used even when Burst is off.", 
                    }, 
                    M = {},                                    
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Healing Values",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "envelopingMistHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Enveloping Mist HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Enveloping Mist. Only with instant cast."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "vivifyHP",
                    DBV = 75,
                    ONOFF = false,
                    L = {
                        ANY = "Vivify (instant) HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Vivify. Only with instant cast."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "vivifyHardHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Vivify (hard) HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Vivify. Hard casting only if Soothing Mist isn't learned."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "soomHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Soothing Mist HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Soothing Mist pumper combo. This includes Enveloping Mist and Vivify where appropriate."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "soomOORHP",
                    DBV = 65,
                    ONOFF = false,
                    L = {
                        ANY = "Soothing Mist Out Of Range HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Soothing Mist if you're not in melee range to punch things."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "HP",    value = 1 },
                        { text = "TTD",   value = 2 },
                    },
                    DB = "cocoonMode",
                    DBV = 1,
                    L = {
                        ANY = "Life Cocoon Mode",
                    },
                    TT = {
                        ANY = "Determine when to use Life Cocoon.\nHP = Use when HP is below the given value.\nTTD = Use when friendly is expected to die in less than the given time in seconds."
                    },
                    M = {},
                },
                { -- Randomist Cocoon
                    E = "Checkbox", 
                    DB = "randomiseCocoon",
                    DBV = true,
                    L = { 
                        ANY = "Random Delay on Cocoon",
                    }, 
                    TT = { 
                        ANY = "Add a radomised delay to casting Life Cocoon to look more human.",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "lifeCocoonHPtank",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Life Cocoon HP Tank (%)"
                    },
                    TT = {
                        ANY = "HP % to use Life Cocoon on tank.\nOnly when Cocoon mode set to HP."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "lifeCocoonHPother",
                    DBV = 25,
                    ONOFF = false,
                    L = {
                        ANY = "Life Cocoon HP non-tank (%)"
                    },
                    TT = {
                        ANY = "HP % to use Life Cocoon on anyone other than tank.\nOnly when Cocoon mode set to HP."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 20,
                    DB = "lifeCocoonTTDtank",
                    DBV = 5,
                    ONOFF = false,
                    L = {
                        ANY = "Life Cocoon TTD Tank"
                    },
                    TT = {
                        ANY = "Friendly TTD to use Life Cocoon on tank.\nOnly when Cocoon mode set to TTD."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 20,
                    DB = "lifeCocoonTTDall",
                    DBV = 5,
                    ONOFF = false,
                    L = {
                        ANY = "Life Cocoon TTD Non-Tank"
                    },
                    TT = {
                        ANY = "Friendly TTD to use Life Cocoon on non-tank.\nOnly when Cocoon mode set to TTD."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "expelHarmHP",
                    DBV = 75,
                    ONOFF = false,
                    L = {
                        ANY = "Expel Harm HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Expel Harm. This is lowish priority based on whether or not you're about to do AoE healing anyway."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- Critical Healing Header
                {
                    E = "Header",
                    L = {
                        ANY = "Critical Healing Thresholds",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "emergencyHP",
                    DBV = 15,
                    ONOFF = false,
                    L = {
                        ANY = "Emergency HP (%)"
                    },
                    TT = {
                        ANY = "Life Cocoon emergency usage threshold."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "criticalHP",
                    DBV = 25,
                    ONOFF = false,
                    L = {
                        ANY = "Critical HP (%)"
                    },
                    TT = {
                        ANY = "Critical healing threshold for Vivify (highest priority after Life Cocoon)."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- Season 3 Tier Set Header
                {
                    E = "Header",
                    L = {
                        ANY = "Season 3 Tier Set Controls",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "tierSetPriority",
                    DBV = true,
                    L = {
                        ANY = "Enable Tier Set Optimization"
                    },
                    TT = {
                        ANY = "Enable tier set optimization for Season 3."
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "maintainJadeSerpentBuff",
                    DBV = true,
                    L = {
                        ANY = "Auto-maintain Heart of Jade Serpent"
                    },
                    TT = {
                        ANY = "Automatically maintain Heart of Jade Serpent buff."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 15,
                    DB = "sheilunGiftMinStacks",
                    DBV = 8,
                    ONOFF = false,
                    L = {
                        ANY = "Sheilun's Gift Min Stacks"
                    },
                    TT = {
                        ANY = "Minimum stacks before using Sheilun's Gift."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- Hero Talent Header
                {
                    E = "Header",
                    L = {
                        ANY = "Hero Talent Controls",
                    },
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Conduit", value = 1 },
                        { text = "Harmony", value = 2 },
                    },
                    DB = "heroTalentBuild",
                    DBV = 1,
                    L = {
                        ANY = "Hero Talent Build",
                    },
                    TT = {
                        ANY = "Select your hero talent build: Conduit vs Harmony."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 5,
                    DB = "celestialConduitGroupThreshold",
                    DBV = 3,
                    ONOFF = false,
                    L = {
                        ANY = "Celestial Conduit Group Threshold"
                    },
                    TT = {
                        ANY = "Group threshold for Celestial Conduit usage."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- Enhanced Fistweaving Header
                {
                    E = "Header",
                    L = {
                        ANY = "Enhanced Fistweaving Controls",
                    },
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Pure", value = 1 },
                        { text = "Balanced", value = 2 },
                        { text = "Minimal", value = 3 },
                    },
                    DB = "fistweavingMode",
                    DBV = 2,
                    L = {
                        ANY = "Fistweaving Intensity",
                    },
                    TT = {
                        ANY = "Pure/Balanced/Minimal intensity for fistweaving rotation."
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "pureFistInRaids",
                    DBV = false,
                    L = {
                        ANY = "Pure Fistweaving in Raids"
                    },
                    TT = {
                        ANY = "Enable pure fistweaving in raid environments."
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- Enhanced Cooldown Management Header
                {
                    E = "Header",
                    L = {
                        ANY = "Enhanced Cooldown Management",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "burstMode",
                    DBV = false,
                    L = {
                        ANY = "Aggressive Cooldown Usage"
                    },
                    TT = {
                        ANY = "Enable aggressive cooldown usage mode."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 5,
                    MAX = 30,
                    DB = "burstThreshold",
                    DBV = 12,
                    ONOFF = false,
                    L = {
                        ANY = "Burst Threshold (seconds)"
                    },
                    TT = {
                        ANY = "Time sensitivity for burst cooldown usage."
                    },
                    M = {},
                },
            },
            {
                { -- Debug
                    E = "Checkbox",
                    DB = "makDebug",
                    DBV = false,
                    L = {
                        ANY = "Enable debug options",
                    },
                    TT = {
                        ANY = "Show a box with various debug data.\nIt takes a couple of seconds to get rid of the box when you disable this.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Crackling Jade Lightning", value = 1 },
                        { text = "Summon Active", value = 2 },   
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },  
                    L = { 
                        ANY = "Aware Text Alert Reminders", 
                    }, 
                    TT = { 
                        ANY = "Select what text alert reminders you would like.\nThese will appear in the center of your screen.", 
                    }, 
                    M = {},                                    
                },  
            },    
        },
    },
}    

