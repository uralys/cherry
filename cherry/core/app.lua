--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local analytics = require 'cherry.libs.analytics'
local _ = require 'cherry.libs.underscore'
local Game = require 'cherry.core.game'
local User = require 'cherry.core.user'
local Score = require 'cherry.core.score'
local Sound = require 'cherry.core.sound'
local file = _G.file or require 'cherry.libs.file'

--------------------------------------------------------------------------------

local App = {
  name = 'Uralys',
  cherryVersion = _G.CHERRY_VERSION,
  version = '0.0.1',
  -----------------------------------------
  -- 'production', 'development', 'editor'
  ENV = 'development',
  -----------------------------------------
  FACEBOOK_PAGE_ID = '379432705492888',
  FACEBOOK_PAGE = 'https://www.facebook.com/uralys',
  ANALYTICS_TRACKING_ID = nil, --'UA-XXXXX-XX',
  IOS_ID = nil,
  API_GATEWAY_URL = nil,
  API_GATEWAY_KEY = nil,
  -----------------------------------------
  fonts = {
    default = 'cherry/assets/PatrickHand-Regular.ttf'
  },
  -----------------------------------------
  screens = {
    HOME = 'home',
    LEADERBOARD = 'leaderboard',
    PLAYGROUND = 'playground',
    HEADPHONES = 'headphones'
  },
  -----------------------------------------
  background = {
    light = 'cherry/assets/images/background-light.jpg',
    dark = 'cherry/assets/images/background-dark.jpg'
  },
  -----------------------------------------
  images = {
    blurBG = 'cherry/assets/images/overlay-blur.png',
    star = 'cherry/assets/images/gui/items/star.icon.png',
    heart = 'cherry/assets/images/gui/items/heart.png',
    heartLeft = 'cherry/assets/images/gui/items/heart-left.png',
    heartRight = 'cherry/assets/images/gui/items/heart-right.png',
    step = 'cherry/assets/images/gui/buttons/empty.png',
    verticalPanel = 'cherry/assets/images/gui/panels/panel.vertical.png',
    greenGem = 'cherry/assets/images/gui/items/gem.green.png'
  },
  -----------------------------------------
  xGravity = 0,
  yGravity = 0,
  -----------------------------------------
  usePhysics = false,
  useNamePicker = false,
  hasTutorial = false,
  showHeadphonesScreen = false,
  -----------------------------------------
  -- layers (+ BG and stage)
  transversalBackLayer = display.newGroup(),
  transversalFrontLayer = display.newGroup(),
  hud = display.newGroup(),
  -----------------------------------------
  reorderLayers = function()
    App.transversalBackLayer:toBack()
    Background:toBack()
    App.transversalFrontLayer:toFront()
    App.resetHUD()
  end,
  resetHUD = function()
    display.remove(App.hud)
    App.hud = display.newGroup()
    App.hud:toFront()
  end
}

--------------------------------------------------------------------------------

function App:start(options)
  options = options or {}
  local screens = _.extend(App.screens, options.screens)
  local images = _.extend(App.images, options.images)
  App = _.extend(App, options)
  App.images = images
  App.screens = screens

  _G = _.extend(_G, options.globals)

  _G.log('--------------------------------')
  _G.log(App.name .. ' [ ' .. App.ENV .. ' | ' .. App.version .. ' ] ')
  _G.log('🍒 Cherry: ' .. App.cherryVersion)
  _G.log(_G._VERSION)
  _G.log('--------------------------------')
  _G.log('🔌 extensions:')
  _G.log(App.extension, {depth = 1})
  _G.log('--------------------------------')
  _G.log('🌐 globals:')
  _G.log(options.globals)
  _G.log('--------------------------------')

  self:deviceSetup()
  self:setup()
  self:loadSettings()

  _G.log('✅ settings are ready.')
  _G.log('--------------------------------')

  self:create()
  _G.log('🎉 App is running.')
  _G.log('--------------------------------')
end

--------------------------------------------------------------------------------

function App:loadSettings()
  _G.log('👨‍🚀 Loading settings...')
  local path = 'env/' .. App.ENV .. '.json'
  local settings = file.load(path)
  _G = _.extend(_G, settings)

  -----------------------------')

  App.RESET_USER = settings['reset-user']
  App.SHOW_TOUCHABLES = settings['show-touchables']
  App.SOUND_OFF = settings.silent
  App.EDITOR_TESTING = settings.editor
  App.EDITOR_PLAY = settings.play
  App.VIEW_TESTING = settings['view-testing']
  App.LEVEL_TESTING = settings['level-testing']

  if (App.LEVEL_TESTING) then
    App.TESTING_CHAPTER = App.LEVEL_TESTING.chapter
    App.TESTING_LEVEL = App.LEVEL_TESTING.level
    App.TESTING_STEPS = App.LEVEL_TESTING.step
  end
