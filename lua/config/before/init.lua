-- before.lua
-- Configure neovim before any plugins are loaded

local BeforeConfig = {}

-- Run the new() method when required
setmetatable( BeforeConfig , {
  __index = BeforeConfig,
  __call = function (self, ...) return BeforeConfig:new(...) end
})

function BeforeConfig:new(opts)
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

return BeforeConfig
