if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 268 then return end

local FrameworkStart   = MakuluFramework.start
local FrameworkEnd     = MakuluFramework.endFunc
local RegisterIcon     = MakuluFramework.registerIcon

local MakUnit          = MakuluFramework.Unit
local TableToLocal     = MakuluFramework.tableToLocal
local MakGcd           = MakuluFramework.gcd
local MakLists         = MakuluFramework.lists
local Trinket          = MakuluFramework.Trinket
local ConstUnit        = MakuluFramework.ConstUnits
local Debounce         = MakuluFramework.debounceSpell
local cacheContext     = MakuluFramework.Cache
local ConstCell        = cacheContext:getConstCacheCell()
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local BossMods         = Action.BossMods

local combatCache = MakuluFramework.Cache:getCombatCacheCell()  




local _G, setmetatable = _G, setmetatable


local ActionID       = {
    WillToSurvive = { ID = 59752 },
    Stoneform = { ID = 20594 },
    Shadowmeld = { ID = 58984 },
    EscapeArtist = { ID = 20589 },
    GiftOfTheNaaru = { ID = 59544 },
    Darkflight = { ID = 68992 },
    BloodFury = { ID = 20572 },
    WillOfTheForsaken = { ID = 7744 },
    WarStomp = { ID = 20549 },
    Berserking = { ID = 26297 },
    ArcaneTorrent = { ID = 50613 },
    RocketJump = { ID = 69070 },
    RocketBarrage = { ID = 69041 },
    QuakingPalm = { ID = 107079 },
    SpatialRift = { ID = 256948 },
    LightsJudgment = { ID = 255647 },
    Fireblood = { ID = 265221 },
    ArcanePulse = { ID = 260364 },
    BullRush = { ID = 255654 },
    AncestralCall = { ID = 274738 },
    Haymaker = { ID = 287712 },
    Regeneratin = { ID = 291944 },
    BagOfTricks = { ID = 312411 },
    HyperOrganicLightOriginator = { ID = 312924 },

    BlackoutKick = { ID = 205523, MAKULU_INFO = { damageType = "physical" } },
    CracklingJadeLightning = { ID = 117952, MAKULU_INFO = { damageType = "magic" } },
    ChiBurst = { ID = 123986 },
    ChiTorpedo = { ID = 115008 },
    Clash = { ID = 324312 },
    Detox = { ID = 218164 },
    DiffuseMagic = { ID = 122783 },
    DampenHarm = { ID = 122278 },
    ExpelHarm = { ID = 322101 },
    FortifyingBrew = { ID = 115203 },
    LegSweep = { ID = 119381, MAKULU_INFO = { damageType = "physical" } },
    Paralysis = { ID = 115078, MAKULU_INFO = { damageType = "physical" } },
    Provoke = { ID = 115546 },
    Resuscitate = { ID = 115178 },
    RingOfPeace = { ID = 116844 },
    RisingSunKick = { ID = 107428, MAKULU_INFO = { damageType = "physical" } },
    Roll = { ID = 109132 },
    SongOfChiJi = { ID = 198898 },
    SoothingMist = { ID = 115175 },
    SpearHandStrike = { ID = 116705, MAKULU_INFO = { damageType = "physical" } },
    SpinningCraneKick = { ID = 101546, MAKULU_INFO = { damageType = "physical" } },
    TigerPalm = { ID = 100780, Texture = 287503, MAKULU_INFO = { damageType = "physical" } },
    TigersLust = { ID = 116841 },
    TouchOfDeath = { ID = 322109, MAKULU_INFO = { damageType = "physical" } },
    Transcendence = { ID = 101643 },
    TranscendenceTransfer = { ID = 119996 },
    Vivify = { ID = 116670 },

    KegSmash = { ID = 121253, MAKULU_INFO = { damageType = "physical" } },
	PurifyingBrew = { ID = 119582 },
	RushingJadeWind = { ID = 116847 },
	CelestialBrew = { ID = 322507 },
	ZenMeditation = { ID = 115176 },
	BreathOfFire = { ID = 115181, MAKULU_INFO = { damageType = "magic" } },
	InvokeNiuzao = { ID = 132578, MAKULU_INFO = { damageType = "physical" } },
	FortifyingBrewDetermination = { ID = 322960 },
	BlackOxBrew = { ID = 115399, MAKULU_INFO = { offGcd = true } },
	ExplodingKeg = { ID = 325153, MAKULU_INFO = { damageType = "magic" }, Macro = "/cast [@player]spell:thisID" },
	WeaponsOfOrder = { ID = 387184, FixedTexture = 3565447, MAKULU_INFO = { damageType = "physical" } },
	PressTheAdvantage = { ID = 418359, Texture = 287503, MAKULU_INFO = { damageType = "physical" } },
    CelestialInfusion = { ID = 1241059 },

    GrappleWeapon = { ID = 233759, MAKULU_INFO = { damageType = "physical" } },
    AvertHarm = { ID = 202162 },
	NimbleBrew = { ID = 354540 },
	DoubleBarrel = { ID = 202335 },
	MightyOxKick = { ID = 202370 },
	Admonishment = { ID = 207025 },

	BlackoutCombo = { ID = 196736, Hidden = true },
    FluidityOfMotion = { ID = 387230, Hidden = true },
    ScaldingBrew = { ID = 383698, Hidden = true },
    CharredPassions = { ID = 386965, Hidden = true },
    EndlessDraught = { ID = 450892, Hidden = true },

    Healthstone = { Type = "Item", ID = 5512, Hidden = true },
    TemperedPotion1 = { Type = "Potion", ID = 212263, Texture = 176108, Hidden = true },
    TemperedPotion2 = { Type = "Potion", ID = 212264, Texture = 176108, Hidden = true },
    TemperedPotion3 = { Type = "Potion", ID = 212265, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus1 = { Type = "Potion", ID = 212257, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus2 = { Type = "Potion", ID = 212258, Texture = 176108, Hidden = true },
    PotionofUnwaveringFocus3 = { Type = "Potion", ID = 212259, Texture = 176108, Hidden = true },
    FrontlinePotion = { Type = "Potion", ID = 212262, Texture = 176108, Hidden = true },
    AlgariManaPotion = { Type = "Potion", ID = 212241, Texture = 176108, Hidden = true },

    ArenaPreparation = { ID = 32727, Hidden = true },
    VivifyFriendly = { ID = 116670, Desc = "Party", FixedTexture = 133667, Hidden = false, Macro = "/cast [@party1,help] Vivify" }, --Universal 1

    MasterofHarmony = { ID = 450508 },
    ShadowPan       = { ID = 450615 },
    
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_MONK_BREWMASTER] = A

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

local gameState = {
	staggerLevel = "None",
	stagger = 0,
	staggerPct = 0,
	targetNoThreat = false,
	mouseoverNoThreat = false,
}

local buffs = {
	blackoutCombo = 228563,
	pressTheAdvantage = 418361,
	charredPassions = 386963,
	rushingJadeWind = 116847,
	chiBurst = 460490,
	explodingKeg = 325153,
	shuffle = 215479,
	purifiedChi = 325092,
    aspectOfHarmony = 450531,
    weaponsOfOrder = 387184,
    zenMeditation = 115176,
    dampenHarm = 122278,
    vivaciousVivification = 392883,
    fortifyingBrew = 115203,
    diffuseMagic = 122783,
    harmonicSurgeReady = 1239483, -- Potential Energy buff

}

local debuffs = {
	lightStagger = 124275,
	moderateStagger = 124274,
	heavyStagger = 124273,
    aspectOfHarmony = 450763,
    breathOfFire = 123725,
}

local function num(val)
    if val then return 1 else return 0 end
end

local interrupts = {
    { spell = SpearHandStrike },
    { spell = LegSweep, isCC = true, aoe = true, distance = 4 },
    { spell = Paralysis, isCC = true },
}

local function majorDRActive()
    return player:Buff(buffs.dampenHarm) or player:Buff(buffs.zenMeditation) or player:Buff(buffs.fortifyingBrew) or player:Buff(buffs.diffuseMagic)
end

-- === Hero talent detection ===
local function IsShadoPan()
    return player:TalentKnown(ShadowPan.id) or player:TalentKnown(450615)
end
local function IsMasterOfHarmony()
    return player:TalentKnown(MasterofHarmony.id) or player:TalentKnown(450508)
end

-- Cache helpers that work across framework versions
local function cacheSet(cell, key, value)
    if cell and cell.Set then return cell:Set(key, value) end  -- newer API
    if cell then cell[key] = value end                         -- fallback
end

local function cacheGet(cell, key)
    if cell and cell.Get then return cell:Get(key) end         -- newer API
    return cell and cell[key]                                  -- fallback
end


local function shouldBurst()
    if A.BurstIsON("target") then
        if A.Zone ~= "arena" then
            local activeEnemies = MultiUnits:GetActiveUnitPlates()
            for enemy in pairs(activeEnemies) do
                if ActionUnit(enemy):Health() > (A.RisingSunKick:GetSpellDescription()[1] * 20) or target.isDummy or target.isBoss then
                    return true
                end
            end
        else
            return true
        end
    end
    return false
end

local function enemiesInMelee()
    return ConstCell:GetOrSet("enemiesInMelee", function()
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local total = 0

        for enemyGUID in pairs(activeEnemies) do -- Jack will fix our enemies check soon
            local enemy = MakUnit:new(enemyGUID)
            if enemy.distance <= 5 and not enemy:IsTotem() and not enemy.isPet then  -- I haven't tested the new totem yet
                total = total + 1
            end
        end

        return total
    end)
end

local function enemiesInRSK()
    local activeEnemies = MultiUnits:GetActiveUnitPlates()
    local total = 0

	for enemy in pairs(activeEnemies) do
		if A.RisingSunKick:IsSpellInRange(enemy) and not ActionUnit(enemy):IsTotem() and not ActionUnit(enemy):IsPet() then
			total = total + 1
		end
	end

	return total
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

local function AutoTarget()
    if not player.inCombat then return false end

    if A.GetToggle(2, "autotarget") then
        for _, spellInfo in ipairs(interrupts) do
            if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
                return false
            end
        end
    end

    if A.GetToggle(2, "autotarget") and TotemsInSpellRange(BlackoutKick) and not target:IsTotem() then
        return true
    end

    gameState.ShouldTaunt = MakuluFramework.TauntStatus(Provoke)

    if A.GetToggle(2, "autotaunt") and gameState.ShouldTaunt == "Switch" then
        return true
    end

    if BlackoutKick:InRange(target) and target.exists then return false end

    if A.GetToggle(2, "targetmelee") and EnemiesInSpellRange(BlackoutKick) > 0 then
        return true
    end
end

local function updateGameState()
	if player:Debuff(debuffs.lightStagger) then
		gameState.staggerLevel = "Light"
	elseif player:Debuff(debuffs.moderateStagger) then
		gameState.staggerLevel = "Moderate"
	elseif player:Debuff(debuffs.heavyStagger) then
		gameState.staggerLevel = "Heavy"
	else
		gameState.staggerLevel = "None"
	end

	gameState.stagger = UnitStagger("player")
	if gameState.stagger > 0 then
		gameState.staggerPct = (gameState.stagger / player.maxHealth) * 100
	end

	gameState.targetNoThreat = UnitThreatSituation("player", "target") == 0 or UnitThreatSituation("player", "target") == 2
	gameState.mouseoverNoThreat = UnitThreatSituation("player", "mouseover") == 0 or UnitThreatSituation("player", "mouseover") == 2

    gameState.tank_buster_in = MakuluFramework.DBM_TankBusterIn() or 1000000
end

CelestialBrew:Callback("dump", function(spell)
    if CelestialBrew.frac > 1.7 or not player:TalentKnown(EndlessDraught.id) then
        return spell:Cast(player)
    end
end)

PurifyingBrew:Callback("dump", function(spell)
	if gameState.staggerLevel == "None" then return end
    if gameState.stagger == 0 then return end
    if player:Buff(buffs.blackoutCombo) then return end

    return spell:Cast(player)
end)

-- Emergency "oh-shit" Purifying Brew
PurifyingBrew:Callback("panic", function(spell)
    -- Must have something to purify (this also gates the heal)
    if gameState.stagger == 0 then return end

    local hp      = player.hp
    local maxHP   = player:HealthMax()
    local ttd     = player:TTD()                 -- returns ms; 0 if unknown
    local DT      = MakuluFramework.DamageTracker
    local recent2 = DT and DT:GetRecentDamageTaken(2) or 0  -- damage in last 2s
    local stagPct = (maxHP > 0) and (gameState.stagger / maxHP) or 0

    -- User slider (if you have one); else use a sane default
    local cfgHP   = (A.GetToggle and A.GetToggle(2, "purifyHP")) or 45

    -- Fire in ANY of these cases:
    -- 1) HP below config OR hard floor
    if hp <= cfgHP or hp <= 35 then
        return spell:Cast(player)
    end

    -- 2) Took a big spike in the last 2s (>=30% max HP)
    if recent2 >= maxHP * 0.30 then
        return spell:Cast(player)
    end

    -- 3) Stagger pool is huge (>=40% max HP)
    if stagPct >= 0.40 then
        return spell:Cast(player)
    end

    -- 4) Time-to-die is imminent (<=4s)
    if ttd > 0 and ttd <= 4000 then
        return spell:Cast(player)
    end
