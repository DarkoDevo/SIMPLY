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
            {
                { -- Snipe Engulf
                    E = "Checkbox",
                    DB = "snipeEngulf",
                    DBV = true,
                    L = {
                        ANY = "Switch Targets Engulf",
                    },
                    TT = {
                        ANY = "Automatically switches targets to snipe Engulf on Fire Breath units.",
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
                    DBV = false,
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
                { -- Full Auto Mode
                    E = "Checkbox",
                    DB = "FullAutoMode",
                    DBV = true,
                    L = {
                        ANY = "Full Auto Mode**",
                    },
                    TT = {
                        ANY = "Just do it all for me please. Heal engine binds must be set (1-5 for dungeon, 1-X for raids).",
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
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- TRINKETS
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVES ====== ",
                    },
                },
            },
            {
                { -- ObsidianScalesHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "ObsidianScalesHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Obsidian Scales HP",
                    },
                    TT = {
                        ANY = "Obsidian Scales HP (%)",
                    },
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- TRINKETS
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
                        ANY = " ====== CLEANSE ====== ",
                    },
                },
            },
			{
				{ -- Cleanse
                    E = "Checkbox",
                    DB = "Cleanse",
                    DBV = true,
                    L = {
                        ANY = "Cleanse",
                    },
                    TT = {
                        ANY = "Automatically cleanse (be sure to set suspend values in your advanced settings).",
                    },
                    M = {},
                },
			},
            { -- LAYOUT SPACE
                { -- Cleanse
                    E = "Checkbox",
                    DB = "makAware",
                    DBV = true,
                    L = {
                        ANY = "Makulu aware messages",
                    },
                    TT = {
                        ANY = "Show Makulu Aware messages on screen",
                    },
                    M = {},
                },
            },
            { -- CLEANSE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== HEALING VALUES ====== ",
                    },
                },
            },
            {

            },
			{
                { -- Global Heal Modifier
                    E = "Slider",
                    MIN = 0,
                    MAX = 2,
					Precision = 1,
                    DB = "globalhealmod",
                    DBV = 0.8,
                    ONOFF = false,
                    L = {
                        ANY = "Global Heal Modifier",
                    },
                    TT = {
                        ANY = "Multiplies the healing calculations by this amount (if healing sliders are set to AUTO). A lower number means that your heals will be cast sooner. Not recommended to have this higher than 1. Default is 0.8.",
                    },
                    M = {},
                },
                { -- EmergencyHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "EmergencyHP",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Emergency HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) of friendly target to consider a healing emergency.",
                    },
                    M = {},
                },
            },
            {
                { -- DreamFlightHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DreamFlightHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Dream Flight HP",
                    },
                    TT = {
                        ANY = "Dream Flight HP (%)",
                    },
                    M = {},
                },
                { -- DreamFlightUnits
                    E = "Slider",
                    MIN = 0,
                    MAX = 15,
                    DB = "DreamFlightUnits",
                    DBV = 10,
                    ONOFF = false,
                    L = {
                        ANY = "Dream Flight Units",
                    },
                    TT = {
                        ANY = "Number of injured friendlies to use Dream Flight. As we can only check in a radius around the player, higher numbers become far less accurate. Will automatically scale to 5 if value is greater than 5 and in a dungeon.",
                    },
                    M = {},
                },
			},
            {
                { -- DreamBreathHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DreamBreathHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Dream Breath HP",
                    },
                    TT = {
                        ANY = "Dream Breath HP (%)",
                    },
                    M = {},
                },
                { -- DreamBreathUnits
                    E = "Slider",
                    MIN = 0,
                    MAX = 5,
                    DB = "DreamBreathUnits",
                    DBV = 3,
                    ONOFF = false,
                    L = {
                        ANY = "Dream Breath Units",
                    },
                    TT = {
                        ANY = "Number of injured friendlies to use Dream Breath.",
                    },
                    M = {},
                },
			},
            {
                { -- SpiritbloomHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SpiritbloomHP",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Spirit Bloom HP",
                    },
                    TT = {
                        ANY = "Spirit Bloom HP (%)",
                    },
                    M = {},
                },
                { -- EchoHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "EchoHP",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Echo HP",
                    },
                    TT = {
                        ANY = "Echo HP (%)",
                    },
                    M = {},
                },
            },
            {
                { -- VerdantEmbraceHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "VerdantEmbraceHP",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Verdant Embrace HP",
                    },
                    TT = {
                        ANY = "Verdant Embrace HP (%)",
                    },
                    M = {},
                },
                { -- EmeraldBlossomHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "EmeraldBlossomHP",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Emerald Blossom HP",
                    },
                    TT = {
                        ANY = "Emerald Blossom HP (%)",
                    },
                    M = {},
                },
            },
            {
                { -- LivingFlameHP
                E = "Slider",
                MIN = 0,
                MAX = 100,
                DB = "LivingFlameHP",
                DBV = 100,
                ONOFF = true,
                L = {
                    ANY = "Living Flame HP",
                },
                TT = {
                    ANY = "Living Flame HP (%)",
                },
                M = {},
                },
            },
            {
                { -- SpiritBloom
                E = "Slider",
                MIN = 1,
                MAX = 4,
                DB = "SpiritSlider",
                DBV = 1,
                ONOFF = false,
                L = {
                    ANY = "Spirit Bloom Empower Level",
                },
                TT = {
                    ANY = "Spirit Bloom Empower Level",
                },
                M = {},
                },
            },
            {
                { -- DreamBreath
                E = "Slider",
                MIN = 1,
                MAX = 4,
                DB = "DreamSlider",
                DBV = 1,
                ONOFF = false,
                L = {
                    ANY = "Dream Breath Empower Level",
                },
                TT = {
                    ANY = "Dream Breath Empower Level",
                },
                M = {},
                },
            },
            {
                { -- FireBreath
                E = "Slider",
                MIN = 1,
                MAX = 4,
                DB = "FireBreathSlider",
                DBV = 2,
                ONOFF = false,
                L = {
                    ANY = "Fire Breath Empower Level",
                },
                TT = {
                    ANY = "Fire Breath Empower Level",
                },
                M = {},
                },
            },

            {
                { E = "Header", L = { ANY = "Hero Talent" } },
                { E = "LayoutSpace" },
            },
            {
                { -- HeroMode
                    E = "Dropdown",
                    DB = "HeroMode",
                    DBV = 1,
                    L = { ANY = "Hero Talent Mode" },
                    TT = { ANY = "Select which Hero tree logic to prefer: Auto detects by talents, or force Flameshaper/Chronowarden." },
                    MIN = 1,
                    MAX = 3,
                    OT = {
                        { text = "Auto", value = 1 },
                        { text = "Flameshaper", value = 2 },
                        { text = "Chronowarden", value = 3 },
                    },
                },
            },
            {
                { E = "Header", L = { ANY = "Stasis Preset" } },
                { E = "LayoutSpace" },
            },
            {
                { -- StasisPreset
                    E = "Dropdown",
                    DB = "StasisPreset",
                    DBV = 1,
                    L = { ANY = "Stasis Stored Spells" },
                    TT = { ANY = "Choose which combo to store in Stasis automatically when available." },
                    MIN = 1,
                    MAX = 3,
                    OT = {
                        { text = "Off", value = 1 },
                        { text = "VE + DB + SB", value = 2 },
                        { text = "TA + DB + SB", value = 3 },
                    },
                },
            },
            {
                { E = "Header", L = { ANY = "Echo and Temporal Anomaly" } },
                { E = "LayoutSpace" },
            },
            {
                { -- EchoStrategy
                    E = "Dropdown",
                    DB = "EchoStrategy",
                    DBV = 2,
                    L = { ANY = "Echo Strategy" },
                    TT = { ANY = "Off = never spread Echo; Conservative = seed 3 targets; Aggressive = seed up to 6 targets prior to big casts." },
                    MIN = 1,
                    MAX = 3,
                    OT = {
                        { text = "Off", value = 1 },
                        { text = "Conservative", value = 2 },
                        { text = "Aggressive", value = 3 },
                    },
                },
                { -- UseTA
                    E = "Checkbox",
                    DB = "UseTA",
                    DBV = true,
                    L = { ANY = "Use Temporal Anomaly" },
                    TT = { ANY = "Allow Temporal Anomaly for light group damage and Echo seeding (non-Arena)." },
                },
            },
            {
                { -- TA_MinTargets
                    E = "Slider",
                    MIN = 0,
                    MAX = 10,
                    DB = "TA_MinTargets",
                    DBV = 3,
                    ONOFF = false,
                    L = { ANY = "TA: Min Injured Units" },
                    TT = { ANY = "Minimum number of injured allies to warrant casting Temporal Anomaly." },
                    M = {},
                },
                { -- TA_MinHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "TA_MinHP",
                    DBV = 80,
                    ONOFF = false,
                    L = { ANY = "TA: HP Threshold" },
                    TT = { ANY = "Injured allies HP% threshold for Temporal Anomaly checks." },
                    M = {},
                },
            },
            {
                { E = "Header", L = { ANY = "Cooldown Modes" } },
                { E = "LayoutSpace" },
            },
            {
                { -- RewindMode
                    E = "Dropdown",
                    DB = "RewindMode",
                    DBV = 1,
                    L = { ANY = "Rewind Mode" },
                    TT = { ANY = "Auto = automatic usage; Manual = never auto-use." },
                    MIN = 1,
                    MAX = 2,
                    OT = {
                        { text = "Auto", value = 1 },
                        { text = "Manual", value = 2 },
                    },
                },
                { -- DFMode
                    E = "Dropdown",
                    DB = "DFMode",
                    DBV = 1,
                    L = { ANY = "Dream Flight Mode" },
                    TT = { ANY = "Auto = automatic usage; Manual = never auto-use." },
                    MIN = 1,
                    MAX = 2,
                    OT = {
                        { text = "Auto", value = 1 },
                        { text = "Manual", value = 2 },
                    },
                },
            },
            {
                { -- ECMode
                    E = "Dropdown",
                    DB = "ECMode",
                    DBV = 1,
                    L = { ANY = "Emerald Communion Mode" },
                    TT = { ANY = "Auto = automatic usage; Manual = never auto-use." },
                    MIN = 1,
                    MAX = 2,
                    OT = {
                        { text = "Auto", value = 1 },
                        { text = "Manual", value = 2 },
                    },
                },
            },
            {
                { E = "Header", L = { ANY = "Safety / DPS" } },
                { E = "LayoutSpace" },
            },
            {
                { -- AllowDPSWhenSafe
                    E = "Checkbox",
                    DB = "AllowDPSWhenSafe",
                    DBV = true,
                    L = { ANY = "DPS When Team Stable" },
                    TT = { ANY = "Allow swapping to damage when group is above the Safe Heal Threshold." },
                },
                { -- SafeHealThreshold
                    E = "Slider",
                    MIN = 50,
                    MAX = 100,
                    DB = "SafeHealThreshold",
                    DBV = 85,
                    ONOFF = false,
                    L = { ANY = "Safe Heal Threshold" },
                    TT = { ANY = "If the team is above this HP%, the rotation may cast damage spells." },
                    M = {},
                },
            },
            {
                { E = "Header", L = { ANY = "Tip the Scales Usage" } },
                { E = "LayoutSpace" },
            },
            {
                { -- TipUsage MULTI
                    E = "Dropdown",
                    MULT = true,
                    DB = "TipUsage",
                    DBV = {
                        [1] = true, -- Dream Breath
                        [2] = true, -- Spiritbloom
                        [3] = false, -- Fire Breath
                    },
                    OT = {
                        { text = "Dream Breath", value = 1 },
                        { text = "Spiritbloom", value = 2 },
                        { text = "Fire Breath", value = 3 },
                    },
                    L = { ANY = "Use Tip the Scales with:" },
                    TT = { ANY = "Select which abilities should use Tip the Scales automatically." },
                },
            },
        },


	},
}