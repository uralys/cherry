local Banner = require('../../components/banner')

describe('[Banner]', function()
  it('should instanciate a simple banner', function()
    local banner = Banner:simple({
      parent = {insert = function() end},
      x = 100,
      y = 100
    })

    assert.are.equal(banner.anchorX, 0.5)
    assert.are.equal(banner.anchorY, 0.5)
    assert.are.equal(banner.x, 100)
    assert.are.equal(banner.y, 100)
  end)

  it('should instanciate a large banner', function()
    local banner = Banner:large({
      parent = {insert = function() end},
      x = 100,
      y = 100
    })

    assert.are.equal(banner.anchorX, 0.5)
    assert.are.equal(banner.anchorY, 0.5)
    assert.are.equal(banner.x, 100)
    assert.are.equal(banner.y, 100)
  end)
end)