end)

-- Prevent overcapping charges when any stagger exists
PurifyingBrew:Callback("overcap", function(spell)
    if gameState.stagger == 0 then return end
    if spell.ChargesFractional and spell:ChargesFractional() >= 1.9 then
        return spell:Cast(player)
    end
end)


BlackOxBrew:Callback(function(spell)
    if player.energy > 40 then return end
    if CelestialBrew.frac > 1.7 or not player:TalentKnown(EndlessDraught.id) and CelestialBrew.frac >= 1 then
        if MakGcd() > 250 then return end
    end

    CelestialBrew("dump")
    PurifyingBrew("dump")

	return spell:Cast(player)
end)

CelestialBrew:Callback(function(spell)
    if not player.inCombat then return end

    if player:Buff(buffs.aspectOfHarmony) and (player:Buff(buffs.weaponsOfOrder) or WeaponsOfOrder.cd > 20000 or not player:TalentKnown(WeaponsOfOrder.id)) and not target:Debuff(debuffs.aspectOfHarmony) then
        return spell:Cast(player)
    end

	local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end
	if gameState.staggerLevel == "None" then return end
    if gameState.stagger == 0 then return end

    if majorDRActive() and not player:Debuff(debuffs.heavyStagger) then
        return
    end

	if player:HasBuffCount(buffs.purifiedChi) >= 5 and MakuluFramework.TankDefensive() then
		return spell:Cast(player)
	end

	if player:Debuff(debuffs.heavyStagger) then
		return spell:Cast(player)
	end

	if player.hp < A.GetToggle(2, "celestialBrewHP") then
		return spell:Cast(player)
	end
end)

