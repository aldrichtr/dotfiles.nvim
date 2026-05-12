
local path = require('util.path')

---@type ManagerOptions
local M = {
  use = "lazy",
  -- these options affect the installation of lazy.nvim and are only used on
  -- new installs of lazy.nvim
  install = {
    repo = "https://github.com/folke/lazy.nvim.git",
    -- install lazy.nvim along side other package
    path = path.join(path.data, "lazy", "lazy.nvim"),
    check = path.join(path.data, "lazy", "lazy.nvim", ".git"),
  },
  -- where packages will be installed to
  target = path.join(path.data, "lazy"),
  source = { "before", "themes", "setup", "after" },
  -- these options will be passed to the lazy.setup() function
  setup = {
    -- see https://lazy.folke.io/configuration for all options
    spec = {},
    lockfile = path.join(path.data, "/lazy-lock.json"),
  }
}

return M
