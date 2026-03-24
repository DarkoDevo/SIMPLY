local A                                                = Action

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v2.0 (12 April 2025)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_DEATHKNIGHT_BLOOD] = { 
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
                        { text = "Dancing Rune Weapon", value = 1 },
                        { text = "Abomination Limb", value = 2 },
                        { text = "Bone Storm", value = 3 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
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
                        { text = "AoE and Ranged", value = "AoERanged" },
                        { text = "Multiple Ranged Only", value = "Ranged" },
                        { text = "AoE Only", value = "AoE" },
                        { text = "APL", value = "APL" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "abomMode",
                    DBV = "AoERanged",
                    L = {
                        ANY = "Abomination Limb Mode",
                    },
                    TT = {
                        enUS = "Conditions for using Abomination Limb.\nAoE Multiple Ranged Only: Only use Abomination Limb if there are multiple ranged enemies standing outside of melee range (but still nearby for grip). Will respect total enemies AoE slider.\nAoE Only: Only use Abomination Limb if the amount of enemies is equal to or greater than the value set for Abomination Limb Count.\nAPL: Use Abomination Limb as per optimal damage APL.\nOff: Use Abomination Limb manually.",
                    },
                    M = {},
                },
                { -- Abom Limb AOE
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "abomCount",
                    DBV = 7,
                    ONOFF = false,
                    L = { 
                        ANY = "Abomination Limb Count",
                    },
                    TT = { 
                        ANY = "Number of enemies to use Abomination Limb.\nUsed in conjunction with Abomination Limb Mode slider.", 
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
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    Precision = 1,
                    DB = "DNDTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Death and Decay Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Death and Decay.",
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
                { -- DeathStrike Special
                    E = "Slider",
                    MIN = 1000000,
                    MAX = 10000000,
                    DB = "DeathStrikeSliderSpecial",
                    DBV = 2000000,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike Special"
                    },
                    TT = {
                        ANY = "Player lost more than X health last 4 secconds"
                    },
                    M = {},
                },
                { -- DeathPactHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DeathPactHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Death Pact HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Death Pact.",
                    },
                    M = {},
                },
                { -- IBF HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "IBFHP",
                    DBV = 80,
                    ONOFF = false,
                    L = { 
                        ANY = "Icebound Fortitude HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Icebound Fortitude.", 
                    },                     
                    M = {},
                },
            },
            {
                { -- VampBloodSlider
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "VampBloodHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Vampiric Blood HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Vampiric Blood.", 
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
        [ACTION_CONST_DEATHKNIGHT_UNHOLY] = { 
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Unholy DK ====== ",
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
                { -- Res
                    E = "Checkbox", 
                    DB = "mouseoverRes",
                    DBV = true,
                    L = { 
                        ANY = "Raise Dead Mouseover",
                    }, 
                    TT = { 
                        ANY = "Use Raise Dead on dead mouseover.",
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
                    DB = "DNDTimer",
                    DBV = 1,
                    ONOFF = false,
                    L = {
                        ANY = "Death and Decay Timer",
                    },
                    TT = {
                        ANY = "Number of seconds to remain still before casting Death and Decay.",
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
                        { text = "Army of the Dead / Raise Abomination", value = 1 },
                        { text = "Summon Gargoyle", value = 2 },
                        { text = "Dark Transformation", value = 3 },
                        { text = "Vile Contagion", value = 4 },
                        { text = "Unholy Assault", value = 5 },
                        { text = "Apocalypse", value = 6 },
                        { text = "Abomination Limb", value = 7 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
                        [6] = true,
                        [7] = true,
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
            {
                { -- BarkskinHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ibfHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Icebound Fortitude HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use icebound Fortitude.", 
                    },                     
                    M = {},
                },	
                { -- RenewalHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "lichborneHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Lichborne HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Lichborne.", 
                    },                     
                    M = {},
                },
            },
            {
                { -- Res
                    E = "Checkbox", 
                    DB = "deathCoilSelf",
                    DBV = false,
                    L = { 
                        ANY = "Death Coil Self (Heal)",
                    }, 
                    TT = { 
                        ANY = "Use Death Coil on self to heal while in Lichborne.",
                    }, 
                    M = {},
                },	
                { 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "deathCoilHealHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Death Coil Self HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Death Coil on self during Lichborne.", 
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
                        ANY = " ====== PvP ====== ",
                    },
                },
            },
            {
                { 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "pvpDeathGripHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Death Grip HP (%)",
                    },
                    TT = { 
                        ANY = "Target HP (%) to use Death Grip.", 
                    },                     
                    M = {},
                },
                { 
                    E = "Slider",                                                     
                    MIN = 12, 
                    MAX = 30,                            
                    DB = "pvpDeathGripDist",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = "Death Grip Distance",
                    },
                    TT = { 
                        ANY = "Target distance to use Death Grip.\nDistance is an approximation due to WoW restrictions.", 
                    },                     
                    M = {},
                },
            },
            {
                { 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "pvpCOIHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Chains of Ice HP (%)",
                    },
                    TT = { 
                        ANY = "Target HP (%) to use Chains of Ice.\nWon't be used if enemy is below 15% HP.", 
                    },                     
                    M = {},
                },
                { 
                    E = "Slider",                                                     
                    MIN = 12, 
                    MAX = 30,                            
                    DB = "pvpCOIDist",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = "Chains of Ice Distance",
                    },
                    TT = { 
                        ANY = "Target distance to use Chains of Ice.\nDistance is an approximation due to WoW restrictions.", 
                    },                     
                    M = {},
                },
            },
            {
                { 
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "soulReaperHP",
                    DBV = 25,
                    ONOFF = false,
                    L = { 
                        ANY = "Soul Reaper HP (%)",
                    },
                    TT = { 
                        ANY = "Target HP (%) to use Soul Reaper.", 
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
                        ANY = " ====== DEBUG ====== ",
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
                        { text = " ", value = 1 }, 
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
        [ACTION_CONST_DEATHKNIGHT_FROST] = { 
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
            { -- LICHBORNE HEALING OPTION
                {
                    E = "Checkbox",
                    DB = "lichborneHealing",
                    DBV = false,
                    L = {
                        enUS = "Use Death Coil on player during lichborne for healing",
                    },
                    TT = {
                        enUS = "If enabled, we will use death coil on player during lichborne for healing",
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
                    E = "Slider",
                    MIN = 1000000,
                    MAX = 10000000,
                    DB = "DeathStrikeSliderSpecial",
                    DBV = 2000000,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike Special"
                    },
                    TT = {
                        ANY = "Player lost more than X health last 4 secconds"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathStrikeSlider",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Strike (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Strike"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "DeathPactSlider",
                    DBV = 50,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Death Pact"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SacrificialPactSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Sacrificial Pact (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Sacrificial Pact"
                    },
                    M = {},
                },
            },
			{
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LichborneSlider",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Lichborne (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lichborne"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "IceboundFortitudeSlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Icebound Fortitude (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Icebound Fortitude"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicShellSlider",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Shell (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Shell"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AntiMagicZoneSlider",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Anti Magic Zone (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Anti Magic Zone"
                    },
                    M = {},
                },
            },                   
            { -- CLEANSE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== ADVANCED ====== ",
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
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Healer",   value = "3" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "AsphyxiateDropdown",
                    DBV = "3",
                    L = {
                        ANY = "Asphyxiate",
                    },
                    TT = {
                        enUS = "Auto = We will use Asphyxiate to interrupt any arena unit or to stun the enemy healer in arena. Interrupt = We will use Asphyxiate only to interrupt any arena unit. Healer = We will use Asphyxiate only to stun the enemy healer. Target = We will use Asphyxiate only to interrupt our current target."
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Healer",   value = "3" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "StrangulateDropdown",
                    DBV = "3",
                    L = {
                        ANY = "Strangulate",
                    },
                    TT = {
                        enUS = "Auto = We will use Strangulate to interrupt any arena unit or to stun the enemy Healer in arena. Interrupt = We will use Strangulate only to interrupt any arena unit. Healer = We will use Strangulate only to stun the enemy healer. Target = We will use Strangulate only to interrupt our current target."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Interrupt",   value = "2" },
                        { text = "Target",   value = "4" },
                    },
                    DB = "DeathGripDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Death Grip",
                    },
                    TT = {
                        enUS = "Choose, how the rotation should handle Death Grip."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 40,
                    DB = "TargetRangeSlider",
                    DBV = 10,
                    ONLYOFF = true,
                    L = {
                        ANY = "Target Range"
                    },
                    TT = {
                        ANY = "Target range to use Death Grip when the Dropdown is set to Target"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TargetHealthSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Death Grip Health (%)"
                    },
                    TT = {
                        ANY = "Target HP % to Death Grip when the Target is not in Range"
                    },
                    M = {},
                },
            },
        },
    },
}    

