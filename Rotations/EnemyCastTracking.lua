local Action = _G.Action
local InstanceInfo = Action.InstanceInfo

makuluReactionTable = {
    [2579] = { -- Dawn of the Infinite (Dungeon ID is Season 2 full dungeon but table is for Galakrond's Fall, Murozond's Rise is at the very bottom of table)
        Interrupts = {
            411994, -- Chronomelt (all)
            412012, -- Temposlice (cc only)
            415770, -- Infinite Bolt Volley (interrupt only)
            415435, -- Infinite Boly (all)
            415437, -- Enervate (all)
            416256, -- Stonebolt (all)
        },
        TankDefensive = {
            413013, -- Chronoshear
        },
        AoEDefensiveEndCast = {
            413622, -- Infinite Fury
            407978, -- Necrotic Winds
            414535, -- Stonecracker Barrage
        },
        AoEDefensiveStartCast = {
            414184, -- Cataclysmic Obliteration
        },
        DebuffDefensive = {
            408029, -- Necrofrost
        },
        HealerCooldown = {
            413622, -- Infinite Fury
            414184, -- Cataclysmic Obliteration
        },
        Dispel = {
            415436, -- Tainted Sands
        },
        DispelPlus = {
            404141, -- Chrono-faded (only dispel when unit also has Debuff 403912 Accelerating Time)
        },
        Purge = {
            423717, -- Bloom
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            413105, -- Eon Shatter (need to figure out how to check Eon Residue after Shatter)
            413529, -- Untwist
            404141, -- Chrono-faded
            413618, -- Timeless Curse
            412806, -- Blight Spew
            407027, -- Corrosive Expulsion
            407978, -- Necrotic Winds
            414535, -- Stonecracker Barrage
            409635, -- Pulverizing Exhalation
            414184, -- Cataclysmic Obliteration
        },
        MovementLockDebuff = {
            401420, -- Sand Stomp
            410901, -- Extinction Blast (needs ID check)
        },
        MovementLockEnemyBuff = {
            414452, -- Earthsurge
        },
    },
    [1862] = { -- Waycrest Manor
        Interrupts = {
            267824, -- Scar Soul (all)
            265368, -- Spirited Defense (all)
            426541, -- Runic Bolt (all)
            264390, -- Spellbind (all)
            324589, -- Death Bolt (all)
            263959, -- Soul Volley (all)
            314992, -- Drain Essence (all)
            264050, -- Infected Thorn (all)
            324589, -- Death Bolt (interrupt only)
            260700, -- Ruinous Bolt (interrupt only)
            260701, -- Bramble Bolt (interrupt only)
            265346, -- Pallid Glare (all)
            264520, -- Severing Serpent (all)
            324589, -- Soul Bolt (all)
            265876, -- Ruinous Volley (all)
            268202, -- Death Lens (all)
        },
        TankDefensive = {
            264556, -- Tearing Strike
            265760, -- Thorned Barrage
            429021, -- Crush
            265337, -- Snout Smack
            261438, -- Wasting Strike
        },
        AoEDefensiveEndCast = {

        },
        AoEDefensiveStartCast = {
            
        },
        DebuffDefensive = {
            260741, -- Jagged Nettles
            271178, -- Ravaging Leap
            426590, -- Gluttonous Bile
            263943, -- Etch
        },
        EnemyBuffDefensive = {
            260541, -- Burning Brush
        },
        HealerCooldown = {
            
        },
        Dispel = {
            264050, -- Infected Thorn (Poison)
            265881, -- Decaying Touch (Magic)
        },
        DispelPlus = {
            
        },
        Purge = {
            265368, -- Spirited Defense
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            265372, -- Shadow Cleave
            265352, -- Toad Blight
            260703, -- Unstable Runic Mark
            212786, -- Uproot
            265759, -- Splinter Spike
            260551, -- Soul Thorns
            264923, -- Tenderize
            264694, -- Rotten Expulsion
            268306, -- Discordant Cadenza
        },
        MovementLockDebuff = {
            265880, -- Dread Mark
        },
        MovementLockEnemyBuff = {
            
        },
        PriorityTargetBuff = { -- If enemy unit has this buff, prioritise targeting them
            386336, -- Focusing Iris (Sisters boss in Waycrest Manor)
        },
        StunDebuff = { -- If enemy unit has this Debuff, stun them.
            260900, -- Soul Manipulation (Sisters boss). Charm affect on ally. Stun is to prevent ally from wasting cooldowns while charmed.
        },
    },
    [1763] = { -- Atal'Dazar
        Interrupts = {
            253517, -- Meding Word (all)
            383489, -- Wildfire (all)
            253583, -- Fiery Enchant (all)
            255041, -- Terrifying Screech (all)
            256849, -- Dino Might (all)
            252923, -- Venom Blast (all)
            252781, -- Unstable Hex (all)
            253721, -- Bulwark of Juju (cc only)
            259572, -- Noxious Stench (interrupt only)
            250096, -- Wracking Pain (interrupt only)
        },
        TankDefensive = {
            256138, -- Fervent Strike
            252687, -- Venomfrang Strike
            249919, -- Skewer
        },
        TankDefensiveBuff = {
            255581, -- Gilded Claws
        },
        AoEDefensiveEndCast = {
            259190, -- Soulrend (instant cast, probably need to track boss energy (casts at 100 energy))
        },
        AoEDefensiveStartCast = {
            200238, -- Feed on the Weak
        },
        DebuffDefensive = {
            254959, -- Soulburn
            255434, -- Serrated Teeth
            255814, -- Rending Maul
            250372, -- Lingering Nausea
            250036, -- Shadowy Remains
            201365, -- Darksoul Drain
            200182, -- Festering Rip
        },
        HealerCooldown = {
            
        },
        Dispel = {
            255371, -- Terrifying Visage (magic)
            252781, -- Unstable Hex (curse)
            252687, -- Venomfrang Strike (poison)
        },
        DispelPlus = {
            
        },
        Purge = {
            255581, -- Gilded Claws
            256849, -- Dino Might      
        },        
        Enrage = {
            255824, -- Fanatic's Rage
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            250258, -- Toxic Leap
        },
        MovementLockDebuff = {
            
        },
        MovementLockEnemyBuff = {
            
        },
    },
    [1466] = { -- Darkheart Thicket
        Interrupts = {
            200630, -- Unnerving Screech (all)
            357144, -- Despair (all)
            204243, -- Tormenting Eye (all)
            201298, -- Bloodbolt (all)
            225562, -- Blood Metamorphosis (cc only)
            201399, -- Dread Inferno (all)
            201837, -- Shadow Bolt (all)
            201839, -- Curse of Isolation (all)
        },
        TankDefensive = {
            
        },
        AoEDefensiveEndCast = {
            200580, -- Maddening Roar (stacks, better to use defensive after 2-3 count)
            199389, -- Earthshaking Roar
        },
        AoEDefensiveStartCast = {
            
        },
        DebuffDefensive = {
            200620, -- Frantic Rip
            196376, -- Grievous Tear
            204611, -- Crushing Grip
        },
        HealerCooldown = {
            199389, -- Earthshaking Roar
        },
        Dispel = {
            198904, -- Poison Spear (poison)
            204246, -- Tormenting Fear (magic)
        },
        DispelPlus = {
            
        },
        Purge = {
            
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            200768, -- Propelling Charge
            204667, -- Nightmare Breath
        },
        MovementLockDebuff = {
            
        },
        MovementLockEnemyBuff = {
            
        },
        IncreaseMovementSpeed = {
            134370, -- Down Draft (pushes backwards constantly for 8 seconds)
        },
    },
    [1501] = { -- Black Rook Hold
        Interrupts = {
            199663, -- Soul Blast (all)
            196883, -- Spirit Blast (all)
            200248, -- Arcane Blitz (all)
            200291, -- Knife Dance (cc only, cast turns into channel, only cc during cast)
            201139, -- Brutal Assault (stun only?)
            227913, -- Felfrenzy (all)
        },
        TankDefensive = {
            225732, -- Strike Down
            197418, -- Vengeful Shear
            198245, -- Brutal Haymaker
            214003, -- Coup de Grace
        },
        AoEDefensiveEndCast = {
            196587, -- Soul Burst
            198073, -- Earthshaking Stomp
            182392, -- Shadow Bolt Volley
        },
        AoEDefensiveStartCast = {
            
        },
        DebuffDefensive = {
            197546, -- Brutal Glaive
            198635, -- Unerring Shear
            201733, -- Stinging Swarm
        },
        HealerCooldown = {
            
        },
        Dispel = {
            200084, -- Soul Blade
        },
        DispelPlus = {
            225908, -- Soul Venom, only needs dispelling at high stacks (untested, maybe like 5?)
        },
        Purge = {
            
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            196916, -- Glaive Toss
            195254, -- Swirling Scythe
            200345, -- Arrow Barrage
            200256, -- Phased Explosion
            200261, -- Bonebreaking Strike
            197546, -- Brutal Glaive
            197418, -- Vengeful Shear
            197974, -- Bonecrushing Strike
            200913, -- Indigestion
            214001, -- Raven's Dive
            121896, -- Whirling Blade
            198820, -- Dark Blast
        },
        MovementLockDebuff = {
            194966, -- Soul Echoes
            197484, -- Dark Rush
            197687, -- Eye Beams
            198446, -- Fel Vomit
        },
        MovementLockEnemyBuff = {
            
        },
        IncreaseMovementSpeed = {
            199567, -- Dark Obliteration (four beams that need to be dodged in succession)
        },
    },
    [643] = { -- Throne of the Tides
        Interrupts = {
            76813, -- Healing Wave (all)
            76820, -- Hex (all)
            426768, -- Lightning Bolt
            117163, -- Water Bolt
            426905, -- Psionic Pulse (stun only)
            429176, -- Aquablast
            428526, -- Ink Blast
        },
        TankDefensive = {
            426741, -- Shellbreaker
            427670, -- Crushing Claw
            428889, -- Foul Bolt
        },
        AoEDefensiveEndCast = {
            325418, -- Volatile Acid
            428868, -- Putrid Roar
        },
        AoEDefensiveStartCast = {
            428376, -- Focused Tempest
            427668, -- Festering Shockwave
        },
        DebuffDefensive = {
            426660, -- Razor Jaws
            428399, -- Blotting Barrage
        },
        HealerCooldown = {
            427668, -- Festering Shockwave
            429173, -- Mind Rot (not sure if this tracks correctly)
            428868, -- Putrid Roar
        },
        Dispel = {
            76820, -- Hex (curse)
            75992, -- Lightning Surge (magic)
            75993, -- Lightning Surge (magic)(not sure which spell ID)
            429048, -- Flame Shock (magic)
            76516, -- Poised Spear (poison)
        },
        DispelPlus = {
            
        },
        Purge = {
            428329, -- Icy Veins
        },
        Enrage = {
            428291, -- Slithering Assault
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            426684, -- Volatile Bolt
            120519, -- Waterspout
            428041, -- Shock Blast
            427672, -- Bubbling Fissure
            428926, -- Clenching Tentacles
        },
        MovementLockDebuff = {
            428399, -- Blotting Barrage
            428668, -- Cleansing Flux
        },
        MovementLockEnemyBuff = {
            
        },
    },
    [1279] = { -- The Everbloom
        Interrupts = {
            164973, -- Dancing Thorns (all)
            164965, -- Choking Vines (all)
            165213, -- Enraged Growth (all)
            164887, -- Healing Waters (all)
            427459, -- Toxic Bloom (interrupt)
            212040, -- Revitalize (interrupt)
            420334, -- Nature's Wrath (interrupt)
            117163, -- Water Bolt (interrupt)
            169825, 169841, -- Arcane Blast (all)(not sure which ID is correct)
            169839, -- Pyroblast (all)
            169840, -- Frostbolt (all)
            176000, -- Lasher Venom (all)
        },
        TankDefensive = {
            427245, -- Fungal Fist
        },
        AoEDefensiveEndCast = {
            169445, -- Noxious Eruption
        },
        AoEDefensiveStartCast = {
            427233, -- Cinderbolt Salvo
            427919, -- Cinderbolt Storm
        },
        DebuffDefensive = {
            
        },
        HealerCooldown = {
            
        },
        Dispel = {
            428450, -- Venom Burst
        },
        DispelPlus = {
            
        },
        Purge = {
            
        },
        Enrage = {
            165213, -- Enraged Growth
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            428139, -- Spatial Compression
            175973, -- Colossal Blow
        },
        MovementLockDebuff = {
            
        },
        MovementLockEnemyBuff = {
            
        },
    },
}




