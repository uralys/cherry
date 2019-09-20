--------------------------------------------------------------------------------
-- joinTables join
-- removeFromTable removeObject
-- emptyTable empty
--------------------------------------------------------------------------------

function table.join(t1, t2)
  local result = {}
  if (t1 == nil) then
    t1 = {}
  end
  if (t2 == nil) then
    t2 = {}
  end

  for _, v in pairs(t1) do
    result[#result + 1] = v
  end

  for _, v in pairs(t2) do
    result[#result + 1] = v
  end

  return result
end

--------------------------------------------------------------------------------

function table.shift(t)
  local o = t[1]
  table.remove(t, 1)
  return o
end

function table.pop(t)
  local o = t[#t]
  table.remove(t, #t)
  return o
end

function table.removeObject(t, object)
  local index = 1
  for k, _ in pairs(t) do
    if (t[k] == object) then
      break
    end

    index = index + 1
  end

  table.remove(t, index)
end

function table.empty(t)
  if (not t) then
    return
  end
  local i, _ = next(t, nil)
  while i do
    t[i] = nil
    i, _ = next(t, i)
  end
end

function table.contains(t, object)
  if (not t) then
    return
  end
  for _, v in pairs(t) do
    if (v == object) then
      return true
    end
  end
  return false
end

--[[---------------------------------------------------------
https://github.com/Facepunch/garrysmod/lua/includes/extensions/table.lua
Name: table.Count( table )
Desc: Returns the number of keys in a table
-----------------------------------------------------------]]
function table.count(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
  end
  return i
end

function table.simpleEquals(t1, t2)
  for k, v1 in pairs(t1) do
    if (t2[k] ~= v1) then
      return false
    end
  end

  return true
end
