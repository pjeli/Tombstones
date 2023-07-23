-- Constants
local PLAYER_NAME, _ = UnitName("player")
local REALM = GetRealmName()
local CTL = _G.ChatThrottleLib
local EN_COMM_NAME = "TombstonesEngravings"
local EN_COMM_COMMANDS = {
  ["BROADCAST_ENGRAVING_PING"] = "6",
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
local tombstones_channel = "tsbroadcastchannel"
local tombstones_channel_pw = "tsbroadcastchannelpw"

-- Variables
local engravingsDB
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

local function LoadEngravingRecords()
    engravingsDB = _G["engravingsDB"]
    if not engravingsDB then
        engravingsDB = {}
        engravingsDB.version = ADDON_SAVED_VARIABLES_VERSION
        engravingsDB.engravingRecords = {}
        engravingsDB.participating = false
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

-- Add engraving marker function
local function AddEngravingMarker(user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
    if (mapID == nil or posX == nil or posY == nil or templ_index == 0 or user == nil) then
        -- No location info. Useless.
        return
    end

    local engraving = { realm = REALM, mapID = mapID, posX = posX, posY = posY, timestamp = time(), user = user , templ_index = templ_index, cat_index = cat_index, word_index = word_index, conj_index = conj_index, conj_templ_index = conj_templ_index, conj_cat_index = conj_cat_index, conj_word_index = conj_word_index }

    table.insert(engravingsDB.engravingRecords, engraving)
    engravingsRecordCount = engravingsRecordCount + 1
    printDebug("Engraving marker added at (" .. posX .. ", " .. posY .. ") in map " .. mapID)
end

local function decodePhrase(templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex) 
    if (templateIndex == 0) then
        return ""
    end
    
    local phrase = templates[templateIndex]
    
    if(categoryIndex == 0 or wordIndex == 0) then
        phrase, _ = phrase:gsub("(%*%*%*%*)", "")
        return phrase
    end
    
    phrase, _ = phrase:gsub("(%*%*%*%*)", wordsTable[categoryIndex][wordIndex])
    
    if (conjunctionIndex == 0) then
        return phrase
    else
        phrase = phrase .. " " .. conjunctions[conjunctionIndex]
    end
    
    if (conjTemplateIndex == 0 or conjCategoryIndex == 0 or conjWordIndex == 0) then
        return phrase
    end
        
    local conjPhrase = templates[conjTemplateIndex]
    conjPhrase, _ = conjPhrase:gsub("(%*%*%*%*)", wordsTable[conjCategoryIndex][conjWordIndex])
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
    UIDropDownMenu_Initialize(templateDropdown, function(self, level, menuList)
        for index, template in ipairs(templates) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = template
            info.value = template
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, template)
                templateIndex = index
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
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
        local words = wordsTable[category] or {}
        for index, word in ipairs(words) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = word
            info.value = word
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, word)
                wordIndex = index
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
                categoryIndex = index
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(categoryDropdown, InitializeCategoryDropdown)
    UIDropDownMenu_SetText(categoryDropdown, "Select Category")

    local conjunctionDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjunctionDropdown:SetPoint("TOPLEFT", categoryDropdown, "BOTTOMLEFT", 0, -50)
    UIDropDownMenu_SetWidth(conjunctionDropdown, 150)
    UIDropDownMenu_Initialize(conjunctionDropdown, function(self, level, menuList)
        for index, conjunction in ipairs(conjunctions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = conjunction
            info.value = conjunction
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, conjunction)
                conjunctionIndex = index
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
  
      -- Function to handle conjection dropdown initialization
    local function InitializeConjectionDropdown(self, level, menuList)
        for index, conjunction in pairs(conjunctions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = conjunction
            info.value = conjunction
            info.func = function()
                UIDropDownMenu_SetSelectedValue(conjunctionDropdown, conjunction)
                UIDropDownMenu_SetText(conjunctionDropdown, conjunction)
                conjunctionIndex = index
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    UIDropDownMenu_Initialize(conjunctionDropdown, InitializeConjectionDropdown)
    UIDropDownMenu_SetText(conjunctionDropdown, "Select Conjunction")
  
    local conjTemplateDropdown = CreateFrame("Frame", nil, phraseFrame, "UIDropDownMenuTemplate")
    conjTemplateDropdown:SetPoint("TOPLEFT", conjunctionDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(conjTemplateDropdown, 150)
    UIDropDownMenu_Initialize(conjTemplateDropdown, function(self, level, menuList)
        for index, template in ipairs(templates) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = template
            info.value = template
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, template)
                conjTemplateIndex = index
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
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
        local words = wordsTable[category] or {}
        for index, word in ipairs(words) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = word
            info.value = word
            info.func = function()
                UIDropDownMenu_SetSelectedValue(self, word)
                conjWordIndex = index
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
                conjCategoryIndex = index
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

        local phrase = generatePhrase(selectedTemplate, selectedWord, selectedConjunction, selectedConjTemplate, selectedConjWord)
        printDebug("Generated Phrase: ", phrase)
        printDebug("Generated Indexes: @"..templateIndex.."#"..categoryIndex.."$"..wordIndex.."+".. conjunctionIndex .."&"..conjTemplateIndex.."^"..conjCategoryIndex.."*"..conjWordIndex)
        
        local mapID = C_Map.GetBestMapForUnit("player")
        local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
        local posX, posY = playerPosition:GetXY()
        posX = string.format("%.4f", posX)
        posY = string.format("%.4f", posY)
        
        local engravingLink = "!E["..PLAYER_NAME.." "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex .." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex .." "..mapID.." "..posX.." "..posY.."]"
        local say_msg = "I have left an engraving here: "..engravingLink
        CTL:SendChatMessage("BULK", EN_COMM_NAME, say_msg, "SAY", nil)
        
        --(name, map_id, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
        if (engravingsDB.participating) then
            local channel_msg = EencodeMessage(PLAYER_NAME, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)   
            local channel_num = GetChannelName(tombstones_channel)
            CTL:SendChatMessage("BULK", EN_COMM_NAME, EN_COMM_COMMANDS["BROADCAST_ENGRAVING_PING"] .. COMM_COMMAND_DELIM .. channel_msg, "CHANNEL", nil, channel_num)
        end
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
              end
          else
              -- Perform actions for unselected state
              if (toggleName == "Participate") then
                  engravingsDB.participating = false
              end
          end
      end
      participateToggle:SetScript("OnClick", ToggleOnClick)

			InterfaceOptions_AddCategory(interPanel)
end

local function ReadOutNearestEngraving(engraving)
    -- engraving = { realm , mapID, posX , posY, timestamp, user , templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index }
    local engravingLink = "!E["..engraving.user.." "..engraving.templ_index.." "..engraving.cat_index.." "..engraving.word_index.." "..engraving.conj_index.." "..engraving.conj_templ_index.." "..engraving.conj_cat_index.." "..engraving.conj_word_index.." "..engraving.mapID.." "..engraving.posX.." "..engraving.posY.."]"
    local engravingHyperLink = "|cFFBF4500|Hgarrmission:engravings:"..engraving.templ_index..":"..engraving.cat_index..":"..engraving.word_index..":"..engraving.conj_index..":"..engraving.conj_templ_index..":"..engraving.conj_cat_index..":"..engraving.conj_word_index..":"..engraving.mapID..":"..engraving.posX..":"..engraving.posY.."|h["..engraving.user.."'s Engraving]|h|r"
    --local say_msg = "You found an engraving on the ground: "..engravingHyperLink
    --CTL:SendChatMessage("BULK", EN_COMM_NAME, say_msg, "SAY", nil)
    --SendChatMessage(say_msg, "SAY")
    
    local phrase = decodePhrase(engraving.templ_index, engraving.cat_index, engraving.word_index, engraving.conj_index, engraving.conj_templ_index, engraving.conj_cat_index, engraving.conj_word_index)
    DEFAULT_CHAT_FRAME:AddMessage("You found an engraving on the ground: "..engravingHyperLink, 1, 1, 0)
    PlaySound(1194)
    
    C_Timer.After(0.8, function()
        DEFAULT_CHAT_FRAME:AddMessage(engraving.user.."'s engraving reads: \""..phrase.."\"", 1, 1, 0)
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
    local start, finish, characterName, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY = remaining:find("!E%[([^%s]+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) ([%d%.]+) ([%d%.]+)%]")
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
        local start, finish, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex, mapID, posX, posY, characterName = text:find("|cFFBF4500|Hgarrmission:engravings:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):([%d%.]+):([%d%.]+)|h%[([^%s]+)'s Engraving%]|h|r");
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
                editbox:Insert("!E["..characterName.." "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex.." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex.." "..mapID.." "..posX.." "..posY.."]");
            end
        else
            if(IsControlKeyDown()) then
                local player_name_short, realm = string.split("-", characterName)
                --AddEngravingMarker(user, mapID, posX, posY, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
                AddEngravingMarker(player_name_short, mapID, posX, posY, templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)
                print("Tombstones imported in an Engraving.")
                --print("Engraving imported failed.")
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

    local zoneMarkers = engravingsDB.engravingRecords or {}
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

    local zoneMarkers = engravingsDB.engravingRecords or {}
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
    C_ChatInfo.RegisterAddonMessagePrefix(EN_COMM_NAME)
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
    elseif command == "info" then
        print("Engravings has " .. #engravingsDB.engravingRecords.. " records in total.")
        print("Engravings saw " .. engravingsRecordCount .. " records this session.")
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
      end
  end
end

function Engravings:PLAYER_LOGOUT()
  -- TODO
  SaveEngravingRecords()
end

function Engravings:PLAYER_LOGIN()
  -- called during load screen
  --  MakeMinimapButton()
  LoadEngravingRecords()
  MakeInterfacePage()

  self:RegisterEvent("PLAYER_STARTED_MOVING")
  self:RegisterEvent("PLAYER_STOPPED_MOVING")
  self:RegisterEvent("CHAT_MSG_CHANNEL")
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
