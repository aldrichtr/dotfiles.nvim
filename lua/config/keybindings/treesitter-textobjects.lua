
local function textobjects()
  local select = require('nvim-treesitter-textobjects.select').select_textobject
  local keys = {
    {"af", function() select("@function.outer", "textobjects") end,mode = { "x", "o" }, desc = 'Select outer function' },
    {"if", function() select("@function.inner", "textobjects") end, mode = { "x", "o" }, desc = 'Select inner function'},
    {"ac", function() select("@class.outer", "textobjects") end, mode = { "x", "o" }, desc = 'Select outer class'},
    {"ic", function() select("@class.inner", "textobjects") end, mode = { "x", "o" }, desc = 'Select inner class'}
  }
return keys
end

return textobjects