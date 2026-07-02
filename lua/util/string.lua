
local M = {}

function M:split(input, sep)
  local sep = sep or '%s' -- split on whitespace if not specified
  local t = {}
  local pattern = '([^' .. sep .. ']+)'

  for str in string.gmatch(input, pattern) do
    t:insert(str)
  end

  return t
end

return M
