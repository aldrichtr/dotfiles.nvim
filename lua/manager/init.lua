
local is = require('util.is')

---@class Manager
--- An abstract Package manager for the various types of packages, services,
--- etc.  Intended use is:
--- local Manager = require('manager.<type>')
--- Manager:new(options) - or -
--- Manager:new()
--- Manager:configure(options)
---
--- Manager:load()
Manager = class('Manager')

---@param opts ManagerOptions
function Manager:initialize(opts)
  self.name = 'manager'
  if is.present(opts) then
   self.options = vim.tbl_deep_extend('force', self.options, opts)
  end
end

function Manager:configure(opts)
  if is.filled(opts) then
   self.options = vim.tbl_deep_extend('force', self.options, opts)
  end
end

function Manager:load() end

function Manager:reload() end

function Manager:subclassed(child)
  if child.configure == Manager.configure then
    error(child.name .. " must implement the configure() method")
  end
  if child.load == Manager.load then
    error(child.name .. " must implement the load() method")
  end
end

return Manager
