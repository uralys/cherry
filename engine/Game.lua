
local physics = require( 'physics' )

--------------------------------------------------------------------------------

Game = {
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

    Score:createBar()
    Background:darken()

    self:onStart() -- from extension

    Effects:restart()
    self.state = Game.RUNNING
end

function Game:reset()
    Camera:empty()
    HUD:reset()
    self:onReset() -- from extension

    Score:reset()
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
        Score:calculate()
    end

    ------------------------------------------

    HUD:reset()
    Screen:showBands()
    Background:lighten()
    Score:display()

    ------------------------------------------

    Effects:stop(true)
    Camera:stop()
end

--------------------------------------------------------------------------------

return Game
