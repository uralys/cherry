--------------------------------------------------------------------------------

Game = {
    RUNNING = 1,
    STOPPED = 2
}

--------------------------------------------------------------------------------

function Game:new()
    local game = {
        state  = Game.STOPPED,
        -- you may add any content to deal with your Game status
        -- stuff = {}
        -- other = 'plop'
    }

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self:reset()

    if(self:loadLevel()) then
        Camera:resetZoom()
        Camera:center()
        Camera:start()

        Score:createBar()
        Background:darken()

        self.state = Game.RUNNING
    else
        Router:open(Router.CHAPTERS)
    end
end

------------------------------------------

function Game:reset()
    Camera:empty()
    HUD:reset()
    LevelDrawer:reset()
    self:resetContent()

    Tutorial:reset()
    Score:reset()
end

function Game:resetContent()
    -- here you can reset your content
    -- utils.emptyTable(self.stuff)
end

------------------------------------------

function Game:stop(userExit)

    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------
    -- calculate score

    if(not userExit) then
        Score:calculate (self.chapter, self.level)
    end

    ------------------------------------------

    Tutorial:reset()
    HUD:reset()
    Screen:showBands()
    Background:lighten()
    Score:display()

    ------------------------------------------

    Effects:stop(true)
    Camera:stop()
    User:resetLevelSelection()
end

--------------------------------------------------------------------------------

function Game:loadLevel()
    if(User:isNew()) then
        self.chapter = 0
        self.level   = 1
        User:setChapter(0)
        User:setLevel(1)
    else
        self.chapter, self.level = User:currentGame()
    end

    local path
    if(App.EDITOR_TESTING) then
        path  = 'assets/levels/level-editor/level-editor.json'
        if(not App.EDITOR_PLAY) then
            for i = 2, 10 do
                self:loadNextStep(i)
            end
        end
    else
        if(App.LEVEL_TESTING) then
            self.chapter = App.TESTING_CHAPTER
            self.level   = App.TESTING_LEVEL
            if(App.TESTING_STEPS) then
                for i = 2, App.TESTING_STEPS do
                    self:loadNextStep(i)
                end
            end
        end
        path = 'assets/levels/chapter'.. self.chapter
                   ..'/level'.. self.level
                   ..'.json'
    end

    ---------------------------
    -- analytics
    if(self.chapter > 0) then
        analyticsLoadLevel(self.chapter, self.level)
    end
    ----------

    print('loading level', self.chapter, self.level)
    return self:loadContent(path)
end


function Game:loadNextStep(step)
    local from
    if(App.EDITOR_TESTING) then
        from = 'level-editor/level-editor'
    else
        from = 'chapter' .. self.chapter ..'/level'.. self.level
    end

    local path = 'assets/levels/'
                    .. from
                    ..'-step-' .. step
                    ..'.json'

    ----------
    -- analytics
    if(self.chapter == 0) then
        analytics.event('tutorial', 'step', step)
    else
        local value = self.chapter .. ':' .. self.level .. ':' .. step
        analytics.event('game', 'load-step', value)
    end
    ----------

    print('loading level-step', path)
    return self:loadContent(path, step)
end

function Game:loadContent(path, step)
    print(path, step)
    local level = utils.loadFile(path)
    utils.tprint(level)

    LevelDrawer:build(level)
    self:render()

    Tutorial:showPanel(level.panel, step)

    if(not step) then
        self.title = level.title or 'Level ' .. self.chapter ..'.'.. self.level
        self.properties = level.properties
        self:displayTitle()
    end

    return true
end

--------------------------------------------------------------------------------

function Game:displayTitle()
    local introText = display.newText(
        App.hud,
        self.title,
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

--------------------------------------------------------------------------------

-- you may perform extra loading/setup after the level is rendered using
-- the next function
function Game:render(next)
    self:renderLevel(function()
        Effects:restart()
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function Game:renderLevel(next)
    -- READ what you've created in LevelDrawer
    for i, item in pairs(LevelDrawer.content) do
        print('showing item ' .. item.type)
        item:show()
    end
    next()
end

--------------------------------------------------------------------------------
--  API
--------------------------------------------------------------------------------
-- you may manipulate your game overall status
-- and modify every concerned models here

-- function Game:toggleStuff()
--     for model in self.stuff:findModels() do
--         model:anyThing()
--     end
-- end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function analyticsLoadLevel(chapter, level)
    local user = User.profile.analytics

    if(not user[chapter]) then
        user[chapter] = {}
    end

    if(not user[chapter][level]) then
        user[chapter][level] = { tries = 0 }
    end

    local tries = user[chapter][level].tries
    user[chapter][level].tries = tries + 1

    if(chapter == 0) then
        analytics.event('tutorial', 'step', '1')
    else
        local value = chapter .. ':' .. level .. ':' .. tries
        analytics.event('game', 'load-level', value)
    end
end

return Game
