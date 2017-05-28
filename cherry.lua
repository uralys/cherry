--------------------------------------------------------------------------------
CHERRY_VERSION = '2.0.2'
--------------------------------------------------------------------------------
-- libs
json          = require 'json'
composer      = require 'composer'

_             = require 'cherry.libs.underscore'
utils         = require 'cherry.libs.utils'
Vector2D      = require 'cherry.libs.vector2D'
analytics     = require 'cherry.libs.google.analytics'

-- app
App           = require 'cherry.app.app'
Router        = require 'cherry.app.router'

-- engine
Camera        = require 'cherry.engine.camera'
Effects       = require 'cherry.engine.effects'
Game          = require 'cherry.engine.game'
Sound         = require 'cherry.engine.sound'
