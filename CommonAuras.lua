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

	L["Common Auras"] = true
	L["Noncombat"] = true
	L["Group utility"] = true
	L["Tanking cooldowns"] = true
	L["Healing cooldowns"] = true
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "ruRU")
if L then
	L.usedon_cast = "%s: %s на %s"
	L.used_cast = "%s использовал %s."
	L.ritual_cast = "%s wants to perform a %s!"

	L.portal = "Портал"
	L.portal_desc = "Переключение отображения порталов мага."
	L.portal_cast = "%s открыл %s!"
	L.portal_bar = "%s (%s)"

	L.repair = "Ремонтный робот"
	L.repair_desc = "Вкл/выкл оповещение о доступности ремонтного робота."

	L.feast = "Feasts"
	L.feast_desc = "Toggle showing when feasts get prepared."
	L.feast_cast = "%s prepared a %s!"

	L.rebirth = "Rebirth"
	L.rebirth_desc = "Toggle showing combat resurrections."

	L["Common Auras"] = "Основные ауры"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "Полезность группы"
	L["Tanking cooldowns"] = "Восстоновления танка"
	L["Healing cooldowns"] = "Восстоновления лекаря"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhCN")
if L then
	L.usedon_cast = "%s：%s于%s"
	L.used_cast = " %s使用：%s。"
	L.ritual_cast = "%s想进行一次%s！"

	L.portal = "传送门"
	L.portal_desc = "打开或关闭显示法师传送门时提示。"
	L.portal_cast = "%s施放了一道%s！"
	L.portal_bar = "%s (%s)"

	L.repair = "修理机器人"
	L.repair_desc = "打开或关闭显示修理机器人可用时提示。"

	L.feast = "盛宴"
	L.feast_desc = "打开或关闭显示盛宴可用时提示。"
	L.feast_cast = "%s准备了一顿%s！"

	L.rebirth = "复生"
	L.rebirth_desc = "打开或关闭显示战斗复活提示。"

	L["Common Auras"] = "普通光环"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "组效果"
	L["Tanking cooldowns"] = "坦克冷却"
	L["Healing cooldowns"] = "治疗冷却"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhTW")
if L then
	L.usedon_cast = "%s：%s於%s"
	L.used_cast = " %s使用：%s。"
	L.ritual_cast = "%s wants to perform a %s!"

	L.portal = "傳送門"
	L.portal_desc = "打開或關閉顯示法師傳送門時提示。"
	L.portal_cast = "%s施放了一道%s！"
	L.portal_bar = "%s (%s)"

	L.repair = "修理機器人"
	L.repair_desc = "打開或關閉顯示修理機器人可用時提示。"

	L.feast = "Feasts"
	L.feast_desc = "Toggle showing when feasts get prepared."
	L.feast_cast = "%s prepared a %s!"

	L.rebirth = "Rebirth"
	L.rebirth_desc = "Toggle showing combat resurrections."

	L["Common Auras"] = "共同光環"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "組效果"
	L["Tanking cooldowns"] = "坦克冷卻"
	L["Healing cooldowns"] = "治療冷卻"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "koKR")
if L then
	L.usedon_cast = "%1$s: %3$s에게 %2$s"
	L.used_cast = "%s: %s 사용"
	L.ritual_cast = "%s - %s 사용!"

	L.portal = "차원문"
	L.portal_desc = "마법사의 차원문 표시합니다."
	L.portal_cast = "%s - %s 차원문!"
	L.portal_bar = "%s (%s)"

	L.repair = "수리 로봇"
	L.repair_desc = "수리 로봇 사용시 표시합니다."

	L.feast = "음식"
	L.feast_desc = "전체 음식 사용시 표시합니다."
	L.feast_cast = "%s - %s 사용!"

	L["Common Auras"] = "공통 버프"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "그룹에 유용한 것"
	L["Tanking cooldowns"] = "탱킹 재사용 대기시간"
	L["Healing cooldowns"] = "힐링 재사용 대기시간"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "deDE")
