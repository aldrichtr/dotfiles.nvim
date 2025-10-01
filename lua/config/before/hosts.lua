
local M = {}
setmetatable(M, {
  __index = M,
  __call = function(cls, ...) cls:init(...) end
})

function M:init(opts)
  if opts['hosts'] ~= nil then
    local hosts = opts.hosts
    if hosts['python'] ~= nil then
      vim.g.python3_host_prog = hosts.python
    end
  end
end

return M
