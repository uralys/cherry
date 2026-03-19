# Scroller

Vertical scroller with custom scrollbar, mouse wheel support and draggable handle with lerp interpolation.

## Assets

Required images in `cherry/assets/images/gui/scroller/`:

- `scroll.base.png` : scrollbar track
- `scroll.handle.png` : scrollbar handle

## API

### Scroller:new(options)

Creates a new scroller instance.

```lua
local Scroller = require 'cherry.components.scroller'

local scroller = Scroller:new({
  parent = self.view,
  top = 50,
  left = 100,
  width = 400,
  height = 600,
  gap = 20,
  horizontalScrollDisabled = true,
  verticalScrollDisabled = true,
  hideBackground = true,
  backgroundColor = {0, 0, 0, 0.5},
  handleHeight = 50
})
```

**Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `parent` | DisplayGroup | required | Parent display group |
| `top` | number | required | Y position of the scroll area |
| `left` | number | required | X position of the scroll area |
| `width` | number | required | Width of the scroll area |
| `height` | number | required | Height of the visible area |
| `gap` | number | `0` | Vertical spacing between children |
| `horizontalScrollDisabled` | boolean | `nil` | Disable horizontal touch scroll |
| `verticalScrollDisabled` | boolean | `nil` | Disable vertical touch scroll |
| `hideBackground` | boolean | `nil` | Hide the scrollview background |
| `backgroundColor` | table | `{0, 0, 0, 0.5}` | Background color RGBA |
| `handleHeight` | number | auto | Fixed handle height (auto-calculated from content ratio if omitted) |

### scroller:insert(child, options)

Inserts a display object into the scroller. Children are stacked vertically with `gap` spacing.

```lua
local item = display.newGroup()
scroller:insert(item)
```

### scroller:remove(child)

Removes a child from the scroller.

### scroller:removeChildren()

Removes all children and resets scroll position.

### scroller:destroy()

Cleans up the scroller, scrollbar, and all listeners.

### scroller:enableMouseScroll()

Enables mouse wheel scrolling and draggable scrollbar handle.

- **Mouse wheel**: smooth scroll with lerp interpolation
- **Handle drag**: proportional content positioning with lerp

### scroller:disableMouseScroll()

Disables mouse wheel and handle drag listeners, stops any ongoing lerp.

## Usage example

A typical Composer screen using a Scroller with mouse scroll:

```lua
local composer = require 'composer'
local Scroller = require 'cherry.components.scroller'

local scene = composer.newScene()
local scroller

function scene:show(event)
  if event.phase == 'did' then
    scroller = Scroller:new({
      parent = self.view,
      top = 50,
      left = 30,
      width = display.contentWidth * 0.8,
      height = display.contentHeight * 0.85,
      gap = 20,
      horizontalScrollDisabled = true,
      verticalScrollDisabled = true,
      hideBackground = true
    })

    for i = 1, 10 do
      local item = display.newRect(0, 0, 300, 100)
      scroller:insert(item)
    end

    scroller:enableMouseScroll()
  end
end

function scene:hide(event)
  if event.phase == 'did' then
    scroller:disableMouseScroll()
    scroller:destroy()
  end
end
```

## Internals

The mouse scroll system uses `enterFrame` lerp rather than `scrollToPosition`:

- Each mouse wheel event accumulates into a `targetY`
- An `enterFrame` listener interpolates `currentY` toward `targetY` (factor: `0.15`)
- The lerp stops when distance to target is under `0.5px`
- Handle drag sets `targetY` proportionally from the handle position and reuses the same lerp
- During handle drag, `syncHandlePosition` is skipped to avoid fighting the drag
