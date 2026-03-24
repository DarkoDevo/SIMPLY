local FrameworkStart = MakuluFramwork.start
local FrameworkEnd   = MakuluFramwork.endFunc
local RegisterIcon   = MakuluFramwork.registerIcon

local benchMarkTime  = _G.debugprofilestop
if type(benchMarkTime) ~= "function" then
    local gtp = _G.GetTimePreciseSec
    if type(gtp) == "function" then
        benchMarkTime = function() return gtp() * 1000 end
    else
        benchMarkTime = function() return _G.GetTime() * 1000 end
    end
end
local AtoL           = MakuluFramework.AtoL

local Spell          = MakuluFramwork.Spell
local MakUnit        = MakuluFramwork.Unit
local MakMulti       = MakuluFramwork.MultiUnits
local MakParty       = MakuluFramwork.Party
local MakEnemy       = MakuluFramwork.Enemies
local MakLists       = MakuluFramwork.lists
local TableToLocal   = MakuluFramwork.tableToLocal
local MakGcd         = MakuluFramwork.gcd
local AtoL           = MakuluFramework.AtoL
local Lists          = MakuluFramework.lists
local ConstUnits     = MakuluFramework.ConstUnits
local Debounce       = MakuluFramework.debounceSpell
local Aware          = MakuluFramework.Aware

local target         = ConstUnits.target
local healer         = ConstUnits.healer
local player         = ConstUnits.player
local enemyHealer    = ConstUnits.enemyHealer

local GetSpellTexture = C_Spell.GetSpellTexture


local arenaKicks            = Lists.arenaKicks
local Action                = _G.Action

local A                     = {}

-- General Death Knight abilities
local DeathCoil             = Spell:new(47541, {}, nil, A)
local DeathCoilPlayer       = Spell:new(98008, { texture = 237586 }, nil, A)
local DeathCoilPet          = Spell:new(213690, { texture = 132179 }, nil, A)
local HeartStrike           = Spell:new(206930, { action = {}, damageType = "physical" }, nil, A)
local DeathandDecay         = Spell:new(43265, {}, nil, A)
local DeathGrip             = Spell:new(49576, {}, nil, A)
local Lichborne             = Spell:new(49039, {}, nil, A)
local DeathsAdvance         = Spell:new(48265, {}, nil, A)
local DarkCommand           = Spell:new(56222, {}, nil, A)
local RaiseAlly             = Spell:new(61999, {}, nil, A)
local PathofFrost           = Spell:new(3714, {}, nil, A)
local ChainsofIce           = Spell:new(45524, { damageType = "magic" }, nil, A)
local DeathStrike           = Spell:new(49998, { damageType = "physical" }, nil, A)
local RaiseDead             = Spell:new(46585, { offGcd = true }, nil, A)
local MindFreeze            = Spell:new(47528, { offGcd = true }, nil, A)
local AntiMagicShell        = Spell:new(48707, { offGcd = true, action = { Texture = 77606 }, heal = true }, nil, A)
local BlindingSleet         = Spell:new(207167, {}, nil, A)
local SacrificialPact       = Spell:new(327574, {}, nil, A)
local ControlUndead         = Spell:new(111673, {}, nil, A)
local IceboundFortitude     = Spell:new(48792, {}, nil, A)
local AntiMagicZone         = Spell:new(51052, {}, nil, A)
local Asphyxiate            = Spell:new(108194, {}, nil, A)
local DeathPact             = Spell:new(48743, {}, nil, A)
local WraithWalk            = Spell:new(212552, {}, nil, A)
local EmpowerRuneWeapon     = Spell:new(47568, {}, nil, A)
local AbominationLimb       = Spell:new(383312, {}, nil, A)
local SoulReaper            = Spell:new(343294, { damageType = "magic" }, nil, A)

