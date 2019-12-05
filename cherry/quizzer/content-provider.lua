--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local ContentProvider = {}

--------------------------------------------------------------------------------

-- options:
-- type: [coorp]
-- content: json
function ContentProvider:create(options)
  local provider = _.extend({}, options)
  setmetatable(provider, {__index = ContentProvider})

  if (provider.type == 'coorp') then
    provider.slides = provider.content.slides
    provider.keys = {}
    provider.currentKeyNum = 0

    for key, _ in pairs(provider.slides) do
      provider.keys[#provider.keys + 1] = key
    end
  else
    _G.log('[ContentProvider] ' .. type .. ' not handled')
  end

  return provider
end

--------------------------------------------------------------------------------

local isHandled = function(type)
  return type == 'qcm' or type == 'qcmDrag'
end

function ContentProvider:nextSlide()
  self.currentKeyNum = self.currentKeyNum + 1

  local ref = self.keys[self.currentKeyNum]
  local slide = self.slides[ref]

  if (not slide) then
    self.currentKeyNum = 0
    _G.log('[ContentProvider] reached the end ! restarting slides')
    return self:nextSlide()
  end

  local hasContext = slide.context.description
  if (hasContext) then
    _G.log(
      '[ContentProvider] slide [' ..
        ref .. '] has a context: not handled so far.'
    )
    return self:nextSlide()
  end

  local type = slide.question.type
  if (not isHandled(type)) then
    _G.log('[ContentProvider] type [' .. type .. '] is not handled so far.')
    return self:nextSlide()
  end

  return slide
end

--------------------------------------------------------------------------------

return ContentProvider
