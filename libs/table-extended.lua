--------------------------------------------------------------------------------

local Table = {}

-- joinTables join
-- removeFromTable removeObject
-- emptyTable empty

--------------------------------------------------------------------------------

function Table.join(t1, t2)

    local result = {}
    if(t1 == nil) then t1 = {} end
    if(t2 == nil) then t2 = {} end

    for k,v in pairs(t1) do
        result[k] = v
    end

    for k,v in pairs(t2) do
        result[k] = v
    end

    return result
end

--------------------------------------------------------------------------------

function Table.removeObject(t, object)
    local index = 1
    for k,_ in pairs(t) do
        if(t[k] == object) then
            break
        end

        index = index + 1
    end

    table.remove(t, index)
end

function Table.empty(t)
    if(not t) then return end
    local i, _ = next(t, nil)
    while i do
        t[i] = nil
        i, _ = next(t, i)
    end
end

function Table.contains(t, object)
    if(not t) then return end
    for _,v in pairs(t) do
        if(v == object) then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------

return Table
