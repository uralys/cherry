--------------------------------------------------------------------------------
--- ANDROID BACK BUTTON
--------------------------------------------------------------------------------

local function onKeyEvent(event)
  local phase = event.phase
  local keyName = event.keyName

  if ('back' == keyName and phase == 'up') then
    _G.log('[backButtonListener] back button extension todo')
  end

  return true
end

--------------------------------------------------------------------------------

local function attachBackButtonListener()
  if (not _G.ANDROID) then
    return
  end

  Runtime:removeEventListener('key', onKeyEvent)
  Runtime:addEventListener('key', onKeyEvent)
end

--------------------------------------------------------------------------------

return attachBackButtonListener
