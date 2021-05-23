
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewPlugin("Common Auras")
if not mod then return end
local CAFrame = CreateFrame("Frame")

--------------------------------------------------------------------------------
-- Localization
--

local addonName, L = ...

local PL = BigWigsAPI:GetLocale("BigWigs: Plugins")
function mod:GetLocale() return L end

--------------------------------------------------------------------------------
-- Options
--

local toggleOptions = {
	--[[ Out of combat ]]--
	"repair",
	"portal",
	43987, -- Ritual of Refreshment
	29893, -- Ritual of Souls
	698, -- Ritual of Summoning

	--[[ Group ]]--
	"rebirth",
	29166, -- Innervate
	34477, -- Misdirection
	1022, -- Blessing of Protection
	6940, -- Blessing of Sacrifice
	6346, -- Fear Ward
	32548, -- Symbol of Hope
	2825, -- Bloodlust
	16190, -- Mana Tide Totem

	--[[ Tank ]]--
	5209, -- Challenging Roar
	22842, -- Frenzied Regeneration
	-- 19752, -- Divine Intervention
	498, -- Divine Protection
	642, -- Divine Shield
	1161, -- Challenging Shout
	12975, -- Last Stand
	871, -- Shield Wall

	--[[ Healer ]]--
	-- 22812, -- Barkskin
	740, -- Tranquility
	31842, -- Divine Illumination
	724, -- Lightwell
	33206, -- Pain Suppression
}
local toggleDefaults = { enabled = true, custom = {} }
for _, key in next, toggleOptions do
	toggleDefaults[key] = 0
end
mod.defaultDB = toggleDefaults

local optionHeaders = {
	repair = L.outOfCombat,
	rebirth = L.group,
	[5209] = L.tank,
	[740] = L.healer,
}


local C = BigWigs.C
local bit_band = bit.band
local colors = nil -- key to message color map

-- for emphasized options
function mod:CheckOption(key, flag)
	return self.db.profile[key] and bit_band(self.db.profile[key], C[flag]) == C[flag]
end

