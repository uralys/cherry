# push notifications

to subscribe to push notifications from FCM, add the list of topics within `App:start(options)`:

```lua
  options = {pushSubscriptions = {'news', 'quest'}}
```

to listen and interact to notifications add a listener:

```lua
local function notificationListener( event )
  _G.log('--------- received data from FCM ---------')
  _G.log({event})

  if ( event.type == 'remote' ) then
      _G.log('--> remote notif')

  elseif ( event.type == 'remoteRegistration' ) then
      -- Code to register your device with the service
      _G.log('Registrated.')

  elseif ( event.type == 'local' ) then
      _G.log('--> local notif')
  end
end

_G.log('Listening...')
Runtime:addEventListener( 'notification', notificationListener )
```
