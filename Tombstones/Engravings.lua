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
local engravings_sync_request_queue = {}
local engravings_sync_availability_queue = {}
local engravings_sync_accept_queue = {}
local engravings_sync_data_queue = {}
local agreedSender = nil
local agreedMapSender = nil
local agreedReceiver = nil
local agreedMapReceiver = nil
local requestedSync = false
local printedWarning = false

-- Variables
local engravingsDB
local engravingsZoneCache = {}
local phraseFrame
local engravingsRecordCount = 0
local debug = false
local iconSize = 12
local isPlayerMoving = false
local movementUpdateInterval = 0.5 -- Update interval in seconds
local movementTimer = nil
local lastClosestEngraving
local glowFrame

-- Libraries
local hbdp = LibStub("HereBeDragons-Pins-2.0")
local ls = LibStub("LibSerialize")
local ld = LibStub("LibDeflate")

-- Main Frame
local Engravings = CreateFrame("Frame")

function printDebug(msg)
    if debug then
        print(msg)
    end
end

local function SaveEngravingRecords()
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
end

local function LoadEngravingRecords()
    engravingsDB = _G["engravingsDB"]
    if not engravingsDB then
        engravingsDB = {}
        engravingsDB.version = ADDON_SAVED_VARIABLES_VERSION
        engravingsDB.engravingRecords = {}
        engravingsDB.participating = false
        engravingsDB.offerSync = false
    end
    if (engravingsDB.offerSync == nil) then
        engravingsDB.offerSync = false
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
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

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
            -- Ignore last words. 
            -- If last words arrive they will update our existing record instead of making a new record.
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
        if engraving.timestamp > oldest_engraving_timestamp then 
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
        if (engraving.timestamp > request_timestamp) then return true end
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
        if engraving.timestamp > request_timestamp then 
            table.insert(fetchedEngravings, engraving)
        end
        if #fetchedEngravings >= max_to_fetch then
            break
        end
    end
    return fetchedEngravings
end

