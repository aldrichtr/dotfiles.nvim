local logger = require('util.logger')

_G.Logger = logger:new({
  level = os.getenv("NVIM_LOG_LEVEL") or "WARN",
  format = "[!d<%y.%m.%d>]!LL: (!p:!n) !m",
})
Logger:debug("- Beginning neovim initialization script" .. string.rep("-", 40))

local config = require('config')

config.setup()

Logger:debug("Initialization complete" .. string.rep("-", 40))
