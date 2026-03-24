local _, MakuluFramework, project = ...

local MF                              = MakuluFramework

local Spell                           = MakuluFramework.Spell
local Cache                           = MakuluFramework.Cache
local Unit                            = MakuluFramework.Unit
local ConstUnits                      = MakuluFramework.ConstUnits
local MultiUnits                      = MakuluFramework.MultiUnits
local Chat                            = MakuluFramework.Chat
local Lazy                            = MakuluFramework.Lazy
local FakeCasting                     = MakuluFramework.FakeCasting
local Debounce                        = MakuluFramework.debounceSpell
local AtoL                            = MakuluFramework.AtoL
local Events                          = MakuluFramework.Events
local MakuluAware                     = MakuluFramework.MakuluAware
local pairs = pairs

local target                          = ConstUnits.target
local healer                          = ConstUnits.healer
local player                          = ConstUnits.player
local enemyHealer                     = ConstUnits.enemyHealer

local MindBlast                       = Spell:new(8092, { damageType = "magic" })
local MindFlay                        = Spell:new(15407, { damageType = "magic", channel = true, dumbCast = true })
local MindGames                       = Spell:new(375901, { damageType = "magic" })
local VampiricTouch                   = Spell:new(34914, { ignoreFacing = true, damageType = "magic" })
local VoidTorrent                     = Spell:new(263165, { damageType = "magic", channel = true, ignoreMoving = true })
local VoidEruption                    = Spell:new(228260, { damageType = "magic" })
local VoidBolt                        = Spell:new(205448, { damageType = "magic" })
local ShadowFiend                     = Spell:new(34433, { damageType = "magic" })
local VoidWrath                       = Spell:new(451235, { damageType = "magic" })
local DevouringPlague                 = Spell:new(335467,
  { ignoreFacing = true, damageType = "magic" })
local ShadowWordPain                  = Spell:new(589, { ignoreFacing = true, damageType = "magic" })
local ShadowWordDeath                 = Spell:new(32379, { ignoreFacing = true, damageType = "magic" })
local ShadowCrash                     = Spell:new(457042, { damageType = "magic", ignoreMoving = true })
local Psyfiend                        = Spell:new(211522, { targeted = false })
local DivineStar                      = Spell:new(122121, { targeted = false })
local VoidBlast                       = Spell:new(450983, { targeted = true, damageType = "magic" })

local Scream                          = Spell:new(8122, { damageType = "magic", targed = false })
local Silence                         = Spell:new(15487, { damageType = "magic", offGcd = true, cc = true })
local Horror                          = Spell:new(64044, { damageType = "magic", cc = true })

local DispelMagic                     = Spell:new(528, { cc = true })
local MassDispel                      = Spell:new(32375, { targeted = false })

local Feather                         = Spell:new(121536, { targeted = false })

local DesperatePrayer                 = Spell:new(19236, { targeted = false })
local VoidShift                       = Spell:new(108968, { heal = true, offGcd = true, ignoreCasting = true })
local PowerWordShield                 = Spell:new(17, { ignoreFacing = true, heal = true })
local PowerWordFortitude              = Spell:new(21562, { targeted = false })
local PowerInfusion                   = Spell:new(10060, { heal = true, ignoreFacing = true })
local FlashHeal                       = Spell:new(2061, { ignoreFacing = true })
local VampiricEmbrace                 = Spell:new(15286, { targeted = false, offGcd = true })
local Fade                            = Spell:new(586, { targeted = false, offGcd = true, ignoreCasting = true })
local Dispersion                      = Spell:new(47585, { targeted = false, offGcd = true, ignoreCasting = true })

local Cacher = Cache:getConstCacheCell()

local debuffs                         = {
  swp = 589,
  vt = 34914,
  dp = 335467,
  mindTrauma = 247777,
  528
}

local buffs                           = {
  shadowyInsights = 375981,
  pwf = 21562,
  pi = 10060,
  instaVT = 341282,
  insanty = 391401,
  pws = 17,
  feather = 121557,
  mindDevourer = 373204,
  screamsOfVoid = 393919,
  protecitveLight = 193065
}

