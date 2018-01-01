--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local HUDBar = {}

--------------------------------------------------------------------------------

function HUDBar:create(options)
    local component = _.defaults(options, {
        height = display.contentHeight*0.07
    })

    component.height = options.height
    component.finalX = options.x or display.contentWidth*0.5
    component.finalY = options.y or component.height*0.5

    component.display = display.newGroup()
    component.display.x = component.finalX
    component.display.y = -component.finalY

    if(options.parent) then
        options.parent:insert(component.display)
    end

    component.bg = display.newRect(
        component.display,
        0, 0,
        display.contentWidth,
        component.height
    )

    component.bg.alpha = 0
    component.bg:setFillColor(0)

    setmetatable(component, { __index = HUDBar })
    component:show()

    return component
end

--------------------------------------------------------------------------------

function HUDBar:show()
    transition.to( self.display, self.transitionOnShow or {
        time  = 800,
        y     = self.finalY
    })

    transition.to( self.bg, {
        time  = 800,
        alpha = 0.6
    })
end

function HUDBar:hide()
    transition.to( self.display, self.transitionOnHide or {
        time  = 800,
        y     = -self.finalY
    })
end

--------------------------------------------------------------------------------

return HUDBar
