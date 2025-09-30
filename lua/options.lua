
local path = require('util.path')
---@class Config.Options
---@param packages Package configuration settings to be sent to the package manager
---@param ui User Interface settings such as the colorscheme and fonts
local ConfigOptions = {}

ConfigOptions.manager = {
  use = 'lazy',
  -- where packages will be installed to
  root = path.join(path.data, 'lazy'),
  -- these options affect the installation of lazy.nvim and are only used on
  -- new installs of lazy.nvim
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  },
  -- these options will be passed to the lazy.setup() function
  setup = {
    -- see https://lazy.folke.io/configuration for all options
    spec = require('config.packages'),
    lockfile = path.join(path.data, '/lazy-lock.json')
  }
}

ConfigOptions.ui = {
  colors = {
    colorscheme = 'habamax'
  },
  fonts = {
    gui = 'Cousine Nerd Font Mono:h12'
  }
}


return ConfigOptions
