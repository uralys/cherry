--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local analytics  = require 'cherry.libs.analytics'
local _          = require 'cherry.libs.underscore'
local demo       = require 'cherry.core.extension-demo'
local User       = require 'cherry.core.user'
local Score      = require 'cherry.screens.score'
local NamePicker = require 'cherry.screens.name-picker'
local file       = _G.file or require 'cherry.libs.file'

--------------------------------------------------------------------------------

local App = {
  name          = 'Uralys',
  cherryVersion = _G.CHERRY_VERSION,
  version       = '0.0.1',
  IOS_ID        = 'XXXXX',

  -----------------------------------------
  -- 'production', 'development', 'editor'
  ENV = 'development',
  -----------------------------------------

  font = 'cherry/assets/PatrickHand-Regular.ttf',

  background = {
    light = 'cherry/assets/images/background-light.jpg',
    dark  = 'cherry/assets/images/background-dark.jpg'
  },

  -----------------------------------------

  images = {
    blurBG        = 'cherry/assets/images/overlay-blur.png',
    star          = 'cherry/assets/images/gui/items/star.icon.png',
    heart         = 'cherry/assets/images/gui/items/heart.png',
    heartLeft     = 'cherry/assets/images/gui/items/heart-left.png',
    heartRight    = 'cherry/assets/images/gui/items/heart-right.png',
    step          = 'cherry/assets/images/gui/buttons/empty.png',
    verticalPanel = 'cherry/assets/images/gui/panels/panel.vertical.png',
    greenGem      = 'cherry/assets/images/gui/items/gem.green.png'
  },

  -----------------------------------------

  xGravity = 0,
  yGravity = 0,

  -----------------------------------------

  usePhysics     = false,
  useNamePicker  = true,
  hasTutorial    = false,

  -----------------------------------------

  extension = {
    game = demo
  },

  -----------------------------------------

  FACEBOOK_PAGE_ID = '379432705492888',
  FACEBOOK_PAGE    = 'https://www.facebook.com/uralys',

  ANALYTICS_VERSION     = 1,
  ANALYTICS_TRACKING_ID = 'UA-XXXXX-XX',

  -----------------------------------------

  display = display.newGroup(),
  hud     = display.newGroup()
}

--------------------------------------------------------------------------------

function App:start(options)
  options = options or {}
  local images = _.extend(App.images, options.images)
  App = _.extend(App, options)
  App.images = images

  _G = _.extend(_G, options.globals)

  _G.log('--------------------------------')
  _G.log( App.name .. ' [ ' .. App.ENV .. ' | ' .. App.version .. ' ] ')
  _G.log( 'Cherry: ' .. App.cherryVersion)
  _G.log( _G._VERSION )
  _G.log('--------------------------------')
  _G.log('extensions:')
  _G.log(App.extension, {depth = 1})
  _G.log('--------------------------------')
  _G.log('globals:')
  _G.log(options.globals)
  _G.log('--------------------------------')

  self:deviceSetup()
  self:setup()
  self:loadSettings()
  self:ready()
end

--------------------------------------------------------------------------------

function App:loadSettings()
  _G.log('---------- SETTINGS ------------')
  local path = 'env/' .. App.ENV .. '.json'
  local settings = file.load(path)
  _G.log(settings)
  _G.log('--------------------------------')

  App.INVINCIBLE     = settings.invincible
  App.SOUND_OFF      = settings.silent
  App.EDITOR_TESTING = settings.editor
  App.EDITOR_PLAY    = settings.play
  App.VIEW_TESTING   = settings['view-testing']
  App.LEVEL_TESTING  = settings['level-testing']

  if(App.LEVEL_TESTING) then
    App.TESTING_CHAPTER = App.LEVEL_TESTING.chapter
    App.TESTING_LEVEL   = App.LEVEL_TESTING.level
    App.TESTING_STEPS   = App.LEVEL_TESTING.step
  end
end

--------------------------------------------------------------------------------

