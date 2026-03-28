-- log.lua
--
local path = require("util.path")
local switch = require("util.switch")
local is = require("util.is")

local copy_t = vim.tbl_deep_extend

---@class Logger
Logger = class("Logger")

---@enum LogLevel
local LogLevel = { "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }
-- support reverse lookups
for i, v in ipairs(LogLevel) do
  LogLevel[v] = i - 1
end

-- #region Configuration definition

---@class LoggerFileConfig
---@field public enabled boolean Should the logger write to a file?
---@field public path string The directory to write log files in
---@field public name string The name of the file to write log messages in
---
---@class LoggerConsoleConfig
---@field public enabled boolean Should the logger write to the neovim message queue?

---@class LoggerConfig
---@field public file LoggerFileConfig Control logging to the filesystem
---@field public console LoggerConsoleConfig Control logging to the neovim message queue
---@field public level LogLevel Messages at this level and higher will be logged
---@field public format string How to format messages
--- Format Cookies:
---  !LL = Level full name in Caps : INFO
---  !ll = Level full name in lowercase : info
---  !L  = Level first letter caps : I
---  !l  = Level first letter lowercase : i
---  !d<format>  = Date : the format in < > will be passed to os.date
---  !m  = The message

function Logger:initialize(config)
  self.file = {
    enabled = false,
    path = vim.fn.stdpath("data"),
    name = "nvim.init-test.log",
  }
  self.console = {
    enabled = true,
  }
  self.level = "TRACE"
  self.format = "[!LL](!d<%y%M%d>) !m !p"

  if is.present(config.file) then
    copy_t("force", self.file, config.file)
  end
  if is.present(config.console) then
    copy_t("force", self.console, config.console)
  end

  -- setmetatable(self, { __index = function(cls,lvl, ...) return cls:write(string.upper(lvl), ...) end })
end

-- Internal function to format log messages
function Logger:format_message(message)
  local completed = self.format
  local date_pattern = "!d%<(.*)%>"
  local lv_full_up = "!LL"
  local lv_full_lw = "!ll"
  local lv_shrt_up = "!L"
  local lv_shrt_lw = "!l"
  local mess_pattern = "!m"
  completed, _ = string.gsub(completed, lv_full_up, string.upper(self.level))
  completed, _ = string.gsub(completed, lv_full_lw, string.lower(self.level))
  completed, _ = string.gsub(completed, lv_shrt_up, string.upper(string.sub(self.level, 0, 1)))
  completed, _ = string.gsub(completed, lv_shrt_lw, string.lower(string.sub(self.level, 0, 1)))
  date_frmt = string.match(completed, date_pattern)
  date_strg = os.date(date_frmt)
  completed, _ = string.gsub(completed, date_pattern, date_strg)
  completed, _ = string.gsub(completed, mess_pattern, message)
  return completed
end

function Logger:parse_caller_info(c)

end

function Logger:write_console(lvl, msg)
  vim.notify(msg, LogLevel[lvl])
end

function Logger:write_file(lvl, msg)
  local f = path.join(self.file.path, self.file.name)
  local fp = io.open(f, "a")
  fp:write(msg)
  fp:close()
end

function Logger:write(lvl, ...)
  if LogLevel[lvl] <= LogLevel[self.level] then
    local caller = debug.getinfo(2,"Sl")

    local msg = self:format_message(string.format(...))
    if self.file.enabled then self:write_file(lvl, msg) end
    if self.console.enabled then self:write_console(lvl, msg) end
  end
end

function Logger:trace(...)
  self:write("TRACE", ...)
end
function Logger:debug(...)
  self:write("DEBUG", ...)
end
function Logger:info(...)
  self:write("INFO", ...)
end
function Logger:warn(...)
  self:write("WARN", ...)
end
function Logger:error(...)
  self:write("ERROR", ...)
end

return Logger
