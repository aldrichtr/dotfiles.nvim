local M = {
  'neovim/nvim-lspconfig',
}

M.event = 'BufReadPre'

M.dependencies = {
  'antosha417/nvim-lsp-file-operations',
}

M.config = function()
  local lspconfig = require('lspconfig')
  local file_ops = require('lsp-file-operations')

  local lspconfig_defaults = require('lspconfig').util.default_config
  lspconfig_defaults.capabilities =
    vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

  require('lsp.pses').setup()
  require('lsp.luals').setup()
  require('lsp.rust_analyzer').setup()
--  require('lsp.clojure').setup()
end

return M
