
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

- Code : copy and require `src/components/ProgressBar.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L45) in Cherry) and `src/components/Icon.lua`

- assets : you need to copy the assets from `assets/images/gui/progress-bar` (and credit GraphicBurger see [Third Parties](#third-parties))

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
#### Scroller
#### Background

Use 2 background images to switch between `dark` and `light` modes.
- copy and require `src/components/Background.lua` ([example](https://github.com/chrisdugne/cherry/blob/master/main.lua#L38) in Cherry)
- Background:init() at your [App startup](https://github.com/chrisdugne/cherry/blob/master/src/App.lua#L45) to prepare your 2 pictures.
- use `Background:darken()` and `Background:lighten()` wherever you need in your app to switch modes.

## Music and Sounds

Courtesy of [VelvetCoffee](https://soundcloud.com/velvetcoffee), you may use the samples from `/assets/sounds` for your own game, providing you credit VelvetCoffee for the work and link to :

`https://soundcloud.com/velvetcoffee`

## BSD License
You may use Cherry or a part of it in a free or commercial game or app, providing you follow the [license](http://www.linfo.org/bsdlicense.html) crediting requirements.

## Third Parties

- Cherry uses the awesome particle effects provided by [CBEffects](https://github.com/GymbylCoding/CBEffects).
- There are some adapted functions from [Underscore.Lua](https://github.com/mirven/underscore.lua)
- Mobile GUI assets from [GraphicBurger](http://graphicburger.com/mobile-game-gui/)
- Avatars from [Tiny Speck](http://www.glitchthegame.com/public-domain-game-art/)
- [Profile](https://thenounproject.com/search/?q=profile&i=77971) icon designed by [Miguel C Balandrano](https://thenounproject.com/acider/)
