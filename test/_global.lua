expose('[setting up tests Globals]', function()
  _G.inspect    = require('inspect')
  _G.display    = require('mocks.display')
  _G.transition = require('mocks.transition')
  _G.App        = require('mocks.app')
  _G.network    = require('mocks.network')
  _G.http       = require('mocks.http')

  _G.easing     = {}
  _G.timer      = {performWithDelay = function(time, func) func() end}
end)
