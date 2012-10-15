--[[
--
-- BigWigs Strategy Module - Common Auras
--
-- Gives timer bars and raid messages about common
-- buffs and debuffs.
--
--]]

local name = "Common Auras"

------------------------------
--      Localization        --
------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "enUS", true)
if L then
	L.usedon_cast = "%s: %s on %s"
	L.used_cast = "%s used %s."
	L.used_bar = "%s: %s"

	L.portal = "Portal"
	L.portal_desc = "Toggle showing of mage portals."
	L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination
	L.portal_icon = 53142

	L.repair = "Repair Bot"
	L.repair_desc = "Toggle showing when repair bots are available."
	L.repair_icon = 67826

	L.feast = "Feasts/Cauldrons"
	L.feast_desc = "Toggle showing when feasts/cauldrons get prepared."
	L.feast_cast = "%s prepared a %s!"
	L.feast_icon = 44102

	L.ritual = "Ritual of Summoning/Souls"
	L.ritual_desc = "Toggles Ritual of Summoning/Souls warning - click the green circle!"
	L.ritual_cast = "%s wants to perform a %s!"
	L.ritual_icon = 698

	L.rebirth = "Rebirth"
	L.rebirth_desc = "Toggle showing combat resurrections."
	L.rebirth_icon = 20484

	L["Common Auras"] = true
	L["Group utility"] = true
	L["Tanking cooldowns"] = true
	L["Healing cooldowns"] = true
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "ruRU")
if L then
	L.usedon_cast = "%s: %s на %s"
	L.used_cast = "%s использовал %s."
	L.used_bar = "%s: %s"

	L.portal = "Портал"
	L.portal_desc = "Переключение отображения порталов мага."
	L.portal_cast = "%s открыл %s!" --Player opened a Portal: Destination

	L.repair = "Ремонтный робот"
	L.repair_desc = "Вкл/выкл оповещение о доступности ремонтного робота."

	L["Common Auras"] = "Основные ауры"
	L["Group utility"] = "Полезность группы"
	L["Tanking cooldowns"] = "Восстоновления танка"
	L["Healing cooldowns"] = "Восстоновления лекаря"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhCN")
if L then
	L.usedon_cast = "%s：%s于%s"
	L.used_cast = " %s使用：%s。"
	L.used_bar = "%s：%s"

	L.portal = "传送门"
	L.portal_desc = "打开或关闭显示法师传送门时提示。"
	L.portal_cast = "%s施放了一道%s！"

	L.repair = "修理机器人"
	L.repair_desc = "打开或关闭显示修理机器人可用时提示。"

	L.feast = "盛宴/药锅"
	L.feast_desc = "打开或关闭显示盛宴/药锅可用时提示。"
	L.feast_cast = "%s准备了一顿%s！"

	L.ritual = "召唤/灵魂仪式"
	L.ritual_desc = "打开或关闭显示召唤/灵魂仪式可用时提示 - 点击绿色圆圈！"
	L.ritual_cast = "%s想进行一次%s！"

	L.rebirth = "复生"
	L.rebirth_desc = "打开或关闭显示战斗复活提示。"

	L["Common Auras"] = "普通光环"
	L["Group utility"] = "组效果"
	L["Tanking cooldowns"] = "坦克冷却"
	L["Healing cooldowns"] = "治疗冷却"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhTW")
if L then
	L.usedon_cast = "%s：%s於%s"
	L.used_cast = " %s使用：%s。"
	L.used_bar = "%s：%s"

	L.portal = "傳送門"
	L.portal_desc = "打開或關閉顯示法師傳送門時提示。"
	L.portal_cast = "%s施放了一道%s！"

	L.repair = "修理機器人"
	L.repair_desc = "打開或關閉顯示修理機器人可用時提示。"

	L["Common Auras"] = "共同光環"
	L["Group utility"] = "組效果"
	L["Tanking cooldowns"] = "坦克冷卻"
	L["Healing cooldowns"] = "治療冷卻"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "koKR")
