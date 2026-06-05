
local path = require('config.path')
local fs      = require('util.fs')

local server = { name = 'lua_ls' }
local root = fs.join(path.lsp, server.name)

---@type vim.lsp.config
server.config = {
  cmd = { fs.join(root, "bin", "lua-language-server.exe") },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json", ".luarc.jsonc",
    ".stylua.toml", "stylua.toml",
  },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim", "log", "Logger", "class" },
      },
    },
  },
}

return server