-- Blood specialization abilities
local Marrowrend            = Spell:new(195182, { damageType = "physical" }, nil, A)
local BloodBoil             = Spell:new(50842, {}, nil, A)
local VampiricBlood         = Spell:new(55233, { offGcd = true, heal = true }, nil, A)
local DeathsCaress          = Spell:new(195292, {}, nil, A)
local RuneTap               = Spell:new(194679, {}, nil, A)
local DancingRuneWeapon     = Spell:new(49028, {}, nil, A)
local Blooddrinker          = Spell:new(206931, {}, nil, A)
local Consumption           = Spell:new(274156, {}, nil, A)
local BloodTap              = Spell:new(221699, {}, nil, A)
local MarkofBlood           = Spell:new(206940, {}, nil, A)
local Tombstone             = Spell:new(219809, {}, nil, A)
local GorefiendsGrasp       = Spell:new(108199, {}, nil, A)
local Bonestorm             = Spell:new(194844, {}, nil, A)
local ReapersMark           = Spell:new(439843, {}, nil, A)

-- PvP abilities
local DeathChain            = Spell:new(203173, {}, nil, A)
local Strangulate           = Spell:new(47476, {}, nil, A)
local DarkSimulacrum        = Spell:new(77606, {}, nil, A)
local PVPTaunt              = Spell:new(207018, {}, nil, A)

-- Talents/Passives (Hidden)
local Heartbreaker          = Spell:new(221536, { hidden = true }, nil, A)
local ShatteringBone        = Spell:new(377640, { hidden = true }, nil, A)
local SanguineGround        = Spell:new(391458, { hidden = true }, nil, A)
local UnholyGround          = Spell:new(374265, { hidden = true }, nil, A)
local InsatiableBlade       = Spell:new(377637, { hidden = true }, nil, A)
local TighteningGrasp       = Spell:new(206970, { hidden = true }, nil, A)
local UnholyEndurance       = Spell:new(389682, { hidden = true }, nil, A)

-- Buffs/Debuffs (Hidden)
local BoneShield            = Spell:new(195181, { hidden = true }, nil, A)
local Coagulopathy          = Spell:new(391481, { hidden = true }, nil, A)
local IcyTalons             = Spell:new(194879, { hidden = true }, nil, A)
local DeathandDecayBuff     = Spell:new(188290, { hidden = true }, nil, A)
local Hemostasis            = Spell:new(273947, { hidden = true }, nil, A)
local UnholyStrength        = Spell:new(53365, { hidden = true }, nil, A)
local DancingRuneWeaponBuff = Spell:new(81256, { hidden = true }, nil, A)
local VampiricStrength      = Spell:new(408356, { hidden = true }, nil, A)
local CrimsonScourge        = Spell:new(81141, { hidden = true }, nil, A)
local BloodPlague           = Spell:new(55078, { hidden = true }, nil, A)
local SoulReaperDebuff      = Spell:new(343294, { hidden = true }, nil, A)


A = setmetatable(A, { __index = Action })

Action[ACTION_CONST_DEATHKNIGHT_BLOOD] = A

local buffs = {
        boneShield = 195181,
        crimsonScourge = 81141,
        hemostasis = 273947,
        dancingRuneWeapon = 81256,
        wraithWalk = 212552,
        abominationLimb = 383269,
        ashenDecay = 425721,
        sanguineGround = 391459,
        deathAndDecay = 188290,
        coagulapth = 391481,
        runeTap = 194679,
        heartRend = 377656,
        exterminate = 441416,
        bloodsheild = 77535,
        bloodQueen = 433925
}

local debuffs = {
        gripOfDeath = 273977,
        chainsOfIce = 45524,
        bloodPlague = 55078,
        ashenDecay = 425719,
        focussAssault = 206891,
}

local kickPercent = 32
local meldDuration = 0.9
local shortHalfSecond = 0.5
local channelKickTime = 400
local autoAttackDelay = 0.5
local quickKick = 15

local function generateNewRandomKicks()
        kickPercent = math.random(40, 90)
        meldDuration = math.random(600, 1200) / 1000
        shortHalfSecond = math.random(400, 600) / 1000
        channelKickTime = math.random(300, 800)
        quickKick = math.random(10, 20)

        autoAttackDelay = math.random(600, 1200) / 1000

        return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()

