--------------------------------------------------------------------------------

local animation = {}

--------------------------------------------------------

function animation.rotateBackAndForth(object, angle, time)

    local initialRotation = object.rotation

    local back = function()
        transition.to(object, {
            rotation   = initialRotation,
            onComplete = animation.rotateBackAndForth(object, -angle, time),
            time       = time
        })
    end

    transition.to(object, {
        rotation   = angle,
        onComplete = back,
        time       = time
    })
end

--------------------------------------------------------

function animation.easeDisplay(object, scale)
    local scaleTo = scale or 1
    object.xScale = 0.2
    object.yScale = 0.2

    return transition.to( object, {
        xScale = scaleTo,
        yScale = scaleTo,
        time = 350,
        transition = easing.outCubic
    })
end

function animation.bounce(object, scale)
    local scaleTo = scale or 1

    object.xScale = 0.01
    object.yScale = 0.01
    timer.performWithDelay(math.random(120, 330), function()
        transition.to( object, {
            xScale = scaleTo,
            yScale = scaleTo,
            time = 750,
            transition = easing.outBounce
        })
    end)
end

function animation.grow(object, fromScale, time, onComplete)
    object.xScale = fromScale or 0.6
    object.yScale = fromScale or 0.6

    transition.to( object, {
        xScale = 1,
        yScale = 1,
        time = time or 350,
        onComplete = onComplete
    })
end

function animation.easeHide(object, next, time)
    transition.to( object, {
        xScale = 0.01,
        yScale = 0.01,
        time = time or 450,
        transition = easing.inCubic,
        onComplete = function()
            if(next) then
                next()
            end
        end
    })
end

function animation.fadeIn(object)
    object.alpha = 0

    transition.to( object, {
        alpha = 1,
        time = 750
    })
end

--------------------------------------------------------------------------------

return animation
