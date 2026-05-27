
local path = require('util.path')
local is   = require('util.is')

-- I found these bits looking through the powershell.nvim repo
-- [powershell.nvim](https://github.com/TheLeoP/powershell.nvim/blob/main/lua/powershell/lsp.lua)
-- local ok = pcall(require, "dap")
-- if ok then require("powershell.dap").setup() end

-- cmd = vim.lsp.rpc.connect(session_details.languageServicePipeName),
-- capabilities = config.capabilities,
-- on_attach = config.on_attach,
-- settings = config.settings,
-- init_options = config.init_options,
-- handlers = config.handlers,
-- commands = config.commands,
-- root_dir = config.root_dir(buf),



local M = { name = 'powershell_es' }

function M.config(user_config)

  local shell = 'pwsh'
  local root = path.join(path.lsp, M.name)

  local lsp_config = {
    shell = shell,
    cmd = {
      shell, '-NoProfile', '-NoLogo', '-NoProfileLoadTime',
      '-CommandWithArgs', '"',
      "'" .. path.join(root, 'PowerShellEditorServices', 'Start-EditorServices.ps1') .. "'",
      '-BundledModulesPath', "'" .. root .. "'",
      '-LogPath', "'" .. path.join(path.Home, '.cache', M.name) .. "'",
      '-SessionDetailsPath', "'" .. path.join(path.Home, '.cache', M.name) .. "'",
      '-LogLevel', '"Diagnostic"',
      '-FeatureFlags', '@()',
      '-AdditionalModules', '@()',
      '-HostName', '"Neovim"',
      '-HostProfileId', 0,
      '-HostVersion', '"0.12"',
      '-EnableConsoleRepl',
      '-Stdio',
    },
    filetypes = { 'ps1' },
    settings = {
      powershell = {
        codeFormatting = 'OTBS'
      }
    },
    init_options = {
      enableProfileLoading = false
    }
  }

	if is.present(user_config) then
		vim.tbl_deep_extend('force', lsp_config, user_config)
	end

  return lsp_config
end


return M
