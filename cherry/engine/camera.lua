--------------------------------------------------------------------------------

local _     = require 'cherry.libs.underscore'
local group = require 'cherry.libs.group'

local Camera = {
  options = {},
  display = display.newGroup(),
  zoom    = 1
}

--------------------------------------------------------------------------------

local INIT_X = display.contentWidth * 0.5
local INIT_Y = display.contentHeight * 0.5

--------------------------------------------------------------------------------

local xShake = 16
local yShake = 8
local shakePeriod = 2

--------------------------------------------------------------------------------

function Camera:insert(stuff)
  self.display:insert(stuff)
end

function Camera:localToContent(x, y)
  self.display:localToContent(x, y)
end

--------------------------------------------------------------------------------

function Camera:empty()
  group.empty(self.display)
end

--------------------------------------------------------------------------------

function Camera:resetZoom()
  self.zoom = 1
end

--------------------------------------------------------------------------------

function Camera:toHUD(vector)
  local alpha = math.rad(Camera.display.rotation)
  local cameraX = vector.x * Camera.zoom
  local cameraY = vector.y * Camera.zoom

  local x = cameraX * math.cos(alpha) - cameraY * math.sin(alpha)
  local y = cameraX * math.sin(alpha) + cameraY * math.cos(alpha)

  return x + Camera.display.x, y + Camera.display.y
end

--------------------------------------------------------------------------------

-- INIT_X,Y should be defined by the current level offset from level[0,0]
-- default for Doors : not offset = the center of the screen = level[0,0]
function Camera:center()
  self.display.x = INIT_X
  self.display.y = INIT_Y

  -- reset then apply
    self.display.xScale = 1
    self.display.yScale = 1
    self.display:scale(self.zoom, self.zoom)
  end

  --------------------------------------------------------------------------------

  function Camera:start(options)
    self.options = _.extend(self.options, options)
    transition.cancel(self.display)
    self.display.alpha = 1
    App.hud:toFront()

    self.moveDisplay = function()
      if(self.shakeCount % shakePeriod == 0 ) then
        self.display.x = self.display.x0 + math.random( -xShake, xShake )
        self.display.y = self.display.y0 + math.random( -yShake, yShake )
      end
      self.shakeCount = self.shakeCount + 1
    end

    self.startShake = function()
      self.display.x0 = self.display.x
      self.display.y0 = self.display.y
      self.shakeCount = 0
      Runtime:addEventListener( 'enterFrame', self.moveDisplay )
    end

    self.stopShake = function()
      Runtime:removeEventListener( 'enterFrame', self.moveDisplay )
      self.display.x = INIT_X
      self.display.y = INIT_Y
      self.shaking = false
    end
  end

  function Camera:shake()
    if(self.shaking) then
      timer.cancel(self.shaking)
      self.stopShake()
    end

    self.startShake()
    self.shaking = timer.performWithDelay(250, self.stopShake)
  end

  function Camera:stop()
    transition.to (self.display, {
      alpha = 0,
      time = 500,
      xScale = 0.01,
      yScale = 0.01
    })
  end

  --------------------------------------------------------------------------------

  return Camera

