
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

local Manager = require('manager')

local LazyManager = class('LazyManager', Manager)

local _defaults = {
  root = path.join(path.data, 'lazy'),
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  },
  setup = {  },
  packages = {'before', 'themes', 'setup', 'after'}
}

function LazyManager:initialize(opt)
  log.debug('Initializing manager - lazy')
  self.options = _defaults
  if is.present(opt) then
    self.options = vim.tbl_deep_extend('force', self.options, opt)
  end
end

function LazyManager:load(opts)
  log.debug("Loading manager lazy")
  if is.present(opt) then
    self.options = vim.tbl_deep_extend('force', self.options, opt)
  end
  local packages = self.options.packages

  log.debug("Checking for an existing lazy spec")
  if is.filled(self.options.setup.spec) then
    log.debug("spec", self.options.setup.spec, "was given")
  else
    log.debug("no spec given in options. Building spec")
     self.options.setup['spec'] = self:build_spec(packages)
  end

  if not self:isInstalled() then
    self:install()
  end

  vim.opt.runtimepath:prepend(self.options.install.path)

  -- lazy.nvim package setup utility from folke, not this manager
  local lazy_nvim = require('lazy')
  log.debug("Calling lazy.nvim plugin with", self.options.setup)
  lazy_nvim.setup(self.options.setup)

  local stats = lazy_nvim.stats()
  if is.filled(stats.count) then
    log.debug("Lazy.nvim finished loading", stats.count, "plugins")
  end
end

---Build the LazySpec from lua files in the `packages/**` files
---@param packages table A list of subdirectories in `lua/packages`
---@return LazySpec
function LazyManager:build_spec(packages)
  -- TODO: I could move this to `lua/packages/init.lua` and use `load.all`
  -- there...
  log.debug("Building lazy spec from 'packages'")
  local root = path.join(path.lua, 'packages')
  local packages = packages or _defaults.packages
  local result = {}
  -- TODO: Im not sure this is necessary but I am collecting all of the
  -- modules into spec and then returning it
  local mod
  for _, package in ipairs(packages) do
    local dir = path.join(root, package)
    log.debug("loading lazy spec in packages from", package)
    mod = load.all({dir = dir}, {})
    if is.filled(mod) then
      table.insert(result, mod)
    end
  end
  log.debug("finished building spec", result)
  return result
end

function LazyManager:isInstalled()
  if vim.fn.isdirectory(self.options.install.check) then
    log.debug("[Manager.LazyManager] - it is installed")
    return 1
  else
    log.debug("[Manager.LazyManager] - it is not installed")
    return 0
  end

end

function LazyManager:install(opts)
  local options = self.options.install
  log.debug("[Manager.LazyManager] Installing the lazy.nvim package manager")
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

return LazyManager
