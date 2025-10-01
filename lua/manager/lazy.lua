
local path = require('util.path')

local Manager = require('manager')

local Lazy = class('Lazy', Manager)

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

function Lazy:initialize(opt)
  log.debug('Initializing manager - lazy')
  self.options = _defaults
  if next(opt) ~= nil then
    self.options = vim.tbl_deep_extend('force', self.options, opt)
  end
end

function Lazy:load(opts)
  local options = opts or self.options

  if not self:isInstalled() then
    self:install()
  end

  vim.opt.runtimepath:prepend(options.install.path)

  local lazy_nvim = require('lazy')
  lazy_nvim.setup(options.setup)
end

function Lazy:isInstalled()
  if vim.fn.isdirectory(self.options.install.check) then
    log.debug("[Manager.Lazy] - it is installed")
    return 1
  else
    log.debug("[Manager.Lazy] - it is not installed")
    return 0
  end

end

function Lazy:install(opts)
  local options = self.options.install
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
