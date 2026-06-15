
local is = require("util.is")


local M = {
  "folke/snacks.nvim",
}

M.lazy = false

M.priority = 1000

M.init = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end

      -- Override print to use snacks for `:=` command
      if vim.fn.has("nvim-0.11") == 1 then
        vim._print = function(_, ...)
          dd(...)
        end
      else
        vim.print = _G.dd
      end
    end,
  })
end

---@type Snacks.Config
M.opts = {
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
      { section = "startup" },
    },
  },
  explorer = {
    enabled = true,
    replace_netrw = true,
    trash = true
  },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        -- yes, the "double nested layout" is correct
        layout = { layout = { position = 'right' } }
      }
    },
  },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  toggle = {
    enabled = true,
    map = vim.keymap.set,
    which_key = true,
    notify = true,
  },
  words = { enabled = true },
}


return M