if L then
	L.usedon_cast = "%s: %s auf %s"
	L.used_cast = "%s: %s"
	L.ritual_cast = "%s will %s stellen!"

	L.portal = "Portale"
	L.portal_desc = "Zeigt die Portale der Magier an."
	L.portal_cast = "%s öffnet %s!"
	L.portal_bar = "%s (%s)"

	L.repair = "Reparaturbots"
	L.repair_desc = "Zeigt Reparaturbots an, sobald sie aufgestellt wurden."

	L.feast = "Festmähler"
	L.feast_desc = "Zeigt Festmähler an, sobald sie zubereitet wurden."
	L.feast_cast = "%s hat %s zubereitet!"

	L.rebirth = "Battle Res"
	L.rebirth_desc = "Zeigt ausgeführte Battle Resses an."

	L["Common Auras"] = "Common Auras"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "Gruppenwerkzeuge"
	L["Tanking cooldowns"] = "Tank-Cooldowns"
	L["Healing cooldowns"] = "Heil-Cooldowns"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "frFR")
if L then
	L.usedon_cast = "%s : %s sur %s"
	L.used_cast = "%s a utilisé %s."
	L.ritual_cast = "%s souhaite effectuer un %s !"

	L.portal = "Portail"
	L.portal_desc = "Prévient quand un mage ouvre un portail."
	L.portal_cast = "%s a ouvert un %s !"
	L.portal_bar = "%s (%s)"

	L.repair = "Robot réparateur"
	L.repair_desc = "Prévient quand un robot réparateur est déployé."

	L.feast = "Festins"
	L.feast_desc = "Prévient quand des festins sont préparés."
	L.feast_cast = "%s a préparé un %s !"

	L.rebirth = "Renaissance"
	L.rebirth_desc = "Prévient quand des ressurections en combat sont effectuées."

	L["Common Auras"] = "Auras habituelles"
	L["Noncombat"] = "Noncombat"
	L["Group utility"] = "Utilité de groupe"
	L["Tanking cooldowns"] = "Temps de recharge de tank"
	L["Healing cooldowns"] = "Temps de recharge de soigneur"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "itIT")
if L then
	L.usedon_cast = "%s : %s su %s"
	L.used_cast = "%s ha usato %s."
	L.ritual_cast = "%s sta evocando %s!"

	L.portal = "Portale"
	L.portal_desc = "Avvisa quando un mago apre un portale."
	L.portal_cast = "%s ha aperto un %s !"
	L.portal_bar = "%s (%s)"

	L.repair = "Robot di Riparazione"
	L.repair_desc = "Avvisa quando un Robot di Riparazione è disponibile."

	L.feast = "Banchetti"
	L.feast_desc = "Avvisa quando vengono messi a disposizione dei Banchetti."
	L.feast_cast = "%s ha preparato un %s !"

	L.rebirth = "Resurrezione"
	L.rebirth_desc = "Avvisa quando viene utilizzata un'abilità di Resurrezione in combattimento."

	L["Common Auras"] = "Auree Comuni"
	L["Noncombat"] = "Fuori dal Combattimento"
	L["Group utility"] = "Utilità di Gruppo"
	L["Tanking cooldowns"] = "Tempi di Recupero per Difensori"
	L["Healing cooldowns"] = "Tempi di Recupero per Guaritori"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common Auras")

------------------------------
--      Module              --
------------------------------

local mod, CL = BigWigs:NewPlugin(L[name])
if not mod then return end

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

function mod:GetLocale() return L end

------------------------------
--      Initialization      --
------------------------------

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

function mod:OnPluginEnable()
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

local green = "Positive"   -- utility/healing cds
local orange = "Urgent"    -- dangerous healer cds
local yellow = "Attention" -- targeted healer cds
local red = "Important"    -- dps cds
local blue = "Personal"    -- everything else

local C = BigWigs.C
local function checkFlag(key, flag)
	return bit.band(mod.db.profile[key], flag) == flag
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
		mod:SendMessage("BigWigs_StartBar", mod, key, player and CL["other"]:format(text, player) or text, length, icons[icon or key])
	end
	if checkFlag(key, C.EMPHASIZE) then
		mod:SendMessage("BigWigs_StartEmphasize", mod, player and CL["other"]:format(text, player) or text, length)
	end
end
local function stopbar(text, player)
	mod:SendMessage("BigWigs_StopBar", mod, player and CL["other"]:format(text, player) or text)
	mod:SendMessage("BigWigs_StopEmphasize", mod, player and CL["other"]:format(text, player) or text)
