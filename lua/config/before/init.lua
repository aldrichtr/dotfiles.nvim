
local path = require('config.path')
local fs      = require('util.fs')

local M = {}

function M.setup()
  Logger:info("Setting priority options")
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  local tsdir = fs.join(path.LocalAppData, 'tree-sitter')
  vim.opt.rtp:prepend(tsdir)
end

return M
