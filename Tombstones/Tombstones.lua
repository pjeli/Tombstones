-- Constants
local ADDON_NAME = "Tombstones"
local TS_COMM_NAME = "TSKarmaChannel"
local tombstones_channel = "tsbroadcastchannel"
local tombstones_channel_pw = "tsbroadcastchannelpw"
local CTL = _G.ChatThrottleLib
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
local deathVisitCount = 0
local deadlyNPCs = {}
local deadlyZones = {}
local deadlyZoneLvlSums = {}
local visitingZoneCache = {}
local iconSize = 12
local maxRenderCount = 3000
local renderWarned = false
local renderingScheduled = false
local renderCycleCount = 0
local debug = false
local trace = false
local isPlayerMoving = false
local movementUpdateInterval = 0.2 -- Update interval in seconds
local movementTimer = 0
local lastProximityWarning = 0
local lastClosestMarker
local optionsFrame
local mapButton
local splashFrame
local tombstoneFrame
local dialogueBox
local targetDangerFrame
local targetDangerText
local glowFrame
local currentViewingMapID
local subTooltip
local TOMB_FILTERS = {
  --["ENABLED"] = false,
  ["HAS_LAST_WORDS"] = false,
  ["CLASS_ID"] = nil,
  ["RACE_ID"] = nil,
  ["LEVEL_THRESH"] = 0,
  ["HOUR_THRESH"] = 0,
  ["REALMS"] = true,
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

-- Message/Karma Variables
local throttlePlayer = {}
local karmaMessageBuffer = {}
local karmaBatchSize = 100
local karmaBatchInterval = 3

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ac = LibStub("AceComm-3.0")
local ls = LibStub("LibSerialize")
local lc = LibStub("LibCompress")
local ld = LibStub("LibDeflate")
local l64 = LibStub("LibBase64-1.0")

-- Register events
local addon = CreateFrame("Frame")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
addon:RegisterEvent("PLAYER_LOGOUT")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_STARTED_MOVING")
addon:RegisterEvent("PLAYER_STOPPED_MOVING")
addon:RegisterEvent("PLAYER_TARGET_CHANGED")
addon:RegisterEvent("CHAT_MSG_CHANNEL")


function fetchQuotedPart(str)
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

function endsWithResurrected(str)
    return string.find(str, "^%w+ has resurrected!$") ~= nil
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

function roundNearestHalf(value)
    return math.floor(value * 2 + 0.5) / 2
end

function GetDistanceBetweenPositions(playerX, playerY, playerInstance, markerX, markerY, markerInstance)
    local deltaX = markerX - playerX
    local deltaY = markerY - playerY
    local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
    return distance
end

function printDebug(msg)
    if debug then
        print(msg)
    end
end

function printTrace(msg)
    if trace then
        print(msg)
    end
end

local function SaveDeathRecords()
    deathRecordsDB.TOMB_FILTERS = TOMB_FILTERS
    _G["deathRecordsDB"] = deathRecordsDB
end

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
        if(visitingZoneCache[marker.mapID] == nil) then
            visitingZoneCache[marker.mapID] = { marker }
        else
            table.insert(visitingZoneCache[marker.mapID], marker)
        end
        if (deadlyZones[marker.mapID] == nil) then
            deadlyZones[marker.mapID] = 1
        else
            deadlyZones[marker.mapID] = deadlyZones[marker.mapID] + 1  
        end
    end
    if marker.level then
        if (deadlyZoneLvlSums[marker.mapID] == nil) then
            deadlyZoneLvlSums[marker.mapID] = marker.level
        else
            deadlyZoneLvlSums[marker.mapID] = deadlyZoneLvlSums[marker.mapID] + marker.level
        end
    end
    if marker.visited and marker.visited == true then
        deathVisitCount = deathVisitCount + 1
    end
end

local function InitializeDeadlyCounts()
    deadlyZones = {}
    deadlyNPCs = {}
    deadlyZoneLvlSums = {}
    visitingZoneCache = {}
    deathVisitCount = 0
    for _, marker in ipairs(deathRecordsDB.deathRecords) do
        IncrementDeadlyCounts(marker)        
    end
end

-- Has no 'F' detector. Prefer to have visit show F.
local function LastWordsSmartParser(last_words)
    if(last_words == nil or lastWords == "") then
        return nil
    end

    local allow = true

    if (startsWith(last_words, "{rt")) then allow = false end
    if (allow == true and endsWithLevel(last_words)) then allow = false end
    if (allow == true and endsWithResurrected(last_words)) then allow = false end
    if (allow == true and startsWith(last_words, "Our brave ") 
        and stringContains(last_words, "has died at level") 
        and not stringContains(last_words, "last words were")) then
            allow = false
    end
    -- Filter the quoted part of the 'Our brave' last_words
    if (allow == true and startsWith(last_words, "Our brave ") 
        and stringContains(last_words, "has died at level")
        and stringContains(last_words, "last words were")) then
            local quotedPart = fetchQuotedPart(last_words)
            if (allow == true and startsWith(quotedPart, "{rt")) then allow = false end
            if (allow == true and endsWithLevel(quotedPart)) then allow = false end
            if (allow == true and endsWithResurrected(quotedPart)) then allow = false end
            if (allow == true) then return quotedPart end
    end
    if (allow == true) then
        return last_words
    else
        return nil
    end
end

local function TdeathlogJoinChannel()
    if _G["deathlogJoinChannel"] ~= nil then
        return
    else
        local channel_num = GetChannelName(death_alerts_channel)
        if channel_num == 0 then
            JoinChannelByName(death_alerts_channel, death_alerts_channel_pw)
            local channel_num = GetChannelName(death_alerts_channel)
                if channel_num == 0 then
                print("Failed to join death alerts channel via Tombstones.")
            else
                print("Successfully joined deathlog channel via Tombstones.")
            end
            for i = 1, 10 do
                if _G['ChatFrame'..i] then
                    ChatFrame_RemoveChannel(_G['ChatFrame'..i], death_alerts_channel)
                end
            end
        else
                print("Successfully joined deathlog channel via Tombstones.")
        end
    end
end

local function TombstonesJoinChannel()
    local channel_num = GetChannelName(tombstones_channel)
    if channel_num == 0 then
        JoinChannelByName(tombstones_channel, tombstones_channel_pw)
        local channel_num = GetChannelName(tombstones_channel)
            if channel_num == 0 then
            print("Failed to join Tombstones channel.")
        else
            printDebug("Successfully Tombstones channel.")
        end
        for i = 1, 10 do
            if _G['ChatFrame'..i] then
                ChatFrame_RemoveChannel(_G['ChatFrame'..i], tombstones_channel)
            end
        end
    else
        printDebug("Successfully Tombstones channel.")
    end
end

local function LoadDeathRecords()
    deathRecordsDB = _G["deathRecordsDB"]
    if not deathRecordsDB then
        deathRecordsDB = {}
        deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
        deathRecordsDB.deathRecords = {}
        deathRecordsDB.showMarkers = true
        deathRecordsDB.dangerFrameUnlocked = true
        deathRecordsDB.showDanger = true
        deathRecordsDB.showZoneSplash = true
        deathRecordsDB.visiting = true
        deathRecordsDB.hide = false
        deathRecordsDB.minimapDB = {}
        deathRecordsDB.minimapDB.minimapPos = 204
        deathRecordsDB.minimapDB.hide = false
    end
    if (deathRecordsDB.showMarkers == nil) then
        deathRecordsDB.showMarkers = true
    end
    if (deathRecordsDB.visiting == nil) then
       deathRecordsDB.visiting = true 
    end
    if (deathRecordsDB.showZoneSplash == nil) then
       deathRecordsDB.showZoneSplash = true 
    end
    if (deathRecordsDB.showDanger == nil) then
       deathRecordsDB.showDanger = true 
    end
    if (deathRecordsDB.dangerFrameUnlocked == nil) then
       deathRecordsDB.dangerFrameUnlocked = true 
    end
    if (deathRecordsDB.minimapDB == nil) then
        deathRecordsDB.minimapDB = {}
    end
    if (deathRecordsDB.minimapDB.minimapPos == nil) then
        deathRecordsDB.minimapDB.minimapPos = 204
    end
    if (deathRecordsDB.minimapDB.hide == nil) then
        deathRecordsDB.minimapDB.hide = false
    end
    if (deathRecordsDB.TOMB_FILTERS ~= nil) then
        TOMB_FILTERS = deathRecordsDB.TOMB_FILTERS
    end
    for _, marker in ipairs(deathRecordsDB.deathRecords) do
        IncrementDeadlyCounts(marker)
        marker.last_words = LastWordsSmartParser(marker.last_words)     
    end
end

local function ClearDeathRecords()
    deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
    deathRecordsDB.deathRecords = {}
    deathRecordCount = 0
    _G["deathRecordsDB"] = deathRecordsDB
    InitializeDeadlyCounts()
end

local function UnvisitAllMarkers()
    local totalRecords = #deathRecordsDB.deathRecords
    local totalIcons = #deathMapIcons
    for i = 1, totalRecords do
        deathRecordsDB.deathRecords[i].visited = nil
    end
    for i = 1, totalIcons do
        if (deathMapIcons[i] ~= nil and deathMapIcons[i].checkmarkTexture ~= nil) then
            deathMapIcons[i].checkmarkTexture:Hide()
            deathMapIcons[i].checkmarkTexture = nil
        end
    end
    deathVisitCount = 0
end

local function PruneDeathRecords()
    local prunedRecords = {}
    local recordsToPrune = 0
    local totalRecords = #deathRecordsDB.deathRecords

    for i = 1, totalRecords do
        local marker = deathRecordsDB.deathRecords[i]
        local allow = IsMarkerAllowedByFilters(marker)

        if (allow == true) then
            table.insert(prunedRecords, marker)
        else
            recordsToPrune = recordsToPrune + 1
        end
    end

    deathRecordsDB.deathRecords = prunedRecords
    return recordsToPrune
end

-- "force" should be used if the underlying DeathRecords have been altered
local function ClearDeathMarkers(clearMM)
    hbdp:RemoveAllWorldMapIcons("Tombstones")
    local totalIcons = #deathMapIcons
    printDebug("Clearing " .. tostring(totalIcons) .. " map buttons.")
    for i = 1, totalIcons do
        if (deathMapIcons[i] ~= nil) then
            deathMapIcons[i]:Hide()
            deathMapIcons[i] = nil
        end
    end
    if (clearMM) then
        hbdp:RemoveAllMinimapIcons("TombstonesMM")
        lastClosestMarker = nil
    end
end

-- Define the confirmation dialog
StaticPopupDialogs["TOMBSTONES_CLEAR_CONFIRMATION"] = {
    text = "Are you sure you want to delete all your tombstones?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        ClearDeathRecords()
        ClearDeathMarkers(true)
        print("Tombstones have been cleared.")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function IsMarkerAllowedByFilters(marker)
    if (marker == nil) then
        return false
    end

    local currentTime = time()
    local allow = true

    -- Fetch filtering parameters
    local filter_realms = TOMB_FILTERS["REALMS"]
    local filter_has_words = TOMB_FILTERS["HAS_LAST_WORDS"]
    local filter_class = TOMB_FILTERS["CLASS_ID"]
    local filter_race = TOMB_FILTERS["RACE_ID"]
    local filter_level = TOMB_FILTERS["LEVEL_THRESH"] 
    local filter_hour = TOMB_FILTERS["HOUR_THRESH"]

    if (allow == true and filter_has_words == true) then
        if (marker.last_words == nil) then allow = false end
        -- Smart filter is now the default...
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
    if (allow == true and filter_hour > 0) then
        if (marker.timestamp ~= nil and marker.timestamp <= (currentTime - (filter_hour * 60 * 60))) then allow = false end
    end
    if (allow == true and filter_realms and marker.realm ~= REALM) then allow = false end
    return allow
end

local function IsNewRecordDuplicate(newRecord)
    local isDuplicate = false

    local newTruncatedX = math.floor(newRecord.posX * 1000) / 1000
    local newTruncatedY = math.floor(newRecord.posY * 1000) / 1000  

    -- Check if the imported record is "close enough" to existing record
    for index, existingRecord in ipairs(deathRecordsDB.deathRecords) do

        local existingTruncatedX = math.floor(existingRecord.posX * 1000) / 1000
        local existingTruncatedY = math.floor(existingRecord.posY * 1000) / 1000

        if existingRecord.mapID == newRecord.mapID and
            existingRecord.instID == newRecord.instID and
            existingTruncatedX == newTruncatedX and
            existingTruncatedY == newTruncatedY and
            math.floor(existingRecord.timestamp / 3600) == math.floor(newRecord.timestamp / 3600) and
            existingRecord.user == newRecord.user and
            existingRecord.level == newRecord.level then
            -- Ignore last words. 
            -- If last words arrive they will update our existing record instead of making a new record.
            isDuplicate = true
            break
        end
    end

    return isDuplicate
end

-- Add death marker function
local function AddDeathMarker(mapID, instID, posX, posY, timestamp, user, level, source_id, class_id, race_id)
    if (mapID == nil and instID == nil) then
        -- No location info. Useless.
        return
    end

    if (instID ~= nil) then
        printDebug("Instance death recorded for " .. user .. ".")
    end

    local marker = { realm = REALM, mapID = mapID, instID = instID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id, race_id = race_id }
    
    local isDuplicate = IsNewRecordDuplicate(marker)
    if (not isDuplicate) then 
        table.insert(deathRecordsDB.deathRecords, marker)
        IncrementDeadlyCounts(marker)
        deathRecordCount = deathRecordCount + 1
        printDebug("Death marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
    else
        printDebug("Received a duplicate record. Ignoring.")
    end
end

local function ImportDeathMarker(realm, mapID, instID, posX, posY, timestamp, user, level, source_id, class_id, race_id, last_words)
    if (mapID == nil and instID == nil) then
        -- No location info. Useless.
       return
    end

    local marker = { realm = realm, mapID = mapID, instID = instID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id, race_id = race_id, last_words = last_words }
    table.insert(deathRecordsDB.deathRecords, marker)
    IncrementDeadlyCounts(marker)
    deathRecordCount = deathRecordCount + 1
end

-- Function to create a frame to display serialized data
local function CreateDataDisplayFrame(data)
    local frame = CreateFrame("Frame", "SerializedDisplayFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", 0, 200)
    frame:SetFrameStrata("HIGH")

    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.8)

    local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOP", frame, "TOP", 0, -10)
    titleText:SetText("Tombstones Data Export")

    local scrollFrame = CreateFrame("ScrollFrame", "SerializedDisplayFrameScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 8)

    local textArea = CreateFrame("EditBox", "SerializedDisplayFrameText", scrollFrame)
    textArea:SetMultiLine(true)
    textArea:SetMaxLetters(0)
    textArea:SetAutoFocus(false)
    textArea:SetFontObject("ChatFontNormal")
    textArea:SetWidth(scrollFrame:GetWidth() - 20)
    textArea:SetHeight(scrollFrame:GetHeight() - 20)
    textArea:SetText(data)
    textArea:HighlightText()
    textArea:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local function OnCursorChanged(self)
        self:SetCursorPosition(0)
        self:HighlightText()
    end
    textArea:SetScript("OnCursorChanged", OnCursorChanged)

    local function OnTextChanged(self)
        self:SetCursorPosition(0)
        self:SetText(data)
        self:HighlightText()
    end
    textArea:SetScript("OnTextChanged", OnTextChanged)

    local closeButton = CreateFrame("Button", "SerializedDisplayFrameCloseButton", frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
        frame = nil
    end)

    scrollFrame:SetScrollChild(textArea)

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame:Show()
end

local function UpdateWorldMapMarkers()
    local worldMapFrame = WorldMapFrame
    if deathRecordsDB.showMarkers and worldMapFrame and worldMapFrame:IsVisible() then

        local currentZoneMarkers = visitingZoneCache[currentViewingMapID] or {}
        local currentIndex = #currentZoneMarkers
        renderCycleCount = renderCycleCount + 1 
        local currentRenderCycleCount = renderCycleCount
        local renderCount = 0
        local currentTime = time()

        local batchSize = 250

        local function RenderBatch()
            local startIndex = math.max(currentIndex - batchSize + 1, 1)
            local endIndex = currentIndex

            for i = endIndex, startIndex, -1 do
                -- Stop rendering on close or new Update call
                if renderingScheduled == false or renderCycleCount ~= currentRenderCycleCount then
                    return
                end
                -- If marker doesn't pass filters, skip map render
                local marker = currentZoneMarkers[i]
                local allowed = IsMarkerAllowedByFilters(marker)
                if (allowed == true) then
                    -- If marker is older than 30 days, skip map render
                    local timeDifference = currentTime - marker.timestamp
                    local thirtyDaysInSeconds = 2592000
                    if (timeDifference < thirtyDaysInSeconds) then
                        -- Generate marker for that Zone
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

                        if (marker.visited == true and markerMapButton.checkmarkTexture == nil) then
                            -- Create the checkmark texture
                            local checkmarkTexture = markerMapButton:CreateTexture(nil, "OVERLAY")
                            markerMapButton.checkmarkTexture = checkmarkTexture
                            checkmarkTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
                            checkmarkTexture:SetSize(10, 10)
                            checkmarkTexture:SetPoint("CENTER", markerMapButton, "CENTER", 0, 0)
                        end

                        if (marker.last_words ~= nil and markerMapButton.borderTexture == nil) then
                            local borderTexture = markerMapButton:CreateTexture(nil, "OVERLAY")
                            markerMapButton.borderTexture = borderTexture
                            borderTexture:SetAllPoints(markerMapButton)
                            borderTexture:SetTexture("Interface\\Cooldown\\ping4")
                            borderTexture:SetBlendMode("ADD")
                            borderTexture:SetVertexColor(1, 1, 0, 0.7)
                        end

                        local markerUsername = marker.user
                        if (filtering and not filter_realms and marker.realm ~= REALM) then
                            markerUsername = marker.user .. "@" .. marker.realm
                        end

                        -- Set the tooltip text to the name of the player who died
                        markerMapButton:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                            local class_str = marker.class_id and GetClassInfo(marker.class_id) or nil
                            if (marker.level ~= nil and marker.class_id ~= nil and marker.race_id ~= nil) then
                                local race_info = C_CreatureInfo.GetRaceInfo(marker.race_id) 
                                GameTooltip:SetText(markerUsername .. " - " .. race_info.raceName .. " " .. class_str .." - " .. marker.level)
                            elseif (marker.level ~= nil and marker.class_id ~= nil and race_info == nil) then
                                GameTooltip:SetText(markerUsername .. " - " .. class_str .." - " .. marker.level)
                            elseif (marker.level ~= nil and marker.class_id == nil) then
                                GameTooltip:SetText(markerUsername .. " - ? - " .. marker.level)
                            else
                                GameTooltip:SetText(markerUsername .. " - ? - ?")
                            end
                            local date_str = date("%Y-%m-%d %H:%M:%S", marker.timestamp)
                            GameTooltip:AddLine(date_str, .8, .8, .8, true)
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
                            if (marker.karma ~= nil) then
                                subTooltip = CreateFrame("Frame", "KarmaSubtooltip", UIParent)
                                subTooltip:SetFrameStrata("HIGH")
                                subTooltip:SetSize(120, 16)
                                subTooltip:SetPoint("BOTTOM", GameTooltip, "BOTTOM", 0, -14)
                                local bgTexture = subTooltip:CreateTexture(nil, "BACKGROUND")
                                bgTexture:SetAllPoints()
                                bgTexture:SetColorTexture(0, 0, 0, 0.75)
                                local subTooltipText = subTooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                                subTooltipText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
                                subTooltipText:SetPoint("CENTER", subTooltip, "CENTER", 0, 0)
                                subTooltipText:SetText("rating: "..marker.karma)
                                subTooltip:Show()
                            end
                            GameTooltip:Show()
                        end)
                        markerMapButton:SetScript("OnLeave", function(self)
                            if subTooltip then
                                subTooltip:Hide()
                                subTooltip:ClearAllPoints()
                                subTooltip:SetParent(nil)
                                subTooltip = nil
                            end
                            GameTooltip:Hide()
                        end)
                        markerMapButton:SetScript("OnMouseDown", function(self, button)
                            if (button == "LeftButton" and IsShiftKeyDown()) then
                                local singleRecordTable = {}
                                table.insert(singleRecordTable, marker)
                                local serializedData = ls:Serialize(singleRecordTable)
                                local compressedData = ld:CompressDeflate(serializedData)
                                local encodedData = ld:EncodeForPrint(compressedData)
                                CreateDataDisplayFrame(encodedData)
                            elseif (button == "LeftButton" and IsControlKeyDown()) then
                                local encodedKarmaMsg = TencodeMessageLite(marker) .. COMM_FIELD_DELIM .. "+"
                                local channel_num = GetChannelName(tombstones_channel)
                                if(channel_num == 0) then
                                    printDebug("Failed to send Karma message. Not in TS channel.")
                                end
                                CTL:SendChatMessage("BULK", TS_COMM_NAME, encodedKarmaMsg, "CHANNEL", nil, channel_num)
                            elseif (button == "LeftButton" and IsAltKeyDown()) then
                                local encodedKarmaMsg = TencodeMessageLite(marker) .. COMM_FIELD_DELIM .. "-"
                                local channel_num = GetChannelName(tombstones_channel)
                                if(channel_num == 0) then
                                    printDebug("Failed to send Karma message. Not in TS channel.")
                                end
                                CTL:SendChatMessage("BULK", TS_COMM_NAME, encodedKarmaMsg, "CHANNEL", nil, channel_num)
                            else
                                local worldMapFrame = WorldMapFrame:GetCanvasContainer()
                                worldMapFrame:OnMouseDown(button)
                            end
                        end)
                        markerMapButton:SetScript("OnMouseUp", function(self, button)
                            local worldMapFrame = WorldMapFrame:GetCanvasContainer()
                            worldMapFrame:OnMouseUp(button)
                        end)
                        -- Check if the marker timestamp within the last 24 hours
                        local timeDifference = currentTime - marker.timestamp
                        local secondsIn24Hours = 24 * 60 * 60 -- 12 hours in seconds
                        if (timeDifference >= secondsIn24Hours) then
                            markerMapButton.texture:SetVertexColor(.6, .6, .6, 0.5)
                        end
                        -- Cache the Map Marker for deletion later
                        deathMapIcons[i] = markerMapButton
                        hbdp:AddWorldMapIconMap("Tombstones", deathMapIcons[i], marker.mapID, marker.posX, marker.posY)
                        renderCount = renderCount + 1  
                        -- Cap marker rendering
                        if (renderCount > maxRenderCount) then
                            if (not renderWarned) then
                                print("Tombstones rendering too many markers in zone. Capping. Consider pruning.")
                                renderWarned = true
                            end
                            return
                        end
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
    ClearDeathMarkers(false)
    UpdateWorldMapMarkers()
end)

hooksecurefunc(WorldMapFrame, "OnMapChanged", function() 
    ClearDeathMarkers(false)
    currentViewingMapID = WorldMapFrame:GetMapID()
    printDebug("Current viewing Map ID:" .. currentViewingMapID)
    UpdateWorldMapMarkers()
end);

WorldMapFrame:HookScript("OnHide", function()
    ClearDeathMarkers(false)
    renderingScheduled = false
end)

-- Define the confirmation dialog
StaticPopupDialogs["TOMBSTONES_PRUNE_CONFIRMATION"] = {
    text = "Are you sure you want to prune your tombstones based on current filters?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        prunedRecordCount = PruneDeathRecords()
        InitializeDeadlyCounts()
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
        print(tostring(prunedRecordCount) .. " tombstones have been pruned.")
        print("Tombstones has " .. #deathRecordsDB.deathRecords.. " records in total.")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function MakeWorldMapButton()
    if (mapButton ~= nil) then
        mapButton:Hide()
        mapButton = nil
    end
    mapButton = CreateFrame("Button", nil, WorldMapFrame, "UIPanelButtonTemplate")
    mapButton:SetSize(20, 20) -- Adjust the size of the button as needed
    mapButton:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 30, -35)
    if (deathRecordsDB.showMarkers == true) then
        mapButton:SetNormalTexture("Interface\\Icons\\Ability_fiegndead") -- Set a custom texture for the button
    else
        mapButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Map_01")
    end
    mapButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square") -- Set the highlight texture for the button
    mapButton:SetScript("OnClick", function()
        if optionsFrame ~= nil and optionsFrame:IsVisible() then
            return
        end
        deathRecordsDB.showMarkers = not deathRecordsDB.showMarkers
        if deathRecordsDB.showMarkers then
            mapButton:SetNormalTexture("Interface\\Icons\\Ability_fiegndead") -- Set the new icon texture
            GameTooltip:SetText("Hide Tombstones")
            deathRecordsDB.showMarkers = true
            renderingScheduled = true
            UpdateWorldMapMarkers()
        else
            mapButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Map_01") -- Set the default icon texture
            GameTooltip:SetText("Show Tombstones")
            deathRecordsDB.showMarkers = false
            renderingScheduled = false
            ClearDeathMarkers(false)
        end
    end)
    mapButton:SetScript("OnEnter", function(self)
         GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
         if deathRecordsDB.showMarkers then
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

local function GenerateMinimapIcon(marker)
    local iconFrame = CreateFrame("Frame", "NearestTombstoneMM", Minimap)
    iconFrame:SetSize(12, 12)
    local iconTexture = iconFrame:CreateTexture(nil, "BACKGROUND")
    iconTexture:SetAllPoints()
    if (marker.level == nil) then
        iconTexture:SetTexture("Interface\\Icons\\Ability_fiegndead")
    elseif (marker.level <= 30) then
        iconTexture:SetTexture("Interface\\Icons\\Ability_Creature_Cursed_03")
    elseif (marker.level <= 59) then
        iconTexture:SetTexture("Interface\\Icons\\Spell_holy_nullifydisease")
    else
        iconTexture:SetTexture("Interface\\Icons\\Ability_creature_cursed_05")
    end

    if (marker.last_words ~= nil) then
        local borderTexture = iconFrame:CreateTexture(nil, "OVERLAY")
        borderTexture:SetAllPoints(iconFrame)
        borderTexture:SetTexture("Interface\\Cooldown\\ping4")
        borderTexture:SetBlendMode("ADD")
        borderTexture:SetVertexColor(1, 1, 0, 0.7)
    end

    iconTexture:SetVertexColor(1, 1, 1, 0.75)
    iconFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Tombstone", 1, 1, 1)
        GameTooltip:Show()
    end)
    iconFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return iconFrame
end

local function FlashWhenNearTombstone()
    if (deathRecordsDB.visiting == false or IsInInstance()) then
        return
    end

    -- Handle player death event
    local playerInstance = C_Map.GetBestMapForUnit("player")
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()

    local closestMarker
    local closestDistance = math.huge

    local zoneMarkers = visitingZoneCache[playerInstance]
    if (zoneMarkers == nil or #zoneMarkers == 0) then
        return
    end

    -- Iterate through your death markers and calculate the distance from each marker to the player's position
    for index, marker in ipairs(zoneMarkers) do
        local markerX = marker.posX
        local markerY = marker.posY
        local markerInstance = marker.mapID

        -- Calculate the distance between the player and the marker
        local distance = GetDistanceBetweenPositions(playerX, playerY, playerInstance, markerX, markerY, markerInstance)
        local allowed = IsMarkerAllowedByFilters(marker)

        -- Check if this marker is closer than the previous closest marker
        if not marker.visited and allowed and distance < closestDistance then
            closestMarker = marker
            closestDistance = distance
        end
    end

    -- Now you have the closest death marker to the player
    if closestMarker then
        printTrace("On move death marker: " .. tostring(closestDistance))
        if (lastClosestMarker == nil) then
            lastClosestMarker = closestMarker
            hbdp:AddMinimapIconMap("TombstonesMM", GenerateMinimapIcon(closestMarker), closestMarker.mapID, closestMarker.posX, closestMarker.posY, false, true)
        elseif (lastClosestMarker ~= closestMarker) then
            lastClosestMarker = closestMarker
            printDebug("Swapping nearest minimap marker.")
            hbdp:RemoveAllMinimapIcons("TombstonesMM")
            hbdp:AddMinimapIconMap("TombstonesMM", GenerateMinimapIcon(closestMarker), closestMarker.mapID, closestMarker.posX, closestMarker.posY, false, true)
        end

        if closestDistance <= 0.0025 then
            if (glowFrame == nil) then
                -- Create a frame for the screen glow effect
                glowFrame = CreateFrame("Frame", "ScreenGlowFrame", UIParent)
                glowFrame:SetAllPoints(UIParent)
                glowFrame:SetFrameStrata("BACKGROUND")

                -- Create a texture for the glow effect
                local glowTexture = glowFrame:CreateTexture(nil, "BACKGROUND")
                glowTexture:SetAllPoints()
                glowTexture:SetTexture("Interface\\FullScreenTextures\\OutOfControl")
                glowTexture:SetBlendMode("ADD")
                glowTexture:SetVertexColor(1, 1, 1, 0.5) -- Set the texture color to red (RGB values)
                glowFrame:Show()
            end
        elseif(glowFrame ~= nil) then
            glowFrame:Hide()
            glowFrame = nil
        end
    elseif (glowFrame ~= nil) then
        glowFrame:Hide()
        glowFrame = nil
    end
end

local function GenerateTombstonesOptionsFrame()
    if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
        return
    end

    -- Create the main frame
    optionsFrame = CreateFrame("Frame", "MyFrame", UIParent)
    optionsFrame:SetFrameStrata("HIGH")
    optionsFrame:SetSize(360, 310)
    optionsFrame:SetPoint("CENTER", 0, 80)

    local titleText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOP", optionsFrame, "TOP", 0, -10)
    titleText:SetText("Tombstones Options")

    local bgTexture = optionsFrame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.75)

    local optionText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText:SetPoint("TOP", optionsFrame, "TOPLEFT", 40, -40)
    optionText:SetText("I want...")
    optionText:SetTextColor(1, 1, 1)

    -- TOGGLE OPTIONS
    local toggle1 = CreateFrame("CheckButton", "Visiting", optionsFrame, "OptionsCheckButtonTemplate")
    toggle1:SetPoint("TOPLEFT", 20, -60)
    toggle1:SetChecked(deathRecordsDB.visiting)
    local toggle1Text = toggle1:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle1Text:SetPoint("LEFT", toggle1, "RIGHT", 5, 0)
    toggle1Text:SetText("To visit the dead.")

    local toggle2 = CreateFrame("CheckButton", "MapRender", optionsFrame, "OptionsCheckButtonTemplate")
    toggle2:SetPoint("TOPLEFT", 20, -80)
    toggle2:SetChecked(deathRecordsDB.showMarkers)
    local toggle2Text = toggle2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle2Text:SetPoint("LEFT", toggle2, "RIGHT", 5, 0)
    toggle2Text:SetText("To see the dead on my world map.")

    local toggle3 = CreateFrame("CheckButton", "ZoneInfo", optionsFrame, "OptionsCheckButtonTemplate")
    toggle3:SetPoint("TOPLEFT", 20, -100)
    toggle3:SetChecked(deathRecordsDB.showZoneSplash or deathRecordsDB.showDanger)
    local toggle3Text = toggle3:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle3Text:SetPoint("LEFT", toggle3, "RIGHT", 5, 0)
    toggle3Text:SetText("Information about dangers in my zone.")
    -- TOGGLE OPTIONS

    -- Callback function for toggle button click event
    local function ToggleOnClick(self)
        local isChecked = self:GetChecked()
        local toggleName = self:GetName()
        
        if isChecked then
            -- Perform actions for selected state
            if (toggleName == "Visiting") then
                deathRecordsDB.visiting = true
            elseif (toggleName == "MapRender") then
                deathRecordsDB.showMarkers = true
                UpdateWorldMapMarkers()
                MakeWorldMapButton()
            elseif (toggleName == "ZoneInfo") then
                deathRecordsDB.showZoneSplash = true
                deathRecordsDB.showDanger = true
                UnitTargetChange()
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "Visiting") then
                deathRecordsDB.visiting = false
                hbdp:RemoveAllMinimapIcons("TombstonesMM")
                lastClosestMarker = nil
            elseif (toggleName == "MapRender") then
                deathRecordsDB.showMarkers = false
                ClearDeathMarkers(false)
                MakeWorldMapButton()
            elseif (toggleName == "ZoneInfo") then
                deathRecordsDB.showZoneSplash = false
                deathRecordsDB.showDanger = false
                if (splashFrame ~= nil) then
                  splashFrame:Hide()
                  splashFrame = nil
                end
                if (targetDangerFrame ~= nil) then
                    targetDangerFrame:Hide()
                    targetDangerFrame = nil
                end
                if (targetDangerText ~= nil) then
                    targetDangerText = nil
                end
            end
        end
    end

    -- Assign the callback function to toggle buttons' OnClick event
    toggle1:SetScript("OnClick", ToggleOnClick)
    toggle2:SetScript("OnClick", ToggleOnClick)
    toggle3:SetScript("OnClick", ToggleOnClick)

    local closeButton = CreateFrame("Button", "CloseButton", optionsFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -8, -8)

    local filtersText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    filtersText:SetPoint("TOP", optionsFrame, "TOP", 0, -160)
    filtersText:SetText("Filters")

    local optionText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText:SetPoint("TOP", filtersText, "TOPLEFT", -35, -30)
    optionText:SetText("I only want to see Tombstones that...")
    optionText:SetTextColor(1, 1, 1)

    local lastWordsOption = CreateFrame("CheckButton", "HasLastWords", optionsFrame, "OptionsCheckButtonTemplate")
    lastWordsOption:SetPoint("TOPLEFT", 20, -210)
    lastWordsOption:SetChecked(TOMB_FILTERS["HAS_LAST_WORDS"])
    local lastWordsOptionText = lastWordsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lastWordsOptionText:SetPoint("LEFT", lastWordsOption, "RIGHT", 5, 0)
    lastWordsOptionText:SetText("Have last words.")

    local realmsOption = CreateFrame("CheckButton", "Realms", optionsFrame, "OptionsCheckButtonTemplate")
    realmsOption:SetPoint("TOPLEFT", 20, -230)
    realmsOption:SetChecked(TOMB_FILTERS["REALMS"])
    local realmsOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    realmsOptionText:SetPoint("LEFT", realmsOption, "RIGHT", 5, 0)
    realmsOptionText:SetText("Are from this realm.")

    local slider = CreateFrame("Slider", "HourSlider", optionsFrame, "OptionsSliderTemplate")
    slider:SetWidth(180)
    slider:SetHeight(20)
    slider:SetPoint("TOPLEFT", 20, -260)
    slider:SetOrientation("HORIZONTAL")
    slider:SetMinMaxValues(0, 30) -- Set the minimum and maximum values for the slider
    slider:SetValueStep(0.5) -- Set the step value for the slider
    slider:SetValue(roundNearestHalf(TOMB_FILTERS["HOUR_THRESH"]/24)) -- Set the default value for the slider
    local sliderOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sliderOptionText:SetPoint("LEFT", slider, "RIGHT", 10, 0)
    sliderOptionText:SetText("Days old, at most.")

    -- Add labels for minimum and maximum values
    slider.Low:SetText("0")
    slider.High:SetText("30")

    -- Add a label for the current value
    local valueText = slider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    valueText:SetPoint("TOP", slider, "BOTTOM", 0, -5)
    valueText:SetText(roundNearestHalf(TOMB_FILTERS["HOUR_THRESH"]/24)) -- Set the initial value
    slider.valueText = valueText

    -- Set the OnValueChanged callback function
    slider:SetScript("OnValueChanged", function(self, value)
        value = roundNearestHalf(value)
        valueText:SetText(string.format("%.1f", value))
    end)

    slider:SetScript("OnMouseUp", function(self)
        local value = roundNearestHalf(slider:GetValue())
        TOMB_FILTERS["HOUR_THRESH"] = value * 24
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    end)

        -- Callback function for toggle button click event
    local function ToggleFilter(self)
        local isChecked = self:GetChecked()
        local toggleName = self:GetName()
        
        if isChecked then
            -- Perform actions for selected state
            if (toggleName == "HasLastWords") then
                TOMB_FILTERS["HAS_LAST_WORDS"] = true
            elseif (toggleName == "Realms") then
                TOMB_FILTERS["REALMS"] = true
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "HasLastWords") then
                TOMB_FILTERS["HAS_LAST_WORDS"] = false
            elseif (toggleName == "Realms") then
                TOMB_FILTERS["REALMS"] = false
            end
        end
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    end

    lastWordsOption:SetScript("OnClick", ToggleFilter)
    realmsOption:SetScript("OnClick", ToggleFilter)

    optionsFrame:SetMovable(true)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
