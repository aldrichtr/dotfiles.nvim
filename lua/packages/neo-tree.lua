-- neo-tree.nvim is a plugin to manage the filesystem and other tree like
-- structures, like git-status, document symbols, etc.
local M = {
  'nvim-neo-tree/neo-tree.nvim',
}
M.branch = 'v3.x'

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  'MunifTanjim/nui.nvim',
  -- Preview Mode
  '3rd/image.nvim',
}

M.cmd = 'Neotree'

M.opts = function()
  local options = {
    popup_border_style = 'rounded',
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'aerial', 'qf' },
    sort_case_insensitive = false,

    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
        provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '•',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '',
          modified = '•',
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    -- A list of functions, each representing a global custom command
    -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    -- see `:h neo-tree-custom-commands-global`
    commands = {},
    window = {
      position = 'right',
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = { 'toggle_node', nowait = false },
        ['<2-LeftMouse>'] = 'open',
        -- ['<cr>'] = 'open',
        ['<cr>'] = { 'open', config = { expand_nested_files = true } }, -- expand nested file takes precedence
        ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
        ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['<C-f>'] = { 'scroll_preview', config = { direction = -10 } },
        ['<C-b>'] = { 'scroll_preview', config = { direction = 10 } },
        ['l'] = 'focus_preview',
        ['S'] = 'split_with_window_picker',
        ['sr'] = 'open_rightbelow_vs',
        ['sl'] = 'open_leftabove_vs',
        ['sv'] = 'vsplit_with_window_picker',
        ['t'] = 'open_tabnew',
        -- ["<cr>"] = "open_drop",
        -- ["t"] = "open_tab_drop",
        ['w'] = 'open_with_window_picker',
        ['C'] = 'close_node',
        ['z'] = 'close_all_nodes',
        --["Z"] = "expand_all_nodes",
        ['R'] = 'refresh',
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        ['a'] = {
          'add',
          config = {
            show_path = 'none', -- "none", "relative", "absolute"
          },
        },
        ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['e'] = 'toggle_auto_expand_width',
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
      },
    },
    nesting_rules = {},

    filesystem = {
      bind_to_cwd = true,
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Windows for hidden files/directories
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        always_show_by_pattern = { -- uses glob style patterns
          --".env*",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
        --["/"] = "filter_as_you_type", -- this was the default until v1.28
        ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ['f'] = 'filter_on_submit',
        ['<C-x>'] = 'clear_filter',
        ['<bs>'] = 'navigate_up',
        ['.'] = 'set_root',
        ['[g'] = 'prev_git_modified',
        [']g'] = 'next_git_modified',
        ['i'] = 'show_file_details',
        ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
        ['oc'] = { 'order_by_created', nowait = false },
        ['od'] = { 'order_by_diagnostics', nowait = false },
        ['og'] = { 'order_by_git_status', nowait = false },
        ['om'] = { 'order_by_modified', nowait = false },
        ['on'] = { 'order_by_name', nowait = false },
        ['os'] = { 'order_by_size', nowait = false },
        ['ot'] = { 'order_by_type', nowait = false },
      },
      fuzzy_finder_mappings = {
        -- define keymaps for filter popup window in fuzzy_finder_mode
        ['<down>'] = 'move_cursor_down',
        ['<C-n>'] = 'move_cursor_down',
        ['<up>'] = 'move_cursor_up',
        ['<C-p>'] = 'move_cursor_up',
      },
    },
      commands = {},
      components = {
        harpoon_index = function(config, node, _)
          local harpoon_list = require('harpoon'):list()
          local path = node:get_id()
          local harpoon_key = vim.uv.cwd()

          for i, item in ipairs(harpoon_list.items) do
            local value = item.value
            if string.sub(item.value, 1, 1) ~= '/' then value = harpoon_key .. '/' .. item.value end

            if value == path then
              vim.print(path)
              return {
                text = string.format(' ⥤ %d', i), -- <-- Add your favorite harpoon like arrow here
                highlight = config.highlight or 'NeoTreeDirectoryIcon',
              }
            end
          end
          return {}
        end,
      },
      renderers = {
        file = {
          { 'icon' },
          { 'name', use_git_status_colors = true },
          { 'harpoon_index' }, --> This is what actually adds the component in where you want it
          { 'diagnostics' },
          -- { 'git_status',   highlight = 'NeoTreeDimText' },
        },
      },
    },
  }

  return options
end

return M
