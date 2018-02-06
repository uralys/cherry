--------------------------------------------------------------------------------

local animation = require 'cherry.libs.animation'
local Group = {}

-- destroyFromDisplay --> destroy

--------------------------------------------------------------------------------

function Group.empty( group )
    if(group == nil) then return end

    if(#group > 0) then
        for i = #group, 1, -1 do
            group[i]:removeSelf()
            group[i] = nil
        end
    end

    if(group.numChildren ~= nil and group.numChildren > 0) then
        for i=group.numChildren,1,-1 do
            local child = group[i]
            transition.cancel(child)
            display.remove(child)
            group[i] = nil
        end
    end
end

function Group.destroy(object, easeHideEffect)
    local doDestroy = function()
        if(object) then
            Group.empty(object)
            display.remove(object)
            object = nil
        end
    end

    if(easeHideEffect) then
        animation.easeHide(object, doDestroy, 125)
    else
        doDestroy()
    end
end

--------------------------------------------------------------------------------

return Group
