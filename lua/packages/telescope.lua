
local M = {
  'nvim-telescope/telescope.nvim'
}
M.tag = '0.1.8'

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

M.opts = function(plugin, opts)
  opts.pickers = {
    find_files = {
      theme = 'dropdown'
    }
  }
end

return M
