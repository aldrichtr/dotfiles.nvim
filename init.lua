_G.log = require('util.log')

local path = require('util.path')
local shared_lib_dir = path.join(path.LocalAppData, 'lua', 'share', 'lua', '5.1')

package.path = package.path .. ';' .. shared_lib_dir .. '/?.lua'

_G.class = require('middleclass')

local options = require('options')
local Config = require('config')
local Manager = require('manager.lazy')

local config = Config:new(options)

config.manager = Manager:new(options.manager)

config:apply()

-- ------------------------------------------------------------------------------
log.debug("Initialization complete")
