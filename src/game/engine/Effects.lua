--------------------------------------------------------------------------------

local Effects = {
    effects     = {},
    nbDestroyed = 0,
    nbRunning   = 0
}

--------------------------------------------------------------------------------

function Effects:start(refresh)
    if(refresh) then
        -- Runtime:addEventListener( 'enterFrame', refreshEffects )
    else
        self:startAllEffects()
    end
end

function Effects:pause()
    -- Runtime:removeEventListener( 'enterFrame', refreshEffects )
end

function Effects:stop(now)
    self:pause()

    if(self.effects) then
        while #self.effects > 0 do
            self:destroyEffect(self.effects[1])
        end
    end

    self.effects = {}
    nbDestroyed  = 0
    nbRunning    = 0
end

function Effects:restart()
    self:pause(true)
    self:start()
end

--------------------------------------------------------------------------------
-- for static views : no refresh required
function Effects:startAllEffects()
    if(self.effects) then
        for i=1,#self.effects do
            self:startEffect(self.effects[i])
        end
    end
end

--------------------------------------------------------------------------------

function Effects:registerNewEffect( effect )
    effect.num = #self.effects+1
    self.effects[effect.num] = effect
end

--------------------------------------------------------------------------------

function Effects:startEffect( effect )
    if(not effect.started) then
        effect:start()
        effect.started = true

        --- debug
        nbRunning = nbRunning + 1
    end
end

--------------------------------------------------------------------------------

function Effects:stopEffect( effect )
    effect:stop()
    effect.started = false

    --- debug
    nbRunning = nbRunning - 1
end

--------------------------------------------------------------------------------

function Effects:destroyEffect( effect, now )
    utils.removeFromTable(self.effects, effect)
    effect:destroy()

    nbDestroyed = nbDestroyed + 1
end

--------------------------------------------------------------------------------

function Effects:destroyObjectWithEffect(body)
    if(body.effect) then
        return destroyEffect(body.effect)
    else
        return false
    end
end

--------------------------------------------------------------------------------
--- Menu Atmospheres
--------------------------------------------------------------------------------

function Effects:atmosphere(x, y, scale)
    local effect = CBE.newVent({
        preset = 'burn',
        emitX = x,
        emitY = y
    })

    self:registerNewEffect(effect)
    App.hud:insert(effect)
    return effect
end

-----------------------------------------------------------------------------
--- Level Exit
-----------------------------------------------------------------------------

function Effects:drawExit(x, y)
    local effect = CBE.newVent({
        preset      = 'wisps',
        color       = {{222/255,222/255,222/255},{225/255,155/255,120/255},{195/255,245/255,190/255}},
        perEmit     = 10,
        emitX       = x,
        emitY       = y-10,
        emissionNum = 0,
        emitDelay   = 320,
        lifeSpan    = 1800,
        fadeInTime  = 1800,
        scale       = 0.15,
        physics     = {
            gravityY = 0.025,
        }
    })

    self:registerNewEffect(effect)
    return effect
end

-----------------------------------------------------------------------------
--- Level NextStep
-----------------------------------------------------------------------------

function Effects:drawNextStep(x, y)
    local effect = CBE.newVent({
        preset='wisps',
        emitX = x,
        emitY = y-10,
        color={{205/255,225/255,200/255},{255/255,155/255,220/255},{115/255,215/255,220/255}},
        perEmit     = 1,
        emissionNum = 0,
        emitDelay   = 380,
        lifeSpan    = 1900,
        fadeInTime  = 1900,
        scale       = 0.1,
        physics     = {
            gravityY = 0.03,
        }
    })

    self:registerNewEffect(effect)
    return effect
end

-----------------------------------------------------------------------------
--- Room Breaker
-----------------------------------------------------------------------------

function Effects:drawRoomBreaker(x, y)
    local effect = CBE.newVent({
        preset='wisps',
        emitX = x,
        emitY = y-10,
        color={{215/255,245/255,250/255}},
        perEmit     = math.random(1,3),
        emissionNum = 0,
        emitDelay   = 380,
        lifeSpan    = 900,
        fadeInTime  = 900,
        scale       = 0.1,
        physics     = {
            gravityY = -0.01,
        }
    })

    self:registerNewEffect(effect)
    return effect
end

-----------------------------------------------------------------------------
--- Gem brightning
-----------------------------------------------------------------------------

function Effects:brighten(x, y)
    local light = CBE.newVent({
        preset      = 'wisps',
        color       = {{222/255,222/255,222/255},{175/255,155/255,120/255},{215/255,125/255,220/255}},
        emitX       = x,
        emitY       = y+10,
        perEmit     = 3,
        emitDelay   = 120,
        lifeSpan    = 2800,
        fadeInTime  = 2880,
        scale       = 0.25,
        alpha       = 0.3,
        physics     = {
            gravityY = 0.025,
        }
    })

    self:registerNewEffect(light)
    return light
end

-----------------------------------------------------------------------------
--- Explosion
-----------------------------------------------------------------------------

function Effects:explosion(parent, x, y)
    local vent = CBE.newVent({
        preset = 'wisps'   ,
        title = 'explosion',

        positionType = 'inRadius'  ,
        color = {{1, 1, 0}, {1, 0.5, 0}, {0.2, 0.2, 0.2}},
        particleProperties = {blendMode = 'add'},
        emitX = x,
        emitY = y,

        emissionNum = 5,
        emitDelay = 5,
        perEmit = 1,

        inTime = 100,
        lifeTime = 0,
        outTime = 600,

        onCreation = function(particle)
            particle:changeColor({
                color = {0.1, 0.1, 0.1},
                time = 600
            })
        end,

        onUpdate = function(particle)
            particle:setCBEProperty('  scaleRateX'   , particle:getCBEProperty('scaleRateX' ) * 0.998)
            particle:setCBEProperty('  scaleRateY'   , particle:getCBEProperty('scaleRateY' ) * 0.998)
        end,

        physics = {
            velocity = 0,
            gravityY = -0.035,
            angles = {0, 360},
            scaleRateX = 1.05,
            scaleRateY = 1.05
        }
    })

    self:registerNewEffect(vent)
    parent:insert(vent)
    self:restart()
end

--------------------------------------------------------------------------------

return Effects
