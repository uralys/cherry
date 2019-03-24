local unpack = table.unpack or unpack

_G.log = _G.log or function(stuff, ...)
    local args = {...}
    local prefix = ''
    if (App.name) then
      prefix = '[' .. App.name .. ']'
    end

    if (type(stuff) == 'table') then
      local inspect = require 'cherry.libs.inspect'
      print(prefix, inspect(stuff, unpack(args)))
    else
      print(prefix, stuff, unpack(args))
    end
  end
