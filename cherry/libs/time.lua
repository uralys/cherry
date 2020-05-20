--------------------------------------------------------------------------------

local socket = require 'socket'

--------------------------------------------------------------------------------

local function getTimeMs()
  local plop = '' .. socket.gettime() * 1000
  return tonumber(plop:split('%.')[1])
end

local function getMinSec(seconds)
  local min = math.floor(seconds / 60)
  local sec = seconds - min * 60

  if (sec < 10) then
    sec = '0' .. sec
  end

  return tostring(min), tostring(sec)
end

local function getMinSecMillis(millis)
  local min = math.floor(millis / 60000)
  local sec = math.floor((millis - min * 60 * 1000) / 1000)
  local ms = math.floor(millis - min * 60 * 1000 - sec * 1000)

  if (sec < 10) then
    sec = '0' .. sec
  end

  if (ms < 10) then
    ms = '00' .. ms
  elseif (ms < 100) then
    ms = '0' .. ms
  end

  return tostring(min), tostring(sec), tostring(ms)
end

--------------------------------------------------------------------------------

return {
  getTimeMs = getTimeMs,
  getMinSec = getMinSec,
  getMinSecMillis = getMinSecMillis
}
