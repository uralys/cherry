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

  it('> should create Text.simple', function()
    local parent = display.newGroup()
    local text = Text.simple({
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

  it('> should create Text.curve', function()
    local parent = display.newGroup()
    local curveSize = 100

    local text = Text.curve({
        parent     = parent,
        text       = 'foo',
        curveSize  = curveSize,
        x          = 0,
        y          = 0,
        font       = _G.FONT,
        fontSize   = 50
    })

    assert.are.equal(#parent.children, 1)
    assert.are.equal(#text.children, 3)
    assert.are.equal(parent.children[1], text)

    local letter1 = text.children[1].private
    local letter2 = text.children[2].private
    local letter3 = text.children[3].private

    assert.are.equal(math.round( letter1.x, 2 ), -11.97)
    assert.are.equal(math.round( letter2.x, 2 ), -2.40)
    assert.are.equal(math.round( letter3.x, 2 ), 7.19)

    assert.are.equal(letter1.rotation, -6.875)
    assert.are.equal(letter2.rotation, -1.375)
    assert.are.equal(letter3.rotation, 4.125)

    assert.are.same(letter1.highlight, {
      b = 0.2,
      g = 0.2,
      r = 0.2
    })

    assert.are.same(letter1.shadow, {
      b = 0.2,
      g = 0.2,
      r = 0.2
    })
  end)

  it('> should create Text.counter', function()
    local next = spy.new(function() end)
    local writer = {
      currentDisplay = 10
    }

    Text.counter(77777, writer, 0, 0, 0, next)

    assert.are.same(writer, {
      anchorX        = 0,
      anchorY        = 0,
      x              = 0,
      currentDisplay = 77777,
      text           = 77777
    })

    assert.spy(next).was.called(1)
  end)
end)
