
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

local CONFIG_DIR = path.join(path.lua, 'config')


local Manager = require('manager')

LangServerManager = class('LangServerManager', Manager)

function LangServerManager:initialize(opts)
  Manager.initialize(self, opts)
  self.name = 'langserv'
  self.options = require('options.' .. self.name)
  self.servers = {}
end

function LangServerManager:configure(opts)
  Manager.configure(self, opts)
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- "Global (*)" LSP configuration
  vim.lsp.config("*", { capabilities = client_capabilities })

  log.trace(string.rep("-" , 60))
  log.trace("-- Configuring the Language Server Manager")
  -- loop through the source(s)
  --   - for each file in source, create an entry in the servers table
  for _, source in ipairs(self.options.source) do
    local files = path.find(source)
    for _, file in ipairs(files) do
      local name = path.convert_to_module(file)
      local mod = require(name)
      table.insert(self.servers, mod.name)
      log.trace("Loading language server '", mod.name, "' from '", name, "'")
      vim.lsp.config[mod.name] = mod.config()
      vim.lsp.enable(mod.name)
    end
  end
end

function LangServerManager:configure_server(name, config)
  local p = path.join()
end


function LangServerManager:enable_server(name)

end

function LangServerManager:load(pkg)
  Manager.load(self)
end

return LangServerManager