DiffuseMagic:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end
    if not player.inCombat then return end
    if majorDRActive() then return end

    if MakuluFramework.TankDefensive() or player.hp < A.GetToggle(2, "diffuseMagicHP") then
        return spell:Cast(player)
    end
end)

FortifyingBrew:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end
    if not player.inCombat then return end
    if majorDRActive() then return end

    if MakuluFramework.TankDefensive() or player.hp < A.GetToggle(2, "fortifyingBrewHP") then
        return spell:Cast(player)
    end
end)

CelestialInfusion:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[4] then return end
    if not player.inCombat then return end
    if player:Buff(1241059) then return end
    if majorDRActive() then return end

    if MakuluFramework.TankDefensive() or player.hp < A.GetToggle(2, "CelestialInfusionHP") then
        if spell:Cast(player) then
            -- NEW: grant 4p bonus stacks if Master of Harmony
            if IsMasterOfHarmony() and player:Has4Set() then
                cacheSet(combatCache, "harmonicStacks", 2)
                cacheSet(combatCache, "harmonicGivenAt", GetTime() * 1000)
            end
            return true
        end
    end
end)


ZenMeditation:Callback(function(spell)
    if player.moving then return end
    if not player.inCombat then return end
    if not MakuluFramework.TankDefensive() then return end
    if player:Buff(buffs.dampenHarm) then return end
    if player:Buff(buffs.fortifyingBrew) then return end
    if player:Buff(buffs.diffuseMagic) then return end

    return spell:Cast(player)
end)

