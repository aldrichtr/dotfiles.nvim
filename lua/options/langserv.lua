local path = require("util.path")

---@type ManagerOptions
local M = {
  use = "lsp",
  install = {},
  -- This is where language servers are installed
  target = path.lsp.root,
  -- This is where the lsp config modules are 'config/lsp'
  source = {path.join(path.config, "langserv")},
  setup = {},
}

return M
