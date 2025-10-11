-- Util module

local M = {}


-- TODO: I don't think this is the right place for this, so I need another
-- namespace for "functions that I want to map to keybindings", maybe it belongs
-- in config/setup/keybindings.lua?

--- Toggle line numbers between relative and ordered
function M.toggle_numbers()
  if vim.o.relativenumber then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end

return M
