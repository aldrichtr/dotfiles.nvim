-- This is the main entry point to my customized neovim configuration
--
local try = require('util').try
local log = require('util.log')

---@class Config
local Config = { name = '', options = {}}
setmetatable( Config , {
  __index = Config,
  __call = function (self, ...) return Config:new(...) end
})

function Config:new(opts)
  local instance = {}
  instance = {
    name = 'Default',
    options = opts or try('options')
  }
  setmetatable(instance, self)
  return instance
end

-- --------------------------------------------------------------------------
-- Config:before is intended to be loaded before the package manager, and any
-- plugins.
-- --------------------------------------------------------------------------
function Config:before(opts)
  opts = opts or self.options
  try('config.before')(opts)
end

-- --------------------------------------------------------------------------
-- Config:setup is intended to be the main configuration settings, called just
-- after plugins are loaded.
-- --------------------------------------------------------------------------
function Config:setup(opts)
  opts = opts or self.options
  try('config.setup')(opts)
end

-- --------------------------------------------------------------------------
-- Config:setup is intended to be the main configuration settings, called just
-- after plugins are loaded.
-- --------------------------------------------------------------------------
function Config:lsp(opts)
  opts = opts or self.options
  try('config.lsp')(opts)
end
-- --------------------------------------------------------------------------
-- Config:after is intended to be loaded after all plugins and other settings
-- are loaded.  The final config before control is turned over to the user.
-- --------------------------------------------------------------------------
function Config:after(opts)
  opts = opts or self.options
  try('config.after')(opts)
end

return Config
