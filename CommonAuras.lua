
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewPlugin("Common Auras")
if not mod then return end
local CAFrame = CreateFrame("Frame")

-- luacheck: globals C_AddOns C_Spell UnitGroupRolesAssigned

--------------------------------------------------------------------------------
-- Localization
--

local addonName, L = ...

local PL = BigWigsAPI:GetLocale("BigWigs: Plugins")
function mod:GetLocale() return L end

--------------------------------------------------------------------------------
-- Options
--

local GetSpellName = BigWigsLoader.GetSpellName
local GetSpellDescription = BigWigsLoader.GetSpellDescription
local GetSpellTexture = BigWigsLoader.GetSpellTexture
local GetSpellInfo = C_Spell.GetSpellInfo

local toggleOptions = {
	--[[ Out of combat ]]--
	"feast",
	"repair",
	43987, -- Conjure Refreshment Table
	"portal",
	29893, -- Create Soulwell
	698, -- Ritual of Summoning
	114018, -- Shroud of Concealment

	--[[ Group ]]--
	-- Death Knight
	51052, -- Anti-Magic Zone
	108199, -- Gorefiend's Grasp
	383269, -- Abomination Limb
	-- Demon Hunter
	196718, -- Darkness
	-- Druid
	29166, -- Innervate
	106898, -- Stampeding Roar
	124974, -- Nature's Vigil
	"rebirth",
	-- Evoker
	374227, -- Zephyr
	-- Hunter
	53480, -- Roar of Sacrifice
	-- Mage
	414660, -- Mass Barrier
	-- Monk
	116841, -- Tiger's Lust
	-- Paladin
	1044, -- Blessing of Freedom
	1022, -- Blessing of Protection
	204018, -- Blessing of Spellwarding
	6940, -- Blessing of Sacrifice
	-- Priest
	15286, -- Vampiric Embrace
	-- Shaman
	2825, -- Bloodlust
	108281, -- Ancestral Guidance
	207399, -- Ancestral Protection Totem
	198103, -- Earth Elemental
	16191, -- Mana Tide Totem
	192077, -- Wind Rush Totem
	-- Warlock
	111771, -- Demonic Gateway
	-- Warrior
	97462, -- Rallying Cry

	--[[ Defensive ]]--
	-- Death Knight
	49028, -- Dancing Rune Weapon
	48743, -- Death Pact
	48792, -- Icebound Fortitude
	55233, -- Vampiric Blood
	-- Demon Hunter
	198589, -- Blur
	204021, -- Fiery Brand
	187827, -- Metamorphosis
	196555, -- Netherwalk
	-- Druid
	22812, -- Barkskin
	102558, -- Incarnation (Guardian)
	61336, -- Survival Instincts
	-- Evoker
	363916, -- Obsidian Scales
	374348, -- Renewing Blaze
	-- Monk
	122278, -- Dampen Harm
	122783, -- Diffuse Magic
	115203, -- Fortifying Brew
	115176, -- Zen Meditation
	-- Paladin
	31850, -- Ardent Defender
	498, -- Divine Protection
	642, -- Divine Shield
	86659, -- Guardian of Ancient Kings
	-- Warrior
	1160, -- Demoralizing Shout
	12975, -- Last Stand
	871, -- Shield Wall
	392966, -- Spell Block

	--[[ Healer ]]--
	-- Druid
	33891, -- Incarnation (Tree of Life)
	102342, -- Ironbark
	740, -- Tranquility
	-- Evoker
	357170, -- Time Dilation
	363534, -- Rewind
	-- Monk
	116849, -- Life Cocoon
	322118, -- Invoke Yu'lon
	115310, -- Revival
	-- Paladin
	31821, -- Aura Mastery
	-- Priest
	64843, -- Divine Hymn
	47788, -- Guardian Spirit
	126135, -- Lightwell
	64901, -- Symbol of Hope
	265202, -- Holy Word: Salvation
	33206, -- Pain Suppression
	62618, -- Power Word: Barrier
	271466, -- Luminous Barrier
	108968, -- Void Shift
	-- Shaman
	114052, -- Ascendance
	108280, -- Healing Tide Totem
	198838, -- Earthen Wall Totem
	98008, -- Spirit Link Totem
}
local toggleDefaults = { enabled = true, custom = {} }
for _, key in next, toggleOptions do
	toggleDefaults[key] = 0
end
mod.defaultDB = toggleDefaults


