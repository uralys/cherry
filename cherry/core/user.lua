--------------------------------------------------------------------------------

local _           = require 'cherry.libs.underscore'
local generateUID = require 'cherry.libs.generate-uid'
local file = _G.file or require 'cherry.libs.file'

local User = {}

--------------------------------------------------------------------------------

function User:new(extension)
  local user = _.extend({}, extension);
  setmetatable(user, { __index = User })
  return user;
end

--------------------------------------------------------------------------------

function User:load()
  self.savedData = file.loadUserData('savedData.json');

  -- preparing data
  if(not self.savedData) then
    self:resetSavedData()
  end

  if (self.onLoad) then
    self:onLoad() -- from extension
  end
end

--------------------------------------------------------------------------------

function User:resetSavedData()
  local previousSavedData = self.savedData
  local id

  if(previousSavedData) then
    id = previousSavedData.profile.id
  else
    id = generateUID()
  end

  self.savedData = {
    version = App.version,
    options = {
      sound = true
    },
    profile = {
      id = id,
      name = nil,
      tutorial = false
    }
  };

  if (self.onResetSavedData) then
    self:onResetSavedData(previousSavedData) -- from extension
  end

  self:save()
end

--------------------------------------------------------------------------------

function User:saveSoundSettings(soundOff)
  self.savedData.options.sound = not soundOff
  self:save()
end

function User:isSoundOff()
  return not self.savedData.options.sound;
end

function User:id()
  return self.savedData.profile.id;
end

function User:name()
  return self.savedData.profile.name;
end

function User:setName(name)
  self.savedData.profile.name = name
  self:save()
end

--------------------------------------------------------------------------------

function User:save()
  file.save(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------

function User:isNew()
  return not self.savedData.profile.tutorial
end

function User:name()
  return self.savedData.profile.name
end

function User:onTutorialDone()
  self.savedData.profile.tutorial = true
  self:save()
end

--------------------------------------------------------------------------------

return User
