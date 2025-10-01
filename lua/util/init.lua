-- Util module

local M = {}

---Attempt to require a module with error handling
---@param mod string dot-separated path to module
---@return mod|nil, error
---``` lua
--- local mod = try('util')
--- if not mod then
---   -- mod is the error
--- end
--- ```
function M.try(mod,...)
  local ok, mod_or_err = pcall(require, mod, ...)
  if ok then
    return mod_or_err
  else
    return nil, mod_or_err
  end
end

-- TODO: I don't think this is the right place for this

--- Toggle line numbers between relative and ordered
function M.toggle_numbers()
  if vim.o.relativenumber then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end

return M
