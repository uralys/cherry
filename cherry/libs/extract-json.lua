--------------------------------------------------------------------------------

local url = require('socket.url')
local json = require('dkjson')

--------------------------------------------------------------------------------

local function extractJson(customEvent, eventUrl)
    if(not eventUrl) then return nil end

    local urlString = url.unescape(eventUrl)
    local start, _end = string.find(urlString, customEvent)
    if start ~= nil then
        local response = string.sub(urlString, _end + 1)
        local formatted = string.gsub(response, '/"', '\\"')
        return json.decode(formatted);
    end

    return nil
end

--------------------------------------------------------------------------------

return extractJson
