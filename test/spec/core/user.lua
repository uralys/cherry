local User = require('cherry.core.user')

describe('[User]', function()
  it('> should create a user', function()
    local user = User:new()
    assert.is.falsy(user.savedData)
  end)

  it('> should create savedData', function()
    local onLoad = spy.new(function() end)
    local onResetSavedData = spy.new(function() end)

    local user = User:new({
      onLoad = onLoad,
      onResetSavedData = onResetSavedData
    })

    user:load()

    assert.are.same(user.savedData, {
        version = 'cherry.tests',
        options = {
            sound = true
        },
        tutorial = false,
        currentUser = 1,
        users = {
          {
            name = nil,
            id = nil
          }
        }
    })

    assert.spy(onLoad).was.called(1)
    assert.spy(onResetSavedData).was.called(1)
  end)

  it('> should toggle sound settings', function()
    local user = User:new()
    user:load()
    user:saveSoundSettings(true)

    assert.are.same(user.savedData.options, {
      sound = false
    })
  end)
end)
