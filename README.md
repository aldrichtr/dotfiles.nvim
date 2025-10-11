# My Neovim configuration

```
lua
├───config     <-- Main configuration scripts
│   ├───after
│   ├───before
│   ├───lsp
│   └───setup
├───manager    <-- Package managers such as lazy or mason
├───packages   <-- Lazy plugin secs
│   ├───after
│   ├───before
│   ├───disabled
│   ├───setup
│   └───themes
└───util       <-- My custom functions that support init
    └───class
```
## Initialization flow

Neovim loads `init.el`, which adds the `util.log` to the Global table, rather
than requiring it from basically every file.
``` lua
_G.log = require('util.log')
```

### Options

The next to be loaded is the `options` module.  It is a plain lua table, and I
have been moving frequently changed settings like fonts, colors, etc.  That
table gets passed to most of the other modules which use them to set config
options.  I'm going to continue to move other settings here as I iterate.

``` lua
local options = require('options')
```
The main body of the initialization is in `lua/config`.  Config loads the
subdirectories in the following order, when `apply()` is called:
```
- before         <-- Settings that should be in place before the plugins
- Manager:load() <-- The plugins are loaded and configured
- setup          <-- Settings that should be set after plugins
- after          <-- Settings that should be set after everything else
```

`/lua/config/init` requires all of the files in each of those directories,
so to add any additional settings, just add it either to one of the existing
files or add a new file in one of these folders.  `before` obviously, is where
any settings that must be set before the plugins are loaded.  `setup` is where
most of the files should be placed. Here is how the "Config system" should be
used:
``` lua
local Manager = require('manager.lazy')
local Config = require('config')
local config = Config:new(options)
config.manager = Manager:new(options.manager)
config:apply()
```
## Adding plugins

Any file under `lua/packages` will be loaded (except for those in disabled) by the
*Manager* that is configured (currently [lazy.nvim](https://github.com/folke/lazy.nvim)).
Packages are organized in folders, which are loaded in the folowing order:

- before
- themes
- setup
- after

