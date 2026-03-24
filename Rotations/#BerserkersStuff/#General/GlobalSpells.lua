-------------------------------------------------------------------------------
-- Profil Loader
-------------------------------------------------------------------------------
local A = _G.Action
local isProfilLoaded = true

--################################################################################################################################################################################################################

-------------------------------------------------------------------------------
-- Profil Keys
-------------------------------------------------------------------------------
All_in_one_profil = {
    ["[Berserker]Deathknight"]   = true,
    ["[Berserker]Demonhunter"]   = true,
    ["[Berserker]Druid"]         = true,
    ["[Berserker]Evoker"]        = true,
    ["[Berserker]Hunter"]        = true,
    ["[Berserker]Mage"]          = true,
    ["[Berserker]Monk"]          = true,
    ["[Berserker]Paladin"]       = true,
    ["[Berserker]Priest"]        = true,
    ["[Berserker]Rogue"]         = true,
    ["[Berserker]Shaman"]        = true,
    ["[Berserker]Warlock"]       = true,
    ["[Berserker]Warrior"]       = true,
}

Deathknight_berserker = {
    ["[Berserker]Deathknight"]   = true,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Demonhunter_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = true,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Druid_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = true,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Evoker_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = true,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Hunter_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = true,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Mage_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = true,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Monk_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = true,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Paladin_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = true,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Priest_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = true,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Rogue_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = true,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Shaman_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = true,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = false,
}

Warlock_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = true,
    ["[Berserker]Warrior"]       = false,
}

Warrior_berserker = {
    ["[Berserker]Deathknight"]   = false,
    ["[Berserker]Demonhunter"]   = false,
    ["[Berserker]Druid"]         = false,
    ["[Berserker]Evoker"]        = false,
    ["[Berserker]Hunter"]        = false,
    ["[Berserker]Mage"]          = false,
    ["[Berserker]Monk"]          = false,
    ["[Berserker]Paladin"]       = false,
    ["[Berserker]Priest"]        = false,
    ["[Berserker]Rogue"]         = false,
    ["[Berserker]Shaman"]        = false,
    ["[Berserker]Warlock"]       = false,
    ["[Berserker]Warrior"]       = true,
}

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Big Offensive CDs
BigOffensiveCDTable = {
    --Death Knight
    51271, -- Pillar of Frost
    207289, -- Unholy Assault
    315443, -- Abomination Limb
    49206, -- Summon Gargoyle
    
    --Demon Hunter
    258860, -- Essence Break
    323639, -- The Hunt
   
    --Druid
    102560, -- Incarnation: Chosen of Elune
    102543, -- Incarnation: Avatar of Ashamane
    274837, -- Feral Frenzy
    
    --Evoker
    
    --Hunter
    360952, -- Coordinated Assault
    288613, -- Trueshot
    19574, -- Bestial Wrath
    
    --Mage
    190319, -- Combustion
    12472, -- Icy Veins
    365350, -- Arcane Surge
    
    --Monk
    137639, -- Storm, Earth, and Fire
    152173, -- Serenity
    
    --Paladin
    31884, -- Avenging Wrath
    152262, -- Seraphim
    375576, -- Divine Toll
    
    --Priest
    10060, -- Power Infusion
    391109, -- Dark Ascension
    211522, -- Psyfiend
    
    --Rogue
    360194, -- Deathmark

    --Shaman
    191634, -- Stormkeeper
    114051, -- Ascendance

    --Warlock
    267217, -- Nether Portal
    265187, -- Summon Demonic Tyrant

    --Warrior
    376079, -- Spear of Bastion
}