local function timeToRuneCount(desired)
        local start, duration, runeReady = GetRuneCooldown(desired)
        if runeReady then
                return 0
        end

        return ((start + duration) - TMW.time) * 1000
end

local damKickList = AtoL({
        "Chaos Bolt",
        "Lava Burst",
        "Haunt",
        "Mind Flay: Insanity",
        "Unstable Affliction",
        "Crackling Jade Lightning",
        "Soul Rot",
        "Stormkeeper",
        "Lightning Lasso",
        "Full Moon",
        "Ray of Frost",
        "Frostfire Bolt",
        "Vampiric Touch",
        "Hand of Gul'dan",
        "Disintegrate",
        "Void Torrent",
})

MindFreeze:Callback("single", function(spell, unit)
        if not unit.exists then return end
        if not unit.player then return end

        local castOrChannel = unit.castOrChannelInfo
        if not castOrChannel then return end -- Ensure castOrChannelInfo exists

        if not arenaKicks[castOrChannel.spellId] then
                if unit.isHealer then return end
                if not damKickList[castOrChannel.name] then return end
        end

        if not castOrChannel.channel and castOrChannel.percent < kickPercent then return end
        if castOrChannel.channel and castOrChannel.elapsed < channelKickTime then return end

        Aware:displayMessage("Kicking  " .. unit.name .. " to interrupt " .. castOrChannel.name, 'DeathKnight', 1.5, GetSpellTexture(spell.id))
        return spell:Cast(unit)
end)

SoulReaper:Callback(function(spell, enemy)
        if not target.bigButtons then return end
        return spell:Cast(enemy)
end)

SoulReaper:Callback("low", function(spell, enemy)
        if not target.bigButtons then return end
        if not player:Buff(buffs.sanguineGround) then return end

        if enemy.hp > 45 then return end
        Aware:displayMessage("Big Soul Reaper Explode?", 'DeathKnight', 1.5, GetSpellTexture(spell.id))
        return spell:Cast(enemy)
end)

SoulReaper:Callback("proc", function(spell, enemy)
        if not target.bigButtons then return end
        if not player:Buff(buffs.sanguineGround) then return end

        if not IsSpellOverlayed(spell.id) then return end

        Aware:displayMessage("Big Soul Reaper Proc", 'DeathKnight', 1.5, GetSpellTexture(spell.id))
      
        return spell:Cast(enemy)
end)


DeathandDecay:Callback(function(spell)
        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end
        if player:Buff(buffs.deathAndDecay) then return end
        if target.magicImmune or target.totalImmune then return end

        return spell:Cast(player)
end)

PVPTaunt:Callback(function(spell)
        if not target.bigButtons then return end

        if not player:TalentKnown(207018) then return end

        if target:Debuff(debuffs.focussAssault) then return end
        if target.physImmune then return end

        return spell:Cast(target)
end)

DeathStrike:Callback("coagulapth", function(spell)
        if not target.bigButtons then return end
        
        if not player:TalentKnown(433901) then return end

        if player:BuffRemains(buffs.coagulapth) > 2000 then return end

        return spell:Cast(target)
end)

DeathStrike:Callback("capping", function(spell)
        if not target.bigButtons then return end
        
        if player.runicPower < 70 then return end

        return spell:Cast(target)
end)

DeathStrike:Callback("bigdam", function(spell)
        if not target.bigButtons then return end

        if not player:Buff(buffs.sanguineGround) then return end
        if not player:Buff(buffs.hemostasis) and player.runicPower < 90 then return end

        return spell:Cast(target)
end)

DeathStrike:Callback("heartRend", function(spell)
        if not target.bigButtons then return end

        if not player:HasBuff(buffs.heartRend) then return end
        return spell:Cast(target)
end)

DeathStrike:Callback("panic", function(spell)
        if player.hp > 40 then return end

        Aware:displayMessage("Death Strike Panic", 'DeathKnight', 1.5, GetSpellTexture(spell.id))

        return spell:Cast(target)
end)

DeathStrike:Callback("bloodShield", function(spell)
        if player:BuffRemains(buffs.bloodsheild) > 2000 then return end

        Aware:displayMessage("Topping blood shield", 'DeathKnight', 1.5, GetSpellTexture(spell.id))

        return spell:Cast(target)
end)

