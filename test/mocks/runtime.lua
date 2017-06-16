local eventListeners = {}

local Runtime = {
  addEventListener = function(self, name, callback)
    if not eventListeners[name] then eventListeners[name] = {} end
    table.insert(eventListeners[name], callback)
  end,
  removeEventListener = function(self, name, callback)
    assert(eventListeners[name], "no such event name: " .. tostring(name))
    for i = #eventListeners[name], 1, -1 do
      if eventListeners[name][i] == callback then
        table.remove(eventListeners[name], i)
      end
    end
  end,
  dispatchEvent = function(self, event)
    assert(event.name, "event name not provided")
    local listener = eventListeners[event.name]
    if not listener or #listener == 0 then return end

    for i = 1, #listener do
      listener[i](event)
    end
  end
}

return Runtime
