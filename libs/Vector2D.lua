local Vector2D = {}

function Vector2D:new(x, y)
  local object = { x = x, y = y }
  setmetatable(object, { __index = Vector2D })
  return object
end

function Vector2D:copy()
    return Vector2D:new(self.x, self.y)
end

function Vector2D:magnitude()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector2D:normalize()
    local temp
    temp = self:magnitude()
    if temp > 0 then
        self.x = self.x / temp
        self.y = self.y / temp
    end
end

function Vector2D:limit(l)
    if self.x > l then
        self.x = l
    end

    if self.y > l then
        self.y = l
    end
end

function Vector2D:equals(vec)
    if self.x == vec.x and self.y == vec.y then
        return true
    else
        return false
    end
end

function Vector2D:add(vec)
    self.x = self.x + vec.x
    self.y = self.y + vec.y
end

function Vector2D:sub(vec)
    self.x = self.x - vec.x
    self.y = self.y - vec.y
end

function Vector2D:mult(s)
    self.x = self.x * s
    self.y = self.y * s
end

function Vector2D:div(s)
    self.x = self.x / s
    self.y = self.y / s
end

function Vector2D:dot(vec)
    return self.x * vec.x + self.y * vec.y
end

function Vector2D:dist(vec2)
    return math.sqrt( (vec2.x - self.x) + (vec2.y - self.y) )
end

function Vector2D:rotate(alpha)
    self.x = self.x * math.cos(alpha) + self.y * math.sin(alpha)
    self.y = - self.x * math.sin(alpha) + self.y * math.cos(alpha)
end

-- Class Methods

function Vector2D:Normalize(vec)
    local tempVec = Vector2D:new(vec.x,vec.y)
    local temp
    temp = tempVec:magnitude()
    if temp > 0 then
        tempVec.x = tempVec.x / temp
        tempVec.y = tempVec.y / temp
    end

    return tempVec
end

function Vector2D:Limit(vec,l)
    local tempVec = Vector2D:new(vec.x,vec.y)

    if tempVec.x > l then
        tempVec.x = l
    end

    if tempVec.y > l then
        tempVec.y = l
    end

    return tempVec
end

function Vector2D:Add(vec1, vec2)
    local vec = Vector2D:new(0,0)
    vec.x = vec1.x + vec2.x
    vec.y = vec1.y + vec2.y
    return vec
end

function Vector2D:Average(vec1, vec2)
    local vec = Vector2D:new(0,0)
    vec.x = (vec1.x + vec2.x)/2
    vec.y = (vec1.y + vec2.y)/2
    return vec
end

function Vector2D:Sub(vec1, vec2)
    local vec = Vector2D:new(0,0)
    vec.x = vec1.x - vec2.x
    vec.y = vec1.y - vec2.y

    return vec
end

function Vector2D:Mult(vec, s)
    local tempVec = Vector2D:new(0,0)
    tempVec.x = vec.x * s
    tempVec.y = vec.y * s

    return tempVec
end

function Vector2D:Div(vec, s)
    local tempVec = Vector2D:new(0,0)
    tempVec.x = vec.x / s
    tempVec.y = vec.y / s

    return tempVec
end

function Vector2D:Perpendicular(vec)
    local tempVec = Vector2D:new(0,0)
    tempVec.x = vec.y
    tempVec.y = -vec.x

    return tempVec
end

function Vector2D:Dist(vec1, vec2)
    return math.sqrt( math.abs(vec2.x - vec1.x) + math.abs(vec2.y - vec1.y) )
end

return Vector2D
