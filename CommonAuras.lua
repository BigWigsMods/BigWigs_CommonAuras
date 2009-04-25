--[[
--
-- BigWigs Strategy Module - Common Auras
--
-- Gives timer bars and raid messages about common
-- buffs and debuffs.
--
--]]

------------------------------
--      Are you local?      --
------------------------------

local name = "Common Auras"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local fear_ward = GetSpellInfo(6346)
local shield_wall = GetSpellInfo(871)
local guardian_spirit = GetSpellInfo(47788)
local innervate = GetSpellInfo(29166)
local hand_of_sacrifice = GetSpellInfo(6940)
local divine_sacrifice = GetSpellInfo(64205)
local divine_protection = GetSpellInfo(498)
local bl_hero = UnitFactionGroup("player") == "Alliance" and GetSpellInfo(32182) or GetSpellInfo(2825)

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	usedon_cast = "%s: %s on %s",
	usedon_bar = "%s: %s Cooldown",

	used_cast = "%s used %s.",
	used_bar = "%s: %s",

	portal_cast = "%s opened a %s!", --Player opened a Portal: Destination

	["Repair Bot"] = true,

	["Toggle %s display."] = true,
	["Portal"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting the messages to the raidwarning channel."] = true,

	["Gives timer bars and raid messages about common buffs and debuffs."] = true,
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

	["Repair Bot"] = "Ремонтный робот",

	["Toggle %s display."] = "Переключить отображение %s.",
	["Portal"] = "Портал",
	["Broadcast"] = "Вещание",
	["Toggle broadcasting the messages to the raidwarning channel."] = "Посылать сообщения в канал предупреждений рейда",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Показывать таймеры и рейдовые сообщения об основных основных положительных и отрицательных эффектах.",
	["Common Auras"] = "Основные ауры",
} end )

L:RegisterTranslations("zhCN", function() return {
	fw_cast = "%s：防护恐惧结界于%s",
	fw_bar = "<%s：防护恐惧结界 冷却>",

	usedon_cast = "%s：%s于%s",
	usedon_bar = "<%s：%s 冷却>",

	used_cast = " %s使用：%s。",
	used_bar = "<%s：%s>",

	portal_cast = "%s施放了一道%s！",

	["Repair Bot"] = "修理机器人",

	["Toggle %s display."] = "选择%s显示。",
	["Portal"] = "传送门",
	["Broadcast"] = "广播",
	["Toggle broadcasting the messages to the raidwarning channel."] = "显示使用团队警告（RW）频道广播的消息。",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "对通常的增益效果和负面影响使用计时条并且发送团队信息。",
	["Common Auras"] = "普通光环",
} end )

L:RegisterTranslations("koKR", function() return {
	fw_cast = "%s: %s에게 공포의 수호물",
	fw_bar = "%s: 공수 대기시간",

	usedon_cast = "%1$s: %3$s에게 %2$s",
	usedon_bar = "%s: %s 대기시간",

	used_cast = "%s: %s 사용",
	used_bar = "%s: %s",

	portal_cast = "%s: %s 차원문!",

	["Repair Bot"] = "수리 로봇",

	["Toggle %s display."] = "%s 표시를 전환합니다.",
	["Portal"] = "차원문",

	["Broadcast"] = "알림",
	["Toggle broadcasting the messages to the raidwarning channel."] = "공격대 경보 채널에 메세지 알림을 전환합니다.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "공통 버프와 디버프에 대한 공격대 메세지와 타이머 바를 제공합니다.",
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

	["Repair Bot"] = "Reparaturbots",

	["Toggle %s display."] = "Zeigt %s an.",
	["Portal"] = "Portale",
	["Broadcast"] = "Verbreiten",
	["Toggle broadcasting the messages to the raidwarning channel."] = "Nachrichten über Schlachtzugswarnung an alle senden.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Zeigt Timer und Raidnachrichten für allgemein bekannte Buffs und Debuffs.",
	--["Common Auras"] = "",
} end )

L:RegisterTranslations("frFR", function() return {
	fw_cast = "%s a protégé contre la peur %s.",
	fw_bar = "%s : Recharge Gardien",

	usedon_cast = "%s : %s sur %s",
	usedon_bar = "%s : Recharge %s",

	used_cast = "%s a utilisé %s.",
	used_bar = "%s : %s",

	portal_cast = "%s a ouvert un portail pour %s !",

	["Repair Bot"] = "Robot réparateur",

	["Toggle %s display."] = "Préviens ou non quand la capacité %s est utilisée.",
	["Portal"] = "Portail",
	["Broadcast"] = "Diffuser",
	["Toggle broadcasting the messages to the raidwarning channel."] = "Diffuse ou non les messages sur le canal Avertissement raid.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Affiche des barres temporelles et des messages raid concernant les buffs & débuffs courants.",
	["Common Auras"] = "Auras courantes",
} end )

------------------------------
--      Module              --
------------------------------

