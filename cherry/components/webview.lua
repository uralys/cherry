--------------------------------------------------------------------------------

local url = require('socket.url')
local json = require('dkjson')

--------------------------------------------------------------------------------

local WebView = {}

--------------------------------------------------------------------------------

local HEADER_HEIGHT = display.contentHeight / 6

--------------------------------------------------------------------------------

function WebView:new(options)
  local webView = native.newWebView(
    display.contentCenterX,
    display.contentCenterY,
    display.contentWidth,
    display.contentHeight - HEADER_HEIGHT
  )

  webView.x = display.contentCenterX + display.contentWidth

  if(options.url) then
    webView:request(options.url)
  end

  local o = {webView = webView}
  setmetatable(o, { __index = WebView })

  return o;
end

--------------------------------------------------------------------------------

function WebView:open(options)
  if(options.listener) then
    self.listener = options.listener
    self.webView:addEventListener( 'urlRequest', self.listener )
  end

  if(options.url) then
    self:request(options.url)
  end

  self:show()
end

function WebView:close()
  if(self.listener) then
    self.webView:removeEventListener( 'urlRequest', self.listener )
    self.listener = nil
  end

  self:hide()
end

--------------------------------------------------------------------------------

function WebView:request(url)
  self.webView:request( url )
end

function WebView:show()
  transition.to(self.webView, {
    x = display.contentCenterX,
    time = 150
  })
end

function WebView:hide()
  transition.to(self.webView, {
    x = display.contentCenterX + display.contentWidth,
    time = 150
  })
end

--------------------------------------------------------------------------------

function WebView:destroy()
  self.webView:removeSelf()
  self.webView = nil
end

--------------------------------------------------------------------------------

return WebView
