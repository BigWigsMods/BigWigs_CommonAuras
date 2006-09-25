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

local spellStatus = nil
local lastTank = nil
local shieldWallDuration = nil

-- Use for detecting instant cast target (Fear Ward)
local spellTarget = nil
local spellCasting = nil

local portalIcons = {}

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	sw_cast = "%s used Shield Wall.",
	sw_bar = "%s: Shield Wall",

	cs_cast = "%s used challenging shout!",
	cs_bar = "%s: Challenging Shout",

	cr_cast = "%s used challenging roar!",
	cr_bar = "%s: Challenging Roar",

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
	["Toggle broadcasting the messages to the raidwarning channel."] = true,

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

BigWigsCommonAuras = BigWigs:NewModule(name, "AceHook-2.0")
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
			desc = L["Toggle broadcasting the messages to the raidwarning channel."],
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

	if class == "WARRIOR" or class == "DRUID" then
		self:RegisterEvent("SpellStatus_SpellCastInstant")
		if class == "WARRIOR" then
			local _, _, _, _, currentRank ,_ , _, _ = GetTalentInfo( 3 , 13 )
			if currentRank == 0 then
				shieldWallDuration = 10
			elseif currentRank == 1 then
				shieldWallDuration = 13
			else
				shieldWallDuration = 15
			end
		end
	elseif class == "PRIEST" and race == "Dwarf" then
		self:RegisterEvent("SpellStatus_SpellCastInstant")
		--[[self:Hook("CastSpell")
		self:Hook("CastSpellByName")
		self:Hook("SpellTargetUnit")
		self:Hook("SpellStopTargeting")
		self:Hook("TargetUnit")
		self:Hook("UseAction")
		self:HookScript(WorldFrame,"OnMouseDown","BigWigsCommonAurasOnMouseDown")]]
	elseif class == "MAGE" then
		if not spellStatus then spellStatus = AceLibrary("SpellStatus-1.0") end
		self:RegisterEvent("SpellStatus_SpellCastCastingFinish")
		self:RegisterEvent("SpellStatus_SpellCastFailure")
	end

	portalIcons[L["Portal: Ironforge"]] = "Spell_Arcane_PortalIronForge"
	portalIcons[L["Portal: Stormwind"]] = "Spell_Arcane_PortalStormWind"
	portalIcons[L["Portal: Darnassus"]] = "Spell_Arcane_PortalDarnassus"
	portalIcons[L["Portal: Orgrimmar"]] = "Spell_Arcane_PortalOrgrimmar"
	portalIcons[L["Portal: Thunder Bluff"]] = "Spell_Arcane_PortalThunderBluff"
	portalIcons[L["Portal: Undercity"]] = "Spell_Arcane_PortalUnderCity"

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
	if self.db.profile.fearward and sync == "BWCAFW" and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["fw_cast"], nick, rest), "Green", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["fw_bar"], nick), 30, "Interface\\Icons\\Spell_Holy_Excorcism", "Green")
	elseif self.db.profile.shieldwall and sync == "BWCASW" then
		local swTime = tonumber(rest)
		if not swTime then swTime = 10 end -- If the tank uses an old BWCA, just assume 10 seconds.
		self:TriggerEvent("BigWigs_Message", string.format(L["sw_cast"], nick), "Yellow", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sw_bar"], nick), swTime, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["sw_bar"], nick), function(name, button, extra) TargetByName(extra, true) end, nick )
		lastTank = nick
	elseif self.db.profile.challengingshout and sync == "BWCACS" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cs_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cs_bar"], nick), 6, "Interface\\Icons\\Ability_BullRush", "Orange")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["cs_bar"], nick), function(name, button, extra) TargetByName(extra, true) end, nick )
		lastTank = nick
	elseif self.db.profile.challengingroar and sync == "BWCACR" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cr_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cr_bar"], nick), 6, "Interface\\Icons\\Ability_Druid_ChallangingRoar", "Orange")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["cr_bar"], nick), function(name, button, extra) TargetByName(extra, true) end, nick )
		lastTank = nick
	elseif self.db.profile.portal and sync == "BWCAP" and rest then
		local _, _, zone = string.find(rest, ".*: (.*)")
		self:TriggerEvent("BigWigs_Message", string.format(L["portal_cast"], nick, zone), "Blue", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, rest, 60, "Interface\\Icons\\"..portalIcons[rest], "Blue")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
	if sName == L["Fear Ward"] then
		local targetName = nil
		if spellTarget then
			targetName = spellTarget
			spellCasting = nil
			spellTarget = nil
		else
			targetName = UnitExists("target") and UnitName("target") or UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "BWCAFW "..targetName)
	elseif sName == L["Shield Wall"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCASW "..tostring(shieldWallDuration))
	elseif sName == L["Challenging Shout"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACS")
	elseif sName == L["Challenging Roar"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACR")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastCastingFinish(sId, sName, sRank, sFullName, sCastTime)
	if not string.find(sName, L["Portal"]) then return end
	self:ScheduleEvent("bwcaspellcast", self.SpellCast, 0.3, self, sName)
end

function BigWigsCommonAuras:SpellStatus_SpellCastFailure(sId, sName, sRank, sFullName, isActiveSpell, UIEM_Message, CMSFLP_SpellName, CMSFLP_Message)
	-- do nothing if we are casting a spell but the error doesn't consern that spell, thanks Iceroth.
	if (spellStatus:IsCastingOrChanneling() and not spellStatus:IsActiveSpell(sId, sName)) then
		return
	end
	if self:IsEventScheduled("bwcaspellcast") then
		self:CancelScheduledEvent("bwcaspellcast")
	end
end

function BigWigsCommonAuras:SpellCast(sName)
	self:TriggerEvent("BigWigs_SendSync", "BWCAP "..sName)
end


------------------------------
--      Hooks               --
------------------------------
--[[
function BigWigsCommonAuras:UseAction(a1, a2, a3)
	self.hooks["UseAction"](a1, a2, a3)
	if GetActionText(a1) then return end
	if SpellIsTargeting() then return
	elseif a3 then
		spellTarget = UnitName("player")
	elseif UnitExists("target") then
		spellTarget = UnitName("target")
	end
end

function BigWigsCommonAuras:BigWigsCommonAurasOnMouseDown()
	if UnitName("mouseover") then
		spellTarget = UnitName("mouseover")
	elseif GameTooltipTextLeft1:IsVisible() then
		local _, _, name = string.find(GameTooltipTextLeft1:GetText(), "^Corpse of (.+)$")
		if name then
			spellTarget = name
		end
	end
	self.hooks[WorldFrame]["OnMouseDown"]()
end

function BigWigsCommonAuras:CastSpell(spellId, spellbookTabNum)
	self.hooks["CastSpell"](spellId, spellbookTabNum)
	if UnitExists("target") then
		spellTarget = UnitName("target")
	end
	spellCasting = true
end

function BigWigsCommonAuras:CastSpellByName(a1, a2)
	self.hooks["CastSpellByName"](a1, a2)
	if a1 then
		spellCasting = true
		if not SpellIsTargeting() then
			spellTarget = UnitName("target")
		end
	end
end

function BigWigsCommonAuras:SpellTargetUnit(a1)
	local shallTargetUnit
	if SpellIsTargeting() then
		shallTargetUnit = true
	end
	self.hooks["SpellTargetUnit"](a1)
	if shallTargetUnit and spellCasting and not SpellIsTargeting() then
		spellTarget = UnitName(a1)
	end
end


function BigWigsCommonAuras:SpellStopTargeting()
	self.hooks["SpellStopTargeting"]()
	spellCasting = nil
	spellTarget = nil
end

function BigWigsCommonAuras:TargetUnit(a1)
	self.hooks["TargetUnit"](a1)
	if spellCasting and UnitExists(a1) then
		spellTarget = UnitName(a1)
	end
end]]

------------------------------
--      Macro               --
------------------------------

function BWCATargetLastTank()
	if not lastTank then return end
	TargetByName(lastTank, true)
end