DeathStrike:Callback("new", function(spell)
        if not target.bigButtons then return end

        if target.hp > 10 and player.runicPower < 65 then
                return
        end

        return spell:Cast(target)
end)

DeathStrike:Callback("sany", function(spell)
        if not target.bigButtons then return end

        if not player:TalentKnown(433901) then return end
        return spell:Cast(target)
end)

RuneTap:Callback(function(spell)
        if player:Buff(buffs.runeTap) then return end
        if player.hp < 80 then spell:Cast(player) end
end)

VampiricBlood:Callback(function(spell)
        if player.hp < 30 then spell:Cast(player) end
end)

ChainsofIce:Callback(function(spell)
        if not target.bigButtons then return end
        if DeathStrike:InRange(target) then
                if not target.isMelee then return end

                local enemyTarget = target.target
                if not enemyTarget or not enemyTarget.exists then return end
                if not enemyTarget.isFriendly then return end
                if enemyTarget.isMelee then return end
         end

        if target.slowed or target.rooted then return end
        if target.slowImmune then return end

        return spell:Cast(target)
end)

RaiseDead:Callback(function(spell)
        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end

        return spell:Cast()
end)

BloodBoil:Callback("dancingwep", function(spell)
        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end
        if not player:Buff(buffs.dancingRuneWeapon) then return end

        if target:Debuff(debuffs.bloodPlague, true) then
                if BloodBoil.used < DancingRuneWeapon.used then return end

                -- if player:Buff(buffs.bloodQueen) then return end

        end

        return spell:Cast(player)
end)

BloodBoil:Callback("spread", function(spell, dance)
        if not target.bigButtons then return end
        if dance and not player:Buff(buffs.dancingRuneWeapon) then return end

        return MakMulti.arena:ForEach(function(enemy)
                if not enemy.exists then return end
                if not enemy.canAttack then return end
                if enemy.bcc then return end

                if enemy.magicImmune then return end

                if not DeathStrike:InRange(enemy) then return end

                if enemy:Debuff(debuffs.bloodPlague, true) then return end

                
                Aware:displayMessage("Spread Boil on " .. enemy.name, 'DeathKnight', 1.5, GetSpellTexture(spell.id))
        
                return spell:Cast(player)
        end)
end)

Consumption:Callback(function(spell)

        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end
        if not player:Buff(buffs.dancingRuneWeapon) then return end
        if not target:Debuff(debuffs.bloodPlague, true) then return end

        if BloodBoil.used > DancingRuneWeapon.used then return end

        if player:BuffRemains(buffs.dancingRuneWeapon) > 6000 then return end

        return spell:Cast(player)
end)

BloodBoil:Callback("newEarly", function(spell)
        if not target.bigButtons then return end
        if not DeathStrike:InRange(target) then return end
        if spell.frac < 1.8 then return end
        if target.magicImmune then return end

        -- if target:Debuff(debuffs.bloodPlague, true) then
        --         if player:Buff(buffs.bloodQueen) then return end

        -- end

        -- TODO: ADD checks for aoe in the future
        return spell:Cast(player)
end)

BloodBoil:Callback("newDump", function(spell)
        if not target.bigButtons then return end
        if not DeathStrike:InRange(target) then return end
        if spell.frac < 1.1 then return end
        if target.magicImmune then return end

        -- if target:Debuff(debuffs.bloodPlague, true) then
        --         if player:Buff(buffs.bloodQueen) then return end

        -- end

        -- TODO: ADD checks for aoe in the future
        return spell:Cast(player)
end)

BloodBoil:Callback("force", function(spell)
        
        if not target.bigButtons then return end
        if not DeathStrike:InRange(target) then return end
        if target.magicImmune then return end

        
        -- if target:Debuff(debuffs.bloodPlague, true) then
        --         if player:Buff(buffs.bloodQueen) then return end

        -- end

        -- TODO: ADD checks for aoe in the future
        return spell:Cast(player)
end)

