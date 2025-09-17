
local try = require('util').try

local _default_manager = 'lazy'

---@class Manager
local Manager = {
  name = 'base__'
}

Manager.__index = Manager

setmetatable(
  Manager, { 
    __call = function(self, ...) 
      return self:new(...) 
    end 
  })

function Manager:new(name)
  vim.notify('[Manager] - Initializing Manager')
  if name then
    return self:create(name)
  else
    return setmetatable({}, Manager)
  end
end

---Create a new Manager of the given type (Manager Factory)
---@param name string the name of the manager type to load
function Manager:create(name)
  name = name or _default_manager
  vim.notify('[Manager] - Creating manager: ' .. name)
  return try('manager.' .. name)
end


return Manager
