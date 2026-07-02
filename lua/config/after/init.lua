
local Stage = require('config.stage')
local class = require('extern.middleclass')
local fs = require('util.fs')
local path = require('config.path')

local After = class('After', Stage)

function After:initialize()
  Stage.initialize(self)
  self.label = 'after'
  self.priority = 99
end

function After:apply()
  Logger:info('Setting final options')
  local tsdir = fs.join(path.LocalAppData, 'tree-sitter')
  vim.opt.rtp:prepend(tsdir)
end

return After
