--------------------------------------------------------------------------------

local TouchController = {}

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function TouchController:stopPropagation (object)
    object:addEventListener( 'touch', function(event)
        return true
    end)
end

function TouchController:addDrag(object, options)
    options = options or {}

    local onEvent = function(event)
        drag(object, event, options)
        return true
    end

    object:addEventListener( 'touch', onEvent )

    object.removeDrag = function()
        object:removeEventListener( 'touch', onEvent )
    end
end

function TouchController:addTap (listener, action)
    listener:addEventListener( 'touch', function(event)
        tap(event, action)
    end)
end

--------------------------------------------------------------------------------

function drag (o, event, options)
    if event.phase == 'began' then
        if(not options.child) then
            display.getCurrentStage():setFocus( o )
        end
        o.markX  = o.x
        o.markY  = o.y
        o.startX = o.x
        o.startY = o.y

    elseif event.phase == 'moved' then
        if(not o.startX) then return end
        if(not o.markX) then o.markX = o.x end
        if(not o.markY) then o.markY = o.y end

        o.x = (event.x - event.xStart) + o.markX
        o.y = (event.y - event.yStart) + o.markY

        if(not o.moving and options.onDragStart) then
            options.onDragStart()
        end

        o.moving = true

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus( nil )
        o.moving = false
        o.endX   = o.x
        o.endY   = o.y

        local sameObjectFromStartToEnd = o.startX ~= nil
        local hasMoved = (o.endX ~= o.startX) or (o.endY ~= o.startY)

        if(sameObjectFromStartToEnd and hasMoved and options.onDrop) then
            options.onDrop(event)
        end

    end

    if(o.children) then
        for k,child in pairs(o.children) do
            drag(child, event, {
                child = true
            })
        end
    end

end

--------------------------------------------------------------------------------

function tap (event, action)

    if event.phase == 'began' then
        event.target.startTap = system.getTimer()

    elseif (event.phase == 'ended' or event.phase == 'cancelled') then
        if(system.getTimer() - event.target.startTap < 100) then
            action(event)
        end
    end

end

--------------------------------------------------------------------------------

return TouchController
