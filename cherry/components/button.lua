--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local colorize = require 'cherry.libs.colorize'
local gesture = require 'cherry.libs.gesture'
local file = _G.file or require 'cherry.libs.file'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Button = {}

--------------------------------------------------------------------------------

function Button:round(options)
  options = options or {}

  local button = display.newGroup()
  button.x = options.x or 0
  button.y = options.y or 0

  if (options.parent) then
    options.parent:insert(button)
  end

  local path =
    'cherry/assets/images/gui/buttons/' .. (options.type or '') .. '.png'
  if (not file.exists(path)) then
    _G.log('Button:round(): invalid options.type | check: ' .. path)
    return nil
  end

  button.image = display.newImage(button, path, 0, 0)

  button.text =
    display.newText(
    {
      parent = button,
      text = options.label or '',
      x = 0,
      y = 0,
      font = _G.FONTS.default,
      fontSize = 60
    }
  )

  button.text.anchorX = 0.63
  button.text.anchorY = 0.61

  if (options.action) then
    gesture.onTouch(button, options.action)
  end

  return button
end

function Button:icon(options)
  options = options or {}

  local path =
    'cherry/assets/images/gui/buttons/' .. (options.type or '') .. '.png'
  if (not file.exists(path)) then
    _G.log('Button:icon(): invalid options.type | check: ' .. path)
    return nil
  end

  local button = display.newImage(path)

  if (options.parent) then
    options.parent:insert(button)
  end

  button.x = options.x or 0
  button.y = options.y or 0

  if (options.action) then
    local scaleFrom = options.scale or 1
    local SCALE = scaleFrom * 0.7
    gesture.onTap(
      button,
      function()
        if (button.locked) then
          return
        end
        button.locked = true
        animation.touchEffect(
          button,
          {
            scaleTo = SCALE,
            scaleFrom = scaleFrom,
            onComplete = function()
              if (button.scale) then
                button:scale(scaleFrom / SCALE, scaleFrom / SCALE)
                button.locked = false
                timer.performWithDelay(10, options.action)
              end
            end
          }
        )
      end
    )
  end

  if (options.scale) then
    button:scale(options.scale, options.scale)
  end

  if (options.bounce) then
    if (options.scale) then
      animation.bounce(button, {scaleTo = options.scale})
    else
      animation.bounce(button)
    end
  end

  return button
end
--------------------------------------------------------------------------------

-- if options.bg = false --> only text button
-- if options.bg is not defined --> default bg is rectangle
function Button:create(options)
  options = options or {}
  options =
    _.defaults(
    options,
    {
      parent = App.hud,
      bg = _.defaults(
        options.bg or {},
        {
          image = 'cherry/assets/images/gui/buttons/rectangle.png',
          xScale = 1,
          yScale = 1
          -- color = if defined, colorize bg
        }
      ),
      text = _.defaults(
        options.text or {},
        {
          value = 'Go',
          font = _G.FONTS.default,
          fontSize = 35,
          color = '#ffffff'
        }
      ),
      anchorX = 0.5,
      anchorY = 0.5,
      x = 0,
      y = 0
    }
  )

  local button = display.newGroup()
  options.parent:insert(button)
  button.x = options.x
  button.y = options.y
  button.anchorChildren = true
  button.anchorX = options.anchorX
  button.anchorY = options.anchorY
  button.action = options.action

  local bg
  if (options.bg) then
    if (options.bg.width) then
      bg =
        display.newRoundedRect(
        button,
        0,
        0,
        options.bg.width,
        options.bg.height,
        options.bg.cornerRadius
      )
    else
      bg = display.newImage(button, options.bg.image)
      bg:scale(options.bg.xScale, options.bg.yScale)
    end
    if (options.bg.color) then
      bg:setFillColor(colorize(options.bg.color))
    end
  end

  button.text =
    Text:create(
    {
      parent = button,
      x = 0,
      y = -3,
      value = options.text.value,
      font = options.text.font,
      fontSize = options.text.fontSize,
      color = options.text.color,
      align = options.text.align
    }
  )

  local SCALE = 0.8
  local scaleFrom = 1

  if (button.action) then
    gesture.onTap(
      button,
      function()
        if (button.locked) then
          return
        end
        button.locked = true
        animation.touchEffect(
          button,
          {
            scaleTo = SCALE,
            scaleFrom = scaleFrom,
            onComplete = function()
              if (button.scale) then
                button:scale(scaleFrom / SCALE, scaleFrom / SCALE)
                button.locked = false
                timer.performWithDelay(10, button.action)
              end
            end
          }
        )
      end
    )
  end

  return button
end

--------------------------------------------------------------------------------

return Button
