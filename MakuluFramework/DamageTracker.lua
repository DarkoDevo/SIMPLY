local _, MakuluFramework = ...
MakuluFramework          = MakuluFramework or _G.MakuluFramework

-- DamageTracker disabled for now - returns safe defaults
-- TTD tracking can be re-enabled later if needed

local function GetTimeToDie(unit)
    return math.huge
end

local function GetDmgPerSec(unit)
    return 0
end

MakuluFramework.GetTimeToDie = GetTimeToDie
MakuluFramework.GetDmgPerSec = GetDmgPerSec
