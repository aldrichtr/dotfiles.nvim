
-- <https://github.com/kikito/middleclass/wiki/Quick-Example>
-- Add a new command, `class` using the middleclass library
_G.class = require('extern.middleclass')

-- I downloaded and modified the vlog script.
-- NOTE: I made it global here because it can be used anywhere in the init that I'm having issues

_G.log = require('util.log')

log.debug(string.rep("-",40))
log.debug("- Beginning neovim initialization script")

local Config = require('config')
local Lazy = require('manager.lazy')
local LangServ = require('manager.langserv')

Lazy = Lazy:new()
Config = Config:new()
LangServ = LangServ:new()


Lazy:configure()
Lazy:load()
LangServ:configure()
LangServ:load()
Config:configure()
Config:load()

-- This is where all the settings start to get applied

-- ------------------------------------------------------------------------------
log.debug("Initialization complete")
log.debug(string.rep("-",40))
