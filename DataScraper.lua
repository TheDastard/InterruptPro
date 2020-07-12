-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local InterruptPro = InterruptPro
local db

-- Caches local variables
local strsplit = strsplit

------------------
-- Data Scraper --
------------------

InterruptPro.DataScraper = {}
local DataScraper = InterruptPro.DataScraper

local trackedEvents = {
	["SPELL_CAST_START"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REMOVED"] = true
}

function DataScraper:Init()
	db = InterruptPro:GetDB()

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, event, ...)
		DataScraper[event](self, ...)
	end)
end

function DataScraper:Quit()
	-- TODO
end

function DataScraper:COMBAT_LOG_EVENT_UNFILTERED(self, ...)
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlag, sourceRaidFlags,
		destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()

	if trackedEvents[event] then
		local unitType, _, serverID, instanceID, zoneID, ID, spawnUID = strsplit("-", sourceGUID)

		-- Enemy scraping
		-- TODO

		-- Ability scraping
		-- TODO

		-- Immunity scraping
		-- TODO

		InterruptPro:Debug(sourceName .. " - " .. spellName .. "[" .. spellId .. "]")
	end
end
