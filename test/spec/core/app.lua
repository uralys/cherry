require('cherry.main')
local App = require('cherry.core.app')
local deviceNotification = require('cherry.extensions.device-notifications')

describe(
  '[App]',
  function()
    it(
      'should instanciate an App',
      function()
        App.start()
      end
    )

    it(
      'should accept few options',
      function()
        App.start(
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
        App.start(
          {
            useGPGS = true
          }
        )
      end
    )

    it(
      'should open a view directly',
      function()
        App.start(
          {
            ENV = 'development'
          }
        )
      end
    )

    it(
      'should start as production',
      function()
        App.start(
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
        App.start()
        system.switchPlatform('Android')
      end
    )

    it(
      'should use default colors',
      function()
        local colors = App.colors
        App.start()
        assert.are.same(App.colors, colors)
      end
    )

    it(
      'should override colors',
      function()
        local customColors = {
          '#DA1D38',
          '#ffe35b',
          '#8E84F8'
        }

        App.start(
          {
            colors = customColors
          }
        )

        assert.are.same(App.colors, customColors)
      end
    )

    it(
      'should extend App.env',
      function()
        local customEnv = {
          plop = 'plup'
        }

        App.start(
          {
            env = customEnv
          }
        )

        assert.are.same(
          App.env,
          {
            SHOW_TOUCHABLES = false,
            SOUND_OFF = false,
            name = 'cherry-default-env',
            plop = customEnv.plop
          }
        )
      end
    )

    it(
      'should extend App.images',
      function()
        local customImages = {
          plop = 'path/to/custom/img.png'
        }

        App.start(
          {
            images = customImages
          }
        )

        assert.are.same(
          App.images,
          {
            blurBG = 'cherry/assets/images/overlay-blur.png',
            greenGem = 'cherry/assets/images/gui/items/gem.green.png',
            heart = 'cherry/assets/images/gui/items/heart.png',
            heartLeft = 'cherry/assets/images/gui/items/heart-left.png',
            heartRight = 'cherry/assets/images/gui/items/heart-right.png',
            star = 'cherry/assets/images/gui/items/star.icon.png',
            step = 'cherry/assets/images/gui/buttons/empty.png',
            verticalPanel = 'cherry/assets/images/gui/panels/panel.vertical.png',
            plop = customImages.plop
          }
        )
      end
    )

    it(
      'should extend App.screens',
      function()
        local customScreens = {
          screen1 = 'SCREEN1.scene'
        }

        App.start(
          {
            screens = customScreens
          }
        )

        assert.are.same(
          App.screens,
          {
            HEADPHONES = 'headphones',
            HOME = 'home',
            LEADERBOARD = 'leaderboard',
            PLAYGROUND = 'playground',
            screen1 = customScreens.screen1
          }
        )
      end
    )

    it(
      'should listen key events',
      function()
        App.start()

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
        App.start()
        assert.are.equal(#App.deviceNotifications, 0)

        deviceNotification('plop', 10, 'test.plop')
        assert.are.equal(table.count(App.deviceNotifications), 1)

        -- should cancel previous one and add a new one
        deviceNotification('plop', 10, 'test.plop')
        assert.are.equal(table.count(App.deviceNotifications), 1)

        deviceNotification('plop!', 10, 'test.other.plop')
        assert.are.equal(table.count(App.deviceNotifications), 2)
        _G.log(App.deviceNotifications)
      end
    )
  end
)
