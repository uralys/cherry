local App = require('app.app')

describe('[App]', function()
  it('should instanciate an App', function()
    print('========================================== test App')
    App:start({
      name    = 'Demo',
      version = '2.6.0'
    })
    print('========================================== /test App')
  end)
end)
