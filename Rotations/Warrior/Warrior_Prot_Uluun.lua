
local _G, setmetatable     = _G, setmetatable
local A                    = _G.Action
local Covenant             = _G.LibStub("Covenant")
local TMW                  = _G.TMW
local Listener             = Action.Listener
local Create               = Action.Create
local GetToggle            = Action.GetToggle
local SetToggle            = Action.SetToggle
local GetGCD               = Action.GetGCD
local GetCurrentGCD        = Action.GetCurrentGCD
local GetPing              = Action.GetPing
local ShouldStop           = Action.ShouldStop
local BurstIsON            = Action.BurstIsON
local CovenantIsON         = Action.CovenantIsON
local AuraIsValid          = Action.AuraIsValid
local InterruptIsValid     = Action.InterruptIsValid
local FrameHasSpell        = Action.FrameHasSpell
local Utils                = Action.Utils
local TeamCache            = Action.TeamCache
local EnemyTeam            = Action.EnemyTeam
local FriendlyTeam         = Action.FriendlyTeam
local LoC                  = Action.LossOfControl
local Player               = Action.Player
local Pet                  = LibStub("PetLibrary") 
local MultiUnits           = Action.MultiUnits
local UnitCooldown         = Action.UnitCooldown
local Unit                 = Action.Unit 
local IsUnitEnemy          = Action.IsUnitEnemy
local IsUnitFriendly       = Action.IsUnitFriendly
local ActiveUnitPlates     = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit = IsIndoors, UnitIsUnit
local pairs                = pairs
local Toaster              = _G.Toaster
local GetSpellTexture      = _G.TMW.GetSpellTexture

