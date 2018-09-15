--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local Button    = require 'cherry.components.button'
local Panel     = require 'cherry.components.panel'
local Banner    = require 'cherry.components.banner'

--------------------------------------------------------------------------------

local NamePicker = {}

--------------------------------------------------------------------------------

function NamePicker:new()
  local namePicker = {}
  setmetatable(namePicker, { __index = NamePicker })
  return namePicker
end

--------------------------------------------------------------------------------
---  BOARD
--------------------------------------------------------------------------------

function NamePicker:display()
  local board = display.newGroup()
  board.x = display.contentWidth  * 0.5
  board.y = display.contentHeight * 0.5
  App.hud:insert(board)

  local bg = Panel:vertical({
    parent = board,
    width  = display.contentWidth * 0.7,
    height = display.contentHeight * 0.7,
    x      = 0,
    y      = 0
  })

  Banner:simple({
    parent   = board,
    text     = 'Your name',
    fontSize = 80,
    width    = display.contentWidth*0.37,
    height   = display.contentHeight*0.075,
    x        = 0,
    y        = -bg.height*0.49
  })

  local inputText

  local function textListener( event )

    if ( event.phase == "began" ) then
      -- User begins editing "inputText"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
      -- Output resulting text from "inputText"
      print( event.target.text )

    elseif ( event.phase == "editing" ) then
      print( event.newCharacters )
      print( event.oldText )
      print( event.startPosition )
      print( event.text )
    end
  end

  -- Create text field
  inputText = native.newTextField( 0, -250, board.width - 70, 80 )
  inputText.font = native.newFont( _G.FONT, 80 )
  board:insert(inputText)
  inputText:addEventListener( "userInput", textListener )

  animation.easeDisplay(board)
end

--------------------------------------------------------------------------------

return NamePicker
