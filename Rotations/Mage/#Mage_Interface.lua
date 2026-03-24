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
    DateTime = "TWW v 2.0 (14 April 2025)",
    -- Class settings
    [2] = {
        [ACTION_CONST_MAGE_FIRE] = {
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
                        ANY = "Cursor Check (Meteor/Flamestrike)",
                    },
                    TT = {
                        ANY = "Check that the cursor is over an enemy before using Meteor/Flamestrike."
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
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Pyroblast / Flamestrike", value = 1 },
                        { text = "Shifting Power", value = 2 },
                    },
                    MULT = true,
                    DB = "floesSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },
                    L = {
                        ANY = "Ice Floes Spells",
                    },
                    TT = {
                        ANY = "Select what spells to be used with Ice Floes.",
                    },
                    M = {},
                },
            },
            {
                { -- Debug
                    E = "Checkbox",
                    DB = "holdCombustIB",
                    DBV = true,
                    L = {
                        ANY = "Hold Combust for IB/PF charges",
                    },
                    TT = {
                        ANY = "Wait until we have 2+ Flame Blast/1+ Phoenix Flames charges before using Combust.\nUseful if you've just spent everything during a mini-combust proc.",
                    },
                    M = {},
                },
                { -- Debug
                    E = "Checkbox",
                    DB = "scorchOnly",
                    DBV = true,
                    L = {
                        ANY = "Only Scorch During Execute",
                    },
                    TT = {
                        ANY = "Only use Scorch during execute phase if enemy isn't a boss.\nEnabling this means we will not use Phoenix Flames or Fire Blast if the current non-boss target is below 30%.",
                    },
                    M = {},
                },
            },
            {
                { -- Debug
                    E = "Checkbox",
                    DB = "blessingOnBurst",
                    DBV = false,
                    L = {
                        ANY = "SKB with Burst Toggle",
                    },
                    TT = {
                        ANY = "Only consume SKB with Burst Toggle or if it's about to expire.",
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
            { -- Potions
                { -- useDamagePotion
                    E = "Checkbox",
                    DB = "damagePotion",
                    DBV = true,
                    L = {
                        ANY = "Damage Potion"
                    },
                    TT = {
                        ANY = "Use Tempered Potion / Unwavering Focus",
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
                        ANY = "Only use Tempered Potion / Unwavering Focus when any kind of Bloodlust/Warp active."
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
                        ANY = "Use Tempered Potion / Unwavering Focus while Exhausted (can't use Bloodlust)."
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
                        { text = "Ice Block / Ice Cold", value = 1 },
                        { text = "Mass Barrier", value = 2 },
                        { text = "Mirror Image", value = 3 },
                        { text = "Greater Invisibility", value = 4 },
                        { text = "Blazing Barrier", value = 5 },
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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
                { -- Ice Block / Ice Cold
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "iceBlockHP",
                    DBV = 35,
                    ONOFF = false,
                    L = {
                        ANY = "Ice Block / Ice Cold",
                    },
                    TT = {
                        ANY = "HP (%) to use Ice Block / Ice Cold",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "massBarrierHP",
                    DBV = 55,
                    ONOFF = false,
                    L = {
                        ANY = "Mass Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Mass Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "greaterInvisibilityHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Greater Invisibility",
                    },
                    TT = {
                        ANY = "HP (%) to use Greater Invisibility",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "blazingBarrierHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Blazing Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Blazing Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mirror Image HP (PvP Only)
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "MirrorImageHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Mirror Image (PvP Only)",
                    },
                    TT = {
                        ANY = "HP (%) to use Mirror Image in PvP",
                    },
                    M = {},
                },
            },
            {
                { -- Feign Death
                    E = "Checkbox",
                    DB = "feignMechs",
                    DBV = true,
                    L = {
                        ANY = "Invisibility Targeted Mechanics",
                    },
                    TT = {
                        ANY = "Use Invisibility/Greater Invisibility to drop targeted mechanics in PvE content.",
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
                        { text = "Ice Floes", value = 1 },
                        { text = "Shifting Power Soon", value = 2 },
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
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
        },
        [ACTION_CONST_MAGE_ARCANE] = {
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
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Utility",
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
                    DB = "lockTotM",
                    DBV = true,
                    L = {
                        ANY = "Lock TotM Target",
                    },
                    TT = {
                        ANY = "Prevents automatically swapping targets when your current target has Touch of the Magi on them.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Arcane Surge", value = 1 },
                        { text = "Shifting Power", value = 2 },
                    },
                    MULT = true,
                    DB = "floesSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },
                    L = {
                        ANY = "Ice Floes Spells",
                    },
                    TT = {
                        ANY = "Select what spells to be used with Ice Floes.",
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
                    E = "Checkbox",
                    DB = "arcaneSoulCdOpener",
                    DBV = false,
                    L = {
                        ANY = "Use Sunfury S3 Soul Opener",
                    },
                    TT = {
                        ANY = "When enabled (and if Sunfury + S3 4pc, no Magi's Spark, and 3+ targets), use the alternate Evocation-in-Surge opener per SimC instead of the default opener. Still obeys the Burst toggle.",
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
                        ANY = "Use Tempered Potion / Unwavering Focus",
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
                        ANY = "Only use Tempered Potion / Unwavering Focus when any kind of Bloodlust/Warp active."
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
                        ANY = "Use Tempered Potion / Unwavering Focus while Exhausted (can't use Bloodlust)."
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
                        { text = "Ice Block / Ice Cold", value = 1 },
                        { text = "Mass Barrier", value = 2 },
                        { text = "Mirror Image", value = 3 },
                        { text = "Greater Invisibility", value = 4 },
                        { text = "Prismatic Barrier", value = 5 },
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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
                { -- Ice Block / Ice Cold
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "iceBlockHP",
                    DBV = 35,
                    ONOFF = false,
                    L = {
                        ANY = "Ice Block / Ice Cold",
                    },
                    TT = {
                        ANY = "HP (%) to use Ice Block / Ice Cold",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "massBarrierHP",
                    DBV = 55,
                    ONOFF = false,
                    L = {
                        ANY = "Mass Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Mass Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "greaterInvisibilityHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Greater Invisibility",
                    },
                    TT = {
                        ANY = "HP (%) to use Greater Invisibility",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "prismaticBarrierHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Prismatic Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Prismatic Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mirror Image HP (PvP Only)
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "MirrorImageHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Mirror Image (PvP Only)",
                    },
                    TT = {
                        ANY = "HP (%) to use Mirror Image in PvP",
                    },
                    M = {},
                },
            },
            {
                { -- Feign Death
                    E = "Checkbox",
                    DB = "feignMechs",
                    DBV = true,
                    L = {
                        ANY = "Invisibility Targeted Mechanics",
                    },
                    TT = {
                        ANY = "Use Invisibility/Greater Invisibility to drop targeted mechanics in PvE content.",
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
                {
                    E = "Checkbox",
                    DB = "makAwareToggle",
                    DBV = true,
                    L = {
                        ANY = "Enable Aware Messages",
                    },
                    TT = {
                        ANY = "Enable awareness messages from the rotation.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Ice Floes", value = 1 },
                        { text = "Shifting Power Soon", value = 2 },
                        { text = "Arcane Surge Soon", value = 3 },
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
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",
                },
            },
        },
        [ACTION_CONST_MAGE_FROST] = {
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
                {-- Burst Sensitivity
                    E = "Slider",
                    MIN = 0,
                    MAX = 15,
                    DB = "orbTTD",
                    DBV = 8,
                    ONOFF = false,
                    L = {
                        ANY = "Frozen Orb TTD",
                    },
                    TT = {
                        ANY = "Check enemy pack estimated time to die before using Frozen Orb.",
                    },
                    M = {},
                },
                { -- AOE
                    E = "Checkbox",
                    DB = "orbWithoutBurst",
                    DBV = false,
                    L = {
                        ANY = "Frozen Orb when Burst Off",
                    },
                    TT = {
                        ANY = "Use Frozen Orb in Single Target/Cleave while burst is turned off.\nEnabling this will have Frozen Orb ignore Icy Veins cooldown when you turn burst off.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "10", value = "10" },
                        { text = "15", value = "15" },
                    },
                    DB = "cocRange",
                    DBV = "10",
                    L = {
                        ANY = "Cone of Cold Range",
                    },
                    TT = {
                        ANY = "Range check on which to use Cone of Cold.\nUnfortunately, Cone of Cold is 12y range and we can only check 10y or 15y.\nSetting this to 10y will mean you will need to move closer to trigger CoC, while 15y means that you might end up missing enemies."
                    },
                    M = {},
                },
                {-- Burst Sensitivity
                    E = "Slider",
                    MIN = 0,
                    MAX = 30,
                    DB = "orbCocCD",
                    DBV = 10,
                    ONOFF = false,
                    L = {
                        ANY = "Orb CD for CoC",
                    },
                    TT = {
                        ANY = "Cooldown remaining on Frozen Orb to use Cone of Cold for Coldest Snap reset.",
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
                        ANY = "Cursor Check (Blizzard)",
                    },
                    TT = {
                        ANY = "Check that the cursor is over an enemy before using Blizzard."
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
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Glacial Spike", value = 1 },
                        { text = "Ray Of Frost", value = 2 },
                        { text = "Shifting Power", value = 3 },
                    },
                    MULT = true,
                    DB = "floesSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                    },
                    L = {
                        ANY = "Ice Floes Spells",
                    },
                    TT = {
                        ANY = "Select what spells to be used with Ice Floes.",
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
            { -- Potions
                { -- useDamagePotion
                    E = "Checkbox",
                    DB = "damagePotion",
                    DBV = true,
                    L = {
                        ANY = "Damage Potion"
                    },
                    TT = {
                        ANY = "Use Tempered Potion / Unwavering Focus",
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
                        ANY = "Only use Tempered Potion / Unwavering Focus when any kind of Bloodlust/Warp active."
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
                        ANY = "Use Tempered Potion / Unwavering Focus while Exhausted (can't use Bloodlust)."
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
                        { text = "Ice Block / Ice Cold", value = 1 },
                        { text = "Mass Barrier", value = 2 },
                        { text = "Mirror Image", value = 3 },
                        { text = "Greater Invisibility", value = 4 },
                        { text = "Ice Barrier", value = 5 },
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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
                { -- Ice Block / Ice Cold
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "iceBlockHP",
                    DBV = 35,
                    ONOFF = false,
                    L = {
                        ANY = "Ice Block / Ice Cold",
                    },
                    TT = {
                        ANY = "HP (%) to use Ice Block / Ice Cold",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "massBarrierHP",
                    DBV = 55,
                    ONOFF = false,
                    L = {
                        ANY = "Mass Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Mass Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "greaterInvisibilityHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Greater Invisibility",
                    },
                    TT = {
                        ANY = "HP (%) to use Greater Invisibility",
                    },
                    M = {},
                },
                { -- Mass Barrier
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "iceBarrierHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Ice Barrier Barrier",
                    },
                    TT = {
                        ANY = "HP (%) to use Ice Barrier",
                    },
                    M = {},
                },
            },
            {
                { -- Mirror Image HP (PvP Only)
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "MirrorImageHP",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Mirror Image (PvP Only)",
                    },
                    TT = {
                        ANY = "HP (%) to use Mirror Image in PvP",
                    },
                    M = {},
                },
            },
            {
                { -- Feign Death
                    E = "Checkbox",
                    DB = "feignMechs",
                    DBV = true,
                    L = {
                        ANY = "Invisibility Targeted Mechanics",
                    },
                    TT = {
                        ANY = "Use Invisibility/Greater Invisibility to drop targeted mechanics in PvE content.",
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
                        { text = "Ice Floes", value = 1 },
                        { text = "Shifting Power Soon", value = 2 },
                        { text = "Glacial Spike Soon", value = 3 },
                        { text = "Ray of Frost Soon", value = 4 },
                    },
                    MULT = true,
                    DB = "makAware",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
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
    },
}
