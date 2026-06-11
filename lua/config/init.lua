
local load = require('util.load')
local is   = require('util.is')
local fs   = require('util.fs')
local class = require('extern.middleclass')

local Config = class('Config')

function Config:initialize(opts)
  self.name = 'nvim.config'
  self.paths = require('config.path')
  self.stages = {}
  if is.present(opts) then
    if is.present(opts.stages) then
      self.stages = opts.stages
    end
  end
end

---@private
--- Looks for `config/<name>.lua` or `config/<name>/init.lua`
---@param name string Name of module or directory to check
---@return bool True if the given `name` is a module
function Config:is_module(name)
  -- look for name.lua or name/init.lua
  local fname = string.format('%s.lua', name)
	local iname = string.format('%s/init.lua', name)
  local path
	-- 
	path = fs.join(self.paths.config, fname)
	Logger:debug('Testing if %s exists', path)
	if fs.exists(path) then return true end
	path = fs.join(self.paths.config, iname)
	Logger:debug('Testing if %s exists', path)
	if fs.exists(path) then return true end
  return false
end

---@public
--- Apply the given `Config`
---@param spec string  
function Config:apply(opts)
  Logger:info('Configuration setup initialized')
  for _, stage in ipairs(self.stages) do
    local mod, Stage, err
    Logger:debug('Checking if %s is a module', stage)
    if self:is_module(stage) then
      Logger:debug('%s is a module.  Looking for apply function', stage)
			mod = require('config.' .. stage)
		  Stage = mod:new()
			Stage:apply()
    else -- is mod present
      Logger:debug('%s is not a module.  Looking for files', stage)
			self:load_each(stage)
    end
  end -- for each stage
end


function Config:load_each(name)
	local finder = {
		root    = fs.join(self.paths.config, stage),
		match   = { '(.+).lua$' },
		exclude = { 'init.lua$' }, -- shouldn't have to, but just incase
		type    = 'file'
	}
	local files = fs.find(finder)
	if is.filled(files) then
		Logger:debug(' - found files. Loading now')
		for _, file in ipairs(files) do
			local p = fs.convert_to_module(file)
			Logger:debug('Attempting to load %s', p)
			local mod, File, err
			mod = load:try(fs.convert_to_module(file))
			if is.present(mod) then
				Logger:debug('%s is a module.  Looking for apply function', p)
				File = mod:new()
				if type(File['apply']) == 'function' then
					Logger:debug('- found apply.  Calling now')
					File:apply()
				end -- has setup
			else -- no mod present
				Logger:error('Could not load configuration stage %s %s', p, err)
			end -- is mod present
		end -- for each file
	else -- nothing in files
		Logger:warn('%s contained no valid files to load', stage)
	end -- is there files

end
-- SECTION Return

return Config

-- !SECTION Return
