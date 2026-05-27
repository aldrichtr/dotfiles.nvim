
local path = require('util.path')

local M = {}
setmetatable(M, {
	__index = M,
	__call  = function(cls, ...) return cls:init(...) end
})

function M:init(opt)
	local tsdir = path.join(path.LocalAppData, 'tree-sitter')
	vim.opt.runtimepath:prepend(tsdir)
end

return M
