-- This is the main entry point to my customized neovim configuration

local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

---@type NVimConfig
NVimConfig = class('Config')

function NVimConfig:initialize(opts)
  log.debug("Initializing Config")
  self.name = 'Default'
  self.path = path.caller()
  self.stages = { 'before', 'manager', 'setup', 'after' }
  self.options = {}
  if is.present(opts) then
    self.options = vim.tbl_deep_extend('force', self.options, opts)
  end
end


function NVimConfig:configure(opts)
  self.options.shell = require('options.shell')
  self.options.ui    = require('options.ui')
  self.options.snippets = require('options.snippets')
end

function NVimConfig:load(stages)
	log.debug("Applying Config")
  local stages = stages or self.stages
  for _, stage in ipairs(stages) do
		log.debug("Configuration stage", stage)
      local stage_dir = path.join(vim.fs.dirname(self.path), stage)
      log.debug("Getting ready to apply settings in ", stage_dir)
      if path.exists(stage_dir) then
        load.all(stage_dir, self.options)
      else
        log.warn("Config Stage", stage, "is not a defined stage")
      end
    end
end

return NVimConfig
