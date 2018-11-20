--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local Background = {}

--------------------------------------------------------------------------------

function Background:darken()
    self:setDarkBGAplha(1)
end

function Background:lighten()
    self:setDarkBGAplha(0)
end

function Background:setDarkBGAplha(alpha)
    transition.to(self.darkBG, {
        alpha = alpha,
        time = self.time
    })
end

--------------------------------------------------------------------------------

function Background:init(options)
    options = _.defaults(options or {}, {
        light = 'cherry/assets/images/background-light.jpg',
        dark = 'cherry/assets/images/background-dark.jpg',
        desaturate = false
    })
    local lightImage = options.light
    local darkImage  = options.dark

    self.time = options.time or 700

    App.display:toBack()

    self.bg = display.newImageRect(
        App.display,
        lightImage,
        display.contentWidth,
        display.contentHeight
    )

    if(options.desaturate) then
        self.bg.fill.effect = 'filter.desaturate'
        self.bg.fill.effect.intensity = options.desaturate
    end

    self.darkBG = display.newImageRect(
        App.display,
        darkImage,
        display.contentWidth,
        display.contentHeight
    )

    self.bg.x         = display.contentWidth*0.5
    self.bg.y         = display.contentHeight*0.5
    self.darkBG.x     = display.contentWidth*0.5
    self.darkBG.y     = display.contentHeight*0.5
    self.darkBG.alpha = 1

    return self
end

--------------------------------------------------------------------------------

return Background
