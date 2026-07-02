
local M = {
  'stevearc/conform.nvim',
}

M.event = { 'BufWritePre' }

M.cmd = { 'ConformInfo' }

M.opts = {
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
  },
  default_format_opts = {
    async = true,
    lsp_format = 'fallback',
  },
  format_on_save = { timeout_ms = 500 },
}

M.keys = {
  { '<M-F>', function() require('conform').format() end,
    mode = { 'i', 'n', 'v' }, desc = 'Format buffer or selection with conform',
  },
  { '<leader>=', function() require('conform').format() end,
    desc = 'Format document with conform',
    mode = { 'n' },
  },
  { '=', function() require('conform').format() end,
    desc = 'Format range with conform',
    mode = { 'v' },
  },
}

return M