local GetSpellTexture = C_Spell.GetSpellTexture
local GetTime = GetTime
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local instaVTLast = 0

local kickPercent                     = 32
local meldDuration                    = 0.9
local shortHalfSecond                 = 0.5
local channelKickTime                 = 400
local quickKick                       = 15

local function generateNewRandomKicks()
  kickPercent = math.random(40, 90)
  meldDuration = math.random(600, 1200) / 1000
  shortHalfSecond = math.random(400, 600) / 1000
  channelKickTime = math.random(300, 800)
  quickKick = math.random(10, 20)

  return C_Timer.After(math.random(15, 30), generateNewRandomKicks)
end

generateNewRandomKicks()

print(" " .. Chat.SpecDraw(258, 20) .. " - Lets get ready to rumble")

local shadowCrashUsed = {
  time = 0,
  target = nil
}

local vtTracker = {
  time = 0,
  target = nil
}

local function recordShadowCrash(unit)
  shadowCrashUsed.target = unit.guid
  shadowCrashUsed.time = GetTime()
end

local function likelyHitSoon(unit)
  if not shadowCrashUsed.target then return end
  if GetTime() - shadowCrashUsed.time > 2 then return end

  if unit.guid == shadowCrashUsed.target then return true end

  local scTarget = Unit:newGUID(shadowCrashUsed.target)
  if not scTarget.exists then return end
  if unit:DistanceTo(scTarget) < 8 then return true end
end

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local function vtCasted()
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool =
        CombatLogGetCurrentEventInfo()
    
    if subevent ~= "SPELL_CAST_SUCCESS" then return end
    if sourceName ~= "player" then return end
    if spellName ~= "Vampiric Touch" then return end

    vtTracker.target = destGUID
    vtTracker.time = GetTime()
end

Events.register("COMBAT_LOG_EVENT_UNFILTERED", vtCasted)

local function vtAlreadyCasted(unit)
  return Cacher:GetOrSet("vtCasted", function ()
    local castInfo = player.castInfo
    if castInfo and castInfo.name == "Vampiric Touch" then
      local castTarget = player:CastTarget()
      if castTarget and castTarget.guid == unit.guid then return true end
    end

    if not vtTracker.target then return end
    if unit.guid ~= vtTracker.target then return end

    if GetTime() - vtTracker.time > 1 then return end

    return true
  end)
end

local function aura_applied()
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool =
        CombatLogGetCurrentEventInfo()
    if subevent ~= "SPELL_AURA_APPLIED" then return end

    if spellName == "Unfurling Darkness" and destGUID == player.guid then
        instaVTLast = GetTime()
    end
end

Events.register("COMBAT_LOG_EVENT_UNFILTERED", aura_applied)

local function timeTilInstaVT()
  return Cacher:GetOrSet("instaVT", function ()
    if GetTime() - vtTracker.time < 2 then return 15 end
    local playerCasting = player.castOrChannelInfo
    if playerCasting and playerCasting.name == "Vampiric Touch" then
      return 15
    end

    return (instaVTLast + 15) - GetTime()
  end)
end

PowerWordFortitude:Callback(function(spell)
  if player:BuffRemains(buffs.pwf) > 50000 then return end

  return Debounce("PWF", 4000, 8000, spell)
end)

Feather:Callback("self", function(spell)
  if player:BuffRemains(buffs.feather) > 1000 then return end
  if spell.used < 1000 then return end

  return spell:Cast(player)
end)

local purgePrio = AtoL({
  "Alter Time",
  "Blessing of Protection",
  "Power Infusion",
  "Nullifying Shroud",
  "Holy Ward",
  "Blessing of Sanctuary",
  "Nature's Swiftness",
  "Mind Control"
})

DispelMagic:Callback(function(spell)
  if player.manaPct < 40 then return end
  MultiUnits.enemies:ForEach(function(enemy)
    if enemy:HasBuffFromFor(purgePrio, channelKickTime) then
      return spell:Cast(enemy)
    end
  end)
end)

