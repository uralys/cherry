--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local animation = {}

--------------------------------------------------------

function animation.rotateBackAndForth(object, angle, time)
    local initialRotation = object.rotation

    local back = function()
        transition.to(object, {
            rotation   = initialRotation,
            onComplete = function() animation.rotateBackAndForth(object, -angle, time) end,
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

function animation.scaleBackAndForth(object, options)
    options = options or {}
    local initialScale = object.xScale
    local scaleGrow = options.scale or 1.5

    local back = function()
        animation.bounce(object, _.extend({
            time       = options.time or 500,
            scaleFrom  = scaleGrow,
            scaleTo    = initialScale,
            transition = easing.outBounce,
            noDelay    = true,
            onComplete = function ()
                if(options.loop) then
                    animation.scaleBackAndForth(object, options)
                end
            end
        }, options))
    end

    animation.bounce(object, _.extend({
        time       = options.time or 500,
        scaleFrom  = initialScale,
        scaleTo    = scaleGrow,
        transition = easing.outSine,
        onComplete = back,
        noDelay    = true
    }, options))
end

--------------------------------------------------------

function animation.easeDisplay(object, scale)
    local scaleTo = scale or object.xScale or 1
    object.xScale = 0.2
    object.yScale = 0.2

    return transition.to( object, {
        xScale = scaleTo,
        yScale = scaleTo,
        time = 350,
        transition = easing.outCubic
    })
end

function animation.bounce(object, options)
    options = options or {}
    local scaleTo = options.scaleTo or 1
    local scaleFrom = options.scaleFrom or 0.01

    object.xScale = scaleFrom
    object.yScale = scaleFrom

    local doBounce = function()
        transition.to( object, {
            xScale     = scaleTo,
            yScale     = scaleTo,
            time       = options. time or 750,
            transition = options.transition or easing.outBounce,
            onComplete = options.onComplete
        })
    end

    if(options.noDelay) then
        doBounce()
    else
        timer.performWithDelay(math.random(120, 330), doBounce)
    end
end

function animation.grow(object, fromScale, time, onComplete)
    object.xScale = fromScale or 0.6
    object.yScale = fromScale or 0.6

    transition.to( object, {
        xScale = 1,
        yScale = 1,
        time = time or 150,
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

function animation.flash()
  local flash = display.newRect(
      display.contentWidth/2,
      display.contentHeight/2,
      display.contentWidth,
      display.contentHeight
  )

  flash:setFillColor(1)

  transition.to(flash, {
    time = 300,
    alpha = 0,
    onComplete = function ()
        display.remove(flash)
    end
  })
end

--------------------------------------------------------------------------------

function animation.rotate(o, options)
    options = options or {}

    if(o.rotateAnimation) then
        transition.cancel(o.rotateAnimation)
    end

    local rotateTime = options.rotateTime or 3000
    local speed = options.speed or 1

    local clock = 1
    if(options.counterClockwise) then clock = -1 end

    local toRotation = o.rotation + 360 * clock * speed

    o.rotateAnimation = transition.to(o, {
        rotation = toRotation,
        time = rotateTime,
        onComplete = function()
            if(not options.onlyOnce) then
                animation.rotate(o, options)
            end
        end
    })
end

--------------------------------------------------------------------------------

return animation
