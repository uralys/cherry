require('cherry')
local App = require('app.app')

describe('[App]', function()
  it('should instanciate an App', function()
    App:start({
      name    = 'Demo',
      version = '2.6.0'
    })
  end)

  it('should test gpgs', function()
    App:start({
      name    = 'Demo',
      version = '2.6.0',
      useGPGS = true
    })
  end)
end)
