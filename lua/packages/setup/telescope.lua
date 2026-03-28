
---@type LazySpec
local M = {
  'nvim-telescope/telescope.nvim'
}

M.version = '*'
M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope-fzf-native.nvim'
}

M.opts = {
  pickers = {
    find_files = { theme = 'dropdown' }
  }
}

return M
