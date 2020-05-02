require('cherry.main')
local App = require('cherry.core.app')

describe(
  '[App]',
  function()
    it(
      'should instanciate an App',
      function()
        App:start()
      end
    )

    it(
      'should accept few options',
      function()
        App:start(
          {
            name = 'Demo',
            version = '2.6.0'
          }
        )
      end
    )

    it(
      'should test gpgs',
      function()
        App:start(
          {
            useGPGS = true
          }
        )
      end
    )

    it(
      'should open a view directly',
      function()
        App:start(
          {
            ENV = 'development'
          }
        )
      end
    )

    it(
      'should start as production',
      function()
        App:start(
          {
            ENV = 'production'
          }
        )
      end
    )

    it(
      'should start as iOS',
      function()
        system.switchPlatform('iPhone OS')
        App:start()
        system.switchPlatform('Android')
      end
    )

    it(
      'should override colors',
      function()
        App:start(
          {
            colors = {
              'DA1D38', -- #DA1D38
              'ffe35b', -- #ffe35b
              '8E84F8' -- #8E84F8
            }
          }
        )

        assert.are.same(
          App.colors,
          {
            'DA1D38',
            'ffe35b',
            '8E84F8'
          }
        )
      end
    )

    it(
      'should listen key events',
      function()
        App:start()

        Runtime:dispatchEvent(
          {
            name = 'key',
            phase = 'up',
            keyName = 'back'
          }
        )
      end
    )

    it(
      'should send device notifications',
      function()
        App:start()
        assert.are.equal(#App.deviceNotifications, 0)

        App:deviceNotification('plop', 10, 'test.plop')
        assert.are.equal(table.count(App.deviceNotifications), 1)

        -- should cancel previous one and add a new one
        App:deviceNotification('plop', 10, 'test.plop')
        assert.are.equal(table.count(App.deviceNotifications), 1)

        App:deviceNotification('plop!', 10, 'test.other.plop')
        assert.are.equal(table.count(App.deviceNotifications), 2)
        _G.log(App.deviceNotifications)
      end
    )
  end
)
