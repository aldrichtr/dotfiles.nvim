
-- SECTION Dependencies
local class = require('extern.middleclass')
local path = require('util.path')
local load = require('util.load')
local is   = require('util.is')

local defaults = {
  profile = {
    root = path.join(path.lua, 'profile'),
    name = 'default'
  },
  stages = { 'before', 'managers', 'setup', 'after' }
}

-- !SECTION

-- SECTION Initialization

local Config = class('Config')

---@public
---@param opts ConfigurationOptions
function Config:initialize(opts)
  local opts = opts or { profile = defaults.profile.name }
  self.name = 'Config'
  self.managers = {}
  -- sets self.options to the values in the profile
  Logger:info("Preparing to load profile '%s'", opts.profile)
  local _, err = self:load_profile(opts.profile)

  if is.present(err) then
    Logger:error("Error loading config: %s ", err)
  else
    Logger:info("Success")
  end
end
-- !SECTION

-- ============================================================================
-- SECTION Public functions
---@public
---@param p string The profile to apply
---@return string|nil e Returns nil if no errors were reported
function Config:apply(p)
  if is.present(p) then
    self:load_profile(p)
  end

  local stages = self.options.stages or defaults.stages

  for _,stage in ipairs(stages) do
    Logger:debug("Processing %s stage", stage)
    if stage == 'managers' then
      for name, opts in pairs(self.options.managers) do
        self:load_manager(name, self.options)
      end
    else
      self:load_stage(stage, self.options)
    end
  end
end
-- !SECTION
-- ============================================================================


-- ============================================================================
-- SECTION Supporting functions


-- SECTION load profile -------------------------------------------------------
---@private
---@param p string The name of the profile to load
---@return string|nil err nil if successful, the error message if not
function Config:load_profile(p)
  local name = p or defaults.profile.name
  local pdir = path.join(defaults.profile.root , name)

  if path.exists(pdir) then
    local mpath = path.convert_to_module(pdir)
    if is.present(mpath) then
      Logger:debug("Loading profile '%s'", mpath)
      local mod, err = load.try(mpath)
      if is.present(err) then
        return err
      else
        Logger:debug("Success")
        mod['module'] = mpath
        mod['root'] = pdir
        self.options = mod
        _G.profile = { name = name, path = pdir, last = os.date() }
        return nil
      end -- if there was an error
    end -- the path exists
  end -- p table or string
end
-- !SECTION

-- SECTION Load manager
---@private
---@param name string The name of the manager
---@param opt ConfigurationOptions The options needed to run the manager
---@return table|nil errors nil if successful, errors otherwise
function Config:load_manager(name, opt)
  Logger:debug("Loading manager '%s'", name)
  local mgr, err = load.try('manager.' .. name)
  local e = {} -- We will collect errors here

  if is.empty(err) then
    Logger:debug("- Success")
    mgr = mgr:new()
    mgr:configure(opt)
    mgr:load()
    self.managers[name] = mgr
  else
    Logger:error("Did not load %s manager: %s", name, err)
    table.insert(e, err)
  end

  if is.present(e) then
    return e
  else
    return nil
  end
end
-- !SECTION

-- SECTION Load stage
---@private
--- require each file in <stage> directory if it exists
---@param stage string The name of the stage to load
---@param opts? table Options that should be passed to the stage module
---@return string|nil e Returns nil if no errors were reported
function Config:load_stage(stage, opts)
  Logger:debug("Loading stage '%s',", stage)
  local profile_dir = self.options.root
  local stage_dir = path.join(profile_dir, stage)
  if path.exists(stage_dir) then
    Logger:debug("Loading all files in '%s'", stage_dir)
    load.all(stage_dir,opts)
  end
end
-- !SECTION

-- !SECTION
-- ============================================================================

return Config

