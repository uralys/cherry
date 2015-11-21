--------------------------------------------------------------------------------

local Screen = {}

--------------------------------------------------------------------------------

function Screen:openFacebook()
    local closeWeb = utils.openWeb('http://facebook.com/uralys')
    analytics.event('user', 'open-web', 'facebook')
    self:showBands({
        back = function ()
            analytics.event('user', 'close-web', 'facebook')
            self:hideBands()
            closeWeb()
        end
    })
end

--------------------------------------------------------------------------------

function Screen:openCredits()
    local closeWeb = utils.openWeb('http://www.uralys.com/projects/phantoms/#credits')
    analytics.event('user', 'open-web', 'uralys')
    self:showBands({
        back = function ()
            analytics.event('user', 'close-web', 'uralys')
            self:hideBands()
            closeWeb()
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

    transition.to( self.topRect, {
        time  = 800,
        alpha = 1
    })

    transition.to( self.topBand, {
        time  = 800,
        y     = display.contentHeight/24
    })

    transition.to( self.bottom, {
        time  = 800,
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
    end
end

function Screen:hideBands()
    transition.to( self.topBand, {
        time  = 800,
        y     = -display.contentHeight/12
    })

    transition.to( self.top, {
        time  = 800,
        alpha = 0
    })

    transition.to( self.bottom, {
        time  = 800,
        alpha = 0,
        y     = display.contentHeight + display.contentHeight/12
    })
end
--------------------------------------------------------------------------------

return Screen
