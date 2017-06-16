local system = {
  getInfo = function (info)
    if(info == 'platformName') then
      return 'Android'
    elseif(info == 'environment') then
      return 'simulator'
    end
  end,
  pathForFile = function (name, folder)
    return 'plop'
  end
}

return system
