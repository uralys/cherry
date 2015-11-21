----------------------------------------------------------------------------------------------------

module(..., package.seeall)

----------------------------------------------------------------------------------------------------

ANALYTICS_URL = "http://www.google-analytics.com/collect"

----------------------------------------------------------------------------------------------------

params = {}

----------------------------------------------------------------------------------------------------

function init(version, trackingId, profileId, AppName, AppVersion)
    params.version   = version
    params.trackingId  = trackingId
    params.profileId   = profileId

    params.AppName   = AppName
    params.AppVersion  = AppVersion
end

----------------------------------------------------------------------------------------------------

function pageview(page)
    local data = ""
    data = data .. "v="     .. params.version
    data = data .. "&tid="  .. params.trackingId
    data = data .. "&cid="  .. params.profileId
    data = data .. "&t="    .. "Appview"
    data = data .. "&an="   .. params.AppName
    data = data .. "&av="   .. params.AppVersion
    data = data .. "&cd="   .. page

    utils.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

----------------------------------------------------------------------------------------------------

function event(category, action, label)
    local data = ""
    data = data .. "v="     .. params.version
    data = data .. "&tid="  .. params.trackingId
    data = data .. "&cid="  .. params.profileId

    data = data .. "&t="    .. "event"
    data = data .. "&an="   .. params.AppName

    data = data .. "&ec="   .. category
    data = data .. "&ea="   .. action

    if(value) then
        data = data .. "&el="  .. value
    end

    utils.post(ANALYTICS_URL, data, nil, 'urlencoded')
end
