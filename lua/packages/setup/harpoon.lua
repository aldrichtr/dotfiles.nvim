
local M = {
  'ThePrimeagen/harpoon'
}

M.branch = 'harpoon2'

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim'
}

M.event = { 'BufReadPre' }

-- M.opt = {}

M.keys = require('config.keybindings.harpoon')

return M