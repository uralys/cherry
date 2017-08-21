local Background = require('cherry.components.background')

describe('[Background]', function()
  it('should instanciate a simple background', function()
    local background = Background:init()

    assert.are.equal(background.bg.x, display.contentWidth*0.5)
    assert.are.equal(background.bg.y, display.contentHeight*0.5)
    assert.are.equal(background.darkBG.x, display.contentWidth*0.5)
    assert.are.equal(background.darkBG.y, display.contentHeight*0.5)
    assert.are.equal(background.darkBG.alpha, 1)
  end)

  it('darken/lighten should change darkBG alpha', function()
    local background = Background:init()
    assert.are.equal(background.darkBG.alpha, 1)

    background:lighten()
    assert.are.equal(background.darkBG.alpha, 0)

    background:darken()
    assert.are.equal(background.darkBG.alpha, 1)
  end)
end)
