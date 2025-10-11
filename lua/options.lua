
local path = require('util.path')

-- Options is just a table full of values that affect all of the config/*
-- functions, so I dont need it to be a class. I could also create an options/*
-- folder, and then do something like load.all() if I need to break these up...

local ConfigOptions = {}

ConfigOptions.shell = {
  pwsh = path.join(path.Programs, 'WindowsApps', 'Microsoft.PowerShell_7.5.3.0_x64__8wekyb3d8bbwe','pwsh.exe'),
  python = path.join(path.Programs, 'Python312', 'python.exe')
}

ConfigOptions.manager = {
  use = 'lazy',
  -- where packages will be installed to
  root = path.join(path.data, 'lazy'),
  -- these options affect the installation of lazy.nvim and are only used on
  -- new installs of lazy.nvim
  install = {
    repo = 'https://github.com/folke/lazy.nvim.git',
    -- install lazy.nvim along side other package
    path = path.join(path.data, 'lazy', 'lazy.nvim'),
    check = path.join(path.data, 'lazy', 'lazy.nvim', '.git')
  },
  packages = {'before', 'themes', 'setup', 'after'},
  -- these options will be passed to the lazy.setup() function
  setup = {
    -- see https://lazy.folke.io/configuration for all options
    spec = {},
    lockfile = path.join(path.data, '/lazy-lock.json')
  }
}


ConfigOptions.snippets = {
  root = { path.join(path.lua, 'snippets') }
}

ConfigOptions.ui = {
  colors = {
    colorscheme = 'darcula-dark'
  },
  fonts = {
    gui = 'SauceCodePro Nerd Font Mono:h11'
  }
}

ConfigOptions.lsp = {
  servers = {
    {'lua_ls', {
      cmd = { path.join(path.lsp.lua, 'bin', 'lua-language-server.exe') },
      filetypes = { 'lua' },
      root_markers = {'.luarc.json', '.luarc.jsonc'},
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = {
            globals = { 'vim', 'log', 'class' }
          }
        }
      }
    }},
    {'powershell_es', {
    cmd = {
      ConfigOptions.shell.pwsh,
      '-NoProfile', '-NonInteractive', '-Command',
      '"',
      "'" .. path.join(path.lsp.pses, '/PowerShellEditorServices/Start-EditorServices.ps1') .. "'",
      '-HostName', "'nvim'",
      '-HostProfileId', "'Neovim'",
      '-HostVersion', '0.11.0',
      '-LogPath', "'" .. path.join(path.lsp.logs, 'pses') .. "'",
      '-LogLevel', "'Normal'",
      '-BundledModulesPath', path.lsp.pses,
      '-EnableConsoleRepl',
      '-SessionDetailsPath',
      "'" .. path.join(path.lsp.logs, 'pses', 'pses.jsonc') .."'",
      '-AdditionalModules', '@()',
      '-FeatureFlags', '@()',
      '"',
    },
    filetypes = { 'ps1' },
    root_markers = {'.build.ps1', 'PSScriptAnalyzerSettings.psd1'},
    settings = {
      powershell = {
        codeFormatting = 'OTBS',
      },
    },
    }}
  }
}

return ConfigOptions