local purgeLow = AtoL({
  102352,
  33763,
  366155,
  364343,
  155675,
  774,
  467,
  139,
  33206,
  17,
  115151,
  124682,
  61295,
  355941,
  378001,
  1022
})

DispelMagic:Callback("bored", function(spell)
  if player.manaPct < 80 then return end

  if not target.exists then return end
  if target:HasBuffFromFor(purgeLow, channelKickTime) then
    return spell:Cast(target)
  end
end)

MassDispel:Callback(function(spell)
  MultiUnits.enemies:ForEach(function(enemy)
    if enemy.distance > 30 then return end
    if not enemy.los then return end

    local buffToPurge = enemy:BuffFrom(project.mdOffensiveList)
    if not buffToPurge or buffToPurge.duration == 0 then return end
    local uptime = MF.auraUptime(buffToPurge)
    if uptime < 400 then return end

    return spell:AoECast(enemy)
  end, true)
end)

local fade_duration = 600

local generate_fade_duration = function()
  fade_duration = math.random(200, 500)
end

generate_fade_duration()

Fade:Callback("avoid_damage", function(spell, unit)
  if not unit.exists then return end

  local castInfo = unit.castOrChannelInfo
  if not castInfo then return end

  local castTarget = unit:CastTarget()
  if not castTarget then return end
  if not castTarget.isMe then return end

  if not project.fadeList[castInfo.spellId] then return end
  if castInfo.remaining > fade_duration then return end

  if project.deathList[castInfo] then
    if ShadowWordDeath:Used() < 1000 then return end
  end

  if spell:Cast() then
    generate_fade_duration()
  end
end)

Fade:Callback("avoid_any", function(spell, enemies)
  enemies():ForEach(function(enemy)
    return Fade("avoid_damage", enemy)
  end, true)
end)

ShadowWordDeath:Callback("BreakCC", function(spell, unit)
  if not unit.exists then return end

  local castInfo = unit.castOrChannelInfo
  if not castInfo then return end

  local castTarget = unit:CastTarget()
  if not castTarget then return end
  if not castTarget.isMe then return end

  if Fade:Used() < 1000 then return end

  if not project.deathList[castInfo.spellId] then return end
  if castInfo.remaining > fade_duration then return end

  if spell:Cast(unit) then
    generate_fade_duration()
  end
end)

ShadowWordDeath:Callback("DeathAny", function(spell, enemies)
  if player.hp < 30 then return end

  enemies():ForEach(function(enemy)
    return ShadowWordDeath("BreakCC", enemy)
  end, true)
end)

VoidShift:Callback("save_self", function(spell)
  if player.hp > 25 then return end

  local shiftPossible = MultiUnits.party:Filter(function(team)
    if team.hp < 50 then return end
    if not team.los then return end
    if team.distance > 40 then return end

    return true
  end)

  shiftPossible:Sort(function(a, b)
    return a.hp > b.hp
  end)

  shiftPossible:ForEach(function(team)
    return Debounce("shift_low", 300, 1000, spell, team)
  end, true)
end)

VoidShift:Callback("save_others", function(spell)
  if player.hp < 50 then return end

  local shiftPossible = MultiUnits.party:Filter(function(team)
    if team.dead then return end
    if team.hp > 25 then return end
    if not team.los then return end
    if team.totalImmune then return end
    if team.distance > 40 then return end

    return true
  end)

  shiftPossible:Sort(function(a, b)
    return a.hp < b.hp
  end)

  shiftPossible:ForEach(function(team)
    return Debounce("shift_save", 300, 1000, spell, team)
  end, true)
end)

VoidShift:Callback(function()
  VoidShift("save_self")
  VoidShift("save_others")
end)

Silence:Callback("healer", function(spell)
  if not enemyHealer.exists then return end
  if target.hp > 90 or not target.los then return end
  if enemyHealer.silenceDr < 1 then return end

  if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

  if spell:Cast(enemyHealer) then
    -- print('Silence on ' .. enemyHealer.name)
  end
end)

