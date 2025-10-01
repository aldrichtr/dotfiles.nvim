local log = require('util.log')
local cmp_lsp = require('cmp_nvim_lsp')
local file_ops = require('lsp-file-operations')


local LspConfig = {}
setmetatable(LspConfig, {
  __index = LspConfig,
  __call = function(cls, ...) return cls:new(...) end
})



---@class Config.LspConfig
---@param opt LspOptions
function LspConfig:new(opt)
  log.debug("Loading lsp config")
  local instance = {
    name = 'lspconfig',
    options = opt or {servers = {}}
  }
  setmetatable(instance, self)
  return instance
end

function LspConfig:enable()
  log.debug("Enabling lsp servers")
  local servers = self.options.servers

  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
 
  vim.tbl_deep_extend("force", client_capabilities, cmp_lsp.default_capabilities())
  vim.tbl_deep_extend("force", client_capabilities, file_ops.default_capabilities())

  -- "Global (*)" LSP configuration
  vim.lsp.config("*", {
    capabilities = client_capabilities
  })

  if next(servers) ~= nil then
    for _, server in servers do
      vim.lsp.config[server] = require('config.lsp' .. server)
      vim.lsp.enable(server)
    end
  end
end

return LspConfig
