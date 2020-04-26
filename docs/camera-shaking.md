backup camera shaking.

```lua
function Camera:start(options)
  _G.log('🔴 Camera is DEPRECATED! use App.game.camera instead.')
  self.options = _.extend(self.options, options)
  transition.cancel(self.display)
  self.display.alpha = 1
  App.hud:toFront()

  self.moveDisplay = function()
    if (self.shakeCount % shakePeriod == 0) then
      self.display.x = self.display.x0 + math.random(-xShake, xShake)
      self.display.y = self.display.y0 + math.random(-yShake, yShake)
    end
    self.shakeCount = self.shakeCount + 1
  end

  self.startShake = function()
    self.display.x0 = self.display.x
    self.display.y0 = self.display.y
    self.shakeCount = 0
    Runtime:addEventListener('enterFrame', self.moveDisplay)
  end

  self.stopShake = function()
    Runtime:removeEventListener('enterFrame', self.moveDisplay)
    self.display.x = INIT_X
    self.display.y = INIT_Y
    self.shaking = false
  end
end

function Camera:shake()
  if (self.shaking) then
    timer.cancel(self.shaking)
    self.stopShake()
  end

  self.startShake()
  self.shaking = timer.performWithDelay(250, self.stopShake)
end
```
