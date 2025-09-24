local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  local server = lspconfig.clojure_lsp

  server.setup({
    -- TODO: This should be added to active_profile:get_options()
    cmd = vim.fs.joinpath(vim.env.LOCALAPPDATA, 'lsp', 'clojure', 'bin', 'clojure_lsp.exe')
  })
end

return M
