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

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

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

L:RegisterTranslations("koKR", function() return {
	fw_cast = "%s님이 %s에게 공포의 수호물을 시전합니다.", --"%s|1이;가; %s에게 공포의 수호물을 시전합니다.",
	fw_bar = "%s: FW 재사용 대기시간",

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

BigWigsCommonAuras = BigWigs:NewModule(name)
BigWigsCommonAuras.synctoken = name
BigWigsCommonAuras.defaultDB = {
	fearward = true,
	shieldwall = true,
	challengingshout = true,
	challengingroar = true,
	portal = true,
	broadcast = false,
}

BigWigsCommonAuras.consoleCmd = L["commonauras"]
BigWigsCommonAuras.consoleOptions = {
	type = "group",
	name = L["Common Auras"],
	desc = L["Gives timer bars and raid messages about common buffs and debuffs."],
	args   = {
		["fearward"] = {
			type = "toggle",
			name = BS["Fear Ward"],
			desc = string.format(L["Toggle %s display."], BS["Fear Ward"]),
			get = function() return BigWigsCommonAuras.db.profile.fearward end,
			set = function(v) BigWigsCommonAuras.db.profile.fearward = v end,
		},
		["shieldwall"] = {
			type = "toggle",
			name = BS["Shield Wall"],
			desc = string.format(L["Toggle %s display."], BS["Shield Wall"]),
			get = function() return BigWigsCommonAuras.db.profile.shieldwall end,
			set = function(v) BigWigsCommonAuras.db.profile.shieldwall = v end,
		},
		["challengingshout"] = {
			type = "toggle",
			name = BS["Challenging Shout"],
			desc = string.format(L["Toggle %s display."], BS["Challenging Shout"]),
			get = function() return BigWigsCommonAuras.db.profile.challengingshout end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingshout = v end,
		},
		["challengingroar"] = {
			type = "toggle",
			name = BS["Challenging Roar"],
			desc = string.format(L["Toggle %s display."], BS["Challenging Roar"]),
			get = function() return BigWigsCommonAuras.db.profile.challengingroar end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingroar = v end,
		},
		["portal"] = {
			type = "toggle",
			name = L["Portal"],
			desc = string.format(L["Toggle %s display."], L["Portal"]),
			get = function() return BigWigsCommonAuras.db.profile.portal end,
			set = function(v) BigWigsCommonAuras.db.profile.portal = v end,
		},
		["broadcast"] = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting the messages to the raidwarning channel."],
			get = function() return BigWigsCommonAuras.db.profile.broadcast end,
			set = function(v) BigWigsCommonAuras.db.profile.broadcast = v end,
		},
	}
}
BigWigsCommonAuras.revision = tonumber(string.sub("$Revision$", 12, -3))
BigWigsCommonAuras.external = true

------------------------------
--      Initialization      --
------------------------------

function BigWigsCommonAuras:OnEnable()
	local _, class = UnitClass("player")
	local _, race = UnitRace("player")

	if class == "WARRIOR" then
		local _, _, _, _, rank = GetTalentInfo( 3 , 13 )
		shieldWallDuration = 10
		if rank == 2 then
			shieldWallDuration = shieldWallDuration + 5
		elseif rank == 1 then
			shieldWallDuration = shieldWallDuration + 3
		end
		_, _, _, _, rank = GetTalentInfo( 1 , 18 )
		shieldWallDuration = shieldWallDuration + (rank * 2)
	end

	if class == "WARRIOR" or class == "MAGE" or (class == "PRIEST" and (race == "Dwarf" or race == "Draenei")) then
		if class == "PRIEST" then
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
end

------------------------------
--      Events              --
------------------------------

function BigWigsCommonAuras:BigWigs_RecvSync( sync, rest, nick )
	if not nick then nick = UnitName("player") end
	if sync == "BWCAFW" and rest and self.db.profile.fearward then
		self:TriggerEvent("BigWigs_Message", string.format(L["fw_cast"], nick, rest), "Green", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["fw_bar"], nick), 30, BS:GetSpellIcon("Fear Ward"), true, "Green")
	elseif sync == "BWCASW" and self.db.profile.shieldwall then
		local swTime = tonumber(rest)
		if not swTime then swTime = 10 end -- If the tank uses an old BWCA, just assume 10 seconds.
		local spell = BS["Shield Wall"]
		self:TriggerEvent("BigWigs_Message", string.format(L["used_cast"], nick,  spell), "Yellow", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["used_bar"], nick, spell), swTime, BS:GetSpellIcon(spell), true, "Yellow")
	elseif sync == "BWCACS" and self.db.profile.challengingshout then
		local spell = BS["Challenging Shout"]
		self:TriggerEvent("BigWigs_Message", string.format(L["used_cast"], nick, spell), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["used_bar"], nick, spell), 6, BS:GetSpellIcon(spell), true, "Orange")
	elseif sync == "BWCACR" and self.db.profile.challengingroar then
		local spell = BS["Challenging Roar"]
		self:TriggerEvent("BigWigs_Message", string.format(L["used_cast"], nick, spell), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["used_bar"], nick, spell), 6, BS:GetSpellIcon(spell), true, "Orange")
	elseif sync == "BWCAP" and rest and self.db.profile.portal then
		rest = BS:HasTranslation(rest) and BS:GetTranslation(rest) or rest
		local _, _, zone = string.find(rest, L["portal_regexp"])
		if zone then
			self:TriggerEvent("BigWigs_Message", string.format(L["portal_cast"], nick, zone), "Blue", not self.db.profile.broadcast, false)
			self:TriggerEvent("BigWigs_StartBar", self, rest, 60, BS:GetSpellIcon(rest), true, "Blue")
		end
	end
end

function BigWigsCommonAuras:UNIT_SPELLCAST_SENT(sPlayer, sSpell, sRank, sTarget)
	if sPlayer and sPlayer == "player" and sSpell and sTarget and sSpell == BS["Fear Ward"] then
		spellTarget = sTarget
	end
end

function BigWigsCommonAuras:UNIT_SPELLCAST_SUCCEEDED(sPlayer, sName, sRank)
	if sName == BS["Fear Ward"] then
		local targetName = spellTarget or UnitName("player")
		self:TriggerEvent("BigWigs_SendSync", "BWCAFW "..targetName)
		spellTarget = nil
	elseif sName == BS["Shield Wall"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCASW "..tostring(shieldWallDuration))
	elseif sName == BS["Challenging Shout"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACS")
	elseif sName == BS["Challenging Roar"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACR")
	elseif string.find(sName, L["Portal"]) then
		local name = BS:HasReverseTranslation(sName) and BS:GetReverseTranslation(sName) or sName
		self:TriggerEvent("BigWigs_SendSync", "BWCAP "..name)
	end
end

