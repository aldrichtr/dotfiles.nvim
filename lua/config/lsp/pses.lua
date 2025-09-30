local M = {}

function M.setup(config)
  local lspconfig = require('lspconfig')
  local shell = 'pwsh'
  if not vim.fn.executable('pwsh') then shell = 'powershell' end
  local bundle_path = vim.fs.normalize(vim.env.LOCALAPPDATA .. '/lsp' .. '/pses')

  local log_path = vim.fn.stdpath('log')

  local cmd = {
    shell,
    '-NoProfile', '-NonInteractive', '-Command',
    '"',
    "'" .. vim.fs.joinpath(bundle_path, '/PowerShellEditorServices/Start-EditorServices.ps1') .. "'",
    '-HostName', "'nvim'",
    '-HostProfileId', "'Neovim'",
    '-HostVersion', '0.0.0',
    '-LogPath', "'" .. vim.fs.joinpath(log_path, 'pses') .. "'",
    '-LogLevel', "'Normal'",
    '-BundledModulesPath', bundle_path,
    '-EnableConsoleRepl',
    '-SessionDetailsPath',
    "'" .. vim.fs.joinpath(log_path, 'pses.jsonc') .."'",
    '-AdditionalModules', '@()',
    '-FeatureFlags', '@()',
    '"',
  }

  vim.notify('Starting PSES with cmd:')
  vim.notify(table.concat(cmd, ' '))
  lspconfig.powershell_es.setup({
    cmd = cmd,
    filetypes = { 'ps1', 'psm1', 'psd1' },
    settings = {
      powershell = {
        codeFormatting = 'OTBS',
      },
    },
  })
end

return M