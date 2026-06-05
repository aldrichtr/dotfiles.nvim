
local M = {}

function M.setup()
	Logger:info("Setting up Editor elements")
  vim.o.fileformats = 'unix'

  -- SECTION Buffer elements

  -- Enable modelines in files
  vim.o.modeline = true
  -- On the first and last two lines
  vim.o.modelines = 2

  -- ! use the vscode region markers for folding by default
  vim.o.foldmethod = 'marker'
  vim.o.foldmarker = 'SECTION,!SECTION'

  vim.o.number = true -- Show the current line numbers
  vim.o.relativenumber = true -- and relative number

  vim.o.ruler = true -- Show the cursor position in the status bar
  vim.o.cursorline = true -- Highlight the current line
  vim.opt.cursorlineopt = { 'number', 'line' }

  -- SECTION spaces and tabs
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
  -- !SECTION spaces and tabs
  -- !SECTION Buffer elements

  -- SECTION Editor functions

  -- SECTION search
  vim.o.hlsearch = true -- Highlight results of search
  vim.o.incsearch = true --  incrementally

  vim.o.ignorecase = true -- Ignore case,
  vim.o.smartcase = true --  unless there are capitals in the pattern
  vim.o.magic = true -- Change the special characters in search patterns
  -- !SECTION search
  -- !SECTION Editor functions

  -- SECTION UI Elements
	Logger:info("Setting up UI elements")
  -- Set the hight of the command area
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

  -- SECTION wildmenu
  vim.o.completeopt = 'menu,menuone'

  -- Display completion matches in the status line
  vim.opt.wildmenu = true
  -- Use fuzzy search, and a Pop-Up
  vim.opt.wildoptions = { 'fuzzy', 'pum' }
  -- in list form to the longest match
  vim.o.wildmode = 'longest:full'
  vim.opt.wildignorecase = false
  -- !SECTION wildmenu

  -- Flash window instead of audible ding
  vim.opt.visualbell = true
  -- Warn on shell commands when buffer modified
  vim.opt.warn = true
  --
  vim.cmd.colorscheme("darcula-dark")

  -- SECTION gui options
  vim.opt.termguicolors = true
  vim.opt.background = 'dark'

  vim.opt.winblend = 8
  vim.opt.pumblend = 8

  vim.opt.guifont = "AtkynsonMono\\ NF:h12"

  if vim.g.neovide then M.setup_neovide() end
  -- !SECTION

  -- Windows keep this many lines above and below the cursor
  vim.opt.scrolloff = 5

  -- split creates a new window below the current
  vim.opt.splitbelow = true
  -- vsplit creates a new window to the right
  vim.opt.splitright = true

  -- !SECTION

  require('config.setup.lsp').setup()
  require('config.setup.keybindings').setup()
  require('config.setup.autocmds').setup()
end

---Configuration for neovide, a "gui" for neovim
function M.setup_neovide()
  -- g:neovide_transparency should be 0 if you want to unify transparency of
  -- content and title bar.
  vim.g.neovide_opacity = 0.95
  vim.g.transparency = 0.95
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


return M
