

local M = {}
setmetatable( M, {
  __index = M,
  __call  = function(cls, ...) return cls.new(cls, ...) end,
})

function M:new()
  local instance = setmetatable({}, M)
  instance.name = 'config.keybinds.groups'
  return instance
end


function M:setup()
  Logger:debug('Setting up which-key groups')
end

return M
