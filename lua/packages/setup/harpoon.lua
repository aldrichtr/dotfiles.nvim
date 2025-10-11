
local M = {
  'ThePrimeagen/harpoon'
}

M.branch = 'harpoon2'

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.event = { 'BufReadPre' }

M.init = function()
  require('telescope').register_extension({'harpoon'})
end

M.opt = {}

M.keys = function()
  local wk = require('which-key')
  local harpoon = require('harpoon')
  local list = harpoon:list()

  harpoon:setup()
  wk.add({ '<leader><leader>', group = 'Harpoon operations' })
  local keys = {
    { '<leader><leader>1', function() list:select(1) end, desc = 'Jump to harpoon file 1' },
    { '<leader><leader>2', function() list:select(2) end, desc = 'Jump to harpoon file 2' },
    { '<leader><leader>3', function() list:select(3) end, desc = 'Jump to harpoon file 3' },
    { '<leader><leader>4', function() list:select(4) end, desc = 'Jump to harpoon file 4' },
    { '<leader><leader>5', function() list:select(5) end, desc = 'Jump to harpoon file 5' },
    { '<leader><leader>6', function() list:select(6) end, desc = 'Jump to harpoon file 6' },
    { '<leader><leader>7', function() list:select(7) end, desc = 'Jump to harpoon file 7' },
    { '<leader><leader>8', function() list:select(8) end, desc = 'Jump to harpoon file 8' },
    { '<leader><leader>9', function() list:select(9) end, desc = 'Jump to harpoon file 9' },
    {
      '<leader><leader>a', function() list:add() end, desc = 'Add this file to the harpoon list', },
    { '<leader><leader>n', function() list:next() end, desc = 'Jump to next mark' },
    { '<leader><leader>p', function() list:prev() end, desc = 'Jump to previous mark' },
    { '<leader><leader>q', function() harpoon.ui:toggle_quick_menu(list) end, desc = 'Show the harpoon quick menu', }
  }
  return keys
end

return M
