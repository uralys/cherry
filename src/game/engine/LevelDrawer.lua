--------------------------------------------------------------------------------

LevelDrawer = {
    content = {}
}

--------------------------------------------------------------------------------

function LevelDrawer:reset()
    self.content = {}
end

--------------------------------------------------------------------------------

function LevelDrawer:build(level)
    for i, item in pairs(level.items) do
        self.content[#self.content + 1] = Item:new(item)
    end
end

------------------------------------------

return LevelDrawer
