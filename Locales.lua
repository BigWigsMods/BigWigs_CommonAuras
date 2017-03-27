
local _, L = ...

L.commonAuras = "Common Auras"
L.outOfCombat = "Out of combat"
L.group = "Group"
L.self = "Self"
L.healer = "Healer"
L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
L.barBackground = "Bar background"
L.barText = "Bar text"
L.barTextShadow = "Bar text shadow"
L.codex = "Codex"

L.usedon_cast = "%s: %s on %s"
L.used_cast = "%s used %s"
L.ritual_cast = "%s wants to perform a %s!"

L.portal = "Portal"
L.portal_desc = "Toggle showing mage portals."
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
	L.commonAuras = "Häufige Auren"
	L.outOfCombat = "Außerhalb des Kampfes"
	L.group = "Gruppe"
	L.self = "Eigene"
	L.healer = "Heiler"
	L.TANK_desc = "Manche Fähigkeiten sind nur für Tanks wichtig. Setze diese Funktion, um nur Nachrichten und Leisten für Spieler zu sehen, deren zugewiesene Rolle auf Tank gesetzt ist."
	L.barBackground = "Leistenhintergrund"
	L.barText = "Leistentext"
	L.barTextShadow = "Leistentext-Schatten"
	L.codex = "Kodex"

	L.usedon_cast = "%s: %s auf %s"
	L.used_cast = "%s verwendete %s"
	L.ritual_cast = "%s will %s stellen!"

	L.portal = "Portal"
	L.portal_desc = "Zeigt die Portale der Magier an."
	L.portal_cast = "%s öffnete ein %s!"
	L.portal_bar = "%s (%s)"

	L.repair = "Reparaturbots"
	L.repair_desc = "Zeigt Reparaturbots an, sobald sie aufgestellt wurden."

	L.feasts = "Festmähler"
	L.feast_cast = "%s hat %s zubereitet!"
	L.feast_desc = "Zeigt Festmähler an, sobald sie zubereitet wurden."

	L.rebirth = "Battle-Rezz"
	L.rebirth_desc = "Zeigt ausgeführte Battle-Rezzes an."
elseif locale == "esES" or locale == "esMX" then
	L.commonAuras = "Auras Comunes"
	--L.outOfCombat = "Out of combat"
	--L.group = "Group"
	--L.self = "Self"
	--L.healer = "Healer"
	--L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	--L.barBackground = "Bar background"
	--L.barText = "Bar text"
	--L.barTextShadow = "Bar text shadow"
	L.codex = "Códice"

	--L.usedon_cast = "%s: %s on %s"
	--L.used_cast = "%s used %s"
	--L.ritual_cast = "%s wants to perform a %s!"

	--L.portal = "Portal"
	--L.portal_desc = "Toggle showing of mage portals."
	--L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination
	--L.portal_bar = "%s (%s)"

	--L.repair = "Repair Bot"
	--L.repair_desc = "Toggle showing when repair bots are available."

	--L.feast = "Feasts"
	--L.feast_desc = "Toggle showing when feasts get prepared."
	--L.feast_cast = "%s prepared a %s!"

	--L.rebirth = "Rebirth"
	--L.rebirth_desc = "Toggle showing combat resurrections."
elseif locale == "frFR" then
	L.commonAuras = "Auras Habituelles"
	L.outOfCombat = "Hors de combat"
	L.group = "Groupe"
	L.self = "Soi-même"
	L.healer = "Soigneur"
	L.TANK_desc = "Certaines techniques ne sont importantes que pour les tanks. Utilisez cette option pour ne voir que les messages et les barres des joueurs qui ont tank comme rôle assigné."
	L.barBackground = "Arrière-plan de la barre"
	L.barText = "Texte de la barre"
	L.barTextShadow = "Ombre du texte de la barre"
	L.codex = "Codex"

	L.usedon_cast = "%s : %s sur %s"
	L.used_cast = "%s a utilisé %s"
	L.ritual_cast = "%s souhaite effectuer un %s !"

	L.portal = "Portail"
	L.portal_desc = "Prévient quand un mage ouvre un portail."
	L.portal_cast = "%s a ouvert un %s !"
	L.portal_bar = "%s (%s)"

	L.repair = "Robot réparateur"
	L.repair_desc = "Prévient quand un robot réparateur est déployé."

	L.feasts = "Festins"
	L.feast_desc = "Prévient quand des festins sont préparés."
	L.feast_cast = "%s a préparé un %s !"

	L.rebirth = "Renaissance"
	L.rebirth_desc = "Prévient quand des ressurections en combat sont effectuées."
