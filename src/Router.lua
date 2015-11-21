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

function Router:openView(id, class, params)
    local options = {
        params = params
    }
    self:resetScreen()
    analytics.pageview(id)

    Router.view = id
    print('Router : openView : ' .. Router.view )

    composer.gotoScene( class, options )
end

--------------------------------------------------------------------------------

function Router:open(id, params)
    self:openView(id, 'src.views.' .. id, params)
end

--------------------------------------------------------------------------------

return Router
