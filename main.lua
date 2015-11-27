--------------------------------------------------------------------------------
--
-- main.lua
--
--------------------------------------------------------------------------------
--- Corona's libraries
json                = require 'json'
composer            = require 'composer'

---- Additional libs

CBE                 = require 'CBE.CBE'
_                   = require 'src.libs.Underscore'
utils               = require 'src.libs.Utils'
analytics           = require 'src.libs.google.Analytics'

--------------------------------------------------------------------------------
---- App packages

-- main
App                 = require 'src.App'
Router              = require 'src.Router'
User                = require 'src.User'

-- game engine
Game                = require 'src.game.engine.Game'
Camera              = require 'src.game.engine.Camera'
HUD                 = require 'src.game.engine.HUD'
LevelDrawer         = require 'src.game.engine.LevelDrawer'
Effects             = require 'src.game.engine.Effects'
Touch               = require 'src.game.engine.TouchController'
Score               = require 'src.game.engine.Score'
Tutorial            = require 'src.game.engine.Tutorial'
Sound               = require 'src.game.engine.Sound'

-- gui components
GUI                 = require 'src.components.GUI'
Background          = require 'src.components.Background'
Profile             = require 'src.components.Profile'
Level               = require 'src.components.Level'
Panel               = require 'src.components.Panel'
Banner              = require 'src.components.Banner'
Button              = require 'src.components.Button'
Icon                = require 'src.components.Icon'
ProgressBar         = require 'src.components.ProgressBar'
Scroller            = require 'src.components.Scroller'
Screen              = require 'src.components.Screen'
Focus               = require 'src.components.Focus'

Chapters            = require 'src.components.Chapters'
Profiles            = require 'src.components.Profiles'

--------------------------------------------------------------------------------
---- Models

Item                = require 'src.game.models.Item'

--------------------------------------------------------------------------------

App:start()
