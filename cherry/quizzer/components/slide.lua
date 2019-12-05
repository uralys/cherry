--------------------------------------------------------------------------------

local Choice = require 'cherry.quizzer.components.choice'
local Text = require 'cherry.components.text'
local Button = require 'cherry.components.button'
local _ = require 'cherry.libs.underscore'
local deepEqual = require 'cherry.libs.deep-equal'

--------------------------------------------------------------------------------

local Slide = {}

--------------------------------------------------------------------------------

function Slide:isAnswer(label)
  -- question.content.answers is [[]]
  local answers = self.data.question.content.answers[1]
  for i = 1, #answers do
    if (label == answers[i]) then
      return true
    end
  end

  return false
end

--------------------------------------------------------------------------------

local VERTICAL_PADDING = display.contentHeight * 0.05
local VALIDATION_HEIGHT = display.contentHeight * 0.1

--------------------------------------------------------------------------------

-- options:
--   parent, x, y
--   data: slideData
--   onValidate
--   alpha: [0,1]
function Slide:create(options)
  if (not options.data) then
    _G.log('usage: Slide:create({data: slideData})')
  end

  local component =
    _.defaults(
    options or {},
    {
      isAnswered = false,
      height = H,
      y = 0
    }
  )
  setmetatable(component, {__index = Slide})

  component.display = display.newGroup()
  options.parent:insert(component.display)
  component.display.x = options.x
  component.display.y = options.y

  component.question =
    Text:create(
    {
      parent = component.display,
      x = W * 0.5,
      y = VERTICAL_PADDING,
      anchorY = 0,
      width = W * 0.8,
      value = options.data.question.header,
      fontSize = 37,
      font = _G.FONTS.semiBold
    }
  )

  component.explanation =
    Text:create(
    {
      parent = component.display,
      value = '(' .. options.data.question.explanation .. ')',
      x = W * 0.5,
      y = component.question.display.y + component.question.display.height + 5,
      anchorY = 0,
      fontSize = 25,
      color = '#c5c5c5'
    }
  )

  local content = options.data.question.content
  component:drawChoices(content.choices)
  component:drawValidateButton()
  component:showQuestion()

  return component
end

--------------------------------------------------------------------------------

function Slide:choicesHeight()
  return self.height - VERTICAL_PADDING - self.question:getHeight() -
    VERTICAL_PADDING -
    VERTICAL_PADDING -
    VALIDATION_HEIGHT -
    VERTICAL_PADDING
end

--------------------------------------------------------------------------------

function Slide:dryDraw(choicesData)
  local metrics = {
    textHeight = 0
  }

  for i, data in pairs(choicesData) do
    local _choice =
      Choice:create(
      data,
      {
        parent = self.display,
        x = 0,
        y = 0
      }
    )

    local height = _choice:textHeight()
    metrics.textHeight = metrics.textHeight + height
    metrics[i] = height
    _choice:destroy()
  end

  return metrics
end

--------------------------------------------------------------------------------

function Slide:realDraw(choicesData, metrics)
  self.choices = {}
  local freeHeight = self:choicesHeight() - metrics.textHeight
  local paddingByItem = (freeHeight / 2) / #choicesData
  local marginByItem = (freeHeight / 2) / #choicesData
  local choicesTop =
    VERTICAL_PADDING + self.question:getHeight() + VERTICAL_PADDING

  local latestY = choicesTop

  for i, data in pairs(choicesData) do
    local itemHeight = metrics[i] + paddingByItem
    local y = latestY + marginByItem / 2 + itemHeight / 2

    self.choices[#self.choices + 1] =
      Choice:create(
      data,
      {
        parent = self.display,
        height = itemHeight,
        -- xFrom = W * 0.5 - W * 0.6 * alternate(#self.choices),
        xFrom = 0,
        xTo = W * 0.5,
        y = y,
        delay = #self.choices * 150,
        time = 550,
        alpha = self.alpha,
        defaultTextColor = self.defaultTextColor,
        highlightTextColor = self.highlightTextColor,
        highlightColor = self.highlightColor,
        checkIsLocked = function()
          return self.isAnswered
        end,
        showAnswer = _G.SHOW_ANSWERS and self:isAnswer(data.label),
        isAnswer = self:isAnswer(data.label)
      }
    )

    latestY = y + itemHeight / 2 + marginByItem / 2
  end
end

--------------------------------------------------------------------------------

function Slide:drawChoices(choicesData)
  local metrics = self:dryDraw(choicesData)
  self:realDraw(choicesData, metrics)
end

--------------------------------------------------------------------------------

function Slide:drawValidateButton()
  local validateButton = display.newGroup()
  self.validateButton = validateButton
  self.display:insert(validateButton)
  validateButton.x = W * 0.5
  validateButton.y = H * 1.4

  Button:create(
    {
      parent = validateButton,
      x = 0,
      y = 0,
      bg = {
        color = self.highlightColor,
        width = W * 0.7,
        height = 100,
        cornerRadius = 50
      },
      text = {
        value = 'Valider',
        font = _G.FONTS.semiBold,
        fontSize = 50,
        color = '#ffffff'
      },
      action = function()
        if (self.hasValidated) then
          return
        end
        self.hasValidated = true
        self:validate()
      end
    }
  )

  transition.to(
    validateButton,
    {
      y = H - 2 * VERTICAL_PADDING - self.y,
      time = 500,
      transition = easing.outQuad
    }
  )
end

--------------------------------------------------------------------------------

function Slide:showQuestion()
  local options = {
    alpha = 0,
    transition = easing.outQuad,
    time = 350
  }

  transition.from(self.question.display, options)
  transition.from(self.explanation.display, options)
end

function Slide:hideQuestion()
  local options = {
    alpha = 0,
    transition = easing.inQuad,
    time = 350
  }

  transition.to(self.question.display, options)
  transition.to(self.explanation.display, options)
end

function Slide:hideValidateButton()
  transition.to(
    self.validateButton,
    {
      y = H + 500,
      time = 500,
      transition = easing.inQuad
    }
  )
end

--------------------------------------------------------------------------------

function Slide:close(force)
  if (self.isAnswered) then
    return
  end

  self.isAnswered = true
  self:hideQuestion()
  self:hideValidateButton()

  if (force) then
    self:destroy()
  else
    timer.performWithDelay(
      2000,
      function()
        self:destroy()
      end
    )
  end
end

--------------------------------------------------------------------------------

function Slide:validate()
  self:close(false)

  local userAnswers = {}
  for _, choice in pairs(self.choices) do
    if (choice.selected) then
      userAnswers[#userAnswers + 1] = choice.data.label
    end

    if (choice.isAnswer) then
      choice:setColor(App.colors.good, App.colors.dark)
    elseif (choice.selected) then
      choice:setColor(App.colors.bad, App.colors.dark)
    else
      choice:hide()
    end
  end

  table.sort(userAnswers)

  local answers = {}
  -- note: question.content.answers is [[]]
  local _answers = self.data.question.content.answers[1]
  for i = 1, #_answers do
    answers[#answers + 1] = _answers[i]
  end

  table.sort(answers)
  local isCorrect = deepEqual(answers, userAnswers)

  if (self.onValidate) then
    self.onValidate(isCorrect)
  end
end

--------------------------------------------------------------------------------

function Slide:destroy()
  for _, choice in pairs(self.choices) do
    choice:hide()
  end

  display.remove(self.display)
  self.display = nil
  self.validateButton = nil
  self.choices = nil
  self.explanation = nil
  self.question = nil
end

--------------------------------------------------------------------------------

return Slide