Horror:Callback("healer", function(spell)
  if not enemyHealer.exists then return end
  if enemyHealer.stunDr < 0.5 then return end

  if enemyHealer.ccImmune then return end
  if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

  return spell:Cast(enemyHealer)
  -- print('Horrify on ' .. enemyHealer.name)
end)

Horror:Callback("enemyCds", function(spell)
  MultiUnits.enemyPlayers:ForEach(function(enemy)
    if enemy.isHealer then return end
    if enemy.stunDr < 0.5 then return end
    if enemy.cc then return end

    if not enemy.cds then return end
    if healer.exists or not healer.cc or healer.ccRemains < 1000 then return end

    return Debounce("CHARGE_CDS" .. enemy.name, 400, 3500, spell, enemy)
  end)
end)

DivineStar:Callback(function (spell, enemies)
  enemies():ForEach(function(enemy)
    if enemy.distance > 30 or not enemy.los then return end
    if not player:FacingUnit(enemy, 10) then return end
    if enemy.bcc or enemy.magicImmune then return end

    return spell:Cast()
  end, true)
end)

local dontFear = AtoL({
    6940,
    378464,
    329543,
    215769,
    5246,
    "Bladestorm",
    "Nullifying Shroud"
})

Scream:Callback("healer", function(spell)
  if not enemyHealer.exists then return end
  if enemyHealer.disorientDr < 0.5 then return end
  if enemyHealer.distance > 8 then return end
  if not enemyHealer.los then return end

  if enemyHealer.magicImmune then return end
  if enemyHealer.ccImmune then return end
  if enemyHealer:BuffFrom(dontFear) or enemyHealer:DebuffFrom(dontFear) then return end
  if enemyHealer.cc and enemyHealer:CCRemains() > 400 then return end

  return spell:Cast()
end)

Scream:Callback("force", function(spell)
  return spell:Cast()
end)

PowerWordShield:Callback("pressure", function(spell)
  if player.manaPct < 10 then return end

  local attackers, _, _, _, cds = player:AttackersV69()

  if attackers == 0 then
    return MultiUnits.party:ForEach(function(team)
      if team.isMe then return end
      if team.totalImmune then return end
      if not healer.cc then return end

      if team.hp > player.hp then return end
      local tattackers, _, _, _, tcds = team:AttackersV69()

      if tattackers > 1 or tcds > 0 then
        if team.hp > 70 and tcds == 0 and player.manaPct < 80 then return end

        return spell:Cast(team)
      end
    end)
  end

  if player.hp > 90 then return end
  if player:Buff(buffs.pws) then return end

  if cds > 0 or attackers > 1 then
    if cds == 0 and player.manaPct < 80 then return end
    return spell:Cast(player)
  end
end)

PowerWordShield:Callback("self", function(spell)
  local attackers, _, _, _, cds = player:AttackersV69()
  if attackers == 0 and player.hp > 60 then return end
  if player:Buff(buffs.pws) then return end
  if player.manaPct < 20 then return end

  return Debounce("pwsSelf", 400, 3500, spell)
end)

PowerInfusion:Callback(function(spell)
  return MultiUnits.party:ForEach(function(team)
    if team.isMe then return end
    if team.isHealer then return end
    if not team.cds then return end
    if team.cc then return end

    return Debounce("PICD" .. team.name, 400, 3500, spell, team)
  end, true)
end)

FlashHeal:Callback("protective", function(spell)
  if not target.exists then return end
  if not target.totalImmune and target.hp < 30 then return end
  if player:BuffRemains(buffs.protecitveLight) > 1000 then return end
  local attackers, _, _, _, cds = player:AttackersV69()
  if attackers == 0 then return end
  return spell:Cast(player)
end)

FlashHeal:Callback("self", function(spell)
  if player.hp > 90 and player:BuffRemains(buffs.protecitveLight) > 1000 then return end
  return spell:Cast(player)
end)

DesperatePrayer:Callback(function(spell)
  if player.hp > 40 then return end

  return Debounce("DesperatePrayer", 600, 1500, spell)
end)

Dispersion:Callback(function(spell)
  if player.hp > 20 then return end

  return Debounce("Disperion", 300, 1500, spell)
end)

