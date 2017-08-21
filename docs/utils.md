### onTap

Use `onTap` on any displayObject to apply a function as soon as a finger **touches** your object.

```lua
local button = display.newImage(
    'cherry/assets/images/gui/items/circle.simple.container.png',
    0, 0
)

gesture.onTap(button, function()
    print('tap !')
end)
```

Applying an other `onTap` on your object will remove the first listener.

You may remove the previous listener manually by calling `removeOnTap` on your object.

```lua
button.removeOnTap()
```

### onTouch

Use `onTouch` on any displayObject to apply a function when finger that touched your object is **lifted up** from the screen.


```lua
local button = display.newImage(
    'cherry/assets/images/gui/items/circle.simple.container.png',
    0, 0
)

gesture.onTouch(button, function()
    print('touch !')
end)
```

Applying an other `onTouch` on your object will remove the first listener.

You may remove the previous listener manually by calling `removeOnTouch` on your object.

```lua
button.removeOnTouch()
```
