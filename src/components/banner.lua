--------------------------------------------------------------------------------

local Text = require 'text'
local Banner = {}

--------------------------------------------------------------------------------

function Banner:large(options)
    options = options or {}
    options.width = options.width or 400

    local banner = display.newGroup()
    options.parent:insert(banner)

    display.newImageRect(
        banner,
        'Cherry/assets/images/gui/banners/banner.png',
        options.width,
        options.height
    );

    banner.anchorX = options.anchorX or 0.5
    banner.anchorY = options.anchorY or 0.5
    banner.x       = options.x
    banner.y       = options.y

    local curveSize = options.width/0.55

    banner.text = Text.curve({
        parent     = banner,
        text       = options.text or '',
        curveSize  = curveSize,
        x          = 0,
        y          = curveSize*0.965,
        font       = _G.FONT,
        fontSize   = options.fontSize or 10
    })

    return banner
end

--------------------------------------------------------------------------------

function Banner:simple(options)
    options = options or {}
    options.width = options.width or 400

    local banner = display.newGroup()
    options.parent:insert(banner)

    display.newImageRect(
        banner,
        'Cherry/assets/images/gui/banners/banner.simple.png',
        options.width,
        options.height
    );

    banner.anchorX = options.anchorX or 0.5
    banner.anchorY = options.anchorY or 0.5
    banner.x       = options.x
    banner.y       = options.y

    local curveSize = options.width/0.55

    banner.text = Text.curve({
        parent     = banner,
        text       = options.text or '',
        curveSize  = curveSize,
        x          = 0,
        y          = curveSize*0.985,
        font       = _G.FONT,
        fontSize   = options.fontSize or 10
    })

    return banner
end

--------------------------------------------------------------------------------

return Banner
