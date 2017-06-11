_G.tprint = function (tbl, indent, options)
    if not tbl then print("Table nil") return end
    if not options then options = {} end

    if type(tbl) ~= "table" then
        print(tostring(tbl))
    else
        if not indent then indent = 1 end
        for k, v in pairs(tbl) do
            local formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                print(formatting)
                if(indent < 6) then
                    _G.tprint(v, indent+1, options)
                end
            else
                print(formatting .. tostring(v))
            end
        end
    end
end
