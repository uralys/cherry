local Text = require('cherry.components.text')

describe('[Text]', function()
  it('> create with no params', function()
    Text:create({})
  end)

  it('> create with params', function()
    local foo = display.newGroup()
    local action = spy.new(function() end)

    local text = Text:create({
      parent = foo,
      value = 'plop',
      x = 12,
      y = 32,
      grow = true,
      animation = {
        y = 52
      },
      onTap = action
    })

    assert.are.equal(12, text.display.x)
    assert.are.equal(52, text.display.y)
    assert.are.equal('plop', text.currentValue.text)

    text.display:tap()
    assert.spy(action).was.called(1)
  end)

  it('> update text value', function()
    local foo = display.newGroup()

    local text = Text:create({
      parent = foo,
      value = 'plop',
      animation = {
        y = 0
      }
    })

    assert.are.equal(text.currentValue.text, 'plop')
    text:setValue('plup')
    assert.are.equal(text.currentValue.text, 'plup')

    assert.are.equal(text:width(), 0)
    text:destroy()
  end)
end)
