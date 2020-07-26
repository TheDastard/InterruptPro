-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local AddonName = ...

local IP = {}
_G[AddonName] = IP

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

local LibStub = LibStub

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

function IP:GetDB()
	return db
end

do
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, ...)
		IP[event](self, ...)
	end)

	function IP.ADDON_LOADED(self, addon)
		if addon == "InterruptPro" then
			local AceDB = LibStub("AceDB-3.0")
			local Icon = LibStub("LibDBIcon-1.0")
			db = AceDB:New("InterruptProDB", defaultSavedVars).global
			Icon:Register("InterruptPro", dataBroker, db.minimap)

			IP:Debug("DevMode enabled")
		end
	end
end

-------------
-- Utility --
-------------

local addonColor = "|c000070de"

function IP:Print(text)
	print(addonColor .. "InterruptPro:|r " .. text)
end

-----------
-- Debug --
-----------

function IP:ToggleDevMode()
	db.devMode.enabled = not db.devMode.enabled
	if db.devMode.enabled then
		IP:Print("DevMode enabled")
	else
		IP:Print("DevMode disabled")
	end
end

function IP:Debug(text, level)
	if not db.devMode.enabled then return end
	if (level or 1) <= db.devMode.debugLevel then
		IP:Print("DEV - " .. text)
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
			IP:ToggleMinimapButton()
		elseif cmd == "dev" then
			IP:ToggleDevMode()
		elseif cmd == "ds" then
			IP:ToggleDataScraper()
		else -- Default case
			IP.EnemyGuide:Show()
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
				IP.EnemyGuide:Show()
			end
			if button == "RightButton" then
				IP:LockMinmapButton()
			end
			if button == "MiddleButton" then
				IP:ToggleMinimapButton()
			end
		end

		function dataBroker.OnTooltipShow(tooltip)
			tooltip:AddLine("Interrupt Pro")
			tooltip:AddLine(" ")
			tooltip:AddLine("Left-click - Open Enemy Guide")
			tooltip:AddLine("Right-click - Lock Minimap button")
			tooltip:AddLine("Middle-click - Hide Minimap button")
		end
	end

	function IP:LockMinmapButton()
		db.minimap.lock = not db.minimap.lock
		if db.minimap.lock then
			Icon:Lock("InterruptPro")
		else
			Icon:Unlock("InterruptPro")
		end
	end

	function IP:ToggleMinimapButton()
		db.minimap.hide = not db.minimap.hide
		if db.minimap.hide then
			Icon:Hide("InterruptPro")
			IP:Print("To re-enable the Interrupt Pro Minimap button type '/ip minimap'")
		else
			Icon:Show("InterruptPro")
		end
	end
end

-------------------
-- Miscellaneous --
-------------------

function IP:ToggleDataScraper()
	db.dataScraper.enable = not db.dataScraper.enable
	if db.dataScraper.enable then
		DataScraper:Init()
		IP:Print("Data Scrapper enabled")
	else
		DataScraper:Quit()
		IP:Print("Data scrapper disabled")
	end
end
