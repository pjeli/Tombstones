-- Constants
local ADDON_NAME = "Tombstones"
local TS_COMM_NAME = "Tombstones"
local TS_COMM_NAME_SERIAL = "TombstonesSer"
local CTL = _G.ChatThrottleLib
local REALM = GetRealmName()
local PLAYER_NAME, _ = UnitName("player")
local PLAYERGUID = UnitGUID("player")
local PLAYER_GUILD_NAME, _, _, _, _, _, _, _, _, _, _ = GetGuildInfo("player")
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
local classIDToIcon = {
    [1] = "classicon_warrior",
    [2] = "classicon_paladin",
    [3] = "classicon_hunter",
    [4] = "classicon_rogue",
    [5] = "classicon_priest",
    [7] = "classicon_shaman",
    [8] = "classicon_mage",
    [9] = "classicon_warlock",
    [11] = "classicon_druid",
}
local classColors = {
    [0] = "|cFFFFFFFF", -- Default White
    [1] = "|cFFC79C6E", -- Warrior
    [2] = "|cFFF58CBA", -- Paladin
    [3] = "|cFFABD473", -- Hunter
    [4] = "|cFFFFF569", -- Rogue
    [5] = "|cFFFFFFFF", -- Priest
    [6] = "|cFFC41F3B", -- Death Knight
    [7] = "|cFF0070DE", -- Shaman
    [8] = "|cFF69CCF0", -- Mage
    [9] = "|cFF9482C9", -- Warlock
    [11] = "|cFFA330C9", -- Druid
}
local PLAYER_CLASS = select(3, UnitClass("player"))
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
local raceIDToFactionID = {
    [1] = 1,
    [2] = 2,
    [3] = 1,
    [4] = 1,
    [5] = 2,
    [6] = 2,
    [7] = 1,
    [8] = 2,
}
local factionNameToFactionID = {
    ["alliance"] = 1,
    ["horde"] = 2,
}
local PLAYER_RACE = raceNameToID[string.lower(UnitRace("player"))]
local PLAYER_FACTION = raceIDToFactionID[PLAYER_RACE]
local TS_COMM_COMMANDS = {
  ["BROADCAST_KARMA_PING"] = "0",
  ["BROADCAST_TALLY_REQUEST"] = "1",
  ["WHISPER_TALLY_REPLY"] = "2",
  ["BROADCAST_PVP_DEATH"] = "3",
  ["BROADCAST_TOMBSTONE_SYNC_REQUEST"] = "4",
  ["WHISPER_SYNC_AVAILABILITY"] = "5",
  ["WHISPER_SYNC_ACCEPT"] = "6",
}
local MAP_TABLE = {
--[[Eastern Kingdoms]]      [1415] = {minLevel = 1,     maxLevel = 60,},
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

--[[Kalimdor]]              [1414] = {minLevel = 1,     maxLevel = 60,},
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
local tombstones_channel = "tsbroadcastchannel"
local tombstones_channel_pw = "tsbroadcastchannelpw"

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
  [-8] = "PvP" -- Added for Tombstones
}
-- DeathLog Variables
local deathlog_death_queue = {}
local deathlog_last_words_queue = {}
-- Tombstones Queue Variables
local tombstones_pvp_death_queue = {}

-- Variables
local deathRecordsDB
local miniButton
local icon
local deathMapIcons = {}
local deathRecordCount = 0
local deathVisitCount = 0
local deadlyNPCs = {}
local deadlyZones = {}
local deadlyClasses = {}
local deadlyZoneLvlSums = {}
local deadlyClassLvlSums = {}
local visitingZoneCache = {}
local iconSize = 12
local maxRenderCount = 3000
local renderWarned = false
local renderingScheduled = false
local renderCycleCount = 0
local debug = false
local trace = false
local isPlayerMoving = false
local movementUpdateInterval = 0.5 -- Update interval in seconds
local movementTimer = nil
local lastProximityWarning = 0
local lastFlowersWarning = 0
local lastClosestMarker
local optionsFrame
local mapButton
local splashFrame
local tombstoneFrame
local dialogueBox
local targetDangerFrame
local targetDangerText
local zoneDangerFrame
local zoneDangerText
local glowFrame
local currentViewingMapID
local subTooltip
local tooltipKarmaBackgroundTexture
local debugCount = 0
local lastWords = nil
local lastDmgSourceID = nil
local lastPvpSourceName = nil
local TOMB_FILTERS = {
  ["HAS_LAST_WORDS"] = false,
  ["HAS_KNOWN_DEATH"] = 1,
  ["CLASS_ID"] = nil,
  ["RACE_ID"] = nil,
  ["FACTION_ID"] = PLAYER_FACTION,
  ["LEVEL_THRESH"] = 1,
  ["HOUR_THRESH"] = 720,
  ["REALMS"] = true,
  ["RATING"] = false,
  ["GUILD"] = 0,
}

-- Message/Karma Variables
local throttle_player = {}
local shadowbanned = {}
local TallyInterval = 2
local expectingTallyReply = false
local expectingTallyReplyMapMarker = nil
local currentViewingMapMarker = nil
local expectingTallyReplyMapID = nil
local ratings = {}
local ratingsSeenCount = 0
local ratingsSeenTotal = 0
local syncAvailabilityTimer = nil
local agreedSender = nil
local agreedMapSender = nil
local agreedReceiver = nil
local agreedMapReceiver = nil
local syncAccepted = false
local requestedSync = false
local printedWarning = false

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ls = LibStub("LibSerialize")
local lc = LibStub("LibCompress")
local ld = LibStub("LibDeflate")
local l64 = LibStub("LibBase64-1.0")

-- Main Frame
local Tombstones = CreateFrame("Frame")

local function printDebug(msg)
    if debug then
        print(msg)
    end
end

local function printTrace(msg)
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
        if marker.class_id then
            if(deadlyClasses[marker.class_id] == nil) then
                deadlyClasses[marker.class_id] = 1
                deadlyClassLvlSums[marker.class_id] = marker.level
            else
                deadlyClasses[marker.class_id] = deadlyClasses[marker.class_id] + 1
                deadlyClassLvlSums[marker.class_id] = deadlyClassLvlSums[marker.class_id] + marker.level
            end
        end
    end

    if marker.visited and marker.visited == true then
        deathVisitCount = deathVisitCount + 1
    end
    -- Not ideal; but fixes broken Karma from previous system.
    if marker.karma then
        if marker.karma > 0 then
            marker.karma = 1
        elseif marker.karma < 0 then
            marker.karma = -1
        else
            marker.karma = nil
        end
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

-- Filters our Fs, Questie text, and the "Our brave.." statement down to actual words
local function LastWordsSmartParser(last_words)
    if(last_words == nil or last_words == "") then
        return nil
    end

    local allow = true

    if (startsWith(last_words, "{rt")) then allow = false end
    if (allow == true and endsWithLevel(last_words)) then allow = false end
    if (allow == true and endsWithResurrected(last_words)) then allow = false end
    if (allow == true and fDetection(last_words)) then allow = false end
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
            if (allow == true and fDetection(quotedPart)) then allow = false end
            if (allow == true and endsWithResurrected(quotedPart)) then allow = false end
            if (allow == true) then return quotedPart end
    end
    if (allow == true) then
        return last_words
    end
    return nil
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

local function TwhisperRatingForMarkerTo(msg, player_name_short)
    if (player_name_short == PLAYER_NAME) then
        printDebug("Ignoring rating tally request from self.")
        return 
    end
    local liteDecodedPlayerData = TdecodeMessageLite(msg)
    if (liteDecodedPlayerData["name"] ~= nil and liteDecodedPlayerData["name"] ~= "MalformedData") then
        local user = liteDecodedPlayerData["name"]
        local mapID = liteDecodedPlayerData["map_id"]
        local posX, posY = strsplit(",", liteDecodedPlayerData["map_pos"], 2)
        local zoneMarkers = visitingZoneCache[mapID] or {}
        local foundMarker = nil
        for _, marker in ipairs(zoneMarkers) do
            if (marker ~= nil and marker.user == user and marker.posX == tonumber(posX) and marker.posY == tonumber(posY) and marker.realm == REALM) then
                foundMarker = marker
                break
            end
        end
        if foundMarker ~= nil and foundMarker.karma ~= nil and foundMarker.karma == 1 then
            local karmaScore = foundMarker.karma > 0 and "+" or "-"
            local replyMsg = TS_COMM_COMMANDS["WHISPER_TALLY_REPLY"] .. COMM_COMMAND_DELIM .. msg .. karmaScore
            CTL:SendAddonMessage("BULK", TS_COMM_NAME, replyMsg, "WHISPER", player_name_short)
            printDebug("Sent rating ping for " .. liteDecodedPlayerData["name"] .. ".")
            return
        else
            printDebug("Ignoring rating ping for " .. liteDecodedPlayerData["name"] .. " because marker unrated.")
        end
    else
        printDebug("Ignoring rating ping for " .. liteDecodedPlayerData["name"] .. " because marker malformed.")
    end
end

local function TcountWhisperedRatingForMarkerFrom(msg, player_name_short)
    local liteDecodedPlayerData = TdecodeMessageLite(msg)
    local karmaScore = msg:sub(-1)
    if (karmaScore ~= '+') then return end
    if (tonumber(liteDecodedPlayerData["map_id"]) ~= expectingTallyReplyMapID) then return end
    ratings[player_name_short] = karmaScore == "+" and 1 or -1
end

