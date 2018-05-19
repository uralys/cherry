--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local Screen     = require 'cherry.components.screen'
local Effects    = require 'cherry.engine.effects'
local group      = require 'cherry.libs.group'
local _          = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

function Game:new(extension)
    local game = _.defaults(extension, {
        isRunning = false,
        state = {},
        elements = {}
    })

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:initialState() return {} end
function Game:resetState() self.state = self:initialState() end
function Game:getState() return self.state end
function Game:resetElements() self.elements = {} end

--------------------------------------------------------------------------------
-- game.start --> reset, load?, run
--------------------------------------------------------------------------------

function Game:reset()
    group.empty(App.hud)
    if(self.onReset) then self:onReset() end -- from extension
    Camera:empty()
    self:resetState()
    self:resetElements()
    App.score:reset()
end

function Game:run()
    self.isRunning = true

    if(_G.usePhysics) then
        _G.log('activated physics')
        _G.physics.start()
        _G.physics.setGravity( App.xGravity, App.yGravity )
    end

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    Background:darken()

    if(self.onRun) then self:onRun() end -- from extension

    if(_G.CBE) then Effects:restart() end
    print('Game runs!')
end

--------------------------------------------------------------------------------

function Game:start()
    _G.isTutorial = App.user:isNew()
    self:reset()

    if (self.load) then
        local success = self:load()
        if(success) then
            self:run()
        else
            print('could not load properly')
            self:onLoadFailed()
        end
    else
        self:run()
    end
end

------------------------------------------

function Game:stop(userExit)
    if(not self.isRunning) then return end
    self.isRunning = false

    ------------------------------------------

    if(self.onStop) then self:onStop(userExit) end -- from extension

    ------------------------------------------

    if(not userExit) then
        Screen:showBands()
        App.score:display()
    end

    ------------------------------------------

    Background:lighten()
    if(_G.CBE) then Effects:stop(true) end
    Camera:stop()
end

--------------------------------------------------------------------------------

return Game
