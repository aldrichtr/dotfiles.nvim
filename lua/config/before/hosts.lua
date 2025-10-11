
local M = {}
setmetatable(M, {
  __index = M,
  __call = function(cls, ...) cls:init(...) end
})

function M:init(opts)
  if opts['shell'] ~= nil then
    local shell = opts.shell
    if shell['python'] ~= nil then
      vim.g.python3_host_prog = shell.python
    end
  end
end

return M
