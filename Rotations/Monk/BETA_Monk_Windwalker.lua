if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 269 then return end

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
local Debounce         = MakuluFramework.debounceSpell
local ConstSpells      = MakuluFramework.constantSpells
local Trinket          = MakuluFramework.Trinket
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local ActionUnit       = Action.Unit
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

-- Safety check: if Action.Player is not available, exit early
if not Action or not Action.Player then
    print("Action.Player not available - Windwalker rotation disabled")
    return
end

local _G, setmetatable = _G, setmetatable

local ActionID       = {
    WillToSurvive = { ID = 59752 },
    Stoneform = { ID = 20594 },
    Shadowmeld = { ID = 58984 },
    EscapeArtist = { ID = 20589 },
    GiftOfTheNaaru = { ID = 59544 },
    Darkflight = { ID = 68992 },
    BloodFury = { ID = 33697 },
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

    BlackoutKick = { ID = 100784, MAKULU_INFO = { damageType = "physical" } },
    CracklingJadeLightning = { ID = 117952, MAKULU_INFO = { damageType = "magic" } },  
    ChiBurst = { ID = 461404, MAKULU_INFO = { ignoreMoving = true } },
    ChiTorpedo = { ID = 115008 },
    Clash = { ID = 324312 },
    Detox = { ID = 218164 },
    Disable = { ID = 116095 },
    DiffuseMagic = { ID = 122783 },
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
    TigerPalm = { ID = 100780, MAKULU_INFO = { damageType = "physical" } },
    TigersLust = { ID = 116841 },
    TouchOfDeath = { ID = 322109, MAKULU_INFO = { damageType = "physical" } },
    Transcendence = { ID = 101643 },
    TranscendenceTransfer = { ID = 119996 },
    Vivify = { ID = 116670, MAKULU_INFO = { heal = true } },

    FistsOfFury = { ID = 113656, MAKULU_INFO = { damageType = "physical" } },
    StormEarthAndFire = { ID = 137639, MAKULU_INFO = { damageType = "physical" } },
    StrikeOfTheWindlord = { ID = 392983, MAKULU_INFO = { damageType = "physical" } },
    InvokeXuen = { ID = 123904, MAKULU_INFO = { damageType = "physical" } },
    WhirlingDragonPunch = { ID = 152175, MAKULU_INFO = { damageType = "physical" } },
    JadefireStomp = { ID = 388193, FixedTexture = 3636842, MAKULU_INFO = { damageType = "physical" } },
    TouchOfKarma = { ID = 122470 },
    FlyingSerpentKick = { ID = 101545, FixedTexture = 606545 },
    SlicingWinds = { ID = 1217413, FixedTexture = 606545, MAKULU_INFO = { damageType = "physical", ignoreCasting = true }  },

    TigereyeBrew = { ID = 247483 },
    GrappleWeapon = { ID = 233759, MAKULU_INFO = { damageType = "physical" } },

    CelestialConduit = { ID = 443028, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    CelestialConduitCancel = { ID = 443591, FixedTexture = 5927619, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },

    InnerPeace = { ID = 397768, Hidden = true },
    KnowledgeOfTheBrokenTemple = { ID = 451529, Hidden = true },
    OrderedElements = { ID = 451463, Hidden = true },
    ShadowboxingTreads = { ID = 392982, Hidden = true },
    XuensBattlegear = { ID = 392993, Hidden = true },
    PowerOfTheThunderKing = { ID = 459809, Hidden = true },
    SingularlyFocusedJade = { ID = 451573, Hidden = true },
    JadefireHarmony = { ID = 391412, Hidden = true },
    EnergyBurst = { ID = 451498, Hidden = true },
    SequencedStrikes = { ID = 451515, Hidden = true },
    HitCombo = { ID = 196740, Hidden = true },
    GaleForce = { ID = 451580, Hidden = true },
    LastEmperorsCapacitor = { ID = 392989, Hidden = true },
    XuensBond = { ID = 392986, Hidden = true },
    RevolvingWhirl = { ID = 451524, Hidden = true },
    FlurryStrikes = { ID = 450615, Hidden = true },
    GloryOfTheDawn = { ID = 392958, Hidden = true },
    MemoryOfTheMonastery = { ID = 454969, Hidden = true },
    CraneVortex = { ID = 388848, Hidden = true },
    CourageousImpulse = { ID = 451495, Hidden = true },

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
    VivifyFriendly = { ID = 116670, Desc = "Party", FixedTexture = 133667 }, --Universal 1
}

local A, M = MakuluFramework.CreateActionVar(ActionID)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_MONK_WINDWALKER] = A

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

local gs = {
    comboStrike = nil,
    maxCrane = 0,
    shouldAoE = false,
    imCasting = nil,
    tigerPalmEnemies = 0,
}

local buffs = {
    stormEarthAndFire = 137639,
    teachingsOfTheMonastery = 202090,
    orderedElements = 451462,
    danceOfChiJi = 325202,
    chiBurst = 460490,
    theEmperorsCapacitor = 393039,
    invokersDelight = 388663,
    powerInfusion = 10060,
    blackoutReinforcement = 424454,
    bokProc = 116768,
    chiEnergy = 393057,
    pressurePoint = 393053,
    heartOfTheJadeSerpentCdr = 443421,
    heartOfTheJadeSerpentCdrCelestial = 443616,
    wisdomOfTheWallFlurry = 452688,
    memoryOfTheMonastery = 454970,
    vivaciousVivification = 392883,
    -- TWW Season 3 Set Bonus Buffs
    flurryStrikes = 450615,
    innerFlame = 451452, -- Flameshaper set bonus
    harmonicSurge = 451461, -- Master of Harmony set bonus
}

local debuffs = {
    acclamation = 451433,
    markOfTheCrane = 228287,
    galeForce = 451582,
}

local arenaKicks = MakLists.arenaKicks

local kickPercent = 32
local meldDuration = 0.9
local shortHalfSecond = 620
local channelKickTime = 400
local quickKick = 15

local function generateNewRandomKicks()
    kickPercent = math.random(40, 90)
    meldDuration = math.random(600, 1200) / 1000
    shortHalfSecond = math.random(400, 600) / 1000
    channelKickTime = math.random(300, 800)
    quickKick = math.random(10, 20)

    return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()

local function num(val)
    if val then return 1 else return 0 end
end

--[[Player:AddTier("Tier31", { 207281, 207279, 207284, 207280, 207282, })
local T31has2P = Player:HasTier("Tier31", 2)
local T31has4P = Player:HasTier("Tier31", 4)]]

local interrupts = {
    { spell = SpearHandStrike },
    { spell = LegSweep, isCC = true, aoe = true, distance = 4 },
    { spell = Paralysis, isCC = true },
}

local function shouldBurst()
    return makBurst()
end

local constCell = cacheContext:getConstCacheCell()
local function enemiesInRange(debuff, dur)
    return constCell:GetOrSet("enemiesInRange", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if TigerPalm:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
                if (player.inCombat and enemy.inCombat) or (not player.inCombat and not enemy.inCombat) or enemy.isDummy then
                    if debuff and enemy:DebuffRemains(debuff, true) > dur then
                        count = count + 1
                    elseif not debuff then
                        count = count + 1
                    end
                end
            end
        end
        
        return count
    end)
end

local function fightRemains()
    return constCell:GetOrSet("areaTTD", function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local highest = 0 
        
        for enemyGUID in pairs(activeEnemies) do
            local enemy = MakUnit:new(enemyGUID)
            if enemy.isDummy then 
                highest = 99999
            else
                if enemy.ttd > 0 and enemy.ttd > highest then
                    highest = enemy.ttd
                end
            end
        end
        
        return highest
    end)
end

local function autoTarget()
    if not player.inCombat then return false end

    if A.Zone == "pvp" or A.Zone == "arena" then return false end

    for _, spellInfo in ipairs(interrupts) do
        if target:ShouldInterrupt(spellInfo.spell, spellInfo.isCC, spellInfo.aoe, spellInfo.distance) then
            return false
        end
    end

    if not A.GetToggle(2, "autoTarget") then return false end

    if TigerPalm:InRange(target) and target.exists then return false end

    if gs.tigerPalmEnemies > 0 then
        return true
    end
end

local triggerComboStrike = {
    [BlackoutKick.id] = true,
    [ChiBurst.id] = true,
    [CracklingJadeLightning.id] = true,
    [JadefireStomp.id] = true,
    [FistsOfFury.id] = true,
    [FlyingSerpentKick.id] = true,
    [SlicingWinds.id] = true,
    [RisingSunKick.id] = true,
    [SpinningCraneKick.id] = true,
    [StrikeOfTheWindlord.id] = true,
    [TouchOfDeath.id] = true,
    [TigerPalm.id] = true,
    [WhirlingDragonPunch.id] = true,
}

local PrevComboStrike = nil

local function OnSpellCast(self, event, unit, _, spellID)
    if unit == "player" and triggerComboStrike[spellID] then
        PrevComboStrike = spellID 
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", OnSpellCast)

function LastComboStrike()
    return PrevComboStrike
end

local function hasIncomingDamage()
    return incBigDmgIn() < 2000 or incModDmgIn() < 2000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive() 
end

local function myCast()
    local casting = player.castOrChannelInfo
    local currentCast = casting and casting.spellId

    return currentCast
end

local lastUpdateTime = 0
local updateDelay = 0.8

local function updategs()
    local currentTime = GetTime()
    local currentCast = myCast()
    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        lastUpdateTime = currentTime
    end

    gs.fightRemains = fightRemains()

    gs.comboStrike = LastComboStrike()
    gs.shouldAoE = A.GetToggle(2, "AoE") and A.Zone ~= "arena"
    gs.tigerPalmEnemies = enemiesInRange()
    gs.activeEnemies = math.max(gs.tigerPalmEnemies, 1)

    --actions+=/variable,name=sef_condition,value=target.time_to_die>6&(cooldown.rising_sun_kick.remains|active_enemies>2|!talent.ordered_elements)&(prev.invoke_xuen_the_white_tiger|(talent.celestial_conduit|!talent.last_emperors_capacitor)&buff.bloodlust.up&(cooldown.strike_of_the_windlord.remains<5|!talent.strike_of_the_windlord)&talent.sequenced_strikes|buff.invokers_delight.remains>15|(cooldown.strike_of_the_windlord.remains<5|!talent.strike_of_the_windlord)&cooldown.storm_earth_and_fire.full_recharge_time<cooldown.invoke_xuen_the_white_tiger.remains&cooldown.fists_of_fury.remains<5&(!talent.last_emperors_capacitor|talent.celestial_conduit)|talent.last_emperors_capacitor&buff.the_emperors_capacitor.stack>17&cooldown.invoke_xuen_the_white_tiger.remains>cooldown.storm_earth_and_fire.full_recharge_time)|fight_remains<30|buff.invokers_delight.remains>15&(cooldown.rising_sun_kick.remains|active_enemies>2|!talent.ordered_elements)|fight_style.patchwerk&buff.bloodlust.up&(cooldown.rising_sun_kick.remains|active_enemies>2|!talent.ordered_elements)&talent.celestial_conduit&time>10
    gs.sefCondition = (target.ttd > 6000 or target.isDummy) and (RisingSunKick.cd > 700 or gs.activeEnemies > 2 or not player:TalentKnown(OrderedElements.id)) and (Player:PrevGCD(1, A.InvokeXuen) or (player:TalentKnown(CelestialConduit.id) or not player:TalentKnown(LastEmperorsCapacitor.id)) and player.bloodlust and (StrikeOfTheWindlord.cd < 5000 or not player:TalentKnown(StrikeOfTheWindlord.id)) and player:TalentKnown(SequencedStrikes.id) or player:BuffRemains(buffs.invokersDelight) > 15000 or (StrikeOfTheWindlord.cd < 5000 or not player:TalentKnown(StrikeOfTheWindlord.id)) and StormEarthAndFire:TimeToFullCharges() < InvokeXuen.cd and FistsOfFury.cd < 5000 and (not player:TalentKnown(LastEmperorsCapacitor.id) or player:TalentKnown(CelestialConduit.id)) or player:TalentKnown(LastEmperorsCapacitor.id) and player:HasBuffCount(buffs.theEmperorsCapacitor) > 17 and InvokeXuen.cd > StormEarthAndFire:TimeToFullCharges()) or (IsInRaid() and target.isBoss and target.ttd < 30000) or player:BuffRemains(buffs.invokersDelight) > 15000 and (RisingSunKick.cd > 700 or gs.activeEnemies > 2 or not player:TalentKnown(OrderedElements.id)) or IsInRaid() and target.isBoss and (RisingSunKick.cd > 700 or gs.activeEnemies > 2 or not player:TalentKnown(OrderedElements.id)) and player:TalentKnown(CelestialConduit.id) and player.combatTime > 10

    --actions+=/variable,name=xuen_condition,value=(fight_style.DungeonSlice&active_enemies=1&(time<10|talent.xuens_bond&talent.celestial_conduit)|!fight_style.dungeonslice|active_enemies>1)&cooldown.storm_earth_and_fire.ready&(target.time_to_die>14&!fight_style.dungeonroute|target.time_to_die>22)&(active_enemies>2|debuff.acclamation.up|!talent.ordered_elements&time<5)&(chi>2&talent.ordered_elements|chi>5|chi>3&energy<50|energy<50&active_enemies=1|prev.tiger_palm&!talent.ordered_elements&time<5)|fight_remains<30|fight_style.dungeonroute&talent.celestial_conduit&target.time_to_die>14
    gs.dungeonSlice = MakMulti.party:Size() <= 5

    gs.xuenCondition = (gs.dungeonSlice and gs.activeEnemies <= 1 and (player.combatTime < 10 or player:TalentKnown(XuensBond.id) and player:TalentKnown(CelestialConduit.id)) or not gs.dungeonSlice or gs.activeEnemies > 1) and StormEarthAndFire.cd < 700 and (target.ttd > 14000 and not gs.dungeonSlice or target.ttd > 22000 or target.isDummy) and (gs.activeEnemies > 2 or target:Debuff(debuffs.acclamation) or not player:TalentKnown(OrderedElements.id) and player.combatTime < 5) and (player.chi > 2 and player:TalentKnown(OrderedElements.id) or player.chi > 5 or player.chi > 3 and player.energy < 50 or player.energy < 50 and gs.activeEnemies <= 1 or Player:PrevGCD(1, A.TigerPalm) and not player:TalentKnown(OrderedElements.id) and player.combatTime < 5) or (IsInRaid() and target.isBoss and target.ttd < 30000) or gs.dungeonSlice and player:TalentKnown(CelestialConduit.id) and (target.ttd > 14000 or target.isDummy)

    -- TWW Season 3 Set Bonus Tracking
    gs.shadoPanSetActive = player:Buff(buffs.flurryStrikes) -- Shado-Pan set bonus detection
    gs.celestialConduitSetActive = player:TalentKnown(CelestialConduit.id) -- Celestial Conduit hero talent
    gs.masterOfHarmonySetActive = player:Buff(buffs.harmonicSurge) -- Master of Harmony set bonus detection
    gs.heartOfJadeSerpentActive = player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)

    -- Enhanced burst conditions with set bonus considerations
    gs.burstWindow = player:Buff(buffs.stormEarthAndFire) and (gs.shadoPanSetActive or gs.celestialConduitSetActive)
    gs.resourceOptimal = player.energy > 80 and player.chi >= 3 -- Optimal resource state for set bonus usage

    -- PHASE 1 OPTIMIZATION: Heart of Jade Serpent Chi Pre-Pooling
    -- Track when Strike of the Windlord or Celestial Conduit will be available soon
    -- This allows predictive Chi pooling to maximize abilities during the 4-second HotJS CDR window
    gs.strikeOfWindlordSoon = StrikeOfTheWindlord.cd < 3000 and StrikeOfTheWindlord.cd > 500 and player:TalentKnown(StrikeOfTheWindlord.id)
    gs.celestialConduitSoon = CelestialConduit.cd < 3000 and CelestialConduit.cd > 500 and player:TalentKnown(CelestialConduit.id)
    gs.hotJSSoon = gs.strikeOfWindlordSoon or gs.celestialConduitSoon

