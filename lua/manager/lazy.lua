
local try = require('util').try
local path = require('std').path
local log  = require('util.log')

local Manager = require('manager')

---@class LazyManager
local Lazy = { name = 'lazy' }
Lazy.__index = Lazy
local class = {
  __index = Manager, -- inherit Manager
  __call  = function(m, ...)
    return m:new(...)
  end
}
setmetatable( Lazy, class )

-- #region Default options
-- @class LazyOptions
local _lazy = { root = path.join(path.data, 'lazy') }
_lazy.install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    path = path.join(_lazy.root, 'lazy.nvim'),
  }
_lazy.install.check = path.join(_lazy.install.path, '.git')
_lazy.setup = {
    spec = 'packages',
    lockfile = path.join(path.data, '/lazy-lock.json')
  }
-- #endregion Default options

function Lazy:new()
  log.debug('Initializing manager')
  local instance = Manager:new()
  instance.name = 'lazy'
  setmetatable(instance, self)
  self.__index = self
  return instance
end


---Load the module with the given options
---@param opts ManagerOptions
function Lazy:load(opts)
  local options = opts or _lazy
  if not self:isInstalled() then
    self:install() 
  end

  vim.opt.runtimepath:prepend(options.install.path)

  local lazy_nvim = try('lazy')
  log.debug("Initializing lazy.nvim from " .. options.setup.spec)
  lazy_nvim.setup(options.setup)
end


function Lazy:isInstalled()
  if vim.fn.isdirectory(_lazy.install.check) then
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
  local options = opts or _lazy.install
  log.debug("[Manager.Lazy] Installing the lazy.nvim package manager")
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', -- latest stable release
    options.repo, options.path })
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