Action[ACTION_CONST_WARRIOR_PROTECTION] = {
    AncestralCall                = Action.Create({ Type = "Spell", ID = 274738    }),
    AngerManagement= Action.Create({ Type = "Spell", ID = 152278 }),
    Annihilator    = Action.Create({ Type = "Spell", ID = 383916 }),
    ArcanePulse                 = Action.Create({ Type = "Spell", ID = 260364    }),
    ArcaneTorrent                = Action.Create({ Type = "Spell", ID = 50613    }),
    ArmoredtotheTeeth= Action.Create({ Type = "Spell", ID = 384124 }),
    AshenJuggernaut= Action.Create({ Type = "Spell", ID = 392536 }),
    Attack         = Action.Create({ Type = "Spell", ID = 88163 }),
    Avatar         = Action.Create({ Type = "Spell", ID = 107574 }),
    BagofTricks                    = Action.Create({ Type = "Spell", ID = 312411    }),
    BarbaricTraining= Action.Create({ Type = "Spell", ID = 383082 }),
    BatteringRam   = Action.Create({ Type = "Spell", ID = 394312 }),
    Battlelord     = Action.Create({ Type = "Spell", ID = 386630 }),
    BattleScarredVeteran= Action.Create({ Type = "Spell", ID = 386394 }),
    BattleShout    = Action.Create({ Type = "Spell", ID = 6673 }),
    BattleStance   = Action.Create({ Type = "Spell", ID = 386164 }),
    BerserkerRage  = Action.Create({ Type = "Spell", ID = 18499 }),
    BerserkerShout = Action.Create({ Type = "Spell", ID = 384100 }),
    BerserkerStance= Action.Create({ Type = "Spell", ID = 386196 }),
    BerserkersTorment= Action.Create({ Type = "Spell", ID = 390123 }),
    Berserking                    = Action.Create({ Type = "Spell", ID = 26297    }),
    BestServedCold = Action.Create({ Type = "Spell", ID = 202560 }),
    BitterImmunity = Action.Create({ Type = "Spell", ID = 383762 }),
    BlademastersTorment= Action.Create({ Type = "Spell", ID = 390138 }),
    Bladestorm     = Action.Create({ Type = "Spell", ID = 227847 }),
    BloodandThunder= Action.Create({ Type = "Spell", ID = 384277 }),
    Bloodborne     = Action.Create({ Type = "Spell", ID = 383287 }),
    Bloodcraze     = Action.Create({ Type = "Spell", ID = 393950 }),
    BloodFury                    = Action.Create({ Type = "Spell", ID = 20572    }),
    Bloodletting   = Action.Create({ Type = "Spell", ID = 383154 }),
    Bloodsurge     = Action.Create({ Type = "Spell", ID = 384361 }),
    Bloodthirst    = Action.Create({ Type = "Spell", ID = 23881 }),
    BluntInstruments= Action.Create({ Type = "Spell", ID = 383442 }),
    Bolster        = Action.Create({ Type = "Spell", ID = 280001 }),
    BoomingVoice   = Action.Create({ Type = "Spell", ID = 202743 }),
    BoundingStride = Action.Create({ Type = "Spell", ID = 202163 }),
    BraceForImpact = Action.Create({ Type = "Spell", ID = 386030 }),
    BrutalVitality = Action.Create({ Type = "Spell", ID = 384036 }),
    BullRush                       = Action.Create({ Type = "Spell", ID = 255654    }),    
    CacophonousRoar= Action.Create({ Type = "Spell", ID = 382954 }),
    ChallengingShout= Action.Create({ Type = "Spell", ID = 1161 }),
    ChampionsBulwark= Action.Create({ Type = "Spell", ID = 386328 }),
    ChampionsSpear = Action.Create({ Type = "Spell", ID = 376079 }),
    Charge         = Action.Create({ Type = "Spell", ID = 100 }),
    Cleave         = Action.Create({ Type = "Spell", ID = 845 }),
    ColdSteelHotBlood= Action.Create({ Type = "Spell", ID = 383959 }),
    CollateralDamage= Action.Create({ Type = "Spell", ID = 334779 }),
    ColossusSmash  = Action.Create({ Type = "Spell", ID = 167105 }),
    ConcussiveBlows= Action.Create({ Type = "Spell", ID = 383115 }),
    CracklingThunder= Action.Create({ Type = "Spell", ID = 203201 }),
    CriticalThinking= Action.Create({ Type = "Spell", ID = 383297 }),
    CruelStrikes   = Action.Create({ Type = "Spell", ID = 392777 }),
    Cruelty        = Action.Create({ Type = "Spell", ID = 392931 }),
    CrushingForce  = Action.Create({ Type = "Spell", ID = 382764 }),
    DanceofDeath   = Action.Create({ Type = "Spell", ID = 390713 }),
    DancingBlades  = Action.Create({ Type = "Spell", ID = 391683 }),
    DefendersAegis = Action.Create({ Type = "Spell", ID = 397103 }),
    DefensiveStance= Action.Create({ Type = "Spell", ID = 386208 }),
    DeftExperience = Action.Create({ Type = "Spell", ID = 383295 }),
    DemoralizingShout= Action.Create({ Type = "Spell", ID = 1160 }),
    DepthsofInsanity= Action.Create({ Type = "Spell", ID = 383922 }),
    Devastate      = Action.Create({ Type = "Spell", ID = 20243 }),
    Devastator     = Action.Create({ Type = "Spell", ID = 236279 }),
    DiebytheSword  = Action.Create({ Type = "Spell", ID = 118038 }),
    DisruptingShout= Action.Create({ Type = "Spell", ID = 386071 }),
    DoubleTime     = Action.Create({ Type = "Spell", ID = 103827 }),
    Dreadnaught    = Action.Create({ Type = "Spell", ID = 262150 }),
    DualWieldSpecialization= Action.Create({ Type = "Spell", ID = 382900 }),
    ElysianMight   = Action.Create({ Type = "Spell", ID = 386285 }),
    EnduranceTraining= Action.Create({ Type = "Spell", ID = 382940 }),
    EnduringAlacrity= Action.Create({ Type = "Spell", ID = 384063 }),
    EnduringDefenses= Action.Create({ Type = "Spell", ID = 386027 }),
    EnragedRegeneration= Action.Create({ Type = "Spell", ID = 184364 }),
    EscapeArtist                = Action.Create({ Type = "Spell", ID = 20589    }), 
    Execute        = Action.Create({ Type = "Spell", ID = 5308 }),
    ExecutionersPrecision= Action.Create({ Type = "Spell", ID = 386634 }),
    ExhilaratingBlows= Action.Create({ Type = "Spell", ID = 383219 }),
    FastFootwork   = Action.Create({ Type = "Spell", ID = 382260 }),
    Fatality       = Action.Create({ Type = "Spell", ID = 383703 }),
    FervorofBattle = Action.Create({ Type = "Spell", ID = 202316 }),
    Fireblood                    = Action.Create({ Type = "Spell", ID = 265221    }),
    FocusedVigor   = Action.Create({ Type = "Spell", ID = 384067 }),
    FocusinChaos   = Action.Create({ Type = "Spell", ID = 383486 }),
    FrenziedFlurry = Action.Create({ Type = "Spell", ID = 383605 }),
    Frenzy         = Action.Create({ Type = "Spell", ID = 335077 }),
    FreshMeat      = Action.Create({ Type = "Spell", ID = 215568 }),
    FrothingBerserker= Action.Create({ Type = "Spell", ID = 215571 }),
    FueledbyViolence= Action.Create({ Type = "Spell", ID = 383103 }),
    FuriousBlows   = Action.Create({ Type = "Spell", ID = 390354 }),
    GiftofNaaru                   = Action.Create({ Type = "Spell", ID = 59544    }),
    HackandSlash   = Action.Create({ Type = "Spell", ID = 383877 }),
    Hamstring      = Action.Create({ Type = "Spell", ID = 1715 }),
    Haymaker                       = Action.Create({ Type = "Spell", ID = 287712    }), 
    Healthstone     = Action.Create({ Type = "Item", ID = 5512 }),
    HeavyRepercussions= Action.Create({ Type = "Spell", ID = 203177 }),
    HeroicLeap     = Action.Create({ Type = "Spell", ID = 6544 }),
    HeroicThrow    = Action.Create({ Type = "Spell", ID = 57755 }),
    HonedReflexes  = Action.Create({ Type = "Spell", ID = 382461 }),
    Hurricane      = Action.Create({ Type = "Spell", ID = 390563 }),
    IgnorePain     = Action.Create({ Type = "Spell", ID = 190456 }),
    ImmovableObject= Action.Create({ Type = "Spell", ID = 394307 }),
    Impale         = Action.Create({ Type = "Spell", ID = 383430 }),
    ImpendingVictory= Action.Create({ Type = "Spell", ID = 202168 }),
    ImpenetrableWall= Action.Create({ Type = "Spell", ID = 384072 }),
    ImprovedBloodthirst= Action.Create({ Type = "Spell", ID = 383852 }),
    ImprovedEnrage = Action.Create({ Type = "Spell", ID = 383848 }),
    ImprovedExecute= Action.Create({ Type = "Spell", ID = 316402 }),
    ImprovedHeroicThrow= Action.Create({ Type = "Spell", ID = 386034 }),
    ImprovedMortalStrike= Action.Create({ Type = "Spell", ID = 385573 }),
    ImprovedOverpower= Action.Create({ Type = "Spell", ID = 385571 }),
    ImprovedRagingBlow= Action.Create({ Type = "Spell", ID = 383854 }),
    ImprovedWhirlwind= Action.Create({ Type = "Spell", ID = 12950 }),
    Indomitable    = Action.Create({ Type = "Spell", ID = 202095 }),
    InForTheKill   = Action.Create({ Type = "Spell", ID = 248621 }),
    InspiringPresence= Action.Create({ Type = "Spell", ID = 382310 }),
    Instigate      = Action.Create({ Type = "Spell", ID = 394311 }),
    Intervene      = Action.Create({ Type = "Spell", ID = 3411 }),
    IntimidatingShout= Action.Create({ Type = "Spell", ID = 5246 }),
    IntotheFray    = Action.Create({ Type = "Spell", ID = 202603 }),
    InvigoratingFury= Action.Create({ Type = "Spell", ID = 383468 }),
    Juggernaut     = Action.Create({ Type = "Spell", ID = 383292 }),
    LastStand      = Action.Create({ Type = "Spell", ID = 12975 }),
    LeechingStrikes= Action.Create({ Type = "Spell", ID = 382258 }),
    LightsJudgment                = Action.Create({ Type = "Spell", ID = 255647   }), 
    MartialProwess = Action.Create({ Type = "Spell", ID = 316440 }),
    Massacre       = Action.Create({ Type = "Spell", ID = 206315 }),
    MeatCleaver    = Action.Create({ Type = "Spell", ID = 280392 }),
    Menace         = Action.Create({ Type = "Spell", ID = 275338 }),
    MercilessBonegrinder= Action.Create({ Type = "Spell", ID = 383317 }),
    MortalStrike   = Action.Create({ Type = "Spell", ID = 12294 }),
    OdynsFury      = Action.Create({ Type = "Spell", ID = 385059 }),
    OneHandedWeaponSpecialization= Action.Create({ Type = "Spell", ID = 382895 }),
    Onslaught      = Action.Create({ Type = "Spell", ID = 315720 }),
    Overpower      = Action.Create({ Type = "Spell", ID = 7384 }),
    OverwhelmingRage= Action.Create({ Type = "Spell", ID = 382767 }),
    PainandGain    = Action.Create({ Type = "Spell", ID = 382549 }),
    PiercingHowl   = Action.Create({ Type = "Spell", ID = 12323 }),
    PiercingVerdict= Action.Create({ Type = "Spell", ID = 382948 }),
    Pummel         = Action.Create({ Type = "Spell", ID = 6552 }),
    Punish         = Action.Create({ Type = "Spell", ID = 275334 }),
    QuakingPalm                   = Action.Create({ Type = "Spell", ID = 107079    }),
    RagingArmaments= Action.Create({ Type = "Spell", ID = 388049 }),
    RagingBlow     = Action.Create({ Type = "Spell", ID = 85288 }),
    RallyingCry    = Action.Create({ Type = "Spell", ID = 97462 }),
    Rampage        = Action.Create({ Type = "Spell", ID = 184367 }),
    Ravager        = Action.Create({ Type = "Spell", ID = 228920 }),
    ReapingSwings  = Action.Create({ Type = "Spell", ID = 383293 }),
    RecklessAbandon= Action.Create({ Type = "Spell", ID = 396749 }),
    Recklessness   = Action.Create({ Type = "Spell", ID = 1719 }),
    ReinforcedPlates= Action.Create({ Type = "Spell", ID = 382939 }),
    Rend           = Action.Create({ Type = "Spell", ID = 772 }),
    Revenge        = Action.Create({ Type = "Spell", ID = 6572 }),
    RumblingEarth  = Action.Create({ Type = "Spell", ID = 275339 }),
    SecondWind     = Action.Create({ Type = "Spell", ID = 29838 }),
    SeismicReverberation= Action.Create({ Type = "Spell", ID = 382956 }),
    Shadowmeld                   = Action.Create({ Type = "Spell", ID = 58984    }),
    SharpenedBlades= Action.Create({ Type = "Spell", ID = 383341 }),
    ShatteringThrow= Action.Create({ Type = "Spell", ID = 64382 }),
    ShieldBlock    = Action.Create({ Type = "Spell", ID = 2565 }),
    ShieldBlockBuff    = Action.Create({ Type = "Spell", ID = 132404 }),
    ShieldCharge   = Action.Create({ Type = "Spell", ID = 385952 }),
    ShieldSlam     = Action.Create({ Type = "Spell", ID = 23922 }),
    ShieldSpecialization= Action.Create({ Type = "Spell", ID = 386011 }),
    ShieldWall     = Action.Create({ Type = "Spell", ID = 871 }),
    Shockwave      = Action.Create({ Type = "Spell", ID = 46968 }),
    ShowofForce    = Action.Create({ Type = "Spell", ID = 385843 }),
    Sidearm        = Action.Create({ Type = "Spell", ID = 384404 }),
    SingleMindedFury= Action.Create({ Type = "Spell", ID = 81099 }),
    Skullsplitter  = Action.Create({ Type = "Spell", ID = 260643 }),
    Slam           = Action.Create({ Type = "Spell", ID = 1464 }),
    SlaughteringStrikes= Action.Create({ Type = "Spell", ID = 388004 }),
    SonicBoom      = Action.Create({ Type = "Spell", ID = 390725 }),
    SpellBlock     = Action.Create({ Type = "Spell", ID = 392966 }),
    SpellReflection= Action.Create({ Type = "Spell", ID = 23920 }),
    Stoneform                     = Action.Create({ Type = "Spell", ID = 20594    }), 
    StormBolt      = Action.Create({ Type = "Spell", ID = 107570 }),
    StormofSteel   = Action.Create({ Type = "Spell", ID = 382953 }),
    StormofSwords  = Action.Create({ Type = "Spell", ID = 385512 }),
    StormWall      = Action.Create({ Type = "Spell", ID = 388807 }),
    Strategist     = Action.Create({ Type = "Spell", ID = 384041 }),
    SuddenDeath    = Action.Create({ Type = "Spell", ID = 29725 }),
    SweepingStrikes= Action.Create({ Type = "Spell", ID = 260708 }),
    SwiftStrikes   = Action.Create({ Type = "Spell", ID = 383459 }),
    Tactician      = Action.Create({ Type = "Spell", ID = 184783 }),
    Taunt          = Action.Create({ Type = "Spell", ID = 355 }),
    Tenderize      = Action.Create({ Type = "Spell", ID = 388933 }),
    TestofMight    = Action.Create({ Type = "Spell", ID = 385008 }),
    ThunderClap    = Action.Create({ Type = "Spell", ID = 6343 }),
    Thunderlord    = Action.Create({ Type = "Spell", ID = 385840 }),
    ThunderousRoar = Action.Create({ Type = "Spell", ID = 384318 }),
    ThunderousWords= Action.Create({ Type = "Spell", ID = 384969 }),
    TideofBlood    = Action.Create({ Type = "Spell", ID = 386357 }),
    TitanicRage    = Action.Create({ Type = "Spell", ID = 394329 }),
    TitanicThrow   = Action.Create({ Type = "Spell", ID = 384090 }),
    TitansTorment  = Action.Create({ Type = "Spell", ID = 390135 }),
    ToughasNails   = Action.Create({ Type = "Spell", ID = 385888 }),
    TwoHandedWeaponSpecialization= Action.Create({ Type = "Spell", ID = 382896 }),
    UnbridledFerocity= Action.Create({ Type = "Spell", ID = 389603 }),
    Unhinged       = Action.Create({ Type = "Spell", ID = 386628 }),
    UnnervingFocus = Action.Create({ Type = "Spell", ID = 384042 }),
    UnstoppableForce= Action.Create({ Type = "Spell", ID = 275336 }),
    Uproar         = Action.Create({ Type = "Spell", ID = 391572 }),
    ValorinVictory = Action.Create({ Type = "Spell", ID = 383338 }),
    VanguardsDetermination = Action.Create({ Type = "Spell", ID = 394056 }),   
    ViciousContempt= Action.Create({ Type = "Spell", ID = 383885 }),
    VictoryRush    = Action.Create({ Type = "Spell", ID = 34428 }),
    ViolentOutburst= Action.Create({ Type = "Spell", ID = 386477 }),
    ViolentOutburstBuff= Action.Create({ Type = "Spell", ID = 38647 }),
    Warbreaker     = Action.Create({ Type = "Spell", ID = 262161 }),
    WarlordsTorment= Action.Create({ Type = "Spell", ID = 390140 }),
    WarMachine     = Action.Create({ Type = "Spell", ID = 262231 }),
    Warpaint       = Action.Create({ Type = "Spell", ID = 208154 }),
    WarStomp                    = Action.Create({ Type = "Spell", ID = 20549    }),
    Whirlwind      = Action.Create({ Type = "Spell", ID = 1680 }),
    WildStrikes    = Action.Create({ Type = "Spell", ID = 382946 }),
    WilloftheForsaken            = Action.Create({ Type = "Spell", ID = 7744        }),   
    WilltoSurvive            = Action.Create({ Type = "Spell", ID = 59752    }),
    WrathandFury   = Action.Create({ Type = "Spell", ID = 392936 }),
    WreckingThrow  = Action.Create({ Type = "Spell", ID = 384110 }),

}