DampenHarm:Callback(function(spell)
    if not player.inCombat then return end
    if not MakuluFramework.TankDefensive() then return end
    if player:Buff(buffs.zenMeditation) then return end
    if player:Buff(buffs.fortifyingBrew) then return end
    if player:Buff(buffs.diffuseMagic) then return end

    return spell:Cast(player)
end)

Provoke:Callback(function(spell)
    if gameState.ShouldTaunt == "Taunt" then
        return spell:Cast(target)
    end
end)

Provoke:Callback("mo", function(spell, icon)
	icon = icon or Regeneratin
	if IsInRaid() then return end
	if not A.GetToggle(2, "mouseover") then return end
	if not gameState.mouseoverNoThreat then return end
	if not mouseover.inCombat then return end

	return spell:Cast(mouseover, false, icon)
end)

ExpelHarm:Callback(function(spell, icon)
	if player.hp <= A.GetToggle(2, "expelHarmHP") then
		return spell:Cast(player)
	end
    local orbsReq = A.GetToggle(2, "expelHarmOrbs")
    if orbsReq and orbsReq > 0 and C_Spell.GetSpellCastCount(ExpelHarm.id) >= orbsReq then
        return spell:Cast(player)
    end
end)

RushingJadeWind:Callback("pre", function(spell)
    if not A.RushingJadeWind:IsTalentLearned() then return end
	if player.inCombat then return end

	return spell:Cast(player)
end)

