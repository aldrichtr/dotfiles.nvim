---@class LazyPluginSpec
local M = { "hrsh7th/nvim-cmp" }

M.branch = "main"

M.version = false

M.dependencies = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "saadparwaiz1/cmp_luasnip",
}

M.event = { "InsertEnter", "CmdlineEnter" }


function M.opts()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")
  --
  -- When selecting items in the list:
  -- - Insert :: Insert the item into the buffer
  -- - Select :: Select the item but do not insert it
  local select_behavior = cmp.SelectBehavior.Insert

  local select_opts = { behavior = select_behavior }

  -- #region Setup completion for search command
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  -- #endregion

  -- #region Setup completion for command mode
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    matching = {
      disallow_symbol_nonprefix_matching = false,
      disallow_fuzzy_matching = false,
      disallow_partial_fuzzy_matching = false,
      disallow_partial_matching = false,
      disallow_prefix_unmatching = false,
      disallow_fullfuzzy_matching = false,
    },
  })
  -- #endregion

  -- #region Mapping functions
  ---Either select the next item in the completion list, or the next item
  ---in the snippet
  local cmp_next = cmp.mapping(
    function(fallback)
      if cmp.visible() then
        -- cmp.select_next_item()
        return cmp.complete_common_string()
      elseif luasnip.locally_jumpable(1) then
        return luasnip.jump(1)
      else
        return fallback()
      end
    end)

  ---Either select the previous item in the completion list, or the previous item
  ---in the snippet
  local cmp_prev = cmp.mapping(
    function(fallback)
      if cmp.visible() then
        return cmp.select_prev_item(select_opts)
      elseif luasnip.locally_jumpable(-1) then
        return luasnip.jump(-1)
      else
        return fallback()
      end
    end)

  -- Expand or select the current item
  local cmp_select = cmp.mapping(
    function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          return luasnip.expand(nil)
        else
          return cmp.confirm({ select = true })
        end
      else
        return fallback()
      end
    end)
  -- #endregion Mapping functions

  local options = {
    preselect = cmp.PreselectMode.Item,

    completion = { keyword_length = 2 },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    -- TODO: These should be moved to their respective package config files
    sources = cmp.config.sources({ -- group_index 0,
      { name = "lazydev" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, { -- group_index 1
      { name = "buffer" },
    }),

    experimental = {
      ghost_text = false,
    },

    window = {
      documentation = cmp.config.window.bordered({
        border = "rounded",
        winblend = 5,
      }),

      completion = cmp.config.window.bordered({
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
        winblend = 5,
      }),
    },

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = lspkind.cmp_format({
          mode = "symbol_text",
          preset = "default",
          maxwidth = {
            menu = 50,
            abbr = 50,
          },
        })(entry, vim_item)

        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      end, -- end format function
    },

    mapping = cmp.mapping.preset.insert({
      ["<tab>"] = cmp_next,
      ["<down>"] = cmp_next,
      ["<C-n>"] = cmp_next,
      ["<S-tab>"] = cmp_prev,
      ["<up>"] = cmp_prev,
      ["<C-p>"] = cmp_prev,
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<S-Space>"] = cmp.mapping.complete(),
      ["<C-Space>"] = cmp.get_entries(),
      ["<C-c>"] = cmp.mapping.close(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true, }),
      ["<CR>"] = cmp_select,
      ["<C-e>"] = cmp.mapping.abort(),
    }),

    view = {
      entries = {
        name = "custom",
        follow_cursor = true,
      },
    },
  }

  return options
end -- end opts

function M.config()
  local cmp_lsp = require('cmp_nvim_lsp')
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  vim.tbl_deep_extend("force",
  client_capabilities,
  cmp_lsp.default_capabilities())
end

return M
