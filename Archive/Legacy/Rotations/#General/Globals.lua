LPH_JIT_MAX = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_ENCNUM = function(val) return val end

--Remove it when you dont like to save it global - its just a idea
--[[
--####################################################################################################################################################################################

------------------------------------
--- Function to Purge passiv in arena
------------------------------------
local purgeableBuffs = {
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

function canPassivPurge(unitID)
    if Action.Zone ~= "arena" then 
        return false 
    end

    for buffID, _ in pairs(purgeableBuffs) do
        if Unit(unitID):HasBuffs(buffID) > 1 then
            return true
        end
    end
    return false
end

--####################################################################################################################################################################################

------------------------------------
--- Function to Dispel passiv in arena
------------------------------------
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

function canPassivDispel(unitID)
    if Action.Zone ~= "arena" or Action.HealingEngine.GetBelowHealthPercentUnits(35, 40) > 0 then 
        return false 
    end

    for debuffID, _ in pairs(arenaDispelDebuffs) do
        if Unit(unitID):HasDeBuffs(debuffID) > 0 then
            return true
        end
    end

    return false
end

--####################################################################################################################################################################################

------------------------------------
--- Helper Function for Kick passiv in arena
------------------------------------
local arenaKicks = {
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
    [204437] = true,   -- Lightning Lasso
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
    [982] = true,      -- Revive pet
    [198013] = true,   -- Eye Beam
    [113724] = true,   -- Ring of Frost
    [199786] = true,   -- Glacial Spike
    [365350] = true,   -- Arcane Surge
    [234153] = true,   -- Drain Life
    [116858] = true    -- Chaos Bolt
}

function GetCastPercentage(unitID)
    local name, _, _, startTime, endTime = UnitCastingInfo(unitID)
    if not name then
        name, _, _, startTime, endTime = UnitChannelInfo(unitID)
    end
    if name then
        local currentTime = GetTime() * 1000
        local elapsedTime = currentTime - startTime
        local totalDuration = endTime - startTime
        return (elapsedTime / totalDuration) * 100
    else
        return 0
    end
end

function canPassivInterrupt(unitID)
    if Action.Zone ~= "arena" or Unit(unitID):HasBuffs("KickImun") > 0 or Unit(unitID):HasBuffs("Reflect") > 0 or Unit(unitID):HasBuffs(377360) > 0 then return false end
    
    for spellID, _ in pairs(arenaKicks) do
        if Unit(unitID):IsCastingRemains(spellID) > 0 and GetCastPercentage(unitID) > 35 then
            return true 
        end
    end

    return false 
end

--####################################################################################################################################################################################
]]