local A = setmetatable(Action[ACTION_CONST_WARRIOR_PROTECTION], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local pet = "pet"
local targettarget = "targettarget"

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
    incomingAoEDamage                       = { 388537, --Arcane Fissue
        377004, --Deafening Screech
        388923, --Burst Forth
        212784, --Eye Storm
        192305, --Eye of the Storm (mini-boss)
        200901, --Eye of the Storm (boss)
        372863, --Ritual of Blazebinding
        153094, --Whispers of the Dark Star
        164974, --Dark Eclipse
        153804, --Inhale
        175988, --Omen of Death
        106228, --Nothingness
        374720, --Consuming Stomp
        384132, --Overwhelming Energy
        388008, --Absolute Zero
        385399, --Unleashed Destruction
        388817, --Shards of Stone
        387145, --Totemic Overload
    },
    healerStressedIncMagic                    = { 372735, -- Tectonic Slam (RLP)
        372808, -- Frigid Shard (RLP)
        385536, -- Flame Dance (RLP)
        392488, -- Lightning Storm (RLP)
        392486, -- Lightning Storm (RLP)
        387564, -- Mystic Vapors (AV)
        374720, -- Consuming Stomp (AV)
        384132, -- Overwhelming Energy (AV)
        388804, -- Unleashed Destruction (AV)
        388817, -- Shards of Stone (NO)
        387135, -- Arcing Strike (NO)
        387145, -- Totemic Overload (NO)
        386012, -- Stormbolt (NO)
        386025, -- Tempest (NO)
        384620, -- Electrical Storm (NO)
        387411, -- Death Bolt Volley (NO)
        388862, -- Surge (AA)
        212784, -- Eye Storm (CoS)
        211406, -- Firebolt (CoS)
        207906, -- Burning Intensity (CoS)
        207881, -- Infernal Eruption (CoS)
        156722, -- Void Bolt (SBG)
        152814, -- Shadow Bolt (SBG)
    },
    IncMagic                                = { 372863, -- Ritual of Blazebinding (RLP)
        381605, -- Flamespit (RLP)
        381602, -- Flamespit (RLP)
        381607, -- Flamespit (RLP)
        374789, -- Infused Strike (AV)
        374567, -- Explosive Brand (AV)
        374570, -- Explosive Brand (AV)
        374582, -- Explosive Brand (AV)
        370764, -- Piercing Shards (AV)
        377105, -- Ice Cutter (AV)
        372222, -- Arcane Cleave (AV)
        388008, -- Absolute Zero (AV)
        384978, -- Dragon Strike (AV)
        385916, -- Tectonic Stomp (NO)
        386028, -- Thunder Clap (NO)
        384686, -- Energy Surge (NO)
        384316, -- Lightning Strike (NO)
        382670, -- Gale Arrow (NO)
        376827, -- Conductive Strike (NO)
        388923, -- Burst Forth (AA)
        377991, -- Storm Slash (AA)
        377004, -- Deafening Screech (AA)
        396812, -- Mystic Blast (AA)
        385958, -- Arcane Expulsion (AA)
        387975, -- Arcane Missiles (AA)
        200901, -- Eye of the Storm (HoV)
        200682, -- Eye of the Storm (HoV)
        192288, -- Searing Light (HoV)
        198888, -- Lightning Breath (HoV)
        209404, -- Seal Magic (CoS)
        209410, -- Nightfall Orb (CoS)
        211299, -- Searing Glare (CoS)
        211473, -- Shadow Slash (CoS)
        397892, -- Scream of Pain (CoS)
        373364, -- Vampiric Claws (CoS)
        214692, -- Shadow Bolt Volley (CoS)
        164907, -- Void Slash (SBG)
        152792, -- Void Blast (SBG)
        156717, -- Death Venom (SBG)
        153485, -- Fetid Spit (SBG)
        153680, -- Fetid Spit (SBG)
        152964, -- Void Pulse (SBG)
        397888, -- Hydrolance (TJS)
        397878, -- Tainted Ripple (TJS)
        114646, -- Haunting Gaze (TJS)
        114571, -- Agony (TJS)
        397931, -- Dark Claw (TJS)
        106823, -- Serpent Strike (TJS)
        106841, -- Jade Serpent Strike (TJS)
        117665, -- Bounds of Reality (TJS)
        
    },
    healerStressedIncPhys                    = { 191284, -- Horn of Valor (HoV)
        
    },
    IncPhys                                    = { 372794, -- Steel Barrage (RLP)
        372047, -- Steel Barrage (RLP)
        392395, -- Thunder Jaw (RLP)
        395303, -- Thunder Jaw (RLP)
        392394, -- Fire Maw (RLP)
        395292, -- Fire Maw (RLP)
        372858, -- Searing Blows (RLP)
        372859, -- Searing Blows (RLP)
        396991, -- Bestial Roar (AV)
        381683, -- Swift Stab (NO)
        384476, -- Rain of Arrows (NO)
        387826, -- Heavy Slash (NO)
        388801, -- Mortal Strike (NO)
        382836, -- Brutalize (NO)
        384336, -- War Stomp (NO)
        375937, -- Rending Strike (NO)
        388544, -- Barkbreaker (AA)
        376997, -- Savage Peck (AA)
        388911, -- Severing Slash (AA)
        199772, -- Power Attack (HoV)
        193092, -- Bloodletting Sweep (HoV)
        198944, -- Breach Armor (HoV)
        199050, -- Mortal Hew (HoV)
        199210, -- Penetrating Shot (HoV)
        199108, -- Frantic Gore (HoV)
        199151, -- Piercing Horns (HoV)
        196512, -- Claw Frenzy (HoV)
        199177, -- Ferocious Bite (HoV)
        199652, -- Sever (HoV)
        193668, -- Savage Blade (HoV)
        209495, -- Charged Smash (CoS)
        396007, -- Vicious Peck (TJS)
        396018, -- Fit of Rage (TJS)
        397904, -- Setting Sun Kick (TJS)
        
    },
}

