local M = {
  'nvim-treesitter/nvim-treesitter-textobjects',
}

M.branch = 'main'

M.dependencies = {'nvim-treesitter/nvim-treesitter'}

M.keys = function()
  local select = require('nvim-treesitter-textobjects.select').select_textobject
  local keys = {
    {"af", function() select("@function.outer", "textobjects") end,mode = { "x", "o" }, desc = 'Select outer function' },
    {"if", function() select("@function.inner", "textobjects") end, mode = { "x", "o" }, desc = 'Select inner function'},
    {"ac", function() select("@class.outer", "textobjects") end, mode = { "x", "o" }, desc = 'Select outer class'},
    {"ic", function() select("@class.inner", "textobjects") end, mode = { "x", "o" }, desc = 'Select inner class'}
  }
  return keys
end

M.opts = {
  select = {
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  }
}

return M
