-- note: delimiter is a regex, to split by '.' use '%.' for instance
function string:split(delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = self:find(delimiter, from)
  while delim_from do
    table.insert(result, self:sub(from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = self:find(delimiter, from)
  end
  table.insert(result, self:sub(from))
  return result
end

function string:trim()
  return self:match '^%s*(.-)%s*$'
end

function string:maxLength(nbChars)
  local part = self:sub(1, nbChars)
  if (#part < #self) then
    return part .. '...'
  else
    return self
  end
end
