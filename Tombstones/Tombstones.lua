-- Constants
local ADDON_NAME = "Tombstones"
local ADDON_CHANNEL = "Tombstones"
local DEATH_RECORD_WINDOW_SIZE = 5000
local REALM = GetRealmName()
local COLORS = {
    Reset = "\27[0m",
    Red = "\27[31m",
    Green = "\27[32m",
    Yellow = "\27[33m",
    Blue = "\27[34m",
    Magenta = "\27[35m",
    Cyan = "\27[36m",
    White = "\27[37m",
    Grey = "\27[90m",
}
local MAP_TABLE = {
-- Eastern Kingdoms
--[[Alterac Mountains]]     [1416] = {minLevel = 30,    maxLevel = 40,},
--[[Arathi Highlands]]      [1417] = {minLevel = 30,    maxLevel = 40,},
--[[Badlands]]              [1418] = {minLevel = 35,    maxLevel = 45,},
--[[Blasted Lands]]         [1419] = {minLevel = 45,    maxLevel = 55,},
--[[Burning Steppes]]       [1428] = {minLevel = 50,    maxLevel = 58,},
--[[Deadwind Pass]]         [1430] = {minLevel = 55,    maxLevel = 60,},
--[[Dun Morogh]]            [1426] = {minLevel = 1,     maxLevel = 10,},
--[[Duskwood]]              [1431] = {minLevel = 18,    maxLevel = 30,},
--[[Eastern Plaguelands]]   [1423] = {minLevel = 53,    maxLevel = 60,},
--[[Elwynn Forest]]         [1429] = {minLevel = 1,     maxLevel = 10,},
--[[Hillsbrad Foothills]]   [1424] = {minLevel = 20,    maxLevel = 30,},
--[[Ironforge]]             [1455] = {},
--[[Loch Modan]]            [1432] = {minLevel = 10,    maxLevel = 20,},
--[[Redridge Mountains]]    [1433] = {minLevel = 15,    maxLevel = 25,},
--[[Searing Gorge]]         [1427] = {minLevel = 43,    maxLevel = 50,},
--[[Silverpine Forest]]     [1421] = {minLevel = 10,    maxLevel = 20,},
--[[Stormwind City]]        [1453] = {},
--[[Stranglethorn Vale]]    [1434] = {minLevel = 30,    maxLevel = 45,},
--[[Swamp of Sorrows]]      [1435] = {minLevel = 35,    maxLevel = 45,},
--[[The Hinterlands]]       [1425] = {minLevel = 40,    maxLevel = 50,},
--[[Tirisfal Glades]]       [1420] = {minLevel = 1,     maxLevel = 10,},
--[[Undercity]]             [1458] = {},
--[[Westfall]]              [1436] = {minLevel = 10,    maxLevel = 20,},
--[[Western Plaguelands]]   [1422] = {minLevel = 51,    maxLevel = 58,},
--[[Wetlands]]              [1437] = {minLevel = 20,    maxLevel = 30,},

-- Kalimdor
--[[Ashenvale]]             [1440] = {minLevel = 18,    maxLevel = 30,},
--[[Azshara]]               [1447] = {minLevel = 45,    maxLevel = 55,},
--[[Darkshore]]             [1439] = {minLevel = 10,    maxLevel = 20,},
--[[Darnassus]]             [1457] = {},
--[[Desolace]]              [1443] = {minLevel = 30,    maxLevel = 40,},
--[[Durotar]]               [1411] = {minLevel = 1,     maxLevel = 10,},
--[[Dustwallow Marsh]]      [1445] = {minLevel = 35,    maxLevel = 45,},
--[[Felwood]]               [1448] = {minLevel = 48,    maxLevel = 55,},
--[[Feralas]]               [1444] = {minLevel = 40,    maxLevel = 50,},
--[[Moonglade]]             [1450] = {},
--[[Mulgore]]               [1412] = {minLevel = 1,     maxLevel = 10,},
--[[Orgrimmar]]             [1454] = {},
--[[Silithus]]              [1451] = {minLevel = 55,    maxLevel = 60,},
--[[Stonetalon Mountains]]  [1442] = {minLevel = 15,    maxLevel = 27,},
--[[Tanaris]]               [1446] = {minLevel = 40,    maxLevel = 50,},
--[[Teldrassil]]            [1438] = {minLevel = 1,     maxLevel = 10,},
--[[The Barrens]]           [1413] = {minLevel = 10,    maxLevel = 25,},
--[[Thousand Needles]]      [1441] = {minLevel = 25,    maxLevel = 35,},
--[[Thunder Bluff]]         [1456] = {},
--[[Un'Goro Crater]]        [1449] = {minLevel = 48,    maxLevel = 55,},
--[[Winterspring]]          [1452] = {minLevel = 55,    maxLevel = 60,},
}

-- DeathLog Constants
local death_alerts_channel = "hcdeathalertschannel"
local death_alerts_channel_pw = "hcdeathalertschannelpw"
local COMM_COMMAND_DELIM = "$"
local COMM_FIELD_DELIM = "~"
local COMM_NAME = "HCDeathAlerts"
local COMM_COMMANDS = {
  ["BROADCAST_DEATH_PING"] = "1",
  ["BROADCAST_DEATH_PING_CHECKSUM"] = "2",
  ["LAST_WORDS"] = "3",
}
local environment_damage = {
  [-2] = "Drowning",
  [-3] = "Falling",
  [-4] = "Fatigue",
  [-5] = "Fire",
  [-6] = "Lava",
  [-7] = "Slime",
}

-- Variables
local deathRecordsDB
local deathMapIcons = {}
local deathRecordCount = 0
local deadlyNPCs = {}
local deadlyZones = {}
local iconSize = 12
local renderingScheduled = false
local showMarkers = true
local debug = false
local splashFrame
local targetDangerFrame
local targetDangerText
local TOMB_FILTERS = {
  ["ENABLED"] = false,
  ["HAS_LAST_WORDS"] = false,
  ["HAS_LAST_WORDS_SMART"] = false,
  ["CLASS_ID"] = nil,
  ["RACE_ID"] = nil,
  ["LEVEL_THRESH"] = 0,
  ["HOUR_THRESH"] = -1,
}
local classNameToID = {
    ["warrior"] = 1,
    ["paladin"] = 2,
    ["hunter"] = 3,
    ["rogue"] = 4,
    ["priest"] = 5,
    ["shaman"] = 7,
    ["mage"] = 8,
    ["warlock"] = 9,
    ["druid"] = 11,
}
local raceNameToID = {
    ["human"] = 1,
    ["orc"] = 2,
    ["dwarf"] = 3,
    ["night elf"] = 4,
    ["nelf"] = 4,
    ["undead"] = 5,
    ["tauren"] = 6,
    ["gnome"] = 7,
    ["troll"] = 8,
}

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ac = LibStub("AceComm-3.0")
local ls = LibStub("LibSerialize")
local lc = LibStub("LibCompress")
local l64 = LibStub("LibBase64-1.0")

-- Register events
local addon = CreateFrame("Frame")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
addon:RegisterEvent("PLAYER_DEAD")
addon:RegisterEvent("PLAYER_LOGOUT")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("CHAT_MSG_SAY")
addon:RegisterEvent("PLAYER_TARGET_CHANGED")
addon:RegisterEvent("CHAT_MSG_CHANNEL")
addon:RegisterEvent("CHAT_MSG_ADDON") -- Changed from CHAT_MSG_SAY

--Increment deadly caches
local function IncrementDeadlyCounts(marker)
    if marker.source_id then
        if (deadlyNPCs[marker.source_id] == nil) then
            deadlyNPCs[marker.source_id] = 1
        else
            deadlyNPCs[marker.source_id] = deadlyNPCs[marker.source_id] + 1
        end
    end
    if marker.mapID then
        if (deadlyZones[marker.mapID] == nil) then
            deadlyZones[marker.mapID] = 1
        else
            deadlyZones[marker.mapID] = deadlyZones[marker.mapID] + 1  
        end
    end
end

-- Add death marker function
local function AddDeathMarker(mapID, contID, posX, posY, timestamp, user, level, source_id, class_id, race_id)
    if mapID == nil then
       return
    end

    if deathRecordCount >= DEATH_RECORD_WINDOW_SIZE then
        table.remove(deathRecordsDB.deathRecords, 1)
        deathRecordCount = deathRecordCount - 1
    end

    local marker = { realm = REALM, mapID = mapID, contID = contID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id, race_id = race_id }
    table.insert(deathRecordsDB.deathRecords, marker)
    IncrementDeadlyCounts(marker)
    deathRecordCount = deathRecordCount + 1

    printDebug("Death marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
end

local function ImportDeathMarker(realm, mapID, contID, posX, posY, timestamp, user, level, source_id, class_id, race_id, last_words)
    if mapID == nil then
       return
    end

    local marker = { realm = realm, mapID = mapID, contID = contID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id, race_id = race_id, last_words = last_words }
    table.insert(deathRecordsDB.deathRecords, marker)
    IncrementDeadlyCounts(marker)
    deathRecordCount = deathRecordCount + 1
end

local function fetchQuotedPart(str)
    local pattern = "\"(.-)\""
    local quotedPart = string.match(str, pattern)
    if quotedPart then
        return quotedPart
    end
    return nil  -- Quoted part not found
end

function endsWithLevel(str)
    return string.match(str, "has reached level %d?%d?!$") ~= nil
end

function startsWith(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

function stringContains(text, pattern)
    return string.find(text, pattern) ~= nil
end

function fDetection(str)
    return str:match("^%s*[Ff]%s*$") ~= nil
end

function printDebug(msg)
    if debug then
        print(msg)
    end
end

local function ClearDeathMarkers()
    hbdp:RemoveAllWorldMapIcons("Tombstones")
end


local function UpdateWorldMapMarkers()
    local worldMapFrame = WorldMapFrame
    if showMarkers and worldMapFrame and worldMapFrame:IsVisible() then
        -- Fetch filtering parameters
        local filtering = TOMB_FILTERS["ENABLED"]
        local filter_has_words = TOMB_FILTERS["HAS_LAST_WORDS"]
        local filter_has_words_smart = TOMB_FILTERS["HAS_LAST_WORDS_SMART"]
        local filter_class = TOMB_FILTERS["CLASS_ID"]
        local filter_race = TOMB_FILTERS["RACE_ID"]
        local filter_level = TOMB_FILTERS["LEVEL_THRESH"] 
        local filter_hour = TOMB_FILTERS["HOUR_THRESH"]

        -- Number of death markers to render in each batch
        local batchSize = 200
        local currentIndex = #deathRecordsDB.deathRecords
        local currentTime = time()

        local function RenderBatch()
            local startIndex = math.max(currentIndex - batchSize + 1, 1)
            local endIndex = currentIndex
            for i = endIndex, startIndex, -1 do
                local marker = deathRecordsDB.deathRecords[i]
                -- Stop rendering
                if renderingScheduled == false then
                    return
                end

                -- Skip markers that are not in our realm
                if ((marker.realm == nil or REALM == marker.realm) and deathMapIcons[i] == nil) then
                    -- Create the marker on the current continent's map
                    local markerMapButton = CreateFrame("Button", nil, WorldMapButton)
                    markerMapButton:SetSize(iconSize , iconSize) -- Adjust the size of the marker as needed
                    markerMapButton:SetFrameStrata("FULLSCREEN") -- Set the frame strata to ensure it appears above other elements
                    markerMapButton.texture = markerMapButton:CreateTexture(nil, "BACKGROUND")
                    markerMapButton.texture:SetAllPoints(true)
                    if (marker.level == nil) then
                        markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_fiegndead")
                    elseif (marker.level <= 30) then
                        markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_Creature_Cursed_03")
                    elseif (marker.level <= 59) then
                        markerMapButton.texture:SetTexture("Interface\\Icons\\Spell_holy_nullifydisease")
                    else
                        markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_creature_cursed_05")
                    end

                    if (marker.last_words ~= nil) then
                        local borderTexture = markerMapButton:CreateTexture(nil, "OVERLAY")
                        borderTexture:SetAllPoints(markerMapButton)
                        borderTexture:SetTexture("Interface\\Cooldown\\ping4")
                        borderTexture:SetBlendMode("ADD")
                        borderTexture:SetVertexColor(1, 1, 0, 0.7)
                    end

                    -- Set the tooltip text to the name of the player who died
                    markerMapButton:SetScript("OnEnter", function(self)
                        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                        local class_str, _, _ = GetClassInfo(marker.class_id)
                        if (marker.level ~= nil and marker.class_id ~= nil and marker.race_id ~= nil) then
                            local race_info = C_CreatureInfo.GetRaceInfo(marker.race_id) 
                            GameTooltip:SetText(marker.user .. " - " .. race_info.raceName .. " " .. class_str .." - " .. marker.level)
                        elseif (marker.level ~= nil and marker.class_id ~= nil and race_info == nil) then
                            GameTooltip:SetText(marker.user .. " - " .. class_str .." - " .. marker.level)
                        elseif (marker.level ~= nil and marker.class_id == nil) then
                            GameTooltip:SetText(marker.user .. " - ? - " .. marker.level)
                        else
                            GameTooltip:SetText(marker.user .. " -  ? - ?")
                        end
                        if (marker.timestamp > 0) then
                            local date_str = date("%Y-%m-%d %H:%M:%S", marker.timestamp)
                            GameTooltip:AddLine(date_str, .8, .8, .8, true)
                        end
                        if (marker.source_id ~= nil) then
                            local source_id = id_to_npc[marker.source_id]
                            local env_dmg = environment_damage[marker.source_id]
                            if (source_id ~= nil) then 
                                GameTooltip:AddLine("Killed by: " .. source_id, 1, 0, 0, true) 
                            elseif (env_dmg ~= nil) then
                                GameTooltip:AddLine("Died from: " .. env_dmg, 1, 0, 0, true) 
                            end
                        end
                        if (marker.last_words ~= nil) then
                           GameTooltip:AddLine("\""..marker.last_words.."\"", 1, 1, 1)
                        end
                        GameTooltip:Show()
                    end)
                    markerMapButton:SetScript("OnLeave", function(self)
                        GameTooltip:Hide()
                    end)
                    markerMapButton:SetScript("OnMouseDown", function(self, button)
                        local worldMapFrame = WorldMapFrame:GetCanvasContainer()
                        worldMapFrame:OnMouseDown(button)
                    end)
                    markerMapButton:SetScript("OnMouseUp", function(self, button)
                        local worldMapFrame = WorldMapFrame:GetCanvasContainer()
                        worldMapFrame:OnMouseUp(button)
                    end)

                    -- Cache the Map Marker
                    deathMapIcons[i] = markerMapButton
                end

                -- Check if the marker timestamp within the last 12 hours
                local timeDifference = currentTime - marker.timestamp
                local secondsIn24Hours = 12 * 60 * 60 -- 12 hours in seconds
                if (deathMapIcons[i] ~= nil and timeDifference >= secondsIn24Hours) then
                    deathMapIcons[i].texture:SetVertexColor(.4, .4, .4, 0.5)
                end

                -- Check if filters enabled
                -- Add the marker to the current continent's map if passes filter
                if (filtering and deathMapIcons[i] ~= nil) then
                    local allow = true
                    if (filter_has_words == true) then
                        if (marker.last_words == nil) then allow = false end
                        if (allow == true and filter_has_words_smart) then
                            if (allow == true and fDetection(marker.last_words)) then allow = false end
                            if (allow == true and startsWith(marker.last_words, "{rt")) then allow = false end
                            if (allow == true and endsWithLevel(marker.last_words)) then allow = false end
                            if (allow == true and startsWith(marker.last_words, "Our brave ") 
                                and stringContains(marker.last_words, "has died at level") 
                                and not stringContains(marker.last_words, "last words were")) then
                                    allow = false
                            end
                            -- Filter the quoted part of the 'Our brave' last_words
                            if (allow == true and startsWith(marker.last_words, "Our brave ") 
                                and stringContains(marker.last_words, "has died at level")
                                and stringContains(marker.last_words, "last words were")) then
                                    local quotedPart = fetchQuotedPart(marker.last_words)
                                    if (allow == true and fDetection(quotedPart)) then allow = false end
                                    if (allow == true and startsWith(quotedPart, "{rt")) then allow = false end
                                    if (allow == true and endsWithLevel(quotedPart)) then allow = false end
                                    if (allow == true) then
                                        -- Set the tooltip text to allowed quotation
                                        deathMapIcons[i]:SetScript("OnEnter", function(self)
                                            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                                            local class_str = marker.class_id and GetClassInfo(marker.class_id) or nil
                                            if (marker.level ~= nil and marker.class_id ~= nil and marker.race_id ~= nil) then
                                                local race_info = C_CreatureInfo.GetRaceInfo(marker.race_id) 
                                                GameTooltip:SetText(marker.user .. " - " .. race_info.raceName .. " " .. class_str .." - " .. marker.level)
                                            elseif (marker.level ~= nil and marker.class_id ~= nil and race_info == nil) then
                                                GameTooltip:SetText(marker.user .. " - " .. class_str .." - " .. marker.level)
                                            elseif (marker.level ~= nil and marker.class_id == nil) then
                                                GameTooltip:SetText(marker.user .. " - ? - " .. marker.level)
                                            else
                                                GameTooltip:SetText(marker.user .. " -  ? - ?")
                                            end
                                            if (marker.timestamp > 0) then
                                                local date_str = date("%Y-%m-%d %H:%M:%S", marker.timestamp)
                                                GameTooltip:AddLine(date_str, .8, .8, .8, true)
                                            end
                                            if (marker.source_id ~= nil) then
                                                local source_id = id_to_npc[marker.source_id]
                                                local env_dmg = environment_damage[marker.source_id]
                                                if (source_id ~= nil) then 
                                                    GameTooltip:AddLine("Killed by: " .. source_id, 1, 0, 0, true) 
                                                elseif (env_dmg ~= nil) then
                                                    GameTooltip:AddLine("Died from: " .. env_dmg, 1, 0, 0, true) 
                                                end
                                            end
                                            if (marker.last_words ~= nil) then
                                                GameTooltip:AddLine("\""..quotedPart.."\"", 1, 1, 1)
                                            end
                                            GameTooltip:Show()
                                        end)  
                                    end
                            end
                        end
                    end
                    if (allow == true and filter_class ~= nil) then
                        if (marker.class_id == nil or marker.class_id ~= filter_class) then allow = false end
                    end
                    if (allow == true and filter_race ~= nil) then
                        if (marker.race_id == nil or marker.race_id ~= filter_race) then allow = false end
                    end
                    if (allow == true and filter_level > 0) then
                        if (marker.level < filter_level) then allow = false end
                    end
                    if (allow == true and filter_hour >= 0) then
                        if (marker.timestamp <= (currentTime - (filter_hour * 60 * 60))) then allow = false end
                    end
                    if (allow == true) then
                        hbdp:AddWorldMapIconMap("Tombstones", deathMapIcons[i], marker.mapID, marker.posX, marker.posY, HBD_PINS_WORLDMAP_SHOW_WORLD)
                    end
                else
                    if (deathMapIcons[i] ~= nil) then
                        -- Set the tooltip text to the name of the player who died
                        deathMapIcons[i]:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                            local class_str = marker.class_id and GetClassInfo(marker.class_id) or nil
                            if (marker.level ~= nil and marker.class_id ~= nil and marker.race_id ~= nil) then
                                local race_info = C_CreatureInfo.GetRaceInfo(marker.race_id) 
                                GameTooltip:SetText(marker.user .. " - " .. race_info.raceName .. " " .. class_str .." - " .. marker.level)
                            elseif (marker.level ~= nil and marker.class_id ~= nil and race_info == nil) then
                                GameTooltip:SetText(marker.user .. " - " .. class_str .." - " .. marker.level)
                            elseif (marker.level ~= nil and marker.class_id == nil) then
                                GameTooltip:SetText(marker.user .. " - ? - " .. marker.level)
                            else
                                GameTooltip:SetText(marker.user .. " -  ? - ?")
                            end
                            if (marker.timestamp > 0) then
                                local date_str = date("%Y-%m-%d %H:%M:%S", marker.timestamp)
                                GameTooltip:AddLine(date_str, .8, .8, .8, true)
                            end
                            if (marker.source_id ~= nil) then
                                local source_id = id_to_npc[marker.source_id]
                                local env_dmg = environment_damage[marker.source_id]
                                if (source_id ~= nil) then 
                                    GameTooltip:AddLine("Killed by: " .. source_id, 1, 0, 0, true) 
                                elseif (env_dmg ~= nil) then
                                    GameTooltip:AddLine("Died from: " .. env_dmg, 1, 0, 0, true) 
                                end
                            end
                            if (marker.last_words ~= nil) then
                               GameTooltip:AddLine("\""..marker.last_words.."\"", 1, 1, 1)
                            end
                            GameTooltip:Show()
                        end)
                        hbdp:AddWorldMapIconMap("Tombstones", deathMapIcons[i], marker.mapID, marker.posX, marker.posY, HBD_PINS_WORLDMAP_SHOW_WORLD) 
                    end
                end
            end

            currentIndex = startIndex - 1

            if currentIndex >= 1 then
                C_Timer.After(0.05, RenderBatch) -- Delay between batches
            end
        end

        -- Will call itself til completion.
        RenderBatch()

    end
end

-- Hook into WorldMapFrame_OnShow and WorldMapFrame_OnHide functions to update markers
WorldMapFrame:HookScript("OnShow", function()
    renderingScheduled = true
    UpdateWorldMapMarkers()
end)

WorldMapFrame:HookScript("OnHide", function()
    renderingScheduled = false
    ClearDeathMarkers()
end)

local function MakeWorldMapButton()
    local mapButton = CreateFrame("Button", nil, WorldMapFrame, "UIPanelButtonTemplate")
    mapButton:SetSize(20, 20) -- Adjust the size of the button as needed
    mapButton:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 30, -35)
    mapButton:SetNormalTexture("Interface\\Icons\\Ability_fiegndead") -- Set a custom texture for the button
    mapButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square") -- Set the highlight texture for the button
    mapButton:SetScript("OnClick", function()
        showMarkers = not showMarkers
        if showMarkers then
            mapButton:SetNormalTexture("Interface\\Icons\\Ability_fiegndead") -- Set the new icon texture
            GameTooltip:SetText("Hide Tombstones")
            showMarkers = true
            renderingScheduled = true
            UpdateWorldMapMarkers()
        else
            mapButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Map_01") -- Set the default icon texture
            GameTooltip:SetText("Show Tombstones")
            showMarkers = false
            renderingScheduled = false
            ClearDeathMarkers()
        end
    end)
    mapButton:SetScript("OnEnter", function(self)
         GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
         if showMarkers then
            GameTooltip:SetText("Hide Tombstones")
        else
            GameTooltip:SetText("Show Tombstones")
        end
        GameTooltip:Show()
    end)
    mapButton:SetScript("OnLeave", function(self)
       GameTooltip:Hide()
    end)
end

local function SaveDeathRecords()
    _G["deathRecordsDB"] = deathRecordsDB
end

local function LoadDeathRecords()
    deathRecordsDB = _G["deathRecordsDB"]
    if not deathRecordsDB then
        deathRecordsDB = {}
        deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
        deathRecordsDB.deathRecords = {}
        deathRecordsDB.dangerFrameUnlocked = true
        deathRecordsDB.showDanger = true
        deathRecordsDB.showZoneSplash = true
    end
    for _, marker in ipairs(deathRecordsDB.deathRecords) do
        IncrementDeadlyCounts(marker)        
    end
end

local function ClearDeathRecords()
    deathRecordsDB = {}
    deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
    deathRecordsDB.deathRecords = {}
    deathRecordCount = 0
    _G["deathRecordsDB"] = deathRecordsDB
end

function addon:SendMessage(message, distribution, target)
    local prefix = "Tombstones" -- Replace with your add-on's unique prefix
    local messageType = "MESSAGE_TYPE" -- Replace with your desired message type
    local distribution = "PARTY" -- Replace with your desired target (e.g., "PARTY", "RAID", "GUILD")
    self:SendCommMessage(prefix, message, distribution, nil)
    printDebug("Sent message: "..message)
end

function addon:OnCommReceived(prefix, message, distribution, sender)
    local addonPrefix = "Tombstones" -- Replace with your add-on's unique prefix

    -- Check if the received message matches the prefix and message type
    if prefix == addonPrefix and distribution == "PARTY" and sender ~= UnitName("player") then
        -- Process the add-on message
        -- Implement your logic here
        printDebug("Received add-on message: " .. message .. " from " .. sender)
        local command, mapID, contID, posX, posY, timestamp = strsplit("|", message)
            if command == "DEATH" and mapID and posX and posY and timestamp then
                mapID = tonumber(mapID)
                contID = tonumber(contID)
                posX = tonumber(posX)
                posY = tonumber(posY)
                timestamp = tonumber(timestamp)
                if mapID and posX and posY and timestamp then
                    -- Add received death marker
                    AddDeathMarker(mapID, contID, posX, posY, timestamp, sender)
                end
            end
    end
end

function TdeathlogReceiveLastWords(sender, data)
  if data == nil then return end
  local values = {}
  for w in data:gmatch("(.-)~") do table.insert(values, w) end
  local msg = values[2]

  -- Iterate over the death records
  for index, record in ipairs(deathRecordsDB.deathRecords) do
    if record.user == sender then
        record.last_words = msg
        break
    end
  end
end

function TdeathlogReceiveChannelMessage(sender, data)
  if data == nil then return end
  local decoded_player_data = TdecodeMessage(data)
  printDebug("Tombstones decoded a DeathLog death for " .. sender .. "!")
  if sender ~= decoded_player_data["name"] then return end
  local x, y = strsplit(",", decoded_player_data["map_pos"],2)
  AddDeathMarker(tonumber(decoded_player_data["map_id"]), tonumber(decoded_player_data["cont_id"]), tonumber(x), tonumber(y), tonumber(decoded_player_data["date"]), sender, tonumber(decoded_player_data["level"]), tonumber(decoded_player_data["source_id"]), tonumber(decoded_player_data["class_id"]), tonumber(decoded_player_data["race_id"]))
end

function TdecodeMessage(msg)
  local values = {}
  for w in msg:gmatch("(.-)~") do table.insert(values, w) end
  if #values < 9 then
	-- Return something that causes the calling function to return on the isValidEntry check
	local malformed_player_data = TPlayerData( "MalformedData", nil, nil, nil,nil,nil,nil,nil,nil,nil,nil,nil )
	return malformed_player_data
  end
  local date = time()
  local last_words = nil
  local name = values[1]
  local guild = values[2]
  local source_id = tonumber(values[3])
  local race_id = tonumber(values[4])
  local class_id = tonumber(values[5])
  local level = tonumber(values[6])
  local instance_id = tonumber(values[7])
  local map_id = tonumber(values[8])
  local map_pos = values[9]
  if (map_id == nil) then
	-- Return something that causes the calling function to return on the isValidEntry check
	local malformed_player_data = TPlayerData( "MalformedData", nil, nil, nil,nil,nil,nil,nil,nil,nil,nil,nil )
	return malformed_player_data
  end
  local mapInfo = C_Map.GetMapInfo(map_id)
  local cont_id = mapInfo.continentID
  local player_data = TPlayerData(name, guild, source_id, race_id, class_id, level, instance_id, map_id, cont_id, map_pos, date, last_words)
  return player_data
end

function TPlayerData(name, guild, source_id, race_id, class_id, level, instance_id, map_id, cont_id, map_pos, date, last_words)
  return {
    ["name"] = name,
    ["guild"] = guild,
    ["source_id"] = source_id,
    ["race_id"] = race_id,
    ["class_id"] = class_id,
    ["level"] = level,
    ["instance_id"] = instance_id,
    ["map_id"] = map_id,
    ["cont_id"] = cont_id,
    ["map_pos"] = map_pos,
    ["date"] = date,
    ["last_words"] = last_words,
  }
end

-- Function to show the zone splash text
function ShowZoneSplashText()
    if (deathRecordsDB.showZoneSplash == false) then
        return
    end

    if (splashFrame ~= nil) then
      splashFrame:Hide()
      splashFrame = nil
    end

    local zoneName = GetRealZoneText()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    
    local levelRange = MAP_TABLE[currentMapID]
    local minLevel
    local maxLevel
    if levelRange then
        minLevel = levelRange.minLevel
        maxLevel = levelRange.maxLevel
    end

    local deathMarkersInZone = deadlyZones[currentMapID] or 0
    local deathMarkersTotal = #deathRecordsDB.deathRecords
    local deathPercentage = 0.0
    if (deathMarkersTotal > 0) then
        deathPercentage = (deathMarkersInZone / #deathRecordsDB.deathRecords) * 100.0
    end

    -- Create and display the splash text frame
    splashFrame = CreateFrame("Frame", "SplashFrame", UIParent)
    splashFrame:SetSize(400, 200)
    splashFrame:SetPoint("CENTER", 0, 330)

    -- Add a texture
    splashFrame.texture = splashFrame:CreateTexture(nil, "BACKGROUND")
    splashFrame.texture:SetAllPoints(true)

    -- Set-up flavor text and regular info
    splashFrame.flavorText = splashFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    splashFrame.flavorText:SetPoint("CENTER", 0, 105)
    splashFrame.infoText = splashFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    local playerLevel = UnitLevel("player")
    -- Default flavor text
    local splashFlavorText = ""
    local splashInfoText = ""
    splashFrame.flavorText:SetTextColor(1, 1, 1) -- Default white
    splashFrame.infoText:SetTextColor(1, 1, 1) -- White
    if (minLevel == nil or maxLevel == nil) then
        splashFlavorText = "This place seems safe..."
        splashFrame.flavorText:SetTextColor(0, 1, 0) -- Green
        splashInfoText = string.format("There are %d tombstones here.", deathMarkersInZone)
        splashFrame.infoText:SetPoint("CENTER", 0, 120)
    elseif (playerLevel < minLevel) then
        splashFlavorText = "This place is dangerous!"
        splashFrame.flavorText:SetTextColor(1, 0, 0) -- Red
        splashInfoText = string.format("There are %d tombstones here.", deathMarkersInZone)
        splashFrame.infoText:SetPoint("CENTER", 0, 120)
    elseif (playerLevel >= minLevel and playerLevel <= maxLevel) then
        splashFlavorText = "This place is teeming with adventure."
        splashFrame.flavorText:SetTextColor(1, 1, 0) -- Yellow
        splashInfoText = string.format("There are %d tombstones here.\n%.2f%% chance of death.", deathMarkersInZone, deathPercentage)
        splashFrame.infoText:SetPoint("CENTER", 0, 126)
    elseif (playerLevel > maxLevel) then
        splashInfoText = string.format("There are %d tombstones here.", deathMarkersInZone)
        splashFrame.infoText:SetPoint("CENTER", 0, 120)
    end
    splashFrame.infoText:SetText(splashInfoText)
    splashFrame.flavorText:SetText(splashFlavorText)

    -- Apply fade-out animation to the splash frame
    splashFrame.fadeOut = splashFrame:CreateAnimationGroup()
    local fadeIn = splashFrame.fadeOut:CreateAnimation("Alpha")
    fadeIn:SetDuration(.5) -- Adjust the delay duration as desired
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetOrder(1)
    local delay = splashFrame.fadeOut:CreateAnimation("Alpha")
    delay:SetDuration(2.5) -- Adjust the delay duration as desired
    delay:SetFromAlpha(1)
    delay:SetToAlpha(1)
    delay:SetOrder(2)
    local fadeOut = splashFrame.fadeOut:CreateAnimation("Alpha")
    fadeOut:SetDuration(.5) -- Adjust the fade duration as desired
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetOrder(3)
    splashFrame.fadeOut:SetScript("OnFinished", function()
        splashFrame:Hide()
    end)

    splashFrame:Show()
    splashFrame.fadeOut:Play()
end

local function CreateTargetDangerFrame()
    targetDangerFrame = CreateFrame("Frame", "TargetDangerFrame", UIParent)
    targetDangerFrame:SetSize(100, 20)
    local position = deathRecordsDB.targetDangerFramePos
    if (position ~= nil) then
        targetDangerFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", position.x, position.y)
    else
        targetDangerFrame:SetPoint("CENTER", 0, 0)
    end
    targetDangerFrame:SetMovable(true)
    targetDangerFrame:SetClampedToScreen(true)
    targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked)
    targetDangerFrame:RegisterForDrag("LeftButton")
    targetDangerFrame:SetScript("OnDragStart", targetDangerFrame.StartMoving)
    targetDangerFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save the new position
        local x, y = self:GetLeft(), self:GetTop()
        deathRecordsDB.targetDangerFramePos = { x = x, y = y }
    end)

    targetDangerText = targetDangerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetDangerText:SetPoint("CENTER", 0, 0)
    targetDangerText:SetText("")

    -- Create the background texture
    local bgTexture = targetDangerFrame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.5) -- Set the RGB values and alpha (0.5 for 50% transparency)

    targetDangerFrame.text = targetDangerText -- Assign the text object to the frame to keep a reference
