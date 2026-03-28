-- log.lua
--
local path = require('util.path')
local switch = require('util.switch')

Logger = class('Logger')


-- Log levels
local LogLevel = { "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }
-- support reverse lookups
for i, v in ipairs(LogLevel) do LogLevel[v] = i - 1 end


function Logger:initialize(config)

  self.file = {
    enabled = false
    path    = vim.fn.stdpath("data")
  }

    self.file = config.file or false
    self.path = config.path or path.join(path.data, "nvim.init.log")
    self.level = Logger.levels[level] or Logger.levels.DEBUG
    return self
end

-- Internal function to format log messages
local function format_message(level, message)
    local time_str = os.date("%Y-%m-%d %H:%M:%S")
    return string.format("[%s] [%s] %s", time_str, level, message)
end

function Logger:write_console(...)

end

function Logger:write_file(...)

end

function Logger:write(lvl, ...)
  if LogLevel[lvl] <= LogLevel[self.level] then
    local msg = ...
    if self.file then
      self.write_file(msg)
    end
    if self.console then
      self.write_console(msg)
    end
  end
end




-- Internal function to write logs
function Logger:_write(level, message)
    if Logger.levels[level] < self.level then
        return
    end

    local formatted = format_message(level, message)

    -- Output to console
    print(formatted)

    -- Output to file if specified
    if self.logfile then
        local file, err = io.open(self.logfile, "a")
        if not file then
            print("[LOGGER ERROR] Could not open log file: " .. tostring(err))
            return
        end
        file:write(formatted .. "\n")
        file:close()
    end
end

-- Public logging methods
function Logger:debug(msg) self:_write("DEBUG", msg) end
function Logger:info(msg)  self:_write("INFO",  msg) end
function Logger:warn(msg)  self:_write("WARN",  msg) end
function Logger:error(msg) self:_write("ERROR", msg) end

return Logger


Example Usage
Lualocal Logger = require("logger")

-- Create a logger that logs INFO and above to "app.log"
local log = Logger.new("app.log", "INFO")

log:debug("This is a debug message (won't show because level is INFO)")
log:info("Application started")
log:warn("Low disk space")
log:error("Failed to connect to database")


Features

Log Levels: DEBUG, INFO, WARN, ERROR
Timestamped Output
Console + Optional File Logging
Configurable Minimum Log Level


If you prefer a ready-made, feature-rich solution, you can install LuaLogging via LuaRocks:
Bashluarocks install lualogging


Do you want me to extend this logger to support colored console output for better readability? That would make it easier to distinguish log levels.
local default_config = {
  -- Name of the plugin. Prepended to log messages
  plugin = 'nvim.init',

  -- Should print the output to neovim while running
  use_console = false,

  -- Should highlighting be used in console (using echohl)
  highlights = true,

  -- Should write to a file
  use_file = true,

	-- TODO: develop a method to get this from the command

  -- Any messages above this level will be logged.
  level = "trace",

  -- Level configuration
  modes = {
    { name = "trace", hl = "Comment", },
    { name = "debug", hl = "Comment", },
    { name = "info",  hl = "None", },
    { name = "warn",  hl = "WarningMsg", },
    { name = "error", hl = "ErrorMsg", },
    { name = "fatal", hl = "ErrorMsg", },
  },

  -- Can limit the number of decimals displayed for floats
  float_precision = 0.01,
}

-- {{{ NO NEED TO CHANGE
local log = {}

local unpack = unpack or table.unpack

log.new = function(config, standalone)
  config = vim.tbl_deep_extend("force", default_config, config)

  -- local outfile = string.format('%s/%s.log', vim.api.nvim_call_function('stdpath', {'data'}), config.plugin)

  local outfile = string.format('%s/%s.log', path.data, config.plugin)
  local obj
  if standalone then
    obj = log
  else
    obj = {}
  end

  local levels = {}
  for i, v in ipairs(config.modes) do
    levels[v.name] = i
  end

  local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
  end

  local make_string = function(...)
    local t = {}
    for i = 1, select('#', ...) do
      local x = select(i, ...)

      if type(x) == "number" and config.float_precision then
        x = tostring(round(x, config.float_precision))
      elseif type(x) == "table" then
        x = vim.inspect(x)
      else
        x = tostring(x)
      end

      t[#t + 1] = x
    end
    return table.concat(t, " ")
  end


  local log_at_level = function(level, level_config, message_maker, ...)
    -- Return early if we're below the config.level
    if level < levels[config.level] then
      return
    end
    local nameupper = level_config.name:upper()

    local msg = message_maker(...)
    local info = debug.getinfo(2, "Sl")
    -- I added this to shorten the path to the file to be relative to
    -- the nvim config directory
    -- first I normalize the directory separator to `/`, and then
    -- remove everything up to the `/nvim/`
    local src = info.short_src:gsub('\\', '/'):gsub(".*/nvim/", "")
    local lineinfo = src .. ":" .. info.currentline

    -- Output to console
    if config.use_console then
      local console_string = string.format(
      "[%-6s%s] %s: %s",
      nameupper,
      os.date("%H:%M:%S"),
      lineinfo,
      msg
      )

      if config.highlights and level_config.hl then
        vim.cmd(string.format("echohl %s", level_config.hl))
      end

      local split_console = vim.split(console_string, "\n")
      for _, v in ipairs(split_console) do
        vim.cmd(string.format([[echom "[%s] %s"]], config.plugin, vim.fn.escape(v, '"')))
      end

      if config.highlights and level_config.hl then
        vim.cmd("echohl NONE")
      end
    end

    -- Output to log file
    if config.use_file then
      local fp = io.open(outfile, "a")
      local str = string.format("[%-6s%s] %s: %s\n",
      nameupper, os.date(), lineinfo, msg)
      fp:write(str)
      fp:close()
    end
  end

  for i, x in ipairs(config.modes) do
    obj[x.name] = function(...)
      return log_at_level(i, x, make_string, ...)
    end

    obj[("fmt_%s" ):format(x.name)] = function()
      return log_at_level(i, x, function(...)
        local passed = {...}
        local fmt = table.remove(passed, 1)
        local inspected = {}
        for _, v in ipairs(passed) do
          table.insert(inspected, vim.inspect(v))
        end
        return string.format(fmt, unpack(inspected))
      end)
    end
  end
end

log.new(default_config, true)
-- }}}

return log
