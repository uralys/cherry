
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
        time = 700
    })
end

--------------------------------------------------------------------------------

function Background:init()
    App.display:toBack()

    self.bg = display.newImageRect(
        App.display,
        'assets/images/background-light.jpg',
        display.contentWidth,
        display.contentHeight
    )

    self.darkBG = display.newImageRect(
        App.display,
        'assets/images/background-dark.jpg',
        display.contentWidth,
        display.contentHeight
    )

    self.bg.x         = display.contentWidth*0.5
    self.bg.y         = display.contentHeight*0.5
    self.darkBG.x     = display.contentWidth*0.5
    self.darkBG.y     = display.contentHeight*0.5
    self.darkBG.alpha = 1
end

--------------------------------------------------------------------------------

return Background
