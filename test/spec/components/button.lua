local Button = require('cherry.components.button')
local foo = display.newGroup()

describe('[Button]', function()
  it('should prevent a button without any options', function()
    local round = Button:round()
    assert.is.falsy(round)

    local icon = Button:icon()
    assert.is.falsy(icon)
  end)

  it('should instanciate a round button', function()
    local action = spy.new(function() end)
    local button = Button:round({
      parent = foo,
      type   = 'play',
      action = action,
      x      = 100,
      y      = 100
    })

    assert.spy(action).was.called(0)
    assert.are.equal(button.x, 100)
    assert.are.equal(button.y, 100)

    button:touch()
    assert.spy(action).was.called(1)
  end)

  it('should instanciate an icon button', function()
    local action = spy.new(function() end)
    local button = Button:icon({
      parent = foo,
      type   = 'settings',
      action = action,
      x      = 100,
      y      = 100
    })

    assert.spy(action).was.called(0)
    assert.are.equal(button.x, 100)
    assert.are.equal(button.y, 100)

    button:tap()
    assert.spy(action).was.called(1)
  end)

  it('should scale and bouncs icon buttons', function()
    local plop = Button:icon({type = 'play'})
    assert.are.equal(plop.xScale, 1)

    local plup = Button:icon({type = 'play', scale = 2})
    assert.are.equal(plup.xScale, 2)

    local plip = Button:icon({type = 'play', bounce = true})
    assert.are.equal(plip.xScale, 1)

    local ploup = Button:icon({
      type = 'play',
      bounce = true,
      scale = 3
    })

    assert.are.equal(ploup.xScale, 3)
  end)
end)
