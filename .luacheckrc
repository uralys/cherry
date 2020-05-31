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
    'math',
    'Router',
    'string',
    'table',
    'unpack',
    'FULL_W',
    'FULL_H',
    'W',
    'H',
    'TOP',
    'BOTTOM'
  }
}

std = 'min+corona+cherry'
ignore = {'212'}
files['test'] = {std = '+busted'}
exclude_files = {'.rocks/*', 'lua_install_travis_folder'}
