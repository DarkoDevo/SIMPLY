local Action = _G.Action
local A = Action
local CONST = Action.Const
local ACTION_CONST_ROGUE_OUTLAW = CONST.ROGUE_OUTLAW

LPH_ENCNUM = function(val) return val end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "TWW 1.0 (22 September 2024)",
    -- Class settings
    [2] = {
        [ACTION_CONST_ROGUE_ASSASSINATION] = {
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Makulu Rotations - Big ol' Ass",
                    },
                },
            },
            { -- Spacer
                {
                    E = "LayoutSpace",
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
                        ANY = "Automatically switches targets to interrupt (PvE).",
                    },
                    M = {},
                },
                { -- Automatic Interrupt
                    E = "Checkbox",
                    DB = "AutoDotVenomousWounds",
                    DBV = true,
                    L = {
                        ANY = "DoT for VenomousWounds",
                    },
                    TT = {
                        ANY = "Automatically DoT enemies for Venomous Wounds energy regen (Arena).",
                    },
                    M = {},
                },
            },
            {
                { -- Tricks on Focus
                    E = "Checkbox",
                    DB = "AutoToT",
                    DBV = true,
                    L = {
                        ANY = "ToT on Focus",
                    },
                    TT = {
                        ANY = "Automatically use Tricks of the Trade on focus.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "TargetonST",
                    DBV = true,
                    L = {
                        ANY = "Target on ST",
                    },
                    TT = {
                        ANY = "Automatically set the target when we shadow step to kill.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Tricks Reminder", value = 1 },
                        { text = "Arena CC Notices", value = 2 },
                        { text = "Arena Target Notices", value = 3 },
                        { text = "Defensive Notices", value = 4 },
                        { text = "Debug Window", value = 5 },
                        { text = "Dismantle Reminder", value = 6 }
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = false,
                        [6] = true
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
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Offensive CC (Lower DR)", value = 1 },
                        { text = "Defensive CC (Lower DR)", value = 2 },
                        { text = "Offensive CC (Normal DR)", value = 3 },
                        { text = "Defensive CC (Normal DR)", value = 4 },
                        { text = "Healer CC (Full DR)", value = 5 },
                        { text = "Other CC (Full DR)", value = 6 },
                        { text = "Shadow Step Kill", value = 7 },
                        { text = "Kick Healer", value = 8 },
                        { text = "Kick DPS", value = 9 },
                    },
                    MULT = true,
                    DB = "makCC",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = true,
                        [8] = true,
                        [9] = true
                    },
                    L = {
                        ANY = "Arena Conditions",
                    },
                    TT = {
                        ANY = "Conditions for arena.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Mutilate", value = "Mutilate" },
                        { text = "Fan of Knives", value = "FanofKnives" }
                    },
                    DB = "MainAttack",
                    DBV = "Auto",
                    L = {
                        ANY = "Main Attack",
                    },
                    TT = {
                        ANY = "Use Multilate or Fan of Knives as main attack in PvP (will Mutilate if breakable).",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Amplifying Poision", value = "AmplifyingPoision" },
                        { text = "Deadly Poision", value = "DeadlyPoision" },
                        { text = "Wound Poision", value = "WoundPoision" },
                        { text = "Instant Poision", value = "InstantPoision" },
                        { text = "Manual", value = "Manual" }
                    },
                    DB = "LethalPsn",
                    DBV = "Auto",
                    L = {
                        ANY = "Lethal Psn",
                    },
                    TT = {
                        ANY = "Set your lethal poison. Auto will use the best poison for the situation.",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Crippling Poison", value = "CripplingPoison" },
                        { text = "Numbing Poision", value = "NumbingPoision" },
                        { text = "Atrophic Poision", value = "AtrophicPoision" },
                        { text = "Manual", value = "Manual" }
                    },
                    DB = "NonLethalPsn",
                    DBV = "Auto",
                    L = {
                        ANY = "NonLethal Psn",
                    },
                    TT = {
                        ANY = "Set your non-lethal poison. Auto will use the best poison for the situation.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 6,
                    PRECISION = 1,
                    DB = "CrimsonTempestSlider",
                    DBV = 4,
                    ONOFF = false,
                    L = {
                        ANY = "Crimson Tempest",
                    },
                    TT = {
                        ANY = "Number of units in range to use Crimson Tempest.",
                    },
                    M = {},
                },
            },
        },
        [ACTION_CONST_ROGUE_OUTLAW] = {
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Makulu Rotations - Rogue Outlaw",
                    },
                },
            },
            { -- Spacer
                {
                    E = "LayoutSpace",
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
                    DB = "autoTarget",
                    DBV = false,
                    L = { 
                        ANY = "Auto Target Out of Range",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets when out of range.",
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
                        { text = "Evasion", value = 1 }, 
                        { text = "Cloak of Shadows", value = 2 },
                        { text = "Feint", value = 3 },  
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
                { -- Obsidian Scales
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "evasionHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Evasion",
                    },
                    TT = { 
                        ANY = "HP (%) to use Evasion", 
                    },                     
                    M = {},
                },  
                { -- Zephyr
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "cloakHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Cloak of Shadows",
                    },
                    TT = { 
                        ANY = "HP (%) to use Cloak of Shadows", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "feintHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Feint HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Feint.", 
                    },                     
                    M = {},
                },
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "crimsonVialHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Crimson Vial",
                    },
                    TT = { 
                        ANY = "HP (%) to use Crimson Vial.", 
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
                { -- Debug
                E = "Checkbox", 
                DB = "forceRTB",
                DBV = true,
                L = { 
                    ANY = "Force RTB in Arena with PVP Talent",
                }, 
                TT = { 
                    ANY = "If this is enabled we will use RTB on cooldown if you have Take Your Cut talented.",
                }, 
                M = {},
                },
            },
            {
                { -- Debug
                E = "Checkbox", 
                DB = "makAware",
                DBV = true,
                L = { 
                    ANY = "Show Makulu Aware Messages",
                }, 
                TT = { 
                    ANY = "If this is enabled we will show messages in the middle of your screen.",
                }, 
                M = {},
                },
            },  
        },
        [ACTION_CONST_ROGUE_SUBTLETY] = {
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
                    DB = "priority",
                    DBV = false,
                    L = { 
                        ANY = "Priority Rotation", 
                    }, 
                    TT = { 
                        ANY = "Use single-target priority abilities in AoE scenarios.\nCan result in a minor DPS loss in M+ if your group is particularly good."
                    }, 
                    M = {},
                }, 
                { -- Cursor
                    E = "Checkbox", 
                    DB = "autoRupture",
                    DBV = false,
                    L = { 
                        ANY = "Spread Rupture", 
                    }, 
                    TT = { 
                        ANY = "Automatically spread rupture."
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
                    DB = "autoTarget",
                    DBV = false,
                    L = { 
                        ANY = "Auto Target Out of Range",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets when out of range.",
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
                        { text = "Evasion", value = 1 }, 
                        { text = "Cloak of Shadows", value = 2 },
                        { text = "Feint", value = 3 },  
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
                { -- Obsidian Scales
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "evasionHP",
                    DBV = 65,
                    ONOFF = false,
                    L = { 
                        ANY = "Evasion",
                    },
                    TT = { 
                        ANY = "HP (%) to use Evasion", 
                    },                     
                    M = {},
                },  
                { -- Zephyr
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "cloakHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Cloak of Shadows",
                    },
                    TT = { 
                        ANY = "HP (%) to use Cloak of Shadows", 
                    },                     
                    M = {},
                },  
            },
            {
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Feint",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = "Feint",
                    },
                    TT = { 
                        ANY = "HP (%) to use Feint.", 
                    },                     
                    M = {},
                },
                { -- Renewing Blaze
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "crimsonVialHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = "Crimson Vial",
                    },
                    TT = { 
                        ANY = "HP (%) to use Crimson Vial.", 
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
                        { text = "Poisons", value = 1 },
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
