--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local analytics = require 'cherry.libs.analytics'
local Screen = require 'cherry.components.screen'
local Effects = require 'cherry.engine.effects'

--------------------------------------------------------------------------------

local Router = {
  view = nil
}

--------------------------------------------------------------------------------

function Router:resetScreen()
  Effects:stop(true)
  display.remove(App.hud)
  App.hud = display.newGroup()

  Effects:start()
  if (Screen.reset) then
    Screen:reset()
  end
end

--------------------------------------------------------------------------------

function Router:openScreen(id, class, params)
  local options = {
    params = params
  }
  self:resetScreen()
  analytics.screenview(id)

  Router.view = id

  _G.logOneLine({'[Router:openScreen]', id = id, class = class})
  _G.composer.gotoScene(class, options)
end

--------------------------------------------------------------------------------

function Router:open(id, params)
  local class
  local ok =
    pcall(
    function()
      require('src.screens.' .. id)
    end
  )

  if (ok) then
    class = 'src.screens.' .. id
  else
    class = 'cherry.screens.' .. id
  end

  self:openScreen(id, class, params)
end

--------------------------------------------------------------------------------

return Router
