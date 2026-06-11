
local class = require('extern.middleclass')
local path  = require('config.path')


local Server = class('Server')

function Server:initialize()
  self.bin = path.mason.bin
	self.package = path.mason.package
end

function Server:apply()

end

return Server
