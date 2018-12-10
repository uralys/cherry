--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local group     = require 'cherry.libs.group'
local Button    = require 'cherry.components.button'
local Text      = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Counter = {}

--------------------------------------------------------------------------------

function Counter:create(options)
  options = _.defaults(options or {}, {
    x         = 0,
    y         = 0,
    iconScale = 1,
    font      = _G.FONT,
    fontSize  = 45,
    value     = '0',
    icon      = 'cherry/assets/images/gui/items/gem.green.png',
  })

  local counter = {
    options = options
  }

  setmetatable(counter, { __index = Counter })

  counter.display = display.newGroup()
  counter.display.x = options.x
  counter.display.y = options.y
  options.parent:insert(counter.display)

  counter:createBg()
  counter:createIcon()
  counter:createAddButton()
  counter:createText()

  return counter
end

--------------------------------------------------------------------------------

function Counter:createBg(newValue)
  self.textBG = display.newImage(
    self.display,
    'cherry/assets/images/gui/items/text-bg-dark.png',
    0, 0
  )
end

--------------------------------------------------------------------------------

function Counter:createIcon()
  self.icon = display.newImage(
    self.display,
    self.options.icon,
    self.display.width/2, 0
  )

  self.icon:scale(self.options.iconScale, self.options.iconScale)
end

--------------------------------------------------------------------------------

function Counter:createAddButton()
  self.addButton = Button:icon({
    parent = self.display,
    type   = 'add',
    x      = 40 - self.display.width/2,
    y      = 0,
    scale  = 0.7,
    action = function() App.namePicker:display() end
  })
end

--------------------------------------------------------------------------------

function Counter:createText()
  self.text = Text:create({
    parent   = self.display,
    value    = self.options.value,
    grow     = true,
    anchorX  = 1,
    x        = self.display.width/2 - 90,
    y        = -2,
    color    = '#ffffff',
    fontSize = self.options.fontSize
  })
end

--------------------------------------------------------------------------------

function Counter:setValue(newValue)
  self.text:setValue(newValue)
end

function Counter:bounce()
  animation.bounce(self.icon, {
    time = 150,
    scaleFrom = self.options.iconScale * 0.7,
    scaleTo = self.options.iconScale
  })
end

--------------------------------------------------------------------------------

function Counter:destroy(newValue)
  group.destroy(self.display)
end

--------------------------------------------------------------------------------

return Counter
