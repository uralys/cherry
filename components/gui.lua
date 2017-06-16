--------------------------------------------------------------------------------

local _         = require 'underscore'
local animation = require 'animation'
local Text      = require 'text'
local Banner    = require 'components.banner'

--------------------------------------------------------------------------------

local GUI = {}


--------------------------------------------------------------------------------

function GUI:gameTitle(view)
    local banner = Banner:large({
        parent   = view,
        text     = 'Phantoms',
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

    display.newImage(
        icon,
        'cherry/_images/gui/items/circle.container.on.png',
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

function GUI:miniIcon(options)
    local icon = display.newImage(
        options.parent,
        'cherry/_images/gui/items/' .. options.type .. '.icon.png'
    );

    if(options.disabled or options.status == 'off') then
        icon.fill.effect = 'filter.desaturate'
        icon.fill.effect.intensity = 1
    end

    icon.x = options.x
    icon.y = options.y

    local scale = options.scale or 0.26
    icon:scale(scale, scale)
    return icon
end

--------------------------------------------------------------------------------

function GUI:iconText(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    display.newImage(
        icon,
        'cherry/_images/gui/items/circle.container.on.png',
        0, 0
    )

    Text.embossed({
        parent   = icon,
        text     = options.value,
        x        = 0,
        y        = 0,
        font     = options.font or _G.FONT,
        fontSize = options.fontSize or 65
    })

    return icon
end

--------------------------------------------------------------------------------

function GUI:banner(options)
    local banner = Banner:large({
        parent   = options.parent,
        text     = options.text,
        fontSize = options.fontSize or 55,
        width    = options.width    or display.contentWidth*0.27,
        height   = options.height   or display.contentHeight*0.17,
        x        = options.x        or display.contentWidth*0.5,
        y        = options.y        or display.contentHeight*0.2
    })

    return banner
end

--------------------------------------------------------------------------------

function GUI:multiplier(options)
    local icon = self:bigIcon(_.extend({
        image  = 'cherry/_images/gui/items/' .. options.item .. '.icon.png',
        parent = options.parent,
        x      = options.x,
        y      = options.y,
        scale  = options.scale or 1
    }, options))

    local multiply = display.newImage(
        options.parent,
        'cherry/_images/gui/items/multiply.png',
        options.x + icon.width * 0.55,
        options.y
    )

    animation.bounce(multiply)

    local num = Text.embossed({
        parent   = options.parent,
        text     = options.value,
        x        = options.x + icon.width * 1.1,
        y        = options.y,
        font     = options.font or _G.FONT,
        fontSize = options.fontSize or 75
    })

    animation.bounce(num)
end

--------------------------------------------------------------------------------

return GUI
