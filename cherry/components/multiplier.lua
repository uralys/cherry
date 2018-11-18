--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local Text      = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Multiplier = {}

--------------------------------------------------------------------------------

function Multiplier:draw(options)
  local multiplier = {}
  local image = options.image or 'cherry/assets/images/gui/items/' .. options.item .. '.icon.png'

  local icon = display.newImage(
    options.parent,
    image,
    options.x,
    options.y
  )

  local scale = options.scale or 0.5
  icon:scale(scale, scale)
  multiplier.icon = icon

  local sign = display.newImage(
    options.parent,
    'cherry/assets/images/gui/items/multiply.png',
    options.x + icon.width * scale * 0.8,
    options.y
  )

  animation.bounce(sign)
  multiplier.sign = sign

  timer.performWithDelay(150, function ()
    local num = Text:create({
      parent   = options.parent,
      value    = options.value,
      x        = options.x + icon.width * scale * 1.1,
      y        = options.y,
      fontSize = options.fontSize or 75,
      anchorX  = 0
    })

    multiplier.text = num
    animation.bounce(num.display)
  end)

  return multiplier
end

--------------------------------------------------------------------------------

return Multiplier
