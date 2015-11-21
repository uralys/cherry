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

return Icon
