local M = {
  'nvim-treesitter/nvim-treesitter-textobjects',
}

M.branch = 'main'

M.dependencies = {'nvim-treesitter/nvim-treesitter'}

M.keys = require('config.keybindings.treesitter-textobjects')

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