end

--------------------------------------------------------------------------------

function App:create()
  _G.log('👨‍🚀 creating app...')
  self.game = Game:new(App.extension.game)
  _G.log('  ✅ App.game')
  self.user = User:new(App.extension.user)
  self.user:load()
  _G.log('  ✅ App.user')

  self.score = Score:new(App.extension.score)
  _G.log('  ✅ App.score')
  self.sound = Sound:init(App.extension.sound)
  _G.log('  ✅ App.sound')

  if (self.useNamePicker) then
    local NamePicker = require 'cherry.extensions.name-picker'
    self.namePicker = NamePicker:new()
    _G.log('  ✅ App.namePicker')
  end

  Background:init(App.background)
  _G.log('  ✅ Background')

  if (self.ANALYTICS_TRACKING_ID) then
    analytics.init(
      self.ANALYTICS_TRACKING_ID,
      self.user:deviceId(),
      self.name,
      self.version
    )
    _G.log('  ✅ Initialized analytics')
  end

  _G.log('  Preparing first view...')
  if (App.VIEW_TESTING) then
    _G.log('🐛 VIEW_TESTING --> forced view : ' .. App.VIEW_TESTING)
    _G.log('--------------------------------')
    _G.Router:open(App.VIEW_TESTING)
  elseif (App.EDITOR_TESTING or App.LEVEL_TESTING) then
    _G.log('🐛 EDITOR_TESTING or LEVEL_TESTING --> forced playground')
    _G.log('--------------------------------')
    _G.Router:open(App.screens.PLAYGROUND)
  else
    local nextView = App.screens.HOME
    if (self.user:isNew() and App.hasTutorial) then
      nextView = App.screens.PLAYGROUND
    end

    if (self.showHeadphonesScreen) then
      _G.Router:open(
        App.screens.HEADPHONES,
        {
          nextView = nextView
        }
      )
    else
      Router:open(nextView)
    end
  end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function App:setup()
  _G.log('👨‍🚀 Application setup...')

  ----------------------------------------------------------------------------

  _G.IOS = system.getInfo('platformName') == 'iPhone OS'
  _G.ANDROID = system.getInfo('platformName') == 'Android'
  _G.SIMULATOR = system.getInfo('environment') == 'simulator'
  _G.FONTS = App.fonts

  ----------------------------------------------------------------------------

  App.colors =
    _.defaults(
    App.colors or {},
    {
      '#7f00ff',
      '#ff00ff'
    }
  )

  ----------------------------------------------------------------------------

  if (_G.IOS or _G.SIMULATOR) then
    display.setStatusBar(display.HiddenStatusBar)
  end

  ----------------------------------------------------------------------------

  self.aspectRatio = display.pixelHeight / display.pixelWidth
end

--------------------------------------------------------------------------------

local function onKeyEvent(event)
  local phase = event.phase
  local keyName = event.keyName

  if ('back' == keyName and phase == 'up') then
    _G.log('back button is not handled')
  end

  return true
end

function App:deviceSetup()
  _G.log('👨‍🚀 Device setup...')

  if (self.pushSubscriptions) then
    _G.log('  Setting up FCM:')
    local notifications = require('plugin.notifications.v2')
    _G.log('    Closed previous notifications.')
    notifications.cancelNotification()
    _G.log('    Registering to notifications...')
    notifications.registerForPushNotifications({useFCM = true})

    for _, topic in pairs(self.pushSubscriptions) do
      notifications.subscribe(topic)
      _G.log('    Subscribed to topic ' .. topic)
    end
  else
    _G.log('  (no pushSubscriptions)')
  end

  ----------------------------------------------------------------------------
  -- prepare notifications for this session
  -- these notifications can be removed as long as the App is ON

  self.deviceNotifications = {}

  ----------------------------------------------------------------------------
  --- ANDROID BACK BUTTON

  if (_G.ANDROID) then
    Runtime:removeEventListener('key', onKeyEvent)
    Runtime:addEventListener('key', onKeyEvent)
  end
end

--------------------------------------------------------------------------------

function App:deviceNotification(text, secondsFromNow, id)
  _G.log(
    '----> deviceNotification : [' ..
      id .. '] --> ' .. text .. ' (' .. secondsFromNow .. ')'
  )

  local options = {
    alert = text,
    badge = 1
  }

  if (self.deviceNotifications[id]) then
    _G.log('cancelling device notification : ', self.deviceNotifications[id])
    system.cancelNotification(self.deviceNotifications[id])
  end

  _G.log('scheduling : ', id, secondsFromNow)
  self.deviceNotifications[id] =
    system.scheduleNotification(secondsFromNow, options)

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
