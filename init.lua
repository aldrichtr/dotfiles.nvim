

-- I downloaded and modified the vlog script.
-- NOTE: I made it global here because it can be used anywhere in the init that I'm having issues

_G.log = require('util.log')

log.debug(string.rep("-",40))
log.debug("- Beginning neovim initialization script")

-- ------------------------------------------------------------------------------
local Config = require('config')

Config = Config:new({profile = 'default'})

Config:apply()

-- ------------------------------------------------------------------------------
log.debug("Initialization complete")
log.debug(string.rep("-",40))
