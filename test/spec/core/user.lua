local User = require('cherry.core.user')

describe(
  '[User]',
  function()
    it(
      '> should create a user',
      function()
        local user = User:new()
        assert.is.falsy(user.savedData)
      end
    )

    it(
      '> should create savedData',
      function()
        local onLoad =
          spy.new(
          function()
          end
        )
        local onCreateSavedData =
          spy.new(
          function()
          end
        )

        local user =
          User:new(
          {
            onLoad = onLoad,
            onCreateSavedData = onCreateSavedData
          }
        )

        user:load()
        user.savedData.deviceId = nil

        assert.are.same(
          user.savedData,
          {
            version = 0,
            options = {
              sound = true,
              soundVolume = 1
            },
            sync = true,
            tutorial = false,
            currentUser = 1,
            users = {
              {
                name = nil,
                id = nil
              }
            }
          }
        )

        assert.spy(onLoad).was.called(1)
        assert.spy(onCreateSavedData).was.called(1)
      end
    )

    it(
      '> should toggle sound settings',
      function()
        local user = User:new()
        user:load()
        user:saveSoundSettings(true)

        assert.are.same(
          user.savedData.options,
          {
            sound = false,
            soundVolume = 1
          }
        )
      end
    )
  end
)
