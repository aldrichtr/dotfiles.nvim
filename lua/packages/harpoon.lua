
local M = {
    'ThePrimeagen/harpoon'
}

M.branch = 'harpoon2'

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.event = { 'BufReadPre' }

M.init = function()
    require('telescope').register_extension('harpoon')
end

M.opt = {}

return M
