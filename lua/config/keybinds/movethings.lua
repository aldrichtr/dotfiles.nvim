
local M = {}

function M:setup()
  local wk = require('which-key')

  wk.add({
    {
      mode = { 'n' },
      { '<A-Down>', ':move +1<CR>==', desc = 'Move line down' },
      { '<A-Up>', ':move -2<CR>==', desc = 'Move line up' },
      { '<A-S-Down>', 'yyp', desc = 'Copy line down' },
      { '<A-S-Up>', 'yyp:move +1<CR>', desc = 'Copy line up' },

      -- TODO: These need a new home
      { 'Y', 'y$', desc = 'Map Y to yank until EOL, rather than act as yy' },

      {
        '<C-L>',
        ':nohl<CR><C-L>',
        desc = 'redraw screen and turn off search highlighting',
      },

      { '<C-S-y>', '"+y', desc = 'Yank to system clipboard' },
      { '<C-S-v>', '"+p', desc = 'Paste from system clipboard' },
    },
    {
      mode = { 'v' },
      { '<A-Down>', ":move '>+1<CR>gv=gv", desc = 'Move line down' },
      { '<A-Up>', ":move '<-2<CR>gv=gv", desc = 'Move line up' },
      { '<A-S-Down>', 'ypgv=gv', desc = 'Copy line down' },
      { '<A-S-Up>', "y:move '>+1<CR>pgv=gv", desc = 'Copy line up' },
    },
    {
      mode = { 'i' },
      { '<A-Down>', ':move .+1<CR><esc>==gi', desc = 'Move line down' },
      { '<A-Up>', ':move .-2<CR><esc>==gi', desc = 'Move line up' },
      { '<A-S-Down>', '<Esc>yypi', desc = 'Copy line down' },
      { '<A-S-Up>', 'yy:move >+1<CR>pgv=gv', desc = 'Copy line up' },
      { '<C-S-v>', '<C-r>*p', desc = 'Paste from the system clipboard' },
    },
  })
end

return M
