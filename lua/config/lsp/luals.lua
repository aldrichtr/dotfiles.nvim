
local path = require('util.path')

local cmp_lsp = require('cmp_nvim_lsp')
local file_ops = require('lsp-file-operations')

local luals = {
    cmd = path.join(path.lsp.lua, 'bin', 'lua-language-server.exe'),

    filetypes = { 'lua' },
    root_markers = {'.luarc.json', '.luarc.jsonc'},
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities(),
      file_ops.default_capabilities()
    ),
    settings.Lua = {
      runtime = { version = 'LuaJIT' }
    }
  }

return luals
