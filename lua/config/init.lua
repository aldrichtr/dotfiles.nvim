
local stages = { "before", "lazy", "setup", "after" }

local Config = {}

function Config.setup()
  for _, stage in ipairs(stages) do
		Logger:debug("Loading %s", stage)
		mod = require('config.' .. stage)
		mod.setup()
  end
end

return Config