if L then
	L.usedon_cast = "%1$s: %3$s에게 %2$s"
	L.used_cast = "%s: %s 사용"
	L.used_bar = "%s: %s"

	L.portal = "차원문"
	L.portal_desc = "마법사의 차원문 표시합니다."
	L.portal_cast = "%s - %s 차원문!"

	L.repair = "수리 로봇"
	L.repair_desc = "수리 로봇 사용시 표시합니다."

	L.feast = "음식/가마솥"
	L.feast_desc = "전체 음식/가마솥 사용시 표시합니다."
	L.feast_cast = "%s - %s 사용!"

	L.ritual = "영혼/소환 의식"
	L.ritual_desc = "영혼/소환 의식을 알립니다 - 녹색 원을 클릭하셈!"
	L.ritual_cast = "%s - %s 사용!"

	L["Common Auras"] = "공통 버프"
	L["Group utility"] = "그룹에 유용한 것"
	L["Tanking cooldowns"] = "탱킹 재사용 대기시간"
	L["Healing cooldowns"] = "힐링 재사용 대기시간"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "deDE")
if L then
	L.usedon_cast = "%s: %s auf %s"
	L.used_cast = "%s: %s"
	L.used_bar = "%s: %s"

	L.portal = "Portale"
	L.portal_desc = "Zeigt die Portale der Magier an."
	L.portal_cast = "%s öffnet %s!"

	L.repair = "Reparaturbots"
	L.repair_desc = "Zeigt Reparaturbots an, sobald sie aufgestellt wurden."

	L.feast = "Festmähler/Kessel"
	L.feast_desc = "Zeigt Festmähler/Kessel an, sobald sie zubereitet wurden."
	L.feast_cast = "%s hat %s zubereitet!"

	L.ritual = "Ritual der Beschwörung/Seelen"
	L.ritual_desc = "Zeigt eine Warnung für Ritual der Beschwörung/Seelen an - klicke auf den grünen Kreis!"
	L.ritual_cast = "%s will %s stellen!"

	L.rebirth = "Battle Res"
	L.rebirth_desc = "Zeigt ausgeführte Battle Resses an."

	L["Common Auras"] = "Common Auras"
	L["Group utility"] = "Gruppenwerkzeuge"
	L["Tanking cooldowns"] = "Tank-Cooldowns"
	L["Healing cooldowns"] = "Heil-Cooldowns"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "frFR")
if L then
	L.usedon_cast = "%s : %s sur %s"
	L.used_cast = "%s a utilisé %s."
	L.used_bar = "%s : %s"

	L.portal = "Portail"
	L.portal_desc = "Prévient quand un mage ouvre un portail."
	L.portal_cast = "%s a ouvert un %s !"

	L.repair = "Robot réparateur"
	L.repair_desc = "Prévient quand un robot réparateur est déployé."

	L.feast = "Festins/Chaudrons"
	L.feast_desc = "Prévient quand des festins ou des chaudrons sont préparés."
	L.feast_cast = "%s a préparé un %s !"

	L.ritual = "Rituel d'invocation/des âmes"
	L.ritual_desc = "Prévient quand un rituel d'invocation/des âmes est effectué - cliquez sur le cercle vert !"
	L.ritual_cast = "%s souhaite effectuer un %s !"

	L.rebirth = "Renaissance"
	L.rebirth_desc = "Prévient quand des ressurections en combat sont effectuées."

	L["Common Auras"] = "Auras habituelles"
	L["Group utility"] = "Utilité de groupe"
	L["Tanking cooldowns"] = "Temps de recharge de tank"
	L["Healing cooldowns"] = "Temps de recharge de soigneur"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common Auras")

------------------------------
--      Module              --
------------------------------

local mod = BigWigs:NewPlugin(L[name])
if not mod then return end

mod.toggleOptions = {
	"portal", "repair", "feast", "ritual", 92827, 97462, 2825, 120668, 114207, 
	871, 12975, 498, 31850, 20925, 48792, 55233, 22812, 61336, 114203, 114192,
	33206, 47788, 102342, 29166, 6940, "rebirth", 
}
mod.optionHeaders = {
	portal = L["Group utility"],
	[871] = L["Tanking cooldowns"],
	[33206] = L["Healing cooldowns"],
}

function mod:GetLocale() return L end

------------------------------
--      Initialization      --
------------------------------

