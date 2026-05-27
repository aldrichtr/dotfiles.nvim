local path = require('util.path')

---@class LazySpec
local M = {
  'L3MON4D3/LuaSnip',
}
M.version = 'v2.*'
-- jsregexp is installed via luarocks, so we dont need to build it here
M.build = false

M.opts = {
  enable_autosnippets = true,
  store_selection_keys = "<Tab>"
}

M.config = function()
  local loader = require('luasnip.loaders.from_lua')
  local root = path.join(path.init , 'snippets')

  loader.lazy_load({ paths = root })

  -- TODO: Gross.  I'd like to use the `keys` field for this.
  vim.cmd[[
  " Use Tab to expand and jump through snippets
  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
  smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

  " Use Shift-Tab to jump backwards through snippets
  imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
  smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
  ]]

end

return M
