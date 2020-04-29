--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local ProgressionRecorder = {}

--------------------------------------------------------------------------------

-- options:
-- game: string [spaceship|forest]
-- content: json
function ProgressionRecorder:create(options)
  local recorder = _.extend({}, options)
  setmetatable(recorder, {__index = ProgressionRecorder})
  recorder:createProgression()
  return recorder
end

--------------------------------------------------------------------------------

function ProgressionRecorder:createProgression()
  self.progression = {
    userId = 'todo-plug-me',
    engine = {
      ref = self.progressionData.engine,
      version = 1
    },
    actions = {},
    content = self.progressionData.content
  }
end

--------------------------------------------------------------------------------

function ProgressionRecorder:addAnswer(data)
  local isCorrect = data.isCorrect
  local slide = data.slide
  local nextSlide = data.nextSlide

  local action = {
    type = 'answer',
    authors = {App.user:deviceId()},
    isCorrect = isCorrect,
    godMode = _G.SHOW_ANSWERS,
    content = {
      ref = slide.universalRef,
      type = 'slide'
    },
    nextContent = {
      ref = nextSlide.universalRef,
      type = 'slide'
    }
  }

  return self:addAction(action)
end

--------------------------------------------------------------------------------

function ProgressionRecorder:addFinalAnswer(data, isSuccess)
  local isCorrect = data.isCorrect
  local slide = data.slide
  local nextContent

  if (isSuccess) then
    nextContent = {
      {ref = 'successExitNode', type = 'success'}
    }
  else
    nextContent = {
      {ref = 'failureExitNode', type = 'failure'}
    }
  end

  local action = {
    type = 'answer',
    authors = {App.user:deviceId()},
    isCorrect = isCorrect,
    content = {
      ref = slide.universalRef,
      type = 'slide'
    },
    godMode = _G.SHOW_ANSWERS,
    nextContent = nextContent
  }

  return self:addAction(action)
end

--------------------------------------------------------------------------------

function ProgressionRecorder:addAction(action)
  self.progression.actions[#self.progression.actions + 1] = action
  return action
end

--------------------------------------------------------------------------------

function ProgressionRecorder:print()
  _G.log({self.progression})
end

--------------------------------------------------------------------------------

-- @TODO /POST to /api-progression
function ProgressionRecorder:export()
  self:print()
  return self.progression
end

--------------------------------------------------------------------------------

return ProgressionRecorder
