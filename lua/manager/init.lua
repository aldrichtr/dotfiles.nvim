
local try = require('util').try
local log = require('util.log')

---@class Manager
local Manager = {}
setmetatable( Manager, {
  __index = Manager,
  __call = function (self, ...) return Manager:new(...) end
})

function Manager:new(opt)
  log.debug("Creating new manager")
  local options = opt or try('options') or {}
  local instance = {
    name = 'manager',
    options = options
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

---Create a new Manager of the given type (Manager Factory)
---@param name string the name of the manager type to load
function Manager:create(name)
  local name = name or _name
  log.fmt_debug('Request to create manager: %s', name)
  return try('manager.' .. name)
end

return Manager
