--------------------------------------------------------------------------------

local table = require 'table-extended'

--------------------------------------------------------------------------------

local Effects = {
    effects = {},
}

local nbDestroyed = 0
local nbRunning   = 0

--------------------------------------------------------------------------------

function Effects:start()
    self:startAllEffects()
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
    table.removeObject(self.effects, effect)
    effect:destroy()

    nbDestroyed = nbDestroyed + 1
end

--------------------------------------------------------------------------------

function Effects:destroyObjectWithEffect(body)
    if(body.effect) then
        return self:destroyEffect(body.effect)
    else
        return false
    end
end

--------------------------------------------------------------------------------
--- Menu Atmospheres
--------------------------------------------------------------------------------

function Effects:atmosphere(parent, x, y, scale)
    local effect = CBE.newVent({
        preset = 'wisps',
        emitX = x,
        emitY = y
    })

    self:registerNewEffect(effect)
    parent:insert(effect)
    return effect
end

-----------------------------------------------------------------------------
--- Explosion
-----------------------------------------------------------------------------

function Effects:explosion(parent, x, y)
    local vent = CBE.newVent({
        preset = 'wisps',
        title = 'explosion',

        positionType = 'inRadius'  ,
        color = {{1, 1, 0}, {1, 0.5, 0}, {0.2, 0.2, 0.2}},
        particleProperties = {blendMode = 'add'},
        emitX = x,
        emitY = y,

        emissionNum = 5,
        emitDelay = 5,
        perEmit = 5,

        inTime = 100,
        lifeTime = 0,
        outTime = 300,

        onCreation = function(particle)
            particle:changeColor({
                color = {0.1, 0.1, 0.1},
                time = 500
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
            scaleRateX = .85,
            scaleRateY = .85
        }
    })

    self:registerNewEffect(vent)
    parent:insert(vent)
    self:restart()
end

--------------------------------------------------------------------------------

return Effects
