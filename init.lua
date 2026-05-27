
-- --------------------------------------------------------------------------------------------------------
-- Establish a logging facility globally because it can be used anywhere in the init that I'm having issues

local logger = require('util.logger')

_G.Logger = logger:new({
  level = "TRACE",
  format = "[!d<%y.%m.%d>]!LL: (!p:!n) !m"
})
-- --------------------------------------------------------------------------------------------------------
--
Logger:debug("- Beginning neovim initialization script" .. string.rep("-", 40))

local Config = require('config')

local options = { profile = "default" }

Config = Config:new(options)
Logger:debug("Applying %s profile", options.profile)
Config:apply()

_G.Config = Config

-- --------------------------------------------------------------------------------------------------------
Logger:debug("Initialization complete" .. string.rep("-",40))
