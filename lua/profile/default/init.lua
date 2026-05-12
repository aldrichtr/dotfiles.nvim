
local options = 'profile.default.options'

local M = {}

M.name = 'default'

M.before = {}

M.managers = {
    lazy = require(options .. 'lazy'),

    langserv = require(options .. 'langserv')
  }

M.setup = {
  ui = require(options .. 'ui')
}

M.after = {}

return M
