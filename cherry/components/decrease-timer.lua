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
      font = _G.FONT,
      color = '#ffffff',
      fontSize = 40,
      align = 'center',
      anchorX = 0,
      anchorY = 0.5
    }
  )

  setmetatable(timer, {__index = Timer})

  timer.currentMillis = timer.startMillis
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

function Timer:refresh()
  local _, sec, ms = Time.getMinSecMillis(self.currentMillis)
  self.text:setValue(sec .. "''" .. ms)
end

function Timer:start()
  self.lastTime = system.getTimer()
  self:step()
end

function Timer:step()
  self.lastTime = system.getTimer()
  self.currentDelay =
    timer.performWithDelay(
    40,
    function()
      local elapsedTime = system.getTimer() - self.lastTime
      self.currentMillis = math.max(0, self.currentMillis - elapsedTime)
      self:refresh()

      if (self.currentMillis > 0) then
        self:step()
      end
    end
  )
end

function Timer:stop()
  timer.cancel(self.currentDelay)
end

function Timer:restart()
  self:stop()
  self.currentMillis = self.startMillis
  self:start()
end

--------------------------------------------------------------------------------

function Timer:destroy()
  display.remove(self.text)
end

--------------------------------------------------------------------------------

return Timer
