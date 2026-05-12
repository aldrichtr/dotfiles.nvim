local M = { name = "cssls" }

function M.config(user_config)
  ---@type vim.lsp.Config
  local settings = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
    root_markers = { "package.json", ".git" },
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  }
  return settings
end

return M