AbominationLimb:Callback(function(spell)
        if not target.bigButtons then return end

        if not player:Buff(buffs.sanguineGround) then return end
        if not DeathStrike:InRange(target) then return end
        if target.magicImmune then return end

        return spell:Cast(player)
end)

DancingRuneWeapon:Callback("bigdam", function(spell)
        if not target.bigButtons then return end

        -- if player:TalentKnown(433901) then 
        --         if not IsSpellOverlayed(433895) then 
        --                 Aware:displayMessage("Holding dancing rune wep for proc", 'DeathKnight', 1.5, GetSpellTexture(spell.id))
        --                 return
        --          end
        -- end

        if spell.used < 30000 then return end

        if not player:Buff(buffs.sanguineGround) then return end
        if not DeathStrike:InRange(target) then return end
        if target.magicImmune then return end

        return spell:Cast(player)
end)

Tombstone:Callback(function(spell)
        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end
        if not player:Buff(buffs.sanguineGround) then return end        
        if DancingRuneWeapon.cd - Consumption.cd < 5000 then return end
        if target.magicImmune then return end

        return spell:Cast(player)
end)

Bonestorm:Callback(function(spell)
        if not target.bigButtons then return end

        if not DeathStrike:InRange(target) then return end
        if not player:Buff(buffs.sanguineGround) then return end
        if player:HasBuffCount(buffs.boneShield) < 6 then return end
        if target.magicImmune then return end
        if DancingRuneWeapon.cd - Consumption.cd < 5000 then return end

        return spell:Cast(target)
end)

DeathsCaress:Callback("new", function(spell, enemy)
        if player:BuffRemains(buffs.boneShield) > 5000 then return end
        if player.runicPower > 120 then return end
        if player:BuffRemains(buffs.boneShield) > DancingRuneWeapon.cd then return end
        if timeToRuneCount(3) < MakGcd() then return end

        return spell:Cast(enemy)
end)

ReapersMark:Callback(function(spell, enemy)
        if not target.bigButtons then return end
        if not player:Buff(buffs.sanguineGround) then return end
        return spell:Cast(enemy)
end)

Marrowrend:Callback("proc", function(spell, enemy)
        if not target.bigButtons then return end
        if not player:Buff(buffs.exterminate) then return end

        if not player:Buff(buffs.bloodsheild) then return end
        if not player:Buff(buffs.sanguineGround) then return end

        return spell:Cast(enemy)
end)

Marrowrend:Callback("new", function(spell, enemy)
        if player:BuffRemains(buffs.boneShield) > 5000 then return end
        if player.runicPower > 100 then return end
        if player:BuffRemains(buffs.boneShield) > DancingRuneWeapon.cd then return end

        return spell:Cast(enemy)
end)

HeartStrike:Callback("AshenDecay", function(spell)
        if not target.bigButtons then return end

        if timeToRuneCount(1) > MakGcd() then return end
        if not player:Buff(buffs.ashenDecay) then return end

        if target:HasDeBuffRemain(debuffs.ashenDecay, MakGcd() + 100) then return end

        return spell:Cast(target)
end)

HeartStrike:Callback("proc", function(spell)
        if not player:TalentKnown(433901) then return end

        -- if not IsSpellOverlayed(433895) then return end

        if not target:Debuff(debuffs.bloodPlague, true) then
                return
        end

        if not player:Buff(buffs.dancingRuneWeapon) then return end

        if BloodBoil.used > DancingRuneWeapon.used then return end

        if player:Buff(buffs.coagulapth) and
                player:BuffRemains(buffs.coagulapth) < 2000 then return end

        return spell:Cast(target)
end)

HeartStrike:Callback("fourRunes", function(spell)
        if timeToRuneCount(4) > MakGcd() then return end

        return spell:Cast(target)
end)

HeartStrike:Callback("lastDitch", function(spell)
        if player.rune <= 1 then return end
        if timeToRuneCount(3) > MakGcd() and player:HasBuffCount(buffs.boneShield) <= 7 then return end

        return spell:Cast(target)
end)

