--------------------------------------------------------------------------------

local Button = {}

--------------------------------------------------------------------------------

function Button:round(options)

    local button = display.newGroup()
    button.x = options.x
    button.y = options.y
    options.parent:insert(button)

    button.image = display.newImage(
        button,
        'assets/images/gui/buttons/round.'.. options.type .. '.png',
        0, 0
    );

    button.text = display.newText(
        button,
        options.label,
        0, 0,
        FONT,
        60
    );

    button.text.anchorX = 0.63
    button.text.anchorY = 0.61

    utils.onTap(button, function()
        options.action()
        Sound:playButton()
    end)

    return button
end

function Button:icon(options)

    local button = display.newImage(
        options.parent,
        'assets/images/gui/buttons/'.. options.type ..'.png'
    );

    button.x = options.x
    button.y = options.y

    if(options.action) then
        utils.onTap(button, function()
            options.action()
            Sound:playButton()
        end)
    end

    if(options.scale) then
        button:scale(options.scale, options.scale)
    end

    if(options.bounce) then
        if(options.scale) then
            utils.bounce(button, options.scale)
        else
            utils.bounce(button)
        end
    end

    return button
end

--------------------------------------------------------------------------------

return Button
