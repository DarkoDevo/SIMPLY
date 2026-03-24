# Converting Priest_Holy.lua to Meta-Priest-Holy.lua Structure

## Overview
This guide shows how to convert from the old TMW Healing Engine callback system to the new direct unit selection approach used in Meta-Priest-Holy.lua.

## Key Differences

### OLD WAY (Priest_Holy.lua)
- Uses `TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", ...)`
- Enables/disables units via `thisUnit.Enabled = true/false`
- Healing Engine automatically selects which unit to heal
- Less control over unit selection logic

### NEW WAY (Meta-Priest-Holy.lua)
- No TMW callbacks
- Direct unit selection using `MakMulti.party:Lowest()`
- Full control over unit selection logic
- Cleaner, more maintainable code

---

## Step-by-Step Conversion

### STEP 1: Remove TMW Callback (Lines 315-370 in Priest_Holy.lua)

**DELETE THIS ENTIRE SECTION:**
```lua
TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(_, thisUnit, db, QueueOrder)
    local unitID = thisUnit.Unit
    local Role = thisUnit.Role

    if Action.Zone == "arena" then
        local unitA = MakUnit:new(unitID)
        if unitA:Buff(buffs.spiritOfRedemption) or unitA:Buff(buffs.spiritOfTheRedeemer) then
            thisUnit.Enabled = false
        else 
            thisUnit.Enabled = true
        end
    end

    if Action.Zone == "arena" or thisUnit.realHP < 35 then return end

    if thisUnit.Enabled then 
        local unit = Unit(unitID)
        local isPlayerMounted = Player:IsMounted()
        local isUnitOutOfRange = unit:GetRange() > 40
        local spiritOfRedemptionBuffID = 27827
        local spiritOfRedeemerBuffID = 215769
        local unitHasSpiritBuff = unit:IsBuffUp(spiritOfRedemptionBuffID) or unit:IsBuffUp(spiritOfRedeemerBuffID)
        
        if isPlayerMounted or unitHasSpiritBuff then
            thisUnit.Enabled = false
        end
    end
    
    -- ... rest of callback code
end)
```

### STEP 2: Add Module-Level Unit Variable

**ADD THIS near the top of the file (after ConstUnit declarations):**
```lua
local unit  -- This will hold the currently selected healing target
```

### STEP 3: Create getPartyList() Function

**ADD THIS FUNCTION (based on Meta-Priest-Holy.lua lines 511-531):**
```lua
local function getPartyList()
    return constCell:GetOrSet("partyList", function()
        local healable = MakMulti.party:Filter(function(friendly)
            -- Filter out invalid units
            return friendly.exists 
                and not friendly.dead 
                and friendly.distance < 50 
                and not friendly.healImmune
                -- Filter out Spirit of Redemption/Redeemer
                and not friendly:Buff(buffs.spiritOfRedemption)
                and not friendly:Buff(buffs.spiritOfTheRedeemer)
        end)

        -- Deprioritize self-healing when not under pressure
        local myOffset = 0
        if player.ehp > 30 then
            local total, _, _, _, cds = player:AttackersV69()
            if total < 2 and cds < 1 then
                myOffset = 40  -- Add 40 to player's EHP to deprioritize
            end
        end

        -- Sort by effective HP (lowest first)
        healable:Sort(function(a, b)
            return ((a.isMe and a.ehp + myOffset) or a.ehp) < ((b.isMe and b.ehp + myOffset) or b.ehp)
        end)

        return healable
    end)
end
```

### STEP 4: Add Unit Selection Logic to Main Loop

**IN YOUR MAIN ROTATION FUNCTION, ADD THIS AT THE BEGINNING:**
```lua
local function HealerRotation()
    -- Don't heal while mounted
    if player:IsMounted() then
        return
    end

    -- Get filtered party list
    local healable = getPartyList()
    
    -- Select the lowest HP unit
    unit = healable:Lowest(function(friendly)
        return (friendly.isMe and friendly.ehp + 10) or friendly.ehp
    end) or player
    
    -- Override with target if target is friendly and lower HP
    if target.exists and target.isFriendly then
        -- Skip if target has spirit buffs
        if not (target:Buff(buffs.spiritOfRedemption) or target:Buff(buffs.spiritOfTheRedeemer)) then
            if target.ehp < unit.ehp and target.distance <= 40 then
                unit = target
            end
        end
    end
    
    -- Now 'unit' contains the selected healing target
    -- All your spell callbacks can use this 'unit' variable
    
    -- Your existing healing rotation code here...
end
```

### STEP 5: Update Spell Callbacks

Your spell callbacks can now use the `unit` variable directly:

**EXAMPLE:**
```lua
FlashHeal:Callback('emergency', function(spell)
    if unit.hp > 40 then return end
    if not spell:InRange(unit) then return end
    
    return spell:Cast(unit)
end)
```

---

## Important Notes

1. **constCell** - Make sure you have this defined:
   ```lua
   local constCell = cacheContext:getConstCacheCell()
   ```

2. **buffs table** - Ensure your buffs table includes:
   ```lua
   local buffs = {
       spiritOfRedemption = 27827,   -- or 215982 in retail
       spiritOfTheRedeemer = 215769,
       -- ... other buffs
   }
   ```

3. **Distance checks** - Use `friendly.distance` instead of `unit:GetRange()`

4. **Buff checks** - Use `friendly:Buff(id)` instead of `unit:IsBuffUp(id)`

5. **HP checks** - Use `friendly.ehp` for effective HP percentage

---

## Benefits of New Approach

✅ No dependency on TMW Healing Engine callbacks  
✅ Full control over unit selection logic  
✅ Easier to debug and understand  
✅ Can easily add custom prioritization logic  
✅ Works seamlessly with MakuluFramework  
✅ Better performance (no callback overhead)  

---

## Next Steps

After conversion, test thoroughly:
1. Arena healing priority
2. Mounted state handling
3. Spirit of Redemption/Redeemer filtering
4. Range checking
5. Target override logic

