--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local colorize = require 'cherry.libs.colorize'

--------------------------------------------------------------------------------

local function showText(options)
  options =
    _.defaults(
    options or {},
    {
      text = '',
      color = '#ffffff',
      fontSize = 145,
      y = display.contentHeight * 0.5,
      parent = App.hud
    }
  )

  local introText =
    display.newText(
    options.parent,
    options.text,
    0,
    0,
    _G.FONTS.default,
    options.fontSize
  )

  introText:setFillColor(colorize(options.color))
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

return showText