-- Add engraving marker function
local function ImportEngravingMarker(realm, user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
    if (mapID == nil or posX == nil or posY == nil or templ_index == 0 or user == nil) then
        -- No location info. Useless.
        return
    end

    local engraving = { realm = realm, mapID = mapID, posX = posX, posY = posY, timestamp = time(), user = user , templ_index = templ_index, cat_index = cat_index, word_index = word_index, conj_index = conj_index, conj_templ_index = conj_templ_index, conj_cat_index = conj_cat_index, conj_word_index = conj_word_index }
    
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
    return ImportEngravingMarker(REALM, user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
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
    if (phraseFrame ~= nil and phraseFrame:IsVisible()) then
        return
    elseif (phraseFrame ~= nil and not phraseFrame:IsVisible()) then
        phraseFrame:Show()
        return
    end
  
    phraseFrame = CreateFrame("Frame", "EngravingsPhraseGenerator", UIParent)--, "UIPanelDialogTemplate")
    phraseFrame:SetSize(280, 390)
    phraseFrame:SetPoint("CENTER")
    phraseFrame:SetFrameStrata("HIGH")
    phraseFrame:SetMovable(true)
    phraseFrame:EnableMouse(true)
    phraseFrame:RegisterForDrag("LeftButton")
    phraseFrame:SetScript("OnDragStart", phraseFrame.StartMoving)
    phraseFrame:SetScript("OnDragStop", phraseFrame.StopMovingOrSizing)
    
    local bgTexture = phraseFrame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.75)
    
    local closeButton = CreateFrame("Button", "CloseButton", phraseFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -8, -8)

    local title = phraseFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Make Engraving Phrase")
    
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
        
        local engravingLink = "!E[\""..PLAYER_NAME.."\" "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex .." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex .." "..mapID.." "..posX.." "..posY.."]"
        local say_msg = "I have left an engraving here: "..engravingLink
        CTL:SendChatMessage("BULK", EN_COMM_NAME, say_msg, "SAY", nil)
        
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
        PlaySound(39514)
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
      local participateToggle = CreateFrame("CheckButton", "Participate", interPanel, "OptionsCheckButtonTemplate")
      participateToggle:SetPoint("TOPLEFT", 10, -40)
      participateToggle:SetChecked(engravingsDB.participating)
      local participateToggleText = participateToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      participateToggleText:SetPoint("LEFT", participateToggle, "RIGHT", 5, 0)
      participateToggleText:SetText("Participate")
      
      local offerSyncToggle = CreateFrame("CheckButton", "OfferSync", interPanel, "OptionsCheckButtonTemplate")
      offerSyncToggle:SetPoint("TOPLEFT", 10, -60)
      offerSyncToggle:SetChecked(engravingsDB.offerSync)
      local offerSyncToggleText = offerSyncToggle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      offerSyncToggleText:SetPoint("LEFT", offerSyncToggle, "RIGHT", 5, 0)
      offerSyncToggleText:SetText("Offer Engravings sync service")
      
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
              elseif (toggleName == "OfferSync") then
                  engravingsDB.offerSync = true
              end
          else
              -- Perform actions for unselected state
              if (toggleName == "Participate") then
                  engravingsDB.participating = false
                  engravingsDB.offerSync = false
                  offerSyncToggle:SetChecked(engravingsDB.offerSync)
              elseif (toggleName == "OfferSync") then
                  engravingsDB.offerSync = false
              end
          end
      end
      participateToggle:SetScript("OnClick", ToggleOnClick)
      offerSyncToggle:SetScript("OnClick", ToggleOnClick)

			InterfaceOptions_AddCategory(interPanel)
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
    local engravingLink = "!E[\""..user.."\" "..engraving.templ_index.." "..engraving.cat_index.." "..engraving.word_index.." "..engraving.conj_index.." "..engraving.conj_templ_index.." "..engraving.conj_cat_index.." "..engraving.conj_word_index.." "..engraving.mapID.." "..engraving.posX.." "..engraving.posY.."]"
    local engravingHyperLink = "|cFFBF4500|Hgarrmission:engravings:"..engraving.templ_index..":"..engraving.cat_index..":"..engraving.word_index..":"..engraving.conj_index..":"..engraving.conj_templ_index..":"..engraving.conj_cat_index..":"..engraving.conj_word_index..":"..engraving.mapID..":"..engraving.posX..":"..engraving.posY.."|h["..user.."'s Engraving]|h|r"
    --local say_msg = "You found an engraving on the ground: "..engravingHyperLink
    --CTL:SendChatMessage("BULK", EN_COMM_NAME, say_msg, "SAY", nil)
    --SendChatMessage(say_msg, "SAY")
    
    local phrase = decodePhrase(engraving.templ_index, engraving.cat_index, engraving.word_index, engraving.conj_index, engraving.conj_templ_index, engraving.conj_cat_index, engraving.conj_word_index)
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
    local start, finish, characterName, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY = remaining:find("!E%[\"%s*([^%]\"]*)\" (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) ([%d%.]+) ([%d%.]+)%]")
    if(characterName) then
      newMsg = newMsg..remaining:sub(1, start-1);
      newMsg = newMsg.."|cFFBF4500|Hgarrmission:engravings:"..templateIndex..":"..categoryIndex..":"..wordIndex..":"..conjunctionIndex..":"..conjTemplateIndex..":"..conjCategoryIndex..":"..conjWordIndex..":"..mapID..":"..posX..":"..posY.."|h["..characterName.."'s Engraving]|h|r";
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
        local start, finish, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY, characterName = text:find("|cFFBF4500|Hgarrmission:engravings:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):([%d%.]+):([%d%.]+)|h%[(.*)'s Engraving%]|h|r");
        templateIndex = tonumber(templateIndex) > 0 and tonumber(templateIndex) or 0
        categoryIndex = tonumber(categoryIndex) > 0 and tonumber(categoryIndex) or 0
        wordIndex = tonumber(wordIndex) > 0 and tonumber(wordIndex) or 0
        conjunctionIndex = tonumber(conjunctionIndex) > 0 and tonumber(conjunctionIndex) or 0
        conjTemplateIndex = tonumber(conjTemplateIndex) > 0 and tonumber(conjTemplateIndex) or 0
        conjCategoryIndex = tonumber(conjCategoryIndex) > 0 and tonumber(conjCategoryIndex) or 0
        conjWordIndex = tonumber(conjWordIndex) > 0 and tonumber(conjWordIndex) or 0
        mapID = tonumber(mapID) == 0 and nil or tonumber(mapID)
        posX = tonumber(posX) == 0 and nil or tonumber(posX)
        posY = tonumber(posY) == 0 and nil or tonumber(posY)
        --Republish hyperlink logic
        if(IsShiftKeyDown()) then
            local editbox = GetCurrentKeyBoardFocus();
            if(editbox) then
                editbox:Insert("!E[\""..characterName.."\" "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex.." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex.." "..mapID.." "..posX.." "..posY.."]");
            end
        else
            if(IsControlKeyDown()) then
                local player_name_short, realm = string.split("-", characterName)
                local success, engraving = ImportEngravingMarker(realm, player_name_short, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)
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

        -- Check if this marker is closer than the previous closest marker
        if not engraving.visited then
            if distance < closestDistance then
                closestEngraving = engraving
                closestDistance = distance
            end
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

        -- Check if this marker is closer than the previous closest marker
        if (not engraving.visited and distance < closestDistance) then
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

