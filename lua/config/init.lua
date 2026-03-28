-- This is the main entry point to my customized neovim configuration

local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

---@type Config
Config = class('Config')

function Config:initialize(opts)
  log.debug("Initializing Config")
  self.name = 'Default'
  self.path = path.caller()
  self.stages = {'before', 'setup', 'after', 'keybindings'}
  self.options = {}
  if is.present(opts) then
    self.options = vim.tbl_deep_extend('force', self.options, opts)
  end
end


function Config:configure(opts) end

function Config:load(stages)
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

return Config