end

TouchOfKarma:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[1] then return end 
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp < A.GetToggle(2, "touchOfKarmaHP") then
        return spell:Cast()
    end
end)

DiffuseMagic:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[2] then return end 
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp < A.GetToggle(2, "diffuseMagicHP") then
        return spell:Cast()
    end
end)

FortifyingBrew:Callback(function(spell)
    local defensiveSelect = A.GetToggle(2, "defensiveSelect")
    if not defensiveSelect[3] then return end 
    if not player.inCombat then return end
    
    if shouldDefensive() or player.hp < A.GetToggle(2, "fortifyingBrewHP") then
        return spell:Cast()
    end
end)

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

-- actions.aoe_opener=slicing_winds
SlicingWinds:Callback("aoeOpener", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end


    return spell:Cast()

end)
-- actions.aoe_opener+=/tiger_palm,if=chi<6
TigerPalm:Callback("aoeOpener", function(spell)
    if player.chi >= 6 then return end

    return spell:Cast(target)
end)

local function aoeOpener()
    SlicingWinds("aoeOpener")
    TigerPalm("aoeOpener")
end

-- actions.normal_opener=tiger_palm,if=chi<6&combo_strike
TigerPalm:Callback("normalOpener", function(spell)
    if player.chi >= 6 then return end
    if gs.comboStrike == spell.id then return end

    return spell:Cast(target)
end)

-- actions.normal_opener+=/rising_sun_kick,if=talent.ordered_elements
RisingSunKick:Callback("normalOpener", function(spell)
    if not player:TalentKnown(OrderedElements.id) then return end

    return spell:Cast(target)
end)

local function normalOpener()
    TigerPalm("normalOpener")
    RisingSunKick("normalOpener")
end

-- actions.fallback=spinning_crane_kick,if=chi>5&combo_strike
SpinningCraneKick:Callback("fallback", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end

    if gs.comboStrike == spell.id then return end

    if player.chi <= 5 then return end

    return spell:Cast()
end)
-- actions.fallback+=/blackout_kick,if=combo_strike&chi>3
BlackoutKick:Callback("fallback", function(spell)
    if gs.comboStrike == spell.id then return end
    if player.chi <= 3 then return end

    return spell:Cast(target)
end)

-- actions.fallback+=/tiger_palm,if=combo_strike&chi>5
TigerPalm:Callback("fallback", function(spell)
    if gs.comboStrike == spell.id then return end
    if player.chi <= 5 then return end

    return spell:Cast(target)
end)

local function fallback()
    SpinningCraneKick("fallback")
    BlackoutKick("fallback")
    TigerPalm("fallback")
end

-- APL: actions.cooldowns=invoke_external_buff,name=power_infusion,if=pet.xuen_the_white_tiger.active&(!buff.bloodlust.up|buff.bloodlust.up&cooldown.strike_of_the_windlord.remains)
-- Note: Power Infusion is external buff, handled by player/raid

--actions.cooldowns+=/storm_earth_and_fire,target_if=max:target.time_to_die,if=fight_style.dungeonroute&buff.invokers_delight.remains>15&(active_enemies>2|!talent.ordered_elements|cooldown.rising_sun_kick.remains)
StormEarthAndFire:Callback("cooldown", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end

    if player:Buff(buffs.stormEarthAndFire) then return end

    if A.GetToggle(2, "holdSEF") then
        if spell.frac < 1.9 then
            if InvokeXuen.cd > 85000 then return end
        end
    end

    -- TWW Season 3 optimization: Shado-Pan set bonus synergy
    -- Prioritize SEF when we can benefit from Flurry Strikes generation
    local hasFlurryStrikes = player:TalentKnown(FlurryStrikes.id)
    local shadoPanSetBonus = player:Buff(buffs.flurryStrikes) -- Check for set bonus presence

    -- Enhanced condition for set bonus optimization
    if gs.dungeonSlice and player:BuffRemains(buffs.invokersDelight) > 15000 and
       (gs.activeEnemies > 2 or not player:TalentKnown(OrderedElements.id) or RisingSunKick.cd > 700) then
        return spell:Cast()
    end

    -- Additional condition for Shado-Pan set bonus optimization
    if hasFlurryStrikes and player.energy > 120 and gs.activeEnemies >= 2 then
        return spell:Cast()
    end
end)

