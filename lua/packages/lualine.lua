-- lualine is a status bar for neovim that can be used for the application
-- status lines

---@class LazyPlugin
local M = {
  'nvim-lualine/lualine.nvim'
}

M.lazy = false

M.dependencies = { 'nvim-tree/nvim-web-devicons' }


local global_options = {
    icons_enabled = true,
    theme = 'auto',
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'neo-tree', 'aerial' },
    ignore_focus = { 'neo-tree', 'aerial' },
    always_divide_middle = true,
    always_show_tabline = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  }

  -- Currently using the bufferline.nvim plugin which uses the tabline
-- local tabline_config = {}

local winbar_config = {
  -- I am trying to make a "breadcrumb-like" line above the window
  lualine_a = {
    { 'filetype', icon_only = true, colored = true, icon = { align = 'left' } },
    {
      'filename',
      file_status = true,
      -- 0: Just the filename
      -- 1: Relative path
      -- 2: Absolute path
      -- 3: Absolute path, with tilde as the home directory
      -- 4: Filename and parent dir, with tilde as the home directory
      path = 1,
      --
      shorting_target = 40, -- Shortens path to leave 40 spaces in the window
      newfile_status = true,
      symbols = {
        modified = '⭘',
        readonly = '',
        unnamed = 'untitled',
        newfile = 'new',
      },
    },
  },
  }

local statusline = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch' },
      { 'diff',
        -- Displays a colored diff status if set to true
        colored = true,
        diff_color = {
          -- Same color values as the general color option can be used here.
          -- Changes the diff's added color
          added = 'LuaLineDiffAdd',
          -- Changes the diff's modified color
          modified = 'LuaLineDiffChange',
          -- Changes the diff's removed color you
          removed = 'LuaLineDiffDelete',
        },
        -- Changes the symbols used by the diff.
        symbols = { added = '+', modified = '~', removed = '-' },
        -- A function that works as a data source for diff.
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed
            }
          end
        end
        -- It must return a table as such:
        --   { added = add_count, modified = modified_count, removed = removed_count }
        -- or nil on failure. count <= 0 won't be displayed.
      },
    },
    lualine_x = {
      { 'datetime', style = '%A - %d %B %H:%M' },
      { 'encoding' },
    },
    lualine_y = { 'searchcount', 'progress' },
    lualine_z = {
      'aerial',
      'location',
    },
  }

M.opts = {
  -- #region Extensions
  extensions = {
    'lazy',
    'neo-tree',
    'quickfix',
    'aerial',
    'toggleterm',
    'trouble',
  },
  -- #endregion Extensions

  options = global_options,


  winbar = winbar_config,

  inactive_winbar = winbar_config,

  sections = statusline,
}

return M
