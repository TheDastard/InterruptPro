-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local AddonName, InterruptPro = ... -- TODO - Necessary?

_G["InterruptPro"] = InterruptPro -- TODO - Necessary?

----------------------------
-- Cached Local Variables --
----------------------------

-- Lua API
-- string:lower()

-- WoW API

-- InterruptPro
local dataBroker

---------------
-- Libraries --
---------------

local LibStub = _G["LibStub"] -- TODO - Necessary?

--------------
-- Database --
--------------

local db

local defaultSavedVars = {
	global = {
		minimap = {
			hide = false,
			lock = false
		},
		devMode = {
			enabled = false,
			debugLevel = 1
		}
	}
}

do
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, ...)
		InterruptPro[event](self, ...)
	end)

	function InterruptPro.ADDON_LOADED(self, addon)
		if addon == "InterruptPro" then
			local AceDB = LibStub("AceDB-3.0")
			local Icon = LibStub("LibDBIcon-1.0")
			db = AceDB:New("InterruptProDB", defaultSavedVars).global
			Icon:Register("InterruptPro", dataBroker, db.minimap)
		end
	end
end

-----------
-- Debug --
-----------

function InterruptPro:ToggleDevMode()
	db.devMode.enabled = not db.devMode.enabled
	if db.devMode.enabled then
		print("InterruptPro - DevMode enabled")
	else
		print("InterruptPro - DevMode disabled")
	end
end

function InterruptPro:Debug(text, level)
	if not db.devMode.enabled then return end
	if (level or 1) <= db.devMode.debugLevel then
		print("InterruptPro: " .. text)
	end
end

--------------------
-- Slash Commands --
--------------------

do
	SLASH_INTERRUPTPRO1 = "/ip"

	function SlashCmdList.INTERRUPTPRO(msg)
		local cmd = msg:lower()
		if cmd == "minimap" then
			InterruptPro:ToggleMinimapButton()
		elseif cmd == "dev" then
			InterruptPro:ToggleDevMode()
		else -- Default case
			InterruptPro:ShowEnemyGuide()
		end
	end
end

--------------------
-- Minimap Button --
--------------------

do
	local Icon = LibStub("LibDBIcon-1.0")
	local LDB = LibStub("LibDataBroker-1.1")

	if LDB then
		dataBroker = LDB:NewDataObject("InterruptPro", {
			type = "data source",
			label = "InterruptPro",
			text = "Interrupt Pro",
			icon = "Interface\\AddOns\\InterruptPro\\textures\\dast"
		})

		function dataBroker.OnClick(self, button)
			if button == "LeftButton" then
				InterruptPro:ShowEnemyGuide()
			end
			if button == "RightButton" then
				InterruptPro:LockMinmapButton()
			end
			if button == "MiddleButton" then
				InterruptPro:ToggleMinimapButton()
			end
		end

		function dataBroker.OnTooltipShow(tooltip)
			tooltip:AddLine("Interrupt Pro")
			tooltip:AddLine("Left-click - Open Enemy Guide")
			tooltip:AddLine("Right-click - Lock Minimap button")
			tooltip:AddLine("Middle-click - Hide Minimap button")
		end
	end

	function InterruptPro:LockMinmapButton()
		db.minimap.lock = not db.minimap.lock
		if db.minimap.lock then
			Icon:Lock("InterruptPro")
		else
			Icon:Unlock("InterruptPro")
		end
	end

	function InterruptPro:ToggleMinimapButton()
		db.minimap.hide = not db.minimap.hide
		if db.minimap.hide then
			Icon:Hide("InterruptPro")
			print("To re-enable the Interrupt Pro Minimap button type '/ip minimap'")
		else
			Icon:Show("InterruptPro")
		end
	end
end

-----------------
-- Enemy Guide --
-----------------

-- TODO - Move to separate Lua file
local bfaDungeons = {
	"Atal'Dazar",
	"Freehold",
	"King's Rest",
	"Mechagon - Junkyard",
	"Mechagon - Workshop",
	"Shrine of the Storm",
	"Siege of Boralus",
	"Temple of Sethraliss",
	"The MOTHERLODE!!",
	"The Underrot",
	"Tol Dagor",
	"Waycrest Manor"
}

-- TODO - Move to separate Lua file
local atalDazarEnemies = {
	"Dazar'ai Honor Guard",
	"Dazar'ai Juggernaut",
	"Dazar'ai Confessor",
	"Dazar'ai Augur",
	"Dazar'ai Colossus",
	"Gilded Priestess",
	"Priestess Alun'za",
	"Shadowblade Stalker",
	"Reanimated Honor Guard",
	"Reanimated Totem",
	"Zanchuli Witch-Doctor",
	"Shieldbearer of Zul",
	"Vol'kaal",
	"Toxic Saurid",
	"Feasting Skyscreamer",
	"Rezan",
	"Dinomancer Kish'o",
	"T'lonja",
	"Monzumi",
	"Yazma"
}

function InterruptPro:CreateEnemyGuide()
	local AceGUI = LibStub("AceGUI-3.0")

	-- Create a container frame
	local window = AceGUI:Create("Window")
	window:SetTitle("Interrupt Pro")
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

	-- Create dungeon dropdown list
	local dungeonDropdown = AceGUI:Create("Dropdown")
	dungeonDropdown:SetLabel("Dungeon:")
	dungeonDropdown:SetList(bfaDungeons)
	window:AddChild(dungeonDropdown)

	-- Create enemy downdown list
	local enemiesDropdown = AceGUI:Create("Dropdown")
	enemiesDropdown:SetLabel("Enemy:")
	enemiesDropdown:SetList(atalDazarEnemies)
	window:AddChild(enemiesDropdown)

	InterruptPro:Debug("Creating new EnemyGuide frame - This should only be called once!")

	return window
end

function InterruptPro:ShowEnemyGuide()
	InterruptPro.EnemyGuide = InterruptPro.EnemyGuide or InterruptPro:CreateEnemyGuide()
	InterruptPro.EnemyGuide:Show()
end
