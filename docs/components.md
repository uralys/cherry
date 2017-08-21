
## Components Documentation

#### ProgressBar

An animated progress bar.

![progress-bar](/docs/assets/progress-bar.png)

##### Requirements

- Code : copy and require `src/components/ProgressBar.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L45) in Cherry) and `src/components/Icon.lua`

- assets : you need to copy the assets from `_/gui/progress-bar` (and credit GraphicBurger see [Third Parties](#third-parties))

##### API

- init the ProgressBar
```
    local progress = ProgressBar:new()
```

- use parameters to draw the ProgressBar
```
    progress:draw({
        parent = self.display,
        x      = 30,
        y      = 30,
        width  = 200,
        height = 30,
        path   = 'assets/images/game/item/gem.png'
    })
```

- either add the `value` within the previous parameters for a static bar, or init the bar from a startup percentage :
```
    progress:set(0)
```

- then ask the animation to start and reach the required percentage (here 88%)
```
    progress:reach(88)
```

#### Focus

Apply animated arrows to focus any DisplayObject.

You can choose one to 4 arrows, `showing` your item or `from` your item.

##### Requirements

- Code : copy and require `src/components/Focus.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L48) in Cherry).

- assets : you need to copy the assets from `_/gui/items/arrow.right.png` (and credit GraphicBurger see [Third Parties](#third-parties))

##### API

The simplest focus :
```
Focus(item, true)
```

![default-focus](/docs/assets/default-focus.png)

Choose arrow positions : set `all` to false, and set the ones you want in `[up, down, left, right]`
```
Focus(item, {
    all    = false,
    bottom = true,
    up     = true
})
```

![up-bottom-focus](/docs/assets/up-bottom-focus.png)

Choose arrow ways : set `type` to `from-center` or `show-center` (default)
```
Focus(item, {
    all   = false,
    right = true,
    type  = 'from-center'
})
```

![right-from-center-focus](/docs/assets/right-from-center-focus.png)

You can combine focus to place arrows to/from and where you want:
```
    Focus(item, {
        all   = false,
        right = true,
        type  = 'from-center'
    })

    Focus(item, {
        all  = false,
        left = true,
        type = 'show-center'
    })
```

![special-focus](/docs/assets/special-focus.png)

#### Scroller

A custom ScrollView with an API to add and remove elements, and, *wait for it...* an animated attached `scrollbar` !

![scroller](/docs/assets/scroller.png)

##### Requirements

- Code : copy and require `src/components/Scroller.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L46) in Cherry)

- assets : you need to copy the assets from `_/gui/scroller` (and credit GraphicBurger see [Third Parties](#third-parties))

##### API

Init a Scroller with the same parameters as a [`ScrollView`](https://docs.coronalabs.com/api/library/widget/newScrollView.html)

You may add the following parameters :
 - `handleHeight` : if set, your scrollbar height is fixed the value. if not, the height depends on the number of elements you have inserted.
 - `gap` : the height between the elements
```
local scroller = Scroller:new({
    parent                   = self.parent,
    top                      = self.top + 7,
    left                     = self.x - self.width * 0.45,
    width                    = self.width * 0.9,
    height                   = self.height - 22,
    gap                      = display.contentHeight*0.05,
    handleHeight             = display.contentHeight*0.07,
    horizontalScrollDisabled = true,
    hideBackground           = true
})
```

You can now insert/remove whatever you need in the `scroller`, the scrollbar is refreshed dynamically

```
local element = scroller:insert(anyDisplayGroup)
scroller:remove(element)
scroller:removeAll()
```

#### Background

Use 2 background images to switch between `dark` and `light` modes.

##### Requirements

- copy and require `src/components/Background.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L38) in Cherry)

##### API

- Background:init() at your [App startup](https://github.com/chrisdugne/cherry/blob/master/src/App.lua#L45) to prepare your 2 pictures.

- use `Background:darken()` and `Background:lighten()` wherever you need in your app to switch modes.


#### Cooldown
todo, read the code to understand the API
#### Chapters
todo, read the code to understand the API
#### Levels
todo, read the code to understand the API