elseif locale == "itIT" then
	L.commonAuras = "Auree Comuni"
	L.outOfCombat = "Fuori dal Combattimento"
	--L.group = "Group"
	--L.self = "Self"
	--L.healer = "Healer"
	--L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	--L.barBackground = "Bar background"
	--L.barText = "Bar text"
	--L.barTextShadow = "Bar text shadow"
	L.codex = "Codice"

	L.usedon_cast = "%s : %s su %s"
	L.used_cast = "%s ha usato %s"
	L.ritual_cast = "%s sta evocando %s!"

	L.portal = "Portale"
	L.portal_desc = "Avvisa quando un mago apre un portale."
	L.portal_cast = "%s ha aperto un %s !"
	L.portal_bar = "%s (%s)"

	L.repair = "Robot di Riparazione"
	L.repair_desc = "Avvisa quando un Robot di Riparazione è disponibile."

	L.feasts = "Banchetti"
	L.feast_desc = "Avvisa quando vengono messi a disposizione dei Banchetti."
	L.feast_cast = "%s ha preparato un %s !"

	L.rebirth = "Resurrezione"
	L.rebirth_desc = "Avvisa quando viene utilizzata un'abilità di Resurrezione in combattimento."
elseif locale == "koKR" then
	L.commonAuras = "공통 버프"
	L.outOfCombat = "전투 중"
	--L.group = "Group"
	--L.self = "Self"
	--L.healer = "Healer"
	--L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	--L.barBackground = "Bar background"
	--L.barText = "Bar text"
	--L.barTextShadow = "Bar text shadow"
	L.codex = "전서"

	L.usedon_cast = "%1$s: %3$s에게 %2$s"
	L.used_cast = "%s: %s 사용"
	L.ritual_cast = "%s - %s 사용!"

	L.portal = "차원문"
	L.portal_desc = "마법사의 차원문 표시합니다."
	L.portal_cast = "%s - %s 차원문!"
	L.portal_bar = "%s (%s)"

	L.repair = "수리 로봇"
	L.repair_desc = "수리 로봇 사용시 표시합니다."

	L.feasts = "음식"
	L.feast_desc = "전체 음식 사용시 표시합니다."
	L.feast_cast = "%s - %s 사용!"

	--L.rebirth = "Rebirth"
	--L.rebirth_desc = "Toggle showing combat resurrections."
elseif locale == "ptBR" then
	L.commonAuras = "Auras Comunes"
	--L.outOfCombat = "Out of combat"
	--L.group = "Group"
	--L.self = "Self"
	--L.healer = "Healer"
	--L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	--L.barBackground = "Bar background"
	--L.barText = "Bar text"
	--L.barTextShadow = "Bar text shadow"
	L.codex = "Códice"

	--L.usedon_cast = "%s: %s on %s"
	--L.used_cast = "%s used %s"
	--L.ritual_cast = "%s wants to perform a %s!"

	--L.portal = "Portal"
	--L.portal_desc = "Toggle showing of mage portals."
	--L.portal_cast = "%s opened a %s!" --Player opened a Portal: Destination
	--L.portal_bar = "%s (%s)"

	--L.repair = "Repair Bot"
	--L.repair_desc = "Toggle showing when repair bots are available."

	--L.feast = "Feasts"
	--L.feast_desc = "Toggle showing when feasts get prepared."
	--L.feast_cast = "%s prepared a %s!"

	--L.rebirth = "Rebirth"
	--L.rebirth_desc = "Toggle showing combat resurrections."