local C = BigWigs.C
local bit_band, bit_bor = bit.band, bit.bor
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
				name = C_AddOns.GetAddOnMetadata(addonName, "Notes") .. "\n",
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

	local optionHeaders = {
		feast = L.outOfCombat,
		[51052] = L.group,
		[49028] = L.defensive,
		[33891] = L.healer,
	}
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
					name = ("|cfffed000%s|r"):format(isSpell and GetSpellName(key) or L[key] or key),
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
		if header == L.defensive then
			group.args.TANK = {
				type = "toggle",
				name = BigWigs:GetOptionDetails("TANK"),
				desc = L.TANK_desc, descStyle = "inline",
				get = flagGet,
				set = flagSet,
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
					local info = GetSpellInfo(value)
					if info then
						mod.db.profile.custom[info.spellID] = {
							event = "SPELL_CAST_SUCCESS",
							format = "used_cast",
							duration = 0,
						}
						mod.db.profile[info.spellID] = 0
					end
				end,
				validate = function(info, value)
					local info = GetSpellInfo(value)
					if not info then
						return ("%s: %s"):format(L.commonAuras, L.customErrorInvalid)
					elseif mod.db.profile[info.spellID] then
						return ("%s: %s"):format(L.commonAuras, L.customErrorExists)
					end
					return true
				end,
				confirm = function(info, value)
					local info = GetSpellInfo(value)
					if not info then return false end
					local desc = GetSpellDescription(info.spellID) or ""
					if desc ~= "" then desc = "\n" .. desc:gsub("%%", "%%%%") end
					return ("%s\n\n|T%d:0|t|cffffd200%s|r (%d)%s"):format(L.customConfirmAdd, info.iconID, info.name, info.spellID, desc)
				end,
				order = 1,
			},
		},
	}

	local customOptions = {}
	for key in next, mod.db.profile.custom do
		if GetSpellName(key) then
			customOptions[#customOptions+1] = key
		else
			mod.db.profile.custom[key] = nil
		end
	end
	table.sort(customOptions, function(a, b)
		return GetSpellName(a) < GetSpellName(b)
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
					name = ("|cfffed000%s|r (%d)"):format(GetSpellName(key), key),
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
	combatLogMap.SPELL_SUMMON = {
		-- Reaves (Pylon doesn't have a _SUCCESS, so we'll just use _SUMMON for all of them)
		[200205] = "AutoHammer", -- Auto-Hammer Mode
		[200211] = "Pylon", -- Failure Detection Mode (50)
	}
	combatLogMap.SPELL_CAST_START = {
		[259409] = "Feasts", -- Galley Banquet (+17 primary stat)
		[259410] = "Feasts", -- Bountiful Captain's Feast (+23 primary stat)
		[286050] = "Feasts", -- Sanguinated Feast (+23 primary stat)
		[297048] = "Feasts", -- Famine Evaluator And Snack Table (+25 primary stat)
		[308458] = "Feasts", -- Surprisingly Palatable Feast (+18 primary stat)
		[308462] = "Feasts", -- Feast of Gluttonous Hedonism (+20 primary stat)
		[382423] = "Feasts", -- Yusa's Hearty Stew (+70 lowest secondary)
		[382427] = "Feasts", -- Grand Banquet of the Kalu'ak (+76 primary stat)
		[383063] = "Feasts", -- Prepare Growing Hoard of Draconic Delicacies (+76 primary stat)
	}
	combatLogMap.SPELL_CAST_SUCCESS = {
		-- OOC
		[22700] = "Repair", -- Field Repair Bot 74A
		[44389] = "Repair", -- Field Repair Bot 110G
		[54711] = "Repair", -- Scrapbot
		[67826] = "Repair", -- Jeeves
		[157066] = "Repair", -- Walter
		[199109] = "AutoHammer", -- Auto-Hammer
		[199115] = "Pylon", -- Failure Detection Pylon (50)
		[385969] = "Pylon", -- S.A.V.I.O.R. (70)
		[698] = "SummoningStone", -- Ritual of Summoning
		[29893] = "Soulwell", -- Create Soulwell
		[43987] = "Refreshment", -- Conjure Refreshment Table
		-- Group
		[97462] = "RallyingCry",
		[29166] = "Innervate",
		[106898] = "StampedingRoar",
		[124974] = "NaturesVigil",
		[1044] = "BlessingOfFreedom",
		[1022] = "BlessingOfProtection",
		[204018] ="BlessingOfSpellwarding",
		[6940] = "BlessingOfSacrifice",
		[199448] = "BlessingOfSacrifice", -- Ultimate Sacrifice
		[15286] = "VampiricEmbrace",
		[108199] = "GorefiendsGrasp",
		[383269] = "AbominationLimb",
		[108281] = "AncestralGuidance",
		[207399] = "AncestralProtectionTotem",
		[16191] = "ManaTideTotem",
		[198103] = "EarthElemental",
		[192077] = "WindRushTotem",
		[196718] = "Darkness",
		[51052] = "AntiMagicZone",
		[111771] = "DemonicGateway",
		[114018] = "ShroudOfConcealment",
		[374227] = "Zephyr",
		[116841] = "TigersLust",
		[53480] = "RoarOfSacrifice",
		[414660] = "MassBarrier",
		-- DPS
		[2825] = "Bloodlust", -- Bloodlust
		[32182] = "Bloodlust", -- Heroism
		[80353] = "Bloodlust", -- Time Warp
		[264667] = "Bloodlust", -- Hunter pet: Primal Rage
		[390386] = "Bloodlust", -- Fury of the Aspects
		[146555] = "Bloodlust", -- LW: Drums of Rage (50)
		[178207] = "Bloodlust", -- LW: Drums of Fury (50)
		[230935] = "Bloodlust", -- LW: Drums of the Mountain (50)
		[256740] = "Bloodlust", -- LW: Drums of the Maelstrom (50)
		[292686] = "Bloodlust", -- LW: Mallet of Thunderous Skins (50)
		[309658] = "Bloodlust", -- LW: Drums of Deathly Ferocity (60)
		[381301] = "Bloodlust", -- LW: Feral Hide Drums (70)
		-- Tank
		[871] = "ShieldWall",
		[12975] = "LastStand",
		[1160] = "DemoralizingShout",
		[392966] = "SpellBlock",
		[31850] = "ArdentDefender",
		[86659] = "GuardianOfAncientKings",
		[498] = "DivineProtection",
		[642] = "DivineShield",
		[49028] = "DancingRuneWeapon",
		[48743] = "DeathPact",
		[48792] = "IceboundFortitude",
		[55233] = "VampiricBlood",
		[22812] = "Barkskin",
		[102558] = "IncarnationGuardian",
		[33891] = "IncarnationTree",
		[61336] = "SurvivalInstincts",
		[122278] = "DampenHarm",
		[122783] = "DiffuseMagic",
		[115203] = "FortifyingBrew",
		[115176] = "ZenMeditation",
		[198589] = "Blur",
		[204021] = "FieryBrand",
		[187827] = "Metamorphosis",
		[196555] = "Netherwalk",
		[363916] = "ObsidianScales",
		[374348] = "RenewingBlaze",
		-- Healer
		[64843] = "DivineHymn",
		[47788] = "GuardianSpirit",
		[265202] = "HolyWordSalvation",
		[126135] = "Lightwell",
		[33206] = "PainSuppression",
		[62618] = "PowerWordBarrier",
		[271466] = "LuminousBarrier",
		[108968] = "VoidShift",
		[64901] = "SymbolOfHope",
		[102342] = "Ironbark",
		[740] = "Tranquility",
		[31821] = "AuraMastery",
		[98008] = "SpiritLinkTotem",
		[108280] = "HealingTideTotem",
		[198838] = "EarthenWallTotem",
		[114052]= "Ascendance",
		[116849] = "LifeCocoon",
		[322118] = "InvokeYulon",
		[115310] = "Revival",
		[388615] = "Revival", -- Restoral
		[357170] = "TimeDilation",
		[363534] = "Rewind",
		-- Reincarnation
		[21169] = "Reincarnation",
	}
	combatLogMap.SPELL_AURA_REMOVED = {
		[740] = "TranquilityOff",
		[64843] = "DivineHymnOff",
		[47788] = "GuardianSpiritOff",
		[115176] = "ZenMeditationOff",
		[116849] = "LifeCocoonOff",
		[6940] = "BlessingOfSacrificeOff",
		[199448] = "BlessingOfSacrificeOff", -- Ultimate Sacrifice
		[48743] = "DeathPactOff",
		[196555] = "NetherwalkOff",
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
		[53142] = "Portals", -- Dalaran - Northrend
		[88345] = "Portals", -- Tol Barad (Alliance)
		[88346] = "Portals", -- Tol Barad (Horde)
		[120146] = "Portals", -- Ancient Portal: Dalaran
		[132620] = "Portals", -- Vale of Eternal Blossoms (Alliance)
		[132626] = "Portals", -- Vale of Eternal Blossoms (Horde)
		[176246] = "Portals", -- Stormshield (Alliance)
		[176244] = "Portals", -- Warspear (Horde)
		[224871] = "Portals", -- Dalaran - Broken Isles
		[281400] = "Portals", -- Boralus (Alliance)
		[281402] = "Portals", -- Dazar'alor (Horde)
		[344597] = "Portals", -- Oribos
		[395289] = "Portals", -- Valdrakken
	}
	combatLogMap.SPELL_RESURRECT = {
		[20484] = "Rebirth", -- Rebirth (Druid)
		[61999] = "Rebirth", -- Raise Ally (Death Knight)
		[95750] = "Rebirth", -- Soulstone Resurrection (Warlock)
		[391054] = "Rebirth", -- Intercession (Paladin)
		[265116] = "Rebirth", -- Unstable Temporal Time Shifter (Engineer) (60)
		[345130] = "Rebirth", -- Disposable Spectrophasic Reanimator (Engineer)
		[393795] = "Rebirth", -- Arclight Vital Correctors (Engineer)
	}
end

function mod:OnPluginEnable()
	if self.db.profile.enabled then
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("SPELL_DATA_LOAD_RESULT")

		CAFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
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
	[114018] = true, -- Shroud of Concealment
}
local firedNonCombat = {} -- Bars that we fired that should be hidden on combat.

-- green:  utility and healing cds
-- yellow: targeted cds
-- orange: damaging cds
-- red:    dps cds
-- blue:   everything else
colors = {
	[740] = "green", -- Tranquility
	rebirth = "green", -- Rebirth
	[115310] = "green", -- Revival
	[64843] = "green", -- Divine Hymn
	[265202] = "green", -- Holy Word: Salvation
	[271466] = "green", -- Luminous Barrier
	[64901] = "green", -- Symbol of Hope
	[126135] = "green", -- Lightwell
	[108280] = "green", -- Healing Tide Totem
	[114052] = "green", -- Ascendance
	[322118] = "green", -- Invoke Yu'lon
	[363534] = "green", -- Rewind
	[102342] = "yellow", -- Ironbark
	[116849] = "yellow", -- Life Cocoon
	[47788] = "yellow", -- Guardian Spirit
	[33206] = "yellow", -- Pain Suppression
	[357170] = "yellow", -- Time Dilation
	[48743] = "orange", -- Death Pact
	[53480] = "orange", -- Roar of Sacrifice
	[108968] = "orange", -- Void Shift
	[6940] = "orange", -- Blessing of Sacrifice
	[98008] = "orange", -- Spirit Link Totem
	[2825] = "red", -- Bloodlust
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
		self[key] = icon or nil
		return icon
	end
})
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
	if zoneType == "raid" or zoneType == "party" then
		self:SendMessage("BigWigs_StopBars", self)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Dedicated COMBAT_LOG_EVENT_UNFILTERED handler for efficiency
