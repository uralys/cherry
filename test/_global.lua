expose('[setting up tests Globals]', function()
  require('tprint')

  _G.sleep = function(n)
    local t = os.clock()
    while os.clock() - t <= n do
      -- nothing
    end
  end

  _G.display    = require('mocks.display')
  _G.transition = require('mocks.transition')
  _G.App        = require('mocks.app')
  _G.network    = require('mocks.network')
  _G.http       = require('mocks.http')

  _G.easing     = {}
  _G.timer      = {performWithDelay = function(time, func) func() end}
end)
