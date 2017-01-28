--------------------------------------------------------------------------------
VERSION = '2.0'
--------------------------------------------------------------------------------
-- libs
_             = require 'Cherry.libs.Underscore'
utils         = require 'Cherry.libs.Utils'
Vector2D      = require 'Cherry.libs.Vector2D'
analytics     = require 'Cherry.libs.google.Analytics'

-- app
App           = require 'Cherry.app.App'
Router        = require 'Cherry.app.Router'
User          = require 'Cherry.app.User'

-- engine
Game          = require 'Cherry.engine.Game'
Camera        = require 'Cherry.engine.Camera'
Effects       = require 'Cherry.engine.Effects'
Score         = require 'Cherry.engine.Score'
Sound         = require 'Cherry.engine.Sound'

-- components
GUI           = require 'Cherry.components.GUI'
Background    = require 'Cherry.components.Background'
Panel         = require 'Cherry.components.Panel'
Banner        = require 'Cherry.components.Banner'
Button        = require 'Cherry.components.Button'
Icon          = require 'Cherry.components.Icon'
ProgressBar   = require 'Cherry.components.ProgressBar'
Scroller      = require 'Cherry.components.Scroller'
Screen        = require 'Cherry.components.Screen'
Focus         = require 'Cherry.components.Focus'
Cooldown      = require 'Cherry.components.Cooldown'
Options       = require 'Cherry.components.Options'