Dispersion:Callback("force", function(spell)
  if player.hp > 80 then return end
  return spell:Cast()
end)

Psyfiend:Callback(function(spell)
  if not target.exists then return end
  if not target.bigButtons then return end

  return spell:Cast(target)
end)

VoidWrath:Callback(function(spell)
  if not target.exists then return end
  return spell:Cast(target)
end)

ShadowFiend:Callback(function(spell)
  if not target.exists then return end

  return spell:Cast(target)
end)


local canGo = Lazy("cango", function()
  local info = player.castOrChannelInfo
  if not info then return true end

  return info.spellId == 15407
end)

DevouringPlague:Callback("single", function(spell, unit)
  if not unit.exists then return end
  if not canGo() then return end
  if not unit.bigButtons then return end

  if player:Buff(buffs.mindDevourer) and player:BuffRemains(buffs.mindDevourer) < 1000 then
    return spell:Cast(unit)
  end

  if unit.isTarget and player.insanityDeficit < 15 then
    return spell:Cast(unit)
  end

  if player:BuffRemains(buffs.screamsOfVoid) > 1500 then return end
  if player.insanity < 45 and not player:Buff(buffs.mindDevourer) then return end

  if unit:DebuffRemains(debuffs.dp, true) > 1000 then
    if not unit.isTarget then return end

    if not unit:Debuff(debuffs.vt, true) then return end
  end

  if unit.isTarget then
    if not unit:Debuff(debuffs.vt, true) and player.insanity < 130 then return end
  else
    if not unit:Debuff(debuffs.vt, true) then return end
  end

  return spell:Cast(unit)
end)

DevouringPlague:Callback("spread", function(spell, enemies)
  if player.insanity < 110 then return end

  if DevouringPlague("single", target) then return end

  enemies():ForEach(function(enemy)
    return DevouringPlague("single", enemy)
  end, true)
end)

MindBlast:Callback("single", function(spell, unit)
  if not unit.exists then return end

  return spell:Cast(unit)
end)

MindBlast:Callback("proc", function(spell, enemies)
  if not player:Buff(buffs.shadowyInsights) then return end
  if MindBlast("single", target) then return end

  return enemies():ForEach(function(enemy)
    return MindBlast("single", enemy)
  end, true)
end)

MindGames:Callback("single", function(spell, unit)
  if not unit.exists then return end

  return spell:Cast(unit)
end)

MindGames:Callback("spread", function(spell, enemies)
  if MindGames("single", target) then return end

  return enemies():ForEach(function(enemy)
    return MindGames("single", enemy)
  end, true)
end)

VampiricTouch:Callback("single", function(spell, unit, ignore)
  if not unit.exists then return end
  if not ignore and unit:DebuffRemains(debuffs.vt, true) > 3000 then return end
  if likelyHitSoon(unit) then return end
  if vtAlreadyCasted(unit) then print("Prevented double vt") return end

  return spell:Cast(unit)
end)

VampiricTouch:Callback("spread", function(spell, enemies)
  local nextInsta = timeTilInstaVT()
  if nextInsta < 0 and VampiricTouch("single", target) then return end

  if nextInsta > 0 and nextInsta < 2 then return end

  return enemies():ForEach(function(enemy)
    return VampiricTouch("single", enemy)
  end, true)
end)

VampiricTouch:Callback("getInsta", function(spell, enemies)

  if timeTilInstaVT() > 0 then return end

  if spell("spreadMore", enemies) then return end

  local allEnemies = MultiUnits.allEnemies:Clone()

  allEnemies:Sort(function(a, b)
    return a:DebuffRemains(debuffs.vt, true) < b:DebuffRemains(debuffs.vt, true)
  end)

  return allEnemies:ForEach(function (enemy)
    if enemy:HealthMax() < 1000000 then return end

    return spell:Cast(enemy)
  end)
end)

