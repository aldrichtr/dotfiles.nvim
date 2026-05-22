
-- REGION Dependencies
local class = require('extern.middleclass')
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')
local t_copy = vim.tbl_deep_extend

local _install_ = {
  root = path.join(path.data, 'lazy'),
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  }
}
-- !REGION


-- SECTION  Initialization
local Manager = require('manager')

LazyManager = class('LazyManager', Manager)


function LazyManager:initialize(opts)
  Manager.initialize(self, opts)
  self.name = 'lazy'
  if is.present(opts) then
    self.options = opts
  end
end

-- !SECTION

function LazyManager:configure(opts)
  Manager.configure(self, opts)
  Logger:debug("Loading manager lazy")

  if is.present(opts) then
    t_copy('force', self.options, opts)
  end

  if not self:isInstalled() then
    Logger:warn("Lazy package manager not installed")
    self:install()
  end
end

function LazyManager:load()
  Manager.load(self)
  local options = self.options.managers.lazy
  vim.opt.runtimepath:prepend(options.install.path)

  -- lazy.nvim package setup utility from folke, not this manager
  local lazy_nvim = require('lazy')
  Logger:info("Now loading lazy.nvim")
  lazy_nvim.setup(options.setup)

  local stats = lazy_nvim.stats()
  if is.filled(stats.count) then
    Logger:info("Lazy.nvim finished loading %s out of %s", stats.loaded, stats.count)

    self:register_commands()
  end
end


---@return boolean True if Lazy.nvim is already installed
function LazyManager:isInstalled()
  local options = self.options.managers.lazy
  if vim.fn.isdirectory(options.install.check) then
    Logger:debug(" - it is installed")
    return true
  else
    Logger:debug(" - it is not installed")
    return false
  end

end

function LazyManager:install(opts)
  local options = self.options.managers.lazy
  if is.present(opts) then
    for k,v in pairs(opts) do
      options[k] = v
    end
  end
  Logger:info("[Manager.LazyManager] Installing the lazy.nvim package manager")

  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable', options.repo, options.path })

  if vim.v.shell_error ~= 0 then
    Logger:error("Failed to clone lazy.nvim:\n%s", out)
  else
    Logger:trace("- Success!")
  end
end

function LazyManager:register_commands()
  local root = path.join(self.options.root, self.options.packages)
  local enabled = { 'before', 'after', 'themes', 'setup' }
  local disabled = 'disabled'

  vim.api.nvim_create_user_command('DisablePlugin',
  function(opts)
    local name = opts.fargs[1]
    local p = name .. ".lua"
    local pkg, dpkg
    for _, e in ipairs(enabled) do
      pkg = path.join(root, e, p)
      dpkg = path.join(root, disabled, p)
      if path.exists(pkg) and not path.exists(dpkg) then
        os.rename(pkg, dpkg)
      end
    end
  end, {nargs = 1})

  vim.api.nvim_create_user_command('EnablePlugin',
  function(opts)
    local name = opts.fargs[1]
    local p = name .. ".lua"
    local pkg = path.join(root, 'setup', p)
    local dpkg = path.join(root, 'disabled', p)
    if path.exists(dpkg) and not path.exists(pkg) then
      os.rename(d,s)
    end
  end, {nargs = 1})
end

return LazyManager
