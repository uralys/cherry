--------------------------------------------------------------------------------

local gesture = {}

--------------------------------------------------------------------------------

function gesture.onTouch(object, action)
    if(object.removeOnTouch) then object.removeOnTouch() end

    local touch = function(event)
        if(event.phase == 'began') then
            object.alpha = 0.8
            -- display.getCurrentStage():setFocus( object )
        elseif event.phase == 'ended' or event.phase == 'cancelled' then
            object.alpha = 1
            -- display.getCurrentStage():setFocus( nil )
            action()
        end
        return true
    end

    object:addEventListener ('touch', touch)

    object.removeOnTouch = function()
        object:removeEventListener ('touch', touch)
    end
end

function gesture.onceTouch(object, action)
    gesture.onTouch(object, function()
        action()
        object.removeOnTouch()
    end)
end

--------------------------------------------------------------------------------

function gesture.onTap(object, action)
    if(object.removeOnTap) then object.removeOnTap() end

    local tap = function(event)
        if(event.phase == 'began') then
            -- display.getCurrentStage():setFocus( object )
            return action()
        -- elseif event.phase == 'ended' or event.phase == 'cancelled' then
            -- display.getCurrentStage():setFocus( nil )
        end
        return false
    end

    object:addEventListener ('touch', tap)

    object.removeOnTap = function()
        object:removeEventListener ('touch', tap)
    end
end

function gesture.onceTap(object, action)
    gesture.onTap(object, function()
        action()
        object.removeOnTap()
    end)
end

--------------------------------------------------------------------------------

function gesture.disabledTouch(object)
    gesture.onTap(object, function ()
        return true
    end)
end

--------------------------------------------------------------------------------

return gesture
