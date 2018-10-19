--------------------------------------------------------------------------------

local url = require('socket.url')
local json = require('dkjson')

--------------------------------------------------------------------------------

local webview = {}

-- openWeb --> open

--------------------------------------------------------

function webview.open(url, listener, customOnClose)
    local webContainer = {}
    local HEADER_HEIGHT = display.contentHeight / 6

    ------------------

    local webView = native.newWebView(
        display.contentCenterX,
        display.contentCenterY,
        display.contentWidth,
        display.contentHeight - HEADER_HEIGHT
    )

    webView:request( url )

    local _listener
    if(listener) then
        _listener = function(event)
            listener(event, webView)
        end
        webView:addEventListener( 'urlRequest', _listener )
    end

    ------------------

    local onClose = function(params)
        if(_listener) then
            webView:removeEventListener( 'urlRequest', _listener )
        end

        webView:removeSelf()
        webView = nil

        display.remove(webContainer.headerRect)
        display.remove(webContainer.logo)
        display.remove(webContainer.close)
        webContainer = nil

        if(customOnClose) then
            customOnClose(params)
        end
    end

    ------------------

    return onClose
end

--------------------------------------------------------------------------------

function extractJson(customEvent, eventUrl)
    if(not eventUrl) then return nil end

    local urlString = url.unescape(eventUrl)
    local start, _end = string.find(urlString, customEvent)
    if start ~= nil then
        local response = string.sub(urlString, _end + 1)
        return json.decode(response);
    end

    return nil
end

--------------------------------------------------------------------------------

return extractJson
