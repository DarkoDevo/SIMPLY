if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 73 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local MakSpell         = MakuluFramework.Spell
local MakMulti         = MakuluFramework.MultiUnits
local TableToLocal     = MakuluFramework.tableToLocal
local MakLists         = MakuluFramework.lists
local ConstUnit        = MakuluFramework.ConstUnits
local cacheContext     = MakuluFramework.Cache
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware
local Debounce         = MakuluFramework.debounceSpell
local ConstCell        = cacheContext:getConstCacheCell()
local CommandRegister  = MakuluFramework.Commands.register

local Action           = _G.Action
local ActionUnit       = Action.Unit
local MultiUnits       = Action.MultiUnits
local GetToggle           = Action.GetToggle

local BossMods         = Action.BossMods

local _G, setmetatable = _G, setmetatable

local ActionID = {
    Avatar = { Type = "Spell", ID = 107574, MAKULU_INFO = { targeted = false } },
    BattleShout = { Type = "Spell", ID = 6673, MAKULU_INFO = { targeted = false } },
    BattleStance = { Type = "Spell", ID = 386164, MAKULU_INFO = { targeted = false } },
    BerserkerRage = { Type = "Spell", ID = 18499, MAKULU_INFO = { targeted = false } },
    Charge = { Type = "Spell", ID = 100, MAKULU_INFO = { damageType = "physical" } },
    DefensiveStance = { Type = "Spell", ID = 386208, MAKULU_INFO = { targeted = false } },
    Execute = { Type = "Spell", ID = 163201, MAKULU_INFO = { damageType = "physical" } },
    Hamstring = { Type = "Spell", ID = 1715, MAKULU_INFO = { damageType = "physical" } },
    HeroicLeap = { Type = "Spell", ID = 6544, MAKULU_INFO = { targeted = false } },
    HeroicThrow = { Type = "Spell", ID = 57755, MAKULU_INFO = { damageType = "physical" } },
    ImpendingVictory = { Type = "Spell", ID = 202168, MAKULU_INFO = { targeted = false } },
    Intervene = { Type = "Spell", ID = 3411, MAKULU_INFO = { heal = true }, Macro = "/cast [@target,help][@focus,help][]spell:thisID" },
    IntimidatingShout = { Type = "Spell", ID = 5246, MAKULU_INFO = { cc = true } },
    Pummel = { Type = "Spell", ID = 6552, MAKULU_INFO = { offGcd = true } },
    RallyingCry = { Type = "Spell", ID = 97462, MAKULU_INFO = { targeted = false } },
    ShieldBlock = { Type = "Spell", ID = 2565 },
    ShieldSlam = { Type = "Spell", ID = 23922, MAKULU_INFO = { damageType = "physical" } },
    Shockwave = { Type = "Spell", ID = 46968 },
    Slam = { Type = "Spell", ID = 1464, MAKULU_INFO = { damageType = "physical" } },
    SpellReflection = { Type = "Spell", ID = 23920, MAKULU_INFO = { offGcd = true } },
    StormBolt = { Type = "Spell", ID = 107570, MAKULU_INFO = { damageType = "physical" } },
    Taunt = { Type = "Spell", ID = 355 },
    ThunderClap = { Type = "Spell", ID = 6343, MAKULU_INFO = { damageType = "physical" }, Macro = "/cast spell:thisID" },
    ThunderousRoar = { Type = "Spell", ID = 384318, MAKULU_INFO = { damageType = "physical" } },
    WhirlWind = { Type = "Spell", ID = 1680, MAKULU_INFO = { damageType = "physical" } },
    ChampionsSpear = { Type = "Spell", ID = 376079, Macro = "/cast Single-Button Assistant" },
    
    ChallengingShout = { Type = "Spell", ID = 1161 },
    DemoralizingShout = { Type = "Spell", ID = 1160, MAKULU_INFO = { targeted = false } },
    IgnorePain = { Type = "Spell", ID = 190456, MAKULU_INFO = { targeted = false, offGcd = true } },
    LastStand = { Type = "Spell", ID = 12975 },
    Ravager = { Type = "Spell", ID = 228920, MAKULU_INFO = { damageType = "physical" }, Macro = "/cast Single-Button Assistant" },
    Rend = { Type = "Spell", ID = 394062, MAKULU_INFO = { damageType = "physical" } },
    Revenge = { Type = "Spell", ID = 6572 },
    ShieldCharge = { Type = "Spell", ID = 385952, MAKULU_INFO = { damageType = "physical", cc = true } },
    ShieldWall = { Type = "Spell", ID = 871 },
    -- SpellBlock = { Type = "Spell", ID = 392966, MAKULU_INFO = { offGcd = true } },  -- Removed in Patch 11.2
    Demolish = { Type = "Spell", ID = 436358 }, -- Texture = 5927618 },
    ThunderBlast = { Type = "Spell", ID = 435222, MAKULU_INFO = { damageType = "magic" } },
    
    ImmovableObject = { Type = "Spell", ID = 394307 },
    ChampionsBulwark = { Type = "Spell", ID = 386328 },
    BoomingVoice = { Type = "Spell", ID = 202743 },
    ImpenetrableWall = { Type = "Spell", ID = 384072 },
    HeavyRepercussions = { Type = "Spell", ID = 203177 },
    UnnervingFocus = { Type = "Spell", ID = 384042 },
    Bolster = { Type = "Spell", ID = 280001 },
    SeismicReverberation = { Type = "Spell", ID = 382956 },
    BarbaricTraining = { Type = "Spell", ID = 390675 },
    BitterImmunity = { Type = "Spell", ID =  383762 },
    SuddenDeath = { Type = "Spell", ID = 29725 },
    Massacre = { Type = "Spell", ID = 281001 },
    UnstoppableForce = { Type = "Spell", ID = 275336 },
    CrashingThunder = { Type = "Spell", ID = 436707 },
    ViolentOutburst = { Type = "Spell", ID = 386477 },
    
    -- Season 3 / Patch 11.2 New Talents
    HeavyHanded = { Type = "Spell", ID = 1235088 },
    RedRightHand = { Type = "Spell", ID = 1235038 },
    Spellbreaker = { Type = "Spell", ID = 1235023 },
    HunkerDown = { Type = "Spell", ID = 1235022 },
    ArmorSpecialization = { Type = "Spell", ID = 1234769 },
    
    Disarm = { Type = "Spell", ID = 236077, MAKULU_INFO = { damageType = "physical" } },
    
    -- PvP Talents Oppressor 
    Bodyguard = { Type = "Spell", ID = 213871, MAKULU_INFO = { targeted = true } },
    Warbringer = { Type = "Spell", ID = 356353 },
    ShieldBash = { Type = "Spell", ID = 198912 },
    Rebound = { Type = "Spell", ID = 213915 },
    MoraleKiller = { Type = "Spell", ID = 199023 },
    DragonCharge = { Type = "Spell", ID = 206572, MAKULU_INFO = { damageType = "physical" } },
    Warpath = { Type = "Spell", ID = 199086 },
    Thunderstruck = { Type = "Spell", ID = 199045 },
    Oppressor = { Type = "Spell", ID = 205800 },
    Demolition = { Type = "Spell", ID = 329033 },
    
    AntiFakeKick = { Type = "Spell", ID = 6552,  Hidden = true,        Color = "GREEN"        , Desc = "[2] AntiFakeKick",    QueueForbidden = true    },
    AntiFakeCC     = { Type = "Spell", ID = 107570,      Hidden = true,        Color = "YELLOW"    , Desc = "[1] AntiFakeCC",      QueueForbidden = true    },
    
    -- Racials
    Berserking = { Type = "Spell", ID = 26297, MAKULU_INFO = { ignoreCasting = true } }, -- Troll
    BloodFury = { Type = "Spell", ID = 20572, MAKULU_INFO = { ignoreCasting = true } }, -- Orc
    
    -- Universals
    Universal6 = { Type = "Spell", ID = 133648, Texture = 133648, Macro = "/cast [@mouseover,exists]Heroic Throw" },
    Universal7 = { Type = "Spell", ID = 133646, Texture = 133646, Macro = "/cast [@mouseover,exists]Charge" },
    Universal8 = { Type = "Spell", ID = 133643, Texture = 133643, Macro = "/cast [@mouseover,exists]Taunt" },
    
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })
Action[ACTION_CONST_WARRIOR_PROTECTION] = A
TableToLocal(M, getfenv(1))
Aware:enable()

