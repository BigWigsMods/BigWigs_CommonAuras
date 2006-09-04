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
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..name)

local spellstatus = nil

local portalIcons = {}

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s FW CD",

	sw_cast = "%s used Shield Wall.",
	sw_bar = "%s Shield Wall",

	cs_cast = "%s used challenging shout!",
	cs_bar = "%s Challenging Shout",

	cr_cast = "%s used challenging roar!",
	cr_bar = "%s Challenging Roar",

	portal_cast = "%s opened a portal to %s!",
	-- portal_bar is the spellname

	["Fear Ward"] = true,
	["Toggle Fear Ward display."] = true,
	["Shield Wall"] = true,
	["Toggle Shield Wall display."] = true,
	["Challenging Shout"] = true,
	["Toggle Challenging Shout display."] = true,
	["Challenging Roar"] = true,
	["Toggle Challenging Roar display."] = true,
	["Portal"] = true,
	["Toggle Portal reporting."] = true,
	["broadcast"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting the messages to raid."] = true,

	["Gives timer bars and raid messages about common buffs and debuffs."] = true,
	["Common Auras"] = true,
	["commonauras"] = true,

	["Portal: Ironforge"] = true,
	["Portal: Stormwind"] = true,
	["Portal: Darnassus"] = true,
	["Portal: Orgrimmar"] = true,
	["Portal: Thunder Bluff"] = true,
	["Portal: Undercity"] = true,

} end )

------------------------------
--      Module              --
------------------------------

BigWigsCommonAuras = BigWigs:NewModule(name)
BigWigsCommonAuras.synctoken = myname
BigWigsCommonAuras.defaultDB = {
	fearward = true,
	shieldwall = true,
	challengingshout = true,
	challengingroar = true,
	portal = true,
	broadcast = false,
}

BigWigsCommonAuras.consoleCmd = "commonauras"
BigWigsCommonAuras.consoleOptions = {
	type = "group",
	name = L["Common Auras"],
	desc = L["Gives timer bars and raid messages about common buffs and debuffs."],
	args   = {
		["fearward"] = {
			type = "toggle",
			name = L["Fear Ward"],
			desc = L["Toggle Fear Ward display."],
			get = function() return BigWigsCommonAuras.db.profile.fearward end,
			set = function(v) BigWigsCommonAuras.db.profile.fearward = v end,
		},
		["shieldwall"] = {
			type = "toggle",
			name = L["Shield Wall"],
			desc = L["Toggle Shield Wall display."],
			get = function() return BigWigsCommonAuras.db.profile.shieldwall end,
			set = function(v) BigWigsCommonAuras.db.profile.shieldwall = v end,
		},
		["challengingshout"] = {
			type = "toggle",
			name = L["Challenging Shout"],
			desc = L["Toggle Challenging Shout display."],
			get = function() return BigWigsCommonAuras.db.profile.challengingshout end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingshout = v end,
		},
		["challengingroar"] = {
			type = "toggle",
			name = L["Challenging Roar"],
			desc = L["Toggle Challenging Roar display."],
			get = function() return BigWigsCommonAuras.db.profile.challengingroar end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingroar = v end,
		},
		["portal"] = {
			type = "toggle",
			name = L["Portal"],
			desc = L["Toggle Portal reporting."],
			get = function() return BigWigsCommonAuras.db.profile.portal end,
			set = function(v) BigWigsCommonAuras.db.profile.portal = v end,
		},
		["broadcast"] = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting the messages to raid."],
			get = function() return BigWigsCommonAuras.db.profile.broadcast end,
			set = function(v) BigWigsCommonAuras.db.profile.broadcast = v end,
		},
	}
}
BigWigsCommonAuras.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCommonAuras:OnEnable()
	local _, class = UnitClass("player")
	local _, race = UnitRace("player")
	if class == "WARRIOR" or class == "DRUID" or (class == "PRIEST" and race == "Dwarf") then
		if not spellstatus then spellstatus = AceLibrary("SpellStatus-1.0") end
		self:RegisterEvent("SpellStatus_SpellCastInstant")
	elseif class == "MAGE" then
		if not spellstatus then spellstatus = AceLibrary("SpellStatus-1.0") end
		self:RegisterEvent("SpellStatus_SpellCastCastingFinish")
	end

	portalIcons[L["Portal: Ironforge"]] = "Spell_Arcane_PortalIronForge"
	portalIcons[L["Portal: Stormwind"]] = "Spell_Arcane_PortalStormWind"
	portalIcons[L["Portal: Darnassus"]] = "Spell_Arcane_PortalDarnassus"
	portalIcons[L["Portal: Orgrimmar"]] = "Spell_Arcane_PortalOrgrimmar"
	portalIcons[L["Portal: Thunder Bluff"]] = "Spell_Arcane_PortalThunderBluff"
	portalIcons[L["Portal: Undercity"]] = "Spell_Arcane_PortalUnderCity"

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAFW", 5) -- Fear Ward
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCASW", 5) -- Shield Wall
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACS", 5) -- Challenging Shout
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACR", 5) -- Challenging Roar
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAP", 5) -- Portal
end

------------------------------
--      Events              --
------------------------------

function BigWigsCommonAuras:BigWigs_RecvSync( sync, rest, nick )
	if not nick then nick = UnitName("player") end
	if self.db.profile.fearward and sync == "BWCAFW" and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["fw_cast"], nick, rest), "Green", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["fw_bar"], nick), 30, "Interface\\Icons\\Spell_Holy_Excorcism", "Green")
	elseif self.db.profile.shieldwall and sync == "BWCASW" then
		self:TriggerEvent("BigWigs_Message", string.format(L["sw_cast"], nick), "Yellow", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sw_bar"], nick), 10, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow")
	elseif self.db.profile.challengingshout and sync == "BWCACS" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cs_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cs_bar"], nick), 6, "Interface\\Icons\\Ability_BullRush", "Orange")
	elseif self.db.profile.challengingroar and sync == "BWCACR" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cr_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cr_bar"], nick), 6, "Interface\\Icons\\Ability_Druid_ChallangingRoar", "Orange")
	elseif self.db.profile.portal and sync == "BWCAP" and rest then
		local _, _, zone = string.find(rest, ".*: (.*)")
		self:TriggerEvent("BigWigs_Message", string.format(L["portal_cast"], nick, zone), "Blue", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, rest, 60, portalIcons[rest], "Blue")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
	if sName == L["Fear Ward"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCAFW "..UnitName("target"))
	elseif sName == L["Shield Wall"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCASW")
	elseif sName == L["Challenging Shout"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACS")
	elseif sName == L["Challenging Roar"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACR")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastCastingFinish(sId, sName, sRank, sFullName, sCastTime)
	if not string.find(sName, L["Portal"]) then return end
	self:TriggerEvent("BigWigs_SendSync", "BWCAP "..sName)
end

