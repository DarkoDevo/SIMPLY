local SITUATION_TYPES = {
    Offensive = 1,
    Defensive = 2,
    Mana = 3
}

local CACHE_LENGTH_TYPES = {
    Tick = 1,
    Combat = 2
}

local PlayerInfoCache = {}

function GetItemInformation()
    local trinket1ID = GetInventoryItemID("player", 13)
    local trinket2ID = GetInventoryItemID("player", 14)
    local weaponID = GetInventoryItemID("player", 16)
end

function ItemCheck(situation_type)
    if situation_type == SITUATION_TYPES.Defensive then
        
    end
end



local DBM 							= _G.DBM
local BigWigsLoader					= _G.BigWigsLoader
local TMW 							= _G.TMW

local strlowerCache  				= TMW.strlowerCache
local toNum 						= A.toNum
local GetToggle						= A.GetToggle

local bossSpellInfo = {
	-- AMIRDRASSIL GNARLROOT
	[422026] = {
		name = "Tortured Scream",
		damageProfiles = {"DoT", "Direct"},
		damageTarget = {"DPS", "Heal", "Tank"}
	},
	
	-- AMIRDRASSIL IGIRA
	[414425] = {
		name = "Blistering Spear",
		damageProfiles = {"Direct"},
		damageTarget = {"DPS", "Heal"}
	},
	
	[422776] = {
		name = "Marked for Torment",
		damageProfiles = {"Direct"},
		damageTarget = {"DPS", "Heal", "Tank"}
	},
	
	[423715] = {
		name = "Searing Sparks",
		damageProfiles = {"Direct"},
		damageTarget = {"DPS", "Heal", "Tank"}
	}
}

if DBM then
	print("USING DBM")
	local Timers = {}
	DBM:RegisterCallback("DBM_TimerStart", function(_, id, text, timerRaw, icon, timerType, spellid, colorId)
		local duration
		if type(timerRaw) == "string" then
			duration = toNum[timerRaw:match("%d+")]
		else
			duration = timerRaw
		end
		
		if spellid and bossSpellInfo[spellid] ~= nil then
			print("Starting [" .. bossSpellInfo[spellid].name .. "]")
			Timers[id] = {
				start = TMW.time,
				duration = duration,
				spellid = spellid
			}
		end
	end)
	DBM:RegisterCallback("DBM_TimerStop", function(_, id)
		if Timers[id] ~= nil then
			print("Timer Ended For [" .. bossSpellInfo[Timers[id].spellid].name .. "]")
			Timers[id] = nil
		end
	end)
end

