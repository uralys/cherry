--------------------------------------------------------------------------------

local _           = require 'cherry.libs.underscore'
local file        = require 'cherry.libs.file'
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
    local path = nil
    if(options.item) then
        path = 'assets/images/gui/items/'.. options.item ..'.icon.png'

        if(not file.exists(path)) then
            path = 'cherry/assets/images/gui/items/'.. options.item ..'.icon.png'
        end
    end

    local progress = ProgressBar:new()
    progress:draw(_.extend({
        path = path
    }, options))

    progress:set(0)
    progress:reach(options.step)
end

--------------------------------------------------------------------------------

return Profile
