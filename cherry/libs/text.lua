--------------------------------------------------------------------------------

local Text = {}

-- displayCounter --> counter

--------------------------------------------------------------------------------

function Text.embossed(options)
    local _text = display.newEmbossedText({
        parent   = options.parent,
        text     = options.text,
        x        = options.x,
        y        = options.y,
        width    = options.width,
        height   = options.height,
        font     = options.font,
        fontSize = options.fontSize
    })

    local color = options.color or {
        highlight = { r=1, g=1, b=1 },
        shadow = { r=0.3, g=0.3, b=0.3 }
    }

    _text:setEmbossColor( color )
    return _text
end

function Text.simple(options)
    if(not options.parent) then return end

    local _text = display.newText({
        parent   = options.parent,
        text     = options.text,
        x        = options.x,
        y        = options.y,
        width    = options.width,
        height   = options.height,
        font     = options.font,
        fontSize = options.fontSize
    })

    _text:setFillColor( options.color )
    return _text
end

function Text.curve(options)
    local curvedText = display.newGroup()
    local circleSize = options.curveSize or 250
    local step       = options.fontSize*(0.33/#options.text)

    for i = 1, #options.text do
        local angleDegrees = (i - (#options.text+1.5)/2)*step - 90
        local angleRadians = math.rad(angleDegrees)

        local color =
        {
            highlight = { r=0.2, g=0.2, b=0.2 },
            shadow = { r=0.2, g=0.2, b=0.2 }
        }

        local sprite = Text.embossed({
            parent = curvedText,
            text = options.text:sub(i, i),
            x = 0,
            y = 0,
            font = options.font,
            fontSize = 65,
            color = color
        })

        sprite.x = options.x + math.cos(angleRadians)*circleSize
        sprite.y = options.y + math.sin(angleRadians)*circleSize
        sprite.rotation = 90 + angleDegrees -- or maybe minus this or plus 90...
    end

    options.parent:insert(curvedText)

    return curvedText
end

--------------------------------------------------------

function Text.counter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
    writer.currentDisplay = writer.currentDisplay or 0
    writer.x       = x
    writer.anchorX = anchorX
    writer.anchorY = anchorY

    timer.performWithDelay(25, function()
        local ratio = (4 * numToReach)/(numToReach - writer.currentDisplay)
        local toAdd = math.floor(numToReach/ratio)
        if(toAdd == 0) then toAdd = 1 end

        writer.currentDisplay = math.round(writer.currentDisplay + toAdd)

        if(writer.currentDisplay >= numToReach) then
            writer.currentDisplay = math.round(numToReach)
            writer.text    = writer.currentDisplay
            if(next) then next() end
        else
            nextMillis = 100/(numToReach - writer.currentDisplay)
            Text.counter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
        end

    end)
end

--------------------------------------------------------------------------------

-- local function displayTitle ()
--     local introText = Text:create({
--         parent   = App.hud,
--         value    = 'Kodo !',
--         x        = display.contentWidth * 0.1,
--         y        = display.contentHeight * 0.18,
--         fontSize = 45,
--         color    = 'ffffff'
--     })

--     introText.view.alpha   = 0

--     transition.to( introText.view, {
--         time       = 2600,
--         alpha      = 1,
--         x          = display.contentWidth * 0.13,
--         onComplete = function()
--             transition.to( introText, {
--                 time  = 3200,
--                 alpha = 0,
--                 x     = display.contentWidth * 0.16
--             })
--         end
--     })
-- end

--------------------------------------------------------------------------------

return Text
