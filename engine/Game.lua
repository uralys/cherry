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
    self.state = Game.RUNNING

    physics.start()
    physics.setGravity( App.xGravity, App.yGravity )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    App.score:createBar()
    Background:darken()

    self:onStart() -- from extension

    Effects:restart()
end

function Game:reset()
    Camera:empty()
    App.score:reset()
    self:onReset() -- from extension
end

------------------------------------------

function Game:stop(userExit)
    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

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

    ------------------------------------------

    self:onStop() -- from extension
end

--------------------------------------------------------------------------------

return Game
