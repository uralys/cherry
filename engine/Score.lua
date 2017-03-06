--------------------------------------------------------------------------------

local Button = require 'cherry.components.button'
local Panel  = require 'cherry.components.panel'
local Banner = require 'cherry.components.banner'

--------------------------------------------------------------------------------

local Score = {}

--------------------------------------------------------------------------------

function Score:new(extension)
    local score = _.extend({}, extension)
    setmetatable(score, { __index = Score })
    return score
end

--------------------------------------------------------------------------------
--- METRICS
--------------------------------------------------------------------------------

function Score:reset()
    self.current = {
        points = 0
    }

    self.enhancement = nil
    self.latest      = nil
end

function Score:worst()
    return {
        points = 0
    }
end

function Score:enhance(previousScore)
    self.merge = {
        points = math.max(self.current.points, previousScore.points)
    }

    self.enhancement = {
        points = self.current.points > previousScore.points
    }

    return self.merge
end

--------------------------------------------------------------------------------
--- MINI BAR
--------------------------------------------------------------------------------

function Score:createBar()
    if(self.bar) then
        display.remove(self.bar)
    end

    self.barHeight = display.contentHeight*0.07

    self.bar   = display.newGroup()
    self.bar.x = display.contentWidth*0.5
    self.bar.y = -self.barHeight*0.5
    self.bar.anchorX = 0

    App.hud:insert(self.bar)

    self.barBG = display.newRect(
        self.bar,
        0, 0,
        display.contentWidth,
        self.barHeight
    )

    self.barBG.alpha = 0
    self.barBG:setFillColor(0)

    self:onCreate(self.bar) -- from extension

    self:displayTitle()
    self:showBar()
end

--------------------------------------------------------------------------------

function Score:displayButtons()
    local back = Button:icon({
        parent = self.bar,
        type   = 'close',
        x      = display.contentWidth*0.5 - 50,
        y      = 0,
        scale  = 0.7,
        action = function ()
            App.game:stop(true)
            Router:open(Router.HOME)
        end
    })
end

--------------------------------------------------------------------------------

function Score:displayTitle()
    if(not App.game.title) then return end

    local text = display.newText(
        self.bar,
        App.game.title,
        display.contentWidth*0.5 - 195, 0,
        FONT, 35
    )

    text.anchorX = 1
    text.alpha = 0

    transition.to(text, {
        alpha = 1,
        time  = 2000,
        delay = 4000
    })
end

--------------------------------------------------------------------------------

function Score:showBar()
    transition.to( self.bar, {
        time  = 800,
        y     = self.barHeight*0.5
    })

    transition.to( self.barBG, {
        time  = 800,
        alpha = 0.6
    })
end

function Score:hideBar()
    transition.to( self.bar, {
        time  = 800,
        alpha = 0
    })
end

--------------------------------------------------------------------------------
--- RESULT BOARD
--------------------------------------------------------------------------------

function Score:calculate()
    print('Final score : ', self.current.points)
end

--------------------------------------------------------------------------------

function Score:display()
    self:hideBar()

    local board = display.newGroup()
    board.x = display.contentWidth  * 0.5
    board.y = display.contentHeight * 0.5
    App.hud:insert(board)

    local bg = Panel:vertical({
        parent = board,
        image  = 'assets/images/gui/panels/panel.vertical.png',
        width  = display.contentWidth * 0.4,
        height = display.contentHeight * 0.35,
        x      = 0,
        y      = 0
    })

    local title = 'Game Over'

    Banner:large({
        parent   = board,
        text     = title,
        fontSize = 44,
        width    = display.contentWidth*0.25,
        height   = display.contentHeight*0.13,
        x        = 0,
        y        = -bg.height*0.49
    })

    local text = display.newText(
        board,
        self.current.points,
        0, 0,
        FONT, 85
    )

    utils.grow(text)

    self:addBoardButtons(board)
    utils.easeDisplay(board)
end

--------------------------------------------------------------------------------

function Score:addBoardButtons(board)
    Button:icon({
        parent = board,
        type   = 'play',
        x      = board.width * 0.25,
        y      = board.height * 0.45,
        bounce = true,
        action = function()
            Router:open(Router.HOME)
        end
    })
end

--------------------------------------------------------------------------------

return Score
