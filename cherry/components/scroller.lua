--------------------------------------------------------------------------------

local Scroller = {
  children = {}
}

--------------------------------------------------------------------------------

local widget = widget or require('widget')

local SCROLL_SPEED = 40
local LERP_FACTOR = 0.15
local LERP_THRESHOLD = 0.5

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function Scroller:new(options)
  self.options = options
  self.options.gap = self.options.gap or 0
  self.children = {}

  self:prepareScrollView()
  self:scrollbarBase()
  self:scrollbarHandle()

  return self
end

--------------------------------------------------------------------------------

function Scroller:destroy()
  self:disableMouseScroll()

  pcall(function()
    if self.scrollView then
      self.scrollView:removeSelf()
      self.scrollView = nil
    end
    if self.scrollbar then
      self.scrollbar:removeSelf()
      self.scrollbar = nil
    end
    self:removeChildren()
  end)
end

--------------------------------------------------------------------------------

function Scroller:insert(child, options)
  options = options or {}
  child.x = options.x or self.options.width / 2
  child.y =
    options.y or self:contentHeight() + child.height / 2 + self.options.gap
  self.children[#self.children + 1] = child
  self.scrollView:insert(child)

  self:refreshHandle()
  self:refreshContentHeight()
  return child
end

function Scroller:remove(child)
  local index = 1
  for k in pairs(self.children) do
    if self.children[k] == child then
      break
    end
    index = index + 1
  end

  table.remove(self.children, index)
  self:refreshHandle()
  self:refreshContentHeight()
  display.remove(child)
  return child
end

function Scroller:removeChildren()
  self.scrollView._view.y = 0
  while #self.children > 0 do
    self:remove(self.children[1])
  end
end

--------------------------------------------------------------------------------
-- Scrollbar display
--------------------------------------------------------------------------------

function Scroller:hideScrollbar()
  self.scrollbar.base.alpha = 0
  self.scrollbar.handle.alpha = 0
end

function Scroller:showScrollbar()
  self.scrollbar.base.alpha = 1
  self.scrollbar.handle.alpha = 1
end

function Scroller:prepareScrollView()
  self.scrollView =
    widget.newScrollView(
    {
      top = self.options.top,
      left = self.options.left,
      width = self.options.width,
      height = self.options.height,
      scrollWidth = 0,
      scrollHeight = 0,
      horizontalScrollDisabled = self.options.horizontalScrollDisabled,
      verticalScrollDisabled = self.options.verticalScrollDisabled,
      hideBackground = self.options.hideBackground,
      hideScrollBar = true,
      backgroundColor = self.options.backgroundColor or {0, 0, 0, 0.5}
    }
  )

  self.currentScrollHeight = 0
  self.options.parent:insert(self.scrollView)
end

function Scroller:scrollbarBase()
  self.scrollbar = display.newGroup()
  self.scrollbar.x = self.options.left + self.options.width
  self.scrollbar.y = self.options.top
  self.options.parent:insert(self.scrollbar)

  self.scrollbar.base =
    display.newImageRect(
    self.scrollbar,
    'cherry/assets/images/gui/scroller/scroll.base.png',
    20,
    self.options.height * 0.8
  )

  self.scrollbar.base.x = 0
  self.scrollbar.base.y = self.options.height * 0.5
end

function Scroller:scrollbarHandle()
  self.scrollbar.handle =
    display.newImageRect(
    self.scrollbar,
    'cherry/assets/images/gui/scroller/scroll.handle.png',
    20,
    0
  )

  self:refreshHandle()
end

function Scroller:refreshHandle()
  local totalHeight = self:contentHeight()
  local height

  if totalHeight == 0 then
    self:hideScrollbar()
    return
  end

  if self.options.handleHeight then
    height = self.options.handleHeight
    self:showScrollbar()
  else
    local ratio = self.options.height / totalHeight
    height = self.scrollbar.base.height * ratio

    if ratio > 1 then
      self:hideScrollbar()
    else
      self:showScrollbar()
    end
  end

  self.scrollbar.handle.height = height
  self.scrollbar.handle.min =
    self.scrollbar.base.y - self.scrollbar.base.height * 0.5 + height * 0.5
  self.scrollbar.handle.max =
    self.scrollbar.handle.min + self.scrollbar.base.height - height
  self.scrollbar.handle.x = 0
  self.scrollbar.handle.y = self.scrollbar.handle.min
end

--------------------------------------------------------------------------------
-- Content height
--------------------------------------------------------------------------------

function Scroller:refreshContentHeight()
  self.currentScrollHeight = self:contentHeight()
  self.scrollView:setScrollHeight(self.currentScrollHeight)
  self:setRatio()
end

function Scroller:contentHeight()
  local height = 0
  for _, child in pairs(self.children) do
    height = height + child.height + self.options.gap
  end
  return height
end

function Scroller:setRatio()
  if self.scrollbar.handle.max then
    local scrollbarHeight =
      self.scrollbar.handle.max - self.scrollbar.handle.min
    local scrollableHeight = self.currentScrollHeight - self.options.height
    self.scrollableRatio = scrollbarHeight / scrollableHeight
  end
end

--------------------------------------------------------------------------------
-- Handle positioning
--------------------------------------------------------------------------------

function Scroller:syncHandlePosition()
  if not self.scrollView or self.scrollView._view.y == nil then
    return
  end

  self.scrollbar.handle.y =
    -self.scrollView._view.y * self.scrollableRatio + self.scrollbar.handle.min

  if self.scrollbar.handle.y > self.scrollbar.handle.max then
    self.scrollbar.handle.y = self.scrollbar.handle.max
  end

  if self.scrollbar.handle.y < self.scrollbar.handle.min then
    self.scrollbar.handle.y = self.scrollbar.handle.min
  end
end

--------------------------------------------------------------------------------
-- Mouse scroll + draggable handle
--------------------------------------------------------------------------------

function Scroller:clampContentY(y)
  local minY = -(self.currentScrollHeight - self.options.height)
  if y > 0 then y = 0 end
  if y < minY then y = minY end
  return y
end

function Scroller:stopLerp()
  if self.lerpListener then
    Runtime:removeEventListener('enterFrame', self.lerpListener)
    self.lerpListener = nil
  end
  self.targetY = nil
end

function Scroller:startLerp()
  if self.lerpListener then return end

  local function onFrame()
    if not self.scrollView or not self.targetY then
      self:stopLerp()
      return
    end

    local currentY = self.scrollView._view.y
    local newY = currentY + (self.targetY - currentY) * LERP_FACTOR

    if math.abs(newY - self.targetY) < LERP_THRESHOLD then
      newY = self.targetY
      self:stopLerp()
    end

    self.scrollView._view.y = newY

    if not self.draggingHandle and self.scrollableRatio then
      self:syncHandlePosition()
    end
  end

  self.lerpListener = onFrame
  Runtime:addEventListener('enterFrame', onFrame)
end

function Scroller:handleToContentY(handleY)
  local handle = self.scrollbar.handle
  local ratio = (handleY - handle.min) / (handle.max - handle.min)
  local scrollableHeight = self.currentScrollHeight - self.options.height
  return -ratio * scrollableHeight
end

function Scroller:enableMouseScroll()
  if self.mouseScrollEnabled then return end
  self.mouseScrollEnabled = true

  self.onMouseWheel = function(event)
    if not self.scrollView then return end

    if not self.targetY then
      self.targetY = self.scrollView._view.y
    end

    self.targetY = self:clampContentY(self.targetY - event.scrollY * SCROLL_SPEED)
    self:startLerp()
  end

  self.onHandleDrag = function(event)
    local handle = event.target

    if event.phase == 'began' then
      display.getCurrentStage():setFocus(handle)
      handle.markY = handle.y
      handle.dragging = true
      self.draggingHandle = true

    elseif event.phase == 'moved' and handle.dragging then
      local newHandleY = handle.markY + (event.y - event.yStart)
      if newHandleY < handle.min then newHandleY = handle.min end
      if newHandleY > handle.max then newHandleY = handle.max end
      handle.y = newHandleY

      self.targetY = self:handleToContentY(newHandleY)
      self:startLerp()

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
      display.getCurrentStage():setFocus(nil)
      handle.dragging = false
      self.draggingHandle = false
    end

    return true
  end

  Runtime:addEventListener('mouse', self.onMouseWheel)

  if self.scrollbar and self.scrollbar.handle then
    self.scrollbar.handle:addEventListener('touch', self.onHandleDrag)
  end
end

function Scroller:disableMouseScroll()
  if not self.mouseScrollEnabled then return end
  self.mouseScrollEnabled = false

  Runtime:removeEventListener('mouse', self.onMouseWheel)

  if self.scrollbar and self.scrollbar.handle then
    self.scrollbar.handle:removeEventListener('touch', self.onHandleDrag)
  end

  self:stopLerp()
  self.onMouseWheel = nil
  self.onHandleDrag = nil
  self.draggingHandle = false
end

--------------------------------------------------------------------------------

return Scroller
