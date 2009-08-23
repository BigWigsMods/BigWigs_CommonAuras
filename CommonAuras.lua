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

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)
L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	usedon_cast = "%s: %s on %s",
	usedon_bar = "%s: %s Cooldown",

	used_cast = "%s used %s.",
	used_bar = "%s: %s",

	portal = "Portal",
	portal_desc = "Toggle showing of mage portals.",
	portal_cast = "%s opened a %s!", --Player opened a Portal: Destination

	repair = "Repair Bot",
	repair_desc = "Toggle showing when repair bots are available.",

	["Common Auras"] = true,
} end )

L:RegisterTranslations("ruRU", function() return {
	fw_cast = "%s защитил от страха |3-3(%s).",
	fw_bar = "%s: Восстановление антистраха",

	usedon_cast = "%s: %s на %s",
	usedon_bar = "%s: %s восстановление",

	used_cast = "%s использовал %s.",
	used_bar = "%s: %s",

	portal_cast = "%s открыл %s!", --Player opened a Portal: Destination

	["Common Auras"] = "Основные ауры",
} end )

L:RegisterTranslations("zhCN", function() return {
	fw_cast = "%s：防护恐惧结界于%s",
	fw_bar = "<%s：防护恐惧结界 冷却>",

	usedon_cast = "%s：%s于%s",
	usedon_bar = "<%s：%s 冷却>",

	used_cast = " %s使用：%s。",
	used_bar = "<%s：%s>",

	portal = "传送门",
	portal_desc = "打开或关闭显示法师传送门时提示。",
	portal_cast = "%s施放了一道%s！",

	repair = "修理机器人",
	repair_desc = "打开或关闭显示修理机器人可用时提示。",

	["Common Auras"] = "普通光环",
} end )

L:RegisterTranslations("zhTW", function() return {
	fw_cast = "%s：防護恐懼結界於%s",
	fw_bar = "<%s：防護恐懼結界 冷卻>",

	usedon_cast = "%s：%s於%s",
	usedon_bar = "<%s：%s 冷卻>",

	used_cast = " %s使用：%s。",
	used_bar = "<%s：%s>",

	portal = "傳送門",
	portal_desc = "打開或關閉顯示法師傳送門時提示。",
	portal_cast = "%s施放了一道%s！",

	repair = "修理機器人",
	repair_desc = "打開或關閉顯示修理機器人可用時提示。",

	["Common Auras"] = "共同光環",
} end )

L:RegisterTranslations("koKR", function() return {
	fw_cast = "%s: %s에게 공포의 수호물",
	fw_bar = "%s: 공수 대기시간",

	usedon_cast = "%1$s: %3$s에게 %2$s",
	usedon_bar = "%s: %s 대기시간",

	used_cast = "%s: %s 사용",
	used_bar = "%s: %s",

	portal = "차원문",
	portal_desc = "마법사의 차원문 표시합니다.",
	portal_cast = "%s: %s 차원문!",

	repair = "수리 로봇",
	repair_desc = "수리 로봇 사용시 표시합니다.",

	["Common Auras"] = "공통 버프",
} end )

L:RegisterTranslations("deDE", function() return {
	fw_cast = "%s: Furchtschutz auf %s",
	fw_bar = "%s: Furchtschutz (CD)",

	usedon_cast = "%s: %s auf %s",
	usedon_bar = "%s: %s (CD)",

	used_cast = "%s benutzt %s",
	used_bar = "%s: %s",

	portal_cast = "%s öffnet ein %s!",
} end )

L:RegisterTranslations("frFR", function() return {
	fw_cast = "%s a protégé %s contre la peur .",
	fw_bar = "%s : Recharge Gardien",

	usedon_cast = "%s : %s sur %s",
	usedon_bar = "%s : Recharge %s",

	used_cast = "%s a utilisé %s.",
	used_bar = "%s : %s",

	portal = "Portail",
	portal_desc = "Prévient ou non quand un mage ouvre un portail.",
	portal_cast = "%s a ouvert un %s !",

	repair = "Robot réparateur",
	repair_desc = "Prévient ou non quand un robot réparateur est déployé.",

	["Common Auras"] = "Auras courantes",
} end )

