local luals = {}
luals.__index

function luals.setup()
  local cmp_lsp = require('cmp_nvim_lsp')
  local file_ops = require('lsp-file-operations')

  vim.lsp.config['luals']({
    cmd = { vim.fs.joinpath(vim.env.LOCALAPPDATA, 'lsp', 'lua', 'bin', 'lua-language-server.exe') },
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities(),
      file_ops.default_capabilities()
    ),

    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = true,
          library = {
            vim.env.VIMRUNTIME
          },
        },
        completion = {
          enable = true,
          keywordSnippet = 'Both',
          requireSeparator = '.',
          showParams = true
    },
      })
    end, -- end on_init
  })
end -- end luals.setup

return luals
