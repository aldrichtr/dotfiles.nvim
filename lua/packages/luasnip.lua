local M = {
  'L3MON4D3/LuaSnip',
}
M.version = 'v2.*'
-- install jsregexp (optional!).
-- The downloaded make files need a little adjusting to work, so
-- the build command calls a powershell script that does the compilation
M.build = '& ' .. vim.fn.stdpath('config') .. '/luasnip-build.ps1'

M.init = function()
  local root = vim.fs.joinpath(vim.fn.stdpath('config'), 'snipppets')

  -- load json format "vscode style" snippets
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = {
      vim.fs.joinpath(root, 'vscode'),
    },
  })

  -- load lua format "luasnip native" snippets
  require('luasnip.loaders.from_lua').lazy_load({
      paths = {
        vim.fs.joinpath(root, 'luasnip'),
      },
    })
end

M.opts = {
  keep_roots = true,
  link_roots = true,
  link_children = true,

  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
  -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
  -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
  -- luasnip uses this function to get the currently active filetype.  Use
  -- treesitter for getting the current filetype allows correctly resolving
  -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
  -- ft_func = function() require('luasnip.extras.filetype_functions').from_cursor_pos() end,
}

return M