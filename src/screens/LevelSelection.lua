--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )

    --------------------------------------
    -- bg panel

    self.panel = Panel:small({
        parent = self.view,
        width  = display.contentWidth*0.8,
        height = display.contentHeight*0.75,
        x      = display.contentWidth*0.5,
        y      = display.contentHeight*0.5
    })

    --------------------------------------
    -- close button

    self.closeButton = Button:icon({
        parent = self.view,
        type   = 'close',
        x      = self.panel.x + self.panel.width *0.5 - 35,
        y      = self.panel.y - self.panel.height *0.5 + 35,
        action = function ()
            User:resetLevelSelection()
            Router:open(Router.CHAPTERS)
        end
    })

end

function scene:resetContent( event )
    if(self.levels) then
        display.remove(self.banner)
        display.remove(self.avatar)

        for i = 1, #self.levels do
            self.levels[i]:destroy()
        end
    end
end

function scene:build( event )
    self:resetContent()
    local chapterNum = User:selectedChapter()

    --------------------------------------
    -- title banner

    self.banner = Banner:large({
        parent   = self.view,
        text     = 'Chapter ' .. chapterNum,
        fontSize = 40,
        width    = display.contentWidth*0.35,
        height   = display.contentHeight*0.17,
        x        = display.contentWidth*0.5,
        y        = display.contentHeight*0.15
    })

    ---------------------------------------------------------------
    -- avatar

    self.avatar = display.newImage(
        self.view,
        'assets/images/gui/avatars/profile.' .. chapterNum .. '.png',
         self.panel.x - self.panel.width *0.45 ,
         self.panel.y - self.panel.height *0.47
    )

    self.avatar:scale(0.7, 0.7)

    --------------------------------------

    self.levels = {}
    local lines = 2
    local columns = 4

    local horizontal = display.contentWidth * 0.18
    local vertical   = display.contentHeight * 0.25
    local marginLeft = display.contentWidth * 0.05
    local marginTop  = display.contentHeight * 0.15

    for i = 1,lines do
        for j = 1,columns do
            local num = j + columns*(i-1)

            local status = 'off'
            local frog = false
            if(User:isLevelAvailable(chapterNum, num)) then status = 'on' end

            local level = Level:build({
                parent  = self.view,
                x       = marginLeft + horizontal*j,
                y       = marginTop + vertical*i,
                level   = num,
                status  = status,
                maxGems = 3,
                gems    = random(1,3),
                action  = function()
                    local value = chapterNum .. ':' .. num
                    analytics.event('game', 'level-selection', value)
                    User:setLevel(num)
                    Router:open(Router.PLAYGROUND)
                end
            })

            self.levels[num] = level
        end
    end
end

function scene:showLevels()
    for i = 1, #self.levels do
        self.levels[i]:show()
    end
end

--------------------------------------------------------------------------------

-- real show...would be awsome to refresh the dynamical content part by part
-- and actually use :create
function scene:show(event)
    if ( event.phase == 'did' ) then
        self:build()

        utils.easeDisplay(self.panel)
        utils.easeDisplay(self.banner)
        utils.easeDisplay(self.closeButton)
        utils.easeDisplay(self.avatar, .7)
        self:showLevels()

        GUI:refreshAvatar({
            parent = self.view,
            link = true
        })
    end
end

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
