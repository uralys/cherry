--------------------------------------------------------------------------------

local Router = {
    view = nil,

    TUTORIAL        = 'Tutorial',
    HOME            = 'Home',
    PLAYGROUND      = 'Playground',
    PROFILES        = 'Profiles',
    HEADPHONES      = 'Headphones',
    CHAPTERS        = 'Chapters',
    LEVEL_SELECTION = 'LevelSelection'
}

--------------------------------------------------------------------------------

function Router:resetScreen()
    Effects:stop(true)
    utils.emptyGroup(App.hud)
    Effects:start()
end

--------------------------------------------------------------------------------

function Router:openScreen(id, class, params)
    local options = {
        params = params
    }
    self:resetScreen()
    analytics.pageview(id)

    Router.view = id
    print('Router : openScreen : ' .. Router.view )

    composer.gotoScene( class, options )
end

--------------------------------------------------------------------------------

function Router:open(id, params)
    self:openScreen(id, 'src.screens.' .. id, params)
end

--------------------------------------------------------------------------------

return Router
