-- This is the main entry point to my customized neovim configuration

local path = require('util.path')
local load = require('util.load')

---@class Config
---@field protected name string A unique name for the class.
---@field private path string The path to the given class file
---@field manager Manager The package manager to use
---@field stages string[] List of stages to apply
---@field options ConfigOptions Settings that control the configuration
local Config = class('Config')

function Config:initialize(opts)
  log.debug("Initializing Config")
  self.name = 'Default'
  self.path = path.caller()
  self.manager = {}
  self.stages = { 'before', 'manager', 'setup', 'after' }
  self.options = require('options')
  if next(opts) ~= nil then
    self.options = vim.tbl_deep_extend('force', self.options, opts)
  end
end

function Config:apply(stages)
	log.debug("Applying Config")
  local stages = stages or self.stages
  for _, stage in ipairs(stages) do
		log.debug("Configuration stage", stage)
    if stage:match('manager') then
      self.manager:load()
    else
      local child = path.join(vim.fs.dirname(self.path), stage)
      log.debug("Getting ready to apply settings in ", child)
      if vim.uv.fs_stat(child) then
        load.all({dir = child},self.options)
      else
        log.warn("Config Stage", stage, "is not a defined stage")
      end
    end
  end
end



return Config

