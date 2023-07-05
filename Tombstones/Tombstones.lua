-- Constants
local ADDON_NAME = "Tombstones"
local ADDON_CHANNEL = "Tombstones"
local DEATH_RECORD_WINDOW_SIZE = 5000
local REALM = GetRealmName()

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
local deathRecordCount = 0
local showMarkers = true
local debug = false
local splashFrame
local TOMB_FILTERS = {
  ["ENABLED"] = false,
  ["HAS_LAST_WORDS"] = false,
  ["CLASS_ID"] = nil,
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

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ac = LibStub("AceComm-3.0")

-- Register events
local addon = CreateFrame("Frame")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
addon:RegisterEvent("PLAYER_DEAD")
addon:RegisterEvent("PLAYER_LOGOUT")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("CHAT_MSG_SAY")
addon:RegisterEvent("CHAT_MSG_CHANNEL")
addon:RegisterEvent("CHAT_MSG_ADDON") -- Changed from CHAT_MSG_SAY

-- Add death marker function
local function AddDeathMarker(mapID, contID, posX, posY, timestamp, user, level, source_id, class_id)
    if mapID == nil then
       return
    end

    if deathRecordCount >= DEATH_RECORD_WINDOW_SIZE then
        table.remove(deathRecordsDB.deathRecords, 1)
        deathRecordCount = deathRecordCount - 1
    end

    local marker = { realm = REALM, mapID = mapID, contID = contID, posX = posX, posY = posY, timestamp = timestamp, user = user , level = level, last_words = last_words, source_id = source_id, class_id = class_id }
    table.insert(deathRecordsDB.deathRecords, marker)
    deathRecordCount = deathRecordCount + 1

    -- Place your custom code here to handle additional logic for the death marker

    printDebug("Death marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
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
        local mapCanvas = worldMapFrame.ScrollContainer.Child
        local mapCanvasScale = mapCanvas:GetEffectiveScale()
        local mapCanvasWidth, mapCanvasHeight = mapCanvas:GetSize()

        local filtering = TOMB_FILTERS["ENABLED"]
        local filter_has_words = TOMB_FILTERS["HAS_LAST_WORDS"]
        local filter_class = TOMB_FILTERS["CLASS_ID"]

        -- Clear existing death markers
        ClearDeathMarkers()

        -- Delay the display of death markers to ensure the map is fully loaded
        C_Timer.After(0.1, function()
            -- Display death markers on the world map
            for _, marker in ipairs(deathRecordsDB.deathRecords) do
                    local realm, mapID, contID, posX, posY, level, timestamp = marker.realm, marker.mapID, marker.contID, marker.posX, marker.posY, marker.level, marker.timestamp
                    -- Skip markers that are not in our realm
                    if (realm == nil or REALM == realm) then
 
                    -- Create the marker on the current continent's map
                    local markerMapButton = CreateFrame("Button", nil, WorldMapButton)
                    markerMapButton:SetSize(12, 12) -- Adjust the size of the marker as needed
                    markerMapButton:SetFrameStrata("FULLSCREEN") -- Set the frame strata to ensure it appears above other elements

                    markerMapButton.texture = markerMapButton:CreateTexture(nil, "BACKGROUND")
                    markerMapButton.texture:SetAllPoints(true)
                    if (level == nil) then
                      markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_fiegndead")
                    elseif (level <= 30) then
                      markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_Creature_Cursed_03")
                    elseif (level <= 59) then
                      markerMapButton.texture:SetTexture("Interface\\Icons\\Spell_holy_nullifydisease")
                    else
                      markerMapButton.texture:SetTexture("Interface\\Icons\\Ability_creature_cursed_05")
                    end
                    -- Set the tooltip text to the name of the player who died
                    markerMapButton:SetScript("OnEnter", function(self)
                       GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                       if (marker.level ~= nil and marker.class_id ~= nil) then
                           local class_str, _, _ = GetClassInfo(marker.class_id)
                           GameTooltip:SetText(marker.user .. " - " .. class_str .." - " .. marker.level)
                       elseif (marker.level ~= nil and marker.class_id == nil) then
                           GameTooltip:SetText(marker.user .. " - ? - " .. marker.level)
                       else
                           GameTooltip:SetText(marker.user .. " - ? - ?")
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

                    if (marker.last_words ~= nil) then
                       local borderTexture = markerMapButton:CreateTexture(nil, "OVERLAY")
                       borderTexture:SetAllPoints(markerMapButton)
                       borderTexture:SetTexture("Interface\\Cooldown\\ping4")
                       borderTexture:SetBlendMode("ADD")
                       borderTexture:SetVertexColor(1, 1, 0, 0.7) -- Set the border color to yellow (RGB values)
                    end

                    -- Check if the marker occurred within the last 24 hours
                    local currentTime = time()
                    local timeDifference = currentTime - timestamp
                    local secondsIn24Hours = 12 * 60 * 60 -- 24 hours in seconds
                    if timeDifference >= secondsIn24Hours then
                       markerMapButton.texture:SetVertexColor(.5, .5, .5, 0.5)
                    end
                    
                    -- Check if filters enabled
                    -- Add the marker to the current continent's map
                    if (filtering) then
                        local allow = true
                        if (filter_has_words == true) then
                           if (marker.last_words == nil) then allow = false end
                        end
                        if (filter_class ~= nil) then
                           if (marker.class_id ~= filter_class) then allow = false end
                        end
                        if (allow == true) then
                            hbdp:AddWorldMapIconMap("Tombstones", markerMapButton, mapID, posX, posY, HBD_PINS_WORLDMAP_SHOW_WORLD)
                        end
                    else
                        hbdp:AddWorldMapIconMap("Tombstones", markerMapButton, mapID, posX, posY, HBD_PINS_WORLDMAP_SHOW_WORLD)
                    end
                    end
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
            UpdateWorldMapMarkers()
        else
            mapButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Map_01") -- Set the default icon texture
            GameTooltip:SetText("Show Tombstones")
            showMarkers = false
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
    end
end

local function ClearDeathRecords()
    deathRecordsDB = {}
    deathRecordsDB.version = ADDON_SAVED_VARIABLES_VERSION
    deathRecordsDB.deathRecords = {}
    deathRecordsCount = 0
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
  AddDeathMarker(tonumber(decoded_player_data["map_id"]), tonumber(decoded_player_data["cont_id"]), tonumber(x), tonumber(y), tonumber(decoded_player_data["date"]), sender, tonumber(decoded_player_data["level"]), tonumber(decoded_player_data["source_id"]), tonumber(decoded_player_data["class_id"]))
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
    if (splashFrame ~= nil) then
      splashFrame:Hide()
      splashFrame = nil
    end

    local zoneName = GetRealZoneText()
    local currentMapID = C_Map.GetBestMapForUnit("player")
    local deathMarkersInZone = CountDeathMarkersInZone(currentMapID)
    local deathMarkersTotal = #deathRecordsDB.deathRecords
    local deathPercentage = 0.0
    if (deathMarkersTotal > 0) then
        deathPercentage = (deathMarkersInZone / #deathRecordsDB.deathRecords) * 100.0
    end

    -- Create and display the splash text frame
    splashFrame = CreateFrame("Frame", "SplashFrame", UIParent)
    splashFrame:SetSize(400, 200)
    splashFrame:SetPoint("CENTER", 0, 340)

    -- Add a texture
    splashFrame.texture = splashFrame:CreateTexture(nil, "BACKGROUND")
    splashFrame.texture:SetAllPoints(true)
    --splashFrame.texture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")

    -- Add a font string
    splashFrame.text = splashFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    splashFrame.text:SetPoint("CENTER", 0, 0)
    splashFrame.text:SetText(string.format("There are %d tombstones here.\n%.2f%% chance of death.", deathMarkersInZone, deathPercentage))
    splashFrame.text:SetTextColor(1, 1, 1) -- Set text color as needed

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

-- Function to count death markers in a zone based on mapID
function CountDeathMarkersInZone(mapID)
    local count = 0

    -- Iterate over the deathRecordsDB table to count markers in the specified zone
    for _, marker in pairs(deathRecordsDB.deathRecords) do
        local markerMapID = marker.mapID
        if markerMapID == mapID then
            count = count + 1
        end
    end

    return count
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
    elseif command == "debug" then
        debug = not debug
        print("Tombstones' debug mode is: ".. tostring(debug))
    elseif command == "info" then
        print("Tombstones has " .. deathRecordCount .. " records this session.")
        print("Tombstones has " .. #deathRecordsDB.deathRecords.. " records in total.")
    elseif command == "filter" then
        if args == "info" then
            print("Tombstone filtering enabled: " .. tostring(TOMB_FILTERS["ENABLED"]))
            print("Tombstone 'last words' filtering enabled: " .. tostring(TOMB_FILTERS["HAS_LAST_WORDS"]))
            print("Tombstone 'ClassID' filtering on: " .. tostring(TOMB_FILTERS["CLASS_ID"]))
        elseif args == "off" then
            TOMB_FILTERS["ENABLED"] = false
            TOMB_FILTERS["HAS_LAST_WORDS"] = false
            TOMB_FILTERS["CLASS_ID"] = nil
        elseif args == "last_words" then
            TOMB_FILTERS["ENABLED"] = true
            TOMB_FILTERS["HAS_LAST_WORDS"] = not TOMB_FILTERS["HAS_LAST_WORDS"]
        else
            local classID = classNameToID[string.lower(args)]
            if (classID ~= nil) then
                TOMB_FILTERS["ENABLED"] = true
                TOMB_FILTERS["CLASS_ID"] = classNameToID[args]
            else
                print("Class ID not found.")
            end
        end
    else
        -- Display command usage information
        print("Usage: /tombstones or /ts [show | hide | clear | info | filter (info|off|last_words|CLASS) | debug]")
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
