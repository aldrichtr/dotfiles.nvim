-- Keybindings for neovim.  Requires whichkey.

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
]] --
-- #endregion which-key wk.Spec

local class = require('extern.middleclass')
local Config = require('config')


local Keybindings = class('Keybindings', Config)

function Keybindings:initialize()
  Config.initialize(self)
end



function Keybindings:apply()
  local whichkey = require('which-key')
  whichkey.add({
    -- #region "Global" keys
    -- #region normal mode bindings
    {
      mode = { 'n' },
      -- #region General
      { 'Y', 'y$', desc = 'Map Y to yank until EOL, rather than act as yy', },

      { '<A-Down>', '<cmd>move +1<cr>==', desc = 'Move line down' },
      { '<A-Up>', '<cmd>move -2<cr>==', desc = 'Move line up' },
      { '<A-S-Down>', 'yyp', desc = 'Copy line down' },
      { '<A-S-Up>', 'yyp<cmd>move +1<cr>', desc = 'Copy line up' },

      {
        '<C-L>',
        '<cmd>nohl<CR><C-L>',
        desc = 'redraw screen and turn off search highlighting',
      },

      { '<C-S-y>', '"+y', desc = 'Yank to system clipboard' },
      { '<C-S-v>', '"+p', desc = 'Paste from system clipboard' },
      -- #endregion General

    }, -- #endregion normal mode bindings

    -- #region visual mode bindings
    {
      mode = { 'v' },
      -- #region General
      { '<A-Down>', '<cmd>move >+1<cr>gv=gv', desc = 'Move line down' },
      { '<A-Up>', '<cmd>move <-2<cr>gv=gv', desc = 'Move line up' },
      { '<A-S-Down>', 'ypgv=gv', desc = 'Copy line down' },
      { '<A-S-Up>', 'y<cmd>move >+1<cr>pgv=gv', desc = 'Copy line up' },
      -- #endregion General

      -- #region <leader>T Terminal operations

      -- #endregion <leader>T Terminal operations
    },
    -- #endregion visual mode bindings

    -- #region insert mode bindings
    {
      mode = { 'i' },
      { '<A-Down>', '<cmd>move .+1<cr><esc>==gi', desc = 'Move line down' },
      { '<A-Up>', '<cmd>move .-2<cr><esc>==gi', desc = 'Move line up' },
      { '<A-S-Down>', '<Esc>yypi', desc = 'Copy line down' },
      { '<A-S-Up>', 'yy<cmd>move >+1<cr>pgv=gv', desc = 'Copy line up' },
      { '<C-S-v>', '<C-r>*p', desc = 'Paste from the system clipboard' },
    },
    -- #endregion insert mode bindings
  })
end

-- ----------------------------------------------------------------------------------------------------------------
-- #endregion Setup new keymaps (with which-key)

return Keybindings
