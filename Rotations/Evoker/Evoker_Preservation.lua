-- furys update
if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 1468 then return end

local Action = _G.Action
local TMW = _G.TMW

local GetToggle	= Action.GetToggle
local Unit = Action.Unit
local Aware = MakuluFramework.Aware
local CONST                               = Action.Const
local Create                              = Action.Create
local GetToggle                           = Action.GetToggle
local AuraIsValid                         = Action.AuraIsValid
local InterruptIsValid                    = Action.InterruptIsValid
local FriendlyTeam                        = Action.FriendlyTeam
local LoC                                 = Action.LossOfControl
local ActionPlayer                        = Action.Player
local MultiUnits                          = Action.MultiUnits
local HealingEngine                       = Action.HealingEngine
local HealingEngineSetTarget              = HealingEngine.SetTarget
local ACTION_CONST_EVOKER_PRESERVATION    = CONST.EVOKER_PRESERVATION
local ACTION_CONST_STOPCAST               = CONST.STOPCAST
local getmembersAll                       = HealingEngine.GetMembersAll()
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid, UnitDetailedThreatSituation, IsResting, GetItemCount, debugprofilestop = 
_G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid, _G.UnitDetailedThreatSituation, _G.IsResting, _G.GetItemCount, _G.debugprofilestop
local ConstUnit        = MakuluFramework.ConstUnits
local ConstSpells      = MakuluFramework.constantSpells
local player = ConstUnit.player
local target = ConstUnit.target



-- This is a variable we change to 1 or 2 before we return living flame or living flame damage so that we can track which one we are casting (primarily for stopcasting purposes)
local LivingFlameCastType = 0
-- This is a variable we change to 1 or 2 depending on what spell we cast during stasis (dreambreath or spiritbloom) because we want to track this for using stasis again the right way
local StasisType = 0
local IsUnitEnemy                       = Action.IsUnitEnemy

local FakeCasting      = MakuluFramework.FakeCasting

Action[ACTION_CONST_EVOKER_PRESERVATION] = {
    --Alliance Racials
    EveryManforHimself                    = Create({ Type = "Spell", ID = 59752     }),
    Stoneform                             = Create({ Type = "Spell", ID = 20594     }),
    Shadowmeld                            = Create({ Type = "Spell", ID = 58984     }),
    EscapeArtist                          = Create({ Type = "Spell", ID = 20589     }),
    GiftofNaaru                           = Create({ Type = "Spell", ID = 59542     }),
    Darkflight                            = Create({ Type = "Spell", ID = 68992     }),
    SpatialRift                           = Create({ Type = "Spell", ID = 256948    }),
    LightsJudgment                        = Create({ Type = "Spell", ID = 255647    }),
    Fireblood                             = Create({ Type = "Spell", ID = 265221    }),
    Haymaker                              = Create({ Type = "Spell", ID = 287712    }),
    HyperOrganicLightOriginator           = Create({ Type = "Spell", ID = 312924    }),
    --Horde Racials
    BloodFury                             = Create({ Type = "Spell", ID = 33697     }),
    WilloftheForsaken                     = Create({ Type = "Spell", ID = 7744      }),
    Canibalize                            = Create({ Type = "Spell", ID = 20577     }),
    WarStomp                              = Create({ Type = "Spell", ID = 20549     }),
    Berserking                            = Create({ Type = "Spell", ID = 26297     }),
    ArcaneTorrent                         = Create({ Type = "Spell", ID = 28730     }),
    PackHobGoblin                         = Create({ Type = "Spell", ID = 69046     }),
    RocketBarrage                         = Create({ Type = "Spell", ID = 69041     }),
    RocketJump                            = Create({ Type = "Spell", ID = 69070     }),
    ArcanePulse                           = Create({ Type = "Spell", ID = 260364    }),
    Cantrips                              = Create({ Type = "Spell", ID = 255661    }),
    BullRush                              = Create({ Type = "Spell", ID = 255654    }),
    AncestralCall                         = Create({ Type = "Spell", ID = 274738    }),
    EmbraceoftheLoa                       = Create({ Type = "Spell", ID = 292752    }),
    PterrordaxSwoop                       = Create({ Type = "Spell", ID = 281954    }),
    Regeneratin                           = Create({ Type = "Spell", ID = 291944    }),
    BagofTricks                           = Create({ Type = "Spell", ID = 312411    }),
    MakeCamp                              = Create({ Type = "Spell", ID = 312370    }),
    ReturntoCamp                          = Create({ Type = "Spell", ID = 312372    }),
    RummageyourBag                        = Create({ Type = "Spell", ID = 312425    }),
    --Neutral
    SkywardAscent                         = Create({ Type = "Spell", ID = 376744    }),
    Soar                                  = Create({ Type = "Spell", ID = 369536    }),
    SurgeForward                          = Create({ Type = "Spell", ID = 376743    }),
    TailSwipe                             = Create({ Type = "Spell", ID = 368970    }),
    WingBuffet                            = Create({ Type = "Spell", ID = 357214    }),

    --AntiFakeStuff
	AntiFakeKick                          = Create({ Type = "SpellSingleColor", ID = 351338, Hidden = true,		Color = "GREEN"	, Desc = "[2] AntiFakeKick",    QueueForbidden = true	}),
	AntiFakeCC						      = Create({ Type = "SpellSingleColor", ID = 360806, Hidden = true,		Color = "RED"	, Desc = "[1] AntiFakeCC",      QueueForbidden = true	}),

    --Evoker General
    AzureStrike                           = Create({ Type = "Spell", ID = 362969     }),
    BlessingoftheBronze                   = Create({ Type = "Spell", ID = 364342     }),
    CauterizingFlame                      = Create({ Type = "Spell", ID = 374251     }),
    ChronoLoop                            = Create({ Type = "Spell", ID = 383005     }),
    DeepBreath                            = Create({ Type = "Spell", ID = 357210     }),
    Disintegrate                          = Create({ Type = "Spell", ID = 356995     }),
    EmeraldBlossom                        = Create({ Type = "Spell", ID = 355913     }),
    FireBreath                            = Create({ Type = "Spell", ID = 382266     }),
    FireBreathToo                         = Create({ Type = "Spell", ID = 357208     }),
    FuryoftheAspects                      = Create({ Type = "Spell", ID = 390386     }),
    Hover                                 = Create({ Type = "Spell", ID = 358267, Macro = "/cast time spiral\n/cast hover"     }),
    Landslide                             = Create({ Type = "Spell", ID = 358385     }),
    LivingFlame                           = Create({ Type = "Spell", ID = 361469, Texture = 375554    }),
    LivingFlameDMG                        = Create({ Type = "Spell", ID = 361469, Texture = 375554, Color = "BLUE" }),
    ObsidianScales                        = Create({ Type = "Spell", ID = 363916     }),
    Rescue                                = Create({ Type = "Spell", ID = 370665, Macro = "/tar [@focus]\n/cast [@cursor] spell:thisID\n/targetlasttarget"     }),
    Return                                = Create({ Type = "Spell", ID = 361227     }),
    TiptheScales                          = Create({ Type = "Spell", ID = 370553     }),
    VerdantEmbrace                        = Create({ Type = "Spell", ID = 360995     }),
    Zephyr                                = Create({ Type = "Spell", ID = 374227     }),
    Quell                                 = Create({ Type = "Spell", ID = 351338     }),
    SleepWalk                             = Create({ Type = "Spell", ID = 360806     }),
    SourceofMagic                         = Create({ Type = "Spell", ID = 369459     }),
    Unravel                               = Create({ Type = "Spell", ID = 368432     }),
    OpressingRoar                         = Create({ Type = "Spell", ID = 372048     }),
    RenewingBlaze                         = Create({ Type = "Spell", ID = 374348     }),
    TimeSpiral                            = Create({ Type = "Spell", ID = 374968     }),
    --Preservation
    DreamBreath                           = Create({ Type = "Spell", ID = 382614    }),
    DreamBreathToo                        = Create({ Type = "Spell", ID = 355936    }),
    DreamBreathBuff                       = Create({ Type = "Spell", ID = 355941    }),
    DreamFlight                           = Create({ Type = "Spell", ID = 359816    }),
    Echo                                  = Create({ Type = "Spell", ID = 364343    }),
    MassReturn                            = Create({ Type = "Spell", ID = 361178    }),
    Naturalize                            = Create({ Type = "Spell", ID = 360823    }),
    Reversion                             = Create({ Type = "Spell", ID = 366155    }),
    ReversionEcho                         = Create({ Type = "Spell", ID = 367364    }),
    Rewind                                = Create({ Type = "Spell", ID = 363534    }),
    SpiritBloom                           = Create({ Type = "Spell", ID = 382731    }),
    SpiritBloomToo                        = Create({ Type = "Spell", ID = 367226    }),
    TimeDilation                          = Create({ Type = "Spell", ID = 357170    }),
    EssenceBurst                          = Create({ Type = "Spell", ID = 369297    }),
    EmeraldCommunion                      = Create({ Type = "Spell", ID = 370960    }),
    TemporalAnomaly                       = Create({ Type = "Spell", ID = 373861    }),
    Stasis                                = Create({ Type = "Spell", ID = 370537    }),
    StasisHeal                            = Create({ Type = "Spell", ID = 370562, Hidden = true     }),
    FontofMagic                           = Create({ Type = "Spell", ID = 375783    }),
    DreamProjection                       = Create({ Type = "Spell", ID = 377509    }),
    CallofYsera                           = Create({ Type = "Spell", ID = 373834, Hidden = true  }),
    Lifespark                             = Create({ Type = "Spell", ID = 394552, Hidden = true  }),
    NullifyingShroud                      = Create({ Type = "Spell", ID = 378464    }),
    GoldenHour                            = Create({ Type = "Spell", ID = 378196, Hidden = true  }),
    --EnergyLoop Talent
    EnergyLoop                            = Create({ Type = "Spell", ID = 372233, Hidden = true  }),
    --Improved Dispel
    ImprovedDispelTalent                  = Create({ Type = "Spell", ID = 360823, Hidden = true  }),
    --PVP
    ObsidianMettle                        = Create({ Type = "Spell", ID = 378444, Hidden = true  }),
    SwoopUp                               = Create({ Type = "Spell", ID = 370388, Hidden = true  }),
    --Other
    BlessingBuff                          = Create({ Type = "Spell", ID = 381748, Hidden = true  }),
    LifesparkBuff                         = Create({ Type = "Spell", ID = 394552, Hidden = true  }),
    --Hero Talent Stuff
    ChronoFlames                          = Create({ Type = "Spell", ID = 431443, Texture = 133667  }),
    --ChronoFlamesDMG                       = Create({ Type = "Spell", ID = 431443, Texture = 20589  }), 
    --ChronoFlamesTalent                    = Create({ Type = "Spell", ID = 431442, Hidden = true  }),
    Engulf                                = Create({ Type = "Spell", ID = 443328, Macro = "/cast [@player] Engulf"     }),

    
}

