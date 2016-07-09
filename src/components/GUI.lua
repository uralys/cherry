 --------------------------------------------------------------------------------

local GUI = {}

--------------------------------------------------------------------------------

-- only one shared by every scenes
function GUI:refreshAvatar(options)
    if(self.avatar) then
        display.remove(self.avatar)
    end

    options = options or {}
    options = _.defaults(options, {
        parent = options.parent,
        x      = display.contentWidth * 0.06,
        y      = display.contentHeight * 0.9,
        scale  = 1,
        link   = false
    })

    self.avatar = Profile:avatar({
        parent  = options.parent,
        profile = User.profile,
        x       = options.x,
        y       = options.y
    })

    if(options.link) then
        utils.onTouch(self.avatar, function()
            Sound:playButton()
            analytics.event('user', 'open-profiles', 'avatar:' .. Router.view)
            Router:open(Router.PROFILES)
        end)
    end

    utils.bounce(self.avatar, options.scale)
end

--------------------------------------------------------------------------------

function GUI:iconText(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    local bg = display.newImage(
        icon,
        'assets/images/gui/items/circle.container.on.png',
        0, 0
    )

    local text = utils.text({
        parent   = icon,
        value    = options.value,
        x        = 0,
        y        = 0,
        font     = options.font or FONT,
        fontSize = options.fontSize or 65
    })

    return icon
end

--------------------------------------------------------------------------------

-- only one shared by every scenes
function GUI:refreshMiniProfile(view)
    if(self.mini) then
        display.remove(self.mini)
    end

    self.mini = Profile:mini({
        parent  = view,
        profile = User.profile,
        x       = display.contentWidth*0.16,
        y       = display.contentHeight*0.9,
        width   = display.contentWidth*0.15
    })

    utils.onTouch(self.mini, function()
        Sound:playButton()
        analytics.event('user', 'open-profiles', 'mini-profile:' .. Router.view)
        Router:open(Router.PROFILES)
    end)

    utils.bounce(self.mini)

    return self.mini
end

--------------------------------------------------------------------------------

function GUI:gameTitle(view)
    local banner = Banner:large({
        parent   = view,
        text     = App.NAME,
        fontSize = 55,
        width    = display.contentWidth*0.42,
        height   = display.contentHeight*0.22,
        x        = display.contentWidth*0.5,
        y        = display.contentHeight*0.2
    })

    return banner
end

--------------------------------------------------------------------------------

function GUI:bigIcon(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    local bg = display.newImage(
        icon,
        'assets/images/gui/items/circle.container.on.png',
        0, 0
    )

    local picture = display.newImage(
        icon,
        options.image,
        0, 0
    )

    local scale = options.scale or 0.5
    picture:scale(scale, scale)
    return icon
end


--------------------------------------------------------------------------------

function GUI:multiplier(options)
    local icon = self:bigIcon(_.extend({
        image  = 'assets/images/gui/items/' .. options.item .. '.icon.png',
        parent = options.parent,
        x      = options.x,
        y      = options.y,
        scale  = options.scale or 1
    }, options))

    local multiply = display.newImage(
        options.parent,
        'assets/images/gui/items/multiply.png',
        options.x + icon.width * 0.55,
        options.y
    )

    utils.bounce(multiply)

    local num = utils.text({
        parent   = options.parent,
        value    = options.value,
        x        = options.x + icon.width * 1.1,
        y        = options.y,
        font     = options.font or FONT,
        fontSize = options.fontSize or 75
    })

    utils.bounce(num)
end

--------------------------------------------------------------------------------

return GUI
