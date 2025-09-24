
local try = require('util').try
local log = require('util.log')

local _name = 'manager'
---@class Manager
local Manager = { name = _name } -- Table that represents the Manager
local class = {
  __index = Manager, -- Failed lookups to the object should fall back to the class (static method)
  __call = function(m, ...) 
    return m:new(...) 
  end 
}
-- Call new() when the Class is required
setmetatable( Manager, class )

function Manager:new()
  log.debug("Creating new manager")
  local m = { name = _name }
  setmetatable(m, self)
  self.__index = self
  return m
end

---Create a new Manager of the given type (Manager Factory)
---@param name string the name of the manager type to load
function Manager:create(name)
  local name = name or _name
  log.fmt_debug('Request to create manager: %s', name)
  return try('manager.' .. name)
end

return Manager