VampiricTouch:Callback("spreadMore", function(spell, enemies)
  local nextInsta = timeTilInstaVT()
  if nextInsta > 0 and nextInsta < 2 then return end

  local vtList = enemies():Clone()

  vtList:Sort(function(a, b)
    return a:DebuffRemains(debuffs.vt, true) < b:DebuffRemains(debuffs.vt, true)
  end)

  return vtList:ForEach(function(unit)
    if unit:DebuffRemains(debuffs.vt, true) > 6000 then return end
    if likelyHitSoon(unit) then return end
    if vtAlreadyCasted(unit) then print("Prevented double vt") return end

    return spell:Cast(unit)
  end, true)
end)

VampiricTouch:Callback("proc", function(spell, enemies)
  if not player:Buff(buffs.instaVT) then return end
  if VampiricTouch("single", target, true) then 
      MakuluAware:displayMessage('- Big VT proc', 'Priest', 1.4, GetSpellTexture(spell.id))
  end

  if player:BuffRemains(buffs.instaVT) > 1500 then return end
  local vtList = enemies():Clone()

  vtList:Sort(function(a, b)
    return a:DebuffRemains(debuffs.vt, true) < b:DebuffRemains(debuffs.vt, true)
  end)

  return vtList:ForEach(function(enemy)
    if VampiricTouch("single", enemy, true) then
      return
    end
  end, true)
end)

MindFlay:Callback("single", function(spell, unit)
  if not unit.exists then return end

  return spell:Cast(unit)
end)

MindFlay:Callback("spread", function(spell, enemies)
  MindFlay("single", target)

  -- local hasTrauma, noTrauma = enemies():Split(function(enemy)
  --     return enemy:Debuff(debuffs.mindTrauma)
  -- end)
  --
  -- hasTrauma:Sort(function(a, b)
  --     return a:DebuffRemains(debuffs.mindTrauma, true) < b:DebuffRemains(debuffs.mindTrauma, true)
  -- end)
  --
  -- local hasThreeStackTraumaDropping, noThree = hasTrauma:Split(function(enemy)
  --     return enemy:HasDeBuffCount(debuffs.mindTrauma, 3, true)
  -- end)
  --
  -- if hasThreeStackTraumaDropping:ForEach(function(enemy)
  --         if enemy:DebuffRemains(debuffs.mindTrauma, true) > 6000 then return end
  --         return MindFlay("single", enemy)
  --     end, true) then
  --       return
  -- end
  --
  -- if noThree:ForEach(function(enemy)
  --         return MindFlay("single", enemy)
  --     end, true) then
  --     return
  -- end
  --
  -- noTrauma:ForEach(function(enemy)
  --     return MindFlay("single", enemy)
  -- end, true)
  --

  if player:Buff(buffs.insanty) then return end

  return enemies():ForEach(function(enemy)
    return MindFlay("single", enemy)
  end, true)
end)

MindFlay:Callback("proc", function()
  if not player:Buff(buffs.insanty) then return end

  return MindFlay("single", target)
end)

VoidTorrent:Callback("single", function(spell, unit)
  if not unit.exists then return end
  if not unit.bigButtons then return end

  return spell:Cast(unit)
end)

VoidTorrent:Callback("proc", function(spell, enemies)
  if VoidTorrent("single", target) then return end

  if target.hp < 40 then return end

  return enemies():ForEach(function(enemy)
    return VoidTorrent("single", enemy)
  end, true)
end)

VoidBolt:Callback("single", function(spell, unit, check)
  if not unit.exists then return end
  if check and not unit:Debuff(debuffs.vt, true) then return end

  return spell:Cast(unit)
end)

VoidBolt:Callback("spread", function(spell, enemies)
  if VoidBolt("single", target, true) then return end

  enemies():ForEach(function(enemy)
    return VoidBolt("single", enemy, true)
  end, true)

  if VoidBolt("single", target) then return end

  return enemies():ForEach(function(enemy)
    return VoidBolt("single", enemy)
  end, true)
end)

VoidBlast:Callback("single", function(spell, unit)
  if not player:Buff(449887) then return end
  return spell:Cast(unit)
end)

VoidBlast:Callback("spread", function(spell, enemies)
  if VoidBlast("single", target) then return end

  return enemies():ForEach(function(enemy)
    return VoidBlast("single", enemy)
  end, true)
end)

