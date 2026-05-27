
local class = require('extern.middleclass')
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

local Manager = require('manager')

LanguageServerManager = class('LanguageServerManager', Manager)

function LanguageServerManager:initialize(opts)
  Logger:trace("Initializing Language Server Manager")
  Manager.initialize(self, opts)
  self.name = 'langserv'
  self.servers = {}
  self.options = opts or {}
end

function LanguageServerManager:configure(opts)
  Manager.configure(self, opts)
  local options = self.options.managers.langserv
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- "Global (*)" LSP configuration
  vim.lsp.config("*", { capabilities = client_capabilities })

end

function LanguageServerManager:load(opt)
  Manager.load(self)
  local options = self.options.managers.langserv
  -- loop through the source(s)
  --   - for each file in source, create an entry in the servers table
  for _, source in ipairs(options.source) do
    local files = path.find(source)
    for _, file in ipairs(files) do
      local mpath = path.convert_to_module(file)
      local mod = require(mpath)
      self:configure_server({ name = mod.name, config = mod.config() })
      self:enable_server({ name = mod.name })
    end
  end
end

function LanguageServerManager:configure_server(opt)
  vim.lsp.config[opt.name] = opt.config
end


function LanguageServerManager:enable_server(opt)
      vim.lsp.enable(opt.name)
end

return LanguageServerManager