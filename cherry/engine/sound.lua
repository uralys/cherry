--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'

--------------------------------------------------------------------------------

local Sound = {}

--------------------------------------------------------------------------------

function Sound:init(extension)
  local _sound = _.defaults(extension or {}, {
    isOff    = App.user:isSoundOff() or App.SOUND_OFF,
    themes   = {},
    sfx      = {},
    options  = {},
    channels = {},
    loopOnStart = false
  })

  setmetatable(_sound, { __index = Sound })

  if(_sound.isOff) then
    _sound:off(_sound.channels.music)
    _sound:off(_sound.channels.effects)
  end

  if(_sound.loopOnStart) then
    _sound:loop()
  end

  return _sound
end

-----------------------------------------------------------------------------------------

function Sound:nextTheme()
  self.currentTheme = self.currentTheme + 1
  if(self.currentTheme == (#self.themes+1)) then self.currentTheme = 1 end

  audio.pause(self.channels.music)

  self.channels.music = audio.play( self.themes[self.currentTheme], {
    onComplete = function()
      self:nextTheme()
    end,
  })
end

--------------------------------------------------------------------------------

function Sound:toggleAll()
  self.isOff = not self.isOff

  App.user:saveSoundSettings(self.isOff)

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

function Sound:effect(effect)
  if(not self.isOff and not App.SOUND_OFF) then
    self.channels.effect = audio.play(effect)
  end
end

function Sound:play(track)
  if(not self.isOff and not App.SOUND_OFF) then
    self.channels.music = audio.play(track)
  end
end

function Sound:loop(num)
  self.currentTheme = num or 0
  self:nextTheme()
end


--------------------------------------------------------------------------------

return Sound
