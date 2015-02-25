
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewPlugin("Common Auras")
if not mod then return end

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "enUS", true)
if L then
	L.usedon_cast = "%s: %s on %s"
	L.used_cast = "%s used %s."
	L.ritual_cast = "%s wants to perform a %s!"

	L.portal = "Portal"
	L.portal_desc = "Toggle showing of mage portals."
	L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination
	L.portal_icon = 53142
	L.portal_bar = "%s (%s)"

	L.repair = "Repair Bot"
	L.repair_desc = "Toggle showing when repair bots are available."
	L.repair_icon = 67826

	L.feast = "Feasts"
	L.feast_desc = "Toggle showing when feasts get prepared."
	L.feast_cast = "%s prepared a %s!"
	L.feast_icon = 44102

	L.rebirth = "Rebirth"
	L.rebirth_desc = "Toggle showing combat resurrections."
	L.rebirth_icon = 20484

	L["Noncombat"] = true
	L["Group utility"] = true
	L["Tanking cooldowns"] = true
	L["Healing cooldowns"] = true
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common Auras")

function mod:GetLocale() return L end

--------------------------------------------------------------------------------
-- Initialization
--

mod.toggleOptions = {
	"portal", "repair", "feast", 698, 29893, 43987,
	97462, 114192, 2825, 106898, 172106, "rebirth",
	871, 12975, 114030, 1160, 498, 31850, 86659, 48792, 55233, 22812, 61336, 115203, 115176,
	33206, 62618, 47788, 64843, 102342, 740, 6940, 31821, 98008, 116849, 115310, 159916, 51052, 76577,
}
mod.optionHeaders = {
	portal = L["Noncombat"],
	[97462] = L["Group utility"],
	[871] = L["Tanking cooldowns"],
	[33206] = L["Healing cooldowns"],
}

local nonCombat = { -- Map of spells to only show out of combat.
	portal = true,
	repair = true,
	feast = true,
	[698] = true, -- Rital of Summoning
	[29893] = true, -- Create Soulwell
	[43987] = true, -- Conjure Refreshment Table
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.
local combatLogMap = {}

function mod:OnRegister()
	combatLogMap.SPELL_CAST_START = {
		[160740] = "Feasts", -- Feast of Blood (+75)
		[160914] = "Feasts", -- Feast of the Waters (+75)
		[175215] = "Feasts", -- Savage Feast (+100)
	}
	combatLogMap.SPELL_CAST_SUCCESS = {
		--OOC
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[54711] = "Repair", -- Scrapbot
		[67826] = "Repair", -- Jeeves
		[157066] = "Repair", -- Walter
		[698] = "SummoningStone", -- Ritual of Summoning
		[29893] = "Soulwell", -- Create Soulwell
		[43987] = "Refreshment", -- Conjure Refreshment Table
		-- Group
		[97462] = "RallyingCry",
		[106898] = "StampedingRoar",
		[172106] = "AspectOfTheFox",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[90355] = "Bloodlust", -- Ancient Hysteria
		[160452] = "Bloodlust", -- Netherwinds
		-- Tank
		[871] = "ShieldWall",
		[12975] = "LastStand",
		[1160] = "DemoralizingShout",
		[114030] = "Vigilance",
		[31850] = "ArdentDefender",
		[86659] = "GuardianAncientKings",
		[498] = "DivineProtection",
		[48792] = "IceboundFortitude",
		[55233] = "VampiricBlood",
		[22812] = "Barkskin",
		[61336] = "SurvivalInstincts",
		[115203] = "FortifyingBrew",
		[115176] = "ZenMeditation",
		-- Healing
		[33206] = "PainSuppression",
		[62618] = "Barrier",
		[47788] = "GuardianSpirit",
		[64843] = "DivineHymn",
		[102342] = "Ironbark",
		[740] = "Tranquility",
		[6940] = "Sacrifice",
		[31821] = "DevotionAura",
		[98008] = "SpiritLink",
		[116849] = "LifeCocoon",
		[115310] = "Revival",
		[51052] = "AntiMagicZone",
		[76577] = "SmokeBomb",
		[159916] = "AmplifyMagic",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[47788] = "GuardianSpiritOff",
		[115176] = "ZenMeditationOff",
		[64843] = "DivineHymnOff",
		[740] = "TranquilityOff",
		[116849] = "LifeCocoonOff",
	}
	combatLogMap.SPELL_CREATE = {
		[11419] = "Portals", -- Darnassus
		[32266] = "Portals", -- Exodar
		[11416] = "Portals", -- Ironforge
		[11417] = "Portals", -- Orgrimmar
		[33691] = "Portals", -- Shattrath (Alliance)
		[35717] = "Portals", -- Shattrath (Horde)
		[32267] = "Portals", -- Silvermoon
		[10059] = "Portals", -- Stormwind
		[11420] = "Portals", -- Thunder Bluff
		[11418] = "Portals", -- Undercity
		[49360] = "Portals", -- Theramore
		[49361] = "Portals", -- Stonard
		[53142] = "Portals", -- Dalaran
		[88345] = "Portals", -- Tol Barad (Alliance)
		[88346] = "Portals", -- Tol Barad (Horde)
		[132620] = "Portals", -- Vale of Eternal Blossoms (Alliance)
		[132626] = "Portals", -- Vale of Eternal Blossoms (Horde)
		[176246] = "Portals", -- Stormshield (Alliance)
		[176244] = "Portals", -- Warspear (Horde)
	}
	combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth
		[95750] = "Rebirth", -- Soulstone Resurrection
		[61999] = "Rebirth", -- Raise Ally
		[126393] = "Rebirth", -- Eternal Guardian (Hunter pet)
		[159931] = "Rebirth", -- Gift of Chi-Ji (Hunter pet)
		[159956] = "Rebirth", -- Dust of Life (Hunter pet)
	}
	combatLogMap.SPELL_SUMMON = {
		[114192] = "MockingBanner",
	}
