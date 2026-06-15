
local is = require('util.is')

local M = {}

function M.setup()
  if is.empty(Snacks) then
    Logger:error('Snacks is not loaded. Cant add picker keymaps')
    return nil
  end
  local option = Snacks.toggle.option
  -- Another snacks.nvim feature.  Instead of using which-key for these,
  -- use the :map(...) because that adds icons and colors to the toggles
  -- in whichkey
  option('spell', { name = 'Spelling' }):map('<leader>us')
  option('wrap', { name = 'Wrap' }):map('<leader>uw')
  option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
  option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
  Snacks.toggle.diagnostics():map('<leader>ud')
  Snacks.toggle.line_number():map('<leader>ul')
  option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
    '<leader>uc'
  )
  Snacks.toggle.treesitter():map('<leader>uT')
  Snacks.toggle.inlay_hints():map('<leader>uh')
  Snacks.toggle.indent():map('<leader>ug')
  Snacks.toggle.dim():map('<leader>uD')
end

return M
