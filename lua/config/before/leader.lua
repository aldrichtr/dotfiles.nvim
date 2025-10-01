
local M = {}
setmetatable(M, {
  __index = M,
  __call  = function(cls, ...) return cls:init(...) end
})

function M:init(opts)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
end

return M
