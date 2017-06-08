local gesture = require 'gesture'

describe('[gesture]', function()
  it('> onTouch', function()
    local foo = display.newImage(App.display)
    local action = spy.new(function() end)

    gesture.onTouch(foo, action)

    foo:dispatchEvent({
        name = 'touch',
        phase = 'ended'
    })

    assert.spy(action).was.called(1)
  end)
end)
