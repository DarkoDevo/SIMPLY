local TMW											= TMW 
local CNDT											= TMW.CNDT
local Env											= CNDT.Env

local A												= Action
local GetToggle										= A.GetToggle
local InterruptIsValid								= A.InterruptIsValid

local UnitCooldown									= A.UnitCooldown
local Unit											= A.Unit 
local Player										= A.Player 
local Pet											= A.Pet
local LoC											= A.LossOfControl
local MultiUnits									= A.MultiUnits
local EnemyTeam										= A.EnemyTeam
local FriendlyTeam									= A.FriendlyTeam
local TeamCache										= A.TeamCache
local InstanceInfo									= A.InstanceInfo
local select, setmetatable							= select, setmetatable

local GameLocale                                        = A.FormatGameLocale(_G.GetLocale())
local StdUi                                                = A.StdUi
local Factory                                            = StdUi.Factory
local math_random                                        = math.random

local function applyPresetValues(label, values)
    local changed = false
    for key, value in pairs(values) do
        if A.GetToggle(2, key) ~= value then
            A.SetToggle({ 2, key, nil, true }, value)
            changed = true
        end
    end

    if changed then
        A.Print(label .. " preset applied. Reopen /action to refresh values.")
    end
end

local function applyMistweavePreset()
    applyPresetValues("Mistweave", {
        fistweaving = false,
        pureFist = false,
        fistweaveStopHPpve = 80,
        fistweaveStopCdsHPpve = 90,
        fistweaveStopHPpvp = 70,
        fistweaveStopCdsHPpvp = 85,
    })
end

local function applyFistweavePreset()
    applyPresetValues("Fistweave", {
        fistweaving = true,
        pureFist = true,
        fistweaveStopHPpve = 55,
        fistweaveStopCdsHPpve = 70,
        fistweaveStopHPpvp = 60,
        fistweaveStopCdsHPpvp = 75,
    })
end

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
            {   -- Fistweaving PvP
                {
                    E = "Checkbox",
                    DB = "fistweaving",
                    DBV = false,
                    L = {
                        ANY = "Fistweave Mode (PvP)",
                    },
                    TT = {
                        ANY = "Enable hybrid fistweaving priority in PvP when Harmony/Ancient Teachings is active.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = "Playstyle Presets",
                    },
                },
            },
            {   -- Preset Buttons 
                {   -- Mistweave Presets Button
                    E = "Button",
                    H = 20,
                    L = {
                        ANY = "Mistweave Preset",
                    },
                    TT = {
                        ANY = "Apply Mistweave-focused toggles and thresholds.\nReopen /action to refresh values.",
                    },
                    OnClick = function()
                        applyMistweavePreset()
                    end,
                },
                {   -- Fistweave Presets Button
                    E = "Button",
                    H = 20,
                    L = {
                        ANY = "Fistweave Preset",
                    },
                    TT = {
                        ANY = "Apply Fistweave-focused toggles and thresholds.\nReopen /action to refresh values.",
                    },
                    OnClick = function()
                        applyFistweavePreset()
                    end,
                },
            },
            {   -- Mistweave Preset Frame
                {
                    E = "Checkbox",
                    DB = "mwPresetFrame",
                    DBV = false,
                    L = {
                        ANY = "Show Preset Frame",
                    },
                    TT = {
                        ANY = "Show a small draggable frame with Mistweave/Fistweave preset buttons.",
                    },
                    M = {},
                },
            },
            {   -- Stop Fistweave HP Sliders
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "fistweaveStopHPpve",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Stop Fistweave HP (%) PvE",
                    },
                    TT = {
                        ANY = "Switch from fistweave to full healing when the lowest ally drops below this HP in PvE.",
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "fistweaveStopCdsHPpve",
                    DBV = 75,
                    ONOFF = false,
                    L = {
                        ANY = "Stop Fistweave HP (Enemy CDs) PvE",
                    },
                    TT = {
                        ANY = "More conservative stop threshold while enemy cooldowns are active in PvE.",
                    },
                    M = {},
                },
            },
            {   -- Stop Fistweaving When HP drops below these Sliders
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "fistweaveStopHPpvp",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Stop Fistweave HP (%) PvP",
                    },
                    TT = {
                        ANY = "Switch from fistweave to full healing when the lowest ally drops below this HP in PvP.",
                    },
                    M = {},
                },
                { -- Stop Fistweaving When Enemy CDs are Active and HP drops below these Sliders
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "fistweaveStopCdsHPpvp",
                    DBV = 75,
                    ONOFF = false,
                    L = {
                        ANY = "Stop Fistweave HP (Enemy CDs) PvP",
                    },
                    TT = {
                        ANY = "More conservative stop threshold while enemy cooldowns are active in PvP.",
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
                    DBV = 50,
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
                    DBV = 55,
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
                    DBV = 35,
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
                    DBV = 35,
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
                    DBV = 80,
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