------------------------------
--      Module              --
------------------------------

local mod = BigWigs:New(L[name], "$Revision$")
mod.synctoken = name
mod.consoleCmd = "commonauras"
mod.toggleoptions = { "portal", "repair", 6346, 871, 47788, 29166, 6940, 64205, 498, 33206, 32182, 2825 }
mod.external = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "FearWard", 6346) --Fear Ward
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Repair", 22700, 44389, 54711, 67826) --Field Repair Bot 74A, Field Repair Bot 110G, Scrapbot, Jeeves
	self:AddCombatListener("SPELL_CREATE", "Portals", 11419, 32266,
		11416, 11417, 33691, 35717, 32267, 10059, 11420, 11418, 49360, 49361, 53142
	) --Portals, http://www.wowhead.com/?search=portal#abilities
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 871) --Shield Wall
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Innervate", 29166) --Innervate
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bloodlust", 2825, 32182) -- Bloodlust and Heroism
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Guardian", 47788) --Guardian Spirit
	self:AddCombatListener("SPELL_AURA_REMOVED", "GuardianOff", 47788) --Guardian Spirit
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Sacrifice", 6940) --Hand of Sacrifice
	self:AddCombatListener("SPELL_CAST_SUCCESS", "DivineSacrifice", 64205) --Divine Sacrifice
	self:AddCombatListener("SPELL_CAST_SUCCESS", "DivineProtection", 498) --Divine Protection
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Suppression", 33206)
end

------------------------------
--      Events              --
------------------------------

local green = {r = 0, g = 1, b = 0}
local blue = {r = 0, g = 0, b = 1}
local orange = {r = 1, g = 0.75, b = 0.14}
local yellow = {r = 1, g = 1, b = 0}
local red = {r = 1, g = 0, b = 0}

function mod:Suppression(target, spellId, nick, _, spellName)
	self:IfMessage(L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	self:Bar(L["used_bar"]:format(target, spellName), 10, spellId)
end

function mod:Bloodlust(_, spellId, nick, _, spellName)
	self:TargetMessage(L["used_cast"], nick, red, spellId, nil, spellName)
	self:Bar(L["used_bar"]:format(nick, spellName), 300, spellId)
end

function mod:Guardian(target, spellId, nick, _, spellName)
	self:IfMessage(L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	self:Bar(L["used_bar"]:format(target, spellName), 10, spellId)
end

function mod:GuardianOff(target, spellId, nick, _, spellName) --Need to remove if fatal blow received and prevented
	self:TriggerEvent("BigWigs_StopBar", self, L["used_bar"]:format(target, spellName))
end

function mod:Sacrifice(target, spellId, nick, _, spellName)
	self:Message(L["usedon_cast"]:format(nick, spellName, target), orange, nil, nil, nil, spellId)
	self:Bar(L["used_bar"]:format(target, spellName), 12, spellId)
end

function mod:DivineSacrifice(_, spellId, nick, _, spellName)
	self:TargetMessage(L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:DivineProtection(_, spellId, nick, _, spellName)
	self:TargetMessage(L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:FearWard(target, spellId, nick, _, spellName)
	self:IfMessage(L["fw_cast"]:format(nick, target), green, spellId)
	self:Bar(L["fw_bar"]:format(nick), 180, spellId)
end

function mod:Repair(_, spellId, nick, _, spellName)
	if self.db.profile.repair then
		self:TargetMessage(L["used_cast"], nick, blue, spellId, nil, spellName)
		self:Bar(L["used_bar"]:format(nick, spellName), spellId == 54711 and 300 or 600, spellId)
	end
end

function mod:Portals(_, spellId, nick, _, spellName)
	if self.db.profile.portal then
		self:TargetMessage(L["portal_cast"], nick, blue, spellId, nil, spellName)
		self:Bar(spellName.." ("..nick..")", 60, spellId)
	end
end

function mod:ShieldWall(_, spellId, nick, _, spellName)
	self:TargetMessage(L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:Innervate(target, spellId, nick, _, spellName)
	self:IfMessage(L["usedon_cast"]:format(nick, spellName, target), green, spellId)
	self:Bar(L["usedon_bar"]:format(nick, spellName), 180, spellId)
end

