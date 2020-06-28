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
		enemyGuide = {
			expansionIndex = 1,
			dungeonIndex = 1,
			enemyIndex = 1
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

-----------
-- Debug --
-----------

local debugColor = "|c000070de"

function InterruptPro:ToggleDevMode()
	db.devMode.enabled = not db.devMode.enabled
	if db.devMode.enabled then
		InterruptPro:Debug("DevMode enabled")
	else
		-- InteruptPro:Debug() is disabled so have to manually color text
		print(debugColor ..  "InterruptPro:|r DevMode disabled")
	end
end

function InterruptPro:Debug(text, level)
	if not db.devMode.enabled then return end
	if (level or 1) <= db.devMode.debugLevel then
		print(debugColor .. "InterruptPro:|r " .. text)
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
