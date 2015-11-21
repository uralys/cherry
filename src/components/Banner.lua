--------------------------------------------------------------------------------

local Banner = {}

--------------------------------------------------------------------------------

function Banner:large(options)

    local banner = display.newGroup()
    options.parent:insert(banner)

    local image = display.newImageRect(
        banner,
        'assets/images/gui/banners/banner.png',
        options.width,
        options.height
    );

    banner.anchorX = options.anchorX or 0.5
    banner.anchorY = options.anchorY or 0.5
    banner.x       = options.x
    banner.y       = options.y

    local curveSize = options.width/0.55

    banner.text = utils.curveText({
        parent     = banner,
        text       = options.text,
        curveSize  = curveSize,
        x          = 0,
        y          = curveSize*0.965,
        font       = FONT,
        fontSize   = options.fontSize
    })

    return banner
end

--------------------------------------------------------------------------------

function Banner:simple(options)

    local banner = display.newGroup()
    options.parent:insert(banner)

    local image = display.newImageRect(
        banner,
        'assets/images/gui/banners/banner.simple.png',
        options.width,
        options.height
    );

    banner.anchorX = options.anchorX or 0.5
    banner.anchorY = options.anchorY or 0.5
    banner.x       = options.x
    banner.y       = options.y

    local curveSize = options.width/0.55

    banner.text = utils.curveText({
        parent     = banner,
        text       = options.text,
        curveSize  = curveSize,
        x          = 0,
        y          = curveSize*0.985,
        font       = FONT,
        fontSize   = options.fontSize
    })

    return banner
end

--------------------------------------------------------------------------------

return Banner
