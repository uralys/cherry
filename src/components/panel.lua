--------------------------------------------------------------------------------

local Panel = {}

--------------------------------------------------------------------------------

function Panel:vertical(options)
    options = options or {}

    local image = options.image or 'Cherry/assets/images/gui/panels/panel.vertical.png'
    local panel = display.newImageRect(
        image,
        options.width or 0,
        options.height or 0
    )

    if(options.parent) then
        options.parent:insert(panel)
    end

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x or 0
    panel.y       = options.y or 0

    return panel
end

function Panel:small(options)
    options = options or {}

    local image = options.image or 'Cherry/assets/images/gui/panels/panel.horizontal.png'
    local panel = display.newImageRect(
        image,
        options.width or 0,
        options.height or 0
    )

    if(options.parent) then
        options.parent:insert(panel)
    end

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x or 0
    panel.y       = options.y or 0

    return panel
end

function Panel:level(options)
    options = options or {}
    options.status = options.status or 'on'

    local panel = display.newImage(
        'Cherry/assets/images/gui/panels/level.panel.' .. options.status .. '.png'
    )

    if(options.parent) then
        options.parent:insert(panel)
    end

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x or 0
    panel.y       = options.y or 0

    return panel
end

function Panel:chapter(options)
    options = options or {}
    options.status = options.status or 'on'

    local panel = display.newImageRect(
        'Cherry/assets/images/gui/panels/chapter.panel.' .. options.status .. '.png',
        options.width or 0,
        options.height or 0
    )

    if(options.parent) then
        options.parent:insert(panel)
    end

    panel.anchorX = options.anchorX or 0.5
    panel.anchorY = options.anchorY or 0.5
    panel.x       = options.x or 0
    panel.y       = options.y or 0

    return panel
end

--------------------------------------------------------------------------------

return Panel
