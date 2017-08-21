--------------------------------------------------------------------------------
---
-- Picked up Underscore tools from :
-- https://github.com/mirven/underscore.lua/blob/master/lib/underscore.lua
--
-- Applied some modifications for Uralys
--
--------------------------------------------------------------------------------

local Underscore = {}

--------------------------------------------------------------------------------

---
-- http://underscorejs.org/#extend
--
-- Copy all of the properties in the source objects over
-- to the destination object, and return the destination object.
--
-- It's in-order, so the last source will override properties
-- of the same name in previous arguments.
--
function Underscore.extend (destination, source)
    if(source == nil) then
        return destination
    end

    for k,v in pairs(source) do
        destination[k] = v
    end
    return destination
end

---
-- http://underscorejs.org/#defaults
--
-- Fill in undefined properties in object with the first
-- value present in the following list of defaults objects.
--
function Underscore.defaults (object, default)
    for k,v in pairs(default) do
        if(object[k] == nil) then
            object[k] = v
        end
    end
    return object
end

-------------------------------------

return Underscore
