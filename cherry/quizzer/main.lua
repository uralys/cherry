--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local colorize = require 'cherry.libs.colorize'
local Text = require 'cherry.components.text'

local ContentProvider = require 'cherry.quizzer.content-provider'
local ProgressionRecorder = require 'cherry.quizzer.progression-recorder'
local Slide = require 'cherry.quizzer.components.slide'

--------------------------------------------------------------------------------

local Quizzer = {}

--------------------------------------------------------------------------------

local hiddenMargin = 50
local INFO_PANEL_HEIGHT = 280

--------------------------------------------------------------------------------

-- options:
--   content    : json,
--   parent     : displayObject
--   onValidate : function
--   alpha      : [0,1]
--   correctionTitleAdjustY : number default 0
function Quizzer:create(options)
  if (not options.progressionData.engine) then
    _G.log('[quizzer]: no options.progressionData.engine was provided')
    return
  end
  local quizzer =
    _.defaults(
    options or {},
    {
      parent = App.hud,
      height = H,
      y = 0,
      correctionTitleAdjustY = 0,
      infoPanelColor = '#00000060'
    }
  )

  setmetatable(quizzer, {__index = Quizzer})

  quizzer.provider =
    ContentProvider:create(
    {
      type = 'coorp',
      content = options.content
    }
  )

  quizzer.currentSlideData = quizzer.provider:nextSlide()

  quizzer.recorder =
    ProgressionRecorder:create(
    {
      type = 'coorp',
      progressionData = options.progressionData
    }
  )

  quizzer:createInfoPanel(
    {
      color = options.infoPanelColor
    }
  )

  return quizzer
end

--------------------------------------------------------------------------------

function Quizzer:createInfoPanel(options)
  local info = display.newGroup()
  info.visibleCenterY = hiddenMargin / 2
  info.x = W * 0.5
  info.y = -INFO_PANEL_HEIGHT - 2 * hiddenMargin
  info.anchorChildren = true
  info.anchorY = 0
  self.parent:insert(info)

  local panel = display.newRect(info, 0, 0, W, INFO_PANEL_HEIGHT)
  panel:setFillColor(colorize(options.color))

  self.infoPanel = info
end

--------------------------------------------------------------------------------

function Quizzer:showCorrection(isCorrect)
  local correction = display.newGroup()
  correction.visibleCenterY = hiddenMargin / 2
  correction.x = W * 0.5
  correction.y = -hiddenMargin
  correction.anchorChildren = true
  correction.anchorY = 0
  self.parent:insert(correction)

  ----------------

  local title = 'Oups...'
  local color = App.colors.bad
  local textY = correction.visibleCenterY

  if (isCorrect) then
    title = 'Bonne réponse!'
    color = App.colors.good
    textY = textY + self.correctionTitleAdjustY
  end

  ----------------

  local panel = display.newRect(correction, 0, 0, W, 300)
  panel:setFillColor(colorize(color))

  Text:create(
    {
      parent = correction,
      x = 100 - W * 0.5,
      y = textY,
      anchorX = 0,
      value = title,
      fontSize = 65,
      color = '#ffffff'
    }
  )

  transition.from(
    correction,
    {
      y = -400,
      time = 450,
      transition = easing.outBack
    }
  )

  transition.to(
    correction,
    {
      delay = 2000,
      y = -400,
      time = 450,
      transition = easing.inBack
    }
  )

  return correction
end

--------------------------------------------------------------------------------

function Quizzer:close()
  self.currentSlide:close(true)

  transition.to(
    self.infoPanel,
    {
      y = -600,
      transition = easing.inBack
    }
  )
end

--------------------------------------------------------------------------------

function Quizzer:showQuestion()
  transition.to(
    self.infoPanel,
    {
      y = -hiddenMargin,
      time = 450,
      transition = easing.outBack
    }
  )

  self.currentSlide =
    Slide:create(
    {
      parent = self.parent,
      alpha = self.alpha,
      defaultTextColor = self.defaultTextColor,
      highlightTextColor = self.highlightTextColor,
      highlightColor = self.highlightColor,
      data = self.currentSlideData,
      x = 0,
      y = self.y,
      height = self.height,
      onValidate = function(isCorrect)
        local correctionPanel = self:showCorrection(isCorrect)
        local slide = self.currentSlideData
        self.currentSlideData = self.provider:nextSlide()

        if (self.onValidate) then
          self.onValidate(
            {
              isCorrect = isCorrect,
              slide = slide,
              nextSlide = self.currentSlideData
            },
            correctionPanel
          )
        end
      end
    }
  )
end

--------------------------------------------------------------------------------

return Quizzer
