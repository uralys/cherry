--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local TextUtils = require 'cherry.libs.text'
local colorize = require 'cherry.libs.colorize'
local animation = require 'cherry.libs.animation'
local gesture = require 'cherry.libs.gesture'

local Text = {}

--------------------------------------------------------------------------------

function Text:create(options)
  local text =
    _.defaults(
    options,
    {
      x = 0,
      y = 0,
      anchorX = 0.5,
      anchorY = 0.5,
      grow = false,
      font = _G.FONTS.default,
      color = '#ffffff',
      fontSize = 40
    }
  )

  setmetatable(text, {__index = Text})

  text.display = display.newGroup()

  if (text.parent and text.parent.insert) then
    text.parent:insert(text.display)
  end

  text.display.x = text.x
  text.display.y = text.y

  text.display.anchorX = text.anchorX
  text.display.anchorY = text.anchorY

  if (options.onTap) then
    gesture.onTap(text.display, options.onTap)
  end

  text:render()
  return text
end

--------------------------------------------------------------------------------

function Text:render()
  if (self.currentValue) then
    if (self.currentAnimation) then
      transition.cancel(self.currentAnimation)
    end
    display.remove(self.currentValue)
  end

  if (self.display == nil) then
    return
  end

  self.currentValue =
    TextUtils.simple(
    {
      parent = self.display,
      text = self.value,
      font = self.font or _G.FONTS.default,
      fontSize = self.fontSize or 55,
      x = 0,
      y = 0,
      width = self.width,
      align = self.align
    }
  )

  if (self.currentValue == nil) then
    return
  end

  self.currentValue:setFillColor(colorize(self.color))

  -- if(self.width) then
  --   self.currentValue.width = self.width
  -- end

  -- if(self.height) then
  --   self.currentValue.height = self.height
  -- end

  if (self.grow) then
    animation.grow(self.currentValue)
  end

  if (self.animation) then
    self.currentAnimation = transition.to(self.display, self.animation)
  end

  self.currentValue.anchorX = self.anchorX or 0.5
  self.currentValue.anchorY = self.anchorY or 0.5
end

--------------------------------------------------------------------------------

function Text:setValue(value)
  self.value = value
  self:render()
end

function Text:setColor(color)
  self.color = color
  self.currentValue:setFillColor(colorize(self.color))
end

function Text:getWidth()
  return self.currentValue.width
end

function Text:getHeight()
  return self.currentValue.height
end

--------------------------------------------------------------------------------

function Text:destroy()
  display.remove(self.display)
end

--------------------------------------------------------------------------------

return Text
