
-- Add a new command, `class`
_G.class = require('extern.middleclass')

local load = require('util.load')

-- I downloaded and modified the vlog script.
-- NOTE: I made it global here because it can be used anywhere in the init that I'm having issues

_G.log = require('util.log')

log.debug(string.rep("-",40))
log.debug("- Beginning neovim initialization script")

local Lazy = require('manager.lazy')
local LangServ = require('manager.langserv')
local Config = require('config')

local lazy = Lazy:new()
local nv = Config:new()
local lsp = LangServ:new()

-- ------------------------------------------------------------------------------
-- This is where my configuration starts.
-- **options** : These are some frequently changed options that control the
--               configuration
-- **manager** : This is a set of classes that represent package managers such
--               as lazy, mason, packer, etc.
-- **config**  : This is the main "driver" of the initialization script.  It
--               will:
--               - Run all scripts in the `config/before` directory
--               - Initialize and run the manager
--               - Run all the scripts in the `config/setup` directory
--               - Run all the scripts in the `config/after` directory

lazy:configure()
nv:configure()
lsp:configure()

-- This is where all the settings start to get applied
lazy:load()
nv:load()
lsp:load()

-- ------------------------------------------------------------------------------
log.debug("Initialization complete")
log.debug(string.rep("-",40))
