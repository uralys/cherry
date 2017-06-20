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

-- libs extensions
require 'libs.math'
require 'libs.table'

-- debug
require 'logger'