local player = ConstUnit.player
local target = ConstUnit.target
local focus = ConstUnit.focus
local mouseover = ConstUnit.mouseover
local pet = ConstUnit.pet
local arena1 = ConstUnit.arena1
local arena2 = ConstUnit.arena2
local arena3 = ConstUnit.arena3
local party1 = ConstUnit.party1
local party2 = ConstUnit.party2
local party3 = ConstUnit.party3
local party4 = ConstUnit.party4
local healer = ConstUnit.healer
local enemyHealer = ConstUnit.enemyHealer

local gameState = {}

local buffs = {
    arena_preparation = 32727,
    power_infusion = 10060,
    
    battle_stance = 386164,
    thunder_blast = 435607,
    avatar = 107574,
    last_stand = 12975,
    violent_outburst = 386477,
    colossal_might = 440989,
    shield_block = 132404,
    burst_of_power = 437118,
    defensive_stance = 386208,
    rallying_cry = 97462,
    battle_shout = 6673,
    ignore_pain = 190456,
    sudden_death = 52437,
    revenge = 5302,
    bodyguard = 213871,
    spell_reflection = 23920,
}

local debuffs = {
    exhaustion = 57723,
    rend = 772,
}

local scd = 12
if A.GetToggle(2, "SheildChargeMeleeOnly") then
    scd = 2
end

local interrupts = {
    { spell = Pummel },
    { spell = StormBolt, isCC = true },
    { spell = Shockwave, isCC = true, aoe = true, distance = 3 },
    { spell = IntimidatingShout, aoe = true, distance = 3 },
    { spell = ShieldCharge, isCC = true, distance = scd },
}

local function num(val)
    if val then return 1 else return 0 end
end

local function shouldBurst()
    if Action.BurstIsON("target") then
        return true
    end
    return false
end

local function EnemiesInSpellRange(makulu_spell)
    return ConstCell:GetOrSet("enemiesIn" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and enemy.inCombat and not enemy.isPet and not enemy.isFriendly then
                    total = total + 1
                end
            end
            return total
    end)
end

local function EnemiesInSpellRangeWithoutDebuff(makulu_spell, debuff_id)
    return ConstCell:GetOrSet("enemiesInDebuff" .. makulu_spell.id .. debuff_id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local total = 0
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and enemy.inCombat and not enemy.isPet and not enemy.isFriendly and not enemy:Debuff(debuff_id) then
                    total = total + 1
                end
            end
            return total
    end)
end

local function TotemsInSpellRange(makulu_spell)
    return ConstCell:GetOrSet("totemsIn" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemyGUID in pairs(activeEnemies) do
                local enemy = MakUnit:new(enemyGUID)
                if makulu_spell:InRange(enemy) and enemy.inCombat and enemy:IsTotem() and not enemy.isFriendly then
                    return true
                end
            end
            return false
    end)
end

local function TauntCountSpell(makulu_spell)
    return ConstCell:GetOrSet("tauntCount" .. makulu_spell.id, function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            local needTaunt = 0
            for unitToCheck in pairs(activeEnemies) do
                local munit = MakUnit:new(unitToCheck)
                if munit and munit.exists and munit.inCombat and makulu_spell:InRange(munit) and not A.IsInPvP and not ActionUnit(unitToCheck):IsTotem() and not ActionUnit(unitToCheck):IsDummy() then
                    local threatStatusE = UnitThreatSituation("player", unitToCheck)
                    if threatStatusE == 0 or threatStatusE == 2 then
                        needTaunt = needTaunt + 1
                    end
                end
            end
            return needTaunt
    end)
end

local function AutoTarget()
    if not player.inCombat then return false end
    
    if A.GetToggle(2, "autotarget") then
        for _, spellInfo in ipairs(interrupts) do
            if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
                return false
            end
        end
    end
    
    if A.GetToggle(2, "autotarget") and TotemsInSpellRange(Execute) and not target:IsTotem() then
        return true
    end
    
    if A.GetToggle(2, "autotaunt") and gameState.ShouldTaunt == "Switch" then
        return true
    end
    
    if Execute:InRange(target) and target.exists and (target.hp < 20 or (player:TalentKnown(281001) and target.hp < 35)) then return false end
    
    if A.GetToggle(2, "multidot") and EnemiesInSpellRangeWithoutDebuff(Execute, debuffs.rend) < EnemiesInSpellRange(Execute) and gameState.ShouldTaunt ~= "Taunt" then
        return true
    end
    
    if Execute:InRange(target) and target.exists then return false end
    
    if A.GetToggle(2, "targetmelee") and EnemiesInSpellRange(Execute) > 0 then
        return true
    end
end

local pveSpellReflect = {
    -- SEASON 1 TWW
    -- Raid
    436996, -- Princess
    436787, -- Princess
    437839, -- Princess
    438200, -- Court
    441772, -- Court
    439865, -- Queen
    451600, -- Queen
    -- Dungeon
    432031, -- Ara-Kara - Ki'katal
    436322, -- Ara-Kara
    434786, -- Ara-Kara
    436322, -- Ara-Kara
    -- City
    434722, 440468, 439646, 446718, 439341,
    -- Dawn
    428086, 451117,
    -- Grim
    449444, 447966, 450102, 450087,
    -- NW
    320170, 322493, 320788,
    -- Mist
    323057,
    --Vault
    428161,
    
    --SEASON 2 TWW
    --Liberation of Undermine
    1219386, -- Scrap Rockets
    460847, -- Electric Blast
    --Cinderbrew
    436640, -- Burning Ricochet
    437733, -- Boiling Flames
    --Darkflame
    443694, -- Crude Weapons
    422700, -- Extinguishing Gust
    421638, -- Wicklighter Barrage
    469620, -- Creeping Shadow
    428563, -- Flame Bolt
    423479, -- Wicklighter Bolt
    --Mechagon Workshop
    294860, -- Blossom Blast
    291878, -- Pulse Blast
    294195, -- Arcing Zap
    293827, -- Giga-Wallop
    1215415, -- Sticky Sludge
    -- Motherlode
    260323, -- Alpha Cannon
    263628, -- Charged Shield
    280604, -- Iced Spritzer
    262270, -- Caustic Compound
    1215934, -- Rock Lance
    268846, -- Echo Blade
    -- Operation Floodgate
    473126, -- Mudslide
    469811, -- Backwash
    465871, -- Blood Blast
    465666, -- Sparkslam
    1214468, -- Trickshot
    474388, -- Flamethrower
    465595, -- Lightning Bolt
    462776, -- Surveying Beam
    -- Priory pf the Sacred Flame
    424420, -- Cinderblast
    424421, -- Fireball
    423015, -- Castigator's Shield
    423536, -- Holy Smite
    427357, -- Holy Smite
    427469, -- Fireball
    427900, -- Molten Pool
    427951, -- Seal of Flame
    -- Theater of pain
    1217138, -- Necrotic Bolt
    1216475, -- Necrotic Bolt
    319669, -- Spectral Reach
    1222949, -- Well of Darkness
    323608, -- Dark Devastation
    324589, -- Death Bolt
    341969, -- Withering Discharge
    330697, -- Decaying Strike
    330784, -- Necrotic Bolt
    333299, -- Curse of Desolation
    330875, -- Spirit Frost
    330810, -- Bind Soul
    -- The Rookery
    430805, -- Arcing Void
    430186, -- Seeping Corruption
    430238, -- Void Bolt
    430109, -- Lightning Bolt
    467907, -- Festering Void
    
    --SEASON 3 TWW
    -- Manaforge Omega Raid
    -- TODO: Add Manaforge Omega spell IDs for spell reflect when available
    
    -- Eco-Dome Al'dani
    -- TODO: Add Eco-Dome Al'dani spell IDs for spell reflect when available
    
    -- Halls of Atonement (Returning)
    -- TODO: Add Halls of Atonement spell IDs for spell reflect when available
    
    -- Tazavesh: Streets of Wonder (Returning)
    -- TODO: Add Tazavesh Streets of Wonder spell IDs for spell reflect when available
    
    -- Tazavesh: So'leah's Gambit (Returning)
    -- TODO: Add Tazavesh So'leah's Gambit spell IDs for spell reflect when available
}

