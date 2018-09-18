--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local group     = require 'cherry.libs.group'
local gesture   = require 'cherry.libs.gesture'
local Banner    = require 'cherry.components.banner'
local Button    = require 'cherry.components.button'
local Panel     = require 'cherry.components.panel'
local Text      = require 'cherry.components.text'

--------------------------------------------------------------------------------

local NamePicker = {}

--------------------------------------------------------------------------------

function NamePicker:new()
  local namePicker = {}
  setmetatable(namePicker, { __index = NamePicker })
  return namePicker
end

--------------------------------------------------------------------------------

local function existsUserName(name)
  local exists = false
  local user = App.user:current()

  for i = 1, App.user:nbUsers() do
    local userName = App.user:getUser(i).name
    if(userName ~= nil and userName == name) then
      exists = true
      user = i
    end
  end

  return exists, user
end

--------------------------------------------------------------------------------

local function usersHeight()
  local height = 0
  for i = 1, App.user:nbUsers() do
    height = height + display.contentHeight * 0.075
  end
  return display.contentHeight * 0.15 + height
end

--------------------------------------------------------------------------------

function NamePicker:display(next)
  self:refreshAction()
  self:createBlur()

  if(App.user:nbUsers() < 6) then
    self:createTextBoard(next)
  else
    self.hideCreation = true
  end

  if(App.user:nbUsers() > 1) then
    self:createPlayersBoard(next)
  end
end

--------------------------------------------------------------------------------

function NamePicker:createBlur()
  self.blurBG = display.newImageRect(
    App.hud,
    App.images.blurBG,
    display.contentWidth,
    display.contentHeight
  )

  self.blurBG.alpha = 0

  transition.to(self.blurBG, {
    alpha = 1,
    time = 300
  })

  self.blurBG.x = display.contentWidth * 0.5
  self.blurBG.y = display.contentHeight * 0.5
end

--------------------------------------------------------------------------------

function NamePicker:createTextBoard(next)
  self.text = App.user:name() or 'Player' .. string.sub(os.time(), -5)

  self.textBoard = self:createBoard({
    title       = 'New player',
    panelheight = display.contentHeight * 0.18,
    y           = display.contentHeight * 0.2
  })

  Button:icon({
    parent   = self.textBoard,
    type     = 'selected',
    x        = 0,
    y        = self.textBoard.panel.height * 0.5,
    action = function()
      if(self.createNewUser) then
        _G.log('createNewUser')
        App.user:newProfile(self.text)
      else
        _G.log('switchToProfile')
        App.user:switchToProfile(self.userNum)
      end

      self:close(next)
    end
  })

  self:createInputText()
end

--------------------------------------------------------------------------------

function NamePicker:createPlayersBoard(next)
  local height = usersHeight()
  local title = 'Previous player'
  local y = display.contentHeight * 0.68

  if(self.hideCreation == true) then
    title = 'Who are you ?'
    y = display.contentHeight * 0.5
  end

  self.playersBoard = self:createBoard({
    title       = title,
    panelheight = height,
    y           = y
  })

  self:addPreviousUsers(next)
end

--------------------------------------------------------------------------------

function NamePicker:close(next)
  group.destroy(self.textBoard, true)
  group.destroy(self.playersBoard, true)
  group.destroy(self.blurBG, false)
  if(next) then next() end
end

--------------------------------------------------------------------------------

function NamePicker:refreshAction()
  local exists, userNum = existsUserName(self.text)
  _G.log('refreshAction')
  _G.log({text= self.text, exists=exists, userNum=userNum})

  self.createNewUser = not exists
  self.userNum = userNum
end

--------------------------------------------------------------------------------

function NamePicker:createBoard(options)
  local panelheight = options.panelheight
  local title       = options.title
  local y           = options.y

  local board = display.newGroup()
  board.x = display.contentWidth * 0.5
  board.y = y
  App.hud:insert(board)
  gesture.disabledTouch(board) -- not to click behind

  board.panel = Panel:vertical({
    parent = board,
    width  = display.contentWidth * 0.7,
    height = panelheight,
    x      = 0,
    y      = 0
  })

  board.banner = Banner:simple({
    parent   = board,
    text     = title,
    fontSize = 70,
    width    = display.contentWidth*0.55,
    height   = display.contentHeight*0.075,
    x        = 0,
    y        = -board.panel.height*0.49
  })

  animation.easeDisplay(board)
  board:toFront()
  return board
end

--------------------------------------------------------------------------------

function NamePicker:createInputText()
  local function textListener( event )
    if ( event.phase == 'editing' ) then
      self.text = event.text
      self:refreshAction()
    end
  end

  -- Create text field
  self.inputText = native.newTextField(
    0, self.textBoard.banner.y + display.contentHeight * 0.085,
    display.contentWidth * 0.6, 80
  )

  self.inputText.font = native.newFont( _G.FONT, 80 )
  self.inputText.text = self.text
  native.setKeyboardFocus( self.inputText )

  self.inputText:addEventListener( 'userInput', textListener )
  self.textBoard:insert(self.inputText)
end

--------------------------------------------------------------------------------

function NamePicker:addPreviousUsers(next)
  for i = 1, App.user:nbUsers() do
    local playerName = App.user:getUser(i).name
    local user = display.newGroup()
    self.playersBoard:insert(user)
    user.x = 0
    user.y = self.playersBoard.banner.y + i * display.contentHeight * 0.09

    local panel = Panel:small({
      parent = user,
      x      = 0,
      y      = 0
    })

    local nameDisplay = Text:create({
      parent = user,
      value  = playerName,
      x      = 0,
      y      = 0,
      grow   = true,
      color  = '#000000',
      fontSize = 43
    })

    panel.width = nameDisplay:width() + 60

    gesture.onTouch(panel, function()
      animation.bounce(user, {
        time = 120,
        scaleFrom = 0.8,
        scaleTo = 1,
        onComplete = function()
          App.user:switchToProfile(i)
          self:close(next)
        end
      })
    end)
  end
end

--------------------------------------------------------------------------------

return NamePicker
