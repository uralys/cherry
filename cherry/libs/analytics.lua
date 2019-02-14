--------------------------------------------------------------------------------

local http = _G.http or require 'cherry.libs.http'

local ANALYTICS_URL = "http://www.google-analytics.com/collect"
local params

--------------------------------------------------------------------------------

local function init(version, trackingId, deviceId, gameName, gameVersion)
  params = {
    version     = version,
    trackingId  = trackingId,
    clientId    = deviceId,
    gameName    = gameName,
    gameVersion = gameVersion
  }
end

--------------------------------------------------------------------------------

local function pageview(page)
  local data = ""
  data = data .. "v="     .. params.version
  data = data .. "&tid="  .. params.trackingId
  data = data .. "&cid="  .. params.clientId
  data = data .. "&t="    .. "Appview"
  data = data .. "&an="   .. params.gameName
  data = data .. "&av="   .. params.gameVersion
  data = data .. "&cd="   .. page

  http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

local function event(category, action, label)
  local data = ""
  data = data .. "v="     .. params.version
  data = data .. "&tid="  .. params.trackingId
  data = data .. "&cid="  .. params.clientId
  data = data .. "&t="    .. "event"
  data = data .. "&an="   .. params.gameName
  data = data .. "&ec="   .. category
  data = data .. "&ea="   .. action

  if(label) then
    data = data .. "&el="  .. label
  end

  http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

return {
  init      = init,
  pageview  = pageview,
  event     = event,
  getParams = function() return params end
}
