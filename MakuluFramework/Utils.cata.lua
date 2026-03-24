local _, MakuluFramework = ...

local spec = nil
local GetPrimaryTalentTree = GetPrimaryTalentTree
local GetTalentTabInfo = GetTalentTabInfo

MakuluFramework.getSpec = function()
    if spec then return spec end

    spec = GetPrimaryTalentTree()
    return spec
end

MakuluFramework.getSpecId = function()
    local _, res = GetTalentTabInfo(MakuluFramework.getSpec())

    return res
end