TouchOfDeath:Callback(function(spell)
    if not TouchOfDeath:InRange(target) then return end

    if gameState.staggerLevel == "Heavy" then
        return spell:Cast(target)
    end

    if gameState.staggerLevel == "Moderate" and gameState.staggerPct > 50 then
        return spell:Cast(target)
    end
end)

Vivify:Callback(function(spell)
    -- Self-heal if low HP and Vivacious Vivification is active
    if player.hp <= 90 and player:Buff(buffs.vivaciousVivification) then
        return spell:Cast(player)
    end

    -- Otherwise heal current target (if friendly)
    if target:Exists() and target:IsFriendly() and spell:InRange(target) then
        return spell:Cast(target)
    end
end)

BlackoutKick:Callback(function(spell)

    return spell:Cast(target)
end)

ChiBurst:Callback(function(spell)
    if not RisingSunKick:InRange(target) then return end

    return spell:Cast(player)
end)

WeaponsOfOrder:Callback(function(spell)
	if not shouldBurst() then return end
	if enemiesInMelee() < 1 then return end

    return spell:Cast(player)
end)

RisingSunKick:Callback("noFluid", function(spell)
    if player:TalentKnown(FluidityOfMotion.id) then return end

    return spell:Cast(target)
end)

TigerPalm:Callback(function(spell)
    if not player:Buff(buffs.blackoutCombo) then return end

    return spell:Cast(target)
end)

KegSmash:Callback(function(spell)
    if not player:TalentKnown(ScaldingBrew.id) then return end

    return spell:Cast(target)
end)

SpinningCraneKick:Callback(function(spell)
    if not player:TalentKnown(CharredPassions.id) then return end
    if not player:TalentKnown(ScaldingBrew.id) then return end
	if not player:Buff(buffs.charredPassions) then return end
    if player:BuffRemains(buffs.charredPassions) > 3000 then return end
    if target:DebuffRemains(debuffs.breathOfFire) > 9000 then return end
	if enemiesInMelee() <= 4 then return end

    return spell:Cast(player)
end)

