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
    options = options or {}
    local lightImage = options.light or 'cherry/_images/background-light.jpg'
    local darkImage  = options.dark or 'cherry/_images/background-dark.jpg'

    self.time = options.time or 700

    App.display:toBack()

    self.bg = display.newImageRect(
        App.display,
        lightImage,
        display.contentWidth,
        display.contentHeight
    )

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