local function InMelee(unitID)
    return A.Bloodthirst:IsInRange(unitID)
end 
InMelee = A.MakeFunctionCachedDynamic(InMelee)

local function HealerStressed()
    
    local total = 0
    for _, thisUnit in pairs(TeamCache.Friendly.GUIDs) do
        if Unit(thisUnit):HealthPercent() > 75 then
            total = total + 1
        end
    end
    
    return total 
end 

local function MassPull()
    
    defensive = false 
    for _, thisUnit in pairs(MultiUnits:GetActiveUnitPlates()) do
        if Unit(thisUnit):Health() > Unit(player):HealthMax() * 30 then
            defensive = true
        end
    end
    
    return defensive 
    
end

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    local unitID
    if A.IsUnitEnemy("target") then 
        unitID = "target"
    end  
    
    if A.CanUseHealthstoneOrHealingPotion() then
        return A.Healthstone
    end
    
    local useRacial = A.GetToggle(1, "Racial")
    
    local SpellReflectionActive = Unit(player):HasBuffs(A.SpellReflection.ID) > 0
    local ShieldWallActive = Unit(player):HasBuffs(A.ShieldWall.ID) > 0
    local noDefensiveActive = not SpellReflectionActive and not ShieldWallActive
    local healerStressed = HealerStressed()
    local massPull = MassPull()
    
    if A.RallyingCry:IsReady(player) and MultiUnits:GetByRangeCasting(60, 1, nil, Temp.incomingAoEDamage) >= 1 then
        return A.RallyingCry
    end
    
    if noDefensiveActive then
        if healerStressed then
            if MultiUnits:GetByRangeCasting(60, 1, nil, Temp.healerStressedIncMagic) >= 1 then
                if A.SpellReflection:IsReady(player) then
                    return A.SpellReflection
                elseif A.ShieldWall:IsReady(player) then
                    return A.ShieldWall
                end
            end
            if MultiUnits:GetByRangeCasting(60, 1, nil, Temp.healerStressedIncPhys) >= 1 then
                if A.ShieldWall:IsReady(player) then
                    return A.ShieldWall
                end
            end
        end

        if MultiUnits:GetByRangeCasting(60, 1, nil, Temp.IncMagic) >= 1 then
            if A.SpellReflection:IsReady(player) then
                return A.SpellReflection
            elseif A.ShieldWall:IsReady(player) then
                return A.ShieldWall
            end
        end
        if MultiUnits:GetByRangeCasting(60, 1, nil, Temp.IncPhys) >= 1 then
            if A.ShieldWall:IsReady(player) then
                return A.ShieldWall
            end
        end
    end
    
    if A.BerserkerRage:IsReady(player) and (LoC:Get("FEAR") > 0 or LoC:Get("INCAPACITATE") > 0) then
        return A.BerserkerRage
    end
    
    if A.WilltoSurvive:IsReady(player) and useRacial and LoC:Get("STUN") > 0 then
        return A.WilltoSurvive
    end
    
    local ShieldWallHP = A.GetToggle(2, "ShieldWallHP")
    if A.ShieldWall:IsReady(player) and Unit(player):HealthPercent() <= ShieldWallHP then
        return A.ShieldWall
    end
    
    local BitterImmunityHP = A.GetToggle(2, "BitterImmunityHP")
    if A.BitterImmunity:IsReady(player) and Unit(player):HealthPercent() <= BitterImmunityHP then
        return A.BitterImmunity
    end   
    
    local LastStandHP = A.GetToggle(2, "LastStandHP")
    if A.LastStand:IsReady(player) and Unit(player):HealthPercent() <= LastStandHP then
        return A.LastStand
    end
    
    local VictoryRushHP = A.GetToggle(2, "VictoryRushHP")
    if A.VictoryRush:IsReady(player) and Unit(player):HealthPercent() <= VictoryRushHP then
        return A.VictoryRush
    end
    
