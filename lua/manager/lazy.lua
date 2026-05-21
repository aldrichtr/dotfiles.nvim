
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

local Manager = require('manager')

LazyManager = class('LazyManager', Manager)


function LazyManager:initialize(opts)
  Manager.initialize(self, opts)
  self.name = 'lazy'
  if is.present(opts) then
    self.options = opts
  end
end

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
    Logger:debug("Lazy.nvim finished loading", stats.count, "plugins")
  end
end

---Build the LazySpec from lua files in the `packages/**` files
---@return LazySpec
function LazyManager:build_spec()
  local root = path.join(self.options.root, self.options.packages)
  local options = self.options.managers.lazy
  local result = {}
  for _, package in ipairs(options.source) do
    local p = path.join(root, package)
    local m = path.convert_to_module(p)
    table.insert(result, { import = m })
  end
  Logger:debug("finished building spec")
  return result
end

---@return boolean True if Lazy.nvim is already installed
function LazyManager:isInstalled()
  local options = self.options.managers.lazy
  if vim.fn.isdirectory(options.install.check) then
    Logger:debug(" - it is installed")
    return 1
  else
    Logger:debug(" - it is not installed")
    return 0
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

return LazyManager
