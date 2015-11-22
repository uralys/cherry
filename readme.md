
## Cherry.lua
Cherry is the `CoronaSDK App` starter for [Uralys](http://uralys.com/games) mobile games provided as a ready-to go Corona Application.

![cherry](/docs/cherry.jpg)

You may use Cherry as a base to start your own game, with the following facilities:

#### Game worflow

Avoid developing your screens by using many pre-defined screens to go straight to the point :

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

Either use these components within the full workflow or pick them one by one to use it in your own game :

- Focus
- Progress Bar
- Scroller

See [below](#components-documentation) for the complete documentation for each component.

## Music and Sounds

Courtesy of [VelvetCoffee](https://soundcloud.com/velvetcoffee), you may use the samples from `/assets/sounds` for your own game, providing you credit VelvetCoffee for the work and link to :

`https://soundcloud.com/velvetcoffee`

## Adding a new View

A View implements the [Composer](https://docs.coronalabs.com/daily/api/library/composer/index.html) library.

- Start by creating a new `view`, for instance duplicate the simplest one `src/views/Playground.lua`
- Register your new view in the [Router](https://github.com/chrisdugne/cherry/blob/master/src/Router.lua#L12)  : `YOUR_NEW_VIEW = 'YourNewView'`
- Now you can open your view from anywhere calling :
    `Router:open(Router.YOUR_NEW_VIEW)`

## Adding a new Model
- Each `model` should implement `new` and `show` functions, read how [Item](https://github.com/chrisdugne/cherry/blob/master/src/game/models/Item.lua) is built.
- Register your model in [main.lua](https://github.com/chrisdugne/cherry/blob/master/main.lua#L55) : `YourModel = require 'src.game.models.YourModel'`
- Use `YourModel:new()` during the `LevelDrawer` parsing
- Use `YourModel:show()` during the `Game` rendering

## Components Documentation

## BSD License
You may use Cherry or a part of it in a free or commercial game or app, providing you follow the [license](http://www.linfo.org/bsdlicense.html) crediting requirements.

## Third Parties

- Cherry uses the awesome particle effects provided by [CBEffects](https://github.com/GymbylCoding/CBEffects).
- There are some adapted functions from [Underscore.Lua](https://github.com/mirven/underscore.lua)
- Mobile GUI assets from [GraphicBurger](http://graphicburger.com/mobile-game-gui/)
- Avatars from [Tiny Speck](http://www.glitchthegame.com/public-domain-game-art/)
- [Profile](https://thenounproject.com/search/?q=profile&i=77971) icon designed by [Miguel C Balandrano](https://thenounproject.com/acider/)
