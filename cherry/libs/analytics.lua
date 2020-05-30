--------------------------------------------------------------------------------
-- https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
--------------------------------------------------------------------------------

local http = _G.http or require 'cherry.libs.http'
local ANALYTICS_URL = 'http://www.google-analytics.com/collect'
local params = nil

--------------------------------------------------------------------------------

local function init(trackingId, deviceId, gameName, gameVersion)
  params = {
    trackingId = trackingId,
    clientId = deviceId,
    gameName = gameName,
    gameVersion = gameVersion
  }
end

--------------------------------------------------------------------------------

local function screenview(page)
  if (_G.SIMULATOR or App.ENV == 'development' or params == nil) then
    return
  end

  local data = 'v=1'
  data = data .. '&tid=' .. params.trackingId
  data = data .. '&cid=' .. params.clientId
  data = data .. '&t=' .. 'screenview'
  data = data .. '&an=' .. params.gameName
  data = data .. '&av=' .. params.gameVersion
  data = data .. '&cd=' .. page

  http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

local function event(category, action, label)
  if (_G.SIMULATOR or App.ENV == 'development' or params == nil) then
    return
  end

  local data = 'v=1'
  data = data .. '&tid=' .. params.trackingId
  data = data .. '&cid=' .. params.clientId
  data = data .. '&t=' .. 'event'
  data = data .. '&an=' .. params.gameName
  data = data .. '&av=' .. params.gameVersion
  data = data .. '&ec=' .. category
  data = data .. '&ea=' .. action

  if (label) then
    data = data .. '&el=' .. label
  end

  http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

return {
  init = init,
  screenview = screenview,
  event = event,
  getParams = function()
    return params
  end
}
