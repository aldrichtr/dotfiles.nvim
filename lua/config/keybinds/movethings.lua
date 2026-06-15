
-- #region which-key wk.Spec
--[[
  - [1]: (string) lhs (required)
  - [2]: (string|fun()) rhs (optional): when present, it will create the mapping
  - desc: (string|fun():string) description (required for non-groups)
  - group: (string|fun():string) group name (optional)
  - mode: (string|string[]) mode (optional, defaults to "n")
  - cond: (boolean|fun():boolean) condition to enable the mapping (optional)
  - hidden: (boolean) hide the mapping (optional)
  - icon: (string|wk.Icon|fun():(wk.Icon|string)) icon spec (optional)
  - proxy: (string) proxy to another mapping (optional)
  - expand: (fun():wk.Spec) nested mappings (optional)
  - any other option valid for vim.keymap.set. These are only used for creating mappings.
    When desc, group, or icon are functions, they are evaluated every time the popup is shown.

    The expand property allows to create dynamic mappings. Only functions as rhs are supported for dynamic mappings.
]]
--
-- #endregion which-key wk.Spec

local M = {}

M.whichkey = {
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
}

return M
