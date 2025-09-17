
local try = require('util').try

local Manager = require('manager')

local _lazy_data_dir = vim.fn.stdpath('data') .. '/lazy'

-- Default options
local _install_options = {
	repo = 'https://github.com/folke/lazy.nvim.git',
	path = _lazy_data_dir .. '/lazy.nvim'
}

-- These will be passed to the setup function of lazy.nvim
local _default = {
    root = _lazy_data_dir,
    spec = 'packages',
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json'
}
-- Default options

---@class Lazy : Manager
local Lazy = setmetatable({}, { __index = Manager })
Lazy.__index = Lazy

function Lazy:new()
  vim.notify('[Manager.Lazy] - Initializing manager')
  local instance = Manager:new()
  instance.name = 'lazy'
  setmetatable(instance, self)
  self.__index = self
  return instance
end


---Load the module with the given options
---@param opts ManagerOptions
function Lazy:load(opts)
  local options = opts or _default
  if not self:isInstalled() then
    self:install() 
  end

  vim.opt.runtimepath:prepend(_install_options.path)

  local lazy_nvim = try('lazy')
  vim.notify("[Manager.Lazy] - Initializing lazy.nvim from " .. options.spec)
  lazy_nvim.setup(options)
end


function Lazy:isInstalled()
  local lazy_git_dir = _install_options.path .. '/.git'

  vim.notify("[Manager.Lazy] Checking if lazy.nvim is installed")
  vim.notify("[Manager.Lazy] - Looking for the  '" .. lazy_git_dir .. "' directory" )


  if vim.fn.isdirectory(lazy_git_dir) then
    vim.notify("[Manager.Lazy] - it is installed")
    return 1
  else
    vim.notify("[Manager.Lazy] - it is not installed")
    return 0
  end

end

---Install the lazy.nvim package manager
---@param opts? ManagerOptions
function Lazy:install(opts)
  local options = opts or _install_options

  vim.notify("[Manager.Lazy] Installing the lazy.nvim package manager")
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', -- latest stable release
    options.repo, options.path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  else
    vim.notify("[Manager.Lazy] - Success")
  end
end

setmetatable( Lazy , { __call = function (self, ...) return Lazy:new(...) end})

return Lazy
