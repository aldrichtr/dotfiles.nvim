
-- Some often used options are set here, such as colorscheme, font, etc
local options = require('options')

local config = require('config')
config.options = options

local package_manager = require('manager.lazy')(options.manager)

config:before()

package_manager:load()

config:setup()

config:after()
