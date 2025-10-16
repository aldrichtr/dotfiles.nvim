
local path = require('util.path')

LspLuaLs = class('LspLuaLs')


--TODO: I need to add a name field so we can use that
-- when we call vim.lsp.configure[<name>]


function LspLuaLs:initialize()
  self.name = 'luals'
end

function LspLuaLs:configure()
  local config = {
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

  vim.lsp.config(self.name, config)
end

function LspLuaLs:enable()
  vim.lsp.enable(self.name)
end

return LspLuaLs
