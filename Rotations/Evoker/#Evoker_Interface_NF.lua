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

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "TWW v1.0.0 (6 Sept 2024)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_EVOKER_DEVASTATION] = { 
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
                { -- Cursor
                    E = "Checkbox", 
                    DB = "cursorCheck",
                    DBV = true,
                    L = { 
                        ANY = "Cursor Check (Firestorm)", 
                    }, 
                    TT = { 
                        ANY = "Check that the cursor is over an enemy before using Firestorm."
                    }, 
                    M = {},
                }, 
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "AutoInterrupt",
                    DBV = false,
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
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " ====== COOLDOWNS ====== ",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Dragonrage", value = 1 }, 
                        { text = "Deep Breath", value = 2 },                             
                        { text = "Tip The Scales", value = 3 },     
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = false,
                        [2] = false,
                        [3] = false,
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
                { -- Burst Sensitivity
                    E = "Slider",
                    MIN = 0, 
                    MAX = 30,                            
                    DB = "burstSens",
                    DBV = 10,
                    ONOFF = false,
                    L = { 
                        ANY = "Burst Sensitivity",
                    },
                    TT = { 
                        ANY = "How sensitive burst detection is regarding enemies near death.\nThe higher the number, the more HP required for the enemy to have to trigger burst.",
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
                        ANY = " ====== DAMAGE POTIONS ====== ",
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
                        ANY = " ====== DEFENSIVES ====== ",
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
                        { text = "Obsidian Scales", value = 1 }, 
                        { text = "Zephyr", value = 2 },     
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
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
                { -- Obsidian Scales
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "obsidianScalesHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Obsidian Scales",
                    },
                    TT = { 
                        ANY = "HP (%) to use Obsidian Scales", 
                    },                     
                    M = {},
                },  
                { -- Zephyr
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "zephyrHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Zephyr",
                    },
                    TT = { 
                        ANY = "HP (%) to use Zephyr", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "renewingBlazeHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Renewing Blaze",
                    },
                    TT = { 
                        ANY = "HP (%) to use Renewing Blaze.", 
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
                { -- heal for dps
                    E = "Checkbox", 
                    DB = "healForDPS",
                    DBV = true,
                    L = { 
                        ANY = "Heal For DPS Gain"
                    }, 
                    TT = { 
                        ANY = "Use Green spells for DPS gain when appropriate, even if ally/player at full HP.",
                    }, 
                    M = {},
                },
                { -- heal target
                    E = "Checkbox", 
                    DB = "healTarget",
                    DBV = true,
                    L = { 
                        ANY = "Living Flame Target Heal"
                    }, 
                    TT = { 
                        ANY = "Use Living Flame to heal your target if they're missing HP.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Verdant Embrace HP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,                        
                    DB = "verdantEmbraceHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Verdant Embrace",
                    },
                    TT = { 
                        ANY = "HP (%) to use Verdant Embrace in an emergency.",
                    },                     
                    M = {},
                },  
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Tank", value = 1 },
                        { text = "Healer", value = 2 },
                        { text = "DPS", value = 3 },
                        { text = "Self", value = 4 },
                    },
                    MULT = true,
                    DB = "veSelect",
                    DBV = {
                        [1] = false,
                        [2] = false,
                        [3] = false,
                        [4] = true,
                    },
                    L = {
                        ANY = "Verdant Embrace Units", 
                    },
                    TT = {
                        ANY = "Select what units you want to use Verdant Embrace on.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Emerald Blossom
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "emeraldBlossomHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Emerald Blossom",
                    },
                    TT = { 
                        ANY = "HP (%) to use Emerald Blossom in an emergency.",
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
                        { text = "Hover", value = 1 },
                        { text = "Deep Breath", value = 2 },
                        { text = "Out of Range", value = 3 },
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
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
        [1473] = { 
            { -- GENERAL OPTIONS FIRST ROW
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
                { -- Hover
                    E = "Checkbox",
                    DB = "useHover",
                    DBV = true,
                    L = {
                        ANY = "Use Hover",
                    },
                    TT = {
                        ANY = "Automatically use Hover when moving and in combat.",
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
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
        },
        [ACTION_CONST_EVOKER_PRESERVATION] = { 
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
                        ANY = " ====== DEFENSIVES ====== ",
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
                        { text = "Obsidian Scales", value = 1 }, 
                        { text = "Zephyr", value = 2 },     
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
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
                { -- Obsidian Scales
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "obsidianScalesHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Obsidian Scales",
                    },
                    TT = { 
                        ANY = "HP (%) to use Obsidian Scales", 
                    },                     
                    M = {},
                },  
                { -- Zephyr
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "zephyrHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Zephyr",
                    },
                    TT = { 
                        ANY = "HP (%) to use Zephyr", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "renewingBlazeHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Renewing Blaze",
                    },
                    TT = { 
                        ANY = "HP (%) to use Renewing Blaze.", 
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
                        ANY = " ====== HEALING ====== ",
                    },
                },
            },
            {
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "spreadEcho",
                    DBV = false,
                    L = { 
                        ANY = "Spread Echo",
                    }, 
                    TT = { 
                        ANY = "Spread Echo across the raid.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Verdant Embrace HP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,                        
                    DB = "verdantEmbraceHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = "Verdant Embrace",
                    },
                    TT = { 
                        ANY = "HP (%) to use Verdant Embrace.",
                    },                     
                    M = {},
                },  
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Tank", value = 1 },
                        { text = "Healer", value = 2 },
                        { text = "DPS", value = 3 },
                        { text = "Self", value = 4 },
                    },
                    MULT = true,
                    DB = "veSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },
                    L = {
                        ANY = "Verdant Embrace Units", 
                    },
                    TT = {
                        ANY = "Select what units you want to use Verdant Embrace on.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Reversion
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "reversionHP",
                    DBV = 95,
                    ONOFF = false,
                    L = { 
                        ANY = "Reversion",
                    },
                    TT = { 
                        ANY = "HP (%) to use Reversion.",
                    },               
                    M = {},
                },
                { -- Emerald Blossom
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "emeraldBlossomHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Emerald Blossom",
                    },
                    TT = { 
                        ANY = "HP (%) to use Emerald Blossom.",
                    },               
                    M = {},
                },
            },
            {
                { -- Echo
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "echoHP",
                    DBV = 90,
                    ONOFF = false,
                    L = { 
                        ANY = "Echo",
                    },
                    TT = { 
                        ANY = "HP (%) to use Echo.",
                    },               
                    M = {},
                },
                { -- Emerald Blossom
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "livingFlameHP",
                    DBV = 90,
                    ONOFF = false,
                    L = { 
                        ANY = "Living Flame",
                    },
                    TT = { 
                        ANY = "HP (%) to use Living Flame (heal).",
                    },               
                    M = {},
                },
            },
            {
                { -- DPS Mana
                    E = "Slider",
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "dpsMana",
                    DBV = 30,
                    ONOFF = false,
                    L = { 
                        ANY = "DPS above mana",
                    },
                    TT = { 
                        ANY = "Mana (%) to use DPS abilities.",
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
                        { text = "Hover", value = 1 },
                        { text = "Dream Breath", value = 2 },
                        { text = "Stasis", value = 3 },
                        { text = "Out of Range", value = 4 },
                        { text = "Spread Echo", value = 5 },
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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