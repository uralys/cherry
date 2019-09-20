return {
  to = function(object, properties)
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
  end,
  cancel = function(animation)
  end
}
