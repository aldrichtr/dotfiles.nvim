
local path = require('util.path')
local cmp_lsp = require('cmp_nvim_lsp')
local file_ops = require('lsp-file-operations')

local M = {}
setmetatable(M, {
  __index = M,
  __call = function(cls,...) return cls:init(...) end
})

function M:init(opt)
  log.debug("Loading lsp config")

  local servers = opt.lsp.servers or {}

  self:defaults()
  for _, server in pairs(servers) do
    local name, config = server[1], server[2]
		log.debug("configuring ", name, " with command ", config.cmd)
    vim.lsp.enable(name)
    if config then
        vim.lsp.config(name, config)
    end
  end
end

function M:defaults()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  vim.tbl_deep_extend("force",
    client_capabilities, cmp_lsp.default_capabilities())
  vim.tbl_deep_extend("force",
    client_capabilities, file_ops.default_capabilities())

  -- "Global (*)" LSP configuration
  vim.lsp.config("*", {
    capabilities = client_capabilities
  })
end


return M
