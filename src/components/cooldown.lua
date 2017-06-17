--------------------------------------------------------------------------------
-- Cooldown by www.uralys.com
-- April 2014
--------------------------------------------------------------------------------

local Cooldown    = {}

-------------------------------------
-- Cooldown states

local EMPTY       = 1
local FORWARD     = 2
local REVERSE     = 3
local COMPLETE    = 4

-------------------------------------
-- Tween states

local PAUSED      = 1
local RUNNING     = 2

-------------------------------------
-- Needle states

local NEEDLE_ON_LEFT  = 1
local NEEDLE_ON_RIGHT = 2

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------

function Cooldown:new(options)
    local cooldown = {
        parent        = options.parent,
        x             = options.x                 or 0,
        y             = options.y                 or 0,
        alpha         = options.alpha             or 1,
        scale         = options.scale             or 1,
        loops         = options.loops             or 1,
        time          = options.time              or 2000,
        reverseRatio  = options.reverseRatio      or 1,
        autoStart     = options.autoStart         or false,
        autoStartBack = options.autoStartBack     or false,
        startBackTime = options.startBackTime     or 0,
        pauseTime     = system.getTimer(),
        startHalfTime = system.getTimer(),
        needle        = NEEDLE_ON_RIGHT,
        state         = EMPTY,
        tweenState    = PAUSED
    }

    setmetatable(cooldown, { __index = Cooldown })
    self:prepare(cooldown)
    self:autoRun(cooldown)

    return cooldown
end

--------------------------------------------------------------------------------

function Cooldown:prepare(cooldown)

    cooldown.leftCircle = display.newImage(
        cooldown.parent,
        'Cherry/assets/images/cooldown/half.left-' .. cooldown.alpha .. '.png'
    )

    cooldown.leftCircle.x           = cooldown.x
    cooldown.leftCircle.y           = cooldown.y
    cooldown.leftCircle:scale (cooldown.scale, cooldown.scale)

    cooldown.rightCircle = display.newImage(
        cooldown.parent,
        'Cherry/assets/images/cooldown/half.left-' .. cooldown.alpha .. '.png'
    )

    cooldown.rightCircle.rotation = 180
    cooldown.rightCircle.x        = cooldown.x
    cooldown.rightCircle.y        = cooldown.y
    cooldown.rightCircle:scale (cooldown.scale, cooldown.scale)

    cooldown.leftMask  = graphics.newMask( 'Cherry/assets/images/cooldown/mask.png' )
    cooldown.rightMask = graphics.newMask( 'Cherry/assets/images/cooldown/mask.png' )

    cooldown.leftCircle:setMask     ( cooldown.leftMask )
    cooldown.rightCircle:setMask    ( cooldown.rightMask )

    self:reset(cooldown)
end

--------------------------------------------------------------------------------

function Cooldown:autoRun(cooldown)
    if(cooldown.autoStart) then
        cooldown:start()
    end

    if(cooldown.autoStartBack) then
        cooldown:start(true)
    end
end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

---
-- starts the cooldown,
-- only if it is EMPTY and tweens are PAUSED.
--
function Cooldown:start(reverse)
    if(reverse) then
        self.state                      = COMPLETE
        self.tweenState                 = PAUSED
        self.needle                     = NEEDLE_ON_LEFT
        self.rightCircle.maskRotation   = 180
        self.leftCircle.maskRotation    = 180
        self:startBack()
        self:addTime(-self.startBackTime)

    elseif(self.state == EMPTY and self.tweenState == PAUSED) then
        self.startHalfTime      = system.getTimer()
        self.state              = FORWARD
        self.remainingHalfTime  = self.time*0.5
        self:tweenRightPart()
    end
end

---
-- starts the cooldown,
-- only if it is COMPLETE and tweens are PAUSED.
--
function Cooldown:startBack()
    if(self.state == COMPLETE and self.tweenState == PAUSED) then
        self.startHalfTime      = system.getTimer()
        self.state              = REVERSE
        self.remainingHalfTime  = self.time*0.5 / self.reverseRatio
        self:tweenLeftPart()
    end
end

-------------------------------------

