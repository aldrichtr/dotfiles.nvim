local Manager = require('manager')

---@class Mason : Manager
local Mason = {}
setmetatable(Mason, {
  __index = Mason,
  __call = function(self, ...) return Mason:new(...) end
})



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