--################################################################################################################################################################################################################

local A = setmetatable(Action[ACTION_CONST_EVOKER_PRESERVATION], { __index = Action })

Aware:enable()

local mouseover               = "mouseover"
local player                  = "player"
local focus                   = "focus"
local target                  = "target"

local Temp                    = {
    TotalAndPhys              = {"TotalImun", "DamagePhysImun"},
    TotalAndMag               = {"TotalImun", "DamageMagicImun"},
    TotalAndPhysKick          = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndMagKick           = {"TotalImun", "DamageMagicImun", "KickImun"},
    TotalAndPhysAndCC         = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndMagAndCC          = {"TotalImun", "DamageMagicImun", "CCTotalImun"},
    TotalAndPhysAndStun       = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndMagAndStun        = {"TotalImun", "DamageMagicImun", "StunImun"},
    TotalAndPhysAndCCAndStun  = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagAndCCAndStun   = {"TotalImun", "DamageMagicImun", "CCTotalImun", "StunImun"},
    DisablePhys               = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked      = {},
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local RootTable = {
    339, --entangling roots
    122, --frost nova
    102359, --mass entanglement
    51485, --earthgrab totem
    162488, --steel trap
    212638, --tracker's net
    64695, -- earthgrab totem
    358385, --Landslide
    114404, -- void tendrils
    433662, -- Grasping Blood
    432031, -- Grasping Blood 2
    434083, -- Ambush
    431494, -- Black Edge
    324859, -- Bramblethorn Entanglement
    328664, -- Chilled
    464876, -- Concussive Smash
    450095, -- Curse of Entropy
    326092, -- Debilitating Poison
    431309, -- Ensnaring Shadows
    448215, -- Expel Webs
    320788, -- Frozen Binds
    433785, -- Grasping Slash
    425974, -- Ground Pound
    440238, -- Ice Sickles
    451871, -- Mass Tremor
    428161, -- Molten Metal
    322486, -- Overgrowth
    443430, -- Silk Binding
    434722, -- Subjugate
    340300, -- Tongue Lashing
    456773, -- Twilight Wind
    446718, -- Umbral Weave
    439324, -- Umbral Weave
    443427, -- Web Bolt
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CauterizingFlameDispelTable = {
    --PVP Bleed
    115767, --deep wounds
    262115, --deep wounds 2
    772, --rend
    703, --garrote
    1943, --rupture
    16511, --hemorrhage
    1079, --rip
    1822, --rake
    360194, --deathmark
    217200, --barbed shot
    253384, --slaughter
    372860, --searing wounds
    209858, --necrotic wound
    324149, --flayed shot
    325037, --death chakram
    385060, --odyn's fury
    384318, --thunderous roar
    274837, --feral frenzy
    --PVP Curse
    18223, --curse of exhaustion
    702, --curse of weakness
    980, --agony
	199890, -- curse of toungues
    --PVP Disease
    335467, --devouring plague
    191587, --virulent plague
    360194, --deathmark
    --PVP Poison
}

local BigDefBuff = {
    186265, -- Turtle
    642, -- Bubble
    45438, -- Block
}

local kickList    = {
    [1064] = true,   -- chain heal
    [2061] = true,   -- Flash heal,
    [8004] = true,   -- Healing surge
    [8936] = true,   -- Regrowth
    [19750] = true,  -- Flash heal
    [32375] = true,  -- Mass dispel
    [47540] = true,  -- Penance
    [48438] = true,  -- Wild Growth
    [64843] = true,  -- Divine hymn
    [77472] = true,  -- Healing wave
    [82326] = true,  -- Holy light
    [115175] = true, -- Soothing Mist
    [116670] = true, -- Vivify
    --[120517] = true, -- Halo
    [124682] = true, -- Enveloping
    [191837] = true, -- Essense font
    [194509] = true, -- Radiance
    [200652] = true, -- Tyr's
    [234153] = true, -- Drain life
    [289666] = true, -- Greater heal
    [202771] = true, -- Full Moon
    [274283] = true, -- Other full moon?
    [316009] = true, -- UA
    [199786] = true, --Glacial Spike
    [118] = true, --Polymorph
    [51514] = true, --Hex
    [33786] = true, --Cyclone
    [198898] = true, --Song of Chi-Ji
    [421543] = true, --Ultimate Penitence
    [20066] = true, --Repentance
    [5782] = true, --Fear
    --[30108] = true, --UA
    [356995] = true, --Distintgrate
    [359073] = true, -- Eternity Surge
    [360806] = true, -- Sleep walk
    [410126] = true, -- searing glare
    [390612] = true, -- frostbomb
}

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
    --[47476] = true,  -- strangulate
    [410201] = true, -- searing glare
    
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

    --[375901] = true, -- mindgames new 2
    [80240] = true,  -- havoc
    [325640] = true,  -- soul rot
    [390612] = true, -- frost bomb
}


local function tempSpellCooldown(spellID)
    local cooldownInfo = C_Spell.GetSpellCooldown(spellID)
    if cooldownInfo and cooldownInfo.isEnabled then
        local start = cooldownInfo.startTime
        local duration = cooldownInfo.duration
        local modRate = cooldownInfo.modRate or 1

        if duration > 0 then
            local remaining = (start + duration - GetTime()) / modRate
            return remaining
        else
            return 0 -- No cooldown
        end
    end
    return nil -- Spell is not usable or invalid spell ID
end

local function isPlayerCastingSpell(spellID)
    -- Get the name, start time, and end time of the current spell being cast by the player
    local spellName, _, _, _, startTime, endTime, _, castSpellID = UnitCastingInfo("player")

    -- Check if the player is casting a spell and if it matches the given spell ID
    if castSpellID == spellID then
        return true
    else
        return false
    end
end

local function RotationsVariables()
    --Default Variables
    isMoving                        = ActionPlayer:IsMoving()
    isStaying                       = ActionPlayer:IsStaying()
    combatTime                      = Unit(player):CombatTime()
    movingTime                      = ActionPlayer:IsMovingTime()
    stayingTime                     = ActionPlayer:IsStayingTime()
    PlayerHealth                    = Unit(player):HealthPercent()
    IsInMeleeRange                  = Unit(target):GetRange() < 5
    IsInCasterRange                 = Unit(target):GetRange() < 40
    MeleeMultiUnits                 = MultiUnits:GetByRange(25)
    --RangeMultiUnits               = MultiUnits:GetActiveEnemies(40)

    weAreInPve                      = (Action.Zone ~= "arena" and Action.Zone ~= "pvp")
	weAreInPvp 						= (Action.Zone == "arena" or Action.Zone == "pvp")

    SpiritBloomEmpower              = GetToggle(2, "SpiritSlider")
    DreamBreathEmpower              = GetToggle(2, "DreamSlider")
    FireBreathEmpower               = GetToggle(2, "FireBreathSlider")
    ExpiringStasisBuff              = Unit(player):HasBuffs(A.StasisHeal.ID) > 0 and Unit(player):HasBuffs(A.StasisHeal.ID) < 5
    HaveStasisBuff                  = Unit(player):HasBuffs(A.StasisHeal.ID) > 0 and Unit(player):HasBuffs(A.StasisHeal.ID) < 30
    CallofYseraBuffUp               = Unit(player):HasBuffs(373834) > 0

    HaveHoverBuff                   = Unit(player):HasBuffs(A.Hover.ID) > 0
    HaveTipbuff                     = Unit(player):HasBuffs(A.TiptheScales.ID) > 0
    MovementCheck                   = (isStaying or HaveHoverBuff)
    EmpowerMovement                 = (isStaying or HaveTipbuff)
end

local function canDispel(unitID)
    if A.Zone ~= "arena" or HealingEngine.GetBelowHealthPercentUnits(35) > 0 then 
        return false 
    end

    local randomThreshold = math.random(500, 800) / 1000 -- Convert to seconds
    local dispelWindow = 2 -- Time in seconds before debuff expires to not dispel

    for i = 1, 40 do -- Iterate over debuffs
        local aura = C_UnitAuras.GetDebuffDataByIndex(unitID, i)
        if not aura then
            break
        end

        if arenaDispelDebuffs[aura.spellId] then
            local startTime = aura.expirationTime - aura.duration
            local currentTime = GetTime()
            local elapsed = currentTime - startTime
            local remainingTime = aura.expirationTime - currentTime

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

local function arenaInterrupt(unitID)
    local hasKickImun = Unit(unitID):HasBuffs("KickImun")
    local hasReflect = Unit(unitID):HasBuffs("Reflect")
    local hasPrecog = Unit(unitID):HasBuffs(377360)

    if hasKickImun > 0 or hasReflect > 0 or hasPrecog > 0 then
        return false
    end

    local randomKickTime = math.random(500, 750) / 1000 
    local castTime = getCastTime(unitID)

    for spellID, _ in pairs(kickList) do
        local isCastingRemains = Unit(unitID):IsCastingRemains(spellID)

        if isCastingRemains > 0 and castTime > randomKickTime then
            return true 
        end
    end

    return false 
end

local function ArenaHealthThreshold(threshhold)
    if (_G.UnitExists("arena1") and Action.Unit("arena1"):HealthPercent() <= threshhold) or (_G.UnitExists("arena2") and Action.Unit("arena2"):HealthPercent() <= threshhold) or (_G.UnitExists("arena3") and Action.Unit("arena3"):HealthPercent()<= threshhold) then
        return true
    end
    return false

end

local function StunHealerInArenaNew(unitID, threshhold, ccDur, ccType, byPassHeals, DR)
    if ArenaHealthThreshold(threshhold) then
        if (Action.Unit(unitID):IsHealer() or byPassHeals) and not UnitIsUnit(unitID, "target") and Action.Unit(unitID):HasDeBuffs("BreakAble") == 0 and Action.Unit(unitID):InCC() <= ccDur and Action.Unit(unitID):GetDR(ccType) >= DR then
            return true
        end
    end
    return false
end

local function canHeal(unitID)
    if Unit(unitID):HasDeBuffs(33786) > 0 then
        return false
    end
    return true 
end

local function shouldPS(unitID)
    if Unit(unitID):HasBuffs(186265, nil, true) > 0 or Unit(unitID):HasBuffs(642, nil, true) > 0 or Unit(unitID):HasBuffs(79811, nil, true) > 0 or Unit(unitID):HasBuffs(196555, nil, true) > 0 or Unit(unitID):HasBuffs(118038, nil, true) > 0 then
        return false
    end
    return true 
end

local GetEmpowerStageForCurrent = LPH_NO_VIRTUALIZE(function()
    local unit = "player"
    local _, _, _, start, endTime, _, _, spellID, _, numStages = UnitChannelInfo(unit);

    if not spellID or not numStages or numStages == 0 then
        return 0, nil
    end

    local stageStart = start
    for i = 0, numStages - 1 do
        local duration = GetUnitEmpowerStageDuration(unit, i)
        local ourStageStart = stageStart

        stageStart = stageStart + duration

        if stageStart / 1000 > TMW.time then
            return i, spellID, (((ourStageStart + 50) / 1000) > TMW.time)
        end
    end

    return numStages + 1, spellID
end)

local handleStages = LPH_NO_VIRTUALIZE(function(icon)
    local empowerStage, spellID, holdLonger = GetEmpowerStageForCurrent()
    local activeEnemies = MultiUnits:GetByRangeAppliedDoTs(nil, 5, 357209) -- Amount of units hit by Fire Breath

    if activeEnemies == 0 then
        activeEnemies = 2
    end

    if holdLonger then
        return spellID, false
    end

    if empowerStage > 0 then
        if empowerStage >= FireBreathEmpower and (spellID == 357208 or spellID == 382266) then -- Fire Breath spellID
            return A.FireBreath:Show(icon), true
        end

        if empowerStage >= SpiritBloomEmpower and (spellID == 382731 or spellID == 367226) then -- Spiritbloom spellID
            return A.SpiritBloom:Show(icon), true
        end

        if empowerStage >= DreamBreathEmpower and (spellID == 382614 or spellID == 355936) then -- Dream Breath spellID
            return A.DreamBreath:Show(icon), true
        end
    end

    return spellID, false
end)

local function TeamIsSafe(threshhold)
    if HealingEngine.GetBelowHealthPercentUnits(threshhold) < 1 then
        return true
    end
    return false
end

local function shouldStopSleep(unitID)
    if (Unit(unitID):InCC() > 1.5 or (Unit(unitID):HasBuffs(204336) > 0 or Unit(unitID):HasBuffs(642) > 0 or Unit(unitID):HasBuffs(740) > 0 or Unit(unitID):HasBuffs(421453) > 0 or Unit(unitID):HasBuffs(6940) > 0 or Unit(unitID):HasBuffs(408557) > 0 or Unit(unitID):HasBuffs(377360) >0)) then
        return true
    end

    if Unit("player"):HasDeBuffs(32379) > 0 then
        return true
    end
    
    return false
end

FakeCasting.enable()

FakeCasting.blacklist({
  [370960] = true, -- em com
  [382731] = true, -- spiritbloom
  [367226] = true, -- spiritbloomtoo
  [382614] = true, -- dreambreath
  [355936] = true, -- dreambreathtoo
  [431443] = true, -- Chrono Flames
  [356995] = true, -- disintegrate
  [382266] = true, -- firebreath


})


local function PvpHealingRotation(unitID, icon)
    RotationsVariables()
    local ShouldPVPAoe                   = HealingEngine.GetBelowHealthPercentUnits(50) >= 2
    local ShouldPVPBigAoe                = HealingEngine.GetBelowHealthPercentUnits(50) >= 3
    local unitIsImmune = Unit(unitID):HasBuffs(45438) > 0 or Unit(unitID):HasBuffs(642) > 0
    local LifesparkCount = Unit(player):HasBuffsStacks(A.LifesparkBuff.ID)
    local shouldAware = GetToggle(2, "makAware")


    --LivingFlame Snipe
    if A.LivingFlame:IsReady(target) and LifesparkCount > 0 and TeamIsSafe(50) and Unit(target):HealthPercent() <= 45 then LivingFlameCastType = 2 return A.LivingFlameDMG:Show(icon) end

    --Distintegrate Snipe
    if A.Disintegrate:IsReady(target) and MovementCheck and TeamIsSafe(50) and Unit(target):HealthPercent() <= 35 then  return A.Disintegrate:Show(icon) end
    
    
    --TailSwipe (Kick)
    if A.TailSwipe:IsReady() and not A.Quell:IsReady() and TeamIsSafe(60) and ((arenaInterrupt("arena1") and Unit("arena1"):GetRange() <= 5) or (arenaInterrupt("arena2") and Unit("arena2"):GetRange() <= 5) or (arenaInterrupt("arena3") and Unit("arena3"):GetRange() <= 5)) and A.TailSwipe:AbsentImun(unitID, Temp.TotalAndMagKick, true) then return A.TailSwipe:Show(icon) end
    

    
    if canHeal(unitID) then
        --Consume stasis if expiring or if we need heals (type based)
        if A.Stasis:IsReady() and Unit(unitID):HealthPercent() > 30
            and Unit(player):HasBuffs(A.Stasis.ID) == 0 
            and (tempSpellCooldown(A.Stasis.ID) == nil or tempSpellCooldown(A.Stasis.ID) < 0.35)
            and (
                (Unit(player):HasBuffs(A.StasisHeal.ID) > 0 and Unit(unitID):HealthPercent() <= 60 and Unit(unitID):HasBuffs(355941) <= 2) 
                or 
                (Unit(player):HasBuffs(A.StasisHeal.ID) > 0 and Unit(player):HasBuffs(A.StasisHeal.ID) < 5 and Unit(unitID):HasBuffs(355941) <= 2)
                ) 
        then 
            return A.Stasis:Show(icon) 
        end
        --TIP + Spiritbloom emergency
        if not unitIsImmune and A.SpiritBloom:IsReady(unitID) and IsPlayerSpell(A.SpiritBloom.ID) and tempSpellCooldown(A.SpiritBloom.ID) < .35 and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and (A.TiptheScales:GetCooldown() == 0 or Unit(player):HasBuffs(A.TiptheScales.ID) > 0) and Unit(unitID):HasBuffs(A.Rewind.ID) == 0 and Unit(unitID):HasDeBuffs(BigDefBuff) == 0 and EmpowerMovement and Unit(unitID):HealthPercent() <= 40 then if A.TiptheScales:IsReady() and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then return A.TiptheScales:Show(icon) end return A.SpiritBloom:Show(icon) end
        if not unitIsImmune and A.SpiritBloomToo:IsReady(unitID) and IsPlayerSpell(A.SpiritBloomToo.ID)  and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and tempSpellCooldown(A.SpiritBloom.ID) < .35 and (A.TiptheScales:GetCooldown() == 0 or Unit(player):HasBuffs(A.TiptheScales.ID) > 0) and Unit(unitID):HasBuffs(A.Rewind.ID) == 0 and Unit(unitID):HasDeBuffs(BigDefBuff) == 0 and EmpowerMovement and Unit(unitID):HealthPercent() <= 40 then if A.TiptheScales:IsReady() and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then return A.TiptheScales:Show(icon) end return A.SpiritBloomToo:Show(icon) end

        --Rewind emergency
        if not unitIsImmune and A.Rewind:IsReady() and A.LivingFlame:IsReady(unitID) and Unit(unitID):HealthPercent() <= 45 and shouldPS(unitID) and Unit(unitID):HasDeBuffs(BigDefBuff) == 0 and not A.Rewind:IsSuspended(.5,1) then
            return A.Rewind:Show(icon)
        end
        
        --Emerald Communion emergency
        if not unitIsImmune and A.EmeraldCommunion:IsReady() and A.LivingFlame:IsReady(unitID) and Unit(unitID):HasDeBuffs(BigDefBuff) == 0 and Unit(unitID):HealthPercent() <= 35  then return A.EmeraldCommunion:Show(icon) end

        --Instant Cast Big Living Flame Emergency
        if A.LivingFlame:IsReady(unitID) and Unit(player):HasBuffs(A.Lifespark.ID) > 0  and Unit(unitID):HealthPercent() <= 30 then LivingFlameCastType = 1 return A.LivingFlame:Show(icon) end

        --Chrono Flames Big Living Flame Emergency
        --if A.ChronoFlames:IsReady(unitID) and IsPlayerSpell(A.ChronoFlamesTalent.ID) and Unit(player):HasBuffs(A.Lifespark.ID) > 0  and Unit(unitID):HealthPercent() <= 30 then LivingFlameCastType = 1 return A.ChronoFlames:Show(icon) end

        --TimeDilation to slow pressure
        if not unitIsImmune and A.TimeDilation:IsReady(player) and Unit(unitID):HealthPercent() <= 80 and Unit(unitID):HealthPercent() > 40 and combatTime > 0 then
            return A.TimeDilation:Show(icon)
        end

	    --Stasis Stuff
	    local stasisCooldown = tempSpellCooldown(A.Stasis.ID)
	    local stasisPreset   = GetToggle(2, "StasisPreset") or 1

	    -- If the UI preset is set to "Off" (1) in PvE content, don't automatically set up
	    -- a Stasis combo. This keeps dungeon behavior in line with the dropdown.
	    if not (weAreInPve and stasisPreset == 1) then
	        if A.Stasis:IsReady() and (stasisCooldown == nil or stasisCooldown < 0.35)
	            and Unit(player):HasBuffs(A.Stasis.ID) == 0
	            and A.VerdantEmbrace:GetCooldown() <= 1
	            and A.DreamBreath:GetCooldown() <= 2
	            and Unit(unitID):HealthPercent() <= 95
	            and A.LivingFlame:IsReady(unitID)
	        then
	            return A.Stasis:Show(icon)
	        end
	    end
        if A.VerdantEmbrace:IsReady(unitID) and Unit(unitID):HealthPercent() <= 95 and Unit(player):HasBuffs(A.Stasis.ID) > 0 and Unit(player):HasDeBuffs(RootTable) == 0 then return A.VerdantEmbrace:Show(icon) end
        if A.Echo:IsReady(player) and Unit(player):HasBuffs(A.Stasis.ID) > 0 and Unit(unitID):HasBuffs(A.Echo.ID, true) == 0 then return A.Echo:Show(icon) end
        --if A.SpiritBloom:IsReady(unitID) and EmpowerMovement and Unit(player):IsDebuffDown(MindgamesDebuff) and Unit(unitID):HealthPercent() <= 65 and Unit(player):IsBuffUp(A.Stasis.ID) and Unit(unitID):IsBuffUp(A.Echo.ID, true) then StasisType = 1 return A.SpiritBloom:Show(icon) end
        -- DreamBreath during Stasis WITH Call of Ysera talent (requires buff)
        if A.DreamBreath:IsReady() and IsPlayerSpell(A.DreamBreath.ID) and A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and Unit(player):HasBuffs(373835) > 0 and EmpowerMovement and Unit(player):HasBuffs(A.Stasis.ID) > 0 and A.LivingFlame:IsReady(unitID) and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 and Unit(player):HasBuffs(A.Stasis.ID) > 0 then  StasisType = 2 return A.DreamBreath:Show(icon) end
        if A.DreamBreathToo:IsReady(player) and IsPlayerSpell(A.DreamBreathToo.ID) and A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and tempSpellCooldown(A.DreamBreath.ID) < .35 and Unit(player):HasBuffs(373835) > 0 and EmpowerMovement and Unit(player):HasBuffs(A.Stasis.ID) > 0 and A.LivingFlame:IsReady(unitID) and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 and Unit(player):HasBuffs(A.Stasis.ID) > 0 then  StasisType = 2 return A.DreamBreathToo:Show(icon) end
        -- DreamBreath during Stasis WITHOUT Call of Ysera talent (Chronowarden builds)
        if A.DreamBreath:IsReady() and IsPlayerSpell(A.DreamBreath.ID) and not A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and EmpowerMovement and Unit(player):HasBuffs(A.Stasis.ID) > 0 and A.LivingFlame:IsReady(unitID) and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 then  StasisType = 2 return A.DreamBreath:Show(icon) end
        if A.DreamBreathToo:IsReady(player) and IsPlayerSpell(A.DreamBreathToo.ID) and not A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and tempSpellCooldown(A.DreamBreath.ID) < .35 and EmpowerMovement and Unit(player):HasBuffs(A.Stasis.ID) > 0 and A.LivingFlame:IsReady(unitID) and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 then  StasisType = 2 return A.DreamBreathToo:Show(icon) end

        --Verdant Embrace @ higher health now to get proc for spiritbloom and target has echo and player not rooted (TESTING NO ECHO)
        if A.VerdantEmbrace:IsReady(unitID) and Unit(unitID):HealthPercent() <= 95  and Unit(player):HasDeBuffs(RootTable) == 0 then return A.VerdantEmbrace:Show(icon) end

        --DreamBreath (@level1) after Verdant Infusion to take advantage of 40% bonus for ST (no TIP) - higher prio than Normal Spirit Bloom (WITH Call of Ysera)
        if A.DreamBreath:IsReady() and IsPlayerSpell(A.DreamBreath.ID) and A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35  and EmpowerMovement  and A.LivingFlame:IsReady(unitID) and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) and Unit(player):HasBuffs(373835) > 0 then
            if shouldAware then Aware:displayMessage("Casting Dream Breath - Aim at Party.", "White", 1) end
            return A.DreamBreath:Show(icon)
        end
        if A.DreamBreathToo:IsReady() and IsPlayerSpell(A.DreamBreathToo.ID) and A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35  and EmpowerMovement  and A.LivingFlame:IsReady(unitID) and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) and Unit(player):HasBuffs(373835) > 0 then
            if shouldAware then Aware:displayMessage("Casting Dream Breath - Aim at Party.", "White", 1) end
            return A.DreamBreathToo:Show(icon)
        end
        --DreamBreath (@level1) for Chronowarden builds WITHOUT Call of Ysera
        if A.DreamBreath:IsReady() and IsPlayerSpell(A.DreamBreath.ID) and not A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and EmpowerMovement and A.LivingFlame:IsReady(unitID) and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) then
            if shouldAware then Aware:displayMessage("Casting Dream Breath - Aim at Party.", "White", 1) end
            return A.DreamBreath:Show(icon)
        end
        if A.DreamBreathToo:IsReady() and IsPlayerSpell(A.DreamBreathToo.ID) and not A.CallofYsera:IsTalentLearned() and tempSpellCooldown(A.DreamBreath.ID) < .35 and tempSpellCooldown(A.DreamBreathToo.ID) < .35 and EmpowerMovement and A.LivingFlame:IsReady(unitID) and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) then
            if shouldAware then Aware:displayMessage("Casting Dream Breath - Aim at Party.", "White", 1) end
            return A.DreamBreathToo:Show(icon)
        end

             
        --Instant Big Living Flame
        if A.LivingFlame:IsReady(player) and IsPlayerSpell(A.LivingFlame.ID) and Unit(player):HasBuffs(A.Lifespark.ID) > 0 and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) and Unit(unitID):HealthPercent() <= 55 then LivingFlameCastType = 1 return A.LivingFlame:Show(icon) end

        --Instance Big Chrono Flames
        --if A.ChronoFlames:IsReady(unitID) and IsPlayerSpell(A.ChronoFlamesTalent.ID) and Unit(player):HasBuffs(A.Lifespark.ID) > 0 and (Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 or ActionPlayer:Essence() < 2) and Unit(unitID):HealthPercent() <= 55 then LivingFlameCastType = 1 return A.ChronoFlames:Show(icon) end
        
        --Temporal Anomoly
        if A.TemporalAnomaly:IsReady() and A.LivingFlameDMG:IsReady(target) and (UnitExists("party4") or UnitExists("raid4")) and Action.Zone ~= "arena" and tempSpellCooldown(A.TemporalAnomaly.ID) < .35 and combatTime > 0 and HealingEngine.GetBelowHealthPercentUnits(90) >= 2 and HealingEngine.GetBelowHealthPercentUnits(40) == 0 and EmpowerMovement then return A.TemporalAnomaly:Show(icon) end
   
        
        --TIP + Spiritbloom emergency multi target (higher HP)
        if A.SpiritBloom:IsReady() and IsPlayerSpell(A.SpiritBloom.ID) and (A.SpiritBloom.ID) and tempSpellCooldown(A.SpiritBloom.ID) < .35 and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and EmpowerMovement and A.TiptheScales:GetCooldown() == 0 and ShouldPVPBigAoe then if A.TiptheScales:IsReady() and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then return A.TiptheScales:Show(icon) end return A.SpiritBloom:Show(icon) end
        if A.SpiritBloomToo:IsReady(player) and IsPlayerSpell(A.SpiritBloomToo.ID)  and (A.SpiritBloomToo.ID) and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and tempSpellCooldown(A.SpiritBloom.ID) < .35 and EmpowerMovement and A.TiptheScales:GetCooldown() == 0 and ShouldPVPBigAoe then if A.TiptheScales:IsReady() and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then return A.TiptheScales:Show(icon) end return A.SpiritBloomToo:Show(icon) end
    
        --Lets test some more aggressive firebreath
        if A.FireBreath:IsReady() and IsPlayerSpell(A.FireBreath.ID)  and tempSpellCooldown(A.FireBreath.ID) < .35 and tempSpellCooldown(A.FireBreathToo.ID) < .35 and A.LivingFlameDMG:IsReady(target) and IsUnitEnemy(target) and isStaying and HealingEngine.GetBelowHealthPercentUnits(70) == 0 and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then 
            if shouldAware then Aware:displayMessage("Casting Firebreath.", "White", 1) end
            return A.FireBreath:Show(icon) 
        end
        if A.FireBreathToo:IsReady() and IsPlayerSpell(A.FireBreathToo.ID) and tempSpellCooldown(A.FireBreathToo.ID) < .35 and tempSpellCooldown(A.FireBreath.ID) < .35 and A.LivingFlameDMG:IsReady(target) and IsUnitEnemy(target) and isStaying and HealingEngine.GetBelowHealthPercentUnits(70) == 0 and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then 
            if shouldAware then Aware:displayMessage("Casting Firebreath.", "White", 1) end
            return A.FireBreathToo:Show(icon) 
        end
        --Reversion
        if A.Reversion:IsReady(player) and Unit(unitID):HasBuffs(A.Reversion.ID, true) < 2 and Unit(unitID):HealthPercent() <= 95 and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 then 
            return A.Reversion:Show(icon) 
        end

        --Reversion (Save)
        if A.Reversion:IsReady(player) and Unit(unitID):HealthPercent() <= 40 then return A.Reversion:Show(icon) end
        
        --Echo
        if A.Echo:IsReady(player) and Unit(unitID):HasBuffs(A.Echo.ID, true) == 0 and Unit(unitID):HealthPercent() <= 95 then return A.Echo:Show(icon) end
        
        --DreamBreath with TIP after Verdant Infusion to take advantage of 40% bonus for AOE
        --if A.DreamBreath:IsReady() and A.TiptheScales:GetCooldown() == 0 and combatTime > 0 and EmpowerMovement and Unit(player):HasBuffs(373835) > 0 and A.LivingFlame:IsReady(unitID) then if A.TiptheScales:IsReady() and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then return A.TiptheScales:Show(icon) end return A.DreamBreath:Show(icon) end
        
        --SpiritBloom normal with echo
        if A.SpiritBloom:IsReady() and IsPlayerSpell(A.SpiritBloom.ID) and tempSpellCooldown(A.SpiritBloom.ID) < .35 and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and EmpowerMovement and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 and Unit(unitID):HealthPercent() <= 75 then return A.SpiritBloom:Show(icon) end
        if A.SpiritBloomToo:IsReady() and IsPlayerSpell(A.SpiritBloomToo.ID) and tempSpellCooldown(A.SpiritBloomToo.ID) < .35 and tempSpellCooldown(A.SpiritBloom.ID) < .35 and EmpowerMovement and Unit(unitID):HasBuffs(A.Echo.ID, true) > 0 and Unit(unitID):HealthPercent() <= 75 then return A.SpiritBloomToo:Show(icon) end
    
        --DreamBreath Normal with echo
        --if A.DreamBreath:IsReady() and Unit(player):IsDebuffDown(MindgamesDebuff) and Unit(unitID):IsBuffUp(A.Echo.ID, true) and EmpowerMovement and Unit(unitID):HealthPercent() < 80 and Unit(unitID):GetRange() <=27 then return A.DreamBreath:Show(icon) end
        
        --Engulf Test
        if A.Engulf:IsReady(player) and Unit(unitID):HealthPercent() <= 80 and Unit(player):HasBuffs(A.DreamBreathBuff.ID, true) > 0 then 
            return A.Engulf:Show(icon) 
        end
        
        --Cauterizing Flame based on new cauterizing flame table (to avoid dispel sniper)
        if A.CauterizingFlame:IsReady(player) and Unit(unitID):HasDeBuffs(CauterizingFlameDispelTable) > 0 then return A.CauterizingFlame:Show(icon) end

        --Rescue
        if A.Rescue:IsReady(unitID) and Unit(unitID):HealthPercent() <= 50 and Unit(player):HasDeBuffs(RootTable) == 0 and not UnitIsUnit(unitID, "player") then 
            if shouldAware then Aware:displayMessage("Attempting to rescue.. Please choose a location.", "Blue", 1) end
            return A.Rescue:Show(icon) 
        end
        
        --LivingFlame Filler
        if A.LivingFlame:IsReady(player) and IsPlayerSpell(A.LivingFlame.ID) and (MovementCheck or LifesparkCount > 0) and Unit(unitID):HealthPercent() < 70 then LivingFlameCastType = 1 return A.LivingFlame:Show(icon) end

        --ChronoFlames Filler
        --if A.ChronoFlames:IsReady(unitID) and IsPlayerSpell(A.ChronoFlamesTalent.ID) and (MovementCheck or LifesparkCount > 0) and Unit(unitID):HealthPercent() < 70 then LivingFlameCastType = 1 return A.ChronoFlames:Show(icon) end

    end
    
    --Nullifying Shroud
    if Action.Zone == "arena" and A.NullifyingShroud:IsReady(unitID) and A.NullifyingShroud:IsTalentLearned() and TeamIsSafe(70) and MovementCheck and combatTime > 0 then return A.NullifyingShroud:Show(icon) end
