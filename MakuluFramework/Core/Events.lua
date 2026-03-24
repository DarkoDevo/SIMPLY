local _, MakuluFramework = ...
MakuluFramework = MakuluFramework or _G.MakuluFramework

-- Events disabled for now due to TMW taint issues
-- RegisterEvent calls are blocked by ForceTaint_Strong
-- These are no-op stubs that prevent errors

local function register_event(event_name, callback)
    -- No-op: event registration disabled
end

local function register_reset(callback)
    -- No-op: reset registration disabled
end

MakuluFramework.Events = {
    register = register_event,
    registerReset = register_reset
}
