--------------------------------------------------------------------------------

local Chapters = {}

--------------------------------------------------------------------------------

function Chapters:draw(options)
    self:reset()
    self:setup          (options)
    self:prepareBoard   (options)
    self:fillContent    (options)
    self:displayBanner  (options)

    self:onShow()
    return self
end

function Chapters:onShow()
    utils.easeDisplay(self.banner)
end

function Chapters:reset()
    if(self.scroller) then
        display.remove(self.banner)
        self.scroller:destroy()
    end
end

--------------------------------------------------------------------------------

function Chapters:setup(options)
    self.parent = options.parent
    self.x      = display.contentWidth*0.5
    self.y      = display.contentHeight*0.5
    self.width  = display.contentWidth*0.8
    self.height = display.contentHeight*0.9
    self.top    = self.y - display.contentHeight*0.42
end

function Chapters:prepareBoard(options)
    self.scroller = Scroller:new({
        parent                   = self.parent,
        top                      = self.top + 7,
        left                     = self.x - self.width * 0.45,
        width                    = self.width * 0.9,
        height                   = self.height - 22,
        gap                      = display.contentHeight*0.05,
        handleHeight             = display.contentHeight*0.07,
        horizontalScrollDisabled = true,
        hideBackground           = true
    })

    self.scroller.onBottomReached = function()
        analytics.event('game', 'chapter-scroll-end')
    end
end

function Chapters:displayBanner(options)
    self.banner = Banner:large({
        parent   = self.parent,
        text     = 'Chapters',
        fontSize = 57,
        width    = display.contentWidth*0.25,
        height   = display.contentHeight*0.13,
        x        = self.x,
        y        = self.top
    })
end

--------------------------------------------------------------------------------

function Chapters:fillContent(options)
    for i = 1,3 do
        local chapter = self:summary(
            User:chapterData(i)
        )
        self.scroller:insert (chapter)
    end

    self.scroller:insert( self:hellBarEntrance(options) )
end

function Chapters:hellBarEntrance(options)
    local hellbar = display.newGroup()

    local panel = Panel:chapter({
        parent = hellbar,
        width  = self.width * 0.83,
        height = display.contentHeight*0.35,
        status = 'off'
    })

    local hell = display.newImage(
        hellbar,
        'assets/images/gui/avatars/profile.3.png',
        panel.width*0.2, 0
    )

    local contentX = -panel.width * 0.2

    utils.text({
        parent = hellbar,
        value  = 'Reach 10k likes on FB to open this secret door...',
        x      = contentX,
        y      = - App:adaptToRatio(15),
        width  = panel.width * 0.4,
        height = panel.height * 0.45,
        font   = FONT,
        fontSize = App:adaptToRatio(10),
    })

    Profile:status({
        parent   = hellbar,
        x        = contentX,
        y        = 0,
        width    = panel.width * 0.36,
        height   = panel.height * 0.15,
        item     = 'fb',
        step     = 59
    })

    local fb = Button:icon({
        parent = hellbar,
        type   = 'facebook',
        x      = contentX,
        y      = panel.height * 0.35,
        action = function ()
            Screen:openFacebook()
        end
    })

    self:lockChapter({
        parent = hellbar,
        x      = - panel.width * 0.47,
        y      = - panel.height * 0.47
    })

    return hellbar
end

--------------------------------------------------------------------------------

function Chapters:summary(options)
    local summary = display.newGroup()

    local panel = Panel:chapter({
        parent = summary,
        width  = self.width * 0.83,
        height = display.contentHeight*0.4,
        status = options.status
    })

    ---------------------------------------------------------------
    -- custom

    local avatar = display.newImage(
        summary,
        'assets/images/gui/avatars/profile.' .. options.chapter .. '.png',
        - panel.width * 0.31, 0
    )

    if(options.status == 'off') then
        avatar.fill.effect = 'filter.desaturate'
        avatar.fill.effect.intensity = 0.8
    end

    ---------------------------------------------------------------

    if(options.condition) then
        local textY    = panel.y - panel.height * 0.2
        local contentX = panel.x + panel.width*0.22

        utils.text({
            parent   = summary,
            value    = options.condition.text,
            x        = contentX,
            y        = textY,
            width    = panel.width * 0.5,
            height   = panel.height * 0.38,
            font     = FONT,
            fontSize = App:adaptToRatio(12)
        })

        local fb = Button:icon({
            parent = summary,
            type   = 'facebook',
            x      = contentX,
            y      = panel.height * 0.35,
            action = function ()
                Screen:openFacebook()
            end
        })

    else
        if(options.status == 'on') then
            GUI:multiplier({
                item   = 'gem',
                parent = summary,
                x      = panel.width * 0.05,
                y      = 0,
                scale  = 0.85,
                value  = 2
            })

            local play = Button:icon({
                parent = summary,
                type   = 'play',
                x      = panel.width * 0.35,
                y      = 0,
                action = function ()
                    analytics.event('game', 'chapter-selection', options.chapter)
                    User:setChapter(options.chapter)
                    Router:open(Router.LEVEL_SELECTION)
                end
            })

            utils.easeDisplay(play, 1.2)

        else
            Profile:status({
                parent   = summary,
                x        = panel.width * 0.15,
                y        = panel.height * 0.13,
                width    = panel.width * 0.4,
                height   = panel.height * 0.15,
                item     = 'gem',
                step     = options.percentGems,
                disabled = (options.status == 'off')
            })

            self:lock(_.defaults({
                parent = summary,
                x = panel.width * 0.42,
                y = 0
            }, options))
        end
    end

    if(options.status == 'off') then
        self:lockChapter({
            parent = summary,
            x      = - panel.width * 0.47,
            y      = - panel.height * 0.47
        })
    end

    return summary
end

--------------------------------------------------------------------------------

function Chapters:lockChapter(options)
    local bg = display.newImage(
        options.parent,
        'assets/images/gui/items/circle.container.off.png',
        options.x,
        options.y
    )

    bg:scale(0.7, 0.7)

    self:lock(_.defaults({
        parent = summary,
        x = bg.x,
        y = bg.y
    }, options))
end

--------------------------------------------------------------------------------

function Chapters:lock(options)
    if(options.status == 'on') then return end

    local lock = display.newImage(
        options.parent,
        'assets/images/gui/items/lock.png'
    );

    lock.x = options.x
    lock.y = options.y
    return lock
end

--------------------------------------------------------------------------------

return Chapters
