
local is = require('util.is')

local M = {}

local key = '<leader>u'

function M:map(char)
  return key .. char
end

function M:setup()
  if is.empty(Snacks) then
    Logger:error('Snacks is not loaded. Cant add picker keymaps')
    return nil
  end
  local t = Snacks.toggle
  local option = t.option
  -- Another snacks.nvim feature.  Instead of using which-key for these,
  -- use the :map(...) because that adds icons and colors to the toggles
  -- in whichkey
  option('spell', { name = 'Spelling' }):map(self:map('s'))
  option('wrap', { name = 'Wrap' }):map(self:map('w'))
  option('relativenumber', { name = 'Relative Number' }):map(self:map('L'))
  option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map(self:map('b'))
  t.diagnostics():map(self:map('d'))
  t.line_number():map(self:map('l'))
  option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
    self:map('c')
  )
  t.treesitter():map(self:map('T'))
  t.inlay_hints():map(self:map('h'))
  t.indent():map(self:map('g'))
  t.dim():map(self:map('D'))
end

return M
