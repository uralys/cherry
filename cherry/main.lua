--------------------------------------------------------------------------------
_G.CHERRY_VERSION = '3.2.0'
--------------------------------------------------------------------------------
-- debug
require 'cherry.libs.logger'
require 'cherry.libs.test-rect'

-- libs extensions
require 'cherry.libs.math'
require 'cherry.libs.string'
require 'cherry.libs.table'

--------------------------------------------------------------------------------
-- corona
_G.composer = _G.composer or require 'composer'

-- app
_G.App = require 'cherry.core.app'
_G.Router = require 'cherry.core.router'

-- engine
_G.Game = require 'cherry.engine.game'
_G.Sound = require 'cherry.engine.sound'

--------------------------------------------------------------------------------

_G.W = display.contentWidth
_G.H = display.contentHeight

--------------------------------------------------------------------------------
-- https://docs.coronalabs.com/tutorial/media/extendAnchors/index.html#extending-anchor-points-1
display.setDefault('isAnchorClamped', false)
