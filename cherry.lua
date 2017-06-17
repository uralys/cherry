-- corona
_G.composer = _G.composer or require 'composer'

-- app
_G.App     = require 'app.app'
_G.Router  = require 'app.router'

-- engine
_G.Camera  = require 'engine.camera'
_G.Effects = require 'engine.effects'
_G.Game    = require 'engine.game'
_G.Sound   = require 'engine.sound'

-- debug
_G.log     = _G.log or function(stuff, options)
  if(type(stuff) == 'table') then
    local inspect = require 'inspect'
    print(inspect(stuff, options))
  else
    print(stuff)
  end
end
