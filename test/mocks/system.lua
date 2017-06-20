local system = {
  pathForFile = function (name, folder)
    return './' .. name
  end,
  scheduleNotification = function (secondsFromNow, options)
    return 'scheduled.'.. options.alert
  end,
  cancelNotification = function (id)
    return true
  end
}

system.switchPlatform = function(platform)
  system.getInfo = function (info)
    if(info == 'platformName') then
      return platform
    elseif(info == 'environment') then
      return 'simulator'
    end
  end
end

system.switchPlatform('Android')

return system
