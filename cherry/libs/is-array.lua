local function isArray(objects)
  local isNotObject = getmetatable(objects) == nil
  local isTable = type(objects) == 'table'
  local result = isNotObject and isTable
  return result
end

return isArray
