

local M = {
  'nvim-orgmode/telescope-orgmode.nvim'
}

M.event = 'VeryLazy'

M.dependencies = {
  'nvim-orgmode/orgmode',
  'nvim-telescope/telescope.nvim'
}

M.config = function()
  local telescope = require('telescope')
  local extensions = telescope.extensions

  telescope.load_extension('orgmode')

  vim.keymap.set("n", "<leader>r",  extensions.orgmode.refile_heading)
  vim.keymap.set("n", "<leader>fh", extensions.orgmode.search_headings)
  vim.keymap.set("n", "<leader>li", extensions.orgmode.insert_link)
end


return M
