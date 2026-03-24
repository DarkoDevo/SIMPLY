if not MakuluValidCheck() then return true end
if not Makulu_magic_number == 2347956243324 then return true end

if GetSpecializationInfo(GetSpecialization()) ~= 256 then return end

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
local constCell        = cacheContext:getConstCacheCell()

local boss             = MakuluFramework.Boss
local inc              = MakuluFramework.incSpell

local HealingEngine    = Action.HealingEngine
local Aware            = MakuluFramework.Aware

local Action           = _G.Action
local Player           = Action.Player
local MultiUnits       = Action.MultiUnits

local _G, setmetatable = _G, setmetatable
local FakeCasting      = MakuluFramework.FakeCasting

local ActionID       = {
    WillToSurvive = { ID = 59752, MAKULU_INFO = { offGcd = true } },
    Stoneform = { ID = 20594, MAKULU_INFO = { offGcd = true } },
    Shadowmeld = { ID = 58984, MAKULU_INFO = { offGcd = true } },
    EscapeArtist = { ID = 20589, MAKULU_INFO = { offGcd = true } },
    GiftOfTheNaaru = { ID = 59544, MAKULU_INFO = { offGcd = true } },
    Darkflight = { ID = 68992, MAKULU_INFO = { offGcd = true } },
    BloodFury = { ID = 20572, MAKULU_INFO = { offGcd = true } },
    WillOfTheForsaken = { ID = 7744, MAKULU_INFO = { offGcd = true } },
    WarStomp = { ID = 20549, MAKULU_INFO = { offGcd = true } },
    Berserking = { ID = 26297, MAKULU_INFO = { offGcd = true } },
    ArcaneTorrent = { ID = 50613, MAKULU_INFO = { offGcd = true } },
    RocketJump = { ID = 69070, MAKULU_INFO = { offGcd = true } },
    RocketBarrage = { ID = 69041, MAKULU_INFO = { offGcd = true } },
    QuakingPalm = { ID = 107079, MAKULU_INFO = { offGcd = true } },
    SpatialRift = { ID = 256948, MAKULU_INFO = { offGcd = true } },
    LightsJudgment = { ID = 255647, MAKULU_INFO = { offGcd = true } },
    Fireblood = { ID = 265221, MAKULU_INFO = { offGcd = true } },
    ArcanePulse = { ID = 260364, MAKULU_INFO = { offGcd = true }, Macro = "/cast !Inner Light \n/cast Inner Shadow" },
    BullRush = { ID = 255654, MAKULU_INFO = { offGcd = true } },
    AncestralCall = { ID = 274738, MAKULU_INFO = { offGcd = true } },
    Haymaker = { ID = 287712, MAKULU_INFO = { offGcd = true } },
    Regeneratin = { ID = 291944, MAKULU_INFO = { offGcd = true }, Macro = "/cast Premonition of Insight\n/cast Premonition of Piety\n/cast Premonition of Solace\n/cast Premonition of Clairvoyance" },
    BagOfTricks = { ID = 312411, MAKULU_INFO = { offGcd = true } }, 
    HyperOrganicLightOriginator = { ID = 312924, MAKULU_INFO = { offGcd = true } },

    DesperatePrayer = { ID = 19236, MAKULU_INFO = { ignoreCasting = true } },
    Fade = { ID = 586, MAKULU_INFO = { ignoreCasting = true, offGcd = true, }, Macro = "/stopcasting\n/cast spell:thisID" },
    FlashHeal = { ID = 2061, MAKULU_INFO = { ignoreCasting = true } },
    Levitate = { ID = 1706, MAKULU_INFO = { ignoreCasting = true } },
    MindBlast = { ID = 8092, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }  },
    MindSoothe = { ID = 453, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordFortitude = { ID = 21562, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordShield = { ID = 17, MAKULU_INFO = { ignoreCasting = true } },
    PsychicScream = { ID = 8122, MAKULU_INFO = { ignoreCasting = true } },
    Resurrection = { ID = 2006, MAKULU_INFO = { ignoreCasting = true } },
    ShadowWordPain = { ID = 589, MAKULU_INFO = { ignoreCasting = true } },
    Smite = { ID = 585, FixedTexture = 135924, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Renew = { ID = 139, MAKULU_INFO = { ignoreCasting = true } 	 },
    DispelMagic = { ID = 528, MAKULU_INFO = { ignoreCasting = true }  },
    Mindbender = { ID = 123040, FixedTexture = 136199, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Shadowfiend = { ID = 34433, FixedTexture = 136199, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    PrayerOfMending = { ID = 33076, MAKULU_INFO = { ignoreCasting = true }  },
    ShadowWordDeath = { ID = 32379, MAKULU_INFO = { damageType = "magic", }  },
    HolyNova = { ID = 132157, MAKULU_INFO = { ignoreCasting = true } },
    AngelicFeather = { ID = 121536, MAKULU_INFO = { ignoreCasting = true }, Macro = "/cast [@player] spell:thisID" },
    LeapOfFaith = { ID = 73325, MAKULU_INFO = { ignoreCasting = true } },
    ShackleUndead = { ID = 9484, MAKULU_INFO = { ignoreCasting = true } },
    VoidTendrils = { ID = 108920, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MindControl = { ID = 605, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    DominateMind = { ID = 205364, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    MassDispel = { ID = 32375, MAKULU_INFO = { ignoreCasting = true } },
    PowerInfusion = { ID = 10060, MAKULU_INFO = { ignoreCasting = true }  },
    PowerInfusionP = { ID = 10060, Texture = 316262, Desc = "Party", MAKULU_INFO = { ignoreCasting = true }, Click = { unit = "focus", type = "spell", spell = 10060 } },
    VampiricEmbrace = { ID = 15286, MAKULU_INFO = { ignoreCasting = true }  },
    DivineStar = { ID = 110744, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }   },
	Halo = { ID = 120517, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }    },
    PowerWordLife = { ID = 373481, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordLifeToo = { ID = 440678, MAKULU_INFO = { ignoreCasting = true } },
    VoidShift = { ID = 108968, MAKULU_INFO = { ignoreCasting = true } },
    
    Penance = { ID = 47540, Texture = 273307, MAKULU_INFO = { ignoreCasting = true }  },
    PenanceDmg = { ID = 47540, Texture = 23018, Desc = "PenanceDmg", Click = { unit = "target", type = "spell", spell = 47540 }, MAKULU_INFO = { damageType = "magic", ignoreCasting = true } },
    Purify = { ID = 527, MAKULU_INFO = { ignoreCasting = true } },
    Evangelism = { ID = 472433, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordBarrier = { ID = 62618, MAKULU_INFO = { ignoreCasting = true } },
    LuminousBarrier = { ID = 271466, MAKULU_INFO = { ignoreCasting = true } },
    PainSuppression = { ID = 33206, MAKULU_INFO = { ignoreCasting = true } },
    PowerWordRadiance = { ID = 194509, MAKULU_INFO = { ignoreCasting = true } },
    UltimatePenitence = { ID = 421453, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }  },
    Voidwraith = { ID = 451235, FixedTexture = 136199, MAKULU_INFO = { damageType = "magic", ignoreCasting = true }  },

    PremonitionofInsight = { ID = 428933, FixedTexture = 5927640, MAKULU_INFO = { ignoreCasting = true } }, 
    PremonitionofPiety = { ID = 428930, FixedTexture = 5927640, MAKULU_INFO = { ignoreCasting = true } },
    PremonitionofSolace = { ID = 428934, FixedTexture = 5927640, MAKULU_INFO = { ignoreCasting = true }  },
    PremonitionofClairvoyance = { ID = 440725, FixedTexture = 5927640, MAKULU_INFO = { ignoreCasting = true }  },

    Archangel = { ID = 197862, MAKULU_INFO = { ignoreCasting = true } },
    DarkArchangel = { ID = 197871, MAKULU_INFO = { ignoreCasting = true } },
    InnerLight = { ID = 355897, FixedTexture = 133667, Macro = "/cast !Inner Light\n/cast Inner Shadow", MAKULU_INFO = { ignoreCasting = true } },
    InnerShadow = { ID = 355898, FixedTexture = 133667, MAKULU_INFO = { ignoreCasting = true } },
    Mindgames = { ID = 375901, MAKULU_INFO = { ignoreCasting = true } },
    Thoughtsteal = { ID = 316262, MAKULU_INFO = { ignoreCasting = true } },

    ImprovedPurify = { ID = 390632, Hidden = true  },
    MiraculousRecovery = { ID = 440674, Hidden = true  },
    FocusedMending = { ID = 372354, Hidden = true  },
    DevourMatter = { ID = 372354, Hidden = true  },
    TranslucentImage = { ID = 373446, Hidden = true  },
    VoidwraithTalent = { ID = 451234, Hidden = true  },
    PhaseShift	     = { ID = 408557, Hidden = true  },
    TwilightCorruption = { ID = 373065, Hidden = true  },

    EntropicRift  = { ID = 447444, Hidden = true  }, 

}

local A, M = MakuluFramework.CreateActionVar(ActionID, true)
A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_PRIEST_DISCIPLINE] = A
TableToLocal(M, getfenv(1))
Aware:enable()

-- Function to update spell movement flags based on castWhileMoving toggle
local function updateCastWhileMovingFlags()
    local castWhileMoving = A.GetToggle(2, "castWhileMoving")

    -- List of spell names that have cast times and should respect the toggle
    local castTimeSpellNames = {
        "FlashHeal", "Smite", "MindBlast", "MassDispel", "Mindgames"
    }

    for _, spellName in ipairs(castTimeSpellNames) do
        local spell = M[spellName]
        if spell then
            rawset(spell, "ignoreMoving", castWhileMoving)
        end
    end
end

local player        = ConstUnit.player
local target        = ConstUnit.target
local focus         = ConstUnit.focus
local mouseover     = ConstUnit.mouseover
local arena1        = ConstUnit.arena1
local arena2        = ConstUnit.arena2
local arena3        = ConstUnit.arena3
local party1        = ConstUnit.party1
local party2        = ConstUnit.party2
local party3        = ConstUnit.party3
local party4        = ConstUnit.party4
local tank          = ConstUnit.tank
local healer        = ConstUnit.healer
local enemyHealer   = ConstUnit.enemyHealer
local pet           = ConstUnit.pet

Aware:enable()

local buffs = {
    feather = 121557,
    painSuppression = 33206,
    powerWordShield = 17,
    atonement = 194384,
    renew = 139,
    shadowCovenant = 322105,
    voidheart = 449887,
    surgeOfLight = 114255,
    premOfInsight = 428933,
    premOfPiety = 428930,
    premOfSolace = 428934,
    innerLight = 355897,
    innerShadow = 355898,
    ultimatePenitence = 421453,
    spiritOfRedemption = 27827,
    spiritOfTheRedeemer = 215982,
    wealAndWoe = 390787,
    WasteNoTime = 447444, 
}

local debuffs = {
    shadowWordPain = 589,
}

local gs = {
    rampTracker = 0
}

local interrupts = {
    { spell = PsychicScream, isCC = true, aoe = true, distance = 3 },
}

TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(callbackEvent, thisUnit, db, QueueOrder)
	local unitID  = thisUnit.Unit
    local unit = MakUnit:new(unitID)

	--Spirit of Redemption / Spirit of the Redeemer
    if unit:Buff(buffs.spiritOfRedemption) or unit:Buff(buffs.spiritOfTheRedeemer) then
	    thisUnit.Enabled = false
	else 
        thisUnit.Enabled = true
	end

    if unit:Buff(buffs.atonement, true) then
        thisUnit.realHP = unit.hp + 20
    else
        thisUnit.realHP = unit.hp
    end
end)

local function calculateHealTarget()
    if target.exists and target.isFriendly then
        healTarget = target
    elseif focus.exists and focus.isFriendly then
        healTarget = focus
    else
        healTarget = nil
    end
end

FakeCasting.enable()

FakeCasting.blacklist({
  ["Penance"] = true,
  ["Ultimate Pentience"] = true,
  ["Dark Reprimand"] = true,
  [47540] = true, -- Penance
  [421453] = true, --Ultimate Penitience
  [8092] = true, -- Mindblast
  [585] = true, -- Smite
  [32375] = true, -- mass dispel
})

local function CanAttackTarget()
    return target.exists and not target.isFriendly and target.canAttack
end

local function HandleMindbenderLogic(spell)
	if not CanAttackTarget() then return end
    if combatTime == 0 then return end

    local mindbenderMenuOption = GetToggle(2, "MindbenderMenu")

    if mindbenderMenuOption == "1" then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "2" and CanUseHealingCooldowns() then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "3" and unit.ehp <= GetToggle(2, "MindbenderSlider") then
        return spell:Cast(target)
    elseif mindbenderMenuOption == "4" and (CanUseAoeHealing() or unit.ehp <= GetToggle(2, "MindbenderSlider")) then
        return spell:Cast(target)
    end
end

local function hasIncomingDamage()
    return incBigDmgIn() < 4000 or incModDmgIn() < 4000
end

local function defensiveActive()
    return player:BuffFrom(MakLists.Defensive) or UnitGetTotalAbsorbs("player") >= player.maxHealth * 0.15
end

local function shouldDefensive()
    local incomingDamage = hasIncomingDamage()

    return incomingDamage and not defensiveActive()
end

local function getBelowHP(percent, withoutAtonement)
    return MakMulti.party:Count(function(unit)
        return FlashHeal:InRange(unit) and unit.ehp < percent and unit.hp > 0 and (not withoutAtonement or unit:BuffRemains(buffs.atonement, true) < 1500)
    end)
end

local function unitsWithoutAtonement()
    local found = 0

    return MakMulti.party:Count(function(unit)
        if found == 5 then return end

        local without = FlashHeal:InRange(unit) and unit.hp > 0 and not unit:Buff(buffs.atonement, true)
        if without then found = found + 1 end
        return without
    end)
end

local function timeToFullRamp(max)
    local maxGcd = A.GetGCD() * 1000 

    local totalUnits = MakMulti.party:Count(function(unit)
        return unit.hp > 0 and FlashHeal:InRange(unit)
    end)

    local atonementsNeeded = math.min(totalUnits, max)

    local pwrCharges = 1
    if atonementsNeeded >= 15 then
        pwrCharges = 2
    end

    local gcdsNeeded = atonementsNeeded - (5 * pwrCharges) + pwrCharges

    return gcdsNeeded * maxGcd
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", function(self, event, unitTarget, castGUID, spellID)
    if unitTarget == "player" then
        if gs.ramping then
            if spellID == PowerWordShield.id or spellID == Renew.id or spellID == FlashHeal.id or spellID == PowerWordRadiance.id then
                gs.rampTracker = gs.rampTracker + 1
            end
            if spellID == Evangelism.id then
                gs.rampTracker = 0
            end
        else
            gs.rampTracker = 0
        end
    end
end)

local function doTheRamp()
    if not gs.raid then return end

    local autoRamp = A.GetToggle(2, "rampMode") == "Auto"

    if autoRamp then
        if incBigDmgIn() < gs.timeToFullRamp then
            if not A.GetToggle(2, "startRamp") then
                A.SetToggle({2, "startRamp", "Start Ramp: "}, true)
            end
        end
    end

    if A.GetToggle(2, "startRamp") then
        if Evangelism.used > 0 and Evangelism.used < 1000 then
            A.SetToggle({2, "startRamp", "Manual Ramp: "}, false)
        end

        if UltimatePenitence.used > 0 and UltimatePenitence.used < 1000 then
            A.SetToggle({2, "startRamp", "Manual Ramp: "}, false)
        end

        if PowerWordRadiance.cd > gs.timeToFullRamp then
            A.SetToggle({2, "startRamp", "Manual Ramp: "}, false)
        end
    end
end

local function rampTimers()
    if not gs.raid then return end

    local autoRamp = A.GetToggle(2, "rampMode") == "Auto"
    if not autoRamp then return end

    if A.GetToggle(2, "uppiesRamp") then
        if UltimatePenitence.cd > 10000 then
            A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, false)
        end
    end

    if A.GetToggle(2, "evangRamp") then
        if Evangelism.cd > 10000 then
            A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, false)
        end
    end

    if not boss then return end
    if not player.combat then return end

    local upReady = player:TalentKnown(UltimatePenitence.id) and UltimatePenitence.cd < 10000
    local evangReady = player:TalentKnown(Evangelism.id) and Evangelism.cd < 10000

    if boss.vexie() then
        if evangReady then
            if makRamp({465865}) < 2000 then -- Exhaust Fumes (tracker is for Tank Buster but happens at same time every time)
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
            if inc.mechanicalBreakdown then
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        else
            if upReady then
                if makRamp({465865}) < 20000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Exhaust Fumes
                    A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                end
            end
        end
    end

    if boss.cauldron() then
        if upReady then
            if makRamp({472233}) < 18000  then -- Blastburn Roarcannon
                A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
            end
        end
        if evangReady then
            if inc.colossalClash < 60000 then
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        end
    end

    if boss.rik() then
        if evangReady then
            if makRamp({466866}) < 18000 then -- Echoing Chant
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        end
        if upReady then
            if makRamp({466866}) < 18000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Echoing Chant
                if not A.GetToggle(2, "uppiesRamp") then
                    A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                end
            end
        end
    end

    if boss.stix() then
        if evangReady then
            if makRamp({464399}) < 1000 then -- Electromagnetic Sorting
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        else 
            if upReady then
                if makRamp({464399}) < 18000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Electromagnetic Sorting
                    if not A.GetToggle(2, "uppiesRamp") then
                        A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                    end
                end
            end
        end
    end

    if boss.lockenstock() then
        if evangReady then
            if makRamp({465232}) < 18000 then -- Sonic Ba-Boom (AKA Activate Inventions)
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
            if inc.betaLaunch or inc.bleedingEdge then
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        end
        if upReady then
            if makRamp({465232}) < 18000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Sonic Ba-Boom (AKA Activate Inventions)
                if not A.GetToggle(2, "uppiesRamp") then
                    A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                end
            end
        end
    end

    if boss.bandit() then
        if evangReady then
            if makRamp({469993}) < 18000 then -- Foul Exhaust
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        else 
            if upReady then
                if makRamp({469993}) < 18000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Foul Exhaust
                    if not A.GetToggle(2, "uppiesRamp") then
                        A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                    end
                end
            end
        end
    end

    if boss.mugzee() then
        if evangReady then
            if makRamp({474461}) < 18000 then -- Earthshaker Gaol
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
            if makRamp({467380}) < 18000 then -- Goblin-Guided Rocket
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        else 
            if upReady then
                if makRamp({474461}) < 18000 and Evangelism.cd > 1000 and Evangelism.used > 10000 then -- Foul Exhaust
                    if not A.GetToggle(2, "uppiesRamp") then
                        A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                    end
                end
            end
        end
    end

    if boss.gallywix() then
        if evangReady then
            if makRamp({466340}) < 18000 then -- Scatterblast Canisters
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
            if makRamp({469286}) < 18000 then -- Giga Coils
                if not A.GetToggle(2, "evangRamp") then
                    A.SetToggle({2, "evangRamp", "Evangelism Ramp: "}, true)
                end
            end
        else 
            if upReady then
                if makRamp({466340}) < 18000 then -- Scatterblast Canisters
                    if not A.GetToggle(2, "uppiesRamp") then
                        A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                    end
                end
                if makRamp({469286}) < 18000 then -- Giga Coils
                    if not A.GetToggle(2, "uppiesRamp") then
                        A.SetToggle({2, "uppiesRamp", "Uppies Ramp: "}, true)
                    end
                end
            end
        end
    end
end

local function isPetActive()
    for i = 1, 4 do
        local _, name = GetTotemInfo(i)
        if name == Voidwraith.wowName or name == Shadowfiend.wowName or name == Mindbender.wowName then
            return true
        end
    end
    return false
end

local function petDuration()
    if player:TalentKnown(VoidwraithTalent.id) then
        return Voidwraith.used < 15000 and Voidwraith.used or 0 
    end

    if not player:TalentKnown(VoidwraithTalent.id) and player:TalentKnown(Mindbender.id) then
        return Mindbender.used < 12000 and Mindbender.used or 0 
    end

    if not player:TalentKnown(VoidwraithTalent.id) and not player:TalentKnown(Mindbender.id) then
        return Shadowfiend.used < 15000 and Voidwraith.used or 0 
    end
end

local function enemyBurstCount()
    local burstCount = 0

    if arena1.exists and arena1.cds then burstCount = burstCount + 1 end
    if arena2.exists and arena2.cds then burstCount = burstCount + 1 end
    if arena3.exists and arena3.cds then burstCount = burstCount + 1 end

    return burstCount
end

local function getPowerWordShieldAbsorption(unitID)
    local totalAbsorbs = UnitGetTotalAbsorbs(unitID)
    return totalAbsorbs -- This includes all absorption effects, not just Power Word: Shield
end

local function enemiesInRange(debuff, dur)
    local cacheKey = debuff and ("enemiesInRangeWithDebuff_" .. tostring(debuff)) or "enemiesInRange"
    
    return constCell:GetOrSet(cacheKey, function() 
        local activeEnemies = MultiUnits:GetActiveUnitPlates()
        local count = 0
        local dur = dur or 0
        
        for enemyGUID in pairs(activeEnemies) do
        local enemy = MakUnit:new(enemyGUID)
        
            if Smite:InRange(enemy) and not enemy:IsTotem() and not enemy.isPet then
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

local function getCurrentCastInfo()
    local castingInfo = player.castOrChannelInfo

    if not castingInfo then
        return nil, nil, nil, nil
    end

    return castingInfo.spellId, castingInfo.name, castingInfo.remaining, castingInfo.castLength
end

local lastUpdateTime = 0
local updateDelay = 0.5
-- Funktion zur Aktualisierung des Spielzustands
local function updategs()
    local currentTime = GetTime()

    local currentCast, currentCastName, currentCastRemains, currentCastLength = getCurrentCastInfo()
    gs.imCastingRemaining = currentCastRemains

    if (currentTime - lastUpdateTime) > updateDelay then
        gs.imCasting = currentCast
        gs.imCastingName = currentCastName
        lastUpdateTime = currentTime 
    end

    rampTimers()

    gs.activeEnemies = math.max(enemiesInRange(), 1)
    gs.swpEnemies = enemiesInRange(ShadowWordPain.id, 3000)

    gs.atonementCount = MakMulti.party:Count(function(unit) return unit:BuffRemains(buffs.atonement, true) > 2000 end)
    gs.unitsWithoutAtonement = unitsWithoutAtonement()

    if gs.imCasting and gs.imCasting == PowerWordRadiance.id then
        gs.atonementCount = gs.atonementCount + gs.unitsWithoutAtonement
    end

    gs.groupSize = MakMulti.party:Count(function(unit) return unit.hp > 0 and FlashHeal:InRange(unit) end)

    gs.petActive = isPetActive()
    gs.petDuration = petDuration()
    gs.petNotReady = Voidwraith.cd > 0 or Shadowfiend.cd > 0 or Mindbender.cd > 0

    if player:TalentKnown(Evangelism.id) and Evangelism.cd < timeToFullRamp(18) then
        gs.timeToFullRamp = timeToFullRamp(18)
    end

    if (Evangelism.cd > timeToFullRamp(18) or not player:TalentKnown(Evangelism.id)) and player:TalentKnown(UltimatePenitence.id) and UltimatePenitence.cd < timeToFullRamp(9) then
        gs.timeToFullRamp = timeToFullRamp(9)
    end

    if (Evangelism.cd > timeToFullRamp(18) or not player:TalentKnown(Evangelism.id)) and (UltimatePenitence.cd > timeToFullRamp(9) or not player:TalentKnown(UltimatePenitence.id)) then
        if PowerWordRadiance:TimeToFullCharges() < timeToFullRamp(18) then
            gs.timeToFullRamp = timeToFullRamp(18)
        else
            gs.timeToFullRamp = timeToFullRamp(10)
        end
    end


    gs.totalCastsFullRamp = gs.timeToFullRamp / (A.GetGCD() * 1000)

    gs.rampTimer = incBigDmgIn()

    gs.burstCount = enemyBurstCount()
    gs.painCharges = PainSuppression.frac
    gs.radianceCharges = PowerWordRadiance.frac
    gs.ramping = A.GetToggle(2, "startRamp") or A.GetToggle(2, "evangRamp") or A.GetToggle(2, "uppiesRamp")

    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    gs.dungeon = instanceType == "party" or instanceType == "pvp"
    gs.raid = instanceType == "raid"

    if gs.raid and MakUnit:new("boss1").exists then
        local BossTargets = {}
        for i = 1, 5 do
            local tmpboss = MakUnit:new("boss"..i)
            if tmpboss.exists and tmpboss.target and tmpboss.target.exists then
                BossTargets[tmpboss.target.guid] = true
            end
        end
        tank = MakMulti.party:Find(function(party)
            return party.exists and party.isTank and not party.dead and BossTargets[party.guid]
        end)
    else
        tank = ConstUnit.tank
    end

    -- Update cast while moving flags based on checkbox setting
    updateCastWhileMovingFlags()
end

local function shouldPS(unit)
    if unit:Buff(186265) then return false end
    if unit:Buff(642) then return false end
    if unit:Buff(79811) then return false end
    if unit:Buff(196555) then return false end
    if unit:Buff(118038) then return false end
    return true
end

local function holdGCDforSWD()
    if Action.Zone ~= "arena" then return false end
    if ShadowWordDeath.cd > 1000 then return false end
    if getBelowHP(30) > 0 then return false end
    if arena1.exists and arena1:CastingFromFor(MakLists.swdList, 1) --[[and not arena1:CastingFromFor(MakLists.swdList, 420)]] then return true end
    if arena2.exists and arena2:CastingFromFor(MakLists.swdList, 1) --[[and not arena2:CastingFromFor(MakLists.swdList, 420)]] then return true end
    if arena3.exists and arena3:CastingFromFor(MakLists.swdList, 1) --[[and not arena3:CastingFromFor(MakLists.swdList, 420)]] then return true end
    return false
end

local function holdGCDforSWDP()
    if Action.Zone ~= "arena" then return false end
    if ShadowWordDeath:Cooldown() > 1000 then return false end
    if getBelowHP(30) > 0 then return false end
    if arena1.exists and arena1:CastingFromFor(MakLists.swdList, 1) and not arena1:CastingFromFor(MakLists.swdList, 420) then return true end
    if arena2.exists and arena2:CastingFromFor(MakLists.swdList, 1) and not arena2:CastingFromFor(MakLists.swdList, 420) then return true end
    if arena3.exists and arena3:CastingFromFor(MakLists.swdList, 1) and not arena3:CastingFromFor(MakLists.swdList, 420) then return true end
    return false
end

--------------------------------------------
---Util-------------------------------------

PowerInfusion:Callback(function(spell, unit)
    if not player.inCombat then return end

    if Action.Zone == "arena" then return end

    local needsPI = MakMulti.party:Find(function(friendly) return PowerInfusion:InRange(friendly) and friendly:HasBuffFromFor(MakLists.DPSCooldownList, 500) and not friendly.isTank and not friendly.isHealer end)
    if not needsPI then return end

    local piSelect = A.GetToggle(2, "piSelect")
    local piP1 = piSelect[1] and UnitIsUnit(needsPI:CallerId(), party1:CallerId())
    local piP2 = piSelect[2] and UnitIsUnit(needsPI:CallerId(), party2:CallerId())
    local piP3 = piSelect[3] and UnitIsUnit(needsPI:CallerId(), party3:CallerId())
    local piP4 = piSelect[4] and UnitIsUnit(needsPI:CallerId(), party4:CallerId())


    if gs.dungeon then
        if needsPI then
            if piP1 then
                if not UnitIsUnit(unit:CallerId(), party1:CallerId()) then 
                    HealingEngine.SetTarget(party1:CallerId(), 1)
                end
                return spell:Cast(unit)
            elseif piP2 then
                if not UnitIsUnit(unit:CallerId(), party2:CallerId()) then
                    HealingEngine.SetTarget(party2:CallerId(), 1)
                end
                return spell:Cast(unit)
            elseif piP3 then
                if not UnitIsUnit(unit:CallerId(), party3:CallerId()) then
                    HealingEngine.SetTarget(party3:CallerId(), 1)
                end
                return spell:Cast(unit)
            elseif piP4 then
                if not UnitIsUnit(unit:CallerId(), party4:CallerId()) then
                    HealingEngine.SetTarget(party4:CallerId(), 1)
                end
                return spell:Cast(unit)
            end
        end
    else
        if needsPI then
            if not UnitIsUnit(unit:CallerId(), needsPI:CallerId()) then
                HealingEngine.SetTarget(needsPI:CallerId(), 1)
            end
        end
    end
end)

AngelicFeather:Callback(function(spell)
    if A.Zone == "arena" then return end
    if player:HasBuff(buffs.feather) then return end
    if not player.moving then return end
    if IsFalling() then return end
    
    if A.GetToggle(2, "saveFeather") and spell.frac < 1.9 then return end

    return spell:Cast()
end)

PowerWordFortitude:Callback(function(spell)
    if player.inCombat then return end

    if Action.Zone == "arena" and player.combatTime > 0 then return end

    local missingBuff = MakMulti.party:Any(function(unit) return not unit:Buff(PowerWordFortitude.wowName) and unit.distance < 40 and not unit.isPet and unit.hp > 0 end)
    local outOfRange = MakMulti.party:Any(function(unit) return unit.distance >= 40 or C_Map.GetBestMapForUnit(player:CallerId()) ~= C_Map.GetBestMapForUnit(unit:CallerId()) end)
    
    if MakMulti.party:Size() <= 5 and outOfRange then return end -- attempt to wait for everyone to join the instance, dungeon only

    if missingBuff then 
        return Debounce("pwf", 1000, 2500, spell, player)
    end
end)

local function util(unit)
    PowerInfusion(unit)
    PowerWordFortitude()
    AngelicFeather()
end

--------------------------------------------
---Defensives-------------------------------
DesperatePrayer:Callback(function(spell)
    if player.ehp > A.GetToggle(2, "desperatePrayerHP") then return end

    return spell:Cast()
end)

Fade:Callback("pveDef", function(spell)
    if not player:TalentKnown(TranslucentImage.id) then return end
    if A.Zone == "arena" or A.Zone == "pvp" then return end

    if shouldDefensive() then
        return spell:Cast()
    end
    
    if MakMulti.party:Size() >= 2 and UnitThreatSituation(player:CallerId()) == 3 then
        return spell:Cast()
    end
end)

VampiricEmbrace:Callback(function(spell)
    if not hasIncomingDamage() then return end
    if player:BuffRemains(buffs.shadowCovenant) < 5000 then return end

    return spell:Cast()
end)

local function defensives()
    DesperatePrayer()
    Fade("pveDef")
    VampiricEmbrace()
end

--------------------------------------------
---Raid Healing-----------------------------

ShadowWordPain:Callback("ramp", function(spell)
    if not gs.ramping then return end
    if target:DebuffRemains(debuffs.shadowWordPain, true) > 13000 then return end

    if gs.rampTracker == 0 then
        return spell:Cast()
    end
end)

PowerWordShield:Callback("ramp", function(spell, unit)
    local needsAtonement = MakMulti.party:Find(function(unit) return PowerWordShield:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 and not unit.isMe end)
    local lowest = MakMulti.party:Lowest(function(unit) return unit:BuffRemains(buffs.atonement, true) end)

    if gs.rampTracker >= 0 or gs.rampTracker >= 8 then
        if needsAtonement then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
            return spell:Cast(unit)
        elseif lowest then
            HealingEngine.SetTarget(lowest:CallerId(), 1)
            return spell:Cast(unit)
        end
    end
end)

Renew:Callback("ramp", function(spell, unit)
    local needsAtonement = MakMulti.party:Find(function(unit) return Renew:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 and not unit.isMe end)
    local lowest = MakMulti.party:Lowest(function(unit) return unit:BuffRemains(buffs.atonement, true) end)

    if gs.rampTracker >= 1 and gs.rampTracker <= 6 then
        if needsAtonement then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
            return spell:Cast(unit)
        elseif lowest then
            HealingEngine.SetTarget(lowest:CallerId(), 1)
            return spell:Cast(unit)
        end
    end
end)

FlashHeal:Callback("ramp", function(spell, unit)
    local needsAtonement = MakMulti.party:Find(function(unit) return FlashHeal:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 end)
    local lowest = MakMulti.party:Lowest(function(unit) return unit:BuffRemains(buffs.atonement, true) end)

    if spell:CastTime() > 0 then return end

    if gs.rampTracker == 7 then
        if needsAtonement then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
            return spell:Cast(unit)
        elseif lowest then
            HealingEngine.SetTarget(lowest:CallerId(), 1)
            return spell:Cast(unit)
        end
    end
end)

Shadowfiend:Callback("ramp", function(spell)
    if gs.petNotReady then return end

    if player:TalentKnown(Evangelism.id) then
        if Evangelism.cd < 1000 then return end
    end

    if player:TalentKnown(VoidwraithTalent.id) or Evangelism.used < 3000 or not player:TalentKnown(Evangelism.id) then
        return spell:Cast()
    end
end)

PowerWordRadiance:Callback("ramp", function(spell, unit)
    local needsAtonement = MakMulti.party:Find(function(unit) return PowerWordRadiance:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 end)
    local lowest = MakMulti.party:Lowest(function(unit) return unit:BuffRemains(buffs.atonement, true) end)

    if gs.imCasting and gs.imCasting == spell.id and spell.frac < 1.9 then return end

    local selfCast = A.GetToggle(2, "forceCastPWRSelf")

    local pwrTarget = nil

    local aliveGroupMem = MakMulti.party:Count(function(unit) return PowerWordRadiance:InRange(unit) and unit.hp > 0 end)
    local rampTrackerMod = aliveGroupMem - 10

    if gs.rampTracker >= 9 or gs.rampTracker >= 10 or gs.rampTracker >= rampTrackerMod then
        if needsAtonement then
            pwrTarget = selfCast and player or needsAtonement
        elseif lowest then
            pwrTarget = selfCast and player or lowest
        end
        
        if pwrTarget and not unit:IsUnit(pwrTarget) then
            HealingEngine.SetTarget(pwrTarget:CallerId(), 1)
        elseif pwrTarget then
            return spell:Cast(unit)
        end
    end
end)

Evangelism:Callback("ramp", function(spell)
    if getBelowHP(80) < 5 then return end

    if gs.atonementCount >= gs.groupSize then
        return spell:Cast()
    end

    if PowerWordRadiance.frac < 1.9 and gs.imCasting and gs.imCasting == PowerWordRadiance.id then 
        return spell:Cast()
    end
end)

PremonitionofInsight:Callback("ramp", function(spell)
    if not player.combat then return end
    if not gs.raid then return end
    
    if Evangelism.cd < 500 then return end

    if Evangelism.used > 10000 then return end
    if MindBlast.cd < 500 then return end
    
    if PremonitionofInsight.used > 0 and PremonitionofInsight.used < 1200 then return end
    if PremonitionofPiety.used > 0 and PremonitionofPiety.used  < 1200 then return end
    if PremonitionofSolace.used > 0 and PremonitionofSolace.used < 1200 then return end
    if PremonitionofClairvoyance.used > 0 and PremonitionofClairvoyance.used < 1200 then return end

    return spell:Cast()
end)

PremonitionofInsight:Callback("temp", function(spell)
    if getBelowHP(95) < 1 then return end
    if player.combatTime == 0 then return end

    return spell:Cast(player)
end)

PremonitionofPiety:Callback("ramp", function(spell)
    if not player.combat then return end
    if not gs.raid then return end
    
    if Evangelism.cd < 500 then return end

    if Evangelism.used > 10000 then return end
    if MindBlast.cd < 500 then return end

    if PremonitionofInsight.used > 0 and PremonitionofInsight.used < 1200 then return end
    if PremonitionofPiety.used > 0 and PremonitionofPiety.used  < 1200 then return end
    if PremonitionofSolace.used > 0 and PremonitionofSolace.used < 1200 then return end
    if PremonitionofClairvoyance.used > 0 and PremonitionofClairvoyance.used < 1200 then return end

    return spell:Cast()
end)

PremonitionofPiety:Callback("temp", function(spell)
    if getBelowHP(70) < 1 then return end
    if player.combatTime == 0 then return end

    return spell:Cast(player)
end)


PremonitionofSolace:Callback("ramp", function(spell)
    if not player.combat then return end
    if not gs.raid then return end
    
    if Evangelism.cd < 500 then return end

    if Evangelism.used > 10000 then return end
    if MindBlast.cd < 500 then return end

    if PremonitionofInsight.used > 0 and PremonitionofInsight.used < 1200 then return end
    if PremonitionofPiety.used > 0 and PremonitionofPiety.used  < 1200 then return end
    if PremonitionofSolace.used > 0 and PremonitionofSolace.used < 1200 then return end
    if PremonitionofClairvoyance.used > 0 and PremonitionofClairvoyance.used < 1200 then return end

    return spell:Cast()
end)

PremonitionofSolace:Callback("temp", function(spell)
    if getBelowHP(70) < 1 then return end
    if player.combatTime == 0 then return end

    return spell:Cast(player)
end)

PremonitionofClairvoyance:Callback("ramp", function(spell)
    if not player.combat then return end
    if not gs.raid then return end
    
    if Evangelism.cd < 500 then return end

    if Evangelism.used > 10000 then return end
    if MindBlast.cd < 500 then return end

    if PremonitionofInsight.used > 0 and PremonitionofInsight.used < 1200 then return end
    if PremonitionofPiety.used > 0 and PremonitionofPiety.used  < 1200 then return end
    if PremonitionofSolace.used > 0 and PremonitionofSolace.used < 1200 then return end
    if PremonitionofClairvoyance.used > 0 and PremonitionofClairvoyance.used < 1200 then return end

    return spell:Cast()
end)

PremonitionofClairvoyance:Callback("temp", function(spell)
    if getBelowHP(60) < 1 then return end
    if player.combatTime == 0 then return end

    return spell:Cast(player)
end)

local function mainRamp(unit)
    Evangelism("ramp")
    if gs.rampTracker < gs.totalCastsFullRamp - math.floor(PowerWordRadiance.frac) then
        ShadowWordPain("ramp")
        PowerWordShield("ramp", unit)
        FlashHeal("ramp", unit)
        Renew("ramp", unit)
    else
        Shadowfiend("ramp")
        PowerWordRadiance("ramp", unit)
    end
end

MindBlast:Callback("ramp", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end
    
    if gs.atonementCount >= gs.groupSize then
        return spell:Cast(target)
    end

    if gs.imCasting and gs.imCasting == PowerWordRadiance.id then
        return spell:Cast(target)
    end
end)

UltimatePenitence:Callback("ramp", function(spell)
    if gs.atonementCount >= gs.groupSize then
        return spell:Cast(target)
    end

    if gs.imCasting and gs.imCasting == MindBlast.id then
        return spell:Cast(target)
    end
end)

local function uppiesRamp(unit)
    MindBlast("ramp")
    UltimatePenitence("ramp")
    if gs.rampTracker < gs.totalCastsFullRamp - 1 then
        ShadowWordPain("ramp")
        PowerWordShield("ramp", unit)
        FlashHeal("ramp", unit)
        Renew("ramp", unit)
    else
        PowerWordRadiance("ramp", unit)
    end
end

PowerWordRadiance:Callback("raid-extra", function(spell, unit)
    if gs.imCasting and gs.imCasting == spell.id then return end
    if not gs.raid then return end
    local bossUnit = MakUnit:new("boss1")
    if bossUnit and bossUnit.exists and spell.frac < 1.9 then return end

    if gs.imCasting and gs.imCasting == spell.id and spell.frac < 1.9 then return end

    local injuredWithoutAtonement = MakMulti.party:Count(function(unit)
        return unit.hp > 0 and unit.ehp < 90 and not unit:Buff(buffs.atonement, true)
    end)

    if injuredWithoutAtonement >= 4 then
        return spell:Cast(unit)
    end

    local atonementExpiring = MakMulti.party:Count(function(unit)
        return unit.hp > 0 and unit:BuffRemains(buffs.atonement, true) < 4000
    end)

    if unit:BuffRemains(buffs.atonement, true) <= spell:CastTime() and atonementExpiring >= 1 then
        if (incBigDmgIn() - 500 < spell:CastTime() or gs.petDuration > 8000) then
            return spell:Cast(unit)
        end
    end
end)

local function raid(unit)
    PowerWordRadiance("raid-extra", unit)
    if not gs.ramping then return end

    --[[if (Evangelism.cd > gs.timeToFullRamp or not player:TalentKnown(Evangelism.id)) and player:TalentKnown(UltimatePenitence.id) and UltimatePenitence.cd < gs.timeToFullRamp then
        uppiesRamp(unit)
    end

    mainRamp(unit)]]

    if A.GetToggle(2, "uppiesRamp") or (A.GetToggle(2, "startRamp") and Evangelism.cd > 5000 and Evangelism.used > 10000) then
        uppiesRamp(unit)
    end

    if A.GetToggle(2, "evangRamp") or A.GetToggle(2, "startRamp") then
        mainRamp(unit)
    end

    Shadowfiend("ramp") -- Both inside and outside mainRamp() for with and without Evangelism
end

--------------------------------------------
---Dungeon Healing--------------------------

PowerWordRadiance:Callback("dungeon", function(spell, unit)
    if gs.imCasting and gs.imCasting == spell.id then return end

    local injuredWithoutAtonement = MakMulti.party:Count(function(unit)
        return unit.hp > 0 and unit.ehp < 90 and not unit:Buff(buffs.atonement, true)
    end)

    if injuredWithoutAtonement >= 2 then
        return spell:Cast(unit)
    end

    local atonementExpiring = MakMulti.party:Count(function(unit)
        return unit.hp > 0 and unit:BuffRemains(buffs.atonement, true) < 4000
    end)

    if unit:BuffRemains(buffs.atonement, true) <= spell:CastTime() and atonementExpiring >= 1 then
        if (incBigDmgIn() - 500 < spell:CastTime() or gs.petDuration > 8000) then
            return spell:Cast(unit)
        end
    end
end)

Shadowfiend:Callback("dungeon", function(spell)
    if not target.exists then return end
    if target.isFriendly then return end
    if gs.petDuration > 0 then return end
    if gs.petNotReady then return end
    if target.ttd < 5000 then return end

    if incBigDmgIn() < 5000 then
        return spell:Cast()
    end

    if A.GetToggle(2, "sendPet") and MindBlast.cd < 1000 then
        return spell:Cast()
    end
end)

UltimatePenitence:Callback("dungeon", function(spell)
    if gs.atonementCount < 5 then return end
    if (shouldDefensive() or getBelowHP(75)) and target.isBoss then
        return spell:Cast(target)
    end
end)

Evangelism:Callback("dungeon", function(spell, unit)
    if not unit:Buff(buffs.atonement, true) then return end
    
    if unit.ehp < 30 then
        return spell:Cast()
    end

    if gs.atonementCount == 2 and unit.ehp < 50 then
        return spell:Cast()
    end

    if gs.atonementCount == 3 and unit.ehp < 60 then
        return spell:Cast()
    end

    if gs.atonementCount >= 4 and unit.ehp < 70 then
        return spell:Cast()
    end
end)

local function dungeon(unit)
    if not gs.dungeon then return end
    Evangelism("dungeon", unit)
    Shadowfiend("dungeon")
    PowerWordRadiance("dungeon", unit)
    UltimatePenitence("dungeon")
end

--------------------------------------------
---PvE Standard-----------------------------

Purify:Callback("pve", function(spell, unit)
    if A.Zone == "arena" then return end
    if unit.hp < 35 then return end
    if unit:DebuffFrom(AvoidDispelTable) then return end

    local imDiseased = player.diseased or Action.AuraIsValid(player:CallerId(), "UseDispel", "Disease")
    local imMagicked = player.magicked or Action.AuraIsValid(player:CallerId(), "UseDispel", "Magic")
    
    local diseased = MakMulti.party:Find(function(unit) return (unit.diseased or Action.AuraIsValid(unit:CallerId(), "UseDispel", "Disease")) and Purify:InRange(unit) end)
    local magicked = MakMulti.party:Find(function(unit) return (unit.magicked or Action.AuraIsValid(unit:CallerId(), "UseDispel", "Magic")) and Purify:InRange(unit) end)

    if imDiseased and player:TalentKnown(ImprovedPurify.id) then
        HealingEngine.SetTarget(player:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if imMagicked then
        HealingEngine.SetTarget(player:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
    
    if diseased and player:TalentKnown(ImprovedPurify.id) then
        HealingEngine.SetTarget(diseased:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end

    if magicked then
        HealingEngine.SetTarget(magicked:CallerId(), 1)
        Debounce("dispel", 1000, 2500, spell, unit)
    end
end)

VoidShift:Callback("pve", function(spell, unit)
    if not player.inCombat then return end
    if unit.dead then return end
    if unit.isMe then return end

    if unit.hp <= A.GetToggle(2, "voidShiftLowest") and player.hp >= A.GetToggle(2, "voidShiftHighest") then
        return spell:Cast(unit)
    end
end)

PainSuppression:Callback("pve", function(spell, unit)
    if not player.inCombat then return end
	if unit:Buff(buffs.painSuppression) then return end
    if not unit.player then return end

    local weakestPartyMem = MakMulti.party:Lowest(
        function(friendly) return friendly.maxHealth end,
        function(friendly) return PainSuppression:InRange(friendly) and friendly.hp > 0 end
    )

    if A.GetToggle(2, "externalWeak") then
        if shouldDefensive() and weakestPartyMem then
            if not unit:IsUnit(weakestPartyMem) then
                HealingEngine.SetTarget(weakestPartyMem:CallerId(), 1)
            end
            return spell:Cast(unit)
        end
    end

    local tankBuster = MultiUnits:GetByRangeCasting(nil, 1, nil, MakLists.pveTankBuster) > 0
    if tankBuster or (tank and tank.exists and tank.hp > 0 and tank.hp <= 50) then
        if tank and tank.exists and tank.hp > 0 and not tank:BuffFrom(MakLists.Defensive) then
            if not unit:IsUnit(tank) then
                HealingEngine.SetTarget(tank:CallerId(), 1)
            end
            return spell:Cast(unit)
        end
    end
end)

PowerWordShield:Callback("pve-weal", function(spell, unit)
    if unit:Buff(buffs.powerWordShield, true) then return end
    if player:HasBuffCount(buffs.wealAndWoe) < 3 then return end

    local weakestPartyMem = MakMulti.party:Lowest(
        function(friendly) return friendly.maxHealth end,
        function(friendly) return PowerWordShield:InRange(friendly) and friendly.hp > 0 and not friendly:BuffFrom(MakLists.Defensive) end
    )

    if A.GetToggle(2, "externalWeak") then
        if shouldDefensive() and weakestPartyMem then
            if not unit:IsUnit(weakestPartyMem) then
                HealingEngine.SetTarget(weakestPartyMem:CallerId(), 1)
            end
            return spell:Cast(unit)
        end
    end
end)

PowerWordLife:Callback("pve", function(spell, unit)
    if player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp <= 0 then return end
    if unit.hp < 35 then 
        return spell:Cast(unit) 
    end
end)

PowerWordLifeToo:Callback("pve", function(spell, unit)
    if not player:TalentKnown(MiraculousRecovery.id) then return end
    if unit.hp <= 0 then return end
    if unit.hp < 50 then 
        return spell:Cast(unit)
    end
end)

FlashHeal:Callback("ooc-instant", function(spell, unit)
    if player.inCombat then return end
    if spell:CastTime() > 0 then return end
    if unit.ehp > 90 then return end

    return spell:Cast(unit)
end)

Penance:Callback("ooc", function(spell, unit)
    if player.inCombat then return end
    if spell:CastTime() > 0 then return end
    if unit.ehp > 85 then return end

    return spell:Cast(unit)
end)

FlashHeal:Callback("ooc", function(spell, unit)
    if player.inCombat then return end
    if unit.ehp > 90 then return end

    return spell:Cast(unit)
end)

Renew:Callback("ooc", function(spell, unit)
    if player.inCombat then return end
    if unit.ehp <= 90 then return end
    if unit.ehp >= 95 then return end
    if unit:Buff(buffs.renew, true) then return end

    return spell:Cast(unit)
end)

PrayerOfMending:Callback("pve", function(spell, unit)
    if unit:Buff(buffs.prayerOfMending, true) then return end

    local mendingActive = MakMulti.party:Find(function(friendly) return friendly:Buff(buffs.prayerOfMending, true) end)
    if not player:TalentKnown(FocusedMending.id) then
        if mendingActive then return end
    end

    return spell:Cast(unit)
end)

Halo:Callback("pve", function(spell)
    local below80 = getBelowHP(80)

    if below80 < 3 then return end

    return spell:Cast()
end)

Penance:Callback("pve", function(spell, unit)
    if gs.petActive then return end

    local atonementSensitivity = A.GetToggle(2, "atonementSensitivity")
    local directHeal = math.abs(unit.ehp - HealingEngine.GetHealthAVG()) >= atonementSensitivity

    if unit.ehp < A.GetToggle(2, "penanceHP") and directHeal then
        return spell:Cast(unit)
    end
end)

PowerWordShield:Callback("pve", function(spell, unit)
    if unit:Buff(buffs.powerWordShield) then return end

    if unit.isTank or UnitThreatSituation(unit:CallerId()) == 3 and unit.hp > 0 and unit.ehp < 90 then
        return spell:Cast(unit)
    end

    if unit.hp > 0 and unit.ehp < 75 then
        return spell:Cast(unit)
    end

    local needsAtonement = MakMulti.party:Find(function(unit) return PowerWordShield:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 and unit.ehp < 90 end)
    
    if needsAtonement then
        if not unit:IsUnit(needsAtonement) then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
        end
        return spell:Cast(unit)
    end
end)

FlashHeal:Callback("pve", function(spell, unit)
    local atonementSensitivity = A.GetToggle(2, "atonementSensitivity")
    local directHeal = math.abs(unit.ehp - HealingEngine.GetHealthAVG()) >= atonementSensitivity
    
    if directHeal and unit.ehp < A.GetToggle(2, "flashHealHP") then
        return spell:Cast(unit)
    end

    if spell:CastTime() > 0 then return end
    
    local needsAtonement = MakMulti.party:Find(function(unit) return FlashHeal:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 and unit.ehp < 90 end)
    
    if needsAtonement then
        if not unit:IsUnit(needsAtonement) then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
        end
        return spell:Cast(unit)
    end
end)

Renew:Callback("pve", function(spell, unit)
    if unit:Buff(buffs.atonement, true) then return end
    if not player.combat then return end

    if unit.ehp < 90 and PowerWordRadiance.frac < 1 then
        return spell:Cast(unit)
    end

    local needsAtonement = MakMulti.party:Find(function(unit) return Renew:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 and unit.ehp < 90 end)
    
    if needsAtonement then
        if not unit:IsUnit(needsAtonement) then
            HealingEngine.SetTarget(needsAtonement:CallerId(), 1)
        end
        return spell:Cast(unit)
    end

    local atoneAnyone = MakMulti.party:Find(function(unit) return Renew:InRange(unit) and not unit:Buff(buffs.atonement, true) and unit.hp > 0 end)
    if player.moving then
        if atoneAnyone then
            if not unit:IsUnit(atoneAnyone) then
                HealingEngine.SetTarget(atoneAnyone:CallerId(), 1)
            end
            return spell:Cast(unit)
        end
    end
end)


local function inPvP()
  if Action and Action.Zone then return Action.Zone == "arena" end
  if A and A.IsInPvP ~= nil then return A.IsInPvP end
  return false
end

local function spellReady(spell)
  -- Works even if :IsReady() doesn't exist in your build
  if spell.Cooldown and spell:Cooldown() > 0 then return false end
  return true
end

-- -------- Power Word: Radiance — PvE/PvP smart usage --------
PowerWordRadiance:Callback("smart", function(spell)
  local isCh = (player.IsChanneling and player:IsChanneling()) or player.channeling
  if isCh then return end
  if player:Debuff(410201) then return end
  if not spellReady(spell) then return end

  -- charges (support multiple APIs)
  local charges = (spell.Charges and spell:Charges())
               or spell.charges
               or (spell.GetSpellCharges and spell:GetSpellCharges())
               or 0
  if not charges or charges <= 0 then return end

  -- Waste No Time buff (optional)
  local WNT_ID = (A and A.WasteNoTime and (A.WasteNoTime.ID or A.WasteNoTime.id)) or 0
  local hasWNT = (WNT_ID ~= 0) and (player:BuffRemains(WNT_ID, true) > 0) or false

  -- Healing engine shortcut
  local below = HealingEngine.GetBelowHealthPercentUnits
  local pvp = inPvP()

  if not pvp then
    -- ===== PvE =====
    if charges >= 2 then
      -- ≥3 allies @ ≤92%
      if below(92) >= 3 then
        return spell:Cast(player)
      end
    else -- charges == 1
      -- ≥3 allies @ ≤75%
      if below(75) >= 3 then
        return spell:Cast(player)
      end
    end
  else
    -- ===== PvP =====
    if charges >= 2 then
      -- (≥2 @ ≤80%) OR (WNT & ≥2 @ ≤90%)
      if (below(80) >= 2) or (hasWNT and below(90) >= 2) then
        return spell:Cast(player)
      end
    else -- charges == 1
      -- (≥2 @ ≤70%) OR (WNT & ≥2 @ ≤80%)
      if (below(70) >= 2) or (hasWNT and below(80) >= 2) then
        return spell:Cast(player)
      end
    end
  end
end)




local function pveHealing(unit)
    Purify("pve", unit)
    VoidShift("pve", unit)
    PainSuppression("pve", unit)
    PowerWordShield("pve-weal", unit)
    PowerWordLife("pve", unit)
    PowerWordLifeToo("pve", unit)
    PowerWordRadiance("smart")
    PremonitionofInsight("temp")
    PremonitionofPiety("temp")
    PremonitionofSolace("temp")
    PremonitionofClairvoyance("temp")
    dungeon(unit)
    raid(unit)
    FlashHeal("ooc-instant", unit)
    Penance("ooc", unit)
    FlashHeal("ooc", unit)
    Renew("ooc", unit)
    Halo("pve")
    Penance("pve", unit)
    PowerWordShield("pve", unit)
    FlashHeal("pve", unit)
    Renew("pve", unit)
    PrayerOfMending("pve", unit)
end

--------------------------------------------
---Open World Pet Spells-------------------

Shadowfiend:Callback("general", function(spell)
    if gs.petNotReady then return end
    if gs.petDuration > 0 then return end
    if not target.exists or target.isFriendly then return end
    if target.ttd < 8000 then return end

    -- Prioritize Voidwraith if talented
    if player:TalentKnown(VoidwraithTalent.id) then return end

    -- Use for mana efficiency in solo content
    -- TODO look to add slider for this
    if Player:ManaPercentage() < 70 then
        return spell:Cast()
    end
end)

Mindbender:Callback("general", function(spell)
    if gs.petNotReady then return end
    if gs.petDuration > 0 then return end
    if not target.exists or target.isFriendly then return end
    if target.ttd < 6000 then return end

    -- Don't use if Voidwraith is talented (higher priority)
    if player:TalentKnown(VoidwraithTalent.id) then return end

    -- Don't use if Shadowfiend is not talented (Shadowfiend is baseline)
    if not player:TalentKnown(Mindbender.id) then return end

    -- Prioritize mana efficiency - Mindbender has shorter CD than Shadowfiend
    -- TODO look to add slider for this
    if Player:ManaPercentage() < 60 then
        return spell:Cast()
    end
end)

Voidwraith:Callback("general", function(spell)
    if gs.petNotReady then return end
    if gs.petDuration > 0 then return end
    if not player:TalentKnown(VoidwraithTalent.id) then return end
    if not target.exists or target.isFriendly then return end
    if target.ttd < 5000 then return end

    -- Use for sustained damage and mana return - most aggressive usage
    -- TODO look to add slider for this
    if Player:ManaPercentage() < 80 then
        return spell:Cast()
    end
end)

--------------------------------------------
---PvE Damage-------------------------------

ShadowWordDeath:Callback("absorb", function(spell)
    if not player:TalentKnown(DevourMatter.id) then return end
    if UnitGetTotalAbsorbs(target:CallerId()) <= 0 then return end

    return spell:Cast(target)
end)

ShadowWordPain:Callback(function(spell)
    if target:Debuff(debuffs.shadowWordPain, true) then return end

    return spell:Cast(target)
end)

PenanceDmg:Callback("spreadDot", function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    if gs.activeEnemies > gs.swpEnemies then
        return spell:Cast(target)
    end
end)

MindBlast:Callback(function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast(target)
end)

PenanceDmg:Callback(function(spell)
    if gs.imCasting and gs.imCasting == spell.id then return end

    return spell:Cast(target)
end)

ShadowWordDeath:Callback("execute", function(spell)
    if target.hp > 20 and not player.moving then return end

    return spell:Cast(target)
end)

Smite:Callback(function(spell)

    return spell:Cast(target)
end)

local function damage()
    -- Pet spells for open world content (highest priority)
    Shadowfiend("general")
    Mindbender("general")
    Voidwraith("general")

    -- Standard damage rotation
    ShadowWordDeath("absorb")
    ShadowWordPain()
    PenanceDmg("spreadDot")
    MindBlast()
    PenanceDmg()
    ShadowWordDeath("execute")
    Smite()
end

--------------------------------------------
---Arena------------------------------------
--------------------------------------------

InnerLight:Callback("swap", function(spell)
    if player.combatTime > 0 and player.mana < 20 and not player:Buff(buffs.innerLight) and getBelowHP(50) == 0 then
        return spell:Cast(player)
    end

    if player.combatTime > 0 and player.mana > 20 and player:Buff(buffs.innerLight) and getBelowHP(50) == 0 then
        return spell:Cast(player)
    end

    if player.combatTime == 0 and not player:Buff(buffs.innerLight) and not player:Buff(buffs.innerShadow) then
        return spell:Cast(player)
    end

    if player.combatTime == 0 and player:Buff(buffs.innerLight) and not player:Buff(buffs.innerShadow) then
        return spell:Cast(player)
    end
end)

Fade:Callback("arena", function(spell)
    local castOrChannelAone = arena1.castOrChannelInfo
    local castOrChannelAtwo = arena2.castOrChannelInfo
    local castOrChannelAthree = arena3.castOrChannelInfo
    if Action.Zone ~= "arena" then return end
    if player:Buff(buffs.ultimatePentience) then return end
    if not IsPlayerSpell(PhaseShift.id) then return end
    if arena1.exists and arena1:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAone.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena1", "White", 1) end
            return spell:Cast(player)
        end
    end

    if arena2.exists and arena2:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAtwo.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena2", "White", 1) end
            return spell:Cast(player)
        end
    end

    if arena3.exists and arena3:CastingFromFor(MakLists.arenaFadeList, 420) then
        if castOrChannelAthree.percent >= 60 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting fade to counter incoming CC from Arena3", "White", 1) end
            return spell:Cast(player)
        end
    end
end)

PsychicScream:Callback("arena", function(spell)
    if getBelowHP(40) > 0 then return end
    if player:Debuff(410201) then return end -- searing glare
    if player.combatTime == 0 then return end
    if not enemyHealer.exists then return end
    if enemyHealer.distance <= 3 and not enemyHealer.totalImmune and not enemyHealer.magicImmune and not enemyHealer.ccImmune and enemyHealer.ccRemains < 1000 and enemyHealer.disorientDr >= .5 and not enemyHealer:Debuff(203337) then
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting Psychic Scream on enemy healer", "White", 1) end
        return spell:Cast(player)
    end

    --[[if arena1.exists and arena1:IsHealer() and arena1.distance <= 5 and not arena1.totalImmune and not arena1.magicImmune and not arena1.ccImmune and arena1.ccRemains < 1 and arena1.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena2)", "White", 1)
        return spell:Cast(player)
    end

    if arena2.exists and arena2:IsHealer() and arena2.distance <= 5 and not arena2.totalImmune and not arena2.magicImmune and not arena2.ccImmune and arena2.ccRemains < 1 and arena2.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena2)", "White", 1)
        return spell:Cast(player)
    end

    if arena3.exists and arena3:IsHealer() and arena3.distance <= 5 and not arena3.totalImmune and not arena3.magicImmune and not arena3.ccImmune and arena3.ccRemains < 1 and arena3.disorientDr >= .5 then
        Aware:displayMessage("Casting Psychic Scream on enemy healer (arena3)", "White", 1)
        return spell:Cast(player)
    end]]
end)

MassDispel:Callback("arena", function(spell)
    if getBelowHP(60) > 0 then return end
    if arena1.exists and arena1.distance < 40 and (arena1:Debuff(45438) or arena1:Debuff(642)) then
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Mass Dispel Arena1.. Please place it.", "Red", 1) end
        return spell:Cast(player)
    end

    if arena2.exists and arena2.distance < 40 and (arena2:Debuff(45438) or arena2:Debuff(642)) then
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Mass Dispel Arena2.. Please place it.", "Red", 1) end
        return spell:Cast(player)
    end

    if arena3.exists and arena3.distance < 40 and (arena3:Debuff(45438) or arena3:Debuff(642)) then
        if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Mass Dispel Arena3.. Please place it.", "Red", 1) end
        return spell:Cast(player)
    end
end)

PremonitionofInsight:Callback("arena", function(spell)
    if getBelowHP(95) < 1 then return end
    if player.combatTime == 0 then return end

    return spell:Cast(player)
end)

PremonitionofPiety:Callback("arena", function(spell)
    if getBelowHP(80) < 1 then return end
    if (gs.burstCount < 1 or getBelowHP(60) < 1) then return end

    return spell:Cast(player)
end)

PremonitionofSolace:Callback("arena", function(spell)
    if getBelowHP(80) < 1 then return end
    if (gs.burstCount < 1 or getBelowHP(60) < 1) then return end

    return spell:Cast(player)
end)

PremonitionofClairvoyance:Callback("arena", function(spell)
    if getBelowHP(80) < 1 then return end
    if (gs.burstCount < 1 or getBelowHP(60) < 1) then return end

    return spell:Cast(player)
end)

PenanceDmg:Callback("insight", function(spell, enemy)
    if getBelowHP(70) < 1 then return end
    if not focus:Buff(buffs.atonement, true) then return end
    if not player:Buff(buffs.premOfInsight) then return end

    return spell:Cast(enemy)
end)

PowerWordLife:Callback("arena", function(spell, friendly)
    if IsPlayerSpell(MiraculousRecovery.id) then return end
    if friendly.hp <= 0 then return end
    if friendly.hp < 35 then 
        return spell:Cast(friendly) 
    end
end)

PowerWordLifeToo:Callback("arena", function(spell, friendly)
    if not IsPlayerSpell(MiraculousRecovery.id) then return end
    if friendly.hp <= 0 then return end
    if friendly.hp < 50 then 
        return spell:Cast(friendly) 
    end
end)

Evangelism:Callback("arena", function(spell)
    if not focus:Buff(buffs.atonement, true) then return end
    if VoidShift:Used() > 0 and VoidShift:Used() < 3000 then return end
    if focus:IsUnit(player) and player.hp > 30 then return end
    if focus.hp < 50 then
        return spell:Cast(player)
    end
end)

PainSuppression:Callback("arena", function(spell, friendly)
    if not shouldPS(friendly) then return end
    if friendly.hp <= 0 then return end
    if friendly:BuffRemains(buffs.painSuppression) > 1500 then return end
    if VoidShift:Used() > 0 and VoidShift:Used() < 3000 then return end
    if gs.painCharges == 2 and friendly.hp < 75 and gs.burstCount >= 1 then
        return spell:Cast(friendly)
    end

    if friendly.hp < 50 then
        return spell:Cast(friendly)
    end
end)

PowerWordRadiance:Callback("arena", function(spell, friendly)
    if not FlashHeal:InRange(friendly) then return end
    if friendly.hp > 50 then return end

    return spell:Cast(friendly)
end)

PowerWordShield:Callback("arena", function(spell, friendly)
    if getPowerWordShieldAbsorption(friendly:CallerId()) > 75000 then return end
    if friendly.hp > 95 then return end

    return spell:Cast(friendly)
end)

PowerWordShield:Callback("arenaGates", function(spell)
    if player.combatTime > 0 then return end
    if player:Buff(32727) then return end
    if PowerWordShield:Cooldown() > 0 then return end

    if party1.exists and not party1:Buff(buffs.powerWordShield) then
        HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    end

    if party2.exists and not party2:Buff(buffs.powerWordShield) then
        HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    else
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

Renew:Callback("arenaGates", function(spell)
    if player.combatTime > 0 then return end
    if player:Buff(32727) then return end
    if Renew:Cooldown() > 0 then return end

    if party1.exists and not party1:Buff(buffs.renew) then
        HealingEngine.SetTarget(party1:CallerId(), 1)
        return spell:Cast(party1)
    end

    if party2.exists and not party2:Buff(buffs.renew) then
        HealingEngine.SetTarget(party2:CallerId(), 1)
        return spell:Cast(party2)
    elseif not player:Buff(buffs.renew) then
        HealingEngine.SetTarget(player:CallerId(), 1)
        return spell:Cast(player)
    end
end)

FlashHeal:Callback("arena", function(spell, friendly)
    if friendly.hp > 80 then return end
    if not player:Buff(buffs.surgeOfLight) then return end

    return spell:Cast(friendly)
end)

PowerWordRadiance:Callback("arena2", function(spell, friendly)
    if gs.radianceCharges < 2 then return end
    if not FlashHeal:InRange(friendly) then return end
    if friendly.ehp > 75 then return end

    return spell:Cast(friendly)
end)

Penance:Callback("arena", function(spell, friendly)
    if friendly.ehp > 65 then return end
    if not Penance:InRange(friendly) then return end

    return spell:Cast(friendly)
end)

UltimatePenitence:Callback("arena", function(spell, friendly)
    if not FlashHeal:InRange(friendly) then return end
    if friendly.hp > 65 then return end

    return spell:Cast(friendly)
end)

FlashHeal:Callback("arena2", function(spell, friendly)
    if player.moving then return end
    if friendly.ehp >= 65 then return end

    return spell:Cast(friendly)
end)

FlashHeal:Callback("arenat", function(spell, friendly)
    if player.moving then return end
    if friendly.ehp >= 80 then return end

    return spell:Cast(friendly)
end)

Renew:Callback("arena", function(spell, friendly)
    if PowerWordShield:Cooldown() < 4000 then return end
    if friendly:Buff(buffs.renew) then return end
    if friendly.ehp > 90 then return end

    return spell:Cast(friendly)
end)

---------------------------------------------------
----------------DAMAGE CALLS---------------
---------------------------------------------------

ShadowWordDeath:Callback("arena", function(spell, target)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if target.hp > 20 then return end

    return spell:Cast(target)
end)

Mindgames:Callback("arena", function(spell, target)
    if not CanAttackTarget() then return end
    if target.hp > 50 then return end
    if player.moving then return end

    return spell:Cast(target)
end)

Shadowfiend:Callback("arena", function(spell)
    if gs.petNotReady then return end
    if player:Debuff(410201) then return end
    if player:TalentKnown(VoidwraithTalent.id) then return end
    if player:TalentKnown(Mindbender.id) then return end

    if Player:ManaPercentage() < 90 then return end
    return spell:Cast()
end)

Mindbender:Callback("arena", function(spell)
    if gs.petNotReady then return end
    if getBelowHP(50) > 0 then return end
    if player:TalentKnown(VoidwraithTalent.id) then return end

    if Player:ManaPercentage() < 100 then return end
    return spell:Cast()
end)

Voidwraith:Callback('arena', function(spell)
    if gs.petNotReady then return end
    if not player:TalentKnown(VoidwraithTalent.id) then return end

    if Player:ManaPercentage() < 90 then return end
    return spell:Cast()
end)

PenanceDmg:Callback("arena", function(spell)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if getBelowHP(95) < 1 then return end

    return spell:Cast(target)
end)

ShadowWordPain:Callback("arena", function(spell, target)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if target.ccRemains > 1000 then return end
    if target:DebuffRemains(debuffs.shadowWordPain, true) >= 3000 then return end

    return spell:Cast(target)
end)

MindBlast:Callback("arena", function(spell, target)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if player.moving then return end

    return spell:Cast(target)
end)

Smite:Callback("arena", function(spell, target)
    if player:Debuff(410201) then return end
    if not CanAttackTarget() then return end
    if player.moving then return end

    return spell:Cast(target)
end)

MindBlast:Callback("entropicRift", function(spell, target)
    if not player:TalentKnown(447444) then return end  

    if player:Debuff(410201) or player.channeling or player.moving then return end  
    if not (target and target.exists and not target.isFriendly and spell:InRange(target)) then return end  

    -- Cast Mind Blast to trigger Entropic Rift
    return spell:Cast(target)
end)



local function arenaHealingRotation()
    local holdGCDforSWDE = holdGCDforSWD()
    Fade("arena")
    if player.channeling then return end
    local unitID = nil
    if target.exists and target.isFriendly then
        unitID = target
    elseif focus.exists and focus.isFriendly then
        unitID = focus
    else
        return
    end
    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling

    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end
    if holdGCDforSWDE then return end
    
    PowerWordShield("arenaGates")
    Renew("arenaGates")
    --Archangel("arena", unitID)
    PsychicScream("arena")
    MassDispel("arena")
    --FlashHeal("arenat", unitID)
    PowerWordRadiance("smart")
    PremonitionofInsight("arena")
    PremonitionofPiety("arena")
    PremonitionofSolace("arena")
    PremonitionofClairvoyance("arena")
    PowerWordLife("arena", unitID)
    PowerWordLifeToo("arena", unitID)
    Evangelism("arena")
    PainSuppression("arena", unitID)
    PowerWordShield("arena", unitID)
    PenanceDmg("insight", target)
    Mindbender("arena", unitID)
    MindBlast("entropicRift", unitID)
    PowerWordRadiance("arena", unitID)
    FlashHeal("arena", unitID)
    PowerWordRadiance("arena2", unitID)
    Penance("arena", unitID)
    UltimatePenitence("arena", unitID)
    FlashHeal("arena2", unitID)
    Renew("arena", unitID)

end

local function arenaDamageRotation(unitID)
    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling
    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end
    if player.channeling then return end

    ShadowWordDeath("arena", unitID)
    Shadowfiend("arena", unitID)
    Mindbender("arena", unitID)
    Voidwraith("arena", unitID)
    ShadowWordPain("arena", unitID)
    MindBlast("arena", unitID)
    PenanceDmg("arena", unitID)
    Smite("arena", unitID)
    Mindgames("arena", unitID)

end



A[3] = function(icon)
    FrameworkStart(icon)
    SetUpHealers()
    updategs()
    calculateHealTarget()
    --doTheRamp()

    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling

    if A.GetToggle(2, "makDebug") then
        MakPrint(1, "incBigDmgIn: ", incBigDmgIn())
        MakPrint(2, "Get Total Absorbs: ", UnitGetTotalAbsorbs(target:CallerId()))
        MakPrint(3, "PWR Used: ", PowerWordRadiance.used)
        MakPrint(4, "Is Pet Active: ", gs.petActive)
        MakPrint(5, "Pet Duration: ", gs.petDuration)
        MakPrint(6, "Pet Not Ready: ", gs.petNotReady)
        MakPrint(7, "Ramp Tracker: ", gs.rampTracker)
        MakPrint(8, "Blastburn Roarcannon: ", makRamp({472233}))
        MakPrint(9, "Colossal Clash: ", makRamp({465833}))
        MakPrint(10, "Echoing Chant: ", makRamp({466866}))
    end
    
    if player.channeling then return end
    if castingUP then return end

    if Action.Zone == "arena" then
        if not player:Buff(buffs.ultimatePenitence) and not player.channeling and getBelowHP(30) == 0 then
            FakeCasting.gglFakeCast(icon)
        end
    end

    defensives()

    local healUnit = target.isFriendly and target or focus.isFriendly and focus or player
    if A.Zone ~= "arena" then
        makInterrupt(interrupts)

        pveHealing(healUnit)
        util(healUnit)

        if target.exists and not target.isFriendly then
            damage()
        end
    else
        InnerLight("swap")
        Fade("arena")
        PowerWordFortitude()

        if target.exists or focus.exists then
            arenaHealingRotation()
        end

        if target.exists and not target.isFriendly then
            arenaDamageRotation(target)
        end
    end

    return FrameworkEnd()
end

ShadowWordDeath:Callback("arenap", function(spell, enemy)
    local castOrChannel = enemy.castOrChannelInfo
    if (IsPlayerSpell(PhaseShift.id) and Fade:Cooldown() == 0) then return end
    if player:Buff(408558) then return end
    if enemy.exists and enemy:CastingFromFor(MakLists.swdList, 420) then
        if castOrChannel.percent >= 50 then
            if A.GetToggle(2, "makArenaAware") then Aware:displayMessage("Casting SW:D to counter incoming CC", "Blue", 1) end
            return spell:Cast(player)
        end
    end
end)

ShadowWordDeath:Callback("arena2", function(spell, enemy)
    if not CanAttackTarget() then return end
    if enemy.hp > 20 then return end

    return spell:Cast(enemy)
end)

ShadowWordPain:Callback("arenap", function(spell, enemy)
    if getBelowHP(70) > 0 then return end
    if PowerWordShield:Cooldown() < 1000 then return end
    if enemy.ccImmune or enemy.magicImmune then return end
    if enemy.distance > 40 then return end
    if enemy.ccRemains > 1000 then return end
    if enemy:DebuffRemains(debuffs.shadowWordPain, true) >= 2000 then return end

    return spell:Cast(enemy)
end)

DispelMagic:Callback("arenap", function(spell, enemy)
    if getBelowHP(70) > 0 then return end
    --if enemy.hp > 50 then return end
    --if PowerWordShield:Cooldown() < 2000 then return end
    if enemy:HasBuffFromFor(MakLists.purgeableBuffs, 500) then
        return spell:Cast(enemy)
    end
end)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local enemyRotation = function(enemy)
    local holdGCDforSWDPE = holdGCDforSWDP()
    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling

    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end
    if player:Debuff(410201) then return end
    if player.channeling then return end
	if not enemy.exists then return end
    ShadowWordDeath("arenap", enemy)
    ShadowWordDeath("arena2", enemy)
    if not holdGCDforSWDPE then
        DispelMagic("arenap", enemy)
        ShadowWordPain("arenap", enemy)
    end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---### PARTY ROTATION ###
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

VoidShift:Callback("arenap", function(spell, friendly)
    if friendly.isMe then return end
    if friendly.hp < 25 and player.hp > 60 and not friendly.totalImmune then
        return spell:Cast(friendly)
    end

    if player.hp < 35 and friendly.hp > 60 then
        return spell:Cast(friendly)
    end

end)

Purify:Callback("arenap", function(spell, friendly)
    if getBelowHP(50) > 0 then return end
    if friendly:Debuff(30108) or friendly:Debuff(316099) then return end -- UA
    if friendly:HasDeBuffFromFor(MakLists.arenaDispelDebuffs, 500) then
        return spell:Cast(friendly)
    end
end)

PowerInfusionP:Callback("arenap", function(spell, friendly)
    if player.combatTime == 0 then return end
    if not target.canAttack then return end
    if target.distance > 40 then return end
    if friendly:HasBuffFromFor(MakLists.DPSCooldownList, 777) then
        return spell:Cast(friendly)
    end
end)


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local partyRotation = function(friendly)
    local holdGCDforSWDP = holdGCDforSWD()
    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling

    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end
    if player.channeling then return end
    if not friendly.exists then return end
    if holdGCDforSWDP then return end
    PowerInfusionP("arenap", friendly)
    VoidShift("arenap", friendly)
    Purify("arenap", friendly)

end

--################################################################################################################################################################################################################


A[6] = function(icon)
    --Multi Dot
    --if GetToggle(2, "SpreadDot") and not Unit("target"):IsBoss() and Unit("target"):HasDeBuffs(A.ShadowWordPain.ID, true) > 0 and (Player:GetDeBuffsUnitCount(A.ShadowWordPain.ID, true) < MultiUnits:GetActiveEnemies()) then
       -- return A.TargetEnemy:Show(icon)
    --end

    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling



    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end

	RegisterIcon(icon)

    if Action.Zone == "arena" then 
        partyRotation(party1)
	    enemyRotation(arena1)
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[7] = function(icon)
	RegisterIcon(icon)

    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling



    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end

    if Action.Zone == "arena" then
        partyRotation(party2)
	    enemyRotation(arena2)
    end

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[8] = function(icon)
	RegisterIcon(icon)

    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling



    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end



	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[9] = function(icon)
	RegisterIcon(icon)


	--partyRotation(party4)
        

	return FrameworkEnd()
end

--################################################################################################################################################################################################################

A[10] = function(icon)
	RegisterIcon(icon)

    local playerCast = player.castInfo
    local castingUP = gs.imCasting and gs.imCasting == UltimatePenitence.id or UltimatePenitence.used < 1000 or player.channeling



    if castingUP then return end
    if player:Buff(buffs.ultimatePentience) then return end

    if Action.Zone == "arena" then
        partyRotation(player)
    end

	return FrameworkEnd()
end
