--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local gesture = require 'cherry.libs.gesture'
local Background = require 'cherry.components.background'

--------------------------------------------------------------------------------

local scene = _G.composer.newScene()
local selectedButton = nil

local CLOSED_Y = 35
local OPEN_Y = 70

--------------------------------------------------------------------------------

local function select(button)
  if(selectedButton) then
    if(button == selectedButton) then return end

    transition.to(selectedButton, {
      y = CLOSED_Y,
      time = 250,
      transition = easing.outBack
    })
  end

  selectedButton = button

  transition.to(button, {
    y = OPEN_Y,
    time = 250,
    transition = easing.outBack
  })

end

local function drawButton(num)
  local field = _.defaults(App.scoreFields[num], {
    scale = 1
  })

  ----------------------

  local button = display.newGroup()
  App.hud:insert(button)

  button.field = field
  button.x = 250 + (num - 1) * 150
  button.y = CLOSED_Y

  ----------------------

  display.newImage(
    button,
    'cherry/assets/images/gui/buttons/tab-vertical.png'
  )

  ----------------------

  local icon = display.newImage(
    button,
    field.image,
    0, 10
  )

  icon:scale(field.scale, field.scale)

  ----------------------

  display.newText({
    parent   = button,
    y        = -50,
    text     = field.label,
    font     = _G.FONT,
    fontSize = 40
  })

  ----------------------

  gesture.onTap(button, function()
    select(button)
  end)

  return button
end

--------------------------------------------------------------------------------

function scene:create( event )
end

function scene:show( event )
  if ( event.phase == 'did' ) then
    Background:darken()

    local buttons = {}
    for i = 1, #App.scoreFields do
      buttons[i] = drawButton(i)
    end

    select(buttons[1])

    local backArrow = display.newImage(
      App.hud,
      'cherry/assets/images/gui/items/arrow.right.png',
      50, 50
    )

    backArrow.rotation = 180
    backArrow:scale(0.6, 0.6)

    gesture.onTap(backArrow, function()
      Router:open(Router.HOME)
    end)
  end
end

function scene:hide( event )
end

function scene:destroy( event )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene
