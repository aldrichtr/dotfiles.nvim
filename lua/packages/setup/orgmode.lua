local path = require('util.path')

---@class LazySpec
local M = {
  'nvim-orgmode/orgmode'
}

M.event = 'VeryLazy'

M.opts = {
  org_agenda_files = '~/Dropbox/org/**',
  org_default_notes_file = '~/Dropbox/org/inbox.org'
}

return M
