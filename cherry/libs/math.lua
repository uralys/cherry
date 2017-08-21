
-- Round to the nearest interger
function math.round( num, idp )
  local mult = 10 ^ ( idp or 0 )
  return math.floor( num * mult + 0.5 ) / mult
end

function math.isInt(n)
  return n==math.floor(n)
end

--- http://developer.coronalabs.com/code/maths-library
-- returns the distance between points a and b
function math.distanceBetween( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
    -- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end
