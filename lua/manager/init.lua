
---@class Manager
local Manager = class('Manager')

function Manager:initialize(opt)
  log.debug("Creating new manager")
  self.name = 'manager'
  self.options = opt or require('options') or {}
end

return Manager
