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

    if(listener) then
        webView:addEventListener( "urlRequest", listener )
    end

    ------------------

    local onClose = function ()

        if(listener) then
            webView:removeEventListener( "urlRequest", listener )
        end

        webView:removeSelf()
        webView = nil

        display.remove(webContainer.headerRect)
        display.remove(webContainer.logo)
        display.remove(webContainer.close)
        webContainer = nil

        if(customOnClose) then
            customOnClose()
        end
    end

    ------------------

    return onClose
end

--------------------------------------------------------------------------------

return webview