local pveShieldBlock = {
    -- SEASON 1 TWW
    -- City
    434722, 440468, 439646,
    -- Ara-Kara
    438471,
    -- Dawn
    451117,
    -- Grim
    447261, 450102, 449444,
    -- NW
    320655, 338456, 61269,
    -- Siege
    256867, 268230, 273470,
    -- Vault
    424888, 422233,
    
    --SEASON 2 TWW
    -- Liberation of Undermine
    459627, -- Tank Buster
    464112, -- Demolish
    466748, -- Infected Bite
    474406, -- Gear Grinder
    465171, -- Goblin Gravi-Gun
    473009, -- Explosive Shrapnel
    460472, -- The Big Hit
    466974, -- Goblin Gun
    466976, -- Gold Knuckles
    -- Cinderbrew
    432229, -- Keg Smash
    439031, -- Bottoms Uppercut
    438651, -- Snack Time
    436592, -- Cash Cannon
    435000, -- High Steaks
    463206, -- Tenderize
    434758, -- Throw Chair
    442995, -- Swarming Surprise
    434773, -- Mean Mug
    439468, -- Downward Trend
    -- Darkflame
    422245, -- Rock Buster
    425561, -- Nasty Nibble
    -- Mechagon Workshop
    285377, -- B.4.T.T.L.3. Mine
    282945, -- Buzz Saw
    -- Motherlode
    270926, -- Drill Smash
    267357, -- Fan of Knives
    262019, -- Grease Gun
    263586, -- Throw Shield
    -- Operation Floodgate
    460965, -- Barreling Charge
    459799, -- Wallop
    469479, -- Sludge Claws
    465128, -- Wind Up
    474350, -- Shreddation Sawblade
    468932, -- Wrench Wallop
    -- Priory of the Sacred Flame
    427621, -- Impale
    424621, -- Brutal Smash
    424426, -- Lunging Strike
    -- Theater of Pain
    320069, -- Mortal Strike
    323515, -- Hateful Strike
    318102, -- Finishing Blow
    324079, -- Reaping Scythe
    331319, -- Savage Flurry
    333845, -- Unbalancing Blow
    331224, -- Bonestorm
    -- The Rookery
    
    --SEASON 3 TWW
    -- Manaforge Omega Raid
    -- TODO: Add Manaforge Omega spell IDs for shield block when available
    
    -- Eco-Dome Al'dani
    -- TODO: Add Eco-Dome Al'dani spell IDs for shield block when available
    
    -- Halls of Atonement (Returning)
    -- TODO: Add Halls of Atonement spell IDs for shield block when available
    
    -- Tazavesh: Streets of Wonder (Returning)
    -- TODO: Add Tazavesh Streets of Wonder spell IDs for shield block when available
    
    -- Tazavesh: So'leah's Gambit (Returning)
    -- TODO: Add Tazavesh So'leah's Gambit spell IDs for shield block when available
}

local function wantSpellReflect()
    return ConstCell:GetOrSet("wantSpellReflect", function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for unitToCheck in pairs(activeEnemies) do
                local munit = MakUnit:new(unitToCheck)
                if munit and munit.exists and munit:IsCasting() then
                    local currentCast = munit:CastInfo()
                    if currentCast and currentCast.spellId and currentCast.percent > 10 and currentCast.percent < 100 and tContains(pveSpellReflect, currentCast.spellId) then
                        Aware:displayMessage("Need Spell Reflect", "Green", 1)
                        return true
                    end
                end
            end
            return false
    end)
end

local function wantShieldBlock()
    return ConstCell:GetOrSet("wantShieldBlock", function()
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for unitToCheck in pairs(activeEnemies) do
                local munit = MakUnit:new(unitToCheck)
                if munit and munit.exists and munit:IsCasting() then
                    local currentCast = munit:CastInfo()
                    if currentCast and currentCast.spellId and currentCast.percent > 10 and currentCast.percent < 100 and tContains(pveShieldBlock, currentCast.spellId) then
                        Aware:displayMessage("Need Shield Block", "Green", 1)
                        return true
                    end
                end
            end
            return false
    end)
end

---------- BODYGUARD DISTANCE TRACKER -----------

local BodyguardTracker = {
    frame = nil,
    barFrame = nil,
    textFrame = nil,
    distanceText = nil,
    nameText = nil,
    protectedUnit = nil,
    lastUpdate = 0,
    updateInterval = 0.05, -- Update 20 times per second
}

-- Color gradient function based on distance
local function GetDistanceColor(distance)
    -- Safety check for nil or invalid distance
    if not distance or distance <= 0 then
        return 0.5, 0.5, 0.5, 1 -- Gray for invalid distance
    end
    
    if distance <= 10 then
        -- Green zone (0-10 yards)
        return 0, 1, 0, 1
    elseif distance <= 15 then
        -- Transition from Green to Yellow (10-15 yards)
        local t = (distance - 10) / 5
        return t, 1, 0, 1
    elseif distance <= 18 then
        -- Transition from Yellow to Orange (15-18 yards)
        local t = (distance - 15) / 3
        return 1, 1 - (t * 0.5), 0, 1
    else
        -- Red zone (18-20 yards)
        return 1, 0, 0, 1
    end
end

-- Create the visual indicator frame
function BodyguardTracker:CreateFrame()
    if self.frame then return end
    
    -- Main container frame
    self.frame = CreateFrame("Frame", "BodyguardDistanceTracker", UIParent)
    self.frame:SetSize(250, 60)
    self.frame:SetPoint("TOP", UIParent, "TOP", 0, -200)
    self.frame:SetFrameStrata("TOOLTIP")  -- Changed from HIGH to TOOLTIP for better visibility
    self.frame:SetFrameLevel(100)  -- Ensure it's on top
    self.frame:Hide()
    
    -- Background
    local bg = self.frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.7)
    
    -- Border
    local border = self.frame:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetColorTexture(1, 1, 1, 0.3)
    border:SetDrawLayer("BORDER", 1)
    
    -- Inner background (slightly smaller for border effect)
    local innerBg = self.frame:CreateTexture(nil, "BACKGROUND")
    innerBg:SetPoint("TOPLEFT", 2, -2)
    innerBg:SetPoint("BOTTOMRIGHT", -2, 2)
    innerBg:SetColorTexture(0, 0, 0, 0.8)
    innerBg:SetDrawLayer("BACKGROUND", 1)
    
    -- Distance bar background
    local barBg = CreateFrame("Frame", nil, self.frame)
    barBg:SetSize(230, 15)
    barBg:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 8)
    local barBgTex = barBg:CreateTexture(nil, "BACKGROUND")
    barBgTex:SetAllPoints()
    barBgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)
    
    -- Distance bar (colored based on distance)
    self.barFrame = CreateFrame("Frame", nil, self.frame)
    self.barFrame:SetSize(230, 15)
    self.barFrame:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 8)
    self.barTexture = self.barFrame:CreateTexture(nil, "ARTWORK")
    self.barTexture:SetPoint("LEFT")
    self.barTexture:SetSize(230, 15)
    self.barTexture:SetColorTexture(0, 1, 0, 0.8)
    
    -- Protected unit name text
    self.nameText = self.frame:CreateFontString(nil, "OVERLAY")
    self.nameText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    self.nameText:SetPoint("TOP", self.frame, "TOP", 0, -8)
    self.nameText:SetTextColor(1, 1, 1, 1)
    self.nameText:SetText("Bodyguard Active")
    
    -- Distance text
    self.distanceText = self.frame:CreateFontString(nil, "OVERLAY")
    self.distanceText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    self.distanceText:SetPoint("TOP", self.nameText, "BOTTOM", 0, -4)
    self.distanceText:SetTextColor(1, 1, 1, 1)
    self.distanceText:SetText("0 yards")
end

