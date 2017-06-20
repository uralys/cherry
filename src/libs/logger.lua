_G.log = _G.log or function(stuff, ...)
  local args = {...}
  if(type(stuff) == 'table') then
    local inspect = require 'inspect'
    print(inspect(stuff, _G.unpack(args)))
  else
    print(stuff, _G.unpack(args))
  end
end
