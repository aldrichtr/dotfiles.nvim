
local fs     = require('util.fs')
local path   = require('config.path')
local config = require('config')
local logger = require('util.logger')

local options = {
  level = os.getenv("NVIM_LOG_LEVEL") or "WARN",
  format = "[!d<%y.%m.%d>]!LL: (!p:!n) !m",
}

local log_config = fs.join(path.init, 'logger.json')


_G.Logger = logger:new()

Logger:set(options)

if fs.exists(log_config) then Logger:read_json(log_config) end

Logger:info("- Beginning neovim initialization script" .. string.rep("-", 40))


_G.Config = config:new()

Config.stages = {
  'before',
  'lazy', 'lsp',
  'setup', 'keybinds',
  'after'
}

Config:apply()

Logger:info("Initialization complete" .. string.rep("-", 40))
