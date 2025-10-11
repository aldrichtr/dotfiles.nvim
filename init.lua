

-- I downloaded and modified the vlog script.  I made it global here because
-- it can be used anywhere in the init that I'm having issues
_G.log = require('util.log')
log.debug(string.rep("-",40))
log.debug("- Beginning neovim initialization script")
local path = require('util.path')

-- My luarocks installation puts rocks in ~/.local/share/lua/share/lua/5.1
-- currently I am using the `middleclass` library for OOP, so I need to add this here early

local shared_lib_dir = path.join(path.LocalAppData, 'lua', 'share', 'lua', '5.1')
package.path = package.path .. ';' .. shared_lib_dir .. '/?.lua'

-- Add a new command, `class`
_G.class = require('middleclass')

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
-- **note** that the `config/lsp` directory is a leftover of the old configuration,
--          I am now using the options.lsp and the `config/setup/lsp` file to setup
--          the lsps.
local options = require('options')
local Manager = require('manager.lazy')
local Config = require('config')

local config = Config:new(options)

config.manager = Manager:new(options.manager)

-- This is where all the settings start to get applied
config:apply()

-- ------------------------------------------------------------------------------
log.debug("Initialization complete")
log.debug(string.rep("-",40))