end

-- Event handler for UNIT_TARGET event
local function UnitTargetChange()
    local target = "target"
    if (not UnitExists("target") and targetDangerFrame ~= nil) then
        targetDangerFrame:Hide()
    end
    local targetName = UnitName(target)
    local source_id = npc_to_id[targetName]
    local friendly = UnitIsFriend("player", target)

    local playerLevel = UnitLevel("player")
    local targetLevel = UnitLevel("target")

    -- Check if the target is an enemy NPC
    if  (deathRecordsDB.showDanger and source_id ~= nil and not UnitIsPlayer(target) and not friendly and (playerLevel <= targetLevel + 4)) then
        local sourceDeathCount = deadlyNPCs[source_id] or 0
        local currentMapID = C_Map.GetBestMapForUnit("player")
        local deathMarkersTotal = deadlyZones[currentMapID] or 0
        local dangerPercentage = 0.0
        if (deathMarkersTotal > 0) then
            dangerPercentage = (sourceDeathCount / deathMarkersTotal) * 100.0
        end

        if (targetDangerFrame == nil) then
            CreateTargetDangerFrame()
            targetDangerText:SetText(string.format("%.2f%% Deadly", dangerPercentage))
        else
            targetDangerText:SetText(string.format("%.2f%% Deadly", dangerPercentage))
        end

        targetDangerFrame:Show()
        printDebug(string.format("Tombstones has detected enemy danger at: %.2f%%.", dangerPercentage))
    else
        if (targetDangerFrame ~= nil) then
            targetDangerText:SetText("")
            targetDangerFrame:Hide()
        end
    end
