-- Constants
local PLAYER_NAME, _ = UnitName("player")
local REALM = GetRealmName()
local CTL = _G.ChatThrottleLib
local EN_COMM_NAME = "Engravings"
local EN_COMM_NAME_SERIAL = "EngravingsSer"
local EN_COMM_COMMANDS = {
  ["BROADCAST_ENGRAVING_PING"] = "6",
  ["BROADCAST_ENGRAVING_SYNC_REQUEST"] = "7",
  ["WHISPER_SYNC_AVAILABILITY"] = "8",
  ["WHISPER_SYNC_ACCEPT"] = "9",
  ["WHISPER_SYNC_BULK_DATA"] = "10",
}
local COMM_COMMAND_DELIM = "$"
local COMM_FIELD_DELIM = "~"
local templates = {
    "**** ahead",
    "Likely ****",
    "If only I had a ****...",
    "****, O ****",
    "Ahh, ****...",
    "No **** ahead",
    "First off, ****",
    "Didn't expect ****...",
    "Behold, ****!",
    "**** required ahead",
    "Seek ****",
    "Visions of ****...",
    "Offer ****",
    "****!",
    "Be wary of ****",
    "Still no ****...",
    "Could this be a ****?",
    "Praise the ****!",
    "****?",
    "Try ****",
    "Why is it always ****?",
    "Time for ****",
    "Let there be ****",
    "****..."
}
local templatesOrigToAlphaMappingTable
local templatesAlphaToOrigMappingTable
local categoryTable = {
  "Enemies",
  "People",
  "Things",
  "Battle Tactics",
  "Actions",
  "Situations",
  "Places",
  "Directions",
  "Body Parts",
  "Affinities",
  "Concepts",
  "Phrases",
}
local categoryOrigToAlphaMappingTable
local categoryAlphaToOrigMappingTable
local wordsTable = {
    [1] = {
        "enemy",
        "weak foe",
        "strong foe",
        "monster",
        "dragon",
        "boss",
        "sentry",
        "group",
        "pack",
        "decoy",
        "undead",
        "soldier",
        "knight",
        "cavalier",
        "archer",
        "sniper",
        "mage",
        "ordnance",
        "monarch",
        "lord",
        "demi-human",
        "outsider",
        "giant",
        "horse",
        "dog",
        "wolf",
        "rat",
        "beast",
        "bird",
        "raptor",
        "snake",
        "crab",
        "prawn",
        "octopus",
        "bug",
        "scarab",
        "slug",
        "wraith",
        "skeleton",
        "monstrosity",
        "ill-omened creature",
    },
    [2] = {
        "Tarnished",
        "warrior",
        "swordfighter",
        "knight",
        "samurai",
        "sorcerer",
        "cleric",
        "sage",
        "merchant",
        "teacher",
        "master",
        "friend",
        "lover",
        "old dear",
        "old codger",
        "angel",
        "fat coinpurse",
        "pauper",
        "good sort",
        "wicked sort",
        "plump sort",
        "skinny sort",
        "lovable sort",
        "pathetic sort",
        "strange sort",
        "nimble sort",
        "laggardly sort",
        "invisible sort",
        "unfathomable sort",
        "giant sort",
        "sinner",
        "thief",
        "liar",
        "dastard",
        "traitor",
        "pair",
        "trio",
        "noble",
        "aristocrat",
        "hero",
        "champion",
        "monarch",
        "lord",
        "god",
    },
    [3] = {
        "item",
        "necessary item",
        "precious item",
        "something",
        "something incredible",
        "treasure chest",
        "corpse",
        "coffin",
        "trap",
        "armament",
        "shield",
        "bow",
        "projectile weapon",
        "armor",
        "talisman",
        "skill",
        "sorcery",
        "incantation",
        "map",
        "material",
        "flower",
        "grass",
        "tree",
        "fruit",
        "seed",
        "mushroom",
        "tear",
        "crystal",
        "butterfly",
        "bug",
        "dung",
        "grace",
        "door",
        "key",
        "ladder",
        "lever",
        "lift",
        "spiritspring",
        "sending gate",
        "stone astrolabe",
        "Birdseye Telescope",
        "message",
        "bloodstain",
        "Erdtree",
        "Elden Ring",
    },
    [4] = {
        "close-quarters battle",
        "ranged battle",
        "horseback battle",
        "luring out",
        "defeating one-by-one",
        "taking on all at once",
        "rushing in",
        "stealth",
        "mimicry",
        "confusion",
        "pursuit",
        "fleeing",
        "summoning",
        "circling around",
        "jumping off",
        "dashing through",
        "brief respite",
    },
    [5] = {
        "attacking",
        "jump attack",
        "running attack",
        "critical hit",
        "two-handing",
        "blocking",
        "parrying",
        "guard counter",
        "sorcery",
        "incantation",
        "skill",
        "summoning",
        "throwing",
        "healing",
        "running",
        "rolling",
        "backstepping",
        "jumping",
        "crouching",
        "target lock",
        "item crafting",
        "gesturing",
    },
    [6] = {
        "morning",
        "noon",
        "evening",
        "night",
        "clear sky",
        "overcast",
        "rain",
        "storm",
        "mist",
        "snow",
        "patrolling",
        "procession",
        "crowd",
        "surprise attack",
        "ambush",
        "pincer attack",
        "beating to a pulp",
        "battle",
        "reinforcements",
        "ritual",
        "explosion",
        "high spot",
        "defensible spot",
        "climbable spot",
        "bright spot",
        "dark spot",
        "open area",
        "cramped area",
        "hiding place",
        "sniping spot",
        "recon spot",
        "safety",
        "danger",
        "gorgeous view",
        "detour",
        "hidden path",
        "secret passage",
        "shortcut",
        "dead end",
        "looking away",
        "unnoticed",
        "out of stamina",
    },
    [7] = {
        "high road",
        "checkpoint",
        "bridge",
        "castle",
        "fort",
        "city",
        "ruins",
        "church",
        "tower",
        "camp site",
        "house",
        "cemetery",
        "underground tomb",
        "tunnel",
        "cave",
        "evergaol",
        "great tree",
        "cellar",
        "surface",
        "underground",
        "forest",
        "river",
        "lake",
        "bog",
        "mountain",
        "valley",
        "cliff",
        "waterside",
        "nest",
        "hole",
    },
    [8] = {
        "east",
        "west",
        "south",
        "north",
        "ahead",
        "behind",
        "left",
        "right",
        "center",
        "up",
        "down",
        "edge",
    },
    [9] = {
        "head",
        "stomach",
        "back",
        "arms",
        "legs",
        "rump",
        "tail",
        "core",
        "fingers",
    },
    [10] = {
        "physical",
        "standard",
        "striking",
        "slashing",
        "piercing",
        "fire",
        "lightning",
        "magic",
        "holy",
        "poison",
        "toxic",
        "scarlet rot",
        "blood loss",
        "frost",
        "sleep",
        "madness",
        "death",
    },
    [11] = {
        "life",
        "Death",
        "light",
        "dark",
        "stars",
        "fire",
        "Order",
        "chaos",
        "joy",
        "wrath",
        "suffering",
        "sadness",
        "comfort",
        "bliss",
        "misfortune",
        "good fortune",
        "bad luck",
        "hope",
        "despair",
        "victory",
        "defeat",
        "research",
        "faith",
        "abundance",
        "rot",
        "loyalty",
        "injustice",
        "secret",
        "opportunity",
        "pickle",
        "clue",
        "friendship",
        "love",
        "bravery",
        "vigor",
        "fortitude",
        "confidence",
        "distracted",
        "unguarded",
        "introspection",
        "regret",
        "resignation",
        "futility",
        "on the brink",
        "betrayal",
        "revenge",
        "destruction",
        "recklessness",
        "calmness",
        "vigilance",
        "tranquility",
        "sound",
        "tears",
        "sleep",
        "depths",
        "dregs",
        "fear",
        "sacrifice",
        "ruin",
    },
    [12] = {
        "good luck",
        "look carefully",
        "listen carefully",
        "think carefully",
        "well done",
        "I did it!",
        "I've failed...",
        "here!",
        "not here!",
        "don't you dare!",
        "do it!",
        "I can't take this...",
        "don't think",
        "so lonely...",
        "here again...",
        "just getting started",
        "stay calm",
        "keep moving",
        "turn back",
        "give up",
        "don't give up",
        "help me...",
        "I don't believe it...",
        "too high up",
        "I want to go home...",
        "it's like a dream...",
        "seems familiar...",
        "beautiful...",
        "you don't have the right",
        "are you ready?",
    },
}
local wordsOrigToAlphaMappingTable
local wordsAlphaToOrigMappingTable
local conjunctions = {
    "and then",
    "or",
    "but",
    "therefore",
    "in short",
    "except",
    "by the way",
    "so to speak",
    "all the more",
    ",",
}
local conjunctionsOrigToAlphaMappingTable
local conjunctionsAlphaToOrigMappingTable

local tombstones_channel = "tsbroadcastchannel"
local tombstones_channel_pw = "tsbroadcastchannelpw"

-- Message Variables
local throttle_player = {}
local shadowbanned = {}
local engravings_readout_queue = {}
local engravings_sync_request_queue = {}
local engravings_sync_availability_queue = {}
local engravings_sync_accept_queue = {}
local engravings_sync_data_queue = {}
local syncAvailabilityTimer = nil
local agreedSender = nil
local agreedMapSender = nil
local agreedReceiver = nil
local agreedMapReceiver = nil
local syncAccepted = false
local requestedSync = false
local printedWarning = false

-- Variables
local engravingsDB
local miniButton
local icon
local engravingsZoneCache = {}
local phraseFrame
local engravingsRecordCount = 0
local engravingsSeenCount = 0
local engravingVisitCount = 0
local debug = false
local iconSize = 12
local isPlayerMoving = false
local movementUpdateInterval = 0.5 -- Update interval in seconds
local movementTimer = nil
local lastClosestEngraving
local glowFrame
local optionsFrame
local ENGR_FILTERS = {
  ["HOUR_THRESH"] = 720,
  ["REALMS"] = true,
}

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ls = LibStub("LibSerialize")
local ld = LibStub("LibDeflate")