local mod = BigWigs:NewModule(name)
mod.synctoken = name
mod.defaultDB = {
	fearward = true,
	shieldwall = true,
	portal = true,
	repair = true,
	innervate = true,
	blhero = true,
	guardian = true,
	sacrifice = true,
	broadcast = false,
	divinesacrifice = true,
	divineprotection = true
}
mod.consoleCmd = "commonauras"
mod.consoleOptions = {
	type = "group",
	name = L["Common Auras"],
	desc = L["Gives timer bars and raid messages about common buffs and debuffs."],
	pass = true,
	get = function(key) return mod.db.profile[key] end,
	set = function(key, value) mod.db.profile[key] = value end,
	args = {
		fearward = {
			type = "toggle",
			name = fear_ward,
			desc = L["Toggle %s display."]:format(fear_ward),
		},
		shieldwall = {
			type = "toggle",
			name = shield_wall,
			desc = L["Toggle %s display."]:format(shield_wall),
		},
		guardian = {
			type = "toggle",
			name = guardian_spirit,
			desc = L["Toggle %s display."]:format(guardian_spirit),
		},
		sacrifice = {
			type = "toggle",
			name = hand_of_sacrifice,
			desc = L["Toggle %s display."]:format(hand_of_sacrifice),
		},
		divinesacrifice = {
			type = "toggle",
			name = divine_sacrifice,
			desc = L["Toggle %s display."]:format(divine_sacrifice),
		},
		divineprotection = {
			type = "toggle",
			name = divine_protection,
			desc = L["Toggle %s display."]:format(divine_protection),
		},
		portal = {
			type = "toggle",
			name = L["Portal"],
			desc = L["Toggle %s display."]:format(L["Portal"]),
		},
		repair = {
			type = "toggle",
			name = L["Repair Bot"],
			desc = L["Toggle %s display."]:format(L["Repair Bot"]),
		},
		innervate = {
			type = "toggle",
			name = innervate,
			desc = L["Toggle %s display."]:format(innervate),
		},
		blhero = {
			type = "toggle",
			name = bl_hero,
			desc = L["Toggle %s display."]:format(bl_hero),
		},
		broadcast = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting the messages to the raidwarning channel."],
			order = -1,
		},
	}
}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.external = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "FearWard", 6346) --Fear Ward
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Repair", 22700, 44389, 54711) --Field Repair Bot 74A, Field Repair Bot 110G, Scrapbot
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
	--self:AddCombatListener("SPELL_CAST_SUCCESS", "Mammoth", 00000) --Reins of the Traveler's Tundra Mammoth --NO MOUNTING EVENTS :[
end

------------------------------
--      Events              --
------------------------------

local green = {r = 0, g = 1, b = 0}
local blue = {r = 0, g = 0, b = 1}
local orange = {r = 1, g = 0.75, b = 0.14}
local yellow = {r = 1, g = 1, b = 0}
local red = {r = 1, g = 0, b = 0}

function mod:Bloodlust(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.blhero then
		self:Message(L["used_cast"]:format(nick, spellName), red, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 300, spellID, true, 1, 0, 0)
	end
end

function mod:Guardian(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.guardian then
		self:Message(L["usedon_cast"]:format(nick, spellName, target), yellow, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(target, spellName), 10, spellID, true, 1, 1, 0)
	end
end

function mod:GuardianOff(target, spellID, nick, _, spellName) --Need to remove if fatal blow received and prevented
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.guardian then
		self:TriggerEvent("BigWigs_StopBar", self, L["used_bar"]:format(target, spellName))
	end
end

function mod:Sacrifice(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.sacrifice then
		self:Message(L["usedon_cast"]:format(nick, spellName, target), orange, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(target, spellName), 12, spellID, true, 1, 0.75, 0.14)
	end
end

function mod:DivineSacrifice(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.divinesacrifice then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 10, spellID, true, 0, 0, 1)
	end
end

function mod:DivineProtection(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.divineprotection then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 12, spellID, true, 0, 0, 1)
	end
end

function mod:FearWard(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.fearward then
		self:Message(L["fw_cast"]:format(nick, target), green, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["fw_bar"]:format(nick), 180, spellID, true, 0, 1, 0)
	end
end

function mod:Repair(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.repair then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), spellID == 54711 and 300 or 600, spellID, true, 0, 0, 1)
	end
end
--[[
function mod:Mammoth(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.repair then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
	end
end
]]
function mod:Portals(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.portal then
		self:Message(L["portal_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(spellName.." ("..nick..")", 60, spellID, true, 0, 0, 1)
	end
end

function mod:ShieldWall(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.shieldwall then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 12, spellID, true, 0, 0, 1)
	end
end

function mod:Innervate(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.innervate then
		self:Message(L["usedon_cast"]:format(nick, spellName, target), green, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["usedon_bar"]:format(nick, spellName), 360, spellID, true, 0, 1, 0)
	end
end

