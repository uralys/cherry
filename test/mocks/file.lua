local lfs = require 'lfs'

local file = {
  loadUserData = function() return nil end,
  load = function(path)
    if (path == 'env/development.json') then
      return {
        silent = true,
        invincible = true,
        ['view-testing'] = 'playground'
      }
    end
    if (path == 'env/production.json') then
      return {
          silent = false,
          editor = false,
          ['level-testing'] = false
      }
    end
  end,
  save = function(path) return true end,
  exists = function(path)
    local f = lfs.currentdir() .. '/' .. path
    local attr = lfs.attributes(f)
    return attr ~= nil
  end,
}

return file
