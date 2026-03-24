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
    DateTime = "v2.1 (24 April 2024)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_WARRIOR_PROTECTION] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Protection Warrior ====== ",
                    },
                },
            },
            {
                {
                    E = "Label",
                    L = {
                        ANY = " BETA Please report any errors or issues. ",
                    },
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " =============================== ",
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
                { -- DEFMODE TOGGLE
                E = "Checkbox",
                DB = "defMode",
                DBV = false,
                L = {
                    enUS = "Toggle Defense Mode",
                },
                TT = {
                    enUS = "Enable defense mode (Force Ignore Pain/Shield Block)",
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
            { -- AUTO OPTIONS
                {
                    E = "Checkbox",
                    DB = "mouseoverHeroicThrow",
                    DBV = false,
                    L = {
                        enUS = "Mouseover Throw",
                    },
                    TT = {
                        enUS = "Use Heroic Throw on mouseover for agro (Universal6 must be set!).",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "mouseoverTaunt",
                    DBV = false,
                    L = {
                        enUS = "Mouseover Taunt",
                    },
                    TT = {
                        enUS = "Use Taunt on mouseover for agro (Universal8 must be set!).",
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
                    DB = "usedbm",
                    DBV = true,
                    L = {
                        enUS = "Enable DBM Intigration",
                    },
                    TT = {
                        enUS = "Will use DBM timers for smart defensive usage.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "autostance",
                    DBV = true,
                    L = {
                        enUS = "Auto Stance",
                    },
                    TT = {
                        enUS = "Auto swap between battle/defensive stance. (Use def only on higher content)",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "shieldchargemelee",
                    DBV = false,
                    L = {
                        enUS = "SC Melee Only",
                    },
                    TT = {
                        enUS = "Shield charge in melee only.",
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
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVES ====== ",
                    },
                },
            },
            {
                { -- Ignore Pain Percent
                    E = "Slider",
                    MIN = 1,
                    MAX = 30,
                    DB = "IgnorePainPerc",
                    DBV = 10,
                    ONOFF = false,
                    L = {
                        ANY = "Ignore Pain Perc",
                    },
                    TT = {
                        ANY = "Percent of HP to keep Ignore Pain at (ex have 1m hp 10% would be 100,000).",
                    },
                    M = {},
                },
                { -- Ignore Pain Percent Rage Dump
                    E = "Slider",
                    MIN = 1,
                    MAX = 30,
                    DB = "IgnorePainPercRageDump",
                    DBV = 15,
                    ONOFF = false,
                    L = {
                        ANY = "Ignore Pain Perc RD",
                    },
                    TT = {
                        ANY = "Percent of HP to keep Ignore Pain at (ex have 1m hp 10% would be 100,000) for high rage.",
                    },
                    M = {},
                },
            },
        },
        [ACTION_CONST_WARRIOR_FURY] = {
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
            {{E = "Header", L = { ANY = "=== [ Cooldowns ] ===", },},},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
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
                { -- potionLustOnly
                    E = "Checkbox", 
                    DB = "potionLustOnly",
                    DBV = true,
                    L = { 
                        ANY = "Damage Potion Lust Only", 
                    }, 
                    TT = { 
                        ANY = "Only use Damage Potion when bloodlust/similar."
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
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Berserker Stance", value = "2" },
                        { text = "Defensive Stance", value = "3" },
                    },
                    DB = "StanceMode",
                    DBV = "1",
                    L = {
                        ANY = "Choose your Stance",
                    },
                    TT = {
                        enUS = "Auto = will swap to Defensive Stance when we drop low health - otherwise we prefer Berserker Stance"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "VictoryRushSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = {
                        ANY = "Victory Rush (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Victory Rush"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EnragedRegenerationSlider",
                    DBV = 55,
                    ONLYOFF = true,
                    L = {
                        ANY = "Enraged Regeneration (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Enraged Regeneration"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RallyingCrySlider",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Rallying Cry (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Rallying Cry"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BitterImmunitySlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Bitter Immunity (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Bitter Immunity"
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
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "makArenaAware",
                    DBV = true,
                    L = { 
                        ANY = "Enable Aware Alert Messages in Arena.",
                    }, 
                    TT = { 
                        ANY = "If enabled you will receive messages related to arena situations and actions.",
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_WARRIOR_ARMS] = { 
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
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "syncCDs",
                    DBV = false,
                    L = { 
                        ANY = "Sync Cooldowns",
                    }, 
                    TT = { 
                        ANY = "Sync major cooldowns to be used at the same time\n(Avatar, Thunderous Roar, Bladestorm, Champion's Might)",
                    }, 
                    M = {},
                },
            },
            { -- PRIEST HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== TRINKETS ====== ",
                    },
                },
            },
            {
                { -- Trinket Type 1
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Damage", value = "Damage" },
                        { text = "Friendly", value = "Friendly" },
                        { text = "Self Defensive", value = "SelfDefensive" },
                        { text = "Mana Gain", value = "ManaGain" },						
                    },
                    DB = "TrinketType1",
                    DBV = "Damage",
                    L = { 
                        ANY = "First Trinket",
                    }, 
                    TT = { 
                        ANY = "Pick what type of trinket you have in your first/upper trinket slot (only matters for trinkets with Use effects).", 
                    }, 
                    M = {},
                },	
                { -- Trinket Type 2
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Damage", value = "Damage" },
                        { text = "Friendly", value = "Friendly" },
                        { text = "Self Defensive", value = "SelfDefensive" },
                        { text = "Mana Gain", value = "ManaGain" },						
                    },
                    DB = "TrinketType2",
                    DBV = "Damage",
                    L = { 
                        ANY = "Second Trinket",
                    }, 
                    TT = { 
                        ANY = "Pick what type of trinket you have in your second/lower trinket slot (only matters for trinkets with Use effects).", 
                    }, 
                    M = {},
                },				
            },			
            {
                { -- TrinketValue1
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "TrinketValue1",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "First Trinket Value",
                    },
                    TT = { 
                        ANY = "HP/Mana (%) to use your first trinket, based on what you've chosen for your trinket type. Damage trinkets will be used on burst targets.", 
                    },                     
                    M = {},
                },	
                { -- TrinketValue2
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "TrinketValue2",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Second Trinket Value",
                    },
                    TT = { 
                        ANY = "HP/Mana (%) to use your second trinket, based on what you've chosen for your trinket type. Damage trinkets will be used on burst targets.", 
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
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVES ====== ",
                    },
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Battle Stance", value = "2" },
                        { text = "Defensive Stance", value = "3" },
                    },
                    DB = "StanceMode",
                    DBV = "1",
                    L = {
                        ANY = "Choose your Stance",
                    },
                    TT = {
                        enUS = "Auto = will swap to Defensive Stance when we drop low health - otherwise we prefer Battle Stance"
                    },
                    M = {},
                },
            },
            {
                { -- BitterImmunity
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "BitterImmunitySlider",
                    DBV = 40,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Bitter Immunity HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Bitter Immunity.", 
                    },                     
                    M = {},
                },
                { -- DiebytheSwordHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DiebytheSwordSlider",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Die by the Sword HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Die by the Sword.", 
                    },                     
                    M = {},
                },
            },
            {
                { -- RallyingCryHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RallyingCrySlider",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Rallying Cry HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Rallying Cry. Will also check party members in arena!", 
                    },                     
                    M = {},
                },
                { -- VictoryRushHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "VictoryRushSlider",
                    DBV = 70,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Victory Rush HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Victory Rush.", 
                    },                     
                    M = {},
                },
            },		
            {
                { -- Ignore Pain
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "IgnorePainSlider",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Ignore Pain HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Ignore Pain.", 
                    },                     
                    M = {},
                },
            },
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "makArenaAware",
                    DBV = true,
                    L = { 
                        ANY = "Enable Aware Alert Messages in Arena.",
                    }, 
                    TT = { 
                        ANY = "If enabled you will receive messages related to arena situations and actions.",
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