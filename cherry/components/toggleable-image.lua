--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'

--------------------------------------------------------------------------------

local ToggleableImage = {}

--------------------------------------------------------------------------------

function ToggleableImage:new(options)
  options = _.defaults(options, {
    isOn       = true,
    scale      = 1,
    bounceTime = 200
  })


  local image = display.newImage(
    options.parent,
    options.image,
    options.x,
    options.y
  )

  local scale = options.scale
  image:scale(scale, scale)

  local o = {
    image = image,
    options = options
  }

  setmetatable(o, { __index = ToggleableImage })
  return o
end

--------------------------------------------------------------------------------

function ToggleableImage:bounce()
  animation.bounce(self.image, {
    scaleTo = self.options.scale,
    time    = self.options.bounceTime
  })
end

--------------------------------------------------------------------------------

function ToggleableImage:on()
  local changed = self.image.fill.effect ~= nil
  self.image.fill.effect = nil
  self.isOn = true

  if(changed) then
    self:bounce()
  end
end

function ToggleableImage:off()
  local changed = self.image.fill.effect == nil
  self.image.fill.effect = 'filter.desaturate'
  self.image.fill.effect.intensity = 1
  self.isOn = false

  if(changed) then
    self:bounce()
  end
end

--------------------------------------------------------------------------------

function ToggleableImage:destroy()
  display.remove(self.image)
  self.image = nil
end

--------------------------------------------------------------------------------

return ToggleableImage
