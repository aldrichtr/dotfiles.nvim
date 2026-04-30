
---@type LazySpec
local M = { 'nvim-telescope/telescope.nvim' }

M.version = '*'

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope-fzf-native.nvim'
}

M.keys = function()
  local builtin = require('telescope.builtin')

  local keys = {
    {'<leader>ff', builtin.find_files, desc = "Telescope find files" },
    {'<leader>/', builtin.grep_string, desc = "Telescope grep thing under point"}

  }
  return keys
end

M.opts = {
  pickers = {
    find_files = { theme = 'dropdown' }
  }
}

return M
