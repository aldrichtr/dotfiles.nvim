-- after.lua
-- Configure neovim after all plugins are loaded

local AfterConfig = {}

-- Run the main() method when required
setmetatable( AfterConfig , {
  __index = AfterConfig,
  __call = function (self, ...) return AfterConfig:new(...) end
})

function AfterConfig:new(opts)
end

return AfterConfig
