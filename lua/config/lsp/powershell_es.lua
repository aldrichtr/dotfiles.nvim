
local path = require('config.path')
local fs   = require('util.fs')

-- I found these bits looking through the powershell.nvim repo
-- [powershell.nvim](https://github.com/TheLeoP/powershell.nvim/blob/main/lua/powershell/lsp.lua)
-- local ok = pcall(require, "dap")
-- if ok then require('powershell.dap').setup() end

-- cmd = vim.lsp.rpc.connect(session_details.languageServicePipeName),
-- capabilities = config.capabilities,
-- on_attach = config.on_attach,
-- settings = config.settings,
-- init_options = config.init_options,
-- handlers = config.handlers,
-- commands = config.commands,
-- root_dir = config.root_dir(buf),

local shell = "pwsh.exe"

local server = { name = 'powershell_es' }
local root = fs.join(path.lsp, server.name)
local logs = fs.join(path.Home,'.cache', server.name)

local start = {
  shell, "-NoProfile", "-NoLogo", "-NoProfileLoadTime", "-NonInteractive",
  "-CommandWithArgs",
  "'" .. fs.join(root, "PowerShellEditorServices", "Start-EditorServices.ps1") .. "'",
  "-BundledModulesPath", "'" .. root .. "'",
  "-LogPath", "'" .. logs .. "'",
  "-SessionDetailsPath", "'" .. logs .. "'",
  "-LogLevel", '"Diagnostic"',
  "-FeatureFlags", "@()",
  "-AdditionalModules", "@()",
  "-HostName", '"Neovim"',
  "-HostProfileId", 0,
  "-HostVersion", '"0.12"',
  "-EnableConsoleRepl"
}

---@type vim.lsp.Config
server.config = {
  shell = "pwsh",
  cmd = function(dispatchers) vim.lsp.rpc.connect(start, dispatchers) end,
  filetypes = { "ps1" },
  root_markers = { '.build.ps1', 'PSScriptAnalyzerSettings.psd1', '.git' }
}

return server
