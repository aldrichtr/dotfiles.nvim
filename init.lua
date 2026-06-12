
local options = {
  level = os.getenv("NVIM_LOG_LEVEL") or "WARN",
  format = "[!d<%y.%m.%d>]!LL: (!p:!n) !m",
	file = { enabled = true }
}
-- TODO: Use `vim.json` to read in options if file exists

local logger = require('util.logger')

_G.Logger = logger:new()

Logger:set(options)

Logger:info("- Beginning neovim initialization script" .. string.rep("-", 40))

local config = require('config')

local Config = config:new()

Config.stages = {
	'before',
	'lazy', 'lsp',
	'setup', 'keybinds',
	'after'
}

Config:apply()

Logger:info("Initialization complete" .. string.rep("-", 40))
