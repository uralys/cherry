--------------------------------------------------------------------------------

local gesture = {}

--------------------------------------------------------------------------------

function gesture.onTouch(object, action, _options)
  local options = _options or {}

  if (object.removeOnTouch) then
    object.removeOnTouch()
  end

  local touch = function(event)
    if (event.phase == 'began') then
      -- display.getCurrentStage():setFocus( object )
      object.alpha = 0.8
    elseif event.phase == 'ended' or event.phase == 'cancelled' then
      object.alpha = 1
      -- display.getCurrentStage():setFocus( nil )
      action(event)
    end
    return not options.touchThrough -- default return true
  end

  object:addEventListener('touch', touch)

  object.removeOnTouch = function()
    object:removeEventListener('touch', touch)
  end
end

function gesture.onceTouch(object, action)
  gesture.onTouch(
    object,
    function(event)
      action(event)
      object.removeOnTouch()
    end
  )
end

--------------------------------------------------------------------------------

function gesture.onTap(object, action, _options)
  local options = _options or {}

  if (object.removeOnTap) then
    object.removeOnTap()
  end

  local tap = function(event)
    if (event.phase == 'began') then
      -- display.getCurrentStage():setFocus( object )
      action(event)
    -- elseif event.phase == 'ended' or event.phase == 'cancelled' then
    -- display.getCurrentStage():setFocus( nil )
    end
    return not options.touchThrough -- default return true
  end

  object:addEventListener('touch', tap)

  object.removeOnTap = function()
    object:removeEventListener('touch', tap)
  end
end

function gesture.onceTap(object, action)
  gesture.onTap(
    object,
    function(event)
      action(event)
      object.removeOnTap()
    end
  )
end

--------------------------------------------------------------------------------

function gesture.disabledTouch(object)
  gesture.onTap(
    object,
    function()
      return true
    end
  )
end

--------------------------------------------------------------------------------

return gesture
