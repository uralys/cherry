--------------------------------------------------------------------------------

local _        = require 'cherry.libs.underscore'
local group    = require 'cherry.libs.group'
local colorize = require 'cherry.libs.colorize'
local Icon     = require 'cherry.components.icon'
local Text     = require 'cherry.components.text'

--------------------------------------------------------------------------------

local ProgressBar = {}

--------------------------------------------------------------------------------
-- options:
--  parent, x, y, width, height
--  useRects   : boolean: default false : when no assets are to be used
--  rail
--  track
--  iconImage
--  trackColor : string: default '#119911' to colorize progress rect
--  trackFilledColor : string: default #FFFF00' progress rect 100%
--  changeBG   : boolean: switch to greenBg at 100%
--  vertical   : boolean: default false
--  disabled   : boolean: default false
--  hideText   : boolean: default false
--  hideIcon   : boolean: default false
function ProgressBar:new (options)
  options = _.defaults(options, {
    width  = 300,
    height = 35,

    useRects  = false,
    changeBG  = false,
    vertical  = false,
    disabled  = false,
    hideText  = false,
    hideIcon  = false,
    rail      = nil,
    iconImage = nil,

    trackColor       = '#119911',
    trackFilledColor = '#FFFF00'
  })

  local bar = _.extend({
    queue = {}
  }, options);

  setmetatable(bar, { __index = ProgressBar })

  bar:draw()
  return bar;
end

--------------------------------------------------------------------------------

function ProgressBar:draw()
  self:prepare()
  self:background()
  self:progress()

  if(not self.hideText) then self:addText () end
  if(not self.hideIcon) then self:icon() end
end

function ProgressBar:destroy()
  group.destroy(self.display)
end

--------------------------------------------------------------------------------
--  Construction
--------------------------------------------------------------------------------

function ProgressBar:prepare()
  self.display   = display.newGroup()
  self.display.x = self.x
  self.display.y = self.y

  if(self.vertical) then
    self.display.rotation = -90
  end

  self.parent:insert(self.display)
end

--------------------------------------------------------------------------------

function ProgressBar:background()
  if(self.useRects) then
    self.bg = display.newRoundedRect(
      self.display, 0, 0,
      self.width,
      self.height,
      10
    )

    self.bg.anchorX = 0
    self.bg.alpha = 0.8
    self.bg:setFillColor( 0.5 )
  else
    self:backgroundWithAsset()
  end
end

--------------------------------------------------------------------------------

function ProgressBar:backgroundWithAsset()
  self.bg = display.newImage(
    self.display,
    self.rail or 'cherry/assets/images/gui/progress-bar/loading-bg.png'
  )

  self.bg.width  = self.width
  self.bg.height = self.height

  if(self.disabled) then
    self.bg.fill.effect = 'filter.desaturate'
    self.bg.fill.effect.intensity = 0.8
  end

  ------------

  self.bgGreen = display.newImage(
    self.display,
    'cherry/assets/images/gui/progress-bar/loading-bg-green.png'
  )

  self.bgGreen.width  = self.width
  self.bgGreen.height = self.height
  self.bgGreen.alpha = 0
end

--------------------------------------------------------------------------------

function ProgressBar:progress()
  if(self.useRects) then
    self.progress = display.newRoundedRect(
      self.display, 0, 0,
      self.width,
      self.height,
      10
    )

    self.progress.anchorX = 0
    self.progress:setFillColor(
      colorize(self.trackColor)
    )
  else
    self:progressWithAsset()
  end
end

function ProgressBar:progressWithAsset()
  self.progress = display.newImage(
    self.display,
    self.track or 'cherry/assets/images/gui/progress-bar/loading-progress.png'
  )

  self.progress.width   = self:progressWidth()
  self.progress.height  = self.height * 0.69
  self.progress.anchorX = 0
  self.progress.x       = - self.width / 2.06

  self.progress:setMask( graphics.newMask(
    'cherry/assets/images/gui/progress-bar/loading-mask.png'
  ))
end

function ProgressBar:icon()
  if(not self.iconImage) then
    return
  end

  local logoContainer = display.newImage(
    self.display,
    'cherry/assets/images/gui/items/circle.container.simple.png',
    - self.width * 0.55, 0
  )

  if(self.disabled) then
    logoContainer.fill.effect = 'filter.desaturate'
    logoContainer.fill.effect.intensity = 0.8
  end

  -----------------

  logoContainer.icon = Icon:draw({
    parent  = self.display,
    x       = - self.width * 0.55,
    y       = 0,
    maxSize = logoContainer.height * 0.6,
    image   = self.iconImage
  })

  self.logoContainer = logoContainer
