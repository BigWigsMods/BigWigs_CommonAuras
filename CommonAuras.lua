
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

local PL = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
function mod:GetLocale() return L end

--------------------------------------------------------------------------------
-- Options
--

local toggleOptions = {
	--[[ Out of combat ]]--
	"feast",
	"repair",
	226241, -- Codex of the Tranquil Mind
	43987, -- Conjure Refreshment Table
	"portal",
	29893, -- Create Soulwell
	698, -- Ritual of Summoning

	--[[ Group ]]--
	108199, -- Gorefiend's Grasp
	196718, -- Darkness
	207810, -- Nether Bond
	106898, -- Stampeding Roar
	"rebirth",
	204150, -- Aegis of Light
	1022, -- Blessing of Protection
	204018, -- Blessing of Spellwarding
	6940, -- Blessing of Sacrifice
	2825, -- Bloodlust
	192077, -- Wind Rush Totem
	97462, -- Commanding Shout

	--[[ Self ]]--
	48792, -- Icebound Fortitude
	55233, -- Vampiric Blood
	204021, -- Fiery Brand
	187827, -- Metamorphosis
	22812, -- Barkskin
	61336, -- Survival Instincts
	122278, -- Dampen Harm
	122783, -- Diffuse Magic
	115203, -- Fortifying Brew
	115176, -- Zen Meditation
	31850, -- Ardent Defender
	498, -- Divine Protection
	642, -- Divine Shield
	86659, -- Guardian of Ancient Kings
	1160, -- Demoralizing Shout
	12975, -- Last Stand
	871, -- Shield Wall

	--[[ Healer ]]--
	102342, -- Ironbark
	740, -- Tranquility
	116849, -- Life Cocoon
	115310, -- Revival
	31821, -- Aura Mastery
	64843, -- Divine Hymn
	47788, -- Guardian Spirit
	33206, -- Pain Suppression
	62618, -- Power Word: Barrier
	108280, -- Healing Tide Totem
	98008, -- Spirit Link Totem
}
local toggleDefaults = { enabled = true }
for _, key in next, toggleOptions do
	toggleDefaults[key] = 0
end
mod.defaultDB = toggleDefaults


local C = BigWigs.C
local bit_band = bit.band
local colors = nil -- key to message color map

-- for emphasized options
function mod:CheckOption(key, flag)
	return self.db.profile[key] and bit_band(self.db.profile[key], C[flag]) == C[flag]
end