VoidEruption:Callback(function(spell)
  if not target.exists then return end
  if not target.bigButtons then return end
  if not target:Debuff(debuffs.vt, true) then return end

  return spell:Cast(target)
end)

ShadowCrash:Callback("target", function(spell)
  if not target.exists then return end
  if not target.bigButtons then return end
  if target:Debuff(debuffs.vt, true) then return end

  if spell:Cast(target) then
    recordShadowCrash(target)
  end
end)

ShadowCrash:Callback(function(spell, enemies)
  if not target:Debuff(debuffs.vt, true) then return end
  local canHit = enemies():Filter(function(enemy)
    if enemy.distance > 40 then return end
    if not enemy.los then return end
    if enemy:Debuff(debuffs.vt, true) then return end

    return not enemy.magicImmune
  end, true)

  return canHit:ForEach(function(enemy)
    if spell:Cast(enemy) then
      recordShadowCrash(enemy)
    end
  end, true)
end)

ShadowWordPain:Callback("single", function(spell, unit, ignore)
  if not unit.exists then return end
  if not ignore and unit:DebuffRemains(debuffs.swp, true) > 3000 then return end

  return spell:Cast(unit)
end)

ShadowWordPain:Callback("spread", function(spell, enemies, ignore)
  if ShadowWordPain("single", target, ignore) then return end

  return enemies():ForEach(function(enemy)
    return ShadowWordPain("single", enemy, ignore)
  end, true)
end)

ShadowWordPain:Callback("cathesis", function(spell, enemies, onlyTarget)
  if not player:TalentKnown(391297) then return end
  if not IsSpellOverlayed(spell.id) then return end

  if onlyTarget then return spell("single", target, true) end

  return spell("spread", enemies, true)
end)

ShadowWordDeath:Callback("execute_single", function(spell, unit)
  if not unit.exists then return end
  if unit.hp >= 20 then return end
  if not unit.player then return end

  return spell:Cast(unit)
end)

ShadowWordDeath:Callback("execute_multi", function(spell, enemies)
  if player.hp < 10 then return end
  if ShadowWordDeath("execute_single", target) then return end

  enemies():ForEach(function(enemy)
    return ShadowWordDeath("execute_single", enemy)
  end, true)
end)

VampiricEmbrace:Callback(function(spell)
  local healerInCC = healer.exists and healer.cc and healer.ccRemains > 2000

  MultiUnits.party:ForEach(function(party)
    if healerInCC and party.hp < 80 then
      return Debounce("EMBRACE" .. party.name, 400, 2500, spell)
    end

    if party.hp < 50 then
      return Debounce("EMBRACELOW" .. party.name, 400, 2500, spell)
    end
  end)
end)

local SPRI_ROTATION  = {}

local ignoring       = {
  ["Cleave Training Dummy"] = true,
  ["Boulderfist"] = true,
  ["Eye of Topaz"] = true,
  ["Kelpfist"] = true
}

local earthDraws = function(draw)
    -- if on and not IsInGame() then return end
    -- if instanceType ~= "none" then return end

    for i, object in ipairs(Objects()) do
        local id = ObjectId(object)
        if id == 422531 then
            local x,y,z = ObjectPosition(object)
            local px, py, pz = ObjectPosition('player')
            local name = ObjectName(object)
            draw:SetColor(draw.colors.yellow)
            draw:Text(name, "GameFontHighlight", x, y, z)
            draw:SetColor(draw.colors.yellow)
            draw:SetWidth(2)
            draw:Outline(x, y, z, 2, 125)
            draw:Line(px, py, pz, x, y, z)
        end
    end
end

local healerLineDraw = function(draw)
  if not player.exists then return end
  -- earthDraws(draw)
  if not healer.exists then return end
  if player.mounted then return end
  local myPos = player:PositionNoCache()
  local healerPos = healer:PositionNoCache()

  if myPos.x and healerPos.x then
    if healer.distance > 40 or not healer:Los() then
      draw:SetColor(draw.colors.red)
    else
      draw:SetColor(draw.colors.green)
    end
    draw:SetWidth(2)
    draw:Line(myPos.x, myPos.y, myPos.z, healerPos.x, healerPos.y, healerPos.z)
  end