MindFreeze:Callback("kick", function(spell, enemy)
        if not enemy.pvpKick then return end

        -- return spell:Cast(enemy)
end)

A[3] = function(icon)
        FrameworkStart(icon)

        VampiricBlood()

        if target.exists and target.canAttack then
                RaiseDead()

                DeathStrike("panic")
                DeathStrike("bloodShield")
                DeathStrike("coagulapth")
                DeathStrike("capping")
                PVPTaunt()

                Consumption()
                Marrowrend("proc", target)
                SoulReaper("proc", target)
                ChainsofIce()
                DeathandDecay()
                DancingRuneWeapon("bigdam")
                BloodBoil("dancingwep")
                
                BloodBoil("spread", true)
                HeartStrike("proc")
                ReapersMark()
                SoulReaper("low", target)
                Bonestorm()
                Tombstone()

                AbominationLimb()

                HeartStrike("AshenDecay")

                DeathStrike("new")
                SoulReaper(target)
                DeathsCaress("new", target)
                Marrowrend("new", target)

                BloodBoil("spread", false)
                BloodBoil("newEarly")
                HeartStrike("fourRunes")
                BloodBoil("newDump")

                HeartStrike("lastDitch")
        end

        return FrameworkEnd()
end

local enemyRotation = function(enemy)
        if not enemy.exists then return end

        MindFreeze("single", enemy)
end

local amscc = AtoL({
        20066,  -- Repentance
        118,    -- Polymorph
        51514,  -- Hex
        33786,  -- Cyclone
        5782,   -- Fear
        605,    -- Mind Control
        360806, -- Sleep Walk
        161355, -- Polymorph (additional values)
        161354, -- Polymorph (additional values)
        161353, -- Polymorph (additional values)
        126819, -- Polymorph (additional values)
        61780,  -- Polymorph (additional values)
        161372, -- Polymorph (additional values)
        61721,  -- Polymorph (additional values)
        61305,  -- Polymorph (additional values)
        28272,  -- Polymorph (additional values)
        28271,  -- Polymorph (additional values)
        277792, -- Polymorph (additional values)
        277787, -- Polymorph (additional values)
        391622, -- Polymorph (additional values)
        211015, -- Hex (additional values)
        211010, -- Hex (additional values)
        211004, -- Hex (additional values)
        210873, -- Hex (additional values)
        269352, -- Hex (additional values)
        277778, -- Hex (additional values)
        277784, -- Hex (additional values)
})

AntiMagicShell:Callback("anti-cc", function(spell, party)
        if not party.exists then return end
        if not party.isHealer then return end

        MakMulti.arena:Any(function(enemy)
                local castInfo = enemy.castOrChannelInfo
                if not castInfo then return end

                if not amscc[castInfo.spellId] then return end
                if not castInfo.channel and castInfo.percent < kickPercent then return end
                if castInfo.channel and castInfo.elapsed < channelKickTime then return end

                print("Casting Anti-Magic Shell on " .. party.name .. " to counter CC")
                return spell:Cast(party)
        end)

        -- return spell:Cast(party)
end)

AntiMagicShell:Callback("save", function(spell, party)
        if not party.exists then return end
        if party.isMe then return end
        if not healer.cc or party.hp > 20 then return end
        if party.hp > 50 then return end
    
        return Debounce("save"..party.name, 500, 2000, spell, party)
end)

local partyRotation = function(party)
        if not party.exists then return end

        AntiMagicShell("anti-cc", party)
        AntiMagicShell("save", party)
end

A[6] = function(icon)
        RegisterIcon(icon)
        enemyRotation(MakUnit:new("arena1"))
        partyRotation(MakUnit:new("party1"))

        return FrameworkEnd()
end

A[7] = function(icon)
        RegisterIcon(icon)
        enemyRotation(MakUnit:new("arena2"))
        partyRotation(MakUnit:new("party2"))

        return FrameworkEnd()
end

A[8] = function(icon)
        RegisterIcon(icon)
        enemyRotation(MakUnit:new("arena3"))
        partyRotation(MakUnit:new("party3"))

        return FrameworkEnd()
end
