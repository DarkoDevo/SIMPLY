-- Converted from TMW Healing Engine callback to Meta-Priest-Holy.lua style
-- This shows how to handle unit selection without TMW callbacks

-- The old way (TMW callback - DO NOT USE):
--[[
TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)
    if A.Zone == "arena" or thisUnit.realHP < 35 then return end
    
    local unitID = thisUnit.Unit
    
    -- Check if 'HE' should not be used based on certain conditions
    if thisUnit.Enabled then
        local unit = Action.Unit(unitID)
        
        -- Condition: Player is mounted
        local isPlayerMounted = Player:IsMounted()
        
        -- Condition: Unit is out of range (> 40 yards)
        local isUnitOutOfRange = unit:GetRange() > 40
        
        -- Buff IDs for Spirit of Redemption and Spirit of Redeemer
        local spiritOfRedemptionBuffID = 27827  -- Spirit of Redemption
        local spiritOfRedeemerBuffID = 215769   -- Spirit of Redeemer
        
        -- Condition: Unit has Spirit of Redemption or Spirit of Redeemer buff
        local unitHasSpiritBuff = unit:IsBuffUp(spiritOfRedemptionBuffID) or unit:IsBuffUp(spiritOfRedeemerBuffID)
        
        -- If any condition is true, disable 'thisUnit'
        if isPlayerMounted or unitHasSpiritBuff then
            thisUnit.Enabled = false
        end
    end
end)
]]

-- The NEW way (Meta-Priest-Holy.lua style):

-- 1. Define your buffs table at the top of your file
local buffs = {
    spiritOfRedemption = 27827,   -- Spirit of Redemption (215982 in retail)
    spiritOfTheRedeemer = 215769, -- Spirit of Redeemer
}

-- 2. In your main loop, select the unit based on conditions
local function selectHealingTarget()
    -- Get the party list (this filters out invalid units automatically)
    local healable = getPartyList()
    
    -- Find the lowest HP unit that needs healing
    -- The function adds +10 to player's EHP to slightly deprioritize self-healing
    local selectedUnit = healable:Lowest(function(friendly)
        -- Skip units with Spirit of Redemption/Redeemer
        if friendly:Buff(buffs.spiritOfRedemption) or friendly:Buff(buffs.spiritOfTheRedeemer) then
            return 999 -- Return high value to deprioritize
        end
        
        -- Skip units out of range (> 40 yards)
        if friendly.distance > 40 then
            return 999
        end
        
        -- Return effective HP (lower = higher priority)
        return (friendly.isMe and friendly.ehp + 10) or friendly.ehp
    end) or player
    
    -- Override with target if target is friendly and lower HP
    if target.exists and target.isFriendly then
        -- Skip if target has spirit buffs
        if not (target:Buff(buffs.spiritOfRedemption) or target:Buff(buffs.spiritOfTheRedeemer)) then
            if target.ehp < selectedUnit.ehp and target.distance <= 40 then
                selectedUnit = target
            end
        end
    end
    
    return selectedUnit
end

-- 3. In your main rotation function, use the selected unit
local function HealerRotation()
    -- Don't heal while mounted
    if player.moving and player:IsMounted() then
        return
    end
    
    -- Select the healing target
    unit = selectHealingTarget()
    
    -- Now use 'unit' in your spell callbacks
    -- Example:
    -- FlashHeal('callback_name')
    -- Heal('callback_name')
    -- etc.
end

-- 4. Example of how spell callbacks work with the selected unit
--[[
FlashHeal:Callback('emergency', function(spell)
    if unit.hp > 40 then return end
    
    return spell:Cast(unit)
end)

Heal:Callback('normal', function(spell)
    if unit.hp > 70 then return end
    
    return spell:Cast(unit)
end)
]]

-- SUMMARY OF CHANGES:
-- OLD: TMW callback system that enables/disables units in the healing engine
-- NEW: Direct unit selection in main loop using MakMulti.party:Lowest()
--
-- Benefits of new approach:
-- 1. More control over unit selection logic
-- 2. No dependency on TMW healing engine callbacks
-- 3. Easier to debug and understand
-- 4. Can easily prioritize/deprioritize units based on any condition
-- 5. Works seamlessly with MakuluFramework's MultiUnits system

-- IMPORTANT NOTES:
-- - The 'unit' variable is a module-level variable (declared at top: local unit)
-- - It gets set in the main loop before calling rotation functions
-- - All spell callbacks can then use this 'unit' variable
-- - getPartyList() already filters out dead/invalid units
-- - Use friendly.distance instead of unit:GetRange()
-- - Use friendly:Buff(id) instead of unit:IsBuffUp(id)
-- - Use friendly.ehp for effective HP percentage
-- - Use friendly.hp for actual HP percentage

