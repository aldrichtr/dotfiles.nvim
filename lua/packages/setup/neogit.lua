local M = {
  'NeogitOrg/neogit',
}

M.cmd = 'Neogit'

M.opts = {}

M.keys = {
  {
    '<leader>gs',
    function()
      require('neogit').open({ kind = 'floating' })
    end,
    desc = 'Open Neogit UI',
  },
}

return M
