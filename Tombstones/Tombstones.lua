-- Constants
local ADDON_NAME = "Tombstones"
local ADDON_CHANNEL = "Tombstones"
local DEATH_RECORD_WINDOW_SIZE = 5000

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

-- Variables
local deathMarkers = {}
local deathRecordsDB
local deathRecordCount = 0

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ac = LibStub("AceComm-3.0")

-- Register events
local addon = CreateFrame("Frame")
addon:RegisterEvent("PLAYER_DEAD")
addon:RegisterEvent("PLAYER_LOGOUT")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("CHAT_MSG_SAY")
addon:RegisterEvent("CHAT_MSG_CHANNEL")
addon:RegisterEvent("CHAT_MSG_ADDON") -- Changed from CHAT_MSG_SAY

-- Add death marker function
local function AddDeathMarker(mapID, contID, posX, posY, timestamp, user)
    if deathRecordCount >= DEATH_RECORD_WINDOW_SIZE then
        table.remove(deathRecordsDB.deathRecords, 1)
        table.remove(deathMarkers, 1)
        deathRecordCount = deathRecordCount - 1
    end

    local marker = { mapID = mapID, contID = contID, posX = posX, posY = posY, timestamp = timestamp, user = user }
    table.insert(deathRecordsDB.deathRecords, marker)
    table.insert(deathMarkers, marker)
    deathRecordCount = deathRecordCount + 1

    -- Place your custom code here to handle additional logic for the death marker

    print("Death marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
end

local function ClearDeathMarkers()
    for _, marker in ipairs(deathMarkers) do
        if marker.texture then
            marker.texture:Hide()
            marker.texture = nil
        end
    end
end


local function UpdateWorldMapMarkers()
    local worldMapFrame = WorldMapFrame
    if worldMapFrame and worldMapFrame:IsVisible() then
        local mapCanvas = worldMapFrame.ScrollContainer.Child
        local mapCanvasScale = mapCanvas:GetEffectiveScale()
        local mapCanvasWidth, mapCanvasHeight = mapCanvas:GetSize()


        -- Clear existing death markers
        ClearDeathMarkers()

        -- Delay the display of death markers to ensure the map is fully loaded
        C_Timer.After(0.1, function()
            -- Display death markers on the world map
            local currentContinentID = C_Map.GetMapInfo(worldMapFrame:GetMapID()).parentMapID
            for _, marker in ipairs(deathMarkers) do
                local mapID, contID, posX, posY = marker.mapID, marker.contID, marker.posX, marker.posY

                -- Check if the marker is on a different continent
                    -- Create the marker on the current continent's map
                    local markerMapButton = CreateFrame("Button", nil, WorldMapButton)
                    markerMapButton:SetSize(20, 20) -- Adjust the size of the marker as needed
                    markerMapButton:SetFrameStrata("FULLSCREEN") -- Set the frame strata to ensure it appears above other elements

                    markerMapButton.texture = markerMapButton:CreateTexture(nil, "BACKGROUND")
                    markerMapButton.texture:SetAllPoints(true)
                    markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_Creature_Cursed_03")

                    -- Set the tooltip text to the name of the player who died
                    markerMapButton:SetScript("OnEnter", function(self)
                       GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                       GameTooltip:SetText("R.I.P. " .. marker.user)
                       GameTooltip:Show()
                    end)
                    markerMapButton:SetScript("OnLeave", function(self)
                       GameTooltip:Hide()
                    end)

                    -- Add the marker to the current continent's map
                    hbdp:AddWorldMapIconMap("Tombstones", markerMapButton, mapID, posX, posY, HBD_PINS_WORLDMAP_SHOW_WORLD)

                    marker.texture = markerMapButton
            end
        end)
    end
end

-- Hook into WorldMapFrame_OnShow and WorldMapFrame_OnHide functions to update markers
WorldMapFrame:HookScript("OnShow", function()
    UpdateWorldMapMarkers()
end)

WorldMapFrame:HookScript("OnHide", function()
    ClearDeathMarkers()
end)

local function SaveDeathRecords()
    _G["deathRecordsDB"] = deathRecordsDB
end

local function LoadDeathRecords()
    deathRecordsDB = _G["deathRecordsDB"]
    if not deathRecordsDB then
        deathRecordsDB = {}
        deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
        deathRecordsDB.deathRecords = {}
        deathRecordsCount = 0
        deathMarkers = {}
    else
        deathRecordsCount = #deathRecordsDB.deathRecords
        deathMarkers = deathRecordsDB.deathRecords
    end
end

function addon:SendMessage(message, distribution, target)
    local prefix = "Tombstones" -- Replace with your add-on's unique prefix
    local messageType = "MESSAGE_TYPE" -- Replace with your desired message type
    local distribution = "PARTY" -- Replace with your desired target (e.g., "PARTY", "RAID", "GUILD")
    self:SendCommMessage(prefix, message, distribution, nil)
    print("Sent message: "..message)
end

function addon:OnCommReceived(prefix, message, distribution, sender)
    local addonPrefix = "Tombstones" -- Replace with your add-on's unique prefix

    -- Check if the received message matches the prefix and message type
    if prefix == addonPrefix and distribution == "PARTY" and sender ~= UnitName("player") then
        -- Process the add-on message
        -- Implement your logic here
        print("Received add-on message: " .. message .. " from " .. sender)
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

function TdeathlogReceiveChannelMessage(sender, data)
  if data == nil then return end
  local decoded_player_data = TdecodeMessage(data)
  print("Tombstones decoded a DeathLog death for " .. sender .. "!")
  if sender ~= decoded_player_data["name"] then return end
  local x, y = strsplit(",", decoded_player_data["map_pos"],2)
  AddDeathMarker(tonumber(decoded_player_data["map_id"]), tonumber(decoded_player_data["cont_id"]), tonumber(x), tonumber(y), tonumber(decoded_player_data["date"]), sender)
end

function TdecodeMessage(msg)
  local values = {}
  for w in msg:gmatch("(.-)~") do table.insert(values, w) end
  if #values < 9 then
	-- Return something that causes the calling function to return on the isValidEntry check
	--print("Malformed deathlog message with " .. #values .. " data values")
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

-- Initialize
addon:SetScript("OnEvent", function(self, event, ...)
  local arg = { ... }
  if event == "ADDON_LOADED" then
    local addonName = ...
    if addonName == ADDON_NAME then
      print("Tombstones is loading...")

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
      print("Death detected. Making mark...")
      AddDeathMarker(mapID, contID, posX, posY, timestamp, UnitName("player"))
      self:SendMessage("DEATH|"..mapID.."|"..contID.."|"..posX.."|"..posY.."|"..timestamp)
    end
  elseif event == "PLAYER_LOGOUT" then
    -- Handle player logout event
    SaveDeathRecords()
  elseif event == "CHAT_MSG_SAY" then
        local message = ...
        if message == "dead" then
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
      print("Receiving DeathLog death ping for " .. player_name_short .. ".")
      TdeathlogReceiveChannelMessage(player_name_short, msg)
    end

    if command == COMM_COMMANDS["LAST_WORDS"] then
      local player_name_short, _ = string.split("-", arg[2])
      print("Receiving DeathLog last_words ping for " .. player_name_short .. ".")
    end
  end
end)