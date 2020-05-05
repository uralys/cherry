local notifications = require('plugin.notifications.v2')

-- doc https://docs.coronalabs.com/plugin/notifications-v2/scheduleNotification.html

local function deviceNotification(text, secondsFromNow, id)
  _G.log(
    '📱  deviceNotification : [' ..
      id .. '] --> ' .. text .. ' (' .. secondsFromNow .. ')'
  )

  local options = {
    alert = text,
    badge = 1
  }

  if (App.deviceNotifications[id]) then
    _G.log('📱 cancelling device notification : ', App.deviceNotifications[id])
    notifications.cancelNotification(App.deviceNotifications[id])
  end

  App.deviceNotifications[id] =
    notifications.scheduleNotification(secondsFromNow, options)

  _G.log('📱  device notification scheduled: ', id, secondsFromNow)
end

--------------------------------------------------------------------------------

return deviceNotification