end

local function DamageRotation(unitID, icon)
    RotationsVariables()

    local LifesparkCount = Unit(player):HasBuffsStacks(A.LifesparkBuff.ID)
    local ManaCheckforDps = Action.Player:ManaPercentage() <= 30
    local shouldAware = GetToggle(2, "makAware")
    if ManaCheckforDps then return end

    --This will skip all actions if our target/focus is out of range
    if not A.AzureStrike:IsReady(unitID) then return end
    if Action.Zone == "arena" then
        if HealingEngine.GetBelowHealthPercentUnits(70) == 0 then
            --FireBreath

            if A.FireBreath:IsReady() and IsPlayerSpell(A.FireBreath.ID) and tempSpellCooldown(A.FireBreath.ID) < .35 and tempSpellCooldown(A.FireBreathToo.ID) < .35  and IsUnitEnemy(target)  and A.LivingFlameDMG:IsReady(target) and isStaying and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then 
                if shouldAware then Aware:displayMessage("Casting Firebreath.", "White", 1) end
                return A.FireBreath:Show(icon) 
            end
            if A.FireBreathToo:IsReady() and IsPlayerSpell(A.FireBreathToo.ID)  and tempSpellCooldown(A.FireBreathToo.ID) < .35 and tempSpellCooldown(A.FireBreath.ID) < .35  and IsUnitEnemy(target)  and A.LivingFlameDMG:IsReady(target) and isStaying and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 then 
                if shouldAware then Aware:displayMessage("Casting Firebreath.", "White", 1) end
                return A.FireBreathToo:Show(icon) 
            end
            
            --Disintegrate
            if  A.Disintegrate:IsReady(unitID) and MovementCheck and A.EnergyLoop:IsTalentLearned() and Unit(player):HasBuffs(A.EssenceBurst.ID) > 0 then 
                if shouldAware then Aware:displayMessage("Casting disintegrate.", "Blue", 1) end
                return A.Disintegrate:Show(icon) end
            
            --LivingFlame
            if A.LivingFlameDMG:IsReady(unitID) and IsPlayerSpell(A.LivingFlame.ID) and (MovementCheck or LifesparkCount > 0) then LivingFlameCastType = 2 return A.LivingFlameDMG:Show(icon) end
        end
    else
        --DeepBreath
        if A.DeepBreath:IsReady() and isStaying and combatTime > 0 and (MeleeMultiUnits > 3 or Unit(unitID):IsBoss()) then return A.DeepBreath:Show(icon) end

        
        --FireBreath
        if A.FireBreath:IsReady() and IsPlayerSpell(A.FireBreath.ID) and tempSpellCooldown(A.FireBreath.ID) < .35 and tempSpellCooldown(A.FireBreath.ID) < .35  and isStaying and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 and Unit(unitID):TimeToDie() > 5 then return A.FireBreath:Show(icon) end
        if A.FireBreathToo:IsReady() and IsPlayerSpell(A.FireBreathToo.ID) and tempSpellCooldown(A.FireBreath.ID) < .35 and tempSpellCooldown(A.FireBreath.ID) < .35  and isStaying and Unit(player):HasDeBuffs(A.TiptheScales.ID) == 0 and Unit(unitID):TimeToDie() > 5 then return A.FireBreathToo:Show(icon) end
        
        --LivingFlame MultiTarget
        if A.LivingFlameDMG:IsReady(unitID) and IsPlayerSpell(A.LivingFlame.ID) and MovementCheck and Unit(player):HasBuffs(370901) > 0 and MeleeMultiUnits > 1 then LivingFlameCastType = 2 return A.LivingFlameDMG:Show(icon) end


        --ChronoFlames Multitarget
        --if A.ChronoFlamesDMG:IsReady(unitID) and IsPlayerSpell(A.ChronoFlamesTalent.ID) and MovementCheck and Unit(player):HasBuffs(370901) > 0 and MeleeMultiUnits > 1 then LivingFlameCastType = 2 return A.ChronoFlamesDMG:Show(icon) end
        
        --Disintegrate
        if A.Disintegrate:IsReady(unitID) and MovementCheck and (ActionPlayer:Essence() >= 4 or Unit(player):HasBuffs(A.EssenceBurst.ID) > 0) then return A.Disintegrate:Show(icon) end
        
        --LivingFlame Damage
        if A.LivingFlameDMG:IsReady(unitID) and IsPlayerSpell(A.LivingFlame.ID) and MovementCheck then LivingFlameCastType = 2 return A.LivingFlameDMG:Show(icon) end

        --ChronoFlames Damage
        --if A.ChronoFlamesDMG:IsReady(unitID) and IsPlayerSpell(A.ChronoFlamesTalent.ID) and MovementCheck then LivingFlameCastType = 2 return A.ChronoFlamesDMG:Show(icon) end

        --AzureStrike
        if A.AzureStrike:IsReady(unitID) then return A.AzureStrike:Show(icon) end
    end
