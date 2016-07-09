--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    Background:lighten()
    self:drawActions()

    self.title          = GUI:gameTitle    (self.view)
    self.playButton     = self:drawPlayButton()
end

function scene:show( event )
    if ( event.phase == 'did' ) then
        utils.bounce(self.title)
        utils.bounce(self.playButton, 1.6)
        utils.bounce(self.toggleActionsButton, .7)

        GUI:refreshMiniProfile(self.view)
    end
end

--------------------------------------------------------------------------------

function scene:drawActions()
    self.actions      = display.newGroup()
    self.actions.x    = display.contentWidth*0.95
    self.actions.y    = display.contentHeight*0.9
    self.actions.open = false
    self.actions.lock = false
    self.view:insert(self.actions)

    self.toggleActionsButton = Button:icon({
        parent = self.actions,
        type   = 'settings',
        x      = 0,
        y      = 0,
        scale  = .7,
        action = function()
            self:toggleActions()
        end
    })

    self:redrawMusicButton()

    self.infoButton = Button:icon({
        parent = self.actions,
        type   = 'info',
        x      = 110,
        y      = 0,
        scale  = .7,
        action = function()
            Screen:openCredits()
        end
    })
end

--------------------------------------------------------------------------------

function scene:toggleActions()
    if(self.actions.lock) then return end
    self.actions.lock = true

    if(self.actions.open) then
        self:closeActions()
    else
        self:openActions()
    end
end

function scene:openActions()
    transition.to(self.actions, {
        x = self.actions.x - 330,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = true
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton)
    self:rotateButton(self.infoButton)
    self:rotateButton(self.musicButton)
end

function scene:closeActions()
    transition.to(self.actions, {
        x = self.actions.x + 330,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = false
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton, true)
    self:rotateButton(self.infoButton, true)
    self:rotateButton(self.musicButton, true)
end

function scene:rotateButton(button, back)
    local rotation = function() if (back) then return 0 else return -360 end end
    transition.to(button, {
        rotation = rotation(),
        time = 850,
        transition = easing.inOutBack
    })
end

--------------------------------------------------------------------------------

function scene:redrawMusicButton()
    if(self.musicButton) then
        display.remove(self.musicButton)
    end

    local musicType = 'music'
    if(Sound.isOff) then
        musicType = 'music-off'
    end

    self.musicButton = Button:icon({
        parent = self.actions,
        type   = musicType,
        x      = 220,
        y      = 0,
        scale  = .7,
        action = function()
            Sound:toggleAll()
            self:redrawMusicButton()
        end
    })
end

--------------------------------------------------------------------------------

function scene:drawPlayButton()
    return Button:icon({
        parent = self.view,
        type   = 'play',
        x      = display.contentWidth*0.5,
        y      = display.contentHeight*0.5,
        scale  = 1.6,
        bounce = true,
        action = function ()
            analytics.event('game', 'home-play-button')
            if(self.actions.open) then
                self:closeActions()
            end
            Router:open(Router.CHAPTERS)
        end
    })
end

--------------------------------------------------------------------------------

function scene:hide( event )
end

function scene:destroy( event )
    Runtime:removeEventListener( 'enterFrame', self.refreshCamera )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene
