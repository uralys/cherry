--------------------------------------------------------------------------------

local _     = require 'underscore'
local utils = require 'utils'

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
    self.savedData = utils.loadUserData('savedData.json');

    -- preparing data
    if(not self.savedData) then
        self:resetSavedData()
    end

    self:resetLevel()

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

function User:resetLevel()
    self.level = 1
end

function User:growLevel()
    self.level = self.level+1
    return self.level
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
    utils.saveTable(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------
--  Profile crawling
--------------------------------------------------------------------------------

function User:isNew()
    return not self.savedData.profile.tutorial
end

--------------------------------------------------------------------------------

function User:totalPercentage()
    return utils.toPercentage(12, 28)
end

--------------------------------------------------------------------------------

return User
