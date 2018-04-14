return function (hexCode)
    return tonumber('0x'..hexCode:sub(2,3))/255,
           tonumber('0x'..hexCode:sub(4,5))/255,
           tonumber('0x'..hexCode:sub(6,7))/255;
end
