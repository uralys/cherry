--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local colorize = require 'cherry.libs.colorize'
local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local Game = {}

--------------------------------------------------------------------------------

function Game:new(extension)
  local game =
    _.defaults(
    extension,
    {
      isRunning = false,
      camera = nil,
      preset = {}, -- may be used to set a preset data during `resetState`
      state = {},
      elements = {}
    }
  )

  setmetatable(game, {__index = Game})
  return game
end

--------------------------------------------------------------------------------
-- these should be implemented by extension

function Game:initialState()
  return {}
end

function Game:resetState()
  self.state = self:initialState()
end

function Game:resetElements()
  self.elements = {}
end

--------------------------------------------------------------------------------

function Game:getState()
  return self.state
end

--------------------------------------------------------------------------------
--      CAMERA
--------------------------------------------------------------------------------

function Game:resetCamera()
  if (self.camera) then
    display.remove(self.camera)
  end

  self.camera = display.newGroup()
  App.reorderLayers()
end

function Game:removeCamera()
  transition.to(
    self.camera,
    {
      alpha = 0,
      time = 500,
      xScale = 0.01,
      yScale = 0.01,
      x = W / 2,
      y = H / 2,
      onComplete = function()
        display.remove(self.camera)
      end
    }
  )
end

function Game:growCamera()
  transition.from(
    self.camera,
    {
      alpha = 0,
      time = 500,
      xScale = 0.01,
      yScale = 0.01,
      x = W / 2,
      y = H / 2
    }
  )
end

---------------------------------------------------------------------------------- END
-- START
-- game.start --> reset, load?, run
--------------------------------------------------------------------------------

function Game:reset()
  if (self.onReset) then
    self:onReset()
  end -- from extension

  self:resetState()
  self:resetElements()
  self:resetCamera()

  App.score:reset()
  self.preset = {} -- by now preset should have been used to init state and can be reset
end

--------------------------------------------------------------------------------

function Game:run()
  self.isRunning = true

  if (_G.usePhysics) then
    _G.log('activated physics')
    _G.physics.start()
    _G.physics.setGravity(App.xGravity, App.yGravity)
  end

  self:growCamera()
  Background:darken()

  if (self.onRun) then
    self:onRun()
  end -- from extension

  print('Game runs.')
end

--------------------------------------------------------------------------------

function Game:start()
  if (self.isRunning) then
    _G.log('Game is already running.')
    return
  end

  _G.isTutorial = App.user:isNew() and not _G['test-level']
  self:reset()

  if (self.load) then
    local success = self:load()
    if (success) then
      self:run()
    else
      print('could not load properly')
      self:onLoadFailed()
    end
  else
    self:run()
  end
end

--------------------------------------------------------------------------------
-- END
--------------------------------------------------------------------------------

function Game:exit()
  if (not self.isRunning) then
    return
  end

  print('Game exit.')
  self.isRunning = false

  ------------------------------------------

  if (self.onExit) then
    self:onExit()
  end -- from extension

  ------------------------------------------

  self:removeCamera()
  Background:lighten()
end

--------------------------------------------------------------------------------

return Game
