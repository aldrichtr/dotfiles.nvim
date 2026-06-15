
local Config = require('config')
local class = require('extern.middleclass')
local fs = require('util.fs')
local is = require('util.is')
local load = require('util.load')

local Keybindings = class('Keybindings', Config)

function Keybindings:initialize()
  Config.initialize(self)
  self.bindings = {}
end

function Keybindings:apply() self:load_bindings() end

function Keybindings:load_bindings()
  Logger:debug('Loading Keybindings')
  local files = fs.find()
  local k, wk, err

  for _, file in ipairs(files) do
    local p = fs.convert_to_module(file)
    local name = fs.basename(fs.filename(file))
    Logger:debug('Loading keybindings module %s', p)
    k, err = load:try(p)
    if not k then
      Logger:error('There was an error with a keybindings module: %s', err)
    else
      Logger:info('Configuring keybinds %s', name)
      if is.present(k.whichkey) then
        wk, err = load:try('which-key')
        if is.empty(wk) then
          Logger:error('Could not load `which-key` plugin %s', err)
        else
          wk.add(k.whichkey)
        end
      elseif type(k.setup) == 'function' then
        k.setup()
      end
    end
  end
end

return Keybindings
