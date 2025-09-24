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

   ]]
--
-- #endregion which-key wk.Spec

---@class Keybindings
local M = {}
M.__index = M

setmetatable(M, { __call = function(_, ...) return M:new(...) end })


function M:new(opts)
  opts = opts or require('profile.default.options')
  local utils = require('util')

  local whichkey = require('which-key')
  local builtin = require('telescope.builtin')
  local t_utils = require('telescope.utils')
  local ufo = require('ufo')
  local conform = require('conform')
  local bufferline = require('bufferline')
  -- ----------------------------------------------------------------------------------------------------------------
  -- Mappings start here
  whichkey.add({
    -- #region "Global" keys
    {
      mode = { 'n', 'i', 'v' },
      { '<C-S-]>', '<cmd>Neotree toggle<cr>', desc = 'Toggle the Neotree window' },
      { '<C-S-[>', '<cmd>AerialToggle<cr>', desc = 'Toggle the Aerial window' },
    }, -- #endregion "Global" keys
    -- #region normal mode bindings
    {
      mode = { 'n' },
      -- #region General
      { 'K', 'kJ', desc = 'Join this line with previous line' },
      {
        'Y',
        'y$',
        desc = 'Map Y to yank until EOL, rather than act as yy',
      },

      { '<A-Down>', '<cmd>move +1<cr>==', desc = 'Move line down' },
      { '<A-Up>', '<cmd>move -2<cr>==', desc = 'Move line up' },
      { '<A-S-Down>', 'yyp', desc = 'Copy line down' },
      { '<A-S-Up>', 'yyp<cmd>move +1<cr>', desc = 'Copy line up' },

      {
        '<C-L>',
        '<cmd>nohl<CR><C-L>',
        desc = 'redraw screen and turn off search highlighting',
      },

      { '<C-S-v>', '"*p', desc = 'Paste from system clipboard' },
      -- #endregion General

      -- #region <leader> Leader key operations
      -- #region <leader> - Top level
      { '<leader>?', function() whichkey.show({ global = true }) end, desc = 'Show available keys' },
      {
        '<leader>=',
        function() conform.format({ async = true, lsp_format = 'fallback' }) end,
        desc = 'Format document (conform)',
      },
      -- #endregion <leader> - Top level

      -- #region <leader><leader> - Harpoon
      { '<leader><leader>', group = 'Harpoon operations' },
      { '<leader><leader>1', function() require('harpoon.ui').nav_file(1) end, desc = 'Jump to harpoon file 1' },
      { '<leader><leader>2', function() require('harpoon.ui').nav_file(2) end, desc = 'Jump to harpoon file 2' },
      { '<leader><leader>3', function() require('harpoon.ui').nav_file(3) end, desc = 'Jump to harpoon file 3' },
      { '<leader><leader>4', function() require('harpoon.ui').nav_file(4) end, desc = 'Jump to harpoon file 4' },
      { '<leader><leader>5', function() require('harpoon.ui').nav_file(5) end, desc = 'Jump to harpoon file 5' },
      { '<leader><leader>6', function() require('harpoon.ui').nav_file(6) end, desc = 'Jump to harpoon file 6' },
      { '<leader><leader>7', function() require('harpoon.ui').nav_file(7) end, desc = 'Jump to harpoon file 7' },
      { '<leader><leader>8', function() require('harpoon.ui').nav_file(8) end, desc = 'Jump to harpoon file 8' },
      { '<leader><leader>9', function() require('harpoon.ui').nav_file(9) end, desc = 'Jump to harpoon file 9' },
      {
        '<leader><leader>a',
        function() require('harpoon.mark').add_file() end,
        desc = 'Add this file to the harpoon list',
      },
      { '<leader><leader>n', function() require('harpoon.ui').nav_next() end, desc = 'Jump to next mark' },
      { '<leader><leader>p', function() require('harpoon.ui').nav_prev() end, desc = 'Jump to previous mark' },
      {
        '<leader><leader>q',
        function() require('harpoon.ui').toggle_quick_menu() end,
        desc = 'Show the harpoon quick menu',
      },
      { '<leader><leader>t', function() require('harpoon.term').gotoTerminal() end, desc = 'Goto terminal window' },
      -- #endregion <leader><leader> - Harpoon

      -- #region <leader>! - Todo comments
      { '<leader>!', group = 'Todo comments' },
      { '<leader>!n', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '<leader>!p', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
      -- #endregion <leader>! - Todo comments

      -- #region <leader>a - Unused
      -- #endregion <leader>a - Unused

      -- #region <leader>b - buffer operations
      { '<leader>b', group = 'Buffers' },
      { '<leader>b1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Goto buffer 1' },
      { '<leader>b2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Goto buffer 2' },
      { '<leader>b3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Goto buffer 3' },
      { '<leader>b4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Goto buffer 4' },
      { '<leader>b5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Goto buffer 5' },
      { '<leader>b6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Goto buffer 6' },
      { '<leader>b7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Goto buffer 7' },
      { '<leader>b8', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Goto buffer 8' },
      { '<leader>b9', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Goto buffer 9' },
      --
      { '<leader>bn', '<cmd>BufferLineCycleNext<cr>', desc = 'Goto the next buffer' },
      { '<leader>bp', '<cmd>BufferLineCyclePrev<cr>', desc = 'Goto the prev buffer' },
      --
      {
        '<leader>bb',
        function() builtin.buffers() end,
        desc = 'Select buffer using telescope',
      },
      --
      { '<leader>bc', group = 'Close buffers' },
      { '<leader>bcc', '<cmd>BufferLinePickClose<cr>', desc = 'Choose a buffer to close' },
      {
        '<leader>bcl',
        '<cmd>BufferLineCloseLeft<cr>',
        desc = 'Close visible buffers to the left',
      },
      {
        '<leader>bcr',
        '<cmd>BufferLineCloseRight<cr>',
        desc = 'Close visible buffers to the right',
      },
      {
        '<leader>bco',
        '<cmd>BufferLineCloseOthers<cr>',
        desc = 'Close all other visible buffers',
      },
      {
        '<leader>bd',
        '<cmd>bdelete<cr>',
        desc = 'Delete the current buffer',
      },
      --
      { '<leader>bg', group = 'Buffer groups' },
      { '<leader>bgc', '<cmd>BufferLineGroupClose<cr>', desc = 'Close buffer group' },
      { '<leader>bgg', '<cmd>BufferLineGroupToggle<cr>', desc = 'Toggle buffer group' },
      --
      { '<leader>bm', group = 'Move buffers' },
      {
        '<leader>bm1',
        function() bufferline.move_to(1) end,
        desc = 'Move current buffer to position 1',
      },
      {
        '<leader>bm2',
        function() bufferline.move_to(2) end,
        desc = 'Move current buffer to position 2',
      },
      {
        '<leader>bm3',
        function() bufferline.move_to(3) end,
        desc = 'Move current buffer to position 3',
      },
      {
        '<leader>bm4',
        function() bufferline.move_to(4) end,
        desc = 'Move current buffer to position 4',
      },
      {
        '<leader>bm5',
        function() bufferline.move_to(5) end,
        desc = 'Move current buffer to position 5',
      },
      {
        '<leader>bm6',
        function() bufferline.move_to(6) end,
        desc = 'Move current buffer to position 6',
      },
      {
        '<leader>bm7',
        function() bufferline.move_to(7) end,
        desc = 'Move current buffer to position 7',
      },
      {
        '<leader>bm8',
        function() bufferline.move_to(8) end,
        desc = 'Move current buffer to position 8',
      },
      {
        '<leader>bm9',
        function() bufferline.move_to(9) end,
        desc = 'Move current buffer to position 9',
      },
      {
        '<leader>bm$',
        function() bufferline.move_to(-1) end,
        desc = 'Move current buffer to last position',
      },
      {
        '<leader>bml',
        '<cmd>BufferLineMovePrev<cr>',
        desc = 'Move current buffer to the left',
      },
      {
        '<leader>bmr',
        '<cmd>BufferLineMoveNext<cr>',
        desc = 'Move current buffer to the right',
      },
      --
      {
        '<leader>bP',
        '<cmd>BufferLineTogglePin<cr>',
        desc = 'Toggle pin on current buffer',
      },
      --
      { '<leader>bs', group = 'Sort buffers' },
      {
        '<leader>bse',
        '<cmd>BufferLineSortByExtension<cr>',
        desc = 'Sort buffers by Extension',
      },
      {
        '<leader>bsd',
        '<cmd>BufferLineSortByDirectory<cr>',
        desc = 'Sort buffers by Directory',
      },
      { '<leader>bst', '<cmd>BufferLineSortByTabs<cr>', desc = 'Sort buffers by tab' },
      -- #endregion <leader>b - buffer operations

      -- #region <leader>c - Unused
      -- #endregion <leader>c - Unused

      -- #region <leader>d - Unused
      -- #endregion <leader>d - Unused

      -- #region <leader>e - Unused
      -- #endregion <leader>e - Unused

      -- #region <leader>f - File operations
      { '<leader>f', group = 'Files' },
      {
        '<leader>ff',
        function() builtin.find_files({ cwd = t_utils.buffer_dir() }) end,
        desc = 'select from files in current directory',
      },
      -- #endregion <leader>f - File operations

      -- #region <leader>g - git commands (Neogit)
      { '<leader>g', group = 'Git' },
      { '<leader>gd', '<cmd>Neogit diff<cr>', desc = 'Git diff view' },
      { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Git log view' },
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
      { '<leader>s', group = 'Search' },
      { '<leader>sb', function() builtin.buffers() end, desc = 'Search for buffers in current tab' },
      { '<leader>sB', '<cmd>Telescope scope buffers<CR>', desc = 'Search for buffers in current tab' },
      {
        '<leader>sc',
        function() builtin.find_files({ cwd = opts.paths.config }) end,
        desc = 'Search for files in the nvim config directory',
      },
      {
        '<leader>sd',
        function() builtin.find_files({ cwd = opts.paths.dotfiles }) end,
        desc = 'Search for files in the dotfiles directory',
      },
      { '<leader>sg', function() builtin.live_grep() end, desc = 'select from grep results in the current file' },
      { '<leader>sh', function() builtin.help_tags() end, desc = 'Search for help tags' },
      { '<leader>sk', function() builtin.keymaps() end, desc = 'Search for keymaps' },
      { '<leader>sm', '<cmd>Telescope harpoon marks<cmd>', desc = 'Select from harpoon marks' },
      {
        '<leader>sp',
        function() require('telescope').extensions.projects.projects({}) end,
        desc = 'Search for projects',
      },
      { '<leader>sS', '<cmd>Telescope aerial<cmd>', desc = 'Select from symbol (aerial)' },
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Search for Todo comments in the current directory' },
      {
        '<leader>sw',
        function()
          local word = vim.fn.expand('<cword>')
          builtin.grep_string({ search = word })
        end,
        desc = 'Search for the word under cursor',
      },
      {
        '<leader>sW',
        function()
          local word = vim.fn.expand('<cWORD>')
          builtin.grep_string({ search = word })
        end,
        desc = 'Search for the WORD under cursor',
      },
      -- #endregion <leader>s - Search operations

      -- #region <leader>t - Tab operations
      { '<leader>t', group = 'Tab operations' },
      { '<leader>ta', '<cmd>tabnew<cr>', desc = 'Add a new tab' },
      --
      { '<leader>tc', group = 'Close tab' },
      { '<leader>tcc', '<cmd>tabclose<cr>', desc = 'Close the current tab' },
      { '<leader>tcn', '<cmd>+tabclose<cr>', desc = 'Close the next tab' },
      { '<leader>tcp', '<cmd>-tabclose<cr>', desc = 'Close the previous tab' },
      { '<leader>tco', '<cmd>tabonly<cr>', desc = 'Close all other tabs' },
      { '<leader>tq', '<cmd>tabclose<cr>', desc = 'Close the current tab' },
      --
      { '<leader>tm', group = 'Move tab' },
      { '<leader>tm^', '<cmd>0tabmove<cr>', desc = 'Move tab to beginning' },
      { '<leader>tm$', '<cmd>$tabmove<cr>', desc = 'Move tab to end' },
      { '<leader>tmp', '<cmd>-tabmove<cr>', desc = 'Move tab left' },
      { '<leader>tmn', '<cmd>+tabmove<cr>', desc = 'Move tab right' },
      --
      { '<leader>t^', '<cmd>tabfirst<cr>', desc = 'Focus on first tab' },
      { '<leader>tn', '<cmd>tabnext<cr>', desc = 'Focus on next tab' },
      { '<leader>tp', '<cmd>tabprev<cr>', desc = 'Focus on previous tab' },
      { '<leader>t$', '<cmd>tablast<cr>', desc = 'Focus on last tab' },

      { '<leader>tr', '<cmd>BufferLineTabRename<cr>', desc = 'Rename the current tab' },
      -- #endregion <leader>t - Tab operations

      -- #region <leader>T - Terminal operations
      { '<leader>T', group = 'Terminal operations' },
      -- #endregion <leader>T - Terminal operations
      -- #region <leader>u - Unused
      -- #endregion <leader>u - Unused

      -- #region <leader>v - View application components
      { '<leader>v', group = 'View application components' },
      { '<leader>vd', '<cmd>Dashboard<CR>', desc = 'View the dashboard' },
      {
        '<leader>ve',
        '<cmd>Neotree reveal position=right source=filesystem dir=%:h<CR>',
        desc = 'Reveal the filesystem explorer window',
      },
      {
        '<leader>vg',
        '<cmd>Neotree reveal position=float source=git_status<CR>',
        desc = 'View the git status in a floating window',
      },
      { '<leader>vk', function() whichkey.show({ global = true }) end, desc = 'Show keybindings' },
      { '<leader>vl', '<cmd>Lazy<cr>', desc = 'Lazy package manager console' },
      { '<leader>vn', function() utils.toggle_numbers() end, desc = 'Toggle relative line numbers' },
      { '<leader>vo', '<cmd>AerialToggle!<CR>', desc = 'Toggle the code outline' },
      -- #endregion <leader>v - View application components

      -- #region <leader>w - Window operations
      { '<leader>w', group = 'Windows operations', proxy = '<c-w>' },
      -- #endregion <leader>w - Window operations

      -- #region <leader>x - Diagnostics
      { '<leader>x', group = 'Diagnostics' },
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      {
        '<leader>xl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      -- #endregion <leader>x - Diagnostics

      -- #region <leader>y - Unused
      -- #endregion <leader>y - Unused

      -- #region <leader>z - Unused
      -- #endregion <leader>z - Unused

      -- #endregion <leader> Leader key operations

      -- #region z - Fold commands
      { 'z', group = 'Folding operations' },
      { 'zM', function() ufo.closeAllFolds() end, desc = 'Close all folds with UFO' },
      { 'zR', function() ufo.openAllFolds() end, desc = 'Open all folds with UFO' },
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
      { '<leader>T', group = 'Terminal operations' },
      {
        '<leader>Te',
        function()
          local tterm = require('toggleterm')
          local trim_spaces = true
          tterm.send_lines_to_terminal('visual_selection', trim_spaces, { args = vim.v.count })
        end,
        desc = 'Execute selection in terminal',
      },

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
