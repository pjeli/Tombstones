local PLAYER_NAME, _ = UnitName("player")

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

local function decodePhrase(templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)
    print(templateIndex)
    print(categoryIndex)
    print(wordIndex)
    print(conjunctionIndex)
  
    if (templateIndex == 0 or categoryIndex == 0 or wordIndex == 0) then
        return nil
    end

    local phrase = templates[templateIndex]
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

local function CreatePhaseGenerationInterface()
    local frame = CreateFrame("Frame", "TombstonesPhraseGenerator", UIParent)--, "UIPanelDialogTemplate")
    frame:SetSize(300, 400)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    local bgTexture = frame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints()
    bgTexture:SetColorTexture(0, 0, 0, 0.75)
    
    local closeButton = CreateFrame("Button", "CloseButton", frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -8, -8)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Make Engraving Phrase")
    
    local templateIndex = 0
    local categoryIndex = 0
    local wordIndex = 0
    local conjunctionIndex = 0
    local conjTemplateIndex = 0
    local conjCategoryIndex = 0
    local conjWordIndex = 0

    local templateDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
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

    local categoryDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
    categoryDropdown:SetPoint("TOPLEFT", templateDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(categoryDropdown, 150)

    local wordDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
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

    local conjunctionDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
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
  
    local conjTemplateDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
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

    local conjCategoryDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
    conjCategoryDropdown:SetPoint("TOPLEFT", conjTemplateDropdown, "BOTTOMLEFT", 0, -10)
    UIDropDownMenu_SetWidth(conjCategoryDropdown, 150)

    local conjWordDropdown = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate")
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

    local generateButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    generateButton:SetPoint("BOTTOM", 0, 20)
    generateButton:SetText("Leave Engraving")
    generateButton:SetScript("OnClick", function()
        local selectedTemplate = UIDropDownMenu_GetSelectedValue(templateDropdown)
        local selectedWord = UIDropDownMenu_GetSelectedValue(wordDropdown)
        local selectedConjunction = UIDropDownMenu_GetSelectedValue(conjunctionDropdown)
        local selectedConjTemplate = UIDropDownMenu_GetSelectedValue(conjTemplateDropdown)
        local selectedConjWord = UIDropDownMenu_GetSelectedValue(conjWordDropdown)

        local phrase = generatePhrase(selectedTemplate, selectedWord, selectedConjunction, selectedConjTemplate, selectedConjWord)
        printDebug("Generated Phrase:", phrase)
        printDebug("Generated Indexes: @"..templateIndex.."#"..categoryIndex.."$"..wordIndex.."+".. conjunctionIndex .."&"..conjTemplateIndex.."^"..conjCategoryIndex.."*"..conjWordIndex)
        
        local mapID = C_Map.GetBestMapForUnit("player")
        local playerPosition = C_Map.GetPlayerMapPosition(mapID, "player")
        local posX, posY = playerPosition:GetXY()
        posX = string.format("%.4f", posX)
        posY = string.format("%.4f", posY)
        
        DEFAULT_CHAT_FRAME:AddMessage("!E["..PLAYER_NAME.." "..templateIndex.." "..categoryIndex.." "..wordIndex.." "..conjunctionIndex .." "..conjTemplateIndex.." "..conjCategoryIndex.." "..conjWordIndex .." "..mapID.." "..posX.." "..posY.."]", 1, 1, 1)
    end)

    frame:Show()
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
                print("Engravings imported failed.")
            end
            -- Do the magic
            local phrase = decodePhrase(templateIndex, categoryIndex, wordIndex, conjunctionIndex, conjTemplateIndex, conjCategoryIndex, conjWordIndex)
            DEFAULT_CHAT_FRAME:AddMessage(characterName.."'s engraving reads: \""..phrase.."\"", 1, 1, 0)
        end
    end
end);


--[[ Slash Command Handler ]]
--
SLASH_ENGRAVINGS1 = "/engravings"
SLASH_ENGRAVINGS2 = "/eng"
-- Slash command handler function
local function SlashCommandHandler(msg)
    local command, args = strsplit(" ", msg, 2) -- Split the command and arguments
    -- Process the command and perform the desired actions
    if command == "make" then
        CreatePhaseGenerationInterface()
    end
end
SlashCmdList["ENGRAVINGS"] = SlashCommandHandler
