--------------------------------------------------------------------------------

local Item = {}

--------------------------------------------------------------------------------

function Item:new(options)
    local item = _.extend({
        rotation = 0
    }, options);

    setmetatable(item, { __index = Item })
    return item;
end

--------------------------------------------------------------------------------

function Item:show()
    self.display = display.newImage(
        'assets/images/game/avatars/profile.' .. self.type .. '.png'
    )

    Camera:insert(self.display)

    self.display.x = self.x
    self.display.y = self.y
    self.display.rotation = self.rotation

    if(self.focus) then
        self.focus = utils.focus(self.display, self.focus)
    end

    utils.onTap(self.display, function()
        App.game:stop()
        Sound:playExit()
    end)
end

--------------------------------------------------------------------------------

return Item
