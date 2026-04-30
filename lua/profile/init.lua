

local Profile = class('Profile')


function Profile:initialize()
  self.name = '_base'
  self.before = {}
  self.managers = {}
  self.setup = {}
  self.after = {}

end
