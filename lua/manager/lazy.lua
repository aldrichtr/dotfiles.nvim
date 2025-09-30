
local try = require('util').try
local path = require('util.path')
local log  = require('util.log')

local Manager = require('manager')

---@class LazyManager
local Lazy = {}
setmetatable( Lazy, {
  __index = Lazy,
  __call = function (self, ...) return Lazy:new(...) end
})

-- @class LazyOptions
local _defaults = {
  root = path.join(path.data, 'lazy'),
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  },
  setup = { "packages" }
}
-- #endregion Default options


function Lazy:new(opt)
  log.debug('Initializing manager - lazy')
  local options = opt or _defaults
  local instance = Manager:new()

  instance.name = 'lazy'
  instance.options = options
  setmetatable(instance, self)
  self.__index = self
  return instance
end


---Load the module with the given options
---@param opts ManagerOptions
function Lazy:load(opts)
  local options = opts or self.options

  if not self:isInstalled() then
    self:install()
  end

  vim.opt.runtimepath:prepend(options.install.path)

  local lazy_nvim = try('lazy')
  if lazy_nvim then
    lazy_nvim.setup(options.setup)
  end
end


function Lazy:isInstalled()
  local options = self.options or _defaults
  if vim.fn.isdirectory(options.install.check) then
    log.debug("[Manager.Lazy] - it is installed")
    return 1
  else
    log.debug("[Manager.Lazy] - it is not installed")
    return 0
  end

end

---Install the lazy.nvim package manager
---@param opts? ManagerOptions
function Lazy:install(opts)
  local options = self.options.install or _defaults.install
  log.debug("[Manager.Lazy] Installing the lazy.nvim package manager")
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', 
    '--branch=stable', options.repo, options.path })
  if vim.v.shell_error ~= 0 then
    vim.notify({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  else
    log.debug("- Success!")
  end
end

return Lazy
