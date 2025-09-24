-- This is the main entry point to my customized neovim configuration
-- 
local try = require('util').try

---@class Config : Profile
local Config = setmetatable({}, { __index = Config })

setmetatable( Config , { __call = function (self, ...) return Config:new(...) end })

function Config:new(opts)
  local instance = {}
  setmetatable(instance, self)
  instance = {
    name = 'Default',
    options = opts or try('options')
  }
  return instance
end

-- --------------------------------------------------------------------------
function Config:before(opts)
  opts = opts or self.options
  try('config.before')(opts)
end

function Config:setup(opts)
  opts = opts or self.options
  try('config.setup')(opts)
end

function Config:after(opts)
  opts = opts or self.options
  try('config.after')(opts)
end

return Config
