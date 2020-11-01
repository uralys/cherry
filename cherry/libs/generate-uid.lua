local function generateUID(prefix)
  math.randomseed(os.time())
  local _prefix = ''
  if (prefix) then
    _prefix = prefix .. '-'
  end

  return _prefix ..
    os.time() ..
      '-' .. math.floor(system.getTimer()) .. '-' .. math.random(100000, 900000)
end

return generateUID
