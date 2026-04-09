local addonName, addonTable = ...
local existingFramework = rawget(_G, "MakuluFramework")
local sharedFramework = addonTable

if type(sharedFramework) == "table" and type(existingFramework) == "table" and existingFramework ~= sharedFramework then
    for key, value in pairs(existingFramework) do
        if sharedFramework[key] == nil then
            sharedFramework[key] = value
        end
    end
elseif type(sharedFramework) ~= "table" then
    sharedFramework = existingFramework
end

if type(sharedFramework) ~= "table" then
    sharedFramework = {
        NAME = "Makulu",
    }
end

if type(sharedFramework.NAME) ~= "string" or sharedFramework.NAME == "" then
    sharedFramework.NAME = "Makulu"
end

if type(addonName) == "string" and addonName ~= "" then
    sharedFramework.ADDON_NAME = addonName
end

_G.MakuluFramework = sharedFramework
_G.MakuluFramwork = sharedFramework
MakuluFramework = sharedFramework


-- Compatibility shim to ensure _G.debugprofilestop exists (Classic/MoP)
do
    local _dps = _G.debugprofilestop
    if type(_dps) ~= "function" then
        local gtp = _G.GetTimePreciseSec
        if type(gtp) == "function" then
            _dps = function() return gtp() * 1000 end
        else
            _dps = function() return _G.GetTime() * 1000 end
        end
        _G.debugprofilestop = _dps
    end
end
