local notifications = _G.notifications or require('plugin.notifications.v2')

-- doc https://docs.coronalabs.com/plugin/notifications-v2/scheduleNotification.html

local function deviceNotification(text, secondsFromNow, id)
  local options = {
    alert = text,
    badge = 1
  }

  -- if (App.deviceNotifications[id]) then
  --   _G.log('📱❌ cancelling device notification : ', App.deviceNotifications[id])
  --   notifications.cancelNotification(App.deviceNotifications[id])
  -- end

  App.deviceNotifications[id] =
    notifications.scheduleNotification(secondsFromNow, options)

  _G.log(
    '📱  device notification scheduled: ',
    id,
    App.deviceNotifications[id],
    secondsFromNow,
    text
  )
end

--------------------------------------------------------------------------------

return deviceNotification