function Cooldown:addTime(time)

    local timeForHalf   = 0
    local currentAngle  = 0

    self:pause()

    ---
    -- avant : verif si on tombe en EMPTY OU COMPLETE
    if(self.state == FORWARD) then

        timeForHalf     = self.time*0.5
        currentAngle    = math.round(180 * self.elapsedTime/timeForHalf)

        if(self.elapsedTime + math.abs(time)  > timeForHalf) then
            print('addTime : set COMPLETE')
        end

    elseif(self.state == REVERSE) then

        timeForHalf     = self.time*0.5/self.reverseRatio
        currentAngle    = 360 - math.round(180 * self.elapsedTime/timeForHalf)

        if(self.elapsedTime + math.abs(time)  > self.time/self.reverseRatio) then
            print('addTime : set EMPTY')
        end

    end

    print('addtime          : ' .. time)
    print('state            : ' .. self.state)
    print('elapsedTime      : ' .. self.elapsedTime)
    print('timeForHalf      : ' .. timeForHalf)

    ---
    --  calcule angle requis ( si time negatif : on regarte avec reverseRatio)
    local angleToAdd        = 180 * time/timeForHalf
    local angleToReach      = currentAngle + angleToAdd

    print('currentAngle      : ' .. currentAngle)
    print('angleToAdd        : ' .. angleToAdd)
    print('angleToReach      : ' .. angleToReach)

    ---
    -- find out if the needle changes side

    local sameNeedle = self.elapsedTime + math.abs(time)  < timeForHalf

    ---
    -- needle stays on the same side

    if(sameNeedle) then

        print('sameNeedle')

        if(self.needle == NEEDLE_ON_RIGHT) then
            self.rightCircle.maskRotation   = angleToReach
        else
            self.leftCircle.maskRotation    = angleToReach - 180
        end

        self.remainingHalfTime  = timeForHalf - self.elapsedTime - math.abs(time)
        self.startHalfTime      = system.getTimer() - (self.time*0.5 - self.remainingHalfTime)


    ---
    -- needle changes side

    else
        if(self.needle == NEEDLE_ON_RIGHT) then
            print('needle changes from right to left')
            self.rightCircle.maskRotation   = 180
            self.leftCircle.maskRotation    = angleToReach - 180
            self.needle                     = NEEDLE_ON_LEFT
            self.remainingHalfTime          = timeForHalf - self.elapsedTime - math.abs(time)
            self.startHalfTime              = system.getTimer() - (timeForHalf - self.remainingHalfTime)
        end

        if(self.needle == NEEDLE_ON_LEFT) then
            print('needle changes from left to right')
            self.leftCircle.maskRotation    = 0
            self.rightCircle.maskRotation   = angleToReach
            self.needle                     = NEEDLE_ON_RIGHT
            self.remainingHalfTime          = angleToReach/180 * timeForHalf
            self.startHalfTime              = system.getTimer() - (timeForHalf - self.remainingHalfTime)
        end

    end


    print('self.rightCircle.maskRotation      : ' .. self.rightCircle.maskRotation)
    print('self.leftCircle.maskRotation       : ' .. self.leftCircle.maskRotation)

    print('remainingHalfTime                  : ' .. self.remainingHalfTime)


--    if(angleToReach > 180) then
--        self.rightCircle.maskRotation   = 180
--        self.leftCircle.maskRotation    = angleToReach
--        self.needle                     = NEEDLE_ON_LEFT
--
--        if(self.state == FORWARD) then
--            self.remainingHalfTime  = self.time*0.5 - self.elapsedTime - time
--            self.startHalfTime      = system.getTimer() - (self.time*0.5 - self.remainingHalfTime)
--        elseif(self.state == REVERSE) then
--            self.remainingHalfTime  = self.time*0.5/self.reverseRatio - self.elapsedTime - time
--            self.startHalfTime      = system.getTimer() - (self.time*0.5/self.reverseRatio - self.remainingHalfTime)
--        end
--
--    else
--        self.rightCircle.maskRotation   = angleToReach
--        self.needle                     = NEEDLE_ON_RIGHT
--
--        if(self.state == FORWARD) then
--            self.remainingHalfTime  = self.time*0.5 - self.elapsedTime - time
--            self.startHalfTime      = system.getTimer() - (self.time*0.5 - self.remainingHalfTime)
--        elseif(self.state == REVERSE) then
--            self.remainingHalfTime  = self.time*0.5/self.reverseRatio - self.elapsedTime - time
--            self.startHalfTime      = system.getTimer() - (self.time*0.5/self.reverseRatio - self.remainingHalfTime)
--        end
--
--    end

    ---
    --

    ----------

    self:continue()

end


-------------------------------------