-- Main Frame
local Engravings = CreateFrame("Frame")

local function printDebug(msg)
    if debug then
        print(msg)
    end
end

local function SaveEngravingRecords()
    engravingsDB.ENGR_FILTERS = ENGR_FILTERS
    _G["engravingsDB"] = engravingsDB
end

local function CacheEngraving(engraving)
    if engraving.mapID then
        if(engravingsZoneCache[engraving.mapID] == nil) then
            engravingsZoneCache[engraving.mapID] = { engraving }
        else
            table.insert(engravingsZoneCache[engraving.mapID], engraving)
        end
    end
    if engraving.visited and engraving.visited == true then
        engravingVisitCount = engravingVisitCount + 1
    end
end

local function LoadEngravingRecords()
    engravingsDB = _G["engravingsDB"]
    if not engravingsDB then
        engravingsDB = {}
        engravingsDB.version = ADDON_SAVED_VARIABLES_VERSION
        engravingsDB.engravingRecords = {}
        engravingsDB.participating = false
        engravingsDB.offerSync = false
        engravingsDB.minimapDB = {}
        engravingsDB.minimapDB.minimapPos = 204
        engravingsDB.minimapDB.hide = false
        engravingsDB.announcePlacement = true
        engravingsDB.reduceChatMsgs = false
    end
    if (engravingsDB.minimapDB == nil) then
        engravingsDB.minimapDB = {}
    end
    if (engravingsDB.minimapDB.minimapPos == nil) then
        engravingsDB.minimapDB.minimapPos = 204
    end
    if (engravingsDB.minimapDB.hide == nil) then
        engravingsDB.minimapDB.hide = false
    end
    if (engravingsDB.offerSync == nil) then
        engravingsDB.offerSync = false
    end
    if (engravingsDB.announcePlacement == nil) then
        engravingsDB.announcePlacement = true
    end
    if (engravingsDB.reduceChatMsgs == nil) then
        engravingsDB.reduceChatMsgs = false
    end
    if (engravingsDB.autoSync == nil) then
        engravingsDB.autoSync = true
    end
    if (engravingsDB.ENGR_FILTERS ~= nil) then
        ENGR_FILTERS = engravingsDB.ENGR_FILTERS
        if (ENGR_FILTERS["HOUR_THRESH"] <= 0) then
            ENGR_FILTERS["HOUR_THRESH"] = 720 -- 30 days in hours
        end
    end
    for _, engraving in ipairs(engravingsDB.engravingRecords) do
        CacheEngraving(engraving)  
    end
end

local function ClearEngravingRecords()
    engravingsDB.version = ADDON_SAVED_VARIABLES_VERSION
    engravingsDB.engravingRecords = {}
    engravingsRecordCount = 0
    _G["engravingsDB"] = engravingsDB
end

