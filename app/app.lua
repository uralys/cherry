--------------------------------------------------------------------------------

local Background = require 'components.background'
local demo       = require 'app.extension-demo'
local User       = require 'app.user'
local Score      = require 'engine.score'
local _          = require 'underscore'
local file       = require 'file'
local analytics  = require 'analytics'

--------------------------------------------------------------------------------

local App = {
    name          = 'Uralys',
    cherryVersion = '2.5.0',
    version       = '0.0.1',
    IOS_ID        = 'XXXXX',

    -----------------------------------------
    -- 'production', 'development', 'editor'
    ENV = 'development',
    -----------------------------------------

    font = {
        android =  'y2kboogie',
        ios     = 'Year2000Boogie'
    },

    background = {
        light = 'cherry/_images/background-light.jpg',
        dark = 'cherry/_images/background-dark.jpg'
    },

    xGravity = 0,
    yGravity = 0,

    -----------------------------------------
    -- to use gpgs, add the plugin within your build.settings

    useGPGS = false,

    -----------------------------------------

    extension = {
        game = demo
    },

    -----------------------------------------

    FACEBOOK_PAGE_ID = '379432705492888',
    FACEBOOK_PAGE    = 'https://www.facebook.com/uralys',

    ANALYTICS_VERSION     = 1,
    ANALYTICS_TRACKING_ID = 'UA-XXXXX-XX',
    ANALYTICS_PROFILE_ID  = 'XXXXXXXX',

    -----------------------------------------

    display = display.newGroup(),
    hud     = display.newGroup()
}

--------------------------------------------------------------------------------

function App:start(options)
    App = _.extend(App, options or {})

    print('--------------------------------')
    print( App.name .. ' [ ' .. App.ENV .. ' | ' .. App.version .. ' ] ')
    print( 'Cherry: ' .. App.cherryVersion)
    print('--------------------------------')
    print('extensions:')
    print(_G.inspect(App.extension, {depth = 1}))
    print('--------------------------------')

    self:deviceSetup()
    self:setup()
    self:loadSettings()
    self:initGPGS(options)
    self:ready()
end

--------------------------------------------------------------------------------

function App:loadSettings()
    print('---------- SETTINGS ------------')
    local path = 'env/' .. App.ENV .. '.json'
    local settings = file.load(path)
    print(_G.inspect(settings))
    print('--------------------------------')

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

function App:initGPGS(options)
    if(not options.useGPGS) then
        return
    end

    local gpgs = require 'plugin.gpgs'

    local function gpgsLoginListener( event )
    end

    local function gpgsInitListener( event )
        if not event.isError then
            -- Try to automatically log in the user without displaying the login screen
            gpgs.login( { listener = gpgsLoginListener } )
        end
    end

    gpgs.init( gpgsInitListener )
end

--------------------------------------------------------------------------------

function App:ready()
    self.game  = Game:new(App.extension.game)
    self.score = Score:new(App.extension.score)
    self.user  = User:new(App.extension.user)
    self.user:load()

    Background:init({
        light = App.background.light,
        dark = App.background.dark
    })

    Sound:init()

    if(App.VIEW_TESTING) then
        print(' --> forced view : ' .. App.VIEW_TESTING)
        print('--------------------------------')
        Router:open(App.VIEW_TESTING)

    elseif(App.EDITOR_TESTING or App.LEVEL_TESTING) then
        print(' --> forced playground')
        print('--------------------------------')
        Router:open(Router.PLAYGROUND)

    else
        local nextView = Router.HOME

        if(self.user:isNew()) then
            nextView = Router.PLAYGROUND
        end

        Router:open(Router.HEADPHONES, {
            nextView = nextView
        })
    end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function App:setup()

    print('Application setup...')

    ----------------------------------------------------------------------------

    App.colors = _.defaults(App.colors or {}, {
        '7f00ff',
        'ff00ff'
    })

    ----------------------------------------------------------------------------

    analytics.init(
        App.ANALYTICS_VERSION,
        App.ANALYTICS_TRACKING_ID,
        App.ANALYTICS_PROFILE_ID,
        App.name,
        App.version
    )

    ----------------------------------------------------------------------------

    _G.IOS         = system.getInfo( 'platformName' )  == 'iPhone OS'
    _G.ANDROID     = system.getInfo( 'platformName' )  == 'Android'
    _G.SIMULATOR   = system.getInfo( 'environment' )   == 'simulator'

    ----------------------------------------------------------------------------

    if(_G.IOS or _G.SIMULATOR) then
        display.setStatusBar( display.HiddenStatusBar )
    end

    ----------------------------------------------------------------------------

    if _G.ANDROID then
        _G.FONT   = App.font.android
    else
        _G.FONT   = App.font.ios
    end

    ----------------------------------------------------------------------------

    self.aspectRatio = display.pixelHeight / display.pixelWidth
end

--------------------------------------------------------------------------------

function App:deviceSetup()

    print('Device setup...')

    ----------------------------------------------------------------------------
    -- prepare notifications for this session
    -- these notifications can be removed as long as the App is ON

    self.deviceNotifications = {}

    ----------------------------------------------------------------------------
    --- ANDROID BACK BUTTON

    local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName
        print( event.phase, event.keyName )

        if ( 'back' == keyName and phase == 'up' ) then
            print('back button is not handled')
        end

        if ( keyName == 'volumeUp' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume < 1.0 ) then
                masterVolume = masterVolume + 0.1
                audio.setVolume( masterVolume )
            end
        elseif ( keyName == 'volumeDown' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume > 0.0 ) then
                masterVolume = masterVolume - 0.1
                audio.setVolume( masterVolume )
            end
        end

        return true  --SEE NOTE BELOW
    end

    --add the key callback
    Runtime:addEventListener( 'key', onKeyEvent )

    ----------------------------------------------------------------------------

    local function myUnhandledErrorListener( event )

        local iHandledTheError = true

        if iHandledTheError then
            print( 'Handling the unhandled error', event.errorMessage )
        else
            print( 'Not handling the unhandled error', event.errorMessage )
        end

        return iHandledTheError
    end

    Runtime:addEventListener('unhandledError', myUnhandledErrorListener)

    ----------------------------------------------------------------------------

    -- local fonts = native.getFontNames()

    -- count = 0

    -- -- Count the number of total fonts
    -- for i,fontname in ipairs(fonts) do
    --    count = count+1
    -- end

    -- print( '\rFont count = ' .. count )

    -- local name = 'pt'     -- part of the Font name we are looking for

    -- name = string.lower( name )

    -- -- Display each font in the terminal console
    -- for i, fontname in ipairs(fonts) do

    --        print( 'fontname = ' .. tostring( fontname ) )
    -- end
end

--------------------------------------------------------------------------------

function App:deviceNotification(text, secondsFromNow, id)

    print('----> deviceNotification : [' .. id .. '] --> ' ..
            text .. ' (' .. secondsFromNow .. ')'
    )

    local options = {
        alert = text,
        badge = 1,
    }

    if(self.deviceNotifications[id]) then
        print('cancelling device notification : ', self.deviceNotifications[id])
        system.cancelNotification( self.deviceNotifications[id] )
    end

    print('scheduling : ', id, secondsFromNow)
    self.deviceNotifications[id] = system.scheduleNotification(
        secondsFromNow,
        options
    )
    print('scheduled : ', self.deviceNotifications[id])

end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function App:adaptToRatio(value)
    return value * self.aspectRatio * self.aspectRatio
end

--------------------------------------------------------------------------------

return App
