-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local InterruptPro = InterruptPro
local db

-- Caches local variables
-- TODO

-----------------
-- Enemy Guide --
-----------------

InterruptPro.EnemyGuide = {}
local EnemyGuide = InterruptPro.EnemyGuide

InterruptPro.dungeons = {}
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

InterruptPro.dungeons = {
	[1] = bfaDungeons,
	[2] = shadowlandsDungeons
}

function EnemyGuide:Create()
	db = InterruptPro:GetDB()

	local AceGUI = LibStub("AceGUI-3.0")

	-- TODO - Review all of these values

	-- Create main window
	local window = AceGUI:Create("Window")
	window:SetTitle("Interrupt Pro - Enemy Guide")
	window:SetLayout("Flow")
	window:EnableResize(false)

	-- Left Column
	do
		-- Create left column
		local leftContainer = AceGUI:Create("SimpleGroup")
		window.leftContainer = leftContainer
		leftContainer:SetLayout("List")
		leftContainer:SetWidth(window.frame:GetWidth() / 2)
		leftContainer:SetHeight(window.frame:GetHeight())
		window:AddChild(leftContainer)

		-- Create dropdown group
		local dropdownContainer = AceGUI:Create("InlineGroup")
		window.dropdownContainer = dropdownContainer
		--dropdownContainer.frame:SetBackdropColor(1, 1, 1, 0)
		dropdownContainer:SetWidth(leftContainer.frame:GetWidth() - 20)
		dropdownContainer:SetHeight(200)
		dropdownContainer:SetLayout("List")
		leftContainer:AddChild(dropdownContainer)

		-- Create expansion dropdown
		local expansionDropdown = AceGUI:Create("Dropdown")
		window.expansionDropdown = expansionDropdown
		expansionDropdown:SetLabel("Expansion:")
		expansionDropdown:SetList(expansions)
		expansionDropdown:SetValue(db.enemyGuide.expansionIndex)
		--expansionDropdown:SetWidth(dropdownContainer.frame:GetWidth() - 25)
		expansionDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
			InterruptPro:OnExpansionChanged(key)
		end)
		dropdownContainer:AddChild(expansionDropdown)

		-- Create dungeon dropdown
		local dungeonDropdown = AceGUI:Create("Dropdown")
		window.dungeonDropdown = dungeonDropdown
		dungeonDropdown:SetLabel("Dungeon:")
		--dungeonDropdown:SetWidth(dropdownContainer.frame:GetWidth() - 25)
		dungeonDropdown:SetCallback("OnValueChanged", function(widget, callbackN1ame, key)
			InterruptPro:OnDungeonChanged(key)
		end)
		dropdownContainer:AddChild(dungeonDropdown)

		-- Create enemy downdown
		local enemyDropdown = AceGUI:Create("Dropdown")
		window.enemyDropdown = enemyDropdown
		enemyDropdown:SetLabel("Enemy:")
		--enemyDropdown:SetWidth(dropdownContainer.frame:GetWidth() - 25)
		enemyDropdown:SetCallback("OnValueChanged", function(widget, callbackName, key)
			InterruptPro:OnEnemyChanged(key)
		end)
		dropdownContainer:AddChild(enemyDropdown)
	end

	-- Right Column
	do
		-- Create right column
		local rightContainer = AceGUI:Create("SimpleGroup")
		window.rightContainer = rightContainer
		rightContainer:SetLayout("List")
		rightContainer:SetWidth(window.frame:GetWidth() / 2)
		rightContainer:SetHeight(window.frame:GetHeight())
		window:AddChild(rightContainer)

		-- Create enemy model group
		local enemyModelContainer = AceGUI:Create("InlineGroup")
		window.enemyModelContainer = enemyModelContainer
		--dropdownContainer.frame:SetBackdropColor(1, 1, 1, 0)
		enemyModelContainer:SetWidth(rightContainer.frame:GetWidth() - 20)
		enemyModelContainer:SetHeight(250)
		enemyModelContainer:SetLayout("List")
		rightContainer:AddChild(enemyModelContainer)

		-- Create enemy model
		local enemyModel = CreateFrame("PlayerModel", nil, enemyModelContainer.frame, "ModelWithCOntrolsTemplate")
		window.enemyModel = enemyModel
		-- TODO - Especially review these values
		enemyModel:SetFrameLevel(15)
		enemyModel:SetSize(enemyModelContainer.frame:GetWidth() - 20, 245)
		enemyModel:SetScript("OnEnter", nil)
		enemyModel:Show()
		enemyModel:Hide()
		enemyModel:ClearAllPoints()
		enemyModel:SetPoint("BOTTOM", enemyModelContainer.frame, "BOTTOM", 0, 10)
		enemyModel:SetDisplayInfo(79568)
		enemyModel:ResetModel()
	end

	InterruptPro:Debug("Constructed EnemyGuide frame")

	return window
end

local lastExpansionIndex, lastDungeonIndex, lastEnemyIndex
function EnemyGuide:Update(expansionIndex, dungeonIndex, enemyIndex)
	local window = EnemyGuide.Frame

	window.dungeonDropdown:SetList(InterruptPro.dungeons[expansionIndex])
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

function EnemyGuide:Show()
	EnemyGuide.Frame = EnemyGuide.Frame or EnemyGuide:Create()
	EnemyGuide:Update(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
	EnemyGuide.Frame:Show()
end

function InterruptPro:OnExpansionChanged(expansionIndex)
	db.enemyGuide.expansionIndex = expansionIndex
	db.enemyGuide.dungeonIndex = 1
	db.enemyGuide.enemyIndex = 1
	EnemyGuide:Update(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end

function InterruptPro:OnDungeonChanged(dungeonIndex)
	db.enemyGuide.dungeonIndex = dungeonIndex
	db.enemyGuide.enemyIndex = 1
	EnemyGuide:Update(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end

function InterruptPro:OnEnemyChanged(enemyIndex)
	db.enemyGuide.enemyIndex = enemyIndex
	EnemyGuide:Update(db.enemyGuide.expansionIndex,
		db.enemyGuide.dungeonIndex, db.enemyGuide.enemyIndex)
end
