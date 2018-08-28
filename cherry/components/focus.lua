
local _        = require 'cherry.libs.underscore'
local colorize = require 'cherry.libs.colorize'
local group    = require 'cherry.libs.group'
local gesture  = require 'cherry.libs.gesture'

--------------------------------------------------------

local function horizontalBackAndForth(object, options)
    local initialX = object.x

    local back = function()

        if(options.repeatAction) then
            options.repeatAction()
        end

        transition.to(object, {
            x = initialX,
            onComplete = function()
                horizontalBackAndForth(object, options)
            end
        })
    end

    if(options.repeatAction) then
        options.repeatAction()
    end

    transition.to(object, {
        x = options.to,
        onComplete = back
    })
end

--------------------------------------------------------

local function verticalBackAndForth(object, options)

    local initialY = object.y

    local back = function()

        if(options.repeatAction) then
            options.repeatAction()
        end

        transition.to(object, {
            y = initialY,
            onComplete = function()
                verticalBackAndForth(object, options)
            end
        })
    end

    if(options.repeatAction) then
        options.repeatAction()
    end

    transition.to(object, {
        y = options.to,
        onComplete = back
    })
end

--------------------------------------------------------------------------------

return function(object, options)
    if(type(options) == 'boolean') then options = {} end

    options = options or {}
    options = _.defaults(options, {
        type   = 'show-center', -- 'from-center'
        all    = true,
        up     = false,
        down   = false,
        right  = false,
        left   = false,
        bounce = true,

        offsetX = 0,
        offsetY = 0,
        color = nil
    })

    -----------------

    local parent = object.parent or options.parent
    local focus = display.newGroup()
    focus.x = object.x + options.offsetX
    focus.y = object.y + options.offsetY
    parent:insert(focus)

    local focusOnTop = function()
        if(focus and focus.toFront) then
            focus:toFront()
        end
    end

    -----------------

    local radius = options.radius or 100
    local roundToCatchFinger = display.newCircle(focus, 0, 0, radius)
    roundToCatchFinger.alpha = 0.01

    -----------------

    if(options.all or options.up) then
        local upY = -object.height / 2 - 20

        local up = display.newImage(focus, 'cherry/assets/images/gui/items/arrow.right.png')
        up.x = 0
        up.y = upY
        up:scale(0.5, 0.5)

        if(options.type == 'show-center') then
            up.rotation = 90
        elseif(options.type == 'from-center') then
            up.rotation = -90
        end

        if(options.bounce) then
            verticalBackAndForth(up, {
                to = upY - 10,
                repeatAction = focusOnTop
            })
        end

        if(options.color) then
            up:setFillColor(colorize(options.color))
        end
    end

    -----------------

    if(options.all or options.left) then
        local leftY = -object.width / 2 - 20
        local left = display.newImage(focus, 'cherry/assets/images/gui/items/arrow.right.png')
        left.x = leftY
        left.y = 0
        left:scale(0.5, 0.5)

        if(options.type == 'from-center') then
            left.rotation = 180
        end

        if(options.bounce) then
            horizontalBackAndForth(left, {
                to = leftY - 10,
                repeatAction = focusOnTop
            })
        end

        if(options.color) then
            left:setFillColor(colorize(options.color))
        end
    end

    -----------------

    if(options.all or options.down) then
        local downY = object.height / 2 + 20
        local down = display.newImage(focus, 'cherry/assets/images/gui/items/arrow.right.png')
        down.x = 0
        down.y = downY
        down:scale(0.5, 0.5)

        if(options.type == 'show-center') then
            down.rotation = -90
        elseif(options.type == 'from-center') then
            down.rotation = 90
        end

        if(options.bounce) then
            verticalBackAndForth(down, {
                to = downY + 10,
                repeatAction = focusOnTop
            })
        end

        if(options.color) then
            down:setFillColor(colorize(options.color))
        end
    end

    -----------------

    if(options.all or options.right) then
        local rightX = object.width / 2 + 20
        local right = display.newImage(focus, 'cherry/assets/images/gui/items/arrow.right.png')
        right.x = rightX
        right.y = 0
        right:scale(0.5, 0.5)

        if(options.type == 'show-center') then
            right.rotation = 180
        end

        if(options.bounce) then
            horizontalBackAndForth(right, {
                to = rightX + 10,
                repeatAction = focusOnTop
            })
        end

        if(options.color) then
            _G.log('FILL')
            right:setFillColor(colorize(options.color))
        end
    end

    -----------------

    if(options.removeOnTap) then
        gesture.onTap(focus, function ()
            group.destroy(focus, true)
            return false -- enable propagation
        end)
    end

    -----------------

    return focus
end
