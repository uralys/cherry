local function isDisplayObjectsArray (objects)
  local isNotDisplayObject = objects._class == nil
  local isTable = type(objects) == 'table'
  local result = isNotDisplayObject and isTable
  return result
end

return isDisplayObjectsArray
