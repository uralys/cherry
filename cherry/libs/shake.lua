--------------------------------------------------------------------------------

local xShake = 16
local yShake = 8
local shakePeriod = 2

--------------------------------------------------------------------------------

local function addShaking(object)
  object.moveDisplay = function()
    if (object.shakeCount % shakePeriod == 0) then
      object.x = object.x0 + math.random(-xShake, xShake)
      object.y = object.y0 + math.random(-yShake, yShake)
    end
    object.shakeCount = object.shakeCount + 1
  end

  object.startShake = function()
    object.x0 = object.x
    object.y0 = object.y
    object.shakeCount = 0
    Runtime:addEventListener('enterFrame', object.moveDisplay)
  end

  object.stopShake = function()
    Runtime:removeEventListener('enterFrame', object.moveDisplay)
    object.x = 0
    object.y = 0
    object.shaking = false
  end
end

--------------------------------------------------------------------------------

local function shake(object)
  if (not object.startShake) then
    addShaking(object)
  end

  if (object.shaking) then
    timer.cancel(object.shaking)
    object.stopShake()
  end

  object.startShake()
  object.shaking = timer.performWithDelay(250, object.stopShake)
end

--------------------------------------------------------------------------------

return shake
