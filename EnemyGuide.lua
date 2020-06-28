
-----------------
-- Enemy Guide --
-----------------

local InterruptPro = InterruptPro
local db

InterruptPro.dungeonEnemies = {}

local expansions = {
	[1] = "Battle for Azeroth",
	[2] = "Shadowlands"
}

local bfaDungeons = {
	[1] = "Atal'Dazar",
	[2] = "Freehold",
	[3] = "King's Rest",
	[4] = "Shrine of the Storm",
	[5] = "Siege of Boralus",
	[6] = "Temple of Sethraliss",
	[7] = "The MOTHERLODE!!",
	[8] = "The Underrot",
	[9] = "Tol Dagor",
	[10] = "Waycrest Manor",
	[11] = "Operation: Mechagon - Junkyard",
	[12] = "Operation: Mechagon - Workshop"
}

local shadowlandsDungeons = {
	[1] = "De Other Side",
	[2] = "Halls of Atonement",
	[3] = "Mists of Tirna Scithe",
	[4] = "Plaguefall",
	[5] = "The Necrotic Wake",
	[6] = "Theater of Pain",
	[7] = "Sanguine Depths",
	[8] = "Spires of Ascension"
}

local dungeons = {
	[1] = bfaDungeons,
	[2] = shadowlandsDungeons
}

function InterruptPro:CreateEnemyGuide()
	db = InterruptPro:GetDB()

	local AceGUI = LibStub("AceGUI-3.0")

	-- Create window
	local window = AceGUI:Create("Window")
	window:SetTitle("Interrupt Pro - Enemy Guide")
	window:SetLayout("List")
	window:EnableResize(false)

	-- TODO - Organize into two separate columns
	-- Left Column
	-- local leftContainer = AceGUI:Create("DropdownGroup")
	-- leftContainer:SetGroupList(bfaDungeons)
	-- window:AddChild(leftContainer)
	-- local leftContainer = AceGUI:Create("SimpleGroup")
	-- leftContainer:SetLayout("List")
	-- leftContainer:setWidth(window:GetWidth() / 2)
	-- leftContainer:setHeight(window:GetHeight())
	-- window:AddChild(leftContainer)

	-- Right Column

	-- Create expansion dropdown
	local expansionDropdown = AceGUI:Create("Dropdown")
	expansionDropdown:SetLabel("Expansion:")
	expansionDropdown:SetList(expansions)
	expansionDropdown:SetValue(db.enemyGuide.expansionIndex)
	expansionDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
		InterruptPro:OnExpansionChanged(key)
	end)
	window:AddChild(expansionDropdown)

	-- Create dungeon dropdown
	local dungeonDropdown = AceGUI:Create("Dropdown")
	window.dungeonDropdown = dungeonDropdown
	dungeonDropdown:SetLabel("Dungeon:")
	dungeonDropdown:SetList(bfaDungeons)
	dungeonDropdown:SetValue(db.enemyGuide.dungeonIndex)
	dungeonDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
		InterruptPro:OnDungeonChanged(key)
	end)
	window:AddChild(dungeonDropdown)

	-- Create enemy downdown
	local enemyDropdown = AceGUI:Create("Dropdown")
	window.enemyDropdown = enemyDropdown
	enemyDropdown:SetLabel("Enemy:")
	enemyDropdown:SetList(atalDazarEnemies) -- TODO - Load this correctly
	enemyDropdown:SetValue(db.enemyGuide.enemyIndex)
	enemyDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
		InterruptPro:OnEnemyChanged(key)
	end)
	window:AddChild(enemyDropdown)

	-- Create enemy model frame
	local enemyModel = CreateFrame("PlayerModel", nil, window.frame, "ModelWithCOntrolsTemplate")
	window.enemyModel = enemyModel
	-- TODO - Review values
	enemyModel:SetFrameLevel(15)
	enemyModel:SetSize(window.frame:GetWidth()/2, window.frame:GetHeight()/2)
	enemyModel:SetScript("OnEnter", nil)
	enemyModel:Show()
	enemyModel:ClearAllPoints()
	enemyModel:SetPoint("BOTTOM", window.frame, "BOTTOM", 0, 10)
	enemyModel:SetDisplayInfo(79568)
	enemyModel:ResetModel()

	InterruptPro:Debug("Constructed EnemyGuide frame")

	return window
end

local lastExpansionIndex, lastDungeonIndex, lastEnemyIndex
function InterruptPro:UpdateEnemyGuide(expansionIndex, dungeonIndex, enemyIndex)
	local window = InterruptPro.EnemyGuide

	window.dungeonDropdown:SetList(dungeons[expansionIndex])
	window.dungeonDropdown:SetValue(dungeonIndex)

	local enemies = {}
	for indx,info in ipairs(InterruptPro.dungeonEnemies[dungeonIndex]) do
		tinsert(enemies, indx, info.name)
	end

	window.enemyDropdown:SetList(enemies)
	window.enemyDropdown:SetValue(enemyIndex)

	-- Data
	local enemyData = InterruptPro.dungeonEnemies[dungeonIndex][enemyIndex]
	window.enemyModel:SetDisplayInfo(enemyData.displayId)
	window.enemyModel:ResetModel()
end

function InterruptPro:ShowEnemyGuide()
	InterruptPro.EnemyGuide = InterruptPro.EnemyGuide or InterruptPro:CreateEnemyGuide()
	InterruptPro:UpdateEnemyGuide(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
	InterruptPro.EnemyGuide:Show()
end

function InterruptPro:OnExpansionChanged(expansionIndex)
	db.enemyGuide.expansionIndex = expansionIndex
	db.enemyGuide.dungeonIndex = 1
	db.enemyGuide.enemyIndex = 1
	InterruptPro:UpdateEnemyGuide(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end

function InterruptPro:OnDungeonChanged(dungeonIndex)
	db.enemyGuide.dungeonIndex = dungeonIndex
	db.enemyGuide.enemyIndex = 1
	InterruptPro:UpdateEnemyGuide(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end

function InterruptPro:OnEnemyChanged(enemyIndex)
	db.enemyGuide.enemyIndex = enemyIndex
	InterruptPro:UpdateEnemyGuide(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end
