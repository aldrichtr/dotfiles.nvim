local path = require('util.path')

---@class LazySpec
local M = {
  'chipsenkbeil/org-roam.nvim'
}

M.tag = '0.2.0'

M.dependencies = {
  {'nvim-orgmode/orgmode', tag = '0.7.0'}
}

M.opts = {
  directory = '~/Dropbox/org'
}

return M
