--------------------------------------------------------------------------------

local Background = require 'Cherry.components.Background'
local Screen = require 'Cherry.components.Screen'

--------------------------------------------------------------------------------

local physics = require( 'physics' )

--------------------------------------------------------------------------------

local Game = {
    RUNNING = 1,
    STOPPED = 2
}

--------------------------------------------------------------------------------

function Game:new(extension)
    local game = _.extend({
        state = Game.STOPPED
    }, extension)

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self:reset()

    physics.start()
    physics.setGravity( App.xGravity, App.yGravity )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    App.score:createBar()
    Background:darken()

    self:onStart() -- from extension

    Effects:restart()
    self.state = Game.RUNNING
end

function Game:reset()
    Camera:empty()
    self:onReset() -- from extension
    App.score:reset()
end

------------------------------------------

function Game:stop(userExit)
    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------

    self:onStop() -- from extension

    ------------------------------------------
    -- calculate score

    if(not userExit) then
        App.score:calculate()
    end

    ------------------------------------------

    Screen:showBands()
    Background:lighten()
    App.score:display()

    ------------------------------------------

    Effects:stop(true)
    Camera:stop()
end

--------------------------------------------------------------------------------

return Game
