--------------------------------------------------------------------------------
VERSION = '2.0'
--------------------------------------------------------------------------------
-- libs
json          = require 'json'
composer      = require 'composer'

_             = require 'Cherry.libs.Underscore'
utils         = require 'Cherry.libs.Utils'
Vector2D      = require 'Cherry.libs.Vector2D'
analytics     = require 'Cherry.libs.google.Analytics'

-- app
App           = require 'Cherry.app.App'
Router        = require 'Cherry.app.Router'
User          = require 'Cherry.app.User'

-- engine
Camera        = require 'Cherry.engine.Camera'
Effects       = require 'Cherry.engine.Effects'
Game          = require 'Cherry.engine.Game'
Score         = require 'Cherry.engine.Score'
Sound         = require 'Cherry.engine.Sound'