elseif locale == "ruRU" then
	L.commonAuras = "Основные ауры"
	L.outOfCombat = "Вне боя"
	L.group = "Группа"
	L.self = "Игрок"
	L.healer = "Лекарь"
	L.TANK_desc = "Некоторые способности важны лишь для танков. Активируйте эту опцию для того чтобы видеть оповещения и полосы лишь для игроков у которых установлена роль танка."
	L.barBackground = "Фон полосы"
	L.barText = "Текст полосы"
	L.barTextShadow = "Тень текста полосы"
	L.codex = "Кодекс"

	L.usedon_cast = "%s: %s на %s"
	L.used_cast = "%s использовал %s"
	L.ritual_cast = "%s хочет совершить %s!"

	L.portal = "Портал"
	L.portal_desc = "Вкл/выкл оповещения об открытии портала магов."
	L.portal_cast = "%s открыл %s!"
	L.portal_bar = "%s (%s)"

	L.repair = "Ремонтный робот"
	L.repair_desc = "Вкл/выкл оповещения о доступности ремонтного робота."

	L.feasts = "Пиршества"
	L.feast_desc = "Вкл/выкл оповещения о приготовленных пиршествах."
	L.feast_cast = "%s приготовил %s!"

	L.rebirth = "Возрождение"
	L.rebirth_desc = "Показать/Скрыть воскрешения в бою."
elseif locale == "zhCN" then
	L.commonAuras = "普通光环"
	L.outOfCombat = "脱离战斗"
	L.group = "队伍"
	L.self = "自身"
	L.healer = "治疗"
	L.TANK_desc = "一些技能对坦克重要。设置此选项将只能看到对于选为坦克职能的信息和计时条。"
	L.barBackground = "计时条背景"
	L.barText = "计时条文本"
	L.barTextShadow = "计时条文本阴影"
	L.codex = "圣典"

	L.usedon_cast = "%s：%s于%s"
	L.used_cast = " %s使用：%s"
	L.ritual_cast = "%s想进行一次%s！"

	L.portal = "传送门"
	L.portal_desc = "打开或关闭显示法师传送门时提示。"
	L.portal_cast = "%s施放了一道%s！"
	L.portal_bar = "%s (%s)"

	L.repair = "修理机器人"
	L.repair_desc = "打开或关闭显示修理机器人可用时提示。"

	L.feasts = "盛宴"
	L.feast_desc = "打开或关闭显示盛宴可用时提示。"
	L.feast_cast = "%s准备了一顿%s！"

	L.rebirth = "复生"
	L.rebirth_desc = "打开或关闭显示战斗复活提示。"
elseif locale == "zhTW" then
	L.commonAuras = "共同光環"
	L.outOfCombat = "脫離戰鬥"
	--L.group = "Group"
	--L.self = "Self"
	--L.healer = "Healer"
	--L.TANK_desc = "Some abilities are only important for tanks. Set this option to only see messages and bars for players with their assigned role set to Tank."
	--L.barBackground = "Bar background"
	--L.barText = "Bar text"
	--L.barTextShadow = "Bar text shadow"
	L.codex = "寧神聖"

	L.usedon_cast = "%s：%s於%s"
	L.used_cast = " %s使用：%s"
	--L.ritual_cast = "%s wants to perform a %s!"

	L.portal = "傳送門"
	L.portal_desc = "打開或關閉顯示法師傳送門時提示。"
	L.portal_cast = "%s施放了一道%s！"
	L.portal_bar = "%s (%s)"

	L.repair = "修理機器人"
	L.repair_desc = "打開或關閉顯示修理機器人可用時提示。"

	--L.feast = "Feasts"
	--L.feast_desc = "Toggle showing when feasts get prepared."
	--L.feast_cast = "%s prepared a %s!"

	--L.rebirth = "Rebirth"
	--L.rebirth_desc = "Toggle showing combat resurrections."
end

