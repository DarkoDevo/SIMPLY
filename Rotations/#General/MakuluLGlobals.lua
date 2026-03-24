
local MakuluFramework = _G.MakuluFramework

local Action = _G.Action
local MultiUnits, Unit, GetToggle, Re = Action.MultiUnits, Action.Unit, Action.GetToggle, Action.Re
local Player = Action.Player
local UnitExists = UnitExists

local function EnemiesInSpellRange(spell)
    local total = 0
    for namePlateUnitID in pairs(MultiUnits.GetActiveUnitPlates()) do
        if UnitExists(namePlateUnitID) and (Unit(namePlateUnitID):IsEnemy() or Unit(namePlateUnitID):IsDummy() or Unit(namePlateUnitID):IsDummyPvP()) and spell:IsInRange(namePlateUnitID) then
            total = total + 1
        end
    end
    return total
end

local function EnemiesTTDSpellRange(spell)
    local total = 0
    local ttds = 0
    for namePlateUnitID in pairs(MultiUnits.GetActiveUnitPlates()) do
        if UnitExists(namePlateUnitID) and Unit(namePlateUnitID):IsEnemy() and spell:IsInRange(namePlateUnitID) and not Unit(namePlateUnitID):IsTotem() then
            total = total + 1
            ttds = ttds + Unit(namePlateUnitID):TimeToDie()
        end
    end
    if total > 0 then
        return ttds / total
    else
        return total
    end
end

MakuluFramework.OLD = {
    EnemiesInSpellRange = EnemiesInSpellRange,
    EnemiesTTDSpellRange = EnemiesTTDSpellRange,
}