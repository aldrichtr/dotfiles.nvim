
local class = require('extern.middleclass')

-- Dependencies
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

-- Static
local defaults = {
  profile = {
    root = path.join(path.lua, 'profile'),
    name = 'default'
  },
  stages = { 'before', 'managers', 'setup', 'after' }
}

local Config = class('Config')

---@public
---@param opts ConfigurationOptions
function Config:initialize(opts)
  self.name = 'Config'
  self.managers = {}
  local profile_name = opts.profile or defaults.profile.name

  local profile, err = self:load_profile(profile_name)
  if is.present(err) then
    vim.notify("Error loading config " .. err, 1)
  else
    self:apply(profile)
  end

end

---@public
---@param p ProfileOptions The profile options to apply
---@return string|nil e Returns nil if no errors were reported
function Config:apply(p)
  local stages = p.stages or defaults.stages

  for _,stage in ipairs(stages) do
    if stage == 'managers' then
      for name, opts in pairs(p.managers) do
        self:load_manager(name, opts)
      end
    else
      self:load_stage(stage)
    end
  end
end

-- ============================================================================
-- Supporting functions
-- ============================================================================


-- #region load profile -------------------------------------------------------
---@private
---@param p string The name of the profile to load
---@return string|nil err nil if successful, the error message if not
function Config:load_profile(p)
  if is.empty(p) then
    return "No profile was given to load"
  end
  local pdir = path.join(defaults.profile.root , p)

  if path.exists(pdir) then
    local mpath = path.convert_to_module(pdir)
    if is.present(mpath) then
      local mod, err = load.try(mpath)
      if is.present(err) then
        return err
      else
        self.profile = mod
        return nil
      end -- if there was an error
    end -- the path exists
  end -- p table or string
end
-- #endregion

---@private
---@param name string The name of the manager
---@param opt ManagerOptions The options needed to run the manager
---@return table|nil errors nil if successful, errors otherwise
function Config:load_manager(name, opt)
  local mgr, err = load.try('manager.' .. name)
  local e = {} -- We will collect errors here
  if is.empty(err) then
    mgr = mgr:new()
    mgr:configure(opt)
    mgr:load()
    table.insert(self.managers[name], mgr)
  else
    table.insert(e, err)
  end

  if is.present(e) then
    return e
  else
    return nil
  end
end

---@private
--- require each file in `<profile>/<stage>` directory if it exists
---@param stage string The name of the stage to load
---@param opts? table Options that should be passed to the stage module
---@return string|nil e Returns nil if no errors were reported
function Config:load_stage(stage, opts)
  local options = opts or {}
  local e = {} -- We will collect errors here
  local f_names = {'setup', 'load'}
  local p = path.join(defaults.profile.root, stage)
  if path.exists(p) then
    local m = path.convert_to_module(p)
    local mod = require(m)
    for _,f in ipairs(f_names) do
      if type(mod[f]) then
        pcall(mod .. f, options)
      end
    end
  end

  if is.present(e) then
    return table.concat(e, '\n')
  end
end

return Config
