expose(
  '[setting up tests Globals]',
  function()
    require 'cherry.libs.math'
    _G.inspect = require('cherry.libs.inspect')
    _G.display = require('mocks.display')
    _G.App = require('mocks.app')
    _G.audio = require('mocks.audio')
    _G.composer = require('mocks.composer')
    _G.http = require('mocks.http')
    _G.file = require('mocks.file')
    _G.network = require('mocks.network')
    _G.physics = require('mocks.physics')
    _G.Runtime = require('mocks.runtime')
    _G.system = require('mocks.system')
    _G.transition = require('mocks.transition')
    _G.FONTS = {default = ''}

    _G.easing = {}
    _G.timer = {
      performWithDelay = function(time, func)
        func()
      end
    }

    _G.DEBUG = os.getenv('DEBUG') -- make busted verbose=true

    if (_G.DEBUG) then
      require('cherry.libs.logger')
    else
      _G.log = function()
      end
    end
  end
)
