
local path = require('config.path')
local fs   = require('util.fs')
local class  = require('extern.middleclass')
local Config = require('config')

local Lazy = class('Lazy', Config)

function Lazy:initialize()
	Config.initialize(self)
  self.desc = 'The lazy package manager'
  self.docs = 'https://lazy.folke.io'
  self.repo = 'https://github.com/folke/lazy.nvim.git'
  self.path = fs.join(path.data, 'lazy')
  self.install = fs.join(path.data, 'lazy', 'lazy.nvim')
  self.config = {
    spec = {
      { import = 'packages.themes' },
      { import = 'packages.setup'  }
    }
  }
	Logger:info("Initializing the Lazy package manager")
  if not self:isInstalled() then
		Logger:info("Lazy package manager is not installed yet")
    self:install()
  end
  vim.opt.rtp:prepend(self.install)
  local lazy = require('lazy') -- the other one ;-)
  lazy.setup(self.config)
end

-- Supporting functions

function Lazy:isInstalled()
  local gitDir = fs.join(self.install, '.git')
  return fs.exists(gitDir)
end

function Lazy:install()
	Logger:info("Installing Lazy package manager")
  local out = vim.fn.system({
    'git', 'clone',
    '--filter=blob:none', '--branch=stable',
    self.repo, self.install })

  if vim.v.shell_error ~= 0 then
      Logger:error("Failed to clone lazy.nvim:\n%s", out)
    else
      Logger:trace("- Success!")
    end
  end

  return Lazy
