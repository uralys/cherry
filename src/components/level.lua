--------------------------------------------------------------------------------

local _         = require 'underscore'
local animation = require 'animation'
local gesture   = require 'gesture'
local Panel     = require 'components.panel'
local GUI       = require 'components.gui'

--------------------------------------------------------------------------------

local Level = {}

--------------------------------------------------------------------------------

function Level:new(options)
    local level = _.extend({
        gems = {},
        activatedGems = options.gems,
        activatedStars = options.stars
    }, options);

    setmetatable(level, { __index = Level })
    return level;
end

--------------------------------------------------------------------------------

---
-- options extending self
-- x
-- y
-- level
-- status
-- frog
-- maxGems
-- gems
-- maxStars
-- stars
-- moves
function Level:build(options)
    local level = Level:new ( options )
    level:buildPanel(options)
    level:buildLock()
    level:buildGems()
    level:buildStars()
    level:buildMoves()
    level:buildNum()
    return level
end

function Level:show()
    animation.bounce(self.bg)
    animation.bounce(self.text)
    self:bounceGems()
    self:bounceStars()

    if(self.lock) then animation.bounce(self.lock) end
    if(self.moves) then animation.bounce(self.moves, 0.5) end
end

function Level:destroy()
    display.remove(self.bg)
    display.remove(self.lock)
    display.remove(self.moves)
    display.remove(self.text)

    for i = 1, #self.gems do
        display.remove(self.gems[i])
    end

    for i = 1, #self.stars do
        display.remove(self.stars[i])
    end
end

--------------------------------------------------------------------------------

function Level:buildPanel(options)
    self.bg = Panel:level({
        parent = self.parent,
        x      = self.x,
        y      = self.y,
        status = self.status
    })

    if(self.status == 'on') then
        gesture.onTouch(self.bg, self.action)
    end
end

--------------------------------------------------------------------------------

function Level:buildLock()
    if(self.status == 'on') then return end

    self.lock = display.newImage(
        self.parent,
        'Cherry/assets/images/gui/items/lock.png'
    );

    self.lock.x = self.x + self.bg.width * 0.32
    self.lock.y = self.y - self.bg.height * 0.32
end

--------------------------------------------------------------------------------

function Level:buildMoves()
    local levelDone = self.moves > 0
    local allGemsCaught = self.activatedGems == self.maxGems
    local displayMoves = levelDone and allGemsCaught

    if(not displayMoves) then
        self.moves = nil
        return
    end

    self.moves = GUI:iconText({
        parent = self.parent,
        value  = self.moves,
        x      = self.x + self.bg.width * 0.32,
        y      = self.y - self.bg.height * 0.36
    })
end

--------------------------------------------------------------------------------

function Level:buildGems()
    local MINI_STAR_WIDTH = 40
    local width = self.maxGems * 40
    local y = self.y + self.bg.height * 0.25
    self.gems = {}

    for i = 1, self.maxGems do
        local x = self.x - width/2 + MINI_STAR_WIDTH * (i - 0.5)
        local status = 'off'
        if(self.activatedGems >= i) then status = 'on' end

        local gem = GUI:miniIcon({
            type     = 'gem',
            parent   = self.parent,
            x        = x,
            y        = y,
            status   = status,
            disabled = self.status == 'off'
        })

        self.gems[i] = gem
    end
end

function Level:bounceGems()
    for i = 1, #self.gems do
        animation.bounce(self.gems[i], 0.26)
    end
end

--------------------------------------------------------------------------------

function Level:buildStars()
    local y = self.y + self.bg.height * 0.5
    local x = self.x - self.bg.width * 0.47
    self.stars = {}

    for i = 1, self.maxStars do
        local status = 'off'
        if(self.activatedStars >= i) then status = 'on' end

        local star = GUI:miniIcon({
            type     = 'star',
            parent   = self.parent,
            x        = x,
            y        = y - i * self.bg.height * 0.15,
            status   = status,
            disabled = self.status == 'off'
        })

        self.stars[i] = star
    end

    if(self.stars == 7) then
        local star = display.newImage(
            self.parent,
            'Cherry/assets/images/gui/items/star-special.icon.png'
        );

        star.x = self.x + self.bg.width * 0.32
        star.y = self.y - self.bg.height * 0.36
        self.stars[7] = star
    end
end

function Level:bounceStars()
    for i = 1, #self.stars do
        local scale = 0.26
        if(i == 7) then scale = 0.8 end
        animation.bounce(self.stars[i], scale)
    end
end

--------------------------------------------------------------------------------

function Level:buildNum()
    self.text = display.newEmbossedText(
        self.parent,
        self.level,
        self.bg.x,
        self.bg.y - 10,
        _G.FONT,
        60
    );

    local color =
    {
        highlight = { r=0.2, g=0.2, b=0.2 },
        shadow = { r=0.2, g=0.2, b=0.2 }
    }

    self.text:setEmbossColor( color )
end

--------------------------------------------------------------------------------

return Level
