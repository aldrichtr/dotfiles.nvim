
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

--[[
-- lsp.servers are just the names of the individual lsp servers.  Currently,
-- config.lsp.enable() uses this name to both configure the server by looking
-- up config.lsp.<servername>, and then calling `vim.lsp.enable(<servername>)`
--
-- Another option would be to require the configurations here and then, modifying
-- the loop in enable() like:
-- ```lua
-- for _, server in servers do
--   local name, config = server[1], server[2]
--   ...
-- ```
--]]
ConfigOptions.lsp = {
  servers = {
    {'luals', {
      cmd = path.join(path.lsp.lua, 'bin', 'lua-language-server.exe'),
      filetypes = { 'lua' },
      root_markers = {'.luarc.json', '.luarc.jsonc'},
      settings = { 
	Lua = {
          runtime = { version = 'LuaJIT' }
        }
      }
    }},
  }
}

return ConfigOptions
