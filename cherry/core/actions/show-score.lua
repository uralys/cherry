local Screen = require 'cherry.components.screen'

local function showScore()
  Screen:showBands()
  if (not App.user:name() and App.useNamePicker) then
    App.namePicker:display(App.score.display)
  else
    App.score:display()
  end
end

return showScore
