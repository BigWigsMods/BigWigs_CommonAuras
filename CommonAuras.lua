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
local BS = AceLibrary("Babble-Spell-2.2")

local shieldWallDuration = nil

-- Use for detecting instant cast target (Fear Ward)
local spellTarget = nil
local is23 = type(RaidNotice_AddMessage) == "function" and true or nil

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	md_cast = "%s: MD on %s",
	md_bar = "%s: MD Cooldown",

	used_cast = "%s used %s.",
	used_bar = "%s: %s",

	portal_cast = "%s opened a portal to %s!",
	portal_regexp = ".*: (.*)",
	-- portal_bar is the spellname

	["Toggle %s display."] = true,
	["Portal"] = true,
	["broadcast"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting the messages to the raidwarning channel."] = true,

	["Gives timer bars and raid messages about common buffs and debuffs."] = true,
	["Common Auras"] = true,
	["commonauras"] = true,
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	fw_cast = "%s防护恐惧结界%s",
	fw_bar = "%s: 防护恐惧结界冷却",
	
	md_cast = "%s: MD on %s",
	md_bar = "%s: MD Cooldown",

	used_cast = " 对%s使用%s",
	used_bar = "%s: %s",

	portal_cast = "%s施放一传送门到%s",
	portal_regexp = ".*: (.*)",
	-- portal_bar is the spellname

	["Toggle %s display."] = "选择%s显示",
	["Portal"] = "传送门",
	["broadcast"] = "广播",
	["Broadcast"] = "广播",
	["Toggle broadcasting the messages to the raidwarning channel."] = "显示使用团队警告(RW)频道广播的消息。",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "对通常的Buff和Debuff使用计时条并且发送团队信息。",
	["Common Auras"] = "普通光环",
	["commonauras"] = "普通光环",
} end )


L:RegisterTranslations("koKR", function() return {
	fw_cast = "%s님이 %s에게 공포의 수호물을 시전합니다.", --"%s|1이;가; %s에게 공포의 수호물을 시전합니다.",
	fw_bar = "%s: 공수 재사용 대기시간",

	md_cast = "%s: %s님에게 눈속임",
	md_bar = "%s: 눈속임 재사용 대기시간",

	used_cast = "%s님이 %s 사용했습니다.", --"%s|1이;가; %s|1을;를; 사용했습니다.",
	used_bar = "%s: %s",

	portal_cast = "%s님이 %s 차원문을 엽니다!", --"%s|1이;가; %s|1으로;로; 가는 차원문을 엽니다!",
	portal_regexp = ".*: (.*)",
	-- portal_bar is the spellname

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

	used_cast = "%s benutzt %s.",

	portal_cast = "%s \195\182ffnet ein Portal nach %s!",
	-- portal_bar is the spellname

	["Toggle %s display."] = "Aktiviert oder Deaktiviert die Anzeige von %s.",
	["Portal"] = "Portale",
	["broadcast"] = "broadcasten",
	["Broadcast"] = "Broadcast",
	["Toggle broadcasting the messages to the raidwarning channel."] = "W\195\164hle, ob Warnungen \195\188ber RaidWarning gesendet werden sollen.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Zeigt Zeitleisten und Raidnachrichten f? kritische Spr\195\188che.",
} end )

