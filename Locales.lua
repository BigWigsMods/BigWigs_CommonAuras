-- update at http://www.wowace.com/addons/big-wigs_common-auras/localization/

local n, L = ...

L["Common Auras"] = "Common Auras"
L["Out of combat"] = "Out of combat"
L["Group"] = "Group"
L["Self"] = "Self"
L["Healer"] = "Healer"
L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
L["Messages"] = "Messages"
L["Colors"] = "Colors"
L["Normal bar"] = "Normal bar"
L["Emphasized bar"] = "Emphasized bar"
L["Bar background"] = "Bar background"
L["Bar text"] = "Bar text"
L["Bar text shadow"] = "Bar text shadow"

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

local locale = GetLocale()
if locale == "deDE" then
--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esES" or locale == "esMX" then
--@localization(locale="esES", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "frFR" then
--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "itIT" then
--@localization(locale="itIT", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="ignore")@
end

