
## Cherry.lua

Cherry is the `CoronaSDK App` starter for [Uralys](http://uralys.com/games) mobile games provided as a preset Corona Game.

You may use Cherry as a base to start your own game, with the following facilities:

- [Introduction](#introduction-to-cherry)
- [Usage](#usage)
- [Components](#components-documentation)
- [Music and Sounds](#music-and-sounds)
- [License](#bsd-license)
- [Third Parties](#third-parties)

![cherry](/docs/cherry.jpg)

## Introduction to Cherry

#### Game worflow

Avoid developing your screens by using many pre-defined `screens` to go straight to the point :

- Home + Options
- Level Selection
- Playground
- Score
- Profiles
- Credits

#### Libraries

Many libraries to provide easy tooling for your app :

- screen **routing**
- game **Camera**
- **touch** controller
- **sound** library (music + effects)
- a sublevel to register **effects** from [CBEffects](https://github.com/GymbylCoding/CBEffects).
- **user** profile and game status
- google **analytics** events (a lot are already plugged in the workflow)

#### Components

Either use these components within the full workflow or pick them one by one to use it in your own game.

See [below](#components-documentation) for the complete list and documentation for each component.

## Usage

#### Adding a new Screen

A `Screen` implements the [Composer](https://docs.coronalabs.com/daily/api/library/composer/index.html) library.

- Start by creating a new `screen`, for instance duplicate the simplest one `src/screens/Playground.lua`
- Register your new screen in the [Router](https://github.com/chrisdugne/cherry/blob/master/src/Router.lua#L12)  : `YOUR_NEW_SCREEN = 'YourNewScreen'`
- Now you can open your screen from anywhere calling :
    `Router:open(Router.YOUR_NEW_SCREEN)`

#### Adding a new Model
- Each `model` should implement `new` and `show` functions, for instance read how [Item](https://github.com/chrisdugne/cherry/blob/master/src/game/models/Item.lua) is built.
- Register your model in [main.lua](https://github.com/chrisdugne/cherry/blob/master/main.lua#L55) : `YourModel = require 'src.game.models.YourModel'`
- Use `YourModel:new()` during the `LevelDrawer` parsing
- Use `YourModel:show()` during the `Game` rendering

## Components Documentation

#### ProgressBar

An animated progress bar.

![progress-bar](/docs/progress-bar.png)

##### Requirements

- Code : copy and require `src/components/ProgressBar.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L45) in Cherry) and `src/components/Icon.lua`

- assets : you need to copy the assets from `assets/images/gui/progress-bar` (and credit GraphicBurger see [Third Parties](#third-parties))

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

Apply animated arrows tso focus any DisplayObject.
You can choose one to 4 arrows, `showing` your item or `from` your item.

##### Requirements

- Code : copy and require `src/components/Focus.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L48) in Cherry).

- assets : you need to copy the assets from `assets/images/gui/items/arrow.right.png` (and credit GraphicBurger see [Third Parties](#third-parties))

##### API

The simplest focus :
```
Focus(item, true)
```

![default-focus](/docs/default-focus.png)

Choose arrow positions : set `all` to false, and set the ones you want in `[up, down, left, right]`
```
Focus(item, {
    all    = false,
    bottom = true,
    up     = true
})
```

![up-bottom-focus](/docs/up-bottom-focus.png)

Choose arrow ways : set `type` to `from-center` or `show-center` (default)
```
Focus(item, {
    all   = false,
    right = true,
    type  = 'from-center'
})
```

![right-from-center-focus](/docs/right-from-center-focus.png)

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

![special-focus](/docs/special-focus.png)

#### Scroller

A custom ScrollView with an API to add and remove elements, and, *wait for it...* an animated attached `scrollbar` !

![scroller](/docs/scroller.png)

##### Requirements

- Code : copy and require `src/components/Scroller.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L46) in Cherry)

- assets : you need to copy the assets from `assets/images/gui/scroller` (and credit GraphicBurger see [Third Parties](#third-parties))

##### API

Init a Scroller with the same parameters than [`ScrollView`](https://docs.coronalabs.com/api/library/widget/newScrollView.html)

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
- copy and require `src/components/Background.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L38) in Cherry)
- Background:init() at your [App startup](https://github.com/chrisdugne/cherry/blob/master/src/App.lua#L45) to prepare your 2 pictures.
- use `Background:darken()` and `Background:lighten()` wherever you need in your app to switch modes.

## Music and Sounds

Courtesy of [VelvetCoffee](https://soundcloud.com/velvetcoffee), you may use the samples from `/assets/sounds` for your own game, providing you credit VelvetCoffee for the work and link to :

`https://soundcloud.com/velvetcoffee`

## BSD License
You may use Cherry or a part of it in a free or commercial game or app, providing you follow the [BSD](http://www.linfo.org/bsdlicense.html) crediting requirements, provided in the project [LICENSE](https://github.com/chrisdugne/cherry/blob/master/LICENSE)

## Third Parties

- Cherry uses the awesome particle effects provided by [CBEffects](https://github.com/GymbylCoding/CBEffects).
- There are some adapted functions from [Underscore.Lua](https://github.com/mirven/underscore.lua)
- Mobile GUI assets from [GraphicBurger](http://graphicburger.com/mobile-game-gui/)
- Avatars from [Tiny Speck](http://www.glitchthegame.com/public-domain-game-art/)
- [Profile](https://thenounproject.com/search/?q=profile&i=77971) icon designed by [Miguel C Balandrano](https://thenounproject.com/acider/)
