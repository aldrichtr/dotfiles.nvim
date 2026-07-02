
local M = {
  name = 'lua_ls',
}

M.config = {
  cmd = { 'lua-language-server.cmd' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.stylua.toml',
    'stylua.toml',
  },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      diagnostics = {
        globals = { 'vim', 'log', 'Logger', 'class' },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
}

return M
