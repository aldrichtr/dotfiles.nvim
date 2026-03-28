
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

local _install_ = {
  root = path.join(path.data, 'lazy'),
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  }
}

local Manager = require('manager')

LazyManager = class('LazyManager', Manager)


function LazyManager:initialize(opts)
  Manager.initialize(self, opts)
  self.name = 'lazy'
  -- TODO: I really would rather do this from the Manager, but it is running as
  --       Manager instead of LazyManager
  self.options = require('options.' .. self.name)
  -- This is where the individual neovim
  -- plugin lazyspecs are loaded from.  Each item is a directory under
  -- lua/packages
  -- NOTE:: The order is important here.
  self.options.source = {'before', 'themes', 'setup', 'after'}
  if is.present(opts) then
    vim.tbl_deep_extend('force', self.options, opts)
  end
end

function LazyManager:configure(opts)
  Manager.configure(self, opts)
  log.debug("Loading manager lazy")

  if not self:isInstalled() then
    self:install()
  end

  if is.present(self.options.setup.spec) then
    log.debug("spec", self.options.setup.spec, "was given")
  else
    log.debug("no spec given in options. Building spec")
     self.options.setup['spec'] = self:build_spec(packages)
  end
end

function LazyManager:load()
  Manager.load(self)
  vim.opt.runtimepath:prepend(self.options.install.path)

  -- lazy.nvim package setup utility from folke, not this manager
  local lazy_nvim = require('lazy')
  log.info("Now loading lazy.nvim")
  lazy_nvim.setup(self.options.setup)

  local stats = lazy_nvim.stats()
  if is.filled(stats.count) then
    log.debug("Lazy.nvim finished loading", stats.count, "plugins")
  end
end

---Build the LazySpec from lua files in the `packages/**` files
---@return LazySpec
function LazyManager:build_spec()
  local root = path.join(path.lua, 'packages')
  local result = {}
  local mods
  for _, package in ipairs(self.options.source) do
    local current_path = path.join(root, package)
    log.debug(string.format("loading lazy spec in packages from stage: '%s'", package))
    log.trace(string.format("Current stage path to load '%s'", current_path))
    mods = load.all(current_path)
    -- load all gives us back a table of tables, we want to "unwrap" that
    -- by one layer
    if is.filled(mods) then
      for _, mod in ipairs(mods) do
        table.insert(result, mod)
      end
    end
  end
  log.debug("finished building spec")
  return result
end

---@return boolean True if Lazy.nvim is already installed
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
  local options = _install_
  if is.present(opts) then
    for k,v in pairs(opts) do
      options[k] = v
    end
  end
  log.info("[Manager.LazyManager] Installing the lazy.nvim package manager")

  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none',
    '--branch=stable', options.repo, options.path })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone lazy.nvim:", vim.log.levels.ERROR)
    vim.notify(out, vim.log.levels.WARN)
  else
    log.debug("- Success!")
  end
end

return LazyManager