local nonCombat = {
	-- Map of spells to only show out of combat.
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.
local combatLogMap = {}
function mod:OnRegister()
	combatLogMap.SPELL_CAST_START = {
		[57426] = "Feasts", -- Fish Feast
		[57301] = "Feasts", -- Great Feast
		[66476] = "Feasts", -- Bountiful Feast
		[87643] = "Feasts", -- Broiled Dragon Feast
		[87915] = "Feasts", -- Goblin Barbecue Feast
		[87644] = "Feasts", -- Seafood Magnifique Feast
		[92649] = "Feasts", -- Cauldron of Battle
		[92712] = "Feasts", -- Big Cauldron of Battle
		-- MoP Feasts
		-- 10 man
		[126492] = "Feasts", -- Banquet of the Grill
		[126501] = "Feasts", -- Banquet of the Oven
		[126497] = "Feasts", -- Banquet of the Pot
		[126499] = "Feasts", -- Banquet of the Steamer
		[126495] = "Feasts", -- Banquet of the Wok
		[126503] = "Feasts", -- Banquet of the Brew
		[104958] = "Feasts", -- Pandaren Banquet
		-- 25 man
		[126494] = "Feasts", -- Great Banquet of the Grill
		[126502] = "Feasts", -- Great Banquet of the Oven
		[126498] = "Feasts", -- Great Banquet of the Pot
		[126500] = "Feasts", -- Great Banquet of the Steamer
		[126496] = "Feasts", -- Great Banquet of the Wok
		[126504] = "Feasts", -- Great Banquet of the Brew
		[105193] = "Feasts", -- Great Pandaren Banquet
	}
	combatLogMap.SPELL_CAST_SUCCESS = {
		-- Group
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[54711] = "Repair", -- Scrapbot
		[67826] = "Repair", -- Jeeves
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[90355] = "Bloodlust", -- Ancient Hysteria
		[29893] = "Rituals", -- Ritual of Souls
		[698] = "Rituals", -- Ritual of Summoning
		[92827] = "Refreshment", -- Ritual of Refreshment
		[97462] = "RallyingCry",
		[120668] = "StormlashTotem",
		-- Tank
		[871] = "ShieldWall",
		[12975] = "LastStand",
		[31850] = "ArdentDefender",
		[498] = "DivineProtection",
		[20925] = "HolyShield",
		[48792] = "IceboundFortitude",
		[55233] = "VampiricBlood",
		[22812] = "Barkskin",
		[61336] = "SurvivalInstincts",
		-- Healer
		[33206] = "Suppression",
		[47788] = "Guardian",
		[102342] = "Ironbark",
		[29166] = "Innervate",
		[6940] = "Sacrifice",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[47788] = "GuardianOff",
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
		[132626] = "Portals", -- Vale Blossom
		[132626] = "Portals", -- Vale Blossom
	}
	combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth
		[95750] = "Rebirth", -- Soulstone Resurrection
		[61999] = "Rebirth", -- Raise Ally
	}
	combatLogMap.SPELL_SUMMON = {
		[114203] = "DemoralizingBanner",
		[114207] = "SkullBanner",
		[114192] = "MockingBanner",
	}

	local nonCombatTypes = {
		Portals = true,
		Repair = true,
		Feasts = true,
		Rituals = true,
		Refreshment = true,
	}
	for event, tbl in pairs(combatLogMap) do
		for spellId, spellType in pairs(tbl) do
			if nonCombatTypes[spellType] then
				nonCombat[spellId] = true
			end
		end
	end
end
function mod:OnPluginEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:ZONE_CHANGED_NEW_AREA()
end

function mod:PLAYER_REGEN_DISABLED()
	for i, barText in next, firedNonCombat do
		self:SendMessage("BigWigs_StopBar", self, barText)
	end
	wipe(firedNonCombat)
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

------------------------------
--      Events              --
------------------------------

local green = "Positive"
local blue = "Personal"
local orange = "Urgent"
local yellow = "Attention"
local red = "Important"

local C = BigWigs.C
local function checkFlag(key, flag)
	if type(key) == "number" then key = GetSpellInfo(key) end
	return bit.band(mod.db.profile[key], flag) == flag
end

local icons = setmetatable({}, {__index =
	function(self, key)
		local _, _, icon = GetSpellInfo(key)
		self[key] = icon
		return self[key]
	end
})
local function message(key, text, color, icon)
	if not checkFlag(key, C.MESSAGE) then return end
	mod:SendMessage("BigWigs_Message", mod, key, text, color, nil, nil, nil, icons[icon])
