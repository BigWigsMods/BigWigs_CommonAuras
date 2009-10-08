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
	L.fw_cast = "%s fearwarded %s."
	L.fw_bar = "%s: FW Cooldown"

	L.usedon_cast = "%s: %s on %s"
	L.usedon_bar = "%s: %s Cooldown"

	L.used_cast = "%s used %s."
	L.used_bar = "%s: %s"
	
	L.portal = "Portal"
	L.portal_desc = "Toggle showing of mage portals."
	L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination

	L.repair = "Repair Bot"
	L.repair_desc = "Toggle showing when repair bots are available."

	L["Common Auras"] = true
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "ruRU")
if L then
	L.fw_cast = "%s защитил от страха |3-3(%s)."
	L.fw_bar = "%s: Восстановление антистраха"

	L.usedon_cast = "%s: %s на %s"
	L.usedon_bar = "%s: %s восстановление"

	L.used_cast = "%s использовал %s."
	L.used_bar = "%s: %s"

	L.portal_cast = "%s открыл %s!" --Player opened a Portal: Destination

	L["Common Auras"] = "Основные ауры"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhCN")
if L then
	L.fw_cast = "%s：防护恐惧结界于%s"
	L.fw_bar = "<%s：防护恐惧结界 冷却>"

	L.usedon_cast = "%s：%s于%s"
	L.usedon_bar = "<%s：%s 冷却>"

	L.used_cast = " %s使用：%s。"
	L.used_bar = "<%s：%s>"

	L.portal = "传送门"
	L.portal_desc = "打开或关闭显示法师传送门时提示。"
	L.portal_cast = "%s施放了一道%s！"

	L.repair = "修理机器人"
	L.repair_desc = "打开或关闭显示修理机器人可用时提示。"

	L["Common Auras"] = "普通光环"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "zhTW")
if L then
	L.fw_cast = "%s：防護恐懼結界於%s"
	L.fw_bar = "<%s：防護恐懼結界 冷卻>"

	L.usedon_cast = "%s：%s於%s"
	L.usedon_bar = "<%s：%s 冷卻>"

	L.used_cast = " %s使用：%s。"
	L.used_bar = "<%s：%s>"

	L.portal = "傳送門"
	L.portal_desc = "打開或關閉顯示法師傳送門時提示。"
	L.portal_cast = "%s施放了一道%s！"

	L.repair = "修理機器人"
	L.repair_desc = "打開或關閉顯示修理機器人可用時提示。"
	
	L["Common Auras"] = "共同光環"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "koKR")
if L then
	L.fw_cast = "%s: %s에게 공포의 수호물"
	L.fw_bar = "%s: 공수 대기시간"

	L.usedon_cast = "%1$s: %3$s에게 %2$s"
	L.usedon_bar = "%s: %s 대기시간"

	L.used_cast = "%s: %s 사용"
	L.used_bar = "%s: %s"

	L.portal = "차원문"
	L.portal_desc = "마법사의 차원문 표시합니다."
	L.portal_cast = "%s: %s 차원문!"
	
	L.repair = "수리 로봇"
	L.repair_desc = "수리 로봇 사용시 표시합니다."
	
	L["Common Auras"] = "공통 버프"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "deDE")
if L then
	L.fw_cast = "%s: Furchtschutz auf %s"
	L.fw_bar = "%s: Furchtschutz (CD)"
	
	L.usedon_cast = "%s: %s auf %s"
	L.usedon_bar = "%s: %s (CD)"

	L.used_cast = "%s benutzt %s"
	L.used_bar = "%s: %s"

	L.portal_cast = "%s öffnet ein %s!"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "frFR")
if L then
	L.fw_cast = "%s a protégé %s contre la peur ."
	L.fw_bar = "%s : Recharge Gardien"

	L.usedon_cast = "%s : %s sur %s"
	L.usedon_bar = "%s : Recharge %s"

	L.used_cast = "%s a utilisé %s."
	L.used_bar = "%s : %s"
	
	L.portal = "Portail"
	L.portal_desc = "Prévient ou non quand un mage ouvre un portail."
	L.portal_cast = "%s a ouvert un %s !"

	L.repair = "Robot réparateur"
	L.repair_desc = "Prévient ou non quand un robot réparateur est déployé."

	L["Common Auras"] = "Auras courantes"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common Auras")


------------------------------
--      Module              --
------------------------------

local mod = BigWigs:NewBoss(L[name], L[name]) -- XXX this should not be a boss!
if not mod then return end
mod.locale = L
mod.zoneName = L[name] -- XXX evil haxors
mod.toggleOptions = { "portal", "repair", 6346, 871, 47788, 29166, 6940, 64205, 498, 33206, 32182, 2825 }

