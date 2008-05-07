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
local challenging_shout = GetSpellInfo(1161)
local challenging_roar = GetSpellInfo(5209)
local misdirection = GetSpellInfo(34477)
local rebirth = GetSpellInfo(20484)
local innervate = GetSpellInfo(29166)
local bl_hero = UnitFactionGroup("player") == "Alliance" and GetSpellInfo(32182) or GetSpellInfo(2825)

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	md_cast = "%s: MD on %s",
	md_bar = "%s: MD Cooldown",

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

L:RegisterTranslations("zhCN", function() return {
	fw_cast = "%s：防护恐惧结界于%s",
	fw_bar = "<%s：防护恐惧结界 冷却>",

	md_cast = "%s：误导于%s",
	md_bar = "<%s: 误导 冷却>",

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

	md_cast = "%s: %s에게 눈속임",
	md_bar = "%s: 눈속임 대기시간",

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
	fw_cast = "%s sch\195\188tzt %s vor Furcht.",
	fw_bar = "%s: FS Cooldown",

	--md_cast = "%s: MD on %s",
	--md_bar = "%s: MD Cooldown",

	--usedon_cast = "%s: %s on %s",
	--usedon_bar = "%s: %s Cooldown",

	used_cast = "%s benutzt %s.",
	--used_bar = "%s: %s",

	portal_cast = "%s \195\182ffnet ein Portal nach %s!",

	--["Repair Bot"] = "",

	["Toggle %s display."] = "Aktiviert oder Deaktiviert die Anzeige von %s.",
	["Portal"] = "Portale",
	["Broadcast"] = "Broadcast",
	["Toggle broadcasting the messages to the raidwarning channel."] = "W\195\164hle, ob Warnungen \195\188ber RaidWarning gesendet werden sollen.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Zeigt Zeitleisten und Raidnachrichten f? kritische Spr\195\188che.",
	--["Common Auras"] = "",
} end )

L:RegisterTranslations("frFR", function() return {
	fw_cast = "%s a protégé contre la peur %s.",
	fw_bar = "%s : Recharge Gardien",

	md_cast = "%s : Redirection sur %s.",
	md_bar = "%s : Recharge Redirection",

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
	challengingshout = true,
	challengingroar = true,
	portal = true,
	misdirection = true,
	repair = true,
	innervate = true,
	rebirth = true,
	blhero = true,
	broadcast = false,
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
		challengingshout = {
			type = "toggle",
			name = challenging_shout,
			desc = L["Toggle %s display."]:format(challenging_shout),
		},
		challengingroar = {
			type = "toggle",
			name = challenging_roar,
			desc = L["Toggle %s display."]:format(challenging_roar),
		},
		portal = {
			type = "toggle",
			name = L["Portal"],
			desc = L["Toggle %s display."]:format(L["Portal"]),
		},
		misdirection = {
			type = "toggle",
			name = misdirection,
			desc = L["Toggle %s display."]:format(misdirection),
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
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shout", 1161) --Challenging Shout
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Roar", 5209) --Challenging Roar
	self:AddCombatListener("SPELL_CAST_SUCCESS", "FearWard", 6346) --Fear Ward
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Misdirection", 34477) --Misdirection
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Repair", 22700, 44389) --Field Repair Bot 74A, Field Repair Bot 110G
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Portals", 11419, 32266, 11416, 11417, 33691, 35717, 32267, 10059, 11420, 11418) --Portals, BROKEN UNTIL BLIZZ FIX IT
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 871) --Shield Wall
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Innervate", 29166) --Innervate
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bloodlust", 2825, 32182) -- Bloodlust and Heroism
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
		self:Bar(L["used_bar"]:format(nick, spellName), 600, spellID, true, 1, 0, 0)
	end
end

function mod:Shout(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.challengingshout then
		self:Message(L["used_cast"]:format(nick, spellName), orange, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 6, spellID, true, 1, 0.75, 0.14)
	end
end

function mod:Roar(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.challengingroar then
		self:Message(L["used_cast"]:format(nick, spellName), orange, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 6, spellID, true, 1, 0.75, 0.14)
	end
end

function mod:FearWard(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.fearward then
		self:Message(L["fw_cast"]:format(nick, target), green, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["fw_bar"]:format(nick), 180, spellID, true, 0, 1, 0)
	end
end

function mod:Misdirection(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.misdirection then
		self:Message(L["md_cast"]:format(nick, target), yellow, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["md_bar"]:format(nick), 120, spellID, true, 1, 1, 0)
	end
end

function mod:Repair(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.repair then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 600, spellID, true, 0, 0, 1)
	end
end

function mod:Portals(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.portal then
		self:Message(L["portal_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(spellName.." ("..nick..")", 60, spellID, true, 0, 0, 1)
	end
end

function mod:ShieldWall(_, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.shieldwall then
		self:Message(L["used_cast"]:format(nick, spellName), blue, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["used_bar"]:format(nick, spellName), 10, spellID, true, 0, 0, 1)
	end
end

function mod:Innervate(target, spellID, nick, _, spellName)
	if (UnitInRaid(nick) or UnitInParty(nick)) and self.db.profile.innervate then
		self:Message(L["usedon_cast"]:format(nick, spellName, target), green, not self.db.profile.broadcast, nil, nil, spellID)
		self:Bar(L["usedon_bar"]:format(nick, spellName), 360, spellID, true, 0, 1, 0)
	end
end