end

-- 6.1 DB cleanup
local function updateProfile()
	local db = mod.db.profile
	-- migrate old settings
	for key in next, mod.toggleDefaults do
		if type(key) == "number" then
			local oldKey = GetSpellInfo(key)
			if db[oldKey] then
				db[key] = db[oldKey]
				db[oldKey] = nil
			end
		end
	end
	-- delete old keys
	for key in next, db do
		if not mod.toggleDefaults[key] then
			db[key] = nil
		end
	end
end

function mod:OnPluginEnable()
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:ZONE_CHANGED_NEW_AREA()
end

local registered = nil
function mod:ZONE_CHANGED_NEW_AREA()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "raid" or instanceType == "party") then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		registered = true
	elseif registered then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		registered = nil
	end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, _, source, _, _, _, player, _, _, spellId, spellName)
	local f = combatLogMap[event] and combatLogMap[event][spellId] or nil
	if f and player then
		self[f](self, player:gsub("%-.+", "*"), spellId, source:gsub("%-.+", "*"), spellName)
	elseif f then
		self[f](self, player, spellId, source:gsub("%-.+", "*"), spellName)
	end
end

local green = "Positive"   -- utility/healer cds
local orange = "Urgent"    -- dangerous healer cds
local yellow = "Attention" -- targeted healer cds
local red = "Important"    -- dps cds
local blue = "Personal"    -- everything else

local C = BigWigs.C
local bit_band = bit.band
local function checkFlag(key, flag)
	return bit_band(mod.db.profile[key], flag) == flag
end
local icons = setmetatable({}, {__index =
	function(self, key)
		local icon = GetSpellTexture(key)
		self[key] = icon
		return icon
	end
})
local function message(key, text, color, icon)
	if not checkFlag(key, C.MESSAGE) then return end
	mod:SendMessage("BigWigs_Message", mod, key, text, color, icons[icon or key])
end
local function bar(key, length, player, text, icon)
	if nonCombat[key] then
		if InCombatLockdown() then return end
		firedNonCombat[text] = player or false
	end
	if checkFlag(key, C.BAR) then
		mod:SendMessage("BigWigs_StartBar", mod, key, player and CL.other:format(text, player) or text, length, icons[icon or key])
	end
	if checkFlag(key, C.EMPHASIZE) then
		mod:SendMessage("BigWigs_StartEmphasize", mod, player and CL.other:format(text, player) or text, length)
	end
