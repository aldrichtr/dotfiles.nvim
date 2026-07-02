
local class = require('extern.middleclass')
local fs = require('util.fs')
local is = require('util.is')
local load = require('util.load')

local Config = class('Config')
local Stage = require('config.stage'):new()

function Config:initialize(opts)
  self.stages = {}

  self.paths = require('config.path')
  if is.present(opts) then
    if is.present(opts.stages) then self.stages = opts.stages end
  end
end

function Config:get_stages()
  local stage, mod, err, modp, label, pri
  local stages = {}
  local pri_index = 90
  local iter = vim.fs.dir(self.paths.config, { depth = 1 })
  for name, type in pairs(iter) do
    if type == 'directory' then
      modp = fs.convert_to_module(name)
      mod, err = load:try(modp)
      if not mod then
        Logger:error('couldnt load stage %s: %s', modp, err)
      else
        if mod and type(mod['new']) then
          stage = mod:new()
          if stage:isSubclassOf(Stage) then
            if is.empty(stage.label) then
              label = fs.basename(name)
              Logger:warn('Stage %s does not have a label defined. Assigning %s', modp, label)
            else
              label = stage.label
            end

            if is.empty(stage.priority) then
              pri = pri_index
              Logger:warn('Stage %s does not have a priority defined. Assigning %d', modp, pri)
              pri_index = pri_index + 1
            else
              pri = stage.priority
            end
            stages[pri] = { label = label, stage = stage }
          end -- if subclass
        end -- if new
      end -- if mod
    end -- if directory
  end -- for each
  return stages
end

---@public
function Config:apply()
  Logger:info('Configuration setup initialized')
  for _, stage in ipairs(self.stages) do
    Logger:info('%s Starting stage %s', string.rep('-', 40), stage)
    self:load('config.' .. stage)
  end
end

---@public
--- First load the given module, then check if it has the
function Config:load(spec)
  local mod, obj, err
  Logger:debug('Attempting to load %s', spec)
  mod, err = load:try(spec)
  if not mod then
    Logger:error('Failed to load %s. %s', spec, err)
  elseif type(mod) ~= 'table' then
    Logger:error('%s loaded but it is a %s', spec, type(mod))
  else
    Logger:debug('The module was loaded')
    if type(mod['new']) == 'function' then
      Logger:debug('Calling new')
      obj = mod:new()
      if type(obj['apply']) == 'function' then
        Logger:debug('Calling apply')
        obj:apply()
      else
        Logger:debug('No apply() method')
      end
    else
      Logger:debug('No new() method')
    end
  end
  Logger:trace('Finished loading %s', spec)
end

-- SECTION Return

return Config

-- !SECTION Return
