local system = {
  pathForFile = function(name, folder)
    return './' .. name
  end,
  getTimer = function()
    return '1234'
  end
}

system.switchPlatform = function(platform)
  system.getInfo = function(info)
    if (info == 'platformName') then
      return platform
    elseif (info == 'environment') then
      return 'simulator'
    end
  end
end

system.switchPlatform('Android')

return system
