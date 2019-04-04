--------------------------------------------------------------------------------
-- https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
--------------------------------------------------------------------------------

local http = _G.http or require 'cherry.libs.http'

local ANALYTICS_URL = 'http://www.google-analytics.com/collect'
local params

--------------------------------------------------------------------------------

local function init(version, trackingId, deviceId, gameName, gameVersion)
  params = {
    version = version,
    trackingId = trackingId,
    clientId = deviceId,
    gameName = gameName,
    gameVersion = gameVersion
  }
end

--------------------------------------------------------------------------------

local function screenview(page)
  if (_G.SIMULATOR or App.ENV == 'development') then
    _G.log('analytics skipped.')
    _G.log(
      {
        page
      }
    )
    return
  end

  -- http://www.google-analytics.com/collect?an=Coorpacademy&av=1.1.13&cid=119999&ea=testA&ec=testC&el=testL&ev=testEV&ni=0&t=event&tid=UA-49366530-56&uid=123456
  -- http://www.google-analytics.com/collect?v=1&cid=119999&ea=testA&ec=testC&t=event&tid=UA-49366530-56

  -- http://www.google-analytics.com/collect?an=Coorpacademy&av=1.1.13&v=1&cid=119999&ea=testOK2&ec=testC&t=event&tid=UA-49366530-56&el=testL&uid=3456789

  local data = ''
  data = data .. 'v=' .. params.version
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
  if (_G.SIMULATOR or App.ENV == 'development') then
    _G.log('analytics skipped.')
    _G.log(
      {
        category,
        action,
        label
      }
    )
    return
  end

  local data = ''
  data = data .. 'v=' .. params.version
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