end

local isHealerSetupDone = false

A[3] = function(icon)
    -- if not isHealerSetupDone then
    --     _G.MakuluCore.Functions.SetUpHealers()
    --     isHealerSetupDone = true
    -- end
    RotationsVariables()

    local spell, stop = handleStages(icon)
    if spell then
        return stop
    end

    if Action.Zone == "arena" then
        FakeCasting.gglFakeCast(icon)
    end

    if not inCombat and A.Zone == "arena" and HealingEngine.GetBelowHealthPercentUnits(95) < 1 then
        local unitsPWF = {"party1", "party2", "player"}

        for _, unit in ipairs(unitsPWF) do
            if A.BlessingoftheBronze:IsReady() and UnitExists(unit) and Unit(unit):HasBuffs(A.BlessingBuff.ID) == 0 and not A.BlessingoftheBronze:IsSuspended(1,1) then
                return A.BlessingoftheBronze:Show(icon)
            end
        end
    end

    
    if A.Quell:IsReady("target") and arenaInterrupt("target") then return A.Quell:Show(icon) end

    if A.ObsidianScales:IsReady() and Unit(player):HasBuffs({A.ObsidianScales.ID, A.RenewingBlaze.ID}, true) == 0 and ((PlayerHealth <= GetToggle(2, "ObsidianScalesHP")) or (A.ObsidianMettle:IsTalentLearned() and Unit(player):HasBuffs(A.Hover.ID) > 0) and HealingEngine.GetBelowHealthPercentUnits(60) >= 1) then return A.ObsidianScales:Show(icon) end
    
    if A.RenewingBlaze:IsReady() and Unit(player):HasBuffs({A.ObsidianScales.ID, A.RenewingBlaze.ID}, true) == 0 and PlayerHealth <= 50 then return A.RenewingBlaze:Show(icon) end

    if A.IsUnitFriendly(target) then if PvpHealingRotation(target, icon) then return true end elseif A.IsUnitFriendly(focus) then if PvpHealingRotation(focus, icon) then return true end end
    if A.IsUnitEnemy(target) then if DamageRotation(target, icon) then return true end end
