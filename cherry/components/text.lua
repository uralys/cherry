--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local TextUtils = require 'cherry.libs.text'
local colorize  = require 'cherry.libs.colorize'
local animation = require 'cherry.libs.animation'

local Text = {}

--------------------------------------------------------------------------------

function Text:create(options)
    local text = _.extend({}, options);
    setmetatable(text, { __index = Text })
    text:render()
    return text
end

--------------------------------------------------------------------------------

local function animate ( view, type )
    if(type == 'slow-disappear') then
        transition.to( view, {
            time       = 2600,
            alpha      = 1,
            x          = view.x + 30,
            onComplete = function()
                transition.to( view , {
                    time  = 3200,
                    alpha = 0,
                    x     = view.x + 30
                })
            end
        })
    end

    if(type == 'bounce-disappear') then
        transition.to( view, {
            time       = 50,
            alpha      = 1,
            onComplete = function()
                transition.to( view , {
                    time   = 1550,
                    alpha  = 0,
                    xScale = 1.25,
                    yScale = 1.25
                })
            end
        })
    end
end

--------------------------------------------------------------------------------

function Text:render()
    if (self.view) then
        display.remove(self.view)
    end

    self.view = TextUtils.simple({
        parent   = self.parent,
        text     = self.value,
        font     = self.font or _G.FONT,
        fontSize = self.fontSize or 55,
        x        = self.x,
        y        = self.y
    })

    self.view:setFillColor( colorize(self.color or 'ffffff') )

    if (self.grow) then
        animation.grow(self.view)
    end

    if (self.animation) then
        animate(self.view, self.animation)
    end

    self.view.anchorX = self.anchorX or 0.5
end

--------------------------------------------------------------------------------

function Text:setValue(value)
    self.value = value
    self:render()
end

--------------------------------------------------------------------------------

return Text
