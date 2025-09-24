local M = {
  'stevearc/conform.nvim'
}

M.event = { 'BufWritePre' }

M.cmd = { 'ConformInfo' }

M.opts = {
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
  },
}


return M
