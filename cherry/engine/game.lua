--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local Screen = require 'cherry.components.screen'
local Effects = require 'cherry.engine.effects'
local group = require 'cherry.libs.group'
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
      preset = {}, -- may be used to set a preset data during `resetState`
      state = {},
      elements = {}
    }
  )

  setmetatable(game, {__index = Game})
  return game
end

--------------------------------------------------------------------------------

function Game:initialState()
  return {}
end
function Game:resetState()
  self.state = self:initialState()
end
function Game:getState()
  return self.state
end
function Game:resetElements()
  self.elements = {}
end

--------------------------------------------------------------------------------
-- game.start --> reset, load?, run
--------------------------------------------------------------------------------

function Game:reset()
  group.empty(App.hud)
  if (self.onReset) then
    self:onReset()
  end -- from extension
  Camera:empty()
  self:resetState()
  self:resetElements()
  App.score:reset()
  self.preset = {} -- by now preset should have been used to init state and can be reset
end

function Game:run()
  self.isRunning = true

  if (_G.usePhysics) then
    _G.log('activated physics')
    _G.physics.start()
    _G.physics.setGravity(App.xGravity, App.yGravity)
  end

  Camera:resetZoom()
  Camera:center()
  Camera:start()

  Background:darken()

  if (self.onRun) then
    self:onRun()
  end -- from extension

  if (_G.CBE) then
    Effects:restart()
  end
  print('Game runs!')
end

--------------------------------------------------------------------------------

function Game:start()
  _G.isTutorial = App.user:isNew()
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

------------------------------------------

function Game:stop(noScore)
  if (not self.isRunning) then
    return
  end
  self.isRunning = false

  ------------------------------------------

  if (self.onStop) then
    self:onStop(noScore)
  end -- from extension

  ------------------------------------------

  if (not noScore) then
    Screen:showBands()
    if (not App.user:name()) then
      App.namePicker:display(App.score.display)
    else
      App.score:display()
    end
  end

  ------------------------------------------

  Background:lighten()
  if (_G.CBE) then
    Effects:stop(true)
  end
  Camera:stop()
end

--------------------------------------------------------------------------------

function Game:displayText(options)
  options =
    _.defaults(
    options or {},
    {
      text = '',
      fontSize = 145,
      y = display.contentHeight * 0.5
    }
  )

  local introText =
    display.newText(App.hud, options.text, 0, 0, _G.FONTS.default, options.fontSize)

  introText:setFillColor(255)
  introText.x = display.contentWidth * 0.1
  introText.y = options.y
  introText.alpha = 0

  transition.to(
    introText,
    {
      time = 500,
      alpha = 1,
      x = display.contentWidth * 0.5,
      transition = easing.outBounce,
      onComplete = function()
        transition.to(
          introText,
          {
            time = 300,
            alpha = 0,
            delay = options.persistTime or 600,
            x = display.contentWidth * 1.2,
            onComplete = function()
              if (options.next) then
                options.next()
              end
            end
          }
        )
      end
    }
  )
end

--------------------------------------------------------------------------------

return Game
