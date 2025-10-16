local path = require('util.path')


LspPowerShell = class('LspPowerShell')

function LspPowerShell:initialize()
  self.name = 'powershell_es'
end

function LspPowerShell:configure()
  -- Unfortunately, the PSES script has a bunch of options on the command line
  -- so we need to build it up in layers to get the formatting right

  -- This is the shell executable and its options
  local shell = {
    cmd = path.join(path.Programs, 'WindowsApps','Microsoft.PowerShell_7.5.3.0_x64__8wekyb3d8bbwe','pwsh.exe'),
    -- cmd = "C:/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe",
    options = '-NoProfile -NoLogo -Command'
  }

  -- Logging options for the LSP
  local logging = {
    level = 'Normal',
    path = vim.fs.joinpath(path.lsp.logs, 'pses'),
    session = vim.fs.joinpath(path.lsp.logs, 'pses', 'pses.jsonc'),
  }

  -- The PSES module and options for other modules and features
  local bundle = {
    path = path.join(path.lsp.pses),
    server = 'Start-EditorServices.ps1',
    modules = '@()',
    features = '@()'
  }

  -- Neovim is the host program for the LSP
  local host = {
    name = "nvim",
    profileId = "Neovim",
    version = function()
      local v = vim.version()
      local fmt = "%d.%d.%d"
      return string.format(fmt, v.major, v.minor, v.patch)
    end
  }


  -- ----------------------------------------------------------
  -- Now we start building up the command string

  local cmd_info = string.format(
    [[%s %s]],
    shell.cmd, shell.options
  )

  local host_info = string.format(
    [[-HostName '%s' -HostProfileId '%s' -HostVersion '%s']],
    host.name, host.profileId, host.version()
  )
  local log_info = string.format(
    [[-LogPath '%s' -LogLevel '%s' -SessionDetailsPath '%s']],
    logging.path, logging.level, logging.session
  )
  local bundle_info = string.format(
    -- [[%s -BundledModulesPath '%s' -AdditionalModules '%s' -FeatureFlags '%s' -EnableConsoleRepl -Stdio]],
    [[%s -BundledModulesPath '%s' -AdditionalModules '%s' -FeatureFlags '%s' -Stdio]],
    -- [[%s -BundledModulesPath '%s' -AdditionalModules '%s' -FeatureFlags '%s']],
    path.join(bundle.path,'PowerShellEditorServices', bundle.server), bundle.path, bundle.modules, bundle.features

  )

  -- -----------------------------------------------------------
  -- now we put the whole string together

  local server_start = table.concat(
    { cmd_info, bundle_info, host_info, log_info }, ' '
  )
  -- this is the table that gets fed to `vim.lsp.config['powershell_es']`
  -- note that we are returning a table from the initialize() function,
  -- which means that require('config.lsp.pses') will get that table
  local config = {
    shell = 'pwsh',
    cmd = { server_start },
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

  local test_config = {
    bundle_path = bundle.path,
    shell = "pwsh",
    settings = {
      powershell = {
        codeFormatting = 'OTBS'
      }
    },
    init_options = {
      enableProfileLoading = false
    }
  }
  vim.lsp.config(self.name, test_config)
end

function LspPowerShell:enable()
  vim.lsp.enable(self.name)
end

return LspPowerShell
