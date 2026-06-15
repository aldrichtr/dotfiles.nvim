
local fs = require('util.fs')
local path = require('config.path')

local M = {
  "TheLeoP/powershell.nvim",
}

M.opts = {
  bundle_path = fs.join(path.lsp, 'powershell_es')
}


return M
