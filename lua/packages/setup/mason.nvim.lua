
local fs = require('util.fs')
local path = require('config.path')

local M = {
  'mason-org/mason.nvim'
}

M.opts = {
  install_root_dir = fs.join(path.LocalAppData, 'mason')
}

return M
