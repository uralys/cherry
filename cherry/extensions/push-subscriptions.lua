local attachPushSubscriptions = function(pushSubscriptions)
  if (not pushSubscriptions) then
    _G.log('> no pushSubscriptions.')
    return
  end

  ------------------

  if (_G.SIMULATOR) then
    _G.log('[🖥  SIMULATOR] no pushSubscriptions.')
    for _, topic in pairs(pushSubscriptions) do
      _G.log('  ✅ found topic ' .. topic)
    end
    return
  end

  ------------------

  _G.log('  Setting up FCM:')
  local notifications = require('plugin.notifications.v2')
  _G.log('    Closed previous notifications.')
  notifications.cancelNotification()
  _G.log('    Registering to notifications...')
  notifications.registerForPushNotifications({useFCM = true})

  for _, topic in pairs(pushSubscriptions) do
    notifications.subscribe(topic)
    _G.log('    ✅ Subscribed to topic ' .. topic)
  end
end

return attachPushSubscriptions
