--------------------------------------------------------------------------------

local Button = require 'cherry.components.button'

--------------------------------------------------------------------------------

local scene = _G.composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
end

function scene:show( event )
    if ( event.phase == 'did' ) then
        self.leaderboardButton = Button:icon({
            parent = App.HUD,
            type   = 'tab',
            x      = 100,
            y      = 100,
            action = function()
            end
        })
    end
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
