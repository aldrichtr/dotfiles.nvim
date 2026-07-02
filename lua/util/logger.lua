-- --------------------------------------------------------------------------------------------------------
-- A simple logging facility for use in neovim lua init files.
-- Features:
-- - Log to file and/or the vim message stream
-- - Provides five log-levels
--   - `ERROR` : Only serious errors
--   - `WARN`  : Recoverable errors
--   - `INFO`  : Informational messages
--   - `DEBUG` : Diagnostic output
--   - `TRACE` : All log messages
-- --------------------------------------------------------------------------------------------------------

-- SECTION Meta information
---@class MessageData
---@field level string|LogLevel The level the message was marked as
---@field path string The fully-qualified path of the caller
---@field short_path string The path of the caller, relative to stdpath('config')
---@field line number The line number of the caller

---@class FileLogger
---@field enabled boolean Whether the logger writes to the file
---@field dir string The directory where log files are written
---@field name string The name of the file where log files are written
---@field ext string The extension of the file where log files are written
---@field keep number The number of logs to keep

---@class ConsoleLogger
---@field enabled boolean Whether the logger writes to the neovim message stream
---@field use_snacks? boolean Whether to use the snacks.notify interface (experimental)

---@alias format string
---| '"!d<date_pattern>"' # Will be replaced by the date/time where date_pattern is passed to os.date()
---| '"!LL"' # The message level name in uppercase
---| '"!L"' # The message level letter in uppercase
---| '"!ll"' # The message level name in lowercase
---| '"!l"' # The message level letter in lowercase
---| '"!I"' # The pid of the process generating the message
---| '"!P"' # The fully-qualified path of the caller
---| '"!p"' # The path of the caller relative to stdpath('config')
---| '"!n"' # The line number of the caller
---| '"!m"' # The message from the caller

---@class Logger
---@field level string The `LogLevel` at which messages will be output
---@field format format The log message format
---@field file FileLogger
---@field console ConsoleLogger

---@class WriterOptions
---@field level string The `LogLevel` at which messages will be output
---@field caller table The information from the caller
---@field message string the message that will be sent to the formatter

---@alias LoggerConfig Logger
-- !SECTION

-- SECTION Initialization
local class = require('extern.middleclass')
local fs = require('util.fs')
local is = require('util.is')
local copy_t = vim.tbl_deep_extend

