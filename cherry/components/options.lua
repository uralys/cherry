--------------------------------------------------------------------------------

local Text = require 'cherry.libs.text'
local Button = require 'cherry.components.button'
local Screen = require 'cherry.components.screen'

--------------------------------------------------------------------------------

local Options = {}

--------------------------------------------------------------------------------

local initActionX = display.contentWidth - 50
local initActionY = display.contentHeight - 75

local ANIMATION_TIME = 1200
local OPTION_BUTTONS_GAP = 110

local LEADERBOARD_BUTTON_X = initActionX
local LEADERBOARD_BUTTON_Y = initActionY - 100

local PRIVACY_BUTTON_POSITION = 1
local INFO_BUTTON_POSITION = 2
local MUSIC_BUTTON_POSITION = 3
local PROFILE_BUTTON_POSITION = 4

local nbOptionButtons = 4
local VERSION_POSITION = nbOptionButtons + 1

local buttonPosition = function(num)
  return OPTION_BUTTONS_GAP * num
end

--------------------------------------------------------------------------------

function Options:create(view)
  self:drawActions(view)
  self:drawLeaderboardButton(view)
end

--------------------------------------------------------------------------------

function Options:drawLeaderboardButton(view)
  if (not App.scoreFields) then
    return
  end
  self.leaderboardButton =
    Button:icon(
    {
      parent = view,
      type = 'leaderboard',
      x = LEADERBOARD_BUTTON_X,
      y = LEADERBOARD_BUTTON_Y,
      scale = .7,
      action = function()
        Router:open(Router.LEADERBOARD)
      end
    }
  )
end

--------------------------------------------------------------------------------

function Options:drawInfoButton()
  self.infoButton =
    Button:icon(
    {
      parent = self.actions,
      type = 'info',
      x = buttonPosition(INFO_BUTTON_POSITION),
      y = 0,
      scale = .7,
      action = function()
        Screen:openCredits()
      end
    }
  )
end

--------------------------------------------------------------------------------

function Options:drawPrivacyButton()
  self.infoButton =
    Button:icon(
    {
      parent = self.actions,
      type = 'privacy',
      x = buttonPosition(PRIVACY_BUTTON_POSITION),
      y = 0,
      scale = .7,
      action = function()
        Screen:openPrivacy()
      end
    }
  )
end

--------------------------------------------------------------------------------

function Options:drawProfileButton()
  if (not App.useNamePicker) then
    return
  end
  local buttonLock = false
  local pickPlayer = function()
    if (buttonLock) then
      return
    end
    buttonLock = true
    App.namePicker:display(
      function()
        buttonLock = false
      end
    )
  end

  self.profileButton =
    Button:icon(
    {
      parent = self.actions,
      type = 'profile',
      x = buttonPosition(PROFILE_BUTTON_POSITION),
      y = 0,
      scale = .7,
      action = pickPlayer
    }
  )
end

--------------------------------------------------------------------------------

function Options:drawActions(view)
  self.actions = display.newGroup()
  self.actions.x = initActionX
  self.actions.y = initActionY
  self.actions.open = false
  self.actions.lock = false
  view:insert(self.actions)

  self.toggleActionsButton =
    Button:icon(
    {
      parent = self.actions,
      type = 'settings',
      x = 0,
      y = 0,
      scale = .7,
      action = function()
        self:toggleActions()
      end
    }
  )

  self:redrawMusicButton()

  self:drawInfoButton()
  self:drawProfileButton()
  self:drawPrivacyButton()

  self.version =
    Text.simple(
    {
      parent = self.actions,
      text = App.version,
      x = buttonPosition(VERSION_POSITION),
      y = 0,
      color = 1,
      font = _G.FONT,
      fontSize = 40
    }
  )
end

--------------------------------------------------------------------------------

function Options:toggleActions()
  if (self.actions.lock) then
    return
  end
  self.actions.lock = true

  if (self.actions.open) then
    self:closeActions()
  else
    self:openActions()
  end
end

function Options:openActions()
  transition.cancel(self.actions)
  transition.to(
    self.actions,
    {
      x = initActionX - OPTION_BUTTONS_GAP / 2 - self.version.width -
        (nbOptionButtons * OPTION_BUTTONS_GAP),
      time = ANIMATION_TIME,
      transition = easing.inOutBack,
      onComplete = function()
        self.actions.open = true
        self.actions.lock = false
      end
    }
  )

  self:rotateButton(self.toggleActionsButton)
  self:rotateButton(self.infoButton)
  self:rotateButton(self.musicButton)
  self:rotateButton(self.profileButton)
end

function Options:closeActions()
  transition.cancel(self.actions)
  transition.to(
    self.actions,
    {
      x = initActionX,
      time = ANIMATION_TIME,
      transition = easing.inOutBack,
      onComplete = function()
        self.actions.open = false
        self.actions.lock = false
      end
    }
  )

  self:rotateButton(self.toggleActionsButton, true)
  self:rotateButton(self.infoButton, true)
  self:rotateButton(self.musicButton, true)
  self:rotateButton(self.profileButton, true)
end

function Options:rotateButton(button, back)
  local rotation = function()
    if (back) then
      return 0
    else
      return -360
    end
  end
  transition.to(
    button,
    {
      rotation = rotation(),
      time = ANIMATION_TIME,
      transition = easing.inOutBack
    }
  )
end

--------------------------------------------------------------------------------

function Options:redrawMusicButton()
  if (self.musicButton) then
    display.remove(self.musicButton)
  end

  local musicType = 'music'
  if (App.sound.isOff) then
    musicType = 'music-off'
  end

  self.musicButton =
    Button:icon(
    {
      parent = self.actions,
      type = musicType,
      x = buttonPosition(MUSIC_BUTTON_POSITION),
      y = 0,
      scale = .7,
      action = function()
        App.sound:toggleAll()
        self:redrawMusicButton()
      end
    }
  )
end

--------------------------------------------------------------------------------

return Options
