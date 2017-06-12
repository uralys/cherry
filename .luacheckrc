stds.corona = {
  read_globals = {
    'audio',
    'composer',
    'display',
    'easing',
    'graphics',
    math = {fields = {round = {}}},
    'native',
    'network',
    'Runtime',
    'system',
    'timer',
    'transition',
    'widget'
  }
}

stds.cherry = {
  globals = {
    'App',
    'Camera',
    'CBE',
    'Effects',
    'Game',
    'Router',
    'Sound',
    string = {fields = {
        endsWith = {},
        startsWith = {}
    }}
  }
}

std = 'min+corona+cherry'
ignore = {'212'}
files['test'] = {std = '+busted'}
exclude_files = {'lua_install/*'}
