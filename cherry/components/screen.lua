--------------------------------------------------------------------------------

local analytics  = require 'cherry.libs.analytics'
local gesture    = require 'cherry.libs.gesture'
local Button     = require 'cherry.components.button'

--------------------------------------------------------------------------------

local Screen = {}

--------------------------------------------------------------------------------

function Screen:openFacebook()
    App.webView:open({url = 'http://facebook.com/uralys'})
    analytics.event('user', 'open-web', 'facebook')
    self:showBands({
        back = function ()
            analytics.event('user', 'close-web', 'facebook')
            self:hideBands()
            App.webView:close()
        end
    })
end

--------------------------------------------------------------------------------

function Screen:openCredits()
    App.webView:open({url = 'http://www.uralys.com/projects/phantoms/#credits'})
    analytics.event('user', 'open-web', 'uralys')
    self:showBands({
        back = function ()
            analytics.event('user', 'close-web', 'uralys')
            self:hideBands()
            App.webView:close()
        end
    })
end

--------------------------------------------------------------------------------

function Screen:showBands(options)
    options = options or {}

    self.topBand = display.newGroup()
    App.hud:insert(self.topBand)
    self.topBand.x = display.contentWidth/2
    self.topBand.y = -display.contentHeight/12

    self.topRect = display.newRect(
        self.topBand,
        0,
        0,
        display.contentWidth,
        display.contentHeight/12
    )

    self.topRect.alpha = 0
    self.topRect:setFillColor(0)

    self.bottom = display.newRect(
        App.hud,
        display.contentWidth/2,
        display.contentHeight,
        display.contentWidth,
        display.contentHeight/12
    )

    self.bottom.alpha = 0
    self.bottom:setFillColor(0)

    gesture.disabledTouch(self.topRect)
    gesture.disabledTouch(self.bottom)

    transition.to( self.topRect, {
        time  = options.time or 800,
        alpha = 1
    })

    transition.to( self.topBand, {
        time  = options.time or 800,
        y     = display.contentHeight/24
    })

    transition.to( self.bottom, {
        time  = options.time or 800,
        alpha = 1,
        y     = display.contentHeight - display.contentHeight/24,
        onComplete = function()
            if(options.next) then
                options.next()
            end
        end
    })

    if(options.back) then
        local back = Button:icon({
            parent = self.topBand,
            type   = 'close',
            x      = display.contentWidth/2 - 50,
            y      = 0,
            scale  = 0.65,
            action = options.back
        })

        self.topBand:insert(back)
    end
end

function Screen:hideBands(options)
    options = options or {}
    transition.to( self.topBand, {
        time  = options.time or 800,
        y     = -display.contentHeight/12
    })

    transition.to( self.top, {
        time  = options.time or 800,
        alpha = 0
    })

    transition.to( self.bottom, {
        time  = options.time or 800,
        alpha = 0,
        y     = display.contentHeight + display.contentHeight/12
    })
end
--------------------------------------------------------------------------------

return Screen
