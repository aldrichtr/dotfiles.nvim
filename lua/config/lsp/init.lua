
local LspConfig = {}
setmetatable(LspConfig, {
  __index = LspConfig,
  __call = function(self, ...) return LspConfig:new(...) end
})

function LspConfig:new(opt)
  local options = opt or {}
  local instance = {
    name = 'lspconfig',
    options = options
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function LspConfig:configure(opt)
  local options = opt or self.options
  vim.lsp.config['luals'] = require('config.lsp.luals')
end

function LspConfig:enable()
  local options = opt or self.options
  vim.lsp.enable('luals')
end

return LspConfig
