
local path = require('config.path')
local fs   = require('util.fs')

local server = { name = 'omnisharp' }
local root = fs.join(path.lsp, server.name)

  ---@type vim.lsp.Config
server.config = {
  cmd = {
    fs.join(root, "omnisharp.exe"),
    "-z",
    "--hostPID",
    vim.fn.getpid(),
    "'DotNet:enablePackageRestore=false'",
    "--encoding",
    "utf-8",
    "--languageserver",
  },
  filetypes = { "cs", "vb" },
  settings = {
    FormattingOptions = {
      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      EnableEditorConfigSupport = true
    }
  }
}

return server
