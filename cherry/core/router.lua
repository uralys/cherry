--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local analytics = require 'cherry.libs.analytics'
local group = require 'cherry.libs.group'
local Screen = require 'cherry.components.screen'
local Effects = require 'cherry.engine.effects'

--------------------------------------------------------------------------------

local Router = {
  view = nil
}

--------------------------------------------------------------------------------

function Router:resetScreen()
  Effects:stop(true)
  group.empty(App.hud)
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
  _G.log('[Router] ---> ' .. Router.view)

  _G.composer.gotoScene(class, options)
end

--------------------------------------------------------------------------------

function Router:open(id, params)
  local class

  if (table.contains(App.screens, id)) then
    class = 'src.screens.' .. id
  else
    class = 'cherry.screens.' .. id
  end

  self:openScreen(id, class, params)
end

--------------------------------------------------------------------------------

return Router