-- Define the confirmation dialog
StaticPopupDialogs["ENGRAVINGS_CLEAR_CONFIRMATION"] = {
    text = "Are you sure you want to delete all your engravings?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        ClearEngravingRecords()
        print("Engravings have been cleared.")
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function IsEngravingAllowedByFilters(engraving)
    if (engraving == nil) then
        return false
    end

    local currentTime = time()
    local allow = true

    -- Fetch filtering parameters
    local filter_realms = ENGR_FILTERS["REALMS"]
    local filter_hour = ENGR_FILTERS["HOUR_THRESH"]

    if (allow == true and filter_hour > 0) then
        if (engraving.timestamp ~= nil and engraving.timestamp <= (currentTime - (filter_hour * 60 * 60))) then allow = false end
    end
    if (allow == true and filter_realms and engraving.realm ~= REALM) then allow = false end
    return allow
end

local function IsNewRecordDuplicate(newRecord)
    local isDuplicate = false 

    -- Check if the imported record is "close enough" to existing record
    for index, existingRecord in ipairs(engravingsDB.engravingRecords) do
        if existingRecord.mapID == newRecord.mapID and
            existingRecord.instID == newRecord.instID and
            existingRecord.posX == newRecord.posX and
            existingRecord.posY == newRecord.posY and
            existingRecord.user == newRecord.user and
            existingRecord.realm == newRecord.realm and
            existingRecord.templ_index == newRecord.templ_index and
            existingRecord.cat_index == newRecord.cat_index and
            existingRecord.word_index == newRecord.word_index and
            existingRecord.conj_index == newRecord.conj_index and
            existingRecord.conj_templ_index == newRecord.conj_templ_index and 
            existingRecord.conj_cat_index == newRecord.conj_cat_index and
            existingRecord.conj_word_index == newRecord.conj_word_index then
            -- Ignore timestamp
            isDuplicate = true
            break
        end
    end

    return isDuplicate
end

local function GetOldestEngravingTimestamp(mapID)
    local oldest_engraving_timestamp = 0 
    
    local zoneEngravings = engravingsZoneCache[mapID] or {}
    local numRecords = #zoneEngravings or 0
    
    -- Iterate over the engraving records in reverse
    for index = numRecords, 1, -1 do
        local engraving = zoneEngravings[index]
        if (engraving.timestamp > oldest_engraving_timestamp and engraving.realm == REALM) then 
          oldest_engraving_timestamp = engraving.timestamp
        end
    end

    return oldest_engraving_timestamp
end

local function haveEngravingsBeyondTimestamp(request_timestamp, mapID)
    -- Get the number of engraving records
    local zoneEngravings = engravingsZoneCache[mapID] or {}
    local numRecords = #zoneEngravings or 0
    -- Iterate over the engraving records in reverse
    for index = numRecords, 1, -1 do
        local engraving = zoneEngravings[index]
        if (engraving.timestamp > request_timestamp and engraving.realm == REALM) then return true end
    end
    return false
end

local function GetEngravingsBeyondTimestamp(request_timestamp, max_to_fetch, mapID)
    local fetchedEngravings = {}
    -- Get the number of engraving records
    local zoneEngravings = engravingsZoneCache[mapID] or {}
    local numRecords = #zoneEngravings or 0
    -- Iterate over the engraving records in reverse
    for index = numRecords, 1, -1 do
        local engraving = zoneEngravings[index]
        if (engraving.timestamp > request_timestamp and engraving.realm == REALM) then 
            table.insert(fetchedEngravings, engraving)
        end
        if #fetchedEngravings >= max_to_fetch then
            break
        end
    end
    return fetchedEngravings
end

-- Add engraving marker function
local function ImportEngravingMarker(realm, user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index, timestamp)
    if (mapID == nil or posX == nil or posY == nil or templ_index == 0 or user == nil or timestamp > time()) then
        -- No location info. Or from the future. Useless.
        return false, nil
    end

    local engraving = { realm = realm, mapID = mapID, posX = posX, posY = posY, timestamp = timestamp, user = user , templ_index = templ_index, cat_index = cat_index, word_index = word_index, conj_index = conj_index, conj_templ_index = conj_templ_index, conj_cat_index = conj_cat_index, conj_word_index = conj_word_index }
    
    local isDuplicate = IsNewRecordDuplicate(engraving)
    if (not isDuplicate) then 
        table.insert(engravingsDB.engravingRecords, engraving)
        CacheEngraving(engraving)
        engravingsRecordCount = engravingsRecordCount + 1
        printDebug("Engraving marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
        return true, engraving
    end
    printDebug("Received a duplicate record. Ignoring.")
    return false, engraving
end

local function AddEngravingMarker(user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
    return ImportEngravingMarker(REALM, user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index, time())
end

local function decodePhrase(templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex) 
    if (templateIndex == 0) then
        return ""
    end
    
    local phrase = templates[templatesOrigToAlphaMappingTable[templateIndex]]
    
    if(categoryIndex == 0 or wordIndex == 0) then
        phrase, _ = phrase:gsub("(%*%*%*%*)", "")
        return phrase
    end

    phrase, _ = phrase:gsub("(%*%*%*%*)", wordsTable[categoryIndex][wordsOrigToAlphaMappingTable[categoryIndex][wordIndex]])
    
    if (conjunctionIndex == 0) then
        return phrase
    else
        phrase = phrase .. " " .. conjunctions[conjunctionsOrigToAlphaMappingTable[conjunctionIndex]]
    end
    
    if (conjTemplateIndex == 0 or conjCategoryIndex == 0 or conjWordIndex == 0) then
        return phrase
    end
        
    local conjPhrase = templates[templatesOrigToAlphaMappingTable[conjTemplateIndex]]

    conjPhrase, _ = conjPhrase:gsub("(%*%*%*%*)", wordsTable[conjCategoryIndex][wordsOrigToAlphaMappingTable[conjCategoryIndex][conjWordIndex]])
    return phrase.." "..conjPhrase
end

-- (name, map_id, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
function EencodeMessage(name, map_id, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
  local loc_str = string.format("%.4f,%.4f", posX, posY)
  local comm_message = name .. COMM_FIELD_DELIM .. (map_id or "") .. COMM_FIELD_DELIM .. (loc_str or "") .. COMM_FIELD_DELIM .. (templ_index or 0) .. COMM_FIELD_DELIM .. 
  (cat_index or 0) .. COMM_FIELD_DELIM .. (word_index or 0) .. COMM_FIELD_DELIM ..  (conj_index or 0) .. COMM_FIELD_DELIM .. (conj_templ_index or 0) .. COMM_FIELD_DELIM .. 
  (conj_cat_index or 0) .. COMM_FIELD_DELIM .. (conj_word_index or 0) .. COMM_FIELD_DELIM
  return comm_message
end

function EencodeMessageFromEngraving(engraving)
  return EencodeMessage(engraving.user, engraving.map_id, engraving.posX, engraving.posY, engraving.templ_index, engraving.cat_index, engraving.word_index, engraving.conj_index, engraving.conj_templ_index, engraving.conj_cat_index, engraving.conj_word_index)
end

-- (name, map_id, map_pos, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
function EdecodeMessage(msg)
  local values = {}
  for w in msg:gmatch("(.-)~") do table.insert(values, w) end
  if #values ~= 10 then
    -- Return something that causes the calling function to return on the isValidEntry check
    return nil
  end
  local name = values[1]
  local map_id = tonumber(values[2])
  local map_pos = values[3]
  local templ_index = tonumber(values[4])
  local cat_index = tonumber(values[5])
  local word_index = tonumber(values[6])
  local conj_index = tonumber(values[7])
  local conj_templ_index = tonumber(values[8])
  local conj_cat_index = tonumber(values[9])
  local conj_word_index = tonumber(values[10])
  
  if (name == nil or map_id == nil or map_pos == nil or templ_index == nil) then
    return nil
  end
  local engraving_loc_ping_data = ELocationPing(name, map_id, map_pos, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
  return engraving_loc_ping_data
end

local function generatePhrase(selectedTemplate, selectedWords, selectedConjunction, selectedConjTemplate, selectedConjWord)
    if (selectedTemplate == nil or selectedWords == nil) then
        return nil
    end
  
    local phrase = selectedTemplate
    phrase, _ = phrase:gsub("(%*%*%*%*)", selectedWords)
    
    if (selectedConjunction == nil) then
        return phrase
    else
        phrase = phrase .. " " .. selectedConjunction
    end
    
    if (selectedConjTemplate == nil or selectedConjWord == nil) then
        return phrase
    end
        
    local conjPhrase = selectedConjTemplate
    conjPhrase, _ = conjPhrase:gsub("(%*%*%*%*)", selectedConjWord)
    return phrase.." "..conjPhrase
end

local function CreatePhraseGenerationInterface()
    if (not engravingsDB.participating) then
        print("You are not participating in Tombstones:Engravings. Please enable via Interface Options.")
        return
    end
    if (phraseFrame ~= nil and phraseFrame:IsVisible()) then
        return
    elseif (phraseFrame ~= nil and not phraseFrame:IsVisible()) then
        phraseFrame:Show()
        return
    end
  
    phraseFrame = CreateFrame("Frame", "EngravingsPhraseGenerator", UIParent)--, "UIPanelDialogTemplate")
    phraseFrame:SetSize(280, 390)
    phraseFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    phraseFrame:SetFrameLevel(5500)
    phraseFrame:SetClampedToScreen(true)
    phraseFrame:SetPoint("CENTER")
    phraseFrame:SetMovable(true)
    phraseFrame:EnableMouse(true)
    phraseFrame:RegisterForDrag("LeftButton")
    phraseFrame:SetScript("OnDragStart", phraseFrame.StartMoving)
    phraseFrame:SetScript("OnDragStop", phraseFrame.StopMovingOrSizing)
    
    phraseFrame.t = phraseFrame:CreateTexture(nil, "BACKGROUND")
    phraseFrame.t:SetAllPoints()
    phraseFrame.t:SetColorTexture(0, 0, 0, 0.75)
    
    phraseFrame.c = CreateFrame("Button", "CloseButton", phraseFrame, "UIPanelCloseButton")
    phraseFrame.c:SetPoint("TOPRIGHT", 0, 0)

    phraseFrame.title = phraseFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    phraseFrame.title:SetPoint("TOP", 0, -10)
    phraseFrame.title:SetText("|cFFBF4500Make Engraving Phrase|r")
    
    local templateIndex = 0
    local categoryIndex = 0
    local wordIndex = 0
    local conjunctionIndex = 0
    local conjTemplateIndex = 0
    local conjCategoryIndex = 0
    local conjWordIndex = 0

    local templateDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    templateDropdown:SetPoint("TOPLEFT", 20, -50)
    UIDropDownMenu_SetWidth(templateDropdown, 150)
    local function InitializeTemplateDropdown(self, level, menuList)
        for index, template in ipairs(templates) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = template
            info.value = template
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, template)
                templateIndex = templatesAlphaToOrigMappingTable[index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(templateDropdown, InitializeTemplateDropdown)
    UIDropDownMenu_SetText(templateDropdown, "Select Template")

    local categoryDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    categoryDropdown:SetPoint("TOPLEFT", templateDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(categoryDropdown, 150)

    local wordDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    wordDropdown:SetPoint("TOPLEFT", categoryDropdown, "BOTTOMLEFT", 40, -5)
    UIDropDownMenu_SetWidth(wordDropdown, 150)
    
    -- Function to handle the word dropdown initialization
    local function InitializeWordDropdown(self, level, menuList)
        local category = UIDropDownMenu_GetSelectedValue(categoryDropdown) or 0
        local words = wordsTable[categoryAlphaToOrigMappingTable[category]] or {}
        for index, word in ipairs(words) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = word
            info.value = word
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, word)
                wordIndex = wordsAlphaToOrigMappingTable[categoryAlphaToOrigMappingTable[category]][index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(wordDropdown, InitializeWordDropdown)
    UIDropDownMenu_SetText(wordDropdown, "Select Word")
    
    -- Function to handle category dropdown initialization
    local function InitializeCategoryDropdown(self, level, menuList)
        for index, category in pairs(categoryTable) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = category
            info.value = index
            info.func = function()
                UIDropDownMenu_SetSelectedValue(categoryDropdown, index)
                UIDropDownMenu_SetText(categoryDropdown, category)
                UIDropDownMenu_Initialize(wordDropdown, InitializeWordDropdown)
                UIDropDownMenu_SetText(wordDropdown, "Select Word")
                wordIndex = 0
                categoryIndex = categoryAlphaToOrigMappingTable[index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(categoryDropdown, InitializeCategoryDropdown)
    UIDropDownMenu_SetText(categoryDropdown, "Select Category")

    local conjunctionDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjunctionDropdown:SetPoint("TOPLEFT", categoryDropdown, "BOTTOMLEFT", 0, -50)
    UIDropDownMenu_SetWidth(conjunctionDropdown, 150)
      -- Function to handle conjection dropdown initialization
    local function InitializeConjunctionDropdown(self, level, menuList)
        for index, conjunction in pairs(conjunctions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = conjunction
            info.value = conjunction
            info.func = function()
                UIDropDownMenu_SetSelectedValue(conjunctionDropdown, conjunction)
                UIDropDownMenu_SetText(conjunctionDropdown, conjunction)
                conjunctionIndex = conjunctionsAlphaToOrigMappingTable[index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(conjunctionDropdown, InitializeConjunctionDropdown)
    UIDropDownMenu_SetText(conjunctionDropdown, "Select Conjunction")
  
    local conjTemplateDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjTemplateDropdown:SetPoint("TOPLEFT", conjunctionDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(conjTemplateDropdown, 150)
    local function InitializeConjTemplateDropdown(self, level, menuList)
        for index, template in ipairs(templates) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = template
            info.value = template
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, template)
                conjTemplateIndex = templatesAlphaToOrigMappingTable[index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(conjTemplateDropdown, InitializeConjTemplateDropdown)
    UIDropDownMenu_SetText(conjTemplateDropdown, "Select Template")

    local conjCategoryDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjCategoryDropdown:SetPoint("TOPLEFT", conjTemplateDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(conjCategoryDropdown, 150)

    local conjWordDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjWordDropdown:SetPoint("TOPLEFT", conjCategoryDropdown, "BOTTOMLEFT", 40, -5)
    UIDropDownMenu_SetWidth(conjWordDropdown, 150)
     
    -- Function to handle the word dropdown initialization
    local function InitializeConjWordDropdown(self, level, menuList)
        local category = UIDropDownMenu_GetSelectedValue(conjCategoryDropdown) or 0
        local words = wordsTable[categoryAlphaToOrigMappingTable[category]] or {}
        for index, word in ipairs(words) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = word
            info.value = word
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, word)
                conjWordIndex = wordsAlphaToOrigMappingTable[categoryAlphaToOrigMappingTable[category]][index]
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end  
    UIDropDownMenu_Initialize(conjWordDropdown, InitializeConjWordDropdown)
    UIDropDownMenu_SetText(conjWordDropdown, "Select Word")
    
    -- Function to handle category dropdown initialization
    local function InitializeConjCategoryDropdown(self, level, menuList)
        for index, category in pairs(categoryTable) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = category
            info.value = index
            info.func = function()
                UIDropDownMenu_SetSelectedValue(conjCategoryDropdown, index)
                UIDropDownMenu_SetText(conjCategoryDropdown, category)
                UIDropDownMenu_Initialize(conjWordDropdown, InitializeConjWordDropdown)
                UIDropDownMenu_SetText(conjWordDropdown, "Select Word")
                conjCategoryIndex = categoryAlphaToOrigMappingTable[index]
                conjWordIndex = 0
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(conjCategoryDropdown, InitializeConjCategoryDropdown)
    UIDropDownMenu_SetText(conjCategoryDropdown, "Select Category")

    local generateButton = CreateFrame("Button", nil, phraseFrame, "GameMenuButtonTemplate")
    generateButton:SetPoint("BOTTOM", 0, 20)
    generateButton:SetText("Leave Engraving")
    generateButton:SetScript("OnClick", function()
        local selectedTemplate = UIDropDownMenu_GetSelectedValue(templateDropdown)
        local selectedWord = UIDropDownMenu_GetSelectedValue(wordDropdown)
        local selectedConjunction = UIDropDownMenu_GetSelectedValue(conjunctionDropdown)
        local selectedConjTemplate = UIDropDownMenu_GetSelectedValue(conjTemplateDropdown)
        local selectedConjWord = UIDropDownMenu_GetSelectedValue(conjWordDropdown)
        if(selectedTemplate == nil or selectedTemplate == 0) then
            phraseFrame:Hide()
            return
        end

        local phrase = generatePhrase(selectedTemplate, selectedWord, selectedConjunction, selectedConjTemplate, selectedConjWord)
        printDebug("Generated Phrase: ", phrase)
        printDebug("Generated Indexes: @"..templateIndex.."#"..categoryIndex.."$"..wordIndex.."+".. conjunctionIndex .."&"..conjTemplateIndex.."^"..conjCategoryIndex.."*"..conjWordIndex)
        
        local mapID = C_Map.GetBestMapForUnit("player")
        local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
        local posX, posY = playerPosition:GetXY()
        posX = string.format("%.4f", posX)
        posY = string.format("%.4f", posY)
        
        if (engravingsDB.announcePlacement) then 
            local engravingLink = "!E[\""..PLAYER_NAME.."\" "..time().." "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex .." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex .." "..mapID.." "..posX.." "..posY.."]"
            local say_msg = "I have left an engraving here: "..engravingLink
            CTL:SendChatMessage("BULK", EN_COMM_NAME, say_msg, "SAY", nil)
        end
        
        --(name, map_id, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
        if (engravingsDB.participating) then
            PlaySound(839)
            local channel_msg = EencodeMessage(PLAYER_NAME, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)   
            local channel_num = GetChannelName(tombstones_channel)
            CTL:SendChatMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["BROADCAST_ENGRAVING_PING"] .. COMM_COMMAND_DELIM .. channel_msg, "CHANNEL", nil, channel_num)
        end
        phraseFrame:Hide()
    end)
  
    -- Reset frame options OnHide
    phraseFrame:SetScript("OnHide", function(self)
        templateIndex = 0
        categoryIndex = 0
        wordIndex = 0
        conjunctionIndex = 0
        conjTemplateIndex = 0
        conjCategoryIndex = 0
        conjWordIndex = 0
        UIDropDownMenu_SetText(templateDropdown, "Select Template")
        UIDropDownMenu_SetText(wordDropdown, "Select Word")
        UIDropDownMenu_SetText(categoryDropdown, "Select Category")
        UIDropDownMenu_SetText(conjunctionDropdown, "Select Conjunction")
        UIDropDownMenu_SetText(conjTemplateDropdown, "Select Template")
        UIDropDownMenu_SetText(conjWordDropdown, "Select Word")
        UIDropDownMenu_SetText(conjCategoryDropdown, "Select Category")
    end)

    table.insert(UISpecialFrames, "EngravingsPhraseGenerator")
end

local function MakeInterfacePage()
			local interPanel = CreateFrame("FRAME", "EngravingsInterfaceOptions", UIParent)
			interPanel.name = "Engravings"
      interPanel.parent = "Tombstones"
      
      local titleText = interPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      titleText:SetPoint("TOPLEFT", 10, -10)
      local font, _, flags = titleText:GetFont()
      titleText:SetFont(font, 18, flags)
      titleText:SetText("Tombstones: |cFFBF4500Engravings|r |cFFFFFFFF(BETA)|r")
      titleText:SetTextColor(0.5, 0.5, 0.5)
      
      -- TOGGLE OPTIONS
      local participateToggle = CreateFrame("CheckButton", "Participate", interPanel, "UICheckButtonTemplate")
      participateToggle:SetPoint("TOPLEFT", 10, -40)
      participateToggle:SetChecked(engravingsDB.participating)
      local participateToggleText = participateToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      participateToggleText:SetPoint("LEFT", participateToggle, "RIGHT", 5, 0)
      participateToggleText:SetText("Participate")
      
      local mmToggle = CreateFrame("CheckButton", "MMB_Show", interPanel, "UICheckButtonTemplate")
      mmToggle:SetPoint("TOPLEFT", 10, -60)
      mmToggle:SetChecked(not engravingsDB.minimapDB["hide"])
      local mmToggleText = mmToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      mmToggleText:SetPoint("LEFT", mmToggle, "RIGHT", 5, 0)
      mmToggleText:SetText("Show Minimap button")
      
      local reduceChatMessageToggle = CreateFrame("CheckButton", "ReduceChatMsgs", interPanel, "UICheckButtonTemplate")
      reduceChatMessageToggle:SetPoint("TOPLEFT", 10, -80)
      reduceChatMessageToggle:SetChecked(engravingsDB.reduceChatMsgs)
      local reduceChatMessageToggleText = reduceChatMessageToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      reduceChatMessageToggleText:SetPoint("LEFT", reduceChatMessageToggle, "RIGHT", 5, 0)
      reduceChatMessageToggleText:SetText("Remove Engravings add-on messages on login")
      
      local offerSyncToggle = CreateFrame("CheckButton", "OfferSync", interPanel, "UICheckButtonTemplate")
      offerSyncToggle:SetPoint("TOPLEFT", 10, -100)
      offerSyncToggle:SetChecked(engravingsDB.offerSync)
      local offerSyncToggleText = offerSyncToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      offerSyncToggleText:SetPoint("LEFT", offerSyncToggle, "RIGHT", 5, 0)
      offerSyncToggleText:SetText("Offer Engravings sync service")
      
      local autoSyncToggle = CreateFrame("CheckButton", "AutoSync", interPanel, "UICheckButtonTemplate")
      autoSyncToggle:SetPoint("TOPLEFT", 10, -120)
      autoSyncToggle:SetChecked(engravingsDB.autoSync)
      local autoSyncToggleText = autoSyncToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      autoSyncToggleText:SetPoint("LEFT", autoSyncToggle, "RIGHT", 5, 0)
      autoSyncToggleText:SetText("Auto-sync on Zone change")
      
      local announcePlacementToggle = CreateFrame("CheckButton", "AnnouncePlacement", interPanel, "UICheckButtonTemplate")
      announcePlacementToggle:SetPoint("TOPLEFT", 10, -140)
      announcePlacementToggle:SetChecked(engravingsDB.announcePlacement)
      local announcePlacementToggleText = announcePlacementToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      announcePlacementToggleText:SetPoint("LEFT", announcePlacementToggle, "RIGHT", 5, 0)
      announcePlacementToggleText:SetText("Announce engravings in /say")
      
      local slashHelpText = interPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      slashHelpText:SetPoint("CENTER", interPanel, "CENTER", 0, 0)
      slashHelpText:SetText("/eng usage for slash command options.")
      
      local function ToggleOnClick(self)
          local isChecked = self:GetChecked()
          local toggleName = self:GetName()
          
          if isChecked then
              -- Perform actions for selected state
              if (toggleName == "Participate") then
                  engravingsDB.participating = true
                  engravingsDB.minimapDB["hide"] = false
                  icon:Show("Engravings")
                  offerSyncToggle:Enable()
              elseif (toggleName == "MMB_Show") then
                  engravingsDB.minimapDB["hide"] = false
                  icon:Show("Engravings")
              elseif (toggleName == "ReduceChatMsgs") then  
                  engravingsDB.reduceChatMsgs = true
              elseif (toggleName == "OfferSync") then
                  engravingsDB.offerSync = true
              elseif (toggleName == "AutoSync") then
                  engravingsDB.autoSync = true
              elseif (toggleName == "AnnouncePlacement") then
                  engravingsDB.announcePlacement = true
              end
          else
              -- Perform actions for unselected state
              if (toggleName == "Participate") then
                  engravingsDB.participating = false
                  engravingsDB.minimapDB["hide"] = true
                  icon:Hide("Engravings")
                  engravingsDB.offerSync = false
                  offerSyncToggle:SetChecked(false)
                  offerSyncToggle:Disable()
                  hbdp:RemoveAllMinimapIcons("EngravingsMM")
              elseif (toggleName == "MMB_Show") then
                  engravingsDB.minimapDB["hide"] = true
                  icon:Hide("Engravings")
              elseif (toggleName == "ReduceChatMsgs") then  
                  engravingsDB.reduceChatMsgs = false
              elseif (toggleName == "OfferSync") then
                  engravingsDB.offerSync = false
              elseif (toggleName == "AutoSync") then
                  engravingsDB.autoSync = false
              elseif (toggleName == "AnnouncePlacement") then
                  engravingsDB.announcePlacement = false
              end
          end
      end
      participateToggle:SetScript("OnClick", ToggleOnClick)
      mmToggle:SetScript("OnClick", ToggleOnClick)
      reduceChatMessageToggle:SetScript("OnClick", ToggleOnClick)
      offerSyncToggle:SetScript("OnClick", ToggleOnClick)
      autoSyncToggle:SetScript("OnClick", ToggleOnClick)
      announcePlacementToggle:SetScript("OnClick", ToggleOnClick)

      local category, layout = _G.Settings.RegisterCanvasLayoutCategory(interPanel, interPanel.name)
      _G.Settings.RegisterAddOnCategory(category)
end

local function BroadcastSyncRequest(custom_timestamp)
    if (IsInInstance()) then 
      print("Engravings cannot sync while in instance.")
      return 
    end
    local playerMap = C_Map.GetBestMapForUnit("player")
    if (playerMap == nil) then return end
    local oldest_engraving_timestamp = custom_timestamp or GetOldestEngravingTimestamp(playerMap)
    local channel_num = GetChannelName(tombstones_channel)
    requestedSync = true
    CTL:SendChatMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["BROADCAST_ENGRAVING_SYNC_REQUEST"]..COMM_COMMAND_DELIM..oldest_engraving_timestamp..COMM_FIELD_DELIM..playerMap, "CHANNEL", nil, channel_num)
end

local function QueueSyncRequest()
    if (IsInInstance()) then return end
    local playerMap = C_Map.GetBestMapForUnit("player")
    if (playerMap == nil) then return end
    local oldest_engraving_timestamp = GetOldestEngravingTimestamp(playerMap)
    local channel_num = GetChannelName(tombstones_channel)
    requestedSync = true
    table.insert(engravings_sync_request_queue, EN_COMM_COMMANDS["BROADCAST_ENGRAVING_SYNC_REQUEST"]..COMM_COMMAND_DELIM..oldest_engraving_timestamp..COMM_FIELD_DELIM..playerMap)
end

local function GenerateEngravingsOptionsFrame()
    if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
        return
    elseif (optionsFrame ~= nil and not optionsFrame:IsVisible()) then
        optionsFrame:Show()
        return
    end

    -- Create the main frame
    optionsFrame = CreateFrame("Frame", "EngravingsOptionsFrame", UIParent)
    optionsFrame:SetSize(360, 220)
    optionsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    optionsFrame:SetFrameLevel(6000)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:SetPoint("CENTER", 0, 80)
    
    optionsFrame.t = optionsFrame:CreateTexture(nil, "BACKGROUND")
    optionsFrame.t:SetAllPoints()
    optionsFrame.t:SetColorTexture(0, 0, 0, 0.75)

    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionsFrame.title:SetPoint("TOP", optionsFrame, "TOP", 0, -10)
    optionsFrame.title:SetText("|cFFBF4500Engravings Options|r")

    local optionText1 = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText1:SetPoint("TOP", optionsFrame, "TOPLEFT", 40, -40)
    optionText1:SetText("I want...")
    optionText1:SetTextColor(1, 1, 1)

    -- TOGGLE OPTIONS
    local toggle1 = CreateFrame("CheckButton", "Visiting", optionsFrame, "UICheckButtonTemplate")
    toggle1:SetPoint("TOPLEFT", 20, -60)
    toggle1:SetChecked(engravingsDB.participating)
    local toggle1Text = toggle1:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    toggle1Text:SetPoint("LEFT", toggle1, "RIGHT", 5, 0)
    toggle1Text:SetText("To visit and decode engravings.")

    -- TOGGLE OPTIONS

    -- Callback function for toggle button click event
    local function ToggleOnClick(self)
        local isChecked = self:GetChecked()
        local toggleName = self:GetName()
        
        if isChecked then
            -- Perform actions for selected state
            if (toggleName == "Visiting") then
                engravingsDB.participating = true
                engravingsDB.minimapDB["hide"] = false
                icon:Show("Engravings")
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "Visiting") then
                engravingsDB.participating = false
                engravingsDB.minimapDB["hide"] = true
                icon:Hide("Engravings")
                engravingsDB.offerSync = false
                hbdp:RemoveAllMinimapIcons("EngravingsMM")
            end
        end
    end

    -- Assign the callback function to toggle buttons' OnClick event
    toggle1:SetScript("OnClick", ToggleOnClick)

    optionsFrame.c = CreateFrame("Button", "CloseButton", optionsFrame, "UIPanelCloseButton")
    optionsFrame.c:SetPoint("TOPRIGHT", 0, 0)

    local filtersText = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    filtersText:SetPoint("TOP", optionsFrame, "TOP", 0, -100)
    filtersText:SetText("|cFFBF4500Filters|r")

    local optionText2 = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionText2:SetPoint("TOP", filtersText, "TOPLEFT", -35, -30)
    optionText2:SetText("I only want to see Engravings that...")
    optionText2:SetTextColor(1, 1, 1)

    local realmsOption = CreateFrame("CheckButton", "Realms", optionsFrame, "UICheckButtonTemplate")
    realmsOption:SetPoint("TOPLEFT", 20, -150)
    realmsOption:SetChecked(ENGR_FILTERS["REALMS"])
    local realmsOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    realmsOptionText:SetPoint("LEFT", realmsOption, "RIGHT", 5, 0)
    realmsOptionText:SetText("Are from this realm.")

    local hourSlider = CreateFrame("Slider", "HourSlider", optionsFrame, "OptionsSliderTemplate")
    hourSlider:SetWidth(180)
    hourSlider:SetHeight(20)
    hourSlider:SetPoint("TOPLEFT", 20, -180)
    hourSlider:SetOrientation("HORIZONTAL")
    hourSlider:SetMinMaxValues(0.5, 30) -- Set the minimum and maximum values for the slider
    hourSlider:SetValueStep(0.5) -- Set the step value for the slider
    hourSlider:SetValue(30.5 - roundNearestHalf(ENGR_FILTERS["HOUR_THRESH"]/24)) -- Set the default value for the slider
    local hourSliderOptionText = realmsOption:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hourSliderOptionText:SetPoint("LEFT", hourSlider, "RIGHT", 10, 0)
    hourSliderOptionText:SetText("Days old, at most.")
    -- Add labels for minimum and maximum values
    hourSlider.Low:SetText("30")
    hourSlider.High:SetText("0.5")

    -- Add a label for the current value
    local hourText = hourSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hourText:SetPoint("TOP", hourSlider, "BOTTOM", 0, 0)
    hourText:SetText(roundNearestHalf(ENGR_FILTERS["HOUR_THRESH"]/24)) -- Set the initial value
    hourSlider.hourText = hourText

    -- Set the OnValueChanged callback function
    hourSlider:SetScript("OnValueChanged", function(self, value)
        value = 30.5 - roundNearestHalf(value)
        hourText:SetText(string.format("%.1f", value))
    end)

    hourSlider:SetScript("OnMouseUp", function(self)
        local value = 30.5 - roundNearestHalf(hourSlider:GetValue())
        ENGR_FILTERS["HOUR_THRESH"] = value * 24
        hbdp:RemoveAllMinimapIcons("EngravingsMM")
        lastClosestEngraving = nil
    end)

        -- Callback function for toggle button click event
    local function ToggleFilter(self)
        local isChecked = self:GetChecked()
        local toggleName = self:GetName()
        
        if isChecked then
            -- Perform actions for selected state
            if (toggleName == "Realms") then
                ENGR_FILTERS["REALMS"] = true
            end
        else
            -- Perform actions for unselected state
            if (toggleName == "Realms") then
                ENGR_FILTERS["REALMS"] = false
            end
        end
        hbdp:RemoveAllMinimapIcons("EngravingsMM")
        lastClosestEngraving = nil
    end

    realmsOption:SetScript("OnClick", ToggleFilter)

    optionsFrame:SetMovable(true)
    optionsFrame:SetClampedToScreen(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
    table.insert(UISpecialFrames, "EngravingsOptionsFrame")
end

local function MakeMinimapButton()
    -- Minimap button click function
    local function MiniBtnClickFunc(btn)
        if (IsControlKeyDown()) then
          BroadcastSyncRequest(nil)
          -- Set minimap icon to indicate sync running
          miniButton.icon = "Interface\\Icons\\inv_misc_eye_01"
          icon:Refresh("Engravings")
          C_Timer.After(10.0, function()
              miniButton.icon = "Interface\\Icons\\inv_misc_rune_04"
              icon:Refresh("Engravings")
          end)
        elseif (IsShiftKeyDown()) then
          if (phraseFrame ~= nil and phraseFrame:IsVisible()) then
              phraseFrame:Hide()
          else
              CreatePhraseGenerationInterface()
          end
        else
          if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
              optionsFrame:Hide()
          else
              GenerateEngravingsOptionsFrame()
          end
        end
    end
    -- Create minimap button using LibDBIcon
    miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("Engravings", {
        type = "data source",
        text = "Engravings",
        icon = "Interface\\Icons\\Inv_misc_rune_04",
        OnClick = function(self, btn)
            MiniBtnClickFunc(btn)
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:AddLine("Engravings")
            tooltip:AddLine("|cFFBF4500records:|r "..tostring(#engravingsDB.engravingRecords))
            tooltip:AddLine("|cffffffffctrl-click to sync|r")
            tooltip:AddLine("|cffffffffshift-click to make|r")
        end,
    })

    icon = LibStub("LibDBIcon-1.0", true)
    icon:Register("Engravings", miniButton, engravingsDB.minimapDB)
    
    if (not engravingsDB.participating) then
        icon:Hide("Engravings")
    end
end

local function ReadOutNearestEngraving(engraving)
    
    local user = engraving.user
    if(engraving.realm ~= nil and engraving.realm ~= REALM) then
       user = user.."-"..engraving.realm
    end
    
    -- Create a frame
    local engravingFound = CreateFrame("Frame", "EngravingFound", UIParent)
    engravingFound:SetSize(GetScreenWidth(), 2048)  -- Set the size of the frame
    engravingFound:SetPoint("TOP", 0, 700) -- Set the position of the frame
    local engravingFoundTexture = engravingFound:CreateTexture(nil, "BACKGROUND")
    engravingFoundTexture:SetAllPoints() -- Fill the entire frame with the texture
    engravingFoundTexture:SetTexture("Interface\\AddOns\\Tombstones\\artwork\\engraving_found.tga")
    engravingFound:Show()
    
        -- Apply fade-out animation to the splash frame
    engravingFound.fade = engravingFound:CreateAnimationGroup()
    local fadeIn = engravingFound.fade:CreateAnimation("Alpha")
    fadeIn:SetDuration(0.5) -- Adjust the delay duration as desired
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetOrder(1)
    local delay = engravingFound.fade:CreateAnimation("Alpha")
    delay:SetDuration(1) -- Adjust the delay duration as desired
    delay:SetFromAlpha(1)
    delay:SetToAlpha(1)
    delay:SetOrder(2)
    local fadeOut = engravingFound.fade:CreateAnimation("Alpha")
    fadeOut:SetDuration(0.5) -- Adjust the fade duration as desired
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetOrder(3)
    engravingFound.fade:SetScript("OnFinished", function(self)
        if (engravingFound ~= nil) then
            engravingFound:Hide()
            engravingFound = nil
        end
    end)
    engravingFound:Show()
    engravingFound.fade:Play()

    -- engraving = { realm , mapID, posX , posY, timestamp, user , templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index }
    local engravingLink = "!E[\""..user.."\" "..engraving.timestamp.." "..engraving.templ_index.." "..engraving.cat_index.." "..engraving.word_index.." "..engraving.conj_index.." "..engraving.conj_templ_index.." "..engraving.conj_cat_index.." "..engraving.conj_word_index.." "..engraving.mapID.." "..engraving.posX.." "..engraving.posY.."]"
    local engravingHyperLink = "|cFFBF4500|Hgarrmission:engravings:"..engraving.templ_index..":"..engraving.cat_index..":"..engraving.word_index..":"..engraving.conj_index..":"..engraving.conj_templ_index..":"..engraving.conj_cat_index..":"..engraving.conj_word_index..":"..engraving.timestamp..":"..engraving.mapID..":"..engraving.posX..":"..engraving.posY.."|h["..user.."'s Engraving]|h|r"
    --local say_msg = "You found an engraving on the ground: "..engravingHyperLink

    --SendChatMessage(say_msg, "SAY")
    
    local phrase = decodePhrase(engraving.templ_index, engraving.cat_index, engraving.word_index, engraving.conj_index, engraving.conj_templ_index, engraving.conj_cat_index, engraving.conj_word_index)
    if (engravingsDB.announcePlacement) then
        --local firstSayMessage = "I found an engraving on the ground: "..engravingHyperLink
        local sayReadoutMessage = user.."'s engraving reads: \""..phrase.."\""
        --table.insert(engravings_readout_queue, { msg = firstSayMessage})
        table.insert(engravings_readout_queue, {msg = sayReadoutMessage})
        --CTL:SendChatMessage("BULK", EN_COMM_NAME, user.."'s engraving reads: \""..phrase.."\"", "SAY", nil)
    end
    --DEFAULT_CHAT_FRAME:AddMessage("You found an engraving on the ground: "..engravingHyperLink, 1, 1, 0)
    PlaySound(1194)
    C_Timer.After(0.5, function()
        DEFAULT_CHAT_FRAME:AddMessage("You found an engraving on the ground: "..engravingHyperLink, 1, 1, 0)
    end)
    C_Timer.After(1, function()
        DEFAULT_CHAT_FRAME:AddMessage(user.."'s engraving reads: \""..phrase.."\"", 1, 1, 0)
    end)
    

--    
--        CTL:SendChatMessage("BULK", EN_COMM_NAME, "It reads: \""..phrase.."\".", "SAY", nil)
--    end)
end


--[[ Hyperlink Handlers ]]
--
local function engravingsFilterFunc(_, event, msg, player, l, cs, t, flag, channelId, ...)
  local newMsg = "";
  local remaining = msg;
  local done;
  repeat
    local start, finish, characterName, timestamp, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY = remaining:find("!E%[\"%s*([^%]\"]*)\" (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) ([%d%.]+) ([%d%.]+)%]")
    if(characterName) then
      newMsg = newMsg..remaining:sub(1, start-1);
      newMsg = newMsg.."|cFFBF4500|Hgarrmission:engravings:"..templateIndex..":"..categoryIndex..":"..wordIndex..":"..conjunctionIndex..":"..conjTemplateIndex..":"..conjCategoryIndex..":"..conjWordIndex..":"..timestamp..":"..mapID..":"..posX..":"..posY.."|h["..characterName.."'s Engraving]|h|r";
      remaining = remaining:sub(finish + 1);
    else
      done = true;
    end
  until(done)
  if newMsg ~= "" then
      return false, newMsg, player, l, cs, t, flag, channelId, ...;
  end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", engravingsFilterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", engravingsFilterFunc)

hooksecurefunc("SetItemRef", function(link, text)
    if(startsWith(link, "garrmission:engravings")) then    
        local start, finish, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, timestamp, mapID, posX, posY, characterName = text:find("|cFFBF4500|Hgarrmission:engravings:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):([%d%.]+):([%d%.]+)|h%[(.*)'s Engraving%]|h|r");
        templateIndex = tonumber(templateIndex) > 0 and tonumber(templateIndex) or 0
        categoryIndex = tonumber(categoryIndex) > 0 and tonumber(categoryIndex) or 0
        wordIndex = tonumber(wordIndex) > 0 and tonumber(wordIndex) or 0
        conjunctionIndex = tonumber(conjunctionIndex) > 0 and tonumber(conjunctionIndex) or 0
        conjTemplateIndex = tonumber(conjTemplateIndex) > 0 and tonumber(conjTemplateIndex) or 0
        conjCategoryIndex = tonumber(conjCategoryIndex) > 0 and tonumber(conjCategoryIndex) or 0
        conjWordIndex = tonumber(conjWordIndex) > 0 and tonumber(conjWordIndex) or 0
        timestamp = tonumber(timestamp) == 0 and nil or tonumber(timestamp)
        mapID = tonumber(mapID) == 0 and nil or tonumber(mapID)
        posX = tonumber(posX) == 0 and nil or tonumber(posX)
        posY = tonumber(posY) == 0 and nil or tonumber(posY)
        --Republish hyperlink logic
        if(IsShiftKeyDown()) then
            local editbox = GetCurrentKeyBoardFocus();
            if(editbox) then
                editbox:Insert("!E[\""..characterName.."\" "..timestamp.." "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex.." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex.." "..mapID.." "..posX.." "..posY.."]");
            end
        else
            if(IsControlKeyDown()) then
                local player_name_short, realm = string.split("-", characterName)
                realm = realm ~= nil and realm or REALM
                local success, engraving = ImportEngravingMarker(realm, player_name_short, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, timestamp)
                local numImportRecords = 1
                local numNewRecords = 0
                if (success) then
                    numNewRecords = numNewRecords + 1
                end
                print("Engravings imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
                return
            end
            -- Do the magic
            --local phrase = decodePhrase(templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)
            --DEFAULT_CHAT_FRAME:AddMessage(characterName.."'s engraving reads: \""..phrase.."\"", 1, 1, 0)
            
            if not WorldMapFrame:IsVisible() then
                ToggleWorldMap()
            end
            local overlayFrame = CreateFrame("Frame", nil, WorldMapFrame)
            --overlayFrame:SetFrameStrata("FULLSCREEN")
            --overlayFrame:SetFrameLevel(3) -- Set a higher frame level to appear on top of the map
            overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)

            WorldMapFrame:SetMapID(mapID)
            
            overlayFrame.Texture = overlayFrame:CreateTexture(nil, "ARTWORK")
            overlayFrame.Texture:SetAllPoints()
            overlayFrame.Texture:SetTexture("Interface\\Icons\\Inv_misc_rune_04")

            hbdp:AddWorldMapIconMap("EngravingPing", overlayFrame, mapID, posX, posY, 3)
            C_Timer.After(8.0, function()
                hbdp:RemoveWorldMapIcon("EngravingPing", overlayFrame)
                if overlayFrame ~= nil then
                  overlayFrame:Hide()
                  overlayFrame = nil 
                end
            end)
        end
    end
end);

local function ActOnNearestEngraving()
    if (engravingsDB.participating == false or IsInInstance()) then
        return
    end
    
    -- Handle player death event
    local playerInstance = C_Map.GetBestMapForUnit("player")
    if (playerInstance == nil) then return end
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()

    local closestEngraving
    local closestDistance = math.huge

    local zoneMarkers = engravingsZoneCache[playerInstance] or {}
    local totalZoneMarkers = #zoneMarkers
    if (zoneMarkers == nil or totalZoneMarkers == 0) then
        return
    end

    -- Iterate through the zone death markers and calculate the distance from each marker to the player's position
    for index, engraving in ipairs(zoneMarkers) do
        -- Calculate the distance between the player and the marker
        local distance = GetDistanceBetweenPositions(playerX, playerY, playerInstance, engraving.posX, engraving.posY, engraving.mapID)
        local allowed = IsEngravingAllowedByFilters(engraving)

        -- Check if this marker is closer than the previous closest marker
        if allowed and not engraving.visited and distance < closestDistance then
            closestEngraving = engraving
            closestDistance = distance
        end
    end

    if closestEngraving then
        printDebug("Closest engraving: " .. tostring(closestEngraving.user))
        printDebug("Closest engraving: " .. tostring(closestDistance))
        if closestDistance <= 0.0025 then
            -- Perform any desired logic with the closest death marker
            ReadOutNearestEngraving(closestEngraving)
            closestEngraving.visited = true
            hbdp:RemoveAllMinimapIcons("EngravingsMM")
        end
    end
end

local function GenerateMinimapIcon(engraving)
    local iconFrame = CreateFrame("Frame", "NearestEngravingMM", Minimap)
    iconFrame:SetSize(12, 12)
    local iconTexture = iconFrame:CreateTexture(nil, "BACKGROUND")
    iconTexture:SetAllPoints()
    iconTexture:SetTexture("Interface\\Icons\\Inv_misc_rune_04")

    iconTexture:SetVertexColor(1, 1, 1, 0.75)
    iconFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("|cFFBF4500Engraving|r", 1, 1, 1)
        GameTooltip:Show()
    end)
    iconFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return iconFrame
end

local function FlashWhenNearEngraving()
    if (engravingsDB.partipating == false or IsInInstance()) then
        return
    end

    local playerInstance = C_Map.GetBestMapForUnit("player")
    if (playerInstance == nil) then return end
    local playerPosition = C_Map.GetPlayerMapPosition(playerInstance, "player")
    local playerX, playerY = playerPosition:GetXY()

    local closestEngraving
    local closestDistance = math.huge

    local zoneMarkers = engravingsZoneCache[playerInstance] or {}
    local totalZoneMarkers = #zoneMarkers

    -- Iterate through zone death markers and determine closest marker
    for index, engraving in ipairs(zoneMarkers) do
        local engravingPosX = engraving.posX
        local engravingPosY = engraving.posY
        local engravingMapID = engraving.mapID

        -- Calculate the distance between the player and the marker
        local distance = GetDistanceBetweenPositions(playerX, playerY, playerInstance, engravingPosX, engravingPosY, engravingMapID)
        local allowed = IsEngravingAllowedByFilters(engraving)

        -- Check if this marker is closer than the previous closest marker
        if (allowed and not engraving.visited and distance < closestDistance) then
                closestEngraving = engraving
                closestDistance = distance
        end
    end
    -- Now you have the closest death marker to the player
    if closestEngraving then
        printDebug("On move engraving: " .. tostring(closestDistance))
        if (lastClosestEngraving == nil) then
            lastClosestEngraving = closestEngraving
            hbdp:AddMinimapIconMap("EngravingsMM", GenerateMinimapIcon(closestEngraving), closestEngraving.mapID, closestEngraving.posX, closestEngraving.posY, false, true)
        elseif (lastClosestEngraving ~= closestEngraving) then
            lastClosestEngraving = closestEngraving
            printDebug("Swapping nearest engraving minimap marker.")
            hbdp:RemoveAllMinimapIcons("EngravingsMM")
            hbdp:AddMinimapIconMap("EngravingsMM", GenerateMinimapIcon(closestEngraving), closestEngraving.mapID, closestEngraving.posX, closestEngraving.posY, false, true)
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
                glowTexture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
                glowTexture:SetBlendMode("ADD")
                glowTexture:SetVertexColor(1, 0.5, 0, 0.5) -- Orange?
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

local function UnvisitAllEngravings()
    local totalRecords = #engravingsDB.engravingRecords
    for i = 1, totalRecords do
        engravingsDB.engravingRecords[i].visited = nil
    end
end

local function CreateDataImportFrame()
    local frame = CreateFrame("Frame", "EngravingsImportFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", 0, 200)
    frame:SetFrameStrata("HIGH")

    -- Create the background texture
    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.8) -- Set the RGB values and alpha

    local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOP", frame, "TOP", 0, -10)
    titleText:SetText("Engravings Data Import")

    -- Create a scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "EngravingsImportScrollFrameEditBox", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 8, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

    local editBox = CreateFrame("EditBox", "EngravingsImportFrameEditBox", scrollFrame)
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

    local importButton = CreateFrame("Button", "EngravingsImportButton", frame, "UIPanelButtonTemplate")
    importButton:SetSize(80, 22)
    importButton:SetPoint("BOTTOM", 0, 10)
    importButton:SetText("Import")
    importButton:SetScript("OnClick", function()
        local encodedData = editBox:GetText()
        local numImportRecords = 0
        local numNewRecords = 0
        if (startsWith(encodedData, "!E[")) then
            local start, finish, characterName, timestamp, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY = encodedData:find("!E%[\"%s*([^%]\"]*)\" (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) ([%d%.]+) ([%d%.]+)%]")
            local player_name_short, realm = string.split("-", characterName)
            local success, engraving = ImportEngravingMarker(realm, player_name_short, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, timestamp)
            numImportRecords = numImportRecords + 1
            if (success) then
                numNewRecords = numNewRecords + 1
            end
            print("Engravings imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
        else  
            printDebug("Input data size is: " .. tostring(string.len(encodedData)))
            local decodedData = ld:DecodeForPrint(encodedData)
            printDebug("Decoded data size is: " .. tostring(string.len(decodedData)))
            local decompressedData = ld:DecompressDeflate(decodedData)
            printDebug("Decompressed data size is: " .. tostring(string.len(decompressedData)))
            local success, importedEngravingRecords = ls:Deserialize(decompressedData)
            -- Example: Print the received data to the chat frame
            printDebug("Deserialization sucess: " .. tostring(success))
            numImportRecords = #importedEngravingRecords
            printDebug("Imported records size is: " .. tostring(numImportRecords))
            for _, engraving in ipairs(importedEngravingRecords) do
                local success, _ = ImportEngravingMarker(engraving.realm,  engraving.user, tonumber(engraving.mapID), tonumber(engraving.posX), tonumber(engraving.posY), tonumber(engraving.templ_index), tonumber(engraving.cat_index), tonumber(engraving.word_index), tonumber(engraving.conj_index), tonumber(engraving.conj_templ_index), tonumber(engraving.conj_cat_index), tonumber(engraving.conj_word_index), tonumber(engraving.timestamp))
                if success then numNewRecords = numNewRecords + 1 end
            end
            print("Engravings imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
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
    titleText:SetText("Engravings Data Export")

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

local function TombstonesJoinChannel()

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

local function WhisperSyncAvailabilityTo(player_name_short, oldest_timestamp, mapID)
    local commMessage = { msg = EN_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    CTL:SendAddonMessage("BULK", EN_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
end

local function WhisperSyncAcceptanceTo(player_name_short, oldest_timestamp, mapID)
    local commMessage = { msg = EN_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    CTL:SendAddonMessage("BULK", EN_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
    print("Engravings is accepting sync from " .. player_name_short .. ".")
end

local function WhisperSyncDataTo(player_name_short, engravings_data) 
    print("Engravings is sending sync data to " .. player_name_short .. ".")

    local serialized = ls:Serialize(engravings_data)
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
      CTL:SendAddonMessage("BULK", EN_COMM_NAME_SERIAL, commMessage.msg, "WHISPER", commMessage.player_name_short)
    end
    
    agreedReceiver = nil 
    agreedMapReceiver = nil
    syncAccepted = false
end

local function isPlayerMessageAllowed(player_name_short)
    if shadowbanned[player_name_short] then return false end
    if throttle_player[player_name_short] == nil then
        throttle_player[player_name_short] = 0
        return true
    end
    throttle_player[player_name_short] = throttle_player[player_name_short] + 1
    if throttle_player[player_name_short] > 300 then
        print("Engravings has shadowbanned "..player_name_short..".")
        shadowbanned[player_name_short] = 1
        return false
    end
    return true
end


--[[ Self Report Handling]]
--
local function EsendNextInQueue()
  if #engravings_readout_queue > 0 then 
		local commMessage = engravings_readout_queue[1]
		CTL:SendChatMessage("BULK", EN_COMM_NAME, commMessage.msg, "SAY", nil)
		table.remove(engravings_readout_queue, 1)
		return
	end
  
	if #engravings_sync_request_queue > 0 then 
		local ts_channel_num = GetChannelName(tombstones_channel)
		if ts_channel_num == 0 then
		  TombstonesJoinChannel()
		  return
		end
    
		local commMessage = engravings_sync_request_queue[1]
		CTL:SendChatMessage("BULK", EN_COMM_NAME, commMessage, "CHANNEL", nil, ts_channel_num)
		table.remove(engravings_sync_request_queue, 1)
		return
	end

	if #engravings_sync_availability_queue > 0 then 
		local ts_channel_num = GetChannelName(tombstones_channel)
		if ts_channel_num == 0 then
		  TombstonesJoinChannel()
		  return
		end

		local commMessage = engravings_sync_availability_queue[1]
		CTL:SendAddonMessage("BULK", EN_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
    table.remove(engravings_sync_availability_queue, 1)
    printDebug("Sent availability ping to "..commMessage.player_name_short..".")
		return
	end
  
  if #engravings_sync_accept_queue > 0 then 
		local ts_channel_num = GetChannelName(tombstones_channel)
		if ts_channel_num == 0 then
		  TombstonesJoinChannel()
		  return
		end

		local commMessage = engravings_sync_accept_queue[1]
		CTL:SendAddonMessage("BULK", EN_COMM_NAME, commMessage.msg, "WHISPER", commMessage.player_name_short)
		table.remove(engravings_sync_accept_queue, 1)
		return
	end
  
  if #engravings_sync_data_queue > 0 then 
		local ts_channel_num = GetChannelName(tombstones_channel)
		if ts_channel_num == 0 then
		  TombstonesJoinChannel()
		  return
		end

		local commMessage = engravings_sync_data_queue[1]
		CTL:SendAddonMessage("BULK", EN_COMM_NAME_SERIAL, commMessage.msg, "WHISPER", commMessage.player_name_short)
		table.remove(engravings_sync_data_queue, 1)
    if #engravings_sync_data_queue == 0 then
        printDebug("Sent all chunks to "..commMessage.player_name_short..".")
        agreedReceiver = nil 
        agreedMapReceiver = nil
    end -- Reset receiver after full send of all chunks.
		return
	end
end
-- Note: We can only send at most 1 message per click, otherwise we get a taint
WorldFrame:HookScript("OnMouseDown", function(self, button)
  EsendNextInQueue()
end)
-- This binds any key press to send, including hitting enter to type or esc to exit game
local f  = CreateFrame("Frame", "Test", UIParent)
f:SetScript("OnKeyDown", EsendNextInQueue)
f:SetPropagateKeyboardInput(true)


--[[ Slash Command Handler ]]
--
SLASH_ENGRAVINGS1 = "/engravings"
SLASH_ENGRAVINGS2 = "/eng"
-- Slash command handler function
local function SlashCommandHandler(msg)
    local command, args = strsplit(" ", msg, 2) -- Split the command and arguments
    -- Process the command and perform the desired actions
    if command == "make" then
        CreatePhraseGenerationInterface()
    elseif command == "debug" then
        debug = not debug
        print("Engravings debug mode is: ".. tostring(debug))
    elseif command == "export" then
        local serializedData = ls:Serialize(engravingsDB.engravingRecords)
        printDebug("Serialized data size is: " .. tostring(string.len(serializedData)))
        local compressedData = ld:CompressDeflate(serializedData)
        printDebug("Compressed data size is: " .. tostring(string.len(compressedData)))
        local encodedData = ld:EncodeForPrint(compressedData)
        printDebug("Encoded data size is: " .. tostring(string.len(encodedData)))
        CreateDataDisplayFrame(encodedData)
    elseif command == "import" then
        CreateDataImportFrame()
    elseif command == "clear" then
        -- Clear all death records
        StaticPopup_Show("ENGRAVINGS_CLEAR_CONFIRMATION")
    elseif command == "unvisit" then
        if (not debug) then return end
        UnvisitAllEngravings()
    elseif command == "sync" then
        local argsArray = {}
        if args then
           for word in string.gmatch(args, "%S+") do
               table.insert(argsArray, word)
           end
        end
        if(#argsArray > 0) then
            BroadcastSyncRequest(tonumber(argsArray[1]))
        else
            BroadcastSyncRequest(nil)
        end
    elseif command == "info" then
        print("Engravings has " .. #engravingsDB.engravingRecords.. " records in total.")
        print("Engravings saw " .. engravingsRecordCount .. " records this session.")
        print("You have found and decoded " .. engravingVisitCount .. " engravings.")
        print("Engravings offering sync service: " .. tostring(engravingsDB.offerSync) .. ".")
    elseif command == "usage" then
        print("Usage: /engravings or /eng [info | make | clear]")
    else
      if (optionsFrame ~= nil and optionsFrame:IsVisible()) then
        optionsFrame:Hide()
      else
        GenerateEngravingsOptionsFrame()
      end
    end
end
SlashCmdList["ENGRAVINGS"] = SlashCommandHandler


--[[ Initialize Event Handlers ]]
--
local function OnUpdateMovementHandler(self, elapsed)
  if (isPlayerMoving and engravingsDB.participating) then
    FlashWhenNearEngraving()
  end
end

function Engravings:PLAYER_STOPPED_MOVING()
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
  ActOnNearestEngraving()
end

function Engravings:PLAYER_STARTED_MOVING()
  isPlayerMoving = true
  if not movementTimer and engravingsDB.participating then
    movementTimer = C_Timer.NewTicker(movementUpdateInterval, OnUpdateMovementHandler)
  end
  -- Movement monitoring started
end

function Engravings:ZONE_CHANGED_NEW_AREA()
  if (engravingsDB.participating and engravingsDB.autoSync and not IsInInstance()) then
      QueueSyncRequest()
  end
end

local receivedChunks = {} -- Table to store the received chunks
local totalChunks = 0 -- Total number of expected chunks

function Engravings:CHAT_MSG_ADDON(prefix, data_str, channel, sender_name_long)
  local player_name_short, _ = string.split("-", sender_name_long)
  local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
  -- RESPOND TO SYNC AVAILABILITY IF STILL VALID
  if (command == EN_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"] and prefix == EN_COMM_NAME and channel == "WHISPER") then
      printDebug("Receiving TS:EngravingSyncAvailability from " .. player_name_short .. ".") 
      if not isPlayerMessageAllowed(player_name_short) then return end
      if (requestedSync == false) then return end -- We didn't request a sync? Spammer...
      if (agreedSender ~= nil) then return end -- We already have a sender
      local oldestTimestampInRequest, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
      oldestTimestampInRequest = tonumber(oldestTimestampInRequest)
      mapID = tonumber(mapID)
      local oldestEngravingTimestamp = GetOldestEngravingTimestamp(mapID) -- Ensure we are still in the same state and accepting to the same timestamp
      if (oldestTimestampInRequest == oldestEngravingTimestamp) then 
          agreedSender = player_name_short
          agreedMapSender = mapID
          WhisperSyncAcceptanceTo(player_name_short, oldestEngravingTimestamp, mapID)
      end
  -- RESPOND TO SYNC ACCEPTANCE; SEND THE DATA
  elseif (command == EN_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"] and prefix == EN_COMM_NAME and channel == "WHISPER") then
      printDebug("Receiving TS:EngravingSyncAccept from " .. player_name_short .. ".") 
      if not isPlayerMessageAllowed(player_name_short) then return end
      if (engravingsDB.offerSync == false) then return end -- We are not offering sync service
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
      local numberOfEngravingsToFetch = 100
      local fetchedEngravings = GetEngravingsBeyondTimestamp(timestampAgreedUpon, numberOfEngravingsToFetch, mapID)
      printDebug("Sending "..#fetchedEngravings.." engravings for map "..mapID..".")
      WhisperSyncDataTo(player_name_short, fetchedEngravings)
  -- RECEIVE THE CHUNKED DATA
  elseif (prefix == EN_COMM_NAME_SERIAL and channel == "WHISPER") then
      printDebug("Receiving TS:EngravingSyncData from " .. player_name_short .. ".") 
      if not isPlayerMessageAllowed(player_name_short) then return end
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
          print("Engravings is receiving 50+ chunks. This may cause slowness.\nConsider reloading and ignoring " .. player_name_short .. " if this is griefing.")
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
            local success, importedEngravingRecords = ls:Deserialize(decompressedData)
            importedEngravingRecords = importedEngravingRecords or {}
            local numImportRecords = #importedEngravingRecords or 0
            local numNewRecords = 0
            local badRecords = false
            for _, engraving in ipairs(importedEngravingRecords) do
                if (engraving.mapID == agreedMapSender) then
                    -- engraving = { realm, mapID, posX, posY, user , templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index }
                    -- (realm, user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
                    local success, _ = ImportEngravingMarker(engraving.realm,  engraving.user, tonumber(engraving.mapID), tonumber(engraving.posX), tonumber(engraving.posY), tonumber(engraving.templ_index), tonumber(engraving.cat_index), tonumber(engraving.word_index), tonumber(engraving.conj_index), tonumber(engraving.conj_templ_index), tonumber(engraving.conj_cat_index), tonumber(engraving.conj_word_index), tonumber(engraving.timestamp))
                    if success then numNewRecords = numNewRecords + 1 end
                else
                    badRecords = true
                end
            end
            print("Engravings imported in " .. tostring(numNewRecords) .. " new records out of " .. tostring(numImportRecords) .. ".")
            if badRecords == true then
                print("Engravings detected that "..player_name_short.." sent improper data. Consider ignoring if this is griefing.")
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

function Engravings:CHAT_MSG_CHANNEL(data_str, sender_name_long, _, channel_name_long)
  if (not engravingsDB.participating) then return end
  local _, channel_name = string.split(" ", channel_name_long)
  local player_name_short, _ = string.split("-", sender_name_long)
  if channel_name == tombstones_channel then
      local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
      if command == EN_COMM_COMMANDS["BROADCAST_ENGRAVING_PING"] then
          printDebug("Receiving TS:EngravingPing from " .. player_name_short .. ".")
          if not isPlayerMessageAllowed(player_name_short) then return end
          --(name, map_id, map_pos, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
          local engravingLocPing = EdecodeMessage(msg)
          if (engravingLocPing ~= nil) then
              --(user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
              local posX, posY = strsplit(",", engravingLocPing["map_pos"], 2)
              local mapID = tonumber(engravingLocPing.map_id)
              AddEngravingMarker(engravingLocPing.name, mapID, tonumber(posX), tonumber(posY), tonumber(engravingLocPing.templ_index), tonumber(engravingLocPing.cat_index), tonumber(engravingLocPing.word_index), tonumber(engravingLocPing.conj_index), tonumber(engravingLocPing.conj_templ_index),  tonumber(engravingLocPing.conj_cat_index), tonumber(engravingLocPing.conj_word_index))
              
              local overlayFrame = CreateFrame("Button", nil, WorldMapButton)
              overlayFrame:SetSize(iconSize * 1.5, iconSize * 1.5)

              local textureIcon = "Interface\\Addons\\Tombstones\\artwork\\inv_misc_rune_04_orange_tb.tga"
              local overlayFrameTexture = overlayFrame:CreateTexture(nil, "ARTWORK")
              overlayFrameTexture:SetAllPoints()
              overlayFrameTexture:SetTexture(textureIcon)

              engravingsSeenCount = engravingsSeenCount + 1
              
              hbdp:AddWorldMapIconMap("EngravingsPing", overlayFrame, tonumber(mapID), tonumber(posX), tonumber(posY), 3)
              miniButton.icon = textureIcon
              icon:Refresh("Engravings")
              
              C_Timer.After(7.0, function()
                  engravingsSeenCount = engravingsSeenCount - 1
                  hbdp:RemoveWorldMapIcon("EngravingsPing", overlayFrame)
                  if overlayFrame ~= nil then
                      overlayFrame:Hide()
                      overlayFrame = nil 
                  end
                  if(engravingsSeenCount == 0) then
                    miniButton.icon = "Interface\\Icons\\inv_misc_rune_04"
                    icon:Refresh("Engravings")
                  end
              end)
          end
      elseif command == EN_COMM_COMMANDS["BROADCAST_ENGRAVING_SYNC_REQUEST"] then
          printDebug("Receiving TS:EngravingSyncRequest from " .. player_name_short .. ".")
          if not isPlayerMessageAllowed(player_name_short) then return end
          if (engravingsDB.offerSync == false) then return end -- We are not offering syncing service
          if (agreedReceiver ~= nil) then return end -- We already have an agreed upon receiver of sync
          local oldestTimestampInRequest, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
          oldestTimestampInRequest = tonumber(oldestTimestampInRequest)
          mapID = tonumber(mapID)
          local haveNewEngravings = haveEngravingsBeyondTimestamp(oldestTimestampInRequest, mapID) -- HANDLE MAPID IN BEYOND TIMESTAMP
          if haveNewEngravings then
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
              printDebug("You don't have newer Engravings. Ignoring sync request.")
          end
      end
  end
end

function Engravings:PLAYER_LOGOUT()
  -- TODO
  SaveEngravingRecords()
end

local function sortTableWithOriginalIndex(tbl)
    local indexTable = {}
    for index, value in ipairs(tbl) do
        table.insert(indexTable, {index = index, value = value})
    end
    table.sort(indexTable, function(a, b) return a.value < b.value end)
    local alphaTable = {}
    local origToAlpha = {}
    local alphaToOrig = {}
    for newIndex, data in ipairs(indexTable) do
        alphaTable[newIndex] = data.value
        origToAlpha[data.index] = newIndex -- Store the original index for each new index
        alphaToOrig[newIndex] = data.index
        
    end
    return alphaTable, origToAlpha, alphaToOrig
end

local function sortTwoLevelTableWithOriginalIndex(tbl)
    local alphaTable = {}
    local origToAlpha = {}
    local alphaToOrig = {}

    for index, value in ipairs(tbl) do
        -- value == { word, word, word }
        local alphaWords, origToAlphaWordMappingTable, alphaToOrigWordMappingTable = sortTableWithOriginalIndex(value)
        table.insert(alphaTable, index, alphaWords)
        table.insert(origToAlpha, index, origToAlphaWordMappingTable)
        table.insert(alphaToOrig, index, alphaToOrigWordMappingTable)
    end
    return alphaTable, origToAlpha, alphaToOrig
end

function Engravings:PLAYER_LOGIN()
  templates, templatesOrigToAlphaMappingTable, templatesAlphaToOrigMappingTable = sortTableWithOriginalIndex(templates)
  conjunctions, conjunctionsOrigToAlphaMappingTable, conjunctionsAlphaToOrigMappingTable = sortTableWithOriginalIndex(conjunctions)
  categoryTable, categoryOrigToAlphaMappingTable, categoryAlphaToOrigMappingTable = sortTableWithOriginalIndex(categoryTable)
  wordsTable, wordsOrigToAlphaMappingTable, wordsAlphaToOrigMappingTable = sortTwoLevelTableWithOriginalIndex(wordsTable)
  
  -- called during load screen
  LoadEngravingRecords()
  MakeMinimapButton()
  MakeInterfacePage()
  
  C_ChatInfo.RegisterAddonMessagePrefix(EN_COMM_NAME)
  C_ChatInfo.RegisterAddonMessagePrefix(EN_COMM_NAME_SERIAL)
  
  if (engravingsDB.participating and not engravingsDB.reduceChatMsgs) then
      print("|cFFBF4500[Engravings]|r loaded successfully. Type /eng to get started, or click the minimap button. Additional options in Interface Options.")
  end

  self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  self:RegisterEvent("PLAYER_STARTED_MOVING")
  self:RegisterEvent("PLAYER_STOPPED_MOVING")
  self:RegisterEvent("CHAT_MSG_CHANNEL")
  self:RegisterEvent("CHAT_MSG_ADDON")
end

function Engravings:ADDON_LOADED()
    -- TODO
end

function Engravings:StartUp()
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
Engravings:StartUp()