RisingSunKick:Callback(function(spell)

    return spell:Cast(target)
end)

PurifyingBrew:Callback("blackout", function(spell)
	if gameState.staggerLevel == "None" then return end
    if gameState.stagger == 0 then return end
    if player:Buff(buffs.blackoutCombo) then return end

	if PurifyingBrew.frac > 1.9 or player:BuffRemains(buffs.purifiedChi) < 1500 or player:Debuff(debuffs.heavyStagger) then
		return spell:Cast(player)
	end
end)

BreathOfFire:Callback(function(spell)
	if enemiesInMelee() < 1 then return end

    if not player:Buff(buffs.charredPassions) and (not player:TalentKnown(ScaldingBrew.id) or enemiesInMelee() < 5) then
        return spell:Cast(player)
    end

    if not player:TalentKnown(CharredPassions.id) then
        return spell:Cast(player)
    end

    if target:DebuffRemains(debuffs.breathOfFire) < 3000 and player:TalentKnown(ScaldingBrew.id) then
        return spell:Cast(player)
    end
end)

ExplodingKeg:Callback(function(spell)
	if enemiesInMelee() < 1 then return end

    return spell:Cast(player)
end)

KegSmash:Callback(function(spell)

    return spell:Cast(target)
end)

RushingJadeWind:Callback(function(spell)

    return spell:Cast(player)
end)

InvokeNiuzao:Callback(function(spell)
    if gameState.staggerLevel ~= "Heavy" then return end
	if enemiesInMelee() < 1 then return end

	return spell:Cast(player)
end)

TigerPalm:Callback("filler", function(spell)
	if player:TalentKnown(PressTheAdvantage.id) then return end
	if not RisingSunKick:InRange(target) then return end

    local energyRegen = GetPowerRegen()

    if player.energy > 40 - (num(KegSmash.cd > 300) * energyRegen) then
        return spell:Cast(target)
    end
end)

SpinningCraneKick:Callback("filler", function(spell)
	if player:TalentKnown(PressTheAdvantage.id) then return end
	if enemiesInMelee() < 1 then return end

    local energyRegen = GetPowerRegen()

    if player.energy > 40 - (num(KegSmash.cd > 300) * energyRegen) then

        return spell:Cast(target)
    end
end)

-- Cast WoO only under normal conditions, and then timestamp it
WeaponsOfOrder:Callback("tag", function(spell)
    if not shouldBurst() then return end
    if enemiesInMelee() < 1 then return end
    if spell:Cast(player) then
        cacheSet(combatCache, "wooCastMs", GetTime() * 1000)
        return true
    end
end)

KegSmash:Callback("woo_consume", function(spell)
    if not IsShadoPan() or not player:Has2Set() then return end
    local t = cacheGet(combatCache, "wooCastMs") or 0
    if t > 0 and (GetTime()*1000 - t) <= 1200 and spell:InRange(target) then
        return spell:Cast(target)
    end
end)

TigerPalm:Callback("woo_spend", function(spell)
    if not IsShadoPan() or not player:Has4Set() then return end
    if not player:Buff(buffs.weaponsOfOrder) then return end
    if KegSmash.cd > 800 and player.energy >= 40 and spell:InRange(target) then
        return spell:Cast(target)
    end
end)

SpinningCraneKick:Callback("woo_spend", function(spell)
    if not IsShadoPan() or not player:Has4Set() then return end
    if not player:Buff(buffs.weaponsOfOrder) then return end
    if enemiesInMelee() >= 3 and player.energy >= 45 then
        return spell:Cast(player)
    end
end)

-- Keep ONE CI charge rolling on Master of Harmony (after 3s in combat)
CelestialInfusion:Callback("maintain", function(spell)
    if not IsMasterOfHarmony() then return end
    if not player.inCombat then return end

    -- Only fire when capped at 2 charges
    local charges = spell.charges or 0
    if charges < 2 then return end

    if spell:Cast(player) then
        -- Grant 4p stacks if we have them
        if player:Has4Set() then
            cacheSet(combatCache, "harmonicStacks", 2)
            cacheSet(combatCache, "harmonicGivenAt", GetTime() * 1000)
        end
        return true
    end
end)


TigerPalm:Callback("harmonic_chain", function(spell)
    if not IsMasterOfHarmony() or not player:Has4Set() then return end
    local stacks = cacheGet(combatCache, "harmonicStacks") or 0
    if stacks <= 0 then return end
    if KegSmash.cd <= 600 or not spell:InRange(target) or player.energy < 40 then return end
    if spell:Cast(target) then
        cacheSet(combatCache, "harmonicStacks", stacks - 1)
        return true
    end
end)

TigerPalm:Callback("harmonic_proc", function(spell)
    if not IsMasterOfHarmony() or not player:Has2Set() then return end
    if not player:Buff(buffs.harmonicSurgeReady) then return end
    if KegSmash.cd <= 600 or not spell:InRange(target) or player.energy < 40 then return end
    return spell:Cast(target)
end)


local function rotation()
		local aoe = enemiesInMelee()

		-- High-threat openers for packs (improve initial aggro)
		if aoe >= 3 then
			KegSmash()
			ExplodingKeg()
			BreathOfFire()
			RushingJadeWind()
		end

	    -- Prioritize core threat generators early
	    KegSmash()
	    BreathOfFire()
	    ExplodingKeg()
	    RushingJadeWind()


	BlackOxBrew()
	TouchOfDeath()
    BlackoutKick()
    -- Use the tag so we timestamp WoO (Shado-Pan path only)
    WeaponsOfOrder("tag")
    RisingSunKick("noFluid")
    -- Shado-Pan (Flurry) set behavior
    KegSmash("woo_consume")
    TigerPalm("woo_spend")
    SpinningCraneKick("woo_spend")
    -- Master of Harmony (Harmonic Surge) set behavior
    TigerPalm("harmonic_chain")   -- 4p: two guaranteed Surges after CI("tag")
    TigerPalm("harmonic_proc")    -- 2p: Potential Energy buff up
    ChiBurst()
    SpinningCraneKick()
    TigerPalm()
    KegSmash()
    RisingSunKick()
    PurifyingBrew("blackout")
    BreathOfFire()
    ExplodingKeg()
    KegSmash()
    RushingJadeWind()
    InvokeNiuzao()
    TigerPalm("filler")
    SpinningCraneKick("filler")


end

LightsJudgment:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(target)
end)

BagOfTricks:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not shouldBurst() then return end

    return spell:Cast(target)
end)

BloodFury:Callback(function(spell)
    if not RisingSunKick:InRange(target) then return end
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(player)
end)

Berserking:Callback(function(spell)
    if not RisingSunKick:InRange(target) then return end
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(player)
end)

Fireblood:Callback(function(spell)
    if not RisingSunKick:InRange(target) then return end
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(player)
end)

AncestralCall:Callback(function(spell)
    if not RisingSunKick:InRange(target) then return end
    if not A.GetToggle(1, "Racial") then return end

    return spell:Cast(player)
end)

