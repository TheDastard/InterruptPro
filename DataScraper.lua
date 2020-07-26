-- Made by: Dastard - Skullcrusher US - <Death and Destruction> --

local IP = InterruptPro
local db

-- Cached local variables
local strsplit = strsplit

------------------
-- Data Scraper --
------------------

local DS = {}
IP.DataScraper = DS

local trackedEvents = {
	["SPELL_CAST_START"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REMOVED"] = true
}

function DS:Init()
	db = IP:GetDB()

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, event, ...)
		DS[event](self, ...)
	end)
end

function DS:Quit()
	-- TODO
end

function DS:COMBAT_LOG_EVENT_UNFILTERED(self, ...)
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

		IP:Debug(sourceName .. " - " .. spellName .. "[" .. spellId .. "]")
	end
end
