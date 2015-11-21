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
        local previousScore = User:previousScore(self.chapter, self.level)
        local newScore      = Score:enhance(previousScore)

        User:recordLevel(
            self.chapter,
            self.level,
            newScore
        )
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

    print('loading level', self.chapter, self.level)
    return self:loadContent(path)
end

function Game:loadNextStep(step)
    local path = 'assets/levels/chapter'.. self.chapter
               ..'/level'.. self.level
               ..'-step-' .. step
               ..'.json'


    print('loading level-step', self.chapter, self.level, step)
    self.loadedSteps[step] = true
    return self:loadContent(path, step)
end

function Game:loadContent(path, step)
    local resource = system.pathForFile( path, system.ResourcesDirectory )
    if(not resource) then
        return false
    end

    local file     = io.open(resource, 'r')
    local contents = file:read( '*a' )
    local level    = json.decode(contents)

    LevelDrawer:build(level)
    self:render()

    Tutorial:showPanel(level.panel, step)
    self:displayTitle(level.title)
    return true
end

--------------------------------------------------------------------------------

function Game:displayTitle(text)
    if(not text) then
        return
    end

    local introText = display.newText(
        App.hud,
        text,
        0, 0,
        FONT, 45
    )

    introText:setFillColor( 255 )
    introText.anchorX = 0
    introText.x       = display.contentWidth * 0.05
    introText.y       = display.contentHeight * 0.18
    introText.alpha   = 0

    transition.to( introText, {
        time       = 2600,
        alpha      = 1,
        x          = display.contentWidth * 0.06,
        onComplete = function()
            transition.to( introText, {
                time  = 3200,
                alpha = 0,
                x     = display.contentWidth * 0.08
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

------------------------------------------

return Game
