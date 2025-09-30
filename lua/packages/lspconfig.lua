local M = {
  'neovim/nvim-lspconfig',
}

M.event = 'BufReadPre'

M.dependencies = {
  'antosha417/nvim-lsp-file-operations',
}

M.config = function()

  local lspconfig_defaults = require('lspconfig').util.default_config
  lspconfig_defaults.capabilities =
    vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())
end

return M