end

function ProgressBar:addText()
  self.text = Text:create({
    parent   = self.display,
    value    = '',
    x        = 0,
    y        = 0,
    font     = _G.FONT,
    fontSize = self.progress.height*0.7,
  })
end

--------------------------------------------------------------------------------
-- Tools
--------------------------------------------------------------------------------

function ProgressBar:progressWidth()
  return self.bg.width*0.97
end

function ProgressBar:showGreenBG()
  transition.to(self.bgGreen, {
    alpha      = 1,
    transition = easing.outQuad,
    time       = 1400
  })
end

--------------------------------------------------------------------------------

function ProgressBar:maskX(value)
  return (value * (self:progressWidth()/100)) - self:progressWidth()/1.835
end

function ProgressBar:currentValue()
  if(self.useRects) then
    return 100 * self.progress.width / self.width
  else
    return (self.progress.maskX + self:progressWidth()/1.835 ) / (self:progressWidth()/100)
  end
end

--------------------------------------------------------------------------------

function ProgressBar:runNextInQueue(force)
  if(force)
    then self.currentActionRunning = nil
  end

  if(self.currentActionRunning) then return end
  if(#self.queue == 0) then return end

  local action = table.shift(self.queue)
  self.currentActionRunning = action
  self:reach(action.value, action)
end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function ProgressBar:set(value)
  self:stop()

  if(self.text) then
    self.text:setValue(value .. '%')
  end

  if(self.useRects) then
    self.progress.width = self.width * value/100
  else
    self.progress.maskX = self:maskX(value)
    if(self.changeBG and value == 100) then self:showGreenBG() end
  end
end

function ProgressBar:stop()
  if(self.reachTransition) then
    transition.cancel(self.reachTransition)
  end
end

function ProgressBar:reach(step, options)
  options = _.defaults(options, {
    transition = easing.outQuad,
    time       = 1400
  })

  if(self.reachTransition) then
    transition.cancel(self.reachTransition)
  end

  local value, text

  if('table' == type(step)) then
    value = step.value
    text = step.text
  else
    value = step
    text = value .. '%'
  end

  if(self.text) then
    self.text:setValue(text)
  end

  local params = {
    transition = options.transition,
    time       = options.time,
    onComplete = options.onComplete
  }

  if(self.useRects) then
    params.width = self.width * value/100
  else
    params.maskX = self:maskX(value)
  end

  self.reachTransition = transition.to(self.progress, params)

  if(self.changeBG and value == 100) then self:showGreenBG() end

  if(value == 100) then
    self.progress:setFillColor(
      colorize(self.trackFilledColor)
    )

    if(not self.useRects) then
      self.progress.fill.effect = "filter.brightness"
      self.progress.fill.effect.intensity = 0.3
    end

  else
    if(not self.useRects) then
      self.progress.fill.effect = nil
      self.progress:setFillColor(1)
    end
  end
end

---
-- adds an action within the queue
-- when a "fill-then-reset" animation is completed, the next action is triggered
-- action
--   type: 'fill-then-reset', 'reach'
--   value: number (for type 'reach')
function ProgressBar:add(action)
  local defaultAction = {}

  if(self.currentActionRunning and self.currentActionRunning.type == 'reach') then
    self.currentActionRunning = nil
  end

  if(action.type == 'fill-then-reset') then
    defaultAction.value = 100
    defaultAction.onComplete = function()
      local height = self.progress.height
      transition.to(self.progress, {
        time = 90,
        height = height * 1.4,
        alpha = 0.7,
        onComplete = function()
          transition.to(self.progress, {
            time = 90,
            height = height,
            alpha = 0.2,
            onComplete = function()
              self.progress.alpha = 1
              self:set(0)
              self:runNextInQueue(true)
            end
          })
        end
      })
    end

  elseif(action.type == 'reach') then
    defaultAction.onComplete = function()
      self:runNextInQueue(true)
    end
  end

  local next = #self.queue + 1
  if(#self.queue > 0 and self.queue[#self.queue].type == 'reach') then
    next = #self.queue
  end

  self.queue[next] = _.defaults(defaultAction, action)
  self:runNextInQueue()
end

--------------------------------------------------------------------------------

return ProgressBar
