
local Config = require('config')
local class = require('extern.middleclass')
local fs = require('util.fs')
local load = require('util.load')

local LspClient = class('LspClient', Config)

function LspClient:initialize()
  Config.initialize(self)
  self.servers = {}
end

function LspClient:apply()
  self:add_commands()
  self:load_servers()
end

function LspClient:load_servers()
  Logger:debug('Loading LSP Servers')
  local files = fs.find()
  local s, err

  for _, file in ipairs(files) do
    local p = fs.convert_to_module(file)
    Logger:debug('Loading server module %s', p)
    s, err = load:try(p)
    if not s then
      Logger:error('There was an error with an lsp server\n%s', err)
    else
      Logger:info('Configuring LSP Server %s', s.name)
      vim.lsp.config(s.name, s.config)
      vim.lsp.enable(s.name)
      table.insert(self.servers, s.name)
    end
  end
end

--- Disable file-watching: Recommended by neovim if performance is impacted
---@return nil
function LspClient:disable_file_watching()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  if client_capabilities.workspace then client_capabilities.workspace.didChangeWatchedFiles = nil end

  vim.lsp.config('*', { capabilities = client_capabilities })
end

--- Enable file-watching
---@return nil
function LspClient:enable_file_watching()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  if client_capabilities.workspace then client_capabilities.workspace.didChangeWatchedFiles = true end

  vim.lsp.config('*', { capabilities = client_capabilities })
end

--- Create auto commands when the LSP is active
---@return nil
function LspClient:add_commands()
  -- keymap functions
  local cmd = vim.api.nvim_create_autocmd -- (event,opts)
  local set = vim.keymap.set -- (mode, lhs, rhs, opts)
  -- diagnostics
  local diag = vim.diagnostic
  -- LSP
  local lsp = vim.lsp
  local buf = lsp.buf
  local lens = lsp.codelens

  -- Add some additional LSP actions
  cmd({ 'LspAttach' }, {
    desc = 'LSP actions',
    callback = function(event)
      set(
        'n',
        '<F2>',
        function() buf.rename() end,
        { desc = 'Renames all references to the symbol under the cursor', buffer = event.buf }
      )
      set(
        'n',
        'gL',
        function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end,
        { desc = 'Toggle inlay hints', buffer = event.buf }
      )
      set(
        'n',
        'gK',
        function() buf.hover() end,
        { desc = 'Displays hover information', buffer = event.buf }
      )
      set(
        'n',
        'grd',
        function() buf.definition() end,
        { desc = 'Jump to the definition', buffer = event.buf }
      )
      set(
        'n',
        'grD',
        function() buf.declaration() end,
        { desc = 'Jump to declaration', buffer = event.buf }
      )
      set(
        'n',
        'gl',
        function() diag.open_float() end,
        { desc = 'Show diagnostics in a floating window', buffer = event.buf }
      )
      set(
        'n',
        'gL',
        function() lens.enable(not lens.is_enabled()) end,
        { desc = 'Toggle codelens', buffer = event.buf }
      )
      set(
        'n',
        '[d',
        function() diag.goto_prev() end,
        { desc = 'Move to the previous diagnostic', buffer = event.buf }
      )
      set(
        'n',
        ']d',
        function() diag.goto_next() end,
        { desc = 'Move to the next diagnostic', buffer = event.buf }
      )
    end,
  })

  -- Disable diagnostics in insert and select mode
  cmd({ 'ModeChanged' }, {
    pattern = { 'n:i', 'v:s' },
    desc = 'Disable diagnostics in insert and select mode',
    callback = function(_) diag.config({ virtual_text = false }) end,
  })

  -- Enable diagnostics when leaving insert mode
  cmd({ 'ModeChanged' }, {
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function(_) diag.config({ virtual_text = true }) end,
  })
end
return LspClient
