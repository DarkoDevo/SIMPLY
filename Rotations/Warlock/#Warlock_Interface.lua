local A												= Action

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "TWW v2.0.0 (28 April 2025)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_WARLOCK_AFFLICTION] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Affliction Warlock ====== ",
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
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                { -- AOE
                    E = "Checkbox",
                    DB = "autoDOT",
                    DBV = false,
                    L = {
                        ANY = "Auto DOT",
                    },
                    TT = {
                        ANY = "Use Auto DOT (experimental).\nCan't currently be used with general Auto Target from Action."
                    },
                    M = {},
                },
            },
            {
                { -- Cast While Moving
                    E = "Checkbox",
                    DB = "castWhileMoving",
                    DBV = false,
                    L = {
                        ANY = "Allow Casting While Moving",
                    },
                    TT = {
                        ANY = "When enabled, allows the rotation to cast spells while moving.\nWARNING: This may cause spell failures if you don't have movement-casting buffs active."
                    },
                    M = {},
                },
            },
            {
                { -- AOE
                    E = "Checkbox", 
                    DB = "cursorCheck",
                    DBV = true,
                    L = { 
                        ANY = "Cursor Check (VT)", 
                    }, 
                    TT = { 
                        ANY = "Check that the cursor is over an enemy before using Vile Taint."
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
            { -- PRIEST HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== BURST ====== ",
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
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Cooldowns",
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
                        { text = "Summon Darkglare", value = 1 }, 
                        { text = "Soul Rot", value = 2 },     
                        { text = "Phantom Singularity", value = 3 },   
                        { text = "Oblivion", value = 4 },
                        { text = "Malevolence", value = 5 }, 
                    },
                    MULT = true,
                    DB = "cooldownSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                    },  
                    L = { 
                        ANY = "Cooldown Abilities", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want the rotation to obey the burst toggle.\nIf a spell is unchecked, it will be used even when burst is turned off!", 
                    }, 
                    M = {},                                    
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
                        { text = "Unending Resolve", value = 1 }, 
                        { text = "Dark Pact", value = 2 },     
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
                { -- UnendingResolveHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "UnendingResolveHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Unending Resolve HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Unending Resolve.", 
                    },                     
                    M = {},
                },				
                { -- DarkPactHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DarkPactHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Dark Pact HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Dark Pact.", 
                    },                     
                    M = {},
                },						
            },
            {
                { -- MortalCoilHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "MortalCoilHP",
                    DBV = 60,
                    ONOFF = true,
                    L = { 
                        ANY = "Mortal Coil Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Mortal Coil.", 
                    },                     
                    M = {},
                },	
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 30,
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Drain Life.", 
                    },                     
                    M = {},
                },	
            },					
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PETS ====== ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(366222), value = "SAYAAD" },
                    },
                    DB = "PetChoice",
                    DBV = "IMP",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
                    },
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
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
                        { text = "Vile Taint Soon", value = 1 },     
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
        [ACTION_CONST_WARLOCK_DESTRUCTION] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Destruction Warlock ====== ",
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
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                { -- AOE
                    E = "Checkbox",
                    DB = "cursorCheck",
                    DBV = true,
                    L = {
                        ANY = "Cursor Check (RoF)",
                    },
                    TT = {
                        ANY = "Check that the cursor is over an enemy before using Rain of Fire."
                    },
                    M = {},
                },
            },
            {
                { -- Cast While Moving
                    E = "Checkbox",
                    DB = "castWhileMoving",
                    DBV = false,
                    L = {
                        ANY = "Allow Casting While Moving",
                    },
                    TT = {
                        ANY = "When enabled, allows the rotation to cast spells while moving.\nWARNING: This is to be used in the Legion Remix."
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
                { -- autoDoT
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = false,
                    L = { 
                        ANY = "Auto DOT", 
                    }, 
                    TT = { 
                        ANY = "Use Auto DOT (experimental).\nCan't currently be used with general Auto Target from Action."
                    }, 
                    M = {},
                },
                { -- cataTime
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 15,
                    Precision = 1,
                    DB = "cataTime",
                    DBV = 0,
                    ONOFF = false,
                    L = { 
                        ANY = "Cataclysm CD Auto DoT",
                    },
                    TT = { 
                        ANY = "Cooldown remaining on Cataclysm to use auto DoT.\nFor example, setting this to 5 will mean that it will no longer swap targets if Cataclysm is ready in 5 seconds.", 
                    },                     
                    M = {},
                },	
                { -- swapOffHavoc
                    E = "Checkbox", 
                    DB = "swapOffHavoc",
                    DBV = false,
                    L = { 
                        ANY = "Swap Off Havoc", 
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets if your current target has Havoc on them and you're fighting two or more enemies."
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
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Pet", value = "Pet" },
                        { text = "Nameplates", value = "Nameplates" },                    
                    },
                    DB = "aoeDetection",
                    DBV = "Pet",
                    L = { 
                        ANY = "AoE Detection"
                    },
                    TT = { 
                        ANY = "Choose method for AoE detection. Pet only works with Felhound and Sayaad."
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
                { -- disableCb2t
                    E = "Checkbox", 
                    DB = "disableCb2t",
                    DBV = false,
                    L = { 
                        ANY = "Disable Chaos Bolt Two-Target",
                    }, 
                    TT = { 
                        ANY = "Disable using Chaos Bolt when only two enemies.",
                    }, 
                    M = {},
                },	
                { -- disableCb2t
                    E = "Checkbox", 
                    DB = "allowRoF2t",
                    DBV = false,
                    L = { 
                        ANY = "Allow Rain of Fire Two-Target",
                    }, 
                    TT = { 
                        ANY = "Allow using Rain of Fire when only two enemies.\nTHIS IS IGNORED IF YOU HAVE THE RAIN OF CHAOS TALENT.",
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
                        ANY = " ====== COOLDOWNS ====== ",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Summon Infernal", value = 1 }, 
                        { text = "Malevolence", value = 2 },     
                    },
                    MULT = true,
                    DB = "cooldownSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },  
                    L = { 
                        ANY = "Cooldown Abilities", 
                    }, 
                    TT = { 
                        ANY = "Select what abilities you want the rotation to obey the burst toggle.\nIf a spell is unchecked, it will be used even when burst is turned off!", 
                    }, 
                    M = {},                                    
                },  
            },
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
            { -- CLEANSE HEADER
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
                        { text = "Unending Resolve", value = 1 }, 
                        { text = "Dark Pact", value = 2 },     
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
                { -- UnendingResolveHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "UnendingResolveHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Unending Resolve HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Unending Resolve.", 
                    },                     
                    M = {},
                },				
                { -- DarkPactHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DarkPactHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Dark Pact HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Dark Pact.", 
                    },                     
                    M = {},
                },						
            },
            {
                { -- MortalCoilHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "MortalCoilHP",
                    DBV = 60,
                    ONOFF = true,
                    L = { 
                        ANY = "Mortal Coil Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Mortal Coil.", 
                    },                     
                    M = {},
                },	
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 30,
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Drain Life.", 
                    },                     
                    M = {},
                },	
            },					
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },	
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PETS ====== ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(366222), value = "SAYAAD" },
                    },
                    DB = "PetChoice",
                    DBV = "FELHUNTER",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
                    },
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
                    },					
                    M = {},
                },					
            }, 
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Debug/Aware Options",
                    },
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
                        { text = "Cataclysm Soon", value = 1 },     
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
        [ACTION_CONST_WARLOCK_DEMONOLOGY] = {  
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Demonology Warlock ====== ",
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
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
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
                { -- Cast While Moving
                    E = "Checkbox",
                    DB = "castWhileMoving",
                    DBV = false,
                    L = {
                        ANY = "Allow Casting While Moving",
                    },
                    TT = {
                        ANY = "When enabled, allows the rotation to cast spells while moving.\nWARNING: This is to be used in the Legion Remix."
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
                        ANY = "Cursor Check (Guillotine/BSB)", 
                    }, 
                    TT = { 
                        ANY = "Check that the cursor is over an enemy before using Guillotine/Bilescourge Bombers."
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
                { -- Cursor
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = true,
                    L = { 
                        ANY = "Auto Spread Doom", 
                    }, 
                    TT = { 
                        ANY = "Automatically spread Doom (if learned)."
                    }, 
                    M = {},
                },  
            },
            {
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Pet", value = "Pet" },
                        { text = "Nameplates", value = "Nameplates" },                    
                    },
                    DB = "aoeDetection",
                    DBV = "Pet",
                    L = { 
                        ANY = "AoE Detection"
                    },
                    TT = { 
                        ANY = "Choose method for AoE detection. Pet only works with Felhound and Sayaad."
                    },
                    M = {},
                },
            },
            { -- PRIEST HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== BURST ====== ",
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
                        { text = "Summon Demonic Tyrant", value = 1 },
                        { text = "Grimoire: Felguard", value = 2 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
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
                { -- potionLustOnly
                    E = "Checkbox", 
                    DB = "endOfFight",
                    DBV = false,
                    L = { 
                        ANY = "Force Cooldowns if Fight Ends Soon", 
                    }, 
                    TT = { 
                        ANY = "Force the use of your cooldowns if the fight is going to end soon. Useful for trying to parse on raid bosses. Best to leave this disabled in M+"
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
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Unending Resolve", value = 1 }, 
                        { text = "Dark Pact", value = 2 },     
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
                { -- UnendingResolveHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "UnendingResolveHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Unending Resolve HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Unending Resolve.", 
                    },                     
                    M = {},
                },				
                { -- DarkPactHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DarkPactHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Dark Pact HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Dark Pact.", 
                    },                     
                    M = {},
                },					
            },
            {
                { -- MortalCoilHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "MortalCoilHP",
                    DBV = 60,
                    ONOFF = true,
                    L = { 
                        ANY = "Mortal Coil Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Mortal Coil.", 
                    },                     
                    M = {},
                },	
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 30,
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life Health (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Drain Life.", 
                    },                     
                    M = {},
                },	
            },					
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PETS ====== ",
                    },
                },
            },
            { -- Pet Stuff - Content
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
                    },					
                    M = {},
                },					
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Vile Taint Soon", value = 1 },     
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
        },
    },
}