local options = nil
local function GetOptions()
	if options then
		return options
	end

	options = {
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
		if type(mod.db.profile[key]) ~= "number" then
			mod.db.profile[key] = 0
		end
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

	local function get(info)
		local key = info[#info-1]
		local flag = C[info[#info]]
		return bit_band(mod.db.profile[key], flag) == flag
	end
	local function set(info, value)
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
		local value = mod.db.profile[key] or 0
		return value == 0
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
		local color = colors[key] or "Personal"
		return cModule:GetColor(color, mod.name, key)
	end
	local function messageColorSet(info, r, g, b)
		local key = info[#info-1]
		local color = colors[key] or "Personal"
		cModule.db.profile[color][mod.name][key] = {r, g, b, 1}
	end

	local optionHeaders = {
		feast = L.outOfCombat,
		[108199] = L.group,
		[48792] = L.self,
		[102342] = L.healer,
	}
	local bitflags = {"MESSAGE", "BAR", "EMPHASIZE"}
	local parentGroup = nil
	local isTankCD = nil
	for index, key in ipairs(toggleOptions) do
		if optionHeaders[key] then
			local header = optionHeaders[key]
			parentGroup = {
				type = "group",
				name = header,
				order = index,
				args = {},
			}
			options.args[header] = parentGroup
			isTankCD = key == 48792
		end

		local isSpell = type(key) == "number"
		local group = {
			name = " ",
			type = "group",
			get = get,
			set = set,
			inline = true,
			order = index,
			args = {
				master = {
					type = "toggle",
					name = ("|cfffed000%s|r"):format(isSpell and GetSpellInfo(key) or L[key] or key),
					desc = isSpell and GetSpellDescription(key) or L[key.."_desc"], descStyle = "inline",
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
			},
		}
		if isTankCD then
			group.args.TANK = {
				type = "toggle",
				name = BigWigs:GetOptionDetails("TANK"),
				desc = L.TANK_desc, descStyle = "inline",
				hidden = hidden,
				order = 10,
				width = "full",
			}
		end
		for i, flag in ipairs(bitflags) do
			local name, desc = BigWigs:GetOptionDetails(flag)
			group.args[flag] = {
				type = "toggle",
				name = name,
				desc = desc,
				hidden = hidden,
				order = i + 10,
			}
		end

		parentGroup.args[key] = group
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
	combatLogMap.SPELL_CAST_START = {
		[160740] = "Feasts", -- Feast of Blood (+75)
		[160914] = "Feasts", -- Feast of the Waters (+75)
		[175215] = "Feasts", -- Savage Feast (+100)
	}
	combatLogMap.SPELL_CAST_SUCCESS = {
		-- OOC
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[54711] = "Repair", -- Scrapbot
		[67826] = "Repair", -- Jeeves
		[157066] = "Repair", -- Walter
		[698] = "SummoningStone", -- Ritual of Summoning
		[29893] = "Soulwell", -- Create Soulwell
		[43987] = "Refreshment", -- Conjure Refreshment Table
		-- Group
		[97462] = "CommandingShout",
		[106898] = "StampedingRoar",
		[1022] = "BlessinOfProtection",
		[204018] ="BlessingOfSpellwarding",
		[6940] = "BlessingOfSacrifice",
		[108199] = "GorefiendsGrasp",
		[204150] = "AegisOfLight",
		[192077] = "WindRushTotem",
		[196718] = "Darkness",
		[207810] = "Nether Bond",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[90355] = "Bloodlust", -- Ancient Hysteria
		[160452] = "Bloodlust", -- Netherwinds
		[178207] = "Bloodlust", -- Leatherworking: Drums of Fury
		-- Tank
		[871] = "ShieldWall",
		[12975] = "LastStand",
		[1160] = "DemoralizingShout",
		[31850] = "ArdentDefender",
		[86659] = "GuardianOfAncientKings",
		[498] = "DivineProtection",
		[642] = "DivineShield",
		[48792] = "IceboundFortitude",
		[55233] = "VampiricBlood",
		[22812] = "Barkskin",
		[61336] = "SurvivalInstincts",
		[115203] = "FortifyingBrew",
		[115176] = "ZenMeditation",
		[122278] = "DampenHarm",
		[122783] = "DiffuseMagic",
		[187827] = "Metamorphosis",
		[204021] = "FieryBrand",
		-- Healer
		[33206] = "PainSuppression",
		[62618] = "PowerWordBarrier",
		[47788] = "GuardianSpirit",
		[64843] = "DivineHymn",
		[102342] = "Ironbark",
		[740] = "Tranquility",
		[31821] = "AuraMastery",
		[98008] = "SpiritLink",
		[108280] = "HealingTide",
		[116849] = "LifeCocoon",
		[115310] = "Revival",
		-- Reincarnation
		[21169] = "Reincarnation",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[740] = "TranquilityOff",
		[64843] = "DivineHymnOff",
		[47788] = "GuardianSpiritOff",
		[115176] = "ZenMeditationOff",
		[116849] = "LifeCocoonOff",
		[122278] = "DampenHarmOff",
		[204150] = "AegisOfLightOff",
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
		[53142] = "Portals", -- Dalaran
		[88345] = "Portals", -- Tol Barad (Alliance)
		[88346] = "Portals", -- Tol Barad (Horde)
		[132620] = "Portals", -- Vale of Eternal Blossoms (Alliance)
		[132626] = "Portals", -- Vale of Eternal Blossoms (Horde)
		[176246] = "Portals", -- Stormshield (Alliance)
		[176244] = "Portals", -- Warspear (Horde)
	}
	combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth
		[95750] = "Rebirth", -- Soulstone Resurrection
		[61999] = "Rebirth", -- Raise Ally
		[126393] = "Rebirth", -- Eternal Guardian (Hunter pet)
		[159931] = "Rebirth", -- Gift of Chi-Ji (Hunter pet)
		[159956] = "Rebirth", -- Dust of Life (Hunter pet)
	}
end

function mod:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- for tracking Codex casts

	CAFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function mod:OnPluginDisable()
	CAFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local nonCombat = { -- Map of spells to only show out of combat.
	portal = true,
	repair = true,
	feast = true,
	[698] = true, -- Rital of Summoning
	[29893] = true, -- Create Soulwell
	[43987] = true, -- Conjure Refreshment Table
	[226241] = true, -- Codex of the Tranquil Mind
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.

local green = "Positive"   -- utility and healing cds
local orange = "Urgent"    -- damaging cds
local yellow = "Attention" -- targeted cds
local red = "Important"    -- dps cds
local blue = "Personal"    -- everything else

colors = {
	[207810] = orange, -- Nether Bond
	[102342] = yellow, -- Ironbark
	[106898] = green, -- Stampeding Roar
	[740] = green, -- Tranquility
	rebirth = green,
	[116849] = yellow, -- Life Cocoon
	[115310] = green, -- Revival
	[6940] = orange, -- Blessing of Sacrifice
	[64843] = green, -- Divine Hymn
	[47788] = yellow, -- Guardian Spirit
	[33206] = yellow, -- Pain Suppression
	[2825] = red, -- Bloodlust
	[108280] = green, -- Healing Tide Totem
	[98008] = orange, -- Spirit Link Totem
}

local function checkFlag(key, flag, player)
	if bit_band(mod.db.profile[key], flag) == flag then
		if player and bit_band(mod.db.profile[key], C.TANK) == C.TANK and UnitGroupRolesAssigned(player:gsub("%*", "")) ~= "TANK" then return end
		return true
	end
end
local icons = setmetatable({}, {__index =
	function(self, key)
		local icon = GetSpellTexture(key)
		self[key] = icon
		return icon
	end
})
local function message(key, text, player, icon)
	if checkFlag(key, C.MESSAGE, player) then
		mod:SendMessage("BigWigs_Message", mod, key, text, colors[key] or blue, icons[icon or key])
	end
end
local function bar(key, length, player, text, icon)
	if nonCombat[key] then
		if InCombatLockdown() then return end
		firedNonCombat[text] = player or false
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
	wipe(firedNonCombat)
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
CAFrame:SetScript("OnEvent", function(_, _, _, event, _, _, source, _, _, _, player, _, _, spellId, spellName)
	local f = combatLogMap[event] and combatLogMap[event][spellId] or nil
	if f and player then
		mod[f](mod, player:gsub("%-.+", "*"), spellId, source:gsub("%-.+", "*"), spellName)
	elseif f then
		mod[f](mod, player, spellId, source:gsub("%-.+", "*"), spellName)
	end
end)

-- General

-- Codex handling. There are no CLEU events for this, unfortunately
do
	local prev = ""
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, castGUID, spellId)
		if spellId == 226241 and castGUID ~= prev then
			prev = castGUID
			local nick = self:UnitName(unit, true)
			message(spellId, L.used_cast:format(nick, spellName))
			bar(spellId, 300, nick, L.codex)
		end
	end
end

do
	local feast = GetSpellInfo(66477)
	function mod:Feasts(_, spellId, nick, spellName)
		message("feast", L.feast_cast:format(nick, spellName), nil, spellId)
		bar("feast", 180, nick, feast, spellId)
	end
end

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

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L.usedon_cast:format(nick, spellName, target), nil, spellId)
end

function mod:Reincarnation(_, spellId, nick, spellName)
	message("rebirth", L.used_cast:format(nick, spellName), nil, spellId)
end

-- Death Knight

function mod:GorefiendsGrasp(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:IceboundFortitude(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:VampiricBlood(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

-- Demon Hunter

function mod:Darkness(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:FieryBrand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:NetherBond(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 15, target, spellName)
end

function mod:Metamorphosis(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

-- Druid

function mod:Barkskin(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:StampedingRoar(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:SurvivalInstincts(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:Tranquility(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:TranquilityOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

-- Mage

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L.portal_cast:format(nick, spellName), nil, spellId)
	bar("portal", 65, nick, spellName, spellId)
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

-- Monk

function mod:DampenHarm(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 45, nick, spellName)
end

function mod:DampenHarmOff(_, _, nick, spellName)
	stopbar(spellName, nick) -- removed on melees
end

function mod:DiffuseMagic(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:FortifyingBrew(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:LifeCocoon(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:LifeCocoonOff(target, _, _, spellName)
	stopbar(spellName, target)
end

function mod:Revival(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:ZenMeditation(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:ZenMeditationOff(_, _, nick, spellName)
	stopbar(spellName, nick) -- removed on melee
end

-- Paladin

function mod:AegisOfLight(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:AegisOfLightOff(_, spellId, nick, spellName)
	stopbar(spellName, nick)
end

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

function mod:AuraMastery(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:DivineProtection(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:DivineShield(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:GuardianOfAncientKings(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:BlessinOfProtection(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:BlessingOfSpellwarding(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:BlessingOfSacrifice(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

-- Priest

function mod:DivineHymn(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:DivineHymnOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

function mod:GuardianSpirit(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:GuardianSpiritOff(_, _, nick, spellName)
	stopbar(spellName, nick) -- removed on absorbed fatal blow
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, target)
end

function mod:PowerWordBarrier(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

-- Shaman

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

function mod:SpiritLink(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:HealingTide(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:WindRushTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

-- Warlock

function mod:Soulwell(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:SummoningStone(_, spellId, nick, spellName)
	message(spellId, L.ritual_cast:format(nick, spellName))
end

-- Warrior

function mod:DemoralizingShout(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:CommandingShout(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