end

--################################################################################################################################################################################################################

local function PartyRotation(icon, unitID)
    if Unit("player"):CombatTime() > 1 then
        if UnitExists(unitID) then
            if A.Naturalize:IsReady(unitID) and canDispel(unitID) and Unit(unitID):HasDeBuffs(30108) < .1 and Unit(unitID):HasDeBuffs(316099) < .1 then 
                return A.Naturalize:Show(icon)
            end
        end
    end
end 

local sleepVar = 0

--################################################################################################################################################################################################################

local sleepWalkTarget = ""
local function ArenaRotation(icon, unitID)
    local shouldAware = GetToggle(2, "makAware")
    if A.Zone == "arena" and not ActionPlayer:IsStealthed() then
        --ChronoLoop Snipe
        if A.ChronoLoop:IsReady(unitID) and TeamIsSafe(40) and Unit(unitID):HealthPercent() <= 40 then return A.ChronoLoop:Show(icon) end

        --Sleep Walk 1
        if A.SleepWalk:IsReady(unitID)  and TeamIsSafe(50) and MovementCheck and not UnitIsUnit("target", unitID) and Unit(unitID):HasBuffs(204336) == 0 and Unit(unitID):HasBuffs(642) == 0 and Unit(unitID):HasBuffs(473909) == 0  and Unit(unitID):HasBuffs(740) == 0 and Unit(unitID):HasBuffs(378464) == 0 and Unit(unitID):HasBuffs(6940) == 0 and Unit(unitID):HasBuffs(421453) == 0 and Unit(unitID):HasBuffs(408557) == 0 and Unit(unitID):HasBuffs(377360) == 0 and Unit(unitID):HealthPercent() > 50 and StunHealerInArenaNew(unitID, 90, 1.4, "disorient", false, 100) then 
            sleepWalkTarget = unitID
            if shouldAware then Aware:displayMessage("Casting sleep walk on healer, please stand still. (FULL)", "Blue", 1) end
            sleepVar = 1
            return A.SleepWalk:Show(icon)
        end

        --Sleep Walk 1 half
        if A.SleepWalk:IsReady(unitID) and Unit("target"):HealthPercent() <= 30 and TeamIsSafe(50) and MovementCheck and not UnitIsUnit("target", unitID) and Unit(unitID):HasBuffs(204336) == 0 and Unit(unitID):HasBuffs(473909) == 0 and Unit(unitID):HasBuffs(642) == 0 and Unit(unitID):HasBuffs(740) == 0 and Unit(unitID):HasBuffs(378464) == 0 and Unit(unitID):HasBuffs(6940) == 0 and Unit(unitID):HasBuffs(421453) == 0 and Unit(unitID):HasBuffs(408557) == 0 and Unit(unitID):HasBuffs(377360) == 0 and Unit(unitID):HealthPercent() > 50 and StunHealerInArenaNew(unitID, 40, 1.4, "disorient", false, 50) then 
            sleepWalkTarget = unitID
            if shouldAware then Aware:displayMessage("Casting sleep walk on healer, please stand still. (HALF)", "Blue", 1) end
            sleepVar = 1
            return A.SleepWalk:Show(icon)
        end

        --Sleep Walk 2

        if A.SleepWalk:IsReady(unitID)  and TeamIsSafe(50) and MovementCheck and Unit(unitID):HasBuffs(204336) == 0 and Unit(unitID):HasBuffs(642) == 0 and Unit(unitID):HasBuffs(378464) == 0 and Unit(unitID):HasBuffs(473909) == 0 and Unit(unitID):HasBuffs(421453) == 0 and Unit(unitID):HasBuffs(740) == 0 and Unit(unitID):HasBuffs(377360) == 0 and Unit(unitID):HasBuffs(408557) == 0 and Unit(unitID):HasBuffs(377360) == 0 and not UnitIsUnit("target", unitID) and Unit("target"):IsHealer() and StunHealerInArenaNew(unitID, 90, 1.4, "disorient", true, 100) then 
            sleepWalkTarget = unitID
            if shouldAware then Aware:displayMessage("Casting sleep walk on off target, please stand still. (FULL)", "Blue", 1) end
            return A.SleepWalk:Show(icon) 
        end
        
        --Quell
        if A.Quell:IsReady(unitID) and TeamIsSafe(55) and arenaInterrupt(unitID) then return A.Quell:Show(icon) end
    end
