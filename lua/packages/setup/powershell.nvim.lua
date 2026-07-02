
local fs = require('util.fs')
local path = require('config.path')

local M = {
  'TheLeoP/powershell.nvim',
}

M.opts = {
  bundle_path = fs.join(path.mason.packages, 'powershell-editor-services'),
  lsp_log_level = 'Diagnostic',
  settings = {
    powershell = {
      -- Shell
      startAutomatically = true,
      cwd = '${fileDirname}',
      enableProfileLoading = false,
      promptToUpdatePowerShell = false,
      developer = {
        setExecutionPolicy = true,
        waitForSessionFileTimeoutSeconds = 30,
      },
      -- Console
      integratedConsole = {
        focusConsoleOnExecute = true,
        forceClearScrollbackBuffer = true,
        showOnStartup = true,
        startInBackground = false,
        suppressStartupBanner = false,
        useLegacyReadLine = false,
      },
      -- UI Elements
      buttons = {
        showPanelMovementButtons = true,
        showRunButtons = true,
      },
      sideBar = {
        CommandExplorerVisibility = true,
        CommandExplorerExcludeFilter = {},
      },
      enableReferencesCodeLens = true,
      -- Analyzer
      analyzeOpenDocumentsOnly = true,
      scriptAnalysis = {
        enable = true,
        settingsPath = '~/.config/DevKit/pssa/PSScriptAnalyzerSettings.psd1',
      },
      -- Folding
      codeFolding = {
        enable = true,
        showLastLine = false,
      },
      codeFormatting = {
        preset = 'Custom',
        ignoreOneLineBlock = true,
        --   - Braces
        newLineAfterCloseBrace = false,
        newLineAfterOpenBrace = true,
        openBraceOnSameLine = true,
        whitespaceBeforeOpenBrace = true,
        --   - Pipline
        addWhitespaceAroundPipe = true,
        pipelineIndentationStyle = 'IncreaseIndentationAfterEveryPipeline',
        trimWhitespaceAroundPipe = true,
        --   - Properties
        alignPropertyValuePairs = true,
        --   - Syntax checks
        avoidSemicolonsAsLineTerminators = true,
        useConstantStrings = true,
        autoCorrectAliases = true,
        useCorrectCasing = true,
        --   - Trim Whitespace
        whitespaceAfterSeparator = true,
        whitespaceBetweenParameters = true,
        whitespaceInsideBrace = true,
        whitespaceAroundOperator = true,
        whitespaceBeforeOpenParen = true,
      },
      -- Debugging
      debugging = {
        createTemporaryIntegratedConsole = true,
      },

      helpCompletion = 'BlockComment',

      -- Test Cases
      pester = {
        codeLens = true,
        debugOutputVerbosity = 'Detailed',
        outputVerbosity = 'Detailed',
        useLegacyCodeLens = false,
      },
    }, -- powershell
  }, -- settings
}

return M
