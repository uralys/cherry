--------------------------------------------------------------------------------

local analytics = require 'cherry.libs.analytics'
local gesture = require 'cherry.libs.gesture'
local Button = require 'cherry.components.button'
local WebView = require 'cherry.components.webview'

--------------------------------------------------------------------------------

local BAND_HEIGHT = 120

--------------------------------------------------------------------------------

local Screen = {}

--------------------------------------------------------------------------------

function Screen:openFacebook()
  self:openWeb(
    {
      url = 'http://facebook.com/uralys',
      analyticsCategory = 'facebook'
    }
  )
end

--------------------------------------------------------------------------------

function Screen:openCredits()
  self:openWeb(
    {
      url = 'http://www.uralys.com/projects/phantoms/#credits',
      analyticsCategory = 'credits'
    }
  )
end

--------------------------------------------------------------------------------

function Screen:openPrivacy()
  self:openWeb(
    {
      url = 'http://www.uralys.com/privacy',
      analyticsCategory = 'privacy'
    }
  )
end

--------------------------------------------------------------------------------

function Screen:openWeb(options)
  local url, analyticsCategory = options.url, options.analyticsCategory

  if (App.transversalView) then
    App.transversalView.alpha = 0
  end
  local webView =
    WebView:new(
    {
      height = H - BAND_HEIGHT * 2,
      y = H / 2
    }
  )
  webView:open(
    {
      url = url,
      show = true
    }
  )

  analytics.event('user', 'open-web', analyticsCategory)
  self:showBands(
    {
      back = function()
        analytics.event('user', 'close-web', analyticsCategory)
        self:hideBands()

        if (App.transversalView) then
          App.transversalView.alpha = 1
        end
        webView:close()
      end
    }
  )
end

--------------------------------------------------------------------------------

function Screen:showBands(options)
  options = options or {}

  self.topBand = display.newGroup()
  App.hud:insert(self.topBand)
  self.topBand.x = display.contentWidth / 2
  self.topBand.y = -BAND_HEIGHT

  self.topRect =
    display.newRect(self.topBand, 0, 0, display.contentWidth, BAND_HEIGHT)

  self.topRect.alpha = 0
  self.topRect.anchorY = 0
  self.topRect:setFillColor(0)

  self.bottom =
    display.newRect(
    App.hud,
    display.contentWidth / 2,
    display.contentHeight,
    display.contentWidth,
    BAND_HEIGHT
  )

  self.bottom.alpha = 0
  self.bottom.anchorY = 1
  self.bottom:setFillColor(0)

  gesture.disabledTouch(self.topRect)
  gesture.disabledTouch(self.bottom)

  transition.to(
    self.topRect,
    {
      time = options.time or 800,
      alpha = 1
    }
  )

  transition.to(
    self.topBand,
    {
      time = options.time or 800,
      y = 0
    }
  )

  transition.to(
    self.bottom,
    {
      time = options.time or 800,
      alpha = 1,
      y = display.contentHeight,
      onComplete = function()
        if (options.next) then
          options.next()
        end
      end
    }
  )

  if (options.back) then
    local back =
      Button:icon(
      {
        parent = self.topBand,
        type = 'close',
        x = display.contentWidth / 2 - 50,
        y = BAND_HEIGHT / 2,
        scale = 0.85,
        action = options.back
      }
    )

    self.topBand:insert(back)
  end
end

function Screen:hideBands(options)
  options = options or {}
  transition.to(
    self.topBand,
    {
      time = options.time or 800,
      y = -BAND_HEIGHT
    }
  )

  transition.to(
    self.top,
    {
      time = options.time or 800,
      alpha = 0
    }
  )

  transition.to(
    self.bottom,
    {
      time = options.time or 800,
      alpha = 0,
      y = display.contentHeight + BAND_HEIGHT
    }
  )
end
--------------------------------------------------------------------------------

return Screen
