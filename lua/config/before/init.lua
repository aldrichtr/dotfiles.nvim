
local Stage = require('config.stage')
local class = require('extern.middleclass')

local Before = class('Before', Stage)

function Before:initialize()
  Stage.initialize(self)
  self.label = 'before'
  self.priority = 1
end

function Before:apply()
  Logger:info('Setting priority options')
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
end

return Before
