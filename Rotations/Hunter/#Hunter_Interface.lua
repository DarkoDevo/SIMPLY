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
    DateTime = "TWW v2.1.0 (5 April 2025)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_HUNTER_BEASTMASTERY] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Beast Mastery Hunter ====== ",
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
                    DBV = false,
                    L = { 
                        ANY = "Switch Targets Interrupt",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets to interrupt.",
                    }, 
                    M = {},
                },
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = true,
                    L = { 
                        ANY = "Auto DoT",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to cast Barbed Shot on everything in combat.",
                    }, 
                    M = {},
                },	
            },
            {
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "sotfPixel",
                    DBV = false,
                    L = { 
                        ANY = "MY SURVIVAL OF THE FITTEST PIXEL DOESN'T WORK",
                    }, 
                    TT = { 
                        ANY = "This spell has been notorious for pixel issues lately. Check this box if your Survival of the Fittest pixel doesn't work.\nYou will need to bind Universal10 to Survival of the Fittest.\nYou should also uncheck the Rotation Doesn't Work IfMounted option on the General tab as that icon also causes issues with SotF (this option will also replace the mounted pixel).",
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
                        ANY = "Pet Stuff",
                    },
                },
            },
            {	
                { -- Misdirect
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Off", value = "Off"},
                        { text = "WeakAura", value = "WeakAura" },
                        { text = "Focus/Pet", value = "Focus" },                
                    },
                    DB = "MisdirectType",
                    DBV = "Off",
                    L = { 
                        ANY = "Misdirection Usage",
                    }, 
                    TT = { 
                        ANY = "Choose how you would like Misdirection to be managed. Set up your WeakAura from https://wago.io/n9Sg1NLb5 or check Discord for more information.", 
                    }, 
                    M = {},
                },  
            },
            {
                { -- Swap Pets
                    E = "Checkbox", 
                    DB = "swapPets",
                    DBV = false,
                    L = { 
                        ANY = "Show the Swap Pets Frame",
                    }, 
                    TT = { 
                        ANY = "Show a frame that allows you to quickly swap your pets based on their spec.\nUseful for swapping between Ferocity and Tenacity pets on the fly!",
                    }, 
                    M = {},
                },	
                { -- Swap Pets
                    E = "Checkbox", 
                    DB = "swapPetsCombat",
                    DBV = false,
                    L = { 
                        ANY = "Allow Pet Swap in Combat",
                    }, 
                    TT = { 
                        ANY = "Allow automatic usage of Dismiss Pet in combat. Not recommended as this can be a considerable DPS loss.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Earth Elemental
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "mendPetHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Mend Pet",
                    },
                    TT = { 
                        ANY = "HP (%) to use Mend Pet", 
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
                        { text = "Call of the Wild", value = 1 }, 
                        { text = "Bestial Wrath", value = 2 },     
                        { text = "Bloodshed", value = 3 },    
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = false,
                        [2] = true,
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
            { -- Potions
                { -- force black arrow
                    E = "Checkbox", 
                    DB = "forceBlackArrow",
                    DBV = false,
                    L = { 
                        ANY = "Force Black Arrow"
                    }, 
                    TT = { 
                        ANY = "This will overide APL and force black arrow to be used on cooldown if enabled.", 
                    }, 
                    M = {},
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
                        { text = "Survival of the Fittest", value = 1 }, 
                        { text = "Camouflage (with Ghillie Suit)", value = 2 },     
                        { text = "Aspect of the Turtle", value = 3 },    
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
                    DB = "survivalOfTheFittestHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Survival of the Fittest",
                    },
                    TT = { 
                        ANY = "HP (%) to use Survival of the Fittest", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "camouflageHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Camouflague",
                    },
                    TT = { 
                        ANY = "HP (%) to use Camouflage (with Ghillie Suit)", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "aspectOfTheTurtleHP",
                    DBV = 20,
                    ONOFF = false,
                    L = { 
                        ANY = "Aspect of the Turtle",
                    },
                    TT = { 
                        ANY = "HP (%) to use Aspect of the Turtle", 
                    },                     
                    M = {},
                },
            },
            { 
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "exhilarationHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Exhilaration",
                    },
                    TT = { 
                        ANY = "HP (%) to use Exhilaration", 
                    },                     
                    M = {},
                }, 
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "fortHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Fortitude of the Bear",
                    },
                    TT = { 
                        ANY = "HP (%) to use Fortitude of the Bear (tenacity pet)", 
                    },                     
                    M = {},
                }, 
            },
            {
                { -- Feign Death
                    E = "Checkbox", 
                    DB = "selfCleanse",
                    DBV = true,
                    L = { 
                        ANY = "Feign Death Poison/Disease",
                    }, 
                    TT = { 
                        ANY = "Use Feign Death to cleanse poison/disease from yourself with Emergency Salve talent.\nOnly in PvE.",
                    }, 
                    M = {},
                },
                { -- Feign Death
                    E = "Checkbox", 
                    DB = "feignMechs",
                    DBV = true,
                    L = { 
                        ANY = "Feign Death Targeted Mechanics",
                    }, 
                    TT = { 
                        ANY = "Use Feign Death to drop targeted mechanics in PvE content.",
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
                        { text = "Set Focus Reminder", value = 1 }, 
                        { text = "Casting Aimed Shot", value = 2 },     
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
        [ACTION_CONST_HUNTER_MARKSMANSHIP] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Marksmanship Hunter ====== ",
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
                    DB = "cursorCheck",
                    DBV = true,
                    L = { 
                        ANY = "Cursor Check (Volley)",
                    }, 
                    TT = { 
                        ANY = "Check if enemies are under cursor before using Volley.",
                    }, 
                    M = {},
                },	
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
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "stopSteady",
                    DBV = false,
                    L = { 
                        ANY = "StopCast Steady Shot when Aimed Shot ready",
                    }, 
                    TT = { 
                        ANY = "Interrupt Steady Shot cast to cast Aimed Shot if Aimed Shot is ready.",
                    }, 
                    M = {},
                },
            },
            {
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "sotfPixel",
                    DBV = false,
                    L = { 
                        ANY = "MY SURVIVAL OF THE FITTEST PIXEL DOESN'T WORK",
                    }, 
                    TT = { 
                        ANY = "This spell has been notorious for pixel issues lately. Check this box if your Survival of the Fittest pixel doesn't work.\nYou will need to bind Universal10 to Survival of the Fittest.\nYou should also uncheck the Rotation Doesn't Work IfMounted option on the General tab as that icon also causes issues with SotF (this option will also replace the mounted pixel).",
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
                        { text = "Survival of the Fittest", value = 1 }, 
                        { text = "Camouflage (with Ghillie Suit)", value = 2 },     
                        { text = "Aspect of the Turtle", value = 3 },    
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
                    DB = "survivalOfTheFittestHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Survival of the Fittest",
                    },
                    TT = { 
                        ANY = "HP (%) to use Survival of the Fittest", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "camouflageHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Camouflague",
                    },
                    TT = { 
                        ANY = "HP (%) to use Camouflage (with Ghillie Suit)", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "aspectOfTheTurtleHP",
                    DBV = 20,
                    ONOFF = false,
                    L = { 
                        ANY = "Aspect of the Turtle",
                    },
                    TT = { 
                        ANY = "HP (%) to use Aspect of the Turtle", 
                    },                     
                    M = {},
                }, 
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "exhilarationHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Exhilaration",
                    },
                    TT = { 
                        ANY = "HP (%) to use Exhilaration", 
                    },                     
                    M = {},
                }, 
            },
            {
                { -- Feign Death
                    E = "Checkbox",
                    DB = "selfCleanse",
                    DBV = true,
                    L = {
                        ANY = "Feign Death Poison/Disease",
                    },
                    TT = {
                        ANY = "Use Feign Death to cleanse poison/disease from yourself with Emergency Salve talent.\nOnly in PvE.",
                    },
                    M = {},
                },
                { -- Feign Death
                    E = "Checkbox",
                    DB = "feignMechs",
                    DBV = true,
                    L = {
                        ANY = "Feign Death Targeted Mechanics",
                    },
                    TT = {
                        ANY = "Use Feign Death to drop targeted mechanics in PvE content.",
                    },
                    M = {},
                },
                { -- Emergency Feign Death HP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "feignDeathHP",
                    DBV = 35,
                    ONOFF = true,
                    L = {
                        ANY = "Emergency Feign Death",
                    },
                    TT = {
                        ANY = "HP (%) to use Feign Death as an emergency survival cooldown.\nWorks in all content (PvE and PvP).\nSet to 0 to disable.",
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
                        { text = "Set Focus Reminder", value = 1 }, 
                        { text = "Casting Aimed Shot", value = 2 },     
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
        [ACTION_CONST_HUNTER_SURVIVAL] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Survival Hunter ====== ",
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
                    DB = "kcFallback",
                    DBV = false,
                    L = { 
                        ANY = "Kill Command Ignore Focus",
                    }, 
                    TT = { 
                        ANY = "Check this option to use Kill Command when out of range with no other options left, regardless of how much focus you have.",
                    }, 
                    M = {},
                },
            },
            {
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "sotfPixel",
                    DBV = false,
                    L = { 
                        ANY = "MY SURVIVAL OF THE FITTEST PIXEL DOESN'T WORK",
                    }, 
                    TT = { 
                        ANY = "This spell has been notorious for pixel issues lately. Check this box if your Survival of the Fittest pixel doesn't work.\nYou will need to bind Universal10 to Survival of the Fittest.\nYou should also uncheck the Rotation Doesn't Work IfMounted option on the General tab as that icon also causes issues with SotF (this option will also replace the mounted pixel).",
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
                        ANY = "Pet Stuff",
                    },
                },
            },
            {	
                { -- Misdirect
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "WeakAura", value = "WeakAura" },
                        { text = "Focus/Pet", value = "Focus" },                
                    },
                    DB = "MisdirectType",
                    DBV = "Focus",
                    L = { 
                        ANY = "Misdirection Usage",
                    }, 
                    TT = { 
                        ANY = "Choose how you would like Misdirection to be managed. Set up your WeakAura from https://wago.io/n9Sg1NLb5 or check Discord for more information.", 
                    }, 
                    M = {},
                },  
            },
            {
                { -- Swap Pets
                    E = "Checkbox", 
                    DB = "swapPets",
                    DBV = true,
                    L = { 
                        ANY = "Show the Swap Pets Frame",
                    }, 
                    TT = { 
                        ANY = "Show a frame that allows you to quickly swap your pets based on their spec.\nUseful for swapping between Ferocity and Tenacity pets on the fly!",
                    }, 
                    M = {},
                },	
                { -- Swap Pets
                    E = "Checkbox", 
                    DB = "swapPetsCombat",
                    DBV = false,
                    L = { 
                        ANY = "Allow Pet Swap in Combat",
                    }, 
                    TT = { 
                        ANY = "Allow automatic usage of Dismiss Pet in combat. Not recommended as this can be a considerable DPS loss.",
                    }, 
                    M = {},
                },
            },
            {
                { -- Earth Elemental
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "mendPetHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Mend Pet",
                    },
                    TT = { 
                        ANY = "HP (%) to use Mend Pet", 
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
                        { text = "Coordinated Assault", value = 1 }, 
                        { text = "Spearhead", value = 2 },     
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = false,
                        [2] = true,
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
                        { text = "Survival of the Fittest", value = 1 }, 
                        { text = "Camouflage (with Ghillie Suit)", value = 2 },     
                        { text = "Aspect of the Turtle", value = 3 },    
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
                    DB = "survivalOfTheFittestHP",
                    DBV = 45,
                    ONOFF = false,
                    L = { 
                        ANY = "Survival of the Fittest",
                    },
                    TT = { 
                        ANY = "HP (%) to use Survival of the Fittest", 
                    },                     
                    M = {},
                },  
                { -- Stone Bulwark Totem
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "camouflageHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Camouflague",
                    },
                    TT = { 
                        ANY = "HP (%) to use Camouflage (with Ghillie Suit)", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "aspectOfTheTurtleHP",
                    DBV = 25,
                    ONOFF = false,
                    L = { 
                        ANY = "Aspect of the Turtle",
                    },
                    TT = { 
                        ANY = "HP (%) to use Aspect of the Turtle", 
                    },                     
                    M = {},
                },
            },
            { 
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "exhilarationHP",
                    DBV = 37,
                    ONOFF = false,
                    L = { 
                        ANY = "Exhilaration",
                    },
                    TT = { 
                        ANY = "HP (%) to use Exhilaration", 
                    },                     
                    M = {},
                }, 
                { -- Ancestral Guidance
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "fortHP",
                    DBV = 30,
                    ONOFF = false,
                    L = { 
                        ANY = "Fortitude of the Bear",
                    },
                    TT = { 
                        ANY = "HP (%) to use Fortitude of the Bear (tenacity pet)", 
                    },                     
                    M = {},
                }, 
            },
            {
                { -- Feign Death
                    E = "Checkbox",
                    DB = "selfCleanse",
                    DBV = true,
                    L = {
                        ANY = "Feign Death Poison/Disease",
                    },
                    TT = {
                        ANY = "Use Feign Death to cleanse poison/disease from yourself with Emergency Salve talent.\nOnly in PvE.",
                    },
                    M = {},
                },
                { -- Feign Death
                    E = "Checkbox",
                    DB = "feignMechs",
                    DBV = true,
                    L = {
                        ANY = "Feign Death Targeted Mechanics",
                    },
                    TT = {
                        ANY = "Use Feign Death to drop targeted mechanics in PvE content.",
                    },
                    M = {},
                },
            },
            {
                { -- Feign Death PvP
                    E = "Checkbox",
                    DB = "feignDeathPvP",
                    DBV = true,
                    L = {
                        ANY = "Feign Death to Avoid Death (PvP)",
                    },
                    TT = {
                        ANY = "Use Feign Death to avoid death in PvP when HP is low.",
                    },
                    M = {},
                },
                { -- Feign Death HP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "feignDeathHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Feign Death HP (PvP)",
                    },
                    TT = {
                        ANY = "HP (%) to use Feign Death in PvP to avoid death",
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
                { -- Debug
                E = "Checkbox", 
                DB = "flankStrike",
                DBV = true,
                L = { 
                    ANY = "Use flanking strike while moving.",
                }, 
                TT = { 
                    ANY = "If enabled you will use flanking strike while you are moving.",
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

