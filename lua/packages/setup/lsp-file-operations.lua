-- TODO: Annotate this package
local M = {
  "antosha417/nvim-lsp-file-operations",
}
M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-neo-tree/neo-tree.nvim",
}
function M.config()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  local file_ops = require("lsp-file-operations")

  vim.tbl_deep_extend("force", client_capabilities, file_ops.default_capabilities())
end

return M