end

-- Function to create a frame to display serialized data
local function CreateDataDisplayFrame(data)
    local frame = CreateFrame("Frame", "SerializedDisplayFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", 0, 200)

    -- Create the background texture
    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.8) -- Set the RGB values and alpha

    -- Create a scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "SerializedDisplayFrameScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 8)

    -- Create a text area inside the scroll frame
    local textArea = CreateFrame("EditBox", "SerializedDisplayFrameText", scrollFrame)
    textArea:SetMultiLine(true)
    textArea:SetMaxLetters(0)
    textArea:SetAutoFocus(false)
    textArea:SetFontObject("ChatFontNormal")
    textArea:SetWidth(scrollFrame:GetWidth() - 20)
    textArea:SetHeight(scrollFrame:GetHeight() - 20)
    textArea:SetText(data)
    textArea:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    -- Set the scroll frame's content
    scrollFrame:SetScrollChild(textArea)
    -- Highlight the text
    textArea:HighlightText()

    -- Add a close button
    local closeButton = CreateFrame("Button", "SerializedDisplayFrameCloseButton", frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
        frame = nil
    end)

    frame:Show()
end

local function IsImportRecordDuplicate(importedRecord)
    local isDuplicate = false

    -- Check if the imported record is "close enough" to existing record
    for index, existingRecord in ipairs(deathRecordsDB.deathRecords) do
        if existingRecord.mapID == importedRecord.mapID and
            existingRecord.posX == importedRecord.posX and
            existingRecord.posY == importedRecord.posY and
            math.floor(existingRecord.timestamp / 3600) == math.floor(importedRecord.timestamp / 3600) and
            existingRecord.user == importedRecord.user and
            existingRecord.level == importedRecord.level and
            existingRecord.last_words == importedRecord.last_words then
            -- It is possible for this to CREATE duplicates with different last_words
            -- Those can be fixed with "/ts dedupe" for now
            -- The record is a duplicate, break search 
            isDuplicate = true
            break
        end
    end

    return isDuplicate
