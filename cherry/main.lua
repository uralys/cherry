--------------------------------------------------------------------------------
_G.CHERRY_VERSION = '3.7.0'
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

--------------------------------------------------------------------------------

_G.FULL_W = display.contentWidth
_G.FULL_H = display.contentHeight

_G.W = display.safeActualContentWidth
_G.H = display.safeActualContentHeight

_G.TOP = display.safeScreenOriginY
_G.BOTTOM = display.safeScreenOriginY + display.safeActualContentHeight

-- local safeArea = display.newRect(W / 2, TOP + H / 2, W, H)
-- local colorize = require 'cherry.libs.colorize'
-- safeArea:setFillColor(colorize('#fff'))
-- safeArea.alpha = 0.2

--------------------------------------------------------------------------------
-- https://docs.coronalabs.com/tutorial/media/extendAnchors/index.html#extending-anchor-points-1
display.setDefault('isAnchorClamped', false)
