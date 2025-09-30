
local M = {}


function M.dir(opts)
  local directory
  local match
  local exclude
  if opts['dir'] then
    directory = opts.dir
  else
    directory = opts
  end
  match = opts.match or "(.+).lua$"
end
return M
