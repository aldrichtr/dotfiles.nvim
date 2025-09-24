---@class LazyPlugin
local M = {
  'xiantang/darcula-dark.nvim',
}

M.name = 'darcula'

M.opts = {
  opt = {
    integrations = {
      telescope = false,
      lualine = true,
      lsp_semantics_token = true,
      nvim_cmp = true,
      dap_nvim = true,
    },
  },
}

return M
