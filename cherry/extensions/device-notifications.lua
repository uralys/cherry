local function deviceNotification(text, secondsFromNow, id)
  _G.log(
    '----> deviceNotification : [' ..
      id .. '] --> ' .. text .. ' (' .. secondsFromNow .. ')'
  )

  local options = {
    alert = text,
    badge = 1
  }

  if (App.deviceNotifications[id]) then
    _G.log('cancelling device notification : ', App.deviceNotifications[id])
    system.cancelNotification(App.deviceNotifications[id])
  end

  _G.log('scheduling : ', id, secondsFromNow)
  App.deviceNotifications[id] =
    system.scheduleNotification(secondsFromNow, options)

  _G.log('scheduled : ', App.deviceNotifications[id])
end

--------------------------------------------------------------------------------

return deviceNotification
