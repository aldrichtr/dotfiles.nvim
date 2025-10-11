-- A code outline in a side window
local M = {
  'stevearc/aerial.nvim',
}

M.dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'nvim-tree/nvim-web-devicons',
}
M.init = function()
  local telescope = require('telescope')
  telescope.setup({
    extensions = {
      aerial = {
        -- Set the width of the first two columns (the second
        -- is relevant only when show_columns is set to 'both')
        col1_width = 4,
        col2_width = 30,
        -- How to format the symbols
        format_symbol = function(symbol_path, filetype)
          if filetype == "json" or filetype == "yaml" then
            return table.concat(symbol_path, ".")
          else
            return symbol_path[#symbol_path]
          end
        end,
        -- Available modes: symbols, lines, both
        show_columns = "both",
      },
    },
  })
  telescope.register_extension({'aerial'})
end

M.opts = {
  backends = { 'treesitter', 'lsp' },
  default_direction = 'left',
  placement = 'edge',
  manage_folds = false,
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  keymaps = {
    ['?'] = 'actions.show_help',
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<C-v>'] = 'actions.jump_vsplit',
    ['<C-s>'] = 'actions.jump_split',
    ['p'] = 'actions.scroll',
    ['<C-j>'] = 'actions.down_and_scroll',
    ['<C-k>'] = 'actions.up_and_scroll',
    ['{'] = 'actions.prev',
    ['}'] = 'actions.next',
    ['[['] = 'actions.prev_up',
    [']]'] = 'actions.next_up',
    ['q'] = 'actions.close',
    ['o'] = 'actions.tree_toggle',
    ['za'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['zA'] = 'actions.tree_toggle_recursive',
    ['l'] = 'actions.tree_open',
    ['zo'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['zO'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['zc'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['zC'] = 'actions.tree_close_recursive',
    ['zr'] = 'actions.tree_increase_fold_level',
    ['zR'] = 'actions.tree_open_all',
    ['zm'] = 'actions.tree_decrease_fold_level',
    ['zM'] = 'actions.tree_close_all',
    ['zx'] = 'actions.tree_sync_folds',
    ['zX'] = 'actions.tree_sync_folds',
  }
}

return M
