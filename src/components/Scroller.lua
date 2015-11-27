--------------------------------------------------------------------------------
-- DOC to desc
-- vertical scroller
-- can insert on the fly
-- handle resize/visibility
-- handle listening
-- install src.component
-- install assets
--------------------------------------------------------------------------------
--- todo :
-- remove child
-- test button home to insert profile on the fly
local Scroller = {
    children = {}
}

--------------------------------------------------------------------------------

local widget = widget or require( 'widget' )
local defaultGap = 0

local IDLE      = 0
local RESET     = 1
local THRESHOLD = 10

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function Scroller:new(options)
    self.options = options

    self:reset()
    self:prepareScrollView()
    self:scrollbarBase()
    self:scrollbarHandle()

    return self
end

--------------------------------------------------------------------------------

function Scroller:destroy()
    self:removeAll()
    display.remove(self.scrollView)
    display.remove(self.scrollbar)
end

--------------------------------------------------------------------------------

function Scroller:reset()
    self.handleWatcher = IDLE
    self.scrolling     = false
    self.children      = {}
    self.options.gap   = self.options.gap or defaultGap
end

--------------------------------------------------------------------------------

function Scroller:insert(child)
    child.x = self.options.width/2
    child.y = self:contentHeight() + child.height/2 + self.options.gap
    self.children[#self.children + 1] = child
    self.scrollView:insert(child)

    self:refreshHandle()
    self:refreshContentHeight()
    return child
end

function Scroller:remove(child)
    local index = 1
    for k,c in pairs(self.children) do
        if(self.children[k] == child) then
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

function Scroller:removeAll()
    self.scrollView._view.y = 0
    local n = #self.children
    for i=1, n do
        self:remove(self.children[1])
    end
end

--------------------------------------------------------------------------------

function Scroller:hideScrollbar()
    self.scrollbar.base.alpha = 0
    self.scrollbar.handle.alpha = 0
end

function Scroller:showScrollbar()
    self.scrollbar.base.alpha = 1
    self.scrollbar.handle.alpha = 1
end

--------------------------------------------------------------------------------
-- Display elements
--------------------------------------------------------------------------------

function Scroller:prepareScrollView()
    self.scrollView = widget.newScrollView({
        top                      = self.options.top,
        left                     = self.options.left,
        width                    = self.options.width,
        height                   = self.options.height,
        scrollWidth              = 0,
        scrollHeight             = 0,
        horizontalScrollDisabled = self.options.horizontalScrollDisabled,
        hideBackground           = self.options.hideBackground,
        hideScrollBar            = true,
        listener                 = function(event) self:listen(event) end
    })

    self.currentScrollHeight = 0
    self.currentScrollWidth  = 0

    self.options.parent:insert(self.scrollView)
end

--------------------------------------------------------------------------------

function Scroller:scrollbarBase()
    self.scrollbar   = display.newGroup()
    self.scrollbar.x = self.options.left + self.options.width
    self.scrollbar.y = self.options.top
    self.options.parent:insert(self.scrollbar)

    self.scrollbar.base = display.newImageRect(
        self.scrollbar,
        'assets/images/gui/scroller/scroll.base.png',
        20, self.options.height*0.8
    )

    self.scrollbar.base.x = 0
    self.scrollbar.base.y = self.options.height*0.5
end

--------------------------------------------------------------------------------

function Scroller:scrollbarHandle()
    self.scrollbar.handle = display.newImageRect(
        self.scrollbar,
        'assets/images/gui/scroller/scroll.handle.png',
        20, 0
    )

    self:refreshHandle()
end

function Scroller:refreshHandle()
    local totalHeight = self:contentHeight()
    local height = 0

    if(totalHeight == 0) then
        self:hideScrollbar()
        return
    end

    -- the handle height may be fixed as option.handleHeight
    if(self.options.handleHeight) then
        height = self.options.handleHeight
        self:showScrollbar()
    else
        local ratio = self.options.height/totalHeight
        height = self.scrollbar.base.height * ratio

        if(ratio > 1) then
            self:hideScrollbar()
        else
            self:showScrollbar()
        end
    end

    self.scrollbar.handle.height = height
    self.scrollbar.handle.min = self.scrollbar.base.y
                              - self.scrollbar.base.height*0.5
                              + height*0.5

    self.scrollbar.handle.max = self.scrollbar.handle.min
                              + self.scrollbar.base.height
                              - height

    self.scrollbar.handle.x = 0
    self.scrollbar.handle.y = self.scrollbar.handle.min
end

--------------------------------------------------------------------------------
-- Refreshing the scrollbar height depending on the content
--------------------------------------------------------------------------------

function Scroller:refreshContentHeight()
    self.currentScrollHeight = self:contentHeight()
    self.scrollView:setScrollHeight(self.currentScrollHeight)
    self:setRatio()
end

function Scroller:contentHeight()
    local height = 0
    for k,child in pairs(self.children) do
        height = height + child.height + self.options.gap
    end

    return height
end

--------------------------------------------------------------------------------
-- Handle positioning
--------------------------------------------------------------------------------

function Scroller:setRatio()
    if(self.scrollbar.handle.max) then
        local scrollbarHeight  = self.scrollbar.handle.max - self.scrollbar.handle.min
        local scrollableHeight = self.currentScrollHeight - self.options.height
        self.scrollableRatio   = scrollbarHeight/scrollableHeight
    end
end

--------------------------------------------------------------------------------

function Scroller:syncHandlePosition()
    -- sync is cancelled if the scrollview was destroyed
    local destroyed = self.scrollView._view.y == nil
    if(destroyed) then
        self:unbind()
        self:reset()
        return
    end

    self.scrollbar.handle.y = - self.scrollView._view.y * self.scrollableRatio
                              + self.scrollbar.handle.min

    if(self.scrollbar.handle.y > self.scrollbar.handle.max) then
        self.scrollbar.handle.y = self.scrollbar.handle.max
    end

    if(self.scrollbar.handle.y < self.scrollbar.handle.min) then
        self.scrollbar.handle.y = self.scrollbar.handle.min
    end
end

--------------------------------------------------------------------------------

function Scroller:bind(event)

    local alreadyBound = self.handleWatcher and (self.handleWatcher ~= IDLE)
    if(alreadyBound) then
        return
    end

    self.handleWatcher = RESET

    local watch = function(event)
        self:syncHandlePosition()

        local handleHasMoved = self.previousHandleY ~= self.scrollbar.handle.y
        self.previousHandleY = self.scrollbar.handle.y

        if( handleHasMoved ) then
            self.handleWatcher = RESET
        else
            if((not self.scrolling) and (self.handleWatcher > THRESHOLD) ) then
                self:unbind()
            else
                self.handleWatcher = self.handleWatcher + 1
            end
        end
    end

    Runtime:addEventListener( 'enterFrame', watch )

    return function ()
        self.handleWatcher = IDLE
        Runtime:removeEventListener( 'enterFrame', watch )
    end
end

function Scroller:unbind ()
    self._unbind()
end

function Scroller:setUnbind (_unbind)
    self._unbind = _unbind
end

--------------------------------------------------------------------------------

function Scroller:listen(event)
    if ( event.phase == 'began' ) then
        self.scrolling = true
        local _unbind = self:bind()
        if(_unbind) then
            self:setUnbind(_unbind)
        end

    elseif ( event.phase == 'ended' ) then
        self.scrolling = false

        -- https://github.com/chrisdugne/phantoms/issues/37
        -- if(self.onBottomReached) then
        --     self.onBottomReached()
        -- end

    end
    return true
end

--------------------------------------------------------------------------------

return Scroller
