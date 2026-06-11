

local M = { 'OXY2DEV/helpview.nvim' }

M.lazy = false

M.dependencies = { }

---@type helpview.config
M.opts = {
  preview = {
    enable = true,
    enable_hybrid_mode = true,
    icon_provider = "devicons",
  }
}


return M
