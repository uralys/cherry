--------------------------------------------------------------------------------

local User = {}

--------------------------------------------------------------------------------

function User:new(options)
    local user = _.extend({
        savedData = nil,
        profile   = nil
    }, options);

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
end

--------------------------------------------------------------------------------

function User:resetSavedData()
    self.savedData = {
        version = App.VERSION,
        profile = initPlayer(1)
    }

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
-- PRIVATE
--------------------------------------------------------------------------------

function initPlayer(num)
    return {
        name      = 'Player ' .. num,
        analytics = {},
        options   = {}
    }
end

--------------------------------------------------------------------------------

return User
