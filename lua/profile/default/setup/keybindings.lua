-- Keybindings for neovim.  Requires whichkey.

local path = require('util.path')
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


--[[
-- TODO: Decide whether keybindings should be defined in the packages or
-- separately
--
-- Currently, some keybindings are set in the packages files, and some are set
-- here.  I'm not sure which is best, but I know that having them in two or more
-- places is not ideal when trying to find where one was set
--
-- If i create a keybinding class, then I could basically keep the keybindings
-- in one file, and provide a function for the plugins like
-- local keys = require('config.keybindings')
--
-- -- M.keys = keys.myplugin()
--
--]]--



local M = {}
setmetatable(M, {
  __index = M,
  __call  = function(cls, ...) return cls:init(...) end
})


function M:init(opts)
  Logger:debug("Loading Keybindings")

  local whichkey = require('which-key')
  -- ----------------------------------------------------------------------------------------------------------------
  -- Mappings start here
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

      -- #region <leader> Leader key operations
      -- #region <leader> - Top level
      -- #endregion <leader> - Top level
      -- #region <leader>digit - Switching windows
      -- #endregion <leader>digit - Switching windows

      -- #region <leader><leader> - Harpoon

      -- #endregion <leader><leader> - Harpoon

      -- #region <leader>! - Todo comments
      -- #endregion <leader>! - Todo comments

      -- #region <leader>a - Unused
      -- #endregion <leader>a - Unused

      -- #region <leader>b - buffer operations
      -- #region <leader>c - Unused
      -- #endregion <leader>c - Unused

      -- #region <leader>d - Unused
      -- #endregion <leader>d - Unused

      -- #region <leader>e - Unused
      -- #endregion <leader>e - Unused

      -- #region <leader>f - File operations
      -- #endregion <leader>f - File operations

      -- #region <leader>g - git commands (Neogit)
      -- #endregion <leader>g - git commands (Neogit)

      -- #region <leader>h - Unused
      -- #endregion <leader>h - Unused

      -- #region <leader>i - Unused
      -- #endregion <leader>i - Unused

      -- #region <leader>j - Unused
      -- #endregion <leader>j - Unused

      -- #region <leader>k - Unused
      -- #endregion <leader>k - Unused

      -- #region <leader>l - Unused
      -- #endregion <leader>l - Unused

      -- #region <leader>m - Unused
      -- #endregion <leader>m - Unused

      -- #region <leader>n - Unused
      -- #endregion <leader>n - Unused

      -- #region <leader>o - Unused
      -- #endregion <leader>o - Unused

      -- #region <leader>p - Unused
      -- #endregion <leader>p - Unused

      -- #region <leader>q - Unused
      -- #endregion <leader>q - Unused

      -- #region <leader>r - Unused
      -- #endregion <leader>r - Unused

      -- #region <leader>s - Search operations
      -- #endregion <leader>s - Search operations

      -- #region <leader>t - Tab operations
      -- #endregion <leader>t - Tab operations

      -- #region <leader>T - Terminal operations
      -- #endregion <leader>T - Terminal operations
      -- #region <leader>u - Unused
      -- #endregion <leader>u - Unused

      -- #region <leader>v - View application components
      -- #endregion <leader>v - View application components

      -- #region <leader>w - Window operations
      -- #endregion <leader>w - Window operations

      -- #region <leader>x - Diagnostics
      -- #endregion <leader>x - Diagnostics

      -- #region <leader>y - Unused
      -- #endregion <leader>y - Unused

      -- #region <leader>z - Unused
      -- #endregion <leader>z - Unused

      -- #endregion <leader> Leader key operations

      -- #region z - Fold commands
      -- #endregion z - Fold commands
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

return M