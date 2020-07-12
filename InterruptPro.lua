-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local AddonName, InterruptPro = ... -- TODO - Necessary?

_G["InterruptPro"] = InterruptPro -- TODO - Necessary?

----------------------------
-- Cached Local Variables --
----------------------------

-- Lua API
-- TODO

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
		enemyGuide = {
			expansionIndex = 1,
			dungeonIndex = 1,
			enemyIndex = 1
		},
		dataScraper = {
			enabled = false
		},
		devMode = {
			enabled = false,
			debugLevel = 1
		}
	}
}

function InterruptPro:GetDB()
	return db
end

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

			InterruptPro:Debug("DevMode enabled")
		end
	end
end

-------------
-- Utility --
-------------

local AddonColor = "|c000070de"

function InterruptPro:Print(text)
	print(AddonColor .. "InterruptPro:|r " .. text)
end

-----------
-- Debug --
-----------

function InterruptPro:ToggleDevMode()
	db.devMode.enabled = not db.devMode.enabled
	if db.devMode.enabled then
		InterruptPro:Print("DevMode enabled")
	else
		InterruptPro:Print("DevMode disabled")
	end
end

function InterruptPro:Debug(text, level)
	if not db.devMode.enabled then return end
	if (level or 1) <= db.devMode.debugLevel then
		InterruptPro:Print("DEV - " .. text)
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
		elseif cmd == "ds" then
			InterruptPro:ToggleDataScraper()
		else -- Default case
			InterruptPro.EnemyGuide:Show()
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
				InterruptPro.EnemyGuide:Show()
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
			InterruptPro:Print("To re-enable the Interrupt Pro Minimap button type '/ip minimap'")
		else
			Icon:Show("InterruptPro")
		end
	end
end

-------------------
-- Miscellaneous --
-------------------

function InterruptPro:ToggleDataScraper()
	db.dataScraper.enable = not db.dataScraper.enable
	if db.dataScraper.enable then
		DataScraper:Init()
		InterruptPro:Print("Data Scrapper enabled")
	else
		DataScraper:Quit()
		InterruptPro:Print("Data scrapper disabled")
	end
end
