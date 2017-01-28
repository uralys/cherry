
local physics = require( 'physics' )

--------------------------------------------------------------------------------

Game = {
    RUNNING = 1,
    STOPPED = 2
}

--------------------------------------------------------------------------------

function Game:new()
    local game = {
        state  = Game.STOPPED,
        enemies = {}
    }

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self:reset()

    physics.start()
    physics.setGravity( 0,0 )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    Score:createBar()
    Background:darken()

    self:displayTitle()
    self:spawnKodo()
    Effects:restart()

    self.state = Game.RUNNING
    Curves:reset()
    HUD:raiseTo(App.user.level)
    Curves:raiseTo(App.user.level)

    self:spawnEnemy()
end

function Game:reset()
    Camera:empty()
    HUD:reset()
    self:resetContent()

    Score:reset()
end

function Game:resetContent()
    self.title = 'Kodo !'
    utils.emptyTable(self.enemies)
end

------------------------------------------

function Game:stop(userExit)
    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------
    -- destroy all bodies

    self.kodo:destroy()
    while(#self.enemies > 0) do
        local enemy = self.enemies[1]
        enemy:destroy()
    end

    ------------------------------------------
    -- calculate score

    if(not userExit) then
        Score:calculate()
    end

    ------------------------------------------

    HUD:reset()
    Screen:showBands()
    Background:lighten()
    Score:display()

    ------------------------------------------

    Effects:stop(true)
    Camera:stop()
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

function Game:spawnKodo()
    self.kodo = Kodo:new()
    self.kodo:show()
end

--------------------------------------------------------------------------------

function Game:waitForNextEnemy()
    timer.performWithDelay( math.random(1250, 2500), function()
        if(self.state == Game.RUNNING) then
            self:spawnEnemy()
        end
    end)
end

function Game:spawnEnemy()
    local enemy = Enemy:new()
    enemy:spawn(App.user.level)
    self.enemies[#self.enemies + 1] = enemy
    self:waitForNextEnemy()
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

function Game:removeEnemy(enemy)
    utils.removeFromTable(self.enemies, enemy)
end

function Game:hitEnemies(num)
    for i = #self.enemies,1,-1 do
        local enemy = self.enemies[i]
        local isDead = enemy:damages(num, self.kodo.strength)
        if(isDead) then
            Score:increment(enemy.value)
            enemy:explode()
        end
    end

    local nextLevel = GLOBALS.levels[App.user.level+1]
    local pointsRequired = nextLevel and nextLevel.pointsRequired
    local pointsReached = nextLevel and Score.current.points >= pointsRequired

    if(pointsReached) then
        local newLevel = App.user:growLevel()
        HUD:raiseTo(newLevel)
        Curves:raiseTo(newLevel)
    end
end

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
