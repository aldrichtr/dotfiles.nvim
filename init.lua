
-- <https://github.com/kikito/middleclass/wiki/Quick-Example>
-- Add a new command, `class` using the middleclass library
_G.class = require('extern.middleclass')

-- I downloaded and modified the vlog script.
-- NOTE: I made it global here because it can be used anywhere in the init that I'm having issues

_G.log = require('util.log')

log.debug(string.rep("-",40))
log.debug("- Beginning neovim initialization script")

local path = require('util.path')
-- ------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- #region Shells
if vim.fn.executable('pwsh') == 1 then
  vim.opt.shell = 'pwsh'
elseif vim.fn.executable('powershell') then
  vim.opt.shell = 'powershell'
end
-- These are passed to the shell when running `!` and `:!`
vim.opt.shellcmdflag = table.concat({
  '-NoLogo',
  '-NoProfile',
  '-ExecutionPolicy RemoteSigned',
  '-Command',
  '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();',
  [[$PSDefaultParameterValues['Out-File:Encoding']='utf8';]],
  'Remove-Alias -Force -ErrorAction SilentlyContinue tee;',
}, ' ')
vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''
vim.opt.shellslash = true

vim.g.python3_host_prog = path.join(path.Programs, "Python312", "python.exe")
-- #endregion Shells


vim.o.fileformats = 'unix'
--
-- #region Buffer elements

-- Enable modelines in files
vim.o.modeline = true
-- On the first and last two lines
vim.o.modelines = 2

-- ! use the vscode region markers for folding by default
vim.o.foldmethod = 'marker'
vim.o.foldmarker = '#region,#endregion'

vim.o.number = true -- Show the current line numbers
vim.o.relativenumber = true -- and relative number

vim.o.ruler = true -- Show the cursor position in the status bar
vim.o.cursorline = true -- Highlight the current line
vim.opt.cursorlineopt = { 'number', 'line' }

-- #region spaces and tabs
vim.o.expandtab = true -- Insert spaces instead of tabs
vim.o.smarttab = true  -- Insert spaces according to shift width
vim.o.shiftwidth = 2   -- when shifting lines
vim.o.tabstop = 2      -- how many spaces is a tab worth
vim.o.softtabstop = 2  -- while performing editing

vim.o.list = true -- Show Whitespace
vim.opt.listchars = {
  tab = '>-',
  trail = '·',
}
-- #endregion spaces and tabs
-- #endregion Buffer elements
-- ------------------------------------------------------------------------

-- ------------------------------------------------------------------------
-- #region Editor functions

-- #region search
vim.o.hlsearch = true -- Highlight results of search
vim.o.incsearch = true --  incrementally

vim.o.ignorecase = true -- Ignore case,
vim.o.smartcase = true --  unless there are capitals in the pattern
vim.o.magic = true -- Change the special characters in search patterns
-- #endregion search
-- #endregion Editor functions
-- ------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- configure neovim User Interface elements
-- ---------------------------------------------------------------------------

vim.opt.cmdheight = 2
-- Enable modelines in files
vim.opt.modeline = true
-- On the first and last two lines
vim.opt.modelines = 2

-- Last window status line, 2 = always
vim.opt.laststatus = 2
-- Show (partial) command
vim.opt.showcmd = true
--   On the tabline
vim.opt.showcmdloc = 'tabline'
-- Show the tabline, 2 = always
vim.opt.showtabline = 2

-- #region wildmenu
vim.o.completeopt = 'menu,menuone'

-- Display completion matches in the status line
vim.opt.wildmenu = true
-- Use fuzzy search, and a Pop-Up UiSetupConfigenu
vim.opt.wildoptions = { 'fuzzy', 'pum' }
-- in list form to the longest match
vim.o.wildmode = 'longest:full'
vim.opt.wildignorecase = false
-- #endregion wildmenu

-- Flash window instead of audible ding
vim.opt.visualbell = true
-- Warn on shell commands when buffer modified
vim.opt.warn = true
--
vim.cmd.colorscheme = "darcula-dark"
-- #region gui options
vim.opt.termguicolors = true
vim.opt.background = 'dark'

vim.opt.winblend = 8
vim.opt.pumblend = 8
--
-- #endregion gui options

-- Windows keep this many lines above and below the cursor
vim.opt.scrolloff = 5

