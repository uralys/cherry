local App = {
  version = 'cherry.tests',
  display = display.newGroup(),
  hud = display.newGroup(),
  start = function()
  end,
  width = 640,
  height = 1280,
  screens = {
    HOME = 'home',
    LEADERBOARD = 'leaderboard',
    PLAYGROUND = 'playground',
    HEADPHONES = 'headphones'
  },
  images = {
    star = 'items/star.icon.png',
    heart = 'items/heart.png',
    heartLeft = 'items/heart-left.png',
    heartRight = 'items/heart-right.png',
    step = 'buttons/empty.png',
    verticalPanel = 'panels/panel.vertical.png'
  }
}

return App
