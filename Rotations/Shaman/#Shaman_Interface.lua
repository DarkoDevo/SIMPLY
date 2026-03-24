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


A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "TWW v2.0.1 (7 January 2025)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_SHAMAN_ENHANCEMENT] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Enhancement Shaman ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                    M = {
                        Custom = "/run Action.AoEToggleMode()",
                        -- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
                        Value = value or nil, 
                        -- Very Very Optional, no idea why it will be need however.. 
                        TabN = '@number' or nil,                                
                        Print = '@string' or nil,
                    },
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
                    DB = "autoRod",
                    DBV = true,
                    L = { 
                        ANY = "Auto Lightning Rod",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to apply Lightning Rod.",
                    }, 
                    M = {},
                },
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "pauseWhenWolf",
                    DBV = false,
                    L = { 
                        ANY = "Pause when Wolf",
                    }, 
                    TT = { 
                        ANY = "Pause everything when in Ghost Wolf (you will need to manually exit Ghost Wolf)",
                    }, 
                    M = {},
                },	
            },
            {
                { -- PWaveTempest
                    E = "Checkbox", 
                    DB = "esInCombat",
                    DBV = false,
                    L = { 
                        ANY = "Earth Shield in Combat",
                    }, 
                    TT = { 
                        ANY = "Reapply Earth Shield while in combat.",
                    }, 
                    M = {},
                },
                { -- PWaveTempest
                    E = "Checkbox", 
                    DB = "savePWave",
                    DBV = false,
                    L = { 
                        ANY = "Spend PWave on Tempest (AoE)",
                    }, 
                    TT = { 
                        ANY = "Only spend Primordial Wave buff on Tempest in AoE.",
                    }, 
                    M = {},
                },
            },
            {
                { -- PWaveTempest
                    E = "Checkbox", 
                    DB = "resetTi",
                    DBV = false,
                    L = { 
                        ANY = "Hard Reset TI",
                    }, 
                    TT = { 
                        ANY = "Hard reset Thorim's Invocation primed spell when leaving combat.\nEnabling this will force the rotation to think that Lightning Bolt is primed when starting a new AoE pack.",
                    }, 
                    M = {},
                },
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "estTempest",
                    DBV = false,
                    L = { 
                        ANY = "Estimate Tempest",
                    }, 
                    TT = { 
                        ANY = "Estimate Maelstrom Weapon buildup for Tempest.\nWe will keep track of Maelstrom Weapon spent and prepare when we have 10 Maelstrom Weapon to go.\nWARNING: THE RESULTS OF THIS CAN BE VOLATILE.\nIn-game Tempest counts only reset when you log out completely. IF YOU EVER RELOAD YOUR GAME WITHOUT RELOGGING, THESE NUMBERS WILL BE INACCURATE.\nWorst Blizzard design yet.",
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
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Ascendance", value = 1 },
                        { text = "Feral Spirit", value = 2 },
                        { text = "Doom Winds", value = 3 },
                        { text = "Primordial Wave", value = 4 },
                        { text = "Tempest", value = 5 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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
            { 
                {
                    E = "Dropdown",
                    OT = {
                        { text = "TTD", value = "1" },
                        { text = "Classification + HP", value = "2" },
                    },
                    DB = "burstStyle",
                    DBV = "1",
                    L = {
                        ANY = "Burst Style",
                    },
                    TT = {
                        ANY = "TTD: Activate burst based on enemy time to die slider below.\nClassification + HP: Based on a combination of enemy unit classification (boss, elite, etc) plus HP value."
                    },
                    M = {},
                },	
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 30,                            
                    DB = "burstSens",
                    DBV = 0,
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
                        { text = "Tremor Totem", value = 1 }, 
                        { text = "Capacitor Totem", value = 2 }, 
                        { text = "Stone Bulwark Totem", value = 3 }, 
                        { text = "Static Field Totem", value = 4 }, 
                        { text = "Grounding Totem", value = 5 },
                        { text = "Wind Rush Totem", value = 6 },
                        { text = "Poson Cleansing Totem", value = 7 },
                        { text = "Healing Stream Totem", value = 8},

                    },
                    MULT = true,
                    DB = "recallSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = false,
                        [7] = false,
                        [8] = false,
                    },  
                    L = { 
                        ANY = "Totemic Recall Spells", 
                    }, 
                    TT = { 
                        ANY = "Select what totems to be reset with Totemic Recall.", 
                    }, 
                    M = {},                                    
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
                        { text = "Astral Shift", value = 1 }, 
                        { text = "Stone Bulwark Totem", value = 2 },     
                        { text = "Ancestral Guidance", value = 3 },    
                        { text = "Earth Elemental", value = 4 }, 
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
                { -- Astral Shift
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "astralShiftHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Astral Shift",
                    },
                    TT = { 
                        ANY = "HP (%) to use Astral Shift", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "stoneBulwarkTotemHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Stone Bulwark Totem",
                    },
                    TT = { 
                        ANY = "HP (%) to use Stone Bulwark Totem", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ancestralGuidanceHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Ancestral Guidance",
                    },
                    TT = { 
                        ANY = "HP (%) to use Ancestral Guidance", 
                    },                     
                    M = {},
                }, 
                { -- Earth Elemental
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "earthElementalHP",
                    DBV = 30,
                    ONOFF = false,
                    L = { 
                        ANY = "Earth Elemental",
                    },
                    TT = { 
                        ANY = "HP (%) to use Earth Elemental", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Healing Surge
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "healingSurgeHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Healing Surge (self and party)",
                    },
                    TT = {
                        ANY = "HP (%) to use Healing Surge",
                    },
                    M = {},
                },
                { -- Healing Stream Totem
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "healingStreamTotemHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Healing Stream Totem",
                    },
                    TT = {
                        ANY = "HP (%) to use Healing Stream Totem for party healing",
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
                        { text = "Using Hex", value = 1 },     
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
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Elemental Shaman ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "cursorCheck",
                    DBV = true,
                    L = { 
                        ANY = "Cursor Check (EQ / LMT)",
                    }, 
                    TT = { 
                        ANY = "Check if enemies are under cursor before using LMT.",
                    }, 
                    M = {},
                },		
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "autoRod",
                    DBV = true,
                    L = { 
                        ANY = "Auto Lightning Rod",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to apply Lightning Rod.",
                    }, 
                    M = {},
                },	
            },
            { 
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "pauseWhenWolf",
                    DBV = false,
                    L = { 
                        ANY = "Pause when Wolf",
                    }, 
                    TT = { 
                        ANY = "Pause everything when in Ghost Wolf (you will need to manually exit Ghost Wolf)",
                    }, 
                    M = {},
                },	
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "OnlyTremorHealer",
                    DBV = true,
                    L = { 
                        ANY = "Only Tremor Totem for Healers",
                    }, 
                    TT = { 
                        ANY = "We will only tremor totem if healer on the team is feared",
                    }, 
                    M = {},
                },	
            },
            {
                { -- Automatic Interrupt
                    E = "Checkbox",
                    DB = "fullSendTempest",
                    DBV = false,
                    L = {
                        ANY = "Use Tempest on CD",
                    },
                    TT = {
                        ANY = "Enabling this will use Tempest as soon as it's available.\nThis option still respects the burst/TTD settings.",
                    },
                    M = {},
                },
                { -- Automatic Interrupt
                    E = "Checkbox",
                    DB = "tempestNothingLeft",
                    DBV = true,
                    L = {
                        ANY = "Consume Tempest when nothing left to use",
                    },
                    TT = {
                        ANY = "If burst is OFF and we have nothing else to press, this will enable us to use Tempest.\nThis will happen in single target scenarios when enemies are low HP and don't die fast enough.\nIf this is disabled, you will spam Frost Shock when there is nothing else to do.",
                    },
                    M = {},
                },
            },
            { 
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
                { -- ST Spenders with AoE Builders
                    E = "Checkbox",
                    DB = "stSpendersAoeBuilders",
                    DBV = false,
                    L = {
                        ANY = "ST Spenders with AoE Builders",
                    },
                    TT = {
                        ANY = "When enabled, allows Chain Lightning for AoE building while using single-target spenders (Earth Shock instead of Earthquake).\nUseful for cleaving multiple targets while focusing burst damage on a priority target.",
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
                        ANY = "Cooldowns Usage",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Fire / Storm Elemental", value = 1 }, 
                        { text = "Ascendance", value = 2 },                             
                        { text = "Stormkeeper", value = 3 },     
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = false,
                        [2] = false,
                        [3] = true,
                    },  
                    L = { 
                        ANY = "Cooldowns to ignore Burst Toggle", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want the rotation to use even while burst toggle is turned off.", 
                    }, 
                    M = {},                                    
                },  
            },
            { 
                {
                    E = "Dropdown",
                    OT = {
                        { text = "TTD", value = "1" },
                        { text = "Classification + HP", value = "2" },
                    },
                    DB = "burstStyle",
                    DBV = "2",
                    L = {
                        ANY = "Burst Style",
                    },
                    TT = {
                        ANY = "TTD: Activate burst based on enemy time to die slider below.\nClassification + HP: Based on a combination of enemy unit classification (boss, elite, etc) plus HP value."
                    },
                    M = {},
                },	
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
                        { text = "Tremor Totem", value = 1 }, 
                        { text = "Capacitor Totem", value = 2 }, 
                        { text = "Stone Bulwark Totem", value = 3 }, 
                        { text = "Static Field Totem", value = 4 }, 
                        { text = "Grounding Totem", value = 5 },
                        { text = "Liquid Magma Totem", value = 6 },
                        { text = "Wind Rush Totem", value = 7 },
                        { text = "Poson Cleansing Totem", value = 8 },
                        { text = "Healing Stream Totem", value = 9},
                    },
                    MULT = true,
                    DB = "recallSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = false,
                        [8] = true,
                        [9] = false,
                    },  
                    L = { 
                        ANY = "Totemic Recall Spells", 
                    }, 
                    TT = { 
                        ANY = "Select what totems to be reset with Totemic Recall.", 
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
                        { text = "Astral Shift", value = 1 }, 
                        { text = "Stone Bulwark Totem", value = 2 },     
                        { text = "Ancestral Guidance", value = 3 },    
                        { text = "Earth Elemental", value = 4 }, 
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
                { -- Astral Shift
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "astralShiftHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Astral Shift",
                    },
                    TT = { 
                        ANY = "HP (%) to use Astral Shift", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "stoneBulwarkTotemHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Stone Bulwark Totem",
                    },
                    TT = { 
                        ANY = "HP (%) to use Stone Bulwark Totem", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ancestralGuidanceHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Ancestral Guidance",
                    },
                    TT = { 
                        ANY = "HP (%) to use Ancestral Guidance", 
                    },                     
                    M = {},
                }, 
                { -- Earth Elemental
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "earthElementalHP",
                    DBV = 30,
                    ONOFF = false,
                    L = { 
                        ANY = "Earth Elemental",
                    },
                    TT = { 
                        ANY = "HP (%) to use Earth Elemental", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Healing Surge
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "healingSurgeHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Healing Surge (self and party)",
                    },
                    TT = {
                        ANY = "HP (%) to use Healing Surge",
                    },
                    M = {},
                },
                { -- Healing Stream Totem
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "healingStreamTotemHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Healing Stream Totem",
                    },
                    TT = {
                        ANY = "HP (%) to use Healing Stream Totem for party healing",
                    },
                    M = {},
                },
                { -- Burrow
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "burrowHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Burrow HP (PvP)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Burrow", 
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
                { -- FakeCasting
                E = "Checkbox", 
                DB = "fakeCasting",
                DBV = false,
                L = { 
                    ANY = "Enable fakecasting in arena",
                }, 
                TT = { 
                    ANY = "This will attempt to fakecast hex if you don't have precog and if someone is in range with a kick of you off CD.",
                }, 
                M = {},
            },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Liquid Magma Totem", value = 1 },     
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
        [ACTION_CONST_SHAMAN_RESTORATION] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Restoration Shaman ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                {
                    E = "Checkbox", 
                    DB = "Iconbar1",
                    DBV = false,
                    L = { 
                        enUS = "Queuebar", 
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
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                    DB = "pauseWhenWolf",
                    DBV = false,
                    L = { 
                        ANY = "Pause when Wolf",
                    }, 
                    TT = { 
                        ANY = "Pause everything when in Ghost Wolf (you will need to manually exit Ghost Wolf)",
                    }, 
                    M = {},
                },	
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Healing Settings ] ===", },},},
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
            {
                { -- potionExhaustedSlider
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,   
                    Precision = 1,                         
                    DB = "stopCastPercent",
                    DBV = 50,
                    ONOFF = true,
                    L = { 
                        ANY = "Threshhold for team HP% to StopCast damage.",
                    },
                    TT = { 
                        ANY = "If anyone on party/raid drops below this value and we are casting daamge/cc we will stop cast to heal.", 
                    },                     
                    M = {},
                },
            },
            {	
                { -- RiptideHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "riptideHP",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Riptide (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Riptide / Primordial Wave.", 
                    },                     
                    M = {},
                },			
                { -- Unleash Life
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "unleashLifeHP",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Unleash Life (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Unleash Life.", 
                    },                     
                    M = {},
                },			
            },
            {	
                { -- healingWaveHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "healingWaveHP",
                    DBV = 0,
                    ONOFF = true,
                    L = { 
                        ANY = "Healing Wave (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Healing Wave.\nNote, this will still be used with Primordial Wave buffs even if turned to 0%.", 
                    },                     
                    M = {},
                },		
                { -- healingSurgeHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "healingSurgeHP",
                    DBV = 80,
                    ONOFF = true,
                    L = { 
                        ANY = "Healing Surge (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Healing Surge.", 
                    },                     
                    M = {},
                },				
            },
            {	
                { -- healingSurgeHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "chainHealHP",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Chain Heal (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Chain Heal.", 
                    },                     
                    M = {},
                },			
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "chainHealMode",
                    DBV = "Off",
                    L = {
                        ANY = "Chain Heal Mode",
                    },
                    TT = {
                        enUS = "Auto: will use it with Unleash Life / Hide Tide.\nAlways: will use it whenever AoE healing is needed."
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "healingRainMode",
                    DBV = "Auto",
                    L = {
                        ANY = "Healing Rain / Surging Totem",
                    },
                    TT = {
                        enUS = "Auto: will use it when AoE healing is needed.\nAlways: will use it always and keep it on cooldown."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "rampMode",
                    DBV = false,
                    L = {
                        ANY = "Enable Ramp Mode",
                    },
                    TT = {
                        ANY = "Enable ramp functionality with Cloudburst Totem, Unleash Life, and Ancestral Swiftness coordination."
                    },
                    M = {},
                },
            },
            {
                { -- popCB
                    E = "Checkbox", 
                    DB = "autoPopCB",
                    DBV = true,
                    L = { 
                        ANY = "Consume Cloudburst Totem on leaving combat", 
                    }, 
                    TT = { 
                        ANY = "Automatically pop/consume Cloudburst Totem when leaving combat."
                    }, 
                    M = {},
                },
                { -- Tidal Wave
                    E = "Checkbox", 
                    DB = "tidalwave",
                    DBV = false,
                    L = { 
                        ANY = "Tidal Wave Weaving", 
                    }, 
                    TT = { 
                        ANY = "If enabled, we will only use Riptide to generate Tidal Waves or while moving"
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
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "acidRain",
                    DBV = true,
                    L = { 
                        ANY = "Acid Rain Offensively",
                    }, 
                    TT = { 
                        ANY = "Use Healing Rain / Surging Totem for Acid Rain damage.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Earth Shield
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 9,                            
                    DB = "earthShieldStacks",
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Refresh Earth Shield at stacks",
                    },
                    TT = { 
                        ANY = "Number of stacks to refresh Earth Shield (good for Totemic talent)", 
                    },                     
                    M = {},
                },	
                { -- Water Shield
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 9,                            
                    DB = "waterShieldStacks",
                    DBV = 1,
                    ONOFF = true,
                    L = { 
                        ANY = "Refresh Water Shield at stacks",
                    },
                    TT = { 
                        ANY = "Number of stacks to refresh Water Shield (good for Totemic talent", 
                    },                     
                    M = {},
                },	
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Tremor Totem", value = 1 }, --Tremor Totem
                        { text = "Capacitor Totem", value = 2 }, --Capacitor Totem
                        { text = "Stone Bulwark Totem", value = 3 }, --Stone Bulwark Totem
                        { text = "Static Field Totem", value = 4 }, -- Static Field Totem
                        { text = "Grounding Totem", value = 5 }, -- Grounding Totem
                        { text = "Earthen Wall Totem ", value = 6 }, -- Grounding Totem
                        { text = "Wind Rush Totem", value = 7 },
                        { text = "Poson Cleansing Totem", value = 8 },
                        { text = "Healing Stream Totem", value = 9},
                    },
                    MULT = true,
                    DB = "recallSelect",
                    DBV = {
                        [1] = false,
                        [2] = false,
                        [3] = false,
                        [4] = false,
                        [5] = false,
                        [6] = true,
                        [7] = false,
                        [8] = false,
                        [9] = false,
                    },  
                    L = {
                        ANY = "Totem Recall Spells", 
                    }, 
                    TT = { 
                        ANY = "Select what totems to be reset with Totemic Recall.", 
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
                        { text = "Astral Shift", value = 1 }, 
                        { text = "Stone Bulwark Totem", value = 2 },     
                        { text = "Ancestral Guidance", value = 3 },    
                        { text = "Earth Elemental", value = 4 }, 
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
                { -- Astral Shift
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "astralShiftHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Astral Shift",
                    },
                    TT = { 
                        ANY = "HP (%) to use Astral Shift", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "stoneBulwarkTotemHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Stone Bulwark Totem",
                    },
                    TT = { 
                        ANY = "HP (%) to use Stone Bulwark Totem", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ancestralGuidanceHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Ancestral Guidance",
                    },
                    TT = { 
                        ANY = "HP (%) to use Ancestral Guidance", 
                    },                     
                    M = {},
                }, 
                { -- Earth Elemental
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "earthElementalHP",
                    DBV = 30,
                    ONOFF = false,
                    L = { 
                        ANY = "Earth Elemental",
                    },
                    TT = { 
                        ANY = "HP (%) to use Earth Elemental", 
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
                        ANY = "Damage Potion",
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
                        { text = "What Totem Am I Placing?", value = 1 },     
                        { text = "Healing Rain / Surging Totem Ready", value = 2 },     
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
        },
    },
}

