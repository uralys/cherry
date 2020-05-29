------------------------------------------------------------------

local time = require 'cherry.libs.time'

------------------------------------------------------------------
-- https://stackoverflow.com/a/12646864
-- Randomize array in-place using Durstenfeld shuffle algorithm
------------------------------------------------------------------
-- this function mutates the array
------------------------------------------------------------------

local function shuffleArray(array)
  local seed = time.getTimeMs()
  math.randomseed(seed)

  for i = #array, 1, -1 do
    local j = math.floor(math.random() * i) + 1
    print(i, j)
    local temp = array[i]
    array[i] = array[j]
    array[j] = temp
  end
end

------------------------------------------------------------------

return shuffleArray
