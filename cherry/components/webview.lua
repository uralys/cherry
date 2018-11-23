--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local WebView = {}

--------------------------------------------------------------------------------

local HEADER_HEIGHT = display.contentHeight / 6

--------------------------------------------------------------------------------

function WebView:new(options)
  options = _.defaults(options or {}, {
    x      = display.contentCenterX,
    y      = display.contentCenterY,
    width  = display.contentWidth,
    height = display.contentHeight - HEADER_HEIGHT
  })

  local webView = native.newWebView(
    options.x,
    options.y,
    options.width,
    options.height
  )
  -- defaut: hide
  webView.x = options.x + display.contentWidth

  local o = {webView = webView, options = options}
  setmetatable(o, { __index = WebView })

  if(options.url) then
    o:request(options.url)
  end
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
  if(self.options.resourceDirectory) then
    self.webView:request(url, system.ResourceDirectory)
  else
    self.webView:request(url)
  end
end

function WebView:show()
  transition.to(self.webView, {
    x = self.options.x,
    time = 150
  })
end

function WebView:hide()
  transition.to(self.webView, {
    x = self.options.x + display.contentWidth,
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
