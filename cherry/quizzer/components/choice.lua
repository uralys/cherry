local Text = require 'cherry.components.text'
local colorize = require 'cherry.libs.colorize'
local animation = require 'cherry.libs.animation'
local gesture = require 'cherry.libs.gesture'
local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local Choice = {}

--------------------------------------------------------------------------------

---
--  data: {
--   _id = "5c3dfab3660b9b1278c17a5d",
--   items = {},
--   label = "Certaines cultures valorisent plus la créativité que d'autres",
--   media = {
--     posters = {},
--     src = {},
--     subtitles = {},
--   },
--   value = "sli_VyNT10-RS.choice_VJBSx0O0r"
-- }
--
function Choice:create(data, options)
  local component =
    _.extend(
    {
      data = data
    },
    options
  )
  setmetatable(component, {__index = Choice})

  component.display = display.newGroup()
  options.parent:insert(component.display)

  component.display.x = options.xFrom
  component.display.y = options.y
  component.display.alpha = 0

  component.selected = false
  component:render({noEffect = true})

  transition.to(
    component.display,
    {
      alpha = 1,
      x = options.xTo,
      delay = options.delay,
      time = options.time,
      transition = easing.outBack
    }
  )

  gesture.onTap(
    component.display,
    function()
      local isLocked = component.checkIsLocked()
      if (not isLocked) then
        component:toggle()
      end
    end
  )

  return component
end

--------------------------------------------------------------------------------

function Choice:render(options)
  options = options or {}

  local width = display.contentWidth * 0.7
  local defaultColor = '#000000'
  local defaultTextColor = self.defaultTextColor or App.colors.light
  local highlightTextColor = self.highlightTextColor or App.colors.light
  local highlightColor = self.highlightColor or App.colors.primary

  local bgColor = defaultColor
  local textColor = defaultTextColor
  local alpha = self.alpha or 1

  if (self.selected) then
    bgColor = highlightColor
    textColor = highlightTextColor
    alpha = 1
  end

  if (self.bg) then
    display.remove(self.bg)
  end

  if (self.choice) then
    display.remove(self.choice)
  end

  self.bg =
    display.newRoundedRect(
    self.display,
    0,
    0,
    width + 50,
    self.height or 100,
    15
  )

  self.bg.strokeWidth = 3
  self.bg.alpha = alpha
  self.bg:setFillColor(colorize(bgColor))
  self.bg:setStrokeColor(colorize(textColor))

  self.choice =
    Text:create(
    {
      parent = self.display,
      x = 0,
      y = 0,
      width = width,
      value = self.data.label,
      color = textColor,
      fontSize = 35,
      font = _G.FONTS.default
    }
  )

  ------------------------------------------
  -- SHOW_ANSWERS

  if (self.showAnswer) then
    self.circle =
      display.newCircle(self.display, -self.bg.width / 2 - 40, 0, 12)
    self.circle:setFillColor(colorize('#90ff00'))
  end

  ------------------------------------------

  if (not options.noEffect) then
    animation.touchEffect(
      self.display,
      {
        scaleFrom = 0.93
      }
    )
  end
end

--------------------------------------------------------------------------------
---  API
--------------------------------------------------------------------------------

function Choice:toggle()
  self.selected = not self.selected
  self:render()
end

function Choice:setColor(bgColor, textColor, alpha)
  self.bg:setFillColor(colorize(bgColor))
  self.bg:setStrokeColor(colorize(textColor))
  self.choice:setColor(textColor)
  self.bg.alpha = alpha or 1
end

function Choice:hide()
  transition.to(
    self.display,
    {
      alpha = 0,
      xScale = 0,
      yScale = 0.5,
      time = 500,
      transition = easing.inQuad
    }
  )
end

function Choice:textHeight()
  return self.choice:getHeight()
end

function Choice:destroy()
  display.remove(self.bg)
  self.choice:destroy()
  display.remove(self.display)
end

--------------------------------------------------------------------------------

return Choice
