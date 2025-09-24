local Manager = require('manager')

---@class Mason : Manager
local Mason = setmetatable({}, {__index = Manager})
Mason.__index = Mason



function Mason:new()
  vim.notify('Calling mason:new')
  local instance = Manager:new()
  setmetatable(instance, self)
  instance.name = 'mason'
  return instance
end

---Load the module with the given options

---@param opts ManagerOptions
function Mason:load(opts)
end