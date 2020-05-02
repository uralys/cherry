# ENV

env variables are placed within `App.env`.

## default Cherry variables

- `SHOW_TOUCHABLES = false`
- `SOUND_OFF = false`

Override them in your `App.start(options)`

```lua
{options = {env = {"SOUND_OFF": true}}}
```

## usage

```lua
if(App.env.SOUND_OFF) then ... end
if(App.env.YOUR_CUSTOM_VAR) then ... end
```

## custom variables, custom env

you should create a `src/env.lua` and choose the ENV from it.

example:

```lua
return {
  DEVELOPMENT = {
    name = 'development',
    -- Cherry overrides
    SOUND_OFF = true,
    -- Custom
    INVINCIBLE = true,
  },
  PRODUCTION = {
    name = 'production'
    -- Custom
    INVINCIBLE = false
  }
}

```

then require your `env` to set the chosen one in your start options:

```lua
local env = require 'src/env.lua'
App.start({env = env.PRODUCTION})
```
