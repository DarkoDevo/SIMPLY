--##########################
--#####    TFO-Hpal    #####
--##########################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener									= Action.Listener
local Create									= Action.Create
local GetToggle									= Action.GetToggle
local SetToggle									= Action.SetToggle
local GetGCD									= Action.GetGCD
local GetCurrentGCD								= Action.GetCurrentGCD
local GetPing									= Action.GetPing
local ShouldStop								= Action.ShouldStop
local BurstIsON									= Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local HealingEngine                           	= Action.HealingEngine
local AuraIsValid								= Action.AuraIsValid
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils										= Action.Utils
local TeamCache									= Action.TeamCache
local EnemyTeam									= Action.EnemyTeam
local FriendlyTeam								= Action.FriendlyTeam
local LoC										= Action.LossOfControl
local Player									= Action.Player
local Pet                                       = LibStub("PetLibrary")
local MultiUnits								= Action.MultiUnits
local UnitCooldown								= Action.UnitCooldown
local Unit										= Action.Unit
local IsUnitEnemy								= Action.IsUnitEnemy
local IsUnitFriendly							= Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs
--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture


Action[ACTION_CONST_PALADIN_HOLY] = {
		--Racial
        ArcaneTorrent				= Action.Create({ Type = "Spell", ID = 50613	}),
        BloodFury					= Action.Create({ Type = "Spell", ID = 20572	}),
        Fireblood					= Action.Create({ Type = "Spell", ID = 265221	}),
        AncestralCall				= Action.Create({ Type = "Spell", ID = 274738	}),
        Berserking					= Action.Create({ Type = "Spell", ID = 26297	}),
        ArcanePulse             	= Action.Create({ Type = "Spell", ID = 260364	}),
        QuakingPalm           		= Action.Create({ Type = "Spell", ID = 107079	}),
        Haymaker           			= Action.Create({ Type = "Spell", ID = 287712	}),
        BullRush           			= Action.Create({ Type = "Spell", ID = 255654	}),
        WarStomp        			= Action.Create({ Type = "Spell", ID = 20549	}),
        GiftofNaaru   				= Action.Create({ Type = "Spell", ID = 59544	}),
        Shadowmeld   				= Action.Create({ Type = "Spell", ID = 58984    }),
        Stoneform 					= Action.Create({ Type = "Spell", ID = 20594    }),
        BagofTricks					= Action.Create({ Type = "Spell", ID = 312411	}),
        WilloftheForsaken			= Action.Create({ Type = "Spell", ID = 7744		}),
        EscapeArtist				= Action.Create({ Type = "Spell", ID = 20589    }),
        EveryManforHimself			= Action.Create({ Type = "Spell", ID = 59752    }),
        LightsJudgment				= Action.Create({ Type = "Spell", ID = 255647   }),
        Regeneratin					= Action.Create({ Type = "Spell", ID = 291944   }),


        --Paladin
        AvengingWrath        = Action.Create({ Type = "Spell", ID = 31884    }),
        AvengingCrusader     = Action.Create({ Type = "Spell", ID = 216331    }),
        BlessingofFreedom    = Action.Create({ Type = "Spell", ID = 1044        }),
        BlessingofProtection = Action.Create({ Type = "Spell", ID = 1022, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        BlessingofSacrifice  = Action.Create({ Type = "Spell", ID = 6940, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        ConcentrationAura    = Action.Create({ Type = "Spell", ID = 317920    }),
        Consecration         = Action.Create({ Type = "Spell", ID = 26573    }),
        CrusaderAura         = Action.Create({ Type = "Spell", ID = 32223    }),
        CrusaderStrike       = Action.Create({ Type = "Spell", ID = 35395    }),
        DevotionAura         = Action.Create({ Type = "Spell", ID = 465        }),
        DivineShield         = Action.Create({ Type = "Spell", ID = 642        }),
        DivineSteed          = Action.Create({ Type = "Spell", ID = 190784    }),
        FlashofLight         = Action.Create({ Type = "Spell", ID = 19750, predictName = "FlashofLight", Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        Forbearance          = Action.Create({ Type = "Spell", ID = 25771   }),
        HammerofJustice      = Action.Create({ Type = "Spell", ID = 853        }),
        HammerofJusticeGreen = Action.Create({ Type = "SpellSingleColor", ID = 853, Color = "GREEN", Desc = "[1] CC", Hidden = true, Hidden = true, QueueForbidden = true }),
        HammerofWrath        = Action.Create({ Type = "Spell", ID = 24275    }),
        HandofReckoning      = Action.Create({ Type = "Spell", ID = 62124    }),
        Judgment             = Action.Create({ Type = "Spell", ID = 275773    }),
        LayOnHands           = Action.Create({ Type = "Spell", ID = 633, Texture = 1706, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        LayOnHandsWard       = Action.Create({ Type = "Spell", ID = 471195, Texture = 1706, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        Rebuke               = Action.Create({ Type = "Spell", ID = 96231        }),
        Redemption           = Action.Create({ Type = "Spell", ID = 7328        }),
        Repentance           = Action.Create({ Type = "Spell", ID = 20066   }),
        RetributionAura      = Action.Create({ Type = "Spell", ID = 183435    }),
        Seraphim             = Action.Create({ Type = "Spell", ID = 152262    }),
        TurnEvil             = Action.Create({ Type = "Spell", ID = 10326    }),

        --HOLY
        AuraMastery          = Action.Create({ Type = "Spell", ID = 31821    }),
        BarrierofFaith       = Action.Create({ Type = "Spell", ID = 148039   }),
        BarrierofFaithBuff   = Action.Create({ Type = "Spell", ID = 395180   }),
        BeaconofFaith        = Action.Create({ Type = "Spell", ID = 156910, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        BeaconofLight        = Action.Create({ Type = "Spell", ID = 53563, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        BeaconofVirtue       = Action.Create({ Type = "Spell", ID = 200025, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        BelssingofDawnBuff   = Action.Create({ Type = "Spell", ID = 385127   }),
        BlessingofAutumn     = Action.Create({ Type = "Spell", ID = 388010,  Texture = 328620, Macro = "/cast [@player] Blessing of Autumn" }),
        BlessingofDuskBuff   = Action.Create({ Type = "Spell", ID = 385126   }),
        BlessingofSpring     = Action.Create({ Type = "Spell", ID = 388013,  Texture = 328620, Macro = "/cast [@player] Blessing of Spring" }),
        BlessingofSummer     = Action.Create({ Type = "Spell", ID = 388007,  Texture = 328620, Macro = "/cast [@player] Blessing of Summer" }),
        BlessingofWinter     = Action.Create({ Type = "Spell", ID = 388011,  Texture = 328620, Macro = "/cast [@player] Blessing of Winter" }),
        BlindingLight        = Action.Create({ Type = "Spell", ID = 115750   }),
        Cleanse              = Action.Create({ Type = "Spell", ID = 4987     }),
        ConsecrationBuff     = Action.Create({ Type = "Spell", ID = 188370   }),
        DawnLightBuff        = Action.Create({ Type = "Spell", ID = 431522   }),
        DawnLightHeal        = Action.Create({ Type = "Spell", ID = 431381   }),
        Daybreak             = Action.Create({ Type = "Spell", ID = 414170   }),
        Denounce             = Action.Create({ Type = "Spell", ID = 2812     }),
        DivineFavor          = Action.Create({ Type = "Spell", ID = 210294   }),
        DivineProtection     = Action.Create({ Type = "Spell", ID = 498      }),
        DivinePurposeBuff    = Action.Create({ Type = "Spell", ID = 223819   }),
        DivineToll           = Action.Create({ Type = "Spell", ID = 375576   }),
        Entangling           = Action.Create({ Type = "Spell", ID = 408556   }),
        EternalFlame         = Action.Create({ Type = "Spell", ID = 156322, Texture = 315921, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        GlimmerofLightBuff   = Action.Create({ Type = "Spell", ID = 287280   }),
        HolyLight            = Action.Create({ Type = "Spell", ID = 82326, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        HolyPrism            = Action.Create({ Type = "Spell", ID = 114165, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        HolyShock            = Action.Create({ Type = "Spell", ID = 20473, Texture = 278147, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        HolyShockDmg         = Action.Create({ Type = "Spell", ID = 93402,  Texture = 278147     }),
        ImprovedCleanse      = Action.Create({ Type = "Spell", ID = 393024   }),
        InfusionofLight      = Action.Create({ Type = "Spell", ID = 53576    }),
        InfusionofLightBuff  = Action.Create({ Type = "Spell", ID = 54149    }),
        LightofDawn          = Action.Create({ Type = "Spell", ID = 85222, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        LightoftheMartyr     = Action.Create({ Type = "Spell", ID = 447985, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        LightoftheMartyrDebuff = Action.Create({ Type = "Spell", ID = 448005, Hidden = true }),
        RisingSunlightBuff   = Action.Create({ Type = "Spell", ID = 414204   }),
        SavedbytheLight      = Action.Create({ Type = "Spell", ID = 157131   }),
        SearingGlare         = Action.Create({ Type = "Spell", ID = 410126   }),
        ShieldofTheRighteous = Action.Create({ Type = "Spell", ID = 415091   }),
        StrengthofConviction = Action.Create({ Type = "Spell", ID = 379008   }),
        TyrsDeliverance      = Action.Create({ Type = "Spell", ID = 200652   }),
        Unworthy             = Action.Create({ Type = "Spell", ID = 414022   }),
        WordofGlory          = Action.Create({ Type = "Spell", ID = 85673, Texture = 315921, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        SwiftPursuit         = Action.Create({ Type = "Spell", ID = 418986   }),
        EmpyrealWard         = Action.Create({ Type = "Spell", ID = 387791   }),
        HandofDivinity       = Action.Create({ Type = "Spell", ID = 414273   }),
        BlessingofSpellwarding = Action.Create({ Type = "Spell", ID = 204018, Macro = "/cast [@target,help][@focus,help]spell:thisID" }),
        LightsRevocation     = Action.Create({ Type = "Spell", ID = 461854   }),
        SearingGlareDebuff   = Action.Create({ Type = "Spell", ID = 410201   }),


        CursedSpirit                    = Action.Create({ Type = "Spell", ID = 409465, Hidden = true   }),
        PoisonedSpirit                  = Action.Create({ Type = "Spell", ID = 409470, Hidden = true   }),
        DiseasedSpirit                  = Action.Create({ Type = "Spell", ID = 409472, Hidden = true   }),

        DivineGuidanceBuff      = Action.Create({ Type = "Spell", ID = 460822   }),
        HolyBulwark             = Action.Create({ Type = "Spell", ID = 432459   }),
        HolyBulwarkBuff         = Action.Create({ Type = "Spell", ID = 432496   }),
        RiteofSanctification     = Action.Create({ Type = "Spell", ID = 433568, Macro = "/cast spell:thisID\n/cast 16" }),
        RiteofSanctificationBuff = Action.Create({ Type = "Spell", ID = 433550   }),
        RiteofAdjuration         = Action.Create({ Type = "Spell", ID = 433583, Macro = "/cast spell:thisID\n/cast 16" }),
        RiteofAdjurationBuff     = Action.Create({ Type = "Spell", ID = 433584   }),
        SacredWeapon            = Action.Create({ Type = "Spell", ID = 432472   }),
        SacredWeaponBuff        = Action.Create({ Type = "Spell", ID = 432502   }),
        HammerandAnvil          = Action.Create({ Type = "Spell", ID = 433718   }),


            --Flags
    RedFlag                       = Action.Create({ Type = "Spell", ID = 156618 }),
    BlueFlag                      = Action.Create({ Type = "Spell", ID = 156621 }),

    --Orbs
    RedOrb                        = Action.Create({ Type = "Spell", ID = 121177 }),
    BlueOrb                       = Action.Create({ Type = "Spell", ID = 121164 }),
    GreenOrb                      = Action.Create({ Type = "Spell", ID = 121176 }),
    PurpleOrb                     = Action.Create({ Type = "Spell", ID = 121175 }),



        --Arena Prep Timer
        ArenaPrep                           = Action.Create({ Type = "Spell", ID = 32727     }),
        BlitzPrep                           = Action.Create({ Type = "Spell", ID = 44521     }),


}

local A = setmetatable(Action[ACTION_CONST_PALADIN_HOLY], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local targettarget = "targettarget"
local mouseover = "mouseover"
local focus = "focus"

local arenaDispelDebuffs = {
    -- Disorients
    [605] = true,    -- mind control
    [8122] = true,   -- psychic scream
    [205369] = true, -- mind bomb
    [115750] = true, -- blinding light
    [5782] = true,   -- fear
    [5484] = true,   -- howl of terror
    [6358] = true,   -- seduction
    [198898] = true, -- song of chi-ji

    -- Incapacitates
    [2637] = true,   -- hibernate
    [217832] = true, -- imprison
    [118] = true,    -- Polymorph - normal
    [28271] = true,  -- Polymorph - Turtle
    [28272] = true,  -- Polymorph - Pig
    [28285] = true,  -- Polymorph - Pig 2
    [61305] = true,  -- Polymorph - Black Cat
    [61721] = true,  -- Polymorph - Rabbit
    [61025] = true,  -- Polymorph - Serpent
    [61780] = true,  -- Polymorph - Turkey
    [161372] = true, -- Polymorph - Peacock
    [161355] = true, -- Polymorph - Penguin
    [161353] = true, -- Polymorph - Polar Bear Cub
    [161354] = true, -- Polymorph - Monkey
    [126819] = true, -- Polymorph - Porcupine
    [277787] = true, -- Polymorph - Direhorn
    [277792] = true, -- Polymorph - Bumblebee
    [391622] = true, -- Polymorph - Duck
    [321395] = true, -- Polymorph - Mawrat
    [113724] = true, -- ring of frost
    [187650] = true, -- freezing trap
    [20066] = true,  -- repentance

    -- Silences
    [47476] = true,  -- strangulate

    --Fears
    [118699] = true,  --Lock Fear
    [6789]   = true,  --Coil

    -- Roots
    [339] = true,    -- entangling roots
    [122] = true,    -- frost nova
    [102359] = true, -- mass entanglement
    [33395] = true,  -- freeze
    [109248] = true, -- binding shot
    [51485] = true,  -- earthgrab totem 1
    [64695] = true,  -- earthgrab totem 2

    -- Stuns
    [853] = true,    -- hammer of justice
    [179057] = true, -- chaos Nova
    [64044] = true,  -- psychic horror
    [200199] = true, -- censure

    [375901] = true, -- mindgames new 2
    [80240] = true,  -- havoc
    [325640] = true  -- soul rot
}


local burstlist = {
    384352, --doomwinds
    190319, --combustion
    191427, --meta
    162264, --meta2
    121471, --shadowblades
    185313, --shadow dance
    185422, --shadow dance
    288613, --trueshot
    360952, --coordinated assault
    102543, --incarn feral
    103560, --incarn elune
    1719, --recklessness
    107574, --avatar
    13750, --adrenaline rush
    12472, --icy veins
    51271, --pillar of frost
    383269, --abom limb
    231895, --avenging wrath
    384392, --crusade
    231895, --crusade2
    152173, --serenity
    114051, --ascendance
    393969, --danse macabre
}


local burstListLookup = {}

local function arenaEnemyBursting()
    local arenaUnit = {"arena1", "arena2", "arena3"}
    for _, spellId in ipairs(burstlist) do
        for _, unit in ipairs(arenaUnit) do
            if Unit(unit):HasBuffs(spellId) > 0 then
                return true
            end
        end
    end
    return false
end

for _, v in pairs(burstlist) do
    burstListLookup[v] = true
end

-- Freedom debuffs list (snares/roots that freedom removes)
local freedomDebuffs = {
    339,     -- Entangling Roots
    122,     -- Frost Nova
    102359,  -- Mass Entanglement
    51485,   -- Earthgrab Totem
    162488,  -- Steel Trap
    212638,  -- Tracker's Net
    64695,   -- Earthgrab Totem 2
    358385,  -- Landslide
    114404,  -- Void Tendrils
    3409,    -- Crippling Poison
    5116,    -- Concussive Shot
    450505,  -- Enfebling Spirit
}

-- Arena kicks list (spells to interrupt)
local arenaKicksList = {
    [118] = true,    -- Polymorph
    [5782] = true,   -- Fear
    [20066] = true,  -- Repentance
    [51514] = true,  -- Hex
    [33786] = true,  -- Cyclone
    [605] = true,    -- Mind Control
    [360806] = true, -- Sleep Walk
    [47540] = true,  -- Penance
    [47757] = true,  -- Penance
    [186723] = true, -- Penance
    [2060] = true,   -- Heal
    [2061] = true,   -- Flash Heal
    [19750] = true,  -- Flash of Light
    [82326] = true,  -- Holy Light
    [8936] = true,   -- Regrowth
    [77472] = true,  -- Healing Wave
    [8004] = true,   -- Healing Surge
    [1064] = true,   -- Chain Heal
    [115175] = true, -- Soothing Mist
    [116670] = true, -- Vivify
    [323673] = true, -- Mindgames
}

-- Stop casting list for PVP
local stopCastingList = {
    [20066] = true,  -- Repentance
    [414273] = true, -- Hand of Divinity
    [200652] = true, -- Tyr's Deliverance
}

-- Helper function to check if unit has any debuff from a list
local function hasDebuffFromList(unitID, debuffList)
    for _, debuffID in ipairs(debuffList) do
        if Unit(unitID):HasDeBuffs(debuffID) > 500 then
            return true
        end
    end
    return false
end

-- Helper function to check if enemy is casting from kick list
local function isCastingFromKickList(unitID)
    local castName, _, _, _, _, _, _, _, spellID = UnitCastingInfo(unitID)
    if castName and arenaKicksList[spellID] then
        return true
    end
    local channelName, _, _, _, _, _, _, channelSpellID = UnitChannelInfo(unitID)
    if channelName and arenaKicksList[channelSpellID] then
        return true
    end
    return false
end

-- Helper to find enemy healer in arena
local function getEnemyHealer()
    local arenaUnits = {"arena1", "arena2", "arena3"}
    for _, unitID in ipairs(arenaUnits) do
        if UnitExists(unitID) and Unit(unitID):IsHealer() then
            return unitID
        end
    end
    return nil
end

-- Helper to check if enemy healer is in CC
local function getEnemyHealerCCRemains()
    local healer = getEnemyHealer()
    if healer then
        return Unit(healer):InCC()
    end
    return 0
end

-- Helper to check if arena has physical damage dealers
local function arenaHasPhysicalDamage()
    local arenaUnits = {"arena1", "arena2", "arena3"}
    for _, unitID in ipairs(arenaUnits) do
        if UnitExists(unitID) and not Unit(unitID):IsHealer() and Unit(unitID):IsMelee() then
            return true
        end
    end
    return false
end

-- Helper to check if arena has magic damage dealers (casters)
local function arenaHasMagicDamage()
    local arenaUnits = {"arena1", "arena2", "arena3"}
    for _, unitID in ipairs(arenaUnits) do
        if UnitExists(unitID) and not Unit(unitID):IsHealer() and not Unit(unitID):IsMelee() then
            return true
        end
    end
    return false
end

-- Breakable CC spells that can be broken with damage (for Blessing of Sacrifice)
local breakableCCCasts = {
    -- Polymorph variants
    [118] = true,       -- Polymorph
    [28271] = true,     -- Polymorph (Turtle)
    [28272] = true,     -- Polymorph (Pig)
    [61305] = true,     -- Polymorph (Black Cat)
    [61721] = true,     -- Polymorph (Rabbit)
    [61025] = true,     -- Polymorph (Serpent)
    [61780] = true,     -- Polymorph (Turkey)
    [161353] = true,    -- Polymorph (Polar Bear Cub)
    [161354] = true,    -- Polymorph (Monkey)
    [161355] = true,    -- Polymorph (Penguin)
    [161372] = true,    -- Polymorph (Peacock)
    [126819] = true,    -- Polymorph (Porcupine)
    [277787] = true,    -- Polymorph (Direhorn)
    [277792] = true,    -- Polymorph (Bumblebee)
    [391622] = true,    -- Polymorph (Duck)
    [321395] = true,    -- Polymorph (Mawrat)
    -- Hex variants
    [51514] = true,     -- Hex
    [210873] = true,    -- Hex (Compy)
    [211004] = true,    -- Hex (Spider)
    [211010] = true,    -- Hex (Snake)
    [211015] = true,    -- Hex (Cockroach)
    [269352] = true,    -- Hex (Skeletal Hatchling)
    [309328] = true,    -- Hex (Living Honey)
    -- Fear effects
    [5782] = true,      -- Fear (Warlock)
    [118699] = true,    -- Fear (Warlock - alternate)
    [130616] = true,    -- Fear (Horrify)
    [5484] = true,      -- Howl of Terror
    [8122] = true,      -- Psychic Scream
    -- Other breakable CCs
    [20066] = true,     -- Repentance
    [360806] = true,    -- Sleep Walk (Evoker)
    [6358] = true,      -- Seduction (Succubus)
    [261589] = true,    -- Seduction (Grimoire of Sacrifice)
    [2637] = true,      -- Hibernate
    [1513] = true,      -- Scare Beast
}

-- Helper to check if an arena enemy is casting a breakable CC on the player
local function isEnemyCastingBreakableCCOnPlayer()
    local arenaUnits = {"arena1", "arena2", "arena3"}
    for _, arenaUnit in ipairs(arenaUnits) do
        if UnitExists(arenaUnit) then
            local castName, _, _, _, _, _, _, _, spellID = UnitCastingInfo(arenaUnit)
            if castName and breakableCCCasts[spellID] then
                -- Check if the cast is targeting the player
                local castTarget = arenaUnit .. "target"
                if UnitExists(castTarget) and UnitIsUnit(castTarget, "player") then
                    return true, arenaUnit
                end
            end
        end
    end
    return false, nil
end

--Bubble List
local BubbleList = {
    202019, --Shadow Bolt Volley
    196587, --Soul Burst

 }


 local function TankMode(unitID)
     useBubble = MultiUnits:GetByRangeCasting(nil, 1, nil, BubbleList) > 0

     if useBubble and A.DivineShield:IsReady(player) and Unit(player):HasDeBuffs(A.Forbearance.ID, true) == 0 then
         return A.DivineShield
     end
 end

local incorporealStunned = {
    360806, -- Sleep Walk
    2094, -- Blind
    217832, -- Imprison
    2637, -- Hibernate
    1513, -- Scare Beast
    187650, -- Freezing Trap
    118, -- Polymorph
    115078, -- Paralysis
    10326, -- Turn Evil
    20066, -- Repentance
    9484, -- Shackle Undead
    51514, -- Hex
    710, -- Banish
}

local function imprisonAffix(unit)
    if not A.TurnEvil:IsReady(unit) then return false end

    local npcID = select(6, Unit(unit):InfoGUID())
    local affixNPC = npcID == 204560
    local notStunned = Unit(unit):HasDeBuffs(incorporealStunned) == 0

    return affixNPC and notStunned
end

local function AfflictedAffix(unit)
    local debuffIDs = {A.CursedSpirit.ID, A.PoisonedSpirit.ID, A.DiseasedSpirit.ID}
    for _, id in ipairs(debuffIDs) do
        if Unit(unit):HasDeBuffs(id) > 0 then
            return true
        end
    end
    return false
end

local function getPowerWordShieldAbsorption(unitID)
    local totalAbsorbs = UnitGetTotalAbsorbs(unitID)
    return totalAbsorbs -- This includes all absorption effects, not just Power Word: Shield
end

-- Get player's effective health considering heal absorb effects (like Light of the Martyr debuff)
-- If the absorb is more than 10% of max health, treat it as missing health
local function getPlayerEffectiveHealthPercent()
    local currentHP = Unit(player):HealthPercent()
    local healAbsorbPercent = Unit(player):GetTotalHealAbsorbsPercent()

    -- If heal absorb is more than 10% of max health, subtract from effective HP
    if healAbsorbPercent > 10 then
        return currentHP - healAbsorbPercent
    end

    return currentHP
end

-- Get effective health for any unit (uses effective health for player)
local function getEffectiveHealthPercent(unitID)
    if UnitIsUnit(unitID, player) then
        return getPlayerEffectiveHealthPercent()
    end
    return Unit(unitID):HealthPercent()
end

local function Cleanse(unitID)
    if A.Cleanse:IsReady(unitID) then
        if AuraIsValid(unitID, "UseDispel", "Magic") or (A.ImprovedCleanse:IsTalentLearned() and AuraIsValid(unitID, "UseDispel", "Disease") or AuraIsValid(unitID, "UseDispel", "Poison")) then
            return A.Cleanse
        end
    end

end

local function canDispel(unitID)
    if A.Zone ~= "arena" or HealingEngine.GetBelowHealthPercentUnits(35, nil) > 0 then
        return false
    end

    local randomThreshold = math.random(500, 800) / 1000 -- Convert to seconds
    local dispelWindow = 2 -- Time in seconds before debuff expires to not dispel

    for i = 1, 40 do -- Iterate over debuffs
        local auraData = C_UnitAuras.GetDebuffDataByIndex(unitID, i)
        if not auraData then
            break
        end

        local spellId = auraData.spellId
        local duration = auraData.duration or 0
        local expiration = auraData.expirationTime or 0

        if arenaDispelDebuffs[spellId] then
            local startTime = expiration - duration
            local currentTime = GetTime()
            local elapsed = currentTime - startTime
            local remainingTime = expiration - currentTime

            if elapsed > randomThreshold and remainingTime > dispelWindow then
                return true
            end
        end
    end

    return false
end
local function getCastTime(unitID)
    local name, _, _, startTime, endTime, _, _, _, spellID = UnitCastingInfo(unitID)
    if not name then
        name, _, _, startTime, endTime, _, _, spellID = UnitChannelInfo(unitID)
    end
    if name then
        local elapsedTime = GetTime() - (startTime / 1000)
        return elapsedTime
    else
        return 0
    end
end



local function isPlayerChanneling()
    local spellName, _, _, _, startTime, endTime, _, _, notInterruptible = UnitChannelInfo("player")
    if spellName then
        return true
    else
        return false
    end
end

local function canHeal(unitID)
    if Unit(unitID):HasDeBuffs(33786) > 0 then
        return false
    end
    return true
end

------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
	TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
	TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
}

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then
        return
    end

    local unitID
	if A.IsUnitEnemy("target") then
        unit = "target"
    end


end
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Interrupts spells
local function Interrupts(unitID)
    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unitID, nil, nil, true)

	if castRemainsTime >= A.GetLatency() then
        if useKick and not notInterruptable and A.Rebuke:IsReady(unitID) then
            return A.Rebuke
        end

        if A.BlindingLight:IsReady(unitID) and useCC and not Unit(unitID):IsBoss() then
            return A.BlindingLight
        end

        if A.HammerofJustice:IsReady(unitID) and useCC and not Unit(unitID):IsBoss() then
            return A.HammerofJustice
        end

   	    if useRacial and A.QuakingPalm:AutoRacial(unitID) then
   	        return A.QuakingPalm
   	    end

   	    if useRacial and A.Haymaker:AutoRacial(unitID) then
            return A.Haymaker
   	    end

   	    if useRacial and A.WarStomp:AutoRacial(unitID) then
            return A.WarStomp
   	    end

   	    if useRacial and A.BullRush:AutoRacial(unitID) then
            return A.BullRush
   	    end
    end
end

local function doubleBeaconCheeseburger(icon, unitID)

    --everything here
    local faithActive = Unit("player"):HasBuffs(A.BeaconofFaith.ID) > 0 or Unit("party1"):HasBuffs(A.BeaconofFaith.ID) > 0 or Unit("party2"):HasBuffs(A.BeaconofFaith.ID) > 0
    local lightActive = Unit("player"):HasBuffs(A.BeaconofLight.ID) > 0 or Unit("party1"):HasBuffs(A.BeaconofLight.ID) > 0 or Unit("party2"):HasBuffs(A.BeaconofLight.ID) > 0
    local faithBeacon = Unit(unitID):HasBuffs(A.BeaconofFaith.ID) > 0
    local lightBeacon = Unit(unitID):HasBuffs(A.BeaconofLight.ID) > 0
    local noBeacon = not faithBeacon and not lightBeacon

    -- Emergency Saved by the Light - Apply beacon to low health target to trigger shield
    -- Only if target is below 50% and doesn't have Recently Saved by the Light debuff
    if A.SavedbytheLight:IsTalentLearned()
    and Unit(unitID):HealthPercent() < 50
    and Unit(unitID):HasBuffs(A.SavedbytheLight.ID, true) == 0
    and noBeacon then
        -- Try Beacon of Light first
        if A.BeaconofLight:IsReady(unitID) then
            return A.BeaconofLight:Show(icon)
        end
        -- Try Beacon of Faith if Light isn't available
        if A.BeaconofFaith:IsTalentLearned() and A.BeaconofFaith:IsReady(unitID) then
            return A.BeaconofFaith:Show(icon)
        end
    end

    if not A.IsInPvP and not A.BeaconofVirtue:IsTalentLearned() then
        --BeaconofLight
        if A.BeaconofLight:IsReady(player) and Unit(unitID):IsTank() and Unit(unitID):HasBuffs(A.BeaconofLight.ID, true) == 0 then
            return A.BeaconofLight:Show(icon)
        end
        --BeaconofFaith
        if A.BeaconofFaith:IsReady(player) and Unit(unitID):IsHealer() and Unit(unitID):HasBuffs(A.BeaconofFaith.ID, true) == 0 then
            return A.BeaconofFaith:Show(icon)
        end
    end

   -- Arena Logic (3v3, etc.)
    if A.IsInPvP then
        if A.BeaconofLight:IsReady("party1") and not lightActive and noBeacon then
            if UnitGUID("party1") ~= UnitGUID(unitID) then
                HealingEngine.SetTarget("party1", 1)
            end
            if UnitIsUnit(unitID, "party1") then
                return A.BeaconofLight:Show(icon)
            end
        end

        if A.BeaconofFaith:IsTalentLearned() and not faithActive and noBeacon then
            local beaconTarget = Unit("party2"):IsExists() and "party2" or "player"

            if A.BeaconofFaith:IsReady(beaconTarget) and lightActive then
                if UnitGUID(beaconTarget) ~= UnitGUID(unitID) then
                    HealingEngine.SetTarget(beaconTarget, 1)
                end
                if UnitIsUnit(unitID, beaconTarget) then
                    return A.BeaconofFaith:Show(icon)
                end
            end
        end
    end

end

-- Check if unit is taking physical damage (has melee attackers targeting them)
local function hasIncomingPhysicalDamage(unitID)
    -- Check if unit is being focused by melee specs within 8 yards
    -- IsFocused("MELEE", ...) checks if melee-spec enemies are targeting the unit
    if Unit(unitID):IsFocused("MELEE", nil, nil, 8) then
        return true
    end

    -- In Arena, also use the arena-specific check
    if A.Zone == "arena" then
        return arenaHasPhysicalDamage()
    end

    -- In Battleground/PvP, check if any enemy players in melee range are targeting the unit
    if A.IsInPvP then
        -- GetByRangeIsFocused returns count of enemies within range targeting the unit
        local meleeCount = A.MultiUnits:GetByRangeIsFocused(unitID, 8, 1)
        if meleeCount and meleeCount > 0 then
            return true
        end
    end

    return false
end

-- Blessing of Protection function
local function BlessingOfProtectionCheck(unitID)
    if A.BlessingofProtection:IsReady(player)
    and hasIncomingPhysicalDamage(unitID)
    and Unit(unitID):HasDeBuffs(A.Forbearance.ID) == 0
    and Unit(unitID):HealthPercent() <= 30
    and Unit(unitID):HasBuffs(A.RedOrb.ID) == 0
    and Unit(unitID):HasBuffs(A.PurpleOrb.ID) == 0
    and Unit(unitID):HasBuffs(A.BlueOrb.ID) == 0
    and Unit(unitID):HasBuffs(A.GreenOrb.ID) == 0
    and Unit(unitID):HasBuffs(A.RedFlag.ID) == 0
    and Unit(unitID):HasBuffs(A.BlueFlag.ID) == 0 then
        return A.BlessingofProtection
    end
    return nil
end

-- Blessing of Seasons function
local function BlessingOfSeasons()
    if A.BlessingofSummer:IsReady(player) then
        return A.BlessingofSummer
    end
    if A.BlessingofAutumn:IsReady(player) then
        return A.BlessingofAutumn
    end
    if A.BlessingofWinter:IsReady(player) then
        return A.BlessingofWinter
    end
    if A.BlessingofSpring:IsReady(player) then
        return A.BlessingofSpring
    end
    return nil
end

-- PVE Helper: Check if we can use AoE healing (multiple people need healing)
local function CanUseAoeHealingPve()
    if not A.GetToggle(2, "AoE") then return false end
    local friendlySize = TeamCache.Friendly.Size or 0
    if friendlySize == 0 then return false end

    local below95 = HealingEngine.GetBelowHealthPercentUnits(95, nil) or 0
    local below90 = HealingEngine.GetBelowHealthPercentUnits(90, nil) or 0
    local below85 = HealingEngine.GetBelowHealthPercentUnits(85, nil) or 0

    if friendlySize <= 5 then
        return below95 >= 5 or below90 >= 4 or below85 >= math.min(3, friendlySize)
    else
        return below95 >= 7 or below90 >= 6 or below85 >= 5
    end
end

-- PVE Helper: Check if we should use healing cooldowns (emergency situation)
local function CanUseHealingCooldownsPve()
    if not A.BurstIsON("player") then return false end
    if Unit(player):CombatTime() == 0 then return false end

    local friendlySize = TeamCache.Friendly.Size or 0
    if friendlySize == 0 then return false end

    local below80 = HealingEngine.GetBelowHealthPercentUnits(80, nil) or 0
    local below75 = HealingEngine.GetBelowHealthPercentUnits(75, nil) or 0
    local below70 = HealingEngine.GetBelowHealthPercentUnits(70, nil) or 0

    if friendlySize <= 5 then
        return below80 >= 5 or below75 >= 4 or below70 >= 3
    else
        return below80 >= 7 or below75 >= 6 or below70 >= 5
    end
end

-- PVE Helper: Check if Infusion of Light buff is active with enough time to cast
local function HasInfusionOfLight(castTime)
    local buffRemains = Unit(player):HasBuffs(A.InfusionofLightBuff.ID, true)
    return buffRemains > (castTime or 1500)
end

A[3] = function(icon)

    local inCombat = Unit("player"):CombatTime() > 0
    local isMoving = Player:IsStayingTime() < 0.3
    local isStaying = Player:IsStaying()
    local isPetActive = Player:GetTotemTimeLeft(1) > 0
    local isFriendly = A
    local BoPCharges = A.BlessingofProtection:GetSpellCharges()
    local HolyShockCharge = A.HolyShock:GetSpellCharges()
    local getmembersAll = HealingEngine.GetMembersAll()
    local isMouseoverAffix = imprisonAffix(mouseover)
    local isTargetAffix = imprisonAffix(target) and not A.IsUnitEnemy(mouseover)
    local enemyBurstCount = arenaEnemyBursting()

    if isMouseoverAffix or isTargetAffix then
        return A.TurnEvil:Show(icon)
    end

    local function num(val)
        if val then return 1 else return 0 end
    end

        -- Afflicted Affix
    if AfflictedAffix(mouseover) then
        if A.Cleanse:IsReady(mouseover) then
            return A.Cleanse:Show(icon)
        end
    elseif not A.IsUnitFriendly(mouseover) and AfflictedAffix(target) then
        if A.Cleanse:IsReady(target) then
            return A.Cleanse:Show(icon)
        end
    end

    -- Rite of Sanctification / Rite of Adjuration (weapon enchant)
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
    if not hasMainHandEnchant or (not inCombat and mainHandExpiration < 300000) then
        -- Rite of Sanctification (if talented)
        if A.RiteofSanctification:IsTalentLearned() and A.RiteofSanctification:IsReady(player) then
            return A.RiteofSanctification:Show(icon)
        end
        -- Rite of Adjuration (if talented instead)
        if A.RiteofAdjuration:IsTalentLearned() and A.RiteofAdjuration:IsReady(player) then
            return A.RiteofAdjuration:Show(icon)
        end
    end

    local function HealingRotation(unitID)


        --#####################################################################################################
        --Consecration
        if A.Consecration:IsReady(unitID)
        and A.HammerofJustice:IsInRange(unitID)
        and Unit(player):HasBuffsStacks(A.DivineGuidanceBuff.ID) == 5 then
            return A.Consecration:Show(icon)
        end

        -- Cleanse
        local useCleanse = Cleanse(unitID)
        if useCleanse then
            return useCleanse:Show(icon)
        end
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then
            return Interrupt:Show(icon)
        end
        -- Defensive
        local useBubble = TankMode(unitID)
        if useBubble then
            return useBubble:Show(icon)
        end
        --DevotionAura
        if A.DevotionAura:IsReady(player) and Unit(player):HasBuffs(A.DevotionAura.ID, true) == 0 then
            return A.DevotionAura:Show(icon)
        end
        if doubleBeaconCheeseburger(icon, unitID) then
            return true
        end
        --Entangling
        if A.BlessingofFreedom:IsReady(player) and Unit(player):HasDeBuffs(A.Entangling.ID, true) > 0 then
            return A.BlessingofFreedom:Show(icon)
        end
        --Divine Protection
        local divineProtHP = A.GetToggle(2, "SelfProtection1") or 60
        if inCombat and A.DivineProtection:IsReady(player) and Unit(player):HealthPercent() < divineProtHP then
            return A.DivineProtection:Show(icon)
        end
        --Divine Shield
        local divineShieldHP = A.GetToggle(2, "SelfProtection2") or 30
        if inCombat and A.DivineShield:IsReady(player) and Unit(player):HealthPercent() < divineShieldHP then
            return A.DivineShield:Show(icon)
        end

        if inCombat and Unit(player):HasBuffs(A.ArenaPrep.ID) == 0 then
            --Blessing of Seasons
            local useSeasons = BlessingOfSeasons()
            if useSeasons then
                return useSeasons:Show(icon)
            end
        end
        --#######################################################################################################

        --PVP Healing Rotation
        if A.IsInPvP and canHeal(unitID) then

            -- Blessing of Sacrifice

            if A.BlessingofSacrifice:IsReady(unitID)
            and not UnitIsUnit(unitID, "player")
            and Unit(unitID):HealthPercent() <= 70 then
                return A.BlessingofSacrifice:Show(icon)
            end

            --Lay on Hands
            if A.LayOnHands:IsReady(player)
            and not A.EmpyrealWard:IsTalentLearned()
            and Unit(unitID):HealthPercent() < 18
            and Unit(unitID):HasDeBuffs(A.Forbearance.ID) == 0 then
                return A.LayOnHands:Show(icon)
            end
            if A.LayOnHandsWard:IsReady(player)
            and A.EmpyrealWard:IsTalentLearned()
            and Unit(unitID):HealthPercent() < 18
            and Unit(unitID):HasDeBuffs(A.Forbearance.ID) == 0 then
                return A.LayOnHandsWard:Show(icon)
            end

            --BoP
            if useBoP then
                return useBoP:Show(icon)
            end

            -- Holy Light with BIG Buffs
            if A.HolyLight:IsReady(player)
            and Unit(player):HasBuffsStacks(A.HandofDivinity.ID) > 0
            and Unit(unitID):HealthPercent() <= 80
            and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 then
                return A.HolyLight:Show(icon)
            end
            if isStaying and A.HolyLight:IsReady(player)
            and Unit(player):HasBuffsStacks(A.DivineFavor.ID) > 0
            and Unit(unitID):HealthPercent() <= 80
            and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 then
                return A.HolyLight:Show(icon)
            end
            if A.HolyLight:IsReady(player)
            and Unit(player):HasBuffsStacks(A.HandofDivinity.ID) > 0
            and Unit(unitID):HealthPercent() <= 62 then
                return A.HolyLight:Show(icon)
            end

            --Holy Armaments (Holy Bulwark or Sacred Weapon depending on talent)
            if A.HolyBulwark:IsReady(player)
            and inCombat and Unit(unitID):HealthPercent() <= 88
            and Unit(player):HasBuffs(A.HolyBulwarkBuff.ID) == 0 then
                return A.HolyBulwark:Show(icon)
            end
            if A.SacredWeapon:IsReady(player)
            and inCombat and Unit(unitID):HealthPercent() <= 88
            and Unit(player):HasBuffs(A.SacredWeaponBuff.ID) == 0 then
                return A.SacredWeapon:Show(icon)
            end

            --Divine Toll
            if inCombat and A.DivineToll:IsReady(player)
            and Unit(unitID):HealthPercent() <= 65
            and Unit(player):HasBuffsStacks(A.RisingSunlightBuff.ID) == 0 then
                return A.DivineToll:Show(icon)
            end

            -- Avenging Wrath
            if inCombat and A.AvengingWrath:IsReady(player)
            and not A.AvengingCrusader:IsTalentLearned()
            and Unit(unitID):HealthPercent() <= 65
            and Unit(player):HasBuffs(A.AvengingWrath.ID) == 0
            and Unit(player):HasBuffsStacks(A.RisingSunlightBuff.ID) == 0 then
                return A.AvengingWrath:Show(icon)
            end
            -- Avenging Crusader
            if inCombat and A.AvengingCrusader:IsReady(player)
            and not A.AvengingWrath:IsTalentLearned()
            and Unit(unitID):HealthPercent() <= 65
            and Unit(player):HasBuffs(A.AvengingWrath.ID) == 0
            and Unit(player):HasBuffsStacks(A.RisingSunlightBuff.ID) == 0 then
                return A.AvengingCrusader:Show(icon)
            end

            -- Holy Shock Tripple Cast
            if A.HolyShock:IsReady(player)
            and Unit(unitID):HealthPercent() <= 80
            and Unit(player):HasBuffsStacks(A.RisingSunlightBuff.ID) > 0 then
                return A.HolyShock:Show(icon)
            end

            -- Aura Mastery
            if A.AuraMastery:IsReady(player)
            and Unit(unitID):HasBuffs(A.AuraMastery.ID) == 0
            and ((HealingEngine.GetBelowHealthPercentUnits(85) >= 3) or (HealingEngine.GetBelowHealthPercentUnits(75) >= 2) or (Unit(unitID):HealthPercent() <= 40)) then
                return A.AuraMastery:Show(icon)
            end

            -- Blessing of Sacrifice
            if not A.IsInPvP and A.BlessingofSacrifice:IsReady(unitID)
            and Unit(unitID):IsTank() and Unit(unitID):HealthPercent() <= 75 then
                return A.BlessingofSacrifice:Show(icon)
            end

            -- Eternal Flame
            if IsPlayerSpell(A.EternalFlame.ID)
            and Unit(unitID):HealthPercent() <= 90
            and Player:HolyPower() >= 3
            and Unit(player):HasBuffsStacks(A.DawnLightBuff.ID) > 0
            and Unit(unitID):HasBuffs(A.DawnLightHeal.ID) == 0 then
                return A.EternalFlame:Show(icon)
            end
            -- Word of Glory
            if A.WordofGlory:IsReady(player)
            and Unit(unitID):HealthPercent() <= 90
            and Player:HolyPower() >= 3
            and Unit(player):HasBuffsStacks(A.DawnLightBuff.ID) > 0
            and Unit(unitID):HasBuffs(A.DawnLightHeal.ID) == 0 then
                return A.WordofGlory:Show(icon)
            end

            -- Barrier of Faith
            if A.BarrierofFaith:IsReady(player)
            and ((Unit(unitID):HealthPercent() < 80)
            and (Unit(unitID):HasBuffs(A.BarrierofFaithBuff.ID) == 0) or (Unit(unitID):HasBuffs(A.BarrierofFaithBuff.ID) == 0) and (Unit(unitID):HealthPercentLosePerSecond() > 15)) then
                return A.BarrierofFaith:Show(icon)
            end
            -- Holy Prism
            if A.HolyPrism:IsReady(player)
            and ((Unit(unitID):HealthPercent() < 80) and (Unit(unitID):HasBuffs(A.BarrierofFaithBuff.ID) == 0) or (Unit(unitID):HasBuffs(A.BarrierofFaithBuff.ID) == 0) and (Unit(unitID):HealthPercentLosePerSecond() > 15)) then
                return A.HolyPrism:Show(icon)
            end

            -- Word of Glory
            if A.WordofGlory:IsReady(player)
            and Unit(unitID):HealthPercent() <= 90
            and Player:HolyPower() == 5 then
                return A.WordofGlory:Show(icon)
            end
            -- Eternal Flame
            if IsPlayerSpell(A.EternalFlame.ID)
            and Unit(unitID):HealthPercent() <= 90
            and Player:HolyPower() == 5 then
                return A.EternalFlame:Show(icon)
            end

            -- Flash of Light with Infusion of Light Buff
            if isStaying and A.FlashofLight:IsReady(player)
            and Unit(unitID):HealthPercent() < 90
            and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 then
                return A.FlashofLight:Show(icon)
            end

            -- Eternal Flame
            if IsPlayerSpell(A.EternalFlame.ID)
            and Unit(unitID):HealthPercent() <= 92
            and Player:HolyPower() >= 3 then
                return A.EternalFlame:Show(icon)
            end
            -- Word of Glory
            if A.WordofGlory:IsReady(player)
            and Unit(unitID):HealthPercent() <= 92
            and Player:HolyPower() >= 3 then
                return A.WordofGlory:Show(icon)
            end

            -- Holy Light
            if isStaying and A.HolyLight:IsReady(player)
            and Unit(player):HasBuffsStacks(A.DivineFavor.ID) > 0
            and Unit(unitID):HealthPercent() <= 75
            and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 then
                return A.HolyLight:Show(icon)
            end

            -- Beacon of Virtue
            if not A.IsInPvP and A.BeaconofVirtue:IsTalentLearned()
            and A.BeaconofVirtue:IsReady(player)
            and HealingEngine.GetBelowHealthPercentUnits(90) >= 2 then
                return A.BeaconofVirtue:Show(icon)
            end

            -- Holy Shock
            if A.HolyShock:IsReady(player) and Unit(unitID):HealthPercent() <= 95 then
                return A.HolyShock:Show(icon)
            end

            -- Holy Prism
            if A.HolyPrism:IsReady(player) and Unit(unitID):HealthPercent() <= 75 then
                return A.HolyPrism:Show(icon)
            end

            -- Flash of Light
            if isStaying and A.FlashofLight:IsReady(player) and Unit(unitID):HealthPercent() < 75 then
                return A.FlashofLight:Show(icon)
            end

            -- Tyrs Deliverance
            if inCombat and isStaying and A.TyrsDeliverance:IsReady(player)
            and Unit(unitID):HealthPercent() > 95
            and Unit(unitID):HasBuffs(A.ArenaPrep.ID) < 1
            and Unit(unitID):HasBuffs(A.TyrsDeliverance.ID) == 0 then
                return A.TyrsDeliverance:Show(icon)
            end
            if A.TyrsDeliverance:IsReady(player)
            and Unit(unitID):HasBuffs(A.ArenaPrep.ID) == 0
            and HealingEngine.GetBelowHealthPercentUnits(100) == 0 then
                return A.TyrsDeliverance:Show(icon)
            end


        end

        --#######################################################################################################################
        --PVE Healing Rotation
        if not A.IsInPvP and canHeal(unitID) then

            local holyPower = Player:HolyPower() or 0
            local hasDawnlight = Unit(player):HasBuffs(A.DawnLightBuff.ID, true) > 0
            local hasBeaconVirtue = Unit(player):HasBuffs(A.BeaconofVirtue.ID, true) > 0 or Unit(unitID):HasBuffs(A.BeaconofVirtue.ID, true) > 0
            local hasDivinePurpose = Unit(player):HasBuffs(A.DivinePurposeBuff.ID, true) > 0
            local hasInfusion = Unit(player):HasBuffs(A.InfusionofLightBuff.ID, true) > 1500
            local hasDivinity = Unit(player):HasBuffs(A.HandofDivinity.ID, true) > 0
            local hasDivineFavor = Unit(player):HasBuffs(A.DivineFavor.ID, true) > 0

            -- Emergency: Lay on Hands
            if A.LayOnHands:IsReady(player)
            and not A.EmpyrealWard:IsTalentLearned()
            and Unit(unitID):HealthPercent() < 20
            and Unit(unitID):HasDeBuffs(A.Forbearance.ID) == 0 then
                return A.LayOnHands:Show(icon)
            end
            if A.LayOnHandsWard:IsReady(player)
            and A.EmpyrealWard:IsTalentLearned()
            and Unit(unitID):HealthPercent() < 20
            and Unit(unitID):HasDeBuffs(A.Forbearance.ID) == 0 then
                return A.LayOnHandsWard:Show(icon)
            end

            -- Emergency: Blessing of Protection
            local useBoPPve = BlessingOfProtectionCheck(unitID)
            if useBoPPve then
                return useBoPPve:Show(icon)
            end

            -- Blessing of Sacrifice on tank for tank busters
            if inCombat and A.BlessingofSacrifice:IsReady(player)
            and Unit(unitID):IsTank()
            and Unit(unitID):HealthPercent() <= 50 then
                return A.BlessingofSacrifice:Show(icon)
            end

            -- Blessing of Seasons
            local useSeasonsP = BlessingOfSeasons()
            if inCombat and useSeasonsP then
                return useSeasonsP:Show(icon)
            end

            -- Avenging Wrath (when not talented into Avenging Crusader)
            if inCombat and A.AvengingWrath:IsReady(player)
            and not A.AvengingCrusader:IsTalentLearned()
            and A.BurstIsON("player")
            and CanUseHealingCooldownsPve() then
                return A.AvengingWrath:Show(icon)
            end

            -- Avenging Crusader (if talented)
            if inCombat and A.AvengingCrusader:IsReady(player)
            and A.AvengingCrusader:IsTalentLearned()
            and A.BurstIsON("player")
            and (CanUseHealingCooldownsPve() or Unit(unitID):HealthPercent() <= A.GetToggle(2, "AvengingCrusaderSlider")) then
                return A.AvengingCrusader:Show(icon)
            end

            -- Aura Mastery
            if inCombat and A.AuraMastery:IsReady(player)
            and A.BurstIsON("player")
            and CanUseHealingCooldownsPve() then
                return A.AuraMastery:Show(icon)
            end

            -- Tyrs Deliverance
            if inCombat and A.TyrsDeliverance:IsReady(player)
            and CanUseAoeHealingPve() then
                return A.TyrsDeliverance:Show(icon)
            end

            -- Beacon of Virtue
            if inCombat and A.BeaconofVirtue:IsTalentLearned()
            and A.BeaconofVirtue:IsReady(player)
            and (CanUseAoeHealingPve() or CanUseHealingCooldownsPve()) then
                return A.BeaconofVirtue:Show(icon)
            end

            -- Divine Toll (when multiple need healing and low holy power)
            if inCombat and A.DivineToll:IsReady(player)
            and holyPower < 2
            and CanUseAoeHealingPve() then
                return A.DivineToll:Show(icon)
            end

            -- Hand of Divinity
            if inCombat and A.HandofDivinity:IsReady(player)
            and CanUseAoeHealingPve() then
                return A.HandofDivinity:Show(icon)
            end

            -- Holy Bulwark (Holy Armaments - defensive)
            if inCombat and A.HolyBulwark:IsReady(player)
            and Unit(unitID):HasBuffs(A.HolyBulwarkBuff.ID) == 0
            and Unit(unitID):HealthPercent() <= 75 then
                return A.HolyBulwark:Show(icon)
            end

            -- Sacred Weapon (Holy Armaments - offensive healing)
            if inCombat and A.SacredWeapon:IsReady(player)
            and Unit(unitID):HasBuffs(A.SacredWeaponBuff.ID) == 0
            and CanUseAoeHealingPve() then
                return A.SacredWeapon:Show(icon)
            end

            -- Holy Shock (2 charges - use one)
            local hsCharges = A.HolyShock:GetSpellCharges() or 0
            if A.HolyShock:IsReady(player)
            and hsCharges >= 2
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "HolyShockSlider") then
                return A.HolyShock:Show(icon)
            end

            -- Barrier of Faith
            if A.BarrierofFaith:IsReady(player)
            and A.BarrierofFaith:IsTalentLearned()
            and Unit(unitID):HealthPercent() <= 80 then
                return A.BarrierofFaith:Show(icon)
            end

            -- Holy Prism
            if A.HolyPrism:IsReady(player)
            and A.HolyPrism:IsTalentLearned()
            and Unit(unitID):HealthPercent() <= 75 then
                return A.HolyPrism:Show(icon)
            end

            -- Word of Glory with Dawnlight or Beacon of Virtue buff
            if (hasDawnlight or hasBeaconVirtue)
            and A.WordofGlory:IsReady(player)
            and holyPower >= 3
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "WOGSlider") then
                return A.WordofGlory:Show(icon)
            end

            -- Light of Dawn at 5 Holy Power
            if holyPower >= 5
            and A.LightofDawn:IsReady(player)
            and CanUseAoeHealingPve() then
                return A.LightofDawn:Show(icon)
            end

            -- Word of Glory at 5 Holy Power (if not using Light of Dawn)
            if holyPower >= 5
            and A.WordofGlory:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "WOGSlider") then
                return A.WordofGlory:Show(icon)
            end

            -- Holy Light with Hand of Divinity buff
            if hasDivinity
            and isStaying
            and A.HolyLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= 80 then
                return A.HolyLight:Show(icon)
            end

            -- Flash of Light with Infusion of Light
            if hasInfusion
            and A.FlashofLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "FlashofLightSlider") then
                return A.FlashofLight:Show(icon)
            end

            -- Holy Light with Infusion of Light (if staying still)
            if hasInfusion
            and isStaying
            and A.HolyLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "HolyLightSlider") then
                return A.HolyLight:Show(icon)
            end

            -- Flash of Light with Divine Favor
            if hasDivineFavor
            and A.FlashofLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= 75 then
                return A.FlashofLight:Show(icon)
            end

            -- Holy Light with Divine Favor (if staying still)
            if hasDivineFavor
            and isStaying
            and A.HolyLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= 80 then
                return A.HolyLight:Show(icon)
            end

            -- Light of Dawn (default)
            if A.LightofDawn:IsReady(player)
            and holyPower >= 3
            and CanUseAoeHealingPve() then
                return A.LightofDawn:Show(icon)
            end

            -- Word of Glory (default)
            if A.WordofGlory:IsReady(player)
            and holyPower >= 3
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "WOGSlider") then
                return A.WordofGlory:Show(icon)
            end

            -- Holy Shock (default)
            if A.HolyShock:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "HolyShockSlider") then
                return A.HolyShock:Show(icon)
            end

            -- Judgment (for Infusion of Light procs)
            if inCombat and A.Judgment:IsReady(player)
            and Unit(target):IsEnemy()
            and not hasInfusion then
                return A.Judgment:Show(icon)
            end

            -- Flash of Light (hard cast)
            if isStaying
            and A.FlashofLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "FlashofLightSlider") then
                return A.FlashofLight:Show(icon)
            end

            -- Holy Light (hard cast)
            if isStaying
            and A.HolyLight:IsReady(player)
            and Unit(unitID):HealthPercent() <= A.GetToggle(2, "HolyLightSlider") then
                return A.HolyLight:Show(icon)
            end

            -- Out of Combat: Holy Light for topping off
            if not inCombat
            and A.GetToggle(2, "OOCHeal")
            and isStaying
            and A.HolyLight:IsReady(player)
            and Unit(unitID):HealthPercent() < 95 then
                return A.HolyLight:Show(icon)
            end

        end

    end

    local function EnemyRotation(unitID, icon)
        local HolyShockCharge = A.HolyShock:GetSpellCharges()
        local isStaying = Player:IsStaying()
        local inCombat = Unit("player"):CombatTime() > 0
        local isMoving = Player:IsStayingTime() < 0.3
        local isStaying = Player:IsStaying()
        local isPetActive = Player:GetTotemTimeLeft(1) > 0
        local isFriendly = A
        local BoPCharges = A.BlessingofProtection:GetSpellCharges()
        local HolyShockCharge = A.HolyShock:GetSpellCharges()

        local function num(val)
            if val then return 1 else return 0 end
        end

        -- Judgment
        if A.Judgment:IsReady(unitID) 
        and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 
        and A.HammerandAnvil:IsTalentLearned() then
            return A.Judgment:Show(icon)
        end
        -- Judgment w/WINGS
        if A.Judgment:IsReady(unitID) 
        and Unit(player):HasBuffsStacks(A.AvengingCrusader.ID) > 0 then
            return A.Judgment:Show(icon)
        end
        -- Crusader Strike w/WINGS
        if A.CrusaderStrike:IsReady() 
        and Unit(player):HasBuffsStacks(A.AvengingCrusader.ID) > 0 then
            return A.CrusaderStrike:Show(icon)
        end
        -- Holy Prism
        if A.HolyPrism:IsReady(player) 
        and HealingEngine.GetBelowHealthPercentUnits(100) == 0 then
            return A.HolyPrism:Show(icon)
        end
        -- Hammer of Wrath
        if A.HammerofWrath:IsReady("target") then
            return A.HammerofWrath:Show(icon)
        end
        if isStaying and A.Repentance:IsReady(unitID)
        and Unit(unitID):InCC() < .50
        and HealingEngine.GetBelowHealthPercentUnits(80, nil) == 0 then
            local hasBurst = false
            for _, spellId in ipairs(burstlist) do
                if Unit(unitID):HasBuffs(spellId) > 0 then
                    hasBurst = true
                    break
                end
            end
            if Unit(unitID):IsHealer() or (Unit(unitID):IsDamager() and hasBurst) then
                return A.Repentance:Show(icon)
            end
        end
        -- Judgment
        if A.Judgment:IsReady(unitID) 
        and Unit(player):HasBuffsStacks(A.InfusionofLightBuff.ID) > 0 
        and Unit(unitID):HasDeBuffs(A.Unworthy.ID) == 0 then
            return A.Judgment:Show(icon)
        end
        --Consecration (only if enemy is close and no healing priority)
        if not A.IsInPvP and inCombat
        and A.Consecration:IsReady(player)
        and A.Rebuke:IsInRange()
        and Unit(player):HasBuffs(A.ConsecrationBuff.ID) == 0
        and HealingEngine.GetBelowHealthPercentUnits(80, nil) == 0 then
            return A.Consecration:Show(icon)
        end
        -- Holy Shock
        if HolyShockCharge == 2 and A.HolyShock:IsReady(player) 
        and Unit(player):HasBuffsStacks(A.RisingSunlightBuff.ID) > 0 
        and HealingEngine.GetBelowHealthPercentUnits(95) == 0 then
            return A.HolyShockDmg:Show(icon)
        end
        --Denounce
        if A.IsInPvP
        and A.Denounce:IsTalentLearned()
        and A.Denounce:IsReady(unitID)
        and Unit(target):HasDeBuffs(A.Denounce.ID) <= 1
        and Player:HolyPower() == 5
        and HealingEngine.GetBelowHealthPercentUnits(95) == 0 then
            return A.Denounce:Show(icon)
        end
        -- Crusader Strike
        if A.CrusaderStrike:IsReady() then
            return A.CrusaderStrike:Show(icon)
        end
        --Shield of Righteous (only if no healing needed)
        if A.ShieldofTheRighteous:IsReady(player)
        and A.Rebuke:IsInRange()
        and HealingEngine.GetBelowHealthPercentUnits(80, nil) == 0 then
            return A.ShieldofTheRighteous:Show(icon)
        end

    end

    local isHealerSetupDone = false






    if A.IsUnitFriendly("target") and HealingRotation("target") then return true end
    if A.IsUnitFriendly("focus")  and HealingRotation("focus") then return true end
    if A.IsUnitEnemy("target")    and EnemyRotation("target", icon) then return true end

end

-- Arena Party Rotation (friendly units in arena)
local function arenaPartyRotation(icon, unitID)
    if isPlayerChanneling() then return end
    if not UnitExists(unitID) then return end
    if not A.IsUnitFriendly(unitID) then return end

    local isStaying = Player:IsStaying()
    local isMe = UnitIsUnit(unitID, player)
    -- Use effective health (accounts for Light of the Martyr absorb on player)
    local unitHP = getEffectiveHealthPercent(unitID)
    local hasForbearance = Unit(unitID):HasDeBuffs(A.Forbearance.ID) > 0
    local unitClass = Unit(unitID):Class()
    local targetHP = Unit("target"):HealthPercent() or 100

    -- Cleanse (avoid dispelling UA)
    if A.Cleanse:IsReady(unitID) and canDispel(unitID)
    and Unit(unitID):HasDeBuffs(30108) < .1
    and Unit(unitID):HasDeBuffs(316099) < .1 then
        return A.Cleanse:Show(icon)
    end

    -- Blessing of Freedom - if friendly has root/snare debuff
    if A.BlessingofFreedom:IsReady(player) and hasDebuffFromList(unitID, freedomDebuffs) then
        return A.BlessingofFreedom:Show(icon)
    end

    -- Blessing of Protection - for physical damage
    if A.BlessingofProtection:IsReady(player) and arenaHasPhysicalDamage() then
        if isMe and A.DivineShield:GetCooldown() < 2 and not A.LightsRevocation:IsTalentLearned() then
            -- Skip BoP on self if Divine Shield is almost ready (unless we have Light's Revocation)
        elseif unitHP <= 60 and not hasForbearance and not (unitClass == "PALADIN" and not isMe) then
            -- Don't BoP other paladins, only self
            if not (unitHP > 40 and targetHP < 20) then
                return A.BlessingofProtection:Show(icon)
            end
        end
    end

    -- Blessing of Spellwarding - for magic damage
    if A.BlessingofSpellwarding:IsReady(player) and A.BlessingofSpellwarding:IsTalentLearned() and arenaHasMagicDamage() then
        if isMe and A.DivineShield:GetCooldown() < 2 and not A.LightsRevocation:IsTalentLearned() then
            -- Skip on self if Divine Shield is almost ready
        elseif unitHP <= 60 and not hasForbearance and not (unitClass == "PALADIN" and not isMe) then
            if not (unitHP > 40 and targetHP < 20) then
                return A.BlessingofSpellwarding:Show(icon)
            end
        end
    end

    -- Blessing of Sacrifice
    if A.BlessingofSacrifice:IsReady(player) then
        -- Use Case 1: Breakable CC prevention - Cast on self when enemy is casting breakable CC on player
        -- The damage transfer from BoS will break the CC cast before it completes
        if isMe then
            local isCastingCC, casterUnit = isEnemyCastingBreakableCCOnPlayer()
            if isCastingCC then
                -- Find a party member to cast BoS on (not the player)
                local bosSacTarget = nil
                if UnitExists("party1") and not UnitIsUnit("party1", "player") then
                    bosSacTarget = "party1"
                elseif UnitExists("party2") and not UnitIsUnit("party2", "player") then
                    bosSacTarget = "party2"
                end

                if bosSacTarget and A.BlessingofSacrifice:IsReady(bosSacTarget) then
                    HealingEngine.SetTarget(bosSacTarget, 1)
                    return A.BlessingofSacrifice:Show(icon)
                end
            end
        end

        -- Use Case 2: Standard usage - Cast on party members (not player) at 70% HP or below
        if not isMe and unitHP <= 70 then
            return A.BlessingofSacrifice:Show(icon)
        end
    end
end

-- Arena Enemy Rotation
local function arenaEnemyRotation(icon, unitID)
    if not UnitExists(unitID) then return end
    if not A.IsUnitEnemy(unitID) then return end

    local isStaying = Player:IsStaying()
    local enemyHP = Unit(unitID):HealthPercent()
    local enemyHealer = getEnemyHealer()
    local isEnemyHealer = enemyHealer and UnitIsUnit(unitID, enemyHealer)
    local isTarget = UnitIsUnit(unitID, "target")
    local ccRemains = Unit(unitID):InCC()
    local stunDR = Unit(unitID):GetDR("stun") / 100  -- Convert to 0-1 scale
    local incapacitateDR = Unit(unitID):GetDR("incapacitate") / 100
    local hasSearingGlare = Unit(player):HasDeBuffs(A.SearingGlareDebuff.ID) > 0
    local hasDiamondTrap = Unit(unitID):HasDeBuffs(203337) > 0  -- Freezing Trap (Honor talent)
    local healerCCRemains = getEnemyHealerCCRemains()

    -- Skip if player has Searing Glare debuff
    if hasSearingGlare then return end

    -- HOJ Healer - if healer is not in CC and has more than 50% DR
    if A.HammerofJustice:IsReady(unitID)
    and isEnemyHealer
    and not isTarget
    and not hasDiamondTrap
    and ccRemains < 1500
    and stunDR >= 0.5 then
        return A.HammerofJustice:Show(icon)
    end

    -- HOJ Kill Target - if enemy healer is CCed and target is low
    if A.HammerofJustice:IsReady(unitID)
    and isTarget
    and not isEnemyHealer
    and not hasDiamondTrap
    and healerCCRemains >= 2000 then
        -- Full DR = always HOJ
        if stunDR >= 1 then
            return A.HammerofJustice:Show(icon)
        end
        -- Low DR but target is low HP
        if stunDR < 0.5 and enemyHP < 50 then
            return A.HammerofJustice:Show(icon)
        end
    end

    -- Rebuke - interrupt important casts (only if no one is low HP)
    if A.Rebuke:IsReady(unitID)
    and HealingEngine.GetBelowHealthPercentUnits(50, nil) == 0
    and isCastingFromKickList(unitID) then
        return A.Rebuke:Show(icon)
    end

    -- Repentance - CC enemy healer if allies are not too low and an arena enemy is injured
    if isStaying
    and A.Repentance:IsReady(unitID)
    and isEnemyHealer
    and not isTarget
    and enemyHP >= 20
    and ccRemains < 1000
    and incapacitateDR >= 0.5
    and HealingEngine.GetBelowHealthPercentUnits(50, nil) == 0 then
        -- Check if any arena enemy is injured (below 70%)
        local arenaUnits = {"arena1", "arena2", "arena3"}
        for _, arenaUnit in ipairs(arenaUnits) do
            if UnitExists(arenaUnit) and Unit(arenaUnit):HealthPercent() < 70 then
                return A.Repentance:Show(icon)
            end
        end
    end
end


-- Finished

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = function(icon)
    -- Stop casting damage spells if party member is low
    if A.Zone == "arena" then
        local castName, _, _, _, _, _, _, _, spellID = UnitCastingInfo(player)
        if castName and stopCastingList[spellID] then
            if HealingEngine.GetBelowHealthPercentUnits(40, nil) >= 1 then
                SpellStopCasting()
            end
        end
    end

    if A.Zone == "arena" and not Player:IsStealthed() then
        -- Party1 healing/utility rotation
        if arenaPartyRotation(icon, "party1") then return true end
        -- Arena1 enemy rotation
        if arenaEnemyRotation(icon, "arena1") then return true end
    end
end

A[7] = function(icon)
    if A.Zone == "arena" and not Player:IsStealthed() then
        -- Party2 healing/utility rotation
        if arenaPartyRotation(icon, "party2") then return true end
        -- Arena2 enemy rotation
        if arenaEnemyRotation(icon, "arena2") then return true end
    end
end

A[8] = function(icon)
    if A.Zone == "arena" and not Player:IsStealthed() then
        -- Party3 healing/utility rotation
        if arenaPartyRotation(icon, "party3") then return true end
        -- Arena3 enemy rotation
        if arenaEnemyRotation(icon, "arena3") then return true end
    end
end

A[9] = function(icon)
    if A.Zone == "arena" and not Player:IsStealthed() then
        -- Party4 (if applicable)
        if arenaPartyRotation(icon, "party4") then return true end
    end
end

A[10] = function(icon)
    if A.Zone == "arena" and not Player:IsStealthed() then
        -- Player rotation (self)
        if arenaPartyRotation(icon, player) then return true end
    end
end
