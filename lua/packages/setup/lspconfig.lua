local M = {
  'neovim/nvim-lspconfig',
}

M.event = 'BufReadPre'

M.dependencies = {
  'antosha417/nvim-lsp-file-operations',
}

M.config = function()
end

return M
