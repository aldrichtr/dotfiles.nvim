-- This is the main entry point to my customized neovim configuration

-- Dependencies
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

-- Static
local DEFAULT_PROFILE = 'default'
local PROFILE_DIR = path.join(path.lua, 'profile')
local CONFIG_DIR  = path.join(path.lua, 'config')

---@type Configuration
local Config = class('Config')

function Config:initialize(opts)
  self.name = 'Config'
  log.debug("Initializing", self.name)
  self.stages = { 'before', 'manager', 'setup', 'after' }
  self.managers = {}
  self.profile = {}
end


---@private
---@param p table|string The name of the profile to load
---@return string err Nil if successful, the error message if not
function Config:load_profile(p)
  if is.empty(p) then
    return "No profile was given to load"
  end

  if is.a_table(p) then self.profile = p return nil
  elseif is.a_string(p.profile) then
    pdir = path.join(PROFILE_DIR, p.profile)
    if path.exists(pdir) then
      local mpath = path.convert_to_module(pdir)
      if is.present(mpath) then
        local mod, err = load.try(mpath)
        if is.present(err) then return err
        else self.profile = mod return nil
        end -- if there was an error
      end -- the path exists
    end -- p table or string
  else
    return string.format("Not a profile '%s'",p)
  end
end

---@private
---@param name string The name of the manager
---@param opt ManagerOptions The options needed to run the manager
function Config:load_manager(name, opt)
  local mgr, err = load.try('manager.' .. name)
  local e = {} -- We will collect errors here
  if is.empty(err) then
    mgr = mgr:new()
    mgr:configure(config)
    mgr:load()
    table.insert(self.managers[name], mgr)
  else
    table.insert(e, err)
  end

  if is.present(e) then return e end
end

---@private
--- For every item specified in profile.stage, lookup the module in the config
--- directory, if it exists, require it and call load() 
---@param stage string The name of the stage to load
---@return string e Returns nil if no errors were reported
function Config:load_stage(stage)
  local s = self.profile[stage] or nil
  local e = {} -- will collect any errors in e
  if is.a_table(s) then
    for i,m in ipairs(s) do  -- i == index, m == name of config file to load
      local p = path.join(CONFIG_DIR, stage, m .. ".lua")
      log.trace(string.format("%s) Attempting to load %d", i, p))
      if path.exists(p) then
        local mod, err = load.try(path.convert_to_module(p))
        if is.empty(err) then
          mod.load()
        else
          table.insert(e, err)
        end
      else
        table.insert(e, string.format("In stage %s, config %s does not exist", stage, m))
      end
    end
  else
    table.insert(e, string.format("Stage %s is empty in %s profile", stage, self.profile.name))
  end

  if is.present(e) then return e end
end

---@public
---@return string e Returns nil if no errors were reported

function Config:apply()
  for _,stage in ipairs(self.stages) do
    if stage == 'manager' then
      for name, config in pairs(self.profile.managers) do
      end
    else
      self.load_stage(stage)
    end
  end
end

return Config
