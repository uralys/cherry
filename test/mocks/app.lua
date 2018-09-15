local App = {
  version = 'cherry.tests',
  display = display.newGroup(),
  hud     = display.newGroup(),
  start   = function () end,
  width   = 640,
  height  = 1280,

  images = {
    starImage       = 'items/star.icon.png',
    heartImage      = 'items/heart.png',
    heartLeftImage  = 'items/heart-left.png',
    heartRightImage = 'items/heart-right.png',
    stepImage       = 'buttons/empty.png',
    verticalPanel   = 'panels/panel.vertical.png'
  }

}

return App
