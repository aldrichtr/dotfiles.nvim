local M = {
   'saghen/blink.cmp'
}

-- use a release tag to download pre-built binaries
M.version = '1.*'
-- AND/OR build from source
-- build = 'cargo build --release',
-- If you use nix, you can build from source with:
-- build = 'nix run .#build-plugin',

M.Lazy = false

M.opts = {
   -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
   -- 'super-tab' for mappings similar to vscode (tab to accept)
   -- 'enter' for enter to accept
   -- 'none' for no mappings
   --
   -- All presets have the following mappings:
   -- C-space: Open menu or open docs if already open
   -- C-n/C-p or Up/Down: Select next/previous item
   -- C-e: Hide menu
   -- C-k: Toggle signature help (if signature.enabled = true)
   --
   -- See :h blink-cmp-config-keymap for defining your own keymap
   keymap = { preset = 'super-tab' },

   appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
   },

   -- (Default) Only show the documentation popup when manually triggered
   completion = { documentation = { auto_show = false } },

   cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true }}
   },
   -- Default list of enabled providers defined so that you can extend it
   -- elsewhere in your config, without redefining it, due to `opts_extend`
   sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
   },

   fuzzy = { implementation = "prefer_rust_with_warning" }
}

M.opts_extend = { "sources.default" }

return M