end 

SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unitID, nil, nil, true)
    
    if castRemainsTime >= A.GetLatency() then
        if useKick and not notInterruptable and A.Pummel:IsReady(unitID, nil, nil, true) then 
            return A.Pummel
        end
        if useCC and A.StormBolt:IsReady(unitID) then 
            return A.StormBolt
        end
        if useCC and A.IntimidatingShout:IsReady(unitID) then 
            return A.IntimidatingShout
        end
        
        if useRacial and A.WarStomp:AutoRacial(unitID) then 
            return A.WarStomp
        end 

        if useCC and A.SpellBlock:IsReady(unitID) then 
            return A.SpellBlock
        end

    end
end

local function UseTrinkets(unitID)
    
    if A.Trinket1:IsReady(unitID) then
        if A.BurstIsON(unitID) and A.IsUnitEnemy(unitID) and InMelee() then
            return A.Trinket1
        end    
    end
    
    if A.Trinket2:IsReady(unitID) then
        if A.BurstIsON(unitID) and A.IsUnitEnemy(unitID) and InMelee() then
            return A.Trinket2
        end    
    end
    
end

A[3] = function(icon, isMulti)
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local TTD = MultiUnits.GetByRangeAreaTTD(10)
    local useRacial = A.GetToggle(1, "Racial")
    
    if A.DefensiveStance:IsReady(unitID, true) and Unit(player):HasBuffs(A.DefensiveStance.ID) == 0 then 
        return A.DefensiveStance:Show(icon)
    end

    if A.BattleShout:IsReady(unitID, true) and Unit(player):HasBuffs(A.BattleShout.ID) == 0 then 
        return A.BattleShout:Show(icon)
    end    
    
    local function DamageRotation(unitID)
        
        local inMelee = A.Slam:IsInRange(unitID)

        local SelfDefensive = SelfDefensives()
        if SelfDefensive then 
            return SelfDefensive:Show(icon)
        end 
        
        local Interrupt = Interrupts(unitID)
        if Interrupt then 
            return Interrupt:Show(icon)
        end 
        
        local UseTrinket = UseTrinkets(unitID)
        if UseTrinket and Unit(unitID):GetRange() <= 10 then
            return UseTrinket:Show(icon)
        end    
        
        if A.Taunt:IsReady(unitID, true) and not Unit(unitID):IsBoss() and not Unit(unitID):IsDummy() and Unit(targettarget):InfoGUID() ~= Unit(player):InfoGUID() and Unit(targettarget):InfoGUID() ~= nil and A.IsUnitFriendly(targettarget) then 
            return A.Taunt:Show(icon)
        end 
        
        if A.Avatar:IsReady(player) and BurstIsON(unitID) and inMelee and TTD > 15 then
            return A.Stoneform:Show(icon)
        end
        
        if A.Shockwave:IsReady(player) and inMelee then
            return A.Shockwave:Show(icon)
        end
        
        if BurstIsON(unitID) and useRacial and inMelee and TTD > 15 then
            
            if A.Avatar:IsReady(player) then
                return A.Stoneform:Show(icon)
            end
            
            if A.DemoralizingShout:IsReady(player) then
                return A.DemoralizingShout:Show(icon)
            end
            
            if A.Ravager:IsReady(player) then
                return A.Ravager:Show(icon)
            end
            
            if A.ShieldCharge:IsReady(player) then
                return A.ShieldCharge:Show(icon)
            end
            
      
            if A.BloodFury:IsReady(player) then
                return A.BloodFury:Show(icon)
            end
 
            if A.Berserking:IsReady(player) then
                return A.Berserking:Show(icon)
            end
    
            if A.ArcaneTorrent:IsReady(player) then
                return A.ArcaneTorrent:Show(icon)
            end
   
            if A.LightsJudgment:IsReady(unitID) then
                return A.LightsJudgment:Show(icon)
            end

            if A.Fireblood:IsReady(player) then
                return A.Fireblood:Show(icon)
            end

            if A.AncestralCall:IsReady(player) then
                return A.AncestralCall:Show(icon)
            end

            if A.BagofTricks:IsReady(player) then
                return A.BagofTricks:Show(icon)
            end
            
            if A.ShieldSlam:IsReady(player) then
                return A.ShieldSlam:Show(icon)
            end
            
            if A.ThunderClap:IsReady(player) and Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 1 then
                return A.ThunderClap:Show(icon)
            end
            
        end
        
        if A.IgnorePain:IsReady(player, nil, nil, true) and inMelee then
            if Unit(unitID):HealthPercent() >= 20 and (Player:RageDeficit() <= 15 and A.ShieldSlam:GetCooldown() == 0 or Player:RageDeficit() <= 40 and A.ShieldCharge:GetCooldown() == 0 and A.ChampionsBulwark:IsTalentLearned() or Player:RageDeficit() <= 20 and A.ShieldCharge:GetCooldown() == 0 or Player:RageDeficit() <= 30 and A.DemoralizingShout:GetCooldown() == 0 and A.BoomingVoice:IsTalentLearned() or Player:RageDeficit() <= 20 and A.Avatar:GetCooldown() == 0 or Player:RageDeficit() <= 45 and A.DemoralizingShout:GetCooldown() == 0 and A.BoomingVoice:GetCooldown() == 0 and Unit(player):HasBuffs(A.LastStand.ID) > 0 and A.UnnervingFocus:IsTalentLearned() or Player:RageDeficit() <= 30 and A.Avatar:GetCooldown() == 0 and Unit(player):HasBuffs(A.LastStand.ID) > 0 and A.UnnervingFocus:IsTalentLearned() or Player:RageDeficit() <= 20 or Player:RageDeficit() <= 40 and A.ShieldSlam:GetCooldown() == 0 and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) > 0 or Player:RageDeficit() <= 55 and A.ShieldSlam:GetCooldown() == 0 and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) > 0 and Unit(player):HasBuffs(A.LastStand.ID) > 0 or Player:RageDeficit() <= 17 and A.ShieldSlam:GetCooldown() == 0 or Player:RageDeficit() <= 18 and A.ShieldSlam:GetCooldown() == 0 ) then
                return A.IgnorePain:Show(icon)
            end
        end
        
        if A.LastStand:IsReady(player) then
            if (Unit(unitID):HealthPercent() >= 90 and A.UnnervingFocus:IsTalentLearned() or Unit(unitID):HealthPercent() <= 20 ) then
                return A.LastStand:Show(icon)
            end
        end
        
        if A.Ravager:IsReady(player) and not isMoving and inMelee and BurstIsON(unitID) and TTD > 15 then
            return A.Ravager:Show(icon)
        end

        if A.DemoralizingShout:IsReady(player) and inMelee and not isMoving then
            return A.DemoralizingShout:Show(icon)
        end

        if A.ThunderousRoar:IsReady(player) and BurstIsON(unitID) and inMelee and not isMoving and TTD > 15 then
            return A.ThunderousRoar:Show(icon)
        end
        
        if A.Shockwave:IsReady(player) and inMelee then
            return A.Shockwave:Show(icon)
        end

        if A.ShieldCharge:IsReady(unitID) then
            return A.ShieldCharge:Show(icon)
        end

        if A.ShieldBlock:IsReady(player) and (Unit(player):HasBuffs(A.ShieldBlockBuff.ID) <= 18 or Unit(player):HasBuffs(A.ShieldBlockBuff.ID) <= 12) then
            return A.ShieldBlock:Show(icon)
        end
        
        local function AOE(unitID)

            if A.ThunderClap:IsReady(player) and Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 1 then
                return A.ThunderClap:Show(icon)
            end
            
            if A.ThunderClap:IsReady(player) and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) > 0 and MultiUnits:GetByRange(10, 4) > 5 and Unit(player):HasBuffs(A.Avatar.ID) > 0 and A.UnstoppableForce:IsTalentLearned() then
                return A.ThunderClap:Show(icon)
            end

            if A.Revenge:IsReady(player) and Player:Rage() >= 70 then
                return A.Revenge:Show(icon)
            end

            if A.ShieldSlam:IsReady(unitID) and (Player:Rage() <= 60 or Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) > 0 and MultiUnits:GetByRange(10, 4) <= 4) then
                return A.ShieldSlam:Show(icon)
            end

            if A.ThunderClap:IsReady(player) then
                return A.ThunderClap:Show(icon)
            end

            if A.Revenge:IsReady(player) and (Player:Rage() >= 30 or Player:Rage() >= 40) then
                return A.Revenge:Show(icon)
            end     
        end
        
        local function Generic(unitID)

            if A.ShieldSlam:IsReady(unitID) then
                return A.ShieldSlam:Show(icon)
            end

            if A.ThunderClap:IsReady(player) and inMelee and Unit(unitID):HasDeBuffs(A.Rend.ID, true) <= 1 and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) == 0 then
                return A.ThunderClap:Show(icon)
            end

            if A.Execute:IsReady(unitID) and Unit(player):HasBuffs(A.SuddenDeath.ID) > 0 then
                return A.Execute:Show(icon)
            end

            if A.Execute:IsReady(unitID) and MultiUnits:GetByRange(10, 4) == 1 and Player:Rage() >= 50 then
                return A.Execute:Show(icon)
            end

            if A.Revenge:IsReady(player) and inMelee and Unit(player):HasBuffs(A.VanguardsDetermination.ID) == 0 and Player:Rage() >= 40 then
                return A.Revenge:Show(icon)
            end

            if A.Execute:IsReady(unitID) and MultiUnits:GetByRange(10, 4) == 1 and Player:Rage() >= 50 then
                return A.Execute:Show(icon)
            end

            if A.ThunderClap:IsReady(player) and inMelee and (MultiUnits:GetByRange(10, 4) > 1 or A.ShieldSlam:GetCooldown() > A.GetGCD() and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) == 0) then
                return A.ThunderClap:Show(icon)
            end

            if A.Revenge:IsReady(player) and inMelee then
                if (Player:Rage() >= 60 and Unit(unitID):HealthPercent() > 20 or Unit(player):HasBuffs(A.Revenge.ID) > 0 and Unit(unitID):HealthPercent() <= 20 and Player:Rage() <= 18 and A.ShieldSlam:GetCooldown() > 0 or Unit(player):HasBuffs(A.Revenge.ID) > 0 and Unit(unitID):HealthPercent() > 20) or (Player:Rage() >= 60 and Unit(unitID):HealthPercent() > 35 or Unit(player):HasBuffs(A.Revenge.ID) > 0 and Unit(unitID):HealthPercent() <= 35 and Player:Rage() <= 18 and A.ShieldSlam:GetCooldown() > 0 or Unit(player):HasBuffs(A.Revenge.ID) > 0 and Unit(unitID):HealthPercent() > 35) then
                    return A.Revenge:Show(icon)
                end
            end

            if A.Execute:IsReady(unitID) and MultiUnits:GetByRange(10, 4) == 1 then
                return A.Execute:Show(icon)
            end

            if A.Revenge:IsReady(player) and inMelee then
                return A.Revenge:Show(icon)
            end

            if A.ThunderClap:IsReady(player) and inMelee and (MultiUnits:GetByRange(10, 4) >= 1 or A.ShieldSlam:GetCooldown() > 0 and Unit(player):HasBuffs(A.ViolentOutburstBuff.ID) > 0) then
                return A.ThunderClap:Show(icon)
            end

            if A.Devastate:IsReady(unitID) then
                return A.Devastate:Show(icon)
            end
            
            if A.Charge:IsReady(player) and not inMelee and Unit(unitID):GetRange() <= 20 then
                return A.Charge:Show(icon)
            end
        end
        
        if MultiUnits:GetByRange(10, 4) > 2 then
            return AOE(unitID)  
        else return Generic(unitID)
        end
        
    end

    if A.IsUnitEnemy(target) then 
        unitID = target 
        if DamageRotation(unitID) then 
            return true 
        end 
    end
end

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil

