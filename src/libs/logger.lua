local unpack = table.unpack or unpack

_G.log = _G.log or function(stuff, ...)
  local args = {...}
  if(type(stuff) == 'table') then
    local inspect = require 'inspect'
    print(inspect(stuff, unpack(args)))
  else
    print(stuff, unpack(args))
  end
end
