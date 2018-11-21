--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local TextUtils = require 'cherry.libs.text'
local colorize  = require 'cherry.libs.colorize'
local animation = require 'cherry.libs.animation'
local gesture   = require 'cherry.libs.gesture'

local Text = {}

--------------------------------------------------------------------------------

function Text:create(options)
  local text = _.defaults(options, {
    x        = 0,
    y        = 0,
    font     = _G.FONT,
    fontSize = 40
  })

  setmetatable(text, { __index = Text })

  text.display = display.newGroup()

  if(text.parent) then
    text.parent:insert(text.display)
  end

  text.display.x = text.x
  text.display.y = text.y

  if(options.onTap) then
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

  if(self.display == nil) then return end

  self.currentValue = TextUtils.simple({
    parent   = self.display,
    text     = self.value,
    font     = self.font or _G.FONT,
    fontSize = self.fontSize or 55,
    x        = 0,
    y        = 0
  })

  self.currentValue:setFillColor( colorize(self.color or '#ffffff') )

  if (self.grow) then
    animation.grow(self.currentValue)
  end

  if (self.animation) then
    self.currentAnimation = transition.to(self.display, self.animation)
  end

  self.currentValue.anchorX = self.anchorX or 0.5
end

--------------------------------------------------------------------------------

function Text:setValue(value)
  self.value = value
  self:render()
end

function Text:width()
  return self.currentValue.width
end

--------------------------------------------------------------------------------

function Text:destroy()
  display.remove(self.display)
end

--------------------------------------------------------------------------------

return Text
