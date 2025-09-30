-- ---------------------------------------------------------------------------
-- configure neovim User Interface elements
-- ---------------------------------------------------------------------------

---@class UiSetupConfig
local UiSetupConfig = {}

setmetatable( UiSetupConfig, { 
  __index = UiSetupConfig,
  __call = function (self,...) return UiSetupConfig:new(...) end
})

function UiSetupConfig:new(opts)
  local options = opts or {}
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

  -- #region wildmenu
  vim.opt.completeopt = { 'menu', 'menuone' }

  -- Display completion matches in the status line
  vim.opt.wildmenu = true
  -- Use fuzzy search, and a Pop-Up UiSetupConfigenu
  vim.opt.wildoptions = { 'fuzzy', 'pum' }
  -- in list form to the longest match
  vim.opt.wildmode = { 'longest', 'full' }
  vim.opt.wildignorecase = false
  -- #endregion wildmenu

  -- Flash window instead of audible ding
  vim.opt.visualbell = true
  -- Warn on shell commands when buffer modified
  vim.opt.warn = true
  --
  vim.cmd.colorscheme(options.colors.colorscheme)
  -- #region gui options
  vim.opt.termguicolors = true
  vim.opt.background = 'dark'

  vim.opt.winblend = 8
  vim.opt.pumblend = 8

  if vim.g.neovide then
    vim.opt.guifont = options.fonts.gui
    UiSetupConfig.setup_neovide()
  else
    vim.opt.guifont = 'CommitMono Nerd Font Mono:h11'
  end

  -- #endregion gui options

  -- Windows keep this many lines above and below the cursor
  vim.opt.scrolloff = 5

  -- split creates a new window below the current
  vim.opt.splitbelow = true
  -- vsplit creates a new window to the right
  vim.opt.splitright = true

  vim.diagnostic.config({
    float = { border = 'rounded' },
  })
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
end

---Configuration for neovide, a "gui" for neovim
function UiSetupConfig:setup_neovide()
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

  vim.g.neovide_cursor_animate_in_insert_mode = true
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


return UiSetupConfig
