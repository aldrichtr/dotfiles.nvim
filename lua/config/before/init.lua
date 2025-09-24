-- before.lua
-- Configure neovim before any plugins are loaded


local try = require('util').try
local std  = require('std')


local M = {}
M.__index = M

-- Run the main() method when required
setmetatable( M , { __call = function (self, ...) return M:main(...) end })

function M:main(opts)
  local opts = opts or {}
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
  if opts['hosts'] ~= nil then
    local hosts = opts.hosts
    if hosts['python'] ~= nil then
      vim.g.python3_host_prog = hosts.python
    end
  end 
  
end

return M