_G.tprint = function (tbl, depth, loop)
    if depth == nil then depth = 10 end
    if loop == nil then loop = 1 end
    if not tbl then print("Table nil") return end

    if type(tbl) ~= "table" then
        print(tostring(tbl))
    else
        for k, v in pairs(tbl) do
            local formatting = string.rep("  ", loop) .. k
            if type(v) == "table" then
                print(formatting)
                if(depth > 1) then
                    _G.tprint(v, depth - 1, loop + 1)
                end
            else
                print(formatting .. ': ' .. tostring(v))
            end
        end
    end
end