L:RegisterTranslations("frFR", function() return {
	fw_cast = "%s a prot\195\169g\195\169 contre la peur %s.",
	fw_bar = "%s: Gardien de peur",

	used_cast = "%s a utilis\195\169 %s.",

	portal_cast = "%s a ouvert un portail pour %s !",
	-- portal_bar is the spellname

	["Toggle %s display."] = "Activer l'affichage de %s.",
	["Portal"] = "Portail",
	["broadcast"] = "Annonce",
	["Broadcast"] = "Annonce",
	["Toggle broadcasting the messages to the raidwarning channel."] = "Active les annonces au canal d'avertissement raid.",

	["Gives timer bars and raid messages about common buffs and debuffs."] = "Affiche des compteurs et des annonces de raid pour les buffs et debuffs g\195\169n\195\169riques.",
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
	broadcast = false,
}

mod.consoleCmd = L["commonauras"]
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
			name = BS["Fear Ward"],
			desc = L["Toggle %s display."]:format(BS["Fear Ward"]),
		},
		shieldwall = {
			type = "toggle",
			name = BS["Shield Wall"],
			desc = L["Toggle %s display."]:format(BS["Shield Wall"]),
		},
		challengingshout = {
			type = "toggle",
			name = BS["Challenging Shout"],
			desc = L["Toggle %s display."]:format(BS["Challenging Shout"]),
		},
		challengingroar = {
			type = "toggle",
			name = BS["Challenging Roar"],
			desc = L["Toggle %s display."]:format(BS["Challenging Roar"]),
		},
		portal = {
			type = "toggle",
			name = L["Portal"],
			desc = L["Toggle %s display."]:format(L["Portal"]),
		},
		misdirection = {
			type = "toggle",
			name = BS["Misdirection"],
			desc = L["Toggle %s display."]:format(BS["Misdirection"]),
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
	local class = select(2, UnitClass("player"))
	local race = select(2, UnitRace("player"))

	if class == "WARRIOR" then
		local rank = select(5, GetTalentInfo(3 , 13))
		shieldWallDuration = 10
		if rank == 2 then
			shieldWallDuration = shieldWallDuration + 5
		elseif rank == 1 then
			shieldWallDuration = shieldWallDuration + 3
		end
		rank = select(5, GetTalentInfo(1 , 18))
		shieldWallDuration = shieldWallDuration + (rank * 2)
	end

	if class == "HUNTER" or class == "WARRIOR" or class == "MAGE" or (class == "PRIEST" and (is23 or (race == "Dwarf" or race == "Draenei"))) then
		if class == "PRIEST" or class == "HUNTER" then
			self:RegisterEvent("UNIT_SPELLCAST_SENT")
			spellTarget = nil
		end
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end

	self:RegisterEvent("BigWigs_RecvSync")

	-- XXX Lets have a low throttle because you'll get 2 syncs from yourself, so
	-- it results in 2 messages.
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAFW", .4) -- Fear Ward
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCASW", .4) -- Shield Wall
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACS", .4) -- Challenging Shout
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACR", .4) -- Challenging Roar
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAP", .4) -- Portal
	self:TriggerEvent("BigWigs_ThrottleSync", "BWMD", .4) -- Misdirection
end

------------------------------
--      Events              --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if not nick then nick = UnitName("player") end
	if sync == "BWCAFW" and rest and self.db.profile.fearward then
		self:Message(L["fw_cast"]:format(nick, rest), "Green", not self.db.profile.broadcast, false)
		self:Bar(L["fw_bar"]:format(nick), is23 and 180 or 30, BS:GetShortSpellIcon("Fear Ward"), true, "Green")
	elseif sync == "BWCASW" and self.db.profile.shieldwall then
		local swTime = tonumber(rest)
		if not swTime then swTime = 10 end -- If the tank uses an old BWCA, just assume 10 seconds.
		local spell = BS["Shield Wall"]
		self:Message(L["used_cast"]:format(nick,  spell), "Blue", not self.db.profile.broadcast, false)
		self:Bar(L["used_bar"]:format(nick, spell), swTime, BS:GetShortSpellIcon(spell), true, "Blue")
	elseif sync == "BWCACS" and self.db.profile.challengingshout then
		local spell = BS["Challenging Shout"]
		self:Message(L["used_cast"]:format(nick, spell), "Orange", not self.db.profile.broadcast, false)
		self:Bar(L["used_bar"]:format(nick, spell), 6, BS:GetShortSpellIcon(spell), true, "Orange")
	elseif sync == "BWCACR" and self.db.profile.challengingroar then
		local spell = BS["Challenging Roar"]
		self:Message(L["used_cast"]:format(nick, spell), "Orange", not self.db.profile.broadcast, false)
		self:Bar(L["used_bar"]:format(nick, spell), 6, BS:GetShortSpellIcon(spell), true, "Orange")
	elseif sync == "BWCAP" and rest and self.db.profile.portal then
		rest = BS:HasTranslation(rest) and BS:GetTranslation(rest) or rest
		local zone = select(3, rest:find(L["portal_regexp"]))
		if zone then
			self:Message(L["portal_cast"]:format(nick, zone), "Blue", not self.db.profile.broadcast, false)
			self:Bar(rest, 60, BS:GetShortSpellIcon(rest), true, "Blue")
		end
	elseif sync == "BWMD" and rest and self.db.profile.misdirection then
		self:Message(L["md_cast"]:format(nick, rest), "Yellow", not self.db.profile.broadcast, false)
		self:Bar(L["md_bar"]:format(nick), 120, BS:GetShortSpellIcon("Misdirection"), true, "Yellow")
	end
end

function mod:UNIT_SPELLCAST_SENT(sPlayer, sSpell, sRank, sTarget)
	if sTarget == "" then sTarget = nil end
	if sPlayer and sPlayer == "player" and sSpell and sTarget and (sSpell == BS["Fear Ward"] or sSpell == BS["Misdirection"]) then
		spellTarget = sTarget
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(sPlayer, sName, sRank)
	if sName == BS["Fear Ward"] then
		local targetName = spellTarget or UnitName("player")
		self:Sync("BWCAFW "..targetName)
		spellTarget = nil
	elseif sName == BS["Shield Wall"] then
		self:Sync("BWCASW "..tostring(shieldWallDuration))
	elseif sName == BS["Challenging Shout"] then
		self:Sync("BWCACS")
	elseif sName == BS["Challenging Roar"] then
		self:Sync("BWCACR")
	elseif sName:find(L["Portal"]) then
		local name = BS:HasReverseTranslation(sName) and BS:GetReverseTranslation(sName) or sName
		self:Sync("BWCAP "..name)
	elseif sName == BS["Misdirection"] then
		local targetName = spellTarget or UnitName("player")
		self:Sync("BWMD "..targetName)
		spellTarget = nil
	end
end

