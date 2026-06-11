
local path = require('config.path')
local fs   = require('util.fs')
local class  = require('extern.middleclass')
local Config = require('config')

local After = class('After', Config)

function After:initialize()
	Config.initialize(self)
end

function After:apply()
  Logger:info("Setting final options")
  local tsdir = fs.join(path.LocalAppData, 'tree-sitter')
  vim.opt.rtp:prepend(tsdir)
end

return After
