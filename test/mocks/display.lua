local func = function () return {} end

local display = {
  contentWidth  = 750,
  contentHeight = 2250,
  newImage      = func,
  newImageRect  = func,
  newGroup      = function () return {
    insert  = func,
    toBack  = func,
    toFront = func
  } end
}

return display
