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
    DateTime = "TWW v1.0.0 (12 August 2024)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_DEMONHUNTER_HAVOC] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - BETA Havoc Demon Hunter ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = false,
                    L = { 
                        ANY = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        ANY = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
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
                        ANY = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        ANY = "Enable multiunits actions", 
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
                    DB = "antiFakeRotation",
                    DBV = false,
                    L = { 
                        ANY = "AntiFake Rotation",
                    }, 
                    TT = { 
                        ANY = "This enables the usage of antifake for CC on your focus target.\nOnly use this if you want to manually control your CCs on your focus target.\nUses the START AntiFake CC bind.",
                    }, 
                    M = {},
                },
            },
            { 
                { -- Swap For Melee
                    E = "Checkbox", 
                    DB = "SwapForMelee",
                    DBV = true,
                    L = { 
                        ANY = "Switch Targets Melee",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets for melee.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "autotarget",
                    DBV = true,
                    L = {
                        ANY = "Auto Target",
                    },
                    TT = {
                        ANY = "Swappers",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== MACROS ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "sigilMouseOver",
                    DBV = false,
                    L = {
                        ANY = "Sigils Mouse Over",
                    },
                    TT = {
                        ANY = "Checked = Sigils on mouse over target, Unchecked = Sigils on player. Must edit the macros to [@player] or [@cursor].",
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
                        ANY = "Cooldowns",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Metamorphosis", value = 1 }, 
                        { text = "The Hunt", value = 2 },     
                        { text = "Sigil of Spite", value = 3 }, 
                        { text = "Essence Break", value = 4 }, 
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = false,
                        [2] = false,
                        [3] = false,
                        [4] = true,
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
                        { text = "Blur", value = 1 }, 
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
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
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "blurHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Blur",
                    },
                    TT = { 
                        ANY = "HP (%) to use Blur", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "darknessHP",
                    DBV = 45,
                    ONOFF = false,
                    L = { 
                        ANY = "Darkness",
                    },
                    TT = { 
                        ANY = "HP (%) to use Darkness", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "netherwalkHP",
                    DBV = 20,
                    ONOFF = false,
                    L = { 
                        ANY = "Netherwalk",
                    },
                    TT = { 
                        ANY = "HP (%) to use Netherwalk", 
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
                        { text = "Nothing Yet", value = 1 },      
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
        [ACTION_CONST_DEMONHUNTER_VENGEANCE] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " **Vengance DH BETA** ",
                    },
                },
            },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== GENERAL ====== ",
                    },
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- AOE
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        ANY = "Use AoE",
                        ruRU = "Использовать AoE",
                        frFR = "Utiliser l'AoE",
                    },
                    TT = {
                        ANY = "Enable multiunits actions",
                        ruRU = "Включает действия для нескольких целей",
                        frFR = "Activer les actions multi-unités",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "usedbm",
                    DBV = true,
                    L = {
                        ANY = "Enable DBM Intigration",
                    },
                    TT = {
                        ANY = "Will use DBM timers for smart defensive usage.",
                    },
                    M = {},
                }
            },
            { -- AUTO OPTIONS
                {
                    E = "Checkbox",
                    DB = "autotarget",
                    DBV = true,
                    L = {
                        ANY = "Auto Target",
                    },
                    TT = {
                        ANY = "Taunt, Multi-Dot, Interrupt, etc.",
                    },
                    M = {},
                },
				{
                    E = "Checkbox",
                    DB = "autotaunt",
                    DBV = true,
                    L = {
                        ANY = "Auto Taunt (Non-Raid)",
                    },
                    TT = {
                        ANY = "Auto Taunt in non-raid environments",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "targetmelee",
                    DBV = true,
                    L = {
                        ANY = "Auto Target Melee",
                    },
                    TT = {
                        ANY = "Auto swap targets for malee targeting.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "felbladeMelee",
                    DBV = true,
                    L = {
                        ANY = "FelBlade Melee Only",
                    },
                    TT = {
                        ANY = "Auto swap targets for malee targeting.",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== MACROS ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "sigilMouseOver",
                    DBV = false,
                    L = {
                        ANY = "Sigils Mouse Over",
                    },
                    TT = {
                        ANY = "Checked = Sigils on mouse over target, Unchecked = Sigils on player. Must edit the macros to set if using V1. If using meta engine reload after changing.",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
            { -- CLEANSE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== UTIL ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "MetaDefensive",
                    DBV = false,
                    L = {
                        ANY = "Meta Defensive Only",
                    },
                    TT = {
                        ANY = "Save Meta for defensive purposes only.",
                    },
                    M = {},
                }
            },
            {
                { -- FelDevastationHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 2,
                    DB = "holdInfernalStrikeCharges",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Save Infernal Strike Charges",
                    },
                    TT = {
                        ANY = "The amount of Infernal Strike charges to save for manual use.\nSetting this to 2 will mean that the rotation will NEVER use Infernal Strike automatically.\nSetting this to 0 will mean that the rotation will use ALL charges of Infernal Strike automatically.",
                    },
                    M = {},
                },
                { -- FelDevastationHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 2,
                    DB = "holdThrowGlaiveCharges",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Save Throw Glaive Charges",
                    },
                    TT = {
                        ANY = "The amount of Throw Glaive charges to save for manual use.\nSetting this to 2 will mean that the rotation will NEVER use Throw Glaive automatically.\nSetting this to 0 will mean that the rotation will use ALL charges of Throw Glaive automatically.",
                    },
                    M = {},
                },
            },
            {
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    Precision = 1,
                    DB = "felbladeTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Felblade Movement Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Felblade.\nUseful for when stepping out of an AoE mechanic.",
                    },
                    M = {},
                },
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    Precision = 1,
                    DB = "felDevastationTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Fel Devastation Movement Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Fel Devastation.\nUseful for when stepping out of an AoE mechanic/grouping up enemies.",
                    },
                    M = {},
                },
            },
            {
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    Precision = 1,
                    DB = "sigilOfSpiteTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Sigil of Spite Movement Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Sigil of Spite.\nUseful for when grouping up enemies.",
                    },
                    M = {},
                },
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    Precision = 1,
                    DB = "darknessTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Darkness Movement Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Fel Devastation.\nUseful for not using when still grouping up enemies.",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",
                },
            },
            { -- CLEANSE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVES ====== ",
                    },
                },
            },
            {
                { -- FelDevastationHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "FelDevastationHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Fel Devastation HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Fel Devastation.",
                    },
                    M = {},
                },
                { -- MetaHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "MetaHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Metamorphosis HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Metamorphosis.",
                    },
                    M = {},
                },
            },
            {
                { -- FelDevastationHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "demonSpikes2",
                    DBV = 95,
                    ONOFF = false,
                    L = {
                        ANY = "Demon Spikes 2 Charges HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Demon Spikes with 2 charges available.\nWill take into account a little bit of distance from your enemy, so can set this to 100% to attempt to use it before initiating a pull.",
                    },
                    M = {},
                },
                { -- MetaHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "demonSpikes1",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Demon Spikes 1 Charge HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Demon Spikes with 1 charge available.",
                    },
                    M = {},
                },
            },
            {
                { -- FelDevastationHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "darknessHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Darkness HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Darkness.",
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
	},
}