
local Stage = require('config.stage')
local class = require('extern.middleclass')

local Setup = class('Setup', Stage)

function Setup:initialize()
  Stage.initialize(self)
  self.label = 'setup'
  self.priority = 50
end

function Setup:apply()
  self:loadeach()
end

return Setup
