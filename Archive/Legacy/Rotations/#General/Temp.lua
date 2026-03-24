local kickAbilitiesBySpec = {
    -- Death Knight
    [250] = {spellID = 47528, cooldown = 15, range = 8}, -- Blood
    [251] = {spellID = 47528, cooldown = 15, range = 8}, -- Frost
    [252] = {spellID = 47528, cooldown = 15, range = 8}, -- Unholy
    -- Demon Hunter
    [577] = {spellID = 183752, cooldown = 15, range = 8}, -- Havoc
    [581] = {spellID = 183752, cooldown = 15, range = 8}, -- Vengeance
    -- Druid
    [102] = {spellID = 78675, cooldown = 60, range = 40}, -- Balance
    [103] = {spellID = 106839, cooldown = 15, range = 8}, -- Feral
    [104] = {spellID = 106839, cooldown = 15, range = 8}, -- Guardian
    -- Evoker
    [1467] = {spellID = 351338, cooldown = 20, range = 25}, -- Devestation
    [1468] = {spellID = 351338, cooldown = 40, range = 25}, -- Preservation
    [1473] = {spellID = 351338, cooldown = 30, range = 25}, -- Augmentation
    -- Hunter
    [253] = {spellID = 147362, cooldown = 24, range = 40}, -- Beast Mastery
    [254] = {spellID = 147362, cooldown = 24, range = 40}, -- Marksmanship
    [255] = {spellID = 187707, cooldown = 15, range = 8}, -- Survival
    -- Mage
    [62] = {spellID = 2139, cooldown = 20, range = 40}, -- Arcane
    [63] = {spellID = 2139, cooldown = 20, range = 40}, -- Fire
    [64] = {spellID = 2139, cooldown = 20, range = 40}, -- Frost
    -- Monk
    [268] = {spellID = 116705, cooldown = 15, range = 8}, -- Brewmaster
    [270] = {spellID = 116705, cooldown = 15, range = 8}, -- Windwalker
    [269] = {spellID = 116705, cooldown = 15, range = 8}, -- Windwalker
    -- Paladin
    [66] = {spellID = 96231, cooldown = 15, range = 8}, -- Protection
    [70] = {spellID = 96231, cooldown = 15, range = 8}, -- Retribution
    -- Rogue
    [259] = {spellID = 1766, cooldown = 15, range = 8}, -- Assassination
    [260] = {spellID = 1766, cooldown = 15, range = 8}, -- Outlaw
    [261] = {spellID = 1766, cooldown = 15, range = 8}, -- Subtlety
    -- Shaman
    [262] = {spellID = 57994, cooldown = 12, range = 25}, -- Elemental
    [263] = {spellID = 57994, cooldown = 12, range = 25}, -- Enhancement
    [264] = {spellID = 57994, cooldown = 12, range = 25}, -- Restoration
    -- Warlock
    [265] = {spellID = 19647, cooldown = 24, range = 40}, -- Affliction
    [266] = {spellID = 19647, cooldown = 24, range = 40}, -- Demonology
    [267] = {spellID = 19647, cooldown = 24, range = 40}, -- Destruction
    -- Warrior
    [71] = {spellID = 6552, cooldown = 14, range = 8}, -- Arms
    [72] = {spellID = 6552, cooldown = 14, range = 8}, -- Fury
    [73] = {spellID = 6552, cooldown = 14, range = 8}, -- Protection
}

local interruptImmuneBuffs = {
    642,   -- Divine Shield (Paladin)
    377360, -- Precognition
    204336, -- Grounding Totem
    104337, -- Unending Resolve
}

local function getKickInfoBySpellID(spellID)
    for specID, info in pairs(kickAbilitiesBySpec) do
        if info.spellID == spellID then
            return info
        end
    end
    return nil
end

local activeCooldowns = {}
local opponentSpecs = {}
local guidToArenaID = {}

local function updateGUIDToArenaIDMapping()
    wipe(guidToArenaID)
    for i = 1, 3 do
        local unitID = "arena" .. i
        local guid = UnitGUID(unitID)
        if guid then
            guidToArenaID[guid] = unitID
        end
    end
end

local function updateOpponentSpecs()
    wipe(opponentSpecs)
    for i = 1, 3 do
        local specID, gender, classID = GetArenaOpponentSpec(i)
        if specID and specID > 0 then
            local _, specName, _, icon, _, class = GetSpecializationInfoByID(specID)
            opponentSpecs["arena" .. i] = {
                specID = specID,
                specName = specName,
                icon = icon,
                class = class,
                classID = classID,
                gender = gender
            }
        end
    end
end

-- Refactored to use RegisterEventCallback
RegisterEventCallback("PLAYER_ENTERING_WORLD", function()
    updateGUIDToArenaIDMapping()
    updateOpponentSpecs()
end)

RegisterEventCallback("ARENA_PREP_OPPONENT_SPECIALIZATIONS", function()
    updateGUIDToArenaIDMapping()
    updateOpponentSpecs()
end)

RegisterEventCallback("ARENA_OPPONENT_UPDATE", function()
    updateGUIDToArenaIDMapping()
    updateOpponentSpecs()
end)

RegisterEventCallback("COMBAT_LOG_EVENT_UNFILTERED", function(timestamp, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellID)
    if subevent == "SPELL_CAST_SUCCESS" then
        local kickInfo = getKickInfoBySpellID(spellID)
        if kickInfo and guidToArenaID[sourceGUID] then
            local arenaID = guidToArenaID[sourceGUID]
            activeCooldowns[arenaID] = {spellID = spellID, cooldownEnd = GetTime() + kickInfo.cooldown}
            print(arenaID, "kick used. Cooldown ends at:", GetTime() + kickInfo.cooldown)
        end
    end
end)

local function getUnitSpecInfo(unitID)
    return opponentSpecs[unitID]
end

local function getCooldownRemaining(arenaID, spellID)
    local cooldownInfo = activeCooldowns[arenaID]
    if cooldownInfo and cooldownInfo.spellID == spellID then
        local remaining = cooldownInfo.cooldownEnd - GetTime()
        print(arenaID, "cooldown remaining:", remaining)
        if remaining > 0 then
            return remaining
        else
            activeCooldowns[arenaID] = nil
        end
    end
    return nil -- Indicating no cooldown or cooldown expired
end


local function isPlayerImmuneToInterrupts()
    for _, spellID in ipairs(interruptImmuneBuffs) do
        local remain, _ = Unit("player"):HasBuffs(spellID)
        if remain > 0 then
            return true, remain
        end
    end
    return false, 0
end



local function safeToCast()
    local minSafeDuration = nil
    local isAnyKickAvailable = false

    for i = 1, 3 do
        local unitID = "arena" .. i
        if UnitExists(unitID) then
            local _, range = Unit(unitID):GetRange()
            local specInfo = getUnitSpecInfo(unitID)
            print(unitID .. " range: ", range)

            if specInfo then
                local kickInfo = kickAbilitiesBySpec[specInfo.specID]
                if kickInfo then
                    local inRange = not range or (range <= kickInfo.range)
                    print(unitID .. " in kick range: ", inRange)

                    if inRange then
                        local cooldownRemaining = getCooldownRemaining(unitID, kickInfo.spellID)
                        if cooldownRemaining then
                            if not minSafeDuration or cooldownRemaining < minSafeDuration then
                                minSafeDuration = cooldownRemaining
                            end
                        else
                            return false, 0
                        end
                    end
                end
            end
        end
    end

    if isAnyKickAvailable then
        return false, 0
    else
        return true, minSafeDuration or 0
    end
end