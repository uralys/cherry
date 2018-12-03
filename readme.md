# Cherry.lua

[![Build Status](https://travis-ci.com/chrisdugne/cherry.svg?branch=master)](https://travis-ci.com/chrisdugne/cherry)
[![codecov](https://codecov.io/gh/chrisdugne/cherry/branch/master/graph/badge.svg)](https://codecov.io/gh/chrisdugne/cherry)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-green.svg?colorB=3cc712)](LICENSE)
[![GitHub release](https://img.shields.io/github/release/chrisdugne/cherry.svg)](Release)

Cherry is a starter for `CoronaSDK App` to help building your game.

- [Introduction](#introduction-to-cherry)
- [Usage](#usage)
- [Libraries](#libraries)
- [Starters](#starters)
- [Components](#components)
- [Music and Sounds](#music-and-sounds)
- [License](#bsd-license)
- [Third Parties](#third-parties)
- [Games using Cherry](#games-using-cherry)

![cherry](/docs/assets/cherry.png)

## Introduction to Cherry

You may extend Cherry framework, or just pick few components, in order to start your own game.

#### Installation

- clone Cherry next to your project
- symlink the lib to your project root:

```
> ln -s ../Cherry/cherry cherry
```

- add a `main.lua` with

```lua
-- main.lua
require 'cherry.main'
require 'src.app'
```

- add a `src/app.lua`
- then call `App.start()` with your options

```lua
-- src/app.lua
App:start({
  name    = 'YourGame',
  version = '1.0',
})
```

- add a `env/development.json`

```json
{
  "silent": true,
  "invincible": true,
  "view-testing": "playground"
}
```

see env settings for more options.

A typical tree should be :

```sh
├── Cherry
│   ├── cherry
│   │   ├── assets
│   │   │   ├── images
│   │   │   └── sounds
│   │   ├── core
│   │   ├── components
│   │   ├── engine
│   │   ├── libs
│   │   └── screens
│   └── test
│
├── YourGame
│   ├── cherry -> ../Cherry/cherry
│   ├── assets
│   │   ├── images
│   │   └── sounds
│   │
│   ├── build.settings
│   ├── config.lua
│   ├── env
│   ├── src
│   │   ├── components
│   │   ├── extensions
│   │   ├── models
│   │   └── screens
│   ├── test
│   └── main.lua
```

## Using Cherry

### Adding a new Screen

A `Screen` implements the [Composer](https://docs.coronalabs.com/daily/api/library/composer/index.html) library.

- Start by creating a new `screen`, for instance duplicate the simplest one `src/screens/Playground.lua`
- Register your new screen in the [Router](https://github.com/chrisdugne/cherry/blob/master/src/Router.lua#L12) : `YOUR_NEW_SCREEN = 'YourNewScreen'`
- Now you can open your screen from anywhere calling :
  `Router:open(Router.YOUR_NEW_SCREEN)`

### Adding a new Model

- Each `model` should implement `new` and `show` functions, for instance read how [Item](https://github.com/chrisdugne/cherry/blob/master/src/game/models/Item.lua) is built.
- Register your model in [main.lua](https://github.com/chrisdugne/cherry/blob/master/main.lua#L55) : `YourModel = require 'game.models.YourModel'`
- Use `YourModel:new()` during the `LevelDrawer` parsing
- Use `YourModel:show()` during the `Game` rendering

## Components

Either use these components within the full workflow or pick them one by one to use it in your own game.

See [documentation](docs/components.md) for the complete components list and options.

## Libraries

See [documentation](docs/libraries.md) for the complete components list and options.

## Tools

- screen **routing**
- game **Camera**
- **touch** controller
- **sound** library (music + effects)
- an API to register **effects** from [CBEffects](https://github.com/GymbylCoding/CBEffects).
- **user** profile and game status
- google **analytics** events (a lot are already plugged in the workflow)

## Music and Sounds

Courtesy of [VelvetCoffee](https://soundcloud.com/velvetcoffee), you may use the samples from `/assets/sounds` for your own game, providing you credit VelvetCoffee for the work and link to :

`https://soundcloud.com/velvetcoffee`

## Local development

### dependencies

Luacheck, busted and luacov are used for the tests and coverage.
install the luarocks using the `Makefile`, they will be created locally within `.rocks/`

Corona SDK [embed Lua 5.1](https://docs.coronalabs.com/guide/start/introLua/index.html) with the apps.
To use native libs from luarocks, you must install and build them for lua 5.1, the move the `.so` to an embed folder as well.
Cherry uses [hererocks](https://github.com/mpeterv/hererocks) to locally use this version.

```bash
> pip install hererocks
```

```sh
> make install
> make test
```

### external dependencies

now you can move your external lib to a path _in_ your app,
and use it, after having modified your `cpath`.

```lua
package.cpath = 'cherry/rocks/lib/lua/5.1/luazen.so;' .. package.cpath
local luazen  = require('luazen')
```

## Tests

UT with busted: http://olivinelabs.com/busted/

```sh
> make test
●●●●●●●●●●●●
50 successes / 0 failures / 0 errors / 0 pending : 0.014314 seconds
```

To display your `_G.log()` use:

```sh
> make test verbose=true
```

## BSD License

You may use Cherry or a part of it in a free or commercial game or app, providing you follow the [BSD](http://www.linfo.org/bsdlicense.html) crediting requirements, provided in the project [LICENSE](https://github.com/chrisdugne/cherry/blob/master/LICENSE)

## Third Parties

- Cherry uses the awesome particle effects provided by [CBEffects](https://github.com/GymbylCoding/CBEffects).
- There are some adapted functions from [Underscore.Lua](https://github.com/mirven/underscore.lua)
- Mobile GUI assets from [GraphicBurger](http://graphicburger.com/mobile-game-gui/)
- Avatars from [Tiny Speck](http://www.glitchthegame.com/public-domain-game-art/)
- [Profile](https://thenounproject.com/search/?q=profile&i=77971) icon designed by [Miguel C Balandrano](https://thenounproject.com/acider/)

## Games using Cherry

- [Phantoms](http://www.uralys.com/projects/phantoms/) released on November 2015 as the actual source for

## game/ui assets

https://www.garagegames.com/community/resources/view/23092

## [todo] Doc to provide

##### waiting for the doc, read the code

- Look in app.App to see what you may override with `App:start(options)`
- Look in engine.Game to see what you may override with `Game:YourStuff()`

##### core

- env files
  simple example: development.json

```
{
    "silent": true,
    "view-testing": "Playground"
}
```

- adding custom screens
- extending/overriding `engine.Game`

##### less important misc

- setting custom bg
- setting custom gravity
- defining colors
- defining analytics ids
- defining facebook ids
- defining ios id