function App:ready()
  self.game  = Game:new(App.extension.game)
  self.user  = User:new(App.extension.user)
  self.user:load()

  self.namePicker = NamePicker:new()

  self.score = Score:new(App.extension.score)
  self.sound = Sound:init(App.extension.sound)

  Background:init(App.background)

  analytics.init(
    self.ANALYTICS_VERSION,
    self.ANALYTICS_TRACKING_ID,
    self.user:deviceId(),
    self.name,
    self.version
  )

  if(App.VIEW_TESTING) then
    _G.log(' --> forced view : ' .. App.VIEW_TESTING)
    _G.log('--------------------------------')
    _G.Router:open(App.VIEW_TESTING)

  elseif(App.EDITOR_TESTING or App.LEVEL_TESTING) then
    _G.log(' --> forced playground')
    _G.log('--------------------------------')
    _G.Router:open(_G.Router.PLAYGROUND)

  else
    local nextView = _G.Router.HOME
    if(self.user:isNew() and App.hasTutorial) then
      nextView = _G.Router.PLAYGROUND
    end

    _G.Router:open(_G.Router.HEADPHONES, {
      nextView = nextView
    })
  end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function App:setup()
  _G.log('Application setup...')

  ----------------------------------------------------------------------------

  _G.IOS       = system.getInfo( 'platformName' )  == 'iPhone OS'
  _G.ANDROID   = system.getInfo( 'platformName' )  == 'Android'
  _G.SIMULATOR = system.getInfo( 'environment' )   == 'simulator'
  _G.FONT      = App.font

  ----------------------------------------------------------------------------

  App.colors = _.defaults(App.colors or {}, {
    '#7f00ff',
    '#ff00ff'
  })

  ----------------------------------------------------------------------------

  if(_G.IOS or _G.SIMULATOR) then
    display.setStatusBar( display.HiddenStatusBar )
  end

  ----------------------------------------------------------------------------

  self.aspectRatio = display.pixelHeight / display.pixelWidth
end

--------------------------------------------------------------------------------

local function onKeyEvent( event )
  local phase = event.phase
  local keyName = event.keyName

  if ( 'back' == keyName and phase == 'up' ) then
    _G.log('back button is not handled')
  end

  return true
end

function App:deviceSetup()
  _G.log('Device setup...')

  if(self.pushSubscriptions) then
    _G.log('  Setting up FCM:')
    local notifications = require( 'plugin.notifications.v2' )
    _G.log('    Closed previous notifications.')
    notifications.cancelNotification()
    _G.log('    Registering to notifications...')
    notifications.registerForPushNotifications({useFCM = true})

    for _,topic in pairs(self.pushSubscriptions) do
      notifications.subscribe(topic)
      _G.log('    Subscribed to topic ' .. topic)
    end
  end

  ----------------------------------------------------------------------------
  -- prepare notifications for this session
  -- these notifications can be removed as long as the App is ON

  self.deviceNotifications = {}

  ----------------------------------------------------------------------------
  --- ANDROID BACK BUTTON

  if(_G.ANDROID) then
    Runtime:removeEventListener( 'key', onKeyEvent )
    Runtime:addEventListener( 'key', onKeyEvent )
  end
end

--------------------------------------------------------------------------------

function App:deviceNotification(text, secondsFromNow, id)
  _G.log('----> deviceNotification : [' .. id .. '] --> ' ..
    text .. ' (' .. secondsFromNow .. ')'
  )

  local options = {
    alert = text,
    badge = 1,
  }

  if(self.deviceNotifications[id]) then
    _G.log('cancelling device notification : ', self.deviceNotifications[id])
    system.cancelNotification( self.deviceNotifications[id] )
  end

  _G.log('scheduling : ', id, secondsFromNow)
  self.deviceNotifications[id] = system.scheduleNotification(
    secondsFromNow,
    options
  )

  _G.log('scheduled : ', self.deviceNotifications[id])
end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function App:adaptToRatio(value)
  return value * self.aspectRatio * self.aspectRatio
end

--------------------------------------------------------------------------------

return App
