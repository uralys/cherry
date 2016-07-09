--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    Background:lighten()
    self:drawActions()

    self.title          = GUI:gameTitle    (self.view)
    self.chaptersButton = self:drawChapters()
    self.playButton     = self:drawPlayButton()
end

function scene:show( event )
    if ( event.phase == 'did' ) then
        utils.bounce(self.title)
        utils.bounce(self.playButton, 1.6)
        utils.bounce(self.toggleActionsButton, .7)
        utils.bounce(self.chaptersButton, .7)

        GUI:refreshMiniProfile(self.view)
    end
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
        time = 500,
        onComplete = function()
            self.actions.open = true
            self.actions.lock = false
        end
    })

    transition.to(self.toggleButton, {
        rotation = -360,
        time = 500
    })
end

function scene:closeActions()
    transition.to(self.actions, {
        x = self.actions.x + 330,
        time = 500,
        onComplete = function()
            self.actions.open = false
            self.actions.lock = false
        end
    })

    transition.to(self.toggleButton, {
        rotation = 0,
        time = 500
    })
end

--------------------------------------------------------------------------------

function scene:drawChapters()
    return Button:icon({
        parent = self.view,
        type   = 'chapters',
        x      = self.actions.x,
        y      = self.actions.y - 100,
        scale  = .7,
        action = function()
            if(User:isNew()) then
                Router:open(Router.PLAYGROUND)
            else
                analytics.event('home-action', 'open-chapter')
                Router:open(Router.CHAPTERS)
            end
        end
    })
end

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

    Button:icon({
        parent = self.actions,
        type   = 'profile',
        x      = 110,
        y      = 01,
        scale  = .7,
        action = function()
            analytics.event('user', 'open-profiles', 'button:home')
            Router:open(Router.PROFILES)
        end
    })

    self:redrawMusicButton()

    Button:icon({
        parent = self.actions,
        type   = 'info',
        x      = 330,
        y      = 0,
        scale  = .7,
        action = function()
            Screen:openCredits()
        end
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
            Router:open(Router.PLAYGROUND)
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
