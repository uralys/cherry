--------------------------------------------------------------------------------
--
-- Headphones.lua
--
--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    local nextView = event.params.nextView

    local phantom = display.newImage(
        self.view,
        'Cherry/_images/gui/avatars/headphones.png',
        display.contentWidth * 0.2,
        display.contentHeight * 0.5
    )

    phantom.rotation = -4
    utils.rotateBackAndForth(phantom, 4, 800)

    local text = utils.text({
        parent   = self.view,
        x        = display.contentWidth * 0.4,
        y        = display.contentHeight * 0.5,
        value    = 'You should use headphones for a complete experience',
        font     = FONT,
        fontSize = App:adaptToRatio(15),
        width    = display.contentWidth * 0.4
    })

    text.anchorX = 0

    local delay = timer.performWithDelay(4000, function()
        Router:open(nextView)
    end)

    utils.onTap(phantom, function()
        analytics.event('game', 'phantom-headphone')
        timer.cancel(delay)
        Router:open(nextView)
    end)

    utils.onTap(text, function()
        analytics.event('game', 'text-headphone')
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