--actions.cooldowns+=/slicing_winds,if=talent.celestial_conduit&variable.sef_condition
SlicingWinds:Callback("cooldown", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end
    if not player:TalentKnown(CelestialConduit.id) then return end
    if not gs.sefCondition then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--actions.cooldowns+=/tiger_palm,if=(target.time_to_die>14&!fight_style.dungeonroute|target.time_to_die>22)&!cooldown.invoke_xuen_the_white_tiger.remains&(chi<5&!talent.ordered_elements|chi<3)&(combo_strike|!talent.hit_combo)
TigerPalm:Callback("cooldown", function(spell)
    if (target.ttd > 14000 and not gs.dungeonSlice or target.ttd > 22000 or target.isDummy) and InvokeXuen.cd < 700 and shouldBurst() and (player.chi < 5 and not player:TalentKnown(OrderedElements.id) or player.chi < 3) and (gs.comboStrike ~= spell.id or not player:TalentKnown(HitCombo.id)) then
        return spell:Cast(target)
    end
end)

--actions.cooldowns+=/invoke_xuen_the_white_tiger,target_if=max:target.time_to_die,if=variable.xuen_condition&!fight_style.dungeonslice&!fight_style.dungeonroute|variable.xuen_dungeonslice_condition&fight_style.Dungeonslice|variable.xuen_dungeonroute_condition&fight_style.dungeonroute
InvokeXuen:Callback("cooldown", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[2] then return end
    end

    if not gs.xuenCondition then return end

    return spell:Cast()
end)

--actions.cooldowns+=/storm_earth_and_fire,target_if=max:target.time_to_die,if=variable.sef_condition&!fight_style.dungeonroute|variable.sef_dungeonroute_condition&fight_style.dungeonroute
StormEarthAndFire:Callback("cooldown2", function(spell)   
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[1] then return end
    end
    
    if player:Buff(buffs.stormEarthAndFire) then return end
    
    if A.GetToggle(2, "holdSEF") then
        if StormEarthAndFire:TimeToFullCharges() > InvokeXuen.cd then return end
    end

    if not gs.dungeonSlice then
        if gs.sefCondition then
            return spell:Cast()
        end
    else
        return spell:Cast()
    end
end)

-- APL: actions.cooldowns+=/ancestral_call,if=buff.invoke_xuen_the_white_tiger.remains>15|!talent.invoke_xuen_the_white_tiger&(!talent.storm_earth_and_fire&(cooldown.strike_of_the_windlord.ready|!talent.strike_of_the_windlord&cooldown.fists_of_fury.ready)|buff.storm_earth_and_fire.remains>10)|fight_remains<20
AncestralCall:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not TigerPalm:InRange(target) then return end

    -- APL condition
    if player:BuffRemains(buffs.invokersDelight) > 15000 or
       (not player:TalentKnown(InvokeXuen.id) and
        (not player:TalentKnown(StormEarthAndFire.id) and
         (StrikeOfTheWindlord.cd < 700 or not player:TalentKnown(StrikeOfTheWindlord.id) and FistsOfFury.cd < 700) or
         player:BuffRemains(buffs.stormEarthAndFire) > 10000)) or
       gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- APL: actions.cooldowns+=/blood_fury,if=buff.invoke_xuen_the_white_tiger.remains>15|!talent.invoke_xuen_the_white_tiger&(!talent.storm_earth_and_fire&(cooldown.strike_of_the_windlord.ready|!talent.strike_of_the_windlord&cooldown.fists_of_fury.ready)|buff.storm_earth_and_fire.remains>10)|fight_remains<20
BloodFury:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not TigerPalm:InRange(target) then return end

    -- APL condition
    if player:BuffRemains(buffs.invokersDelight) > 15000 or
       (not player:TalentKnown(InvokeXuen.id) and
        (not player:TalentKnown(StormEarthAndFire.id) and
         (StrikeOfTheWindlord.cd < 700 or not player:TalentKnown(StrikeOfTheWindlord.id) and FistsOfFury.cd < 700) or
         player:BuffRemains(buffs.stormEarthAndFire) > 10000)) or
       gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- APL: actions.cooldowns+=/fireblood,if=buff.invoke_xuen_the_white_tiger.remains>15|!talent.invoke_xuen_the_white_tiger&(!talent.storm_earth_and_fire&(cooldown.strike_of_the_windlord.ready|!talent.strike_of_the_windlord&cooldown.fists_of_fury.ready)|buff.storm_earth_and_fire.remains>10)|fight_remains<20
Fireblood:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not TigerPalm:InRange(target) then return end

    -- APL condition
    if player:BuffRemains(buffs.invokersDelight) > 15000 or
       (not player:TalentKnown(InvokeXuen.id) and
        (not player:TalentKnown(StormEarthAndFire.id) and
         (StrikeOfTheWindlord.cd < 700 or not player:TalentKnown(StrikeOfTheWindlord.id) and FistsOfFury.cd < 700) or
         player:BuffRemains(buffs.stormEarthAndFire) > 10000)) or
       gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

-- APL: actions.cooldowns+=/berserking,if=buff.invoke_xuen_the_white_tiger.remains>15|!talent.invoke_xuen_the_white_tiger&(!talent.storm_earth_and_fire&(cooldown.strike_of_the_windlord.ready|!talent.strike_of_the_windlord&cooldown.fists_of_fury.ready)|buff.storm_earth_and_fire.remains>10)|fight_remains<20
Berserking:Callback(function(spell)
    if not A.GetToggle(1, "Racial") then return end
    if not TigerPalm:InRange(target) then return end

    -- APL condition
    if player:BuffRemains(buffs.invokersDelight) > 15000 or
       (not player:TalentKnown(InvokeXuen.id) and
        (not player:TalentKnown(StormEarthAndFire.id) and
         (StrikeOfTheWindlord.cd < 700 or not player:TalentKnown(StrikeOfTheWindlord.id) and FistsOfFury.cd < 700) or
         player:BuffRemains(buffs.stormEarthAndFire) > 10000)) or
       gs.fightRemains < 20000 then
        return spell:Cast()
    end
end)

local function cds()
    -- TWW Season 3 optimized cooldown usage
    -- Prioritize Storm, Earth, and Fire with set bonus considerations
    StormEarthAndFire("cooldown")

    -- Slicing Winds priority for Celestial Conduit set bonus
    SlicingWinds("cooldown")

    -- Tiger Palm for resource management and set bonus synergy
    TigerPalm("cooldown")

    -- Invoke Xuen timing optimization
    InvokeXuen("cooldown")

    -- Secondary SEF usage for extended fights
    StormEarthAndFire("cooldown2")

    -- Racial cooldowns
    BloodFury()
    Berserking()
    Fireblood()
    AncestralCall()
end

--APL: actions.default_aoe=tiger_palm,if=(energy>55&talent.inner_peace|energy>60&!talent.inner_peace)&combo_strike&chi.max-chi>=2&buff.teachings_of_the_monastery.stack<buff.teachings_of_the_monastery.max_stack&(talent.energy_burst&!buff.bok_proc.up)&!buff.ordered_elements.up|(talent.energy_burst&!buff.bok_proc.up)&!buff.ordered_elements.up&!cooldown.fists_of_fury.remains&chi<3|(prev.strike_of_the_windlord|cooldown.strike_of_the_windlord.remains)&cooldown.celestial_conduit.remains<2&buff.ordered_elements.up&chi<5&combo_strike
TigerPalm:Callback("aoe", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- First condition: (energy>55&talent.inner_peace|energy>60&!talent.inner_peace)&combo_strike&chi.max-chi>=2&buff.teachings_of_the_monastery.stack<buff.teachings_of_the_monastery.max_stack&(talent.energy_burst&!buff.bok_proc.up)&!buff.ordered_elements.up
    if player.energy > (55 + (5 * player:TalentKnownInt(InnerPeace.id))) and
       gs.comboStrike ~= spell.id and
       player.chiMax - player.chi >= 2 and
       player:HasBuffCount(buffs.teachingsOfTheMonastery) < (4 + (4 * player:TalentKnownInt(KnowledgeOfTheBrokenTemple.id))) and
       (player:TalentKnown(EnergyBurst.id) and not player:Buff(buffs.bokProc)) and
       not player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end

    -- Second condition: (talent.energy_burst&!buff.bok_proc.up)&!buff.ordered_elements.up&!cooldown.fists_of_fury.remains&chi<3
    if (player:TalentKnown(EnergyBurst.id) and not player:Buff(buffs.bokProc)) and
       not player:Buff(buffs.orderedElements) and
       FistsOfFury.cd < 700 and
       player.chi < 3 then
        return spell:Cast(target)
    end

    -- Third condition: (prev.strike_of_the_windlord|cooldown.strike_of_the_windlord.remains)&cooldown.celestial_conduit.remains<2&buff.ordered_elements.up&chi<5&combo_strike
    if (gs.comboStrike == StrikeOfTheWindlord.id or StrikeOfTheWindlord.cd > 700) and
       CelestialConduit.cd < 2000 and
       player:Buff(buffs.orderedElements) and
       player.chi < 5 and
       gs.comboStrike ~= spell.id then
        return spell:Cast(target)
    end
end)

--APL: actions.default_aoe+=/touch_of_death,if=!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up
TouchOfDeath:Callback("aoe", function(spell)
    if not TigerPalm:InRange(target) then return end
    if target.ttd < A.GetToggle(2, "TODSensitivity") * 1000 and not target.isDummy then return end

    -- APL condition: !buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) and not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=buff.dance_of_chiji.stack=2&combo_strike
SpinningCraneKick:Callback("aoe", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) ~= 2 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.chi_energy.stack>29&cooldown.fists_of_fury.remains<5
SpinningCraneKick:Callback("aoe2", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.chiEnergy) <= 29 then return end
    if FistsOfFury.cd >= 5000 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.stack<2
WhirlingDragonPunch:Callback("aoe", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) then return end
    if player:HasBuffCount(buffs.danceOfChiJi) >= 2 then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=buff.dance_of_chiji.stack<2
WhirlingDragonPunch:Callback("aoe2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if player:HasBuffCount(buffs.danceOfChiJi) >= 2 then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/slicing_winds,if=buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up
SlicingWinds:Callback("aoe", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    if player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[4] then
            Aware:displayMessage("Slicing Winds Soon!", "White", 1)
        end
    
        if player.stayTime > 0.3 then
            return spell:Cast()
        end
    end
end)

--actions.default_aoe+=/celestial_conduit,if=buff.storm_earth_and_fire.up&cooldown.strike_of_the_windlord.remains&(!buff.heart_of_the_jade_serpent_cdr.up|debuff.gale_force.remains<5)&(talent.xuens_bond|!talent.xuens_bond&buff.invokers_delight.up)|fight_remains<15|fight_style.dungeonroute&buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains&buff.storm_earth_and_fire.remains<8
CelestialConduit:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if not player:Buff(buffs.stormEarthAndFire) then return end
    if StrikeOfTheWindlord.cd < 300 then return end

    if (not player:Buff(buffs.heartOfTheJadeSerpentCdr) or target:DebuffRemains(debuffs.galeForce) < 5000) and (player:TalentKnown(XuensBond.id) or player:Buff(buffs.invokersDelight)) or (IsInRaid() and target.isBoss and target.ttd < 15000) or gs.dungeonSlice and player:Buff(buffs.invokersDelight) and StrikeOfTheWindlord.cd > 700 and player:BuffRemains(buffs.stormEarthAndFire) < 8000 then
        return spell:Cast()
    end
end)

--APL: actions.default_aoe+=/rising_sun_kick,target_if=max:target.time_to_die,if=cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2|!buff.storm_earth_and_fire.up&buff.pressure_point.up
RisingSunKick:Callback("aoe", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- First condition: cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2
    if WhirlingDragonPunch.cd < 2000 and FistsOfFury.cd > 1000 and player:HasBuffCount(buffs.danceOfChiJi) < 2 then
        return spell:Cast(target)
    end

    -- Second condition: !buff.storm_earth_and_fire.up&buff.pressure_point.up
    if not player:Buff(buffs.stormEarthAndFire) and player:Buff(buffs.pressurePoint) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=!talent.revolving_whirl|talent.revolving_whirl&buff.dance_of_chiji.stack<2&active_enemies>2
WhirlingDragonPunch:Callback("aoe2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if not player:TalentKnown(RevolvingWhirl.id) or player:TalentKnown(RevolvingWhirl.id) and player:HasBuffCount(buffs.danceOfChiJi) < 2 and gs.activeEnemies > 2 then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[3] then
            Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
        end
    
        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
            return spell:Cast(target)
        end
    end
end)

--actions.default_aoe+=/blackout_kick,if=combo_strike&buff.bok_proc.up&chi<2&talent.energy_burst&energy<55
BlackoutKick:Callback("aoe", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not player:Buff(buffs.bokProc) then return end
    if player.chi >= 2 then return end
    if not player:TalentKnown(EnergyBurst.id) then return end
    if player.energy >= 55 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/strike_of_the_windlord,target_if=max:target.time_to_die,if=(time>5|buff.invokers_delight.up&buff.storm_earth_and_fire.up)&(cooldown.invoke_xuen_the_white_tiger.remains>15|talent.flurry_strikes)
StrikeOfTheWindlord:Callback("aoe", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    
    if (player.combatTime > 5 or player:Buff(buffs.invokersDelight) and player:Buff(buffs.stormEarthAndFire)) or (InvokeXuen.cd > 15000 or player:TalentKnown(FlurryStrikes.id)) then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/slicing_winds
SlicingWinds:Callback("aoe2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=8&talent.shadowboxing_treads
BlackoutKick:Callback("aoe2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 8 then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/crackling_jade_lightning,target_if=max:target.time_to_die,if=buff.the_emperors_capacitor.stack>19&combo_strike&talent.power_of_the_thunder_king&cooldown.invoke_xuen_the_white_tiger.remains>10
CracklingJadeLightning:Callback("aoe", function(spell)
    if player:HasBuffCount(buffs.theEmperorsCapacitor) <= 19 then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(PowerOfTheThunderKing.id) then return end
    if InvokeXuen.cd < 10000 and shouldBurst() then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/fists_of_fury,target_if=max:target.time_to_die,if=(talent.flurry_strikes|talent.xuens_battlegear&(cooldown.invoke_xuen_the_white_tiger.remains>5&fight_style.patchwerk|cooldown.invoke_xuen_the_white_tiger.remains>9)|cooldown.invoke_xuen_the_white_tiger.remains>10)
FistsOfFury:Callback("aoe", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    
    if (player:TalentKnown(FlurryStrikes.id) or player:TalentKnown(XuensBattlegear.id) and (InvokeXuen.cd > 5000 and not gs.dungeonSlice or InvokeXuen.cd > 9000) or InvokeXuen.cd > 10000 or not shouldBurst()) then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.wisdom_of_the_wall_flurry.up&chi<6
TigerPalm:Callback("aoe2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player:Buff(buffs.wisdomOfTheWallFlurry) then return end
    if player.chi >= 6 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&chi>5
--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up&buff.chi_energy.stack>29&cooldown.fists_of_fury.remains<5
SpinningCraneKick:Callback("aoe2", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if target.physImmune then return end

    if player.chi > 5 then
        return spell:Cast()
    end

    if not player:Buff(buffs.danceOfChiJi) then return end
    if player:HasBuffCount(buffs.chiEnergy) < 30 then return end
    if FistsOfFury.cd > 5000 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/rising_sun_kick,if=buff.pressure_point.up&cooldown.fists_of_fury.remains>2
RisingSunKick:Callback("aoe2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if not player:Buff(buffs.pressurePoint) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 2000 then return end
    end

    return spell:Cast(target)
end)

--actions.default_aoe+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
BlackoutKick:Callback("aoe3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.bokProc) < 2 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up
--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.ordered_elements.up&talent.crane_vortex&active_enemies>2
SpinningCraneKick:Callback("aoe3", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end 
    if target.physImmune then return end
    
    if player:Buff(buffs.danceOfChiJi) then
        return spell:Cast()
    end

    if player:Buff(buffs.orderedElements) and player:TalentKnown(CraneVortex.id) then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.ordered_elements.up
--actions.default_aoe+=/tiger_palm,if=combo_strike&chi.deficit>=2&(!buff.ordered_elements.up|energy.time_to_max<=gcd.max*3)
TigerPalm:Callback("aoe3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if Player and Player:EnergyTimeToMax() < A.GetGCD() * 3 and player:TalentKnown(FlurryStrikes.id) and player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end

    if player.chiDeficit >= 2 and (not player:Buff(buffs.orderedElements) or (Player and Player:EnergyTimeToMax() < A.GetGCD() * 3)) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/jadefire_stomp,target_if=max:target.time_to_die,if=talent.Singularly_Focused_Jade|talent.jadefire_harmony
JadefireStomp:Callback("aoe", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    if player:TalentKnown(SingularlyFocusedJade.id) or player:TalentKnown(JadefireHarmony.id) then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&!buff.ordered_elements.up&talent.crane_vortex&active_enemies>2&chi>4
SpinningCraneKick:Callback("aoe4", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end 
    if target.physImmune then return end
    if player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(CraneVortex.id) then return end
    if player.chi <= 4 then return end
    
    return spell:Cast()
end)

-- actions.default_aoe+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(buff.teachings_of_the_monastery.stack>3|buff.ordered_elements.up)&(talent.shadowboxing_treads|buff.bok_proc.up)
-- actions.default_aoe+=/blackout_kick,if=combo_strike&!cooldown.fists_of_fury.remains&chi<3
-- actions.default_aoe+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.up
BlackoutKick:Callback("aoe4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if FistsOfFury.cd > 500 and (player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 or player:Buff(buffs.orderedElements)) and (player:TalentKnown(ShadowboxingTreads.id) or player:Buff(buffs.bokProc)) then
        return spell:Cast(target)
    end

    if FistsOfFury.cd < 500 and player.chi < 3 then
        return spell:Cast(target)
    end

    if player:TalentKnown(ShadowboxingTreads.id) and player:TalentKnown(CourageousImpulse.id) and player:Buff(buffs.bokProc) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/spinning_crane_kick,if=combo_strike&(chi>3|energy>55)
SpinningCraneKick:Callback("aoe5", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if target.physImmune then return end
    
    if player.chi > 3 or player.energy > 55 then
        return spell:Cast()
    end
end)

-- actions.default_aoe+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
-- actions.default_aoe+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("aoe5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:Buff(buffs.orderedElements) or player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.orderedElements) or player.chi > 2 or player.energy > 60 or player:Buff(buffs.bokProc) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/jadefire_stomp,target_if=max:debuff.acclamation.stack
JadefireStomp:Callback("aoe2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("aoe4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/chi_burst,if=!buff.ordered_elements.up
--actions.default_aoe+=/chi_burst
ChiBurst:Callback("aoe", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.chiBurst) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    if not player.moving then
        return spell:Cast()
    end
end)

--actions.default_aoe+=/spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
SpinningCraneKick:Callback("aoe6", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end 
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(HitCombo.id) then return end

    return spell:Cast()
end)

--actions.default_aoe+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("aoe6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player:TalentKnown(HitCombo.id) then return end
    
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    return spell:Cast(target)
end)

--actions.default_aoe+=/rising_sun_kick,target_if=max:target.time_to_die,if=cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2|!buff.storm_earth_and_fire.up&buff.pressure_point.up
RisingSunKick:Callback("aoe", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- First condition: cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2
    if WhirlingDragonPunch.cd < 2000 and FistsOfFury.cd > 1000 and player:HasBuffCount(buffs.danceOfChiJi) < 2 then
        return spell:Cast(target)
    end

    -- Second condition: !buff.storm_earth_and_fire.up&buff.pressure_point.up
    if not player:Buff(buffs.stormEarthAndFire) and player:Buff(buffs.pressurePoint) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=!talent.revolving_whirl|talent.revolving_whirl&buff.dance_of_chiji.stack<2&active_enemies>2
WhirlingDragonPunch:Callback("aoe3", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if not player:TalentKnown(RevolvingWhirl.id) or
       (player:TalentKnown(RevolvingWhirl.id) and player:HasBuffCount(buffs.danceOfChiJi) < 2 and gs.activeEnemies > 2) then

        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[3] then
            Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
        end

        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
            return spell:Cast()
        end
    end
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&chi>5
SpinningCraneKick:Callback("aoe3", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player.chi <= 5 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up&buff.chi_energy.stack>29&cooldown.fists_of_fury.remains<5
SpinningCraneKick:Callback("aoe4", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.danceOfChiJi) then return end
    if player:HasBuffCount(buffs.chiEnergy) <= 29 then return end
    if FistsOfFury.cd >= 5000 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/rising_sun_kick,if=buff.pressure_point.up&cooldown.fists_of_fury.remains>2
RisingSunKick:Callback("aoe2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.pressurePoint) then return end
    if FistsOfFury.cd <= 2000 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
BlackoutKick:Callback("aoe3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.bokProc) ~= 2 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up
SpinningCraneKick:Callback("aoe5", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.danceOfChiJi) then return end

    return spell:Cast()
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.ordered_elements.up&talent.crane_vortex&active_enemies>2
SpinningCraneKick:Callback("aoe6", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(CraneVortex.id) then return end
    if gs.activeEnemies <= 2 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.ordered_elements.up
TigerPalm:Callback("aoe3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player:Buff(buffs.orderedElements) then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&chi.deficit>=2&(!buff.ordered_elements.up|energy.time_to_max<=gcd.max*3)
TigerPalm:Callback("aoe4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player.chiDeficit < 2 then return end

    if not player:Buff(buffs.orderedElements) or (Player and Player:EnergyTimeToMax() <= A.GetGCD() * 3) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
TigerPalm:Callback("aoe6", function(spell)
    if A.GetLastCast() ~= spell.id then return end
    if player.chi >= 3 then return end
    if FistsOfFury.cd > 500 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&!buff.ordered_elements.up&talent.crane_vortex&active_enemies>2&chi>4
SpinningCraneKick:Callback("aoe7", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(CraneVortex.id) then return end
    if gs.activeEnemies <= 2 then return end
    if player.chi <= 4 then return end

    return spell:Cast()
end)

--actions.default_aoe+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(buff.teachings_of_the_monastery.stack>3|buff.ordered_elements.up)&(talent.shadowboxing_treads|buff.bok_proc.up)
BlackoutKick:Callback("aoe4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if FistsOfFury.cd < 500 then return end
    if not (player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 or player:Buff(buffs.orderedElements)) then return end
    if not (player:TalentKnown(ShadowboxingTreads.id) or player:Buff(buffs.bokProc)) then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/blackout_kick,if=combo_strike&!cooldown.fists_of_fury.remains&chi<3
BlackoutKick:Callback("aoe5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if FistsOfFury.cd > 500 then return end
    if player.chi >= 3 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.up
BlackoutKick:Callback("aoe6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.bokProc) then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/spinning_crane_kick,if=combo_strike&(chi>3|energy>55)
SpinningCraneKick:Callback("aoe8", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not (player.chi > 3 or player.energy > 55) then return end

    return spell:Cast()
end)

--actions.default_aoe+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
BlackoutKick:Callback("aoe7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not (player:Buff(buffs.orderedElements) or (player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id))) then return end
    if FistsOfFury.cd < 500 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("aoe8", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if FistsOfFury.cd < 500 then return end
    if not (player.chi > 2 or player.energy > 60 or player:Buff(buffs.bokProc)) then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("aoe5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--actions.default_aoe+=/chi_burst,if=!buff.ordered_elements.up
ChiBurst:Callback("aoe", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ChiBurst.id) then return end
    if player:Buff(buffs.orderedElements) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    return spell:Cast()
end)

--actions.default_aoe+=/chi_burst
ChiBurst:Callback("aoe2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ChiBurst.id) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    return spell:Cast()
end)

--actions.default_aoe+=/spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
SpinningCraneKick:Callback("aoe9", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(HitCombo.id) then return end

    return spell:Cast()
end)

--actions.default_aoe+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("aoe9", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player:TalentKnown(HitCombo.id) then return end
    if FistsOfFury.cd < 500 then return end

    return spell:Cast(target)
end)

local function aoe()
    -- New AoE rotation based on updated APL
    TigerPalm("aoe")                    -- tiger_palm opener conditions
    TouchOfDeath("aoe")                 -- touch_of_death
    SpinningCraneKick("aoe")           -- spinning_crane_kick dance_of_chiji.stack=2
    SpinningCraneKick("aoe2")          -- spinning_crane_kick chi_energy.stack>29
    WhirlingDragonPunch("aoe")         -- whirling_dragon_punch heart_of_jade_serpent_cdr
    WhirlingDragonPunch("aoe2")        -- whirling_dragon_punch dance_of_chiji.stack<2
    SlicingWinds("aoe")                -- slicing_winds heart_of_jade_serpent_cdr
    CelestialConduit("aoe")            -- celestial_conduit
    RisingSunKick("aoe")               -- rising_sun_kick conditions
    WhirlingDragonPunch("aoe3")        -- whirling_dragon_punch revolving_whirl
    BlackoutKick("aoe")                -- blackout_kick bok_proc energy_burst
    StrikeOfTheWindlord("aoe")         -- strike_of_the_windlord
    SlicingWinds("aoe2")               -- slicing_winds fallback
    BlackoutKick("aoe2")               -- blackout_kick teachings=8 shadowboxing
    CracklingJadeLightning("aoe")      -- crackling_jade_lightning emperors_capacitor
    FistsOfFury("aoe")                 -- fists_of_fury
    TigerPalm("aoe2")                  -- tiger_palm energy.time_to_max flurry_strikes
    SpinningCraneKick("aoe3")          -- spinning_crane_kick chi>5
    SpinningCraneKick("aoe4")          -- spinning_crane_kick dance_of_chiji chi_energy
    RisingSunKick("aoe2")              -- rising_sun_kick pressure_point
    BlackoutKick("aoe3")               -- blackout_kick shadowboxing courageous_impulse
    SpinningCraneKick("aoe5")          -- spinning_crane_kick dance_of_chiji
    SpinningCraneKick("aoe6")          -- spinning_crane_kick ordered_elements crane_vortex
    TigerPalm("aoe3")                  -- tiger_palm energy.time_to_max ordered_elements
    TigerPalm("aoe4")                  -- tiger_palm chi.deficit
    JadefireStomp("aoe")               -- jadefire_stomp singularly_focused/harmony
    SpinningCraneKick("aoe7")          -- spinning_crane_kick !ordered_elements crane_vortex
    BlackoutKick("aoe4")               -- blackout_kick cooldown.fists_of_fury.remains
    BlackoutKick("aoe5")               -- blackout_kick !cooldown.fists_of_fury.remains
    BlackoutKick("aoe6")               -- blackout_kick shadowboxing courageous_impulse bok_proc
    SpinningCraneKick("aoe8")          -- spinning_crane_kick chi>3|energy>55
    BlackoutKick("aoe7")               -- blackout_kick ordered_elements|bok_proc
    BlackoutKick("aoe8")               -- blackout_kick cooldown.fists_of_fury.remains
    JadefireStomp("aoe2")              -- jadefire_stomp max:debuff.acclamation.stack
    TigerPalm("aoe5")                  -- tiger_palm ordered_elements chi.deficit>=1
    ChiBurst("aoe")                    -- chi_burst !ordered_elements
    ChiBurst("aoe2")                   -- chi_burst fallback
    SpinningCraneKick("aoe9")          -- spinning_crane_kick ordered_elements hit_combo
    BlackoutKick("aoe9")               -- blackout_kick ordered_elements !hit_combo
    TigerPalm("aoe6")                  -- tiger_palm prev.tiger_palm chi<3
end

--actions.default_cleave=spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike
SpinningCraneKick:Callback("cleave", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) < 2 then return end
    
    return spell:Cast() 
end)

-- actions.default_cleave+=/rising_sun_kick,target_if=max:target.time_to_die,if=buff.pressure_point.up&active_enemies<4&cooldown.fists_of_fury.remains>4
-- actions.default_cleave+=/rising_sun_kick,target_if=max:target.time_to_die,if=cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2
RisingSunKick:Callback("cleave", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:Buff(buffs.pressurePoint) and gs.activeEnemies < 4 and FistsOfFury.cd > 4000 then
        return spell:Cast(target)
    end

    if WhirlingDragonPunch.cd < 2000 and FistsOfFury.cd > 1000 and player:HasBuffCount(buffs.danceOfChiJi) < 2 then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.stack=2&active_enemies>3
SpinningCraneKick:Callback("cleave2", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) < 2 then return end
    if gs.activeEnemies <= 3 then return end
    
    return spell:Cast() 
end)

-- PHASE 1 OPTIMIZATION: Heart of Jade Serpent Chi Pre-Pooling (Cleave)
-- Same optimization as single-target, applied to cleave rotation
TigerPalm:Callback("preHotJSCleave", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    -- Only pool Chi when Heart of Jade Serpent trigger abilities are coming soon
    if not gs.hotJSSoon then return end

    -- Don't pool if already in Heart of Jade Serpent window
    if gs.heartOfJadeSerpentActive then return end

    -- Pool Chi to 4+ before Strike of the Windlord or Celestial Conduit
    if player.chi < 4 and player.energy > 50 then
        return spell:Cast(target)
    end

    -- Also pool if Chi is very low (< 3) even with less energy
    if player.chi < 3 and player.energy > 40 and player.chiDeficit >= 2 then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/tiger_palm,if=(energy>55&talent.inner_peace|energy>60&!talent.inner_peace)&combo_strike&chi.max-chi>=2&buff.teachings_of_the_monastery.stack<buff.teachings_of_the_monastery.max_stack&(talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up|(talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up&!cooldown.fists_of_fury.remains&chi<3|(prev.strike_of_the_windlord|cooldown.strike_of_the_windlord.remains)&cooldown.celestial_conduit.remains<2&buff.ordered_elements.up&chi<5&combo_strike|(!buff.heart_of_the_jade_serpent_cdr.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)&combo_strike&chi.deficit>=2&!buff.ordered_elements.up
TigerPalm:Callback("cleave", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- First condition: (energy>55&talent.inner_peace|energy>60&!talent.inner_peace)&combo_strike&chi.max-chi>=2&buff.teachings_of_the_monastery.stack<buff.teachings_of_the_monastery.max_stack&(talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up
    if player.energy > (55 + (5 * player:TalentKnownInt(InnerPeace.id))) and
       gs.comboStrike ~= spell.id and
       player.chiMax - player.chi >= 2 and
       player:HasBuffCount(buffs.teachingsOfTheMonastery) < (4 + (4 * player:TalentKnownInt(KnowledgeOfTheBrokenTemple.id))) and
       (player:TalentKnown(EnergyBurst.id) and not player:Buff(buffs.bokProc) or not player:TalentKnown(EnergyBurst.id)) and
       not player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end

    -- Second condition: (talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up&!cooldown.fists_of_fury.remains&chi<3
    if (player:TalentKnown(EnergyBurst.id) and not player:Buff(buffs.bokProc) or not player:TalentKnown(EnergyBurst.id)) and
       not player:Buff(buffs.orderedElements) and
       FistsOfFury.cd < 700 and
       player.chi < 3 then
        return spell:Cast(target)
    end

    -- Third condition: (prev.strike_of_the_windlord|cooldown.strike_of_the_windlord.remains)&cooldown.celestial_conduit.remains<2&buff.ordered_elements.up&chi<5&combo_strike
    if (gs.comboStrike == StrikeOfTheWindlord.id or StrikeOfTheWindlord.cd > 700) and
       CelestialConduit.cd < 2000 and
       player:Buff(buffs.orderedElements) and
       player.chi < 5 and
       gs.comboStrike ~= spell.id then
        return spell:Cast(target)
    end

    -- Fourth condition: (!buff.heart_of_the_jade_serpent_cdr.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)&combo_strike&chi.deficit>=2&!buff.ordered_elements.up
    if (not player:Buff(buffs.heartOfTheJadeSerpentCdr) or not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)) and
       gs.comboStrike ~= spell.id and
       player.chiDeficit >= 2 and
       not player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/touch_of_death,if=!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up
TouchOfDeath:Callback("cleave", function(spell)
    if not TigerPalm:InRange(target) then return end
    if target.ttd < A.GetToggle(2, "TODSensitivity") * 1000 and not target.isDummy then return end

    -- APL condition: !buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) and not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.stack<2
--actions.default_aoe+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=buff.dance_of_chiji.stack<2
WhirlingDragonPunch:Callback("cleave", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.danceOfChiJi) >= 2 then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast(target)
    end
end)

--actions.default_aoe+=/slicing_winds,if=buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up
SlicingWinds:Callback("cleave", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    if player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[4] then
            Aware:displayMessage("Slicing Winds Soon!", "White", 1)
        end
    
        if player.stayTime > 0.3 then
            return spell:Cast()
        end
    end
end)

--actions.default_cleave+=/celestial_conduit,if=buff.storm_earth_and_fire.up&cooldown.strike_of_the_windlord.remains&(!buff.heart_of_the_jade_serpent_cdr.up|debuff.gale_force.remains<5)&(talent.xuens_bond|!talent.xuens_bond&buff.invokers_delight.up)|fight_remains<15|fight_style.dungeonroute&buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains&buff.storm_earth_and_fire.remains<8
CelestialConduit:Callback("cleave", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end
    
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if not gs.dungeonSlice then
        if gs.fightRemains < 15000 then
            return spell:Cast()
        end
    else
        if player:Buff(buffs.invokersDelight) and StrikeOfTheWindlord.cd < 500 and player:BuffRemains(buffs.stormEarthAndFire) < 8000 then
            return spell:Cast()
        end
    end

    if not player:Buff(buffs.stormEarthAndFire) then return end
    if StrikeOfTheWindlord.cd < 500 then return end

    if (not player:Buff(buffs.heartOfTheJadeSerpentCdr) or target:DebuffRemains(debuffs.galeForce) < 5000) and (player:TalentKnown(XuensBond.id) or not player:TalentKnown(XuensBond.id) and player:Buff(buffs.invokersDelight)) then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/rising_sun_kick,target_if=max:target.time_to_die,if=!pet.xuen_the_white_tiger.active&prev.tiger_palm&time<5|buff.heart_of_the_jade_serpent_cdr_celestial.up&buff.pressure_point.up&cooldown.fists_of_fury.remains&(talent.glory_of_the_dawn|active_enemies<3)
RisingSunKick:Callback("cleave2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if not pet.exists and gs.comboStrike == TigerPalm.id and player.combatTime < 5 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and player:Buff(buffs.pressurePoint) and FistsOfFury.cd > 500 and (not player:TalentKnown(GloryOfTheDawn.id) or gs.activeEnemies < 3) then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/fists_of_fury,target_if=max:target.time_to_die,if=buff.heart_of_the_jade_serpent_cdr_celestial.up
FistsOfFury:Callback("cleave", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then return end

    return spell:Cast()
end)

--actions.default_cleave+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=buff.heart_of_the_jade_serpent_cdr_celestial.up
WhirlingDragonPunch:Callback("cleave2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/strike_of_the_windlord,target_if=max:target.time_to_die,if=talent.gale_force&buff.invokers_delight.up&(buff.bloodlust.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)
StrikeOfTheWindlord:Callback("cleave", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(GaleForce.id) then return end
    if not player:Buff(buffs.invokersDelight) then return end

    if player.bloodlust or not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/fists_of_fury,target_if=max:target.time_to_die,if=buff.power_infusion.up&buff.bloodlust.up
FistsOfFury:Callback("cleave2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player.bloodlust then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

--actions.default_cleave+=/rising_sun_kick,target_if=max:target.time_to_die,if=buff.power_infusion.up&buff.bloodlust.up&active_enemies<3
RisingSunKick:Callback("cleave3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player.bloodlust then return end
    if not player:Buff(buffs.powerInfusion) then return end
    if gs.activeEnemies >= 3 then return end

    return spell:Cast(target)
end)

--actions.default_cleave+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=8&(active_enemies<3|talent.shadowboxing_treads)
BlackoutKick:Callback("cleave", function(spell)
    if not TigerPalm:InRange(target) then return end
    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 8 then return end

    if gs.activeEnemies < 3 or player:TalentKnown(ShadowboxingTreads.id) then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/whirling_dragon_punch,target_if=max:target.time_to_die,if=!talent.revolving_whirl|talent.revolving_whirl&buff.dance_of_chiji.stack<2&active_enemies>2|active_enemies<3
WhirlingDragonPunch:Callback("cleave3", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if gs.activeEnemies > 2 then
        if not player:TalentKnown(RevolvingWhirl.id) or player:TalentKnown(RevolvingWhirl.id) and player:HasBuffCount(buffs.danceOfChiJi) < 2 then
            local makAlert = A.GetToggle(2, "makAware")
            if makAlert[3] then
                Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
            end
        
            if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
                return spell:Cast(target)
            end
        end
    else
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[3] then
            Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
        end
    
        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
            return spell:Cast(target)
        end
    end
end)

--actions.default_cleave+=/strike_of_the_windlord,if=time>5&(cooldown.invoke_xuen_the_white_tiger.remains>15|talent.flurry_strikes)&(cooldown.fists_of_fury.remains<2|cooldown.celestial_conduit.remains<10)
StrikeOfTheWindlord:Callback("cleave2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if player.combatTime < 5 then return end

    if InvokeXuen.cd > 15000 or player:TalentKnown(FlurryStrikes.id) and (FistsOfFury.cd < 2000 or (CelestialConduit.cd < 10000 and player:TalentKnown(CelestialConduit.id) or not shouldBurst())) then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/slicing_winds
SlicingWinds:Callback("cleave2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/crackling_jade_lightning,target_if=max:target.time_to_die,if=buff.the_emperors_capacitor.stack>19&combo_strike&talent.power_of_the_thunder_king&cooldown.invoke_xuen_the_white_tiger.remains>10
CracklingJadeLightning:Callback("cleave", function(spell)
    if player:HasBuffCount(buffs.theEmperorsCapacitor) <= 19 then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(PowerOfTheThunderKing.id) then return end
    if InvokeXuen.cd < 10000 and shouldBurst() then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[2] then
        Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.stack=2
SpinningCraneKick:Callback("cleave3", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) < 2 then return end

    return spell:Cast()
end)

--actions.default_cleave+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5&buff.wisdom_of_the_wall_flurry.up&active_enemies<4
TigerPalm:Callback("cleave2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player:Buff(buffs.wisdomOfTheWallFlurry) then return end
    if gs.activeEnemies >= 4 then return end

    return spell:Cast(target)
end)

--actions.default_cleave+=/fists_of_fury,target_if=max:target.time_to_die,if=(talent.flurry_strikes|talent.xuens_battlegear|!talent.xuens_battlegear&(cooldown.strike_of_the_windlord.remains>1|buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up))&(talent.flurry_strikes|talent.xuens_battlegear&(cooldown.invoke_xuen_the_white_tiger.remains>5&fight_style.patchwerk|cooldown.invoke_xuen_the_white_tiger.remains>9)|cooldown.invoke_xuen_the_white_tiger.remains>10)
FistsOfFury:Callback("cleave3", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if (player:TalentKnown(FlurryStrikes.id) or player:TalentKnown(XuensBattlegear.id) or not player:TalentKnown(XuensBattlegear.id) and (StrikeOfTheWindlord.cd > 1000 or player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial))) and (player:TalentKnown(FlurryStrikes.id) or player:TalentKnown(XuensBattlegear.id) and (InvokeXuen.cd > 5000 and not gs.dungeonSlice or InvokeXuen.cd > 9000) or InvokeXuen.cd > 10000) then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5&buff.wisdom_of_the_wall_flurry.up
TigerPalm:Callback("cleave3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player:Buff(buffs.wisdomOfTheWallFlurry) then return end
    if gs.activeEnemies >= 5 then return end

    return spell:Cast(target)
end)

--actions.default_cleave+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up&buff.chi_energy.stack>29
SpinningCraneKick:Callback("cleave4", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.danceOfChiJi) then return end
    if player:HasBuffCount(buffs.chiEnergy) <= 29 then return end
    
    return spell:Cast()
end)

--actions.default_cleave+=/rising_sun_kick,target_if=max:target.time_to_die,if=chi>4&(active_enemies<3|talent.glory_of_the_dawn)|chi>2&energy>50&(active_enemies<3|talent.glory_of_the_dawn)|cooldown.fists_of_fury.remains>2&(active_enemies<3|talent.glory_of_the_dawn)
RisingSunKick:Callback("cleave4", function(spell)
    if not TigerPalm:InRange(target) then return end

    if gs.activeEnemies < 3 or player:TalentKnown(GloryOfTheDawn.id) then
        if player.chi > 4 or (player.chi > 2 and player.energy > 50) or FistsOfFury.cd > 2000 then
            return spell:Cast(target)
        end
    end
end)

-- actions.default_cleave+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
-- actions.default_cleave+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=4&!talent.knowledge_of_the_broken_temple&talent.shadowboxing_treads&active_enemies<3
BlackoutKick:Callback("cleave2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:TalentKnown(ShadowboxingTreads.id) and player:TalentKnown(CourageousImpulse.id) and gs.comboStrike == spell.id and player:HasBuffCount(buffs.bokProc) >= 2 then
        return spell:Cast(target)
    end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) >= 4 and not player:TalentKnown(KnowledgeOfTheBrokenTemple.id) and player:TalentKnown(ShadowboxingTreads.id) and gs.activeEnemies < 3 then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&buff.dance_of_chiji.up
SpinningCraneKick:Callback("cleave5", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    
    if player:Buff(buffs.danceOfChiJi) then 
        return spell:Cast()
    end
end)

--APL: actions.default_cleave+=/blackout_kick,if=buff.teachings_of_the_monastery.stack=4&!talent.knowledge_of_the_broken_temple&talent.shadowboxing_treads&active_enemies<3
BlackoutKick:Callback("cleave3", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) >= 4 and
       not player:TalentKnown(KnowledgeOfTheBrokenTemple.id) and
       player:TalentKnown(ShadowboxingTreads.id) and
       gs.activeEnemies < 3 then
        return spell:Cast(target)
    end
end)

-- actions.default_cleave+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5
-- actions.default_cleave+=/tiger_palm,if=combo_strike&chi.deficit>=2&(!buff.ordered_elements.up|energy.time_to_max<=gcd.max*3)
TigerPalm:Callback("cleave4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if Player and Player:EnergyTimeToMax() <= A.GetGCD() * 3 and player:TalentKnown(FlurryStrikes.id) then
        return spell:Cast(target)
    end

    if player.chiDeficit >= 2 and (not player:Buff(buffs.orderedElements) or (Player and Player:EnergyTimeToMax() <= A.GetGCD() * 3)) then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&buff.teachings_of_the_monastery.stack>3&cooldown.rising_sun_kick.remains
BlackoutKick:Callback("cleave4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) <= 3 then return end
    if RisingSunKick.cd < 500 then return end

    return spell:Cast(target)
end)

--actions.default_cleave+=/jadefire_stomp,if=talent.Singularly_Focused_Jade|talent.jadefire_harmony
JadefireStomp:Callback("cleave", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    if player:TalentKnown(SingularlyFocusedJade.id) or player:TalentKnown(JadefireHarmony.id) then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(buff.teachings_of_the_monastery.stack>3|buff.ordered_elements.up)&(talent.shadowboxing_treads|buff.bok_proc.up|buff.ordered_elements.up)
BlackoutKick:Callback("cleave5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if (player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 or player:Buff(buffs.orderedElements)) and (player:TalentKnown(ShadowboxingTreads.id) or player:Buff(buffs.bokProc) or player:Buff(buffs.orderedElements)) then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/spinning_crane_kick,target_if=max:target.time_to_die,if=combo_strike&!buff.ordered_elements.up&talent.crane_vortex&active_enemies>2&chi>4
SpinningCraneKick:Callback("cleave6", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end 
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(CraneVortex.id) then return end
    if player.chi <= 4 then return end
    
    return spell:Cast()
end)

--actions.default_cleave+=/chi_burst,if=!buff.ordered_elements.up
ChiBurst:Callback("cleave", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.chiBurst) then return end
    if player:Buff(buffs.orderedElements) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    if not player.moving then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
-- actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("cleave6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:Buff(buffs.orderedElements) or player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id) then
        return spell:Cast(target)
    end

    if player:Buff(buffs.bokProc) or player.chi > 2 or player.energy > 60 then
        return spell:Cast(target)
    end
end)

--actions.default_cleave+=/jadefire_stomp,target_if=max:debuff.acclamation.stack
JadefireStomp:Callback("cleave2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    return spell:Cast()
end)

--actions.default_cleave+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("cleave5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--actions.default_cleave+=/chi_burst
ChiBurst:Callback("cleave2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.chiBurst) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    if not player.moving then
        return spell:Cast()
    end
end)

--actions.default_cleave+=/spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
SpinningCraneKick:Callback("cleave7", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end 
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(HitCombo.id) then return end
    
    return spell:Cast()
end)

--actions.default_cleave+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("cleave7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end
    
    if not player:Buff(buffs.orderedElements) then return end
    if player:TalentKnown(HitCombo.id) then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
BlackoutKick:Callback("cleave7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:Buff(buffs.orderedElements) or
       (player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id)) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("cleave8", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player.chi > 2 or player.energy > 60 or player:Buff(buffs.bokProc) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("cleave9", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player:TalentKnown(HitCombo.id) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("cleave5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
TigerPalm:Callback("cleave6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike ~= spell.id then return end
    if player.chi >= 3 then return end
    if FistsOfFury.cd > 500 then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
TigerPalm:Callback("cleave7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike ~= spell.id then return end
    if player.chi >= 3 then return end
    if FistsOfFury.cd > 500 then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/rising_sun_kick,if=chi>4&(active_enemies<3|talent.glory_of_the_dawn)|chi>2&energy>50&(active_enemies<3|talent.glory_of_the_dawn)|cooldown.fists_of_fury.remains>2&(active_enemies<3|talent.glory_of_the_dawn)
RisingSunKick:Callback("cleave4", function(spell)
    if not TigerPalm:InRange(target) then return end

    if (player.chi > 4 and (gs.activeEnemies < 3 or player:TalentKnown(GloryOfTheDawn.id))) or
       (player.chi > 2 and player.energy > 50 and (gs.activeEnemies < 3 or player:TalentKnown(GloryOfTheDawn.id))) or
       (FistsOfFury.cd > 2000 and (gs.activeEnemies < 3 or player:TalentKnown(GloryOfTheDawn.id))) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
BlackoutKick:Callback("cleave2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.bokProc) < 2 then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.up
BlackoutKick:Callback("cleave4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(ShadowboxingTreads.id) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.bokProc) then return end

    return spell:Cast(target)
end)

--APL: actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&buff.teachings_of_the_monastery.stack>3&cooldown.rising_sun_kick.remains
BlackoutKick:Callback("cleave5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 and RisingSunKick.cd > 500 then
        return spell:Cast(target)
    end
end)

--APL: actions.default_cleave+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(buff.teachings_of_the_monastery.stack>3|buff.ordered_elements.up)&(talent.shadowboxing_treads|buff.bok_proc.up|buff.ordered_elements.up)
BlackoutKick:Callback("cleave6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if (player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 or player:Buff(buffs.orderedElements)) and
       (player:TalentKnown(ShadowboxingTreads.id) or player:Buff(buffs.bokProc) or player:Buff(buffs.orderedElements)) then
        return spell:Cast(target)
    end
end)

local function cleave()
    -- APL Priority Order for 2-4 targets
    SpinningCraneKick("cleave")                    -- spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike
    RisingSunKick("cleave")                        -- rising_sun_kick,if=buff.pressure_point.up&active_enemies<4&cooldown.fists_of_fury.remains>4
                                                   -- rising_sun_kick,if=cooldown.whirling_dragon_punch.remains<2&cooldown.fists_of_fury.remains>1&buff.dance_of_chiji.stack<2
    SpinningCraneKick("cleave2")                   -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.stack=2&active_enemies>3

    -- PHASE 1 OPTIMIZATION: Heart of Jade Serpent Chi Pre-Pooling (Cleave)
    TigerPalm("preHotJSCleave")                    -- tiger_palm,if=hotjs_soon&chi<4&energy>50

    TigerPalm("cleave")                            -- tiger_palm (complex conditions)
    TouchOfDeath("cleave")                         -- touch_of_death,if=!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up
    WhirlingDragonPunch("cleave")                  -- whirling_dragon_punch,if=buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.stack<2
                                                   -- whirling_dragon_punch,if=buff.dance_of_chiji.stack<2
    SlicingWinds("cleave")                         -- slicing_winds,if=buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up
    CelestialConduit("cleave")                     -- celestial_conduit (complex conditions)
    RisingSunKick("cleave2")                       -- rising_sun_kick,if=!pet.xuen_the_white_tiger.active&prev.tiger_palm&time<5|buff.heart_of_the_jade_serpent_cdr_celestial.up&buff.pressure_point.up&cooldown.fists_of_fury.remains&(talent.glory_of_the_dawn|active_enemies<3)
    FistsOfFury("cleave")                          -- fists_of_fury,if=buff.heart_of_the_jade_serpent_cdr_celestial.up
    WhirlingDragonPunch("cleave2")                 -- whirling_dragon_punch,if=buff.heart_of_the_jade_serpent_cdr_celestial.up
    StrikeOfTheWindlord("cleave")                  -- strike_of_the_windlord,if=talent.gale_force&buff.invokers_delight.up&(buff.bloodlust.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)
    FistsOfFury("cleave2")                         -- fists_of_fury,if=buff.power_infusion.up&buff.bloodlust.up
    RisingSunKick("cleave3")                       -- rising_sun_kick,if=buff.power_infusion.up&buff.bloodlust.up&active_enemies<3
    BlackoutKick("cleave")                         -- blackout_kick,if=buff.teachings_of_the_monastery.stack=8&(active_enemies<3|talent.shadowboxing_treads)
    WhirlingDragonPunch("cleave3")                 -- whirling_dragon_punch,if=!talent.revolving_whirl|talent.revolving_whirl&buff.dance_of_chiji.stack<2&active_enemies>2|active_enemies<3
    StrikeOfTheWindlord("cleave2")                 -- strike_of_the_windlord,if=time>5&(cooldown.invoke_xuen_the_white_tiger.remains>15|talent.flurry_strikes)&(cooldown.fists_of_fury.remains<2|cooldown.celestial_conduit.remains<10)
    SlicingWinds("cleave2")                        -- slicing_winds
    CracklingJadeLightning("cleave")               -- crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&combo_strike&talent.power_of_the_thunder_king&cooldown.invoke_xuen_the_white_tiger.remains>10
    SpinningCraneKick("cleave3")                   -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.stack=2
    TigerPalm("cleave2")                           -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5&buff.wisdom_of_the_wall_flurry.up&active_enemies<4
    FistsOfFury("cleave3")                         -- fists_of_fury (complex conditions)
    TigerPalm("cleave3")                           -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5&buff.wisdom_of_the_wall_flurry.up
    SpinningCraneKick("cleave4")                   -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&buff.chi_energy.stack>29
    RisingSunKick("cleave4")                       -- rising_sun_kick,if=chi>4&(active_enemies<3|talent.glory_of_the_dawn)|chi>2&energy>50&(active_enemies<3|talent.glory_of_the_dawn)|cooldown.fists_of_fury.remains>2&(active_enemies<3|talent.glory_of_the_dawn)
    BlackoutKick("cleave2")                        -- blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
    SpinningCraneKick("cleave5")                   -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up
    BlackoutKick("cleave3")                        -- blackout_kick,if=buff.teachings_of_the_monastery.stack=4&!talent.knowledge_of_the_broken_temple&talent.shadowboxing_treads&active_enemies<3
    TigerPalm("cleave4")                           -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&active_enemies<5
    BlackoutKick("cleave4")                        -- blackout_kick,if=talent.shadowboxing_treads&talent.courageous_impulse&combo_strike&buff.bok_proc.up
    JadefireStomp("cleave")                        -- jadefire_stomp,if=talent.Singularly_Focused_Jade|talent.jadefire_harmony
    BlackoutKick("cleave5")                        -- blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&buff.teachings_of_the_monastery.stack>3&cooldown.rising_sun_kick.remains
    SpinningCraneKick("cleave6")                   -- spinning_crane_kick,if=combo_strike&!buff.ordered_elements.up&talent.crane_vortex&active_enemies>2&chi>4
    ChiBurst("cleave")                             -- chi_burst,if=!buff.ordered_elements.up
    BlackoutKick("cleave6")                        -- blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(buff.teachings_of_the_monastery.stack>3|buff.ordered_elements.up)&(talent.shadowboxing_treads|buff.bok_proc.up|buff.ordered_elements.up)
    JadefireStomp("cleave2")                       -- jadefire_stomp,target_if=max:debuff.acclamation.stack
    TigerPalm("cleave5")                           -- tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
    ChiBurst("cleave2")                            -- chi_burst
    SpinningCraneKick("cleave7")                   -- spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
    BlackoutKick("cleave7")                        -- blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
    TigerPalm("cleave6")                           -- tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
    BlackoutKick("cleave8")                        -- blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
    BlackoutKick("cleave9")                        -- blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
    TigerPalm("cleave7")                           -- tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
end

--actions.default_st=fists_of_fury,if=buff.heart_of_the_jade_serpent_cdr_celestial.up|buff.heart_of_the_jade_serpent_cdr.up
FistsOfFury:Callback("st", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if target.physImmune then return end

    if player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/rising_sun_kick,if=buff.pressure_point.up&!buff.heart_of_the_jade_serpent_cdr.up&buff.heart_of_the_jade_serpent_cdr_celestial.up|buff.invokers_delight.up|buff.bloodlust.up|buff.pressure_point.up&cooldown.fists_of_fury.remains|buff.power_infusion.up
RisingSunKick:Callback("st", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- First condition: buff.pressure_point.up&!buff.heart_of_the_jade_serpent_cdr.up&buff.heart_of_the_jade_serpent_cdr_celestial.up
    if player:Buff(buffs.pressurePoint) and not player:Buff(buffs.heartOfTheJadeSerpentCdr) and player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast(target)
    end

    -- Second condition: buff.invokers_delight.up
    if player:Buff(buffs.invokersDelight) then
        return spell:Cast(target)
    end

    -- Third condition: buff.bloodlust.up
    if player.bloodlust then
        return spell:Cast(target)
    end

    -- Fourth condition: buff.pressure_point.up&cooldown.fists_of_fury.remains
    if player:Buff(buffs.pressurePoint) and FistsOfFury.cd > 500 then
        return spell:Cast(target)
    end

    -- Fifth condition: buff.power_infusion.up
    if player:Buff(buffs.powerInfusion) then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/whirling_dragon_punch,if=!buff.heart_of_the_jade_serpent_cdr_celestial.up&!buff.dance_of_chiji.stack=2
WhirlingDragonPunch:Callback("st", function(spell)
    if target.physImmune then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then return end
    if player:HasBuffCount(buffs.danceOfChiJi) >= 2 then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/slicing_winds,if=buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up
SlicingWinds:Callback("st", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end

    -- TWW Season 3 optimization: Enhanced Slicing Winds for Celestial Conduit set bonus
    local hasHeartOfJadeSerpent = player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)
    local celestialConduitSetBonus = player:TalentKnown(CelestialConduit.id) -- Check for Celestial Conduit hero talent

    -- Priority casting during Heart of Jade Serpent for set bonus synergy
    if hasHeartOfJadeSerpent then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[4] then
            Aware:displayMessage("Slicing Winds - Set Bonus Active!", "Green", 1)
        end

        if player.stayTime > 0.3 then
            return spell:Cast()
        end
    end

    -- Additional condition for Celestial Conduit set bonus optimization
    -- Cast Slicing Winds to trigger Heart of Jade Serpent for 4 seconds at 100% effectiveness
    if celestialConduitSetBonus and not hasHeartOfJadeSerpent and player.energy > 80 and player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/celestial_conduit,if=buff.storm_earth_and_fire.up&(!buff.heart_of_the_jade_serpent_cdr.up|debuff.gale_force.remains<5)&cooldown.strike_of_the_windlord.remains&(talent.xuens_bond|!talent.xuens_bond&buff.invokers_delight.up)|fight_remains<15|fight_style.dungeonroute&buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains&buff.storm_earth_and_fire.remains<8|fight_remains<10
CelestialConduit:Callback("st", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[3] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    -- First condition: buff.storm_earth_and_fire.up&(!buff.heart_of_the_jade_serpent_cdr.up|debuff.gale_force.remains<5)&cooldown.strike_of_the_windlord.remains&(talent.xuens_bond|!talent.xuens_bond&buff.invokers_delight.up)
    if player:Buff(buffs.stormEarthAndFire) and
       (not player:Buff(buffs.heartOfTheJadeSerpentCdr) or target:DebuffRemains(debuffs.galeForce) < 5000) and
       StrikeOfTheWindlord.cd > 500 and
       (player:TalentKnown(XuensBond.id) or not player:TalentKnown(XuensBond.id) and player:Buff(buffs.invokersDelight)) then
        return spell:Cast()
    end

    -- Second condition: fight_remains<15
    if gs.fightRemains < 15000 then
        return spell:Cast()
    end

    -- Third condition: fight_style.dungeonroute&buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains&buff.storm_earth_and_fire.remains<8
    if gs.dungeonSlice and player:Buff(buffs.invokersDelight) and StrikeOfTheWindlord.cd > 500 and player:BuffRemains(buffs.stormEarthAndFire) < 8000 then
        return spell:Cast()
    end

    -- Fourth condition: fight_remains<10
    if gs.fightRemains < 10000 then
        return spell:Cast()
    end
end)

--actions.default_st+=/spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike
SpinningCraneKick:Callback("st", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) < 2 then return end

    return spell:Cast()
end)

-- PHASE 1 OPTIMIZATION: Heart of Jade Serpent Chi Pre-Pooling
-- This callback ensures the player enters Heart of Jade Serpent CDR windows with 4+ Chi
-- Expected gain: 2-3% burst window damage by allowing 4-5 abilities during the 4-second window
-- Priority: HIGH (placed before Strike of the Windlord and Celestial Conduit)
TigerPalm:Callback("preHotJS", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    -- Only pool Chi when Heart of Jade Serpent trigger abilities are coming soon
    if not gs.hotJSSoon then return end

    -- Don't pool if already in Heart of Jade Serpent window (would waste the window)
    if gs.heartOfJadeSerpentActive then return end

    -- Pool Chi to 4+ before Strike of the Windlord or Celestial Conduit
    -- This allows immediate high-value spender chain: FoF → RSK → WDP → BoK
    if player.chi < 4 and player.energy > 50 then
        return spell:Cast(target)
    end

    -- Also pool if Chi is very low (< 3) even with less energy
    -- This prevents entering HotJS window with insufficient Chi
    if player.chi < 3 and player.energy > 40 and player.chiDeficit >= 2 then
        return spell:Cast(target)
    end
end)

-- actions.default_st+=/tiger_palm,target_if=min:debuff.mark_of_the_crane.remains,if=(energy>55&talent.inner_peace|energy>60&!talent.inner_peace)&combo_strike&chi.max-chi>=2&buff.teachings_of_the_monastery.stack<buff.teachings_of_the_monastery.max_stack&(talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up|(talent.energy_burst&!buff.bok_proc.up|!talent.energy_burst)&!buff.ordered_elements.up&!cooldown.fists_of_fury.remains&chi<3|(prev.strike_of_the_windlord|!buff.heart_of_the_jade_serpent_cdr_celestial.up)&combo_strike&chi.deficit>=2&!buff.ordered_elements.up
TigerPalm:Callback("st", function(spell)
    if not TigerPalm:InRange(target) then return end

    -- TWW Season 3 optimization: Enhanced Tiger Palm priority with set bonus considerations
    local energyThreshold = 60 - (5 * player:TalentKnownInt(InnerPeace.id))
    local maxTeachingsStacks = 4 + (4 * player:TalentKnownInt(KnowledgeOfTheBrokenTemple.id))

    -- Shado-Pan set bonus optimization: Prioritize Tiger Palm for Chi generation during SEF
    local shadoPanSetBonus = player:Buff(buffs.flurryStrikes)
    local duringStormEarthFire = player:Buff(buffs.stormEarthAndFire)

    -- Enhanced priority during Storm, Earth, and Fire with Shado-Pan set
    if duringStormEarthFire and shadoPanSetBonus and gs.comboStrike ~= spell.id and player.chi < 5 then
        return spell:Cast(target)
    end

    -- Standard energy and resource conditions with set bonus awareness
    if player.energy > energyThreshold and gs.comboStrike ~= spell.id and player.chiMax - player.chi >= 2 and
       player:HasBuffCount(buffs.teachingsOfTheMonastery) < maxTeachingsStacks and not player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end

    -- Energy Burst synergy with enhanced priority
    if player:TalentKnown(EnergyBurst.id) and not player:Buff(buffs.bokProc) and not player:Buff(buffs.orderedElements) and
       FistsOfFury.cd < 300 and player.chi < 3 then
        return spell:Cast(target)
    end

    -- Strike of the Windlord combo strike synergy
    if gs.comboStrike == StrikeOfTheWindlord.id then
        return spell:Cast(target)
    end

    -- Heart of Jade Serpent optimization with enhanced conditions
    if (not player:Buff(buffs.heartOfTheJadeSerpentCdr) or not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)) and
       gs.comboStrike ~= spell.id and player.chiDeficit >= 2 and not player:Buff(buffs.orderedElements) then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/touch_of_death
TouchOfDeath:Callback("st", function(spell)
    if not TigerPalm:InRange(target) then return end
    if ActionUnit("target"):TimeToDie() < A.GetToggle(2, "TODSensitivity") then return end
    if Action.IsInPvP and not target.player then return end

    return spell:Cast(target)
end)

-- actions.default_st+=/rising_sun_kick,if=!pet.xuen_the_white_tiger.active&prev.tiger_palm&time<5|buff.storm_earth_and_fire.up&talent.ordered_elements
RisingSunKick:Callback("st2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if not pet.exists and gs.comboStrike == TigerPalm.id and player.combatTime < 5 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.stormEarthAndFire) and player:TalentKnown(OrderedElements.id) then
        return spell:Cast(target)
    end
end)

-- actions.default_st+=/strike_of_the_windlord,if=talent.celestial_conduit&!buff.invokers_delight.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&cooldown.fists_of_fury.remains<5&cooldown.invoke_xuen_the_white_tiger.remains>15|fight_remains<12
-- actions.default_st+=/strike_of_the_windlord,if=talent.gale_force&buff.invokers_delight.up&(buff.bloodlust.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)
-- actions.default_st+=/strike_of_the_windlord,if=time>5&talent.flurry_strikes
StrikeOfTheWindlord:Callback("st", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if target.physImmune then return end

    if player:TalentKnown(CelestialConduit.id) and not player:Buff(buffs.invokersDelight) and not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and FistsOfFury.cd < 5000 and InvokeXuen.cd > 15000 or gs.fightRemains < 12000 and not gs.dungeonSlice or not shouldBurst() then
        return spell:Cast()
    end

    if player:TalentKnown(GaleForce.id) and player:Buff(buffs.invokersDelight) and (player.bloodlust or not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)) then
        return spell:Cast()
    end

    if player.combatTime > 5 and player:TalentKnown(FlurryStrikes.id) then
        return spell:Cast()
    end
end)

--actions.default_st+=/fists_of_fury,if=buff.power_infusion.up&buff.bloodlust.up&time>5
FistsOfFury:Callback("st2", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if player.combatTime < 5 then return end

    if not player.bloodlust then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast()
end)

--actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>3&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 4 then return end
    if not player:Buff(buffs.orderedElements) then return end
    if RisingSunKick.cd < 1000 then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 2000 then return end
    end

    return spell:Cast(target)
end)

--actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.power_infusion.up&buff.bloodlust.up
TigerPalm:Callback("st2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3000 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player.bloodlust then return end
    if not player:Buff(buffs.powerInfusion) then return end

    return spell:Cast(target)
end)

--actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>4&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 4 then return end
    if RisingSunKick.cd < 1000 then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 2000 then return end
    end

    return spell:Cast(target)
end)

--actions.default_st+=/whirling_dragon_punch,if=!buff.heart_of_the_jade_serpent_cdr_celestial.up&!buff.dance_of_chiji.stack=2|buff.ordered_elements.up|talent.knowledge_of_the_broken_temple
WhirlingDragonPunch:Callback("st2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    
    if not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and player:HasBuffCount(buffs.danceOfChiJi) >= 2 then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[3] then
            Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
        end
    
        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
            return spell:Cast(target)
        end
    end

    if player:Buff(buffs.orderedElements) or player:TalentKnown(KnowledgeOfTheBrokenTemple.id) then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[3] then
            Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
        end
    
        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 then
            return spell:Cast(target)
        end
    end
end)

--actions.default_st+=/crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&combo_strike&(!fight_style.dungeonslice|target.time_to_die>20)&cooldown.invoke_xuen_the_white_tiger.remains>10
CracklingJadeLightning:Callback("st", function(spell)
    if player:HasBuffCount(buffs.theEmperorsCapacitor) <= 19 then return end
    if player:Buff(buffs.heartOfTheJadeSerpentCdr) then return end
    if player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then return end
    if gs.comboStrike == spell.id then return end
    if InvokeXuen.cd < 10000 and shouldBurst() then return end

    if not gs.dungeonSlice or target.ttd > 20000 or target.isDummy then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[2] then
            Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
        end
    
        if player.stayTime > 0.3 then
            return spell:Cast(target)
        end
    end
end)

--splitting into two because an APL addition later made this annoying to add.
--buff.the_emperors_capacitor.stack>15&!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&combo_strike&(!fight_style.dungeonslice|target.time_to_die>20)&cooldown.invoke_xuen_the_white_tiger.remains<10&cooldown.invoke_xuen_the_white_tiger.remains>2
CracklingJadeLightning:Callback("st2", function(spell)
    if player:HasBuffCount(buffs.theEmperorsCapacitor) <= 15 then return end
    if player:Buff(buffs.heartOfTheJadeSerpentCdr) then return end
    if player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then return end
    if gs.comboStrike == spell.id then return end
    if InvokeXuen.cd > 10000 and shouldBurst() then return end
    if InvokeXuen.cd < 2000 and shouldBurst() then return end

    if not gs.dungeonSlice or target.ttd > 20000 or target.isDummy then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[2] then
            Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
        end
    
        if player.stayTime > 0.3 then
            return spell:Cast(target)
        end
    end
end)

--actions.default_st+=/slicing_winds
SlicingWinds:Callback("st2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end
    if target.ttd < 10000 then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--actions.default_st+=/fists_of_fury,if=(talent.xuens_battlegear|!talent.xuens_battlegear&(cooldown.strike_of_the_windlord.remains>1|buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up))&(talent.xuens_battlegear&cooldown.invoke_xuen_the_white_tiger.remains>5|cooldown.invoke_xuen_the_white_tiger.remains>10)&(!buff.invokers_delight.up|buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains>4&cooldown.celestial_conduit.remains)|fight_remains<5|talent.flurry_strikes
FistsOfFury:Callback("st3", function(spell)
    if not shouldBurst() then 
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if target.physImmune then return end

    if (player:TalentKnown(XuensBattlegear.id) or not player:TalentKnown(XuensBattlegear.id) and (StrikeOfTheWindlord.cd > 1000 or player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial))) and (player:TalentKnown(XuensBattlegear.id) and InvokeXuen.cd > 5000 or InvokeXuen.cd > 10000 or not shouldBurst()) then
        return spell:Cast()
    end

    if player:TalentKnown(FlurryStrikes.id) then
        return spell:Cast()
    end
end)

--actions.default_st+=/rising_sun_kick,if=chi>4|chi>2&energy>50|cooldown.fists_of_fury.remains>2
RisingSunKick:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player.chi > 4 or (player.chi > 2 and player.energy > 50) or FistsOfFury.cd > 2000 then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.wisdom_of_the_wall_flurry.up
TigerPalm:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end

    if player:TalentKnown(FlurryStrikes.id) and player:Buff(buffs.wisdomOfTheWallFlurry) or player.chiDeficit >= 2 then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/blackout_kick,if=combo_strike&talent.energy_burst&buff.bok_proc.up&chi<5&(buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up)
BlackoutKick:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(EnergyBurst.id) then return end
    if not player:Buff(buffs.bokProc) then return end
    if player.chi >= 5 then return end

    if player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast(target)
    end
end)


--actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.bloodlust.up&buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.up
SpinningCraneKick:Callback("st2", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player.bloodlust then return end
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) then return end
    if not player:Buff(buffs.danceOfChiJi) then return end

    return spell:Cast()
end)

-- actions.default_st+=/tiger_palm,if=combo_strike&chi.deficit>=2&energy.time_to_max<=gcd.max*3
TigerPalm:Callback("st4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end

    return spell:Cast(target)
end)

--actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>7&talent.memory_of_the_monastery&!buff.memory_of_the_monastery.up&cooldown.fists_of_fury.remains
BlackoutKick:Callback("st4", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) < 7 then return end
    if not player:TalentKnown(MemoryOfTheMonastery.id) then return end
    if not player:Buff(buffs.memoryOfTheMonastery) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    return spell:Cast(target)
end)

--actions.default_st+=/spinning_crane_kick,if=(buff.dance_of_chiji.stack=2|buff.dance_of_chiji.remains<2&buff.dance_of_chiji.up)&combo_strike&!buff.ordered_elements.up
SpinningCraneKick:Callback("st3", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:Buff(buffs.orderedElements) then return end

    if player:HasBuffCount(buffs.danceOfChiJi) >= 2 or player:BuffRemains(buffs.danceOfChiJi) < 2000 and player:Buff(buffs.danceOfChiJi) then
        return spell:Cast()
    end
end)

--actions.default_st+=/whirling_dragon_punch
WhirlingDragonPunch:Callback("st3", function(spell)
    if target.physImmune then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[3] then
        Aware:displayMessage("Whirling Dragon Punch Soon!", "White", 1)
    end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike
SpinningCraneKick:Callback("st4", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) < 2 then return end

    return spell:Cast()
end)

--actions.default_st+=/blackout_kick,if=talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
-- actions.default_st+=/blackout_kick,if=combo_strike&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if player:TalentKnown(CourageousImpulse.id) and player:HasBuffCount(buffs.bokProc) >= 2 then
        return spell:Cast(target)
    end

    if player:Buff(buffs.orderedElements) and RisingSunKick.cd > 1000 and FistsOfFury.cd > 2000 then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes
TigerPalm:Callback("st5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not Player or Player:EnergyTimeToMax() > A.GetGCD() * 3 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end

    return spell:Cast(target)
end)

--actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&(buff.ordered_elements.up|energy.time_to_max>=gcd.max*3&talent.sequenced_strikes&talent.energy_burst|!talent.sequenced_strikes|!talent.energy_burst|buff.dance_of_chiji.remains<=gcd.max*3)
SpinningCraneKick:Callback("st5", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.danceOfChiJi) then return end

    if player:Buff(buffs.orderedElements) or (Player and Player:EnergyTimeToMax() > A.GetGCD() * 3 and player:TalentKnown(SequencedStrikes.id) and player:TalentKnown(EnergyBurst.id)) or not player:TalentKnown(SequencedStrikes.id) or not player:TalentKnown(EnergyBurst.id) or player:BuffRemains(buffs.danceOfChiJi) <= A.GetGCD() * 3000 then
        return spell:Cast()
    end
end)

--actions.default_st+=/jadefire_stomp,if=talent.Singularly_Focused_Jade|talent.jadefire_harmony
JadefireStomp:Callback("st", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    if player:TalentKnown(SingularlyFocusedJade.id) or player:TalentKnown(JadefireHarmony.id) then
        return spell:Cast()
    end
end)

--actions.default_st+=/chi_burst,if=!buff.ordered_elements.up
ChiBurst:Callback("st", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.chiBurst) then return end
    if player:Buff(buffs.orderedElements) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    if not player.moving then
        return spell:Cast()
    end
end)

--actions.default_st+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
-- actions.default_st+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("st6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    
    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if player:Buff(buffs.orderedElements) or player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id) then
        return spell:Cast(target)
    end

    if player.chi > 2 or player.energy > 60 or player:Buff(buffs.bokProc) then
        return spell:Cast(target)
    end
end)

--actions.default_st+=/jadefire_stomp
JadefireStomp:Callback("st2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if A.GetToggle(2, "stompStaying") and player.moving then return end

    return spell:Cast()
end)

--actions.default_st+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("st6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end

    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--actions.default_st+=/chi_burst
ChiBurst:Callback("st2", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.chiBurst) then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[1] then
        Aware:displayMessage("Chi Burst Soon!", "Purple", 1)
    end

    if not player.moving then
        return spell:Cast()
    end
end)

--actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
SpinningCraneKick:Callback("st6", function(spell)
    if target.distance > 5 or not TigerPalm:InRange(target) then return end
    if target.physImmune then return end
    if not player:TalentKnown(HitCombo.id) then return end
    if not player:Buff(buffs.orderedElements) then return end

    return spell:Cast()
end)

--actions.default_st+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("st7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if player:TalentKnown(HitCombo.id) then return end

    local cooldownUsage = A.GetToggle(2, "cooldownUsage")
    if shouldBurst() or not cooldownUsage[4] then
        if FistsOfFury.cd < 500 then return end
    end

    if not player:Buff(buffs.orderedElements) then return end

    return spell:Cast(target)
end)

--actions.default_st+=/tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
TigerPalm:Callback("st7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike ~= spell.id then return end
    if player.chi >= 3 then return end
    if FistsOfFury.cd > 300 then return end

    return spell:Cast(target)
end)

Vivify:Callback("selfPanic", function(spell)
    if not player:Buff(buffs.vivaciousVivification) then return end

    if player.hp > 90 then return end
    if healer.exists and not healer.cc then
        if player.hp > 40 then return end
    end

    return Debounce("VIVIFYSELFPANIC", 500, 2500, spell, player)
end)

Vivify:Callback("topSelf", function(spell)
    if not player:Buff(buffs.vivaciousVivification) then return end
    if player.hp > 80 then return end

    return Debounce("VIVIFYTOPSELF", 500, 2500, spell, player)
end)

local function st()
    -- TWW Season 3 Optimized Single Target Priority (patch 11.2)
    -- Prioritized for maximum theoretical DPS with set bonus considerations

    -- Highest priority: Fists of Fury with Heart of Jade Serpent synergy
    FistsOfFury("st")                              -- fists_of_fury,if=buff.heart_of_the_jade_serpent_cdr_celestial.up|buff.heart_of_the_jade_serpent_cdr.up

    -- Rising Sun Kick with enhanced priority for current patch
    RisingSunKick("st")                            -- rising_sun_kick,if=buff.pressure_point.up&!buff.heart_of_the_jade_serpent_cdr.up&buff.heart_of_the_jade_serpent_cdr_celestial.up|buff.invokers_delight.up|buff.bloodlust.up|buff.pressure_point.up&cooldown.fists_of_fury.remains|buff.power_infusion.up

    -- Whirling Dragon Punch optimization
    WhirlingDragonPunch("st")                      -- whirling_dragon_punch,if=!buff.heart_of_the_jade_serpent_cdr_celestial.up&!buff.dance_of_chiji.stack=2

    -- Slicing Winds for Celestial Conduit set bonus synergy
    SlicingWinds("st")                             -- slicing_winds,if=buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up

    -- Celestial Conduit with enhanced priority
    CelestialConduit("st")                         -- celestial_conduit (complex conditions)

    -- Spinning Crane Kick for Dance of Chi-Ji stacks
    SpinningCraneKick("st")                        -- spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike

    -- PHASE 1 OPTIMIZATION: Heart of Jade Serpent Chi Pre-Pooling
    -- Pool Chi before Strike of the Windlord or Celestial Conduit to maximize HotJS window
    TigerPalm("preHotJS")                          -- tiger_palm,if=hotjs_soon&chi<4&energy>50

    -- Tiger Palm resource management with set bonus considerations
    TigerPalm("st")                                -- tiger_palm (complex conditions)

    -- Touch of Death execute priority
    TouchOfDeath("st")                             -- touch_of_death

    -- Secondary Rising Sun Kick conditions
    RisingSunKick("st2")                           -- rising_sun_kick,if=!pet.xuen_the_white_tiger.active&prev.tiger_palm&time<5|buff.storm_earth_and_fire.up&talent.ordered_elements

    -- Strike of the Windlord priority chain
    StrikeOfTheWindlord("st")                      -- strike_of_the_windlord (multiple conditions)
    StrikeOfTheWindlord("st2")                     -- strike_of_the_windlord,if=talent.gale_force&buff.invokers_delight.up&(buff.bloodlust.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)
    StrikeOfTheWindlord("st3")                     -- strike_of_the_windlord,if=time>5&talent.flurry_strikes

    -- Secondary Fists of Fury with burst conditions
    FistsOfFury("st2")                             -- fists_of_fury,if=buff.power_infusion.up&buff.bloodlust.up&time>5

    -- Blackout Kick optimization for Teachings stacks
    BlackoutKick("st")                             -- blackout_kick,if=buff.teachings_of_the_monastery.stack>3&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2

    -- Enhanced Tiger Palm for Flurry Strikes synergy
    TigerPalm("st2")                               -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.power_infusion.up&buff.bloodlust.up

    -- Additional Blackout Kick conditions
    BlackoutKick("st2")                            -- blackout_kick,if=buff.teachings_of_the_monastery.stack>4&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2

    -- Enhanced Whirling Dragon Punch conditions
    WhirlingDragonPunch("st2")                     -- whirling_dragon_punch,if=!buff.heart_of_the_jade_serpent_cdr_celestial.up&!buff.dance_of_chiji.stack=2|buff.ordered_elements.up|talent.knowledge_of_the_broken_temple

    -- Crackling Jade Lightning filler
    CracklingJadeLightning("st")                   -- crackling_jade_lightning (complex conditions)

    -- Secondary Slicing Winds
    SlicingWinds("st2")                            -- slicing_winds,if=target.time_to_die>10

    -- Tertiary Fists of Fury
    FistsOfFury("st3")                             -- fists_of_fury (complex conditions)

    -- Tertiary Rising Sun Kick
    RisingSunKick("st3")                           -- rising_sun_kick,if=chi>4|chi>2&energy>50|cooldown.fists_of_fury.remains>2

    -- Flurry Strikes Tiger Palm synergy
    TigerPalm("st3")                               -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.wisdom_of_the_wall_flurry.up

    -- Energy Burst Blackout Kick
    BlackoutKick("st3")                            -- blackout_kick,if=combo_strike&talent.energy_burst&buff.bok_proc.up&chi<5&(buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up)

    -- Bloodlust Spinning Crane Kick
    SpinningCraneKick("st2")                       -- spinning_crane_kick,if=combo_strike&buff.bloodlust.up&buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.up

    -- Resource management Tiger Palm
    TigerPalm("st4")                               -- tiger_palm,if=combo_strike&chi.deficit>=2&energy.time_to_max<=gcd.max*3

    -- Memory of the Monastery Blackout Kick
    BlackoutKick("st4")                            -- blackout_kick,if=buff.teachings_of_the_monastery.stack>7&talent.memory_of_the_monastery&!buff.memory_of_the_monastery.up&cooldown.fists_of_fury.remains

    -- Dance of Chi-Ji Spinning Crane Kick
    SpinningCraneKick("st3")                       -- spinning_crane_kick,if=(buff.dance_of_chiji.stack=2|buff.dance_of_chiji.remains<2&buff.dance_of_chiji.up)&combo_strike&!buff.ordered_elements.up

    -- Fallback Whirling Dragon Punch
    WhirlingDragonPunch("st3")                     -- whirling_dragon_punch

    -- Final Spinning Crane Kick
    SpinningCraneKick("st4")                       -- spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike

    -- Additional single target rotation priorities
    BlackoutKick("st5")                            -- blackout_kick,if=talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
    BlackoutKick("st6")                            -- blackout_kick,if=combo_strike&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
    TigerPalm("st5")                               -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes
    SpinningCraneKick("st5")                       -- spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&(buff.ordered_elements.up|energy.time_to_max>=gcd.max*3&talent.sequenced_strikes&talent.energy_burst|!talent.sequenced_strikes|!talent.energy_burst|buff.dance_of_chiji.remains<=gcd.max*3)
    TigerPalm("st6")                               -- tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes
    JadefireStomp("st")                            -- jadefire_stomp,if=talent.Singularly_Focused_Jade|talent.jadefire_harmony
    ChiBurst("st")                                 -- chi_burst,if=!buff.ordered_elements.up
    BlackoutKick("st7")                            -- blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
    BlackoutKick("st8")                            -- blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
    JadefireStomp("st2")                           -- jadefire_stomp
    TigerPalm("st7")                               -- tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
    ChiBurst("st2")                                -- chi_burst
    SpinningCraneKick("st6")                       -- spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
    BlackoutKick("st9")                            -- blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
    TigerPalm("st8")                               -- tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains

    -- Keep defensive abilities
    Vivify("selfPanic")
    Vivify("topSelf")
end

--APL: actions.default_st+=/strike_of_the_windlord,if=talent.celestial_conduit&!buff.invokers_delight.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&cooldown.fists_of_fury.remains<5&cooldown.invoke_xuen_the_white_tiger.remains>15|fight_remains<12
StrikeOfTheWindlord:Callback("st", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    -- First condition: talent.celestial_conduit&!buff.invokers_delight.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&cooldown.fists_of_fury.remains<5&cooldown.invoke_xuen_the_white_tiger.remains>15
    if player:TalentKnown(CelestialConduit.id) and
       not player:Buff(buffs.invokersDelight) and
       not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and
       FistsOfFury.cd < 5000 and
       InvokeXuen.cd > 15000 then
        return spell:Cast()
    end

    -- Second condition: fight_remains<12
    if gs.fightRemains < 12000 then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/strike_of_the_windlord,if=talent.gale_force&buff.invokers_delight.up&(buff.bloodlust.up|!buff.heart_of_the_jade_serpent_cdr_celestial.up)
StrikeOfTheWindlord:Callback("st2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(GaleForce.id) then return end
    if not player:Buff(buffs.invokersDelight) then return end

    if player.bloodlust or not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/strike_of_the_windlord,if=time>5&talent.flurry_strikes
StrikeOfTheWindlord:Callback("st3", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if player.combatTime <= 5 then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end

    return spell:Cast()
end)

--APL: actions.default_st+=/fists_of_fury,if=buff.power_infusion.up&buff.bloodlust.up&time>5
FistsOfFury:Callback("st2", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.powerInfusion) then return end
    if not player.bloodlust then return end
    if player.combatTime <= 5 then return end

    return spell:Cast()
end)

--APL: actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>3&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) > 3 and
       player:Buff(buffs.orderedElements) and
       RisingSunKick.cd > 1000 and
       FistsOfFury.cd > 2000 then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>4&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st2", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player:HasBuffCount(buffs.teachingsOfTheMonastery) > 4 and
       RisingSunKick.cd > 1000 and
       FistsOfFury.cd > 2000 then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/crackling_jade_lightning,if=buff.the_emperors_capacitor.stack>19&!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&combo_strike&(!fight_style.dungeonslice|target.time_to_die>20)&cooldown.invoke_xuen_the_white_tiger.remains>10|buff.the_emperors_capacitor.stack>15&!buff.heart_of_the_jade_serpent_cdr.up&!buff.heart_of_the_jade_serpent_cdr_celestial.up&combo_strike&(!fight_style.dungeonslice|target.time_to_die>20)&cooldown.invoke_xuen_the_white_tiger.remains<10&cooldown.invoke_xuen_the_white_tiger.remains>2
CracklingJadeLightning:Callback("st", function(spell)
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) and not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and gs.comboStrike ~= spell.id then
        -- First condition: buff.the_emperors_capacitor.stack>19&cooldown.invoke_xuen_the_white_tiger.remains>10
        if player:HasBuffCount(buffs.theEmperorsCapacitor) > 19 and
           (not gs.dungeonSlice or target.ttd > 20000 or target.isDummy) and
           InvokeXuen.cd > 10000 then
            local makAlert = A.GetToggle(2, "makAware")
            if makAlert[2] then
                Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
            end
            if player.stayTime > 0.3 then
                return spell:Cast(target)
            end
        end

        -- Second condition: buff.the_emperors_capacitor.stack>15&cooldown.invoke_xuen_the_white_tiger.remains<10&cooldown.invoke_xuen_the_white_tiger.remains>2
        if player:HasBuffCount(buffs.theEmperorsCapacitor) > 15 and
           (not gs.dungeonSlice or target.ttd > 20000 or target.isDummy) and
           InvokeXuen.cd < 10000 and InvokeXuen.cd > 2000 then
            local makAlert = A.GetToggle(2, "makAware")
            if makAlert[2] then
                Aware:displayMessage("Crackling Jade Lightning Soon!", "Green", 1)
            end
            if player.stayTime > 0.3 then
                return spell:Cast(target)
            end
        end
    end
end)

--APL: actions.default_st+=/slicing_winds,if=target.time_to_die>10
SlicingWinds:Callback("st2", function(spell)
    if target.distance > 5 and not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(SlicingWinds.id) then return end
    if target.ttd <= 10000 and not target.isDummy then return end

    local makAlert = A.GetToggle(2, "makAware")
    if makAlert[4] then
        Aware:displayMessage("Slicing Winds Soon!", "White", 1)
    end

    if player.stayTime > 0.3 then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/fists_of_fury,if=(talent.xuens_battlegear|!talent.xuens_battlegear&(cooldown.strike_of_the_windlord.remains>1|buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up))&(talent.xuens_battlegear&cooldown.invoke_xuen_the_white_tiger.remains>5|cooldown.invoke_xuen_the_white_tiger.remains>10)&(!buff.invokers_delight.up|buff.invokers_delight.up&cooldown.strike_of_the_windlord.remains>4&cooldown.celestial_conduit.remains)|fight_remains<5|talent.flurry_strikes
FistsOfFury:Callback("st3", function(spell)
    if not shouldBurst() then
        local cooldownUsage = A.GetToggle(2, "cooldownUsage")
        if cooldownUsage[4] then return end
    end

    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    -- Complex condition from APL
    local condition1 = player:TalentKnown(XuensBattlegear.id) or
                      (not player:TalentKnown(XuensBattlegear.id) and
                       (StrikeOfTheWindlord.cd > 1000 or player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)))

    local condition2 = (player:TalentKnown(XuensBattlegear.id) and InvokeXuen.cd > 5000) or InvokeXuen.cd > 10000

    local condition3 = (not player:Buff(buffs.invokersDelight)) or
                      (player:Buff(buffs.invokersDelight) and StrikeOfTheWindlord.cd > 4000 and CelestialConduit.cd > 500)

    if (condition1 and condition2 and condition3) or gs.fightRemains < 5000 or player:TalentKnown(FlurryStrikes.id) then
        return spell:Cast()
    end
end)

--APL: actions.default_st+=/rising_sun_kick,if=chi>4|chi>2&energy>50|cooldown.fists_of_fury.remains>2
RisingSunKick:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end

    if player.chi > 4 or
       (player.chi > 2 and player.energy > 50) or
       FistsOfFury.cd > 2000 then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes&buff.wisdom_of_the_wall_flurry.up
TigerPalm:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not player:Buff(buffs.wisdomOfTheWallFlurry) then return end
    if not Player or Player:EnergyTimeToMax() > (MakuluFramework.gcd() * 3) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=combo_strike&talent.energy_burst&buff.bok_proc.up&chi<5&(buff.heart_of_the_jade_serpent_cdr.up|buff.heart_of_the_jade_serpent_cdr_celestial.up)
BlackoutKick:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(EnergyBurst.id) then return end
    if not player:Buff(buffs.bokProc) then return end
    if player.chi >= 5 then return end
    if not (player:Buff(buffs.heartOfTheJadeSerpentCdr) or player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial)) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.bloodlust.up&buff.heart_of_the_jade_serpent_cdr.up&buff.dance_of_chiji.up
SpinningCraneKick:Callback("st2", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player.bloodlust then return end
    if not player:Buff(buffs.heartOfTheJadeSerpentCdr) then return end
    if not player:Buff(buffs.danceOfChiJi) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/tiger_palm,if=combo_strike&chi.deficit>=2&energy.time_to_max<=gcd.max*3
TigerPalm:Callback("st4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player.chiDeficit < 2 then return end
    if not Player or Player:EnergyTimeToMax() > (MakuluFramework.gcd() * 3) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=buff.teachings_of_the_monastery.stack>7&talent.memory_of_the_monastery&!buff.memory_of_the_monastery.up&cooldown.fists_of_fury.remains
BlackoutKick:Callback("st4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if player:HasBuffCount(buffs.teachingsOfTheMonastery) <= 7 then return end
    if not player:TalentKnown(MemoryOfTheMonastery.id) then return end
    if player:Buff(buffs.memoryOfTheMonastery) then return end
    if FistsOfFury.cd < 500 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/spinning_crane_kick,if=(buff.dance_of_chiji.stack=2|buff.dance_of_chiji.remains<2&buff.dance_of_chiji.up)&combo_strike&!buff.ordered_elements.up
SpinningCraneKick:Callback("st3", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player:Buff(buffs.orderedElements) then return end

    if player:HasBuffCount(buffs.danceOfChiJi) == 2 or
       (player:BuffRemains(buffs.danceOfChiJi) < 2000 and player:Buff(buffs.danceOfChiJi)) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/whirling_dragon_punch,if=!buff.heart_of_the_jade_serpent_cdr_celestial.up&!buff.dance_of_chiji.stack=2|buff.ordered_elements.up|talent.knowledge_of_the_broken_temple
WhirlingDragonPunch:Callback("st2", function(spell)
    if target.physImmune then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if (not player:Buff(buffs.heartOfTheJadeSerpentCdrCelestial) and player:HasBuffCount(buffs.danceOfChiJi) ~= 2) or
       player:Buff(buffs.orderedElements) or
       player:TalentKnown(KnowledgeOfTheBrokenTemple.id) then

        if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
            return spell:Cast(target)
        end
    end
end)

--APL: actions.default_st+=/whirling_dragon_punch
WhirlingDragonPunch:Callback("st3", function(spell)
    if target.physImmune then return end
    if target.distance > 5 and not TigerPalm:InRange(target) then return end

    if A.GetToggle(2, "wdpStaying") and player.stayTime > 0.3 or not A.GetToggle(2, "wdpStaying") then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/spinning_crane_kick,if=buff.dance_of_chiji.stack=2&combo_strike
SpinningCraneKick:Callback("st4", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.danceOfChiJi) ~= 2 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=talent.courageous_impulse&combo_strike&buff.bok_proc.stack=2
BlackoutKick:Callback("st5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(CourageousImpulse.id) then return end
    if gs.comboStrike == spell.id then return end
    if player:HasBuffCount(buffs.bokProc) ~= 2 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=combo_strike&buff.ordered_elements.up&cooldown.rising_sun_kick.remains>1&cooldown.fists_of_fury.remains>2
BlackoutKick:Callback("st6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if RisingSunKick.cd <= 1000 then return end
    if FistsOfFury.cd <= 2000 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes
TigerPalm:Callback("st5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not Player or Player:EnergyTimeToMax() > (MakuluFramework.gcd() * 3) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.dance_of_chiji.up&(buff.ordered_elements.up|energy.time_to_max>=gcd.max*3&talent.sequenced_strikes&talent.energy_burst|!talent.sequenced_strikes|!talent.energy_burst|buff.dance_of_chiji.remains<=gcd.max*3)
SpinningCraneKick:Callback("st5", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.danceOfChiJi) then return end

    if player:Buff(buffs.orderedElements) or
       (Player and Player:EnergyTimeToMax() >= (MakuluFramework.gcd() * 3) and player:TalentKnown(SequencedStrikes.id) and player:TalentKnown(EnergyBurst.id)) or
       not player:TalentKnown(SequencedStrikes.id) or
       not player:TalentKnown(EnergyBurst.id) or
       player:BuffRemains(buffs.danceOfChiJi) <= (MakuluFramework.gcd() * 3) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/tiger_palm,if=combo_strike&energy.time_to_max<=gcd.max*3&talent.flurry_strikes (duplicate)
TigerPalm:Callback("st6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:TalentKnown(FlurryStrikes.id) then return end
    if not Player or Player:EnergyTimeToMax() > (MakuluFramework.gcd() * 3) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=combo_strike&(buff.ordered_elements.up|buff.bok_proc.up&chi.deficit>=1&talent.energy_burst)&cooldown.fists_of_fury.remains
BlackoutKick:Callback("st7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if FistsOfFury.cd < 500 then return end

    if player:Buff(buffs.orderedElements) or
       (player:Buff(buffs.bokProc) and player.chiDeficit >= 1 and player:TalentKnown(EnergyBurst.id)) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/blackout_kick,if=combo_strike&cooldown.fists_of_fury.remains&(chi>2|energy>60|buff.bok_proc.up)
BlackoutKick:Callback("st8", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if FistsOfFury.cd < 500 then return end

    if player.chi > 2 or player.energy > 60 or player:Buff(buffs.bokProc) then
        return spell:Cast(target)
    end
end)

--APL: actions.default_st+=/tiger_palm,if=combo_strike&buff.ordered_elements.up&chi.deficit>=1
TigerPalm:Callback("st7", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player.chiDeficit < 1 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/spinning_crane_kick,if=combo_strike&buff.ordered_elements.up&talent.hit_combo
SpinningCraneKick:Callback("st6", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if not player:Buff(buffs.orderedElements) then return end
    if not player:TalentKnown(HitCombo.id) then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/blackout_kick,if=buff.ordered_elements.up&!talent.hit_combo&cooldown.fists_of_fury.remains
BlackoutKick:Callback("st9", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:Buff(buffs.orderedElements) then return end
    if player:TalentKnown(HitCombo.id) then return end
    if FistsOfFury.cd < 500 then return end

    return spell:Cast(target)
end)

--APL: actions.default_st+=/tiger_palm,if=prev.tiger_palm&chi<3&!cooldown.fists_of_fury.remains
TigerPalm:Callback("st8", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike ~= spell.id then return end
    if player.chi >= 3 then return end
    if FistsOfFury.cd > 500 then return end

    return spell:Cast(target)
end)

CelestialConduitCancel:Callback(function(spell)
    local casting = player.channelInfo
    if not casting then return end

    if casting.spellId == CelestialConduit.id and casting.remaining < 1000 then
        return spell:Cast()
    end
end)

TigerPalm:Callback("opener", function(spell)
    if not TigerPalm:InRange(target) then return end
    if gs.comboStrike == spell.id then return end
    if player.chi >= 6 then return end

    return spell:Cast(target)
end)

RisingSunKick:Callback("opener", function(spell)
    if not TigerPalm:InRange(target) then return end
    if not player:TalentKnown(OrderedElements.id) then return end

    return spell:Cast(target)
end)

LegSweep:Callback("arena", function(spell)
    if gs.activeEnemies < 2 then return end

    if arena1.Cds or arena2.Cds or arena3.Cds then
        return spell:Cast()
    end
end)

SlicingWinds:Callback("quickCancel", function(spell)
    local duration = GetUnitEmpowerStageDuration("player", 1)

    if duration > 0 then
        local makAlert = A.GetToggle(2, "makAware")
        if makAlert[4] then
            Aware:displayMessage("Slicing Winds Soon!", "White", 1)
        end
    
        if player.stayTime > 0.3 then
            return spell:Cast()
        end
    end
end)

A[3] = function(icon)
	FrameworkStart(icon)
    updategs()

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "Xuen active: ", pet.exists)
        MakPrint(2, "Energy: ", player.energy)
        MakPrint(3, "Chi: ", player.chi)
        MakPrint(4, "Chi Max: ", player.chiMax)
        MakPrint(5, "Chi Deficit: ", player.chiDeficit)
        MakPrint(6, "Previous Combo Strike: ", gs.comboStrike)
        MakPrint(7, "Tiger Palm In Range: ", TigerPalm:InRange(target))
        MakPrint(8, "Enemies In Melee: ", gs.activeEnemies)
        MakPrint(9, "Empower Duration ", GetUnitEmpowerStageDuration("player", 1))
        MakPrint(10, "Celestial Conduit Learned: ", IsPlayerSpell(CelestialConduit.id))
        MakPrint(11, "Target Distance: ", target.distance)
        MakPrint(12, "Xuen CD: ", InvokeXuen.cd)
    end

    if Action.Zone ~= "arena" then makInterrupt(interrupts) end

    --SlicingWinds("quickCancel")
    if GetUnitEmpowerStageDuration("player", 1) > 0 then
        return A.SlicingWinds:Show(icon)
    end

    FortifyingBrew()
    DiffuseMagic()
    CelestialConduitCancel()

    local casting = player.channelInfo
    if casting then return end

    if Action.IsInPvP then
        LegSweep("arena")
    end

    if target.exists and target.canAttack and CracklingJadeLightning:InRange(target) then
       TouchOfKarma()
    
        if gs.activeEnemies > 2 then
            if player.combatTime < 3 then
                aoeOpener()
            end
        else
            if player.combatTime < 4 then
                normalOpener()
            end
        end
        

        if shouldBurst() and TigerPalm:InRange(target) then
            local damagePotion = Action.GetToggle(2, "damagePotion")
            local potionLustOnly = Action.GetToggle(2, "potionLustOnly")
            local potionExhausted = Action.GetToggle(2, "potionExhausted")
            local potionExhaustedSlider = Action.GetToggle(2, "potionExhaustedSlider")
            local damagePotionObject = Action.DetermineUsableObject("player", nil, nil, true, nil, A.TemperedPotion1, A.TemperedPotion2, A.TemperedPotion3, A.PotionofUnwaveringFocus1, A.PotionofUnwaveringFocus2, A.PotionofUnwaveringFocus3)

            if damagePotionObject and damagePotion and ((potionLustOnly and player.bloodlust) or (potionExhausted and player:SatedRemains() > potionExhaustedSlider * 60000) or not potionLustOnly) then
                local shouldPot = player:Buff(buffs.stormEarthAndFire) and pet.exists
                if shouldPot then
                    return damagePotionObject:Show(icon)
                end
            end
            if InvokeXuen.cd > 30000 then
                if Trinket(1, "Damage") then Trinket1() end
                if Trinket(2, "Damage") then Trinket2() end
            end
        end

        if TigerPalm:InRange(target) then
            cds() -- outside burst for individual spell toggles.
        end
        
        if gs.shouldAoE then
            if gs.activeEnemies >= 5 then
                aoe()
            elseif gs.activeEnemies > 1 and (player.combatTime > 7 or not player:TalentKnown(CelestialConduit.id)) and gs.activeEnemies < 5 then
                cleave()
            end
        end

        st()
        fallback()

        LightsJudgment()
        BagOfTricks()
    end

	return FrameworkEnd()
end

TouchOfDeath:Callback("arena", function(spell, enemy)
    if not TouchOfDeath:InRange(enemy) then return end

    return spell:Cast(enemy)
end)

GrappleWeapon:Callback("arena", function(spell, enemy)
    if enemy.totalImmune then return end
    if enemy.physicalImmune then return end
    if enemy.ccRemains > 700 then return end
    if enemy.distance > 10 then return end
    if enemy:Buff(446035) then return end
    if enemy:Buff(227847) then return end
    if not enemy:HasBuffFromFor(MakLists.Disarm, 500) then return end
    --Aware:displayMessage("Disarm - Enemy - Bursting", "White", 1)
    return spell:Cast(enemy)
end)

SpearHandStrike:Callback("arena", function(spell, unit)
    if unit:IsKickImmune() then return end
    if target.hp < 20 then return end
    if not unit:CastingFromFor(MakLists.arenaKicks, 620) then return end

    return spell:Cast(unit)
end)

Paralysis:Callback("arena", function(spell, enemy)
    if enemy.cc then return end
    if enemy:IsTarget() then return end
    if enemy.incapacitateDr < 0.5 then return end
    if enemy.ccImmune then return end
    

    if enemy.isHealer and target.exists and target.hp < 50 then
        --Aware:displayMessage("Paralysis Healer", "Green", 1)
        return spell:Cast(enemy)
    end

    local peelParty = (party1.exists and party1.hp < 50) or (party2.exists and party2.hp < 50)
    if peelParty and not enemy.isHealer and enemy.hp > 40 then
        --Aware:displayMessage("Paralysis To Peel", "Red", 1)
        return spell:Cast(enemy)
    end
end)

TigersLust:Callback("self", function(spell)
    if not player.rooted then return end

    return Debounce("TLS", 1000, 2500, spell, player)
end)

TigersLust:Callback("arena", function(spell, friendly)
    if not TigersLust:InRange(friendly) then return end

    if player.rooted then return end
    if not friendly.rooted then return end

    return Debounce("TLF", 1000, 2500, spell, friendly)
end)

Detox:Callback("pve", function(spell, friendly)
    if not Detox:InRange(friendly) then return end
    
    if friendly.diseased or friendly.poisoned then
        return Debounce("detox", 1000, 2500, spell, friendly)
    end
end)

VivifyFriendly:Callback("party", function(spell, friendly)
    if A.IsInPvP then return end
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
    if autoTarget() then return TabTarget() end
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
    TigersLust("self")
	partyRotation(player)

	return FrameworkEnd()
end
