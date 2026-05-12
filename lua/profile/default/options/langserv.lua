local path = require("util.path")

---@type ManagerOptions
local M = {
  use = "lsp",
  install = {},
  -- This is where language servers are installed
  target = path.lsp.root,
  source = {path.join(path.lua, "profile", "default", "servers")},
  setup = {},
}

return M
