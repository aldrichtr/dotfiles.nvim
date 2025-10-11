local M = { 'hrsh7th/nvim-cmp', }

M.branch = 'main'

M.version = false

M.dependencies = {
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'saadparwaiz1/cmp_luasnip',
}

M.event = 'InsertEnter'

M.init = function()
  local cmp = require('cmp')

  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
      local bufmap = function(mode, lhs, rhs, opts)
        opts['buffer'] = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      bufmap('n', 'gK',    function() vim.lsp.buf.hover() end,             { desc = 'Displays hover information about the symbol under the cursor' })
      bufmap('n', 'gd',    function() vim.lsp.buf.definition() end,        { desc = 'Jump to the definition' })
      bufmap('n', 'gD',    function() vim.lsp.buf.declaration() end,       { desc = 'Jump to declaration' })
      bufmap('n', 'gi',    function() vim.lsp.buf.implementation() end,    { desc = 'Lists all the implementations for the symbol under the cursor' })
      bufmap('n', 'go',    function() vim.lsp.buf.type_definition() end,   { desc = 'Jumps to the definition of the type symbol' })
      bufmap('n', 'gr',    function() vim.lsp.buf.references() end,        { desc = 'Lists all the references' })
      bufmap('n', 'gs',    function() vim.lsp.buf.signature_help() end,    { desc = 'Displays a functions signature information' })
      bufmap('n', '<F2>',  function() vim.lsp.buf.rename() end,            { desc = 'Renames all references to the symbol under the cursor' })
      bufmap('n', '<F4>',  function() vim.lsp.buf.code_action() end,       { desc = 'Selects a code action available at the current cursor position' })
      bufmap('n', 'gl',    function() vim.lsp.diagnostic.open_float() end, { desc = 'Show diagnostics in a floating window' })
      bufmap('n', '[d',    function() vim.lsp.diagnostic.goto_prev() end,  { desc = 'Move to the previous diagnostic' })
      bufmap('n', ']d',    function() vim.lsp.diagnostic.goto_next() end,  { desc = 'Move to the next diagnostic' })
    end,
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  })
end

M.opts = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')
  -- When selecting items in the list:
  -- - Insert :: Insert the item into the buffer
  -- - Select :: Select the item but do not insert it
  local select_behavior = cmp.SelectBehavior.Insert

  local select_opts = { behavior = select_behavior }

  ---Either select the next item in the completion list, or the next item
  ---in the snippet
  ---@param fallback any
  local cmp_next = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.locally_jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end, { "i", "s" })

  ---Either select the previous item in the completion list, or the previous item
  ---in the snippet
  ---@param fallback any
  local cmp_prev = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" })

  local cmp_select = cmp.mapping(function(fallback)
    if cmp.visible() then
      if luasnip.expandable() then
        luasnip.expand()
      else
        cmp.confirm({
          select = true,
        })
      end
    else
      fallback()
    end
  end)

  local options = {
    preselect = cmp.PreselectMode.Item,

    completion = { completeopt = 'menu, menuone, preinsert, preview', },

    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },

    -- TODO: These should be moved to their respective package config files
    sources = cmp.config.sources(
      { -- group_index 0,
        { name = 'lazydev' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, { -- group_index 1
        { name = 'buffer' },
      }),

      experimental = {
        ghost_text = false,
      },

      window = {
        documentation = cmp.config.window.bordered({
          border = 'rounded',
          winblend = 5,
        }),

        completion = cmp.config.window.bordered({
          border = 'rounded',
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
          col_offset = -3,
          side_padding = 0,
          winblend = 5,
        }),
      },

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({
            mode = 'symbol_text',
            preset = 'default',
            maxwidth = {
              menu = 50,
              abbr = 50,
            }})(entry, vim_item)

            local strings = vim.split(kind.kind, '%s', { trimempty = true})
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'
            return kind
          end -- end format function
        },

        mapping = cmp.mapping.preset.insert({
          ['<tab>'] = cmp_next,
          ['<down>'] = cmp_next,
          ['<C-n>'] = cmp_next,
          ['<S-tab>'] = cmp_prev,
          ['<up>'] = cmp_prev,
          ['<C-p>'] = cmp_prev,
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<S-Space>'] = cmp.mapping.complete(),
          ['<C-Space>'] = cmp.get_entries(),
          ['<C-c>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = true, }),
          ['<C-e>'] = cmp.mapping.abort()
        }),

        view = {
          entries = {
            follow_cursor = true,
          },
        },
      }

      return options
    end -- end opts

    return M
