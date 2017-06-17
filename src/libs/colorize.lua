return function (hexCode)
    return tonumber('0x'..hexCode:sub(1,2))/255,
           tonumber('0x'..hexCode:sub(3,4))/255,
           tonumber('0x'..hexCode:sub(5,6))/255;
end
