
local path = require('config.path')
local fs      = require('util.fs')
local class  = require('extern.middleclass')
local Config = require('config')

local Before = class('Before', Config)

function Before:initialize()
	Config.initialize(self)
end

function Before:apply()
  Logger:info("Setting priority options")
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

	Logger:trace('adding tree-sitter to the runtimepath')
  local tsdir = fs.join(path.LocalAppData, 'tree-sitter')
  vim.opt.rtp:prepend(tsdir)
end

return Before
