local M = {
  "saghen/blink.cmp",
}

-- use a release tag to download pre-built binaries
M.version = "1.*"
-- AND/OR build from source
-- build = 'cargo build --release',
-- If you use nix, you can build from source with:
-- build = 'nix run .#build-plugin',

M.Lazy = false

M.opts = {

  keymap = { preset = "super-tab" },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "normal",
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    list= {
      selection = {
        preselect = true,
        auto_insert = true
      }
    },
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" }
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require('lspkind').symbol_map[ctx.kind] or ""
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
        },
      },
    },
    documentation = { auto_show = true },
  },

  cmdline = {
    enabled = true,
    keymap = { preset = "inherit" },
    completion = { menu = { auto_show = true } },
  },
  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = {
    preset = "luasnip",
    expand = function(snippet)
      require('luasnip').lsp_expand(snippet)
    end,
    active = function(filter)
      if filter and filter.direction then
        return require('luasnip').jumpable(filter.direction)
      end
      return require('luasnip').in_snippet()
    end,
    jump = function(direction)
      require('luasnip').jump(direction)
    end,
  },
}

return M
