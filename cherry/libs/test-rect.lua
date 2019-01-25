local colorize = require 'cherry.libs.colorize'

_G.testRect = function ( options )
  local test = display.newRect(
    options.parent,
    options.x or display.contentWidth * 0.5,
    options.y or display.contentHeight * 0.5,
    options.width or display.contentWidth,
    options.height or display.contentHeight
  )

  if(options.anchorX) then
    test.anchorX = options.anchorX
  end

  if(options.anchorY) then
    test.anchorY = options.anchorY
  end

  test.alpha = options.alpha or 0.3
  test:setFillColor( colorize(options.color or '#ce95de') )
  test:toBack()
end
