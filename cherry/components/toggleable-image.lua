--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'

--------------------------------------------------------------------------------

local ToggleableImage = {}

--------------------------------------------------------------------------------

function ToggleableImage:new(options)
  options = _.defaults(options, {
    scale = 1,
    bounceTime = 200
  })

  self.options = options

  local image = display.newImage(
    options.parent,
    options.image,
    options.x,
    options.y
  )

  local scale = options.scale
  image:scale(scale, scale)

  self.image = image
  return self
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

  if(changed) then
    self:bounce()
  end
end

function ToggleableImage:off()
  local changed = self.image.fill.effect == nil
  self.image.fill.effect = 'filter.desaturate'
  self.image.fill.effect.intensity = 1

  if(changed) then
    self:bounce()
  end
end

--------------------------------------------------------------------------------

return ToggleableImage
