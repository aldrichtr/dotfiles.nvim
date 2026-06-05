
local path = require('config.path')
local fs      = require('util.fs')

local M = {}

function M.setup()
  Logger:info("Setting final options")
  local tsdir = fs.join(path.LocalAppData, 'tree-sitter')
  vim.opt.rtp:prepend(tsdir)
end

return M
