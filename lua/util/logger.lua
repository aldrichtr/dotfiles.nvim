-- log.lua
--
local path = require('config.path')
local fs      = require('util.fs')
local is = require('util.is')
local class = require('extern.middleclass')
local copy_t = vim.tbl_deep_extend

Logger = class("Logger")


-- local LogLevel = { "NONE", "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }
local LogLevel = { "TRACE" , "DEBUG", "INFO", "WARN", "ERROR", "NONE" }
-- support reverse lookups
for i, v in ipairs(LogLevel) do
  LogLevel[v] = i - 1
end

local defaults = {
  file = {
    enabled = false,
    path = vim.fn.stdpath("data"),
    name = "nvim.init-test.log",
  },
  console = {
    enabled = true,
  },
  level = "WARN",
  format or "[!d<%y.%m.%d>]!LL: (!p:!n) !m"
}


  -- TODO: Add the ability to set logging per module like
  -- lua/config/init.lua = 'DEBUG'

function Logger:initialize(config)
  self.level   = defaults.level
  self.format  = defaults.format
  self.console = defaults.console
  self.file    = defaults.file

  if is.present(config.level) then
    self.level = config.level
  end

  if is.present(config.format) then
    self.format  = config.format
  end

  if is.present(config.console) then
    copy_t("force", self.console, config.console)
  end

  if is.present(config.file) then
    copy_t("force", self.file, config.file)
  end
end

--- @private
function Logger:format_message(opts,message)
  local completed = self.format
  local level_name = opts.level

  -- ------------------------------------------------------
  -- | for the date, we need a round trip:                |
  -- | - find the date "cookie" in the format string      |
  -- | - Pull the format of the date out of the cookie    |
  -- | - replace the date cookie with the formatted date  |
  local date_pattern = "!d%<(.*)%>"
  local date_format = string.match(completed, date_pattern)
  local msg_date = os.date(date_format)
  -- ------------------------------------------------------

  local patterns = {
    { pattern = "!LL"       , field = string.upper(level_name) },
    { pattern = "!ll"       , field = string.lower(level_name) },
    { pattern = "!L"        , field = string.upper(string.sub(level_name, 0, 1)) },
    { pattern = "!l"        , field = string.lower(string.sub(level_name, 0, 1)) },
    { pattern = "!I"        , field = vim.uv.os_getpid() },
    { pattern = "!n"        , field = opts.line or 0 },
    { pattern = "!P"        , field = opts.path or '_' },
    { pattern = "!p"        , field = opts.short_path or '_' },
    { pattern = date_pattern, field = msg_date },
    { pattern = "!m"        , field = message }
  }

  for _, replace in ipairs(patterns) do
    completed, _ = string.gsub(completed, replace.pattern, replace.field)
  end
  return completed
end


---@private
function Logger:write_console(level, msg)
  vim.notify(msg, LogLevel[level])
end

---@private
function Logger:write_file(level,msg)
  local f = fs.join(self.file.path, self.file.name)
  local fp = io.open(f, "a")
  fp:write(msg)
  fp:close()
end

---@private
function Logger:write(opts)
  if LogLevel[opts.level] >= LogLevel[self.level] then
    local caller = opts.caller
    local info = {
      level = opts.level,
      path = caller.short_src,
      short_path = caller.short_src:gsub('\\', '/'):gsub(".*/nvim/", ""),
      line = caller.currentline
    }

    local msg = self:format_message(info, opts.message)

    if self.file.enabled then self:write_file(opts.level, msg) end
    if self.console.enabled then self:write_console(opts.level, msg) end
  end
end

---@public
function Logger:trace(...)
  self:write({
    caller = debug.getinfo(2, "Sl"),
    level  = "TRACE",
    message = string.format(...)
  })
end
---@public
function Logger:debug(...)
  self:write({
    caller = debug.getinfo(2, "Sl"),
    level  = "DEBUG",
    message = string.format(...)
  })
end
---@public
function Logger:info(...)
  self:write({
    caller = debug.getinfo(2, "Sl"),
    level  = "INFO",
    message = string.format(...)
  })
end
---@public
function Logger:warn(...)
  self:write({
    caller = debug.getinfo(2, "Sl"),
    level  = "WARN",
    message = string.format(...)
  })
end
---@public
function Logger:error(...)
  self:write({
    caller = debug.getinfo(2, "Sl"),
    level  = "ERROR",
    message = string.format(...)
  })
end

return Logger
