expose('[setting up tests Globals]', function()
  _G.inspect    = require('inspect')
  _G.display    = require('mocks.display')
  _G.App        = require('mocks.app')
  _G.audio      = require('mocks.audio')
  _G.composer   = require('mocks.composer')
  _G.http       = require('mocks.http')
  _G.network    = require('mocks.network')
  _G.physics    = require('mocks.physics')
  _G.Runtime    = require('mocks.runtime')
  _G.system     = require('mocks.system')
  _G.transition = require('mocks.transition')

  _G.easing     = {}
  _G.timer      = {performWithDelay = function(time, func) func() end}
  _G.log        = function() end

  _G.round = function (num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end
  math.round = _G.round

end)
