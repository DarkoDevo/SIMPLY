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
    DateTime = "v2.0.0 (11 January 2024)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_WARRIOR_PROTECTION] = { 
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
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
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
                { -- ShieldWallHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ShieldWallHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Shield Wall HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Shield Wall.", 
                    },                     
                    M = {},
                },
                { -- LastStandHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "LastStandHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Last Stand HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Last Stand.", 
                    },                     
                    M = {},
                },
            },		
            {
                { -- VictoryRushHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "VictoryRushHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Victory Rush HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Victory Rush.", 
                    },                     
                    M = {},
                },
                { -- VictoryRushHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "BitterImmunityHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Bitter Immunity HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Bitter Immunity.", 
                    },                     
                    M = {},
                },
            },							
        },
        [ACTION_CONST_WARRIOR_FURY] = {
            {{ E = "LayoutSpace", },},
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
        },
        [ACTION_CONST_WARRIOR_ARMS] = { 
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
                { -- BitterImmunity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "BitterImmunityHP",
                    DBV = 40,
                    ONOFF = false,
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
                    DB = "DiebytheSwordHP",
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
                { -- VictoryRushHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "VictoryRushHP",
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Victory Rush HP",
                    },
                    TT = { 
                        ANY = "HP (%) to use Victory Rush.", 
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