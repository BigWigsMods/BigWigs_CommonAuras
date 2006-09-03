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

	["Fear Ward"] = true,
	["Toggle Fear Ward display."] = true,
	["Shield Wall"] = true,
	["Toggle Shield Wall display."] = true,
	["Challenging Shout"] = true,
	["Toggle Challenging Shout display."] = true,

	["Gives timer bars and raid messages about common buffs and debuffs."] = true,
	["Common Auras"] = true,
	["commonauras"] = true,

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
			desc = "Toggle Fear Ward display.",
			get = function() return BigWigsCommonAuras.db.profile.fearward end,
			set = function(v) BigWigsCommonAuras.db.profile.fearward = v end,
		},
		["shieldwall"] = {
			type = "toggle",
			name = L["Shield Wall"],
			desc = "Toggle Shield Wall display.",
			get = function() return BigWigsCommonAuras.db.profile.shieldwall end,
			set = function(v) BigWigsCommonAuras.db.profile.shieldwall = v end,
		},
		["challengingshout"] = {
			type = "toggle",
			name = L["Challenging Shout"],
			desc = "Toggle Challenging Shout display.",
			get = function() return BigWigsCommonAuras.db.profile.challengingshout end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingshout = v end,
		},
	}
}
BigWigsCommonAuras.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCommonAuras:OnEnable()
	local _, class = UnitClass("player")
	local race = UnitRace("player")
	if class == "WARRIOR" or (class == "PRIEST" and race == "Dwarf") then
		if not spellstatus then spellstatus = AceLibrary("SpellStatus-1.0") end
		self:RegisterEvent("SpellStatus_SpellCastInstant")
	end
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAFW", 5) -- Fear Ward
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCASW", 5) -- Shield Wall
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACS", 5) -- Challenging Shout
end

------------------------------
--      Events              --
------------------------------

function BigWigsCommonAuras:BigWigs_RecvSync( sync, rest, nick )
	if not nick then nick = UnitName("player") end
	if self.db.profile.fearward and sync == "BWCAFW" and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["fw_cast"], nick, rest), "Green")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["fw_bar"], nick), 30, "Interface\\Icons\\Spell_Holy_Excorcism", "Green")
	elseif self.db.profile.shieldwall and sync == "BWCASW" then
		self:TriggerEvent("BigWigs_Message", string.format(L["sw_cast"], nick), "Yellow")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sw_bar"], nick), 10, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow")
	elseif self.db.profile.challengingshout and sync == "BWCACS" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cs_cast"], nick), "Orange")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cs_bar"], nick), 6, "Interface\\Icons\\Ability_BullRush", "Orange")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
	if sName == L["Fear Ward"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCAFW "..UnitName("target"))
	elseif sName == L["Shield Wall"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCASW")
	elseif sName == L["Challenging Shout"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACS")
	end
end

