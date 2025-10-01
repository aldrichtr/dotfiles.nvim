local path = require('util.path')

local load = {}

function load.all(find, ...)
  local files = path.find(find)
  for _,file in ipairs(files) do
    local mod = path.convert_to_module(file)
    require(mod)(...)
  end
end

return load