end

local totemsToStomp  = {
  ["Spirit Link Totem"] = true,
  ["Tremor Totem"] = true,
  ["Grounding Totem"] = true,
  ["Totem of Wrath"] = true,
  ["Psyfiend"] = true,
  ["Observer"] = true,
  ["Wind Rush Totem"] = true,
}

local letterQ        = 0x0C
local letterE        = 0x0E
local letterR        = 0x0F
local letterN        = 0x2D

FakeCasting.enable()

SPRI_ROTATION.draw     = healerLineDraw

SPRI_ROTATION.callback = function()
  -- FakeCasting.fakeCast()

  if player.mounted then return end

  local chat_open = MF.ChatWindowOpen()

  if not chat_open and GetKeyState(letterR) then
    Dispersion("force")
  end

  if not target.exists or not target.canAttack then
    VoidShift()
    Dispersion()

    if not chat_open and GetKeyState(letterQ) then
      Feather("self")
    end

    PowerWordFortitude()
    return
  end

  if not chat_open and GetKeyState(letterE) then
    Psyfiend()
    VoidWrath()
  end

  if not chat_open and GetKeyState(letterN) then
    Scream("force")
  end

  local casting = Lazy("casting", function()
    return MultiUnits.enemies:Filter(function(enemy)
      return enemy.player and enemy.castOrChannel
    end)
  end)

  local enemies = Lazy("enemies", function()
    local attackable = MultiUnits.enemies:Filter(function(enemy)
      return enemy.los and enemy.distance < 50 and not enemy.bcc and not enemy.magicImmune
          and not ignoring[enemy.name]
    end)

    attackable:Sort(function(a, b)
      return a.hp < b.hp
    end)

    return attackable
  end)

  VoidShift()
  Dispersion()
  ShadowWordDeath("DeathAny", casting)
  Fade("avoid_any", casting)
  DesperatePrayer()

  MassDispel()

  local playerCasting = player.castOrChannelInfo
  if playerCasting and playerCasting.name == "Mind Flay: Insanity" then
    return
  end

  PowerInfusion()
  VampiricEmbrace()

  Scream("healer")
  Silence("healer")
  Horror("healer")

  Horror("enemyCds")

  if not chat_open and GetKeyState(letterQ) then
    Feather("self")
  end

  MultiUnits.totems:ForEach(function(totem)
    if not totem.canAttack then return end
    if not totemsToStomp[totem.name] then return end

    MakuluFramework.debounce("totem" .. totem.guid, 300, 5000, function()
      ShadowWordPain("single", totem)
      MindBlast("single", totem)
    end)
  end)

  ShadowWordDeath("execute_multi", enemies)

  VampiricTouch("proc", enemies)

  PowerWordShield("pressure")
  DevouringPlague("single", target)

  ShadowWordPain("cathesis", enemies, true)

  VampiricTouch("getInsta", enemies)
  ShadowCrash("target")
  VampiricTouch("single", target)
  ShadowCrash(enemies)
  VampiricTouch("spread", enemies)
  VoidTorrent("single", target)
  MindFlay("proc", enemies)
  DispelMagic()
  VoidEruption()
  MindGames("single", target)
  VoidBolt("spread", enemies)
  VoidBlast("spread", enemies)

  -- ShadowFiend()

  DevouringPlague("spread", enemies)

  MindBlast("proc", enemies)
  FlashHeal("protective")
  DivineStar(enemies)
  VampiricTouch("spreadMore", enemies)
  MindFlay("single", target)

  MindGames("spread", enemies)

  MindFlay("spread", enemies)

  PowerWordFortitude()
  PowerWordShield("self")
  DispelMagic("bored")
  -- ShadowWordPain("cathesis", enemies)
  -- ShadowWordPain("spread", enemies)

  FlashHeal("self")
end

SPRI_ROTATION.spec     = 258

MakuluFramework.registerRotation(SPRI_ROTATION)
