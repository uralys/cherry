--------------------------------------------------------------------------------

local Level = {}

--------------------------------------------------------------------------------

function Level:new(options)
    local level = _.extend({
        gems = {}
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
    self = Level:new ( options )
    self.options = options
    self:buildPanel()
    self:buildLock()
    self:buildGems()
    self:buildStars()
    self:buildMoves()
    self:buildNum()
    return self
end

function Level:show()
    utils.bounce(self.bg)
    utils.bounce(self.text)
    self:bounceGems()
    self:bounceStars()

    if(self.lock) then utils.bounce(self.lock) end
    if(self.moves) then utils.bounce(self.moves, 0.5) end
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

function Level:buildPanel()
    self.bg = Panel:level({
        parent = self.options.parent,
        x      = self.options.x,
        y      = self.options.y,
        status = self.options.status
    })

    if(self.options.status == 'on') then
        utils.onTouch(self.bg, self.options.action)
    end
end

--------------------------------------------------------------------------------

function Level:buildLock()
    if(self.options.status == 'on') then return end

    self.lock = display.newImage(
        self.options.parent,
        'assets/images/gui/items/lock.png'
    );

    self.lock.x = self.options.x + self.bg.width * 0.32
    self.lock.y = self.options.y - self.bg.height * 0.32
end

--------------------------------------------------------------------------------

function Level:buildMoves()
    local levelDone = self.options.moves > 0
    local allGemsCaught = self.options.gems == self.options.maxGems
    local displayMoves = levelDone and allGemsCaught

    if(not displayMoves) then
        self.moves = nil
        return
    end

    self.moves = GUI:iconText(_.extend({
        parent = self.options.parent,
        value  = self.options.moves,
        x      = self.options.x + self.bg.width * 0.32,
        y      = self.options.y - self.bg.height * 0.36
    }, options))
end

--------------------------------------------------------------------------------

function Level:buildGems()
    local MINI_STAR_WIDTH = 40
    local width = self.options.maxGems * 40
    local y = self.options.y + self.bg.height * 0.25
    self.gems = {}

    for i = 1, self.options.maxGems do
        local x = self.options.x - width/2 + MINI_STAR_WIDTH * (i - 0.5)
        local status = 'off'
        if(self.options.gems >= i) then status = 'on' end

        local gem = GUI:miniIcon({
            type     = 'gem',
            parent   = self.options.parent,
            x        = x,
            y        = y,
            status   = status,
            disabled = self.options.status == 'off'
        })

        self.gems[i] = gem
    end
end

function Level:bounceGems()
    for i = 1, #self.gems do
        utils.bounce(self.gems[i], 0.26)
    end
end

--------------------------------------------------------------------------------

function Level:buildStars()
    local y = self.options.y + self.bg.height * 0.5
    local x = self.options.x - self.bg.width * 0.47
    self.stars = {}

    for i = 1, self.options.maxStars do
        local status = 'off'
        if(self.options.stars >= i) then status = 'on' end

        local star = GUI:miniIcon({
            type     = 'star',
            parent   = self.options.parent,
            x        = x,
            y        = y - i * self.bg.height * 0.15,
            status   = status,
            disabled = self.options.status == 'off'
        })

        self.stars[i] = star
    end

    if(self.options.stars == 7) then
        local star = display.newImage(
            self.options.parent,
            'assets/images/gui/items/star-special.icon.png'
        );

        star.x = self.options.x + self.bg.width * 0.32
        star.y = self.options.y - self.bg.height * 0.36
        self.stars[7] = star
    end
end

function Level:bounceStars()
    for i = 1, #self.stars do
        local scale = 0.26
        if(i == 7) then scale = 0.8 end
        utils.bounce(self.stars[i], scale)
    end
end

--------------------------------------------------------------------------------

function Level:buildNum()
    self.text = display.newEmbossedText(
        self.options.parent,
        self.options.level,
        self.bg.x,
        self.bg.y - 10,
        FONT,
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