---@enum LogLevel
local LogLevel = { 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR', 'NONE' }
-- support reverse lookups
for i, v in ipairs(LogLevel) do
  LogLevel[v] = i - 1
end

-- TODO: Might be better to make this a singleton instead of a global?
--       https://github.com/ichesnokov/middleclass-mixin-singleton

---@type Logger
local Logger = class('Logger')

-- TODO: Add the ability to set logging per module like
-- lua/config/init.lua = 'DEBUG'

---@param config LoggerConfig
---@return Logger
function Logger:initialize(config)
  self.name = 'Logger'
  self.level = 'WARN'
  self.format = '[!d<%y.%m.%d>]!LL: (!p:!n) !m'

  self.file = {
    keep = 5,
    filetype = 'log',
    enabled = false,
    dir = fs.join(vim.fn.stdpath('data'), 'logs', 'init'),
    name = 'nvim.init-test',
    ext = '.log',
  }
  self.console = {
    enabled = true,
    use_snacks = false,
  }

  self.state = 'INIT'

  if is.present(config) then self:set(config) end
  if self.file.enabled then self:rotate_file() end
end

-- !SECTION

-- SECTION Configuration

---@public
---@param config LoggerConfig
---@return nil
function Logger:set(config)
  if is.present(config.level) then self.level = config.level end
  if is.present(config.format) then self.format = config.format end

  if is.present(config.console) then self.console = copy_t('force', self.console, config.console) end
  -- file is treated special because we have some items we don't want
  -- overwritten
  if is.present(config.file) then
    if is.present(config.file.enabled) then self.file.enabled = config.file.enabled end
    if is.present(config.file.filetype) then self.file.filetype = config.file.filetype end
    if is.present(config.file.keep) then self.file.keep = config.file.keep end
    if is.present(config.file.dir) then self.file.dir = config.file.dir end
    if is.present(config.file.name) then self.file.name = config.file.name end
    if is.present(config.file.ext) then self.file.ext = config.file.ext end
  end
  if self.file.enabled then self:rotate_file() end
end

---@public
---@return LoggerConfig
function Logger:get()
  return {
    name = self.name,
    level = self.level,
    format = self.format,
    file = self.file,
    console = self.console,
  }
end

function Logger:read_json(path)
  if fs.exists(path) then
    local f = io.open(path, 'r')
    local json = f:read('*a')
    f:close()
    if is.filled(json) then
      local json_options = vim.json.decode(json)
      self:set(json_options)
    else
      self:error('%s did not contain any data', path)
    end
  else
    self:error('%s is not a valid path for logger settings file', path)
  end
end
-- !SECTION Configuration

-- SECTION Writers

---@private
--- Writes the message to the neovim message facility
---@param level string The `LogLevel` of the message
---@param msg string The formatted message
---@return nil
function Logger:write_console(level, msg)
  vim.notify(msg, LogLevel[level])
end

-- SECTION File logging utilities

---@private
--- Writes the message to the file.  The path is determined by joining `file.path`
--- and `file.name`
---@param msg string The formatted message
---@return nil
function Logger:write_file(_, msg)
  if not fs.exists(self.file.dir) then vim.uv.fs_mkdir(self.file.dir, tonumber('755', 8)) end

  local f = self:format_path()
  local fp = io.open(f, 'a')
  assert(fp ~= nil, 'Error! failed to open file: ' .. f)
  fp:write(msg)
  fp:close()
end

---@private
--- Create a path from the components in the `file` table
---@return string A fully-qualified path to the current log file
function Logger:format_path()
  local ext = self.file.ext
  if ext:sub(1, 1) ~= '.' then
    -- here, lemme fix that for you
    ext = '.' .. ext
    self.file.ext = ext
  end
  local fname = self.file.name .. self.file.ext
  return fs.join(self.file.dir, fname)
end

---@public
--- Open the log file in a new buffer
function Logger:open_file()
  vim.cmd({ cmd = 'edit', args = { self:format_path() } })
end

---@private
--- Initialize the log file
---@return nil
function Logger:start_file()
  local f = self:format_path()
  local fp = io.open(f, 'w')
  fp:write(string.format('# vim: ft=%s\n\n', self.file.filetype))
  fp:close()
end

---@private
--- Move existing logfiles by renaming them using numbers in the filename.
--- `init.log` => `init.1.log` => `init.2.log`, etc.
---@return nil
function Logger:rotate_file()
  -- we only need to rotate if the set logfile exists
  local current = self:format_path()
  if fs.exists(current) then
    local base = fs.basename(self.file.name)
    local dir = self.file.dir
    local ext = self.file.ext
    local i = self.file.keep - 1
    local rename = vim.uv.fs_rename
    local function format_name(n)
      return string.format('%s.%d%s', base, n, ext)
    end
    -- 1. delete the oldest file first if it exists
    -- 3. move current to .1
    local last = fs.join(dir, format_name(i))
    if fs.exists(last) then vim.fs.rm(last, { force = true }) end
    i = i - 1
    local this, next
    -- 2. starting at the max amount - 1, move to the next index
    --    move it one back
    while i > 1 do
      this = fs.join(dir, format_name(i))
      next = fs.join(dir, format_name(i + 1))
      if fs.exists(this) then rename(this, next) end
      i = i - 1
    end
    -- 3. rename current to .1
    rename(current, fs.join(dir, format_name(1)))
  end
  self:start_file()
end

-- !SECTION

-- SECTION Message handling

---@private
---Perform replacement of the tokens in the format string with the appropriate values
---@param opts MessageData Log and caller data used for replacement
---@param message string The message submitted by the caller
---@return string A message with the tokens replaced suitable for writing
function Logger:format_message(opts, message)
  local completed = self.format
  local level_name = opts.level

  -- ------------------------------------------------------------
  -- | for the date, we need a round trip:                    --|
  -- | - find the date "cookie" in the format string          --|
  -- | - Pull the format of the date out of the cookie        --|
  -- | - replace the date cookie with the formatted date      --|
  local date_pattern = '!d%<(.*)%>' --|
  local date_format = string.match(completed, date_pattern) --|
  local msg_date = os.date(date_format) --|
  -- ------------------------------------------------------------

  local patterns = {
    { pattern = '!LL', field = string.upper(level_name) },
    { pattern = '!ll', field = string.lower(level_name) },
    { pattern = '!L', field = string.upper(string.sub(level_name, 0, 1)) },
    { pattern = '!l', field = string.lower(string.sub(level_name, 0, 1)) },
    { pattern = '!I', field = vim.uv.os_getpid() },
    { pattern = '!n', field = opts.line or 0 },
    { pattern = '!P', field = opts.path or '_' },
    { pattern = '!p', field = opts.short_path or '_' },
    { pattern = date_pattern, field = msg_date },
    { pattern = '!m', field = message },
  }

  for _, replace in ipairs(patterns) do
    completed, _ = completed:gsub(replace.pattern, replace.field)
  end
  if completed:sub(-1) ~= '\n' then completed = completed .. '\n' end
  return completed
end

-- !SECTION

---@private
--- The abstract writer function.  gathers and formats information before
--- passing to the given concrete writer.  This is where the caller's level and
--- the Logger's level are evaluated.
---@param opts WriterOptions
---@return nil
function Logger:write(opts)
  if LogLevel[opts.level] >= LogLevel[self.level] then
    local caller = opts.caller
    local src = caller.short_src
    local norm, _ = src:gsub('\\', '/') -- normalize the directory separator
    local std = vim.fn.stdpath('config')
    local config = vim.fs.basename(vim.fs.dirname(std))
    local pattern = '.+' .. config .. '/'
    local short, _ = norm:gsub(pattern, '') -- remove everything upto stdpath config
    ---@type MessageData
    local info = {
      level = opts.level,
      path = caller.short_src,
      short_path = short,
      line = caller.currentline,
    }

    local msg = self:format_message(info, opts.message)

    if self.file.enabled then self:write_file(opts.level, msg) end
    if self.console.enabled then self:write_console(opts.level, msg) end
  end
end

-- !SECTION

-- SECTION Public interface

---@public
---@param ... any Either a string, or a string.format table
---@return nil
function Logger:trace(...)
  self:write({
    caller = debug.getinfo(2, 'Sl'),
    level = 'TRACE',
    message = string.format(...),
  })
end
---@public
---@param ... any Either a string, or a string.format table
---@return nil
function Logger:debug(...)
  self:write({
    caller = debug.getinfo(2, 'Sl'),
    level = 'DEBUG',
    message = string.format(...),
  })
end
---@public
---@param ... any Either a string, or a string.format table
---@return nil
function Logger:info(...)
  self:write({
    caller = debug.getinfo(2, 'Sl'),
    level = 'INFO',
    message = string.format(...),
  })
end
---@public
---@param ... any Either a string, or a string.format table
---@return nil
function Logger:warn(...)
  self:write({
    caller = debug.getinfo(2, 'Sl'),
    level = 'WARN',
    message = string.format(...),
  })
end
---@public
---@param ... any Either a string, or a string.format table
---@return nil
function Logger:error(...)
  self:write({
    caller = debug.getinfo(2, 'Sl'),
    level = 'ERROR',
    message = string.format(...),
  })
end

-- !SECTION

return Logger
