stds.corona = {
  globals = {
    'system'
  },
  read_globals = {
    'audio',
    'composer',
    'display',
    'easing',
    'graphics',
    'native',
    'network',
    'Runtime',
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
    'math',
    'Router',
    'Sound',
    'string',
    'table',
    'unpack'
  }
}

std = 'min+corona+cherry'
ignore = {'212'}
files['test'] = {std = '+busted'}
exclude_files = {'modules/*'}
