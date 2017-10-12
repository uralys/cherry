--------------------------------------------------------------------------------

local _    = require 'cherry.libs.underscore'
local Icon = require 'cherry.components.icon'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local ProgressBar = {}

--------------------------------------------------------------------------------
-- DOC desc
-- todo utils.text --> component.Text puis if Text or display.newtText
-- install component
-- install Cherry/assets

--- options:
--      changeBG:     boolean : greenbg at 100%
--      rail:         to override rail asset
--      track:        to override track asset
function ProgressBar: new(options)
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
    options = _.defaults(options, {
        width    = 300,
        height   = 35,
        hideText = false,
        changeBG = false
    })

    self:prepare    ( options )
    self:background ( options )
    self:progress   ( options )
    self:icon       ( options )

    if(not options.hideText) then
        self:addText(options)
    end
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
        self.rail or 'cherry/assets/images/gui/progress-bar/loading-bg.png'
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
        'cherry/assets/images/gui/progress-bar/loading-bg-green.png'
    )

    self.bgGreen.width  = options.width
    self.bgGreen.height = options.height
    self.bgGreen.alpha = 0
end

function ProgressBar:progress(options)
    self.progress = display.newImage(
        self.display,
        self.track or 'cherry/assets/images/gui/progress-bar/loading-progress.png'
    )

    self.progress.width   = self:progressWidth()
    self.progress.height  = options.height*0.69
    self.progress.anchorX = 0
    self.progress.x       = -options.width/2.06

    self.progress:setMask( graphics.newMask(
        'cherry/assets/images/gui/progress-bar/loading-mask.png'
    ))
end

function ProgressBar:icon(options)
    if(options.path) then
        local logoContainer = display.newImage(
            self.display,
            'cherry/assets/images/gui/items/circle.simple.container.png',
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

function ProgressBar:addText(options)
    self.text = Text:create({
        parent   = self.display,
        value    = '',
        x        = 0,
        y        = 0,
        font     = _G.FONT,
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
    if(self.text) then
        self.text:setValue(value .. '%')
    end

    self.progress.maskX = self:maskX(value)
    if(self.changeBG and value == 100) then self:showGreenBG() end
end

function ProgressBar:stop()
    if(self.reachTransition) then
        transition.cancel(self.reachTransition)
    end
end

function ProgressBar:reach(step, options)
    options = _.defaults(options, {
        transition = easing.outQuad,
        time       = 1400
    })

    if(self.reachTransition) then
        transition.cancel(self.reachTransition)
    end

    local value, text

    if('table' == type(step)) then
        value = step.value
        text = step.text
    else
        value = step
        text = value .. '%'
    end

    if(self.text) then
        self.text:setValue(text)
    end

    self.reachTransition = transition.to(self.progress, {
        maskX      = self:maskX(value),
        transition = options.transition,
        time       = options.time,
        onComplete = options.onComplete
    })

    if(self.changeBG and value == 100) then self:showGreenBG() end
end

--------------------------------------------------------------------------------

function ProgressBar:maskX(value)
    return (value * (self:progressWidth()/100)) - self:progressWidth()/1.835
end

function ProgressBar:currentValue()
    return (self.progress.maskX + self:progressWidth()/1.835 ) / (self:progressWidth()/100)
end

--------------------------------------------------------------------------------

return ProgressBar
