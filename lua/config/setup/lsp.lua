
local path = require('config.path')
local fs   = require('util.fs')
local is   = require('util.is')

local M = {}

function M.setup()
  M.defaults()
  -- look for configuration files in lua/config/lsp
  local configs = fs.find(fs.join(path.config, 'lsp'))
  if is.filled(configs) then
    for _, config in ipairs(configs) do
      local server = require(fs.convert_to_module(config))
      local name = server.name
      Logger:info("Configuring Language Server %s", name)
      vim.lsp.config(name,server.config)
      vim.lsp.enable(name)
    end
  end
end

function M.defaults()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.lsp.config('*', { capabilities = client_capabilities })
end

return M
