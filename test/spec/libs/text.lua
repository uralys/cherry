local Text = require 'text'

describe('[text]', function()
  it('> should create Text.embossed', function()
    local parent = display.newGroup()
    local text = Text.embossed({
        parent   = parent,
        text     = 'foo',
        x        = 111,
        y        = 222,
        width    = 333,
        height   = 444,
        fontSize = 20
    })

    assert.are.equal(text.x, 111)
    assert.are.equal(text.y, 222)
  end)
end)