local function BroadcastSyncRequest()
    local playerMap = C_Map.GetBestMapForUnit("player")
    local oldest_engraving_timestamp = GetOldestEngravingTimestamp(playerMap)
    local channel_num = GetChannelName(tombstones_channel)
    requestedSync = true
    CTL:SendChatMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["BROADCAST_ENGRAVING_SYNC_REQUEST"]..COMM_COMMAND_DELIM..oldest_engraving_timestamp..COMM_FIELD_DELIM..playerMap, "CHANNEL", nil, channel_num)
end

local function WhisperSyncAvailabilityTo(player_name_short, oldest_timestamp, mapID)
    --print("z1")
    local commMessage = { msg = EN_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    table.insert(engravings_sync_availability_queue, commMessage)
    --CTL:SendAddonMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"]..COMM_COMMAND_DELIM..oldest_timestamp, "WHISPER", player_name_short)
end

local function WhisperSyncAcceptanceTo(player_name_short, oldest_timestamp, mapID)
  --print("z2")
    local commMessage = { msg = EN_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"]..COMM_COMMAND_DELIM..oldest_timestamp..COMM_FIELD_DELIM..mapID, player_name_short = player_name_short }
    table.insert(engravings_sync_accept_queue, commMessage)
    --CTL:SendAddonMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["WHISPER_SYNC_ACCEPT"]..COMM_COMMAND_DELIM..oldest_timestamp, "WHISPER", player_name_short)
end

local function WhisperSyncDataTo(player_name_short, engravings_data)
    --print("z3")
    
    local serialized = ls:Serialize(engravings_data)
    local compressed = ld:CompressDeflate(serialized)
    local encoded = ld:EncodeForWoWAddonChannel(compressed)
   
    local chunkSize = 200 -- Set the desired chunk size
    local totalChunks = math.ceil(#encoded / chunkSize)
   
    for i = 1, totalChunks do
      local startIndex = (i - 1) * chunkSize + 1
      local endIndex = i * chunkSize
      local chunk = encoded:sub(startIndex, endIndex)
      
      local msg = string.format("%d/%d:%s", i, totalChunks, chunk)
      
      local commMessage = { msg = msg , player_name_short = player_name_short }
      table.insert(engravings_sync_data_queue, commMessage)
    end
    printDebug("Loaded up "..totalChunks.." chunks for sending out.")
    --CTL:SendAddonMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["WHISPER_SYNC_BULK_DATA"]..COMM_COMMAND_DELIM..encodedData, "WHISPER", player_name_short)
end


--[[ Self Report Handling]]
--
local function EsendNextInQueue()
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
    elseif command == "clear" then
        -- Clear all death records
        StaticPopup_Show("ENGRAVINGS_CLEAR_CONFIRMATION")
    elseif command == "unvisit" then
        if (not debug) then return end
        UnvisitAllEngravings()
    elseif command == "sync" then
        BroadcastSyncRequest()
    elseif command == "info" then
        print("Engravings has " .. #engravingsDB.engravingRecords.. " records in total.")
        print("Engravings saw " .. engravingsRecordCount .. " records this session.")
        print("Engravings offering sync service: " .. tostring(engravingsDB.offerSync) .. ".")
    elseif command == "usage" then
        print("Usage: /engravings or /eng [info | make | clear]")
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

local receivedChunks = {} -- Table to store the received chunks
local totalChunks = 0 -- Total number of expected chunks

function Engravings:CHAT_MSG_ADDON(prefix, data_str, channel, sender_name_long)
  local player_name_short, _ = string.split("-", sender_name_long)
  local command, msg = string.split(COMM_COMMAND_DELIM, data_str)
  -- RESPOND TO SYNC AVAILABILITY IF STILL VALID
  if (command == EN_COMM_COMMANDS["WHISPER_SYNC_AVAILABILITY"] and prefix == EN_COMM_NAME and channel == "WHISPER") then
      printDebug("Receiving TS:EngravingSyncAvailability from " .. player_name_short .. ".") 
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
      if (engravingsDB.offerSync == false) then return end -- We are not offering sync service
      if (player_name_short ~= agreedReceiver) then return end -- The accepter is not the same player as we agreed upon? Spam / hacker.
      local timestampAgreedUpon, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
      timestampAgreedUpon = tonumber(timestampAgreedUpon)
      mapID = tonumber(mapID)
      if (mapID ~= agreedMapReceiver) then return end -- The acceptor has changed mapIDs on us? Reject sending.
      local numberOfEngravingsToFetch = 100
      local fetchedEngravings = GetEngravingsBeyondTimestamp(timestampAgreedUpon, numberOfEngravingsToFetch, mapID)
      printDebug("Sending "..#fetchedEngravings.." engravings for map "..mapID..".")
      WhisperSyncDataTo(player_name_short, fetchedEngravings)
  -- RECEIVE THE CHUNKED DATA
  elseif (prefix == EN_COMM_NAME_SERIAL and channel == "WHISPER") then
      printDebug("Receiving TS:EngravingSyncData from " .. player_name_short .. ".") 
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
                    local success, _ = ImportEngravingMarker(engraving.realm,  engraving.user, tonumber(engraving.mapID), tonumber(engraving.posX), tonumber(engraving.posY), tonumber(engraving.templ_index), tonumber(engraving.cat_index), tonumber(engraving.word_index), tonumber(engraving.conj_index), tonumber(engraving.conj_templ_index), tonumber(engraving.conj_cat_index), tonumber(engraving.conj_word_index))
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
          --(name, map_id, map_pos, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
          local engravingLocPing = EdecodeMessage(msg)
          if (engravingLocPing ~= nil) then
              --(user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
              local posX, posY = strsplit(",", engravingLocPing["map_pos"], 2)
              AddEngravingMarker(engravingLocPing.name, tonumber(engravingLocPing.map_id), tonumber(posX), tonumber(posY), tonumber(engravingLocPing.templ_index), tonumber(engravingLocPing.cat_index), tonumber(engravingLocPing.word_index), tonumber(engravingLocPing.conj_index), tonumber(engravingLocPing.conj_templ_index),  tonumber(engravingLocPing.conj_cat_index), tonumber(engravingLocPing.conj_word_index))
          end
      elseif command == EN_COMM_COMMANDS["BROADCAST_ENGRAVING_SYNC_REQUEST"] then
          printDebug("Receiving TS:EngravingSyncRequest from " .. player_name_short .. ".")
          if (engravingsDB.offerSync == false) then return end -- We are not offering syncing service
          if (agreedReceiver ~= nil) then return end -- We already have an agreed upon receiver of sync
          local oldestTimestampInRequest, mapID = strsplit(COMM_FIELD_DELIM, msg, 2)
          oldestTimestampInRequest = tonumber(oldestTimestampInRequest)
          mapID = tonumber(mapID)
          local haveNewEngravings = haveEngravingsBeyondTimestamp(oldestTimestampInRequest, mapID) -- HANDLE MAPID IN BEYOND TIMESTAMP
          if haveNewEngravings then
              agreedReceiver = player_name_short
              agreedMapReceiver = mapID
              WhisperSyncAvailabilityTo(player_name_short, oldestTimestampInRequest, mapID)
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
  --  MakeMinimapButton()
  LoadEngravingRecords()
  MakeInterfacePage()
  
  C_ChatInfo.RegisterAddonMessagePrefix(EN_COMM_NAME)
  C_ChatInfo.RegisterAddonMessagePrefix(EN_COMM_NAME_SERIAL)

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
