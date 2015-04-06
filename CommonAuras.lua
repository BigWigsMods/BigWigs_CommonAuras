
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewPlugin("Common Auras")
if not mod then return end

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Common Auras", "enUS", true)
if L then
	L["Common Auras"] = true
	L["Out of combat"] = true
	L["Group"] = true
	L["Self"] = true
	L["Healer"] = true
	L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	L["Messages"] = true
	L["Colors"] = true
	L["Normal bar"] = true
	L["Emphasized bar"] = true
	L["Bar background"] = true
	L["Bar text"] = true
	L["Bar text shadow"] = true

	L.usedon_cast = "%s: %s on %s"
	L.used_cast = "%s used %s"
	L.ritual_cast = "%s wants to perform a %s!"

	L.portal = "Portal"
	L.portal_desc = "Toggle showing of mage portals."
	L.portal_icon = 53142
	L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination
	L.portal_bar = "%s (%s)"

	L.repair = "Repair Bot"
	L.repair_desc = "Toggle showing when repair bots are available."
	L.repair_icon = 67826

	L.feast = "Feasts"
	L.feast_desc = "Toggle showing when feasts get prepared."
	L.feast_icon = 44102
	L.feast_cast = "%s prepared a %s!"

	L.rebirth = "Rebirth"
	L.rebirth_desc = "Toggle showing combat resurrections."
	L.rebirth_icon = 20484
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common Auras")

function mod:GetLocale() return L end

--------------------------------------------------------------------------------
-- Options
--

local toggleOptions = {
	--[[ Out of combat ]]--
	"feast",
	"repair",
	43987, -- Conjure Refreshment Table
	"portal",
	29893, -- Create Soulwell
	698, -- Ritual of Summoning

	--[[ Group ]]--
	51052, -- Anti-Magic Zone
	108199, -- Gorefiend's Grasp
	106898, -- Stampeding Roar
	"rebirth",
	172106, -- Aspect of the Fox
	159916, -- Amplify Magic
	6940, -- Hand of Sacrifice
	114039, -- Hand of Purity
	76577, -- Smoke Bomb
	2825, -- Bloodlust
	114192, -- Mocking Banner
	97462, -- Rallying Cry
	114030, -- Vigilance

	--[[ Self ]]--
	48792, -- Icebound Fortitude
	48982, -- Rune Tap
	55233, -- Vampiric Blood
	22812, -- Barkskin
	61336, -- Survival Instincts
	122278, -- Dampen Harm
	122783, -- Diffuse Magic
	115203, -- Fortifying Brew
	115176, -- Zen Meditation
	31850, -- Ardent Defender
	498, -- Divine Protection
	86659, -- Guardian of Ancient Kings
	1160, -- Demoralizing Shout
	12975, -- Last Stand
	871, -- Shield Wall

	--[[ Healer ]]--
	102342, -- Ironbark
	740, -- Tranquility
	116849, -- Life Cocoon
	115310, -- Revival
	31821, -- Devotion Aura
	64843, -- Divine Hymn
	47788, -- Guardian Spirit
	33206, -- Pain Suppression
	62618, -- Power Word: Barrier
	98008, -- Spirit Link Totem
}
local toggleDefaults = {}
for _, key in next, toggleOptions do
	toggleDefaults[key] = 0
end
mod.defaultDB = toggleDefaults


local C = BigWigs.C
local bit_band = bit.band
local cModule = nil
local colors = nil -- key to message color map

