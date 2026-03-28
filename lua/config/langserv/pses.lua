
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

local path = require('util.path')


local M = { name = 'powershell_es' }

function M.config(user_config)

  local log_path = path.join(path.lsp.logs, M.name)
  local bundle_path = path.lsp.pses

  local shell = 'pwsh'
  local command_fmt =
  [[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 0.11.4 -Stdio -LogLevel Normal]]

  local command = command_fmt:format(bundle_path, bundle_path, log_path, log_path)
  local cmd = { shell, '-NoLogo', '-NoProfile', '-Command', command }

  return {
  -- name = "powershell_es",
    shell = 'pwsh',
    cmd = cmd,
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

end


return M