end

--################################################################################################################################################################################################################

A[6] = function(icon)
    RotationsVariables()

    if isPlayerCastingSpell(A.SleepWalk.ID) then
        local IsHealerCC = Unit(player):IsCastingRemains(A.SleepWalk.ID) > 0 and shouldStopSleep(sleepWalkTarget)
        local sleepCastDelay = A.SleepWalk:GetSpellCastTime() + 0.1
        if IsHealerCC and sleepVar == 1 and not A.SwoopUp:IsSuspended(.3,1) then sleepVar = 0 return A.SwoopUp:Show(icon) end
    end

    --Stopcast Pvp
    if weAreInPvp then
        local IsDmgSpellLow = ((Unit(player):IsCastingRemains(A.LivingFlame.ID) > 0 and LivingFlameCastType == 2 or (Unit(player):IsCastingRemains(A.ChronoFlames.ID) > 0 and LivingFlameCastType == 2)) or Unit(player):IsCastingRemains(A.FireBreath.ID) > 0 or Unit(player):IsCastingRemains(A.Disintegrate.ID) > 0)
        local IsHealingSpell = ((Unit(player):IsCastingRemains(A.LivingFlame.ID) > 0 and LivingFlameCastType == 1 or Unit(player):IsCastingRemains(A.ChronoFlames.ID) > 0 or Unit(player):IsCastingRemains(A.SleepWalk.ID) > 0 and LivingFlameCastType == 1)) and ((A.TiptheScales:IsReady() and A.SpiritBloom:IsReady()) or A.Rewind:IsReady())
        if IsHealingSpell and HealingEngine.GetBelowHealthPercentUnits(40) >= 1 then return A:Show(icon, ACTION_CONST_STOPCAST) end
        if IsDmgSpellLow and HealingEngine.GetBelowHealthPercentUnits(65) >= 1 then return A:Show(icon, ACTION_CONST_STOPCAST) end
    end

    if PartyRotation(icon, "party1") then
        return true
    end
    
    return ArenaRotation(icon, "arena1")