---
-- reverse the cooldown,
-- only if it is currently running.
-- if not running and forceStart : then start the cooldown instead
--
-- the reverse action :
-- actually pause the tweens,
-- change state,
-- calculate reverse timings,
-- and finally continue the tweens
--
function Cooldown:reverse(forceStart)

    ---------------------

    if(forceStart and self.state == COMPLETE) then
        self:startBack()
        return
    end

    ---------------------

    if(forceStart and self.state == EMPTY) then
        self:start()
        return
    end

    ---------------------

    local forbidden = self.state == COMPLETE or (self.state == EMPTY and not forceStart)
    if(forbidden) then return end

    ---------------------

    self:pause()

    if(self.state == FORWARD) then
        self.state              = REVERSE
        self.remainingHalfTime  = self.elapsedTime/self.reverseRatio
        self.startHalfTime      = system.getTimer() - (self.time*0.5/self.reverseRatio - self.remainingHalfTime)
    elseif(self.state == REVERSE) then
        self.state              = FORWARD
        self.remainingHalfTime  = self.elapsedTime*self.reverseRatio
        self.startHalfTime      = system.getTimer() - (self.time*0.5 - self.remainingHalfTime)
    end

    self:continue()

end

-------------------------------------

---
-- pause the tweens,
-- only if cooldown is currently running.
--
function Cooldown:pause()
    local forbidden = self.state == COMPLETE
                   or self.state == EMPTY
                   or self.tweenState == PAUSED

    if(forbidden) then return end

    self:stopTweens()
    self.pauseTime          = system.getTimer()
    self.elapsedTime        = system.getTimer() - self.startHalfTime
    self.remainingHalfTime  = self.time*0.5 - self.elapsedTime
end

-------------------------------------
---
-- ask the tweens to restart from the pause,
-- only if cooldown is currently running.
--
function Cooldown:continue()
    local forbidden = self.state == COMPLETE
                   or self.state == EMPTY
                   or self.tweenState == RUNNING

    if(forbidden) then return end

    if(self.pauseTime) then
        local timeSpentOnPause  = system.getTimer() - self.pauseTime
        self.startHalfTime      = self.startHalfTime + timeSpentOnPause
    end

    if(self.needle == NEEDLE_ON_RIGHT) then
        self:tweenRightPart()
    else
        self:tweenLeftPart()
    end
end

--------------------------------------------------------------------------------

function Cooldown:reset(cooldown)
    cooldown = cooldown or self
    cooldown.leftCircle.maskRotation  = 0
    cooldown.rightCircle.maskRotation = 0
    cooldown.state = EMPTY
end

--------------------------------------------------------------------------------
-- UTILS
--------------------------------------------------------------------------------

function Cooldown:stopTweens()
    if(self.tweenLeft)  then transition.cancel(self.tweenLeft)  end
    if(self.tweenRight) then transition.cancel(self.tweenRight) end

    self.tweenState = PAUSED
end

------------------------------------------

function Cooldown:tweenRightPart()
    local angle = 180
    if(self.state == REVERSE) then angle = 0 end

    self.needle = NEEDLE_ON_RIGHT
    self.tweenRight = transition.to(self.rightCircle, {
        maskRotation    = angle,
        time            = self.remainingHalfTime ,
        onComplete      = function()
            if(self.state == FORWARD) then
                self.remainingHalfTime = self.time*0.5
                self.startHalfTime     = system.getTimer()
                self:tweenLeftPart()

            else
                self.state      = EMPTY
                self.tweenState = PAUSED

                if(self.onComplete) then
                    self:onComplete()
                end
            end
        end
    })

    self.tweenState = RUNNING
end

------------------------------------------

function Cooldown:tweenLeftPart()
    local angle = 180
    if(self.state == REVERSE) then angle = 0 end

    self.needle = NEEDLE_ON_LEFT
    self.tweenLeft = transition.to(self.leftCircle, {
        maskRotation    = angle,
        time            = self.remainingHalfTime,
        onComplete      = function()
            if(self.state == FORWARD) then
                self.state      = COMPLETE
                self.tweenState = PAUSED

                if(self.onComplete) then
                    self:onComplete()
                end

            else
                self.remainingHalfTime = self.time*0.5/self.reverseRatio
                self.startHalfTime     = system.getTimer()
                self:tweenRightPart()

            end

        end
    })

    self.tweenState = RUNNING
end

--------------------------------------------------------------------------------

return Cooldown
