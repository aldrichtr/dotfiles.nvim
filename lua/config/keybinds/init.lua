
local Stage = require('config.stage')
local class = require('extern.middleclass')

local Keybindings = class('Keybindings', Stage)

function Keybindings:initialize()
  Stage.initialize(self)
  self.label = 'keybinds'
  self.priority = 70
end

function Keybindings:apply()
  self:loadeach()
end

return Keybindings
