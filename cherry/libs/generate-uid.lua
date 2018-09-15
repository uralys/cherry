local function generateUID()
  return os.time() .. '-'
    .. math.floor(system.getTimer()) .. '-'
    .. math.random(100000, 900000)
end

return generateUID
