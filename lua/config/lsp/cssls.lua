
local path = require('config.path')
local fs      = require('util.fs')

local server = { name = 'cssls' }

local root = fs.join(path.lsp, server.name)

---@type vim.lsp.Config
server.config = {
  cmd = {
    fs.join(root, "vscode-css-language-server"), "--stdio"
  },
  filetypes = { "css", "scss", "less" },
  init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
  root_markers = { "package.json", ".git" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}


return server