DamageBuffsTMW = {
    1719, -- Recklessness                        (warrior, arms)
    5217, -- Tiger's Fury                        (druid, feral)
   12042, -- Arcane Power                        (mage, arcane)
   12472, -- Icy Veins                           (mage, frost)
   13750, -- Adrenaline Rush                     (rogue, outlaw)
   19574, -- Bestial Wrath                       (hunter, beast mastery)
   31884, -- Avenging Wrath                      (paladin, retribution)
   51271, -- Pillar of Frost                     (death knight, frost)
  102543, -- Incarnation: King of the Jungle     (druid, feral)
  102560, -- Incarnation: Chosen of Elune        (druid, balance)
  106951, -- Berserk                             (druid, feral)
  107574, -- Avatar                              (warrior, arms)
  113858, -- Dark Soul: Instability              (warlock, destro)
  113860, -- Dark Soul: Misery                   (warlock, affliction)
  114050, -- Ascendance                          (shaman, elemental)
  114051, -- Ascendance                          (shaman, enhancement)
  137639, -- Storm, Earth, and Fire              (monk, windwalker)
  152173, -- Serenity                            (monk, windwalker)
  162264, -- Metamorphosis                       (demon hunter)
  185422, -- Shadow Dance                        (rogue, subtlety)
  190319, -- Combustion                          (mage, fire)
  194223, -- Celestial Alignment                 (druid, balance)
  194249, -- Voidform                            (priest, shadow)
  198144, -- Ice Form                            (mage, frost)
  199261, -- Death Wish                          (warrior, fury)
  207289, -- Unholy Frenzy                       (death knight, unholy)
  212155, -- Tricks of the Trade                 (rogue, Outlaw, PVP talent)
  212283, -- Symbols of Death                    (rogue, subtlety)
  216331, -- Avenging Crusader                   (paladin, holy)
  248622, -- In for the Kill                     (warrior, arms)
  262228, -- Deadly Calm                         (warrior, arms)
  266779, -- Coordinated Assault                 (hunter, survival)
  288613, -- Trueshot                            (hunter, marksman)
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- All Offensive CDs
AllOffensiveCDTable = {
    --Death Knight
    51271, -- Pillar of Frost
    279302, -- Frostwyrm's Fury
    305392, -- Chill Streak
    207289, -- Unholy Assault
    315443, -- Abomination Limb
    49206, -- Summon Gargoyle
    288853, -- Raise Abomination
    275699, -- Apocalypse
    63560, -- Dark Transformation
    
    --Demon Hunter
    191427, -- Metamorphosis
    258860, -- Essence Break
    323639, -- The Hunt
   
    --Druid
    102560, -- Incarnation: Chosen of Elune
    102543, -- Incarnation: Avatar of Ashamane
    274837, -- Feral Frenzy
    194223, -- Celestial Alignment
    106951, -- Berserk
    
    --Evoker
    357210, -- Deep Breath
    370553, -- Tip the Scales
    375087, -- Dragonrage

    --Hunter
    360952, -- Coordinated Assault
    288613, -- Trueshot
    19574, -- Bestial Wrath
    392060, -- Wailing Arrow
    375891, -- Death Chakram
    260402, -- Double Tap
    
    --Mage
    190319, -- Combustion
    12472, -- Icy Veins
    365350, -- Arcane Surge
    321507, -- Touch of the Magi
    205025, -- Presence of Mind
    84714, -- Frozen Orb
    389794, -- Snowdrift
    
    --Monk
    137639, -- Storm, Earth, and Fire
    386276, -- Bonedust Brew
    152173, -- Serenity
    392983, -- Strike of the Windlord
    123904, -- Invoke Xuen, the White Tiger
    392991, -- Skyreach
    
    --Paladin
    31884, -- Avenging Wrath
    152262, -- Seraphim
    343721, -- Final Reckoning
    375576, -- Divine Toll
    343527, -- Execution Sentence
    
    --Priest
    10060, -- Power Infusion
    228260, -- Void Eruption
    391109, -- Dark Ascension
    211522, -- Psyfiend
    375901, -- Mindgames
    197871, -- Dark Archangel
    
    --Rogue
    360194, -- Deathmark
    13750, -- Adrenaline Rush
    121471, -- Shadow Blades
    381623, -- Thistle Tea
    385616, -- Echoing Reprimand
    5938, -- Shiv
    343142, -- Dreadblades
    212283, -- Symbols of Death

    --Shaman
    198067, -- Fire Elemental
    2825, -- Bloodlust
    114051, -- Ascendance
    191634, -- Stormkeeper
    204330, -- Skyfury Totem
    51533, -- Feral Spirit
    384352, -- Doom Winds
    355580, -- Static Field Totem

    --Warlock
    267217, -- Nether Portal
    1122, -- Summon Infernal
    205180, -- Summon Darkglare
    386997, -- Soul Rot
    265187, -- Summon Demonic Tyrant
    267171, -- Demonic Strength
    104316, -- Call Dreadstalkers
    6789, -- Mortal Coil
    196586, -- Dimensional Rift
    80240, -- Havoc

    --Warrior
    107574, -- Avatar
    376079, -- Spear of Bastion
    1719, -- Recklessness
    227847, -- Bladestorm
    262161, -- Warbreaker
    198817, -- Sharpen Blade
    384318, -- Thunderous Roar
    385059, -- Odyn's Fury
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- All Offensive Magic CDs @TODO
AllOffensiveMagicCDTable = {
    --Death Knight
    279302, -- Frostwyrm's Fury (Frost)
    305392, -- Chill Streak (Frost)
    207289, -- Unholy Assault (Shadow)
    315443, -- Abomination Limb (Shadow)
    49206, -- Summon Gargoyle (Shadow)
    275699, -- Apocalypse (Shadow)
    63560, -- Dark Transformation (Shadow)
    
    --Demon Hunter
    258860, -- Essence Break (Fire, Nature, Frost, Shadow, Arcane)
    323639, -- The Hunt (Nature)
   
    --Druid
    194223, -- Celestial Alignment (Nature, Arcane)
    
    --Evoker
    357210, -- Deep Breath (Fire, Nature)
    370553, -- Tip the Scales (Arcane)

    --Hunter
    360952, -- Coordinated Assault (Nature)
    392060, -- Wailing Arrow (Shadow)
    
    --Mage
    190319, -- Combustion (Fire)
    12472, -- Icy Veins (Frost)
    365350, -- Arcane Surge (Arcane)
    321507, -- Touch of the Magi (Arcane)
    205025, -- Presence of Mind (Arcane)
    84714, -- Frozen Orb (Frost)
    389794, -- Snowdrift (Frost)
    
    --Monk
    137639, -- Storm, Earth, and Fire (Nature)
    386276, -- Bonedust Brew (Shadow)
    123904, -- Invoke Xuen, the White Tiger (Nature)
    
    --Paladin
    31884, -- Avenging Wrath (Holy)
    152262, -- Seraphim (Holy)
    343721, -- Final Reckoning (Holy)
    375576, -- Divine Toll (Arcane)
    343527, -- Execution Sentence (Holy)
    
    --Priest
    10060, -- Power Infusion (Holy)
    228260, -- Void Eruption (Shadow)
    391109, -- Dark Ascension (Shadow)
    211522, -- Psyfiend (Shadow)
    375901, -- Mindgames (Shadow)
    197871, -- Dark Archangel (Shadow)
    
    --Rogue
    385616, -- Echoing Reprimand (Arcane)

    --Shaman
    198067, -- Fire Elemental (Fire)
    2825, -- Bloodlust (Nature)
    114051, -- Ascendance (Nature)
    191634, -- Stormkeeper (Nature)
    204330, -- Skyfury Totem (Fire)
    51533, -- Feral Spirit (Nature)
    355580, -- Static Field Totem (Nature)

    --Warlock
    267217, -- Nether Portal (Shadow)
    1122, -- Summon Infernal (Fire)
    205180, -- Summon Darkglare (Shadow)
    386997, -- Soul Rot (Nature)
    265187, -- Summon Demonic Tyrant (Shadow)
    267171, -- Demonic Strength (Shadow)
    104316, -- Call Dreadstalkers (Shadow)
    6789, -- Mortal Coil (Shadow)
    196586, -- Dimensional Rift (Physical, Holy, Fire, Nature, Frost, Shadow, Arcane)
    80240, -- Havoc (Shadow)

    --Warrior
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- All Offensive Physical CDs @TODO
AllOffensivePhysicalCDTable = {
    --Death Knight
    51271, -- Pillar of Frost
    288853, -- Raise Abomination
    
    --Demon Hunter
    191427, -- Metamorphosis
   
    --Druid
    102560, -- Incarnation: Chosen of Elune
    102543, -- Incarnation: Avatar of Ashamane
    274837, -- Feral Frenzy
    106951, -- Berserk
    
    --Evoker
    375087, -- Dragonrage

    --Hunter
    288613, -- Trueshot
    19574, -- Bestial Wrath
    375891, -- Death Chakram
    260402, -- Double Tap
    
    --Mage
    
    --Monk
    152173, -- Serenity
    392983, -- Strike of the Windlord
    392991, -- Skyreach
    
    --Paladin
    
    --Priest
    
    --Rogue
    360194, -- Deathmark (Bleeding)
    13750, -- Adrenaline Rush
    121471, -- Shadow Blades
    381623, -- Thistle Tea
    5938, -- Shiv
    343142, -- Dreadblades
    212283, -- Symbols of Death

    --Shaman
    384352, -- Doom Winds

    --Warlock

    --Warrior
    107574, -- Avatar
    376079, -- Spear of Bastion
    1719, -- Recklessness
    227847, -- Bladestorm
    262161, -- Warbreaker
    198817, -- Sharpen Blade
    384318, -- Thunderous Roar
    385059, -- Odyn's Fury
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AllDisarmCDTable = {
    --Death Knight
    51271, -- Pillar of Frost
    279302, -- Frostwyrm's Fury
    305392, -- Chill Streak
    207289, -- Unholy Assault
    315443, -- Abomination Limb
    49206, -- Summon Gargoyle
    288853, -- Raise Abomination
    275699, -- Apocalypse
    63560, -- Dark Transformation
    
    --Demon Hunter
    191427, -- Metamorphosis
    258860, -- Essence Break
    323639, -- The Hunt

    --Hunter
    360952, -- Coordinated Assault
    288613, -- Trueshot
    19574, -- Bestial Wrath
    375891, -- Death Chakram
    260402, -- Double Tap
    
    --Paladin
    31884, -- Avenging Wrath
    152262, -- Seraphim
    343721, -- Final Reckoning
    375576, -- Divine Toll
    343527, -- Execution Sentence

    --Rogue
    360194, -- Deathmark
    13750, -- Adrenaline Rush
    121471, -- Shadow Blades
    385616, -- Echoing Reprimand
    343142, -- Dreadblades
    212283, -- Symbols of Death

    --Shaman
    114051, -- Ascendance
    204330, -- Skyfury Totem
    51533, -- Feral Spirit
    384352, -- Doom Winds

    --Warrior
    107574, -- Avatar
    376079, -- Spear of Bastion
    1719, -- Recklessness
    262161, -- Warbreaker
    384318, -- Thunderous Roar
    385059, -- Odyn's Fury
    118038, -- Die by the Sword (will cancel it)
}

--#####################################################################################################################################################################################

--Avoid Dispels with Frozen Binds | Malevolence | Intangible Presence | Unstable Affliction | Vampiric Touch | Chronoshear
AvoidDispelTable = {
    320788, 350469, 227404, 30108, 250037, 413013
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Magic Dispel
MagicDispelTable = {
    448561, -- Shadows of Doubt
    440238, -- Ice Sickles
    322557, -- Soul Split
    325224, -- Anima Injection
    275014, -- Putrid Waters
    272571, -- Choking Waters
    432448, -- Stygian Seed
    426735, -- Burning Shadows
    432520, -- Umbral Barrier
    323347, -- Clinging Darkness
    --424889, -- Seismic Reverberation
    449154, -- Molten Mortar
    428161, -- Molten Metal
    429545, -- Censoring Gear
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Curse Dispel
CurseDispelTable = {
    451224, -- Enveloping Shadowflame
    450095, -- Curse of Entropy
    322968, -- Dying Breath
    257168, -- Cursed Slash
    426308, -- Void Infection
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Disease Dispel
DiseaseDispelTable = {
    454440, -- Stinky Vomit
    272588, -- Rotting Wounds
    321821, -- Disgusting Guts
    320596, -- Heaving Retch
    338353, -- Goresplatter
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Poison Dispel
PoisonDispelTable = {
    438618, -- Venomous Spit
    436322, -- Poison Bolt
    448248, -- Revolting Volley
    433841, -- Venom Volley
    461487, -- Cultivated Poisons
    443401, -- Venom Strike
    440160, -- Poison Bolt
    275743, -- Venomous Spray
    340288, -- Triple Bite
    326092, -- Debilitating Poison
    340304, -- Poisonous Secretions
    275836, -- Stinging Venom
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Enrage Dispel
EnrageDispelTable = {
    441645, -- Unnatural Bloodlust
    451040, -- Rage
    451379, -- Reckless Tactic
    327155, -- Vengeful Rage
    320012, -- Unholy Frenzy
    320703, -- Seething Rage
    451112, -- Tactician's Rage
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--High priority Purge PVE
ImportantPurgeTable = {
    324914, -- Nourish the Forest
    324776, -- Bramblethorn Coat
    326046, -- Stimulate Resistance
    256957, -- Watertight Shell
    275826, -- Bolstering Shout
    431493, -- Darkblade
    450756, -- Abyssal Howl
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Magic Dispel PVP
MagicDispelTablePvp = {
    --Disorients
    605, --mind control
    8122, --psychic scream
    205369, --mind bomb
    115750, --blinding light
    5782, --fear
    5484, --howl of terror
    6358, --seduction
    198898, --song of chi-ji
    
    --Incapacitates
    2637, --hibernate
    217832, --imprison
    118, --polymorph
    113724, --ring of frost
    187650, --freezing trap
    20066, --repentance
    
    --Silences
    47476, --strangulate
    
    --Roots
    339, --entangling roots
    122, --frost nova
    102359, --mass entanglement
    33395, --freeze
    109248, --binding shot
    51485, --earthgrab totem
    358385, --Landslide
    --262303, --surge of power
    
    --Stuns
    853, --hammer of justice
    179057, --chaos Nova
    64044, --psychic horror
    200199, --censure
    
    --Other
    323673, --mindgames old
    323701, --mindgames new 1
    375901, --mindgames new 2
    80240, --havoc
    325640, --soul rot
}

--#####################################################################################################################################################################################

------------------------------------
--- Table with Damage Buffs for Power Infusion - some of the IDs here leave no Buff - ToDo find a better way
------------------------------------
PiTable = {
    -- Death Knight
    42650,          -- Army of Dead
    275699,         -- Apocalypse
    315443,         -- Abomination Limb
    47568,			-- Empower Rune Weapon
    -- Demon Hunter
    191427,         -- Metamorphosis
    --Druid
    194223,			-- Celestial Alignment
    102560,			-- Incarnation: Chosen of Elune
    106951, 		-- Berserk 
    102543, 		-- Incarnation: King of the Jungle
    --Evoker
    375087,
    -- Hunter
    193530,			-- Aspect of the Wild
    19574,			-- Bestial Wrath
    288613,			-- TrueShot
    266779,			-- Coordinated Assault
    --Mage
    12042, 			-- Arcane Power   
    190319,         -- Combustion
    12472,			-- Icy Veins
    -- Monk
    123904,         -- Invoke Xuen
    137639,         -- Storm, Earth and Fire
    152173,         -- Serenity
    -- Paladin
    231895,         -- Crusade
    31884,          -- Avenging Wrath
    -- Priest
    194249,			-- Voidform
    228260,         -- Void Eruption
    319952,			-- Surrender to Madness
    -- Rogue
    121471,         -- Shadow Blades
    13750,          -- Adrenaline Rush
    79140,			-- Vendetta
    -- Shaman
    198067,			-- Fire Elemental
    192249,			-- Storm Elemental
    114050,			-- Asdendance Elemental
    114051,			-- Ascendence Enhancement
    333957,			-- Feral Spirit
    --Warlock
    113860,			-- Dark Soul Misery
    265273,			-- Demonic Power
    267218,			-- Nether Portal
    113858,			-- Dark Soul Instability
    266087,			-- Rain of Chaos
    344566,         -- RapidContagion
    -- Warrior
    107574,         -- Avatar
    1719,			-- Recklessness
}

--#####################################################################################################################################################################################

--Avoid all actions
Full_Immune_Buffs = {
    642,    --Divine Shield
    45438,  --Ice Block
    186265, --Aspect of Turtle     
    215769, --Spirit of Redemption
    196555, --Netherwalk
    408557, --Phase Shift
    421453, --Ultimate Penitence
    --740,    --Tranquility (Replacing with Keeper of the Grove)
    392486, -- Keeper of the Grove
    362486, -- Keeper of the Grove
    409293, --Burrow
    378441, --Time stop
}

Full_Immune_DeBuffs = {
    33786,  --Cyclone
    3355,   -- Freezing Trap
    217832, --Imprison
    203340, --Diamond Ice
    221527  --Imprison Pvp Talent
}

--Avoid all physical actions
Phys_Immune_Buffs = {
    1022,   --Blessing of Protection
  	5277,   --Evasion
   	118038  --Die by the Sword
}

--Avoid all magical actions
Magic_Immune_Buffs = {
	31224,  -- Cloak of Shadows
	204018, -- Blessing of Spellwarding
   	48707,  --Anti Magic Shell
    8178,   --Grounding Totem
    212295, --Nether Ward
    115310, --Revival
    388615, -- Restoral
    353313, --Peaveweaver 1
    353319  --Peaveweaver 2
}

--Avoid some magical actions
Magic_Immune_UnholyBlight = {
	31224,  -- Cloak of Shadows
	204018, -- Blessing of Spellwarding
    115310, --Revival
    388615, -- Restoral
    353313, --Peaveweaver 1
    353319  --Peaveweaver 2
}

--Avoid all Kicks
Kick_Immune_Buffs = {
    104773, --Unending Resolve 
    377360, --Precognition
    131557, --Spiritwalker’s Aegis
    209584, --Zen Focus Tea
    378444  --Obsidian Mettle
}

--Avoid all CC
CC_Immune_Buffs = {
    104773, --Unending Resolve
    115310, --Revival 
    378464, --Nullifying Shroud
    377360, --Precognition
    227847, --Bladestorm
    213610, --Holy Ward
    357210, --Deep Breath
    354489, --Glimpse
    8178,   --Grounding Totem - Not a immunity but want to avoid CCs while Totem is up
    317929,  --Aura Mastery
    473909, -- Ancient of Lore
    455945, -- Absolute Serenity
    456499, -- Absolute Serenity
}

Active_CC_Debuffs_Magic = {
    853,    --Hammer of Justice
    118,    --Polymorph
    5782,   --Fear
    47476,  --Strangulate
    15487,  --Silence
    51514,  --Hex
    187650, --Freezing Trap
    20066,  --Repentance
    360806  --Sleep Walk
}

--Found this List in TMW/DR List Spells.lua
Active_CC_Debuffs = {
    --disorient
    207167  ,       -- Blinding Sleet
    207685  ,       -- Sigil of Misery
    33786   ,       -- Cyclone
    360806  ,       -- Sleep Walk
    1513    ,       -- Scare Beast
    31661   ,       -- Dragon's Breath
    198909  ,       -- Song of Chi-ji
    202274  ,       -- Hot Trub
    105421  ,       -- Blinding Light
    10326   ,       -- Turn Evil
    205364  ,       -- Dominate Mind
    605     ,       -- Mind Control
    8122    ,       -- Psychic Scream
    226943  ,       -- Mind Bomb
    2094    ,       -- Blind
    118699  ,       -- Fear
    130616  ,       -- Fear (Horrify)
    5484    ,       -- Howl of Terror
    261589  ,       -- Seduction (Grimoire of Sacrifice)
    6358    ,       -- Seduction (Succubus)
    5246    ,       -- Intimidating Shout 1
    316593  ,       -- Intimidating Shout 2 (TODO: not sure which one is correct in 9.0.1)
    316595  ,       -- Intimidating Shout 3
    331866  ,       -- Agent of Chaos (Venthyr Covenant)

    --incapacitate
    217832  ,    -- Imprison
    221527  ,    -- Imprison (Honor talent)
    2637    ,    -- Hibernate
    99      ,    -- Incapacitating Roar
    378441  ,    -- Time Stop
    3355    ,    -- Freezing Trap
    203337  ,    -- Freezing Trap (Honor talent)
    213691  ,    -- Scatter Shot
    383121  ,    -- Mass Polymorph
    118     ,    -- Polymorph
    28271   ,    -- Polymorph (Turtle)
    28272   ,    -- Polymorph (Pig)
    61025   ,    -- Polymorph (Snake)
    61305   ,    -- Polymorph (Black Cat)
    61780   ,    -- Polymorph (Turkey)
    61721   ,    -- Polymorph (Rabbit)
    126819  ,    -- Polymorph (Porcupine)
    161353  ,    -- Polymorph (Polar Bear Cub)
    161354  ,    -- Polymorph (Monkey)
    161355  ,    -- Polymorph (Penguin)
    161372  ,    -- Polymorph (Peacock)
    277787  ,    -- Polymorph (Baby Direhorn)
    277792  ,    -- Polymorph (Bumblebee)
    321395  ,    -- Polymorph (Mawrat)
    391622  ,    -- Polymorph (Duck)
    82691   ,    -- Ring of Frost
    115078  ,    -- Paralysis
    357768  ,    -- Paralysis 2 (Perpetual Paralysis?)
    20066   ,    -- Repentance
    9484    ,    -- Shackle Undead
    200196  ,    -- Holy Word: Chastise
    1776    ,    -- Gouge
    6770    ,    -- Sap
    51514   ,    -- Hex
    196942  ,    -- Hex (Voodoo Totem)
    210873  ,    -- Hex (Raptor)
    211004  ,    -- Hex (Spider)
    211010  ,    -- Hex (Snake)
    211015  ,    -- Hex (Cockroach)
    269352  ,    -- Hex (Skeletal Hatchling)
    309328  ,    -- Hex (Living Honey)
    277778  ,    -- Hex (Zandalari Tendonripper)
    277784  ,    -- Hex (Wicker Mongrel)
    197214  ,    -- Sundering
    710     ,    -- Banish
    6789    ,    -- Mortal Coil
    107079  ,    -- Quaking Palm (Pandaren racial)

    --silence
    47476   ,         -- Strangulate
    204490  ,         -- Sigil of Silence
    410065  ,         -- Reactive Resin
    202933  ,         -- Spider Sting
    356727  ,         -- Spider Venom
    354831  ,         -- Wailing Arrow 1
    355596  ,         -- Wailing Arrow 2
    217824  ,         -- Shield of Virtue
    15487   ,         -- Silence
    1330    ,         -- Garrote
    196364  ,         -- Unstable Affliction Silence Effect

    --stun
    210141  ,            -- Zombie Explosion
    334693  ,            -- Absolute Zero (Breath of Sindragosa)
    108194  ,            -- Asphyxiate (Unholy)
    221562  ,            -- Asphyxiate (Blood)
    91800   ,            -- Gnaw (Ghoul)
    91797   ,            -- Monstrous Blow (Mutated Ghoul)
    287254  ,            -- Dead of Winter
    179057  ,            -- Chaos Nova
    205630  ,            -- Illidan's Grasp (Primary effect)
    208618  ,            -- Illidan's Grasp (Secondary effect)
    211881  ,            -- Fel Eruption
    200166  ,            -- Metamorphosis (PvE stun effect)
    203123  ,            -- Maim
    163505  ,            -- Rake (Prowl)
    5211    ,            -- Mighty Bash
    202244  ,            -- Overrun
    325321  ,            -- Wild Hunt's Charge
    372245  ,            -- Terror of the Skies
    117526  ,            -- Binding Shot
    357021  ,            -- Consecutive Concussion
    24394   ,            -- Intimidation
    389831  ,            -- Snowdrift
    119381  ,            -- Leg Sweep
    202346  ,            -- Double Barrel
    385149  ,            -- Exorcism
    853     ,            -- Hammer of Justice
    255941  ,            -- Wake of Ashes
    64044   ,            -- Psychic Horror
    200200  ,            -- Holy Word: Chastise Censure
    1833    ,            -- Cheap Shot
    408     ,            -- Kidney Shot
    118905  ,            -- Static Charge (Capacitor Totem)
    118345  ,            -- Pulverize (Primal Earth Elemental)
    305485  ,            -- Lightning Lasso
    89766   ,            -- Axe Toss
    171017  ,            -- Meteor Strike (Infernal)
    171018  ,            -- Meteor Strike (Abyssal)
    30283   ,            -- Shadowfury
    385954  ,            -- Shield Charge
    46968   ,            -- Shockwave
    132168  ,            -- Shockwave (Protection)
    145047  ,            -- Shockwave (Proving Grounds PvE)
    132169  ,            -- Storm Bolt
    199085  ,            -- Warpath
    20549   ,            -- War Stomp (Tauren)
    255723  ,            -- Bull Rush (Highmountain Tauren)
    287712  ,            -- Haymaker (Kul Tiran)
    332423               -- Sparkling Driftglobe Core (Kyrian Covenant)
}

--Found this List in TMW/DR List Spells.lua
Root_Debuff = {
    204085  ,            -- Deathchill (Chains of Ice)
    233395  ,            -- Deathchill (Remorseless Winter)
    339     ,            -- Entangling Roots
    235963  ,            -- Entangling Roots (Earthen Grasp)
    170855  ,            -- Entangling Roots (Nature's Grasp)
    102359  ,            -- Mass Entanglement
    355689  ,            -- Landslide
    393456  ,            -- Entrapment (Tar Trap)
    162480  ,            -- Steel Trap
    273909  ,            -- Steelclaw Trap
    212638  ,            -- Tracker's Net
    201158  ,            -- Super Sticky Tar
    122     ,            -- Frost Nova
    33395   ,            -- Freeze
    386770  ,            -- Freezing Cold
    198121  ,            -- Frostbite
    114404  ,            -- Void Tendril's Grasp
    342375  ,            -- Tormenting Backlash (Torghast PvE)
    233582  ,            -- Entrenched in Flame
    116706  ,            -- Disable
    324382  ,            -- Clash
    64695   ,            -- Earthgrab (Totem effect)
    285515  ,            -- Surge of Power
    199042  ,            -- Thunderstruck (Protection PvP Talent)
    39965   ,            -- Frost Grenade (Item)
    75148   ,            -- Embersilk Net (Item)
    55536   ,            -- Frostweave Net (Item)
    268966  ,            -- Hooked Deep Sea Net (Item)
    91802   ,            -- Shambling Rush
    454787  ,            -- Ice Prison
    454786  ,            -- Ice Prison2
    316595  ,            -- Intimidating Shout
    316593  ,            -- Intimidating Shout
    5246    ,            -- Intimidating Shout

    --PVE
    442210, -- Silken Restraints
    433662, -- Grasping Blood
    433781, -- Ceaseless Swarm
    433785, -- Grasping Slash
    434083, -- Ambush
    446718, -- Umbral Weave
    443430, -- Silk Binding
    443427, -- Web Bolt
    451104, -- Bursting Cocoon
    439780, -- Sticky Webs
    287295, -- Chilled
    320788, -- Frozen Binds
    464876, -- Concussive Smash
    425974, -- Ground Pound
}

--Anti-Magic Shell Dispel Table
AMS_Dispell = {
    390612  ,            -- Frost Bomb
    44457   ,            -- Living Bomb
    410201  ,            -- Searing Glare
    122470  ,            -- Karma
}

--Anti-Magic Shell Enemey Buff Table
AMS_Bufftable = {
    31884   ,           -- Avenging Wrath
    391109  ,           -- Dark Ascension
    450716  ,           -- Lit Fuse
    51271   ,           -- Pillar of Frost
    207289  ,           -- Unholy Assault
    384352  ,           -- Doomwinds
    325640  ,           -- Soul Rot
    114051  ,           -- Ascendance
    357210  ,           -- Deep Breath
}

--AntiMagic Shell Debuff Table
AMS_Debufftable = {
    122470  ,           -- Karma
    125174  ,           -- Karma 2
    124280  ,           -- Karma 3
    6789    ,           -- Mortal Coil
    389794  ,           -- Snowdrift
    385627  ,           -- Kingsbane
    80240   ,           -- Havoc
    258860  ,           -- Essence Break
}

--Only Dot Immune
DOT_Immune_Table = {
    6940    ,           -- Blessing of Sacrifice
    137027  ,           -- Blessing of Sac Ret
    137028  ,           -- Blessing of Sac Prot
    137029  ,           -- Blessing of Sac Holy
}

--Found this List in TMW/DR List Spells.lua
Disarm_Debuff = {
    209749  ,          -- Faerie Swarm (Balance Honor Talent)
    407032  ,          -- Sticky Tar Bomb 1
    407031  ,          -- Sticky Tar Bomb 2
    207777  ,          -- Dismantle
    233759  ,          -- Grapple Weapon
    236077             -- Disarm
}

Slowed_Debuff = {
    116,  -- Frostbolt                           (mage, frost)
    1715, -- Hamstring                           (warrior, arms)
    2120, -- Flamestrike                         (mage, fire)
    3409, -- Crippling Poison                    (rogue, assassination)
    3600, -- Earthbind                           (shaman, general)
    5116, -- Concussive Shot                     (hunter, beast mastery/marksman)
    6343, -- Thunder Clap                        (warrior, protection)
    7992, -- Slowing Poison                      (NPC ability)
    12323, -- Piercing Howl                       (warrior, fury)
    12486, -- Blizzard                            (mage, frost)
    12544, -- Frost Armor                         (NPC ability only now?)
    15407, -- Mind Flay                           (priest, shadow)
    31589, -- Slow                                (mage, arcane)
    35346, -- Warp Time                           (NPC ability)
    44614, -- Flurry                              (mage, frost)
    45524, -- Chains of Ice                       (death knight)
    50259, -- Dazed                               (druid, PVE talent, general)
    50433, -- Ankle Crack                         (hunter pet)
    51490, -- Thunderstorm                        (shaman, elemental)
    58180, -- Infected Wounds                     (druid, feral)
    61391, -- Typhoon                             (druid, general)
    116095, -- Disable                             (monk, windwalker)
    118000, -- Dragon Roar                         (warrior, PVE talent, fury)
    121253, -- Keg Smash                           (monk, brewmaster)
    123586, -- Flying Serpent Kick                 (monk, windwalker)
    127797, -- Ursol's Vortex                      (druid, restoration)
    135299, -- Tar Trap                            (hunter, survival)
    147732, -- Frostbrand Attack                   (shaman, enhancement)
    157981, -- Blast Wave                          (mage, fire)
    160065, -- Tendon Rip                          (hunter pet)
    160067, -- Web Spray                           (pet ability)
    183218, -- Hand of Hindrance                   (paladin, retribution)
    185763, -- Pistol Shot                         (rogue, outlaw)
    186387, -- Bursting Shot                       (hunter, marks)
    195645, -- Wing Clip                           (hunter, survival)
    196840, -- Frost Shock                         (shaman, elemental)
    198222, -- System Shock                        (rogue, assassination)
    198813, -- Vengeful Retreat                    (demon hunter, havoc)
    201787, -- Heavy-Handed Strikes                (monk, windwalker)
    204263, -- Shining Force                       (priest, disc/holy)
    204843, -- Sigil of Chains                     (demon hunter, veng)
    205021, -- Ray of Frost                        (mage, frost)
    205708, -- Chilled                             (mage, frost)
    206930, -- Heart Strike                        (death knight, blood)
    208278, -- Debilitating Infestation            (DK unholy talent)
    211793, -- Remorseless Winter                  (death knight, frost)
    212792, -- Cone of Cold                        (mage, frost)
    213405, -- Master of the Glaive                (demon hunter, PVE talent, havoc)
    228354, -- Flurry                              (mage, frost)
    255937, -- Wake of Ashes                       (paladin, PVE talent, retribution)
    257478, -- Crippling Bite                      (Freehold dungeon)
    257777, -- Crippling Shiv                      (Tol Dagor dungeon)
    258313, -- Handcuff                            (Tol Dagor dungeon)
    267899, -- Hindering Cleave                    (Shrine of the Storms dungeon)
    268896, -- Mind Rend                           (Shrine of the Storms dungeon)
    270499, -- Frost Shock                         (King's Rest dungeon)
    271564, -- Embalming Fluid                     (King's Rest dungeon)
    272834, -- Viscous Slobber                     (Siege of Boralus dungeon)
    273977, -- Grip of the Dead                    (death knight, unholy)
    277953, -- Night Terrors                       (rogue, subtlety)
    279303, -- Frostwyrm's Fury                    (death knight, PVE talent, frost)
    280184, -- Sweep the Leg                       (monk, azerite trait)
    280583, -- Cauterized                          (engineering goggles azerite trait)
    280604, -- Iced Spritzer                       (Motherload dungeon)
    288962, -- Blood Bolt                          (hunter pet)
    289308, -- Frozen Orb                          (mage, frost)
    289526, -- Everchill                           (Everchill Anchor, from Battle of Dazar'alor raid)
    290366  -- Commandant's Frigid Winds           (Daelin Proudmoore's Saber+Lord Admiral's Signet 2-set, from Battle of Dazar'alor raid)
}

--#####################################################################################################################################################################################

ArenaKicks = {
    [118] = true,      -- Polymorph
    [5782] = true,     -- Fear
    [20066] = true,    -- Repentence
    [51514] = true,    -- Hex
    [33786] = true,    -- Cyclone
    [323673] = true,   -- Mindgames
    [323701] = true,   -- Mindgames
    [605] = true,      -- Mind Control
    [205367] = true,   -- Dominate Mind
    [323764] = true,   -- Convoke
    [360806] = true,   -- Sleep Walk
    [47540] = true,    -- Penance
    [186723] = true,   -- Penance
    [2060] = true,     -- Heal
    [2061] = true,     -- Flash Heal
    [289666] = true,   -- Greater Heal
    [64843] = true,    -- Divine Hymn
    [265202] = true,   -- Holy Word: Salvation
    [8936] = true,     -- Regrowth
    [289022] = true,   -- Nourish
    [48438] = true,    -- Wild Growth
    [202771] = true,   -- Full Moon
    [77472] = true,    -- Healing Wave
    [8004] = true,     -- Healing Surge
    [1064] = true,     -- Chain Heal
    [73920] = true,    -- Healing Rain
    [197995] = true,   -- Wellspring
    [207778] = true,   -- Downpour
    [305483] = true,   -- Lightning Lasso
    [19750] = true,    -- Flash of Light
    [82326] = true,    -- Holy Light
    [410126] = true,   -- Searing Glare
    [115175] = true,   -- Soothing Mist
    [116670] = true,   -- Vivify
    [124682] = true,   -- Enveloping Mist
    [191837] = true,   -- Essence Font
    [227344] = true,   -- Surging Mist
    [376788] = true,   -- Dream Breath
    [367226] = true,   -- Spiritbloom
    [361469] = true,   -- Living Flame
    --[198013] = true,   -- Eye Beam
    [113724] = true,   -- Ring of Frost
    [199786] = true,   -- Glacial Spike
    [365350] = true,   -- Arcane Surge
    [234153] = true,   -- Drain Life
    [116858] = true,   -- Chaos Bolt
    [421453] = true,   -- Ultimate Penitence
    [357208] = true,   -- Firebreath
    [305484] = true,   -- Lightning Lasso
    [305485] = true,   -- Lightning Lasso
    [204437] = true,   -- Lightning Lasso
}

--#####################################################################################################################################################################################

ArenaDispelDebuffs = {
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

    -- Other
    [323673] = true, -- mindgames old
    [323701] = true, -- mindgames new 1
    [375901] = true, -- mindgames new 2
    [80240] = true,  -- havoc
    [325640] = true  -- soul rot
}

--#####################################################################################################################################################################################

PurgeableBuffs = {
    [10060] = true,    -- Power Infusion
    [1022] = true,     -- Blessing of Protection
    [79206] = true,    -- Spiritwalkers Grace
    [12042] = true,    -- Arcane Power
    [12472] = true,    -- Icy Veins
    [467] = true,      -- Thorns 
    [29166] = true,    -- Innervate  
    [358267] = true,   -- Hover
    [378464] = true,   -- Nullifying Shroud
    [108978] = true,   -- Alter Time
}

--#####################################################################################################################################################################################

SlowImmuneBuffs = {
    [642] = true, -- Divine Shield
    [45438] = true, -- Ice Block
    [186265] = true, -- Aspect of Turtle     
    [215769] = true, -- Spirit of Redemption
    [33786] = true,  -- Cyclone
    [227847] = true, -- Bladestorm  
    [768] = true, -- Cat Form
    [5487] = true, -- Bear Form
    [783] = true, -- Travel Form
    [31224] = true, -- Cloak of Shadows
    [204018] = true, -- Blessing of Spellwarding    
    [48707] = true, -- Anti Magic Shell
    [23920] = true, -- Spell Reflection
    [444347] = true, -- Spell Reflection
    [213915] = true, -- Mass reflect
    [212295] = true, -- Nether Ward (Warlock)
    [1022] = true, -- Blessing of Protection
    [1044] = true, -- Blessing of Freedom
    [48265] = true, -- Death's Advance
    [212552] = true, -- Wraith Walk
    [53271] = true, -- Master's Call    
    [116841] = true, -- Tiger's Lust
    [216113] = true, -- Way of the Crane (Monk TT PvP)
    [358267] = true -- Hover
}

--#####################################################################################################################################################################################

DontGripMe = {
    206959,     -- Rain from Above
    206804,     -- Rain from Above
    73325,      -- Leap of Faith
    113942,     -- Demonic Gateway?
    376079,     -- Spear of Bastion
    357210,     -- Deep Breath
    444347,     -- Death Charge
    23920,      -- Spell Reflection
    444347,     -- Spell Reflection
    212295,     -- Nether Ward
    31224,      -- Cloak of Shadows
    204018,     -- Blessing of Spellwarding
    329543,     -- Divine Ascension
}
