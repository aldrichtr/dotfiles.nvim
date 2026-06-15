
local M = {
  name = "lua_ls",
}

M.config = {
  cmd = { "lua-language-server.cmd" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "stylua.toml",
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

return M
