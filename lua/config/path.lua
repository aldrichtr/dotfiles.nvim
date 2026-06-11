

local fs = require('util.fs')

local Path = {
  std = {
    config      = fs.normalize(vim.fn.stdpath('config')),
    cache       = fs.normalize(vim.fn.stdpath('cache')),
    config_dirs = vim.fn.stdpath('config_dirs'),
    data        = fs.normalize(vim.fn.stdpath('data')),
    data_dirs   = vim.fn.stdpath('data_dirs'),
    log         = fs.normalize(vim.fn.stdpath('log')),
    run         = fs.normalize(vim.fn.stdpath('run')),
    state       = fs.normalize(vim.fn.stdpath('state'))
  },

  -- This is neovim's configuration directory, where init.lua lives
  -- $env:XDG_USER_CONFIG_DIR/nvim
  init = fs.normalize(vim.fn.stdpath('config')),

  -- This is neovim's local directory, where packages, tools, and libraries are stored
  -- $env:XDG_USER_DATA_DIR/nvim-data
  data = fs.normalize(vim.fn.stdpath('data')),

  -- Environmental paths (windows though)
  AppData      = fs.normalize(vim.env.APPDATA),
  LocalAppData = fs.normalize(vim.env.LOCALAPPDATA),
  Home         = fs.normalize(vim.env.HOME),
  Programs     = fs.normalize('c:/programs')
}

Path.dotfiles = fs.join(Path.Home, '.dotfiles')

Path.lua = fs.join(Path.init, 'lua')
-- This might be confusing because it seems like stdpath('config') should be `config`
-- but it is the path to the main config of my init `lua/config`
Path.config = fs.join(Path.lua, 'config')

Path.lsp = fs.join(Path.LocalAppData, 'lsp')
Path.logs = fs.join(Path.data, 'logs')

Path.mason = {
  packages = fs.join(Path.LocalAppData, 'mason', 'packages'),
  bin = fs.join(Path.LocalAppData, 'mason', 'bin')
}


return Path
