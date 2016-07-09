--------------------------------------------------------------------------------

local ProgressBar = {}

--------------------------------------------------------------------------------
-- DOC desc
-- todo utils.text --> component.Text puis if Text or display.newtText
-- install src.component
-- install assets
function ProgressBar:new(options)
    local bar = _.extend({}, options);

    setmetatable(bar, { __index = ProgressBar })
    return bar;
end

--------------------------------------------------------------------------------
---
-- options :
--  parent
--  x
--  y
--  width
--  height
--  path
--
function ProgressBar:draw( options )
    self:prepare    ( options )
    self:background ( options )
    self:progress   ( options )
    self:icon       ( options )
    self:text       ( options )
end

--------------------------------------------------------------------------------
--  Construction
--------------------------------------------------------------------------------

function ProgressBar:prepare(options)
    self.display   = display.newGroup()
    self.display.x = options.x
    self.display.y = options.y
    options.parent:insert(self.display)
end

--- greenBG is show when 100%
function ProgressBar:background(options)
    self.bg = display.newImage(
        self.display,
        'assets/images/gui/progress-bar/loading-bg.png'
    )

    self.bg.width  = options.width
    self.bg.height = options.height

    if(options.disabled) then
        self.bg.fill.effect = 'filter.desaturate'
        self.bg.fill.effect.intensity = 0.8
    end

    ------------

    self.bgGreen = display.newImage(
        self.display,
        'assets/images/gui/progress-bar/loading-bg-green.png'
    )

    self.bgGreen.width  = options.width
    self.bgGreen.height = options.height
    self.bgGreen.alpha = 0
end

function ProgressBar:progress(options)
    self.progress = display.newImage(
        self.display,
        'assets/images/gui/progress-bar/loading-progress.png'
    )

    self.progress.width   = self:progressWidth()
    self.progress.height  = options.height*0.69
    self.progress.anchorX = 0
    self.progress.x       = -options.width/2.06

    self.progress:setMask( graphics.newMask(
            'assets/images/gui/progress-bar/loading-mask.png'
    ))
end

function ProgressBar:icon(options)
    if(options.path) then
        local logoContainer = display.newImage(
            self.display,
            'assets/images/gui/items/circle.simple.container.png',
            -options.width*0.55, 0
        )

        if(options.disabled) then
            logoContainer.fill.effect = 'filter.desaturate'
            logoContainer.fill.effect.intensity = 0.8
        end

        local ratio = (options.height / logoContainer.height) * 1.3
        logoContainer:scale(ratio, ratio)

        -----------------

        Icon:draw(_.defaults({
            parent  = self.display,
            x       = -options.width*0.55,
            y       = 0,
            maxSize = logoContainer.height * 0.6
        }, options))
    end
end

function ProgressBar:text(options)
    self.text = display.newText({
        parent   = self.display,
        text    = '',
        x        = 0,
        y        = 0,
        font     = FONT,
        fontSize = self.progress.height*0.7,
    })
end

--------------------------------------------------------------------------------
-- Tools
--------------------------------------------------------------------------------

function ProgressBar:progressWidth()
    return self.bg.width*0.97
end

function ProgressBar:showGreenBG()
    transition.to(self.bgGreen, {
        alpha      = 1,
        transition = easing.outQuad,
        time       = 1400
    })
end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function ProgressBar:set(value)
    self.text.text = value .. '%'
    self.progress.maskX = self:maskX(value)
    if(value == 100) then self:showGreenBG() end
end

function ProgressBar:reach(step)
    local value, text

    if('table' == type(step)) then
        value = step.value
        text = step.text
    else
        value = step
        text = value .. '%'
    end

    self.text.text = text

    transition.to(self.progress, {
        maskX      = self:maskX(value),
        transition = easing.outQuad,
        time       = 1400
    })

    if(value == 100) then self:showGreenBG() end
end

--------------------------------------------------------------------------------

function ProgressBar:maskX(value)
    return (value * (self:progressWidth()/100)) - self:progressWidth()/1.835
end

--------------------------------------------------------------------------------

return ProgressBar