end

function mod:PLAYER_REGEN_DISABLED()
	for text, player in next, firedNonCombat do
		stopbar(text, player)
	end
	wipe(firedNonCombat)
end

------------------------------
--      Events              --
------------------------------


function mod:Repair(_, spellId, nick, spellName)
	message("repair", L["used_cast"]:format(nick, spellName), blue, spellId)
	-- scrapbot = 5min, walter = 6min, field repair bot/jeeves = 10min
	bar("repair", spellId == 54711 and 300 or spellId == 157066 and 360 or 600, nick, spellName, spellId)
end

do
	local feast = GetSpellInfo(66477)
	function mod:Feasts(_, spellId, nick, spellName)
		message("feast", L["feast_cast"]:format(nick, spellName), blue, spellId)
		bar("feast", 180, nick, feast, spellId)
	end
end

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L["portal_cast"]:format(nick, spellName), blue, spellId)
	bar("portal", 65, L["portal_bar"]:format(spellName, nick), nick, spellName, spellId)
end

function mod:SummoningStone(_, spellId, nick, spellName)
	message(spellId, L["ritual_cast"]:format(nick, spellName), blue)
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
end

function mod:Soulwell(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
end

do
	local prev = 0
	function mod:Bloodlust(_, spellId, nick, spellName)
		local t = GetTime()
		if t-prev > 40 then
			message(2825, L["used_cast"]:format(nick, spellName), red, spellId)
			bar(2825, 40, nick, spellName, spellId)
			prev = t
		end
	end
end

function mod:SpiritLink(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), orange)
	bar(spellId, 6, nick, spellName)
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), yellow)
	bar(spellId, 8, target, spellName)
end

function mod:GuardianSpirit(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), yellow)
	bar(spellId, 10, target, spellName)
end

function mod:GuardianSpiritOff(target, spellId, nick, spellName)
	stopbar(spellName, nick, spellName) --removed on absorbed fatal blow
end

function mod:Barrier(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:DivineHymn(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), green)
	bar(spellId, 8, nick, spellName)
end

function mod:DivineHymnOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:Sacrifice(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), orange)
	bar(spellId, 12, target, spellName)
end

function mod:DevotionAura(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:DivineProtection(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:GuardianAncientKings(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 15, nick, spellName)
end

function mod:RallyingCry(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:Vigilance(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), orange)
	bar(spellId, 12, target, spellName)
end

function mod:DemoralizingShout(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:MockingBanner(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), orange)
	bar(spellId, 30, nick, spellName)
end

function mod:IceboundFortitude(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 8, nick, spellName)
end

function mod:VampiricBlood(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 10, nick, spellName)
end

function mod:AntiMagicZone(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 3, nick, spellName)
end

function mod:Barkskin(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 12, nick, spellName)
end

function mod:SurvivalInstincts(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L["usedon_cast"]:format(nick, spellName, target), green, spellId)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), yellow)
	bar(spellId, 12, target, spellName)
end

function mod:Tranquility(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), green)
	bar(spellId, 8, nick, spellName)
end

function mod:TranquilityOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:StampedingRoar(_, spellId, nick, spellName)
	message(106898, L["used_cast"]:format(nick, spellName), green)
	bar(106898, 8, nick, spellName)
end

function mod:FortifyingBrew(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 15, nick, spellName)
end

function mod:ZenMeditation(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), yellow)
	bar(spellId, 8, nick, spellName)
end

function mod:ZenMeditationOff(_, spellId, nick, spellName)
	stopbar(spellName, nick) --removed on melee
end

function mod:LifeCocoon(target, spellId, nick, spellName)
	message(spellId, L["usedon_cast"]:format(nick, spellName, target), yellow)
	bar(spellId, 12, target, spellName)
end

function mod:LifeCocoonOff(target, spellId, nick, spellName)
	stopbar(spellName, target)
end

function mod:Revival(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), green)
end

function mod:SmokeBomb(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 5, nick, spellName)
end

function mod:AmplifyMagic(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), blue)
	bar(spellId, 6, nick, spellName)
end

function mod:AspectOfTheFox(_, spellId, nick, spellName)
	message(spellId, L["used_cast"]:format(nick, spellName), green)
	bar(spellId, 6, nick, spellName)
end

