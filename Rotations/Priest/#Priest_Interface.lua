local Action = _G.Action

local A                = Action

local CONST                                                              = Action.Const

local ACTION_CONST_PRIEST_SHADOW                                      = CONST.PRIEST_SHADOW

LPH_ENCNUM = function(val) return val end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "v2.0 (8 March 2025)",
    -- Class settings
    [2] = {
        [ACTION_CONST_PRIEST_SHADOW] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Shadow Priest ====== ",
                    },
                },
            },
            {
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
                { -- Mouseover
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = false,
                    L = { 
                        ANY = "Auto DOT", 
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to spread VT when Shadow Crash isn't available.", 
                    }, 
                    M = {},
                },
                { -- Cursor
                    E = "Checkbox", 
                    DB = "cursorCheck",
                    DBV = true,
                    L = { 
                        ANY = "Cursor Check (Shadow Crash)", 
                    }, 
                    TT = { 
                        ANY = "Check that the cursor is over an enemy before using Shadow Crash."
                    }, 
                    M = {},
                },   
            },
            { -- Spacer
                
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
                        ANY = "Cooldowns",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Void Eruption / Dark Ascension", value = 1 }, 
                        { text = "Shadowfiend / Mindbender / Voidwraith", value = 2 },     
                        { text = "Void Torrent", value = 3 },   
                    },
                    MULT = true,
                    DB = "cooldownSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
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
            { -- Spacer
                {
                    E = "LayoutSpace",
                },
            },
            { 
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "burstSens",
                    DBV = 18,
                    ONOFF = false,
                    L = { 
                        ANY = "Burst Mode Time To Die",
                    },
                    TT = { 
                        ANY = "Measures the TTD of enemies to determine when to use cooldowns. A lower number means cooldowns used closer to death.\nIgnored on bosses.", 
                    },                     
                    M = {},
                },  
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "vtRefresh",
                    DBV = 12,
                    ONOFF = false,
                    L = { 
                        ANY = "Vampiric Touch Time To Die",
                    },
                    TT = { 
                        ANY = "Measures the TTD of enemies to determine when to use Vampiric Touch / Shadow Crash. A lower number means Vampiric Touch / Shadow Crash used closer to death.\nIgnored on bosses.", 
                    },                     
                    M = {},
                },     
            },
            { -- Spacer
                {
                    E = "LayoutSpace",
                },
            },
            { -- PRIEST HEADER
                {
                    E = "Header",
                    L = {
                        ANY = "INTERRUPTS",
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
            },
            { -- Spacer
                {
                    E = "LayoutSpace",
                },
            },
            { -- PRIEST HEADER
                {
                    E = "Header",
                    L = {
                        ANY = "DEFENSIVES",
                    },
                },
            },
            {
                { -- DesperatePrayerHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DesperatePrayerHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Desperate Prayer HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Desperate Prayer on yourself.", 
                    },                     
                    M = {},
                },    
                { -- Power Word Shield HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "PWSHP",
                    DBV = 75,
                    ONOFF = false,
                    L = { 
                        ANY = "Power Word: Shield HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Power Word: Shield on yourself.", 
                    },                     
                    M = {},
                },    
            },
            {
                {-- Burst Sensitivity
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "dispersionHP",
                    DBV = 20,
                    ONOFF = false,
                    L = { 
                        ANY = "Dispersion HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Dispersion.", 
                    },                     
                    M = {},
                },    
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Fade", value = 1 }, 
                        { text = "Vampiric Embrace", value = 2 },  
                        { text = "Protective Light", value = 3 },
                        { text = "Power Word: Shield", value = 4 },    
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        ANY = "Defensive Reactions", 
                    }, 
                    TT = { 
                        ANY = "Select what spells to be used when reacting to incoming damage in dungeons.", 
                    }, 
                    M = {},                                    
                },   
            },
            { -- Spacer
                
                {
                    E = "LayoutSpace",
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
                        { text = "Focus Reminder", value = 1 }, 
                        { text = "Shadow Crash Ready", value = 2 },
                        { text = "Void Torrent Soon", value = 3 },      
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
        [ACTION_CONST_PRIEST_HOLY] = {
            {
                {
                    E = "Checkbox", 
                    DB = "Iconbar1",
                    DBV = false,
                    L = { 
                        enUS = "Qeuebar", 
                    }, 
                    TT = { 
                        enUS = "Choose whether you want to display an bar to queue and block cooldowns", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Iconbar2",
                    DBV = false,
                    L = {
                        enUS = "Presettings",
                    },
                    TT = {
                        enUS = "Choose whether you want to display an bar with presettings for M+ | Raids | Pvp - It's editable!",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SetupHealingTab",
                    DBV = true,
                    L = {
                        enUS = "Auto Setup",
                    },
                    TT = {
                        enUS = "If enabled, we will Auto setup the 'Healing System' Tab in action to our prefered values",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "castWhileMoving",
                    DBV = false,
                    L = {
                        ANY = "Allow Casting While Moving",
                    },
                    TT = {
                        ANY = "Enable this if you have a buff that allows casting while moving",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        enUS = "Use AoE",
                    },
                    TT = {
                        enUS = "As healer, we use it to toggle our Aoe Healing Spells like 'Wild Growth' - 'Essence Font' - 'Prayer of Healing' etc ",
                    },
                    M = {},
                },

            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RenewSlider",
                    DBV = 95,
                    ONOFF = true,
                    L = {
                        ANY = "Renew (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Renew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "PowerWordShieldSlider",
                    DBV = 90,
                    ONOFF = true,
                    L = {
                        ANY = "Power Word Shield (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Shield"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LightweaverSlider",
                    DBV = 80,
                    ONOFF = true,
                    L = {
                        ANY = "Lightweaver (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal and Heal alternate"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HealSlider",
                    DBV = 85,
                    ONOFF = true,
                    L = {
                        ANY = "Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Heal"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashHealSlider",
                    DBV = 70,
                    ONOFF = true,
                    L = {
                        ANY = "Flash Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HolyWordSerenitySlider",
                    DBV = 70,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Word Serenity (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Holy Word Serenety"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "GSTank",
                    DBV = false,
                    L = {
                        enUS = "GS Tanks",
                    },
                    TT = {
                        enUS = "If enabled, we will use Guardian Spirit on Tanks only",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "DivineImageBox",
                    DBV = false,
                    L = {
                        enUS = "Divine Image",
                    },
                    TT = {
                        enUS = "If enabled, we wont cast any new Holy Word until Divine Image Buff is gone",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ResonantWordsBox",
                    DBV = true,
                    L = {
                        enUS = "Resonant Words",
                    },
                    TT = {
                        enUS = "If enabled, we wont cast any new Holy Word until Resonant Words Buff is gone",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "HWS",
                    DBV = false,
                    L = {
                        enUS = "HWS Range Check",
                    },
                    TT = {
                        enUS = "If enabled, we will use Holy Word Sanctify with range check for @player macros",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "SpreadDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Shadow Word: Pain",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All",         value = "All" },
                        { text = "Party1",      value = "Party1" },
                        { text = "Party2",      value = "Party2" },
                        { text = "Party3",      value = "Party3" },
                        { text = "Party4",      value = "Party4" },
                        { text = "Mouseover",   value = "Mouseover" },
                    },
                    DB = "PowerInfusionDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Power Infusion Mode",
                    },
                    TT = {
                        enUS = "Choose, a specific class you want to support with Power Infusion - or use ALL"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "High Priority",   value = "1" },
                        { text = "Low Priority",    value = "2" },
                        { text = "While Moving",    value = "3" },
                        { text = "Off",             value = "4" },
                    },
                    DB = "PrayerofMendingMenu",
                    DBV = "1",
                    L = {
                        ANY = "Prayer of Mending Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the priority"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Always",    value = "1" },
                        { text = "Moving",    value = "2" },
                        { text = "Off",       value = "3" },
                    },
                    DB = "RenewMenu",
                    DBV = "2",
                    L = {
                        ANY = "Renew Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the priority"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Always",    value = "1" },
                        { text = "Moving",    value = "2" },
                        { text = "Off",       value = "3" },
                    },
                    DB = "PowerWordShieldMenu",
                    DBV = "2",
                    L = {
                        ANY = "Power Word Shield Mode",
                    },
                    TT = {
                        enUS = "Choose, how you want to handle the priority"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Desperate Prayer (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Desperate Prayer"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "ManaTresholdDpsSlider",
                    DBV = 25,
                    ONLYOFF = true,
                    L = {
                        ANY = "Mana Treshold (%)"
                    },
                    TT = {
                        ANY = "Player Mana % to use Dps Spells"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LeapofFaithSlider",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Leap of Faith (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Leap of Faith"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 10,
                    DB = "HolyNovaSlider",
                    DBV = 5,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Holy Nova"
                    },
                    TT = {
                        ANY = "Amount of targets to use Holy Nova"
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
        [ACTION_CONST_PRIEST_DISCIPLINE] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Discipline Priest ====== ",
                    },
                },
            },
            {	
                {
                    E = "Checkbox",
                    DB = "SetupHealingTab",
                    DBV = true,
                    L = {
                        enUS = "Auto Setup",
                    },
                    TT = {
                        enUS = "If enabled, we will Auto setup the 'Healing System' Tab in action to our prefered values",
                    }, 
                    M = {},
                },
            },
            {
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
                { -- Cast While Moving
                    E = "Checkbox",
                    DB = "castWhileMoving",
                    DBV = false,
                    L = {
                        ANY = "Allow Casting While Moving",
                    },
                    TT = {
                        ANY = "Enable this if you have a buff that allows casting while moving",
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
            {	
                { -- Pet
                    E = "Checkbox", 
                    DB = "sendPet",
                    DBV = true,
                    L = { 
                        ANY = "Shadowfiend/Mindbender/Voidwraith ASAP",
                    }, 
                    TT = { 
                        ANY = "Send Shadowfiend/Mindbender/Voidwraith whenever ready with Mind Blast.\nOnly for dungeons.",
                    }, 
                    M = {},
                },
                { -- Feather
                    E = "Checkbox", 
                    DB = "saveFeather",
                    DBV = true,
                    L = { 
                        ANY = "Keep One Feather Charge",
                    }, 
                    TT = { 
                        ANY = "Always have one charge of Angelic Feather available for manual use.",
                    }, 
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Party 1", value = 1 },
                        { text = "Party 2", value = 2 },
                        { text = "Party 3", value = 3 },
                        { text = "Party 4", value = 4 },
                    },
                    MULT = true,
                    DB = "piSelect",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },
                    L = {
                        ANY = "Power Infusion Units", 
                    },
                    TT = {
                        ANY = "Select what units you want to use Power Infusion on. It will automatically exclude tank/healer.",
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
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "desperatePrayerHP",
                    DBV = 65,
                    ONOFF = false,
                    L = {
                        ANY = "Desperate Prayer HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Desperate Prayer."
                    },
                    M = {},
                },
                { -- Debug
                    E = "Checkbox", 
                    DB = "externalWeak",
                    DBV = false,
                    L = { 
                        ANY = "External Defensive on Weakest",
                    }, 
                    TT = { 
                        ANY = "Use Pain Suppression/Weal and Woe shield on 'weakest' party member without defensive active during incoming damage.",
                    }, 
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = "Healing Values",
                    },
                },
            },            
            {
                { -- Global Heal Modifier
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 20, 
                    DB = "forceDPS",
                    DBV = 14,
                    ONOFF = false,
                    L = { 
                        ANY = "Force DPS on Atonement Count",
                    },
                    TT = { 
                        ANY = "Force DPS when the amount of atonements reach this number OUTSIDE of a ramp.\n(This means that ramps will continue as normal)", 
                    },                     
                    M = {},
                },		
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "renewHP",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Renew (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Renew"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "pwsHP",
                    DBV = 80,
                    ONOFF = false,
                    L = { 
                        ANY = "Power Word Shield (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Power Word Shield"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "penanceHP",
                    DBV = 45,
                    ONOFF = false,
                    L = { 
                        ANY = "Penance (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Penance"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "flashHealHP",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = "Flash Heal (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Flash Heal"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "voidShiftLowest",
                    DBV = 35,
                    ONOFF = false,
                    L = {
                        ANY = "Void Shift Lowest"
                    },
                    TT = {
                        ANY = "Lowest HP % of yourself/party member to save with Void Shift."
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "voidShiftHighest",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Void Shift Highest"
                    },
                    TT = {
                        ANY = "Highest HP % of yourself/party member to save with Void Shift."
                    },
                    M = {},
                },
            },
            {
                { -- Global Heal Modifier
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100, 
                    DB = "atonementSensitivity",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = "Atonement Sensitivity",
                    },
                    TT = { 
                        ANY = "The % HP outlier required to switch to a direct heal spell versus using atonement healing. The higher the number, the more you rely on atonement for healing and less on direct healing. Recommended somewhere around 35.\nIn clearer terms: if one person has significantly less health than everyone else, it will try to use a direct heal rather than group atonement.", 
                    },                     
                    M = {},
                },	
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto",        value = "Auto" },
                        { text = "Manual",      value = "Manual" },
                    },
                    DB = "rampMode",
                    DBV = "Auto",
                    L = {
                        ANY = "Ramp Mode",
                    },
                    TT = {
                        enUS = "Select between Automatic and Manual ramp mode.\nAutomatic: Let the rotation handle ramp timers and attempt to automatically blanket the raid (very beta).\nManual: Use a macro to toggle on and off the ramp when you want it."
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "startRamp",
                    DBV = false,
                    L = { 
                        enUS = "Start Ramp",
                    },
                    TT = {
                        enUS = "This controls the ramp in Manual Ramp Mode! Right-click this button to make a macro that allows you to turn your ramp on and off when you want!",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "PwsTank",
                    DBV = false,
                    L = { 
                        enUS = "PWS Tank",
                    },
                    TT = {
                        enUS = "If enbaled, we will keep PWS active on Tanks",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "OOCHeal",
                    DBV = true,
                    L = { 
                        enUS = "Out of Combat Heal",
                    },
                    TT = {
                        enUS = "If enabled, we will Out of Combat Heal",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "forceBeforePet",
                    DBV = false,
                    L = {
                        enUS = "Refresh Atonement Before Pet",
                    },
                    TT = {
                        enUS = "If enabled, we will refresh group atonement with Power Word: Radiance right before summoning pet if needed.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "forceCastPWRSelf",
                    DBV = false,
                    L = {
                        enUS = "Radiance on self",
                    },
                    TT = {
                        enUS = "Enable to cast Power Word: Radiance on yourself only.\nUseful when in M+ and everyone is scatted; allows you to position yourself in the center.",
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
                        { text = "Spread Shield", value = 1 }, 
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
                        ANY = "Don't Touch The Stuff Below",
                    },
                },
            },    
            {
                {
                    E = "Checkbox",
                    DB = "uppiesRamp",
                    DBV = false,
                    L = { 
                        enUS = "Uppies Ramp",
                    },
                    TT = {
                        enUS = "Call Uppies Ramp. This is for Auto mode only. Do not try to macro this.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "evangRamp",
                    DBV = false,
                    L = { 
                        enUS = "Evangelism Ramp",
                    },
                    TT = {
                        enUS = "Call Evangelism Ramp. This is for Auto mode only. Do not try to macro this.",
                    },
                    M = {},
                },
            },
        },
    },
}

