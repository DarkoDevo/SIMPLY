local Action = _G.Action

local A                = Action

local CONST                                                              = Action.Const

local ACTION_CONST_DRUID_FERAL                                      = CONST.DRUID_FERAL
local ACTION_CONST_DRUID_RESTORATION                                = CONST.DRUID_RESTORATION

LPH_ENCNUM = function(val) return val end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "TWW Season 2 (28 February 2025)",
    -- Class settings
    [2] = {
        [ACTION_CONST_DRUID_FERAL] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Feral Druid ====== ",
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
                { -- autoShift
                    E = "Checkbox", 
                    DB = "autoShift",
                    DBV = true,
                    L = { 
                        ANY = "Auto Shapeshift",
                    }, 
                    TT = { 
                        ANY = "Automatically shapeshift out of roots.",
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Cat Form", value = 1 },
                        { text = "Bear Form", value = 2 },
                    },
                    MULT = true,
                    DB = "autoForms",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },  
                    L = { 
                        ANY = "Forms for Auto Shapeshift", 
                    }, 
                    TT = { 
                        ANY = "Choose what forms you want to shapeshift into.", 
                    }, 
                    M = {},                                    
                },
            },
            {
                { -- autoShift
                    E = "Checkbox", 
                    DB = "stayInBear",
                    DBV = false,
                    L = { 
                        ANY = "Stay In Bear Form",
                    }, 
                    TT = { 
                        ANY = "Only enable this if you want to manually leave bear form.\nUseful for preempting big damage with Bear Form in higher keys.",
                    }, 
                    M = {},
                },
            },
            {
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = true,
                    L = { 
                        ANY = "Auto DoT",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to cast Rake on everything in combat.",
                    }, 
                    M = {},
                },
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "easySwipe",
                    DBV = false,
                    L = { 
                        ANY = "No Shred in AoE",
                    }, 
                    TT = { 
                        ANY = "Don't use Shred in AoE (generally worse than allowing Shred in AoE).",
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
                        ANY = "Revive/Rebirth Mouseover",
                    }, 
                    TT = { 
                        ANY = "Use Revive/Rebirth on dead mouseover.",
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
                        { text = "Tiger's Fury", value = 1 },
                        { text = "Berserk/Incarnation", value = 2 },
                        { text = "Feral Frenzy", value = 3 },
                        { text = "Convoke the Spirits", value = 4 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
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
            {
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
                    DB = "healingUnits",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        ANY = "Heal Units", 
                    }, 
                    TT = { 
                        ANY = "Select the units in your group that you want to heal with Predatory Swiftness procs.", 
                    }, 
                    M = {},                                    
                },
                { -- offHealingHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "offHealingHP",
                    DBV = 80,
                    ONOFF = false,
                    L = { 
                        ANY = "Off-Healing HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Predatory Swiftness procs on Regrowth.", 
                    },                     
                    M = {},
                },	
            },
            {
                { -- BarkskinHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "BarkskinHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Barkskin HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Barkskin.", 
                    },                     
                    M = {},
                },	
                { -- RenewalHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RenewalHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Renewal HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Renewal.", 
                    },                     
                    M = {},
                },
            },
            {
                { -- FrenziedRegen
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "FrenziedRegenerationHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = "Frenzied Regenration HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Frenzied Regeneration while in Bear Form OR with Empowered Shapeshifting talent.", 
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
                        { text = "Force of Nature", value = 1 }, 
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
        [ACTION_CONST_DRUID_RESTORATION] = {
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
            {
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 5,
                    DB = "AutoHealSensitivitySlider",
                    DBV = 2,
                    ONOFF = false,
                    L = {
                        ANY = "Auto Heal Sensitivity"
                    },
                    TT = {
                        ANY = "Auto Heal assesses the health deficit and factors in the potency of the heal, including incoming healing, damage taken, and active HoTs.\nThe slider adjusts the healing value: a lower slider setting results in more aggressive healing, consuming more mana, whereas a higher setting leads to less aggressive healing, aiding in better mana management."
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Healing Settings ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "LifebloomSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Lifebloom (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Lifebloom for Non Tanks"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RejuvenationSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = "Rejuvenation (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Rejuvenation"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FreecastSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Clearcast (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regrowth"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "CenarionWardSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Cenarion Ward (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Cenarion Ward"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "RegrowthSlider",
                    DBV = 65,
                    ONOFF = true,
                    L = {
                        ANY = "Regrowth (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regrowth"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "NourishSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Nourish (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Nourish"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "Swiftmend",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Swiftmend (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Swiftmend"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AutoSpread",
                    DBV = false,
                    L = { 
                        enUS = "Auto Spread",
                    },
                    TT = {
                        enUS = "When enabled, we will spread Rejuvenation automatically while we are in fight and above the Mana Slider",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ForceSpread",
                    DBV = false,
                    L = { 
                        enUS = "High priority Spread",
                    },
                    TT = {
                        enUS = "When enabled, we will force the spread of Rejuvenation over all other actions",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SpreadHot",
                    DBV = false,
                    L = {
                        enUS = "Low priority Spread",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Rejuvenation with lower priority as other actions",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        enUS = "OOC Hots",
                    },
                    TT = {
                        enUS = "If enbaled, we will pre hot the tank with Lifebloom and Rejuvenation",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        enUS = "Force Swiftmend into CW",
                    },
                    TT = {
                        enUS = "If enbaled, we will force to extend the Cenarion Ward Buff",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Photosynthesis",
                    },
                    TT = {
                        enUS = "If enbaled, we will swap Lifebloom to player (Darkflight Icon) with Photosynthesis Talent",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox5",
                    DBV = true,
                    L = { 
                        enUS = "CW everyone",
                    },
                    TT = {
                        enUS = "When enabled, Cenarion Ward will be applied flexibly to any party or raid member. If not enabled, it will only be cast on tanks",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "KeepGrove",
                    DBV = false,
                    L = { 
                        enUS = "Grove Guardians on CD",
                    },
                    TT = {
                        enUS = "When enabled, we will keep Grove Guardians active",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "Checkbox4",
                    DBV = false,
                    L = { 
                        enUS = "Convoke for low health",
                    },
                    TT = {
                        enUS = "If enbaled, we will use Convoke the Spirits to heal up a low health member",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "MultiDot",
                    DBV = false,
                    L = {
                        enUS = "Multi Dot",
                    },
                    TT = {
                        enUS = "If enabled, we will spread Moonfire Dot",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "StarfireInstantBox",
                    DBV = false,
                    L = { 
                        enUS = "Use Starfire only with Instant Buff",
                    },
                    TT = {
                        enUS = "",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "PrepareTeamBox",
                    DBV = true,
                    L = { 
                        enUS = "Precast Wild Growth",
                    },
                    TT = {
                        enUS = "If enbaled we will precast Wild Growth",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "MouseOverRootRaid",
                    DBV = false,
                    L = { 
                        enUS = "Root Mouseover in Raid",
                    },
                    TT = {
                        enUS = "We will root the mouseover target in raid for specific mechanics. Requires mouse over macro.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "LifrBloomAll",
                    DBV = false,
                    L = { 
                        enUS = "Lifebloom All",
                    },
                    TT = {
                        enUS = "Allow Lifebloom to be applied to all party/raid members.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ConvokeLowMana",
                    DBV = false,
                    L = { 
                        enUS = "Use Convoke Low Mana",
                    },
                    TT = {
                        enUS = "Use Convoke with Master Shapeshifter to regen mana when <30%.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "InnervateFriend",
                    DBV = false,
                    L = { 
                        enUS = "Allow Innervate Friend",
                    },
                    TT = {
                        enUS = "Allow innerate friend if big healing needed and they have <50% mana and less then us.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AutoSpreadSlider",
                    DBV = 75,
                    ONLYOFF = true,
                    L = {
                        ANY = "Auto Spread Mana Slider (%)"
                    },
                    TT = {
                        ANY = ""
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "EmergencySlider",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Emergency (%)"
                    },
                    TT = {
                        ANY = "Unit HP (%) to leave our Cat/Moonkin Form"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto",            value = "Auto" },
                        { text = "Rejuvenation",    value = "Rejuvenation" },
                        { text = "Regrowth",        value = "Regrowth" },
                        { text = "Wild Growth",     value = "WildGrowth" },
                    },
                    DB = "SoutFDropdown",
                    DBV = "Auto",
                    L = {
                        ANY = "Soul of the Forest Mode",
                    },
                    TT = {
                        enUS = "Choose how you want to handle Soul of the Forest Buff"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Expiring Hots",   value = "1" },
                        { text = "Agressive",        value = "2" },
                    },
                    DB = "SwiftmendDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Swiftmend Mode",
                    },
                    TT = {
                        enUS = "Choose how you want to handle Swiftmend without Verdant Infusion Talent"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Lowest Max HP", value = "1" },
                        { text = "Tank", value = "2" },
                        { text = "Manual", value = "3" },
                    },
                    DB = "symbioticRelationship",
                    DBV = "1",
                    L = { 
                        ANY = "Symbiotic Relationship", 
                    }, 
                    TT = { 
                        ANY = "Choose target for Symbiotic Relationship.\nDue to long cast time, this probably will be set-and-forget and won't swap targets mid-combat.", 
                    }, 
                    M = {},                                    
                },  
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Refresh Sunfire + Moonfire",                          value = "1" },
                        { text = "Refresh Sunfire",                                     value = "2" },
                        { text = "Refresh Moonfire",                                    value = "3" },
                        { text = "Refresh Sunfire + Moonfire out of Melee Range",       value = "4" },
                        { text = "Refresh Sunfire out of Melee Range",                  value = "5" },
                        { text = "Refresh Moonfire out of Melee Range",                 value = "6" },
                        { text = "No Refresh in Catform",                               value = "7" },
                        { text = "Catweaving disabled",                                 value = "8" },
                    },
                    DB = "DotRefreshDropdown",
                    DBV = "1",
                    L = {
                        ANY = "Catweaving + Dot Refreshing Mode",
                    },
                    TT = {
                        enUS = "Choose how you want to handle Catweaving"
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
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Barkskin (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Barkskin"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 30,
                    ONLYOFF = true,
                    L = {
                        ANY = "Renewal (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Renewal"
                    },
                    M = {},
                },
			},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Bear Form (%)"
                    },
                    TT = {
                        ANY = "Player HP % to switch in Bear Form"
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
                    E = "Checkbox",
                    DB = "LeaveCatBearForm",
                    DBV = false,
                    L = { 
                        enUS = "Leave Forms out of Range",
                    },
                    TT = {
                        enUS = "If enbaled we will leave Cat and Bear Form when our target is out of range",
                    },
                    M = {},
                },
            },
            {
                { -- Automatic Interrupt
                    E = "Checkbox", 
                    DB = "testWG",
                    DBV = true,
                    L = { 
                        ANY = "Force WG after Swift Mend in Raid",
                    }, 
                    TT = { 
                        ANY = "Will Force WG after Swift Mend in Raid regardless of other settings",
                    }, 
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Ramp Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "rampRejuv",
                    DBV = true,
                    L = { 
                        enUS = "Use Rejuv",
                    },
                    TT = {
                        enUS = "Use Rejuv in Ramp",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "rampWildGrowth",
                    DBV = true,
                    L = { 
                        enUS = "Use Wild Growth",
                    },
                    TT = {
                        enUS = "Use Wild Growth in Ramp",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "rampGuardians",
                    DBV = true,
                    L = { 
                        enUS = "Use Grove Guardians",
                    },
                    TT = {
                        enUS = "Use Grove Guardians in Ramp",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "rampConvoke",
                    DBV = true,
                    L = { 
                        enUS = "Use Convoke the Spirits",
                    },
                    TT = {
                        enUS = "Use Convoke the Spirits in Ramp",
                    },
                    M = {},
                },
            },
        },
        [ACTION_CONST_DRUID_BALANCE] = { 
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
                { -- mouseover
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = false,
                    L = { 
                        ANY = "Mouseover",
                    }, 
                    TT = { 
                        ANY = "Use spells in Mouseover",
                    }, 
                    M = {},
                },
            },
            {
                { -- autoShift
                    E = "Checkbox", 
                    DB = "autoShift",
                    DBV = true,
                    L = { 
                        ANY = "Automatically Shapeshift",
                    }, 
                    TT = { 
                        ANY = "Automatically shapeshift to Moonkin for and also out of roots.",
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Moonkin Form", value = 1 },
                        { text = "Bear Form", value = 2 },
                    },
                    MULT = true,
                    DB = "autoForms",
                    DBV = {
                        [1] = true,
                        [2] = true,
                    },  
                    L = { 
                        ANY = "Forms for Auto Shapeshift", 
                    }, 
                    TT = { 
                        ANY = "Choose what forms you want to shapeshift into.", 
                    }, 
                    M = {},                                    
                },
            },
            {
                { -- autoShift
                    E = "Checkbox", 
                    DB = "stayInBear",
                    DBV = false,
                    L = { 
                        ANY = "Stay In Bear Form",
                    }, 
                    TT = { 
                        ANY = "Only enable this if you want to manually leave bear form.\nUseful for preempting big damage with Bear Form in higher keys.",
                    }, 
                    M = {},
                },
                { -- autoShift
                    E = "Checkbox", 
                    DB = "dontBreakStealth",
                    DBV = false,
                    L = { 
                        ANY = "Don't Break Stealth",
                    }, 
                    TT = { 
                        ANY = "Enable this to pause the rotation when stealthed.",
                    }, 
                    M = {},
                },
            },
            {
                { -- lycarasBlessing
                    E = "Checkbox", 
                    DB = "lycarasMeditation",
                    DBV = false,
                    L = { 
                        ANY = "Pre-Form Lycaras Meditation",
                    }, 
                    TT = { 
                        ANY = "Start fights in bear form when Lycara's Meditation + Fluid Form are learned for bonus versatility at the start of a fight.",
                    }, 
                    M = {},
                },
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "autoDOT",
                    DBV = false,
                    L = { 
                        ANY = "Auto DoT",
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to cast Moonfire on everything in combat.",
                    }, 
                    M = {},
                },
			},
            {
                { -- autoDOT
                    E = "Checkbox", 
                    DB = "poolAsp",
                    DBV = false,
                    L = { 
                        ANY = "Pool Astral Power",
                    }, 
                    TT = { 
                        ANY = "Stop spending Astral Power unless about to cap.",
                    }, 
                    M = {},
                },
            },
            { 
                {-- maxMoonfire
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 15,                            
                    DB = "maxMoonfire",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = "Maximum Moonfires",
                    },
                    TT = { 
                        ANY = "Maximum amount of Moonfires allowed for Auto DoT\n(will stop trying to spread Moonfire when total amount of active Moonfires reaches this number).", 
                    },                     
                    M = {},
                },
                {-- maxSunfire
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 15,                            
                    DB = "maxSunfire",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = "Maximum Sunfires",
                    },
                    TT = { 
                        ANY = "Maximum amount of Sunfires allowed for Auto DoT\n(will stop trying to spread Sunfire when total amount of active Sunfires reaches this number).", 
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
                { -- DoTs while moving
                    E = "Checkbox", 
                    DB = "dotsMoving",
                    DBV = true,
                    L = { 
                        ANY = "Refresh DoTs while moving",
                    }, 
                    TT = { 
                        ANY = "Refresh Sunfire/Moonfire while moving when you have nothing else to press.",
                    }, 
                    M = {},
                },		
                { -- Res
                    E = "Checkbox", 
                    DB = "mouseoverRes",
                    DBV = true,
                    L = { 
                        ANY = "Revive/Rebirth Mouseover",
                    }, 
                    TT = { 
                        ANY = "Use Revive/Rebirth on dead mouseover.",
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
                { -- Res
                    E = "Checkbox", 
                    DB = "syncFoECA", 
                    DBV = false,
                    L = { 
                        ANY = "Hold CA/Inc for Fury of Elune",
                    }, 
                    TT = { 
                        ANY = "Wait until Fury of Elune is ready before using CA/Inc.",
                    }, 
                    M = {},
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
                { -- Res
                    E = "Checkbox", 
                    DB = "bypassBurstRaid",
                    DBV = false,
                    L = { 
                        ANY = "Bypass Raid Logic Burst Settings (Experimental)",
                    }, 
                    TT = { 
                        ANY = "Quick fix until trip is back",
                    }, 
                    M = {},
                },	
            },
            {
                {
                    E = "Dropdown",                                                         
                    H = 20,
                    OT = {
                        { text = "Celestial Alignment / Incarnation", value = 1 },
                        { text = "Convoke the Spirits", value = 2 },
                        { text = "Warrior of Elune", value = 3 },
                        { text = "Force of Nature", value = 4 },
                        { text = "Fury of Elune", value = 5 },
                    },
                    MULT = true,
                    DB = "cooldownUsage",
                    DBV = {
                        [1] = true,
                        [2] = true,
                        [3] = true,
                        [4] = true,
                        [5] = true,
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
            { -- CLEANSE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVES ====== ",
                    },
                },
            },
            {
                { -- BarkskinHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "BarkskinHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Barkskin HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Barkskin.", 
                    },                     
                    M = {},
                },	
                { -- RenewalHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RenewalHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Renewal HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Renewal.", 
                    },                     
                    M = {},
                },	
            },
            {
                { -- RenewalHP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "frenziedRegenHP",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Frenzied Regeneration HP (%)",
                    },
                    TT = { 
                        ANY = "HP (%) to use Frenzied Regeneration (must be in Bear Form).", 
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
                        ANY = " ====== PVP ====== ",
                    },
                },
            },
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "fakeCasting",
                    DBV = true,
                    L = { 
                        ANY = "Fakecasting",
                    }, 
                    TT = { 
                        ANY = "Enable Fakecasting in arena. Requires Stopcasting to be bound.",
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
                        { text = "Force of Nature", value = 1 },
                        { text = "Cyclone", value = 2 },
                        { text = "Mighty Bash", value = 3 },
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
                { -- Debug
                    E = "Checkbox", 
                    DB = "makAwareArena",
                    DBV = false,
                    L = { 
                        ANY = "Enable aware messages in arena",
                    }, 
                    TT = { 
                        ANY = "Show messages in arena when doing things like cyclone.",
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
                        ANY = " ====== RAMP OPTIONS ====== ",
                    },
                },
            },
            {
                { -- Debug
                    E = "Checkbox", 
                    DB = "rampWildGrowth",
                    DBV = false,
                    L = { 
                        ANY = "Wild Growth",
                    }, 
                    TT = { 
                        ANY = "Use Wild Growth in ramp mode.",
                    }, 
                    M = {},
                },
                { -- Debug
                    E = "Checkbox", 
                    DB = "rampRejuv",
                    DBV = false,
                    L = { 
                        ANY = "Wild Growth",
                    }, 
                    TT = { 
                        ANY = "Use Wild Growth in ramp mode.",
                    }, 
                    M = {},
                },
                { -- Debug
                    E = "Checkbox", 
                    DB = "rampConvoke",
                    DBV = false,
                    L = { 
                        ANY = "Convoke the Spirits",
                    }, 
                    TT = { 
                        ANY = "Use Convoke the Spirits in ramp mode.",
                    }, 
                    M = {},
                },
                { -- Debug
                    E = "Checkbox", 
                    DB = "rampGuardians",
                    DBV = false,
                    L = { 
                        ANY = "Grove Guardians",
                    }, 
                    TT = { 
                        ANY = "Use Grove Guardians in ramp mode.",
                    }, 
                    M = {},
                },
            },    
        },
        [ACTION_CONST_DRUID_GUARDIAN] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Guardian Druid ======",
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
                { -- mouseover
                    E = "Checkbox",
                    DB = "mouseover",
                    DBV = false,
                    L = {
                        ANY = "Mouseover",
                    },
                    TT = {
                        ANY = "Use spells in Mouseover",
                    },
                    M = {},
                },
            },
            {
                { -- AutoTaunt
                    E = "Checkbox",
                    DB = "AutoTaunt",
                    DBV = false,
                    L = {
                        ANY = "Auto Taunt",
                    },
                    TT = {
                        ANY = "Automatically Taunt enemies that are not targeting you (dungeon content only).",
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
                { -- Res
                    E = "Checkbox", 
                    DB = "mouseoverRes",
                    DBV = true,
                    L = { 
                        ANY = "Revive/Rebirth Mouseover",
                    }, 
                    TT = { 
                        ANY = "Use Revive/Rebirth on dead mouseover.",
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
                { -- FRegenHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "FRegenHP",
                    DBV = 65,
                    ONOFF = false,
                    L = {
                        ANY = "Frenzied Regeneration HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Frenzied Regeneration.",
                    },
                    M = {},
                },
                { -- RenewalHP
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "RenewalHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Renewal HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Renewal.",
                    },
                    M = {},
                },
            },
            {
                { -- SurvivalInstincts
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "survHP",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Survival Instincts HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use Survival Instincts (value set low because this is handled automatically per dungeon encounter).",
                    },
                    M = {},
                },
                { -- Dream of Cenarius
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "docRegrowth",
                    DBV = 80,
                    ONOFF = false,
                    L = {
                        ANY = "Dream of Cenarius HP (%)",
                    },
                    TT = {
                        ANY = "HP (%) to use the Regrowth proc from Dream of Cenarius.",
                    },
                    M = {},
                },
            }
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- TRINKETS HEADER
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
        },          
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {},
    },
}
