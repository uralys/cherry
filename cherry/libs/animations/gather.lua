--------------------------------------------------------------------------------

local isArray = require 'cherry.libs.is-array'

--------------------------------------------------------------------------------
-- {
--  newParent,
--  asset,
--  toX,
--  toY,
--  ?stepTime,
--  ?scale,
--  ?createElement,
--  ?onComplete,
--  ?onStepComplete
-- } = options
local function gather(stageCoordinates, options)
  if (not isArray(stageCoordinates)) then
    stageCoordinates = {stageCoordinates}
  end
  local newParent = options.newParent

  local TIME = options.stepTime or 600

  if (options.onComplete) then
    local totalTime = TIME - 50 + #stageCoordinates * 50
    timer.performWithDelay(totalTime, options.onComplete)
  end

  for num = 1, #stageCoordinates do
    local stageX = stageCoordinates[num].stageX
    local stageY = stageCoordinates[num].stageY
    local x, y = newParent:contentToLocal(stageX, stageY)

    local c
    if (options.createElement) then
      c = options.createElement(num)
      newParent:insert(c)
      c.x = x
      c.y = y
    else
      c = display.newImage(newParent, options.asset, x, y)
    end

    local scaleFrom = options.scaleFrom or 1
    local scaleTo = options.scaleTo or 0.12
    c:scale(scaleFrom, scaleFrom)

    local delay = 0
    if (options.delay) then
      delay = options.delay()
    end

    transition.to(
      c,
      {
        x = options.toX,
        y = options.toY,
        alpha = 0.7,
        time = TIME + num * 50,
        delay = delay,
        transition = options.easing or easing.inQuad,
        rotation = options.rotation or 0,
        onComplete = function()
          if (options.onStepComplete) then
            options.onStepComplete(num)
          end
          display.remove(c)
        end
      }
    )

    transition.to(
      c,
      {
        time = 70,
        xScale = scaleFrom,
        yScale = scaleFrom,
        onComplete = function()
          transition.to(
            c,
            {
              transition = easing.outInQuad,
              time = 400,
              xScale = scaleTo,
              yScale = scaleTo
            }
          )
        end
      }
    )
  end
end

--------------------------------------------------------------------------------

return gather
