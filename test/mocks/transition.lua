return {
  to = function (object, properties)
    for k,v in pairs(properties) do
      object[k] = v
    end
  end
}
