stds.corona = {
  read_globals = {
    'audio',
    'composer',
    'display',
    'easing',
    'graphics',
    'json',
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
    '_',
    'analytics',
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
    }},
    'utils',
    'Vector2D'
  }
}

std = 'min+corona+cherry'
ignore = {'212'}
files['test'] = {std = '+busted'}
