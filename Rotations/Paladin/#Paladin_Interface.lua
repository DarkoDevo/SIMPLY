local Action = _G.Action

local A                = Action

local CONST                                                              = Action.Const
 
A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "TWW Season 2 (27 March 2025",
    [2] = {
        [ACTION_CONST_PALADIN_HOLY] = {
            {
                {
                    E = "Checkbox", 
                    DB = "Iconbar1",
                    DBV = false,
                    L = { 
                        ANY = "Qeuebar", 
                    }, 
                    TT = { 
                        ANY = "Choose whether you want to display an bar to queue and block cooldowns", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Iconbar2",
                    DBV = false,
                    L = {
                        ANY = "Presettings",
                    },
                    TT = {
                        ANY = "Choose whether you want to display an bar with presettings for M+ | Raids | Pvp - It's editable!",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SetupHealingTab",
                    DBV = true,
                    L = {
                        ANY = "Auto Setup",
                    },
                    TT = {
                        ANY = "If enabled, we will Auto setup the 'Healing System' Tab in action to our prefered values",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        ANY = "Use AoE",
                    },
                    TT = {
                        ANY = "As healer, we use it to toggle our Aoe Healing Spells like 'Wild Growth' - 'Essence Font' - 'Prayer of Healing' etc ",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "oorTarget",
                    DBV = true,
                    L = {
                        ANY = "Target Out of Range",
                    },
                    TT = {
                        ANY = "Automatically swap target to the nearest enemy if your current target is out of range.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "mouseoverRes",
                    DBV = false,
                    L = {
                        ANY = "Mouseover Resurrect",
                    },
                    TT = {
                        ANY = "Resurrect when mouseover on dead friendly unit (battle res in combat only, regular res out of combat [Absolution doesn't require mouseover on Holy]).",
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
                    DBV = 1,
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
                    DB = "HolyShockSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Shock (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Holy Shock"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WOGSlider",
                    DBV = 100,
                    ONOFF = true,
                    L = {
                        ANY = "Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "InfusionSlider",
                    DBV = 80,
                    ONOFF = true,
                    L = {
                        ANY = "Infusion of Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to use Infusion of Light"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "HolyLightSlider",
                    DBV = -1,
                    ONOFF = true,
                    L = {
                        ANY = "Holy Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to hard cast Holy Light"
                    },
                    M = {},
                },                
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FlashofLightSlider",
                    DBV = 35,
                    ONOFF = true,
                    L = {
                        ANY = "Flash of Light (%)"
                    },
                    TT = {
                        ANY = "Target HP % to hard cast Flash of Light"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "AvengingCrusaderSlider",
                    DBV = 75,
                    ONOFF = true,
                    L = {
                        ANY = "Avenging Crusader (%)"
                    },
                    TT = {
                        ANY = "Target HP % to cast Avenging Crusader"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
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
                {
                    E = "Checkbox",
                    DB = "ForceDps",
                    DBV = true,
                    L = {
                        ANY = "Force Dps",
                    },
                    TT = {
                        ANY = "If enabled, we will force the usage of Consecration & Hammer of Wrath",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "CrusdersMightBox",
                    DBV = false,
                    L = {
                        ANY = "Crusders Might",
                    },
                    TT = {
                        ANY = "If enabled, we will only use Crusader Strike to reduce the cooldown of Holy Shock",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "BoFPlayer",
                    DBV = false,
                    L = {
                        ANY = "Blessing of Freedom @Player",
                    },
                    TT = {
                        ANY = "If enabled, we will use Blessing of Freedom voa @player macro when we are rooted",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        ANY = "Beacon of Faith @Player",
                    },
                    TT = {
                        ANY = "If enbaled, we will use Beacon of Faith on us - useful in Dungeons",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox3",
                    DBV = false,
                    L = { 
                        ANY = "Consume Infusion asap",
                    },
                    TT = {
                        ANY = "If enabled, we will consume Infusion of Light Buff as soon as possible",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "JudgmentHeal",
                    DBV = false,
                    L = { 
                        ANY = "Judgment Heal",
                    },
                    TT = {
                        ANY = "If enabled, we will track group health and use Judgment while Avenging Crusader only when we need heal",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "StopJudgment15",
                    DBV = false,
                    L = {
                        ANY = "Judgment at 15 Awakening stacks only",
                    },
                    TT = {
                        ANY = "If enabled, only cast Judgment when Awakening stacks are exactly 15.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "DontConsumeHP",
                    DBV = false,
                    L = { 
                        ANY = "Not consuming HP (Beta)",
                    },
                    TT = {
                        ANY = "If enabled, we will not consume Holy Power when aOE is incoming",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "aggroDps",
                    DBV = true,
                    L = {
                        ANY = "Aggressive DPS",
                    },
                    TT = {
                        ANY = "Use Shield of the Righteous at 3 or more Holy Power when nothing else left to do.\nDisabling this option will let you pool until 5 Holy Power in case someone takes damage in the meantime.",
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
                    DB = "AvoidLoDSlider",
                    DBV = 35,
                    ONOFF = true,
                    L = {
                        ANY = "Light of Dawn Treshold (%)"
                    },
                    TT = {
                        ANY = "Target HP % must be greater as Slider to use LoD in Auto Mode"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Heal only", value = "2" },
                        { text = "Dps only", value = "3" },
                        { text = "Dps when 2 charges", value = "4" },
                    },
                    DB = "HSMenu",
                    DBV = "1",
                    L = {
                        ANY = "Holy Shock Mode",
                    },
                    TT = {
                        ANY = ""
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "Auto" },
                        { text = "Always", value = "Always" },
                        { text = "Unending Light", value = "UL" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "Dropdown2",
                    DBV = "Off",
                    L = {
                        ANY = "Light of Dawn Mode",
                    },
                    TT = {
                        ANY = "Description:\nAuto = will use it in AoE Scenarios \nAlways = Will use it always when its ready\nUnending Light = Will use it only when you have 9 stacks of Unending Light\nOff = Will not use it"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Flash of Light", value = "FlashofLight" },
                        { text = "Holy Light", value = "HolyLight" },
                        { text = "Judgment", value = "Judgment" },
                    },
                    DB = "Dropdown5",
                    DBV = "Judgment",
                    L = {
                        ANY = "Infusion of Light",
                    },
                    TT = {
                        ANY = ""
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Flash of Light", value = "1" },
                        { text = "Holy Light", value = "2" },
                        { text = "Holy Light + Infusion", value = "4" },
                        { text = "No additional logic", value = "3" },
                    },
                    DB = "DivineFavorMenu",
                    DBV = "3",
                    L = {
                        ANY = "Divine Favor Consumer",
                    },
                    TT = {
                        ANY = ""
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Light of Dawn", value = "1" },
                        { text = "Shield of the Righteous", value = "2" },
                        { text = "Word of Glory", value = "3" },
                        { text = "Light of Dawn with Mana check", value = "4" },
                        { text = "Shield of the Righteous with Mana check", value = "5" },
                        { text = "Word of Glory with Mana check", value = "6" },
                        { text = "Off", value = "7" },
                    },
                    DB = "HolyPowerConsumer",
                    DBV = "5",
                    L = {
                        ANY = "Holy Power Consumer",
                    },
                    TT = {
                        ANY = "Choose, which spell you want to use as Holy Power consumer - with mana check means that we dont use any consumer as soon we are below mana treshold slider"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = "1" },
                        { text = "Heal only", value = "2" },
                        { text = "Dps only", value = "3" },
                    },
                    DB = "DtMenu",
                    DBV = "1",
                    L = {
                        ANY = "Divine Toll Mode",
                    },
                    TT = {
                        ANY = "Use /cast Divine Toll and bind it to Regeneratin if you want to use it offensively"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 1,
                    MAX = 10,
                    DB = "DivineTollSlider",
                    DBV = 3,
                    ONLYOFF = false,
                    L = {
                        ANY = "Divine Toll Enemies"
                    },
                    TT = {
                        ANY = "How many enemies around you should be there to use Divine Toll for damage"
                    },
                    M = {},
                },     
            },
            { { E = "LayoutSpace", },},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Divine Protection (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Protection"
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
                        ANY = "Divine Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Shield"
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
                    E = "Checkbox",
                    DB = "OOCHeal",
                    DBV = true,
                    L = { 
                        ANY = "OOC Healing",
                    },
                    TT = {
                        ANY = "If enbaled we will use out of combat healing logic beside of sliders",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "PrepareTeamBox",
                    DBV = true,
                    L = { 
                        ANY = "Precast Beacon of Virtue",
                    },
                    TT = {
                        ANY = "If enbaled we will precast Beacon of Virtue",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "VirtueSynch",
                    DBV = true,
                    L = { 
                        ANY = "Virtue Synch",
                    },
                    TT = {
                        ANY = "If enbaled we use Holy Prism and Divine Toll Heal only with Virtue Buff",
                    },
                    M = {},
                },
            },
        },
        [ACTION_CONST_PALADIN_PROTECTION] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Protection Paladin ====== ",
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
                        ANY = "Use AoE",
                        ruRU = "Использовать AoE",
                        frFR = "Utiliser l'AoE",
                    },
                    TT = {
                        ANY = "Enable multiunits actions",
                        ruRU = "Включает действия для нескольких целей",
                        frFR = "Activer les actions multi-unités",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = {
                        ANY = "Only Cast While Staying",
                    },
                    TT = {
                        ANY = "Only cast movement-sensitive spells when the player is not moving",
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
                        ANY = "Auto Target",
                    },
                    TT = {
                        ANY = "Taunt, Multi-Dot, Interrupt, etc.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "autotaunt",
                    DBV = true,
                    L = {
                        ANY = "Auto Taunt (Non-Raid)",
                    },
                    TT = {
                        ANY = "Auto Taunt in non-raid environments",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "multidot",
                    DBV = true,
                    L = {
                        ANY = "Auto Target for Multi-Dot",
                    },
                    TT = {
                        ANY = "Auto swap targets for multi-dot.",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "targetmelee",
                    DBV = true,
                    L = {
                        ANY = "Auto Target Melee",
                    },
                    TT = {
                        ANY = "Auto swap targets for malee targeting.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "mouseoverRes",
                    DBV = false,
                    L = {
                        ANY = "Mouseover Resurrect",
                    },
                    TT = {
                        ANY = "Resurrect when mouseover on dead friendly unit (battle res in combat only, regular res out of combat).",
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
                        ANY = "Enable DBM Intigration",
                    },
                    TT = {
                        ANY = "Will use DBM timers for smart defensive usage.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "asonCD",
                    DBV = false,
                    L = {
                        ANY = "Avengers Shield CD",
                    },
                    TT = {
                        ANY = "Will use Avengers Shield on Cooldown incombat.",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "lohDebounce",
                    DBV = true,
                    L = {
                        ANY = "Slow Down LoH",
                    },
                    TT = {
                        ANY = "Delay LoH SLIGHTLY for not so crazy reaction speed.",
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
                        ANY = "====== BURST ======",
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
                E = "Checkbox",
                DB = "firebloodDef",
                DBV = true,
                L = {
                    ANY = "Fireblood Defensive",
                },
                TT = {
                    ANY = "Only use Fireblood defensively to clear bleeds.",
                },
                M = {},
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "WoGHPFree",
                    DBV = 65,
                    ONOFF = false,
                    L = {
                        ANY = "WoG Free HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "WoGHP",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "WoG HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DivineShieldHP",
                    DBV = 25,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Shield HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "ArdentDefenderHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Ardent Defender HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Ardent Defender"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "GuardianHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Guardian HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Guardian of Ancient Kings"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Word of Glory Defensive HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory for emergency self-healing"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Ardent Defender HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Ardent Defender (overrides existing ArdentDefenderHP)"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Guardian of Ancient Kings HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Guardian of Ancient Kings (overrides existing GuardianHP)"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Shield HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Shield (overrides existing DivineShieldHP)"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SelfProtection5",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Lay on Hands HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Lay on Hands for emergency self-healing"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "WoGFreePlayer",
                    DBV = 65,
                    ONOFF = false,
                    L = {
                        ANY = "Word of Glory Freecast HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory when Divine Purpose proc is active"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== DEFENSIVE COOLDOWN OPTIONS ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "defensiveSelect1",
                    DBV = true,
                    L = {
                        ANY = "Use Ardent Defender",
                    },
                    TT = {
                        ANY = "Enable Ardent Defender in defensive rotation",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "defensiveSelect2",
                    DBV = true,
                    L = {
                        ANY = "Use Guardian of Ancient Kings",
                    },
                    TT = {
                        ANY = "Enable Guardian of Ancient Kings in defensive rotation",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "defensiveSelect3",
                    DBV = true,
                    L = {
                        ANY = "Use Avenging Wrath/Sentinel",
                    },
                    TT = {
                        ANY = "Enable Avenging Wrath and Sentinel in defensive rotation",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PARTY DEFENSIVES ====== ",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "PartyWoGHPFree",
                    DBV = 0,
                    ONOFF = false,
                    L = {
                        ANY = "WoG Free HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "PartyWoGHP",
                    DBV = 0,
                    ONOFF = false,
                    L = {
                        ANY = "WoG HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "PartyLoHHP",
                    DBV = 0,
                    ONOFF = false,
                    L = {
                        ANY = "LoH HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Lay on Hands"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "PartyBoPHP",
                    DBV = 0,
                    ONOFF = false,
                    L = {
                        ANY = "BoP HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Protection"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PARTY UTILITY (M+/Arena) ====== ",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BopHPParty",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Protection HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Protection on party members (physical damage protection)"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SpellwardHPParty",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Spellwarding HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Spellwarding on party members (magic damage protection)"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "LayonHandsHPParty",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Lay on Hands Party HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Lay on Hands on party members (emergency healing)"
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "BlessingofSanctuaryEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Blessing of Sanctuary",
                    },
                    TT = {
                        ANY = "Enable automatic Blessing of Sanctuary for CC protection on party members",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "BlessingofFreedomEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Blessing of Freedom",
                    },
                    TT = {
                        ANY = "Enable automatic Blessing of Freedom for root/beam removal on party members",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "BlessingofSpellwardingEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Blessing of Spellwarding",
                    },
                    TT = {
                        ANY = "Enable automatic Blessing of Spellwarding for magic damage protection on party members",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PvP Settings (Arena/BG) ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "DivineProtectionEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Divine Protection",
                    },
                    TT = {
                        ANY = "Enable automatic Divine Protection for damage reduction in PvP",
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DivineProtectionHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Protection HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Protection in PvP"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "ShieldofVengeanceEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Shield of Vengeance",
                    },
                    TT = {
                        ANY = "Enable automatic Shield of Vengeance for proactive absorb shield in PvP",
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "ShieldofVengeanceHP",
                    DBV = 70,
                    ONOFF = false,
                    L = {
                        ANY = "Shield of Vengeance HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Shield of Vengeance in PvP"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "DivineSteedEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Divine Steed",
                    },
                    TT = {
                        ANY = "Enable automatic Divine Steed for kiting/mobility in PvP",
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DivineSteedHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Steed HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Steed for kiting in PvP"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "HammerofJusticeEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Hammer of Justice",
                    },
                    TT = {
                        ANY = "Enable smart Hammer of Justice CC in PvP",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    DB = "HammerofJusticeMode",
                    DBV = "Smart",
                    L = {
                        ANY = "Hammer of Justice Mode"
                    },
                    TT = {
                        ANY = "Smart: Auto-detect offensive/defensive | Offensive: CC healer during burst | Defensive: Peel for low HP | Manual: Disabled"
                    },
                    OT = {
                        { text = "Smart", value = "Smart" },
                        { text = "Offensive", value = "Offensive" },
                        { text = "Defensive", value = "Defensive" },
                        { text = "Manual", value = "Manual" },
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "HammerofJusticeDefensiveHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "HoJ Defensive HP (%)"
                    },
                    TT = {
                        ANY = "HP % threshold for defensive Hammer of Justice usage"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "BlindingLightEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Blinding Light",
                    },
                    TT = {
                        ANY = "Enable smart Blinding Light CC in PvP",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    DB = "BlindingLightMode",
                    DBV = "Smart",
                    L = {
                        ANY = "Blinding Light Mode"
                    },
                    TT = {
                        ANY = "Smart: Auto-detect offensive/defensive | Offensive: Blind during burst | Defensive: Disrupt casts | Manual: Disabled"
                    },
                    OT = {
                        { text = "Smart", value = "Smart" },
                        { text = "Offensive", value = "Offensive" },
                        { text = "Defensive", value = "Defensive" },
                        { text = "Manual", value = "Manual" },
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BlindingLightDefensiveHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Blinding Light Defensive HP (%)"
                    },
                    TT = {
                        ANY = "HP % threshold for defensive Blinding Light usage"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    DB = "BlessingofSanctuaryPriority",
                    DBV = "SmartPriority",
                    L = {
                        ANY = "Blessing of Sanctuary Priority"
                    },
                    TT = {
                        ANY = "SmartPriority: Healers > Casters | HealersOnly: Only protect healer | UseWhenAvailable: Use on anyone"
                    },
                    OT = {
                        { text = "Smart Priority", value = "SmartPriority" },
                        { text = "Healers Only", value = "HealersOnly" },
                        { text = "Use When Available", value = "UseWhenAvailable" },
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DivineShieldHPPvP",
                    DBV = 25,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Shield HP (PvP) (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Shield in PvP (emergency threshold)"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BoPHPSelf",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Protection HP (Self) (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Protection on self in PvP"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Aura Management ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "AuraManagementEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Automatic Aura Switching",
                    },
                    TT = {
                        ANY = "Enable smart aura switching based on combat state and situational needs",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "ConcentrationAuraEnabled",
                    DBV = true,
                    L = {
                        ANY = "Use Concentration Aura in PvP",
                    },
                    TT = {
                        ANY = "Switch to Concentration Aura in PvP for interrupt protection",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "CrusaderAuraEnabled",
                    DBV = true,
                    L = {
                        ANY = "Use Crusader Aura Out of Combat",
                    },
                    TT = {
                        ANY = "Switch to Crusader Aura when moving out of combat for speed",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Rite Abilities (Weapon Enchants) ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "RiteManagementEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Automatic Rite Management",
                    },
                    TT = {
                        ANY = "Enable automatic weapon enchant reapplication when out of combat",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "RiteofSanctificationEnabled",
                    DBV = true,
                    L = {
                        ANY = "Use Rite of Sanctification",
                    },
                    TT = {
                        ANY = "Rite of Sanctification: +5% armor, +2% Strength (primary stat)",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "RiteofAdjurationEnabled",
                    DBV = false,
                    L = {
                        ANY = "Use Rite of Adjuration",
                    },
                    TT = {
                        ANY = "Rite of Adjuration: +5% armor, +2% Stamina (alternative to Sanctification)",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Holy Armaments (Holy Bulwark & Sacred Weapon) ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "HolyBulwarkEnabled",
                    DBV = true,
                    L = {
                        ANY = "Use Holy Bulwark (Defensive)",
                    },
                    TT = {
                        ANY = "Enable Holy Bulwark for defensive shielding on self and party members",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "SacredWeaponEnabled",
                    DBV = true,
                    L = {
                        ANY = "Use Sacred Weapon (Offensive)",
                    },
                    TT = {
                        ANY = "Enable Sacred Weapon for damage output during burst windows",
                    },
                    M = {},
                },
            },
        },
        [ACTION_CONST_PALADIN_RETRIBUTION] = {
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Makulu - Retribution Paladin ====== ",
                    },
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
                {
                    E = "Checkbox",
                    DB = "oorTarget",
                    DBV = true,
                    L = {
                        ANY = "Target Out of Range",
                    },
                    TT = {
                        ANY = "Automatically swap target to the nearest enemy if your current target is out of range.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "mouseoverRes",
                    DBV = false,
                    L = {
                        ANY = "Mouseover Resurrect",
                    },
                    TT = {
                        ANY = "Resurrect when mouseover on dead friendly unit (battle res in combat only, regular res out of combat).",
                    }, 
                    M = {},
                },
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
            },
            {
                {
                    E = "Slider",
                    MIN = 2,
                    MAX = 30,
                    DB = "divineTollRange",
                    DBV = 5,
                    ONOFF = false,
                    L = {
                        ANY = "Range to target to use divine toll"
                    },
                    TT = {
                        ANY = "Range between player and target at which we will use divine toll"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Personal Defensives ====== ",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "DivineShieldHP",
                    DBV = 40,
                    ONOFF = false,
                    L = {
                        ANY = "Divine Shield HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Divine Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "FlashLightHP",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Flash of Light (%)"
                    },
                    TT = {
                        ANY = "HP % to use Flash of Light on Player"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "WogHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Word of Glory HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory on Player"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BopHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Protection (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Protection on Player"
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "BopTankMouseover",
                    DBV = false,
                    L = {
                        ANY = "Allow BOP on Tank (Mouseover)"
                    },
                    TT = {
                        ANY = "When enabled, allows casting Blessing of Protection on tanks via mouseover for emergency situations. When disabled (default), tanks are excluded from ALL BOP casting including mouseover. This prevents accidental BOP on tanks during normal rotation."
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "EFHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Eternal Flame (%)"
                    },
                    TT = {
                        ANY = "HP % to Eternal Flame on Player"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "LohHP",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Lay on Hands (%)"
                    },
                    TT = {
                        ANY = "HP % to use Lay on Hands on Player"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== Party Utility (M+/Arena) ====== ",
                    },
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "FlashLightHPParty",
                    DBV = 50,
                    ONOFF = false,
                    L = {
                        ANY = "Flash of Light (%)"
                    },
                    TT = {
                        ANY = "HP % to use Flash of Light"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "WogHPParty",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Word of Glory HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Word of Glory on Party"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "EFHPParty",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Eternal Flame (%)"
                    },
                    TT = {
                        ANY = "HP % to use Eternal Flame on Party"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "BopHPParty",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Protection (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Protection on Party"
                    },
                    M = {},
                },
            },
            {                
                { -- Sac Tank
                    E = "Checkbox", 
                    DB = "sacTankOnly",
                    DBV = true,
                    L = { 
                        ANY = "Only Blessing of Sacrifice on Tank Buster",
                    }, 
                    TT = { 
                        ANY = "Only uses Blessing of Sacrifice on Tank for Tank Buster.",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "SacHP",
                    DBV = 60,
                    ONOFF = false,
                    L = {
                        ANY = "Blessing of Sacrifice HP (%)"
                    },
                    TT = {
                        ANY = "HP % to use Blessing of Sacrifice on Party"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = 0,
                    MAX = 100,
                    DB = "LohHPParty",
                    DBV = 30,
                    ONOFF = false,
                    L = {
                        ANY = "Lay on Hands (%)"
                    },
                    TT = {
                        ANY = "HP % to use Lay on Hands on Party"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " ====== PvP Settings (Arena/BG) ====== ",
                    },
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "BlessingofSanctuaryEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Blessing of Sanctuary",
                    },
                    TT = {
                        ANY = "Enable automatic Blessing of Sanctuary for CC protection on party members in PvP",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Healers Only", value = "HealersOnly" },
                        { text = "Smart Priority (Healers > Casters > Others)", value = "SmartPriority" },
                        { text = "Use When Available", value = "UseWhenAvailable" },
                    },
                    DB = "BlessingofSanctuaryPriority",
                    DBV = "SmartPriority",
                    L = {
                        ANY = "Blessing of Sanctuary Priority",
                    },
                    TT = {
                        ANY = "Choose how Blessing of Sanctuary is used in PvP:\n\nHealers Only - Save for healers only\nSmart Priority - Healers first, then casters/ranged DPS, then everyone else\nUse When Available - Use on any teammate when they are CC'd",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "SearingGlareEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Searing Glare",
                    },
                    TT = {
                        ANY = "Enable automatic Searing Glare usage in PvP to blind enemies and disrupt their attacks/casts",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Smart (Healers/Casters Priority)", value = "Smart" },
                        { text = "Interrupt Only (During Enemy Casts)", value = "Interrupt" },
                        { text = "Burst Windows (During Offensive CDs)", value = "Burst" },
                        { text = "Defensive (When Low HP)", value = "Defensive" },
                    },
                    DB = "SearingGlarePriority",
                    DBV = "Smart",
                    L = {
                        ANY = "Searing Glare Usage Mode",
                    },
                    TT = {
                        ANY = "Choose when to use Searing Glare:\n\nSmart - Prioritize healers/casters, use during enemy burst or important casts\nInterrupt Only - Only use to interrupt critical enemy casts\nBurst Windows - Use during your offensive cooldowns (Avenging Wrath/Crusade)\nDefensive - Use when you or teammates are low HP(<40%) to mitigate damage",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox",
                    DB = "RepentanceEnabled",
                    DBV = true,
                    L = {
                        ANY = "Enable Repentance",
                    },
                    TT = {
                        ANY = "Enable automatic Repentance usage in PvP to incapacitate enemies (30 sec CC, breaks on damage)",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Smart Priority (Offensive + Defensive)", value = "Smart" },
                        { text = "Offensive Only (CC Healer During Burst)", value = "Offensive" },
                        { text = "Defensive Only (Peel for Low HP Teammates)", value = "Defensive" },
                        { text = "Manual Only (Disabled)", value = "Manual" },
                    },
                    DB = "RepentanceUsageMode",
                    DBV = "Smart",
                    L = {
                        ANY = "Repentance Usage Mode",
                    },
                    TT = {
                        ANY = "Choose when to use Repentance:\n\nSmart Priority - Use offensively during burst windows AND defensively to peel for low HP teammates\nOffensive Only - Only CC enemy healer during your burst windows (Avenging Wrath/Crusade)\nDefensive Only - Only CC enemies attacking low HP teammates (<30%)\nManual Only - Disable automatic usage (manual control only)",
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = 10,
                    MAX = 50,
                    DB = "RepentanceDefensiveHP",
                    DBV = 30,
                    L = {
                        ANY = "Repentance Defensive HP Threshold (%)",
                    },
                    TT = {
                        ANY = "HP threshold for defensive Repentance usage. Will CC enemies attacking teammates below this HP percentage.",
                    },
                    M = {},
                },
            },
        },
    },
}

