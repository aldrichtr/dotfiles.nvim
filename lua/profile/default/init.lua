

local Profile = require('profile')

local Default = class('Default', Profile)


function Default:initialize()
  self.name = 'default'
  self.managers = {
    lazy = {},
    langserv = {}
  }
  self.before = {}
  self.setup = {}
  self.after = {}
end

return Default
