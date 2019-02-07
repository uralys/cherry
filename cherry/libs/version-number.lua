require 'cherry.libs.string'

local function toVersionNumber(semver)
  if(not semver) then return 0 end
  if(type(semver) ~= 'string') then return 0 end

  local splinters = semver:split('%.')
  local code = ''
  for i = 1, 3 do
    local splinter = splinters[i]
    if(not splinter ) then
      splinter = '00'
    end

    if(#splinter == 1) then
      splinter = '0' .. splinter
    end

    code = code .. splinter
  end

  local number = tonumber(code) or 0
  return number
end

return toVersionNumber
