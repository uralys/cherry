expose('[setting up tests Globals]', function()
  _G.inspect    = require('inspect')
  _G.display    = require('mocks.display')
  _G.transition = require('mocks.transition')
  _G.App        = require('mocks.app')
  _G.network    = require('mocks.network')
  _G.http       = require('mocks.http')
  _G.Runtime    = require('mocks.runtime')
  _G.system     = require('mocks.system')

  _G.easing     = {}
  _G.timer      = {performWithDelay = function(time, func) func() end}

  _G.round = function (num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

  math.round = _G.round
end)
