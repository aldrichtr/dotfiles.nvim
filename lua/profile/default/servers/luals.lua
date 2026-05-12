
local path = require('util.path')

local M = { name = 'lua_ls' }

function M.config(user_config)
  return {
    cmd = { path.join(path.lsp.lua, 'bin', 'lua-language-server.exe') },
    filetypes = { 'lua' },
    root_markers = {'.luarc.json', '.luarc.jsonc'},
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          globals = { 'vim', 'log', 'class' }
        }
      }
    }
  }
end

return M
