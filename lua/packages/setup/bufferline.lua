local M = {
  'akinsho/bufferline.nvim',
}

M.lazy = false

M.version = '*'

M.dependencies = { 'nvim-tree/nvim-web-devicons' }

M.keys = function()
  local wk = require('which-key')
  local bufferline = require('bufferline')
  local builtin = require('telescope.builtin')

  wk.add({
    { '<leader>b', group = 'Buffers' },
    { '<leader>bc', group = 'Close buffers' },
    { '<leader>bg', group = 'Buffer groups' },
    { '<leader>bm', group = 'Move buffers' },
    { '<leader>bs', group = 'Sort buffers' },
  })

  local keys = {
  -- #region Goto buffer
  { '<leader>b1', '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Goto buffer 1' },
  { '<leader>b2', '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Goto buffer 2' },
  { '<leader>b3', '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Goto buffer 3' },
  { '<leader>b4', '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Goto buffer 4' },
  { '<leader>b5', '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Goto buffer 5' },
  { '<leader>b6', '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Goto buffer 6' },
  { '<leader>b7', '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Goto buffer 7' },
  { '<leader>b8', '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Goto buffer 8' },
  { '<leader>b9', '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Goto buffer 9' },

    { '<leader>bn', '<cmd>BufferLineCycleNext<cr>', desc = 'Goto the next buffer' },
    { '<leader>bp', '<cmd>BufferLineCyclePrev<cr>', desc = 'Goto the prev buffer' },
  -- #endregion
    --
    { '<leader>bb', function() builtin.buffers() end, desc = 'Select buffer using telescope', },
    --
    { '<leader>bcc', '<cmd>BufferLinePickClose<cr>', desc = 'Choose a buffer to close' },
    { '<leader>bcl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close visible buffers to the left', },
    { '<leader>bcr', '<cmd>BufferLineCloseRight<cr>', desc = 'Close visible buffers to the right', },
    { '<leader>bco', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close all other visible buffers', },
    --
    { '<leader>bd', '<cmd>bdelete<cr>', desc = 'Delete the current buffer', },
    --
    { '<leader>bgc', '<cmd>BufferLineGroupClose<cr>', desc = 'Close buffer group' },
    { '<leader>bgg', '<cmd>BufferLineGroupToggle<cr>', desc = 'Toggle buffer group' },
    --
    { '<leader>bm1', function() bufferline.move_to(1) end, desc = 'Move buffer to position 1', },
    { '<leader>bm2', function() bufferline.move_to(2) end, desc = 'Move buffer to position 2', },
    { '<leader>bm3', function() bufferline.move_to(3) end, desc = 'Move buffer to position 3', },
    { '<leader>bm4', function() bufferline.move_to(4) end, desc = 'Move buffer to position 4', },
    { '<leader>bm5', function() bufferline.move_to(5) end, desc = 'Move buffer to position 5', },
    { '<leader>bm6', function() bufferline.move_to(6) end, desc = 'Move buffer to position 6', },
    { '<leader>bm7', function() bufferline.move_to(7) end, desc = 'Move buffer to position 7', },
    { '<leader>bm8', function() bufferline.move_to(8) end, desc = 'Move buffer to position 8', },
    { '<leader>bm9', function() bufferline.move_to(9) end, desc = 'Move buffer to position 9', },
    { '<leader>bm$', function() bufferline.move_to(-1) end, desc = 'Move buffer to last position', },
    { '<leader>bml', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer left', },
    { '<leader>bmr', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer right', },
    --
    { '<leader>bP', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle pin on current buffer', },
    --
    { '<leader>bse', '<cmd>BufferLineSortByExtension<cr>', desc = 'Sort buffers by Extension', },
    { '<leader>bsd', '<cmd>BufferLineSortByDirectory<cr>', desc = 'Sort buffers by Directory', },
    { '<leader>bst', '<cmd>BufferLineSortByTabs<cr>', desc = 'Sort buffers by tab' },

  }
  return keys
end

M.opts = function()
  local bufferline = require('bufferline')
  --#region Options
  return {
    options = {
      mode = 'buffers', -- set to "tabs" to only show tabpages instead
      style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
      themable = true,
      numbers = 'ordinal',
      close_command = 'bdelete! %d',
      right_mouse_command = 'bdelete! %d',
      left_mouse_command = 'buffer %d', -- can be a string | function, | false see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
      indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon', --| 'underline' | 'none',
      },
      buffer_close_icon = '󰅖',
      modified_icon = '● ',
      close_icon = ' ',
      left_trunc_marker = ' ',
      right_trunc_marker = ' ',
      -- name_formatter can be used to change the buffer's label in the bufferline.
      -- Please note some names can/will break the
      -- bufferline so use this at your discretion knowing that it has
      -- some limitations that will *NOT* be fixed.
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      truncate_names = true, -- whether or not tab names should be truncated
      tab_size = 18,
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false, -- only applies to coc
      diagnostics_update_on_event = true, -- use nvim's diagnostic handler
      -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
      diagnostics_indicator = function(count, level, diagnostics_dict, context) return '(' .. count .. ')' end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'center',
          separator = true,
        },
      },
      color_icons = true, -- whether or not to add the filetype icon highlights
      get_element_icon = function(element)
        -- element consists of {filetype: string, path: string, extension: string, directory: string}
        -- This can be used to change how bufferline fetches the icon
        -- for an element e.g. a buffer or a tab.
        -- e.g.
        local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
        return icon, hl
      end,
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
      duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = 'slant', -- | "slope" | "thick" | "thin" | { 'any', 'any' },
      -- enforce_regular_tabs = true, -- if enabled, unique names will not be shown
      always_show_bufferline = true,
      auto_toggle_bufferline = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
      sort_by = 'insert_after_current', -- |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        -- add custom logic
        pick = {
          alphabet = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890',
        },
      },
    }
    --#endregion
  end

  return M