end
local function bar(key, text, length, icon)
	if not checkFlag(key, C.BAR) then return end
	if nonCombat[key] then
		if InCombatLockdown() then return end
		firedNonCombat[#firedNonCombat + 1] = text
	end
	mod:SendMessage("BigWigs_StartBar", mod, key, text, length, icons[icon])
end

function mod:Suppression(target, spellId, nick, spellName)
	message(33206, L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	bar(33206, L["used_bar"]:format(target, spellName), 8, spellId)
end

do
	local t = nil
	function mod:Bloodlust(_, spellId, nick, spellName)
		if t and GetTime() < (t + 40) then return end
		t = GetTime()
		message(2825, L["used_cast"]:format(nick, spellName), red, spellId)
		bar(2825, L["used_bar"]:format(nick, spellName), 40, spellId)
	end
end

function mod:Guardian(target, spellId, nick, spellName)
	message(47788, L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	bar(47788, L["used_bar"]:format(target, spellName), 10, spellId)
end

function mod:GuardianOff(target, spellId, nick, spellName) --Need to remove if fatal blow received and prevented
	self:SendMessage("BigWigs_StopBar", self, L["used_bar"]:format(target, spellName))
end

function mod:Sacrifice(target, spellId, nick, spellName)
	message(6940, L["usedon_cast"]:format(nick, spellName, target), orange, spellId)
	bar(6940, L["used_bar"]:format(target, spellName), 12, spellId)
end

function mod:DivineProtection(_, spellId, nick, spellName)
	message(498, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(498, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(31850, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(31850, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:HolyShield(_, spellId, nick, spellName)
	message(20925, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(20925, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:Repair(_, spellId, nick, spellName)
	message("repair", L["used_cast"]:format(nick, spellName), blue, spellId)
	bar("repair", L["used_bar"]:format(nick, spellName), spellId == 54711 and 300 or 600, spellId)
end

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L["portal_cast"]:format(nick, spellName), blue, spellId)
	bar("portal", spellName.." ("..nick..")", 60, spellId)
end

function mod:Feasts(_, spellId, nick, spellName)
	message("feast", L["feast_cast"]:format(nick, spellName), blue, spellId)
	bar("feast", L["used_bar"]:format(nick, spellName), 180, spellId)
end

function mod:Rituals(_, spellId, nick, spellName)
	message("ritual", L["ritual_cast"]:format(nick, spellName), blue, spellId)
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(92827, L["ritual_cast"]:format(nick, spellName), blue, spellId)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(871, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(871, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(12975, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(12975, L["used_bar"]:format(nick, spellName), 20, spellId)
end

function mod:RallyingCry(_, spellId, nick, spellName)
	message(97462, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(97462, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:StormlashTotem(_, spellId, nick, spellName)
	message(120668, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(120668, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:Innervate(target, spellId, nick, spellName)
	message(29166, L["usedon_cast"]:format(nick, spellName, target), green, spellId)
end

function mod:IceboundFortitude(_, spellId, nick, spellName)
	message(48792, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(48792, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:VampiricBlood(_, spellId, nick, spellName)
	message(55233, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(55233, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:Barkskin(_, spellId, nick, spellName)
	message(22812, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(22812, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:SurvivalInstincts(_, spellId, nick, spellName)
	message(61336, L["used_cast"]:format(nick, spellName), blue, spellId)
	bar(61336, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L["usedon_cast"]:format(nick, spellName, target), green, spellId)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(102342, L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	bar(102342, L["used_bar"]:format(target, spellName), 12, spellId)
end

function mod:DemoralizingBanner(_, spellId, nick, spellName)
	message(114203, L["used_cast"]:format(nick, spellName), red, spellId)
	bar(114203, L["used_bar"]:format(nick, spellName), 15, spellId)
end

function mod:SkullBanner(_, spellId, nick, spellName)
	message(114207, L["used_cast"]:format(nick, spellName), yellow, spellId)
	bar(114207, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:MockingBanner(_, spellId, nick, spellName)
	message(114192, L["used_cast"]:format(nick, spellName), green, spellId)
	bar(114192, L["used_bar"]:format(nick, spellName), 30, spellId)
end