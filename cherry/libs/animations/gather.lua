--------------------------------------------------------------------------------

local Group   = require 'cherry.libs.group'
local isArray = require 'cherry.libs.is-array'

--------------------------------------------------------------------------------
-- {
--  newParent,
--  asset,
--  toX,
--  toY,
--  ?stepTime,
--  ?scale,
--  ?fillColorFunc,
--  ?onComplete,
--  ?onStepComplete
-- } = options
local function gather(movables, options)
  if(not isArray(movables)) then movables = {movables} end
  local newParent = options.newParent
  local TIME = options.stepTime or 600

  if(options.onComplete) then
    local totalTime = TIME + #movables * 50 + 50
    timer.performWithDelay(totalTime, options.onComplete)
  end

  for num = 1, #movables do
    local movable = movables[num]
    local stageX, stageY = movable:localToContent(0, 0)

    local x,y = newParent:contentToLocal(stageX, stageY)
    Group.destroy(movable)

    local c = display.newImage(
      newParent,
      options.asset,
      x, y
    )

    local scale = options.scale or 1
    c:scale(scale, scale)

    if(options.fillColorFunc) then
      c:setFillColor(options.fillColorFunc(num))
    end

    transition.to(c, {
      x = options.toX,
      y = options.toY,
      alpha = 0.7,
      time = TIME + num * 50,
      transition = easing.inQuad,
      onComplete = function ()
        if(options.onStepComplete) then
          options.onStepComplete(num)
        end
        Group.destroy(c)
      end
    })

    transition.to(c, {
      time = 70,
      xScale = 0.7,
      yScale = 0.7,
      onComplete = function ()
        transition.to(c, {
          transition = easing.outInQuad,
          time = 400,
          xScale = 0.12,
          yScale = 0.12
        })
      end
    })
  end
end

--------------------------------------------------------------------------------

return gather
