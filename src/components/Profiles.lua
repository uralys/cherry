--------------------------------------------------------------------------------

local Profiles = {}

--------------------------------------------------------------------------------

function Profiles:draw(options)
    User:resetLevelSelection()

    local selectedProfile

    local x = {
        display.contentWidth * 0.25,
        display.contentWidth * 0.75,
        display.contentWidth * 0.75
    }

    local y = {
        display.contentHeight * 0.5,
        display.contentHeight * 0.25,
        display.contentHeight * 0.75
    }

    for i,profile in pairs(User.savedData.profiles) do

        local profilePanel = Profile:draw({
            parent  = options.parent,
            profile = profile,
            x       = x[i],
            y       = y[i],
            width   = display.contentWidth*0.37,
            height  = display.contentHeight*0.33
        })

        profilePanel.onSelect = function()
            analytics.event('user', 'switch-profile')
            User:switchProfile(i)
            selectedProfile:unselect()
            selectedProfile = profilePanel
            selectedProfile:select()
            options.refresh()
        end

        if(User.profile == profile) then
            selectedProfile = profilePanel
            selectedProfile:select()
        end
    end
end

--------------------------------------------------------------------------------

return Profiles
