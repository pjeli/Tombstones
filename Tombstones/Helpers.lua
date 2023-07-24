local REALM = GetRealmName()

function fetchQuotedPart(str)
    if(str == nil) then return nil end
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

function round(value)
  return math.floor(value + 0.5)
end

function GetDistanceBetweenPositions(playerX, playerY, playerInstance, markerX, markerY, markerInstance)
    local deltaX = markerX - playerX
    local deltaY = markerY - playerY
    local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
    return distance
end

function encodeColorizedText(str)
    local encodedText = str:gsub("|([cr])", "<%1>")  -- Special encoding for "|c" and "|r"
    return encodedText
end

function decodeColorizedText(str)
    local decodedText = str:gsub("<([cr])>", "|%1")  -- Special decoding for "|c" and "|r"
    return decodedText
end

function extractBracketTextWithColor(str)
    local start, finish, color, text = str:find("|c(%x+)|H.-|h%[(.-)%]|h|r")
    if color and text then
        local colorizedText = "|c" .. color .. "[" .. text .. "]|r"
        local cleanedText = str:gsub("|H.-|h(.-)|h", function(match)
            return match:match("|c(%x+)(.-)|r") or match:match("|c(%x+)(.-)") or match
        end)
        return colorizedText, cleanedText
    elseif str:match("|c") then
        local cleanedText = str:gsub("|H.-|h(.-)|h", function(match)
            return match:match("|c(%x+)(.-)|r") or match:match("|c(%x+)(.-)") or match
        end)
        return nil, cleanedText
    else
        return nil, str
    end
end

-- characterName might have REALM info in it
function generateEncodedHyperlink(characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words)
    sourceID = sourceID or -1
    raceID = raceID or 0
    classID = classID or 0
    level = level or 0
    guild = guild or ""
    if (last_words) then
        local _, santizedLastWords = extractBracketTextWithColor(last_words)
        local encodedLastWords = encodeColorizedText(santizedLastWords)
        return "!T["..characterName.." \""..guild.."\" "..timestamp.." "..level.." "..classID.." "..raceID.." "..sourceID.." "..mapID.." "..posX.." "..posY.." "..encodedLastWords.."]"
    end
    return "!T["..characterName.." \""..guild.."\" "..timestamp.." "..level.." "..classID.." "..raceID.." "..sourceID.." "..mapID.." "..posX.." "..posY.." \"\"]"
end

function generateEncodedHyperlinkFromMarker(marker)
    local user = marker.realm == REALM and marker.user or marker.user.."-"..marker.realm
    return generateEncodedHyperlink(user, marker.guild, marker.timestamp, marker.level, marker.class_id, marker.race_id, marker.source_id, marker.mapID, marker.posX, marker.posY, marker.last_words)
end

-- start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words
function parseEncodedHyperlink(encodedData)
    local start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words = encodedData:find("!T%[([^%s]+) \"%s*([^%]\"]*)\" (%d+) (%d+) (%d+) (%d+) (-?%d+) (%d+) ([%d%.]+) ([%d%.]+) (.*)%]")
    return start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words
end

-- start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words, 
function parseHyperlink(hyperlink)
  local start, finish, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words, characterName = hyperlink:find("|cff9d9d9d|Hgarrmission:tombstones:([^:]*):(%d+):(%d+):(%d+):(%d+):(-?%d+):(%d+):([%d%.]+):([%d%.]+):(.*)|h%[([^%s]+)'s Tombstone%]|h|r");
  return start, finish, characterName, guild, timestamp, level, classID, raceID, sourceID, mapID, posX, posY, last_words
end

function ELocationPing(name, map_id, map_pos, templ_index, cat_index, word_index, conj_index, conj_templ_index, conj_cat_index, conj_word_index)
  return {
    ["name"] = name,
    ["map_id"] = map_id,
    ["map_pos"] = map_pos,
    ["templ_index"] = templ_index,
    ["cat_index"] = cat_index,
    ["word_index"] = word_index,
    ["conj_index"] = conj_index,
    ["conj_templ_index"] = conj_templ_index,
    ["conj_cat_index"] = conj_cat_index,
    ["conj_word_index"] = conj_word_index,
  }
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

function TLocationPing(name, map_id, map_pos, karma)
  return {
    ["name"] = name,
    ["map_id"] = map_id,
    ["map_pos"] = map_pos,
    ["karma"] = karma,
  }
end

function ConvertTimestampToLongForm(timestamp)
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

    return string.format("%s%s%s, %d, at %d:%s%s",
        date("%B ", timestamp),
        day, daySuffix,
        dateTable.year,
        hour, minute,
        period
    )
end

-- Function to insert line breaks for word-wrapping
function InsertLineBreaks(text)
    local maxWidth = 22
    local wrappedText = ""
    local line = ""

    for word in string.gmatch(text, "%S+") do
        local testLine = line .. word

        if #testLine > 0 and #testLine > maxWidth then
            wrappedText = wrappedText .. line .. "\n"
            line = word .. " "
        else
            line = testLine .. " "
        end
    end

    wrappedText = wrappedText .. line
    wrappedText = string.sub(wrappedText, 1, -2) -- Remove the last character

    return wrappedText
end
