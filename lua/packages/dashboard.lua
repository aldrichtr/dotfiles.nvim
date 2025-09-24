-- A dashboard menu
local M = {
  'nvimdev/dashboard-nvim'
}

M.dependencies = { 'nvim-tree/nvim-web-devicons' }

M.event = 'VimEnter'

M.opts = {
  theme = 'hyper',
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files {cwd = vim.env.HOME}',
        key = 'f',
      },
      {
        desc = ' dotfiles',
        group = 'Number',
        action = 'Telescope dotfiles',
        key = 'd',
      },
      {
        desc = ' projects',
        group = 'Number',
        action = 'Telescope projects',
        key = 'p',
      }
    }
  }
}

return M
