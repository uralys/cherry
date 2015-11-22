--------------------------------------------------------------------------------
--
-- well, this file is named Headphones because I use it to display
-- the "You should use Headphones for the bext experience".
-- Let say it's an example of pre-home screen.
--
--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    local nextView = event.params.nextView

    local title= utils.text({
        parent   = self.view,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight * 0.3,
        value    = 'This is Cherry !',
        font     = FONT,
        fontSize = App:adaptToRatio(35),
        width    = display.contentWidth * 0.4
    })

    local text = utils.text({
        parent   = self.view,
        x        = display.contentWidth * 0.5,
        y        = display.contentHeight * 0.6,
        value    = 'You may provide information at startup',
        font     = FONT,
        fontSize = App:adaptToRatio(15),
        width    = display.contentWidth * 0.4
    })

    local delay = timer.performWithDelay(4000, function()
        Router:open(nextView)
    end)

    utils.onTap(text, function()
        analytics.event('game', 'text-headphone')
        timer.cancel(delay)
        Router:open(nextView)
    end)
end

--------------------------------------------------------------------------------

function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene
