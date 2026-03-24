if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end


if GetSpecializationInfo(GetSpecialization()) ~= 270 then return end

local frame = CreateFrame("Frame", "MakuluMessageFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 100)
frame:SetPoint("CENTER")

frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("TOP", frame, "TOP", 0, -5)
frame.title:SetText("Makulu Alert")

frame:Show()