--------------------------------------------------------------------------------

Tutorial = {}

--------------------------------------------------------------------------------

function Tutorial:new()
    local object = {}
    setmetatable(object, { __index = Tutorial })
    return object
end

--------------------------------------------------------------------------------

function Tutorial:reset()
    if(self.panel) then
        utils.destroyFromDisplay(self.panel.text, true)
        utils.destroyFromDisplay(self.panel, true)
        self.panel = nil
        self.step = nil
    end
end

--------------------------------------------------------------------------------

function Tutorial:closeCurrentPanel()
    analytics.event('tutorial', 'close-panel', self.step )
    utils.destroyFromDisplay(self.panel, true)
    utils.destroyFromDisplay(self.panel.text, true)
end

--------------------------------------------------------------------------------

function Tutorial:showPanel(content, step)
    if(not content) then return end
    self:reset()

    self.step = step
    self.panel = display.newRoundedRect(
        App.hud,
        display.contentWidth*0.5,
        display.contentHeight*0.2,
        display.contentWidth*0.8,
        App:adaptToRatio(display.contentHeight*0.06),
        25
    )

    self.panel:setFillColor(0)
    self.panel.alpha = 0.4

    self.panel.text = utils.text({
        parent   = App.hud,
        x        = self.panel.x - self.panel.width/2 + 20,
        y        = self.panel.y - self.panel.height/2 + 20,
        value    = content,
        font     = FONT,
        fontSize = App:adaptToRatio(15),
        width    = self.panel.width - 50
    })

    self.panel.text.anchorX = 0
    self.panel.text.anchorY = 0

    utils.easeDisplay(self.panel)
    utils.easeDisplay(self.panel.text)

    utils.onTap(self.panel, function()
        self:closeCurrentPanel()
        return true
    end)

end

--------------------------------------------------------------------------------

function Tutorial:showTips()
    if(not self.tips or #self.tips == 0) then return end

    local json = self.tips[1]

    local tip = display.newImage(
        'assets/images/game/finger.png',
        json.from.x,
        json.from.y
    );

    tip.json = json
    tip.stop = json.stop

    Camera:insert(tip)
    self:tweenOn(tip)
end

function Tutorial:tweenOn(tip)
    tip.alpha = 0.8
    tip.x = tip.json.from.x
    tip.y = tip.json.from.y
    tip.stop = tip.stop - 1

    transition.to( tip, {
        time       = 1800,
        alpha      = 0,
        x          = tip.json.to.x,
        y          = tip.json.to.y,
        transition = easing.inSine,
        onComplete = function()
            timer.performWithDelay(800, function()
                if(tip.stop > 0) then
                    self:tweenOn(tip)
                end
            end)
        end
    })
end

--------------------------------------------------------------------------------

return Tutorial