local options = nil
local function GetOptions()
	if options then
		return options
	end

	options = {
		name = L["Common Auras"],
		type = "group",
		childGroups = "tab",
		args = {},
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
		feast = L["Out of combat"],
		[51052] = L["Group"],
		[48792] = L["Self"],
		[102342] = L["Healer"],
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
					name = ("|cfffed000%s|r"):format(isSpell and GetSpellInfo(key) or L[key] or "???"),
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
					name = L["Colors"],
					order = 20,
					hidden = hidden,
				},
				messages = {
					name = L["Messages"],
					type = "color",
					get = messageColorGet,
					set = messageColorSet,
					hidden = hidden,
					order = 21,
				},
				barColor = {
					name = L["Normal bar"],
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 22,
				},
				barEmphasized = {
					name = L["Emphasized bar"],
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 23,
				},
				barBackground = {
					name = L["Bar background"],
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 24,
				},
				barText = {
					name = L["Bar text"],
					type = "color", hasAlpha = true,
					get = barColorGet,
					set = barColorSet,
					hidden = hidden,
					order = 25,
				},
				barTextShadow = {
					name = L["Bar text shadow"],
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
	name = L["Common Auras"],
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
		[97462] = "RallyingCry",
		[114030] = "Vigilance",
		[106898] = "StampedingRoar",
		[172106] = "AspectOfTheFox",
		[6940] = "HandOfSacrifice",
		[114039] = "HandOfPurity",
		[108199] = "GorefiendsGrasp",
		[51052] = "AntiMagicZone",
		[76577] = "SmokeBomb",
		[159916] = "AmplifyMagic",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[90355] = "Bloodlust", -- Ancient Hysteria
		[160452] = "Bloodlust", -- Netherwinds
		-- Tank
		[871] = "ShieldWall",
		[12975] = "LastStand",
		[1160] = "DemoralizingShout",
		[31850] = "ArdentDefender",
		[86659] = "GuardianOfAncientKings",
		[498] = "DivineProtection",
		[48792] = "IceboundFortitude",
		[48982] = "RuneTap",
		[55233] = "VampiricBlood",
		[22812] = "Barkskin",
		[61336] = "SurvivalInstincts",
		[115203] = "FortifyingBrew",
		[115176] = "ZenMeditation",
		[122278] = "DampenHarm",
		[122783] = "DiffuseMagic",
		-- Healer
		[33206] = "PainSuppression",
		[62618] = "PowerWordBarrier",
		[47788] = "GuardianSpirit",
		[64843] = "DivineHymn",
		[102342] = "Ironbark",
		[740] = "Tranquility",
		[31821] = "DevotionAura",
		[98008] = "SpiritLink",
		[116849] = "LifeCocoon",
		[115310] = "Revival",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[740] = "TranquilityOff",
		[64843] = "DivineHymnOff",
		[47788] = "GuardianSpiritOff",
		[115176] = "ZenMeditationOff",
		[116849] = "LifeCocoonOff",
		[122278] = "DampenHarmOff",
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
	combatLogMap.SPELL_SUMMON = {
		[114192] = "MockingBanner",
	}

	-- XXX temp db reset
	local ns = BigWigs3DB.namespaces["BigWigs_Plugins_Common Auras"]
	if not ns.reset then
		if ns.profiles then
			for profile, db in next, ns.profiles do
				wipe(db)
			end
			self.resetMessage = true
		end
		ns.reset = true
	end
end

function mod:OnPluginEnable()
	if self.resetMessage then
		print("|cFF33FF99Big Wigs|r: Common Auras has been updated to show in the Big Wigs settings panel! Spells now default to being disabled which, unfortunately, means your settings have been reset :(")
	end

	cModule = BigWigs:GetPlugin("Colors")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:ZONE_CHANGED_NEW_AREA()
end

function mod:ZONE_CHANGED_NEW_AREA()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "raid" or instanceType == "party") then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, _, source, _, _, _, player, _, _, spellId, spellName)
	local f = combatLogMap[event] and combatLogMap[event][spellId] or nil
	if f and player then
		self[f](self, player:gsub("%-.+", "*"), spellId, source:gsub("%-.+", "*"), spellName)
	elseif f then
		self[f](self, player, spellId, source:gsub("%-.+", "*"), spellName)
	end
end


