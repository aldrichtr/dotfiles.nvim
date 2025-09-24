-- TODO: I'm not sure what benefit this gives me over the lspconfig
local M = {
  'TheLeoP/powershell.nvim',
}
M.cond = false

M.opts = {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  bundle_path = '',
  init_options = vim.empty_dict(),
  settings = vim.empty_dict(),
  shell = 'pwsh',
  --handlers = require('powershell.handlers'), -- see lua/powershell/handlers.lua
  root_dir = function(buf)
    return vim.fs.dirname(
      vim.fs.find({ '.git' }, { upward = true, path = vim.fs.dirname(vim.api.nvim_buf_get_name(buf)) })[1]
    )
  end,
}

return M