local GetDescription do
	local needsUpdate = {}

	local function RefreshOnUpdate(self)
		LibStub("AceConfigRegistry-3.0"):NotifyChange("BigWigs")
		self:SetScript("OnUpdate", nil)
	end

	function mod:SPELL_DATA_LOAD_RESULT(_, spellId, success)
		if success and needsUpdate[spellId] then
			CAFrame:SetScript("OnUpdate", RefreshOnUpdate)
		end
		needsUpdate[spellId] = nil
	end

	function GetDescription(info)
		local spellId = info[#info-1]
		if spellId and not C_Spell.IsSpellDataCached(spellId) then
			needsUpdate[spellId] = true
			C_Spell.RequestLoadSpellData(spellId)
		end
		return GetSpellDescription(spellId)
	end
end

local function GetOptions()
	local options = {
		name = L.commonAuras,
		type = "group",
		childGroups = "tab",
		args = {
			header = {
				type = "description",
				name = GetAddOnMetadata(addonName, "Notes") .. "\n",
				fontSize = "medium",
				order = 0,
			},
			enabled = {
				type = "toggle",
				name = ENABLE,
				get = function() return mod.db.profile.enabled end,
				set = function(_, value)
					mod.db.profile.enabled = value
					mod:Disable()
					mod:Enable()
				end,
				order = 1,
			},
		},
	}

	local function masterGet(info)
		local key = info[#info-1]
		return mod.db.profile[key] > 0
	end
	local function masterSet(info, value)
		local key = info[#info-1]
		if value then
			mod.db.profile[key] = C.MESSAGE + C.BAR
		else
			mod.db.profile[key] = 0
		end
	end

	local function flagGet(info)
		local key = info[#info-1]
		local flag = C[info[#info]]
		return bit_band(mod.db.profile[key], flag) == flag
	end
	local function flagSet(info, value)
		local key = info[#info-1]
		local flag = C[info[#info]]
		if value then
			mod.db.profile[key] = mod.db.profile[key] + flag
		else
			mod.db.profile[key] = mod.db.profile[key] - flag
		end
	end
	local function hidden(info)
		local key = info[#info-1]
		return mod.db.profile[key] == 0
	end

	local cModule = BigWigs:GetPlugin("Colors")
	local function barColorGet(info)
		local option = info[#info]
		local key = info[#info-1]
		return cModule:GetColor(option, mod.name, key)
	end
	local function barColorSet(info, r, g, b, a)
		local option = info[#info]
		local key = info[#info-1]
		cModule.db.profile[option][mod.name][key] = {r, g, b, a}
	end
	local function messageColorGet(info)
		local key = info[#info-1]
		local color = colors[key] or "blue"
		return cModule:GetColor(color, mod.name, key)
	end
	local function messageColorSet(info, r, g, b)
		local key = info[#info-1]
		local color = colors[key] or "blue"
		cModule.db.profile[color][mod.name][key] = {r, g, b, 1}
	end

	local bitflags = {"MESSAGE", "BAR", "EMPHASIZE"}
	local parentGroup
	local header
	for index, key in ipairs(toggleOptions) do
		if optionHeaders[key] then
			header = optionHeaders[key]
			parentGroup = {
				type = "group",
				name = header,
				order = index,
				args = {},
			}
			options.args[header] = parentGroup
		end

		local isSpell = type(key) == "number"
		local group = {
			name = " ",
			type = "group",
			inline = true,
			order = index,
			args = {
				master = {
					type = "toggle",
					name = ("|cfffed000%s|r"):format(isSpell and GetSpellInfo(key) or L[key] or key),
					desc = isSpell and GetDescription or L[key.."_desc"], descStyle = "inline",
					image = GetSpellTexture(isSpell and key or L[key.."_icon"]),
					get = masterGet,
					set = masterSet,
					order = 1,
					width = "full",
				},
				sep1 = {
					type = "header",
					name = "",
					order = 2,
					hidden = hidden,
				},
				--
				-- bitflag options here
				--
				sep2 = {
					type = "header",
					name = PL.colors,
					order = 20,
					hidden = hidden,
				},
				messages = {
					name = PL.messages,
					type = "color",
					get = messageColorGet,
					set = messageColorSet,
					hidden = hidden,
					order = 21,
				},
				barColor = {
					name = PL.bars,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 22,
				},
				barEmphasized = {
					name = PL.emphasizedBars,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 23,
				},
				barBackground = {
					name = L.barBackground,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 24,
				},
				barText = {
					name = L.barText,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 25,
				},
				barTextShadow = {
					name = L.barTextShadow,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 26,
				},
			},
		}
		-- if header == L.tank then
		-- 	group.args.TANK = {
		-- 		type = "toggle",
		-- 		name = BigWigs:GetOptionDetails("TANK"),
		-- 		desc = L.TANK_desc, descStyle = "inline",
		-- 		get = flagGet,
		-- 		set = flagSet,
		-- 		hidden = hidden,
		-- 		order = 10,
		-- 		width = "full",
		-- 	}
		-- end
		for i, flag in ipairs(bitflags) do
			local name, desc = BigWigs:GetOptionDetails(flag)
			group.args[flag] = {
				type = "toggle",
				name = name,
				desc = desc,
				get = flagGet,
				set = flagSet,
				hidden = hidden,
				order = i + 10,
			}
		end

		parentGroup.args[key] = group
	end

	options.args["Custom"] = {
		type = "group",
		name = L.custom,
		order = #toggleOptions + 10,
		args = {
			add = {
				type = "input",
				name = L.addSpell,
				desc = L.addSpellDesc,
				get = false,
				set = function(info, value)
					local _, _, _, _, _, _, spellId = GetSpellInfo(value)
					mod.db.profile.custom[spellId] = {
						event = "SPELL_CAST_SUCCESS",
						format = "used_cast",
						duration = 0,
					}
					mod.db.profile[spellId] = 0
				end,
				validate = function(info, value)
					local _, _, _, _, _, _, spellId = GetSpellInfo(value)
					if not spellId then
						return ("%s: %s"):format(L.commonAuras, L.customErrorInvalid)
					elseif mod.db.profile[spellId] then
						return ("%s: %s"):format(L.commonAuras, L.customErrorExists)
					end
					return true
				end,
				confirm = function(info, value)
					local spell, _, texture, _, _, _, spellId = GetSpellInfo(value)
					if not spell then return false end
					local desc = GetSpellDescription(spellId) or ""
					if desc ~= "" then desc = "\n" .. desc:gsub("%%", "%%%%") end
					return ("%s\n\n|T%d:0|t|cffffd200%s|r (%d)%s"):format(L.customConfirmAdd, texture, spell, spellId, desc)
				end,
				order = 1,
			},
		},
	}

	local customOptions = {}
	for key in next, mod.db.profile.custom do
		if GetSpellInfo(key) then
			customOptions[#customOptions+1] = key
		else
			mod.db.profile.custom[key] = nil
		end
	end
	table.sort(customOptions, function(a, b)
		return GetSpellInfo(a) < GetSpellInfo(b)
	end)

	local function customMasterSet(info, value)
		local key = info[#info-1]
		mod.db.profile[key] = value and C.MESSAGE or 0
	end
	local function customGet(info)
		local option = info[#info]
		local key = info[#info-1]
		return mod.db.profile.custom[key][option]
	end
	local function customSet(info, value)
		local option = info[#info]
		local key = info[#info-1]
		mod.db.profile.custom[key][option] = value
	end

	local eventValues = {
		SPELL_CAST_START = "SPELL_CAST_START",
		SPELL_CAST_SUCCESS = "SPELL_CAST_SUCCESS",
		SPELL_SUMMON = "SPELL_SUMMON",
	}
	local source, target, spell = ("[%s]"):format(STATUS_TEXT_PLAYER), ("[%s]"):format(STATUS_TEXT_TARGET), ("[%s]"):format(STAT_CATEGORY_SPELL)
	local formatValues = {
		used_cast = L.used_cast:format(source, spell),
		usedon_cast = L.usedon_cast:format(source, spell, target)
	}

	for index, key in ipairs(customOptions) do
		local group = {
			name = " ",
			type = "group",
			inline = true,
			order = index + 10,
			args = {
				master = {
					type = "toggle",
					name = ("|cfffed000%s|r (%d)"):format((GetSpellInfo(key)), key),
					desc = GetDescription, descStyle = "inline",
					image = GetSpellTexture(key),
					get = masterGet,
					set = customMasterSet,
					order = 1,
					width = "full",
				},
				event = {
					type = "select",
					name = L.event,
					values = eventValues,
					get = customGet,
					set = customSet,
					hidden = hidden,
					order = 2,
				},
				duration = {
					type = "range",
					name = L.duration,
					min = 0, max = 60, step = 1,
					get = customGet,
					set = customSet,
					hidden = hidden,
					order = 3,
				},
				format = {
					type = "select",
					name = L.textFormat,
					values = formatValues,
					get = customGet,
					set = customSet,
					hidden = hidden,
					order = 4,
				},
				sep1 = {
					type = "header",
					name = "",
					order = 10,
					hidden = hidden,
				},
				--
				-- bitflag options here
				--
				sep2 = {
					type = "header",
					name = PL.colors,
					order = 20,
					hidden = hidden,
				},
				messages = {
					name = PL.messages,
					type = "color",
					get = messageColorGet,
					set = messageColorSet,
					hidden = hidden,
					order = 21,
				},
				barColor = {
					name = PL.regularBars,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 22,
				},
				barEmphasized = {
					name = PL.emphasizedBars,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 23,
				},
				barBackground = {
					name = L.barBackground,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 24,
				},
				barText = {
					name = L.barText,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 25,
				},
				barTextShadow = {
					name = L.barTextShadow,
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 26,
				},
				delete = {
					type = "execute",
					name = L.remove,
					arg = key,
					func = function(info)
						local value = tonumber(info.arg)
						mod.db.profile.custom[value] = nil
						mod.db.profile[value] = nil
						GameTooltip:Hide()
					end,
					order = 30,
				},
			}
		}

		for i, flag in ipairs(bitflags) do
			local name, desc = BigWigs:GetOptionDetails(flag)
			group.args[flag] = {
				type = "toggle",
				name = name,
				desc = desc,
				get = flagGet,
				set = flagSet,
				hidden = hidden,
				order = i + 10,
			}
		end

		options.args["Custom"].args[key] = group
	end

	return options
end

mod.subPanelOptions = {
	key = "Common Auras",
	name = L.commonAuras,
	options = GetOptions,
}

--------------------------------------------------------------------------------
-- Initialization
--

local combatLogMap = {}

function mod:OnRegister()
	-- XXX Do I need the extra spell rank ids?
	-- The original tbc mod only used the rank 1 ids >.>
	combatLogMap.SPELL_CAST_SUCCESS = {
		-- OOC
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[698] = "Ritual", -- Ritual of Summoning
		[29893] = "Ritual", -- Ritual of Souls
		[43987] = "Ritual", -- Ritual of Refreshment
		-- Group
		[29166] = "Innervate",
		[34477] = "Misdirection",
		[1022] = "BlessinOfProtection",
		[5599] = "BlessinOfProtection",
		[10278] = "BlessinOfProtection",
		[6940] = "BlessingOfSacrifice",
		[20729] = "BlessingOfSacrifice",
		[27147] = "BlessingOfSacrifice",
		[27148] = "BlessingOfSacrifice",
		[6346] = "FearWard",
		[16191] = "ManaTideTotem",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		-- Tank
		[1161] = "ChallengingShout",
		[5209] = "ChallengingRoar",
		[12975] = "LastStand",
		[871] = "ShieldWall",
		[498] = "DivineProtection",
		[5573] = "DivineProtection",
		[642] = "DivineShield",
		[1020] = "DivineShield",
		-- [22812] = "Barkskin",
		[22842] = "FrenziedRegeneration",
		[22895] = "FrenziedRegeneration",
		[22896] = "FrenziedRegeneration",
		[26999] = "FrenziedRegeneration",
		-- Healer
		[740] = "Tranquility",
		[8918] = "Tranquility",
		[9862] = "Tranquility",
		[9863] = "Tranquility",
		[26983] = "Tranquility",
		[33206] = "PainSuppression",
		[64901] = "SymbolOfHope",
		[724] = "Lightwell",
		[27870] = "Lightwell",
		[27871] = "Lightwell",
		[28275] = "Lightwell",
		-- Reincarnation
		[21169] = "Reincarnation",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[740] = "TranquilityOff",
		[8918] = "TranquilityOff",
		[9862] = "TranquilityOff",
		[9863] = "TranquilityOff",
		[26983] = "TranquilityOff",
		[6940] = "BlessingOfSacrificeOff",
		[20729] = "BlessingOfSacrificeOff",
		[27147] = "BlessingOfSacrificeOff",
		[27148] = "BlessingOfSacrificeOff",
		[642] = "DivineShieldOff",
		[1020] = "DivineShieldOff",
		[6346] = "FearWardOff",
		[64901] = "SymbolOfHopeOff",
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
	}
	combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth
		[95750] = "Rebirth", -- Soulstone Resurrection
	}
end

function mod:OnPluginEnable()
	if self.db.profile.enabled then
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("SPELL_DATA_LOAD_RESULT")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Portals

		CAFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function mod:OnPluginDisable()
	CAFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local nonCombat = { -- Map of spells to only show out of combat.
	portal = true,
	repair = true,
	[698] = true,   -- Ritual of Summoning
	[29893] = true, -- Ritual of Souls
	[43987] = true, -- Ritual of Refreshment
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.

-- green:  utility and healing cds
-- yellow: targeted cds
-- orange: damaging cds
-- red:    dps cds
-- blue:   everything else
colors = {
	rebirth = "green", -- Rebirth
	[740] = "green", -- Tranquility
	[724] = "green", -- Lightwell
	[34477] = "yellow", -- Misdirection
	[29166] = "yellow", -- Innervate
	[6346] = "yellow", -- Fear Ward
	[33206] = "yellow", -- Pain Suppression
	[6940] = "orange", -- Blessing of Sacrifice
	[1161] = "orange", -- Challenging Shout
	[5209] = "orange", -- Challenging Roar
	[2825] = "red", -- Bloodlust
}

local function checkFlag(key, flag, player)
	if bit_band(mod.db.profile[key], flag) == flag then
		-- if player and bit_band(mod.db.profile[key], C.TANK) == C.TANK and UnitGroupRolesAssigned(player:gsub("%*", "")) ~= "TANK" then return end
		return true
	end
end
local icons = setmetatable({}, {__index =
	function(self, key)
		local icon = GetSpellTexture(key)
		self[key] = icon or nil
		return icon
	end
})
local function duration(player, spellName)
	if not UnitExists(player) then return end -- not in group
	for i = 1, 100 do
		local name, _, _, _, _, expirationTime = UnitAura(player, i, "HELPFUL")
		if not name then break end
		if name == spellName then
			return expirationTime - GetTime()
		end
	end
end
local function message(key, text, player, icon)
	if checkFlag(key, C.MESSAGE, player) then
		mod:SendMessage("BigWigs_Message", mod, key, text, colors[key] or "blue", icons[icon or key], checkFlag(key, C.EMPHASIZE))
	end
end
local function bar(key, length, player, text, icon)
	if nonCombat[key] then
		if InCombatLockdown() then return end
		firedNonCombat[text] = player or false
	end
	if not length then
		-- duration changes with rank or talents or whatever
		length = duration(player, text)
		if not length then
			return
		end
	end
	if checkFlag(key, C.BAR, player) then
		mod:SendMessage("BigWigs_StartBar", mod, key, player and CL.other:format(text, player) or text, length, icons[icon or key])
	end
	if checkFlag(key, C.EMPHASIZE, player) then
		mod:SendMessage("BigWigs_StartEmphasize", mod, player and CL.other:format(text, player) or text, length)
	end
end
local function stopbar(text, player)
	mod:SendMessage("BigWigs_StopBar", mod, player and CL.other:format(text, player) or text)
	mod:SendMessage("BigWigs_StopEmphasize", mod, player and CL.other:format(text, player) or text)
end

function mod:PLAYER_REGEN_DISABLED()
	for text, player in next, firedNonCombat do
		stopbar(text, player)
	end
	firedNonCombat = {}
end

function mod:BigWigs_OnBossWin()
	local _, zoneType = GetInstanceInfo()
	if zoneType == "raid" then
		self:SendMessage("BigWigs_StopBars", self)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Dedicated COMBAT_LOG_EVENT_UNFILTERED handler for efficiency
CAFrame:SetScript("OnEvent", function()
	local _, event, _, _, source, _, _, _, target, _, _, spellId, spellName = CombatLogGetCurrentEventInfo()
	if not combatLogMap[event] then return end

	local f = combatLogMap[event][spellId]
	if f then
		mod[f](mod, target and target:gsub("%-.+", "*"), spellId, source:gsub("%-.+", "*"), spellName)
		return
	end

	f = mod.db.profile.custom[spellId]
	if f and f.event == event then
		-- we could end up with string.format errors so include fallback for player names
		mod:Custom(f, target and target:gsub("%-.+", "*") or UNKNOWN, spellId, source and source:gsub("%-.+", "*") or UNKNOWN, spellName)
		return
	end
end)

do
	local prev = nil
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, castId, spellId)
		if castId == prev then return end
		if combatLogMap.SPELL_CREATE[spellId] and (UnitIsUnit(unit, "player") or UnitInRaid(unit) or UnitInParty(unit)) then
			prev = castId
			local source = self:UnitName(unit, true)
			local spellName = GetSpellInfo(spellId)
			self:Portals(nil, spellId, source, spellName)
		end
	end
end

-- Custom spells
function mod:Custom(info, target, spellId, source, spellName)
	message(spellId, L[info.format]:format(source, spellName, target))
	if info.duration > 0 then
		local player = info.format == "used_cast" and source or target
		bar(spellId, info.duration, player, spellName)
	end
end

-- General

do
	-- heaven forbid they all just be 10min or something
	local durations = {
		[22700] = 600, -- Field Repair Bot 74A, 10min
		[44389] = 600, -- Field Repair Bot 110G, 10min
		[54711] = 300, -- Scrapbot, 5min
		[67826] = 660, -- Jeeves, 11min
		[157066] = 300, -- Walter, 6min
	}
	function mod:Repair(_, spellId, nick, spellName)
		message("repair", L.used_cast:format(nick, spellName), nil, spellId)
		bar("repair", durations[spellId], nick, spellName, spellId)
	end
end

function mod:Ritual(_, spellId, nick, spellName)
	message(spellId, L.ritual_cast:format(nick, spellName))
end

-- Druid

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L.usedon_cast:format(nick, spellName, target), nil, spellId)
end

-- function mod:Barkskin(_, _, nick, spellName)
-- 	message(22812, L.used_cast:format(nick, spellName))
-- 	bar(22812, 12, nick, spellName)
-- end

function mod:ChallengingRoar(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:FrenziedRegeneration(_, _, nick, spellName)
	message(22842, L.used_cast:format(nick, spellName), nick)
	bar(22842, 10, nick, spellName)
end

function mod:Tranquility(_, _, nick, spellName)
	message(740, L.used_cast:format(nick, spellName))
	bar(740, 8, nick, spellName)
end

function mod:TranquilityOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

function mod:Innervate(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	-- bar(spellId, 20, target, spellName)
end

-- Hunter

function mod:Misdirection(target, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 30, nick, spellName)
end

-- Mage

do
	local last = {}
	function mod:Portals(_, spellId, nick, spellName)
		message("portal", L.portal_cast:format(nick, spellName), nil, spellId)
		bar("portal", 65, nick, spellName, spellId)
		-- only show the last portal from a mage
		if last[nick] then stopbar(last[nick], nick) end
		last[nick] = spellName
	end
end

-- Paladin

function mod:DivineProtection(_, _, nick, spellName)
	message(498, L.used_cast:format(nick, spellName), nick)
	bar(498, nil, nick, spellName)
end

function mod:DivineShield(_, _, nick, spellName)
	message(642, L.used_cast:format(nick, spellName), nick)
	bar(642, nil, nick, spellName)
end

function mod:DivineShieldOff(target, _, nick, spellName)
	stopbar(spellName, target)
end

function mod:BlessinOfProtection(target, _, nick, spellName)
	message(1022, L.usedon_cast:format(nick, spellName, target))
	bar(1022, nil, target, spellName)
end

function mod:BlessingOfSacrifice(target, _, nick, spellName)
	message(6940, L.usedon_cast:format(nick, spellName, target))
	bar(6940, 30, target, spellName)
end

function mod:BlessingOfSacrificeOff(target, _, _, spellName)
	stopbar(spellName, target)
end

function mod:DivineIllumination(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

-- function mod:DivineIntervention(target, spellId, nick, spellName)
-- 	message(spellId, L.usedon_cast:format(nick, spellName, target))
-- end

-- Priest

function mod:SymbolOfHope(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
end

function mod:SymbolOfHopeOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, target, spellName)
end

function mod:Lightwell(_, _, nick, spellName)
	message(724, L.used_cast:format(nick, spellName))
end

function mod:FearWard(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 180, target, spellName)
end

function mod:FearWardOff(target, _, _, spellName)
	stopbar(spellName, target)
end

-- Shaman

function mod:Reincarnation(_, spellId, nick, spellName)
	message("rebirth", L.used_cast:format(nick, spellName), nil, spellId)
end

do
	local prev = 0
	function mod:Bloodlust(_, spellId, nick, spellName)
		local t = GetTime()
		if t-prev > 40 then
			prev = t
			message(2825, L.used_cast:format(nick, spellName), nil, spellId)
			bar(2825, 40, nick, spellName, spellId)
		end
	end
end

function mod:ManaTideTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

-- Warrior

function mod:ChallengingShout(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 20, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, nil, nick, spellName)
end
