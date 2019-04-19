--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local Text = require 'cherry.components.text'
local Time = require 'cherry.libs.time'

--------------------------------------------------------------------------------

local Timer = {}

--------------------------------------------------------------------------------

function Timer:create(options)
  local timer =
    _.defaults(
    options,
    {
      x = 0,
      y = 0,
      font = _G.FONTS.default,
      color = '#ffffff',
      fontSize = 40,
      align = 'center',
      anchorX = 0,
      anchorY = 0.5
    }
  )

  setmetatable(timer, {__index = Timer})

  timer.currentMillis = 0
  timer:render()
  return timer
end

--------------------------------------------------------------------------------

function Timer:render()
  if (self.text) then
    display.remove(self.text)
  end

  self.text =
    Text:create(
    {
      parent = self.parent,
      value = '',
      font = self.font,
      fontSize = self.fontSize,
      x = self.x,
      y = self.y,
      width = self.width,
      align = self.align,
      anchorX = self.anchorX,
      anchorY = self.anchorY,
      color = self.color
    }
  )
end

--------------------------------------------------------------------------------

function Timer:toString()
  local _, sec, ms = Time.getMinSecMillis(self.currentMillis)
  return sec .. "'" .. ms
end

function Timer:refresh()
  self.text:setValue(self:toString())
end

function Timer:start()
  self.lastTime = system.getTimer()
  self:step()
end

function Timer:step()
  self.lastTime = system.getTimer()
  self.currentDelay =
    timer.performWithDelay(
    50,
    function()
      pcall(
        function()
          if (not self.currentDelay) then
            -- stopped meanwhile
            return
          end

          local elapsedTime = system.getTimer() - self.lastTime
          self.currentMillis = self.currentMillis + elapsedTime
          self:refresh()
          self:step()
        end
      )
    end
  )
end

function Timer:stop()
  if (self.currentDelay) then
    timer.cancel(self.currentDelay)
  end
end

function Timer:restart()
  self:stop()
  self.currentMillis = 0
  self:start()
end

--------------------------------------------------------------------------------

function Timer:destroy()
  self:stop()
  self.text:destroy()
end

--------------------------------------------------------------------------------

return Timer
