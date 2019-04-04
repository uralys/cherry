--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local Button    = require 'cherry.components.button'
local Panel     = require 'cherry.components.panel'
local Banner    = require 'cherry.components.banner'

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
--- RESULT BOARD
--------------------------------------------------------------------------------

function Score:calculate()
    print('Final score : ', self.current.points)
end

function Score:generateResult()
    return {
        title = 'Game over !',
        background = 'cherry/assets/images/gui/panels/panel.vertical.png'
    }
end

function Score:displayResult(board, bg)
    local text = display.newText(
        board,
        'Thanks for playing.',
        0, 0,
        _G.FONTS.default, 85
    )

    animation.grow(text)

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

function Score:display()
    local board = display.newGroup()
    board.x = display.contentWidth  * 0.5
    board.y = display.contentHeight * 0.5
    App.hud:insert(board)

    local result = self:generateResult()

    local bg = Panel:vertical({
        parent = board,
        image  = result.background,
        width  = display.contentWidth * 0.4,
        height = display.contentHeight * 0.35,
        x      = 0,
        y      = 0
    })

    Banner:large({
        parent   = board,
        text     = result.title,
        fontSize = 44,
        width    = display.contentWidth*0.25,
        height   = display.contentHeight*0.13,
        x        = 0,
        y        = -bg.height*0.49
    })

    self:displayResult(board, bg)
    animation.easeDisplay(board)
end

--------------------------------------------------------------------------------

return Score
