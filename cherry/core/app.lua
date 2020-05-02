--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local analytics = require 'cherry.libs.analytics'
local _ = require 'cherry.libs.underscore'
local Game = require 'cherry.core.game'
local User = require 'cherry.core.user'
local Score = require 'cherry.core.score'
local Sound = require 'cherry.core.sound'
local defaultEnv = require 'cherry.core.env'

--------------------------------------------------------------------------------

local attachPushSubscriptions = require 'cherry.extensions.push-subscriptions'
local attachBackButtonListener =
  require 'cherry.extensions.back-button-listener'

--------------------------------------------------------------------------------

local App = {
  name = 'Uralys',
  cherryVersion = _G.CHERRY_VERSION,
  version = '0.0.1',
  -----------------------------------------
  env = defaultEnv,
  -----------------------------------------
  FACEBOOK_PAGE_ID = '379432705492888',
  FACEBOOK_PAGE = 'https://www.facebook.com/uralys',
  ANALYTICS_TRACKING_ID = nil, --'UA-XXXXX-XX',
  IOS_ID = nil,
  API_GATEWAY_URL = nil,
  API_GATEWAY_KEY = nil,
  -----------------------------------------
  extension = {},
  deviceNotifications = {},
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
  colors = {
    '#7f00ff',
    '#ff00ff'
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

local function applyOptions(_options)
  local options = _options or {}

  local env = _.extend(App.env, options.env)
  local screens = _.extend(App.screens, options.screens)
  local images = _.extend(App.images, options.images)

  App = _.extend(App, options)

  App.env = env
  App.screens = screens
  App.images = images

  ----------------------------------------------------------------------------

  _G.IOS = system.getInfo('platformName') == 'iPhone OS'
  _G.ANDROID = system.getInfo('platformName') == 'Android'
  _G.SIMULATOR = system.getInfo('environment') == 'simulator'
  _G.FONTS = App.fonts

  ----------------------------------------------------------------------------

  if (_G.IOS or _G.SIMULATOR) then
    display.setStatusBar(display.HiddenStatusBar)
  end
end

--------------------------------------------------------------------------------

local function createApp()
  _G.log('👨‍🚀 creating app...')
  App.game = Game:new(App.extension.game)
  _G.log('  ✅ App.game')
  App.user = User:new(App.extension.user)
  App.user:load()
  _G.log('  ✅ App.user')

  App.score = Score:new(App.extension.score)
  _G.log('  ✅ App.score')
  App.sound = Sound:init(App.extension.sound)
  _G.log('  ✅ App.sound')

  if (App.useNamePicker) then
    local NamePicker = require 'cherry.extensions.name-picker'
    App.namePicker = NamePicker:new()
    _G.log('  ✅ App.namePicker')
  end

  Background:init(App.background)
  _G.log('  ✅ Background')

  if (App.ANALYTICS_TRACKING_ID) then
    analytics.init(
      App.ANALYTICS_TRACKING_ID,
      App.user:deviceId(),
      App.name,
      App.version
    )
    _G.log('  ✅ Initialized analytics')
  end

  _G.log('  Preparing first view...')
  if (_G.VIEW_TESTING) then
    _G.log('🐛 VIEW_TESTING --> forced view : ' .. _G.VIEW_TESTING)
    _G.log('--------------------------------')
    Router:open(_G.VIEW_TESTING)
  elseif (_G.EDITOR_TESTING or _G.LEVEL_TESTING) then
    _G.log('🐛 EDITOR_TESTING or LEVEL_TESTING --> forced playground')
    _G.log('--------------------------------')
    Router:open(App.screens.PLAYGROUND)
  else
    local nextView = App.screens.HOME
    if (App.user:isNew() and App.hasTutorial) then
      nextView = App.screens.PLAYGROUND
    end

    if (App.showHeadphonesScreen) then
      Router:open(
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

function App.start(options)
  _G.log('--------------------------------')
  _G.log('🍒 Cherry: ' .. App.cherryVersion)
  _G.log(' > ' .. _G._VERSION) -- Lua version

  applyOptions(options)

  _G.log('--------------------------------')
  _G.log(App.name .. ' [ ' .. App.version .. ' | ' .. App.env.name .. ' ] ')
  _G.log('--------------------------------')
  _G.log('🔌 extensions:')
  _G.log(App.extension, {depth = 1})
  attachPushSubscriptions(App.pushSubscriptions)
  attachBackButtonListener()
  _G.log('--------------------------------')

  createApp()

  _G.log('🎉 App is running.')
  _G.log('--------------------------------')
end

--------------------------------------------------------------------------------

return App
