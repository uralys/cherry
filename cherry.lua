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
Camera        = require 'Cherry.engine.Camera'
Effects       = require 'Cherry.engine.Effects'
Game          = require 'Cherry.engine.Game'
Score         = require 'Cherry.engine.Score'
Sound         = require 'Cherry.engine.Sound'

-- components
Background    = require 'Cherry.components.Background'
Banner        = require 'Cherry.components.Banner'
Button        = require 'Cherry.components.Button'
Chapters      = require 'Cherry.components.Chapters'
Cooldown      = require 'Cherry.components.Cooldown'
Focus         = require 'Cherry.components.Focus'
GUI           = require 'Cherry.components.GUI'
Icon          = require 'Cherry.components.Icon'
Level         = require 'Cherry.components.Level'
Options       = require 'Cherry.components.Options'
Panel         = require 'Cherry.components.Panel'
Profile       = require 'Cherry.components.Profile'
ProgressBar   = require 'Cherry.components.ProgressBar'
Screen        = require 'Cherry.components.Screen'
Scroller      = require 'Cherry.components.Scroller'
