
--------------------------------------------------------------------------------

local Profile = {}

--------------------------------------------------------------------------------

function Profile:new(options)
    local profile = {}

    setmetatable(profile, { __index = Profile })
    return profile;
end

--------------------------------------------------------------------------------
-- API to change status
--------------------------------------------------------------------------------

function Profile:select()
    if(self.button) then
        display.remove(self.button)
    end
    self.button = Button:icon({
        parent = self.display,
        type   = 'selected',
        x      = self.width*0.45,
        y      = -self.height*0.45
    })

    utils.bounce(self.button)
end

function Profile:unselect()
    if(self.button) then
        display.remove(self.button)
    end
    self.button = Button:icon({
        parent = self.display,
        type   = 'empty',
        x      = self.width*0.45,
        y      = -self.height*0.45,
        action = function()
            if(self.onSelect) then
                self.onSelect()
            end
        end
    })

    utils.bounce(self.button)
end

--------------------------------------------------------------------------------

function Profile:draw(options)
    self = Profile:new ( options )
    self:prepare ( options )
    self:panel   ( options )
    -- self:banner  ( options )

    -- ---------------------------------

    local barWidth  = self.display.width*0.58
    local barHeight = self.display.width*0.1

    self:status(_.defaults({
        x      = 30,
        y      = -self.height*0.27,
        width  = barWidth,
        height = barHeight,
        parent = self.display,
        step   = User:totalPercentage(options.profile)
    }, options))


    -- ---------------------------------

    self:avatar(_.defaults({
        parent = self.display,
        x      = -self.width*0.45,
        y      = -self.height*0.45
    }, options))

    ---------------------------------

    self:unselect()

    utils.easeDisplay(self.display)
    return self
end

--------------------------------------------------------------------------------

function Profile:mini(options)
    self:prepare ( options )
    -- ---------------------------------

    self:status(_.defaults({
        x      = 0,
        y      = 0,
        width  = options.width,
        height = 50,
        parent = self.display,
        step   = User:totalPercentage(User.profile)
    }, options))

    -- ---------------------------------

    self:avatar(_.defaults({
        parent = self.display,
        x      = -self.width*0.65,
        y      = 0
    }, options))

    ---------------------------------

    return self.display
end

--------------------------------------------------------------------------------

function Profile:prepare(options)
    self.display   = display.newGroup()
    self.display.x = options.x
    self.display.y = options.y

    if(options.parent) then
        options.parent:insert(self.display)
    end

    self.width  = options.width  or display.contentWidth*0.4
    self.height = options.height or display.contentHeight*0.45
end

function Profile:panel(options)
    Panel:small({
        parent = self.display,
        width  = self.width,
        height = self.height,
        x      = 0,
        y      = 0
    })
end

function Profile:banner(options)
    Banner:simple({
        parent   = self.display,
        text     = User.profile.name,
        fontSize = 43,
        width    = display.contentWidth*0.18,
        height   = display.contentHeight*0.08,
        x        = 0,
        y        = -self.height/2,
    })
end

--------------------------------------------------------------------------------

function Profile:avatar(options)
    return GUI:bigIcon(_.extend({
        image = 'assets/images/gui/avatars/' .. options.profile.avatar,
    }, options))
end

--------------------------------------------------------------------------------

function Profile:status(options)
    local path = 'assets/images/game/item/gem.png'

    local progress = ProgressBar:new()
    progress:draw(_.extend({
        path = path
    }, options))

    progress:set(0)
    progress:reach(options.step)
end

--------------------------------------------------------------------------------

return Profile