--[[
[2579] = { -- Dawn of the Infinite (Dungeon ID is Season 2 full dungeon but table is for Murozond's Rise)
        Interrupts = {
            400165, -- Epoch Bolt (interrupt)
            413607, -- Corroding Volley (stun)
            412924, -- Binding Grasp (interrupt, can only be interrupted when in melee range/inside the shrouding sandstorm (412212))
            417481, -- Displace Chronosequence (interrupt)
            419327, -- Infinite Schism (cc)
            412378, -- Dizzying Sands (interrupt)
            412233, -- Rockey Bolt Volley (all)
            413427, -- Time Beam (all)
            407535, -- Deploy Goblin Sappers (cc)
        },
        TankDefensive = {
            410240, -- Titanic Blow
            410254, -- Decapitate
        },
        AoEDefensiveEndCast = {
            400641, -- Dividing Strike 
            413622, -- Infinite Fury
        },
        AoEDefensiveStartCast = {
            410496, -- War Cry
        },
        DebuffDefensive = {
            
        },
        HealerCooldown = {
            413622, -- Infinite Fury
        },
        Dispel = {
            400649, -- Spark of Tyr
            401667, -- Time Stasis
            407121, -- Immolate
            417030, -- Fireball
            412027, -- Chronal Burn
        },
        DispelPlus = {
            
        },
        Purge = {
            
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            412135, -- Temporal Strike
            407205, -- Volatile Mortar
        },
        MovementLockDebuff = {
            
        },
        MovementLockEnemyBuff = {
            
        },
        IncreaseMovementSpeed = {
            404365, -- Dragon's Breath (Morchie's giant frontal, need big speeeeeeeeeed)
        },
    },]]


    --[[
[????] = { -- Amirdrassil, the Dream's Hope
        Interrupts = {
            
        },
        TankDefensive = {
            416056, -- Umbral Destruction
        },
        AoEDefensiveEndCast = {
            422026, -- Tortured Scream
            422776, -- Marked for Torment
        },
        AoEDefensiveStartCast = {
            
        },
        DebuffDefensive = {
            421038, -- Ember-Charred
            415624, -- Heart Stopper
        },
        HealerCooldown = {
            422026, -- Tortured Scream
        },
        HealerCooldownDebuffAlly = {
            415624, -- Heart Stopper
        },
        Dispel = {
            
        },
        DispelPlus = {
            
        },
        Purge = {
            
        },
        MovementLockCast = { -- Ground AoE checks, don't use forced-movement/locked-movement abilities.
            421898, -- Flaming Pestilence
            422039, -- Shadowflame Cleave
        },
        MovementLockDebuff = {
            421971, -- Controlled Burn
            414425, -- Blistering Spear
            416998, -- Twisting Blade
        },
        MovementLockEnemyBuff = {
            
        },
        IncreaseMovementSpeed = {
            
        },
    },]]

makuluDefaultReaction = {
    Interrupts = {},
    TankDefensive = {},
    AoEDefensiveEndCast = {},
    AoEDefensiveStartCast = {},
    DebuffDefensive = {},
    HealerCooldown = {},
    Dispel = {},
    DispelPlus = {},
    Purge = {},
    Enrage = {},
    MovementLockCast = {},
    MovementLockDebuff = {},
    MovementLockEnemyBuff = {},
}

function GetReactionTable()
    local instanceID = InstanceInfo.ID
    local reaction = makuluReactionTable[instanceID]
    if reaction then
        return reaction, true 
    else
        return makuluDefaultReaction, false 
    end
end