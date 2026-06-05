
local path = require('config.path')
local fs      = require('util.fs')

local options = {
  desc = 'The lazy package manager',
  docs = 'https://lazy.folke.io',
  repo = 'https://github.com/folke/lazy.nvim.git',
  path = fs.join(path.data, 'lazy'),
  install = fs.join(path.data, 'lazy', 'lazy.nvim'),
  config = {
    spec = {
      { import = 'packages.themes' },
      { import = 'packages.setup'  }
    }
  }
}

M = {}

function M.setup()
	Logger:info("Initializing the Lazy package manager")
  if not M.isInstalled() then
		Logger:info("Lazy package manager is not installed yet")
    M.install()
  end
  vim.opt.rtp:prepend(options.install)
  local lazy = require('lazy')
  lazy.setup(options.config)
end

-- Supporting functions

function M.isInstalled()
  local gitDir = fs.join(options.install, '.git')
  return fs.exists(gitDir)
end

function M.install()
	Logger:info("Installing Lazy package manager")
  local out = vim.fn.system({
    'git', 'clone',
    '--filter=blob:none', '--branch=stable',
    options.repo, options.install })

  if vim.v.shell_error ~= 0 then
      Logger:error("Failed to clone lazy.nvim:\n%s", out)
    else
      Logger:trace("- Success!")
    end
  end

  return M
