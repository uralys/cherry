--------------------------------------------------------------------------------

local http = require 'http'

local ANALYTICS_URL = "http://www.google-analytics.com/collect"

--------------------------------------------------------------------------------

local function init(version, trackingId, profileId, AppName, AppVersion)
    _G.analyticsParams = {
        version    = version,
        trackingId = trackingId,
        profileId  = profileId,
        AppName    = AppName,
        AppVersion = AppVersion
    }
end

--------------------------------------------------------------------------------

local function pageview(page)
    local data = ""
    data = data .. "v="     .. _G.analyticsParams.version
    data = data .. "&tid="  .. _G.analyticsParams.trackingId
    data = data .. "&cid="  .. _G.analyticsParams.profileId
    data = data .. "&t="    .. "Appview"
    data = data .. "&an="   .. _G.analyticsParams.AppName
    data = data .. "&av="   .. _G.analyticsParams.AppVersion
    data = data .. "&cd="   .. page

    http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

local function event(category, action, label)
    local data = ""
    data = data .. "v="     .. _G.analyticsParams.version
    data = data .. "&tid="  .. _G.analyticsParams.trackingId
    data = data .. "&cid="  .. _G.analyticsParams.profileId

    data = data .. "&t="    .. "event"
    data = data .. "&an="   .. _G.analyticsParams.AppName

    data = data .. "&ec="   .. category
    data = data .. "&ea="   .. action

    if(label) then
        data = data .. "&el="  .. label
    end

    http.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

--------------------------------------------------------------------------------

return {
    init = init,
    pageview = pageview,
    event = event
}