end

local function MakeMinimapButton()
    -- Minimap button click function
    local function MiniBtnClickFunc(btn)
        -- Prevent options panel from showing if Blizzard options panel is showing
        if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
            optionsFrame:Hide()
            optionsFrame = nil
        else
            GenerateTombstonesOptionsFrame()
        end
    end
    -- Create minimap button using LibDBIcon
    local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("Tombstones", {
        type = "data source",
        text = "Tombstones",
        icon = "Interface\\Icons\\Ability_fiegndead",
        OnClick = function(self, btn)
            MiniBtnClickFunc(btn)
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:AddLine("Tombstones")
            tooltip:AddLine("|cFFCFCFCFrecords:|r "..tostring(#deathRecordsDB.deathRecords))
        end,
    })

    local icon = LibStub("LibDBIcon-1.0", true)
    icon:Register("Tombstones", miniButton, deathRecordsDB.minimapDB)
end

function TdeathlogReceiveLastWords(sender, data)
  if data == nil then return end
  local values = {}
  for w in data:gmatch("(.-)~") do table.insert(values, w) end
  local msg = values[2]
  local currentTimeHour = math.floor(time() / 3600)

  -- Iterate over the death records
  for index, record in ipairs(deathRecordsDB.deathRecords) do
    if (record.user == sender and record.realm == REALM and record.last_words == nil) then
        if (math.floor(record.timestamp / 3600) == currentTimeHour) then
            record.last_words = LastWordsSmartParser(msg)
            break
        end
    end
  end
end

function TdeathlogReceiveChannelMessage(sender, data)
  if data == nil then return end
  local decoded_player_data = TdecodeMessage(data)
  printDebug("Tombstones decoded a DeathLog death for " .. sender .. "!")
  if sender ~= decoded_player_data["name"] then return end
  local x, y = strsplit(",", decoded_player_data["map_pos"],2)

  AddDeathMarker(tonumber(decoded_player_data["map_id"]), decoded_player_data["instance_id"], tonumber(x), tonumber(y), tonumber(decoded_player_data["date"]), sender, tonumber(decoded_player_data["level"]), tonumber(decoded_player_data["source_id"]), tonumber(decoded_player_data["class_id"]), tonumber(decoded_player_data["race_id"]))
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
  local player_data = TPlayerData(name, guild, source_id, race_id, class_id, level, instance_id, map_id, map_pos, date, last_words)
  return player_data
end

-- (name, guild, source_id, race_id, class_id, level, instance_id, map_id, map_pos, date, last_words, realm)
function TencodeMessageFull(marker)
  local loc_str = string.format("%.4f,%.4f", marker.posX, marker.posY)
  local comm_message = marker.user .. COMM_FIELD_DELIM .. (marker.guild or "") .. COMM_FIELD_DELIM .. (marker.source_id or "") .. COMM_FIELD_DELIM .. (marker.race_id or "") .. COMM_FIELD_DELIM .. 
  (marker.class_id or "") .. COMM_FIELD_DELIM .. (marker.level or "") .. COMM_FIELD_DELIM ..  (marker.instID or "") .. COMM_FIELD_DELIM .. (marker.mapID or "") .. COMM_FIELD_DELIM .. 
  loc_str .. COMM_FIELD_DELIM ..  marker.timestamp .. COMM_FIELD_DELIM ..  (marker.last_words or "") .. COMM_FIELD_DELIM ..  (marker.realm or "")
  return comm_message
end

-- (name, level, map_id, map_pos)
function TencodeMessageLite(marker)
  local loc_str = string.format("%.4f,%.4f", marker.posX, marker.posY)
  local comm_message = marker.user .. COMM_FIELD_DELIM .. (marker.level or "") .. COMM_FIELD_DELIM .. (marker.mapID or "") .. COMM_FIELD_DELIM .. loc_str
  return comm_message
end

function TdecodeMessageLite(msg)
  local values = {}
  for w in msg:gmatch("(.-)~") do table.insert(values, w) end
  if #values ~= 4 then
    print(tostring(#values))
    -- Return something that causes the calling function to return on the isValidEntry check
    local malformed_player_data = TPlayerData( "MalformedData", nil, nil, nil,nil,nil,nil,nil,nil,nil,nil,nil )
    return malformed_player_data
  end
  local date = time()
  local last_words = nil
  local name = values[1]
  local guild = nil
  local source_id = nil
  local race_id = nil
  local class_id = nil
  local level = tonumber(values[2])
  local instance_id = nil
  local map_id = tonumber(values[3])
  local map_pos = values[4]
  if (map_id == nil) then
    -- Return something that causes the calling function to return on the isValidEntry check
    local malformed_player_data = TPlayerData( "MalformedData", nil, nil, nil,nil,nil,nil,nil,nil,nil,nil,nil )
    return malformed_player_data
  end
  local player_data = TPlayerData(name, guild, source_id, race_id, class_id, level, instance_id, map_id, map_pos, date, last_words)
  return player_data
end

function TPlayerData(name, guild, source_id, race_id, class_id, level, instance_id, map_id, map_pos, date, last_words)
  return {
    ["name"] = name,
    ["guild"] = guild,
    ["source_id"] = source_id,
    ["race_id"] = race_id,
    ["class_id"] = class_id,
    ["level"] = level,
    ["instance_id"] = instance_id,
    ["map_id"] = map_id,
    ["map_pos"] = map_pos,
    ["date"] = date,
    ["last_words"] = last_words,
  }
end

-- Function to show the zone splash text
function ShowZoneSplashText()
    if (deathRecordsDB.showZoneSplash == false or IsInInstance()) then
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
    local deathLvlSumInZone = deadlyZoneLvlSums[currentMapID] or 0
    local deathMarkersTotal = #deathRecordsDB.deathRecords
    local deathPercentage = 0.0
    local deathZoneLvlAvg = 0.0
    if (deathMarkersTotal > 0) then
        deathPercentage = (deathMarkersInZone / #deathRecordsDB.deathRecords) * 100.0
    end
    if (deathMarkersInZone > 0) then
        deathZoneLvlAvg = math.floor((deathLvlSumInZone / deathMarkersInZone) + 0.5)
    end

    -- Create and display the splash text frame
    splashFrame = CreateFrame("Frame", "SplashFrame", UIParent)
    splashFrame:SetSize(400, 200)
    splashFrame:SetPoint("CENTER", 0, 0.28 * UIParent:GetHeight())

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
    local splashInfoText = string.format("There are %d tombstones here.", deathMarkersInZone)
    splashFrame.infoText:SetPoint("CENTER", 0, 120)
    splashFrame.flavorText:SetTextColor(1, 1, 1) -- Default white
    splashFrame.infoText:SetTextColor(1, 1, 1) -- White
    if (minLevel == nil or maxLevel == nil) then
        splashFlavorText = "This place seems safe..."
        splashFrame.flavorText:SetTextColor(0, 1, 0) -- Green
    elseif (playerLevel < minLevel) then
        splashFlavorText = "This place is dangerous!"
        splashFrame.flavorText:SetTextColor(1, 0, 0) -- Red
        if(deathZoneLvlAvg > 0) then
            splashInfoText = string.format("There are %d tombstones here.\nThe average death is at level %d.", deathMarkersInZone, deathZoneLvlAvg)
            splashFrame.infoText:SetPoint("CENTER", 0, 126)
        end
    elseif (playerLevel >= minLevel and playerLevel <= maxLevel) then
        splashFlavorText = "This place is teeming with adventure."
        splashFrame.flavorText:SetTextColor(1, 1, 0) -- Yellow
        if(deathZoneLvlAvg > 0) then
            splashInfoText = string.format("There are %d tombstones here.\n%.2f%% chance of death.\nThe average death is at level %d.", deathMarkersInZone, deathPercentage, deathZoneLvlAvg)
            splashFrame.infoText:SetPoint("CENTER", 0, 132)
        end
    elseif (playerLevel > maxLevel) then
        -- Do nothing
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
    splashFrame.fadeOut:SetScript("OnFinished", function(self)
        if (splashFrame ~= nil) then
            splashFrame:Hide()
            splashFrame = nil
        end
    end)

    splashFrame:Show()
    splashFrame.fadeOut:Play()
end

local function IsImportRecordDuplicate(importedRecord)
    local isDuplicate = false

    local importedTruncatedX = math.floor(importedRecord.posX * 1000) / 1000
    local importedTruncatedY = math.floor(importedRecord.posY * 1000) / 1000

    -- Check if the imported record is "close enough" to existing record
    for index, existingRecord in ipairs(deathRecordsDB.deathRecords) do

        -- Causes slowness.. but usable. Bitwise won't work on floating points.
        local existingTruncatedX = math.floor(existingRecord.posX * 1000) / 1000
        local existingTruncatedY = math.floor(existingRecord.posY * 1000) / 1000

        if existingRecord.mapID == importedRecord.mapID and
            existingRecord.instID == importedRecord.instID and
            existingTruncatedX == importedTruncatedX and
            existingTruncatedY == importedTruncatedY and
            math.floor(existingRecord.timestamp / 3600) == math.floor(importedRecord.timestamp / 3600) and
            existingRecord.user == importedRecord.user and
            existingRecord.level == importedRecord.level then
            -- The record is a duplicate match; check last_words...
            if (existingRecord.last_words == nil and importedRecord.last_words == nil) or
                (existingRecord.last_words ~= nil and importedRecord.last_words == nil) or
                (existingRecord.last_words ~= nil and importedRecord.last_words ~= nil) then
                isDuplicate = true
            elseif (existingRecord.last_words == nil and importedRecord.last_words ~= nil) then
                -- This may CREATE duplicates where import has last_words and existing does not
                -- Those can be fixed with "/ts dedupe" for now
            end
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

        local currentTruncatedX = math.floor(currentRecord.posX * 1000) / 1000
        local currentTruncatedY = math.floor(currentRecord.posY * 1000) / 1000

        for j = i + 1, totalRecords do
            local compareRecord = deathRecordsDB.deathRecords[j]

            local compareTruncatedX = math.floor(compareRecord.posX * 1000) / 1000
            local compareTruncatedY = math.floor(compareRecord.posY * 1000) / 1000

            if currentRecord.mapID == compareRecord.mapID and
                currentRecord.instID == compareRecord.instID and
                currentTruncatedX == compareTruncatedX and
                currentTruncatedY == compareTruncatedY and
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
        InitializeDeadlyCounts()
    end

    print("Original Tombstones size was " .. tostring(totalRecords) .. ", now is: " .. tostring(#deduplicatedRecords) .. ".")
    print("Tombstones found " .. tostring(duplicatesFound) .. " duplicate entries.")
    print("Tombstones replaced " .. tostring(replacementsMade) .. " duplicate entries with their more updated ones.")

    return duplicatesFound
end

local function CreateDataImportFrame()
    local frame = CreateFrame("Frame", "TombstonesImportFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", 0, 200)
    frame:SetFrameStrata("HIGH")

    -- Create the background texture
    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.8) -- Set the RGB values and alpha

    local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOP", frame, "TOP", 0, -10)
    titleText:SetText("Tombstones Data Import")

    -- Create a scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "TombstonesImportScrollFrameEditBox", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

    local editBox = CreateFrame("EditBox", "TombstonesImportFrameEditBox", scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetEnabled(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(scrollFrame:GetWidth() - 20)
    editBox:SetHeight(scrollFrame:GetHeight() - 20)
    editBox:SetText("Paste import string here...")
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
        local decodedData = ld:DecodeForPrint(encodedData)
        printDebug("Decoded data size is: " .. tostring(string.len(decodedData)))
        local decompressedData = ld:DecompressDeflate(decodedData)
        printDebug("Decompressed data size is: " .. tostring(string.len(decompressedData)))
        local success, importedDeathRecords = ls:Deserialize(decompressedData)
        -- Example: Print the received data to the chat frame
        printDebug("Deserialization sucess: " .. tostring(success))
        local numImportRecords = #importedDeathRecords
        printDebug("Imported records size is: " .. tostring(numImportRecords))
        cleanImportRecords = DedupeImportDeathRecords(importedDeathRecords)
        local numNewRecords = #cleanImportRecords
        printDebug("Deduped records size is: " .. tostring(numNewRecords))
        for _, marker in ipairs(cleanImportRecords) do
            ImportDeathMarker(marker.realm, marker.mapID, marker.instID, marker.posX, marker.posY, marker.timestamp, marker.user, marker.level, marker.source_id, marker.class_id, marker.race_id, marker.last_words)
        end
        UpdateWorldMapMarkers()
        print("Tombstones imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
        frame:Hide()
        frame = nil
    end)

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame:Show()
end

local function ConvertTimestampToLongForm(timestamp)
    local dateTable = date("*t", timestamp)
    local daySuffix = ""
    local day = dateTable.day
    if day == 1 or day == 21 or day == 31 then
        daySuffix = "st"
    elseif day == 2 or day == 22 then
        daySuffix = "nd"
    elseif day == 3 or day == 23 then
        daySuffix = "rd"
    else
        daySuffix = "th"
    end

    local hour = dateTable.hour
    local period = "am"
    if hour >= 12 then
        period = "pm"
        if hour > 12 then
            hour = hour - 12
        end
    end

    local minute = string.format("%02d", dateTable.min)
    --local second = string.format("%02d", dateTable.sec)

    return string.format("%s%s%s, %d, at %d:%s%s",
        date("%B ", timestamp),
        day, daySuffix,
        dateTable.year,
        hour, minute,
        period
    )
end

local function ShowLastWordsDialogueBox(marker)
    -- Regardless of words, stop any current boxes
    if (dialogueBox ~= nil) then
        dialogueBox:Hide()
        dialogueBox = nil
    end
    -- Safety break
    local lastWords = marker.last_words
    if (lastWords == nil or lastWords == "") then
        return
    end
    -- Create the dialogue box frame
    dialogueBox = CreateFrame("Frame", "MyDialogueBox", UIParent)
    dialogueBox:SetSize(300, 100)
    dialogueBox:SetPoint("CENTER", 0, 0.3 * UIParent:GetHeight())

    -- Add a background texture
    dialogueBox.texture = dialogueBox:CreateTexture(nil, "BACKGROUND")
    dialogueBox.texture:SetAllPoints()
    dialogueBox.texture:SetColorTexture(0, 0, 0, 0.7) -- Set the background color

    -- Add a model frame for a spooky ghost
    dialogueBox.model = CreateFrame("PlayerModel", nil, dialogueBox)
    dialogueBox.model:SetPoint("BOTTOMLEFT", 10, 10)
    dialogueBox.model:SetSize(80, 80)
    dialogueBox.model:SetDisplayInfo(146)
    --dialogueBox.model:SetUnit("player") -- Set the model to the player's character
    dialogueBox.model:SetAnimation(60)
    dialogueBox.model:SetCamDistanceScale(0.7) -- Adjust the camera distance as needed
    dialogueBox.model:SetPosition(0, 0, -0.7)

    -- Add a text area for the dialogue text
    local editBox = CreateFrame("EditBox", nil, dialogueBox)
    dialogueBox.editBox = editBox
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(0)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject("GameFontNormal")
    editBox:SetWidth(160) -- Adjust width as needed
    editBox:SetHeight(100) -- Adjust height as needed
    editBox:SetPoint("TOP", dialogueBox, "TOP", 70, -20)
    editBox:SetJustifyH("LEFT")
    editBox:SetJustifyV("TOP")
    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    editBox:SetText(marker.user..":\n\n\"" .. lastWords .."\"")

    -- Apply fade-out animation to the splash frame
    dialogueBox.fade = dialogueBox:CreateAnimationGroup()
    local fadeIn = dialogueBox.fade:CreateAnimation("Alpha")
    fadeIn:SetDuration(2) -- Adjust the delay duration as desired
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetOrder(1)
    local delay = dialogueBox.fade:CreateAnimation("Alpha")
    delay:SetDuration(8) -- Adjust the delay duration as desired
    delay:SetFromAlpha(1)
    delay:SetToAlpha(1)
    delay:SetOrder(2)
    local fadeOut = dialogueBox.fade:CreateAnimation("Alpha")
    fadeOut:SetDuration(2) -- Adjust the fade duration as desired
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetOrder(3)
    dialogueBox.fade:SetScript("OnFinished", function(self)
        if (dialogueBox ~= nil) then
            dialogueBox:Hide()
            dialogueBox = nil
        end
    end)

    dialogueBox:Show()
    dialogueBox.fade:Play()
end

-- Function to show the zone splash text
local function ShowNearestTombstoneSplashText(marker)
    if (deathRecordsDB.showZoneSplash == false or IsInInstance()) then
        return
    end

    if (tombstoneFrame ~= nil) then
        tombstoneFrame:Hide()
        tombstoneFrame = nil
    end

    -- Create and display the splash text frame
    tombstoneFrame = CreateFrame("Frame", "SplashFrame", UIParent)
    tombstoneFrame:SetSize(400, 200)
    tombstoneFrame:SetPoint("CENTER", 0, 0.3 * UIParent:GetHeight())

    -- Add a texture
    tombstoneFrame.texture = tombstoneFrame:CreateTexture(nil, "BACKGROUND")
    tombstoneFrame.texture:SetAllPoints(true)

    local class_str = marker.class_id and GetClassInfo(marker.class_id) or "Wanderer"
    local race_info = marker.race_id and C_CreatureInfo.GetRaceInfo(marker.race_id).raceName or "unknown"
    local level = marker.level and tostring(marker.level) or "unknown"
    local timeOfDeathLong = ConvertTimestampToLongForm(marker.timestamp)
    local lastWords = marker.last_words
    local heroText
    if(marker.realm == REALM) then
        heroText = marker.user .. ", a " .. class_str .. " of " .. race_info .. " origins, perished here at level " .. level .. "."
    else
        heroText = marker.user .. ", a " .. class_str .. " of " .. race_info .. " origins from " .. marker.realm .. ", perished here at level " .. level .. "."
    end

    local timeText = "They fell on " .. timeOfDeathLong .. "."
    local fallenText = "They fell by unknown means."
    if (marker.source_id ~= nil) then
        local source_npc = id_to_npc[marker.source_id]
        local env_dmg = environment_damage[marker.source_id]
        if (source_npc ~= nil) then 
            fallenText = "They were killed by " .. source_npc .. "."
        elseif (env_dmg ~= nil) then
            fallenText = "They died from " .. env_dmg .. "."
        end
    end


    -- PLAY THE HERO TEXT
    tombstoneFrame.infoText = tombstoneFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    tombstoneFrame.infoText:SetPoint("CENTER", 0, 120)
    tombstoneFrame.infoText:SetText(heroText.."\n"..fallenText.."\n"..timeText)

    -- Apply fade-out animation to the splash frame
    tombstoneFrame.heroFade = tombstoneFrame:CreateAnimationGroup()
    local fadeIn = tombstoneFrame.heroFade:CreateAnimation("Alpha")
    fadeIn:SetDuration(1) -- Adjust the delay duration as desired
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetOrder(1)
    local delay = tombstoneFrame.heroFade:CreateAnimation("Alpha")
    delay:SetDuration(10) -- Adjust the delay duration as desired
    delay:SetFromAlpha(1)
    delay:SetToAlpha(1)
    delay:SetOrder(2)
    local fadeOut = tombstoneFrame.heroFade:CreateAnimation("Alpha")
    fadeOut:SetDuration(1) -- Adjust the fade duration as desired
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetOrder(3)
    tombstoneFrame.heroFade:SetScript("OnFinished", function(self)
        if (tombstoneFrame ~= nil) then
            tombstoneFrame:Hide()
            tombstoneFrame = nil
        end
    end)

    tombstoneFrame:Show()
    tombstoneFrame.heroFade:Play()

    ShowLastWordsDialogueBox(marker)

    PlaySound(3416)
end

local function ActOnNearestTombstone()
    if(glowFrame ~= nil) then
        glowFrame:Hide()
        glowFrame = nil
    end

    if (deathRecordsDB.visiting == false or IsInInstance()) then
        return
    end
    
    -- Handle player death event
    local playerInstance = C_Map.GetBestMapForUnit("player")
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()

    local closestMarker
    local closestDistance = math.huge
    local proximityUnvisitedCount = 0

    local zoneMarkers = visitingZoneCache[playerInstance]
    if (zoneMarkers == nil or #zoneMarkers == 0) then
        return
    end

    -- Iterate through the zone death markers and calculate the distance from each marker to the player's position
    for index, marker in ipairs(zoneMarkers) do
        local markerX = marker.posX
        local markerY = marker.posY
        local markerInstance = marker.mapID

        -- Calculate the distance between the player and the marker
        local distance = GetDistanceBetweenPositions(playerX, playerY, playerInstance, markerX, markerY, markerInstance)
        local allowed = IsMarkerAllowedByFilters(marker)

        -- Check if this marker is closer than the previous closest marker
        if distance < 0.015 then
            if not marker.visited and allowed then
                proximityUnvisitedCount = proximityUnvisitedCount + 1
                if distance < closestDistance then
                    closestMarker = marker
                    closestDistance = distance
                end
            end
        end
    end

    if (proximityUnvisitedCount >= 10 and (lastProximityWarning < (time() - 900))) then
        lastProximityWarning = time()
        DEFAULT_CHAT_FRAME:AddMessage("You feel the gaze of " .. tostring(proximityUnvisitedCount) .. " nearby unvisited spirits...", 1, 1, 0)
    end

    if closestMarker then
        printTrace("Closest death marker: " .. tostring(closestMarker.user))
        printTrace("Closest death marker: " .. tostring(closestDistance))
        if closestDistance <= 0.0025 then
            -- Perform any desired logic with the closest death marker
            ShowNearestTombstoneSplashText(closestMarker)
            closestMarker.visited = true
            deathVisitCount = deathVisitCount + 1
            ClearDeathMarkers(true)
            UpdateWorldMapMarkers()
        end
    end
end

local function ProcessKarmaMessages()
    local numMsgs = math.min(#karmaMessageBuffer, karmaBatchSize) -- Determine the number of messages to process in the current batch
    for i = 1, numMsgs do
        local msg = karmaMessageBuffer[i]
        local liteDecodedPlayerData = TdecodeMessageLite(msg)
        if(liteDecodedPlayerData["name"] ~= "MalformedData") then
            local karmaScore = msg:sub(-1)
            if(karmaScore == "+" or karmaScore == "-") then
                local user = liteDecodedPlayerData["name"]
                local level = liteDecodedPlayerData["level"]
                local mapID = liteDecodedPlayerData["map_id"]
                local posX, posY = strsplit(",", liteDecodedPlayerData["map_pos"], 2)
                local zoneMarkers = visitingZoneCache[mapID]
                local foundMarker = false
                for _, marker in ipairs(zoneMarkers) do
                    if ((not foundMarker) and marker ~= nil and marker.user == user and marker.level == tonumber(level) and marker.posX == tonumber(posX) and marker.posY == tonumber(posY) and marker.realm == REALM) then
                        foundMarker = true
                        if (karmaScore == "+") then
                           if(marker.karma == nil) then
                                marker.karma = 1
                            else
                                marker.karma = marker.karma + 1
                            end 
                        else
                            if(marker.karma == nil) then
                                marker.karma = -1
                            else
                                marker.karma = marker.karma - 1
                            end 
                        end
                        printDebug("Got Karma " .. karmaScore .. " ping for " .. liteDecodedPlayerData["name"] .. ".")
                    end
                end
            end
        end
    end
    -- Remove the processed messages from the buffer
    for i = 1, numMsgs do
        table.remove(karmaMessageBuffer, 1)
    end
    -- Reset throttle on process finish
    throttlePlayer = {}
end

-- Only allow 1 ping per process batch
local function AddKarmaMessageToBuffer(sender, msg)
    if throttlePlayer[sender] == nil then throttlePlayer[sender] = 1 else return end
    table.insert(karmaMessageBuffer, msg)
end

local function StartKarmaBatchProcessing()
     -- Start a timer to execute the ProcessMessages function at regular intervals
    C_Timer.NewTicker(karmaBatchInterval, ProcessKarmaMessages)
end

local function PrintVisitingInfo()
    local mapID = C_Map.GetBestMapForUnit("player")
    local zoneMarkers = visitingZoneCache[mapID] or {}
    local zoneMarkersCount = #zoneMarkers

    print("Tombstones visiting enabled: " .. tostring(deathRecordsDB.visiting) .. ".")
    print("This zone has " .. tostring(zoneMarkersCount) .. " tombstones.")

    local zoneVisitedCount = 0
    -- Iterate through the zone death markers and calculate the distance from each marker to the player's position
    for index, marker in ipairs(zoneMarkers) do
        if (marker ~= nil and marker.visited) then
            zoneVisitedCount = zoneVisitedCount + 1
        end
    end

    local zoneVisitedPercentage = 100.0
    if (zoneMarkersCount > 0) then
        zoneVisitedPercentage = (zoneVisitedCount / zoneMarkersCount) * 100.0
    end

    print("You have visited " .. tostring(zoneVisitedCount) .. " of them. " .. string.format("(%.2f%%).", zoneVisitedPercentage))
end

-- Function to generate a random player name
local function GenerateRandomPlayerName()
    local nameLength = math.random(4, 7)
    local playerName = ""

    -- Generate the first character as a capital letter
    local firstCharAscii = math.random(65, 90) -- ASCII values for capital letters A-Z
    playerName = playerName .. string.char(firstCharAscii)

    -- Generate the remaining characters
    for i = 2, nameLength do
        local charAscii = math.random(97, 122) -- ASCII values for lowercase letters a-z
        playerName = playerName .. string.char(charAscii)
    end

    return playerName
end

-- Function to generate a random timestamp between now and 45 days ago
local function GenerateRandomTimestamp()
    local now = time() -- Current timestamp
    local fortyEightHoursInSeconds = 3888000 -- 45 days in seconds

    -- Generate a random time offset between 0 and 48 hours
    local randomOffset = math.random(0, fortyEightHoursInSeconds)

    -- Calculate the random timestamp by subtracting the offset from the current time
    local randomTimestamp = now - randomOffset

    return randomTimestamp
end

local function SillySentence()
    local words = {
        "banana", "elephant", "juggling", "noodles", "squirrel", "giraffe", "kangaroo",
        "singing", "umbrella", "muffin", "pickle", "wombat", "bubblegum", "giggles"
    }
    local sentence = ""
    local sentenceLength = math.random(3, 6)
    for i = 1, sentenceLength do
        local randomIndex = math.random(1, #words)
        local word = words[randomIndex]
        sentence = sentence .. word .. " "
    end
    sentence = sentence .. "!"
    return sentence
end

local function StressGen(numberOfMarkers)
    local mapIDs = {}
    local classNames = {}
    for mapID, _ in pairs(MAP_TABLE) do
        table.insert(mapIDs, mapID)
    end
    for className, _ in pairs(classNameToID) do
        table.insert(classNames, className)
    end

    local min = 0.1
    local max = 0.9

    for i = 1, numberOfMarkers do 
        -- Randomly select a MapID
        local randomIndex = math.random(1, #mapIDs)
        --local map_id = mapIDs[randomIndex]
        local map_id = C_Map.GetBestMapForUnit("player")
        -- Randomly generated posX and posY
        local randomValue1 = math.random()
        local randomValue2 = math.random()
        local posX = min + randomValue1 * (max - min)
        local posY = min + randomValue2 * (max - min)
        -- Random Class ID
        local randomIndex = math.random(1, #classNames)
        local class_id = classNameToID[classNames[randomIndex]]
        -- Random others
        local user = GenerateRandomPlayerName()
        local timestamp = GenerateRandomTimestamp()
        local level = math.random(1, 60)
        local race_id = math.random(1, 8)
        local last_words = SillySentence()
        ImportDeathMarker(REALM, map_id, nil, posX, posY, timestamp, user, level, nil, class_id, race_id, last_words)
    end
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
        deathRecordsDB.showMarkers = true
        UpdateWorldMapMarkers()
        MakeWorldMapButton()
    elseif command == "hide" then
        deathRecordsDB.showMarkers = false
        ClearDeathMarkers(false)
        MakeWorldMapButton()
    elseif command == "unvisit" then
        if (not debug) then return end
        UnvisitAllMarkers()
        ClearDeathMarkers(false)
        UpdateWorldMapMarkers()
    elseif command == "clear" then
        -- Clear all death records
        StaticPopup_Show("TOMBSTONES_CLEAR_CONFIRMATION")
    elseif command == "stress" then
        if (not debug) then return end
        StressGen(2000)
    elseif command == "prune" then
        -- Clear all death records
        StaticPopup_Show("TOMBSTONES_PRUNE_CONFIRMATION")
    elseif command == "dedupe" then
        if (not debug) then return end
        local duplicates = DeduplicateDeathRecords()
        if (duplicates > 0) then
            ClearDeathMarkers(true)
            UpdateWorldMapMarkers()
        end
    elseif command == "debug" then
        debug = not debug
        print("Tombstones debug mode is: ".. tostring(debug))
    elseif command == "trace" then
        trace = not trace
        print("Tombstones trace mode is: ".. tostring(trace))
    elseif command == "icon_size" then
        iconSize = tonumber(args)
    elseif command == "max_render" then
        maxRenderCount = tonumber(args)
    elseif command == "info" then
        print("Tombstones saw " .. deathRecordCount .. " records this session.")
        print("Tombstones has " .. #deathRecordsDB.deathRecords.. " records in total.")
        print("You have visited " .. deathVisitCount .. " tombstones.")
    elseif command == "export" then
        local serializedData = ls:Serialize(deathRecordsDB.deathRecords)
        printDebug("Serialized data size is: " .. tostring(string.len(serializedData)))
        local compressedData = ld:CompressDeflate(serializedData)
        printDebug("Compressed data size is: " .. tostring(string.len(compressedData)))
        local encodedData = ld:EncodeForPrint(compressedData)
        printDebug("Encoded data size is: " .. tostring(string.len(encodedData)))
        CreateDataDisplayFrame(encodedData)
    elseif command == "export_legacy" then
        local serializedData = ls:Serialize(deathRecordsDB.deathRecords)
        printDebug("Serialized data size is: " .. tostring(string.len(serializedData)))
        local compressedData = lc:Compress(serializedData)
        printDebug("Compressed data size is: " .. tostring(string.len(compressedData)))
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
    elseif command == "visiting" then
        if args == "on" then
            deathRecordsDB.visiting = true
        elseif args == "off" then
            deathRecordsDB.visiting = false
            hbdp:RemoveAllMinimapIcons("TombstonesMM")
        elseif args == "info" then
            PrintVisitingInfo()
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
            print("Tombstones 'Last Words' filtering enabled: " .. tostring(TOMB_FILTERS["HAS_LAST_WORDS"]))
            print("Tombstones 'ClassID' filtering on: " .. tostring(TOMB_FILTERS["CLASS_ID"]))
            print("Tombstones 'RaceID' filtering on: " .. tostring(TOMB_FILTERS["RACE_ID"]))
            print("Tombstones 'Level Thresh' filtering on: " .. tostring(TOMB_FILTERS["LEVEL_THRESH"]))
            print("Tombstones 'Hour Thresh' filtering on: " .. tostring(TOMB_FILTERS["HOUR_THRESH"]))
            print("Tombstones 'Realms' filtering on: " .. tostring(TOMB_FILTERS["REALMS"]))
            return
        elseif argsArray[1] == "reset" then
            TOMB_FILTERS["HAS_LAST_WORDS"] = false
            TOMB_FILTERS["CLASS_ID"] = nil
            TOMB_FILTERS["RACE_ID"] = nil
            TOMB_FILTERS["LEVEL_THRESH"] = 0
            TOMB_FILTERS["HOUR_THRESH"] = 0
            TOMB_FILTERS["REALMS"] = true
        elseif argsArray[1] == "last_words" then
            --TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HAS_LAST_WORDS"] = true
        elseif argsArray[1] == "realms" then
            --TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["REALMS"] = false
        elseif argsArray[1] == "level" then
            --TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["LEVEL_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "hours" then
            --TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HOUR_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "days" then
            --TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HOUR_THRESH"] = (tonumber(argsArray[2]) * 24)
        elseif argsArray[1] == "class" then
            local className = argsArray[2]
            if (className ~= nil) then
                --TOMB_FILTERS["ENABLED"] = true
                TOMB_FILTERS["CLASS_ID"] = classNameToID[className]
            else
                print("Tombstones ERROR : Class not found.")
                print("Tombstones WARN : Try 'paladin','priest','warrior','rogue','mage','warlock','druid','shaman','hunter'.")
            end
        elseif argsArray[1] == "race" then
            local raceName = argsArray[2]
            if (raceName ~= nil) then
                --TOMB_FILTERS["ENABLED"] = true
                TOMB_FILTERS["RACE_ID"] = raceNameToID[raceName]
            else
                print("Tombstones ERROR : Race not found.")
                print("Tombstones WARN : Try 'human','dwarf','gnome','night elf | nelf','orc','troll','undead','tauren'.")
            end
        end
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    else
        -- Display command usage information
        print("Usage: /tombstones or /ts [show | hide | export | import | prune | clear | info | icon_size {#SIZE} | max_render {#COUNT}]")
        print("Usage: /tombstones or /ts [filter (info | reset | last_words | hours {#HOURS} | days {#DAYS} | level {#LEVEL} | class {CLASS} | race {RACE})]")
        print("Usage: /tombstones or /ts [danger (show | hide | lock | unlock)]")
        print("Usage: /tombstones or /ts [visiting (info | on | off )]")
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

            LoadDeathRecords()
            MakeWorldMapButton()
            MakeMinimapButton()
            -- Try to join only after Hardcore add-on take precedence
            C_Timer.After(6.0, function()
                TdeathlogJoinChannel()
                TombstonesJoinChannel()
                StartKarmaBatchProcessing()
            end)
     
            ac:Embed(self)
            print("Tombstones loaded successfully!")
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Handle player logout event
        SaveDeathRecords()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        ShowZoneSplashText()
    elseif event == "PLAYER_TARGET_CHANGED" then
        UnitTargetChange()
    elseif event == "PLAYER_STARTED_MOVING" then
        isPlayerMoving = true
        movementTimer = 0
    elseif event == "PLAYER_STOPPED_MOVING" then
        isPlayerMoving = false
        ActOnNearestTombstone()
    elseif event == "CHAT_MSG_CHANNEL" then
        local _, channel_name = string.split(" ", arg[4])
        if channel_name == death_alerts_channel then
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
        elseif channel_name == tombstones_channel then
            local player_name_short, _ = string.split("-", arg[2])
            printTrace("Receiving Karma ping from " .. player_name_short .. ".")
            AddKarmaMessageToBuffer(player_name_short, arg[1])
        end
    end
end)

-- Movement monitoring
addon:SetScript("OnUpdate", function(self, elapsed)
    if isPlayerMoving then
        movementTimer = movementTimer + elapsed
        if (movementTimer >= movementUpdateInterval) then
            FlashWhenNearTombstone()
            movementTimer = 0
        end
    end
end)

addon:SetScript("OnUpdate", addon:GetScript("OnUpdate"))
