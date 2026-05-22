local path = require('util.path')

---@class LazySpec
local M = {
  'L3MON4D3/LuaSnip',
}
M.version = 'v2.*'
-- jsregexp is installed via luarocks, so we dont need to build it here
M.build = false

M.config = function()
  local lua = require('luasnip.loaders.from_lua')
  -- TODO: I want to get this from the options, but this file is required
  --       by options and so it causes a loop to require options here
  local root = path.join(path.lua, 'snippets')

  -- load json format "vscode style" snippets

  -- load lua format "luasnip native" snippets
  lua.lazy_load({ paths = root })
end



return M