-- Find which friendly unit has the Bodyguard buff
function BodyguardTracker:FindProtectedUnit()
    -- Check arena teammates (arena1, arena2, arena3)
    for i = 1, 3 do
        local unit = "arena" .. i
        if UnitExists(unit) and UnitIsFriend("player", unit) and not UnitIsDeadOrGhost(unit) then
            local arenaUnit = MakUnit:new(unit)
            if arenaUnit and arenaUnit.exists and arenaUnit:Buff(buffs.bodyguard) then
                return arenaUnit, unit
            end
        end
    end
    
    -- Check party members (party1-4)
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
            local partyUnit = MakUnit:new(unit)
            if partyUnit and partyUnit.exists and partyUnit:Buff(buffs.bodyguard) then
                return partyUnit, unit
            end
        end
    end
    
    -- Check raid members (raid1-40)
    if IsInRaid() then
        for i = 1, 40 do
            local unit = "raid" .. i
            if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and not UnitIsUnit(unit, "player") then
                local raidUnit = MakUnit:new(unit)
                if raidUnit and raidUnit.exists and raidUnit:Buff(buffs.bodyguard) then
                    return raidUnit, unit
                end
            end
        end
    end
    
    -- Check player (in case it's used on self somehow)
    if player and player.exists and player:Buff(buffs.bodyguard) then
        return player, "player"
    end
    
    return nil, nil
end

-- Update the distance indicator
function BodyguardTracker:Update()
    local currentTime = GetTime()
    if currentTime - self.lastUpdate < self.updateInterval then
        return
    end
    self.lastUpdate = currentTime
    
    -- Find protected unit
    local protectedUnit, unitId = self:FindProtectedUnit()
    
    if not protectedUnit or not protectedUnit.exists then
        -- No protected unit, hide frame
        if self.frame then
            self.frame:Hide()
        end
        self.protectedUnit = nil
        return
    end
    
    -- Debug: Found protected unit
    if not self.frame then
        Aware:displayMessage("Bodyguard Tracker: Found protected unit!", "Green", 2)
    end
    
    -- Create frame if it doesn't exist
    if not self.frame then
        self:CreateFrame()
    end
    
    -- Get distance
    local distance = protectedUnit:Distance()
    
    -- Check if distance is valid
    if not distance or distance == 0 then
        -- Distance unavailable, hide frame
        self.frame:Hide()
        self.protectedUnit = nil
        return
    end
    
    -- Check if unit is out of range or dead
    if distance > 20 or protectedUnit.isDead then
        self.frame:Hide()
        self.protectedUnit = nil
        return
    end
    
    -- Update protected unit reference
    self.protectedUnit = protectedUnit
    
    -- Show frame
    self.frame:Show()
    
    -- Update name text
    local unitName = UnitName(unitId) or "Unknown"
    self.nameText:SetText("Bodyguard: " .. unitName)
    
    -- Update distance text
    self.distanceText:SetText(string.format("%.1f yards", distance))
    
    -- Get color based on distance
    local r, g, b, a = GetDistanceColor(distance)
    
    -- Update bar color
    self.barTexture:SetColorTexture(r, g, b, a)
    
    -- Update bar width based on distance (inverse - shorter bar = further away)
    local barWidth = 230 * (1 - (distance / 20))
    self.barTexture:SetWidth(math.max(1, barWidth))
    
    -- Update distance text color to match bar
    self.distanceText:SetTextColor(r, g, b, 1)
    
    -- Show warning messages at critical distances
    if distance >= 18 then
        Aware:displayMessage("Bodyguard - Critical Range!", "Red", 0.5)
    elseif distance >= 15 then
        Aware:displayMessage("Bodyguard - Warning Range", "Orange", 0.5)
    end
end

-- Initialize the tracker
function BodyguardTracker:Initialize()
    self:CreateFrame()
end

---------- MACRO STUFF -----------

MakuluFramework.tauntMode = false
local function TauntModeHandler()
    if MakuluFramework.tauntMode then
        return
    end
    
    MakuluFramework.tauntMode = true
    
    C_Timer.After(2, function()
            MakuluFramework.tauntMode = false
    end)
end
CommandRegister("taunt", TauntModeHandler, "Auto Agro Mouseover (Universal 6 and 8)", {})

-- Season 3 Encounter-Specific Helper Functions
-- TODO: Add specific functions for Season 3 encounters when spell IDs are available
-- Example: local function isManaforgeBoss() return ... end
-- Example: local function isEcoDomeEncounter() return ... end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId
    
    return currentCast
end

local function updateGameState()
    gameState = {
        TWW1has2P = player:Has2Set(),
        TWW1has4P = player:Has4Set(),
        ShouldTaunt = MakuluFramework.TauntStatus(Taunt),
        tank_buster_in = MakuluFramework.DBM_TankBusterIn() or 1000000,
        stance = 0,
        ignore_pain_perc = GetToggle(2, "IgnorePainPerc"),
        ignore_pain_perc_rd = GetToggle(2, "IgnorePainPercRageDump"),
    }
    
    if not A.GetToggle(2, "usedbm") then
        gameState.tank_buster_in = 1000000
    end
    
    if player.hp < 50 then
        gameState.stance = 1
    elseif gameState.tank_buster_in < 4000 or player.hp < 50 then
        gameState.stance = 1
    end
end

-- actions.precombat+=/battle_stance,toggle=on
BattleStance:Callback("ooc", function(spell)
        if not A.GetToggle(2, "autostance") then return end
        if not player:Buff(buffs.battle_stance) and gameState.stance == 0 then
            return spell:Cast()
        end
end)

DefensiveStance:Callback("ooc", function(spell)
        if not A.GetToggle(2, "autostance") then return end
        if not player:Buff(buffs.defensive_stance) and gameState.stance == 1 then
            return spell:Cast()
        end
end)

-- actions+=/charge,if=time=0
Charge:Callback("opener", function(spell)
        if A.IsInPvP then return end
        local distance = target:Distance()
        if not distance then return end
        if player.inCombat or distance < 8 or distance > 30 then return end
        
        return spell:Cast(target)
end)

-- actions+=/avatar,if=buff.thunder_blast.down|buff.thunder_blast.stack<=2
Avatar:Callback(function(spell)
        if not shouldBurst() then return end
        if not ShieldSlam:InRange(target) then return end
        if target.totalImmune or target.physImmune then return end
        if not player:Buff(buffs.thunder_blast) or player:HasBuffCount(buffs.thunder_blast) <= 2 and Pummel:InRange(target) then
            return spell:Cast()
        end
end)

-- actions+=/shield_wall,if=talent.immovable_object.enabled&buff.avatar.down
ShieldWall:Callback("apl", function(spell)
        if not shouldBurst() then return end
        if A.GetToggle(2, "defMode") then return end
        if player:TalentKnown(ImmovableObject.id) and not player:Buff(buffs.avatar) and ShieldSlam:InRange(target) then
            return spell:Cast()
        end
end)

-- actions+=/ignore_pain,if=target.health.pct>=20&(rage.deficit<=15&cooldown.shield_slam.ready|rage.deficit<=40&cooldown.shield_charge.ready|rage.deficit<=20&cooldown.shield_charge.ready|rage.deficit<=30&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled|rage.deficit<=20&cooldown.avatar.ready|rage.deficit<=45&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled&buff.last_stand.up&talent.unnerving_focus.enabled|rage.deficit<=30&cooldown.avatar.ready&buff.last_stand.up&talent.unnerving_focus.enabled|rage.deficit<=20|rage.deficit<=40&cooldown.shield_slam.ready&buff.violent_outburst.up&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled|rage.deficit<=55&cooldown.shield_slam.ready&buff.violent_outburst.up&buff.last_stand.up&talent.unnerving_focus.enabled&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled|rage.deficit<=17&cooldown.shield_slam.ready&talent.heavy_repercussions.enabled|rage.deficit<=18&cooldown.shield_slam.ready&talent.impenetrable_wall.enabled)|(rage>=70|buff.seeing_red.stack=7&rage>=35)&cooldown.shield_slam.remains<=1&buff.shield_block.remains>=4&set_bonus.tier31_2pc,use_off_gcd=1
-- NEW talent champions_bulwark it was removed in 11.2
IgnorePain:Callback(function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 25 then return end
        if (target.hp >= 20) and (player.rageDeficit <= 15 and ShieldSlam.cd < 300 or player.rageDeficit <= 40 and ShieldCharge.cd < 300 or player.rageDeficit <= 20 and ShieldCharge.cd < 300 or player.rageDeficit <= 30 and DemoralizingShout.cd < 300 and player:TalentKnown(BoomingVoice.id) or player.rageDeficit <= 20 and Avatar.cd < 300 or player.rageDeficit <= 45 and DemoralizingShout.cd < 300 and player:TalentKnown(BoomingVoice.id) and player:Buff(buffs.last_stand) and player:TalentKnown(UnnervingFocus.id) or player.rageDeficit <= 30 and Avatar.cd < 300 and player:Buff(buffs.last_stand) and player:TalentKnown(UnnervingFocus.id) or player.rageDeficit <= 20 or player.rageDeficit <= 40 and ShieldSlam.cd < 300 and player:Buff(ViolentOutburst) and player:TalentKnown(HeavyRepercussions.id) and player:TalentKnown(ImpenetrableWall.id) or player.rageDeficit <= 55 and ShieldSlam.cd < 300 and player:Buff(buffs.violent_outburst) and player:Buff(buffs.last_stand) and player:TalentKnown(UnnervingFocus.id) and player:TalentKnown(HeavyRepercussions.id) and player:TalentKnown(ImpenetrableWall.id) or player.rageDeficit <= 17 and ShieldSlam.cd < 300 and player:TalentKnown(HeavyRepercussions.id) or player.rageDeficit <= 18 and ShieldSlam.cd < 300 and player:TalentKnown(ImpenetrableWall.id)) then
            return spell:Cast()
        end
        
        if player:Buff(buffs.ignore_pain) and ((player:HasBuffCount(buffs.ignore_pain) < 80 and player.rage >= 35) or (player:HasBuffCount(buffs.ignore_pain) < 96 and player.rage >= 70)) then
            return spell:Cast()
        end
end)

IgnorePain:Callback("defMode", function(spell)
        
        if player.rageDeficit <= 15 then
            return spell:Cast()
        end
        
        if player:Buff(buffs.ignore_pain) then return end
        
        return spell:Cast()
end)

-- actions+=/last_stand,if=(target.health.pct>=90&talent.unnerving_focus.enabled|target.health.pct<=20&talent.unnerving_focus.enabled)|talent.bolster.enabled|set_bonus.tier30_2pc|set_bonus.tier30_4pc
--LastStand:Callback("apl", function(spell)
--    if (target.hp >= 90 and player:TalentKnown(UnnervingFocus.id) or target.hp <= 20 and player:TalentKnown(UnnervingFocus.id)) or player:TalentKnown(Bolster.id) or gameState.TWW1has2P or gameState.TWW1has4P then
--        return spell:Cast()
--    end
--end)

-- actions+=/ravager
Ravager:Callback(function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance < 8 and shouldBurst() and target.ttd > 3000 then
            return spell:Cast(target)
        end
end)

-- actions+=/demoralizing_shout,if=talent.booming_voice.enabled
DemoralizingShout:Callback(function(spell)
        if player:TalentKnown(BoomingVoice.id) and Execute:InRange(target) then
            return spell:Cast()
        end
end)

-- actions+=/champions_spear
ChampionsSpear:Callback(function(spell)
        local distance = target:Distance()
        if not distance then return end
        if shouldBurst() and distance <= 8 and target.ttd > 4000 then
            return spell:Cast(target)
        end
end)

-- actions+=/thunder_blast,if=spell_targets.thunder_blast>=2&buff.thunder_blast.stack=2
ThunderousRoar:Callback("cond1", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        if EnemiesInSpellRange(Execute) >= 2 and player:HasBuffCount(buffs.thunder_blast) == 2 then
            return spell:Cast(target)
        end
end)

-- actions+=/demolish,if=buff.colossal_might.stack>=3
Demolish:Callback(function(spell)
        if not shouldBurst() then return end
        if player:HasBuffCount(buffs.colossal_might) >= 3 and target.ttd > 5000 and not player.moving then
            return spell:Cast(target)
        end
end)

-- actions+=/thunderous_roar
ThunderousRoar:Callback("cond2", function(spell)
        if not shouldBurst() then return end
        if target.totalImmune or target.physImmune then return end
        return spell:Cast(target)
end)

-- Racials (burst-gated)
Berserking:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end
        return spell:Cast()
end)

