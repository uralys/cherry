local gesture = require 'cherry.libs.gesture'

describe('[gesture]', function()
    describe('[onTouch]', function()
      it('> phase.began: action is not called, opacity becomes 0.8', function()
        local foo = display.newImage(App.display)
        local action = spy.new(function() end)
        assert.are.equal(foo.alpha, 1)

        gesture.onTouch(foo, action)

        foo:tap()

        assert.are.equal(foo.alpha, 0.8)
        assert.spy(action).was.called(0)
      end)

      it('> phase.ended: action is called, opacity is back to 1', function()
        local foo = display.newImage(App.display)
        local action = spy.new(function() end)

        gesture.onTouch(foo, action)

        foo:touch()

        assert.spy(action).was.called(1)
        assert.are.equal(foo.alpha, 1)
      end)

      it('> should override previous action', function()
        local foo = display.newImage(App.display)
        local action1 = spy.new(function() end)
        local action2 = spy.new(function() end)

        gesture.onTouch(foo, action1)
        gesture.onTouch(foo, action2)

        foo:touch()

        assert.spy(action1).was.called(0)
        assert.spy(action2).was.called(1)
      end)
    end)

    describe('[onTap]', function()
      it('> phase.began: action is called', function()
        local foo = display.newImage(App.display)
        local action = spy.new(function() end)

        gesture.onTap(foo, action)
        foo:tap()

        assert.spy(action).was.called(1)
      end)

      it('> phase.ended: action is not called', function()
        local foo = display.newImage(App.display)
        local action = spy.new(function() end)

        gesture.onTap(foo, action)
        foo:touch()

        assert.spy(action).was.called(0)
      end)

      it('> should override previous action', function()
        local foo = display.newImage(App.display)
        local action1 = spy.new(function() end)
        local action2 = spy.new(function() end)

        gesture.onTap(foo, action1)
        gesture.onTap(foo, action2)

        foo:tap()

        assert.spy(action1).was.called(0)
        assert.spy(action2).was.called(1)
      end)
    end)

    describe('[disabledTouch]', function()
      it('> phase.began: action is called', function()
        local foo = display.newImage(App.display)
        local action = spy.new(function() end)

        gesture.onTap(foo, action)
        gesture.disabledTouch(foo)

        foo:tap()

        assert.spy(action).was.called(0)
      end)
    end)
end)