------------------------------
--      Initialization      --
------------------------------

-- XXX evil hacks once more
local enabler = LibStub("AceEvent-3.0"):Embed({})
function enabler:BigWigs_CoreEnabled()
	mod:Enable()
end
enabler:RegisterMessage("BigWigs_CoreEnabled")
--- XXX end evil hacks

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "FearWard", 6346) --Fear Ward
	self:Log("SPELL_CAST_SUCCESS", "Repair", 22700, 44389, 54711, 67826) --Field Repair Bot 74A, Field Repair Bot 110G, Scrapbot, Jeeves
	self:Log("SPELL_CREATE", "Portals", 11419, 32266,
		11416, 11417, 33691, 35717, 32267, 10059, 11420, 11418, 49360, 49361, 53142
	) --Portals, http://www.wowhead.com/?search=portal#abilities
	self:Log("SPELL_CAST_SUCCESS", "ShieldWall", 871) --Shield Wall
	self:Log("SPELL_CAST_SUCCESS", "Innervate", 29166) --Innervate
	self:Log("SPELL_CAST_SUCCESS", "Bloodlust", 2825, 32182) -- Bloodlust and Heroism
	self:Log("SPELL_CAST_SUCCESS", "Guardian", 47788) --Guardian Spirit
	self:Log("SPELL_AURA_REMOVED", "GuardianOff", 47788) --Guardian Spirit
	self:Log("SPELL_CAST_SUCCESS", "Sacrifice", 6940) --Hand of Sacrifice
	self:Log("SPELL_CAST_SUCCESS", "DivineSacrifice", 64205) --Divine Sacrifice
	self:Log("SPELL_CAST_SUCCESS", "DivineProtection", 498) --Divine Protection
	self:Log("SPELL_CAST_SUCCESS", "Suppression", 33206)
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
	self:Message(33206,L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	self:Bar(33206,L["used_bar"]:format(target, spellName), 10, spellId)
end

function mod:Bloodlust(_, spellId, nick, _, spellName)
	self:TargetMessage(32182, L["used_cast"], nick, red, spellId, nil, spellName)
	self:Bar(32182, L["used_bar"]:format(nick, spellName), 300, spellId)
end

function mod:Guardian(target, spellId, nick, _, spellName)
	self:Message(47788, L["usedon_cast"]:format(nick, spellName, target), yellow, spellId)
	self:Bar(47788, L["used_bar"]:format(target, spellName), 10, spellId)
end

function mod:GuardianOff(target, spellId, nick, _, spellName) --Need to remove if fatal blow received and prevented
	self:TriggerEvent("BigWigs_StopBar", self, L["used_bar"]:format(target, spellName))
end

function mod:Sacrifice(target, spellId, nick, _, spellName)
	self:Message(6940, L["usedon_cast"]:format(nick, spellName, target), orange, nil, nil, nil, spellId)
	self:Bar(6940, L["used_bar"]:format(target, spellName), 12, spellId)
end

function mod:DivineSacrifice(_, spellId, nick, _, spellName)
	self:TargetMessage(64205, L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(64205, L["used_bar"]:format(nick, spellName), 10, spellId)
end

function mod:DivineProtection(_, spellId, nick, _, spellName)
	self:TargetMessage(498, L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(498, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:FearWard(target, spellId, nick, _, spellName)
	self:Message(6346, L["fw_cast"]:format(nick, target), green, spellId)
	self:Bar(6346, L["fw_bar"]:format(nick), 180, spellId)
end

function mod:Repair(_, spellId, nick, _, spellName)
	self:TargetMessage("repair", L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar("repair", L["used_bar"]:format(nick, spellName), spellId == 54711 and 300 or 600, spellId)
end

function mod:Portals(_, spellId, nick, _, spellName)
	self:TargetMessage("portal", L["portal_cast"], nick, blue, spellId, nil, spellName)
	self:Bar("portal", spellName.." ("..nick..")", 60, spellId)
end

function mod:ShieldWall(_, spellId, nick, _, spellName)
	self:TargetMessage(871, L["used_cast"], nick, blue, spellId, nil, spellName)
	self:Bar(871, L["used_bar"]:format(nick, spellName), 12, spellId)
end

function mod:Innervate(target, spellId, nick, _, spellName)
	self:Message(29166, L["usedon_cast"]:format(nick, spellName, target), green, spellId)
	self:Bar(29166, L["usedon_bar"]:format(nick, spellName), 180, spellId)
end

