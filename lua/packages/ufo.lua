-- nvim-ufo - Ultra Fold in Neovim
local M = {
  'kevinhwang91/nvim-ufo'
}
-- TODO: Create a package for promise-async
M.dependencies = { 'kevinhwang91/promise-async' }

M.init = function()
  vim.o.foldenable = true
  vim.o.foldcolumn = '1'
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
end

M.opts = {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end
}

return M