A[3] = function(icon)
	FrameworkStart(icon)
    updateGameState()

    local makAlert = A.GetToggle(2, "makAware")

    if makAlert[1] then
        if player:TalentKnown(ZenMeditation.id) and not A.ZenMeditation:IsBlocked() and ZenMeditation.cd < 500 then
            if MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0 then
                Aware:displayMessage("Zen Meditation! Stand Still", "Green", 1)
            end
        end
    end

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Niuzao active: ", pet.exists)
		MakPrint(2, "Stagger: ", gameState.stagger)
		MakPrint(3, "Stagger Level: ", gameState.staggerLevel)
		MakPrint(4, "Stagger Percent: ", gameState.staggerPct)
		MakPrint(5, "Target No Threat: ", gameState.targetNoThreat)
		MakPrint(6, "Mouseover No Threat: ", gameState.mouseoverNoThreat)
        MakPrint(7, "Expel Harm Spheres: ", C_Spell.GetSpellCastCount(ExpelHarm.id))
        MakPrint(8, "Energy Regen: ", GetPowerRegen())
        MakPrint(9, "Tank Def: ", MakuluFramework.TankDefensive())
        MakPrint(10, "Set Pieces: ", player:SetPieces())
        MakPrint(11, "Has2: ", player:Has2Set())
        MakPrint(12, "Has4: ", player:Has4Set())

    end

    if player.channeling then return end

    makInterrupt(interrupts)

	Provoke("mo")
	Provoke()
    ExpelHarm()
    Vivify()
    PurifyingBrew("panic")
    PurifyingBrew("overcap")
    ZenMeditation()
    DampenHarm()

    if target.exists and target.canAttack and CracklingJadeLightning:InRange(target) then
		RushingJadeWind("pre")

        -- Master of Harmony only: keep one CI charge rolling (won’t fire until 3s in combat)

        CelestialInfusion("maintain")
        CelestialInfusion()
        --CelestialInfusion("tag")
		DiffuseMagic()
		FortifyingBrew()
		CelestialBrew()

        if shouldBurst() and RisingSunKick:InRange(target) then
            BloodFury()
            Berserking()
            Fireblood()
            AncestralCall()
            LightsJudgment()
            BagOfTricks()

            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = true
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if Trinket(1, "Damage") then Trinket1() end
            if Trinket(2, "Damage") then Trinket2() end
        end
        rotation()
    end

	return FrameworkEnd()
end

TouchOfDeath:Callback("arena", function(spell, enemy)
    if not TouchOfDeath:InRange(enemy) or target.isDummy then return end

    return spell:Cast(enemy)
end)

GrappleWeapon:Callback("arena", function(spell, enemy)
    if not GrappleWeapon:InRange(enemy) then return end
    if A.GrappleWeapon:IsSuspended(0.5, 1) then return end
    if not enemy:BuffFrom(MakLists.Disarm) then return end

    return spell:Cast(enemy)
end)

SpearHandStrike:Callback("arena", function(spell, enemy)
    if not enemy.pvpKick then return end

    return spell:Cast(enemy)
end)

Paralysis:Callback("arena", function(spell, enemy)
    if enemy.cc then return end
    if enemy:IsTarget() then return end
    if enemy.incapacitateDr < 0.5 then return end

    if enemy.isHealer and target.exists and target.hp < 50 then
        Aware:displayMessage("Paralysis Healer", "Green", 1)
    end

    local peelParty = (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        Aware:displayMessage("Paralysis To Peel", "Red", 1)
        return spell:Cast(enemy)
    end
end)

TigersLust:Callback("arena", function(spell, friendly)
    if not TigersLust:InRange(friendly) then return end

    if not friendly:DebuffFrom(MakLists.Rooted) then return end
    if player:DebuffFrom(MakLists.Rooted) then
        return spell:Cast(player)
    end
    if player:DebuffFrom(MakLists.Rooted) then return end

    return spell:Cast(friendly)
end)

Detox:Callback("pve", function(spell, friendly)
    if not Detox:InRange(friendly) then return end

    local shouldDispel = friendly.diseased or friendly.poisoned

    if not shouldDispel then return end

    return Debounce("cleanse", 350, 1500, spell, friendly)
end)

VivifyFriendly:Callback("party", function(spell, friendly)
    if not Vivify:InRange(friendly) then return end
    if not player:Buff(buffs.vivaciousVivification) then return end

    if friendly.ehp > A.GetToggle(2, "vivifyHP") then return end

    return spell:Cast(friendly)
end)

local enemyRotation = function(enemy)
	if not enemy.exists then return end

    TouchOfDeath("arena", enemy)
    GrappleWeapon("arena", enemy)
    SpearHandStrike("arena", enemy)
    Paralysis("arena", enemy)
end

local partyRotation = function(friendly)
    if not friendly.exists then return end

    TigersLust("arena", friendly)
    Detox("pve", friendly)
    VivifyFriendly("party", friendly)
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