end
local function stopbar(text, player)
	mod:SendMessage("BigWigs_StopBar", mod, player and CL.other:format(text, player) or text)
	mod:SendMessage("BigWigs_StopEmphasize", mod, player and CL.other:format(text, player) or text)
end

function mod:PLAYER_REGEN_DISABLED()
	for text, player in next, firedNonCombat do
		stopbar(text, player)
	end
	wipe(firedNonCombat)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Repair(_, spellId, nick, spellName)
	message("repair", L.used_cast:format(nick, spellName), blue, spellId)
	-- scrapbot = 5min, walter = 6min, field repair bot/jeeves = 10min
	bar("repair", spellId == 54711 and 300 or spellId == 157066 and 360 or 600, nick, spellName, spellId)
end

do
	local feast = GetSpellInfo(66477)
	function mod:Feasts(_, spellId, nick, spellName)
		message("feast", L.feast_cast:format(nick, spellName), blue, spellId)
		bar("feast", 180, nick, feast, spellId)
	end
end

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L.portal_cast:format(nick, spellName), blue, spellId)
	bar("portal", 65, L.portal_bar:format(spellName, nick), nick, spellName, spellId)
end

function mod:SummoningStone(_, spellId, nick, spellName)
	message(spellId, L.ritual_cast:format(nick, spellName), blue)
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
end

function mod:Soulwell(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
end

do
	local prev = 0
	function mod:Bloodlust(_, spellId, nick, spellName)
		local t = GetTime()
		if t-prev > 40 then
			message(2825, L.used_cast:format(nick, spellName), red, spellId)
			bar(2825, 40, nick, spellName, spellId)
			prev = t
		end
	end
end

function mod:SpiritLink(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), orange)
	bar(spellId, 6, nick, spellName)
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), yellow)
	bar(spellId, 8, target, spellName)
end

function mod:GuardianSpirit(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), yellow)
	bar(spellId, 10, target, spellName)
end

function mod:GuardianSpiritOff(target, spellId, nick, spellName)
	stopbar(spellName, nick, spellName) --removed on absorbed fatal blow
end

function mod:Barrier(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:DivineHymn(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), green)
	bar(spellId, 8, nick, spellName)
end

function mod:DivineHymnOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:Sacrifice(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), orange)
	bar(spellId, 12, target, spellName)
end

function mod:DevotionAura(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:DivineProtection(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:GuardianAncientKings(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 15, nick, spellName)
end

function mod:RallyingCry(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:Vigilance(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), orange)
	bar(spellId, 12, target, spellName)
end

function mod:DemoralizingShout(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:MockingBanner(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), orange)
	bar(spellId, 30, nick, spellName)
end

function mod:IceboundFortitude(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:VampiricBlood(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:AntiMagicZone(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 3, nick, spellName)
end

function mod:Barkskin(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 12, nick, spellName)
end

function mod:SurvivalInstincts(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L.usedon_cast:format(nick, spellName, target), green, spellId)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), yellow)
	bar(spellId, 12, target, spellName)
end

function mod:Tranquility(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), green)
	bar(spellId, 8, nick, spellName)
end

function mod:TranquilityOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:StampedingRoar(_, spellId, nick, spellName)
	message(106898, L.used_cast:format(nick, spellName), green)
	bar(106898, 8, nick, spellName)
end

function mod:FortifyingBrew(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 15, nick, spellName)
end

function mod:ZenMeditation(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), yellow)
	bar(spellId, 8, nick, spellName)
end

function mod:ZenMeditationOff(_, spellId, nick, spellName)
	stopbar(spellName, nick) --removed on melee
end

function mod:LifeCocoon(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target), yellow)
	bar(spellId, 12, target, spellName)
end

function mod:LifeCocoonOff(target, spellId, nick, spellName)
	stopbar(spellName, target)
end

function mod:Revival(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), green)
end

function mod:SmokeBomb(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 5, nick, spellName)
end

function mod:AmplifyMagic(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:AspectOfTheFox(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), green)
	bar(spellId, 6, nick, spellName)
end