local function WhisperSyncAvailabilityTo(player_name_short, oldest_timestamp, mapID)
    local commMessage = { msg = TS_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    CTL:SendAddonMessage("BULK", TS_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
end

local function WhisperSyncAcceptanceTo(player_name_short, oldest_timestamp, mapID)
    local commMessage = { msg = TS_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    CTL:SendAddonMessage("BULK", TS_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
    print("Tombstones is accepting sync from " .. player_name_short .. ".")
end

local function WhisperSyncDataTo(player_name_short, tombstones_data) 
    print("Tombstones is sending sync data to " .. player_name_short .. ".")

    local serialized = ls:Serialize(tombstones_data)
    local compressed = ld:CompressDeflate(serialized)
    local encoded = ld:EncodeForWoWAddonChannel(compressed)

    local chunkSize = 200 -- Set the desired chunk size
    local totalChunks = math.ceil(#encoded / chunkSize)
   
    printDebug("Loading up "..totalChunks.." chunks for sending out.")
    for i = 1, totalChunks do
      local startIndex = (i - 1) * chunkSize + 1
      local endIndex = i * chunkSize
      local chunk = encoded:sub(startIndex, endIndex)
      
      local msg = string.format("%d/%d:%s", i, totalChunks, chunk)
      
      local commMessage = { msg = msg , player_name_short = player_name_short }
      CTL:SendAddonMessage("BULK", TS_COMM_NAME_SERIAL, commMessage.msg, "WHISPER", commMessage.player_name_short)
    end
    
    agreedReceiver = nil 
    agreedMapReceiver = nil
    syncAccepted = false
end

local function TombstonesJoinChannel()
    C_ChatInfo.RegisterAddonMessagePrefix(TS_COMM_NAME)
    C_ChatInfo.RegisterAddonMessagePrefix(TS_COMM_NAME_SERIAL)
    
    local channel_num = GetChannelName(tombstones_channel)
    if channel_num == 0 then
        JoinChannelByName(tombstones_channel, tombstones_channel_pw)
        local channel_num = GetChannelName(tombstones_channel)
            if channel_num == 0 then
            print("Failed to join Tombstones channel.")
        else
            printDebug("Successfully joined Tombstones channel.")
        end
        for i = 1, 10 do
            if _G['ChatFrame'..i] then
                ChatFrame_RemoveChannel(_G['ChatFrame'..i], tombstones_channel)
            end
        end
    else
        printDebug("Successfully joined Tombstones channel.")
    end
end

local function GetOldestTombstoneTimestamp(mapID)
    local oldest_tombstone_timestamp = 0 
    
    local zoneMarkers = visitingZoneCache[mapID] or {}
    local numRecords = #zoneMarkers or 0
    
    -- Iterate over the death records in reverse
    for index = numRecords, 1, -1 do
        local marker = zoneMarkers[index]
        if (marker.timestamp > oldest_tombstone_timestamp and marker.realm == REALM) then 
          oldest_tombstone_timestamp = marker.timestamp
        end
    end

    return oldest_tombstone_timestamp
end

local function haveTombstonesBeyondTimestamp(request_timestamp, mapID)
    -- Get the number of death records
    local zoneMarkers = visitingZoneCache[mapID] or {}
    local numRecords = #zoneMarkers or 0
    -- Iterate over the death records in reverse
    for index = numRecords, 1, -1 do
        local marker = zoneMarkers[index]
        if (marker.timestamp > request_timestamp and marker.realm == REALM) then return true end
    end
    return false
end

local function GetTombstonesBeyondTimestamp(request_timestamp, max_to_fetch, mapID)
    local fetchedTombstones = {}
    -- Get the number of death records
    local zoneMarkers = visitingZoneCache[mapID] or {}
    local numRecords = #zoneMarkers or 0
    -- Iterate over the death records in reverse
    for index = numRecords, 1, -1 do
        local marker = zoneMarkers[index]
        if (marker.timestamp > request_timestamp and marker.realm == REALM) then 
            table.insert(fetchedTombstones, marker)
        end
        if #fetchedTombstones >= max_to_fetch then
            break
        end
    end
    return fetchedTombstones
end

local function BroadcastSyncRequest()
    if (IsInInstance()) then 
      print("Tombstones cannot sync while in instance.")
      return 
    end
    local playerMap = C_Map.GetBestMapForUnit("player")
    local oldest_tombstone_timestamp = GetOldestTombstoneTimestamp(playerMap)
    local channel_num = GetChannelName(tombstones_channel)
    requestedSync = true
    CTL:SendChatMessage("BULK", TS_COMM_NAME, TS_COMM_COMMANDS["BROADCAST_TOMBSTONE_SYNC_REQUEST"]..COMM_COMMAND_DELIM..oldest_tombstone_timestamp..COMM_FIELD_DELIM..playerMap, "CHANNEL", nil, channel_num)
end

local function TombstonesLeaveChannel()
    local channel_num = GetChannelName(tombstones_channel)
    if channel_num ~= 0 then
        LeaveChannelByName(tombstones_channel)
        for i = 1, 10 do
            if _G['ChatFrame'..i] then
                ChatFrame_RemoveChannel(_G['ChatFrame'..i], tombstones_channel)
            end
        end
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
        deathRecordsDB.rating = true
        deathRecordsDB.useClassIcons = false
        deathRecordsDB.broadcastPvpDeath = true
        deathRecordsDB.filteredTombsChat = true
        deathRecordsDB.offerSync = false
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
    if (deathRecordsDB.rating == nil) then
        deathRecordsDB.rating = true
    end
    if (deathRecordsDB.useClassIcons == nil) then
        deathRecordsDB.useClassIcons = false
    end
    if (deathRecordsDB.broadcastPvpDeath == nil) then
        deathRecordsDB.broadcastPvpDeath = true
    end
    if (deathRecordsDB.filteredTombsChat == nil) then
        deathRecordsDB.filteredTombsChat = true
    end
    if (deathRecordsDB.offerSync == nil) then
        deathRecordsDB.offerSync = false
    end
    if (deathRecordsDB.TOMB_FILTERS ~= nil) then
        TOMB_FILTERS = deathRecordsDB.TOMB_FILTERS
        if (TOMB_FILTERS["HOUR_THRESH"] <= 0) then
            TOMB_FILTERS["HOUR_THRESH"] = 720 -- 30 days in hours
        end
        if (TOMB_FILTERS["LEVEL_THRESH"] <= 0) then
            TOMB_FILTERS["LEVEL_THRESH"] = 1
        end
        if (TOMB_FILTERS["FACTION_ID"] ~= nil) then
            TOMB_FILTERS["FACTION_ID"] = PLAYER_FACTION
        end
        if (TOMB_FILTERS["CLASS_ID"] ~= nil) then
            TOMB_FILTERS["CLASS_ID"] = PLAYER_CLASS
        end
        if (TOMB_FILTERS["HAS_KNOWN_DEATH"] == nil or TOMB_FILTERS["HAS_KNOWN_DEATH"] == true) then
            TOMB_FILTERS["HAS_KNOWN_DEATH"] = 1
        end
        if (TOMB_FILTERS["GUILD"] == nil) then
            TOMB_FILTERS["GUILD"] = 0
        end
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

local function UnrateAllMarkers()
    local totalRecords = #deathRecordsDB.deathRecords
    local totalIcons = #deathMapIcons
    for i = 1, totalRecords do
        deathRecordsDB.deathRecords[i].karma = nil
    end
    if tooltipKarmaBackgroundTexture then
        tooltipKarmaBackgroundTexture:Hide()
        tooltipKarmaBackgroundTexture:ClearAllPoints()
        tooltipKarmaBackgroundTexture = nil
    end
end

local function HideDangerFrames()
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
    if (zoneDangerFrame ~= nil) then
        zoneDangerFrame:Hide()
        zoneDangerFrame = nil
    end
    if (zoneDangerText ~= nil) then
        zoneDangerText = nil
    end
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
        currentViewingMapMarker = nil
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
    local filter_has_death = TOMB_FILTERS["HAS_KNOWN_DEATH"]
    local filter_class = TOMB_FILTERS["CLASS_ID"]
    local filter_race = TOMB_FILTERS["RACE_ID"]
    local filter_faction = TOMB_FILTERS["FACTION_ID"]
    local filter_level = TOMB_FILTERS["LEVEL_THRESH"] 
    local filter_hour = TOMB_FILTERS["HOUR_THRESH"]
    local filter_rating = TOMB_FILTERS["RATING"]
    local filter_guild = TOMB_FILTERS["GUILD"]

    if (allow == true and filter_has_words == true) then
        if (marker.last_words == nil) then allow = false end
        -- Smart filter is now the default...
    end
    if (allow == true and filter_has_death >= 1) then
        if (marker.source_id == nil or marker.source_id == -1) then allow = false end
        if (allow and filter_has_death == 2 and marker.source_id == -8) then allow = false end
    end
    if (allow == true and filter_rating == true) then
        if (marker.karma ~= nil and marker.karma < 0) then allow = false end
    end
    if (allow == true and filter_class ~= nil) then
        if (marker.class_id == nil or marker.class_id ~= filter_class) then allow = false end
    end
    if (allow == true and filter_faction ~= nil) then
        if (marker.race_id == nil or raceIDToFactionID[marker.race_id] ~= filter_faction) then allow = false end
    end
    if (allow == true and filter_race ~= nil) then
        if (marker.race_id == nil or marker.race_id ~= filter_race) then allow = false end
    end
    if (allow == true and filter_level > 0) then
        if (marker.level ~= nil and marker.level < filter_level) then allow = false end
    end
    if (allow == true and filter_hour > 0) then
        if (marker.timestamp ~= nil and marker.timestamp <= (currentTime - (filter_hour * 60 * 60))) then allow = false end
    end
    if (allow == true and filter_guild ~= 0) then
        if (marker.guild == nil or marker.guild == "") then allow = false end
        if (allow and filter_guild == 2 and marker.guild ~= PLAYER_GUILD_NAME) then allow = false end
    end
    if (allow == true and filter_realms and marker.realm ~= REALM) then allow = false end
    return allow
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
            existingRecord.level == newRecord.level and
            existingRecord.realm == newRecord.realm then
            -- Ignore last words. 
            -- If last words arrive they will update our existing record instead of making a new record.
            isDuplicate = true
            break
        end
    end

    return isDuplicate
end

local function ImportDeathMarker(realm, mapID, instID, posX, posY, timestamp, user, level, source_id, class_id, race_id, last_words, guild, pvpKiller)
    if (mapID == nil and instID == nil) then
        -- No location info. Useless.
       return false, nil
    end

    local marker = { realm = realm, mapID = mapID, instID = instID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id, race_id = race_id, last_words = last_words, guild = guild , pvpKiller = pvpKiller }

    local isDuplicate = IsNewRecordDuplicate(marker)
    if (not isDuplicate) then 
        table.insert(deathRecordsDB.deathRecords, marker)
        IncrementDeadlyCounts(marker)
        deathRecordCount = deathRecordCount + 1
        printDebug("Death marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
        return true, marker
    end
    printDebug("Received a duplicate record. Ignoring.")
    return false, marker
end

-- Add death marker function
local function AddDeathMarker(mapID, instID, posX, posY, timestamp, user, level, source_id, class_id, race_id, guild)
    return ImportDeathMarker(REALM, mapID, instID, posX, posY, timestamp, user, level, source_id, class_id, race_id, nil, guild, nil)
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

-- Function to display the tally after a delay
local function DisplayTally()
    -- Calculate the total tally
    local totalRating = 0
    for _, rating in pairs(ratings) do
        totalRating = totalRating + rating
    end
    -- Display the tally
    if subTooltip then
        subTooltip:Hide()
        subTooltip:ClearAllPoints()
        subTooltip:SetParent(nil)
        subTooltip = nil
    end
    if GameTooltip:IsVisible() and currentViewingMapMarker == expectingTallyReplyMapMarker then
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
        subTooltipText:SetText("rating: "..totalRating)
        subTooltip:Show()
    end
    printDebug("Tally: " .. tostring(totalRating) .. ".")
    expectingTallyReply = false
    expectingTallyReplyMapMarker = nil
    expectingTallyReplyMapID = nil
    ratings = {}
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
        
        local filter_realms = TOMB_FILTERS["REALMS"]

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
                    -- Generate marker for that Zone
                    local markerMapButton = CreateFrame("Button", nil, WorldMapButton)
                    markerMapButton:SetSize(iconSize , iconSize) -- Adjust the size of the marker as needed
                    markerMapButton:SetFrameStrata("FULLSCREEN") -- Set the frame strata to ensure it appears above other elements
                    markerMapButton.texture = markerMapButton:CreateTexture(nil, "BACKGROUND")
                    markerMapButton.texture:SetAllPoints(true)
                    
                    if(deathRecordsDB.useClassIcons == true and marker.class_id ~= nil) then
                        markerMapButton.texture:SetTexture("Interface\\Icons\\"..classIDToIcon[marker.class_id])
                    else
                        markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_fiegndead")
                    end

                    if (marker.visited == true and markerMapButton.checkmarkTexture == nil) then
                        -- Create the checkmark texture
                        local checkmarkTexture = markerMapButton:CreateTexture(nil, "OVERLAY")
                        markerMapButton.checkmarkTexture = checkmarkTexture
                        checkmarkTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
                        checkmarkTexture:SetSize(10, 10)
                        checkmarkTexture:SetPoint("CENTER", markerMapButton, "CENTER", 0, 0)
                    end

                    local markerUsername = marker.user
                    if (not filter_realms and marker.realm ~= REALM) then
                        markerUsername = marker.user .. "-" .. marker.realm
                    end

                    -- Set the tooltip text to the name of the player who died
                    markerMapButton:SetScript("OnEnter", function(self)
                        currentViewingMapMarker = marker
                        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                        if (GameTooltip.SetBackdrop) then GameTooltip:SetBackdrop(nil) end
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
                        if (marker.guild ~= nil and marker.guild ~= "") then
                            GameTooltip:AddLine("<"..marker.guild..">", 0, 1, 0, true)
                        end
                        local date_str = date("%Y-%m-%d %H:%M:%S", marker.timestamp)
                        GameTooltip:AddLine(date_str, .8, .8, .8, true)
                        if (marker.source_id ~= nil) then
                            local source_id = id_to_npc[marker.source_id]
                            local env_dmg = environment_damage[marker.source_id]
                            if (source_id ~= nil) then 
                                GameTooltip:AddLine("Killed by: " .. source_id, 1, 0, 0, true) 
                            elseif (env_dmg ~= nil) then
                                if (marker.source_id == -8 and marker.pvpKiller ~= nil) then 
                                    GameTooltip:AddLine("Died from: " .. env_dmg .. " w/ " .. marker.pvpKiller, 1, 0, 0, true)
                                else 
                                    GameTooltip:AddLine("Died from: " .. env_dmg, 1, 0, 0, true)
                                end
                            end
                        end
                        if (marker.last_words ~= nil) then
                           GameTooltip:AddLine("\""..marker.last_words.."\"", 1, 1, 1)
                        end
                        if (marker.karma ~= nil) then
                            if tooltipKarmaBackgroundTexture then
                                tooltipKarmaBackgroundTexture:Hide()
                                tooltipKarmaBackgroundTexture:ClearAllPoints()
                                tooltipKarmaBackgroundTexture = nil
                            end
                            if(marker.karma > 0) then 
                                --GameTooltip:EnableDrawLayer("BACKGROUND")


                                tooltipKarmaBackgroundTexture = GameTooltip:CreateTexture(nil, "BACKGROUND")
                                tooltipKarmaBackgroundTexture:SetColorTexture(0.01, 0.8, 0.32, 0.25) 
                                GameTooltip:EnableDrawLayer("BACKGROUND")
                                GameTooltip:Show()
--                                if(GameTooltip.GetBackdropColor ~= nil) then
--                                    GameTooltip.GetBackdropColor = function(self) return 0.01, 0.5, 0.32, 0.25 end
--                                end
                            else
                                --GameTooltip:EnableDrawLayer("BACKGROUND")
                                tooltipKarmaBackgroundTexture = GameTooltip:CreateTexture(nil, "BACKGROUND")
                                tooltipKarmaBackgroundTexture:SetColorTexture(1, 0, 0, 0.25) 
                                GameTooltip:EnableDrawLayer("BACKGROUND")
                                GameTooltip:Show()
--                                if(GameTooltip.GetBackdropColor ~= nil) then
--                                    GameTooltip.GetBackdropColor = function(self) return 1, 0, 0, 0.25 end
--                                end
                            end
                            tooltipKarmaBackgroundTexture:SetSize(GameTooltip:GetWidth() - 10, GameTooltip:GetHeight() - 10) 
                            tooltipKarmaBackgroundTexture:SetPoint("CENTER", GameTooltip, "CENTER", 0, 0)
                        else
                            --GameTooltip:DisableDrawLayer("BACKGROUND")
                            tooltipKarmaBackgroundTexture = GameTooltip:CreateTexture(nil, "BACKGROUND")
                            tooltipKarmaBackgroundTexture:SetColorTexture(0, 0, 0, 0.25) 
                            GameTooltip:EnableDrawLayer("BACKGROUND")
                            GameTooltip:Show()
--                            if tooltipKarmaBackgroundTexture then
--                                tooltipKarmaBackgroundTexture:Hide()
--                                tooltipKarmaBackgroundTexture:ClearAllPoints()
--                                tooltipKarmaBackgroundTexture = nil
--                            end
--                            GameTooltip:Show()
                        end

                        --GameTooltip:EnableDrawLayer("BACKGROUND")
                        if subTooltip then
                            subTooltip:Hide()
                            subTooltip:ClearAllPoints()
                            subTooltip:SetParent(nil)
                            subTooltip = nil
                        end                         
                    end)
                    markerMapButton:SetScript("OnLeave", function(self)
                        currentViewingMapMarker = nil
                        if tooltipKarmaBackgroundTexture then
                            tooltipKarmaBackgroundTexture:Hide()
                            tooltipKarmaBackgroundTexture:ClearAllPoints()
                            tooltipKarmaBackgroundTexture = nil
                        end
                        if subTooltip then
                            subTooltip:Hide()
                            subTooltip:ClearAllPoints()
                            subTooltip:SetParent(nil)
                            subTooltip = nil
                        end
                        GameTooltip:Hide()
                    end)

                    local scaleUpAnimation = markerMapButton:CreateAnimationGroup()
                    local scaleUp1 = scaleUpAnimation:CreateAnimation("Scale")
                    scaleUp1:SetScale(1.5, 1.5)
                    scaleUp1:SetDuration(0.2)
                    scaleUp1:SetOrder(1)
                    local scaleDown1 = scaleUpAnimation:CreateAnimation("Scale")
                    scaleDown1:SetScale(1, 1)
                    scaleDown1:SetDuration(0.2)
                    scaleDown1:SetOrder(2)

                    local scaleDownAnimation = markerMapButton:CreateAnimationGroup()
                    local scaleDown2 = scaleDownAnimation:CreateAnimation("Scale")
                    scaleDown2:SetScale(0.6, 0.6)
                    scaleDown2:SetDuration(0.2)
                    scaleDown2:SetOrder(1)
                    local scaleUp2 = scaleDownAnimation:CreateAnimation("Scale")
                    scaleUp2:SetScale(1, 1)
                    scaleUp2:SetDuration(0.2)
                    scaleUp2:SetOrder(2)

                    markerMapButton:SetScript("OnMouseDown", function(self, button)
                        -- Share Tombstone export
                        if (button == "LeftButton" and IsShiftKeyDown()) then
                            -- Form export data as hyperlink
                            local exportData = generateEncodedHyperlinkFromMarker(marker)
                            local editbox = GetCurrentKeyBoardFocus();
                            if(editbox) then
                                -- Hyperlink export
                                ChatFrame1EditBox:Insert(exportData)
                            else
                                -- Open up export frame
                                CreateDataDisplayFrame(exportData)
                            end
                        -- Reset Karma score
                        elseif (button == "RightButton" and IsShiftKeyDown()) then
                            marker.karma = nil
                            if tooltipKarmaBackgroundTexture then
                                tooltipKarmaBackgroundTexture:SetSize(GameTooltip:GetWidth() - 10, GameTooltip:GetHeight() - 10) 
                                tooltipKarmaBackgroundTexture:SetPoint("CENTER", GameTooltip, "CENTER", 0, 0)
                                tooltipKarmaBackgroundTexture:SetColorTexture(0, 0, 0, 0.25) 
                                GameTooltip:EnableDrawLayer("BACKGROUND")
                                GameTooltip:Show()
                            end
                        -- Trigger karma tally broadcast; Marker must be from THIS Realm
                        elseif (button == "LeftButton" and IsControlKeyDown() and IsAltKeyDown() and deathRecordsDB.rating) then
                            
                            -- Marker must be from this realm to perform tally; pointless otherwise.
                            if (marker.realm ~= REALM) then return end
                            local encodedRatingRequestMsg = TS_COMM_COMMANDS["BROADCAST_TALLY_REQUEST"] .. COMM_COMMAND_DELIM .. TencodeMessageLite(marker)
                            local channel_num = GetChannelName(tombstones_channel)
                            CTL:SendChatMessage("BULK", TS_COMM_NAME, encodedRatingRequestMsg, "CHANNEL", nil, channel_num)
                            expectingTallyReply = true
                            expectingTallyReplyMapID = marker.mapID
                            expectingTallyReplyMapMarker = marker
                            ratings[PLAYER_NAME] = marker.karma
                            C_Timer.NewTimer(TallyInterval, DisplayTally)

                        -- Postive karma rating
                        elseif (button == "LeftButton" and IsControlKeyDown() and (marker.karma == nil or marker.karma == -1) and deathRecordsDB.rating) then
                            marker.karma = 1
                            scaleUpAnimation:Stop()
                            scaleUpAnimation:Play()

                            if(tooltipKarmaBackgroundTexture == nil) then
                                tooltipKarmaBackgroundTexture = GameTooltip:CreateTexture(nil, "BACKGROUND")
                            end
                            tooltipKarmaBackgroundTexture:SetSize(GameTooltip:GetWidth() - 10, GameTooltip:GetHeight() - 10) 
                            tooltipKarmaBackgroundTexture:SetPoint("CENTER", GameTooltip, "CENTER", 0, 0)
                            tooltipKarmaBackgroundTexture:SetColorTexture(0.01, 0.8, 0.32, 0.25)  
                            GameTooltip:EnableDrawLayer("BACKGROUND")
                            GameTooltip:Show()
                            
                            -- Marker must be from this realm and PLAYER_FACTION to receive flowers; pointless otherwise.
                            if (marker.realm ~= nil and marker.race_id ~= nil and marker.realm == REALM and raceIDToFactionID[marker.race_id] == PLAYER_FACTION) then
                              local encodedRatingPingMsg = TS_COMM_COMMANDS["BROADCAST_KARMA_PING"] .. COMM_COMMAND_DELIM .. TencodeMessageLite(marker)
                              local channel_num = GetChannelName(tombstones_channel)
                              CTL:SendChatMessage("BULK", TS_COMM_NAME, encodedRatingPingMsg, "CHANNEL", nil, channel_num)
                            end

                        -- Negative karma rating
                        elseif (button == "LeftButton" and IsAltKeyDown() and (marker.karma == nil or marker.karma == 1) and deathRecordsDB.rating) then
                            marker.karma = -1
                            scaleDownAnimation:Stop()
                            scaleDownAnimation:Play()

                            if(tooltipKarmaBackgroundTexture == nil) then
                                tooltipKarmaBackgroundTexture = GameTooltip:CreateTexture(nil, "BACKGROUND")
                            end
                            tooltipKarmaBackgroundTexture:SetSize(GameTooltip:GetWidth() - 10, GameTooltip:GetHeight() - 10) 
                            tooltipKarmaBackgroundTexture:SetPoint("CENTER", GameTooltip, "CENTER", 0, 0)
                            tooltipKarmaBackgroundTexture:SetColorTexture(1, 0, 0, 0.25) 
                            GameTooltip:EnableDrawLayer("BACKGROUND")
                            GameTooltip:Show()

                        -- Else propogate the click down the WorldMap    
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
        local prunedRecordCount = PruneDeathRecords()
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
            if (optionsFrame) then optionsFrame.toggle2:SetChecked(true) end
            renderingScheduled = true
            UpdateWorldMapMarkers()
        else
            mapButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Map_01") -- Set the default icon texture
            GameTooltip:SetText("Show Tombstones")
            deathRecordsDB.showMarkers = false
            if (optionsFrame) then optionsFrame.toggle2:SetChecked(false) end
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

local function MakeInterfacePage()
			local interPanel = CreateFrame("FRAME", "TombstonesInterfaceOptions", UIParent)
			interPanel.name = "Tombstones"
      
      local titleText = interPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      titleText:SetPoint("TOPLEFT", 10, -10)
      local font, _, flags = titleText:GetFont()
      titleText:SetFont(font, 18, flags)
      titleText:SetText("Tombstones")
      titleText:SetTextColor(0.5, 0.5, 0.5)

      -- TOGGLE OPTIONS
      local mmToggle = CreateFrame("CheckButton", "MMB_Show", interPanel, "OptionsCheckButtonTemplate")
      mmToggle:SetPoint("TOPLEFT", 10, -40)
      mmToggle:SetChecked(not deathRecordsDB.minimapDB["hide"])
      local mmToggleText = mmToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      mmToggleText:SetPoint("LEFT", mmToggle, "RIGHT", 5, 0)
      mmToggleText:SetText("Show Minimap button")
      
      local dangerFrameLockToggle = CreateFrame("CheckButton", "LockDangerFrames", interPanel, "OptionsCheckButtonTemplate")
      dangerFrameLockToggle:SetPoint("TOPLEFT", 10, -60)
      dangerFrameLockToggle:SetChecked(not deathRecordsDB.dangerFrameUnlocked)
      local dangerFrameLockToggleText = dangerFrameLockToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      dangerFrameLockToggleText:SetPoint("LEFT", dangerFrameLockToggle, "RIGHT", 5, 0)
      dangerFrameLockToggleText:SetText("Lock Zone Danger and Target Deadly frames")
      
      local classIconsToggle = CreateFrame("CheckButton", "ClassIcons", interPanel, "OptionsCheckButtonTemplate")
      classIconsToggle:SetPoint("TOPLEFT", 10, -80)
      classIconsToggle:SetChecked(deathRecordsDB.useClassIcons)
      local classIconsToggleText = mmToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      classIconsToggleText:SetPoint("LEFT", classIconsToggle, "RIGHT", 5, 0)
      classIconsToggleText:SetText("Use class icons as Tombstones")
      
      local broadcastPvpToggle = CreateFrame("CheckButton", "BroadcastPvpDeath", interPanel, "OptionsCheckButtonTemplate")
      broadcastPvpToggle:SetPoint("TOPLEFT", 10, -100)
      broadcastPvpToggle:SetChecked(deathRecordsDB.broadcastPvpDeath)
      local broadcastPvpToggleText = broadcastPvpToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      broadcastPvpToggleText:SetPoint("LEFT", broadcastPvpToggle, "RIGHT", 5, 0)
      broadcastPvpToggleText:SetText("Broadcast killer on death by World PvP")
      
      local filtedTombsInChatToggle = CreateFrame("CheckButton", "FiltedTombsInChat", interPanel, "OptionsCheckButtonTemplate")
      filtedTombsInChatToggle:SetPoint("TOPLEFT", 10, -120)
      filtedTombsInChatToggle:SetChecked(deathRecordsDB.filteredTombsChat)
      local filtedTombsInChatToggleText = filtedTombsInChatToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      filtedTombsInChatToggleText:SetPoint("LEFT", filtedTombsInChatToggle, "RIGHT", 5, 0)
      filtedTombsInChatToggleText:SetText("Show new filtered Tombstones in Default Chat")
      
      local offerSyncToggle = CreateFrame("CheckButton", "OfferSync", interPanel, "OptionsCheckButtonTemplate")
      offerSyncToggle:SetPoint("TOPLEFT", 10, -140)
      offerSyncToggle:SetChecked(deathRecordsDB.offerSync)
      local offerSyncToggleText = offerSyncToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      offerSyncToggleText:SetPoint("LEFT", offerSyncToggle, "RIGHT", 5, 0)
      offerSyncToggleText:SetText("Offer Tombstones sync service")
      
      local slashHelpText = interPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      slashHelpText:SetPoint("CENTER", interPanel, "CENTER", 0, 0)
      slashHelpText:SetText("/ts for menu.\n/ts usage for slash command options.")
      
      local function ToggleOnClick(self)
          local isChecked = self:GetChecked()
          local toggleName = self:GetName()
          
          if isChecked then
              -- Perform actions for selected state
              if (toggleName == "MMB_Show") then
                  deathRecordsDB.minimapDB["hide"] = false
                  icon:Show("Tombstones")
              elseif (toggleName == "LockDangerFrames") then
                  deathRecordsDB.dangerFrameUnlocked = false
                  if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
                  if zoneDangerFrame then zoneDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
              elseif (toggleName == "ClassIcons") then
                  deathRecordsDB.useClassIcons = true
              elseif (toggleName == "BroadcastPvpDeath") then
                  deathRecordsDB.broadcastPvpDeath = true
              elseif (toggleName == "FiltedTombsInChat") then
                  deathRecordsDB.filteredTombsChat = true
              elseif (toggleName == "OfferSync") then
                  deathRecordsDB.offerSync = true
              end
          else
              -- Perform actions for unselected state
              if (toggleName == "MMB_Show") then
                  deathRecordsDB.minimapDB["hide"] = true
                  icon:Hide("Tombstones")
              elseif (toggleName == "LockDangerFrames") then
                  deathRecordsDB.dangerFrameUnlocked = true
                  if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
                  if zoneDangerFrame then zoneDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
              elseif (toggleName == "ClassIcons") then
                  deathRecordsDB.useClassIcons = false
              elseif (toggleName == "BroadcastPvpDeath") then
                  deathRecordsDB.broadcastPvpDeath = false
              elseif (toggleName == "FiltedTombsInChat") then
                  deathRecordsDB.filteredTombsChat = false
              elseif (toggleName == "OfferSync") then
                  deathRecordsDB.offerSync = false
              end
          end
      end
      mmToggle:SetScript("OnClick", ToggleOnClick)
      dangerFrameLockToggle:SetScript("OnClick", ToggleOnClick)
      classIconsToggle:SetScript("OnClick", ToggleOnClick)
      broadcastPvpToggle:SetScript("OnClick", ToggleOnClick)
      filtedTombsInChatToggle:SetScript("OnClick", ToggleOnClick)
      offerSyncToggle:SetScript("OnClick", ToggleOnClick)

			InterfaceOptions_AddCategory(interPanel)
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

local function CreateZoneDangerFrame()
    --if (IsInInstance()) then return end
    zoneDangerFrame = CreateFrame("Frame", "ZoneDangerFrame", UIParent)
    zoneDangerFrame:SetSize(100, 20)
    local position = deathRecordsDB.zoneDangerFramePos
    if (position ~= nil) then
        zoneDangerFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", position.x, position.y)
    else
        zoneDangerFrame:SetPoint("CENTER", 0, 0)
    end
    zoneDangerFrame:SetMovable(true)
    zoneDangerFrame:SetClampedToScreen(true)
    zoneDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked)
    zoneDangerFrame:RegisterForDrag("LeftButton")
    zoneDangerFrame:SetScript("OnDragStart", zoneDangerFrame.StartMoving)
    zoneDangerFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Save the new position
        local x, y = self:GetLeft(), self:GetTop()
        deathRecordsDB.zoneDangerFramePos = { x = x, y = y }
    end)

    zoneDangerText = zoneDangerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    zoneDangerText:SetPoint("CENTER", 0, 0)
    zoneDangerText:SetText("")

    -- Create the background texture
    local bgTexture = zoneDangerFrame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.5) -- Set the RGB values and alpha (0.5 for 50% transparency)

    zoneDangerFrame.text = zoneDangerText -- Assign the text object to the frame to keep a reference
end

-- Event handler for PLAYER_TARGET_CHANGED event
local function UnitTargetChange()
    if (IsInInstance()) then return end
    local target = "target"
    if (not UnitExists("target") and targetDangerFrame ~= nil) then
        targetDangerFrame:Hide()
    end
    local targetName = UnitName(target)
    local source_id = npc_to_id[targetName]
    local friendly = UnitIsFriend("player", target)

    local playerLevel = UnitLevel("player")
    local targetLevel = UnitLevel("target")
    
    local playerInstance = C_Map.GetBestMapForUnit("player")
    local levelRange = MAP_TABLE[playerInstance]
    local minLevel
    local maxLevel
    if levelRange then
        minLevel = levelRange.minLevel
        maxLevel = levelRange.maxLevel
    end

    -- Check if the target is an enemy NPC
    if  (deathRecordsDB.showDanger and source_id ~= nil and not UnitIsPlayer(target) and not friendly and targetLevel ~= -1 and (playerLevel <= targetLevel + 4)) then
        local sourceDeathCount = deadlyNPCs[source_id] or 0
        local currentMapID = C_Map.GetBestMapForUnit("player")
        local deathMarkersTotal = deadlyZones[currentMapID] or 0
        local dangerPercentage = 0.0
        if (deathMarkersTotal > 0) then
            dangerPercentage = math.min((sourceDeathCount / deathMarkersTotal) * 100.0, 100.0)
        end
        if (targetDangerFrame == nil) then
            CreateTargetDangerFrame()
            targetDangerText:SetText(string.format("%.2f%% Deadly", dangerPercentage))
        else
            targetDangerText:SetText(string.format("%.2f%% Deadly", dangerPercentage))
        end
        targetDangerFrame:Show()
    elseif (deathRecordsDB.showDanger and not UnitIsPlayer(target) and not friendly and targetLevel == -1 and playerLevel < minLevel) then
        if (targetDangerFrame == nil) then
            CreateTargetDangerFrame()
            targetDangerText:SetText(string.format("%d%% Deadly", 100))
        else
            targetDangerText:SetText(string.format("%d%% Deadly", 100))
        end
        targetDangerFrame:Show()
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
    iconTexture:SetTexture("Interface\\Icons\\Ability_fiegndead")

    iconTexture:SetVertexColor(1, 1, 1, 0.75)
    iconFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("|cff9d9d9dTombstone|r", 1, 1, 1)
        GameTooltip:Show()
    end)
    iconFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return iconFrame
end

local function FlashWhenNearTombstone()
    if ((deathRecordsDB.visiting == false and deathRecordsDB.showDanger == false) or IsInInstance()) then
        return
    end

    local playerInstance = C_Map.GetBestMapForUnit("player")
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()
    local playerLevel = UnitLevel("player")
    
    local levelRange = MAP_TABLE[playerInstance]
    local minLevel
    local maxLevel
    if levelRange then
        minLevel = levelRange.minLevel
        maxLevel = levelRange.maxLevel
    end

    local closestMarker
    local closestDistance = math.huge
    local proximityUnvisitedCount = 0
    local proximityTotalCount = 0

    local zoneMarkers = visitingZoneCache[playerInstance] or {}
    local totalZoneMarkers = #zoneMarkers

    -- Iterate through zone death markers and determine closest marker
    for index, marker in ipairs(zoneMarkers) do
        local markerX = marker.posX
        local markerY = marker.posY
        local markerInstance = marker.mapID

        -- Calculate the distance between the player and the marker
        local distance = GetDistanceBetweenPositions(playerX, playerY, playerInstance, markerX, markerY, markerInstance)
        local allowed = IsMarkerAllowedByFilters(marker)

        -- Check if this marker is closer than the previous closest marker
        if distance < 0.03 then
            proximityTotalCount = proximityTotalCount + 1
        end
        if allowed then
            if (distance < 0.015 and not marker.visited) then proximityUnvisitedCount = proximityUnvisitedCount + 1 end
            if (not marker.visited and distance < closestDistance) then
                    closestMarker = marker
                    closestDistance = distance
            end
        end
    end
    
    -- Only show Danger frame if within level range and enabled
    if (deathRecordsDB.showDanger and minLevel ~= nil and maxLevel ~= nil and playerLevel <= maxLevel and playerLevel >= minLevel) then
        local dangerPercentage = 0.0
        if (totalZoneMarkers > 0) then
            dangerPercentage = math.min((proximityTotalCount / totalZoneMarkers) * 100.0, 100.0)
        end
        if (zoneDangerFrame == nil) then
            CreateZoneDangerFrame()
            zoneDangerText:SetText(string.format("%.2f%% Danger", dangerPercentage))
        else
            zoneDangerText:SetText(string.format("%.2f%% Danger", dangerPercentage))
        end
    elseif (deathRecordsDB.showDanger and minLevel ~= nil and maxLevel ~= nil and playerLevel < minLevel) then
        if (zoneDangerFrame == nil) then
            CreateZoneDangerFrame()
            zoneDangerText:SetText(string.format("%d%% Danger", 100))
        else
            zoneDangerText:SetText(string.format("%d%% Danger", 100))
        end
    else
        if (zoneDangerFrame ~= nil) then
            zoneDangerFrame:Hide()
            zoneDangerFrame = nil
        end
    end    
    
    -- Only show Visiting Glow if visiting enabled
    if (deathRecordsDB.visiting) then
        -- Proximity flavor text
        if(proximityUnvisitedCount >= 10 and (lastProximityWarning < (time() - 900))) then
          lastProximityWarning = time()
          DEFAULT_CHAT_FRAME:AddMessage("You feel the gaze of " .. tostring(proximityUnvisitedCount) .. " nearby unvisited spirits...", 1, 1, 0)
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
end

local function PrintDeadliestNPCs() 
  -- Function to compare the values for sorting
  local function compareValues(a, b)
      return deadlyNPCs[a] > deadlyNPCs[b]
  end
  -- Create a temporary table to store the keys
  local tempKeys = {}
  for key in pairs(deadlyNPCs) do
      --print(key)
      if (tonumber(key) ~= nil and tonumber(key) > 0) then
        table.insert(tempKeys, key)
      end
  end

  -- Sort the keys based on their values
  table.sort(tempKeys, compareValues)

  -- Fetch the top 3 keys with the highest values
  local top3Keys = {}
  for i = 1, 3 do
      if tempKeys[i] then
          table.insert(top3Keys, tempKeys[i])
      end
  end

  -- Print the top 3 keys and their corresponding values
  for _, key in ipairs(top3Keys) do
      print(id_to_npc[key] .. " has the highest value: " .. deadlyNPCs[key])
  end
end

local function PrintDeadliestEnvironmentalDamages() 
  -- Function to compare the values for sorting
  local function compareValues(a, b)
      return deadlyNPCs[a] > deadlyNPCs[b]
  end
  -- Create a temporary table to store the keys
  local tempKeys = {}
  for key in pairs(deadlyNPCs) do
      --print(key)
      if (tonumber(key) ~= nil and tonumber(key) < -1) then
        table.insert(tempKeys, key)
      end
  end

  -- Sort the keys based on their values
  table.sort(tempKeys, compareValues)

  -- Fetch the top 3 keys with the highest values
  local top3Keys = {}
  for i = 1, 3 do
      if tempKeys[i] then
          table.insert(top3Keys, tempKeys[i])
      end
  end

  -- Print the top 3 keys and their corresponding values
  for _, key in ipairs(top3Keys) do
      print(environment_damage[key] .. " has the highest value: " .. deadlyNPCs[key])
  end
end

local function PrintDeadliestZones() 
  -- Function to compare the values for sorting
  local function compareValues(a, b)
      return deadlyZones[a] > deadlyZones[b]
  end
  -- Create a temporary table to store the keys
  local tempKeys = {}
  for key in pairs(deadlyZones) do
      --print(key)
      if (tonumber(key) ~= nil and tonumber(key) > 0) then
        table.insert(tempKeys, key)
      end
  end

  -- Sort the keys based on their values
  table.sort(tempKeys, compareValues)

  -- Fetch the top 3 keys with the highest values
  local top3Keys = {}
  for i = 1, 3 do
      if tempKeys[i] then
          table.insert(top3Keys, tempKeys[i])
      end
  end

  -- Print the top 3 keys and their corresponding values
  for _, key in ipairs(top3Keys) do
      print(C_Map.GetMapInfo(key).name .. " has the highest value: " .. deadlyZones[key])
  end
end

local function PrintDeadliestClasses() 
  -- Function to compare the values for sorting
  local function compareValues(a, b)
      return deadlyClasses[a] > deadlyClasses[b]
  end
  -- Create a temporary table to store the keys
  local tempKeys = {}
  for key in pairs(deadlyClasses) do
      --print(key)
      if (tonumber(key) ~= nil and tonumber(key) > 0) then
        table.insert(tempKeys, key)
      end
  end

  -- Sort the keys based on their values
  table.sort(tempKeys, compareValues)

  -- Fetch the top 3 keys with the highest values
  local top3Keys = {}
  for i = 1, 3 do
      if tempKeys[i] then
          table.insert(top3Keys, tempKeys[i])
      end
  end

  -- Print the top 3 keys and their corresponding values
  for _, key in ipairs(top3Keys) do
      print(C_CreatureInfo.GetClassInfo(key).className .. " has the highest value: " .. deadlyClasses[key])
      print(C_CreatureInfo.GetClassInfo(key).className .. " death level average is level: " .. math.floor(deadlyClassLvlSums[key] / deadlyClasses[key]))
  end
end

local function GenerateTombstonesOptionsFrame()
    if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
        return
    elseif (optionsFrame ~= nil and not optionsFrame:IsVisible()) then
        optionsFrame:Show()
        return
    end

    -- Create the main frame
    optionsFrame = CreateFrame("Frame", "TombstonesOptionsFrame", UIParent)
    optionsFrame:SetSize(360, 430)
    optionsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    optionsFrame:SetFrameLevel(6000)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:SetPoint("CENTER", 0, 80)
    
    optionsFrame.t = optionsFrame:CreateTexture(nil, "BACKGROUND")
    optionsFrame.t:SetAllPoints()
    optionsFrame.t:SetColorTexture(0, 0, 0, 0.75)

    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionsFrame.title:SetPoint("TOP", optionsFrame, "TOP", 0, -10)
    optionsFrame.title:SetText("|cff9d9d9dTombstones Options|r")

    local optionText1 = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText1:SetPoint("TOP", optionsFrame, "TOPLEFT", 40, -40)
    optionText1:SetText("I want...")
    optionText1:SetTextColor(1, 1, 1)

    -- TOGGLE OPTIONS
    local toggle1 = CreateFrame("CheckButton", "Visiting", optionsFrame, "OptionsCheckButtonTemplate")
    toggle1:SetPoint("TOPLEFT", 20, -60)
    toggle1:SetChecked(deathRecordsDB.visiting)
    local toggle1Text = toggle1:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle1Text:SetPoint("LEFT", toggle1, "RIGHT", 5, 0)
    toggle1Text:SetText("To visit the dead.")

    local toggle2 = CreateFrame("CheckButton", "MapRender", optionsFrame, "OptionsCheckButtonTemplate")
    optionsFrame.toggle2 = toggle2
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
    
    local toggle4 = CreateFrame("CheckButton", "Rating", optionsFrame, "OptionsCheckButtonTemplate")
    toggle4:SetPoint("TOPLEFT", 20, -120)
    toggle4:SetChecked(deathRecordsDB.rating)
    local toggle4Text = toggle4:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle4Text:SetPoint("LEFT", toggle4, "RIGHT", 5, 0)
    toggle4Text:SetText("To participate in rating the dead.")
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
                renderingScheduled = true
                UpdateWorldMapMarkers()
                MakeWorldMapButton()
            elseif (toggleName == "ZoneInfo") then
                deathRecordsDB.showZoneSplash = true
                deathRecordsDB.showDanger = true
                UnitTargetChange()
            elseif (toggleName == "Rating") then
                deathRecordsDB.rating = true
                TombstonesJoinChannel()
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "Visiting") then
                deathRecordsDB.visiting = false
                hbdp:RemoveAllMinimapIcons("TombstonesMM")
                lastClosestMarker = nil
            elseif (toggleName == "MapRender") then
                deathRecordsDB.showMarkers = false
                renderingScheduled = false
                ClearDeathMarkers(false)
                MakeWorldMapButton()
            elseif (toggleName == "ZoneInfo") then
                deathRecordsDB.showZoneSplash = false
                deathRecordsDB.showDanger = false
                HideDangerFrames()
            elseif (toggleName == "Rating") then
                deathRecordsDB.rating = false
                TombstonesLeaveChannel()
            end
        end
    end

    -- Assign the callback function to toggle buttons' OnClick event
    toggle1:SetScript("OnClick", ToggleOnClick)
    toggle2:SetScript("OnClick", ToggleOnClick)
    toggle3:SetScript("OnClick", ToggleOnClick)
    toggle4:SetScript("OnClick", ToggleOnClick)

    optionsFrame.c = CreateFrame("Button", "CloseButton", optionsFrame, "UIPanelCloseButton")
    optionsFrame.c:SetPoint("TOPRIGHT", 0, 0)

    local filtersText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    filtersText:SetPoint("TOP", optionsFrame, "TOP", 0, -160)
    filtersText:SetText("|cff9d9d9dFilters|r")

    local optionText2 = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText2:SetPoint("TOP", filtersText, "TOPLEFT", -35, -30)
    optionText2:SetText("I only want to see Tombstones that...")
    optionText2:SetTextColor(1, 1, 1)

    local lastWordsOption = CreateFrame("CheckButton", "HasLastWords", optionsFrame, "OptionsCheckButtonTemplate")
    lastWordsOption:SetPoint("TOPLEFT", 20, -210)
    lastWordsOption:SetChecked(TOMB_FILTERS["HAS_LAST_WORDS"])
    local lastWordsOptionText = lastWordsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lastWordsOptionText:SetPoint("LEFT", lastWordsOption, "RIGHT", 5, 0)
    lastWordsOptionText:SetText("Have last words.")
    
    local knownDeathOption = CreateFrame("CheckButton", "HasKnownDeath", optionsFrame, "OptionsCheckButtonTemplate")
    knownDeathOption:SetPoint("TOPLEFT", 20, -230)
    knownDeathOption:SetChecked(TOMB_FILTERS["HAS_KNOWN_DEATH"] >= 1)
    local knownDeathOptionText = knownDeathOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    knownDeathOptionText:SetPoint("LEFT", knownDeathOption, "RIGHT", 5, 0)
    knownDeathOptionText:SetText("Have known means of death.")
    
    local ignorePvpOption = CreateFrame("CheckButton", "IgnorePvp", optionsFrame, "OptionsCheckButtonTemplate")
    ignorePvpOption:SetPoint("LEFT", knownDeathOptionText, "RIGHT", 5, 0)
    if (TOMB_FILTERS["HAS_KNOWN_DEATH"] == 2) then
        ignorePvpOption:Enable()
        ignorePvpOption:SetChecked(true)
    elseif(TOMB_FILTERS["HAS_KNOWN_DEATH"] == 1) then
        ignorePvpOption:Enable()
        ignorePvpOption:SetChecked(false)
    else
        ignorePvpOption:Disable()
        ignorePvpOption:SetChecked(false)
    end
    local ignorePvpOptionText = ignorePvpOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ignorePvpOptionText:SetPoint("LEFT", ignorePvpOption, "RIGHT", 5, 0)
    ignorePvpOptionText:SetText("Ignore PvP.")
    
    local guildOption = CreateFrame("CheckButton", "Guild", optionsFrame, "OptionsCheckButtonTemplate")
    guildOption:SetPoint("TOPLEFT", 20, -250)
    guildOption:SetChecked(TOMB_FILTERS["GUILD"] >= 1)
    local guildOptionText = guildOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    guildOptionText:SetPoint("LEFT", guildOption, "RIGHT", 5, 0)
    guildOptionText:SetText("Are in a guild.")
    
    local guild2Option = CreateFrame("CheckButton", "MyGuild", optionsFrame, "OptionsCheckButtonTemplate")
    guild2Option:SetPoint("LEFT", guildOptionText, "RIGHT", 5, 0)
    if (TOMB_FILTERS["GUILD"] == 2) then
        guild2Option:Enable()
        guild2Option:SetChecked(true)
    elseif(TOMB_FILTERS["GUILD"] == 1) then
        guild2Option:Enable()
        guild2Option:SetChecked(false)
    else
        guild2Option:Disable()
        guild2Option:SetChecked(false)
    end
    local guild2OptionText = guild2Option:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    guild2OptionText:SetPoint("LEFT", guild2Option, "RIGHT", 5, 0)
    guild2OptionText:SetText("In my guild.")
    
    local classOption = CreateFrame("CheckButton", "Class", optionsFrame, "OptionsCheckButtonTemplate")
    classOption:SetPoint("TOPLEFT", 20, -270)
    classOption:SetChecked(TOMB_FILTERS["CLASS_ID"] ~= nil)
    local classOptionText = classOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    classOptionText:SetPoint("LEFT", classOption, "RIGHT", 5, 0)
    classOptionText:SetText("Are same class as me.")
    
    local factionOption = CreateFrame("CheckButton", "Faction", optionsFrame, "OptionsCheckButtonTemplate")
    factionOption:SetPoint("TOPLEFT", 20, -290)
    factionOption:SetChecked(TOMB_FILTERS["FACTION_ID"] ~= nil)
    local factionOptionText = factionOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    factionOptionText:SetPoint("LEFT", factionOption, "RIGHT", 5, 0)
    factionOptionText:SetText("Are same faction as me.")

    local realmsOption = CreateFrame("CheckButton", "Realms", optionsFrame, "OptionsCheckButtonTemplate")
    realmsOption:SetPoint("TOPLEFT", 20, -310)
    realmsOption:SetChecked(TOMB_FILTERS["REALMS"])
    local realmsOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    realmsOptionText:SetPoint("LEFT", realmsOption, "RIGHT", 5, 0)
    realmsOptionText:SetText("Are from this realm.")
    
    local ratingOption = CreateFrame("CheckButton", "Rating", optionsFrame, "OptionsCheckButtonTemplate")
    ratingOption:SetPoint("TOPLEFT", 20, -330)
    ratingOption:SetChecked(TOMB_FILTERS["RATING"])
    local ratingOptionText = ratingOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ratingOptionText:SetPoint("LEFT", ratingOption, "RIGHT", 5, 0)
    ratingOptionText:SetText("Don't have |cFFF00000bad|r karma.")

    local hourSlider = CreateFrame("Slider", "HourSlider", optionsFrame, "OptionsSliderTemplate")
    hourSlider:SetWidth(180)
    hourSlider:SetHeight(20)
    hourSlider:SetPoint("TOPLEFT", 20, -360)
    hourSlider:SetOrientation("HORIZONTAL")
    hourSlider:SetMinMaxValues(0.5, 30) -- Set the minimum and maximum values for the slider
    hourSlider:SetValueStep(0.5) -- Set the step value for the slider
    hourSlider:SetValue(30.5 - roundNearestHalf(TOMB_FILTERS["HOUR_THRESH"]/24)) -- Set the default value for the slider
    local hourSliderOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hourSliderOptionText:SetPoint("LEFT", hourSlider, "RIGHT", 10, 0)
    hourSliderOptionText:SetText("Days old, at most.")
    -- Add labels for minimum and maximum values
    hourSlider.Low:SetText("30")
    hourSlider.High:SetText("0.5")

    -- Add a label for the current value
    local hourText = hourSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hourText:SetPoint("TOP", hourSlider, "BOTTOM", 0, 0)
    hourText:SetText(roundNearestHalf(TOMB_FILTERS["HOUR_THRESH"]/24)) -- Set the initial value
    hourSlider.hourText = hourText

    -- Set the OnValueChanged callback function
    hourSlider:SetScript("OnValueChanged", function(self, value)
        value = 30.5 - roundNearestHalf(value)
        hourText:SetText(string.format("%.1f", value))
    end)

    hourSlider:SetScript("OnMouseUp", function(self)
        local value = 30.5 - roundNearestHalf(hourSlider:GetValue())
        TOMB_FILTERS["HOUR_THRESH"] = value * 24
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    end)
      
    local levelSlider = CreateFrame("Slider", "LevelSlider", optionsFrame, "OptionsSliderTemplate")
    levelSlider:SetWidth(180)
    levelSlider:SetHeight(20)
    levelSlider:SetPoint("TOPLEFT", 20, -390)
    levelSlider:SetOrientation("HORIZONTAL")
    levelSlider:SetMinMaxValues(1, 60) -- Set the minimum and maximum values for the slider
    levelSlider:SetValueStep(1) -- Set the step value for the slider
    levelSlider:SetValue(round(TOMB_FILTERS["LEVEL_THRESH"])) -- Set the default value for the slider
    local levelSliderOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    levelSliderOptionText:SetPoint("LEFT", levelSlider, "RIGHT", 10, 0)
    levelSliderOptionText:SetText("At least this level.")
    -- Add labels for minimum and maximum values
    levelSlider.Low:SetText("1")
    levelSlider.High:SetText("60")

    -- Add a label for the current value
    local levelText = levelSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    levelText:SetPoint("TOP", levelSlider, "BOTTOM", 0, 0)
    levelText:SetText(round(TOMB_FILTERS["LEVEL_THRESH"])) -- Set the initial value
    levelSlider.levelText = levelText

    -- Set the OnValueChanged callback function
    levelSlider:SetScript("OnValueChanged", function(self, value)
        value = round(value)
        levelText:SetText(value)
    end)

    levelSlider:SetScript("OnMouseUp", function(self)
        local value = round(levelSlider:GetValue())
        TOMB_FILTERS["LEVEL_THRESH"] = value
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    end)

        -- Callback function for toggle button click event
    local function ToggleFilter(self)
        local isChecked = self:GetChecked()
        local toggleName = self:GetName()
        
        if guildOption:GetChecked() then
            guild2Option:Enable()
        else
            guild2Option:Disable()
            guild2Option:SetChecked(false) -- Reset the dependent checkbox when main checkbox is unchecked
            TOMB_FILTERS["GUILD"] = 0
        end
        
        if knownDeathOption:GetChecked() then
            ignorePvpOption:Enable()
        else
            ignorePvpOption:Disable()
            ignorePvpOption:SetChecked(false) -- Reset the dependent checkbox when main checkbox is unchecked
            TOMB_FILTERS["HAS_KNOWN_DEATH"] = 0
        end
        
        if isChecked then
            -- Perform actions for selected state
            if (toggleName == "HasLastWords") then
                TOMB_FILTERS["HAS_LAST_WORDS"] = true
            elseif (toggleName == "HasKnownDeath") then
                TOMB_FILTERS["HAS_KNOWN_DEATH"] = 1
            elseif (toggleName == "IgnorePvp") then
                TOMB_FILTERS["HAS_KNOWN_DEATH"] = 2
            elseif (toggleName == "Realms") then
                TOMB_FILTERS["REALMS"] = true
            elseif (toggleName == "Class") then
                TOMB_FILTERS["CLASS_ID"] = PLAYER_CLASS
            elseif (toggleName == "Faction") then
                TOMB_FILTERS["FACTION_ID"] = PLAYER_FACTION
            elseif (toggleName == "Rating") then
                TOMB_FILTERS["RATING"] = true
            elseif (toggleName == "Guild") then
                TOMB_FILTERS["GUILD"] = 1
            elseif (toggleName == "MyGuild") then
                TOMB_FILTERS["GUILD"] = 2
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "HasLastWords") then
                TOMB_FILTERS["HAS_LAST_WORDS"] = false
            elseif (toggleName == "HasKnownDeath") then
                TOMB_FILTERS["HAS_KNOWN_DEATH"] = 0
            elseif (toggleName == "IgnorePvp") then
                TOMB_FILTERS["HAS_KNOWN_DEATH"] = 1
            elseif (toggleName == "Realms") then
                TOMB_FILTERS["REALMS"] = false
            elseif (toggleName == "Class") then
                TOMB_FILTERS["CLASS_ID"] = nil
            elseif (toggleName == "Faction") then
                TOMB_FILTERS["FACTION_ID"] = nil
            elseif (toggleName == "Rating") then
                TOMB_FILTERS["RATING"] = false
            elseif (toggleName == "Guild") then
                TOMB_FILTERS["GUILD"] = 0
            elseif (toggleName == "MyGuild") then
                TOMB_FILTERS["GUILD"] = 1
            end
        end
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    end

    lastWordsOption:SetScript("OnClick", ToggleFilter)
    knownDeathOption:SetScript("OnClick", ToggleFilter)
    ignorePvpOption:SetScript("OnClick", ToggleFilter)
    classOption:SetScript("OnClick", ToggleFilter)
    guildOption:SetScript("OnClick", ToggleFilter)
    guild2Option:SetScript("OnClick", ToggleFilter)
    factionOption:SetScript("OnClick", ToggleFilter)
    realmsOption:SetScript("OnClick", ToggleFilter)
    ratingOption:SetScript("OnClick", ToggleFilter)

    optionsFrame:SetMovable(true)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
    table.insert(UISpecialFrames, "TombstonesOptionsFrame")
end

local function MakeMinimapButton()
    -- Minimap button click function
    local function MiniBtnClickFunc(btn)
        if (IsControlKeyDown()) then
          BroadcastSyncRequest()
          -- Set minimap icon to indicate sync running
          miniButton.icon = "Interface\\Icons\\inv_misc_eye_01"
          icon:Refresh("Tombstones")
          C_Timer.After(10.0, function()
              miniButton.icon = "Interface\\Icons\\Ability_fiegndead"
              icon:Refresh("Tombstones")
          end)
        else
          if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
              optionsFrame:Hide()
          else
              GenerateTombstonesOptionsFrame()
          end
        end
    end
    -- Create minimap button using LibDBIcon
    miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("Tombstones", {
        type = "data source",
        text = "Tombstones",
        icon = "Interface\\Icons\\Ability_fiegndead",
        OnClick = function(self, btn)
            MiniBtnClickFunc(btn)
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:AddLine("Tombstones")
            tooltip:AddLine("|cff9d9d9drecords:|r "..tostring(#deathRecordsDB.deathRecords))
            tooltip:AddLine("|cffffffffctrl-click to sync|r")
        end,
    })

    icon = LibStub("LibDBIcon-1.0", true)
    icon:Register("Tombstones", miniButton, deathRecordsDB.minimapDB)
end

function TReceivePvpDeath(sender, data)
  if data == nil then return end
  local values = {}
  for w in data:gmatch("(.-)~") do table.insert(values, w) end
  local msg = values[1]
  local currentTimeHour = math.floor(time() / 3600)

  -- Get the number of death records
  local numRecords = #deathRecordsDB.deathRecords

  -- Iterate over the death records in reverse
  for index = numRecords, 1, -1 do
      local record = deathRecordsDB.deathRecords[index]
      if (record.user == sender and record.realm == REALM and record.source_id == -8 and record.pvpKiller == nil) then
          if (math.floor(record.timestamp / 3600) == currentTimeHour) then
              record.pvpKiller = msg
              break
          end
      end
  end
end

function TdeathlogReceiveLastWords(sender, data)
  if data == nil then return end
  local values = {}
  for w in data:gmatch("(.-)~") do table.insert(values, w) end
  local msg = values[2]
  local currentTimeHour = math.floor(time() / 3600)

  -- Get the number of death records
  local numRecords = #deathRecordsDB.deathRecords

  -- Iterate over the death records in reverse
  for index = numRecords, 1, -1 do
      local record = deathRecordsDB.deathRecords[index]
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
  
  local mapID = tonumber(decoded_player_data["map_id"])
  local posX = tonumber(x)
  local posY = tonumber(y)

  local success, marker = AddDeathMarker(mapID, decoded_player_data["instance_id"], posX, posY, tonumber(decoded_player_data["date"]), sender, tonumber(decoded_player_data["level"]), tonumber(decoded_player_data["source_id"]), tonumber(decoded_player_data["class_id"]), tonumber(decoded_player_data["race_id"]), decoded_player_data["guild"])
  
  local overlayFrame = CreateFrame("Frame", nil, WorldMapFrame)
  local overlayFrameTexture = overlayFrame:CreateTexture(nil, "ARTWORK")
  local textureIcon = "Interface\\Icons\\Ability_Creature_Cursed_03"
  overlayFrameTexture:SetAllPoints()
  overlayFrameTexture:SetTexture(textureIcon)

  ratingsSeenCount = ratingsSeenCount + 1

  miniButton.icon = textureIcon
  icon:Refresh("Tombstones")
  
  C_Timer.After(7.0, function()
      ratingsSeenCount = ratingsSeenCount - 1
      if overlayFrame ~= nil then
          overlayFrame:Hide()
          overlayFrame = nil 
      end
      if(ratingsSeenCount == 0) then
        miniButton.icon = "Interface\\Icons\\Ability_fiegndead"
        icon:Refresh("Tombstones")
      end
  end)

  if (success and not IsInInstance() and deathRecordsDB.filteredTombsChat) then
      C_Timer.After(7.0, function()
          if (IsMarkerAllowedByFilters(marker)) then
              local last_words = marker.last_words or ""
              local _, santizedLastWords = extractBracketTextWithColor(last_words)
              local encodedLastWords = encodeColorizedText(santizedLastWords)
              local msg = "|cff9d9d9d|Hgarrmission:tombstones:"..marker.guild..":"..marker.timestamp..":"..marker.level..":"..marker.class_id..":"..marker.race_id..":"..marker.source_id..":"..marker.mapID..":"..marker.posX..":"..marker.posY..":\""..encodedLastWords.."\"|h["..marker.user.."'s Tombstone]|h|r"
              DEFAULT_CHAT_FRAME:AddMessage(msg .. " has been added to your collection.")
          end
      end)
  end
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
  loc_str .. COMM_FIELD_DELIM ..  marker.timestamp .. COMM_FIELD_DELIM ..  (marker.last_words or "") .. COMM_FIELD_DELIM ..  (marker.realm or "") .. COMM_FIELD_DELIM
  return comm_message
end

-- (name, map_id, map_pos, karma)
function TencodeMessageLite(marker)
  local loc_str = string.format("%.4f,%.4f", marker.posX, marker.posY)
  local karmaScore = (marker.karma ~= nil and marker.karma > 0) and "+" or "-"
  local comm_message = marker.user .. COMM_FIELD_DELIM .. marker.mapID .. COMM_FIELD_DELIM .. loc_str .. COMM_FIELD_DELIM .. karmaScore .. COMM_FIELD_DELIM
  return comm_message
end

function TdecodeMessageLite(msg)
  local values = {}
  for w in msg:gmatch("(.-)~") do table.insert(values, w) end
  if #values ~= 4 then
    -- Return something that causes the calling function to return on the isValidEntry check
    return nil
  end
  local user = values[1]
  local map_id = tonumber(values[2])
  local map_pos = values[3]
  local karma = values[4]
  if (user == nil or map_id == nil or map_pos == nil or karma == nil) then
    return nil
  end
  local location_ping_data = TLocationPing(user, map_id, map_pos, karma)
  return location_ping_data
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
        local numImportRecords = 0
        local numNewRecords = 0
        local singleRecord = nil
        if (startsWith(encodedData, "!T[")) then
            local start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words = parseEncodedHyperlink(encodedData)
            local player_name_short, realm = string.split("-", characterName)
            classID = tonumber(classID) > 0 and classID or nil
            raceID = tonumber(raceID) > 0 and raceID or nil
            sourceID = tonumber(sourceID) == -1 and nil or sourceID
            level = tonumber(level) == 0 and nil or level
            last_words = #last_words > 2 and fetchQuotedPart(last_words) or nil
            guild = #guild > 2 and fetchQuotedPart(guild) or nil
            local success, marker = ImportDeathMarker(realm or REALM, tonumber(mapID), nil, tonumber(posX), tonumber(posY), tonumber(timestamp), player_name_short, tonumber(level), tonumber(sourceID), tonumber(classID), tonumber(raceID), last_words, guild, nil)
            singleRecord = marker
            numImportRecords = numImportRecords + 1
            if (success) then
                numNewRecords = numNewRecords + 1
            end
            print("Tombstones imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
        else
            printDebug("Input data size is: " .. tostring(string.len(encodedData)))
            local decodedData = ld:DecodeForPrint(encodedData)
            printDebug("Decoded data size is: " .. tostring(string.len(decodedData)))
            local decompressedData = ld:DecompressDeflate(decodedData)
            printDebug("Decompressed data size is: " .. tostring(string.len(decompressedData)))
            local success, importedDeathRecords = ls:Deserialize(decompressedData)
            -- Example: Print the received data to the chat frame
            printDebug("Deserialization sucess: " .. tostring(success))
            numImportRecords = #importedDeathRecords
            printDebug("Imported records size is: " .. tostring(numImportRecords))
            --cleanImportRecords = DedupeImportDeathRecords(importedDeathRecords)
            printDebug("Deduped records size is: " .. tostring(numNewRecords))
            if(numImportRecords == 1) then
                singleRecord = importedDeathRecords[1]
            end
            for _, marker in ipairs(importedDeathRecords) do
                local success, _ = ImportDeathMarker(marker.realm, marker.mapID, marker.instID, marker.posX, marker.posY, marker.timestamp, marker.user, marker.level, marker.source_id, marker.class_id, marker.race_id, marker.last_words, marker.guild, marker.pvpKiller)
                if success then numNewRecords = numNewRecords + 1 end
            end
            ClearDeathMarkers(false) 
            UpdateWorldMapMarkers()
            print("Tombstones imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
        end
        if(singleRecord ~= nil) then
            if not WorldMapFrame:IsVisible() then
                ToggleWorldMap()
            end
            local overlayFrame = CreateFrame("Frame", nil, WorldMapFrame)
            overlayFrame:SetFrameStrata("FULLSCREEN")
            overlayFrame:SetFrameLevel(3) -- Set a higher frame level to appear on top of the map
            overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)   
            local mapID = singleRecord.mapID
            local posX = singleRecord.posX
            local posY = singleRecord.posY

            WorldMapFrame:SetMapID(mapID)
            
            overlayFrame.Texture = overlayFrame:CreateTexture(nil, "ARTWORK")
            overlayFrame.Texture:SetAllPoints()
            overlayFrame.Texture:SetTexture("Interface\\Icons\\Spell_Nature_WispSplode")

            hbdp:AddWorldMapIconMap("TombstonesImport", overlayFrame, mapID, posX, posY)
            C_Timer.After(3.0, function()
              hbdp:RemoveWorldMapIcon("TombstonesImport", overlayFrame)
              if overlayFrame ~= nil then
                overlayFrame:Hide()
                overlayFrame = nil 
              end
            end)
        end
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

local function HighlightMarkersForPlayer(characterName)
    local player_name_short, realm = string.split("-", characterName)
    local markerHighlights = {}
    
    for i, marker in ipairs(deathRecordsDB.deathRecords) do
        if (marker.user == player_name_short and (realm == nil or realm == marker.realm)) then
            local overlayFrame = CreateFrame("Frame", nil, WorldMapFrame)
            overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)
            overlayFrame.Texture = overlayFrame:CreateTexture(nil, "ARTWORK")
            overlayFrame.Texture:SetAllPoints()
            overlayFrame.Texture:SetTexture("Interface\\Icons\\Ability_fiegndead")
            table.insert(markerHighlights, overlayFrame)
            hbdp:AddWorldMapIconMap("TombstonesHighlight", overlayFrame, marker.mapID, marker.posX, marker.posY, 3)
        end
    end

    C_Timer.After(10.0, function()
        for _, markerHighlight in ipairs(markerHighlights) do
            hbdp:RemoveWorldMapIcon("TombstonesHighlight", markerHighlight)
            if (markerHighlight ~= nil) then
                markerHighlight:Hide()
                markerHighlight = nil
            end
        end
        markerHighlights = nil
    end)
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
    local text = dialogueBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    local linedBreakedLastWords = InsertLineBreaks(lastWords)
    dialogueBox.text = text
    text:SetPoint("TOPLEFT", dialogueBox, "TOPLEFT", 110, -10)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    local colorCode = marker.class_id or 0
    text:SetText(classColors[colorCode]..marker.user.."|r:\n\n\"" .. linedBreakedLastWords .. "\"")

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
    if (IsInInstance()) then
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
    if (marker.realm == REALM) then
        if marker.guild then 
            heroText = marker.user .. ", a " ..race_info.. " "..class_str .. " from " .. marker.guild .. ", perished here at level " .. level .. "."
        else 
            heroText = marker.user .. ", a " ..race_info.. " "..class_str .. ", perished here at level " .. level .. "."
        end
    else
        if marker.guild then 
            heroText = marker.user .. ", a " ..race_info.. " "..class_str .. " from " .. marker.guild .. " of the realm " .. marker.realm ..", perished here at level " .. level .. "."
        else
            heroText = marker.user .. ", a " ..race_info.. " "..class_str .. " of the realm " .. marker.realm .. ", perished here at level " .. level .. "."
        end
    end

    local timeText = "They fell on " .. timeOfDeathLong .. "."
    local fallenText = "They fell by unknown means."
    if (marker.source_id ~= nil) then
        local source_npc = id_to_npc[marker.source_id]
        local env_dmg = environment_damage[marker.source_id]
        if (source_npc ~= nil) then 
            fallenText = "They were killed by " .. source_npc .. "."
        elseif (env_dmg ~= nil) then
            if (marker.pvpKiller ~= nil) then
                fallenText = "They died from " .. env_dmg .. " against " .. marker.pvpKiller .. "."
            else
                fallenText = "They died from " .. env_dmg .. "."
            end
        end
    end


    -- PLAY THE HERO TEXT
    tombstoneFrame.infoText = tombstoneFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    tombstoneFrame.infoText:SetPoint("CENTER", 0, 120)
    tombstoneFrame.infoText:SetText(heroText.."\n"..timeText.."\n"..fallenText)

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
    local inInstance, _ = IsInInstance()
    if (deathRecordsDB.visiting == false or inInstance) then
        return
    end
    
    -- Handle player death event
    local playerInstance = C_Map.GetBestMapForUnit("player")
    if (playerInstance == nil) then return end
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()

    local closestMarker
    local closestDistance = math.huge

    local zoneMarkers = visitingZoneCache[playerInstance] or {}
    local totalZoneMarkers = #zoneMarkers or 0
    if (zoneMarkers == nil or totalZoneMarkers == 0) then
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
        if allowed and not marker.visited then
            if distance < closestDistance then
                closestMarker = marker
                closestDistance = distance
            end
        end
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
        --local randomIndex = math.random(1, #mapIDs)
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
        ImportDeathMarker(REALM, map_id, nil, posX, posY, timestamp, user, level, nil, class_id, race_id, last_words, nil, nil)
    end
end

local function TencodeMessageSelfReport(name, guild, source_id, race_id, class_id, level, instance_id, map_id, map_pos)
  if name == nil then return end
  -- if guild == nil then return end -- TODO 
  if tonumber(source_id) == nil then return end
  if tonumber(race_id) == nil then return end
  if tonumber(level) == nil then return end

  local loc_str = ""
  if map_pos then
    loc_str = string.format("%.4f,%.4f", map_pos.x, map_pos.y)
  end
  local comm_message = name .. COMM_FIELD_DELIM .. (guild or "") .. COMM_FIELD_DELIM .. source_id .. COMM_FIELD_DELIM .. race_id .. COMM_FIELD_DELIM .. class_id .. COMM_FIELD_DELIM .. level .. COMM_FIELD_DELIM .. (instance_id or "")  .. COMM_FIELD_DELIM .. (map_id or "") .. COMM_FIELD_DELIM .. loc_str .. COMM_FIELD_DELIM
  return comm_message
end

local function SetRecentMsg(...)
	local text, sn, LN, CN, p2, sF, zcI, cI, cB, unu, lI, senderGUID = ...
	if PLAYERGUID == nil then
		PLAYERGUID = UnitGUID("player")
	end

	if senderGUID == PLAYERGUID then
		lastWords = text
    printTrace("Last words set.")
		return true
	end
	return false
end

local function fletcher16(_player_data)
    local data = _player_data["name"] .. _player_data["guild"] .. _player_data["level"]
    local sum1 = 0
    local sum2 = 0
    for index=1,#data do
        sum1 = (sum1 + string.byte(string.sub(data,index,index))) % 255;
        sum2 = (sum2 + sum1) % 255;
    end
    return _player_data["name"] .. "-" .. bit.bor(bit.lshift(sum2,8), sum1)
end

local function selfDeathAlertPvp()
  if (not deathRecordsDB.broadcastPvpDeath) then return end
	if (lastDmgSourceID ~= -8 or lastPvpSourceName == nil) then return end
	local msg = lastPvpSourceName .. COMM_FIELD_DELIM

  table.insert(tombstones_pvp_death_queue, TS_COMM_COMMANDS["BROADCAST_PVP_DEATH"] .. COMM_COMMAND_DELIM .. msg)
end

local function selfDeathAlertLastWords()
	if lastWords == nil then return end
	local _, _, race_id = UnitRace("player")
	local _, _, class_id = UnitClass("player")
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if guildName == nil then guildName = "" end

	local player_data = TPlayerData(UnitName("player"), guildName, nil, nil, nil, UnitLevel("player"), nil, nil, nil, nil, nil)
	local checksum = fletcher16(player_data)
	local msg = checksum .. COMM_FIELD_DELIM .. lastWords .. COMM_FIELD_DELIM

  table.insert(deathlog_last_words_queue, COMM_COMMANDS["LAST_WORDS"] .. COMM_COMMAND_DELIM .. msg)
end

local function selfDeathAlert(death_source_id)
	local map = C_Map.GetBestMapForUnit("player")
	local instance_id = nil
	local position = nil
	if map then 
		position = C_Map.GetPlayerMapPosition(map, "player")
		local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(map, position)
	else
	  local _, _, _, _, _, _, _, _instance_id, _, _ = GetInstanceInfo()
	  instance_id = _instance_id
	end

	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	local _, _, race_id = UnitRace("player")
	local _, _, class_id = UnitClass("player")
	local source_id = -1
	if death_source_id then
	  source_id = death_source_id
	end
	if source_id == -1 and death_source_id and environment_damage[death_source_id] then
		source_id = death_source_id
	end

	local msg = TencodeMessageSelfReport(UnitName("player"), guildName, source_id, race_id, class_id, UnitLevel("player"), instance_id, map, position)
	if msg == nil then return end

  table.insert(deathlog_death_queue, COMM_COMMANDS["BROADCAST_DEATH_PING"] .. COMM_COMMAND_DELIM .. msg)
end

local function isPlayerMessageAllowed(player_name_short)
    if shadowbanned[player_name_short] then return false end
    if throttle_player[player_name_short] == nil then
        throttle_player[player_name_short] = 0
        return true
    end
    throttle_player[player_name_short] = throttle_player[player_name_short] + 1
    if throttle_player[player_name_short] > 1000 then
        print("Tombstones has shadowbanned "..player_name_short..".")
        shadowbanned[player_name_short] = 1
        return false
    end
    return true
end


--[[ Self Report Handling]]
--
local function TsendNextInQueue()
	if #deathlog_death_queue > 0 then 
		local dl_channel_num = GetChannelName(death_alerts_channel)
		if dl_channel_num == 0 then
		  TdeathlogJoinChannel()
		  return
		end
    
		local commMessage = deathlog_death_queue[1]
		CTL:SendChatMessage("BULK", COMM_NAME, commMessage, "CHANNEL", nil, dl_channel_num)
		table.remove(deathlog_death_queue, 1)
		return
	end

	if #deathlog_last_words_queue > 0 then 
		local dl_channel_num = GetChannelName(death_alerts_channel)
		if dl_channel_num == 0 then
		  TdeathlogJoinChannel()
		  return
		end

		local commMessage = deathlog_last_words_queue[1]
		CTL:SendChatMessage("BULK", COMM_NAME, commMessage, "CHANNEL", nil, dl_channel_num)
		table.remove(deathlog_last_words_queue, 1)
		return
	end
  
  if #tombstones_pvp_death_queue > 0 then
    local ts_channel_num = GetChannelName(tombstones_channel)
		if ts_channel_num == 0 then
		  TombstonesJoinChannel()
		  return
		end

		local commMessage = tombstones_pvp_death_queue[1]
		CTL:SendChatMessage("BULK", TS_COMM_NAME, commMessage, "CHANNEL", nil, ts_channel_num)
		table.remove(tombstones_pvp_death_queue, 1)
		return
  end
end
-- Note: We can only send at most 1 message per click, otherwise we get a taint
WorldFrame:HookScript("OnMouseDown", function(self, button)
  TsendNextInQueue()
end)
-- This binds any key press to send, including hitting enter to type or esc to exit game
local f  = CreateFrame("Frame", "Test", UIParent)
f:SetScript("OnKeyDown", TsendNextInQueue)
f:SetPropagateKeyboardInput(true)


--[[ Hyperlink Handlers ]]
--
local function filterFunc(_, event, msg, player, l, cs, t, flag, channelId, ...)
  local newMsg = "";
  local remaining = msg;
  local done;
  repeat
    local start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words = parseEncodedHyperlink(remaining)
    if(characterName) then
      newMsg = newMsg..remaining:sub(1, start-1);
      newMsg = newMsg.."|cff9d9d9d|Hgarrmission:tombstones:"..guild..":"..timestamp..":"..level..":"..classID..":"..raceID..":"..sourceID..":"..mapID..":"..posX..":"..posY..":"..last_words.."|h["..characterName.."'s Tombstone]|h|r";
      remaining = remaining:sub(finish + 1);
    else
      done = true;
    end
  until(done)
  if newMsg ~= "" then
      return false, newMsg, player, l, cs, t, flag, channelId, ...;
  end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)

hooksecurefunc("SetItemRef", function(link, text)
    if(startsWith(link, "garrmission:tombstones")) then    
        local _, _, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words = parseHyperlink(text)
        classID = tonumber(classID) > 0 and tonumber(classID) or nil
        raceID = tonumber(raceID) > 0 and tonumber(raceID) or nil
        sourceID = tonumber(sourceID) == -1 and nil or tonumber(sourceID)
        level = tonumber(level) == 0 and nil or tonumber(level)
        local decoded_last_words = decodeColorizedText(last_words)
        --Republish hyperlink logic
        if(IsShiftKeyDown()) then
            local editbox = GetCurrentKeyBoardFocus();
            if(editbox) then
                local encodedData = generateEncodedHyperlink(characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, fetchQuotedPart(last_words))
                editbox:Insert(encodedData);
            end
        else
            if(IsControlKeyDown()) then
                local player_name_short, realm = string.split("-", characterName) 
                decoded_last_words = #last_words > 2 and decoded_last_words or nil
                local success, marker = ImportDeathMarker(realm or REALM, tonumber(mapID), nil, tonumber(posX), tonumber(posY), tonumber(timestamp), player_name_short, level, sourceID, classID, raceID, fetchQuotedPart(decoded_last_words), guild, nil)
                local numImportRecords = 1
                local numNewRecords = 0
                if (success) then
                    numNewRecords = numNewRecords + 1
                end
                print("Tombstones imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
                return
            end
            -- Do the magic
            if not WorldMapFrame:IsVisible() then
                ToggleWorldMap()
            end
            WorldMapFrame:SetMapID(tonumber(mapID))
            --Create temporary map marker    
            local overlayFrame = CreateFrame("Frame", nil, WorldMapFrame)
            overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)

            overlayFrame.Texture = overlayFrame:CreateTexture(nil, "ARTWORK")
            overlayFrame.Texture:SetAllPoints()
            overlayFrame.Texture:SetTexture("Interface\\Icons\\Ability_fiegndead")
            
            -- Set a light tooltip for the hyperlinked Tombstone
            overlayFrame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                local class_str = classID and GetClassInfo(classID) or nil
                if (level ~= nil and level > 0 and classID ~= nil and classID > 0 and raceID ~= nil and raceID > 0) then
                    local race_info = C_CreatureInfo.GetRaceInfo(raceID) 
                    GameTooltip:SetText(characterName .. " - " .. race_info.raceName .. " " .. class_str .." - " .. level)
                elseif (level ~= nil and level > 0 and classID ~= nil and classID > 0 and (raceID == nil or raceID == 0)) then
                    GameTooltip:SetText(characterName .. " - " .. class_str .." - " .. level)
                elseif (level ~= nil and level > 0 and (classID == nil or classID == 0)) then
                    GameTooltip:SetText(characterName .. " - ? - " .. level)
                else
                    GameTooltip:SetText(characterName .. " - ? - ?")
                end
                if (guild ~= nil and guild ~= "") then
                    GameTooltip:AddLine("<"..guild..">", 0, 1, 0, true)
                end
                local date_str = date("%Y-%m-%d %H:%M:%S", tonumber(timestamp))
                GameTooltip:AddLine(date_str, .8, .8, .8, true)
                if (sourceID ~= nil) then
                    local source_id = id_to_npc[sourceID]
                    local env_dmg = environment_damage[sourceID]
                    if (source_id ~= nil) then 
                        GameTooltip:AddLine("Killed by: " .. source_id, 1, 0, 0, true) 
                    elseif (env_dmg ~= nil) then
                        GameTooltip:AddLine("Died from: " .. env_dmg, 1, 0, 0, true) 
                    end
                end
                if (decoded_last_words ~= nil and decoded_last_words ~= "\"\"") then
                    GameTooltip:AddLine(decoded_last_words, 1, 1, 1)
                end
                GameTooltip:Show()
            end)
            overlayFrame:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            hbdp:AddWorldMapIconMap("TombstonesHyperlink", overlayFrame, tonumber(mapID), tonumber(posX), tonumber(posY), 3)
            C_Timer.After(10.0, function()
                hbdp:RemoveWorldMapIcon("TombstonesHyperlink", overlayFrame)
                if overlayFrame ~= nil then
                  overlayFrame:Hide()
                  overlayFrame = nil 
                end
            end)
        end
    end
end);


--[[ Slash Command Handler ]]
--
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
    elseif command == "unrate" then
        if (not debug) then return end
        UnrateAllMarkers()
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    elseif command == "clear" then
        -- Clear all death records
        StaticPopup_Show("TOMBSTONES_CLEAR_CONFIRMATION")
    elseif command == "stress" then
        if (not debug) then return end
        StressGen(2000)
    elseif command == "dead" then
        if (not debug) then return end
        selfDeathAlert(lastDmgSourceID)
        selfDeathAlertLastWords()
        selfDeathAlertPvp()
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
        print("Tombstones has " .. #deathRecordsDB.deathRecords.. " records in total.")
        print("Tombstones saw " .. deathRecordCount .. " records this session.")
        print("You have visited " .. deathVisitCount .. " tombstones.")
        print("You have seen " .. ratingsSeenTotal .. " ratings broadcasted.")
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
    elseif command == "highlight" then
        local playerName = args
        HighlightMarkersForPlayer(playerName)
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
            HideDangerFrames()
        elseif argsArray[1] == "lock" then
            deathRecordsDB.dangerFrameUnlocked = false
            if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
            if zoneDangerFrame then zoneDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
        elseif argsArray[1] == "unlock" then
            deathRecordsDB.dangerFrameUnlocked = true
            if targetDangerFrame then targetDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
            if zoneDangerFrame then zoneDangerFrame:EnableMouse(deathRecordsDB.dangerFrameUnlocked) end
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
            print("Tombstones 'Known Death' filtering enabled: " .. tostring(TOMB_FILTERS["HAS_KNOWN_DEATH"]))
            print("Tombstones 'ClassID' filtering on: " .. tostring(TOMB_FILTERS["CLASS_ID"]))
            print("Tombstones 'RaceID' filtering on: " .. tostring(TOMB_FILTERS["RACE_ID"]))
            print("Tombstones 'Faction' filtering on: " .. tostring(TOMB_FILTERS["FACTION_ID"]))
            print("Tombstones 'Level Thresh' filtering on: " .. tostring(TOMB_FILTERS["LEVEL_THRESH"]))
            print("Tombstones 'Hour Thresh' filtering on: " .. tostring(TOMB_FILTERS["HOUR_THRESH"]))
            print("Tombstones 'Realms' filtering on: " .. tostring(TOMB_FILTERS["REALMS"]))
            print("Tombstones 'Rating' filtering on: " .. tostring(TOMB_FILTERS["RATING"]))
            print("Tombstones 'Guild' filtering on: " .. tostring(TOMB_FILTERS["GUILD"]))
            return
        elseif argsArray[1] == "reset" then
            TOMB_FILTERS["HAS_LAST_WORDS"] = false
            TOMB_FILTERS["HAS_KNOWN_DEATH"] = true
            TOMB_FILTERS["CLASS_ID"] = nil
            TOMB_FILTERS["RACE_ID"] = nil
            TOMB_FILTERS["FACTION_ID"] = nil
            TOMB_FILTERS["LEVEL_THRESH"] = 1
            TOMB_FILTERS["HOUR_THRESH"] = 720
            TOMB_FILTERS["REALMS"] = true
            TOMB_FILTERS["RATING"] = false
            TOMB_FILTERS["GUILD"] = 0
            if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
                optionsFrame:Hide()
            end
            ReloadUI()
        elseif argsArray[1] == "last_words" then
            TOMB_FILTERS["HAS_LAST_WORDS"] = true
        elseif argsArray[1] == "known_death" then
            TOMB_FILTERS["HAS_KNOWN_DEATH"] = true
        elseif argsArray[1] == "rating" then
            TOMB_FILTERS["RATING"] = true
        elseif argsArray[1] == "realms" then
            TOMB_FILTERS["REALMS"] = false
        elseif argsArray[1] == "level" then
            TOMB_FILTERS["LEVEL_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "hours" then
            TOMB_FILTERS["HOUR_THRESH"] = tonumber(argsArray[2])
        elseif argsArray[1] == "days" then
            TOMB_FILTERS["HOUR_THRESH"] = (tonumber(argsArray[2]) * 24)
        elseif argsArray[1] == "class" then
            local className = argsArray[2]
            if (className ~= nil) then
                TOMB_FILTERS["CLASS_ID"] = classNameToID[className]
            else
                print("Tombstones ERROR : Class not found.")
                print("Tombstones WARN : Try 'paladin','priest','warrior','rogue','mage','warlock','druid','shaman','hunter'.")
            end
        elseif argsArray[1] == "race" then
            local raceName = argsArray[2]
            if (raceName ~= nil) then
                TOMB_FILTERS["RACE_ID"] = raceNameToID[string.lower(raceName)]
            else
                print("Tombstones ERROR : Race not found.")
                print("Tombstones WARN : Try 'human','dwarf','gnome','night elf | nelf','orc','troll','undead','tauren'.")
            end
        elseif argsArray[1] == "faction" then
            local factionName = argsArray[2]
            if (factionName ~= nil) then
                TOMB_FILTERS["FACTION_ID"] = factionNameToFactionID[string.lower(factionName)]
            else
                print("Tombstones ERROR : Faction not found.")
                print("Tombstones WARN : Try 'alliance','horde'.")
            end
        elseif argsArray[1] == "guild" then
            TOMB_FILTERS["GUILD"] = 1
        end
        ClearDeathMarkers(true)
        UpdateWorldMapMarkers()
    elseif command == "deadly" then
        local argsArray = {}
        if args then
           for word in string.gmatch(args, "%S+") do
               table.insert(argsArray, word)
           end
        end
        if argsArray[1] == "npc" then
            PrintDeadliestNPCs()
        elseif argsArray[1] == "zone" then
            PrintDeadliestZones()
        elseif argsArray[1] == "env" then
            PrintDeadliestEnvironmentalDamages()
        elseif argsArray[1] == "class" then
            PrintDeadliestClasses()
        end
    elseif command == "sync" then
        BroadcastSyncRequest()
    elseif command == "usage" then
       -- Display command usage information
        print("Usage: /tombstones or /ts [show | hide | export | import | sync | prune | clear | info | icon_size {#SIZE} | max_render {#COUNT} | highlight {PLAYER}]")
        print("Usage: /tombstones or /ts [filter (info | reset | last_words | known_death | rating | hours {#HOURS} | days {#DAYS} | level {#LEVEL} | class {CLASS} | race {RACE})]")
        print("Usage: /tombstones or /ts [deadly (npc | zone | env | class)]")
        print("Usage: /tombstones or /ts [danger (show | hide | lock | unlock)]")
        print("Usage: /tombstones or /ts [visiting (info | on | off )]")
        print("Usage: /tombstones or /ts [zone (show | hide )]")
    else
        if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
            optionsFrame:Hide()
        else
            GenerateTombstonesOptionsFrame()
        end
    end
end
SlashCmdList["TOMBSTONES"] = SlashCommandHandler


--[[ Initialize Event Handlers ]]
--
local receivedChunks = {} -- Table to store the received chunks
local totalChunks = 0 -- Total number of expected chunks

function Tombstones:CHAT_MSG_ADDON(prefix, data_str, channel, sender_name_long)
  local player_name_short, _ = string.split("-", sender_name_long)
  local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
  -- TALLY RESPONSE HANDLING
  if (command == TS_COMM_COMMANDS["WHISPER_TALLY_REPLY"] and expectingTallyReply and prefix == TS_COMM_NAME and channel == "WHISPER") then
      -- CONSIDER: We only process messages we expect; and we only take 1 message; so, should be fine...
      --if not isPlayerMessageAllowed(player_name_short) then return end 
      TcountWhisperedRatingForMarkerFrom(msg, player_name_short)
  end
  -- RESPOND TO SYNC AVAILABILITY IF STILL VALID
  if (command == TS_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"] and prefix == TS_COMM_NAME and channel == "WHISPER") then
      printDebug("Receiving TS:TombstoneSyncAvailability from " .. player_name_short .. ".") 
      if (requestedSync == false) then return end -- We didn't request a sync? Spammer...
      if (agreedSender ~= nil) then return end -- We already have a sender
      local oldestTimestampInRequest, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
      oldestTimestampInRequest = tonumber(oldestTimestampInRequest)
      mapID = tonumber(mapID)
      local oldestTombstoneTimestamp = GetOldestTombstoneTimestamp(mapID) -- Ensure we are still in the same state and accepting to the same timestamp
      if (oldestTimestampInRequest == oldestTombstoneTimestamp) then 
          agreedSender = player_name_short
          agreedMapSender = mapID
          WhisperSyncAcceptanceTo(player_name_short, oldestTombstoneTimestamp, mapID)
      end
  -- RESPOND TO SYNC ACCEPTANCE; SEND THE DATA
  elseif (command == TS_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"] and prefix == TS_COMM_NAME and channel == "WHISPER") then
      printDebug("Receiving TS:TombstoneSyncAccept from " .. player_name_short .. ".") 
      if (deathRecordsDB.offerSync == false) then return end -- We are not offering sync service
      if (player_name_short ~= agreedReceiver) then return end -- The accepter is not the same player as we agreed upon? Spam / hacker.
      local timestampAgreedUpon, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
      timestampAgreedUpon = tonumber(timestampAgreedUpon)
      mapID = tonumber(mapID)
      if (mapID ~= agreedMapReceiver) then return end -- The acceptor has changed mapIDs on us? Reject sending.
      syncAccepted = true
      if (syncAvailabilityTimer ~= nil) then
          syncAvailabilityTimer:Cancel()
          syncAvailabilityTimer = nil
      end
      local numberOfTombstonesToFetch = 40
      local fetchedTombstones = GetTombstonesBeyondTimestamp(timestampAgreedUpon, numberOfTombstonesToFetch, mapID)
      printDebug("Sending "..#fetchedTombstones.." tombstones for map "..mapID..".")
      WhisperSyncDataTo(player_name_short, fetchedTombstones)
  -- RECEIVE THE CHUNKED DATA
  elseif (prefix == TS_COMM_NAME_SERIAL and channel == "WHISPER") then
      printDebug("Receiving TS:TombstoneSyncData from " .. player_name_short .. ".") 
      if (player_name_short ~= agreedSender) then
          printDebug("Rejecting "..player_name_short.." because non-agreed sender.")
          return
      end -- Sender is not the same player as we agreed upon? Spam / hacker.
      if (requestedSync == false) then
          printDebug("Rejecting "..player_name_short.." because did not request sync.")
          return
      end -- We didn't request a sync? Spammer...
      -- Parse the chunk info
      local chunkIndex, total, chunkData = data_str:match("(%d+)/(%d+):(.+)")

      if (tonumber(total) > 50 and not printedWarning) then
          print("Tombstones is receiving 50+ chunks. This may cause slowness.\nConsider reloading and ignoring " .. player_name_short .. " if this is griefing.")
          printedWarning = true
      end
      
      if chunkIndex and total and chunkData then
         chunkIndex = tonumber(chunkIndex)
         printDebug("Receiving chunk "..chunkIndex..".")
         total = tonumber(total)
         -- Init chunk table
         if not receivedChunks[player_name_short] then
            receivedChunks[player_name_short] = {}
         end
         -- Store chunk
         receivedChunks[player_name_short][chunkIndex] = chunkData
         -- Check if all chunks have been received
         if #receivedChunks[player_name_short] == total then
            local reconstructedData = table.concat(receivedChunks[player_name_short])
            -- Process the reconstructed data
            printDebug("Input data size is: " .. tostring(string.len(reconstructedData)))
            local decodedData = ld:DecodeForWoWAddonChannel(reconstructedData)
            printDebug("Decoded data size is: " .. tostring(string.len(decodedData)))
            local decompressedData = ld:DecompressDeflate(decodedData, { level = 3 })
            printDebug("Decompressed data size is: " .. tostring(string.len(decompressedData)))
            local success, importedDeathRecords = ls:Deserialize(decompressedData)
            importedDeathRecords = importedDeathRecords or {}
            local numImportRecords = #importedDeathRecords or 0
            local numNewRecords = 0
            local badRecords = false
            for _, marker in ipairs(importedDeathRecords) do
                if (marker.mapID == agreedMapSender) then
                    local success, _ = ImportDeathMarker(marker.realm, tonumber(marker.mapID), tonumber(marker.instID), tonumber(marker.posX), tonumber(marker.posY), tonumber(marker.timestamp), marker.user, tonumber(marker.level), tonumber(marker.source_id), tonumber(marker.class_id), tonumber(marker.race_id), marker.last_words, marker.guild, marker.pvpKiller)
                    if success then numNewRecords = numNewRecords + 1 end
                else
                    badRecords = true
                end
            end
            print("Tombstones imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
            if badRecords == true then
                print("Tombstones detected that "..player_name_short.." sent improper data. Consider ignoring if this is griefing.")
            end
            -- Clear the received chunks for this sender and reset agreedSender
            receivedChunks[player_name_short] = nil
            agreedSender = nil
            agreedMapSender = nil
            requestedSync = false
            printedWarning = false
         end
      end
  end
end

function Tombstones:CHAT_MSG_CHANNEL(data_str, sender_name_long, _, channel_name_long)
  local _, channel_name = string.split(" ", channel_name_long)
  local player_name_short, _ = string.split("-", sender_name_long)
  if channel_name == death_alerts_channel then
      local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
      if command == COMM_COMMANDS["BROADCAST_DEATH_PING"] then
          if not isPlayerMessageAllowed(player_name_short) then return end
          printDebug("Receiving HC:DeathLog death for " .. player_name_short .. ".")
          TdeathlogReceiveChannelMessage(player_name_short, msg)
      end
      if command == COMM_COMMANDS["LAST_WORDS"] then
          if not isPlayerMessageAllowed(player_name_short) then return end
          printDebug("Receiving HC:DeathLog last_words for " .. player_name_short .. ".")
          TdeathlogReceiveLastWords(player_name_short, msg)
      end
  elseif channel_name == tombstones_channel then
      local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
      if command == TS_COMM_COMMANDS["BROADCAST_PVP_DEATH"] then
          if not isPlayerMessageAllowed(player_name_short) then return end
          printDebug("Receiving TS:PvPDeathPing for " .. player_name_short .. ".")
          TReceivePvpDeath(player_name_short, msg)
      end
      if command == TS_COMM_COMMANDS["BROADCAST_TALLY_REQUEST"] and deathRecordsDB.rating then
          if not isPlayerMessageAllowed(player_name_short) then return end
          printDebug("Receiving TS:RatingRequest for " .. player_name_short .. ".")
          TwhisperRatingForMarkerTo(msg, player_name_short)
      end
      if command == TS_COMM_COMMANDS["BROADCAST_KARMA_PING"] and deathRecordsDB.rating then
          if not isPlayerMessageAllowed(player_name_short) then return end
          printDebug("Receiving TS:RatingPing from " .. player_name_short .. ".")
          
          local overlayFrame = CreateFrame("Button", nil, WorldMapButton)
          overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)
          local decodedLocationData = TdecodeMessageLite(msg)
          if (decodedLocationData == nil) then return end
          
          local mapID = decodedLocationData.map_id
          local posX, posY = strsplit(",", decodedLocationData["map_pos"], 2)
          local karma = decodedLocationData.karma
          local textureIcon = "Interface\\Icons\\inv_rosebouquet01"
          
          local overlayFrameTexture = overlayFrame:CreateTexture(nil, "ARTWORK")
          overlayFrameTexture:SetAllPoints()
          overlayFrameTexture:SetTexture(textureIcon)

          ratingsSeenCount = ratingsSeenCount + 1
          ratingsSeenTotal = ratingsSeenTotal + 1
          
          hbdp:AddWorldMapIconMap("TombstonesRatingPing", overlayFrame, tonumber(mapID), tonumber(posX), tonumber(posY), 3)
          miniButton.icon = textureIcon
          icon:Refresh("Tombstones")
          
          C_Timer.After(7.0, function()
              ratingsSeenCount = ratingsSeenCount - 1
              hbdp:RemoveWorldMapIcon("TombstonesRatingPing", overlayFrame)
              if overlayFrame ~= nil then
                  overlayFrame:Hide()
                  overlayFrame = nil 
              end
              if(ratingsSeenCount == 0) then
                miniButton.icon = "Interface\\Icons\\Ability_fiegndead"
                icon:Refresh("Tombstones")
              end
          end)
          if (decodedLocationData.name ~= nil and PLAYER_NAME == decodedLocationData.name) then
              -- Notification can only be seen once two minutes avoid spam.
              if (lastFlowersWarning < (time() - 120)) then 
                  lastFlowersWarning = time()
                  DEFAULT_CHAT_FRAME:AddMessage("You received flowers at your gravesite from "..player_name_short..".", 1, 1, 0)
              end
          end
      end
      if command == TS_COMM_COMMANDS["BROADCAST_TOMBSTONE_SYNC_REQUEST"] then
          printDebug("Receiving TS:TombstoneSyncRequest from " .. player_name_short .. ".")
          if (deathRecordsDB.offerSync == false) then return end -- We are not offering syncing service
          if (agreedReceiver ~= nil) then return end -- We already have an agreed upon receiver of sync
          local oldestTimestampInRequest, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
          oldestTimestampInRequest = tonumber(oldestTimestampInRequest)
          mapID = tonumber(mapID)
          local haveNewTombstones = haveTombstonesBeyondTimestamp(oldestTimestampInRequest, mapID) -- HANDLE MAPID IN BEYOND TIMESTAMP
          if haveNewTombstones then
              agreedReceiver = player_name_short
              agreedMapReceiver = mapID
              local randomDelay = math.random(0,5) -- Give random delay to create competition
              C_Timer.After(randomDelay, function()
                  WhisperSyncAvailabilityTo(player_name_short, oldestTimestampInRequest, mapID)
                  syncAvailabilityTimer = C_Timer.After(1, function()
                      if (syncAccepted == false and agreedReceiver ~= nil and agreedMapReceiver ~= nil) then
                          agreedReceiver = nil
                          agreedMapReceiver = nil
                          syncAccepted = false
                      end
                  end)
              end)
          else
              printDebug("You don't have newer Tombstones. Ignoring sync request.")
          end
      end
  end
end

local function OnUpdateMovementHandler(self, elapsed)
  if isPlayerMoving and (deathRecordsDB.visiting or deathRecordsDB.showDanger) then
    FlashWhenNearTombstone()
  end
end

function Tombstones:PLAYER_STOPPED_MOVING()
  isPlayerMoving = false
  if movementTimer then
    movementTimer:Cancel()
    movementTimer = nil
  end
  if(glowFrame ~= nil) then
    glowFrame:Hide()
    glowFrame = nil
  end
  -- Movement monitoring ended
  ActOnNearestTombstone()
end

function Tombstones:PLAYER_STARTED_MOVING()
  isPlayerMoving = true
  if not movementTimer and (deathRecordsDB.visiting or deathRecordsDB.showDanger) then
    movementTimer = C_Timer.NewTicker(movementUpdateInterval, OnUpdateMovementHandler)
  end
  -- Movement monitoring started
end

function Tombstones:PLAYER_TARGET_CHANGED()
  UnitTargetChange()
end

-- Event handler for ZONE_CHANGED_NEW_AREA event
local function ShowZoneSplashText()
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

function Tombstones:ZONE_CHANGED_NEW_AREA()
  ShowZoneSplashText()
end

function Tombstones:PLAYER_DEAD()
    if (_G["deathlogJoinChannel"] ~= nil or IsInInstance()) then
        -- Refuse self report if Hardcore add-on is present
        return
    end
    selfDeathAlert(lastDmgSourceID)
    selfDeathAlertLastWords()
    selfDeathAlertPvp()
end

function Tombstones:COMBAT_LOG_EVENT_UNFILTERED(...)
	local _, ev, _, source_guid, source_name, _, _, target_guid, _, _, _, environmental_type, _, _, _, _, _ = CombatLogGetCurrentEventInfo()
	if not (source_name == PLAYER_NAME) then
		if not (source_name == nil) then
			if (string.find(ev, "DAMAGE") ~= nil and target_guid == UnitGUID("player")) then
        local sourceIsPlayer = startsWith(source_guid, "Player-") 
        if (sourceIsPlayer) then
            lastDmgSourceID = -8 -- PVP
            lastPvpSourceName = source_name
        else
            lastDmgSourceID = npc_to_id[source_name]
        end
			end
		end
	end
	if ev == "ENVIRONMENTAL_DAMAGE" then
	  if target_guid == UnitGUID("player") then
	    if environmental_type == "Drowning" then
	      lastDmgSourceID = -2
	    elseif environmental_type == "Falling" then
	      lastDmgSourceID = -3
	    elseif environmental_type == "Fatigue" then
	      lastDmgSourceID = -4
	    elseif environmental_type == "Fire" then
	      lastDmgSourceID = -5
	    elseif environmental_type == "Lava" then
	      lastDmgSourceID = -6
	    elseif environmental_type == "Slime" then
	      lastDmgSourceID = -7
	    end
	  end
	end
end

function Tombstones:CHAT_MSG_SAY(...)
  SetRecentMsg(...)
end

function Tombstones:CHAT_MSG_PARTY(...)
  SetRecentMsg(...)
end

function Tombstones:CHAT_MSG_GUILD(...)
  SetRecentMsg(...)
end

function Tombstones:CHAT_MSG_RAID(...)
  SetRecentMsg(...)
end

function Tombstones:PLAYER_LOGOUT()
  -- Handle player logout event
  SaveDeathRecords()
end

function Tombstones:ADDON_LOADED(addonName)
  if addonName == ADDON_NAME then
      printDebug("Tombstones is loading...")
      
      C_Timer.After(5.0, function()
        TdeathlogJoinChannel()
        TombstonesJoinChannel()
      end)

      print("Tombstones loaded successfully!")
  end
end

function Tombstones:PLAYER_LOGIN()
  -- called during load screen
  LoadDeathRecords()
  MakeWorldMapButton()
  MakeMinimapButton()
  MakeInterfacePage()
  
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("PLAYER_TARGET_CHANGED")
  self:RegisterEvent("PLAYER_STARTED_MOVING")
  self:RegisterEvent("PLAYER_STOPPED_MOVING")
  self:RegisterEvent("PLAYER_DEAD")
  self:RegisterEvent("CHAT_MSG_CHANNEL")
	self:RegisterEvent("CHAT_MSG_ADDON")
  self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_SAY")
	self:RegisterEvent("CHAT_MSG_GUILD")
  self:RegisterEvent("CHAT_MSG_RAID")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function Tombstones:StartUp()
	-- the entry point of our addon
	-- called inside loading screen before player sees world, some api functions are not available yet.

	-- event handling helper
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)
	-- actually start loading the addon once player ui is loading
  self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
end


--[[ Start Addon ]]
--
Tombstones:StartUp()
