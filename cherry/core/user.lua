--------------------------------------------------------------------------------

local _    = require 'cherry.libs.underscore'
local file = _G.file or require 'cherry.libs.file'

local User = {}

--------------------------------------------------------------------------------

function User:new(extension)
    local user = _.extend({
        savedData = nil,
        profile   = nil
    }, extension);

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
    self.savedData = {
        version = App.version,
        options = {
            sound = true
        },
        profile = {
            tutorial = false
        }
    }

    if (self.onResetSavedData) then
        self:onResetSavedData() -- from extension
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

--------------------------------------------------------------------------------

function User:save()
    file.save(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------

function User:isNew()
    return not self.savedData.profile.tutorial
end

function User:onTutorialDone()
  self.savedData.profile.tutorial = true
  self:save()
end

--------------------------------------------------------------------------------

return User
