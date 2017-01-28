--------------------------------------------------------------------------------

local Sound = {
    isOff = false,
    options = {},
    channels = {}
}

-----------------------------------------------------------------------------------------

local themes = {
    audio.loadSound('assets/sounds/music/theme-1.mp3'),
    audio.loadSound('assets/sounds/music/theme-2.mp3')
}

local rotation   = audio.loadSound('assets/sounds/sfx/room-rotation.mp3')
local toggleDoor = audio.loadSound('assets/sounds/sfx/toggle-door.mp3')
local gem        = audio.loadSound('assets/sounds/sfx/gem.mp3')
local exit       = audio.loadSound('assets/sounds/sfx/exit.mp3')

local room = {
    appear = audio.loadSound('assets/sounds/sfx/room-appear.mp3'),
    vanish = audio.loadSound('assets/sounds/sfx/room-vanish.mp3'),
    tilt   = audio.loadSound('assets/sounds/sfx/room-tilt.mp3')
}

local gems = {
    audio.loadSound('assets/sounds/sfx/gem-1.mp3'),
    audio.loadSound('assets/sounds/sfx/gem-2.mp3'),
    audio.loadSound('assets/sounds/sfx/gem-3.mp3')
}

-----------------------------------------------------------------------------------------

function Sound:playMusic()
    self.currentTheme = 0
    self:nextTheme()
end

function Sound:nextTheme()
    self.currentTheme = self.currentTheme + 1
    if(self.currentTheme == (#themes+1)) then self.currentTheme = 1 end

    audio.pause(self.channels.music)

    self.channels.music = audio.play( themes[self.currentTheme], {
        onComplete = function()
            self:nextTheme()
        end,
    })
end

--------------------------------------------------------------------------------

function Sound:toggleAll()
    self.isOff = not self.isOff
    self:toggleMusic()
    self:toggleEffects()
end

function Sound:toggleMusic()
    self:toggle(self.channels.music)
end

function Sound:toggleEffects()
    self:toggle(self.channels.effects)
end

--------------------------------------------------------------------------------

function Sound:off(channel)
    audio.setVolume( 0, { channel = channel } )
end

function Sound:on(channel)
    audio.setVolume( 1, { channel = channel } )
end

function Sound:toggle(channel)
    local current = audio.getVolume( { channel = channel } )
    if(current > 0 ) then
        self:off(channel)
    else
        self:on(channel)
    end
end

--------------------------------------------------------------------------------

function Sound:musicVolume(value)
    audio.setVolume( value, { channel = self.channels.music } )
end

function Sound:effectsVolume(value)
    audio.setVolume( value, { channel = self.channels.effects } )
end

--------------------------------------------------------------------------------

function Sound:effect(effect, value)
    if(not self.isOff and not App.SOUND_OFF) then
        self.channels.effect = audio.play(effect)
        self:effectsVolume(value or 1)
    end
end

--------------------------------------------------------------------------------

function Sound:playRotation()
    self:effect( rotation )
end

function Sound:playButton()
    self:playRotation()
end

function Sound:playToggleDoor()
    self:effect( toggleDoor )
end

function Sound:playGem()
    self:effect( gem )
end

function Sound:playExit()
    self:effect( exit )
end

function Sound:playAppear()
    self:effect( room.appear)
end

function Sound:playVanish()
    self:effect( room.vanish )
end

function Sound:playTilt()
    self:effect( room.tilt )
end

function Sound:playFinalGem(num)
    self:effect( gems[num] )
end

-----------------------------------------------------------------------------------------

return Sound
