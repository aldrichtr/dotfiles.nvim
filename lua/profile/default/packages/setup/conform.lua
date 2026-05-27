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

M.keys = {
  { "<leader>=", function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
    desc = "Format document with conform"}
}

return M