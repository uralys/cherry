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
-- 'resetSavedData' should be for admin/test only
function User:resetSavedData()
  local previousSavedData = self.savedData

  self.savedData = {
    version = App.version,
    tutorial = false,
    options = {
      sound = true
    },
    currentUser = 1,
    users = {
      {}
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
  return self.savedData.users[self.savedData.currentUser].id;
end

function User:name()
  return self.savedData.users[self.savedData.currentUser].name;
end

function User:newProfile(name)
  if(self.savedData.users[self.savedData.currentUser].name) then
    self.savedData.currentUser = #self.savedData.users + 1
  else
    self.savedData.currentUser = 1
  end

  local gameUserData = {}
  if (self.extendNewUser) then
    gameUserData = self:extendNewUser() -- from extension
  end

  local newUser = _.extend({
    id = generateUID(),
    name = name
  }, gameUserData)

  self.savedData.users[self.savedData.currentUser] = newUser

  self:save()
end

--------------------------------------------------------------------------------

function User:save()
  file.save(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------

function User:isNew()
  return not self.savedData.tutorial
end

function User:current()
  return self.savedData.currentUser
end

function User:name()
  return self.savedData.users[self.savedData.currentUser].name
end

function User:nbUsers()
  return #self.savedData.users
end

function User:switchToProfile(i)
  self.savedData.currentUser = i
  self:save()
end

function User:getUser(i)
  return self.savedData.users[i]
end

function User:onTutorialDone()
  self.savedData.tutorial = true
  self:save()
end

--------------------------------------------------------------------------------

return User
