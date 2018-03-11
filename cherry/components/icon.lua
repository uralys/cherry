--------------------------------------------------------------------------------

local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local Icon = {}

--------------------------------------------------------------------------------

function Icon:draw(options)
    local icon = display.newImage(
        options.parent,
        options.path
    )

    if(options.disabled) then
        icon.fill.effect = 'filter.desaturate'
        icon.fill.effect.intensity = 0.8
    end

    icon.x = options.x
    icon.y = options.y

    if(options.maxSize) then
        local heigthRatio = options.maxSize / icon.height
        local widthRatio  = options.maxSize / icon.width
        local ratio = math.min(widthRatio, heigthRatio)
        icon:scale(ratio, ratio)
    end

    return icon
end

--------------------------------------------------------------------------------

function Icon:big(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    display.newImage(
        icon,
        'cherry/assets/images/gui/items/circle.container.on.png',
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

function Icon:mini(options)
    local path = options.path or 'cherry/assets/images/gui/items/' .. options.type .. '.icon.png'

    local icon = display.newImage(
        options.parent,
        path
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

function Icon:text(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    display.newImage(
        icon,
        'cherry/assets/images/gui/items/circle.container.on.png',
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

return Icon
