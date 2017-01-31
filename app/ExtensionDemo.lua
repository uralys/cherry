
local function onReset ()
    print('gameExtension.onReset should be set')
end

local function onStop ()
    print('gameExtension.onReset should be set')
end

local function onStart ()
    local introText = display.newText(
        App.hud,
        'Cherry !',
        0, 0,
        FONT, 45
    )

    introText:setFillColor( 255 )
    introText.anchorX = 0
    introText.x       = display.contentWidth * 0.1
    introText.y       = display.contentHeight * 0.18
    introText.alpha   = 0

    transition.to( introText, {
        time       = 2600,
        alpha      = 1,
        x          = display.contentWidth * 0.13,
        onComplete = function()
            transition.to( introText, {
                time  = 3200,
                alpha = 0,
                x     = display.contentWidth * 0.16
            })
        end
    })
end

return {
    onReset = onReset,
    onStart = onStart,
    onStop = onStop
}
