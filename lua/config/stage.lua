
local class = require('extern.middleclass')
local fs = require('util.fs')
local is = require('util.is')
local path = require('config.path')

local Stage = class('Stage')

---@protected
--- Initialize the `Stage` object.  Called automatically by `new()`
function Stage:initialize()
  self.label = ''
end

function Stage:get_path()
  return fs.join(path.config, self.label)
end

---@protected
--- Call `self:load()` on each file in the stage`s directory
---@return table result A list of name => success of each file
function Stage:loadeach()
  local fname, mname, mod, err, key
  local result = {}
  Logger:debug('Loading all files for %s in %s', self.label, path)
  local files = fs.find({
    dir = self:get_path(),
    excludes = { 'init.lua' },
  })

  if is.filled(files) then
    Logger:debug(' - found files. Loading now')
    for _, file in ipairs(files) do
      fname = fs.basename(file)
      mname = fs.convert_to_module(file)
      key = {
        success = nil,
        message = 'unknown',
      }
      mod, err = self:load(mname)
      if mod then
        key.success = true
        key.message = string.format('%s loaded by %s', fname, mname)
      else
        key.success = false
        key.message = string.format('%s not loaded by %s: %s', fname, self.name, err)
      end
      result[fname] = key
    end
  else
    Logger:warn('%s contained no valid files to load', self.name)
  end
  return result
end

function Stage:try(name)
  local success, result = pcall(require, name)
  if success then
    return result
  else
    return nil, result
  end
end

---@protected
--- First require the module. Then check if it is a middleclass class, if so
--- call `new()`
---@param name string The name of the file to load expressed as a module path
--- require or new
function Stage:load(name)
  local m, err
  Logger:debug('Attempting to load %s', name)
  m, err = self:try(name)
  if not m then return { nil, err } end

  Logger:debug('The module was loaded')
  if type(m['new']) == 'function' then
    Logger:debug('Creating new %s', name)
    return m:new()
  elseif type(m['setup']) == 'function' then
    return m:setup()
  else
    Logger:debug('No new method')
    return m
  end
end

-- SECTION Return

return Stage

-- !SECTION Return
