local _to = function(object, properties)
  for k, v in pairs(properties) do
    object[k] = v
  end
  if (object.onComplete) then
    object.onCompleteCounts = (object.onCompleteCounts or 0) - 1
    if (object.onCompleteCounts >= 0) then
      object.onComplete()
    end
  end

  return '__animation__'
end

local _from = function(object, properties)
  local toReach = {}
  for k, v in pairs(properties) do
    toReach[k] = object[k]
    object[k] = v
  end

  _to(object, toReach)

  return '__animation__'
end

return {
  from = _from,
  to = _to,
  cancel = function(animation)
  end
}
