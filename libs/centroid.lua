local reduce = require('src.ludash').reduce

function centroid (points)
  local l = #points

  return reduce(points, function (center, p, i)
    center.x = center.x + p.x
    center.y = center.y + p.y

    if (i == l) then
        center.x = center.x / l
        center.y = center.y / l
    end

    return center;
  end, {x = 0, y = 0})
end

return centroid
