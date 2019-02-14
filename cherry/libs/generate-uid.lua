local function generateUID()
  math.randomseed(os.time() * os.time())

  return os.time() .. '-'
    .. math.floor(system.getTimer()) .. '-'
    .. math.random(100000, 900000)
end

return generateUID
