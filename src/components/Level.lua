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
-- x
-- y
-- level
-- lock
-- num stars
-- num stars won
function Level:build(options)
    self = Level:new ( options )
    self.options = options
    self:buildPanel()
    self:buildLock()
    self:buildGems()
    self:buildPhantom()
    self:buildNum()
    return self
end

function Level:show()
    utils.bounce(self.bg)
    utils.bounce(self.text)
    self:bounceGems()

    if(self.lock) then utils.bounce(self.lock) end
    if(self.phantom) then utils.bounce(self.phantom, 0.7) end
end

function Level:destroy()
    display.remove(self.bg)
    display.remove(self.lock)
    display.remove(self.text)
    display.remove(self.phantom)

    for i = 1, #self.gems do
        display.remove(self.gems[i])
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

    self.lock.x = self.options.x - self.bg.width * 0.32
    self.lock.y = self.options.y - self.bg.height * 0.32
end

--------------------------------------------------------------------------------

function Level:buildPhantom()
    if(not self.options.frog) then return end

    self.phantom = display.newImage(
        self.options.parent,
        'assets/images/gui/items/mini-phantom.icon.png'
    );

    self.phantom.x = self.options.x + self.bg.width * 0.32
    self.phantom.y = self.options.y - self.bg.height * 0.36
    self.phantom:scale(0.7, 0.7)
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

        local gem = self:miniGem({
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

function Level:bounceGems()
    for i = 1, #self.gems do
        utils.bounce(self.gems[i], 0.26)
    end
end

function Level:miniGem(options)
    local gem = display.newImage(
        options.parent,
        'assets/images/gui/items/gem.icon.png'
    );

    if(options.disabled or options.status == 'off') then
        gem.fill.effect = 'filter.desaturate'
        gem.fill.effect.intensity = 1
    end

    gem.x = options.x
    gem.y = options.y

    local scale = 0.26
    gem:scale(scale, scale)
    return gem
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
