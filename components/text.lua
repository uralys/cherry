--------------------------------------------------------------------------------

local Text = {}

--------------------------------------------------------------------------------

function Text:create(options)
    local text = _.extend({}, options);
    setmetatable(text, { __index = Text })
    text:render()
    return text
end

--------------------------------------------------------------------------------

function Text:render()
    if (self.view) then
        display.remove(self.view)
    end

    self.view = utils.text({
        parent   = self.parent,
        value    = self.value,
        font     = self.font or FONT,
        fontSize = self.fontSize or 55,
        x        = self.x,
        y        = self.y
    })

    if (self.grow) then
        utils.grow(self.view)
    end

    self.view.anchorX = 0
end

--------------------------------------------------------------------------------

function Text:setValue(value)
    self.value = value
    self:render()
end

--------------------------------------------------------------------------------

return Text
