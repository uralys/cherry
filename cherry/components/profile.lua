--------------------------------------------------------------------------------

local _           = require 'cherry.libs.underscore'
local ProgressBar = require 'cherry.components.progress-bar'

--------------------------------------------------------------------------------

local Profile = {}

--------------------------------------------------------------------------------

function Profile:new(options)
    local profile = {}

    setmetatable(profile, { __index = Profile })
    return profile;
end

--------------------------------------------------------------------------------

function Profile:status(options)
    local progress = ProgressBar:new(_.extend({
        iconImage = options.iconImage or 'cherry/assets/images/gui/items/gem.icon.png'
    }, options))

    progress:set(0)
    progress:reach(options.step)
end

--------------------------------------------------------------------------------

return Profile
