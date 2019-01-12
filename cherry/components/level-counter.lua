--------------------------------------------------------------------------------

local _           = require 'cherry.libs.underscore'
local Group       = require 'cherry.libs.group'
local Text        = require 'cherry.components.text'
local ProgressBar = require 'cherry.components.progress-bar'

--------------------------------------------------------------------------------

local LevelCounter = {}

--------------------------------------------------------------------------------

function LevelCounter:create(options)
  if(_G.isTutorial) then return end
  local counter = _.extend({}, options);
  setmetatable(counter, { __index = LevelCounter })

  counter.display = display.newGroup()
  options.parent:insert(counter.display)

  counter.display.x = options.x
  counter.display.y = options.y

  counter:createProgressBar()
  return counter
end

function LevelCounter:destroy()
  Group.destroy(self.display)
end

--------------------------------------------------------------------------------

function LevelCounter:show()
  self.display:show()
end

function LevelCounter:hide()
  transition.to(self.display, {
    y =  display.contentHeight * 1.5
  })
end

--------------------------------------------------------------------------------
-- Game API
--------------------------------------------------------------------------------

function LevelCounter:updateLevel(value)
  if(value > tonumber(self.progressBar.text.value)) then
    self.progressBar.text:setValue(value)
  end
end

--------------------------------------------------------------------------------
-- components
--------------------------------------------------------------------------------

function LevelCounter:createProgressBar(options)
  if(self.progressBar) then
    display.remove(self.progressBar)
  end

  self.progressBar = display.newGroup()
  self.display:insert(self.progressBar)
  self.progressBar.x = 10
  self.progressBar.y = 10

  local levelBarWidth = display.contentWidth * 0.5
  local levelNum = 1

  local levelBar = ProgressBar:new({
    parent   = self.progressBar,
    rail     = 'assets/images/gui/progress-bar/rail.png',
    track    = 'assets/images/gui/progress-bar/track.png',
    hideText = true,
    width    = levelBarWidth,
    height   = 50,
    x        = 0,
    y        = 0
  })

  local nbLevels = App.game:nbLevels()
  local ratio = levelNum * 100 / nbLevels

  levelBar:set(0)
  levelBar:reach(ratio, {
    time = 700,
    transition = easing.outCubic
  })

  self.progressBar.text = Text:create({
    parent   = self.progressBar,
    value    = 'level ' .. levelNum,
    anchorX  = 1,
    x        = 0,
    y        = 0,
    font     = _G.FONT,
    fontSize = 34,
    grow     = true
  })
end

--------------------------------------------------------------------------------

function LevelCounter:createStarCounter()
  local starCounter = display.newGroup()
  self.points:insert(starCounter)
  self.points.starCounter = starCounter
  starCounter.x = -45
  starCounter.y = 60

  self.points.star = display.newImage(
    starCounter,
    App.images.star,
    -45, 0
  )

  self.points.star:scale(0.3, 0.3)

  local starCounterBG = display.newImage(
    starCounter,
    'cherry/assets/images/gui/items/circle.container.simple.png',
    0, 0
  )

  starCounterBG:setFillColor(0.7)
  starCounterBG:scale(0.5, 0.5)
  starCounterBG.alpha = 0.6

  starCounter.text = Text:create({
    parent   = starCounter,
    value    = '0',
    x        = 0,
    y        = 0,
    font     = _G.FONT,
    fontSize = 30,
    grow     = true
  })

end

--------------------------------------------------------------------------------

return LevelCounter

