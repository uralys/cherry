local Panel = require('components.panel')

describe('[Panel]', function()
  it('> vertical', function()
    local foo = display.newGroup()
    local panel = Panel:vertical()
    assert.are.equal(panel.x, 0)
    assert.are.equal(panel.y, 0)
    assert.are.equal(#foo.children, 0)

    Panel:vertical({
      parent = foo
    })

    assert.are.equal(#foo.children, 1)
  end)

  it('> small', function()
    local foo = display.newGroup()
    local panel = Panel:small()
    assert.are.equal(#foo.children, 0)

    Panel:small({
      parent = foo
    })

    assert.are.equal(#foo.children, 1)
    assert.are.equal(panel.x, 0)
    assert.are.equal(panel.y, 0)
  end)

  it('> level', function()
    local foo = display.newGroup()
    local panel = Panel:level()
    assert.are.equal(#foo.children, 0)
    assert.are.equal(panel.x, 0)
    assert.are.equal(panel.y, 0)

    Panel:level({
      parent = foo,
      status = 'off'
    })

    assert.are.equal(#foo.children, 1)
  end)

  it('> chapter', function()
    local foo = display.newGroup()
    local panel = Panel:chapter()
    assert.are.equal(#foo.children, 0)
    assert.are.equal(panel.x, 0)
    assert.are.equal(panel.y, 0)

    Panel:chapter({
      parent = foo,
      status = 'off'
    })

    assert.are.equal(#foo.children, 1)
  end)
end)
