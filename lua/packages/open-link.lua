
local M = {
  'elentok/open-link.nvim'
}

M.lazy = false
M.cmd = { 'OpenLink', 'PasteImage' }

M.init = function()
  local expanders = require('open-link.expanders')
  local options = {
    expanders = {
      -- expands "{user}/{repo}" to the github repo URL
      expanders.github
    }
  }
  require('open-link').setup(options)
end

return M