local nonCombat = { -- Map of spells to only show out of combat.
	portal = true,
	repair = true,
	feast = true,
	[698] = true, -- Rital of Summoning
	[29893] = true, -- Create Soulwell
	[43987] = true, -- Conjure Refreshment Table
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.

local green = "Positive"   -- utility and healing cds
local orange = "Urgent"    -- damaging cds
local yellow = "Attention" -- targeted cds
local red = "Important"    -- dps cds
local blue = "Personal"    -- everything else
local cyan = "Neutral"     -- not used

colors = {
	[102342] = yellow, -- Ironbark
	[106898] = green, -- Stampeding Roar
	[740] = green, -- Tranquility
	rebirth = green,
	[172106] = green, -- Aspect of the Fox
	[116849] = yellow, -- Life Cocoon
	[115310] = green, -- Revival
	[6940] = orange, -- Hand of Sacrifice
	[114039] = yellow, -- Hand of Purity
	[64843] = green, -- Divine Hymn
	[47788] = yellow, -- Guardian Spirit
	[33206] = yellow, -- Pain Suppression
	[2825] = red, -- Bloodlust
	[98008] = orange, -- Spirit Link Totem
	[114192] = orange, -- Mocking Banner
	[114030] = orange, -- Vigilance
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

--------------------------------------------------------------------------------
-- Event Handlers
--

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

do
	local feast = GetSpellInfo(66477)
	function mod:Feasts(_, spellId, nick, spellName)
		message("feast", L.feast_cast:format(nick, spellName), nil, spellId)
		bar("feast", 180, nick, feast, spellId)
	end
end

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L.portal_cast:format(nick, spellName), nil, spellId)
	bar("portal", 65, L.portal_bar:format(spellName, nick), nick, spellName, spellId)
end

function mod:SummoningStone(_, spellId, nick, spellName)
	message(spellId, L.ritual_cast:format(nick, spellName))
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:Soulwell(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

do
	local prev = 0
	function mod:Bloodlust(_, spellId, nick, spellName)
		local t = GetTime()
		if t-prev > 40 then
			message(2825, L.used_cast:format(nick, spellName), nil, spellId)
			bar(2825, 40, nick, spellName, spellId)
			prev = t
		end
	end
end

function mod:SpiritLink(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, target, spellName)
end

function mod:GuardianSpirit(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:GuardianSpiritOff(target, spellId, nick, spellName)
	stopbar(spellName, nick, spellName) -- removed on absorbed fatal blow
end

function mod:PowerWordBarrier(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:DivineHymn(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:DivineHymnOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:HandOfSacrifice(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:HandOfPurity(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 6, target, spellName)
end

function mod:DevotionAura(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:DivineProtection(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

function mod:GuardianOfAncientKings(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:LastStand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:RallyingCry(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:Vigilance(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:DemoralizingShout(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:MockingBanner(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 30, nick, spellName)
end

function mod:IceboundFortitude(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:RuneTap(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 3, nick, spellName)
end

function mod:VampiricBlood(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

function mod:GorefiendsGrasp(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:AntiMagicZone(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 3, nick, spellName)
end

function mod:Barkskin(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:SurvivalInstincts(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L.usedon_cast:format(nick, spellName, target), nil, spellId)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:Tranquility(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:TranquilityOff(_, spellId, nick, spellName)
	stopbar(spellName, nick, spellName)
end

function mod:StampedingRoar(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:DampenHarm(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 45, nick, spellName)
end

function mod:DampenHarmOff(_, spellId, nick, spellName)
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

function mod:ZenMeditation(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:ZenMeditationOff(_, spellId, nick, spellName)
	stopbar(spellName, nick) -- removed on melee
end

function mod:LifeCocoon(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:LifeCocoonOff(target, spellId, nick, spellName)
	stopbar(spellName, target)
end

function mod:Revival(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:SmokeBomb(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 5, nick, spellName)
end

function mod:AmplifyMagic(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:AspectOfTheFox(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

