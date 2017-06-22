local lfs = require 'lfs'

local file = {
  loadUserData = function() return nil end,
  load = function(path) return nil end,
  save = function(path) return true end,
  exists = function(path)
    local _path = string.gsub(path, 'Cherry/', '/')
    local f = lfs.currentdir() .. _path
    local attr = lfs.attributes(f)
    return attr ~= nil
  end,
}

return file
