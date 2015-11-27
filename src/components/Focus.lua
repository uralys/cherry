
--------------------------------------------------------

function horizontalBackAndForth(object, options)
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

function verticalBackAndForth(object, options)

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
        bottom = false,
        right  = false,
        left   = false,
        bounce = true
    })

    -----------------

    local parent = object.parent or options.parent
    local focus = display.newGroup()
    focus.x = object.x
    focus.y = object.y
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

        local up = display.newImage(focus, 'assets/images/gui/items/arrow.right.png')
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
    end

    -----------------

    if(options.all or options.left) then
        local leftY = -object.width / 2 - 20
        local left = display.newImage(focus, 'assets/images/gui/items/arrow.right.png')
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
    end

    -----------------

    if(options.all or options.bottom) then
        local bottomY = object.height / 2 + 20
        local bottom = display.newImage(focus, 'assets/images/gui/items/arrow.right.png')
        bottom.x = 0
        bottom.y = bottomY
        bottom:scale(0.5, 0.5)

        if(options.type == 'show-center') then
            bottom.rotation = -90
        elseif(options.type == 'from-center') then
            bottom.rotation = 90
        end

        if(options.bounce) then
            verticalBackAndForth(bottom, {
                to = bottomY + 10,
                repeatAction = focusOnTop
            })
        end
    end

    -----------------

    if(options.all or options.right) then
        local rightX = object.width / 2 + 20
        local right = display.newImage(focus, 'assets/images/gui/items/arrow.right.png')
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
    end

    -----------------

    if(utils and utils.onTap) then
        utils.onTap(focus, function ()
            if(utils and utils.destroyFromDisplay) then
                utils.destroyFromDisplay(focus, true)
            else
                display.remove(focus)
            end

            -- enable propagation
            return false
        end)
    end

    -----------------

    return focus
end