end

local function DedupeImportDeathRecords(importedRecords)
    -- Create a table to store the deduplicated records
    local dedupedDeathRecords = {}
    -- Iterate over the imported records
    for _, importedRecord in ipairs(importedRecords) do
        local isDuplicate = IsImportRecordDuplicate(importedRecord)
        -- If the record is not a duplicate, add it to the deduplicated records
        if not isDuplicate then
            table.insert(dedupedDeathRecords, importedRecord)
        end
    end
    -- Return the deduplicated records
    return dedupedDeathRecords
end

local function DeduplicateDeathRecords()
    local deduplicatedRecords = {}
    local duplicatesFound = 0
    local replacementsMade = 0
    local totalRecords = #deathRecordsDB.deathRecords

    for i = 1, totalRecords do
        local currentRecord = deathRecordsDB.deathRecords[i]
        local isDuplicate = false

        for j = i + 1, totalRecords do
            local compareRecord = deathRecordsDB.deathRecords[j]

            if currentRecord.mapID == compareRecord.mapID and
                currentRecord.posX == compareRecord.posX and
                currentRecord.posY == compareRecord.posY and
                math.floor(currentRecord.timestamp / 3600) == math.floor(compareRecord.timestamp / 3600) and
                currentRecord.user == compareRecord.user and
                currentRecord.level == compareRecord.level 
                then
                
                isDuplicate = true
                duplicatesFound = duplicatesFound + 1

                -- We prefer the duplicate with more info
                if (currentRecord.last_words ~= nil and compareRecord.last_words == nil) then
                    table.insert(deduplicatedRecords, currentRecord)
                    compareRecord.skip = true
                    replacementsMade = replacementsMade + 1
                    printDebug("Replacing entry for "..currentRecord.user..".")
                elseif (currentRecord.last_words == nil and compareRecord.last_words ~= nil) then
                    table.insert(deduplicatedRecords, compareRecord)
                    replacementsMade = replacementsMade + 1
                    printDebug("Replacing entry for "..compareRecord.user..".")
                end
                -- Break loop on duplicate found
                break
            end
        end

        -- If the record is purely unique and NOT one that was compared previously for replacement
        if (not isDuplicate) then
            if (currentRecord.skip == nil or currentRecord.skip == false) then
                table.insert(deduplicatedRecords, currentRecord)
            end
        else
            printDebug("Removing duplicate entry for "..currentRecord.user..".")
        end
    end
    -- Save the records back into SV
    deathRecordsDB.deathRecords = deduplicatedRecords
    -- Re-initialize deadly count caches
    if(duplicatesFound > 0 or replacementsMade > 0) then
        deadlyZones = {}
        deadlyNPCs = {}
        for _, marker in ipairs(deathRecordsDB.deathRecords) do
            IncrementDeadlyCounts(marker)        
        end
    end

    print("Original Tombstones size was " .. tostring(totalRecords) .. ", now is: " .. tostring(#deduplicatedRecords) .. ".")
    print("Tombstones found " .. tostring(duplicatesFound) .. " duplicate entries.")
    print("Tombstones replaced " .. tostring(replacementsMade) .. " duplicate entries with their more updated ones.")
end

local function CreateDataImportFrame()
    local frame = CreateFrame("Frame", "TombstonesImportFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", 0, 200)

    -- Create the background texture
    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.8) -- Set the RGB values and alpha

    -- Create a scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "TombstonesImportScrollFrameEditBox", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

    local editBox = CreateFrame("EditBox", "TombstonesImportFrameEditBox", scrollFrame)
    editBox:SetWidth(scrollFrame:GetWidth() - 20)
    editBox:SetHeight(scrollFrame:GetHeight() - 20)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetEnabled(true)
    editBox:SetText("Paste import string here...")
    editBox:SetFontObject("GameFontNormal")
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    editBox:SetScript("OnEditFocusGained", function(self) self:SetText("") end) -- Clear the default text when the EditBox receives focus

    -- Set the scroll frame's content
    scrollFrame:SetScrollChild(editBox)

    -- Add a close button
    local closeButton = CreateFrame("Button", "SerializedDisplayFrameCloseButton", frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
        frame = nil
    end)

    local importButton = CreateFrame("Button", "TombstonesImportButton", frame, "UIPanelButtonTemplate")
    importButton:SetSize(80, 22)
    importButton:SetPoint("BOTTOM", 0, 10)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        local encodedData = editBox:GetText()
        printDebug("Input data size is: " .. tostring(string.len(encodedData)))
        -- Decode the encoded data from Base64
        local decodedData = l64:decode(encodedData)
        printDebug("Base64 decoded data size is: " .. tostring(string.len(decodedData)))
        -- Decompress the decoded data
        local decompressedData = lc:Decompress(decodedData)
        printDebug("Decompressed data size is: " .. tostring(string.len(decompressedData)))
        -- Deserialize the decompressed data
        local success, importedDeathRecords = ls:Deserialize(decompressedData)
        -- Example: Print the received data to the chat frame
        printDebug("Deserialization sucess: " .. tostring(success))
        local numImportRecords = #importedDeathRecords
        printDebug("Imported records size is: " .. tostring(numImportRecords))
        cleanImportRecords = DedupeImportDeathRecords(importedDeathRecords)
        local numNewRecords = #cleanImportRecords
        printDebug("Deduped records size is: " .. tostring(numNewRecords))
        for _, marker in ipairs(cleanImportRecords) do
            ImportDeathMarker(marker.realm, marker.mapID, marker.contID, marker.posX, marker.posY, marker.timestamp, marker.user, marker.level, marker.source_id, marker.class_id, marker.race_id, marker.last_words)
        end
        print("Tombstones imported in " .. tostring(numNewRecords) .. " new de-dupe'd records out of " .. tostring(numImportRecords) .. ".")
        frame:Hide()
        frame = nil
    end)

    frame:Show()
