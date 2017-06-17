--------------------------------------------------------------------------------

local Panel = {}

--------------------------------------------------------------------------------

function Panel:vertical(options)
    local image = options.image or 'Cherry/assets/images/gui/panels/panel.vertical.png'
    local panel = display.newImageRect(
        options.parent,
        image,
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:small(options)
    local image = options.image or 'Cherry/assets/images/gui/panels/panel.horizontal.png'
    local panel = display.newImageRect(
        options.parent,
        image,
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:level(options)
    local panel = display.newImage(
        options.parent,
        'Cherry/assets/images/gui/panels/level.panel.' .. options.status .. '.png'
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

function Panel:chapter(options)
    local panel = display.newImageRect(
        options.parent,
        'Cherry/assets/images/gui/panels/chapter.panel.' .. options.status .. '.png',
        options.width,
        options.height
    );

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x
    panel.y       = options.y

    return panel
end

--------------------------------------------------------------------------------

return Panel
