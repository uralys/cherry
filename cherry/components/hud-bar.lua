--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local HUDBar = {}

--------------------------------------------------------------------------------

function HUDBar:create(parent)
    if(self.bar) then
        display.remove(self.bar)
    end

    self.barHeight = display.contentHeight*0.07

    self.bar   = display.newGroup()
    self.bar.x = display.contentWidth*0.5
    self.bar.y = -self.barHeight*0.5
    self.bar.anchorX = 0

    parent:insert(self.bar)

    self.barBG = display.newRect(
        self.bar,
        0, 0,
        display.contentWidth,
        self.barHeight
    )

    self.barBG.alpha = 0
    self.barBG:setFillColor(0)

    self:show()
    return self
end

--------------------------------------------------------------------------------

function HUDBar:show()
    transition.to( self.bar, {
        time  = 800,
        y     = self.barHeight*0.5
    })

    transition.to( self.barBG, {
        time  = 800,
        alpha = 0.6
    })
end

function HUDBar:hide()
    transition.to( self.bar, {
        time  = 800,
        y     = -self.barHeight*0.5
    })
end

--------------------------------------------------------------------------------

return HUDBar