BloodFury:Callback(function(spell)
        if not shouldBurst() then return end
        if not A.GetToggle(1, "Racial") then return end
        return spell:Cast()
end)


-- actions+=/shield_charge
ShieldCharge:Callback(function(spell)
        return spell:Cast(target)
end)

-- actions+=/shield_block,if=buff.shield_block.remains<=10
ShieldBlock:Callback("apl", function(spell)
        if player:BuffRemains(buffs.shield_block) <= 1000 then
            return spell:Cast()
        end
end)

-----------------------------------------------------------------------------
-- actions.aoe=thunder_blast,if=dot.rend.remains<=1
ThunderBlast:Callback("aoe", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 1 then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/thunder_clap,if=dot.rend.remains<=1
ThunderClap:Callback("aoe", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if not target:Debuff(debuffs.rend) and distance < 4 then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/thunder_blast,if=buff.violent_outburst.up&spell_targets.thunderclap>=2&buff.avatar.up&talent.unstoppable_force.enabled
ThunderBlast:Callback("aoe2", function(spell)
        if player:Buff(buffs.violent_outburst) and EnemiesInSpellRange(Execute) >= 2 and player:Buff(buffs.avatar) and player:TalentKnown(UnstoppableForce.id) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/thunder_clap,if=buff.violent_outburst.up&spell_targets.thunderclap>=4&buff.avatar.up&talent.unstoppable_force.enabled&talent.crashing_thunder.enabled|buff.violent_outburst.up&spell_targets.thunderclap>6&buff.avatar.up&talent.unstoppable_force.enabled
ThunderClap:Callback("aoe2", function(spell)
        if player:Buff(buffs.violent_outburst) and EnemiesInSpellRange(Execute) >= 4 and player:Buff(buffs.avatar) and player:TalentKnown(UnstoppableForce.id) and player:TalentKnown(CrashingThunder.id) or player:Buff(buffs.violent_outburst) and EnemiesInSpellRange(Execute) > 6 and player:Buff(buffs.avatar) and player:TalentKnown(UnstoppableForce.id) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/revenge,if=rage>=70&talent.seismic_reverberation.enabled&spell_targets.revenge>=3
Revenge:Callback("aoe", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 8 then return end
        if player.rage >= 70 and player:TalentKnown(SeismicReverberation.id) and EnemiesInSpellRange(Revenge) >= 3 then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/shield_slam,if=rage<=60|buff.violent_outburst.up&spell_targets.thunderclap<=4&talent.crashing_thunder.enabled
ShieldSlam:Callback("aoe", function(spell)
        if player.rage <= 60 or player:Buff(buffs.violent_outburst) and player:TalentKnown(CrashingThunder.id) and Rend:InRange(target) then -- Removed EnemiesInSpellRange(ThunderClap) <= 4 and
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/thunder_blast
ThunderBlast:Callback("aoe3", function(spell)
        return spell:Cast(target)
end)

-- actions.aoe+=/execute,if=spell_targets.execute>=2&(rage>=50|buff.sudden_death.up)&talent.heavy_handed.enabled
-- NEWEnhanced for Season 3: Heavy Handed talent makes Execute hit 2 additional targets, Red Right Hand increases Execute damage
Execute:Callback("aoe", function(spell)
        if EnemiesInSpellRange(Execute) >= 2 and (player.rage >= 50 or player:Buff(buffs.sudden_death)) and player:TalentKnown(HeavyHanded.id) then
            return spell:Cast(target)
        end
end)

-- actions.aoe+=/thunder_clap
ThunderClap:Callback("aoe3", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 3 then return end
        return spell:Cast(target)
end)

-- actions.aoe+=/revenge,if=rage>=30|rage>=40&talent.barbaric_training.enabled
Revenge:Callback("aoe2", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 8 then return end
        if player.rage >= 30 or player.rage >= 40 and player:TalentKnown(BarbaricTraining.id) then
            return spell:Cast(target)
        end
end)

-- actions+=/run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
local aoerot = function()
    if EnemiesInSpellRange(Execute) < 3 then return end
    
    ThunderBlast("aoe")
    ThunderClap("aoe")
    ThunderBlast("aoe2")
    Execute("aoe") -- NEW
    ThunderClap("aoe2")
    Revenge("aoe")
    ShieldSlam("aoe")
    ThunderBlast("aoe3")
    ThunderClap("aoe3")
    Revenge("aoe2")
    
end

-- actions.generic=thunder_blast,if=(buff.thunder_blast.stack=2&buff.burst_of_power.stack<=1&buff.avatar.up&talent.unstoppable_force.enabled)
ThunderBlast:Callback("generic", function(spell)
        if player:HasBuffCount(buffs.thunder_blast) == 2 and player:HasBuffCount(buffs.burst_of_power) <= 1 and player:Buff(buffs.avatar) and player:TalentKnown(UnstoppableForce.id) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/shield_slam,if=(buff.burst_of_power.stack=2&buff.thunder_blast.stack<=1|buff.violent_outburst.up)|rage<=70&talent.demolish.enabled
ShieldSlam:Callback("generic", function(spell)
        if (player:HasBuffCount(buffs.burst_of_power) == 2 and player:HasBuffCount(buffs.thunder_blast) <= 1 or player:Buff(buffs.violent_outburst)) or player.rage <= 70 and player:TalentKnown(Demolish.id) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/execute,if=rage>=70|(rage>=40&cooldown.shield_slam.remains&talent.demolish.enabled|rage>=50&cooldown.shield_slam.remains)|buff.sudden_death.up&talent.sudden_death.enabled
Execute:Callback("generic", function(spell)
        if player.rage >= 70 or (player.rage >= 40 and ShieldSlam.cd > 0 and player:TalentKnown(Demolish.id) or player.rage >= 50 and ShieldSlam.cd > 0) or player:Buff(buffs.sudden_death) and player:TalentKnown(SuddenDeath.id) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/shield_slam
ShieldSlam:Callback("generic2", function(spell)
        return spell:Cast(target)
end)

-- actions.generic+=/thunder_blast,if=dot.rend.remains<=2&buff.violent_outburst.down
ThunderBlast:Callback("generic2", function(spell)
        if target:DebuffRemains(debuffs.rend) <= 2 and not player:Buff(buffs.violent_outburst) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/thunder_blast
ThunderBlast:Callback("generic3", function(spell)
        return spell:Cast(target)
end)

-- actions.generic+=/thunder_clap,if=dot.rend.remains<=2&buff.violent_outburst.down
ThunderClap:Callback("generic", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 4 then return end
        if target:HasDeBuffCount(debuffs.rend) <= 2 and not player:Buff(buffs.violent_outburst) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/thunder_blast,if=(spell_targets.thunder_clap>1|cooldown.shield_slam.remains&!buff.violent_outburst.up)
ThunderBlast:Callback("generic4", function(spell)
        if (EnemiesInSpellRange(Execute) > 1 or ShieldSlam.cd > 0 and not player:Buff(buffs.violent_outburst)) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/thunder_clap,if=(spell_targets.thunder_clap>1|cooldown.shield_slam.remains&!buff.violent_outburst.up)
ThunderClap:Callback("generic2", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 4 then return end
        if (EnemiesInSpellRange(Execute) > 1 or ShieldSlam.cd > 0 and not player:Buff(buffs.violent_outburst)) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/revenge,if=(rage>=80&target.health.pct>20|buff.revenge.up&target.health.pct<=20&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>20)|(rage>=80&target.health.pct>35|buff.revenge.up&target.health.pct<=35&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>35)&talent.massacre.enabled
Revenge:Callback("generic", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 8 then return end
        if (player.rage >= 80 and target.hp > 20 or player:Buff(buffs.revenge) and target.hp <= 20 and player.rage <= 18 and ShieldSlam.cd > 0 or player:Buff(buffs.revenge) and target.hp > 20) or (player.rage >= 80 and target.hp > 35 or player:Buff(buffs.revenge) and target.hp <= 35 and player.rage <= 18 and ShieldSlam.cd > 0 or player:Buff(buffs.revenge) and target.hp > 35) and player:TalentKnown(Massacre.id) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/execute
-- Enhanced for Season 3: Heavy Handed and Red Right Hand talents improve Execute
Execute:Callback("generic2", function(spell)
        return spell:Cast(target)
end)

-- actions.generic+=/revenge
Revenge:Callback("generic2", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 8 then return end
        return spell:Cast(target)
end)

-- actions.generic+=/thunder_blast,if=(spell_targets.thunder_clap>=1|cooldown.shield_slam.remains&buff.violent_outburst.up)
ThunderBlast:Callback("generic5", function(spell)
        if (EnemiesInSpellRange(Execute) >= 1 or ShieldSlam.cd > 0 and player:Buff(buffs.violent_outburst)) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/thunder_clap,if=(spell_targets.thunder_clap>=1|cooldown.shield_slam.remains&buff.violent_outburst.up)
ThunderClap:Callback("generic3", function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 4 then return end
        if (EnemiesInSpellRange(Execute) >= 1 or ShieldSlam.cd > 0 and player:Buff(buffs.violent_outburst)) then
            return spell:Cast(target)
        end
end)

-- actions.generic+=/devastate
Slam:Callback("generic", function(spell)
        return spell:Cast(target)
end)

-- actions+=/call_action_list,name=generic
local genericrot = function()
    ThunderBlast("generic")
    Execute("generic")
    Execute("generic2")
    ShieldSlam("generic")
    ThunderBlast("generic2")
    ThunderBlast("generic3")
    ShieldSlam("generic2")
    ThunderClap("generic")
    ThunderBlast("generic4")
    ThunderClap("generic2")
    Revenge("generic")
    Revenge("generic2")
    ThunderBlast("generic5")
    ThunderClap("generic3")
    Slam("generic")
end

Taunt:Callback(function(spell)
        local noAggro = UnitThreatSituation("player", target:CallerId())
        if noAggro == 0 or noAggro == 2 then
            return spell:Cast(target)
        end
end)

HeroicThrow:Callback("MouseOver", function(spell)
        if not A.GetToggle(2, "mouseoverHeroicThrow") or not MakuluFramework.tauntMode then return end
        local noAggro = UnitThreatSituation("player", mouseover:CallerId())
        if mouseover.exists and not mouseover.isFriendly and HeroicThrow:InRange(mouseover) and (noAggro == 0 or noAggro == 2 or noAggro == nil) then
            return spell:Cast(mouseover)
        end
end)

Taunt:Callback("MouseOver", function(spell)
        if not A.GetToggle(2, "mouseoverTaunt") or not MakuluFramework.tauntMode then return end
        local noAggro = UnitThreatSituation("player", mouseover:CallerId())
        if mouseover.exists and not mouseover.isFriendly and Taunt:InRange(mouseover) and (noAggro == 0 or noAggro == 2 or noAggro == nil) then
            return spell:Cast(mouseover)
        end
end)

ChallengingShout:Callback(function(spell)
        if (gameState.ShouldTaunt == "Taunt" or gameState.ShouldTaunt == "Switch") and TauntCountSpell(Hamstring) > 2 then
            return spell:Cast()
        end
end)

HeroicThrow:Callback(function(spell)
        local distance = target:Distance()
        if not distance then return end
        if distance > 30 or distance < 8 then return end
        if Taunt.cd < 300 or gameState.ShouldTaunt ~= "Taunt" then return end
        
        return spell:Cast(target)
end)

SpellReflection:Callback(function(spell)
        if wantSpellReflect() then
            return spell:Cast()
        end
end)

--  ?? not sure this logic is right ??   --
-- SpellReflection:Callback("pve", function(spell)
--     if (arena1.exists and arena1:CastingFromFor(MakLists.arenaSpellReflect, 500)) or (arena2.exists and arena2:CastingFromFor(MakLists.arenaSpellReflect, 500)) or arena3.exists and arena3:CastingFromFor(MakLists.arenaSpellReflect, 500) then
--         return spell:Cast(target)
--     end
-- end)

-- NOTE: Spell Block was removed in Patch 11.2 - keeping callback commented for reference
-- The new Spellbreaker talent provides passive 4% chance to reduce magic damage by 50%
-- SpellBlock:Callback(function(spell)
--     if wantSpellBlock() then
--         return spell:Cast()
--     end
-- end)

ShieldBlock:Callback("def", function(spell)
        if player.rage >= 30 and not player:Buff(buffs.rallying_cry) and not player:Buff(buffs.last_stand) and player.hp < 70 then
            return spell:Cast()
        end
        
        if wantShieldBlock() then
            return spell:Cast()
        end
end)

LastStand:Callback("def", function(spell)
        if player.hp < 40 or gameState.tank_buster_in < 1500 then
            return spell:Cast()
        end
end)

BitterImmunity:Callback("def", function(spell)
        if player.hp < 40 then
            return spell:Cast()
        end
end)

RallyingCry:Callback("def", function(spell)
        local inDangerish = MakMulti.party:Count(function(unit) return unit.hp > 0 and unit.hp < 50 and Intervene:InRange(unit) end)
        local fullSquad = MakMulti.party:Count(function(unit) return unit.hp > 0 and Intervene:InRange(unit) end)
        if (fullSquad > 5 and inDangerish > fullSquad / 4) or (fullSquad < 6 and inDangerish >= 3) or (fullSquad < 3 and inDangerish > 0) then
            return spell:Cast()
        end
end)

ShieldWall:Callback("def", function(spell)
        if player.hp < 60 and not player:Buff(buffs.rallying_cry) and not player:Buff(buffs.last_stand) and not player:Buff(buffs.shield_block) then
            return spell:Cast()
        end
end)

BerserkerRage:Callback(function(spell)
        if not player:HasDeBuff(MakLists.feared) then return end
        
        return Debounce("berRage", 350, 2500, spell)
end)

BattleShout:Callback(function(spell)
        if player.inCombat then return end
        if player:HasBuff(buffs.battle_shout) then return end
        
        return spell:Cast()
end)

ImpendingVictory:Callback(function(spell)
        if not player.inCombat then return end
        
        if player.hp < 100 and target.ttd < 2500 and player.rage >= 10 then
            return spell:Cast(target)
        end
        
        if player.hp > 80 or target.ttd < 2500 then return end
        if player.rage < 10 then return end
        
        return spell:Cast(target)
end)

SpellReflection:Callback("pvp-arena", function(spell)
        if not Action.Zone == "arena" then return end
        if (arena1.exists and arena1:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena1.distance > 5 or Pummel.cd > 1000)) or (arena2.exists and arena2:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena2.distance > 5 or Pummel:Cooldown() > 1000)) or (arena3.exists and arena3:CastingFromFor(MakLists.arenaSpellReflect, 500) and (arena1.distance > 5 or Pummel:Cooldown() > 1000)) then
            return spell:Cast() -- No target required for Spell Reflection
        end
end)

ShieldCharge:Callback("arena", function(spell)
        if not Action.Zone == "arena" then return end
        local distance = target:Distance()
        if not distance then return end
        if distance > 8 then return end
        if player.rage < 20 then return end
        
        return spell:Cast(target)
end)

A[1] = function(icon)
    --AntiFakeCC - Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
    if A.AntiFakeCC:GetCooldown() == 0 then return A.AntiFakeCC:Show(icon) end
end

A[2] = function(icon)
    local castLeft, _, _, _, notKickAble = ActionUnit("target"):IsCastingRemains()
    if castLeft == 0 then return end
    
    --AntiFakeKick --Use GetCooldown to ensure the AntiFake CC spell remains usable via 'click' even if it's been blocked
    if A.AntiFakeKick:GetCooldown() == 0 and not notKickAble then return A.AntiFakeKick:Show(icon) end
end

MakuluFramework.firstLoop = true
A[3] = function(icon)
    if MakuluFramework.firstLoop then
        MakuluFramework.firstLoop = false
        Action.SetToggle({1, "AutoAttack", "Auto Attack: "}, false)
        Action.SetToggle({1, "AutoShoot", "Auto Shoot: "}, false)
    end
    
    FrameworkStart(icon)
    updateGameState()
    
    -- Update Bodyguard distance tracker (always check, not just in PvP mode)
    BodyguardTracker:Update()
    
    makInterrupt(interrupts)
    
    if player.inCombat and MakuluFramework.TankDefensive() then
        if Trinket(13, "Defensive") then
            Trinket1()
        end
        if Trinket(14, "Defensive") then
            Trinket2()
        end
    end
    
    --[[if player.inCombat and player.hp < 50 then
        if MakuluFramework.CanUseHealthStone() then
            HealthStone()
        end

        if MakuluFramework.CanUseHealthPotion() then
            HealthPotion()
        end
    end]]
    
    if gameState.tank_buster_in <= 5000 then
        Aware:displayMessage("Tank Buster Soon", "Green", 1)
    end
    
    if player.inCombat then
        ShieldBlock("def")
        if A.GetToggle(2, "defMode") then ShieldBlock("apl") end
        if A.GetToggle(2, "defMode") then IgnorePain("defMode") end
        LastStand("def")
        ShieldWall("def")
        BerserkerRage()
        SpellReflection("pvp-arena")
        BitterImmunity("def")
        RallyingCry("def")
    end
    
    if MakuluFramework.tauntMode then
        print("TAUNT MODE")
        HeroicThrow("MouseOver")
        Taunt("MouseOver")
    end
    
    BattleStance("ooc")
    DefensiveStance("ooc")
    IgnorePain()
    
    BattleShout()
    
    if target.exists and target.canAttack then
        HeroicThrow("MouseOver")
        Taunt("MouseOver")
        
        Taunt()
        HeroicThrow()
        ChallengingShout()
        
        SpellReflection()
        -- SpellBlock() -- Removed in Patch 11.2
        -- Racials during burst
        if shouldBurst() then
            Berserking()
            BloodFury()
        end
        
        
        local distance = target:Distance()
        if distance and shouldBurst() and distance < 4 then
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
        end
        
        ImpendingVictory()
        
        -- PvP Talents (only when PvP mode is ON)
        if A.IsInPvP then
            ChampionsSpear()
            Ravager()
            Taunt("pvp_oppressor", target)
            DragonCharge("pvp")
            HeroicLeap("pvp_warpath")
        end
        
        -- pew pew
        Charge("opener")
        Avatar()
        ShieldWall("apl")
        IgnorePain()
        --LastStand("apl")
        if ShieldSlam:InRange(target) then
            Ravager()
            DemoralizingShout()
            ChampionsSpear()
            ThunderousRoar("cond1")
            Demolish()
            ThunderousRoar("cond2")
            --ShieldCharge()
            ShieldBlock("apl")
            ShieldCharge("arena")
            
            aoerot()
            genericrot()
        end
    end
    
    return FrameworkEnd()
end

Pummel:Callback("arena", function(spell, enemy)
        if enemy:IsKickImmune() then return end
        if not enemy.pvpKick then return end
        
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_healer", function(spell, enemy)
        if enemy.ccImmune then return end
        if not enemy.isHealer then return end
        if enemy:IsTarget() then return end
        if target.hp > 50 then return end
        if enemy.stunDr < 0.5 then return end
        if enemy:CCRemains() > 2000 then return end
        Aware:displayMessage("SB - Enemy Healer - KT Low", "Blue", 1)
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_kill", function(spell, enemy)
        if enemy.ccImmune then return end
        if not enemy:IsTarget() then return end
        if enemy.stunDr < 0.5 then return end
        if enemyHealer.exists and enemy:IsUnit(enemyHealer) then return end
        if enemyHealer:CCRemains() < 2000 then return end
        if enemy.hp > 50 then return end
        Aware:displayMessage("SB - KT - Healer CCed", "Red", 1)
        return spell:Cast(enemy)
end)

StormBolt:Callback("arena_nohealer_kill", function(spell, enemy)
        if enemy.ccImmune then return end
        if enemyHealer.exists then return end
        if not enemy:IsTarget() then return end
        if enemy.stunDr < 0.5 then return end
        if enemy.hp > 50 then return end
        Aware:displayMessage("SB - KT - No Enemy Healer Exists", "Red", 1)
        return spell:Cast(enemy)
end)

Charge:Callback("charge_fear", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy:IsTarget() then return end
        if enemy.distance < 5 then return end
        if target.hp > 60 then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if IntimidatingShout:Cooldown() > 700 then return end
        if enemy.totalImmune then return end
        if enemy.ccImmune then return end
        if enemy.disorientDr < 0.5 then return end
        if enemyHealer:CCRemains() > 1500 then return end
        if aware then Aware:displayMessage("Charge - Enemy Healer - To Fear", "Blue", 1) end
        return spell:Cast(enemy)
end)

IntimidatingShout:Callback("arena", function(spell, enemy)
        local aware = A.GetToggle(2, "makArenaAware")
        if enemy.ccImmune then return end
        --if not spell:InRange(enemy) then return end
        if not enemy:IsUnit(enemyHealer) then return end
        if enemy:IsTarget() then return end
        if target.hp > 60 then return end
        if target.totalImmune then return end
        if enemy.disorientDr < 0.5 then return end
        if enemyHealer:CCRemains() > 1500 then return end
        if aware then Aware:displayMessage("Fear - Enemy Healer - KT Low", "Blue", 1) end
        return spell:Cast(enemy)
end)

Disarm:Callback("arena", function(spell, enemy)
        if enemy.totalImmune then return end
        if not enemy:HasBuffFromFor(MakLists.Disarm, 500) then return end
        Aware:displayMessage("Disarm - Enemy - Bursting", "White", 1)
        return spell:Cast(enemy)
end)

Intervene:Callback("party", function(spell, friendly)
        if friendly:IsUnit(player) then return end
        if friendly.hp > 40 then return end
        if player.hp < 40 then return end
        if friendly.hp > target.hp then return end
        if target.hp < 30 then return end
        
        return spell:Cast(friendly)
end)

-- ========================================
-- PvP TALENT CALLBACKS
-- ========================================

-- Bodyguard (PvP Talent) - Protect an ally, transferring 40% of physical damage to you
-- Priority: Healers > Low HP DPS > Focused targets
Bodyguard:Callback("pvp", function(spell, friendly)
        if not A.IsInPvP then return end
        if not player:TalentKnown(Bodyguard.id) then return end
        if friendly:IsUnit(player) then return end
        if not friendly.exists or not friendly.inCombat then return end
        
        local distance = friendly:Distance()
        if not distance then return end
        if distance > 20 then return end
        
        -- Don't recast if already active on this target
        if friendly:Buff(buffs.bodyguard) then return end
        
        -- Priority 1: Protect healer when they're in danger
        if friendly.isHealer and friendly.hp < 60 then
            Aware:displayMessage("Bodyguard - Healer Low HP", "Blue", 1)
            return spell:Cast(friendly)
        end
        
        -- Priority 2: Protect low HP party members
        if friendly.hp < 40 and player.hp > 50 then
            Aware:displayMessage("Bodyguard - Ally Critical", "Yellow", 1)
            return spell:Cast(friendly)
        end
        
        -- Priority 3: Protect focused targets (multiple enemies attacking)
        local threatCount = 0
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            local enemyTarget = enemy.exists and enemy.target
            if enemyTarget and enemyTarget.exists and enemyTarget.id == friendly.id then
                threatCount = threatCount + 1
            end
        end
        
        if threatCount >= 2 and friendly.hp < 70 then
            Aware:displayMessage("Bodyguard - Ally Focused", "Red", 1)
            return spell:Cast(friendly)
        end
end)

-- Warbringer (PvP Talent) - Charge roots enemies
-- Already handled by base Charge, but we can add PvP-specific logic
Charge:Callback("pvp_warbringer", function(spell, enemy)
        if not A.IsInPvP then return end
        if not player:TalentKnown(Warbringer.id) then return end
        
        local distance = enemy:Distance()
        if not distance then return end
        if not enemy.exists or distance < 8 or distance > 25 then return end
        
        -- Use on kiting enemies
        if enemy.moving and distance > 15 then
            return spell:Cast(enemy)
        end
        
        -- Use to peel for allies
        if enemyHealer.exists and enemy:IsUnit(enemyHealer) and distance > 12 then
            Aware:displayMessage("Charge - Enemy Healer", "Blue", 1)
            return spell:Cast(enemy)
        end
end)

-- Dragon Charge (PvP Talent) - High-speed charge with knockback
DragonCharge:Callback("pvp", function(spell)
        if not A.IsInPvP then return end
        if not player:TalentKnown(DragonCharge.id) then return end
        
        local distance = target:Distance()
        if not distance then return end
        if distance < 8 then return end
        
        -- Use for mobility and AoE knockback
        if EnemiesInSpellRange(Execute) >= 2 then
            Aware:displayMessage("Dragon Charge - AoE", "Green", 1)
            return spell:Cast(target)
        end
end)

-- Warpath (PvP Talent) - Heroic Leap stuns all targets
HeroicLeap:Callback("pvp_warpath", function(spell)
        if not  A.IsInPvP then return end
        if not player:TalentKnown(Warpath.id) then return end
        
        local distance = target:Distance()
        if not distance then return end
        
        -- Use for AoE stun setup
        if EnemiesInSpellRange(Execute) >= 2 and distance > 8 then
            Aware:displayMessage("Heroic Leap - AoE Stun", "Yellow", 1)
            return spell:Cast(target)
        end
end)

-- Oppressor (PvP Talent) - Taunt increases damage taken
Taunt:Callback("pvp_oppressor", function(spell, enemy)
        if not A.IsInPvP then return end
        if not player:TalentKnown(Oppressor.id) then return end
        if not enemy.exists then return end
        
        -- Use on kill targets to increase damage
        if enemy:IsTarget() and enemy.hp < 60 then
            Aware:displayMessage("Oppressor - Kill Target", "Red", 1)
            return spell:Cast(enemy)
        end
end)

-- Morale Killer (PvP Talent) - Enhanced Demoralizing Shout
-- Already handled by base DemoralizingShout callback, talent just enhances it

-- Rebound (PvP Talent) - Spell Reflection reflects 2 spells
-- Already handled by base SpellReflection callback, talent just enhances it

-- Disarm (PvP Talent) - Enhanced disarm logic for PvP
Disarm:Callback("pvp_melee", function(spell, enemy)
        if not A.IsInPvP then return end
        if not player:TalentKnown(Disarm.id) then return end
        
        local distance = enemy:Distance()
        if not distance then return end
        if not enemy.exists or distance > 10 then return end
        
        -- Use on melee DPS bursting
        if enemy:HasBuffFromFor(MakLists.Disarm, 500) then
            Aware:displayMessage("Disarm - Enemy Bursting", "White", 1)
            return spell:Cast(enemy)
        end
end)


local enemyRotation = function(enemy)
    if not enemy.exists then return end
    
    Pummel("arena", enemy)
    StormBolt("arena_healer", enemy)
    StormBolt("arena_kill", enemy)
    
    -- PvP Talents (only when PvP mode is ON) changes
    if A.IsInPvP then
        Taunt("pvp_oppressor", enemy)
        Disarm("pvp_melee", enemy)
    end
    
    Charge("charge_fear", enemy)
    IntimidatingShout("arena", enemy)
    Disarm("arena", enemy)
end


local partyRotation = function(friendly)
    if not friendly.exists then return end
    
    -- PvP Talents (only when PvP mode is ON)
    if A.IsInPvP then
        Bodyguard("pvp", friendly)
    end
    
    Intervene("party", friendly)
end

A[6] = function(icon)
    RegisterIcon(icon)
    if targetForInterrupt(interrupts) then return TabTarget() end
    if AutoTarget() then return TabTarget() end
    enemyRotation(arena1)
    partyRotation(party1)
    
    return FrameworkEnd()
end

A[7] = function(icon)
    RegisterIcon(icon)
    enemyRotation(arena2)
    partyRotation(party2)
    
    return FrameworkEnd()
end

A[8] = function(icon)
    RegisterIcon(icon)
    enemyRotation(arena3)
    partyRotation(party3)
    
    return FrameworkEnd()
end

A[9] = function(icon)
    RegisterIcon(icon)
    partyRotation(party4)
    
    return FrameworkEnd()
end

A[10] = function(icon)
    RegisterIcon(icon)
    partyRotation(player)
    
    return FrameworkEnd()
end