end

--################################################################################################################################################################################################################

A[7] = function(icon)
    RotationsVariables()
    
    if PartyRotation(icon, "party2") then
        return true
    end
    
    return ArenaRotation(icon, "arena2")
end

--################################################################################################################################################################################################################

A[8] = function(icon)
    RotationsVariables()
    
    if PartyRotation(icon, "party3") then
        return true
    end

    return ArenaRotation(icon, "arena3")
end

A[9] = function(icon)
    RotationsVariables()
    
    if PartyRotation(icon, "party4") then
        return true
    end
end

A[10] = function(icon)
    RotationsVariables()
    
    if PartyRotation(icon, "player") then
        return true
    end
end

A[1] = function(icon)

end


A[2] = function(icon)

end

--################################################################################################################################################################################################################
-- NOTES
--################################################################################################################################################################################################################
-- [1] is AntiFake CC rotation (limited, usually is single color like 0x00FF00 which is green)
-- [2] is AntiFake Kick rotation (racial, primary specialization interrupt spell)
-- [3] is Rotation (old launcher called it Single, supports all actions)
-- [4] is Secondary (old launcher called it AoE) rotation (supports all actions)
-- [5] is Trinket rotation (racial, specialization's spells which can remove CC)
-- [6] is Passive rotation (limited actions, usually @raid1, @party1, @arena1 and additional binds - for more info look notes in the launcher)
-- [7] is Passive rotation (limited actions, usually @raid2, @party2, @arena2)
-- [8] is Passive rotation (limited actions, usually @raid3, @party3, @arena3)
--Passive rotation doesn't require START button use like it does [1] -> [5] rotations