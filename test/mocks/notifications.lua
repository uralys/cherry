local notifications = {
  cancelNotification = function(text, secondsFromNow, id)
    return true
  end,
  scheduleNotification = function(secondsFromNow, options)
    return 'scheduled.' .. options.alert
  end
}

return notifications