-- split creates a new window below the current
vim.opt.splitbelow = true
-- vsplit creates a new window to the right
vim.opt.splitright = true

vim.opt.guifont = {"Lilex Nerd Font", ":h10" }

---Configuration for neovide, a "gui" for neovim
if vim.g.neovide then
  -- g:neovide_transparency should be 0 if you want to unify transparency of
  -- content and title bar.
  vim.g.neovide_opacity = 0.98
  vim.g.transparency = 0.98
  -- How long it takes position animations such as vsplit
  vim.g.neovide_position_animation_length = 0.2
  -- How long it takes for scroll animations to complete (in seconds)
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_hide_mouse_while_typing = true

  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.85

  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.2
  vim.g.neovide_cursor_smooth_blink = true

  -- cursor effects are : 'railgun', 'torpedo', 'pixiedust', 'sonicboom', 'ripple', 'wireframe'
  vim.g.neovide_cursor_vfx_mode = 'railgun'

  vim.g.neovide_cursor_vfx_opacity = 200.0
  -- How long the particles last (seconds)
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.5
  -- The number of generated particles
  vim.g.neovide_cursor_vfx_particle_density = 9.0
  vim.g.neovide_cursor_vfx_particle_speed = 8.0
  -- for railgun, the higher the value the less particles rotate
  vim.g.neovide_cursor_vfx_particle_phase = 2.0
  -- for railgun set the rotation speed
  vim.g.neovide_cursor_vfx_particle_curl = 2.0


  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
end

-- -----------------------------------------------------------------------------
-- Package manager
-- -----------------------------------------------------------------------------

local lazy_opts = {
  root = path.join(path.data, 'lazy'),
  repo = 'https://github.com/folke/lazy.nvim.git',
  -- install lazy.nvim along side other package
  path = path.join(path.data, 'lazy', 'lazy.nvim'),
  check = path.join(path.data, 'lazy', 'lazy.nvim', '.git'),
  spec = {
    { import = 'packages.themes' },
    { import = 'packages.setup'  }
  }
}

-- Bootstrap lazy.nvim
if not path.exists(lazy_opts.check) then
  local out = vim.fn.system({ "git", "clone",
  "--filter=blob:none", "--branch=stable", lazy_opts.repo, lazy_opts.path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazy_opts.path)

require("lazy").setup(
  ---@type LazyConfig
  {
    root = lazy_opts.root,
    spec = lazy_opts.spec,
    checker = {
      enabled = true,
      notify = true,
      change_detection = {
        enabled = true,
        notify = true
      }
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
      enabled = true,
      root = vim.fn.stdpath("state") .. "/lazy/readme",
      files = { "README.md", "lua/**/README.md" },
      -- only generate markdown helptags for plugins that don't have docs
      skip_if_doc_exists = true,
    },
    state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
    -- Enable profiling of lazy.nvim. This will add some overhead,
    -- so only enable this when you are debugging lazy.nvim
    profiling = {
      -- Enables extra stats on the debug tab related to the loader cache.
      -- Additionally gathers stats about all package.loaders
      loader = false,
      -- Track each new require in the Lazy profiling tab
      require = false,
    },
  })

  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- "Global (*)" LSP configuration
  vim.lsp.config("*", { capabilities = client_capabilities })

  local servers = {
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

    powershell_es = {
      name = 'powershell_es',
      config = function()
        local log_path = path.join(path.lsp.logs, name)
        local bundle_path = path.lsp.pses

        local shell = 'pwsh'
        local command_fmt = {
          "%s/PowerShellEditorServices/Start-EditorServices.ps1",
          '-BundledModulesPath', '%s',
          '-LogPath', '%s',
          '-SessionDetailsPath', "'%s/powershell_es.session.json'",
          '-FeatureFlags', '@()',
          '-AdditionalModules',' @()',
          '-HostName', 'nvim',
          '-HostProfileId', '0',
          '-HostVersion', '0.11.4',
          '-Stdio',
          '-LogLevel', 'Normal'
        }

        local command = string.format( table.concat(command_fmt, ' '),
        bundle_path, bundle_path, log_path, log_path)
        local cmd = { shell, '-NoLogo', '-NoProfile', '-Command', command }
        local runner = string.format(table.concat(cmd, ' '))

        return {
          name = "powershell_es",
          shell = 'pwsh',
          cmd = runner,
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
    },
    clojure_lsp = {
      name = 'clojure_lsp',
      config = function()
        return {
          cmd = path.join(vim.env.LOCALAPPDATA, 'lsp', 'clojure', 'bin', 'clojure_lsp.exe'),
          filetypes = { 'clojure', 'edn' },
          root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' }
        }
      end
    },
    lua_ls = {
      name = 'lua_ls',
      config = function()
        return {
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
        }
      end
    },
    cssls = {
      name = "cssls",
      config = function()
        local settings = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
          root_markers = { "package.json", ".git" },
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        }
        return settings
      end
    }
  }


  for _, server in pairs(servers) do
    vim.lsp.config[server.name] = server.config()
    vim.lsp.enable(server.name)
  end


  -- -----------------------------------------------------------------------------

  local create = vim.api.nvim_create_autocmd
  local buf    = vim.lsp.buf
  local diag   = vim.lsp.diagnostic
  --
  -- #region Create an autocmd for when the LSP is started
  local cmds = {
    {{"LspAttach"} ,
    {desc = "LSP actions",
    callback = function()
      local bufmap = function(mode, lhs, rhs, opts)
        opts["buffer"] = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end
      bufmap("n", "gK", function() buf.hover() end, { desc = "Displays hover information about the symbol under the cursor" })
      bufmap("n", "gd", function() buf.definition() end, { desc = "Jump to the definition" })
      bufmap("n", "gD", function() buf.declaration() end, { desc = "Jump to declaration" })
      bufmap("n", "gi", function() buf.implementation() end, { desc = "Lists all the implementations for the symbol under the cursor" })
      bufmap("n", "go", function() buf.type_definition() end, { desc = "Jumps to the definition of the type symbol" })
      bufmap("n", "gr", function() buf.references() end, { desc = "Lists all the references" })
      bufmap("n", "gs", function() buf.signature_help() end, { desc = "Displays a functions signature information" })
      bufmap("n", "<F2>", function() buf.rename() end, { desc = "Renames all references to the symbol under the cursor" })
      bufmap("n", "<F4>", function() buf.code_action() end, { desc = "Selects a code action available at the current cursor position" })
      bufmap("n", "gl", function() diag.open_float() end, { desc = "Show diagnostics in a floating window" })
      bufmap("n", "[d", function() diag.goto_prev() end, { desc = "Move to the previous diagnostic" })
      bufmap("n", "]d", function() diag.goto_next() end, { desc = "Move to the next diagnostic" })
    end,
  }},
  {{'BufWritePre' },
  {pattern = { '*' }, desc = 'Remove trailing whitespace on save', command = [[%s/\s\+$//e]] }, },
  {{'ModeChanged' },
  {pattern = { 'n:i', 'v:s' },
  desc = 'Disable diagnostics in insert and select mode',
  callback = function() vim.diagnostic.config({ virtual_text = false }) end, }, },
  {{'ModeChanged' },
  {pattern = 'i:n',
  desc = 'Enable diagnostics when leaving insert mode',
  callback = function(e) vim.diagnostic.config({ virtual_text = true }) end, }, },
  {{'FileType' },
  {desc = 'Close help, quickfix, netrw, etc. windows with q',
  pattern = 'help,qf,netrw',
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, desc = 'Quit help, quickfix, netrw, etc. windows' })
  end}}
}

for _, cmd in pairs(cmds) do
  create(cmd[1], cmd[2])
end


vim.api.nvim_create_user_command('DisablePlugin',
  function(opts)
    local name = opts.fargs[1]
    local k = path.join(path.lua, 'packages')
    local s = path.join(k, 'setup', name .. ".lua")
    local d = path.join(k, 'disabled', name .. ".lua")
    if path.exists(s) and not path.exists(d) then
      os.rename(s,d)
    end
  end, {nargs = 1})

vim.api.nvim_create_user_command('EnablePlugin',
  function(opts)
    local name = opts.fargs[1]
    local k = path.join(path.lua, 'packages')
    local s = path.join(k, 'setup', name .. ".lua")
    local d = path.join(k, 'disabled', name .. ".lua")
    if path.exists(d) and not path.exists(s) then
      os.rename(d,s)
    end
  end, {nargs = 1})

-- Keybindings for neovim.  Requires whichkey.

-- #region which-key wk.Spec
--[[
- [1]: (string) lhs (required)
- [2]: (string|fun()) rhs (optional): when present, it will create the mapping
- desc: (string|fun():string) description (required for non-groups)
- group: (string|fun():string) group name (optional)
- mode: (string|string[]) mode (optional, defaults to "n")
- cond: (boolean|fun():boolean) condition to enable the mapping (optional)
- hidden: (boolean) hide the mapping (optional)
- icon: (string|wk.Icon|fun():(wk.Icon|string)) icon spec (optional)
- proxy: (string) proxy to another mapping (optional)
- expand: (fun():wk.Spec) nested mappings (optional)
- any other option valid for vim.keymap.set. These are only used for creating mappings.
When desc, group, or icon are functions, they are evaluated every time the popup is shown.

The expand property allows to create dynamic mappings. Only functions as rhs are supported for dynamic mappings.
]] --
-- #endregion which-key wk.Spec






local whichkey = require('which-key')
local builtin = require('telescope.builtin')
local t_utils = require('telescope.utils')
local ufo = require('ufo')
local conform = require('conform')
-- ----------------------------------------------------------------------------------------------------------------
-- Mappings start here
whichkey.add({
  -- #region "Global" keys
  {
    mode = { 'n', 'i', 'v' },
    { '<C-S-]>', '<cmd>Neotree toggle<cr>', desc = 'Toggle the Neotree window' },
    { '<C-S-[>', '<cmd>AerialToggle<cr>', desc = 'Toggle the Aerial window' },
  }, -- #endregion "Global" keys
  -- #region normal mode bindings
  {
    mode = { 'n' },
    -- #region General
    { 'K', 'kJ', desc = 'Join this line with previous line' },
    {
      'Y',
      'y$',
      desc = 'Map Y to yank until EOL, rather than act as yy',
    },

    { '<A-Down>', '<cmd>move +1<cr>==', desc = 'Move line down' },
    { '<A-Up>', '<cmd>move -2<cr>==', desc = 'Move line up' },
    { '<A-S-Down>', 'yyp', desc = 'Copy line down' },
    { '<A-S-Up>', 'yyp<cmd>move +1<cr>', desc = 'Copy line up' },

    {
      '<C-L>',
      '<cmd>nohl<CR><C-L>',
      desc = 'redraw screen and turn off search highlighting',
    },

    { '<C-S-v>', '"*p', desc = 'Paste from system clipboard' },
    -- #endregion General

    -- #region <leader> Leader key operations
    -- #region <leader> - Top level
    { '<leader>?', function() whichkey.show({ global = true }) end, desc = 'Show available keys' },
    {
      '<leader>=',
      function() conform.format({ async = true, lsp_format = 'fallback' }) end,
      desc = 'Format document (conform)',
    },
    -- #endregion <leader> - Top level
    -- #region <leader>digit - Switching windows
    -- #endregion <leader>digit - Switching windows

    -- #region <leader><leader> - Harpoon

    -- #endregion <leader><leader> - Harpoon

    -- #region <leader>! - Todo comments
    { '<leader>!', group = 'Todo comments' },
    { '<leader>!n', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
    { '<leader>!p', function() require('todo-comments').jump_prev() end, desc = 'Previous todo comment' },
    -- #endregion <leader>! - Todo comments

    -- #region <leader>a - Unused
    -- #endregion <leader>a - Unused

    -- #region <leader>b - buffer operations
    -- #region <leader>c - Unused
    -- #endregion <leader>c - Unused

    -- #region <leader>d - Unused
    -- #endregion <leader>d - Unused

    -- #region <leader>e - Unused
    -- #endregion <leader>e - Unused

    -- #region <leader>f - File operations
    { '<leader>f', group = 'Files' },
    {
      '<leader>ff',
      function() builtin.find_files({ cwd = t_utils.buffer_dir() }) end,
      desc = 'select from files in current directory',
    },
    -- #endregion <leader>f - File operations

    -- #region <leader>g - git commands (Neogit)
    { '<leader>g', group = 'Git' },
    { '<leader>gd', '<cmd>Neogit diff<cr>', desc = 'Git diff view' },
    { '<leader>gl', '<cmd>Neogit log<cr>', desc = 'Git log view' },
    -- #endregion <leader>g - git commands (Neogit)

    -- #region <leader>h - Unused
    -- #endregion <leader>h - Unused

    -- #region <leader>i - Unused
    -- #endregion <leader>i - Unused

    -- #region <leader>j - Unused
    -- #endregion <leader>j - Unused

    -- #region <leader>k - Unused
    -- #endregion <leader>k - Unused

    -- #region <leader>l - Unused
    -- #endregion <leader>l - Unused

    -- #region <leader>m - Unused
    -- #endregion <leader>m - Unused

    -- #region <leader>n - Unused
    -- #endregion <leader>n - Unused

    -- #region <leader>o - Unused
    -- #endregion <leader>o - Unused

    -- #region <leader>p - Unused
    -- #endregion <leader>p - Unused

    -- #region <leader>q - Unused
    -- #endregion <leader>q - Unused

    -- #region <leader>r - Unused
    -- #endregion <leader>r - Unused

    -- #region <leader>s - Search operations
    { '<leader>s', group = 'Search' },
    { '<leader>sb', function() builtin.buffers() end, desc = 'Search for buffers in current tab' },
    { '<leader>sB', '<cmd>Telescope scope buffers<CR>', desc = 'Search for buffers in current tab' },
    {
      '<leader>sc',
      function() builtin.find_files({ cwd = path.config }) end,
      desc = 'Search for files in the nvim config directory',
    },
    {
      '<leader>sd',
      function() builtin.find_files({ cwd = path.dotfiles }) end,
      desc = 'Search for files in the dotfiles directory',
    },
    { '<leader>sg', function() builtin.live_grep() end, desc = 'select from grep results in the current file' },
    { '<leader>sh', function() builtin.help_tags() end, desc = 'Search for help tags' },
    { '<leader>sk', function() builtin.keymaps() end, desc = 'Search for keymaps' },
    { '<leader>sm', '<cmd>Telescope harpoon marks<cmd>', desc = 'Select from harpoon marks' },
    {
      '<leader>sp',
      function() require('telescope').extensions.projects.projects({}) end,
      desc = 'Search for projects',
    },
    { '<leader>sS', '<cmd>Telescope aerial<cmd>', desc = 'Select from symbol (aerial)' },
    { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Search for Todo comments in the current directory' },
    {
      '<leader>sw',
      function()
        local word = vim.fn.expand('<cword>')
        builtin.grep_string({ search = word })
      end,
      desc = 'Search for the word under cursor',
    },
    {
      '<leader>sW',
      function()
        local word = vim.fn.expand('<cWORD>')
        builtin.grep_string({ search = word })
      end,
      desc = 'Search for the WORD under cursor',
    },
    -- #endregion <leader>s - Search operations

    -- #region <leader>t - Tab operations
    { '<leader>t', group = 'Tab operations' },
    { '<leader>ta', '<cmd>tabnew<cr>', desc = 'Add a new tab' },
    --
    { '<leader>tc', group = 'Close tab' },
    { '<leader>tcc', '<cmd>tabclose<cr>', desc = 'Close the current tab' },
    { '<leader>tcn', '<cmd>+tabclose<cr>', desc = 'Close the next tab' },
    { '<leader>tcp', '<cmd>-tabclose<cr>', desc = 'Close the previous tab' },
    { '<leader>tco', '<cmd>tabonly<cr>', desc = 'Close all other tabs' },
    { '<leader>tq', '<cmd>tabclose<cr>', desc = 'Close the current tab' },
    --
    { '<leader>tm', group = 'Move tab' },
    { '<leader>tm^', '<cmd>0tabmove<cr>', desc = 'Move tab to beginning' },
    { '<leader>tm$', '<cmd>$tabmove<cr>', desc = 'Move tab to end' },
    { '<leader>tmp', '<cmd>-tabmove<cr>', desc = 'Move tab left' },
    { '<leader>tmn', '<cmd>+tabmove<cr>', desc = 'Move tab right' },
    --
    { '<leader>t^', '<cmd>tabfirst<cr>', desc = 'Focus on first tab' },
    { '<leader>tn', '<cmd>tabnext<cr>', desc = 'Focus on next tab' },
    { '<leader>tp', '<cmd>tabprev<cr>', desc = 'Focus on previous tab' },
    { '<leader>t$', '<cmd>tablast<cr>', desc = 'Focus on last tab' },

    { '<leader>tr', '<cmd>BufferLineTabRename<cr>', desc = 'Rename the current tab' },
    -- #endregion <leader>t - Tab operations

    -- #region <leader>T - Terminal operations
    { '<leader>T', group = 'Terminal operations' },
    -- #endregion <leader>T - Terminal operations
    -- #region <leader>u - Unused
    -- #endregion <leader>u - Unused

    -- #region <leader>v - View application components
    { '<leader>v', group = 'View application components' },
    { '<leader>vd', '<cmd>Dashboard<CR>', desc = 'View the dashboard' },
    {
      '<leader>ve',
      '<cmd>Neotree reveal position=right source=filesystem dir=%:h<CR>',
      desc = 'Reveal the filesystem explorer window',
    },
    {
      '<leader>vg',
      '<cmd>Neotree reveal position=float source=git_status<CR>',
      desc = 'View the git status in a floating window',
    },
    { '<leader>vk', function() whichkey.show({ global = true }) end, desc = 'Show keybindings' },
    { '<leader>vl', '<cmd>Lazy<cr>', desc = 'Lazy package manager console' },
    { '<leader>vn', function() utils.toggle_numbers() end, desc = 'Toggle relative line numbers' },
    { '<leader>vo', '<cmd>AerialToggle!<CR>', desc = 'Toggle the code outline' },
    -- #endregion <leader>v - View application components

    -- #region <leader>w - Window operations
    { '<leader>w', group = 'Windows operations', proxy = '<c-w>' },
    -- #endregion <leader>w - Window operations

    -- #region <leader>x - Diagnostics
    { '<leader>x', group = 'Diagnostics' },
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    {
      '<leader>xl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    -- #endregion <leader>x - Diagnostics

    -- #region <leader>y - Unused
    -- #endregion <leader>y - Unused

    -- #region <leader>z - Unused
    -- #endregion <leader>z - Unused

    -- #endregion <leader> Leader key operations

    -- #region z - Fold commands
    { 'z', group = 'Folding operations' },
    { 'zM', function() ufo.closeAllFolds() end, desc = 'Close all folds with UFO' },
    { 'zR', function() ufo.openAllFolds() end, desc = 'Open all folds with UFO' },
    -- #endregion z - Fold commands
  }, -- #endregion normal mode bindings

  -- #region visual mode bindings
  {
    mode = { 'v' },
    -- #region General
    { '<A-Down>', '<cmd>move >+1<cr>gv=gv', desc = 'Move line down' },
    { '<A-Up>', '<cmd>move <-2<cr>gv=gv', desc = 'Move line up' },
    { '<A-S-Down>', 'ypgv=gv', desc = 'Copy line down' },
    { '<A-S-Up>', 'y<cmd>move >+1<cr>pgv=gv', desc = 'Copy line up' },
    -- #endregion General

    -- #region <leader>T Terminal operations
    { '<leader>T', group = 'Terminal operations' },
    {
      '<leader>Te',
      function()
        local tterm = require('toggleterm')
        local trim_spaces = true
        tterm.send_lines_to_terminal('visual_selection', trim_spaces, { args = vim.v.count })
      end,
      desc = 'Execute selection in terminal',
    },

    -- #endregion <leader>T Terminal operations
  },
  -- #endregion visual mode bindings

  -- #region insert mode bindings
  {
    mode = { 'i' },
    { '<A-Down>', '<cmd>move .+1<cr><esc>==gi', desc = 'Move line down' },
    { '<A-Up>', '<cmd>move .-2<cr><esc>==gi', desc = 'Move line up' },
    { '<A-S-Down>', '<Esc>yypi', desc = 'Copy line down' },
    { '<A-S-Up>', 'yy<cmd>move >+1<cr>pgv=gv', desc = 'Copy line up' },
    { '<C-S-v>', '<C-r>*p', desc = 'Paste from the system clipboard' },
  },
  -- #endregion insert mode bindings
})






-- ----------------------------------------------------------------------------------------------------------------
-- #endregion Setup new keymaps (with which-key)