do
	local FILTER_GROUP = bit_bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID)
	CAFrame:SetScript("OnEvent", function()
		local _, event, _, _, source, srcFlags, _, _, target, dstFlags, _, spellId, spellName = CombatLogGetCurrentEventInfo()
		if not combatLogMap[event] then return end
		if bit_band(bit_bor(srcFlags, dstFlags), FILTER_GROUP) == 0 then return end

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
	local feast = GetSpellName(66477)
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

do
	local hammer = GetSpellName(199109)
	function mod:AutoHammer(_, spellId, nick, spellName)
		message("repair", L.used_cast:format(nick, hammer), nil, spellId)
		bar("repair", 660, nick, hammer, spellId) -- 11min
	end
end

do
	local pylon = GetSpellName(199115)
	function mod:Pylon(_, spellId, nick, spellName)
		message("rebirth", L.used_cast:format(nick, pylon), nil, spellId)
	end
end

function mod:Rebirth(target, spellId, nick, spellName)
	message("rebirth", L.usedon_cast:format(nick, spellName, target), nil, spellId)
end

function mod:Reincarnation(_, spellId, nick, spellName)
	message("rebirth", L.used_cast:format(nick, spellName), nil, spellId)
end

-- Death Knight

function mod:AbominationLimb(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:AntiMagicZone(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

-- XXX Need to check if there's a good way to tell if it hit absorb max vs someone walking out
-- function mod:AntiMagicZoneOff(_, spellId, nick, spellName)
-- 	stopbar(spellName, nick)
-- end

function mod:DancingRuneWeapon(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:DeathPact(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:DeathPactOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

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

function mod:Blur(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

function mod:Darkness(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:FieryBrand(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:Metamorphosis(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:Netherwalk(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:NetherwalkOff(_, _, nick, spellName)
	stopbar(spellName, nick)
end

-- Druid

function mod:Barkskin(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:IncarnationGuardian(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	-- bar(spellId, 30, nick, spellName)
end

function mod:IncarnationTree(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	-- bar(spellId, 30, nick, spellName)
end

function mod:Ironbark(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:Innervate(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:StampedingRoar(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:NaturesVigil(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
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

-- Evoker

function mod:ObsidianScales(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:RenewingBlaze(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:Rewind(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:TimeDilation(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, nick, spellName)
end

function mod:Zephyr(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

-- Hunter

function mod:RoarOfSacrifice(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, nick, spellName)
end

-- Mage

function mod:Portals(_, spellId, nick, spellName)
	message("portal", L.portal_cast:format(nick, spellName), nil, spellId)
	bar("portal", 65, nick, spellName, spellId)
end

function mod:Refreshment(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:MassBarrier(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
end

-- Monk

function mod:DampenHarm(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 10, nick, spellName)
end

function mod:DiffuseMagic(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 6, nick, spellName)
end

function mod:FortifyingBrew(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 15, nick, spellName)
end

function mod:InvokeYulon(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 25, nick, spellName)
end

function mod:LifeCocoon(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 12, target, spellName)
end

function mod:LifeCocoonOff(target, _, _, spellName)
	stopbar(spellName, target)
end

function mod:Revival(_, spellId, nick, spellName)
	message(115310, L.used_cast:format(nick, spellName))
end

function mod:ZenMeditation(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:ZenMeditationOff(_, _, nick, spellName)
	stopbar(spellName, nick) -- removed on melee
end

function mod:TigersLust(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 6, target, spellName)
end

-- Paladin

function mod:ArdentDefender(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end

function mod:AuraMastery(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:BlessingOfFreedom(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, target, spellName)
end

function mod:BlessingOfProtection(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
end

function mod:BlessingOfSacrifice(target, spellId, nick, spellName)
	message(6940, L.usedon_cast:format(nick, spellName, target))
	bar(6940, 12, target, spellName)
end

function mod:BlessingOfSacrificeOff(target, spellId, nick, spellName)
	stopbar(spellName, target)
end

function mod:BlessingOfSpellwarding(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 10, target, spellName)
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

function mod:HolyWordSalvation(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:Lightwell(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:PainSuppression(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
	bar(spellId, 8, target, spellName)
end

function mod:PowerWordBarrier(_, spellId, nick, spellName)
	message(62618, L.used_cast:format(nick, spellName))
	bar(62618, 10, nick, spellName)
end

function mod:LuminousBarrier(_, spellId, nick, spellName)
	message(62618, L.used_cast:format(nick, spellName))
end

function mod:SymbolOfHope(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 5, nick, spellName)
end

function mod:VampiricEmbrace(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName)
end

function mod:VoidShift(target, spellId, nick, spellName)
	message(spellId, L.usedon_cast:format(nick, spellName, target))
end

-- Rogue

function mod:ShroudOfConcealment(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
end

-- Shaman

function mod:Ascendance(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
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

function mod:AncestralGuidance(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:AncestralProtectionTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:EarthElemental(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

function mod:SpiritLinkTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 6, nick, spellName)
end

function mod:EarthenWallTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
end

function mod:HealingTideTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 12, nick, spellName) -- base 10s, 12s at lv52
end

function mod:ManaTideTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 8, nick, spellName)
end

function mod:WindRushTotem(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 15, nick, spellName)
end

-- Warlock

function mod:DemonicGateway(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
end

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

function mod:SpellBlock(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 30, nick, spellName)
end

function mod:RallyingCry(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName))
	bar(spellId, 10, nick, spellName)
end

function mod:ShieldWall(_, spellId, nick, spellName)
	message(spellId, L.used_cast:format(nick, spellName), nick)
	bar(spellId, 8, nick, spellName)
end
