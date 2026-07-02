
local str = require('util.string')

local M = {}

function M:get()
  local t = {}
  local n, h
  for f in ipairs(vim.opt.guifont) do
    n, h = str:split(f, ':')
  end
end

return M