end

-- Define slash commands
SLASH_TOMBSTONES1 = "/tombstones"
SLASH_TOMBSTONES2 = "/ts"

-- Slash command handler function
local function SlashCommandHandler(msg)
    local command, args = strsplit(" ", msg, 2) -- Split the command and arguments
    -- Process the command and perform the desired actions
    if command == "show" then
        -- Show death markers
        showMarkers = true
    elseif command == "hide" then
        showMarkers = false
        ClearDeathMarkers()
    elseif command == "clear" then
        -- Clear all death records
        ClearDeathRecords()
    elseif command == "dedupe" then
        -- Dedupe existing death records
        DeduplicateDeathRecords()
        ClearDeathMarkers()
        UpdateWorldMapMarkers()
    elseif command == "debug" then
        debug = not debug
        print("Tombstones debug mode is: ".. tostring(debug))
    elseif command == "icon_size" then
        iconSize = tonumber(args)
    elseif command == "info" then
        print("Tombstones saw " .. deathRecordCount .. " records this session.")
        print("Tombstones has " .. #deathRecordsDB.deathRecords.. " records in total.")
    elseif command == "export" then
        local serializedData = ls:Serialize(deathRecordsDB.deathRecords)
        printDebug("Serialized data size is: " .. tostring(string.len(serializedData)))
        -- Compress the serialized data
        local compressedData = lc:Compress(serializedData)
        printDebug("Compressed data size is: " .. tostring(string.len(compressedData)))
        -- Encode the compressed data using Base64
        local encodedData = l64:encode(compressedData)
        printDebug("Base64 data size is: " .. tostring(string.len(encodedData)))
        CreateDataDisplayFrame(encodedData)
    elseif command == "import" then
        CreateDataImportFrame()
    elseif command == "zone" then
        if args == "show" then
            deathRecordsDB.showZoneSplash = true
        elseif args == "hide" then
            deathRecordsDB.showZoneSplash = false
            if (splashFrame ~= nil) then
              splashFrame:Hide()
              splashFrame = nil
            end
        end
    elseif command == "danger" then
        local argsArray = {}
        if args then
           for word in string.gmatch(args, "%S+") do
               table.insert(argsArray, word)
           end
        end
        if argsArray[1] == "show" then
            deathRecordsDB.showDanger = true
            UnitTargetChange()
        elseif argsArray[1] == "hide" then
            deathRecordsDB.showDanger = false
            if (targetDangerFrame ~= nil) then
                targetDangerFrame:Hide()
                targetDangerFrame = nil
            end
            if (targetDangerText ~= nil) then
                targetDangerText = nil
            end
        elseif argsArray[1] == "lock" then
            deathRecordsDB.dangerFrameUnlocked = false
            if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
        elseif argsArray[1] == "unlock" then
            deathRecordsDB.dangerFrameUnlocked = true
            if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
        end
    elseif command == "filter" then
        local argsArray = {}
        if args then
           for word in string.gmatch(args, "%S+") do
               table.insert(argsArray, word)
           end
        end
        if argsArray[1] == "info" then
            print("Tombstones filtering enabled: " .. tostring(TOMB_FILTERS["ENABLED"]))
            print("Tombstones 'Last Words' filtering enabled: " .. tostring(TOMB_FILTERS["HAS_LAST_WORDS"]) .. " (smart mode: " .. tostring(TOMB_FILTERS["HAS_LAST_WORDS_SMART"]) .. ")")
            print("Tombstones 'ClassID' filtering on: " .. tostring(TOMB_FILTERS["CLASS_ID"]))
            print("Tombstones 'RaceID' filtering on: " .. tostring(TOMB_FILTERS["RACE_ID"]))
            print("Tombstones 'Level Thresh' filtering on: " .. tostring(TOMB_FILTERS["LEVEL_THRESH"]))
            print("Tombstones 'Hour Thresh' filtering on: " .. tostring(TOMB_FILTERS["HOUR_THRESH"]))
            return
        elseif argsArray[1] == "off" then
            TOMB_FILTERS["ENABLED"] = false
            TOMB_FILTERS["HAS_LAST_WORDS"] = false
            TOMB_FILTERS["HAS_LAST_WORDS_SMART"] = false
            TOMB_FILTERS["CLASS_ID"] = nil
            TOMB_FILTERS["RACE_ID"] = nil
            TOMB_FILTERS["LEVEL_THRESH"] = 0
            TOMB_FILTERS["HOUR_THRESH"] = -1
        elseif argsArray[1] == "last_words" then
            TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HAS_LAST_WORDS_SMART"] = false
            TOMB_FILTERS["HAS_LAST_WORDS"] = true
        elseif argsArray[1] == "last_words_smart" then
            TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HAS_LAST_WORDS"] = true
            TOMB_FILTERS["HAS_LAST_WORDS_SMART"] = true
        elseif argsArray[1] == "level" then
            TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["LEVEL_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "hours" then
            TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HOUR_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "class" then
            local className = argsArray[2]
            if (className ~= nil) then
                TOMB_FILTERS["ENABLED"] = true
                TOMB_FILTERS["CLASS_ID"] = classNameToID[className]
            else
                print("Tombstones ERROR : Class not found.")
                print("Tombstones WARN : Try 'paladin','priest','warrior','rogue','mage','warlock','druid','shaman','hunter'.")
            end
        elseif argsArray[1] == "race" then
            local raceName = argsArray[2]
            if (raceName ~= nil) then
                TOMB_FILTERS["ENABLED"] = true
                TOMB_FILTERS["RACE_ID"] = raceNameToID[raceName]
            else
                print("Tombstones ERROR : Race not found.")
                print("Tombstones WARN : Try 'human','dwarf','gnome','night elf | nelf','orc','troll','undead','tauren'.")
            end
        end
        ClearDeathMarkers()
        UpdateWorldMapMarkers()
    else
        -- Display command usage information
        print("Usage: /tombstones or /ts [show | hide | export | import | clear | dedupe | info | debug | icon_size {#SIZE}]")
        print("Usage: /tombstones or /ts [filter (info | off | last_words | last_words_smart | hours {#HOURS} | level {#LEVEL} | class {CLASS} | race {RACE})]")
        print("Usage: /tombstones or /ts [danger (show | hide | lock | unlock)]")
        print("Usage: /tombstones or /ts [zone (show | hide )]")
    end
end

-- Register slash command handler
SlashCmdList["TOMBSTONES"] = SlashCommandHandler

-- Initialize
addon:SetScript("OnEvent", function(self, event, ...)
  local arg = { ... }
  if event == "ADDON_LOADED" then
    local addonName = ...
    if addonName == ADDON_NAME then
      printDebug("Tombstones is loading...")

      MakeWorldMapButton()
      LoadDeathRecords()
 
      ac:Embed(self)
      self:RegisterComm("Tombstones")
      print("Tombstones loaded successfully!")
    end
  elseif event == "PLAYER_DEAD" then
    print("Death detected!")
    -- Handle player death event
    local mapID = C_Map.GetBestMapForUnit("player")
    local contID = C_Map.GetMapInfo(mapID).parentMapID
    local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
    local posX, posY = playerPosition:GetXY()
    local timestamp = time()

    if mapID and contID and posX and posY and timestamp then
      printDebug("Death detected. Making mark...")
      AddDeathMarker(mapID, contID, posX, posY, timestamp, UnitName("player"))
      self:SendMessage("DEATH|"..mapID.."|"..contID.."|"..posX.."|"..posY.."|"..timestamp)
    end
  elseif event == "PLAYER_LOGOUT" then
    -- Handle player logout event
    SaveDeathRecords()
  elseif event == "ZONE_CHANGED_NEW_AREA" then
    ShowZoneSplashText()
  elseif event == "PLAYER_TARGET_CHANGED" then
    UnitTargetChange()
  elseif event == "CHAT_MSG_SAY" then
        local message = ...
        if (debug and message == "dead") then
            local mapID = C_Map.GetBestMapForUnit("player")
            local contID = C_Map.GetMapInfo(mapID).parentMapID
            local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
            local posX, posY = playerPosition:GetXY()
            local truncatedX = tonumber(string.format("%.5f", posX))
            local truncatedY = tonumber(string.format("%.5f", posY))
            local timestamp = time()
            AddDeathMarker(mapID, contID, truncatedX, truncatedY, timestamp, UnitName("player"))
            self:SendMessage("DEATH|"..mapID.."|"..contID.."|"..truncatedX.."|"..truncatedY.."|"..timestamp)
        end
  elseif event == "CHAT_MSG_CHANNEL" then
    local _, channel_name = string.split(" ", arg[4])
    if channel_name ~= death_alerts_channel then return end
    local command, msg = string.split(COMM_COMMAND_DELIM, arg[1])

    if command == COMM_COMMANDS["BROADCAST_DEATH_PING"] then
      local player_name_short, _ = string.split("-", arg[2])
      printDebug("Receiving DeathLog death ping for " .. player_name_short .. ".")
      TdeathlogReceiveChannelMessage(player_name_short, msg)
    end

    if command == COMM_COMMANDS["LAST_WORDS"] then
      local player_name_short, _ = string.split("-", arg[2])
      printDebug("Receiving DeathLog last_words ping for " .. player_name_short .. ".")
      TdeathlogReceiveLastWords(player_name_short, msg)
    end
  end
end)
