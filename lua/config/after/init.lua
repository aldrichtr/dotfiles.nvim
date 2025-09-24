-- after.lua
-- Configure neovim after all plugins are loaded


local try = require('util').try
local std  = require('std')


local M = {}
M.__index = M

-- Run the main() method when required
setmetatable( M , { __call = function (self, ...) return M:main(...) end })

function M:main(opts)
end

return M