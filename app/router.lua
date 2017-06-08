--------------------------------------------------------------------------------

local composer  = require('composer')
local _         = require 'underscore'
local analytics = require 'analytics'
local utils     = require 'utils'
local Screen    = require 'components.screen'
local Effects   = require 'engine.effects'

--------------------------------------------------------------------------------

local Router = {
    view = nil,

    HOME       = 'home',
    PLAYGROUND = 'playground',
    HEADPHONES = 'headphones'
}

--------------------------------------------------------------------------------

function Router:resetScreen()
    Effects:stop(true)
    utils.emptyGroup(App.hud)
    Effects:start()
    if(Screen.reset) then Screen:reset() end
end

--------------------------------------------------------------------------------

function Router:openScreen(id, class, params)
    local options = {
        params = params
    }
    self:resetScreen()
    analytics.pageview(id)

    Router.view = id
    print('[Router] openScreen: ' .. Router.view )

    composer.gotoScene( class, options )
end

--------------------------------------------------------------------------------

function Router:open(id, params)
    local class
    if(utils.contains(App.screens, id)) then
        class  = 'src.screens.' .. id
    else
        class  = 'screens.' .. id
    end

    self:openScreen(id, class, params)
end

--------------------------------------------------------------------------------

return Router
